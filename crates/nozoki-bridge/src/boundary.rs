#[cfg(test)]
mod tests {
    //! Layer 1: the C boundary's own logic, without calling an export: the exports touch the
    //! process-global session, so these tests drive the wrapper and the decoders they are made of.

    use std::ffi::{CString, c_char};
    use std::ptr;

    use super::{ListPath, decode_list_path, decode_location, guarded, list_entries, open_location};
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
        let (from_null, from_empty) =
            unsafe { (decode_list_path(ptr::null()), decode_list_path(empty.as_ptr())) };

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
    fn test_non_utf8_list_path_answers_empty_array() {
        let folder = TempDir::new();
        folder.write_file("present.txt", "");
        let session = Session::default();
        assert!(session.open(Some(folder.path().to_path_buf())).opened);
        let path = CString::new(&b"docs/\xff"[..]).expect("no interior NUL");

        // SAFETY: `path` is NUL-terminated and outlives both calls.
        let (decoded, entries) = unsafe {
            (
                decode_list_path(path.as_ptr()),
                list_entries(&session, path.as_ptr()),
            )
        };

        assert_eq!(decoded, ListPath::NotUtf8);
        assert!(entries.is_empty(), "`[]`, and never a lossy guess");
        // SAFETY: NULL is the root, and the folder holds one entry.
        let root = unsafe { list_entries(&session, ptr::null::<c_char>()) };
        assert_eq!(root.len(), 1, "the same session does list its root");
    }

    #[test]
    fn test_open_location_with_null_is_a_cancel() {
        let session = Session::default();

        // SAFETY: NULL is the documented cancel.
        let result = unsafe { open_location(&session, ptr::null()) };

        assert!(!result.opened);
    }
}
