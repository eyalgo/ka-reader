use super::fold::fold;
use super::*;
use crate::fs_reader::fakes::SeededContainment;
use crate::{Condition, ContainedEntry, EntryKind, Language, highlight};
use pulldown_cmark::{Event, Tag, TagEnd};
use std::path::{Path, PathBuf};

fn file(path: &str) -> Result<ContainedEntry, Condition> {
    Ok(ContainedEntry {
        path: PathBuf::from(path),
        kind: EntryKind::File,
    })
}

fn folder_entry(path: &str) -> Result<ContainedEntry, Condition> {
    Ok(ContainedEntry {
        path: PathBuf::from(path),
        kind: EntryKind::Folder,
    })
}

fn text(content: &str) -> Inline {
    Inline::Text(content.to_string())
}

fn paragraph(content: Vec<Inline>) -> Block {
    Block::Paragraph(content)
}

fn image(alt: &str, target: ImageTarget) -> Inline {
    Inline::Image {
        alt: alt.to_string(),
        target,
    }
}

fn placeholder(condition: PlaceholderCondition, source: &str) -> ImageTarget {
    ImageTarget::Placeholder {
        condition,
        source: source.to_string(),
    }
}

/// The blocks of `source` rendered at the root with a check that knows nothing.
fn blocks_of(source: &str) -> Vec<Block> {
    render(source, Path::new(""), &SeededContainment::new()).blocks
}

/// The one inline run of a source that renders as a single paragraph.
fn inlines_of(source: &str, folder: &str, check: &SeededContainment) -> Vec<Inline> {
    let blocks = render(source, Path::new(folder), check).blocks;
    match blocks.as_slice() {
        [Block::Paragraph(content)] => content.clone(),
        other => panic!("expected one paragraph, got {other:?}"),
    }
}

#[test]
fn test_a_heading_and_emphasis_become_nodes() {
    assert_eq!(
        blocks_of("# Title\n"),
        [Block::Heading {
            level: HeadingLevel::One,
            content: vec![text("Title")],
        }]
    );
    assert_eq!(
        blocks_of("Some *words*.\n"),
        [paragraph(vec![
            text("Some "),
            Inline::Emphasis {
                strength: EmphasisStrength::Single,
                content: vec![text("words")],
            },
            text("."),
        ])]
    );
    assert_eq!(
        blocks_of("**bold**\n"),
        [paragraph(vec![Inline::Emphasis {
            strength: EmphasisStrength::Strong,
            content: vec![text("bold")],
        }])]
    );
}

#[test]
fn test_every_heading_level_has_its_own_value() {
    let levels: Vec<HeadingLevel> = blocks_of("# a\n\n## b\n\n### c\n\n#### d\n\n##### e\n\n###### f\n")
        .into_iter()
        .map(|block| match block {
            Block::Heading { level, .. } => level,
            other => panic!("expected a heading, got {other:?}"),
        })
        .collect();
    assert_eq!(
        levels,
        [
            HeadingLevel::One,
            HeadingLevel::Two,
            HeadingLevel::Three,
            HeadingLevel::Four,
            HeadingLevel::Five,
            HeadingLevel::Six,
        ]
    );
}

#[test]
fn test_a_nested_list_and_a_quote_keep_their_structure() {
    assert_eq!(
        blocks_of("- a\n  - b\n> quote\n"),
        [
            Block::List {
                kind: ListKind::Unordered,
                items: vec![vec![
                    paragraph(vec![text("a")]),
                    Block::List {
                        kind: ListKind::Unordered,
                        items: vec![vec![paragraph(vec![text("b")])]],
                    },
                ]],
            },
            Block::Quote(vec![paragraph(vec![text("quote")])]),
        ]
    );
}

#[test]
fn test_an_ordered_list_keeps_its_start_number() {
    assert_eq!(
        blocks_of("3. x\n4. y\n"),
        [Block::List {
            kind: ListKind::Ordered { start: 3 },
            items: vec![
                vec![paragraph(vec![text("x")])],
                vec![paragraph(vec![text("y")])],
            ],
        }]
    );
}

#[test]
fn test_a_rule_and_inline_code_are_nodes() {
    assert_eq!(
        blocks_of("one\n\n---\n\ntwo\n"),
        [
            paragraph(vec![text("one")]),
            Block::Rule,
            paragraph(vec![text("two")]),
        ]
    );
    assert_eq!(
        blocks_of("`code`\n"),
        [paragraph(vec![Inline::Code("code".to_string())])]
    );
}

#[test]
fn test_a_table_and_a_strikethrough_are_text() {
    let table = "| a | b |\n|---|---|\n| 1 | 2 |";
    assert_eq!(
        blocks_of(&format!("{table}\n")),
        [paragraph(vec![text(table)])]
    );
    assert_eq!(
        blocks_of("~~gone~~\n"),
        [paragraph(vec![text("~~gone~~")])]
    );
}

#[test]
fn test_a_script_block_is_one_text_node_in_a_paragraph() {
    assert_eq!(
        blocks_of("<script>alert(1)</script>\n"),
        [paragraph(vec![text("<script>alert(1)</script>")])]
    );
}

#[test]
fn test_a_multi_line_html_block_is_one_text_node_with_its_line_breaks() {
    let source = "<div class=\"box\">\nraw block content\n</div>";
    assert_eq!(
        blocks_of(&format!("{source}\n")),
        [paragraph(vec![text(source)])]
    );
}

#[test]
fn test_inline_html_is_never_merged_into_its_neighbours() {
    assert_eq!(
        blocks_of("Hi <b onclick=\"x()\">there</b>\n"),
        [paragraph(vec![
            text("Hi "),
            text("<b onclick=\"x()\">"),
            text("there"),
            text("</b>"),
        ])]
    );
}

#[test]
fn test_a_soft_break_and_a_hard_break_stay_distinguishable() {
    let soft = inlines_of("line one\nline two\n", "", &SeededContainment::new());
    let hard = inlines_of("line one  \nline two\n", "", &SeededContainment::new());
    assert_eq!(soft, [text("line one\nline two")]);
    assert_eq!(hard, [text("line one\u{2028}line two")]);
    assert_ne!(soft, hard);
    assert_ne!(soft, [text("line one line two")]);
}

#[test]
fn test_a_floor_language_fence_carries_the_highlighters_spans() {
    let cases = [
        ("python", "print(\"hi\")\n", Language::Python),
        ("PY", "print(\"hi\")\n", Language::Python),
        ("yml", "key: 1\n", Language::Yaml),
        ("Bash", "echo hi\n", Language::Shell),
        ("python title=example", "print(\"hi\")\n", Language::Python),
    ];
    for (info, code, language) in cases {
        let blocks = blocks_of(&format!("```{info}\n{code}```\n"));
        assert_eq!(
            blocks,
            [Block::Code {
                language,
                code: code.to_string(),
                spans: highlight(code, language),
            }],
            "fence `{info}`"
        );
    }
    let Block::Code { spans, .. } = &blocks_of("```python\nprint(\"hi\")\n```\n")[0] else {
        panic!("expected a code block");
    };
    assert!(!spans.is_empty(), "a Python fence is highlighted");
}

#[test]
fn test_other_fences_and_indented_code_are_plain_with_no_spans() {
    let plain = |code: &str| Block::Code {
        language: Language::Plain,
        code: code.to_string(),
        spans: Vec::new(),
    };
    assert_eq!(
        blocks_of("```rust\nfn main() {}\n```\n"),
        [plain("fn main() {}\n")]
    );
    assert_eq!(blocks_of("```\nnothing\n```\n"), [plain("nothing\n")]);
    assert_eq!(
        blocks_of("para\n\n    indented\n"),
        [paragraph(vec![text("para")]), plain("indented\n")]
    );
}

#[test]
fn test_a_contained_bitmap_image_resolves_to_its_path() {
    let check = SeededContainment::new().seeded("img/a.png", file("docs/img/a.png"));
    assert_eq!(
        inlines_of("![logo](img/a.png)\n", "docs", &check),
        [image(
            "logo",
            ImageTarget::Resolved(PathBuf::from("docs/img/a.png"))
        )]
    );

    for name in [
        "IMG/A.PNG",
        "a.png",
        "p.jpg",
        "p.JPG",
        "p.jpeg",
        "p.JPEG",
        "p.gif",
        "p.GIF",
        "p.webp",
        "p.WEBP",
    ] {
        let check = SeededContainment::new().seeded(name, file(name));
        assert_eq!(
            inlines_of(&format!("![x]({name})\n"), "", &check),
            [image("x", ImageTarget::Resolved(PathBuf::from(name)))],
            "reference `{name}`"
        );
    }
}

#[test]
fn test_a_scheme_image_is_a_placeholder_outside_the_folder() {
    let sources = [
        "https://x.example/a.png",
        "file:///anything/a.png",
        "data:image/png;base64,AAAA",
    ];
    // Each is seeded as a file, so a check that was consulted would resolve it.
    let mut check = SeededContainment::new();
    for source in sources {
        check = check.seeded(source, file("a.png"));
    }
    for source in sources {
        assert_eq!(
            inlines_of(&format!("![x]({source})\n"), "", &check),
            [image(
                "x",
                placeholder(PlaceholderCondition::OutsideTheFolder, source)
            )],
            "source `{source}`"
        );
    }
    assert!(check.asked().is_empty(), "a scheme never reaches the check");
}

#[test]
fn test_each_refusal_maps_to_exactly_one_placeholder_condition() {
    let check = SeededContainment::new()
        .seeded("outside.png", Err(Condition::Outside))
        .seeded("missing.png", Err(Condition::Missing))
        .seeded("through.png", Err(Condition::NotAFolder))
        .seeded("folder", folder_entry("folder"))
        .seeded("loop.png", Err(Condition::Cycle))
        .seeded("long.png", Err(Condition::TooManyLinks))
        .seeded("denied.png", Err(Condition::Unreadable))
        .seeded("d.svg", file("d.svg"));
    let expected = [
        ("outside.png", PlaceholderCondition::OutsideTheFolder),
        ("missing.png", PlaceholderCondition::Missing),
        ("through.png", PlaceholderCondition::Missing),
        ("folder", PlaceholderCondition::Missing),
        ("loop.png", PlaceholderCondition::Unreadable),
        ("long.png", PlaceholderCondition::Unreadable),
        ("denied.png", PlaceholderCondition::Unreadable),
        ("d.svg", PlaceholderCondition::FormatNotDecoded),
    ];
    for (source, condition) in expected {
        assert_eq!(
            inlines_of(&format!("![x]({source})\n"), "", &check),
            [image("x", placeholder(condition, source))],
            "reference `{source}`"
        );
    }
}

#[test]
fn test_an_image_alt_is_the_flattened_plain_text_of_its_content() {
    assert_eq!(
        inlines_of("![a *b* `c`](none.png)\n", "", &SeededContainment::new()),
        [image(
            "a b c",
            placeholder(PlaceholderCondition::Missing, "none.png")
        )]
    );
}

#[test]
fn test_a_relative_link_carries_its_target_and_its_destination() {
    let check = SeededContainment::new().seeded("docs/guide.md", file("docs/guide.md"));
    assert_eq!(
        inlines_of("[guide](docs/guide.md#install)\n", "", &check),
        [Inline::Link {
            content: vec![text("guide")],
            destination: "docs/guide.md#install".to_string(),
            target: LinkTarget::Relative(PathBuf::from("docs/guide.md")),
        }]
    );
    assert_eq!(
        check.asked(),
        [(PathBuf::new(), "docs/guide.md".to_string())],
        "the check is asked for the path without the fragment"
    );
}

#[test]
fn test_every_other_link_is_external() {
    let check = SeededContainment::new().seeded("../outside.md", Err(Condition::Outside));
    let external = |content: &str, destination: &str| Inline::Link {
        content: vec![text(content)],
        destination: destination.to_string(),
        target: LinkTarget::External,
    };

    let schemes = inlines_of(
        "[site](https://x.example) [mail](mailto:a@x.example) [js](javascript:alert(1)) [top](#install)\n",
        "",
        &check,
    );
    assert_eq!(
        schemes,
        [
            external("site", "https://x.example"),
            text(" "),
            external("mail", "mailto:a@x.example"),
            text(" "),
            external("js", "javascript:alert(1)"),
            text(" "),
            external("top", "#install"),
        ]
    );
    assert!(check.asked().is_empty(), "none of those reached the check");

    assert_eq!(
        inlines_of("[up](../outside.md) [none](nope.md)\n", "", &check),
        [
            external("up", "../outside.md"),
            text(" "),
            external("none", "nope.md"),
        ]
    );
}

#[test]
fn test_a_badge_inside_a_link_keeps_both() {
    assert_eq!(
        inlines_of(
            "[![badge](https://x.example/b.svg)](https://x.example)\n",
            "",
            &SeededContainment::new()
        ),
        [Inline::Link {
            content: vec![image(
                "badge",
                placeholder(
                    PlaceholderCondition::OutsideTheFolder,
                    "https://x.example/b.svg"
                )
            )],
            destination: "https://x.example".to_string(),
            target: LinkTarget::External,
        }]
    );
}

#[test]
fn test_a_reference_is_asked_with_the_folder_of_the_markdown_file() {
    let check = SeededContainment::new();
    render("![a](img/a.png)\n\n[l](g.md)\n", Path::new("docs"), &check);
    assert_eq!(
        check.asked(),
        [
            (PathBuf::from("docs"), "img/a.png".to_string()),
            (PathBuf::from("docs"), "g.md".to_string()),
        ]
    );

    let at_root = SeededContainment::new();
    render("![a](img/a.png)\n", Path::new(""), &at_root);
    assert_eq!(
        at_root.asked(),
        [(PathBuf::new(), "img/a.png".to_string())]
    );
}

#[test]
fn test_a_link_reference_definition_yields_no_node() {
    assert_eq!(blocks_of("[foo]: /url \"title\"\n"), []);
}

#[test]
fn test_an_empty_text_renders_no_blocks() {
    assert_eq!(blocks_of(""), []);
}

/// The fold is driven by hand-built events, because with the parser's options off no source makes
/// it report a construct the closed set has no kind for.
#[test]
fn test_a_construct_with_no_kind_becomes_source_text() {
    let source = "a ~~gone~~ b";
    let events = vec![
        (Event::Start(Tag::Paragraph), 0..12),
        (Event::Text("a ".into()), 0..2),
        (Event::Start(Tag::Strikethrough), 2..10),
        (Event::Text("gone".into()), 4..8),
        (Event::Code("inner".into()), 4..8),
        (Event::End(TagEnd::Strikethrough), 2..10),
        (Event::Text(" b".into()), 10..12),
        (Event::End(TagEnd::Paragraph), 0..12),
    ];
    let document = fold(
        source,
        events.into_iter(),
        Path::new(""),
        &SeededContainment::new(),
    );
    assert_eq!(
        document.blocks,
        [paragraph(vec![text("a "), text("~~gone~~"), text(" b")])]
    );
}

#[test]
fn test_an_event_with_no_arm_becomes_source_text() {
    let source = "[x] done";
    let events = vec![
        (Event::Start(Tag::Paragraph), 0..8),
        (Event::TaskListMarker(true), 0..3),
        (Event::Text(" done".into()), 3..8),
        (Event::End(TagEnd::Paragraph), 0..8),
    ];
    let document = fold(
        source,
        events.into_iter(),
        Path::new(""),
        &SeededContainment::new(),
    );
    assert_eq!(
        document.blocks,
        [paragraph(vec![text("[x]"), text(" done")])]
    );
}

#[test]
fn test_a_block_construct_with_no_kind_becomes_a_paragraph_of_source_text() {
    let source = "| a |";
    let events = vec![
        (Event::Start(Tag::Table(Vec::new())), 0..5),
        (Event::Start(Tag::TableHead), 0..5),
        (Event::Text("a".into()), 2..3),
        (Event::End(TagEnd::TableHead), 0..5),
        (Event::End(TagEnd::Table), 0..5),
    ];
    let document = fold(
        source,
        events.into_iter(),
        Path::new(""),
        &SeededContainment::new(),
    );
    assert_eq!(document.blocks, [paragraph(vec![text("| a |")])]);
}
