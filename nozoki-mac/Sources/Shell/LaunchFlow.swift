import AppKit
import Surfaces

private enum StatusGlyphNames {
    /// `docs/DESIGN.md` § *Components* "Status messages": `info` leads an empty or pending state,
    /// `circle-alert` a failure.
    static let emptyGlyphName = "info"

    static let failureGlyphName = "circle-alert"
}

/// The main-actor launch controller. It owns panel retries and replaces content in one window.
@MainActor
package final class LaunchFlow {
    private static let rootPath = ""
    private static let folderGlyphName = "folder"
    private static let fileGlyphName = "file"

    private enum LaunchAnswer {
        case opened(RootListing?)
        case failed(path: String, condition: OpeningCondition)
        case stopped(path: String)
    }

    private let panel: FolderChoosing
    private let bridge: Bridging
    private let glyphs: GlyphSource
    private let presenter: WindowPresenting
    private let reader: ReadRunning
    private let terminate: () -> Void
    package private(set) var folderOpened = false

    /// Resolved on the first surface that needs them, as the tree's glyphs are, so a missing file
    /// stops the launch where it is first drawn.
    private lazy var statusGlyphs = StatusGlyphs(
        empty: glyph(named: StatusGlyphNames.emptyGlyphName),
        failure: glyph(named: StatusGlyphNames.failureGlyphName))

    package init(
        panel: FolderChoosing, bridge: Bridging, glyphs: GlyphSource, presenter: WindowPresenting,
        reader: ReadRunning = OffMainReadRunner(), terminate: @escaping () -> Void
    ) {
        self.panel = panel
        self.bridge = bridge
        self.glyphs = glyphs
        self.presenter = presenter
        self.reader = reader
        self.terminate = terminate
    }

    package func run() { chooseFolder() }

    private func chooseFolder() {
        guard let location = panel.chooseFolder() else {
            presentStartup(.empty)
            return
        }
        presentStartup(.reading)
        reader.run(
            { [bridge] in Self.openAndList(location, through: bridge) },
            deliver: { [weak self] answer in
                self?.deliver(answer)
            })
    }

    private nonisolated static func openAndList(_ location: URL, through bridge: Bridging)
        -> LaunchAnswer
    {
        let openBuffer = bridge.openFolder(location: location)
        defer { release(openBuffer, through: bridge) }
        guard let result = BridgePayload.decodeOpen(openBuffer) else {
            return .stopped(path: location.path)
        }
        switch result {
        case .failed(let condition): return .failed(path: location.path, condition: condition)
        case .opened: return .opened(listing(at: "", through: bridge))
        }
    }

    private func deliver(_ answer: LaunchAnswer) {
        switch answer {
        case .failed(let path, let condition):
            presentStartup(.failed(path: path, condition: condition))
        case .stopped(let path): presentStartup(.stopped(path: path))
        case .opened(let root):
            folderOpened = true
            presentWorkbench(root)
        }
    }

    private func presentStartup(_ projection: StartupProjection) {
        presenter.present(
            StartupView(projection: projection, glyphs: statusGlyphs) { [weak self] intent in
                switch intent {
                case .browse: self?.chooseFolder()
                case .quit: self?.terminate()
                }
            })
    }

    private func presentWorkbench(_ root: RootListing?) {
        let view = RootItemsView(
            folderGlyph: glyph(named: Self.folderGlyphName),
            fileGlyph: glyph(named: Self.fileGlyphName), statusGlyphs: statusGlyphs)
        view.show(root)
        view.listTree = { [bridge, reader] path, answer in
            reader.run({ Self.listing(at: path, through: bridge) }, deliver: answer)
        }
        let workbench = WorkbenchView(rootItemsView: view, statusGlyphs: statusGlyphs)
        workbench.selectFile = { [bridge, reader] path, answer in
            reader.run({ Self.verdict(at: path, through: bridge) }, deliver: answer)
        }
        presenter.present(workbench)
    }

    private nonisolated static func verdict(at path: String, through bridge: Bridging)
        -> FileVerdict?
    {
        let buffer = bridge.selectFile(path: path)
        defer { release(buffer, through: bridge) }
        return BridgePayload.decodeFile(buffer)
    }

    private nonisolated static func listing(at path: String, through bridge: Bridging)
        -> RootListing?
    {
        let buffer = bridge.listTree(path: path)
        defer { release(buffer, through: bridge) }
        return BridgePayload.decodeRoot(buffer)
    }

    private nonisolated static func release(_ buffer: BridgeBuffer?, through bridge: Bridging) {
        if let buffer { bridge.free(buffer) }
    }

    private func glyph(named name: String) -> NSImage {
        guard let image = glyphs.glyph(named: name) else {
            preconditionFailure("the assembled bundle carries \(name).svg")
        }
        return image
    }
}
