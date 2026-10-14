//! folder-model: SM-5, the crate's public surface for the host and the harness. An opened folder is
//! a canonical root, and listing is delegated to fs-reader.

use std::collections::{BTreeMap, BTreeSet};
use std::path::{Path, PathBuf};

use crate::fs_reader::{
    self, CannotDisplayReason, Entry, EntryKind, FileContent, ItemState, Listed,
    ListingObservation, Location, OpenFailure,
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
#[derive(Debug, Clone, PartialEq, Eq)]
pub struct OpenFile {
    path: PathBuf,
    position: ReadingPosition,
    view: ItemState<FileView>,
}

impl OpenFile {
    /// The path the file was opened by, relative to the folder's root.
    pub fn path(&self) -> &Path {
        &self.path
    }

    pub fn position(&self) -> &ReadingPosition {
        &self.position
    }

    /// What reading the file gave when it was opened, as [`select_file`] answers it.
    pub fn view(&self) -> &ItemState<FileView> {
        &self.view
    }
}

/// What the reader has done to the tree and the file: which folders are expanded, which file is
/// selected, and the open file. It is held in memory only and is never written anywhere.
///
/// A folder absent from the expanded set is collapsed, so a place that expanded and collapsed a
/// folder equals one that never touched it. Paths are native, relative to the opened folder's root.
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
#[derive(Debug, Clone, PartialEq, Eq)]
pub enum TreeRequest {
    /// Hold the folder expanded, with its direct listing read now.
    Expand(PathBuf),
    /// Hold the folder collapsed. Nothing is read, and nothing held beneath it is dropped.
    Collapse(PathBuf),
}

/// An act on the file: which is selected, which is open, and where the reader is in it.
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

    /// Applies a disclosure act and returns the model that results.
    ///
    /// `Expand` reads the folder's direct listing and holds it; `Collapse` changes only that
    /// folder's flag and reads nothing. A path that does not resolve inside the root to a folder,
    /// and the root itself, leaves the model as it was.
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
        if self.admit(&path, EntryKind::File).is_none() {
            return self;
        }
        let view = fs_reader::observe_file(&self.folder.root, &path).map(FileView::from);
        self.place.open_file = Some(OpenFile {
            path,
            position,
            view,
        });
        self
    }

    fn with_position(mut self, position: ReadingPosition) -> Self {
        if let Some(open_file) = self.place.open_file.as_mut() {
            open_file.position = position;
        }
        self
    }
}

/// Asks `port` about the model's folder and returns the model with only the Git item replaced.
///
/// `probe` is asked every call, whatever the item held. `state` is asked only where `probe` says
/// `Root`, and `status` only if `state` succeeded, so one read holds the branch element, the
/// repository state and both lists, or the condition of the read that failed, and never a root
/// missing an element. An item that becomes failed emits one `warn` record naming `git-reader`, the
/// operation that failed and a fixed phrase, and never a path.
pub fn read_git(model: FolderModel, port: &dyn GitPort) -> FolderModel {
    let kind = match ask_git(port, model.folder.root.as_path()) {
        Ok(observed) => ItemState::Observed(observed),
        Err((condition, operation)) => {
            let phrase = condition.log_phrase();
            log::warn!(
                "git-reader: {operation} failed: {phrase}; the folder stays open without it"
            );
            ItemState::Failed(condition)
        }
    };
    FolderModel { kind, ..model }
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
        ItemState, ModelDelta, OpenFailure, OpenFolderOutcome, OpenedFolder, ReaderPlace,
        ReadingPosition, ReportedNames, TreeRequest, list_tree, open_folder, read_git, reduce,
        select_file,
    };
    use crate::fs_reader::{Condition, Entry, EntryKind, Listed, ListingObservation};
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

    #[test]
    fn test_selecting_performs_no_content_read() {
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
        // The fresh read saw `a.rs` and `c.rs` gone, `d.rs` added and `b.rs` changed; only `e.rs`
        // is reported, so none of those four reaches the model.
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
    }
}
