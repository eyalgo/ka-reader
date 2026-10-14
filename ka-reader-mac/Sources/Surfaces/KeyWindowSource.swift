import AppKit

/// Whether a host's window is the key window, when that changes, and where the pointer is. The hover
/// fill and the tooltip are drawn from it beside the pointer's own events (`docs/DESIGN.md`
/// § Components "Rows" and "The tooltip"). `live` reads the window the host is in at the moment of
/// asking; a test passes a double that flips on demand, because the test windows never become key.
package struct KeyWindowSource {
    package typealias Moment = @MainActor () -> Void

    /// Whether `host`'s window is the key window now.
    package let isKey: @MainActor (_ host: NSView) -> Bool

    /// Delivers the two moments to `stoppedBeingKey` and `becameKey`, on the main actor. The
    /// subscription lasts as long as what it returns is held.
    package let observe:
        @MainActor (
            _ host: NSView, _ stoppedBeingKey: @escaping Moment, _ becameKey: @escaping Moment
        ) -> AnyObject

    /// Where the pointer is now, in `host`'s coordinates, or nil when the source has no answer.
    package let pointer: @MainActor (_ host: NSView) -> NSPoint?

    package init(
        isKey: @escaping @MainActor (_ host: NSView) -> Bool,
        observe:
            @escaping @MainActor (
                _ host: NSView, _ stoppedBeingKey: @escaping Moment,
                _ becameKey: @escaping Moment
            ) -> AnyObject,
        pointer: @escaping @MainActor (_ host: NSView) -> NSPoint?
    ) {
        self.isKey = isKey
        self.observe = observe
        self.pointer = pointer
    }

    /// Where the pointer is now, when it is a point the host can act on: the source has an answer,
    /// the host is not hidden, and the point lies inside the host's visible rect. A row scrolled out
    /// of the clip still has a frame in the host's coordinates, so the bound is the host's, not the
    /// rows'.
    @MainActor func pointerInVisibleHost(_ host: NSView) -> NSPoint? {
        guard !host.isHiddenOrHasHiddenAncestor, let point = pointer(host),
            host.visibleRect.contains(point)
        else { return nil }
        return point
    }

    /// The window's own answers. The pointer is the window's `mouseLocationOutsideOfEventStream`,
    /// converted into the host's coordinates.
    package static let live = KeyWindowSource(
        isKey: { host in unsafe host.window?.isKeyWindow ?? false },
        observe: { host, stoppedBeingKey, becameKey in
            LiveKeyWindowObservation(
                host: host, stoppedBeingKey: stoppedBeingKey, becameKey: becameKey)
        },
        pointer: { host in
            guard let window = unsafe host.window else { return nil }
            return host.convert(window.mouseLocationOutsideOfEventStream, from: nil)
        })
}

/// Listens to every window's key notifications and acts on those of the host's window as it is at
/// that moment: a host joins its window after it is built, so the window cannot be named up front.
/// The observer is selector-based, so it ends with this object.
@MainActor
private final class LiveKeyWindowObservation: NSObject {
    private weak var host: NSView?
    private let stoppedBeingKey: KeyWindowSource.Moment
    private let becameKey: KeyWindowSource.Moment

    init(
        host: NSView, stoppedBeingKey: @escaping KeyWindowSource.Moment,
        becameKey: @escaping KeyWindowSource.Moment
    ) {
        self.host = host
        self.stoppedBeingKey = stoppedBeingKey
        self.becameKey = becameKey
        super.init()
        let center = NotificationCenter.default
        center.addObserver(
            self, selector: #selector(windowResignedKey), name: NSWindow.didResignKeyNotification,
            object: nil)
        center.addObserver(
            self, selector: #selector(windowBecameKey), name: NSWindow.didBecomeKeyNotification,
            object: nil)
    }

    @objc private func windowResignedKey(_ notification: Notification) {
        if isHostWindow(notification) { stoppedBeingKey() }
    }

    @objc private func windowBecameKey(_ notification: Notification) {
        if isHostWindow(notification) { becameKey() }
    }

    private func isHostWindow(_ notification: Notification) -> Bool {
        guard let window = notification.object as? NSWindow else { return false }
        return unsafe window === host?.window
    }
}
