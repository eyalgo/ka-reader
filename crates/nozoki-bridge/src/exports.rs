//! The C ABI: the `#[repr(C)]` buffer, the three exports, and the process's one session. Each
//! export decodes, calls the session, and formats through the wrapper, and does nothing else
//! (QC-13). The header generator reads this file, so it holds only what the header must declare.

use std::ffi::c_char;
use std::sync::LazyLock;

use crate::boundary::{guarded, list_entries, open_location};
use crate::log_install::install_if_application_bundle;
use crate::session::Session;

/// An owned buffer of JSON bytes, made by the bridge and released by `nozoki_free`.
#[repr(C)]
pub struct NozokiBuffer {
    pub bytes: *mut u8,
    pub len: usize,
}

impl NozokiBuffer {
    /// Moves `payload` into a heap buffer and returns the pointer the caller must free once.
    pub fn allocate(payload: Vec<u8>) -> *mut NozokiBuffer {
        let len = payload.len();
        let bytes = Box::into_raw(payload.into_boxed_slice()).cast::<u8>();
        Box::into_raw(Box::new(NozokiBuffer { bytes, len }))
    }
}

static SESSION: LazyLock<Session> = LazyLock::new(Session::default);

/// Opens the folder the Open panel returned. NULL is a cancel. Answers `{"opened": true|false}`,
/// or NULL on failure; a non-NULL answer is freed with `nozoki_free`.
///
/// # Safety
///
/// `location` is NULL, or a NUL-terminated string valid for the call.
#[unsafe(no_mangle)]
pub unsafe extern "C" fn nozoki_open_folder(location: *const c_char) -> *mut NozokiBuffer {
    // SAFETY: forwarded from the caller.
    guarded(|| unsafe { open_location(&SESSION, location) })
}

/// Lists a path relative to the open folder's root; NULL or empty is the root. Answers a JSON
/// array of `{"name", "path", "kind"}`, or NULL on failure; a non-NULL answer is freed with
/// `nozoki_free`.
///
/// # Safety
///
/// `path` is NULL, or a NUL-terminated string valid for the call.
#[unsafe(no_mangle)]
pub unsafe extern "C" fn nozoki_list_tree(path: *const c_char) -> *mut NozokiBuffer {
    // SAFETY: forwarded from the caller.
    guarded(|| unsafe { list_entries(&SESSION, path) })
}

/// Releases a buffer returned by `nozoki_open_folder` or `nozoki_list_tree`. NULL does nothing.
///
/// # Safety
///
/// `buffer` is NULL, or a pointer this library returned that has not been freed.
#[unsafe(no_mangle)]
pub unsafe extern "C" fn nozoki_free(buffer: *mut NozokiBuffer) {
    if buffer.is_null() {
        return;
    }
    // SAFETY: the caller guarantees `buffer` came from `NozokiBuffer::allocate` and is freed once.
    let buffer = unsafe { Box::from_raw(buffer) };
    // SAFETY: `bytes` and `len` are exactly the boxed slice `allocate` leaked.
    drop(unsafe { Box::from_raw(std::ptr::slice_from_raw_parts_mut(buffer.bytes, buffer.len)) });
}

/// The load-time initializer: one function pointer in Mach-O's `__DATA,__mod_init_func`, run when
/// the process loads the image. It sits in this file, the same object as the three exports, because
/// the linker pulls an archive member only for a symbol it resolves, and an initializer anywhere else
/// would be dropped silently. No export installs the writer, and no test process does: the guard
/// answers no unless the process is an application bundle's executable.
#[used]
#[unsafe(link_section = "__DATA,__mod_init_func")]
static INSTALL_LOG_AT_LOAD: extern "C" fn() = install_log_at_load;

extern "C" fn install_log_at_load() {
    // A panic must not unwind out of an `extern "C"` function, and the log is best effort.
    std::panic::catch_unwind(install_if_application_bundle).ok();
}
