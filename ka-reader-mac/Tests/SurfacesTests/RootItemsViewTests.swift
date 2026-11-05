import AppKit
import XCTest

@testable import Surfaces

@MainActor
final class RootItemsViewTests: XCTestCase {
    private let folderGlyph = NSImage(size: NSSize(width: 1, height: 1))
    private let fileGlyph = NSImage(size: NSSize(width: 2, height: 2))
    private let fileCodeGlyph = NSImage(size: NSSize(width: 5, height: 5))
    /// Distinct images for the two status glyphs, so a test can tell which one was drawn.
    private let statusGlyphs = StatusGlyphs(
        empty: NSImage(size: NSSize(width: 3, height: 3)),
        failure: NSImage(size: NSSize(width: 4, height: 4)))

    private func makeView(showing root: RootListing?) -> RootItemsView {
        let view = RootItemsView(
            folderGlyph: folderGlyph, fileGlyph: fileGlyph, fileCodeGlyph: fileCodeGlyph,
            statusGlyphs: statusGlyphs)
        view.show(root)
        return view
    }

    private func makeView(showing entries: [Entry]) -> RootItemsView {
        makeView(showing: .observed(entries))
    }

    private func cell(_ view: RootItemsView, row: Int) throws -> NSTableCellView {
        let made = view.outlineView.view(atColumn: 0, row: row, makeIfNecessary: true)
        return try XCTUnwrap(made as? NSTableCellView)
    }

    /// The failed-row sentence a cell shows, or nil when it shows none. The label is found by its
    /// identifier, because the cell's `textField` stays the entry's name.
    private func conditionText(_ cell: NSTableCellView) -> String? {
        let label = cell.subviews.compactMap { $0 as? NSTextField }
            .first { $0.identifier?.rawValue == "entryCondition" }
        guard let label, !label.isHidden, !label.stringValue.isEmpty else { return nil }
        return label.stringValue
    }

    private func entry(
        _ name: String, _ kind: EntryKind, _ state: EntryState, language: FloorLanguage? = nil
    ) -> Entry {
        Entry(name: name, path: name, kind: kind, state: state, language: language)
    }

    /// The images the rows draw, top to bottom.
    private func drawnGlyphs(_ view: RootItemsView) throws -> [NSImage?] {
        try (0..<view.outlineView.numberOfRows).map {
            try unsafe cell(view, row: $0).imageView?.image
        }
    }

    /// How many image views a row's cell holds: the glyph leading it is the only one.
    private func imageViewCount(_ cell: NSTableCellView) -> Int {
        cell.subviews.filter { $0 is NSImageView }.count
    }

    private var plainProjection: [Entry] {
        [
            entry("docs", .folder, .pending),
            entry(".hidden-note", .file, .observed),
            entry("outside-link", .file, .failed(.outside)),
            entry("readme.txt", .file, .observed),
        ]
    }

    private let outsideSentence =
        "This link leads outside the folder you opened, so KA-Reader doesn't read it."
    private let cantReadSentence = "KA-Reader can't read this folder."
    private let noFilesSentence = "This folder has no files."

    func testPlainProjectionDrawsFourRowsInOrderWithTheOutsideSentence() throws {
        let view = makeView(showing: plainProjection)

        XCTAssertEqual(view.outlineView.numberOfRows, 4)
        let names = try (0..<4).map { try unsafe cell(view, row: $0).textField?.stringValue }
        XCTAssertEqual(names, ["docs", ".hidden-note", "outside-link", "readme.txt"])
        unsafe XCTAssertTrue(try cell(view, row: 0).imageView?.image === folderGlyph)
        for row in 1...3 {
            unsafe XCTAssertTrue(try cell(view, row: row).imageView?.image === fileGlyph)
        }
        XCTAssertEqual(try conditionText(cell(view, row: 2)), outsideSentence)
        for row in [0, 1, 3] {
            XCTAssertNil(try conditionText(cell(view, row: row)))
        }
        let docs = view.outlineView.item(atRow: 0)
        XCTAssertTrue(view.outlineView.isExpandable(docs), "a folder row can be expanded")
        XCTAssertFalse(view.outlineView.isItemExpanded(docs), "and arrives collapsed")
        for row in 1...3 {
            XCTAssertFalse(
                view.outlineView.isExpandable(view.outlineView.item(atRow: row)),
                "a file row, a failed entry included, cannot")
        }
    }

    func testObservedEmptyRootDrawsTheNoFilesLine() {
        let view = makeView(showing: .observed([]))

        XCTAssertEqual(view.outlineView.numberOfRows, 0)
        XCTAssertEqual(view.rootLineText, noFilesSentence)
    }

    func testFailedRootDrawsTheCantReadLineAndNoRow() {
        for condition in [Condition.unreadable, .missing, .notAFolder] {
            let view = makeView(showing: .failed(condition))

            XCTAssertEqual(view.outlineView.numberOfRows, 0, "\(condition)")
            XCTAssertEqual(view.rootLineText, cantReadSentence, "\(condition)")
            XCTAssertNotEqual(view.rootLineText, noFilesSentence, "\(condition)")
        }
    }

    func testNilRootDrawsNoRowAndNoLine() {
        let view = makeView(showing: nil)

        XCTAssertEqual(view.outlineView.numberOfRows, 0)
        XCTAssertNil(view.rootLineText)
    }

    func testRepoProjectionDrawsNameAndGlyphOnly() throws {
        let view = makeView(showing: [
            entry(".git", .folder, .pending),
            entry("src", .folder, .pending),
            entry("README.md", .file, .observed),
        ])

        XCTAssertEqual(view.outlineView.numberOfRows, 3)
        XCTAssertNil(view.rootLineText)
        let names = [".git", "src", "README.md"]
        for row in 0..<3 {
            let drawn = try cell(view, row: row)
            XCTAssertNil(conditionText(drawn))
            // The only text a row draws is the name: no count, no marker, no word beside it.
            let visibleText = drawn.subviews.compactMap { $0 as? NSTextField }
                .filter { !$0.isHidden }.map(\.stringValue)
            XCTAssertEqual(visibleText, [names[row]])
            unsafe XCTAssertNotNil(drawn.imageView?.image)
        }
    }

    func testShowingAgainReplacesTheRowsAndTheLine() {
        let view = makeView(showing: .failed(.unreadable))
        XCTAssertEqual(view.rootLineText, cantReadSentence)

        view.show(.observed([entry("a.txt", .file, .observed)]))
        XCTAssertNil(view.rootLineText, "a stale line is not carried into a listing with rows")
        XCTAssertEqual(view.outlineView.numberOfRows, 1)

        view.show(.observed([]))
        XCTAssertEqual(view.rootLineText, noFilesSentence)
        XCTAssertEqual(view.outlineView.numberOfRows, 0)

        view.show(nil)
        XCTAssertNil(view.rootLineText)
    }

    func testCatalogueHoldsEachSentenceExactly() {
        let rows: [(Condition, String)] = [
            (.unreadable, "KA-Reader can't read this folder."),
            (
                .outside,
                "This link leads outside the folder you opened, so KA-Reader doesn't read it."
            ),
            (.cycle, "This link loops back on itself, so KA-Reader can't read it."),
            (.missing, "This link leads to something that isn't there."),
            (.tooManyLinks, "This link leads through more links than KA-Reader follows."),
            (.notAFolder, "KA-Reader can't read this folder."),
        ]

        for (condition, sentence) in rows {
            XCTAssertEqual(ConditionSentences.row(for: condition), sentence, "\(condition)")
        }
        XCTAssertEqual(ConditionSentences.failedRoot, "KA-Reader can't read this folder.")
        XCTAssertEqual(ConditionSentences.emptyRoot, "This folder has no files.")
    }

    func testEachRootRowCarriesItsConditionsSentence() throws {
        let view = makeView(showing: [
            entry("ping", .file, .failed(.cycle)),
            entry("pong", .file, .failed(.cycle)),
            entry("gone", .file, .failed(.missing)),
            entry("bad", .file, .failed(.missing)),
            entry("notes.txt", .file, .observed),
        ])
        let loopSentence = "This link loops back on itself, so KA-Reader can't read it."
        let missingSentence = "This link leads to something that isn't there."

        XCTAssertEqual(try conditionText(cell(view, row: 0)), loopSentence)
        XCTAssertEqual(try conditionText(cell(view, row: 1)), loopSentence)
        XCTAssertEqual(try conditionText(cell(view, row: 2)), missingSentence)
        XCTAssertEqual(try conditionText(cell(view, row: 3)), missingSentence)
        XCTAssertNil(try conditionText(cell(view, row: 4)))
    }

    func testFailedFileEntryDrawsTheFileGlyph() throws {
        let view = makeView(showing: [entry("gone", .file, .failed(.missing))])

        unsafe XCTAssertTrue(try cell(view, row: 0).imageView?.image === fileGlyph)
    }

    func testRowsEqualEntriesInCountAndOrder() throws {
        let entries = [
            entry("docs", .folder, .pending),
            entry("README.md", .file, .observed),
            entry("src", .folder, .pending),
        ]
        let view = makeView(showing: entries)

        XCTAssertEqual(view.outlineView.numberOfRows, entries.count)
        for (index, entry) in entries.enumerated() {
            unsafe XCTAssertEqual(try cell(view, row: index).textField?.stringValue, entry.name)
        }
    }

    func testDotNamedEntryIsKept() throws {
        let view = makeView(showing: [entry(".hidden-note", .file, .observed)])

        XCTAssertEqual(view.outlineView.numberOfRows, 1)
        unsafe XCTAssertEqual(try cell(view, row: 0).textField?.stringValue, ".hidden-note")
    }

    func testNestedEntryIsLabelledByNameNotPath() throws {
        let view = makeView(showing: [
            Entry(name: "guides", path: "docs/guides", kind: .folder, state: .pending)
        ])

        unsafe XCTAssertEqual(try cell(view, row: 0).textField?.stringValue, "guides")
    }

    func testFolderKindDrawsFolderGlyph() throws {
        let view = makeView(showing: [entry("docs", .folder, .pending)])

        unsafe XCTAssertTrue(try cell(view, row: 0).imageView?.image === folderGlyph)
    }

    func testRowsAreNotReordered() throws {
        let names = ["zebra", "apple", "mango"]
        let view = makeView(showing: names.map { entry($0, .file, .observed) })

        for (index, name) in names.enumerated() {
            unsafe XCTAssertEqual(try cell(view, row: index).textField?.stringValue, name)
        }
    }

    func testKindDecodesFromTheTwoWireStrings() throws {
        let wire =
            #"[{"name":"a","path":"a","kind":"folder","state":"pending"},"#
            + #"{"name":"b","path":"b","kind":"file","state":"observed","language":"plain"}]"#

        let entries = try JSONDecoder().decode([Entry].self, from: Data(wire.utf8))

        XCTAssertEqual(entries.map(\.kind), [.folder, .file])
    }

    func testEntryDecodesEachOfTheSevenLanguageNames() throws {
        let names = ["plain", "python", "shell", "javascript", "json", "yaml", "toml"]
        let wire =
            "["
            + names.map {
                #"{"name":"f","path":"f","kind":"file","state":"observed","language":"\#($0)"}"#
            }.joined(separator: ",") + "]"

        let entries = try JSONDecoder().decode([Entry].self, from: Data(wire.utf8))

        XCTAssertEqual(
            entries.map(\.language),
            [nil, .python, .shell, .javascript, .json, .yaml, .toml])
    }

    func testEntryRefusesAFileEntryWithoutALanguageMember() {
        let wire = #"{"name":"a","path":"a","kind":"file","state":"observed"}"#

        XCTAssertThrowsError(try JSONDecoder().decode(Entry.self, from: Data(wire.utf8)))
    }

    func testEntryRefusesAFileEntryWithAnUnknownLanguage() {
        for language in [#""rust""#, #""markdown""#, "7", "null"] {
            let wire =
                #"{"name":"a","path":"a","kind":"file","state":"observed","language":"#
                + language + "}"

            XCTAssertThrowsError(
                try JSONDecoder().decode(Entry.self, from: Data(wire.utf8)), language)
        }
    }

    func testFolderEntryDecodesWithNoLanguageMember() throws {
        let wire = #"{"name":"src","path":"src","kind":"folder","state":"pending"}"#

        let decoded = try JSONDecoder().decode(Entry.self, from: Data(wire.utf8))

        XCTAssertEqual(decoded.kind, .folder)
        XCTAssertNil(decoded.language)
    }

    func testFolderEntryIgnoresAnyLanguageMember() throws {
        for language in [#""python""#, #""rust""#, "7", "null", "{}"] {
            let wire =
                #"{"name":"scripts.py","path":"scripts.py","kind":"folder","state":"pending","language":"#
                + language + "}"

            let decoded = try JSONDecoder().decode(Entry.self, from: Data(wire.utf8))

            XCTAssertNil(decoded.language, language)
            let view = makeView(showing: [decoded])
            unsafe XCTAssertTrue(try cell(view, row: 0).imageView?.image === folderGlyph, language)
        }
    }

    func testFileRowUsesTheSuppliedLanguageWithoutClassifyingItsNameAgain() throws {
        let view = makeView(showing: [
            entry("notes.txt", .file, .observed, language: .python),
            entry("app.py", .file, .observed),
        ])

        unsafe XCTAssertTrue(try cell(view, row: 0).imageView?.image === fileCodeGlyph)
        unsafe XCTAssertTrue(try cell(view, row: 1).imageView?.image === fileGlyph)
    }

    func testPlainFileRowDrawsFileInEveryState() throws {
        let view = makeView(showing: [
            entry("a.txt", .file, .pending),
            entry("b.txt", .file, .observed),
            entry("gone", .file, .failed(.missing)),
        ])

        for row in 0..<3 {
            unsafe XCTAssertTrue(try cell(view, row: row).imageView?.image === fileGlyph, "\(row)")
            XCTAssertEqual(imageViewCount(try cell(view, row: row)), 1)
        }
        XCTAssertEqual(
            try conditionText(cell(view, row: 2)), "This link leads to something that isn't there.")
    }

    func testFileRowWithAFloorLanguageDrawsTheFileCodeGlyph() throws {
        let view = makeView(showing: [entry("app.py", .file, .observed, language: .python)])

        unsafe XCTAssertTrue(try cell(view, row: 0).imageView?.image === fileCodeGlyph)
        XCTAssertEqual(imageViewCount(try cell(view, row: 0)), 1)
    }

    func testPlainFileRowDrawsTheFileGlyph() throws {
        let view = makeView(showing: [entry("notes.txt", .file, .observed)])

        unsafe XCTAssertTrue(try cell(view, row: 0).imageView?.image === fileGlyph)
        XCTAssertEqual(imageViewCount(try cell(view, row: 0)), 1)
    }

    func testFolderRowDrawsTheFolderGlyphEvenWhenBuiltWithALanguage() throws {
        let view = makeView(showing: [entry("scripts.py", .folder, .pending, language: .python)])

        unsafe XCTAssertTrue(try cell(view, row: 0).imageView?.image === folderGlyph)
    }

    func testFileRowDrawsFileCodeInEveryState() throws {
        let view = makeView(showing: [
            entry("a.py", .file, .pending, language: .python),
            entry("b.py", .file, .observed, language: .python),
            entry("gone.py", .file, .failed(.missing), language: .python),
        ])

        for row in 0..<3 {
            unsafe XCTAssertTrue(
                try cell(view, row: row).imageView?.image === fileCodeGlyph, "\(row)")
        }
        XCTAssertEqual(
            try conditionText(cell(view, row: 2)), "This link leads to something that isn't there.")
    }

    /// The listing the bridge's own test proves it sends for the name table
    /// (`crates/ka-reader-bridge/tests/fixtures/list_tree_name_table.json`), drawn here.
    func testTreeDrawnFromTheBridgesListingWireFileLeadsEachRowWithTheRightGlyph() throws {
        // `ka-reader-mac/Tests/SurfacesTests/RootItemsViewTests.swift` → the repository root.
        let root = URL(fileURLWithPath: #filePath)
            .deletingLastPathComponent().deletingLastPathComponent()
            .deletingLastPathComponent().deletingLastPathComponent()
        let wire = try Data(
            contentsOf: root.appendingPathComponent(
                "crates/ka-reader-bridge/tests/fixtures/list_tree_name_table.json"))
        struct Listing: Decodable { let entries: [Entry] }
        let entries = try JSONDecoder().decode(Listing.self, from: wire).entries
        let view = makeView(showing: entries)

        let withFileCode: Set<String> = [
            "app.py", "stubs.pyi", "gui.pyw", "x.Py", "setup.sh", "x.bash", "x.zsh", "RUN.SH",
            "index.js", "index.mjs", "index.cjs", "App.jsx", "package.json", "archive.tar.json",
            "deploy.yml", "ci.yaml", "Build.YmL", "Cargo.toml", "gone.py",
        ]
        let withFile: Set<String> = [
            "notes.txt", "main.rs", "README", "Makefile", ".bashrc", ".py", "notes.",
            "README.md", "guide.markdown", "notes.MARKDOWN", "Makefile.py.bak", "x.ſh",
        ]
        XCTAssertEqual(view.outlineView.numberOfRows, entries.count)
        XCTAssertEqual(withFileCode.count + withFile.count + 1, entries.count)
        var seen: Set<String> = []
        for row in 0..<entries.count {
            let drawn = try cell(view, row: row)
            let name = try unsafe XCTUnwrap(drawn.textField?.stringValue)
            let image = unsafe drawn.imageView?.image
            seen.insert(name)
            if name == "scripts.py" {
                XCTAssertTrue(image === folderGlyph, name)
            } else if withFileCode.contains(name) {
                XCTAssertTrue(image === fileCodeGlyph, name)
            } else {
                XCTAssertTrue(withFile.contains(name), "\(name) is not in the name table")
                XCTAssertTrue(image === fileGlyph, name)
            }
        }
        XCTAssertEqual(seen, withFileCode.union(withFile).union(["scripts.py"]))
    }

    func testUnknownKindFailsToDecode() {
        for kind in ["socket", "symlink"] {
            let wire =
                #"[{"name":"a","path":"a","kind":"\#(kind)","state":"observed","language":"plain"}]"#

            XCTAssertThrowsError(
                try JSONDecoder().decode([Entry].self, from: Data(wire.utf8)), kind)
        }
    }

    func testUnknownStateOrConditionFailsToDecode() {
        let wires = [
            #"{"name":"a","path":"a","kind":"file","state":"stopped","language":"plain"}"#,
            #"{"name":"a","path":"a","kind":"file","state":"failed","condition":"gone","language":"plain"}"#,
        ]

        for wire in wires {
            XCTAssertThrowsError(try JSONDecoder().decode(Entry.self, from: Data(wire.utf8)), wire)
        }
    }

    func testEntryStateDecodesFromTheWireWithItsCondition() throws {
        let wire =
            #"[{"name":"a","path":"a","kind":"folder","state":"pending"},"#
            + #"{"name":"b","path":"b","kind":"file","state":"observed","language":"plain"},"#
            + #"{"name":"c","path":"c","kind":"file","state":"failed","condition":"not_a_folder","language":"plain"},"#
            + #"{"name":"d","path":"d","kind":"file","state":"failed","condition":"too_many_links","language":"plain"}]"#

        let entries = try JSONDecoder().decode([Entry].self, from: Data(wire.utf8))

        XCTAssertEqual(
            entries.map(\.state),
            [.pending, .observed, .failed(.notAFolder), .failed(.tooManyLinks)])
    }

    func testAFailedEntryWithoutAConditionFailsToDecode() {
        let wire = #"{"name":"a","path":"a","kind":"file","state":"failed","language":"plain"}"#

        XCTAssertThrowsError(try JSONDecoder().decode(Entry.self, from: Data(wire.utf8)))
    }

    // ---- Added by development-code-integrity (2026-09-25), derived from the intent it cites ----

    /// The text of every visible label the view draws outside its rows: every label beneath the
    /// view that is not beneath its outline view, at whatever depth the view keeps it.
    private func drawnLines(_ view: RootItemsView) -> [String] {
        visibleViewsOutsideTheRows(beneath: view, of: view).compactMap { $0 as? NSTextField }
            .map(\.stringValue)
    }

    private func visibleViewsOutsideTheRows(beneath parent: NSView, of view: RootItemsView)
        -> [NSView]
    {
        parent.subviews.filter { !$0.isHidden && $0 !== view.outlineView }.flatMap {
            [$0] + visibleViewsOutsideTheRows(beneath: $0, of: view)
        }
    }

    /// CP-186, CP-187 and CP-188 are about what the window *draws*: exactly one line for an observed
    /// empty root and for a failed one, and no line where there are rows or no answer. The other
    /// tests read `rootLineText`, which is set beside the label and would stay right if the label
    /// were never filled or never shown. This one reads the label itself.
    func testTheRootLineIsTheOneLabelDrawnOutsideTheRows() {
        let cases: [(String, RootListing?, [String])] = [
            ("observed and empty", .observed([]), [noFilesSentence]),
            ("failed", .failed(.unreadable), [cantReadSentence]),
            ("observed with rows", .observed([entry("a.txt", .file, .observed)]), []),
            ("no answer", nil, []),
        ]

        for (label, root, expected) in cases {
            XCTAssertEqual(drawnLines(makeView(showing: root)), expected, label)
        }
        let reused = makeView(showing: .observed([]))
        reused.show(.observed([entry("a.txt", .file, .observed)]))
        XCTAssertEqual(drawnLines(reused), [], "a line drawn earlier is taken down")
    }

    // MARK: - Showing a file opened from outside the tree (CP-565, CP-550)

    /// A tree of `src/` (collapsed, holding `x.txt`) and two files, hosted in a window short enough
    /// that it scrolls, with every `list_tree` answered at once and every `fileSelected` recorded.
    private struct OpenFileFixture {
        let view: RootItemsView
        let window: NSWindow
        let selected: SelectedLog
        let reads: ReadCount
    }

    private final class SelectedLog {
        var paths: [String] = []
    }

    private final class ReadCount {
        var count = 0
    }

    private func makeOpenFileFixture() -> OpenFileFixture {
        let view = RootItemsView(
            folderGlyph: folderGlyph, fileGlyph: fileGlyph, fileCodeGlyph: fileCodeGlyph,
            statusGlyphs: statusGlyphs)
        let selected = SelectedLog()
        let reads = ReadCount()
        view.fileSelected = { selected.paths.append($0.path) }
        view.listTree = { _, act, answer in
            guard act == .expand else { return }
            reads.count += 1
            answer(
                .observed([
                    Entry(name: "x.txt", path: "src/x.txt", kind: .file, state: .observed)
                ]))
        }
        let files = (0..<40).map { unsafe entry(String(format: "f%02d.txt", $0), .file, .observed) }
        view.show(.observed([entry("src", .folder, .pending)] + files))
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 260, height: 200), styleMask: [.borderless],
            backing: .buffered, defer: true)
        window.contentView = view
        view.layoutSubtreeIfNeeded()
        return OpenFileFixture(view: view, window: window, selected: selected, reads: reads)
    }

    private func rowIndex(of path: String, in view: RootItemsView) -> Int? {
        (0..<view.outlineView.numberOfRows).first { view.entry(atRow: $0)?.path == path }
    }

    private func expandedPaths(_ view: RootItemsView) -> [String] {
        (0..<view.outlineView.numberOfRows).compactMap { row in
            let item = view.outlineView.item(atRow: row)
            return view.outlineView.isItemExpanded(item) ? view.entry(atRow: row)?.path : nil
        }
    }

    private func scrollOffset(_ view: RootItemsView) -> NSPoint {
        view.contentView.bounds.origin
    }

    func test_theOpenFileOperationSelectsTheRowOfAPathTheTreeShows() throws {
        let fixture = makeOpenFileFixture()
        let row = try XCTUnwrap(rowIndex(of: "f03.txt", in: fixture.view))

        fixture.view.showOpenFile(path: "f03.txt")

        XCTAssertEqual(fixture.view.outlineView.selectedRowIndexes, IndexSet(integer: row))
        XCTAssertEqual(fixture.view.openFilePath, "f03.txt")
        XCTAssertEqual(fixture.view.barPaths(), ["f03.txt"])

        fixture.view.showOpenFile(path: "f05.txt")
        let next = try XCTUnwrap(rowIndex(of: "f05.txt", in: fixture.view))
        XCTAssertEqual(
            fixture.view.outlineView.selectedRowIndexes, IndexSet(integer: next),
            "the earlier row is no longer selected")
    }

    func test_itSelectsNoRowForAPathUnderACollapsedFolder() throws {
        let fixture = makeOpenFileFixture()
        let src = try XCTUnwrap(rowIndex(of: "src", in: fixture.view))
        fixture.view.outlineView.expandItem(fixture.view.outlineView.item(atRow: src))
        fixture.view.showOpenFile(path: "src/x.txt")
        XCTAssertEqual(fixture.view.outlineView.selectedRowIndexes.count, 1)

        fixture.view.outlineView.collapseItem(fixture.view.outlineView.item(atRow: src))
        fixture.view.showOpenFile(path: "f01.txt")
        XCTAssertEqual(fixture.view.outlineView.selectedRowIndexes.count, 1)
        fixture.view.showOpenFile(path: "src/x.txt")

        XCTAssertTrue(
            fixture.view.outlineView.selectedRowIndexes.isEmpty,
            "the row the tree does not show is not selected, and the earlier one is let go")
        XCTAssertEqual(fixture.view.openFilePath, "src/x.txt")
        XCTAssertNil(rowIndex(of: "src/x.txt", in: fixture.view))
    }

    func test_itRaisesNoFileSelected() throws {
        let fixture = makeOpenFileFixture()
        let src = try XCTUnwrap(rowIndex(of: "src", in: fixture.view))
        fixture.view.outlineView.expandItem(fixture.view.outlineView.item(atRow: src))

        fixture.view.showOpenFile(path: "f03.txt")
        fixture.view.showOpenFile(path: "src/x.txt")
        fixture.view.outlineView.collapseItem(fixture.view.outlineView.item(atRow: src))
        fixture.view.showOpenFile(path: "src/x.txt")
        fixture.view.showOpenFile(path: nil)

        XCTAssertEqual(fixture.selected.paths, [])
    }

    func test_itExpandsAndCollapsesNoFolder() throws {
        let fixture = makeOpenFileFixture()
        let before = expandedPaths(fixture.view)

        fixture.view.showOpenFile(path: "src/x.txt")
        fixture.view.showOpenFile(path: "f03.txt")

        XCTAssertEqual(expandedPaths(fixture.view), before)
        XCTAssertEqual(fixture.reads.count, 0, "and no folder was read")
        XCTAssertEqual(fixture.view.outlineView.numberOfRows, 41)

        let src = try XCTUnwrap(rowIndex(of: "src", in: fixture.view))
        fixture.view.outlineView.expandItem(fixture.view.outlineView.item(atRow: src))
        let opened = expandedPaths(fixture.view)
        fixture.view.showOpenFile(path: "f10.txt")
        XCTAssertEqual(expandedPaths(fixture.view), opened, "an open folder stays open")
    }

    func test_itDoesNotMoveTheScrollOffset() throws {
        let fixture = makeOpenFileFixture()
        fixture.view.contentView.scroll(to: NSPoint(x: 0, y: 40))
        fixture.view.reflectScrolledClipView(fixture.view.contentView)
        let before = scrollOffset(fixture.view)
        let visible = fixture.view.outlineView.rows(in: fixture.view.contentView.bounds)
        let inView = try XCTUnwrap(fixture.view.entry(atRow: visible.location + 2)?.path)
        XCTAssertGreaterThan(before.y, 0, "the fixture scrolls")

        fixture.view.showOpenFile(path: inView)
        XCTAssertEqual(scrollOffset(fixture.view), before, "a row in view is selected in place")

        fixture.view.showOpenFile(path: "f39.txt")
        XCTAssertEqual(scrollOffset(fixture.view), before, "a row out of view is not scrolled to")
        XCTAssertEqual(
            fixture.view.outlineView.selectedRowIndexes,
            IndexSet(integer: try XCTUnwrap(rowIndex(of: "f39.txt", in: fixture.view))))
    }
}
