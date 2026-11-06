//! The containment port's contract suite (`docs/SDD.md` § 3, `fs-reader`; `docs/nfdr.md` § 9).
//!
//! One generic suite over [`ContainmentCheck`], called from two tests: one with the real adapter over
//! a folder the test makes, and one with the fake seeded to the same entries. A fake that passes the
//! suite answers as the adapter does, so a unit test handed the fake is not proving a fiction
//! (`<CORE>/doctrine/engineering/languages/rust/testing.md`, the contract-suite bullet).

#[allow(
    dead_code,
    reason = "each test crate uses a subset of the shared helpers"
)]
mod common;

use std::path::{Path, PathBuf};

use common::TempDir;
use ka_reader_core::{
    Condition, ContainedEntry, ContainmentCheck, EntryKind, FolderContainment, SeededContainment,
};

/// The folder every case asks from: the folder that holds the Markdown file.
const FOLDER: &str = "docs";

/// One reference and the answer the port gives for it from [`FOLDER`].
struct Case {
    reference: &'static str,
    answer: Result<ContainedEntry, Condition>,
}

fn reached(path: &str, kind: EntryKind) -> Result<ContainedEntry, Condition> {
    Ok(ContainedEntry {
        path: PathBuf::from(path),
        kind,
    })
}

/// The cases both runs hold. Each reference is spelled once, because the fake keys its answers by
/// reference text.
fn contract_cases() -> Vec<Case> {
    vec![
        Case {
            reference: "a.png",
            answer: reached("docs/a.png", EntryKind::File),
        },
        Case {
            reference: "img",
            answer: reached("docs/img", EntryKind::Folder),
        },
        Case {
            reference: "nothing.png",
            answer: Err(Condition::Missing),
        },
        Case {
            reference: "../../../up.png",
            answer: Err(Condition::Outside),
        },
        Case {
            reference: "out-link.png",
            answer: Err(Condition::Outside),
        },
    ]
}

fn containment_contract<C: ContainmentCheck>(make: impl Fn(&[Case]) -> C) {
    let cases = contract_cases();
    let check = make(&cases);
    for case in &cases {
        assert_eq!(
            check.check(Path::new(FOLDER), case.reference),
            case.answer,
            "the answer for the reference {:?}",
            case.reference
        );
    }
}

/// A root holding `docs/a.png`, the folder `docs/img`, a link in `docs` whose target is outside the
/// root, and a link in `docs` whose target is `docs/a.png`.
fn scene() -> (TempDir, TempDir) {
    let root = TempDir::new();
    root.write_file("docs/a.png", "bytes");
    root.make_folder("docs/img");
    let outside = TempDir::new();
    outside.write_file("secret.png", "bytes");
    root.make_link("docs/out-link.png", outside.path().join("secret.png"));
    root.make_link("docs/in-link.png", "a.png");
    (root, outside)
}

#[test]
fn test_real_containment_meets_the_contract() {
    let (root, _outside) = scene();

    containment_contract(|_| FolderContainment::new(root.path().to_path_buf()));
}

#[test]
fn test_seeded_containment_meets_the_contract() {
    containment_contract(|cases| {
        cases.iter().fold(SeededContainment::new(), |fake, case| {
            fake.seeded(case.reference, case.answer.clone())
        })
    });
}

#[test]
fn test_real_containment_answers_an_in_folder_links_resolved_target() {
    let (root, _outside) = scene();
    let check = FolderContainment::new(root.path().to_path_buf());

    assert_eq!(
        check.check(Path::new(FOLDER), "in-link.png"),
        reached("docs/a.png", EntryKind::File)
    );
}
