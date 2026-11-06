//! Layer 2: the file acts across the bridge's session, over temporary folders and a watcher a test
//! drives by hand. The open act selects and opens a file at a position and answers today's file
//! answer; the position act moves the open file's position and answers `pending` (CP-1022).
//!
//! Run them with `cargo test --locked -p ka-reader-bridge --test open_file`.

#[allow(
    dead_code,
    reason = "each test crate uses a subset of the shared helpers"
)]
mod common;

use std::path::{Path, PathBuf};
use std::sync::{Arc, Mutex};

use common::TempDir;
use ka_reader_bridge::session::{FileAct, FileAnswerDto, OpenResult, Session, Wiring};
use ka_reader_bridge::watcher::fakes::ManualWatching;
use ka_reader_core::{FileView, ItemState, ReadingPosition, read_file};
use serde_json::{Value, json};

fn position(bytes: &[u8]) -> ReadingPosition {
    ReadingPosition::new(bytes)
}

/// A session over the hand-driven watcher, with no Git double (QC-50).
fn session_over(watching: &Arc<ManualWatching>) -> Session {
    Session::with_parts(Box::new(|| Wiring::SwitchFailed), watching.clone())
}

/// Opens `folder` with a delivery that records every payload it receives.
fn open_delivering(session: &Session, folder: &TempDir) -> Arc<Mutex<Vec<Vec<u8>>>> {
    let received = Arc::new(Mutex::new(Vec::new()));
    let sink = Arc::clone(&received);
    let result = session.open_delivering(
        folder.path().to_path_buf(),
        Arc::new(move |payload| sink.lock().expect("the payload log").push(payload)),
    );
    assert!(matches!(result, OpenResult::Opened), "the folder must open");
    received
}

fn root_of(folder: &TempDir) -> PathBuf {
    folder.path().canonicalize().expect("a canonical folder")
}

fn wire(answer: FileAnswerDto) -> Value {
    serde_json::to_value(answer).expect("the answer serializes")
}

/// The text the held model shows for its open file, if it shows text.
fn held_text(session: &Session) -> Option<String> {
    let place = session.held_place()?;
    match place.open_file()?.view() {
        ItemState::Observed(FileView::Text { content, .. }) => Some(content.clone()),
        _ => None,
    }
}

#[test]
fn test_the_open_act_answers_exactly_todays_json_for_text_failed_and_pending() {
    let folder = TempDir::new();
    folder.write_file("a.txt", "hello\n");
    let watching = Arc::new(ManualWatching::new());
    let session = session_over(&watching);
    let open = || Some(FileAct::Open(position(b"top")));

    let before_any_open = wire(session.select_file("a.txt", open()));
    session.open(folder.path().to_path_buf());
    let text = wire(session.select_file("a.txt", open()));
    let failed = wire(session.select_file("missing.txt", open()));

    assert_eq!(before_any_open, json!({ "state": "pending" }));
    assert_eq!(
        text,
        json!({ "state": "text", "content": "hello\n", "language": "plain" })
    );
    assert_eq!(failed, json!({ "state": "failed", "condition": "missing" }));
}

#[test]
fn test_the_open_act_holds_the_path_selected_and_opened_at_the_position_given() {
    let folder = TempDir::new();
    folder.write_file("a.txt", "hello\n");
    let watching = Arc::new(ManualWatching::new());
    let session = session_over(&watching);
    session.open(folder.path().to_path_buf());

    session.select_file("a.txt", Some(FileAct::Open(position(b"line=7;x=2"))));

    let place = session.held_place().expect("a folder is open");
    assert_eq!(place.selected(), Some(Path::new("a.txt")));
    let open = place.open_file().expect("the file is open");
    assert_eq!(open.path(), Path::new("a.txt"));
    assert_eq!(open.position(), &position(b"line=7;x=2"));
    assert_eq!(held_text(&session).as_deref(), Some("hello\n"));
}

#[test]
fn test_the_position_act_on_the_open_file_sets_it_and_answers_pending() {
    let folder = TempDir::new();
    folder.write_file("a.txt", "hello\n");
    let watching = Arc::new(ManualWatching::new());
    let session = session_over(&watching);
    let received = open_delivering(&session, &folder);
    session.select_file("a.txt", Some(FileAct::Open(position(b"top"))));

    let answer = session.select_file("a.txt", Some(FileAct::Position(position(b"line=40;x=0"))));

    assert_eq!(wire(answer), json!({ "state": "pending" }));
    let place = session.held_place().expect("a folder is open");
    assert_eq!(
        place.open_file().expect("still open").position(),
        &position(b"line=40;x=0")
    );
    assert!(
        received.lock().expect("the payload log").is_empty(),
        "a position act delivers nothing"
    );
}

#[test]
fn test_the_position_act_on_another_path_changes_nothing() {
    let folder = TempDir::new();
    folder.write_file("a.txt", "hello\n");
    folder.write_file("b.txt", "other\n");
    let watching = Arc::new(ManualWatching::new());
    let session = session_over(&watching);
    session.open(folder.path().to_path_buf());
    session.select_file("a.txt", Some(FileAct::Open(position(b"top"))));
    let before = session.held_place();

    let answer = session.select_file("b.txt", Some(FileAct::Position(position(b"line=9"))));

    assert_eq!(wire(answer), json!({ "state": "pending" }));
    assert_eq!(session.held_place(), before);
}

#[test]
fn test_an_unknown_act_answers_pending_and_changes_nothing() {
    let folder = TempDir::new();
    folder.write_file("a.txt", "hello\n");
    let watching = Arc::new(ManualWatching::new());
    let session = session_over(&watching);
    session.open(folder.path().to_path_buf());
    session.select_file("a.txt", Some(FileAct::Open(position(b"top"))));
    let before = session.held_place();

    let answer = session.select_file("a.txt", None);

    assert_eq!(wire(answer), json!({ "state": "pending" }));
    assert_eq!(session.held_place(), before);
}

#[test]
fn test_a_batch_pushed_while_the_opens_read_is_out_leaves_the_held_open_file_with_the_rewritten_text()
 {
    let folder = TempDir::new();
    folder.write_file("a.txt", "old\n");
    let watching = Arc::new(ManualWatching::new());
    let session = session_over(&watching);
    let _received = open_delivering(&session, &folder);
    let subscription = watching
        .subscription_for(&root_of(&folder))
        .expect("a subscription on the folder");

    let answer = session.select_file_with(
        "a.txt",
        Some(FileAct::Open(position(b"top"))),
        |opened, path| {
            let read = read_file(opened, path);
            folder.write_file("a.txt", "new\n");
            subscription.push(vec![root_of(&folder).join("a.txt")]);
            read
        },
    );

    assert_eq!(
        wire(answer),
        json!({ "state": "text", "content": "old\n", "language": "plain" }),
        "the answer is what the read gave"
    );
    assert_eq!(
        held_text(&session).as_deref(),
        Some("new\n"),
        "the change that landed during the read is not lost"
    );
}

#[test]
fn test_a_selection_is_applied_to_the_held_model_on_the_path_given() {
    let folder = TempDir::new();
    folder.write_file("a.txt", "x");
    let watching = Arc::new(ManualWatching::new());
    let session = session_over(&watching);
    session.open(folder.path().to_path_buf());

    session.select_file("a.txt", Some(FileAct::Open(position(b"top"))));

    let place = session.held_place().expect("a folder is open");
    assert_eq!(place.selected(), Some(Path::new("a.txt")));
}
