import AppKit
import Shell
import Surfaces
import XCTest

/// The launch window around the workbench: what the window keeps whatever it is handed, and what
/// the workbench draws in it. Every test presents through the product's own presenter and reads
/// the laid-out window (change_spec.md CP-246).
@MainActor
final class LaunchWindowWorkbenchTests: LaunchWindowTestCase {
    /// A view whose own layout asks for a height: a label pinned to its top and its bottom, so the
    /// view is as tall as one line of text unless something holds it taller.
    private func makeViewAskingForItsOwnHeight() -> NSView {
        let view = NSView()
        let label = NSTextField(labelWithString: "A surface that is one line tall.")
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: view.topAnchor),
            label.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor),
        ])
        return view
    }

    // W7 — CP-236 for a surface that is neither of the product's two.
    func testAViewThatAsksForItsOwnHeightDoesNotResizeTheWindow() throws {
        let presenter = MainWindowPresenter()
        let startup = StartupView(projection: .empty, onIntent: { _ in })
        let window = try present(startup, through: presenter)
        XCTAssertEqual(contentArea(of: window).size, openingContentSize)

        let asking = makeViewAskingForItsOwnHeight()
        let windowAfter = try present(asking, through: presenter)

        XCTAssertTrue(windowAfter === window, "the second view is presented in the same window")
        XCTAssertEqual(contentArea(of: windowAfter).size, openingContentSize)
    }

    func testTheFirstViewThatAsksForItsOwnHeightDoesNotResizeTheWindow() throws {
        let window = try present(makeViewAskingForItsOwnHeight())

        XCTAssertEqual(contentArea(of: window).size, openingContentSize)
    }

    func testThePreviousSurfaceLeavesTheWindowWhenTheNextArrives() throws {
        let presenter = MainWindowPresenter()
        let first = NSView()
        let window = try present(first, through: presenter)

        let second = NSView()
        let windowAfter = try present(second, through: presenter)

        XCTAssertTrue(windowAfter === window)
        XCTAssertNil(first.window, "the replaced surface is in no window")
        XCTAssertNil(first.superview, "the replaced surface is beneath no view")
    }

    func testASurfaceThatAsksForNoSizeIsGivenTheWholeContentArea() throws {
        let presenter = MainWindowPresenter()
        let first = NSView()
        let window = try present(first, through: presenter)
        XCTAssertEqual(frameInWindow(of: first), contentArea(of: window))

        let second = NSView()
        _ = try present(second, through: presenter)

        XCTAssertEqual(frameInWindow(of: second), contentArea(of: window))
    }

    // MARK: - One surface replacing another through a launch (CP-236)

    private static let browseTitle = "Browse…"
    private static let chosenFolder = URL(
        fileURLWithPath: "/Users/someone/notes", isDirectory: true)

    private static let twoEntryRootAnswer = Data(
        (#"{"state":"observed","entries":["#
            + #"{"name":"src","path":"src","kind":"folder","state":"pending"},"#
            + #"{"name":"a.txt","path":"a.txt","kind":"file","state":"observed"}]}"#).utf8)

    private static let missingFolderAnswer = Data(
        #"{"state":"failed","condition":"missing"}"#.utf8)

    // W5 — Example 5 (CP-236; CP-247's "presented over a startup surface").
    func testTheWindowKeepsItsSizeWhenTheWorkbenchReplacesAStartupSurface() throws {
        let launch = makeLaunch(answers: [nil, Self.chosenFolder])
        launch.bridge.listAnswer = Self.twoEntryRootAnswer
        launch.flow.run()
        let startup = try XCTUnwrap(launch.presenter.contents.last as? StartupView)
        let window = try laidOutWindow(of: startup)
        XCTAssertEqual(contentArea(of: window).size, openingContentSize)

        click(try control(titled: Self.browseTitle, beneath: startup))

        let workbench = try XCTUnwrap(
            launch.presenter.contents.last as? WorkbenchView,
            "a readable folder opens the workbench")
        let windowAfter = try laidOutWindow(of: workbench)
        XCTAssertTrue(windowAfter === window, "the workbench is presented in the same window")
        XCTAssertEqual(contentArea(of: windowAfter).size, openingContentSize)
        XCTAssertNil(startup.window, "the startup surface it replaced is in no window")
        assertDrawnWhole(
            try textElement(saying: "src", beneath: workbench.rootItemsView), in: windowAfter)
    }

    // W6 — CP-236's third clause.
    func testTheWindowKeepsItsSizeWhenOneStartupSurfaceReplacesAnother() throws {
        let launch = makeLaunch(answers: [Self.chosenFolder, nil])
        launch.bridge.openAnswer = Self.missingFolderAnswer
        launch.flow.run()
        let failed = try XCTUnwrap(launch.presenter.contents.last as? StartupView)
        let window = try laidOutWindow(of: failed)
        let sizeBefore = contentArea(of: window).size
        XCTAssertEqual(sizeBefore, openingContentSize)

        click(try control(titled: Self.browseTitle, beneath: failed))

        let dismissed = try XCTUnwrap(launch.presenter.contents.last as? StartupView)
        XCTAssertFalse(dismissed === failed, "the dismissed panel presents another surface")
        let windowAfter = try laidOutWindow(of: dismissed)
        XCTAssertTrue(windowAfter === window, "the next surface is presented in the same window")
        XCTAssertEqual(contentArea(of: windowAfter).size, sizeBefore)
        XCTAssertNil(failed.window, "the startup surface it replaced is in no window")
    }

    // MARK: - The workbench's two panels (CP-237, CP-238, CP-239)

    private static let readingPrompt = "Select a file to view."
    private static let frameTolerance: CGFloat = 0.5

    /// The workbench's two panels and the prompt, each found from the drawn view tree: a panel is
    /// the workbench's direct subview that holds the element (change_design.md § 3, *Exposes*).
    private struct DrawnWorkbench {
        let sidebar: NSView
        let readingPanel: NSView
        let prompt: NSTextField
    }

    private func makeWorkbench(showing root: RootListing?) -> WorkbenchView {
        let tree = RootItemsView(folderGlyph: NSImage(), fileGlyph: NSImage())
        tree.show(root)
        return WorkbenchView(rootItemsView: tree)
    }

    private var twoEntryRoot: RootListing {
        .observed([
            Entry(name: "src", path: "src", kind: .folder, state: .pending),
            Entry(name: "a.txt", path: "a.txt", kind: .file, state: .observed),
        ])
    }

    private func drawn(_ workbench: WorkbenchView) throws -> DrawnWorkbench {
        let prompt = try XCTUnwrap(
            textElements(beneath: workbench).first { $0.stringValue == Self.readingPrompt },
            "the workbench draws no “\(Self.readingPrompt)”")
        return DrawnWorkbench(
            sidebar: try XCTUnwrap(
                ShellTests.panel(of: workbench, containing: workbench.rootItemsView.outlineView)),
            readingPanel: try XCTUnwrap(ShellTests.panel(of: workbench, containing: prompt)),
            prompt: prompt)
    }

    private func textElement(
        saying text: String, beneath root: NSView, file: StaticString = #filePath,
        line: UInt = #line
    ) throws -> NSTextField {
        try XCTUnwrap(
            textElements(beneath: root).first { $0.stringValue == text },
            "no text element says “\(text)”", file: file, line: line)
    }

    private func isInside(_ inner: NSRect, _ outer: NSRect) -> Bool {
        outer.insetBy(dx: -Self.frameTolerance, dy: -Self.frameTolerance).contains(inner)
    }

    /// CP-238 and CP-239 in one place, since W2, W3 and W4 each assert the same reading panel.
    private func assertReadingPanelStandsBesideTheSidebarAndDrawsOnlyThePrompt(
        _ workbench: WorkbenchView, in window: NSWindow, file: StaticString = #filePath,
        line: UInt = #line
    ) throws {
        let panels = try drawn(workbench)
        let area = contentArea(of: window)
        let sidebarFrame = frameInWindow(of: panels.sidebar)
        let readingFrame = frameInWindow(of: panels.readingPanel)
        let promptFrame = frameInWindow(of: panels.prompt)

        XCTAssertFalse(panels.readingPanel === panels.sidebar, file: file, line: line)
        XCTAssertGreaterThan(readingFrame.width, 0, file: file, line: line)
        XCTAssertEqual(
            readingFrame.height, area.height, accuracy: Self.frameTolerance, file: file, line: line)
        XCTAssertFalse(
            readingFrame.intersects(sidebarFrame),
            "the reading panel \(readingFrame) overlaps the sidebar \(sidebarFrame)",
            file: file, line: line)
        XCTAssertTrue(
            isInside(sidebarFrame, area), "sidebar \(sidebarFrame)", file: file, line: line)
        XCTAssertTrue(
            isInside(readingFrame, area), "reading panel \(readingFrame)", file: file, line: line)

        assertDrawnWhole(panels.prompt, in: window, file: file, line: line)
        XCTAssertTrue(
            isInside(promptFrame, readingFrame),
            "the prompt \(promptFrame) is not inside the reading panel \(readingFrame)",
            file: file, line: line)
        XCTAssertLessThanOrEqual(
            promptFrame.maxX, area.maxX + Self.frameTolerance, file: file, line: line)
        XCTAssertEqual(
            drawnStrings(beneath: panels.readingPanel), [Self.readingPrompt],
            "the reading panel holds the prompt and no other text element or control",
            file: file, line: line)
        XCTAssertEqual(controls(beneath: panels.readingPanel).count, 0, file: file, line: line)
    }

    // W1 — Example 1.
    func testWorkbenchDrawsAFilesSidebarAndItsTree() throws {
        let workbench = makeWorkbench(showing: twoEntryRoot)

        let window = try present(workbench)

        let area = contentArea(of: window)
        XCTAssertEqual(area.size, openingContentSize)
        let sidebarFrame = frameInWindow(of: try drawn(workbench).sidebar)
        XCTAssertGreaterThan(sidebarFrame.width, 0)
        XCTAssertEqual(sidebarFrame.height, area.height, accuracy: Self.frameTolerance)
        let treeFrame = frameInWindow(of: workbench.rootItemsView)
        XCTAssertGreaterThan(treeFrame.width, 0)
        XCTAssertGreaterThan(treeFrame.height, 0)
        XCTAssertTrue(isInside(treeFrame, sidebarFrame), "tree \(treeFrame) in \(sidebarFrame)")
        let firstRowName = try textElement(saying: "src", beneath: workbench.rootItemsView)
        assertDrawnWhole(firstRowName, in: window)
        XCTAssertTrue(isInside(frameInWindow(of: firstRowName), sidebarFrame))
    }

    // W2 — Example 2.
    func testReadingPanelStandsBesideTheSidebarAndDrawsOnlyThePrompt() throws {
        let workbench = makeWorkbench(showing: twoEntryRoot)

        let window = try present(workbench)

        try assertReadingPanelStandsBesideTheSidebarAndDrawsOnlyThePrompt(workbench, in: window)
    }

    // W3 — Example 3.
    func testAFolderWithNoEntryDrawsItsLineInsideTheSidebar() throws {
        let workbench = makeWorkbench(showing: .observed([]))

        let window = try present(workbench)

        let line = try textElement(saying: "This folder has no files.", beneath: workbench)
        assertDrawnWhole(line, in: window)
        XCTAssertTrue(
            isInside(frameInWindow(of: line), frameInWindow(of: try drawn(workbench).sidebar)))
        try assertReadingPanelStandsBesideTheSidebarAndDrawsOnlyThePrompt(workbench, in: window)
    }

    // W4 — Example 4.
    func testAnUnreadableRootDrawsItsLineInsideTheSidebar() throws {
        let workbench = makeWorkbench(showing: .failed(.unreadable))

        let window = try present(workbench)

        let line = try textElement(saying: "Nozoki can't read this folder.", beneath: workbench)
        assertDrawnWhole(line, in: window)
        XCTAssertTrue(
            isInside(frameInWindow(of: line), frameInWindow(of: try drawn(workbench).sidebar)))
        try assertReadingPanelStandsBesideTheSidebarAndDrawsOnlyThePrompt(workbench, in: window)
    }

    func testTheWorkbenchIsExactlyItsTwoPanelsWithTheTreeItWasHandedAsTheSidebar() throws {
        let workbench = makeWorkbench(showing: twoEntryRoot)

        _ = try present(workbench)

        let panels = try drawn(workbench)
        XCTAssertEqual(workbench.subviews.count, 2)
        XCTAssertTrue(workbench.subviews.first === panels.sidebar, "the sidebar comes first")
        XCTAssertTrue(workbench.subviews.last === panels.readingPanel)
        XCTAssertTrue(
            panels.sidebar === workbench.rootItemsView,
            "the sidebar is the tree it was handed, in no second scrolling view")
    }

    func testThePanelsFillAWindowOfAnotherSize() throws {
        let workbench = makeWorkbench(showing: twoEntryRoot)
        let window = try present(workbench)

        window.setContentSize(NSSize(width: 900, height: 500))
        layOut(window)

        let area = contentArea(of: window)
        let panels = try drawn(workbench)
        let sidebarFrame = frameInWindow(of: panels.sidebar)
        let readingFrame = frameInWindow(of: panels.readingPanel)
        XCTAssertEqual(area.size, NSSize(width: 900, height: 500))
        XCTAssertEqual(sidebarFrame.minX, area.minX, accuracy: Self.frameTolerance)
        XCTAssertEqual(sidebarFrame.height, area.height, accuracy: Self.frameTolerance)
        XCTAssertEqual(readingFrame.height, area.height, accuracy: Self.frameTolerance)
        XCTAssertEqual(readingFrame.maxX, area.maxX, accuracy: Self.frameTolerance)
        try assertReadingPanelStandsBesideTheSidebarAndDrawsOnlyThePrompt(workbench, in: window)
    }
}
