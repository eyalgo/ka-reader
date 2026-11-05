//! Layer 2: the folder model holds the reader's place — expansion, selection, the open file and its
//! reading position — through the public API alone, and applies a delta of created, changed and
//! removed entries to the folders it holds without losing any of it (CP-777 – CP-788).
//!
//! The place is set only through `FolderModel::list_tree` and `FolderModel::select_file`, the two
//! operations CP-782 names. Fixture writes are setup, made before the model sees them.

#[allow(
    dead_code,
    reason = "each test crate uses a subset of the shared helpers"
)]
mod common;

use std::fs;
use std::path::{Path, PathBuf};
use std::time::SystemTime;

use common::TempDir;
use ka_reader_core::{
    Condition, Entry, EntryKind, FileRequest, FolderModel, ItemState, ModelDelta, PathReports,
    ReadingPosition, TreeRequest, list_tree, open_folder,
};

/// A project-shaped folder: a root file, nested folders, a `.git` entry and files to open.
fn project() -> TempDir {
    let folder = TempDir::new();
    folder.write_file("README.md", "# readme\n");
    folder.write_file("old.txt", "old\n");
    folder.write_file("src/main.rs", "fn main() {}\n");
    folder.write_file("src/util.rs", "// util\n");
    folder.write_file("src/lib/mod.rs", "// lib\n");
    folder.write_file("docs/guide.md", "guide\n");
    folder.write_file("tests/old.rs", "// old\n");
    folder.write_file(".git/HEAD", "ref: refs/heads/main\n");
    folder
}

fn model_over(folder: &TempDir) -> FolderModel {
    FolderModel::new(open_folder(folder.path()).expect("the project folder opens"))
}

fn expand(model: FolderModel, path: &str) -> FolderModel {
    model.list_tree(TreeRequest::Expand(PathBuf::from(path)))
}

fn collapse(model: FolderModel, path: &str) -> FolderModel {
    model.list_tree(TreeRequest::Collapse(PathBuf::from(path)))
}

fn select(model: FolderModel, path: &str) -> FolderModel {
    model.select_file(FileRequest::Select(Some(PathBuf::from(path))))
}

fn open_at(model: FolderModel, path: &str, position: &ReadingPosition) -> FolderModel {
    model.select_file(FileRequest::Open(PathBuf::from(path), position.clone()))
}

fn expanded(model: &FolderModel, path: &str) -> bool {
    model.place().is_expanded(Path::new(path))
}

/// The line-400 anchor of a file longer than the panel, in a caller-chosen encoding with a finer
/// offset: the model never reads inside it.
fn line_400_anchor() -> ReadingPosition {
    ReadingPosition::new(b"line=400;offset=0.5".as_slice())
}

/// The names of the entries of an observed listing, in the order it carries them.
fn names(listing: Option<&ItemState<Vec<Entry>>>) -> Vec<&str> {
    match listing {
        Some(ItemState::Observed(entries)) => entries.iter().map(|e| e.name.as_str()).collect(),
        other => panic!("expected a held observed listing, got {other:?}"),
    }
}

#[test]
fn a_fresh_model_holds_nothing() {
    let folder = project();
    let opened = open_folder(folder.path()).expect("the project folder opens");

    let model = model_over(&folder);

    for path in ["src", "docs", "tests", "src/lib", ".git"] {
        assert!(!expanded(&model, path), "{path} is collapsed at arrival");
    }
    assert_eq!(model.place().selected(), None);
    assert!(model.open_file().is_none());
    assert_eq!(model.tree(), &list_tree(&opened, ""));
    assert!(model.listing(Path::new("src")).is_none());
    assert!(model.listing(Path::new(".git")).is_none());
}

#[test]
fn collapsing_a_parent_holds_the_child_expanded() {
    let folder = project();

    let model = collapse(expand(expand(model_over(&folder), "src"), "src/lib"), "src");

    assert!(!expanded(&model, "src"));
    assert!(expanded(&model, "src/lib"));
}

#[test]
fn dot_git_stays_expanded_when_another_folder_is_collapsed() {
    let folder = project();

    let model = collapse(expand(expand(model_over(&folder), "docs"), ".git"), "docs");

    assert!(expanded(&model, ".git"));
    assert!(!expanded(&model, "docs"));
    assert_eq!(names(model.listing(Path::new(".git"))), ["HEAD"]);
}

#[test]
fn an_inside_folder_link_and_a_nested_folder_hold_their_own_flags() {
    let folder = project();
    folder.make_link("shown", "src");
    let opened = open_folder(folder.path()).expect("the project folder opens");

    let model = expand(model_over(&folder), "src");
    let model = expand(model, "shown");
    let model = expand(model, "src/lib");
    let model = collapse(model, "shown");

    let link_kind = match model.tree() {
        ItemState::Observed(entries) => entries.iter().find(|e| e.name == "shown").map(|e| e.kind),
        other => panic!("the root listing is held: {other:?}"),
    };
    assert_eq!(link_kind, Some(EntryKind::Folder));
    assert!(expanded(&model, "src"));
    assert!(!expanded(&model, "shown"));
    assert!(expanded(&model, "src/lib"));
    assert_eq!(
        model.listing(Path::new("shown")),
        Some(&list_tree(&opened, "shown"))
    );
    assert_eq!(
        model.listing(Path::new("src")),
        Some(&list_tree(&opened, "src"))
    );
}

#[test]
fn select_open_and_position_read_back_as_set() {
    let folder = project();
    let anchor = line_400_anchor();

    let model = select(model_over(&folder), "src/main.rs");
    let model = open_at(
        model,
        "src/main.rs",
        &ReadingPosition::new(b"top".as_slice()),
    );
    let model = model.select_file(FileRequest::Position(anchor.clone()));

    assert_eq!(model.place().selected(), Some(Path::new("src/main.rs")));
    let open_file = model.open_file().expect("a file is open");
    assert_eq!(open_file.path(), Path::new("src/main.rs"));
    assert_eq!(open_file.position(), &anchor);
    assert_eq!(open_file.position().as_bytes(), b"line=400;offset=0.5");
}

/// The product's own data location, in the sandbox container below the user's home, as a record of
/// what is there. It is only read: a test never creates or rewrites it.
fn own_data_record() -> Option<Vec<(PathBuf, u64, Option<SystemTime>)>> {
    const BELOW_HOME: &str = "Library/Containers/com.kensaiapp.ka-reader/Data";

    fn visit(path: &Path, record: &mut Vec<(PathBuf, u64, Option<SystemTime>)>) {
        let Ok(metadata) = fs::symlink_metadata(path) else {
            return;
        };
        record.push((path.to_path_buf(), metadata.len(), metadata.modified().ok()));
        if metadata.is_dir() {
            let Ok(children) = fs::read_dir(path) else {
                return;
            };
            let mut children: Vec<_> = children.flatten().map(|child| child.path()).collect();
            children.sort();
            for child in children {
                visit(&child, record);
            }
        }
    }

    let home = std::env::var_os("HOME")?; // test-isolation: allowed — the subject is that nothing is written under the home; the gate runs it under an empty one
    let location = Path::new(&home).join(BELOW_HOME);
    let mut record = Vec::new();
    visit(&location, &mut record);
    Some(record)
}

#[test]
fn setting_the_place_writes_nothing() {
    let folder = project();
    let own_data_before = own_data_record();
    let before = folder.snapshot();

    let model = expand(expand(model_over(&folder), "src"), "docs");
    let model = collapse(model, "docs");
    let model = select(model, "src/util.rs");
    let model = open_at(
        model,
        "src/main.rs",
        &ReadingPosition::new(b"top".as_slice()),
    );
    let model = model.select_file(FileRequest::Position(line_400_anchor()));
    assert!(expanded(&model, "src"));
    assert!(!expanded(&model, "docs"));
    assert_eq!(model.place().selected(), Some(Path::new("src/util.rs")));
    assert_eq!(
        model.open_file().expect("a file is open").position(),
        &line_400_anchor()
    );

    folder.assert_unchanged_since(
        &before,
        "setting and reading back the place wrote under the folder",
    );
    assert_eq!(
        own_data_record(),
        own_data_before,
        "setting the place touched the product's own data location"
    );
}

// ---- A delta of created, changed and removed entries, applied to what the model holds ----

fn delta(created: &[&str], changed: &[&str], removed: &[&str]) -> TreeRequest {
    let paths = |names: &[&str]| names.iter().map(PathBuf::from).collect::<Vec<_>>();
    TreeRequest::Delta(ModelDelta::new(
        paths(created),
        paths(changed),
        paths(removed),
    ))
}

/// A fresh free-function read of `path`: the oracle for a listing, never the reducer's own output.
fn fresh(folder: &TempDir, path: &str) -> ItemState<Vec<Entry>> {
    list_tree(
        &open_folder(folder.path()).expect("the project folder opens"),
        path,
    )
}

fn entry_named<'a>(listing: &'a ItemState<Vec<Entry>>, name: &str) -> Option<&'a Entry> {
    match listing {
        ItemState::Observed(entries) => entries.iter().find(|entry| entry.name == name),
        other => panic!("expected an observed listing, got {other:?}"),
    }
}

/// Every entry of `listing` except those named in `except`, with their values.
fn others<'a>(listing: &'a ItemState<Vec<Entry>>, except: &[&str]) -> Vec<&'a Entry> {
    match listing {
        ItemState::Observed(entries) => entries
            .iter()
            .filter(|entry| !except.contains(&entry.name.as_str()))
            .collect(),
        other => panic!("expected an observed listing, got {other:?}"),
    }
}

#[test]
fn place_survives_mixed_delta() {
    let folder = project();
    let model = expand(expand(model_over(&folder), "src"), "docs");
    let model = collapse(model, "docs");
    let model = select(model, "src/main.rs");
    let model = open_at(
        model,
        "src/main.rs",
        &ReadingPosition::new(b"top".as_slice()),
    );
    let model = model.select_file(FileRequest::Position(line_400_anchor()));
    let place_before = model.place().clone();
    let open_before = model.open_file().cloned();
    let docs_before = model.listing(Path::new("docs")).cloned();
    let git_before = model.kind().clone();

    folder.write_file("src/new.rs", "// new\n");
    fs::remove_file(folder.path().join("src/util.rs")).expect("the file is removed");
    folder.make_folder("src/util.rs");
    fs::remove_file(folder.path().join("README.md")).expect("the file is removed");
    let model = model.list_tree(delta(&["src/new.rs"], &["src/util.rs"], &["README.md"]));

    assert_eq!(model.place(), &place_before);
    assert_eq!(model.open_file().cloned(), open_before);
    assert!(expanded(&model, "src"));
    assert!(!expanded(&model, "docs"));
    assert_eq!(model.place().selected(), Some(Path::new("src/main.rs")));
    assert_eq!(
        model.open_file().expect("a file is open").position(),
        &line_400_anchor()
    );
    assert_eq!(model.tree(), &fresh(&folder, ""));
    assert_eq!(
        model.listing(Path::new("src")),
        Some(&fresh(&folder, "src"))
    );
    assert_eq!(model.listing(Path::new("docs")).cloned(), docs_before);
    assert_eq!(model.kind(), &git_before);
    assert_eq!(
        names(model.listing(Path::new("src"))),
        ["lib", "util.rs", "main.rs", "new.rs"]
    );
    assert!(entry_named(model.tree(), "README.md").is_none());
}

#[test]
fn a_create_inside_a_collapsed_folder_leaves_it_collapsed_and_unlisted() {
    let folder = project();
    let model = open_at(
        expand(model_over(&folder), "src"),
        "src/main.rs",
        &line_400_anchor(),
    );
    let before = model.clone();

    folder.write_file("tests/a.rs", "// a\n");
    let after = model.list_tree(delta(&["tests/a.rs"], &[], &[]));

    assert_eq!(after, before);
    assert!(!expanded(&after, "tests"));
    assert!(after.listing(Path::new("tests")).is_none());

    // A folder expanded and then collapsed keeps the listing it read: that listing takes the change
    // and the folder stays collapsed.
    let reread = collapse(expand(after, "tests"), "tests");
    let src_before = reread.listing(Path::new("src")).cloned();
    folder.write_file("tests/b.rs", "// b\n");
    let reread = reread.list_tree(delta(&["tests/b.rs"], &[], &[]));

    assert!(!expanded(&reread, "tests"));
    assert_eq!(
        reread.listing(Path::new("tests")),
        Some(&fresh(&folder, "tests"))
    );
    assert_eq!(
        names(reread.listing(Path::new("tests"))),
        ["a.rs", "b.rs", "old.rs"]
    );
    assert_eq!(reread.listing(Path::new("src")).cloned(), src_before);
    assert_eq!(reread.open_file(), before.open_file());
}

#[test]
fn a_root_only_delta_changes_only_the_root_listing() {
    let folder = project();
    let model = expand(expand(model_over(&folder), "src"), "docs");
    let model = collapse(select(model, "src/util.rs"), "docs");
    let root_before = model.tree().clone();
    let src_before = model.listing(Path::new("src")).cloned();
    let docs_before = model.listing(Path::new("docs")).cloned();

    folder.write_file("NOTES.md", "notes\n");
    fs::remove_file(folder.path().join("README.md")).expect("the file is removed");
    folder.make_folder("README.md");
    fs::remove_file(folder.path().join("old.txt")).expect("the file is removed");
    let after = model
        .clone()
        .list_tree(delta(&["NOTES.md"], &["README.md"], &["old.txt"]));

    assert_eq!(after.tree(), &fresh(&folder, ""));
    assert_eq!(
        others(after.tree(), &["NOTES.md", "README.md", "old.txt"]),
        others(&root_before, &["NOTES.md", "README.md", "old.txt"])
    );
    assert_eq!(after.listing(Path::new("src")).cloned(), src_before);
    assert_eq!(after.listing(Path::new("docs")).cloned(), docs_before);
    assert_eq!(after.place(), model.place());
    assert_eq!(after.kind(), model.kind());

    // A single create reaches the root listing alone.
    folder.write_file("only-created.md", "x\n");
    let created = model.list_tree(delta(&["only-created.md"], &[], &[]));
    assert_eq!(created.listing(Path::new("src")).cloned(), src_before);
    assert!(entry_named(created.tree(), "only-created.md").is_some());
}

#[test]
fn a_sibling_of_the_selected_file_may_change() {
    let folder = project();
    let model = select(expand(model_over(&folder), "src"), "src/main.rs");
    let model = open_at(model, "src/main.rs", &line_400_anchor());
    let open_before = model.open_file().cloned();

    folder.write_file("src/sibling.rs", "// sibling\n");
    let after = model.list_tree(delta(&["src/sibling.rs"], &[], &[]));

    assert_eq!(after.place().selected(), Some(Path::new("src/main.rs")));
    assert_eq!(after.open_file().cloned(), open_before);
    assert_eq!(
        after.listing(Path::new("src")),
        Some(&fresh(&folder, "src"))
    );
    assert!(entry_named(after.listing(Path::new("src")).expect("held"), "sibling.rs").is_some());
}

#[test]
fn a_delta_through_a_folder_link_updates_both_held_listings() {
    let folder = project();
    folder.make_link("shown", "src");
    let model = expand(expand(model_over(&folder), "src"), "shown");
    let model = expand(model, "src/lib");

    // A child is created and reported by its target path.
    folder.write_file("src/new.rs", "// new\n");
    let model = model.list_tree(delta(&["src/new.rs"], &[], &[]));
    assert_eq!(
        model.listing(Path::new("src")),
        Some(&fresh(&folder, "src"))
    );
    assert_eq!(
        model.listing(Path::new("shown")),
        Some(&fresh(&folder, "shown"))
    );

    // A child is removed and reported by the link's spelling, which no longer resolves to it.
    fs::remove_file(folder.path().join("src/util.rs")).expect("the file is removed");
    let model = model.list_tree(delta(&[], &[], &["shown/util.rs"]));
    assert_eq!(
        model.listing(Path::new("src")),
        Some(&fresh(&folder, "src"))
    );
    assert_eq!(
        model.listing(Path::new("shown")),
        Some(&fresh(&folder, "shown"))
    );
    assert!(entry_named(model.listing(Path::new("shown")).expect("held"), "util.rs").is_none());

    // A child is created and reported by the link's spelling.
    folder.write_file("src/z.rs", "// z\n");
    let model = model.list_tree(delta(&["shown/z.rs"], &[], &[]));
    assert_eq!(
        model.listing(Path::new("src")),
        Some(&fresh(&folder, "src"))
    );
    assert_eq!(
        model.listing(Path::new("shown")),
        Some(&fresh(&folder, "shown"))
    );

    assert!(expanded(&model, "src"));
    assert!(expanded(&model, "shown"));
    assert!(expanded(&model, "src/lib"));
    let model = collapse(model, "shown");
    assert!(expanded(&model, "src"));
    assert!(!expanded(&model, "shown"));
}

#[test]
fn a_change_reported_by_the_target_path_updates_both_held_listings() {
    let folder = project();
    folder.make_link("shown", "src");
    let model = expand(expand(model_over(&folder), "src"), "shown");

    // A child changes kind on disk and is reported changed by its target path.
    fs::remove_file(folder.path().join("src/util.rs")).expect("the file is removed");
    folder.make_folder("src/util.rs");
    let model = model.list_tree(delta(&[], &["src/util.rs"], &[]));

    for path in ["src", "shown"] {
        let listing = model.listing(Path::new(path)).expect("the listing is held");
        assert_eq!(listing, &fresh(&folder, path), "{path}");
        assert_eq!(
            entry_named(listing, "util.rs").map(|entry| entry.kind),
            Some(EntryKind::Folder),
            "{path}"
        );
    }
    assert!(expanded(&model, "src"));
    assert!(expanded(&model, "shown"));
}

#[test]
fn unreported_disk_changes_are_not_adopted() {
    let folder = project();
    let model = expand(model_over(&folder), "src");

    folder.write_file("src/new.rs", "// new\n");
    folder.write_file("src/unreported.rs", "// unreported\n");
    fs::remove_file(folder.path().join("src/util.rs")).expect("the file is removed");
    let after = model.list_tree(delta(&["src/new.rs"], &[], &[]));

    let listing = after
        .listing(Path::new("src"))
        .expect("the listing is held");
    assert!(entry_named(listing, "new.rs").is_some());
    assert!(entry_named(listing, "unreported.rs").is_none());
    assert!(entry_named(listing, "util.rs").is_some());
}

// ---- Invalidate: path hints re-read the listings they cover, whole ----

/// The model after a batch of reports, each naming a path relative to the opened root.
fn invalidate(model: FolderModel, reported: &[&str]) -> FolderModel {
    let root = model.folder().root().to_path_buf();
    let paths = reported.iter().map(|path| root.join(path)).collect();
    model.list_tree(TreeRequest::Invalidate(PathReports::new(paths)))
}

/// Every listing the model holds at `paths` equals a fresh read of the same path, in its order.
fn assert_equals_fresh_reads(model: &FolderModel, paths: &[&str]) {
    for path in paths {
        assert_eq!(
            model.listing(Path::new(path)),
            Some(&list_tree(model.folder(), path)),
            "the listing at {path:?} differs from a fresh read"
        );
    }
}

#[test]
fn test_create_in_nested_expanded_folder_appears_and_matches_a_fresh_read() {
    let folder = project();
    let model = expand(
        expand(expand(model_over(&folder), "src"), "src/lib"),
        "docs",
    );
    folder.write_file("src/lib/new.rs", "// new\n");
    folder.write_file("docs/more.md", "more\n");

    let model = invalidate(model, &["src/lib/new.rs", "docs/more.md"]);

    assert!(names(model.listing(Path::new("src/lib"))).contains(&"new.rs"));
    assert!(names(model.listing(Path::new("docs"))).contains(&"more.md"));
    assert_equals_fresh_reads(&model, &["", "src", "src/lib", "docs"]);
}

#[test]
fn test_deleting_the_last_child_gives_an_observed_empty_listing() {
    let folder = project();
    let model = expand(expand(model_over(&folder), "docs"), "src");
    fs::remove_file(folder.path().join("docs/guide.md")).expect("the file goes");

    let model = invalidate(model, &["docs/guide.md"]);

    assert_eq!(
        model.listing(Path::new("docs")),
        Some(&ItemState::Observed(vec![]))
    );
    assert_equals_fresh_reads(&model, &["", "docs", "src"]);
}

#[test]
fn test_rename_across_folders_reads_as_absent_then_present() {
    let folder = project();
    let model = expand(expand(model_over(&folder), "src"), "docs");
    fs::rename(
        folder.path().join("src/util.rs"),
        folder.path().join("docs/util.rs"),
    )
    .expect("the file moves");

    let model = invalidate(model, &["src/util.rs", "docs/util.rs"]);

    assert!(!names(model.listing(Path::new("src"))).contains(&"util.rs"));
    assert!(names(model.listing(Path::new("docs"))).contains(&"util.rs"));
    assert_equals_fresh_reads(&model, &["", "src", "docs"]);
}

#[test]
fn test_the_same_report_twice_leaves_no_duplicate_row() {
    let folder = project();
    let model = expand(model_over(&folder), "src");
    folder.write_file("src/new.rs", "// new\n");

    let once = invalidate(model.clone(), &["src/new.rs"]);
    let twice = invalidate(once.clone(), &["src/new.rs", "src/new.rs"]);

    assert_eq!(
        names(twice.listing(Path::new("src")))
            .iter()
            .filter(|n| **n == "new.rs")
            .count(),
        1
    );
    assert_eq!(twice, once);
    assert_equals_fresh_reads(&twice, &["", "src"]);
}

#[test]
fn test_place_survives_an_invalidate() {
    let folder = project();
    let anchor = line_400_anchor();
    let model = open_at(
        select(
            collapse(expand(expand(model_over(&folder), "src"), "docs"), "docs"),
            "src/util.rs",
        ),
        "src/main.rs",
        &anchor,
    );
    let before = model.place().clone();
    let open_before = model.open_file().cloned();
    folder.write_file("src/new.rs", "// new\n");
    folder.write_file("docs/more.md", "more\n");

    let after = invalidate(model, &["src/new.rs", "docs/more.md"]);

    assert_eq!(after.place(), &before);
    assert!(!expanded(&after, "docs"));
    assert_eq!(after.place().selected(), Some(Path::new("src/util.rs")));
    let open = after.open_file().expect("the open file stands");
    assert_eq!(open.path(), Path::new("src/main.rs"));
    assert_eq!(open.position(), &anchor);
    assert_eq!(Some(open), open_before.as_ref());
}

#[test]
fn test_a_root_failed_reread_then_recovery() {
    let folder = project();
    let model = model_over(&folder);
    folder.set_mode("", 0o000);

    let failed = invalidate(model, &[""]);
    folder.set_mode("", 0o755);

    assert_eq!(failed.tree(), &ItemState::Failed(Condition::Unreadable));

    let recovered = invalidate(failed, &[""]);
    assert_eq!(recovered.tree(), &list_tree(recovered.folder(), ""));
    assert!(matches!(recovered.tree(), ItemState::Observed(_)));
}

#[test]
fn test_an_unreadable_entry_is_failed_alone() {
    let folder = project();
    let model = expand(expand(model_over(&folder), "docs"), "src");
    let root_before = model.listing(Path::new("")).cloned();
    let src_before = model.listing(Path::new("src")).cloned();
    folder.set_mode("docs", 0o000);

    let model = invalidate(model, &["docs"]);
    folder.set_mode("docs", 0o755);

    assert_eq!(
        model.listing(Path::new("docs")),
        Some(&ItemState::Failed(Condition::Unreadable))
    );
    assert_eq!(model.listing(Path::new("")).cloned(), root_before);
    assert_eq!(model.listing(Path::new("src")).cloned(), src_before);
}

#[test]
fn test_an_ancestor_report_and_a_root_report_cover_descendants() {
    let folder = project();
    let model = expand(expand(model_over(&folder), "src"), "src/lib");
    folder.write_file("src/lib/deep.rs", "// deep\n");
    folder.write_file("src/top.rs", "// top\n");

    let by_ancestor = invalidate(model.clone(), &["src"]);
    assert!(names(by_ancestor.listing(Path::new("src/lib"))).contains(&"deep.rs"));
    assert_equals_fresh_reads(&by_ancestor, &["", "src", "src/lib"]);

    let by_root = invalidate(model.clone(), &[""]);
    assert_equals_fresh_reads(&by_root, &["", "src", "src/lib"]);

    let outside = model
        .folder()
        .root()
        .parent()
        .expect("the root has a parent")
        .join("elsewhere");
    let by_outside = model.list_tree(TreeRequest::Invalidate(PathReports::new(vec![outside])));
    assert_equals_fresh_reads(&by_outside, &["", "src", "src/lib"]);
}

#[test]
fn test_a_retargeted_link_is_marked_each_time_and_nothing_outside_is_read() {
    let scene = TempDir::new();
    let folder = scene.make_folder("opened");
    scene.write_file("opened/docs/guide.md", "guide\n");
    scene.write_file("opened/src/main.rs", "fn main() {}\n");
    scene.write_file("outside/secret.txt", "secret\n");
    scene.make_link("opened/src/link", "../docs");
    let opened = open_folder(&folder).expect("the folder opens");
    let model = expand(
        expand(expand(FolderModel::new(opened), "src"), "src/link"),
        "docs",
    );
    let siblings_before = (
        model.listing(Path::new("docs")).cloned(),
        model.listing(Path::new("src")).cloned(),
    );
    let outside_before = outside_of(&scene);

    for target in ["../../outside", "../missing-target", "."] {
        fs::remove_file(folder.join("src/link")).expect("the link goes");
        std::os::unix::fs::symlink(target, folder.join("src/link"))
            .expect("the link is retargeted");

        let after = invalidate(model.clone(), &["src/link"]);

        // The parent is re-read too (it is the report's parent), so a link that no longer reads
        // as a folder is marked on its own row in the parent's listing, and the listing under it
        // goes with the drop pass.
        assert_equals_fresh_reads(&after, &["src"]);
        assert_eq!(after.listing(Path::new("src/link")), None);
        let row_state = match after.listing(Path::new("src")) {
            Some(ItemState::Observed(entries)) => entries
                .iter()
                .find(|entry| entry.name == "link")
                .map(|entry| entry.state.clone()),
            other => panic!("expected the observed parent listing, got {other:?}"),
        };
        assert!(
            matches!(row_state, Some(ItemState::Failed(_))),
            "the retargeted row is marked failed: {row_state:?}"
        );
        assert_eq!(after.listing(Path::new("docs")).cloned(), siblings_before.0);
    }
    let _ = siblings_before.1;
    assert_eq!(
        outside_of(&scene),
        outside_before,
        "nothing outside the root is touched"
    );
}

/// What the scene holds beside the opened folder, snapshotted without following a link.
fn outside_of(scene: &TempDir) -> Vec<(PathBuf, common::SnapshotEntry)> {
    scene
        .snapshot()
        .into_iter()
        .filter(|(path, _)| path.starts_with("outside"))
        .collect()
}

#[test]
fn test_removal_report_removes_the_folder_and_keeps_expansion_and_selection() {
    let folder = project();
    let model = select(
        expand(
            expand(expand(model_over(&folder), "src"), "src/lib"),
            "docs",
        ),
        "src/util.rs",
    );
    fs::remove_dir_all(folder.path().join("src")).expect("the folder goes");

    let model = invalidate(model, &["src"]);

    assert_eq!(model.listing(Path::new("src")), None);
    assert_eq!(model.listing(Path::new("src/lib")), None);
    assert!(expanded(&model, "src") && expanded(&model, "src/lib"));
    assert_eq!(model.place().selected(), Some(Path::new("src/util.rs")));
    assert!(!names(model.listing(Path::new(""))).contains(&"src"));
    assert_equals_fresh_reads(&model, &["", "docs"]);
}

#[test]
fn test_a_folder_replaced_by_a_file_is_listed_as_a_file_with_the_flag_kept() {
    let folder = project();
    let model = expand(expand(model_over(&folder), "docs"), "src");
    fs::remove_dir_all(folder.path().join("docs")).expect("the folder goes");
    folder.write_file("docs", "now a file\n");

    let model = invalidate(model, &["docs"]);

    assert_eq!(model.listing(Path::new("docs")), None);
    assert!(expanded(&model, "docs"));
    let root = model
        .listing(Path::new(""))
        .expect("the root listing stands");
    assert!(matches!(
        root,
        ItemState::Observed(entries)
            if entries.iter().any(|e| e.name == "docs" && e.kind == EntryKind::File)
    ));
    assert_equals_fresh_reads(&model, &["", "src"]);
}

#[test]
fn test_a_failed_expanded_folder_keeps_each_sibling_in_its_own_state() {
    let folder = project();
    folder.set_mode("docs", 0o000);
    let model = expand(
        expand(
            expand(expand(model_over(&folder), "docs"), "src"),
            "src/lib",
        ),
        "tests",
    );
    folder.set_mode("docs", 0o755);
    let docs_before = model.listing(Path::new("docs")).cloned();
    let tests_before = model.listing(Path::new("tests")).cloned();
    assert_eq!(docs_before, Some(ItemState::Failed(Condition::Unreadable)));
    folder.write_file("src/x.rs", "// x\n");
    folder.set_mode("src", 0o000);

    let model = invalidate(model, &["src"]);
    folder.set_mode("src", 0o755);

    assert_eq!(
        model.listing(Path::new("src")),
        Some(&ItemState::Failed(Condition::Unreadable))
    );
    assert_eq!(model.listing(Path::new("src/lib")), None);
    assert_eq!(model.listing(Path::new("docs")).cloned(), docs_before);
    assert_eq!(model.listing(Path::new("tests")).cloned(), tests_before);
    assert!(matches!(
        model.listing(Path::new("tests")),
        Some(ItemState::Observed(_))
    ));
    assert_eq!(model.kind(), &ItemState::Pending);
}
