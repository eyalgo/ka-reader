//! The one process-global writer-install assertion lives in its own test binary.

#[allow(
    dead_code,
    reason = "the shared helper offers more than this test needs"
)]
mod common;

use common::TempDir;

#[test]
fn test_install_sets_the_facade_to_warn() {
    let folder = TempDir::new();

    ka_reader_bridge::log_writer::install(folder.path())
        .expect("no other logger is installed in this binary");

    assert_eq!(log::max_level(), log::LevelFilter::Warn);
    assert!(folder.path().join("Library/Logs/ka-reader.log").is_file());
}
