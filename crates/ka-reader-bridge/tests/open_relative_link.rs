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

use std::ffi::CString;
use std::fs;
use std::path::{Path, PathBuf};
use std::ptr;
use std::sync::atomic::{AtomicBool, Ordering};
use std::sync::{Arc, Mutex};

use common::TempDir;
use ka_reader_bridge::boundary::link_entry;
use ka_reader_bridge::exports::{ka_reader_free, ka_reader_open_relative_link};
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

/// The answer for `checks/fixtures/repo/README.md` (`# repo fixture`): the tag and `blocks`, and
/// nothing else (CP-1100).
fn readme_document() -> Value {
    json!({ "state": "markdown", "blocks": [{ "kind": "heading", "level": 1,
            "content": [{ "kind": "text", "text": "repo fixture" }] }] })
}

#[test]
fn test_open_relative_link_opens_a_markdown_file_at_the_empty_position_and_delivers_once() {
    let watching = Arc::new(ManualWatching::new());
    let session = session_over(&watching);
    let received = open_delivering(&session, &repo_fixture());
    let before = delivered(&received).len();

    let answer = session.open_relative_link("README.md");

    assert_eq!(wire(answer), readme_document());
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
    assert_eq!(open_file["answer"], readme_document());
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
fn test_open_relative_link_replaces_the_open_file_and_opens_at_the_empty_position() {
    let folder = TempDir::new();
    folder.write_file("a.md", "# A\n");
    folder.write_file("b.rs", "fn b() {}\n");
    let session = Session::default();
    session.open(folder.path().to_path_buf());
    open_at(&session, "a.md", b"line=9;x=4");

    session.open_relative_link("b.rs");

    assert_eq!(
        place_of(&session),
        (
            Some(PathBuf::from("b.rs")),
            Some(PathBuf::from("b.rs")),
            Some(ReadingPosition::new(Vec::new())),
        ),
        "the link's file is selected and open, at the empty position and not the last file's"
    );
}

#[test]
fn test_open_relative_link_answers_each_verdict_as_a_click_on_the_file_does() {
    let folder = TempDir::new();
    folder.write_file("tool.py", "def run():\n    return 1\n");
    folder.write_bytes("data.bin", &[0xFF, 0xFE, 0x00, 0xD8, 0x80]);
    let linked = Session::default();
    linked.open(folder.path().to_path_buf());
    let clicked = Session::default();
    clicked.open(folder.path().to_path_buf());

    for path in ["tool.py", "data.bin"] {
        let by_link = wire(linked.open_relative_link(path));
        let by_click =
            wire(clicked.select_file(path, Some(FileAct::Open(ReadingPosition::new(Vec::new())))));

        assert_eq!(by_link, by_click, "{path}: the answer a click gives");
    }
    let python = wire(linked.open_relative_link("tool.py"));
    assert_eq!(python["state"], json!("text"));
    assert_eq!(python["language"], json!("python"));
    assert!(
        python.get("spans").is_some(),
        "a floor language carries its spans: {python}"
    );
    assert_eq!(
        wire(linked.open_relative_link("data.bin"))["state"],
        json!("cannot_display")
    );
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
        "missing.md",
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
    let watching = Arc::new(ManualWatching::new());
    let session = session_over(&watching);
    let received = open_delivering(&session, folder.path());
    open_at(&session, "doc.md", b"line=1;x=0");
    let place = place_of(&session);
    let payloads_before = delivered(&received).len();
    fs::remove_file(folder.path().join("notes.md")).expect("the file is removed");
    folder.make_link(
        "notes.md",
        outside.write_file("notes.md", "# Not for the page\n"),
    );
    let read_ran = Arc::new(AtomicBool::new(false));

    let answer = session.open_relative_link_with("notes.md", watched_read(&read_ran));

    assert_eq!(wire(answer), pending());
    assert_eq!(place_of(&session), place, "nothing changed");
    assert!(!read_ran.load(Ordering::SeqCst), "no read happens");
    assert_eq!(
        delivered(&received).len(),
        payloads_before,
        "nothing is delivered"
    );
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

#[test]
fn test_link_entry_answers_pending_for_a_null_an_empty_and_a_non_utf8_path() {
    let folder = TempDir::new();
    folder.write_file("a.md", "# A\n");
    let watching = Arc::new(ManualWatching::new());
    let session = session_over(&watching);
    let received = open_delivering(&session, folder.path());
    open_at(&session, "a.md", b"line=3;x=1");
    let place = place_of(&session);
    let payloads_before = delivered(&received).len();
    let empty = CString::new("").expect("no interior NUL");
    let non_utf8 = CString::new(vec![b'a', 0xFF, b'.', b'm', b'd']).expect("no interior NUL");

    // SAFETY: each pointer is NULL or a live NUL-terminated string for the call.
    let answers = unsafe {
        [
            link_entry(&session, ptr::null()),
            link_entry(&session, empty.as_ptr()),
            link_entry(&session, non_utf8.as_ptr()),
        ]
    };

    for answer in answers {
        assert_eq!(wire(answer), pending());
    }
    assert_eq!(place_of(&session), place, "nothing changed");
    assert_eq!(
        delivered(&received).len(),
        payloads_before,
        "nothing delivered"
    );
}

#[test]
fn test_link_entry_opens_a_valid_contained_path() {
    let folder = TempDir::new();
    folder.write_file("a.md", "# A\n");
    let session = Session::default();
    session.open(folder.path().to_path_buf());
    let path = CString::new("a.md").expect("no interior NUL");

    // SAFETY: `path` is a live NUL-terminated string for the call.
    let answer = unsafe { link_entry(&session, path.as_ptr()) };

    assert_eq!(
        wire(answer),
        json!({ "state": "markdown", "blocks": [{ "kind": "heading", "level": 1,
                "content": [{ "kind": "text", "text": "A" }] }] })
    );
}

/// The only test of this target that reaches the process-global session, so no folder is open in it.
#[test]
fn test_the_link_export_with_no_folder_open_answers_pending_as_json() {
    let path = CString::new("a.md").expect("no interior NUL");

    // SAFETY: `path` is a live NUL-terminated string for the call.
    let buffer = unsafe { ka_reader_open_relative_link(path.as_ptr()) };

    assert!(!buffer.is_null());
    // SAFETY: the buffer was returned a moment ago, is read before the free and freed once.
    let answer: Value = unsafe {
        let bytes = std::slice::from_raw_parts((*buffer).bytes, (*buffer).len);
        let answer = serde_json::from_slice(bytes).expect("the answer is JSON");
        ka_reader_free(buffer);
        answer
    };
    assert_eq!(answer, pending());
}
