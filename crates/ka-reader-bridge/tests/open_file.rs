//! Layer 2: the file acts across the bridge's session, over temporary folders and a watcher a test
//! drives by hand. The open act selects and opens a file at a position and answers today's file
//! answer; the position act moves the open file's position and answers `pending` (CP-1022).
//!
//! Run them with `cargo test --locked -p ka-reader-bridge --test open_file`.

#[allow(
    dead_code,
    reason = "each test crate uses a subset of the shared helpers"
)]
mod common;

use std::path::{Path, PathBuf};
use std::sync::atomic::{AtomicBool, AtomicUsize, Ordering};
use std::sync::{Arc, Mutex, mpsc};
use std::time::Duration;

use common::TempDir;
use ka_reader_bridge::session::{FileAct, FileAnswerDto, OpenResult, Session, Wiring};
use ka_reader_bridge::watcher::fakes::ManualWatching;
use ka_reader_core::{FileView, ItemState, ReadingPosition, read_file};
use serde_json::{Value, json};

fn position(bytes: &[u8]) -> ReadingPosition {
    ReadingPosition::new(bytes)
}

/// A session over the hand-driven watcher, with no Git double (QC-50).
fn session_over(watching: &Arc<ManualWatching>) -> Session {
    Session::with_parts(Box::new(|| Wiring::SwitchFailed), watching.clone())
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

fn root_of(folder: &TempDir) -> PathBuf {
    folder.path().canonicalize().expect("a canonical folder")
}

fn wire(answer: FileAnswerDto) -> Value {
    serde_json::to_value(answer).expect("the answer serializes")
}

/// The text the held model shows for its open file, if it shows text.
fn held_text(session: &Session) -> Option<String> {
    let place = session.held_place()?;
    match place.open_file()?.view() {
        ItemState::Observed(FileView::Text { content, .. }) => Some(content.clone()),
        _ => None,
    }
}

#[test]
fn test_the_open_act_answers_exactly_todays_json_for_text_failed_and_pending() {
    let folder = TempDir::new();
    folder.write_file("a.txt", "hello\n");
    let watching = Arc::new(ManualWatching::new());
    let session = session_over(&watching);
    let open = || Some(FileAct::Open(position(b"top")));

    let before_any_open = wire(session.select_file("a.txt", open()));
    session.open(folder.path().to_path_buf());
    let text = wire(session.select_file("a.txt", open()));
    let failed = wire(session.select_file("missing.txt", open()));

    assert_eq!(before_any_open, json!({ "state": "pending" }));
    assert_eq!(
        text,
        json!({ "state": "text", "content": "hello\n", "language": "plain" })
    );
    assert_eq!(failed, json!({ "state": "failed", "condition": "missing" }));
}

#[test]
fn test_the_open_act_holds_the_path_selected_and_opened_at_the_position_given() {
    let folder = TempDir::new();
    folder.write_file("a.txt", "hello\n");
    let watching = Arc::new(ManualWatching::new());
    let session = session_over(&watching);
    session.open(folder.path().to_path_buf());

    session.select_file("a.txt", Some(FileAct::Open(position(b"line=7;x=2"))));

    let place = session.held_place().expect("a folder is open");
    assert_eq!(place.selected(), Some(Path::new("a.txt")));
    let open = place.open_file().expect("the file is open");
    assert_eq!(open.path(), Path::new("a.txt"));
    assert_eq!(open.position(), &position(b"line=7;x=2"));
    assert_eq!(held_text(&session).as_deref(), Some("hello\n"));
}

#[test]
fn test_the_position_act_on_the_open_file_sets_it_and_answers_pending() {
    let folder = TempDir::new();
    folder.write_file("a.txt", "hello\n");
    let watching = Arc::new(ManualWatching::new());
    let session = session_over(&watching);
    let received = open_delivering(&session, &folder);
    session.select_file("a.txt", Some(FileAct::Open(position(b"top"))));

    let answer = session.select_file("a.txt", Some(FileAct::Position(position(b"line=40;x=0"))));

    assert_eq!(wire(answer), json!({ "state": "pending" }));
    let place = session.held_place().expect("a folder is open");
    assert_eq!(
        place.open_file().expect("still open").position(),
        &position(b"line=40;x=0")
    );
    assert!(
        received.lock().expect("the payload log").is_empty(),
        "a position act delivers nothing"
    );
}

#[test]
fn test_the_position_act_on_another_path_changes_nothing() {
    let folder = TempDir::new();
    folder.write_file("a.txt", "hello\n");
    folder.write_file("b.txt", "other\n");
    let watching = Arc::new(ManualWatching::new());
    let session = session_over(&watching);
    session.open(folder.path().to_path_buf());
    session.select_file("a.txt", Some(FileAct::Open(position(b"top"))));
    let before = session.held_place();

    let answer = session.select_file("b.txt", Some(FileAct::Position(position(b"line=9"))));

    assert_eq!(wire(answer), json!({ "state": "pending" }));
    assert_eq!(session.held_place(), before);
}

#[test]
fn test_an_unknown_act_answers_pending_and_changes_nothing() {
    let folder = TempDir::new();
    folder.write_file("a.txt", "hello\n");
    let watching = Arc::new(ManualWatching::new());
    let session = session_over(&watching);
    session.open(folder.path().to_path_buf());
    session.select_file("a.txt", Some(FileAct::Open(position(b"top"))));
    let before = session.held_place();

    let answer = session.select_file("a.txt", None);

    assert_eq!(wire(answer), json!({ "state": "pending" }));
    assert_eq!(session.held_place(), before);
}

#[test]
fn test_a_batch_pushed_while_the_opens_read_is_out_leaves_the_held_open_file_with_the_rewritten_text()
 {
    let folder = TempDir::new();
    folder.write_file("a.txt", "old\n");
    let watching = Arc::new(ManualWatching::new());
    let session = session_over(&watching);
    let _received = open_delivering(&session, &folder);
    let subscription = watching
        .subscription_for(&root_of(&folder))
        .expect("a subscription on the folder");

    let answer = session.select_file_with(
        "a.txt",
        Some(FileAct::Open(position(b"top"))),
        |opened, path| {
            let read = read_file(opened, path);
            folder.write_file("a.txt", "new\n");
            subscription.push(vec![root_of(&folder).join("a.txt")]);
            read
        },
    );

    assert_eq!(
        wire(answer),
        json!({ "state": "text", "content": "old\n", "language": "plain" }),
        "the answer is what the read gave"
    );
    assert_eq!(
        held_text(&session).as_deref(),
        Some("new\n"),
        "the change that landed during the read is not lost"
    );
}

#[test]
fn test_a_selection_is_applied_to_the_held_model_on_the_path_given() {
    let folder = TempDir::new();
    folder.write_file("a.txt", "x");
    let watching = Arc::new(ManualWatching::new());
    let session = session_over(&watching);
    session.open(folder.path().to_path_buf());

    session.select_file("a.txt", Some(FileAct::Open(position(b"top"))));

    let place = session.held_place().expect("a folder is open");
    assert_eq!(place.selected(), Some(Path::new("a.txt")));
}

// ---- Delivery: the open file in the `model_changed` payload (CP-1022, CP-1023, CP-1031) ----

/// Every payload a delivery received, parsed.
fn payloads(received: &Arc<Mutex<Vec<Vec<u8>>>>) -> Vec<Value> {
    received
        .lock()
        .expect("the payload log")
        .iter()
        .map(|bytes| serde_json::from_slice(bytes).expect("a payload is JSON"))
        .collect()
}

/// The `open_file` members the payloads carry, in order.
fn open_files(received: &Arc<Mutex<Vec<Vec<u8>>>>) -> Vec<Value> {
    payloads(received)
        .into_iter()
        .filter_map(|payload| payload.get("open_file").cloned())
        .collect()
}

fn text(content: &str) -> Value {
    json!({ "state": "text", "content": content, "language": "plain" })
}

fn open_at(session: &Session, path: &str, at: &[u8]) {
    session.select_file(path, Some(FileAct::Open(position(at))));
}

#[test]
fn test_the_open_delivers_one_payload_with_the_path_the_position_and_the_answer_at_revision_1() {
    let folder = TempDir::new();
    folder.write_file("a.txt", "hello\n");
    let watching = Arc::new(ManualWatching::new());
    let session = session_over(&watching);
    let received = open_delivering(&session, &folder);

    open_at(&session, "a.txt", b"line=3;x=0");

    assert_eq!(
        payloads(&received),
        vec![json!({
            "listings": [],
            "open_file": {
                "revision": 1,
                "path": "a.txt",
                "position": "line=3;x=0",
                "answer": text("hello\n"),
            },
        })]
    );
}

#[test]
fn test_the_position_act_then_a_pushed_batch_delivers_the_new_position() {
    let folder = TempDir::new();
    folder.write_file("a.txt", "one\n");
    let watching = Arc::new(ManualWatching::new());
    let session = session_over(&watching);
    let received = open_delivering(&session, &folder);
    open_at(&session, "a.txt", b"top");
    let delivered = payloads(&received).len();

    session.select_file("a.txt", Some(FileAct::Position(position(b"line=40;x=2"))));
    assert_eq!(
        payloads(&received).len(),
        delivered,
        "the act delivers nothing"
    );
    folder.write_file("a.txt", "two\n");
    watching
        .subscription_for(&root_of(&folder))
        .expect("a subscription")
        .push(vec![root_of(&folder).join("a.txt")]);

    let members = open_files(&received);
    let newest = members.last().expect("the batch delivered the open file");
    assert_eq!(newest["position"], json!("line=40;x=2"));
    assert_eq!(newest["answer"], text("two\n"));
}

#[test]
fn test_batches_naming_the_file_its_folder_and_the_root_each_deliver_the_open_file() {
    let folder = TempDir::new();
    folder.write_file("sub/a.txt", "v1\n");
    let watching = Arc::new(ManualWatching::new());
    let session = session_over(&watching);
    let received = open_delivering(&session, &folder);
    open_at(&session, "sub/a.txt", b"top");
    let subscription = watching
        .subscription_for(&root_of(&folder))
        .expect("a subscription");
    let root = root_of(&folder);

    for (content, reported) in [
        ("v2\n", root.join("sub/a.txt")),
        ("v3\n", root.join("sub")),
        ("v4\n", root.clone()),
    ] {
        folder.write_file("sub/a.txt", content);
        subscription.push(vec![reported]);
    }

    let answers: Vec<Value> = open_files(&received)
        .iter()
        .map(|member| member["answer"].clone())
        .collect();
    assert_eq!(
        answers,
        vec![text("v1\n"), text("v2\n"), text("v3\n"), text("v4\n")]
    );
}

#[test]
fn test_a_batch_over_unchanged_bytes_delivers_no_open_file_member() {
    let folder = TempDir::new();
    folder.write_file("a.txt", "same\n");
    let watching = Arc::new(ManualWatching::new());
    let session = session_over(&watching);
    let received = open_delivering(&session, &folder);
    open_at(&session, "a.txt", b"top");
    let before = open_files(&received).len();

    folder.write_file("a.txt", "same\n");
    watching
        .subscription_for(&root_of(&folder))
        .expect("a subscription")
        .push(vec![root_of(&folder).join("a.txt")]);

    assert_eq!(open_files(&received).len(), before);
}

#[test]
fn test_after_deletion_the_member_is_the_path_with_state_gone_and_the_bytes_hold_none_of_the_old_text()
 {
    let folder = TempDir::new();
    folder.write_file("a.txt", "the secret words\n");
    let watching = Arc::new(ManualWatching::new());
    let session = session_over(&watching);
    let received = open_delivering(&session, &folder);
    open_at(&session, "a.txt", b"line=2");
    let delivered = received.lock().expect("the payload log").len();

    std::fs::remove_file(folder.path().join("a.txt")).expect("the file is removed");
    watching
        .subscription_for(&root_of(&folder))
        .expect("a subscription")
        .push(vec![root_of(&folder).join("a.txt")]);

    let log = received.lock().expect("the payload log").clone();
    let after = &log[delivered..];
    let members = open_files(&received);
    let gone = members
        .last()
        .expect("the deletion delivered the open file");
    assert_eq!(gone["path"], json!("a.txt"));
    assert_eq!(gone["answer"], json!({ "state": "gone" }));
    assert_eq!(gone["position"], json!("line=2"));
    assert!(!after.is_empty());
    for bytes in after {
        assert!(
            !String::from_utf8_lossy(bytes).contains("secret"),
            "the old text must not cross again"
        );
    }
}

#[test]
fn test_recovery_after_gone_and_after_a_failure_delivers_the_text_with_the_position_the_model_held()
{
    let folder = TempDir::new();
    folder.write_file("a.txt", "first\n");
    let watching = Arc::new(ManualWatching::new());
    let session = session_over(&watching);
    let received = open_delivering(&session, &folder);
    open_at(&session, "a.txt", b"line=9;x=4");
    let subscription = watching
        .subscription_for(&root_of(&folder))
        .expect("a subscription");
    let reported = vec![root_of(&folder).join("a.txt")];

    std::fs::remove_file(folder.path().join("a.txt")).expect("the file is removed");
    subscription.push(reported.clone());
    folder.write_file("a.txt", "second\n");
    subscription.push(reported.clone());
    folder.set_mode("a.txt", 0o000);
    subscription.push(reported.clone());
    folder.set_mode("a.txt", 0o644);
    folder.write_file("a.txt", "third\n");
    subscription.push(reported);

    let members = open_files(&received);
    let states: Vec<Value> = members
        .iter()
        .map(|member| member["answer"].clone())
        .collect();
    assert_eq!(
        states,
        vec![
            text("first\n"),
            json!({ "state": "gone" }),
            text("second\n"),
            json!({ "state": "failed", "condition": "unreadable" }),
            text("third\n"),
        ]
    );
    for member in &members {
        assert_eq!(member["position"], json!("line=9;x=4"));
    }
}

#[test]
fn test_after_opening_a_then_b_a_batch_covering_a_delivers_no_open_file_for_it() {
    let folder = TempDir::new();
    folder.write_file("a.txt", "a1\n");
    folder.write_file("b.txt", "b1\n");
    let watching = Arc::new(ManualWatching::new());
    let session = session_over(&watching);
    let received = open_delivering(&session, &folder);
    open_at(&session, "a.txt", b"top");
    open_at(&session, "b.txt", b"top");
    let before = open_files(&received).len();

    folder.write_file("a.txt", "a2\n");
    watching
        .subscription_for(&root_of(&folder))
        .expect("a subscription")
        .push(vec![root_of(&folder).join("a.txt")]);

    assert_eq!(open_files(&received).len(), before);
}

#[test]
fn test_revisions_rise_by_one_per_payload_that_carries_the_member() {
    let folder = TempDir::new();
    folder.write_file("a.txt", "v1\n");
    let watching = Arc::new(ManualWatching::new());
    let session = session_over(&watching);
    let received = open_delivering(&session, &folder);
    open_at(&session, "a.txt", b"top");
    let subscription = watching
        .subscription_for(&root_of(&folder))
        .expect("a subscription");

    folder.write_file("a.txt", "v2\n");
    subscription.push(vec![root_of(&folder).join("a.txt")]);
    folder.write_file("added.txt", "x");
    subscription.push(vec![root_of(&folder)]);
    folder.write_file("a.txt", "v3\n");
    subscription.push(vec![root_of(&folder).join("a.txt")]);

    let revisions: Vec<Value> = open_files(&received)
        .iter()
        .map(|member| member["revision"].clone())
        .collect();
    assert_eq!(revisions, vec![json!(1), json!(2), json!(3)]);
    assert_eq!(
        payloads(&received).len(),
        4,
        "the listing-only payload carries no member and raises no revision"
    );
}

#[test]
fn test_a_batch_pushed_while_the_opens_read_is_out_leaves_the_opens_payload_holding_the_rewritten_text()
 {
    let folder = TempDir::new();
    folder.write_file("a.txt", "old\n");
    let watching = Arc::new(ManualWatching::new());
    let session = session_over(&watching);
    let received = open_delivering(&session, &folder);
    let subscription = watching
        .subscription_for(&root_of(&folder))
        .expect("a subscription");

    session.select_file_with(
        "a.txt",
        Some(FileAct::Open(position(b"top"))),
        |opened, path| {
            let read = read_file(opened, path);
            folder.write_file("a.txt", "new\n");
            subscription.push(vec![root_of(&folder).join("a.txt")]);
            read
        },
    );

    let members = open_files(&received);
    assert_eq!(members.len(), 1);
    assert_eq!(members[0]["answer"], text("new\n"));
}

/// A delivery that parks inside its first call until the test releases it.
fn parking_delivery(
    entered: mpsc::Sender<()>,
    release: mpsc::Receiver<()>,
    calls: Arc<AtomicUsize>,
) -> ka_reader_bridge::session::Delivery {
    let release = Mutex::new(release);
    let entered = Mutex::new(entered);
    Arc::new(move |_payload| {
        if calls.fetch_add(1, Ordering::SeqCst) == 0 {
            entered
                .lock()
                .expect("the sender")
                .send(())
                .expect("the test is listening");
            release
                .lock()
                .expect("the receiver")
                .recv_timeout(Duration::from_secs(20))
                .expect("the test releases the delivery");
        }
    })
}

#[test]
fn test_a_delivery_blocked_inside_an_opens_callback_holds_a_replacing_open_until_it_is_released_and_is_never_called_after_that_open_returns()
 {
    let first = TempDir::new();
    first.write_file("a.txt", "one\n");
    let second = TempDir::new();
    let watching = Arc::new(ManualWatching::new());
    let session = Arc::new(session_over(&watching));
    let (entered_tx, entered_rx) = mpsc::channel();
    let (release_tx, release_rx) = mpsc::channel();
    let calls = Arc::new(AtomicUsize::new(0));
    session.open_delivering(
        first.path().to_path_buf(),
        parking_delivery(entered_tx, release_rx, Arc::clone(&calls)),
    );
    let opener = {
        let session = Arc::clone(&session);
        std::thread::spawn(move || {
            session.select_file("a.txt", Some(FileAct::Open(position(b"top"))));
        })
    };
    entered_rx
        .recv_timeout(Duration::from_secs(20))
        .expect("the open's delivery is parked in its callback");
    let replaced = Arc::new(AtomicBool::new(false));
    let replacer = {
        let session = Arc::clone(&session);
        let replaced = Arc::clone(&replaced);
        let second = second.path().to_path_buf();
        std::thread::spawn(move || {
            session.open_delivering(second, Arc::new(|payload| drop(payload)));
            replaced.store(true, Ordering::SeqCst);
        })
    };

    std::thread::sleep(Duration::from_millis(400));
    assert!(
        !replaced.load(Ordering::SeqCst),
        "the replacing open waits for the delivery in flight"
    );
    release_tx.send(()).expect("the delivery is waiting");
    replacer.join().expect("the replacing open returns");
    opener.join().expect("the open returns");

    assert!(replaced.load(Ordering::SeqCst));
    let after_return = calls.load(Ordering::SeqCst);
    first.write_file("a.txt", "two\n");
    if let Some(stale) = watching.subscription_for(&root_of(&first)) {
        stale.push(vec![root_of(&first).join("a.txt")]);
    }
    assert_eq!(
        calls.load(Ordering::SeqCst),
        after_return,
        "the replaced grant's callback is never called after the replacing open returned"
    );
}

#[test]
fn test_a_delivery_that_calls_list_and_select_file_from_inside_itself_completes() {
    let folder = TempDir::new();
    folder.write_file("a.txt", "one\n");
    let watching = Arc::new(ManualWatching::new());
    let session = Arc::new(session_over(&watching));
    let (done_tx, done_rx) = mpsc::channel();
    let inner = Arc::clone(&session);
    let done = Mutex::new(done_tx);
    session.open_delivering(
        folder.path().to_path_buf(),
        Arc::new(move |_payload| {
            inner.list("", Some(ka_reader_bridge::session::TreeAct::Expand));
            inner.select_file("a.txt", Some(FileAct::Open(position(b"top"))));
            let _ = done.lock().expect("the sender").send(());
        }),
    );

    let opener = {
        let session = Arc::clone(&session);
        std::thread::spawn(move || {
            session.select_file("a.txt", Some(FileAct::Open(position(b"top"))));
        })
    };

    done_rx
        .recv_timeout(Duration::from_secs(20))
        .expect("the delivery completed while calling the session");
    opener.join().expect("the open returns");
}

#[test]
fn test_a_tree_only_payloads_exact_shape_still_holds() {
    let folder = TempDir::new();
    folder.write_file("a.txt", "one\n");
    let watching = Arc::new(ManualWatching::new());
    let session = session_over(&watching);
    let received = open_delivering(&session, &folder);
    session.list("", Some(ka_reader_bridge::session::TreeAct::Expand));
    folder.write_file("added.txt", "x");

    watching
        .subscription_for(&root_of(&folder))
        .expect("a subscription")
        .push(vec![root_of(&folder)]);

    let log = received.lock().expect("the payload log").clone();
    assert_eq!(log.len(), 1);
    let payload: Value = serde_json::from_slice(&log[0]).expect("JSON");
    let members: Vec<&String> = payload.as_object().expect("an object").keys().collect();
    assert_eq!(members, vec!["listings"]);
}
