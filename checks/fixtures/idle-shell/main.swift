import AppKit

// The negative control of checks/renderer.sh: the shape the shell took when it opened an empty
// window (SDD C-I3) — an event loop and one titled window. It has no application delegate, so
// nothing runs at launch that could present a panel, sheet, alert or modal. A control that did
// present one would be the finding CP-149's immediate failure exists to catch.
MainActor.assumeIsolated {
    let application = NSApplication.shared
    application.setActivationPolicy(.regular)

    let window = NSWindow(
        contentRect: NSRect(x: 0, y: 0, width: 480, height: 640),
        styleMask: [.titled, .closable],
        backing: .buffered,
        defer: false)
    window.title = "idle-shell"
    window.center()
    window.makeKeyAndOrderFront(nil)

    application.run()
}
