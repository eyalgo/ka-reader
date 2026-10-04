import AppKit

/// A row that can draw the open file's bar: 2px of `{colors.primary}` down its left edge
/// (`docs/DESIGN.md` § Elevation & Depth, "Selection is a fill and a bar"). The selection fill is
/// the table's own. The tree and the Git view draw one bar through this view.
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

    var drawsBar = false {
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
        if showsHover {
            Self.hoverColor.setFill()
            bounds.fill()
        }
        guard drawsBar else { return }
        Self.barColor.setFill()
        NSRect(x: bounds.minX, y: bounds.minY, width: Self.barWidth, height: bounds.height).fill()
    }
}
