import AppKit
import Surfaces

/// The launch: present the Open panel, pass its answer to the bridge, list the root, draw it.
///
/// The panel comes first and nothing is asked before it (CP-81). What the panel returned is the
/// only thing handed to `openFolder`; a cancel is passed as `nil` and the flow goes on, so the
/// bridge decides what a cancel means (CP-90). The flow never presents the panel a second time,
/// never exits on a cancel and creates one window.
@MainActor
package final class LaunchFlow {
    /// The root of the open folder, as `nozoki_list_tree` reads it.
    private static let rootPath = ""
    private static let folderGlyphName = "folder"
    private static let fileGlyphName = "file"

    /// Whether the bridge reported the last `openFolder` as having replaced the session.
    package private(set) var folderOpened = false

    private let panel: FolderChoosing
    private let bridge: Bridging
    private let glyphs: GlyphSource
    private let presenter: WindowPresenting

    package init(
        panel: FolderChoosing, bridge: Bridging, glyphs: GlyphSource, presenter: WindowPresenting
    ) {
        self.panel = panel
        self.bridge = bridge
        self.glyphs = glyphs
        self.presenter = presenter
    }

    package func run() {
        let location = panel.chooseFolder()

        let openBuffer = bridge.openFolder(location: location)
        folderOpened = BridgePayload.decodeOpened(openBuffer)
        release(openBuffer)

        let listBuffer = bridge.listTree(path: Self.rootPath)
        let root = BridgePayload.decodeRoot(listBuffer)
        release(listBuffer)

        let view = RootItemsView(
            folderGlyph: glyph(named: Self.folderGlyphName),
            fileGlyph: glyph(named: Self.fileGlyphName))
        view.show(root)
        presenter.present(view)
    }

    private func release(_ buffer: BridgeBuffer?) {
        if let buffer {
            bridge.free(buffer)
        }
    }

    private func glyph(named name: String) -> NSImage {
        guard let image = glyphs.glyph(named: name) else {
            preconditionFailure("the assembled bundle carries \(name).svg (checks/bundle.sh)")
        }
        return image
    }
}
