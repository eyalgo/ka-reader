//! Layer 2: the native route (CP-1032). The production composition with the real `FsEvents` watcher,
//! driven only through the exported `ka_reader_open_folder`, `ka_reader_select_file` and
//! `ka_reader_free`: the open file follows a rewrite, a deletion and a recreation, and the folder
//! the scene ends in is `checks/fixtures/open-file-scene`, which the gate's read-only step then
//! walks.
//!
//! The folder is built by the test under the temporary directory, with no `.git` and no Git
//! command. Run it with `cargo test --locked -p ka-reader-bridge --test open_file_scene`; the gate's
//! sanitizer step runs this file with the rest of the bridge suite, which is what catches a buffer
//! freed twice.

#[allow(
    dead_code,
    reason = "each test crate uses a subset of the shared helpers"
)]
mod common;

use std::collections::BTreeMap;
use std::ffi::{CString, c_void};
use std::os::unix::ffi::OsStrExt;
use std::path::{Path, PathBuf};
use std::sync::Mutex;
use std::time::{Duration, Instant};

use common::TempDir;
use ka_reader_bridge::exports::{
    KAReaderBuffer, ka_reader_free, ka_reader_open_folder, ka_reader_select_file,
};
use serde_json::{Value, json};

static ONE_AT_A_TIME: Mutex<()> = Mutex::new(());

/// How long the scene waits for something it expects to happen.
const EXPECTED_WITHIN: Duration = Duration::from_secs(20);
/// The quiet interval that closes a step: nothing more arrives, so the step has settled.
const QUIET_FOR: Duration = Duration::from_millis(1500);

const OPEN_FILE: &str = "notes.txt";
const OPEN_ACT: u32 = 0;
const TOP_LEFT: &str = "line=0;x=0";

/// What the scene's one callback received: every payload as the bytes it arrived in, and how many
/// buffers the callback freed.
#[derive(Default)]
struct Received {
    state: Mutex<ReceivedState>,
}

#[derive(Default)]
struct ReceivedState {
    payloads: Vec<String>,
    freed: usize,
}

impl Received {
    /// A receiver that lives for the rest of the process, because the session may call its callback
    /// until the next open has returned, and a test's stack frame is gone by then.
    fn leaked() -> &'static Received {
        Box::leak(Box::new(Received::default()))
    }

    fn lock(&self) -> std::sync::MutexGuard<'_, ReceivedState> {
        self.state.lock().unwrap_or_else(|p| p.into_inner())
    }

    fn payloads(&self) -> Vec<String> {
        self.lock().payloads.clone()
    }

    fn freed(&self) -> usize {
        self.lock().freed
    }

    /// Copies the buffer out, records it, and frees it once, as the shell does.
    fn take(&self, buffer: *mut KAReaderBuffer) {
        let bytes = take_bytes(buffer);
        let mut state = self.lock();
        state
            .payloads
            .push(String::from_utf8(bytes).expect("a payload is UTF-8"));
        state.freed += 1;
    }
}

/// Copies a buffer's bytes out and frees it once through `ka_reader_free`.
fn take_bytes(buffer: *mut KAReaderBuffer) -> Vec<u8> {
    assert!(!buffer.is_null(), "an answer, never NULL");
    // SAFETY: the bridge hands over a live buffer that nothing else frees.
    let bytes = unsafe { std::slice::from_raw_parts((*buffer).bytes, (*buffer).len) }.to_vec();
    // SAFETY: freed exactly once, here, and never read again.
    unsafe { ka_reader_free(buffer) };
    bytes
}

unsafe extern "C" fn callback(context: *mut c_void, buffer: *mut KAReaderBuffer) {
    // SAFETY: the scene passes a leaked `Received`, which is never freed.
    unsafe { &*context.cast::<Received>() }.take(buffer);
}

fn c_string(text: impl AsRef<[u8]>) -> CString {
    CString::new(text.as_ref()).expect("no interior NUL")
}

/// Opens `folder` through the export, with the scene's callback unless `received` is `None`.
fn open(folder: &Path, received: Option<&'static Received>) {
    let location = c_string(folder.as_os_str().as_bytes());
    let (callback, context) = match received {
        Some(received) => (
            Some(callback as unsafe extern "C" fn(*mut c_void, *mut KAReaderBuffer)),
            std::ptr::from_ref(received).cast_mut().cast::<c_void>(),
        ),
        None => (None, std::ptr::null_mut()),
    };
    // SAFETY: `location` is NUL-terminated and outlives the call; the context is leaked.
    let buffer = unsafe { ka_reader_open_folder(location.as_ptr(), callback, context) };
    let answer: Value =
        serde_json::from_slice(&take_bytes(buffer)).expect("the open answer is JSON");
    assert_eq!(answer, json!({ "state": "opened" }));
}

/// Selects and opens `path` at the top-left through the export, and returns its answer.
fn open_file(path: &str) -> Value {
    let (path, position) = (c_string(path), c_string(TOP_LEFT));
    // SAFETY: both strings are NUL-terminated and outlive the call.
    let buffer = unsafe { ka_reader_select_file(path.as_ptr(), OPEN_ACT, position.as_ptr()) };
    serde_json::from_slice(&take_bytes(buffer)).expect("the file answer is JSON")
}

/// Leaves the session with no subscription, so no callback outlives the scene.
struct SilenceOnDrop(TempDir);

impl Drop for SilenceOnDrop {
    fn drop(&mut self) {
        open(self.0.path(), None);
    }
}

/// The open file member of the newest payload that carries one: its `answer`, and the payload's
/// bytes as they arrived.
fn newest_open_file(received: &Received) -> Option<(Value, String)> {
    received.payloads().into_iter().rev().find_map(|raw| {
        let payload: Value = serde_json::from_str(&raw).expect("a payload is JSON");
        let member = payload.get("open_file")?;
        assert_eq!(member["path"], OPEN_FILE, "only the open file is delivered");
        Some((member["answer"].clone(), raw))
    })
}

/// Waits until the newest open file answer is `expected`, then lets the step settle, and returns the
/// payload's bytes.
fn settle_on(received: &Received, step: &str, expected: &Value) -> String {
    let deadline = Instant::now() + EXPECTED_WITHIN;
    loop {
        if let Some((answer, _)) = newest_open_file(received)
            && answer == *expected
        {
            std::thread::sleep(QUIET_FOR);
            let (settled, raw) = newest_open_file(received).expect("a payload was already seen");
            assert_eq!(settled, *expected, "{step}: the answer stays settled");
            return raw;
        }
        assert!(
            Instant::now() < deadline,
            "{step}: no open file answer equal to {expected}; got {:?}",
            newest_open_file(received).map(|(answer, _)| answer)
        );
        std::thread::sleep(Duration::from_millis(25));
    }
}

/// The answer a fresh read of `file` would give: built from the test's own `std::fs`, never from the
/// bridge or the core.
fn fresh_read(file: &Path) -> Value {
    let content = std::fs::read_to_string(file).expect("the file is readable text");
    json!({ "state": "text", "content": content, "language": "plain" })
}

/// Every file below `root` by its path relative to it, with its bytes, and every folder in the
/// same map with `None`.
fn tree_of(root: &Path) -> BTreeMap<PathBuf, Option<Vec<u8>>> {
    fn walk(root: &Path, folder: &Path, into: &mut BTreeMap<PathBuf, Option<Vec<u8>>>) {
        for entry in std::fs::read_dir(folder).expect("a readable folder") {
            let path = entry.expect("a readable entry").path();
            let relative = path
                .strip_prefix(root)
                .expect("below the root")
                .to_path_buf();
            if path.is_dir() {
                into.insert(relative, None);
                walk(root, &path, into);
            } else {
                into.insert(
                    relative,
                    Some(std::fs::read(&path).expect("a readable file")),
                );
            }
        }
    }
    let mut tree = BTreeMap::new();
    walk(root, root, &mut tree);
    tree
}

fn fixture() -> PathBuf {
    Path::new(env!("CARGO_MANIFEST_DIR")).join("../../checks/fixtures/open-file-scene")
}

#[test]
fn test_the_open_file_follows_a_rewrite_a_deletion_and_a_recreation_on_the_real_watcher_route() {
    let _one = ONE_AT_A_TIME.lock().unwrap_or_else(|p| p.into_inner());
    let _silence = SilenceOnDrop(TempDir::new());
    let folder = TempDir::new();
    let notes = folder.write_file(OPEN_FILE, "the first text\n");
    folder.write_file("readme.txt", "A sibling the scene never touches.\n");
    folder.write_file(
        "nested/inner.txt",
        "A file in a folder the scene never touches.\n",
    );
    let received = Received::leaked();
    open(folder.path(), Some(received));

    let opened = open_file(OPEN_FILE);
    assert_eq!(
        opened,
        fresh_read(&notes),
        "the open answers the file's text"
    );
    std::thread::sleep(QUIET_FOR);

    // Rewritten: the last answer equals the test's own fresh read.
    folder.write_file(OPEN_FILE, "the rewritten text\n");
    settle_on(received, "rewrite", &fresh_read(&notes));

    // Deleted: the member is the path with `gone`, and its bytes hold none of the old text.
    std::fs::remove_file(&notes).expect("the file is removed");
    let gone = settle_on(received, "deletion", &json!({ "state": "gone" }));
    assert!(
        !gone.contains("rewritten") && !gone.contains("first text"),
        "a gone payload holds none of the file's text: {gone}"
    );

    // Written again with new text: it equals the fresh read.
    folder.write_file(OPEN_FILE, "the recreated text, as the fixture holds it\n");
    settle_on(received, "recreation", &fresh_read(&notes));

    assert_eq!(
        tree_of(folder.path()),
        tree_of(&fixture()),
        "the scene's final folder is checks/fixtures/open-file-scene, byte for byte"
    );
    assert_eq!(
        received.freed(),
        received.payloads().len(),
        "each payload's buffer was freed once through ka_reader_free"
    );
}
