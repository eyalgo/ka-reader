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
        let (owners, window) = try ownersAndWindow(of: host)
        let event = try mouseEvent(.mouseMoved, at: point, in: host, window: window)
        for owner in owners { owner.mouseMoved(with: event) }
    }

    /// The pointer enters the host at `point`.
    static func enter(at point: NSPoint, in host: NSView) throws {
        let (owners, window) = try ownersAndWindow(of: host)
        let event = try crossing(.mouseEntered, at: point, in: host, window: window)
        for owner in owners { owner.mouseEntered(with: event) }
    }

    /// The pointer leaves the host at `point`.
    static func leave(at point: NSPoint, in host: NSView) throws {
        let (owners, window) = try ownersAndWindow(of: host)
        let event = try crossing(.mouseExited, at: point, in: host, window: window)
        for owner in owners { owner.mouseExited(with: event) }
    }

    /// The tracking area the tooltip installed on `host`, for tests that read its options.
    static func trackingArea(of host: NSView) -> NSTrackingArea? {
        host.trackingAreas.first { $0.owner is LetterTooltip }
    }

    /// The tracking area the hover unit installed on `host`, for tests that read its options.
    static func hoverTrackingArea(of host: NSView) -> NSTrackingArea? {
        host.trackingAreas.first { $0.owner is RowHover }
    }

    /// Every owner on the host that is a tooltip or a hover unit, the way a window hands an event
    /// to every tracking area under the pointer. An owner AppKit installed itself (a scroll view's)
    /// is not one of them.
    private static func ownersAndWindow(of host: NSView) throws -> ([NSResponder], NSWindow) {
        let owners = host.trackingAreas.compactMap { area -> NSResponder? in
            guard area.owner is LetterTooltip || area.owner is RowHover else { return nil }
            return area.owner as? NSResponder
        }
        let found = try XCTUnwrap(
            owners.isEmpty ? nil : owners, "the host carries no tooltip or hover tracking area")
        let window = try unsafe XCTUnwrap(host.window, "the host is in no window")
        return (found, window)
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
        try unsafe XCTUnwrap(
            NSEvent.enterExitEvent(
                with: type, location: host.convert(point, to: nil), modifierFlags: [], timestamp: 0,
                windowNumber: window.windowNumber, context: nil, eventNumber: 0, trackingNumber: 0,
                userData: nil))
    }
}

/// A `KeyWindowSource` that starts key, flips on demand and fires the matching moment, because the
/// test windows never become key. The test sets the point the pointer reads as; it is in the
/// coordinates of whichever host asks, so a case sets it for the host it drives.
@MainActor
final class KeyWindowDouble {
    private final class Subscription {}

    private struct Observer {
        weak var subscription: AnyObject?
        let stoppedBeingKey: KeyWindowSource.Moment
        let becameKey: KeyWindowSource.Moment
    }

    private(set) var isKey = true
    var pointer: NSPoint?
    private var observers: [Observer] = []

    var source: KeyWindowSource {
        KeyWindowSource(
            isKey: { [self] _ in isKey },
            observe: { [self] _, stoppedBeingKey, becameKey in
                let subscription = Subscription()
                observers.append(
                    Observer(
                        subscription: subscription, stoppedBeingKey: stoppedBeingKey,
                        becameKey: becameKey))
                return subscription
            },
            pointer: { [self] _ in pointer })
    }

    /// The window stops being key: the state flips, then the moment is delivered.
    func stopBeingKey() {
        guard isKey else { return }
        isKey = false
        for observer in observers where observer.subscription != nil { observer.stoppedBeingKey() }
    }

    /// The window becomes key: the state flips, then the moment is delivered.
    func becomeKey() {
        guard !isKey else { return }
        isKey = true
        for observer in observers where observer.subscription != nil { observer.becameKey() }
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
