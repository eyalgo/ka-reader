//! Layer 2: the SM-5 API (`open_folder`, `list_tree`) over temporary folders.

mod common;

use common::TempDir;
use nozoki_core::{Entry, EntryKind, Listing, list_tree, open_folder};

/// The name and kind of every entry, sorted by name so a test does not depend on the order the
/// operating system lists in.
fn names_and_kinds(listing: Listing) -> Vec<(String, EntryKind)> {
    let Listing::Listed(entries) = listing else {
        panic!("expected a Listed outcome, got {listing:?}");
    };
    let mut pairs: Vec<(String, EntryKind)> = entries
        .into_iter()
        .map(|Entry { name, kind, .. }| (name, kind))
        .collect();
    pairs.sort_by(|left, right| left.0.cmp(&right.0));
    pairs
}

fn pair(name: &str, kind: EntryKind) -> (String, EntryKind) {
    (name.to_string(), kind)
}

#[test]
fn list_root_returns_every_entry_including_hidden_and_git() {
    let folder = TempDir::new();
    folder.write_file(".env", "SECRET=1");
    folder.make_folder(".git");
    folder.make_folder("src");
    folder.write_file("README.md", "hello");
    let opened = open_folder(folder.path()).expect("a folder opens");

    let listed = names_and_kinds(list_tree(&opened, ""));

    assert_eq!(
        listed,
        vec![
            pair(".env", EntryKind::File),
            pair(".git", EntryKind::Folder),
            pair("README.md", EntryKind::File),
            pair("src", EntryKind::Folder),
        ]
    );
}

#[test]
fn list_subfolder_returns_only_its_direct_entries() {
    let folder = TempDir::new();
    folder.write_file("src/main.rs", "fn main() {}");
    folder.write_file("src/deep/inner.rs", "");
    folder.write_file("top.txt", "");
    let opened = open_folder(folder.path()).expect("a folder opens");

    let listed = names_and_kinds(list_tree(&opened, "src"));

    assert_eq!(
        listed,
        vec![
            pair("deep", EntryKind::Folder),
            pair("main.rs", EntryKind::File)
        ]
    );
}

#[test]
fn list_outside_paths_is_refused() {
    let folder = TempDir::new();
    folder.make_folder("src");
    let outside = TempDir::new();
    outside.write_file("secret.txt", "");
    folder.make_link("escape", outside.path());
    let opened = open_folder(folder.path()).expect("a folder opens");

    for requested in ["/etc", "..", "../x", "escape"] {
        assert_eq!(
            list_tree(&opened, requested),
            Listing::Refused,
            "{requested} must be refused"
        );
    }
}

#[test]
fn list_unlistable_inside_paths_is_failed_and_root_still_lists() {
    let folder = TempDir::new();
    folder.write_file("a-file", "");
    folder.make_folder("gone");
    folder.make_folder("locked");
    let opened = open_folder(folder.path()).expect("a folder opens");
    std::fs::remove_dir(folder.path().join("gone")).expect("the folder can be removed");
    folder.set_mode("locked", 0o000);

    for requested in ["a-file", "gone", "locked"] {
        assert!(
            matches!(list_tree(&opened, requested), Listing::Failed(_)),
            "{requested} must be Failed"
        );
        let root = names_and_kinds(list_tree(&opened, ""));
        assert_eq!(
            root.len(),
            2,
            "the root still lists after {requested}: {root:?}"
        );
    }
}

#[test]
fn open_folder_on_a_file_or_missing_path_is_not_opened() {
    let folder = TempDir::new();
    let file = folder.write_file("a-file", "");

    assert!(open_folder(file).is_none());
    assert!(open_folder(folder.path().join("missing")).is_none());
}

#[test]
fn open_folder_on_an_unreadable_folder_opens_and_root_list_is_failed() {
    let folder = TempDir::new();
    folder.make_folder("locked");
    folder.set_mode("locked", 0o000);

    let opened = open_folder(folder.path().join("locked")).expect("an unreadable folder opens");

    assert!(matches!(list_tree(&opened, ""), Listing::Failed(_)));
}

#[test]
fn second_open_replaces_the_first() {
    let first = TempDir::new();
    first.write_file("from-a.txt", "");
    let second = TempDir::new();
    second.write_file("from-b.txt", "");
    let _a = open_folder(first.path()).expect("A opens");

    let b = open_folder(second.path()).expect("B opens");

    assert_eq!(
        names_and_kinds(list_tree(&b, "")),
        vec![pair("from-b.txt", EntryKind::File)]
    );
}

#[test]
fn open_folder_through_a_symlink_roots_at_the_canonical_target() {
    let folder = TempDir::new();
    folder.write_file("real/inside.txt", "");
    folder.make_link("link", folder.path().join("real"));

    let opened = open_folder(folder.path().join("link")).expect("a link to a folder opens");

    assert_eq!(
        names_and_kinds(list_tree(&opened, "")),
        vec![pair("inside.txt", EntryKind::File)]
    );
}

// ---- Added by development-code-integrity (2026-09-19), each derived from the intent it cites ----

/// C-I1 (tl_instruction.md Task 3, "No panic escapes either call, whatever the input";
/// change_design.md § 3 A, "No panic escapes either call"). Malformed and hostile strings are handed
/// to both calls. Nothing panics, and the root still lists afterwards (CP-27, "the commands keep
/// working").
#[test]
fn no_input_makes_either_call_panic() {
    let folder = TempDir::new();
    folder.write_file("kept.txt", "");
    let opened = open_folder(folder.path()).expect("a folder opens");
    let deep = "a/".repeat(5_000);
    let climb = "../".repeat(300);
    let inputs = [
        "\0",
        "a\0b",
        "/",
        "//",
        ".",
        "./..",
        "\u{FFFF}",
        "\u{1F600}/\u{1F600}",
        deep.as_str(),
        climb.as_str(),
    ];

    for input in inputs {
        let _ = list_tree(&opened, input);
    }
    for input in ["", "\0", "a\0b", deep.as_str()] {
        let _ = open_folder(input);
    }

    assert_eq!(
        names_and_kinds(list_tree(&opened, "")),
        vec![pair("kept.txt", EntryKind::File)]
    );
}

/// CP-25 and CP-26 split `list_tree`'s input by where the path *resolves*: "any path whose resolution
/// lies outside the opened folder" is refused, and a folder inside is listed. change_design.md § 3 A
/// fixes resolution as lexical: "A `..` is applied lexically", and a link's target "is joined and
/// normalized lexically, and is refused if it leaves the root". A path that steps above the root and
/// names the root again normalizes to a place inside it, and reaching it touches nothing outside.
#[test]
fn a_path_that_leaves_and_reenters_the_root_lexically_lists_inside() {
    let folder = TempDir::new();
    folder.write_file("src/main.rs", "");
    let root_name = folder
        .path()
        .file_name()
        .expect("the root has a name")
        .to_str()
        .expect("the root's name is text")
        .to_string();
    folder.make_link("back-relative", format!("../{root_name}/src"));
    folder.make_link(
        "back-absolute",
        folder.path().join("..").join(&root_name).join("src"),
    );
    let opened = open_folder(folder.path()).expect("a folder opens");
    let src = vec![pair("main.rs", EntryKind::File)];

    assert_eq!(
        names_and_kinds(list_tree(&opened, &format!("../{root_name}/src"))),
        src,
        "a requested path"
    );
    assert_eq!(
        names_and_kinds(list_tree(&opened, "back-relative")),
        src,
        "a link with a relative target"
    );
    assert_eq!(
        names_and_kinds(list_tree(&opened, "back-absolute")),
        src,
        "a link with an absolute target"
    );
}
