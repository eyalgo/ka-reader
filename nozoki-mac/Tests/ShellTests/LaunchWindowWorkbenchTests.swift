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
}
