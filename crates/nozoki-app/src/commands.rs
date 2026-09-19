#[cfg(test)]
mod tests {
    //! Layer 1: the panel-free half of SM-4 over temporary folders. The panel is Task 11's, so every
    //! open here hands in the panel's result as a plain `Option<PathBuf>`.

    use std::path::PathBuf;

    use serde_json::{Value, json};

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
}
