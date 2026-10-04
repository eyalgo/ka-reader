import AppKit
import XCTest

@testable import Surfaces

/// The Git view's four presentations and its rows (CP-552 to CP-561, CP-564). Every sentence is a
/// string literal here and never read from `GitSentences`.
@MainActor
final class GitViewTests: XCTestCase {
    private let emptyGlyph = NSImage(size: NSSize(width: 3, height: 3))
    private let failureGlyph = NSImage(size: NSSize(width: 4, height: 4))

    private let clean = "Nothing has changed in this repository."
    private let fault =
        "Nozoki stopped while reading this repository's Git status and can't tell why. "
        + "The file tree is unaffected; the Git view shows the status again if Nozoki can read it."

    private struct Fixture {
        let view: GitView
        let window: NSWindow
        var activated: Box
    }

    @MainActor
    private final class Box {
        var paths: [String] = []
    }

    private func makeView(showing item: GitItem) -> Fixture {
        let glyphs = StatusGlyphs(empty: emptyGlyph, failure: failureGlyph)
        let view = GitView(statusGlyphs: glyphs)
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 260, height: 500), styleMask: [.borderless],
            backing: .buffered, defer: true)
        window.contentView = view
        let box = Box()
        view.rowActivated = { box.paths.append($0) }
        view.show(item)
        view.layoutSubtreeIfNeeded()
        return Fixture(view: view, window: window, activated: box)
    }

    private func repository(
        branch: GitBranch = .named("main"), state: RepositoryState = .normal,
        staged: [GitEntry] = [], changed: [GitEntry] = []
    ) -> GitItem {
        .repository(
            GitRepository(branch: branch, state: state, staged: staged, changed: changed))
    }

    private func entry(_ path: String, _ category: GitStatusCategory) -> GitEntry {
        GitEntry(path: path, category: category)
    }

    private func descendants(of view: NSView) -> [NSView] {
        view.subviews + view.subviews.flatMap { descendants(of: $0) }
    }

    private func shown(_ views: [NSView]) -> [NSView] {
        views.filter { !$0.isHiddenOrHasHiddenAncestor }
    }

    /// The text of every visible, non-editable text field, top to bottom and left to right.
    private func strings(_ view: GitView) -> [String] {
        view.layoutSubtreeIfNeeded()
        func frame(_ field: NSView) -> NSRect { field.convert(field.bounds, to: view) }
        return shown(descendants(of: view))
            .compactMap { $0 as? NSTextField }
            .filter { !$0.isEditable }
            .sorted {
                let (a, b) = (frame($0), frame($1))
                return abs(a.midY - b.midY) > 1 ? a.midY > b.midY : a.minX < b.minX
            }
            .map(\.stringValue)
    }

    private func rowViews(_ view: GitView) -> [BarRowView] {
        shown(descendants(of: view)).compactMap { $0 as? BarRowView }
            .sorted {
                $0.convert($0.bounds, to: view).midY > $1.convert($1.bounds, to: view).midY
            }
    }

    private func visibleImageViews(_ view: GitView) -> [NSImageView] {
        shown(descendants(of: view)).compactMap { $0 as? NSImageView }
    }

    private func click(_ point: NSPoint, in fixture: Fixture) throws {
        let event = NSEvent.mouseEvent(
            with: .leftMouseDown, location: fixture.view.convert(point, to: nil),
            modifierFlags: [], timestamp: 0, windowNumber: fixture.window.windowNumber,
            context: nil, eventNumber: 0, clickCount: 1, pressure: 1)
        fixture.view.mouseDown(with: try XCTUnwrap(event, "no event"))
    }

    private func centre(of view: NSView, in container: NSView) -> NSPoint {
        let frame = view.convert(view.bounds, to: container)
        return NSPoint(x: frame.midX, y: frame.midY)
    }

    private func letterField(of row: BarRowView) throws -> NSTextField {
        try XCTUnwrap(
            row.subviews.compactMap { $0 as? NSTextField }
                .first { $0.identifier?.rawValue == "gitRowLetter" })
    }

    func test_pendingDrawsReadingGitStatusAndNoOtherElement() {
        let fixture = makeView(showing: .pending)

        XCTAssertEqual(strings(fixture.view), ["Reading Git status."])
        XCTAssertTrue(rowViews(fixture.view).isEmpty)
        XCTAssertEqual(visibleImageViews(fixture.view).map(\.image), [emptyGlyph])
    }

    func test_aNewViewIsPendingBeforeAnyAnswer() {
        let view = GitView(statusGlyphs: StatusGlyphs(empty: emptyGlyph, failure: failureGlyph))
        view.frame = NSRect(x: 0, y: 0, width: 260, height: 500)

        XCTAssertEqual(strings(view), ["Reading Git status."])
    }

    func test_plainDrawsNoTextNoGlyphNoControl() {
        let fixture = makeView(showing: .plain)
        let everything = shown(descendants(of: fixture.view))

        XCTAssertTrue(strings(fixture.view).isEmpty)
        XCTAssertTrue(visibleImageViews(fixture.view).isEmpty)
        XCTAssertTrue(rowViews(fixture.view).isEmpty)
        XCTAssertTrue(everything.allSatisfy { !($0 is NSTextField) && !($0 is NSButton) })
    }

    func test_aNormalRepositoryWithEmptyListsDrawsTheBranchAndTheCleanSentenceAndNoHeading() {
        let fixture = makeView(showing: repository())

        XCTAssertEqual(strings(fixture.view), ["main", clean])
        XCTAssertTrue(rowViews(fixture.view).isEmpty)
    }

    func test_theSixCategoryExampleDrawsStagedTwoAndChangesFourWithLettersInOrderAndNoShortStatus()
    {
        let item = repository(
            staged: [entry("src/new.txt", .added), entry("READ.md", .renamed)],
            changed: [
                entry("b.txt", .modified), entry("A.txt", .deleted), entry("tmp.log", .untracked),
                entry("c.txt", .inConflict),
            ])
        let fixture = makeView(showing: item)

        XCTAssertEqual(
            strings(fixture.view),
            [
                "main", "Staged", "2", "READ.md", "R", "src/new.txt", "A", "Changes", "4",
                "A.txt", "D", "b.txt", "M", "c.txt", "C", "tmp.log", "U",
            ])
    }

    func test_aPathInBothListsDrawsTwoRows() throws {
        let fixture = makeView(
            showing: repository(
                staged: [entry("x.txt", .added)], changed: [entry("x.txt", .modified)]))
        let rows = rowViews(fixture.view)
        XCTAssertEqual(rows.count, 2)

        try click(centre(of: rows[1], in: fixture.view), in: fixture)

        XCTAssertEqual(rows.map(\.drawsBar), [false, true])
        XCTAssertEqual(fixture.view.barPaths(), ["x.txt"])
    }

    func test_anEmptyListWithTheOtherNonEmptyDrawsOneHeading() {
        let changedOnly = makeView(
            showing: repository(changed: [entry("a.txt", .modified), entry("b.txt", .added)]))
        let stagedOnly = makeView(showing: repository(staged: [entry("a.txt", .added)]))

        XCTAssertEqual(
            strings(changedOnly.view), ["main", "Changes", "2", "a.txt", "M", "b.txt", "A"])
        XCTAssertEqual(strings(stagedOnly.view), ["main", "Staged", "1", "a.txt", "A"])
    }

    func test_eachOfTheSevenNonNormalStatesDrawsItsOwnSentenceAndNeverTheCleanOne() {
        let sentences: [RepositoryState: String] = [
            .merge: "A merge is in progress in this repository.",
            .rebase: "A rebase is in progress in this repository.",
            .cherryPick: "A cherry-pick is in progress in this repository.",
            .revert: "A revert is in progress in this repository.",
            .bisect: "A bisect is in progress in this repository.",
            .am: "An am session is in progress in this repository.",
            .detachedHead: "HEAD is detached in this repository.",
        ]
        let commit = "62290d82ec30f74dbffb792140ea647be14eb18c"

        for (state, sentence) in sentences {
            let branch: GitBranch = state == .rebase ? .detached(commit: commit) : .named("main")
            let drawn = strings(makeView(showing: repository(branch: branch, state: state)).view)

            XCTAssertEqual(drawn, [state == .rebase ? commit : "main", sentence])
            XCTAssertFalse(drawn.contains(clean))
        }
        XCTAssertEqual(sentences.count, 7)
    }

    func test_aNonNormalStateWithChangesDrawsItsSentenceAndTheLists() {
        let fixture = makeView(
            showing: repository(state: .merge, changed: [entry("a.txt", .inConflict)]))

        XCTAssertEqual(
            strings(fixture.view),
            [
                "main", "A merge is in progress in this repository.", "Changes", "1", "a.txt",
                "C",
            ])
    }

    func test_gitDirectoryOutsideDrawsOneMessageWithThePathAndNoControl() {
        let fixture = makeView(
            showing: .failed(.gitDirectoryOutside(gitDirectory: "/elsewhere/.git/worktrees/wt")))

        XCTAssertEqual(
            strings(fixture.view),
            [
                "This repository's Git directory is at /elsewhere/.git/worktrees/wt, outside the "
                    + "folder you opened, so Nozoki doesn't read its Git status. "
                    + "The file tree and the reading panel are unaffected."
            ])
        XCTAssertTrue(shown(descendants(of: fixture.view)).allSatisfy { !($0 is NSButton) })
        XCTAssertEqual(visibleImageViews(fixture.view).map(\.image), [failureGlyph])
    }

    func test_machineConfigNotSwitchedOffDrawsTheFault() {
        let fixture = makeView(showing: .failed(.condition(.machineConfigNotSwitchedOff)))

        XCTAssertEqual(strings(fixture.view), [fault])
    }

    func test_repositoryReadFailedDrawsOneMessageWithNoPathAndNoWireName() {
        let fixture = makeView(showing: .failed(.condition(.repositoryReadFailed)))
        let drawn = strings(fixture.view)

        XCTAssertEqual(drawn.count, 1)
        XCTAssertFalse(drawn[0].contains("/"))
        XCTAssertFalse(drawn[0].contains("repository_read_failed"))
    }

    func test_stoppedDrawsTheFault() {
        let fixture = makeView(showing: .stopped)

        XCTAssertEqual(strings(fixture.view), [fault])
        XCTAssertEqual(visibleImageViews(fixture.view).map(\.image), [failureGlyph])
    }

    func test_aFailureOrStoppedDrawsNoHeadingRowOrShortStatus() {
        let failures: [GitItem] =
            [.stopped, .failed(.gitDirectoryOutside(gitDirectory: "/e"))]
            + GitCondition.allCases.map { .failed(.condition($0)) }

        for item in failures {
            let fixture = makeView(showing: item)

            XCTAssertEqual(strings(fixture.view).count, 1, "\(item)")
            XCTAssertTrue(rowViews(fixture.view).isEmpty, "\(item)")
        }
    }

    func test_clickingARowOrItsLetterRaisesRowActivatedOnceWithThePath() throws {
        let fixture = makeView(
            showing: repository(
                staged: [entry("READ.md", .renamed)], changed: [entry("b.txt", .modified)]))
        let rows = rowViews(fixture.view)

        try click(centre(of: rows[0], in: fixture.view), in: fixture)
        XCTAssertEqual(fixture.activated.paths, ["READ.md"])

        let letter = try letterField(of: rows[1])
        try click(centre(of: letter, in: fixture.view), in: fixture)
        XCTAssertEqual(fixture.activated.paths, ["READ.md", "b.txt"])
    }

    func test_clickingAHeadingOrTheStatusMessageRaisesNothing() throws {
        let fixture = makeView(showing: repository(changed: [entry("b.txt", .modified)]))
        let heading = shown(descendants(of: fixture.view)).compactMap { $0 as? NSTextField }
            .first { $0.stringValue == "Changes" }

        try click(centre(of: heading!, in: fixture.view), in: fixture)

        XCTAssertTrue(fixture.activated.paths.isEmpty)
        XCTAssertTrue(fixture.view.barPaths().isEmpty)
    }

    func test_theClickedRowCarriesTheBarAndClearingTheSelectionRemovesIt() throws {
        let fixture = makeView(
            showing: repository(changed: [entry("a.txt", .modified), entry("b.txt", .added)]))
        let rows = rowViews(fixture.view)
        XCTAssertTrue(rows.allSatisfy { !$0.drawsBar })

        try click(centre(of: rows[1], in: fixture.view), in: fixture)
        XCTAssertEqual(rows.map(\.drawsBar), [false, true])
        XCTAssertEqual(fixture.view.barPaths(), ["b.txt"])

        fixture.view.clearSelection()
        XCTAssertTrue(rows.allSatisfy { !$0.drawsBar })
        XCTAssertTrue(fixture.view.barPaths().isEmpty)
    }

    func test_noElementOfTheViewHasATooltip() {
        let fixture = makeView(
            showing: repository(
                staged: [entry("a.txt", .added)], changed: [entry("b.txt", .modified)]))

        XCTAssertNil(fixture.view.toolTip)
        XCTAssertTrue(descendants(of: fixture.view).allSatisfy { $0.toolTip == nil })
        XCTAssertTrue(fixture.view.toolTip == nil)
    }
}
