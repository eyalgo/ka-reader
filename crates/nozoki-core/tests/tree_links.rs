//! Layer 2: how a link entry is listed and how a path through a link is answered, over temporary
//! folders. A link lists as the folder or file it reaches, and it fails as one of the closed
//! conditions when it cannot be resolved (CP-171 – CP-177). A link whose target runs through a file
//! is Missing, and a path the caller spells through a file stays NotAFolder (CP-193, CP-194).

mod common;

use common::TempDir;
use nozoki_core::{
    Condition, Entry, EntryKind, ItemState, Language, OpenedFolder, list_tree, open_folder,
};

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

// ---- Added by development-code-integrity (2026-09-25), each derived from the intent it cites ----

/// CP-174's first class is "a link whose target is a folder that contains the link's own position,
/// the opened folder itself included". It names the folder, not how the target spells it. Each link
/// below reaches a folder that holds it by a different spelling: through a grandparent, by an
/// absolute target, and by a target that steps out of the opened folder and names it again (which
/// CP-173 does not make Outside, because the target lies inside).
#[test]
fn a_link_to_a_folder_holding_it_fails_as_cycle_however_its_target_is_spelled() {
    let folder = TempDir::new();
    let root_name = folder
        .path()
        .file_name()
        .expect("the root has a name")
        .to_str()
        .expect("the root's name is text")
        .to_string();
    folder.make_folder("a/b");
    folder.make_link("a/b/top", "../..");
    folder.make_link("a/home", folder.path().join("a"));
    folder.make_link("back", format!("../{root_name}"));
    let opened = open(&folder);

    assert_failed(
        named(&observed(list_tree(&opened, "a/b")), "top"),
        Condition::Cycle,
    );
    assert_failed(
        named(&observed(list_tree(&opened, "a")), "home"),
        Condition::Cycle,
    );
    assert_failed(
        named(&observed(list_tree(&opened, "")), "back"),
        Condition::Cycle,
    );
    for requested in ["a/b/top", "a/home", "back"] {
        assert_eq!(
            list_tree(&opened, requested),
            ItemState::Failed(Condition::Cycle),
            "{requested}"
        );
    }
}

/// CP-174's first class on a volume that ignores letter case, which is what the product runs on
/// (macOS, CI's `macos-14`). There `../A` names the folder `a`, so `a/up → ../A` reaches the folder
/// that holds it. Listing it as a folder would show `a` inside itself without end (spec Gap 4). On a
/// volume that keeps case, `../A` names nothing, and the link is Missing (CP-175).
#[test]
fn a_link_to_the_folder_holding_it_spelled_in_another_case_fails_as_cycle() {
    let folder = TempDir::new();
    folder.make_folder("a");
    folder.make_link("a/up", "../A");
    let opened = open(&folder);
    let folds_case = folder.path().join("A").exists();
    let expected = if folds_case {
        Condition::Cycle
    } else {
        Condition::Missing
    };

    assert_failed(named(&observed(list_tree(&opened, "a")), "up"), expected);
    assert_eq!(
        list_tree(&opened, "a/up"),
        ItemState::Failed(expected),
        "folds case: {folds_case}"
    );
}

// ---- CP-193 and CP-194: a file where the path needs a folder ----

/// A link's target that runs through a file names something that is not there, so the link is Missing
/// (CP-193). The listing that holds it still stands.
#[test]
fn a_link_through_a_file_lists_as_missing() {
    let folder = TempDir::new();
    folder.write_file("notes.txt", "");
    folder.make_link("bad", "notes.txt/x");
    let opened = open(&folder);

    let root = observed(list_tree(&opened, ""));

    assert_failed(named(&root, "bad"), Condition::Missing);
    assert_file(named(&root, "notes.txt"));
    assert_eq!(root.len(), 2);
}

/// The listed-path answer agrees with the entry answer, and a path that goes on past such a link is
/// Missing too (CP-193).
#[test]
fn listing_a_link_through_a_file_or_a_path_past_it_answers_missing() {
    let folder = TempDir::new();
    folder.write_file("notes.txt", "");
    folder.make_link("bad", "notes.txt/x");
    let opened = open(&folder);

    assert_eq!(
        list_tree(&opened, "bad"),
        ItemState::Failed(Condition::Missing)
    );
    assert_eq!(
        list_tree(&opened, "bad/y"),
        ItemState::Failed(Condition::Missing)
    );
}

/// CP-193 closes its class by domain: every link whose target, followed through any further links, is
/// blocked by a file. Each link below is blocked at a different depth of links or by a different
/// spelling of the step past the file.
#[test]
fn every_link_blocked_by_a_file_is_missing_at_any_depth() {
    let folder = TempDir::new();
    folder.write_file("notes.txt", "");
    folder.make_link("note-link", "notes.txt");
    folder.make_link("bad2", "note-link/x");
    folder.make_link("bad3", "notes.txt/..");
    folder.write_file("sub/notes.txt", "");
    folder.make_link("bad4", "sub/notes.txt/x");
    folder.make_link("bad", "notes.txt/x");
    folder.make_link("chain", "bad");
    let opened = open(&folder);

    let root = observed(list_tree(&opened, ""));

    assert_file(named(&root, "note-link"));
    for blocked in ["bad", "bad2", "bad3", "bad4", "chain"] {
        assert_failed(named(&root, blocked), Condition::Missing);
        assert_eq!(
            list_tree(&opened, blocked),
            ItemState::Failed(Condition::Missing),
            "{blocked}"
        );
    }
}

/// `Path::components` drops a trailing separator and a trailing `.`, so a target spelled
/// `notes.txt/` or `notes.txt/.` leaves no step after the file. Both still demand that the file be a
/// folder, and macOS answers "Not a directory" for them, so they belong to CP-193's class.
#[test]
fn a_link_whose_target_ends_past_a_file_is_missing() {
    let folder = TempDir::new();
    folder.write_file("notes.txt", "");
    folder.make_link("ts", "notes.txt/");
    folder.make_link("td", "notes.txt/.");
    let opened = open(&folder);

    let root = observed(list_tree(&opened, ""));

    for blocked in ["ts", "td"] {
        assert_failed(named(&root, blocked), Condition::Missing);
        assert_eq!(
            list_tree(&opened, blocked),
            ItemState::Failed(Condition::Missing),
            "{blocked}"
        );
    }
}

/// The regression fence for the test above: a trailing separator on a target that reaches a folder is
/// not a demand the folder fails.
#[test]
fn a_link_to_a_folder_spelled_with_a_trailing_separator_still_lists_as_a_folder() {
    let folder = TempDir::new();
    folder.write_file("docs/guide.txt", "");
    folder.make_link("dl", "docs/");
    let opened = open(&folder);

    let root = observed(list_tree(&opened, ""));
    let through_link = observed(list_tree(&opened, "dl"));
    let direct = observed(list_tree(&opened, "docs"));

    assert_folder(named(&root, "dl"));
    assert_eq!(through_link, direct);
    assert_eq!(through_link.len(), 1);
}

/// CP-194: a path the caller spells through a file keeps NotAFolder, in the same tree where the
/// links blocked by a file are Missing, so the two answers are told apart by whose step it was.
#[test]
fn a_path_the_caller_spells_through_a_file_keeps_not_a_folder() {
    let folder = TempDir::new();
    folder.write_file("notes.txt", "");
    folder.make_link("note-link", "notes.txt");
    folder.make_link("bad2", "note-link/x");
    let opened = open(&folder);

    for requested in [
        "notes.txt",
        "notes.txt/x",
        "notes.txt/..",
        "note-link/x",
        "notes.txt/",
        "notes.txt/.",
    ] {
        assert_eq!(
            list_tree(&opened, requested),
            ItemState::Failed(Condition::NotAFolder),
            "{requested}"
        );
    }
    assert_eq!(
        list_tree(&opened, "bad2"),
        ItemState::Failed(Condition::Missing)
    );
}

/// CP-194: a link out of the opened folder that would run through a file is Outside, and the answer
/// being Outside and not NotAFolder or Missing is the evidence that nothing under `/etc` was read (the
/// same argument as `a_link_outside_fails_as_outside_without_reading_its_target`).
#[test]
fn a_link_out_of_the_folder_through_a_file_is_outside() {
    let folder = TempDir::new();
    folder.make_link("outx", "/etc/hosts/x");
    let opened = open(&folder);

    let root = observed(list_tree(&opened, ""));

    assert_failed(named(&root, "outx"), Condition::Outside);
    assert_eq!(
        list_tree(&opened, "outx"),
        ItemState::Failed(Condition::Outside)
    );
}

/// CP-193 holds through a chain of links: the step the file blocks belongs to the outer link's target
/// however many links are followed before the file is met, and that includes a trailing separator
/// that demands a link to a file be a folder.
#[test]
fn a_link_blocked_by_a_file_behind_a_chain_of_links_is_missing() {
    let folder = TempDir::new();
    folder.write_file("notes.txt", "");
    folder.make_link("note-link", "notes.txt");
    folder.make_link("c2", "note-link");
    folder.make_link("bad5", "c2/x");
    folder.make_link("ts2", "note-link/");
    folder.make_link("ts3", "c2/");
    let opened = open(&folder);

    let root = observed(list_tree(&opened, ""));

    assert_file(named(&root, "c2"));
    for blocked in ["bad5", "ts2", "ts3"] {
        assert_failed(named(&root, blocked), Condition::Missing);
        assert_eq!(
            list_tree(&opened, blocked),
            ItemState::Failed(Condition::Missing),
            "{blocked}"
        );
    }
}

/// CP-194 holds through a chain of links too: a path the caller spells past a link that reaches a
/// file through a second link meets the file on the caller's own step, so it keeps NotAFolder.
#[test]
fn a_path_the_caller_spells_past_a_chain_of_links_to_a_file_keeps_not_a_folder() {
    let folder = TempDir::new();
    folder.write_file("notes.txt", "");
    folder.make_link("note-link", "notes.txt");
    folder.make_link("c2", "note-link");
    let opened = open(&folder);

    for requested in ["c2", "c2/x", "c2/..", "c2/"] {
        assert_eq!(
            list_tree(&opened, requested),
            ItemState::Failed(Condition::NotAFolder),
            "{requested}"
        );
    }
}

/// A-4: a link takes the language of its own name, not of the file it reaches.
#[test]
fn test_link_takes_the_language_of_its_own_name_when_listed() {
    let python_named = TempDir::new();
    python_named.write_file("notes.txt", "");
    python_named.make_link("tool.py", "notes.txt");
    let plain_named = TempDir::new();
    plain_named.write_file("tool.py", "");
    plain_named.make_link("notes", "tool.py");

    let from_python_name = observed(list_tree(&open(&python_named), ""));
    let from_plain_name = observed(list_tree(&open(&plain_named), ""));

    assert_eq!(
        named(&from_python_name, "tool.py").language,
        Some(Language::Python)
    );
    assert_eq!(
        named(&from_plain_name, "notes").language,
        Some(Language::Plain)
    );
}

/// A-4: an unresolved link is a failed file, and it still carries the language its name gives.
#[test]
fn test_unresolved_link_lists_as_failed_file_with_its_names_language() {
    let folder = TempDir::new();
    folder.make_link("gone.py", "nowhere");
    let opened = open(&folder);

    let root = observed(list_tree(&opened, ""));

    let gone = named(&root, "gone.py");
    assert_failed(gone, Condition::Missing);
    assert_eq!(gone.language, Some(Language::Python));
}

#[test]
fn test_failed_links_keep_their_names_language_beyond_missing_targets() {
    let folder = TempDir::new();
    folder.make_link("cycle.py", "cycle.py");
    folder.make_link("outside.sh", "../outside");
    folder.make_link("plain", "plain");

    let root = observed(list_tree(&open(&folder), ""));

    for (name, condition, language) in [
        ("cycle.py", Condition::Cycle, Language::Python),
        ("outside.sh", Condition::Outside, Language::Shell),
        ("plain", Condition::Cycle, Language::Plain),
    ] {
        let entry = named(&root, name);
        assert_failed(entry, condition);
        assert_eq!(entry.language, Some(language), "{name}");
    }
}

#[test]
fn test_link_named_like_code_to_a_folder_carries_no_language() {
    let folder = TempDir::new();
    folder.make_folder("src");
    folder.make_link("scripts.py", "src");

    let root = observed(list_tree(&open(&folder), ""));

    let linked_folder = named(&root, "scripts.py");
    assert_folder(linked_folder);
    assert_eq!(linked_folder.language, None);
}
