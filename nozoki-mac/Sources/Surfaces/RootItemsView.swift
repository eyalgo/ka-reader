import AppKit

/// The root-items tree view: one row per entry, in the order given, each with the entry's
/// name beside a glyph chosen by kind. An entry that failed also shows its sentence on its row. A
/// root with nothing to list, or one that could not be read, shows one line instead of rows.
///
/// The two glyph images arrive from the caller, because this target never loads a resource
/// and never reaches the bridge (SM-8, CP-97). Only root items are drawn; expansion is not
/// part of this change.
@MainActor
package final class RootItemsView: NSScrollView {
    /// The outline view the rows live in. Exposed so a caller can host it and a test can read
    /// the rows it reports.
    package let outlineView = NSOutlineView()

    private let folderGlyph: NSImage
    private let fileGlyph: NSImage
    private var rows: [Row] = []
    private let rootLine = NSTextField(labelWithString: "")

    /// The one line drawn outside the rows, or nil when none is drawn.
    package private(set) var rootLineText: String?

    package init(folderGlyph: NSImage, fileGlyph: NSImage) {
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

        rootLine.translatesAutoresizingMaskIntoConstraints = false
        rootLine.isHidden = true
        addSubview(rootLine)
        NSLayoutConstraint.activate([
            rootLine.centerXAnchor.constraint(equalTo: centerXAnchor),
            rootLine.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }

    @available(*, unavailable)
    package required init?(coder: NSCoder) {
        preconditionFailure("RootItemsView is built in code only")
    }

    /// Replaces what is drawn with `root`: its entries in exactly that order, or one line when the
    /// root is empty or could not be read, or nothing when there is no answer (`nil`).
    package func show(_ root: RootListing?) {
        var entries: [Entry] = []
        switch root {
        case nil:
            rootLineText = nil
        case .observed(let listed)?:
            entries = listed
            rootLineText = listed.isEmpty ? ConditionSentences.emptyRoot : nil
        case .failed?:
            rootLineText = ConditionSentences.failedRoot
        }
        rows = entries.map(Row.init)
        rootLine.stringValue = rootLineText ?? ""
        rootLine.isHidden = rootLineText == nil
        outlineView.reloadData()
    }

    private static let columnIdentifier = NSUserInterfaceItemIdentifier("entry")
    private static let cellIdentifier = NSUserInterfaceItemIdentifier("entryCell")
    private static let conditionIdentifier = NSUserInterfaceItemIdentifier("entryCondition")
    private static let glyphSize: CGFloat = 16
    private static let glyphSpacing: CGFloat = 6

    private func glyph(for kind: EntryKind) -> NSImage {
        switch kind {
        case .folder: return folderGlyph
        case .file: return fileGlyph
        }
    }

    private func makeCell() -> EntryCell {
        let cell = EntryCell()
        cell.identifier = Self.cellIdentifier

        let imageView = NSImageView()
        let textField = NSTextField(labelWithString: "")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        textField.translatesAutoresizingMaskIntoConstraints = false
        let conditionLabel = cell.conditionLabel
        conditionLabel.identifier = Self.conditionIdentifier
        conditionLabel.translatesAutoresizingMaskIntoConstraints = false
        conditionLabel.textColor = .secondaryLabelColor
        conditionLabel.isHidden = true
        cell.addSubview(imageView)
        cell.addSubview(textField)
        cell.addSubview(conditionLabel)
        cell.imageView = imageView
        cell.textField = textField

        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: cell.leadingAnchor),
            imageView.centerYAnchor.constraint(equalTo: cell.centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: Self.glyphSize),
            imageView.heightAnchor.constraint(equalToConstant: Self.glyphSize),
            textField.leadingAnchor.constraint(
                equalTo: imageView.trailingAnchor, constant: Self.glyphSpacing),
            textField.centerYAnchor.constraint(equalTo: cell.centerYAnchor),
            conditionLabel.leadingAnchor.constraint(
                equalTo: textField.trailingAnchor, constant: Self.glyphSpacing),
            conditionLabel.trailingAnchor.constraint(lessThanOrEqualTo: cell.trailingAnchor),
            conditionLabel.centerYAnchor.constraint(equalTo: cell.centerYAnchor),
        ])
        return cell
    }
}

/// A row's cell: the name and glyph every row has, and the label a failed entry's sentence goes in.
private final class EntryCell: NSTableCellView {
    let conditionLabel = NSTextField(labelWithString: "")
}

/// A row's item. `NSOutlineView` identifies items by object, so each entry gets a reference.
private final class Row: NSObject {
    let entry: Entry

    init(_ entry: Entry) {
        self.entry = entry
    }
}

extension RootItemsView: NSOutlineViewDataSource {
    package func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int
    {
        item == nil ? rows.count : 0
    }

    package func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?)
        -> Any
    {
        rows[index]
    }

    package func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool {
        false
    }
}

extension RootItemsView: NSOutlineViewDelegate {
    package func outlineView(
        _ outlineView: NSOutlineView, viewFor tableColumn: NSTableColumn?, item: Any
    ) -> NSView? {
        guard let row = item as? Row else {
            preconditionFailure("every item this view hands the outline view is a Row")
        }
        let cell =
            outlineView.makeView(withIdentifier: Self.cellIdentifier, owner: self)
            as? EntryCell ?? makeCell()
        cell.textField?.stringValue = row.entry.name
        cell.imageView?.image = glyph(for: row.entry.kind)
        // Every row sets the sentence, so a reused cell never carries a stale one.
        if case .failed(let condition) = row.entry.state {
            cell.conditionLabel.stringValue = ConditionSentences.row(for: condition)
            cell.conditionLabel.isHidden = false
        } else {
            cell.conditionLabel.stringValue = ""
            cell.conditionLabel.isHidden = true
        }
        return cell
    }
}
