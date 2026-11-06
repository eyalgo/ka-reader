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

// MARK: - The automatic update (task 6)

/// A panel in a window, sized so a 400-line file overflows it both ways.
@MainActor
private func makeWindowedPanel() -> (ReadingPanelView, NSClipView, NSWindow) {
    let panel = ReadingPanelView(statusGlyphs: makeGlyphs())
    let window = NSWindow(
        contentRect: panelFrame, styleMask: [.titled], backing: .buffered, defer: false)
    window.contentView = panel
    panel.layoutSubtreeIfNeeded()
    // The clip view exists from construction, but only text gives the panel something to scroll.
    return (panel, panel.contentView.enclosingScrollView?.contentView ?? NSClipView(), window)
}

/// `count` numbered lines, each `width` characters wide, so the document overflows sideways.
private func lines(_ count: Int, width: Int = 200, tag: String = "") -> String {
    (0..<count).map { "line \($0)\(tag) " + String(repeating: "x", count: width) }
        .joined(separator: "\n")
}

/// The y at which the code view's clip view has line `index` at its top.
@MainActor
private func originY(ofLine index: Int) -> CGFloat {
    CodeSpacing.inset + CGFloat(index) * CodeType.linePitch
}

/// Waits one turn of the main run loop, so a coalesced scroll report has been raised.
@MainActor
private func settle() async {
    await withCheckedContinuation { continuation in
        DispatchQueue.main.async { continuation.resume() }
    }
}

/// Counts the edits the text storage takes, and the empty states it passes through.
@MainActor
private final class StorageWatch {
    private(set) var edits = 0
    private(set) var emptyStates = 0
    private var observer: (any NSObjectProtocol)?

    init(_ storage: NSTextStorage) {
        nonisolated(unsafe) let watched = storage
        observer = NotificationCenter.default.addObserver(
            forName: NSTextStorage.didProcessEditingNotification, object: storage, queue: nil
        ) { [weak self] _ in
            MainActor.assumeIsolated {
                self?.edits += 1
                if unsafe watched.length == 0 { self?.emptyStates += 1 }
            }
        }
    }

    isolated deinit {
        if let observer { NotificationCenter.default.removeObserver(observer) }
    }
}

/// The text storage behind the panel's text view.
@MainActor
private func storageOf(_ panel: ReadingPanelView) -> NSTextStorage {
    guard let storage = unsafe panel.contentView.textStorage else {
        preconditionFailure("the panel's text view is TextKit 1 and has a storage")
    }
    return storage
}

@MainActor
private final class PositionLog {
    private(set) var positions: [ReadingPosition] = []
    func record(_ position: ReadingPosition) { positions.append(position) }
}

@MainActor
@Test func anInsertNearTheEndOfA400LineFileKeepsLine200AtTheTopAndThe30ColumnOffset() throws {
    let (panel, clip, window) = makeWindowedPanel()
    _ = window
    panel.show(path: "big.txt", verdict: .text(lines(400), .plain))
    panel.layoutSubtreeIfNeeded()
    clip.scroll(to: NSPoint(x: 240, y: originY(ofLine: 200)))
    let before = clip.bounds.origin
    #expect(panel.currentPosition == ReadingPosition(topLine: 200, horizontalOffset: 240))

    var edited = lines(400).split(separator: "\n", omittingEmptySubsequences: false).map(
        String.init)
    edited.insert("inserted near the end", at: 390)
    panel.update(
        path: "big.txt", verdict: .text(edited.joined(separator: "\n"), .plain),
        position: .topLeft)

    #expect(panel.currentPosition == ReadingPosition(topLine: 200, horizontalOffset: 240))
    #expect(abs(clip.bounds.origin.y - before.y) < 0.01)
    #expect(abs(clip.bounds.origin.y - originY(ofLine: 200)) < 0.5)
    #expect(clip.bounds.origin.x == 240)
    #expect(panel.contentView.string.contains("inserted near the end"))
}

@MainActor
@Test func aTruncationTo50LinesShowsTheLastLinesAndNotTheTop() throws {
    let (panel, clip, window) = makeWindowedPanel()
    _ = window
    panel.show(path: "big.txt", verdict: .text(lines(400), .plain))
    panel.layoutSubtreeIfNeeded()
    clip.scroll(to: NSPoint(x: 240, y: originY(ofLine: 200)))

    panel.update(path: "big.txt", verdict: .text(lines(50), .plain), position: .topLeft)

    let document = try #require(panel.contentView.enclosingScrollView?.documentView)
    #expect(clip.bounds.origin.y > 0)
    #expect(abs(clip.bounds.maxY - document.frame.maxY) < 1)
    #expect(panel.currentPosition.topLine > 0)
    #expect(panel.currentPosition.topLine < 50)
}

@MainActor
@Test func thePendingSentenceNeverAppearsDuringAnUpdateAndNoFrameShowsAnEmptyPanel() {
    let (panel, _, window) = makeWindowedPanel()
    _ = window
    panel.show(path: "a.txt", verdict: .text(lines(30), .plain))
    let watch = StorageWatch(storageOf(panel))

    panel.update(path: "a.txt", verdict: .text(lines(30, tag: "!"), .plain), position: .topLeft)

    #expect(watch.edits > 0)
    #expect(watch.emptyStates == 0)
    #expect(!panel.contentView.isHiddenOrHasHiddenAncestor)
    #expect(panel.contentView.string.contains("!"))
    #expect(visibleLabels(panel) == ["a.txt"])
    #expect(!visibleLabels(panel).contains(ConditionSentences.readingFile))
}

@MainActor
@Test func anEqualVerdictChangesNothingTheScrollIncluded() {
    let (panel, clip, window) = makeWindowedPanel()
    _ = window
    let verdict = FileVerdict.text(lines(400), .plain)
    panel.show(path: "big.txt", verdict: verdict)
    panel.layoutSubtreeIfNeeded()
    clip.scroll(to: NSPoint(x: 120, y: originY(ofLine: 90)))
    let before = clip.bounds.origin
    let watch = StorageWatch(storageOf(panel))

    panel.update(
        path: "big.txt", verdict: verdict,
        position: ReadingPosition(topLine: 3, horizontalOffset: 0))

    #expect(watch.edits == 0)
    #expect(clip.bounds.origin == before)
    #expect(panel.currentPosition == ReadingPosition(topLine: 90, horizontalOffset: 120))
}

@MainActor
@Test func aFailedUpdateShowsTheCatalogueSentenceForTheConditionUnderThePathLine() {
    let (panel, _, window) = makeWindowedPanel()
    _ = window
    panel.show(path: "docs/notes.txt", verdict: .text(lines(30), .plain))

    panel.update(
        path: "docs/notes.txt", verdict: .failed(.unreadable), position: .topLeft)

    #expect(
        visibleLabels(panel) == [
            "docs/notes.txt",
            ConditionSentences.reading(fileNamed: "notes.txt", failedWith: .unreadable),
        ])
    #expect(panel.contentView.isHiddenOrHasHiddenAncestor)
    #expect(panel.contentView.string.isEmpty)

    panel.update(path: "docs/notes.txt", verdict: .cannotDisplay(.invalidUTF8), position: .topLeft)

    #expect(
        visibleLabels(panel) == [
            "docs/notes.txt", ConditionSentences.cannotDisplay(fileNamed: "notes.txt"),
        ])
}

@MainActor
@Test func recoveryFromGoneAndFromAFailureShowsTheNewTextNoMessageAndTheCarriedPositionClamped() {
    let (panel, clip, window) = makeWindowedPanel()
    _ = window
    for broken in [FileVerdict.gone, .failed(.unreadable)] {
        panel.show(path: "big.txt", verdict: .text(lines(400), .plain))
        panel.update(path: "big.txt", verdict: broken, position: .topLeft)
        #expect(panel.contentView.isHiddenOrHasHiddenAncestor)

        panel.update(
            path: "big.txt", verdict: .text(lines(400, tag: "new"), .plain),
            position: ReadingPosition(topLine: 120, horizontalOffset: 80))

        #expect(visibleLabels(panel) == ["big.txt"])
        #expect(panel.contentView.string.contains("new"))
        #expect(panel.currentPosition == ReadingPosition(topLine: 120, horizontalOffset: 80))
        #expect(abs(clip.bounds.origin.y - originY(ofLine: 120)) < 0.5)
    }

    // A position past the new end shows as far as the new content reaches.
    panel.update(path: "big.txt", verdict: .gone, position: .topLeft)
    panel.update(
        path: "big.txt", verdict: .text(lines(50), .plain),
        position: ReadingPosition(topLine: 10_000, horizontalOffset: 100_000))
    let document = panel.contentView.enclosingScrollView?.documentView
    #expect(abs(clip.bounds.maxY - (document?.frame.maxY ?? 0)) < 1)
    #expect(panel.currentPosition.topLine < 50)
    #expect(clip.bounds.maxX <= (document?.frame.maxX ?? 0) + 1)
}

@MainActor
@Test func theFirstDrawOfAFilesTextIsDrawnAtThePositionGiven() {
    let (panel, clip, window) = makeWindowedPanel()
    _ = window

    panel.update(
        path: "big.txt", verdict: .text(lines(400), .plain),
        position: ReadingPosition(topLine: 7, horizontalOffset: 40))

    #expect(panel.currentPosition == ReadingPosition(topLine: 7, horizontalOffset: 40))
    #expect(abs(clip.bounds.origin.y - originY(ofLine: 7)) < 0.5)
    #expect(clip.bounds.origin.x == 40)
    #expect(visibleLabels(panel) == ["big.txt"])
}

@MainActor
@Test func aReadersScrollRaisesPositionChangedOnceWithTheLineAtTheTopAndTheOffset() async {
    let (panel, clip, window) = makeWindowedPanel()
    _ = window
    panel.show(path: "big.txt", verdict: .text(lines(400), .plain))
    panel.layoutSubtreeIfNeeded()
    await settle()
    let log = PositionLog()
    panel.positionChanged = { log.record($0) }

    clip.scroll(to: NSPoint(x: 10, y: originY(ofLine: 12)))
    clip.scroll(to: NSPoint(x: 160, y: originY(ofLine: 20)))
    await settle()

    #expect(log.positions == [ReadingPosition(topLine: 20, horizontalOffset: 160)])
}

@MainActor
@Test func aScrollThePanelMakesItselfRaisesNone() async {
    let (panel, clip, window) = makeWindowedPanel()
    _ = window
    panel.show(path: "big.txt", verdict: .text(lines(400), .plain))
    panel.layoutSubtreeIfNeeded()
    await settle()
    let log = PositionLog()
    panel.positionChanged = { log.record($0) }

    // The restore after recovery, the clamp after a truncation, and a new file drawn at the top.
    panel.update(path: "big.txt", verdict: .gone, position: .topLeft)
    panel.update(
        path: "big.txt", verdict: .text(lines(400), .plain),
        position: ReadingPosition(topLine: 150, horizontalOffset: 60))
    await settle()
    panel.update(path: "big.txt", verdict: .text(lines(50), .plain), position: .topLeft)
    await settle()
    panel.show(path: "other.txt", verdict: .text(lines(400, tag: "o"), .plain))
    await settle()

    #expect(log.positions.isEmpty)
    #expect(clip.bounds.origin == .zero)
}
