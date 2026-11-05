//! The one native binding: macOS FSEvents, written by hand.
//!
//! The binding is an `extern` block linked to CoreServices and CoreFoundation by attribute, plus the
//! libdispatch functions libSystem carries, so no crate is added. The stream is created on a private
//! serial dispatch queue, which needs no run-loop thread, and it starts "since now": it reports what
//! happens after it is created and never replays history.
//!
//! The adapter never `stat`s, canonicalizes or checks for the existence of a reported path. A path is
//! a report and the model decides what it means (QC-15).

use std::collections::HashSet;
use std::ffi::{CStr, c_char, c_void};
use std::os::unix::ffi::OsStrExt;
use std::panic::{AssertUnwindSafe, catch_unwind};
use std::path::{Path, PathBuf};
use std::ptr;

use super::{PathSink, SubscribeError, Subscription, Watching};

/// How long FSEvents coalesces events before it calls back. It is a delivery parameter that trades
/// calls for latency, never a promised figure (QC-45).
const COALESCING_LATENCY_SECONDS: f64 = 0.05;

/// `kFSEventStreamEventIdSinceNow`.
const SINCE_NOW: u64 = u64::MAX;

/// `NoDefer | WatchRoot | FileEvents`: the first event after a quiet period is not held back, a move
/// or removal of the root itself is reported, and events name files and not just their folders.
const CREATE_FLAGS: u32 = 0x0000_0002 | 0x0000_0004 | 0x0000_0010;

/// The event flags that say the stream cannot vouch for what changed or where: `MustScanSubDirs`,
/// `UserDropped`, `KernelDropped`, `EventIdsWrapped` and `RootChanged`. A report carrying any of them
/// stands for the whole granted root.
const UNCERTAIN_EVENT_FLAGS: u32 =
    0x0000_0001 | 0x0000_0002 | 0x0000_0004 | 0x0000_0008 | 0x0000_0020;

/// `kCFStringEncodingUTF8`.
const UTF8_ENCODING: u32 = 0x0800_0100;

type CoreFoundationObject = *const c_void;
type StreamRef = *mut c_void;
type DispatchQueue = *mut c_void;
type StreamCallback = extern "C" fn(
    stream: StreamRef,
    info: *mut c_void,
    count: usize,
    paths: *mut c_void,
    flags: *const u32,
    ids: *const u64,
);

#[repr(C)]
struct StreamContext {
    version: isize,
    info: *mut c_void,
    retain: *const c_void,
    release: *const c_void,
    copy_description: *const c_void,
}

/// Only its address is used: the array is made with CoreFoundation's own callbacks.
#[repr(C)]
struct ArrayCallBacks {
    _private: [u8; 0],
}

#[link(name = "CoreServices", kind = "framework")]
unsafe extern "C" {
    #[link_name = "FSEventStreamCreate"]
    fn stream_create(
        allocator: CoreFoundationObject,
        callback: StreamCallback,
        context: *const StreamContext,
        paths: CoreFoundationObject,
        since: u64,
        latency: f64,
        flags: u32,
    ) -> StreamRef;
    #[link_name = "FSEventStreamSetDispatchQueue"]
    fn stream_set_dispatch_queue(stream: StreamRef, queue: DispatchQueue);
    #[link_name = "FSEventStreamStart"]
    fn stream_start(stream: StreamRef) -> u8;
    #[link_name = "FSEventStreamStop"]
    fn stream_stop(stream: StreamRef);
    #[link_name = "FSEventStreamInvalidate"]
    fn stream_invalidate(stream: StreamRef);
    #[link_name = "FSEventStreamRelease"]
    fn stream_release(stream: StreamRef);
}

#[link(name = "CoreFoundation", kind = "framework")]
unsafe extern "C" {
    #[link_name = "CFStringCreateWithBytes"]
    fn string_create_with_bytes(
        allocator: CoreFoundationObject,
        bytes: *const u8,
        length: isize,
        encoding: u32,
        is_external_representation: u8,
    ) -> CoreFoundationObject;
    #[link_name = "CFArrayCreate"]
    fn array_create(
        allocator: CoreFoundationObject,
        values: *const CoreFoundationObject,
        count: isize,
        callbacks: *const ArrayCallBacks,
    ) -> CoreFoundationObject;
    #[link_name = "CFRelease"]
    fn object_release(object: CoreFoundationObject);
    #[link_name = "kCFTypeArrayCallBacks"]
    static TYPE_ARRAY_CALLBACKS: ArrayCallBacks;
}

// libdispatch is part of libSystem, which every link carries.
unsafe extern "C" {
    #[link_name = "dispatch_queue_create"]
    fn queue_create(label: *const c_char, attributes: *const c_void) -> DispatchQueue;
    #[link_name = "dispatch_sync_f"]
    fn queue_sync(queue: DispatchQueue, context: *mut c_void, work: extern "C" fn(*mut c_void));
    #[link_name = "dispatch_release"]
    fn queue_release(queue: DispatchQueue);
}

/// What a report stands for: the path the stream named, or the whole granted `root` when the event's
/// `flags` say the stream is uncertain. The path is the stream's bytes, whatever they are.
fn report_for(path: &[u8], flags: u32, root: &Path) -> PathBuf {
    if flags & UNCERTAIN_EVENT_FLAGS != 0 {
        root.to_path_buf()
    } else {
        PathBuf::from(std::ffi::OsStr::from_bytes(path))
    }
}

/// One callback's events as one batch: each report once, in the order first seen.
fn batch_from<'a>(entries: impl IntoIterator<Item = (&'a [u8], u32)>, root: &Path) -> Vec<PathBuf> {
    let mut seen = HashSet::new();
    let mut batch = Vec::new();
    for (path, flags) in entries {
        let report = report_for(path, flags, root);
        if seen.insert(report.clone()) {
            batch.push(report);
        }
    }
    batch
}

/// What the stream's callback reaches through its `info` pointer.
struct CallbackState {
    root: PathBuf,
    sink: PathSink,
}

extern "C" fn deliver(
    _stream: StreamRef,
    info: *mut c_void,
    count: usize,
    paths: *mut c_void,
    flags: *const u32,
    _ids: *const u64,
) {
    // SAFETY: `info` is the `CallbackState` the subscription boxed for this stream. `NativeStream::stop`
    // drops it only after the stream's queue has drained, so it outlives every call.
    let state = unsafe { &*info.cast::<CallbackState>() };
    let names = paths.cast::<*const c_char>();
    let entries = (0..count).map(|index| {
        // SAFETY: the stream passes `count` C strings in `paths` and `count` words in `flags`
        // (FSEventStreamCallback), valid for the duration of this call, and no CF-types flag is set.
        unsafe {
            (
                CStr::from_ptr(*names.add(index)).to_bytes(),
                *flags.add(index),
            )
        }
    });
    let batch = batch_from(entries, &state.root);
    if batch.is_empty() {
        return;
    }
    // A panic must not unwind into the framework's frames. The sink is not expected to panic.
    if catch_unwind(AssertUnwindSafe(|| (state.sink)(batch))).is_err() {
        log::warn!("watcher: a sink panicked, the batch was dropped so the stream can go on");
    }
}

extern "C" fn drain_marker(_context: *mut c_void) {}

/// The stream, its queue and its callback state, kept until the subscription stops.
struct NativeStream {
    stream: StreamRef,
    queue: DispatchQueue,
    state: *mut CallbackState,
}

// SAFETY: the three pointers are owned by this value alone. The framework calls are made from whichever
// thread stops the subscription, which FSEvents and libdispatch allow for a stream on a private queue.
unsafe impl Send for NativeStream {}

impl NativeStream {
    /// Stop, invalidate, drain the stream's own queue, release, and only then drop the sink.
    fn stop(self) {
        // SAFETY: each pointer was made by `start` and is released here exactly once. The synchronous
        // empty task on the serial queue returns after every callback queued before it, and invalidate
        // has already ruled out any queued after.
        unsafe {
            stream_stop(self.stream);
            stream_invalidate(self.stream);
            queue_sync(self.queue, ptr::null_mut(), drain_marker);
            stream_release(self.stream);
            queue_release(self.queue);
            drop(Box::from_raw(self.state));
        }
    }
}

/// The folder as a one-element CoreFoundation array of strings, or `None` when it is not UTF-8.
fn watched_paths(root: &Path) -> Option<CoreFoundationObject> {
    let bytes = root.as_os_str().as_bytes();
    let length = isize::try_from(bytes.len()).ok()?;
    // SAFETY: `bytes` is valid for `length` bytes; a null allocator is the default one.
    let text =
        unsafe { string_create_with_bytes(ptr::null(), bytes.as_ptr(), length, UTF8_ENCODING, 0) };
    if text.is_null() {
        return None;
    }
    let values = [text];
    // SAFETY: `values` holds one live string and the callbacks are CoreFoundation's own, which retain it.
    let array = unsafe {
        array_create(
            ptr::null(),
            values.as_ptr(),
            1,
            &raw const TYPE_ARRAY_CALLBACKS,
        )
    };
    // SAFETY: the array holds its own reference to the string.
    unsafe { object_release(text) };
    (!array.is_null()).then_some(array)
}

/// The production [`Watching`]: one FSEvents stream on a private serial queue for each subscription.
///
/// A batch is delivered on that queue, so a sink must not stop its own subscription: stopping waits
/// for the queue, and the queue is waiting for the sink.
///
/// ```
/// use std::path::{Path, PathBuf};
/// use ka_reader_bridge::watcher::{FsEvents, Watching};
///
/// let subscription = FsEvents
///     .subscribe(Path::new("/tmp"), Box::new(|batch: Vec<PathBuf>| drop(batch)))
///     .expect("a stream starts on /tmp");
/// subscription.stop();
/// ```
pub struct FsEvents;

impl Watching for FsEvents {
    fn subscribe(&self, root: &Path, sink: PathSink) -> Result<Subscription, SubscribeError> {
        if !root.is_absolute() {
            return Err(SubscribeError::CouldNotStart);
        }
        let paths = watched_paths(root).ok_or(SubscribeError::CouldNotStart)?;
        let started = start(root, sink, paths);
        // SAFETY: `paths` is ours and the stream, if one was made, holds its own copy.
        unsafe { object_release(paths) };
        let stream = started?;
        Ok(Subscription::new(move || stream.stop()))
    }
}

fn start(
    root: &Path,
    sink: PathSink,
    paths: CoreFoundationObject,
) -> Result<NativeStream, SubscribeError> {
    // SAFETY: a null attribute is the serial queue; the label is a static C string.
    let queue = unsafe { queue_create(c"ka-reader.watcher".as_ptr(), ptr::null()) };
    if queue.is_null() {
        return Err(SubscribeError::CouldNotStart);
    }
    let state = Box::into_raw(Box::new(CallbackState {
        root: root.to_path_buf(),
        sink,
    }));
    let context = StreamContext {
        version: 0,
        info: state.cast(),
        retain: ptr::null(),
        release: ptr::null(),
        copy_description: ptr::null(),
    };
    // SAFETY: `context` and `paths` are valid for the call, which copies both.
    let stream = unsafe {
        stream_create(
            ptr::null(),
            deliver,
            &context,
            paths,
            SINCE_NOW,
            COALESCING_LATENCY_SECONDS,
            CREATE_FLAGS,
        )
    };
    let started = !stream.is_null() && {
        // SAFETY: `stream` is live and `queue` is a live serial queue.
        unsafe {
            stream_set_dispatch_queue(stream, queue);
            stream_start(stream) != 0
        }
    };
    if started {
        return Ok(NativeStream {
            stream,
            queue,
            state,
        });
    }
    // SAFETY: the stream (if any), the queue and the state are ours and nothing has been delivered.
    unsafe {
        if !stream.is_null() {
            stream_invalidate(stream);
            stream_release(stream);
        }
        queue_release(queue);
        drop(Box::from_raw(state));
    }
    Err(SubscribeError::CouldNotStart)
}

#[cfg(test)]
mod tests {
    use std::os::unix::ffi::OsStrExt;
    use std::path::{Path, PathBuf};

    use super::{batch_from, report_for};

    const ROOT: &str = "/granted/root";
    /// The `FSEventStreamEventFlag` words that say the stream cannot vouch for what changed.
    const UNCERTAIN_FLAGS: [(&str, u32); 5] = [
        ("must scan subdirectories", 0x0000_0001),
        ("user dropped", 0x0000_0002),
        ("kernel dropped", 0x0000_0004),
        ("event ids wrapped", 0x0000_0008),
        ("root changed", 0x0000_0020),
    ];
    /// `ItemCreated | ItemIsFile`, an ordinary file event.
    const ORDINARY_FLAGS: u32 = 0x0000_0100 | 0x0001_0000;

    #[test]
    fn test_each_uncertain_flag_maps_to_the_granted_root() {
        for (name, flag) in UNCERTAIN_FLAGS {
            assert_eq!(
                report_for(b"/granted/root/a/b.txt", flag, Path::new(ROOT)),
                PathBuf::from(ROOT),
                "{name}"
            );
        }
    }

    #[test]
    fn test_an_ordinary_flag_keeps_the_path() {
        assert_eq!(
            report_for(b"/granted/root/a/b.txt", ORDINARY_FLAGS, Path::new(ROOT)),
            PathBuf::from("/granted/root/a/b.txt")
        );
    }

    #[test]
    fn test_a_non_utf8_path_survives_as_bytes() {
        let bytes: &[u8] = b"/granted/root/caf\xE9.txt";

        let reported = report_for(bytes, ORDINARY_FLAGS, Path::new(ROOT));

        assert_eq!(reported.as_os_str().as_bytes(), bytes);
    }

    #[test]
    fn test_a_batch_names_each_path_once_in_the_order_first_seen() {
        let entries: [(&[u8], u32); 4] = [
            (b"/granted/root/b.txt", ORDINARY_FLAGS),
            (b"/granted/root/a.txt", ORDINARY_FLAGS),
            (b"/granted/root/b.txt", ORDINARY_FLAGS),
            (b"/granted/root/c.txt", UNCERTAIN_FLAGS[1].1),
        ];

        let batch = batch_from(entries, Path::new(ROOT));

        assert_eq!(
            batch,
            vec![
                PathBuf::from("/granted/root/b.txt"),
                PathBuf::from("/granted/root/a.txt"),
                PathBuf::from(ROOT),
            ]
        );
    }
}
