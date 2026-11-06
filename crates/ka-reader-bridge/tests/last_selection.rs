//! Layer 2: two quick selections across the bridge's session, in both orders their reads can finish
//! in. A click crosses as two acts: the selection act (`select_file` act `2`), then the open. The
//! model holds the last selection whatever order the opens' reads return in (CP-1039 to CP-1050).
//!
//! The order is forced by channels and joins, never by sleeps: each held read blocks on a channel
//! inside the read closure of `Session::select_file_with`, its `started` signal says the read is
//! out, and the test joins each open's thread before it releases the next one.
//!
//! Run them with `cargo test --locked -p ka-reader-bridge --test last_selection`.

#[allow(
    dead_code,
    reason = "each test crate uses a subset of the shared helpers"
)]
mod common;

use std::ffi::CString;
use std::fs;
use std::path::{Path, PathBuf};
use std::ptr;
use std::sync::mpsc;
use std::sync::{Arc, Mutex};
use std::thread::{self, JoinHandle};

use common::TempDir;
use ka_reader_bridge::boundary;
use ka_reader_bridge::session::{
    FileAct, FileAnswerDto, ListAnswerDto, OpenResult, Session, TreeAct, Wiring,
};
use ka_reader_bridge::watcher::fakes::ManualWatching;
use ka_reader_core::{FileView, ItemState, ReadingPosition, read_file};
use serde_json::{Value, json};

/// The selection act of `select_file`'s `act` argument.
const SELECTION_ACT: u32 = 2;
const TOP: &[u8] = b"top";

fn position(bytes: &[u8]) -> ReadingPosition {
    ReadingPosition::new(bytes)
}

/// A session over the hand-driven watcher, with no Git double (QC-50).
fn session_over(watching: &Arc<ManualWatching>) -> Arc<Session> {
    Arc::new(Session::with_parts(
        Box::new(|| Wiring::SwitchFailed),
        watching.clone(),
    ))
}

/// A folder holding `a.txt`, `b.txt` and `c.txt`, each with text of its own.
fn folder_of_three_files() -> TempDir {
    let folder = TempDir::new();
    for name in ["a", "b", "c"] {
        folder.write_file(&format!("{name}.txt"), &format!("{name} text\n"));
    }
    folder
}

fn root_of(folder: &TempDir) -> PathBuf {
    folder.path().canonicalize().expect("a canonical folder")
}

/// The selection act for `path`, through the public boundary the shell crosses.
fn select_act(session: &Session, path: &str) -> FileAnswerDto {
    let path = CString::new(path).expect("a path holds no NUL");
    // SAFETY: `path` is a NUL-terminated string that lives for the call, and NULL is the position
    // the boundary accepts and never reads for this act.
    unsafe { boundary::select_entry(session, path.as_ptr(), SELECTION_ACT, ptr::null()) }
}

/// An open act whose read is held out on a thread of its own until the test releases it.
struct HeldOpen {
    release: mpsc::Sender<()>,
    finished: JoinHandle<FileAnswerDto>,
}

impl HeldOpen {
    /// Lets the read go and returns once the open act has folded and answered.
    fn release(self) -> FileAnswerDto {
        self.release.send(()).expect("the read is waiting");
        self.finished.join().expect("the open act finished")
    }
}

/// The open act for `path` at `at`, returning once its read is out and held.
fn issue_held_open(session: &Arc<Session>, path: &str, at: &[u8]) -> HeldOpen {
    let (started, read_is_out) = mpsc::channel();
    let (release, released) = mpsc::channel::<()>();
    let session = Arc::clone(session);
    let path = path.to_owned();
    let at = at.to_vec();
    let finished = thread::spawn(move || {
        session.select_file_with(
            &path,
            Some(FileAct::Open(ReadingPosition::new(at))),
            move |opened, path| {
                started.send(()).expect("the test is listening");
                released.recv().expect("the test releases the read");
                read_file(opened, path)
            },
        )
    });
    read_is_out.recv().expect("the open's read started");
    HeldOpen { release, finished }
}

/// One click: the selection act, then the open with its read held out.
fn click_held(session: &Arc<Session>, path: &str, at: &[u8]) -> HeldOpen {
    select_act(session, path);
    issue_held_open(session, path, at)
}

fn wire(answer: FileAnswerDto) -> Value {
    serde_json::to_value(answer).expect("the answer serializes")
}

fn text(content: &str) -> Value {
    json!({ "state": "text", "content": content, "language": "plain" })
}

fn held_selected(session: &Session) -> Option<PathBuf> {
    session.held_place()?.selected().map(Path::to_path_buf)
}

fn held_open_path(session: &Session) -> Option<PathBuf> {
    let place = session.held_place()?;
    Some(place.open_file()?.path().to_path_buf())
}

fn held_position(session: &Session) -> Option<ReadingPosition> {
    let place = session.held_place()?;
    Some(place.open_file()?.position().clone())
}

fn held_view(session: &Session) -> Option<ItemState<FileView>> {
    let place = session.held_place()?;
    Some(place.open_file()?.view().clone())
}

fn held_text(session: &Session) -> Option<String> {
    match held_view(session)? {
        ItemState::Observed(FileView::Text { content, .. }) => Some(content),
        _ => None,
    }
}

/// Asserts the held model's selection and open file are `name`, showing `content`.
fn assert_holds_text(session: &Session, name: &str, content: &str, case: &str) {
    assert_eq!(
        held_selected(session).as_deref(),
        Some(Path::new(name)),
        "{case}: selected"
    );
    assert_eq!(
        held_open_path(session).as_deref(),
        Some(Path::new(name)),
        "{case}: open file"
    );
    assert_eq!(held_text(session).as_deref(), Some(content), "{case}: view");
}

/// Opens `folder` with a delivery that records every payload it receives.
fn open_delivering(session: &Session, folder: &TempDir) -> Arc<Mutex<Vec<Vec<u8>>>> {
    let received = Arc::new(Mutex::new(Vec::new()));
    let sink = Arc::clone(&received);
    let result = session.open_delivering(
        folder.path().to_path_buf(),
        Arc::new(move |payload| sink.lock().expect("the payload log").push(payload)),
    );
    assert!(matches!(result, OpenResult::Opened), "the folder must open");
    received
}

/// The `open_file` members the payloads carry, in order.
fn open_files(received: &Arc<Mutex<Vec<Vec<u8>>>>) -> Vec<Value> {
    received
        .lock()
        .expect("the payload log")
        .iter()
        .map(|bytes| serde_json::from_slice::<Value>(bytes).expect("a payload is JSON"))
        .filter_map(|payload| payload.get("open_file").cloned())
        .collect()
}

/// A change on disk reported to the session's watcher.
fn push_batch(watching: &ManualWatching, folder: &TempDir, relative: &str) {
    watching
        .subscription_for(&root_of(folder))
        .expect("a subscription on the folder")
        .push(vec![root_of(folder).join(relative)]);
}

/// The earlier click's read finishes last: `a` then `b`, `b` released first, then `a`.
fn after_the_earlier_last_pair(session: &Arc<Session>) {
    let first = click_held(session, "a.txt", TOP);
    let second = click_held(session, "b.txt", TOP);
    second.release();
    first.release();
}

#[test]
fn test_two_quick_selections_end_on_the_second_in_both_completion_orders() {
    for earlier_first in [true, false] {
        let case = if earlier_first {
            "earlier released first"
        } else {
            "earlier released last"
        };
        let folder = folder_of_three_files();
        let watching = Arc::new(ManualWatching::new());
        let session = session_over(&watching);
        session.open(folder.path().to_path_buf());
        let first = click_held(&session, "a.txt", TOP);
        let second = click_held(&session, "b.txt", TOP);

        if earlier_first {
            first.release();
            second.release();
        } else {
            second.release();
            first.release();
        }

        assert_holds_text(&session, "b.txt", "b text\n", case);
    }
}

#[test]
fn test_three_quick_selections_released_c_a_b_end_on_c() {
    let folder = folder_of_three_files();
    let watching = Arc::new(ManualWatching::new());
    let session = session_over(&watching);
    session.open(folder.path().to_path_buf());
    let a = click_held(&session, "a.txt", TOP);
    let b = click_held(&session, "b.txt", TOP);
    let c = click_held(&session, "c.txt", TOP);

    c.release();
    a.release();
    b.release();

    assert_holds_text(&session, "c.txt", "c text\n", "released c, a, b");
}

#[test]
fn test_a_b_a_with_the_second_a_released_first_holds_a_at_its_last_position() {
    let folder = folder_of_three_files();
    let watching = Arc::new(ManualWatching::new());
    let session = session_over(&watching);
    session.open(folder.path().to_path_buf());
    let first_a = click_held(&session, "a.txt", b"line=1");
    let b = click_held(&session, "b.txt", TOP);
    let second_a = click_held(&session, "a.txt", b"line=7");

    second_a.release();

    assert_holds_text(&session, "a.txt", "a text\n", "the second a released first");
    assert_eq!(held_position(&session), Some(position(b"line=7")));
    session.select_file("a.txt", Some(FileAct::Position(position(b"line=9"))));
    first_a.release();
    b.release();
    assert_holds_text(&session, "a.txt", "a text\n", "after the late releases");
    assert_eq!(
        held_position(&session),
        Some(position(b"line=9")),
        "the first a's late release leaves the reader's position alone"
    );
}

#[test]
fn test_a_file_that_cannot_be_displayed_is_held_when_the_earlier_read_finishes_last() {
    let folder = folder_of_three_files();
    fs::write(folder.path().join("photo.png"), [0xFF, 0xD8, 0xFF, 0xE0]).expect("written");
    let watching = Arc::new(ManualWatching::new());
    let session = session_over(&watching);
    session.open(folder.path().to_path_buf());
    let a = click_held(&session, "a.txt", TOP);
    let photo = click_held(&session, "photo.png", TOP);

    let photo_answer = photo.release();
    let a_answer = a.release();

    assert_eq!(
        wire(photo_answer),
        json!({ "state": "cannot_display", "reason": "invalid_utf8" })
    );
    assert_eq!(wire(a_answer), text("a text\n"));
    assert_eq!(
        held_selected(&session).as_deref(),
        Some(Path::new("photo.png"))
    );
    assert_eq!(
        held_open_path(&session).as_deref(),
        Some(Path::new("photo.png"))
    );
    assert!(
        matches!(
            held_view(&session),
            Some(ItemState::Observed(FileView::CannotDisplay(_)))
        ),
        "the held view is the file that cannot be displayed"
    );
}

#[test]
fn test_after_the_earlier_last_pair_the_open_file_follows_the_disk() {
    let folder = folder_of_three_files();
    let watching = Arc::new(ManualWatching::new());
    let session = session_over(&watching);
    let received = open_delivering(&session, &folder);
    after_the_earlier_last_pair(&session);

    folder.write_file("b.txt", "b changed\n");
    push_batch(&watching, &folder, "b.txt");
    let changed = open_files(&received);
    let member = changed.last().expect("the change delivered the open file");
    assert_eq!(member["path"], json!("b.txt"));
    assert_eq!(member["answer"], text("b changed\n"));

    let delivered = open_files(&received).len();
    folder.write_file("a.txt", "a changed\n");
    push_batch(&watching, &folder, "a.txt");
    assert_eq!(
        open_files(&received).len(),
        delivered,
        "the earlier file's change delivers no open file"
    );

    fs::remove_file(folder.path().join("b.txt")).expect("the file is removed");
    push_batch(&watching, &folder, "b.txt");
    let gone = open_files(&received);
    let member = gone.last().expect("the deletion delivered the open file");
    assert_eq!(member["path"], json!("b.txt"));
    assert_eq!(member["answer"], json!({ "state": "gone" }));

    folder.write_file("b.txt", "b again\n");
    push_batch(&watching, &folder, "b.txt");
    let back = open_files(&received);
    let member = back.last().expect("the rewrite delivered the open file");
    assert_eq!(member["path"], json!("b.txt"));
    assert_eq!(member["answer"], text("b again\n"));
}

#[test]
fn test_after_the_earlier_last_pair_the_reading_position_survives_a_change() {
    let folder = folder_of_three_files();
    let watching = Arc::new(ManualWatching::new());
    let session = session_over(&watching);
    let received = open_delivering(&session, &folder);
    after_the_earlier_last_pair(&session);

    session.select_file("b.txt", Some(FileAct::Position(position(b"line=400"))));
    folder.write_file("b.txt", "b changed\n");
    push_batch(&watching, &folder, "b.txt");

    let members = open_files(&received);
    let member = members.last().expect("the change delivered the open file");
    assert_eq!(member["position"], json!("line=400"));
    assert_eq!(held_position(&session), Some(position(b"line=400")));
}

#[test]
fn test_a_listing_and_a_second_selection_are_not_held_up_by_a_long_read() {
    let folder = folder_of_three_files();
    folder.write_file("big.log", "a long log\n");
    folder.write_file("src/lib.txt", "in src\n");
    let watching = Arc::new(ManualWatching::new());
    let session = session_over(&watching);
    session.open(folder.path().to_path_buf());
    let big = click_held(&session, "big.log", TOP);

    let listing = session.list("src", Some(TreeAct::Expand));
    let selection = select_act(&session, "b.txt");
    let second_open = session.select_file("b.txt", Some(FileAct::Open(position(TOP))));

    assert!(
        matches!(listing, ListAnswerDto::Observed { ref entries } if !entries.is_empty()),
        "src's listing came back while big.log's read was out"
    );
    assert_eq!(selection, FileAnswerDto::Pending);
    assert_eq!(wire(second_open), text("b text\n"));
    big.release();
    assert_holds_text(&session, "b.txt", "b text\n", "after big.log is released");
}

#[test]
fn test_a_read_made_for_a_folder_that_was_switched_away_folds_nothing() {
    let folder = folder_of_three_files();
    let other = TempDir::new();
    other.write_file("elsewhere.txt", "elsewhere\n");
    let watching = Arc::new(ManualWatching::new());
    let session = session_over(&watching);
    session.open(folder.path().to_path_buf());
    let held = click_held(&session, "a.txt", TOP);

    session.open(other.path().to_path_buf());
    held.release();

    let place = session.held_place().expect("the other folder is open");
    assert_eq!(place.selected(), None);
    assert!(place.open_file().is_none());
}

#[test]
fn test_the_selection_act_alone_selects_reads_nothing_and_answers_pending() {
    let folder = folder_of_three_files();
    let watching = Arc::new(ManualWatching::new());
    let session = session_over(&watching);
    let nothing_open = select_act(&session, "a.txt");
    assert_eq!(nothing_open, FileAnswerDto::Pending);
    assert!(session.held_place().is_none(), "no folder is held");
    let received = open_delivering(&session, &folder);
    let delivered = received.lock().expect("the payload log").len();

    let answer = select_act(&session, "a.txt");

    assert_eq!(answer, FileAnswerDto::Pending);
    assert_eq!(held_selected(&session).as_deref(), Some(Path::new("a.txt")));
    assert!(
        held_open_path(&session).is_none(),
        "the selection act reads no content"
    );
    assert_eq!(
        received.lock().expect("the payload log").len(),
        delivered,
        "the selection act delivers no payload"
    );
    // SAFETY: NULL is a path the boundary refuses, and NULL is a position it never reads.
    let null_path =
        unsafe { boundary::select_entry(&session, ptr::null(), SELECTION_ACT, ptr::null()) };
    assert_eq!(null_path, FileAnswerDto::Pending);
    assert_eq!(select_act(&session, ""), FileAnswerDto::Pending);
    assert_eq!(held_selected(&session).as_deref(), Some(Path::new("a.txt")));
}
