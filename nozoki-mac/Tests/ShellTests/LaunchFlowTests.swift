import AppKit
import Shell
import Surfaces
import XCTest

@MainActor
final class LaunchFlowTests: XCTestCase {
    private let chosenFolder = URL(fileURLWithPath: "/Users/someone/notes", isDirectory: true)

    private func makeFlow(
        answer: URL?, open: Data? = Data(#"{"state":"opened"}"#.utf8),
        list: Data? = Data(#"{"state":"observed","entries":[]}"#.utf8)
    ) -> (LaunchFlow, RecordingBridge, FakeWindowPresenter, EventLog) {
        let log = EventLog()
        let bridge = RecordingBridge(log: log)
        bridge.openAnswer = open
        bridge.listAnswer = list
        let presenter = FakeWindowPresenter()
        let flow = LaunchFlow(
            panel: FakePanel(answer: answer, log: log), bridge: bridge, glyphs: FakeGlyphSource(),
            presenter: presenter, reader: InlineReadRunner())
        return (flow, bridge, presenter, log)
    }

    func testInitialDismissalShowsEmptyWithoutCrossingTheBridge() throws {
        let (flow, bridge, presenter, log) = makeFlow(answer: nil)
        flow.run()
        XCTAssertEqual(log.events, ["panel"])
        XCTAssertEqual(bridge.openedLocations, [])
        XCTAssertEqual(bridge.listedPaths, [])
        XCTAssertEqual(try XCTUnwrap(presenter.contents.last as? StartupView).drawnText,
                       ["Choose a folder to view.", "Browse…", "Quit"])
    }

    func testObservedOpeningFailureStaysInTheWindowWithoutListing() throws {
        let failed = Data(#"{"state":"failed","condition":"missing"}"#.utf8)
        let (flow, bridge, presenter, _) = makeFlow(answer: chosenFolder, open: failed)
        flow.run()
        XCTAssertEqual(bridge.openedLocations, [chosenFolder])
        XCTAssertEqual(bridge.listedPaths, [])
        XCTAssertEqual(presenter.contents.count, 2)
        XCTAssertEqual(try XCTUnwrap(presenter.contents.last as? StartupView).availableIntents,
                       [.browse, .quit])
    }

    func testInitialSuccessListsRootAndPresentsWorkbench() throws {
        let (flow, bridge, presenter, _) = makeFlow(answer: chosenFolder)
        flow.run()
        XCTAssertEqual(bridge.openedLocations, [chosenFolder])
        XCTAssertEqual(bridge.listedPaths, [""])
        XCTAssertTrue(flow.folderOpened)
        XCTAssertNotNil(presenter.contents.last as? WorkbenchView)
    }

    func testInvalidOpenAnswerStopsWithoutListing() throws {
        let (flow, bridge, presenter, _) = makeFlow(answer: chosenFolder, open: Data("bad".utf8))
        flow.run()
        XCTAssertEqual(bridge.listedPaths, [])
        XCTAssertEqual(try XCTUnwrap(presenter.contents.last as? StartupView).availableIntents,
                       [.browse, .quit])
    }
}
