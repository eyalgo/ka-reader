//! The exported boundary's stopped-open ownership: open-origin buffers alone can add a bridge line.

#[allow(
    dead_code,
    reason = "the shared helper offers more than this test needs"
)]
mod common;

use std::ffi::CString;
use std::sync::{Mutex, MutexGuard, Once};

use log::{Log, Metadata, Record};
use nozoki_bridge::exports::{NozokiBuffer, nozoki_free, nozoki_list_tree, nozoki_open_folder};

use common::{TempDir, capture_stderr};

static SERIAL: Mutex<()> = Mutex::new(());
static INSTALL_CAPTURE: Once = Once::new();
static CAPTURE: Capture = Capture {
    records: Mutex::new(Vec::new()),
};

struct Capture {
    records: Mutex<Vec<String>>,
}

impl Log for Capture {
    fn enabled(&self, _metadata: &Metadata<'_>) -> bool {
        true
    }

    fn log(&self, record: &Record<'_>) {
        self.records
            .lock()
            .unwrap_or_else(|poisoned| poisoned.into_inner())
            .push(record.args().to_string());
    }

    fn flush(&self) {}
}

fn begin_capture() -> MutexGuard<'static, ()> {
    let serial = SERIAL
        .lock()
        .unwrap_or_else(|poisoned| poisoned.into_inner());
    INSTALL_CAPTURE.call_once(|| {
        log::set_logger(&CAPTURE).expect("this test binary owns the logger");
        log::set_max_level(log::LevelFilter::Warn);
    });
    CAPTURE
        .records
        .lock()
        .unwrap_or_else(|poisoned| poisoned.into_inner())
        .clear();
    serial
}

fn records() -> Vec<String> {
    std::mem::take(
        &mut *CAPTURE
            .records
            .lock()
            .unwrap_or_else(|poisoned| poisoned.into_inner()),
    )
}

fn open(path: &std::path::Path) -> *mut NozokiBuffer {
    let path = CString::new(path.as_os_str().as_encoded_bytes()).expect("no interior NUL");
    // SAFETY: `path` is NUL-terminated and lives through the call.
    unsafe { nozoki_open_folder(path.as_ptr()) }
}

fn stopped(records: &[String]) -> Vec<&String> {
    records
        .iter()
        .filter(|record| record.contains("core-bridge") && record.contains("open_folder"))
        .collect()
}

#[test]
fn test_freeing_invalid_open_buffer_writes_one_stopped_line() {
    let _serial = begin_capture();
    let folder = TempDir::new();
    let buffer = open(folder.path());
    assert!(!buffer.is_null());
    // SAFETY: this live open-origin allocation has at least the opened answer's first byte.
    unsafe { *(*buffer).bytes = b'!' };

    // SAFETY: `buffer` came from the export and is freed exactly once.
    let (_, stderr) = capture_stderr(|| unsafe { nozoki_free(buffer) });
    let records = records();

    assert_eq!(records.len(), 1, "{records:?}");
    let record = &records[0];
    assert!(record.contains("core-bridge"), "{records:?}");
    assert!(record.contains("open_folder"), "{records:?}");
    assert!(
        record
            .split_once("stopped:")
            .is_some_and(|(_, error)| !error.trim().is_empty()),
        "{records:?}"
    );
    assert_eq!(stderr, "");
}

#[test]
fn test_freeing_invalid_open_buffer_excludes_folder_secrets_and_terminal_output() {
    let _serial = begin_capture();
    let folder = TempDir::new();
    let selected_path_secret = folder.make_folder("selected-path-secret");
    let fixture_content_secret = "fixture-content-secret";
    folder.write_file("selected-path-secret/fixture.txt", fixture_content_secret);
    let buffer = open(&selected_path_secret);
    assert!(!buffer.is_null());
    // SAFETY: this live open-origin allocation has at least the opened answer's first byte.
    unsafe { *(*buffer).bytes = b'!' };

    // SAFETY: `buffer` came from the export and is freed exactly once.
    let (_, stderr) = capture_stderr(|| unsafe { nozoki_free(buffer) });
    let records = records();

    assert_eq!(records.len(), 1, "{records:?}");
    assert!(!records[0].contains("selected-path-secret"), "{records:?}");
    assert!(!records[0].contains(fixture_content_secret), "{records:?}");
    assert_eq!(stderr, "");
}

#[test]
fn test_valid_open_buffers_write_no_bridge_stopped_line() {
    let _serial = begin_capture();
    let folder = TempDir::new();
    let missing = folder.path().join("missing");
    let file = folder.write_file("not-a-folder", "private fixture content");
    let unreadable = folder.make_folder("unreadable");
    folder.set_mode("unreadable", 0o000);

    for path in [
        folder.path(),
        missing.as_path(),
        file.as_path(),
        unreadable.as_path(),
    ] {
        let buffer = open(path);
        assert!(!buffer.is_null());
        // SAFETY: every buffer came from the export and is freed exactly once.
        unsafe { nozoki_free(buffer) };
    }
    let records = records();

    assert!(stopped(&records).is_empty(), "{records:?}");
}

#[test]
fn test_list_tree_origin_never_emits_stopped_open() {
    let _serial = begin_capture();
    let folder = TempDir::new();
    let opened = open(folder.path());
    // SAFETY: `opened` came from the export and is freed exactly once.
    unsafe { nozoki_free(opened) };
    // SAFETY: NULL is the documented root path.
    let listing = unsafe { nozoki_list_tree(std::ptr::null()) };
    assert!(!listing.is_null());
    // SAFETY: this live list-origin allocation has at least the root answer's first byte.
    unsafe { *(*listing).bytes = b'!' };

    // SAFETY: `listing` came from the export and is freed exactly once.
    unsafe { nozoki_free(listing) };
    let records = records();

    assert!(stopped(&records).is_empty(), "{records:?}");
}
