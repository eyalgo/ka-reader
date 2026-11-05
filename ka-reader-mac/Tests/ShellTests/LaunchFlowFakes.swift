import AppKit
import Shell
import Surfaces

/// The order in which the fakes were touched, so a test can say what came before what.
final class EventLog: @unchecked Sendable {
    // `@unchecked Sendable` because a bridge fake records into it from whichever thread the read
    // runner calls the bridge on. The lock is enough: `storedEvents` is read and written only inside
    // `lock`.
    private let lock = NSLock()
    private var storedEvents: [String] = []

    var events: [String] { lock.withLock { storedEvents } }

    func record(_ event: String) {
        lock.withLock { storedEvents.append(event) }
    }
}

final class FakePanel: FolderChoosing {
    private var answers: [URL?]
    private let log: EventLog
    private(set) var presentedCount = 0

    init(answers: [URL?], log: EventLog) {
        self.answers = answers
        self.log = log
    }

    func chooseFolder() -> URL? {
        presentedCount += 1
        log.record("panel")
        return answers.isEmpty ? nil : answers.removeFirst()
    }
}

/// A bridge that answers from canned bytes and records every call, buffer and free.
final class RecordingBridge: Bridging, @unchecked Sendable {
    // `@unchecked Sendable` because `Bridging` is `Sendable` (the read runner calls a bridge from a
    // background queue) and this fake keeps mutable answers and records. The lock is enough: every
    // stored property is read and written only inside `lock`, through the accessors below, which
    // keep the names and shapes the tests already use.
    private struct State {
        var openAnswer: Data? = Data(#"{"state":"opened"}"#.utf8)
        var openAnswers: [Data?] = []
        var listAnswer: Data? = Data(#"{"state":"observed","entries":[]}"#.utf8)
        var listAnswers: [String: Data?] = [:]
        var selectAnswer: Data? = Data(#"{"state":"pending"}"#.utf8)
        var selectAnswers: [String: Data?] = [:]
        var gitAnswer: Data? = Data(#"{"state":"pending"}"#.utf8)
        var nextHandle: UInt = 1
        var openedLocations: [URL] = []
        var listedPaths: [String] = []
        var listedActs: [DisclosureAct] = []
        var receivers: [ModelChangesReceiver?] = []
        var selectedPaths: [String] = []
        var gitReadCount = 0
        var handedOut: [UInt] = []
        var freed: [UInt] = []
    }

    private let lock = NSLock()
    private var state = State()
    let log: EventLog

    var openAnswer: Data? {
        get { lock.withLock { state.openAnswer } }
        set { lock.withLock { state.openAnswer = newValue } }
    }
    var openAnswers: [Data?] {
        get { lock.withLock { state.openAnswers } }
        set { lock.withLock { state.openAnswers = newValue } }
    }
    var listAnswer: Data? {
        get { lock.withLock { state.listAnswer } }
        set { lock.withLock { state.listAnswer = newValue } }
    }
    /// An answer for one path. A path with no entry here gets `listAnswer`, and an entry holding
    /// `nil` is the bridge's failure value for that path.
    var listAnswers: [String: Data?] {
        get { lock.withLock { state.listAnswers } }
        set { lock.withLock { state.listAnswers = newValue } }
    }
    var selectAnswer: Data? {
        get { lock.withLock { state.selectAnswer } }
        set { lock.withLock { state.selectAnswer = newValue } }
    }
    /// The answer for a file read. A path with no entry in `selectAnswers` gets `selectAnswer`, and
    /// an entry holding `nil` is the bridge's failure value for that path.
    var selectAnswers: [String: Data?] {
        get { lock.withLock { state.selectAnswers } }
        set { lock.withLock { state.selectAnswers = newValue } }
    }
    /// The answer for the Git read: `pending`, until a test sets it. `nil` is the bridge's failure
    /// value.
    var gitAnswer: Data? {
        get { lock.withLock { state.gitAnswer } }
        set { lock.withLock { state.gitAnswer = newValue } }
    }

    var openedLocations: [URL] { lock.withLock { state.openedLocations } }
    var listedPaths: [String] { lock.withLock { state.listedPaths } }
    /// The act of each `listTree` call, in the order the calls were made.
    var listedActs: [DisclosureAct] { lock.withLock { state.listedActs } }
    /// The receiver of each `openFolder` call, `nil` for a command-only open.
    var receivers: [ModelChangesReceiver?] { lock.withLock { state.receivers } }
    var selectedPaths: [String] { lock.withLock { state.selectedPaths } }
    var gitReadCount: Int { lock.withLock { state.gitReadCount } }
    var handedOut: [UInt] { lock.withLock { state.handedOut } }
    var freed: [UInt] { lock.withLock { state.freed } }

    init(log: EventLog) {
        self.log = log
    }

    func openFolder(location: URL, changes: ModelChangesReceiver?) -> BridgeBuffer? {
        log.record("open_folder")
        return lock.withLock {
            state.openedLocations.append(location)
            state.receivers.append(changes)
            let answer =
                state.openAnswers.isEmpty ? state.openAnswer : state.openAnswers.removeFirst()
            return makeBuffer(from: answer)
        }
    }

    func listTree(path: String, act: DisclosureAct) -> BridgeBuffer? {
        log.record("list_tree")
        return lock.withLock {
            state.listedPaths.append(path)
            state.listedActs.append(act)
            return makeBuffer(from: state.listAnswers[path] ?? state.listAnswer)
        }
    }

    func selectFile(path: String) -> BridgeBuffer? {
        log.record("select_file")
        return lock.withLock {
            state.selectedPaths.append(path)
            return makeBuffer(from: state.selectAnswers[path] ?? state.selectAnswer)
        }
    }

    func readGit() -> BridgeBuffer? {
        log.record("read_git")
        return lock.withLock {
            state.gitReadCount += 1
            return makeBuffer(from: state.gitAnswer)
        }
    }

    func free(_ buffer: BridgeBuffer) {
        log.record("free")
        lock.withLock { state.freed.append(buffer.handle) }
    }

    /// Called with `lock` held.
    private func makeBuffer(from payload: Data?) -> BridgeBuffer? {
        guard let payload else { return nil }
        let handle = state.nextHandle
        state.nextHandle += 1
        state.handedOut.append(handle)
        return BridgeBuffer(payload: payload, handle: handle)
    }
}

@MainActor
final class FakeWindowPresenter: WindowPresenting {
    private(set) var presented: [RootItemsView] = []
    private(set) var contents: [NSView] = []
    private(set) var createdWindowCount = 0
    private(set) var presentationsOnMain: [Bool] = []
    var onPresent: ((NSView) -> Void)?

    func present(_ content: NSView) {
        if contents.isEmpty { createdWindowCount += 1 }
        contents.append(content)
        presentationsOnMain.append(Thread.isMainThread)
        if let workbench = content as? WorkbenchView {
            presented.append(workbench.rootItemsView)
        }
        onPresent?(content)
    }
}

/// A distinct image for each glyph the shell asks for by `docs/DESIGN.md`'s name, so a test can
/// tell which one a surface drew: the tree's three (`folder`, `file` and `file-code`), the status messages' `info` (empty or
/// pending) and `circle-alert` (failure), and the rail's second glyph, `git-branch`.
struct FakeGlyphSource: GlyphSource {
    let folder = NSImage(size: NSSize(width: 1, height: 1))
    let file = NSImage(size: NSSize(width: 2, height: 2))
    let info = NSImage(size: NSSize(width: 3, height: 3))
    let circleAlert = NSImage(size: NSSize(width: 4, height: 4))
    let fileCode = NSImage(size: NSSize(width: 5, height: 5))
    let gitBranch = NSImage(size: NSSize(width: 6, height: 6))

    func glyph(named name: String) -> NSImage? {
        switch name {
        case "folder": return folder
        case "file": return file
        case "file-code": return fileCode
        case "info": return info
        case "circle-alert": return circleAlert
        case "git-branch": return gitBranch
        default: return nil
        }
    }
}

/// Holds every read it is handed and never delivers one, so a launch stays on what it shows while a
/// read is out.
@MainActor
final class HoldingReadRunner: ReadRunning {
    private(set) var heldReads = 0

    /// Each held read, ready to run and deliver. A test releases them in any order.
    private var held: [@MainActor () -> Void] = []

    func run<Answer: Sendable>(
        _ read: @escaping @Sendable () -> Answer,
        deliver: @escaping @MainActor @Sendable (Answer) -> Void
    ) {
        heldReads += 1
        held.append { deliver(read()) }
    }

    /// Runs the `index`th held read and delivers its answer.
    func release(_ index: Int) {
        held[index]()
    }
}

/// Runs the read and the delivery at once, on the caller's thread.
@MainActor
struct InlineReadRunner: ReadRunning {
    func run<Answer: Sendable>(
        _ read: @escaping @Sendable () -> Answer,
        deliver: @escaping @MainActor @Sendable (Answer) -> Void
    ) {
        deliver(read())
    }
}

/// A bridge that may be called from any thread. It answers from canned bytes by path and records,
/// for each call, whether it ran on the main thread.
///
/// `@unchecked Sendable` because the read runner calls it from a background queue. The lock is
/// enough: every stored property but `listAnswers` (a `let`, set once in `init`) is read and written
/// only inside `lock`, and `record` takes the thread reading before it takes the lock.
final class ThreadRecordingBridge: Bridging, @unchecked Sendable {
    private let lock = NSLock()
    private let openAnswer: Data
    private let listAnswers: [String: Data]
    private let selectAnswers: [String: Data]
    private let gitAnswer: Data?
    private var nextHandle: UInt = 1
    private var pathOfHandle: [UInt: String] = [:]
    private var calls: [(name: String, onMain: Bool)] = []

    init(
        openAnswer: Data = Data(#"{"state":"opened"}"#.utf8),
        listAnswers: [String: Data],
        selectAnswers: [String: Data] = [:],
        gitAnswer: Data? = nil
    ) {
        self.openAnswer = openAnswer
        self.listAnswers = listAnswers
        self.selectAnswers = selectAnswers
        self.gitAnswer = gitAnswer
    }

    /// Whether the named call ran on the main thread, for every call of that name.
    func ranOnMain(_ name: String) -> [Bool] {
        lock.withLock { calls.filter { $0.name == name }.map(\.onMain) }
    }

    func openFolder(location: URL, changes: ModelChangesReceiver?) -> BridgeBuffer? {
        record("open_folder")
        return makeBuffer(from: openAnswer, named: "open")
    }

    func listTree(path: String, act: DisclosureAct) -> BridgeBuffer? {
        // A collapse is recorded under its own names, so the expansions' records stay as they were.
        let prefix = act == .collapse ? "collapse:" : ""
        record("list_tree:\(prefix)\(path)")
        guard let payload = listAnswers[path] else { return nil }
        return makeBuffer(from: payload, named: "\(prefix)\(path)")
    }

    func selectFile(path: String) -> BridgeBuffer? {
        record("select_file:\(path)")
        guard let payload = selectAnswers[path] else { return nil }
        return makeBuffer(from: payload, named: "select:\(path)")
    }

    func readGit() -> BridgeBuffer? {
        record("read_git")
        guard let gitAnswer else { return nil }
        return makeBuffer(from: gitAnswer, named: "git")
    }

    func free(_ buffer: BridgeBuffer) {
        let path = lock.withLock { pathOfHandle[buffer.handle] ?? "?" }
        record("free:\(path)")
    }

    private func record(_ name: String) {
        let onMain = Thread.isMainThread
        lock.withLock { calls.append((name, onMain)) }
    }

    private func makeBuffer(from payload: Data, named name: String) -> BridgeBuffer {
        lock.withLock {
            let handle = nextHandle
            nextHandle += 1
            pathOfHandle[handle] = name
            return BridgeBuffer(payload: payload, handle: handle)
        }
    }
}

/// Wraps the real queue runner and observes each main-actor delivery immediately before forwarding it.
@MainActor
final class DeliveryRecordingReadRunner: ReadRunning {
    private let runner = OffMainReadRunner()
    private(set) var deliveriesOnMain: [Bool] = []
    var onDelivery: (() -> Void)?

    func run<Answer: Sendable>(
        _ read: @escaping @Sendable () -> Answer,
        deliver: @escaping @MainActor @Sendable (Answer) -> Void
    ) {
        runner.run(read) { [weak self] answer in
            self?.deliveriesOnMain.append(Thread.isMainThread)
            self?.onDelivery?()
            deliver(answer)
        }
    }
}
