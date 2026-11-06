//! folder-model: SM-5, the crate's public surface for the host and the harness. An opened folder is
//! a canonical root, and listing is delegated to fs-reader.

use std::collections::{BTreeMap, BTreeSet};
use std::ffi::OsString;
use std::path::{Component, Path, PathBuf};

use crate::fs_reader::{
    self, CannotDisplayReason, Entry, EntryKind, FileContent, ItemState, Listed,
    ListingObservation, Location, OpenFailure, Reobserved, order,
};
use crate::git_reader::{
    GitPort, GitReadCondition, HeadState, ProbeCondition, RootFinding, StatusLists,
};
use crate::highlighter::{Span, highlight};
use crate::language::Language;

/// A folder the user chose, held as its canonical path.
///
/// Opening again yields a new value: nothing here is mutated in place, so a caller that keeps one
/// value replaces it whole.
#[derive(Debug, Clone, PartialEq, Eq)]
pub struct OpenedFolder {
    root: PathBuf,
}

impl OpenedFolder {
    /// The canonical root the folder was opened at: a folder chosen through a link names the
    /// resolved path.
    ///
    /// # Examples
    ///
    /// ```
    /// let opened = ka_reader_core::open_folder(std::env::temp_dir()).expect("the temporary folder opens");
    /// assert!(opened.root().is_absolute());
    /// ```
    pub fn root(&self) -> &Path {
        &self.root
    }
}

/// The closed answer to an attempt to open a chosen path.
#[derive(Debug, Clone, PartialEq, Eq)]
pub enum OpenFolderOutcome {
    Opened(OpenedFolder),
    Failed(OpenFailure),
}

impl OpenFolderOutcome {
    /// Returns the opened folder or panics with the same test-facing contract as `Option::expect`.
    pub fn expect(self, message: &str) -> OpenedFolder {
        match self {
            Self::Opened(folder) => folder,
            Self::Failed(failure) => panic!("{message}: {failure:?}"),
        }
    }
}

/// Opens `path` as a folder, rooted at its canonical path.
///
/// Returns a closed outcome for the chosen path. A readable directory is opened; a missing path,
/// non-directory, or unreadable directory is reported as its corresponding [`OpenFailure`].
///
/// # Examples
///
/// ```
/// let opened = ka_reader_core::open_folder(std::env::temp_dir());
/// assert!(matches!(opened, ka_reader_core::OpenFolderOutcome::Opened(_)));
///
/// let missing = std::env::temp_dir().join("ka-reader-a-folder-that-is-not-there");
/// assert!(matches!(
///     ka_reader_core::open_folder(missing),
///     ka_reader_core::OpenFolderOutcome::Failed(ka_reader_core::OpenFailure::Missing)
/// ));
/// ```
pub fn open_folder(path: impl AsRef<Path>) -> OpenFolderOutcome {
    match fs_reader::open_root(path.as_ref()) {
        Ok(root) => OpenFolderOutcome::Opened(OpenedFolder { root }),
        Err(failure) => {
            log::warn!("fs-reader: open_folder failed: {}", failure.text);
            OpenFolderOutcome::Failed(failure.condition)
        }
    }
}

/// Lists the direct entries of `path` inside an opened folder, where `path` is relative to the
/// folder's root (the empty string is the root itself). The answer is `Observed` with the entries,
/// or `Failed` with a condition, and never `Pending`. Nothing is cached, so every call reads again.
///
/// # Examples
///
/// ```
/// use ka_reader_core::{Condition, ItemState, list_tree, open_folder};
///
/// let opened = open_folder(std::env::temp_dir()).expect("the temporary folder opens");
/// assert!(matches!(list_tree(&opened, ""), ItemState::Observed(_)));
/// assert_eq!(list_tree(&opened, ".."), ItemState::Failed(Condition::Outside));
/// ```
pub fn list_tree(opened: &OpenedFolder, path: &str) -> ItemState<Vec<Entry>> {
    fs_reader::list(&opened.root, path)
}

/// What the open file is, as the reading panel needs it: its text with the language it is drawn as
/// and the spans that language's grammar yields for that text, or the fact that it cannot be shown
/// as text.
#[derive(Debug, Clone, PartialEq, Eq)]
pub enum FileView {
    /// The decoded content, its language, and exactly `highlight(&content, language)` in its order.
    /// `spans` is empty for `Plain`, for empty content, and wherever the highlighter yields nothing.
    Text {
        content: String,
        language: Language,
        spans: Vec<Span>,
    },
    /// The file is not text under the text rule, for the reason named.
    CannotDisplay(CannotDisplayReason),
    /// A re-read of the open file found nothing at its path: no entry at a step of the path as the
    /// reader spelled it, or a step above it that is no longer a folder, with no link's target
    /// being resolved there. It carries no content. Only a re-read of the open file yields it:
    /// [`select_file`] and an open never answer it.
    ///
    /// # Examples
    ///
    /// ```
    /// use std::path::PathBuf;
    /// use ka_reader_core::{FileRequest, FileView, FolderModel, ItemState, PathReports, ReadingPosition, TreeRequest, open_folder};
    ///
    /// let folder = std::env::temp_dir().join(format!("ka-reader-doc-gone-{}", std::process::id()));
    /// std::fs::create_dir_all(&folder).expect("the folder is made");
    /// std::fs::write(folder.join("note.txt"), "hello").expect("the file is written");
    /// let opened = open_folder(&folder).expect("the folder opens");
    /// let model = FolderModel::new(opened)
    ///     .select_file(FileRequest::Open("note.txt".into(), ReadingPosition::new(b"top".as_slice())));
    ///
    /// std::fs::remove_file(folder.join("note.txt")).expect("the file goes");
    /// let model = model.list_tree(TreeRequest::Invalidate(PathReports::new(vec![folder.join("note.txt")])));
    ///
    /// let open = model.open_file().expect("the file is still the open one");
    /// assert_eq!(open.view(), &ItemState::Observed(FileView::Gone));
    /// std::fs::remove_dir_all(&folder).expect("the folder goes");
    /// ```
    Gone,
}

impl From<FileContent> for FileView {
    fn from(content: FileContent) -> Self {
        match content {
            FileContent::Text { content, language } => {
                // Spans are taken from the content the answer carries, after any byte-order mark is
                // gone, so their offsets count the bytes the reader is shown (CP-307).
                let spans = highlight(&content, language);
                Self::Text {
                    content,
                    language,
                    spans,
                }
            }
            FileContent::CannotDisplay(reason) => Self::CannotDisplay(reason),
        }
    }
}

/// Reads the file at `path` inside an opened folder, where `path` is relative to the folder's root,
/// and answers what it is: its text with its language and spans, or a file that cannot be shown as
/// text. The answer is `Observed` with that verdict, or `Failed` with a condition, and never
/// `Pending`. Nothing is cached, so every call reads again, and the folder is only read, never
/// written.
///
/// # Examples
///
/// ```
/// use ka_reader_core::{Condition, ItemState, open_folder, select_file};
///
/// let opened = open_folder(std::env::temp_dir()).expect("the temporary folder opens");
/// assert_eq!(select_file(&opened, ".."), ItemState::Failed(Condition::Outside));
/// ```
pub fn select_file(opened: &OpenedFolder, path: &str) -> ItemState<FileView> {
    match fs_reader::read(&opened.root, path) {
        ItemState::Observed(content) => ItemState::Observed(content.into()),
        ItemState::Failed(condition) => ItemState::Failed(condition),
        ItemState::Pending => ItemState::Pending,
    }
}

/// What an opened folder is to Git: the top level of a repository, with what is known of it, or a
/// plain folder that holds no Git state.
#[derive(Debug, Clone, PartialEq, Eq)]
pub enum FolderKind {
    Root(GitState),
    Plain,
}

/// What the model holds of a repository's top level, built from one read: the port's `state()` answer
/// (where HEAD stands) and its `status()` answer (the staged and changed lists, in the port's order
/// and with no count).
///
/// # Examples
///
/// ```
/// use ka_reader_core::{FolderKind, FolderModel, GitPort, ItemState, read_git, open_folder};
/// # use ka_reader_core::{GitReadCondition, HeadState, RootFinding, StatusLists};
/// # use std::path::Path;
/// # struct Plain;
/// # impl GitPort for Plain {
/// #     fn probe(&self, _: &Path) -> RootFinding { RootFinding::Plain }
/// #     fn state(&self, _: &Path) -> Result<HeadState, GitReadCondition> { Err(GitReadCondition::NotARoot) }
/// #     fn status(&self, _: &Path) -> Result<StatusLists, GitReadCondition> { Err(GitReadCondition::NotARoot) }
/// # }
///
/// let opened = open_folder(std::env::temp_dir()).expect("the temporary folder opens");
/// let model = read_git(FolderModel::new(opened), &Plain);
/// assert_eq!(model.kind(), &ItemState::Observed(FolderKind::Plain));
/// ```
#[derive(Debug, Clone, PartialEq, Eq)]
pub struct GitState {
    head: HeadState,
    status: StatusLists,
}

impl GitState {
    /// Where HEAD stands and what the repository is in the middle of.
    pub fn head(&self) -> &HeadState {
        &self.head
    }

    /// The staged and changed lists, as the port answered them.
    pub fn status(&self) -> &StatusLists {
        &self.status
    }
}

/// Why the Git item failed: the port's own condition, unchanged, and the operation that met it.
#[derive(Debug, Clone, PartialEq, Eq)]
pub enum GitCondition {
    Probe(ProbeCondition),
    Read(GitReadCondition),
}

impl GitCondition {
    /// A fixed phrase for the condition. It is chosen from the variant and never formatted from a
    /// payload, so the log line cannot hold a path.
    fn log_phrase(&self) -> &'static str {
        match self {
            Self::Probe(ProbeCondition::FolderUnavailable) => "the folder is unavailable",
            Self::Probe(ProbeCondition::GitDirectoryUnreadable) => {
                "the Git directory is unreadable"
            }
            Self::Probe(ProbeCondition::GitEntryNotDirectory) => "the Git entry is not a directory",
            Self::Probe(ProbeCondition::GitFileUnreadable) => "the Git file is unreadable",
            Self::Probe(ProbeCondition::RepositoryReadFailed) => "the repository could not be read",
            Self::Probe(ProbeCondition::ConfigNamesOutside(_)) => CONFIG_NAMES_OUTSIDE_PHRASE,
            Self::Probe(ProbeCondition::ConfigNotLocated(_)) => CONFIG_NOT_LOCATED_PHRASE,
            Self::Probe(ProbeCondition::ObjectStoreNamesOutside(_)) => {
                OBJECT_STORE_NAMES_OUTSIDE_PHRASE
            }
            Self::Probe(ProbeCondition::ObjectStoreNotLocated(_)) => {
                OBJECT_STORE_NOT_LOCATED_PHRASE
            }
            Self::Read(GitReadCondition::GitDirectoryOutside(_)) => {
                "the Git directory is outside the folder"
            }
            Self::Read(GitReadCondition::NotARoot) => "the folder is not a root",
            Self::Read(GitReadCondition::GitDirectoryMissing) => "the Git directory is missing",
            Self::Read(GitReadCondition::GitDirectoryUnreadable) => {
                "the Git directory is unreadable"
            }
            Self::Read(GitReadCondition::NotARepository) => "no repository was found",
            Self::Read(GitReadCondition::RepositoryReadFailed) => {
                "the repository could not be read"
            }
            Self::Read(GitReadCondition::ConfigNamesOutside(_)) => CONFIG_NAMES_OUTSIDE_PHRASE,
            Self::Read(GitReadCondition::ConfigNotLocated(_)) => CONFIG_NOT_LOCATED_PHRASE,
            Self::Read(GitReadCondition::ObjectStoreNamesOutside(_)) => {
                OBJECT_STORE_NAMES_OUTSIDE_PHRASE
            }
            Self::Read(GitReadCondition::ObjectStoreNotLocated(_)) => {
                OBJECT_STORE_NOT_LOCATED_PHRASE
            }
            Self::Read(GitReadCondition::SubmoduleElsewhere(_)) => SUBMODULE_ELSEWHERE_PHRASE,
            Self::Read(GitReadCondition::GitmodulesUnreadable) => GITMODULES_UNREADABLE_PHRASE,
        }
    }
}

/// The one phrase for a config that names a path outside the folder, whichever operation met it. It
/// carries neither the key nor the path the condition holds.
const CONFIG_NAMES_OUTSIDE_PHRASE: &str = "the config names a path outside the folder";

/// The one phrase for a config that sets a key to a value the reader does not locate, whichever
/// operation met it. It carries neither the key nor the path the condition holds.
const CONFIG_NOT_LOCATED_PHRASE: &str = "the config names a path the reader does not locate";

/// The one phrase for an object store that names a location outside the folder, whichever operation
/// met it. It carries neither the entry nor the location the condition holds.
const OBJECT_STORE_NAMES_OUTSIDE_PHRASE: &str =
    "the object store names a location outside the folder";

/// The one phrase for an object store that names a location the reader does not locate, whichever
/// operation met it. It carries neither the entry nor the location the condition holds.
const OBJECT_STORE_NOT_LOCATED_PHRASE: &str =
    "the object store names a location the reader does not locate";

/// The one phrase for a `.gitmodules` section that names another location for a looked-up path. It
/// carries neither the name nor the path the condition holds.
const SUBMODULE_ELSEWHERE_PHRASE: &str =
    "a .gitmodules section names another location for a looked-up path";

/// The one phrase for a `.gitmodules` the check could not read.
const GITMODULES_UNREADABLE_PHRASE: &str = "a .gitmodules could not be read";

/// Where the reader's place in a file is, held exactly as the caller supplied it.
///
/// The bytes are opaque: the model never parses, rounds, clamps or derives them, so a caller
/// chooses the encoding (a line, a line with a finer offset, a scroll fraction) and reads the same
/// bytes back.
///
/// # Examples
///
/// ```
/// use ka_reader_core::ReadingPosition;
///
/// let position = ReadingPosition::new(b"line=400".as_slice());
/// assert_eq!(position.as_bytes(), b"line=400");
/// assert_eq!(position, ReadingPosition::new(b"line=400".as_slice()));
/// ```
#[derive(Debug, Clone, PartialEq, Eq)]
pub struct ReadingPosition(Vec<u8>);

impl ReadingPosition {
    pub fn new(bytes: impl Into<Vec<u8>>) -> Self {
        Self(bytes.into())
    }

    pub fn as_bytes(&self) -> &[u8] {
        &self.0
    }
}

/// The one file shown for reading: its path, the position the reader holds in it, and what reading
/// it gave. The sole owner of those three, so none is kept anywhere else.
///
/// # Examples
///
/// ```
/// use ka_reader_core::{FileRequest, FolderModel, ReadingPosition, open_folder};
///
/// // This crate's own folder, only read.
/// let opened = open_folder(env!("CARGO_MANIFEST_DIR")).expect("the crate folder opens");
/// let position = ReadingPosition::new(b"line=400".as_slice());
/// let model = FolderModel::new(opened)
///     .select_file(FileRequest::Open("Cargo.toml".into(), position.clone()));
///
/// let open = model.open_file().expect("the file is open");
/// assert_eq!(open.path(), std::path::Path::new("Cargo.toml"));
/// assert_eq!(open.position(), &position);
/// ```
#[derive(Debug, Clone, PartialEq, Eq)]
pub struct OpenFile {
    path: PathBuf,
    position: ReadingPosition,
    view: ItemState<FileView>,
    /// Where the path resolved below the root when the file was last read, which differs from
    /// `path` for a file reached through a link. `None` while the model has not resolved it.
    location: Option<PathBuf>,
}

impl OpenFile {
    /// The path the file was opened by, relative to the folder's root.
    pub fn path(&self) -> &Path {
        &self.path
    }

    /// The position the reader holds in the file, exactly as it was supplied.
    pub fn position(&self) -> &ReadingPosition {
        &self.position
    }

    /// What the latest read of the file gave, as [`select_file`] answers it, or [`FileView::Gone`]
    /// when the latest read found nothing at its path.
    pub fn view(&self) -> &ItemState<FileView> {
        &self.view
    }
}

/// What the reader has done to the tree and the file: which folders are expanded, which file is
/// selected, and the open file. It is held in memory only and is never written anywhere.
///
/// A folder absent from the expanded set is collapsed, so a place that expanded and collapsed a
/// folder equals one that never touched it. Paths are native, relative to the opened folder's root.
///
/// # Examples
///
/// ```
/// use std::path::Path;
/// use ka_reader_core::{FolderModel, open_folder};
///
/// let opened = open_folder(std::env::temp_dir()).expect("the temporary folder opens");
/// let model = FolderModel::new(opened);
///
/// assert!(!model.place().is_expanded(Path::new(".git")));
/// assert_eq!(model.place().selected(), None);
/// assert!(model.place().open_file().is_none());
/// ```
#[derive(Debug, Clone, Default, PartialEq, Eq)]
pub struct ReaderPlace {
    expanded: BTreeSet<PathBuf>,
    selected: Option<PathBuf>,
    open_file: Option<OpenFile>,
}

impl ReaderPlace {
    /// Whether the folder at `path`, as it was asked for, is expanded.
    pub fn is_expanded(&self, path: &Path) -> bool {
        self.expanded.contains(path)
    }

    /// The selected file, if one is.
    pub fn selected(&self) -> Option<&Path> {
        self.selected.as_deref()
    }

    /// The open file, if one is. With none open there is no reading position.
    pub fn open_file(&self) -> Option<&OpenFile> {
        self.open_file.as_ref()
    }
}

/// An act on the tree: a folder disclosed or hidden.
///
/// # Examples
///
/// ```
/// use std::path::Path;
/// use ka_reader_core::{FolderModel, TreeRequest, open_folder};
///
/// // This crate's own folder, only read.
/// let opened = open_folder(env!("CARGO_MANIFEST_DIR")).expect("the crate folder opens");
/// let model = FolderModel::new(opened).list_tree(TreeRequest::Expand("src".into()));
/// assert!(model.place().is_expanded(Path::new("src")));
///
/// let model = model.list_tree(TreeRequest::Collapse("src".into()));
/// assert!(!model.place().is_expanded(Path::new("src")));
/// ```
#[derive(Debug, Clone, PartialEq, Eq)]
pub enum TreeRequest {
    /// Hold the folder expanded, with its direct listing read now.
    Expand(PathBuf),
    /// Hold the folder collapsed. Nothing is read, and nothing held beneath it is dropped.
    Collapse(PathBuf),
    /// Apply what the disk reported: entries created, changed and removed. Only the listings the
    /// model holds change, and the place and the Git item are carried as they were.
    Delta(ModelDelta),
    /// Re-read what a batch of reported paths covers. A path names a place on the disk that may
    /// have changed and says nothing of what happened there: the model decides which held listings
    /// the paths cover, reads each one whole, drops what lies under an entry that is gone and
    /// reads again an expanded folder that has returned. The open file is read again too when the
    /// batch covers it. The place's paths and the reading position, and the Git item, are carried
    /// as they were.
    Invalidate(PathReports),
}

/// A batch of absolute paths the disk reported as possibly changed. The batch is owned and carries
/// no meaning beyond the places it names: the model decides what, if anything, to read.
///
/// # Examples
///
/// ```
/// use std::path::PathBuf;
/// use ka_reader_core::PathReports;
///
/// let reports = PathReports::new(vec![PathBuf::from("/a/folder/src/new.rs")]);
/// assert!(!reports.is_empty());
/// assert!(PathReports::new(vec![]).is_empty());
/// ```
#[derive(Debug, Clone, Default, PartialEq, Eq)]
pub struct PathReports {
    paths: Vec<PathBuf>,
}

impl PathReports {
    pub fn new(paths: Vec<PathBuf>) -> Self {
        Self { paths }
    }

    pub fn is_empty(&self) -> bool {
        self.paths.is_empty()
    }
}

/// The listings one model holds that an earlier one did not hold, or held with other entries or
/// another state: what a shell must draw again after the model changed. A listing the later model
/// dropped is not in it. Each comes as its request path (the root as the empty path) and its
/// listing, in path order with the root first.
///
/// # Examples
///
/// ```
/// use ka_reader_core::{FolderModel, open_folder};
///
/// let opened = open_folder(std::env::temp_dir()).expect("the temporary folder opens");
/// let model = FolderModel::new(opened);
/// let changes = model.changes_since(&model);
/// assert!(changes.is_empty());
/// assert!(changes.listings().is_empty());
/// ```
#[derive(Debug, Clone, Default, PartialEq, Eq)]
pub struct TreeChanges {
    listings: Vec<(PathBuf, ItemState<Vec<Entry>>)>,
}

impl TreeChanges {
    /// The changed listings, in path order with the root's (the empty path) first.
    pub fn listings(&self) -> &[(PathBuf, ItemState<Vec<Entry>>)] {
        &self.listings
    }

    pub fn is_empty(&self) -> bool {
        self.listings.is_empty()
    }
}

/// A batch of reports about the disk: entry paths, relative to the opened folder's root, that were
/// created, changed or removed. A report says what happened and never asks for it to happen.
///
/// # Examples
///
/// ```
/// use std::path::PathBuf;
/// use ka_reader_core::ModelDelta;
///
/// let delta = ModelDelta::new(vec![PathBuf::from("src/new.rs")], vec![], vec![]);
/// assert!(!delta.is_empty());
/// assert!(ModelDelta::default().is_empty());
/// ```
#[derive(Debug, Clone, Default, PartialEq, Eq)]
pub struct ModelDelta {
    created: Vec<PathBuf>,
    changed: Vec<PathBuf>,
    removed: Vec<PathBuf>,
}

impl ModelDelta {
    pub fn new(created: Vec<PathBuf>, changed: Vec<PathBuf>, removed: Vec<PathBuf>) -> Self {
        Self {
            created,
            changed,
            removed,
        }
    }

    pub fn is_empty(&self) -> bool {
        self.created.is_empty() && self.changed.is_empty() && self.removed.is_empty()
    }

    /// Every reported path, each with whether it was reported removed.
    fn reports(&self) -> impl Iterator<Item = (&Path, bool)> {
        let present = self
            .created
            .iter()
            .chain(&self.changed)
            .map(|path| (path.as_path(), false));
        present.chain(self.removed.iter().map(|path| (path.as_path(), true)))
    }
}

/// The names a delta reports in one folder: those it says exist (created or changed) and those it
/// says are gone. Names are raw, so two names that display alike stay two.
#[derive(Debug, Default, Clone, PartialEq, Eq)]
struct ReportedNames {
    present: BTreeSet<OsString>,
    removed: BTreeSet<OsString>,
}

/// What reducing one held folder needs: what the delta reported about it, and a fresh read of it.
#[derive(Debug, Clone, PartialEq, Eq)]
struct FolderChange {
    reported: ReportedNames,
    observed: ItemState<ListingObservation>,
}

/// An act on the file: which is selected, which is open, and where the reader is in it.
///
/// # Examples
///
/// ```
/// use std::path::Path;
/// use ka_reader_core::{FileRequest, FolderModel, ReadingPosition, open_folder};
///
/// // This crate's own folder, only read.
/// let opened = open_folder(env!("CARGO_MANIFEST_DIR")).expect("the crate folder opens");
/// let model = FolderModel::new(opened).select_file(FileRequest::Select(Some("Cargo.toml".into())));
/// assert_eq!(model.place().selected(), Some(Path::new("Cargo.toml")));
/// assert!(model.open_file().is_none());
///
/// let anchor = ReadingPosition::new(b"line=400".as_slice());
/// let top = ReadingPosition::new(b"top".as_slice());
/// let model = model
///     .select_file(FileRequest::Open("Cargo.toml".into(), top))
///     .select_file(FileRequest::Position(anchor.clone()));
/// assert_eq!(model.open_file().map(|open| open.position()), Some(&anchor));
/// ```
#[derive(Debug, Clone, PartialEq, Eq)]
pub enum FileRequest {
    /// Select a file, or with `None` select none. No content is read.
    Select(Option<PathBuf>),
    /// Open a file at the given position, replacing any file open before.
    Open(PathBuf, ReadingPosition),
    /// Set the open file's position. With no file open the model is returned unchanged.
    Position(ReadingPosition),
}

/// One folder's direct entries as the model holds them: the entry observations, in the FDR's order,
/// and the public listing derived from them in this one place, so the two cannot disagree.
#[derive(Debug, Clone, PartialEq, Eq)]
struct HeldListing {
    /// The resolved location the listing was read at, where two folder rows that reach one folder
    /// share it.
    identity: PathBuf,
    entries: ItemState<Vec<Entry>>,
    items: Vec<Listed>,
}

impl HeldListing {
    /// The listing `observation` answers for the folder at `identity`. A failed observation has no
    /// location of its own, so the one the request resolved to is kept.
    fn from_observation(identity: PathBuf, observation: ItemState<ListingObservation>) -> Self {
        match observation {
            ItemState::Observed(observed) => Self::from_items(observed.location, observed.items),
            ItemState::Failed(condition) => Self {
                identity,
                entries: ItemState::Failed(condition),
                items: Vec::new(),
            },
            ItemState::Pending => Self {
                identity,
                entries: ItemState::Pending,
                items: Vec::new(),
            },
        }
    }

    fn from_items(identity: PathBuf, items: Vec<Listed>) -> Self {
        let entries = ItemState::Observed(items.iter().map(|item| item.entry.clone()).collect());
        Self {
            identity,
            entries,
            items,
        }
    }
}

/// An opened folder with what has been read of it: the root listing, the listing of every folder
/// the reader has expanded, the reader's place, and the Git item.
///
/// A value: [`read_git`] and the two request operations consume one and return the next, so a
/// caller that keeps one replaces it whole.
///
/// # Examples
///
/// ```
/// use ka_reader_core::{FolderModel, ItemState, open_folder};
///
/// let opened = open_folder(std::env::temp_dir()).expect("the temporary folder opens");
/// let model = FolderModel::new(opened);
/// assert_eq!(model.kind(), &ItemState::Pending);
/// assert!(model.open_file().is_none());
/// ```
#[derive(Debug, Clone, PartialEq, Eq)]
pub struct FolderModel {
    folder: OpenedFolder,
    root_listing: HeldListing,
    /// Every non-root listing read, by the path the reader asked for it with. A folder collapsed
    /// after it was read keeps its listing here.
    listings: BTreeMap<PathBuf, HeldListing>,
    place: ReaderPlace,
    kind: ItemState<FolderKind, GitCondition>,
}

impl FolderModel {
    /// Holds `opened` with its root listing as [`list_tree`] answers it, the arrival place (nothing
    /// expanded, nothing selected, nothing open), and the Git item `Pending`.
    pub fn new(opened: OpenedFolder) -> Self {
        let observation = fs_reader::observe_listing(&opened.root, Path::new(""));
        Self {
            root_listing: HeldListing::from_observation(PathBuf::new(), observation),
            folder: opened,
            listings: BTreeMap::new(),
            place: ReaderPlace::default(),
            kind: ItemState::Pending,
        }
    }

    pub fn folder(&self) -> &OpenedFolder {
        &self.folder
    }

    /// The root listing: the same one [`FolderModel::listing`] holds for the root.
    pub fn tree(&self) -> &ItemState<Vec<Entry>> {
        &self.root_listing.entries
    }

    /// The Git item: `Pending` until [`read_git`] folds an answer in.
    pub fn kind(&self) -> &ItemState<FolderKind, GitCondition> {
        &self.kind
    }

    pub fn place(&self) -> &ReaderPlace {
        &self.place
    }

    /// The model with only its Git item replaced by `item`: the tree, the place and the open file
    /// are carried over unchanged.
    ///
    /// # Examples
    ///
    /// ```
    /// use ka_reader_core::{FolderKind, FolderModel, ItemState, open_folder};
    ///
    /// let opened = open_folder(std::env::temp_dir()).expect("the temporary folder opens");
    /// let model = FolderModel::new(opened).with_git_item(ItemState::Observed(FolderKind::Plain));
    /// assert_eq!(model.kind(), &ItemState::Observed(FolderKind::Plain));
    /// ```
    pub fn with_git_item(self, item: ItemState<FolderKind, GitCondition>) -> Self {
        Self { kind: item, ..self }
    }

    /// The listings this model holds that `earlier` did not hold, or held with other entries or
    /// another state. A listing `earlier` held that this model no longer holds is not listed.
    ///
    /// # Examples
    ///
    /// ```
    /// use std::path::Path;
    /// use ka_reader_core::{FolderModel, open_folder};
    ///
    /// let here = FolderModel::new(open_folder(".").expect("the working folder opens"));
    /// let elsewhere = FolderModel::new(open_folder(std::env::temp_dir()).expect("the temporary folder opens"));
    ///
    /// let changes = here.changes_since(&elsewhere);
    /// let [(path, _listing)] = changes.listings() else { panic!("only the root listing differs") };
    /// assert_eq!(path, Path::new(""));
    /// assert!(here.changes_since(&here).is_empty());
    /// ```
    pub fn changes_since(&self, earlier: &FolderModel) -> TreeChanges {
        let listings = std::iter::once((PathBuf::new(), &self.root_listing))
            .chain(
                self.listings
                    .iter()
                    .map(|(path, held)| (path.clone(), held)),
            )
            .filter(|(path, held)| {
                earlier.held_at(path).map(|before| &before.entries) != Some(&held.entries)
            })
            .map(|(path, held)| (path, held.entries.clone()))
            .collect();
        TreeChanges { listings }
    }

    pub fn open_file(&self) -> Option<&OpenFile> {
        self.place.open_file()
    }

    /// The held direct listing of the folder at `path`: the root for the empty path, any folder the
    /// reader has expanded, and any folder collapsed since. A folder never expanded holds none, and
    /// nothing is read to answer.
    pub fn listing(&self, path: &Path) -> Option<&ItemState<Vec<Entry>>> {
        if path.as_os_str().is_empty() {
            return Some(&self.root_listing.entries);
        }
        self.listings.get(path).map(|held| &held.entries)
    }

    /// Applies a disclosure act or a delta and returns the model that results.
    ///
    /// `Expand` reads the folder's direct listing and holds it; `Collapse` changes only that
    /// folder's flag and reads nothing. A path that does not resolve inside the root to a folder,
    /// and the root itself, leaves the model as it was. `Delta` changes only the held listings that
    /// hold a reported entry, by the reported entries alone, and leaves the place and the Git item
    /// as they were.
    ///
    /// # Examples
    ///
    /// ```
    /// use std::path::{Path, PathBuf};
    /// use ka_reader_core::{FolderModel, TreeRequest, open_folder};
    ///
    /// let opened = open_folder(std::env::temp_dir()).expect("the temporary folder opens");
    /// let model = FolderModel::new(opened).list_tree(TreeRequest::Expand(PathBuf::from("..")));
    /// assert!(!model.place().is_expanded(Path::new("..")));
    /// ```
    pub fn list_tree(self, request: TreeRequest) -> Self {
        match request {
            TreeRequest::Expand(path) => self.expand(path),
            TreeRequest::Collapse(path) => self.collapse(path),
            TreeRequest::Delta(delta) => self.apply_delta(&delta),
            TreeRequest::Invalidate(reports) => self.invalidate(&reports),
        }
    }

    /// Applies a selection, open or position act and returns the model that results.
    ///
    /// `Select` reads no content and changes only the selection. `Open` reads the file as
    /// [`select_file`] does and changes only the open file. `Position` changes only the open file's
    /// position. A path that does not resolve inside the root to a file leaves the model as it was.
    ///
    /// # Examples
    ///
    /// ```
    /// use ka_reader_core::{FileRequest, FolderModel, open_folder};
    ///
    /// let opened = open_folder(std::env::temp_dir()).expect("the temporary folder opens");
    /// let model = FolderModel::new(opened).select_file(FileRequest::Select(None));
    /// assert_eq!(model.place().selected(), None);
    /// ```
    pub fn select_file(self, request: FileRequest) -> Self {
        match request {
            FileRequest::Select(None) => self.with_selection(None),
            FileRequest::Select(Some(path)) => match self.admit(&path, EntryKind::File) {
                Some(_) => self.with_selection(Some(path)),
                None => self,
            },
            FileRequest::Open(path, position) => self.open(path, position),
            FileRequest::Position(position) => self.with_position(position),
        }
    }

    /// Reads each held folder a delta touches once, then hands the report and what was read to the
    /// pure [`reduce`]. A folder the model holds no listing of is never read, so a report inside
    /// one changes nothing.
    fn apply_delta(self, delta: &ModelDelta) -> Self {
        let root = &self.folder.root;
        let held_identities: BTreeSet<&PathBuf> = std::iter::once(&self.root_listing)
            .chain(self.listings.values())
            .map(|held| &held.identity)
            .collect();
        let mut parent_identities: BTreeMap<PathBuf, Option<PathBuf>> = BTreeMap::new();
        let mut reported: BTreeMap<PathBuf, ReportedNames> = BTreeMap::new();
        for (path, removed) in delta.reports() {
            let Some(name) = path.file_name() else {
                continue;
            };
            let parent = path.parent().unwrap_or(Path::new("")).to_path_buf();
            let identity = parent_identities.entry(parent).or_insert_with(|| {
                fs_reader::locate_parent(root, path)
                    .ok()
                    .filter(|location| location.kind == EntryKind::Folder)
                    .map(|location| location.identity)
            });
            let Some(identity) = identity.as_ref().filter(|id| held_identities.contains(id)) else {
                continue;
            };
            let names = reported.entry(identity.clone()).or_default();
            let set = if removed {
                &mut names.removed
            } else {
                &mut names.present
            };
            set.insert(name.to_os_string());
        }
        let changes: BTreeMap<PathBuf, FolderChange> = reported
            .into_iter()
            .map(|(identity, reported)| {
                let observed = fs_reader::observe_listing(root, &identity);
                (identity, FolderChange { reported, observed })
            })
            .collect();
        reduce(self, &changes)
    }

    /// Re-reads the held listings `reports` cover and folds the reads into the model. A batch that
    /// covers nothing leaves the model as it was and reads nothing.
    fn invalidate(self, reports: &PathReports) -> Self {
        let scope = self.invalidation_scope(reports);
        let open_path = self.open_file_to_reread(reports);
        if scope.is_empty() && open_path.is_none() {
            return self;
        }
        let root = self.folder.root.clone();
        let observation = open_path.map(|path| fs_reader::reobserve_file(&root, &path));
        let model = if scope.is_empty() {
            self
        } else {
            let reads = scope
                .into_iter()
                .map(|path| {
                    let observation = fs_reader::observe_listing(&root, &path);
                    (path, observation)
                })
                .collect();
            reduce_invalidation(self, reads, &mut |path| {
                fs_reader::observe_listing(&root, path)
            })
        };
        reduce_open_file(model, observation)
    }

    /// The request paths of the held listings a batch covers. A reported path that lies lexically
    /// under the root reads as its root-relative path; one that does not, or that holds a `.` or
    /// `..` step, reads as the root and covers every listing. A listing is covered by a path when
    /// its request path or its identity is the path, lies under it, or is its parent.
    fn invalidation_scope(&self, reports: &PathReports) -> BTreeSet<PathBuf> {
        let reported: BTreeSet<PathBuf> = reports
            .paths
            .iter()
            .map(|path| self.relative_to_root(path))
            .collect();
        let root_reported = reported.iter().any(|path| path.as_os_str().is_empty());
        std::iter::once((PathBuf::new(), &self.root_listing))
            .chain(
                self.listings
                    .iter()
                    .map(|(path, held)| (path.clone(), held)),
            )
            .filter(|(request, held)| {
                root_reported
                    || reported
                        .iter()
                        .any(|path| covers(request, &held.identity, path))
            })
            .map(|(request, _)| request)
            .collect()
    }

    fn relative_to_root(&self, path: &Path) -> PathBuf {
        match path.strip_prefix(&self.folder.root) {
            Ok(relative)
                if relative
                    .components()
                    .all(|c| matches!(c, Component::Normal(_))) =>
            {
                relative.to_path_buf()
            }
            _ => PathBuf::new(),
        }
    }

    /// Holds `observation` as the listing at the request path `path`, keeping the identity the
    /// listing was held at when the read has none of its own.
    fn hold(&mut self, path: PathBuf, observation: ItemState<ListingObservation>) {
        if path.as_os_str().is_empty() {
            let identity = self.root_listing.identity.clone();
            self.root_listing = HeldListing::from_observation(identity, observation);
            return;
        }
        let identity = self
            .listings
            .get(&path)
            .map_or_else(|| path.clone(), |held| held.identity.clone());
        self.listings
            .insert(path, HeldListing::from_observation(identity, observation));
    }

    /// The held listing requested at `path`, the root's for the empty path.
    fn held_at(&self, path: &Path) -> Option<&HeldListing> {
        if path.as_os_str().is_empty() {
            return Some(&self.root_listing);
        }
        self.listings.get(path)
    }

    /// Whether the listing held at `folder` is observed and lists `name` as a folder.
    fn lists_as_folder(&self, folder: &Path, name: &std::ffi::OsStr) -> bool {
        self.held_at(folder).is_some_and(|held| {
            matches!(held.entries, ItemState::Observed(_))
                && held
                    .items
                    .iter()
                    .any(|item| item.raw_name == name && item.entry.kind == EntryKind::Folder)
        })
    }

    /// Drops every held non-root listing that lies under an ancestor re-read in this request when
    /// that read is not observed or does not list the next path component as a folder. The place is
    /// untouched: the expanded flags of a dropped listing stay.
    fn drop_beneath_gone_folders(&mut self, reread: &BTreeSet<PathBuf>) {
        let gone: Vec<PathBuf> = self
            .listings
            .keys()
            .filter(|path| {
                path.ancestors().skip(1).any(|ancestor| {
                    let depth = ancestor.components().count();
                    reread.contains(ancestor)
                        && path
                            .iter()
                            .nth(depth)
                            .is_some_and(|next| !self.lists_as_folder(ancestor, next))
                })
            })
            .cloned()
            .collect();
        for path in gone {
            self.listings.remove(&path);
        }
    }

    /// Reads, in path order, each path the place holds expanded that has no held listing, when its
    /// parent's held listing is observed and lists it as a folder. The set is walked in path order,
    /// so a parent that returns is held before the children under it are asked about.
    fn return_expanded_folders(
        &mut self,
        more: &mut dyn FnMut(&Path) -> ItemState<ListingObservation>,
    ) {
        let expanded: Vec<PathBuf> = self.place.expanded.iter().cloned().collect();
        for path in expanded {
            if self.listings.contains_key(&path) {
                continue;
            }
            let (Some(parent), Some(name)) = (path.parent(), path.file_name()) else {
                continue;
            };
            if self.lists_as_folder(parent, name) {
                let observation = more(&path);
                self.hold(path, observation);
            }
        }
    }

    /// The location of `path` when it resolves inside the root to something of `kind`.
    fn admit(&self, path: &Path, kind: EntryKind) -> Option<Location> {
        fs_reader::locate(&self.folder.root, path)
            .ok()
            .filter(|location| location.kind == kind)
    }

    fn expand(mut self, path: PathBuf) -> Self {
        let Some(location) = self.admit(&path, EntryKind::Folder) else {
            return self;
        };
        if location.identity.as_os_str().is_empty() {
            return self;
        }
        let observation = fs_reader::observe_listing(&self.folder.root, &path);
        self.listings.insert(
            path.clone(),
            HeldListing::from_observation(location.identity, observation),
        );
        self.place.expanded.insert(path);
        self
    }

    fn collapse(mut self, path: PathBuf) -> Self {
        match self.admit(&path, EntryKind::Folder) {
            Some(location) if !location.identity.as_os_str().is_empty() => {
                self.place.expanded.remove(&path);
            }
            _ => {}
        }
        self
    }

    fn with_selection(mut self, selected: Option<PathBuf>) -> Self {
        self.place.selected = selected;
        self
    }

    fn open(mut self, path: PathBuf, position: ReadingPosition) -> Self {
        let Some(location) = self.admit(&path, EntryKind::File) else {
            return self;
        };
        let view = fs_reader::observe_file(&self.folder.root, &path).map(FileView::from);
        self.place.open_file = Some(OpenFile {
            path,
            position,
            view,
            location: Some(location.identity),
        });
        self
    }

    /// Re-reads the open file, once, whether or not anything was reported, and folds the answer in
    /// beside the open file's path and position. No listing is read or changed, and with no file
    /// open the model is returned as it was.
    ///
    /// # Examples
    ///
    /// ```
    /// use ka_reader_core::{FolderModel, open_folder};
    ///
    /// let opened = open_folder(std::env::temp_dir()).expect("the temporary folder opens");
    /// let model = FolderModel::new(opened);
    /// assert_eq!(model.clone().reread_open_file(), model);
    /// ```
    pub fn reread_open_file(self) -> Self {
        let observation = self
            .place
            .open_file
            .as_ref()
            .map(|open| fs_reader::reobserve_file(&self.folder.root, &open.path));
        reduce_open_file(self, observation)
    }

    /// The path of the open file when a batch covers it, so it is to be read again: the batch
    /// names the root, or a path the open file's path or its resolved location starts with.
    fn open_file_to_reread(&self, reports: &PathReports) -> Option<PathBuf> {
        let open = self.place.open_file.as_ref()?;
        let covered = reports
            .paths
            .iter()
            .map(|path| self.relative_to_root(path))
            .any(|reported| {
                reported.as_os_str().is_empty()
                    || open.path.starts_with(&reported)
                    || open
                        .location
                        .as_deref()
                        .is_some_and(|location| location.starts_with(&reported))
            });
        covered.then(|| open.path.clone())
    }

    fn with_position(mut self, position: ReadingPosition) -> Self {
        if let Some(open_file) = self.place.open_file.as_mut() {
            open_file.position = position;
        }
        self
    }
}

/// The model after the re-read of its open file: `None` is no read and leaves the model as it
/// was; an absent file is held as [`FileView::Gone`]; a read gives the view the content makes, or
/// the failure observed, and the location it resolved to when it has one. The path and the
/// position are the reader's and are never touched. Pure, so a test hands it a supplied read.
fn reduce_open_file(mut model: FolderModel, observation: Option<Reobserved>) -> FolderModel {
    if let (Some(observation), Some(open)) = (observation, model.place.open_file.as_mut()) {
        match observation {
            Reobserved::Absent => open.view = ItemState::Observed(FileView::Gone),
            Reobserved::Read { state, location } => {
                open.view = state.map(FileView::from);
                if location.is_some() {
                    open.location = location;
                }
            }
        }
    }
    model
}

/// Whether the reported path `reported` covers the listing requested at `request` and read at
/// `identity`: it is that path, lies under it, or is its parent.
fn covers(request: &Path, identity: &Path, reported: &Path) -> bool {
    let parent = reported.parent();
    request.starts_with(reported)
        || identity.starts_with(reported)
        || parent == Some(request)
        || parent == Some(identity)
}

/// The model after an invalidation: each re-read in `reads`, keyed by request path, replaces the
/// listing held there whole, then every listing under a folder that is gone goes, then every
/// expanded folder that has no listing and that its parent lists as a folder is read again. Pure,
/// so a test hands it supplied observations; `more` is how it asks for a read of its own.
fn reduce_invalidation(
    mut model: FolderModel,
    reads: BTreeMap<PathBuf, ItemState<ListingObservation>>,
    more: &mut dyn FnMut(&Path) -> ItemState<ListingObservation>,
) -> FolderModel {
    let mut reread = BTreeSet::new();
    for (path, observation) in reads {
        model.hold(path.clone(), observation);
        reread.insert(path);
    }
    model.drop_beneath_gone_folders(&reread);
    model.return_expanded_folders(more);
    model
}

/// The model after a delta: every held listing whose folder `changes` names is reduced, and nothing
/// else moves. It is pure. It takes the held data, the reports and a fresh read of each reported
/// folder, and reads nothing itself, so the place, the open file's content and the Git item are
/// carried from the input and never rebuilt from the listings.
fn reduce(model: FolderModel, changes: &BTreeMap<PathBuf, FolderChange>) -> FolderModel {
    let reduced = |held: HeldListing| match changes.get(&held.identity) {
        Some(change) => reduce_listing(held, change),
        None => held,
    };
    FolderModel {
        root_listing: reduced(model.root_listing),
        listings: model
            .listings
            .into_iter()
            .map(|(path, held)| (path, reduced(held)))
            .collect(),
        ..model
    }
}

/// One held listing after the delta: each entry the delta names is dropped, each one it says exists
/// comes back as its fresh observation (when the fresh read still sees it), every other entry is
/// kept as it was held, and the result is ordered as a fresh listing orders. A name reported both
/// present and removed is decided by the fresh read.
///
/// A listing that is not observed, and a fresh read that failed, leave the held listing as it was:
/// what the model holds for a failed folder read is not this change's to settle.
fn reduce_listing(held: HeldListing, change: &FolderChange) -> HeldListing {
    let (ItemState::Observed(_), ItemState::Observed(fresh)) = (&held.entries, &change.observed)
    else {
        return held;
    };
    let reported = &change.reported;
    let mut items: Vec<Listed> = held
        .items
        .into_iter()
        .filter(|item| {
            !reported.present.contains(&item.raw_name) && !reported.removed.contains(&item.raw_name)
        })
        .collect();
    items.extend(
        fresh
            .items
            .iter()
            .filter(|item| reported.present.contains(&item.raw_name))
            .cloned(),
    );
    order(&mut items);
    HeldListing::from_items(held.identity, items)
}

/// Asks `port` about the model's folder and returns the model with only the Git item replaced:
/// [`read_git_item`] folded in by [`FolderModel::with_git_item`].
pub fn read_git(model: FolderModel, port: &dyn GitPort) -> FolderModel {
    let item = read_git_item(&model.folder, port);
    model.with_git_item(item)
}

/// Asks `port` about `folder` and returns the Git item the answer makes, touching no model.
///
/// `probe` is asked every call, whatever the item held. `state` is asked only where `probe` says
/// `Root`, and `status` only if `state` succeeded, so one read holds the branch element, the
/// repository state and both lists, or the condition of the read that failed, and never a root
/// missing an element. An item that becomes failed emits one `warn` record naming `git-reader`, the
/// operation that failed and a fixed phrase, and never a path.
///
/// # Examples
///
/// ```
/// use ka_reader_core::{FolderKind, GitPort, ItemState, open_folder, read_git_item};
/// # use ka_reader_core::{GitReadCondition, HeadState, RootFinding, StatusLists};
/// # use std::path::Path;
/// # struct Plain;
/// # impl GitPort for Plain {
/// #     fn probe(&self, _: &Path) -> RootFinding { RootFinding::Plain }
/// #     fn state(&self, _: &Path) -> Result<HeadState, GitReadCondition> { Err(GitReadCondition::NotARoot) }
/// #     fn status(&self, _: &Path) -> Result<StatusLists, GitReadCondition> { Err(GitReadCondition::NotARoot) }
/// # }
///
/// let opened = open_folder(std::env::temp_dir()).expect("the temporary folder opens");
/// assert_eq!(read_git_item(&opened, &Plain), ItemState::Observed(FolderKind::Plain));
/// ```
pub fn read_git_item(
    folder: &OpenedFolder,
    port: &dyn GitPort,
) -> ItemState<FolderKind, GitCondition> {
    match ask_git(port, folder.root.as_path()) {
        Ok(observed) => ItemState::Observed(observed),
        Err((condition, operation)) => {
            let phrase = condition.log_phrase();
            log::warn!(
                "git-reader: {operation} failed: {phrase}; the folder stays open without it"
            );
            ItemState::Failed(condition)
        }
    }
}

/// The port's operations one read asks, in order, and the name each is logged under.
const PROBE_OPERATION: &str = "probe";
const STATE_OPERATION: &str = "state";
const STATUS_OPERATION: &str = "status";

/// One read of `root`: what it is, or the condition of the first operation that failed and that
/// operation's name.
fn ask_git(port: &dyn GitPort, root: &Path) -> Result<FolderKind, (GitCondition, &'static str)> {
    match port.probe(root) {
        RootFinding::Plain => Ok(FolderKind::Plain),
        RootFinding::Failed(condition) => Err((GitCondition::Probe(condition), PROBE_OPERATION)),
        RootFinding::Root => {
            let head = port
                .state(root)
                .map_err(|condition| (GitCondition::Read(condition), STATE_OPERATION))?;
            let status = port
                .status(root)
                .map_err(|condition| (GitCondition::Read(condition), STATUS_OPERATION))?;
            Ok(FolderKind::Root(GitState { head, status }))
        }
    }
}

#[cfg(test)]
mod tests {
    use std::path::{Path, PathBuf};

    use std::collections::{BTreeMap, BTreeSet};
    use std::ffi::OsString;

    use super::{
        FileRequest, FileView, FolderChange, FolderKind, FolderModel, GitCondition, HeldListing,
        ItemState, ModelDelta, OpenFailure, OpenFile, OpenFolderOutcome, OpenedFolder, PathReports,
        ReaderPlace, ReadingPosition, ReportedNames, TreeChanges, TreeRequest, list_tree,
        open_folder, read_git, read_git_item, reduce, reduce_invalidation, reduce_open_file,
        select_file,
    };
    use crate::fs_reader::{
        Condition, Entry, EntryKind, FileContent, Listed, ListingObservation, Reobserved,
    };
    use crate::git_reader::ProbeCondition;
    use crate::git_reader::{GitPort, GitReadCondition, HeadState, RootFinding, StatusLists};
    use crate::language::Language;
    use crate::test_support::TempDir;

    #[test]
    fn test_open_folder_returns_opened_for_a_readable_plain_folder() {
        let folder = TempDir::new();

        assert!(matches!(
            open_folder(folder.path()),
            OpenFolderOutcome::Opened(_)
        ));
    }

    #[test]
    fn test_open_folder_returns_each_closed_failure() {
        let folder = TempDir::new();
        let file = folder.write_file("note.txt", "");
        let missing = folder.path().join("missing");

        assert_eq!(
            open_folder(missing),
            OpenFolderOutcome::Failed(OpenFailure::Missing)
        );
        assert_eq!(
            open_folder(file),
            OpenFolderOutcome::Failed(OpenFailure::NotAFolder)
        );
    }

    /// A project-shaped folder: a root file, nested folders, a `.git` entry and a file to open.
    fn project() -> TempDir {
        let folder = TempDir::new();
        folder.write_file("README.md", "# readme\n");
        folder.write_file("src/main.rs", "fn main() {}\n");
        folder.write_file("src/util.rs", "// util\n");
        folder.write_file("src/lib/a.rs", "// a\n");
        folder.write_file("docs/guide.md", "guide\n");
        folder.write_file("tests/b.rs", "// b\n");
        folder.write_file(".git/HEAD", "ref: refs/heads/main\n");
        folder
    }

    fn model_over(folder: &TempDir) -> FolderModel {
        FolderModel::new(open_folder(folder.path()).expect("the project folder opens"))
    }

    fn expand(model: FolderModel, path: &str) -> FolderModel {
        model.list_tree(TreeRequest::Expand(PathBuf::from(path)))
    }

    fn collapse(model: FolderModel, path: &str) -> FolderModel {
        model.list_tree(TreeRequest::Collapse(PathBuf::from(path)))
    }

    fn select(model: FolderModel, path: &str) -> FolderModel {
        model.select_file(FileRequest::Select(Some(PathBuf::from(path))))
    }

    fn open(model: FolderModel, path: &str, position: &ReadingPosition) -> FolderModel {
        model.select_file(FileRequest::Open(PathBuf::from(path), position.clone()))
    }

    fn position(bytes: &[u8]) -> ReadingPosition {
        ReadingPosition::new(bytes)
    }

    #[test]
    fn test_a_new_model_holds_the_arrival_state() {
        let folder = project();
        let model = model_over(&folder);

        assert_eq!(model.place(), &ReaderPlace::default());
        for path in ["src", "docs", "tests", ".git"] {
            assert!(!model.place().is_expanded(Path::new(path)), "{path}");
        }
        assert_eq!(model.place().selected(), None);
        assert!(model.open_file().is_none());
    }

    #[test]
    fn test_no_open_file_means_no_reading_position() {
        let folder = project();
        let model = select(model_over(&folder), "src/main.rs");

        assert!(model.open_file().is_none());
        assert!(model.place().open_file().is_none());
    }

    #[test]
    fn test_position_without_an_open_file_leaves_the_model_equal() {
        let folder = project();
        let model = select(expand(model_over(&folder), "src"), "src/util.rs");

        let after = model
            .clone()
            .select_file(FileRequest::Position(position(b"line 400")));

        assert_eq!(after, model);
        assert!(after.open_file().is_none());
    }

    #[test]
    fn test_selection_and_open_file_are_held_independently() {
        let folder = project();
        let held = position(b"top");

        let model = open(
            select(model_over(&folder), "src/util.rs"),
            "src/main.rs",
            &held,
        );

        assert_eq!(model.place().selected(), Some(Path::new("src/util.rs")));
        let open_file = model.open_file().expect("a file is open");
        assert_eq!(open_file.path(), Path::new("src/main.rs"));
        assert_eq!(open_file.position(), &held);
    }

    #[test]
    fn test_selecting_does_not_open_or_close_the_open_file() {
        let folder = project();
        let held = position(b"top");
        let opened = open(model_over(&folder), "src/main.rs", &held);

        let selected = select(opened.clone(), "src/util.rs");
        let cleared = selected.clone().select_file(FileRequest::Select(None));

        assert_eq!(selected.open_file(), opened.open_file());
        assert_eq!(cleared.open_file(), opened.open_file());
        assert!(
            select(model_over(&folder), "src/util.rs")
                .open_file()
                .is_none()
        );
    }

    #[test]
    fn test_select_none_clears_the_selection() {
        let folder = project();
        let model = select(model_over(&folder), "src/main.rs");
        assert_eq!(model.place().selected(), Some(Path::new("src/main.rs")));

        let cleared = model.select_file(FileRequest::Select(None));

        assert_eq!(cleared.place().selected(), None);
        assert_eq!(cleared.place(), &ReaderPlace::default());
    }

    /// A file whose content cannot be read is still selected, and selecting opens nothing. A read
    /// made and then ignored is not observable here, so this case does not claim no read happens.
    #[test]
    fn test_selecting_an_unreadable_file_selects_it_and_opens_nothing() {
        let folder = project();
        folder.set_mode("src/util.rs", 0o000);

        let model = select(model_over(&folder), "src/util.rs");

        assert_eq!(model.place().selected(), Some(Path::new("src/util.rs")));
        assert!(model.open_file().is_none());
    }

    #[test]
    fn test_expansion_is_the_last_act_on_that_folder() {
        let folder = project();
        let model = model_over(&folder);

        let expanded = expand(model.clone(), "docs");
        let collapsed = collapse(expanded.clone(), "docs");
        let reexpanded = expand(collapsed.clone(), "docs");

        assert!(expanded.place().is_expanded(Path::new("docs")));
        assert!(!collapsed.place().is_expanded(Path::new("docs")));
        assert!(reexpanded.place().is_expanded(Path::new("docs")));
        assert_eq!(collapsed.place(), model.place());

        // The reverse: collapse, expand, collapse reads collapsed.
        let first_collapse = collapse(model, "docs");
        let then_expanded = expand(first_collapse.clone(), "docs");
        let last_collapse = collapse(then_expanded.clone(), "docs");

        assert!(!first_collapse.place().is_expanded(Path::new("docs")));
        assert!(then_expanded.place().is_expanded(Path::new("docs")));
        assert!(!last_collapse.place().is_expanded(Path::new("docs")));
    }

    #[test]
    fn test_expanding_holds_the_folders_direct_listing_as_a_fresh_list_tree_reads_it() {
        let folder = project();
        let opened = open_folder(folder.path()).expect("opens");

        let model = expand(model_over(&folder), "src");

        assert_eq!(
            model.listing(Path::new("src")),
            Some(&list_tree(&opened, "src"))
        );
    }

    #[test]
    fn test_collapsing_a_parent_keeps_every_descendants_flag_and_listing() {
        let folder = project();
        let model = expand(expand(model_over(&folder), "src"), "src/lib");
        let child_listing = model.listing(Path::new("src/lib")).cloned();
        let parent_listing = model.listing(Path::new("src")).cloned();

        let collapsed = collapse(model, "src");

        assert!(!collapsed.place().is_expanded(Path::new("src")));
        assert!(collapsed.place().is_expanded(Path::new("src/lib")));
        assert_eq!(
            collapsed.listing(Path::new("src/lib")).cloned(),
            child_listing
        );
        assert_eq!(collapsed.listing(Path::new("src")).cloned(), parent_listing);
    }

    #[test]
    fn test_collapse_of_a_never_expanded_folder_holds_it_collapsed() {
        let folder = project();
        let model = model_over(&folder);

        let collapsed = collapse(model.clone(), "tests");

        assert!(!collapsed.place().is_expanded(Path::new("tests")));
        assert!(collapsed.listing(Path::new("tests")).is_none());
        assert_eq!(collapsed, model);
    }

    #[test]
    fn test_open_replaces_the_previous_open_file_and_its_position() {
        let folder = project();
        let first = position(b"first");
        let second = position(b"second");

        let model = open(
            open(model_over(&folder), "src/main.rs", &first),
            "src/util.rs",
            &second,
        );

        let open_file = model.open_file().expect("a file is open");
        assert_eq!(open_file.path(), Path::new("src/util.rs"));
        assert_eq!(open_file.position(), &second);
    }

    #[test]
    fn test_open_holds_the_file_view_as_select_file_reads_it() {
        let folder = project();
        let opened = open_folder(folder.path()).expect("opens");

        let model = open(model_over(&folder), "src/main.rs", &position(b"top"));

        assert_eq!(
            model.open_file().expect("a file is open").view(),
            &select_file(&opened, "src/main.rs")
        );
        assert!(matches!(
            model.open_file().expect("a file is open").view(),
            ItemState::Observed(FileView::Text { .. })
        ));
    }

    #[test]
    fn test_the_reading_position_round_trips_byte_for_byte() {
        let folder = project();
        // A caller-chosen anchor for line 400 with finer offsets, then bytes that are not text.
        let anchors: [&[u8]; 3] = [b"line=400;offset=0.25", &[0xFF, 0x00, 0x80, 0xC3], &[]];

        for bytes in anchors {
            let model = open(model_over(&folder), "src/main.rs", &position(bytes));

            let open_file = model.open_file().expect("a file is open");
            assert_eq!(open_file.position().as_bytes(), bytes);
        }
    }

    #[test]
    fn test_a_distinct_position_set_later_reads_back_as_the_later_one() {
        let folder = project();
        let model = open(model_over(&folder), "src/main.rs", &position(b"line=400"));

        let later = model.select_file(FileRequest::Position(position(b"line=912")));

        let open_file = later.open_file().expect("a file is open");
        assert_eq!(open_file.position(), &position(b"line=912"));
        assert_eq!(open_file.path(), Path::new("src/main.rs"));
    }

    #[test]
    fn test_open_of_a_path_that_is_not_a_file_leaves_the_model_equal_to_its_input() {
        let folder = project();
        let model = open(model_over(&folder), "src/main.rs", &position(b"top"));

        for path in ["src", "missing.rs", "src/missing.rs"] {
            assert_eq!(open(model.clone(), path, &position(b"x")), model, "{path}");
        }
    }

    #[test]
    fn test_select_of_a_path_that_is_not_a_file_leaves_the_model_equal_to_its_input() {
        let folder = project();
        let model = select(model_over(&folder), "src/main.rs");

        for path in ["src", "missing.rs"] {
            assert_eq!(select(model.clone(), path), model, "{path}");
        }
    }

    #[test]
    fn test_expand_of_a_file_path_leaves_the_model_equal_to_its_input() {
        let folder = project();
        let model = expand(model_over(&folder), "src");

        for path in ["src/main.rs", "missing"] {
            assert_eq!(expand(model.clone(), path), model, "{path}");
        }
    }

    #[test]
    fn test_the_root_is_not_a_disclosure_target() {
        let folder = project();
        let model = model_over(&folder);

        for path in ["", ".", "src/.."] {
            assert_eq!(expand(model.clone(), path), model, "expand {path:?}");
            assert_eq!(collapse(model.clone(), path), model, "collapse {path:?}");
        }
    }

    #[test]
    fn test_a_request_outside_the_root_leaves_the_model_equal_to_its_input() {
        let folder = project();
        let model = open(
            expand(model_over(&folder), "src"),
            "src/main.rs",
            &position(b"top"),
        );

        assert_eq!(expand(model.clone(), ".."), model);
        assert_eq!(collapse(model.clone(), "../x"), model);
        assert_eq!(select(model.clone(), "../x"), model);
        assert_eq!(open(model.clone(), "../x", &position(b"y")), model);
    }

    struct PlainFolder;

    impl GitPort for PlainFolder {
        fn probe(&self, _: &Path) -> RootFinding {
            RootFinding::Plain
        }

        fn state(&self, _: &Path) -> Result<HeadState, GitReadCondition> {
            Err(GitReadCondition::NotARoot)
        }

        fn status(&self, _: &Path) -> Result<StatusLists, GitReadCondition> {
            Err(GitReadCondition::NotARoot)
        }
    }

    #[test]
    fn test_read_git_preserves_the_place_and_every_non_git_listing() {
        let folder = project();
        let model = open(
            select(
                expand(expand(model_over(&folder), "src"), "docs"),
                "src/util.rs",
            ),
            "src/main.rs",
            &position(b"line=400"),
        );

        let read = read_git(model.clone(), &PlainFolder);

        assert_eq!(read.kind(), &ItemState::Observed(FolderKind::Plain));
        assert_eq!(read.place(), model.place());
        assert_eq!(read.tree(), model.tree());
        for path in ["src", "docs"] {
            assert_eq!(
                read.listing(Path::new(path)),
                model.listing(Path::new(path))
            );
        }
    }

    #[test]
    fn test_with_git_item_changes_only_the_git_item() {
        let folder = project();
        let model = open(
            select(expand(model_over(&folder), "src"), "src/util.rs"),
            "src/main.rs",
            &position(b"line=7"),
        );
        let item = ItemState::Observed(FolderKind::Plain);

        let replaced = model.clone().with_git_item(item.clone());

        assert_eq!(replaced.kind(), &item);
        assert_eq!(replaced.tree(), model.tree());
        assert_eq!(replaced.place(), model.place());
        assert_eq!(replaced.open_file(), model.open_file());
        assert_eq!(
            replaced.listing(Path::new("src")),
            model.listing(Path::new("src"))
        );
    }

    #[test]
    fn test_read_git_is_the_composition_of_the_two_and_answers_as_before() {
        let folder = project();
        let model = expand(model_over(&folder), "src");

        let item = read_git_item(model.folder(), &PlainFolder);
        let composed = model.clone().with_git_item(item.clone());

        assert_eq!(item, ItemState::Observed(FolderKind::Plain));
        assert_eq!(read_git(model, &PlainFolder), composed);
    }

    #[test]
    fn test_root_names_the_canonical_root() {
        let folder = project();
        folder.make_link("link-to-the-project", folder.path());
        let link = folder.path().join("link-to-the-project");

        let opened = open_folder(&link).expect("the link opens");

        assert_eq!(opened.root(), folder.path());
        assert_ne!(opened.root(), link.as_path());
    }

    #[test]
    fn test_tree_is_the_root_projection_of_the_held_root_listing() {
        let folder = project();
        let opened = open_folder(folder.path()).expect("opens");
        let model = expand(model_over(&folder), "src");

        assert_eq!(model.tree(), &list_tree(&opened, ""));
        assert_eq!(model.listing(Path::new("")), Some(model.tree()));
        assert_eq!(model.listing(Path::new("never-expanded")), None);
    }

    #[test]
    fn test_a_failed_root_listing_is_held_as_the_failure() {
        let folder = project();
        let model = model_over(&folder);
        folder.set_mode("", 0o000);

        let unreadable = FolderModel::new(model.folder().clone());

        assert_eq!(unreadable.tree(), &ItemState::Failed(Condition::Unreadable));
        assert_eq!(unreadable.listing(Path::new("")), Some(unreadable.tree()));
    }

    // ---- The pure reducer: held data, observed values and a report, and no disk ----

    fn listed(identity: &str, name: &str, kind: EntryKind) -> Listed {
        listed_with_state(identity, name, kind, None)
    }

    /// An entry as a listing of the folder at `identity` gives it; `state` overrides the usual one.
    fn listed_with_state(
        identity: &str,
        name: &str,
        kind: EntryKind,
        state: Option<ItemState<()>>,
    ) -> Listed {
        let usual = match kind {
            EntryKind::Folder => ItemState::Pending,
            EntryKind::File => ItemState::Observed(()),
        };
        Listed {
            raw_name: OsString::from(name),
            entry: Entry {
                name: name.to_string(),
                path: PathBuf::from(identity)
                    .join(name)
                    .to_string_lossy()
                    .into_owned(),
                kind,
                state: state.unwrap_or(usual),
                language: (kind == EntryKind::File).then_some(Language::Plain),
            },
        }
    }

    fn held(identity: &str, entries: &[(&str, EntryKind)]) -> HeldListing {
        HeldListing::from_items(
            PathBuf::from(identity),
            entries
                .iter()
                .map(|(name, kind)| listed(identity, name, *kind))
                .collect(),
        )
    }

    /// A model over a root that is never read: every value in it is supplied here.
    fn supplied_model(
        root: HeldListing,
        listings: &[(&str, HeldListing)],
        place: ReaderPlace,
    ) -> FolderModel {
        FolderModel {
            folder: OpenedFolder {
                root: PathBuf::from("/a/root/that/is/not/read"),
            },
            root_listing: root,
            listings: listings
                .iter()
                .map(|(path, listing)| (PathBuf::from(path), listing.clone()))
                .collect(),
            place,
            kind: ItemState::Pending,
        }
    }

    fn names_in(listing: &HeldListing) -> Vec<&str> {
        listing
            .items
            .iter()
            .map(|item| item.entry.name.as_str())
            .collect()
    }

    fn names(present: &[&str], removed: &[&str]) -> ReportedNames {
        ReportedNames {
            present: present.iter().map(OsString::from).collect(),
            removed: removed.iter().map(OsString::from).collect(),
        }
    }

    /// One folder's change: the names reported and what a fresh read of the folder saw.
    fn change(
        reported: ReportedNames,
        identity: &str,
        seen: Vec<Listed>,
    ) -> BTreeMap<PathBuf, FolderChange> {
        let mut seen = seen;
        crate::fs_reader::order(&mut seen);
        BTreeMap::from([(
            PathBuf::from(identity),
            FolderChange {
                reported,
                observed: ItemState::Observed(ListingObservation {
                    location: PathBuf::from(identity),
                    items: seen,
                }),
            },
        )])
    }

    fn root_of(model: &FolderModel) -> Vec<&str> {
        names_in(&model.root_listing)
    }

    const FILE: EntryKind = EntryKind::File;
    const FOLDER: EntryKind = EntryKind::Folder;

    // ---- Invalidate: the pure fold over supplied observations ----

    const SUPPLIED_ROOT: &str = "/a/root/that/is/not/read";

    /// A fresh observation of the folder at `identity`, as a read of it would answer.
    fn observed(identity: &str, entries: &[(&str, EntryKind)]) -> ItemState<ListingObservation> {
        let mut items: Vec<Listed> = entries
            .iter()
            .map(|(name, kind)| listed(identity, name, *kind))
            .collect();
        crate::fs_reader::order(&mut items);
        ItemState::Observed(ListingObservation {
            location: PathBuf::from(identity),
            items,
        })
    }

    fn reports(paths: &[&str]) -> PathReports {
        PathReports::new(
            paths
                .iter()
                .map(|path| Path::new(SUPPLIED_ROOT).join(path))
                .collect(),
        )
    }

    fn keys(set: &BTreeSet<PathBuf>) -> Vec<&str> {
        set.iter()
            .map(|path| path.to_str().expect("UTF-8"))
            .collect()
    }

    /// Applies supplied reads and fails the test if the fold asks for a read of its own.
    fn fold(model: FolderModel, reads: Vec<(&str, ItemState<ListingObservation>)>) -> FolderModel {
        let reads = reads
            .into_iter()
            .map(|(path, observation)| (PathBuf::from(path), observation))
            .collect();
        reduce_invalidation(model, reads, &mut |path| {
            panic!("the fold asked for a read of {}", path.display())
        })
    }

    fn scoped_model() -> FolderModel {
        supplied_model(
            held(
                "",
                &[
                    ("docs", FOLDER),
                    ("link", FOLDER),
                    ("other", FOLDER),
                    ("src", FOLDER),
                ],
            ),
            &[
                ("link", held("docs", &[("guide.md", FILE)])),
                ("other", held("other", &[("o.rs", FILE)])),
                ("src", held("src", &[("lib", FOLDER), ("main.rs", FILE)])),
                ("src/lib", held("src/lib", &[("mod.rs", FILE)])),
            ],
            ReaderPlace::default(),
        )
    }

    #[test]
    fn test_an_observed_reread_replaces_the_held_listing_whole() {
        let model = supplied_model(
            held("", &[("a.rs", FILE), ("src", FOLDER)]),
            &[],
            ReaderPlace::default(),
        );

        let after = fold(
            model,
            vec![(
                "",
                observed("", &[("a.rs", FILE), ("b.rs", FILE), ("src", FOLDER)]),
            )],
        );

        assert_eq!(root_of(&after), vec!["src", "a.rs", "b.rs"]);
        assert_eq!(
            after.tree(),
            &ItemState::Observed(
                ["src", "a.rs", "b.rs"]
                    .iter()
                    .map(|name| {
                        let kind = if *name == "src" { FOLDER } else { FILE };
                        listed("", name, kind).entry
                    })
                    .collect()
            )
        );
    }

    #[test]
    fn test_an_empty_report_batch_is_the_identity() {
        let model = scoped_model();

        assert!(model.invalidation_scope(&reports(&[])).is_empty());
        assert_eq!(
            model
                .clone()
                .list_tree(TreeRequest::Invalidate(reports(&[]))),
            model
        );
    }

    #[test]
    fn test_a_path_outside_the_root_reads_as_the_root() {
        let model = scoped_model();
        let outside = PathReports::new(vec![PathBuf::from("/elsewhere/entirely/x.rs")]);
        let dotted = PathReports::new(vec![Path::new(SUPPLIED_ROOT).join("src/../../x")]);

        for batch in [outside, dotted] {
            assert_eq!(
                keys(&model.invalidation_scope(&batch)),
                vec!["", "link", "other", "src", "src/lib"]
            );
        }
    }

    #[test]
    fn test_scope_matches_request_path_and_identity() {
        let model = scoped_model();
        let scope = |paths: &[&str]| keys(&model.invalidation_scope(&reports(paths))).join(",");

        // equal to, under, and the parent of a listing, by its request path
        assert_eq!(scope(&["src"]), ",src,src/lib");
        assert_eq!(scope(&["src/main.rs"]), "src");
        assert_eq!(scope(&["src/lib/mod.rs"]), "src/lib");
        // by its identity: the row `link` reads the folder `docs`
        assert_eq!(scope(&["docs"]), ",link");
        assert_eq!(scope(&["docs/guide.md"]), "link");
        assert_eq!(scope(&["link"]), ",link");
        // an unrelated sibling is not in scope
        assert_eq!(scope(&["unrelated/x.rs"]), "");
        assert_eq!(scope(&["other/o.rs", "src/main.rs"]), "other,src");
        // a root report covers every held listing
        assert_eq!(scope(&[""]), ",link,other,src,src/lib");
    }

    #[test]
    fn test_a_report_naming_the_roots_git_entry_is_in_scope() {
        let model = scoped_model();
        let batch = reports(&[".git"]);

        assert_eq!(keys(&model.invalidation_scope(&batch)), vec![""]);
        let after = fold(
            model,
            vec![("", observed("", &[(".git", FOLDER), ("docs", FOLDER)]))],
        );
        assert_eq!(root_of(&after), vec![".git", "docs"]);
    }

    #[test]
    fn test_a_failed_reread_marks_the_listing_failed_with_the_observed_condition() {
        let after = fold(
            scoped_model(),
            vec![("src", ItemState::Failed(Condition::Unreadable))],
        );

        let listing = &after.listings[Path::new("src")];
        assert_eq!(listing.entries, ItemState::Failed(Condition::Unreadable));
        assert!(listing.items.is_empty());
        assert_eq!(
            after.listing(Path::new("other")),
            scoped_model().listing(Path::new("other"))
        );
    }

    // ---- Invalidate: the drop pass ----

    fn expanded_place(expanded: &[&str], selected: &str) -> ReaderPlace {
        ReaderPlace {
            expanded: expanded.iter().map(PathBuf::from).collect(),
            selected: Some(PathBuf::from(selected)),
            open_file: None,
        }
    }

    /// A model that holds `src`, `src/lib` and `src/lib/deep`, all expanded, with a file selected.
    fn nested_model() -> FolderModel {
        supplied_model(
            held("", &[("other", FOLDER), ("src", FOLDER)]),
            &[
                ("other", held("other", &[("o.rs", FILE)])),
                ("src", held("src", &[("lib", FOLDER), ("main.rs", FILE)])),
                (
                    "src/lib",
                    held("src/lib", &[("deep", FOLDER), ("mod.rs", FILE)]),
                ),
                ("src/lib/deep", held("src/lib/deep", &[("d.rs", FILE)])),
            ],
            expanded_place(&["src", "src/lib", "src/lib/deep"], "src/lib/mod.rs"),
        )
    }

    fn held_paths(model: &FolderModel) -> Vec<&str> {
        model
            .listings
            .keys()
            .map(|path| path.to_str().expect("UTF-8"))
            .collect()
    }

    #[test]
    fn test_a_failed_reread_drops_every_listing_beneath_it_and_keeps_the_place() {
        let before = nested_model();

        let after = fold(
            before.clone(),
            vec![("src", ItemState::Failed(Condition::Unreadable))],
        );

        assert_eq!(held_paths(&after), vec!["other", "src"]);
        assert_eq!(
            after.listing(Path::new("src")),
            Some(&ItemState::Failed(Condition::Unreadable))
        );
        assert_eq!(after.place(), before.place());
    }

    #[test]
    fn test_a_missing_entry_drops_the_listing_under_it() {
        let after = fold(
            nested_model(),
            vec![("src", observed("src", &[("main.rs", FILE)]))],
        );

        assert_eq!(held_paths(&after), vec!["other", "src"]);
        assert!(after.place().is_expanded(Path::new("src/lib")));
    }

    #[test]
    fn test_an_entry_that_is_now_a_file_drops_the_listing_under_it() {
        let after = fold(
            nested_model(),
            vec![("src", observed("src", &[("lib", FILE), ("main.rs", FILE)]))],
        );

        assert_eq!(held_paths(&after), vec!["other", "src"]);
        assert!(after.place().is_expanded(Path::new("src/lib")));
    }

    #[test]
    fn test_a_removed_folder_is_dropped_rather_than_drawn_as_a_failure() {
        let after = fold(
            nested_model(),
            vec![
                ("", observed("", &[("other", FOLDER)])),
                ("src", ItemState::Failed(Condition::Missing)),
            ],
        );

        assert_eq!(held_paths(&after), vec!["other"]);
        assert_eq!(after.listing(Path::new("src")), None);
        assert!(after.place().is_expanded(Path::new("src")));
    }

    #[test]
    fn test_a_listing_under_a_folder_the_reread_still_lists_is_kept() {
        let before = nested_model();

        let after = fold(
            before.clone(),
            vec![(
                "src",
                observed(
                    "src",
                    &[("lib", FOLDER), ("main.rs", FILE), ("new.rs", FILE)],
                ),
            )],
        );

        assert_eq!(held_paths(&after), held_paths(&before));
        assert_eq!(
            after.listing(Path::new("src/lib")),
            before.listing(Path::new("src/lib"))
        );
    }

    // ---- Invalidate: the return pass ----

    /// Applies supplied reads, answers each read the fold asks for with `answer`, and returns the
    /// model with the paths the fold read, in the order it read them.
    fn fold_returning(
        model: FolderModel,
        reads: Vec<(&str, ItemState<ListingObservation>)>,
        answer: impl Fn(&Path) -> ItemState<ListingObservation>,
    ) -> (FolderModel, Vec<String>) {
        let reads = reads
            .into_iter()
            .map(|(path, observation)| (PathBuf::from(path), observation))
            .collect();
        let mut asked = Vec::new();
        let model = reduce_invalidation(model, reads, &mut |path| {
            asked.push(path.to_str().expect("UTF-8").to_owned());
            answer(path)
        });
        (model, asked)
    }

    #[test]
    fn test_the_return_pass_reads_only_expanded_paths_whose_parent_lists_them_as_folders() {
        let model = supplied_model(
            held("", &[("src", FOLDER)]),
            &[("src", held("src", &[("old.rs", FILE)]))],
            expanded_place(
                &[
                    "src",
                    "src/lib",
                    "src/mod.rs",
                    "src/gone",
                    "nowhere/deep",
                    "src/lib/deep",
                ],
                "src/mod.rs",
            ),
        );

        let (after, asked) = fold_returning(
            model,
            vec![(
                "src",
                observed(
                    "src",
                    &[("lib", FOLDER), ("mod.rs", FILE), ("other", FOLDER)],
                ),
            )],
            |path| match path.to_str().expect("UTF-8") {
                "src/lib" => observed("src/lib", &[("deep", FOLDER)]),
                "src/lib/deep" => observed("src/lib/deep", &[("d.rs", FILE)]),
                other => panic!("the return pass read {other}"),
            },
        );

        assert_eq!(asked, vec!["src/lib", "src/lib/deep"]);
        assert_eq!(held_paths(&after), vec!["src", "src/lib", "src/lib/deep"]);
    }

    #[test]
    fn test_a_parent_returns_before_its_children() {
        let model = supplied_model(
            held("", &[("a", FOLDER)]),
            &[],
            expanded_place(&["a/b/c", "a", "a/b"], "a"),
        );

        let (after, asked) = fold_returning(
            model,
            vec![("", observed("", &[("a", FOLDER)]))],
            |path| match path.to_str().expect("UTF-8") {
                "a" => observed("a", &[("b", FOLDER)]),
                "a/b" => observed("a/b", &[("c", FOLDER)]),
                "a/b/c" => observed("a/b/c", &[("leaf.rs", FILE)]),
                other => panic!("the return pass read {other}"),
            },
        );

        assert_eq!(asked, vec!["a", "a/b", "a/b/c"]);
        assert_eq!(held_paths(&after), vec!["a", "a/b", "a/b/c"]);
    }

    // ---- changes_since ----

    fn changed_paths(changes: &TreeChanges) -> Vec<&str> {
        changes
            .listings()
            .iter()
            .map(|(path, _)| path.to_str().expect("UTF-8"))
            .collect()
    }

    fn two_listings(root: HeldListing, a: HeldListing, b: HeldListing) -> FolderModel {
        supplied_model(
            root,
            &[("a", a), ("b", b)],
            expanded_place(&["a", "b"], "a"),
        )
    }

    #[test]
    fn test_changes_since_lists_new_changed_and_failed_listings() {
        let earlier = supplied_model(
            held("", &[("a", FOLDER), ("b", FOLDER), ("c", FOLDER)]),
            &[
                ("a", held("a", &[("x.rs", FILE)])),
                ("b", held("b", &[("y.rs", FILE)])),
            ],
            expanded_place(&["a", "b"], "a"),
        );
        let mut later = earlier.clone();
        later.listings.insert(
            PathBuf::from("a"),
            held("a", &[("x.rs", FILE), ("z.rs", FILE)]),
        );
        later.listings.insert(
            PathBuf::from("b"),
            HeldListing::from_observation(
                PathBuf::from("b"),
                ItemState::Failed(Condition::Unreadable),
            ),
        );
        later
            .listings
            .insert(PathBuf::from("c"), held("c", &[("w.rs", FILE)]));

        let changes = later.changes_since(&earlier);

        assert_eq!(changed_paths(&changes), vec!["a", "b", "c"]);
        assert_eq!(
            changes.listings()[1].1,
            ItemState::Failed(Condition::Unreadable)
        );
        assert_eq!(
            changes.listings()[0].1,
            later.listing(Path::new("a")).cloned().expect("held")
        );
    }

    #[test]
    fn test_changes_since_never_lists_a_dropped_listing() {
        let earlier = nested_model();
        let mut later = earlier.clone();
        later.listings.remove(Path::new("src/lib"));
        later.listings.remove(Path::new("src/lib/deep"));

        let changes = later.changes_since(&earlier);

        assert!(changes.is_empty());
    }

    #[test]
    fn test_changes_are_in_path_order_with_the_root_first() {
        let earlier = two_listings(
            held("", &[("a", FOLDER), ("b", FOLDER)]),
            held("a", &[]),
            held("b", &[]),
        );
        let mut later = earlier.clone();
        later.root_listing = held("", &[("a", FOLDER), ("b", FOLDER), ("r.rs", FILE)]);
        later
            .listings
            .insert(PathBuf::from("b"), held("b", &[("b.rs", FILE)]));
        later
            .listings
            .insert(PathBuf::from("a/c"), held("a/c", &[("c.rs", FILE)]));
        later
            .listings
            .insert(PathBuf::from("a"), held("a", &[("a.rs", FILE)]));

        let changes = later.changes_since(&earlier);

        assert_eq!(changed_paths(&changes), vec!["", "a", "a/c", "b"]);
    }

    #[test]
    fn test_identical_models_have_empty_changes() {
        let model = nested_model();

        assert!(model.changes_since(&model).is_empty());
        assert!(model.changes_since(&model.clone()).is_empty());
    }

    #[test]
    fn test_a_created_path_is_listed_in_its_held_parent() {
        let model = supplied_model(
            held("", &[("a.rs", FILE), ("src", FOLDER)]),
            &[],
            ReaderPlace::default(),
        );
        let seen = vec![
            listed("", "a.rs", FILE),
            listed("", "b.rs", FILE),
            listed("", "src", FOLDER),
        ];

        let after = reduce(model, &change(names(&["b.rs"], &[]), "", seen));

        assert_eq!(root_of(&after), ["src", "a.rs", "b.rs"]);
    }

    #[test]
    fn test_a_changed_path_is_listed_as_its_fresh_observation() {
        let model = supplied_model(
            held("", &[("a.rs", FILE), ("b.rs", FILE)]),
            &[],
            ReaderPlace::default(),
        );
        let unreadable = listed_with_state(
            "",
            "a.rs",
            FILE,
            Some(ItemState::Failed(Condition::Unreadable)),
        );

        let after = reduce(
            model,
            &change(
                names(&["a.rs"], &[]),
                "",
                vec![unreadable.clone(), listed("", "b.rs", FILE)],
            ),
        );

        assert_eq!(after.root_listing.items[0], unreadable);
        assert_eq!(
            after.tree(),
            &ItemState::Observed(vec![unreadable.entry, listed("", "b.rs", FILE).entry])
        );
    }

    #[test]
    fn test_a_removed_path_is_not_listed() {
        let model = supplied_model(
            held("", &[("a.rs", FILE), ("b.rs", FILE)]),
            &[],
            ReaderPlace::default(),
        );

        let after = reduce(
            model,
            &change(names(&[], &["a.rs"]), "", vec![listed("", "b.rs", FILE)]),
        );

        assert_eq!(root_of(&after), ["b.rs"]);
    }

    #[test]
    fn test_created_changed_and_removed_in_one_batch() {
        let model = supplied_model(
            held(
                "",
                &[("gone.md", FILE), ("keep.md", FILE), ("util.rs", FILE)],
            ),
            &[],
            ReaderPlace::default(),
        );
        let seen = vec![
            listed("", "keep.md", FILE),
            listed("", "new.rs", FILE),
            listed("", "util.rs", FOLDER),
        ];

        let after = reduce(
            model,
            &change(names(&["new.rs", "util.rs"], &["gone.md"]), "", seen),
        );

        assert_eq!(root_of(&after), ["util.rs", "keep.md", "new.rs"]);
        assert_eq!(after.root_listing.items[0].entry.kind, FOLDER);
    }

    #[test]
    fn test_a_changed_entry_that_moves_between_folder_and_file_groups_is_reordered() {
        let model = supplied_model(
            held("", &[("alpha", FOLDER), ("beta", FILE), ("zeta", FILE)]),
            &[],
            ReaderPlace::default(),
        );
        let seen = vec![
            listed("", "alpha", FOLDER),
            listed("", "beta", FOLDER),
            listed("", "zeta", FILE),
        ];

        let after = reduce(model, &change(names(&["beta"], &[]), "", seen));

        assert_eq!(root_of(&after), ["alpha", "beta", "zeta"]);
        assert_eq!(after.root_listing.items[1].entry.kind, FOLDER);
    }

    #[test]
    fn test_removing_the_last_listed_entry_leaves_an_empty_listing_not_a_failed_one() {
        let model = supplied_model(held("", &[("only.rs", FILE)]), &[], ReaderPlace::default());

        let after = reduce(model, &change(names(&[], &["only.rs"]), "", vec![]));

        assert_eq!(after.tree(), &ItemState::Observed(vec![]));
    }

    #[test]
    fn test_a_fresh_observation_with_unreported_extras_does_not_leak_them_into_the_model() {
        let model = supplied_model(
            held("", &[("a.rs", FILE), ("b.rs", FILE)]),
            &[],
            ReaderPlace::default(),
        );
        // The fresh read saw `a.rs` gone, `d.rs` added and `b.rs` changed; only `e.rs` is
        // reported, so none of those three reaches the model.
        let seen = vec![
            listed_with_state(
                "",
                "b.rs",
                FILE,
                Some(ItemState::Failed(Condition::Missing)),
            ),
            listed("", "d.rs", FILE),
            listed("", "e.rs", FILE),
        ];

        let after = reduce(model, &change(names(&["e.rs"], &[]), "", seen));

        assert_eq!(root_of(&after), ["a.rs", "b.rs", "e.rs"]);
        assert_eq!(after.root_listing.items[1], listed("", "b.rs", FILE));
    }

    #[test]
    fn test_a_reported_entry_the_fresh_read_does_not_see_is_not_listed() {
        // CP-785 lists a reported entry as a fresh read lists it now: one reported created or
        // changed that the fresh read no longer sees is not listed, and the unreported entry stays.
        let model = supplied_model(
            held("", &[("a.rs", FILE), ("b.rs", FILE)]),
            &[],
            ReaderPlace::default(),
        );

        let after = reduce(
            model,
            &change(
                names(&["ghost.rs", "a.rs"], &[]),
                "",
                vec![listed("", "b.rs", FILE)],
            ),
        );

        assert_eq!(root_of(&after), ["b.rs"]);
    }

    #[test]
    fn test_repeated_identical_reports_leave_no_duplicates() {
        let model = supplied_model(held("", &[("a.rs", FILE)]), &[], ReaderPlace::default());
        let seen = vec![listed("", "a.rs", FILE), listed("", "b.rs", FILE)];
        let changes = change(names(&["b.rs"], &[]), "", seen);

        let once = reduce(model, &changes);
        let twice = reduce(once.clone(), &changes);

        assert_eq!(root_of(&twice), ["a.rs", "b.rs"]);
        assert_eq!(twice, once);
    }

    #[test]
    fn test_an_empty_batch_is_the_identity() {
        let folder = project();
        let model = expand(model_over(&folder), "src");

        let after = model
            .clone()
            .list_tree(TreeRequest::Delta(ModelDelta::default()));

        assert_eq!(after, model);
        assert_eq!(reduce(model.clone(), &BTreeMap::new()), model);
    }

    #[test]
    fn test_a_delta_with_no_held_parent_changes_nothing() {
        let model = supplied_model(held("", &[("a.rs", FILE)]), &[], ReaderPlace::default());

        let after = reduce(
            model.clone(),
            &change(
                names(&["new.rs"], &[]),
                "elsewhere",
                vec![listed("elsewhere", "new.rs", FILE)],
            ),
        );

        assert_eq!(after, model);
    }

    #[test]
    fn test_a_collapsed_never_read_folder_gets_no_listing() {
        let folder = project();
        let model = model_over(&folder);
        folder.write_file("tests/a.rs", "// a\n");

        let after = model.clone().list_tree(TreeRequest::Delta(ModelDelta::new(
            vec![PathBuf::from("tests/a.rs")],
            vec![],
            vec![],
        )));

        assert_eq!(after, model);
        assert!(after.listing(Path::new("tests")).is_none());
        assert!(!after.place().is_expanded(Path::new("tests")));
    }

    #[test]
    fn test_a_collapsed_previously_read_folder_updates_its_listing_and_stays_collapsed() {
        let model = supplied_model(
            held("", &[("src", FOLDER)]),
            &[("src", held("src", &[("a.rs", FILE)]))],
            ReaderPlace::default(),
        );
        assert!(!model.place.is_expanded(Path::new("src")));

        let after = reduce(
            model,
            &change(
                names(&["b.rs"], &[]),
                "src",
                vec![listed("src", "a.rs", FILE), listed("src", "b.rs", FILE)],
            ),
        );

        assert_eq!(
            names_in(&after.listings[Path::new("src")]),
            ["a.rs", "b.rs"]
        );
        assert!(!after.place.is_expanded(Path::new("src")));
        assert_eq!(root_of(&after), ["src"]);
    }

    #[test]
    fn test_explicit_collapsed_flags_and_nested_held_listings_survive_unchanged() {
        let place = ReaderPlace {
            expanded: BTreeSet::from([PathBuf::from("src/lib")]),
            ..ReaderPlace::default()
        };
        let model = supplied_model(
            held("", &[("src", FOLDER), ("a.rs", FILE)]),
            &[
                ("src", held("src", &[("lib", FOLDER)])),
                ("src/lib", held("src/lib", &[("m.rs", FILE)])),
            ],
            place.clone(),
        );

        let after = reduce(
            model.clone(),
            &change(
                names(&["b.rs"], &[]),
                "",
                vec![
                    listed("", "a.rs", FILE),
                    listed("", "b.rs", FILE),
                    listed("", "src", FOLDER),
                ],
            ),
        );

        assert_eq!(after.place, place);
        assert_eq!(after.listings, model.listings);
        assert_eq!(root_of(&after), ["src", "a.rs", "b.rs"]);
    }

    #[test]
    fn test_the_git_item_is_unchanged_whether_pending_observed_or_failed() {
        let git_items = [
            ItemState::Pending,
            ItemState::Observed(FolderKind::Plain),
            ItemState::Failed(GitCondition::Probe(ProbeCondition::FolderUnavailable)),
        ];

        for kind in git_items {
            let mut model =
                supplied_model(held("", &[("a.rs", FILE)]), &[], ReaderPlace::default());
            model.kind = kind.clone();

            let after = reduce(model, &change(names(&[], &["a.rs"]), "", vec![]));

            assert_eq!(after.kind(), &kind);
        }
    }

    #[test]
    fn test_the_open_file_path_position_and_content_are_unchanged() {
        let folder = project();
        let model = open(
            expand(model_over(&folder), "src"),
            "src/main.rs",
            &position(b"line=400"),
        );
        let open_file = model.open_file().cloned();
        folder.write_file("src/main.rs", "changed on disk, and not reported\n");
        folder.write_file("src/new.rs", "// new\n");

        let after = model.list_tree(TreeRequest::Delta(ModelDelta::new(
            vec![PathBuf::from("src/new.rs")],
            vec![],
            vec![],
        )));

        assert_eq!(after.open_file().cloned(), open_file);
        // The delta was applied, so the open file was carried through a real reduction.
        let src = match after.listing(Path::new("src")) {
            Some(ItemState::Observed(entries)) => entries,
            other => panic!("src is held observed: {other:?}"),
        };
        assert!(src.iter().any(|entry| entry.name == "new.rs"));
    }

    #[test]
    fn test_a_name_reported_present_and_removed_is_decided_by_the_fresh_read() {
        let model = supplied_model(
            held("", &[("a.rs", FILE), ("b.rs", FILE)]),
            &[],
            ReaderPlace::default(),
        );
        let reported = names(&["a.rs", "b.rs"], &["a.rs", "b.rs"]);

        // The fresh read still sees `a.rs` and no longer sees `b.rs`.
        let after = reduce(model, &change(reported, "", vec![listed("", "a.rs", FILE)]));

        assert_eq!(root_of(&after), ["a.rs"]);
    }

    // ---- The open file's re-read: the pure fold over a supplied observation ----

    fn text_view(content: &str) -> ItemState<FileView> {
        ItemState::Observed(FileView::Text {
            content: content.to_owned(),
            language: Language::Plain,
            spans: Vec::new(),
        })
    }

    fn text_read(content: &str, location: Option<&str>) -> Reobserved {
        Reobserved::Read {
            state: ItemState::Observed(FileContent::Text {
                content: content.to_owned(),
                language: Language::Plain,
            }),
            location: location.map(PathBuf::from),
        }
    }

    /// A model over a root that is never read, with `path` open at `line=7` holding `view`.
    fn model_with_open_file(path: &str, view: ItemState<FileView>, location: &str) -> FolderModel {
        supplied_model(
            held("", &[("src", FOLDER)]),
            &[],
            ReaderPlace {
                expanded: BTreeSet::new(),
                selected: Some(PathBuf::from(path)),
                open_file: Some(OpenFile {
                    path: PathBuf::from(path),
                    position: position(b"line=7"),
                    view,
                    location: Some(PathBuf::from(location)),
                }),
            },
        )
    }

    #[test]
    fn test_a_reduction_with_an_absent_observation_holds_the_open_file_as_gone() {
        let model = model_with_open_file("src/a.txt", text_view("old"), "src/a.txt");

        let after = reduce_open_file(model, Some(Reobserved::Absent));

        let open = after.open_file().expect("the file stays the open one");
        assert_eq!(open.path(), Path::new("src/a.txt"));
        assert_eq!(open.position(), &position(b"line=7"));
        assert_ne!(open.view(), &text_view("old"));
        assert_eq!(open.view(), &ItemState::Observed(FileView::Gone));
    }

    #[test]
    fn test_a_reduction_with_a_read_gives_the_new_view_and_a_failed_read_gives_failed() {
        let model = model_with_open_file("src/a.txt", text_view("old"), "src/a.txt");

        let read = reduce_open_file(model.clone(), Some(text_read("new", Some("real/a.txt"))));
        let open = read.open_file().expect("open");
        assert_ne!(open.view(), &text_view("old"));
        assert_eq!(open.view(), &text_view("new"));
        assert_eq!(open.location, Some(PathBuf::from("real/a.txt")));
        assert_eq!(open.path(), Path::new("src/a.txt"));
        assert_eq!(open.position(), &position(b"line=7"));

        let failed = reduce_open_file(
            model,
            Some(Reobserved::Read {
                state: ItemState::Failed(Condition::Unreadable),
                location: Some(PathBuf::from("src/a.txt")),
            }),
        );
        let open = failed.open_file().expect("open");
        assert_ne!(open.view(), &text_view("old"));
        assert_eq!(open.view(), &ItemState::Failed(Condition::Unreadable));
        assert_eq!(open.position(), &position(b"line=7"));
    }

    #[test]
    fn test_an_uncovered_open_file_is_untouched_and_nothing_is_asked() {
        let model = model_with_open_file("src/a.txt", text_view("old"), "real/a.txt");

        // Nothing is asked for a sibling's report, and a report of the location is asked for.
        assert_eq!(model.open_file_to_reread(&reports(&["src/b.txt"])), None);
        assert_eq!(
            model.open_file_to_reread(&reports(&["real/a.txt"])),
            Some(PathBuf::from("src/a.txt"))
        );
        assert_eq!(
            model.open_file_to_reread(&reports(&["src"])),
            Some(PathBuf::from("src/a.txt"))
        );
        assert_eq!(
            model.open_file_to_reread(&reports(&[""])),
            Some(PathBuf::from("src/a.txt"))
        );
        // Not asked, so not folded: the model is the model it was.
        assert_eq!(reduce_open_file(model.clone(), None), model);

        // With no file open nothing is asked, whatever is reported.
        let none_open = supplied_model(held("", &[]), &[], ReaderPlace::default());
        assert_eq!(none_open.open_file_to_reread(&reports(&[""])), None);
        assert_eq!(reduce_open_file(none_open.clone(), None), none_open);
    }
}
