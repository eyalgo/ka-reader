//! Layer 2: the SM-5 API (`open_folder`, `list_tree`) over temporary folders.

mod common;

use std::os::unix::net::UnixListener;

use common::TempDir;
use nozoki_core::{
    Condition, Entry, EntryKind, ItemState, Language, OpenFolderOutcome, list_tree, open_folder,
};

/// The name, kind and state of every entry, in the order the answer carries them. Nothing is
/// re-sorted here, so a test sees the order CP-168 defines and not one it made up.
fn names_and_kinds(listing: ItemState<Vec<Entry>>) -> Vec<(String, EntryKind, ItemState<()>)> {
    let ItemState::Observed(entries) = listing else {
        panic!("expected an Observed answer, got {listing:?}");
    };
    entries
        .into_iter()
        .map(
            |Entry {
                 name, kind, state, ..
             }| (name, kind, state),
        )
        .collect()
}

/// A folder entry arrives `Pending` and any other entry `Observed`, as CP-170 and CP-169 fix.
fn pair(name: &str, kind: EntryKind) -> (String, EntryKind, ItemState<()>) {
    let state = match kind {
        EntryKind::Folder => ItemState::Pending,
        EntryKind::File => ItemState::Observed(()),
    };
    (name.to_string(), kind, state)
}

fn failed(condition: Condition) -> ItemState<Vec<Entry>> {
    ItemState::Failed(condition)
}

#[test]
fn list_root_returns_every_entry_including_hidden_and_git() {
    let folder = TempDir::new();
    folder.write_file(".env", "SECRET=1");
    folder.make_folder(".git");
    folder.make_folder("src");
    folder.write_file("README.md", "hello");
    folder.make_folder("locked");
    folder.set_mode("locked", 0o000);
    let opened = open_folder(folder.path()).expect("a folder opens");

    let listed = names_and_kinds(list_tree(&opened, ""));

    // A folder that cannot be read is still a `Pending` folder here: listing it is a later read.
    assert_eq!(
        listed,
        vec![
            pair(".git", EntryKind::Folder),
            pair("locked", EntryKind::Folder),
            pair("src", EntryKind::Folder),
            pair(".env", EntryKind::File),
            pair("README.md", EntryKind::File),
        ],
        "folders first, then files, each group by name without regard to case (CP-168)"
    );
}

/// CP-168, Ex. 1 without `readme`: `readme` cannot share a folder with `Readme` on a
/// case-insensitive volume, so the tie between them is proved at unit level.
#[test]
fn the_root_lists_folders_first_then_by_name_without_regard_to_case() {
    let folder = TempDir::new();
    folder.make_folder("B");
    folder.make_folder("a");
    folder.write_file("file10", "");
    folder.write_file("file2", "");
    folder.write_file(".dot", "");
    folder.write_file("Readme", "");
    let opened = open_folder(folder.path()).expect("a folder opens");

    let names: Vec<String> = names_and_kinds(list_tree(&opened, ""))
        .into_iter()
        .map(|triple| triple.0)
        .collect();

    assert_eq!(names, ["a", "B", ".dot", "file10", "file2", "Readme"]);
}

/// CP-168, Ex. 2: digits compare as characters and `_` (U+005F) precedes a lowercase letter.
#[test]
fn an_underscore_name_precedes_a_letter() {
    let folder = TempDir::new();
    folder.write_file("apple", "");
    folder.write_file("_notes", "");
    let opened = open_folder(folder.path()).expect("a folder opens");

    let names: Vec<String> = names_and_kinds(list_tree(&opened, ""))
        .into_iter()
        .map(|triple| triple.0)
        .collect();

    assert_eq!(names, ["_notes", "apple"]);
}

/// CP-168, Ex. 3: names compare on their lowercase forms, so `ecrit` precedes `Écrit`. The accented
/// name is spelled with an escape so the source file's normalization cannot change it.
#[test]
fn a_lowercase_fold_puts_ecrit_before_the_accented_name() {
    let folder = TempDir::new();
    folder.write_file("\u{C9}crit", "");
    folder.write_file("ecrit", "");
    let opened = open_folder(folder.path()).expect("a folder opens");

    let names: Vec<String> = names_and_kinds(list_tree(&opened, ""))
        .into_iter()
        .map(|triple| triple.0)
        .collect();

    assert_eq!(names, ["ecrit", "\u{C9}crit"]);
}

#[test]
fn a_socket_lists_as_an_observed_file() {
    let folder = TempDir::new();
    // The path limit of a Unix socket is 104 bytes, so the name stays short.
    let _socket = UnixListener::bind(folder.path().join("s.sock")).expect("the socket binds");
    let opened = open_folder(folder.path()).expect("a folder opens");

    assert_eq!(
        names_and_kinds(list_tree(&opened, "")),
        vec![pair("s.sock", EntryKind::File)]
    );
}

#[test]
fn a_locked_folder_fails_then_lists_once_readable() {
    let folder = TempDir::new();
    folder.write_file("locked/inner.txt", "");
    folder.set_mode("locked", 0o000);
    let opened = open_folder(folder.path()).expect("a folder opens");

    assert_eq!(list_tree(&opened, "locked"), failed(Condition::Unreadable));

    folder.set_mode("locked", 0o755);

    assert_eq!(
        names_and_kinds(list_tree(&opened, "locked")),
        vec![pair("inner.txt", EntryKind::File)],
        "nothing is carried over from the failed read"
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
fn list_outside_paths_is_failed_outside() {
    let folder = TempDir::new();
    folder.make_folder("src");
    let outside = TempDir::new();
    outside.write_file("secret.txt", "");
    folder.make_link("escape", outside.path());
    let opened = open_folder(folder.path()).expect("a folder opens");

    for requested in ["/etc", "..", "../x", "escape"] {
        assert_eq!(
            list_tree(&opened, requested),
            failed(Condition::Outside),
            "{requested} must be Failed(Outside)"
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

    for (requested, condition) in [
        ("a-file", Condition::NotAFolder),
        ("gone", Condition::Missing),
        ("locked", Condition::Unreadable),
    ] {
        assert_eq!(
            list_tree(&opened, requested),
            failed(condition),
            "{requested} must be Failed({condition:?})"
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
fn an_empty_folder_is_observed_with_no_entries() {
    let folder = TempDir::new();
    folder.make_folder("empty");
    let opened = open_folder(folder.path()).expect("a folder opens");

    assert_eq!(
        list_tree(&opened, "empty"),
        ItemState::Observed(Vec::new()),
        "an empty folder is read and holds nothing, which is not a failure"
    );
}

#[test]
fn open_folder_on_a_file_or_missing_path_is_not_opened() {
    let folder = TempDir::new();
    let file = folder.write_file("a-file", "");

    assert!(matches!(open_folder(file), OpenFolderOutcome::Failed(_)));
    assert!(matches!(
        open_folder(folder.path().join("missing")),
        OpenFolderOutcome::Failed(_)
    ));
}

#[test]
fn open_folder_on_an_unreadable_folder_returns_the_closed_failure() {
    let folder = TempDir::new();
    folder.make_folder("locked");
    folder.set_mode("locked", 0o000);

    assert_eq!(
        open_folder(folder.path().join("locked")),
        OpenFolderOutcome::Failed(nozoki_core::OpenFailure::Unreadable)
    );
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

/// The language every entry of an observed listing carries, by name. A file always carries one and
/// a folder never does, so the pairing of kind and language is asserted on every entry on the way.
fn languages_by_name(listing: ItemState<Vec<Entry>>) -> Vec<(String, Option<Language>)> {
    let ItemState::Observed(entries) = listing else {
        panic!("expected an Observed answer, got {listing:?}");
    };
    entries
        .into_iter()
        .map(|entry| {
            assert_eq!(
                entry.language.is_some(),
                entry.kind == EntryKind::File,
                "a file carries a language and a folder carries none: {entry:?}"
            );
            (entry.name, entry.language)
        })
        .collect()
}

/// The language the listing carries for `name`, or a panic naming the names that were there.
fn language_listed(listed: &[(String, Option<Language>)], name: &str) -> Option<Language> {
    listed
        .iter()
        .find(|(listed_name, _)| listed_name == name)
        .unwrap_or_else(|| panic!("no entry called {name}: {listed:?}"))
        .1
}

/// Every name the table sends to a language other than plain, with that language: the six floor
/// names, their alternate extensions, mixed case, and the last extension of a dotted name.
const NAMES_WITH_A_FLOOR_LANGUAGE: [(&str, Language); 18] = [
    ("setup.sh", Language::Shell),
    ("app.py", Language::Python),
    ("index.js", Language::JavaScript),
    ("package.json", Language::Json),
    ("deploy.yml", Language::Yaml),
    ("Cargo.toml", Language::Toml),
    ("stubs.pyi", Language::Python),
    ("gui.pyw", Language::Python),
    ("x.bash", Language::Shell),
    ("x.zsh", Language::Shell),
    ("index.mjs", Language::JavaScript),
    ("index.cjs", Language::JavaScript),
    ("App.jsx", Language::JavaScript),
    ("ci.yaml", Language::Yaml),
    ("Deploy.YmL", Language::Yaml),
    ("RUN.SH", Language::Shell),
    ("x.Py", Language::Python),
    ("archive.tar.json", Language::Json),
];

/// Every file name the table sends to plain: outside the set, no extension, Markdown, a name whose
/// last extension is not a floor one, and an extension the case rule does not reach.
const NAMES_WITH_NO_FLOOR_LANGUAGE: [&str; 12] = [
    "notes.txt",
    "main.rs",
    "README",
    "Makefile",
    ".bashrc",
    ".py",
    "notes.",
    "README.md",
    "guide.markdown",
    "notes.MARKDOWN",
    "x.ſh",
    "Makefile.py.bak",
];

/// A-1: a listed file entry carries the language the core gives its name, whatever its state.
///
/// `Deploy.YmL` is listed from a folder of its own: on a case-insensitive volume it is the same
/// file as `deploy.yml`, and the two cannot share a folder.
#[test]
fn test_listed_floor_names_carry_their_language() {
    let folder = TempDir::new();
    let mixed_case_folder = TempDir::new();
    for (name, _) in NAMES_WITH_A_FLOOR_LANGUAGE {
        let home = if name == "Deploy.YmL" {
            &mixed_case_folder
        } else {
            &folder
        };
        home.write_file(name, "");
    }
    let mut listed = languages_by_name(list_tree(
        &open_folder(folder.path()).expect("a folder opens"),
        "",
    ));
    listed.extend(languages_by_name(list_tree(
        &open_folder(mixed_case_folder.path()).expect("a folder opens"),
        "",
    )));

    for (name, language) in NAMES_WITH_A_FLOOR_LANGUAGE {
        assert_eq!(language_listed(&listed, name), Some(language), "{name}");
    }
}

/// A-3: any other file name, Markdown included, is plain, and plain is a language of its own.
#[test]
fn test_listed_other_names_carry_plain() {
    let folder = TempDir::new();
    for name in NAMES_WITH_NO_FLOOR_LANGUAGE {
        folder.write_file(name, "");
    }
    let opened = open_folder(folder.path()).expect("a folder opens");

    let listed = languages_by_name(list_tree(&opened, ""));

    for name in NAMES_WITH_NO_FLOOR_LANGUAGE {
        assert_eq!(
            language_listed(&listed, name),
            Some(Language::Plain),
            "{name}"
        );
    }
}

/// A-1: a folder carries no language, even when its name is a floor name.
#[test]
fn test_listed_folder_named_like_code_carries_no_language() {
    let folder = TempDir::new();
    folder.make_folder("scripts.py");
    folder.write_file("app.py", "");
    let opened = open_folder(folder.path()).expect("a folder opens");

    let listed = languages_by_name(list_tree(&opened, ""));

    assert_eq!(language_listed(&listed, "scripts.py"), None);
    assert_eq!(language_listed(&listed, "app.py"), Some(Language::Python));
}

/// A-5: the name decides, never the content. A shebang does not make a file shell, and prose does
/// not stop a `.py` being Python.
#[test]
fn test_shebang_file_carries_plain_and_prose_py_carries_python() {
    let folder = TempDir::new();
    folder.write_file("run", "#!/usr/bin/env python3\nprint('hi')\n");
    folder.write_file("tool.py", "this is only prose\n");
    let opened = open_folder(folder.path()).expect("a folder opens");

    let listed = languages_by_name(list_tree(&opened, ""));

    assert_eq!(language_listed(&listed, "run"), Some(Language::Plain));
    assert_eq!(language_listed(&listed, "tool.py"), Some(Language::Python));
}

/// A-1: a nested listing follows the same rule as the root's.
#[test]
fn test_nested_listing_uses_the_same_rule() {
    let folder = TempDir::new();
    folder.write_file("src/lib.py", "");
    folder.write_file("src/notes.txt", "");
    let opened = open_folder(folder.path()).expect("a folder opens");

    let listed = languages_by_name(list_tree(&opened, "src"));

    assert_eq!(language_listed(&listed, "lib.py"), Some(Language::Python));
    assert_eq!(language_listed(&listed, "notes.txt"), Some(Language::Plain));
}
