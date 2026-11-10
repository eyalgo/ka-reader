import AppKit
import Testing

@testable import Surfaces

/// CP-1264's observation belongs to folder open, before the first Git switch.
@MainActor
struct WorkbenchViewTests {
    @MainActor
    private final class ReadState {
        var asks = 0
        var answer: GitAnswer?
        var nextAnswer = GitItem.plain
    }

    private func host() -> (NSWindow, WorkbenchView) {
        let glyph = NSImage(size: NSSize(width: 3, height: 3))
        let glyphs = StatusGlyphs(empty: glyph, failure: glyph)
        let tree = RootItemsView(
            folderGlyph: glyph, fileGlyph: glyph, fileCodeGlyph: glyph, statusGlyphs: glyphs,
            tooltipRest: TooltipRestDouble().rest, keyWindow: KeyWindowDouble().source)
        tree.show(
            .observed([
                Entry(name: "initial.txt", path: "initial.txt", kind: .file, state: .observed)
            ]))
        let workbench = WorkbenchView(
            rootItemsView: tree, statusGlyphs: glyphs, railFolderGlyph: glyph, railGitGlyph: glyph,
            keyWindow: KeyWindowDouble().source)
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 960, height: 500), styleMask: [.borderless],
            backing: .buffered, defer: true)
        window.contentView = workbench
        workbench.layoutSubtreeIfNeeded()
        return (window, workbench)
    }
    private func repository() -> GitItem {
        .repository(
            GitRepository(
                branch: .named("main"), state: .normal, staged: [],
                changed: [GitEntry(path: "initial.txt", category: .modified)]))
    }
    private func fields(_ view: NSView) -> [NSTextField] {
        view.subviews.flatMap { child in
            (child as? NSTextField).map { [$0] } ?? fields(child)
        }.filter { !$0.isHiddenOrHasHiddenAncestor }
    }
    @Test func gitReadStartsBeforeTheFirstGitSwitchAndIsNeverRepeated() throws {
        let (window, workbench) = host()
        let read = ReadState()
        workbench.readGit = { sink in
            read.asks += 1
            read.answer = sink
        }
        #expect(read.asks == 1)
        #expect(workbench.rail.active == .files)
        #expect(workbench.gitView.isHidden)
        #expect(
            !fields(workbench.rootItemsView).contains { $0.stringValue == GitSentences.readAtOpen })
        let deliver = try #require(read.answer)
        deliver(repository())
        workbench.layoutSubtreeIfNeeded()
        #expect(
            fields(workbench.rootItemsView).filter { $0.stringValue == GitSentences.readAtOpen }
                .count == 1)
        for entry in [RailEntry.git, .files, .git, .files] {
            workbench.rail.entryChosen?(entry)
        }
        workbench.readGit = { _ in read.asks += 1 }
        #expect(read.asks == 1)
        withExtendedLifetime(window) {}
    }
    @Test func repositoryCreatedBeforeTheFirstGitSwitchKeepsTheOpenTimePlainAnswer() {
        let (window, workbench) = host()
        let read = ReadState()
        workbench.readGit = { sink in
            read.asks += 1
            sink(read.nextAnswer)
        }
        #expect(read.asks == 1)
        read.nextAnswer = repository()
        workbench.rail.entryChosen?(.git)
        workbench.layoutSubtreeIfNeeded()
        #expect(read.asks == 1)
        #expect(fields(workbench.gitView).isEmpty)
        workbench.rail.entryChosen?(.files)
        workbench.layoutSubtreeIfNeeded()
        #expect(
            !fields(workbench.rootItemsView).contains {
                $0.stringValue == GitSentences.readAtOpen || $0.stringValue == "M"
            })
        withExtendedLifetime(window) {}
    }
}
