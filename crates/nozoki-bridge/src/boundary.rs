//! The C boundary's logic: the panic wrapper every export runs inside, and the decoding of the
//! pointers the exports take. It holds no state and touches no filesystem (QC-13); the process's
//! session lives in `exports`.

use std::ffi::{CStr, c_char};
use std::os::unix::ffi::OsStrExt;
use std::panic::{self, AssertUnwindSafe};
use std::path::PathBuf;

use serde::Serialize;

use crate::exports::NozokiBuffer;
use crate::session::{ListAnswerDto, OpenResult, Session};

/// Runs `work` under `catch_unwind` and hands its answer across as an owned buffer of JSON bytes.
///
/// NULL is the failure value: it is returned when `work` panics, and when the answer cannot be
/// serialized. A panic that unwound out of an `extern "C"` function would abort the process, so no
/// export runs its body outside this wrapper. The workspace sets no `panic = "abort"`, which would
/// leave `catch_unwind` nothing to catch.
pub fn guarded<T: Serialize>(work: impl FnOnce() -> T) -> *mut NozokiBuffer {
    // The session's lock recovers from poisoning, so a panic in `work` leaves nothing half-updated
    // that a later call could observe.
    match panic::catch_unwind(AssertUnwindSafe(work)) {
        Ok(answer) => {
            serde_json::to_vec(&answer).map_or(std::ptr::null_mut(), NozokiBuffer::allocate)
        }
        Err(_) => std::ptr::null_mut(),
    }
}

/// A `list_tree` path, decoded. Root is NULL or empty.
#[derive(Debug, Clone, PartialEq, Eq)]
pub enum ListPath {
    Root,
    Under(String),
    /// Bytes that are not UTF-8. `nozoki_core::list_tree` takes `&str`, so this answers
    /// `{"state":"pending"}`: nothing was read.
    NotUtf8,
}

/// Decodes the location the Open panel returned. NULL is a cancel and never an empty path. The
/// bytes are a path as the file system spells it and need not be UTF-8.
///
/// # Safety
///
/// `location` is NULL, or points at a NUL-terminated string that stays valid for the call.
pub unsafe fn decode_location(location: *const c_char) -> Option<PathBuf> {
    if location.is_null() {
        return None;
    }
    // SAFETY: the caller guarantees a valid NUL-terminated string.
    let bytes = unsafe { CStr::from_ptr(location) }.to_bytes();
    Some(PathBuf::from(std::ffi::OsStr::from_bytes(bytes)))
}

/// Decodes a `list_tree` path.
///
/// # Safety
///
/// `path` is NULL, or points at a NUL-terminated string that stays valid for the call.
pub unsafe fn decode_list_path(path: *const c_char) -> ListPath {
    if path.is_null() {
        return ListPath::Root;
    }
    // SAFETY: the caller guarantees a valid NUL-terminated string.
    let bytes = unsafe { CStr::from_ptr(path) }.to_bytes();
    match std::str::from_utf8(bytes) {
        Ok("") => ListPath::Root,
        Ok(text) => ListPath::Under(text.to_string()),
        Err(_) => ListPath::NotUtf8,
    }
}

/// Opens the panel's answer in `session`.
///
/// # Safety
///
/// As `decode_location`.
pub unsafe fn open_location(session: &Session, location: *const c_char) -> OpenResult {
    // SAFETY: forwarded from the caller.
    session.open(unsafe { decode_location(location) })
}

/// Lists `path` in `session`. A path that is not UTF-8 answers `{"state":"pending"}`, because
/// nothing was read.
///
/// # Safety
///
/// As `decode_list_path`.
pub unsafe fn list_entries(session: &Session, path: *const c_char) -> ListAnswerDto {
    // SAFETY: forwarded from the caller.
    match unsafe { decode_list_path(path) } {
        ListPath::Root => session.list(""),
        ListPath::Under(relative) => session.list(&relative),
        ListPath::NotUtf8 => ListAnswerDto::Pending,
    }
}

#[cfg(test)]
mod tests {
    //! Layer 1: the C boundary's own logic, without calling an export: the exports touch the
    //! process-global session, so these tests drive the wrapper and the decoders they are made of.

    use std::ffi::{CString, c_char};
    use std::ptr;

    use super::{
        ListPath, decode_list_path, decode_location, guarded, list_entries, open_location,
    };
    use crate::exports::{NozokiBuffer, nozoki_free};
    use crate::session::Session;
    use crate::test_support::TempDir;

    fn bytes_of(buffer: *mut NozokiBuffer) -> Vec<u8> {
        assert!(!buffer.is_null(), "a buffer was expected");
        // SAFETY: the pointer came from `guarded` a moment ago and has not been freed.
        unsafe { std::slice::from_raw_parts((*buffer).bytes, (*buffer).len).to_vec() }
    }

    #[test]
    fn test_panicking_closure_yields_null() {
        let buffer = guarded(|| -> Vec<String> { panic!("a panic the boundary must catch") });

        assert!(buffer.is_null(), "an unwind is NULL and never a buffer");
    }

    #[test]
    fn test_normal_closure_yields_its_json_bytes() {
        let buffer = guarded(|| vec!["a", "b"]);

        let bytes = bytes_of(buffer);
        // SAFETY: made by `guarded`, freed exactly once, never read again.
        let length = unsafe { (*buffer).len };
        unsafe { nozoki_free(buffer) };

        assert_eq!(bytes, br#"["a","b"]"#);
        assert_eq!(length, bytes.len());
    }

    #[test]
    fn test_free_null_is_a_no_op() {
        // SAFETY: NULL is the one pointer `nozoki_free` is documented to accept and ignore.
        unsafe { nozoki_free(ptr::null_mut()) };
    }

    #[test]
    fn test_buffer_made_and_freed_once_is_clean() {
        let buffer = guarded(|| 42_u32);
        assert!(!buffer.is_null());

        // SAFETY: made by `guarded` and freed exactly once.
        unsafe { nozoki_free(buffer) };
    }

    #[test]
    fn test_null_location_decodes_to_cancel() {
        // SAFETY: NULL is the documented cancel.
        let decoded = unsafe { decode_location(ptr::null()) };

        assert_eq!(decoded, None, "a cancel is never an empty path");
    }

    #[test]
    fn test_non_utf8_location_decodes_to_a_path() {
        use std::os::unix::ffi::OsStrExt;

        let location = CString::new(&b"/tmp/\xff"[..]).expect("no interior NUL");

        // SAFETY: `location` is NUL-terminated and outlives the call.
        let decoded = unsafe { decode_location(location.as_ptr()) };

        assert_eq!(
            decoded.expect("a path").as_os_str().as_bytes(),
            b"/tmp/\xff"
        );
    }

    #[test]
    fn test_null_and_empty_list_paths_are_the_root() {
        let empty = CString::new("").expect("no interior NUL");

        // SAFETY: NULL and a NUL-terminated empty string are both documented.
        let (from_null, from_empty) = unsafe {
            (
                decode_list_path(ptr::null()),
                decode_list_path(empty.as_ptr()),
            )
        };

        assert_eq!(from_null, ListPath::Root);
        assert_eq!(from_empty, ListPath::Root);
    }

    #[test]
    fn test_relative_list_path_is_kept() {
        let path = CString::new("docs/guides").expect("no interior NUL");

        // SAFETY: `path` is NUL-terminated and outlives the call.
        let decoded = unsafe { decode_list_path(path.as_ptr()) };

        assert_eq!(decoded, ListPath::Under("docs/guides".to_string()));
    }

    #[test]
    fn test_non_utf8_list_path_answers_pending() {
        let folder = TempDir::new();
        folder.write_file("present.txt", "");
        let session = Session::default();
        assert!(session.open(Some(folder.path().to_path_buf())).opened);
        let path = CString::new(&b"docs/\xff"[..]).expect("no interior NUL");

        // SAFETY: `path` is NUL-terminated and outlives both calls.
        let (decoded, answer) = unsafe {
            (
                decode_list_path(path.as_ptr()),
                list_entries(&session, path.as_ptr()),
            )
        };

        assert_eq!(decoded, ListPath::NotUtf8);
        assert_eq!(
            serde_json::to_value(answer).expect("the answer serializes"),
            serde_json::json!({ "state": "pending" }),
            "nothing was read, and never a lossy guess"
        );
        // SAFETY: NULL is the root, and the folder holds one entry.
        let root = unsafe { list_entries(&session, ptr::null::<c_char>()) };
        let root = serde_json::to_value(root).expect("the answer serializes");
        assert_eq!(
            root["state"], "observed",
            "the same session does list its root"
        );
        assert_eq!(root["entries"].as_array().expect("entries").len(), 1);
    }

    #[test]
    fn test_open_location_with_null_is_a_cancel() {
        let session = Session::default();

        // SAFETY: NULL is the documented cancel.
        let result = unsafe { open_location(&session, ptr::null()) };

        assert!(!result.opened);
    }
}
