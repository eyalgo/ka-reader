import AppKit
import Foundation
import Surfaces

/// What the reading panel's Markdown tests share: a panel laid out at a size, and an `assetBytes`
/// intent that records each path asked and answers at once or when the test chooses.

@MainActor
func makeMarkdownPanel(
    recorder: AssetRecorder? = nil, width: CGFloat = 600, height: CGFloat = 400
) -> ReadingPanelView {
    let panel = ReadingPanelView(
        statusGlyphs: StatusGlyphs(
            empty: NSImage(size: NSSize(width: 3, height: 3)),
            failure: NSImage(size: NSSize(width: 4, height: 4))))
    panel.frame = NSRect(x: 0, y: 0, width: width, height: height)
    panel.assetBytes = recorder?.intent
    panel.layoutSubtreeIfNeeded()
    return panel
}

@MainActor
final class AssetRecorder {
    /// Each path asked, in the order asked.
    private(set) var asked: [String] = []
    /// The bytes answered by path; a path not in it is answered `nil`.
    var bytes: [String: Data] = [:]
    /// Whether answers are held until `answerAll()` instead of given at once.
    var holds = false
    private var held: [(path: String, answer: @MainActor (Data?) -> Void)] = []

    var intent: AssetBytesIntent {
        { [self] path, answer in
            asked.append(path)
            if holds {
                held.append((path, answer))
            } else {
                answer(bytes[path])
            }
        }
    }

    /// Answers every held ask, in the order asked.
    func answerAll() {
        let pending = held
        held = []
        for ask in pending { ask.answer(bytes[ask.path]) }
    }

    var heldCount: Int { held.count }
}

func longPage(_ prefix: String, paragraphs: Int) -> MarkdownDocument {
    pageDocument((0..<paragraphs).map { textParagraph("\(prefix) paragraph \($0)") })
}

extension NSView {
    var allDescendants: [NSView] { subviews + subviews.flatMap(\.allDescendants) }
}
