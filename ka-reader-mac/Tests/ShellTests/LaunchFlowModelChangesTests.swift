import AppKit
import XCTest

@testable import Shell
@testable import Surfaces

/// Runs each read at once and holds its delivery, so the bridge has been called (and a receiver
/// exists) while the launch has not yet presented what the read found.
@MainActor
private final class ReadNowDeliverLater: ReadRunning {
    private var held: [@MainActor () -> Void] = []

    func run<Answer: Sendable>(
        _ read: @escaping @Sendable () -> Answer,
        deliver: @escaping @MainActor @Sendable (Answer) -> Void
    ) {
        let answer = read()
        held.append { deliver(answer) }
    }

    func releaseAll() {
        let all = held
        held = []
        for piece in all { piece() }
    }
}

/// Counts the runs it is handed and passes them on to a real runner.
@MainActor
private final class CountingReadRunner: ReadRunning {
    private let inner: ReadRunning
    private(set) var runs = 0

    init(_ inner: ReadRunning) {
        self.inner = inner
    }

    func run<Answer: Sendable>(
        _ read: @escaping @Sendable () -> Answer,
        deliver: @escaping @MainActor @Sendable (Answer) -> Void
    ) {
        runs += 1
        inner.run(read, deliver: deliver)
    }
}

/// A folder's tree follows the model through `LaunchFlow`: a receiver for each open, deliveries
/// held until the workbench is presented and applied in order, a replaced receiver's dropped, and the
/// tree acts reaching the model in the order the reader made them (E7, E8 shell half).
@MainActor
final class LaunchFlowModelChangesTests: XCTestCase {
    private let firstFolder = URL(fileURLWithPath: "/Users/someone/one", isDirectory: true)
    private let secondFolder = URL(fileURLWithPath: "/Users/someone/two", isDirectory: true)

    private func entry(_ name: String, path: String? = nil, folder: Bool = false) -> String {
        let kind = folder ? "folder" : "file"
        let state = folder ? "pending" : "observed"
        let language = folder ? "" : #","language":"plain""#
        return
            #"{"name":"\#(name)","path":"\#(path ?? name)","kind":"\#(kind)","state":"\#(state)"\#(language)}"#
    }

    private func listing(_ entries: [String]) -> Data {
        Data((#"{"state":"observed","entries":["# + entries.joined(separator: ",") + "]}").utf8)
    }

    /// The `model_changed` payload that gives the root `entries`.
    private func rootChange(_ entries: [String]) -> Data {
        let answer = String(decoding: listing(entries), as: UTF8.self)
        return Data(#"{"listings":[{"path":"","answer":\#(answer)}]}"#.utf8)
    }

    private struct Launch {
        let flow: LaunchFlow
        let bridge: RecordingBridge
        let presenter: FakeWindowPresenter
        let main: HeldMainDelivery
    }

    private func launch(
        answers: [URL?], reader: ReadRunning? = nil, treeActs: ReadRunning? = nil,
        root: [String] = []
    ) -> Launch {
        let log = EventLog()
        let bridge = RecordingBridge(log: log)
        bridge.listAnswer = listing(root)
        let presenter = FakeWindowPresenter()
        let main = HeldMainDelivery()
        let flow = LaunchFlow(
            panel: FakePanel(answers: answers, log: log), bridge: bridge, glyphs: FakeGlyphSource(),
            presenter: presenter, reader: reader ?? InlineReadRunner(), treeActs: treeActs,
            main: main, terminate: {})
        return Launch(flow: flow, bridge: bridge, presenter: presenter, main: main)
    }

    private func tree(of launch: Launch) throws -> RootItemsView {
        let workbench = try XCTUnwrap(launch.presenter.contents.last as? WorkbenchView)
        return workbench.rootItemsView
    }

    private func labels(_ view: RootItemsView) -> [String] {
        (0..<view.outlineView.numberOfRows).map { view.entry(atRow: $0)?.path ?? "?" }
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

    func testAPayloadPushedOnABackgroundThreadIsAppliedOnTheMainThread() async throws {
        let launch = launch(answers: [firstFolder], root: [entry("a.txt")])
        launch.flow.run()
        let view = try tree(of: launch)
        let receiver = try XCTUnwrap(launch.bridge.receivers.last ?? nil)

        await push(rootChange([entry("a.txt"), entry("b.txt")]), through: receiver, handle: 90)

        XCTAssertEqual(launch.main.scheduledFromMain, [false], "it crossed from a bridge thread")
        XCTAssertEqual(labels(view), ["a.txt"], "nothing is drawn until the main actor runs it")
        launch.main.releaseAll()
        XCTAssertEqual(labels(view), ["a.txt", "b.txt"])
    }

    func testAPayloadThatArrivesBeforeTheWorkbenchIsPresentedIsAppliedAfterItInOrder() async throws
    {
        let runner = ReadNowDeliverLater()
        let launch = launch(answers: [firstFolder], reader: runner, root: [entry("x.txt")])
        launch.flow.run()
        let receiver = try XCTUnwrap(launch.bridge.receivers.last ?? nil)

        await push(rootChange([entry("x.txt")]), through: receiver, handle: 91)
        await push(rootChange([entry("x.txt"), entry("y.txt")]), through: receiver, handle: 92)
        launch.main.releaseAll()

        XCTAssertFalse(launch.presenter.contents.contains { $0 is WorkbenchView })
        runner.releaseAll()

        XCTAssertEqual(labels(try tree(of: launch)), ["x.txt", "y.txt"], "applied in order")
    }

    func testAReplacedReceiversPayloadIsDropped() async throws {
        let launch = launch(answers: [firstFolder, secondFolder], root: [entry("a.txt")])
        launch.flow.run()
        let first = try XCTUnwrap(launch.bridge.receivers.last ?? nil)
        launch.flow.run()
        let second = try XCTUnwrap(launch.bridge.receivers.last ?? nil)
        let view = try tree(of: launch)

        await push(rootChange([entry("stale.txt")]), through: first, handle: 93)
        launch.main.releaseAll()

        XCTAssertEqual(labels(view), ["a.txt"], "the replaced receiver's payload drew nothing")

        await push(rootChange([entry("a.txt"), entry("live.txt")]), through: second, handle: 94)
        launch.main.releaseAll()

        XCTAssertEqual(labels(view), ["a.txt", "live.txt"])
    }

    func testTheReplacedReceiverStaysAliveUntilTheReplacingOpenReturnsOpenedAndIsReleasedAfter()
        throws
    {
        let runner = ReadNowDeliverLater()
        let launch = launch(answers: [firstFolder, secondFolder], reader: runner)
        launch.flow.run()
        runner.releaseAll()
        weak let first = try XCTUnwrap(launch.bridge.receivers.last ?? nil)

        launch.flow.run()

        XCTAssertNotNil(first, "the open that replaces it has not returned")
        runner.releaseAll()
        XCTAssertNil(first, "released once the replacing open returned opened")
        XCTAssertEqual(launch.bridge.receivers.count, 2)
    }

    func testAFailedOrStoppedOpenLeavesTheEarlierReceiverAsTheBridgesOne() throws {
        for failure in [
            Data(#"{"state":"failed","condition":"missing"}"#.utf8), nil,
        ] {
            let runner = ReadNowDeliverLater()
            let launch = launch(answers: [firstFolder, secondFolder], reader: runner)
            launch.flow.run()
            runner.releaseAll()
            weak let earlier = try XCTUnwrap(launch.bridge.receivers.last ?? nil)
            launch.bridge.openAnswers = [failure]

            launch.flow.run()
            runner.releaseAll()

            XCTAssertNotNil(earlier, "the bridge still calls it, so the flow still holds it")
            XCTAssertEqual(launch.bridge.receivers.count, 2)
            XCTAssertNil(launch.bridge.receivers.last ?? nil, "the failed open's own is let go")
        }
    }

    func testEachPayloadIsFreedOnceThroughFree() async throws {
        let launch = launch(answers: [firstFolder], root: [entry("a.txt")])
        launch.flow.run()
        let receiver = try XCTUnwrap(launch.bridge.receivers.last ?? nil)
        let before = launch.bridge.freed.count

        for handle in [101, 102, 103] as [UInt] {
            await push(rootChange([entry("a.txt")]), through: receiver, handle: handle)
        }
        launch.main.releaseAll()

        let freed = Array(launch.bridge.freed.dropFirst(before))
        XCTAssertEqual(freed.sorted(), [101, 102, 103])
    }

    func testExpandingNestedCollapsingTheParentAndClickingTwoFilesReachesTheModelInOrder()
        async throws
    {
        let acts = CountingReadRunner(InlineReadRunner())
        let launch = launch(
            answers: [firstFolder], treeActs: acts,
            root: [entry("src", folder: true), entry("a.txt"), entry("b.txt")])
        launch.bridge.listAnswers = [
            "src": listing([entry("nested", path: "src/nested", folder: true)]),
            "src/nested": listing([entry("deep.rs", path: "src/nested/deep.rs")]),
        ]
        launch.flow.run()
        let workbench = try XCTUnwrap(launch.presenter.contents.last as? WorkbenchView)
        let view = workbench.rootItemsView
        let outline = view.outlineView
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 900, height: 600), styleMask: [.borderless],
            backing: .buffered, defer: true)
        window.contentView = workbench
        window.layoutIfNeeded()

        outline.expandItem(outline.item(atRow: 0))
        outline.expandItem(outline.item(atRow: 1))
        outline.collapseItem(outline.item(atRow: 0))
        let rowOf: (String) -> Int? = { name in
            (0..<outline.numberOfRows).first { view.entry(atRow: $0)?.name == name }
        }
        for name in ["a.txt", "b.txt"] {
            let row = try XCTUnwrap(rowOf(name))
            outline.selectRowIndexes(IndexSet(integer: row), byExtendingSelection: false)
        }

        XCTAssertEqual(launch.bridge.listedPaths, ["", "src", "src/nested", "src"])
        XCTAssertEqual(launch.bridge.listedActs, [.expand, .expand, .expand, .collapse])
        XCTAssertEqual(
            acts.runs, 5,
            "the three tree acts and the two select acts rode the tree runner, in order")
        XCTAssertEqual(
            launch.bridge.selectedPaths, ["a.txt", "a.txt", "b.txt", "b.txt"],
            "the select act, then one open, for each click")
        XCTAssertEqual(
            Set(launch.bridge.freed), Set(launch.bridge.handedOut), "every buffer was freed")

        let receiver = try XCTUnwrap(launch.bridge.receivers.last ?? nil)
        await push(
            rootChange([entry("src", folder: true), entry("a.txt"), entry("b.txt"), entry("c.txt")]
            ),
            through: receiver, handle: 200)
        launch.main.releaseAll()

        XCTAssertEqual(labels(view), ["src", "a.txt", "b.txt", "c.txt"], "src stays collapsed")
    }
}
