import AppKit

/// The one-window composition for an opened folder: two panels side by side, filling the size they
/// are given. The first is the Files sidebar, which is the tree it was handed and nothing around it,
/// always `{spacing.sidebar-width}` wide. The second is the reading panel, which takes the rest of
/// the width and draws one status message, led by the empty glyph, while no file is selected. Between them the workbench draws one
/// hairline itself.
///
/// A reader of this view gets its drawn view tree and nothing else (change_spec.md CP-246): its
/// direct subviews are exactly the two panels, sidebar first.
@MainActor
package final class WorkbenchView: NSView {
    private static let readingPrompt = "Select a file to view."

    /// `docs/DESIGN.md` § *Layout*: the sidebar is `{spacing.sidebar-width}` wide and does not
    /// resize.
    private static let sidebarWidth: CGFloat = 260

    /// `docs/DESIGN.md` § *Elevation & Depth*: the one `{spacing.hairline}` between the sidebar and
    /// the reading panel.
    private static let hairlineWidth: CGFloat = 1

    /// `docs/DESIGN.md` § *Components* "Status messages": a status message is inset `{spacing.xl}`
    /// from its surface's top-left.
    private static let promptInset: CGFloat = 24

    package let rootItemsView: RootItemsView

    package init(rootItemsView: RootItemsView, statusGlyphs: StatusGlyphs) {
        self.rootItemsView = rootItemsView
        super.init(frame: .zero)
        let readingPanel = Self.makeReadingPanel(glyph: statusGlyphs.empty)
        for panel in [rootItemsView, readingPanel] {
            panel.translatesAutoresizingMaskIntoConstraints = false
            addSubview(panel)
        }

        // Two plain panels and no divider: the sidebar "does not resize" (DESIGN § Layout; FDR R-137
        // puts pane resizing outside the product), so its width is held at required priority and
        // nothing between the panels takes a press. A split view held the width against a divider
        // drag only by tying the drag's own priority (the-window-holds-its-layout, CP-254).
        NSLayoutConstraint.activate([
            rootItemsView.leadingAnchor.constraint(equalTo: leadingAnchor),
            rootItemsView.topAnchor.constraint(equalTo: topAnchor),
            rootItemsView.bottomAnchor.constraint(equalTo: bottomAnchor),
            rootItemsView.widthAnchor.constraint(equalToConstant: Self.sidebarWidth),
            readingPanel.leadingAnchor.constraint(
                equalTo: rootItemsView.trailingAnchor, constant: Self.hairlineWidth),
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
            x: rootItemsView.frame.maxX, y: bounds.minY, width: Self.hairlineWidth,
            height: bounds.height
        ).fill()
    }

    /// A plain view holding the prompt's status message at its top-left (`docs/DESIGN.md` RN-14: a
    /// status message is top-left and never centred).
    private static func makeReadingPanel(glyph: NSImage) -> NSView {
        let panel = NSView()
        let prompt = StatusMessageView(
            glyph: glyph, texts: [NSTextField(labelWithString: readingPrompt)])
        prompt.translatesAutoresizingMaskIntoConstraints = false
        panel.addSubview(prompt)
        // Nothing ties the prompt to the panel's bottom: with the label as the panel, its one
        // line's height became the window's (change_spec.md § Verified Claims row 1).
        NSLayoutConstraint.activate([
            prompt.topAnchor.constraint(equalTo: panel.topAnchor, constant: promptInset),
            prompt.leadingAnchor.constraint(equalTo: panel.leadingAnchor, constant: promptInset),
            prompt.trailingAnchor.constraint(
                lessThanOrEqualTo: panel.trailingAnchor, constant: -promptInset),
        ])
        return panel
    }
}
