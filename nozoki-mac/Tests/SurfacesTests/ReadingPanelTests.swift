import AppKit
import XCTest

@testable import Surfaces

/// The reading panel's four states (CP-246 – CP-286): no file, text, cannot-display and failed
/// read. Each is put in the panel as a path and a `FileVerdict`, the value the shell decodes.
@MainActor
final class ReadingPanelTests: XCTestCase {
    private let statusGlyphs = StatusGlyphs(
        empty: NSImage(size: NSSize(width: 3, height: 3)),
        failure: NSImage(size: NSSize(width: 4, height: 4)))

    private let prompt = "Select a file to view."

    private func makePanel() -> ReadingPanelView {
        let panel = ReadingPanelView(statusGlyphs: statusGlyphs)
        panel.frame = NSRect(x: 0, y: 0, width: 600, height: 400)
        panel.layoutSubtreeIfNeeded()
        return panel
    }

    private func descendants(of view: NSView) -> [NSView] {
        view.subviews + view.subviews.flatMap { descendants(of: $0) }
    }

    private func visible(_ view: NSView) -> [NSView] {
        descendants(of: view).filter { !$0.isHiddenOrHasHiddenAncestor }
    }

    /// The text of every visible, non-editable text field, top to bottom.
    private func visibleStrings(_ panel: NSView) -> [String] {
        panel.layoutSubtreeIfNeeded()
        let fields = visible(panel).compactMap { $0 as? NSTextField }.filter { !$0.isEditable }
        return
            fields
            .sorted {
                $0.convert($0.bounds, to: panel).maxY > $1.convert($1.bounds, to: panel).maxY
            }
            .map(\.stringValue)
    }

    private func isShowingContent(_ panel: ReadingPanelView) -> Bool {
        !panel.contentView.isHiddenOrHasHiddenAncestor
    }

    private func matches(_ pattern: String, in text: String) -> Int {
        // swiftlint:disable:next force_try
        let expression = try! NSRegularExpression(pattern: pattern)
        return expression.numberOfMatches(
            in: text, range: NSRange(text.startIndex..., in: text))
    }

    private func sentenceCount(_ text: String) -> Int {
        // A sentence ends at a stop followed by a space or the end; the stop in `photo.dat` is not one.
        matches(#"[.!?](\s|$)"#, in: text)
    }

    func testTextVerdictShowsPathThenContentInANonEditableView() {
        let panel = makePanel()

        panel.show(path: "src/lib.rs", verdict: .text("fn main() {}\n", .plain))

        XCTAssertEqual(visibleStrings(panel), ["src/lib.rs"])
        XCTAssertEqual(panel.pathLine.stringValue, "src/lib.rs")
        XCTAssertEqual(panel.contentView.string, "fn main() {}\n")
        XCTAssertFalse(panel.contentView.isEditable)
        XCTAssertTrue(isShowingContent(panel))
        let pathFrame = panel.pathLine.convert(panel.pathLine.bounds, to: panel)
        let contentFrame = panel.contentView.convert(panel.contentView.bounds, to: panel)
        XCTAssertGreaterThan(
            pathFrame.minY, contentFrame.minY, "the path line is above the content")
    }

    func testRootFilePathLineIsItsOwnName() {
        let panel = makePanel()

        panel.show(path: "README", verdict: .text("hello", .plain))

        XCTAssertEqual(panel.pathLine.stringValue, "README")
        XCTAssertFalse(panel.pathLine.stringValue.hasPrefix("/"))
        XCTAssertFalse(panel.pathLine.stringValue.hasPrefix("./"))
    }

    func testMarkdownSourceIsDrawnAsWrittenWithNoColour() throws {
        let panel = makePanel()
        let source = "# Title\n\n**bold** and [a link](https://example.com)\n"

        panel.show(path: "README.md", verdict: .text(source, .plain))

        XCTAssertEqual(panel.contentView.string, source)
        let storage = try XCTUnwrap(panel.contentView.textStorage)
        var run = NSRange()
        let attributes = storage.attributes(at: 0, effectiveRange: &run)
        XCTAssertEqual(run, NSRange(location: 0, length: storage.length), "one attribute run")
        // The system's own text colour is the default, not a colouring; anything else is one.
        let foreground = attributes[.foregroundColor] as? NSColor
        XCTAssertTrue(
            foreground == nil || foreground == .textColor, "\(String(describing: foreground))")
        for coloured in [NSAttributedString.Key.backgroundColor, .link] {
            XCTAssertNil(attributes[coloured], "\(coloured) is not set")
        }
    }

    func testEmptyContentShowsThePathLineAndNothingElse() {
        let panel = makePanel()

        panel.show(path: "docs/empty", verdict: .text("", .plain))

        XCTAssertEqual(visibleStrings(panel), ["docs/empty"])
        XCTAssertEqual(panel.contentView.string, "")
    }

    func testCannotDisplayShowsOneSentenceNamingTheFile() {
        for reason in [CannotDisplayReason.invalidUTF8, .invalidUTF16] {
            let panel = makePanel()

            panel.show(path: "docs/photo.dat", verdict: .cannotDisplay(reason))

            let strings = visibleStrings(panel)
            XCTAssertEqual(strings.count, 2, "\(reason): \(strings)")
            XCTAssertEqual(strings.first, "docs/photo.dat")
            let sentence = strings.last ?? ""
            XCTAssertTrue(sentence.contains("photo.dat"), sentence)
            XCTAssertTrue(sentence.contains("can't be shown as text"), sentence)
            XCTAssertEqual(sentenceCount(sentence), 1, sentence)
            XCTAssertFalse(isShowingContent(panel), "none of the content is drawn")
            for banned in ["binary", "unsupported", "unreadable", "utf", "encoding", "error"] {
                XCTAssertFalse(sentence.lowercased().contains(banned), "\(banned): \(sentence)")
            }
        }
    }

    func testFailedReadShowsAStatementForEveryCondition() {
        XCTAssertEqual(Condition.allCases.count, 6, "the six conditions of fs_reader.rs")
        for condition in Condition.allCases {
            let panel = makePanel()

            panel.show(path: "docs/notes.txt", verdict: .failed(condition))

            let strings = visibleStrings(panel)
            XCTAssertEqual(strings.count, 2, "\(condition): \(strings)")
            XCTAssertEqual(strings.first, "docs/notes.txt")
            let statement = strings.last ?? ""
            XCTAssertFalse(statement.isEmpty, "\(condition)")
            XCTAssertLessThanOrEqual(sentenceCount(statement), 3, statement)
            XCTAssertTrue(statement.contains("notes.txt"), "\(condition): \(statement)")
            XCTAssertFalse(isShowingContent(panel))
            XCTAssertEqual(
                matches(
                    #"\b(sorry|oops|unfortunately|apolog\w*|errno|enoent|eacces)\b"#,
                    in: statement.lowercased()),
                0, statement)
        }
    }

    func testFailedReadsAreLedByTheFailureGlyphAndCannotDisplayByTheEmptyOne() {
        let failed = makePanel()
        let cannotDisplay = makePanel()

        failed.show(path: "a", verdict: .failed(.missing))
        cannotDisplay.show(path: "a", verdict: .cannotDisplay(.invalidUTF8))

        let failedGlyphs = visible(failed).compactMap { $0 as? NSImageView }
        let cannotGlyphs = visible(cannotDisplay).compactMap { $0 as? NSImageView }
        XCTAssertTrue(failedGlyphs.count == 1 && failedGlyphs[0].image === statusGlyphs.failure)
        XCTAssertTrue(cannotGlyphs.count == 1 && cannotGlyphs[0].image === statusGlyphs.empty)
    }

    func testNoControlBeneathTheReadingPanelInAnyState() {
        let verdicts: [FileVerdict?] = [
            nil, .text("x", .plain), .cannotDisplay(.invalidUTF16), .failed(.outside),
        ]
        for verdict in verdicts {
            let panel = makePanel()
            if let verdict { panel.show(path: "f", verdict: verdict) } else { panel.showNoFile() }

            for view in descendants(of: panel) {
                XCTAssertFalse(view is NSButton, "\(view) in \(String(describing: verdict))")
                if let field = view as? NSTextField {
                    XCTAssertFalse(field.isEditable, "\(field)")
                }
                if let text = view as? NSTextView {
                    XCTAssertFalse(text.isEditable, "\(text)")
                }
            }
        }
    }

    func testNoFileStateDrawsThePromptAlone() {
        let panel = makePanel()

        XCTAssertEqual(visibleStrings(panel), [prompt])
        XCTAssertFalse(isShowingContent(panel))

        panel.show(path: "a.txt", verdict: .text("body", .plain))
        panel.showNoFile()

        XCTAssertEqual(visibleStrings(panel), [prompt])
        XCTAssertFalse(isShowingContent(panel))
    }
}
