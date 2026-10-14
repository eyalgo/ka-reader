import AppKit
import Shell
import Surfaces
import XCTest

private enum LayoutExpectations {
    /// `docs/DESIGN.md` § *Layout*: "the window's minimum width is 720px". The window's content
    /// area is as wide as the window for its style (change_spec.md § Verified Claims row 2).
    static let minimumContentWidth: CGFloat = 720

    /// The height the window opens at, which this change leaves as it was (change_spec.md Gap 1).
    static let openingContentHeight: CGFloat = 640

    /// `docs/DESIGN.md` § *Layout*: "The sidebar is `{spacing.sidebar-width}` (260px) wide and does
    /// not resize".
    static let sidebarWidth: CGFloat = 260

    /// `docs/DESIGN.md` § *Elevation & Depth*: the one `{spacing.hairline}` (1px) between the
    /// sidebar and the reading panel.
    static let hairline: CGFloat = 1

    /// How far each drag of the panels' boundary moves the pointer (change_spec.md Example 4).
    static let dragDistance: CGFloat = 100

    /// How far a queued pointer event may land from where it was posted. A queued event's place is
    /// read back through where the window server has the window (`dragAsAPersonDoes`): measured
    /// before the drag waited for the server to place it, 460 came back as 461.98, where the
    /// press, which is delivered and not queued, kept its place.
    static let queuedPointerDrift: CGFloat = 3

    static let readingPrompt = "Select a file to view."

    static let frameTolerance: CGFloat = 0.5

    static let chosenFolder = URL(
        fileURLWithPath: "/Users/someone/notes", isDirectory: true)

    static let twoEntryRootAnswer = Data(
        (#"{"state":"observed","entries":["#
            + #"{"name":"src","path":"src","kind":"folder","state":"pending"},"#
            + #"{"name":"a.txt","path":"a.txt","kind":"file","state":"observed","language":"plain"}]}"#)
            .utf8)

    /// `docs/DESIGN.md` § *Components* "Status messages": a status message is "inset
    /// `{spacing.xl}`" (24px), "left-aligned at the top of its surface".
    static let statusInset: CGFloat = 24

    static let browseTitle = "Browse…"
    static let quitTitle = "Quit"
    static let shortPath = "/Users/someone/gone"
    /// 1023 bytes, absolute: a relative path would be resolved against the test runner's directory
    /// on its way through the panel's URL.
    static let widestPath = "/" + String(repeating: "W", count: 1022)
}

/// The launch window against `docs/DESIGN.md` § *Layout* and § *Components*: the window's minimum
/// width, the workbench's two panels, the status messages and the startup surface's routes. Every
/// value expected here is the one DESIGN states, held by the test and never read from a product
/// constant, so a product value that departs from § *Layout* turns a test red (change_spec.md
/// CP-262). Every test reaches the product through its presenting path.
@MainActor
final class LaunchWindowLayoutTests: LaunchWindowTestCase {
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
        let launch = makeLaunch(answers: [LayoutExpectations.chosenFolder])
        launch.bridge.listAnswer = LayoutExpectations.twoEntryRootAnswer
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
            smallestContentWidth(of: window), LayoutExpectations.minimumContentWidth,
            accuracy: LayoutExpectations.frameTolerance,
            "\(label): the smallest content width the window allows", file: file, line: line)
        let opening = contentArea(of: window).size
        XCTAssertGreaterThanOrEqual(
            opening.width,
            LayoutExpectations.minimumContentWidth - LayoutExpectations.frameTolerance,
            "\(label): the opening content width", file: file, line: line)
        XCTAssertEqual(
            opening.height, LayoutExpectations.openingContentHeight,
            accuracy: LayoutExpectations.frameTolerance,
            "\(label): the opening content height is today's", file: file, line: line)
    }

    // L1 — CP-252, CP-262.
    func testTheWindowAllowsNoContentWidthBelowTheMinimum() throws {
        let window = try present(NSView())

        XCTAssertEqual(
            smallestContentWidth(of: window), LayoutExpectations.minimumContentWidth,
            accuracy: LayoutExpectations.frameTolerance)
    }

    // L2 — CP-252, CP-253.
    func testTheWindowOpensAtNoLessThanTheMinimumAndTodaysHeight() throws {
        let window = try present(NSView())
        let opening = contentArea(of: window).size

        XCTAssertGreaterThanOrEqual(
            opening.width,
            LayoutExpectations.minimumContentWidth - LayoutExpectations.frameTolerance)
        XCTAssertEqual(
            opening.height, LayoutExpectations.openingContentHeight,
            accuracy: LayoutExpectations.frameTolerance)
    }

    // CP-252, "whichever surface the window shows" — through a whole launch to each surface.
    func testTheMinimumHoldsOnTheStartupSurfaceAndTheWorkbench() throws {
        assertHoldsTheMinimumAndOpensAtIt(try launchToTheStartupSurface(), "startup surface")
        assertHoldsTheMinimumAndOpensAtIt(try launchToTheWorkbench().window, "workbench")
    }

    // MARK: - The two panels (CP-254, CP-255)

    /// The workbench's two panels, each found from the drawn view tree: a panel is the workbench's
    /// direct subview holding the tree, or holding the reading prompt.
    private func panels(of workbench: WorkbenchView) throws -> (
        rail: NSView, sidebar: NSView, reading: NSView
    ) {
        let prompt = try XCTUnwrap(
            textElements(beneath: workbench).first {
                $0.stringValue == LayoutExpectations.readingPrompt
            },
            "the workbench draws no “\(LayoutExpectations.readingPrompt)”")
        return (
            try XCTUnwrap(ShellTests.panel(of: workbench, containing: workbench.rail)),
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
        let (rail, sidebar, reading) = try panels(of: workbench)
        let railFrame = frameInWindow(of: rail)
        let sidebarFrame = frameInWindow(of: sidebar)
        let readingFrame = frameInWindow(of: reading)

        XCTAssertEqual(
            sidebarFrame.width, LayoutExpectations.sidebarWidth,
            accuracy: LayoutExpectations.frameTolerance,
            "\(label): the sidebar's width", file: file, line: line)
        XCTAssertEqual(
            railFrame.minX, area.minX, accuracy: LayoutExpectations.frameTolerance,
            "\(label): the rail starts at the content area's leading edge", file: file,
            line: line)
        XCTAssertEqual(
            sidebarFrame.minX, railFrame.maxX, accuracy: LayoutExpectations.frameTolerance,
            "\(label): the sidebar starts where the rail ends", file: file, line: line)
        XCTAssertEqual(
            readingFrame.maxX, area.maxX, accuracy: LayoutExpectations.frameTolerance,
            "\(label): the reading panel ends at the content area's trailing edge",
            file: file, line: line)
        let gap = readingFrame.minX - sidebarFrame.maxX
        XCTAssertGreaterThanOrEqual(
            gap, -LayoutExpectations.frameTolerance, "\(label): the panels overlap", file: file,
            line: line)
        XCTAssertLessThanOrEqual(
            gap, LayoutExpectations.hairline + LayoutExpectations.frameTolerance,
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

    // What makes L5 mean something: the drag it delivers reaches a view that tracks a drag in its
    // own loop, so a boundary that could be dragged would be (measured on the fork tree: the same
    // drag moved its split view's divider to 360 once the sidebar's width constraint was removed).
    func testADragReachesAViewThatTracksItInItsOwnLoop() throws {
        let tracker = DragTrackingView()
        let window = try present(tracker)
        let start = NSPoint(x: contentArea(of: window).midX, y: contentArea(of: window).midY)

        try dragAsAPersonDoes(in: window, from: start, by: LayoutExpectations.dragDistance)

        XCTAssertEqual(
            try XCTUnwrap(tracker.trackedDistance, "the view saw no drag"),
            LayoutExpectations.dragDistance,
            accuracy: LayoutExpectations.queuedPointerDrift)
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

        for width in [
            LayoutExpectations.minimumContentWidth, 2 * LayoutExpectations.minimumContentWidth,
        ] {
            window.setContentSize(NSSize(width: width, height: height))
            layOut(window)

            XCTAssertEqual(
                contentArea(of: window).width, width, accuracy: LayoutExpectations.frameTolerance)
            try assertTheSidebarIsFixedAndThePanelTakesTheRest(
                of: workbench, in: window, "at a content width of \(width)")
        }
    }

    // L5 — CP-254, CP-262.
    func testDraggingTheBoundaryBetweenThePanelsLeavesTheSidebarFixed() throws {
        let (workbench, window) = try launchToTheWorkbench()

        for distance in [LayoutExpectations.dragDistance, -LayoutExpectations.dragDistance] {
            let (_, sidebar, reading) = try panels(of: workbench)
            let boundary = NSPoint(
                x: (frameInWindow(of: sidebar).maxX + frameInWindow(of: reading).minX) / 2,
                y: contentArea(of: window).midY)

            try dragAsAPersonDoes(in: window, from: boundary, by: distance)

            XCTAssertEqual(
                frameInWindow(of: try panels(of: workbench).sidebar).width,
                LayoutExpectations.sidebarWidth,
                accuracy: LayoutExpectations.frameTolerance, "after a drag of \(distance) points")
        }
    }

    // MARK: - Status messages and routes (CP-256–CP-261)

    /// Which of `docs/DESIGN.md`'s two status glyphs leads a message: `info` for an empty or
    /// pending state, `circle-alert` for a failure.
    private enum StatusGlyph {
        case empty
        case failure

        func image(in glyphs: FakeGlyphSource) -> NSImage {
            switch self {
            case .empty: return glyphs.info
            case .failure: return glyphs.circleAlert
            }
        }
    }

    /// One of CP-256's seven status messages, reached through a launch and laid out in its window.
    private struct DrawnStatusMessage {
        let name: String
        let launch: WindowLaunch
        let window: NSWindow
        /// The surface the message sits at the top-left of.
        let surface: NSView
        let glyph: StatusGlyph
        /// The message's text, top to bottom.
        let texts: [String]
        let drawsRoutes: Bool
        /// Whether CP-239 or CP-244 holds the surface to no control at all. The sidebar is not
        /// held to it: its scroll view draws its own scrollers.
        var drawsNoControl = false
    }

    private static func openFailure(_ condition: String) -> Data {
        Data(#"{"state":"failed","condition":"\#(condition)"}"#.utf8)
    }

    /// A launch whose panel dismisses at once, or answers `chosenFolder` when `openAnswer` is set.
    private func launchToTheStartupSurface(
        opening openAnswer: Data?, path: String? = nil, reader: ReadRunning? = nil,
        terminate: @escaping () -> Void = {}
    ) throws -> (launch: WindowLaunch, surface: StartupView, window: NSWindow) {
        let chosen = openAnswer.map { _ in
            URL(fileURLWithPath: path ?? LayoutExpectations.shortPath, isDirectory: true)
        }
        let launch = makeLaunch(answers: [chosen, nil], reader: reader, terminate: terminate)
        launch.bridge.openAnswer = openAnswer
        launch.flow.run()
        let surface = try XCTUnwrap(
            launch.presenter.contents.last as? StartupView, "the launch ends on a startup surface")
        return (launch, surface, try laidOutWindow(of: surface))
    }

    /// A launch that opens a folder whose root the bridge answers with `rootAnswer`.
    private func launchToTheWorkbench(
        root rootAnswer: Data, terminate: @escaping () -> Void = {}
    ) throws -> (launch: WindowLaunch, workbench: WorkbenchView, window: NSWindow) {
        let launch = makeLaunch(answers: [LayoutExpectations.chosenFolder], terminate: terminate)
        launch.bridge.listAnswer = rootAnswer
        launch.flow.run()
        let workbench = try XCTUnwrap(
            launch.presenter.contents.last as? WorkbenchView,
            "a readable folder opens the workbench")
        return (launch, workbench, try laidOutWindow(of: workbench))
    }

    /// The sidebar: the workbench's direct subview holding the tree.
    private func sidebar(of workbench: WorkbenchView) throws -> NSView {
        try XCTUnwrap(
            ShellTests.panel(of: workbench, containing: workbench.rootItemsView.outlineView))
    }

    /// All seven status messages CP-256 lists, the failed one once per observed condition.
    private func everyStatusMessage(
        terminate: @escaping () -> Void = {}
    ) throws -> [DrawnStatusMessage] {
        var messages: [DrawnStatusMessage] = []

        let reading = try launchToTheWorkbench(
            root: LayoutExpectations.twoEntryRootAnswer, terminate: terminate)
        messages.append(
            DrawnStatusMessage(
                name: "the reading prompt", launch: reading.launch, window: reading.window,
                surface: try panels(of: reading.workbench).reading, glyph: .empty,
                texts: [LayoutExpectations.readingPrompt], drawsRoutes: false, drawsNoControl: true)
        )

        let roots: [(String, Data, StatusGlyph, String)] = [
            (
                "the empty root", Data(#"{"state":"observed","entries":[]}"#.utf8), .empty,
                "This folder has no files."
            ),
            (
                "the failed root", Data(#"{"state":"failed","condition":"unreadable"}"#.utf8),
                .failure, "KA-Reader can't read this folder."
            ),
        ]
        for (name, answer, glyph, sentence) in roots {
            let root = try launchToTheWorkbench(root: answer, terminate: terminate)
            messages.append(
                DrawnStatusMessage(
                    name: name, launch: root.launch, window: root.window,
                    surface: try sidebar(of: root.workbench), glyph: glyph, texts: [sentence],
                    drawsRoutes: false))
        }

        let dismissed = try launchToTheStartupSurface(opening: nil, terminate: terminate)
        messages.append(
            DrawnStatusMessage(
                name: "dismissed", launch: dismissed.launch, window: dismissed.window,
                surface: dismissed.surface, glyph: .empty, texts: ["Choose a folder to view."],
                drawsRoutes: true))

        let held = try launchToTheStartupSurface(
            opening: Data(#"{"state":"opened"}"#.utf8), reader: HoldingReadRunner(),
            terminate: terminate)
        messages.append(
            DrawnStatusMessage(
                name: "reading", launch: held.launch, window: held.window, surface: held.surface,
                glyph: .empty, texts: ["Reading this folder."], drawsRoutes: false,
                drawsNoControl: true))

        let failures: [(String, String)] = [
            ("missing", "KA-Reader couldn't find this folder."),
            ("not_a_folder", "KA-Reader found a file where it needs a folder."),
            ("unreadable", "KA-Reader can't read this folder."),
        ]
        for (condition, sentence) in failures {
            let failed = try launchToTheStartupSurface(
                opening: Self.openFailure(condition), terminate: terminate)
            messages.append(
                DrawnStatusMessage(
                    name: "failed, \(condition)", launch: failed.launch, window: failed.window,
                    surface: failed.surface, glyph: .failure,
                    texts: [LayoutExpectations.shortPath, sentence],
                    drawsRoutes: true))
        }

        let stopped = try launchToTheStartupSurface(
            opening: Data("malformed".utf8), terminate: terminate)
        messages.append(
            DrawnStatusMessage(
                name: "stopped", launch: stopped.launch, window: stopped.window,
                surface: stopped.surface, glyph: .failure,
                texts: [LayoutExpectations.shortPath, "KA-Reader couldn't open this folder."],
                drawsRoutes: true))
        return messages
    }

    /// The one glyph leading `message`. It fails when the surface draws none, or more than one.
    private func leadingGlyph(
        of message: DrawnStatusMessage, file: StaticString = #filePath, line: UInt = #line
    ) throws -> NSImageView {
        let drawn = glyphs(beneath: message.surface)
        XCTAssertEqual(
            drawn.count, 1, "\(message.name): exactly one glyph leads the message", file: file,
            line: line)
        return try XCTUnwrap(
            drawn.first, "\(message.name): no glyph leads the message", file: file, line: line)
    }

    /// The message's text elements, top to bottom.
    private func texts(of message: DrawnStatusMessage) -> [NSTextField] {
        textElements(beneath: message.surface)
    }

    private func oneLineHeight(of textField: NSTextField) -> CGFloat {
        let oneLine = NSTextField(labelWithString: "W")
        oneLine.font = textField.font
        return oneLine.intrinsicContentSize.height
    }

    private func spansOverlap(_ first: NSRect, _ second: NSRect) -> Bool {
        first.minY < second.maxY - LayoutExpectations.frameTolerance
            && second.minY < first.maxY - LayoutExpectations.frameTolerance
    }

    /// Every check L6 makes of one message. A message with no glyph is still read for its text's
    /// place, so each defect is reported for itself rather than stopping at the first.
    private func assertIsLedByItsGlyphAtTheTopLeft(_ message: DrawnStatusMessage) {
        let name = message.name
        let drawnGlyphs = glyphs(beneath: message.surface)
        XCTAssertEqual(drawnGlyphs.count, 1, "\(name): exactly one glyph leads the message")
        let texts = texts(of: message)
        XCTAssertEqual(texts.map(\.stringValue), message.texts, "\(name): the message's text")
        guard let firstText = texts.first else {
            return XCTFail("\(name): the message has no text")
        }
        let surfaceFrame = frameInWindow(of: message.surface)
        let area = contentArea(of: message.window)
        let textFrames = texts.map { frameInWindow(of: $0) }
        let glyph = drawnGlyphs.first
        let glyphFrame = glyph.map { frameInWindow(of: $0) }
        let messageFrame = textFrames.reduce(glyphFrame ?? textFrames[0]) { $0.union($1) }

        // Place: the message's top at the inset, and — below — the glyph's leading edge.
        XCTAssertEqual(
            surfaceFrame.maxY - messageFrame.maxY, LayoutExpectations.statusInset,
            accuracy: LayoutExpectations.frameTolerance,
            "\(name): the message's top")
        let unstacked = pairsNotStackedTopToBottom(among: texts)
        XCTAssertTrue(unstacked.isEmpty, "\(name): \(unstacked) are not one column")

        // Not centred, on either axis.
        XCTAssertGreaterThan(
            abs(messageFrame.midX - surfaceFrame.midX), LayoutExpectations.frameTolerance,
            "\(name): the message is centred across its surface")
        XCTAssertGreaterThan(
            abs(messageFrame.midY - surfaceFrame.midY), LayoutExpectations.frameTolerance,
            "\(name): the message is centred down its surface")
        for text in texts {
            assertDrawnWhole(text, in: message.window)
            XCTAssertEqual(
                frameInWindow(of: text).minX, textFrames[0].minX,
                accuracy: LayoutExpectations.frameTolerance,
                "\(name): the text shares one leading edge")
        }

        // The reading panel and the reading state draw no control (CP-239, CP-244).
        if message.drawsNoControl {
            XCTAssertEqual(
                controls(beneath: message.surface).count, 0, "\(name): draws no control")
        }

        guard let glyph, let glyphFrame else { return }

        // Which glyph: the empty and failure glyphs told apart.
        XCTAssertTrue(
            glyph.image === message.glyph.image(in: message.launch.glyphs),
            "\(name): led by the \(message.glyph) glyph")
        XCTAssertEqual(
            glyphFrame.minX - surfaceFrame.minX, LayoutExpectations.statusInset,
            accuracy: LayoutExpectations.frameTolerance,
            "\(name): the glyph's leading edge")

        // Beside: every text element to the glyph's right, the glyph on the first line.
        for (text, textFrame) in zip(texts, textFrames) {
            XCTAssertGreaterThanOrEqual(
                textFrame.minX, glyphFrame.maxX - LayoutExpectations.frameTolerance,
                "\(name): “\(text.stringValue)” stands to the glyph's right")
            XCTAssertFalse(
                textFrame.intersects(glyphFrame),
                "\(name): “\(text.stringValue)” overlaps the glyph")
        }
        let lineHeight = oneLineHeight(of: firstText)
        let firstLine = NSRect(
            x: textFrames[0].minX, y: textFrames[0].maxY - lineHeight, width: textFrames[0].width,
            height: lineHeight)
        XCTAssertTrue(
            spansOverlap(glyphFrame, firstLine), "\(name): the glyph stands on the first line")

        // Drawn: the glyph visible, non-zero and inside its surface and the content area.
        XCTAssertFalse(glyph.isHiddenOrHasHiddenAncestor, "\(name): the glyph is visible")
        XCTAssertGreaterThan(glyphFrame.width, 0, name)
        XCTAssertGreaterThan(glyphFrame.height, 0, name)
        XCTAssertTrue(
            surfaceFrame.insetBy(
                dx: -LayoutExpectations.frameTolerance, dy: -LayoutExpectations.frameTolerance
            )
            .contains(glyphFrame), "\(name): the glyph lies inside its surface")
        XCTAssertTrue(
            area.insetBy(
                dx: -LayoutExpectations.frameTolerance, dy: -LayoutExpectations.frameTolerance
            )
            .contains(glyphFrame), "\(name): the glyph lies inside the content area")
    }

    // L6 — CP-256, CP-257, CP-258, CP-263.
    func testEachStatusMessageIsLedByTheRightGlyphAtTheTopLeftBesideItsText() throws {
        for message in try everyStatusMessage() {
            assertIsLedByItsGlyphAtTheTopLeft(message)
        }
    }

    /// Runs `check` on each of `messages`, so a failure in one is reported beside the others'.
    private func forEach(
        _ messages: [DrawnStatusMessage], _ check: (DrawnStatusMessage) throws -> Void
    ) {
        for message in messages {
            do { try check(message) } catch { XCTFail("\(message.name): \(error)") }
        }
    }

    // CP-258 — the glyph is not a control.
    func testClickingTheGlyphRaisesNothing() throws {
        var terminations = 0
        forEach(try everyStatusMessage(terminate: { terminations += 1 })) { message in
            let glyph = try leadingGlyph(of: message)
            let launch = message.launch
            let panelsBefore = launch.panel.presentedCount
            let presentedBefore = launch.presenter.contents.count
            let listedBefore = launch.bridge.listedPaths.count
            let openedBefore = launch.bridge.openedLocations.count

            click(glyph)

            XCTAssertEqual(launch.panel.presentedCount, panelsBefore, "\(message.name): no panel")
            XCTAssertEqual(
                launch.presenter.contents.count, presentedBefore,
                "\(message.name): nothing is presented")
            XCTAssertEqual(launch.bridge.listedPaths.count, listedBefore, message.name)
            XCTAssertEqual(launch.bridge.openedLocations.count, openedBefore, message.name)
            XCTAssertEqual(terminations, 0, "\(message.name): the glyph does not quit")
        }
    }

    /// The startup messages that draw the two routes.
    private func routeDrawingMessages(
        terminate: @escaping () -> Void = {}
    ) throws -> [DrawnStatusMessage] {
        try everyStatusMessage(terminate: terminate).filter(\.drawsRoutes)
    }

    private func routes(
        of message: DrawnStatusMessage, file: StaticString = #filePath, line: UInt = #line
    ) throws -> (browse: NSControl, quit: NSControl) {
        (
            try control(
                titled: LayoutExpectations.browseTitle, beneath: message.surface, file: file,
                line: line),
            try control(
                titled: LayoutExpectations.quitTitle, beneath: message.surface, file: file,
                line: line)
        )
    }

    /// Whether any pixel `route` draws, read from its own rendering, lies outside its title's text
    /// rect: a border, a bezel or a fill would. One point of slack around the rect is allowed for
    /// the text's antialiased edge.
    private func drawsOutsideItsTitle(_ route: NSControl) throws -> Bool {
        let bitmap = try XCTUnwrap(route.bitmapImageRepForCachingDisplay(in: route.bounds))
        route.cacheDisplay(in: route.bounds, to: bitmap)
        let titleRect: NSRect
        if let cell = route.cell as? NSButtonCell {
            titleRect = cell.titleRect(forBounds: route.bounds)
        } else {
            titleRect = route.bounds
        }
        let allowed = titleRect.insetBy(dx: -1, dy: -1)
        let scaleX = CGFloat(bitmap.pixelsWide) / route.bounds.width
        let scaleY = CGFloat(bitmap.pixelsHigh) / route.bounds.height
        for row in 0..<bitmap.pixelsHigh {
            for column in 0..<bitmap.pixelsWide {
                guard let alpha = bitmap.colorAt(x: column, y: row)?.alphaComponent, alpha > 0
                else { continue }
                // A bitmap's rows run top down; the rect is in the route's own coordinates.
                let x = (CGFloat(column) + 0.5) / scaleX
                let yFromTop = (CGFloat(row) + 0.5) / scaleY
                let y = route.isFlipped ? yFromTop : route.bounds.height - yFromTop
                if !allowed.contains(NSPoint(x: x, y: y)) { return true }
            }
        }
        return false
    }

    // L7 — CP-259, CP-263.
    func testEachRouteDrawsItsTitleAndNothingElse() throws {
        forEach(try routeDrawingMessages()) { message in
            let (browse, quit) = try routes(of: message)
            for route in [browse, quit] {
                let title = drawnString(of: route)
                XCTAssertFalse(
                    try drawsOutsideItsTitle(route),
                    "\(message.name): “\(title)” draws outside its title")
                if let button = route as? NSButton {
                    XCTAssertNil(button.image, "\(message.name): “\(title)” holds an image")
                    XCTAssertNil(
                        button.alternateImage, "\(message.name): “\(title)” holds an image")
                }
            }
        }
    }

    // L7 — CP-259.
    func testTheRoutesStandOneToARowAlignedBeneathTheWholeMessage() throws {
        forEach(try routeDrawingMessages()) { message in
            let name = message.name
            let (browse, quit) = try routes(of: message)
            let glyphFrame = frameInWindow(of: try leadingGlyph(of: message))
            let textFrames = texts(of: message).map { frameInWindow(of: $0) }
            let messageBottom = textFrames.reduce(glyphFrame.minY) { min($0, $1.minY) }
            let textLeading = try XCTUnwrap(textFrames.map(\.minX).min(), name)
            let browseFrame = frameInWindow(of: browse)
            let quitFrame = frameInWindow(of: quit)

            XCTAssertLessThanOrEqual(
                quitFrame.maxY, browseFrame.minY + LayoutExpectations.frameTolerance,
                "\(name): Quit stands on its own line beneath Browse…")
            for (route, frame) in [(browse, browseFrame), (quit, quitFrame)] {
                let title = drawnString(of: route)
                XCTAssertLessThanOrEqual(
                    frame.maxY, messageBottom + LayoutExpectations.frameTolerance,
                    "\(name): “\(title)” stands beneath the whole message")
                let others =
                    drawnElements(beneath: message.surface).filter { $0 !== route }.map {
                        frameInWindow(of: $0)
                    } + [glyphFrame]
                XCTAssertFalse(
                    others.contains { spansOverlap($0, frame) },
                    "\(name): something else shares “\(title)”'s line")
                XCTAssertGreaterThanOrEqual(
                    frame.minX, glyphFrame.minX - LayoutExpectations.frameTolerance,
                    "\(name): “\(title)” is left of the glyph")
                XCTAssertLessThanOrEqual(
                    frame.minX, textLeading + LayoutExpectations.frameTolerance,
                    "\(name): “\(title)” is right of the text")
            }
            XCTAssertEqual(
                browseFrame.minX, quitFrame.minX, accuracy: LayoutExpectations.frameTolerance,
                "\(name): the routes' leading edges")
        }
    }

    // CP-260 through the text-alone routes: one click on Browse… presents the panel once, one on
    // Quit ends the app, and the reading state draws no route.
    func testBrowseAndQuitStillRaiseTheirIntents() throws {
        for message in try routeDrawingMessages() {
            let (browse, quit) = try routes(of: message)
            XCTAssertTrue(browse.isEnabled && quit.isEnabled, message.name)
            let panelsBefore = message.launch.panel.presentedCount

            click(browse)

            XCTAssertEqual(
                message.launch.panel.presentedCount, panelsBefore + 1,
                "\(message.name): Browse… presents the panel once")
        }
        var terminations = 0
        for message in try routeDrawingMessages(terminate: { terminations += 1 }) {
            let quit = try routes(of: message).quit
            let before = terminations

            click(quit)

            XCTAssertEqual(terminations, before + 1, "\(message.name): Quit ends the app once")
        }
        let reading = try launchToTheStartupSurface(
            opening: Data(#"{"state":"opened"}"#.utf8), reader: HoldingReadRunner())
        XCTAssertEqual(controls(beneath: reading.surface).count, 0, "reading draws no route")
    }

    // L8 — CP-261's CP-243 clause.
    func testALongPathWrapsInsideTheColumnBesideTheGlyph() throws {
        let failed = try launchToTheStartupSurface(
            opening: Self.openFailure("missing"), path: LayoutExpectations.widestPath)
        let glyph = try XCTUnwrap(glyphs(beneath: failed.surface).first, "no glyph")
        let path = try XCTUnwrap(
            textElements(beneath: failed.surface).first {
                $0.stringValue == LayoutExpectations.widestPath
            },
            "the surface draws no path")
        let pathFrame = frameInWindow(of: path)
        let (browse, quit) = (
            try control(titled: LayoutExpectations.browseTitle, beneath: failed.surface),
            try control(titled: LayoutExpectations.quitTitle, beneath: failed.surface)
        )

        XCTAssertEqual(contentArea(of: failed.window).size, openingContentSize)
        XCTAssertGreaterThanOrEqual(
            pathFrame.minX, frameInWindow(of: glyph).maxX - LayoutExpectations.frameTolerance,
            "the path wraps in the column to the glyph's right")
        XCTAssertGreaterThan(
            pathFrame.height, oneLineHeight(of: path), "the path stands on more than one line")
        assertDrawnWhole(path, in: failed.window)
        XCTAssertNotEqual(path.lineBreakMode, .byTruncatingTail)
        XCTAssertNotEqual(path.lineBreakMode, .byTruncatingMiddle)
        XCTAssertNotEqual(path.lineBreakMode, .byTruncatingHead)
        for route in [browse, quit] {
            assertDrawnWhole(route, in: failed.window)
            XCTAssertLessThanOrEqual(
                frameInWindow(of: route).maxY, pathFrame.minY + LayoutExpectations.frameTolerance,
                "“\(drawnString(of: route))” stands beneath the path")
        }
    }

    // CP-256's exception: a root with rows draws no status message, so no status glyph.
    func testAListingWithRowsDrawsNoStatusGlyphInTheSidebar() throws {
        let (launch, workbench, _) = try launchToTheWorkbench(
            root: LayoutExpectations.twoEntryRootAnswer)
        let statusImages = [launch.glyphs.info, launch.glyphs.circleAlert]

        let drawnImages = glyphs(beneath: try sidebar(of: workbench)).compactMap(\.image)

        XCTAssertFalse(drawnImages.isEmpty, "the rows draw their own glyphs")
        XCTAssertFalse(
            drawnImages.contains { image in statusImages.contains { $0 === image } },
            "the sidebar draws a status glyph beside rows")
    }

    // The root's message follows what it is shown: a failed root that becomes listed draws neither
    // its sentence nor its glyph.
    func testAFailedRootThatBecomesListedHidesItsMessageAndGlyph() throws {
        let (launch, workbench, window) = try launchToTheWorkbench(
            root: Data(#"{"state":"failed","condition":"unreadable"}"#.utf8))
        let sidebar = try sidebar(of: workbench)
        XCTAssertTrue(
            glyphs(beneath: sidebar).contains { $0.image === launch.glyphs.circleAlert },
            "the failed root is led by the failure glyph")

        workbench.rootItemsView.show(
            .observed([Entry(name: "a.txt", path: "a.txt", kind: .file, state: .observed)]))
        layOut(window)

        XCTAssertFalse(
            textElements(beneath: sidebar).contains {
                $0.stringValue == "KA-Reader can't read this folder."
            }, "the failed root's sentence is still drawn")
        let statusImages = [launch.glyphs.info, launch.glyphs.circleAlert]
        XCTAssertFalse(
            glyphs(beneath: sidebar).contains { glyph in
                statusImages.contains { $0 === glyph.image }
            }, "the failed root's glyph is still drawn")
    }

    // A root shown again as empty is led by the empty glyph, not the failure glyph it had.
    func testARootShownAgainAsEmptyIsLedByTheEmptyGlyph() throws {
        let (launch, workbench, window) = try launchToTheWorkbench(
            root: Data(#"{"state":"failed","condition":"unreadable"}"#.utf8))

        workbench.rootItemsView.show(.observed([]))
        layOut(window)

        let drawn = glyphs(beneath: try sidebar(of: workbench))
        XCTAssertEqual(drawn.count, 1)
        XCTAssertTrue(drawn.first?.image === launch.glyphs.info, "led by the empty glyph")
        XCTAssertEqual(
            textElements(beneath: try sidebar(of: workbench)).map(\.stringValue),
            ["This folder has no files."])
    }

    // The sidebar's message stays at its top-left when the window is resized.
    func testTheSidebarsMessageStaysTopLeftWhenTheWindowIsResized() throws {
        let (_, workbench, window) = try launchToTheWorkbench(
            root: Data(#"{"state":"observed","entries":[]}"#.utf8))
        window.setContentSize(
            NSSize(width: 2 * LayoutExpectations.minimumContentWidth, height: 500))
        layOut(window)
        let sidebar = try sidebar(of: workbench)
        let glyph = try XCTUnwrap(glyphs(beneath: sidebar).first, "no glyph")
        let sidebarFrame = frameInWindow(of: sidebar)

        XCTAssertEqual(
            frameInWindow(of: glyph).minX - sidebarFrame.minX, LayoutExpectations.statusInset,
            accuracy: LayoutExpectations.frameTolerance)
        XCTAssertEqual(
            sidebarFrame.maxY - frameInWindow(of: glyph).maxY, LayoutExpectations.statusInset,
            accuracy: LayoutExpectations.frameTolerance)
    }

    // The harness keeps an image view that can be edited or carries an action among the controls,
    // so a stray control drawn as an image still fails a test that finds none.
    func testAnEditableOrActionImageViewIsStillAControl() throws {
        let surface = NSView()
        let glyph = NSImageView(image: NSImage(size: NSSize(width: 16, height: 16)))
        let editable = NSImageView(image: NSImage(size: NSSize(width: 16, height: 16)))
        editable.isEditable = true
        let acting = NSImageView(image: NSImage(size: NSSize(width: 16, height: 16)))
        acting.target = surface
        acting.action = #selector(NSResponder.cancelOperation(_:))
        for (index, view) in [glyph, editable, acting].enumerated() {
            view.frame = NSRect(x: 20, y: 20 + CGFloat(index) * 40, width: 16, height: 16)
            surface.addSubview(view)
        }

        _ = try present(surface)

        XCTAssertEqual(glyphs(beneath: surface), [glyph])
        XCTAssertEqual(
            Set(controls(beneath: surface).map(ObjectIdentifier.init)),
            [
                ObjectIdentifier(editable), ObjectIdentifier(acting),
            ])
        XCTAssertEqual(textElements(beneath: surface).count, 0)
    }
}
