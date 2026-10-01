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

    private func matches(_ pattern: String, in text: String) throws -> Int {
        let expression = try NSRegularExpression(pattern: pattern)
        return expression.numberOfMatches(
            in: text, range: NSRange(text.startIndex..., in: text))
    }

    private func sentenceCount(_ text: String) throws -> Int {
        // A sentence ends at a stop followed by a space or the end; the stop in `photo.dat` is not one.
        try matches(#"[.!?](\s|$)"#, in: text)
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

    func testCannotDisplayShowsOneSentenceNamingTheFile() throws {
        for reason in [CannotDisplayReason.invalidUTF8, .invalidUTF16] {
            let panel = makePanel()

            panel.show(path: "docs/photo.dat", verdict: .cannotDisplay(reason))

            let strings = visibleStrings(panel)
            XCTAssertEqual(strings.count, 2, "\(reason): \(strings)")
            XCTAssertEqual(strings.first, "docs/photo.dat")
            let sentence = strings.last ?? ""
            XCTAssertTrue(sentence.contains("photo.dat"), sentence)
            XCTAssertTrue(sentence.contains("can't be shown as text"), sentence)
            XCTAssertEqual(try sentenceCount(sentence), 1, sentence)
            XCTAssertFalse(isShowingContent(panel), "none of the content is drawn")
            for banned in ["binary", "unsupported", "unreadable", "utf", "encoding", "error"] {
                XCTAssertFalse(sentence.lowercased().contains(banned), "\(banned): \(sentence)")
            }
        }
    }

    func testFailedReadShowsAStatementForEveryCondition() throws {
        XCTAssertEqual(Condition.allCases.count, 6, "the six conditions of fs_reader.rs")
        for condition in Condition.allCases {
            let panel = makePanel()

            panel.show(path: "docs/notes.txt", verdict: .failed(condition))

            let strings = visibleStrings(panel)
            XCTAssertEqual(strings.count, 2, "\(condition): \(strings)")
            XCTAssertEqual(strings.first, "docs/notes.txt")
            let statement = strings.last ?? ""
            XCTAssertFalse(statement.isEmpty, "\(condition)")
            XCTAssertLessThanOrEqual(try sentenceCount(statement), 3, statement)
            XCTAssertTrue(statement.contains("notes.txt"), "\(condition): \(statement)")
            XCTAssertFalse(isShowingContent(panel))
            XCTAssertEqual(
                try matches(
                    #"\b(sorry|oops|unfortunately|apolog\w*|errno|enoent|eacces)\b"#,
                    in: statement.lowercased()),
                0, statement)
        }
    }

    /// CP-282 with `docs/CONTENT.md` § Message patterns *Partial*: `.missing` reaches the panel for a
    /// link whose target was missing when its folder was listed (`change_spec.md` § Examples, the
    /// link row that already failed on listing), and *no longer there* would claim the target was once
    /// there. The statement says what Nozoki observed, which holds for that link and for a file gone
    /// since the listing alike.
    func testMissingStatementDoesNotClaimTheFileWasOnceThere() {
        let panel = makePanel()

        panel.show(path: "docs/ln", verdict: .failed(.missing))

        let statement = visibleStrings(panel).last ?? ""
        XCTAssertTrue(statement.contains("ln"), statement)
        XCTAssertFalse(statement.lowercased().contains("no longer"), statement)
    }

    /// CP-283: selecting another file replaces what the panel shows, whatever it showed before — a
    /// statement or a sentence never outlives its file, and content never shows under another path.
    func testEachVerdictReplacesWhatThePanelShowedBefore() {
        let panel = makePanel()

        panel.show(path: "a.txt", verdict: .failed(.unreadable))
        panel.show(path: "b.txt", verdict: .text("body", .plain))
        XCTAssertEqual(visibleStrings(panel), ["b.txt"])
        XCTAssertTrue(isShowingContent(panel))
        XCTAssertEqual(panel.contentView.string, "body")

        panel.show(path: "c.dat", verdict: .cannotDisplay(.invalidUTF8))
        var strings = visibleStrings(panel)
        XCTAssertEqual(strings.count, 2, "\(strings)")
        XCTAssertEqual(strings.first, "c.dat")
        XCTAssertFalse(isShowingContent(panel), "b.txt's content is gone")

        panel.show(path: "d.txt", verdict: .failed(.outside))
        strings = visibleStrings(panel)
        XCTAssertEqual(strings.count, 2, "\(strings)")
        XCTAssertEqual(strings.first, "d.txt")
        XCTAssertFalse(strings.last?.contains("c.dat") ?? true, "\(strings)")

        panel.show(path: "e", verdict: .text("", .plain))
        XCTAssertEqual(visibleStrings(panel), ["e"])
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

    // MARK: - Drawing a floor-language file's spans (CP-311 – CP-316)

    /// A code token or the ground, with the two values `docs/DESIGN.md:L409-L428` gives it: light
    /// then dark, as `0xRRGGBB`. `primary` and `gutter` are the base ink and the line numbers'
    /// colour (`docs/DESIGN.md:L411`, `:L413`).
    private enum Token {
        case keyword, string, number, comment, name, primary, gutter

        var values: (light: UInt32, dark: UInt32) {
            switch self {
            case .keyword: return (0x7A2E8F, 0xD0A2E6)
            case .string: return (0x1A6B3A, 0x8FD6A4)
            case .number: return (0x9A4B00, 0xF0B47A)
            case .comment: return (0x6A6C72, 0x9A9BA0)
            case .name: return (0x0F5A9A, 0x8CC4F5)
            case .primary: return (0x1E1F22, 0xE7E7E4)
            case .gutter: return (0x6F7177, 0x8E8F94)
            }
        }
    }

    private static let surfaceValues: (light: UInt32, dark: UInt32) = (0xFBFBFA, 0x1B1C1E)

    private let aqua = NSAppearance(named: .aqua)!
    private let darkAqua = NSAppearance(named: .darkAqua)!

    /// Fixture M (CP-317): characters 2, 3 and 4 bytes wide, before a span and inside one.
    private let fixtureM = "# café 日本 🙂\nname = \"é🙂\"\n"

    /// M's two spans in the wire's UTF-8 byte offsets, and the UTF-16 ranges they draw as.
    private let fixtureMSpans = [
        CodeSpan(start: 0, end: 19, tokenClass: .comment),
        CodeSpan(start: 27, end: 35, tokenClass: .string),
    ]
    private let fixtureMColoured: [(Range<Int>, Token)] = [(0..<12, .comment), (20..<25, .string)]

    private func hex(_ value: UInt32) -> [CGFloat] {
        [
            CGFloat((value >> 16) & 0xFF) / 255, CGFloat((value >> 8) & 0xFF) / 255,
            CGFloat(value & 0xFF) / 255,
        ]
    }

    /// `color` as sRGB red, green and blue, resolved under `appearance`.
    private func srgb(_ color: NSColor, under appearance: NSAppearance) -> [CGFloat] {
        var components: [CGFloat] = []
        appearance.performAsCurrentDrawingAppearance {
            if let resolved = color.usingColorSpace(.sRGB) {
                components = [
                    resolved.redComponent, resolved.greenComponent, resolved.blueComponent,
                ]
            }
        }
        return components
    }

    private func assertSame(
        _ actual: [CGFloat], _ expected: [CGFloat], _ message: String,
        file: StaticString = #filePath, line: UInt = #line
    ) {
        XCTAssertEqual(actual.count, 3, message, file: file, line: line)
        for (a, e) in zip(actual, expected) {
            XCTAssertEqual(a, e, accuracy: 0.002, message, file: file, line: line)
        }
    }

    /// The panel's text storage, one foreground colour per UTF-16 unit.
    private func foregrounds(of panel: ReadingPanelView) -> [NSColor?] {
        guard let storage = panel.contentView.textStorage else { return [] }
        return (0..<storage.length).map {
            storage.attribute(.foregroundColor, at: $0, effectiveRange: nil) as? NSColor
        }
    }

    /// Every UTF-16 unit of the panel is `.textColor`, except those in `coloured`, which are in their
    /// token's value for `appearance`. The colours are resolved under the panel's own effective
    /// appearance after it is set to `appearance`.
    private func assertDrawn(
        _ panel: ReadingPanelView, coloured: [(Range<Int>, Token)], under appearance: NSAppearance,
        file: StaticString = #filePath, line: UInt = #line
    ) {
        panel.appearance = appearance
        let resolvedUnder = panel.contentView.effectiveAppearance
        let isDark = appearance.name == .darkAqua
        for (index, color) in foregrounds(of: panel).enumerated() {
            let drawn = color ?? .textColor
            let expected: [CGFloat]
            if let token = coloured.first(where: { $0.0.contains(index) })?.1 {
                expected = hex(isDark ? token.values.dark : token.values.light)
            } else {
                expected = srgb(.textColor, under: resolvedUnder)
            }
            assertSame(
                srgb(drawn, under: resolvedUnder), expected,
                "unit \(index) under \(appearance.name)",
                file: file, line: line)
        }
    }

    private func floorVerdict(
        _ content: String, _ language: FloorLanguage, _ spans: [CodeSpan]
    ) -> FileVerdict {
        .text(content, .floor(language, spans))
    }

    func testFixtureMIsDrawnInItsSpanColoursUnderLightAndDark() {
        let panel = makePanel()

        panel.show(path: "m.py", verdict: floorVerdict(fixtureM, .python, fixtureMSpans))

        XCTAssertEqual(panel.contentView.string, fixtureM)
        XCTAssertFalse(panel.contentView.isEditable)
        assertDrawn(panel, coloured: fixtureMColoured, under: aqua)
        assertDrawn(panel, coloured: fixtureMColoured, under: darkAqua)
    }

    func testSpanColourCoversExactlyTheCharactersOfEachEncodedWidth() {
        // One span over a 2-byte, a 3-byte and a 4-byte character: 1, 1 and 2 UTF-16 units.
        let cases: [(String, CodeSpan, Range<Int>)] = [
            ("xéy", CodeSpan(start: 1, end: 3, tokenClass: .keyword), 1..<2),
            ("x日y", CodeSpan(start: 1, end: 4, tokenClass: .keyword), 1..<2),
            ("x🙂y", CodeSpan(start: 1, end: 5, tokenClass: .keyword), 1..<3),
        ]
        for (content, span, units) in cases {
            let panel = makePanel()

            panel.show(path: "w.py", verdict: floorVerdict(content, .python, [span]))

            assertDrawn(panel, coloured: [(units, .keyword)], under: aqua)
        }
    }

    func testPythonSampleIsDrawnWithEachClassInItsToken() {
        let panel = makePanel()
        let content = "def greet(who):\n    return \"hi\" + 42  # note\n"
        let spans = [
            CodeSpan(start: 0, end: 3, tokenClass: .keyword),
            CodeSpan(start: 4, end: 9, tokenClass: .name),
            CodeSpan(start: 20, end: 26, tokenClass: .keyword),
            CodeSpan(start: 27, end: 31, tokenClass: .string),
            CodeSpan(start: 34, end: 36, tokenClass: .number),
            CodeSpan(start: 38, end: 44, tokenClass: .comment),
        ]

        panel.show(path: "greet.py", verdict: floorVerdict(content, .python, spans))

        XCTAssertEqual(panel.contentView.string, content)

        let coloured: [(Range<Int>, Token)] = [
            (0..<3, .keyword), (4..<9, .name), (20..<26, .keyword), (27..<31, .string),
            (34..<36, .number), (38..<44, .comment),
        ]
        assertDrawn(panel, coloured: coloured, under: aqua)
        assertDrawn(panel, coloured: coloured, under: darkAqua)
    }

    func testFloorLanguageWithNoSpansLooksLikePlain() throws {
        let panel = makePanel()

        panel.show(path: "x.json", verdict: floorVerdict("{}", .json, []))

        let storage = try XCTUnwrap(panel.contentView.textStorage)
        var run = NSRange()
        let attributes = storage.attributes(at: 0, effectiveRange: &run)
        XCTAssertEqual(run, NSRange(location: 0, length: storage.length), "one attribute run")
        let foreground = attributes[.foregroundColor] as? NSColor
        XCTAssertTrue(
            foreground == nil || foreground == .textColor, "\(String(describing: foreground))")
    }

    func testNextFileCarriesNoColourFromTheLast() {
        let python = floorVerdict(
            "print(\"hi\")\n", .python,
            [
                CodeSpan(start: 0, end: 5, tokenClass: .name),
                CodeSpan(start: 6, end: 10, tokenClass: .string),
            ])
        let toml = floorVerdict(
            "title = \"hi\"\n", .toml,
            [
                CodeSpan(start: 0, end: 5, tokenClass: .name),
                CodeSpan(start: 8, end: 12, tokenClass: .string),
            ])
        let panel = makePanel()

        panel.show(path: "app.py", verdict: python)
        panel.show(path: "notes", verdict: .text("print(\"hi\")\n", .plain))
        XCTAssertEqual(panel.contentView.string, "print(\"hi\")\n")
        assertDrawn(panel, coloured: [], under: aqua)

        panel.show(path: "app.py", verdict: python)
        panel.show(path: "config.toml", verdict: toml)
        XCTAssertEqual(panel.contentView.string, "title = \"hi\"\n")
        assertDrawn(panel, coloured: [(0..<5, .name), (8..<12, .string)], under: aqua)
    }

    func testAdjacentSpansCanSplitACombiningSequenceAndReachTheEnd() throws {
        let panel = makePanel()
        let content = "🙂e\u{301}日"
        let spans = [
            CodeSpan(start: 4, end: 5, tokenClass: .name),
            CodeSpan(start: 5, end: 7, tokenClass: .string),
            CodeSpan(start: 7, end: 10, tokenClass: .keyword),
        ]

        panel.show(path: "combined.py", verdict: floorVerdict(content, .python, spans))

        XCTAssertEqual(panel.contentView.string, content)
        let storage = try XCTUnwrap(panel.contentView.textStorage)
        XCTAssertEqual(storage.length, 5)
        for appearance in [aqua, darkAqua] {
            assertDrawn(
                panel, coloured: [(2..<3, .name), (3..<4, .string), (4..<5, .keyword)],
                under: appearance)
        }
        for index in 0..<storage.length {
            XCTAssertNil(storage.attribute(.backgroundColor, at: index, effectiveRange: nil))
        }
    }

    func testEmptyFloorVerdictClearsPreviousColouredText() throws {
        let panel = makePanel()
        panel.show(path: "m.py", verdict: floorVerdict(fixtureM, .python, fixtureMSpans))

        panel.show(path: "empty.py", verdict: floorVerdict("", .python, []))

        XCTAssertEqual(panel.contentView.string, "")
        XCTAssertEqual(try XCTUnwrap(panel.contentView.textStorage).length, 0)
        XCTAssertEqual(visibleStrings(panel), ["empty.py"])
        XCTAssertFalse(panel.contentView.isEditable)
    }

    func testAppearanceChangeRedrawsInTheOtherValues() {
        let panel = makePanel()
        panel.appearance = aqua
        panel.show(
            path: "app.py",
            verdict: floorVerdict(
                "print(\"hi\")\n", .python,
                [
                    CodeSpan(start: 0, end: 5, tokenClass: .name),
                    CodeSpan(start: 6, end: 10, tokenClass: .string),
                ]))
        let coloured: [(Range<Int>, Token)] = [(0..<5, .name), (6..<10, .string)]
        assertDrawn(panel, coloured: coloured, under: aqua)

        // No `show` between the two: the colours are the other appearance's values.
        assertDrawn(panel, coloured: coloured, under: darkAqua)
    }

    func testGroundIsSurfaceForPlainAndFloorVerdictsInBothAppearances() throws {
        let verdicts: [FileVerdict] = [
            .text("plain words\n", .plain),
            floorVerdict(
                "print(\"hi\")\n", .python, [CodeSpan(start: 0, end: 5, tokenClass: .name)]),
        ]
        for verdict in verdicts {
            let panel = makePanel()
            panel.show(path: "f", verdict: verdict)
            let scrollView = try XCTUnwrap(panel.contentView.enclosingScrollView)

            for (appearance, value) in [
                (aqua, Self.surfaceValues.light), (darkAqua, Self.surfaceValues.dark),
            ] {
                panel.appearance = appearance
                let resolvedUnder = panel.contentView.effectiveAppearance
                XCTAssertTrue(panel.contentView.drawsBackground)
                XCTAssertTrue(scrollView.drawsBackground)
                assertSame(
                    srgb(panel.contentView.backgroundColor, under: resolvedUnder), hex(value),
                    "text view ground under \(appearance.name)")
                assertSame(
                    srgb(scrollView.backgroundColor, under: resolvedUnder), hex(value),
                    "scroll view ground under \(appearance.name)")
            }
        }
    }

    // MARK: - The code view's tokens (CP-332, CP-333, CP-335)

    func testCodePrimaryTakesItsDesignValueInEachAppearance() {
        assertSame(
            srgb(CodeColors.primary, under: aqua), hex(Token.primary.values.light),
            "primary under aqua")
        assertSame(
            srgb(CodeColors.primary, under: darkAqua), hex(Token.primary.values.dark),
            "primary under darkAqua")
    }

    func testCodeGutterColourTakesItsDesignValueInEachAppearance() {
        assertSame(
            srgb(CodeColors.gutter, under: aqua), hex(Token.gutter.values.light),
            "gutter under aqua")
        assertSame(
            srgb(CodeColors.gutter, under: darkAqua), hex(Token.gutter.values.dark),
            "gutter under darkAqua")
    }

    func testCodeTypeIsTheThirteenPointMonospacedSystemFontAtRegularWeight() {
        XCTAssertEqual(CodeType.font, .monospacedSystemFont(ofSize: 13, weight: .regular))
        XCTAssertEqual(CodeType.font.pointSize, 13)
    }

    func testCodeLinePitchIsOnePointFiveFiveTimesTheSize() {
        XCTAssertEqual(CodeType.linePitch, 20.15, accuracy: 0.0001)
        XCTAssertEqual(CodeType.linePitch, 1.55 * CodeType.font.pointSize, accuracy: 0.0001)
        // 1.55 times the font's own line height would be 24.8, which CP-332 rejects.
        XCTAssertNotEqual(CodeType.linePitch, 24.8, accuracy: 1)
    }

    func testCodeSpacingCarriesTheSixteenPointInsetAndTheTwentyFourPointGutterBase() {
        XCTAssertEqual(CodeSpacing.inset, 16)
        XCTAssertEqual(CodeSpacing.gutterBase, 24)
    }

    // MARK: - The line-number gutter (CP-336 – CP-338, CP-341)

    /// `text` in the code font on the code pitch: every row's height fixed at `CodeType.linePitch`.
    private func codeText(_ text: String) -> NSAttributedString {
        let pitch = NSMutableParagraphStyle()
        pitch.minimumLineHeight = CodeType.linePitch
        pitch.maximumLineHeight = CodeType.linePitch
        return NSAttributedString(
            string: text,
            attributes: [
                .font: CodeType.font, .paragraphStyle: pitch,
                .foregroundColor: CodeColors.primary,
            ])
    }

    /// A TextKit 1 text view over `text`, not wrapping, as the code view builds its own.
    private func makeTextView(_ text: String) -> NSTextView {
        let storage = NSTextStorage(attributedString: codeText(text))
        let layoutManager = NSLayoutManager()
        storage.addLayoutManager(layoutManager)
        let container = NSTextContainer(
            size: NSSize(
                width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude))
        container.widthTracksTextView = false
        layoutManager.addTextContainer(container)
        let textView = NSTextView(
            frame: NSRect(x: 0, y: 0, width: 600, height: 400), textContainer: container)
        textView.isEditable = false
        return textView
    }

    /// A gutter over a text view of `text`, its frame tall enough to show every row.
    private func makeGutter(
        _ text: String
    ) -> (gutter: CodeGutterView, textView: NSTextView) {
        let textView = makeTextView(text)
        let gutter = CodeGutterView(textView: textView)
        gutter.frame = NSRect(x: 0, y: 0, width: gutter.width, height: 4000)
        return (gutter, textView)
    }

    private func lines(_ count: Int) -> String {
        (1...count).map { "line \($0)\n" }.joined()
    }

    /// The width of `count` digits in the code font, measured from the font.
    private func digitsWidth(_ count: Int) -> CGFloat {
        (String(repeating: "0", count: count) as NSString)
            .size(withAttributes: [.font: CodeType.font]).width
    }

    /// Each row of `textView`'s layout: its fragment's top and its baseline, in the text view's
    /// coordinates, the extra fragment after a terminal break left out.
    private func layoutRows(
        of textView: NSTextView
    ) throws -> [(top: CGFloat, bottom: CGFloat, baseline: CGFloat)] {
        let layoutManager = try XCTUnwrap(textView.layoutManager)
        let container = try XCTUnwrap(textView.textContainer)
        layoutManager.ensureLayout(for: container)
        var rows: [(top: CGFloat, bottom: CGFloat, baseline: CGFloat)] = []
        layoutManager.enumerateLineFragments(
            forGlyphRange: NSRange(location: 0, length: layoutManager.numberOfGlyphs)
        ) { rect, _, _, glyphRange, _ in
            let location = layoutManager.location(forGlyphAt: glyphRange.location)
            let origin = textView.textContainerOrigin
            rows.append(
                (rect.minY + origin.y, rect.maxY + origin.y, rect.minY + location.y + origin.y))
        }
        return rows
    }

    private func labelTexts(_ gutter: CodeGutterView) -> [String] {
        gutter.labels.map(\.text)
    }

    func testGutterNumbersAnLFTerminatedFileOneAndTwo() {
        let (gutter, _) = makeGutter("a\nb\n")

        XCTAssertEqual(gutter.lineCount, 2)
        XCTAssertEqual(
            labelTexts(gutter), ["1", "2"], "the break that ends the file begins no line")
    }

    func testGutterNumbersAnUnterminatedFileOneAndTwo() {
        let (gutter, _) = makeGutter("a\nb")

        XCTAssertEqual(gutter.lineCount, 2)
        XCTAssertEqual(labelTexts(gutter), ["1", "2"])
    }

    func testGutterCountsCRLFAsOneBreak() {
        let (gutter, _) = makeGutter("a\r\nb\r\n")

        XCTAssertEqual(labelTexts(gutter), ["1", "2"])
    }

    func testGutterNumbersTheEmptySecondRow() throws {
        let (gutter, _) = makeGutter("a\n\n")

        XCTAssertEqual(labelTexts(gutter), ["1", "2"])
        let labels = gutter.labels
        XCTAssertEqual(labels[1].point.y - labels[0].point.y, CodeType.linePitch, accuracy: 0.5)
    }

    /// A row holding only its break has no glyph of its own for the layout to measure, and the layout
    /// reports its break at the fragment's bottom. Its number still sits on the grid its neighbours'
    /// baselines make: one pitch from each.
    func testAnEmptyRowsNumberKeepsTheBaselineGridOfTheRowsAroundIt() throws {
        let (gutter, textView) = makeGutter("a\n\n\nb\n")

        XCTAssertEqual(labelTexts(gutter), ["1", "2", "3", "4"])
        let baselines = gutter.labels.map(\.point.y)
        for (before, after) in zip(baselines, baselines.dropFirst()) {
            XCTAssertEqual(after - before, CodeType.linePitch, accuracy: 0.5)
        }
        let firstRowBaseline = try XCTUnwrap(try layoutRows(of: textView).first?.baseline)
        XCTAssertEqual(baselines[0], firstRowBaseline, accuracy: 0.5)
    }

    func testGutterNumbersALoneLFAsOneLine() {
        let (gutter, _) = makeGutter("\n")

        XCTAssertEqual(gutter.lineCount, 1)
        XCTAssertEqual(labelTexts(gutter), ["1"])
    }

    func testGutterNumbersEveryRowTheLayoutDrawsWhateverBrokeIt() {
        for text in ["a\rb", "a\u{2028}b"] {
            let (gutter, _) = makeGutter(text)

            XCTAssertEqual(labelTexts(gutter), ["1", "2"], "\(Array(text.unicodeScalars))")
        }
    }

    func testGutterOfEmptyTextHasNoLabelAndAOneDigitColumn() {
        let (gutter, _) = makeGutter("")

        XCTAssertEqual(gutter.lineCount, 0)
        XCTAssertTrue(gutter.labels.isEmpty)
        XCTAssertEqual(gutter.columnWidth, 24 + digitsWidth(1), accuracy: 0.01)
    }

    func testColumnWidthIsTwentyFourPlusTheDigitsTheFileNeeds() {
        for (count, digits) in [(9, 1), (10, 2), (100, 3)] {
            let (gutter, _) = makeGutter(lines(count))

            XCTAssertEqual(gutter.lineCount, count)
            XCTAssertEqual(
                gutter.columnWidth, 24 + digitsWidth(digits), accuracy: 0.01,
                "\(count) lines")
        }
    }

    func testGutterWidthIsTheInsetPlusTheColumn() {
        let (gutter, _) = makeGutter(lines(10))

        XCTAssertEqual(gutter.width, CodeSpacing.inset + gutter.columnWidth, accuracy: 0.0001)
    }

    func testEveryNumberEndsAtTheColumnsRightEdge() throws {
        let (gutter, _) = makeGutter(lines(10))

        let nine = try XCTUnwrap(gutter.labels.first { $0.text == "9" })
        let ten = try XCTUnwrap(gutter.labels.first { $0.text == "10" })
        XCTAssertEqual(nine.point.x, ten.point.x, accuracy: 0.0001)
        XCTAssertEqual(ten.point.x, gutter.width, accuracy: 0.0001)
    }

    func testEachNumberSitsOnItsRowsBaseline() throws {
        let (gutter, textView) = makeGutter(lines(5))

        let rows = try layoutRows(of: textView)
        XCTAssertEqual(rows.count, 5)
        XCTAssertEqual(gutter.labels.count, 5)
        for (row, label) in zip(rows, gutter.labels) {
            XCTAssertEqual(label.point.y, row.baseline, accuracy: 0.5, label.text)
            XCTAssertGreaterThan(
                label.point.y - row.top, 10,
                "\(label.text) is on the baseline, not the fragment's top")
        }
    }

    func testReloadRecomputesCountColumnAndWidthAfterATextChange() throws {
        let (gutter, textView) = makeGutter(lines(10))
        let widthWithTwoDigits = gutter.width
        XCTAssertEqual(gutter.lineCount, 10)

        textView.textStorage?.setAttributedString(codeText(lines(9)))
        gutter.reload()

        XCTAssertEqual(gutter.lineCount, 9)
        XCTAssertEqual(gutter.columnWidth, 24 + digitsWidth(1), accuracy: 0.01)
        XCTAssertLessThan(gutter.width, widthWithTwoDigits)
        XCTAssertFalse(labelTexts(gutter).contains("10"))
        XCTAssertEqual(labelTexts(gutter).last, "9")
    }

    func testLabelsAreDecimalDigitsOnlyInTheCodeFontAndGutterColour() throws {
        let (gutter, _) = makeGutter(lines(12))

        XCTAssertEqual(labelTexts(gutter), (1...12).map(String.init))
        for label in gutter.labels {
            XCTAssertTrue(label.text.allSatisfy(\.isASCII) && label.text.allSatisfy(\.isNumber))
            XCTAssertEqual(label.attributes[.font] as? NSFont, CodeType.font)
            let colour = try XCTUnwrap(label.attributes[.foregroundColor] as? NSColor)
            assertSame(
                srgb(colour, under: aqua), hex(Token.gutter.values.light), "\(label.text) light")
            assertSame(
                srgb(colour, under: darkAqua), hex(Token.gutter.values.dark), "\(label.text) dark")
        }
    }

    func testGroundIsSurfaceAndBothColoursFollowAnAppearanceChangeWithoutReload() throws {
        let (gutter, _) = makeGutter("a\n")

        for (appearance, ground, ink) in [
            (aqua, Self.surfaceValues.light, Token.gutter.values.light),
            (darkAqua, Self.surfaceValues.dark, Token.gutter.values.dark),
        ] {
            gutter.appearance = appearance
            let resolvedUnder = gutter.effectiveAppearance
            assertSame(
                srgb(gutter.ground, under: resolvedUnder), hex(ground),
                "ground under \(appearance.name)")
            let colour = try XCTUnwrap(
                gutter.labels.first?.attributes[.foregroundColor] as? NSColor)
            assertSame(
                srgb(colour, under: resolvedUnder), hex(ink), "label under \(appearance.name)")
        }
    }

    /// `labels` says where a number is drawn, and `draw(_:)` is the one that has to agree: the ink of
    /// a digit 1, which has no descender, ends on the label's baseline and at the column's right edge.
    func testTheDrawnNumberStandsOnItsLabelsBaselineAtTheRightEdge() throws {
        let (gutter, _) = makeGutter("1\n")
        gutter.appearance = aqua
        gutter.frame = NSRect(x: 0, y: 0, width: gutter.width, height: 40)
        let label = try XCTUnwrap(gutter.labels.first)
        let rep = try XCTUnwrap(gutter.bitmapImageRepForCachingDisplay(in: gutter.bounds))
        gutter.cacheDisplay(in: gutter.bounds, to: rep)
        let scale = CGFloat(rep.pixelsHigh) / gutter.bounds.height

        // The bitmap's last column is rounded up from a fractional width and is never drawn.
        let drawnColumns = Int((gutter.bounds.width * scale).rounded(.down))
        // Ink is any pixel unlike the ground, which is what the top-left corner is.
        let ground = try XCTUnwrap(rep.colorAt(x: 0, y: 0)?.usingColorSpace(.sRGB))
        var inkRows: [Int] = []
        var inkColumns: [Int] = []
        for row in 0..<rep.pixelsHigh {
            for column in 0..<drawnColumns {
                guard let pixel = rep.colorAt(x: column, y: row)?.usingColorSpace(.sRGB),
                    abs(pixel.redComponent - ground.redComponent) > 0.15
                else { continue }
                inkRows.append(row)
                inkColumns.append(column)
            }
        }
        let lowestInk = try XCTUnwrap(inkRows.max())
        let rightmostInk = try XCTUnwrap(inkColumns.max())
        // The row's bottom edge is one pixel below its last inked row.
        XCTAssertEqual(CGFloat(lowestInk + 1) / scale, label.point.y, accuracy: 1)
        XCTAssertEqual(CGFloat(rightmostInk + 1) / scale, label.point.x, accuracy: 2)
    }

    func testGutterHasNoSubviewIsNoControlAndRegistersNoDraggedType() {
        let (gutter, _) = makeGutter(lines(3))

        XCTAssertTrue(gutter.subviews.isEmpty)
        XCTAssertFalse(gutter is NSControl)
        XCTAssertTrue(gutter.registeredDraggedTypes.isEmpty)
    }

    /// The clip view's bounds change when the text scrolls; the gutter redraws, because every
    /// number's place on the screen moved.
    func testGutterRedisplaysWhenTheClipViewScrolls() throws {
        let textView = makeTextView(lines(100))
        textView.setFrameSize(NSSize(width: 600, height: 2100))
        let scrollView = NSScrollView(frame: NSRect(x: 0, y: 0, width: 400, height: 200))
        scrollView.documentView = textView
        let gutter = CodeGutterView(textView: textView)
        gutter.frame = NSRect(x: 0, y: 0, width: gutter.width, height: 200)
        // A view outside a window never reads as needing display, so both sit in one.
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 600, height: 200), styleMask: [.titled],
            backing: .buffered, defer: true)
        window.isReleasedWhenClosed = false
        window.contentView?.addSubview(scrollView)
        window.contentView?.addSubview(gutter)
        gutter.needsDisplay = false

        scrollView.contentView.scroll(to: NSPoint(x: 0, y: 400))
        scrollView.reflectScrolledClipView(scrollView.contentView)

        XCTAssertTrue(gutter.needsDisplay)
    }

    // MARK: - The code view (CP-313, CP-335, CP-337, CP-339 – CP-343)

    /// A code view of 400 by 300 points showing `text`, laid out. Its scrollers are the overlay
    /// kind, which take no room, so the insets are measured against the code view's own edges.
    private func makeCodeView(_ text: String) -> CodeView {
        let codeView = CodeView()
        codeView.frame = NSRect(x: 0, y: 0, width: 400, height: 300)
        codeView.textView.enclosingScrollView?.scrollerStyle = .overlay
        codeView.show(codeText(text))
        codeView.layoutSubtreeIfNeeded()
        return codeView
    }

    private func clipView(of codeView: CodeView) throws -> NSClipView {
        try XCTUnwrap(codeView.textView.enclosingScrollView?.contentView)
    }

    private func scroll(_ codeView: CodeView, to origin: NSPoint) throws {
        let scrollView = try XCTUnwrap(codeView.textView.enclosingScrollView)
        scrollView.contentView.scroll(to: origin)
        scrollView.reflectScrolledClipView(scrollView.contentView)
        codeView.layoutSubtreeIfNeeded()
    }

    private func scrollToBottom(_ codeView: CodeView) throws {
        let clip = try clipView(of: codeView)
        try scroll(
            codeView, to: NSPoint(x: 0, y: codeView.textView.frame.height - clip.bounds.height))
    }

    func testTextViewIsTextKitOneNonEditableSelectableAndPlain() throws {
        let codeView = makeCodeView("a\n")

        XCTAssertNil(codeView.textView.textLayoutManager, "TextKit 1 from construction")
        XCTAssertNotNil(codeView.textView.layoutManager)
        XCTAssertFalse(codeView.textView.isEditable)
        XCTAssertFalse(codeView.textView.isRichText)
        XCTAssertTrue(codeView.textView.isSelectable)
        XCTAssertFalse(
            try XCTUnwrap(codeView.textView.textContainer).widthTracksTextView, "no wrapping")
    }

    func testCodeViewGroundIsSurfaceUnderBothAppearances() throws {
        let codeView = makeCodeView("a\n")
        let scrollView = try XCTUnwrap(codeView.textView.enclosingScrollView)

        XCTAssertTrue(codeView.textView.drawsBackground)
        XCTAssertTrue(scrollView.drawsBackground)
        for (appearance, value) in [
            (aqua, Self.surfaceValues.light), (darkAqua, Self.surfaceValues.dark),
        ] {
            codeView.appearance = appearance
            let resolvedUnder = codeView.textView.effectiveAppearance
            assertSame(
                srgb(codeView.textView.backgroundColor, under: resolvedUnder), hex(value),
                "text view ground under \(appearance.name)")
            assertSame(
                srgb(scrollView.backgroundColor, under: resolvedUnder), hex(value),
                "scroll view ground under \(appearance.name)")
            assertSame(
                srgb(codeView.gutter.ground, under: resolvedUnder), hex(value),
                "gutter ground under \(appearance.name)")
        }
    }

    func testLeftAndTopInsetsAreSixteenWhenScrolledToTheTop() throws {
        let codeView = makeCodeView(lines(40))

        let columnLeft = codeView.gutter.frame.minX + CodeSpacing.inset
        XCTAssertEqual(columnLeft - codeView.bounds.minX, 16, accuracy: 0.5)
        let firstRow = try XCTUnwrap(try layoutRows(of: codeView.textView).first)
        let firstRowTop = codeView.convert(NSPoint(x: 0, y: firstRow.top), from: codeView.textView)
            .y
        XCTAssertEqual(firstRowTop - codeView.bounds.minY, 16, accuracy: 0.5)
    }

    func testBottomInsetIsSixteenAtTheEndOfAnLFTerminatedFile() throws {
        try assertBottomInsetIsSixteen(for: lines(40))
    }

    func testBottomInsetIsSixteenAtTheEndOfAnUnterminatedFile() throws {
        try assertBottomInsetIsSixteen(for: String(lines(40).dropLast()))
    }

    private func assertBottomInsetIsSixteen(
        for text: String, file: StaticString = #filePath, line: UInt = #line
    ) throws {
        let codeView = makeCodeView(text)

        try scrollToBottom(codeView)

        let lastRow = try XCTUnwrap(try layoutRows(of: codeView.textView).last)
        XCTAssertEqual(codeView.gutter.lineCount, 40, file: file, line: line)
        let lastRowBottom = codeView.convert(
            NSPoint(x: 0, y: lastRow.bottom), from: codeView.textView
        ).y
        XCTAssertEqual(
            codeView.bounds.maxY - lastRowBottom, 16, accuracy: 0.5,
            "the last numbered row's bottom", file: file, line: line)
    }

    func testRightInsetIsSixteenAtTheRightEndOfAWideRow() throws {
        let codeView = makeCodeView(String(repeating: "x", count: 200))
        let textView = codeView.textView
        let clip = try clipView(of: codeView)
        XCTAssertGreaterThan(
            textView.frame.width, clip.bounds.width, "the row is wider than the view")

        try scroll(codeView, to: NSPoint(x: textView.frame.width - clip.bounds.width, y: 0))

        let layoutManager = try XCTUnwrap(textView.layoutManager)
        let container = try XCTUnwrap(textView.textContainer)
        let lastCharacter = layoutManager.boundingRect(
            forGlyphRange: NSRange(location: layoutManager.numberOfGlyphs - 1, length: 1),
            in: container)
        let lastCharacterEnd = lastCharacter.maxX + textView.textContainerOrigin.x
        XCTAssertEqual(clip.bounds.maxX - lastCharacterEnd, 16, accuracy: 0.5)
    }

    func testTextStartsAtTheColumnsRightEdgeAndTheGutterStaysPutUnderHorizontalScroll() throws {
        let codeView = makeCodeView(String(repeating: "x", count: 200) + "\nshort\n")
        let textView = codeView.textView
        let scrollView = try XCTUnwrap(textView.enclosingScrollView)
        let clip = try clipView(of: codeView)
        let layoutManager = try XCTUnwrap(textView.layoutManager)
        let container = try XCTUnwrap(textView.textContainer)
        let gutterFrame = codeView.gutter.frame

        XCTAssertEqual(scrollView.frame.minX, gutterFrame.maxX, accuracy: 0.5)
        for row in 0..<2 {
            let glyph = layoutManager.glyphIndexForCharacter(at: row == 0 ? 0 : 201)
            let firstCharacter = layoutManager.boundingRect(
                forGlyphRange: NSRange(location: glyph, length: 1), in: container)
            XCTAssertEqual(
                firstCharacter.minX + textView.textContainerOrigin.x - clip.bounds.minX, 0,
                accuracy: 0.5, "row \(row + 1) starts at the clip view's left edge")
        }

        try scroll(codeView, to: NSPoint(x: 300, y: 0))

        XCTAssertEqual(codeView.gutter.frame, gutterFrame)
        XCTAssertEqual(scrollView.frame.minX, codeView.gutter.frame.maxX, accuracy: 0.5)
    }

    func testNumbersFollowTheirLinesUnderVerticalScroll() throws {
        let codeView = makeCodeView(lines(200))
        let rows = try layoutRows(of: codeView.textView)

        for offset in [CGFloat(2300), 2900] {
            try scroll(codeView, to: NSPoint(x: 0, y: offset))

            let labels = codeView.gutter.labels
            let label = try XCTUnwrap(labels.first { $0.text == "120" }, "line 120 is visible")
            let numberBaseline = codeView.convert(label.point, from: codeView.gutter).y
            let lineBaseline = codeView.convert(
                NSPoint(x: 0, y: rows[119].baseline), from: codeView.textView
            ).y
            XCTAssertEqual(numberBaseline, lineBaseline, accuracy: 0.5, "scrolled to \(offset)")
            XCTAssertLessThan(labels.count, 30, "only the rows in view are labelled")
        }
    }

    func testATenLineFileThenANineLineFileShowsAOneDigitColumn() {
        let codeView = makeCodeView(lines(10))
        codeView.show(codeText(lines(9)))
        codeView.layoutSubtreeIfNeeded()

        XCTAssertEqual(codeView.gutter.lineCount, 9)
        XCTAssertEqual(codeView.gutter.columnWidth, 24 + digitsWidth(1), accuracy: 0.01)
        XCTAssertEqual(codeView.gutter.frame.width, codeView.gutter.width, accuracy: 0.5)
        XCTAssertEqual(labelTexts(codeView.gutter), (1...9).map(String.init))
    }

    func testShowScrollsBackToTheTopLeft() throws {
        let wide = (1...100).map { _ in String(repeating: "x", count: 100) + "\n" }.joined()
        let codeView = makeCodeView(wide)
        try scroll(codeView, to: NSPoint(x: 250, y: 600))
        XCTAssertNotEqual(try clipView(of: codeView).bounds.origin, .zero)

        codeView.show(codeText(wide))
        codeView.layoutSubtreeIfNeeded()

        XCTAssertEqual(try clipView(of: codeView).bounds.origin, .zero)
    }

    func testCopyingAllTheTextYieldsTheFilesCharactersWithNoNumber() throws {
        let codeView = makeCodeView("print(\"hi\")\n")
        let pasteboard = NSPasteboard(name: NSPasteboard.Name("nozoki-test-\(UUID().uuidString)"))
        defer { pasteboard.releaseGlobally() }

        codeView.textView.selectAll(nil)
        pasteboard.clearContents()
        XCTAssertTrue(codeView.textView.writeSelection(to: pasteboard, type: .string))

        XCTAssertEqual(pasteboard.string(forType: .string), "print(\"hi\")\n")
        XCTAssertEqual(codeView.textView.string, "print(\"hi\")\n")
    }

    func testCodeViewScrollViewAndTextViewRegisterNoDraggedTypeAndNoPartIsAControl() throws {
        let codeView = makeCodeView(lines(3))
        let scrollView = try XCTUnwrap(codeView.textView.enclosingScrollView)

        for view in [codeView, scrollView, codeView.textView] as [NSView] {
            XCTAssertTrue(view.registeredDraggedTypes.isEmpty, "\(view)")
        }
        for view in [codeView] + descendants(of: codeView) {
            XCTAssertFalse(view is NSControl, "\(view)")
        }
        XCTAssertFalse(codeView.textView.isEditable)
    }
}
