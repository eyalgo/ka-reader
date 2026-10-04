import AppKit

/// A row that can draw a bar: 2px of `{colors.primary}` down its left edge (`docs/DESIGN.md`
/// § Elevation & Depth, "Selection is a fill and a bar"). The tree's selection fill is the table's
/// own, and its open file's row draws the bar alone. The Git view's selected row stands in no
/// table, so it draws `{colors.selection}` itself, under the bar, from one state (`drawsSelection`).
final class BarRowView: NSTableRowView {
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

    /// The bar was asked for on its own, as the tree's open-file row does.
    private var barRequested = false

    /// The row draws the bar: asked for on its own, or because the row is drawn as selected.
    var drawsBar: Bool {
        get { barRequested || drawsSelection }
        set {
            barRequested = newValue
            needsDisplay = true
        }
    }

    /// The selected drawing: the selection fill edge to edge with the bar over it. It is one
    /// state, so no row shows one without the other, and the hover fill never shows over it.
    var drawsSelection = false {
        didSet { needsDisplay = true }
    }

    /// The pointer is over this row. Set and cleared by the surface's `RowHover`.
    var pointerIsOver = false {
        didSet { needsDisplay = true }
    }

    /// The fill shows: the pointer is over the row, and the row is neither drawn as selected nor
    /// draws the bar. Read when the row is drawn, so a selection or a bar that arrives under a
    /// still pointer redraws correctly with no pointer event.
    var showsHover: Bool { pointerIsOver && !isSelected && !drawsBar }

    override func draw(_ dirtyRect: NSRect) {
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
