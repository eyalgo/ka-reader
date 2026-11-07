//! Layer 2: `Session::open_relative_link` over real folders, the real containment check and a watcher
//! a test drives by hand. A link to a contained file opens it as a tree click does, at the empty
//! position; every other link changes nothing and answers `pending` (CP-1091 – CP-1094).
//!
//! Run them with `cargo test --locked -p ka-reader-bridge --test open_relative_link`.

#[allow(
    dead_code,
    reason = "each test crate uses a subset of the shared helpers"
)]
mod common;

use std::fs;
use std::path::{Path, PathBuf};
use std::sync::atomic::{AtomicBool, Ordering};
use std::sync::{Arc, Mutex};

use common::TempDir;
use ka_reader_bridge::session::{FileAct, FileAnswerDto, OpenResult, Session, Wiring};
use ka_reader_bridge::watcher::fakes::ManualWatching;
use ka_reader_core::{FileRead, OpenedFolder, ReadingPosition, read_file};
use serde_json::{Value, json};

/// A session over the hand-driven watcher, with no Git double (QC-50).
fn session_over(watching: &Arc<ManualWatching>) -> Session {
    Session::with_parts(Box::new(|| Wiring::SwitchFailed), watching.clone())
}

fn wire(answer: FileAnswerDto) -> Value {
    serde_json::to_value(answer).expect("the answer serializes")
}

fn pending() -> Value {
    json!({ "state": "pending" })
}

/// The committed `repo` fixture, which a test reads in place and never writes.
fn repo_fixture() -> PathBuf {
    PathBuf::from(env!("CARGO_MANIFEST_DIR")).join("../../checks/fixtures/repo")
}

/// Opens `folder` with a delivery that records every payload it receives.
fn open_delivering(session: &Session, folder: &Path) -> Arc<Mutex<Vec<Vec<u8>>>> {
    let received = Arc::new(Mutex::new(Vec::new()));
    let sink = Arc::clone(&received);
    let result = session.open_delivering(
        folder.to_path_buf(),
        Arc::new(move |payload| sink.lock().expect("the payload log").push(payload)),
    );
    assert!(matches!(result, OpenResult::Opened), "the folder must open");
    received
}

fn delivered(received: &Arc<Mutex<Vec<Vec<u8>>>>) -> Vec<Value> {
    received
        .lock()
        .expect("the payload log")
        .iter()
        .map(|bytes| serde_json::from_slice(bytes).expect("a payload is JSON"))
        .collect()
}

fn open_at(session: &Session, path: &str, at: &[u8]) {
    session.select_file(path, Some(FileAct::Open(ReadingPosition::new(at))));
}

/// What the session holds of the place: the selection, the open file's path and its position.
fn place_of(session: &Session) -> (Option<PathBuf>, Option<PathBuf>, Option<ReadingPosition>) {
    let place = session.held_place().expect("a folder is open");
    (
        place.selected().map(Path::to_path_buf),
        place.open_file().map(|open| open.path().to_path_buf()),
        place.open_file().map(|open| open.position().clone()),
    )
}

/// A read that records whether it ran, for the cases where it must not.
fn watched_read(ran: &Arc<AtomicBool>) -> impl FnOnce(&OpenedFolder, &Path) -> FileRead + use<> {
    let ran = Arc::clone(ran);
    move |folder, path| {
        ran.store(true, Ordering::SeqCst);
        read_file(folder, path)
    }
}

#[test]
fn test_open_relative_link_opens_a_markdown_file_at_the_empty_position_and_delivers_once() {
    let watching = Arc::new(ManualWatching::new());
    let session = session_over(&watching);
    let received = open_delivering(&session, &repo_fixture());
    let before = delivered(&received).len();

    let answer = session.open_relative_link("README.md");

    assert_eq!(wire(answer), json!({ "state": "markdown" }));
    assert_eq!(
        place_of(&session),
        (
            Some(PathBuf::from("README.md")),
            Some(PathBuf::from("README.md")),
            Some(ReadingPosition::new(Vec::new())),
        )
    );
    let payloads = delivered(&received);
    assert_eq!(
        payloads.len(),
        before + 1,
        "one payload arrives, before the call returns"
    );
    let open_file = &payloads[before]["open_file"];
    assert_eq!(open_file["path"], json!("README.md"));
    assert_eq!(open_file["position"], json!(""));
    assert_eq!(open_file["answer"], json!({ "state": "markdown" }));
}

#[test]
fn test_open_relative_link_answers_a_text_file_in_the_open_grammar() {
    let folder = TempDir::new();
    folder.write_file("src/main.rs", "fn main() {}\n");
    let linked = Session::default();
    linked.open(folder.path().to_path_buf());
    let clicked = Session::default();
    clicked.open(folder.path().to_path_buf());

    let by_link = wire(linked.open_relative_link("src/main.rs"));
    let by_click = wire(clicked.select_file(
        "src/main.rs",
        Some(FileAct::Open(ReadingPosition::new(Vec::new()))),
    ));

    assert_eq!(
        by_link,
        json!({ "state": "text", "content": "fn main() {}\n", "language": "plain" }),
        "no spans member beside a plain language"
    );
    assert_eq!(by_link, by_click, "the answer a click gives");
}

#[test]
fn test_open_relative_link_does_nothing_for_what_is_not_a_contained_file() {
    let folder = TempDir::new();
    let outside = TempDir::new();
    folder.write_file("src/main.rs", "fn main() {}\n");
    folder.make_link("escape.png", outside.write_file("secret.png", "outside"));
    let watching = Arc::new(ManualWatching::new());
    let session = session_over(&watching);
    let received = open_delivering(&session, folder.path());
    open_at(&session, "src/main.rs", b"line=7;x=2");
    let place = place_of(&session);
    let payloads_before = delivered(&received).len();
    let absolute = folder.path().join("src/main.rs");

    for refused in [
        "src",
        "../outside.md",
        "escape.png",
        absolute.to_str().expect("the path is text"),
    ] {
        let read_ran = Arc::new(AtomicBool::new(false));

        let answer = session.open_relative_link_with(refused, watched_read(&read_ran));

        assert_eq!(wire(answer), pending(), "{refused}");
        assert!(
            !read_ran.load(Ordering::SeqCst),
            "{refused}: no read happens"
        );
        assert_eq!(
            place_of(&session),
            place,
            "{refused}: the place is unchanged"
        );
        assert_eq!(
            delivered(&received).len(),
            payloads_before,
            "{refused}: nothing is delivered"
        );
    }
}

#[test]
fn test_open_relative_link_with_no_folder_open_answers_pending_and_reads_nothing() {
    let session = Session::default();
    let read_ran = Arc::new(AtomicBool::new(false));

    let answer = session.open_relative_link_with("README.md", watched_read(&read_ran));

    assert_eq!(wire(answer), pending());
    assert!(!read_ran.load(Ordering::SeqCst), "no read happens");
}

#[test]
fn test_a_link_target_swapped_for_a_symlink_out_after_the_document_rendered_does_nothing() {
    let folder = TempDir::new();
    let outside = TempDir::new();
    folder.write_file("doc.md", "[notes](notes.md)\n");
    folder.write_file("notes.md", "# Notes\n");
    let session = Session::default();
    session.open(folder.path().to_path_buf());
    open_at(&session, "doc.md", b"line=1;x=0");
    let place = place_of(&session);
    fs::remove_file(folder.path().join("notes.md")).expect("the file is removed");
    folder.make_link(
        "notes.md",
        outside.write_file("notes.md", "# Not for the page\n"),
    );

    let answer = session.open_relative_link("notes.md");

    assert_eq!(wire(answer), pending());
    assert_eq!(place_of(&session), place, "nothing changed");
}

#[test]
fn test_a_later_select_act_during_the_links_read_wins() {
    let folder = TempDir::new();
    folder.write_file("a.md", "# A\n");
    folder.write_file("b.rs", "fn b() {}\n");
    let session = Session::default();
    session.open(folder.path().to_path_buf());

    session.open_relative_link_with("a.md", |opened, path| {
        session.select_file("b.rs", Some(FileAct::Select));
        read_file(opened, path)
    });

    let (selected, open, _) = place_of(&session);
    assert_eq!(selected, Some(PathBuf::from("b.rs")), "b.rs stays selected");
    assert_ne!(
        open,
        Some(PathBuf::from("a.md")),
        "a.md is not the open file"
    );
}
