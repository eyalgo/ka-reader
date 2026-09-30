import XCTest

@testable import Surfaces

@MainActor
final class StartupViewTests: XCTestCase {
    func testOpeningConditionIsClosedToTheThreeObservedValues() {
        XCTAssertEqual(OpeningCondition.allCases, [.missing, .notAFolder, .unreadable])
    }
}
