import AppKit
import Surfaces

/// Puts the launch's one view in the launch's one window.
@MainActor
package protocol WindowPresenting {
    func present(_ content: RootItemsView)
}

/// The one window (SDD § 3 `mac-shell`). It holds no content of its own beyond the view given.
@MainActor
package final class MainWindowPresenter: WindowPresenting {
    private static let initialSize = NSSize(width: 480, height: 640)
    private var window: NSWindow?

    package init() {}

    package func present(_ content: RootItemsView) {
        let window = NSWindow(
            contentRect: NSRect(origin: .zero, size: Self.initialSize),
            styleMask: [.titled, .closable, .miniaturizable, .resizable],
            backing: .buffered,
            defer: false)
        window.contentView = content
        window.title = "Nozoki"
        window.center()
        window.makeKeyAndOrderFront(nil)
        self.window = window
    }
}
