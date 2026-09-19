//! CP-30, the core half, across every shape of Failed — added by development-code-integrity.
//!
//! `failure_log.rs` proves the rule on one shape, an unreadable folder. The intent states it for
//! every one: "On `Failed` only: exactly one `log::warn!` whose message carries `fs-reader`, `list`,
//! and the OS error's text, and no path" (tl_instruction.md Task 2), and CP-27 names three kinds of
//! unlistable path (a file, a path that no longer exists, a folder it may not read). A path through a
//! file, a dangling link and a link cycle are Failed too (Task 2's behaviours). Each yields one line
//! carrying the part, the operation and some error text, and none names a path. A refusal of every
//! kind CP-26 lists yields none.
//!
//! `log` has one global logger per process, so this is the only test in its binary.

#[allow(
    dead_code,
    reason = "each test crate uses a subset of the shared helpers"
)]
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

const PREFIX: &str = "fs-reader: list failed: ";

#[test]
fn every_failed_shape_emits_one_pathless_warn_and_no_refusal_emits_any() {
    log::set_logger(&CAPTURE).expect("no other logger is installed in this binary");
    log::set_max_level(LevelFilter::Warn);
    let folder = TempDir::new();
    let outside = TempDir::new();
    folder.write_file("zq-file", "");
    folder.make_link("zq-dangling", "zq-nowhere");
    folder.make_link("zq-loop-a", "zq-loop-b");
    folder.make_link("zq-loop-b", "zq-loop-a");
    folder.make_link("zq-escape", outside.path());
    let opened = open_folder(folder.path()).expect("a folder opens");

    for refused in ["/etc", "..", "../zq-x", "zq-escape"] {
        assert_eq!(list_tree(&opened, refused), Listing::Refused, "{refused}");
    }
    assert!(take_records().is_empty(), "a refusal emits nothing");

    for failed in [
        "zq-file",
        "zq-gone",
        "zq-file/zq-under",
        "zq-dangling",
        "zq-loop-a",
    ] {
        assert!(
            matches!(list_tree(&opened, failed), Listing::Failed(_)),
            "{failed} must be Failed"
        );
        let records = take_records();
        assert_eq!(records.len(), 1, "{failed}: one record: {records:?}");
        let (level, message) = &records[0];
        assert_eq!(*level, log::Level::Warn, "{failed}");
        let error_text = message
            .strip_prefix(PREFIX)
            .unwrap_or_else(|| panic!("{failed}: the line names part and operation: {message}"));
        assert!(
            !error_text.trim().is_empty(),
            "{failed}: error text: {message}"
        );
        assert!(
            !message.contains("zq-"),
            "{failed}: names a path: {message}"
        );
        assert!(
            !message.contains(&folder.path().display().to_string()),
            "{failed}: names the root: {message}"
        );
        assert!(!message.contains('/'), "{failed}: holds a path: {message}");
    }
}
