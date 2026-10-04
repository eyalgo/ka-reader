import AppKit
import XCTest

@testable import Surfaces

/// The hover fill in the Git view (CP-599 to CP-609): the pointer is driven through
/// `PointerDelivery`, the fill is read off `hoverPaths()`, and a row's drawing off a rendered image.
@MainActor
final class GitViewHoverTests: XCTestCase {
    private let glyph = NSImage(size: NSSize(width: 3, height: 3))

    private struct Fixture {
        let view: GitView
        let window: NSWindow
        let activated: Box
        let rest: TooltipRestDouble
    }

    @MainActor
    private final class Box {
        var paths: [String] = []
    }

    private func makeFixture(showing item: GitItem) -> Fixture {
        let rest = TooltipRestDouble()
        let view = GitView(
            statusGlyphs: StatusGlyphs(empty: glyph, failure: glyph), tooltipRest: rest.rest)
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 260, height: 500), styleMask: [.borderless],
            backing: .buffered, defer: true)
        window.contentView = view
        let box = Box()
        view.rowActivated = { box.paths.append($0) }
        view.show(item)
        view.layoutSubtreeIfNeeded()
        return Fixture(view: view, window: window, activated: box, rest: rest)
    }

    private func repository(
        state: RepositoryState = .normal, staged: [GitEntry] = [], changed: [GitEntry] = []
    ) -> GitItem {
        .repository(
            GitRepository(branch: .named("main"), state: state, staged: staged, changed: changed))
    }

    private func entry(_ path: String, _ category: GitStatusCategory = .modified) -> GitEntry {
        GitEntry(path: path, category: category)
    }

    private func descendants(of view: NSView) -> [NSView] {
        view.subviews + view.subviews.flatMap { descendants(of: $0) }
    }

    /// Every drawn row, top to bottom.
    private func rowViews(_ view: GitView) -> [BarRowView] {
        descendants(of: view).compactMap { $0 as? BarRowView }
            .filter { !$0.isHiddenOrHasHiddenAncestor }
            .sorted {
                $0.convert($0.bounds, to: view).midY > $1.convert($1.bounds, to: view).midY
            }
    }

    private func rowView(_ path: String, in view: GitView) throws -> BarRowView {
        try XCTUnwrap(
            rowViews(view).first { row in
                row.subviews.compactMap { $0 as? NSTextField }
                    .contains { $0.identifier?.rawValue == "gitRowPath" && $0.stringValue == path }
            }, "no row for \(path)")
    }

    private func centre(of view: NSView, in container: NSView) -> NSPoint {
        let frame = view.convert(view.bounds, to: container)
        return NSPoint(x: frame.midX, y: frame.midY)
    }

    private func point(ofRow path: String, in view: GitView) throws -> NSPoint {
        let frame = try rowView(path, in: view).convert(rowView(path, in: view).bounds, to: view)
        return NSPoint(x: frame.minX + 40, y: frame.midY)
    }

    /// The row whose rectangle holds `point`, found without the view's own lookup.
    private func rowPath(at point: NSPoint, in view: GitView) -> String? {
        rowViews(view).first { $0.convert($0.bounds, to: view).contains(point) }
            .flatMap { row in
                row.subviews.compactMap { $0 as? NSTextField }
                    .first { $0.identifier?.rawValue == "gitRowPath" }?.stringValue
            }
    }

    /// The middle of every text field outside a row: headings, counts, the branch, the messages.
    private func centresOfFieldsOutsideRows(in view: GitView) -> [NSPoint] {
        func insideRow(_ field: NSView) -> Bool {
            var current: NSView? = field
            while let next = current {
                if next is BarRowView { return true }
                current = next.superview
            }
            return false
        }
        return descendants(of: view).compactMap { $0 as? NSTextField }
            .filter { !$0.isHiddenOrHasHiddenAncestor && !insideRow($0) }
            .map { centre(of: $0, in: view) }
    }

    private func click(at point: NSPoint, in fixture: Fixture) throws {
        let event = NSEvent.mouseEvent(
            with: .leftMouseDown, location: fixture.view.convert(point, to: nil),
            modifierFlags: [], timestamp: 0, windowNumber: fixture.window.windowNumber,
            context: nil, eventNumber: 0, clickCount: 1, pressure: 1)
        fixture.view.mouseDown(with: try XCTUnwrap(event, "no event"))
    }

    private func rowImage(_ path: String, in view: GitView) throws -> Data {
        let row = try rowView(path, in: view)
        row.appearance = NSAppearance(named: .aqua)
        let rep = try XCTUnwrap(row.bitmapImageRepForCachingDisplay(in: row.bounds))
        row.cacheDisplay(in: row.bounds, to: rep)
        return try XCTUnwrap(rep.representation(using: .png, properties: [:]))
    }

    private func scrollView(of view: GitView) throws -> NSScrollView {
        try XCTUnwrap(descendants(of: view).compactMap { $0 as? NSScrollView }.first)
    }

    private func scroll(_ view: GitView, to y: CGFloat) throws {
        let scrollView = try scrollView(of: view)
        scrollView.contentView.scroll(to: NSPoint(x: 0, y: y))
        scrollView.reflectScrolledClipView(scrollView.contentView)
    }

    // MARK: S-4

    func test_hover_s4_file_row_shows_fill_under_pointer_and_loses_it_on_leave() throws {
        let fixture = makeFixture(
            showing: repository(staged: [entry("a.txt", .added)], changed: [entry("src/c.txt")]))
        let view = fixture.view

        for path in ["src/c.txt", "a.txt"] {
            let pointer = try point(ofRow: path, in: view)
            try PointerDelivery.move(to: pointer, in: view)
            XCTAssertEqual(view.hoverPaths(), [path])
            try PointerDelivery.leave(at: pointer, in: view)
            XCTAssertEqual(view.hoverPaths(), [], "after leaving \(path)")
        }
    }

    func test_hover_s4_status_message_never_shows_fill() throws {
        let items: [(String, GitItem)] = [
            ("the short status sentence", repository(state: .merge, changed: [entry("a.txt")])),
            ("the nothing-changed sentence", repository()),
            ("the pending sentence", .pending),
            ("the failure message", .failed(.condition(.repositoryReadFailed))),
            ("the fault message", .stopped),
        ]
        for (what, item) in items {
            let fixture = makeFixture(showing: item)
            let fields = centresOfFieldsOutsideRows(in: fixture.view)
            XCTAssertFalse(fields.isEmpty, what)
            for centre in fields {
                try PointerDelivery.move(to: centre, in: fixture.view)
                XCTAssertEqual(fixture.view.hoverPaths(), [], what)
            }
        }
    }

    func test_hover_s4_section_header_never_shows_fill() throws {
        let fixture = makeFixture(
            showing: repository(staged: [entry("a.txt", .added)], changed: [entry("src/c.txt")]))
        let fields = centresOfFieldsOutsideRows(in: fixture.view)
        // The branch, two headings and two counts.
        XCTAssertGreaterThanOrEqual(fields.count, 5)
        for centre in fields {
            try PointerDelivery.move(to: centre, in: fixture.view)
            XCTAssertEqual(fixture.view.hoverPaths(), [])
        }
    }

    func test_hover_s4_selected_row_under_pointer_keeps_selected_drawing_and_bar() throws {
        let fixture = makeFixture(showing: repository(changed: [entry("a.txt"), entry("b.txt")]))
        let view = fixture.view
        try click(at: try point(ofRow: "b.txt", in: view), in: fixture)
        XCTAssertEqual(view.barPaths(), ["b.txt"])
        try PointerDelivery.move(to: try point(ofRow: "a.txt", in: view), in: view)
        let elsewhere = try rowImage("b.txt", in: view)

        try PointerDelivery.move(to: try point(ofRow: "b.txt", in: view), in: view)

        XCTAssertEqual(view.hoverPaths(), [])
        XCTAssertEqual(view.barPaths(), ["b.txt"])
        XCTAssertEqual(try rowImage("b.txt", in: view), elsewhere)

        view.clearSelection()
        XCTAssertEqual(view.hoverPaths(), ["b.txt"], "no longer drawn as selected")
    }

    func test_hover_s4_scroll_moves_rows_under_still_pointer_fill_follows() throws {
        let many = (0..<30).map { entry(String(format: "c%02d.txt", $0)) }
        let fixture = makeFixture(showing: repository(staged: [entry("s.txt", .added)], changed: many))
        let view = fixture.view
        let pointer = try point(ofRow: "s.txt", in: view)
        try PointerDelivery.move(to: pointer, in: view)
        XCTAssertEqual(view.hoverPaths(), ["s.txt"])

        // Scroll until the *Changes* heading, which lies one row below `s.txt`, is under it.
        try scroll(view, to: 24)
        XCTAssertNil(rowPath(at: pointer, in: view), "a heading is under the pointer")
        XCTAssertEqual(view.hoverPaths(), [])

        try scroll(view, to: 72)
        let now = try XCTUnwrap(rowPath(at: pointer, in: view))
        XCTAssertNotEqual(now, "s.txt")
        XCTAssertEqual(view.hoverPaths(), [now])
    }

    func test_hover_s4_row_keeps_fill_while_tooltip_is_raised() throws {
        let fixture = makeFixture(showing: repository(changed: [entry("a.txt"), entry("b.txt")]))
        let view = fixture.view
        let letter = try XCTUnwrap(
            rowView("a.txt", in: view).subviews.compactMap { $0 as? NSTextField }
                .first { $0.identifier?.rawValue == "gitRowLetter" })

        try PointerDelivery.move(to: centre(of: letter, in: view), in: view)
        fixture.rest.fireLast()

        XCTAssertNotNil(view.letterTooltip.shownView)
        XCTAssertEqual(view.hoverPaths(), ["a.txt"])
    }

    func test_hover_pending_sentence_then_answer_puts_fill_on_the_row_now_under_pointer() throws {
        let answer = repository(
            staged: [entry("a.txt", .added)], changed: [entry("b.txt"), entry("c.txt")])
        let reference = makeFixture(showing: answer)
        let heading = try XCTUnwrap(
            descendants(of: reference.view).compactMap { $0 as? NSTextField }
                .first { $0.stringValue == "Staged" })
        let firstRow = try point(ofRow: "a.txt", in: reference.view)
        let onHeading = centre(of: heading, in: reference.view)

        for (what, pointer, expected) in [
            ("a file row", firstRow, ["a.txt"]), ("a heading", onHeading, [String]()),
        ] {
            let fixture = makeFixture(showing: .pending)
            try PointerDelivery.move(to: pointer, in: fixture.view)
            XCTAssertEqual(fixture.view.hoverPaths(), [], "\(what), while pending")

            fixture.view.show(answer)

            XCTAssertEqual(fixture.view.hoverPaths(), expected, what)
        }
    }

    func test_hover_plain_folder_git_view_never_shows_fill() throws {
        let fixture = makeFixture(showing: .plain)
        for y in stride(from: CGFloat(10), to: 500, by: 60) {
            try PointerDelivery.move(to: NSPoint(x: 100, y: y), in: fixture.view)
            XCTAssertEqual(fixture.view.hoverPaths(), [])
        }
    }

    func test_hover_click_on_hovered_git_row_activates_once_and_keeps_bar() throws {
        let fixture = makeFixture(showing: repository(changed: [entry("a.txt"), entry("b.txt")]))
        let view = fixture.view
        let pointer = try point(ofRow: "b.txt", in: view)
        try PointerDelivery.move(to: pointer, in: view)
        XCTAssertEqual(view.hoverPaths(), ["b.txt"])

        try click(at: pointer, in: fixture)

        XCTAssertEqual(fixture.activated.paths, ["b.txt"])
        XCTAssertEqual(view.hoverPaths(), [])
        XCTAssertEqual(view.barPaths(), ["b.txt"])
    }

    func test_hover_a_hidden_git_view_shows_no_fill_when_shown_again_without_a_pointer_event()
        throws
    {
        let fixture = makeFixture(showing: repository(changed: [entry("a.txt")]))
        let view = fixture.view
        try PointerDelivery.move(to: try point(ofRow: "a.txt", in: view), in: view)
        XCTAssertEqual(view.hoverPaths(), ["a.txt"])

        view.isHidden = true
        view.isHidden = false

        XCTAssertEqual(view.hoverPaths(), [])
    }
}
