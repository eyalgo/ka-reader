//! git-reader: the Git port and its closed outcome types. The one adapter, which does all the Git
//! I/O and names the libgit2 binding, is the child module `libgit2`.

use std::path::{Path, PathBuf};

mod libgit2;

pub use libgit2::Libgit2;

/// What the Git view asks of Git: whether an opened folder is a repository's top level, and, of a
/// root, where its HEAD stands and which entries differ.
///
/// The port is object-safe, so a caller holds `&dyn GitPort` and a test hands it a fake through the
/// same door production wires the real adapter through.
///
/// # Examples
///
/// ```
/// use std::path::Path;
///
/// use nozoki_core::{GitPort, GitReadCondition, HeadState, RootFinding, StatusLists};
///
/// struct NeverARepository;
///
/// impl GitPort for NeverARepository {
///     fn probe(&self, _folder: &Path) -> RootFinding {
///         RootFinding::Plain
///     }
///
///     fn state(&self, _root: &Path) -> Result<HeadState, GitReadCondition> {
///         Err(GitReadCondition::NotARoot)
///     }
///
///     fn status(&self, _root: &Path) -> Result<StatusLists, GitReadCondition> {
///         Err(GitReadCondition::NotARoot)
///     }
/// }
///
/// let port: &dyn GitPort = &NeverARepository;
/// assert_eq!(port.probe(Path::new("/any/folder")), RootFinding::Plain);
/// assert_eq!(
///     port.state(Path::new("/any/folder")),
///     Err(GitReadCondition::NotARoot)
/// );
/// ```
pub trait GitPort {
    /// Answers whether `folder` is a repository's top level. Never changes anything on disk.
    fn probe(&self, folder: &Path) -> RootFinding;

    /// Answers where HEAD stands and what state the repository is in, for `root`, which is a folder
    /// whose `probe` answered `Root` and is the opened folder's canonical path. Never changes
    /// anything on disk, and reads nothing past the folder.
    fn state(&self, root: &Path) -> Result<HeadState, GitReadCondition>;

    /// Answers the staged and the changed entries of `root`, under the same terms as
    /// [`GitPort::state`].
    fn status(&self, root: &Path) -> Result<StatusLists, GitReadCondition>;
}

/// Where HEAD stands and what the repository is in the middle of.
///
/// # Examples
///
/// ```
/// use nozoki_core::{BranchElement, HeadState, RepositoryState};
///
/// let head = HeadState {
///     branch: BranchElement::Branch("main".to_string()),
///     state: RepositoryState::Normal,
/// };
/// assert_eq!(head.branch, BranchElement::Branch("main".to_string()));
/// ```
#[derive(Debug, Clone, PartialEq, Eq)]
pub struct HeadState {
    pub branch: BranchElement,
    pub state: RepositoryState,
}

/// What names HEAD's position: a branch, or the commit HEAD is detached at.
///
/// # Examples
///
/// ```
/// use nozoki_core::BranchElement;
///
/// let detached = BranchElement::Detached("0".repeat(40));
/// assert!(matches!(detached, BranchElement::Detached(id) if id.len() == 40));
/// ```
#[derive(Debug, Clone, PartialEq, Eq)]
pub enum BranchElement {
    /// The branch's short name (`feature/x`). It is also the answer on an unborn branch, and during
    /// a merge, a cherry-pick, a revert and an `am` session on that branch.
    Branch(String),
    /// The full hexadecimal identifier of the commit HEAD is detached at, never abbreviated.
    Detached(String),
}

/// The state a repository is in, named as Git names it. An operation in progress wins over
/// `DetachedHead`, which is answered only when HEAD is detached and nothing is in progress.
///
/// # Examples
///
/// ```
/// use nozoki_core::RepositoryState;
///
/// let state = RepositoryState::Rebase;
/// assert_ne!(state, RepositoryState::DetachedHead);
/// ```
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum RepositoryState {
    Normal,
    Merge,
    Rebase,
    CherryPick,
    Revert,
    Bisect,
    Am,
    DetachedHead,
}

/// The two lists a status read answers. Neither carries a count, and no order is promised.
///
/// # Examples
///
/// ```
/// use nozoki_core::StatusLists;
///
/// let clean = StatusLists { staged: vec![], changed: vec![] };
/// assert!(clean.staged.is_empty() && clean.changed.is_empty());
/// ```
#[derive(Debug, Clone, PartialEq, Eq)]
pub struct StatusLists {
    /// What differs between HEAD and the index.
    pub staged: Vec<StatusEntry>,
    /// What differs between the index and the working tree, plus untracked and conflicted files.
    pub changed: Vec<StatusEntry>,
}

/// One entry of a status list: a path relative to the opened folder, `/`-separated with no leading
/// `/`, spelled lossily from its bytes as a listed entry's path is.
///
/// # Examples
///
/// ```
/// use nozoki_core::{StatusCategory, StatusEntry};
///
/// let entry = StatusEntry { path: "src/a.txt".to_string(), category: StatusCategory::Added };
/// assert_eq!(entry.category, StatusCategory::Added);
/// ```
#[derive(Debug, Clone, PartialEq, Eq)]
pub struct StatusEntry {
    pub path: String,
    pub category: StatusCategory,
}

/// Git's own six status categories. `Renamed` occurs only in the staged list and `Untracked` and
/// `InConflict` only in the changed list.
///
/// # Examples
///
/// ```
/// use nozoki_core::StatusCategory;
///
/// let moved = StatusCategory::Renamed { from: "old.txt".to_string() };
/// assert_ne!(moved, StatusCategory::Added);
/// ```
#[derive(Debug, Clone, PartialEq, Eq)]
pub enum StatusCategory {
    Added,
    Modified,
    Deleted,
    /// A staged rename: the entry's `path` is the path renamed to.
    Renamed {
        from: String,
    },
    Untracked,
    InConflict,
}

/// Why a read of a root's Git state failed, drawn from a closed set. Only the outside case carries a
/// path, and that path is where the Git directory lies, spelled from the root's own files.
///
/// # Examples
///
/// ```
/// use std::path::PathBuf;
///
/// use nozoki_core::GitReadCondition;
///
/// let outside = GitReadCondition::GitDirectoryOutside(PathBuf::from("/elsewhere/.git"));
/// assert_ne!(outside, GitReadCondition::NotARoot);
/// ```
#[derive(Debug, Clone, PartialEq, Eq)]
pub enum GitReadCondition {
    /// The Git directory, or failing that the common directory, lies outside the folder, by
    /// spelling or through a link inside it. Nothing at that location was opened.
    GitDirectoryOutside(PathBuf),
    /// The folder holds no `.git` entry, holds one that is a link or neither a file nor a folder, or
    /// holds a `.git` file with no `gitdir:` value.
    NotARoot,
    /// A location inside the folder is not there.
    GitDirectoryMissing,
    /// A location inside the folder, the `.git` file or the `commondir` file cannot be read.
    GitDirectoryUnreadable,
    /// libgit2 finds no repository at a verified location inside the folder.
    NotARepository,
    /// libgit2 refused, the read failed partway, or what libgit2 opened is not what was verified.
    RepositoryReadFailed,
}

/// The answer to a probe. It holds no path and no text, so it cannot reveal a location above the
/// opened folder.
///
/// # Examples
///
/// ```
/// use nozoki_core::{ProbeCondition, RootFinding};
///
/// let finding = RootFinding::Failed(ProbeCondition::GitDirectoryUnreadable);
/// let said = match finding {
///     RootFinding::Root => "a repository's top level",
///     RootFinding::Plain => "not a top level",
///     RootFinding::Failed(_) => "the probe could not tell",
/// };
/// assert_eq!(said, "the probe could not tell");
/// ```
#[derive(Debug, Clone, PartialEq, Eq)]
pub enum RootFinding {
    /// The folder is the top level of a repository whose working tree it is, or its `.git` is a file
    /// holding a `gitdir:` line, whose target the probe does not check.
    Root,
    /// The folder was looked at and is not such a top level.
    Plain,
    /// The probe could not tell, for the condition observed.
    Failed(ProbeCondition),
}

/// The condition a probe observed when it could not answer `Root` or `Plain`.
///
/// # Examples
///
/// ```
/// use nozoki_core::ProbeCondition;
///
/// let condition = ProbeCondition::GitEntryNotDirectory;
/// assert_ne!(condition, ProbeCondition::FolderUnavailable);
/// ```
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum ProbeCondition {
    /// The opened folder, or its `.git` entry, could not be looked at for a reason other than the
    /// entry's absence. A folder that is missing or is not a folder is this.
    FolderUnavailable,
    /// `.git` is a folder the operating system refuses to let the probe look inside.
    GitDirectoryUnreadable,
    /// `.git` is a symbolic link, which the probe does not follow, or an entry that is neither a
    /// file nor a folder.
    GitEntryNotDirectory,
    /// `.git` is a regular file whose content the probe could not read.
    GitFileUnreadable,
    /// Git refused a `.git` folder the probe could look inside, for a reason other than "not a
    /// repository".
    RepositoryReadFailed,
}
