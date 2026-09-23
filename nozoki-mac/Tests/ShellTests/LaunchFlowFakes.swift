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
    private let answer: URL?
    private let log: EventLog
    private(set) var presentedCount = 0

    init(answer: URL?, log: EventLog) {
        self.answer = answer
        self.log = log
    }

    func chooseFolder() -> URL? {
        presentedCount += 1
        log.record("panel")
        return answer
    }
}

/// A bridge that answers from canned bytes and records every call, buffer and free.
final class RecordingBridge: Bridging {
    var openAnswer: Data? = Data(#"{"opened":true}"#.utf8)
    var listAnswer: Data? = Data("[]".utf8)

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
        return makeBuffer(from: listAnswer)
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

    func present(_ content: RootItemsView) {
        presented.append(content)
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
