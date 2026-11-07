import AppKit
import Foundation
import Surfaces
import Testing

@testable import Shell
@testable import Surfaces

/// A Markdown answer across the bridge, through `LaunchFlow` and the real workbench (CP-1102,
/// CP-1103, CP-1116, CP-1118, CP-1119 at the shell): a click draws the path line and the page, a
/// resolved image asks `asset_bytes` on the reader runner and a placeholder asks nothing, a
/// `model_changed` payload updates the tree and the page from one delivery, a table refuses the
/// answer, and a link is one `open_relative_link` call on the tree-act runner.

private let chosenFolder = URL(fileURLWithPath: "/Users/someone/notes", isDirectory: true)

private func rootAnswer(extra: String = "") -> Data {
    Data(
        (#"{"state":"observed","entries":["#
            + #"{"name":"README.md","path":"README.md","kind":"file","state":"observed","language":"plain"},"#
            + extra
            + #"{"name":"a.txt","path":"a.txt","kind":"file","state":"observed","language":"plain"}]}"#)
            .utf8)
}

private func markdownAnswer(_ blocks: String) -> Data {
    Data(#"{"state":"markdown","blocks":[\#(blocks)]}"#.utf8)
}

private func headingJSON(_ title: String) -> String {
    #"{"kind":"heading","level":1,"content":[{"kind":"text","text":"\#(title)"}]}"#
}

private let imagesJSON =
    #"{"kind":"paragraph","content":["#
    + #"{"kind":"image","alt":"logo","target":"resolved","path":"logo.png"},"#
    + #"{"kind":"image","alt":"remote","target":"placeholder","condition":"outside_the_folder","source":"https://example.com/x.png"}]}"#

private let linkJSON =
    #"{"kind":"paragraph","content":[{"kind":"link","content":[{"kind":"text","text":"guide"}],"#
    + #""destination":"docs/guide.md","target":"relative","path":"docs/guide.md"}]}"#

@MainActor
private struct Launch {
    let flow: LaunchFlow
    let bridge: RecordingBridge
    let presenter: FakeWindowPresenter
    let treeActs: HoldingReadRunner
    let reader: HoldingReadRunner
    let main: HeldMainDelivery
}

@MainActor
private func launch(readme: Data, holding: Bool = false, readerHeld: Bool = false) -> Launch {
    createTheSharedApplication()
    let log = EventLog()
    let bridge = RecordingBridge(log: log)
    bridge.listAnswer = rootAnswer()
    bridge.selectAnswers = [
        "README.md": readme,
        "a.txt": Data(#"{"state":"text","content":"a\n","language":"plain"}"#.utf8),
    ]
    let presenter = FakeWindowPresenter()
    let treeActs = HoldingReadRunner()
    let reader = HoldingReadRunner()
    let main = HeldMainDelivery()
    let flow = LaunchFlow(
        panel: FakePanel(answers: [chosenFolder], log: log), bridge: bridge,
        glyphs: FakeGlyphSource(), presenter: presenter,
        reader: readerHeld ? reader : InlineReadRunner(),
        treeActs: holding ? treeActs : InlineReadRunner(), main: main, terminate: {})
    flow.run()
    return Launch(
        flow: flow, bridge: bridge, presenter: presenter, treeActs: treeActs, reader: reader,
        main: main)
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

private let zeta =
    #"{"name":"zeta.txt","path":"zeta.txt","kind":"file","state":"observed","language":"plain"},"#

private func listingJSON(extra: String) -> String {
    #"{"path":"","answer":\#(String(decoding: rootAnswer(extra: extra), as: UTF8.self))}"#
}

private func openFilePayload(revision: UInt64, listing: String, answer: Data) -> Data {
    Data(
        (#"{"listings":[\#(listing)],"open_file":{"revision":\#(revision),"path":"README.md","#
            + #""position":"line=0;x=0","answer":\#(String(decoding: answer, as: UTF8.self))}}"#)
            .utf8)
}

private func push(_ payload: Data, through receiver: ModelChangesReceiver, handle: UInt) async {
    await withCheckedContinuation { done in
        DispatchQueue.global().async {
            receiver.take(BridgeBuffer(payload: payload, handle: handle))
            done.resume()
        }
    }
}

@MainActor
private func pageText(_ workbench: WorkbenchView) -> String {
    workbench.readingPanel.markdownPage.textView.string
}

@MainActor
@Suite struct LaunchFlowMarkdownTests {
    @Test func aTreeClickOnReadmeAnsweringAMarkdownVerdictDrawsThePathLineAndThePage() throws {
        let launch = launch(readme: markdownAnswer(headingJSON("Title")))
        let workbench = try workbench(of: launch)

        try click("README.md", in: workbench)

        #expect(workbench.readingPanel.pathLine.stringValue == "README.md")
        #expect(!workbench.readingPanel.markdownPage.isHiddenOrHasHiddenAncestor)
        #expect(pageText(workbench) == "Title")
    }

    @Test
    func aResolvedImageAsksAssetBytesForItsPathOnTheReaderRunnerAndAPlaceholderAsksNothing() throws
    {
        let launch = launch(readme: markdownAnswer(imagesJSON), readerHeld: true)
        // The folder open is the reader runner's first read.
        launch.reader.release(0)
        let workbench = try workbench(of: launch)
        let held = launch.reader.heldReads

        try click("README.md", in: workbench)
        launch.reader.release(held)

        #expect(
            launch.reader.heldReads == held + 2, "the open, then one ask for the resolved image")
        #expect(launch.bridge.assetPaths.isEmpty, "the ask is held on the reader runner")

        launch.bridge.assetAnswers = ["logo.png": Data()]
        launch.reader.release(held + 1)

        #expect(launch.bridge.assetPaths == ["logo.png"])
    }

    @Test
    func aModelChangedPayloadWithAListingAndANewHeadingUpdatesTheTreeAndThePageFromOneDelivery()
        async throws
    {
        let launch = launch(readme: markdownAnswer(headingJSON("Old")))
        let workbench = try workbench(of: launch)
        try click("README.md", in: workbench)
        let receiver = try #require(launch.bridge.receivers.last ?? nil)
        let listing =
            listingJSON(extra: zeta)

        await push(
            openFilePayload(
                revision: 1, listing: listing, answer: markdownAnswer(headingJSON("New"))),
            through: receiver, handle: 700)
        launch.main.releaseAll()

        let tree = workbench.rootItemsView
        let names = (0..<tree.outlineView.numberOfRows).compactMap { tree.entry(atRow: $0)?.name }
        #expect(names.contains("zeta.txt"))
        #expect(pageText(workbench) == "New")
    }

    @Test func aModelChangedPayloadWithTheDocumentUnchangedAppliesTheListingAndLeavesThePage()
        async throws
    {
        let launch = launch(readme: markdownAnswer(headingJSON("Same")))
        let workbench = try workbench(of: launch)
        try click("README.md", in: workbench)
        let receiver = try #require(launch.bridge.receivers.last ?? nil)
        let listing =
            listingJSON(extra: zeta)
        workbench.readingPanel.markdownPage.scrollOffset = 0

        await push(
            openFilePayload(
                revision: 1, listing: listing, answer: markdownAnswer(headingJSON("Same"))),
            through: receiver, handle: 701)
        launch.main.releaseAll()

        let tree = workbench.rootItemsView
        let names = (0..<tree.outlineView.numberOfRows).compactMap { tree.entry(atRow: $0)?.name }
        #expect(names.contains("zeta.txt"))
        #expect(pageText(workbench) == "Same")
    }

    @Test func aMarkdownAnswerHoldingATableDrawsStopped() throws {
        let launch = launch(readme: markdownAnswer(#"{"kind":"table","rows":[]}"#))
        let workbench = try workbench(of: launch)

        try click("README.md", in: workbench)

        let panel = workbench.readingPanel
        panel.layoutSubtreeIfNeeded()
        let strings = panel.allShellDescendants.compactMap { ($0 as? NSTextField)?.stringValue }
        #expect(panel.pathLine.stringValue == "README.md")
        #expect(strings.contains { $0.hasPrefix("KA-Reader stopped while reading this file") })
        #expect(panel.markdownPage.isHiddenOrHasHiddenAncestor)
    }

    @Test func aLinkActivationCallsOpenRelativeLinkOnTheTreeActRunnerInOrderWithAClicksSelectAct()
        throws
    {
        let launch = launch(readme: markdownAnswer(linkJSON), holding: true)
        let workbench = try workbench(of: launch)
        let start = launch.treeActs.heldReads
        try click("README.md", in: workbench)
        launch.treeActs.release(start)
        #expect(pageText(workbench).contains("guide"))

        workbench.readingPanel.relativeLinkActivated?("docs/guide.md")
        try click("a.txt", in: workbench)

        #expect(launch.bridge.linkPaths.isEmpty, "the call waits on the tree-act runner")
        launch.treeActs.release(start + 1)
        launch.treeActs.release(start + 2)
        let events = launch.bridge.log.events.filter {
            $0 == "open_relative_link" || $0 == "select_file"
        }
        let afterLink = events.drop { $0 != "open_relative_link" }.dropFirst()
        #expect(launch.bridge.linkPaths == ["docs/guide.md"])
        #expect(
            afterLink.contains("select_file"),
            "the link was raised before the click, so its call goes first")
    }

    @Test func anAssetBytesRefusalBufferDrawsTheUnreadableBox() throws {
        let launch = launch(readme: markdownAnswer(imagesJSON))
        launch.bridge.assetRefusals = ["logo.png"]
        let workbench = try workbench(of: launch)

        try click("README.md", in: workbench)

        let text = pageText(workbench)
        #expect(launch.bridge.assetPaths == ["logo.png"])
        #expect(text.contains("KA-Reader can't read this image."))
        #expect(text.contains("This image is outside the folder you opened"))
        #expect(launch.bridge.freed.count == launch.bridge.handedOut.count)
    }
}

extension NSView {
    fileprivate var allShellDescendants: [NSView] {
        subviews + subviews.flatMap(\.allShellDescendants)
    }
}
