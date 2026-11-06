//! The C ABI: the `#[repr(C)]` buffer, the five exports, and the process's one session. Each
//! export decodes, calls the session, and formats through the wrapper, and does nothing else
//! (QC-13). The header generator reads this file, so it holds only what the header must declare.

use std::ffi::{c_char, c_void};
use std::sync::LazyLock;

use crate::boundary::{guarded, list_entries, open_location, select_entry};
use crate::log_install::install_if_application_bundle;
use crate::session::Session;

/// An owned buffer of JSON bytes, made by the bridge and released by `ka_reader_free`.
#[repr(C)]
pub struct KAReaderBuffer {
    pub bytes: *mut u8,
    pub len: usize,
}

/// The shell's `model_changed` callback: called with the `context` the open was given and one owned
/// buffer holding a payload of changed listings, which the shell frees once with `ka_reader_free`.
pub type KAReaderModelChanged = Option<unsafe extern "C" fn(*mut c_void, *mut KAReaderBuffer)>;

#[derive(Clone, Copy, PartialEq, Eq)]
pub(crate) enum BufferOrigin {
    OpenFolder,
    ListTree,
    SelectFile,
    ReadGit,
    ModelChanged,
}

#[repr(C)]
struct OwnedBuffer {
    public: KAReaderBuffer,
    origin: BufferOrigin,
}

impl KAReaderBuffer {
    /// Moves `payload` into a heap buffer and returns the pointer the caller must free once.
    pub(crate) fn allocate(payload: Vec<u8>, origin: BufferOrigin) -> *mut KAReaderBuffer {
        let len = payload.len();
        let bytes = Box::into_raw(payload.into_boxed_slice()).cast::<u8>();
        let owner = Box::new(OwnedBuffer {
            public: KAReaderBuffer { bytes, len },
            origin,
        });
        Box::into_raw(owner).cast::<KAReaderBuffer>()
    }
}

static SESSION: LazyLock<Session> = LazyLock::new(Session::default);

/// Opens the folder the Open panel returned. NULL is rejected. Answers `{"state":"opened"}` or
/// `{"state":"failed","condition":…}`, or NULL on boundary failure; a non-NULL answer is freed
/// with `ka_reader_free`.
///
/// A non-NULL `model_changed` is called, after a successful open, with `context` and one owned
/// buffer of changed listings each time the disk changes the tree; the shell frees each buffer once
/// with `ka_reader_free`. The call may come on any thread, and never after the next successful open
/// has returned. A NULL `model_changed` opens with no subscription and no delivery.
///
/// # Safety
///
/// `location` is NULL, or a NUL-terminated string valid for the call. `context` stays valid until
/// the next successful open has returned (SM-4's lifetime contract).
#[unsafe(no_mangle)]
pub unsafe extern "C" fn ka_reader_open_folder(
    location: *const c_char,
    model_changed: KAReaderModelChanged,
    context: *mut c_void,
) -> *mut KAReaderBuffer {
    // SAFETY: forwarded from the caller.
    guarded(BufferOrigin::OpenFolder, || unsafe {
        open_location(&SESSION, location, model_changed, context)
    })
}

/// Lists a path relative to the open folder's root; NULL or empty is the root. Answers a JSON
/// object tagged by `state`: `{"state":"observed","entries":[…]}` with each entry
/// `{"name","path","kind","state"}`, a `"condition"` beside `"failed"` and a `"language"` on a file
/// entry (a folder entry names none; the bridge carries core's answer and decides nothing),
/// `{"state":"failed","condition":…}`, or `{"state":"pending"}` when nothing was read. NULL on
/// failure; a non-NULL answer is freed with `ka_reader_free`. `act` is what the reader did: `0`
/// expanded the folder, `1` collapsed it; any other value applies nothing and answers `pending`.
///
/// # Safety
///
/// `path` is NULL, or a NUL-terminated string valid for the call.
#[unsafe(no_mangle)]
pub unsafe extern "C" fn ka_reader_list_tree(path: *const c_char, act: u32) -> *mut KAReaderBuffer {
    // SAFETY: forwarded from the caller.
    guarded(BufferOrigin::ListTree, || unsafe {
        list_entries(&SESSION, path, act)
    })
}

/// Applies what the reader did to the file at a path relative to the open folder's root. `act`
/// `0` is the open: the file is selected and opened at `position` (NULL is the empty position), and
/// the answer is its verdict as a JSON object tagged by `state`:
/// `{"state":"text","content":…,"language":"plain"}`, `{"state":"cannot_display","reason":…}`,
/// `{"state":"failed","condition":…}`, or `{"state":"pending"}` when nothing was read (no folder
/// open, or a NULL, empty or non-UTF-8 path). `act` `1` is the position alone: when the path is the
/// open file its position becomes `position` (a NULL one applies nothing), nothing is read, and the
/// answer is `{"state":"pending"}`. Any other `act` applies nothing and answers `pending`. The
/// position's bytes are held as they are, never parsed. NULL on failure; a non-NULL answer is freed
/// with `ka_reader_free`.
///
/// # Safety
///
/// `path` and `position` are each NULL, or a NUL-terminated string valid for the call.
#[unsafe(no_mangle)]
pub unsafe extern "C" fn ka_reader_select_file(
    path: *const c_char,
    act: u32,
    position: *const c_char,
) -> *mut KAReaderBuffer {
    // SAFETY: forwarded from the caller.
    guarded(BufferOrigin::SelectFile, || unsafe {
        select_entry(&SESSION, path, act, position)
    })
}

/// Answers the open folder's Git item as a JSON object tagged by `state`: `{"state":"pending"}` with
/// no folder open or nothing read; `{"state":"observed","kind":"plain"}`;
/// `{"state":"observed","kind":"root","branch":…,"repository_state":…,"staged":[…],"changed":[…]}`;
/// or `{"state":"failed","condition":…}`, with `"git_directory"` only beside
/// `git_directory_outside`. The item is read on the first ask after each successful open and held
/// until the next one. NULL on failure; a non-NULL answer is freed with `ka_reader_free`.
#[unsafe(no_mangle)]
pub extern "C" fn ka_reader_read_git() -> *mut KAReaderBuffer {
    guarded(BufferOrigin::ReadGit, || SESSION.read_git())
}

/// Releases a buffer returned by `ka_reader_open_folder`, `ka_reader_list_tree`, `ka_reader_select_file`
/// or `ka_reader_read_git`, or handed to a `model_changed` callback. NULL does nothing.
///
/// # Safety
///
/// `buffer` is NULL, or a pointer this library returned that has not been freed.
#[unsafe(no_mangle)]
pub unsafe extern "C" fn ka_reader_free(buffer: *mut KAReaderBuffer) {
    if buffer.is_null() {
        return;
    }
    // SAFETY: `KAReaderBuffer` is the first field of `OwnedBuffer`, so this restores the allocation.
    let buffer = unsafe { Box::from_raw(buffer.cast::<OwnedBuffer>()) };
    if buffer.origin == BufferOrigin::OpenFolder
        && !crate::boundary::is_valid_open_answer(buffer.public.bytes, buffer.public.len)
    {
        log::warn!("core-bridge: open_folder stopped: invalid returned answer");
    }
    // SAFETY: `bytes` and `len` are exactly the boxed slice `allocate` leaked.
    drop(unsafe {
        Box::from_raw(std::ptr::slice_from_raw_parts_mut(
            buffer.public.bytes,
            buffer.public.len,
        ))
    });
}

/// The load-time initializer: one function pointer in Mach-O's `__DATA,__mod_init_func`, run when
/// the process loads the image. It sits in this file, the same object as the four exports, because
/// the linker pulls an archive member only for a symbol it resolves, and an initializer anywhere else
/// would be dropped silently. No export installs the writer, and no test process does: the guard
/// answers no unless the process is an application bundle's executable.
#[used]
#[unsafe(link_section = "__DATA,__mod_init_func")]
static INSTALL_LOG_AT_LOAD: extern "C" fn() = install_log_at_load;

extern "C" fn install_log_at_load() {
    // A panic must not unwind out of an `extern "C"` function, and the log is best effort.
    std::panic::catch_unwind(|| install_if_application_bundle(install_silent_panic_hook)).ok();
}

/// Stops Rust's default hook from rendering a panic that an exported boundary catches. The load
/// initializer calls this only after the application-bundle guard accepts the host process.
pub(crate) fn install_silent_panic_hook() {
    std::panic::set_hook(Box::new(|_| {}));
}
