//! CP-30 and C-I2 for the Git item: an item that becomes failed emits exactly one `warn` record
//! naming `git-reader` and the operation, never the path the condition carries; an item that
//! stands emits none.
//!
//! `log` has one global logger per process, so this is the only test in its binary.

#[allow(
    dead_code,
    reason = "each test crate uses a subset of the shared helpers"
)]
mod common;

use std::path::{Path, PathBuf};
use std::sync::Mutex;

use common::TempDir;
use log::{LevelFilter, Log, Metadata, Record};
use nozoki_core::{
    BranchElement, FolderModel, GitPort, GitReadCondition, HeadState, RepositoryState, RootFinding,
    StatusLists, open_folder, read_git,
};

struct Capture {
    records: Mutex<Vec<(log::Level, String)>>,
}

impl Log for Capture {
    fn enabled(&self, _metadata: &Metadata<'_>) -> bool {
        true
    }

    fn log(&self, record: &Record<'_>) {
        self.records
            .lock()
            .expect("the capture lock is not poisoned")
            .push((record.level(), record.args().to_string()));
    }

    fn flush(&self) {}
}

static CAPTURE: Capture = Capture {
    records: Mutex::new(Vec::new()),
};

fn take_records() -> Vec<(log::Level, String)> {
    std::mem::take(
        &mut *CAPTURE
            .records
            .lock()
            .expect("the capture lock is not poisoned"),
    )
}

struct Double {
    head: Result<HeadState, GitReadCondition>,
}

impl GitPort for Double {
    fn probe(&self, _folder: &Path) -> RootFinding {
        RootFinding::Root
    }

    fn state(&self, _root: &Path) -> Result<HeadState, GitReadCondition> {
        self.head.clone()
    }

    fn status(&self, _root: &Path) -> Result<StatusLists, GitReadCondition> {
        panic!("the reducer step never asks status");
    }
}

#[test]
fn test_failed_git_item_logs_one_warn_without_the_path() {
    log::set_logger(&CAPTURE).expect("no other logger is installed in this binary");
    log::set_max_level(LevelFilter::Warn);
    let scene = TempDir::new();
    scene.write_file("a.txt", "a");
    let opened = open_folder(scene.path()).expect("the scene opens");
    let outside = PathBuf::from("/nowhere-near/the-folder/.git");
    let standing = Double {
        head: Ok(HeadState {
            branch: BranchElement::Branch("main".to_string()),
            state: RepositoryState::Normal,
        }),
    };
    let failing = Double {
        head: Err(GitReadCondition::GitDirectoryOutside(outside.clone())),
    };

    let _ = read_git(FolderModel::new(opened.clone()), &standing);
    assert!(
        take_records().is_empty(),
        "an item that stands emits nothing"
    );

    let _ = read_git(FolderModel::new(opened), &failing);
    let records = take_records();
    assert_eq!(records.len(), 1, "one record: {records:?}");
    let (level, text) = &records[0];
    assert_eq!(*level, log::Level::Warn);
    assert!(text.contains("git-reader"), "{text}");
    assert!(text.contains("state"), "{text}");
    assert!(
        !text.contains(outside.to_str().expect("the path is UTF-8")),
        "the record holds the path: {text}"
    );
}
