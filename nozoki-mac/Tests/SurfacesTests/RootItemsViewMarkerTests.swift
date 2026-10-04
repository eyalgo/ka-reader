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
        let rest: TooltipRestDouble
        var reads: [String] = []
        var selected: [Entry] = []

        init(view: RootItemsView, window: NSWindow, rest: TooltipRestDouble) {
            self.view = view
            self.window = window
            self.rest = rest
        }
    }

    private func makeFixture(_ entries: [Entry], listings: [String: [Entry]] = [:]) -> Fixture {
        let rest = TooltipRestDouble()
        let view = RootItemsView(
            folderGlyph: folderGlyph, fileGlyph: fileGlyph, fileCodeGlyph: fileCodeGlyph,
            statusGlyphs: statusGlyphs, tooltipRest: rest.rest)
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 260, height: 200), styleMask: [.borderless],
            backing: .buffered, defer: true)
        let fixture = Fixture(view: view, window: window, rest: rest)
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
        let entry = try XCTUnwrap(fixture.view.entry(atRow: try row(of: "b.txt", in: fixture.view)))

        // Once with no tooltip showing, once with it showing (CP-595).
        try ClickDelivery.clickMiddle(of: field)
        XCTAssertEqual(fixture.selected, [entry])
        fixture.view.outlineView.deselectAll(nil)
        fixture.selected = []
        try rest(on: field, in: fixture)
        XCTAssertEqual(fixture.view.letterTooltip.shownText, "b.txt \u{2014} modified")

        try ClickDelivery.clickMiddle(of: field)

        XCTAssertEqual(fixture.selected, [entry])
        XCTAssertNil(field.toolTip)
        assertNoAppKitToolTip(in: fixture.view)
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

    // MARK: The letter's tooltip (CP-586 to CP-595)

    private func centre(of view: NSView, in host: NSView) -> NSPoint {
        host.convert(NSPoint(x: view.bounds.midX, y: view.bounds.midY), from: view)
    }

    /// The pointer moves onto `view` and the rest fires, as it does when the pointer stays.
    private func rest(on view: NSView, in fixture: Fixture) throws {
        let before = fixture.rest.requests.count
        try PointerDelivery.move(to: centre(of: view, in: fixture.view), in: fixture.view)
        for index in before..<fixture.rest.requests.count { fixture.rest.fire(index) }
    }

    private func assertNoAppKitToolTip(
        in view: NSView, file: StaticString = #filePath, line: UInt = #line
    ) {
        XCTAssertNil(view.toolTip, file: file, line: line)
        for sub in view.subviews { assertNoAppKitToolTip(in: sub, file: file, line: line) }
    }

    func test_restingOnTheLetterShowsTheTooltipOnlyAfterTheRest() throws {
        let fixture = makeFixture([file("b.txt"), file("top.txt")])
        fixture.view.showMarkers(markers(changed: [("b.txt", .modified)]))
        let cell = try cell(fixture.view, path: "b.txt")
        let field = try letterField(cell)

        try PointerDelivery.move(to: centre(of: field, in: fixture.view), in: fixture.view)
        XCTAssertNil(fixture.view.letterTooltip.shownView, "nothing before the rest")
        XCTAssertEqual(fixture.rest.requests.map(\.interval), [0.5])

        fixture.rest.fireLast()

        let name = try XCTUnwrap(cell.textField?.stringValue)
        XCTAssertEqual(fixture.view.letterTooltip.shownText, name + " \u{2014} modified")
        XCTAssertEqual(name, "b.txt")
    }

    func test_movingFromTheLetterOntoTheNameRemovesItAtOnce() throws {
        let fixture = makeFixture([file("b.txt")])
        fixture.view.showMarkers(markers(changed: [("b.txt", .modified)]))
        let cell = try cell(fixture.view, path: "b.txt")
        try rest(on: try letterField(cell), in: fixture)
        XCTAssertNotNil(fixture.view.letterTooltip.shownView)

        try PointerDelivery.move(
            to: centre(of: try XCTUnwrap(cell.textField), in: fixture.view), in: fixture.view)

        XCTAssertNil(fixture.view.letterTooltip.shownView)
    }

    func test_nothingElseOnARowRaisesIt() throws {
        let fixture = makeFixture([file("b.txt"), file("top.txt")])
        fixture.view.showMarkers(markers(changed: [("b.txt", .modified)]))
        let marked = try cell(fixture.view, path: "b.txt")
        let unmarked = try cell(fixture.view, path: "top.txt")
        let name = try XCTUnwrap(marked.textField)
        let letter = try letterField(marked)
        let gap = NSPoint(
            x: fixture.view.convert(NSPoint(x: name.frame.maxX, y: 0), from: marked).x
                + (letter.frame.minX - name.frame.maxX) / 2,
            y: centre(of: letter, in: fixture.view).y)
        let points = [
            ("the name", centre(of: name, in: fixture.view)),
            ("the glyph", centre(of: try XCTUnwrap(marked.imageView), in: fixture.view)),
            ("the space between the name and the letter", gap),
            ("a row with no letter", centre(of: try XCTUnwrap(unmarked.textField), in: fixture.view)),
            ("where a row with no letter would draw one", centre(of: try letterField(unmarked), in: fixture.view)),
        ]

        for (what, point) in points {
            let before = fixture.rest.requests.count
            try PointerDelivery.move(to: point, in: fixture.view)
            for index in before..<fixture.rest.requests.count { fixture.rest.fire(index) }
            XCTAssertNil(fixture.view.letterTooltip.shownView, what)
        }
    }

    func test_eachOfTheSixCategoriesGivesItsWord() throws {
        let words: [(String, GitStatusCategory, String)] = [
            ("a.txt", .added, "added"), ("m.txt", .modified, "modified"),
            ("d.txt", .deleted, "deleted"), ("r.txt", .renamed, "renamed"),
            ("u.txt", .untracked, "untracked"), ("c.txt", .inConflict, "conflict"),
        ]
        let fixture = makeFixture(words.map { file($0.0) })
        fixture.view.showMarkers(markers(changed: words.map { ($0.0, $0.1) }))

        for (path, _, word) in words {
            try rest(on: try letterField(cell(fixture.view, path: path)), in: fixture)
            XCTAssertEqual(fixture.view.letterTooltip.shownText, "\(path) \u{2014} \(word)")
        }
    }

    func test_aSubmoduleFolderRowGivesModified() throws {
        let fixture = makeFixture([folder("sub")])
        fixture.view.showMarkers(markers(changed: [("sub", .modified)]))

        try rest(on: try letterField(cell(fixture.view, path: "sub")), in: fixture)

        XCTAssertEqual(fixture.view.letterTooltip.shownText, "sub \u{2014} modified")
    }

    func test_aNestedRepositoryFolderRowGivesUntrackedAndItsChildrenRaiseNone() throws {
        let fixture = makeFixture([folder("inner")], listings: ["inner": [file("inner/x.txt")]])
        fixture.view.showMarkers(markers(changed: [("inner/", .untracked)]))
        try rest(on: try letterField(cell(fixture.view, path: "inner")), in: fixture)
        XCTAssertEqual(fixture.view.letterTooltip.shownText, "inner \u{2014} untracked")

        fixture.view.outlineView.expandItem(fixture.view.outlineView.item(atRow: 0))
        fixture.view.layoutSubtreeIfNeeded()
        let child = try cell(fixture.view, path: "inner/x.txt")
        XCTAssertNil(try letter(fixture.view, path: "inner/x.txt"))
        let before = fixture.rest.requests.count
        for view in [try XCTUnwrap(child.textField), try letterField(child)] {
            try PointerDelivery.move(to: centre(of: view, in: fixture.view), in: fixture.view)
        }

        XCTAssertEqual(fixture.rest.requests.count, before, "no rest is asked for on a child")
        XCTAssertNil(fixture.view.letterTooltip.shownView)
    }

    func test_aPathInBothListsGivesTheChangedListsWord() throws {
        let fixture = makeFixture([file("a.txt")])
        fixture.view.showMarkers(
            TreeMarkers(
                .repository(
                    GitRepository(
                        branch: .named("main"), state: .normal,
                        staged: [GitEntry(path: "a.txt", category: .added)],
                        changed: [GitEntry(path: "a.txt", category: .modified)]))))
        XCTAssertEqual(try letter(fixture.view, path: "a.txt"), "M")

        try rest(on: try letterField(cell(fixture.view, path: "a.txt")), in: fixture)

        XCTAssertEqual(fixture.view.letterTooltip.shownText, "a.txt \u{2014} modified")
    }

    func test_oneClickOnAFolderRowsLetterDoesWhatAClickOnItsNameDoes() throws {
        func click(letterNotName: Bool) throws -> (selected: [Entry], reads: [String]) {
            let fixture = makeFixture([folder("sub")], listings: ["sub": [file("sub/x.txt")]])
            fixture.view.showMarkers(markers(changed: [("sub", .modified)]))
            let cell = try cell(fixture.view, path: "sub")
            try ClickDelivery.clickMiddle(
                of: letterNotName ? try letterField(cell) : try XCTUnwrap(cell.textField))
            return (fixture.selected, fixture.reads)
        }

        let onLetter = try click(letterNotName: true)
        let onName = try click(letterNotName: false)

        XCTAssertEqual(onLetter.selected, onName.selected)
        XCTAssertEqual(onLetter.reads, onName.reads)
    }

    func test_scrollingShowAndShowMarkersEachRemoveAShownTooltip() throws {
        let entries = (0..<30).map { file(String(format: "f%02d.txt", $0)) }
        let fixture = makeFixture(entries)
        let marked = markers(changed: [("f00.txt", .modified)])
        func showTooltip() throws {
            fixture.view.showMarkers(marked)
            fixture.view.contentView.scroll(to: .zero)
            fixture.view.reflectScrolledClipView(fixture.view.contentView)
            try rest(on: try letterField(cell(fixture.view, path: "f00.txt")), in: fixture)
            XCTAssertNotNil(fixture.view.letterTooltip.shownView)
        }

        try showTooltip()
        fixture.view.contentView.scroll(to: NSPoint(x: 0, y: 40))
        XCTAssertNil(fixture.view.letterTooltip.shownView, "scrolling")

        try showTooltip()
        fixture.view.show(.observed(entries))
        XCTAssertNil(fixture.view.letterTooltip.shownView, "show(_:)")

        try showTooltip()
        fixture.view.showMarkers(marked)
        XCTAssertNil(fixture.view.letterTooltip.shownView, "showMarkers(_:)")
    }
}
