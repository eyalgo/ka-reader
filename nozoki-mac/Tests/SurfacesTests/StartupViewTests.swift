import XCTest

@testable import Surfaces

@MainActor
final class StartupViewTests: XCTestCase {
    func testEmptyStartupDrawsOnlyThePromptBrowseAndQuit() {
        let view = StartupView(projection: .empty, onIntent: { _ in })

        XCTAssertEqual(view.drawnText, ["Choose a folder to view.", "Browse…", "Quit"])
        XCTAssertFalse(
            view.drawnText.contains(where: { $0.contains("read") || $0.contains("file") }))
    }

    func testEmptyStartupControlsEmitOnlyTheirNamedIntents() {
        var intents: [StartupIntent] = []
        let view = StartupView(projection: .empty, onIntent: { intents.append($0) })

        view.activate(.browse)
        view.activate(.quit)

        XCTAssertEqual(intents, [.browse, .quit])
    }

    func testEachObservedOpeningFailureDrawsThePathConditionAndRoutes() {
        let path = "/Users/someone/gone"
        let cases: [(OpeningCondition, String)] = [
            (.missing, "Nozoki couldn't find this folder."),
            (.notAFolder, "Nozoki found a file where it needs a folder."),
            (.unreadable, "Nozoki can't read this folder."),
        ]

        for (condition, sentence) in cases {
            let view = StartupView(
                projection: .failed(path: path, condition: condition), onIntent: { _ in })

            XCTAssertEqual(view.drawnText, [path, sentence, "Browse…", "Quit"], "\(condition)")
            XCTAssertFalse(
                view.drawnText.joined(separator: " ").contains("terminal"), "\(condition)")
        }
    }

    func testStoppedOpeningUsesOnlyTheUnexplainedFaultMessageAndRoutes() {
        let path = "/Users/someone/gone"
        let view = StartupView(projection: .stopped(path: path), onIntent: { _ in })

        XCTAssertEqual(
            view.drawnText, [path, "Nozoki couldn't open this folder.", "Browse…", "Quit"])
    }

    func testReadingDrawsOnlyTheLoadingLineAndNoControl() {
        let view = StartupView(projection: .reading, onIntent: { _ in })

        XCTAssertEqual(view.drawnText, ["Reading this folder."])
        XCTAssertEqual(view.availableIntents, [])
    }

    func testOpeningConditionIsClosedToTheThreeObservedValues() {
        XCTAssertEqual(OpeningCondition.allCases, [.missing, .notAFolder, .unreadable])
    }
}
