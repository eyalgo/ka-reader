import AppKit
import Surfaces

/// Puts the launch's one view in the launch's one window.
@MainActor
package protocol WindowPresenting {
    func present(_ content: NSView)
}

/// The one window (SDD § 3 `mac-shell`). It holds no content of its own beyond the view given.
@MainActor
package final class MainWindowPresenter: WindowPresenting {
    private static let initialSize = NSSize(width: 480, height: 640)
    private var window: NSWindow?

    package init() {}

    package func present(_ content: NSView) {
        let window: NSWindow
        if let existing = self.window {
            window = existing
        } else {
            window = NSWindow(
                contentRect: NSRect(origin: .zero, size: Self.initialSize),
                styleMask: [.titled, .closable, .miniaturizable, .resizable],
                backing: .buffered,
                defer: false)
            window.title = "Nozoki"
            window.center()
            self.window = window
        }
        window.contentView = content
        window.makeKeyAndOrderFront(nil)
    }
}
