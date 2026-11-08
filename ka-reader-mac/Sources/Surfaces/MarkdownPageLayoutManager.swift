import AppKit

/// The layout manager of the Markdown page's text view. It shapes the fill of an inline code run
/// alone (CP-1147): one rounded rectangle per line fragment the run occupies, grown by the code
/// cell's padding so the room lies between the code's glyphs and the fill's edge, and never inset
/// into them. Every other fill, a selection's included, is the default.
///
/// An inline code run is marked by `codeRun` and carries the canvas as its background-colour
/// attribute. The layout manager routes that attribute and the selection highlight through the same
/// primitive, so a fill is the code run's own only when the range carries the mark and the colour
/// handed over is the range's own background colour. A selection over a code run arrives over the
/// same characters with the selection colour, and takes the default path.
///
/// `NSLayoutManager` is not main-actor-isolated in the SDK, so this class is `nonisolated`.
nonisolated final class MarkdownPageLayoutManager: NSLayoutManager {
    /// The attribute that marks an inline code run, set on the run alone.
    static let codeRun = NSAttributedString.Key("KAReaderInlineCodeRun")

    override func fillBackgroundRectArray(
        _ rectArray: UnsafePointer<NSRect>, count rectCount: Int,
        forCharacterRange charRange: NSRange, color: NSColor
    ) {
        guard isCodeFill(color, over: charRange) else {
            unsafe super.fillBackgroundRectArray(
                rectArray, count: rectCount, forCharacterRange: charRange, color: color)
            return
        }
        // The colour is dynamic, and it resolves in the appearance the view is drawing under.
        color.setFill()
        for index in 0..<rectCount {
            let lineRect = unsafe rectArray[index]
            NSBezierPath(
                roundedRect: lineRect.insetBy(dx: -CodeCell.padding, dy: 0),
                xRadius: CodeCell.cornerRadius, yRadius: CodeCell.cornerRadius
            ).fill()
        }
    }

    /// Whether `color` is the background of an inline code run that starts `range`.
    private func isCodeFill(_ color: NSColor, over range: NSRange) -> Bool {
        guard let storage = unsafe textStorage, range.location < storage.length else {
            return false
        }
        let mark = unsafe storage.attribute(Self.codeRun, at: range.location, effectiveRange: nil)
        let background =
            unsafe storage.attribute(.backgroundColor, at: range.location, effectiveRange: nil)
            as? NSColor
        guard mark != nil, let background else { return false }
        return background.usingColorSpace(.sRGB) == color.usingColorSpace(.sRGB)
    }
}
