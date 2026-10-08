//! Layer 3: `ka_reader_read_git` through the exported call itself, over the process's one session.
//! Each case opens its own folder through `ka_reader_open_folder` before it asks, so the cases hold in
//! any order; they share the session, so they run one at a time.

#[allow(
    dead_code,
    reason = "each test crate uses a subset of the shared helpers"
)]
mod common;

use std::ffi::CString;
use std::os::unix::ffi::OsStrExt;
use std::path::Path;
use std::sync::Mutex;

use common::TempDir;
use ka_reader_bridge::exports::{
    KAReaderBuffer, ka_reader_free, ka_reader_open_folder, ka_reader_read_git,
};
use serde_json::{Value, json};

static ONE_AT_A_TIME: Mutex<()> = Mutex::new(());

/// Takes ownership of an exported buffer: its JSON, and the buffer freed once.
fn take_json(buffer: *mut KAReaderBuffer) -> Value {
    assert!(!buffer.is_null(), "an answer, never NULL");
    // SAFETY: the buffer was returned by the bridge a moment ago and has not been freed.
    let bytes = unsafe { std::slice::from_raw_parts((*buffer).bytes, (*buffer).len) }.to_vec();
    // SAFETY: freed exactly once, and never read again.
    unsafe { ka_reader_free(buffer) };
    serde_json::from_slice(&bytes).expect("the answer is JSON")
}

fn open(folder: &Path) {
    let location = CString::new(folder.as_os_str().as_bytes()).expect("no interior NUL");
    // SAFETY: `location` is NUL-terminated and outlives the call.
    let answer = take_json(unsafe { ka_reader_open_folder(location.as_ptr()) });
    assert_eq!(answer, json!({ "state": "opened" }));
}

fn read_git() -> Value {
    take_json(ka_reader_read_git())
}

#[test]
fn test_exported_read_git_over_repo_answers_the_observed_root() {
    let _one = ONE_AT_A_TIME.lock().unwrap_or_else(|p| p.into_inner());
    let scene = TempDir::new();
    open(&scene.repository_copy());

    assert_eq!(
        read_git(),
        json!({
            "state": "observed",
            "kind": "root",
            "branch": { "kind": "branch", "name": "main" },
            "repository_state": "normal",
            "staged": [],
            "changed": []
        })
    );
}

#[test]
fn test_exported_read_git_over_plain_answers_observed_plain() {
    let _one = ONE_AT_A_TIME.lock().unwrap_or_else(|p| p.into_inner());
    let scene = TempDir::new();
    open(&scene.copy_fixture("plain"));

    assert_eq!(read_git(), json!({ "state": "observed", "kind": "plain" }));
}

#[test]
fn test_the_buffer_from_read_git_is_freed_by_ka_reader_free() {
    let _one = ONE_AT_A_TIME.lock().unwrap_or_else(|p| p.into_inner());
    let scene = TempDir::new();
    open(&scene.copy_fixture("plain"));

    let buffer = ka_reader_read_git();
    assert!(!buffer.is_null());
    // SAFETY: the buffer was returned a moment ago and has not been freed.
    let length = unsafe { (*buffer).len };
    assert!(length > 0, "a Git answer is never an empty buffer");

    // SAFETY: freed exactly once. `ka_reader_free` takes a read_git buffer as it takes any other, and
    // a second free would be the caller's error, so the case frees and stops.
    unsafe { ka_reader_free(buffer) };
}
