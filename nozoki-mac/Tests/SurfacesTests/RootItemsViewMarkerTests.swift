import AppKit
import XCTest

@testable import Surfaces

/// CP-573 – CP-578: the tree draws the status letter of each row the Git item lists, and nothing
/// else about the tree moves when it does.
@MainActor
final class RootItemsViewMarkerTests: XCTestCase {
    private let folderGlyph = NSImage(size: NSSize(width: 1, height: 1))
    private let fileGlyph = NSImage(size: NSSize(width: 2, height: 2))
    private let fileCodeGlyph = NSImage(size: NSSize(width: 5, height: 5))
    private let statusGlyphs = StatusGlyphs(
        empty: NSImage(size: NSSize(width: 3, height: 3)),
        failure: NSImage(size: NSSize(width: 4, height: 4)))

    /// A tree hosted in a window short enough that it scrolls. A folder read is answered at once
    /// from `listings`, and every read and every `fileSelected` is recorded.
    private final class Fixture {
        let view: RootItemsView
        let window: NSWindow
        var reads: [String] = []
        var selected: [Entry] = []

        init(view: RootItemsView, window: NSWindow) {
            self.view = view
            self.window = window
        }
    }

    private func makeFixture(_ entries: [Entry], listings: [String: [Entry]] = [:]) -> Fixture {
        let view = RootItemsView(
            folderGlyph: folderGlyph, fileGlyph: fileGlyph, fileCodeGlyph: fileCodeGlyph,
            statusGlyphs: statusGlyphs)
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 260, height: 200), styleMask: [.borderless],
            backing: .buffered, defer: true)
        let fixture = Fixture(view: view, window: window)
        view.listTree = { path, answer in
            fixture.reads.append(path)
            answer(listings[path].map { .observed($0) })
        }
        view.fileSelected = { fixture.selected.append($0) }
        view.show(.observed(entries))
        window.contentView = view
        view.layoutSubtreeIfNeeded()
        return fixture
    }

    private func folder(_ path: String) -> Entry {
        Entry(
            name: (path as NSString).lastPathComponent, path: path, kind: .folder, state: .pending)
    }

    private func file(_ path: String, state: EntryState = .observed) -> Entry {
        Entry(name: (path as NSString).lastPathComponent, path: path, kind: .file, state: state)
    }

    private func markers(changed: [(String, GitStatusCategory)]) -> TreeMarkers {
        TreeMarkers(
            .repository(
                GitRepository(
                    branch: .named("main"), state: .normal, staged: [],
                    changed: changed.map { GitEntry(path: $0.0, category: $0.1) })))
    }

    private func row(of path: String, in view: RootItemsView) throws -> Int {
        try XCTUnwrap(
            (0..<view.outlineView.numberOfRows).first { view.entry(atRow: $0)?.path == path },
            "no row for \(path)")
    }

    private func cell(_ view: RootItemsView, path: String) throws -> NSTableCellView {
        let made = view.outlineView.view(
            atColumn: 0, row: try row(of: path, in: view), makeIfNecessary: true)
        let cell = try XCTUnwrap(made as? NSTableCellView)
        cell.layoutSubtreeIfNeeded()
        return cell
    }

    private func letterField(_ cell: NSTableCellView) throws -> NSTextField {
        try XCTUnwrap(
            cell.subviews.compactMap { $0 as? NSTextField }
                .first { $0.identifier?.rawValue == "treeRowLetter" },
            "the cell has no treeRowLetter field")
    }

    /// The letter a row shows, or nil when its letter field is hidden or empty.
    private func letter(_ view: RootItemsView, path: String) throws -> String? {
        let field = try letterField(cell(view, path: path))
        return field.isHidden || field.stringValue.isEmpty ? nil : field.stringValue
    }

    private func visibleTexts(_ cell: NSTableCellView) -> [String] {
        cell.subviews.compactMap { $0 as? NSTextField }
            .filter { !$0.isHidden && !$0.stringValue.isEmpty }
            .map(\.stringValue)
    }

    private func expandedPaths(_ view: RootItemsView) -> [String] {
        (0..<view.outlineView.numberOfRows).compactMap { row in
            let item = view.outlineView.item(atRow: row)
            return view.outlineView.isItemExpanded(item) ? view.entry(atRow: row)?.path : nil
        }
    }

    func test_drawnRowsAreMarkedAndOthersAreNot() throws {
        let fixture = makeFixture([
            folder(".git"), folder("sub"), folder("inner"), folder("src"), file("b.txt"),
            file("top.txt"),
        ])

        fixture.view.showMarkers(
            markers(changed: [
                ("b.txt", .modified), ("sub", .modified), ("inner/", .untracked),
                ("src/c.txt", .modified),
            ]))

        XCTAssertEqual(try letter(fixture.view, path: "b.txt"), "M")
        XCTAssertEqual(try letter(fixture.view, path: "sub"), "M")
        XCTAssertEqual(try letter(fixture.view, path: "inner"), "U")
        for path in [".git", "src", "top.txt"] {
            XCTAssertNil(try letter(fixture.view, path: path), path)
        }
        for path in ["b.txt", "sub", "inner"] {
            let drawn = try cell(fixture.view, path: path)
            let name = try XCTUnwrap(drawn.textField)
            XCTAssertGreaterThanOrEqual(
                try letterField(drawn).frame.minX, name.frame.maxX,
                "the letter sits after the name on \(path)")
        }
    }

    func test_rowsDrawnLaterAreMarked() throws {
        let fixture = makeFixture(
            [folder("src"), file("b.txt")],
            listings: ["src": [file("src/c.txt"), file("src/d.txt")]])
        fixture.view.showMarkers(markers(changed: [("src/c.txt", .modified)]))

        let src = fixture.view.outlineView.item(atRow: try row(of: "src", in: fixture.view))
        fixture.view.outlineView.expandItem(src)
        XCTAssertEqual(try letter(fixture.view, path: "src/c.txt"), "M")
        XCTAssertNil(try letter(fixture.view, path: "src/d.txt"))

        fixture.view.outlineView.collapseItem(src)
        fixture.view.outlineView.expandItem(src)
        XCTAssertEqual(try letter(fixture.view, path: "src/c.txt"), "M")
        XCTAssertNil(try letter(fixture.view, path: "src/d.txt"))
    }

    func test_aFailedEntryKeepsItsSentenceAndGainsItsLetter() throws {
        let fixture = makeFixture([file("broken.txt", state: .failed(.unreadable))])
        fixture.view.showMarkers(markers(changed: [("broken.txt", .modified)]))

        let texts = visibleTexts(try cell(fixture.view, path: "broken.txt"))

        XCTAssertEqual(texts.count, 3, "\(texts)")
        XCTAssertTrue(texts.contains("broken.txt"))
        XCTAssertTrue(texts.contains(ConditionSentences.row(for: .unreadable)))
        XCTAssertTrue(texts.contains("M"))
    }

    func test_anUnmarkedRowDrawsWhatItDrew() throws {
        let entries = [
            file("b.txt"), file("top.txt"), file("broken.txt", state: .failed(.outside)),
        ]
        let plain = makeFixture(entries)
        plain.view.showMarkers(.none)
        let marked = makeFixture(entries)
        marked.view.showMarkers(markers(changed: [("b.txt", .modified)]))

        let unmarked = try cell(marked.view, path: "top.txt")
        XCTAssertEqual(visibleTexts(unmarked), ["top.txt"])
        XCTAssertEqual(
            unmarked.textField?.textColor,
            try cell(plain.view, path: "top.txt").textField?.textColor)
        let failed = visibleTexts(try cell(marked.view, path: "broken.txt"))
        XCTAssertEqual(failed.count, 2, "a failed entry shows its name and its sentence only")
        XCTAssertEqual(
            try cell(marked.view, path: "b.txt").textField?.textColor,
            try cell(plain.view, path: "b.txt").textField?.textColor,
            "no hue is added to a marked row's name")
    }

    func test_showingMarkersChangesNothingElse() throws {
        for hidden in [false, true] {
            let files = (0..<40).map { file(String(format: "f%02d.txt", $0)) }
            let fixture = makeFixture(
                [folder("src"), file("b.txt")] + files,
                listings: ["src": [file("src/c.txt"), file("src/d.txt")]])
            let view = fixture.view
            view.outlineView.expandItem(view.outlineView.item(atRow: try row(of: "src", in: view)))
            view.outlineView.selectRowIndexes(
                IndexSet(integer: try row(of: "b.txt", in: view)), byExtendingSelection: false)
            view.markOpenFile(path: "b.txt")
            view.contentView.scroll(to: NSPoint(x: 0, y: 40))
            view.reflectScrolledClipView(view.contentView)
            view.isHidden = hidden
            fixture.selected = []
            fixture.reads = []
            let before = (
                expanded: expandedPaths(view), origin: view.contentView.bounds.origin,
                selected: view.outlineView.selectedRowIndexes, bar: view.barPaths(),
                line: view.rootLineText
            )
            XCTAssertGreaterThan(before.origin.y, 0, "the fixture scrolls")

            view.showMarkers(markers(changed: [("b.txt", .modified), ("src/c.txt", .modified)]))

            XCTAssertEqual(expandedPaths(view), before.expanded, "hidden: \(hidden)")
            XCTAssertEqual(view.contentView.bounds.origin, before.origin, "hidden: \(hidden)")
            XCTAssertEqual(
                view.outlineView.selectedRowIndexes, before.selected, "hidden: \(hidden)")
            XCTAssertEqual(view.barPaths(), before.bar, "hidden: \(hidden)")
            XCTAssertEqual(view.rootLineText, before.line, "hidden: \(hidden)")
            XCTAssertEqual(fixture.selected, [], "hidden: \(hidden)")
            XCTAssertEqual(fixture.reads, [], "hidden: \(hidden)")
            view.isHidden = false
            XCTAssertEqual(try letter(view, path: "b.txt"), "M", "hidden: \(hidden)")
        }
    }

    func test_theLetterIsNoSecondTarget() throws {
        let fixture = makeFixture([file("b.txt"), file("top.txt")])
        fixture.view.showMarkers(markers(changed: [("b.txt", .modified)]))
        let field = try letterField(cell(fixture.view, path: "b.txt"))
        XCTAssertEqual(field.stringValue, "M")

        try ClickDelivery.clickMiddle(of: field)

        XCTAssertEqual(
            fixture.selected,
            [try XCTUnwrap(fixture.view.entry(atRow: try row(of: "b.txt", in: fixture.view)))])
        XCTAssertNil(field.toolTip, "this change adds nothing on pointer rest")
    }

    func test_theLetterCanBeNeitherEditedNorSelected() throws {
        let fixture = makeFixture([file("b.txt")])
        fixture.view.showMarkers(markers(changed: [("b.txt", .modified)]))

        let field = try letterField(cell(fixture.view, path: "b.txt"))

        XCTAssertFalse(field.isEditable)
        XCTAssertFalse(field.isSelectable)
    }

    /// The tree's letter takes the Git view's treatment: whatever colour the Git view's letter is
    /// drawn in, the tree's is drawn in too, so the two views never differ in hue (CP-576).
    func test_theLetterTakesTheGitViewsTreatment() throws {
        let fixture = makeFixture([file("b.txt")])
        fixture.view.showMarkers(markers(changed: [("b.txt", .modified)]))
        let treeLetter = try letterField(cell(fixture.view, path: "b.txt"))

        let gitView = GitView(
            statusGlyphs: StatusGlyphs(
                empty: NSImage(size: NSSize(width: 3, height: 3)),
                failure: NSImage(size: NSSize(width: 4, height: 4))))
        gitView.show(
            .repository(
                GitRepository(
                    branch: .named("main"), state: .normal, staged: [],
                    changed: [GitEntry(path: "b.txt", category: .modified)])))
        func descendants(of view: NSView) -> [NSView] {
            view.subviews + view.subviews.flatMap { descendants(of: $0) }
        }
        let gitLetter = try XCTUnwrap(
            descendants(of: gitView).compactMap { $0 as? NSTextField }
                .first { $0.identifier?.rawValue == "gitRowLetter" },
            "the Git view drew no letter")

        XCTAssertEqual(treeLetter.stringValue, gitLetter.stringValue)
        XCTAssertEqual(treeLetter.textColor, gitLetter.textColor)
    }

    func test_showingANewRootKeepsTheHeldMarkers() throws {
        let fixture = makeFixture([file("b.txt"), file("top.txt")])
        fixture.view.showMarkers(markers(changed: [("b.txt", .modified)]))

        fixture.view.show(.observed([file("b.txt"), file("top.txt")]))

        XCTAssertEqual(try letter(fixture.view, path: "b.txt"), "M")
        XCTAssertNil(try letter(fixture.view, path: "top.txt"))
    }
}
