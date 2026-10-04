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
            projection: .empty, glyphs: StatusGlyphs(empty: glyph, failure: glyph), onIntent: { _ in })
        view.layoutSubtreeIfNeeded()

        func walk(_ view: NSView) {
            XCTAssertNil(view.toolTip)
            view.subviews.forEach(walk)
        }
        walk(view)
    }
}
