//! Layer 3: `ka_reader_read_git` before any folder is open. The exported session is process-global, so
//! this file is its own test binary and nothing in it opens a folder.

use ka_reader_bridge::exports::{ka_reader_free, ka_reader_read_git};

#[test]
fn test_exported_read_git_before_any_open_answers_exactly_pending() {
    let buffer = ka_reader_read_git();
    assert!(!buffer.is_null(), "an answer, never NULL");

    // SAFETY: the buffer was returned a moment ago and has not been freed.
    let bytes = unsafe { std::slice::from_raw_parts((*buffer).bytes, (*buffer).len) }.to_vec();
    // SAFETY: freed exactly once, and never read again.
    unsafe { ka_reader_free(buffer) };

    assert_eq!(
        serde_json::from_slice::<serde_json::Value>(&bytes).expect("the answer is JSON"),
        serde_json::json!({ "state": "pending" })
    );
}
