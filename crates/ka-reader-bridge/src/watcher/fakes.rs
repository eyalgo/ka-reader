//! A watcher a test drives by hand. It is the fake `Watching` is verified against in
//! `tests/watcher.rs`, and it is built only for tests and for the `testing` feature.

use std::path::{Path, PathBuf};
use std::sync::atomic::{AtomicBool, Ordering};
use std::sync::{Arc, Mutex, MutexGuard, PoisonError};

use super::{PathSink, SubscribeError, Subscription, Watching};

/// A `Watching` that records each subscription and delivers only what a test pushes.
///
/// ```
/// use std::path::{Path, PathBuf};
/// use std::sync::mpsc;
/// use ka_reader_bridge::watcher::fakes::ManualWatching;
/// use ka_reader_bridge::watcher::Watching;
///
/// let watching = ManualWatching::new();
/// let (into, from) = mpsc::channel();
/// let _subscription = watching
///     .subscribe(Path::new("/watched"), Box::new(move |batch| {
///         let _ = into.send(batch);
///     }))
///     .expect("the fake starts");
///
/// let recorded = watching.subscription_for(Path::new("/watched")).expect("recorded");
/// recorded.push(vec![PathBuf::from("/watched/a.txt")]);
///
/// assert_eq!(from.recv().expect("a batch"), vec![PathBuf::from("/watched/a.txt")]);
/// ```
pub struct ManualWatching {
    fails: bool,
    recorded: Mutex<Vec<RecordedSubscription>>,
}

impl ManualWatching {
    /// A watcher whose every subscription starts.
    pub fn new() -> Self {
        Self {
            fails: false,
            recorded: Mutex::new(Vec::new()),
        }
    }

    /// A watcher whose every subscription fails to start.
    pub fn failing() -> Self {
        Self {
            fails: true,
            recorded: Mutex::new(Vec::new()),
        }
    }

    /// Every subscription that started, oldest first.
    pub fn recorded(&self) -> Vec<RecordedSubscription> {
        lock(&self.recorded).clone()
    }

    /// The newest subscription to `root`, if one started.
    pub fn subscription_for(&self, root: &Path) -> Option<RecordedSubscription> {
        lock(&self.recorded)
            .iter()
            .rev()
            .find(|recorded| recorded.root == root)
            .cloned()
    }
}

impl Default for ManualWatching {
    fn default() -> Self {
        Self::new()
    }
}

impl Watching for ManualWatching {
    fn subscribe(&self, root: &Path, sink: PathSink) -> Result<Subscription, SubscribeError> {
        if self.fails {
            return Err(SubscribeError::CouldNotStart);
        }
        let state = Arc::new(SubscriptionState {
            sink: Mutex::new(Some(sink)),
            stopped: AtomicBool::new(false),
            released: AtomicBool::new(false),
        });
        lock(&self.recorded).push(RecordedSubscription {
            root: root.to_path_buf(),
            state: Arc::clone(&state),
        });
        Ok(Subscription::new(move || state.stop()))
    }
}

/// One subscription the fake started: a handle a test pushes batches through and reads the end of.
#[derive(Clone)]
pub struct RecordedSubscription {
    root: PathBuf,
    state: Arc<SubscriptionState>,
}

impl RecordedSubscription {
    /// The root the subscription was started on.
    pub fn root(&self) -> &Path {
        &self.root
    }

    /// Hands `batch` to the sink, from the calling thread, and returns when the sink has. Once the
    /// subscription has stopped it delivers nothing. Batches pushed from several threads are
    /// delivered one at a time, as a real watcher's serial queue does.
    pub fn push(&self, batch: Vec<PathBuf>) {
        let guard = lock(&self.state.sink);
        if let Some(sink) = guard.as_ref() {
            sink(batch);
        }
    }

    /// Whether the subscription has been stopped.
    pub fn is_stopped(&self) -> bool {
        self.state.stopped.load(Ordering::SeqCst)
    }

    /// Whether the sink has been dropped, which is after the stop has drained.
    pub fn sink_is_released(&self) -> bool {
        self.state.released.load(Ordering::SeqCst)
    }
}

struct SubscriptionState {
    sink: Mutex<Option<PathSink>>,
    stopped: AtomicBool,
    released: AtomicBool,
}

impl SubscriptionState {
    /// Takes the sink under the lock a push holds while it runs, so a callback in flight finishes
    /// first, and drops it once the lock is free.
    fn stop(&self) {
        self.stopped.store(true, Ordering::SeqCst);
        let sink = lock(&self.sink).take();
        drop(sink);
        self.released.store(true, Ordering::SeqCst);
    }
}

fn lock<T>(mutex: &Mutex<T>) -> MutexGuard<'_, T> {
    mutex.lock().unwrap_or_else(PoisonError::into_inner)
}
