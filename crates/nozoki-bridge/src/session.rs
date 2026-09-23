//! The open-and-list state behind the bridge's two calls, and their wire shapes. Every operation
//! delegates to `nozoki-core` and only formats the result (QC-13). It never presents a panel: the
//! location comes in as a plain `Option<PathBuf>`, so none of this needs a window or a runtime.

use std::path::PathBuf;
use std::sync::{Mutex, PoisonError};

use nozoki_core::{EntryKind, Listing, OpenedFolder, list_tree, open_folder};
use serde::Serialize;

/// What `open_folder` answers across the bridge.
#[derive(Debug, Clone, Copy, PartialEq, Eq, Serialize)]
pub struct OpenResult {
    pub opened: bool,
}

/// An entry's kind on the wire: `"folder"`, `"file"` or `"symlink"`.
#[derive(Debug, Clone, Copy, PartialEq, Eq, Serialize)]
#[serde(rename_all = "lowercase")]
pub enum KindDto {
    Folder,
    File,
    Symlink,
}

impl From<EntryKind> for KindDto {
    fn from(kind: EntryKind) -> Self {
        match kind {
            EntryKind::Folder => Self::Folder,
            EntryKind::File => Self::File,
            EntryKind::Symlink => Self::Symlink,
        }
    }
}

/// One listed entry on the wire: exactly `name`, `path` and `kind`.
#[derive(Debug, Clone, PartialEq, Eq, Serialize)]
pub struct EntryDto {
    pub name: String,
    pub path: String,
    pub kind: KindDto,
}

/// The session: at most one opened folder, starting empty, replaced whole by a successful open.
/// The bridge holds exactly one for the life of the process.
///
/// # Examples
///
/// ```
/// use nozoki_bridge::session::Session;
///
/// let session = Session::default();
///
/// assert!(session.list("").is_empty(), "nothing is open yet");
/// assert!(!session.open(None).opened, "a cancelled panel opens nothing");
/// ```
#[derive(Default)]
pub struct Session {
    opened: Mutex<Option<OpenedFolder>>,
}

impl Session {
    /// Opens the folder the panel returned. A chosen path that `nozoki-core` opens replaces the
    /// session whole. A cancel (`None`), or a path that does not open, leaves the session as it was.
    pub fn open(&self, chosen: Option<PathBuf>) -> OpenResult {
        let replacement = chosen.and_then(open_folder);
        let opened = replacement.is_some();
        if let Some(folder) = replacement {
            *self.opened.lock().unwrap_or_else(PoisonError::into_inner) = Some(folder);
        }
        OpenResult { opened }
    }

    /// Lists `path` inside the opened folder. `Refused`, `Failed`, and no folder open are all `[]`.
    pub fn list(&self, path: &str) -> Vec<EntryDto> {
        let guard = self.opened.lock().unwrap_or_else(PoisonError::into_inner);
        let Some(folder) = guard.as_ref() else {
            return Vec::new();
        };
        match list_tree(folder, path) {
            Listing::Listed(entries) => entries
                .into_iter()
                .map(|entry| EntryDto {
                    name: entry.name,
                    path: entry.path,
                    kind: entry.kind.into(),
                })
                .collect(),
            Listing::Refused | Listing::Failed(_) => Vec::new(),
        }
    }
}

#[cfg(test)]
mod tests {
    //! Layer 1: the session over temporary folders. The panel belongs to the shell, so every open
    //! here hands in the location as a plain `Option<PathBuf>`.

    use std::path::PathBuf;

    use serde_json::{Value, json};

    use nozoki_core::{Listing, list_tree, open_folder};

    use super::{EntryDto, Session};
    use crate::test_support::TempDir;

    fn names(entries: &[EntryDto]) -> Vec<String> {
        let mut names: Vec<String> = entries.iter().map(|entry| entry.name.clone()).collect();
        names.sort();
        names
    }

    fn opened(session: &Session, folder: &TempDir) {
        let result = session.open(Some(folder.path().to_path_buf()));
        assert!(result.opened, "the folder must open");
    }

    #[test]
    fn test_open_with_chosen_folder_replaces_session() {
        let folder = TempDir::new();
        folder.write_file("chosen.txt", "");
        let session = Session::default();

        let result = session.open(Some(folder.path().to_path_buf()));

        assert!(result.opened);
        assert_eq!(names(&session.list("")), vec!["chosen.txt"]);
    }

    #[test]
    fn test_open_replaces_previous_folder_whole() {
        let first = TempDir::new();
        first.write_file("from-a.txt", "");
        let second = TempDir::new();
        second.write_file("from-b.txt", "");
        let session = Session::default();
        opened(&session, &first);

        opened(&session, &second);

        assert_eq!(names(&session.list("")), vec!["from-b.txt"]);
    }

    #[test]
    fn test_cancel_returns_not_opened_and_keeps_session() {
        let folder = TempDir::new();
        folder.write_file("kept.txt", "");
        let session = Session::default();
        opened(&session, &folder);

        let result = session.open(None);

        assert!(!result.opened);
        assert_eq!(names(&session.list("")), vec!["kept.txt"]);
    }

    #[test]
    fn test_unopenable_choice_returns_not_opened_and_keeps_session() {
        let folder = TempDir::new();
        folder.write_file("kept.txt", "");
        let a_file = folder.write_file("not-a-folder.txt", "");
        let session = Session::default();
        opened(&session, &folder);

        let result = session.open(Some(a_file));
        let missing = session.open(Some(PathBuf::from("/nonexistent/nozoki/folder")));

        assert!(!result.opened);
        assert!(!missing.opened);
        assert_eq!(
            names(&session.list("")),
            vec!["kept.txt", "not-a-folder.txt"]
        );
    }

    #[test]
    fn test_open_result_serializes_as_an_opened_flag() {
        let session = Session::default();

        let value = serde_json::to_value(session.open(None)).expect("the result serializes");

        assert_eq!(value, json!({ "opened": false }));
    }

    #[test]
    fn test_list_formats_listed_entries() {
        let folder = TempDir::new();
        folder.write_file("src/main.rs", "");
        folder.write_file("top.txt", "");
        folder.make_link("link", "top.txt");
        let session = Session::default();
        opened(&session, &folder);

        let root = serde_json::to_value(session.list("")).expect("the entries serialize");
        let nested = serde_json::to_value(session.list("src")).expect("the entries serialize");

        let mut root_kinds: Vec<(String, String)> = root
            .as_array()
            .expect("an array")
            .iter()
            .map(|entry| {
                let keys: Vec<&String> = entry.as_object().expect("an object").keys().collect();
                assert_eq!(keys.len(), 3, "exactly name, path and kind: {keys:?}");
                (
                    entry["name"].as_str().expect("a name").to_string(),
                    entry["kind"].as_str().expect("a kind").to_string(),
                )
            })
            .collect();
        root_kinds.sort();
        assert_eq!(
            root_kinds,
            vec![
                ("link".to_string(), "symlink".to_string()),
                ("src".to_string(), "folder".to_string()),
                ("top.txt".to_string(), "file".to_string()),
            ]
        );
        assert_eq!(
            nested,
            Value::Array(vec![
                json!({ "name": "main.rs", "path": "src/main.rs", "kind": "file" })
            ])
        );
    }

    #[test]
    fn test_list_refused_is_empty_array() {
        let folder = TempDir::new();
        folder.write_file("inside.txt", "");
        let session = Session::default();
        opened(&session, &folder);

        assert!(session.list("../").is_empty());
        assert!(session.list("/etc").is_empty());
    }

    #[test]
    fn test_list_failed_is_empty_array() {
        let folder = TempDir::new();
        folder.write_file("a-file", "");
        let session = Session::default();
        opened(&session, &folder);

        assert!(session.list("a-file").is_empty());
        assert_eq!(names(&session.list("")), vec!["a-file"]);
    }

    #[test]
    fn test_list_with_no_folder_open_is_empty_array() {
        let session = Session::default();

        assert!(session.list("").is_empty());
    }

    #[test]
    fn test_list_keeps_core_order() {
        let folder = TempDir::new();
        for name in ["zeta.txt", "alpha.txt", "mid", ".dot", "Beta.txt"] {
            folder.write_file(name, "");
        }
        let session = Session::default();
        opened(&session, &folder);
        let opened_folder = open_folder(folder.path()).expect("the folder opens");
        let Listing::Listed(core_entries) = list_tree(&opened_folder, "") else {
            panic!("the root lists");
        };
        let core_names: Vec<String> = core_entries.into_iter().map(|entry| entry.name).collect();

        let listed: Vec<String> = session
            .list("")
            .into_iter()
            .map(|entry| entry.name)
            .collect();

        assert_eq!(
            listed, core_names,
            "compared in sequence, never sorted here"
        );
        assert_eq!(listed.len(), 5);
    }
}
