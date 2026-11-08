import AppKit

/// The rendered Markdown page (`docs/DESIGN.md` § Components "Rendered Markdown"): one TextKit text
/// view in a scroll view, drawn node by node from a `MarkdownDocument`.
///
/// The attributed string is built from the nodes alone, never from HTML, a web archive or a Markdown
/// parser, so every text node reads as its characters exactly as the node holds them (CP-1105,
/// CP-1109). The page asks for nothing: it is handed the document and, for each resolved image path,
/// the bytes that were answered, and a path with no bytes is a refusal. It raises a relative link's
/// activation through `relativeLinkSink` with the node's target path, and an external link is text.
///
/// Nothing here edits, accepts a drop or draws a control (CP-1108).
@MainActor
package final class MarkdownPageView: NSView, NSTextViewDelegate {
    /// The text view holding the page. TextKit 1 from construction: the placeholder box and a code
    /// block are text blocks, which TextKit 2 does not lay out.
    package let textView: NSTextView

    /// Raised with the target path of a relative link when the reader activates it.
    package var relativeLinkSink: ((String) -> Void)?

    private let scrollView: NSScrollView

    /// The target path of each relative link on the page, by the opaque token its link attribute
    /// holds. The attribute never holds a URL or the destination (CP-1115).
    private var relativeTargets: [String] = []

    /// An empty page, not editable, accepting no drop, with nothing drawn until `show` is called.
    package init() {
        let layoutManager = MarkdownPageLayoutManager()
        let storage = NSTextStorage()
        storage.addLayoutManager(layoutManager)
        let container = NSTextContainer(
            size: NSSize(width: 0, height: CGFloat.greatestFiniteMagnitude))
        container.widthTracksTextView = true
        layoutManager.addTextContainer(container)

        let textView = PageTextView(frame: .zero, textContainer: container)
        textView.isEditable = false
        textView.isRichText = false
        textView.isSelectable = true
        textView.backgroundColor = CodeColors.surface
        textView.drawsBackground = true
        textView.minSize = .zero
        textView.maxSize = NSSize(
            width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
        textView.isVerticallyResizable = true
        textView.isHorizontallyResizable = false
        textView.autoresizingMask = [.width]
        textView.textContainerInset = NSSize(width: PageSpacing.inset, height: PageSpacing.inset)
        // A link's colour and underline come from the nodes, so a relative link looks like an
        // external one (CP-1114); only the link cursor remains.
        textView.linkTextAttributes = [:]
        textView.unregisterDraggedTypes()

        let scrollView = NSScrollView()
        scrollView.documentView = textView
        scrollView.backgroundColor = CodeColors.surface
        scrollView.drawsBackground = true
        scrollView.hasVerticalScroller = true
        scrollView.hasHorizontalScroller = false
        scrollView.automaticallyAdjustsContentInsets = false
        scrollView.contentInsets = NSEdgeInsetsZero
        scrollView.contentView.automaticallyAdjustsContentInsets = false
        scrollView.contentView.contentInsets = NSEdgeInsetsZero

        self.textView = textView
        self.scrollView = scrollView

        super.init(frame: .zero)

        textView.delegate = self
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        preconditionFailure("MarkdownPageView is built in code only")
    }

    /// Laid out from the top, so the page's first block sits under the path line.
    package override var isFlipped: Bool { true }

    /// Draws `document`, replacing the page whole. `imageBytes` holds the answered bytes of each
    /// resolved image by its folder-relative path; a path it lacks was refused.
    ///
    /// The page starts at the top, or with `keepingScroll` stays where the reader scrolled it,
    /// clamped to the new page.
    package func show(
        _ document: MarkdownDocument, imageBytes: [String: Data], keepingScroll: Bool = false
    ) {
        let offset = scrollOffset
        relativeTargets = []
        var builder = PageBuilder(imageBytes: imageBytes)
        builder.append(blocks: document.blocks)
        relativeTargets = builder.relativeTargets
        unsafe textView.textStorage?.setAttributedString(builder.text)
        if let container = unsafe textView.textContainer {
            unsafe textView.layoutManager?.ensureLayout(for: container)
        }
        textView.sizeToFit()
        scrollOffset = keepingScroll ? offset : 0
    }

    /// How far down the page the reader has scrolled it, in points. Setting it clamps to the page.
    package var scrollOffset: CGFloat {
        get { scrollView.contentView.bounds.origin.y }
        set {
            let clip = scrollView.contentView
            let reach = max(textView.frame.height - clip.bounds.height, 0)
            clip.scroll(to: NSPoint(x: 0, y: min(max(newValue, 0), reach)))
            scrollView.reflectScrolledClipView(clip)
        }
    }

    /// Every click on a link is handled here, so AppKit's own open (`NSWorkspace`) never runs. Only
    /// a relative link's token is one the page issued; anything else raises nothing.
    package func textView(_ textView: NSTextView, clickedOnLink link: Any, at charIndex: Int)
        -> Bool
    {
        if let token = link as? Int, relativeTargets.indices.contains(token) {
            relativeLinkSink?(relativeTargets[token])
        }
        return true
    }
}

/// The page's measures, in points (`docs/DESIGN.md` `{spacing.*}`, `{typography.prose-*}`).
private enum PageSpacing {
    static let inset: CGFloat = 24
    static let indentStep: CGFloat = 20
    static let paragraphGap: CGFloat = 12
    static let proseMeasure: CGFloat = 704
}

private enum PageType {
    static let body = NSFont.systemFont(ofSize: 15)
    static let code = NSFont.monospacedSystemFont(ofSize: 13, weight: .regular)
    static let path = NSFont.monospacedSystemFont(ofSize: 12, weight: .regular)
    static let lineMultiple: CGFloat = 1.6

    static func heading(_ level: MarkdownHeadingLevel) -> NSFont {
        switch level {
        case .one: NSFont.systemFont(ofSize: 24, weight: .semibold)
        case .two: NSFont.systemFont(ofSize: 20, weight: .semibold)
        case .three: NSFont.systemFont(ofSize: 17, weight: .semibold)
        case .four, .five, .six: NSFont.systemFont(ofSize: 15, weight: .semibold)
        }
    }
}

/// A text view that shows Copy alone in its menu (CP-1108).
private final class PageTextView: NSTextView {
    override func menu(for event: NSEvent) -> NSMenu? {
        super.menu(for: event).flatMap(keptTextMenu(from:))
    }
}

/// Builds the page's attributed string node by node. A block ends in a line break unless it is the
/// last thing built, so a page of one paragraph is that paragraph's characters alone.
private struct PageBuilder {
    private(set) var text = NSMutableAttributedString()
    private(set) var relativeTargets: [String] = []
    private let imageBytes: [String: Data]

    init(imageBytes: [String: Data]) {
        self.imageBytes = imageBytes
    }

    mutating func append(blocks: [MarkdownBlock], indent: Int = 0) {
        for block in blocks {
            append(block, indent: indent, marker: nil)
        }
    }

    private mutating func append(_ block: MarkdownBlock, indent: Int, marker: String?) {
        endLineIfNeeded()
        switch block {
        case .heading(let level, let content):
            appendProse(content, font: PageType.heading(level), indent: indent, marker: marker)
        case .paragraph(let content):
            appendProse(content, font: PageType.body, indent: indent, marker: marker)
        case .list(let kind, let items):
            appendMarker(marker, indent: indent)
            appendList(kind, items: items, indent: indent)
        case .quote(let blocks):
            appendMarker(marker, indent: indent)
            append(blocks: blocks, indent: indent + 1)
        case .rule:
            appendMarker(marker, indent: indent)
            appendRule(indent: indent)
        case .code(let code, let language):
            appendMarker(marker, indent: indent)
            appendCode(code, language: language, indent: indent)
        }
    }

    private mutating func appendList(
        _ kind: MarkdownListKind, items: [[MarkdownBlock]], indent: Int
    ) {
        for (offset, item) in items.enumerated() {
            let marker =
                switch kind {
                case .unordered: "• "
                case .ordered(let start): "\(start + UInt64(offset)). "
                }
            guard let first = item.first else {
                appendMarker(marker, indent: indent + 1)
                continue
            }
            append(first, indent: indent + 1, marker: marker)
            append(blocks: Array(item.dropFirst()), indent: indent + 1)
        }
    }

    /// A marker for a block that cannot carry it in its own first line gets a line of its own.
    private mutating func appendMarker(_ marker: String?, indent: Int) {
        guard let marker else { return }
        text.append(
            NSAttributedString(
                string: marker.trimmingCharacters(in: .whitespaces),
                attributes: Self.attributes(
                    font: PageType.body, indent: indent, hanging: false)))
        endLineIfNeeded()
    }

    private mutating func appendProse(
        _ content: [MarkdownInline], font: NSFont, indent: Int, marker: String?
    ) {
        let style = Self.attributes(font: font, indent: indent, hanging: marker != nil)
        if let marker {
            text.append(NSAttributedString(string: marker, attributes: style))
        }
        for inline in content {
            append(inline, font: font, base: style)
        }
    }

    private mutating func append(
        _ inline: MarkdownInline, font: NSFont, base: [NSAttributedString.Key: Any]
    ) {
        switch inline {
        case .text(let string):
            text.append(NSAttributedString(string: string, attributes: base))
        case .emphasis(let strength, let content):
            let traits: NSFontDescriptor.SymbolicTraits =
                strength == .strong ? .bold : .italic
            let styled = Self.font(font, adding: traits)
            var attributes = base
            attributes[.font] = styled
            for node in content {
                append(node, font: styled, base: attributes)
            }
        case .code(let code):
            var attributes = base
            attributes[.font] = PageType.code
            attributes[.backgroundColor] = CodeColors.canvas
            attributes[MarkdownPageLayoutManager.codeRun] = true
            text.append(NSAttributedString(string: code, attributes: attributes))
        case .image(let alt, let target):
            appendImage(alt: alt, target: target, base: base)
        case .link(let content, let destination, let target):
            appendLink(content, destination: destination, target: target, font: font, base: base)
        }
    }

    private mutating func appendLink(
        _ content: [MarkdownInline], destination: String, target: MarkdownLinkTarget,
        font: NSFont, base: [NSAttributedString.Key: Any]
    ) {
        var attributes = base
        attributes[.underlineStyle] = NSUnderlineStyle.single.rawValue
        attributes[.underlineColor] = CodeColors.inkMuted
        if case .relative(let path) = target {
            attributes[.link] = relativeTargets.count
            relativeTargets.append(path)
        }
        for node in content {
            append(node, font: font, base: attributes)
        }
        var destinationAttributes = base
        destinationAttributes[.font] = PageType.path
        destinationAttributes[.foregroundColor] = CodeColors.inkMuted
        text.append(
            NSAttributedString(string: " (\(destination))", attributes: destinationAttributes))
    }

    private mutating func appendImage(
        alt: String, target: MarkdownImageTarget, base: [NSAttributedString.Key: Any]
    ) {
        switch target {
        case .resolved(let path):
            if let image = Self.decoded(imageBytes[path]) {
                let attachment = NSTextAttachment()
                attachment.image = image
                attachment.bounds = Self.bounds(of: image)
                text.append(NSAttributedString(attachment: attachment))
            } else {
                appendBox(
                    alt: alt, source: path, sentence: ConditionSentences.imageUnreadable, base: base
                )
            }
        case .placeholder(let condition, let source):
            appendBox(
                alt: alt, source: source,
                sentence: ConditionSentences.imagePlaceholder(for: condition), base: base)
        }
    }

    /// The box where an image would sit: its alt text, its source beneath it, and the one sentence
    /// for what was observed, in a bordered block (CP-1111, CP-1112). Nothing in it is image bytes.
    private mutating func appendBox(
        alt: String, source: String, sentence: String, base: [NSAttributedString.Key: Any]
    ) {
        endLineIfNeeded()
        let block = PlaceholderBoxBlock(canvas: CodeColors.canvas, line: CodeColors.line)
        let lines: [(String, NSFont, NSColor)] = [
            (alt, PageType.body, CodeColors.primary),
            (source, PageType.path, CodeColors.inkMuted),
            (sentence, PageType.body, CodeColors.inkMuted),
        ]
        for (string, font, ink) in lines {
            let style = NSMutableParagraphStyle()
            style.textBlocks = [block]
            style.paragraphSpacing = 0
            text.append(
                NSAttributedString(
                    string: string + "\n",
                    attributes: [.font: font, .foregroundColor: ink, .paragraphStyle: style]))
        }
    }

    private mutating func appendRule(indent: Int) {
        var attributes = Self.attributes(font: PageType.body, indent: indent, hanging: false)
        attributes[.strikethroughStyle] = NSUnderlineStyle.single.rawValue
        attributes[.strikethroughColor] = CodeColors.line
        text.append(
            NSAttributedString(
                string: String(repeating: "\u{A0}", count: 48), attributes: attributes))
    }

    /// Every paragraph of the code goes in one `CodeBlockSurface`, built once per code node. The
    /// indent the code stands at is the surface's left margin, and the paragraphs inside it have no
    /// head indent of their own.
    private mutating func appendCode(_ code: String, language: Language, indent: Int) {
        var attributes = Self.attributes(font: PageType.code, indent: 0, hanging: false)
        attributes[.foregroundColor] = CodeColors.primary
        if let style = attributes[.paragraphStyle] as? NSMutableParagraphStyle {
            style.textBlocks = [
                CodeBlockSurface(
                    canvas: CodeColors.canvas, leftMargin: CGFloat(indent) * PageSpacing.indentStep)
            ]
        }
        let block = NSMutableAttributedString(string: code, attributes: attributes)
        if case .floor(_, let spans) = language {
            for (span, range) in zip(spans, SpanRanges.utf16(of: spans, in: code)) {
                block.addAttribute(
                    .foregroundColor, value: CodeColors.color(for: span.tokenClass), range: range)
            }
        }
        text.append(block)
    }

    private mutating func endLineIfNeeded() {
        guard text.length > 0, !text.string.hasSuffix("\n") else { return }
        text.append(NSAttributedString(string: "\n"))
    }

    private static func attributes(font: NSFont, indent: Int, hanging: Bool)
        -> [NSAttributedString.Key: Any]
    {
        let style = NSMutableParagraphStyle()
        let start = CGFloat(indent) * PageSpacing.indentStep
        style.firstLineHeadIndent = hanging ? start - PageSpacing.indentStep : start
        style.headIndent = start
        style.paragraphSpacing = PageSpacing.paragraphGap
        style.minimumLineHeight = font.pointSize * PageType.lineMultiple
        style.maximumLineHeight = font.pointSize * PageType.lineMultiple
        return [.font: font, .foregroundColor: CodeColors.primary, .paragraphStyle: style]
    }

    private static func font(_ font: NSFont, adding traits: NSFontDescriptor.SymbolicTraits)
        -> NSFont
    {
        let descriptor = font.fontDescriptor.withSymbolicTraits(
            font.fontDescriptor.symbolicTraits.union(traits))
        return NSFont(descriptor: descriptor, size: font.pointSize) ?? font
    }

    /// The image the bytes decode to, or nil when there are no bytes or they make no bitmap. A
    /// non-nil `NSImage` from malformed data can still hold no bitmap, so a missing `CGImage` or an
    /// empty pixel size counts as not decoded.
    private static func decoded(_ bytes: Data?) -> NSImage? {
        guard let bytes, let image = NSImage(data: bytes) else { return nil }
        var rect = CGRect(origin: .zero, size: image.size)
        guard image.size.width > 0, image.size.height > 0,
            let cgImage = unsafe image.cgImage(forProposedRect: &rect, context: nil, hints: nil),
            cgImage.width > 0, cgImage.height > 0
        else { return nil }
        return image
    }

    private static func bounds(of image: NSImage) -> CGRect {
        let scale = min(1, PageSpacing.proseMeasure / image.size.width)
        return CGRect(
            origin: .zero,
            size: CGSize(width: image.size.width * scale, height: image.size.height * scale))
    }
}
