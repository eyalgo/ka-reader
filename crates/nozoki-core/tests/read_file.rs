//! Layer 2: `select_file` over the committed text fixtures and over temporary folders. A file is
//! text or it cannot be shown as text; a read that cannot happen fails as one of the closed
//! conditions and returns (CP-267 – CP-277).

mod common;

use std::path::PathBuf;
use std::process::Command;

use common::TempDir;
use nozoki_core::{
    CannotDisplayReason, Condition, FileContent, ItemState, Language, OpenedFolder, open_folder,
    select_file,
};

fn open(folder: &TempDir) -> OpenedFolder {
    open_folder(folder.path()).expect("a folder opens")
}

/// The committed fixtures, opened as a folder.
fn fixtures() -> OpenedFolder {
    let path = PathBuf::from(env!("CARGO_MANIFEST_DIR")).join("../../checks/fixtures/text");
    open_folder(path.canonicalize().expect("the fixtures exist")).expect("the fixtures open")
}

/// The content and language of an observed text answer, or a panic naming the answer.
fn text_of(answer: ItemState<FileContent>) -> (String, Language) {
    match answer {
        ItemState::Observed(FileContent::Text { content, language }) => (content, language),
        other => panic!("expected observed text, got {other:?}"),
    }
}

#[test]
fn test_fixture_without_extension_is_plain_text() {
    let (content, language) = text_of(select_file(&fixtures(), "README"));

    assert!(content.starts_with("Nozoki reads this file as plain text."));
    assert_eq!(language, Language::Plain);
}

#[test]
fn test_fixture_with_extension_outside_the_set_is_plain_text() {
    let (_, language) = text_of(select_file(&fixtures(), "notes.txt"));

    assert_eq!(language, Language::Plain);
}

#[test]
fn test_shell_script_marker_does_not_choose_a_language() {
    let (content, language) = text_of(select_file(&fixtures(), "run"));

    assert!(content.starts_with("#!/bin/sh"));
    assert_eq!(language, Language::Plain);
}

#[test]
fn test_utf16_fixture_reads_as_text() {
    let (content, _) = text_of(select_file(&fixtures(), "utf16-le.txt"));

    assert_eq!(content, "hi\n");
}

#[test]
fn test_empty_fixture_reads_as_text() {
    let (content, _) = text_of(select_file(&fixtures(), "empty"));

    assert_eq!(content, "");
}

#[test]
fn test_latin1_fixture_is_cannot_display() {
    assert_eq!(
        select_file(&fixtures(), "latin1.txt"),
        ItemState::Observed(FileContent::CannotDisplay(CannotDisplayReason::InvalidUtf8))
    );
}

#[test]
fn test_torn_fixture_is_cannot_display() {
    assert_eq!(
        select_file(&fixtures(), "torn-utf8.txt"),
        ItemState::Observed(FileContent::CannotDisplay(CannotDisplayReason::InvalidUtf8))
    );
}

#[test]
fn test_select_file_reads_a_file_in_a_subfolder() {
    let folder = TempDir::new();
    folder.write_file("src/lib.rs", "pub fn x() {}\n");

    let (content, _) = text_of(select_file(&open(&folder), "src/lib.rs"));

    assert_eq!(content, "pub fn x() {}\n");
}

#[test]
fn test_fifo_inside_the_root_fails_unreadable_and_returns() {
    let folder = TempDir::new();
    let fifo = folder.path().join("pipe");
    let status = Command::new("mkfifo")
        .arg(&fifo)
        .status()
        .expect("mkfifo runs");
    assert!(status.success(), "mkfifo made the FIFO");

    assert_eq!(
        select_file(&open(&folder), "pipe"),
        ItemState::Failed(Condition::Unreadable)
    );
}
