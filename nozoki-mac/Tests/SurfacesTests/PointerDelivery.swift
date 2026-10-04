import AppKit
import XCTest

@testable import Surfaces

/// The pointer moved the way a window moves it: a synthetic moved, entered or exited event goes to
/// the owner of the tracking area the host carries, so the tracking wiring is proved and not only
/// the entry points behind it. The test windows run no run loop, so nothing here is queued: each
/// event is handed straight to the owner, the way `ClickDelivery` hands a press to its view.
@MainActor
enum PointerDelivery {
    /// The pointer moves to `point`, in `host`'s own coordinates.
    static func move(to point: NSPoint, in host: NSView) throws {
        let (owner, window) = try ownerAndWindow(of: host)
        owner.mouseMoved(with: try mouseEvent(.mouseMoved, at: point, in: host, window: window))
    }

    /// The pointer enters the host at `point`.
    static func enter(at point: NSPoint, in host: NSView) throws {
        let (owner, window) = try ownerAndWindow(of: host)
        owner.mouseEntered(with: try crossing(.mouseEntered, at: point, in: host, window: window))
    }

    /// The pointer leaves the host at `point`.
    static func leave(at point: NSPoint, in host: NSView) throws {
        let (owner, window) = try ownerAndWindow(of: host)
        owner.mouseExited(with: try crossing(.mouseExited, at: point, in: host, window: window))
    }

    /// The tracking area the tooltip installed on `host`, for tests that read its options.
    static func trackingArea(of host: NSView) -> NSTrackingArea? {
        host.trackingAreas.first { $0.owner is LetterTooltip }
    }

    private static func ownerAndWindow(of host: NSView) throws -> (NSResponder, NSWindow) {
        let area = try XCTUnwrap(
            trackingArea(of: host), "the host carries no tooltip tracking area")
        let owner = try XCTUnwrap(area.owner as? NSResponder)
        let window = try XCTUnwrap(host.window, "the host is in no window")
        return (owner, window)
    }

    private static func mouseEvent(
        _ type: NSEvent.EventType, at point: NSPoint, in host: NSView, window: NSWindow
    ) throws -> NSEvent {
        try XCTUnwrap(
            NSEvent.mouseEvent(
                with: type, location: host.convert(point, to: nil), modifierFlags: [], timestamp: 0,
                windowNumber: window.windowNumber, context: nil, eventNumber: 0, clickCount: 0,
                pressure: 0))
    }

    private static func crossing(
        _ type: NSEvent.EventType, at point: NSPoint, in host: NSView, window: NSWindow
    ) throws -> NSEvent {
        try XCTUnwrap(
            NSEvent.enterExitEvent(
                with: type, location: host.convert(point, to: nil), modifierFlags: [], timestamp: 0,
                windowNumber: window.windowNumber, context: nil, eventNumber: 0, trackingNumber: 0,
                userData: nil))
    }
}

/// A `TooltipRest` that records what it was asked for and fires on demand, because the test
/// windows run no run loop. A cancelled rest stays on the list: firing it is how a test proves a
/// cancelled rest shows nothing.
@MainActor
final class TooltipRestDouble {
    struct Request {
        let interval: TimeInterval
        fileprivate let action: @MainActor () -> Void
        fileprivate(set) var cancelled = false
    }

    private(set) var requests: [Request] = []

    var rest: TooltipRest {
        TooltipRest { [self] interval, action in
            let index = requests.count
            requests.append(Request(interval: interval, action: action))
            return { [self] in requests[index].cancelled = true }
        }
    }

    /// Runs the `index`th request's action, cancelled or not.
    func fire(_ index: Int) {
        requests[index].action()
    }

    /// Runs the newest request's action.
    func fireLast() {
        fire(requests.count - 1)
    }
}
