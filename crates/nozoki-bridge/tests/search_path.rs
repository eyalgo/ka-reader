//! The config search-path switch against the real libgit2 (CP-544 (a), (b); QC-17).
//!
//! The four search paths are process-global, so this file is its own test binary and its one
//! `#[test]` runs its steps in order.

use git2::ConfigLevel;
use nozoki_bridge::machine_config::{SwitchOutcome, arrive_in_process};

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

#[test]
fn test_the_switch_against_the_real_libgit2() {
    // Step 1: after the first arrival, all four search paths read empty.
    assert_eq!(arrive_in_process(), SwitchOutcome::Off);
    for level in LEVELS {
        assert_eq!(
            search_path(level),
            "",
            "{level:?} reads empty after the switch"
        );
    }

    // Step 2: a second arrival repeats nothing. One level is set to a sentinel, the process arrives
    // again, and that level still reads the sentinel.
    // SAFETY: as above, nothing else runs concurrently.
    unsafe { git2::opts::set_search_path(ConfigLevel::Global, SENTINEL) }
        .expect("the sentinel is set");
    assert_eq!(arrive_in_process(), SwitchOutcome::Off);
    assert_eq!(search_path(ConfigLevel::Global), SENTINEL);
}
