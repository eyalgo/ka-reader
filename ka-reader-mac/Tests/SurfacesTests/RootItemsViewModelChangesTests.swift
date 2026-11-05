import AppKit
import Testing

@testable import Surfaces

/// A folder's tree follows the model: `RootItemsView.apply(changes:)` draws the listings the model
/// changed, in place, and leaves expansion, selection and the open file to the reader's acts (the
/// tree-follows-the-disk change, E1 – E6). The view never reaches the bridge, so each test plays the
/// shell: it records the intent's calls, answers through the sinks they handed out, and hands changes
/// in as the decoded values the shell decodes. Every sentence is read from the catalogue symbol.
@MainActor
struct RootItemsViewModelChangesTests {
    private typealias Change = (path: String, listing: RootListing?)

    /// A view drawn in a window, with the intents and the selections it raised recorded.
    @MainActor
    private final class Harness {
        let view: RootItemsView
        let window: NSWindow
        var reads: [(path: String, answer: ListTreeAnswer)] = []
        /// Each collapse the view raised: its path and the sink it handed out.
        var collapses: [(path: String, answer: ListTreeAnswer)] = []
        var selected: [Entry] = []

        init() {
            let glyph = NSImage(size: NSSize(width: 1, height: 1))
            view = RootItemsView(
                folderGlyph: glyph, fileGlyph: glyph, fileCodeGlyph: glyph,
                statusGlyphs: StatusGlyphs(empty: glyph, failure: glyph))
            window = NSWindow(
                contentRect: NSRect(x: 0, y: 0, width: 300, height: 400), styleMask: [.borderless],
                backing: .buffered, defer: true)
            window.contentView = view
            view.listTree = { [weak self] path, act, answer in
                switch act {
                case .expand: self?.reads.append((path, answer))
                case .collapse: self?.collapses.append((path, answer))
                }
            }
            view.fileSelected = { [weak self] entry in self?.selected.append(entry) }
        }
    }

    private func folder(_ path: String) -> Entry {
        Entry(name: name(of: path), path: path, kind: .folder, state: .pending)
    }

    private func file(_ path: String) -> Entry {
        Entry(name: name(of: path), path: path, kind: .file, state: .observed)
    }

    private func name(of path: String) -> String {
        String(path.split(separator: "/").last ?? "")
    }

    private func makeHarness(_ root: [Entry]) -> Harness {
        let harness = Harness()
        harness.view.show(.observed(root))
        harness.window.layoutIfNeeded()
        return harness
    }

    private func labels(_ view: RootItemsView) -> [String] {
        (0..<view.outlineView.numberOfRows).map { row in
            if let line = view.lineText(atRow: row) { return "line: \(line)" }
            return view.entry(atRow: row)?.path ?? "?"
        }
    }

    private func rowIndex(_ path: String, in view: RootItemsView) -> Int? {
        (0..<view.outlineView.numberOfRows).first { view.entry(atRow: $0)?.path == path }
    }

    private func isExpanded(_ path: String, in view: RootItemsView) -> Bool {
        guard let index = rowIndex(path, in: view) else { return false }
        return view.outlineView.isItemExpanded(view.outlineView.item(atRow: index))
    }

    /// The reader's expansion of `path`, answered with `listing` through the sink it handed out.
    private func readerExpands(
        _ path: String, answering listing: RootListing?, in harness: Harness
    ) throws {
        let view = harness.view
        let index = try #require(rowIndex(path, in: view))
        view.outlineView.expandItem(view.outlineView.item(atRow: index))
        let read = try #require(harness.reads.last { $0.path == path })
        read.answer(listing)
    }

    private func readerCollapses(_ path: String, in view: RootItemsView) throws {
        let index = try #require(rowIndex(path, in: view))
        view.outlineView.collapseItem(view.outlineView.item(atRow: index))
    }

    private func conditionText(_ path: String, in view: RootItemsView) throws -> String? {
        let index = try #require(rowIndex(path, in: view))
        let cell = try #require(
            view.outlineView.view(atColumn: 0, row: index, makeIfNecessary: true)
                as? NSTableCellView)
        let label = cell.subviews.compactMap { $0 as? NSTextField }.first {
            $0.identifier?.rawValue == "entryCondition"
        }
        guard let label, !label.isHidden, !label.stringValue.isEmpty else { return nil }
        return label.stringValue
    }

    @Test func drawnRowsEqualTheAppliedListingsWithNoDuplicate() throws {
        let harness = makeHarness([folder("docs"), file("a.txt")])
        try readerExpands("docs", answering: .observed([folder("docs/guides")]), in: harness)
        let changes: [Change] = [
            ("", .observed([folder("docs"), file("a.txt"), file("b.txt")])),
            ("docs", .observed([folder("docs/guides"), file("docs/x.rs")])),
        ]

        harness.view.apply(changes: changes)
        harness.view.apply(changes: changes)

        #expect(labels(harness.view) == ["docs", "docs/guides", "docs/x.rs", "a.txt", "b.txt"])
    }

    @Test func anEmptyFolderShowsItsLineAndAnEmptyRootItsMessage() throws {
        let harness = makeHarness([folder("docs"), file("a.txt")])
        try readerExpands("docs", answering: .observed([file("docs/x.rs")]), in: harness)

        harness.view.apply(changes: [("docs", .observed([]))])

        #expect(
            labels(harness.view) == ["docs", "line: \(ConditionSentences.emptyFolder)", "a.txt"])

        harness.view.apply(changes: [("", .observed([]))])

        #expect(labels(harness.view) == [])
        #expect(harness.view.rootLineText == ConditionSentences.emptyRoot)
    }

    @Test func anExpandedRowStaysExpandedAndACollapsedRowStaysCollapsed() throws {
        let harness = makeHarness([folder("docs"), folder("src"), file("a.txt")])
        try readerExpands("docs", answering: .observed([file("docs/a.md")]), in: harness)

        harness.view.apply(changes: [
            ("docs", .observed([file("docs/a.md"), file("docs/b.md")])),
            ("src", .observed([file("src/lib.rs")])),
        ])

        #expect(isExpanded("docs", in: harness.view))
        #expect(!isExpanded("src", in: harness.view))
        #expect(
            labels(harness.view) == ["docs", "docs/a.md", "docs/b.md", "src", "a.txt"])

        try readerCollapses("docs", in: harness.view)
        harness.view.apply(changes: [("docs", .observed([file("docs/c.md")]))])

        #expect(!isExpanded("docs", in: harness.view))
        #expect(labels(harness.view) == ["docs", "src", "a.txt"])
    }

    @Test func aRowInsertedAboveTheSelectedFileMovesNoSelectionAndRaisesNoFileSelection() {
        let harness = makeHarness([folder("docs"), file("b.txt")])
        harness.view.showOpenFile(path: "b.txt")
        harness.view.markOpenFile(path: "b.txt")

        harness.view.apply(changes: [
            ("", .observed([file("0.txt"), folder("docs"), file("a.txt"), file("b.txt")]))
        ])

        let view = harness.view
        let selected = view.outlineView.selectedRow
        #expect(selected >= 0)
        #expect(view.entry(atRow: selected)?.path == "b.txt")
        #expect(view.selectionFillPaths() == ["b.txt"])
        #expect(harness.selected.isEmpty)
    }

    @Test func noPendingSentenceAndNoViewAddedBesideTheRows() {
        let harness = makeHarness([folder("docs"), file("a.txt")])
        let subviews = harness.view.subviews.count

        harness.view.apply(changes: [
            ("docs", nil), ("", .observed([folder("docs"), file("a.txt")])),
        ])

        #expect(labels(harness.view) == ["docs", "a.txt"])
        #expect(harness.view.subviews.count == subviews)
        #expect(harness.view.rootLineText == nil)
    }

    @Test func aRemovedFolderVanishesAndOnReturnIsExpandedAgainWithTheFileSelected() throws {
        let harness = makeHarness([folder("docs"), file("b.txt")])
        try readerExpands(
            "docs", answering: .observed([file("docs/keep.txt"), file("docs/old.txt")]),
            in: harness)
        harness.view.showOpenFile(path: "docs/keep.txt")
        harness.view.markOpenFile(path: "docs/keep.txt")

        harness.view.apply(changes: [("", .observed([file("b.txt")]))])

        #expect(labels(harness.view) == ["b.txt"])

        harness.view.apply(changes: [
            ("", .observed([folder("docs"), file("b.txt")])),
            ("docs", .observed([file("docs/keep.txt"), file("docs/new.txt")])),
        ])

        let view = harness.view
        #expect(labels(view) == ["docs", "docs/keep.txt", "docs/new.txt", "b.txt"])
        #expect(isExpanded("docs", in: view))
        #expect(view.selectionFillPaths() == ["docs/keep.txt"])
        #expect(view.entry(atRow: view.outlineView.selectedRow)?.path == "docs/keep.txt")
        #expect(harness.selected.isEmpty)
    }

    @Test func aFileDrawnAtAFolderPathShowsNoChildrenAndNeverTheSelectionFill() throws {
        let harness = makeHarness([folder("docs"), file("b.txt")])
        try readerExpands("docs", answering: .observed([file("docs/x.txt")]), in: harness)
        harness.view.markOpenFile(path: "docs/x.txt")

        harness.view.apply(changes: [("", .observed([file("docs"), file("b.txt")]))])

        let view = harness.view
        #expect(labels(view) == ["docs", "b.txt"])
        #expect(!view.outlineView.isExpandable(view.outlineView.item(atRow: 0)))
        #expect(view.selectionFillPaths().isEmpty)
    }

    @Test func aFailedListingShowsTheCatalogueSentenceInThatRowsFailureSlotWithNothingBeneath()
        throws
    {
        let harness = makeHarness([folder("docs"), folder("src"), file("b.txt")])
        try readerExpands("docs", answering: .observed([file("docs/x.txt")]), in: harness)
        try readerExpands("src", answering: .observed([file("src/lib.rs")]), in: harness)

        harness.view.apply(changes: [("docs", .failed(.unreadable))])

        let view = harness.view
        #expect(labels(view) == ["docs", "src", "src/lib.rs", "b.txt"])
        #expect(try conditionText("docs", in: view) == ConditionSentences.row(for: .unreadable))
        #expect(try conditionText("src", in: view) == nil)

        view.apply(changes: [("docs", .observed([file("docs/y.txt")]))])

        #expect(labels(view) == ["docs", "docs/y.txt", "src", "src/lib.rs", "b.txt"])
        #expect(try conditionText("docs", in: view) == nil)
    }

    @Test func siblingsInEachOfTheFourStatesKeepThem() throws {
        let harness = makeHarness([folder("a"), folder("b"), folder("c"), folder("d")])
        try readerExpands("a", answering: .observed([file("a/x.rs")]), in: harness)
        try readerExpands("c", answering: .failed(.missing), in: harness)
        try readerExpands("d", answering: nil, in: harness)
        harness.view.outlineView.expandItem(
            harness.view.outlineView.item(atRow: try #require(rowIndex("b", in: harness.view))))
        let before = labels(harness.view)
        #expect(before.contains("line: \(ConditionSentences.readingFolder)"))

        harness.view.apply(changes: [
            ("", .observed([folder("a"), folder("b"), folder("c"), folder("d"), file("e.txt")]))
        ])

        let view = harness.view
        #expect(labels(view) == before + ["e.txt"])
        #expect(try conditionText("c", in: view) == ConditionSentences.row(for: .missing))

        view.apply(changes: [("d", .observed([file("d/y.rs")]))])

        #expect(labels(view).contains("d/y.rs"))
        #expect(labels(view).filter { $0.hasPrefix("line: ") }.count == 1)
    }
    @Test func aCollapseTheReaderMakesRaisesOneListTreeIntentWithTheCollapseAct() throws {
        let harness = makeHarness([folder("docs"), file("a.txt")])
        try readerExpands("docs", answering: .observed([file("docs/x.rs")]), in: harness)

        try readerCollapses("docs", in: harness.view)

        #expect(harness.collapses.map(\.path) == ["docs"])
        #expect(harness.reads.map(\.path) == ["docs"], "the collapse asked for no read")
        let before = labels(harness.view)
        harness.collapses[0].answer(.observed([file("docs/y.rs")]))
        harness.collapses[0].answer(nil)
        #expect(labels(harness.view) == before, "a collapse's answer draws nothing")
        #expect(!isExpanded("docs", in: harness.view))
    }

    @Test func aCollapseOrExpansionPostedDuringAReloadRaisesNoIntent() throws {
        let harness = makeHarness([folder("docs"), file("b.txt")])
        try readerExpands("docs", answering: .observed([folder("docs/guides")]), in: harness)
        try readerExpands(
            "docs/guides", answering: .observed([file("docs/guides/a.md")]), in: harness)
        let reads = harness.reads.count

        // The folder vanishes (AppKit posts its collapses during the reload) and then returns
        // (the view draws it expanded again, which posts expansions).
        harness.view.apply(changes: [("", .observed([file("b.txt")]))])
        harness.view.apply(changes: [
            ("", .observed([folder("docs"), file("b.txt")])),
            ("docs", .observed([folder("docs/guides")])),
            ("docs/guides", .observed([file("docs/guides/a.md")])),
        ])

        #expect(harness.collapses.isEmpty)
        #expect(harness.reads.count == reads)
        #expect(isExpanded("docs", in: harness.view))
    }
}
