import AppKit
import Shell
import Surfaces
import Testing
import XCTest

/// The Git view through `LaunchFlow` into the product's window: the fifth bridge call, the
/// buffer's release, the decoded answer drawn, and the calls a session makes (CP-566, and the
/// shell's half of CP-553 and CP-561).
@MainActor
final class LaunchFlowGitTests: LaunchWindowTestCase {
    private let betaNotice =
        "The Git view and the letters beside changed files show the Git state KA-Reader read when you opened the folder. They do not update while KA-Reader is open."
    private static let chosenFolder = URL(
        fileURLWithPath: "/Users/someone/notes", isDirectory: true)

    private static let rootAnswer = Data(
        (#"{"state":"observed","entries":["#
            + #"{"name":"a.txt","path":"a.txt","kind":"file","state":"observed","language":"plain"}]}"#)
            .utf8)

    private static let repositoryAnswer = Data(
        (#"{"state":"observed","kind":"root","branch":{"kind":"branch","name":"main"},"#
            + #""repository_state":"normal","staged":[],"#
            + #""changed":[{"path":"a.txt","category":"modified"}]}"#).utf8)

    private static let faultSentence =
        "KA-Reader stopped while reading this repository's Git status and can't tell why. The file tree is unaffected. Start KA-Reader again to read the status again."

    private func launch(git: Data?) -> WindowLaunch {
        let launch = makeLaunch(answers: [Self.chosenFolder])
        launch.bridge.listAnswer = Self.rootAnswer
        launch.bridge.gitAnswer = git
        launch.flow.run()
        return launch
    }

    private func workbench(of launch: WindowLaunch) throws -> WorkbenchView {
        let view = try XCTUnwrap(launch.presenter.contents.last as? WorkbenchView)
        layOut(try laidOutWindow(of: view))
        return view
    }

    private func choose(_ entry: RailEntry, in workbench: WorkbenchView) {
        workbench.rail.entryChosen?(entry)
        unsafe layOut(workbench.window ?? NSWindow())
    }

    private func strings(in workbench: WorkbenchView) -> [String] {
        textElements(beneath: workbench.gitView).map(\.stringValue)
    }

    /// A real mouse press on the Git view over the text element showing `text`.
    private func click(_ text: String, in workbench: WorkbenchView) throws {
        let element = try XCTUnwrap(
            textElements(beneath: workbench.gitView).first { $0.stringValue == text },
            "no element showing \(text)")
        let frame = element.convert(element.bounds, to: workbench.gitView)
        let event = unsafe NSEvent.mouseEvent(
            with: .leftMouseDown,
            location: workbench.gitView.convert(NSPoint(x: frame.midX, y: frame.midY), to: nil),
            modifierFlags: [], timestamp: 0, windowNumber: workbench.window?.windowNumber ?? 0,
            context: nil, eventNumber: 0, clickCount: 1, pressure: 1)
        workbench.gitView.mouseDown(with: try XCTUnwrap(event, "no event"))
    }

    func test_showingGitCallsReadGitOnceThroughTheReaderFreesItsBufferAndDrawsTheDecodedAnswer()
        throws
    {
        let reader = HoldingReadRunner()
        let launch = makeLaunch(answers: [Self.chosenFolder], reader: reader)
        launch.bridge.listAnswer = Self.rootAnswer
        launch.bridge.gitAnswer = Self.repositoryAnswer
        launch.flow.run()
        reader.release(0)
        let workbench = try workbench(of: launch)

        choose(.git, in: workbench)

        XCTAssertEqual(launch.bridge.gitReadCount, 0, "the read is held by the reader")
        XCTAssertEqual(reader.heldReads, 2, "the open's read, then the Git read")

        if reader.heldReads > 1 { reader.release(1) }
        unsafe layOut(try XCTUnwrap(workbench.window))

        XCTAssertEqual(launch.bridge.gitReadCount, 1)
        XCTAssertEqual(launch.bridge.log.events.filter { $0 == "read_git" }.count, 1)
        XCTAssertEqual(
            Set(launch.bridge.freed), Set(launch.bridge.handedOut), "every buffer is released")
        XCTAssertEqual(launch.bridge.freed.count, launch.bridge.handedOut.count)
        XCTAssertTrue(strings(in: workbench).contains("a.txt"), "\(strings(in: workbench))")
    }

    /// CP-695: wire bytes to the drawn failure slot for the two config observations. The shell hands
    /// the answer down with all three members and decides nothing about it (CP-688).
    func test_aNotLocatedConfigAnswerDrawsItsMessageAndAnOutsideOneKeepsItsSentence() throws {
        let notLocated = Data(
            (#"{"state":"failed","condition":"config_not_located","#
                + #""key":"core.excludesfile","path":"ignore-rel"}"#).utf8)
        let launch = launch(git: notLocated)
        let workbench = try workbench(of: launch)

        choose(.git, in: workbench)

        let drawn = strings(in: workbench)
        XCTAssertEqual(
            drawn,
            [
                betaNotice,
                "When you opened the folder, KA-Reader found core.excludesfile set to ignore-rel and didn't work out where that path leads, so it didn't read the folder's Git status. The file tree and the reading panel are unaffected. Start KA-Reader again to read the status again.",
            ])
        XCTAssertTrue(drawn[1].contains("core.excludesfile") && drawn[1].contains("ignore-rel"))
        XCTAssertEqual(drawn[1].lowercased().components(separatedBy: "outside").count - 1, 0)

        let outside = Data(
            (#"{"state":"failed","condition":"config_names_outside","#
                + #""key":"core.excludesfile","path":"ignore-rel"}"#).utf8)
        let outsideLaunch = self.launch(git: outside)
        let outsideWorkbench = try self.workbench(of: outsideLaunch)

        choose(.git, in: outsideWorkbench)

        XCTAssertEqual(
            strings(in: outsideWorkbench),
            [
                betaNotice,
                "When you opened the folder, KA-Reader found core.excludesfile set to ignore-rel, outside the folder you opened, so it didn't read the folder's Git status. The file tree and the reading panel are unaffected. Start KA-Reader again to read the status again.",
            ])
    }

    /// CP-711: wire bytes to the drawn failure slot for the two alternates observations. The shell
    /// hands the answer down with its one member and decides nothing about it.
    func test_aNotLocatedObjectStoreAnswerDrawsItsMessageAndAnOutsideOneKeepsItsSentence() throws {
        let notLocated = Data(
            (#"{"state":"failed","condition":"object_store_not_located","#
                + #""path":"relative/objects"}"#).utf8)
        let launch = launch(git: notLocated)
        let workbench = try workbench(of: launch)

        choose(.git, in: workbench)

        let drawn = strings(in: workbench)
        XCTAssertEqual(
            drawn,
            [
                betaNotice,
                "When you opened the folder, KA-Reader found a Git object store that names relative/objects but didn't work out where that path leads, so it didn't read the folder's Git status. The file tree and the reading panel are unaffected. Start KA-Reader again to read the status again.",
            ])
        XCTAssertTrue(drawn[1].contains("relative/objects"))
        XCTAssertEqual(drawn[1].lowercased().components(separatedBy: "outside").count - 1, 0)

        let outside = Data(
            (#"{"state":"failed","condition":"object_store_names_outside","#
                + #""path":"relative/objects"}"#).utf8)
        let outsideLaunch = self.launch(git: outside)
        let outsideWorkbench = try self.workbench(of: outsideLaunch)

        choose(.git, in: outsideWorkbench)

        XCTAssertEqual(
            strings(in: outsideWorkbench),
            [
                betaNotice,
                "When you opened the folder, KA-Reader found a Git object store that names relative/objects, outside the folder you opened, so it didn't read the folder's Git status. The file tree and the reading panel are unaffected. Start KA-Reader again to read the status again.",
            ])
    }

    /// CP-733: wire bytes to the drawn failure slot for a section whose path leads elsewhere.
    func test_aSubmoduleElsewhereWireAnswerIsDrawnAsTheMessageCarryingBothValuesWithNoOutside()
        throws
    {
        let answer = Data(
            (#"{"state":"failed","condition":"submodule_elsewhere","#
                + #""name":"submodule","path":"evil"}"#).utf8)
        let launch = launch(git: answer)
        let workbench = try workbench(of: launch)

        choose(.git, in: workbench)

        let drawn = strings(in: workbench)
        XCTAssertEqual(
            drawn,
            [
                betaNotice,
                "When you opened the folder, KA-Reader found that a .gitmodules gives the submodule at submodule the path evil, which leads somewhere else, so it didn't read the folder's Git status. The file tree and the reading panel are unaffected. Start KA-Reader again to read the status again.",
            ])
        XCTAssertEqual(drawn[1].lowercased().components(separatedBy: "outside").count - 1, 0)
    }

    /// CP-726: an answer short of a member is not drawn as a message; it draws the fault sentence.
    func test_aSubmoduleElsewhereAnswerMissingNameOrPathDrawsTheFaultSentence() throws {
        let missing = [
            #"{"state":"failed","condition":"submodule_elsewhere","path":"evil"}"#,
            #"{"state":"failed","condition":"submodule_elsewhere","name":"submodule"}"#,
        ]
        for payload in missing {
            let launch = launch(git: Data(payload.utf8))
            let workbench = try workbench(of: launch)

            choose(.git, in: workbench)

            XCTAssertTrue(
                strings(in: workbench).contains(Self.faultSentence),
                "\(payload): \(strings(in: workbench))")
        }
    }

    func test_aNullReadGitDrawsTheFaultAndTheTreeStaysReachable() throws {
        let launch = launch(git: nil)
        let workbench = try workbench(of: launch)

        choose(.git, in: workbench)

        XCTAssertEqual(launch.bridge.gitReadCount, 1)
        XCTAssertTrue(
            strings(in: workbench).contains(Self.faultSentence), "\(strings(in: workbench))")
        XCTAssertTrue(launch.bridge.freed.count == launch.bridge.handedOut.count)

        choose(.files, in: workbench)

        XCTAssertFalse(workbench.rootItemsView.isHiddenOrHasHiddenAncestor)
        XCTAssertTrue(workbench.gitView.isHiddenOrHasHiddenAncestor)
    }

    /// The status letters the tree draws: the text elements the tree's rows carry as `treeRowLetter`.
    private func treeLetters(in workbench: WorkbenchView) -> [String] {
        textElements(beneath: workbench.rootItemsView)
            .filter { $0.identifier?.rawValue == "treeRowLetter" }.map(\.stringValue)
    }

    func test_aMissingReadGitBufferMarksNoTreeRow() throws {
        let launch = launch(git: nil)
        let workbench = try workbench(of: launch)

        choose(.git, in: workbench)
        choose(.files, in: workbench)

        XCTAssertEqual(launch.bridge.gitReadCount, 1, "the read was delivered")
        XCTAssertTrue(
            textElements(beneath: workbench.rootItemsView).map(\.stringValue).contains("a.txt"),
            "the tree is drawn")
        XCTAssertEqual(treeLetters(in: workbench), [])
    }

    func test_aNonConformingReadGitAnswerMarksNoTreeRow() throws {
        let nonConforming = Data(
            (#"{"state":"observed","kind":"root","branch":{"kind":"branch","name":"main"},"#
                + #""repository_state":"normal","staged":[],"#
                + #""changed":[{"path":"a.txt","category":"copied"}]}"#).utf8)
        let launch = launch(git: nonConforming)
        let workbench = try workbench(of: launch)

        choose(.git, in: workbench)
        choose(.files, in: workbench)

        XCTAssertEqual(launch.bridge.gitReadCount, 1, "the read was delivered")
        XCTAssertTrue(
            textElements(beneath: workbench.rootItemsView).map(\.stringValue).contains("a.txt"),
            "the tree is drawn")
        XCTAssertEqual(treeLetters(in: workbench), [])
    }

    func test_switchingBackToGitCallsNothing() throws {
        let launch = launch(git: Self.repositoryAnswer)
        let workbench = try workbench(of: launch)
        choose(.git, in: workbench)
        let before = launch.bridge.log.events

        choose(.files, in: workbench)
        choose(.git, in: workbench)

        XCTAssertEqual(launch.bridge.gitReadCount, 1)
        XCTAssertEqual(launch.bridge.log.events, before, "switching calls nothing")
        XCTAssertTrue(strings(in: workbench).contains("a.txt"))
    }

    func test_aGitRowCallsSelectFileWithTheRowsPath() throws {
        let launch = launch(git: Self.repositoryAnswer)
        let workbench = try workbench(of: launch)
        choose(.git, in: workbench)

        try click("a.txt", in: workbench)

        XCTAssertEqual(launch.bridge.selectedPaths, ["a.txt", "a.txt"])
    }

    func test_theBufferIsDecodedAndFreedOffTheMainThread() async throws {
        let bridge = ThreadRecordingBridge(
            listAnswers: ["": Self.rootAnswer], gitAnswer: Self.repositoryAnswer)
        let log = EventLog()
        let presenter = FakeWindowPresenter()
        let runner = DeliveryRecordingReadRunner()
        let delivered = expectation(description: "the workbench was delivered")
        presenter.onPresent = { content in
            if content is WorkbenchView { delivered.fulfill() }
        }
        let flow = LaunchFlow(
            panel: FakePanel(answers: [Self.chosenFolder], log: log), bridge: bridge,
            glyphs: FakeGlyphSource(), presenter: presenter, reader: runner, terminate: {})
        flow.run()
        await fulfillment(of: [delivered], timeout: 10)
        let workbench = try XCTUnwrap(presenter.contents.last as? WorkbenchView)

        let gitDelivered = expectation(description: "the Git item was delivered")
        runner.onDelivery = { gitDelivered.fulfill() }
        workbench.rail.entryChosen?(.git)
        await fulfillment(of: [gitDelivered], timeout: 10)

        XCTAssertEqual(bridge.ranOnMain("read_git"), [false])
        XCTAssertEqual(bridge.ranOnMain("free:git"), [false])
        XCTAssertEqual(runner.deliveriesOnMain.last, true, "only the decoded item crosses back")
    }

    func test_acrossASessionTheLoggedCallsAreOnlyOpenFolderListTreeSelectFileReadGitAndFree()
        throws
    {
        let launch = launch(git: Self.repositoryAnswer)
        let workbench = try workbench(of: launch)
        choose(.git, in: workbench)
        try click("a.txt", in: workbench)
        choose(.files, in: workbench)
        choose(.git, in: workbench)

        let allowed: Set<String> = [
            "panel", "open_folder", "list_tree", "select_file", "read_git", "free",
        ]
        let logged = launch.bridge.log.events
        XCTAssertTrue(Set(logged).isSubset(of: allowed), "\(logged)")
        for call in ["open_folder", "list_tree", "select_file", "read_git"] {
            XCTAssertTrue(logged.contains(call), "no \(call) in \(logged)")
        }
    }
}

@MainActor
struct GitBetaLaunchTests {
    private let notice =
        "The Git view and the letters beside changed files show the Git state KA-Reader read when you opened the folder. They do not update while KA-Reader is open."
    private let repository = Data(
        #"{"state":"observed","kind":"root","branch":{"kind":"branch","name":"main"},"repository_state":"normal","staged":[],"changed":[{"path":"a.txt","category":"modified"}]}"#
            .utf8)
    private func text(_ view: NSView) -> [String] {
        view.subviews.flatMap { child in
            (child as? NSTextField).map { [$0.stringValue] } ?? text(child)
        }
    }
    private func exercise(_ answer: Data, expectsNotice: Bool, plain: Bool = false) async throws {
        createTheSharedApplication()
        let log = EventLog()
        let bridge = RecordingBridge(log: log)
        bridge.listAnswer = Data(
            #"{"state":"observed","entries":[{"name":"a.txt","path":"a.txt","kind":"file","state":"observed","language":"plain"}]}"#
                .utf8)
        bridge.gitAnswer = answer
        bridge.selectAnswers = [
            "a.txt": Data(#"{"state":"text","content":"before","language":"plain"}"#.utf8)
        ]
        let presenter = FakeWindowPresenter()
        let reader = HoldingReadRunner()
        let main = HeldMainDelivery()
        let flow = LaunchFlow(
            panel: FakePanel(answers: [URL(fileURLWithPath: "/notes")], log: log), bridge: bridge,
            glyphs: FakeGlyphSource(), presenter: presenter, reader: reader,
            treeActs: InlineReadRunner(), main: main, terminate: {})
        flow.run()
        reader.release(0)
        let view = try #require(presenter.contents.last as? WorkbenchView)
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 900, height: 500), styleMask: [.borderless],
            backing: .buffered, defer: true)
        window.contentView = view
        view.layoutSubtreeIfNeeded()
        view.rail.entryChosen?(.git)
        reader.release(1)
        view.layoutSubtreeIfNeeded()
        let gitBefore = text(view.gitView)
        #expect(gitBefore.filter { $0 == notice }.count == (expectsNotice ? 1 : 0))
        #expect(gitBefore.isEmpty == plain)
        #expect(!gitBefore.contains { $0.contains("INTERNAL-DO-NOT-DRAW") })
        if !expectsNotice && !plain { #expect(gitBefore == [GitSentences.fault]) }
        view.rail.entryChosen?(.files)
        #expect(text(view.rootItemsView).filter { $0 == notice }.count == (expectsNotice ? 1 : 0))
        view.rootItemsView.outlineView.selectRowIndexes(
            IndexSet(integer: 0), byExtendingSelection: false)
        reader.release(2)
        #expect(view.readingPanel.contentView.string == "before")
        let receiver = try #require(bridge.receivers.last ?? nil)
        let reports =
            plain
            ? ["repository created", "edit", "staging", "commit", "root disappeared"]
            : ["edit", "staging", "commit", "root disappeared", "condition cleared"]
        for (index, event) in reports.enumerated() {
            switch event {
            case "staging":
                bridge.gitAnswer = Data(
                    #"{"state":"observed","kind":"root","branch":{"kind":"branch","name":"main"},"repository_state":"normal","staged":[{"path":"a.txt","category":"modified"}],"changed":[]}"#
                        .utf8)
            case "commit", "condition cleared":
                bridge.gitAnswer = Data(
                    #"{"state":"observed","kind":"root","branch":{"kind":"branch","name":"main"},"repository_state":"normal","staged":[],"changed":[]}"#
                        .utf8)
            case "root disappeared":
                bridge.gitAnswer = Data(#"{"state":"observed","kind":"plain"}"#.utf8)
            default:
                bridge.gitAnswer = repository
            }
            let handle = UInt(900 + index)
            let payload = Data(
                #"{"listings":[{"path":"","answer":{"state":"observed","entries":[{"name":"a.txt","path":"a.txt","kind":"file","state":"observed","language":"plain"},{"name":"new.txt","path":"new.txt","kind":"file","state":"observed","language":"plain"}]}}],"open_file":{"revision":\#(index + 1),"path":"a.txt","position":"line=0;x=0","answer":{"state":"text","content":"\#(event)","language":"plain"}}}"#
                    .utf8)
            await withCheckedContinuation { done in
                DispatchQueue.global().async {
                    receiver.take(BridgeBuffer(payload: payload, handle: handle))
                    done.resume()
                }
            }
            main.releaseAll()
            view.layoutSubtreeIfNeeded()
            #expect(view.rootItemsView.outlineView.numberOfRows == 2)
            #expect(view.readingPanel.contentView.string == event)
            #expect(
                text(view.rootItemsView).filter { $0 == notice }.count == (expectsNotice ? 1 : 0))
            #expect(text(view.rootItemsView).contains("M") == (answer == repository))
            view.rail.entryChosen?(.git)
            #expect(text(view.gitView) == gitBefore)
            view.rail.entryChosen?(.files)
            #expect(bridge.gitReadCount == 1)
            #expect(bridge.freed.filter { $0 == handle }.count == 1)
        }
        for buffer in bridge.handedOut { #expect(bridge.freed.filter { $0 == buffer }.count == 1) }
        #expect(bridge.freed.count == bridge.handedOut.count + 5)
        withExtendedLifetime((window, flow)) {}
    }
    @Test func diskChangesDoNotRelabelGitWhileFileAndTreeAdvance() async throws {
        try await exercise(repository, expectsNotice: true)
        try await exercise(
            Data(#"{"state":"failed","condition":"git_directory_missing"}"#.utf8),
            expectsNotice: true)
    }
    @Test func repositoryCreatedAfterPlainAnswerStaysPlain() async throws {
        try await exercise(
            Data(#"{"state":"observed","kind":"plain"}"#.utf8), expectsNotice: false, plain: true)
    }
    @Test func diagnosticBearingAnswersDrawFaultAloneAndKeepRoutes() async throws {
        try await exercise(
            Data(
                #"{"state":"failed","condition":"git_directory_missing","diagnostic":"INTERNAL-DO-NOT-DRAW"}"#
                    .utf8), expectsNotice: false)
    }
}
