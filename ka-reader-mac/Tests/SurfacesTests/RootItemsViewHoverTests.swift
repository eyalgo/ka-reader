import AppKit
import XCTest

@testable import Surfaces

/// The hover fill in the tree (CP-599 to CP-609): the pointer is driven through `PointerDelivery`,
/// the fill is read off `hoverPaths()`, and a row's drawing is read off a rendered image.
@MainActor
final class RootItemsViewHoverTests: XCTestCase {
    private let glyph = NSImage(size: NSSize(width: 1, height: 1))

    private final class Fixture {
        let view: RootItemsView
        let window: NSWindow
        let rest: TooltipRestDouble
        let key: KeyWindowDouble
        /// Folder reads still owed an answer, when the fixture holds answers back.
        var answers: [ListTreeAnswer] = []
        var selected: [Entry] = []
        var reads: [String] = []

        init(view: RootItemsView, window: NSWindow, rest: TooltipRestDouble, key: KeyWindowDouble) {
            self.view = view
            self.window = window
            self.rest = rest
            self.key = key
        }
    }

    /// A tree in a window short enough to scroll. With `holdAnswers` a folder read is not answered
    /// until the test says so; otherwise it is answered at once from `listings`.
    private func makeFixture(
        _ entries: [Entry], listings: [String: RootListing] = [:], holdAnswers: Bool = false
    ) -> Fixture {
        let rest = TooltipRestDouble()
        let key = KeyWindowDouble()
        let view = RootItemsView(
            folderGlyph: glyph, fileGlyph: glyph, fileCodeGlyph: glyph,
            statusGlyphs: StatusGlyphs(empty: glyph, failure: glyph), tooltipRest: rest.rest,
            keyWindow: key.source)
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 260, height: 200), styleMask: [.borderless],
            backing: .buffered, defer: true)
        let fixture = Fixture(view: view, window: window, rest: rest, key: key)
        view.listTree = { path, answer in
            fixture.reads.append(path)
            if holdAnswers {
                fixture.answers.append(answer)
            } else {
                answer(listings[path])
            }
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

    private func files(_ count: Int) -> [Entry] {
        (0..<count).map { unsafe file(String(format: "f%02d.txt", $0)) }
    }

    private func markers(_ changed: [(String, GitStatusCategory)]) -> TreeMarkers {
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

    /// The middle of the row at `index`, in the tree view's coordinates.
    private func point(ofRow index: Int, in view: RootItemsView) -> NSPoint {
        let rect = view.outlineView.rect(ofRow: index)
        return view.convert(NSPoint(x: rect.minX + 40, y: rect.midY), from: view.outlineView)
    }

    private func point(ofPath path: String, in view: RootItemsView) throws -> NSPoint {
        point(ofRow: try row(of: path, in: view), in: view)
    }

    /// The path of the entry row whose rectangle holds `point`, found without the tree's own lookup.
    private func entryPath(at point: NSPoint, in view: RootItemsView) -> String? {
        let inOutline = view.outlineView.convert(point, from: view)
        return (0..<view.outlineView.numberOfRows)
            .first { view.outlineView.rect(ofRow: $0).contains(inOutline) }
            .flatMap { view.entry(atRow: $0)?.path }
    }

    /// Every row of the outline, entry or line, whose drawn row view shows the hover fill.
    /// `hoverPaths()` names entry rows only, so it cannot see a line row drawing the fill (CP-601).
    private func filledRows(_ view: RootItemsView) -> [Int] {
        (0..<view.outlineView.numberOfRows).filter { index in
            (view.outlineView.rowView(atRow: index, makeIfNecessary: false) as? BarRowView)?
                .showsHover == true
        }
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

    private func centre(of view: NSView, in host: NSView) -> NSPoint {
        host.convert(NSPoint(x: view.bounds.midX, y: view.bounds.midY), from: view)
    }

    private func rowImage(_ view: RootItemsView, path: String) throws -> Data {
        let rowView = try XCTUnwrap(
            view.outlineView.rowView(atRow: try row(of: path, in: view), makeIfNecessary: true))
        rowView.appearance = NSAppearance(named: .aqua)
        let rep = try XCTUnwrap(rowView.bitmapImageRepForCachingDisplay(in: rowView.bounds))
        rowView.cacheDisplay(in: rowView.bounds, to: rep)
        return try XCTUnwrap(rep.representation(using: .png, properties: [:]))
    }

    private func expand(_ path: String, in view: RootItemsView) throws {
        let item = view.outlineView.item(atRow: try row(of: path, in: view))
        view.outlineView.expandItem(item)
        view.layoutSubtreeIfNeeded()
    }

    private func collapse(_ path: String, in view: RootItemsView) throws {
        let item = view.outlineView.item(atRow: try row(of: path, in: view))
        view.outlineView.collapseItem(item)
        view.layoutSubtreeIfNeeded()
    }

    private func scroll(_ view: RootItemsView, to y: CGFloat) {
        view.contentView.scroll(to: NSPoint(x: 0, y: y))
        view.reflectScrolledClipView(view.contentView)
    }

    // MARK: S-1

    func test_hover_s1_file_row_shows_fill_under_pointer_and_loses_it_on_leave() throws {
        let fixture = makeFixture([file("a.txt"), file("b.txt")])
        let view = fixture.view

        try PointerDelivery.move(to: try point(ofPath: "b.txt", in: view), in: view)
        XCTAssertEqual(view.hoverPaths(), ["b.txt"])

        try PointerDelivery.leave(at: try point(ofPath: "b.txt", in: view), in: view)
        XCTAssertEqual(view.hoverPaths(), [])
    }

    func test_hover_s1_row_nothing_acts_on_never_shows_fill() throws {
        // The reading line, while the read is out.
        let reading = makeFixture([folder("docs"), file("z.txt")], holdAnswers: true)
        try expand("docs", in: reading.view)
        let readingRow = try row(of: "z.txt", in: reading.view) - 1
        XCTAssertNotNil(reading.view.lineText(atRow: readingRow))
        try PointerDelivery.move(to: point(ofRow: readingRow, in: reading.view), in: reading.view)
        XCTAssertEqual(reading.view.hoverPaths(), [], "the reading line")
        XCTAssertEqual(filledRows(reading.view), [], "the reading line's own row")

        // The empty-folder line.
        let empty = makeFixture([folder("docs"), file("z.txt")], listings: ["docs": .observed([])])
        try expand("docs", in: empty.view)
        let emptyRow = try row(of: "z.txt", in: empty.view) - 1
        XCTAssertNotNil(empty.view.lineText(atRow: emptyRow))
        try PointerDelivery.move(to: point(ofRow: emptyRow, in: empty.view), in: empty.view)
        XCTAssertEqual(empty.view.hoverPaths(), [], "the empty-folder line")
        XCTAssertEqual(filledRows(empty.view), [], "the empty-folder line's own row")

        // The empty root's and the failed root's message, and the space below the last row.
        let root = makeFixture([file("a.txt")])
        root.view.show(.observed([]))
        root.view.layoutSubtreeIfNeeded()
        XCTAssertNotNil(root.view.rootLineText)
        try PointerDelivery.move(to: NSPoint(x: 40, y: 150), in: root.view)
        XCTAssertEqual(root.view.hoverPaths(), [], "the empty root's message")
        root.view.show(.failed(.unreadable))
        root.view.layoutSubtreeIfNeeded()
        XCTAssertNotNil(root.view.rootLineText)
        try PointerDelivery.move(to: NSPoint(x: 40, y: 150), in: root.view)
        XCTAssertEqual(root.view.hoverPaths(), [], "the failed root's message")

        let below = makeFixture([file("a.txt"), file("b.txt")])
        try PointerDelivery.move(to: try point(ofPath: "b.txt", in: below.view), in: below.view)
        XCTAssertEqual(below.view.hoverPaths(), ["b.txt"])
        let lastRow = below.view.outlineView.rect(ofRow: 1)
        let underneath = below.view.convert(
            NSPoint(x: 40, y: lastRow.maxY + 30), from: below.view.outlineView)
        XCTAssertNil(entryPath(at: underneath, in: below.view), "the point is below the rows")
        try PointerDelivery.move(to: underneath, in: below.view)
        XCTAssertEqual(below.view.hoverPaths(), [], "the space below the last row")
    }

    func test_hover_s1_selected_row_under_pointer_keeps_selected_drawing_and_bar() throws {
        // `b.txt` selected and barred.
        let fixture = makeFixture([file("a.txt"), file("b.txt")])
        let view = fixture.view
        view.showOpenFile(path: "b.txt")
        let selectedRow = try row(of: "b.txt", in: view)
        XCTAssertEqual(view.outlineView.selectedRow, selectedRow)
        try PointerDelivery.move(to: try point(ofPath: "a.txt", in: view), in: view)
        let elsewhere = try rowImage(view, path: "b.txt")

        try PointerDelivery.move(to: try point(ofPath: "b.txt", in: view), in: view)

        XCTAssertEqual(view.hoverPaths(), [])
        XCTAssertEqual(view.barPaths(), ["b.txt"])
        XCTAssertEqual(view.outlineView.selectedRow, selectedRow)
        XCTAssertEqual(try rowImage(view, path: "b.txt"), elsewhere)

        // A row carrying the bar alone, with the selection on a folder row.
        let alone = makeFixture([folder("src"), file("b.txt")])
        let tree = alone.view
        tree.markOpenFile(path: "b.txt")
        tree.outlineView.selectRowIndexes(
            IndexSet(integer: try row(of: "src", in: tree)), byExtendingSelection: false)
        try PointerDelivery.move(to: try point(ofPath: "src", in: tree), in: tree)
        let beside = try rowImage(tree, path: "b.txt")

        try PointerDelivery.move(to: try point(ofPath: "b.txt", in: tree), in: tree)

        XCTAssertEqual(tree.hoverPaths(), [])
        XCTAssertEqual(tree.barPaths(), ["b.txt"])
        XCTAssertEqual(try rowImage(tree, path: "b.txt"), beside)
    }

    func test_hover_s1_scroll_moves_rows_under_still_pointer_fill_follows() throws {
        let fixture = makeFixture(files(40))
        let view = fixture.view
        let pointer = point(ofRow: 3, in: view)
        try PointerDelivery.move(to: pointer, in: view)
        XCTAssertEqual(view.hoverPaths(), ["f03.txt"])

        scroll(view, to: 60)

        let now = try XCTUnwrap(entryPath(at: pointer, in: view))
        XCTAssertNotEqual(now, "f03.txt", "the rows moved")
        XCTAssertEqual(view.hoverPaths(), [now])
    }

    func test_hover_s1_expansion_moves_child_under_still_pointer_fill_follows() throws {
        let fixture = makeFixture(
            [folder("src"), file("b.txt")],
            listings: ["src": .observed([file("src/c.txt"), file("src/d.txt")])])
        let view = fixture.view
        let pointer = try point(ofPath: "b.txt", in: view)
        try PointerDelivery.move(to: pointer, in: view)
        XCTAssertEqual(view.hoverPaths(), ["b.txt"])

        try expand("src", in: view)

        XCTAssertEqual(entryPath(at: pointer, in: view), "src/c.txt")
        XCTAssertEqual(view.hoverPaths(), ["src/c.txt"])
    }

    func test_hover_s1_collapse_moves_row_back_under_still_pointer_fill_follows() throws {
        let fixture = makeFixture(
            [folder("src"), file("b.txt"), file("c.txt")],
            listings: ["src": .observed([file("src/x.txt"), file("src/y.txt")])])
        let view = fixture.view
        try expand("src", in: view)
        let pointer = point(ofRow: 1, in: view)
        try PointerDelivery.move(to: pointer, in: view)
        XCTAssertEqual(view.hoverPaths(), ["src/x.txt"])

        try collapse("src", in: view)

        XCTAssertEqual(entryPath(at: pointer, in: view), "b.txt")
        XCTAssertEqual(view.hoverPaths(), ["b.txt"])
    }

    func test_hover_folder_rows_collapsed_and_expanded_take_fill() throws {
        let fixture = makeFixture(
            [folder("src"), file("b.txt")], listings: ["src": .observed([file("src/x.txt")])])
        let view = fixture.view
        try PointerDelivery.move(to: try point(ofPath: "src", in: view), in: view)
        XCTAssertEqual(view.hoverPaths(), ["src"], "collapsed")

        try expand("src", in: view)
        try PointerDelivery.move(to: try point(ofPath: "b.txt", in: view), in: view)
        try PointerDelivery.move(to: try point(ofPath: "src", in: view), in: view)
        XCTAssertEqual(view.hoverPaths(), ["src"], "expanded")
    }

    func test_hover_unreadable_file_and_folder_rows_take_fill() throws {
        let fixture = makeFixture(
            [file("broken.txt", state: .failed(.unreadable)), folder("locked")],
            listings: ["locked": .failed(.unreadable)])
        let view = fixture.view
        try expand("locked", in: view)

        try PointerDelivery.move(to: try point(ofPath: "broken.txt", in: view), in: view)
        XCTAssertEqual(view.hoverPaths(), ["broken.txt"])
        try PointerDelivery.move(to: try point(ofPath: "locked", in: view), in: view)
        XCTAssertEqual(view.hoverPaths(), ["locked"])
    }

    func test_hover_marked_row_shows_fill_on_name_and_on_letter() throws {
        let fixture = makeFixture([file("a.txt"), file("b.txt")])
        let view = fixture.view
        view.showMarkers(markers([("a.txt", .modified)]))
        let cell = try cell(view, path: "a.txt")

        try unsafe PointerDelivery.move(
            to: centre(of: try XCTUnwrap(cell.textField), in: view), in: view)
        XCTAssertEqual(view.hoverPaths(), ["a.txt"], "on the name")

        try PointerDelivery.move(to: point(ofPath: "b.txt", in: view), in: view)
        try PointerDelivery.move(to: centre(of: try letterField(cell), in: view), in: view)
        XCTAssertEqual(view.hoverPaths(), ["a.txt"], "on the letter")
    }

    func test_hover_marked_row_keeps_fill_while_tooltip_is_shown() throws {
        let fixture = makeFixture([file("a.txt"), file("b.txt")])
        let view = fixture.view
        view.showMarkers(markers([("a.txt", .modified)]))
        let letter = try letterField(cell(view, path: "a.txt"))

        try PointerDelivery.move(to: centre(of: letter, in: view), in: view)
        fixture.rest.fireLast()

        XCTAssertNotNil(view.letterTooltip.shownView)
        XCTAssertEqual(view.hoverPaths(), ["a.txt"])
    }

    func test_hover_stays_on_row_after_markers_arrive_under_still_pointer() throws {
        let fixture = makeFixture([file("a.txt"), file("b.txt")])
        let view = fixture.view
        try PointerDelivery.move(to: try point(ofPath: "a.txt", in: view), in: view)

        view.showMarkers(markers([("a.txt", .modified)]))

        XCTAssertEqual(view.hoverPaths(), ["a.txt"])
    }

    func test_hover_moving_between_rows_leaves_only_the_new_row_filled() throws {
        let fixture = makeFixture([file("a.txt"), file("b.txt")])
        let view = fixture.view
        try PointerDelivery.move(to: try point(ofPath: "a.txt", in: view), in: view)
        XCTAssertEqual(view.hoverPaths(), ["a.txt"])

        try PointerDelivery.move(to: try point(ofPath: "b.txt", in: view), in: view)

        XCTAssertEqual(view.hoverPaths(), ["b.txt"])
    }

    func test_hover_reading_line_giving_way_to_entries_moves_fill_to_the_row_now_there() throws {
        for answer in [RootListing.observed([file("src/c.txt")]), .observed([])] {
            let fixture = makeFixture([folder("src"), file("b.txt")], holdAnswers: true)
            let view = fixture.view
            try expand("src", in: view)
            let pointer = point(ofRow: 1, in: view)
            try PointerDelivery.move(to: pointer, in: view)
            XCTAssertNotNil(view.lineText(atRow: 1))
            XCTAssertEqual(view.hoverPaths(), [], "the reading line")
            XCTAssertEqual(filledRows(view), [], "the reading line's own row")

            try XCTUnwrap(fixture.answers.first)(answer)
            view.layoutSubtreeIfNeeded()

            let now = entryPath(at: pointer, in: view)
            XCTAssertEqual(view.hoverPaths(), now.map { [$0] } ?? [], "\(answer)")
            // Where a line now lies under the pointer, its row shows no fill either.
            XCTAssertEqual(filledRows(view).count, now == nil ? 0 : 1, "\(answer), any row")
            if case .observed(let entries) = answer, !entries.isEmpty {
                XCTAssertEqual(now, "src/c.txt")
            }
        }
    }

    func test_hover_new_root_under_still_pointer_resolves_the_row_now_there() throws {
        let fixture = makeFixture([file("a.txt"), file("b.txt")])
        let view = fixture.view
        let pointer = try point(ofPath: "b.txt", in: view)
        try PointerDelivery.move(to: pointer, in: view)
        XCTAssertEqual(view.hoverPaths(), ["b.txt"])

        view.show(.observed([file("x.txt"), file("y.txt"), file("z.txt")]))
        view.layoutSubtreeIfNeeded()

        XCTAssertEqual(view.hoverPaths(), ["y.txt"])
    }

    func test_hover_click_on_hovered_unselected_row_selects_once_and_gives_way_to_selection() throws
    {
        let fixture = makeFixture([file("a.txt"), file("b.txt")])
        let view = fixture.view
        let pointer = try point(ofPath: "b.txt", in: view)
        try PointerDelivery.move(to: pointer, in: view)
        XCTAssertEqual(view.hoverPaths(), ["b.txt"])

        try ClickDelivery.click(at: pointer, in: view)

        XCTAssertEqual(fixture.selected.map(\.path), ["b.txt"])
        XCTAssertEqual(view.hoverPaths(), [])
        let rowView = try XCTUnwrap(
            view.outlineView.rowView(atRow: try row(of: "b.txt", in: view), makeIfNecessary: false))
        XCTAssertTrue(rowView.isSelected)
    }

    func test_hover_a_hidden_tree_shows_no_fill_when_shown_again_without_a_pointer_event() throws {
        let fixture = makeFixture([file("a.txt"), file("b.txt")])
        let view = fixture.view
        try PointerDelivery.move(to: try point(ofPath: "b.txt", in: view), in: view)
        XCTAssertEqual(view.hoverPaths(), ["b.txt"])

        view.isHidden = true
        view.isHidden = false

        XCTAssertEqual(view.hoverPaths(), [])
    }

    // MARK: the key window (CP-619 to CP-623)

    private func labelled() throws -> (Fixture, NSPoint) {
        let fixture = makeFixture([file("a.txt"), file("b.txt"), file("c.txt")])
        fixture.view.showMarkers(markers([("a.txt", .modified)]))
        let letter = centre(
            of: try letterField(cell(fixture.view, path: "a.txt")), in: fixture.view)
        return (fixture, letter)
    }

    func test_hover_s1_window_stops_being_key_under_still_pointer_the_fill_leaves() throws {
        let fixture = makeFixture([file("a.txt"), file("b.txt")])
        let view = fixture.view
        try PointerDelivery.move(to: try point(ofPath: "b.txt", in: view), in: view)
        XCTAssertEqual(view.hoverPaths(), ["b.txt"])

        fixture.key.stopBeingKey()

        XCTAssertEqual(view.hoverPaths(), [])
    }

    func test_hover_s1_window_stops_being_key_with_a_rest_pending_cancels_it() throws {
        let (fixture, letter) = try labelled()
        try PointerDelivery.move(to: letter, in: fixture.view)
        XCTAssertEqual(fixture.rest.requests.count, 1)

        fixture.key.stopBeingKey()

        XCTAssertTrue(fixture.rest.requests[0].cancelled)
        fixture.rest.fire(0)
        XCTAssertNil(fixture.view.letterTooltip.shownView)
        try PointerDelivery.move(to: letter, in: fixture.view)
        XCTAssertEqual(fixture.rest.requests.count, 1, "no rest while the window is not key")
    }

    func test_hover_s1_while_not_key_moving_over_rows_and_letters_fills_nothing_and_rests_nowhere()
        throws
    {
        let (fixture, letter) = try labelled()
        let view = fixture.view
        fixture.key.stopBeingKey()

        for pointer in [
            try point(ofPath: "b.txt", in: view), letter, try point(ofPath: "c.txt", in: view),
        ] {
            try PointerDelivery.move(to: pointer, in: view)
            XCTAssertEqual(view.hoverPaths(), [])
        }
        XCTAssertEqual(fixture.rest.requests.count, 0)
    }

    func test_hover_s1_rows_moving_under_a_still_pointer_while_not_key_fill_nothing() throws {
        let fixture = makeFixture(
            [folder("src")] + files(40), listings: ["src": .observed([file("src/c.txt")])])
        let view = fixture.view
        try PointerDelivery.move(to: point(ofRow: 3, in: view), in: view)
        XCTAssertEqual(view.hoverPaths(), ["f02.txt"])
        fixture.key.stopBeingKey()

        scroll(view, to: 60)
        XCTAssertEqual(view.hoverPaths(), [], "after the scroll")
        scroll(view, to: 0)
        try expand("src", in: view)

        XCTAssertEqual(view.hoverPaths(), [], "after the expansion")
    }

    func test_hover_s1_window_becomes_key_with_pointer_on_another_row_fills_that_row() throws {
        let fixture = makeFixture([file("a.txt"), file("b.txt"), file("c.txt")])
        let view = fixture.view
        try PointerDelivery.move(to: try point(ofPath: "a.txt", in: view), in: view)
        fixture.key.stopBeingKey()

        fixture.key.pointer = try point(ofPath: "c.txt", in: view)
        fixture.key.becomeKey()

        XCTAssertEqual(view.hoverPaths(), ["c.txt"])
    }

    func test_hover_s1_window_becomes_key_with_pointer_on_a_letter_waits_for_a_fresh_rest() throws {
        let (fixture, letter) = try labelled()
        try PointerDelivery.move(to: letter, in: fixture.view)
        fixture.rest.fireLast()
        XCTAssertNotNil(fixture.view.letterTooltip.shownView)
        fixture.key.stopBeingKey()
        XCTAssertNil(fixture.view.letterTooltip.shownView)

        fixture.key.pointer = letter
        fixture.key.becomeKey()

        XCTAssertNil(fixture.view.letterTooltip.shownView)
        XCTAssertEqual(fixture.rest.requests.count, 2)
        XCTAssertEqual(
            try XCTUnwrap(fixture.rest.requests.last).interval, LetterTooltip.restInterval)
        fixture.rest.fireLast()
        XCTAssertNotNil(fixture.view.letterTooltip.shownView)
    }

    func test_hover_s1_window_becomes_key_with_pointer_on_the_selected_row_keeps_its_drawing()
        throws
    {
        let fixture = makeFixture([file("a.txt"), file("b.txt")])
        let view = fixture.view
        view.showOpenFile(path: "b.txt")
        let selectedRow = try row(of: "b.txt", in: view)
        XCTAssertEqual(view.outlineView.selectedRow, selectedRow)
        try PointerDelivery.move(to: try point(ofPath: "a.txt", in: view), in: view)
        fixture.key.stopBeingKey()

        fixture.key.pointer = try point(ofPath: "b.txt", in: view)
        fixture.key.becomeKey()

        XCTAssertEqual(view.hoverPaths(), [])
        XCTAssertEqual(view.barPaths(), ["b.txt"])
        // The tree draws its selected row from `drawsSelection` (the fill and the bar), and the row
        // is still the table's selected row.
        XCTAssertEqual(view.outlineView.selectedRow, selectedRow, "still the selected row")
    }

    // MARK: the selected row and the pointer (CP-634, CP-635)

    func test_selected_open_row_shows_no_hover_with_pointer_moving() throws {
        let fixture = makeFixture([file("a.txt"), file("b.txt")])
        let view = fixture.view
        view.showOpenFile(path: "b.txt")
        let atRest = try rowImage(view, path: "b.txt")

        try PointerDelivery.move(to: try point(ofPath: "b.txt", in: view), in: view)
        XCTAssertEqual(try rowImage(view, path: "b.txt"), atRest, "pointer on b.txt")
        XCTAssertFalse(view.hoverPaths().contains("b.txt"))

        try PointerDelivery.move(to: try point(ofPath: "a.txt", in: view), in: view)
        XCTAssertEqual(try rowImage(view, path: "b.txt"), atRest, "pointer on a.txt")
        XCTAssertEqual(view.hoverPaths(), ["a.txt"], "a.txt shows hover while the pointer is on it")

        try PointerDelivery.leave(at: try point(ofPath: "a.txt", in: view), in: view)
        XCTAssertEqual(try rowImage(view, path: "b.txt"), atRest, "pointer gone")
        XCTAssertEqual(view.hoverPaths(), [])
    }

    func test_clicked_folder_row_takes_hover() throws {
        let fixture = makeFixture([folder("src"), file("a.txt"), file("b.txt")])
        let view = fixture.view
        view.showOpenFile(path: "b.txt")
        view.outlineView.selectRowIndexes(
            IndexSet(integer: try row(of: "src", in: view)), byExtendingSelection: false)

        try PointerDelivery.move(to: try point(ofPath: "src", in: view), in: view)

        XCTAssertEqual(view.hoverPaths(), ["src"])
    }

    func test_clicked_status_line_never_takes_hover() throws {
        let fixture = makeFixture(
            [folder("src"), file("b.txt")], listings: ["src": .observed([])])
        let view = fixture.view
        try expand("src", in: view)
        view.showOpenFile(path: "b.txt")
        let lineRow = try XCTUnwrap(
            (0..<view.outlineView.numberOfRows).first { view.lineText(atRow: $0) != nil })
        view.outlineView.selectRowIndexes(IndexSet(integer: lineRow), byExtendingSelection: false)

        try PointerDelivery.move(to: point(ofRow: lineRow, in: view), in: view)

        XCTAssertEqual(filledRows(view), [])
        XCTAssertEqual(view.hoverPaths(), [])
    }

    func test_hover_s1_window_becomes_key_with_pointer_outside_the_host_fills_nothing() throws {
        let fixture = makeFixture(files(40))
        let view = fixture.view
        try PointerDelivery.move(to: point(ofRow: 3, in: view), in: view)
        scroll(view, to: 100)
        let above = NSPoint(x: 40, y: view.bounds.maxY + 12)
        XCTAssertNotNil(entryPath(at: above, in: view), "a row's frame lies above the view")
        let beside = NSPoint(x: view.bounds.maxX + 30, y: 60)
        let lastRow = view.outlineView.rect(ofRow: 39)
        let below = view.convert(NSPoint(x: 40, y: lastRow.maxY + 30), from: view.outlineView)
        let requests = fixture.rest.requests.count

        for (what, outside) in [("beside", beside), ("above", above), ("below", below)] {
            try PointerDelivery.move(to: point(ofRow: 5, in: view), in: view)
            XCTAssertEqual(view.hoverPaths().count, 1, what)
            fixture.key.stopBeingKey()
            fixture.key.pointer = outside
            fixture.key.becomeKey()
            XCTAssertEqual(view.hoverPaths(), [], what)
        }
        XCTAssertEqual(fixture.rest.requests.count, requests, "no rest")
    }
}
