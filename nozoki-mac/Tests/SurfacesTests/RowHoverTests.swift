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
        for (appearance, hex) in [
            (NSAppearance.Name.aqua, UInt32(0xEBEBE8)), (.darkAqua, 0x2C2D31),
        ] {
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

    // MARK: the selected drawing (the Git view's selected row)

    func test_selected_drawing_renders_the_selection_fill_and_the_bar_light_and_dark() throws {
        let row = makeRow()
        row.drawsSelection = true
        for (appearance, fill, bar) in [
            (NSAppearance.Name.aqua, UInt32(0xE2E3DF), UInt32(0x1E1F22)),
            (.darkAqua, 0x34363B, 0xE7E7E4),
        ] {
            let rep = try render(row, as: appearance)
            let name = appearance.rawValue
            let last = (rep.pixelsWide - 1, rep.pixelsHigh - 1)
            try assertColour(
                rep, atX: rep.pixelsWide / 2, y: rep.pixelsHigh / 2, equals: fill, "centre, \(name)"
            )
            try assertColour(rep, atX: last.0, y: 0, equals: fill, "top-right, \(name)")
            try assertColour(rep, atX: last.0, y: last.1, equals: fill, "bottom-right, \(name)")
            try assertColour(rep, atX: 0, y: rep.pixelsHigh / 2, equals: bar, "left edge, \(name)")
        }
    }

    func test_selected_drawing_shows_no_hover_even_while_the_pointer_is_over_the_row() {
        let row = makeRow()
        row.drawsSelection = true
        row.pointerIsOver = true
        XCTAssertFalse(row.showsHover)
    }

    func test_selected_drawing_is_the_same_with_and_without_the_pointer_over_the_row() throws {
        for appearance in [NSAppearance.Name.aqua, .darkAqua] {
            let away = makeRow()
            away.drawsSelection = true
            let over = makeRow()
            over.drawsSelection = true
            over.pointerIsOver = true
            XCTAssertEqual(
                try pixels(render(over, as: appearance)), try pixels(render(away, as: appearance)),
                appearance.rawValue)
        }
    }

    func test_a_row_with_only_the_bar_shows_no_selection_fill() throws {
        for appearance in [NSAppearance.Name.aqua, .darkAqua] {
            let row = makeRow()
            row.drawsBar = true
            XCTAssertFalse(row.drawsSelection)
            let rep = try render(row, as: appearance)
            let centre = try XCTUnwrap(rep.colorAt(x: rep.pixelsWide / 2, y: rep.pixelsHigh / 2))
            XCTAssertEqual(centre.alphaComponent, 0, accuracy: 0.001, appearance.rawValue)
        }
    }

    func test_the_selected_state_is_the_fill_and_the_bar_together_and_ends_with_both() {
        let row = makeRow()
        XCTAssertFalse(row.drawsBar)
        row.drawsSelection = true
        XCTAssertTrue(row.drawsBar, "the bar comes with the fill")
        row.drawsBar = false
        XCTAssertTrue(row.drawsBar, "nothing takes the bar off a selected row but ending the state")
        row.drawsSelection = false
        XCTAssertFalse(row.drawsBar, "the bar leaves with the fill")
        XCTAssertFalse(row.drawsSelection)
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

/// The hover unit (CP-602 to CP-605): a plain host with two `BarRowView`s and a lookup over them.
@MainActor
final class RowHoverUnitTests: XCTestCase {
    private var window: NSWindow!
    private var host: NSView!
    private var upper: BarRowView!
    private var lower: BarRowView!
    private var hover: RowHover!
    /// What the lookup consults; a test empties or reorders it to move rows from under the pointer.
    private var lookupRows: [BarRowView] = []

    private let upperPoint = NSPoint(x: 50, y: 60)
    private let lowerPoint = NSPoint(x: 50, y: 20)
    private let nowhere = NSPoint(x: 50, y: 90)

    override func setUp() {
        super.setUp()
        window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 200, height: 100), styleMask: [.titled],
            backing: .buffered, defer: false)
        host = NSView(frame: NSRect(x: 0, y: 0, width: 200, height: 100))
        window.contentView?.addSubview(host)
        upper = BarRowView(frame: NSRect(x: 0, y: 40, width: 200, height: 40))
        lower = BarRowView(frame: NSRect(x: 0, y: 0, width: 200, height: 40))
        host.addSubview(upper)
        host.addSubview(lower)
        lookupRows = [upper, lower]
        hover = RowHover(host: host) { [unowned self] point in
            lookupRows.first { $0.frame.contains(point) }
        }
    }

    private func flagged() -> [BarRowView] {
        [upper, lower].filter(\.pointerIsOver)
    }

    func test_hover_moving_onto_a_row_flags_it() throws {
        try PointerDelivery.move(to: upperPoint, in: host)
        XCTAssertTrue(flagged().elementsEqual([upper]))
    }

    func test_hover_moving_to_the_other_row_moves_the_flag() throws {
        try PointerDelivery.move(to: upperPoint, in: host)
        try PointerDelivery.move(to: lowerPoint, in: host)
        XCTAssertTrue(flagged().elementsEqual([lower]))
    }

    func test_hover_moving_onto_nothing_clears_the_flag() throws {
        try PointerDelivery.move(to: upperPoint, in: host)
        try PointerDelivery.move(to: nowhere, in: host)
        XCTAssertTrue(flagged().isEmpty)
    }

    func test_hover_exit_clears_the_flag_in_the_same_turn() throws {
        try PointerDelivery.move(to: upperPoint, in: host)
        try PointerDelivery.leave(at: upperPoint, in: host)
        XCTAssertTrue(flagged().isEmpty)
    }

    func test_hover_entering_again_after_exit_flags_the_row() throws {
        try PointerDelivery.enter(at: upperPoint, in: host)
        try PointerDelivery.leave(at: upperPoint, in: host)
        try PointerDelivery.enter(at: upperPoint, in: host)
        XCTAssertTrue(flagged().elementsEqual([upper]))
    }

    func test_hover_refresh_after_rows_trade_places_flags_the_row_now_there() throws {
        try PointerDelivery.move(to: upperPoint, in: host)
        let upperFrame = upper.frame
        upper.frame = lower.frame
        lower.frame = upperFrame
        hover.refresh()
        XCTAssertTrue(flagged().elementsEqual([lower]))
    }

    func test_hover_refresh_never_depends_on_the_row_flagged_before() throws {
        try PointerDelivery.move(to: upperPoint, in: host)
        lookupRows = [lower]
        hover.refresh()
        XCTAssertTrue(flagged().isEmpty)
    }

    func test_hover_refresh_before_any_pointer_event_flags_nothing() {
        hover.refresh()
        XCTAssertTrue(flagged().isEmpty)
    }

    func test_hover_forget_clears_and_later_refresh_flags_nothing() throws {
        try PointerDelivery.move(to: upperPoint, in: host)
        hover.forget()
        XCTAssertTrue(flagged().isEmpty)
        hover.refresh()
        XCTAssertTrue(flagged().isEmpty)
    }

    func test_hover_area_options_equal_the_tooltip_areas_options() throws {
        let rest = TooltipRestDouble()
        let tooltip = LetterTooltip(host: host, rest: rest.rest) { _ in nil }
        let hoverArea = try XCTUnwrap(PointerDelivery.hoverTrackingArea(of: host))
        let tooltipArea = try XCTUnwrap(PointerDelivery.trackingArea(of: host))
        XCTAssertEqual(hoverArea.options, tooltipArea.options)
        XCTAssertTrue(hoverArea.options.contains(.activeInKeyWindow))
        XCTAssertTrue(tooltipArea.options.contains(.activeInKeyWindow))
        withExtendedLifetime(tooltip) {}
    }
}
