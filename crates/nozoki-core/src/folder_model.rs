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
/// let opened = nozoki_core::open_folder(std::env::temp_dir());
/// assert!(matches!(opened, nozoki_core::OpenFolderOutcome::Opened(_)));
///
/// let missing = std::env::temp_dir().join("nozoki-a-folder-that-is-not-there");
/// assert!(matches!(
///     nozoki_core::open_folder(missing),
///     nozoki_core::OpenFolderOutcome::Failed(nozoki_core::OpenFailure::Missing)
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
/// use nozoki_core::{Condition, ItemState, list_tree, open_folder};
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
/// use nozoki_core::{Condition, ItemState, open_folder, select_file};
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
/// use nozoki_core::{FolderKind, FolderModel, GitPort, ItemState, read_git, open_folder};
/// # use nozoki_core::{GitReadCondition, HeadState, RootFinding, StatusLists};
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
            Self::Probe(ProbeCondition::ObjectStoreNamesOutside(_)) => {
                OBJECT_STORE_NAMES_OUTSIDE_PHRASE
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
            Self::Read(GitReadCondition::ObjectStoreNamesOutside(_)) => {
                OBJECT_STORE_NAMES_OUTSIDE_PHRASE
            }
        }
    }
}

/// The one phrase for a config that names a path outside the folder, whichever operation met it. It
/// carries neither the key nor the path the condition holds.
const CONFIG_NAMES_OUTSIDE_PHRASE: &str = "the config names a path outside the folder";

/// The one phrase for an object store that names a location outside the folder, whichever operation
/// met it. It carries neither the entry nor the location the condition holds.
const OBJECT_STORE_NAMES_OUTSIDE_PHRASE: &str =
    "the object store names a location outside the folder";

/// An opened folder with what has been read of it: the root listing and the Git item.
///
/// A value: [`read_git`] consumes one and returns the next, so a caller that keeps one replaces it
/// whole.
///
/// # Examples
///
/// ```
/// use nozoki_core::{FolderModel, ItemState, open_folder};
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
    use super::{OpenFailure, OpenFolderOutcome, open_folder};
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
}
