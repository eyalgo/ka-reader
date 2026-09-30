import AppKit
import Shell
import Surfaces
import XCTest

/// The launch window around the startup surface: what each projection draws in it. Every test
/// presents through the product's own presenter and reads the laid-out window (change_spec.md
/// CP-246).
@MainActor
final class LaunchWindowStartupTests: LaunchWindowTestCase {
    private static let browseTitle = "Browse…"
    private static let quitTitle = "Quit"
    private static let shortPath = "/Users/someone/gone"
    private static let pathByteLimit = 1023

    /// The path M9 measured to need the most room of those this surface holds whole.
    private static let widestMeasuredPath = String(repeating: "W", count: pathByteLimit)

    /// A path no layout fits: 16384 points tall at a 440-point line (change_design.md M9).
    private static let pathNoLayoutFits = String(repeating: "\n", count: pathByteLimit)

    /// The room M9 measured the 1023-`W` path to need (change_design.md § 5, S5).
    private static let measuredRoomForTheWidestPath: CGFloat = 480

    private static let frameTolerance: CGFloat = 0.5

    /// A failed opening's four elements, found by their place: the path first, the routes last.
    private struct DrawnFailure {
        let path: NSTextField
        let sentence: NSTextField
        let browse: NSButton
        let quit: NSButton

        var belowThePath: [NSControl] { [sentence, browse, quit] }
    }

    private func presentStartup(
        _ projection: StartupProjection, onIntent: @escaping (StartupIntent) -> Void = { _ in }
    ) throws -> (surface: StartupView, window: NSWindow) {
        let surface = StartupView(projection: projection, onIntent: onIntent)
        return (surface, try present(surface))
    }

    /// The element list a rule fixes: exactly `strings`, top to bottom, the last `controlCount` of
    /// them controls and the rest text elements, each drawn whole and none over another.
    private func assertDraws(
        exactly strings: [String], controlCount: Int, on surface: NSView, in window: NSWindow,
        _ label: String = "", file: StaticString = #filePath, line: UInt = #line
    ) {
        let elements = drawnElements(beneath: surface)
        XCTAssertEqual(elements.map(drawnString), strings, label, file: file, line: line)
        XCTAssertEqual(
            textElements(beneath: surface).map(\.stringValue),
            Array(strings.dropLast(controlCount)), "the text elements. \(label)",
            file: file, line: line)
        XCTAssertEqual(
            controls(beneath: surface).map(drawnString), Array(strings.suffix(controlCount)),
            "the controls. \(label)", file: file, line: line)
        for element in elements {
            assertDrawnWhole(element, in: window, file: file, line: line)
        }
        let overlaps = overlappingPairs(among: elements)
        XCTAssertTrue(overlaps.isEmpty, "\(overlaps) overlap. \(label)", file: file, line: line)
        let unstacked = pairsNotStackedTopToBottom(among: elements)
        XCTAssertTrue(
            unstacked.isEmpty, "\(unstacked) are not one beneath the other. \(label)",
            file: file, line: line)
    }

    private func drawnFailure(
        on surface: NSView, file: StaticString = #filePath, line: UInt = #line
    ) throws -> DrawnFailure {
        let texts = textElements(beneath: surface)
        let buttons = controls(beneath: surface).compactMap { $0 as? NSButton }
        let drawn = "the surface draws \(drawnStrings(beneath: surface).count) elements"
        return DrawnFailure(
            path: try XCTUnwrap(texts.first, "no path: \(drawn)", file: file, line: line),
            sentence: try XCTUnwrap(
                texts.dropFirst().first, "no sentence: \(drawn)", file: file, line: line),
            browse: try XCTUnwrap(
                buttons.first, "no first route: \(drawn)", file: file, line: line),
            quit: try XCTUnwrap(
                buttons.dropFirst().first, "no second route: \(drawn)", file: file, line: line))
    }

    private func oneLineHeight(of textField: NSTextField) -> CGFloat {
        let oneLine = NSTextField(labelWithString: "W")
        oneLine.font = textField.font
        return oneLine.intrinsicContentSize.height
    }

    /// CP-243 for a path that fits the room left: the path whole on several lines, and everything
    /// beneath it whole inside the content area.
    private func assertTheWholePathIsDrawnAboveItsWholeRoutes(
        _ path: String, file: StaticString = #filePath, line: UInt = #line
    ) throws -> DrawnFailure {
        let (surface, window) = try presentStartup(.failed(path: path, condition: .missing))
        let drawn = try drawnFailure(on: surface, file: file, line: line)

        XCTAssertEqual(drawn.path.stringValue, path, file: file, line: line)
        XCTAssertGreaterThan(
            frameInWindow(of: drawn.path).height, oneLineHeight(of: drawn.path),
            "the path stands on more than one line", file: file, line: line)
        assertDrawnWhole(drawn.path, in: window, file: file, line: line)
        XCTAssertNotEqual(drawn.path.lineBreakMode, .byTruncatingTail, file: file, line: line)
        XCTAssertNotEqual(drawn.path.lineBreakMode, .byTruncatingMiddle, file: file, line: line)
        XCTAssertNotEqual(drawn.path.lineBreakMode, .byTruncatingHead, file: file, line: line)
        for element in drawn.belowThePath {
            assertDrawnWhole(element, in: window, file: file, line: line)
            XCTAssertLessThanOrEqual(
                frameInWindow(of: element).maxY,
                frameInWindow(of: drawn.path).minY + Self.frameTolerance,
                "“\(drawnString(of: element))” stands beneath the path", file: file, line: line)
        }
        XCTAssertEqual(contentArea(of: window).size, openingContentSize, file: file, line: line)
        return drawn
    }

    // S1 — Example 6 (CP-240).
    func testDismissedPanelDrawsThePromptBrowseAndQuit() throws {
        let (surface, window) = try presentStartup(.empty)

        assertDraws(
            exactly: ["Choose a folder to view.", Self.browseTitle, Self.quitTitle],
            controlCount: 2, on: surface, in: window)
    }

    // S2 — Examples 7, 8, 9 (CP-241).
    func testFailedOpeningDrawsPathSentenceAndRoutesForEachCondition() throws {
        let sentences: [OpeningCondition: String] = [
            .missing: "Nozoki couldn't find this folder.",
            .notAFolder: "Nozoki found a file where it needs a folder.",
            .unreadable: "Nozoki can't read this folder.",
        ]

        for condition in OpeningCondition.allCases {
            let sentence = try XCTUnwrap(sentences[condition], "\(condition) has a sentence")
            let (surface, window) = try presentStartup(
                .failed(path: Self.shortPath, condition: condition))

            assertDraws(
                exactly: [Self.shortPath, sentence, Self.browseTitle, Self.quitTitle],
                controlCount: 2, on: surface, in: window, "\(condition)")
        }
    }

    // S3 — Example 10 (CP-242).
    func testStoppedOpeningDrawsPathSentenceAndRoutes() throws {
        let (surface, window) = try presentStartup(.stopped(path: Self.shortPath))

        assertDraws(
            exactly: [
                Self.shortPath, "Nozoki couldn't open this folder.", Self.browseTitle,
                Self.quitTitle,
            ],
            controlCount: 2, on: surface, in: window)
    }

    // S4 — Example 11 (CP-243).
    func testALongPathWrapsWholeAndTheRoutesStayWhole() throws {
        let longPath = "/" + String(repeating: "a-folder-name/", count: 21) + "gone!"
        XCTAssertEqual(longPath.count, 300)

        _ = try assertTheWholePathIsDrawnAboveItsWholeRoutes(longPath)
    }

    // S5 — CP-243, the largest member this surface holds whole.
    func testThe1023ByteWidePathStillFitsWhole() throws {
        let drawn = try assertTheWholePathIsDrawnAboveItsWholeRoutes(Self.widestMeasuredPath)

        XCTAssertGreaterThanOrEqual(
            frameInWindow(of: drawn.path).height, Self.measuredRoomForTheWidestPath)
    }

    // S6 — the members of CP-243's domain the rule cannot hold for.
    func testAPathNoLayoutFitsGivesWayAndNothingElseMoves() throws {
        let (surface, window) = try presentStartup(
            .failed(path: Self.pathNoLayoutFits, condition: .missing))
        let drawn = try drawnFailure(on: surface)
        let area = contentArea(of: window)

        XCTAssertEqual(area.size, openingContentSize)
        for element in drawn.belowThePath {
            assertDrawnWhole(element, in: window)
            XCTAssertTrue(element.isEnabled, "“\(drawnString(of: element))” is enabled")
        }
        XCTAssertEqual(drawn.path.stringValue, Self.pathNoLayoutFits)
        let pathFrame = frameInWindow(of: drawn.path)
        XCTAssertTrue(
            area.insetBy(dx: -Self.frameTolerance, dy: -Self.frameTolerance).contains(pathFrame),
            "the path \(pathFrame) lies inside the content area \(area)")
        XCTAssertGreaterThan(pathFrame.height, 0)
        XCTAssertTrue(overlappingPairs(among: drawnElements(beneath: surface)).isEmpty)
    }

    // S7 — Example 12 (CP-244).
    func testReadingDrawsOnlyTheReadingLine() throws {
        let (surface, window) = try presentStartup(.reading)

        assertDraws(exactly: ["Reading this folder."], controlCount: 0, on: surface, in: window)
        XCTAssertTrue(visibleViews(of: NSProgressIndicator.self, beneath: surface).isEmpty)
    }

    /// `onIntent` is called once per activation of a drawn control, and by nothing else.
    func testAClickOnADrawnRouteRaisesItsIntentOnceAndDrawingRaisesNone() throws {
        let projections: [StartupProjection] = [
            .empty, .failed(path: Self.shortPath, condition: .unreadable),
            .stopped(path: Self.shortPath),
        ]

        for projection in projections {
            var intents: [StartupIntent] = []
            let (surface, _) = try presentStartup(projection) { intents.append($0) }
            XCTAssertEqual(intents, [], "drawing \(projection) raises no intent")
            let browse = try control(titled: Self.browseTitle, beneath: surface)
            let quit = try control(titled: Self.quitTitle, beneath: surface)
            XCTAssertTrue(browse.isEnabled && quit.isEnabled, "\(projection)")

            click(browse)
            XCTAssertEqual(intents, [.browse], "\(projection)")
            click(quit)
            XCTAssertEqual(intents, [.browse, .quit], "\(projection)")
        }
    }

    // MARK: - The routes through a launch (CP-245)

    /// A launch that ends on a surface drawing the routes: what the panel answers first, and what
    /// the bridge answers the opening with.
    private struct RouteDrawingLaunch {
        let name: String
        let panelAnswer: URL?
        let openAnswer: Data?
    }

    private static let chosenFolder = URL(fileURLWithPath: shortPath, isDirectory: true)

    /// Every surface that draws the routes: the dismissed panel, each observed failure, and the
    /// opening that stopped with no observed condition.
    private static let routeDrawingLaunches: [RouteDrawingLaunch] = [
        RouteDrawingLaunch(name: "dismissed", panelAnswer: nil, openAnswer: nil),
        RouteDrawingLaunch(
            name: "missing", panelAnswer: chosenFolder,
            openAnswer: Data(#"{"state":"failed","condition":"missing"}"#.utf8)),
        RouteDrawingLaunch(
            name: "not a folder", panelAnswer: chosenFolder,
            openAnswer: Data(#"{"state":"failed","condition":"not_a_folder"}"#.utf8)),
        RouteDrawingLaunch(
            name: "unreadable", panelAnswer: chosenFolder,
            openAnswer: Data(#"{"state":"failed","condition":"unreadable"}"#.utf8)),
        RouteDrawingLaunch(
            name: "stopped", panelAnswer: chosenFolder, openAnswer: Data("malformed".utf8)),
    ]

    /// Runs `launch` into a real window and returns it with the startup surface it ended on. The
    /// panel is dismissed on every later presentation, so a click on *Browse…* reads nothing.
    private func run(
        _ launch: RouteDrawingLaunch, terminate: @escaping () -> Void = {}
    ) throws -> (launch: WindowLaunch, surface: StartupView) {
        let windowLaunch = makeLaunch(answers: [launch.panelAnswer, nil], terminate: terminate)
        windowLaunch.bridge.openAnswer = launch.openAnswer
        windowLaunch.flow.run()
        let surface = try XCTUnwrap(
            windowLaunch.presenter.contents.last as? StartupView,
            "\(launch.name) ends on a startup surface")
        _ = try laidOutWindow(of: surface)
        return (windowLaunch, surface)
    }

    /// Every call the bridge has taken so far: a click that makes no bridge call leaves it as is.
    private func bridgeCallCount(of bridge: RecordingBridge) -> Int {
        bridge.openedLocations.count + bridge.listedPaths.count + bridge.freed.count
    }

    // S8 — Examples 13, 14 (CP-245; CP-247's activations "performed on the control itself").
    func testEveryDrawnRouteIsEnabledAndEachClickDoesExactlyItsIntent() throws {
        for routeDrawingLaunch in Self.routeDrawingLaunches {
            let name = routeDrawingLaunch.name

            var terminationsOnBrowse = 0
            let browsed = try run(routeDrawingLaunch) { terminationsOnBrowse += 1 }
            let browse = try control(titled: Self.browseTitle, beneath: browsed.surface)
            XCTAssertTrue(browse.isEnabled, "\(name): Browse… is enabled")
            XCTAssertTrue(
                try control(titled: Self.quitTitle, beneath: browsed.surface).isEnabled,
                "\(name): Quit is enabled")
            let presentedBeforeBrowse = browsed.launch.panel.presentedCount

            click(browse)

            XCTAssertEqual(
                browsed.launch.panel.presentedCount, presentedBeforeBrowse + 1,
                "\(name): one click on Browse… presents the panel exactly once")
            XCTAssertEqual(terminationsOnBrowse, 0, "\(name): Browse… ends nothing")

            var terminationsOnQuit = 0
            let quitting = try run(routeDrawingLaunch) { terminationsOnQuit += 1 }
            let presentedBeforeQuit = quitting.launch.panel.presentedCount
            let bridgeCallsBeforeQuit = bridgeCallCount(of: quitting.launch.bridge)

            click(try control(titled: Self.quitTitle, beneath: quitting.surface))

            XCTAssertEqual(terminationsOnQuit, 1, "\(name): one click on Quit ends once")
            XCTAssertEqual(
                bridgeCallCount(of: quitting.launch.bridge), bridgeCallsBeforeQuit,
                "\(name): Quit makes no bridge call")
            XCTAssertEqual(
                quitting.launch.panel.presentedCount, presentedBeforeQuit,
                "\(name): Quit presents no panel")
        }
    }

    /// A surface takes the size it is given and asks for none, whatever its path.
    func testEverySurfaceIsExactlyTheContentAreaItWasGiven() throws {
        let projections: [StartupProjection] = [
            .empty, .reading, .stopped(path: Self.shortPath),
            .failed(path: Self.widestMeasuredPath, condition: .missing),
            .failed(path: Self.pathNoLayoutFits, condition: .missing),
        ]

        for projection in projections {
            let (surface, window) = try presentStartup(projection)

            XCTAssertFalse(surface.subviews.isEmpty, "the surface draws something")
            XCTAssertEqual(contentArea(of: window).size, openingContentSize)
            XCTAssertEqual(frameInWindow(of: surface), contentArea(of: window))
        }
    }
}
