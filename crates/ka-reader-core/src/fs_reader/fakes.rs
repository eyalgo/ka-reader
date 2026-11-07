//! The fake for the containment port. It does no I/O and names no filesystem primitive: it answers
//! what a test seeded, and records what it was asked, so it is the stub and the spy in one.

use std::cell::RefCell;
use std::collections::HashMap;
use std::path::{Path, PathBuf};

use super::{Condition, ContainedEntry, ContainmentCheck};

/// A [`ContainmentCheck`] that answers what a test seeded for a reference text, and answers
/// [`Condition::Missing`] for any other. It records every (folder, reference) pair it is asked, in
/// order, for the test to read through [`SeededContainment::asked`].
///
/// # Examples
///
/// ```
/// use std::path::Path;
///
/// use ka_reader_core::{Condition, ContainmentCheck, SeededContainment};
///
/// let fake = SeededContainment::new();
/// assert_eq!(fake.check(Path::new("docs"), "a.png"), Err(Condition::Missing));
/// assert_eq!(fake.asked().len(), 1);
/// ```
#[derive(Debug, Default)]
pub struct SeededContainment {
    answers: HashMap<String, Result<ContainedEntry, Condition>>,
    asked: RefCell<Vec<(PathBuf, String)>>,
}

impl SeededContainment {
    pub fn new() -> Self {
        Self::default()
    }

    /// The same fake, answering `answer` whenever it is asked for `reference`.
    #[must_use]
    pub fn seeded(mut self, reference: &str, answer: Result<ContainedEntry, Condition>) -> Self {
        self.answers.insert(reference.to_string(), answer);
        self
    }

    /// Every (folder, reference) pair asked so far, oldest first.
    pub fn asked(&self) -> Vec<(PathBuf, String)> {
        self.asked.borrow().clone()
    }
}

impl ContainmentCheck for SeededContainment {
    fn check(&self, folder: &Path, reference: &str) -> Result<ContainedEntry, Condition> {
        self.asked
            .borrow_mut()
            .push((folder.to_path_buf(), reference.to_string()));
        self.answers
            .get(reference)
            .cloned()
            .unwrap_or(Err(Condition::Missing))
    }
}

#[cfg(test)]
mod tests {
    use std::path::{Path, PathBuf};

    use super::SeededContainment;
    use crate::fs_reader::{Condition, ContainedEntry, ContainmentCheck, EntryKind};

    #[test]
    fn test_seeded_containment_answers_missing_for_an_unseeded_reference() {
        let fake = SeededContainment::new();

        assert_eq!(
            fake.check(Path::new("docs"), "never-seeded.png"),
            Err(Condition::Missing)
        );
    }

    #[test]
    fn test_seeded_containment_answers_what_was_seeded_for_a_reference() {
        let entry = ContainedEntry {
            path: PathBuf::from("docs/a.png"),
            kind: EntryKind::File,
        };
        let fake = SeededContainment::new().seeded("a.png", Ok(entry.clone()));

        assert_eq!(fake.check(Path::new("docs"), "a.png"), Ok(entry));
    }

    #[test]
    fn test_seeded_containment_records_every_pair_asked_in_order() {
        let fake = SeededContainment::new();

        let _ = fake.check(Path::new("docs"), "first.png");
        let _ = fake.check(Path::new(""), "second.png");

        assert_eq!(
            fake.asked(),
            vec![
                (PathBuf::from("docs"), "first.png".to_string()),
                (PathBuf::new(), "second.png".to_string()),
            ]
        );
    }
}
