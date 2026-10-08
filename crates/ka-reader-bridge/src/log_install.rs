//! The log's load-time install: when a process that is an application bundle's executable loads the
//! bridge, and only then, install C-I2's writer at the log path inside the sandbox container.
//!
//! Nothing here reads `HOME` (QC-30 half 1): the home directory is the password database's answer
//! for the current user. Nothing here touches the filesystem either; the one existence check lives in
//! `log_writer` (QC-13). The guard is a pure function so its cases need no process to load.

use std::ffi::{CStr, OsStr};
use std::os::unix::ffi::OsStrExt;
use std::path::{Path, PathBuf};

use crate::log_writer;

/// C-I2's container folder, below the user's home. The writer appends its own `Library/Logs/ka-reader.log`.
const CONTAINER_BELOW_HOME: &str = "Library/Containers/com.kensaiapp.ka-reader/Data";

/// The first password-database buffer, and the most it grows to before the lookup gives up.
const PASSWORD_BUFFER_START: usize = 1024;
const PASSWORD_BUFFER_LIMIT: usize = 1 << 20;

/// The sandbox container's `Data` folder below `home`.
pub fn container_path(home: &Path) -> PathBuf {
    home.join(CONTAINER_BELOW_HOME)
}

/// Whether the writer is installed: `executable` is `<x>.app/Contents/MacOS/<exe>` and the
/// container's `Data` directory already exists. A cargo test binary, an `.xctest` bundle and a
/// bundle with no container all answer no, so no test process installs a logger and the bridge never
/// creates a container.
pub fn should_install(executable: &Path, container_exists: bool) -> bool {
    container_exists && is_application_bundle_executable(executable)
}

fn is_application_bundle_executable(executable: &Path) -> bool {
    let macos = executable.parent();
    let contents = macos.and_then(Path::parent);
    let bundle = contents.and_then(Path::parent);
    name_of(macos) == Some(OsStr::new("MacOS"))
        && name_of(contents) == Some(OsStr::new("Contents"))
        && name_of(bundle).is_some_and(|name| name.as_bytes().ends_with(b".app"))
}

fn name_of(path: Option<&Path>) -> Option<&OsStr> {
    path.and_then(Path::file_name)
}

/// The current user's home directory, from the password database (`getpwuid_r` over `getuid`).
pub fn home_directory() -> Option<PathBuf> {
    let mut size = PASSWORD_BUFFER_START;
    while size <= PASSWORD_BUFFER_LIMIT {
        let mut buffer = vec![0 as libc::c_char; size];
        // SAFETY: an all-zero `passwd` is a valid value to pass as the out-parameter.
        let mut entry: libc::passwd = unsafe { std::mem::zeroed() };
        let mut found: *mut libc::passwd = std::ptr::null_mut();
        // SAFETY: `entry`, `buffer` and `found` are live locals, and `size` is `buffer`'s length.
        let status = unsafe {
            libc::getpwuid_r(
                libc::getuid(),
                &mut entry,
                buffer.as_mut_ptr(),
                size,
                &mut found,
            )
        };
        if status == libc::ERANGE {
            size *= 2;
            continue;
        }
        if status != 0 || found.is_null() || entry.pw_dir.is_null() {
            return None;
        }
        // SAFETY: `pw_dir` points into `buffer`, NUL-terminated by `getpwuid_r`, and `buffer` is alive.
        let home = unsafe { CStr::from_ptr(entry.pw_dir) };
        return Some(PathBuf::from(OsStr::from_bytes(home.to_bytes())));
    }
    None
}

/// Prepares the runtime and installs the writer when the running process is an application bundle's
/// executable and its container exists. Every other case does nothing. `prepare` runs after that
/// guard accepts the process and before any fallible installation work.
pub(crate) fn install_if_application_bundle(prepare: impl FnOnce()) {
    let Ok(executable) = std::env::current_exe() else {
        return;
    };
    let Some(home) = home_directory() else {
        return;
    };
    let container = container_path(&home);
    if should_install(&executable, log_writer::directory_exists(&container)) {
        prepare();
        // A logger already installed by the host is not the bridge's to replace, and continuing is
        // correct. The host's logger is the one place the refusal can be said.
        if let Err(error) = log_writer::install(&container) {
            log::warn!("the bridge's log writer was not installed: {error}");
        }
    }
}

#[cfg(test)]
mod tests {
    //! Layer 1: the install guard and the container path as pure functions. Nothing here installs a
    //! logger: `set_logger` in a test binary is what `test_install_sets_the_facade_to_warn` owns.

    use std::path::{Path, PathBuf};

    use super::{container_path, home_directory, should_install};
    use crate::log_writer::log_path_below;

    #[test]
    fn test_app_bundle_executable_with_container_installs() {
        let executable = Path::new("/Applications/KA-Reader.app/Contents/MacOS/KAReader");

        assert!(should_install(executable, true));
    }

    #[test]
    fn test_cargo_test_binary_does_not_install() {
        let executable = Path::new("/work/target/debug/deps/ka_reader_bridge-0123456789abcdef");

        assert!(!should_install(executable, true));
    }

    #[test]
    fn test_xctest_bundle_does_not_install() {
        let executable = Path::new(
            "/work/.build/debug/ka-reader-macPackageTests.xctest/Contents/MacOS/ka-reader-macPackageTests",
        );

        assert!(!should_install(executable, true));
    }

    #[test]
    fn test_missing_container_does_not_install() {
        let executable = Path::new("/Applications/KA-Reader.app/Contents/MacOS/KAReader");

        assert!(
            !should_install(executable, false),
            "the bridge never creates a container"
        );
    }

    #[test]
    fn test_app_path_not_under_contents_macos_does_not_install() {
        assert!(!should_install(Path::new("/x/KA-Reader.app/KAReader"), true));
    }

    #[test]
    fn test_app_path_under_contents_but_not_macos_does_not_install() {
        let executable = Path::new("/Applications/KA-Reader.app/Contents/Resources/KAReader");

        assert!(!should_install(executable, true));
    }

    #[test]
    fn test_app_path_under_macos_but_not_contents_does_not_install() {
        let executable = Path::new("/Applications/KA-Reader.app/Other/MacOS/KAReader");

        assert!(!should_install(executable, true));
    }

    #[test]
    fn test_container_path_is_c_i2s() {
        let home = Path::new("/Users/someone");

        let container = container_path(home);

        assert_eq!(
            container,
            PathBuf::from("/Users/someone/Library/Containers/com.kensaiapp.ka-reader/Data")
        );
        assert_eq!(
            log_path_below(&container),
            PathBuf::from(
                "/Users/someone/Library/Containers/com.kensaiapp.ka-reader/Data/Library/Logs/ka-reader.log"
            )
        );
    }

    #[test]
    fn test_home_directory_is_an_absolute_path_from_the_password_database() {
        let home = home_directory().expect("the current user has a password-database entry");

        assert!(home.is_absolute(), "{home:?}");
    }
}
