import AppKit
import XCTest

@testable import Surfaces

/// The workbench as rail · sidebar · reading panel: the Files/Git switch, the Git view in the
/// sidebar, the one `readGit` ask, a Git row opening a file, and what a switch leaves alone
/// (CP-547 to CP-550, CP-562 to CP-565, CP-568). Every sentence is a string literal here and never
/// read from `GitSentences`.
@MainActor
final class WorkbenchGitTests: XCTestCase {
    private struct SelectRead {
        let path: String
        let answer: SelectFileAnswer
    }

    private struct GitAsk {
        let answer: GitAnswer
    }

    @MainActor
    private final class Log {
        var selects: [SelectRead] = []
        var listed: [(path: String, answer: ListTreeAnswer)] = []
        var gitAsks: [GitAsk] = []
    }

    private struct Fixture {
        let workbench: WorkbenchView
        let window: NSWindow
        let log: Log
    }

    private let pendingSentence = "Reading Git status."
    private let folderGlyph = NSImage(size: NSSize(width: 7, height: 7))
    private let gitGlyph = NSImage(size: NSSize(width: 8, height: 8))

    private func entry(_ name: String, _ kind: EntryKind, path: String? = nil) -> Entry {
        Entry(
            name: name, path: path ?? name, kind: kind,
            state: kind == .folder ? .pending : .observed)
    }

    private func makeFixture(files: Int = 0) -> Fixture {
        let glyph = NSImage(size: NSSize(width: 1, height: 1))
        let glyphs = StatusGlyphs(empty: glyph, failure: glyph)
        let tree = RootItemsView(
            folderGlyph: glyph, fileGlyph: glyph, fileCodeGlyph: glyph, statusGlyphs: glyphs)
        let filler = (0..<files).map { entry(String(format: "z%02d.txt", $0), .file) }
        tree.show(
            .observed(
                [
                    entry("src", .folder), entry("A.txt", .file), entry("a.txt", .file),
                    entry("b.txt", .file),
                ] + filler))
        let workbench = WorkbenchView(
            rootItemsView: tree, statusGlyphs: glyphs, railFolderGlyph: folderGlyph,
            railGitGlyph: gitGlyph)
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 800, height: 500), styleMask: [.borderless],
            backing: .buffered, defer: true)
        window.contentView = workbench
        let log = Log()
        workbench.selectFile = { path, answer in
            log.selects.append(SelectRead(path: path, answer: answer))
        }
        workbench.readGit = { answer in log.gitAsks.append(GitAsk(answer: answer)) }
        tree.listTree = { path, answer in log.listed.append((path, answer)) }
        workbench.layoutSubtreeIfNeeded()
        return Fixture(workbench: workbench, window: window, log: log)
    }

    // MARK: Helpers

    private func descendants(of view: NSView) -> [NSView] {
        view.subviews + view.subviews.flatMap { descendants(of: $0) }
    }

    private func shown(_ views: [NSView]) -> [NSView] {
        views.filter { !$0.isHiddenOrHasHiddenAncestor }
    }

    private func strings(of view: NSView) -> [String] {
        view.layoutSubtreeIfNeeded()
        return shown(descendants(of: view))
            .compactMap { $0 as? NSTextField }
            .filter { !$0.isEditable }
            .sorted {
                let (a, b) = ($0.convert($0.bounds, to: view), $1.convert($1.bounds, to: view))
                return abs(a.midY - b.midY) > 1 ? a.midY > b.midY : a.minX < b.minX
            }
            .map(\.stringValue)
    }

    private func choose(_ entry: RailEntry, in fixture: Fixture) {
        fixture.workbench.rail.entryChosen?(entry)
    }

    private func treeRow(_ name: String, in workbench: WorkbenchView) throws -> Int {
        let tree = workbench.rootItemsView
        return try XCTUnwrap(
            (0..<tree.outlineView.numberOfRows).first { tree.entry(atRow: $0)?.name == name },
            "no row named \(name)")
    }

    private func selectInTree(_ name: String, in workbench: WorkbenchView) throws {
        workbench.rootItemsView.outlineView.selectRowIndexes(
            IndexSet(integer: try treeRow(name, in: workbench)), byExtendingSelection: false)
    }

    private func expand(
        _ name: String, path: String, in fixture: Fixture, answering children: [Entry]
    )
        throws
    {
        let tree = fixture.workbench.rootItemsView
        tree.outlineView.expandItem(
            tree.outlineView.item(atRow: try treeRow(name, in: fixture.workbench)))
        fixture.log.listed.last(where: { $0.path == path })?.answer(.observed(children))
    }

    private func repository(
        staged: [GitEntry] = [], changed: [GitEntry] = [], state: RepositoryState = .normal
    ) -> GitItem {
        .repository(
            GitRepository(branch: .named("main"), state: state, staged: staged, changed: changed))
    }

    private func gitEntry(_ path: String, _ category: GitStatusCategory = .modified) -> GitEntry {
        GitEntry(path: path, category: category)
    }

    /// The Git view's rows, top to bottom.
    private func gitRows(_ workbench: WorkbenchView) -> [BarRowView] {
        workbench.layoutSubtreeIfNeeded()
        return shown(descendants(of: workbench.gitView)).compactMap { $0 as? BarRowView }
            .sorted {
                $0.convert($0.bounds, to: workbench.gitView).midY
                    > $1.convert($1.bounds, to: workbench.gitView).midY
            }
    }

    private func clickGitRow(_ index: Int, in fixture: Fixture) throws {
        let gitView = fixture.workbench.gitView
        let row = gitRows(fixture.workbench)[index]
        let frame = row.convert(row.bounds, to: gitView)
        let event = NSEvent.mouseEvent(
            with: .leftMouseDown,
            location: gitView.convert(NSPoint(x: frame.midX, y: frame.midY), to: nil),
            modifierFlags: [], timestamp: 0, windowNumber: fixture.window.windowNumber,
            context: nil, eventNumber: 0, clickCount: 1, pressure: 1)
        gitView.mouseDown(with: try XCTUnwrap(event, "no event"))
    }

    private func treeIsShown(_ workbench: WorkbenchView) -> Bool {
        !workbench.rootItemsView.isHiddenOrHasHiddenAncestor
    }

    private func gitIsShown(_ workbench: WorkbenchView) -> Bool {
        !workbench.gitView.isHiddenOrHasHiddenAncestor
    }

    private func expandedPaths(_ workbench: WorkbenchView) -> [String] {
        let tree = workbench.rootItemsView
        return (0..<tree.outlineView.numberOfRows).compactMap { row in
            tree.outlineView.isItemExpanded(tree.outlineView.item(atRow: row))
                ? tree.entry(atRow: row)?.path : nil
        }
    }

    // MARK: (a) and (b): the switch

    func test_filesIsActiveAtOpenAndTheTreeShows() {
        let fixture = makeFixture()

        XCTAssertEqual(fixture.workbench.rail.active, .files)
        XCTAssertTrue(treeIsShown(fixture.workbench))
        XCTAssertFalse(gitIsShown(fixture.workbench))
        XCTAssertTrue(fixture.log.gitAsks.isEmpty, "nothing is asked until Git is shown")
    }

    func test_gitGitFilesShowsTheViewThenNothingChangesThenTheTree() {
        let fixture = makeFixture()

        choose(.git, in: fixture)
        XCTAssertTrue(gitIsShown(fixture.workbench))
        XCTAssertFalse(treeIsShown(fixture.workbench))
        XCTAssertEqual(fixture.workbench.rail.active, .git)

        choose(.git, in: fixture)
        XCTAssertTrue(gitIsShown(fixture.workbench))
        XCTAssertFalse(treeIsShown(fixture.workbench))
        XCTAssertEqual(fixture.log.gitAsks.count, 1)

        choose(.files, in: fixture)
        XCTAssertTrue(treeIsShown(fixture.workbench))
        XCTAssertFalse(gitIsShown(fixture.workbench))
        XCTAssertEqual(fixture.workbench.rail.active, .files)
    }

    // MARK: (c): the one ask

    func test_showingGitBeforeAnyAnswerDrawsPendingAndRaisesReadGitOnce() {
        let fixture = makeFixture()

        choose(.git, in: fixture)
        XCTAssertEqual(fixture.log.gitAsks.count, 1)
        XCTAssertEqual(strings(of: fixture.workbench.gitView), [pendingSentence])

        fixture.log.gitAsks[0].answer(repository(changed: [gitEntry("b.txt")]))
        XCTAssertEqual(
            strings(of: fixture.workbench.gitView), ["main", "Changes", "1", "b.txt", "M"])

        choose(.files, in: fixture)
        choose(.git, in: fixture)
        XCTAssertEqual(fixture.log.gitAsks.count, 1, "a second switch to Git asks nothing")
        XCTAssertEqual(
            strings(of: fixture.workbench.gitView), ["main", "Changes", "1", "b.txt", "M"],
            "and draws the kept answer")
    }

    func test_aPendingAnswerIsDrawnAndNoSecondAskFollows() {
        let fixture = makeFixture()

        choose(.git, in: fixture)
        fixture.log.gitAsks[0].answer(.pending)
        XCTAssertEqual(strings(of: fixture.workbench.gitView), [pendingSentence])

        choose(.files, in: fixture)
        choose(.git, in: fixture)
        XCTAssertEqual(fixture.log.gitAsks.count, 1)
        XCTAssertEqual(strings(of: fixture.workbench.gitView), [pendingSentence])
    }

    func test_theSinkAnswersOnceAndTheFirstAnswerIsTheOneKept() {
        let fixture = makeFixture()
        choose(.git, in: fixture)

        fixture.log.gitAsks[0].answer(.plain)
        fixture.log.gitAsks[0].answer(repository(changed: [gitEntry("b.txt")]))

        XCTAssertTrue(strings(of: fixture.workbench.gitView).isEmpty)
    }

    func test_anAnswerArrivingAfterTheWorkbenchIsGoneDrawsNothingAndDoesNotCrash() {
        var fixture: Fixture? = makeFixture()
        let log = fixture?.log
        choose(.git, in: fixture!)
        fixture = nil

        log?.gitAsks[0].answer(.plain)

        XCTAssertEqual(log?.gitAsks.count, 1)
    }

    // MARK: (d): what a switch leaves alone

    func test_threeRoundTripsToGitAndBackLeaveThePanelAndTheTreeAsTheyWere() throws {
        let fixture = makeFixture(files: 60)
        let workbench = fixture.workbench
        let tree = workbench.rootItemsView
        try expand(
            "src", path: "src", in: fixture, answering: [entry("lib.rs", .file, path: "src/lib.rs")]
        )
        try selectInTree("a.txt", in: workbench)
        let text = (1...300).map { "line \($0)" }.joined(separator: "\n")
        fixture.log.selects[0].answer(.text(text, .plain))
        workbench.readingPanel.contentView.scrollToVisible(
            NSRect(x: 0, y: 3000, width: 10, height: 20))
        let panelScroll = try XCTUnwrap(workbench.readingPanel.contentView.enclosingScrollView)
        panelScroll.contentView.scroll(to: NSPoint(x: 0, y: 3000))
        panelScroll.reflectScrolledClipView(panelScroll.contentView)
        tree.contentView.scroll(to: NSPoint(x: 0, y: 60))
        tree.reflectScrolledClipView(tree.contentView)

        let before = (
            path: workbench.readingPanel.pathLine.stringValue,
            string: workbench.readingPanel.contentView.string,
            panelOffset: panelScroll.contentView.bounds.origin,
            expanded: expandedPaths(workbench), treeOffset: tree.contentView.bounds.origin,
            selected: tree.outlineView.selectedRowIndexes, bar: tree.barPaths()
        )
        XCTAssertGreaterThan(before.panelOffset.y, 0)
        XCTAssertGreaterThan(before.treeOffset.y, 0)

        for _ in 0..<3 {
            choose(.git, in: fixture)
            choose(.files, in: fixture)
        }

        XCTAssertEqual(workbench.readingPanel.pathLine.stringValue, before.path)
        XCTAssertEqual(workbench.readingPanel.contentView.string, before.string)
        XCTAssertEqual(panelScroll.contentView.bounds.origin, before.panelOffset)
        XCTAssertEqual(expandedPaths(workbench), before.expanded)
        XCTAssertEqual(tree.contentView.bounds.origin, before.treeOffset)
        XCTAssertEqual(tree.outlineView.selectedRowIndexes, before.selected)
        XCTAssertEqual(tree.barPaths(), before.bar)
        XCTAssertEqual(fixture.log.selects.map(\.path), ["a.txt"], "no switch read a file")
    }

    // MARK: (e): a Git row opens a file

    func test_aGitRowRaisesSelectFileAndTheViewStaysShowingWithTheRowSelected() throws {
        let fixture = makeFixture()
        choose(.git, in: fixture)
        fixture.log.gitAsks[0].answer(
            repository(changed: [gitEntry("b.txt"), gitEntry("c.txt", .untracked)]))

        try clickGitRow(0, in: fixture)

        XCTAssertEqual(fixture.log.selects.map(\.path), ["b.txt"])
        XCTAssertEqual(strings(of: fixture.workbench.readingPanel), ["Reading this file."])
        XCTAssertTrue(gitIsShown(fixture.workbench))
        XCTAssertEqual(fixture.workbench.gitView.barPaths(), ["b.txt"])
        XCTAssertEqual(fixture.log.selects.count, 1, "the tree raised nothing of its own")

        fixture.log.selects[0].answer(.text("hello", .plain))
        XCTAssertEqual(fixture.workbench.readingPanel.contentView.string, "hello")
        XCTAssertEqual(fixture.workbench.readingPanel.pathLine.stringValue, "b.txt")
    }

    func test_aDeletedRowDrawsThePanelsMissingFileStatementAsATreeSelectionDoes() throws {
        let viaTree = makeFixture()
        try selectInTree("A.txt", in: viaTree.workbench)
        viaTree.log.selects[0].answer(.failed(.missing))
        let treeStrings = strings(of: viaTree.workbench.readingPanel)

        let fixture = makeFixture()
        choose(.git, in: fixture)
        fixture.log.gitAsks[0].answer(repository(changed: [gitEntry("A.txt", .deleted)]))
        try clickGitRow(0, in: fixture)
        XCTAssertEqual(fixture.log.selects.map(\.path), ["A.txt"])
        fixture.log.selects[0].answer(.failed(.missing))

        XCTAssertGreaterThan(treeStrings.count, 1)
        XCTAssertEqual(strings(of: fixture.workbench.readingPanel), treeStrings)
        XCTAssertEqual(fixture.workbench.readingPanel.pathLine.stringValue, "A.txt")
    }

    func test_theLatestSelectionAcrossBothListsWins() throws {
        let fixture = makeFixture()
        choose(.git, in: fixture)
        fixture.log.gitAsks[0].answer(
            repository(changed: [gitEntry("b.txt"), gitEntry("c.txt")]))
        try clickGitRow(0, in: fixture)
        try clickGitRow(1, in: fixture)
        XCTAssertEqual(fixture.log.selects.map(\.path), ["b.txt", "c.txt"])

        fixture.log.selects[1].answer(.text("from c", .plain))
        fixture.log.selects[0].answer(.text("from b", .plain))

        XCTAssertEqual(fixture.workbench.readingPanel.contentView.string, "from c")
        XCTAssertEqual(fixture.workbench.gitView.barPaths(), ["c.txt"])
    }

    func test_aNilReadDrawsTheStoppedStatementForAGitRowsPathAndKeepsItsBar() throws {
        let fixture = makeFixture()
        choose(.git, in: fixture)
        fixture.log.gitAsks[0].answer(repository(changed: [gitEntry("b.txt")]))
        try clickGitRow(0, in: fixture)

        fixture.log.selects[0].answer(nil)

        XCTAssertEqual(fixture.workbench.readingPanel.pathLine.stringValue, "b.txt")
        XCTAssertEqual(fixture.workbench.gitView.barPaths(), ["b.txt"])
        XCTAssertTrue(gitIsShown(fixture.workbench))
    }

    // MARK: (f): the tree after a Git row

    func test_aGitRowClickWithCollapsedFoldersLeavesNoTreeRowSelectedAndExpandsNothing() throws {
        let fixture = makeFixture()
        let tree = fixture.workbench.rootItemsView
        try selectInTree("a.txt", in: fixture.workbench)
        let expandedBefore = expandedPaths(fixture.workbench)
        choose(.git, in: fixture)
        fixture.log.gitAsks[0].answer(repository(changed: [gitEntry("src/deep/x.txt")]))

        try clickGitRow(0, in: fixture)
        choose(.files, in: fixture)

        XCTAssertTrue(tree.outlineView.selectedRowIndexes.isEmpty, "no tree row is selected")
        XCTAssertFalse(tree.barPaths().contains("a.txt"), "a.txt is not the open file")
        XCTAssertEqual(expandedPaths(fixture.workbench), expandedBefore)
        XCTAssertTrue(fixture.log.listed.isEmpty, "no folder was read")
        XCTAssertEqual(
            fixture.log.selects.map(\.path), ["a.txt", "src/deep/x.txt"],
            "the tree's own selection, then the Git row's file; the switch to Files read none")
    }

    func test_theSameWithTheFolderExpandedSelectsTheRowAndRaisesNoFileSelected() throws {
        let fixture = makeFixture()
        let tree = fixture.workbench.rootItemsView
        try expand(
            "src", path: "src", in: fixture,
            answering: [entry("deep", .folder, path: "src/deep")])
        try expand(
            "deep", path: "src/deep", in: fixture,
            answering: [entry("x.txt", .file, path: "src/deep/x.txt")])
        choose(.git, in: fixture)
        fixture.log.gitAsks[0].answer(repository(changed: [gitEntry("src/deep/x.txt")]))

        try clickGitRow(0, in: fixture)
        choose(.files, in: fixture)

        let row = try XCTUnwrap(
            (0..<tree.outlineView.numberOfRows).first {
                tree.entry(atRow: $0)?.path == "src/deep/x.txt"
            })
        XCTAssertEqual(tree.outlineView.selectedRowIndexes, IndexSet(integer: row))
        XCTAssertEqual(tree.barPaths(), ["src/deep/x.txt"])
        XCTAssertEqual(
            fixture.log.selects.map(\.path), ["src/deep/x.txt"],
            "the file was read once, by the Git row, and the tree's selection raised no second read"
        )
    }

    // MARK: (g) to (i): what shows, and what does not

    func test_everyFailureIsShownAndTheTreeStillSelectsThroughFiles() throws {
        let failures: [GitItem] =
            [.failed(.gitDirectoryOutside(gitDirectory: "/elsewhere/.git/worktrees/wt")), .stopped]
            + GitCondition.allCases.map { .failed(.condition($0)) }

        for failure in failures {
            let fixture = makeFixture()
            choose(.git, in: fixture)
            fixture.log.gitAsks[0].answer(failure)

            XCTAssertEqual(strings(of: fixture.workbench.gitView).count, 1, "\(failure)")
            XCTAssertTrue(gitRows(fixture.workbench).isEmpty, "\(failure)")
            XCTAssertEqual(strings(of: fixture.workbench.rail), ["Files", "Git"], "\(failure)")

            choose(.files, in: fixture)
            XCTAssertTrue(treeIsShown(fixture.workbench), "\(failure)")
            try selectInTree("a.txt", in: fixture.workbench)
            XCTAssertEqual(fixture.log.selects.map(\.path), ["a.txt"], "\(failure)")
            fixture.log.selects[0].answer(.text("read", .plain))
            XCTAssertEqual(fixture.workbench.readingPanel.contentView.string, "read", "\(failure)")
        }
    }

    func test_aRepositoryAnswerWithChangesPutsNoLetterOnAnyTreeRow() throws {
        let fixture = makeFixture()
        choose(.git, in: fixture)
        fixture.log.gitAsks[0].answer(
            repository(
                staged: [gitEntry("a.txt", .added)],
                changed: [gitEntry("b.txt"), gitEntry("A.txt", .deleted)]))
        choose(.files, in: fixture)

        let tree = fixture.workbench.rootItemsView
        let drawn = strings(of: tree)
        XCTAssertEqual(Set(drawn), ["src", "A.txt", "a.txt", "b.txt"])
        XCTAssertEqual(drawn.count, 4)
        for letter in ["A", "U", "M", "D", "C", "R"] {
            XCTAssertFalse(drawn.contains(letter), letter)
        }
    }

    func test_aPlainAnswerLeavesNoGitWordOutsideTheViewExceptTheSwitchLabel() {
        let fixture = makeFixture()
        choose(.git, in: fixture)
        fixture.log.gitAsks[0].answer(.plain)

        let outside = shown(descendants(of: fixture.workbench))
            .filter { view in
                !(view === fixture.workbench.gitView
                    || descendants(of: fixture.workbench.gitView).contains { $0 === view })
            }
            .compactMap { $0 as? NSTextField }
            .map(\.stringValue)

        XCTAssertTrue(outside.contains("Git"), "the switch's own label")
        for text in outside where text != "Git" {
            XCTAssertFalse(text.localizedCaseInsensitiveContains("git"), text)
            XCTAssertFalse(text.localizedCaseInsensitiveContains("repository"), text)
        }
        XCTAssertTrue(strings(of: fixture.workbench.gitView).isEmpty)
    }

    // MARK: Composition

    func test_theRailIsTheLeadingSubviewAndTheHairlineFollowsTheSidebarsTrailingEdge() throws {
        let fixture = makeFixture()
        let workbench = fixture.workbench
        workbench.frame = NSRect(x: 0, y: 0, width: 800, height: 500)
        workbench.layoutSubtreeIfNeeded()

        XCTAssertEqual(workbench.subviews.count, 3)
        XCTAssertTrue(workbench.subviews[0] === workbench.rail, "the rail is first")
        XCTAssertTrue(workbench.subviews[1] === workbench.sidebar, "then the sidebar")
        XCTAssertTrue(workbench.subviews[2] === workbench.readingPanel, "then the reading panel")
        XCTAssertEqual(workbench.rail.frame.minX, 0, accuracy: 0.5)
        XCTAssertEqual(workbench.rail.frame.width, 48, accuracy: 0.5)
        XCTAssertEqual(workbench.sidebar.frame.minX, workbench.rail.frame.maxX, accuracy: 0.5)
        XCTAssertEqual(workbench.sidebar.frame.width, 260, accuracy: 0.5)
        XCTAssertTrue(workbench.rootItemsView.superview === workbench.sidebar)
        XCTAssertTrue(workbench.gitView.superview === workbench.sidebar)
        XCTAssertEqual(
            workbench.readingPanel.frame.minX, workbench.sidebar.frame.maxX + 1, accuracy: 0.5)

        let bitmap = try XCTUnwrap(workbench.bitmapImageRepForCachingDisplay(in: workbench.bounds))
        workbench.cacheDisplay(in: workbench.bounds, to: bitmap)
        let scale = CGFloat(bitmap.pixelsWide) / workbench.bounds.width
        let column = Int((workbench.sidebar.frame.maxX + 0.5) * scale)
        let row = Int(CGFloat(bitmap.pixelsHigh) / 2)
        let alpha = try XCTUnwrap(bitmap.colorAt(x: column, y: row)).alphaComponent
        XCTAssertGreaterThan(alpha, 0, "the hairline is drawn in the gap after the sidebar")
        let stale = Int((workbench.rootItemsView.frame.maxX + 0.5) * scale)
        XCTAssertNotEqual(stale, column, "the fixture tells the sidebar's edge from the tree's")
    }

    func test_aTreeSelectionClearsTheGitRowSelection() throws {
        let fixture = makeFixture()
        choose(.git, in: fixture)
        fixture.log.gitAsks[0].answer(repository(changed: [gitEntry("b.txt")]))
        try clickGitRow(0, in: fixture)
        XCTAssertEqual(fixture.workbench.gitView.barPaths(), ["b.txt"])

        choose(.files, in: fixture)
        try selectInTree("a.txt", in: fixture.workbench)

        XCTAssertEqual(fixture.workbench.gitView.barPaths(), [])
        choose(.git, in: fixture)
        XCTAssertEqual(fixture.workbench.gitView.barPaths(), [])
        XCTAssertEqual(fixture.workbench.rootItemsView.barPaths(), ["a.txt"])
    }
}
