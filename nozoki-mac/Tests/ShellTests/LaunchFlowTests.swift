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

        init(panelAnswer: URL?) {
            let log = self.log
            bridge = RecordingBridge(log: log)
            panel = FakePanel(answer: panelAnswer, log: log)
            flow = LaunchFlow(
                panel: panel, bridge: bridge, glyphs: FakeGlyphSource(), presenter: presenter)
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
            #"[{"name":"docs","path":"docs","kind":"folder"},"#
            + #"{"name":"a.md","path":"a.md","kind":"file"}]"#
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

    func testNilListResultDrawsNoRow() throws {
        let harness = Harness(panelAnswer: chosenFolder)
        harness.bridge.listAnswer = nil

        harness.flow.run()

        XCTAssertEqual(try drawnLabels(harness), [])
    }

    func testNonConformingListPayloadDrawsNoRow() throws {
        let payloads = [
            "this is not json",
            #"[{"name":"a","path":"a","kind":"socket"}]"#,
        ]
        for payload in payloads {
            let harness = Harness(panelAnswer: chosenFolder)
            harness.bridge.listAnswer = Data(payload.utf8)

            harness.flow.run()

            XCTAssertEqual(try drawnLabels(harness), [], payload)
        }
    }

    func testEveryCallIsANamedExport() {
        for answer in [chosenFolder, nil] {
            let harness = Harness(panelAnswer: answer)
            harness.flow.run()
            let calls = harness.log.events.filter { $0 != "panel" }
            XCTAssertTrue(Set(calls).isSubset(of: namedExports), "\(calls)")
        }
    }

    func testEveryNonNilBufferIsFreedExactlyOnce() {
        let scenarios: [(open: Data?, list: Data?)] = [
            (Data(#"{"opened":true}"#.utf8), Data("[]".utf8)),
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

    func testLaunchCreatesOneWindow() {
        for answer in [chosenFolder, nil] {
            let harness = Harness(panelAnswer: answer)

            harness.flow.run()

            XCTAssertEqual(harness.presenter.presented.count, 1)
        }
    }
}
