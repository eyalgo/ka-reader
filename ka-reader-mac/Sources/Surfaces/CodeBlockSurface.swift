import AppKit

/// The surface a code block's paragraphs sit in on the Markdown page (CP-1146): the canvas
/// background, `{spacing.xs}` of padding on every edge and no border, with `{rounded.sm}` corners.
///
/// A text block has no radius property, so the block fills its own background, as a rounded
/// rectangle, and does not hand it to `NSTextBlock`, whose fill would show square beneath. The
/// background colour stays set on the block, where the page's tests read it. The list or quote
/// indent the code stands at is the block's left margin: a paragraph indent inside a block moves
/// the text and leaves the surface at the container's edge.
///
/// `NSTextBlock` is not main-actor-isolated in the SDK, so this class is `nonisolated`: the page
/// hands it the canvas colour it builds it with, and it draws on the main actor.
nonisolated final class CodeBlockSurface: NSTextBlock {
    init(canvas: NSColor, leftMargin: CGFloat) {
        super.init()
        backgroundColor = canvas
        setWidth(CodeCell.padding, type: .absoluteValueType, for: .padding)
        setWidth(0, type: .absoluteValueType, for: .border)
        setWidth(leftMargin, type: .absoluteValueType, for: .margin, edge: .minX)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        preconditionFailure("CodeBlockSurface is built in code only")
    }

    override func drawBackground(
        withFrame frameRect: NSRect, in controlView: NSView?, characterRange charRange: NSRange,
        layoutManager layoutMgr: NSLayoutManager
    ) {
        guard let canvas = backgroundColor else { return }
        // The colour is dynamic, so it is resolved in the appearance the view draws under, at the
        // moment of drawing, as the page's other dynamic colours are.
        MainActor.assumeIsolated {
            let appearance = controlView?.effectiveAppearance ?? NSAppearance.currentDrawing()
            appearance.performAsCurrentDrawingAppearance {
                canvas.setFill()
                NSBezierPath(
                    roundedRect: frameRect, xRadius: CodeCell.cornerRadius,
                    yRadius: CodeCell.cornerRadius
                ).fill()
            }
        }
    }
}
