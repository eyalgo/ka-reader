import AppKit
import Foundation
import Testing

@testable import Surfaces

/// The reading panel when the open file follows the disk: the gone state (E7), and the contract
/// `show` keeps for a selection's answer. The expected sentence is always the catalogue symbol,
/// and the catalogue's row in `docs/CONTENT.md` is read to check the symbol holds its words.

private let panelFrame = NSRect(x: 0, y: 0, width: 600, height: 400)

@MainActor
private func makeGlyphs() -> StatusGlyphs {
    StatusGlyphs(
        empty: NSImage(size: NSSize(width: 3, height: 3)),
        failure: NSImage(size: NSSize(width: 4, height: 4)))
}

@MainActor
private func makePanel() -> ReadingPanelView {
    let panel = ReadingPanelView(statusGlyphs: makeGlyphs())
    panel.frame = panelFrame
    panel.layoutSubtreeIfNeeded()
    return panel
}

/// The text of every visible, non-editable text field, top to bottom.
@MainActor
private func visibleLabels(_ root: NSView) -> [String] {
    root.layoutSubtreeIfNeeded()
    func walk(_ view: NSView) -> [NSTextField] {
        if view.isHidden { return [] }
        let own = (view as? NSTextField).map { [$0] } ?? []
        return own + view.subviews.flatMap(walk)
    }
    return walk(root)
        .filter { !$0.isEditable }
        .sorted {
            $0.convert($0.bounds, to: root).maxY > $1.convert($1.bounds, to: root).maxY
        }
        .map(\.stringValue)
}

/// `docs/CONTENT.md`, read from the product root three folders above this file.
private func contentCatalogue() throws -> String {
    var url = URL(fileURLWithPath: #filePath)
    for _ in 0..<4 { url.deleteLastPathComponent() }
    return try String(contentsOf: url.appendingPathComponent("docs/CONTENT.md"), encoding: .utf8)
}

@MainActor
@Test func goneShowsThePathLineAndExactlyTheFileGoneSentence() throws {
    let panel = makePanel()
    panel.show(path: "docs/notes.txt", verdict: .text("before\n", .plain))

    panel.show(path: "docs/notes.txt", verdict: .gone)

    #expect(visibleLabels(panel) == ["docs/notes.txt", ConditionSentences.fileGone])
    #expect(panel.pathLine.stringValue == "docs/notes.txt")
    let row = try #require(
        try contentCatalogue().split(separator: "\n").first {
            $0.contains("UX-S1 Reading panel — error (file gone)")
        })
    #expect(row.contains("\"\(ConditionSentences.fileGone)\""))
    #expect(!ConditionSentences.fileGone.isEmpty)
}

@MainActor
@Test func goneLeavesTheCodeViewHiddenWithNoTextGutterOrColourFromBefore() {
    let panel = makePanel()
    let source = "let a = 1\nlet b = 2\n"
    panel.show(
        path: "a.py",
        verdict: .text(source, .floor(.python, [CodeSpan(start: 0, end: 3, tokenClass: .keyword)])))
    #expect(!panel.contentView.isHiddenOrHasHiddenAncestor)

    panel.show(path: "a.py", verdict: .gone)

    #expect(panel.contentView.isHiddenOrHasHiddenAncestor)
    #expect(panel.contentView.string.isEmpty)
    #expect(unsafe panel.contentView.textStorage?.length == 0)
    #expect(visibleLabels(panel).count == 2)
}

@MainActor
@Test func showStillScrollsATextAnswerToTheTopLeft() throws {
    let panel = makePanel()
    let window = NSWindow(
        contentRect: panelFrame, styleMask: [.titled], backing: .buffered, defer: false)
    window.contentView = panel
    let lines = (0..<400).map { "line \($0) " + String(repeating: "x", count: 200) }
    panel.show(path: "long.txt", verdict: .text(lines.joined(separator: "\n"), .plain))
    panel.layoutSubtreeIfNeeded()
    let clip = try #require(panel.contentView.enclosingScrollView?.contentView)
    clip.scroll(to: NSPoint(x: 120, y: 900))
    #expect(clip.bounds.origin.y > 0)

    panel.show(path: "other.txt", verdict: .text(lines.joined(separator: "\n"), .plain))

    #expect(clip.bounds.origin.x == 0)
    #expect(clip.bounds.origin.y == 0)
}
