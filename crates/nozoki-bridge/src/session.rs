//! The open-and-list state behind the bridge's two calls, and their wire shapes. Every operation
//! delegates to `nozoki-core` and only formats the result (QC-13). It never presents a panel: the
//! location comes in as a plain `Option<PathBuf>`, so none of this needs a window or a runtime.

use std::path::PathBuf;
use std::sync::{Mutex, PoisonError};

use nozoki_core::{
    Condition, EntryKind, ItemState, OpenFailure, OpenFolderOutcome, OpenedFolder, list_tree,
    open_folder,
};
use serde::Serialize;

/// What `open_folder` answers across the bridge.
#[derive(Debug, Clone, Copy, PartialEq, Eq, Serialize)]
#[serde(tag = "state", rename_all = "snake_case")]
pub enum OpenResult {
    Opened,
    Failed { condition: OpenFailureDto },
}

#[derive(Debug, Clone, Copy, PartialEq, Eq, Serialize)]
#[serde(rename_all = "snake_case")]
pub enum OpenFailureDto {
    Missing,
    NotAFolder,
    Unreadable,
}

impl From<OpenFailure> for OpenFailureDto {
    fn from(failure: OpenFailure) -> Self {
        match failure {
            OpenFailure::Missing => Self::Missing,
            OpenFailure::NotAFolder => Self::NotAFolder,
            OpenFailure::Unreadable => Self::Unreadable,
        }
    }
}

/// An entry's kind on the wire: `"folder"` or `"file"`.
#[derive(Debug, Clone, Copy, PartialEq, Eq, Serialize)]
#[serde(rename_all = "lowercase")]
pub enum KindDto {
    Folder,
    File,
}

impl From<EntryKind> for KindDto {
    fn from(kind: EntryKind) -> Self {
        match kind {
            EntryKind::Folder => Self::Folder,
            EntryKind::File => Self::File,
        }
    }
}

/// A failure's condition on the wire, one string from the closed set: `"unreadable"`, `"outside"`,
/// `"cycle"`, `"missing"`, `"not_a_folder"` or `"too_many_links"`. It carries no text and no path.
#[derive(Debug, Clone, Copy, PartialEq, Eq, Serialize)]
#[serde(rename_all = "snake_case")]
pub enum ConditionDto {
    Unreadable,
    Outside,
    Cycle,
    Missing,
    NotAFolder,
    TooManyLinks,
}

impl From<Condition> for ConditionDto {
    fn from(condition: Condition) -> Self {
        match condition {
            Condition::Unreadable => Self::Unreadable,
            Condition::Outside => Self::Outside,
            Condition::Cycle => Self::Cycle,
            Condition::Missing => Self::Missing,
            Condition::NotAFolder => Self::NotAFolder,
            Condition::TooManyLinks => Self::TooManyLinks,
        }
    }
}

/// An entry's state on the wire, tagged by `state`. `condition` appears only beside `"failed"`.
#[derive(Debug, Clone, Copy, PartialEq, Eq, Serialize)]
#[serde(tag = "state", rename_all = "snake_case")]
pub enum EntryStateDto {
    Pending,
    Observed,
    Failed { condition: ConditionDto },
}

impl From<ItemState<()>> for EntryStateDto {
    fn from(state: ItemState<()>) -> Self {
        match state {
            ItemState::Pending => Self::Pending,
            ItemState::Observed(()) => Self::Observed,
            ItemState::Failed(condition) => Self::Failed {
                condition: condition.into(),
            },
        }
    }
}

/// One listed entry on the wire: `name`, `path`, `kind` and `state`, and `condition` when failed.
#[derive(Debug, Clone, PartialEq, Eq, Serialize)]
pub struct EntryDto {
    pub name: String,
    pub path: String,
    pub kind: KindDto,
    #[serde(flatten)]
    pub state: EntryStateDto,
}

/// What `list_tree` answers across the bridge, tagged by `state`: `observed` with its entries in
/// core's order, `failed` with a condition, or `pending` when nothing was read.
#[derive(Debug, Clone, PartialEq, Eq, Serialize)]
#[serde(tag = "state", rename_all = "snake_case")]
pub enum ListAnswerDto {
    Observed { entries: Vec<EntryDto> },
    Failed { condition: ConditionDto },
    Pending,
}

/// The session: at most one opened folder, starting empty, replaced whole by a successful open.
/// The bridge holds exactly one for the life of the process.
///
/// # Examples
///
/// ```
/// use nozoki_bridge::session::{ListAnswerDto, Session};
///
/// let session = Session::default();
///
/// assert_eq!(
///     serde_json::to_value(session.list("")).expect("the answer serializes"),
///     serde_json::json!({ "state": "pending" }),
///     "nothing is open yet"
/// );
/// assert_eq!(session.list(""), ListAnswerDto::Pending);
/// ```
#[derive(Default)]
pub struct Session {
    opened: Mutex<Option<OpenedFolder>>,
}

impl Session {
    /// Opens one chosen folder. Failed opens leave the held folder unchanged.
    pub fn open(&self, chosen: PathBuf) -> OpenResult {
        match open_folder(chosen) {
            OpenFolderOutcome::Opened(folder) => {
                *self.opened.lock().unwrap_or_else(PoisonError::into_inner) = Some(folder);
                OpenResult::Opened
            }
            OpenFolderOutcome::Failed(failure) => OpenResult::Failed {
                condition: failure.into(),
            },
        }
    }

    /// Lists `path` inside the opened folder. Core's item is carried over as it is: `observed`
    /// with the entries, or `failed` with its condition. No folder open is `pending`, because
    /// nothing was read.
    pub fn list(&self, path: &str) -> ListAnswerDto {
        let guard = self.opened.lock().unwrap_or_else(PoisonError::into_inner);
        let Some(folder) = guard.as_ref() else {
            return ListAnswerDto::Pending;
        };
        match list_tree(folder, path) {
            ItemState::Observed(entries) => ListAnswerDto::Observed {
                entries: entries
                    .into_iter()
                    .map(|entry| EntryDto {
                        name: entry.name,
                        path: entry.path,
                        kind: entry.kind.into(),
                        state: entry.state.into(),
                    })
                    .collect(),
            },
            ItemState::Failed(condition) => ListAnswerDto::Failed {
                condition: condition.into(),
            },
            ItemState::Pending => ListAnswerDto::Pending,
        }
    }
}

#[cfg(test)]
mod tests {
    //! Layer 1: the session over temporary folders. The panel belongs to the shell, so every open
    //! here hands in the location as a plain `Option<PathBuf>`.

    use std::path::PathBuf;

    use serde_json::{Value, json};

    use nozoki_core::{ItemState, list_tree, open_folder};

    use super::Session;
    use crate::test_support::TempDir;

    #[test]
    fn test_a_read_in_progress_does_not_hold_the_session_lock() {
        use std::sync::mpsc;
        use std::time::Duration;

        use nozoki_core::{CannotDisplayReason, FileContent};

        let folder = TempDir::new();
        folder.write_file("a.txt", "x");
        let session = Session::default();
        opened(&session, &folder);
        let (parked_tx, parked_rx) = mpsc::channel::<()>();
        let (release_tx, release_rx) = mpsc::channel::<()>();
        let (listed_tx, listed_rx) = mpsc::channel::<()>();

        std::thread::scope(|scope| {
            scope.spawn(|| {
                session.select_file_with("a.txt", |_, _| {
                    parked_tx.send(()).expect("the test is listening");
                    release_rx.recv().expect("the test releases the read");
                    ItemState::Observed(FileContent::CannotDisplay(
                        CannotDisplayReason::InvalidUtf8,
                    ))
                });
            });
            parked_rx
                .recv_timeout(Duration::from_secs(10))
                .expect("the read parked");
            scope.spawn(|| {
                session.list("");
                listed_tx.send(()).expect("the test is listening");
            });
            let listed = listed_rx.recv_timeout(Duration::from_secs(10));
            release_tx.send(()).expect("the read is parked");
            assert!(listed.is_ok(), "list completed while a read was parked");
        });
    }

    /// The answer to `path` as the JSON the shell reads.
    fn answer(session: &Session, path: &str) -> Value {
        serde_json::to_value(session.list(path)).expect("the answer serializes")
    }

    /// The names of the entries of an observed answer, sorted.
    fn names(answer: &Value) -> Vec<String> {
        let mut names: Vec<String> = entries_of(answer)
            .iter()
            .map(|entry| entry["name"].as_str().expect("a name").to_string())
            .collect();
        names.sort();
        names
    }

    fn entries_of(answer: &Value) -> &Vec<Value> {
        assert_eq!(answer["state"], "observed", "{answer}");
        answer["entries"].as_array().expect("an entries array")
    }

    fn opened(session: &Session, folder: &TempDir) {
        let result = session.open(folder.path().to_path_buf());
        assert!(
            matches!(result, super::OpenResult::Opened),
            "the folder must open"
        );
    }

    #[test]
    fn test_open_with_chosen_folder_replaces_session() {
        let folder = TempDir::new();
        folder.write_file("chosen.txt", "");
        let session = Session::default();

        let result = session.open(folder.path().to_path_buf());

        assert!(matches!(result, super::OpenResult::Opened));
        assert_eq!(names(&answer(&session, "")), vec!["chosen.txt"]);
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

        assert_eq!(names(&answer(&session, "")), vec!["from-b.txt"]);
    }

    #[test]
    fn test_unopenable_choice_returns_not_opened_and_keeps_session() {
        let folder = TempDir::new();
        folder.write_file("kept.txt", "");
        let a_file = folder.write_file("not-a-folder.txt", "");
        let session = Session::default();
        opened(&session, &folder);

        let result = session.open(a_file);
        let missing = session.open(PathBuf::from("/nonexistent/nozoki/folder"));

        assert!(matches!(result, super::OpenResult::Failed { .. }));
        assert!(matches!(missing, super::OpenResult::Failed { .. }));
        assert_eq!(
            names(&answer(&session, "")),
            vec!["kept.txt", "not-a-folder.txt"]
        );
    }

    #[test]
    fn test_open_result_serializes_as_an_exact_tagged_answer() {
        let session = Session::default();
        let folder = TempDir::new();

        let value = serde_json::to_value(session.open(folder.path().to_path_buf()))
            .expect("the result serializes");

        assert_eq!(value, json!({ "state": "opened" }));
    }

    #[test]
    fn test_list_answers_state_and_condition_for_each_entry() {
        let folder = TempDir::new();
        folder.write_file("docs/guide.txt", "");
        folder.write_file(".hidden-note", "");
        folder.write_file("readme.txt", "");
        let outside = TempDir::new();
        folder.make_link("outside-link", outside.path());
        let session = Session::default();
        opened(&session, &folder);
        let core_folder = open_folder(folder.path()).expect("the folder opens");
        let ItemState::Observed(core_entries) = list_tree(&core_folder, "") else {
            panic!("the root lists");
        };
        let core_names: Vec<String> = core_entries.into_iter().map(|entry| entry.name).collect();

        let root = answer(&session, "");

        let entries = entries_of(&root);
        let listed: Vec<String> = entries
            .iter()
            .map(|entry| entry["name"].as_str().expect("a name").to_string())
            .collect();
        assert_eq!(listed, core_names, "core's order, none added or dropped");
        for entry in entries {
            let keys: Vec<&str> = entry
                .as_object()
                .expect("an object")
                .keys()
                .map(String::as_str)
                .collect();
            let expected = if entry["state"] == "failed" { 5 } else { 4 };
            assert_eq!(
                keys.len(),
                expected,
                "name, path, kind, state and, when failed, condition: {keys:?}"
            );
            if let Some(condition) = entry.get("condition") {
                assert!(
                    !condition.as_str().expect("a string").contains('/'),
                    "a condition holds no path: {condition}"
                );
            }
        }
        let outside_link = entries
            .iter()
            .find(|entry| entry["name"] == "outside-link")
            .expect("the link is listed");
        assert_eq!(outside_link["state"], "failed");
        assert_eq!(outside_link["condition"], "outside");
        assert_eq!(outside_link["kind"], "file");
    }

    #[test]
    fn test_list_formats_listed_entries() {
        let folder = TempDir::new();
        folder.write_file("src/main.rs", "");
        folder.write_file("top.txt", "");
        folder.make_link("link", "top.txt");
        let session = Session::default();
        opened(&session, &folder);

        let root = answer(&session, "");
        let nested = answer(&session, "src");

        let mut root_kinds: Vec<(String, String, String)> = entries_of(&root)
            .iter()
            .map(|entry| {
                let keys: Vec<&String> = entry.as_object().expect("an object").keys().collect();
                assert_eq!(
                    keys.len(),
                    4,
                    "exactly name, path, kind and state: {keys:?}"
                );
                (
                    entry["name"].as_str().expect("a name").to_string(),
                    entry["kind"].as_str().expect("a kind").to_string(),
                    entry["state"].as_str().expect("a state").to_string(),
                )
            })
            .collect();
        root_kinds.sort();
        assert_eq!(
            root_kinds,
            vec![
                (
                    "link".to_string(),
                    "file".to_string(),
                    "observed".to_string()
                ),
                (
                    "src".to_string(),
                    "folder".to_string(),
                    "pending".to_string()
                ),
                (
                    "top.txt".to_string(),
                    "file".to_string(),
                    "observed".to_string()
                ),
            ]
        );
        assert_eq!(
            nested,
            json!({
                "state": "observed",
                "entries": [
                    { "name": "main.rs", "path": "src/main.rs", "kind": "file", "state": "observed" }
                ]
            })
        );
    }

    #[test]
    fn test_list_outside_answers_failed_outside() {
        let folder = TempDir::new();
        folder.write_file("inside.txt", "");
        let session = Session::default();
        opened(&session, &folder);
        let expected = json!({ "state": "failed", "condition": "outside" });

        assert_eq!(answer(&session, ".."), expected);
        assert_eq!(answer(&session, "/etc"), expected);
    }

    #[test]
    fn test_list_file_answers_failed_not_a_folder() {
        let folder = TempDir::new();
        folder.write_file("a-file", "");
        let session = Session::default();
        opened(&session, &folder);

        assert_eq!(
            answer(&session, "a-file"),
            json!({ "state": "failed", "condition": "not_a_folder" })
        );
        assert_eq!(names(&answer(&session, "")), vec!["a-file"]);
    }

    /// CP-195: a link whose target runs through a file is `missing`, and the bridge carries the
    /// core's condition across as it stands, as the entry's condition and as the listed answer.
    #[test]
    fn test_a_link_through_a_file_crosses_as_missing() {
        let folder = TempDir::new();
        folder.write_file("notes.txt", "");
        folder.make_link("bad", "notes.txt/x");
        let session = Session::default();
        opened(&session, &folder);

        let root = answer(&session, "");
        let bad = entries_of(&root)
            .iter()
            .find(|entry| entry["name"] == "bad")
            .expect("the link is listed");
        assert_eq!(bad["state"], "failed");
        assert_eq!(bad["condition"], "missing");
        assert_eq!(
            answer(&session, "bad"),
            json!({ "state": "failed", "condition": "missing" })
        );
    }

    #[test]
    fn test_list_with_no_folder_open_answers_pending() {
        let session = Session::default();

        assert_eq!(answer(&session, ""), json!({ "state": "pending" }));
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
        let ItemState::Observed(core_entries) = list_tree(&opened_folder, "") else {
            panic!("the root lists");
        };
        let core_names: Vec<String> = core_entries.into_iter().map(|entry| entry.name).collect();

        let listed: Vec<String> = entries_of(&answer(&session, ""))
            .iter()
            .map(|entry| entry["name"].as_str().expect("a name").to_string())
            .collect();

        assert_eq!(
            listed, core_names,
            "compared in sequence, never sorted here"
        );
        assert_eq!(listed.len(), 5);
    }

    // ---- Added by development-code-integrity (2026-09-25), derived from the intent it cites ----

    /// CP-181: from the answer alone the shell "can tell which condition a failed item carries".
    /// Design § 3 C fixes the six strings, and the Swift shell decodes them from that document and
    /// not from this code, so nothing but this test holds the Rust side to them. Each condition is
    /// checked both as a failed answer and as a failed entry's state.
    #[test]
    fn test_every_condition_crosses_the_wire_as_its_design_string() {
        use nozoki_core::Condition;

        use super::{ConditionDto, EntryStateDto, ListAnswerDto};

        for (condition, wire) in [
            (Condition::Unreadable, "unreadable"),
            (Condition::Outside, "outside"),
            (Condition::Cycle, "cycle"),
            (Condition::Missing, "missing"),
            (Condition::NotAFolder, "not_a_folder"),
            (Condition::TooManyLinks, "too_many_links"),
        ] {
            let answer = ListAnswerDto::Failed {
                condition: ConditionDto::from(condition),
            };
            let entry_state = EntryStateDto::from(ItemState::<()>::Failed(condition));

            assert_eq!(
                serde_json::to_value(answer).expect("the answer serializes"),
                json!({ "state": "failed", "condition": wire }),
                "{condition:?} as an answer"
            );
            assert_eq!(
                serde_json::to_value(entry_state).expect("the state serializes"),
                json!({ "state": "failed", "condition": wire }),
                "{condition:?} as an entry's state"
            );
        }
    }
}
