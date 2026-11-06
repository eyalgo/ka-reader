//! The C boundary's logic: the panic wrapper every export runs inside, and the decoding of the
//! pointers the exports take. It holds no state and touches no filesystem (QC-13); the process's
//! session lives in `exports`.

use std::ffi::{CStr, c_char, c_void};
use std::os::unix::ffi::OsStrExt;
use std::panic::{self, AssertUnwindSafe};
use std::path::PathBuf;
use std::sync::Arc;

use ka_reader_core::{ReadingPosition, TreeChanges};
use serde::Serialize;

use crate::exports::{BufferOrigin, KAReaderBuffer, KAReaderModelChanged};
use crate::session::{
    Delivery, FileAct, FileAnswerDto, ListAnswerDto, OpenResult, Session, TreeAct, list_answer,
};

/// Runs `work` under `catch_unwind` and hands its answer across as an owned buffer of JSON bytes.
///
/// NULL is the failure value: it is returned when `work` panics, and when the answer cannot be
/// serialized. A panic that unwound out of an `extern "C"` function would abort the process, so no
/// export runs its body outside this wrapper. The workspace sets no `panic = "abort"`, which would
/// leave `catch_unwind` nothing to catch.
pub(crate) fn guarded<T: Serialize>(
    origin: BufferOrigin,
    work: impl FnOnce() -> T,
) -> *mut KAReaderBuffer {
    // The session's lock recovers from poisoning, so a panic in `work` leaves nothing half-updated
    // that a later call could observe.
    match panic::catch_unwind(AssertUnwindSafe(work)) {
        Ok(answer) => serde_json::to_vec(&answer).map_or_else(
            |_| stopped_open(origin, "answer serialization failed"),
            |payload| KAReaderBuffer::allocate(payload, origin),
        ),
        Err(_) => stopped_open(origin, "boundary panicked"),
    }
}

fn stopped_open(origin: BufferOrigin, detail: &str) -> *mut KAReaderBuffer {
    match origin {
        BufferOrigin::OpenFolder => log::warn!("core-bridge: open_folder stopped: {detail}"),
        BufferOrigin::ReadGit => log::warn!("core-bridge: read_git stopped: {detail}"),
        BufferOrigin::ListTree | BufferOrigin::SelectFile | BufferOrigin::ModelChanged => {}
    }
    std::ptr::null_mut()
}

pub(crate) fn is_valid_open_answer(bytes: *mut u8, len: usize) -> bool {
    // SAFETY: caller supplies a live buffer allocated by this crate before it is freed.
    let Ok(value) = serde_json::from_slice::<serde_json::Value>(unsafe {
        std::slice::from_raw_parts(bytes, len)
    }) else {
        return false;
    };
    match value.get("state").and_then(serde_json::Value::as_str) {
        Some("opened") => value.as_object().is_some_and(|object| object.len() == 1),
        Some("failed") => {
            value.as_object().is_some_and(|object| object.len() == 2)
                && matches!(
                    value.get("condition").and_then(serde_json::Value::as_str),
                    Some("missing" | "not_a_folder" | "unreadable")
                )
        }
        _ => false,
    }
}

#[derive(Serialize)]
struct ChangedListing {
    path: String,
    answer: ListAnswerDto,
}

#[derive(Serialize)]
struct ChangesPayload {
    listings: Vec<ChangedListing>,
}

/// The `model_changed` payload for `changes`: `{"listings":[{"path":…,"answer":…}…]}`, where each
/// `answer` is exactly what `ka_reader_list_tree` answers for that listing and the root's `path`
/// is empty.
pub(crate) fn changes_payload(changes: &TreeChanges) -> Result<Vec<u8>, serde_json::Error> {
    let listings = changes
        .listings()
        .iter()
        .map(|(path, listing)| ChangedListing {
            path: path.to_string_lossy().into_owned(),
            answer: list_answer(listing.clone()),
        })
        .collect();
    serde_json::to_vec(&ChangesPayload { listings })
}

/// A `list_tree` path, decoded. Root is NULL or empty.
#[derive(Debug, Clone, PartialEq, Eq)]
pub enum ListPath {
    Root,
    Under(String),
    /// Bytes that are not UTF-8. `ka_reader_core::list_tree` takes `&str`, so this answers
    /// `{"state":"pending"}`: nothing was read.
    NotUtf8,
}

/// Decodes the location the Open panel returned. NULL is rejected and never an empty path. The
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

/// The shell's callback context, carried to the thread the watcher owns.
struct ShellContext(*mut c_void);

// SAFETY: the pointer is only handed back to the shell's own callback, never dereferenced here. The
// shell guarantees it stays valid until the next successful open has returned (SM-4's lifetime
// contract), and the session never calls the delivery after that.
unsafe impl Send for ShellContext {}
// SAFETY: as for `Send`; the bridge reads the pointer and never writes through it.
unsafe impl Sync for ShellContext {}

impl ShellContext {
    /// A method, so a closure captures the whole wrapper (and its `Send`) rather than the bare field.
    fn get(&self) -> *mut c_void {
        self.0
    }
}

/// The delivery that hands each payload to the shell's callback as one owned buffer.
fn shell_delivery(
    callback: unsafe extern "C" fn(*mut c_void, *mut KAReaderBuffer),
    context: *mut c_void,
) -> Delivery {
    let context = ShellContext(context);
    Arc::new(move |payload: Vec<u8>| {
        let buffer = KAReaderBuffer::allocate(payload, BufferOrigin::ModelChanged);
        // SAFETY: the shell's contract keeps the context valid for this call, and the buffer is
        // live and freed by the shell exactly once.
        unsafe { callback(context.get(), buffer) };
    })
}

/// Opens the panel's answer in `session`. A non-NULL `model_changed` also starts watching the
/// folder, delivering each payload with `context`; a NULL one opens with no delivery.
///
/// # Safety
///
/// As `decode_location`. `context` stays valid as `ka_reader_open_folder` documents.
pub unsafe fn open_location(
    session: &Session,
    location: *const c_char,
    model_changed: KAReaderModelChanged,
    context: *mut c_void,
) -> Option<OpenResult> {
    // SAFETY: forwarded from the caller.
    unsafe { decode_location(location) }.map(|chosen| match model_changed {
        Some(callback) => session.open_delivering(chosen, shell_delivery(callback, context)),
        None => session.open(chosen),
    })
}

/// What the reader did to a folder, decoded from the C `act`: `0` expanded, `1` collapsed, any other
/// value none. Never a `#[repr]` enum read straight from C.
pub(crate) fn decode_act(act: u32) -> Option<TreeAct> {
    match act {
        0 => Some(TreeAct::Expand),
        1 => Some(TreeAct::Collapse),
        _ => None,
    }
}

/// Lists `path` in `session` for `act`. A path that is not UTF-8 answers `{"state":"pending"}`,
/// because nothing was read.
///
/// # Safety
///
/// As `decode_list_path`.
pub unsafe fn list_entries(session: &Session, path: *const c_char, act: u32) -> ListAnswerDto {
    let act = decode_act(act);
    // SAFETY: forwarded from the caller.
    match unsafe { decode_list_path(path) } {
        ListPath::Root => session.list("", act),
        ListPath::Under(relative) => session.list(&relative, act),
        ListPath::NotUtf8 => ListAnswerDto::Pending,
    }
}

/// What the reader did to a file, decoded from the C `act` and `position`: `0` opened it at
/// `position`, with NULL meaning the empty position; `1` moved its position to `position`, and
/// without one there is nothing to apply; any other value is none. Never a `#[repr]` enum read
/// straight from C, and the position's bytes are carried as they are, never parsed.
///
/// # Safety
///
/// `position` is NULL, or points at a NUL-terminated string that stays valid for the call.
pub(crate) unsafe fn decode_file_act(act: u32, position: *const c_char) -> Option<FileAct> {
    let bytes = if position.is_null() {
        None
    } else {
        // SAFETY: the caller guarantees a valid NUL-terminated string.
        Some(ReadingPosition::new(
            unsafe { CStr::from_ptr(position) }.to_bytes(),
        ))
    };
    match act {
        0 => Some(FileAct::Open(
            bytes.unwrap_or_else(|| ReadingPosition::new(Vec::new())),
        )),
        1 => bytes.map(FileAct::Position),
        _ => None,
    }
}

/// Applies `act` to the file at `path` in `session`. NULL, an empty path and bytes that are not
/// UTF-8 name no file, so nothing is read and the answer is `{"state":"pending"}`.
///
/// # Safety
///
/// As `decode_list_path`, and `position` as `decode_file_act`.
pub unsafe fn select_entry(
    session: &Session,
    path: *const c_char,
    act: u32,
    position: *const c_char,
) -> FileAnswerDto {
    // SAFETY: forwarded from the caller.
    let act = unsafe { decode_file_act(act, position) };
    // SAFETY: forwarded from the caller.
    match unsafe { decode_list_path(path) } {
        ListPath::Under(relative) => session.select_file(&relative, act),
        ListPath::Root | ListPath::NotUtf8 => FileAnswerDto::Pending,
    }
}

#[cfg(test)]
mod tests {
    //! Layer 1: the C boundary's own logic, without calling an export: the exports touch the
    //! process-global session, so these tests drive the wrapper and the decoders they are made of.

    use std::ffi::{CString, c_char};
    use std::ptr;

    use super::{
        ListPath, decode_list_path, decode_location, guarded, is_valid_open_answer, list_entries,
        open_location, select_entry,
    };
    use crate::exports::{BufferOrigin, KAReaderBuffer, install_silent_panic_hook, ka_reader_free};
    use crate::session::Session;
    use crate::test_support::{TempDir, begin_log_capture, capture_stderr, take_log_records};

    fn bytes_of(buffer: *mut KAReaderBuffer) -> Vec<u8> {
        assert!(!buffer.is_null(), "a buffer was expected");
        // SAFETY: the pointer came from `guarded` a moment ago and has not been freed.
        unsafe { std::slice::from_raw_parts((*buffer).bytes, (*buffer).len).to_vec() }
    }

    #[test]
    fn test_null_empty_and_non_utf8_paths_read_nothing_and_answer_pending() {
        let folder = TempDir::new();
        folder.write_file("a.txt", "text");
        let session = Session::default();
        session.open(folder.path().to_path_buf());
        let empty = CString::new("").expect("no NUL");
        let non_utf8 = CString::new(vec![0x61, 0xFF, 0x62]).expect("no NUL");

        // SAFETY: each pointer is NULL or a live NUL-terminated string for the call.
        let answers = unsafe {
            [
                select_entry(&session, ptr::null(), 0, ptr::null()),
                select_entry(&session, empty.as_ptr(), 0, ptr::null()),
                select_entry(&session, non_utf8.as_ptr(), 0, ptr::null()),
            ]
        };

        for answer in answers {
            assert_eq!(
                serde_json::to_value(answer).expect("serializes"),
                serde_json::json!({ "state": "pending" })
            );
        }
    }

    #[test]
    fn test_open_answer_matrix_accepts_only_opened_and_three_known_failures() {
        let accepted = [
            br#"{"state":"opened"}"#.as_slice(),
            br#"{"state":"failed","condition":"missing"}"#.as_slice(),
            br#"{"state":"failed","condition":"not_a_folder"}"#.as_slice(),
            br#"{"state":"failed","condition":"unreadable"}"#.as_slice(),
        ];
        let rejected = [
            br#"{"state":"opened","extra":true}"#.as_slice(),
            br#"{"state":"failed"}"#.as_slice(),
            br#"{"state":"failed","condition":7}"#.as_slice(),
            br#"{"state":"failed","condition":"unknown"}"#.as_slice(),
            br#"{"state":"failed","condition":"missing","extra":true}"#.as_slice(),
            br#"{"state":"pending"}"#.as_slice(),
            b"malformed".as_slice(),
            b"".as_slice(),
        ];

        for answer in accepted {
            let mut answer = answer.to_vec();
            assert!(
                is_valid_open_answer(answer.as_mut_ptr(), answer.len()),
                "{answer:?}"
            );
        }
        for answer in rejected {
            let mut answer = answer.to_vec();
            assert!(
                !is_valid_open_answer(answer.as_mut_ptr(), answer.len()),
                "{answer:?}"
            );
        }
    }

    #[test]
    fn test_open_answer_accepts_semantic_json_encodings() {
        // Mirrored byte-for-byte by BridgePayloadTests.testOpenAnswerAcceptsSemanticJSONEncodings.
        let accepted = [
            br#" { "state" : "opened" } "#.as_slice(),
            b"\n{\t\"state\":\t\"opened\"\r\n}\n".as_slice(),
            br#"{"condition":"missing","state":"failed"}"#.as_slice(),
            br#"{"condition":"not_a_folder","state":"failed"}"#.as_slice(),
            br#"{ "condition" : "unreadable" , "state" : "failed" }"#.as_slice(),
        ];

        for answer in accepted {
            let mut answer = answer.to_vec();
            assert!(
                is_valid_open_answer(answer.as_mut_ptr(), answer.len()),
                "{answer:?}"
            );
        }
    }

    #[test]
    fn test_open_answer_rejects_non_objects_and_invalid_field_shapes() {
        // Mirrored byte-for-byte by BridgePayloadTests.testOpenAnswerRejectsEveryNamedComplementShape.
        let rejected = [
            br#"[]"#.as_slice(),
            br#"["opened"]"#.as_slice(),
            br#""opened""#.as_slice(),
            br#"null"#.as_slice(),
            br#"{}"#.as_slice(),
            br#"{"condition":"missing"}"#.as_slice(),
            br#"{"state":7}"#.as_slice(),
            br#"{"state":null}"#.as_slice(),
            br#"{"state":"unknown"}"#.as_slice(),
            br#"{"state":"opened","condition":"missing"}"#.as_slice(),
            br#"{"state":"failed"}"#.as_slice(),
            br#"{"state":"failed","reason":"missing"}"#.as_slice(),
            br#"{"state":"failed","condition":7}"#.as_slice(),
            br#"{"state":"failed","condition":null}"#.as_slice(),
            br#"{"state":"failed","condition":"unknown"}"#.as_slice(),
        ];

        for answer in rejected {
            let mut answer = answer.to_vec();
            assert!(
                !is_valid_open_answer(answer.as_mut_ptr(), answer.len()),
                "{answer:?}"
            );
        }
    }

    #[test]
    fn test_boundary_no_answer_returns_null_and_writes_one_stopped_line() {
        let _serial = begin_log_capture();

        let buffer = guarded(BufferOrigin::OpenFolder, || -> Vec<String> {
            panic!("a panic the boundary must catch")
        });
        let records = take_log_records();

        assert!(buffer.is_null(), "an unwind is NULL and never a buffer");
        assert_eq!(records.len(), 1, "{records:?}");
        assert!(records[0].contains("core-bridge"), "{records:?}");
        assert!(records[0].contains("open_folder"), "{records:?}");
        assert!(!records[0].ends_with(": "), "{records:?}");
    }

    #[test]
    fn test_a_panic_under_the_read_git_origin_returns_null_and_writes_one_read_git_stopped_line() {
        let _serial = begin_log_capture();

        let buffer = guarded(BufferOrigin::ReadGit, || -> Vec<String> {
            panic!("a panic the boundary must catch")
        });
        let records = take_log_records();

        assert!(buffer.is_null(), "an unwind is NULL and never a buffer");
        assert_eq!(records.len(), 1, "{records:?}");
        assert!(
            records[0].starts_with("core-bridge: read_git stopped"),
            "{records:?}"
        );
        assert!(!records[0].ends_with(": "), "{records:?}");
    }

    #[test]
    fn test_caught_open_boundary_failures_are_terminal_silent() {
        let _serial = begin_log_capture();
        let previous_hook = std::panic::take_hook();
        install_silent_panic_hook();

        let (buffer, stderr) = capture_stderr(|| {
            guarded(BufferOrigin::OpenFolder, || -> Vec<String> {
                panic!("caught boundary panic")
            })
        });
        std::panic::set_hook(previous_hook);
        let records = take_log_records();

        assert!(buffer.is_null());
        assert_eq!(stderr, "");
        assert_eq!(records.len(), 1, "{records:?}");
    }

    #[test]
    fn test_normal_closure_yields_its_json_bytes() {
        let buffer = guarded(BufferOrigin::ListTree, || vec!["a", "b"]);

        let bytes = bytes_of(buffer);
        // SAFETY: made by `guarded`, freed exactly once, never read again.
        let length = unsafe { (*buffer).len };
        unsafe { ka_reader_free(buffer) };

        assert_eq!(bytes, br#"["a","b"]"#);
        assert_eq!(length, bytes.len());
    }

    #[test]
    fn test_free_null_is_a_no_op() {
        // SAFETY: NULL is the one pointer `ka_reader_free` is documented to accept and ignore.
        unsafe { ka_reader_free(ptr::null_mut()) };
    }

    #[test]
    fn test_buffer_made_and_freed_once_is_clean() {
        let buffer = guarded(BufferOrigin::ListTree, || 42_u32);
        assert!(!buffer.is_null());

        // SAFETY: made by `guarded` and freed exactly once.
        unsafe { ka_reader_free(buffer) };
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
        assert!(matches!(
            session.open(folder.path().to_path_buf()),
            crate::session::OpenResult::Opened
        ));
        let path = CString::new(&b"docs/\xff"[..]).expect("no interior NUL");

        // SAFETY: `path` is NUL-terminated and outlives both calls.
        let (decoded, answer) = unsafe {
            (
                decode_list_path(path.as_ptr()),
                list_entries(&session, path.as_ptr(), 0),
            )
        };

        assert_eq!(decoded, ListPath::NotUtf8);
        assert_eq!(
            serde_json::to_value(answer).expect("the answer serializes"),
            serde_json::json!({ "state": "pending" }),
            "nothing was read, and never a lossy guess"
        );
        // SAFETY: NULL is the root, and the folder holds one entry.
        let root = unsafe { list_entries(&session, ptr::null::<c_char>(), 0) };
        let root = serde_json::to_value(root).expect("the answer serializes");
        assert_eq!(
            root["state"], "observed",
            "the same session does list its root"
        );
        assert_eq!(root["entries"].as_array().expect("entries").len(), 1);
    }

    #[test]
    fn test_null_open_location_is_rejected_before_core() {
        let session = Session::default();

        // SAFETY: NULL is the documented cancel.
        let result = unsafe { open_location(&session, ptr::null(), None, ptr::null_mut()) };

        assert_eq!(result, None);
    }

    #[test]
    fn test_the_payload_json_is_exactly_listings_with_list_answer_members() {
        use ka_reader_core::{FolderModel, TreeRequest, open_folder};
        use serde_json::json;

        use super::changes_payload;
        use crate::session::TreeAct;
        use crate::test_support::TempDir;

        let folder = TempDir::new();
        folder.write_file("a.txt", "");
        folder.make_folder("src");
        let elsewhere = TempDir::new();
        let earlier = FolderModel::new(open_folder(elsewhere.path()).expect("opens"));
        let later = FolderModel::new(open_folder(folder.path()).expect("opens"))
            .list_tree(TreeRequest::Expand("src".into()));
        let session = Session::default();
        session.open(folder.path().to_path_buf());
        let answer = |path: &str| {
            serde_json::to_value(session.list(path, Some(TreeAct::Expand)))
                .expect("the answer serializes")
        };

        let payload = changes_payload(&later.changes_since(&earlier)).expect("serializes");

        assert_eq!(
            serde_json::from_slice::<serde_json::Value>(&payload).expect("JSON"),
            json!({ "listings": [
                { "path": "", "answer": answer("") },
                { "path": "src", "answer": answer("src") },
            ] })
        );
    }
    /// A composition root whose Git port answers a plain folder, so an open writes no log line the
    /// capture tests could see.
    fn quiet_wiring() -> Box<dyn Fn() -> crate::session::Wiring + Send + Sync> {
        use std::path::Path;
        use std::sync::Arc;

        use ka_reader_core::{GitPort, GitReadCondition, HeadState, RootFinding, StatusLists};

        struct PlainFolder;

        impl GitPort for PlainFolder {
            fn probe(&self, _folder: &Path) -> RootFinding {
                RootFinding::Plain
            }

            fn state(&self, _root: &Path) -> Result<HeadState, GitReadCondition> {
                Err(GitReadCondition::NotARoot)
            }

            fn status(&self, _root: &Path) -> Result<StatusLists, GitReadCondition> {
                Err(GitReadCondition::NotARoot)
            }
        }

        let port: Arc<dyn GitPort + Send + Sync> = Arc::new(PlainFolder);
        Box::new(move || crate::session::Wiring::Wired(Arc::clone(&port)))
    }

    /// What the test callback received: the payload bytes, copied out before the buffer is freed.
    #[derive(Default)]
    struct Received {
        payloads: std::sync::Mutex<Vec<Vec<u8>>>,
    }

    /// A callback as the shell writes one: it reads the buffer, then frees it once through
    /// `ka_reader_free`.
    unsafe extern "C" fn record_and_free(
        context: *mut std::ffi::c_void,
        buffer: *mut KAReaderBuffer,
    ) {
        // SAFETY: the tests pass a live `Received` as the context, and it outlives the session.
        let received = unsafe { &*context.cast::<Received>() };
        // SAFETY: the bridge hands over a live buffer that nothing else frees.
        let bytes = unsafe { std::slice::from_raw_parts((*buffer).bytes, (*buffer).len).to_vec() };
        received
            .payloads
            .lock()
            .unwrap_or_else(|poisoned| poisoned.into_inner())
            .push(bytes);
        // SAFETY: freed exactly once, here, and never read again.
        unsafe { ka_reader_free(buffer) };
    }

    #[test]
    fn test_act_0_1_and_2_decode_as_expand_collapse_and_none() {
        use super::decode_act;
        use crate::session::TreeAct;

        assert_eq!(decode_act(0), Some(TreeAct::Expand));
        assert_eq!(decode_act(1), Some(TreeAct::Collapse));
        assert_eq!(decode_act(2), None);
        assert_eq!(decode_act(u32::MAX), None);
    }

    #[test]
    fn test_act_0_with_a_position_decodes_to_open_with_those_bytes_and_with_null_to_the_empty_position()
     {
        use ka_reader_core::ReadingPosition;

        use super::decode_file_act;
        use crate::session::FileAct;

        let position = CString::new("line=4;x=1.5").expect("no NUL");

        // SAFETY: each pointer is NULL or a live NUL-terminated string for the call.
        let (with, without) = unsafe {
            (
                decode_file_act(0, position.as_ptr()),
                decode_file_act(0, ptr::null()),
            )
        };

        assert_eq!(
            with,
            Some(FileAct::Open(ReadingPosition::new(
                b"line=4;x=1.5".as_slice()
            )))
        );
        assert_eq!(
            without,
            Some(FileAct::Open(ReadingPosition::new(Vec::new())))
        );
    }

    #[test]
    fn test_act_1_decodes_to_position_and_with_null_to_no_act() {
        use ka_reader_core::ReadingPosition;

        use super::decode_file_act;
        use crate::session::FileAct;

        let position = CString::new("top").expect("no NUL");

        // SAFETY: each pointer is NULL or a live NUL-terminated string for the call.
        let (with, without) = unsafe {
            (
                decode_file_act(1, position.as_ptr()),
                decode_file_act(1, ptr::null()),
            )
        };

        assert_eq!(
            with,
            Some(FileAct::Position(ReadingPosition::new(b"top".as_slice())))
        );
        assert_eq!(without, None);
    }

    #[test]
    fn test_act_2_decodes_to_no_act() {
        use super::decode_file_act;

        let position = CString::new("top").expect("no NUL");

        // SAFETY: the pointer is a live NUL-terminated string for the call.
        let (two, many) = unsafe {
            (
                decode_file_act(2, position.as_ptr()),
                decode_file_act(u32::MAX, position.as_ptr()),
            )
        };

        assert_eq!(two, None);
        assert_eq!(many, None);
    }

    #[test]
    fn test_a_null_callback_opens_with_no_delivery() {
        use std::sync::Arc;

        use crate::session::OpenResult;
        use crate::watcher::fakes::ManualWatching;

        let folder = TempDir::new();
        let watching = Arc::new(ManualWatching::new());
        let session = Session::with_parts(quiet_wiring(), watching.clone());
        let location = CString::new(folder.path().as_os_str().as_encoded_bytes()).expect("no NUL");

        // SAFETY: `location` is NUL-terminated and outlives the call; a NULL callback is allowed.
        let result = unsafe { open_location(&session, location.as_ptr(), None, ptr::null_mut()) };

        assert_eq!(result, Some(OpenResult::Opened));
        assert!(
            watching.recorded().is_empty(),
            "no callback means no subscription"
        );
    }

    #[test]
    fn test_each_payload_a_callback_receives_is_freed_once_through_ka_reader_free() {
        use std::sync::Arc;

        use crate::watcher::fakes::ManualWatching;

        let folder = TempDir::new();
        folder.write_file("a.txt", "");
        let watching = Arc::new(ManualWatching::new());
        let session = Session::with_parts(quiet_wiring(), watching.clone());
        let received = Received::default();
        let location = CString::new(folder.path().as_os_str().as_encoded_bytes()).expect("no NUL");
        // SAFETY: `location` is NUL-terminated and outlives the call; the context outlives the session.
        unsafe {
            open_location(
                &session,
                location.as_ptr(),
                Some(record_and_free),
                std::ptr::from_ref(&received).cast_mut().cast(),
            )
        };
        let root = folder.path().canonicalize().expect("the folder resolves");
        let subscription = watching.recorded().pop().expect("a subscription started");

        folder.write_file("b.txt", "");
        subscription.push(vec![root.join("b.txt")]);
        folder.write_file("c.txt", "");
        subscription.push(vec![root.join("c.txt")]);

        let payloads = received.payloads.lock().expect("the lock");
        assert_eq!(payloads.len(), 2, "one buffer per changing batch");
        for payload in payloads.iter() {
            let json: serde_json::Value = serde_json::from_slice(payload).expect("JSON");
            assert!(json["listings"].is_array(), "{json}");
        }
        // The sanitizer step is what catches a second free of either buffer.
    }
}
