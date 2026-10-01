import AppKit
import Shell
import Surfaces
import XCTest

/// A file clicked in the tree, through `LaunchFlow` into the product's window: the bridge call, the
/// buffer's release and what the reading panel shows (CP-267 – CP-287).
@MainActor
final class LaunchFlowSelectionTests: LaunchWindowTestCase {
    private static let chosenFolder = URL(
        fileURLWithPath: "/Users/someone/notes", isDirectory: true)

    private static let rootAnswer = Data(
        (#"{"state":"observed","entries":["#
            + #"{"name":"src","path":"src","kind":"folder","state":"pending"},"#
            + #"{"name":"a.txt","path":"a.txt","kind":"file","state":"observed","language":"plain"},"#
            + #"{"name":"b.txt","path":"b.txt","kind":"file","state":"observed","language":"plain"},"#
            + #"{"name":"ln","path":"ln","kind":"file","state":"failed","condition":"missing","language":"plain"}]}"#)
            .utf8)

    private static let srcAnswer = Data(
        (#"{"state":"observed","entries":["#
            + #"{"name":"lib.rs","path":"src/lib.rs","kind":"file","state":"observed","language":"plain"}]}"#)
            .utf8)

    private func text(_ content: String) -> Data {
        let escaped = content.replacingOccurrences(of: "\n", with: "\\n")
        return Data(#"{"state":"text","content":"\#(escaped)","language":"plain"}"#.utf8)
    }

    /// A launch with the folder chosen and run. With a `reader` that holds reads, the workbench is
    /// not presented until the test releases the open's read.
    private func launch(reader: ReadRunning? = nil) -> WindowLaunch {
        let launch = makeLaunch(answers: [Self.chosenFolder], reader: reader)
        launch.bridge.listAnswer = Self.rootAnswer
        launch.bridge.listAnswers = ["src": Self.srcAnswer]
        launch.flow.run()
        return launch
    }

    private func workbench(of launch: WindowLaunch) throws -> WorkbenchView {
        let view = try XCTUnwrap(launch.presenter.contents.last as? WorkbenchView)
        layOut(try laidOutWindow(of: view))
        return view
    }

    private func click(_ name: String, in workbench: WorkbenchView) throws {
        let tree = workbench.rootItemsView
        let row = try XCTUnwrap(
            (0..<tree.outlineView.numberOfRows).first { tree.entry(atRow: $0)?.name == name },
            "no row named \(name)")
        tree.outlineView.selectRowIndexes(IndexSet(integer: row), byExtendingSelection: false)
    }

    private func shownPath(_ workbench: WorkbenchView) -> String? {
        let line = workbench.readingPanel.pathLine
        return line.isHiddenOrHasHiddenAncestor ? nil : line.stringValue
    }

    func testClickingAFileRowCallsTheBridgeOnceFreesItsBufferAndShowsTheFile() throws {
        let launch = launch()
        let workbench = try workbench(of: launch)
        launch.bridge.selectAnswers = ["src/lib.rs": text("fn main() {}\n")]
        let tree = workbench.rootItemsView
        let src = try XCTUnwrap(
            (0..<tree.outlineView.numberOfRows).first { tree.entry(atRow: $0)?.name == "src" })
        tree.outlineView.expandItem(tree.outlineView.item(atRow: src))

        try click("lib.rs", in: workbench)

        XCTAssertEqual(launch.bridge.selectedPaths, ["src/lib.rs"])
        XCTAssertEqual(
            Set(launch.bridge.freed), Set(launch.bridge.handedOut), "every buffer is released")
        XCTAssertEqual(launch.bridge.freed.count, launch.bridge.handedOut.count)
        XCTAssertEqual(shownPath(workbench), "src/lib.rs")
        XCTAssertEqual(workbench.readingPanel.contentView.string, "fn main() {}\n")
    }

    func testALinkRowThatFailedOnListingStillCallsTheBridge() throws {
        let launch = launch()
        let workbench = try workbench(of: launch)
        launch.bridge.selectAnswers = [
            "ln": Data(#"{"state":"failed","condition":"missing"}"#.utf8)
        ]

        try click("ln", in: workbench)

        XCTAssertEqual(launch.bridge.selectedPaths, ["ln"])
        XCTAssertEqual(shownPath(workbench), "ln")
        XCTAssertTrue(
            visibleStrings(beneath: workbench.readingPanel).contains {
                $0.contains("ln") && $0 != "ln"
            },
            "the bridge's failed answer draws a statement naming the file")
    }

    func testTwoSelectionsReleasedInReverseOrderEndOnTheSecond() throws {
        let holding = HoldingReadRunner()
        let launch = launch(reader: holding)
        holding.release(0)
        let workbench = try workbench(of: launch)
        launch.bridge.selectAnswers = ["a.txt": text("from a"), "b.txt": text("from b")]

        try click("a.txt", in: workbench)
        try click("b.txt", in: workbench)
        XCTAssertEqual(holding.heldReads, 3, "the open and two file reads are held")
        holding.release(2)
        holding.release(1)

        XCTAssertEqual(shownPath(workbench), "b.txt")
        XCTAssertEqual(workbench.readingPanel.contentView.string, "from b")
    }

    func testANullBufferDrawsTheFaultAndKeepsTheBar() throws {
        let launch = launch()
        let workbench = try workbench(of: launch)
        launch.bridge.selectAnswers = ["a.txt": text("shown")]
        // A NULL buffer: the bridge's failure value for this path.
        launch.bridge.selectAnswers.updateValue(nil, forKey: "b.txt")
        try click("a.txt", in: workbench)
        XCTAssertEqual(workbench.rootItemsView.barPaths(), ["a.txt"])

        try click("b.txt", in: workbench)

        XCTAssertEqual(shownPath(workbench), "b.txt")
        XCTAssertEqual(
            visibleStrings(beneath: workbench.readingPanel),
            [
                "b.txt",
                "Nozoki stopped while reading this file and can't tell why. "
                    + "The rest of the folder is still readable — select another file.",
            ])
        XCTAssertEqual(workbench.rootItemsView.barPaths(), ["b.txt"])
    }

    func testClickingAFileShowsPendingAcrossARealAsynchronousDelivery() throws {
        let holding = HoldingReadRunner()
        let launch = launch(reader: holding)
        holding.release(0)
        let workbench = try workbench(of: launch)
        launch.bridge.selectAnswers = ["a.txt": text("from a")]

        try click("a.txt", in: workbench)

        XCTAssertEqual(holding.heldReads, 2, "the open and the file read are held")
        XCTAssertEqual(
            visibleStrings(beneath: workbench.readingPanel), ["Reading this file."])
        holding.release(1)
        XCTAssertEqual(shownPath(workbench), "a.txt")
        XCTAssertEqual(workbench.readingPanel.contentView.string, "from a")
    }

    func testShowingAMultiLineFileLeavesTheWindowContentSizeUnchanged() throws {
        let launch = launch()
        let workbench = try workbench(of: launch)
        let window = try laidOutWindow(of: workbench)
        let before = contentArea(of: window).size
        let frameBefore = window.frame.size
        let longFile = (1...3000).map { "line \($0) " + String(repeating: "x", count: 200) }
            .joined(separator: "\n")
        launch.bridge.selectAnswers = ["a.txt": text(longFile)]

        try click("a.txt", in: workbench)
        layOut(window)

        XCTAssertEqual(workbench.readingPanel.contentView.string, longFile)
        XCTAssertEqual(contentArea(of: window).size, before)
        XCTAssertEqual(window.frame.size, frameBefore)
    }

    private func visibleStrings(beneath view: NSView) -> [String] {
        textElements(beneath: view).map(\.stringValue)
    }
}
