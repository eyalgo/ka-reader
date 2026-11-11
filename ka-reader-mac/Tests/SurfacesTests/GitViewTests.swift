import AppKit
import XCTest

@testable import Surfaces

/// The Git view's four presentations and its rows (CP-552 to CP-561, CP-564). Every sentence is a
/// string literal here and never read from `GitSentences`.
@MainActor
final class GitViewTests: XCTestCase {
    private let betaNotice =
        "The Git view and the letters beside changed files show the Git state KA-Reader read when you opened the folder. They do not update while KA-Reader is open."
    private let emptyGlyph = NSImage(size: NSSize(width: 3, height: 3))
    private let failureGlyph = NSImage(size: NSSize(width: 4, height: 4))

    private let clean = "Nothing has changed in this repository."
    private let fault =
        "When you opened the folder, KA-Reader stopped while finding out whether it's a repository and can't tell why. The file tree and the reading panel are unaffected. Start KA-Reader again to look again."

    private struct Fixture {
        let view: GitView
        let window: NSWindow
        var activated: Box
        let rest: TooltipRestDouble
        let key: KeyWindowDouble
    }

    @MainActor
    private final class Box {
        var paths: [String] = []
    }

    private func makeView(showing item: GitItem) -> Fixture {
        let glyphs = StatusGlyphs(empty: emptyGlyph, failure: failureGlyph)
        let rest = TooltipRestDouble()
        let key = KeyWindowDouble()
        let view = GitView(statusGlyphs: glyphs, tooltipRest: rest.rest, keyWindow: key.source)
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 260, height: 500), styleMask: [.borderless],
            backing: .buffered, defer: true)
        window.contentView = view
        let box = Box()
        view.rowActivated = { box.paths.append($0) }
        view.show(item)
        view.layoutSubtreeIfNeeded()
        return Fixture(view: view, window: window, activated: box, rest: rest, key: key)
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

        XCTAssertEqual(strings(fixture.view), [betaNotice, "main", clean])
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
                betaNotice, "main", "Staged", "2", "READ.md", "R", "src/new.txt", "A", "Changes",
                "4",
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
            strings(changedOnly.view),
            [betaNotice, "main", "Changes", "2", "a.txt", "M", "b.txt", "A"])
        XCTAssertEqual(strings(stagedOnly.view), [betaNotice, "main", "Staged", "1", "a.txt", "A"])
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

            XCTAssertEqual(drawn, [betaNotice, state == .rebase ? commit : "main", sentence])
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
                betaNotice, "main", "A merge is in progress in this repository.", "Changes", "1",
                "a.txt",
                "C",
            ])
    }

    func test_gitDirectoryOutsideDrawsOneMessageWithThePathAndNoControl() {
        let fixture = makeView(
            showing: .failed(.gitDirectoryOutside(gitDirectory: "/elsewhere/.git/worktrees/wt")))

        XCTAssertEqual(
            strings(fixture.view),
            [
                betaNotice,
                "When you opened the folder, this repository's Git directory was at /elsewhere/.git/worktrees/wt, outside the folder you opened, so KA-Reader didn't read its Git status. The file tree and the reading panel are unaffected. Start KA-Reader again to read the status again.",
            ])
        XCTAssertTrue(shown(descendants(of: fixture.view)).allSatisfy { !($0 is NSButton) })
        XCTAssertEqual(visibleImageViews(fixture.view).map(\.image), [failureGlyph])
    }

    func test_theAlternatesFailureDrawsOneMessageAndNothingElse() {
        let fixture = makeView(
            showing: .failed(.objectStoreNamesOutside(path: "../../../elsewhere/objects")))

        XCTAssertEqual(
            strings(fixture.view),
            [
                betaNotice,
                "When you opened the folder, KA-Reader found a Git object store that names ../../../elsewhere/objects, outside the folder you opened, so it didn't read the folder's Git status. The file tree and the reading panel are unaffected. Start KA-Reader again to read the status again.",
            ])
        XCTAssertNotEqual(strings(fixture.view), [GitSentences.pending])
        XCTAssertTrue(rowViews(fixture.view).isEmpty)
        XCTAssertTrue(shown(descendants(of: fixture.view)).allSatisfy { !($0 is NSButton) })
        XCTAssertEqual(visibleImageViews(fixture.view).map(\.image), [failureGlyph])
    }

    func test_theObjectStoreNotLocatedFailureDrawsOneMessageAndNothingElse() {
        let fixture = makeView(showing: .failed(.objectStoreNotLocated(path: "relative/objects")))

        XCTAssertEqual(
            strings(fixture.view),
            [
                betaNotice,
                "When you opened the folder, KA-Reader found a Git object store that names relative/objects but didn't work out where that path leads, so it didn't read the folder's Git status. The file tree and the reading panel are unaffected. Start KA-Reader again to read the status again.",
            ])
        XCTAssertNotEqual(strings(fixture.view), [GitSentences.pending])
        XCTAssertTrue(rowViews(fixture.view).isEmpty)
        XCTAssertTrue(shown(descendants(of: fixture.view)).allSatisfy { !($0 is NSButton) })
        XCTAssertEqual(visibleImageViews(fixture.view).map(\.image), [failureGlyph])
    }

    func test_theConfigNotLocatedFailureDrawsOneMessageAndNothingElse() {
        let fixture = makeView(
            showing: .failed(.configNotLocated(key: "core.excludesfile", path: "ignore-rel")))

        XCTAssertEqual(
            strings(fixture.view),
            [
                betaNotice,
                "When you opened the folder, KA-Reader found core.excludesfile set to ignore-rel and didn't work out where that path leads, so it didn't read the folder's Git status. The file tree and the reading panel are unaffected. Start KA-Reader again to read the status again.",
            ])
        XCTAssertNotEqual(strings(fixture.view), [GitSentences.pending])
        XCTAssertTrue(rowViews(fixture.view).isEmpty)
        XCTAssertTrue(shown(descendants(of: fixture.view)).allSatisfy { !($0 is NSButton) })
        XCTAssertEqual(visibleImageViews(fixture.view).map(\.image), [failureGlyph])
    }

    func test_theSubmoduleElsewhereFailureDrawsOneMessageAndNothingElse() {
        let fixture = makeView(
            showing: .failed(.submoduleElsewhere(name: "submodule", path: "evil")))

        XCTAssertEqual(
            strings(fixture.view),
            [
                betaNotice,
                "When you opened the folder, KA-Reader found that a .gitmodules gives the submodule at submodule the path evil, which leads somewhere else, so it didn't read the folder's Git status. The file tree and the reading panel are unaffected. Start KA-Reader again to read the status again.",
            ])
        XCTAssertTrue(rowViews(fixture.view).isEmpty)
        XCTAssertTrue(shown(descendants(of: fixture.view)).allSatisfy { !($0 is NSButton) })
        XCTAssertEqual(visibleImageViews(fixture.view).map(\.image), [failureGlyph])
    }

    func test_theGitmodulesUnreadableFailureDrawsOneMessageAndNothingElse() {
        let fixture = makeView(showing: .failed(.condition(.gitmodulesUnreadable)))

        XCTAssertEqual(
            strings(fixture.view),
            [
                betaNotice,
                "When you opened the folder, KA-Reader couldn't read how a repository in it names and places its submodules, so it didn't read the folder's Git status. The file tree and the reading panel are unaffected. Start KA-Reader again to read the status again.",
            ])
        XCTAssertTrue(rowViews(fixture.view).isEmpty)
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
            [
                .stopped, .failed(.gitDirectoryOutside(gitDirectory: "/e")),
                .failed(.objectStoreNamesOutside(path: "/e")),
                .failed(.objectStoreNotLocated(path: "/e")),
                .failed(.submoduleElsewhere(name: "e", path: "f")),
            ]
            + GitCondition.allCases.map { .failed(.condition($0)) }

        for item in failures {
            let fixture = makeView(showing: item)

            XCTAssertEqual(
                strings(fixture.view).count, GitReadPolicy.atOpen.showsNotice(for: item) ? 2 : 1,
                "\(item)")
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

    // CP-564: a row is one click target, wherever on it the press lands, as a window delivers it.
    func test_aClickAsAWindowDeliversItOnARowsPathItsLetterOrItsGroundActivatesThatRow() throws {
        let fixture = makeView(
            showing: repository(
                changed: [
                    entry("a.txt", .modified), entry("b.txt", .added), entry("c.txt", .deleted),
                ]))
        let rows = rowViews(fixture.view)
        let path = try XCTUnwrap(
            rows[0].subviews.compactMap { $0 as? NSTextField }
                .first { $0.identifier?.rawValue == "gitRowPath" })

        let letter = try letterField(of: rows[1])

        XCTAssertTrue(
            try ClickDelivery.clickMiddle(of: path) === path, "the press lands on the path")
        XCTAssertEqual(fixture.activated.paths, ["a.txt"], "a press on the path")

        XCTAssertTrue(
            try ClickDelivery.clickMiddle(of: letter) === letter, "the press lands on the letter")
        XCTAssertEqual(fixture.activated.paths, ["a.txt", "b.txt"], "a press on the letter")

        try ClickDelivery.click(
            at: NSPoint(x: rows[2].bounds.midX, y: rows[2].bounds.midY), in: rows[2])
        XCTAssertEqual(
            fixture.activated.paths, ["a.txt", "b.txt", "c.txt"], "a press on the row's ground")
        XCTAssertEqual(fixture.view.barPaths(), ["c.txt"])
    }

    func test_clickingAHeadingOrTheStatusMessageRaisesNothing() throws {
        let fixture = makeView(showing: repository(changed: [entry("b.txt", .modified)]))
        let heading = shown(descendants(of: fixture.view)).compactMap { $0 as? NSTextField }
            .first { $0.stringValue == "Changes" }

        try click(centre(of: try XCTUnwrap(heading), in: fixture.view), in: fixture)

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
        XCTAssertEqual(fixture.view.selectionFillPaths(), ["b.txt"])

        fixture.view.clearSelection()
        XCTAssertTrue(rows.allSatisfy { !$0.drawsBar })
        XCTAssertTrue(fixture.view.barPaths().isEmpty)
        XCTAssertEqual(fixture.view.selectionFillPaths(), [])
    }

    func test_drawingTheRowsAgainTakesTheSelectionFillAndTheBarOffTogether() throws {
        let item = repository(changed: [entry("a.txt", .modified), entry("b.txt", .added)])
        let fixture = makeView(showing: item)
        let rows = rowViews(fixture.view)
        try click(centre(of: rows[1], in: fixture.view), in: fixture)
        XCTAssertEqual(fixture.view.selectionFillPaths(), ["b.txt"])

        fixture.view.show(item)

        XCTAssertEqual(fixture.view.selectionFillPaths(), [])
        XCTAssertEqual(fixture.view.barPaths(), [])
        XCTAssertTrue(rowViews(fixture.view).allSatisfy { !$0.drawsSelection && !$0.drawsBar })
    }

    func test_noElementOfTheViewHasATooltip() throws {
        let fixture = makeView(
            showing: repository(
                staged: [entry("a.txt", .added)], changed: [entry("b.txt", .modified)]))

        // Only a letter raises one (CP-597); no element carries an AppKit tooltip.
        try rest(on: try letterField(fixture, "a.txt"), in: fixture)
        XCTAssertEqual(fixture.view.letterTooltip.shownText, "a.txt \u{2014} added")

        XCTAssertNil(fixture.view.toolTip)
        XCTAssertTrue(descendants(of: fixture.view).allSatisfy { $0.toolTip == nil })
    }

    // MARK: The letter's tooltip (CP-586 to CP-595)

    private func letterFields(_ fixture: Fixture) -> [NSTextField] {
        descendants(of: fixture.view).compactMap { $0 as? NSTextField }
            .filter { $0.identifier?.rawValue == "gitRowLetter" }
    }

    private func pathField(_ fixture: Fixture, _ path: String) throws -> NSTextField {
        try XCTUnwrap(
            descendants(of: fixture.view).compactMap { $0 as? NSTextField }
                .first { $0.identifier?.rawValue == "gitRowPath" && $0.stringValue == path },
            "no row prints \(path)")
    }

    /// The letter field of the row that prints `path`, found as the path field's sibling.
    private func letterField(_ fixture: Fixture, _ path: String, nth: Int = 0) throws -> NSTextField
    {
        let paths = descendants(of: fixture.view).compactMap { $0 as? NSTextField }
            .filter { $0.identifier?.rawValue == "gitRowPath" && $0.stringValue == path }
        let row = try unsafe XCTUnwrap(paths[nth].superview)
        return try XCTUnwrap(
            row.subviews.compactMap { $0 as? NSTextField }
                .first { $0.identifier?.rawValue == "gitRowLetter" })
    }

    private func centre(of view: NSView, in fixture: Fixture) -> NSPoint {
        fixture.view.convert(NSPoint(x: view.bounds.midX, y: view.bounds.midY), from: view)
    }

    private func rest(on view: NSView, in fixture: Fixture) throws {
        try rest(at: centre(of: view, in: fixture), in: fixture)
    }

    private func rest(at point: NSPoint, in fixture: Fixture) throws {
        let before = fixture.rest.requests.count
        try PointerDelivery.move(to: point, in: fixture.view)
        for index in before..<fixture.rest.requests.count { fixture.rest.fire(index) }
    }

    func test_restingOnEachRowsLetterShowsThatRowsText() throws {
        let fixture = makeView(
            showing: repository(
                staged: [entry("a.txt", .added)],
                changed: [entry("b.txt", .modified), entry("c.txt", .deleted)]))

        for (path, text) in [
            ("a.txt", "a.txt \u{2014} added"), ("b.txt", "b.txt \u{2014} modified"),
            ("c.txt", "c.txt \u{2014} deleted"),
        ] {
            try rest(on: try letterField(fixture, path), in: fixture)
            XCTAssertEqual(fixture.view.letterTooltip.shownText, text)
        }
    }

    func test_nothingButALetterRaisesIt() throws {
        let items: [(String, GitItem)] = [
            ("a merge", repository(state: .merge, changed: [entry("b.txt", .modified)])),
            (
                "lists",
                repository(staged: [entry("a.txt", .added)], changed: [entry("b.txt", .modified)])
            ),
            ("clean", repository()),
            ("pending", .pending),
            ("a failure", .failed(.condition(.notARepository))),
            ("stopped", .stopped),
        ]
        for (what, item) in items {
            let fixture = makeView(showing: item)
            // Every label that is not a letter, and every glyph.
            let targets = descendants(of: fixture.view).filter {
                !$0.isHiddenOrHasHiddenAncestor && !($0 is NSStackView) && !($0 is NSScroller)
                    && $0.identifier?.rawValue != "gitRowLetter"
                    && ($0 is NSTextField || $0 is NSImageView)
            }
            for target in targets {
                try rest(on: target, in: fixture)
                XCTAssertNil(fixture.view.letterTooltip.shownView, what)
            }
            // The space between a row's path and its letter.
            for field in letterFields(fixture) {
                let gap = NSPoint(
                    x: fixture.view.convert(
                        NSPoint(x: field.bounds.minX - 3, y: field.bounds.midY), from: field
                    ).x,
                    y: centre(of: field, in: fixture).y)
                try rest(at: gap, in: fixture)
                XCTAssertNil(fixture.view.letterTooltip.shownView, "\(what): the gap")
            }
        }
    }

    func test_aChangesRowGivesItsPrintedPathAndWord() throws {
        let fixture = makeView(showing: repository(changed: [entry("src/c.txt", .modified)]))

        try rest(on: try letterField(fixture, "src/c.txt"), in: fixture)

        XCTAssertEqual(fixture.view.letterTooltip.shownText, "src/c.txt \u{2014} modified")
    }

    func test_eachOfTheSixCategoriesGivesItsWord() throws {
        let words: [(String, GitStatusCategory, String)] = [
            ("a.txt", .added, "added"), ("m.txt", .modified, "modified"),
            ("d.txt", .deleted, "deleted"), ("r.txt", .renamed, "renamed"),
            ("u.txt", .untracked, "untracked"), ("c.txt", .inConflict, "conflict"),
        ]
        let fixture = makeView(showing: repository(changed: words.map { entry($0.0, $0.1) }))

        for (path, _, word) in words {
            try rest(on: try letterField(fixture, path), in: fixture)
            XCTAssertEqual(fixture.view.letterTooltip.shownText, "\(path) \u{2014} \(word)")
        }
    }

    func test_aNestedRepositoryRowGivesItsPrintedPathAndUntracked() throws {
        let fixture = makeView(showing: repository(changed: [entry("inner/", .untracked)]))

        try rest(on: try letterField(fixture, "inner/"), in: fixture)

        XCTAssertEqual(fixture.view.letterTooltip.shownText, "inner/ \u{2014} untracked")
    }

    func test_aPathUnderBothListsGivesADifferentWordOnEachRow() throws {
        let fixture = makeView(
            showing: repository(
                staged: [entry("a.txt", .added)], changed: [entry("a.txt", .modified)]))

        try rest(on: try letterField(fixture, "a.txt", nth: 0), in: fixture)
        XCTAssertEqual(fixture.view.letterTooltip.shownText, "a.txt \u{2014} added")
        try rest(on: try letterField(fixture, "a.txt", nth: 1), in: fixture)
        XCTAssertEqual(fixture.view.letterTooltip.shownText, "a.txt \u{2014} modified")
    }

    func test_clickingALetterWhileTheTooltipShowsRaisesRowActivatedOnce() throws {
        let fixture = makeView(showing: repository(changed: [entry("b.txt", .modified)]))
        let letter = try letterField(fixture, "b.txt")
        try rest(on: letter, in: fixture)
        XCTAssertNotNil(fixture.view.letterTooltip.shownView)

        try ClickDelivery.clickMiddle(of: letter)

        XCTAssertEqual(fixture.activated.paths, ["b.txt"])
    }

    func test_showAndAScrollEachRemoveAShownTooltip() throws {
        let entries = (0..<40).map { unsafe entry(String(format: "f%02d.txt", $0), .modified) }
        let fixture = makeView(showing: repository(changed: entries))
        let scroll = try XCTUnwrap(
            descendants(of: fixture.view).compactMap { $0 as? NSScrollView }.first)
        try rest(on: try letterField(fixture, "f00.txt"), in: fixture)
        XCTAssertNotNil(fixture.view.letterTooltip.shownView)

        scroll.contentView.scroll(to: NSPoint(x: 0, y: 60))
        XCTAssertNil(fixture.view.letterTooltip.shownView, "a scroll")

        scroll.contentView.scroll(to: .zero)
        try rest(on: try letterField(fixture, "f00.txt"), in: fixture)
        XCTAssertNotNil(fixture.view.letterTooltip.shownView)
        fixture.view.show(repository(changed: entries))
        XCTAssertNil(fixture.view.letterTooltip.shownView, "show(_:)")
    }

    /// CP-590 in the Git view itself, not only on a bare host: below the letter, its right edge on
    /// the letter's right edge, and over everything the view draws. Read in window coordinates, so
    /// the view's own nesting of scroll view, stack and row is what is proved.
    func test_inTheGitViewItSitsBelowTheLetterWithItsRightEdgeOnTheLetters() throws {
        let fixture = makeView(
            showing: repository(changed: [entry("b.txt", .modified), entry("c.txt", .deleted)]))
        let letter = try letterField(fixture, "b.txt")

        try rest(on: letter, in: fixture)

        let tooltip = try XCTUnwrap(fixture.view.letterTooltip.shownView)
        let letterFrame = letter.convert(letter.bounds, to: nil)
        let tooltipFrame = tooltip.convert(tooltip.bounds, to: nil)
        XCTAssertEqual(tooltipFrame.maxX, letterFrame.maxX, accuracy: 0.001)
        XCTAssertLessThanOrEqual(
            tooltipFrame.maxY, letterFrame.minY + 0.001, "wholly below the letter")
        XCTAssertTrue(fixture.view.subviews.last === tooltip, "over everything the view draws")
    }
}
