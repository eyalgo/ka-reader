import AppKit

/// The one-window composition for an opened folder: two panels that fill the size they are given.
/// The first is the Files sidebar, which is the tree it was handed and nothing around it. The
/// second is the reading panel, which draws one prompt while no file is selected.
///
/// A reader of this view gets its drawn view tree and nothing else (change_spec.md CP-246): its
/// direct subviews are exactly the two panels, sidebar first.
@MainActor
package final class WorkbenchView: NSSplitView {
    private static let readingPrompt = "Select a file to view."

    /// `docs/DESIGN.md`'s `{spacing.sidebar-width}`.
    private static let sidebarWidth: CGFloat = 260

    /// `docs/DESIGN.md`'s `{spacing.xl}`: how far the prompt stands in from its panel's top-left.
    private static let promptInset: CGFloat = 24

    package let rootItemsView: RootItemsView

    package init(rootItemsView: RootItemsView) {
        self.rootItemsView = rootItemsView
        super.init(frame: .zero)
        isVertical = true
        addArrangedSubview(rootItemsView)
        addArrangedSubview(Self.makeReadingPanel())

        // The workbench states its own division. Left to the split view, the sidebar came out 236
        // wide under one host and 350.5 under another, the second leaving the prompt no room
        // (change_design.md M4, M5). It is held below a divider drag, which this change leaves as
        // it found it (change_spec.md Gap 2).
        let sidebarWidth = rootItemsView.widthAnchor.constraint(equalToConstant: Self.sidebarWidth)
        sidebarWidth.priority = .dragThatCannotResizeWindow
        sidebarWidth.isActive = true
    }

    @available(*, unavailable)
    package required init?(coder: NSCoder) {
        preconditionFailure("WorkbenchView is built in code only")
    }

    /// A plain view holding the prompt at its top-left (`docs/DESIGN.md` RN-14: a status message
    /// is top-left and never centred).
    private static func makeReadingPanel() -> NSView {
        let panel = NSView()
        let prompt = NSTextField(labelWithString: readingPrompt)
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
