import AppKit

/// The path line's row (`docs/DESIGN.md` § Components, the `path-line` component): the strip along
/// the reading panel's top that holds the path label. It draws `{colors.surface}` across the whole of
/// itself. The colour is resolved when it is drawn, so an appearance change recolours the row without
/// the file being selected again (CP-359).
///
/// The row is drawing only: a plain view, no control, no dragged type, and no first responder
/// (CP-367).
final class PathLineRowView: NSView {
    /// What is filled across the row's bounds: the one `surface` value the code view draws too.
    var ground: NSColor { CodeColors.surface }

    override func draw(_ dirtyRect: NSRect) {
        ground.setFill()
        bounds.fill()
    }
}

/// The hairline directly beneath the path line's row: a plain view that fills its bounds with
/// `{colors.line}` when it is drawn (CP-363). Like the row it is drawing only (CP-367).
final class PathLineHairlineView: NSView {
    /// What is filled across the hairline's bounds.
    var color: NSColor { CodeColors.line }

    override func draw(_ dirtyRect: NSRect) {
        color.setFill()
        bounds.fill()
    }
}
