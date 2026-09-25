//! CP-30 and CP-180, the core half, across every shape of failure — added by development-code-integrity.
//!
//! `failure_log.rs` proves the rule on one shape, an unreadable folder. CP-180 states it for every
//! one: a failed answer emits one line and a failed entry emits one line, each carrying the part,
//! the operation and some error text, and none names a path. CP-27 names three kinds of unlistable
//! path (a file, a path that no longer exists, a folder it may not read). A path through a file, a
//! dangling link and a link cycle are Failed too. An answer that is Outside is a failed answer, and it
//! emits its line like the rest (spec Gap 7 reversed the earlier "a refusal emits nothing").
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
use nozoki_core::{Condition, ItemState, list_tree, open_folder};

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

const LIST_PREFIX: &str = "fs-reader: list failed: ";
const ENTRY_PREFIX: &str = "fs-reader: entry failed: ";

/// The text after `prefix`, held to the CP-180 bar: non-empty, and no name, no root path and no `/`.
fn pathless_text<'a>(message: &'a str, prefix: &str, what: &str, root: &str) -> &'a str {
    let text = message
        .strip_prefix(prefix)
        .unwrap_or_else(|| panic!("{what}: the line names part and operation: {message}"));
    assert!(!text.trim().is_empty(), "{what}: error text: {message}");
    assert!(!message.contains("zq-"), "{what}: names a path: {message}");
    assert!(!message.contains(root), "{what}: names the root: {message}");
    assert!(!message.contains('/'), "{what}: holds a path: {message}");
    text
}

#[test]
fn every_failed_shape_emits_one_pathless_warn_and_a_root_one_line_per_failed_entry() {
    log::set_logger(&CAPTURE).expect("no other logger is installed in this binary");
    log::set_max_level(LevelFilter::Warn);
    let folder = TempDir::new();
    let outside = TempDir::new();
    folder.write_file("zq-file", "");
    folder.make_link("zq-dangling", "zq-nowhere");
    folder.make_link("zq-loop-a", "zq-loop-b");
    folder.make_link("zq-loop-b", "zq-loop-a");
    folder.make_link("zq-escape", outside.path());
    folder.make_link("zq-through", "zq-file/zq-x");
    let opened = open_folder(folder.path()).expect("a folder opens");
    let root = folder.path().display().to_string();

    for outside_path in ["/etc", "..", "../zq-x", "zq-escape"] {
        assert_eq!(
            list_tree(&opened, outside_path),
            ItemState::Failed(Condition::Outside),
            "{outside_path}"
        );
        let records = take_records();
        assert_eq!(records.len(), 1, "{outside_path}: one record: {records:?}");
        assert_eq!(records[0].0, log::Level::Warn, "{outside_path}");
        pathless_text(&records[0].1, LIST_PREFIX, outside_path, &root);
    }

    // A link whose target runs through a file is Missing (CP-193), and it logs like the rest.
    assert_eq!(
        list_tree(&opened, "zq-through"),
        ItemState::Failed(Condition::Missing)
    );
    let records = take_records();
    assert_eq!(records.len(), 1, "zq-through: one record: {records:?}");
    assert_eq!(records[0].0, log::Level::Warn, "zq-through");
    pathless_text(&records[0].1, LIST_PREFIX, "zq-through", &root);

    for failed in [
        "zq-file",
        "zq-gone",
        "zq-file/zq-under",
        "zq-dangling",
        "zq-loop-a",
    ] {
        assert!(
            matches!(list_tree(&opened, failed), ItemState::Failed(_)),
            "{failed} must be Failed"
        );
        let records = take_records();
        assert_eq!(records.len(), 1, "{failed}: one record: {records:?}");
        let (level, message) = &records[0];
        assert_eq!(*level, log::Level::Warn, "{failed}");
        pathless_text(message, LIST_PREFIX, failed, &root);
    }

    listing_the_root_emits_one_entry_line_for_each_failed_entry_and_no_list_line();
}

/// Listing the root, which holds five failed entries, emits five entry lines and no list line.
fn listing_the_root_emits_one_entry_line_for_each_failed_entry_and_no_list_line() {
    let folder = TempDir::new();
    let outside = TempDir::new();
    folder.write_file("zq-file", "");
    folder.make_link("zq-dangling", "zq-nowhere");
    folder.make_link("zq-loop-a", "zq-loop-b");
    folder.make_link("zq-loop-b", "zq-loop-a");
    folder.make_link("zq-escape", outside.path());
    folder.make_link("zq-through", "zq-file/zq-x");
    let opened = open_folder(folder.path()).expect("a folder opens");
    let root = folder.path().display().to_string();

    assert!(matches!(list_tree(&opened, ""), ItemState::Observed(_)));
    let records = take_records();

    // zq-dangling, zq-loop-a, zq-loop-b, zq-escape and zq-through fail as entries. zq-file is observed
    // and adds none.
    assert_eq!(records.len(), 5, "one line per failed entry: {records:?}");
    for (level, message) in &records {
        assert_eq!(*level, log::Level::Warn);
        pathless_text(message, ENTRY_PREFIX, "a failed entry", &root);
    }
}
