//! folder-model: SM-5, the crate's public surface for the host and the harness. An opened folder is
//! a canonical root, and listing is delegated to fs-reader.

use std::path::{Path, PathBuf};

use crate::fs_reader::{self, CannotDisplayReason, Entry, FileContent, ItemState, OpenFailure};
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
