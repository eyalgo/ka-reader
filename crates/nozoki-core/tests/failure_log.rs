//! CP-30, the core half: a Failed listing emits exactly one `warn` record without a path, and
//! neither a Refused nor a Listed listing emits any.
//!
//! `log` has one global logger per process, so this is the only test in its binary.

mod common;

use std::sync::Mutex;

use common::TempDir;
use log::{LevelFilter, Log, Metadata, Record};
use nozoki_core::{Listing, list_tree, open_folder};

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
fn failed_listing_emits_one_warn_without_path_and_others_emit_none() {
    log::set_logger(&CAPTURE).expect("no other logger is installed in this binary");
    log::set_max_level(LevelFilter::Warn);
    let folder = TempDir::new();
    folder.write_file("readable/file.txt", "");
    folder.make_folder("locked-folder");
    folder.set_mode("locked-folder", 0o000);
    let opened = open_folder(folder.path()).expect("a folder opens");

    assert!(matches!(list_tree(&opened, "readable"), Listing::Listed(_)));
    assert_eq!(list_tree(&opened, ".."), Listing::Refused);
    assert!(take_records().is_empty(), "Listed and Refused emit nothing");

    assert!(matches!(
        list_tree(&opened, "locked-folder"),
        Listing::Failed(_)
    ));
    let records = take_records();

    assert_eq!(
        records.len(),
        1,
        "one record per Failed listing: {records:?}"
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
}
