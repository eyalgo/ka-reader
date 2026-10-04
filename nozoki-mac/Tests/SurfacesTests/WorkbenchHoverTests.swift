import AppKit
import XCTest

@testable import Surfaces

/// The hover fill in the composed workbench: confined to the tree and the Git view (CP-611), gone
/// from a surface the rail switches away from (CP-602), and acting on nothing (CP-608).
@MainActor
final class WorkbenchHoverTests: XCTestCase {
    private struct Fixture {
        let workbench: WorkbenchView
        let window: NSWindow
        let log: Log
    }

    @MainActor
    private final class Log {
        var selects: [String] = []
        var listed: [String] = []
        var gitAsks: [GitAnswer] = []
    }

    private func makeFixture() -> Fixture {
        let glyph = NSImage(size: NSSize(width: 1, height: 1))
        let glyphs = StatusGlyphs(empty: glyph, failure: glyph)
        let tree = RootItemsView(
            folderGlyph: glyph, fileGlyph: glyph, fileCodeGlyph: glyph, statusGlyphs: glyphs)
        tree.show(
            .observed([
                Entry(name: "src", path: "src", kind: .folder, state: .pending),
                Entry(name: "a.txt", path: "a.txt", kind: .file, state: .observed),
                Entry(name: "b.txt", path: "b.txt", kind: .file, state: .observed),
            ]))
        let workbench = WorkbenchView(
            rootItemsView: tree, statusGlyphs: glyphs, railFolderGlyph: glyph, railGitGlyph: glyph)
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 800, height: 500), styleMask: [.borderless],
            backing: .buffered, defer: true)
        window.contentView = workbench
        let log = Log()
        workbench.selectFile = { path, _ in log.selects.append(path) }
        workbench.readGit = { answer in log.gitAsks.append(answer) }
        tree.listTree = { path, _ in log.listed.append(path) }
        workbench.layoutSubtreeIfNeeded()
        return Fixture(workbench: workbench, window: window, log: log)
    }

    private func descendants(of view: NSView) -> [NSView] {
        view.subviews + view.subviews.flatMap { descendants(of: $0) }
    }

    private func choose(_ entry: RailEntry, in fixture: Fixture) {
        fixture.workbench.rail.entryChosen?(entry)
    }

    private func showGit(in fixture: Fixture) {
        choose(.git, in: fixture)
        fixture.log.gitAsks[0](
            .repository(
                GitRepository(
                    branch: .named("main"), state: .normal, staged: [],
                    changed: [
                        GitEntry(path: "a.txt", category: .modified),
                        GitEntry(path: "b.txt", category: .modified),
                    ])))
        fixture.workbench.layoutSubtreeIfNeeded()
    }

    private func treePoint(ofRow index: Int, in fixture: Fixture) -> NSPoint {
        let tree = fixture.workbench.rootItemsView
        let rect = tree.outlineView.rect(ofRow: index)
        return tree.convert(NSPoint(x: rect.minX + 40, y: rect.midY), from: tree.outlineView)
    }

    private func gitPoint(ofRow index: Int, in fixture: Fixture) throws -> NSPoint {
        let git = fixture.workbench.gitView
        let rows = descendants(of: git).compactMap { $0 as? BarRowView }
            .sorted { $0.convert($0.bounds, to: git).midY > $1.convert($1.bounds, to: git).midY }
        let frame = rows[index].convert(rows[index].bounds, to: git)
        return NSPoint(x: frame.minX + 40, y: frame.midY)
    }

    func test_hover_only_tree_and_git_view_carry_a_hover_tracking_area() throws {
        let fixture = makeFixture()
        showGit(in: fixture)
        let glyph = NSImage(size: NSSize(width: 1, height: 1))
        let startup = StartupView(
            projection: .empty, glyphs: StatusGlyphs(empty: glyph, failure: glyph),
            onIntent: { _ in })
        startup.layoutSubtreeIfNeeded()

        let hosts = ([fixture.workbench] + descendants(of: fixture.workbench)).filter {
            $0.trackingAreas.contains { $0.owner is RowHover }
        }

        XCTAssertEqual(hosts.count, 2)
        XCTAssertTrue(hosts.contains { $0 === fixture.workbench.rootItemsView }, "the tree")
        XCTAssertTrue(hosts.contains { $0 === fixture.workbench.gitView }, "the Git view")
        XCTAssertFalse(
            ([startup] + descendants(of: startup)).contains {
                $0.trackingAreas.contains { $0.owner is RowHover }
            }, "the startup view")
    }

    func test_hover_rail_switch_leaves_no_tree_row_filled() throws {
        let fixture = makeFixture()
        let tree = fixture.workbench.rootItemsView
        try PointerDelivery.move(to: treePoint(ofRow: 2, in: fixture), in: tree)
        XCTAssertEqual(tree.hoverPaths(), ["b.txt"])

        choose(.git, in: fixture)
        choose(.files, in: fixture)

        XCTAssertEqual(tree.hoverPaths(), [])
    }

    func test_hover_moving_resting_and_leaving_acts_on_nothing() throws {
        let fixture = makeFixture()
        let tree = fixture.workbench.rootItemsView
        for index in [0, 1, 2] {
            try PointerDelivery.enter(at: treePoint(ofRow: index, in: fixture), in: tree)
            try PointerDelivery.move(to: treePoint(ofRow: index, in: fixture), in: tree)
        }
        try PointerDelivery.leave(at: treePoint(ofRow: 2, in: fixture), in: tree)

        showGit(in: fixture)
        let git = fixture.workbench.gitView
        for index in [0, 1] {
            try PointerDelivery.enter(at: gitPoint(ofRow: index, in: fixture), in: git)
            try PointerDelivery.move(to: gitPoint(ofRow: index, in: fixture), in: git)
        }
        try PointerDelivery.leave(at: gitPoint(ofRow: 1, in: fixture), in: git)

        XCTAssertEqual(fixture.log.selects, [], "no file selection, no Git-row activation")
        XCTAssertEqual(fixture.log.listed, [], "no listTree, no expansion")
        XCTAssertEqual(tree.outlineView.selectedRow, -1)
        XCTAssertFalse(tree.outlineView.isItemExpanded(tree.outlineView.item(atRow: 0)))
        XCTAssertEqual(git.barPaths(), [])
    }
}
