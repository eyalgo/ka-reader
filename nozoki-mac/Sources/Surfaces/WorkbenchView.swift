import AppKit

/// `docs/DESIGN.md` § *Elevation & Depth*: the one `{spacing.hairline}` between the sidebar and
/// the reading panel.
private let hairlineWidth: CGFloat = 1

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

    /// The reading panel: the prompt until a file is selected, then the file's verdict.
    package let readingPanel: ReadingPanelView

    /// Places the supplied tree beside the reading prompt, using the supplied empty-state image.
    package init(rootItemsView: RootItemsView, statusGlyphs: StatusGlyphs) {
        self.rootItemsView = rootItemsView
        readingPanel = ReadingPanelView(statusGlyphs: statusGlyphs)
        super.init(frame: .zero)
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
