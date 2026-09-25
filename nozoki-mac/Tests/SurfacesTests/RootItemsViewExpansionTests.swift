import AppKit
import XCTest

@testable import Surfaces

/// CP-196 – CP-202 and CP-204: a folder row expands into its read, and says what the read found.
/// The view never reaches the bridge, so each test plays the shell: it records the intent's calls and
/// answers through the sink each call handed out.
@MainActor
final class RootItemsViewExpansionTests: XCTestCase {
    private let folderGlyph = NSImage(size: NSSize(width: 1, height: 1))
    private let fileGlyph = NSImage(size: NSSize(width: 2, height: 2))
    private let readingSentence = "Reading this folder."
    private let noFilesSentence = "This folder has no files."
    private let cantReadSentence = "Nozoki can't read this folder."
    private let loopSentence = "This link loops back on itself, so Nozoki can't read it."

    /// One call of the view's `list_tree` intent, with the sink it handed out.
    private struct Read {
        let path: String
        let answer: ListTreeAnswer
    }

    private final class ReadLog {
        var reads: [Read] = []
        var paths: [String] { reads.map(\.path) }
    }

    private func makeView(_ entries: [Entry]) -> (view: RootItemsView, log: ReadLog) {
        let view = RootItemsView(folderGlyph: folderGlyph, fileGlyph: fileGlyph)
        let log = ReadLog()
        view.listTree = { path, answer in log.reads.append(Read(path: path, answer: answer)) }
        view.show(.observed(entries))
        return (view, log)
    }

    private func folder(_ name: String, path: String? = nil) -> Entry {
        Entry(name: name, path: path ?? name, kind: .folder, state: .pending)
    }

    private func file(_ name: String, path: String? = nil, state: EntryState = .observed) -> Entry {
        Entry(name: name, path: path ?? name, kind: .file, state: state)
    }

    private var plainRoot: [Entry] {
        [folder("docs"), file(".hidden-note"), file("readme.txt")]
    }

    /// Every row's name, with a line item written as `line: <its text>`.
    private func rowLabels(_ view: RootItemsView) -> [String] {
        (0..<view.outlineView.numberOfRows).map { row in
            if let line = view.lineText(atRow: row) { return "line: \(line)" }
            return view.entry(atRow: row)?.name ?? "?"
        }
    }

    private func row(_ name: String, in view: RootItemsView) throws -> Int {
        try XCTUnwrap(
            (0..<view.outlineView.numberOfRows).first { view.entry(atRow: $0)?.name == name },
            "no row named \(name)")
    }

    private func expand(_ name: String, in view: RootItemsView) throws {
        view.outlineView.expandItem(view.outlineView.item(atRow: try row(name, in: view)))
    }

    private func collapse(_ name: String, in view: RootItemsView) throws {
        view.outlineView.collapseItem(view.outlineView.item(atRow: try row(name, in: view)))
    }

    private func cell(_ view: RootItemsView, row: Int) throws -> NSTableCellView {
        let made = view.outlineView.view(atColumn: 0, row: row, makeIfNecessary: true)
        return try XCTUnwrap(made as? NSTableCellView)
    }

    /// The sentence beside a row, or nil when none is shown. The label is found by its identifier,
    /// because the cell's `textField` stays the entry's name.
    private func conditionText(_ view: RootItemsView, _ name: String) throws -> String? {
        let label = try cell(view, row: row(name, in: view)).subviews.compactMap {
            $0 as? NSTextField
        }.first { $0.identifier?.rawValue == "entryCondition" }
        guard let label, !label.isHidden, !label.stringValue.isEmpty else { return nil }
        return label.stringValue
    }

    /// Every piece of text a cell shows.
    private func visibleTexts(_ cell: NSTableCellView) -> [String] {
        cell.subviews.compactMap { $0 as? NSTextField }
            .filter { !$0.isHidden && !$0.stringValue.isEmpty }
            .map(\.stringValue)
    }

    /// Answers the `index`th read the view asked for, failing the test when there was none.
    private func deliver(_ log: ReadLog, _ index: Int, _ listing: RootListing?) throws {
        let read = try XCTUnwrap(
            log.reads.indices.contains(index) ? log.reads[index] : nil,
            "read \(index) was never asked for")
        read.answer(listing)
    }

    private func isExpandable(_ view: RootItemsView, row: Int) -> Bool {
        view.outlineView.isExpandable(view.outlineView.item(atRow: row))
    }

    func testExpandingAFolderRowAsksForItsPathNotItsName() throws {
        let (view, log) = makeView([folder("guides", path: "docs/guides")])

        try expand("guides", in: view)

        XCTAssertEqual(log.paths, ["docs/guides"])
    }

    func testAnObservedAnswerDrawsItsEntriesBeneathTheRow() throws {
        let (view, log) = makeView(plainRoot)
        try expand("docs", in: view)

        try deliver(log, 0, .observed([folder("guides", path: "docs/guides")]))

        XCTAssertEqual(rowLabels(view), ["docs", "guides", ".hidden-note", "readme.txt"])
        XCTAssertTrue(isExpandable(view, row: 1))
        XCTAssertFalse(view.outlineView.isItemExpanded(view.outlineView.item(atRow: 1)))
    }

    func testCollapsingHidesTheChildrenAndLeavesTheRootRows() throws {
        let (view, log) = makeView(plainRoot)
        try expand("docs", in: view)
        try deliver(log, 0, .observed([folder("guides", path: "docs/guides")]))

        try collapse("docs", in: view)

        XCTAssertEqual(rowLabels(view), ["docs", ".hidden-note", "readme.txt"])
    }

    func testExpandingAgainReadsAgainAndDropsTheOldChildren() throws {
        let (view, log) = makeView(plainRoot)
        try expand("docs", in: view)
        try deliver(log, 0, .observed([folder("guides", path: "docs/guides")]))
        try collapse("docs", in: view)

        try expand("docs", in: view)

        XCTAssertEqual(log.paths, ["docs", "docs"])
        XCTAssertEqual(
            rowLabels(view), ["docs", "line: \(readingSentence)", ".hidden-note", "readme.txt"])
    }

    func testChildrenKeepTheAnswersOrder() throws {
        let (view, log) = makeView([folder("docs")])
        try expand("docs", in: view)

        try deliver(
            log, 0,
            .observed([
                file("zeta.txt", path: "docs/zeta.txt"),
                file("alpha.txt", path: "docs/alpha.txt"),
                file("Mid.txt", path: "docs/Mid.txt"),
            ]))

        XCTAssertEqual(rowLabels(view), ["docs", "zeta.txt", "alpha.txt", "Mid.txt"])
    }

    func testAReadStillOutDrawsOnlyTheReadingLine() throws {
        let (view, _) = makeView([folder("docs"), file("readme.txt")])

        try expand("docs", in: view)

        XCTAssertEqual(rowLabels(view), ["docs", "line: \(readingSentence)", "readme.txt"])
        XCTAssertFalse(isExpandable(view, row: 1), "a line item is never expandable")
        XCTAssertNil(view.entry(atRow: 1), "a line item is not an entry")
        let docsCell = try cell(view, row: 0)
        XCTAssertEqual(visibleTexts(docsCell), ["docs"], "no sentence and no count beside the row")
        XCTAssertNil(try conditionText(view, "docs"))
        let lineCell = try cell(view, row: 1)
        XCTAssertEqual(visibleTexts(lineCell), [readingSentence])
        for shown in [docsCell, lineCell] {
            XCTAssertFalse(shown.subviews.contains { $0 is NSProgressIndicator }, "no spinner")
        }
        XCTAssertFalse(lineCell.subviews.contains { $0 is NSImageView }, "a line draws no glyph")
    }

    func testANeverExpandedFolderRowDrawsNameAndGlyphOnly() throws {
        let (view, log) = makeView(plainRoot)

        XCTAssertEqual(rowLabels(view), ["docs", ".hidden-note", "readme.txt"])
        let docsCell = try cell(view, row: 0)
        XCTAssertEqual(visibleTexts(docsCell), ["docs"])
        XCTAssertTrue(docsCell.imageView?.image === folderGlyph)
        XCTAssertEqual(log.paths, [], "nothing is read until a row is expanded")
    }

    func testACollapsedRowWithAReadOutDrawsNoLine() throws {
        let (view, _) = makeView(plainRoot)
        try expand("docs", in: view)

        try collapse("docs", in: view)

        XCTAssertEqual(view.outlineView.numberOfRows, 3)
        XCTAssertEqual(rowLabels(view), ["docs", ".hidden-note", "readme.txt"])
    }

    func testAnObservedEmptyAnswerDrawsTheNoFilesLine() throws {
        let (view, log) = makeView([folder("docs")])
        try expand("docs", in: view)

        try deliver(log, 0, .observed([]))

        XCTAssertEqual(rowLabels(view), ["docs", "line: \(noFilesSentence)"])
    }

    func testAFailedReadPutsItsSentenceBesideTheRowAndTheSiblingsStand() throws {
        let (view, log) = makeView([folder("locked"), file("a.txt")])
        try expand("locked", in: view)

        try deliver(log, 0, .failed(.unreadable))

        XCTAssertEqual(try conditionText(view, "locked"), cantReadSentence)
        XCTAssertEqual(rowLabels(view), ["locked", "a.txt"], "nothing beneath the failed folder")
        let siblingCell = try cell(view, row: row("a.txt", in: view))
        XCTAssertEqual(visibleTexts(siblingCell), ["a.txt"])
        XCTAssertTrue(siblingCell.imageView?.image === fileGlyph)
    }

    func testReExpandingAFailedFolderClearsTheSentenceWhileTheReadIsOut() throws {
        let (view, log) = makeView([folder("locked"), file("a.txt")])
        try expand("locked", in: view)
        try deliver(log, 0, .failed(.unreadable))

        try collapse("locked", in: view)
        try expand("locked", in: view)

        XCTAssertEqual(rowLabels(view), ["locked", "line: \(readingSentence)", "a.txt"])
        XCTAssertNil(try conditionText(view, "locked"))
        try deliver(log, 1, .observed([file("x.txt", path: "locked/x.txt")]))
        XCTAssertEqual(rowLabels(view), ["locked", "x.txt", "a.txt"])
        XCTAssertNil(try conditionText(view, "locked"))
    }

    func testNoAnswerDrawsNothingBeneathTheRow() throws {
        let (view, log) = makeView([folder("docs"), file("a.txt")])
        try expand("docs", in: view)

        try deliver(log, 0, nil)

        XCTAssertEqual(rowLabels(view), ["docs", "a.txt"])
        XCTAssertNil(try conditionText(view, "docs"))
    }

    func testExpandedRowsAtEveryDepthDrawNoMarker() throws {
        let (view, log) = makeView([folder(".git"), folder("src")])
        try expand(".git", in: view)
        try deliver(
            log, 0,
            .observed([file("HEAD", path: ".git/HEAD"), folder("objects", path: ".git/objects")]))
        try expand("src", in: view)
        try deliver(
            log, 1,
            .observed([file("main.rs", path: "src/main.rs"), folder("bin", path: "src/bin")]))
        try expand("objects", in: view)
        try deliver(log, 2, .observed([file("pack", path: ".git/objects/pack")]))

        XCTAssertEqual(
            rowLabels(view), [".git", "HEAD", "objects", "pack", "src", "main.rs", "bin"])
        for row in 0..<view.outlineView.numberOfRows {
            let name = try XCTUnwrap(view.entry(atRow: row)?.name)
            XCTAssertEqual(visibleTexts(try cell(view, row: row)), [name], "row \(row)")
        }
        XCTAssertEqual(view.outlineView.level(forRow: 3), 2, "the file under objects is at depth 2")
    }

    func testAChildFolderExpandsWithItsOwnPath() throws {
        let (view, log) = makeView([folder("docs"), file("readme.txt")])
        try expand("docs", in: view)
        try deliver(
            log, 0,
            .observed([folder("guides", path: "docs/guides"), file("broken", path: "docs/broken")])
        )
        try expand("guides", in: view)
        XCTAssertEqual(log.paths, ["docs", "docs/guides"])

        try deliver(
            log, 1,
            .observed([
                file("intro.md", path: "docs/guides/intro.md"),
                file("loop", path: "docs/guides/loop", state: .failed(.cycle)),
            ]))

        XCTAssertEqual(
            rowLabels(view), ["docs", "guides", "intro.md", "loop", "broken", "readme.txt"])
        XCTAssertEqual(view.outlineView.level(forRow: 3), 2)
        XCTAssertEqual(try conditionText(view, "loop"), loopSentence)
        XCTAssertFalse(isExpandable(view, row: 3), "a failed entry is never expandable")
    }

    func testAFailureArrivingWhileCollapsedStaysBesideTheRow() throws {
        let (view, log) = makeView([folder("locked"), file("a.txt")])
        try expand("locked", in: view)
        try collapse("locked", in: view)

        try deliver(log, 0, .failed(.unreadable))

        XCTAssertEqual(rowLabels(view), ["locked", "a.txt"])
        XCTAssertEqual(try conditionText(view, "locked"), cantReadSentence)
        try expand("locked", in: view)
        XCTAssertNil(try conditionText(view, "locked"), "a new read clears the old failure")
        XCTAssertEqual(rowLabels(view), ["locked", "line: \(readingSentence)", "a.txt"])
    }

    func testAnAnswerForASupersededReadIsIgnored() throws {
        let (view, log) = makeView([folder("docs")])
        try expand("docs", in: view)
        try collapse("docs", in: view)
        try expand("docs", in: view)

        try deliver(log, 0, .observed([file("stale.txt", path: "docs/stale.txt")]))

        XCTAssertEqual(rowLabels(view), ["docs", "line: \(readingSentence)"])
        try deliver(log, 1, .observed([file("fresh.txt", path: "docs/fresh.txt")]))
        XCTAssertEqual(rowLabels(view), ["docs", "fresh.txt"])
    }

    func testAnAnswerAfterTheRootIsReplacedIsIgnored() throws {
        let (view, log) = makeView([folder("docs")])
        try expand("docs", in: view)
        view.show(.observed([folder("docs")]))

        try deliver(log, 0, .observed([file("ghost.txt", path: "docs/ghost.txt")]))

        XCTAssertEqual(rowLabels(view), ["docs"])
        XCTAssertFalse(view.outlineView.isItemExpanded(view.outlineView.item(atRow: 0)))
    }

    func testAnAnswerForARowItsParentsReReadReplacedIsIgnored() throws {
        let (view, log) = makeView([folder("docs")])
        try expand("docs", in: view)
        try deliver(log, 0, .observed([folder("guides", path: "docs/guides")]))
        try expand("guides", in: view)
        try collapse("docs", in: view)
        try expand("docs", in: view)
        try deliver(log, 2, .observed([folder("guides", path: "docs/guides")]))
        try expand("guides", in: view)

        try deliver(log, 1, .observed([file("ghost.txt", path: "docs/guides/ghost.txt")]))

        XCTAssertEqual(rowLabels(view), ["docs", "guides", "line: \(readingSentence)"])
    }

    func testASinkAppliesOnlyItsFirstAnswer() throws {
        let (view, log) = makeView([folder("docs")])
        try expand("docs", in: view)

        try deliver(log, 0, .observed([file("first.txt", path: "docs/first.txt")]))
        try deliver(log, 0, .observed([file("second.txt", path: "docs/second.txt")]))

        XCTAssertEqual(rowLabels(view), ["docs", "first.txt"])
    }

    func testExpandingWithNoIntentStillDrawsTheReadingLine() throws {
        let view = RootItemsView(folderGlyph: folderGlyph, fileGlyph: fileGlyph)
        view.show(.observed([folder("docs")]))

        try expand("docs", in: view)

        XCTAssertEqual(rowLabels(view), ["docs", "line: \(readingSentence)"])
    }
}
