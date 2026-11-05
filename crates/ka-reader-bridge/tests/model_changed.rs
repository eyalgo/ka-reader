//! Layer 2: the native route (QC-66). The production composition, with the real `FsEvents` watcher,
//! driven through the exported `ka_reader_open_folder`: a file made on disk reaches the shell's
//! callback as a payload of changed listings, and a second open silences the first.
//!
//! The cases share the process's one session, so they run one at a time. Run them with
//! `cargo test --locked -p ka-reader-bridge --test model_changed`; the gate's sanitizer step runs this
//! file too, which is what catches a buffer freed twice.

#[allow(
    dead_code,
    reason = "each test crate uses a subset of the shared helpers"
)]
mod common;

use std::ffi::{CString, c_void};
use std::os::unix::ffi::OsStrExt;
use std::path::Path;
use std::sync::Mutex;
use std::time::{Duration, Instant};

use common::TempDir;
use ka_reader_bridge::exports::{KAReaderBuffer, ka_reader_free, ka_reader_open_folder};
use serde_json::{Value, json};

static ONE_AT_A_TIME: Mutex<()> = Mutex::new(());

/// How long a case waits for something it expects to happen.
const EXPECTED_WITHIN: Duration = Duration::from_secs(20);
/// How long a case waits before concluding that something it expects not to happen has not happened.
const QUIET_FOR: Duration = Duration::from_millis(1500);

/// What one callback received: every payload, parsed, and how many buffers it freed.
#[derive(Default)]
struct Received {
    state: Mutex<ReceivedState>,
}

#[derive(Default)]
struct ReceivedState {
    payloads: Vec<Value>,
    freed: usize,
}

impl Received {
    /// A receiver that lives for the rest of the process, because the session may call its callback
    /// until the next open has returned, and a test's stack frame is gone by then.
    fn leaked() -> &'static Received {
        Box::leak(Box::new(Received::default()))
    }

    fn payloads(&self) -> Vec<Value> {
        self.lock().payloads.clone()
    }

    fn freed(&self) -> usize {
        self.lock().freed
    }

    fn lock(&self) -> std::sync::MutexGuard<'_, ReceivedState> {
        self.state.lock().unwrap_or_else(|p| p.into_inner())
    }

    /// Copies the buffer out, records it, and frees it once, as the shell does.
    fn take(&self, buffer: *mut KAReaderBuffer) {
        // SAFETY: the bridge hands over a live buffer that nothing else frees.
        let bytes = unsafe { std::slice::from_raw_parts((*buffer).bytes, (*buffer).len) }.to_vec();
        // SAFETY: freed exactly once, here, and never read again.
        unsafe { ka_reader_free(buffer) };
        let payload = serde_json::from_slice(&bytes).expect("a payload is JSON");
        let mut state = self.lock();
        state.payloads.push(payload);
        state.freed += 1;
    }
}

unsafe extern "C" fn first_callback(context: *mut c_void, buffer: *mut KAReaderBuffer) {
    // SAFETY: the tests pass a leaked `Received`, which is never freed.
    unsafe { &*context.cast::<Received>() }.take(buffer);
}

unsafe extern "C" fn second_callback(context: *mut c_void, buffer: *mut KAReaderBuffer) {
    // SAFETY: the tests pass a leaked `Received`, which is never freed.
    unsafe { &*context.cast::<Received>() }.take(buffer);
}

type Callback = unsafe extern "C" fn(*mut c_void, *mut KAReaderBuffer);

/// Opens `folder` through the export with `callback`, and checks the open succeeded.
fn open(folder: &Path, callback: Option<(Callback, &'static Received)>) {
    let location = CString::new(folder.as_os_str().as_bytes()).expect("no interior NUL");
    let (callback, context) = match callback {
        Some((callback, received)) => (
            Some(callback),
            std::ptr::from_ref(received).cast_mut().cast::<c_void>(),
        ),
        None => (None, std::ptr::null_mut()),
    };
    // SAFETY: `location` is NUL-terminated and outlives the call; the context is leaked.
    let buffer = unsafe { ka_reader_open_folder(location.as_ptr(), callback, context) };
    assert!(!buffer.is_null(), "an answer, never NULL");
    // SAFETY: the buffer came from the export a moment ago and has not been freed.
    let bytes = unsafe { std::slice::from_raw_parts((*buffer).bytes, (*buffer).len) }.to_vec();
    // SAFETY: freed exactly once, and never read again.
    unsafe { ka_reader_free(buffer) };
    let answer: Value = serde_json::from_slice(&bytes).expect("the open answer is JSON");
    assert_eq!(answer, json!({ "state": "opened" }));
}

/// Waits until `done` holds of what `received` has so far, or fails after `EXPECTED_WITHIN`.
fn wait_until(received: &Received, what: &str, done: impl Fn(&[Value]) -> bool) {
    let deadline = Instant::now() + EXPECTED_WITHIN;
    while Instant::now() < deadline {
        if done(&received.payloads()) {
            return;
        }
        std::thread::sleep(Duration::from_millis(25));
    }
    panic!("nothing arrived for: {what}; got {:?}", received.payloads());
}

/// Whether some payload's root listing names `name`.
fn root_lists(payloads: &[Value], name: &str) -> bool {
    payloads.iter().any(|payload| {
        payload["listings"]
            .as_array()
            .into_iter()
            .flatten()
            .filter(|listing| listing["path"] == "")
            .filter_map(|listing| listing["answer"]["entries"].as_array())
            .flatten()
            .any(|entry| entry["name"] == name)
    })
}

/// Leaves the session with no subscription, so no callback outlives its case.
struct SilenceOnDrop(TempDir);

impl Drop for SilenceOnDrop {
    fn drop(&mut self) {
        open(self.0.path(), None);
    }
}

#[test]
fn test_a_file_created_in_the_opened_folder_arrives_as_a_payload_holding_it() {
    let _one = ONE_AT_A_TIME.lock().unwrap_or_else(|p| p.into_inner());
    let _silence = SilenceOnDrop(TempDir::new());
    let folder = TempDir::new();
    folder.write_file("old.txt", "");
    let received = Received::leaked();
    open(folder.path(), Some((first_callback, received)));

    folder.write_file("created.txt", "");

    wait_until(
        received,
        "the created file in the root listing",
        |payloads| root_lists(payloads, "created.txt"),
    );
    let all = received.payloads();
    assert!(
        root_lists(&all, "old.txt"),
        "the root listing is whole: {all:?}"
    );
}

#[test]
fn test_a_second_open_with_another_callback_silences_the_first() {
    let _one = ONE_AT_A_TIME.lock().unwrap_or_else(|p| p.into_inner());
    let _silence = SilenceOnDrop(TempDir::new());
    let first_folder = TempDir::new();
    let second_folder = TempDir::new();
    let first = Received::leaked();
    let second = Received::leaked();
    open(first_folder.path(), Some((first_callback, first)));
    open(second_folder.path(), Some((second_callback, second)));
    let before = first.payloads().len();

    first_folder.write_file("after-the-second-open.txt", "");
    second_folder.write_file("seen-by-the-second.txt", "");

    wait_until(second, "the second callback's file", |payloads| {
        root_lists(payloads, "seen-by-the-second.txt")
    });
    std::thread::sleep(QUIET_FOR);
    assert_eq!(
        first.payloads().len(),
        before,
        "the first callback is never called after the second open returned"
    );
}

#[test]
fn test_every_payload_is_freed_once() {
    let _one = ONE_AT_A_TIME.lock().unwrap_or_else(|p| p.into_inner());
    let _silence = SilenceOnDrop(TempDir::new());
    let folder = TempDir::new();
    let received = Received::leaked();
    open(folder.path(), Some((first_callback, received)));

    for index in 0..3 {
        let name = format!("burst-{index}.txt");
        folder.write_file(&name, "");
        wait_until(received, &name, |payloads| root_lists(payloads, &name));
    }
    std::thread::sleep(QUIET_FOR);

    let payloads = received.payloads().len();
    assert!(payloads >= 3, "at least one payload for each burst");
    assert_eq!(
        received.freed(),
        payloads,
        "each payload's buffer was freed once through ka_reader_free; the sanitizer step catches a second free"
    );
}
