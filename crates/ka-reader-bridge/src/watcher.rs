//! The watcher: one subscription to one granted folder, handing owned path batches to a sink.
//!
//! It reads nothing and decides nothing. A batch is a report of where something may have changed, never
//! a fact about what changed, and the model that receives it (through the bridge's session, not here)
//! works out the rest. This module names no `ka-reader-core` item and no other bridge module.

use std::error::Error;
use std::fmt;
use std::path::{Path, PathBuf};

#[cfg(any(test, feature = "testing"))]
pub mod fakes;
mod fsevents;

/// Where a watcher hands each batch of reported paths: absolute, owned and coalesced. A sink is called
/// on a thread the watcher owns, one batch at a time, until its subscription is stopped.
pub type PathSink = Box<dyn Fn(Vec<PathBuf>) + Send + Sync>;

/// Why a subscription could not start. It carries no path: the watcher was handed one, and a failure
/// that repeated it would write the reader's folder into a log line (QC-39, QC-52).
///
/// ```
/// use ka_reader_bridge::watcher::SubscribeError;
///
/// assert_eq!(
///     SubscribeError::CouldNotStart.to_string(),
///     "the watcher could not start"
/// );
/// ```
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum SubscribeError {
    /// The platform would not start a stream for the folder.
    CouldNotStart,
}

impl fmt::Display for SubscribeError {
    fn fmt(&self, formatter: &mut fmt::Formatter<'_>) -> fmt::Result {
        match self {
            Self::CouldNotStart => formatter.write_str("the watcher could not start"),
        }
    }
}

impl Error for SubscribeError {}

/// A way to watch a folder. The production implementation is `FsEvents`; tests are handed
/// `fakes::ManualWatching`.
///
/// ```
/// use std::path::{Path, PathBuf};
/// use ka_reader_bridge::watcher::fakes::ManualWatching;
/// use ka_reader_bridge::watcher::Watching;
///
/// let watching = ManualWatching::new();
/// let subscription = watching
///     .subscribe(Path::new("/watched"), Box::new(|batch: Vec<PathBuf>| drop(batch)))
///     .expect("the fake starts");
/// subscription.stop();
/// ```
pub trait Watching: Send + Sync {
    /// Subscribes to the absolute `root` and hands every batch to `sink`. The sink is released only
    /// after the returned [`Subscription`] has stopped.
    fn subscribe(&self, root: &Path, sink: PathSink) -> Result<Subscription, SubscribeError>;
}

/// A running subscription. Stopping it, explicitly or by drop, stops the stream and waits for every
/// callback in flight; only then is the sink released, and once stop returns the sink is never called
/// again.
///
/// ```
/// use std::sync::Arc;
/// use std::sync::atomic::{AtomicBool, Ordering};
/// use ka_reader_bridge::watcher::Subscription;
///
/// let stopped = Arc::new(AtomicBool::new(false));
/// let flag = Arc::clone(&stopped);
/// Subscription::new(move || flag.store(true, Ordering::SeqCst)).stop();
/// assert!(stopped.load(Ordering::SeqCst));
/// ```
pub struct Subscription {
    stop: Option<Box<dyn FnOnce() + Send>>,
}

impl Subscription {
    /// A subscription whose stop is `stop`. An implementation of [`Watching`] makes one of these;
    /// `stop` stops its stream, waits for callbacks in flight and releases the sink.
    pub fn new(stop: impl FnOnce() + Send + 'static) -> Self {
        Self {
            stop: Some(Box::new(stop)),
        }
    }

    /// Stops the subscription and returns once nothing more can be delivered.
    pub fn stop(mut self) {
        self.run_stop();
    }

    fn run_stop(&mut self) {
        if let Some(stop) = self.stop.take() {
            stop();
        }
    }
}

impl Drop for Subscription {
    fn drop(&mut self) {
        self.run_stop();
    }
}
