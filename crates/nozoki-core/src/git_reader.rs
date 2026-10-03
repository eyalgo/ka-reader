//! git-reader: the Git port and its closed outcome types. The one adapter, which does all the Git
//! I/O and names the libgit2 binding, is the child module `libgit2`.

use std::path::Path;

mod libgit2;

pub use libgit2::Libgit2;

/// What the Git view asks of Git: whether an opened folder is a repository's top level.
///
/// The port is object-safe, so a caller holds `&dyn GitPort` and a test hands it a fake through the
/// same door production wires the real adapter through.
///
/// # Examples
///
/// ```
/// use std::path::Path;
///
/// use nozoki_core::{GitPort, RootFinding};
///
/// struct NeverARepository;
///
/// impl GitPort for NeverARepository {
///     fn probe(&self, _folder: &Path) -> RootFinding {
///         RootFinding::Plain
///     }
/// }
///
/// let port: &dyn GitPort = &NeverARepository;
/// assert_eq!(port.probe(Path::new("/any/folder")), RootFinding::Plain);
/// ```
pub trait GitPort {
    /// Answers whether `folder` is a repository's top level. Never changes anything on disk.
    fn probe(&self, folder: &Path) -> RootFinding;
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
    /// The folder is the top level of a repository whose working tree it is.
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
    /// `.git` is a file or a link, not a folder. The answer for this shape is provisional.
    GitEntryNotDirectory,
    /// Git refused a `.git` folder the probe could look inside, for a reason other than "not a
    /// repository".
    RepositoryReadFailed,
}
