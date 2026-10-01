//! Layer 2: `highlight` over the committed fixtures, one per floor language, and over the texts CP-298
//! names. Every case first passes the span checker (CP-296); the fixture cases then check the anchors
//! and exclusions of CP-299 (CP-295 – CP-299).

use std::fs;
use std::path::PathBuf;

use nozoki_core::{Language, Span, TokenClass, highlight};

const EVERY_LANGUAGE: [Language; 7] = [
    Language::Python,
    Language::Shell,
    Language::JavaScript,
    Language::Json,
    Language::Yaml,
    Language::Toml,
    Language::Plain,
];

/// The committed fixture `name`, read as text.
fn fixture(name: &str) -> String {
    let path = PathBuf::from(env!("CARGO_MANIFEST_DIR"))
        .join("../../checks/fixtures/highlight")
        .join(name);
    fs::read_to_string(path).expect("the fixture exists and is UTF-8")
}

/// CP-296 on every span: a non-empty byte range inside the text, both ends on character boundaries,
/// and each span starting at or after the end of the one before it.
fn assert_spans_well_formed(text: &str, spans: &[Span]) {
    let mut previous_end = 0;
    for span in spans {
        assert!(span.start < span.end, "{span:?} is empty or reversed");
        assert!(span.end <= text.len(), "{span:?} runs past the text");
        assert!(
            text.is_char_boundary(span.start),
            "{span:?} starts mid-character"
        );
        assert!(
            text.is_char_boundary(span.end),
            "{span:?} ends mid-character"
        );
        assert!(
            span.start >= previous_end,
            "{span:?} overlaps the span before it"
        );
        previous_end = span.end;
    }
}

/// The class of the span holding byte `index`, if any span does.
fn class_at(spans: &[Span], index: usize) -> Option<TokenClass> {
    spans
        .iter()
        .find(|span| span.start <= index && index < span.end)
        .map(|span| span.class)
}

/// CP-299: every byte of the first occurrence of `anchor` lies inside a span of `class`.
fn assert_anchor(text: &str, spans: &[Span], anchor: &str, class: TokenClass) {
    let start = text
        .find(anchor)
        .unwrap_or_else(|| panic!("the fixture holds `{anchor}`"));
    for index in start..start + anchor.len() {
        assert_eq!(
            class_at(spans, index),
            Some(class),
            "byte {index} of `{anchor}` should be {class:?}"
        );
    }
}

/// CP-299: no byte of `text` that is one of `punctuation` lies inside any span.
fn assert_no_span_on(text: &str, spans: &[Span], punctuation: &[u8]) {
    for (index, byte) in text.bytes().enumerate() {
        if punctuation.contains(&byte) {
            assert_eq!(
                class_at(spans, index),
                None,
                "`{}` at byte {index} is punctuation and takes no class",
                byte as char
            );
        }
    }
}

fn highlighted(text: &str, language: Language) -> Vec<Span> {
    let spans = highlight(text, language);
    assert_spans_well_formed(text, &spans);
    spans
}

#[test]
fn test_python_fixture_has_its_anchor_classes() {
    let text = fixture("sample.py");
    let spans = highlighted(&text, Language::Python);

    assert_anchor(&text, &spans, "def", TokenClass::Keyword);
    assert_anchor(&text, &spans, "greet", TokenClass::Name);
    assert_anchor(&text, &spans, "hi", TokenClass::String);
    assert_anchor(&text, &spans, "42", TokenClass::Number);
    assert_anchor(&text, &spans, "note", TokenClass::Comment);
    let signature = text.lines().next().expect("the fixture has a first line");
    assert_eq!(signature, "def greet(who):");
    assert_no_span_on(&text[..signature.len()], &spans, b"():");
}

#[test]
fn test_shell_fixture_has_its_anchor_classes() {
    let text = fixture("sample.sh");
    let spans = highlighted(&text, Language::Shell);

    assert_anchor(&text, &spans, "if", TokenClass::Keyword);
    assert_anchor(&text, &spans, "then", TokenClass::Keyword);
    assert_anchor(&text, &spans, "fi", TokenClass::Keyword);
    assert_anchor(&text, &spans, "hi", TokenClass::String);
    assert_anchor(&text, &spans, "note", TokenClass::Comment);
}

#[test]
fn test_javascript_fixture_has_its_anchor_classes() {
    let text = fixture("sample.js");
    let spans = highlighted(&text, Language::JavaScript);

    assert_anchor(&text, &spans, "function", TokenClass::Keyword);
    assert_anchor(&text, &spans, "greet", TokenClass::Name);
    assert_anchor(&text, &spans, "hi", TokenClass::String);
    assert_anchor(&text, &spans, "42", TokenClass::Number);
    assert_anchor(&text, &spans, "note", TokenClass::Comment);
}

#[test]
fn test_json_fixture_has_its_anchor_classes() {
    let text = fixture("sample.json");
    let spans = highlighted(&text, Language::Json);

    assert_anchor(&text, &spans, "title", TokenClass::Name);
    assert_anchor(&text, &spans, "count", TokenClass::Name);
    assert_anchor(&text, &spans, "hi", TokenClass::String);
    assert_anchor(&text, &spans, "42", TokenClass::Number);
    assert_no_span_on(&text, &spans, b"{}:,");
}

#[test]
fn test_yaml_fixture_has_its_anchor_classes() {
    let text = fixture("sample.yaml");
    let spans = highlighted(&text, Language::Yaml);

    assert_anchor(&text, &spans, "title", TokenClass::Name);
    assert_anchor(&text, &spans, "hi", TokenClass::String);
    assert_anchor(&text, &spans, "42", TokenClass::Number);
    assert_anchor(&text, &spans, "note", TokenClass::Comment);
}

#[test]
fn test_toml_fixture_has_its_anchor_classes() {
    let text = fixture("sample.toml");
    let spans = highlighted(&text, Language::Toml);

    assert_anchor(&text, &spans, "title", TokenClass::Name);
    assert_anchor(&text, &spans, "hi", TokenClass::String);
    assert_anchor(&text, &spans, "42", TokenClass::Number);
    assert_anchor(&text, &spans, "note", TokenClass::Comment);
}

#[test]
fn test_plain_yields_no_span() {
    assert_eq!(highlighted(&fixture("plain.txt"), Language::Plain), []);
    assert_eq!(highlighted("def f(): pass", Language::Plain), []);
}

#[test]
fn test_empty_text_yields_no_span_in_every_language() {
    for language in EVERY_LANGUAGE {
        assert_eq!(highlighted("", language), [], "{language:?}");
    }
}

#[test]
fn test_same_inputs_give_the_same_spans() {
    assert_eq!(
        highlighted("x = 1", Language::Python),
        highlighted("x = 1", Language::Python)
    );
}

#[test]
fn test_span_ends_fall_on_character_boundaries_after_multibyte_text() {
    let text = "# café\ndef f(): pass";
    let spans = highlighted(text, Language::Python);

    assert!(
        spans.iter().any(|span| span.start == 8
            && span.class == TokenClass::Keyword
            && &text[span.start..span.end] == "def"),
        "`def` starts at byte 8, after the two-byte `é`: {spans:?}"
    );
}

#[test]
fn test_truncated_python_string_still_answers() {
    highlighted("s = \"unterminated", Language::Python);
}

#[test]
fn test_deeply_nested_json_still_answers() {
    let text = "[".repeat(10_000);

    highlighted(&text, Language::Json);
}

#[test]
fn test_json_highlighted_as_yaml_still_answers() {
    highlighted("{\"a\": 1}", Language::Yaml);
}

/// The plan's Task 6 and DESIGN's five roles (`docs/DESIGN.md:L390-L393`): punctuation and operators
/// take no class, so no byte of them lies in a span. None of these bytes sits inside a fixture's
/// string or comment, where it would belong to that token.
#[test]
fn test_punctuation_and_operators_take_no_span_in_every_fixture() {
    let cases = [
        ("sample.py", Language::Python, &b"():="[..]),
        ("sample.sh", Language::Shell, &b"[];=-"[..]),
        ("sample.js", Language::JavaScript, &b"(){};="[..]),
        ("sample.json", Language::Json, &b"{}:,"[..]),
        ("sample.yaml", Language::Yaml, &b":"[..]),
        ("sample.toml", Language::Toml, &b"="[..]),
    ];

    for (name, language, punctuation) in cases {
        let text = fixture(name);
        let spans = highlighted(&text, language);

        assert_no_span_on(&text, &spans, punctuation);
    }
}

/// CP-295 for every floor language: each fixture, highlighted twice, gives equal spans.
#[test]
fn test_every_fixture_gives_the_same_spans_twice() {
    let cases = [
        ("sample.py", Language::Python),
        ("sample.sh", Language::Shell),
        ("sample.js", Language::JavaScript),
        ("sample.json", Language::Json),
        ("sample.yaml", Language::Yaml),
        ("sample.toml", Language::Toml),
    ];

    for (name, language) in cases {
        let text = fixture(name);

        assert_eq!(
            highlighted(&text, language),
            highlighted(&text, language),
            "{name}"
        );
    }
}

/// CP-298 "nests deeper than any real file", for every language and each bracket kind.
#[test]
fn test_deep_nesting_still_answers_in_every_language() {
    for opener in ["[", "(", "{"] {
        let text = opener.repeat(10_000);
        for language in EVERY_LANGUAGE {
            highlighted(&text, language);
        }
    }
}

/// CP-296 for multi-byte text in every language: span ends stay on character boundaries when
/// strings and comments hold characters of two, three and four bytes.
#[test]
fn test_multibyte_text_keeps_span_ends_on_character_boundaries_in_every_language() {
    let cases = [
        ("s = \"héllo ☃ 😀\"  # café ☃\n", Language::Python),
        ("echo 'héllo ☃ 😀'  # café ☃\n", Language::Shell),
        (
            "const s = \"héllo ☃ 😀\"; // café ☃\n",
            Language::JavaScript,
        ),
        ("{\"clé\": \"héllo ☃ 😀\"}\n", Language::Json),
        ("clé: \"héllo ☃ 😀\"  # café ☃\n", Language::Yaml),
        ("key = \"héllo ☃ 😀\" # café ☃\n", Language::Toml),
    ];

    for (text, language) in cases {
        let spans = highlighted(text, language);

        assert!(
            spans
                .iter()
                .any(|span| !text[span.start..span.end].is_ascii()),
            "no {language:?} span covers a multi-byte character, so the boundary check proved nothing: {spans:?}"
        );
    }
}

/// CP-298 for every text and every language: each fixture, named as each of the seven languages,
/// still answers with well-formed spans.
#[test]
fn test_every_fixture_highlighted_as_every_language_still_answers() {
    let fixtures = [
        "sample.py",
        "sample.sh",
        "sample.js",
        "sample.json",
        "sample.yaml",
        "sample.toml",
        "plain.txt",
    ];

    for name in fixtures {
        let text = fixture(name);
        for language in EVERY_LANGUAGE {
            highlighted(&text, language);
        }
    }
}
