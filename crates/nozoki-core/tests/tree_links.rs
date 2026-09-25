//! Layer 2: how a link entry is listed and how a path through a link is answered, over temporary
//! folders. A link lists as the folder or file it reaches, and it fails as one of the closed
//! conditions when it cannot be resolved (CP-171 – CP-177).

mod common;

use common::TempDir;
use nozoki_core::{Condition, Entry, EntryKind, ItemState, OpenedFolder, list_tree, open_folder};

fn open(folder: &TempDir) -> OpenedFolder {
    open_folder(folder.path()).expect("a folder opens")
}

/// The entries of an observed answer, or a panic naming the answer.
fn observed(answer: ItemState<Vec<Entry>>) -> Vec<Entry> {
    match answer {
        ItemState::Observed(entries) => entries,
        other => panic!("expected an Observed answer, got {other:?}"),
    }
}

/// The entry called `name`, or a panic listing the names that were there.
fn named<'a>(entries: &'a [Entry], name: &str) -> &'a Entry {
    entries
        .iter()
        .find(|entry| entry.name == name)
        .unwrap_or_else(|| panic!("no entry called {name}: {entries:?}"))
}

fn assert_folder(entry: &Entry) {
    assert_eq!(entry.kind, EntryKind::Folder, "{entry:?}");
    assert_eq!(entry.state, ItemState::Pending, "{entry:?}");
}

fn assert_file(entry: &Entry) {
    assert_eq!(entry.kind, EntryKind::File, "{entry:?}");
    assert_eq!(entry.state, ItemState::Observed(()), "{entry:?}");
}

/// A failed entry is always a file (CP-169).
fn assert_failed(entry: &Entry, condition: Condition) {
    assert_eq!(entry.kind, EntryKind::File, "{entry:?}");
    assert_eq!(entry.state, ItemState::Failed(condition), "{entry:?}");
}

#[test]
fn a_link_to_a_folder_inside_lists_as_a_pending_folder() {
    let folder = TempDir::new();
    folder.write_file("docs/guide.txt", "");
    folder.make_folder("docs/deep");
    folder.write_file("a.txt", "");
    folder.make_link("z-link", "docs");
    let opened = open(&folder);

    let root = observed(list_tree(&opened, ""));
    let through_link = observed(list_tree(&opened, "z-link"));
    let direct = observed(list_tree(&opened, "docs"));

    assert_folder(named(&root, "z-link"));
    assert_eq!(
        through_link, direct,
        "the link lists the entries and states of the folder it reaches"
    );
    assert_eq!(through_link.len(), 2);
}

#[test]
fn a_link_to_a_file_inside_lists_as_an_observed_file() {
    let folder = TempDir::new();
    folder.write_file("notes.txt", "");
    folder.make_link("note-link", "notes.txt");
    let opened = open(&folder);

    let root = observed(list_tree(&opened, ""));

    assert_file(named(&root, "note-link"));
    assert_file(named(&root, "notes.txt"));
}

#[test]
fn a_link_outside_fails_as_outside_without_reading_its_target() {
    let folder = TempDir::new();
    folder.write_file("docs/guide.txt", "");
    folder.write_file(".hidden-note", "");
    folder.write_file("readme.txt", "");
    let outside = TempDir::new();
    outside.write_file("target/child.txt", "");
    outside.set_mode("target", 0o000);
    folder.make_link("outside-link", outside.path().join("target"));
    let opened = open(&folder);

    let root = observed(list_tree(&opened, ""));

    // A read of the target would have answered Unreadable, so Outside proves nothing outside was touched.
    assert_failed(named(&root, "outside-link"), Condition::Outside);
    assert_folder(named(&root, "docs"));
    assert_file(named(&root, ".hidden-note"));
    assert_file(named(&root, "readme.txt"));
    assert_eq!(root.len(), 4);
}

#[test]
fn a_link_to_an_ancestor_of_the_root_fails_as_outside() {
    let folder = TempDir::new();
    folder.make_link("up", "..");
    folder.make_link("top", "/");
    let opened = open(&folder);

    let root = observed(list_tree(&opened, ""));

    // The target leaves the opened folder, so it is Outside even though it contains the link
    // (CP-173 over CP-174, whose first class is confined to targets inside the folder).
    assert_failed(named(&root, "up"), Condition::Outside);
    assert_failed(named(&root, "top"), Condition::Outside);
    assert_eq!(
        list_tree(&opened, "up"),
        ItemState::Failed(Condition::Outside)
    );
    assert_eq!(
        list_tree(&opened, "top"),
        ItemState::Failed(Condition::Outside)
    );
}

#[test]
fn a_dangling_link_fails_as_missing_and_its_siblings_stand() {
    let folder = TempDir::new();
    folder.make_link("gone", "nowhere");
    folder.write_file("kept.txt", "");
    let opened = open(&folder);

    let root = observed(list_tree(&opened, ""));

    assert_failed(named(&root, "gone"), Condition::Missing);
    assert_file(named(&root, "kept.txt"));
    assert_eq!(root.len(), 2);
}

#[test]
fn a_chain_past_the_hop_bound_fails_as_too_many_links() {
    let folder = TempDir::new();
    folder.write_file("real/inner.txt", "");
    // c00 -> c01 -> ... -> c32 -> real: 33 links between the head and the folder.
    for index in 0..32 {
        folder.make_link(&format!("c{index:02}"), format!("c{:02}", index + 1));
    }
    folder.make_link("c32", "real");
    let opened = open(&folder);

    let root = observed(list_tree(&opened, ""));

    assert_failed(named(&root, "c00"), Condition::TooManyLinks);
    for index in 1..=32 {
        assert_folder(named(&root, &format!("c{index:02}")));
    }
    assert_folder(named(&root, "real"));
    assert_eq!(
        list_tree(&opened, "c00"),
        ItemState::Failed(Condition::TooManyLinks)
    );
}

/// CP-168, Ex. 5: a link that lists as a folder sorts with the folders, ahead of every file.
#[test]
fn a_link_to_a_folder_inside_sorts_with_the_folders() {
    let folder = TempDir::new();
    folder.make_folder("docs");
    folder.write_file("a.txt", "");
    folder.make_link("z-link", "docs");
    let opened = open(&folder);

    let names: Vec<String> = observed(list_tree(&opened, ""))
        .into_iter()
        .map(|entry| entry.name)
        .collect();

    assert_eq!(names, ["docs", "z-link", "a.txt"]);
}

/// CP-168, Ex. 7: the folder shaped like `checks/fixtures/plain`. The failed link is a file, so it
/// sorts with the files.
#[test]
fn the_plain_shaped_folder_lists_in_the_fdr_order() {
    let folder = TempDir::new();
    folder.write_file("docs/guide.txt", "");
    folder.write_file(".hidden-note", "");
    folder.write_file("readme.txt", "");
    let outside = TempDir::new();
    outside.make_folder("target");
    folder.make_link("outside-link", outside.path().join("target"));
    let opened = open(&folder);

    let names: Vec<String> = observed(list_tree(&opened, ""))
        .into_iter()
        .map(|entry| entry.name)
        .collect();

    assert_eq!(
        names,
        ["docs", ".hidden-note", "outside-link", "readme.txt"]
    );
}

/// CP-174's first cycle class, Ex. 8: a link whose target is a folder that contains the link's own
/// position. `self` reaches the root, which holds it. A path that goes on through it is a cycle too
/// (CP-177, "a path through a link that forms a cycle").
#[test]
fn a_link_to_the_root_fails_as_cycle() {
    let folder = TempDir::new();
    folder.make_link("self", ".");
    let opened = open(&folder);

    let root = observed(list_tree(&opened, ""));

    assert_failed(named(&root, "self"), Condition::Cycle);
    assert_eq!(
        list_tree(&opened, "self"),
        ItemState::Failed(Condition::Cycle)
    );
    assert_eq!(
        list_tree(&opened, "self/x"),
        ItemState::Failed(Condition::Cycle)
    );
}

/// CP-174's first cycle class, Ex. 8: `a/up` reaches `a`'s parent, which holds `a` and so holds `up`.
#[test]
fn a_link_to_its_own_parent_fails_as_cycle() {
    let folder = TempDir::new();
    folder.make_folder("a");
    folder.make_link("a/up", "..");
    let opened = open(&folder);

    let inside = observed(list_tree(&opened, "a"));

    assert_failed(named(&inside, "up"), Condition::Cycle);
    assert_eq!(
        list_tree(&opened, "a/up"),
        ItemState::Failed(Condition::Cycle)
    );
}

/// CP-174's second cycle class, Ex. 9: a chain of links that returns to a link it is still resolving.
#[test]
fn two_links_naming_each_other_fail_as_cycle() {
    let folder = TempDir::new();
    folder.make_link("ping", "pong");
    folder.make_link("pong", "ping");
    let opened = open(&folder);

    let root = observed(list_tree(&opened, ""));

    assert_failed(named(&root, "ping"), Condition::Cycle);
    assert_failed(named(&root, "pong"), Condition::Cycle);
}

/// CP-174's second cycle class, Ex. 9, through a real folder: `a` leads into `b/c`, and `c` leads back
/// to `a`, so resolving `a` meets `a` again while it is still being resolved.
#[test]
fn a_chain_through_a_real_folder_back_to_its_start_fails_as_cycle() {
    let folder = TempDir::new();
    folder.make_folder("b");
    folder.make_link("a", "b/c");
    folder.make_link("b/c", "../a");
    let opened = open(&folder);

    let root = observed(list_tree(&opened, ""));
    let inside_b = observed(list_tree(&opened, "b"));

    assert_failed(named(&root, "a"), Condition::Cycle);
    assert_failed(named(&inside_b, "c"), Condition::Cycle);
}

/// A link that finished earlier may be followed again: only a link still being resolved is a cycle
/// (design § 4 A). `link/../link` reaches `real` twice and never loops.
#[test]
fn a_link_followed_again_after_it_finished_still_resolves() {
    let folder = TempDir::new();
    folder.write_file("real/inner.txt", "");
    folder.make_link("link", "real");
    let opened = open(&folder);

    let through_twice = observed(list_tree(&opened, "link/../link"));
    let direct = observed(list_tree(&opened, "real"));

    assert_eq!(through_twice, direct);
    assert_eq!(through_twice.len(), 1);
}
