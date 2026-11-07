//! Layer 2: the file answer across the bridge, over temporary folders and the committed text
//! fixtures. The wire is one JSON object tagged by `state`, with exactly the members the state names
//! (CP-267 – CP-271).

#[allow(
    dead_code,
    reason = "each test crate uses a subset of the shared helpers"
)]
mod common;

use std::collections::hash_map::DefaultHasher;
use std::fs;
use std::hash::{Hash, Hasher};
use std::path::PathBuf;

use common::TempDir;
use ka_reader_bridge::session::{FileAct, Session};
use ka_reader_core::{Language, ReadingPosition, TokenClass, highlight};
use serde_json::{Value, json};

/// Fixture M (CP-317): characters 2, 3 and 4 bytes wide before a span and inside one; 36 bytes.
const FIXTURE_M: &str = "# café 日本 🙂\nname = \"é🙂\"\n";

/// One span on the wire.
fn span(start: usize, end: usize, class: &str) -> Value {
    json!({ "start": start, "end": end, "class": class })
}

/// The wire name of a token class, spelled by the test and never read off the bridge.
fn class_name(class: TokenClass) -> &'static str {
    match class {
        TokenClass::Keyword => "keyword",
        TokenClass::String => "string",
        TokenClass::Number => "number",
        TokenClass::Comment => "comment",
        TokenClass::Name => "name",
    }
}

fn opened(folder: &std::path::Path) -> Session {
    let session = Session::default();
    session.open(folder.to_path_buf());
    session
}

/// The open act a click makes, at the top.
fn open_act() -> Option<FileAct> {
    Some(FileAct::Open(ReadingPosition::new(b"top".as_slice())))
}

fn wire(session: &Session, path: &str) -> Value {
    serde_json::to_value(session.select_file(path, open_act())).expect("the answer serializes")
}

#[test]
fn test_select_file_before_any_open_answers_pending() {
    assert_eq!(
        wire(&Session::default(), "a.txt"),
        json!({ "state": "pending" })
    );
}

#[test]
fn test_select_file_answers_text_exactly() {
    let folder = TempDir::new();
    folder.write_file("a.txt", "héllo\n");

    assert_eq!(
        wire(&opened(folder.path()), "a.txt"),
        json!({ "state": "text", "content": "héllo\n", "language": "plain" })
    );
}

/// CP-305, CP-306: a Python file answers its own language and its spans, whole.
#[test]
fn test_select_file_answers_python_with_its_spans() {
    let folder = TempDir::new();
    folder.write_file("app.py", "print(\"hi\")\n");

    assert_eq!(
        wire(&opened(folder.path()), "app.py"),
        json!({
            "state": "text",
            "content": "print(\"hi\")\n",
            "language": "python",
            "spans": [span(0, 5, "name"), span(6, 10, "string")]
        })
    );
}

/// CP-305, CP-306: a TOML file answers its own language and its spans, whole.
#[test]
fn test_select_file_answers_toml_with_its_spans() {
    let folder = TempDir::new();
    folder.write_file("config.toml", "title = \"hi\"\n");

    assert_eq!(
        wire(&opened(folder.path()), "config.toml"),
        json!({
            "state": "text",
            "content": "title = \"hi\"\n",
            "language": "toml",
            "spans": [span(0, 5, "name"), span(8, 12, "string")]
        })
    );
}

/// CP-305, CP-306: the other four floor languages, each with the spans the core's highlighter
/// yields for the same content (the oracle CP-306 is defined against, not the bridge's own output).
#[test]
fn test_select_file_answers_every_other_floor_language_with_its_spans() {
    let samples = PathBuf::from(env!("CARGO_MANIFEST_DIR")).join("../../checks/fixtures/highlight");
    let cases = [
        ("index.js", "sample.js", Language::JavaScript, "javascript"),
        ("run.sh", "sample.sh", Language::Shell, "shell"),
        ("ci.yml", "sample.yaml", Language::Yaml, "yaml"),
        ("package.json", "sample.json", Language::Json, "json"),
    ];
    let folder = TempDir::new();
    let session = opened(folder.path());
    for (name, sample, _, _) in cases {
        folder.write_file(
            name,
            &fs::read_to_string(samples.join(sample)).expect("sample"),
        );
    }

    for (name, sample, language, wire_name) in cases {
        let content = fs::read_to_string(samples.join(sample)).expect("the sample is UTF-8");
        let spans: Vec<Value> = highlight(&content, language)
            .iter()
            .map(|found| span(found.start, found.end, class_name(found.class)))
            .collect();
        assert!(!spans.is_empty(), "{name} has spans to compare");

        assert_eq!(
            wire(&session, name),
            json!({
                "state": "text",
                "content": content,
                "language": wire_name,
                "spans": spans
            }),
            "{name}"
        );
    }
}

/// CP-306, CP-307: fixture M answers byte for byte the wire file the shell's suite decodes.
#[test]
fn test_select_file_answers_fixture_m_byte_for_byte() {
    let folder = TempDir::new();
    folder.write_file("m.py", FIXTURE_M);
    let committed = fs::read_to_string(
        PathBuf::from(env!("CARGO_MANIFEST_DIR")).join("tests/fixtures/m_answer.json"),
    )
    .expect("the shared wire file exists");

    let serialized = serde_json::to_string(&opened(folder.path()).select_file("m.py", open_act()))
        .expect("the answer serializes");

    assert_eq!(serialized, committed);
}

/// CP-307: a UTF-8 byte-order mark is not counted, so M's spans are M's and the first starts at 0.
#[test]
fn test_select_file_counts_offsets_without_the_utf8_byte_order_mark() {
    let folder = TempDir::new();
    let mut bytes = vec![0xEF, 0xBB, 0xBF];
    bytes.extend_from_slice(FIXTURE_M.as_bytes());
    fs::write(folder.path().join("m.py"), bytes).expect("written");

    assert_eq!(
        wire(&opened(folder.path()), "m.py"),
        json!({
            "state": "text",
            "content": FIXTURE_M,
            "language": "python",
            "spans": [span(0, 19, "comment"), span(27, 35, "string")]
        })
    );
}

/// CP-307: offsets count the decoded content's UTF-8 bytes, never the UTF-16 bytes on disk.
#[test]
fn test_select_file_counts_offsets_of_the_decoded_content_for_utf16() {
    let folder = TempDir::new();
    let text = "x = 1\n";
    let mut bytes = vec![0xFF, 0xFE];
    bytes.extend(text.encode_utf16().flat_map(u16::to_le_bytes));
    fs::write(folder.path().join("u.py"), bytes).expect("written");
    folder.write_file("v.py", text);
    let session = opened(folder.path());

    let utf16 = wire(&session, "u.py");

    assert_eq!(utf16["language"], "python");
    assert_eq!(utf16, wire(&session, "v.py"));
}

/// CP-306: a floor-language file with no tokens still carries its (empty) spans member.
#[test]
fn test_select_file_answers_an_empty_span_list_for_json_with_no_tokens() {
    let folder = TempDir::new();
    folder.write_file("x.json", "{}");

    assert_eq!(
        wire(&opened(folder.path()), "x.json"),
        json!({ "state": "text", "content": "{}", "language": "json", "spans": [] })
    );
}

/// CP-306: an empty Python file is `python` with empty content and an empty span list.
#[test]
fn test_select_file_answers_an_empty_span_list_for_an_empty_python_file() {
    let folder = TempDir::new();
    folder.write_file("empty.py", "");

    assert_eq!(
        wire(&opened(folder.path()), "empty.py"),
        json!({ "state": "text", "content": "", "language": "python", "spans": [] })
    );
}

/// CP-305, CP-308: a plain answer has exactly its three members, whatever the name or first line.
#[test]
fn test_select_file_answers_plain_with_exactly_three_members() {
    let folder = TempDir::new();
    folder.write_file("notes.txt", "words\n");
    folder.write_file("run", "#!/bin/sh\necho hi\n");
    let session = opened(folder.path());

    for (name, content) in [("notes.txt", "words\n"), ("run", "#!/bin/sh\necho hi\n")] {
        assert_eq!(
            wire(&session, name),
            json!({ "state": "text", "content": content, "language": "plain" }),
            "{name}"
        );
    }
}

/// CP-1100: a Markdown file's answer keeps the tag `markdown` and carries the document as `blocks`,
/// and those are its only members, whatever the extension.
#[test]
fn test_select_file_export_answers_markdown_with_the_state_and_blocks_alone() {
    let folder = TempDir::new();
    folder.write_file("README.md", "# title\n\nSome *words*.\n");
    folder.write_file("guide.markdown", "plain words\n");
    let session = opened(folder.path());

    let readme = wire(&session, "README.md");
    assert_eq!(
        readme,
        json!({ "state": "markdown", "blocks": [
            { "kind": "heading", "level": 1, "content": [{ "kind": "text", "text": "title" }] },
            { "kind": "paragraph", "content": [
                { "kind": "text", "text": "Some " },
                { "kind": "emphasis", "strength": "single",
                  "content": [{ "kind": "text", "text": "words" }] },
                { "kind": "text", "text": "." },
            ] },
        ] })
    );
    let guide = wire(&session, "guide.markdown");
    assert_eq!(
        guide,
        json!({ "state": "markdown", "blocks": [
            { "kind": "paragraph", "content": [{ "kind": "text", "text": "plain words" }] },
        ] })
    );
    for answer in [&readme, &guide] {
        let members: Vec<&String> = answer.as_object().expect("an object").keys().collect();
        assert_eq!(members, vec!["blocks", "state"]);
    }
}

/// CP-1100, Examples row 1: the hostile scene answers every block in source order. Raw HTML is text,
/// the PNG is resolved, the remote, `..` and symlink-out images are outside the folder, the SVG is a
/// format not decoded, and the two links are one external and one relative.
#[test]
fn test_select_file_on_the_hostile_scene_answers_every_block_in_source_order() {
    let folder = TempDir::new();
    let outside = TempDir::new();
    let target = outside.write_file("secret.png", "not for the page");
    let corpus = fs::read_to_string(
        PathBuf::from(env!("CARGO_MANIFEST_DIR")).join("../../checks/fixtures/hostile.md"),
    )
    .expect("the committed corpus reads");
    folder.write_file("hostile.md", &corpus);
    folder.write_bytes(
        "logo.png",
        &[0x89, b'P', b'N', b'G', 0x0D, 0x0A, 0x1A, 0x0A],
    );
    folder.write_file(
        "diagram.svg",
        "<svg xmlns=\"http://www.w3.org/2000/svg\"/>\n",
    );
    folder.make_link("escape.png", target);
    folder.write_file("other.md", "# Other\n");
    let session = opened(folder.path());

    let answer = wire(&session, "hostile.md");

    let members: Vec<&String> = answer.as_object().expect("an object").keys().collect();
    assert_eq!(members, vec!["blocks", "state"]);
    let blocks = answer["blocks"].as_array().expect("blocks");
    let kinds: Vec<&str> = blocks
        .iter()
        .map(|block| block["kind"].as_str().expect("a kind"))
        .collect();
    // One heading, then one paragraph block for each of the file's seventeen paragraphs and raw blocks, in source order.
    let mut expected_kinds = vec!["heading"];
    expected_kinds.extend(std::iter::repeat_n("paragraph", 17));
    assert_eq!(kinds, expected_kinds);

    let mut inlines = Vec::new();
    collect_inlines(&answer["blocks"], &mut inlines);
    let text_nodes: Vec<&str> = inlines
        .iter()
        .filter(|inline| inline["kind"] == "text")
        .map(|inline| inline["text"].as_str().expect("text"))
        .collect();
    for piece in [
        "<script>alert(1)</script>",
        "<b onclick=\"steal()\">",
        "<iframe src=\"https://example.com/frame\"></iframe>",
        "<style>body { display: none }</style>",
    ] {
        assert!(
            text_nodes.iter().any(|node| node.trim_end() == piece),
            "{piece} is a text node holding exactly its source: {text_nodes:?}"
        );
    }
    assert!(
        text_nodes
            .iter()
            .any(|node| node.starts_with("<div class=\"box\">") && node.contains("</div>")),
        "the raw block is a text node holding its source: {text_nodes:?}"
    );
    assert!(inlines.iter().all(|inline| {
        !["image", "link"].contains(&inline["kind"].as_str().unwrap_or(""))
            || inline.get("target").is_some()
    }));

    let images: Vec<&Value> = inlines
        .iter()
        .copied()
        .filter(|i| i["kind"] == "image")
        .collect();
    let target_of = |source: &str| -> Value {
        let found = images
            .iter()
            .find(|image| image["alt"] == source)
            .unwrap_or_else(|| panic!("an image with alt {source}"));
        (*found).clone()
    };
    assert_eq!(
        target_of("logo"),
        json!({ "kind": "image", "alt": "logo", "target": "resolved", "path": "logo.png" })
    );
    for (alt, source) in [
        ("remote", "https://example.com/remote.png"),
        ("climb", "../outside.png"),
        ("escape", "escape.png"),
    ] {
        assert_eq!(
            target_of(alt),
            json!({ "kind": "image", "alt": alt, "target": "placeholder",
                    "condition": "outside_the_folder", "source": source }),
            "{alt}"
        );
    }
    assert_eq!(
        target_of("diagram"),
        json!({ "kind": "image", "alt": "diagram", "target": "placeholder",
                "condition": "format_not_decoded", "source": "diagram.svg" })
    );

    let links: Vec<&Value> = inlines
        .iter()
        .copied()
        .filter(|i| i["kind"] == "link")
        .collect();
    assert_eq!(links.len(), 2);
    assert_eq!(links[0]["target"], "external");
    assert_eq!(links[0]["destination"], "https://example.com/page");
    assert!(links[0].get("path").is_none());
    assert_eq!(links[1]["target"], "relative");
    assert_eq!(links[1]["path"], "other.md");
}

/// Every inline of `blocks`, depth first, in source order.
fn collect_inlines<'a>(blocks: &'a Value, found: &mut Vec<&'a Value>) {
    for block in blocks.as_array().expect("an array of blocks") {
        if let Some(content) = block.get("content") {
            collect_inline_nodes(content, found);
        }
    }
}

fn collect_inline_nodes<'a>(content: &'a Value, found: &mut Vec<&'a Value>) {
    for inline in content.as_array().expect("an array of inlines") {
        found.push(inline);
        if let Some(inner) = inline.get("content") {
            collect_inline_nodes(inner, found);
        }
    }
}

/// CP-308: a floor-named file that is not text carries no language and no spans.
#[test]
fn test_select_file_answers_cannot_display_for_a_non_text_python_file() {
    let folder = TempDir::new();
    fs::write(folder.path().join("legacy.py"), [0x63, 0x61, 0x66, 0xE9]).expect("written");

    assert_eq!(
        wire(&opened(folder.path()), "legacy.py"),
        json!({ "state": "cannot_display", "reason": "invalid_utf8" })
    );
}

#[test]
fn test_select_file_answers_cannot_display_exactly() {
    let folder = TempDir::new();
    fs::write(folder.path().join("latin1.txt"), [0x63, 0x61, 0x66, 0xE9]).expect("written");

    assert_eq!(
        wire(&opened(folder.path()), "latin1.txt"),
        json!({ "state": "cannot_display", "reason": "invalid_utf8" })
    );
}

#[test]
fn test_select_file_answers_cannot_display_for_utf16_exactly() {
    let folder = TempDir::new();
    fs::write(
        folder.path().join("odd.txt"),
        [0xFF, 0xFE, 0x68, 0x00, 0x69],
    )
    .expect("written");

    assert_eq!(
        wire(&opened(folder.path()), "odd.txt"),
        json!({ "state": "cannot_display", "reason": "invalid_utf16" })
    );
}

#[test]
fn test_select_file_answers_failed_exactly() {
    let folder = TempDir::new();

    assert_eq!(
        wire(&opened(folder.path()), "../x"),
        json!({ "state": "failed", "condition": "outside" })
    );
}

#[test]
fn test_select_file_carries_every_condition_by_its_wire_name() {
    let folder = TempDir::new();
    folder.make_folder("dir");
    folder.make_link("dangling", "nowhere");
    let session = opened(folder.path());

    assert_eq!(
        wire(&session, "dir"),
        json!({ "state": "failed", "condition": "unreadable" })
    );
    assert_eq!(
        wire(&session, "dangling"),
        json!({ "state": "failed", "condition": "missing" })
    );
}

#[test]
fn test_reading_every_text_fixture_leaves_its_bytes_unchanged() {
    let fixtures = PathBuf::from(env!("CARGO_MANIFEST_DIR"))
        .join("../../checks/fixtures/text")
        .canonicalize()
        .expect("the fixtures exist");
    let session = opened(&fixtures);
    let mut read = 0;

    for entry in fs::read_dir(&fixtures).expect("the fixtures list") {
        let entry = entry.expect("an entry");
        let name = entry.file_name().into_string().expect("a UTF-8 name");
        let before = digest(&fs::read(entry.path()).expect("readable"));

        let answer = wire(&session, &name);

        assert_ne!(answer["state"], "pending", "{name} was read");
        assert_ne!(answer["state"], "failed", "{name} was read");
        assert_eq!(
            before,
            digest(&fs::read(entry.path()).expect("readable")),
            "{name}"
        );
        read += 1;
    }
    assert!(read >= 7, "the seven fixtures were all read, got {read}");
}

fn digest(bytes: &[u8]) -> u64 {
    let mut hasher = DefaultHasher::new();
    bytes.hash(&mut hasher);
    hasher.finish()
}
