import AppKit

/// The reading panel (`docs/UXD.md` UX-S1, `docs/DESIGN.md` § Components): what the open file
/// turned out to be, under its folder-relative path. It has seven states and is in one of them at a
/// time:
///
/// - *no file*: the prompt, and nothing else visible;
/// - *text*: the path line, then the file's text as written in a non-editable view, on the
///   `surface` ground, beside a line-number gutter: a floor-language file's spans in their code
///   colours and every other character in `{colors.primary}`, and a plain file's text in that one
///   ink (CP-312, CP-333);
/// - *cannot-display*: the path line, then one sentence saying the file can't be shown as text;
/// - *gone*: the path line, then the failure glyph and one sentence saying the file is no longer
///   there, with no content drawn;
/// - *failed read*: the path line, then one statement of what KA-Reader observed;
/// - *reading*: one status message saying the file's read is out, and no path line (CP-345);
/// - *stopped*: the path line, then one status message saying the read stopped without a cause
///   KA-Reader can state (CP-348).
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

    /// Between the path line's hairline and what is beneath it. `docs/DESIGN.md` prescribes no value
    /// for this separation, so CP-364 keeps the 8 points the panel already drew, now measured from the
    /// hairline's bottom edge.
    private static let gap: CGFloat = 8

    /// `docs/DESIGN.md` `{typography.path}`: the monospaced system font at 12 points, regular weight.
    private static let pathPointSize: CGFloat = 12

    /// `docs/DESIGN.md` `{spacing.lg}`: the path text's distance from the panel's left and right
    /// edges, measured to the drawn text (CP-361).
    private static let pathInset: CGFloat = 16

    /// `docs/DESIGN.md` `{spacing.row}` and `{spacing.hairline}`: the path line's row, and the
    /// hairline directly beneath it (CP-360, CP-363).
    private static let rowHeight: CGFloat = 24
    private static let hairlineHeight: CGFloat = 1

    private let statusGlyphs: StatusGlyphs
    private let prompt: StatusMessageView
    private var message: StatusMessageView?
    private let codeView: CodeView

    /// Whether the code view has been pinned beneath the path line. It is pinned once, by the first
    /// text with content, and stays pinned: a hidden code view takes no part in what is drawn.
    private var isCodeViewPinned = false

    /// What the panel last drew for a file, so an update can tell what is showing: nil while no file
    /// is drawn (the prompt, *reading*, *stopped*).
    private var drawn: (path: String, verdict: FileVerdict)?

    /// Where the code view stood the last time the panel set it or reported it. A scroll report is
    /// raised only for a position other than this one.
    private var lastPosition = ReadingPosition.topLeft

    /// Whether a scroll report is waiting for the end of the current main run-loop turn.
    private var isReportScheduled = false

    /// The path line: the entry's folder-relative path, in the path type.
    package let pathLine: NSTextField

    /// The path line's row and the hairline beneath it. Drawing only; shown exactly when the path
    /// line is.
    let pathRow = PathLineRowView()
    let pathHairline = PathLineHairlineView()

    /// The text view holding a text file's content. It is never editable.
    package let contentView: NSTextView

    package init(statusGlyphs: StatusGlyphs) {
        self.statusGlyphs = statusGlyphs
        prompt = StatusMessageView(
            glyph: statusGlyphs.empty,
            texts: [NSTextField(labelWithString: Self.readingPrompt)])

        pathLine = NSTextField(labelWithString: "")
        pathLine.font = .monospacedSystemFont(ofSize: Self.pathPointSize, weight: .regular)
        pathLine.textColor = CodeColors.inkMuted
        pathLine.lineBreakMode = .byTruncatingMiddle
        pathLine.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)

        codeView = CodeView()
        contentView = codeView.textView

        super.init(frame: .zero)

        for view in [prompt, pathRow, pathHairline, codeView] {
            view.translatesAutoresizingMaskIntoConstraints = false
            addSubview(view)
        }
        pathLine.translatesAutoresizingMaskIntoConstraints = false
        pathRow.addSubview(pathLine)
        // Nothing ties the prompt or the path line to the panel's bottom: with the label as the
        // panel, its one line's height became the window's (change_spec.md § Verified Claims).
        NSLayoutConstraint.activate([
            prompt.topAnchor.constraint(equalTo: topAnchor, constant: Self.inset),
            prompt.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Self.inset),
            prompt.trailingAnchor.constraint(
                lessThanOrEqualTo: trailingAnchor, constant: -Self.inset),
            pathRow.topAnchor.constraint(equalTo: topAnchor),
            pathRow.leadingAnchor.constraint(equalTo: leadingAnchor),
            pathRow.trailingAnchor.constraint(equalTo: trailingAnchor),
            pathRow.heightAnchor.constraint(equalToConstant: Self.rowHeight),
            pathHairline.topAnchor.constraint(equalTo: pathRow.bottomAnchor),
            pathHairline.leadingAnchor.constraint(equalTo: leadingAnchor),
            pathHairline.trailingAnchor.constraint(equalTo: trailingAnchor),
            pathHairline.heightAnchor.constraint(equalToConstant: Self.hairlineHeight),
            // A label draws its text inside its own frame, not at the frame's edge, so the field
            // starts that much short of the 16 and the drawn text begins at it. The right limit is
            // the frame's own edge: the text stays inside it.
            pathLine.leadingAnchor.constraint(
                equalTo: pathRow.leadingAnchor,
                constant: Self.pathInset - Self.textOffset(of: pathLine)),
            pathLine.trailingAnchor.constraint(
                lessThanOrEqualTo: pathRow.trailingAnchor, constant: -Self.pathInset),
            pathLine.centerYAnchor.constraint(equalTo: pathRow.centerYAnchor),
        ])
        codeView.isHidden = true
        codeView.onReaderScroll = { [weak self] in self?.readerScrolled() }
        showNoFile()
    }

    /// How far in from its frame's left edge a label draws its text.
    private static func textOffset(of label: NSTextField) -> CGFloat {
        label.cell?.drawingRect(forBounds: NSRect(x: 0, y: 0, width: 100, height: rowHeight)).minX
            ?? 0
    }

    /// The path row and the hairline show and hide together, and with the path line they hold: one
    /// switch, so a state added later cannot show one without the others (CP-363).
    private var isPathLineShown: Bool {
        get { !pathRow.isHidden }
        set {
            pathRow.isHidden = !newValue
            pathHairline.isHidden = !newValue
        }
    }

    @available(*, unavailable)
    package required init?(coder: NSCoder) {
        preconditionFailure("ReadingPanelView is built in code only")
    }

    /// Returns the panel to its no-file state: the prompt, and nothing else visible.
    package func showNoFile() {
        drawn = nil
        removeMessage()
        isPathLineShown = false
        codeView.isHidden = true
        contentView.string = ""
        prompt.isHidden = false
    }

    /// Draws the *reading* state: one status message, led by the empty glyph, and nothing of any
    /// earlier state (CP-345, CP-346).
    package func showReading() {
        drawn = nil
        removeMessage()
        prompt.isHidden = true
        isPathLineShown = false
        // Anchored where the prompt stands: with the path line hidden, a message hung from the
        // hairline would sit a row and a hairline too low.
        placeMessage(
            glyph: statusGlyphs.empty, sentence: ConditionSentences.readingFile,
            below: topAnchor, gap: Self.inset)
    }

    /// Draws the *stopped* state under `path`, the entry's folder-relative path: the failed read's
    /// presentation, with the sentence for a read that answered nothing (CP-348).
    package func showStopped(path: String) {
        drawn = nil
        removeMessage()
        prompt.isHidden = true
        pathLine.stringValue = path
        isPathLineShown = true
        showMessage(glyph: statusGlyphs.failure, sentence: ConditionSentences.stoppedReadingFile)
    }

    /// Draws `verdict` beneath `path`, the entry's folder-relative path. A text answer is drawn
    /// scrolled to the top-left: this is a selection's answer, the start of reading a file.
    package func show(path: String, verdict: FileVerdict) {
        beginDrawing(path: path, verdict: verdict)
        if case .text(let content, let language) = verdict {
            showText(content, language: language)
        } else {
            showNonText(path: path, verdict: verdict)
        }
        lastPosition = codeView.readingPosition
    }

    /// An automatic update of the open file: what a re-read of `path` gave, and the reading position
    /// the model holds (`docs/SDD.md` § 3 `surfaces`, C-E2).
    ///
    /// - With the text of `path` showing, new text replaces it in place and the scroll stays where
    ///   the reader left it, clamped to the new text. The model's `position` is not applied: the
    ///   panel's own scroll is the newer, and a position act may still be on its way.
    /// - A verdict equal to the one drawn changes nothing, the scroll included.
    /// - Text arriving while the panel shows something else for `path` (a message, another file) is
    ///   drawn and scrolled to `position`, clamped: a recovery, or the first draw.
    /// - Gone, a failure and cannot-display are drawn as `show` draws them, with no content.
    ///
    /// It never draws the pending sentence, and the code view is never emptied on the way to new text.
    package func update(path: String, verdict: FileVerdict, position: ReadingPosition) {
        if let drawn, drawn.path == path, drawn.verdict == verdict { return }
        guard case .text(let content, let language) = verdict else {
            beginDrawing(path: path, verdict: verdict)
            showNonText(path: path, verdict: verdict)
            lastPosition = codeView.readingPosition
            return
        }
        let wasShowingText: Bool
        if let drawn, drawn.path == path, case .text = drawn.verdict {
            wasShowingText = true
        } else {
            wasShowingText = false
        }
        beginDrawing(path: path, verdict: verdict)
        if wasShowingText {
            showText(content, language: language, keepingScroll: true)
        } else {
            showText(content, language: language)
            layoutSubtreeIfNeeded()
            codeView.restore(position)
        }
        lastPosition = codeView.readingPosition
    }

    /// The part of drawing a file's answer every arm shares: the old message goes, the prompt stays
    /// away, and the path line shows `path`.
    private func beginDrawing(path: String, verdict: FileVerdict) {
        drawn = (path, verdict)
        removeMessage()
        prompt.isHidden = true
        pathLine.stringValue = path
        isPathLineShown = true
    }

    private func showNonText(path: String, verdict: FileVerdict) {
        let name = path.split(separator: "/").last.map(String.init) ?? path
        switch verdict {
        case .text:
            preconditionFailure("showNonText draws what is not text")
        case .cannotDisplay:
            showMessage(
                glyph: statusGlyphs.empty,
                sentence: ConditionSentences.cannotDisplay(fileNamed: name))
        case .failed(let condition):
            showMessage(
                glyph: statusGlyphs.failure,
                sentence: ConditionSentences.reading(fileNamed: name, failedWith: condition))
        case .gone:
            showMessage(glyph: statusGlyphs.failure, sentence: ConditionSentences.fileGone)
        }
    }

    /// Where the code view is scrolled to now.
    var currentPosition: ReadingPosition { codeView.readingPosition }

    /// Raised when the reader scrolls the code view, with where the scroll left it. Never raised for
    /// a scroll the panel makes itself. Scrolls are coalesced: at most one report per main run-loop
    /// turn, carrying the position the turn ended on.
    package var positionChanged: (@MainActor (ReadingPosition) -> Void)?

    private func readerScrolled() {
        guard !isReportScheduled else { return }
        isReportScheduled = true
        DispatchQueue.main.async { [weak self] in
            MainActor.assumeIsolated { self?.reportPosition() }
        }
    }

    private func reportPosition() {
        isReportScheduled = false
        let position = codeView.readingPosition
        guard position != lastPosition else { return }
        lastPosition = position
        positionChanged?(position)
    }

    private func showText(_ content: String, language: Language, keepingScroll: Bool = false) {
        // One replacement of the whole text storage, so nothing of the previous file's colours, or
        // the view's typing attributes, reaches this one (CP-313). The code view also rebuilds its
        // gutter. A selection's answer scrolls to the top-left; an update in place keeps the scroll.
        let text = Self.attributedText(content, language: language)
        if keepingScroll {
            codeView.replaceText(text)
        } else {
            codeView.show(text)
        }
        codeView.isHidden = content.isEmpty
        guard !content.isEmpty else { return }
        if !isCodeViewPinned {
            NSLayoutConstraint.activate([
                codeView.topAnchor.constraint(
                    equalTo: pathHairline.bottomAnchor, constant: Self.gap),
                codeView.leadingAnchor.constraint(equalTo: leadingAnchor),
                codeView.trailingAnchor.constraint(equalTo: trailingAnchor),
                codeView.bottomAnchor.constraint(equalTo: bottomAnchor),
            ])
            isCodeViewPinned = true
        }
    }

    private func showMessage(glyph: NSImage, sentence: String) {
        placeMessage(
            glyph: glyph, sentence: sentence, below: pathHairline.bottomAnchor, gap: Self.gap)
    }

    private func placeMessage(
        glyph: NSImage, sentence: String, below anchor: NSLayoutYAxisAnchor, gap: CGFloat
    ) {
        codeView.isHidden = true
        contentView.string = ""
        let label = NSTextField(wrappingLabelWithString: sentence)
        label.isSelectable = false
        let view = StatusMessageView(glyph: glyph, texts: [label])
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: anchor, constant: gap),
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
        for (span, range) in zip(spans, SpanRanges.utf16(of: spans, in: content)) {
            text.addAttribute(
                .foregroundColor, value: CodeColors.color(for: span.tokenClass), range: range)
        }
        return text
    }
}
