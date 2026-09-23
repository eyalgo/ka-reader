import AppKit
import Shell

/// Hands launch to `Shell`: once the application has finished launching, the launch flow runs.
@MainActor
final class AppDelegate: NSObject, NSApplicationDelegate {
    private var flow: LaunchFlow?

    func applicationDidFinishLaunching(_ notification: Notification) {
        let flow = LaunchFlow(
            panel: OpenFolderPanel(),
            bridge: NativeBridge(),
            glyphs: BundleGlyphSource(),
            presenter: MainWindowPresenter())
        self.flow = flow
        NSApplication.shared.activate(ignoringOtherApps: true)
        flow.run()
    }

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        true
    }
}
