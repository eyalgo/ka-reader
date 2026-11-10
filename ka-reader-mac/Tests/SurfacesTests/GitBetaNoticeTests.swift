import AppKit
import Testing

@testable import Surfaces

@MainActor
struct GitBetaNoticeTests {
    private let notice = "The Git view and the letters beside changed files show the Git state KA-Reader read when you opened the folder. They do not update while KA-Reader is open."
    private var glyph: NSImage { NSImage(size: NSSize(width: 3, height: 3)) }
    private var glyphs: StatusGlyphs { StatusGlyphs(empty: glyph, failure: glyph) }
    private func tree(_ listing: RootListing = .observed([])) -> RootItemsView {
        let view = RootItemsView(folderGlyph: glyph, fileGlyph: glyph, fileCodeGlyph: glyph, statusGlyphs: glyphs)
        view.show(listing)
        return view
    }
    private func repository(_ state: RepositoryState = .normal, changed: Bool = false) -> GitItem {
        .repository(GitRepository(branch: .named("main"), state: state, staged: [], changed: changed ? [GitEntry(path: "空 白.txt", category: .modified)] : []))
    }
    private func fields(_ view: NSView) -> [NSTextField] {
        view.subviews.flatMap { child in
            (child as? NSTextField).map { [$0] } ?? fields(child)
        }.filter { !$0.isHiddenOrHasHiddenAncestor }
    }
    private func notices(_ view: NSView) -> [NSTextField] { fields(view).filter { $0.stringValue == notice } }
    private func host(_ view: NSView, width: CGFloat = 260) -> NSWindow {
        let window = NSWindow(contentRect: NSRect(x: 0, y: 0, width: width, height: 500), styleMask: [.borderless], backing: .buffered, defer: true)
        window.contentView = view
        view.layoutSubtreeIfNeeded()
        return window
    }
    @Test func repositoryNoticeIsWholeBesideStatus() {
        for state in RepositoryState.allCases {
            for changed in [false, true] {
                let view = GitView(statusGlyphs: glyphs)
                let window = host(view)
                view.show(repository(state, changed: changed))
                #expect(notices(view).count == 1)
                #expect(fields(view).contains { $0.stringValue == "main" })
                #expect(fields(view).contains { $0.stringValue == "空 白.txt" } == changed)
                if state == .normal && changed {
                    #expect(!fields(view).contains { $0.stringValue == "Nothing has changed in this repository." })
                }
                withExtendedLifetime(window) {}
            }
        }
    }
    @Test func treeNoticeIsAboveEntriesAndRootMessage() throws {
        for listing in [RootListing.observed([]), .observed([Entry(name: "空 白.txt", path: "空 白.txt", kind: .file, state: .observed)]), .failed(.unreadable)] {
            for item in [repository(), repository(changed: true), .failed(.condition(.gitDirectoryMissing))] {
                let view = tree(listing)
                let window = host(view)
                view.showGit(item)
                view.layoutSubtreeIfNeeded()
                let label = try #require(notices(view).only)
                let frame = label.convert(label.bounds, to: view)
                let clip = view.contentView.frame
                #expect(frame.minX >= 0 && frame.maxX <= 260)
                #expect(frame.minY >= clip.maxY)
                #expect(!label.isSelectable && !label.isEditable)
                #expect(label.bounds.height >= label.cell!.cellSize(forBounds: label.bounds).height)
                #expect(view.outlineView.numberOfRows == (listing == .observed([]) ? 0 : listing == .failed(.unreadable) ? 0 : 1))
                withExtendedLifetime(window) {}
            }
        }
    }
    @Test func replacementRemovesEarlierNoticeAndMarkers() {
        let faults: [GitItem] = [.pending, .plain, .stopped] + [GitCondition.probeRepositoryReadFailed, .notARoot, .repositoryReadFailed, .machineConfigNotSwitchedOff].map { .failed(.condition($0)) }
        for starting in [repository(changed: true), .failed(.condition(.gitDirectoryMissing))] {
            for replacement in faults {
                let git = GitView(statusGlyphs: glyphs)
                let root = tree()
                let windows = [host(git), host(root)]
                git.show(starting); root.showGit(starting)
                #expect(notices(git).count == 1 && notices(root).count == 1)
                git.show(replacement); root.showGit(replacement)
                #expect(notices(git).isEmpty && notices(root).isEmpty)
                #expect(fields(git).map(\.stringValue) == (replacement == .plain ? [] : replacement == .pending ? ["Reading Git status."] : [GitSentences.fault]))
                withExtendedLifetime(windows) {}
            }
        }
    }
    @Test func observedFailureAndFaultHaveDifferentScopes() {
        let view = GitView(statusGlyphs: glyphs)
        let window = host(view)
        for condition in GitCondition.allCases {
            view.show(repository(changed: true))
            view.show(.failed(.condition(condition)))
            #expect(notices(view).count == (GitFailure.condition(condition).hasObservedCondition ? 1 : 0))
            #expect(!fields(view).contains { ["main", "Changes", "空 白.txt"].contains($0.stringValue) })
        }
        withExtendedLifetime(window) {}
    }
    @Test func acceptedGitAnswerUpdatesBothSurfacesOnce() {
        let root = tree()
        let view = WorkbenchView(rootItemsView: root, statusGlyphs: glyphs, railFolderGlyph: glyph, railGitGlyph: glyph)
        let window = host(view, width: 800)
        var asks = 0
        var sink: GitAnswer?
        view.readGit = { asks += 1; sink = $0 }
        view.rail.entryChosen?(.git)
        sink?(repository(changed: true))
        #expect(notices(view.gitView).count == 1)
        view.rail.entryChosen?(.files)
        #expect(notices(root).count == 1)
        sink?(.plain)
        for _ in 0..<3 { view.rail.entryChosen?(.git); view.rail.entryChosen?(.files) }
        #expect(asks == 1 && notices(root).count == 1)
        view.rail.entryChosen?(.git)
        #expect(notices(view.gitView).count == 1)
        #expect(view.subviews.count == 3 && view.sidebar.bounds.width == 260)
        withExtendedLifetime(window) {}
    }
    @Test func followedPolicySuppressesBothActualViews() {
        let root = tree()
        let git = GitView(statusGlyphs: glyphs, gitReadPolicy: .followed)
        let windows = [host(root), host(git)]
        for item in [repository(), .failed(.condition(.gitDirectoryMissing)), .plain, repository(changed: true)] {
            root.showGit(repository())
            root.showGit(item, policy: .followed)
            git.show(item)
            #expect(notices(root).isEmpty && notices(git).isEmpty)
        }
        let workbench = WorkbenchView(rootItemsView: root, statusGlyphs: glyphs, railFolderGlyph: glyph, railGitGlyph: glyph, gitReadPolicy: .followed)
        let window = host(workbench, width: 800)
        var asks = 0
        workbench.readGit = { asks += 1; $0(repository()) }
        workbench.rail.entryChosen?(.git)
        #expect(notices(workbench.gitView).isEmpty)
        workbench.rail.entryChosen?(.files)
        #expect(notices(root).isEmpty && asks == 1)
        withExtendedLifetime((windows, window)) {}
    }
}

private extension Array {
    var only: Element? { count == 1 ? first : nil }
}
