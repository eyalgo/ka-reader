import AppKit

/// The row a click on the Git view activates: the row's folder-relative path.
package typealias GitRowActivated = @MainActor (_ path: String) -> Void

enum GitViewLayout {
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
/// one failure message. An observed failure also has the read-at-open notice outside that slot.
///
/// A click anywhere on a row raises `rowActivated` with its path, and the clicked row is drawn as
/// selected: the selection fill and the bar. A status letter raises a tooltip when the pointer rests on it, and nothing else in the view
/// does (CP-586, CP-597). A view that has been shown nothing is pending.
@MainActor
package final class GitView: NSView {
    private let gitReadPolicy: GitReadPolicy
    private let statusGlyphs: StatusGlyphs
    private let tooltipRest: TooltipRest
    private let keyWindow: KeyWindowSource

    /// The tooltip a status letter raises on pointer rest (CP-586). A lazy property because it is
    /// bound to this view, which an initialiser cannot name before it is built.
    package private(set) lazy var letterTooltip = LetterTooltip(
        host: self, rest: tooltipRest, keyWindow: keyWindow,
        letterAt: { [weak self] point in self?.letter(at: point) })

    /// Flags the row under the pointer so it draws its hover fill (CP-599). Lazy for the same
    /// reason as the tooltip.
    private lazy var rowHover = RowHover(
        host: self, keyWindow: keyWindow,
        rowAt: { [weak self] point in
            self?.rowView(at: point)
        })
    private let scrollView = NSScrollView()
    private let stack = NSStackView()
    /// The Git view's lists, top to bottom: *Staged*, then *Changes*, each only when it has rows.
    /// Rows are numbered across them in that order, and the selection is such an index.
    private var lists: [GitRowList] = []
    private var selectedIndex: Int?

    /// Set by the view's owner, and called once per click on a row.
    package var rowActivated: GitRowActivated?

    package init(
        statusGlyphs: StatusGlyphs, tooltipRest: TooltipRest = .live,
        keyWindow: KeyWindowSource = .live, gitReadPolicy: GitReadPolicy = .build
    ) {
        self.gitReadPolicy = gitReadPolicy
        self.statusGlyphs = statusGlyphs
        self.tooltipRest = tooltipRest
        self.keyWindow = keyWindow
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
        // The rows in view change when the visible rect does, with the view's size, and when a list
        // moves in the document, as the read-at-open notice above it takes its height at a new width.
        for sized in [clip, document] {
            sized.postsFrameChangedNotifications = true
            NotificationCenter.default.addObserver(
                self, selector: #selector(listResized), name: NSView.frameDidChangeNotification,
                object: sized)
        }
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
        tileLists()
        rowHover.refresh()
    }

    @objc private func listResized(_ notification: Notification) {
        for list in lists { list.needsLayout = true }
    }

    /// Realizes each list's rows for the visible rect, and lays the new rows out so the hover and the
    /// tooltip read them where they are.
    private func tileLists() {
        for list in lists { list.tile() }
        layoutSubtreeIfNeeded()
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
        for list in lists {
            guard let hit = list.letter(at: point, in: self) else { continue }
            let entry = list.entries[hit.index]
            return LetterUnderPointer(
                letter: hit.letter,
                text: GitSentences.letterTooltip(name: entry.path, category: entry.category))
        }
        return nil
    }

    /// Replaces what is drawn with `item`, and drops the selection.
    package func show(_ item: GitItem) {
        letterTooltip.dismiss()
        for view in stack.arrangedSubviews {
            stack.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
        lists = []
        selectedIndex = nil
        if gitReadPolicy.showsNotice(for: item) { pin(GitReadNotice()) }
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
            add(message: GitSentences.faultBeforeRepository, glyph: statusGlyphs.failure)
        }
        // The rows are realized after the layout, for the visible rect it gives the lists; the row
        // under a still pointer is found against the rows that are then in view.
        layoutSubtreeIfNeeded()
        tileLists()
        rowHover.refresh()
    }

    /// Takes the selected drawing, the fill and the bar, off every row.
    package func clearSelection() {
        selectedIndex = nil
        applySelection()
    }

    /// The `path` of every row that draws the bar, top to bottom.
    package func barPaths() -> [String] {
        selectedPath.map { [$0] } ?? []
    }

    /// The `path` of every row that draws the selection fill, top to bottom.
    package func selectionFillPaths() -> [String] {
        selectedPath.map { [$0] } ?? []
    }

    /// The selected row's path. A selected row scrolled out of view is still the selected row.
    private var selectedPath: String? {
        selectedIndex.flatMap { located($0) }.map { $0.list.entries[$0.row].path }
    }

    /// The list and the row in it that the numbering across the lists gives `index`.
    private func located(_ index: Int) -> (list: GitRowList, row: Int)? {
        var first = 0
        for list in lists {
            if index < first + list.count { return (list, index - first) }
            first += list.count
        }
        return nil
    }

    /// A click on a row, or on its letter, activates that row. Nothing else in the view acts on a
    /// click: a heading and a status message are not rows (`docs/DESIGN.md` § Rows).
    override package func mouseDown(with event: NSEvent) {
        guard let index = rowIndex(at: convert(event.locationInWindow, from: nil)),
            let hit = located(index)
        else { return }
        selectedIndex = index
        applySelection()
        rowActivated?(hit.list.entries[hit.row].path)
    }

    /// The index of the row a click at `point` (in this view's coordinates) acts on, or nil for a
    /// heading, a message and the space between. A click lands only on a realized row, which is a
    /// row in view. The hover reads the same answer, so it lands exactly where a click acts
    /// (CP-600, CP-609).
    private func rowIndex(at point: NSPoint) -> Int? {
        var first = 0
        for list in lists {
            if let row = list.rowIndex(at: point, in: self) { return first + row }
            first += list.count
        }
        return nil
    }

    private func rowView(at point: NSPoint) -> BarRowView? {
        rowIndex(at: point).flatMap { located($0) }.flatMap { $0.list.row(at: $0.row) }
    }

    /// The `path` of every realized row that shows the hover fill, top to bottom.
    package func hoverPaths() -> [String] {
        lists.flatMap { list in
            list.realizedIndices.compactMap { index in
                list.row(at: index)?.showsHover == true ? list.entries[index].path : nil
            }
        }
    }

    private func applySelection() {
        let selected = selectedIndex.flatMap { located($0) }
        for list in lists { list.select(selected?.list === list ? selected?.row : nil) }
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
        let list = GitRowList(entries: entries)
        lists.append(list)
        pin(list)
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
}

/// A document view whose origin is its top-left, so a list reads from the top of its scroll view.
private final class FlippedView: NSView {
    override var isFlipped: Bool { true }
}

/// Whole catalogue notice, outside failure components and selectable rows.
/// DESIGN: ui 13, inkMuted, line height 1.4, spacing.xl inset.
@MainActor
final class GitReadNotice: NSView {
    let label = NSTextField(wrappingLabelWithString: GitSentences.readAtOpen)
    private var measuredHeight: NSLayoutConstraint?

    init() {
        super.init(frame: .zero)
        label.isSelectable = false
        label.font = .systemFont(ofSize: 13)
        label.textColor = CodeColors.inkMuted
        let paragraph = NSMutableParagraphStyle()
        paragraph.minimumLineHeight = 18.2
        paragraph.maximumLineHeight = 18.2
        label.attributedStringValue = NSAttributedString(
            string: GitSentences.readAtOpen,
            attributes: [
                .font: NSFont.systemFont(ofSize: 13), .foregroundColor: CodeColors.inkMuted,
                .paragraphStyle: paragraph,
            ])
        label.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            label.topAnchor.constraint(equalTo: topAnchor, constant: 24),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -24),
        ])
        let height = heightAnchor.constraint(equalToConstant: height(for: 260))
        height.isActive = true
        measuredHeight = height
    }

    // AppKit measures the actual wrapped cell, rather than estimating line count.
    // https://developer.apple.com/documentation/appkit/nscell/cellsize(forbounds:)
    func height(for width: CGFloat) -> CGFloat {
        ceil(
            label.cell?.cellSize(
                forBounds: NSRect(
                    x: 0, y: 0, width: max(1, width - 48), height: .greatestFiniteMagnitude)
            ).height ?? 0) + 48
    }

    override func layout() {
        measuredHeight?.constant = height(for: bounds.width)
        super.layout()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { preconditionFailure("GitReadNotice is built in code only") }
}
