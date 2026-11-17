import AppKit
import Testing

import Surfaces

/// Layer 4: the tree's names stay whole when its listing changes. The real workbench holds the
/// real tree in an 800 × 500 window, and no case calls `tile()` itself, because `tile()` is the
/// one sizing seam the base tree has and a direct call would hide the defect these cases guard.
@MainActor
struct RootItemsViewNamesTests {
    private var glyph: NSImage { NSImage(size: NSSize(width: 3, height: 3)) }
    private var glyphs: StatusGlyphs { StatusGlyphs(empty: glyph, failure: glyph) }
    /// The folder image this file's trees are given, kept so a row can be checked for it: a folder
    /// row draws it and a file row does not.
    private let folderGlyph = NSImage(size: NSSize(width: 3, height: 3))

    private func entry(_ name: String, _ kind: EntryKind) -> Entry {
        Entry(name: name, path: name, kind: kind, state: .observed)
    }

    /// An entry at `path`, named by the path's last component.
    private func entry(path: String, _ kind: EntryKind) -> Entry {
        Entry(
            name: String(path.split(separator: "/").last ?? ""), path: path, kind: kind,
            state: .observed)
    }

    private func tree() -> RootItemsView {
        RootItemsView(
            folderGlyph: folderGlyph, fileGlyph: glyph, fileCodeGlyph: glyph, statusGlyphs: glyphs,
            tooltipRest: TooltipRestDouble().rest, keyWindow: KeyWindowDouble().source)
    }

    private func workbench(_ root: RootItemsView) -> WorkbenchView {
        WorkbenchView(
            rootItemsView: root, statusGlyphs: glyphs, railFolderGlyph: glyph,
            railGitGlyph: glyph, keyWindow: KeyWindowDouble().source)
    }

    private func host(_ view: NSView) -> NSWindow {
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 800, height: 500), styleMask: [.borderless],
            backing: .buffered, defer: true)
        window.contentView = view
        view.layoutSubtreeIfNeeded()
        return window
    }

    private func fields(_ view: NSView) -> [NSTextField] {
        view.subviews.flatMap { child in
            (child as? NSTextField).map { [$0] } ?? fields(child)
        }.filter { !$0.isHiddenOrHasHiddenAncestor }
    }

    /// Every entry row's cell, top to bottom, laid out as a running window lays it out.
    private func entryCells(_ root: RootItemsView) -> [(entry: Entry, cell: NSTableCellView)] {
        root.layoutSubtreeIfNeeded()
        return (0..<root.outlineView.numberOfRows).compactMap { index in
            guard let shown = root.entry(atRow: index),
                let cell = root.outlineView.view(atColumn: 0, row: index, makeIfNecessary: true)
                    as? NSTableCellView
            else { return nil }
            return (shown, cell)
        }
    }

    /// The names the tree draws, each asserted whole: its glyph is set, and is the folder's exactly
    /// for a folder row, its label reads the entry's name, the label is at least as wide as its text,
    /// and it lies inside the clip's visible rect.
    @discardableResult
    private func expectNamesWhole(_ root: RootItemsView) -> [String] {
        root.layoutSubtreeIfNeeded()
        let visible = root.contentView.bounds
        var names: [String] = []
        for (shown, cell) in entryCells(root) {
            let glyphImage = unsafe cell.imageView?.image
            #expect(glyphImage != nil)
            #expect((glyphImage === folderGlyph) == (shown.kind == .folder))
            guard let label = unsafe cell.textField else {
                Issue.record("a row of \(shown.name) has no name label")
                continue
            }
            #expect(label.stringValue == shown.name)
            #expect(label.bounds.width >= label.intrinsicContentSize.width)
            let inClip = root.contentView.convert(label.bounds, from: label)
            #expect(visible.contains(inClip))
            names.append(label.stringValue)
        }
        return names
    }

    private func letters(_ root: RootItemsView) -> [NSTextField] {
        entryCells(root).flatMap { pair -> [NSTextField] in
            let name = unsafe pair.cell.textField
            return pair.cell.subviews.compactMap { $0 as? NSTextField }.filter {
                $0 !== name && !$0.isHidden
            }
        }
    }

    @Test func aRepositoryAppearingAtThePlainRootKeepsEveryNameWholeWithNoSidebarSwitch() {
        let root = tree()
        root.show(
            .observed([
                entry("docs", .folder), entry("notes", .folder), entry("src", .folder),
                entry("README.md", .file),
            ]))
        let view = workbench(root)
        let window = host(view)
        view.readGit = { $0(.plain) }
        let appeared = [
            entry(".git", .folder), entry("docs", .folder), entry("notes", .folder),
            entry("src", .folder), entry("README.md", .file),
        ]
        root.apply(changes: [(path: "", listing: .observed(appeared))])
        let expected = appeared.map(\.name)
        #expect(expectNamesWhole(root) == expected)
        #expect(root.entry(atRow: 0)?.kind == .folder)
        #expect(root.outlineView.isExpandable(root.outlineView.item(atRow: 0)))
        #expect(letters(root).isEmpty)
        // No statement at the tree's head, and no root message: nothing stands outside the rows.
        #expect(standingFields(root).isEmpty)

        view.rail.entryChosen?(.git)
        #expect(fields(view.gitView).isEmpty)
        view.rail.entryChosen?(.files)
        #expect(expectNamesWhole(root) == expected)
        withExtendedLifetime(window) {}
    }

    /// A state the tree is opened in, one change applied to it, and what must hold after.
    private enum Scenario: CaseIterable, CustomTestStringConvertible {
        case rootGainsAFileInARepository
        case rootLosesItsGitFolder
        case changeBeneathAnExpandedFolder
        case changeTwoLevelsDeep
        case failedFolderListingClears
        case failedGitItemThenRootChange
        case gitFilesChangeGitFiles
        case changeArrivesWhileGitShowsInARepository

        var testDescription: String { String(describing: self) }
    }

    /// What a scenario's open state and change read: the Git item answered, the listings the
    /// expansions are answered with, the folders the reader expands (in order) and the one change.
    /// `markedAtOpen` names the rows that show a letter or a sentence beside their name at open, so
    /// the check that they keep it after the change cannot pass on a row that never showed one.
    private struct Plan {
        var git: GitItem = .plain
        var root: [Entry]
        var listings: [String: RootListing] = [:]
        var expands: [String] = []
        var change: (path: String, listing: RootListing)
        var shown: [String]
        var lettersClear = false
        var markedAtOpen: [String] = []
        var changeArrivesWhileGitShows = false

        /// A folder read as a repository, or one whose Git read observed a condition, shows the
        /// statement once at the tree's head and something on the Git view; a plain one shows
        /// neither (CP-1346, CP-1347).
        var showsGitAtOpen: Bool {
            if case .plain = git { return false }
            return true
        }
    }

    private func plan(for scenario: Scenario) -> Plan {
        let repository = GitItem.repository(
            GitRepository(
                branch: .named("main"), state: .normal, staged: [],
                changed: [GitEntry(path: "README.md", category: .modified)]))
        let readme = entry("README.md", .file)
        switch scenario {
        case .rootGainsAFileInARepository, .changeArrivesWhileGitShowsInARepository:
            let added = [readme, entry("NOTES.md", .file)]
            return Plan(
                git: repository, root: [readme], change: ("", .observed(added)),
                shown: added.map(\.name), markedAtOpen: ["README.md"],
                changeArrivesWhileGitShows: scenario == .changeArrivesWhileGitShowsInARepository)
        case .gitFilesChangeGitFiles:
            // E13: between Files and the second Git a tracked file is changed, so the root's
            // listing arrives again with the same entries.
            return Plan(
                git: repository, root: [readme], change: ("", .observed([readme])),
                shown: [readme.name], markedAtOpen: ["README.md"])
        case .rootLosesItsGitFolder:
            let kept = [entry("docs", .folder), readme]
            return Plan(
                git: repository, root: [entry(".git", .folder)] + kept,
                change: ("", .observed(kept)), shown: kept.map(\.name), markedAtOpen: ["README.md"])
        case .changeBeneathAnExpandedFolder:
            let docs = entry("docs", .folder)
            let added = [entry(path: "docs/a.md", .file), entry(path: "docs/b.md", .file)]
            return Plan(
                root: [docs, readme],
                listings: ["docs": .observed([added[0]])], expands: ["docs"],
                change: ("docs", .observed(added)), shown: ["docs", "a.md", "b.md", "README.md"])
        case .changeTwoLevelsDeep:
            let src = entry("src", .folder)
            let lib = entry(path: "src/lib", .folder)
            let first = entry(path: "src/lib/x.swift", .file)
            let second = entry(path: "src/lib/y.swift", .file)
            return Plan(
                root: [src],
                listings: ["src": .observed([lib]), "src/lib": .observed([first])],
                expands: ["src", "src/lib"],
                change: ("src/lib", .observed([first, second])),
                shown: ["src", "lib", "x.swift", "y.swift"])
        case .failedFolderListingClears:
            let docs = entry("docs", .folder)
            let child = entry(path: "docs/a.md", .file)
            return Plan(
                root: [docs], listings: ["docs": .failed(.unreadable)], expands: ["docs"],
                change: ("docs", .observed([child])), shown: ["docs", "a.md"],
                lettersClear: true, markedAtOpen: ["docs"])
        case .failedGitItemThenRootChange:
            let added = [readme, entry("NOTES.md", .file)]
            return Plan(
                git: .failed(.condition(.gitDirectoryMissing)), root: [readme],
                change: ("", .observed(added)), shown: added.map(\.name))
        }
    }

    /// The visible fields of the tree that are not inside its rows: the notice and the root message.
    private func standingFields(_ root: RootItemsView) -> [String] {
        fields(root).filter { !$0.isDescendant(of: root.outlineView) }.map(\.stringValue)
    }

    /// The letter each drawn row shows, by name: nothing for a row with none.
    private func lettersByName(_ root: RootItemsView) -> [String: String] {
        var shown: [String: String] = [:]
        for (entry, cell) in entryCells(root) {
            let name = unsafe cell.textField
            let letter = cell.subviews.compactMap { $0 as? NSTextField }
                .first { $0 !== name && !$0.isHidden }
            shown[entry.name] = letter?.stringValue ?? ""
        }
        return shown
    }

    @Test(arguments: Scenario.allCases)
    private func namesStayWholeThroughEveryListingChangeTheTreeDraws(_ scenario: Scenario) {
        let plan = plan(for: scenario)
        let root = tree()
        root.show(.observed(plan.root))
        root.listTree = { path, act, answer in
            if act == .expand { answer(plan.listings[path]) }
        }
        let view = workbench(root)
        let window = host(view)
        view.readGit = { $0(plan.git) }
        for path in plan.expands {
            let row = (0..<root.outlineView.numberOfRows).first { root.entry(atRow: $0)?.path == path }
            if let row { root.outlineView.expandItem(root.outlineView.item(atRow: row)) }
        }
        // Open: the Git view is asked once, and what both surfaces show is what must stay.
        view.rail.entryChosen?(.git)
        let openGitFields = fields(view.gitView).map(\.stringValue)
        view.rail.entryChosen?(.files)
        expectNamesWhole(root)
        let openLetters = lettersByName(root)
        let openStanding = standingFields(root)
        for name in plan.markedAtOpen { #expect(openLetters[name]?.isEmpty == false) }
        #expect(openStanding.count == (plan.showsGitAtOpen ? 1 : 0))
        #expect(openGitFields.isEmpty == !plan.showsGitAtOpen)

        if plan.changeArrivesWhileGitShows { view.rail.entryChosen?(.git) }
        root.apply(changes: [plan.change])
        if plan.changeArrivesWhileGitShows { view.rail.entryChosen?(.files) }
        #expect(expectNamesWhole(root) == plan.shown)
        if plan.lettersClear {
            #expect(lettersByName(root).values.allSatisfy { $0.isEmpty })
        } else {
            let after = lettersByName(root)
            for (name, letter) in openLetters { #expect(after[name].map { $0 == letter } ?? true) }
        }
        #expect(standingFields(root) == openStanding)

        view.rail.entryChosen?(.git)
        #expect(fields(view.gitView).map(\.stringValue) == openGitFields)
        view.rail.entryChosen?(.files)
        #expect(expectNamesWhole(root) == plan.shown)
        withExtendedLifetime(window) {}
    }

    @Test func aRootChangeKeepsTheReadersPlaceAndEveryNameWhole() throws {
        let root = tree()
        let src = entry("src", .folder)
        let notes = entry("notes", .folder)
        let readme = entry("README.md", .file)
        root.show(.observed([src, notes, readme]))
        let listings: [String: RootListing] = [
            "src": .observed([entry(path: "src/a.swift", .file)]),
            "notes": .observed([entry(path: "notes/n.md", .file)]),
        ]
        root.listTree = { path, act, answer in
            if act == .expand { answer(listings[path]) }
        }
        let view = workbench(root)
        let window = host(view)
        view.readGit = { $0(.plain) }
        let outline = root.outlineView
        func item(_ path: String) throws -> Any {
            let row = try #require(
                (0..<outline.numberOfRows).first { root.entry(atRow: $0)?.path == path })
            return try #require(outline.item(atRow: row))
        }
        outline.expandItem(try item("src"))
        outline.expandItem(try item("notes"))
        outline.collapseItem(try item("notes"))
        root.markOpenFile(path: "README.md")
        root.showOpenFile(path: "README.md")

        root.apply(changes: [
            (path: "", listing: .observed([src, notes, readme, entry("NEW.md", .file)]))
        ])
        #expect(outline.isItemExpanded(try item("src")))
        #expect(!outline.isItemExpanded(try item("notes")))
        #expect(root.selectionFillPaths() == ["README.md"])
        #expect(view.rail.active == .files)
        #expect(
            expectNamesWhole(root) == ["src", "a.swift", "notes", "README.md", "NEW.md"])
        withExtendedLifetime(window) {}
    }
}
