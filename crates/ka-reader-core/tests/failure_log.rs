//! CP-30 and CP-180, the core half: a failed answer emits exactly one `warn` record without a path,
//! a failed entry emits one, and an answer whose entries all stand emits none.
//!
//! `log` has one global logger per process, so this is the only test in its binary.

#[allow(
    dead_code,
    reason = "each test crate uses a subset of the shared helpers"
)]
mod common;

use std::sync::Mutex;

use common::TempDir;
use ka_reader_core::{
    FileRequest, FileView, FolderModel, ItemState, OpenFailure, OpenFolderOutcome, PathReports,
    ReadingPosition, TreeRequest, list_tree, open_folder,
};
use log::{LevelFilter, Log, Metadata, Record};

struct Capture {
    records: Mutex<Vec<(log::Level, String)>>,
}

impl Log for Capture {
    fn enabled(&self, _metadata: &Metadata<'_>) -> bool {
        true
    }

    fn log(&self, record: &Record<'_>) {
        self.records
            .lock()
            .expect("the capture lock is not poisoned")
            .push((record.level(), record.args().to_string()));
    }

    fn flush(&self) {}
}

static CAPTURE: Capture = Capture {
    records: Mutex::new(Vec::new()),
};

fn take_records() -> Vec<(log::Level, String)> {
    std::mem::take(
        &mut *CAPTURE
            .records
            .lock()
            .expect("the capture lock is not poisoned"),
    )
}

#[test]
fn failed_items_emit_one_warn_each_without_a_path_and_others_emit_none() {
    log::set_logger(&CAPTURE).expect("no other logger is installed in this binary");
    log::set_max_level(LevelFilter::Warn);
    let folder = TempDir::new();
    folder.write_file("readable/file.txt", "");
    folder.make_folder("locked-folder");
    folder.set_mode("locked-folder", 0o000);
    let root_with_failure = TempDir::new();
    root_with_failure.make_link("gone", "nowhere");
    root_with_failure.make_folder("locked");
    root_with_failure.set_mode("locked", 0o000);
    let opened = open_folder(folder.path()).expect("a folder opens");
    let opened_with_failure = open_folder(root_with_failure.path()).expect("a folder opens");

    assert!(matches!(
        list_tree(&opened, "readable"),
        ItemState::Observed(_)
    ));
    assert!(
        take_records().is_empty(),
        "an answer with no failed entry emits nothing"
    );

    // `gone` fails as an entry. `locked` is a Pending folder, and adds none.
    assert!(matches!(
        list_tree(&opened_with_failure, ""),
        ItemState::Observed(_)
    ));
    let records = take_records();
    assert_eq!(records.len(), 1, "one record, for `gone`: {records:?}");
    assert_eq!(records[0].0, log::Level::Warn);
    assert!(
        records[0].1.starts_with("fs-reader: entry failed: "),
        "{records:?}"
    );

    assert!(matches!(
        list_tree(&opened, "locked-folder"),
        ItemState::Failed(_)
    ));
    let records = take_records();

    assert_eq!(
        records.len(),
        1,
        "one record per failed answer: {records:?}"
    );
    let (level, message) = &records[0];
    assert_eq!(*level, log::Level::Warn);
    assert!(message.contains("fs-reader"), "{message}");
    assert!(message.contains("list"), "{message}");
    assert!(message.contains("Permission denied"), "{message}");
    assert!(!message.contains("locked-folder"), "{message}");
    assert!(
        !message.contains(&folder.path().display().to_string()),
        "{message}"
    );

    let missing = folder.path().join("missing-open-folder");
    let file = folder.write_file("not-a-folder.txt", "private fixture content");
    let unreadable = folder.make_folder("unreadable-open-folder");
    folder.set_mode("unreadable-open-folder", 0o000);
    for (path, expected) in [
        (missing.as_path(), OpenFailure::Missing),
        (file.as_path(), OpenFailure::NotAFolder),
        (unreadable.as_path(), OpenFailure::Unreadable),
    ] {
        assert_eq!(open_folder(path), OpenFolderOutcome::Failed(expected));
        let records = take_records();
        assert_eq!(records.len(), 1, "{records:?}");
        assert_eq!(records[0].0, log::Level::Warn);
        assert!(records[0].1.contains("fs-reader"), "{records:?}");
        assert!(records[0].1.contains("open_folder"), "{records:?}");
        assert!(!records[0].1.ends_with(": "), "{records:?}");
        assert!(
            !records[0].1.contains(&path.display().to_string()),
            "{records:?}"
        );
        assert!(
            !records[0].1.contains("private fixture content"),
            "{records:?}"
        );
    }
    assert!(matches!(
        open_folder(folder.path()),
        OpenFolderOutcome::Opened(_)
    ));
    assert!(take_records().is_empty());

    for _ in 0..2 {
        assert_eq!(
            open_folder(&missing),
            OpenFolderOutcome::Failed(OpenFailure::Missing)
        );
    }
    assert_eq!(
        take_records().len(),
        2,
        "each attempt adds exactly one record"
    );

    // The open file's re-read (E13, QC-39): a failed re-read writes one line naming the part, the
    // operation and the error text and none of the file's content; a gone re-read writes none.
    let reread = TempDir::new();
    reread.write_file("secret.txt", "private fixture content");
    reread.write_file("vanishing.txt", "private fixture content");
    let position = ReadingPosition::new(b"top".as_slice());
    let open = |name: &str| {
        FolderModel::new(open_folder(reread.path()).expect("the folder opens"))
            .select_file(FileRequest::Open(name.into(), position.clone()))
    };
    let unreadable_model = open("secret.txt");
    let vanishing_model = open("vanishing.txt");
    assert!(
        take_records().is_empty(),
        "opening a readable file logs nothing"
    );
    let reports = || PathReports::new(vec![reread.path().to_path_buf()]);

    reread.set_mode("secret.txt", 0o000);
    let after = unreadable_model.list_tree(TreeRequest::Invalidate(reports()));
    let records = take_records();
    assert_eq!(
        after.open_file().map(|file| file.view()),
        Some(&ItemState::Failed(ka_reader_core::Condition::Unreadable))
    );
    assert_eq!(
        records.len(),
        1,
        "one line for the failed re-read: {records:?}"
    );
    let (level, message) = &records[0];
    assert_eq!(*level, log::Level::Warn);
    assert!(message.contains("fs-reader"), "{message}");
    assert!(message.contains("read"), "{message}");
    assert!(message.contains("Permission denied"), "{message}");
    assert!(!message.contains("private fixture content"), "{message}");
    assert!(!message.contains("secret.txt"), "{message}");

    std::fs::remove_file(reread.path().join("vanishing.txt")).expect("the file goes");
    let gone = vanishing_model.list_tree(TreeRequest::Invalidate(reports()));
    assert_eq!(
        gone.open_file().map(|file| file.view()),
        Some(&ItemState::Observed(FileView::Gone))
    );
    assert!(take_records().is_empty(), "a gone re-read writes no line");

    // The open's read (E13's sibling): a path where nothing is writes the two lines a selection
    // writes, one `read failed` and one `locate failed`, and a file that is there writes none.
    let reading = TempDir::new();
    reading.write_file("there.txt", "present");
    let folder_opened = open_folder(reading.path()).expect("the folder opens");
    let _ = ka_reader_core::read_file(&folder_opened, std::path::Path::new("there.txt"));
    assert!(take_records().is_empty(), "a readable file logs nothing");
    let missing_read =
        ka_reader_core::read_file(&folder_opened, std::path::Path::new("missing.txt"));
    assert!(matches!(missing_read.answer(), ItemState::Failed(_)));
    let records = take_records();
    assert_eq!(records.len(), 2, "{records:?}");
    assert!(
        records
            .iter()
            .any(|(_, message)| message.starts_with("fs-reader: read failed: ")),
        "{records:?}"
    );
    assert!(
        records
            .iter()
            .any(|(_, message)| message.starts_with("fs-reader: locate failed: ")),
        "{records:?}"
    );
}
