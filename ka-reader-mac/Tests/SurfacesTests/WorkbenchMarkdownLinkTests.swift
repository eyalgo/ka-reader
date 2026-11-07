import AppKit
import Foundation
import Testing

@testable import Surfaces

/// The workbench's rule for a relative link's answer (CP-1116, CP-1117): raising the intent changes
/// nothing, a `nothing` answer changes nothing, and an `opened` or `stopped` answer draws only if the
/// reader made no tree or Git selection after the link was raised. A link is raised the way the page
/// raises it: through the panel's forwarded activation.

@MainActor
private final class Log {
    var selects: [(path: String, answer: SelectFileAnswer)] = []
    var links: [(path: String, answer: @MainActor (RelativeLinkAnswer) -> Void)] = []
    var listed: [(path: String, answer: ListTreeAnswer)] = []
    let assets = AssetRecorder()
}

@MainActor
private struct Fixture {
    let workbench: WorkbenchView
    let log: Log
    var tree: RootItemsView { workbench.rootItemsView }
    var panel: ReadingPanelView { workbench.readingPanel }

    /// Raises a link the way the page does.
    @MainActor
    func activate(_ path: String) {
        panel.relativeLinkActivated?(path)
    }
}

@MainActor
private func entry(_ name: String, _ kind: EntryKind, path: String? = nil) -> Entry {
    Entry(
        name: name, path: path ?? name, kind: kind, state: kind == .folder ? .pending : .observed)
}

@MainActor
private func makeFixture() -> Fixture {
    let glyph = NSImage(size: NSSize(width: 1, height: 1))
    let glyphs = StatusGlyphs(empty: glyph, failure: glyph)
    let tree = RootItemsView(
        folderGlyph: glyph, fileGlyph: glyph, fileCodeGlyph: glyph, statusGlyphs: glyphs)
    tree.show(
        .observed([
            entry("docs", .folder), entry("src", .folder), entry("notes.txt", .file),
            entry("a.txt", .file),
        ]))
    let workbench = WorkbenchView(
        rootItemsView: tree, statusGlyphs: glyphs, railFolderGlyph: glyph, railGitGlyph: glyph)
    workbench.frame = NSRect(x: 0, y: 0, width: 900, height: 500)
    let log = Log()
    workbench.selectFile = { path, answer in log.selects.append((path, answer)) }
    workbench.openRelativeLink = { path, answer in log.links.append((path, answer)) }
    workbench.assetBytes = log.assets.intent
    tree.listTree = { path, act, answer in
        guard act == .expand else { return }
        log.listed.append((path, answer))
    }
    workbench.layoutSubtreeIfNeeded()
    return Fixture(workbench: workbench, log: log)
}

private func page(_ words: String) -> FileVerdict {
    .markdown(pageDocument([textParagraph(words)]))
}

@MainActor
private func clickRow(_ name: String, in fixture: Fixture) {
    let tree = fixture.tree
    guard
        let index = (0..<tree.outlineView.numberOfRows).first(where: {
            tree.entry(atRow: $0)?.name == name
        })
    else {
        Issue.record("no row named \(name)")
        return
    }
    tree.outlineView.selectRowIndexes(IndexSet(integer: index), byExtendingSelection: false)
}

@MainActor
private func strings(_ panel: ReadingPanelView) -> [String] {
    panel.layoutSubtreeIfNeeded()
    return panel.allDescendants.filter { !$0.isHiddenOrHasHiddenAncestor }
        .compactMap { ($0 as? NSTextField)?.stringValue }
}

@MainActor
@Test
func anOpenedMarkdownVerdictDrawsUnderTheTargetAndMovesTheMark() {
    let fixture = makeFixture()
    fixture.activate("docs/guide.md")

    fixture.log.links[0].answer(.opened(page("the guide")))

    #expect(fixture.log.links.map(\.path) == ["docs/guide.md"])
    #expect(fixture.panel.pathLine.stringValue == "docs/guide.md")
    #expect(fixture.panel.markdownPage.textView.string == "the guide")
    #expect(fixture.tree.openFilePath == "docs/guide.md")
}

@MainActor
@Test
func aCollapsedFolderStaysCollapsedAndShowsTheCueOnceExpanded() throws {
    let fixture = makeFixture()
    let outline = fixture.tree.outlineView
    fixture.activate("docs/guide.md")

    fixture.log.links[0].answer(.opened(page("the guide")))

    let docsRow = try #require(
        (0..<outline.numberOfRows).first { fixture.tree.entry(atRow: $0)?.name == "docs" })
    #expect(!outline.isItemExpanded(outline.item(atRow: docsRow)))
    outline.expandItem(outline.item(atRow: docsRow))
    fixture.log.listed.last?.answer(.observed([entry("guide.md", .file, path: "docs/guide.md")]))
    #expect(fixture.tree.barPaths() == ["docs/guide.md"])
}

@MainActor
@Test
func anOpenedTextVerdictDrawsAsText() {
    let fixture = makeFixture()
    fixture.activate("src/main.rs")

    fixture.log.links[0].answer(.opened(.text("fn main() {}\n", .plain)))

    #expect(fixture.panel.pathLine.stringValue == "src/main.rs")
    #expect(fixture.panel.contentView.string == "fn main() {}\n")
    #expect(fixture.tree.openFilePath == "src/main.rs")
}

@MainActor
@Test
func aTreeClickAfterTheLinkWhoseAnswerComesLastEndsOnTheClickedFile() {
    let fixture = makeFixture()
    fixture.activate("docs/guide.md")
    clickRow("notes.txt", in: fixture)
    fixture.log.selects[0].answer(.text("notes\n", .plain))

    fixture.log.links[0].answer(.opened(page("the guide")))

    #expect(fixture.panel.pathLine.stringValue == "notes.txt")
    #expect(fixture.panel.contentView.string == "notes\n")
    #expect(fixture.tree.openFilePath == "notes.txt")
}

@MainActor
@Test
func twoLinksAnsweredInOrderEndOnTheSecond() {
    let fixture = makeFixture()
    fixture.activate("one.md")
    fixture.activate("two.md")

    fixture.log.links[0].answer(.opened(page("one")))
    fixture.log.links[1].answer(.opened(page("two")))

    #expect(fixture.panel.pathLine.stringValue == "two.md")
    #expect(fixture.panel.markdownPage.textView.string == "two")
    #expect(fixture.tree.openFilePath == "two.md")
}

@MainActor
@Test
func aFileLinkThenAFolderLinkAnsweredNothingEndOnTheFile() {
    let fixture = makeFixture()
    fixture.activate("one.md")
    fixture.activate("src")

    fixture.log.links[0].answer(.opened(page("one")))
    fixture.log.links[1].answer(.nothing)

    #expect(fixture.panel.pathLine.stringValue == "one.md")
    #expect(fixture.tree.openFilePath == "one.md")
}

@MainActor
@Test
func aNothingAnswerLeavesTheOpenFileTheMarkAndTheScrollAsTheyWere() {
    let fixture = makeFixture()
    clickRow("a.txt", in: fixture)
    fixture.log.selects[0].answer(.text("alpha\n", .plain))
    let offset = fixture.panel.currentPosition
    fixture.activate("src")

    fixture.log.links[0].answer(.nothing)

    #expect(fixture.panel.pathLine.stringValue == "a.txt")
    #expect(fixture.panel.contentView.string == "alpha\n")
    #expect(fixture.tree.openFilePath == "a.txt")
    #expect(fixture.panel.currentPosition == offset)
}

@MainActor
@Test
func aStoppedAnswerDrawsStoppedUnderTheTarget() {
    let fixture = makeFixture()
    fixture.activate("docs/guide.md")

    fixture.log.links[0].answer(.stopped)

    #expect(fixture.panel.pathLine.stringValue == "docs/guide.md")
    #expect(
        strings(fixture.panel).contains {
            $0.hasPrefix("KA-Reader stopped while reading this file")
        })
}

@MainActor
@Test
func raisingALinkDrawsNothingUntilItIsAnswered() {
    let fixture = makeFixture()
    clickRow("a.txt", in: fixture)
    fixture.log.selects[0].answer(.text("alpha\n", .plain))

    fixture.activate("docs/guide.md")

    #expect(fixture.panel.pathLine.stringValue == "a.txt")
    #expect(fixture.tree.openFilePath == "a.txt")
    #expect(!strings(fixture.panel).contains("Reading this file."))
}

@MainActor
@Test
func aLinkOpenedWhileTheGitViewShowsClearsTheGitRowSelectionAndFilesShowsTheMark() {
    let fixture = makeFixture()
    fixture.workbench.rail.entryChosen?(.git)
    fixture.workbench.gitView.rowActivated?("a.txt")
    fixture.activate("docs/guide.md")

    fixture.log.links[0].answer(.opened(page("the guide")))
    fixture.workbench.rail.entryChosen?(.files)

    #expect(fixture.workbench.gitView.barPaths().isEmpty)
    #expect(fixture.tree.openFilePath == "docs/guide.md")
    #expect(fixture.panel.pathLine.stringValue == "docs/guide.md")
}

@MainActor
@Test
func aLinkToTheOpenFileItselfIsDrawnLikeAnyOpenedAnswer() {
    let fixture = makeFixture()
    clickRow("a.txt", in: fixture)
    fixture.log.selects[0].answer(.text("alpha\n", .plain))
    fixture.activate("a.txt")

    fixture.log.links[0].answer(.opened(.text("alpha again\n", .plain)))

    #expect(fixture.panel.pathLine.stringValue == "a.txt")
    #expect(fixture.panel.contentView.string == "alpha again\n")
    #expect(fixture.tree.openFilePath == "a.txt")
}

@MainActor
@Test
func anAssetBytesIntentSetOnTheWorkbenchIsTheOneThePanelAsksThrough() {
    let fixture = makeFixture()
    clickRow("notes.txt", in: fixture)

    fixture.log.selects[0].answer(
        .markdown(
            pageDocument([.paragraph([.image(alt: "logo", .resolved(path: "img/logo.png"))])])))

    #expect(fixture.log.assets.asked == ["img/logo.png"])
}
