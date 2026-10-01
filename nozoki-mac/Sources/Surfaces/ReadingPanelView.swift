import AppKit

/// The reading panel (`docs/UXD.md` UX-S1, `docs/DESIGN.md` § Components): what the open file
/// turned out to be, under its folder-relative path. It has four states and is in one of them at a
/// time:
///
/// - *no file*: the prompt, and nothing else visible;
/// - *text*: the path line, then the file's text as written in a non-editable view, on the
///   `surface` ground: a floor-language file's spans in their code colours and every other
///   character in the system's text colour, and a plain file's text in that one colour (CP-312);
/// - *cannot-display*: the path line, then one sentence saying the file can't be shown as text;
/// - *failed read*: the path line, then one statement of what Nozoki observed.
///
/// The panel has no control: nothing in it edits, saves or writes (CP-286). The text sits in a
/// scroll view pinned to the panel's edges, so the document's size never reaches the window.
@MainActor
package final class ReadingPanelView: NSView {
    private static let readingPrompt = "Select a file to view."

    /// `docs/DESIGN.md` § Components "Status messages": a status message is inset `{spacing.xl}`
    /// from its surface's top-left.
    private static let inset: CGFloat = 24

    /// `docs/DESIGN.md` `{spacing.sm}`: between the path line and what is beneath it.
    private static let gap: CGFloat = 8

    private static let contentPointSize: CGFloat = 13

    private let statusGlyphs: StatusGlyphs
    private let prompt: StatusMessageView
    private var message: StatusMessageView?
    private let scrollView: NSScrollView

    /// Whether the scroll view has been pinned beneath the path line. It is pinned once, by the first
    /// text with content, and stays pinned: a hidden scroll view takes no part in what is drawn.
    private var isScrollViewPinned = false

    /// The path line: the entry's folder-relative path, in the path type.
    package let pathLine: NSTextField

    /// The text view holding a text file's content. It is never editable.
    package let contentView: NSTextView

    package init(statusGlyphs: StatusGlyphs) {
        self.statusGlyphs = statusGlyphs
        prompt = StatusMessageView(
            glyph: statusGlyphs.empty,
            texts: [NSTextField(labelWithString: Self.readingPrompt)])

        pathLine = NSTextField(labelWithString: "")
        pathLine.font = .monospacedSystemFont(ofSize: Self.contentPointSize, weight: .regular)
        pathLine.lineBreakMode = .byTruncatingMiddle
        pathLine.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)

        scrollView = NSTextView.scrollableTextView()
        contentView = scrollView.documentView as? NSTextView ?? NSTextView()
        contentView.isEditable = false
        contentView.isRichText = false
        contentView.isSelectable = true
        contentView.font = .monospacedSystemFont(ofSize: Self.contentPointSize, weight: .regular)
        // The ground is the views' own background, never a `.backgroundColor` text attribute, so a
        // plain file's text carries none (CP-315).
        contentView.backgroundColor = CodeColors.surface
        contentView.drawsBackground = true
        scrollView.backgroundColor = CodeColors.surface
        scrollView.drawsBackground = true
        scrollView.hasVerticalScroller = true
        scrollView.hasHorizontalScroller = true
        contentView.isHorizontallyResizable = true
        contentView.textContainer?.widthTracksTextView = false
        contentView.textContainer?.containerSize = NSSize(
            width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)

        super.init(frame: .zero)

        for view in [prompt, pathLine, scrollView] {
            view.translatesAutoresizingMaskIntoConstraints = false
            addSubview(view)
        }
        // Nothing ties the prompt or the path line to the panel's bottom: with the label as the
        // panel, its one line's height became the window's (change_spec.md § Verified Claims).
        NSLayoutConstraint.activate([
            prompt.topAnchor.constraint(equalTo: topAnchor, constant: Self.inset),
            prompt.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Self.inset),
            prompt.trailingAnchor.constraint(
                lessThanOrEqualTo: trailingAnchor, constant: -Self.inset),
            pathLine.topAnchor.constraint(equalTo: topAnchor, constant: Self.inset),
            pathLine.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Self.inset),
            pathLine.trailingAnchor.constraint(
                lessThanOrEqualTo: trailingAnchor, constant: -Self.inset),
        ])
        showNoFile()
    }

    @available(*, unavailable)
    package required init?(coder: NSCoder) {
        preconditionFailure("ReadingPanelView is built in code only")
    }

    /// Returns the panel to its no-file state: the prompt, and nothing else visible.
    package func showNoFile() {
        removeMessage()
        pathLine.isHidden = true
        scrollView.isHidden = true
        contentView.string = ""
        prompt.isHidden = false
    }

    /// Draws `verdict` beneath `path`, the entry's folder-relative path.
    package func show(path: String, verdict: FileVerdict) {
        removeMessage()
        prompt.isHidden = true
        pathLine.stringValue = path
        pathLine.isHidden = false
        let name = path.split(separator: "/").last.map(String.init) ?? path
        switch verdict {
        case .text(let content, let language):
            showText(content, language: language)
        case .cannotDisplay:
            showMessage(
                glyph: statusGlyphs.empty,
                sentence: ConditionSentences.cannotDisplay(fileNamed: name))
        case .failed(let condition):
            showMessage(
                glyph: statusGlyphs.failure,
                sentence: ConditionSentences.reading(fileNamed: name, failedWith: condition))
        }
    }

    private func showText(_ content: String, language: Language) {
        // One replacement of the whole text storage, so nothing of the previous file's colours, or
        // the view's typing attributes, reaches this one (CP-313).
        contentView.textStorage?.setAttributedString(
            Self.attributedText(content, language: language))
        scrollView.isHidden = content.isEmpty
        guard !content.isEmpty else { return }
        if !isScrollViewPinned {
            NSLayoutConstraint.activate([
                scrollView.topAnchor.constraint(
                    equalTo: pathLine.bottomAnchor, constant: Self.gap),
                scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
                scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
                scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            ])
            isScrollViewPinned = true
        }
        contentView.scrollToBeginningOfDocument(nil)
    }

    private func showMessage(glyph: NSImage, sentence: String) {
        scrollView.isHidden = true
        contentView.string = ""
        let label = NSTextField(wrappingLabelWithString: sentence)
        label.isSelectable = false
        let view = StatusMessageView(glyph: glyph, texts: [label])
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: pathLine.bottomAnchor, constant: Self.gap),
            view.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Self.inset),
            view.trailingAnchor.constraint(
                lessThanOrEqualTo: trailingAnchor, constant: -Self.inset),
        ])
        message = view
    }

    private func removeMessage() {
        message?.removeFromSuperview()
        message = nil
    }

    private static func attributedText(_ content: String, language: Language) -> NSAttributedString {
        let text = NSMutableAttributedString(
            string: content,
            attributes: [
                .font: NSFont.monospacedSystemFont(ofSize: contentPointSize, weight: .regular),
                .foregroundColor: NSColor.textColor,
            ])
        guard case .floor(_, let spans) = language else { return text }
        for (span, range) in zip(spans, utf16Ranges(of: spans, in: content)) {
            text.addAttribute(
                .foregroundColor, value: CodeColors.color(for: span.tokenClass), range: range)
        }
        return text
    }

    /// The UTF-16 range each span covers. The spans' offsets are UTF-8 bytes (the wire's unit) and
    /// AppKit counts UTF-16 units, so one forward pass over the content's Unicode scalars adds up
    /// both widths and maps each offset as the pass reaches it. The spans ascend and fall on scalar
    /// boundaries (the decoder guarantees it), and a Swift `Character` is a grapheme, not the
    /// core's boundary.
    private static func utf16Ranges(of spans: [CodeSpan], in content: String) -> [NSRange] {
        var scalars = content.unicodeScalars.makeIterator()
        var bytes = 0
        var units = 0
        func unit(atByte target: Int) -> Int {
            while bytes < target, let scalar = scalars.next() {
                bytes += UTF8.width(scalar)
                units += UTF16.width(scalar)
            }
            return units
        }
        return spans.map { span in
            let start = unit(atByte: span.start)
            let end = unit(atByte: span.end)
            return NSRange(location: start, length: end - start)
        }
    }
}

/// The five code tokens and the `surface` ground, each with the light and dark values of
/// `docs/DESIGN.md` § Colors "The two themes". A colour resolves when it is drawn, so an appearance
/// change recolours the text without the file being selected again (CP-314), the way
/// `RootItemsView`'s bar colour does.
private enum CodeColors {
    static let surface = dynamic(light: 0xFBFBFA, dark: 0x1B1C1E)
    private static let keyword = dynamic(light: 0x7A2E8F, dark: 0xD0A2E6)
    private static let string = dynamic(light: 0x1A6B3A, dark: 0x8FD6A4)
    private static let number = dynamic(light: 0x9A4B00, dark: 0xF0B47A)
    private static let comment = dynamic(light: 0x6A6C72, dark: 0x9A9BA0)
    private static let name = dynamic(light: 0x0F5A9A, dark: 0x8CC4F5)

    static func color(for tokenClass: TokenClass) -> NSColor {
        switch tokenClass {
        case .keyword: return keyword
        case .string: return string
        case .number: return number
        case .comment: return comment
        case .name: return name
        }
    }

    private static func dynamic(light: UInt32, dark: UInt32) -> NSColor {
        NSColor(name: nil) { appearance in
            srgb(appearance.bestMatch(from: [.darkAqua, .aqua]) == .darkAqua ? dark : light)
        }
    }

    private static func srgb(_ value: UInt32) -> NSColor {
        NSColor(
            srgbRed: CGFloat((value >> 16) & 0xFF) / 255,
            green: CGFloat((value >> 8) & 0xFF) / 255,
            blue: CGFloat(value & 0xFF) / 255, alpha: 1)
    }
}
