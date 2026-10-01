//! Layer 2: `select_file` over the committed text fixtures and over temporary folders. A file is
//! text or it cannot be shown as text; a read that cannot happen fails as one of the closed
//! conditions and returns (CP-267 – CP-277).

#[allow(
    dead_code,
    reason = "each test crate uses a subset of the shared helpers"
)]
mod common;

use std::path::PathBuf;
use std::process::Command;

use common::TempDir;
use nozoki_core::{
    CannotDisplayReason, Condition, FileView, ItemState, Language, OpenedFolder, Span, TokenClass,
    highlight, open_folder, select_file,
};

fn open(folder: &TempDir) -> OpenedFolder {
    open_folder(folder.path()).expect("a folder opens")
}

/// The committed fixtures, opened as a folder.
fn fixtures() -> OpenedFolder {
    let path = PathBuf::from(env!("CARGO_MANIFEST_DIR")).join("../../checks/fixtures/text");
    open_folder(path.canonicalize().expect("the fixtures exist")).expect("the fixtures open")
}

/// The content and language of an observed text answer, or a panic naming the answer.
fn text_of(answer: ItemState<FileView>) -> (String, Language) {
    match answer {
        ItemState::Observed(FileView::Text {
            content, language, ..
        }) => (content, language),
        other => panic!("expected observed text, got {other:?}"),
    }
}

#[test]
fn test_fixture_without_extension_is_plain_text() {
    let (content, language) = text_of(select_file(&fixtures(), "README"));

    assert!(content.starts_with("Nozoki reads this file as plain text."));
    assert_eq!(language, Language::Plain);
}

#[test]
fn test_fixture_with_extension_outside_the_set_is_plain_text() {
    let (_, language) = text_of(select_file(&fixtures(), "notes.txt"));

    assert_eq!(language, Language::Plain);
}

#[test]
fn test_shell_script_marker_does_not_choose_a_language() {
    let (content, language) = text_of(select_file(&fixtures(), "run"));

    assert!(content.starts_with("#!/bin/sh"));
    assert_eq!(language, Language::Plain);
}

#[test]
fn test_utf16_fixture_reads_as_text() {
    let (content, _) = text_of(select_file(&fixtures(), "utf16-le.txt"));

    assert_eq!(content, "hi\n");
}

#[test]
fn test_empty_fixture_reads_as_text() {
    let (content, _) = text_of(select_file(&fixtures(), "empty"));

    assert_eq!(content, "");
}

#[test]
fn test_latin1_fixture_is_cannot_display() {
    assert_eq!(
        select_file(&fixtures(), "latin1.txt"),
        ItemState::Observed(FileView::CannotDisplay(CannotDisplayReason::InvalidUtf8))
    );
}

#[test]
fn test_torn_fixture_is_cannot_display() {
    assert_eq!(
        select_file(&fixtures(), "torn-utf8.txt"),
        ItemState::Observed(FileView::CannotDisplay(CannotDisplayReason::InvalidUtf8))
    );
}

#[test]
fn test_select_file_reads_a_file_in_a_subfolder() {
    let folder = TempDir::new();
    folder.write_file("src/lib.rs", "pub fn x() {}\n");

    let (content, _) = text_of(select_file(&open(&folder), "src/lib.rs"));

    assert_eq!(content, "pub fn x() {}\n");
}

#[test]
fn test_fifo_inside_the_root_fails_unreadable_and_returns() {
    let folder = TempDir::new();
    let fifo = folder.path().join("pipe");
    let status = Command::new("mkfifo")
        .arg(&fifo)
        .status()
        .expect("mkfifo runs");
    assert!(status.success(), "mkfifo made the FIFO");

    assert_eq!(
        select_file(&open(&folder), "pipe"),
        ItemState::Failed(Condition::Unreadable)
    );
}

/// CP-270: a link row lists as the file it reaches, so selecting a link whose target is a file inside
/// the opened folder answers that file's verdict, through the link's own name or a link to a folder.
#[test]
fn test_link_to_a_file_inside_the_root_reads_the_file_it_reaches() {
    let folder = TempDir::new();
    folder.write_file("src/lib.rs", "pub fn x() {}\n");
    folder.make_link("lib-link", "src/lib.rs");
    folder.make_link("src-link", "src");
    let opened = open(&folder);

    for requested in ["lib-link", "src-link/lib.rs"] {
        let (content, language) = text_of(select_file(&opened, requested));

        assert_eq!(content, "pub fn x() {}\n", "{requested}");
        assert_eq!(language, Language::Plain, "{requested}");
    }
}

/// CP-289 – CP-292: every example name of the spec, selected through `select_file`, with the language
/// its row names.
#[test]
fn test_select_file_names_the_language_of_each_example_name() {
    let examples = [
        ("archive.tar.json", Language::Json),
        ("Makefile.py.bak", Language::Plain),
        (".bashrc", Language::Plain),
        (".py", Language::Plain),
        ("notes.", Language::Plain),
        ("deploy.yml", Language::Yaml),
        ("deploy.YML", Language::Yaml),
        ("Deploy.YmL", Language::Yaml),
        ("index.js", Language::JavaScript),
        ("index.mjs", Language::JavaScript),
        ("index.cjs", Language::JavaScript),
        ("App.jsx", Language::JavaScript),
        ("stubs.pyi", Language::Python),
        ("gui.pyw", Language::Python),
        ("setup.sh", Language::Shell),
        ("x.bash", Language::Shell),
        ("x.zsh", Language::Shell),
        ("Cargo.toml", Language::Toml),
        ("package.json", Language::Json),
        ("ci.yaml", Language::Yaml),
        ("README.md", Language::Plain),
        ("guide.MARKDOWN", Language::Plain),
        ("main.rs", Language::Plain),
    ];
    let folder = TempDir::new();
    for (name, _) in examples {
        folder.write_file(name, "x\n");
    }
    let opened = open(&folder);

    for (name, expected) in examples {
        let (_, language) = text_of(select_file(&opened, name));

        assert_eq!(language, expected, "{name}");
    }
}

/// CP-291: a language is never taken from content, so Python source in `notes.txt` is plain.
#[test]
fn test_content_never_chooses_the_language() {
    let folder = TempDir::new();
    folder.write_file("notes.txt", "def greet(who):\n    return \"hi\"\n");

    let (_, language) = text_of(select_file(&open(&folder), "notes.txt"));

    assert_eq!(language, Language::Plain);
}

/// CP-291: a file with no extension is plain whatever its first line names, `env` shebangs included.
#[test]
fn test_env_shebang_does_not_choose_a_language() {
    let folder = TempDir::new();
    folder.write_file("run", "#!/usr/bin/env python3\nprint(\"hi\")\n");

    let (_, language) = text_of(select_file(&open(&folder), "run"));

    assert_eq!(language, Language::Plain);
}

/// CP-292: the language comes from the last component of the selected path, so a floor-named file
/// in a folder is its language and a plain-named file in a floor-named folder is plain.
#[test]
fn test_language_comes_from_the_last_path_component() {
    let folder = TempDir::new();
    folder.write_file("pkg/tool.py", "print(1)\n");
    folder.write_file("tool.py/run", "print(1)\n");
    let opened = open(&folder);

    let (_, nested_python) = text_of(select_file(&opened, "pkg/tool.py"));
    let (_, plain_in_python_folder) = text_of(select_file(&opened, "tool.py/run"));

    assert_eq!(nested_python, Language::Python);
    assert_eq!(plain_in_python_folder, Language::Plain);
}

/// CP-292: the language comes from the name the caller selected, never from a link's target.
#[test]
fn test_link_takes_the_language_of_its_own_name() {
    let python_named = TempDir::new();
    python_named.write_file("notes.txt", "plain words\n");
    python_named.make_link("tool.py", "notes.txt");
    let plain_named = TempDir::new();
    plain_named.write_file("tool.py", "print(1)\n");
    plain_named.make_link("notes", "tool.py");

    let (_, from_python_name) = text_of(select_file(&open(&python_named), "tool.py"));
    let (_, from_plain_name) = text_of(select_file(&open(&plain_named), "notes"));

    assert_eq!(from_python_name, Language::Python);
    assert_eq!(from_plain_name, Language::Plain);
}

/// CP-293: naming a language changes nothing else, so a `.py` that is not text carries none.
#[test]
fn test_non_text_floor_file_carries_no_language() {
    let folder = TempDir::new();
    std::fs::write(folder.path().join("legacy.py"), [0x63, 0x61, 0x66, 0xE9])
        .expect("the file can be written");

    assert_eq!(
        select_file(&open(&folder), "legacy.py"),
        ItemState::Observed(FileView::CannotDisplay(CannotDisplayReason::InvalidUtf8))
    );
}

/// CP-293, CP-306: a text floor file keeps its content and language, and now also carries the
/// spans the highlighter yields for that content.
#[test]
fn test_select_file_text_form_keeps_unchanged_content_and_language() {
    let folder = TempDir::new();
    folder.write_file("app.py", "print(\"hi\")\n");

    assert_eq!(
        select_file(&open(&folder), "app.py"),
        ItemState::Observed(FileView::Text {
            content: "print(\"hi\")\n".to_string(),
            language: Language::Python,
            spans: vec![
                Span {
                    start: 0,
                    end: 5,
                    class: TokenClass::Name
                },
                Span {
                    start: 6,
                    end: 10,
                    class: TokenClass::String
                },
            ],
        })
    );
}

/// CP-305, CP-306: for each committed highlight sample the text form carries exactly the spans the
/// highlighter yields for the content and language the answer carries; plain text carries none.
#[test]
fn test_select_file_spans_equal_the_highlighter_for_each_floor_sample() {
    let path = PathBuf::from(env!("CARGO_MANIFEST_DIR")).join("../../checks/fixtures/highlight");
    let samples = open_folder(path.canonicalize().expect("the samples exist"))
        .expect("the samples open");
    let expected = [
        ("sample.py", Language::Python),
        ("sample.sh", Language::Shell),
        ("sample.js", Language::JavaScript),
        ("sample.json", Language::Json),
        ("sample.yaml", Language::Yaml),
        ("sample.toml", Language::Toml),
        ("plain.txt", Language::Plain),
    ];

    for (name, expected_language) in expected {
        let ItemState::Observed(FileView::Text {
            content,
            language,
            spans,
        }) = select_file(&samples, name)
        else {
            panic!("{name} is not observed text");
        };

        assert_eq!(language, expected_language, "{name}");
        assert_eq!(spans, highlight(&content, language), "{name}");
        if language == Language::Plain {
            assert!(spans.is_empty(), "{name} carries no spans");
        } else {
            assert!(!spans.is_empty(), "{name} carries spans");
        }
    }
}
