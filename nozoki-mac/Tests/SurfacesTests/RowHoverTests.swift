import AppKit
import XCTest

@testable import Surfaces

/// The hover fill of a clickable row (CP-599 to CP-606). The colours are literals of
/// `docs/DESIGN.md:L420`, never read from the code, as `LetterTooltipTests` does.
@MainActor
final class RowHoverTests: XCTestCase {
    private let rowSize = NSSize(width: 120, height: 24)

    private func makeRow() -> BarRowView {
        BarRowView(frame: NSRect(origin: .zero, size: rowSize))
    }

    private func render(_ row: BarRowView, as appearance: NSAppearance.Name = .aqua) throws
        -> NSBitmapImageRep
    {
        row.appearance = NSAppearance(named: appearance)
        let rep = try XCTUnwrap(row.bitmapImageRepForCachingDisplay(in: row.bounds))
        row.cacheDisplay(in: row.bounds, to: rep)
        return rep
    }

    private func assertColour(
        _ rep: NSBitmapImageRep, atX x: Int, y: Int, equals hex: UInt32, _ context: String,
        file: StaticString = #filePath, line: UInt = #line
    ) throws {
        let colour = try XCTUnwrap(rep.colorAt(x: x, y: y)?.usingColorSpace(.sRGB))
        let expected = [
            CGFloat((hex >> 16) & 0xFF), CGFloat((hex >> 8) & 0xFF), CGFloat(hex & 0xFF),
        ].map { $0 / 255 }
        let actual = [colour.redComponent, colour.greenComponent, colour.blueComponent]
        for (a, e) in zip(actual, expected) {
            XCTAssertEqual(a, e, accuracy: 1.5 / 255, context, file: file, line: line)
        }
    }

    private func pixels(_ rep: NSBitmapImageRep) throws -> Data {
        try XCTUnwrap(rep.representation(using: .png, properties: [:]))
    }

    // MARK: the row view

    func test_hover_flag_alone_shows_fill_on_a_plain_row() {
        let row = makeRow()
        row.pointerIsOver = true
        XCTAssertTrue(row.showsHover)
    }

    func test_hover_not_shown_while_row_is_selected() {
        let row = makeRow()
        row.pointerIsOver = true
        row.isSelected = true
        XCTAssertFalse(row.showsHover)
    }

    func test_hover_not_shown_while_row_draws_bar() {
        let row = makeRow()
        row.pointerIsOver = true
        row.drawsBar = true
        XCTAssertFalse(row.showsHover)
    }

    func test_hover_not_shown_without_flag() {
        XCTAssertFalse(makeRow().showsHover)
    }

    func test_hover_fill_renders_light_and_dark_values() throws {
        let row = makeRow()
        row.pointerIsOver = true
        for (appearance, hex) in [(NSAppearance.Name.aqua, UInt32(0xEBEBE8)), (.darkAqua, 0x2C2D31)] {
            let rep = try render(row, as: appearance)
            let last = (rep.pixelsWide - 1, rep.pixelsHigh - 1)
            let name = appearance.rawValue
            try assertColour(rep, atX: 0, y: 0, equals: hex, "top-left, \(name)")
            try assertColour(rep, atX: last.0, y: 0, equals: hex, "top-right, \(name)")
            try assertColour(rep, atX: 0, y: last.1, equals: hex, "bottom-left, \(name)")
            try assertColour(rep, atX: last.0, y: last.1, equals: hex, "bottom-right, \(name)")
            try assertColour(
                rep, atX: rep.pixelsWide / 2, y: rep.pixelsHigh / 2, equals: hex, "centre, \(name)")
        }
    }

    func test_hover_flag_leaves_selected_or_barred_drawing_unchanged() throws {
        for appearance in [NSAppearance.Name.aqua, .darkAqua] {
            let selectedOff = makeRow()
            selectedOff.isSelected = true
            let selectedOn = makeRow()
            selectedOn.isSelected = true
            selectedOn.pointerIsOver = true
            XCTAssertEqual(
                try pixels(render(selectedOn, as: appearance)),
                try pixels(render(selectedOff, as: appearance)),
                "selected row, \(appearance.rawValue)")

            let barredOff = makeRow()
            barredOff.drawsBar = true
            let barredOn = makeRow()
            barredOn.drawsBar = true
            barredOn.pointerIsOver = true
            XCTAssertEqual(
                try pixels(render(barredOn, as: appearance)),
                try pixels(render(barredOff, as: appearance)),
                "barred row, \(appearance.rawValue)")
        }
    }

    func test_hover_fill_goes_when_row_gains_bar_under_the_flag() throws {
        for appearance in [NSAppearance.Name.aqua, .darkAqua] {
            let flagged = makeRow()
            flagged.pointerIsOver = true
            _ = try render(flagged, as: appearance)
            flagged.drawsBar = true
            let unflagged = makeRow()
            unflagged.drawsBar = true
            XCTAssertEqual(
                try pixels(render(flagged, as: appearance)),
                try pixels(render(unflagged, as: appearance)), appearance.rawValue)
        }
    }
}
