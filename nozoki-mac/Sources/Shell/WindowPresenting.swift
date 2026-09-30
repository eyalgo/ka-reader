import AppKit
import Surfaces

/// Puts the launch's one view in the launch's one window.
@MainActor
package protocol WindowPresenting {
    /// Shows `content` in the one window, in place of what that window showed before. After it
    /// returns, `content.window` is that window and its content area is the size it was before the
    /// call.
    func present(_ content: NSView)
}

/// The one window (SDD § 3 `mac-shell`). It holds no content of its own beyond the view given.
///
/// The window's size is this type's and never a surface's (change_spec.md CP-236): a surface is
/// placed inside a view the window owns, and held there more weakly than AppKit holds a window's
/// size. A surface whose own layout asks for another size is then the wrong size itself, inside a
/// window that has not moved.
@MainActor
package final class MainWindowPresenter: WindowPresenting {
    private static let initialSize = NSSize(width: 480, height: 640)

    // One below the priority AppKit keeps a window's size with. Replacing the content view with
    // the surface, autoresizing it, and restoring the size afterwards each let a surface's own
    // height become the window's (change_design.md M1–M3).
    private static let surfaceFillPriority = NSLayoutConstraint.Priority(
        NSLayoutConstraint.Priority.windowSizeStayPut.rawValue - 1)

    private let surfaceHost = NSView()
    private var window: NSWindow?
    private var presentedSurface: NSView?

    package init() {}

    package func present(_ content: NSView) {
        let window = self.window ?? makeWindow()
        self.window = window
        replaceSurface(with: content)
        window.makeKeyAndOrderFront(nil)
    }

    private func makeWindow() -> NSWindow {
        let window = NSWindow(
            contentRect: NSRect(origin: .zero, size: Self.initialSize),
            styleMask: [.titled, .closable, .miniaturizable, .resizable],
            backing: .buffered,
            defer: false)
        window.title = "Nozoki"
        window.contentView = surfaceHost
        window.center()
        return window
    }

    private func replaceSurface(with content: NSView) {
        presentedSurface?.removeFromSuperview()
        presentedSurface = content

        content.translatesAutoresizingMaskIntoConstraints = false
        surfaceHost.addSubview(content)
        let bottom = content.bottomAnchor.constraint(equalTo: surfaceHost.bottomAnchor)
        let trailing = content.trailingAnchor.constraint(equalTo: surfaceHost.trailingAnchor)
        bottom.priority = Self.surfaceFillPriority
        trailing.priority = Self.surfaceFillPriority
        NSLayoutConstraint.activate([
            content.topAnchor.constraint(equalTo: surfaceHost.topAnchor),
            content.leadingAnchor.constraint(equalTo: surfaceHost.leadingAnchor),
            bottom,
            trailing,
        ])
    }
}
