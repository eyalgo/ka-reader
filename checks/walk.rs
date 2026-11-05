//! The in-process walk `checks/read-only.sh` consumes.
//!
//! Folder mode, taken when the first argument is an absolute path: open that folder, then call
//! `list_tree` on its root and on every entry it returns, descending only into folders, and call
//! `select_file` once on each file entry a `list_tree` answer returns. Then it calls `read_git` once
//! on a model of the folder, through the libgit2 adapter, which asks the Git port `probe`, and, only
//! where `probe` says `Root`, `state` and `status`. The answer is dropped and none stops the walk.
//! It prints the number of `list_tree` calls it made, never anything a `select_file` or a Git answer
//! carries, and exits 0 once the walk is complete, or non-zero when the folder did not open.
//!
//! The same walk also drives the model's own operations over the folder, through `FolderModel`:
//! `TreeRequest::Expand` on every folder the tree listed, `FileRequest::Select` on every file,
//! `TreeRequest::Invalidate` with a report naming the root and every folder, then
//! `TreeRequest::Collapse` on every folder. None of them writes.
//!
//! Long mode, taken when the second argument is `--long`: the same pass, then one line on stdout
//! that is exactly `pass-complete`, then the same pass again for as long as the process lives. It
//! never exits on its own; `checks/read-only.sh --kill` ends it with `SIGKILL` after the marker.
//!
//! No-argument mode, taken for any other argument too (a libtest filter is not a folder): walk the
//! committed fixtures, and exit 0 when both walks complete, each root lists at least one entry, and
//! every file entry a walk listed got exactly one `select_file` call and no other path got one. The
//! judge that decides this runs first on hand-built tallies it must refuse.
//!
//! Its own source installs no logger, writes nothing, starts no process and reads no environment
//! variable, and its only input is its argument list. That is a claim about this file: the Git
//! adapter's libgit2 reads `HOME` and the XDG variables in-process (`checks/entry-points.allow`).

use std::collections::{BTreeMap, BTreeSet, HashSet};
use std::io::Write;
use std::path::{Path, PathBuf};
use std::thread::sleep;
use std::time::Duration;

use ka_reader_core::{
    EntryKind, FileRequest, FolderModel, ItemState, Libgit2, OpenedFolder, PathReports,
    TreeRequest, list_tree, open_folder, read_git, select_file,
};

/// The one line long mode prints, after its first completed pass.
const PASS_COMPLETE_MARKER: &str = "pass-complete";

/// The second argument that selects long mode.
const LONG_MODE_ARGUMENT: &str = "--long";

/// How long long mode rests between passes, so a process waiting to be killed does not spin.
const PASS_PAUSE: Duration = Duration::from_millis(50);

/// What a fixture's walk is held to beyond the coverage judge.
type FixtureCheck = fn(&Walk) -> Result<(), String>;

/// The committed fixtures the no-argument mode walks, each with what it holds that walk to beyond
/// the coverage judge.
const FIXTURES: [(&str, FixtureCheck); 2] = [("plain", check_plain), ("repo", check_repo)];

/// The `list_tree` calls the `plain` fixture takes: its root, three folders and five file entries.
const PLAIN_LIST_TREE_CALLS: usize = 9;

/// The file entries of the `plain` fixture, as the walk lists them.
const PLAIN_FILE_ENTRIES: [&str; 5] = [
    "readme.txt",
    ".hidden-note",
    "outside-link",
    "docs/guides/intro.txt",
    "docs/guides/deep/leaf.txt",
];

/// The file entries of the `repo` fixture that its committed tree holds whether or not `.git` has
/// been restored beside them.
const REPO_TREE_FILE_ENTRIES: [&str; 3] = ["README.md", "src/main.rs", "src/deep/leaf.txt"];

/// How many times a walk drove each model operation. Each count is raised at the one site its
/// operation goes through, so the tally is the walk's own record and nothing is derived from it.
#[derive(Debug, Default, Clone, Copy)]
struct Acts {
    expand: usize,
    collapse: usize,
    invalidate: usize,
    select: usize,
}

/// One walk's outcome: how many `list_tree` calls it made, whether the root listed entries, the
/// two tallies the coverage judge compares, and the model operations it drove. They are fed from
/// different places and neither is derived from the other.
struct Walk {
    calls: usize,
    root_has_entries: bool,
    acts: Acts,
    /// The path of every file entry a `list_tree` answer returned.
    listed_files: BTreeSet<String>,
    /// The number of `select_file` calls made at each path.
    selected: BTreeMap<String, usize>,
}

/// Reads the file at `path` and counts the call. This is the one site every `select_file` call goes
/// through. The answer is dropped: the proof is that the folder is unchanged afterwards, whatever
/// the file reads as, so no answer stops the walk or reaches stdout.
fn select_counted(opened: &OpenedFolder, path: &str, selected: &mut BTreeMap<String, usize>) {
    *selected.entry(path.to_string()).or_insert(0) += 1;
    select_file(opened, path);
}

/// Calls `list_tree` on `path`, then on each entry it returns. A folder entry is walked in turn, and
/// every other entry is listed once and not descended, then read once with `select_file`. A failed
/// answer stops nothing: it has no entries to go on to. No path is listed twice, so folder links that reach each other end.
fn walk_from(
    opened: &OpenedFolder,
    path: &str,
    listed: &mut HashSet<String>,
    calls: &mut usize,
    listed_files: &mut BTreeSet<String>,
    listed_folders: &mut BTreeSet<String>,
    selected: &mut BTreeMap<String, usize>,
) -> bool {
    if !listed.insert(path.to_string()) {
        return false;
    }
    *calls += 1;
    let ItemState::Observed(entries) = list_tree(opened, path) else {
        return false;
    };
    for entry in &entries {
        match entry.kind {
            EntryKind::Folder => {
                listed_folders.insert(entry.path.clone());
                walk_from(
                    opened,
                    &entry.path,
                    listed,
                    calls,
                    listed_files,
                    listed_folders,
                    selected,
                );
            }
            EntryKind::File => {
                listed_files.insert(entry.path.clone());
                if listed.insert(entry.path.clone()) {
                    *calls += 1;
                    list_tree(opened, &entry.path);
                    select_counted(opened, &entry.path, selected);
                }
            }
        }
    }
    !entries.is_empty()
}

/// The model's own operations, driven and counted. Each count is raised in the one method its
/// operation goes through.
struct Driven {
    model: FolderModel,
    acts: Acts,
}

impl Driven {
    fn expand(&mut self, path: &str) {
        self.acts.expand += 1;
        self.apply_tree(TreeRequest::Expand(PathBuf::from(path)));
    }

    fn collapse(&mut self, path: &str) {
        self.acts.collapse += 1;
        self.apply_tree(TreeRequest::Collapse(PathBuf::from(path)));
    }

    /// Reports every path in `paths` as possibly changed, once, as one batch.
    fn invalidate(&mut self, paths: Vec<PathBuf>) {
        self.acts.invalidate += 1;
        self.apply_tree(TreeRequest::Invalidate(PathReports::new(paths)));
    }

    fn select(&mut self, path: &str) {
        self.acts.select += 1;
        let model = std::mem::replace(&mut self.model, placeholder());
        self.model = model.select_file(FileRequest::Select(Some(PathBuf::from(path))));
    }

    fn apply_tree(&mut self, request: TreeRequest) {
        let model = std::mem::replace(&mut self.model, placeholder());
        self.model = model.list_tree(request);
    }
}

/// A model of the system's temporary folder, held for the instant `Driven` moves its own model
/// through an operation that takes it by value. It is never read.
fn placeholder() -> FolderModel {
    FolderModel::new(open_folder(std::env::temp_dir()).expect("the temporary folder opens"))
}

/// Drives `Expand` on every folder, `Select` on every file, `Invalidate` with the root and every
/// folder reported, then `Collapse` on every folder, over `folder`. The fixture is only read.
fn drive_model(folder: &Path, folders: &BTreeSet<String>, files: &BTreeSet<String>) -> Acts {
    let opened = open_folder(folder).expect("the folder that was just walked opens");
    let root = opened.root().to_path_buf();
    let mut driven = Driven {
        model: FolderModel::new(opened),
        acts: Acts::default(),
    };
    for path in folders {
        driven.expand(path);
    }
    for path in files {
        driven.select(path);
    }
    let mut reports = vec![root.clone()];
    reports.extend(folders.iter().map(|path| root.join(path)));
    driven.invalidate(reports);
    for path in folders {
        driven.collapse(path);
    }
    driven.acts
}

fn walk_folder(folder: &Path) -> Option<Walk> {
    let opened = open_folder(folder).expect("the read-only fixture opens");
    let mut calls = 0;
    let mut listed = HashSet::new();
    let mut listed_files = BTreeSet::new();
    let mut listed_folders = BTreeSet::new();
    let mut selected = BTreeMap::new();
    let root_has_entries = walk_from(
        &opened,
        "",
        &mut listed,
        &mut calls,
        &mut listed_files,
        &mut listed_folders,
        &mut selected,
    );
    let acts = drive_model(folder, &listed_folders, &listed_files);
    Some(Walk {
        calls,
        root_has_entries,
        acts,
        listed_files,
        selected,
    })
}

/// Judges the two tallies of one walk. Every listed file entry must have exactly one `select_file`
/// call, and no path that was not listed as a file entry (a folder path, a stray path) may have one.
/// The `Err` names the first offending path in path order.
fn judge_coverage(
    listed_files: &BTreeSet<String>,
    selected: &BTreeMap<String, usize>,
) -> Result<(), String> {
    for path in listed_files {
        match selected.get(path).copied().unwrap_or(0) {
            1 => {}
            count => {
                return Err(format!(
                    "file entry {path} got {count} select_file calls, expected 1"
                ));
            }
        }
    }
    for path in selected.keys() {
        if !listed_files.contains(path) {
            return Err(format!(
                "select_file was called on {path}, which the walk did not list as a file entry"
            ));
        }
    }
    Ok(())
}

/// Judges the model operations one walk drove: each of `Expand`, `Collapse`, `Invalidate` and
/// `Select` must have been reached at least once (QC-2's reviewed half). The `Err` names the first
/// operation the walk never reached.
fn judge_acts(acts: &Acts) -> Result<(), String> {
    let reached = [
        ("TreeRequest::Expand", acts.expand),
        ("TreeRequest::Collapse", acts.collapse),
        ("TreeRequest::Invalidate", acts.invalidate),
        ("FileRequest::Select", acts.select),
    ];
    match reached.iter().find(|(_, count)| *count == 0) {
        Some((name, _)) => Err(format!("the walk never reached {name}")),
        None => Ok(()),
    }
}

fn judge_accepts_every_act_reached() -> Result<(), String> {
    let acts = Acts {
        expand: 1,
        collapse: 1,
        invalidate: 1,
        select: 1,
    };
    judge_acts(&acts)
        .map_err(|message| format!("a walk that reached every act was refused: {message}"))
}

/// A tally missing one act, which the judge must refuse by naming it.
fn judge_refuses_a_missing_act(missing: &str, acts: Acts) -> Result<(), String> {
    match judge_acts(&acts) {
        Ok(()) => Err(format!(
            "the judge accepted a walk that never reached {missing}"
        )),
        Err(message) if message.contains(missing) => Ok(()),
        Err(message) => Err(format!(
            "the judge refused a missing {missing} without naming it: {message}"
        )),
    }
}

fn judge_refuses_every_act_left_out() -> Result<(), String> {
    let all = Acts {
        expand: 1,
        collapse: 1,
        invalidate: 1,
        select: 1,
    };
    judge_refuses_a_missing_act("Expand", Acts { expand: 0, ..all })?;
    judge_refuses_a_missing_act("Collapse", Acts { collapse: 0, ..all })?;
    judge_refuses_a_missing_act(
        "Invalidate",
        Acts {
            invalidate: 0,
            ..all
        },
    )?;
    judge_refuses_a_missing_act("Select", Acts { select: 0, ..all })
}

fn tally<const N: usize>(
    listed: [&str; N],
    selected: &[(&str, usize)],
) -> (BTreeSet<String>, BTreeMap<String, usize>) {
    (
        listed.iter().map(|path| path.to_string()).collect(),
        selected
            .iter()
            .map(|(path, count)| (path.to_string(), *count))
            .collect(),
    )
}

fn judge_accepts_every_listed_file_selected_once() -> Result<(), String> {
    let (listed, selected) = tally(["a.txt", "docs/b.txt"], &[("a.txt", 1), ("docs/b.txt", 1)]);
    judge_coverage(&listed, &selected).map_err(|message| {
        format!("a walk that selected each listed file once was refused: {message}")
    })
}

/// A hand-built tally pair the judge must refuse, with the path its message must name.
fn refused_naming(
    case: &str,
    pair: (BTreeSet<String>, BTreeMap<String, usize>),
    path: &str,
) -> Result<(), String> {
    match judge_coverage(&pair.0, &pair.1) {
        Ok(()) => Err(format!("the judge accepted {case}")),
        Err(message) if message.contains(path) => Ok(()),
        Err(message) => Err(format!(
            "the judge refused {case} without naming {path}: {message}"
        )),
    }
}

fn judge_refuses_a_listed_file_never_selected() -> Result<(), String> {
    refused_naming(
        "a listed file never selected",
        tally(["a.txt", "skipped.txt"], &[("a.txt", 1)]),
        "skipped.txt",
    )
}

fn judge_refuses_a_listed_file_selected_twice() -> Result<(), String> {
    refused_naming(
        "a listed file selected twice",
        tally(
            ["a.txt", "doubled.txt"],
            &[("a.txt", 1), ("doubled.txt", 2)],
        ),
        "doubled.txt",
    )
}

fn judge_refuses_a_selected_path_never_listed() -> Result<(), String> {
    refused_naming(
        "a selected path that was never listed",
        tally(["a.txt"], &[("a.txt", 1), ("docs", 1)]),
        "docs",
    )
}

/// Runs the judge on tallies built by hand, so every no-argument run shows that it accepts the walk
/// CP-327 wants and refuses the three it forbids.
fn judge_self_check() -> Result<(), String> {
    judge_accepts_every_listed_file_selected_once()?;
    judge_refuses_a_listed_file_never_selected()?;
    judge_refuses_a_listed_file_selected_twice()?;
    judge_refuses_a_selected_path_never_listed()?;
    judge_accepts_every_act_reached()?;
    judge_refuses_every_act_left_out()
}

fn fixture_path(name: &str) -> PathBuf {
    PathBuf::from(env!("CARGO_MANIFEST_DIR"))
        .join("../../checks/fixtures")
        .join(name)
}

/// Walks one committed fixture and holds it to condition (a), that its root lists an entry, to the
/// judge, which counts whatever file entries the walk listed, and to `extra`.
fn check_fixture(name: &str, extra: FixtureCheck) -> Result<(), String> {
    let walk = walk_folder(&fixture_path(name))
        .ok_or_else(|| format!("fixture {name} did not open as a folder"))?;
    if !walk.root_has_entries {
        return Err(format!("fixture {name} listed no entries at its root"));
    }
    judge_coverage(&walk.listed_files, &walk.selected)
        .map_err(|message| format!("fixture {name}: {message}"))?;
    judge_acts(&walk.acts).map_err(|message| format!("fixture {name}: {message}"))?;
    extra(&walk)
}

/// Holds the `plain` walk to the file entries and the call count the fixture is known to have.
fn check_plain(walk: &Walk) -> Result<(), String> {
    let expected: BTreeSet<String> = PLAIN_FILE_ENTRIES
        .iter()
        .map(|path| path.to_string())
        .collect();
    if walk.listed_files != expected {
        return Err(format!(
            "fixture plain listed {:?} as file entries, expected {expected:?}",
            walk.listed_files
        ));
    }
    if walk.calls != PLAIN_LIST_TREE_CALLS {
        return Err(format!(
            "fixture plain took {} list_tree calls, expected {PLAIN_LIST_TREE_CALLS}",
            walk.calls
        ));
    }
    Ok(())
}

/// Holds the `repo` walk to the file entries of its committed tree, which are listed with or
/// without the `.git` beside them.
fn check_repo(walk: &Walk) -> Result<(), String> {
    for path in REPO_TREE_FILE_ENTRIES {
        if !walk.listed_files.contains(path) {
            return Err(format!("fixture repo did not list the file entry {path}"));
        }
    }
    Ok(())
}

/// One complete pass over `folder`: the `list_tree` and `select_file` walk, the model's own
/// operations, and one Git read of a model of the folder. Returns the number of `list_tree` calls.
fn pass(folder: &str) -> Result<usize, String> {
    let canonical = Path::new(folder)
        .canonicalize()
        .map_err(|_| format!("{folder} did not open as a folder"))?;
    let walk =
        walk_folder(&canonical).ok_or_else(|| format!("{folder} did not open as a folder"))?;
    // The answer is dropped: the proof is that the folder is unchanged afterwards, `.git/index`
    // included. `canonical` is canonical, as the adapter compares it against the locations it
    // verifies.
    let opened = open_folder(&canonical).expect("the folder that was just walked opens");
    let _ = read_git(FolderModel::new(opened), &Libgit2);
    Ok(walk.calls)
}

/// Long mode: one pass, the marker, then passes without end. It returns only on a failed pass.
fn run_long(folder: &str) -> Result<(), String> {
    pass(folder)?;
    let mut stdout = std::io::stdout();
    writeln!(stdout, "{PASS_COMPLETE_MARKER}").map_err(|error| error.to_string())?;
    stdout.flush().map_err(|error| error.to_string())?;
    loop {
        pass(folder)?;
        sleep(PASS_PAUSE);
    }
}

/// Ends the process with status 0 on `Ok` and non-zero on `Err`, whose text goes to stderr.
pub(crate) fn run() -> Result<(), String> {
    let mut arguments = std::env::args().skip(1);
    let folder = arguments
        .next()
        .filter(|argument| argument.starts_with('/'));
    match folder {
        Some(folder) if arguments.next().as_deref() == Some(LONG_MODE_ARGUMENT) => {
            run_long(&folder)
        }
        Some(folder) => {
            println!("{}", pass(&folder)?);
            Ok(())
        }
        None => {
            judge_self_check()?;
            let failures: Vec<String> = FIXTURES
                .iter()
                .filter_map(|(name, extra)| check_fixture(name, *extra).err())
                .collect();
            if failures.is_empty() {
                Ok(())
            } else {
                Err(failures.join("\n"))
            }
        }
    }
}
