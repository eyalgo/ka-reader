import AppKit
import Foundation
import Surfaces
import Testing

@testable import Shell

/// The open file across the bridge, through `LaunchFlow` and the real reading panel: a click is one
/// open act at the top-left, a scroll is one position act on the tree-act runner carrying the
/// encoded position, and each call frees its buffer (CP-1022 crossing; E4).

private let chosenFolder = URL(fileURLWithPath: "/Users/someone/notes", isDirectory: true)

private let rootAnswer = Data(
    (#"{"state":"observed","entries":["#
        + #"{"name":"a.txt","path":"a.txt","kind":"file","state":"observed","language":"plain"}]}"#)
        .utf8)

private let textAnswer = Data(#"{"state":"text","content":"one\ntwo\n","language":"plain"}"#.utf8)

@MainActor
private struct Launch {
    let flow: LaunchFlow
    let bridge: RecordingBridge
    let presenter: FakeWindowPresenter
    let treeActs: HoldingReadRunner
}

@MainActor
private func launch() -> Launch {
    createTheSharedApplication()
    let log = EventLog()
    let bridge = RecordingBridge(log: log)
    bridge.listAnswer = rootAnswer
    bridge.selectAnswers = ["a.txt": textAnswer]
    let presenter = FakeWindowPresenter()
    let treeActs = HoldingReadRunner()
    let flow = LaunchFlow(
        panel: FakePanel(answers: [chosenFolder], log: log), bridge: bridge,
        glyphs: FakeGlyphSource(), presenter: presenter, reader: InlineReadRunner(),
        treeActs: treeActs, terminate: {})
    flow.run()
    return Launch(flow: flow, bridge: bridge, presenter: presenter, treeActs: treeActs)
}

@MainActor
private func workbench(of launch: Launch) throws -> WorkbenchView {
    let view = try #require(launch.presenter.contents.last as? WorkbenchView)
    let window = NSWindow(
        contentRect: NSRect(x: 0, y: 0, width: 900, height: 500), styleMask: [.borderless],
        backing: .buffered, defer: true)
    window.contentView = view
    view.layoutSubtreeIfNeeded()
    return view
}

@MainActor
private func click(_ name: String, in workbench: WorkbenchView) throws {
    let tree = workbench.rootItemsView
    let row = try #require(
        (0..<tree.outlineView.numberOfRows).first { tree.entry(atRow: $0)?.name == name })
    tree.outlineView.selectRowIndexes(IndexSet(integer: row), byExtendingSelection: false)
}

@MainActor
@Suite struct LaunchFlowOpenFileTests {
    @Test func aClickRecordsOneSelectFileOpenCallWithTheTopLeftPositionAndFreesItsBuffer() throws {
        let launch = launch()
        let workbench = try workbench(of: launch)
        let before = launch.bridge.selectCalls.count

        try click("a.txt", in: workbench)

        let calls = Array(launch.bridge.selectCalls.dropFirst(before))
        #expect(
            calls == [
                SelectCall(
                    path: "a.txt", act: .open,
                    position: BridgePayload.encodePosition(.topLeft))
            ])
        #expect(Set(launch.bridge.freed) == Set(launch.bridge.handedOut))
        #expect(launch.bridge.freed.count == launch.bridge.handedOut.count)
        #expect(workbench.readingPanel.contentView.string == "one\ntwo\n")
    }

    @Test func aScrollRecordsOneSelectFilePositionCallOnTheTreeActRunnerWithTheEncodedPosition()
        throws
    {
        let launch = launch()
        let workbench = try workbench(of: launch)
        try click("a.txt", in: workbench)
        let calls = launch.bridge.selectCalls.count
        let held = launch.treeActs.heldReads
        let scrolled = ReadingPosition(topLine: 12, horizontalOffset: 30.5)

        workbench.filePosition?("a.txt", scrolled)

        #expect(launch.treeActs.heldReads == held + 1, "the act is queued on the tree-act runner")
        #expect(launch.bridge.selectCalls.count == calls, "and has not reached the bridge yet")
        launch.treeActs.release(held)
        #expect(
            Array(launch.bridge.selectCalls.dropFirst(calls))
                == [
                    SelectCall(
                        path: "a.txt", act: .position,
                        position: BridgePayload.encodePosition(scrolled))
                ])
        #expect(Set(launch.bridge.freed) == Set(launch.bridge.handedOut))
        #expect(
            launch.bridge.freed.count == launch.bridge.handedOut.count,
            "the position act's buffer is freed once")
    }
}
