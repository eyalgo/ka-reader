import AppKit
import Foundation
import Testing

@testable import Surfaces

/// The workbench when the open file follows the disk: an update draws only for the latest
/// selection, a selection's own answer is skipped once an update was drawn for it, the reader's
/// scroll is raised with the latest selection's path, and the tree stays the reader's throughout
/// (CP-1019, CP-1022, CP-1024; E2, E6). Sentences are literals here, never read from the catalogue.

private let pendingSentence = "Reading this file."

private struct SelectRead {
    let path: String
    let answer: SelectFileAnswer
}

@MainActor
private final class Log {
    var selects: [SelectRead] = []
    var positions: [(path: String, position: ReadingPosition)] = []
}

private struct Fixture {
    let workbench: WorkbenchView
    let window: NSWindow
    let log: Log
}

@MainActor
private func entry(_ name: String, _ kind: EntryKind) -> Entry {
    Entry(name: name, path: name, kind: kind, state: kind == .folder ? .pending : .observed)
}

@MainActor
private func makeFixture() -> Fixture {
    let glyph = NSImage(size: NSSize(width: 1, height: 1))
    let glyphs = StatusGlyphs(empty: glyph, failure: glyph)
    let tree = RootItemsView(
        folderGlyph: glyph, fileGlyph: glyph, fileCodeGlyph: glyph, statusGlyphs: glyphs)
    tree.show(.observed([entry("a.txt", .file), entry("b.txt", .file), entry("src", .folder)]))
    let workbench = WorkbenchView(
        rootItemsView: tree, statusGlyphs: glyphs, railFolderGlyph: glyph, railGitGlyph: glyph)
    let window = NSWindow(
        contentRect: NSRect(x: 0, y: 0, width: 900, height: 500), styleMask: [.borderless],
        backing: .buffered, defer: true)
    window.contentView = workbench
    let log = Log()
    workbench.selectFile = { path, answer in
        log.selects.append(SelectRead(path: path, answer: answer))
    }
    workbench.filePosition = { path, position in log.positions.append((path, position)) }
    workbench.layoutSubtreeIfNeeded()
    return Fixture(workbench: workbench, window: window, log: log)
}

@MainActor
private func select(_ name: String, in workbench: WorkbenchView) {
    let tree = workbench.rootItemsView
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
private func panelStrings(_ workbench: WorkbenchView) -> [String] {
    let panel = workbench.readingPanel
    panel.layoutSubtreeIfNeeded()
    func walk(_ view: NSView) -> [NSView] { view.subviews + view.subviews.flatMap(walk) }
    return walk(panel)
        .filter { !$0.isHiddenOrHasHiddenAncestor }
        .compactMap { $0 as? NSTextField }
        .filter { !$0.isEditable }
        .sorted { $0.convert($0.bounds, to: panel).maxY > $1.convert($1.bounds, to: panel).maxY }
        .map(\.stringValue)
}

@MainActor
private func update(_ path: String, _ text: String, at position: ReadingPosition = .topLeft)
    -> OpenFileUpdate
{
    OpenFileUpdate(path: path, verdict: .text(text, .plain), position: position)
}

@MainActor
private func settle() async {
    await withCheckedContinuation { continuation in
        DispatchQueue.main.async { continuation.resume() }
    }
}

@MainActor
@Test
func anUpdateForAFileThatIsNoLongerTheLatestSelectionDrawsNothingAndTheTreeKeepsTheNewSelection() {
    let fixture = makeFixture()
    let workbench = fixture.workbench
    select("a.txt", in: workbench)
    fixture.log.selects[0].answer(.text("a text", .plain))
    select("b.txt", in: workbench)

    // b.txt is pending: the panel says so, and a's update does not replace that.
    workbench.apply(openFile: update("a.txt", "a changed"))
    #expect(panelStrings(workbench) == [pendingSentence])

    fixture.log.selects[1].answer(.text("b text", .plain))
    workbench.apply(openFile: update("a.txt", "a changed again"))

    #expect(panelStrings(workbench) == ["b.txt"])
    #expect(workbench.readingPanel.contentView.string == "b text")
    #expect(workbench.rootItemsView.barPaths() == ["b.txt"])
    #expect(workbench.rootItemsView.selectionFillPaths() == ["b.txt"])
}

@MainActor
@Test func anUpdateForThePendingSelectionsPathIsDrawnAndThatSelectionsLaterAnswerThenDrawsNothing()
{
    let fixture = makeFixture()
    let workbench = fixture.workbench
    select("a.txt", in: workbench)
    #expect(panelStrings(workbench) == [pendingSentence])

    workbench.apply(openFile: update("a.txt", "newer"))
    #expect(panelStrings(workbench) == ["a.txt"])
    #expect(workbench.readingPanel.contentView.string == "newer")

    fixture.log.selects[0].answer(.text("older", .plain))
    #expect(workbench.readingPanel.contentView.string == "newer")

    // A stopped read answering after the update draws nothing either.
    select("b.txt", in: workbench)
    workbench.apply(openFile: update("b.txt", "b newer"))
    fixture.log.selects[1].answer(nil)
    #expect(panelStrings(workbench) == ["b.txt"])
}

@MainActor
@Test func anAnswerWithNoUpdateBeforeItDrawsAsTodayWhateverEarlierSelectionsHadUpdates() {
    let fixture = makeFixture()
    let workbench = fixture.workbench
    select("a.txt", in: workbench)
    workbench.apply(openFile: update("a.txt", "a newer"))
    select("b.txt", in: workbench)

    fixture.log.selects[1].answer(.text("b text", .plain))

    #expect(panelStrings(workbench) == ["b.txt"])
    #expect(workbench.readingPanel.contentView.string == "b text")

    select("a.txt", in: workbench)
    fixture.log.selects[2].answer(nil)
    #expect(panelStrings(workbench).first == "a.txt")
    #expect(panelStrings(workbench).count == 2)
}

@MainActor
@Test func aPositionChangeRaisesFilePositionWithTheLatestSelectionsPath() async throws {
    let fixture = makeFixture()
    let workbench = fixture.workbench
    select("a.txt", in: workbench)
    let lines = (0..<400).map { "line \($0) " + String(repeating: "x", count: 200) }
    fixture.log.selects[0].answer(.text(lines.joined(separator: "\n"), .plain))
    workbench.layoutSubtreeIfNeeded()
    await settle()
    let clip = try #require(workbench.readingPanel.contentView.enclosingScrollView?.contentView)

    clip.scroll(to: NSPoint(x: 80, y: CodeSpacing.inset + 30 * CodeType.linePitch))
    await settle()

    #expect(fixture.log.positions.count == 1)
    #expect(fixture.log.positions.first?.path == "a.txt")
    #expect(
        fixture.log.positions.first?.position == ReadingPosition(topLine: 30, horizontalOffset: 80))
}

@MainActor
@Test func whileUpdatesArriveTheTreeStaysEnabledAndAClickOnAnotherRowRaisesItsSelection() {
    let fixture = makeFixture()
    let workbench = fixture.workbench
    select("a.txt", in: workbench)
    fixture.log.selects[0].answer(.text("one", .plain))

    workbench.apply(openFile: update("a.txt", "two"))
    workbench.apply(openFile: OpenFileUpdate(path: "a.txt", verdict: .gone, position: .topLeft))

    #expect(workbench.rootItemsView.outlineView.isEnabled)
    select("b.txt", in: workbench)
    #expect(fixture.log.selects.map(\.path) == ["a.txt", "b.txt"])
}

@MainActor
@Test func anUpdateOpenedFromAGitRowIsDrawnTheSameWay() {
    let fixture = makeFixture()
    let workbench = fixture.workbench

    workbench.gitView.rowActivated?("b.txt")
    #expect(fixture.log.selects.map(\.path) == ["b.txt"])
    #expect(panelStrings(workbench) == [pendingSentence])

    workbench.apply(openFile: update("b.txt", "from the disk"))
    #expect(panelStrings(workbench) == ["b.txt"])
    #expect(workbench.readingPanel.contentView.string == "from the disk")

    fixture.log.selects[0].answer(.text("stale", .plain))
    #expect(workbench.readingPanel.contentView.string == "from the disk")
}
