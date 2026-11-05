//! Layer 2: the `Watching` contract. `watching_contract` is a generic suite over the interface; each
//! implementation is run through a `Harness` that says how to make a root and how to make that root
//! report a change. Run it with `cargo test --locked -p ka-reader-bridge --test watcher`.
//!
//! This file runs the suite against the fake, `fakes::ManualWatching`. The production adapter is run
//! through the same suite where it is built (Task 10).

#[allow(
    dead_code,
    reason = "each test crate uses a subset of the shared helpers"
)]
mod common;

use std::fs;
use std::path::{Path, PathBuf};
use std::sync::atomic::{AtomicBool, AtomicUsize, Ordering};
use std::sync::mpsc;
use std::sync::{Arc, Mutex};
use std::thread;
use std::time::{Duration, Instant};

use common::TempDir;

use ka_reader_bridge::watcher::fakes::ManualWatching;
use ka_reader_bridge::watcher::{FsEvents, PathSink, Watching};

/// How long a test waits for something it expects to happen.
const EXPECTED_WITHIN: Duration = Duration::from_secs(10);
/// How long a test waits before concluding that something it expects not to happen has not happened.
const QUIET_FOR: Duration = Duration::from_millis(150);

/// What the contract needs from an implementation beyond the interface itself.
trait Harness: Sync {
    type Watcher: Watching;

    fn watcher(&self) -> &Self::Watcher;
    /// An absolute root the watcher can subscribe to, distinct for each `name`.
    fn make_root(&self, name: &str) -> PathBuf;
    /// Makes `root` report a change. It may block while the sink runs, so a caller that must not
    /// block calls it from another thread.
    fn provoke(&self, root: &Path);
    /// Lets a report that was going to arrive, arrive.
    fn settle(&self);
}

struct FakeHarness {
    watcher: ManualWatching,
}

impl FakeHarness {
    fn new() -> Self {
        Self {
            watcher: ManualWatching::new(),
        }
    }
}

impl Harness for FakeHarness {
    type Watcher = ManualWatching;

    fn watcher(&self) -> &ManualWatching {
        &self.watcher
    }

    fn make_root(&self, name: &str) -> PathBuf {
        PathBuf::from("/watched").join(name)
    }

    fn provoke(&self, root: &Path) {
        self.watcher
            .subscription_for(root)
            .expect("a subscription is recorded for the root")
            .push(vec![root.join("touched.txt")]);
    }

    fn settle(&self) {}
}

/// Records, on drop, that the sink holding it was released.
struct ReleaseFlag(Arc<AtomicBool>);

impl Drop for ReleaseFlag {
    fn drop(&mut self) {
        self.0.store(true, Ordering::SeqCst);
    }
}

fn forwarding_sink(into: mpsc::Sender<Vec<PathBuf>>) -> PathSink {
    Box::new(move |batch| {
        let _ = into.send(batch);
    })
}

/// A sink that counts its batches and sets `released` when it is dropped.
fn counting_sink(delivered: Arc<AtomicUsize>, released: Arc<AtomicBool>) -> PathSink {
    let release_guard = ReleaseFlag(released);
    Box::new(move |_batch| {
        let _still_held = &release_guard;
        delivered.fetch_add(1, Ordering::SeqCst);
    })
}

fn check_batches_reach_only_their_own_sink<H: Harness>(harness: &H) {
    let root_a = harness.make_root("a");
    let root_b = harness.make_root("b");
    let (into_a, from_a) = mpsc::channel();
    let (into_b, from_b) = mpsc::channel();
    let _subscription_a = harness
        .watcher()
        .subscribe(&root_a, forwarding_sink(into_a))
        .expect("subscribe a");
    let _subscription_b = harness
        .watcher()
        .subscribe(&root_b, forwarding_sink(into_b))
        .expect("subscribe b");

    // A real stream can report the creation of a root made just before it started. Let that
    // report arrive and discard it, so what b hears next is only what a's change caused.
    harness.settle();
    while from_a.try_recv().is_ok() {}
    while from_b.try_recv().is_ok() {}

    harness.provoke(&root_a);

    let batch = from_a.recv_timeout(EXPECTED_WITHIN).expect("a's sink");
    assert!(!batch.is_empty());
    assert!(batch.iter().all(|path| path.starts_with(&root_a)));
    assert!(from_b.recv_timeout(QUIET_FOR).is_err());
}

fn check_after_stop_returns_nothing_more_is_delivered_and_the_sink_is_released<H: Harness>(
    harness: &H,
) {
    let root = harness.make_root("stopped");
    let delivered = Arc::new(AtomicUsize::new(0));
    let released = Arc::new(AtomicBool::new(false));
    let subscription = harness
        .watcher()
        .subscribe(
            &root,
            counting_sink(Arc::clone(&delivered), Arc::clone(&released)),
        )
        .expect("subscribe");
    harness.provoke(&root);
    harness.settle();
    assert!(!released.load(Ordering::SeqCst));

    subscription.stop();

    assert!(released.load(Ordering::SeqCst));
    let delivered_at_stop = delivered.load(Ordering::SeqCst);
    harness.provoke(&root);
    harness.settle();
    assert_eq!(delivered.load(Ordering::SeqCst), delivered_at_stop);
}

fn check_dropping_a_subscription_stops_it<H: Harness>(harness: &H) {
    let root = harness.make_root("dropped");
    let delivered = Arc::new(AtomicUsize::new(0));
    let released = Arc::new(AtomicBool::new(false));
    let subscription = harness
        .watcher()
        .subscribe(
            &root,
            counting_sink(Arc::clone(&delivered), Arc::clone(&released)),
        )
        .expect("subscribe");

    drop(subscription);

    assert!(released.load(Ordering::SeqCst));
    let delivered_at_drop = delivered.load(Ordering::SeqCst);
    harness.provoke(&root);
    harness.settle();
    assert_eq!(delivered.load(Ordering::SeqCst), delivered_at_drop);
}

fn check_stop_waits_for_a_callback_in_flight<H: Harness>(harness: &H) {
    let root = harness.make_root("in-flight");
    let (entered_tell, entered_hear) = mpsc::channel();
    let (release_tell, release_hear) = mpsc::channel::<()>();
    let release_hear = Mutex::new(release_hear);
    let sink: PathSink = Box::new(move |_batch| {
        let _ = entered_tell.send(());
        let _ = release_hear
            .lock()
            .expect("the release channel")
            .recv_timeout(EXPECTED_WITHIN);
    });
    let subscription = harness.watcher().subscribe(&root, sink).expect("subscribe");

    thread::scope(|scope| {
        scope.spawn(|| harness.provoke(&root));
        entered_hear
            .recv_timeout(EXPECTED_WITHIN)
            .expect("the sink is entered");
        let (stopped_tell, stopped_hear) = mpsc::channel();
        scope.spawn(move || {
            subscription.stop();
            let _ = stopped_tell.send(());
        });

        assert!(
            stopped_hear.recv_timeout(QUIET_FOR).is_err(),
            "stop returned while a callback was in flight"
        );
        release_tell.send(()).expect("release the callback");
        stopped_hear
            .recv_timeout(EXPECTED_WITHIN)
            .expect("stop returns once the callback has finished");
    });
}

/// The suite every `Watching` implementation satisfies.
fn watching_contract<H: Harness>(make: impl Fn() -> H) {
    check_batches_reach_only_their_own_sink(&make());
    check_after_stop_returns_nothing_more_is_delivered_and_the_sink_is_released(&make());
    check_dropping_a_subscription_stops_it(&make());
    check_stop_waits_for_a_callback_in_flight(&make());
}

#[test]
fn test_the_fake_satisfies_the_watching_contract() {
    watching_contract(FakeHarness::new);
}

#[test]
fn test_batches_reach_only_their_own_sink() {
    check_batches_reach_only_their_own_sink(&FakeHarness::new());
}

#[test]
fn test_after_stop_returns_nothing_more_is_delivered_and_the_sink_is_released() {
    check_after_stop_returns_nothing_more_is_delivered_and_the_sink_is_released(&FakeHarness::new());
}

#[test]
fn test_dropping_a_subscription_stops_it() {
    check_dropping_a_subscription_stops_it(&FakeHarness::new());
}

#[test]
fn test_stop_waits_for_a_callback_in_flight() {
    check_stop_waits_for_a_callback_in_flight(&FakeHarness::new());
}

#[test]
fn test_a_subscribe_failure_names_no_path() {
    let watching = ManualWatching::failing();
    let root = PathBuf::from("/watched/secret-folder-name");
    let (into, _from) = mpsc::channel();

    let failure = match watching.subscribe(&root, forwarding_sink(into)) {
        Ok(_) => panic!("the configured failure did not fail"),
        Err(failure) => failure,
    };

    assert!(!failure.to_string().contains("secret-folder-name"));
    assert!(!format!("{failure:?}").contains("secret-folder-name"));
}

#[test]
fn test_the_fake_reports_whether_a_subscription_was_stopped_and_its_sink_released() {
    let watching = ManualWatching::new();
    let root = PathBuf::from("/watched/recorded");
    let (into, _from) = mpsc::channel();
    let subscription = watching
        .subscribe(&root, forwarding_sink(into))
        .expect("subscribe");
    let recorded = watching.subscription_for(&root).expect("recorded");
    assert!(!recorded.is_stopped());
    assert!(!recorded.sink_is_released());

    subscription.stop();

    assert!(recorded.is_stopped());
    assert!(recorded.sink_is_released());
}

/// The production adapter over real folders under the system temporary directory.
struct FsEventsHarness {
    watcher: FsEvents,
    folder: TempDir,
    provoked: AtomicUsize,
}

/// How long `settle` waits for a report that was going to arrive.
const REAL_SETTLE: Duration = Duration::from_millis(1500);

impl FsEventsHarness {
    fn new() -> Self {
        Self {
            watcher: FsEvents,
            folder: TempDir::new(),
            provoked: AtomicUsize::new(0),
        }
    }
}

impl Harness for FsEventsHarness {
    type Watcher = FsEvents;

    fn watcher(&self) -> &FsEvents {
        &self.watcher
    }

    fn make_root(&self, name: &str) -> PathBuf {
        fs::canonicalize(self.folder.make_folder(name)).expect("the root resolves")
    }

    fn provoke(&self, root: &Path) {
        let number = self.provoked.fetch_add(1, Ordering::SeqCst);
        fs::write(root.join(format!("provoked-{number}.txt")), "x").expect("the file is written");
    }

    fn settle(&self) {
        thread::sleep(REAL_SETTLE);
    }
}

/// Collects batches from `from` until one holds a path `wanted` accepts, or `EXPECTED_WITHIN` passes.
fn batches_until(
    from: &mpsc::Receiver<Vec<PathBuf>>,
    wanted: impl Fn(&Path) -> bool,
) -> Option<Vec<PathBuf>> {
    let deadline = Instant::now() + EXPECTED_WITHIN;
    while let Some(left) = deadline.checked_duration_since(Instant::now()) {
        if let Ok(batch) = from.recv_timeout(left)
            && batch.iter().any(|path| wanted(path))
        {
            return Some(batch);
        }
    }
    None
}

#[test]
fn test_fsevents_satisfies_the_watching_contract() {
    watching_contract(FsEventsHarness::new);
}

#[test]
fn test_a_file_created_at_depth_is_reported_as_itself_or_an_ancestor_within_the_root() {
    let harness = FsEventsHarness::new();
    let root = harness.make_root("depth");
    let deep = root.join("one/two/three");
    fs::create_dir_all(&deep).expect("the nested folders");
    let (into, from) = mpsc::channel();
    let _subscription = harness
        .watcher()
        .subscribe(&root, forwarding_sink(into))
        .expect("subscribe");

    let file = deep.join("created.txt");
    fs::write(&file, "x").expect("the file is written");

    let batch = batches_until(&from, |path| {
        file.starts_with(path) && path.starts_with(&root)
    })
    .expect("the file or an ancestor within the root is reported");
    assert!(batch.iter().all(|path| path.starts_with(&root)));
}

#[test]
fn test_a_change_under_the_roots_git_entry_is_reported() {
    let harness = FsEventsHarness::new();
    let root = harness.make_root("with-git");
    let git_entry = root.join(".git");
    fs::create_dir_all(&git_entry).expect("the .git folder");
    let (into, from) = mpsc::channel();
    let _subscription = harness
        .watcher()
        .subscribe(&root, forwarding_sink(into))
        .expect("subscribe");

    fs::write(git_entry.join("HEAD"), "ref: refs/heads/main\n").expect("HEAD is written");

    assert!(batches_until(&from, |path| path.starts_with(&git_entry)).is_some());
}

#[test]
fn test_no_reported_path_lies_outside_the_root_unless_it_is_the_root() {
    let harness = FsEventsHarness::new();
    let root = harness.make_root("inside");
    let neighbour = harness.make_root("inside-and-more");
    let (into, from) = mpsc::channel();
    let _subscription = harness
        .watcher()
        .subscribe(&root, forwarding_sink(into))
        .expect("subscribe");

    fs::write(neighbour.join("elsewhere.txt"), "x").expect("the neighbour is written");
    harness.provoke(&root);
    harness.settle();

    let mut reported = Vec::new();
    while let Ok(batch) = from.try_recv() {
        reported.extend(batch);
    }
    assert!(
        !reported.is_empty(),
        "the change under the root is reported"
    );
    assert!(
        reported.iter().all(|path| path.starts_with(&root)),
        "reported: {reported:?}"
    );
}
