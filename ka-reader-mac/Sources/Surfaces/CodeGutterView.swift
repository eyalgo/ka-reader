import AppKit

/// The line-number gutter (`docs/DESIGN.md` § Components *Code*): it numbers the rows one TextKit 1
/// text view draws, draws the numbers, and reports what it draws.
///
/// A row is a line fragment of the text view's layout, so the numbers follow what is drawn whatever
/// broke the line (CP-336), and the column's digit count comes from the same enumeration as the last
/// number (CP-337). The extra fragment TextKit adds after a terminal break is no row.
///
/// The gutter's top is the top of the text view's clip view, as the code view pins it, so a row's
/// place in the gutter is its place in the text view less the clip view's scroll offset.
///
/// It is no control, holds no subview and registers no dragged type (CP-338, CP-343).
final class CodeGutterView: NSView {
    /// One number as drawn: its text, where it is drawn and what it is drawn with.
    struct Label {
        let text: String

        /// The number's right end (`x`) and its baseline (`y`), in the gutter's own coordinates.
        let point: NSPoint

        let attributes: [NSAttributedString.Key: Any]
    }

    /// A row of the layout, in the text container's coordinates.
    private struct Row {
        let top: CGFloat
        let bottom: CGFloat
        let baseline: CGFloat
    }

    private let textView: NSTextView
    private let layoutManager: NSLayoutManager
    private var rows: [Row] = []
    private weak var observedClipView: NSClipView?

    /// The rows the layout draws, as of the last `reload()`.
    private(set) var lineCount = 0

    /// `CodeSpacing.gutterBase` plus the width of the digits the last number needs, as of the last
    /// `reload()`.
    private(set) var columnWidth: CGFloat = 0

    /// The gutter's whole width: its left margin, then the column. The column's right edge is the
    /// gutter's right edge. The numbers end `CodeSpacing.gutterPadding` inside that edge, and the
    /// band between their right end and the edge, which lies within this width, holds only the
    /// ground (CP-368, CP-369).
    var width: CGFloat { CodeSpacing.inset + columnWidth }

    /// Where every number ends: the right-hand padding inside the gutter's right edge. One value,
    /// shared by every label whatever its own digit count (CP-368).
    private var numberRightEnd: CGFloat { width - CodeSpacing.gutterPadding }

    /// What is filled across the gutter's bounds before the numbers.
    var ground: NSColor { CodeColors.surface }

    /// The numbers of the rows that intersect the gutter's visible region, with the point and the
    /// attributes each is drawn with. `draw(_:)` draws exactly these.
    var labels: [Label] {
        let clipView = textView.enclosingScrollView?.contentView
        let scrollOffset = clipView?.bounds.minY ?? 0
        let visibleHeight = min(bounds.height, clipView?.bounds.height ?? bounds.height)
        let containerTop = textView.textContainerOrigin.y
        let rightEnd = numberRightEnd
        let attributes: [NSAttributedString.Key: Any] = [
            .font: CodeType.font, .foregroundColor: CodeColors.gutter,
        ]
        return rows.enumerated().compactMap { index, row in
            let top = containerTop + row.top - scrollOffset
            let bottom = containerTop + row.bottom - scrollOffset
            guard bottom > 0, top < visibleHeight else { return nil }
            return Label(
                text: String(index + 1),
                point: NSPoint(x: rightEnd, y: containerTop + row.baseline - scrollOffset),
                attributes: attributes)
        }
    }

    init(textView: NSTextView) {
        guard let layoutManager = unsafe textView.layoutManager else {
            preconditionFailure("CodeGutterView numbers the rows of a TextKit 1 text view")
        }
        self.textView = textView
        self.layoutManager = layoutManager
        super.init(frame: .zero)
        reload()
        observeClipView()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        preconditionFailure("CodeGutterView is built in code only")
    }

    /// The text view's y grows downward, so the gutter's does.
    override var isFlipped: Bool { true }

    /// Re-reads the layout after the text changed: the rows, the count, the column and the width.
    func reload() {
        if let container = unsafe textView.textContainer {
            layoutManager.ensureLayout(for: container)
        }
        let text = textView.string as NSString
        var rows: [Row] = []
        unsafe layoutManager.enumerateLineFragments(
            forGlyphRange: NSRange(location: 0, length: layoutManager.numberOfGlyphs)
        ) { rect, _, _, glyphRange, _ in
            let characters = unsafe self.layoutManager.characterRange(
                forGlyphRange: glyphRange, actualGlyphRange: nil)
            // A row holding only its break has no glyph to measure: the layout puts the break's
            // own location at the fragment's bottom, 3 points below where a row of text has its
            // baseline (probe, 13-point code font, 20.15 pitch). Its baseline is the one a row
            // of the same height has, the code font's descent above the fragment's bottom.
            let hasGlyphOfItsOwn =
                text.substring(with: characters)
                .rangeOfCharacter(from: Self.lineBreaks.inverted) != nil
            let baseline =
                hasGlyphOfItsOwn
                ? rect.minY + self.layoutManager.location(forGlyphAt: glyphRange.location).y
                : rect.maxY - Self.descent
            rows.append(Row(top: rect.minY, bottom: rect.maxY, baseline: baseline))
        }
        self.rows = rows
        lineCount = rows.count
        let digits = max(String(rows.count).count, 1)
        columnWidth = CodeSpacing.gutterBase + Self.width(ofDigits: digits)
        needsDisplay = true
    }

    private static let lineBreaks = CharacterSet.newlines

    /// How far the layout puts a row's baseline above the row's bottom: the code font's descent,
    /// to a whole point as the typesetter rounds it (`baselineOffset` 3.0 for a 2.74 descent).
    private static let descent = (-CodeType.font.descender).rounded(.up)

    /// The width of `count` digits in the code font, measured from the font.
    private static func width(ofDigits count: Int) -> CGFloat {
        (String(repeating: "0", count: count) as NSString)
            .size(withAttributes: [.font: CodeType.font]).width
    }

    override func draw(_ dirtyRect: NSRect) {
        ground.setFill()
        bounds.fill()
        for label in labels {
            let text = label.text as NSString
            let size = text.size(withAttributes: label.attributes)
            // `draw(at:)` takes the top of the text's box, and the baseline lies one ascender below.
            text.draw(
                at: NSPoint(
                    x: label.point.x - size.width, y: label.point.y - CodeType.font.ascender),
                withAttributes: label.attributes)
        }
    }

    override func viewDidMoveToSuperview() {
        super.viewDidMoveToSuperview()
        observeClipView()
    }

    /// Redraws on a vertical scroll, which moves every number's place.
    private func observeClipView() {
        let clipView = textView.enclosingScrollView?.contentView
        guard clipView !== observedClipView else { return }
        if let observedClipView {
            NotificationCenter.default.removeObserver(
                self, name: NSView.boundsDidChangeNotification, object: observedClipView)
        }
        if let clipView {
            clipView.postsBoundsChangedNotifications = true
            NotificationCenter.default.addObserver(
                self, selector: #selector(clipViewBoundsDidChange),
                name: NSView.boundsDidChangeNotification, object: clipView)
        }
        observedClipView = clipView
    }

    @objc private func clipViewBoundsDidChange(_ notification: Notification) {
        needsDisplay = true
    }
}
