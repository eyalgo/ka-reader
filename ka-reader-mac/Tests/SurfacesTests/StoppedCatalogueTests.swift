import AppKit
import Surfaces
import Testing

/// NFDR QC-53's error-path verifier: each surface that has a `stopped` state, put into it as the
/// real surface, shows the path it was given where it has one and exactly one catalogue sentence
/// besides. The expected sentence is always the catalogue symbol itself, and nothing here repeats
/// a sentence as a literal (CP-942).

private let surfaceFrame = NSRect(x: 0, y: 0, width: 600, height: 400)

@MainActor
private func makeGlyphs() -> StatusGlyphs {
    StatusGlyphs(
        empty: NSImage(size: NSSize(width: 3, height: 3)),
        failure: NSImage(size: NSSize(width: 4, height: 4)))
}

/// The strings a laid-out view tree shows, in tree order: every `NSTextField` label and every
/// `NSTextView`, empty ones included. A hidden view and everything under it is not shown. A
/// button, and so a route's title, is left out only when `excludingButtons` is set, and by what
/// it is, never by its wording; a text field beside a button is still collected.
@MainActor
private func shownText(in root: NSView, excludingButtons: Bool = false) -> [String] {
    if root.isHidden || (excludingButtons && root is NSButton) {
        return []
    }
    var shown: [String] = []
    if let field = root as? NSTextField {
        shown.append(field.stringValue)
    } else if let textView = root as? NSTextView {
        shown.append(textView.string)
    }
    for child in root.subviews {
        shown += shownText(in: child, excludingButtons: excludingButtons)
    }
    return shown
}

/// What is shown once `path` has been taken out of it, or `nil` when `path` is not shown exactly
/// once. A path that is missing or repeated is a failure, so it is never filtered away silently.
private func removingPathOnce(_ path: String, from shown: [String]) -> [String]? {
    guard shown.filter({ $0 == path }).count == 1, let index = shown.firstIndex(of: path) else {
        return nil
    }
    var remainder = shown
    remainder.remove(at: index)
    return remainder
}

@MainActor
@Test func stoppedReadingPanelUsesCatalogueSentence() {
    let path = "dir/b.txt"
    let earlierContent = "earlier file content"
    let panel = ReadingPanelView(statusGlyphs: makeGlyphs())
    panel.frame = surfaceFrame
    panel.show(path: "dir/a.txt", verdict: .text(earlierContent, .plain))
    panel.layoutSubtreeIfNeeded()
    let beforeStopped = shownText(in: panel)
    #expect(
        beforeStopped.contains(earlierContent),
        "reading panel: the earlier content was not shown before stopped; shown \(beforeStopped)")

    panel.showStopped(path: path)
    panel.layoutSubtreeIfNeeded()

    let shown = shownText(in: panel)
    #expect(
        removingPathOnce(path, from: shown) == [ConditionSentences.stoppedReadingFile],
        "reading panel stopped: expected \(path) once and one catalogue sentence; shown \(shown)")
}

@MainActor
@Test func stoppedStartupUsesCatalogueSentence() {
    let path = "/x/y"
    let view = StartupView(
        projection: .stopped(path: path), glyphs: makeGlyphs(), onIntent: { _ in })
    view.frame = surfaceFrame
    view.layoutSubtreeIfNeeded()

    let shown = shownText(in: view, excludingButtons: true)
    #expect(
        removingPathOnce(path, from: shown) == [OpeningSentences.stopped],
        "startup stopped: expected \(path) once and one catalogue sentence; shown \(shown)")
}

@MainActor
@Test func stoppedGitViewUsesCatalogueSentence() {
    let view = GitView(statusGlyphs: makeGlyphs())
    view.frame = NSRect(x: 0, y: 0, width: 260, height: 500)
    view.show(.stopped)
    view.layoutSubtreeIfNeeded()

    let shown = shownText(in: view)
    #expect(
        shown == [GitSentences.faultBeforeRepository],
        "git view stopped: expected one catalogue sentence and nothing else; shown \(shown)")
}
