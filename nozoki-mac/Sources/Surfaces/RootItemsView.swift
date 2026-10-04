import AppKit

/// `docs/DESIGN.md` § *Components* "Status messages": a status message is inset `{spacing.xl}`
/// from its surface's top-left.
private let rootMessageInset: CGFloat = 24

/// The answer to one folder read: its entries, the reason it failed, or `nil` when none came.
package typealias ListTreeAnswer = @MainActor (RootListing?) -> Void

/// The read a folder row asks for: the entry's path and the sink its answer goes to.
package typealias ListTreeIntent =
    @MainActor (_ path: String, _ answer: @escaping ListTreeAnswer) -> Void

/// The one file selection a file row raises: the entry whose row was selected.
package typealias FileSelected = @MainActor (Entry) -> Void

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
    private let fileCodeGlyph: NSImage
    private let statusGlyphs: StatusGlyphs
    private var rows: [Row] = []
    private var isReloading = false
    private var isShowingOpenFile = false
    private var markers = TreeMarkers.none
    private let rootLine: NSTextField
    private let rootMessage: StatusMessageView
    private let tooltipRest: TooltipRest

    /// The tooltip a status letter raises on pointer rest, over the tree's letters (CP-586). A lazy
    /// property because it is bound to this view, which an initialiser cannot name before it is
    /// built; `init` reads it once so the tracking area is installed from the start.
    package private(set) lazy var letterTooltip = LetterTooltip(
        host: self, rest: tooltipRest,
        letterAt: { [weak self] point in self?.letter(at: point) })

    /// The one line drawn outside the rows, or nil when none is drawn.
    package private(set) var rootLineText: String?

    /// Set by the view's owner, and called on the main actor once per expansion of a folder row.
    /// It is handed the path the row's entry reports, never its name, and a sink for the answer.
    /// While it is unset an expansion still draws the reading line, and no answer ever comes.
    package var listTree: ListTreeIntent?

    /// Set by the view's owner, and called on the main actor when the user selects a file row.
    /// Selecting a folder row or a status line raises nothing, and neither does a selection AppKit
    /// posts while the view is reloading its own rows (CP-285).
    package var fileSelected: FileSelected?

    /// The path of the open file, whose row alone draws the bar, or nil when none is open. It is a
    /// path and not a row because every expansion rebuilds a folder's child rows.
    package private(set) var openFilePath: String?

    /// Moves the bar to the row whose entry's `path` is `path`, or takes it off every row for nil.
    package func markOpenFile(path: String?) {
        openFilePath = path
        for index in 0..<outlineView.numberOfRows {
            guard
                let rowView = outlineView.rowView(atRow: index, makeIfNecessary: false)
                    as? BarRowView
            else { continue }
            rowView.drawsBar = barBelongs(on: outlineView.item(atRow: index))
        }
    }

    /// Shows a file opened from outside the tree (a Git row) as the open file: the bar moves to
    /// `path`, and the row of that path is selected if the tree as left shows it. A path under a
    /// collapsed folder, or `nil`, selects no row and lets go of the one that was. It raises no
    /// `fileSelected`, expands no folder and moves no scroll offset (CP-565, CP-550).
    package func showOpenFile(path: String?) {
        markOpenFile(path: path)
        isShowingOpenFile = true
        defer { isShowingOpenFile = false }
        let shown = (0..<outlineView.numberOfRows).first { index in
            guard let row = outlineView.item(atRow: index) as? Row else { return false }
            return row.entry.kind == .file && row.entry.path == path
        }
        if let shown {
            outlineView.selectRowIndexes(IndexSet(integer: shown), byExtendingSelection: false)
        } else {
            outlineView.deselectAll(nil)
        }
    }

    /// Replaces the markers the view holds: every entry row drawn now, and every row drawn after,
    /// carries the letter `markers` gives its path (CP-575). Only the drawn rows' cells are drawn
    /// again, inside the reload guard: a whole-outline `reloadData()` would ask the data source for
    /// every item again, and expansion relies on the identity of `Row` (CP-285 precedent at
    /// `reload(_:)`). Expansion, scroll offset, selection and the bar are left as they were.
    package func showMarkers(_ markers: TreeMarkers) {
        letterTooltip.dismiss()
        self.markers = markers
        isReloading = true
        defer { isReloading = false }
        outlineView.reloadData(
            forRowIndexes: IndexSet(0..<outlineView.numberOfRows),
            columnIndexes: IndexSet(integer: 0))
    }

    /// The `path` of every row that draws the bar, top to bottom.
    package func barPaths() -> [String] {
        (0..<outlineView.numberOfRows).compactMap { index in
            let rowView = outlineView.rowView(atRow: index, makeIfNecessary: true) as? BarRowView
            guard rowView?.drawsBar == true else { return nil }
            return (outlineView.item(atRow: index) as? Row)?.entry.path
        }
    }

    private func barBelongs(on item: Any?) -> Bool {
        guard let row = item as? Row, row.entry.kind == .file, let openFilePath else {
            return false
        }
        return row.entry.path == openFilePath
    }

    /// The entry the row at `row` draws, or nil for a row that is not an entry.
    package func entry(atRow row: Int) -> Entry? {
        (outlineView.item(atRow: row) as? Row)?.entry
    }

    /// The text of the line item at `row`, or nil for a row that is not a line.
    package func lineText(atRow row: Int) -> String? {
        (outlineView.item(atRow: row) as? LineItem)?.text
    }

    /// Presents tree rows or a root status using only the images supplied by the owner.
    package init(
        folderGlyph: NSImage, fileGlyph: NSImage, fileCodeGlyph: NSImage,
        statusGlyphs: StatusGlyphs, tooltipRest: TooltipRest = .live
    ) {
        self.tooltipRest = tooltipRest
        self.folderGlyph = folderGlyph
        self.fileGlyph = fileGlyph
        self.fileCodeGlyph = fileCodeGlyph
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

        // A letter can leave a resting pointer by the tree scrolling under it.
        contentView.postsBoundsChangedNotifications = true
        NotificationCenter.default.addObserver(
            self, selector: #selector(treeScrolled), name: NSView.boundsDidChangeNotification,
            object: contentView)
        _ = letterTooltip
    }

    @objc private func treeScrolled(_ notification: Notification) {
        letterTooltip.dismiss()
    }

    /// The shown letter at `point` (in this view's coordinates), with the text it raises, or nil
    /// when the point is on no letter. A point lies on a letter only inside a shown letter field's
    /// own frame: the name, the glyph, the condition sentence, the space between them, an unmarked
    /// row and a line item are on none (CP-587, CP-588). The category is read now, from the same
    /// call the letter is drawn from, so the word never disagrees with the letter (CP-594).
    private func letter(at point: NSPoint) -> LetterUnderPointer? {
        let inOutline = outlineView.convert(point, from: self)
        let index = outlineView.row(at: inOutline)
        guard index >= 0, let row = outlineView.item(atRow: index) as? Row,
            let cell = outlineView.view(atColumn: 0, row: index, makeIfNecessary: false)
                as? EntryCell,
            !cell.letterLabel.isHidden,
            cell.letterLabel.frame.contains(cell.convert(inOutline, from: outlineView)),
            let category = markers.category(forRowPath: row.entry.path)
        else { return nil }
        return LetterUnderPointer(
            letter: cell.letterLabel,
            text: GitSentences.letterTooltip(name: row.entry.name, category: category))
    }

    @available(*, unavailable)
    package required init?(coder: NSCoder) {
        preconditionFailure("RootItemsView is built in code only")
    }

    /// Replaces what is drawn with `root`: its entries in exactly that order, or one line when the
    /// root is empty or could not be read, or nothing when there is no answer (`nil`). Every row is
    /// replaced, so an answer still owed to an earlier row is ignored when it arrives.
    package func show(_ root: RootListing?) {
        letterTooltip.dismiss()
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
        isReloading = true
        defer { isReloading = false }
        outlineView.reloadData()
    }

    private static let columnIdentifier = NSUserInterfaceItemIdentifier("entry")
    private static let cellIdentifier = NSUserInterfaceItemIdentifier("entryCell")
    private static let lineCellIdentifier = NSUserInterfaceItemIdentifier("lineCell")
    private static let conditionIdentifier = NSUserInterfaceItemIdentifier("entryCondition")
    private static let letterIdentifier = NSUserInterfaceItemIdentifier("treeRowLetter")
    private static let glyphSize: CGFloat = 16
    private static let glyphSpacing: CGFloat = 6

    /// A folder draws the folder image, whatever its name; a file with a floor language draws the
    /// file-code image and any other file the file image. State plays no part.
    private func glyph(for entry: Entry) -> NSImage {
        switch entry.kind {
        case .folder: return folderGlyph
        case .file: return entry.language == nil ? fileGlyph : fileCodeGlyph
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
        // The status letter: a label, never a second click target (CP-578), no hue (CP-576).
        let letterLabel = cell.letterLabel
        letterLabel.identifier = Self.letterIdentifier
        letterLabel.translatesAutoresizingMaskIntoConstraints = false
        letterLabel.isSelectable = false
        letterLabel.setContentHuggingPriority(.required, for: .horizontal)
        letterLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        letterLabel.isHidden = true
        cell.addSubview(imageView)
        cell.addSubview(textField)
        cell.addSubview(conditionLabel)
        cell.addSubview(letterLabel)
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
            conditionLabel.trailingAnchor.constraint(
                lessThanOrEqualTo: letterLabel.leadingAnchor, constant: -Self.glyphSpacing),
            conditionLabel.centerYAnchor.constraint(equalTo: cell.centerYAnchor),
            letterLabel.trailingAnchor.constraint(equalTo: cell.trailingAnchor),
            letterLabel.centerYAnchor.constraint(equalTo: cell.centerYAnchor),
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
    /// user or a caller asked for, so it must not start another read. The rows below `row` move, so a
    /// letter can leave a resting pointer here as it does on a scroll, and a shown tooltip leaves too.
    private func reload(_ row: Row) {
        letterTooltip.dismiss()
        isReloading = true
        defer { isReloading = false }
        outlineView.reloadItem(row, reloadChildren: true)
    }
}

/// A row's cell: the name and glyph every row has, the label a failed entry's sentence goes in, and
/// the label a listed row's status letter goes in.
private final class EntryCell: NSTableCellView {
    let conditionLabel = NSTextField(labelWithString: "")
    let letterLabel = NSTextField(labelWithString: "")
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
        cell.imageView?.image = glyph(for: row.entry)
        // Every row sets the sentence, so a reused cell never carries a stale one.
        if let sentence = conditionSentence(for: row) {
            cell.conditionLabel.stringValue = sentence
            cell.conditionLabel.isHidden = false
        } else {
            cell.conditionLabel.stringValue = ""
            cell.conditionLabel.isHidden = true
        }
        // Likewise the letter: every row sets or clears it.
        if let category = markers.category(forRowPath: row.entry.path) {
            cell.letterLabel.stringValue = GitSentences.letter(for: category)
            cell.letterLabel.isHidden = false
        } else {
            cell.letterLabel.stringValue = ""
            cell.letterLabel.isHidden = true
        }
        return cell
    }

    package func outlineView(_ outlineView: NSOutlineView, rowViewForItem item: Any)
        -> NSTableRowView?
    {
        let rowView = BarRowView()
        rowView.drawsBar = barBelongs(on: item)
        return rowView
    }

    /// A selected file row is raised to the owner. A folder row and a status line raise nothing, and
    /// so does a selection posted while this view reloads its own rows, or shows the open file: that
    /// one is AppKit restoring or dropping a selection, or the owner's, not the user's.
    package func outlineViewSelectionDidChange(_ notification: Notification) {
        guard !isReloading, !isShowingOpenFile,
            let row = outlineView.item(atRow: outlineView.selectedRow) as? Row,
            row.entry.kind == .file
        else { return }
        fileSelected?(row.entry)
    }

    /// The one hook an expansion passes through. `expandItem(_:)` fires it before the item opens
    /// (measured in the plan for this change). That a disclosure click fires it too is not
    /// measured here: it is held by review, and by the owner's walk of the running app.
    package func outlineViewItemWillExpand(_ notification: Notification) {
        guard !isReloading, let row = notification.userInfo?["NSObject"] as? Row else { return }
        beginRead(of: row)
    }
}
