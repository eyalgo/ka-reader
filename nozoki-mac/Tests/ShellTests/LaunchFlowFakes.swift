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
    var openAnswer: Data? = Data(#"{"opened":true}"#.utf8)
    var listAnswer: Data? = Data(#"{"state":"observed","entries":[]}"#.utf8)
    /// An answer for one path. A path with no entry here gets `listAnswer`, and an entry holding
    /// `nil` is the bridge's failure value for that path.
    var listAnswers: [String: Data?] = [:]

    private let log: EventLog
    private var nextHandle: UInt = 1
    private(set) var openedLocations: [URL?] = []
    private(set) var listedPaths: [String] = []
    private(set) var handedOut: [UInt] = []
    private(set) var freed: [UInt] = []

    init(log: EventLog) {
        self.log = log
    }

    func openFolder(location: URL?) -> BridgeBuffer? {
        log.record("open_folder")
        openedLocations.append(location)
        return makeBuffer(from: openAnswer)
    }

    func listTree(path: String) -> BridgeBuffer? {
        log.record("list_tree")
        listedPaths.append(path)
        return makeBuffer(from: listAnswers[path] ?? listAnswer)
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

    func present(_ content: NSView) {
        if contents.isEmpty { createdWindowCount += 1 }
        contents.append(content)
        if let workbench = content as? WorkbenchView {
            presented.append(workbench.rootItemsView)
        }
    }
}

struct FakeGlyphSource: GlyphSource {
    let folder = NSImage(size: NSSize(width: 1, height: 1))
    let file = NSImage(size: NSSize(width: 2, height: 2))

    func glyph(named name: String) -> NSImage? {
        switch name {
        case "folder": return folder
        case "file": return file
        default: return nil
        }
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

/// Keeps every read until the test releases it, then runs each one inline.
@MainActor
final class HoldingReadRunner: ReadRunning {
    func run<Answer>(
        _ read: @escaping @Sendable () -> Answer,
        deliver: @escaping @MainActor (Answer) -> Void
    ) {
        deliver(read())
    }

    func release() {
        // The generic runner delivers immediately; this seam remains for older call sites.
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
    private let listAnswers: [String: Data]
    private var nextHandle: UInt = 1
    private var pathOfHandle: [UInt: String] = [:]
    private var calls: [(name: String, onMain: Bool)] = []

    init(listAnswers: [String: Data]) {
        self.listAnswers = listAnswers
    }

    /// Whether the named call ran on the main thread, for every call of that name.
    func ranOnMain(_ name: String) -> [Bool] {
        lock.withLock { calls.filter { $0.name == name }.map(\.onMain) }
    }

    func openFolder(location: URL?) -> BridgeBuffer? {
        record("open_folder")
        return nil
    }

    func listTree(path: String) -> BridgeBuffer? {
        record("list_tree:\(path)")
        return lock.withLock {
            guard let payload = listAnswers[path] else { return nil }
            let handle = nextHandle
            nextHandle += 1
            pathOfHandle[handle] = path
            return BridgeBuffer(payload: payload, handle: handle)
        }
    }

    func free(_ buffer: BridgeBuffer) {
        let path = lock.withLock { pathOfHandle[buffer.handle] ?? "?" }
        record("free:\(path)")
    }

    private func record(_ name: String) {
        let onMain = Thread.isMainThread
        lock.withLock { calls.append((name, onMain)) }
    }
}
