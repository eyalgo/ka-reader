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
    Entry, EntryKind, FileRequest, FolderModel, ItemState, ReadingPosition, TreeRequest, list_tree,
    open_folder,
};

/// A project-shaped folder: a root file, nested folders, a `.git` entry and files to open.
fn project() -> TempDir {
    let folder = TempDir::new();
    folder.write_file("README.md", "# readme\n");
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

    let home = std::env::var_os("HOME")?;
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
