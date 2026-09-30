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
}
