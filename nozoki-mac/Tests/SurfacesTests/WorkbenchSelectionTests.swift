import AppKit
import XCTest

@testable import Surfaces

/// Selecting a file in the tree: the `selectFile` intent, the row bar on the open file, and the
/// last selection winning (CP-278, CP-285). The panel is read through its own seams.
@MainActor
final class WorkbenchSelectionTests: XCTestCase {
    private struct SelectRead {
        let path: String
        let answer: SelectFileAnswer
    }

    @MainActor
    private final class Log {
        var selects: [SelectRead] = []
        var listed: [(path: String, answer: ListTreeAnswer)] = []
    }

    private func entry(_ name: String, _ kind: EntryKind, path: String? = nil) -> Entry {
        Entry(
            name: name, path: path ?? name, kind: kind,
            state: kind == .folder ? .pending : .observed)
    }

    /// Distinct from the one image every other row draws, so a test can tell it was drawn.
    private let fileCodeGlyph = NSImage(size: NSSize(width: 5, height: 5))

    private func pythonEntry(_ name: String) -> Entry {
        Entry(name: name, path: name, kind: .file, state: .observed, language: .python)
    }

    private func makeWorkbench(extra: [Entry] = []) -> (WorkbenchView, Log) {
        let glyph = NSImage(size: NSSize(width: 1, height: 1))
        let glyphs = StatusGlyphs(empty: glyph, failure: glyph)
        let tree = RootItemsView(
            folderGlyph: glyph, fileGlyph: glyph, fileCodeGlyph: fileCodeGlyph,
            statusGlyphs: glyphs)
        tree.show(
            .observed(
                [
                    entry("src", .folder), entry("README", .file), entry("a.txt", .file),
                    entry("b.txt", .file),
                ] + extra))
        let workbench = WorkbenchView(rootItemsView: tree, statusGlyphs: glyphs)
        workbench.frame = NSRect(x: 0, y: 0, width: 800, height: 500)
        let log = Log()
        workbench.selectFile = { path, answer in
            log.selects.append(SelectRead(path: path, answer: answer))
        }
        tree.listTree = { path, answer in log.listed.append((path, answer)) }
        return (workbench, log)
    }

    private func row(_ name: String, in workbench: WorkbenchView) throws -> Int {
        let tree = workbench.rootItemsView
        return try XCTUnwrap(
            (0..<tree.outlineView.numberOfRows).first { tree.entry(atRow: $0)?.name == name },
            "no row named \(name)")
    }

    private func select(_ name: String, in workbench: WorkbenchView) throws {
        let index = try row(name, in: workbench)
        workbench.rootItemsView.outlineView.selectRowIndexes(
            IndexSet(integer: index), byExtendingSelection: false)
    }

    private func expandSource(_ workbench: WorkbenchView, _ log: Log) throws {
        let tree = workbench.rootItemsView
        tree.outlineView.expandItem(tree.outlineView.item(atRow: try row("src", in: workbench)))
        log.listed.last?.answer(.observed([entry("lib.rs", .file, path: "src/lib.rs")]))
    }

    private func collapseSource(_ workbench: WorkbenchView) throws {
        let tree = workbench.rootItemsView
        tree.outlineView.collapseItem(tree.outlineView.item(atRow: try row("src", in: workbench)))
    }

    private func shownPath(_ workbench: WorkbenchView) -> String? {
        let line = workbench.readingPanel.pathLine
        return line.isHiddenOrHasHiddenAncestor ? nil : line.stringValue
    }

    private func barPaths(_ workbench: WorkbenchView) -> [String] {
        workbench.rootItemsView.barPaths()
    }

    func testSelectingAFileRowRaisesSelectFileAndPutsTheBarOnItAlone() throws {
        let (workbench, log) = makeWorkbench()

        try select("a.txt", in: workbench)

        XCTAssertEqual(log.selects.map(\.path), ["a.txt"])
        log.selects[0].answer(.text("hello", .plain))
        XCTAssertEqual(barPaths(workbench), ["a.txt"])
        XCTAssertEqual(shownPath(workbench), "a.txt")
        XCTAssertEqual(workbench.readingPanel.contentView.string, "hello")
    }

    private func rowGlyph(_ name: String, in workbench: WorkbenchView) throws -> NSImage? {
        let tree = workbench.rootItemsView
        let made = tree.outlineView.view(
            atColumn: 0, row: try row(name, in: workbench), makeIfNecessary: true)
        return (made as? NSTableCellView)?.imageView?.image
    }

    func testSelectingACannotDisplayPythonRowKeepsItsFileCodeGlyph() throws {
        let (workbench, log) = makeWorkbench(extra: [pythonEntry("legacy.py")])
        XCTAssertTrue(try rowGlyph("legacy.py", in: workbench) === fileCodeGlyph)

        try select("legacy.py", in: workbench)
        log.selects[0].answer(.cannotDisplay(.invalidUTF8))

        XCTAssertEqual(shownPath(workbench), "legacy.py")
        XCTAssertTrue(
            try rowGlyph("legacy.py", in: workbench) === fileCodeGlyph,
            "a row whose file cannot be displayed keeps its glyph")
    }

    func testOpenFloorLanguageRowKeepsBarSelectionAndNameWithFileCodeGlyph() throws {
        let (workbench, log) = makeWorkbench(extra: [pythonEntry("app.py")])
        let tree = workbench.rootItemsView
        let index = try row("app.py", in: workbench)

        try select("app.py", in: workbench)
        log.selects[0].answer(.text("print(1)", .floor(.python, [])))

        XCTAssertEqual(barPaths(workbench), ["app.py"])
        XCTAssertEqual(tree.outlineView.selectedRow, index)
        let made = tree.outlineView.view(atColumn: 0, row: index, makeIfNecessary: true)
        let drawn = try XCTUnwrap(made as? NSTableCellView)
        XCTAssertEqual(drawn.textField?.stringValue, "app.py")
        XCTAssertTrue(drawn.imageView?.image === fileCodeGlyph)
    }

    func testTreeStaysEnabledAfterCannotDisplayAndAfterFailedRead() throws {
        let (workbench, log) = makeWorkbench()
        let tree = workbench.rootItemsView

        try select("a.txt", in: workbench)
        log.selects[0].answer(.cannotDisplay(.invalidUTF8))
        XCTAssertTrue(tree.outlineView.isEnabled)
        tree.outlineView.expandItem(tree.outlineView.item(atRow: try row("src", in: workbench)))
        XCTAssertEqual(
            log.listed.map(\.path), ["src"], "a folder row still expands and raises listTree")
        log.listed[0].answer(.observed([entry("lib.rs", .file, path: "src/lib.rs")]))

        try select("b.txt", in: workbench)
        log.selects[1].answer(.failed(.outside))

        XCTAssertTrue(tree.outlineView.isEnabled)
        XCTAssertEqual(shownPath(workbench), "b.txt")
        XCTAssertEqual(barPaths(workbench), ["b.txt"])
    }

    func testLastSelectionWinsInEitherDeliveryOrder() throws {
        for order in [[0, 1], [1, 0]] {
            let (workbench, log) = makeWorkbench()
            try select("a.txt", in: workbench)
            try select("b.txt", in: workbench)
            XCTAssertEqual(log.selects.map(\.path), ["a.txt", "b.txt"])
            let verdicts: [FileVerdict] = [.text("from a", .plain), .text("from b", .plain)]

            for index in order {
                log.selects[index].answer(verdicts[index])
                if index == 0 {
                    XCTAssertNotEqual(
                        workbench.readingPanel.contentView.string, "from a", "\(order)")
                }
            }

            XCTAssertEqual(shownPath(workbench), "b.txt", "\(order)")
            XCTAssertEqual(workbench.readingPanel.contentView.string, "from b", "\(order)")
            XCTAssertEqual(barPaths(workbench), ["b.txt"], "\(order)")
        }
    }

    func testSelectingAFolderRowOrStatusLineRowRaisesNothing() throws {
        let (workbench, log) = makeWorkbench()
        let tree = workbench.rootItemsView
        tree.outlineView.expandItem(tree.outlineView.item(atRow: try row("src", in: workbench)))
        let lineRow = try XCTUnwrap(
            (0..<tree.outlineView.numberOfRows).first { tree.lineText(atRow: $0) != nil })
        tree.outlineView.selectRowIndexes(IndexSet(integer: lineRow), byExtendingSelection: false)
        XCTAssertTrue(log.selects.isEmpty, "a status line raises nothing")
        log.listed[0].answer(.observed([entry("lib.rs", .file, path: "src/lib.rs")]))
        try select("lib.rs", in: workbench)
        XCTAssertEqual(log.selects.map(\.path), ["src/lib.rs"])
        log.selects[0].answer(.text("fn main() {}", .plain))

        try select("src", in: workbench)

        XCTAssertEqual(log.selects.count, 1, "a folder row raises nothing")
        XCTAssertEqual(shownPath(workbench), "src/lib.rs")
        XCTAssertEqual(barPaths(workbench), ["src/lib.rs"])
    }

    func testBarStaysOnTheOpenFileAfterItsParentIsReExpanded() throws {
        let (workbench, log) = makeWorkbench()
        let tree = workbench.rootItemsView
        tree.outlineView.expandItem(tree.outlineView.item(atRow: try row("src", in: workbench)))
        log.listed[0].answer(.observed([entry("lib.rs", .file, path: "src/lib.rs")]))
        try select("lib.rs", in: workbench)
        log.selects[0].answer(.text("x", .plain))

        try collapseSource(workbench)
        tree.outlineView.expandItem(tree.outlineView.item(atRow: try row("src", in: workbench)))
        log.listed[1].answer(.observed([entry("lib.rs", .file, path: "src/lib.rs")]))

        XCTAssertEqual(barPaths(workbench), ["src/lib.rs"])
        XCTAssertEqual(log.selects.count, 1, "the rebuild raised no selection")
    }

    func testSelectionChangePostedDuringAReloadRaisesNothing() throws {
        let (workbench, log) = makeWorkbench()
        let tree = workbench.rootItemsView
        try select("b.txt", in: workbench)
        log.selects[0].answer(.text("x", .plain))
        XCTAssertEqual(log.selects.count, 1)

        // Expanding the folder above reloads its rows while `b.txt` is selected: the rows under it
        // move, and AppKit may post a selection change for that.
        tree.outlineView.expandItem(tree.outlineView.item(atRow: try row("src", in: workbench)))
        log.listed[0].answer(.observed([entry("lib.rs", .file, path: "src/lib.rs")]))
        // Replacing the whole root while a file row is selected reloads every row; the selected
        // index now holds a different file, which is what a selection posted mid-reload would raise.
        let selectedIndex = tree.outlineView.selectedRow
        XCTAssertGreaterThanOrEqual(selectedIndex, 0, "the selection survives the expansion")
        var replaced = (0..<tree.outlineView.numberOfRows).compactMap { tree.entry(atRow: $0) }
        replaced[selectedIndex] = entry("z.txt", .file)
        tree.show(.observed(replaced))

        XCTAssertEqual(log.selects.count, 1, "no selection raised during a reload")
    }

    func testNilAnswerReturnsToThePromptAndClearsTheBar() throws {
        let (workbench, log) = makeWorkbench()
        try select("a.txt", in: workbench)
        log.selects[0].answer(.text("x", .plain))
        XCTAssertEqual(barPaths(workbench), ["a.txt"])

        try select("b.txt", in: workbench)
        log.selects[1].answer(nil)

        XCTAssertNil(shownPath(workbench))
        XCTAssertEqual(barPaths(workbench), [])
    }
}
