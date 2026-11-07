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
//! `read_file` then `FolderModel::open_read` at a fixed position on every file, so the last one is the
//! open file, `FileRequest::Position` on the open file, `TreeRequest::Invalidate` with a report
//! naming the root and every folder, which now covers the open file, `FolderModel::reread_open_file`,
//! then `TreeRequest::Collapse` on every folder. None of them writes. None of them is a
//! `select_file` call, so the `select_file` tally and the judge over it are as they were.
//!
//! Before that loop it also calls `asset_bytes` and `link_file` through the real containment check on
//! the root path and on every file entry, and drives the open a link makes (`Select`, `read_file`,
//! `open_read`) where `link_file` answers a file. Folder mode refuses a pass that reached either of
//! the two zero times.
//!
//! Beside those calls it keeps each Markdown document a `select_file` answer gives, whatever the
//! file's extension, and asks `asset_bytes` once for every image node in it: a resolved node by its
//! folder-relative path, a placeholder node by its source as written. The answers are dropped and none
//! stops the walk. A pass in which a Markdown file's `asset_bytes` calls do not equal its image nodes
//! is refused, naming the file.
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
    Block, EmphasisStrength, EntryKind, FileRead, FileRequest, FileView, FolderContainment,
    FolderModel, HeadingLevel, ImageTarget, Inline, ItemState, Libgit2, LinkTarget, ListKind,
    MarkdownDocument, OpenedFolder, PathReports, PlaceholderCondition, ReadingPosition,
    TreeRequest, asset_bytes, link_file, list_tree, open_folder, read_file, read_git, select_file,
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
const REPO_TREE_FILE_ENTRIES: [&str; 5] = [
    "README.md",
    "guide.md",
    "diagram.png",
    "src/main.rs",
    "src/deep/leaf.txt",
];

/// How many times a walk drove each model operation. Each count is raised at the one site its
/// operation goes through, so the tally is the walk's own record and nothing is derived from it.
#[derive(Debug, Default, Clone, Copy)]
struct Acts {
    expand: usize,
    collapse: usize,
    invalidate: usize,
    select: usize,
    read_file: usize,
    open_read: usize,
    position: usize,
    /// The `Invalidate` batches applied while a file was open, which they cover (the root is
    /// reported in each).
    invalidate_over_open_file: usize,
    reread_open_file: usize,
    asset_bytes: usize,
    link_file: usize,
}

/// The reading position every file is opened at: the wire form the shell writes for the top-left.
/// The model holds it as opaque bytes.
const OPEN_POSITION: &[u8] = b"line=0;x=0";
/// The position the open file is then moved to.
const MOVED_POSITION: &[u8] = b"line=3;x=7";

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
    /// What the walk asked `asset_bytes` for the images of the Markdown files it read.
    images: ImageTally,
}

/// One thing `asset_bytes` is asked for an image node of a rendered document.
#[derive(Debug, Clone, PartialEq, Eq)]
enum ImageAsk {
    /// A node resolved inside the folder, asked with its folder-relative path.
    Resolved(String),
    /// A node that is a placeholder, asked with its source as written.
    Placeholder {
        condition: PlaceholderCondition,
        source: String,
    },
}

impl ImageAsk {
    /// The text `asset_bytes` is asked.
    fn path(&self) -> &str {
        match self {
            Self::Resolved(path) => path,
            Self::Placeholder { source, .. } => source,
        }
    }
}

/// What a walk did about images. The node counts are fed by the collector and the call counts by the
/// ask loop, so neither is derived from the other.
#[derive(Debug, Default, Clone, PartialEq, Eq)]
struct ImageTally {
    /// The image nodes of each Markdown file's document.
    nodes: BTreeMap<String, usize>,
    /// The `asset_bytes` calls made for each Markdown file's image nodes.
    calls: BTreeMap<String, usize>,
    /// The resolved nodes `asset_bytes` answered bytes for.
    resolved_answered: usize,
    /// The placeholder nodes that carry `OutsideTheFolder`.
    outside_the_folder: usize,
}

impl ImageTally {
    /// Raises the call count of `path` for one ask, and the resolved or outside-the-folder count
    /// the ask belongs to. `answered` is whether bytes came back.
    fn record_call(&mut self, path: &str, ask: &ImageAsk, answered: bool) {
        *self.calls.entry(path.to_string()).or_insert(0) += 1;
        match ask {
            ImageAsk::Resolved(_) if answered => self.resolved_answered += 1,
            ImageAsk::Placeholder {
                condition: PlaceholderCondition::OutsideTheFolder,
                ..
            } => self.outside_the_folder += 1,
            ImageAsk::Resolved(_) | ImageAsk::Placeholder { .. } => {}
        }
    }
}

/// The document of a `select_file` answer when it is a Markdown document, and nothing otherwise.
fn markdown_document(answer: ItemState<FileView>) -> Option<MarkdownDocument> {
    match answer {
        ItemState::Observed(FileView::Markdown(document)) => Some(document),
        ItemState::Pending | ItemState::Failed(_) | ItemState::Observed(_) => None,
    }
}

/// What `asset_bytes` is asked for each image node of `document`, in document order.
fn image_asks(document: &MarkdownDocument) -> Vec<ImageAsk> {
    let mut asks = Vec::new();
    collect_block_asks(&document.blocks, &mut asks);
    asks
}

/// Appends the asks of `blocks` to `asks`, each block's in source order. The match names every
/// variant, so a node kind added later is a compile error here and never a silently skipped image.
fn collect_block_asks(blocks: &[Block], asks: &mut Vec<ImageAsk>) {
    for block in blocks {
        match block {
            Block::Heading { content, .. } | Block::Paragraph(content) => {
                collect_inline_asks(content, asks);
            }
            Block::List { items, .. } => {
                for item in items {
                    collect_block_asks(item, asks);
                }
            }
            Block::Quote(inner) => collect_block_asks(inner, asks),
            Block::Rule | Block::Code { .. } => {}
        }
    }
}

/// Appends the asks of `inlines` to `asks`, descending into an emphasis and a link's content.
fn collect_inline_asks(inlines: &[Inline], asks: &mut Vec<ImageAsk>) {
    for inline in inlines {
        match inline {
            Inline::Image { target, .. } => asks.push(match target {
                ImageTarget::Resolved(path) => {
                    ImageAsk::Resolved(path.to_string_lossy().into_owned())
                }
                ImageTarget::Placeholder { condition, source } => ImageAsk::Placeholder {
                    condition: *condition,
                    source: source.clone(),
                },
            }),
            Inline::Emphasis { content, .. } | Inline::Link { content, .. } => {
                collect_inline_asks(content, asks);
            }
            Inline::Text(_) | Inline::Code(_) => {}
        }
    }
}

/// Judges the image tally of one walk: every Markdown file's calls must equal its image nodes.
/// The `Err` names the first such file in path order.
fn judge_images(tally: &ImageTally) -> Result<(), String> {
    let paths: BTreeSet<&String> = tally.nodes.keys().chain(tally.calls.keys()).collect();
    for path in paths {
        let nodes = tally.nodes.get(path).copied().unwrap_or(0);
        let calls = tally.calls.get(path).copied().unwrap_or(0);
        if calls < nodes {
            return Err(format!(
                "an image node of the Markdown file {path} got no asset_bytes call (image nodes: {nodes}, asset_bytes calls: {calls})"
            ));
        }
        if calls > nodes {
            return Err(format!(
                "the Markdown file {path} got more asset_bytes calls than it has image nodes (image nodes: {nodes}, asset_bytes calls: {calls})"
            ));
        }
    }
    Ok(())
}

/// Judges what the `repo` fixture's walk exercised of its images.
fn judge_repo_images(tally: &ImageTally) -> Result<(), String> {
    if tally.resolved_answered == 0 {
        return Err("fixture repo: the walk answered bytes for no resolved image node, so no image inside the folder was exercised. Check that diagram.png is beside guide.md in the fixture.".to_string());
    }
    if tally.outside_the_folder == 0 {
        return Err("fixture repo: the walk met no image node outside the folder, so no remote image was exercised. Check that guide.md in the fixture still holds its https:// image.".to_string());
    }
    Ok(())
}

/// Reads the file at `path` and counts the call. This is the one site every `select_file` call goes
/// through. The answer is handed back for the walk to keep a Markdown document; the proof is that
/// the folder is unchanged afterwards, whatever the file reads as, so no answer stops the walk or
/// reaches stdout.
fn select_counted(
    opened: &OpenedFolder,
    path: &str,
    selected: &mut BTreeMap<String, usize>,
) -> ItemState<FileView> {
    *selected.entry(path.to_string()).or_insert(0) += 1;
    select_file(opened, path)
}

/// What one descent over a folder gathers.
#[derive(Default)]
struct Gathered {
    /// The paths already listed, so no path is listed twice.
    listed: HashSet<String>,
    /// The `list_tree` calls made.
    calls: usize,
    listed_files: BTreeSet<String>,
    listed_folders: BTreeSet<String>,
    selected: BTreeMap<String, usize>,
    /// The document of each Markdown file the walk read, by path.
    documents: BTreeMap<String, MarkdownDocument>,
}

/// Calls `list_tree` on `path`, then on each entry it returns. A folder entry is walked in turn, and
/// every other entry is listed once and not descended, then read once with `select_file`, whose
/// Markdown document is kept. A failed
/// answer stops nothing: it has no entries to go on to. No path is listed twice, so folder links that reach each other end.
fn walk_from(opened: &OpenedFolder, path: &str, gathered: &mut Gathered) -> bool {
    if !gathered.listed.insert(path.to_string()) {
        return false;
    }
    gathered.calls += 1;
    let ItemState::Observed(entries) = list_tree(opened, path) else {
        return false;
    };
    for entry in &entries {
        match entry.kind {
            EntryKind::Folder => {
                gathered.listed_folders.insert(entry.path.clone());
                walk_from(opened, &entry.path, gathered);
            }
            EntryKind::File => {
                gathered.listed_files.insert(entry.path.clone());
                if gathered.listed.insert(entry.path.clone()) {
                    gathered.calls += 1;
                    list_tree(opened, &entry.path);
                    let answer = select_counted(opened, &entry.path, &mut gathered.selected);
                    if let Some(document) = markdown_document(answer) {
                        gathered.documents.insert(entry.path.clone(), document);
                    }
                }
            }
        }
    }
    !entries.is_empty()
}

/// The model's own operations, driven and counted. Each count is raised in the one method its
/// operation goes through. The model is held in an `Option` only so an operation that takes it by
/// value can move it out and put the result back.
struct Driven {
    model: Option<FolderModel>,
    acts: Acts,
}

impl Driven {
    fn new(model: FolderModel) -> Self {
        Self {
            model: Some(model),
            acts: Acts::default(),
        }
    }

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
        if self
            .model
            .as_ref()
            .is_some_and(|model| model.open_file().is_some())
        {
            self.acts.invalidate_over_open_file += 1;
        }
        self.apply_tree(TreeRequest::Invalidate(PathReports::new(paths)));
    }

    fn select(&mut self, path: &str) {
        self.acts.select += 1;
        self.model = self
            .model
            .take()
            .map(|model| model.select_file(FileRequest::Select(Some(PathBuf::from(path)))));
    }

    /// The read half of the open: `path` read from `folder`, nothing yet held.
    fn read(&mut self, folder: &OpenedFolder, path: &str) -> FileRead {
        self.acts.read_file += 1;
        read_file(folder, Path::new(path))
    }

    /// The fold half of the open: the file `read` found becomes the open file at `position`.
    fn open_read(&mut self, read: FileRead, position: &[u8]) {
        self.acts.open_read += 1;
        self.model = self
            .model
            .take()
            .map(|model| model.open_read(read, ReadingPosition::new(position)));
    }

    /// Asks for the bytes of `path` and drops them: the proof is that the folder is unchanged. True
    /// when bytes came back.
    fn asset_bytes(
        &mut self,
        folder: &OpenedFolder,
        check: &FolderContainment,
        path: &str,
    ) -> bool {
        self.acts.asset_bytes += 1;
        asset_bytes(folder, path, check).is_some()
    }

    /// Asks whether `path` is a file a link may open. True when it answered one.
    fn link_file(&mut self, check: &FolderContainment, path: &str) -> bool {
        self.acts.link_file += 1;
        link_file(path, check).is_some()
    }

    fn position(&mut self, position: &[u8]) {
        self.acts.position += 1;
        self.model = self
            .model
            .take()
            .map(|model| model.select_file(FileRequest::Position(ReadingPosition::new(position))));
    }

    fn reread_open_file(&mut self) {
        self.acts.reread_open_file += 1;
        self.model = self.model.take().map(FolderModel::reread_open_file);
    }

    fn apply_tree(&mut self, request: TreeRequest) {
        self.model = self.model.take().map(|model| model.list_tree(request));
    }
}

/// Drives `asset_bytes` and `link_file` on the root and on every file, with the open a link makes
/// where `link_file` answers a file, then `Expand` on every folder, `Select` and the open's two halves
/// on every file, `Position` on the open file, `Invalidate` with the root and every folder reported,
/// `reread_open_file`, then `Collapse` on every folder, over `folder`. Each Markdown document in
/// `documents` is also asked `asset_bytes` once per image node. The fixture is only read.
fn drive_model(
    folder: &Path,
    folders: &BTreeSet<String>,
    files: &BTreeSet<String>,
    documents: &BTreeMap<String, MarkdownDocument>,
) -> (Acts, ImageTally) {
    let opened = open_folder(folder).expect("the folder that was just walked opens");
    let root = opened.root().to_path_buf();
    let reading = open_folder(folder).expect("the folder that was just walked opens");
    let check = FolderContainment::new(root.clone());
    let mut driven = Driven::new(FolderModel::new(opened));
    // The root path is asked as well, so every pass reaches each operation whatever the fixture holds.
    // It resolves to the root folder and both answer nothing. These calls come before the loop below,
    // so its last open still decides the open file the later acts see.
    for path in std::iter::once("").chain(files.iter().map(String::as_str)) {
        driven.asset_bytes(&reading, &check, path);
        if driven.link_file(&check, path) {
            driven.select(path);
            let read = driven.read(&reading, path);
            driven.open_read(read, OPEN_POSITION);
        }
    }
    // `asset_bytes` touches no model, so the last open above still decides the open file.
    let mut images = ImageTally::default();
    for (path, document) in documents {
        let asks = image_asks(document);
        images.nodes.insert(path.clone(), asks.len());
        for ask in &asks {
            let answered = driven.asset_bytes(&reading, &check, ask.path());
            images.record_call(path, ask, answered);
        }
    }
    for path in folders {
        driven.expand(path);
    }
    for path in files {
        driven.select(path);
        let read = driven.read(&reading, path);
        driven.open_read(read, OPEN_POSITION);
    }
    driven.position(MOVED_POSITION);
    let mut reports = vec![root.clone()];
    reports.extend(folders.iter().map(|path| root.join(path)));
    driven.invalidate(reports);
    driven.reread_open_file();
    for path in folders {
        driven.collapse(path);
    }
    (driven.acts, images)
}

fn walk_folder(folder: &Path) -> Option<Walk> {
    let opened = open_folder(folder).expect("the read-only fixture opens");
    let mut gathered = Gathered::default();
    let root_has_entries = walk_from(&opened, "", &mut gathered);
    let (acts, images) = drive_model(
        folder,
        &gathered.listed_folders,
        &gathered.listed_files,
        &gathered.documents,
    );
    Some(Walk {
        calls: gathered.calls,
        root_has_entries,
        acts,
        listed_files: gathered.listed_files,
        selected: gathered.selected,
        images,
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

/// The two operations the bridge exports for the shell, each with how many times a walk reached it.
fn bridge_operations(acts: &Acts) -> [(&'static str, usize); 2] {
    [
        ("asset_bytes", acts.asset_bytes),
        ("link_file", acts.link_file),
    ]
}

/// The first of `reached` that a walk never reached, as the `Err` that names it.
fn first_never_reached(reached: &[(&str, usize)]) -> Result<(), String> {
    match reached.iter().find(|(_, count)| *count == 0) {
        Some((name, _)) => Err(format!("the walk never reached {name}")),
        None => Ok(()),
    }
}

/// Judges the two operations folder mode holds a pass to: `asset_bytes` and `link_file` must each have
/// been reached at least once (CP-1097). The `Err` names the first one the pass never reached.
fn judge_bridge_operations(acts: &Acts) -> Result<(), String> {
    first_never_reached(&bridge_operations(acts))
}

/// Judges the model operations one walk drove: each of `Expand`, `Collapse`, `Invalidate`, `Select`,
/// the five the open file adds, and the two the bridge exports for the shell must have been reached
/// at least once (QC-2's reviewed half). The `Err` names the first operation the walk never reached.
fn judge_acts(acts: &Acts) -> Result<(), String> {
    let reached = [
        ("TreeRequest::Expand", acts.expand),
        ("TreeRequest::Collapse", acts.collapse),
        ("TreeRequest::Invalidate", acts.invalidate),
        ("FileRequest::Select", acts.select),
        ("read_file", acts.read_file),
        ("FolderModel::open_read", acts.open_read),
        ("FileRequest::Position", acts.position),
        (
            "TreeRequest::Invalidate over the open file",
            acts.invalidate_over_open_file,
        ),
        ("FolderModel::reread_open_file", acts.reread_open_file),
    ];
    first_never_reached(&reached)?;
    judge_bridge_operations(acts)
}

/// A tally in which every act was reached once.
fn every_act_reached() -> Acts {
    Acts {
        expand: 1,
        collapse: 1,
        invalidate: 1,
        select: 1,
        read_file: 1,
        open_read: 1,
        position: 1,
        invalidate_over_open_file: 1,
        reread_open_file: 1,
        asset_bytes: 1,
        link_file: 1,
    }
}

fn judge_accepts_every_act_reached() -> Result<(), String> {
    judge_acts(&every_act_reached())
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
    let all = every_act_reached();
    judge_refuses_a_missing_act("Expand", Acts { expand: 0, ..all })?;
    judge_refuses_a_missing_act("Collapse", Acts { collapse: 0, ..all })?;
    judge_refuses_a_missing_act(
        "Invalidate",
        Acts {
            invalidate: 0,
            ..all
        },
    )?;
    judge_refuses_a_missing_act("Select", Acts { select: 0, ..all })?;
    judge_refuses_a_missing_act(
        "read_file",
        Acts {
            read_file: 0,
            ..all
        },
    )?;
    judge_refuses_a_missing_act(
        "open_read",
        Acts {
            open_read: 0,
            ..all
        },
    )?;
    judge_refuses_a_missing_act("Position", Acts { position: 0, ..all })?;
    judge_refuses_a_missing_act(
        "Invalidate over the open file",
        Acts {
            invalidate_over_open_file: 0,
            ..all
        },
    )?;
    judge_refuses_a_missing_act(
        "reread_open_file",
        Acts {
            reread_open_file: 0,
            ..all
        },
    )?;
    judge_refuses_a_missing_act(
        "asset_bytes",
        Acts {
            asset_bytes: 0,
            ..all
        },
    )?;
    judge_refuses_a_missing_act(
        "link_file",
        Acts {
            link_file: 0,
            ..all
        },
    )
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

/// A resolved image node on `path`.
fn resolved_image(path: &str) -> Inline {
    Inline::Image {
        alt: String::new(),
        target: ImageTarget::Resolved(PathBuf::from(path)),
    }
}

/// A placeholder image node for `source` that carries `condition`.
fn placeholder_image(condition: PlaceholderCondition, source: &str) -> Inline {
    Inline::Image {
        alt: String::new(),
        target: ImageTarget::Placeholder {
            condition,
            source: source.to_string(),
        },
    }
}

/// What the collector asked for `document`, as the texts `asset_bytes` is asked.
fn asked_texts(document: &MarkdownDocument) -> Vec<String> {
    image_asks(document)
        .iter()
        .map(|ask| ask.path().to_string())
        .collect()
}

fn collector_asks_every_position_in_order() -> Result<(), String> {
    let document = MarkdownDocument {
        blocks: vec![
            Block::Paragraph(vec![
                Inline::Text("text".to_string()),
                resolved_image("paragraph.png"),
            ]),
            Block::Heading {
                level: HeadingLevel::One,
                content: vec![resolved_image("heading.png")],
            },
            Block::Rule,
            Block::Paragraph(vec![Inline::Emphasis {
                strength: EmphasisStrength::Strong,
                content: vec![resolved_image("emphasis.png")],
            }]),
            Block::Paragraph(vec![Inline::Link {
                content: vec![resolved_image("link.png")],
                destination: "page.md".to_string(),
                target: LinkTarget::External,
            }]),
            Block::Quote(vec![Block::List {
                kind: ListKind::Unordered,
                items: vec![vec![Block::Paragraph(vec![resolved_image(
                    "quoted-list-item.png",
                )])]],
            }]),
        ],
    };
    let expected = [
        "paragraph.png",
        "heading.png",
        "emphasis.png",
        "link.png",
        "quoted-list-item.png",
    ];
    let asked = asked_texts(&document);
    if asked == expected {
        Ok(())
    } else {
        Err(format!(
            "the image collector asked {asked:?} for the hand-built document with an image in each position, expected {expected:?}"
        ))
    }
}

fn collector_asks_a_resolved_node_by_its_path_and_a_placeholder_by_its_source() -> Result<(), String>
{
    let document = MarkdownDocument {
        blocks: vec![Block::Paragraph(vec![
            resolved_image("diagram.png"),
            resolved_image("diagram.png"),
            placeholder_image(
                PlaceholderCondition::OutsideTheFolder,
                "https://example.com/c.png",
            ),
        ])],
    };
    let expected = ["diagram.png", "diagram.png", "https://example.com/c.png"];
    let asked = asked_texts(&document);
    if asked == expected {
        Ok(())
    } else {
        Err(format!(
            "the image collector asked {asked:?} for the hand-built document with three images, expected {expected:?}"
        ))
    }
}

fn markdown_predicate_answers_only_for_a_markdown_answer() -> Result<(), String> {
    let document = MarkdownDocument {
        blocks: vec![Block::Rule],
    };
    let from_markdown =
        markdown_document(ItemState::Observed(FileView::Markdown(document.clone())));
    if from_markdown.as_ref() != Some(&document) {
        return Err("the Markdown predicate gave no document for a Markdown answer".to_string());
    }
    let text = FileView::Text {
        content: String::new(),
        language: ka_reader_core::Language::Plain,
        spans: Vec::new(),
    };
    for (case, answer) in [
        ("a text answer", ItemState::Observed(text)),
        ("a pending answer", ItemState::Pending),
    ] {
        if markdown_document(answer).is_some() {
            return Err(format!("the Markdown predicate gave a document for {case}"));
        }
    }
    Ok(())
}

/// A hand-built image tally: the node counts and the call counts of each file.
fn image_tally(nodes: &[(&str, usize)], calls: &[(&str, usize)]) -> ImageTally {
    let counts = |pairs: &[(&str, usize)]| {
        pairs
            .iter()
            .map(|(path, count)| (path.to_string(), *count))
            .collect()
    };
    ImageTally {
        nodes: counts(nodes),
        calls: counts(calls),
        ..ImageTally::default()
    }
}

fn image_judge_accepts_a_tally_where_every_node_got_its_call() -> Result<(), String> {
    judge_images(&image_tally(
        &[("guide.md", 2), ("notes.md", 1)],
        &[("guide.md", 2), ("notes.md", 1)],
    ))
    .map_err(|message| {
        format!("a tally in which every image node got its asset_bytes call was refused: {message}")
    })
}

fn image_judge_refuses_a_file_with_an_unasked_node_naming_it() -> Result<(), String> {
    match judge_images(&image_tally(&[("guide.md", 2)], &[("guide.md", 1)])) {
        Ok(()) => Err(
            "the image judge accepted a tally in which an image node of guide.md got no asset_bytes call"
                .to_string(),
        ),
        Err(message) if message.contains("guide.md") => Ok(()),
        Err(message) => Err(format!(
            "the image judge refused a tally in which an image node of guide.md got no asset_bytes call without naming guide.md: {message}"
        )),
    }
}

fn image_judge_refuses_a_file_asked_more_times_than_it_has_nodes() -> Result<(), String> {
    match judge_images(&image_tally(&[("guide.md", 1)], &[("guide.md", 2)])) {
        Ok(()) => Err(
            "the image judge accepted a tally in which guide.md got more asset_bytes calls than it has image nodes"
                .to_string(),
        ),
        Err(message) if message.contains("guide.md") => Ok(()),
        Err(message) => Err(format!(
            "the image judge refused a tally in which guide.md got more asset_bytes calls than it has image nodes without naming guide.md: {message}"
        )),
    }
}

fn repo_image_check_refuses_a_walk_where_no_resolved_node_was_answered_bytes() -> Result<(), String>
{
    let tally = ImageTally {
        outside_the_folder: 1,
        ..ImageTally::default()
    };
    match judge_repo_images(&tally) {
        Ok(()) => Err(
            "the image check of fixture repo accepted an image tally in which no resolved image node was answered bytes"
                .to_string(),
        ),
        Err(message) if message.contains("repo") => Ok(()),
        Err(message) => Err(format!(
            "the image check of fixture repo refused an image tally in which no resolved image node was answered bytes without naming repo: {message}"
        )),
    }
}

fn repo_image_check_refuses_a_placeholder_that_is_not_outside_the_folder() -> Result<(), String> {
    let tally = ImageTally {
        resolved_answered: 1,
        ..ImageTally::default()
    };
    match judge_repo_images(&tally) {
        Ok(()) => Err(
            "the image check of fixture repo accepted an image tally in which no placeholder node was outside the folder"
                .to_string(),
        ),
        Err(message) if message.contains("repo") => Ok(()),
        Err(message) => Err(format!(
            "the image check of fixture repo refused an image tally in which no placeholder node was outside the folder without naming repo: {message}"
        )),
    }
}

/// Runs the judge on tallies built by hand, so every no-argument run shows that it accepts the walk
/// CP-327 wants and refuses the three it forbids.
fn judge_self_check() -> Result<(), String> {
    judge_accepts_every_listed_file_selected_once()?;
    judge_refuses_a_listed_file_never_selected()?;
    judge_refuses_a_listed_file_selected_twice()?;
    judge_refuses_a_selected_path_never_listed()?;
    judge_accepts_every_act_reached()?;
    judge_refuses_every_act_left_out()?;
    collector_asks_every_position_in_order()?;
    collector_asks_a_resolved_node_by_its_path_and_a_placeholder_by_its_source()?;
    markdown_predicate_answers_only_for_a_markdown_answer()?;
    image_judge_accepts_a_tally_where_every_node_got_its_call()?;
    image_judge_refuses_a_file_with_an_unasked_node_naming_it()?;
    image_judge_refuses_a_file_asked_more_times_than_it_has_nodes()?;
    repo_image_check_refuses_a_walk_where_no_resolved_node_was_answered_bytes()?;
    repo_image_check_refuses_a_placeholder_that_is_not_outside_the_folder()
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
    judge_images(&walk.images).map_err(|message| format!("fixture {name}: {message}"))?;
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
    judge_repo_images(&walk.images)
}

/// One complete pass over `folder`: the `list_tree` and `select_file` walk, the model's own
/// operations, and one Git read of a model of the folder. Returns the number of `list_tree` calls.
fn pass(folder: &str) -> Result<usize, String> {
    let canonical = Path::new(folder)
        .canonicalize()
        .map_err(|_| format!("{folder} did not open as a folder"))?;
    let walk =
        walk_folder(&canonical).ok_or_else(|| format!("{folder} did not open as a folder"))?;
    judge_bridge_operations(&walk.acts).map_err(|message| format!("{folder}: {message}"))?;
    judge_images(&walk.images).map_err(|message| format!("{folder}: {message}"))?;
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
