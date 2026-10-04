import AppKit
import XCTest

@testable import Surfaces

@MainActor
final class StartupViewTests: XCTestCase {
    func testOpeningConditionIsClosedToTheThreeObservedValues() {
        XCTAssertEqual(OpeningCondition.allCases, [.missing, .notAFolder, .unreadable])
    }

    func test_noElementOfTheStartupViewHasATooltip() {
        let glyph = NSImage(size: NSSize(width: 1, height: 1))
        let view = StartupView(
            projection: .empty, glyphs: StatusGlyphs(empty: glyph, failure: glyph),
            onIntent: { _ in })
        view.layoutSubtreeIfNeeded()

        func walk(_ view: NSView) {
            XCTAssertNil(view.toolTip)
            view.subviews.forEach(walk)
        }
        walk(view)
    }

    /// CP-588: the product's own tooltip is raised only through a `LetterTooltip`, and the startup
    /// surface draws no letter, so no view in it carries one.
    func test_noViewOfTheStartupViewHoldsALetterTooltip() {
        let glyph = NSImage(size: NSSize(width: 1, height: 1))
        let view = StartupView(
            projection: .empty, glyphs: StatusGlyphs(empty: glyph, failure: glyph),
            onIntent: { _ in })
        view.layoutSubtreeIfNeeded()

        func walk(_ view: NSView) {
            XCTAssertFalse(view.trackingAreas.contains { $0.owner is LetterTooltip })
            view.subviews.forEach(walk)
        }
        walk(view)
    }
}
