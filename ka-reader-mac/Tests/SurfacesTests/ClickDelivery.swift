import AppKit
import XCTest

/// A click delivered the way a key window delivers one: the press goes to the deepest view under
/// the pointer (`hitTest`), and whatever that view does not take travels up its responder chain on
/// AppKit's own terms. A test that calls a view's `mouseDown` itself skips both, so it cannot see a
/// label or a glyph that takes the press for itself.
///
/// The test windows are never key (no run loop runs), and `NSWindow.sendEvent` hands a press in a
/// window that is not key only to a view that takes the first mouse; this skips that one gate and
/// nothing else. The release is queued before the press, so a view that tracks a press in its own
/// loop finds it, and whatever is left is drained so nothing reaches a later test.
@MainActor
enum ClickDelivery {
    /// Clicks at `point`, in `view`'s own coordinates, and returns the view the press went to.
    @discardableResult
    static func click(at point: NSPoint, in view: NSView) throws -> NSView {
        let window = try unsafe XCTUnwrap(view.window, "the view is in no window")
        let content = try XCTUnwrap(window.contentView, "the window has no content")
        content.layoutSubtreeIfNeeded()
        let inWindow = view.convert(point, to: nil)
        let underPointer = unsafe content.superview?.convert(inWindow, from: nil) ?? inWindow
        let hit = try XCTUnwrap(content.hitTest(underPointer), "nothing is under the pointer")
        let app = NSApplication.shared
        app.postEvent(try event(.leftMouseUp, at: inWindow, in: window), atStart: false)
        hit.mouseDown(with: try event(.leftMouseDown, at: inWindow, in: window))
        while app.nextEvent(
            matching: .leftMouseUp, until: .distantPast, inMode: .default, dequeue: true) != nil
        {}
        return hit
    }

    /// Clicks the middle of `view`.
    @discardableResult
    static func clickMiddle(of view: NSView) throws -> NSView {
        try click(at: NSPoint(x: view.bounds.midX, y: view.bounds.midY), in: view)
    }

    private static func event(
        _ type: NSEvent.EventType, at location: NSPoint, in window: NSWindow
    ) throws -> NSEvent {
        try XCTUnwrap(
            NSEvent.mouseEvent(
                with: type, location: location, modifierFlags: [], timestamp: 0,
                windowNumber: window.windowNumber, context: nil, eventNumber: 0, clickCount: 1,
                pressure: type == .leftMouseUp ? 0 : 1))
    }
}
