#[cfg(test)]
mod tests {
    //! Layer 1: the wire form of a document, built by hand from the core's values.

    use std::path::PathBuf;

    use ka_reader_core::{
        Block, EmphasisStrength, FileView, HeadingLevel, ImageTarget, Inline, ItemState,
        LinkTarget, Language, ListKind, MarkdownDocument, PlaceholderCondition, Span, TokenClass,
    };
    use serde_json::{Value, json};

    use crate::session::FileAnswerDto;

    /// The pinned answer both languages read (CP-1100).
    const PINNED: &str = include_str!("../tests/fixtures/markdown_answer.json");

    fn text(words: &str) -> Inline {
        Inline::Text(words.to_string())
    }

    fn paragraph(words: &str) -> Block {
        Block::Paragraph(vec![text(words)])
    }

    fn answer_of(blocks: Vec<Block>) -> FileAnswerDto {
        FileAnswerDto::from(ItemState::Observed(FileView::Markdown(MarkdownDocument {
            blocks,
        })))
    }

    fn wire(blocks: Vec<Block>) -> Value {
        serde_json::to_value(answer_of(blocks)).expect("the answer serializes")
    }

    /// The `blocks` member of the answer for `blocks`.
    fn blocks_of(blocks: Vec<Block>) -> Value {
        wire(blocks)["blocks"].clone()
    }

    /// The one inline of a paragraph holding only `inline`, as written.
    fn inline_of(inline: Inline) -> Value {
        blocks_of(vec![Block::Paragraph(vec![inline])])[0]["content"][0].clone()
    }

    #[test]
    fn test_a_heading_is_written_with_its_level_as_a_number() {
        let levels = [
            (HeadingLevel::One, 1),
            (HeadingLevel::Two, 2),
            (HeadingLevel::Three, 3),
            (HeadingLevel::Four, 4),
            (HeadingLevel::Five, 5),
            (HeadingLevel::Six, 6),
        ];
        for (level, number) in levels {
            let written = blocks_of(vec![Block::Heading {
                level,
                content: vec![text("Title")],
            }]);

            assert_eq!(
                written,
                json!([{ "kind": "heading", "level": number,
                         "content": [{ "kind": "text", "text": "Title" }] }]),
                "level {number}"
            );
        }
    }

    #[test]
    fn test_a_paragraph_is_written_with_its_inline_content() {
        assert_eq!(
            blocks_of(vec![paragraph("words")]),
            json!([{ "kind": "paragraph", "content": [{ "kind": "text", "text": "words" }] }])
        );
    }

    #[test]
    fn test_an_unordered_list_has_no_start_member() {
        let written = blocks_of(vec![Block::List {
            kind: ListKind::Unordered,
            items: vec![vec![paragraph("one")], vec![paragraph("two")]],
        }]);

        assert_eq!(
            written,
            json!([{ "kind": "list", "order": "unordered", "items": [
                [{ "kind": "paragraph", "content": [{ "kind": "text", "text": "one" }] }],
                [{ "kind": "paragraph", "content": [{ "kind": "text", "text": "two" }] }],
            ] }])
        );
        assert!(written[0].get("start").is_none());
    }

    #[test]
    fn test_an_ordered_list_carries_its_start() {
        let written = blocks_of(vec![Block::List {
            kind: ListKind::Ordered { start: 7 },
            items: vec![vec![paragraph("seven")]],
        }]);

        assert_eq!(written[0]["order"], "ordered");
        assert_eq!(written[0]["start"], 7);
        assert_eq!(written[0]["items"][0][0]["kind"], "paragraph");
    }

    #[test]
    fn test_a_list_inside_a_quote_is_written_nested() {
        let written = blocks_of(vec![Block::Quote(vec![Block::List {
            kind: ListKind::Unordered,
            items: vec![vec![paragraph("inner")]],
        }])]);

        assert_eq!(written[0]["kind"], "quote");
        assert_eq!(written[0]["blocks"][0]["kind"], "list");
        assert_eq!(written[0]["blocks"][0]["items"][0][0]["kind"], "paragraph");
        assert_eq!(
            written[0]["blocks"][0]["items"][0][0]["content"][0]["text"],
            "inner"
        );
    }

    #[test]
    fn test_a_rule_is_written_as_its_kind_alone() {
        assert_eq!(blocks_of(vec![Block::Rule]), json!([{ "kind": "rule" }]));
    }

    #[test]
    fn test_plain_code_has_no_spans_member() {
        let written = blocks_of(vec![Block::Code {
            language: Language::Plain,
            code: "plain\n".to_string(),
            spans: Vec::new(),
        }]);

        assert_eq!(
            written,
            json!([{ "kind": "code", "code": "plain\n", "language": "plain" }])
        );
    }

    #[test]
    fn test_floor_code_carries_spans_even_when_empty() {
        let written = blocks_of(vec![Block::Code {
            language: Language::Python,
            code: String::new(),
            spans: Vec::new(),
        }]);

        assert_eq!(
            written,
            json!([{ "kind": "code", "code": "", "language": "python", "spans": [] }])
        );
    }

    #[test]
    fn test_a_code_span_is_written_with_byte_offsets_and_its_class() {
        let written = blocks_of(vec![Block::Code {
            language: Language::Shell,
            code: "é if".to_string(),
            spans: vec![Span {
                start: 3,
                end: 5,
                class: TokenClass::Keyword,
            }],
        }]);

        assert_eq!(
            written[0]["spans"],
            json!([{ "start": 3, "end": 5, "class": "keyword" }])
        );
        assert_eq!(written[0]["language"], "shell");
    }

    #[test]
    fn test_both_emphasis_strengths_are_written() {
        for (strength, name) in [
            (EmphasisStrength::Single, "single"),
            (EmphasisStrength::Strong, "strong"),
        ] {
            assert_eq!(
                inline_of(Inline::Emphasis {
                    strength,
                    content: vec![text("em")],
                }),
                json!({ "kind": "emphasis", "strength": name,
                        "content": [{ "kind": "text", "text": "em" }] }),
                "{name}"
            );
        }
    }

    #[test]
    fn test_inline_code_is_written_with_its_text() {
        assert_eq!(
            inline_of(Inline::Code("a < b".to_string())),
            json!({ "kind": "code", "code": "a < b" })
        );
    }

    #[test]
    fn test_a_resolved_image_carries_its_path_and_no_condition_or_source() {
        let written = inline_of(Inline::Image {
            alt: "logo".to_string(),
            target: ImageTarget::Resolved(PathBuf::from("img/logo.png")),
        });

        assert_eq!(
            written,
            json!({ "kind": "image", "alt": "logo", "target": "resolved", "path": "img/logo.png" })
        );
        assert!(written.get("condition").is_none());
        assert!(written.get("source").is_none());
    }

    #[test]
    fn test_a_placeholder_image_carries_its_condition_and_source_for_each_condition() {
        for (condition, name) in [
            (PlaceholderCondition::OutsideTheFolder, "outside_the_folder"),
            (PlaceholderCondition::Missing, "missing"),
            (PlaceholderCondition::Unreadable, "unreadable"),
            (PlaceholderCondition::FormatNotDecoded, "format_not_decoded"),
        ] {
            let written = inline_of(Inline::Image {
                alt: "alt".to_string(),
                target: ImageTarget::Placeholder {
                    condition,
                    source: "as/written.png".to_string(),
                },
            });

            assert_eq!(
                written,
                json!({ "kind": "image", "alt": "alt", "target": "placeholder",
                        "condition": name, "source": "as/written.png" }),
                "{name}"
            );
            assert!(written.get("path").is_none(), "{name}");
        }
    }

    #[test]
    fn test_a_relative_link_carries_its_target_path() {
        assert_eq!(
            inline_of(Inline::Link {
                content: vec![text("guide")],
                destination: "./docs/guide.md#top".to_string(),
                target: LinkTarget::Relative(PathBuf::from("docs/guide.md")),
            }),
            json!({ "kind": "link", "content": [{ "kind": "text", "text": "guide" }],
                    "destination": "./docs/guide.md#top", "target": "relative",
                    "path": "docs/guide.md" })
        );
    }

    #[test]
    fn test_an_external_link_has_no_path_member() {
        let written = inline_of(Inline::Link {
            content: vec![text("site")],
            destination: "https://example.com".to_string(),
            target: LinkTarget::External,
        });

        assert_eq!(
            written,
            json!({ "kind": "link", "content": [{ "kind": "text", "text": "site" }],
                    "destination": "https://example.com", "target": "external" })
        );
        assert!(written.get("path").is_none());
    }

    #[cfg(unix)]
    #[test]
    fn test_a_path_without_a_utf8_form_is_written_in_the_lossy_form() {
        use std::ffi::OsString;
        use std::os::unix::ffi::OsStringExt;

        let path = PathBuf::from(OsString::from_vec(b"img/\xFFlogo.png".to_vec()));
        let written = inline_of(Inline::Image {
            alt: String::new(),
            target: ImageTarget::Resolved(path.clone()),
        });

        assert_eq!(written["path"], path.to_string_lossy().as_ref());
        assert_eq!(written["path"], "img/\u{FFFD}logo.png");
    }

    #[test]
    fn test_an_empty_document_is_an_empty_blocks_array() {
        assert_eq!(wire(Vec::new()), json!({ "state": "markdown", "blocks": [] }));
    }

    /// The one document that uses every kind and every member, built from the core's values.
    fn full_document() -> Vec<Block> {
        let placeholder = |alt: &str, condition, source: &str| Inline::Image {
            alt: alt.to_string(),
            target: ImageTarget::Placeholder {
                condition,
                source: source.to_string(),
            },
        };
        vec![
            Block::Heading {
                level: HeadingLevel::One,
                content: vec![
                    text("Title"),
                    Inline::Emphasis {
                        strength: EmphasisStrength::Strong,
                        content: vec![text("bold")],
                    },
                ],
            },
            Block::Paragraph(vec![
                text("Hello "),
                Inline::Emphasis {
                    strength: EmphasisStrength::Single,
                    content: vec![text("there")],
                },
                Inline::Code("x()".to_string()),
                Inline::Image {
                    alt: "logo".to_string(),
                    target: ImageTarget::Resolved(PathBuf::from("logo.png")),
                },
                placeholder(
                    "remote",
                    PlaceholderCondition::OutsideTheFolder,
                    "https://example.com/remote.png",
                ),
                placeholder("", PlaceholderCondition::Missing, "img/missing.png"),
                placeholder("locked", PlaceholderCondition::Unreadable, "locked.png"),
                placeholder(
                    "diagram",
                    PlaceholderCondition::FormatNotDecoded,
                    "diagram.svg",
                ),
                Inline::Link {
                    content: vec![text("guide")],
                    destination: "docs/guide.md".to_string(),
                    target: LinkTarget::Relative(PathBuf::from("docs/guide.md")),
                },
                Inline::Link {
                    content: vec![text("site")],
                    destination: "https://example.com".to_string(),
                    target: LinkTarget::External,
                },
            ]),
            Block::List {
                kind: ListKind::Unordered,
                items: vec![vec![paragraph("one")], vec![paragraph("two")]],
            },
            Block::List {
                kind: ListKind::Ordered { start: 3 },
                items: vec![vec![
                    paragraph("three"),
                    Block::List {
                        kind: ListKind::Unordered,
                        items: vec![vec![paragraph("nested")]],
                    },
                ]],
            },
            Block::Quote(vec![paragraph("quoted")]),
            Block::Rule,
            Block::Code {
                language: Language::Plain,
                code: "plain text\n".to_string(),
                spans: Vec::new(),
            },
            Block::Code {
                language: Language::Python,
                code: "é = 1\n".to_string(),
                spans: vec![Span {
                    start: 0,
                    end: 2,
                    class: TokenClass::Name,
                }],
            },
            Block::Code {
                language: Language::Toml,
                code: String::new(),
                spans: Vec::new(),
            },
        ]
    }

    #[test]
    fn test_the_answer_for_the_full_document_is_exactly_the_pinned_fixture() {
        let written =
            serde_json::to_string(&answer_of(full_document())).expect("the answer serializes");

        assert_eq!(written, PINNED);
    }
}
