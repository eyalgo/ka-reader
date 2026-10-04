//! The C ABI: the `#[repr(C)]` buffer, the five exports, and the process's one session. Each
//! export decodes, calls the session, and formats through the wrapper, and does nothing else
//! (QC-13). The header generator reads this file, so it holds only what the header must declare.

use std::ffi::c_char;
use std::sync::LazyLock;

use crate::boundary::{guarded, list_entries, open_location, select_entry};
use crate::log_install::install_if_application_bundle;
use crate::session::Session;

/// An owned buffer of JSON bytes, made by the bridge and released by `nozoki_free`.
#[repr(C)]
pub struct NozokiBuffer {
    pub bytes: *mut u8,
    pub len: usize,
}

#[derive(Clone, Copy, PartialEq, Eq)]
pub(crate) enum BufferOrigin {
    OpenFolder,
    ListTree,
    SelectFile,
    ReadGit,
}

#[repr(C)]
struct OwnedBuffer {
    public: NozokiBuffer,
    origin: BufferOrigin,
}

impl NozokiBuffer {
    /// Moves `payload` into a heap buffer and returns the pointer the caller must free once.
    pub(crate) fn allocate(payload: Vec<u8>, origin: BufferOrigin) -> *mut NozokiBuffer {
        let len = payload.len();
        let bytes = Box::into_raw(payload.into_boxed_slice()).cast::<u8>();
        let owner = Box::new(OwnedBuffer {
            public: NozokiBuffer { bytes, len },
            origin,
        });
        Box::into_raw(owner).cast::<NozokiBuffer>()
    }
}

static SESSION: LazyLock<Session> = LazyLock::new(Session::default);

/// Opens the folder the Open panel returned. NULL is rejected. Answers `{"state":"opened"}` or
/// `{"state":"failed","condition":…}`, or NULL on boundary failure; a non-NULL answer is freed
/// with `nozoki_free`.
///
/// # Safety
///
/// `location` is NULL, or a NUL-terminated string valid for the call.
#[unsafe(no_mangle)]
pub unsafe extern "C" fn nozoki_open_folder(location: *const c_char) -> *mut NozokiBuffer {
    // SAFETY: forwarded from the caller.
    guarded(BufferOrigin::OpenFolder, || unsafe {
        open_location(&SESSION, location)
    })
}

/// Lists a path relative to the open folder's root; NULL or empty is the root. Answers a JSON
/// object tagged by `state`: `{"state":"observed","entries":[…]}` with each entry
/// `{"name","path","kind","state"}`, a `"condition"` beside `"failed"` and a `"language"` on a file
/// entry (a folder entry names none; the bridge carries core's answer and decides nothing),
/// `{"state":"failed","condition":…}`, or `{"state":"pending"}` when nothing was read. NULL on
/// failure; a non-NULL answer is freed with `nozoki_free`.
///
/// # Safety
///
/// `path` is NULL, or a NUL-terminated string valid for the call.
#[unsafe(no_mangle)]
pub unsafe extern "C" fn nozoki_list_tree(path: *const c_char) -> *mut NozokiBuffer {
    // SAFETY: forwarded from the caller.
    guarded(BufferOrigin::ListTree, || unsafe {
        list_entries(&SESSION, path)
    })
}

/// Reads the file at a path relative to the open folder's root and answers its verdict as a JSON
/// object tagged by `state`: `{"state":"text","content":…,"language":"plain"}`,
/// `{"state":"cannot_display","reason":…}`, `{"state":"failed","condition":…}`, or
/// `{"state":"pending"}` when nothing was read (no folder open, or a NULL, empty or non-UTF-8
/// path). NULL on failure; a non-NULL answer is freed with `nozoki_free`.
///
/// # Safety
///
/// `path` is NULL, or a NUL-terminated string valid for the call.
#[unsafe(no_mangle)]
pub unsafe extern "C" fn nozoki_select_file(path: *const c_char) -> *mut NozokiBuffer {
    // SAFETY: forwarded from the caller.
    guarded(BufferOrigin::SelectFile, || unsafe {
        select_entry(&SESSION, path)
    })
}

/// Answers the open folder's Git item as a JSON object tagged by `state`: `{"state":"pending"}` with
/// no folder open or nothing read; `{"state":"observed","kind":"plain"}`;
/// `{"state":"observed","kind":"root","branch":…,"repository_state":…,"staged":[…],"changed":[…]}`;
/// or `{"state":"failed","condition":…}`, with `"git_directory"` only beside
/// `git_directory_outside`. The item is read on the first ask after each successful open and held
/// until the next one. NULL on failure; a non-NULL answer is freed with `nozoki_free`.
#[unsafe(no_mangle)]
pub extern "C" fn nozoki_read_git() -> *mut NozokiBuffer {
    guarded(BufferOrigin::ReadGit, || SESSION.read_git())
}

/// Releases a buffer returned by `nozoki_open_folder`, `nozoki_list_tree`, `nozoki_select_file` or
/// `nozoki_read_git`. NULL does nothing.
///
/// # Safety
///
/// `buffer` is NULL, or a pointer this library returned that has not been freed.
#[unsafe(no_mangle)]
pub unsafe extern "C" fn nozoki_free(buffer: *mut NozokiBuffer) {
    if buffer.is_null() {
        return;
    }
    // SAFETY: `NozokiBuffer` is the first field of `OwnedBuffer`, so this restores the allocation.
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
