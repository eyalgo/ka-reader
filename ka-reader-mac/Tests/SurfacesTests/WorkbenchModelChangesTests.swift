import AppKit
import Testing

@testable import Surfaces

/// The workbench around a tree that follows the disk: a change to the tree leaves the sidebar's
/// mode, the open file's content and the scroll offsets as they were (E2, sidebar). The workbench is
/// built as `WorkbenchGitTests` builds it, with the owner's intents recorded.
@MainActor
struct WorkbenchModelChangesTests {
    private func entry(_ path: String, _ kind: EntryKind) -> Entry {
        let name = String(path.split(separator: "/").last ?? "")
        return Entry(
            name: name, path: path, kind: kind, state: kind == .folder ? .pending : .observed)
    }

    @Test func aTreeChangeLeavesSidebarModeFileContentAndScrollAsTheyWere() throws {
        let glyph = NSImage(size: NSSize(width: 1, height: 1))
        let glyphs = StatusGlyphs(empty: glyph, failure: glyph)
        let tree = RootItemsView(
            folderGlyph: glyph, fileGlyph: glyph, fileCodeGlyph: glyph, statusGlyphs: glyphs)
        let filler = (0..<60).map { entry(String(format: "z%02d.txt", $0), .file) }
        let root = [entry("src", .folder), entry("a.txt", .file)] + filler
        tree.show(.observed(root))
        let workbench = WorkbenchView(
            rootItemsView: tree, statusGlyphs: glyphs, railFolderGlyph: glyph, railGitGlyph: glyph)
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 800, height: 500), styleMask: [.borderless],
            backing: .buffered, defer: true)
        window.contentView = workbench
        var selects: [(path: String, answer: SelectFileAnswer)] = []
        workbench.selectFile = { path, answer in selects.append((path, answer)) }
        tree.listTree = { _, _ in }
        workbench.layoutSubtreeIfNeeded()

        tree.outlineView.selectRowIndexes(IndexSet(integer: 1), byExtendingSelection: false)
        let text = (1...300).map { "line \($0)" }.joined(separator: "\n")
        try #require(selects.first).answer(.text(text, .plain))
        let panelScroll = try #require(workbench.readingPanel.contentView.enclosingScrollView)
        panelScroll.contentView.scroll(to: NSPoint(x: 0, y: 3000))
        panelScroll.reflectScrolledClipView(panelScroll.contentView)
        tree.contentView.scroll(to: NSPoint(x: 0, y: 60))
        tree.reflectScrolledClipView(tree.contentView)
        let before = (
            active: workbench.rail.active, path: workbench.readingPanel.pathLine.stringValue,
            string: workbench.readingPanel.contentView.string,
            panelOffset: panelScroll.contentView.bounds.origin,
            treeOffset: tree.contentView.bounds.origin, bar: tree.barPaths()
        )
        #expect(before.panelOffset.y > 0)
        #expect(before.treeOffset.y > 0)

        tree.apply(changes: [
            ("", .observed([entry("0.txt", .file)] + root)),
            ("src", .observed([entry("src/lib.rs", .file)])),
        ])

        #expect(workbench.rail.active == before.active)
        #expect(workbench.readingPanel.pathLine.stringValue == before.path)
        #expect(workbench.readingPanel.contentView.string == before.string)
        #expect(panelScroll.contentView.bounds.origin == before.panelOffset)
        #expect(tree.contentView.bounds.origin == before.treeOffset)
        #expect(tree.barPaths() == before.bar)
        #expect(selects.map(\.path) == ["a.txt"], "no change read a file")
    }
}
