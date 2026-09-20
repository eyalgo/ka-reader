//! `nozoki-sandbox-probe <pid>` — asks the operating system what sandbox a running process is under.
//!
//! WHY THIS EXISTS
//!   `checks/bundle.sh` must know from the operating system, not from anything the launched process
//!   carries, whether the bundle it launched is sandboxed and what that sandbox denies (`docs/SDD.md`
//!   § 4 C-I3; NFDR QC-25; ADR-0010). The one interface that answers is libSystem's `sandbox_check`,
//!   and no shell can call it — so `checks/bundle.sh` compiles this file with `rustc` at run time into
//!   its temporary directory and runs the result.
//!
//! WHY IT IS NOT A CRATE
//!   This is a standalone source: no `Cargo.toml`, no lockfile, no dependency, no workspace member, no
//!   committed binary. It lies outside `members = ["crates/*"]`, so `cargo build --workspace` and
//!   `cargo tree --workspace` never see it and `checks/deps.allow` gains nothing from it. Being outside
//!   the workspace, the workspace's `unsafe_code = "forbid"` lint does not reach it — the
//!   foreign-function case that lint's own comment carves out (`Cargo.toml`, `[workspace.lints.rust]`).
//!
//! OUTPUT CONTRACT
//!   Exit 0 with exactly three lines on stdout, one per condition, when all three were read:
//!     sandboxed: yes|no
//!     out-of-grant-read: denied|allowed
//!     outbound-connection: denied|allowed
//!   The probe reports; `checks/bundle.sh` judges. A process that is not sandboxed is still a
//!   successful read of three answers. Exit non-zero, naming `sandbox_check` on stderr, when the symbol
//!   cannot be resolved (exit 2) or returns an error (exit 1): neither is a pass and neither is a denial
//!   (CP-43). A pid that names no process is also exit 1 — `sandbox_check` itself would call it
//!   sandboxed.

use std::env;
use std::ffi::{c_char, c_int, c_void, CString};
use std::process::exit;

const SYMBOL: &str = "sandbox_check";

/// `SANDBOX_FILTER_NONE` and `SANDBOX_FILTER_PATH` from `<sandbox.h>`, which does not declare
/// `sandbox_check` itself even though libSystem exports it (ADR-0010 § What this rests on).
const FILTER_NONE: c_int = 0;
const FILTER_PATH: c_int = 1;

/// `RTLD_DEFAULT` on macOS is `((void *) -2)`; it searches every image already loaded.
const RTLD_DEFAULT: *mut c_void = -2_isize as *mut c_void;

/// A read outside the grant that the sandbox denies by policy whether or not the file exists: a `$HOME`
/// dotfile, the measured case (`~/.zshrc`, `docs/SDD.md` § 10 RC-1). An `/etc` or `/usr` path is not —
/// the default profile allows many of them.
const OUT_OF_GRANT_FILE: &str = ".zshrc";
const READ_OPERATION: &str = "file-read-data";
const OUTBOUND_OPERATION: &str = "network-outbound";

type SandboxCheck = unsafe extern "C" fn(c_int, *const c_char, c_int, ...) -> c_int;

/// `ESRCH` on macOS: "No such process".
const NO_SUCH_PROCESS: i32 = 3;

extern "C" {
    fn dlsym(handle: *mut c_void, symbol: *const c_char) -> *mut c_void;
    fn kill(pid: c_int, signal: c_int) -> c_int;
}

fn fail(exit_code: i32, message: &str) -> ! {
    eprintln!("nozoki-sandbox-probe: {message}");
    exit(exit_code)
}

fn resolve_sandbox_check() -> SandboxCheck {
    let name = CString::new(SYMBOL).expect("the symbol name holds no NUL byte");
    // SAFETY: `dlsym` is given a valid NUL-terminated name and a search handle libSystem defines.
    let address = unsafe { dlsym(RTLD_DEFAULT, name.as_ptr()) };
    if address.is_null() {
        fail(2, &format!("{SYMBOL} cannot be resolved"));
    }
    // SAFETY: the address is `sandbox_check`, whose C signature is
    // `int sandbox_check(pid_t, const char *operation, enum sandbox_filter_type, ...)`.
    unsafe { std::mem::transmute::<*mut c_void, SandboxCheck>(address) }
}

/// What `sandbox_check` reported: `Ok(true)` when the operation is denied, `Ok(false)` when allowed.
fn read_verdict(result: c_int) -> Result<bool, String> {
    if result < 0 {
        return Err(format!("{SYMBOL} returned an error ({result})"));
    }
    Ok(result != 0)
}

fn denied_or_allowed(denied: bool) -> &'static str {
    if denied {
        "denied"
    } else {
        "allowed"
    }
}

fn yes_or_no(value: bool) -> &'static str {
    if value {
        "yes"
    } else {
        "no"
    }
}

fn parse_pid(arguments: &[String]) -> c_int {
    match arguments {
        [pid] => pid
            .parse::<c_int>()
            .ok()
            .filter(|pid| *pid > 0)
            .unwrap_or_else(|| fail(2, &format!("not a process id: {pid}"))),
        _ => fail(2, "usage: nozoki-sandbox-probe <pid>"),
    }
}

/// `sandbox_check` answers "sandboxed, everything denied" for a pid that names no process — measured
/// on pid 99999999 — so an absent process would read as a held wall. Signal 0 delivers nothing and
/// only asks whether the process exists; a process the caller may not signal (`EPERM`) still exists.
fn require_running(pid: c_int) {
    // SAFETY: signal 0 performs the existence check and delivers no signal.
    let result = unsafe { kill(pid, 0) };
    if result != 0 && std::io::Error::last_os_error().raw_os_error() == Some(NO_SUCH_PROCESS) {
        fail(1, &format!("no process has pid {pid}, so {SYMBOL} has nothing to read"));
    }
}

fn out_of_grant_path() -> CString {
    let home = env::var("HOME").unwrap_or_else(|_| fail(1, "HOME is not set, so no out-of-grant path can be named"));
    CString::new(format!("{home}/{OUT_OF_GRANT_FILE}")).unwrap_or_else(|_| fail(1, "HOME holds a NUL byte"))
}

fn main() {
    let arguments: Vec<String> = env::args().skip(1).collect();
    let pid = parse_pid(&arguments);
    require_running(pid);
    let sandbox_check = resolve_sandbox_check();

    let read_operation = CString::new(READ_OPERATION).expect("no NUL byte");
    let outbound_operation = CString::new(OUTBOUND_OPERATION).expect("no NUL byte");
    let path = out_of_grant_path();

    // SAFETY (all three calls): every pointer is a live NUL-terminated string for the call's
    // duration, and the variadic argument of the path filter is the `const char *` that filter takes.
    let sandboxed = read_verdict(unsafe { sandbox_check(pid, std::ptr::null(), FILTER_NONE) });
    let read_denied =
        read_verdict(unsafe { sandbox_check(pid, read_operation.as_ptr(), FILTER_PATH, path.as_ptr()) });
    let outbound_denied = read_verdict(unsafe { sandbox_check(pid, outbound_operation.as_ptr(), FILTER_NONE) });

    match (sandboxed, read_denied, outbound_denied) {
        (Ok(sandboxed), Ok(read_denied), Ok(outbound_denied)) => {
            println!("sandboxed: {}", yes_or_no(sandboxed));
            println!("out-of-grant-read: {}", denied_or_allowed(read_denied));
            println!("outbound-connection: {}", denied_or_allowed(outbound_denied));
        }
        (Err(message), _, _) | (_, Err(message), _) | (_, _, Err(message)) => fail(1, &message),
    }
}
