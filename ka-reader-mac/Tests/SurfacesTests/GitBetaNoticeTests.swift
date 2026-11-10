import AppKit
import Testing

@testable import Surfaces

@MainActor
struct GitBetaNoticeTests {
    private let notice =
        "The Git view and the letters beside changed files show the Git state KA-Reader read when you opened the folder. They do not update while KA-Reader is open."
    private var glyph: NSImage { NSImage(size: NSSize(width: 3, height: 3)) }
    private var glyphs: StatusGlyphs { StatusGlyphs(empty: glyph, failure: glyph) }
    private func tree(_ listing: RootListing = .observed([])) -> RootItemsView {
        let view = RootItemsView(
            folderGlyph: glyph, fileGlyph: glyph, fileCodeGlyph: glyph, statusGlyphs: glyphs,
            tooltipRest: TooltipRestDouble().rest, keyWindow: KeyWindowDouble().source)
        view.show(listing)
        return view
    }
    private func repository(_ state: RepositoryState = .normal, changed: Bool = false) -> GitItem {
        .repository(
            GitRepository(
                branch: .named("main"), state: state, staged: [],
                changed: changed ? [GitEntry(path: "空 白.txt", category: .modified)] : []))
    }
    private func fields(_ view: NSView) -> [NSTextField] {
        view.subviews.flatMap { child in
            (child as? NSTextField).map { [$0] } ?? fields(child)
        }.filter { !$0.isHiddenOrHasHiddenAncestor }
    }
    private func notices(_ view: NSView) -> [NSTextField] {
        fields(view).filter { $0.stringValue == notice }
    }
    private func rootPoint(_ label: NSTextField, in outline: NSOutlineView) -> NSPoint {
        label.convert(NSPoint(x: label.bounds.midX, y: label.bounds.midY), to: outline)
    }
    private func host(_ view: NSView, width: CGFloat = 260) -> NSWindow {
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: width, height: 500), styleMask: [.borderless],
            backing: .buffered, defer: true)
        window.contentView = view
        view.layoutSubtreeIfNeeded()
        return window
    }
    @Test func repositoryNoticeIsWholeBesideStatus() {
        for state in RepositoryState.allCases {
            for changed in [false, true] {
                let view = GitView(
                    statusGlyphs: glyphs, tooltipRest: TooltipRestDouble().rest,
                    keyWindow: KeyWindowDouble().source)
                let window = host(view)
                view.show(repository(state, changed: changed))
                #expect(notices(view).count == 1)
                #expect(fields(view).contains { $0.stringValue == "main" })
                #expect(fields(view).contains { $0.stringValue == "空 白.txt" } == changed)
                if state == .normal && changed {
                    #expect(
                        !fields(view).contains {
                            $0.stringValue == "Nothing has changed in this repository."
                        })
                }
                withExtendedLifetime(window) {}
            }
        }
    }
    @Test func treeNoticeIsAboveEntriesAndRootMessage() throws {
        for listing in [
            RootListing.observed([]),
            .observed([Entry(name: "空 白.txt", path: "空 白.txt", kind: .file, state: .observed)]),
            .failed(.unreadable),
        ] {
            for item in [
                repository(), repository(changed: true), .failed(.condition(.gitDirectoryMissing)),
            ] {
                let view = tree(listing)
                let window = host(view)
                view.showGit(item)
                view.layoutSubtreeIfNeeded()
                let label = try #require(notices(view).only)
                let frame = label.convert(label.bounds, to: view)
                let clip = view.contentView.frame
                #expect(frame.minX >= 0 && frame.maxX <= 260)
                #expect(view.isFlipped ? frame.maxY <= clip.minY : frame.minY >= clip.maxY)
                #expect(!label.isSelectable && !label.isEditable)
                #expect(label.target == nil && label.action == nil)
                let headerPoint = rootPoint(label, in: view.outlineView)
                #expect(view.outlineView.row(at: headerPoint) == -1)
                if let message = fields(view).first(where: {
                    $0.stringValue == ConditionSentences.emptyRoot
                        || $0.stringValue == ConditionSentences.failedRoot
                }) {
                    let messageFrame = message.convert(message.bounds, to: view)
                    #expect(
                        view.isFlipped
                            ? messageFrame.minY >= frame.maxY : messageFrame.maxY <= frame.minY)
                }

                let cell = try #require(label.cell)
                #expect(label.bounds.height >= cell.cellSize(forBounds: label.bounds).height)
                #expect(
                    view.outlineView.numberOfRows
                        == (listing == .observed([]) ? 0 : listing == .failed(.unreadable) ? 0 : 1))
                withExtendedLifetime(window) {}
            }
        }
    }
    @Test func replacementRemovesEarlierNoticeAndMarkers() {
        let faults: [GitItem] =
            [.pending, .plain, .stopped]
            + [
                GitCondition.probeRepositoryReadFailed, .notARoot, .repositoryReadFailed,
                .machineConfigNotSwitchedOff,
            ].map { .failed(.condition($0)) }
        for starting in [repository(changed: true), .failed(.condition(.gitDirectoryMissing))] {
            for replacement in faults {
                let git = GitView(
                    statusGlyphs: glyphs, tooltipRest: TooltipRestDouble().rest,
                    keyWindow: KeyWindowDouble().source)
                let root = tree(
                    .observed([
                        Entry(name: "空 白.txt", path: "空 白.txt", kind: .file, state: .observed)
                    ]))
                let windows = [host(git), host(root)]
                git.show(starting)
                root.showGit(starting)
                #expect(notices(git).count == 1 && notices(root).count == 1)
                #expect(
                    fields(root).contains { $0.stringValue == "M" }
                        == (starting == repository(changed: true)))
                git.show(replacement)
                root.showGit(replacement)
                #expect(notices(git).isEmpty && notices(root).isEmpty)
                #expect(!fields(root).contains { $0.stringValue == "M" })
                #expect(
                    fields(git).map(\.stringValue)
                        == (replacement == .plain
                            ? []
                            : replacement == .pending
                                ? ["Reading Git status."] : [GitSentences.fault]))
                withExtendedLifetime(windows) {}
            }
        }
    }
    @Test func observedFailureAndFaultHaveDifferentScopes() {
        let view = GitView(
            statusGlyphs: glyphs, tooltipRest: TooltipRestDouble().rest,
            keyWindow: KeyWindowDouble().source)
        let window = host(view)
        for condition in GitCondition.allCases {
            view.show(repository(changed: true))
            view.show(.failed(.condition(condition)))
            #expect(
                notices(view).count
                    == (GitFailure.condition(condition).hasObservedCondition ? 1 : 0))
            #expect(
                !fields(view).contains { ["main", "Changes", "空 白.txt"].contains($0.stringValue) })
        }
        withExtendedLifetime(window) {}
    }
    private func statusSlots(_ view: NSView) -> [StatusMessageView] {
        view.subviews.flatMap { child in
            (child as? StatusMessageView).map { [$0] } ?? statusSlots(child)
        }.filter { !$0.isHiddenOrHasHiddenAncestor }
    }
    /// CP-1262/CP-1263 (design § 3A): the notice sits outside the failure component. An observed
    /// condition's slot holds its message alone, and a fault's slot is the only thing drawn.
    @Test func observedFailureNoticeSitsOutsideItsConditionSlot() throws {
        let observed: [GitFailure] =
            [
                .gitDirectoryOutside(gitDirectory: "/elsewhere/.git"),
                .configNamesOutside(key: "core.excludesfile", path: "../空 白"),
                .configNotLocated(key: "include.path", path: "~/空 白"),
                .objectStoreNamesOutside(path: "../objects"),
                .objectStoreNotLocated(path: "relative/objects"),
                .submoduleElsewhere(name: "空 白", path: "elsewhere"),
            ]
            + [
                GitCondition.probeFolderUnavailable, .probeGitDirectoryUnreadable,
                .probeGitEntryNotDirectory, .probeGitFileUnreadable, .gitDirectoryMissing,
                .gitDirectoryUnreadable, .notARepository, .gitmodulesUnreadable,
            ].map { .condition($0) }
        let faults: [GitItem] =
            [
                GitCondition.probeRepositoryReadFailed, .notARoot, .repositoryReadFailed,
                .machineConfigNotSwitchedOff,
            ].map { .failed(.condition($0)) } + [.stopped]
        let view = GitView(
            statusGlyphs: glyphs, tooltipRest: TooltipRestDouble().rest,
            keyWindow: KeyWindowDouble().source)
        let window = host(view)
        for failure in observed {
            view.show(repository(changed: true))
            view.show(.failed(failure))
            let slot = try #require(statusSlots(view).only, "\(failure)")
            let notice = try #require(notices(view).only, "\(failure)")
            #expect(
                fields(slot).map(\.stringValue) == [GitSentences.failure(failure)], "\(failure)")
            #expect(!notice.isDescendant(of: slot), "\(failure)")
        }
        for item in faults {
            view.show(repository(changed: true))
            view.show(item)
            let slot = try #require(statusSlots(view).only, "\(item)")
            #expect(fields(slot).map(\.stringValue) == [GitSentences.fault], "\(item)")
            #expect(fields(view).map(\.stringValue) == [GitSentences.fault], "\(item)")
        }
        withExtendedLifetime(window) {}
    }
    @Test func acceptedGitAnswerUpdatesBothSurfacesOnce() {
        let root = tree()
        let view = WorkbenchView(
            rootItemsView: root, statusGlyphs: glyphs, railFolderGlyph: glyph, railGitGlyph: glyph,
            keyWindow: KeyWindowDouble().source)
        let window = host(view, width: 800)
        var asks = 0
        var sink: GitAnswer?
        view.readGit = {
            asks += 1
            sink = $0
        }
        view.rail.entryChosen?(.git)
        sink?(repository(changed: true))
        #expect(notices(view.gitView).count == 1)
        view.rail.entryChosen?(.files)
        #expect(notices(root).count == 1)
        sink?(.plain)
        for _ in 0..<3 {
            view.rail.entryChosen?(.git)
            view.rail.entryChosen?(.files)
        }
        #expect(asks == 1 && notices(root).count == 1)
        view.rail.entryChosen?(.git)
        #expect(notices(view.gitView).count == 1)
        #expect(view.subviews.count == 3 && view.sidebar.bounds.width == 260)
        withExtendedLifetime(window) {}
    }
    @Test func bothSentencesFitTheActualSidebar() throws {
        for item in [repository(), .failed(.configNotLocated(key: "include.path", path: "空 白"))] {
            let git = GitView(
                statusGlyphs: glyphs, tooltipRest: TooltipRestDouble().rest,
                keyWindow: KeyWindowDouble().source)
            let window = host(git)
            git.show(item)
            git.layoutSubtreeIfNeeded()
            let label = try #require(notices(git).only)
            let frame = label.convert(label.bounds, to: git)
            #expect(frame.minX >= 0 && frame.maxX <= 260)
            let cell = try #require(label.cell)
            #expect(label.bounds.height >= cell.cellSize(forBounds: label.bounds).height)
            #expect(
                !label.isEditable && !label.isSelectable && label.target == nil
                    && label.action == nil)
            let others = fields(git).filter { $0 !== label }
            #expect(others.allSatisfy { $0.convert($0.bounds, to: git).maxY <= frame.minY })
            var activated = 0
            git.rowActivated = { _ in activated += 1 }
            let event = try #require(
                NSEvent.mouseEvent(
                    with: .leftMouseDown,
                    location: label.convert(
                        NSPoint(x: label.bounds.midX, y: label.bounds.midY), to: nil),
                    modifierFlags: [], timestamp: 0, windowNumber: window.windowNumber,
                    context: nil, eventNumber: 0, clickCount: 1, pressure: 1))
            git.mouseDown(with: event)
            #expect(activated == 0)
            withExtendedLifetime(window) {}
        }
    }
    @Test func listingAndDisclosureKeepTheHeldObservation() throws {
        let entries =
            [Entry(name: "src", path: "src", kind: .folder, state: .pending)]
            + (0..<200).map {
                Entry(name: "file\($0)", path: "file\($0)", kind: .file, state: .observed)
            }
        let root = tree(.observed(entries))
        let window = host(root)
        root.showGit(repository(changed: true))
        let folder = try #require(root.outlineView.item(atRow: 0) as AnyObject?)
        var reads = 0
        root.listTree = { path, act, answer in
            if act == .expand {
                reads += 1
                answer(
                    .observed([
                        Entry(name: "child", path: "src/child", kind: .file, state: .observed)
                    ]))
            }
        }
        root.outlineView.expandItem(folder)
        #expect(reads == 1 && root.outlineView.isItemExpanded(folder))
        root.outlineView.selectRowIndexes(IndexSet(integer: 1), byExtendingSelection: false)
        root.markOpenFile(path: "src/child")
        let label = try #require(notices(root).only)
        root.layoutSubtreeIfNeeded()
        let before = label.convert(label.bounds, to: root)
        root.outlineView.scrollRowToVisible(190)
        root.layoutSubtreeIfNeeded()
        #expect(label.convert(label.bounds, to: root) == before)
        root.apply(changes: [
            (
                path: "src",
                listing: .observed([
                    Entry(name: "child", path: "src/child", kind: .file, state: .observed),
                    Entry(name: "new", path: "src/new", kind: .file, state: .observed),
                ])
            )
        ])
        #expect(root.outlineView.item(atRow: 0) as AnyObject? === folder)
        #expect(root.outlineView.isItemExpanded(folder))
        #expect(root.barPaths() == ["src/child"])
        root.outlineView.scrollRowToVisible(1)
        root.layoutSubtreeIfNeeded()
        let row = root.outlineView.rect(ofRow: 1)
        #expect(root.outlineView.row(at: NSPoint(x: row.midX, y: row.midY)) == 1)
        root.outlineView.collapseItem(folder)
        #expect(notices(root).count == 1 && reads == 1)
        withExtendedLifetime(window) {}
    }
    @Test func plainTreeKeepsReadableNamesAfterAListingUpdate() throws {
        let root = tree(
            .observed([Entry(name: "a.txt", path: "a.txt", kind: .file, state: .observed)]))
        let view = WorkbenchView(
            rootItemsView: root, statusGlyphs: glyphs, railFolderGlyph: glyph, railGitGlyph: glyph,
            keyWindow: KeyWindowDouble().source)
        let window = host(view, width: 800)
        view.readGit = { $0(.plain) }
        view.rail.entryChosen?(.git)
        root.apply(changes: [
            (
                path: "",
                listing: .observed([
                    Entry(name: "a.txt", path: "a.txt", kind: .file, state: .observed),
                    Entry(name: "new.txt", path: "new.txt", kind: .file, state: .observed),
                ])
            )
        ])
        view.rail.entryChosen?(.files)
        root.tile()
        view.layoutSubtreeIfNeeded()
        for row in 0..<2 {
            let cell = try #require(
                root.outlineView.view(atColumn: 0, row: row, makeIfNecessary: true)
                    as? NSTableCellView)
            let label = try #require(unsafe cell.textField)
            #expect(label.bounds.width >= label.intrinsicContentSize.width)
        }
        withExtendedLifetime(window) {}
    }
    @Test func aNewWorkbenchClearsAReusedTreesObservation() {
        let root = tree()
        root.showGit(repository())
        let view = WorkbenchView(
            rootItemsView: root, statusGlyphs: glyphs, railFolderGlyph: glyph, railGitGlyph: glyph,
            keyWindow: KeyWindowDouble().source)
        let window = host(view, width: 800)
        #expect(notices(root).isEmpty)
        #expect(fields(view.gitView).isEmpty)
        withExtendedLifetime(window) {}
    }
    @Test func followedPolicySuppressesBothActualViews() {
        let root = tree()
        let git = GitView(
            statusGlyphs: glyphs, tooltipRest: TooltipRestDouble().rest,
            keyWindow: KeyWindowDouble().source, gitReadPolicy: .followed)
        let windows = [host(root), host(git)]
        for item in [
            repository(), .failed(.condition(.gitDirectoryMissing)), .plain,
            repository(changed: true),
        ] {
            root.showGit(repository())
            root.showGit(item, policy: .followed)
            git.show(item)
            #expect(notices(root).isEmpty && notices(git).isEmpty)
        }
        let workbench = WorkbenchView(
            rootItemsView: root, statusGlyphs: glyphs, railFolderGlyph: glyph, railGitGlyph: glyph,
            keyWindow: KeyWindowDouble().source, gitReadPolicy: .followed)
        let window = host(workbench, width: 800)
        var asks = 0
        workbench.readGit = {
            asks += 1
            $0(repository())
        }
        workbench.rail.entryChosen?(.git)
        #expect(notices(workbench.gitView).isEmpty)
        workbench.rail.entryChosen?(.files)
        #expect(notices(root).isEmpty && asks == 1)
        withExtendedLifetime((windows, window)) {}
    }
}

extension Array {
    fileprivate var only: Element? { count == 1 ? first : nil }
}
