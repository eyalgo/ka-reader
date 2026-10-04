//! The composition root's config search-path switch (SDD § 3 `core-bridge`; QC-17).
//!
//! libgit2 reads four machine-level config files, and a repository must never be opened with them
//! on. This module sets each of the four search paths to empty, once per process, and fails closed:
//! the libgit2 adapter is handed out only behind an outcome of [`SwitchOutcome::Off`]. It is the only
//! bridge source that names `git2` (QC-11; CP-534).

use std::fmt;
use std::sync::{Arc, OnceLock};

use nozoki_core::{GitPort, Libgit2};

/// The four machine-level config levels, named by the bridge. This module alone maps them to the
/// libgit2 binding's own type.
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum Level {
    System,
    Global,
    Xdg,
    ProgramData,
}

/// Every level the switch empties.
pub const LEVELS: [Level; 4] = [Level::System, Level::Global, Level::Xdg, Level::ProgramData];

/// A setter's refusal. It carries nothing, so no path and no library text can travel with it.
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub struct SetterFailure;

/// How a run of the switch ended.
///
/// # Examples
///
/// ```
/// use nozoki_bridge::machine_config::{SetterFailure, SwitchOutcome, run_switch};
///
/// assert_eq!(run_switch(|_level| Ok(())), SwitchOutcome::Off);
/// assert_eq!(run_switch(|_level| Err(SetterFailure)), SwitchOutcome::Failed);
/// ```
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum SwitchOutcome {
    /// All four levels read empty: the machine-level config is off.
    Off,
    /// A level could not be emptied. The machine-level config may still be on.
    Failed,
}

impl fmt::Display for SwitchOutcome {
    fn fmt(&self, formatter: &mut fmt::Formatter<'_>) -> fmt::Result {
        formatter.write_str(match self {
            Self::Off => "the machine-level config is off",
            Self::Failed => "the machine-level config could not be switched off",
        })
    }
}

/// Runs the switch once over `set`, which empties one level's search path. The outcome is `Off` only
/// when all four calls succeed, and `Failed` at the first that does not; the rest are not tried.
pub fn run_switch<S>(set: S) -> SwitchOutcome
where
    S: Fn(Level) -> Result<(), SetterFailure>,
{
    for level in LEVELS {
        if set(level).is_err() {
            return SwitchOutcome::Failed;
        }
    }
    SwitchOutcome::Off
}

/// A switch that runs on its first arrival and answers every later one with that first outcome,
/// calling its setter zero times, whatever the outcome was (CP-533).
///
/// # Examples
///
/// ```
/// use nozoki_bridge::machine_config::{SwitchGuard, SwitchOutcome};
///
/// let guard = SwitchGuard::new(|_level| Ok(()));
/// assert_eq!(guard.arrive(), SwitchOutcome::Off);
/// assert_eq!(guard.arrive(), SwitchOutcome::Off);
/// ```
pub struct SwitchGuard<S> {
    set: S,
    outcome: OnceLock<SwitchOutcome>,
}

impl<S> SwitchGuard<S>
where
    S: Fn(Level) -> Result<(), SetterFailure>,
{
    pub const fn new(set: S) -> Self {
        Self {
            set,
            outcome: OnceLock::new(),
        }
    }

    /// Runs the switch if no arrival has, and returns the outcome of the first run. Concurrent first
    /// arrivals block on the one initializer, so the run is never concurrent with itself.
    pub fn arrive(&self) -> SwitchOutcome {
        *self.outcome.get_or_init(|| run_switch(&self.set))
    }
}

/// The libgit2 binding's name for `level`. The only place the two types meet.
fn binding_level(level: Level) -> git2::ConfigLevel {
    match level {
        Level::System => git2::ConfigLevel::System,
        Level::Global => git2::ConfigLevel::Global,
        Level::Xdg => git2::ConfigLevel::XDG,
        Level::ProgramData => git2::ConfigLevel::ProgramData,
    }
}

/// Empties `level`'s search path in libgit2.
fn empty_in_libgit2(level: Level) -> Result<(), SetterFailure> {
    // SAFETY: `set_search_path` "needs to be externally synchronized with calls to access the global
    // state" (git2-0.21.0 `opts.rs`). This function is reached only through `PROCESS`, whose
    // `OnceLock` runs it once, and no libgit2 handle exists before that arrival completes.
    unsafe { git2::opts::set_search_path(binding_level(level), "") }.map_err(|_| SetterFailure)
}

type LibgitSetter = fn(Level) -> Result<(), SetterFailure>;

/// The process's one switch, wired to libgit2.
static PROCESS: SwitchGuard<LibgitSetter> = SwitchGuard::new(empty_in_libgit2);

/// Arrives at the process's switch: the first call empties the four libgit2 search paths, every later
/// call returns that outcome and sets nothing.
pub fn arrive_in_process() -> SwitchOutcome {
    PROCESS.arrive()
}

/// The production Git port, the libgit2 adapter. It is made here, beside the switch, because this is
/// the one module whose source may name the binding (CP-534), and only the session's production
/// arrival calls it, behind an `Off` outcome (QC-17).
pub fn production_port() -> Arc<dyn GitPort + Send + Sync> {
    Arc::new(Libgit2)
}

#[cfg(test)]
mod tests {
    use std::sync::Mutex;
    use std::sync::atomic::{AtomicUsize, Ordering};

    use super::{LEVELS, Level, SetterFailure, SwitchGuard, SwitchOutcome, run_switch};

    /// A setter double that records every level it was asked for and errs at `failing`.
    struct Recorder {
        calls: Mutex<Vec<Level>>,
        failing: Option<Level>,
    }

    impl Recorder {
        fn new(failing: Option<Level>) -> Self {
            Self {
                calls: Mutex::new(Vec::new()),
                failing,
            }
        }

        fn set(&self, level: Level) -> Result<(), SetterFailure> {
            self.calls
                .lock()
                .expect("the recorder lock is not poisoned")
                .push(level);
            if self.failing == Some(level) {
                Err(SetterFailure)
            } else {
                Ok(())
            }
        }

        fn calls(&self) -> Vec<Level> {
            self.calls
                .lock()
                .expect("the recorder lock is not poisoned")
                .clone()
        }
    }

    #[test]
    fn test_all_four_levels_succeeding_is_off_and_sets_each_level_once() {
        let recorder = Recorder::new(None);

        let outcome = run_switch(|level| recorder.set(level));

        assert_eq!(outcome, SwitchOutcome::Off);
        let mut calls = recorder.calls();
        assert_eq!(calls.len(), 4);
        calls.sort_by_key(|level| format!("{level:?}"));
        let mut expected = LEVELS.to_vec();
        expected.sort_by_key(|level| format!("{level:?}"));
        assert_eq!(calls, expected);
        assert_eq!(
            expected,
            vec![Level::Global, Level::ProgramData, Level::System, Level::Xdg]
        );
    }

    #[test]
    fn test_one_level_erring_is_failed() {
        let recorder = Recorder::new(Some(Level::Xdg));

        assert_eq!(
            run_switch(|level| recorder.set(level)),
            SwitchOutcome::Failed
        );
    }

    #[test]
    fn test_any_one_of_the_four_erring_is_failed() {
        for erring in LEVELS {
            let recorder = Recorder::new(Some(erring));

            let outcome = run_switch(|level| recorder.set(level));

            assert_eq!(outcome, SwitchOutcome::Failed, "{erring:?} erring");
        }
    }

    #[test]
    fn test_failed_outcome_carries_no_path_and_no_library_text() {
        let debug = format!("{:?}", SwitchOutcome::Failed);
        let display = SwitchOutcome::Failed.to_string();

        for text in [debug, display] {
            assert!(!text.contains('/'), "{text}");
            assert!(!text.contains("git"), "{text}");
            assert!(!text.contains("libgit2"), "{text}");
        }
    }

    #[test]
    fn test_second_arrival_after_off_calls_the_setter_zero_times() {
        let recorder = Recorder::new(None);
        let guard = SwitchGuard::new(|level| recorder.set(level));
        assert_eq!(guard.arrive(), SwitchOutcome::Off);
        let after_first = recorder.calls().len();

        let second = guard.arrive();

        assert_eq!(second, SwitchOutcome::Off);
        assert_eq!(recorder.calls().len(), after_first);
    }

    #[test]
    fn test_second_arrival_after_failed_calls_the_setter_zero_times() {
        let recorder = Recorder::new(Some(Level::Global));
        let guard = SwitchGuard::new(|level| recorder.set(level));
        assert_eq!(guard.arrive(), SwitchOutcome::Failed);
        let after_first = recorder.calls().len();

        let second = guard.arrive();

        assert_eq!(second, SwitchOutcome::Failed, "no retry");
        assert_eq!(recorder.calls().len(), after_first);
    }

    #[test]
    fn test_concurrent_first_arrivals_run_the_setter_four_times_in_total() {
        let count = AtomicUsize::new(0);
        let guard = SwitchGuard::new(|_level| {
            count.fetch_add(1, Ordering::SeqCst);
            Ok(())
        });

        let outcomes: Vec<SwitchOutcome> = std::thread::scope(|scope| {
            let first = scope.spawn(|| guard.arrive());
            let second = scope.spawn(|| guard.arrive());
            vec![
                first.join().expect("the first arrival returns"),
                second.join().expect("the second arrival returns"),
            ]
        });

        assert_eq!(outcomes, vec![SwitchOutcome::Off, SwitchOutcome::Off]);
        assert_eq!(count.load(Ordering::SeqCst), 4);
    }
}
