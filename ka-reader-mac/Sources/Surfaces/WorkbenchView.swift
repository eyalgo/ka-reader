import AppKit

/// `docs/DESIGN.md` § *Elevation & Depth*: the one `{spacing.hairline}` between the sidebar and
/// the reading panel.
private let hairlineWidth: CGFloat = 1

/// The verdict a file read answered, or `nil` when none came.
package typealias SelectFileAnswer = @MainActor (FileVerdict?) -> Void

/// The read a selected file asks for: the entry's path and the sink its answer goes to (the shape of
/// `ListTreeIntent`).
package typealias SelectFileIntent =
    @MainActor (_ path: String, _ answer: @escaping SelectFileAnswer) -> Void

/// The Git item a read answered.
package typealias GitAnswer = @MainActor (GitItem) -> Void

/// The Git read the workbench asks for, once: the sink its answer goes to (the shape of
/// `SelectFileIntent`, without a path, because the bridge holds the one item).
package typealias GitReadIntent = @MainActor (_ answer: @escaping GitAnswer) -> Void

/// Where the reader's scroll of the open file reached: the latest selection's path, and the position.
package typealias FilePositionIntent =
    @MainActor (_ path: String, _ position: ReadingPosition) -> Void

/// Makes a sink answer once.
private final class SelectionLatch {
    var fired = false
}

/// The one-window composition for an opened folder: three parts side by side, filling the size they
/// are given. The first is the rail, the Files/Git switch. The second is the sidebar, always
/// `{spacing.sidebar-width}` wide, holding the tree it was handed and the Git view and showing one
/// of them. The third is the reading panel, which takes the rest of the width and draws one status
/// message, led by the empty glyph, while no file is selected. Between the sidebar and the panel
/// the workbench draws one hairline itself.
///
/// A switch hides the sidebar view that is not shown and never removes or rebuilds it, so the
/// tree keeps its scroll, its open folders and its selection, and the reading panel is not touched
/// at all. A reader of this view gets its drawn view tree and nothing else (change_spec.md CP-246):
/// its direct subviews are exactly the three parts, the rail first.
@MainActor
package final class WorkbenchView: NSView {
    /// `docs/DESIGN.md` § *Layout*: the sidebar is `{spacing.sidebar-width}` wide and does not
    /// resize.
    private static let sidebarWidth: CGFloat = 260

    package let rootItemsView: RootItemsView

    /// The Files/Git switch, the first part.
    package let rail: RailSwitchView

    /// The second part, which holds the tree and the Git view.
    package let sidebar = NSView()

    /// The Git view: shown in place of the tree while Git is the active entry.
    package let gitView: GitView

    /// The reading panel: the prompt until a file is selected, then the pending read, then the
    /// file's verdict, or the fault when the read answers nothing.
    package let readingPanel: ReadingPanelView

    /// Set by the view's owner, and called on the main actor once per file selection with the
    /// entry's `path` and a sink for the verdict. While it is unset a selection still moves the bar,
    /// and no answer ever comes. Only the latest selection's sink draws anything (CP-278).
    package var selectFile: SelectFileIntent?

    /// Set by the view's owner, and called on the main actor exactly once per workbench, on the
    /// first showing of the Git view, with a sink for the Git item. The first answer the sink
    /// receives is drawn and kept: a later switch to Git draws it again and asks nothing.
    package var readGit: GitReadIntent?

    /// Set by the view's owner, and called on the main actor with the latest selection's path each
    /// time the reader scrolls the open file.
    package var filePosition: FilePositionIntent?

    /// An automatic update of the open file. It is drawn when `openFile.path` is the path of the
    /// reader's latest selection, and the update is recorded so that selection's own answer, which
    /// is older, draws nothing. For any other path it draws nothing: the reader has moved on (CP-1024).
    package func apply(openFile: OpenFileUpdate) {
        guard openFile.path == latestSelectionPath else { return }
        readingPanel.update(
            path: openFile.path, verdict: openFile.verdict, position: openFile.position)
        hasUpdateForLatestSelection = true
    }

    /// The path of the reader's latest selection, and whether an update has been drawn for it since
    /// it was raised.
    private var latestSelectionPath: String?
    private var hasUpdateForLatestSelection = false

    /// Counts file selections: a sink applies only while its selection is still the latest.
    private var selectionGeneration = 0

    /// Whether the Git view has been shown, and so whether `readGit` has been raised.
    private var hasAskedGit = false

    /// The path of the file a Git row opened, while it is the open file; nil once a selection made
    /// in the tree replaces it.
    private var openGitPath: String?

    /// Places the rail, the supplied tree and the Git view in the sidebar, and the reading prompt
    /// beside them, using the supplied empty-state image and the rail's two glyphs.
    package init(
        rootItemsView: RootItemsView, statusGlyphs: StatusGlyphs, railFolderGlyph: NSImage,
        railGitGlyph: NSImage, keyWindow: KeyWindowSource = .live
    ) {
        self.rootItemsView = rootItemsView
        rail = RailSwitchView(folderGlyph: railFolderGlyph, gitGlyph: railGitGlyph)
        gitView = GitView(statusGlyphs: statusGlyphs, keyWindow: keyWindow)
        readingPanel = ReadingPanelView(statusGlyphs: statusGlyphs)
        super.init(frame: .zero)
        rootItemsView.fileSelected = { [weak self] entry in self?.selectFromTree(entry) }
        gitView.rowActivated = { [weak self] path in self?.selectFromGit(path) }
        rail.entryChosen = { [weak self] entry in self?.show(entry) }
        readingPanel.positionChanged = { [weak self] position in
            guard let self, let path = self.latestSelectionPath else { return }
            self.filePosition?(path, position)
        }
        for pane in [rootItemsView, gitView] {
            pane.translatesAutoresizingMaskIntoConstraints = false
            sidebar.addSubview(pane)
            NSLayoutConstraint.activate([
                pane.leadingAnchor.constraint(equalTo: sidebar.leadingAnchor),
                pane.trailingAnchor.constraint(equalTo: sidebar.trailingAnchor),
                pane.topAnchor.constraint(equalTo: sidebar.topAnchor),
                pane.bottomAnchor.constraint(equalTo: sidebar.bottomAnchor),
            ])
        }
        gitView.isHidden = true
        for part in [rail, sidebar, readingPanel] {
            part.translatesAutoresizingMaskIntoConstraints = false
            addSubview(part)
        }

        // Plain parts and no divider: the sidebar "does not resize" (DESIGN § Layout; FDR R-137
        // puts pane resizing outside the product), so its width is held at required priority and
        // nothing between the parts takes a press. A split view held the width against a divider
        // drag only by tying the drag's own priority (the-window-holds-its-layout, CP-254). The
        // rail states its own width.
        NSLayoutConstraint.activate([
            rail.leadingAnchor.constraint(equalTo: leadingAnchor),
            rail.topAnchor.constraint(equalTo: topAnchor),
            rail.bottomAnchor.constraint(equalTo: bottomAnchor),
            sidebar.leadingAnchor.constraint(equalTo: rail.trailingAnchor),
            sidebar.topAnchor.constraint(equalTo: topAnchor),
            sidebar.bottomAnchor.constraint(equalTo: bottomAnchor),
            sidebar.widthAnchor.constraint(equalToConstant: Self.sidebarWidth),
            readingPanel.leadingAnchor.constraint(
                equalTo: sidebar.trailingAnchor, constant: hairlineWidth),
            readingPanel.trailingAnchor.constraint(equalTo: trailingAnchor),
            readingPanel.topAnchor.constraint(equalTo: topAnchor),
            readingPanel.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }

    /// Shows one sidebar view and hides the other, and touches nothing else. Showing Git for the
    /// first time asks the owner for the Git item. Showing Files after a Git row opened a file shows
    /// that file in the tree as left, with no selection event, no folder opened and no scroll.
    private func show(_ entry: RailEntry) {
        rail.active = entry
        switch entry {
        case .files:
            gitView.isHidden = true
            rootItemsView.isHidden = false
            if let openGitPath { rootItemsView.showOpenFile(path: openGitPath) }
        case .git:
            rootItemsView.isHidden = true
            gitView.isHidden = false
            askForGitOnce()
        }
    }

    private func askForGitOnce() {
        guard !hasAskedGit else { return }
        hasAskedGit = true
        let latch = SelectionLatch()
        readGit? { [weak self] item in
            guard !latch.fired else { return }
            latch.fired = true
            self?.gitView.show(item)
            // The tree's markers come from this one item and from nothing else (CP-581).
            self?.rootItemsView.showMarkers(TreeMarkers(item))
        }
    }

    /// A tree selection: it moves the tree's bar to `entry`, and clears a Git row's.
    private func selectFromTree(_ entry: Entry) {
        openGitPath = nil
        gitView.clearSelection()
        readFile(at: entry.path) { [rootItemsView] in rootItemsView.markOpenFile(path: entry.path) }
    }

    /// A Git row's activation: the same select path a tree selection takes. The tree is hidden
    /// while it happens, so it is shown the open file when Files is next shown.
    private func selectFromGit(_ path: String) {
        openGitPath = path
        readFile(at: path) {}
    }

    /// Runs `markBar`, draws the panel's *reading* state and then asks the owner to read `path`. The
    /// panel shows the verdict under `path` once it comes, if no later selection has been made. A
    /// `nil` answer draws the *stopped* state for that path and leaves the bar where it is.
    private func readFile(at path: String, markBar: () -> Void) {
        selectionGeneration += 1
        let generation = selectionGeneration
        latestSelectionPath = path
        hasUpdateForLatestSelection = false
        markBar()
        // Before the intent is raised, never after: an owner may answer inside that call, and a
        // *reading* drawn afterwards would overwrite the verdict just drawn.
        readingPanel.showReading()
        let latch = SelectionLatch()
        selectFile?(path) { [weak self] verdict in
            guard !latch.fired else { return }
            latch.fired = true
            guard let self, self.selectionGeneration == generation else { return }
            // An update drawn for this selection is newer than its answer.
            guard !self.hasUpdateForLatestSelection else { return }
            if let verdict {
                self.readingPanel.show(path: path, verdict: verdict)
            } else {
                // The bar stays on the row it is on: the fault is that file's, so its row stays
                // marked as the file the panel is about.
                self.readingPanel.showStopped(path: path)
            }
        }
    }

    @available(*, unavailable)
    package required init?(coder: NSCoder) {
        preconditionFailure("WorkbenchView is built in code only")
    }

    /// Draws the hairline in the gap the sidebar and the reading panel leave between them. It is
    /// drawn here, not held by a view, so the workbench's direct subviews stay the three parts.
    override package func draw(_ dirtyRect: NSRect) {
        NSColor.separatorColor.setFill()
        NSRect(
            x: sidebar.frame.maxX, y: bounds.minY, width: hairlineWidth,
            height: bounds.height
        ).fill()
    }
}
