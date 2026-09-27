import AppKit
import Shell
import Surfaces
import XCTest

@MainActor
final class LaunchFlowTests: XCTestCase {
    private let chosenFolder = URL(fileURLWithPath: "/Users/someone/notes", isDirectory: true)

    private func makeFlow(
        answers: [URL?], open: Data? = Data(#"{"state":"opened"}"#.utf8),
        list: Data? = Data(#"{"state":"observed","entries":[]}"#.utf8)
    ) -> (LaunchFlow, RecordingBridge, FakeWindowPresenter, EventLog) {
        let log = EventLog()
        let bridge = RecordingBridge(log: log)
        bridge.openAnswer = open
        bridge.listAnswer = list
        let presenter = FakeWindowPresenter()
        let flow = LaunchFlow(
            panel: FakePanel(answers: answers, log: log), bridge: bridge, glyphs: FakeGlyphSource(),
            presenter: presenter, reader: InlineReadRunner())
        return (flow, bridge, presenter, log)
    }

    func testInitialDismissalShowsEmptyWithoutCrossingTheBridge() throws {
        let (flow, bridge, presenter, log) = makeFlow(answers: [nil])
        flow.run()
        XCTAssertEqual(log.events, ["panel"])
        XCTAssertEqual(bridge.openedLocations, [])
        XCTAssertEqual(bridge.listedPaths, [])
        XCTAssertEqual(try XCTUnwrap(presenter.contents.last as? StartupView).drawnText,
                       ["Choose a folder to view.", "Browse…", "Quit"])
    }

    func testObservedOpeningFailureStaysInTheWindowWithoutListing() throws {
        let failed = Data(#"{"state":"failed","condition":"missing"}"#.utf8)
        let (flow, bridge, presenter, _) = makeFlow(answers: [chosenFolder], open: failed)
        flow.run()
        XCTAssertEqual(bridge.openedLocations, [chosenFolder])
        XCTAssertEqual(bridge.listedPaths, [])
        XCTAssertEqual(presenter.contents.count, 2)
        XCTAssertEqual(try XCTUnwrap(presenter.contents.last as? StartupView).availableIntents,
                       [.browse, .quit])
    }

    func testInitialSuccessListsRootAndPresentsWorkbench() throws {
        let (flow, bridge, presenter, _) = makeFlow(answers: [chosenFolder])
        flow.run()
        XCTAssertEqual(bridge.openedLocations, [chosenFolder])
        XCTAssertEqual(bridge.listedPaths, [""])
        XCTAssertTrue(flow.folderOpened)
        XCTAssertNotNil(presenter.contents.last as? WorkbenchView)
    }

    func testInvalidOpenAnswerStopsWithoutListing() throws {
        let (flow, bridge, presenter, _) = makeFlow(answers: [chosenFolder], open: Data("bad".utf8))
        flow.run()
        XCTAssertEqual(bridge.listedPaths, [])
        XCTAssertEqual(try XCTUnwrap(presenter.contents.last as? StartupView).availableIntents,
                       [.browse, .quit])
    }

    func testRepeatedBrowseAndDismissReusesOneWindowWithoutReads() throws {
        let (flow, bridge, presenter, log) = makeFlow(answers: [nil, nil, nil, nil])
        flow.run()
        for _ in 0..<3 {
            try XCTUnwrap(presenter.contents.last as? StartupView).activate(.browse)
        }
        XCTAssertEqual(log.events, ["panel", "panel", "panel", "panel"])
        XCTAssertEqual(bridge.openedLocations, [])
        XCTAssertEqual(bridge.listedPaths, [])
        XCTAssertEqual(presenter.createdWindowCount, 1)
        XCTAssertEqual(presenter.contents.count, 4)
    }

    func testQuitFromEveryStartupStateCallsOnlyTheInjectedTerminator() throws {
        for payload in [nil, Data(#"{"state":"failed","condition":"missing"}"#.utf8), Data("bad".utf8)] {
            var terminations = 0
            let log = EventLog()
            let bridge = RecordingBridge(log: log)
            bridge.openAnswer = payload
            let presenter = FakeWindowPresenter()
            let flow = LaunchFlow(panel: FakePanel(answers: [payload == nil ? nil : chosenFolder], log: log), bridge: bridge, glyphs: FakeGlyphSource(), presenter: presenter, reader: InlineReadRunner(), terminate: { terminations += 1 })
            flow.run()
            try XCTUnwrap(presenter.contents.last as? StartupView).activate(.quit)
            XCTAssertEqual(terminations, 1)
            XCTAssertEqual(bridge.listedPaths, [])
        }
    }

    func testBrowseFromFailureCanReachWorkbenchInTheSameWindow() throws {
        let failure = Data(#"{"state":"failed","condition":"unreadable"}"#.utf8)
        let (flow, bridge, presenter, _) = makeFlow(answers: [chosenFolder, chosenFolder], open: failure)
        flow.run()
        bridge.openAnswer = Data(#"{"state":"opened"}"#.utf8)
        try XCTUnwrap(presenter.contents.last as? StartupView).activate(.browse)
        XCTAssertEqual(bridge.openedLocations, [chosenFolder, chosenFolder])
        XCTAssertEqual(bridge.listedPaths, [""])
        XCTAssertNotNil(presenter.contents.last as? WorkbenchView)
        XCTAssertEqual(presenter.createdWindowCount, 1)
    }
}
