import AppKit

/// The one-window composition for an opened folder.
@MainActor
package final class WorkbenchView: NSSplitView {
    /// The existing tree is hosted unchanged in the Files sidebar.
    package let filesSidebar = NSScrollView()
    package let readingText = "Select a file to view."

    package init(rootItemsView: RootItemsView) {
        super.init(frame: .zero)
        isVertical = true

        filesSidebar.documentView = rootItemsView
        let readingPane = NSTextField(labelWithString: readingText)
        addSubview(filesSidebar)
        addSubview(readingPane)
    }

    @available(*, unavailable)
    package required init?(coder: NSCoder) {
        preconditionFailure("WorkbenchView is built in code only")
    }
}
