import AppKit
import Shell
import Surfaces

/// The order in which the fakes were touched, so a test can say what came before what.
final class EventLog {
    private(set) var events: [String] = []

    func record(_ event: String) {
        events.append(event)
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
final class RecordingBridge: Bridging {
    var openAnswer: Data? = Data(#"{"state":"opened"}"#.utf8)
    var openAnswers: [Data?] = []
    var listAnswer: Data? = Data(#"{"state":"observed","entries":[]}"#.utf8)
    /// An answer for one path. A path with no entry here gets `listAnswer`, and an entry holding
    /// `nil` is the bridge's failure value for that path.
    var listAnswers: [String: Data?] = [:]
    /// The answer for a file read. A path with no entry in `selectAnswers` gets `selectAnswer`, and
    /// an entry holding `nil` is the bridge's failure value for that path.
    var selectAnswer: Data? = Data(#"{"state":"pending"}"#.utf8)
    var selectAnswers: [String: Data?] = [:]

    private let log: EventLog
    private var nextHandle: UInt = 1
    private(set) var openedLocations: [URL] = []
    private(set) var listedPaths: [String] = []
    private(set) var selectedPaths: [String] = []
    private(set) var handedOut: [UInt] = []
    private(set) var freed: [UInt] = []

    init(log: EventLog) {
        self.log = log
    }

    func openFolder(location: URL) -> BridgeBuffer? {
        log.record("open_folder")
        openedLocations.append(location)
        return makeBuffer(from: openAnswers.isEmpty ? openAnswer : openAnswers.removeFirst())
    }

    func listTree(path: String) -> BridgeBuffer? {
        log.record("list_tree")
        listedPaths.append(path)
        return makeBuffer(from: listAnswers[path] ?? listAnswer)
    }

    func selectFile(path: String) -> BridgeBuffer? {
        log.record("select_file")
        selectedPaths.append(path)
        return makeBuffer(from: selectAnswers[path] ?? selectAnswer)
    }

    func free(_ buffer: BridgeBuffer) {
        log.record("free")
        freed.append(buffer.handle)
    }

    private func makeBuffer(from payload: Data?) -> BridgeBuffer? {
        guard let payload else { return nil }
        let handle = nextHandle
        nextHandle += 1
        handedOut.append(handle)
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
/// tell which one a surface drew: the tree's two, and the status messages' `info` (empty or
/// pending) and `circle-alert` (failure).
struct FakeGlyphSource: GlyphSource {
    let folder = NSImage(size: NSSize(width: 1, height: 1))
    let file = NSImage(size: NSSize(width: 2, height: 2))
    let info = NSImage(size: NSSize(width: 3, height: 3))
    let circleAlert = NSImage(size: NSSize(width: 4, height: 4))

    func glyph(named name: String) -> NSImage? {
        switch name {
        case "folder": return folder
        case "file": return file
        case "info": return info
        case "circle-alert": return circleAlert
        default: return nil
        }
    }
}

/// Holds every read it is handed and never delivers one, so a launch stays on what it shows while a
/// read is out.
@MainActor
final class HoldingReadRunner: ReadRunning {
    private(set) var heldReads = 0

    func run<Answer>(
        _ read: @escaping @Sendable () -> Answer,
        deliver: @escaping @MainActor (Answer) -> Void
    ) {
        heldReads += 1
    }
}

/// Runs the read and the delivery at once, on the caller's thread.
@MainActor
struct InlineReadRunner: ReadRunning {
    func run<Answer>(
        _ read: @escaping @Sendable () -> Answer,
        deliver: @escaping @MainActor (Answer) -> Void
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
    private var nextHandle: UInt = 1
    private var pathOfHandle: [UInt: String] = [:]
    private var calls: [(name: String, onMain: Bool)] = []

    init(
        openAnswer: Data = Data(#"{"state":"opened"}"#.utf8),
        listAnswers: [String: Data],
        selectAnswers: [String: Data] = [:]
    ) {
        self.openAnswer = openAnswer
        self.listAnswers = listAnswers
        self.selectAnswers = selectAnswers
    }

    /// Whether the named call ran on the main thread, for every call of that name.
    func ranOnMain(_ name: String) -> [Bool] {
        lock.withLock { calls.filter { $0.name == name }.map(\.onMain) }
    }

    func openFolder(location: URL) -> BridgeBuffer? {
        record("open_folder")
        return makeBuffer(from: openAnswer, named: "open")
    }

    func listTree(path: String) -> BridgeBuffer? {
        record("list_tree:\(path)")
        guard let payload = listAnswers[path] else { return nil }
        return makeBuffer(from: payload, named: path)
    }

    func selectFile(path: String) -> BridgeBuffer? {
        record("select_file:\(path)")
        guard let payload = selectAnswers[path] else { return nil }
        return makeBuffer(from: payload, named: "select:\(path)")
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

    func run<Answer>(
        _ read: @escaping @Sendable () -> Answer,
        deliver: @escaping @MainActor (Answer) -> Void
    ) {
        runner.run(read) { [weak self] answer in
            self?.deliveriesOnMain.append(Thread.isMainThread)
            self?.onDelivery?()
            deliver(answer)
        }
    }
}
