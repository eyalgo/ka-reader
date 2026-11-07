import AppKit
import Foundation
import Surfaces
import Testing

/// How the panel draws a Markdown file over time (CP-1118): a click keeps the reading state until
/// every ask is answered, a first draw starts at the top, an update redraws in place and keeps the
/// panel's own scroll, an equal answer changes nothing, and a superseded draw draws nothing.

private func imageDocument(_ title: String, paths: [String]) -> MarkdownDocument {
    pageDocument(
        [textParagraph(title)]
            + paths.map { .paragraph([.image(alt: $0, .resolved(path: $0))]) })
}

@MainActor
private func isShowing(_ page: MarkdownPageView) -> Bool {
    !page.isHiddenOrHasHiddenAncestor
}

@MainActor
@Test
func aFirstDrawKeepsTheReadingStateUntilItsLastAskIsAnswered() {
    let recorder = AssetRecorder()
    recorder.holds = true
    let panel = makeMarkdownPanel(recorder: recorder)
    panel.showReading()

    panel.show(
        path: "README.md", verdict: .markdown(imageDocument("Title", paths: ["a.png", "b.png"])))

    #expect(recorder.heldCount == 2)
    #expect(!isShowing(panel.markdownPage))
    #expect(panel.pathLine.isHiddenOrHasHiddenAncestor)
    #expect(
        panel.allDescendants.contains { ($0 as? NSTextField)?.stringValue == "Reading this file." })

    recorder.answerAll()

    #expect(isShowing(panel.markdownPage))
    #expect(panel.pathLine.stringValue == "README.md")
    #expect(!panel.pathLine.isHiddenOrHasHiddenAncestor)
    #expect(panel.markdownPage.textView.string.contains("Title"))
    #expect(
        !panel.allDescendants.contains { ($0 as? NSTextField)?.stringValue == "Reading this file." }
    )
}

@MainActor
@Test
func aFirstDrawStartsAtTheTopWhateverPositionTheUpdateCarries() {
    let panel = makeMarkdownPanel(recorder: AssetRecorder())

    panel.update(
        path: "README.md", verdict: .markdown(longPage("one", paragraphs: 200)),
        position: ReadingPosition(topLine: 80, horizontalOffset: 40))
    panel.layoutSubtreeIfNeeded()

    #expect(isShowing(panel.markdownPage))
    #expect(panel.markdownPage.scrollOffset == 0)
}

/// CP-1118: a Markdown file drawn for the first time is drawn from the top. A re-read that arrives
/// while the file's first draw still waits on its images is still that file's first draw, so it
/// starts at the top too, never at the scroll of the page the panel showed before it.
@MainActor
@Test
func aFirstDrawOvertakenByAnUpdateStartsAtTheTopNotAtThePreviousPagesScroll() {
    let recorder = AssetRecorder()
    let panel = makeMarkdownPanel(recorder: recorder)
    panel.show(path: "other.md", verdict: .markdown(longPage("other", paragraphs: 200)))
    panel.layoutSubtreeIfNeeded()
    panel.markdownPage.scrollOffset = 600
    #expect(panel.markdownPage.scrollOffset > 0)
    recorder.holds = true

    panel.show(path: "README.md", verdict: .markdown(imageDocument("first", paths: ["a.png"])))
    panel.update(
        path: "README.md", verdict: .markdown(longPage("second", paragraphs: 200)),
        position: .topLeft)
    panel.layoutSubtreeIfNeeded()

    #expect(panel.markdownPage.textView.string.contains("second paragraph 0"))
    #expect(panel.pathLine.stringValue == "README.md")
    #expect(panel.markdownPage.scrollOffset == 0)
}

@MainActor
@Test
func aChangedDocumentForTheOpenPathRedrawsInPlaceAndKeepsTheScrollClamped() {
    let panel = makeMarkdownPanel(recorder: AssetRecorder())
    panel.show(path: "README.md", verdict: .markdown(longPage("long", paragraphs: 200)))
    panel.layoutSubtreeIfNeeded()
    panel.markdownPage.scrollOffset = 600
    let before = panel.markdownPage.scrollOffset
    #expect(before > 0)

    panel.update(
        path: "README.md", verdict: .markdown(longPage("longer", paragraphs: 260)),
        position: .topLeft)
    panel.layoutSubtreeIfNeeded()
    #expect(panel.markdownPage.textView.string.contains("longer paragraph 259"))
    #expect(panel.markdownPage.scrollOffset == before)

    panel.update(
        path: "README.md", verdict: .markdown(longPage("short", paragraphs: 3)), position: .topLeft)
    panel.layoutSubtreeIfNeeded()
    #expect(panel.markdownPage.textView.string.contains("short paragraph 2"))
    #expect(panel.markdownPage.scrollOffset <= before)
    #expect(panel.markdownPage.scrollOffset >= 0)
    #expect(isShowing(panel.markdownPage))
}

@MainActor
@Test
func anEqualAnswerChangesNothingTheScrollIncluded() {
    let recorder = AssetRecorder()
    let panel = makeMarkdownPanel(recorder: recorder)
    let document = longPage("same", paragraphs: 200)
    panel.show(path: "README.md", verdict: .markdown(document))
    panel.layoutSubtreeIfNeeded()
    panel.markdownPage.scrollOffset = 500
    let offset = panel.markdownPage.scrollOffset

    panel.update(path: "README.md", verdict: .markdown(document), position: .topLeft)

    #expect(panel.markdownPage.scrollOffset == offset)
    #expect(recorder.asked.isEmpty)
}

@MainActor
@Test
func goneAndFailedDrawAsForAnyFile() {
    let panel = makeMarkdownPanel(recorder: AssetRecorder())
    panel.show(path: "README.md", verdict: .markdown(longPage("page", paragraphs: 5)))

    panel.update(path: "README.md", verdict: .gone, position: .topLeft)
    #expect(!isShowing(panel.markdownPage))
    #expect(
        panel.allDescendants.contains {
            ($0 as? NSTextField)?.stringValue == "This file is no longer there."
        })

    panel.show(path: "README.md", verdict: .markdown(longPage("page", paragraphs: 5)))
    panel.update(path: "README.md", verdict: .failed(.unreadable), position: .topLeft)
    #expect(!isShowing(panel.markdownPage))
    #expect(
        panel.allDescendants.contains {
            ($0 as? NSTextField)?.stringValue == "KA-Reader can't read README.md."
        })
}

@MainActor
@Test
func anUpdateArrivingWhileAnEarlierDrawsBytesAreOutSupersedesIt() {
    let recorder = AssetRecorder()
    recorder.holds = true
    let panel = makeMarkdownPanel(recorder: recorder)
    panel.show(path: "README.md", verdict: .markdown(imageDocument("first", paths: ["a.png"])))
    panel.update(
        path: "README.md", verdict: .markdown(imageDocument("second", paths: ["b.png"])),
        position: .topLeft)
    #expect(recorder.heldCount == 2)

    recorder.answerAll()

    #expect(panel.markdownPage.textView.string.contains("second"))
    #expect(!panel.markdownPage.textView.string.contains("first"))
}

@MainActor
@Test
func anUpdateKeepsThePreviousPageUntilItsOwnAsksAreAnswered() {
    let recorder = AssetRecorder()
    let panel = makeMarkdownPanel(recorder: recorder)
    panel.show(path: "README.md", verdict: .markdown(longPage("old", paragraphs: 3)))
    recorder.holds = true

    panel.update(
        path: "README.md", verdict: .markdown(imageDocument("new", paths: ["x.png"])),
        position: .topLeft)

    #expect(panel.markdownPage.textView.string.contains("old paragraph 0"))
    #expect(isShowing(panel.markdownPage))
    #expect(
        !panel.allDescendants.contains { ($0 as? NSTextField)?.stringValue == "Reading this file." }
    )

    recorder.answerAll()

    #expect(panel.markdownPage.textView.string.contains("new"))
}
