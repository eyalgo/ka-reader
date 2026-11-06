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
    private static let fileCodeGlyphName = "file-code"
    /// `docs/DESIGN.md` § *Components* "The rail": `folder` over *Files*, `git-branch` over *Git*.
    private static let gitBranchGlyphName = "git-branch"

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
    private let treeActs: ReadRunning
    private let main: MainDelivering
    private let terminate: () -> Void
    package private(set) var folderOpened = false

    /// The receiver whose deliveries are the live ones: the open in flight's from the moment it
    /// starts, and the earlier one again if that open does not succeed.
    private var currentReceiver: ModelChangesReceiver?
    /// The receiver the open in flight replaces. The bridge keeps calling it until that open has
    /// returned `opened`, because only then has it drained its callbacks, so it is held until then.
    private var replacedReceiver: ModelChangesReceiver?
    /// The tree the workbench draws, once the workbench is presented and until a startup surface
    /// replaces it.
    private weak var presentedTree: RootItemsView?
    /// The current receiver's deliveries that arrived before the workbench was presented, in order.
    private var heldChanges: [Data] = []

    /// Resolved on the first surface that needs them, as the tree's glyphs are, so a missing file
    /// stops the launch where it is first drawn.
    private lazy var statusGlyphs = StatusGlyphs(
        empty: glyph(named: StatusGlyphNames.emptyGlyphName),
        failure: glyph(named: StatusGlyphNames.failureGlyphName))

    /// `reader` runs the folder open and the file and Git reads, `treeActs` the tree acts, and `main`
    /// is where the bridge's deliveries cross to the main actor. With neither runner given, reads run
    /// concurrently and tree acts on one serial queue; a `reader` given alone runs both, so a test
    /// that runs reads inline sees the acts inline too.
    package init(
        panel: FolderChoosing, bridge: Bridging, glyphs: GlyphSource, presenter: WindowPresenting,
        reader: ReadRunning? = nil, treeActs: ReadRunning? = nil,
        main: MainDelivering = MainQueueDelivery(), terminate: @escaping () -> Void
    ) {
        self.panel = panel
        self.bridge = bridge
        self.glyphs = glyphs
        self.presenter = presenter
        self.reader = reader ?? OffMainReadRunner()
        self.treeActs = treeActs ?? reader ?? SerialReadRunner()
        self.main = main
        self.terminate = terminate
    }

    package func run() { chooseFolder() }

    private func chooseFolder() {
        guard let location = panel.chooseFolder() else {
            presentStartup(.empty)
            return
        }
        presentStartup(.reading)
        let receiver = makeReceiver()
        replacedReceiver = currentReceiver
        currentReceiver = receiver
        heldChanges = []
        reader.run(
            { [bridge] in Self.openAndList(location, changes: receiver, through: bridge) },
            deliver: { [weak self] answer in
                self?.deliver(answer)
            })
    }

    private func makeReceiver() -> ModelChangesReceiver {
        ModelChangesReceiver(bridge: bridge, main: main) { [weak self] receiver, payload in
            self?.receive(payload, from: receiver)
        }
    }

    /// One delivery, on the main actor. Only the current receiver's is live; any other receiver's
    /// is dropped here. A live one waits for the workbench, then draws.
    private func receive(_ payload: Data, from receiver: ModelChangesReceiver) {
        guard receiver === currentReceiver else { return }
        guard let tree = presentedTree else {
            heldChanges.append(payload)
            return
        }
        apply(payload, to: tree)
    }

    private func apply(_ payload: Data, to tree: RootItemsView) {
        guard let changes = BridgePayload.decodeChanges(payload) else { return }
        tree.apply(changes: changes.listings)
    }

    private nonisolated static func openAndList(
        _ location: URL, changes: ModelChangesReceiver, through bridge: Bridging
    ) -> LaunchAnswer {
        let openBuffer = bridge.openFolder(location: location, changes: changes)
        defer { release(openBuffer, through: bridge) }
        guard let result = BridgePayload.decodeOpen(openBuffer) else {
            return .stopped(path: location.path)
        }
        switch result {
        case .failed(let condition): return .failed(path: location.path, condition: condition)
        case .opened: return .opened(listing(at: "", act: .expand, through: bridge))
        }
    }

    private func deliver(_ answer: LaunchAnswer) {
        switch answer {
        case .failed(let path, let condition):
            keepEarlierReceiver()
            presentStartup(.failed(path: path, condition: condition))
        case .stopped(let path):
            keepEarlierReceiver()
            presentStartup(.stopped(path: path))
        case .opened(let root):
            replacedReceiver = nil
            folderOpened = true
            presentWorkbench(root)
        }
    }

    /// An open that did not succeed registered nothing, so the bridge still calls the receiver it
    /// had; that one is the live one again, and the open's own is let go.
    private func keepEarlierReceiver() {
        currentReceiver = replacedReceiver
        replacedReceiver = nil
        heldChanges = []
    }

    private func presentStartup(_ projection: StartupProjection) {
        presentedTree = nil
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
            fileGlyph: glyph(named: Self.fileGlyphName),
            fileCodeGlyph: glyph(named: Self.fileCodeGlyphName), statusGlyphs: statusGlyphs)
        view.show(root)
        view.listTree = { [bridge, treeActs] path, act, answer in
            treeActs.run({ Self.listing(at: path, act: act, through: bridge) }, deliver: answer)
        }
        let workbench = WorkbenchView(
            rootItemsView: view, statusGlyphs: statusGlyphs,
            railFolderGlyph: glyph(named: Self.folderGlyphName),
            railGitGlyph: glyph(named: Self.gitBranchGlyphName))
        workbench.selectFile = { [bridge, reader] path, answer in
            reader.run({ Self.verdict(at: path, through: bridge) }, deliver: answer)
        }
        // A scroll is the position act: it goes in order on the tree-act queue, frees its buffer
        // and draws nothing.
        workbench.filePosition = { [bridge, treeActs] path, position in
            treeActs.run(
                { Self.send(position, forFileAt: path, through: bridge) }, deliver: { _ in })
        }
        workbench.readGit = { [bridge, reader] answer in
            reader.run({ Self.gitItem(through: bridge) }, deliver: answer)
        }
        presenter.present(workbench)
        presentedTree = view
        let held = heldChanges
        heldChanges = []
        for payload in held { apply(payload, to: view) }
    }

    private nonisolated static func gitItem(through bridge: Bridging) -> GitItem {
        let buffer = bridge.readGit()
        defer { release(buffer, through: bridge) }
        return BridgePayload.decodeGit(buffer)
    }

    private nonisolated static func verdict(at path: String, through bridge: Bridging)
        -> FileVerdict?
    {
        let buffer = bridge.selectFile(
            path: path, act: .open, position: BridgePayload.encodePosition(.topLeft))
        defer { release(buffer, through: bridge) }
        return BridgePayload.decodeFile(buffer)
    }

    private nonisolated static func send(
        _ position: ReadingPosition, forFileAt path: String, through bridge: Bridging
    ) {
        let buffer = bridge.selectFile(
            path: path, act: .position, position: BridgePayload.encodePosition(position))
        release(buffer, through: bridge)
    }

    private nonisolated static func listing(
        at path: String, act: DisclosureAct, through bridge: Bridging
    ) -> RootListing? {
        let buffer = bridge.listTree(path: path, act: act)
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
