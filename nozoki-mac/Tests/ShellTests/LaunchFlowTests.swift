import AppKit
import Shell
import Surfaces
import XCTest

@MainActor
final class LaunchFlowTests: XCTestCase {
    private let chosenFolder = URL(fileURLWithPath: "/Users/someone/notes", isDirectory: true)
    private let namedExports: Set<String> = ["open_folder", "list_tree", "free"]

    @MainActor private struct Harness {
        let log = EventLog()
        let bridge: RecordingBridge
        let panel: FakePanel
        let presenter = FakeWindowPresenter()
        let flow: LaunchFlow

        /// `reader: nil` builds the flow without a runner, as the launch tests always did.
        init(panelAnswer: URL?, reader: ReadRunning? = nil) {
            let log = self.log
            bridge = RecordingBridge(log: log)
            panel = FakePanel(answer: panelAnswer, log: log)
            if let reader {
                flow = LaunchFlow(
                    panel: panel, bridge: bridge, glyphs: FakeGlyphSource(), presenter: presenter,
                    reader: reader)
            } else {
                flow = LaunchFlow(
                    panel: panel, bridge: bridge, glyphs: FakeGlyphSource(), presenter: presenter)
            }
        }
    }

    private func labels(of view: RootItemsView) throws -> [String] {
        try (0..<view.outlineView.numberOfRows).map { row in
            let made = view.outlineView.view(atColumn: 0, row: row, makeIfNecessary: true)
            return try XCTUnwrap((made as? NSTableCellView)?.textField?.stringValue)
        }
    }

    private func drawnLabels(_ harness: Harness) throws -> [String] {
        let view = try XCTUnwrap(harness.presenter.presented.first)
        return try labels(of: view)
    }

    func testLaunchPresentsThePanelBeforeAnyBridgeCall() {
        let harness = Harness(panelAnswer: chosenFolder)

        harness.flow.run()

        XCTAssertEqual(harness.log.events.first, "panel")
        XCTAssertEqual(harness.panel.presentedCount, 1)
    }

    func testChosenFolderOpensThenListsRoot() throws {
        let harness = Harness(panelAnswer: chosenFolder)
        let wire =
            #"{"state":"observed","entries":["#
            + #"{"name":"docs","path":"docs","kind":"folder","state":"pending"},"#
            + #"{"name":"a.md","path":"a.md","kind":"file","state":"observed"}]}"#
        harness.bridge.listAnswer = Data(wire.utf8)

        harness.flow.run()

        let calls = harness.log.events.filter { $0 != "free" && $0 != "panel" }
        XCTAssertEqual(calls, ["open_folder", "list_tree"])
        XCTAssertEqual(harness.bridge.listedPaths, [""])
        XCTAssertEqual(try drawnLabels(harness), ["docs", "a.md"])
    }

    func testOpenFolderReceivesOnlyThePanelsAnswer() {
        let harness = Harness(panelAnswer: chosenFolder)

        harness.flow.run()

        XCTAssertEqual(harness.bridge.openedLocations, [chosenFolder])
    }

    func testCancelCallsOpenFolderWithNilThenListsRoot() {
        let harness = Harness(panelAnswer: nil)

        harness.flow.run()

        let calls = harness.log.events.filter { $0 != "free" }
        XCTAssertEqual(calls, ["panel", "open_folder", "list_tree"])
        XCTAssertEqual(harness.bridge.openedLocations.count, 1)
        XCTAssertNil(harness.bridge.openedLocations[0])
        XCTAssertEqual(harness.panel.presentedCount, 1)
    }

    func testNilOpenResultDecodesAsNotOpened() throws {
        let harness = Harness(panelAnswer: chosenFolder)
        harness.bridge.openAnswer = nil

        harness.flow.run()

        XCTAssertFalse(harness.flow.folderOpened)
        XCTAssertEqual(harness.bridge.listedPaths, [""], "the flow continues to list")
    }

    func testOpenedTrueIsRead() {
        let harness = Harness(panelAnswer: chosenFolder)

        harness.flow.run()

        XCTAssertTrue(harness.flow.folderOpened)
    }

    func testOpenedFalseIsRead() {
        let harness = Harness(panelAnswer: nil)
        harness.bridge.openAnswer = Data(#"{"opened":false}"#.utf8)

        harness.flow.run()

        XCTAssertFalse(harness.flow.folderOpened)
    }

    func testNonConformingOpenPayloadReadsAsNotOpened() {
        let payloads = ["this is not json", #"{"opened":"yes"}"#, "{}"]
        for payload in payloads {
            let harness = Harness(panelAnswer: chosenFolder)
            harness.bridge.openAnswer = Data(payload.utf8)

            harness.flow.run()

            XCTAssertFalse(harness.flow.folderOpened, payload)
            XCTAssertEqual(harness.bridge.listedPaths, [""], "the flow continues to list")
        }
    }

    func testRowsCarryTheGlyphForTheirKind() throws {
        let glyphs = FakeGlyphSource()
        let log = EventLog()
        let bridge = RecordingBridge(log: log)
        let presenter = FakeWindowPresenter()
        let wire =
            #"{"state":"observed","entries":["#
            + #"{"name":"docs","path":"docs","kind":"folder","state":"pending"},"#
            + #"{"name":"a.md","path":"a.md","kind":"file","state":"observed"},"#
            + #"{"name":"link","path":"link","kind":"file","state":"failed","condition":"outside"}]}"#
        bridge.listAnswer = Data(wire.utf8)
        let flow = LaunchFlow(
            panel: FakePanel(answer: chosenFolder, log: log), bridge: bridge, glyphs: glyphs,
            presenter: presenter)

        flow.run()

        let view = try XCTUnwrap(presenter.presented.first)
        let images = try (0..<view.outlineView.numberOfRows).map { row in
            let made = view.outlineView.view(atColumn: 0, row: row, makeIfNecessary: true)
            return try XCTUnwrap((made as? NSTableCellView)?.imageView?.image)
        }
        XCTAssertEqual(images.count, 3)
        XCTAssertTrue(images[0] === glyphs.folder, "a folder row draws the folder glyph")
        XCTAssertTrue(images[1] === glyphs.file, "a file row draws the file glyph")
        XCTAssertTrue(images[2] === glyphs.file, "a failed entry draws the file glyph")
        let failedCell = try XCTUnwrap(
            view.outlineView.view(atColumn: 0, row: 2, makeIfNecessary: true)
                as? NSTableCellView)
        let sentence = failedCell.subviews.compactMap { $0 as? NSTextField }
            .first { $0.identifier?.rawValue == "entryCondition" }
        XCTAssertEqual(
            sentence?.stringValue,
            "This link leads outside the folder you opened, so Nozoki doesn't read it.")
    }

    func testNilListResultDrawsNoRow() throws {
        let harness = Harness(panelAnswer: chosenFolder)
        harness.bridge.listAnswer = nil

        harness.flow.run()

        XCTAssertEqual(try drawnLabels(harness), [])
        XCTAssertNil(try XCTUnwrap(harness.presenter.presented.first).rootLineText)
    }

    func testNonConformingListPayloadDrawsNoRow() throws {
        let payloads = [
            "this is not json",
            #"[{"name":"a","path":"a","kind":"socket"}]"#,
            "[]",
            #"{"state":"pending"}"#,
            #"{"state":"stopped"}"#,
            #"{"state":"failed","condition":"gone"}"#,
            #"{"state":"observed","entries":[{"name":"a","path":"a","kind":"file","state":"stopped"}]}"#,
            #"{"state":"observed","entries":[{"name":"a","path":"a","kind":"file","state":"failed","condition":"gone"}]}"#,
        ]
        for payload in payloads {
            let harness = Harness(panelAnswer: chosenFolder)
            harness.bridge.listAnswer = Data(payload.utf8)

            harness.flow.run()

            XCTAssertEqual(try drawnLabels(harness), [], payload)
            XCTAssertNil(try XCTUnwrap(harness.presenter.presented.first).rootLineText, payload)
        }
    }

    func testObservedEmptyPayloadDrawsTheNoFilesLine() throws {
        let harness = Harness(panelAnswer: chosenFolder)
        harness.bridge.listAnswer = Data(#"{"state":"observed","entries":[]}"#.utf8)

        harness.flow.run()

        let view = try XCTUnwrap(harness.presenter.presented.first)
        XCTAssertEqual(view.outlineView.numberOfRows, 0)
        XCTAssertEqual(view.rootLineText, "This folder has no files.")
    }

    func testFailedRootPayloadDrawsTheCantReadLine() throws {
        let harness = Harness(panelAnswer: chosenFolder)
        harness.bridge.listAnswer = Data(#"{"state":"failed","condition":"unreadable"}"#.utf8)

        harness.flow.run()

        let view = try XCTUnwrap(harness.presenter.presented.first)
        XCTAssertEqual(view.outlineView.numberOfRows, 0)
        XCTAssertEqual(view.rootLineText, "Nozoki can't read this folder.")
    }

    func testEveryCallIsANamedExport() throws {
        for answer in [chosenFolder, nil] {
            let harness = Harness(panelAnswer: answer, reader: InlineReadRunner())
            harness.bridge.listAnswer = Data(Self.docsRoot.utf8)
            harness.bridge.listAnswers["docs"] = Data(Self.docsWithGuides.utf8)
            harness.flow.run()
            try expandRow(0, of: harness)
            XCTAssertEqual(harness.bridge.listedPaths, ["", "docs"])
            let calls = harness.log.events.filter { $0 != "panel" }
            XCTAssertTrue(Set(calls).isSubset(of: namedExports), "\(calls)")
        }
    }

    func testEveryNonNilBufferIsFreedExactlyOnce() {
        let scenarios: [(open: Data?, list: Data?)] = [
            (Data(#"{"opened":true}"#.utf8), Data(#"{"state":"observed","entries":[]}"#.utf8)),
            (nil, nil),
            (Data("not json".utf8), Data("not json".utf8)),
        ]
        for scenario in scenarios {
            let harness = Harness(panelAnswer: chosenFolder)
            harness.bridge.openAnswer = scenario.open
            harness.bridge.listAnswer = scenario.list

            harness.flow.run()

            XCTAssertEqual(
                harness.bridge.freed.sorted(), harness.bridge.handedOut.sorted(),
                "each buffer handed out is freed once, and a nil is never freed")
        }
    }

    func testEveryExpansionBufferIsFreedExactlyOnce() throws {
        let expansions: [Data?] = [
            Data(#"{"state":"observed","entries":[]}"#.utf8), nil, Data("not json".utf8),
        ]
        for expansion in expansions {
            let harness = Harness(panelAnswer: chosenFolder, reader: InlineReadRunner())
            harness.bridge.listAnswer = Data(Self.docsRoot.utf8)
            harness.bridge.listAnswers["docs"] = .some(expansion)

            harness.flow.run()
            try expandRow(0, of: harness)

            XCTAssertEqual(harness.bridge.listedPaths, ["", "docs"])
            XCTAssertEqual(
                harness.bridge.freed.sorted(), harness.bridge.handedOut.sorted(),
                "each buffer handed out is freed once, and a nil is never freed")
        }
    }

    private static let docsRoot =
        #"{"state":"observed","entries":["#
        + #"{"name":"docs","path":"docs","kind":"folder","state":"pending"}]}"#
    private static let docsWithGuides =
        #"{"state":"observed","entries":["#
        + #"{"name":"guides","path":"docs/guides","kind":"folder","state":"pending"}]}"#

    private func expandRow(_ row: Int, of harness: Harness) throws {
        let view = try XCTUnwrap(harness.presenter.presented.first)
        view.outlineView.expandItem(view.outlineView.item(atRow: row))
    }

    private func collapseRow(_ row: Int, of harness: Harness) throws {
        let view = try XCTUnwrap(harness.presenter.presented.first)
        view.outlineView.collapseItem(view.outlineView.item(atRow: row))
    }

    private func docsHarness(reader: ReadRunning) -> Harness {
        let harness = Harness(panelAnswer: chosenFolder, reader: reader)
        harness.bridge.listAnswer = Data(Self.docsRoot.utf8)
        harness.bridge.listAnswers["docs"] = Data(Self.docsWithGuides.utf8)
        return harness
    }

    func testExpandingAFolderReadsItsPathThroughListTree() throws {
        let harness = docsHarness(reader: InlineReadRunner())
        harness.flow.run()

        try expandRow(0, of: harness)

        XCTAssertEqual(harness.bridge.listedPaths, ["", "docs"])
        XCTAssertEqual(try drawnLabels(harness), ["docs", "guides"])
    }

    func testReExpandingReadsAgain() throws {
        let harness = docsHarness(reader: InlineReadRunner())
        harness.flow.run()

        try expandRow(0, of: harness)
        try collapseRow(0, of: harness)
        try expandRow(0, of: harness)

        XCTAssertEqual(harness.bridge.listedPaths, ["", "docs", "docs"])
    }

    func testAHeldReadShowsTheReadingLineUntilReleased() throws {
        let runner = HoldingReadRunner()
        let harness = docsHarness(reader: runner)
        harness.flow.run()
        let view = try XCTUnwrap(harness.presenter.presented.first)

        try expandRow(0, of: harness)

        XCTAssertEqual(view.outlineView.numberOfRows, 2)
        XCTAssertEqual(view.lineText(atRow: 1), "Reading this folder.")
        XCTAssertEqual(harness.bridge.listedPaths, [""], "the read has not started")

        runner.release()

        XCTAssertEqual(try drawnLabels(harness), ["docs", "guides"])
        XCTAssertEqual(harness.bridge.listedPaths, ["", "docs"])
    }

    func testAnExpansionWithNoAnswerDrawsNothingBeneath() throws {
        let answers: [Data?] = [
            nil, Data(#"{"state":"pending"}"#.utf8), Data("not json".utf8),
        ]
        for answer in answers {
            let harness = docsHarness(reader: InlineReadRunner())
            harness.bridge.listAnswers["docs"] = .some(answer)
            harness.flow.run()
            let view = try XCTUnwrap(harness.presenter.presented.first)

            try expandRow(0, of: harness)

            XCTAssertEqual(view.outlineView.numberOfRows, 1, "nothing beneath docs")
            XCTAssertEqual(try drawnLabels(harness), ["docs"])
        }
    }

    func testTheProductionRunnerReadsOffTheMainThreadAndAnswersOnIt() async throws {
        let bridge = ThreadRecordingBridge(listAnswers: [
            "": Data(Self.docsRoot.utf8), "docs": Data(Self.docsWithGuides.utf8),
        ])
        let presenter = FakeWindowPresenter()
        let flow = LaunchFlow(
            panel: FakePanel(answer: chosenFolder, log: EventLog()), bridge: bridge,
            glyphs: FakeGlyphSource(), presenter: presenter, reader: OffMainReadRunner())
        flow.run()
        let view = try XCTUnwrap(presenter.presented.first)
        let answered = expectation(description: "the expansion's answer reached the view")
        var sinkRanOnMain: Bool?
        let intent = try XCTUnwrap(view.listTree)
        view.listTree = { path, answer in
            intent(path) { listing in
                sinkRanOnMain = Thread.isMainThread
                answer(listing)
                answered.fulfill()
            }
        }

        view.outlineView.expandItem(view.outlineView.item(atRow: 0))
        await fulfillment(of: [answered], timeout: 10)

        XCTAssertEqual(bridge.ranOnMain("list_tree:docs"), [false])
        XCTAssertEqual(bridge.ranOnMain("free:docs"), [false])
        XCTAssertEqual(sinkRanOnMain, true)
        XCTAssertEqual(try labels(of: view), ["docs", "guides"])
    }

    func testLaunchCreatesOneWindow() {
        for answer in [chosenFolder, nil] {
            let harness = Harness(panelAnswer: answer)

            harness.flow.run()

            XCTAssertEqual(harness.presenter.presented.count, 1)
        }
    }
}
