import AppKit
import Shell
import Surfaces
import XCTest

/// The launch window against `docs/DESIGN.md` § *Layout*: the window's minimum width, and the
/// workbench's two panels. Every value expected here is the one DESIGN states, held by the test and
/// never read from a product constant, so a product value that departs from § *Layout* turns a test
/// red (change_spec.md CP-262). Every test reaches the product through its presenting path.
@MainActor
final class LaunchWindowLayoutTests: LaunchWindowTestCase {
    /// `docs/DESIGN.md` § *Layout*: "the window's minimum width is 720px". The window's content area
    /// is as wide as the window for its style (change_spec.md § Verified Claims row 2).
    private static let minimumContentWidth: CGFloat = 720

    /// The height the window opens at, which this change leaves as it was (change_spec.md Gap 1).
    private static let openingContentHeight: CGFloat = 640

    /// `docs/DESIGN.md` § *Layout*: "The sidebar is `{spacing.sidebar-width}` (260px) wide and does
    /// not resize".
    private static let sidebarWidth: CGFloat = 260

    /// `docs/DESIGN.md` § *Elevation & Depth*: the one `{spacing.hairline}` (1px) between the sidebar
    /// and the reading panel.
    private static let hairline: CGFloat = 1

    /// How far each drag of the panels' boundary moves the pointer (change_spec.md Example 4).
    private static let dragDistance: CGFloat = 100

    /// How far a queued pointer event may land from where it was posted. A queued event's place is
    /// read back through the screen it is on: measured on a window on a second display, 460 came back
    /// as 461.98, where the press, which is delivered and not queued, kept its place.
    private static let queuedPointerDrift: CGFloat = 3

    private static let readingPrompt = "Select a file to view."

    private static let frameTolerance: CGFloat = 0.5

    private static let chosenFolder = URL(
        fileURLWithPath: "/Users/someone/notes", isDirectory: true)

    private static let twoEntryRootAnswer = Data(
        (#"{"state":"observed","entries":["#
            + #"{"name":"src","path":"src","kind":"folder","state":"pending"},"#
            + #"{"name":"a.txt","path":"a.txt","kind":"file","state":"observed"}]}"#).utf8)

    /// The smallest content width `window` lets a person resize it to. AppKit keeps a frame minimum
    /// and a content minimum; each is read as a content width and the smaller is the answer, so a
    /// window that declares only one of them is still read by what it declares.
    private func smallestContentWidth(of window: NSWindow) -> CGFloat {
        let frameMinimum = window.contentRect(
            forFrameRect: NSRect(origin: .zero, size: window.minSize)
        ).width
        return min(window.contentMinSize.width, frameMinimum)
    }

    /// A launch that ends on the startup surface, the Open panel dismissed.
    private func launchToTheStartupSurface() throws -> NSWindow {
        let launch = makeLaunch(answers: [nil])
        launch.flow.run()
        let startup = try XCTUnwrap(launch.presenter.contents.last as? StartupView)
        return try laidOutWindow(of: startup)
    }

    /// A launch that opens a two-entry folder and ends on the workbench.
    private func launchToTheWorkbench() throws -> (workbench: WorkbenchView, window: NSWindow) {
        let launch = makeLaunch(answers: [Self.chosenFolder])
        launch.bridge.listAnswer = Self.twoEntryRootAnswer
        launch.flow.run()
        let workbench = try XCTUnwrap(
            launch.presenter.contents.last as? WorkbenchView,
            "a readable folder opens the workbench")
        return (workbench, try laidOutWindow(of: workbench))
    }

    private func assertHoldsTheMinimumAndOpensAtIt(
        _ window: NSWindow, _ label: String, file: StaticString = #filePath, line: UInt = #line
    ) {
        XCTAssertEqual(
            smallestContentWidth(of: window), Self.minimumContentWidth,
            accuracy: Self.frameTolerance,
            "\(label): the smallest content width the window allows", file: file, line: line)
        let opening = contentArea(of: window).size
        XCTAssertGreaterThanOrEqual(
            opening.width, Self.minimumContentWidth - Self.frameTolerance,
            "\(label): the opening content width", file: file, line: line)
        XCTAssertEqual(
            opening.height, Self.openingContentHeight, accuracy: Self.frameTolerance,
            "\(label): the opening content height is today's", file: file, line: line)
    }

    // L1 — CP-252, CP-262.
    func testTheWindowAllowsNoContentWidthBelowTheMinimum() throws {
        let window = try present(NSView())

        XCTAssertEqual(
            smallestContentWidth(of: window), Self.minimumContentWidth,
            accuracy: Self.frameTolerance)
    }

    // L2 — CP-252, CP-253.
    func testTheWindowOpensAtNoLessThanTheMinimumAndTodaysHeight() throws {
        let window = try present(NSView())
        let opening = contentArea(of: window).size

        XCTAssertGreaterThanOrEqual(
            opening.width, Self.minimumContentWidth - Self.frameTolerance)
        XCTAssertEqual(opening.height, Self.openingContentHeight, accuracy: Self.frameTolerance)
    }

    // CP-252, "whichever surface the window shows" — through a whole launch to each surface.
    func testTheMinimumHoldsOnTheStartupSurfaceAndTheWorkbench() throws {
        assertHoldsTheMinimumAndOpensAtIt(try launchToTheStartupSurface(), "startup surface")
        assertHoldsTheMinimumAndOpensAtIt(try launchToTheWorkbench().window, "workbench")
    }

    // MARK: - The two panels (CP-254, CP-255)

    /// The workbench's two panels, each found from the drawn view tree: a panel is the workbench's
    /// direct subview holding the tree, or holding the reading prompt.
    private func panels(of workbench: WorkbenchView) throws -> (sidebar: NSView, reading: NSView) {
        let prompt = try XCTUnwrap(
            textElements(beneath: workbench).first { $0.stringValue == Self.readingPrompt },
            "the workbench draws no “\(Self.readingPrompt)”")
        return (
            try XCTUnwrap(
                ShellTests.panel(of: workbench, containing: workbench.rootItemsView.outlineView)),
            try XCTUnwrap(ShellTests.panel(of: workbench, containing: prompt))
        )
    }

    /// CP-254 and CP-255 at the window's current size: the sidebar is W_sidebar wide, the reading
    /// panel runs from one hairline past it to the content area's trailing edge, and it is wider.
    private func assertTheSidebarIsFixedAndThePanelTakesTheRest(
        of workbench: WorkbenchView, in window: NSWindow, _ label: String,
        file: StaticString = #filePath, line: UInt = #line
    ) throws {
        let area = contentArea(of: window)
        let (sidebar, reading) = try panels(of: workbench)
        let sidebarFrame = frameInWindow(of: sidebar)
        let readingFrame = frameInWindow(of: reading)

        XCTAssertEqual(
            sidebarFrame.width, Self.sidebarWidth, accuracy: Self.frameTolerance,
            "\(label): the sidebar's width", file: file, line: line)
        XCTAssertEqual(
            sidebarFrame.minX, area.minX, accuracy: Self.frameTolerance,
            "\(label): the sidebar starts at the content area's leading edge", file: file,
            line: line)
        XCTAssertEqual(
            readingFrame.maxX, area.maxX, accuracy: Self.frameTolerance,
            "\(label): the reading panel ends at the content area's trailing edge",
            file: file, line: line)
        let gap = readingFrame.minX - sidebarFrame.maxX
        XCTAssertGreaterThanOrEqual(
            gap, -Self.frameTolerance, "\(label): the panels overlap", file: file, line: line)
        XCTAssertLessThanOrEqual(
            gap, Self.hairline + Self.frameTolerance,
            "\(label): the gap between the panels is \(gap), wider than one hairline",
            file: file, line: line)
        XCTAssertGreaterThan(
            readingFrame.width, sidebarFrame.width,
            "\(label): the reading panel \(readingFrame.width) is wider than the sidebar",
            file: file, line: line)
    }

    /// A view that follows a press to its release in its own loop, as a draggable boundary does.
    private final class DragTrackingView: NSView {
        private(set) var trackedDistance: CGFloat?

        // A press on a window that is not key reaches only a view that takes the first mouse, as a
        // split view's divider does; the test window is never key (no run loop is started).
        override func acceptsFirstMouse(for event: NSEvent?) -> Bool { true }

        /// Follows the pointer from the press to the release, as a divider does, and keeps how far
        /// the last drag carried it.
        override func mouseDown(with press: NSEvent) {
            while let event = window?.nextEvent(
                matching: [.leftMouseDragged, .leftMouseUp], until: .distantPast,
                inMode: .eventTracking, dequeue: true), event.type == .leftMouseDragged
            {
                trackedDistance = event.locationInWindow.x - press.locationInWindow.x
            }
        }
    }

    // What makes L5 mean something: the drag it delivers reaches a view that tracks a drag in its own
    // loop, so a boundary that could be dragged would be (measured on the fork tree: the same drag
    // moved its split view's divider to 360 once the sidebar's width constraint was removed).
    func testADragReachesAViewThatTracksItInItsOwnLoop() throws {
        let tracker = DragTrackingView()
        let window = try present(tracker)
        let start = NSPoint(x: contentArea(of: window).midX, y: contentArea(of: window).midY)

        try dragAsAPersonDoes(in: window, from: start, by: Self.dragDistance)

        XCTAssertEqual(
            try XCTUnwrap(tracker.trackedDistance, "the view saw no drag"), Self.dragDistance,
            accuracy: Self.queuedPointerDrift)
    }

    // L3 — CP-254, CP-255.
    func testTheSidebarIsFixedAndThePanelIsWiderAtTheOpeningSize() throws {
        let (workbench, window) = try launchToTheWorkbench()

        try assertTheSidebarIsFixedAndThePanelTakesTheRest(
            of: workbench, in: window, "at the opening size")
    }

    // L4 — CP-254, CP-255.
    func testTheSidebarStaysFixedWhenTheWindowIsResized() throws {
        let (workbench, window) = try launchToTheWorkbench()
        let height = contentArea(of: window).height

        for width in [Self.minimumContentWidth, 2 * Self.minimumContentWidth] {
            window.setContentSize(NSSize(width: width, height: height))
            layOut(window)

            XCTAssertEqual(contentArea(of: window).width, width, accuracy: Self.frameTolerance)
            try assertTheSidebarIsFixedAndThePanelTakesTheRest(
                of: workbench, in: window, "at a content width of \(width)")
        }
    }

    // L5 — CP-254, CP-262.
    func testDraggingTheBoundaryBetweenThePanelsLeavesTheSidebarFixed() throws {
        let (workbench, window) = try launchToTheWorkbench()

        for distance in [Self.dragDistance, -Self.dragDistance] {
            let (sidebar, reading) = try panels(of: workbench)
            let boundary = NSPoint(
                x: (frameInWindow(of: sidebar).maxX + frameInWindow(of: reading).minX) / 2,
                y: contentArea(of: window).midY)

            try dragAsAPersonDoes(in: window, from: boundary, by: distance)

            XCTAssertEqual(
                frameInWindow(of: try panels(of: workbench).sidebar).width, Self.sidebarWidth,
                accuracy: Self.frameTolerance, "after a drag of \(distance) points")
        }
    }
}
