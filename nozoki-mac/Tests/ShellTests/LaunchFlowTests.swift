import AppKit
import Shell
import Surfaces
import XCTest

private let openedAnswer = Data(#"{"state":"opened"}"#.utf8)
private let emptyRootAnswer = Data(#"{"state":"observed","entries":[]}"#.utf8)
private let docsRootAnswer = Data(
    (#"{"state":"observed","entries":["#
        + #"{"name":"docs","path":"docs","kind":"folder","state":"pending"},"#
        + #"{"name":"a.md","path":"a.md","kind":"file","state":"observed"}]}"#).utf8)
private let emptyDocsAnswer = Data(#"{"state":"observed","entries":[]}"#.utf8)

@MainActor
final class LaunchFlowTests: XCTestCase {
    private let chosenFolder = URL(fileURLWithPath: "/Users/someone/notes", isDirectory: true)
    private let namedBridgeCalls: Set<String> = ["open_folder", "list_tree", "free"]

    private var failureCases: [(OpeningCondition, Data, String)] {
        [
            (
                .missing, Data(#"{"state":"failed","condition":"missing"}"#.utf8),
                "Nozoki couldn't find this folder."
            ),
            (
                .notAFolder, Data(#"{"state":"failed","condition":"not_a_folder"}"#.utf8),
                "Nozoki found a file where it needs a folder."
            ),
            (
                .unreadable, Data(#"{"state":"failed","condition":"unreadable"}"#.utf8),
                "Nozoki can't read this folder."
            ),
        ]
    }

    private func makeFlow(
        answers: [URL?],
        open: Data? = openedAnswer,
        list: Data? = emptyRootAnswer,
        reader: ReadRunning? = nil,
        terminate: @escaping () -> Void = {}
    ) -> (LaunchFlow, RecordingBridge, FakePanel, FakeWindowPresenter, EventLog) {
        let log = EventLog()
        let bridge = RecordingBridge(log: log)
        bridge.openAnswer = open
        bridge.listAnswer = list
        let panel = FakePanel(answers: answers, log: log)
        let presenter = FakeWindowPresenter()
        let flow = LaunchFlow(
            panel: panel, bridge: bridge, glyphs: FakeGlyphSource(), presenter: presenter,
            reader: reader ?? InlineReadRunner(), terminate: terminate)
        return (flow, bridge, panel, presenter, log)
    }

    private func startupView(in presenter: FakeWindowPresenter) throws -> StartupView {
        try XCTUnwrap(presenter.contents.last as? StartupView)
    }

    private func workbench(in presenter: FakeWindowPresenter) throws -> WorkbenchView {
        try XCTUnwrap(presenter.contents.last as? WorkbenchView)
    }

    private func labels(in view: RootItemsView) throws -> [String] {
        try (0..<view.outlineView.numberOfRows).map { row in
            let cell = view.outlineView.view(atColumn: 0, row: row, makeIfNecessary: true)
            return try XCTUnwrap((cell as? NSTableCellView)?.textField?.stringValue)
        }
    }

    func testInitialDismissalShowsEmptyWithoutCrossingTheBridge() throws {
        let (flow, bridge, panel, presenter, log) = makeFlow(answers: [nil])

        flow.run()

        XCTAssertEqual(log.events, ["panel"])
        XCTAssertEqual(panel.presentedCount, 1)
        XCTAssertEqual(bridge.openedLocations, [])
        XCTAssertEqual(bridge.listedPaths, [])
        XCTAssertEqual(
            try startupView(in: presenter).drawnText,
            ["Choose a folder to view.", "Browse…", "Quit"])
        XCTAssertEqual(presenter.createdWindowCount, 1)
    }

    func testRepeatedBrowseAndDismissReusesOneWindowWithoutReads() throws {
        let (flow, bridge, panel, presenter, log) = makeFlow(answers: [nil, nil, nil, nil])
        flow.run()

        for _ in 0..<3 {
            try startupView(in: presenter).activate(.browse)
        }

        XCTAssertEqual(log.events, ["panel", "panel", "panel", "panel"])
        XCTAssertEqual(panel.presentedCount, 4)
        XCTAssertEqual(bridge.openedLocations, [])
        XCTAssertEqual(bridge.listedPaths, [])
        XCTAssertEqual(presenter.createdWindowCount, 1)
        XCTAssertEqual(presenter.contents.count, 4)
    }

    func testQuitFromEveryStartupStateCallsOnlyTheInjectedTerminator() throws {
        let startupPayloads: [(URL?, Data?)] =
            [(nil, openedAnswer)]
            + failureCases.map { (chosenFolder, Optional($0.1)) }
            + [(chosenFolder, Data("malformed".utf8))]

        for (panelAnswer, payload) in startupPayloads {
            var terminations = 0
            let (flow, _, _, presenter, log) = makeFlow(
                answers: [panelAnswer], open: payload, terminate: { terminations += 1 })
            flow.run()
            let bridgeCallsBeforeQuit = log.events.filter { $0 != "panel" }

            try startupView(in: presenter).activate(.quit)

            XCTAssertEqual(terminations, 1)
            XCTAssertEqual(log.events.filter { $0 != "panel" }, bridgeCallsBeforeQuit)
        }
    }

    func testEachObservedOpenFailureStaysInTheSameWindowWithoutListing() throws {
        for (condition, payload, sentence) in failureCases {
            let (flow, bridge, _, presenter, _) = makeFlow(
                answers: [chosenFolder], open: payload)

            flow.run()

            XCTAssertEqual(bridge.openedLocations, [chosenFolder], "\(condition)")
            XCTAssertEqual(bridge.listedPaths, [], "\(condition)")
            XCTAssertEqual(
                try startupView(in: presenter).drawnText,
                [chosenFolder.path, sentence, "Browse…", "Quit"],
                "\(condition)")
            XCTAssertEqual(presenter.createdWindowCount, 1, "\(condition)")
            XCTAssertEqual(bridge.handedOut, bridge.freed, "\(condition)")
        }
    }

    func testBrowseFromEveryStartupStateCanReachTheWorkbench() throws {
        let startingStates: [(URL?, Data?)] =
            [(nil, openedAnswer)]
            + failureCases.map { (chosenFolder, Optional($0.1)) }
            + [(chosenFolder, Data("malformed".utf8))]

        for (initialAnswer, initialPayload) in startingStates {
            let (flow, bridge, panel, presenter, _) = makeFlow(
                answers: [initialAnswer, chosenFolder], open: initialPayload)
            flow.run()
            bridge.openAnswer = openedAnswer

            try startupView(in: presenter).activate(.browse)

            XCTAssertEqual(panel.presentedCount, 2)
            XCTAssertEqual(bridge.openedLocations.last, chosenFolder)
            XCTAssertEqual(bridge.listedPaths, [""])
            XCTAssertNotNil(try workbench(in: presenter))
            XCTAssertEqual(presenter.createdWindowCount, 1)
        }
    }

    func testDismissalAfterObservedOrStoppedFailureReturnsToEmptyWithoutReads() throws {
        let failurePayloads: [Data?] =
            failureCases.map { Optional($0.1) }
            + [Data("malformed".utf8)]

        for payload in failurePayloads {
            let (flow, bridge, panel, presenter, _) = makeFlow(
                answers: [chosenFolder, nil], open: payload)
            flow.run()
            let openedBeforeDismissal = bridge.openedLocations

            try startupView(in: presenter).activate(.browse)

            XCTAssertEqual(panel.presentedCount, 2)
            XCTAssertEqual(bridge.openedLocations, openedBeforeDismissal)
            XCTAssertEqual(bridge.listedPaths, [])
            XCTAssertEqual(
                try startupView(in: presenter).drawnText,
                ["Choose a folder to view.", "Browse…", "Quit"])
            XCTAssertEqual(presenter.createdWindowCount, 1)
        }
    }

    func testInitialSuccessUsesTheSingleCreatedWindow() throws {
        let (flow, bridge, _, presenter, log) = makeFlow(
            answers: [chosenFolder], list: docsRootAnswer)

        flow.run()

        let workbench = try workbench(in: presenter)
        XCTAssertEqual(
            log.events.filter { $0 != "free" }, ["panel", "open_folder", "list_tree"])
        XCTAssertEqual(bridge.openedLocations, [chosenFolder])
        XCTAssertEqual(bridge.listedPaths, [""])
        XCTAssertTrue(flow.folderOpened)
        XCTAssertEqual(try labels(in: workbench.rootItemsView), ["docs", "a.md"])
        XCTAssertEqual(presenter.createdWindowCount, 1)
        XCTAssertEqual(presenter.contents.count, 2, "reading is replaced by the workbench")
    }

    func testOpenAndRootReadRunOffMainAndDeliveryRunsOnMain() async throws {
        let bridge = ThreadRecordingBridge(listAnswers: ["": docsRootAnswer])
        let log = EventLog()
        let presenter = FakeWindowPresenter()
        let delivered = expectation(description: "the workbench was delivered")
        presenter.onPresent = { content in
            if content is WorkbenchView { delivered.fulfill() }
        }
        let flow = LaunchFlow(
            panel: FakePanel(answers: [chosenFolder], log: log), bridge: bridge,
            glyphs: FakeGlyphSource(), presenter: presenter, reader: OffMainReadRunner())

        flow.run()
        await fulfillment(of: [delivered], timeout: 10)

        XCTAssertEqual(bridge.ranOnMain("open_folder"), [false])
        XCTAssertEqual(bridge.ranOnMain("list_tree:"), [false])
        XCTAssertEqual(bridge.ranOnMain("free:open"), [false])
        XCTAssertEqual(bridge.ranOnMain("free:"), [false])
        XCTAssertTrue(presenter.presentationsOnMain.allSatisfy { $0 })
        XCTAssertEqual(try labels(in: workbench(in: presenter).rootItemsView), ["docs", "a.md"])
    }

    func testInvalidOpenAnswerStopsWithoutClaimingAConditionOrListing() throws {
        let invalidAnswers: [Data?] = [nil, Data("malformed".utf8)]

        for answer in invalidAnswers {
            let (flow, bridge, _, presenter, _) = makeFlow(
                answers: [chosenFolder], open: answer)

            flow.run()

            XCTAssertEqual(bridge.listedPaths, [])
            XCTAssertEqual(
                try startupView(in: presenter).drawnText,
                [chosenFolder.path, "Nozoki couldn't open this folder.", "Browse…", "Quit"])
        }
    }

    func testMalformedRootAnswerPreservesTheExistingNoAnswerBehavior() throws {
        let (flow, _, _, presenter, _) = makeFlow(
            answers: [chosenFolder], list: Data("malformed".utf8))

        flow.run()

        let root = try workbench(in: presenter).rootItemsView
        XCTAssertEqual(root.outlineView.numberOfRows, 0)
        XCTAssertNil(root.rootLineText)
    }

    func testLaunchUsesOnlyNamedExportsAndFreesEveryNonNilBufferOnce() throws {
        let cancellation = makeFlow(answers: [nil])
        cancellation.0.run()
        XCTAssertEqual(cancellation.4.events, ["panel"])
        XCTAssertEqual(cancellation.1.handedOut, [])
        XCTAssertEqual(cancellation.1.freed, [])

        for (_, payload, _) in failureCases {
            let (flow, bridge, _, _, log) = makeFlow(answers: [chosenFolder], open: payload)
            flow.run()
            XCTAssertTrue(Set(log.events.filter { $0 != "panel" }).isSubset(of: namedBridgeCalls))
            XCTAssertEqual(bridge.freed.sorted(), bridge.handedOut.sorted())
        }

        let (flow, bridge, _, presenter, log) = makeFlow(
            answers: [chosenFolder], list: docsRootAnswer)
        bridge.listAnswers["docs"] = emptyDocsAnswer
        flow.run()
        let root = try workbench(in: presenter).rootItemsView
        root.outlineView.expandItem(root.outlineView.item(atRow: 0))

        XCTAssertEqual(bridge.listedPaths, ["", "docs"])
        XCTAssertTrue(Set(log.events.filter { $0 != "panel" }).isSubset(of: namedBridgeCalls))
        XCTAssertEqual(bridge.freed.sorted(), bridge.handedOut.sorted())
        XCTAssertEqual(Set(bridge.freed).count, bridge.freed.count, "no buffer is freed twice")
    }
}
