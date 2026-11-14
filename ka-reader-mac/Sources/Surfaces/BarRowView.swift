import AppKit

/// A row that can draw a bar: 2px of `{colors.primary}` down its left edge (`docs/DESIGN.md`
/// § Elevation & Depth, "Selection is a fill and a bar"). A selected row draws `{colors.selection}`
/// itself, under the bar, from one state (`drawsSelection`): the Git view's selected row does, and so
/// does the tree's open-file row. The table's own selection drawing is not used.
package final class BarRowView: NSTableRowView {
    private static let barWidth: CGFloat = 2

    /// `{colors.primary}`: `#1E1F22` in the light theme, `#E7E7E4` in the dark one (`docs/DESIGN.md`
    /// § Colors, "The two themes").
    private static let barColor = NSColor(name: nil) { appearance in
        appearance.bestMatch(from: [.darkAqua, .aqua]) == .darkAqua
            ? NSColor(srgbRed: 0xE7 / 255, green: 0xE7 / 255, blue: 0xE4 / 255, alpha: 1)
            : NSColor(srgbRed: 0x1E / 255, green: 0x1F / 255, blue: 0x22 / 255, alpha: 1)
    }

    /// `{colors.hover}`: `#EBEBE8` in the light theme, `#2C2D31` in the dark one (`docs/DESIGN.md:L420`).
    private static let hoverColor = NSColor(name: nil) { appearance in
        appearance.bestMatch(from: [.darkAqua, .aqua]) == .darkAqua
            ? NSColor(srgbRed: 0x2C / 255, green: 0x2D / 255, blue: 0x31 / 255, alpha: 1)
            : NSColor(srgbRed: 0xEB / 255, green: 0xEB / 255, blue: 0xE8 / 255, alpha: 1)
    }

    /// `{colors.selection}`: `#E2E3DF` in the light theme, `#34363B` in the dark one
    /// (`docs/DESIGN.md:L420`).
    private static let selectionColor = NSColor(name: nil) { appearance in
        appearance.bestMatch(from: [.darkAqua, .aqua]) == .darkAqua
            ? NSColor(srgbRed: 0x34 / 255, green: 0x36 / 255, blue: 0x3B / 255, alpha: 1)
            : NSColor(srgbRed: 0xE2 / 255, green: 0xE3 / 255, blue: 0xDF / 255, alpha: 1)
    }

    /// The bar was asked for on its own, as the rail's active entry does.
    private var barRequested = false

    /// The row draws the bar: asked for on its own, or because the row is drawn as selected.
    package var drawsBar: Bool {
        get { barRequested || drawsSelection }
        set {
            barRequested = newValue
            needsDisplay = true
        }
    }

    /// The selected drawing: the selection fill edge to edge with the bar over it. It is one
    /// state, so no row shows one without the other, and the hover fill never shows over it.
    package var drawsSelection = false {
        didSet { needsDisplay = true }
    }

    /// The pointer is over this row. Set and cleared by the surface's `RowHover`.
    var pointerIsOver = false {
        didSet { needsDisplay = true }
    }

    /// The table's selection outranks the hover fill on this row: while `isSelected`, no hover shows.
    /// On by default. The tree turns it off for a folder row and a status line, which a click can
    /// select without drawing them as selected, so a clicked folder row still takes hover.
    var selectionOutranksHover = true

    /// The fill shows: the pointer is over the row, the row draws no bar, and it is not selected
    /// where selection outranks hover. Read when the row is drawn, so a selection or a bar that
    /// arrives under a still pointer redraws correctly with no pointer event.
    package var showsHover: Bool {
        pointerIsOver && !drawsBar && !(isSelected && selectionOutranksHover)
    }

    /// Always the style an unselected row has. A cell's controls read this to choose their ink, and
    /// the platform answers a selected, emphasized row with a different one, so selection or key
    /// status would re-ink the row (CP-632). `NSTableRowView.h` names it as the property to override
    /// beside custom selection drawing.
    override package var interiorBackgroundStyle: NSView.BackgroundStyle { .normal }

    /// Draws the selection fill, or else the hover fill, and the bar over either, from the row's
    /// state alone.
    override package func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        if drawsSelection {
            Self.selectionColor.setFill()
            bounds.fill()
        } else if showsHover {
            Self.hoverColor.setFill()
            bounds.fill()
        }
        guard drawsBar else { return }
        Self.barColor.setFill()
        NSRect(x: bounds.minX, y: bounds.minY, width: Self.barWidth, height: bounds.height).fill()
    }
}
