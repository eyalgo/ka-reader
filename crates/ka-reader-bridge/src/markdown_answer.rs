//! The wire form of a Markdown document: `blocks`, the one member a `markdown` file answer carries
//! beside its tag. Each value of the core's closed node set is written as one JSON object tagged by
//! `kind`, holding exactly the members it names; a member that exists only in some cases is absent
//! otherwise, never `null`. The mapping reads the core's values and writes them, and decides nothing
//! (QC-13). Every `From` names every variant with no wildcard arm, so a node kind added to the core is
//! a compile error here and not a silently dropped one.

use std::path::PathBuf;

use ka_reader_core::{
    Block, EmphasisStrength, HeadingLevel, ImageTarget, Inline, Language, LinkTarget, ListKind,
    PlaceholderCondition,
};
use serde::Serialize;

use crate::session::{LanguageDto, SpanDto};

/// A path on the wire, folder-relative and `/`-separated, in the lossy UTF-8 form the bridge writes
/// for every other path: serde's `PathBuf` impl fails on a non-UTF-8 path and would turn the whole
/// answer into NULL.
fn wire_path(path: PathBuf) -> String {
    path.to_string_lossy().into_owned()
}

/// A block of a document on the wire, tagged by `kind`: `heading` with its `level` as a number from
/// 1 to 6 and its `content`; `paragraph` with its `content`; `list` with its `order`, its `start`
/// beside `ordered` alone, and its `items`, each an array of blocks; `quote` with its `blocks`; `rule`
/// with no member; or `code` with its `code`, its `language` and, for a floor language, its `spans`.
///
/// # Examples
///
/// ```
/// use ka_reader_bridge::markdown_answer::BlockDto;
/// use ka_reader_core::{Block, HeadingLevel, Inline};
///
/// let written = serde_json::to_value(BlockDto::from(Block::Heading {
///     level: HeadingLevel::Two,
///     content: vec![Inline::Text("Title".to_string())],
/// }))
/// .expect("serializes");
/// assert_eq!(
///     written,
///     serde_json::json!({ "kind": "heading", "level": 2,
///                         "content": [{ "kind": "text", "text": "Title" }] })
/// );
/// ```
#[derive(Debug, Clone, PartialEq, Eq, Serialize)]
#[serde(tag = "kind", rename_all = "snake_case")]
pub enum BlockDto {
    Heading {
        level: u8,
        content: Vec<InlineDto>,
    },
    Paragraph {
        content: Vec<InlineDto>,
    },
    List {
        #[serde(flatten)]
        order: ListOrderDto,
        items: Vec<Vec<BlockDto>>,
    },
    Quote {
        blocks: Vec<BlockDto>,
    },
    Rule,
    Code {
        code: String,
        language: LanguageDto,
        /// Present exactly when `language` is a floor language, even as `[]`; a plain block has no
        /// such member. Keyed on the language, never on emptiness, as the text answer's is.
        #[serde(skip_serializing_if = "Option::is_none")]
        spans: Option<Vec<SpanDto>>,
    },
}

/// Whether a list is numbered, tagged by `order`: `unordered` with no other member, or `ordered`
/// with its `start`.
///
/// # Examples
///
/// ```
/// use ka_reader_bridge::markdown_answer::ListOrderDto;
/// use ka_reader_core::ListKind;
///
/// let ordered = serde_json::to_value(ListOrderDto::from(ListKind::Ordered { start: 3 }))
///     .expect("serializes");
/// assert_eq!(ordered, serde_json::json!({ "order": "ordered", "start": 3 }));
/// let unordered = serde_json::to_value(ListOrderDto::from(ListKind::Unordered)).expect("serializes");
/// assert_eq!(unordered, serde_json::json!({ "order": "unordered" }));
/// ```
#[derive(Debug, Clone, Copy, PartialEq, Eq, Serialize)]
#[serde(tag = "order", rename_all = "snake_case")]
pub enum ListOrderDto {
    Unordered,
    Ordered { start: u64 },
}

/// A node inside a heading, a paragraph, an emphasis or a link, tagged by `kind`: `text` with its
/// `text`; `emphasis` with its `strength` and `content`; `code` with its `code`; `image` with its
/// `alt` and its target's members; or `link` with its `content`, its `destination` and its target's
/// members.
///
/// # Examples
///
/// ```
/// use ka_reader_bridge::markdown_answer::InlineDto;
/// use ka_reader_core::{Inline, LinkTarget};
///
/// let written = serde_json::to_value(InlineDto::from(Inline::Link {
///     content: vec![Inline::Text("site".to_string())],
///     destination: "https://example.com".to_string(),
///     target: LinkTarget::External,
/// }))
/// .expect("serializes");
/// assert_eq!(
///     written,
///     serde_json::json!({ "kind": "link", "content": [{ "kind": "text", "text": "site" }],
///                         "destination": "https://example.com", "target": "external" })
/// );
/// ```
#[derive(Debug, Clone, PartialEq, Eq, Serialize)]
#[serde(tag = "kind", rename_all = "snake_case")]
pub enum InlineDto {
    Text {
        text: String,
    },
    Emphasis {
        strength: EmphasisStrengthDto,
        content: Vec<InlineDto>,
    },
    Code {
        code: String,
    },
    Image {
        alt: String,
        #[serde(flatten)]
        target: ImageTargetDto,
    },
    Link {
        content: Vec<InlineDto>,
        destination: String,
        #[serde(flatten)]
        target: LinkTargetDto,
    },
}

/// How strongly an emphasis is set, on the wire: `"single"` or `"strong"`.
///
/// # Examples
///
/// ```
/// use ka_reader_bridge::markdown_answer::EmphasisStrengthDto;
/// use ka_reader_core::EmphasisStrength;
///
/// let strong = serde_json::to_value(EmphasisStrengthDto::from(EmphasisStrength::Strong))
///     .expect("serializes");
/// assert_eq!(strong, serde_json::json!("strong"));
/// ```
#[derive(Debug, Clone, Copy, PartialEq, Eq, Serialize)]
#[serde(rename_all = "snake_case")]
pub enum EmphasisStrengthDto {
    Single,
    Strong,
}

/// What an image reference came to, tagged by `target`: `resolved` with the bitmap's folder-relative
/// `path`, or `placeholder` with its `condition` and the `source` as written.
///
/// # Examples
///
/// ```
/// use std::path::PathBuf;
///
/// use ka_reader_bridge::markdown_answer::ImageTargetDto;
/// use ka_reader_core::ImageTarget;
///
/// let resolved = serde_json::to_value(ImageTargetDto::from(ImageTarget::Resolved(
///     PathBuf::from("img/logo.png"),
/// )))
/// .expect("serializes");
/// assert_eq!(resolved, serde_json::json!({ "target": "resolved", "path": "img/logo.png" }));
/// ```
#[derive(Debug, Clone, PartialEq, Eq, Serialize)]
#[serde(tag = "target", rename_all = "snake_case")]
pub enum ImageTargetDto {
    Resolved {
        path: String,
    },
    Placeholder {
        condition: PlaceholderConditionDto,
        source: String,
    },
}

/// Why an image is a placeholder, on the wire: `"outside_the_folder"`, `"missing"`, `"unreadable"` or
/// `"format_not_decoded"`.
///
/// # Examples
///
/// ```
/// use ka_reader_bridge::markdown_answer::PlaceholderConditionDto;
/// use ka_reader_core::PlaceholderCondition;
///
/// let written =
///     serde_json::to_value(PlaceholderConditionDto::from(PlaceholderCondition::FormatNotDecoded))
///         .expect("serializes");
/// assert_eq!(written, serde_json::json!("format_not_decoded"));
/// ```
#[derive(Debug, Clone, Copy, PartialEq, Eq, Serialize)]
#[serde(rename_all = "snake_case")]
pub enum PlaceholderConditionDto {
    OutsideTheFolder,
    Missing,
    Unreadable,
    FormatNotDecoded,
}

/// What a link came to, tagged by `target`: `relative` with the target's folder-relative `path`, or
/// `external` with no other member.
///
/// # Examples
///
/// ```
/// use std::path::PathBuf;
///
/// use ka_reader_bridge::markdown_answer::LinkTargetDto;
/// use ka_reader_core::LinkTarget;
///
/// let relative = serde_json::to_value(LinkTargetDto::from(LinkTarget::Relative(PathBuf::from(
///     "docs/guide.md",
/// ))))
/// .expect("serializes");
/// assert_eq!(relative, serde_json::json!({ "target": "relative", "path": "docs/guide.md" }));
/// let external = serde_json::to_value(LinkTargetDto::from(LinkTarget::External)).expect("serializes");
/// assert_eq!(external, serde_json::json!({ "target": "external" }));
/// ```
#[derive(Debug, Clone, PartialEq, Eq, Serialize)]
#[serde(tag = "target", rename_all = "snake_case")]
pub enum LinkTargetDto {
    Relative { path: String },
    External,
}

/// A heading's level as the number it is, from 1 to 6.
fn level_number(level: HeadingLevel) -> u8 {
    match level {
        HeadingLevel::One => 1,
        HeadingLevel::Two => 2,
        HeadingLevel::Three => 3,
        HeadingLevel::Four => 4,
        HeadingLevel::Five => 5,
        HeadingLevel::Six => 6,
    }
}

fn blocks_of(blocks: Vec<Block>) -> Vec<BlockDto> {
    blocks.into_iter().map(BlockDto::from).collect()
}

fn inlines_of(inlines: Vec<Inline>) -> Vec<InlineDto> {
    inlines.into_iter().map(InlineDto::from).collect()
}

/// The blocks of a document on the wire, in source order.
///
/// # Examples
///
/// ```
/// use ka_reader_bridge::markdown_answer::document_blocks;
/// use ka_reader_core::{Block, Inline, MarkdownDocument};
///
/// let blocks = document_blocks(MarkdownDocument {
///     blocks: vec![Block::Paragraph(vec![Inline::Text("hello".to_string())]), Block::Rule],
/// });
/// assert_eq!(blocks.len(), 2);
/// ```
pub fn document_blocks(document: ka_reader_core::MarkdownDocument) -> Vec<BlockDto> {
    blocks_of(document.blocks)
}

impl From<Block> for BlockDto {
    fn from(block: Block) -> Self {
        match block {
            Block::Heading { level, content } => Self::Heading {
                level: level_number(level),
                content: inlines_of(content),
            },
            Block::Paragraph(content) => Self::Paragraph {
                content: inlines_of(content),
            },
            Block::List { kind, items } => Self::List {
                order: kind.into(),
                items: items.into_iter().map(blocks_of).collect(),
            },
            Block::Quote(blocks) => Self::Quote {
                blocks: blocks_of(blocks),
            },
            Block::Rule => Self::Rule,
            Block::Code {
                language,
                code,
                spans,
            } => Self::Code {
                code,
                spans: match language {
                    Language::Plain => None,
                    Language::Python
                    | Language::Shell
                    | Language::JavaScript
                    | Language::Json
                    | Language::Yaml
                    | Language::Toml => Some(spans.into_iter().map(SpanDto::from).collect()),
                },
                language: language.into(),
            },
        }
    }
}

impl From<ListKind> for ListOrderDto {
    fn from(kind: ListKind) -> Self {
        match kind {
            ListKind::Unordered => Self::Unordered,
            ListKind::Ordered { start } => Self::Ordered { start },
        }
    }
}

impl From<Inline> for InlineDto {
    fn from(inline: Inline) -> Self {
        match inline {
            Inline::Text(text) => Self::Text { text },
            Inline::Emphasis { strength, content } => Self::Emphasis {
                strength: strength.into(),
                content: inlines_of(content),
            },
            Inline::Code(code) => Self::Code { code },
            Inline::Image { alt, target } => Self::Image {
                alt,
                target: target.into(),
            },
            Inline::Link {
                content,
                destination,
                target,
            } => Self::Link {
                content: inlines_of(content),
                destination,
                target: target.into(),
            },
        }
    }
}

impl From<EmphasisStrength> for EmphasisStrengthDto {
    fn from(strength: EmphasisStrength) -> Self {
        match strength {
            EmphasisStrength::Single => Self::Single,
            EmphasisStrength::Strong => Self::Strong,
        }
    }
}

impl From<ImageTarget> for ImageTargetDto {
    fn from(target: ImageTarget) -> Self {
        match target {
            ImageTarget::Resolved(path) => Self::Resolved {
                path: wire_path(path),
            },
            ImageTarget::Placeholder { condition, source } => Self::Placeholder {
                condition: condition.into(),
                source,
            },
        }
    }
}

impl From<PlaceholderCondition> for PlaceholderConditionDto {
    fn from(condition: PlaceholderCondition) -> Self {
        match condition {
            PlaceholderCondition::OutsideTheFolder => Self::OutsideTheFolder,
            PlaceholderCondition::Missing => Self::Missing,
            PlaceholderCondition::Unreadable => Self::Unreadable,
            PlaceholderCondition::FormatNotDecoded => Self::FormatNotDecoded,
        }
    }
}

impl From<LinkTarget> for LinkTargetDto {
    fn from(target: LinkTarget) -> Self {
        match target {
            LinkTarget::Relative(path) => Self::Relative {
                path: wire_path(path),
            },
            LinkTarget::External => Self::External,
        }
    }
}

#[cfg(test)]
mod tests {
    //! Layer 1: the wire form of a document, built by hand from the core's values.

    use std::path::PathBuf;

    use ka_reader_core::{
        Block, EmphasisStrength, FileView, HeadingLevel, ImageTarget, Inline, ItemState, Language,
        LinkTarget, ListKind, MarkdownDocument, PlaceholderCondition, Span, TokenClass,
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
        assert_eq!(
            wire(Vec::new()),
            json!({ "state": "markdown", "blocks": [] })
        );
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
