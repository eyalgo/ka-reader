//! The Markdown renderer: Markdown text becomes a closed, typed document.
//!
//! The document is a fixed set of node kinds. It holds no markup and no URL value: every piece of
//! raw HTML is a text node holding its source, and an image or a link carries what a reader needs
//! to decide about it, never something a surface could fetch or open. The renderer opens nothing,
//! reads no byte and logs nothing; the one door to the disk is the containment check it is handed.

mod fence;
mod fold;
mod references;

use std::path::{Path, PathBuf};

use pulldown_cmark::{Options, Parser};

use crate::{ContainmentCheck, Language, Span};

/// A Markdown file as a document: its blocks, in source order.
///
/// # Examples
///
/// ```
/// use ka_reader_core::{Block, Inline, MarkdownDocument};
///
/// let document = MarkdownDocument {
///     blocks: vec![Block::Paragraph(vec![Inline::Text("hello".to_string())])],
/// };
/// assert_eq!(document.blocks.len(), 1);
/// ```
#[derive(Debug, Clone, PartialEq, Eq)]
pub struct MarkdownDocument {
    pub blocks: Vec<Block>,
}

/// A block of a document. A heading and a paragraph hold inline nodes; a list item and a quote hold
/// the blocks inside them, in source order.
#[derive(Debug, Clone, PartialEq, Eq)]
pub enum Block {
    Heading {
        level: HeadingLevel,
        content: Vec<Inline>,
    },
    Paragraph(Vec<Inline>),
    List {
        kind: ListKind,
        items: Vec<Vec<Block>>,
    },
    Quote(Vec<Block>),
    Rule,
    /// Code, fenced or indented, with its language and the highlighter's spans over `code`. A block
    /// in no floor language is `Plain` and holds no spans.
    Code {
        language: Language,
        code: String,
        spans: Vec<Span>,
    },
}

/// A heading's level, one of the six Markdown has.
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum HeadingLevel {
    One,
    Two,
    Three,
    Four,
    Five,
    Six,
}

/// Whether a list is numbered, and from where.
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum ListKind {
    Unordered,
    Ordered { start: u64 },
}

/// A node inside a heading, a paragraph, an emphasis or a link.
#[derive(Debug, Clone, PartialEq, Eq)]
pub enum Inline {
    /// Text, raw HTML included, held as its source. A soft break inside it is `"\n"` and a hard
    /// break is U+2028, so neither reads as a space the source wrote.
    Text(String),
    Emphasis {
        strength: EmphasisStrength,
        content: Vec<Inline>,
    },
    Code(String),
    /// An image: its alt as plain text, and what its reference came to.
    Image {
        alt: String,
        target: ImageTarget,
    },
    /// A link: its content, its destination as the parser gave it, and what it came to.
    Link {
        content: Vec<Inline>,
        destination: String,
        target: LinkTarget,
    },
}

/// How strongly a span is emphasised.
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum EmphasisStrength {
    Single,
    Strong,
}

/// What an image reference came to. A path is resolved only for a bitmap inside the folder; every
/// other reference is a placeholder carrying why, and its source as written.
#[derive(Debug, Clone, PartialEq, Eq)]
pub enum ImageTarget {
    /// The bitmap's path below the opened folder's root.
    Resolved(PathBuf),
    Placeholder {
        condition: PlaceholderCondition,
        source: String,
    },
}

/// Why an image is a placeholder.
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum PlaceholderCondition {
    OutsideTheFolder,
    Missing,
    Unreadable,
    FormatNotDecoded,
}

/// What a link came to: a target inside the folder, or inert text to be read.
#[derive(Debug, Clone, PartialEq, Eq)]
pub enum LinkTarget {
    /// The target's path below the opened folder's root.
    Relative(PathBuf),
    External,
}

/// Renders `text`, the decoded content of a Markdown file in `folder` (below the root, empty for the
/// root itself), into a document. Rendering is total: it has no failure arm. Every reference goes
/// through `check`, which is how the renderer reaches the disk without touching it.
pub(crate) fn render(text: &str, folder: &Path, check: &impl ContainmentCheck) -> MarkdownDocument {
    // CommonMark alone: a table, strikethrough, footnote or task marker reaches the fold as text.
    let events = Parser::new_ext(text, Options::empty()).into_offset_iter();
    fold::fold(text, events, folder, check)
}

#[cfg(test)]
#[path = "../tests/unit/markdown_renderer.rs"]
mod tests;
