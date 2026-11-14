import AppKit
import Testing

@testable import Surfaces

/// The Git view realizes a list's rows only for the part of the list in view (CP-1335, CP-1336), and
/// every row, its letter, selection, hover, tooltip and activation stay what the view always drew
/// (CP-1337). Every case builds the real view as `GitViewTests` does, in a 260 × 500 window, and
/// reads the views it holds and what they draw. The sentences and letters are literals here.
@MainActor
struct GitRowListTests {
    private static let windowHeight: CGFloat = 500
    private static let rowHeight: CGFloat = 24

    /// The most rows a window of `windowHeight` can hold at once: the rows that fit, one more for a
    /// row cut at each edge, and the list's overscan on each side.
    private static let rowsHeldAtMost =
        Int((windowHeight / rowHeight).rounded(.up)) + 1 + 2 * GitRowList.overscan

    private final class Activations {
        var paths: [String] = []
    }

    private struct Fixture {
        let view: GitView
        let window: NSWindow
        let rest: TooltipRestDouble
        let key: KeyWindowDouble
        let activations: Activations
    }

    private let glyph = NSImage(size: NSSize(width: 3, height: 3))

    private func makeFixture(showing item: GitItem? = nil, inWindow: Bool = true) -> Fixture {
        let rest = TooltipRestDouble()
        let key = KeyWindowDouble()
        let view = GitView(
            statusGlyphs: StatusGlyphs(empty: glyph, failure: glyph), tooltipRest: rest.rest,
            keyWindow: key.source)
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 260, height: Self.windowHeight),
            styleMask: [.borderless], backing: .buffered, defer: true)
        if inWindow { window.contentView = view }
        let activations = Activations()
        view.rowActivated = { activations.paths.append($0) }
        if let item {
            view.show(item)
            view.layoutSubtreeIfNeeded()
        }
        return Fixture(view: view, window: window, rest: rest, key: key, activations: activations)
    }

    private func repository(
        staged: [GitEntry] = [], changed: [GitEntry] = []
    ) -> GitItem {
        .repository(
            GitRepository(branch: .named("main"), state: .normal, staged: staged, changed: changed))
    }

    /// `count` untracked files in folders of 100, as the E3 repository holds them.
    private func untracked(_ count: Int) -> [GitEntry] {
        (0..<count).map { GitEntry(path: untrackedPath($0), category: .untracked) }
    }

    private func untrackedPath(_ index: Int) -> String {
        "bulk/d\(padded(index / 100, to: 5))/f\(padded(index, to: 5)).txt"
    }

    /// `number` in decimal, with leading zeros to `width` digits.
    private func padded(_ number: Int, to width: Int) -> String {
        let digits = String(number)
        return String(repeating: "0", count: max(0, width - digits.count)) + digits
    }

    private func descendants(of view: NSView) -> [NSView] {
        view.subviews + view.subviews.flatMap { descendants(of: $0) }
    }

    private func rowViews(_ view: GitView) -> [BarRowView] {
        descendants(of: view).compactMap { $0 as? BarRowView }
    }

    private func field(_ identifier: String, of row: BarRowView) -> NSTextField? {
        row.subviews.compactMap { $0 as? NSTextField }
            .first { $0.identifier?.rawValue == identifier }
    }

    private func path(of row: BarRowView) -> String? { field("gitRowPath", of: row)?.stringValue }

    private func letter(of row: BarRowView) -> String? { field("gitRowLetter", of: row)?.stringValue }

    private func realizedPaths(_ view: GitView) -> [String] {
        rowViews(view).compactMap { path(of: $0) }
    }

    private func rowView(_ path: String, in view: GitView) -> BarRowView? {
        rowViews(view).first { self.path(of: $0) == path }
    }

    private func centre(of row: BarRowView, in view: GitView) -> NSPoint {
        let frame = row.convert(row.bounds, to: view)
        return NSPoint(x: frame.midX, y: frame.midY)
    }

    private func scrollView(of view: GitView) throws -> NSScrollView {
        try #require(descendants(of: view).compactMap { $0 as? NSScrollView }.first)
    }

    private func scroll(_ view: GitView, to y: CGFloat) throws {
        let scrollView = try scrollView(of: view)
        scrollView.contentView.scroll(to: NSPoint(x: 0, y: y))
        scrollView.reflectScrolledClipView(scrollView.contentView)
    }

    private func lastScrollPosition(of view: GitView) throws -> CGFloat {
        let scrollView = try scrollView(of: view)
        let document = try #require(scrollView.documentView)
        return document.frame.height - scrollView.contentView.bounds.height
    }

    private func click(_ point: NSPoint, in fixture: Fixture) throws {
        let made = NSEvent.mouseEvent(
            with: .leftMouseDown, location: fixture.view.convert(point, to: nil),
            modifierFlags: [], timestamp: 0, windowNumber: fixture.window.windowNumber,
            context: nil, eventNumber: 0, clickCount: 1, pressure: 1)
        fixture.view.mouseDown(with: try #require(made))
    }

    /// The text of every text field that is not a row's, which is what the headings are.
    private func headingStrings(_ view: GitView) -> [String] {
        descendants(of: view).compactMap { $0 as? NSTextField }
            .filter { $0.identifier == nil }.map(\.stringValue)
    }

    // MARK: The bound (CP-1335, CP-1336)

    @Test func rowsRealizedAreBoundedByTheWindowNotTheList() throws {
        let fixture = makeFixture(showing: repository(changed: untracked(2_000)))

        #expect(rowViews(fixture.view).count <= Self.rowsHeldAtMost)

        try scroll(fixture.view, to: try lastScrollPosition(of: fixture.view))

        #expect(rowViews(fixture.view).count <= Self.rowsHeldAtMost)
        let last = try #require(rowView("bulk/d00019/f01999.txt", in: fixture.view))
        #expect(letter(of: last) == "U")
    }

    // MARK: Every row, once, in order (CP-1334, CP-1337)

    @Test func everyRowAppearsOnceInOrderAcrossAScrollThroughBothLists() throws {
        let staged = (0..<80).map { index in
            GitEntry(path: "staged/s\(padded(index, to: 3)).txt", category: .added)
        }
        let changed = (0..<120).map { index in
            GitEntry(
                path: "work/W\(padded(index, to: 3)).txt",
                category: index.isMultiple(of: 2) ? .modified : .deleted)
        }
        let fixture = makeFixture(showing: repository(staged: staged, changed: changed))
        let expected =
            GitRowOrder.ordered(staged).map { ($0.path, "A") }
            + GitRowOrder.ordered(changed).map { ($0.path, $0.category == .modified ? "M" : "D") }
        let end = try lastScrollPosition(of: fixture.view)

        // The row's top edge in the scrolled content, which no two rows share.
        var seen: [Int: (String, String)] = [:]
        var position: CGFloat = 0
        while true {
            try scroll(fixture.view, to: position)
            let document = try #require(try scrollView(of: fixture.view).documentView)
            var thisStep: [Int] = []
            for row in rowViews(fixture.view) {
                let top = Int(row.convert(row.bounds, to: document).minY.rounded())
                let pair = (try #require(path(of: row)), try #require(letter(of: row)))
                if let earlier = seen[top] { #expect(earlier == pair) }
                seen[top] = pair
                thisStep.append(top)
            }
            #expect(Set(thisStep).count == thisStep.count, "a row is held twice at \(position)")
            if position >= end { break }
            position = min(position + 100, end)
        }

        let collected = seen.sorted { $0.key < $1.key }.map(\.value)
        #expect(collected.map(\.0) == expected.map(\.0))
        #expect(collected.map(\.1) == expected.map(\.1))
        #expect(headingStrings(fixture.view).contains("Staged"))
        #expect(headingStrings(fixture.view).contains("80"))
        #expect(headingStrings(fixture.view).contains("Changes"))
        #expect(headingStrings(fixture.view).contains("120"))
    }

    // MARK: Selection and recycling (CP-1337)

    @Test func aSelectedRowKeepsItsSelectionWhenScrolledOutAndBack() throws {
        let fixture = makeFixture(showing: repository(changed: untracked(300)))
        let selected = untrackedPath(3)
        try click(centre(of: try #require(rowView(selected, in: fixture.view)), in: fixture.view),
            in: fixture)
        #expect(fixture.view.barPaths() == [selected])

        try scroll(fixture.view, to: try lastScrollPosition(of: fixture.view))

        #expect(fixture.view.barPaths() == [selected])
        #expect(fixture.view.selectionFillPaths() == [selected])

        try scroll(fixture.view, to: 0)

        let back = try #require(rowView(selected, in: fixture.view))
        #expect(back.drawsSelection)
        #expect(back.drawsBar)
        #expect(fixture.view.barPaths() == [selected])
        #expect(fixture.view.selectionFillPaths() == [selected])

        fixture.view.show(repository(changed: untracked(300)))
        fixture.view.layoutSubtreeIfNeeded()
        #expect(fixture.view.barPaths().isEmpty)
        #expect(fixture.view.selectionFillPaths().isEmpty)
    }

    @Test func aRecycledRowCarriesNoStaleFlag() throws {
        let fixture = makeFixture(showing: repository(changed: untracked(300)))
        let selected = untrackedPath(3)
        try click(centre(of: try #require(rowView(selected, in: fixture.view)), in: fixture.view),
            in: fixture)
        let pointer = NSPoint(x: 40, y: 300)
        try PointerDelivery.move(to: pointer, in: fixture.view)
        let hovered = fixture.view.hoverPaths()
        #expect(hovered.count == 1)

        try scroll(fixture.view, to: try lastScrollPosition(of: fixture.view))

        let underPointer = rowViews(fixture.view).filter {
            $0.convert($0.bounds, to: fixture.view).contains(pointer)
        }
        #expect(underPointer.count == 1)
        for row in rowViews(fixture.view) {
            let isSelected = path(of: row) == selected
            #expect(row.drawsBar == isSelected, "\(path(of: row) ?? "?") and the bar")
            #expect(row.drawsSelection == isSelected, "\(path(of: row) ?? "?") and the fill")
            #expect(row.showsHover == (row === underPointer.first), "\(path(of: row) ?? "?")")
        }
        #expect(fixture.view.hoverPaths() == underPointer.compactMap { path(of: $0) })
    }

    // MARK: A view that gets its size late, a view shown another item, a row scrolled to

    @Test func aListShownBeforeTheViewHasASizeRealizesItsRowsWhenItGetsOne() {
        let fixture = makeFixture(inWindow: false)
        fixture.view.show(repository(changed: untracked(500)))
        #expect(fixture.view.frame.size == .zero)
        fixture.window.contentView = fixture.view

        fixture.window.layoutIfNeeded()
        fixture.window.layoutIfNeeded()

        let first = rowView(untrackedPath(0), in: fixture.view)
        #expect(first != nil)
        #expect(first.map { $0.convert($0.bounds, to: fixture.view).height } == Self.rowHeight)
    }

    @Test func showingAnotherItemLeavesNoRowOfTheFirst() {
        let fixture = makeFixture(showing: repository(changed: untracked(500)))
        #expect(!rowViews(fixture.view).isEmpty)

        fixture.view.show(.pending)
        #expect(rowViews(fixture.view).isEmpty)

        fixture.view.show(repository(changed: [GitEntry(path: "only.txt", category: .modified)]))
        fixture.view.layoutSubtreeIfNeeded()
        #expect(realizedPaths(fixture.view) == ["only.txt"])
    }

    @Test func aRowScrolledIntoViewActivatesItsOwnPath() throws {
        let fixture = makeFixture(showing: repository(changed: untracked(500)))
        let last = untrackedPath(499)

        try scroll(fixture.view, to: try lastScrollPosition(of: fixture.view))

        let row = try #require(rowView(last, in: fixture.view))
        let letterField = try #require(field("gitRowLetter", of: row))
        try PointerDelivery.move(
            to: fixture.view.convert(
                NSPoint(x: letterField.bounds.midX, y: letterField.bounds.midY), from: letterField),
            in: fixture.view)
        fixture.rest.fireLast()
        #expect(fixture.view.letterTooltip.shownText == "\(last) \u{2014} untracked")

        try click(centre(of: row, in: fixture.view), in: fixture)
        #expect(fixture.activations.paths == [last])
    }
}
