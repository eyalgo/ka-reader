//! The open-and-list state behind the bridge's two calls, and their wire shapes. Every operation
//! delegates to `nozoki-core` and only formats the result (QC-13). It never presents a panel: the
//! location comes in as a plain `Option<PathBuf>`, so none of this needs a window or a runtime.

use std::path::PathBuf;
use std::sync::{Mutex, PoisonError};

use nozoki_core::{
    CannotDisplayReason, Condition, EntryKind, FileView, ItemState, Language, OpenFailure,
    OpenFolderOutcome, OpenedFolder, Span, TokenClass, list_tree, open_folder, select_file,
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

/// One listed entry on the wire: `name`, `path`, `kind` and `state`, and `condition` when failed,
/// and `language` on a file entry. The bridge carries core's language over as it is and decides
/// none: a folder entry has no `language` member.
#[derive(Debug, Clone, PartialEq, Eq, Serialize)]
pub struct EntryDto {
    pub name: String,
    pub path: String,
    pub kind: KindDto,
    #[serde(flatten)]
    pub state: EntryStateDto,
    #[serde(skip_serializing_if = "Option::is_none")]
    pub language: Option<LanguageDto>,
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

/// A text file's language on the wire, one string from the closed set: `"python"`, `"shell"`,
/// `"javascript"`, `"json"`, `"yaml"`, `"toml"` or `"plain"`.
#[derive(Debug, Clone, Copy, PartialEq, Eq, Serialize)]
#[serde(rename_all = "snake_case")]
pub enum LanguageDto {
    Python,
    Shell,
    Javascript,
    Json,
    Yaml,
    Toml,
    Plain,
}

impl From<Language> for LanguageDto {
    fn from(language: Language) -> Self {
        // Every value is named, with no wildcard arm, so a language added to the core is a compile
        // error here and not a silent `plain`.
        match language {
            Language::Python => Self::Python,
            Language::Shell => Self::Shell,
            Language::JavaScript => Self::Javascript,
            Language::Json => Self::Json,
            Language::Yaml => Self::Yaml,
            Language::Toml => Self::Toml,
            Language::Plain => Self::Plain,
        }
    }
}

/// A span's class on the wire, one string from the closed set: `"keyword"`, `"string"`,
/// `"number"`, `"comment"` or `"name"`.
#[derive(Debug, Clone, Copy, PartialEq, Eq, Serialize)]
#[serde(rename_all = "snake_case")]
pub enum TokenClassDto {
    Keyword,
    String,
    Number,
    Comment,
    Name,
}

impl From<TokenClass> for TokenClassDto {
    fn from(class: TokenClass) -> Self {
        match class {
            TokenClass::Keyword => Self::Keyword,
            TokenClass::String => Self::String,
            TokenClass::Number => Self::Number,
            TokenClass::Comment => Self::Comment,
            TokenClass::Name => Self::Name,
        }
    }
}

/// One span on the wire: `start` and `end` are UTF-8 byte offsets into the answer's `content`, and
/// `class` names its token.
#[derive(Debug, Clone, Copy, PartialEq, Eq, Serialize)]
pub struct SpanDto {
    pub start: usize,
    pub end: usize,
    pub class: TokenClassDto,
}

impl From<Span> for SpanDto {
    fn from(span: Span) -> Self {
        Self {
            start: span.start,
            end: span.end,
            class: span.class.into(),
        }
    }
}

/// Why a file cannot be shown as text, on the wire: `"invalid_utf8"` or `"invalid_utf16"`.
#[derive(Debug, Clone, Copy, PartialEq, Eq, Serialize)]
#[serde(rename_all = "snake_case")]
pub enum CannotDisplayReasonDto {
    InvalidUtf8,
    InvalidUtf16,
}

impl From<CannotDisplayReason> for CannotDisplayReasonDto {
    fn from(reason: CannotDisplayReason) -> Self {
        match reason {
            CannotDisplayReason::InvalidUtf8 => Self::InvalidUtf8,
            CannotDisplayReason::InvalidUtf16 => Self::InvalidUtf16,
        }
    }
}

/// What `select_file` answers across the bridge, tagged by `state`: `text` with its decoded
/// `content`, its `language` and, for a floor language, its `spans`; `cannot_display` with a
/// `reason`; `failed` with a `condition`; or `pending` when nothing was read.
#[derive(Debug, Clone, PartialEq, Eq, Serialize)]
#[serde(tag = "state", rename_all = "snake_case")]
pub enum FileAnswerDto {
    Text {
        content: String,
        language: LanguageDto,
        /// Present exactly when `language` is a floor language, even as `[]`; a plain answer has
        /// no such member. Keyed on the language, never on emptiness.
        #[serde(skip_serializing_if = "Option::is_none")]
        spans: Option<Vec<SpanDto>>,
    },
    CannotDisplay {
        reason: CannotDisplayReasonDto,
    },
    Failed {
        condition: ConditionDto,
    },
    Pending,
}

impl From<ItemState<FileView>> for FileAnswerDto {
    fn from(state: ItemState<FileView>) -> Self {
        match state {
            ItemState::Observed(FileView::Text {
                content,
                language,
                spans,
            }) => Self::Text {
                content,
                spans: match language {
                    Language::Plain => None,
                    Language::Python
                    | Language::Shell
                    | Language::JavaScript
                    | Language::Json
                    | Language::Yaml
                    | Language::Toml => Some(spans.into_iter().map(SpanDto::from).collect()),
                },
                language: language.into(),
            },
            ItemState::Observed(FileView::CannotDisplay(reason)) => Self::CannotDisplay {
                reason: reason.into(),
            },
            ItemState::Failed(condition) => Self::Failed {
                condition: condition.into(),
            },
            ItemState::Pending => Self::Pending,
        }
    }
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
                        language: entry.language.map(LanguageDto::from),
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

impl Session {
    /// Reads the file at `path` inside the opened folder and answers its verdict. No folder open
    /// is `pending`, because nothing was read.
    pub fn select_file(&self, path: &str) -> FileAnswerDto {
        self.select_file_with(path, select_file)
    }

    /// `select_file` with the read passed in. The opened folder is cloned under the lock and the
    /// read runs after it is released, so a long read never stalls a listing behind it (CP-283).
    fn select_file_with(
        &self,
        path: &str,
        read: impl FnOnce(&OpenedFolder, &str) -> ItemState<FileView>,
    ) -> FileAnswerDto {
        let folder = self
            .opened
            .lock()
            .unwrap_or_else(PoisonError::into_inner)
            .clone();
        folder.map_or(FileAnswerDto::Pending, |folder| read(&folder, path).into())
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

        use nozoki_core::{CannotDisplayReason, FileView};

        let folder = TempDir::new();
        folder.write_file("a.txt", "x");
        let session = Session::default();
        opened(&session, &folder);
        let (parked_tx, parked_rx) = mpsc::channel::<()>();
        let (release_tx, release_rx) = mpsc::channel::<()>();
        let (listed_tx, listed_rx) = mpsc::channel::<()>();

        let session = &session;
        std::thread::scope(|scope| {
            scope.spawn(move || {
                session.select_file_with("a.txt", |_, _| {
                    parked_tx.send(()).expect("the test is listening");
                    release_rx.recv().expect("the test releases the read");
                    ItemState::Observed(FileView::CannotDisplay(CannotDisplayReason::InvalidUtf8))
                });
            });
            parked_rx
                .recv_timeout(Duration::from_secs(10))
                .expect("the read parked");
            scope.spawn(move || {
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
            let expected = match (entry["kind"] == "folder", entry["state"] == "failed") {
                (true, _) => 4,
                (false, false) => 5,
                (false, true) => 6,
            };
            assert_eq!(
                keys.len(),
                expected,
                "name, path, kind and state; a file also language; when failed, condition: {keys:?}"
            );
            assert_eq!(
                entry.get("language").is_some(),
                entry["kind"] == "file",
                "a file names its language and a folder does not: {keys:?}"
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
                let expected = if entry["kind"] == "folder" { 4 } else { 5 };
                assert_eq!(
                    keys.len(),
                    expected,
                    "name, path, kind and state, and a file also its language: {keys:?}"
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
                    {
                        "name": "main.rs",
                        "path": "src/main.rs",
                        "kind": "file",
                        "state": "observed",
                        "language": "plain"
                    }
                ]
            })
        );
    }

    /// A file entry sends the language its name gives it, in the closed wire set, and a folder
    /// sends none, even when its name is a floor name. A failed link sends its name's language
    /// beside its condition.
    #[test]
    fn test_list_sends_each_files_language_and_none_for_a_folder() {
        let folder = TempDir::new();
        for name in [
            "app.py",
            "setup.sh",
            "index.js",
            "package.json",
            "deploy.yml",
            "Cargo.toml",
            "notes.txt",
        ] {
            folder.write_file(name, "");
        }
        folder.make_folder("src");
        folder.make_link("gone.py", "nowhere");
        let session = Session::default();
        opened(&session, &folder);

        let root = answer(&session, "");

        let entries = entries_of(&root);
        let sent: Vec<(&str, Option<&str>)> = entries
            .iter()
            .map(|entry| {
                (
                    entry["name"].as_str().expect("a name"),
                    entry
                        .get("language")
                        .map(|language| language.as_str().expect("a string")),
                )
            })
            .collect();
        assert_eq!(
            sent,
            vec![
                ("src", None),
                ("app.py", Some("python")),
                ("Cargo.toml", Some("toml")),
                ("deploy.yml", Some("yaml")),
                ("gone.py", Some("python")),
                ("index.js", Some("javascript")),
                ("notes.txt", Some("plain")),
                ("package.json", Some("json")),
                ("setup.sh", Some("shell")),
            ]
        );
        let gone = entries
            .iter()
            .find(|entry| entry["name"] == "gone.py")
            .expect("the link is listed");
        assert_eq!(gone["state"], "failed");
        assert_eq!(gone["condition"], "missing");
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

    /// Task 5: the Git item's wire, mapped from the core's item. The model is built through the core's
    /// public API (`open_folder`, then `read_git` over a port double), because `GitState` has no
    /// public constructor.
    mod git_wire {
        use std::collections::BTreeSet;
        use std::ffi::OsStr;
        use std::os::unix::ffi::OsStrExt;
        use std::path::{Path, PathBuf};

        use nozoki_core::{
            BranchElement, FolderModel, GitPort, GitReadCondition, HeadState, OpenFolderOutcome,
            ProbeCondition, RepositoryState, RootFinding, StatusCategory, StatusEntry, StatusLists,
            open_folder, read_git,
        };
        use serde_json::{Value, json};

        use crate::session::GitAnswerDto;
        use crate::test_support::TempDir;

        /// A port double that answers what it was given, for every folder.
        struct Scripted {
            probe: RootFinding,
            state: Result<HeadState, GitReadCondition>,
            status: Result<StatusLists, GitReadCondition>,
        }

        impl Scripted {
            fn root(head: HeadState, status: StatusLists) -> Self {
                Self {
                    probe: RootFinding::Root,
                    state: Ok(head),
                    status: Ok(status),
                }
            }

            fn root_in(state: RepositoryState) -> Self {
                Self::root(
                    HeadState {
                        branch: BranchElement::Branch("main".to_string()),
                        state,
                    },
                    StatusLists {
                        staged: Vec::new(),
                        changed: Vec::new(),
                    },
                )
            }

            fn root_changed(changed: Vec<StatusEntry>) -> Self {
                Self::root(
                    HeadState {
                        branch: BranchElement::Branch("main".to_string()),
                        state: RepositoryState::Normal,
                    },
                    StatusLists {
                        staged: Vec::new(),
                        changed,
                    },
                )
            }
        }

        impl GitPort for Scripted {
            fn probe(&self, _folder: &Path) -> RootFinding {
                self.probe.clone()
            }

            fn state(&self, _root: &Path) -> Result<HeadState, GitReadCondition> {
                self.state.clone()
            }

            fn status(&self, _root: &Path) -> Result<StatusLists, GitReadCondition> {
                self.status.clone()
            }
        }

        fn opened_model() -> FolderModel {
            let folder = TempDir::new();
            let OpenFolderOutcome::Opened(opened) = open_folder(folder.path()) else {
                panic!("the temporary folder opens");
            };
            FolderModel::new(opened)
        }

        /// The wire of the item `port` makes the model hold.
        fn wire(port: &Scripted) -> Value {
            let model = read_git(opened_model(), port);
            serde_json::to_value(GitAnswerDto::from(model.kind())).expect("the answer serializes")
        }

        fn members(value: &Value) -> Vec<String> {
            let mut names: Vec<String> = value
                .as_object()
                .expect("an object")
                .keys()
                .cloned()
                .collect();
            names.sort();
            names
        }

        fn entry(path: &str, category: StatusCategory) -> StatusEntry {
            StatusEntry {
                path: path.to_string(),
                category,
            }
        }

        #[test]
        fn test_pending_item_is_exactly_state_pending() {
            let model = opened_model();

            let value = serde_json::to_value(GitAnswerDto::from(model.kind()))
                .expect("the answer serializes");

            assert_eq!(value, json!({ "state": "pending" }));
        }

        #[test]
        fn test_observed_plain_is_exactly_state_and_kind() {
            let value = wire(&Scripted {
                probe: RootFinding::Plain,
                state: Err(GitReadCondition::NotARoot),
                status: Err(GitReadCondition::NotARoot),
            });

            assert_eq!(value, json!({ "state": "observed", "kind": "plain" }));
        }

        #[test]
        fn test_observed_root_holds_exactly_the_six_named_members() {
            let value = wire(&Scripted::root_in(RepositoryState::Normal));

            assert_eq!(
                members(&value),
                vec![
                    "branch",
                    "changed",
                    "kind",
                    "repository_state",
                    "staged",
                    "state"
                ]
            );
            assert_eq!(value["state"], "observed");
            assert_eq!(value["kind"], "root");
            assert_eq!(value["staged"], json!([]));
            assert_eq!(value["changed"], json!([]));
        }

        #[test]
        fn test_every_entry_holds_exactly_path_and_category_except_renamed() {
            let value = wire(&Scripted::root(
                HeadState {
                    branch: BranchElement::Branch("main".to_string()),
                    state: RepositoryState::Normal,
                },
                StatusLists {
                    staged: vec![
                        entry("a", StatusCategory::Added),
                        entry(
                            "b",
                            StatusCategory::Renamed {
                                from: "old-b".to_string(),
                            },
                        ),
                    ],
                    changed: vec![
                        entry("c", StatusCategory::Modified),
                        entry("d", StatusCategory::Deleted),
                        entry("e", StatusCategory::Untracked),
                        entry("f", StatusCategory::InConflict),
                    ],
                },
            ));

            let staged = value["staged"].as_array().expect("a staged list");
            let changed = value["changed"].as_array().expect("a changed list");
            assert_eq!(members(&staged[0]), vec!["category", "path"]);
            assert_eq!(members(&staged[1]), vec!["category", "from", "path"]);
            assert_eq!(
                staged[1],
                json!({ "path": "b", "category": "renamed", "from": "old-b" })
            );
            for entry in changed {
                assert_eq!(members(entry), vec!["category", "path"], "{entry}");
            }
        }

        #[test]
        fn test_three_changed_files_cross_as_three_entries_in_the_core_order() {
            let value = wire(&Scripted::root_changed(vec![
                entry("zeta.txt", StatusCategory::Modified),
                entry("alpha.txt", StatusCategory::Modified),
                entry("mid.txt", StatusCategory::Untracked),
            ]));

            let paths: Vec<&str> = value["changed"]
                .as_array()
                .expect("a changed list")
                .iter()
                .map(|entry| entry["path"].as_str().expect("a path"))
                .collect();
            assert_eq!(paths, vec!["zeta.txt", "alpha.txt", "mid.txt"]);
            assert_eq!(
                members(&value),
                vec![
                    "branch",
                    "changed",
                    "kind",
                    "repository_state",
                    "staged",
                    "state"
                ],
                "no count member and no sort key"
            );
        }

        #[test]
        fn test_each_of_the_eight_repository_states_has_its_own_wire_value() {
            let states = [
                (RepositoryState::Normal, "normal"),
                (RepositoryState::Merge, "merge"),
                (RepositoryState::Rebase, "rebase"),
                (RepositoryState::CherryPick, "cherry_pick"),
                (RepositoryState::Revert, "revert"),
                (RepositoryState::Bisect, "bisect"),
                (RepositoryState::Am, "am"),
                (RepositoryState::DetachedHead, "detached_head"),
            ];

            let wires: Vec<Value> = states
                .iter()
                .map(|(state, _)| {
                    wire(&Scripted::root_in(state.clone()))["repository_state"].clone()
                })
                .collect();

            let expected: Vec<Value> = states.iter().map(|(_, text)| json!(text)).collect();
            assert_eq!(wires, expected);
            let distinct: BTreeSet<String> = wires.iter().map(Value::to_string).collect();
            assert_eq!(distinct.len(), 8);
        }

        #[test]
        fn test_each_of_the_six_categories_has_its_own_wire_value() {
            let categories = [
                (StatusCategory::Added, "added"),
                (StatusCategory::Modified, "modified"),
                (StatusCategory::Deleted, "deleted"),
                (
                    StatusCategory::Renamed {
                        from: "was".to_string(),
                    },
                    "renamed",
                ),
                (StatusCategory::Untracked, "untracked"),
                (StatusCategory::InConflict, "in_conflict"),
            ];

            let wires: Vec<Value> = categories
                .iter()
                .map(|(category, _)| {
                    wire(&Scripted::root_changed(vec![entry("p", category.clone())]))["changed"][0]
                        ["category"]
                        .clone()
                })
                .collect();

            let expected: Vec<Value> = categories.iter().map(|(_, text)| json!(text)).collect();
            assert_eq!(wires, expected);
            let distinct: BTreeSet<String> = wires.iter().map(Value::to_string).collect();
            assert_eq!(distinct.len(), 6);
        }

        fn probe_failure(condition: ProbeCondition) -> Scripted {
            Scripted {
                probe: RootFinding::Failed(condition),
                state: Err(GitReadCondition::NotARoot),
                status: Err(GitReadCondition::NotARoot),
            }
        }

        fn read_failure(condition: GitReadCondition) -> Scripted {
            Scripted {
                probe: RootFinding::Root,
                state: Err(condition),
                status: Err(GitReadCondition::NotARoot),
            }
        }

        #[test]
        fn test_each_of_the_eleven_core_conditions_and_the_switch_failure_have_twelve_distinct_wire_values()
         {
            let mut answers: Vec<(Value, &str)> = vec![
                (
                    wire(&probe_failure(ProbeCondition::FolderUnavailable)),
                    "probe_folder_unavailable",
                ),
                (
                    wire(&probe_failure(ProbeCondition::GitDirectoryUnreadable)),
                    "probe_git_directory_unreadable",
                ),
                (
                    wire(&probe_failure(ProbeCondition::GitEntryNotDirectory)),
                    "probe_git_entry_not_directory",
                ),
                (
                    wire(&probe_failure(ProbeCondition::GitFileUnreadable)),
                    "probe_git_file_unreadable",
                ),
                (
                    wire(&probe_failure(ProbeCondition::RepositoryReadFailed)),
                    "probe_repository_read_failed",
                ),
                (
                    wire(&read_failure(GitReadCondition::GitDirectoryOutside(
                        PathBuf::from("/elsewhere/.git"),
                    ))),
                    "git_directory_outside",
                ),
                (
                    wire(&read_failure(GitReadCondition::NotARoot)),
                    "not_a_root",
                ),
                (
                    wire(&read_failure(GitReadCondition::GitDirectoryMissing)),
                    "git_directory_missing",
                ),
                (
                    wire(&read_failure(GitReadCondition::GitDirectoryUnreadable)),
                    "git_directory_unreadable",
                ),
                (
                    wire(&read_failure(GitReadCondition::NotARepository)),
                    "not_a_repository",
                ),
                (
                    wire(&read_failure(GitReadCondition::RepositoryReadFailed)),
                    "repository_read_failed",
                ),
            ];
            answers.push((
                serde_json::to_value(GitAnswerDto::machine_config_not_switched_off())
                    .expect("the answer serializes"),
                "machine_config_not_switched_off",
            ));

            for (answer, condition) in &answers {
                assert_eq!(answer["state"], "failed", "{answer}");
                assert_eq!(answer["condition"], *condition, "{answer}");
            }
            let distinct: BTreeSet<String> = answers
                .iter()
                .map(|(answer, _)| answer["condition"].to_string())
                .collect();
            assert_eq!(distinct.len(), 12);
        }

        #[test]
        fn test_git_directory_member_appears_only_for_git_directory_outside() {
            let outside = wire(&read_failure(GitReadCondition::GitDirectoryOutside(
                PathBuf::from("/elsewhere/.git"),
            )));
            let others = [
                wire(&probe_failure(ProbeCondition::FolderUnavailable)),
                wire(&read_failure(GitReadCondition::NotARoot)),
                wire(&read_failure(GitReadCondition::RepositoryReadFailed)),
                serde_json::to_value(GitAnswerDto::machine_config_not_switched_off())
                    .expect("the answer serializes"),
            ];

            assert_eq!(
                outside,
                json!({
                    "state": "failed",
                    "condition": "git_directory_outside",
                    "git_directory": "/elsewhere/.git"
                })
            );
            for other in others {
                assert_eq!(members(&other), vec!["condition", "state"], "{other}");
            }
        }

        #[test]
        fn test_branch_and_detached_identifier_spell_as_the_core_reads_them() {
            let commit = "62290d82ec30f74dbffb792140ea647be14eb18c";
            let on_branch = wire(&Scripted::root_in(RepositoryState::Normal));
            let detached = wire(&Scripted::root(
                HeadState {
                    branch: BranchElement::Detached(commit.to_string()),
                    state: RepositoryState::DetachedHead,
                },
                StatusLists {
                    staged: Vec::new(),
                    changed: Vec::new(),
                },
            ));

            assert_eq!(
                on_branch["branch"],
                json!({ "kind": "branch", "name": "main" })
            );
            assert_eq!(
                detached["branch"],
                json!({ "kind": "detached", "commit": commit })
            );
            assert_eq!(commit.len(), 40);
        }

        #[test]
        fn test_non_utf8_git_directory_is_a_non_null_answer_with_the_lossy_spelling() {
            let path = PathBuf::from(OsStr::from_bytes(b"/elsewhere/\xff/.git"));
            let model = read_git(
                opened_model(),
                &read_failure(GitReadCondition::GitDirectoryOutside(path)),
            );

            let value = serde_json::to_value(GitAnswerDto::from(model.kind()))
                .expect("a non-UTF-8 path still serializes");

            assert_eq!(value["state"], "failed");
            assert_eq!(value["git_directory"], "/elsewhere/\u{fffd}/.git");
        }

        #[test]
        fn test_switch_failure_carries_no_path_and_no_library_text() {
            let value = serde_json::to_value(GitAnswerDto::machine_config_not_switched_off())
                .expect("the answer serializes");

            assert_eq!(
                value,
                json!({ "state": "failed", "condition": "machine_config_not_switched_off" })
            );
        }
    }
}
