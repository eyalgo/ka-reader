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

/// Makes a sink answer once.
private final class SelectionLatch {
    var fired = false
}

/// The one-window composition for an opened folder: two panels side by side, filling the size they
/// are given. The first is the Files sidebar, which is the tree it was handed and nothing around
/// it, always `{spacing.sidebar-width}` wide. The second is the reading panel, which takes the rest
/// of the width and draws one status message, led by the empty glyph, while no file is selected.
/// Between them the workbench draws one hairline itself.
///
/// A reader of this view gets its drawn view tree and nothing else (change_spec.md CP-246): its
/// direct subviews are exactly the two panels, sidebar first.
@MainActor
package final class WorkbenchView: NSView {
    /// `docs/DESIGN.md` § *Layout*: the sidebar is `{spacing.sidebar-width}` wide and does not
    /// resize.
    private static let sidebarWidth: CGFloat = 260

    package let rootItemsView: RootItemsView

    /// The reading panel: the prompt until a file is selected, then the pending read, then the
    /// file's verdict, or the fault when the read answers nothing.
    package let readingPanel: ReadingPanelView

    /// Set by the view's owner, and called on the main actor once per file selection with the
    /// entry's `path` and a sink for the verdict. While it is unset a selection still moves the bar,
    /// and no answer ever comes. Only the latest selection's sink draws anything (CP-278).
    package var selectFile: SelectFileIntent?

    /// Counts file selections: a sink applies only while its selection is still the latest.
    private var selectionGeneration = 0

    /// Places the supplied tree beside the reading prompt, using the supplied empty-state image.
    package init(rootItemsView: RootItemsView, statusGlyphs: StatusGlyphs) {
        self.rootItemsView = rootItemsView
        readingPanel = ReadingPanelView(statusGlyphs: statusGlyphs)
        super.init(frame: .zero)
        rootItemsView.fileSelected = { [weak self] entry in self?.select(entry) }
        for panel in [rootItemsView, readingPanel] {
            panel.translatesAutoresizingMaskIntoConstraints = false
            addSubview(panel)
        }

        // Two plain panels and no divider: the sidebar "does not resize" (DESIGN § Layout; FDR
        // R-137 puts pane resizing outside the product), so its width is held at required priority
        // and nothing between the panels takes a press. A split view held the width against a
        // divider drag only by tying the drag's own priority (the-window-holds-its-layout, CP-254).
        NSLayoutConstraint.activate([
            rootItemsView.leadingAnchor.constraint(equalTo: leadingAnchor),
            rootItemsView.topAnchor.constraint(equalTo: topAnchor),
            rootItemsView.bottomAnchor.constraint(equalTo: bottomAnchor),
            rootItemsView.widthAnchor.constraint(equalToConstant: Self.sidebarWidth),
            readingPanel.leadingAnchor.constraint(
                equalTo: rootItemsView.trailingAnchor, constant: hairlineWidth),
            readingPanel.trailingAnchor.constraint(equalTo: trailingAnchor),
            readingPanel.topAnchor.constraint(equalTo: topAnchor),
            readingPanel.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }

    /// Moves the bar to `entry`, draws the panel's *reading* state and then asks the owner to read
    /// it. The panel shows the verdict under the entry's `path` once it comes, if no later selection
    /// has been made. A `nil` answer draws the *stopped* state for that path and leaves the bar on
    /// the entry.
    private func select(_ entry: Entry) {
        selectionGeneration += 1
        let generation = selectionGeneration
        rootItemsView.markOpenFile(path: entry.path)
        // Before the intent is raised, never after: an owner may answer inside that call, and a
        // *reading* drawn afterwards would overwrite the verdict just drawn.
        readingPanel.showReading()
        let latch = SelectionLatch()
        selectFile?(entry.path) { [weak self] verdict in
            guard !latch.fired else { return }
            latch.fired = true
            guard let self, self.selectionGeneration == generation else { return }
            if let verdict {
                self.readingPanel.show(path: entry.path, verdict: verdict)
            } else {
                // The bar stays on the entry, where `markOpenFile` put it: the fault is that
                // file's, so its row stays marked as the file the panel is about.
                self.readingPanel.showStopped(path: entry.path)
            }
        }
    }

    @available(*, unavailable)
    package required init?(coder: NSCoder) {
        preconditionFailure("WorkbenchView is built in code only")
    }

    /// Draws the hairline in the gap the two panels leave between them. It is drawn here, not held
    /// by a view, so the workbench's direct subviews stay the two panels.
    override package func draw(_ dirtyRect: NSRect) {
        NSColor.separatorColor.setFill()
        NSRect(
            x: rootItemsView.frame.maxX, y: bounds.minY, width: hairlineWidth,
            height: bounds.height
        ).fill()
    }
}
