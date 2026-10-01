//! Layer 2: the file answer across the bridge, over temporary folders and the committed text
//! fixtures. The wire is one JSON object tagged by `state`, with exactly the members the state names
//! (CP-267 – CP-271).

#[allow(
    dead_code,
    reason = "each test crate uses a subset of the shared helpers"
)]
mod common;

use std::collections::hash_map::DefaultHasher;
use std::fs;
use std::hash::{Hash, Hasher};
use std::path::PathBuf;

use common::TempDir;
use nozoki_bridge::session::Session;
use serde_json::{Value, json};

fn opened(folder: &std::path::Path) -> Session {
    let session = Session::default();
    session.open(folder.to_path_buf());
    session
}

fn wire(session: &Session, path: &str) -> Value {
    serde_json::to_value(session.select_file(path)).expect("the answer serializes")
}

#[test]
fn test_select_file_before_any_open_answers_pending() {
    assert_eq!(
        wire(&Session::default(), "a.txt"),
        json!({ "state": "pending" })
    );
}

#[test]
fn test_select_file_answers_text_exactly() {
    let folder = TempDir::new();
    folder.write_file("a.txt", "héllo\n");

    assert_eq!(
        wire(&opened(folder.path()), "a.txt"),
        json!({ "state": "text", "content": "héllo\n", "language": "plain" })
    );
}

#[test]
fn test_select_file_answers_cannot_display_exactly() {
    let folder = TempDir::new();
    fs::write(folder.path().join("latin1.txt"), [0x63, 0x61, 0x66, 0xE9]).expect("written");

    assert_eq!(
        wire(&opened(folder.path()), "latin1.txt"),
        json!({ "state": "cannot_display", "reason": "invalid_utf8" })
    );
}

#[test]
fn test_select_file_answers_cannot_display_for_utf16_exactly() {
    let folder = TempDir::new();
    fs::write(
        folder.path().join("odd.txt"),
        [0xFF, 0xFE, 0x68, 0x00, 0x69],
    )
    .expect("written");

    assert_eq!(
        wire(&opened(folder.path()), "odd.txt"),
        json!({ "state": "cannot_display", "reason": "invalid_utf16" })
    );
}

#[test]
fn test_select_file_answers_failed_exactly() {
    let folder = TempDir::new();

    assert_eq!(
        wire(&opened(folder.path()), "../x"),
        json!({ "state": "failed", "condition": "outside" })
    );
}

#[test]
fn test_select_file_carries_every_condition_by_its_wire_name() {
    let folder = TempDir::new();
    folder.make_folder("dir");
    folder.make_link("dangling", "nowhere");
    let session = opened(folder.path());

    assert_eq!(
        wire(&session, "dir"),
        json!({ "state": "failed", "condition": "unreadable" })
    );
    assert_eq!(
        wire(&session, "dangling"),
        json!({ "state": "failed", "condition": "missing" })
    );
}

#[test]
fn test_reading_every_text_fixture_leaves_its_bytes_unchanged() {
    let fixtures = PathBuf::from(env!("CARGO_MANIFEST_DIR"))
        .join("../../checks/fixtures/text")
        .canonicalize()
        .expect("the fixtures exist");
    let session = opened(&fixtures);
    let mut read = 0;

    for entry in fs::read_dir(&fixtures).expect("the fixtures list") {
        let entry = entry.expect("an entry");
        let name = entry.file_name().into_string().expect("a UTF-8 name");
        let before = digest(&fs::read(entry.path()).expect("readable"));

        let answer = wire(&session, &name);

        assert_ne!(answer["state"], "pending", "{name} was read");
        assert_ne!(answer["state"], "failed", "{name} was read");
        assert_eq!(
            before,
            digest(&fs::read(entry.path()).expect("readable")),
            "{name}"
        );
        read += 1;
    }
    assert!(read >= 7, "the seven fixtures were all read, got {read}");
}

fn digest(bytes: &[u8]) -> u64 {
    let mut hasher = DefaultHasher::new();
    bytes.hash(&mut hasher);
    hasher.finish()
}
