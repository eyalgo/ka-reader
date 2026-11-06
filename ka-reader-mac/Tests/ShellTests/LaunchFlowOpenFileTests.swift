import AppKit
import Foundation
import Surfaces
import Testing

@testable import Shell
@testable import Surfaces

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
    let main: HeldMainDelivery
}

@MainActor
private func launch(selectAnswer: Data = textAnswer) -> Launch {
    createTheSharedApplication()
    let log = EventLog()
    let bridge = RecordingBridge(log: log)
    bridge.listAnswer = rootAnswer
    bridge.selectAnswers = ["a.txt": selectAnswer]
    let presenter = FakeWindowPresenter()
    let treeActs = HoldingReadRunner()
    let main = HeldMainDelivery()
    let flow = LaunchFlow(
        panel: FakePanel(answers: [chosenFolder, chosenFolder], log: log), bridge: bridge,
        glyphs: FakeGlyphSource(), presenter: presenter, reader: InlineReadRunner(),
        treeActs: treeActs, main: main, terminate: {})
    flow.run()
    return Launch(
        flow: flow, bridge: bridge, presenter: presenter, treeActs: treeActs, main: main)
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

/// The `model_changed` payload that carries only the open file.
private func openFilePayload(
    revision: UInt64, path: String = "a.txt", position: String, answer: String
) -> Data {
    Data(
        (#"{"listings":[],"open_file":{"revision":\#(revision),"path":"\#(path)","#
            + #""position":"\#(position)","answer":\#(answer)}}"#).utf8)
}

private let failedAnswer = Data(#"{"state":"failed","condition":"unreadable"}"#.utf8)

private func longText(_ lines: Int, tag: String = "") -> String {
    (0..<lines).map { "line \($0)\(tag)" }.joined(separator: "\n") + "\n"
}

private func jsonString(_ text: String) -> String {
    String(decoding: (try? JSONEncoder().encode(text)) ?? Data(), as: UTF8.self)
}

/// Hands `receiver` a buffer holding `payload`, from a background thread, as the bridge does.
private func push(_ payload: Data, through receiver: ModelChangesReceiver, handle: UInt) async {
    await withCheckedContinuation { done in
        DispatchQueue.global().async {
            receiver.take(BridgeBuffer(payload: payload, handle: handle))
            done.resume()
        }
    }
}

@MainActor
private func liveReceiver(of launch: Launch) throws -> ModelChangesReceiver {
    try #require(launch.bridge.receivers.last ?? nil)
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

    @Test func aPayloadPushedOnABackgroundThreadWithNewerTextAndThatPositionIsAppliedOnTheMainThread()
        async throws
    {
        let launch = launch(selectAnswer: failedAnswer)
        let workbench = try workbench(of: launch)
        try click("a.txt", in: workbench)
        let panel = workbench.readingPanel
        #expect(panel.contentView.string.isEmpty)
        let receiver = try liveReceiver(of: launch)
        let text = longText(200)
        let answer = #"{"state":"text","content":\#(jsonString(text)),"language":"plain"}"#

        await push(
            openFilePayload(revision: 1, position: "line=40;x=0", answer: answer),
            through: receiver, handle: 500)

        #expect(launch.main.scheduledFromMain == [false], "it crossed from a bridge thread")
        #expect(panel.contentView.string.isEmpty, "nothing is drawn until the main actor runs it")
        launch.main.releaseAll()
        #expect(panel.contentView.string == text)
        #expect(panel.currentPosition == ReadingPosition(topLine: 40, horizontalOffset: 0))
    }

    @Test func aDeliveryRecordsNoBridgeCall() async throws {
        let launch = launch()
        let workbench = try workbench(of: launch)
        try click("a.txt", in: workbench)
        let receiver = try liveReceiver(of: launch)
        // The receiver frees the buffer it was handed, which is the one call a delivery makes.
        let calls = { launch.bridge.log.events.filter { $0 != "free" } }
        let events = calls()
        let acts = launch.treeActs.heldReads

        await push(
            openFilePayload(
                revision: 1, position: "line=0;x=0",
                answer: #"{"state":"text","content":"new\n","language":"plain"}"#),
            through: receiver, handle: 501)
        launch.main.releaseAll()

        #expect(workbench.readingPanel.contentView.string == "new\n")
        #expect(calls() == events, "no call crossed because of the delivery")
        #expect(launch.treeActs.heldReads == acts, "and none was queued")
    }

    @Test func aMemberWithARevisionNotGreaterThanTheLastAppliedIsDroppedAndTheListingsBesideItApply()
        async throws
    {
        let launch = launch()
        let workbench = try workbench(of: launch)
        try click("a.txt", in: workbench)
        let receiver = try liveReceiver(of: launch)
        let tree = workbench.rootItemsView
        func text(_ body: String) -> String {
            #"{"state":"text","content":"\#(body)","language":"plain"}"#
        }

        await push(
            openFilePayload(revision: 5, position: "line=0;x=0", answer: text("five\\n")),
            through: receiver, handle: 502)
        launch.main.releaseAll()
        #expect(workbench.readingPanel.contentView.string == "five\n")

        let listing = #"{"state":"observed","entries":[]}"#
        let older = #"{"listings":[{"path":"","answer":\#(listing)}],"open_file":"#
            + #"{"revision":5,"path":"a.txt","position":"line=0;x=0","answer":\#(text("stale\\n"))}}"#
        await push(Data(older.utf8), through: receiver, handle: 503)
        launch.main.releaseAll()

        #expect(workbench.readingPanel.contentView.string == "five\n", "revision 5 is not newer")
        #expect(tree.outlineView.numberOfRows == 0, "the listings beside it still applied")

        await push(
            openFilePayload(revision: 6, position: "line=0;x=0", answer: text("six\\n")),
            through: receiver, handle: 504)
        launch.main.releaseAll()
        #expect(workbench.readingPanel.contentView.string == "six\n")
    }

    @Test func aReplacedReceiversOpenFilePayloadIsDroppedAndEveryPayloadIsFreedOnce() async throws {
        let launch = launch()
        let first = try liveReceiver(of: launch)
        launch.flow.run()
        let second = try liveReceiver(of: launch)
        #expect(first !== second)
        let workbench = try workbench(of: launch)
        try click("a.txt", in: workbench)
        let before = launch.bridge.freed.count
        let fresh = #"{"state":"text","content":"fresh\n","language":"plain"}"#
        let stale = #"{"state":"text","content":"stale\n","language":"plain"}"#

        await push(
            openFilePayload(revision: 1, position: "line=0;x=0", answer: stale),
            through: first, handle: 505)
        launch.main.releaseAll()
        #expect(workbench.readingPanel.contentView.string == "one\ntwo\n", "the stale one drew nothing")

        await push(
            openFilePayload(revision: 1, position: "line=0;x=0", answer: fresh),
            through: second, handle: 506)
        launch.main.releaseAll()

        #expect(workbench.readingPanel.contentView.string == "fresh\n")
        #expect(Array(launch.bridge.freed.dropFirst(before)).sorted() == [505, 506])
    }
}
