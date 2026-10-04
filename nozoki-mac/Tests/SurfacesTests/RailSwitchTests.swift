import AppKit
import XCTest

@testable import Surfaces

/// The Files/Git switch (CP-547 to CP-549). Every label is a string literal here and never read
/// from `GitSentences`.
@MainActor
final class RailSwitchTests: XCTestCase {
    private let folderGlyph = NSImage(size: NSSize(width: 5, height: 5))
    private let gitGlyph = NSImage(size: NSSize(width: 6, height: 6))

    private final class Chosen {
        var entries: [RailEntry] = []
    }

    private struct Fixture {
        let rail: RailSwitchView
        let window: NSWindow
        let chosen: Chosen
    }

    private func makeRail(active: RailEntry) -> Fixture {
        let rail = RailSwitchView(folderGlyph: folderGlyph, gitGlyph: gitGlyph)
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 48, height: 400), styleMask: [.borderless],
            backing: .buffered, defer: true)
        window.contentView = rail
        let chosen = Chosen()
        rail.entryChosen = { chosen.entries.append($0) }
        rail.active = active
        rail.layoutSubtreeIfNeeded()
        return Fixture(rail: rail, window: window, chosen: chosen)
    }

    private func descendants(of view: NSView) -> [NSView] {
        view.subviews + view.subviews.flatMap { descendants(of: $0) }
    }

    /// The entries, top to bottom.
    private func entryViews(_ rail: RailSwitchView) -> [BarRowView] {
        descendants(of: rail).compactMap { $0 as? BarRowView }
            .sorted {
                $0.convert($0.bounds, to: rail).midY > $1.convert($1.bounds, to: rail).midY
            }
    }

    private func labels(of entry: NSView) -> [NSTextField] {
        descendants(of: entry).compactMap { $0 as? NSTextField }
    }

    private func images(of entry: NSView) -> [NSImageView] {
        descendants(of: entry).compactMap { $0 as? NSImageView }
    }

    private func click(_ entry: NSView, in fixture: Fixture) throws {
        let frame = entry.convert(entry.bounds, to: fixture.rail)
        let point = NSPoint(x: frame.midX, y: frame.midY)
        let event = NSEvent.mouseEvent(
            with: .leftMouseDown, location: fixture.rail.convert(point, to: nil),
            modifierFlags: [], timestamp: 0, windowNumber: fixture.window.windowNumber,
            context: nil, eventNumber: 0, clickCount: 1, pressure: 1)
        fixture.rail.mouseDown(with: try XCTUnwrap(event, "no event"))
    }

    func test_theTwoEntriesDrawExactlyFilesAndGitEachBesideAGlyph() throws {
        let fixture = makeRail(active: .files)
        let entries = entryViews(fixture.rail)

        XCTAssertEqual(entries.count, 2)
        XCTAssertEqual(entries.map { labels(of: $0).map(\.stringValue) }, [["Files"], ["Git"]])
        XCTAssertEqual(entries.map { images(of: $0).map(\.image) }, [[folderGlyph], [gitGlyph]])
        XCTAssertEqual(
            descendants(of: fixture.rail).compactMap { $0 as? NSTextField }.map(\.stringValue),
            ["Files", "Git"])
    }

    func test_theActiveEntryCarriesTheBarAndTheInactiveOneDoesNot() {
        let fixture = makeRail(active: .files)
        XCTAssertEqual(entryViews(fixture.rail).map(\.drawsBar), [true, false])

        fixture.rail.active = .git
        XCTAssertEqual(entryViews(fixture.rail).map(\.drawsBar), [false, true])
    }

    func test_clickingTheInactiveEntryRaisesItsChoice() throws {
        let fixture = makeRail(active: .files)
        let entries = entryViews(fixture.rail)

        try click(entries[1], in: fixture)
        XCTAssertEqual(fixture.chosen.entries, [.git])

        fixture.rail.active = .git
        try click(entries[0], in: fixture)
        XCTAssertEqual(fixture.chosen.entries, [.git, .files])
    }

    // CP-549: an entry is chosen by a press on its word or its glyph, as a window delivers it.
    func test_aClickAsAWindowDeliversItOnAnEntrysWordOrGlyphRaisesItsChoice() throws {
        let fixture = makeRail(active: .files)
        let entries = entryViews(fixture.rail)

        let gitWord = try XCTUnwrap(labels(of: entries[1]).first)
        XCTAssertTrue(
            try ClickDelivery.clickMiddle(of: gitWord) === gitWord, "the press lands on the word")
        XCTAssertEqual(fixture.chosen.entries, [.git], "a press on the word Git")

        fixture.rail.active = .git
        let filesGlyph = try XCTUnwrap(images(of: entries[0]).first)
        XCTAssertTrue(
            try ClickDelivery.clickMiddle(of: filesGlyph) === filesGlyph,
            "the press lands on the glyph")
        XCTAssertEqual(fixture.chosen.entries, [.git, .files], "a press on the Files glyph")
    }

    func test_clickingTheActiveEntryRaisesNothing() throws {
        let fixture = makeRail(active: .files)
        try click(entryViews(fixture.rail)[0], in: fixture)
        XCTAssertTrue(fixture.chosen.entries.isEmpty)

        fixture.rail.active = .git
        try click(entryViews(fixture.rail)[1], in: fixture)
        XCTAssertTrue(fixture.chosen.entries.isEmpty)
    }

    func test_aClickIsTheSwitchsOwnAndTheRaisedChoiceDoesNotMoveTheBar() throws {
        // The owner decides what the choice does; the switch marks only what it is told.
        let fixture = makeRail(active: .files)
        try click(entryViews(fixture.rail)[1], in: fixture)
        XCTAssertEqual(fixture.rail.active, .files)
        XCTAssertEqual(entryViews(fixture.rail).map(\.drawsBar), [true, false])
    }

    func test_bothEntriesStayEnabledWhicheverIsActive() {
        let fixture = makeRail(active: .files)
        for active in [RailEntry.files, .git] {
            fixture.rail.active = active
            let controls = descendants(of: fixture.rail).compactMap { $0 as? NSControl }
            XCTAssertEqual(controls.count, 4)
            XCTAssertTrue(controls.allSatisfy(\.isEnabled))
        }
    }

    func test_neitherEntryHasATooltip() {
        let fixture = makeRail(active: .files)
        XCTAssertNil(fixture.rail.toolTip)
        XCTAssertTrue(descendants(of: fixture.rail).allSatisfy { $0.toolTip == nil })
    }
}
