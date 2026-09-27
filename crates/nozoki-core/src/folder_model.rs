//! folder-model: SM-5, the crate's public surface for the host and the harness. An opened folder is
//! a canonical root, and listing is delegated to fs-reader.

use std::path::{Path, PathBuf};

use crate::fs_reader::{self, Entry, ItemState};

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

/// The observed condition that stopped opening a chosen folder.
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum OpenFailure {
    Missing,
    NotAFolder,
    Unreadable,
}

#[cfg(test)]
mod tests {
    use super::{OpenFailure, OpenFolderOutcome, open_folder};
    use crate::test_support::TempDir;

    #[test]
    fn test_open_folder_returns_opened_for_a_readable_plain_folder() {
        let folder = TempDir::new();

        assert!(matches!(open_folder(folder.path()), OpenFolderOutcome::Opened(_)));
    }

    #[test]
    fn test_open_folder_returns_each_closed_failure() {
        let folder = TempDir::new();
        let file = folder.write_file("note.txt", "");
        let missing = folder.path().join("missing");

        assert_eq!(open_folder(missing), OpenFolderOutcome::Failed(OpenFailure::Missing));
        assert_eq!(open_folder(file), OpenFolderOutcome::Failed(OpenFailure::NotAFolder));
    }
}

/// Opens `path` as a folder, rooted at its canonical path.
///
/// Returns `None` when `path` does not resolve to a folder. Whether the folder can be read is not
/// asked here: [`list_tree`] finds out and reports it as the failed item [`ItemState::Failed`].
///
/// # Examples
///
/// ```
/// let opened = nozoki_core::open_folder(std::env::temp_dir());
/// assert!(opened.is_some());
///
/// let missing = std::env::temp_dir().join("nozoki-a-folder-that-is-not-there");
/// assert!(nozoki_core::open_folder(missing).is_none());
/// ```
pub fn open_folder(path: impl AsRef<Path>) -> OpenFolderOutcome {
    match fs_reader::open_root(path.as_ref()) {
        Ok(root) => OpenFolderOutcome::Opened(OpenedFolder { root }),
        Err(failure) => OpenFolderOutcome::Failed(failure),
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
