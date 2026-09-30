import AppKit

/// `docs/DESIGN.md` § *Components* "Status messages": a status message is inset `{spacing.xl}`
/// from its surface's top-left.
private let rootMessageInset: CGFloat = 24

/// The answer to one folder read: its entries, the reason it failed, or `nil` when none came.
package typealias ListTreeAnswer = @MainActor (RootListing?) -> Void

/// The read a folder row asks for: the entry's path and the sink its answer goes to.
package typealias ListTreeIntent =
    @MainActor (_ path: String, _ answer: @escaping ListTreeAnswer) -> Void

/// The tree view: one row per entry, in the order given, each with the entry's name beside a glyph
/// chosen by kind. A folder row can be expanded, and every expansion reads the folder again through
/// the `listTree` intent. What sits beneath an expanded row follows that read: a line while it is
/// out, the entries it found, a line for an empty folder, or nothing. A folder that could not be
/// read shows its sentence beside its row, as a failed file does. A root with nothing to list, or
/// one that could not be read, shows one line instead of rows.
///
/// Its glyph images arrive from the caller — the rows' two and the status messages' two — because
/// this target never loads a resource and
/// never reaches the bridge (SM-8, CP-97). The read itself is the owner's: this view hands out the
/// path to read and takes the answer back through a one-shot sink.
@MainActor
package final class RootItemsView: NSScrollView {
    /// The outline view the rows live in. Exposed so a caller can host it and a test can read
    /// the rows it reports.
    package let outlineView = NSOutlineView()

    private let folderGlyph: NSImage
    private let fileGlyph: NSImage
    private let statusGlyphs: StatusGlyphs
    private var rows: [Row] = []
    private var isReloading = false
    private let rootLine: NSTextField
    private let rootMessage: StatusMessageView

    /// The one line drawn outside the rows, or nil when none is drawn.
    package private(set) var rootLineText: String?

    /// Set by the view's owner, and called on the main actor once per expansion of a folder row.
    /// It is handed the path the row's entry reports, never its name, and a sink for the answer.
    /// While it is unset an expansion still draws the reading line, and no answer ever comes.
    package var listTree: ListTreeIntent?

    /// The entry the row at `row` draws, or nil for a row that is not an entry.
    package func entry(atRow row: Int) -> Entry? {
        (outlineView.item(atRow: row) as? Row)?.entry
    }

    /// The text of the line item at `row`, or nil for a row that is not a line.
    package func lineText(atRow row: Int) -> String? {
        (outlineView.item(atRow: row) as? LineItem)?.text
    }

    /// Presents tree rows or a root status using only the images supplied by the owner.
    package init(folderGlyph: NSImage, fileGlyph: NSImage, statusGlyphs: StatusGlyphs) {
        self.folderGlyph = folderGlyph
        self.fileGlyph = fileGlyph
        self.statusGlyphs = statusGlyphs
        // Wrapping, so a sentence wider than the sidebar's column is drawn whole on two lines.
        let line = NSTextField(wrappingLabelWithString: "")
        line.isSelectable = false
        rootLine = line
        rootMessage = StatusMessageView(glyph: statusGlyphs.empty, texts: [line])
        super.init(frame: .zero)

        let column = NSTableColumn(identifier: Self.columnIdentifier)
        outlineView.addTableColumn(column)
        outlineView.outlineTableColumn = column
        outlineView.headerView = nil
        outlineView.dataSource = self
        outlineView.delegate = self
        documentView = outlineView
        hasVerticalScroller = true

        rootMessage.translatesAutoresizingMaskIntoConstraints = false
        rootMessage.isHidden = true
        // A floating subview, not a plain one: a scroll view tiles its own subviews and leaves a
        // plain one at the frame it was made with, whatever its constraints say (measured: the
        // line stayed 4 points wide at the top-left). Pinned to the top-left, never the centre
        // (DESIGN RN-14; the-window-holds-its-layout CP-257).
        addFloatingSubview(rootMessage, for: .vertical)
        NSLayoutConstraint.activate([
            rootMessage.topAnchor.constraint(equalTo: topAnchor, constant: rootMessageInset),
            rootMessage.leadingAnchor.constraint(
                equalTo: leadingAnchor, constant: rootMessageInset),
            rootMessage.trailingAnchor.constraint(
                lessThanOrEqualTo: trailingAnchor, constant: -rootMessageInset),
        ])
    }

    @available(*, unavailable)
    package required init?(coder: NSCoder) {
        preconditionFailure("RootItemsView is built in code only")
    }

    /// Replaces what is drawn with `root`: its entries in exactly that order, or one line when the
    /// root is empty or could not be read, or nothing when there is no answer (`nil`). Every row is
    /// replaced, so an answer still owed to an earlier row is ignored when it arrives.
    package func show(_ root: RootListing?) {
        var entries: [Entry] = []
        switch root {
        case nil:
            rootLineText = nil
        case .observed(let listed)?:
            entries = listed
            rootLineText = listed.isEmpty ? ConditionSentences.emptyRoot : nil
            rootMessage.glyph = statusGlyphs.empty
        case .failed?:
            rootLineText = ConditionSentences.failedRoot
            rootMessage.glyph = statusGlyphs.failure
        }
        rows = entries.map { Row($0, parent: nil) }
        rootLine.stringValue = rootLineText ?? ""
        // The whole message goes, glyph included: a glyph never stands alone.
        rootMessage.isHidden = rootLineText == nil
        outlineView.reloadData()
    }

    private static let columnIdentifier = NSUserInterfaceItemIdentifier("entry")
    private static let cellIdentifier = NSUserInterfaceItemIdentifier("entryCell")
    private static let lineCellIdentifier = NSUserInterfaceItemIdentifier("lineCell")
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

    private func makeLineCell() -> NSTableCellView {
        let cell = NSTableCellView()
        cell.identifier = Self.lineCellIdentifier
        let textField = NSTextField(labelWithString: "")
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.textColor = .secondaryLabelColor
        cell.addSubview(textField)
        cell.textField = textField
        NSLayoutConstraint.activate([
            textField.leadingAnchor.constraint(equalTo: cell.leadingAnchor),
            textField.centerYAnchor.constraint(equalTo: cell.centerYAnchor),
        ])
        return cell
    }

    /// The sentence beside a row: a folder's from its read, a file's from its own entry.
    private func conditionSentence(for row: Row) -> String? {
        let state: ReadState
        switch row.entry.kind {
        case .folder:
            state = row.read
        case .file:
            if case .failed(let condition) = row.entry.state {
                state = .failed(condition)
            } else {
                state = .unread
            }
        }
        guard case .failed(let condition) = state else { return nil }
        return ConditionSentences.row(for: condition)
    }

    /// Every expansion reads: the row goes to *reading*, drops what it held and asks the owner for
    /// its path. Its earlier sinks go stale, because the generation moves.
    private func beginRead(of row: Row) {
        row.generation += 1
        row.read = .reading
        row.children = []
        row.line = LineItem(ConditionSentences.readingFolder)
        reload(row)
        listTree?(row.entry.path, makeAnswerSink(for: row))
    }

    private func makeAnswerSink(for row: Row) -> ListTreeAnswer {
        let generation = row.generation
        let latch = AnswerLatch()
        return { [weak self, weak row] listing in
            guard !latch.fired else { return }
            latch.fired = true
            guard let self, let row, row.generation == generation, self.isInTree(row) else {
                return
            }
            self.apply(listing, to: row)
        }
    }

    /// Whether `row` is still drawn from the current root: every row above it still holds it.
    private func isInTree(_ row: Row) -> Bool {
        var current = row
        while let parent = current.parent {
            guard parent.children.contains(where: { $0 === current }) else { return false }
            current = parent
        }
        return rows.contains { $0 === current }
    }

    private func apply(_ listing: RootListing?, to row: Row) {
        row.children = []
        row.line = nil
        switch listing {
        case nil:
            row.read = .noAnswer
        case .observed(let entries)?:
            if entries.isEmpty {
                row.read = .empty
                row.line = LineItem(ConditionSentences.emptyFolder)
            } else {
                row.read = .entries
                row.children = entries.map { Row($0, parent: row) }
            }
        case .failed(let condition)?:
            row.read = .failed(condition)
        }
        reload(row)
    }

    /// Draws `row` and what is beneath it again. Reloading an item that is already expanded posts
    /// the expansion notification a second time (measured), and that one is not an expansion the
    /// user or a caller asked for, so it must not start another read.
    private func reload(_ row: Row) {
        isReloading = true
        defer { isReloading = false }
        outlineView.reloadItem(row, reloadChildren: true)
    }
}

/// A row's cell: the name and glyph every row has, and the label a failed entry's sentence goes in.
private final class EntryCell: NSTableCellView {
    let conditionLabel = NSTextField(labelWithString: "")
}

/// Where a folder row's read stands. A file row stays *unread*.
private enum ReadState: Equatable {
    case unread
    case reading
    case entries
    case empty
    case failed(Condition)
    case noAnswer
}

/// The line drawn beneath an expanded folder while its read is out, or when it holds nothing.
private final class LineItem: NSObject {
    let text: String

    init(_ text: String) {
        self.text = text
    }
}

/// Makes a sink answer once.
private final class AnswerLatch {
    var fired = false
}

/// A row's item. `NSOutlineView` identifies items by object, so each entry gets a reference, and a
/// folder's reference owns its read state, its children and the generation of its latest read.
private final class Row: NSObject {
    let entry: Entry
    weak var parent: Row?
    var read = ReadState.unread
    var generation = 0
    var children: [Row] = []
    var line: LineItem?

    init(_ entry: Entry, parent: Row?) {
        self.entry = entry
        self.parent = parent
    }

    /// What the outline view finds beneath this row.
    var childItems: [NSObject] {
        switch read {
        case .entries: return children
        case .reading, .empty: return line.map { [$0] } ?? []
        case .unread, .failed, .noAnswer: return []
        }
    }
}

extension RootItemsView: NSOutlineViewDataSource {
    package func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int
    {
        guard let item else { return rows.count }
        return (item as? Row)?.childItems.count ?? 0
    }

    package func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?)
        -> Any
    {
        guard let item else { return rows[index] }
        guard let row = item as? Row else {
            preconditionFailure("only an entry row has rows beneath it")
        }
        return row.childItems[index]
    }

    package func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool {
        (item as? Row)?.entry.kind == .folder
    }
}

extension RootItemsView: NSOutlineViewDelegate {
    package func outlineView(
        _ outlineView: NSOutlineView, viewFor tableColumn: NSTableColumn?, item: Any
    ) -> NSView? {
        if let line = item as? LineItem {
            let cell =
                outlineView.makeView(withIdentifier: Self.lineCellIdentifier, owner: self)
                as? NSTableCellView ?? makeLineCell()
            cell.textField?.stringValue = line.text
            return cell
        }
        guard let row = item as? Row else {
            preconditionFailure("every item this view hands the outline view is a Row or a line")
        }
        let cell =
            outlineView.makeView(withIdentifier: Self.cellIdentifier, owner: self)
            as? EntryCell ?? makeCell()
        cell.textField?.stringValue = row.entry.name
        cell.imageView?.image = glyph(for: row.entry.kind)
        // Every row sets the sentence, so a reused cell never carries a stale one.
        if let sentence = conditionSentence(for: row) {
            cell.conditionLabel.stringValue = sentence
            cell.conditionLabel.isHidden = false
        } else {
            cell.conditionLabel.stringValue = ""
            cell.conditionLabel.isHidden = true
        }
        return cell
    }

    /// The one hook an expansion passes through. `expandItem(_:)` fires it before the item opens
    /// (measured in the plan for this change). That a disclosure click fires it too is not
    /// measured here: it is held by review, and by the owner's walk of the running app.
    package func outlineViewItemWillExpand(_ notification: Notification) {
        guard !isReloading, let row = notification.userInfo?["NSObject"] as? Row else { return }
        beginRead(of: row)
    }
}
