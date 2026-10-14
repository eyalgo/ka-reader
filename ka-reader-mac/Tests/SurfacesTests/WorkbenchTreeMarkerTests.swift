import AppKit
import XCTest

@testable import Surfaces

/// CP-573 to CP-581 through the workbench: the Git item the workbench receives for the Git view is
/// the one the tree's markers are drawn from, and nothing else marks a row. Every sentence and
/// letter is a string literal here and never read from `GitSentences`, except where a case is about
/// the letter `GitSentences.letter(for:)` gives.
@MainActor
final class WorkbenchTreeMarkerTests: XCTestCase {
    private struct SelectRead {
        let path: String
        let answer: SelectFileAnswer
    }

    @MainActor
    private final class Log {
        var selects: [SelectRead] = []
        var listed: [(path: String, answer: ListTreeAnswer)] = []
        var gitAsks: [GitAnswer] = []
    }

    @MainActor
    private struct Fixture {
        let workbench: WorkbenchView
        let window: NSWindow
        let log: Log

        var tree: RootItemsView { workbench.rootItemsView }
    }

    private func entry(_ name: String, _ kind: EntryKind, path: String? = nil) -> Entry {
        Entry(
            name: name, path: path ?? name, kind: kind,
            state: kind == .folder ? .pending : .observed)
    }

    /// A tree of `src`, `newdir`, `sub` and `inner` (folders) and `b.txt`, `d.txt`, `moved.txt` and
    /// `top.txt` (files), then `files` fillers, so a window as short as this one scrolls.
    private func makeFixture(files: Int = 0) -> Fixture {
        let glyph = NSImage(size: NSSize(width: 1, height: 1))
        let glyphs = StatusGlyphs(empty: glyph, failure: glyph)
        let tree = RootItemsView(
            folderGlyph: glyph, fileGlyph: glyph, fileCodeGlyph: glyph, statusGlyphs: glyphs)
        let filler = (0..<files).map { unsafe entry(String(format: "z%02d.txt", $0), .file) }
        tree.show(
            .observed(
                [
                    entry("src", .folder), entry("newdir", .folder), entry("sub", .folder),
                    entry("inner", .folder), entry("b.txt", .file), entry("d.txt", .file),
                    entry("moved.txt", .file), entry("top.txt", .file),
                ] + filler))
        let workbench = WorkbenchView(
            rootItemsView: tree, statusGlyphs: glyphs, railFolderGlyph: glyph,
            railGitGlyph: glyph)
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 800, height: 300), styleMask: [.borderless],
            backing: .buffered, defer: true)
        window.contentView = workbench
        let log = Log()
        workbench.selectFile = { path, answer in
            log.selects.append(SelectRead(path: path, answer: answer))
        }
        workbench.readGit = { answer in log.gitAsks.append(answer) }
        tree.listTree = { path, answer in log.listed.append((path, answer)) }
        workbench.layoutSubtreeIfNeeded()
        return Fixture(workbench: workbench, window: window, log: log)
    }

    // MARK: Helpers

    private func descendants(of view: NSView) -> [NSView] {
        view.subviews + view.subviews.flatMap { descendants(of: $0) }
    }

    private func strings(of view: NSView) -> [String] {
        view.layoutSubtreeIfNeeded()
        return descendants(of: view)
            .filter { !$0.isHiddenOrHasHiddenAncestor }
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

    private func repository(staged: [GitEntry] = [], changed: [GitEntry] = []) -> GitItem {
        .repository(
            GitRepository(branch: .named("main"), state: .normal, staged: staged, changed: changed))
    }

    private func gitEntry(_ path: String, _ category: GitStatusCategory) -> GitEntry {
        GitEntry(path: path, category: category)
    }

    /// The first example's answer: staged `d.txt` D and `moved.txt` R, changed `d.txt` U,
    /// `newdir/x.txt` U, `sub` M and `inner/` U.
    private var firstExample: GitItem {
        repository(
            staged: [gitEntry("d.txt", .deleted), gitEntry("moved.txt", .renamed)],
            changed: [
                gitEntry("d.txt", .untracked), gitEntry("newdir/x.txt", .untracked),
                gitEntry("sub", .modified), gitEntry("inner/", .untracked),
            ])
    }

    private func treeRow(_ path: String, in tree: RootItemsView) throws -> Int {
        try XCTUnwrap(
            (0..<tree.outlineView.numberOfRows).first { tree.entry(atRow: $0)?.path == path },
            "no row for \(path)")
    }

    private func treeCell(_ path: String, in tree: RootItemsView) throws -> NSTableCellView {
        let made = tree.outlineView.view(
            atColumn: 0, row: try treeRow(path, in: tree), makeIfNecessary: true)
        return try XCTUnwrap(made as? NSTableCellView)
    }

    /// The letter each drawn tree row shows, keyed by the row's path; a row with none is absent.
    private func letters(in tree: RootItemsView) throws -> [String: String] {
        var shown: [String: String] = [:]
        for index in 0..<tree.outlineView.numberOfRows {
            guard let path = tree.entry(atRow: index)?.path else { continue }
            let field = try treeCell(path, in: tree).subviews.compactMap { $0 as? NSTextField }
                .first { $0.identifier?.rawValue == "treeRowLetter" }
            if let field, !field.isHidden, !field.stringValue.isEmpty {
                shown[path] = field.stringValue
            }
        }
        return shown
    }

    private func expand(_ path: String, answering children: [Entry], in fixture: Fixture) throws {
        let tree = fixture.tree
        tree.outlineView.expandItem(tree.outlineView.item(atRow: try treeRow(path, in: tree)))
        fixture.log.listed.last(where: { $0.path == path })?.answer(.observed(children))
    }

    private func expandedPaths(_ tree: RootItemsView) -> [String] {
        (0..<tree.outlineView.numberOfRows).compactMap { row in
            tree.outlineView.isItemExpanded(tree.outlineView.item(atRow: row))
                ? tree.entry(atRow: row)?.path : nil
        }
    }

    private func selectInTree(_ path: String, in fixture: Fixture) throws {
        fixture.tree.outlineView.selectRowIndexes(
            IndexSet(integer: try treeRow(path, in: fixture.tree)), byExtendingSelection: false)
    }

    // MARK: Marked end to end

    func test_theListedRowsAreMarkedEndToEndAndNoOthers() throws {
        let fixture = makeFixture()
        choose(.git, in: fixture)
        fixture.log.gitAsks[0](firstExample)
        choose(.files, in: fixture)

        XCTAssertEqual(
            try letters(in: fixture.tree),
            ["d.txt": "U", "moved.txt": "R", "sub": "M", "inner": "U"],
            "exactly the listed rows, newdir and every other row unmarked")

        try expand(
            "newdir",
            answering: [
                entry("x.txt", .file, path: "newdir/x.txt"), entry("y", .folder, path: "newdir/y"),
            ], in: fixture)
        let afterExpanding = try letters(in: fixture.tree)
        XCTAssertEqual(afterExpanding["newdir/x.txt"], "U")
        XCTAssertNil(afterExpanding["newdir/y"])
        XCTAssertNil(afterExpanding["newdir"])
    }

    func test_eachMarkerReadsBackAsOneVisibleLetter() throws {
        let fixture = makeFixture()
        choose(.git, in: fixture)
        fixture.log.gitAsks[0](firstExample)
        choose(.files, in: fixture)

        let expected: [String: GitStatusCategory] = [
            "d.txt": .untracked, "moved.txt": .renamed, "sub": .modified, "inner": .untracked,
        ]
        let statusLetters: Set<String> = ["A", "U", "M", "D", "C", "R"]
        for (path, category) in expected {
            let visible = try treeCell(path, in: fixture.tree).subviews
                .compactMap { $0 as? NSTextField }
                .filter { !$0.isHidden && !$0.stringValue.isEmpty }.map(\.stringValue)
            XCTAssertEqual(
                visible.filter { statusLetters.contains($0) }, [GitSentences.letter(for: category)],
                path)
        }
        XCTAssertEqual(try letters(in: fixture.tree)["d.txt"], "U", "d.txt reads U and only U")

        choose(.git, in: fixture)
        XCTAssertEqual(
            strings(of: fixture.workbench.gitView),
            [
                "main", "Staged", "2", "d.txt", "D", "moved.txt", "R", "Changes", "4", "d.txt", "U",
                "inner/", "U", "newdir/x.txt", "U", "sub", "M",
            ], "the Git view still shows d.txt D under Staged and U under Changes")
    }

    // MARK: Never marked

    func test_noRowIsMarkedInAnyNonRepositoryState() throws {
        let outside = GitItem.failed(
            .gitDirectoryOutside(gitDirectory: "/elsewhere/.git/worktrees/wt"))
        let answers: [(String, GitItem?)] = [
            ("pending", .pending),
            ("git_directory_outside", outside),
            ("repository_read_failed", .failed(.condition(.repositoryReadFailed))),
            ("stopped", .stopped),
            ("no answer yet", nil),
        ]
        for (name, answer) in answers {
            let fixture = makeFixture()
            let baseline = strings(of: fixture.tree)
            choose(.git, in: fixture)
            if let answer { fixture.log.gitAsks[0](answer) }
            choose(.files, in: fixture)

            XCTAssertEqual(strings(of: fixture.tree), baseline, name)
            XCTAssertTrue(try letters(in: fixture.tree).isEmpty, name)
            if name == "git_directory_outside" {
                try selectInTree("b.txt", in: fixture)
                XCTAssertEqual(fixture.log.selects.map(\.path), ["b.txt"], name)
                XCTAssertEqual(strings(of: fixture.tree), baseline, name)
                fixture.log.selects[0].answer(.text("hello", .plain))
                XCTAssertEqual(fixture.workbench.readingPanel.pathLine.stringValue, "b.txt", name)
                XCTAssertEqual(fixture.workbench.readingPanel.contentView.string, "hello", name)
            }
        }

        // (i) A repository with changes, Git never shown: the answer is held ready, so any ask the
        // workbench made outside the Git view's first showing would mark the tree.
        let neverShown = makeFixture()
        let readyAnswer = firstExample
        neverShown.workbench.readGit = { [log = neverShown.log] answer in
            log.gitAsks.append(answer)
            answer(readyAnswer)
        }
        let baseline = strings(of: neverShown.tree)
        choose(.files, in: neverShown)
        try selectInTree("b.txt", in: neverShown)
        XCTAssertTrue(neverShown.log.gitAsks.isEmpty, "Git is never shown, so it is never asked")
        XCTAssertEqual(strings(of: neverShown.tree), baseline)
        XCTAssertTrue(try letters(in: neverShown.tree).isEmpty)
    }

    /// The tree takes the one answer the Git view keeps, behind the same latch, so the two cannot
    /// disagree whichever answer comes first.
    func test_onlyTheFirstAnswerReachesTheTree() throws {
        let plainFirst = makeFixture()
        choose(.git, in: plainFirst)
        plainFirst.log.gitAsks[0](.plain)
        plainFirst.log.gitAsks[0](firstExample)
        choose(.files, in: plainFirst)
        XCTAssertTrue(try letters(in: plainFirst.tree).isEmpty, "a later repository answer")

        let repositoryFirst = makeFixture()
        choose(.git, in: repositoryFirst)
        repositoryFirst.log.gitAsks[0](firstExample)
        repositoryFirst.log.gitAsks[0](.plain)
        choose(.files, in: repositoryFirst)
        XCTAssertEqual(
            try letters(in: repositoryFirst.tree),
            ["d.txt": "U", "moved.txt": "R", "sub": "M", "inner": "U"], "a later plain answer")
    }

    func test_aPlainAnswerMarksNoRow() throws {
        let fixture = makeFixture()
        let baseline = strings(of: fixture.tree)
        choose(.git, in: fixture)
        fixture.log.gitAsks[0](.plain)
        choose(.files, in: fixture)

        XCTAssertEqual(strings(of: fixture.tree), baseline)
        XCTAssertTrue(try letters(in: fixture.tree).isEmpty)
    }

    // MARK: What the answer leaves alone

    func test_anAnswerWhileFilesIsHiddenLeavesTheTreeAsLeftAndMarksIt() throws {
        let fixture = makeFixture(files: 40)
        let tree = fixture.tree
        try expand("src", answering: [entry("c.txt", .file, path: "src/c.txt")], in: fixture)
        try selectInTree("b.txt", in: fixture)
        tree.contentView.scroll(to: NSPoint(x: 0, y: 40))
        tree.reflectScrolledClipView(tree.contentView)
        let expandedBefore = expandedPaths(tree)
        let originBefore = tree.contentView.bounds.origin
        let selectedBefore = tree.outlineView.selectedRowIndexes
        let listedBefore = fixture.log.listed.count
        XCTAssertGreaterThan(originBefore.y, 0, "the fixture scrolls")

        choose(.git, in: fixture)
        fixture.log.gitAsks[0](
            repository(changed: [gitEntry("b.txt", .modified), gitEntry("src/c.txt", .modified)]))
        choose(.files, in: fixture)

        let marked = try letters(in: tree)
        XCTAssertEqual(marked["b.txt"], "M")
        XCTAssertEqual(marked["src/c.txt"], "M")
        XCTAssertEqual(expandedPaths(tree), expandedBefore)
        XCTAssertEqual(tree.contentView.bounds.origin, originBefore)
        XCTAssertEqual(tree.outlineView.selectedRowIndexes, selectedBefore)
        XCTAssertEqual(fixture.log.selects.map(\.path), ["b.txt"], "only the earlier selection")
        XCTAssertEqual(fixture.log.listed.count, listedBefore, "the answer read no folder")
    }

    func test_markingAddsNoSecondAsk() throws {
        let fixture = makeFixture()
        choose(.git, in: fixture)
        fixture.log.gitAsks[0](firstExample)
        let listedBefore = fixture.log.listed.count

        choose(.files, in: fixture)
        choose(.git, in: fixture)
        choose(.files, in: fixture)

        XCTAssertEqual(fixture.log.gitAsks.count, 1)
        XCTAssertEqual(fixture.log.listed.count, listedBefore, "no listTree follows the answer")
        XCTAssertEqual(try letters(in: fixture.tree)["d.txt"], "U", "and the marks stay")
    }
}
