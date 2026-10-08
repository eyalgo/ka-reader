//! The config search-path switch against the real libgit2 (CP-544 (a), (b); QC-17).
//!
//! The four search paths are process-global, so this file is its own test binary and its one
//! `#[test]` runs its steps in order.

use git2::ConfigLevel;
use ka_reader_bridge::machine_config::{SwitchOutcome, arrive_in_process};
use ka_reader_bridge::session::{GitAnswerDto, OpenResult, Session};

const LEVELS: [ConfigLevel; 4] = [
    ConfigLevel::System,
    ConfigLevel::Global,
    ConfigLevel::XDG,
    ConfigLevel::ProgramData,
];

const SENTINEL: &str = "/nowhere-near/the-sentinel";

fn search_path(level: ConfigLevel) -> String {
    // SAFETY: this binary holds one test, which runs its steps in sequence, so no other thread
    // touches libgit2's global state while it reads.
    let path = unsafe { git2::opts::get_search_path(level) }.expect("the search path reads back");
    path.into_string().expect("the search path is UTF-8")
}

/// Opens `folder` through `session` and asks its Git item, which must be read through a wired port.
fn open_and_read(session: &Session, folder: std::path::PathBuf) {
    assert!(matches!(session.open(folder), OpenResult::Opened));
    assert!(
        matches!(session.read_git(), GitAnswerDto::Observed(_)),
        "a production-wired session reads through the adapter"
    );
}

#[test]
fn test_the_switch_against_the_real_libgit2() {
    // Step 0: before any arrival, libgit2's global level names a place (the home folder), so the
    // step below can only read it empty if the arrival emptied it.
    assert_ne!(
        search_path(ConfigLevel::Global),
        "",
        "the global level starts non-empty"
    );

    // Step 1: the first arrival is the production session's open, as the shell makes it (CP-531:
    // the composition root runs before any Git read). After it, all four search paths read empty.
    let session = Session::default();
    open_and_read(&session, std::env::temp_dir());
    for level in LEVELS {
        assert_eq!(
            search_path(level),
            "",
            "{level:?} reads empty after the composition root ran"
        );
    }
    assert_eq!(
        arrive_in_process(),
        SwitchOutcome::Off,
        "the session's arrival was the process's switch"
    );

    // Step 2: a second arrival repeats nothing. One level is set to a sentinel, the process arrives
    // again, and that level still reads the sentinel.
    // SAFETY: as above, nothing else runs concurrently.
    unsafe { git2::opts::set_search_path(ConfigLevel::Global, SENTINEL) }
        .expect("the sentinel is set");
    assert_eq!(arrive_in_process(), SwitchOutcome::Off);
    assert_eq!(search_path(ConfigLevel::Global), SENTINEL);

    // Step 3: a second folder opened through the production-wired session is a second arrival, and
    // it repeats nothing: the level still reads the sentinel (CP-533).
    open_and_read(&session, std::env::temp_dir());
    assert_eq!(search_path(ConfigLevel::Global), SENTINEL);
}
