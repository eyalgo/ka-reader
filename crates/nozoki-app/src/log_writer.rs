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
