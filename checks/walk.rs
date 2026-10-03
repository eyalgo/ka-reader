//! The in-process walk `checks/read-only.sh` consumes.
//!
//! Folder mode, taken when the first argument is an absolute path: open that folder, then call
//! `list_tree` on its root and on every entry it returns, descending only into folders, and call
//! `select_file` once on each file entry a `list_tree` answer returns. Then it asks the Git port
//! three things of the folder's canonical path: `probe` on it, and, only where `probe` says `Root`,
//! `state` and `status` once each. The answers are dropped and none stops the walk. It prints the
//! number of `list_tree` calls it made, never anything a `select_file` or a Git answer carries, and
//! exits 0 once the walk is complete, or non-zero when the folder did not open.
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
use std::path::{Path, PathBuf};

use nozoki_core::{
    EntryKind, GitPort, ItemState, Libgit2, OpenedFolder, RootFinding, list_tree, open_folder,
    select_file,
};

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

/// One walk's outcome: how many `list_tree` calls it made, whether the root listed entries, and the
/// two tallies the coverage judge compares. They are fed from different places and neither is
/// derived from the other.
struct Walk {
    calls: usize,
    root_has_entries: bool,
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
                walk_from(opened, &entry.path, listed, calls, listed_files, selected);
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

/// Asks the Git port about `root`: `probe`, and only on `Root` `state` and `status` once each. The
/// answers are dropped, because the proof is that the folder is unchanged afterwards, `.git/index`
/// included. `root` is canonical, as the adapter compares it against the locations it verifies.
fn call_git_port(root: &Path) {
    let port: &dyn GitPort = &Libgit2;
    if port.probe(root) == RootFinding::Root {
        let _ = port.state(root);
        let _ = port.status(root);
    }
}

fn walk_folder(folder: &Path) -> Option<Walk> {
    let opened = open_folder(folder).expect("the read-only fixture opens");
    let mut calls = 0;
    let mut listed = HashSet::new();
    let mut listed_files = BTreeSet::new();
    let mut selected = BTreeMap::new();
    let root_has_entries = walk_from(
        &opened,
        "",
        &mut listed,
        &mut calls,
        &mut listed_files,
        &mut selected,
    );
    Some(Walk {
        calls,
        root_has_entries,
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
    judge_refuses_a_selected_path_never_listed()
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

/// Ends the process with status 0 on `Ok` and non-zero on `Err`, whose text goes to stderr.
pub(crate) fn run() -> Result<(), String> {
    let argument = std::env::args().nth(1);
    match argument.filter(|argument| argument.starts_with('/')) {
        Some(folder) => {
            let canonical = Path::new(&folder)
                .canonicalize()
                .map_err(|_| format!("{folder} did not open as a folder"))?;
            let walk = walk_folder(&canonical)
                .ok_or_else(|| format!("{folder} did not open as a folder"))?;
            call_git_port(&canonical);
            println!("{}", walk.calls);
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
