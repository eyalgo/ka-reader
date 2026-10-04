import AppKit

/// The row a click on the Git view activates: the row's folder-relative path.
package typealias GitRowActivated = @MainActor (_ path: String) -> Void

private enum GitViewLayout {
    /// `docs/DESIGN.md` `{spacing.row}`: every list row's height.
    static let rowHeight: CGFloat = 24
    /// `docs/DESIGN.md` `{spacing.md}`: a row's and a heading's inner padding.
    static let padding: CGFloat = 12
    /// `docs/DESIGN.md` `{spacing.sm}`: between a path and its letter, and a heading and its count.
    static let gap: CGFloat = 8
    /// `docs/DESIGN.md` `{spacing.xl}`: a status message's inset from its surface's top-left.
    static let messageInset: CGFloat = 24
}

/// The Git view (`docs/UXD.md` UX-S3): shown a Git item, it draws exactly one of four
/// presentations and nothing else. *Pending* is the reading sentence. *Plain* is nothing at all.
/// *Repository* is the branch element, the short status where one is drawn, and each non-empty list
/// under its heading and count, its rows in `GitRowOrder`'s order. *Failed* and *stopped* are each
/// one failure message.
///
/// A click anywhere on a row raises `rowActivated` with its path, and the clicked row carries the
/// bar. A status letter raises a tooltip when the pointer rests on it, and nothing else in the view
/// does (CP-586, CP-597). A view that has been shown nothing is pending.
@MainActor
package final class GitView: NSView {
    private struct DrawnRow {
        let entry: GitEntry
        let view: BarRowView
        let letter: NSTextField

        var path: String { entry.path }
    }

    private let statusGlyphs: StatusGlyphs
    private let tooltipRest: TooltipRest

    /// The tooltip a status letter raises on pointer rest (CP-586). A lazy property because it is
    /// bound to this view, which an initialiser cannot name before it is built.
    package private(set) lazy var letterTooltip = LetterTooltip(
        host: self, rest: tooltipRest,
        letterAt: { [weak self] point in self?.letter(at: point) })

    /// Flags the row under the pointer so it draws its hover fill (CP-599). Lazy for the same
    /// reason as the tooltip.
    private lazy var rowHover = RowHover(
        host: self, rowAt: { [weak self] point in
            guard let self, let index = self.rowIndex(at: point) else { return nil }
            return self.rows[index].view
        })
    private let scrollView = NSScrollView()
    private let stack = NSStackView()
    private var rows: [DrawnRow] = []
    private var selectedIndex: Int?

    /// Set by the view's owner, and called once per click on a row.
    package var rowActivated: GitRowActivated?

    package init(statusGlyphs: StatusGlyphs, tooltipRest: TooltipRest = .live) {
        self.statusGlyphs = statusGlyphs
        self.tooltipRest = tooltipRest
        super.init(frame: .zero)
        let document = FlippedView()
        document.translatesAutoresizingMaskIntoConstraints = false
        stack.orientation = .vertical
        stack.alignment = .leading
        stack.spacing = 0
        stack.translatesAutoresizingMaskIntoConstraints = false
        document.addSubview(stack)
        scrollView.documentView = document
        scrollView.hasVerticalScroller = true
        scrollView.drawsBackground = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(scrollView)
        let clip = scrollView.contentView
        // A letter can leave a resting pointer by the list scrolling under it.
        clip.postsBoundsChangedNotifications = true
        NotificationCenter.default.addObserver(
            self, selector: #selector(listScrolled), name: NSView.boundsDidChangeNotification,
            object: clip)
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            document.topAnchor.constraint(equalTo: clip.topAnchor),
            document.leadingAnchor.constraint(equalTo: clip.leadingAnchor),
            document.widthAnchor.constraint(equalTo: clip.widthAnchor),
            stack.topAnchor.constraint(equalTo: document.topAnchor),
            stack.leadingAnchor.constraint(equalTo: document.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: document.trailingAnchor),
            stack.bottomAnchor.constraint(equalTo: document.bottomAnchor),
        ])
        show(.pending)
        _ = rowHover
    }

    @available(*, unavailable)
    package required init?(coder: NSCoder) {
        preconditionFailure("GitView is built in code only")
    }

    @objc private func listScrolled(_ notification: Notification) {
        letterTooltip.dismiss()
        rowHover.refresh()
    }

    /// A hidden view gets no exit event, so it lets go of the pointer and its fill itself (CP-602).
    override package func viewDidHide() {
        super.viewDidHide()
        rowHover.forget()
    }

    /// The row letter at `point` (in this view's coordinates) with the text it raises, or nil when
    /// the point is on no letter: a heading, a count, a path, the space beside it, the branch
    /// element and every message are on none (CP-587, CP-588). The text is built from that row's
    /// own printed path and category, so a path listed twice gives each row its own word (CP-594).
    private func letter(at point: NSPoint) -> LetterUnderPointer? {
        guard
            let row = rows.first(where: {
                $0.letter.bounds.contains($0.letter.convert(point, from: self))
            })
        else { return nil }
        return LetterUnderPointer(
            letter: row.letter,
            text: GitSentences.letterTooltip(name: row.entry.path, category: row.entry.category))
    }

    /// Replaces what is drawn with `item`, and drops the selection.
    package func show(_ item: GitItem) {
        letterTooltip.dismiss()
        for view in stack.arrangedSubviews {
            stack.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
        rows = []
        selectedIndex = nil
        switch item {
        case .pending:
            add(message: GitSentences.pending, glyph: statusGlyphs.empty)
        case .plain:
            break
        case .repository(let repository):
            draw(repository)
        case .failed(let failure):
            add(message: GitSentences.failure(failure), glyph: statusGlyphs.failure)
        case .stopped:
            add(message: GitSentences.fault, glyph: statusGlyphs.failure)
        }
        // Auto Layout places the rows, so they have no frames until the view is laid out; the row
        // under a still pointer is found against the frames they are about to have.
        layoutSubtreeIfNeeded()
        rowHover.refresh()
    }

    /// Takes the bar off every row.
    package func clearSelection() {
        selectedIndex = nil
        applySelection()
    }

    /// The `path` of every row that draws the bar, top to bottom.
    package func barPaths() -> [String] {
        rows.filter(\.view.drawsBar).map(\.path)
    }

    /// A click on a row, or on its letter, activates that row. Nothing else in the view acts on a
    /// click: a heading and a status message are not rows (`docs/DESIGN.md` § Rows).
    override package func mouseDown(with event: NSEvent) {
        guard let index = rowIndex(at: convert(event.locationInWindow, from: nil)) else { return }
        selectedIndex = index
        applySelection()
        rowActivated?(rows[index].path)
    }

    /// The index of the row a click at `point` (in this view's coordinates) acts on, or nil for a
    /// heading, a message and the space between. The hover reads the same answer, so it lands
    /// exactly where a click acts (CP-600, CP-609).
    private func rowIndex(at point: NSPoint) -> Int? {
        rows.firstIndex { $0.view.convert($0.view.bounds, to: self).contains(point) }
    }

    /// The `path` of every drawn row that shows the hover fill, top to bottom.
    package func hoverPaths() -> [String] {
        rows.filter(\.view.showsHover).map(\.path)
    }

    private func applySelection() {
        for (index, row) in rows.enumerated() {
            row.view.drawsBar = index == selectedIndex
        }
    }

    private func draw(_ repository: GitRepository) {
        let branchText: String
        switch repository.branch {
        case .named(let name): branchText = name
        case .detached(let commit): branchText = commit
        }
        add(
            line: NSTextField(labelWithString: branchText),
            insets: NSEdgeInsets(
                top: GitViewLayout.gap, left: GitViewLayout.padding, bottom: GitViewLayout.gap,
                right: GitViewLayout.padding))
        if let sentence = GitSentences.statusSentence(for: repository.state) {
            add(message: sentence, glyph: statusGlyphs.empty)
        } else if repository.staged.isEmpty && repository.changed.isEmpty {
            add(message: GitSentences.clean, glyph: statusGlyphs.empty)
        }
        add(list: repository.staged, heading: GitSentences.stagedHeading)
        add(list: repository.changed, heading: GitSentences.changesHeading)
    }

    private func add(list entries: [GitEntry], heading: String) {
        guard !entries.isEmpty else { return }
        pin(makeHeading(heading, count: entries.count))
        for entry in GitRowOrder.ordered(entries) {
            let (row, letter) = makeRow(entry)
            rows.append(DrawnRow(entry: entry, view: row, letter: letter))
            pin(row)
        }
    }

    private func add(message: String, glyph: NSImage) {
        let text = NSTextField(wrappingLabelWithString: message)
        text.isSelectable = false
        text.textColor = .secondaryLabelColor
        let status = StatusMessageView(glyph: glyph, texts: [text])
        add(
            line: status,
            insets: NSEdgeInsets(
                top: GitViewLayout.messageInset, left: GitViewLayout.messageInset,
                bottom: GitViewLayout.messageInset, right: GitViewLayout.messageInset))
    }

    /// Places `content` in the stack, inset from its edges.
    private func add(line content: NSView, insets: NSEdgeInsets) {
        let holder = NSView()
        content.translatesAutoresizingMaskIntoConstraints = false
        holder.addSubview(content)
        NSLayoutConstraint.activate([
            content.topAnchor.constraint(equalTo: holder.topAnchor, constant: insets.top),
            content.leadingAnchor.constraint(equalTo: holder.leadingAnchor, constant: insets.left),
            content.trailingAnchor.constraint(
                lessThanOrEqualTo: holder.trailingAnchor, constant: -insets.right),
            content.bottomAnchor.constraint(equalTo: holder.bottomAnchor, constant: -insets.bottom),
        ])
        pin(holder)
    }

    /// Adds `view` to the stack at the stack's full width.
    private func pin(_ view: NSView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        stack.addArrangedSubview(view)
        view.widthAnchor.constraint(equalTo: stack.widthAnchor).isActive = true
    }

    private func makeHeading(_ text: String, count: Int) -> NSView {
        let holder = NSView()
        let title = NSTextField(labelWithString: text)
        let number = NSTextField(labelWithString: String(count))
        number.textColor = .secondaryLabelColor
        for label in [title, number] {
            label.translatesAutoresizingMaskIntoConstraints = false
            holder.addSubview(label)
        }
        NSLayoutConstraint.activate([
            holder.heightAnchor.constraint(equalToConstant: GitViewLayout.rowHeight),
            title.leadingAnchor.constraint(
                equalTo: holder.leadingAnchor, constant: GitViewLayout.padding),
            title.centerYAnchor.constraint(equalTo: holder.centerYAnchor),
            number.leadingAnchor.constraint(
                equalTo: title.trailingAnchor, constant: GitViewLayout.gap),
            number.centerYAnchor.constraint(equalTo: holder.centerYAnchor),
        ])
        return holder
    }

    private func makeRow(_ entry: GitEntry) -> (BarRowView, NSTextField) {
        let row = BarRowView()
        let path = NSTextField(labelWithString: entry.path)
        path.identifier = NSUserInterfaceItemIdentifier("gitRowPath")
        path.lineBreakMode = .byClipping
        path.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        let letter = NSTextField(labelWithString: GitSentences.letter(for: entry.category))
        letter.identifier = NSUserInterfaceItemIdentifier("gitRowLetter")
        letter.setContentHuggingPriority(.required, for: .horizontal)
        for label in [path, letter] {
            label.translatesAutoresizingMaskIntoConstraints = false
            row.addSubview(label)
        }
        NSLayoutConstraint.activate([
            row.heightAnchor.constraint(equalToConstant: GitViewLayout.rowHeight),
            path.leadingAnchor.constraint(
                equalTo: row.leadingAnchor, constant: GitViewLayout.padding),
            path.centerYAnchor.constraint(equalTo: row.centerYAnchor),
            letter.trailingAnchor.constraint(
                equalTo: row.trailingAnchor, constant: -GitViewLayout.padding),
            letter.centerYAnchor.constraint(equalTo: row.centerYAnchor),
            path.trailingAnchor.constraint(
                lessThanOrEqualTo: letter.leadingAnchor, constant: -GitViewLayout.gap),
        ])
        return (row, letter)
    }
}

/// A document view whose origin is its top-left, so a list reads from the top of its scroll view.
private final class FlippedView: NSView {
    override var isFlipped: Bool { true }
}
