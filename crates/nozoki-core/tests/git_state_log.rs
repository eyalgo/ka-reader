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
    BranchElement, ConfigNamedPath, FolderModel, GitPort, GitReadCondition, HeadState,
    ProbeCondition, RepositoryState, RootFinding, StatusLists, open_folder, read_git,
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
    probe: RootFinding,
    head: Result<HeadState, GitReadCondition>,
    lists: Result<StatusLists, GitReadCondition>,
}

impl GitPort for Double {
    fn probe(&self, _folder: &Path) -> RootFinding {
        self.probe.clone()
    }

    fn state(&self, _root: &Path) -> Result<HeadState, GitReadCondition> {
        self.head.clone()
    }

    fn status(&self, _root: &Path) -> Result<StatusLists, GitReadCondition> {
        self.lists.clone()
    }
}

fn clean_lists() -> StatusLists {
    StatusLists {
        staged: vec![],
        changed: vec![],
    }
}

fn standing_head() -> HeadState {
    HeadState {
        branch: BranchElement::Branch("main".to_string()),
        state: RepositoryState::Normal,
    }
}

/// `log` has one global logger per process, so both cases run in one test, in this order.
#[test]
fn test_failed_git_item_logs_one_warn_without_the_path() {
    log::set_logger(&CAPTURE).expect("no other logger is installed in this binary");
    log::set_max_level(LevelFilter::Warn);
    let scene = TempDir::new();
    scene.write_file("a.txt", "a");
    let opened = open_folder(scene.path()).expect("the scene opens");
    let outside = PathBuf::from("/nowhere-near/the-folder/.git");
    let standing = Double {
        probe: RootFinding::Root,
        head: Ok(HeadState {
            branch: BranchElement::Branch("main".to_string()),
            state: RepositoryState::Normal,
        }),
        lists: Ok(clean_lists()),
    };
    let failing = Double {
        probe: RootFinding::Root,
        head: Err(GitReadCondition::GitDirectoryOutside(outside.clone())),
        lists: Ok(clean_lists()),
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

    status_failure_logs_one_warn_naming_git_reader_and_status();
    test_failed_git_item_with_the_config_condition_logs_one_warn_without_the_path();
    test_failed_git_item_with_the_not_located_condition_logs_one_warn_without_the_path();
    test_failed_git_item_with_the_alternates_condition_logs_one_warn_without_the_path_or_entry();
    test_failed_git_item_with_the_object_store_not_located_condition_logs_one_warn_without_the_entry(
    );
}

/// Run inside the one test above: a status failure names `status` and not `state`.
fn status_failure_logs_one_warn_naming_git_reader_and_status() {
    let scene = TempDir::new();
    scene.write_file("a.txt", "a");
    let opened = open_folder(scene.path()).expect("the scene opens");
    let failing = Double {
        probe: RootFinding::Root,
        head: Ok(standing_head()),
        lists: Err(GitReadCondition::RepositoryReadFailed),
    };

    let _ = read_git(FolderModel::new(opened), &failing);

    let records = take_records();
    assert_eq!(records.len(), 1, "one record: {records:?}");
    let (level, text) = &records[0];
    assert_eq!(*level, log::Level::Warn);
    assert!(text.contains("git-reader"), "{text}");
    assert!(text.contains("status"), "{text}");
    assert!(!text.contains("state"), "{text}");
    assert!(!text.contains('/'), "the record holds a path: {text}");
}

/// The phrase the config condition is logged under, under both the probe's arm and the read's.
const CONFIG_PHRASE: &str = "the config names a path outside the folder";

/// Run inside the one test above: the config condition, met by the probe and by the state read,
/// logs one `warn` naming `git-reader`, the operation and the fixed phrase, and never the key or
/// the path it carries.
fn test_failed_git_item_with_the_config_condition_logs_one_warn_without_the_path() {
    let named = ConfigNamedPath {
        key: "include.path".to_string(),
        path: "../../outside.config".to_string(),
    };
    let met_by_the_probe = Double {
        probe: RootFinding::Failed(ProbeCondition::ConfigNamesOutside(named.clone())),
        head: Ok(standing_head()),
        lists: Ok(clean_lists()),
    };
    let met_by_the_state_read = Double {
        probe: RootFinding::Root,
        head: Err(GitReadCondition::ConfigNamesOutside(named.clone())),
        lists: Ok(clean_lists()),
    };

    for (double, operation) in [
        (met_by_the_probe, "probe"),
        (met_by_the_state_read, "state"),
    ] {
        let scene = TempDir::new();
        scene.write_file("a.txt", "a");
        let opened = open_folder(scene.path()).expect("the scene opens");

        let _ = read_git(FolderModel::new(opened), &double);

        let records = take_records();
        assert_eq!(records.len(), 1, "one record: {records:?}");
        let (level, text) = &records[0];
        assert_eq!(*level, log::Level::Warn);
        assert!(text.contains("git-reader"), "{text}");
        assert!(text.contains(operation), "{operation}: {text}");
        assert!(text.contains(CONFIG_PHRASE), "{text}");
        assert!(!text.contains('/'), "the record holds a path: {text}");
        assert!(
            !text.contains(&named.key),
            "the record holds the key: {text}"
        );
        assert!(
            !text.contains(&named.path),
            "the record holds the path: {text}"
        );
    }
}

/// Run inside the one test above: the not-located condition, met by the probe, by the state read
/// and by the status read, logs one `warn` naming `git-reader` and the operation under a fixed
/// phrase that says nothing of *outside*, holds no key and no path, and is not the config-outside
/// phrase.
fn test_failed_git_item_with_the_not_located_condition_logs_one_warn_without_the_path() {
    let named = ConfigNamedPath {
        key: "core.excludesfile".to_string(),
        path: "ignore-rel".to_string(),
    };
    let met_by_the_probe = Double {
        probe: RootFinding::Failed(ProbeCondition::ConfigNotLocated(named.clone())),
        head: Ok(standing_head()),
        lists: Ok(clean_lists()),
    };
    let met_by_the_state_read = Double {
        probe: RootFinding::Root,
        head: Err(GitReadCondition::ConfigNotLocated(named.clone())),
        lists: Ok(clean_lists()),
    };
    // A verified submodule's not-located value is met by the status read alone (CP-687).
    let met_by_the_status_read = Double {
        probe: RootFinding::Root,
        head: Ok(standing_head()),
        lists: Err(GitReadCondition::ConfigNotLocated(named.clone())),
    };

    for (double, operation) in [
        (met_by_the_probe, "probe"),
        (met_by_the_state_read, "state"),
        (met_by_the_status_read, "status"),
    ] {
        let scene = TempDir::new();
        scene.write_file("a.txt", "a");
        let opened = open_folder(scene.path()).expect("the scene opens");

        let _ = read_git(FolderModel::new(opened), &double);

        let records = take_records();
        assert_eq!(records.len(), 1, "one record: {records:?}");
        let (level, text) = &records[0];
        assert_eq!(*level, log::Level::Warn);
        assert!(text.contains("git-reader"), "{text}");
        assert!(text.contains(operation), "{operation}: {text}");
        assert!(text.contains(NOT_LOCATED_PHRASE), "{text}");
        assert!(!text.contains(CONFIG_PHRASE), "{text}");
        assert!(!text.to_lowercase().contains("outside"), "{text}");
        assert!(!text.contains('/'), "the record holds a path: {text}");
        assert!(
            !text.contains(&named.key),
            "the record holds the key: {text}"
        );
        assert!(
            !text.contains(&named.path),
            "the record holds the path: {text}"
        );
    }
}

/// The phrase the not-located condition is logged under, under both the probe's arm and the read's.
const NOT_LOCATED_PHRASE: &str = "the config names a path the reader does not locate";

/// The phrase the alternates condition is logged under, under both the probe's arm and the read's.
const ALTERNATES_PHRASE: &str = "the object store names a location outside the folder";

/// Run inside the one test above: the alternates condition, met by the probe and by the state read,
/// logs one `warn` naming `git-reader`, the operation and the fixed phrase, never the entry it
/// carries, and a phrase other than the config one (E17).
fn test_failed_git_item_with_the_alternates_condition_logs_one_warn_without_the_path_or_entry() {
    let entry = "../../../elsewhere/objects".to_string();
    let met_by_the_probe = Double {
        probe: RootFinding::Failed(ProbeCondition::ObjectStoreNamesOutside(entry.clone())),
        head: Ok(standing_head()),
        lists: Ok(clean_lists()),
    };
    let met_by_the_state_read = Double {
        probe: RootFinding::Root,
        head: Err(GitReadCondition::ObjectStoreNamesOutside(entry.clone())),
        lists: Ok(clean_lists()),
    };

    assert_ne!(ALTERNATES_PHRASE, CONFIG_PHRASE);
    for (double, operation) in [
        (met_by_the_probe, "probe"),
        (met_by_the_state_read, "state"),
    ] {
        let scene = TempDir::new();
        scene.write_file("a.txt", "a");
        let opened = open_folder(scene.path()).expect("the scene opens");

        let _ = read_git(FolderModel::new(opened), &double);

        let records = take_records();
        assert_eq!(records.len(), 1, "one record: {records:?}");
        let (level, text) = &records[0];
        assert_eq!(*level, log::Level::Warn);
        assert!(text.contains("git-reader"), "{text}");
        assert!(text.contains(operation), "{operation}: {text}");
        assert!(text.contains(ALTERNATES_PHRASE), "{text}");
        assert!(!text.contains(CONFIG_PHRASE), "{text}");
        assert!(!text.contains('/'), "the record holds a path: {text}");
        assert!(!text.contains(&entry), "the record holds the entry: {text}");
    }
}

/// The phrase the object store's not-located condition is logged under, under both the probe's arm
/// and the read's.
const OBJECT_STORE_NOT_LOCATED_PHRASE: &str =
    "the object store names a location the reader does not locate";

/// Run inside the one test above: the object store's not-located condition, met by the probe and by
/// the state read, logs one `warn` naming `git-reader` and the operation under a fixed phrase that
/// is neither the alternates phrase nor either config phrase, says nothing of *outside*, and holds
/// no `/` and not the entry it carries (CP-710).
fn test_failed_git_item_with_the_object_store_not_located_condition_logs_one_warn_without_the_entry()
 {
    let entry = "relative/objects".to_string();
    let met_by_the_probe = Double {
        probe: RootFinding::Failed(ProbeCondition::ObjectStoreNotLocated(entry.clone())),
        head: Ok(standing_head()),
        lists: Ok(clean_lists()),
    };
    let met_by_the_state_read = Double {
        probe: RootFinding::Root,
        head: Err(GitReadCondition::ObjectStoreNotLocated(entry.clone())),
        lists: Ok(clean_lists()),
    };
    // A verified submodule's entry is met by the status read alone.
    let met_by_the_status_read = Double {
        probe: RootFinding::Root,
        head: Ok(standing_head()),
        lists: Err(GitReadCondition::ObjectStoreNotLocated(entry.clone())),
    };

    for phrase in [ALTERNATES_PHRASE, CONFIG_PHRASE, NOT_LOCATED_PHRASE] {
        assert_ne!(OBJECT_STORE_NOT_LOCATED_PHRASE, phrase);
    }
    for (double, operation) in [
        (met_by_the_probe, "probe"),
        (met_by_the_state_read, "state"),
        (met_by_the_status_read, "status"),
    ] {
        let scene = TempDir::new();
        scene.write_file("a.txt", "a");
        let opened = open_folder(scene.path()).expect("the scene opens");

        let _ = read_git(FolderModel::new(opened), &double);

        let records = take_records();
        assert_eq!(records.len(), 1, "one record: {records:?}");
        let (level, text) = &records[0];
        assert_eq!(*level, log::Level::Warn);
        assert!(text.contains("git-reader"), "{text}");
        assert!(text.contains(operation), "{operation}: {text}");
        assert!(text.contains(OBJECT_STORE_NOT_LOCATED_PHRASE), "{text}");
        assert!(!text.contains(ALTERNATES_PHRASE), "{text}");
        assert!(!text.contains(CONFIG_PHRASE), "{text}");
        assert!(!text.contains(NOT_LOCATED_PHRASE), "{text}");
        assert!(!text.to_lowercase().contains("outside"), "{text}");
        assert!(!text.contains('/'), "the record holds a path: {text}");
        assert!(!text.contains(&entry), "the record holds the entry: {text}");
    }
}
