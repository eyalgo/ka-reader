import AppKit

/// The root-items tree view: one row per entry, in the order given, each with the entry's
/// name beside a glyph chosen by kind.
///
/// The two glyph images arrive from the caller, because this target never loads a resource
/// and never reaches the bridge (SM-8, CP-97). Only root items are drawn; expansion is not
/// part of this change.
@MainActor
public final class RootItemsView: NSScrollView {
    /// The outline view the rows live in. Exposed so a caller can host it and a test can read
    /// the rows it reports.
    public let outlineView = NSOutlineView()

    private let folderGlyph: NSImage
    private let fileGlyph: NSImage
    private var rows: [Row] = []

    public init(folderGlyph: NSImage, fileGlyph: NSImage) {
        self.folderGlyph = folderGlyph
        self.fileGlyph = fileGlyph
        super.init(frame: .zero)

        let column = NSTableColumn(identifier: Self.columnIdentifier)
        outlineView.addTableColumn(column)
        outlineView.outlineTableColumn = column
        outlineView.headerView = nil
        outlineView.dataSource = self
        outlineView.delegate = self
        documentView = outlineView
        hasVerticalScroller = true
    }

    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        preconditionFailure("RootItemsView is built in code only")
    }

    /// Replaces the rows with `entries`, in exactly that order.
    public func show(_ entries: [Entry]) {
        rows = entries.map(Row.init)
        outlineView.reloadData()
    }

    private static let columnIdentifier = NSUserInterfaceItemIdentifier("entry")
    private static let cellIdentifier = NSUserInterfaceItemIdentifier("entryCell")
    private static let glyphSize: CGFloat = 16
    private static let glyphSpacing: CGFloat = 6

    private func glyph(for kind: EntryKind) -> NSImage {
        switch kind {
        case .folder: return folderGlyph
        case .file, .symlink: return fileGlyph
        }
    }

    private func makeCell() -> NSTableCellView {
        let cell = NSTableCellView()
        cell.identifier = Self.cellIdentifier

        let imageView = NSImageView()
        let textField = NSTextField(labelWithString: "")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        textField.translatesAutoresizingMaskIntoConstraints = false
        cell.addSubview(imageView)
        cell.addSubview(textField)
        cell.imageView = imageView
        cell.textField = textField

        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: cell.leadingAnchor),
            imageView.centerYAnchor.constraint(equalTo: cell.centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: Self.glyphSize),
            imageView.heightAnchor.constraint(equalToConstant: Self.glyphSize),
            textField.leadingAnchor.constraint(
                equalTo: imageView.trailingAnchor, constant: Self.glyphSpacing),
            textField.trailingAnchor.constraint(equalTo: cell.trailingAnchor),
            textField.centerYAnchor.constraint(equalTo: cell.centerYAnchor),
        ])
        return cell
    }
}

/// A row's item. `NSOutlineView` identifies items by object, so each entry gets a reference.
private final class Row: NSObject {
    let entry: Entry

    init(_ entry: Entry) {
        self.entry = entry
    }
}

extension RootItemsView: NSOutlineViewDataSource {
    public func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int
    {
        item == nil ? rows.count : 0
    }

    public func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?)
        -> Any
    {
        rows[index]
    }

    public func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool {
        false
    }
}

extension RootItemsView: NSOutlineViewDelegate {
    public func outlineView(
        _ outlineView: NSOutlineView, viewFor tableColumn: NSTableColumn?, item: Any
    ) -> NSView? {
        guard let row = item as? Row else {
            preconditionFailure("every item this view hands the outline view is a Row")
        }
        let cell =
            outlineView.makeView(withIdentifier: Self.cellIdentifier, owner: self)
            as? NSTableCellView ?? makeCell()
        cell.textField?.stringValue = row.entry.name
        cell.imageView?.image = glyph(for: row.entry.kind)
        return cell
    }
}
