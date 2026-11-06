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
