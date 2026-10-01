import AppKit
import Shell
import Surfaces
import XCTest

private let openedAnswer = Data(#"{"state":"opened"}"#.utf8)
private let emptyRootAnswer = Data(#"{"state":"observed","entries":[]}"#.utf8)
private let docsRootAnswer = Data(
    (#"{"state":"observed","entries":["#
        + #"{"name":"docs","path":"docs","kind":"folder","state":"pending"},"#
        + #"{"name":"a.md","path":"a.md","kind":"file","state":"observed","language":"plain"}]}"#)
        .utf8)
private let emptyDocsAnswer = Data(#"{"state":"observed","entries":[]}"#.utf8)

@MainActor
final class LaunchFlowTests: XCTestCase {
    private let chosenFolder = URL(fileURLWithPath: "/Users/someone/notes", isDirectory: true)
    private let namedBridgeCalls: Set<String> = ["open_folder", "list_tree", "free"]
    private let browseTitle = "Browse…"
    private let quitTitle = "Quit"

    override class func setUp() {
        super.setUp()
        createTheSharedApplication()
    }

    private var failureCases: [(OpeningCondition, Data, String)] {
        [
            (
                .missing, Data(#"{"condition":"missing","state":"failed"}"#.utf8),
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

    private var invalidOpenAnswers: [Data?] {
        [
            nil,
            Data("".utf8),
            Data("malformed".utf8),
            Data("[]".utf8),
            Data(#"{}"#.utf8),
            Data(#"{"condition":"missing"}"#.utf8),
            Data(#"{"state":7}"#.utf8),
            Data(#"{"state":"pending"}"#.utf8),
            Data(#"{"state":"opened","extra":true}"#.utf8),
            Data(#"{"state":"opened","condition":"missing"}"#.utf8),
            Data(#"{"state":"failed"}"#.utf8),
            Data(#"{"state":"failed","condition":7}"#.utf8),
            Data(#"{"state":"failed","condition":"unknown"}"#.utf8),
            Data(#"{"state":"failed","condition":"missing","extra":true}"#.utf8),
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

    /// What the presented startup surface draws, top to bottom. The surface is in no window here,
    /// so it is given the opening size and laid out before its elements' places are read.
    private func drawnStartup(in presenter: FakeWindowPresenter) throws -> [String] {
        let surface = try startupView(in: presenter)
        surface.frame = NSRect(origin: .zero, size: openingContentSize)
        surface.layoutSubtreeIfNeeded()
        return drawnStrings(beneath: surface)
    }

    /// One click on the control of that title drawn by the presented startup surface.
    private func clickRoute(titled title: String, in presenter: FakeWindowPresenter) throws {
        click(try control(titled: title, beneath: try startupView(in: presenter)))
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
            try drawnStartup(in: presenter),
            ["Choose a folder to view.", "Browse…", "Quit"])
        XCTAssertEqual(presenter.createdWindowCount, 1)
    }

    func testRepeatedBrowseAndDismissReusesOneWindowWithoutReads() throws {
        let (flow, bridge, panel, presenter, log) = makeFlow(answers: [nil, nil, nil, nil])
        flow.run()

        for _ in 0..<3 {
            try clickRoute(titled: browseTitle, in: presenter)
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

            try clickRoute(titled: quitTitle, in: presenter)

            XCTAssertEqual(terminations, 1)
            XCTAssertEqual(log.events.filter { $0 != "panel" }, bridgeCallsBeforeQuit)
        }
    }

    func testEachObservedOpenFailureAcceptsReversedMemberOrderWithoutListing() throws {
        for (condition, payload, sentence) in failureCases {
            let (flow, bridge, _, presenter, _) = makeFlow(
                answers: [chosenFolder], open: payload)

            flow.run()

            XCTAssertEqual(bridge.openedLocations, [chosenFolder], "\(condition)")
            XCTAssertEqual(bridge.listedPaths, [], "\(condition)")
            XCTAssertEqual(
                try drawnStartup(in: presenter),
                [chosenFolder.path, sentence, "Browse…", "Quit"],
                "\(condition)")
            XCTAssertEqual(presenter.createdWindowCount, 1, "\(condition)")
            XCTAssertEqual(bridge.handedOut, bridge.freed, "\(condition)")
        }
    }

    func testEveryOrderedObservedFailurePairStaysInOneWindow() throws {
        for (firstCondition, firstPayload, _) in failureCases {
            for (secondCondition, secondPayload, secondSentence) in failureCases {
                let firstURL = URL(fileURLWithPath: "/Users/someone/first-\(firstCondition)")
                let secondURL = URL(fileURLWithPath: "/Users/someone/second-\(secondCondition)")
                let (flow, bridge, panel, presenter, _) = makeFlow(answers: [firstURL, secondURL])
                bridge.openAnswers = [firstPayload, secondPayload]

                flow.run()
                try clickRoute(titled: browseTitle, in: presenter)

                XCTAssertEqual(panel.presentedCount, 2, "\(firstCondition), \(secondCondition)")
                XCTAssertEqual(bridge.openedLocations, [firstURL, secondURL])
                XCTAssertEqual(bridge.listedPaths, [])
                XCTAssertEqual(presenter.createdWindowCount, 1)
                XCTAssertEqual(
                    try drawnStartup(in: presenter),
                    [secondURL.path, secondSentence, "Browse…", "Quit"])
                XCTAssertEqual(bridge.handedOut.sorted(), bridge.freed.sorted())
                XCTAssertEqual(Set(bridge.freed).count, bridge.freed.count)
            }
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

            try clickRoute(titled: browseTitle, in: presenter)

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

            try clickRoute(titled: browseTitle, in: presenter)

            XCTAssertEqual(panel.presentedCount, 2)
            XCTAssertEqual(bridge.openedLocations, openedBeforeDismissal)
            XCTAssertEqual(bridge.listedPaths, [])
            XCTAssertEqual(
                try drawnStartup(in: presenter),
                ["Choose a folder to view.", "Browse…", "Quit"])
            XCTAssertEqual(presenter.createdWindowCount, 1)
        }
    }

    func testInitialSuccessAcceptsWhitespaceAndPresentsTheWorkbench() throws {
        let (flow, bridge, _, presenter, log) = makeFlow(
            answers: [chosenFolder], open: Data(" { \"state\" : \"opened\" } ".utf8),
            list: docsRootAnswer)

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

    func testOpenRootAndRepeatedExpansionsReadAndFreeOffMainThenDeliverOnMain() async throws {
        let guidesAnswer = Data(
            #"{"state":"observed","entries":[{"name":"guides","path":"docs/guides","kind":"folder","state":"pending"}]}"#
                .utf8)
        let bridge = ThreadRecordingBridge(
            listAnswers: ["": docsRootAnswer, "docs": guidesAnswer, "docs/guides": emptyDocsAnswer])
        let log = EventLog()
        let presenter = FakeWindowPresenter()
        let runner = DeliveryRecordingReadRunner()
        let delivered = expectation(description: "the workbench was delivered")
        presenter.onPresent = { content in
            if content is WorkbenchView { delivered.fulfill() }
        }
        let flow = LaunchFlow(
            panel: FakePanel(answers: [chosenFolder], log: log), bridge: bridge,
            glyphs: FakeGlyphSource(), presenter: presenter, reader: runner, terminate: {})

        flow.run()
        await fulfillment(of: [delivered], timeout: 10)

        let root = try workbench(in: presenter).rootItemsView
        let docsDelivered = expectation(description: "docs was delivered")
        runner.onDelivery = { docsDelivered.fulfill() }
        root.outlineView.expandItem(root.outlineView.item(atRow: 0))
        await fulfillment(of: [docsDelivered], timeout: 10)

        let guidesDelivered = expectation(description: "guides was delivered")
        runner.onDelivery = { guidesDelivered.fulfill() }
        root.outlineView.expandItem(root.outlineView.item(atRow: 1))
        await fulfillment(of: [guidesDelivered], timeout: 10)
        XCTAssertEqual(
            try labels(in: root), ["docs", "guides", "This folder has no files.", "a.md"])

        let repeatedDocsDelivered = expectation(description: "docs was delivered again")
        runner.onDelivery = { repeatedDocsDelivered.fulfill() }
        root.outlineView.collapseItem(root.outlineView.item(atRow: 0))
        root.outlineView.expandItem(root.outlineView.item(atRow: 0))
        await fulfillment(of: [repeatedDocsDelivered], timeout: 10)

        XCTAssertEqual(bridge.ranOnMain("open_folder"), [false])
        XCTAssertEqual(bridge.ranOnMain("list_tree:"), [false])
        XCTAssertEqual(bridge.ranOnMain("list_tree:docs"), [false, false])
        XCTAssertEqual(bridge.ranOnMain("list_tree:docs/guides"), [false])
        XCTAssertEqual(bridge.ranOnMain("free:open"), [false])
        XCTAssertEqual(bridge.ranOnMain("free:"), [false])
        XCTAssertEqual(bridge.ranOnMain("free:docs"), [false, false])
        XCTAssertEqual(bridge.ranOnMain("free:docs/guides"), [false])
        XCTAssertEqual(runner.deliveriesOnMain, [true, true, true, true])
        XCTAssertTrue(presenter.presentationsOnMain.allSatisfy { $0 })
        XCTAssertEqual(try labels(in: root), ["docs", "guides", "a.md"])
    }

    func testInvalidOpenAnswerStopsWithoutClaimingAConditionOrListing() throws {
        for answer in invalidOpenAnswers {
            let (flow, bridge, _, presenter, _) = makeFlow(
                answers: [chosenFolder], open: answer)

            flow.run()

            XCTAssertEqual(bridge.listedPaths, [])
            XCTAssertFalse(flow.folderOpened)
            XCTAssertFalse(presenter.contents.contains { $0 is WorkbenchView })
            XCTAssertEqual(
                try drawnStartup(in: presenter),
                [chosenFolder.path, "Nozoki couldn't open this folder.", "Browse…", "Quit"])
            XCTAssertEqual(bridge.handedOut, bridge.freed)
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

    func testInvalidFileLanguageRefusesTheWholeRootListing() throws {
        for member in ["", #", "language":"rust""#, #", "language":7"#, #", "language":null"#] {
            let wire =
                #"{"state":"observed","entries":["#
                + #"{"name":"src","path":"src","kind":"folder","state":"pending"},"#
                + #"{"name":"app.py","path":"app.py","kind":"file","state":"observed""#
                + member + "}]}"
            let (flow, bridge, _, presenter, _) = makeFlow(
                answers: [chosenFolder], list: Data(wire.utf8))

            flow.run()

            let root = try workbench(in: presenter).rootItemsView
            XCTAssertEqual(root.outlineView.numberOfRows, 0, member)
            XCTAssertNil(root.rootLineText, member)
            XCTAssertEqual(bridge.handedOut.sorted(), bridge.freed.sorted(), member)
        }
    }

    func testLaunchUsesOnlyNamedExportsAndFreesEveryNonNilBufferOnce() throws {
        let cancellation = makeFlow(answers: [nil])
        cancellation.0.run()
        XCTAssertEqual(cancellation.4.events, ["panel"])
        XCTAssertEqual(cancellation.1.handedOut, [])
        XCTAssertEqual(cancellation.1.freed, [])

        for payload in failureCases.map(\.1) + invalidOpenAnswers.compactMap({ $0 }) {
            let (flow, bridge, _, _, log) = makeFlow(answers: [chosenFolder], open: payload)
            flow.run()
            let label = String(decoding: payload, as: UTF8.self)
            XCTAssertTrue(
                Set(log.events.filter { $0 != "panel" }).isSubset(of: namedBridgeCalls), label)
            XCTAssertEqual(bridge.handedOut.count, 1, label)
            XCTAssertEqual(bridge.freed.sorted(), bridge.handedOut.sorted(), label)
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
