//! The fold of the parser's events into the document's nodes.
//!
//! An explicit stack of open containers does the work, never recursion, so a deeply nested source
//! cannot exhaust the stack while the document is built.

use std::ops::Range;
use std::path::Path;

use pulldown_cmark::{CodeBlockKind, Event, HeadingLevel as ParserLevel, Tag, TagEnd};

use super::fence::language_of_fence;
use super::references::{image_target, link_target};
use super::{Block, EmphasisStrength, HeadingLevel, Inline, ListKind, MarkdownDocument};
use crate::{ContainmentCheck, Language, highlight};

/// Folds `events`, each with the byte range of `text` it came from, into a document.
pub(super) fn fold<'a>(
    text: &str,
    events: impl Iterator<Item = (Event<'a>, Range<usize>)>,
    folder: &Path,
    check: &impl ContainmentCheck,
) -> MarkdownDocument {
    let mut fold = Fold {
        root: Frame::new(Kind::Document),
        stack: Vec::new(),
        skipping: 0,
        text,
        folder,
        check,
    };
    for (event, range) in events {
        fold.take(event, range);
    }
    fold.finish()
}

/// The inline nodes of a container, with the run of text not yet closed into a node. A run of text,
/// soft breaks and hard breaks is one node; any other inline node ends it.
#[derive(Default)]
struct InlineRun {
    nodes: Vec<Inline>,
    pending: String,
}

impl InlineRun {
    fn push_text(&mut self, text: &str) {
        self.pending.push_str(text);
    }

    fn push_node(&mut self, node: Inline) {
        self.flush();
        self.nodes.push(node);
    }

    fn flush(&mut self) {
        if !self.pending.is_empty() {
            self.nodes
                .push(Inline::Text(std::mem::take(&mut self.pending)));
        }
    }

    fn finish(mut self) -> Vec<Inline> {
        self.flush();
        self.nodes
    }
}

/// What an open container is, with what only that kind holds.
enum Kind {
    Document,
    Quote,
    Item,
    List {
        kind: ListKind,
        items: Vec<Vec<Block>>,
    },
    /// An `implicit` paragraph holds inline content the parser met outside any paragraph, such as a
    /// tight list item's text; it closes where the next block starts.
    Paragraph {
        implicit: bool,
    },
    Heading(HeadingLevel),
    Emphasis(EmphasisStrength),
    Link {
        destination: String,
    },
    /// `alt` collects the plain text of the image's inner events; `nested` counts the tags opened
    /// inside it and not yet closed.
    Image {
        source: String,
        alt: String,
        nested: usize,
    },
    Code {
        language: Language,
        code: String,
    },
    Html(String),
}

/// An open container: its kind, the blocks it holds and the inline content it holds. A kind uses
/// one of the two.
struct Frame {
    kind: Kind,
    blocks: Vec<Block>,
    inline: InlineRun,
}

impl Frame {
    fn new(kind: Kind) -> Self {
        Self {
            kind,
            blocks: Vec::new(),
            inline: InlineRun::default(),
        }
    }

    fn holds_inline(&self) -> bool {
        matches!(
            self.kind,
            Kind::Paragraph { .. } | Kind::Heading(_) | Kind::Emphasis(_) | Kind::Link { .. }
        )
    }

    fn is_implicit_paragraph(&self) -> bool {
        matches!(self.kind, Kind::Paragraph { implicit: true })
    }
}

/// What a closed container hands to the one that holds it.
enum Product {
    Block(Block),
    Inline(Inline),
    Item(Vec<Block>),
}

struct Fold<'a, C> {
    /// The document itself. It is never popped, so there is always a container to write into.
    root: Frame,
    stack: Vec<Frame>,
    /// Depth inside a construct with no kind: its events are skipped until it closes.
    skipping: usize,
    text: &'a str,
    folder: &'a Path,
    check: &'a C,
}

impl<C: ContainmentCheck> Fold<'_, C> {
    fn take(&mut self, event: Event<'_>, range: Range<usize>) {
        if self.skipping > 0 {
            match event {
                Event::Start(_) => self.skipping += 1,
                Event::End(_) => self.skipping -= 1,
                _ => {}
            }
            return;
        }
        if matches!(
            self.stack.last(),
            Some(Frame {
                kind: Kind::Image { .. },
                ..
            })
        ) {
            self.take_inside_image(event);
            return;
        }
        match event {
            Event::Start(tag) => self.start(tag, range),
            Event::End(end) => self.end(end),
            Event::Text(text) => self.text_event(&text),
            Event::SoftBreak => self.text_event("\n"),
            Event::HardBreak => self.text_event("\u{2028}"),
            Event::Code(code) => self.inline_node(Inline::Code(code.into_string())),
            Event::InlineHtml(html) => self.inline_node(Inline::Text(html.into_string())),
            Event::Html(html) => self.html_event(html.into_string()),
            Event::Rule => {
                self.settle();
                self.deliver(Product::Block(Block::Rule));
            }
            Event::InlineMath(_)
            | Event::DisplayMath(_)
            | Event::FootnoteReference(_)
            | Event::TaskListMarker(_) => self.source_text(range),
        }
    }

    /// The events inside an image are flattened into its alt text. A tag opened inside it adds
    /// nothing but depth, and the End that closes the image itself is the one with no depth left.
    fn take_inside_image(&mut self, event: Event<'_>) {
        let Some(Frame {
            kind: Kind::Image { alt, nested, .. },
            ..
        }) = self.stack.last_mut()
        else {
            return;
        };
        match event {
            Event::Text(text) | Event::Code(text) | Event::InlineHtml(text) | Event::Html(text) => {
                alt.push_str(&text);
            }
            Event::SoftBreak | Event::HardBreak => alt.push(' '),
            Event::Start(_) => *nested += 1,
            Event::End(_) if *nested > 0 => *nested -= 1,
            Event::End(_) => self.close_top(),
            Event::Rule
            | Event::InlineMath(_)
            | Event::DisplayMath(_)
            | Event::FootnoteReference(_)
            | Event::TaskListMarker(_) => {}
        }
    }

    fn start(&mut self, tag: Tag<'_>, range: Range<usize>) {
        match tag {
            Tag::Paragraph => self.open_block(Kind::Paragraph { implicit: false }),
            Tag::Heading { level, .. } => self.open_block(Kind::Heading(heading_level(level))),
            Tag::BlockQuote(_) => self.open_block(Kind::Quote),
            Tag::CodeBlock(kind) => {
                let language = match kind {
                    CodeBlockKind::Fenced(info) => language_of_fence(&info),
                    CodeBlockKind::Indented => Language::Plain,
                };
                self.open_block(Kind::Code {
                    language,
                    code: String::new(),
                });
            }
            Tag::HtmlBlock => self.open_block(Kind::Html(String::new())),
            Tag::List(start) => self.open_block(Kind::List {
                kind: start.map_or(ListKind::Unordered, |start| ListKind::Ordered { start }),
                items: Vec::new(),
            }),
            Tag::Item => self.open_block(Kind::Item),
            Tag::Emphasis => self.open_inline(Kind::Emphasis(EmphasisStrength::Single)),
            Tag::Strong => self.open_inline(Kind::Emphasis(EmphasisStrength::Strong)),
            Tag::Link { dest_url, .. } => self.open_inline(Kind::Link {
                destination: dest_url.into_string(),
            }),
            Tag::Image { dest_url, .. } => self.open_inline(Kind::Image {
                source: dest_url.into_string(),
                alt: String::new(),
                nested: 0,
            }),
            Tag::FootnoteDefinition(_)
            | Tag::DefinitionList
            | Tag::DefinitionListTitle
            | Tag::DefinitionListDefinition
            | Tag::Table(_)
            | Tag::TableHead
            | Tag::TableRow
            | Tag::TableCell
            | Tag::Strikethrough
            | Tag::Superscript
            | Tag::Subscript
            | Tag::MetadataBlock(_) => {
                self.source_text(range);
                self.skipping = 1;
            }
        }
    }

    fn end(&mut self, end: TagEnd) {
        match end {
            TagEnd::Paragraph
            | TagEnd::Heading(_)
            | TagEnd::BlockQuote(_)
            | TagEnd::CodeBlock
            | TagEnd::HtmlBlock
            | TagEnd::List(_)
            | TagEnd::Item
            | TagEnd::Emphasis
            | TagEnd::Strong
            | TagEnd::Link => {
                self.settle();
                self.close_top();
            }
            // These closed constructs were skipped whole at their start, so no End reaches here.
            TagEnd::Image
            | TagEnd::FootnoteDefinition
            | TagEnd::DefinitionList
            | TagEnd::DefinitionListTitle
            | TagEnd::DefinitionListDefinition
            | TagEnd::Table
            | TagEnd::TableHead
            | TagEnd::TableRow
            | TagEnd::TableCell
            | TagEnd::Strikethrough
            | TagEnd::Superscript
            | TagEnd::Subscript
            | TagEnd::MetadataBlock(_) => {}
        }
    }

    fn top(&mut self) -> &mut Frame {
        self.stack.last_mut().unwrap_or(&mut self.root)
    }

    /// Closes an implicit paragraph left open on top, as a block start or an end requires.
    fn settle(&mut self) {
        if self.top().is_implicit_paragraph() {
            self.close_top();
        }
    }

    fn open_block(&mut self, kind: Kind) {
        self.settle();
        self.stack.push(Frame::new(kind));
    }

    fn open_inline(&mut self, kind: Kind) {
        self.ensure_inline_holder();
        self.stack.push(Frame::new(kind));
    }

    /// Makes the container on top one that holds inline content, opening an implicit paragraph when
    /// the top holds blocks.
    fn ensure_inline_holder(&mut self) {
        if !self.top().holds_inline() {
            self.stack
                .push(Frame::new(Kind::Paragraph { implicit: true }));
        }
    }

    fn inline_node(&mut self, node: Inline) {
        self.ensure_inline_holder();
        self.top().inline.push_node(node);
    }

    fn text_event(&mut self, text: &str) {
        match &mut self.top().kind {
            Kind::Code { code, .. } => code.push_str(text),
            Kind::Html(html) => html.push_str(text),
            _ => {
                self.ensure_inline_holder();
                self.top().inline.push_text(text);
            }
        }
    }

    fn html_event(&mut self, html: String) {
        match &mut self.top().kind {
            Kind::Html(block) => block.push_str(&html),
            _ => self.inline_node(Inline::Text(html)),
        }
    }

    /// A text node holding the source the parser read `range` from.
    fn source_text(&mut self, range: Range<usize>) {
        if let Some(source) = self.text.get(range).filter(|source| !source.is_empty()) {
            self.inline_node(Inline::Text(source.to_string()));
        }
    }

    fn close_top(&mut self) {
        let Some(frame) = self.stack.pop() else {
            return;
        };
        let product = self.product_of(frame);
        self.deliver(product);
    }

    fn product_of(&self, frame: Frame) -> Product {
        let Frame {
            kind,
            blocks,
            inline,
        } = frame;
        match kind {
            // The document is never on the stack; were it, its blocks would stay together.
            Kind::Document | Kind::Quote => Product::Block(Block::Quote(blocks)),
            Kind::Item => Product::Item(blocks),
            Kind::List { kind, items } => Product::Block(Block::List { kind, items }),
            Kind::Paragraph { .. } => Product::Block(Block::Paragraph(inline.finish())),
            Kind::Heading(level) => Product::Block(Block::Heading {
                level,
                content: inline.finish(),
            }),
            Kind::Emphasis(strength) => Product::Inline(Inline::Emphasis {
                strength,
                content: inline.finish(),
            }),
            Kind::Link { destination } => {
                let target = link_target(self.check, self.folder, &destination);
                Product::Inline(Inline::Link {
                    content: inline.finish(),
                    destination,
                    target,
                })
            }
            Kind::Image { source, alt, .. } => Product::Inline(Inline::Image {
                alt,
                target: image_target(self.check, self.folder, &source),
            }),
            Kind::Code { language, code } => {
                let spans = if language == Language::Plain {
                    Vec::new()
                } else {
                    highlight(&code, language)
                };
                Product::Block(Block::Code {
                    language,
                    code,
                    spans,
                })
            }
            Kind::Html(source) => {
                // The block's own line ending is not part of its source.
                let source = source.strip_suffix('\n').unwrap_or(&source);
                let source = source.strip_suffix('\r').unwrap_or(source);
                Product::Block(Block::Paragraph(vec![Inline::Text(source.to_string())]))
            }
        }
    }

    fn deliver(&mut self, product: Product) {
        match product {
            Product::Inline(node) => self.inline_node(node),
            Product::Item(blocks) => match &mut self.top().kind {
                Kind::List { items, .. } => items.push(blocks),
                _ => self.top().blocks.extend(blocks),
            },
            Product::Block(block) => match &mut self.top().kind {
                // Only an item reaches a list, so this is the parser's order broken; the block
                // still lands, as an item of its own.
                Kind::List { items, .. } => items.push(vec![block]),
                _ => self.top().blocks.push(block),
            },
        }
    }

    fn finish(mut self) -> MarkdownDocument {
        while !self.stack.is_empty() {
            self.close_top();
        }
        MarkdownDocument {
            blocks: self.root.blocks,
        }
    }
}

fn heading_level(level: ParserLevel) -> HeadingLevel {
    match level {
        ParserLevel::H1 => HeadingLevel::One,
        ParserLevel::H2 => HeadingLevel::Two,
        ParserLevel::H3 => HeadingLevel::Three,
        ParserLevel::H4 => HeadingLevel::Four,
        ParserLevel::H5 => HeadingLevel::Five,
        ParserLevel::H6 => HeadingLevel::Six,
    }
}
