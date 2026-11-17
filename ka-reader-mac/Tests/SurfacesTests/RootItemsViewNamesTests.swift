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

    private func entry(_ name: String, _ kind: EntryKind) -> Entry {
        Entry(name: name, path: name, kind: kind, state: .observed)
    }

    private func tree() -> RootItemsView {
        RootItemsView(
            folderGlyph: glyph, fileGlyph: glyph, fileCodeGlyph: glyph, statusGlyphs: glyphs,
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

    /// The names the tree draws, each asserted whole: its glyph is set, its label reads the entry's
    /// name, the label is at least as wide as its text, and it lies inside the clip's visible rect.
    @discardableResult
    private func expectNamesWhole(_ root: RootItemsView) -> [String] {
        root.layoutSubtreeIfNeeded()
        let visible = root.contentView.bounds
        var names: [String] = []
        for (shown, cell) in entryCells(root) {
            let glyphImage = unsafe cell.imageView?.image
            #expect(glyphImage != nil)
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
        #expect(letters(root).isEmpty)
        #expect(fields(root).filter { $0.stringValue.contains("Git") }.isEmpty)

        view.rail.entryChosen?(.git)
        #expect(fields(view.gitView).isEmpty)
        view.rail.entryChosen?(.files)
        #expect(expectNamesWhole(root) == expected)
        withExtendedLifetime(window) {}
    }
}
