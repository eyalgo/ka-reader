import AppKit

/// The box's measures, in points, as `docs/DESIGN.md` `{components.image-placeholder}` gives them:
/// `{spacing.md}` of padding, `{rounded.sm}` corners and a hairline border.
nonisolated private enum PlaceholderBox {
    static let padding: CGFloat = 12
    static let cornerRadius: CGFloat = 3
    static let hairline: CGFloat = 1
}

/// The surface a placeholder box's paragraphs sit in on the Markdown page (CP-1156 – CP-1159): the
/// canvas background, a one-point line border on every edge and `{spacing.md}` of padding, with
/// `{rounded.sm}` corners.
///
/// A text block has no radius property, and its own `drawBackground` draws the border beside the
/// fill, square. So this block draws both itself, from one rounded outline, and never calls
/// `super`. The fill and the stroke take the block's own `backgroundColor` and border colour, which
/// the page's tests read, so the value read and the value drawn are one value.
///
/// `NSTextBlock` is not main-actor-isolated in the SDK, so this class is `nonisolated`: the page
/// hands it the two colours it builds it with, and it draws on the main actor.
nonisolated final class PlaceholderBoxBlock: NSTextBlock {
    init(canvas: NSColor, line: NSColor) {
        super.init()
        backgroundColor = canvas
        setBorderColor(line)
        setWidth(PlaceholderBox.hairline, type: .absoluteValueType, for: .border)
        setWidth(PlaceholderBox.padding, type: .absoluteValueType, for: .padding)
        setWidth(0, type: .absoluteValueType, for: .margin)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        preconditionFailure("PlaceholderBoxBlock is built in code only")
    }

    override func drawBackground(
        withFrame frameRect: NSRect, in controlView: NSView?, characterRange charRange: NSRange,
        layoutManager layoutMgr: NSLayoutManager
    ) {
        guard let canvas = backgroundColor, let line = borderColor(for: .minX) else { return }
        // The colours are dynamic, so they are resolved in the appearance the view draws under, at
        // the moment of drawing, as the page's other dynamic colours are. The outline is inset by
        // half the hairline, so the stroke lies inside the frame.
        MainActor.assumeIsolated {
            let appearance = controlView?.effectiveAppearance ?? NSAppearance.currentDrawing()
            appearance.performAsCurrentDrawingAppearance {
                let outline = NSBezierPath(
                    roundedRect: frameRect.insetBy(
                        dx: PlaceholderBox.hairline / 2, dy: PlaceholderBox.hairline / 2),
                    xRadius: PlaceholderBox.cornerRadius, yRadius: PlaceholderBox.cornerRadius)
                canvas.setFill()
                outline.fill()
                line.setStroke()
                outline.lineWidth = PlaceholderBox.hairline
                outline.stroke()
            }
        }
    }
}
