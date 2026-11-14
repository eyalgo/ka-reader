import AppKit

/// One of the Git view's two lists (*Staged*, *Changes*): its rows in `GitRowOrder`'s order, drawn
/// only for the part of the list in view. The list is as tall as all its rows, so the scroll bar and
/// the scroll positions are the list's, but a row view exists only for a row that meets the scroll
/// view's visible rect, widened by `overscan` rows on each side. The views the Git view holds and the
/// layout work it does follow the window and not the number of rows (CP-1335, CP-1336).
///
/// A row is placed by its index, never by a constraint to a sibling, so no chain of constraints spans
/// the list. A row's views are built as the Git view has always built them, with the identifiers
/// `gitRowPath` and `gitRowLetter`, and a row that leaves the visible rect is kept as a spare for the
/// next one to come into view. Whatever a row shows, its path, its letter and its selection, is set
/// from the list's state each time it is realized, never from what its view showed last.
@MainActor
final class GitRowList: NSView {
    /// How many rows are kept realized past each edge of the visible rect.
    static let overscan = 4

    /// A row's three views: the row, and the path and the letter it holds.
    private struct RowViews {
        let row: BarRowView
        let path: NSTextField
        let letter: NSTextField
    }

    /// The list's entries, in row order.
    let entries: [GitEntry]

    private var realized: [Int: RowViews] = [:]
    private var spare: [RowViews] = []
    private var selectedRow: Int?

    /// `entries` are put in row order here; the first row is the first of the result.
    init(entries: [GitEntry]) {
        self.entries = GitRowOrder.ordered(entries)
        super.init(frame: .zero)
        heightAnchor.constraint(
            equalToConstant: CGFloat(self.entries.count) * GitViewLayout.rowHeight
        ).isActive = true
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { preconditionFailure("GitRowList is built in code only") }

    /// A list reads from its top, as the scroll view's document does.
    override var isFlipped: Bool { true }

    /// How many rows the list has.
    var count: Int { entries.count }

    /// The row at `index` is the selected one, or no row is. Applied now to a realized row and later
    /// to any row that is realized.
    func select(_ index: Int?) {
        selectedRow = index
        for (row, views) in realized { views.row.drawsSelection = row == index }
    }

    /// The view of the row at `index`, or nil while that row is not realized.
    func row(at index: Int) -> BarRowView? { realized[index]?.row }

    /// The index of every realized row, top to bottom.
    var realizedIndices: [Int] { realized.keys.sorted() }

    /// The index of the realized row holding `point`, given in `host`'s coordinates.
    func rowIndex(at point: NSPoint, in host: NSView) -> Int? {
        let local = convert(point, from: host)
        return realized.first { $0.value.row.frame.contains(local) }?.key
    }

    /// The realized row whose letter holds `point`, given in `host`'s coordinates: its index and its
    /// letter.
    func letter(at point: NSPoint, in host: NSView) -> (index: Int, letter: NSTextField)? {
        realized.first { $0.value.letter.bounds.contains($0.value.letter.convert(point, from: host)) }
            .map { ($0.key, $0.value.letter) }
    }

    /// Realizes the rows that meet the visible rect and lets go of the rest. Called by the Git view
    /// after a layout and on each scroll, so the rows the hover and the tooltip read are the ones in
    /// view.
    func tile() {
        if realizeVisibleRows() { needsLayout = true }
    }

    override func layout() {
        _ = realizeVisibleRows()
        for (index, views) in realized { views.row.frame = rowFrame(index) }
        super.layout()
    }

    // MARK: Which rows

    /// The rows to hold: those meeting the scroll view's visible rect, widened by the overscan. A
    /// view that has no size yet has no visible rect to meet, so it holds the first rows of the list,
    /// as many as the overscan; the rows it holds follow the visible rect when it gets one.
    private func rowsToRealize() -> Range<Int> {
        guard !entries.isEmpty, let clip = enclosingScrollView?.contentView else { return 0..<0 }
        guard clip.bounds.height > 0 else { return 0..<min(entries.count, Self.overscan) }
        let visible = convert(clip.bounds, from: clip)
        let top = Int((visible.minY / GitViewLayout.rowHeight).rounded(.down))
        let bottom = Int((visible.maxY / GitViewLayout.rowHeight).rounded(.up)) - 1
        guard bottom >= 0, top < entries.count else { return 0..<0 }
        return max(0, top - Self.overscan)..<(min(entries.count - 1, bottom + Self.overscan) + 1)
    }

    /// Realizes the rows to hold and lets go of the others. True when the set of realized rows moved.
    private func realizeVisibleRows() -> Bool {
        let wanted = rowsToRealize()
        let leaving = realized.keys.filter { !wanted.contains($0) }
        let arriving = wanted.filter { realized[$0] == nil }
        for index in leaving { release(index) }
        for index in arriving { realize(index) }
        return !leaving.isEmpty || !arriving.isEmpty
    }

    private func rowFrame(_ index: Int) -> NSRect {
        NSRect(
            x: 0, y: CGFloat(index) * GitViewLayout.rowHeight, width: bounds.width,
            height: GitViewLayout.rowHeight)
    }

    private func realize(_ index: Int) {
        let views = spare.popLast() ?? makeRowViews()
        let entry = entries[index]
        views.path.stringValue = entry.path
        views.letter.stringValue = GitSentences.letter(for: entry.category)
        views.row.drawsSelection = index == selectedRow
        views.row.pointerIsOver = false
        views.row.frame = rowFrame(index)
        addSubview(views.row)
        realized[index] = views
    }

    private func release(_ index: Int) {
        guard let views = realized.removeValue(forKey: index) else { return }
        views.row.removeFromSuperview()
        spare.append(views)
    }

    // MARK: A row's views

    private func makeRowViews() -> RowViews {
        let row = BarRowView()
        let path = NSTextField(labelWithString: "")
        path.identifier = NSUserInterfaceItemIdentifier("gitRowPath")
        path.lineBreakMode = .byClipping
        path.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        let letter = NSTextField(labelWithString: "")
        letter.identifier = NSUserInterfaceItemIdentifier("gitRowLetter")
        letter.setContentHuggingPriority(.required, for: .horizontal)
        for label in [path, letter] {
            label.translatesAutoresizingMaskIntoConstraints = false
            row.addSubview(label)
        }
        NSLayoutConstraint.activate([
            path.leadingAnchor.constraint(
                equalTo: row.leadingAnchor, constant: GitViewLayout.padding),
            path.centerYAnchor.constraint(equalTo: row.centerYAnchor),
            letter.trailingAnchor.constraint(
                equalTo: row.trailingAnchor, constant: -GitViewLayout.padding),
            letter.centerYAnchor.constraint(equalTo: row.centerYAnchor),
            path.trailingAnchor.constraint(
                lessThanOrEqualTo: letter.leadingAnchor, constant: -GitViewLayout.gap),
        ])
        return RowViews(row: row, path: path, letter: letter)
    }
}
