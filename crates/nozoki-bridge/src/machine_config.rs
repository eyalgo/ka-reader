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

        assert_eq!(run_switch(|level| recorder.set(level)), SwitchOutcome::Failed);
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
