//! folder-model: SM-5, the crate's public surface for the host and the harness. An opened folder is
//! a canonical root, and listing is delegated to fs-reader.

use std::path::{Path, PathBuf};

use crate::fs_reader::{self, CannotDisplayReason, Entry, FileContent, ItemState, OpenFailure};
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

/// An opened folder with what has been read of it: the root listing and the Git item.
///
/// A value: [`read_git`] consumes one and returns the next, so a caller that keeps one replaces it
/// whole.
///
/// # Examples
///
/// ```
/// use ka_reader_core::{FolderModel, ItemState, open_folder};
///
/// let opened = open_folder(std::env::temp_dir()).expect("the temporary folder opens");
/// let model = FolderModel::new(opened);
/// assert_eq!(model.kind(), &ItemState::Pending);
/// ```
#[derive(Debug, Clone, PartialEq, Eq)]
pub struct FolderModel {
    folder: OpenedFolder,
    tree: ItemState<Vec<Entry>>,
    kind: ItemState<FolderKind, GitCondition>,
}

impl FolderModel {
    /// Holds `opened` with its root listing as [`list_tree`] answers it, and the Git item `Pending`.
    pub fn new(opened: OpenedFolder) -> Self {
        let tree = list_tree(&opened, "");
        Self {
            folder: opened,
            tree,
            kind: ItemState::Pending,
        }
    }

    pub fn folder(&self) -> &OpenedFolder {
        &self.folder
    }

    pub fn tree(&self) -> &ItemState<Vec<Entry>> {
        &self.tree
    }

    /// The Git item: `Pending` until [`read_git`] folds an answer in.
    pub fn kind(&self) -> &ItemState<FolderKind, GitCondition> {
        &self.kind
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

    use super::{
        FileRequest, FileView, FolderKind, FolderModel, ItemState, OpenFailure, OpenFolderOutcome,
        ReaderPlace, ReadingPosition, TreeRequest, list_tree, open_folder, read_git, select_file,
    };
    use crate::fs_reader::Condition;
    use crate::git_reader::{GitPort, GitReadCondition, HeadState, RootFinding, StatusLists};
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
}
