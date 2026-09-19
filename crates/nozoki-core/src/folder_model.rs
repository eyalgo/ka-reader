//! folder-model: SM-5, the crate's public surface for the host and the harness. An opened folder is
//! a canonical root, and listing is delegated to fs-reader.

use std::path::{Path, PathBuf};

use crate::fs_reader::{self, Listing};

/// A folder the user chose, held as its canonical path.
///
/// Opening again yields a new value: nothing here is mutated in place, so a caller that keeps one
/// value replaces it whole.
#[derive(Debug, Clone, PartialEq, Eq)]
pub struct OpenedFolder {
    root: PathBuf,
}

/// Opens `path` as a folder, rooted at its canonical path.
///
/// Returns `None` when `path` does not resolve to a folder. Whether the folder can be read is not
/// asked here: [`list_tree`] finds out and reports it as [`Listing::Failed`].
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
pub fn open_folder(path: impl AsRef<Path>) -> Option<OpenedFolder> {
    let root = path.as_ref().canonicalize().ok()?;
    root.is_dir().then_some(OpenedFolder { root })
}

/// Lists the direct entries of `path` inside an opened folder, where `path` is relative to the
/// folder's root (the empty string is the root itself).
///
/// # Examples
///
/// ```
/// use nozoki_core::{Listing, list_tree, open_folder};
///
/// let opened = open_folder(std::env::temp_dir()).expect("the temporary folder opens");
/// assert!(matches!(list_tree(&opened, ""), Listing::Listed(_)));
/// assert_eq!(list_tree(&opened, ".."), Listing::Refused);
/// ```
pub fn list_tree(opened: &OpenedFolder, path: &str) -> Listing {
    fs_reader::list(&opened.root, path)
}
