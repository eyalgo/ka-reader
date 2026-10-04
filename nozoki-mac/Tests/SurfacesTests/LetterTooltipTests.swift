import AppKit
import XCTest

@testable import Surfaces

/// The tooltip a status letter raises (CP-586 to CP-590, CP-595, CP-596), on a host with two letter
/// views, a lookup over them and a `TooltipRest` double. The colours and sizes are literals here,
/// the values of `docs/DESIGN.md` § Components "The tooltip", and never read from the code.
@MainActor
final class LetterTooltipTests: XCTestCase {
    private var window: NSWindow!
    private var host: NSView!
    private var first: NSView!
    private var second: NSView!
    private var below: PressCounter!
    private var rest: TooltipRestDouble!
    private var tooltip: LetterTooltip!

    /// A view under the letters that counts the presses that reach it.
    private final class PressCounter: NSView {
        var presses = 0
        override func mouseDown(with event: NSEvent) { presses += 1 }
    }

    override func setUp() {
        super.setUp()
        window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 400, height: 300), styleMask: [.titled],
            backing: .buffered, defer: false)
        host = NSView(frame: NSRect(x: 0, y: 0, width: 400, height: 300))
        window.contentView?.addSubview(host)
        below = PressCounter(frame: host.bounds)
        host.addSubview(below)
        first = NSView(frame: NSRect(x: 200, y: 200, width: 12, height: 16))
        second = NSView(frame: NSRect(x: 300, y: 200, width: 12, height: 16))
        host.addSubview(first)
        host.addSubview(second)
        rest = TooltipRestDouble()
        tooltip = LetterTooltip(host: host, rest: rest.rest) { [unowned self] point in
            if first.frame.contains(point) {
                return LetterUnderPointer(letter: first, text: "a.txt \u{2014} modified")
            }
            if second.frame.contains(point) {
                return LetterUnderPointer(letter: second, text: "b.txt \u{2014} added")
            }
            return nil
        }
    }

    override func tearDown() {
        window = nil
        host = nil
        tooltip = nil
        super.tearDown()
    }

    private var onFirst: NSPoint { NSPoint(x: first.frame.midX, y: first.frame.midY) }
    private var onSecond: NSPoint { NSPoint(x: second.frame.midX, y: second.frame.midY) }
    private let onNothing = NSPoint(x: 300, y: 20)

    private func restAndShow(on point: NSPoint) throws {
        try PointerDelivery.move(to: point, in: host)
        rest.fireLast()
    }

    private func tooltipViews() -> [NSView] {
        var found: [NSView] = []
        func walk(_ view: NSView) {
            for sub in view.subviews where !sub.isHidden {
                if sub is LetterTooltipView { found.append(sub) }
                walk(sub)
            }
        }
        walk(host)
        return found
    }

    private func srgb(_ color: NSColor, under appearance: NSAppearance) throws -> [CGFloat] {
        var components: [CGFloat] = []
        appearance.performAsCurrentDrawingAppearance {
            if let resolved = color.usingColorSpace(.sRGB) {
                components = [resolved.redComponent, resolved.greenComponent, resolved.blueComponent]
            }
        }
        return try XCTUnwrap(components.isEmpty ? nil : components, "colour did not resolve")
    }

    private func hex(_ value: UInt32) -> [CGFloat] {
        [
            CGFloat((value >> 16) & 0xFF) / 255, CGFloat((value >> 8) & 0xFF) / 255,
            CGFloat(value & 0xFF) / 255,
        ]
    }

    private func assertColours(
        _ actual: [CGFloat], _ expected: [CGFloat], _ message: String,
        file: StaticString = #filePath, line: UInt = #line
    ) {
        XCTAssertEqual(actual.count, 3, message, file: file, line: line)
        for (a, e) in zip(actual, expected) {
            XCTAssertEqual(a, e, accuracy: 0.002, message, file: file, line: line)
        }
    }

    // MARK: When it shows

    func test_theTrackingAreaWatchesMovementEntryAndExitOverTheVisibleRect() throws {
        let area = try XCTUnwrap(PointerDelivery.trackingArea(of: host))
        XCTAssertTrue(area.options.contains(.mouseMoved))
        XCTAssertTrue(area.options.contains(.mouseEnteredAndExited))
        XCTAssertTrue(area.options.contains(.inVisibleRect))
    }

    func test_restingOnALetterAsksTheRestForHalfASecond() throws {
        try PointerDelivery.move(to: onFirst, in: host)

        XCTAssertEqual(rest.requests.map(\.interval), [0.5])
        XCTAssertEqual(LetterTooltip.restInterval, 0.5)
    }

    func test_nothingShowsUntilTheRestFires() throws {
        try PointerDelivery.move(to: onFirst, in: host)

        XCTAssertNil(tooltip.shownView)
        XCTAssertNil(tooltip.shownText)

        rest.fireLast()

        XCTAssertNotNil(tooltip.shownView)
        XCTAssertEqual(tooltip.shownText, "a.txt \u{2014} modified")
    }

    func test_enteringTheHostOnALetterStartsTheRestToo() throws {
        try PointerDelivery.enter(at: onFirst, in: host)

        XCTAssertEqual(rest.requests.count, 1)
    }

    func test_movingOverNoLetterAsksForNoRest() throws {
        try PointerDelivery.move(to: onNothing, in: host)

        XCTAssertTrue(rest.requests.isEmpty)
    }

    func test_leavingBeforeTheRestFiresMeansNothingEverShows() throws {
        try PointerDelivery.move(to: onFirst, in: host)
        try PointerDelivery.move(to: onNothing, in: host)

        XCTAssertTrue(rest.requests[0].cancelled)
        rest.fire(0)

        XCTAssertNil(tooltip.shownView)
        XCTAssertTrue(tooltipViews().isEmpty)
    }

    func test_movingWithinOneLetterNeitherRestartsTheRestNorMovesTheTooltip() throws {
        try PointerDelivery.move(to: onFirst, in: host)
        try PointerDelivery.move(to: NSPoint(x: first.frame.minX + 1, y: first.frame.minY + 1), in: host)

        XCTAssertEqual(rest.requests.count, 1, "no new rest")
        XCTAssertFalse(rest.requests[0].cancelled)

        rest.fireLast()
        let frame = try XCTUnwrap(tooltip.shownView).frame
        try PointerDelivery.move(to: NSPoint(x: first.frame.maxX - 1, y: first.frame.maxY - 1), in: host)

        XCTAssertEqual(rest.requests.count, 1)
        XCTAssertEqual(try XCTUnwrap(tooltip.shownView).frame, frame)
    }

    func test_aRestThatFiresAfterThePointerMovedOnToNoLetterShowsNothing() throws {
        // The lookup now answers nil for the current point although the rest was not cancelled.
        try PointerDelivery.move(to: onFirst, in: host)
        first.frame.origin.y = 10

        rest.fireLast()

        XCTAssertNil(tooltip.shownView)
    }

    // MARK: When it leaves

    func test_leavingAfterItShowsRemovesItAtOnce() throws {
        try restAndShow(on: onFirst)
        let view = try XCTUnwrap(tooltip.shownView)

        try PointerDelivery.move(to: onNothing, in: host)

        XCTAssertNil(tooltip.shownView)
        XCTAssertNil(view.superview)
        XCTAssertTrue(tooltipViews().isEmpty)
    }

    func test_movingStraightOntoTheSecondLetterRemovesTheFirstAndStartsAFreshRest() throws {
        try restAndShow(on: onFirst)
        let shownFirst = try XCTUnwrap(tooltip.shownView)

        try PointerDelivery.move(to: onSecond, in: host)

        XCTAssertNil(tooltip.shownView)
        XCTAssertNil(shownFirst.superview)
        XCTAssertEqual(rest.requests.count, 2)
        XCTAssertEqual(rest.requests[1].interval, 0.5)

        // A rest keyed to the first letter's identity shows nothing now.
        rest.fire(0)
        XCTAssertNil(tooltip.shownView)

        rest.fire(1)
        XCTAssertEqual(tooltip.shownText, "b.txt \u{2014} added")
    }

    func test_leavingTheHostRemovesItAndCancelsAPendingRest() throws {
        try restAndShow(on: onFirst)
        try PointerDelivery.leave(at: onNothing, in: host)
        XCTAssertNil(tooltip.shownView)

        try PointerDelivery.move(to: onSecond, in: host)
        try PointerDelivery.leave(at: onNothing, in: host)

        XCTAssertTrue(rest.requests[1].cancelled)
        rest.fire(1)
        XCTAssertNil(tooltip.shownView)
    }

    func test_dismissRemovesItAndCancelsAPendingRest() throws {
        try restAndShow(on: onFirst)

        tooltip.dismiss()

        XCTAssertNil(tooltip.shownView)
        XCTAssertTrue(tooltipViews().isEmpty)

        try PointerDelivery.move(to: onSecond, in: host)
        tooltip.dismiss()

        XCTAssertTrue(rest.requests[1].cancelled)
        rest.fire(1)
        XCTAssertNil(tooltip.shownView)
    }

    func test_dismissWithNothingPendingOrShowingIsHarmless() {
        tooltip.dismiss()
        tooltip.dismiss()

        XCTAssertNil(tooltip.shownView)
        XCTAssertTrue(rest.requests.isEmpty)
    }

    // MARK: Where it sits

    func test_itSitsBelowTheLetterWithItsRightEdgeOnTheLettersRightEdge() throws {
        try restAndShow(on: onFirst)
        let view = try XCTUnwrap(tooltip.shownView)

        XCTAssertEqual(view.frame.maxX, first.frame.maxX, accuracy: 0.001)
        XCTAssertLessThanOrEqual(view.frame.maxY, first.frame.minY + 0.001, "wholly below (host is not flipped)")
    }

    func test_itIsTheHostsLastSubview() throws {
        try restAndShow(on: onFirst)

        XCTAssertTrue(host.subviews.last === tooltip.shownView)
    }

    func test_itIsAViewInsideTheHostAndOpensNoSecondWindow() throws {
        try restAndShow(on: onFirst)

        XCTAssertTrue(tooltip.shownView?.superview === host)
        XCTAssertTrue(tooltip.shownView?.window === window)
        XCTAssertTrue(NSApp.windows.allSatisfy { $0 === window || !$0.isVisible })
    }

    // MARK: How it is drawn

    func test_itIsDrawnInBothThemes() throws {
        let themes: [(NSAppearance.Name, [UInt32])] = [
            (.aqua, [0xFBFBFA, 0x1E1F22, 0xD8D8D4]),
            (.darkAqua, [0x1B1C1E, 0xE7E7E4, 0x3B3C41]),
        ]
        for (name, values) in themes {
            host.appearance = NSAppearance(named: name)
            try restAndShow(on: onFirst)
            let view = try XCTUnwrap(tooltip.shownView as? LetterTooltipView)
            let appearance = try XCTUnwrap(NSAppearance(named: name))

            var ground: [CGFloat] = []
            var hairline: [CGFloat] = []
            appearance.performAsCurrentDrawingAppearance {
                ground = view.layer?.backgroundColor.flatMap { NSColor(cgColor: $0) }
                    .flatMap { $0.usingColorSpace(.sRGB) }
                    .map { [$0.redComponent, $0.greenComponent, $0.blueComponent] } ?? []
                hairline = view.layer?.borderColor.flatMap { NSColor(cgColor: $0) }
                    .flatMap { $0.usingColorSpace(.sRGB) }
                    .map { [$0.redComponent, $0.greenComponent, $0.blueComponent] } ?? []
            }
            assertColours(ground, hex(values[0]), "\(name.rawValue) ground")
            assertColours(try srgb(XCTUnwrap(view.label.textColor), under: appearance), hex(values[1]), "\(name.rawValue) ink")
            assertColours(hairline, hex(values[2]), "\(name.rawValue) hairline")
            XCTAssertEqual(view.layer?.borderWidth, 1)
            tooltip.dismiss()
        }
    }

    func test_itsPaddingRadiusFontAndShadow() throws {
        try restAndShow(on: onFirst)
        let view = try XCTUnwrap(tooltip.shownView as? LetterTooltipView)

        XCTAssertEqual(view.label.frame.minX, 4, accuracy: 0.001)
        XCTAssertEqual(view.label.frame.minY, 4, accuracy: 0.001)
        XCTAssertEqual(view.frame.width, view.label.frame.width + 8, accuracy: 0.001)
        XCTAssertEqual(view.frame.height, view.label.frame.height + 8, accuracy: 0.001)
        XCTAssertEqual(view.layer?.cornerRadius, 3)
        XCTAssertEqual(view.label.font, NSFont.systemFont(ofSize: 13, weight: .regular))
        XCTAssertNil(view.shadow)
        XCTAssertEqual(view.layer?.shadowOpacity, 0)
    }

    func test_itIsOneLineAndDoesNotWrap() throws {
        try restAndShow(on: onFirst)
        let view = try XCTUnwrap(tooltip.shownView as? LetterTooltipView)

        XCTAssertEqual(view.label.maximumNumberOfLines, 1)
        XCTAssertFalse(view.label.cell?.wraps ?? true)
        XCTAssertEqual(view.label.stringValue, "a.txt \u{2014} modified")
    }

    // MARK: What it is not

    func test_aHitTestAtItsCentreNeverReturnsIt() throws {
        try restAndShow(on: onFirst)
        let view = try XCTUnwrap(tooltip.shownView)
        let centre = NSPoint(x: view.frame.midX, y: view.frame.midY)

        let hit = try ClickDelivery.click(at: centre, in: host)

        XCTAssertFalse(hit === view || hit.isDescendant(of: view))
        XCTAssertTrue(hit === below, "the press reaches what lies beneath")
        XCTAssertEqual(below.presses, 1)
    }

    func test_notDrawnWhileNotShowing() throws {
        XCTAssertTrue(tooltipViews().isEmpty, "before any rest")

        try restAndShow(on: onFirst)
        XCTAssertEqual(tooltipViews().count, 1)

        try PointerDelivery.move(to: onNothing, in: host)
        XCTAssertTrue(tooltipViews().isEmpty, "after leaving")
    }

    func test_noViewInTheHostHasAnAppKitToolTip() throws {
        try restAndShow(on: onFirst)

        func walk(_ view: NSView) {
            XCTAssertNil(view.toolTip)
            view.subviews.forEach(walk)
        }
        walk(host)
    }
}
