import AppKit
import Darwin
import Foundation
import Shell
import Surfaces
import Testing

/// The Git view on a large repository stays within a memory bound (CP-1335, CP-1339): the owner's
/// walk (E3) opened a folder of thousands of untracked files and chose Git, and the view held a view
/// for every row. Each case here runs the whole launch through `LaunchFlow` into the product's window
/// and reads the process's high-water mark of resident memory, so a case passes only when it is the
/// one test in its process: `checks/git-view-memory.sh` runs each case alone, and the gate's *Test
/// gate* skips this suite.
@MainActor
struct GitViewMemoryBoundTests {
    /// The most the process's peak resident size may rise from the pending Git view to the end of
    /// the gestures, in bytes: 154,000,000 for the 500-point window the case opens.
    private static let riseBound = 154_000_000

    private static let pendingSentence = "Reading Git status."
    private static let readAtOpenNotice =
        "The Git view and the letters beside changed files show the Git state KA-Reader read when you opened the folder. They do not update while KA-Reader is open."
    private static let chosenFolder = URL(
        fileURLWithPath: "/Users/someone/notes", isDirectory: true)

    /// The root listing the E3 folder shows: `README.md`, `docs`, `notes`, `src` and `bulk`.
    private static let rootAnswer = Data(rootEntries.joined().utf8)

    private static let rootEntries: [String] = [
        #"{"state":"observed","entries":["#,
        #"{"name":"README.md","path":"README.md","kind":"file","state":"observed","language":"plain"},"#,
        #"{"name":"docs","path":"docs","kind":"folder","state":"pending"},"#,
        #"{"name":"notes","path":"notes","kind":"folder","state":"pending"},"#,
        #"{"name":"src","path":"src","kind":"folder","state":"pending"},"#,
        #"{"name":"bulk","path":"bulk","kind":"folder","state":"pending"}]}"#,
    ]

    /// The untracked file at `index`, in folders of 100 as the E3 repository holds them.
    private static func untrackedPath(_ index: Int) -> String {
        "bulk/d\(padded(index / 100))/f\(padded(index)).txt"
    }

    /// `number` in decimal, with leading zeros to five digits.
    private static func padded(_ number: Int) -> String {
        let digits = String(number)
        return String(repeating: "0", count: max(0, 5 - digits.count)) + digits
    }

    /// The wire answer for a repository on `main` whose only changes are `files` untracked files.
    /// Built before the first reading, so it is not part of the rise.
    private static func answer(files: Int) -> Data {
        let entries = (0..<files).map { #"{"category":"untracked","path":"\#(untrackedPath($0))"}"# }
        let head = #"{"state":"observed","kind":"root","branch":{"kind":"branch","name":"main"},"#
        let middle = #""repository_state":"normal","staged":[],"changed":["#
        return Data((head + middle + entries.joined(separator: ",") + "]}").utf8)
    }

    /// The process's maximum resident size so far, in bytes (`ru_maxrss` is bytes on macOS, the
    /// figure `/usr/bin/time -l` prints).
    private static func peakResidentBytes() -> Int {
        var usage = rusage()
        let status = unsafe getrusage(RUSAGE_SELF, &usage)
        precondition(status == 0, "getrusage failed")
        return Int(usage.ru_maxrss)
    }

    private func texts(in view: NSView) -> [NSTextField] {
        view.subviews.flatMap { child in
            (child as? NSTextField).map { [$0] } ?? texts(in: child)
        }
    }

    private func strings(in view: NSView) -> [String] { texts(in: view).map(\.stringValue) }

    private func descendants(of view: NSView) -> [NSView] {
        view.subviews + view.subviews.flatMap { descendants(of: $0) }
    }

    /// Each realized Git row as its path and its letter, in the order the views are held.
    private func realizedRows(in view: NSView) -> [(path: String, letter: String)] {
        texts(in: view).filter { $0.identifier?.rawValue == "gitRowPath" }.compactMap { path in
            let letter = unsafe path.superview?.subviews.compactMap { $0 as? NSTextField }
                .first { $0.identifier?.rawValue == "gitRowLetter" }
            return letter.map { (path.stringValue, $0.stringValue) }
        }
    }

    private func scroll(_ view: NSView, toEnd: Bool) throws {
        let scrollView = try #require(descendants(of: view).compactMap { $0 as? NSScrollView }.first)
        let document = try #require(scrollView.documentView)
        let end = document.frame.height - scrollView.contentView.bounds.height
        scrollView.contentView.scroll(to: NSPoint(x: 0, y: toEnd ? max(0, end) : 0))
        scrollView.reflectScrolledClipView(scrollView.contentView)
    }

    /// Lays the window out and draws what it holds, after each step of a case.
    private func settle(_ window: NSWindow) {
        window.layoutIfNeeded()
        window.layoutIfNeeded()
        window.displayIfNeeded()
    }

    @Test func twoThousandFilesStayWithinTheBound() throws {
        let files = 2_000
        let wire = Self.answer(files: files)

        createTheSharedApplication()
        let log = EventLog()
        let bridge = RecordingBridge(log: log)
        bridge.listAnswer = Self.rootAnswer
        bridge.gitAnswer = wire
        let presenter = FakeWindowPresenter()
        let reader = HoldingReadRunner()
        let flow = LaunchFlow(
            panel: FakePanel(answers: [Self.chosenFolder], log: log), bridge: bridge,
            glyphs: FakeGlyphSource(), presenter: presenter, reader: reader,
            treeActs: InlineReadRunner(), main: HeldMainDelivery(), terminate: {})
        flow.run()
        reader.release(0)
        let workbench = try #require(presenter.contents.last as? WorkbenchView)
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 900, height: 500), styleMask: [.borderless],
            backing: .buffered, defer: true)
        window.contentView = workbench
        settle(window)

        // The tree is shown: choose Git, and the Git read is still held.
        workbench.rail.entryChosen?(.git)
        settle(window)
        #expect(strings(in: workbench.gitView) == [Self.pendingSentence])
        #expect(!strings(in: workbench.rootItemsView).contains(Self.readAtOpenNotice))
        #expect(
            !texts(in: workbench.rootItemsView).contains {
                $0.identifier?.rawValue == "treeRowLetter" && !$0.stringValue.isEmpty
            })
        #expect(bridge.gitReadCount == 0, "the read is held")

        let before = Self.peakResidentBytes()

        reader.release(1)
        settle(window)
        try scroll(workbench.gitView, toEnd: true)
        settle(window)
        try scroll(workbench.gitView, toEnd: false)
        settle(window)
        workbench.rail.entryChosen?(.files)
        settle(window)
        workbench.rail.entryChosen?(.git)
        settle(window)
        workbench.rail.entryChosen?(.files)
        settle(window)
        workbench.rail.entryChosen?(.git)
        settle(window)

        let rise = Self.peakResidentBytes() - before
        #expect(rise <= Self.riseBound, "the peak resident size rose \(rise) bytes")

        let drawn = strings(in: workbench.gitView)
        #expect(drawn.contains("main"))
        #expect(!drawn.contains("Staged"))
        #expect(drawn.contains("Changes"))
        #expect(drawn.contains("\(files)"))
        let first = try #require(realizedRows(in: workbench.gitView).first)
        #expect(first.path == "bulk/d00000/f00000.txt")
        #expect(first.letter == "U")
        try scroll(workbench.gitView, toEnd: true)
        settle(window)
        let last = try #require(
            realizedRows(in: workbench.gitView).first { $0.path == Self.untrackedPath(files - 1) })
        #expect(last.path == "bulk/d00019/f01999.txt")
        #expect(last.letter == "U")
        #expect(drawn.filter { $0 == Self.readAtOpenNotice }.count == 1)
        #expect(strings(in: workbench.rootItemsView).filter { $0 == Self.readAtOpenNotice }.count == 1)
        #expect(bridge.gitReadCount == 1)
        withExtendedLifetime((window, flow)) {}
    }
}
