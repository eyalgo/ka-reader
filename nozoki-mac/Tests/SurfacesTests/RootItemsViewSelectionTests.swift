import AppKit
import XCTest

@testable import Surfaces

/// The tree draws its open file's row as selected (CP-628 to CP-633): `{colors.selection}` edge to
/// edge with the `{colors.primary}` bar over it, the same whether or not the window is key, and
/// never the platform's own selection. The colours are literals of `docs/DESIGN.md:L420`, never read
/// from the code (the rule at `RowHoverTests`). Every comparison is per channel in sRGB, within
/// 1.5/255, at alpha 1.
@MainActor
final class RootItemsViewSelectionTests: XCTestCase {
    private let glyph = NSImage(size: NSSize(width: 1, height: 1))

    private final class Fixture {
        let view: RootItemsView
        let window: NSWindow
        let key: KeyWindowDouble

        init(view: RootItemsView, window: NSWindow, key: KeyWindowDouble) {
            self.view = view
            self.window = window
            self.key = key
        }
    }

    /// A tree in a borderless window, as `RootItemsViewHoverTests.makeFixture` builds one. A folder
    /// read is answered at once from `listings`.
    private func makeFixture(
        _ entries: [Entry], listings: [String: RootListing] = [:], markers: TreeMarkers = .none
    ) -> Fixture {
        let key = KeyWindowDouble()
        let view = RootItemsView(
            folderGlyph: glyph, fileGlyph: glyph, fileCodeGlyph: glyph,
            statusGlyphs: StatusGlyphs(empty: glyph, failure: glyph),
            tooltipRest: TooltipRestDouble().rest, keyWindow: key.source)
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 260, height: 200), styleMask: [.borderless],
            backing: .buffered, defer: true)
        // sRGB, so a rendered row reads back in the space its tokens are written in.
        window.colorSpace = .sRGB
        view.listTree = { path, answer in answer(listings[path]) }
        view.show(.observed(entries))
        view.showMarkers(markers)
        window.contentView = view
        view.layoutSubtreeIfNeeded()
        return Fixture(view: view, window: window, key: key)
    }

    private func folder(_ path: String) -> Entry {
        Entry(
            name: (path as NSString).lastPathComponent, path: path, kind: .folder, state: .pending)
    }

    private func file(_ path: String) -> Entry {
        Entry(
            name: (path as NSString).lastPathComponent, path: path, kind: .file, state: .observed)
    }

    /// `src` holding `lib.rs`, then `a.txt` and `b.txt`.
    private func makeTree() -> Fixture {
        makeFixture(
            [folder("src"), file("a.txt"), file("b.txt")],
            listings: ["src": .observed([file("src/lib.rs")])])
    }

    private func row(of path: String, in view: RootItemsView) throws -> Int {
        try XCTUnwrap(
            (0..<view.outlineView.numberOfRows).first { view.entry(atRow: $0)?.path == path },
            "no row for \(path)")
    }

    private func rowView(atRow index: Int, in view: RootItemsView) throws -> BarRowView {
        let made = view.outlineView.rowView(atRow: index, makeIfNecessary: true)
        return try XCTUnwrap(made as? BarRowView)
    }

    private func select(_ path: String, in view: RootItemsView) throws {
        view.outlineView.selectRowIndexes(
            IndexSet(integer: try row(of: path, in: view)), byExtendingSelection: false)
    }

    /// Selects the status line the expanded `src` shows, which an empty folder draws.
    private func selectStatusLine(in view: RootItemsView) throws -> Int {
        let index = try XCTUnwrap(
            (0..<view.outlineView.numberOfRows).first { view.lineText(atRow: $0) != nil },
            "no status line")
        view.outlineView.selectRowIndexes(IndexSet(integer: index), byExtendingSelection: false)
        return index
    }

    private func expand(_ path: String, in view: RootItemsView) throws {
        view.outlineView.expandItem(view.outlineView.item(atRow: try row(of: path, in: view)))
        view.layoutSubtreeIfNeeded()
    }

    private func collapse(_ path: String, in view: RootItemsView) throws {
        view.outlineView.collapseItem(view.outlineView.item(atRow: try row(of: path, in: view)))
        view.layoutSubtreeIfNeeded()
    }

    private func render(
        _ fixture: Fixture, row index: Int, theme: NSAppearance.Name, emphasized: Bool
    ) throws -> NSBitmapImageRep {
        fixture.window.appearance = NSAppearance(named: theme)
        let view = try rowView(atRow: index, in: fixture.view)
        view.isEmphasized = emphasized
        view.layoutSubtreeIfNeeded()
        let rep = try XCTUnwrap(view.bitmapImageRepForCachingDisplay(in: view.bounds))
        view.cacheDisplay(in: view.bounds, to: rep)
        return rep
    }

    private func image(
        _ fixture: Fixture, path: String, theme: NSAppearance.Name = .aqua, emphasized: Bool = true
    ) throws -> Data {
        let rep = try render(
            fixture, row: try row(of: path, in: fixture.view), theme: theme, emphasized: emphasized)
        return try XCTUnwrap(rep.representation(using: .png, properties: [:]))
    }

    /// Reads one pixel of `rep` and compares it to `hex` per channel, within 1.5/255, at alpha 1.
    /// The rep must be an sRGB one, which the fixture's window colour space makes it: a rep that
    /// carries the display's own space reads the very same drawn pixel `#28292D` for the bar's
    /// `#1E1F22` once its colour is converted, which is a reading error and not a drawn one
    /// (measured 2026-10-04, `window.colorSpace` the display's `Color LCD`: the raw channels were
    /// the tokens exactly and `usingColorSpace(.sRGB)` moved them). With the rep's space asserted,
    /// its channels are the sRGB values, so no conversion is applied to them.
    private func assertColour(
        _ rep: NSBitmapImageRep, atX x: Int, y: Int, equals hex: UInt32, _ context: String,
        file: StaticString = #filePath, line: UInt = #line
    ) throws {
        XCTAssertEqual(
            rep.colorSpace, NSColorSpace.sRGB, "the rep is sRGB, \(context)", file: file,
            line: line)
        let colour = try XCTUnwrap(rep.colorAt(x: x, y: y))
        let expected = [
            CGFloat((hex >> 16) & 0xFF), CGFloat((hex >> 8) & 0xFF), CGFloat(hex & 0xFF),
        ].map { $0 / 255 }
        let actual = [colour.redComponent, colour.greenComponent, colour.blueComponent]
        for (a, e) in zip(actual, expected) {
            XCTAssertEqual(a, e, accuracy: 1.5 / 255, context, file: file, line: line)
        }
        XCTAssertEqual(
            colour.alphaComponent, 1, accuracy: 1.5 / 255, "alpha, \(context)", file: file,
            line: line)
    }

    // MARK: the sampling case (CP-639)

    func test_selected_tree_row_samples_selection_fill_and_bar_key_and_not_key_in_both_themes()
        throws
    {
        let fixture = makeFixture([file("a.txt"), file("b.txt")])
        let view = fixture.view
        view.showOpenFile(path: "b.txt")
        let index = try row(of: "b.txt", in: view)
        let themes: [(NSAppearance.Name, fill: UInt32, bar: UInt32)] = [
            (.aqua, 0xE2E3DF, 0x1E1F22), (.darkAqua, 0x34363B, 0xE7E7E4),
        ]
        for (theme, fill, bar) in themes {
            for isKey in [true, false] {
                // The not-key half stops the key double and sets the row view's isEmphasized false,
                // the state the platform reads for its inactive selection look.
                if isKey { fixture.key.becomeKey() } else { fixture.key.stopBeingKey() }
                let rep = try render(fixture, row: index, theme: theme, emphasized: isKey)
                let context = "\(theme.rawValue), \(isKey ? "key" : "not key")"

                // A point in the fill: clear of the bar and of every visible subview of the cell.
                let rowView = try rowView(atRow: index, in: view)
                let scale = CGFloat(rep.pixelsWide) / rowView.bounds.width
                let fillX = rowView.bounds.maxX - 6
                let fillY = rowView.bounds.midY
                let occupied = rowView.subviews.flatMap { cell in
                    cell.subviews.filter { !$0.isHidden }.map { $0.convert($0.bounds, to: rowView) }
                }
                XCTAssertFalse(occupied.isEmpty, "the cell shows its glyph and name, \(context)")
                for frame in occupied {
                    XCTAssertFalse(
                        frame.contains(NSPoint(x: fillX, y: fillY)),
                        "the fill point is inside a subview frame, \(context)")
                }
                try assertColour(
                    rep, atX: Int(fillX * scale), y: Int(rep.pixelsHigh / 2), equals: fill,
                    "fill, \(context)")
                try assertColour(
                    rep, atX: 0, y: rep.pixelsHigh / 2, equals: bar, "bar, \(context)")
            }
        }
    }

    // MARK: key status changes nothing (CP-630)

    func test_key_change_changes_nothing_on_the_selected_row() throws {
        let fixture = makeFixture([file("a.txt"), file("b.txt")])
        fixture.view.showOpenFile(path: "b.txt")
        for theme in [NSAppearance.Name.aqua, .darkAqua] {
            fixture.key.becomeKey()
            let before = try image(fixture, path: "b.txt", theme: theme, emphasized: true)
            fixture.key.stopBeingKey()
            let whileNotKey = try image(fixture, path: "b.txt", theme: theme, emphasized: true)
            fixture.key.becomeKey()
            let after = try image(fixture, path: "b.txt", theme: theme, emphasized: true)
            XCTAssertEqual(whileNotKey, before, "while not key, \(theme.rawValue)")
            XCTAssertEqual(after, before, "key again, \(theme.rawValue)")
        }
    }

    // MARK: at most one, both or neither (CP-629)

    func test_fill_and_bar_belong_to_exactly_the_open_row() throws {
        let fixture = makeFixture([file("a.txt"), file("b.txt")])
        fixture.view.showOpenFile(path: "b.txt")
        XCTAssertEqual(fixture.view.selectionFillPaths(), ["b.txt"])
        XCTAssertEqual(fixture.view.barPaths(), ["b.txt"])
    }

    func test_clicked_folder_row_draws_no_selection_while_file_open() throws {
        let fixture = makeTree()
        let view = fixture.view
        view.showOpenFile(path: "b.txt")
        var unselected: [String: Data] = [:]
        for theme in [NSAppearance.Name.aqua, .darkAqua] {
            for emphasized in [true, false] {
                unselected["\(theme.rawValue)\(emphasized)"] = try image(
                    fixture, path: "src", theme: theme, emphasized: emphasized)
            }
        }

        try select("src", in: view)

        XCTAssertEqual(view.selectionFillPaths(), ["b.txt"])
        for theme in [NSAppearance.Name.aqua, .darkAqua] {
            for emphasized in [true, false] {
                XCTAssertEqual(
                    try image(fixture, path: "src", theme: theme, emphasized: emphasized),
                    unselected["\(theme.rawValue)\(emphasized)"],
                    "src, \(theme.rawValue), emphasized \(emphasized)")
            }
        }
    }

    func test_clicked_status_line_draws_no_selection_while_file_open() throws {
        let fixture = makeFixture(
            [folder("src"), file("a.txt"), file("b.txt")], listings: ["src": .observed([])])
        let view = fixture.view
        try expand("src", in: view)
        view.showOpenFile(path: "b.txt")
        let lineIndex = try XCTUnwrap(
            (0..<view.outlineView.numberOfRows).first { view.lineText(atRow: $0) != nil })
        var unselected: [String: Data] = [:]
        for theme in [NSAppearance.Name.aqua, .darkAqua] {
            for emphasized in [true, false] {
                let rep = try render(fixture, row: lineIndex, theme: theme, emphasized: emphasized)
                unselected["\(theme.rawValue)\(emphasized)"] = rep.representation(
                    using: .png, properties: [:])
            }
        }

        let selectedLine = try selectStatusLine(in: view)

        XCTAssertEqual(selectedLine, lineIndex)
        XCTAssertEqual(view.selectionFillPaths(), ["b.txt"])
        for theme in [NSAppearance.Name.aqua, .darkAqua] {
            for emphasized in [true, false] {
                let rep = try render(fixture, row: lineIndex, theme: theme, emphasized: emphasized)
                XCTAssertEqual(
                    rep.representation(using: .png, properties: [:]),
                    unselected["\(theme.rawValue)\(emphasized)"],
                    "status line, \(theme.rawValue), emphasized \(emphasized)")
            }
        }
    }

    func test_no_file_open_draws_no_selection_whatever_row_is_selected() throws {
        let fixture = makeTree()
        let view = fixture.view
        let unselected = try image(fixture, path: "src")

        try select("src", in: view)

        XCTAssertEqual(view.selectionFillPaths(), [])
        XCTAssertEqual(view.barPaths(), [])
        XCTAssertEqual(try image(fixture, path: "src"), unselected)
    }

    func test_collapsing_the_open_files_folder_removes_fill_and_expanding_restores_it() throws {
        let fixture = makeTree()
        let view = fixture.view
        try expand("src", in: view)
        view.showOpenFile(path: "src/lib.rs")
        XCTAssertEqual(view.selectionFillPaths(), ["src/lib.rs"])

        try collapse("src", in: view)
        XCTAssertEqual(view.selectionFillPaths(), [])

        try expand("src", in: view)
        XCTAssertEqual(view.selectionFillPaths(), ["src/lib.rs"])
    }

    // MARK: the move is one turn (CP-633)

    func test_markOpenFile_moves_fill_and_bar_in_one_call() throws {
        let fixture = makeFixture([file("a.txt"), file("b.txt")])
        let view = fixture.view
        let unselected = try image(fixture, path: "a.txt")
        view.showOpenFile(path: "a.txt")
        XCTAssertEqual(view.selectionFillPaths(), ["a.txt"])

        view.markOpenFile(path: "b.txt")

        XCTAssertEqual(view.selectionFillPaths(), ["b.txt"])
        XCTAssertEqual(view.barPaths(), ["b.txt"])
        XCTAssertEqual(try image(fixture, path: "a.txt"), unselected)
    }
}
