/// A Markdown file as the shell holds it: its blocks, in source order, as the bridge sent them. The
/// shell draws only what the document holds; no node carries markup or a URL the shell fetches.
package nonisolated struct MarkdownDocument: Equatable, Sendable {
    package let blocks: [MarkdownBlock]

    package init(blocks: [MarkdownBlock]) {
        self.blocks = blocks
    }

    /// The folder-relative path of every resolved image node, in source order, once per node: those
    /// nested inside list items, quotes, emphasis and link content included. A placeholder node
    /// contributes none. The panel asks for one set of bytes per entry.
    package var resolvedImagePaths: [String] {
        blocks.flatMap(\.resolvedImagePaths)
    }
}

/// A block of a document. A heading and a paragraph hold inline nodes; a list item and a quote hold
/// the blocks inside them.
package nonisolated indirect enum MarkdownBlock: Equatable, Sendable {
    case heading(MarkdownHeadingLevel, [MarkdownInline])
    case paragraph([MarkdownInline])
    case list(MarkdownListKind, items: [[MarkdownBlock]])
    case quote([MarkdownBlock])
    case rule
    /// Code, whole as the node holds it, and how it is drawn: a floor language carries its spans.
    case code(String, Language)

    fileprivate var resolvedImagePaths: [String] {
        switch self {
        case .heading(_, let content), .paragraph(let content):
            content.flatMap(\.resolvedImagePaths)
        case .list(_, let items):
            items.flatMap { $0.flatMap(\.resolvedImagePaths) }
        case .quote(let blocks):
            blocks.flatMap(\.resolvedImagePaths)
        case .rule, .code:
            []
        }
    }
}

/// A heading's level, one of the six Markdown has.
package nonisolated enum MarkdownHeadingLevel: Int, CaseIterable, Sendable {
    case one = 1
    case two
    case three
    case four
    case five
    case six
}

/// Whether a list is numbered, and from where.
package nonisolated enum MarkdownListKind: Equatable, Sendable {
    case unordered
    case ordered(start: UInt64)
}

/// A node inside a heading, a paragraph, an emphasis or a link.
package nonisolated indirect enum MarkdownInline: Equatable, Sendable {
    /// Text, raw HTML included, held as its source: it is drawn as these characters.
    case text(String)
    case emphasis(MarkdownEmphasis, [MarkdownInline])
    case code(String)
    case image(alt: String, MarkdownImageTarget)
    case link([MarkdownInline], destination: String, MarkdownLinkTarget)

    fileprivate var resolvedImagePaths: [String] {
        switch self {
        case .text, .code:
            []
        case .emphasis(_, let content), .link(let content, _, _):
            content.flatMap(\.resolvedImagePaths)
        case .image(_, .resolved(let path)):
            [path]
        case .image(_, .placeholder):
            []
        }
    }
}

/// How strongly a span is emphasised.
package nonisolated enum MarkdownEmphasis: Equatable, Sendable {
    case single
    case strong
}

/// What an image reference came to: a bitmap inside the folder, to be asked for by its path, or a
/// placeholder carrying why and the source as written.
package nonisolated enum MarkdownImageTarget: Equatable, Sendable {
    case resolved(path: String)
    case placeholder(ImagePlaceholderCondition, source: String)
}

/// Why an image is a placeholder, as the bridge names it on the wire.
package nonisolated enum ImagePlaceholderCondition: String, CaseIterable, Sendable {
    case outsideTheFolder = "outside_the_folder"
    case missing
    case unreadable
    case formatNotDecoded = "format_not_decoded"
}

/// What a link came to: a target inside the folder, or inert text to be read.
package nonisolated enum MarkdownLinkTarget: Equatable, Sendable {
    case relative(path: String)
    case external
}
