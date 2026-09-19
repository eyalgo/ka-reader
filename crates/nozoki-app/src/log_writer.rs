//! C-I2's log writer: `nozoki-app`'s own `log::Log`, the only place in the crate that touches the
//! filesystem or names the container path.
//!
//! It admits a record only when it comes from `nozoki-core` at `warn` or above, writes it as one
//! line, and keeps the file inside a byte bound. Every failure to open, write or truncate is
//! swallowed: no retry, no panic, and nothing the user could see (CP-32).

use std::fs::{self, OpenOptions};
use std::io::Write;
use std::path::{Path, PathBuf};
use std::sync::{Mutex, OnceLock, PoisonError};

use log::{Level, LevelFilter, Log, Metadata, Record, SetLoggerError};

/// Where the log lives below the home directory. The sandbox container's own `Data` folder is the
/// home directory of a sandboxed process, so this is C-I2's path once the host passes it.
const LOG_PATH_BELOW_HOME: &str = "Library/Logs/nozoki.log";

/// The log's size bound in production: 1 MiB.
pub const PRODUCTION_BOUND_BYTES: u64 = 1_048_576;

/// The installed writer. `log::set_logger` wants a `&'static dyn Log`, and `set_boxed_logger` is
/// behind `log`'s `alloc` feature, which this build does not enable.
static INSTALLED: OnceLock<FileLog> = OnceLock::new();

/// The module path the crate's records carry, in the underscore spelling Rust gives the crate.
const CORE_MODULE: &str = "nozoki_core";

/// A `log::Log` that appends admitted records to one file, emptying it when a line would pass the
/// bound.
///
/// # Examples
///
/// ```
/// use log::{Level, Log, Record};
/// use nozoki_app::log_writer::FileLog;
///
/// let folder = std::env::temp_dir().join("nozoki-app-doctest-file-log");
/// let path = folder.join("nozoki.log");
/// let writer = FileLog::new(path.clone(), 1024);
///
/// writer.log(
///     &Record::builder()
///         .args(format_args!("fs-reader: list failed: Permission denied"))
///         .level(Level::Warn)
///         .module_path(Some("nozoki_core::fs_reader"))
///         .build(),
/// );
///
/// let written = std::fs::read_to_string(&path).expect("the log can be read");
/// assert!(written.contains("Permission denied"));
/// std::fs::remove_dir_all(&folder).expect("the folder can be removed");
/// ```
pub struct FileLog {
    path: PathBuf,
    bound: u64,
    /// Bytes in the file, kept here so the bound check needs no stat per line.
    written: Mutex<u64>,
}

impl FileLog {
    /// Creates the parent directory if it is missing, then creates or empties the file.
    pub fn new(path: PathBuf, bound: u64) -> Self {
        if let Some(parent) = path.parent() {
            // A failure is swallowed by design (CP-32): a log that cannot be opened is a log that
            // is not written, and the next record tries again on its own.
            fs::create_dir_all(parent).ok();
        }
        fs::File::create(&path).ok();
        Self {
            path,
            bound,
            written: Mutex::new(0),
        }
    }

    /// One admitted record as one line, clipped so the line and its newline fit the bound.
    fn line_for(&self, record: &Record<'_>) -> String {
        let flattened = format!("{} {}", record.level(), record.args()).replace(['\n', '\r'], " ");
        let room = usize::try_from(self.bound.saturating_sub(1)).unwrap_or(usize::MAX);
        let mut line = clip_to_char_boundary(&flattened, room).to_string();
        line.push('\n');
        line
    }

    fn append(&self, line: &str) {
        let mut written = self.written.lock().unwrap_or_else(PoisonError::into_inner);
        let length = u64::try_from(line.len()).unwrap_or(u64::MAX);
        let crosses_bound = *written + length > self.bound;
        let mut options = OpenOptions::new();
        options.create(true);
        if crosses_bound {
            options.write(true).truncate(true);
        } else {
            options.append(true);
        }
        let Ok(mut file) = options.open(&self.path) else {
            return;
        };
        if crosses_bound {
            *written = 0;
        }
        if file.write_all(line.as_bytes()).is_ok() {
            *written += length;
        }
    }
}

impl Log for FileLog {
    fn enabled(&self, metadata: &Metadata<'_>) -> bool {
        metadata.level() <= Level::Warn
    }

    fn log(&self, record: &Record<'_>) {
        if self.enabled(record.metadata()) && comes_from_core(record.module_path()) {
            self.append(&self.line_for(record));
        }
    }

    fn flush(&self) {}
}

/// Installs the writer as the process's logger, at `warn`, on the log path below `home`.
///
/// `log`'s maximum level starts at `Off`, so a logger installed without raising it receives
/// nothing from the macros. The level is fixed here and read from nothing.
///
/// # Examples
///
/// ```
/// let home = std::env::temp_dir().join("nozoki-app-doctest-home");
///
/// nozoki_app::log_writer::install(&home).expect("no other logger is installed");
///
/// assert_eq!(log::max_level(), log::LevelFilter::Warn);
/// assert!(home.join("Library/Logs/nozoki.log").is_file());
/// std::fs::remove_dir_all(&home).expect("the folder can be removed");
/// ```
pub fn install(home: &Path) -> Result<(), SetLoggerError> {
    let writer = INSTALLED
        .get_or_init(|| FileLog::new(home.join(LOG_PATH_BELOW_HOME), PRODUCTION_BOUND_BYTES));
    log::set_logger(writer)?;
    log::set_max_level(LevelFilter::Warn);
    Ok(())
}

/// Whether `module_path` is the core crate or lies inside it. A bare prefix test would also admit
/// a crate named `nozoki_core_x`.
fn comes_from_core(module_path: Option<&str>) -> bool {
    module_path.is_some_and(|module| {
        module == CORE_MODULE || module.starts_with(&format!("{CORE_MODULE}::"))
    })
}

fn clip_to_char_boundary(text: &str, max_bytes: usize) -> &str {
    let mut end = max_bytes.min(text.len());
    while !text.is_char_boundary(end) {
        end -= 1;
    }
    &text[..end]
}

#[cfg(test)]
mod tests {
    //! Layer 1: C-I2's writer over temporary directories. Each test builds its own writer; only
    //! `test_install_sets_the_facade_to_warn` installs a global logger, so no other test in this
    //! binary may.

    use std::fs;
    use std::path::Path;

    use log::{Level, LevelFilter, Log, Record};

    use super::{FileLog, PRODUCTION_BOUND_BYTES, install};
    use crate::test_support::TempDir;

    const ROOMY_BOUND: u64 = 1_048_576;

    fn record(writer: &FileLog, level: Level, module: &str, message: &str) {
        writer.log(
            &Record::builder()
                .args(format_args!("{message}"))
                .level(level)
                .module_path(Some(module))
                .build(),
        );
    }

    fn core_warn(writer: &FileLog, message: &str) {
        record(writer, Level::Warn, "nozoki_core::fs_reader", message);
    }

    fn contents(path: &Path) -> String {
        fs::read_to_string(path).expect("the log file can be read")
    }

    #[test]
    fn test_install_truncates_an_existing_file() {
        let folder = TempDir::new();
        let path = folder.path().join("nozoki.log");
        fs::write(&path, "left over from the last session\n").expect("the file can be written");

        let _writer = FileLog::new(path.clone(), ROOMY_BOUND);

        assert_eq!(contents(&path), "");
    }

    #[test]
    fn test_install_creates_missing_parent_and_file() {
        let folder = TempDir::new();
        let path = folder.path().join("Library/Logs/nozoki.log");

        let _writer = FileLog::new(path.clone(), ROOMY_BOUND);

        assert!(path.is_file());
    }

    #[test]
    fn test_core_warn_record_writes_one_line() {
        let folder = TempDir::new();
        let path = folder.path().join("nozoki.log");
        let writer = FileLog::new(path.clone(), ROOMY_BOUND);

        core_warn(&writer, "fs-reader: list failed: Permission denied");

        let written = contents(&path);
        assert_eq!(written.lines().count(), 1, "{written:?}");
        assert!(written.contains("fs-reader: list failed: Permission denied"));
        assert!(written.ends_with('\n'));
    }

    #[test]
    fn test_record_with_line_break_is_one_line() {
        let folder = TempDir::new();
        let path = folder.path().join("nozoki.log");
        let writer = FileLog::new(path.clone(), ROOMY_BOUND);

        core_warn(&writer, "first half\nsecond half\r\nthird");

        let written = contents(&path);
        assert_eq!(written.lines().count(), 1, "{written:?}");
        assert!(written.contains("first half"));
        assert!(written.contains("third"));
    }

    #[test]
    fn test_foreign_module_record_writes_nothing() {
        let folder = TempDir::new();
        let path = folder.path().join("nozoki.log");
        let writer = FileLog::new(path.clone(), ROOMY_BOUND);

        for module in ["tauri::app", "rfd::backend", "nozoki_core_x"] {
            record(&writer, Level::Warn, module, "not ours");
        }

        assert_eq!(contents(&path), "");
    }

    #[test]
    fn test_below_warn_writes_nothing() {
        let folder = TempDir::new();
        let path = folder.path().join("nozoki.log");
        let writer = FileLog::new(path.clone(), ROOMY_BOUND);

        record(
            &writer,
            Level::Info,
            "nozoki_core::fs_reader",
            "just so you know",
        );

        assert_eq!(contents(&path), "");
    }

    /// The size of the file after one record of `message`, so a test can pick a bound in whole lines.
    fn one_line_bytes(message: &str) -> u64 {
        let folder = TempDir::new();
        let path = folder.path().join("probe.log");
        let writer = FileLog::new(path.clone(), ROOMY_BOUND);
        core_warn(&writer, message);
        fs::metadata(&path).expect("the probe file exists").len()
    }

    #[test]
    fn test_line_crossing_bound_empties_file_first() {
        let line = one_line_bytes("aaaa-1");
        let folder = TempDir::new();
        let path = folder.path().join("nozoki.log");
        let writer = FileLog::new(path.clone(), 2 * line);

        core_warn(&writer, "aaaa-1");
        core_warn(&writer, "aaaa-2");
        assert!(
            contents(&path).contains("aaaa-1"),
            "two lines fit the bound"
        );
        core_warn(&writer, "aaaa-3");

        let written = contents(&path);
        assert!(written.contains("aaaa-3"), "{written:?}");
        assert!(!written.contains("aaaa-1"), "{written:?}");
        assert!(!written.contains("aaaa-2"), "{written:?}");
        assert!(fs::metadata(&path).expect("the file exists").len() <= 2 * line);
    }

    #[test]
    fn test_lines_after_a_truncation_append_until_the_bound_again() {
        let line = one_line_bytes("aaaa-1");
        let folder = TempDir::new();
        let path = folder.path().join("nozoki.log");
        let writer = FileLog::new(path.clone(), 2 * line);

        for message in ["aaaa-1", "aaaa-2", "aaaa-3", "aaaa-4"] {
            core_warn(&writer, message);
        }

        let written = contents(&path);
        assert!(written.contains("aaaa-3"), "{written:?}");
        assert!(written.contains("aaaa-4"), "{written:?}");
        assert_eq!(
            fs::metadata(&path).expect("the file exists").len(),
            2 * line
        );
    }

    #[test]
    fn test_overlong_line_is_clipped_to_bound() {
        let folder = TempDir::new();
        let path = folder.path().join("nozoki.log");
        let writer = FileLog::new(path.clone(), 40);

        core_warn(&writer, &"x".repeat(500));

        assert_eq!(fs::metadata(&path).expect("the file exists").len(), 40);
    }

    #[test]
    fn test_production_bound_is_one_mebibyte() {
        assert_eq!(PRODUCTION_BOUND_BYTES, 1_048_576);
    }

    #[test]
    fn test_unwritable_directory_is_silent_and_not_retried() {
        let folder = TempDir::new();
        folder.make_folder("sealed");
        folder.set_mode("sealed", 0o000);
        let path = folder.path().join("sealed/nozoki.log");

        let writer = FileLog::new(path.clone(), ROOMY_BOUND);
        core_warn(&writer, "dropped while the directory is sealed");
        folder.set_mode("sealed", 0o700);
        assert!(!path.exists() || contents(&path).is_empty());
        core_warn(&writer, "written once the directory opens");

        let written = contents(&path);
        assert!(
            written.contains("written once the directory opens"),
            "{written:?}"
        );
        assert!(!written.contains("dropped while"), "{written:?}");
    }

    #[test]
    fn test_install_sets_the_facade_to_warn() {
        let folder = TempDir::new();

        install(folder.path()).expect("no other logger is installed in this binary");

        assert_eq!(log::max_level(), LevelFilter::Warn);
        assert!(folder.path().join("Library/Logs/nozoki.log").is_file());
    }
}
