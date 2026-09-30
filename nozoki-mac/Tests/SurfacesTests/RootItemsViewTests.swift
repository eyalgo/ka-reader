import AppKit
import XCTest

@testable import Surfaces

@MainActor
final class RootItemsViewTests: XCTestCase {
    private let folderGlyph = NSImage(size: NSSize(width: 1, height: 1))
    private let fileGlyph = NSImage(size: NSSize(width: 2, height: 2))

    private func makeView(showing root: RootListing?) -> RootItemsView {
        let view = RootItemsView(folderGlyph: folderGlyph, fileGlyph: fileGlyph)
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

    private func entry(_ name: String, _ kind: EntryKind, _ state: EntryState) -> Entry {
        Entry(name: name, path: name, kind: kind, state: state)
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
        "This link leads outside the folder you opened, so Nozoki doesn't read it."
    private let cantReadSentence = "Nozoki can't read this folder."
    private let noFilesSentence = "This folder has no files."

    func testPlainProjectionDrawsFourRowsInOrderWithTheOutsideSentence() throws {
        let view = makeView(showing: plainProjection)

        XCTAssertEqual(view.outlineView.numberOfRows, 4)
        let names = try (0..<4).map { try cell(view, row: $0).textField?.stringValue }
        XCTAssertEqual(names, ["docs", ".hidden-note", "outside-link", "readme.txt"])
        XCTAssertTrue(try cell(view, row: 0).imageView?.image === folderGlyph)
        for row in 1...3 {
            XCTAssertTrue(try cell(view, row: row).imageView?.image === fileGlyph)
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
            XCTAssertNotNil(drawn.imageView?.image)
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
            (.unreadable, "Nozoki can't read this folder."),
            (
                .outside,
                "This link leads outside the folder you opened, so Nozoki doesn't read it."
            ),
            (.cycle, "This link loops back on itself, so Nozoki can't read it."),
            (.missing, "This link leads to something that isn't there."),
            (.tooManyLinks, "This link leads through more links than Nozoki follows."),
            (.notAFolder, "Nozoki can't read this folder."),
        ]

        for (condition, sentence) in rows {
            XCTAssertEqual(ConditionSentences.row(for: condition), sentence, "\(condition)")
        }
        XCTAssertEqual(ConditionSentences.failedRoot, "Nozoki can't read this folder.")
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
        let loopSentence = "This link loops back on itself, so Nozoki can't read it."
        let missingSentence = "This link leads to something that isn't there."

        XCTAssertEqual(try conditionText(cell(view, row: 0)), loopSentence)
        XCTAssertEqual(try conditionText(cell(view, row: 1)), loopSentence)
        XCTAssertEqual(try conditionText(cell(view, row: 2)), missingSentence)
        XCTAssertEqual(try conditionText(cell(view, row: 3)), missingSentence)
        XCTAssertNil(try conditionText(cell(view, row: 4)))
    }

    func testFailedFileEntryDrawsTheFileGlyph() throws {
        let view = makeView(showing: [entry("gone", .file, .failed(.missing))])

        XCTAssertTrue(try cell(view, row: 0).imageView?.image === fileGlyph)
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
            XCTAssertEqual(try cell(view, row: index).textField?.stringValue, entry.name)
        }
    }

    func testDotNamedEntryIsKept() throws {
        let view = makeView(showing: [entry(".hidden-note", .file, .observed)])

        XCTAssertEqual(view.outlineView.numberOfRows, 1)
        XCTAssertEqual(try cell(view, row: 0).textField?.stringValue, ".hidden-note")
    }

    func testNestedEntryIsLabelledByNameNotPath() throws {
        let view = makeView(showing: [
            Entry(name: "guides", path: "docs/guides", kind: .folder, state: .pending)
        ])

        XCTAssertEqual(try cell(view, row: 0).textField?.stringValue, "guides")
    }

    func testFolderKindDrawsFolderGlyph() throws {
        let view = makeView(showing: [entry("docs", .folder, .pending)])

        XCTAssertTrue(try cell(view, row: 0).imageView?.image === folderGlyph)
    }

    func testRowsAreNotReordered() throws {
        let names = ["zebra", "apple", "mango"]
        let view = makeView(showing: names.map { entry($0, .file, .observed) })

        for (index, name) in names.enumerated() {
            XCTAssertEqual(try cell(view, row: index).textField?.stringValue, name)
        }
    }

    func testKindDecodesFromTheTwoWireStrings() throws {
        let wire =
            #"[{"name":"a","path":"a","kind":"folder","state":"pending"},"#
            + #"{"name":"b","path":"b","kind":"file","state":"observed"}]"#

        let entries = try JSONDecoder().decode([Entry].self, from: Data(wire.utf8))

        XCTAssertEqual(entries.map(\.kind), [.folder, .file])
    }

    func testUnknownKindFailsToDecode() {
        for kind in ["socket", "symlink"] {
            let wire = #"[{"name":"a","path":"a","kind":"\#(kind)","state":"observed"}]"#

            XCTAssertThrowsError(
                try JSONDecoder().decode([Entry].self, from: Data(wire.utf8)), kind)
        }
    }

    func testUnknownStateOrConditionFailsToDecode() {
        let wires = [
            #"{"name":"a","path":"a","kind":"file","state":"stopped"}"#,
            #"{"name":"a","path":"a","kind":"file","state":"failed","condition":"gone"}"#,
        ]

        for wire in wires {
            XCTAssertThrowsError(try JSONDecoder().decode(Entry.self, from: Data(wire.utf8)), wire)
        }
    }

    func testEntryStateDecodesFromTheWireWithItsCondition() throws {
        let wire =
            #"[{"name":"a","path":"a","kind":"folder","state":"pending"},"#
            + #"{"name":"b","path":"b","kind":"file","state":"observed"},"#
            + #"{"name":"c","path":"c","kind":"file","state":"failed","condition":"not_a_folder"},"#
            + #"{"name":"d","path":"d","kind":"file","state":"failed","condition":"too_many_links"}]"#

        let entries = try JSONDecoder().decode([Entry].self, from: Data(wire.utf8))

        XCTAssertEqual(
            entries.map(\.state),
            [.pending, .observed, .failed(.notAFolder), .failed(.tooManyLinks)])
    }

    func testAFailedEntryWithoutAConditionFailsToDecode() {
        let wire = #"{"name":"a","path":"a","kind":"file","state":"failed"}"#

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
}
