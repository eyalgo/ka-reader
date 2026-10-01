import AppKit

/// The reading panel (`docs/UXD.md` UX-S1, `docs/DESIGN.md` § Components): what the open file
/// turned out to be, under its folder-relative path. It has four states and is in one of them at a
/// time:
///
/// - *no file*: the prompt, and nothing else visible;
/// - *text*: the path line, then the file's text as written in a non-editable view, on the
///   `surface` ground, beside a line-number gutter: a floor-language file's spans in their code
///   colours and every other character in `{colors.primary}`, and a plain file's text in that one
///   ink (CP-312, CP-333);
/// - *cannot-display*: the path line, then one sentence saying the file can't be shown as text;
/// - *failed read*: the path line, then one statement of what Nozoki observed.
///
/// The panel has no control: nothing in it edits, saves or writes (CP-286). The text sits in a code
/// view, its gutter and scroll view, pinned to the panel's edges, so the document's size never
/// reaches the window.
@MainActor
package final class ReadingPanelView: NSView {
    private static let readingPrompt = "Select a file to view."

    /// `docs/DESIGN.md` § Components "Status messages": a status message is inset `{spacing.xl}`
    /// from its surface's top-left.
    private static let inset: CGFloat = 24

    /// `docs/DESIGN.md` `{spacing.sm}`: between the path line and what is beneath it.
    private static let gap: CGFloat = 8

    private static let pathPointSize: CGFloat = 13

    private let statusGlyphs: StatusGlyphs
    private let prompt: StatusMessageView
    private var message: StatusMessageView?
    private let codeView: CodeView

    /// Whether the code view has been pinned beneath the path line. It is pinned once, by the first
    /// text with content, and stays pinned: a hidden code view takes no part in what is drawn.
    private var isCodeViewPinned = false

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
        pathLine.font = .monospacedSystemFont(ofSize: Self.pathPointSize, weight: .regular)
        pathLine.lineBreakMode = .byTruncatingMiddle
        pathLine.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)

        codeView = CodeView()
        contentView = codeView.textView

        super.init(frame: .zero)

        for view in [prompt, pathLine, codeView] {
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
        codeView.isHidden = true
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
        codeView.isHidden = true
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
        // the view's typing attributes, reaches this one (CP-313). The code view also rebuilds its
        // gutter and scrolls to the top-left.
        codeView.show(Self.attributedText(content, language: language))
        codeView.isHidden = content.isEmpty
        guard !content.isEmpty else { return }
        if !isCodeViewPinned {
            NSLayoutConstraint.activate([
                codeView.topAnchor.constraint(
                    equalTo: pathLine.bottomAnchor, constant: Self.gap),
                codeView.leadingAnchor.constraint(equalTo: leadingAnchor),
                codeView.trailingAnchor.constraint(equalTo: trailingAnchor),
                codeView.bottomAnchor.constraint(equalTo: bottomAnchor),
            ])
            isCodeViewPinned = true
        }
    }

    private func showMessage(glyph: NSImage, sentence: String) {
        codeView.isHidden = true
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

    private static func attributedText(_ content: String, language: Language) -> NSAttributedString
    {
        // Every row is `CodeType.linePitch` tall, fixed: `lineHeightMultiple` would multiply the
        // font's own 16-point line height, giving 24.8 (CP-332).
        let pitch = NSMutableParagraphStyle()
        pitch.minimumLineHeight = CodeType.linePitch
        pitch.maximumLineHeight = CodeType.linePitch
        let text = NSMutableAttributedString(
            string: content,
            attributes: [
                .font: CodeType.font,
                .paragraphStyle: pitch,
                .foregroundColor: CodeColors.primary,
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
