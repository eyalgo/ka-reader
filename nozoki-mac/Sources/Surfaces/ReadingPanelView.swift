import AppKit

/// The reading panel (`docs/UXD.md` UX-S1, `docs/DESIGN.md` § Components): what the open file
/// turned out to be, drawn plain under its folder-relative path. It has four states and is in one
/// of them at a time:
///
/// - *no file*: the prompt, and nothing else visible;
/// - *text*: the path line, then the file's text as written in a non-editable view;
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
        // Plain is the only language, and plain is drawn with no colour (CP-275).
        switch language {
        case .plain: break
        }
        contentView.string = content
        contentView.font = .monospacedSystemFont(ofSize: Self.contentPointSize, weight: .regular)
        scrollView.isHidden = content.isEmpty
        guard !content.isEmpty else { return }
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(
                equalTo: pathLine.bottomAnchor, constant: Self.gap),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
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
}
