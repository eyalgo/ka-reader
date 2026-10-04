import AppKit
import XCTest

@testable import Surfaces

/// The reading panel's six states (CP-246 – CP-286, CP-345 – CP-355): no file, text,
/// cannot-display, failed read, reading and stopped. The first four are put in the panel as a path
/// and a `FileVerdict`, the value the shell decodes; *reading* is the read in flight, and *stopped*
/// is the read that answered nothing.
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
        // The base ink is `{colors.primary}`, the one ink of a file with no spans (CP-333).
        let foreground = try XCTUnwrap(attributes[.foregroundColor] as? NSColor)
        assertSame(
            srgb(foreground, under: aqua), hex(Token.primary.values.light),
            "the one run's ink is {colors.primary} (CP-333)")
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
    /// colour (`docs/DESIGN.md:L411`, `:L413`). `inkMuted` and `line` are the path line's ink and
    /// hairline (`docs/DESIGN.md:L413`, `:L418`).
    private enum Token {
        case keyword, string, number, comment, name, primary, gutter, inkMuted, line

        var values: (light: UInt32, dark: UInt32) {
            switch self {
            case .keyword: return (0x7A2E8F, 0xD0A2E6)
            case .string: return (0x1A6B3A, 0x8FD6A4)
            case .number: return (0x9A4B00, 0xF0B47A)
            case .comment: return (0x6A6C72, 0x9A9BA0)
            case .name: return (0x0F5A9A, 0x8CC4F5)
            case .primary: return (0x1E1F22, 0xE7E7E4)
            case .gutter: return (0x6F7177, 0x8E8F94)
            case .inkMuted: return (0x5B5D63, 0xABACB0)
            case .line: return (0xD8D8D4, 0x3B3C41)
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

    /// `color`'s alpha, resolved under `appearance`.
    private func alpha(_ color: NSColor, under appearance: NSAppearance) -> CGFloat {
        var alpha: CGFloat = -1
        appearance.performAsCurrentDrawingAppearance {
            alpha = color.usingColorSpace(.sRGB)?.alphaComponent ?? -1
        }
        return alpha
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

    /// Every UTF-16 unit of the panel is `{colors.primary}`, except those in `coloured`, which are in their
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
            // A unit in no span is `{colors.primary}` (CP-333).
            let token = coloured.first(where: { $0.0.contains(index) })?.1 ?? .primary
            let expected = hex(isDark ? token.values.dark : token.values.light)
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
        let foreground = try XCTUnwrap(attributes[.foregroundColor] as? NSColor)
        assertSame(
            srgb(foreground, under: aqua), hex(Token.primary.values.light),
            "a floor language with no spans is {colors.primary} (CP-333)")
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

    // MARK: - The path line's tokens (CP-357, CP-363)

    func testPathMutedInkTakesItsDesignValueInEachAppearance() {
        for (appearance, value) in [
            (aqua, Token.inkMuted.values.light), (darkAqua, Token.inkMuted.values.dark),
        ] {
            assertSame(
                srgb(CodeColors.inkMuted, under: appearance), hex(value),
                "ink-muted under \(appearance.name) (CP-357)")
            XCTAssertEqual(
                alpha(CodeColors.inkMuted, under: appearance), 1, "ink-muted is opaque")
        }
    }

    func testPathHairlineTakesItsDesignValueInEachAppearance() {
        for (appearance, value) in [
            (aqua, Token.line.values.light), (darkAqua, Token.line.values.dark),
        ] {
            assertSame(
                srgb(CodeColors.line, under: appearance), hex(value),
                "line under \(appearance.name) (CP-363)")
            XCTAssertEqual(alpha(CodeColors.line, under: appearance), 1, "line is opaque")
        }
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

    /// The gutter column's right-hand padding is `{spacing.sm}` (`docs/DESIGN.md` § Components
    /// *Code*): 8 points, lying inside the column's width (CP-368).
    func testGutterPaddingIsEightPoints() {
        XCTAssertEqual(CodeSpacing.gutterPadding, 8)
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

    func testEveryNumberEndsEightPointsInsideTheColumnsRightEdge() throws {
        let (gutter, _) = makeGutter(lines(10))

        let nine = try XCTUnwrap(gutter.labels.first { $0.text == "9" })
        let ten = try XCTUnwrap(gutter.labels.first { $0.text == "10" })
        XCTAssertEqual(nine.point.x, ten.point.x, accuracy: 0.0001)
        XCTAssertEqual(
            ten.point.x, gutter.width - CodeSpacing.gutterPadding, accuracy: 0.0001)
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
    /// a digit 1, which has no descender, ends on the label's baseline and at the label's x, which is
    /// `{spacing.sm}` (8 points) inside the column's right edge.
    func testTheDrawnNumberStandsOnItsLabelsBaselineEightPointsInsideTheRightEdge() throws {
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

    // CP-335 applies to the longest row whether it ends the file or precedes another row.
    func testRightInsetExcludesTheBreakAfterTheLongestRow() throws {
        let wide = String(repeating: "x", count: 200)
        for ending in ["\n", "\r\n", "\r", "\u{2028}"] {
            for tail in ["", "short"] {
                let codeView = makeCodeView(wide + ending + tail)
                let textView = codeView.textView
                let clip = try clipView(of: codeView)
                try scroll(
                    codeView, to: NSPoint(x: textView.frame.width - clip.bounds.width, y: 0))
                let layout = try XCTUnwrap(textView.layoutManager)
                let container = try XCTUnwrap(textView.textContainer)
                let lastGlyph = layout.glyphIndexForCharacter(at: (wide as NSString).length - 1)
                let end =
                    layout.boundingRect(
                        forGlyphRange: NSRange(location: lastGlyph, length: 1), in: container
                    ).maxX + textView.textContainerOrigin.x
                XCTAssertEqual(clip.bounds.maxX - end, 16, accuracy: 0.5)
            }
        }
    }

    // CP-342: replacing a wide file must discard its horizontal extent as well as its numbers.
    func testReplacingAWideFileRemovesItsOldHorizontalScrollExtent() throws {
        let codeView = makeCodeView(String(repeating: "x", count: 200))
        try scroll(codeView, to: NSPoint(x: 500, y: 0))

        codeView.show(codeText("short\n"))
        codeView.layoutSubtreeIfNeeded()

        let clip = try clipView(of: codeView)
        XCTAssertEqual(clip.bounds.origin, .zero)
        XCTAssertLessThanOrEqual(codeView.textView.frame.width, clip.bounds.width + 0.5)
        XCTAssertEqual(codeView.textView.string, "short\n")
        XCTAssertEqual(labelTexts(codeView.gutter), ["1"])
    }

    // CP-339 numbers exactly the visible rows, including partially visible rows at either edge.
    func testGutterLabelsExactlyTheRowsIntersectingTheViewport() throws {
        let codeView = makeCodeView(lines(200))
        let rows = try layoutRows(of: codeView.textView)
        for offset in [CGFloat(1), 30, 2310] {
            try scroll(codeView, to: NSPoint(x: 0, y: offset))
            let visible = try clipView(of: codeView).bounds
            let expected = rows.enumerated().compactMap { index, row in
                row.bottom > visible.minY && row.top < visible.maxY ? String(index + 1) : nil
            }
            XCTAssertEqual(labelTexts(codeView.gutter), expected)
        }
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

        for offset in [CGFloat(2300), 2350] {
            try scroll(codeView, to: NSPoint(x: 0, y: offset))

            let labels = codeView.gutter.labels
            let clipOrigin = try clipView(of: codeView).bounds.origin
            let label = try XCTUnwrap(
                labels.first { $0.text == "120" },
                "line 120 is visible: clip \(clipOrigin), text \(codeView.textView.frame), gutter \(codeView.gutter.frame), labels \(labels.map(\.text))"
            )
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

        codeView.textView.setSelectedRange(
            NSRange(location: 0, length: (codeView.textView.string as NSString).length))
        pasteboard.clearContents()
        XCTAssertTrue(
            codeView.textView.writeSelection(
                to: pasteboard, types: codeView.textView.writablePasteboardTypes))

        XCTAssertEqual(pasteboard.string(forType: .string), "print(\"hi\")\n")
        XCTAssertEqual(codeView.textView.string, "print(\"hi\")\n")
    }

    func testCodeViewScrollViewAndTextViewRegisterNoDraggedTypeAndNoPartIsAControl() throws {
        let codeView = makeCodeView(lines(3))
        let scrollView = try XCTUnwrap(codeView.textView.enclosingScrollView)

        for view in [codeView, scrollView, codeView.textView] as [NSView] {
            XCTAssertTrue(view.registeredDraggedTypes.isEmpty, "\(view)")
        }
        for view in [codeView, scrollView, codeView.textView, codeView.gutter] as [NSView] {
            XCTAssertFalse(view is NSControl, "\(view)")
        }
        XCTAssertFalse(codeView.textView.isEditable)
    }

    // MARK: - The gutter's right-hand padding (CP-368 – CP-376)

    /// `{spacing.sm}`, written out here so that these tests assert 8 points and not the token's own
    /// value; `testGutterPaddingIsEightPoints` pins the token to it.
    private let padding: CGFloat = 8

    /// A file of `count` lines as the panel is shown one: plain text, or a Python file whose every
    /// line carries a keyword span and a string span.
    private func fileOfLines(
        highlighted: Bool, lines count: Int
    ) -> (path: String, verdict: FileVerdict) {
        guard highlighted else { return ("notes.txt", .text(lines(count), .plain)) }
        // `def f = "s"` and its break are 12 bytes: the keyword is bytes 0..<3, the string 8..<11.
        let content = String(repeating: "def f = \"s\"\n", count: count)
        let spans = (0..<count).flatMap { index in
            [
                CodeSpan(start: index * 12, end: index * 12 + 3, tokenClass: .keyword),
                CodeSpan(start: index * 12 + 8, end: index * 12 + 11, tokenClass: .string),
            ]
        }
        return ("a.py", floorVerdict(content, .python, spans))
    }

    /// Ten lines, the first of them 200 characters of a block glyph that inks densely, so that text
    /// drawn over a number or into the band would show as ink there. The highlighted file's first
    /// line carries a keyword span, a string span and a number span, each of whole 3-byte glyphs.
    private func fileWithAWideFirstLine(
        highlighted: Bool
    ) -> (path: String, verdict: FileVerdict) {
        let content = String(repeating: "█", count: 200) + "\n" + lines(9)
        guard highlighted else { return ("notes.txt", .text(content, .plain)) }
        let spans = [
            CodeSpan(start: 0, end: 3, tokenClass: .keyword),
            CodeSpan(start: 3, end: 9, tokenClass: .string),
            CodeSpan(start: 597, end: 600, tokenClass: .number),
        ]
        return ("a.py", floorVerdict(content, .python, spans))
    }

    private func kindName(highlighted: Bool) -> String { highlighted ? "highlighted" : "plain" }

    private func codeView(of panel: ReadingPanelView) throws -> CodeView {
        try XCTUnwrap(gutter(of: panel).superview as? CodeView)
    }

    /// Where the gutter's edge, its numbers' right ends and each shown line's first character stand,
    /// in the code view's coordinates.
    private struct GutterGeometry {
        let columnWidth: CGFloat
        let width: CGFloat
        let frame: NSRect
        let numberEnds: [NSPoint]
        let lineStarts: [CGFloat]
    }

    private func geometry(of codeView: CodeView) throws -> GutterGeometry {
        codeView.layoutSubtreeIfNeeded()
        let gutter = codeView.gutter
        let textView = codeView.textView
        let layoutManager = try XCTUnwrap(textView.layoutManager)
        let container = try XCTUnwrap(textView.textContainer)
        let numberEnds = gutter.labels.map { codeView.convert($0.point, from: gutter) }
        let text = textView.string as NSString
        var lineStarts: [CGFloat] = []
        var index = 0
        while index < text.length, lineStarts.count < numberEnds.count {
            let glyph = layoutManager.glyphIndexForCharacter(at: index)
            let firstCharacter = layoutManager.boundingRect(
                forGlyphRange: NSRange(location: glyph, length: 1), in: container)
            lineStarts.append(
                codeView.convert(
                    NSPoint(x: firstCharacter.minX + textView.textContainerOrigin.x, y: 0),
                    from: textView
                ).x)
            index = NSMaxRange(text.lineRange(for: NSRange(location: index, length: 0)))
        }
        return GutterGeometry(
            columnWidth: gutter.columnWidth, width: gutter.width, frame: gutter.frame,
            numberEnds: numberEnds, lineStarts: lineStarts)
    }

    /// Every number ends 8 points inside the gutter's right edge, and every line starts at that edge,
    /// 8 points after its number (CP-368, CP-372). The frame's edge is the layout's, snapped to the
    /// pixel grid, so it is read to half a point; the gutter's own width is read exactly.
    private func assertPaddedAndSeparated(
        _ geometry: GutterGeometry, _ context: String,
        file: StaticString = #filePath, line: UInt = #line
    ) {
        XCTAssertFalse(geometry.numberEnds.isEmpty, context, file: file, line: line)
        XCTAssertEqual(
            geometry.lineStarts.count, geometry.numberEnds.count, context, file: file, line: line)
        for (end, start) in zip(geometry.numberEnds, geometry.lineStarts) {
            XCTAssertEqual(
                end.x, geometry.width - padding, accuracy: 0.01, "number end, \(context)",
                file: file, line: line)
            XCTAssertEqual(
                end.x, geometry.frame.maxX - padding, accuracy: 0.5, "number to edge, \(context)",
                file: file, line: line)
            XCTAssertEqual(
                start, geometry.frame.maxX, accuracy: 0.5, "line start, \(context)",
                file: file, line: line)
            XCTAssertEqual(
                start, end.x + padding, accuracy: 0.5, "number to line, \(context)",
                file: file, line: line)
        }
    }

    private func assertSameGeometry(
        _ actual: GutterGeometry, _ expected: GutterGeometry, _ context: String,
        file: StaticString = #filePath, line: UInt = #line
    ) {
        XCTAssertEqual(actual.frame, expected.frame, context, file: file, line: line)
        XCTAssertEqual(
            actual.columnWidth, expected.columnWidth, accuracy: 0.0001, context,
            file: file, line: line)
        XCTAssertEqual(actual.numberEnds, expected.numberEnds, context, file: file, line: line)
        XCTAssertEqual(actual.lineStarts, expected.lineStarts, context, file: file, line: line)
    }

    /// A render of a view, read for ink as the drawn-number test reads one: a pixel whose red
    /// component differs from the ground's by more than 0.15, the ground being the top-left pixel.
    private struct InkRender {
        let rep: NSBitmapImageRep
        let scale: CGFloat
        let ground: NSColor

        func isInk(column: Int, row: Int) -> Bool {
            guard let pixel = rep.colorAt(x: column, y: row)?.usingColorSpace(.sRGB) else {
                return false
            }
            return abs(pixel.redComponent - ground.redComponent) > 0.15
        }

        /// The first pixel column that starts at or after `x` points.
        func column(atOrAfter x: CGFloat) -> Int { Int((x * scale).rounded(.up)) }

        /// The pixel columns wholly left of `x` points. The bitmap's last column is rounded up from
        /// a fractional width and is never drawn, so a range that reaches the view's right edge ends
        /// here.
        func columns(endingAt x: CGFloat) -> Int { Int((x * scale).rounded(.down)) }

        func hasInk(columns: Range<Int>) -> Bool {
            for row in 0..<rep.pixelsHigh {
                for column in columns where isInk(column: column, row: row) { return true }
            }
            return false
        }

        func inkedPixels(columns: Range<Int>) -> Set<[Int]> {
            var inked: Set<[Int]> = []
            for row in 0..<rep.pixelsHigh {
                for column in columns where isInk(column: column, row: row) {
                    inked.insert([column, row])
                }
            }
            return inked
        }
    }

    private func render(_ view: NSView) throws -> InkRender {
        let rep = try XCTUnwrap(view.bitmapImageRepForCachingDisplay(in: view.bounds))
        view.cacheDisplay(in: view.bounds, to: rep)
        let ground = try XCTUnwrap(rep.colorAt(x: 0, y: 0)?.usingColorSpace(.sRGB))
        return InkRender(
            rep: rep, scale: CGFloat(rep.pixelsHigh) / view.bounds.height, ground: ground)
    }

    /// The drawn pixel columns of the band: from the first column at or after the numbers' right end
    /// to the last drawn column of a gutter `gutterWidth` points wide.
    private func band(of render: InkRender, gutterWidth: CGFloat) -> Range<Int> {
        render.column(atOrAfter: gutterWidth - padding)..<render.columns(endingAt: gutterWidth)
    }

    /// The column of 100 lines holds no digit in the 8 points that end it, under each appearance
    /// (CP-369).
    func testGutterPaddingContainsOnlyGroundUnderBothAppearances() throws {
        for appearance in [aqua, darkAqua] {
            let (gutter, _) = makeGutter(lines(100))
            gutter.appearance = appearance
            gutter.frame = NSRect(x: 0, y: 0, width: gutter.width, height: 2200)
            let context = "100 lines under \(appearance.name)"
            XCTAssertTrue(gutter.labels.contains { $0.text == "100" }, "100 is shown, \(context)")

            let rendered = try render(gutter)

            let band = band(of: rendered, gutterWidth: gutter.width)
            XCTAssertFalse(band.isEmpty, "the band has drawn columns, \(context)")
            XCTAssertTrue(
                rendered.inkedPixels(columns: band).isEmpty, "the band is ground, \(context)")
            XCTAssertTrue(
                rendered.hasInk(columns: 0..<band.lowerBound),
                "the digits are drawn left of the band, \(context)")
        }
    }

    func testEveryNumberKeepsItsPaddingAcrossOneTwoAndThreeDigitColumns() {
        for (count, digits) in [(9, 1), (10, 2), (100, 3)] {
            for appearance in [aqua, darkAqua] {
                let (gutter, _) = makeGutter(lines(count))
                gutter.appearance = appearance
                let context = "\(count) lines under \(appearance.name)"

                XCTAssertEqual(
                    gutter.columnWidth, 24 + digitsWidth(digits), accuracy: 0.01, context)
                XCTAssertEqual(gutter.width, 16 + gutter.columnWidth, accuracy: 0.0001, context)
                let labels = gutter.labels
                XCTAssertEqual(labels.count, count, context)
                for label in labels {
                    XCTAssertEqual(
                        label.point.x, gutter.width - padding, accuracy: 0.0001,
                        "\(label.text), \(context)")
                }
                if count == 100 {
                    XCTAssertTrue(
                        ["9", "99", "100"].allSatisfy { shown in
                            labels.contains { $0.text == shown }
                        }, "9, 99 and 100 are shown together, \(context)")
                }
            }
        }
    }

    /// A 10-line file replaced by a 9-line one, and that one by a 10-line one, through the panel's
    /// code view (CP-371).
    func testReplacingTheFileChangesOnlyTheDigitAllowance() throws {
        let allowance = digitsWidth(2) - digitsWidth(1)
        for highlighted in [false, true] {
            for appearance in [aqua, darkAqua] {
                let kind = kindName(highlighted: highlighted)
                let context = "\(kind) under \(appearance.name)"
                let panel = makePanel()
                panel.appearance = appearance
                var widths: [CGFloat] = []
                for count in [10, 9, 10] {
                    let file = fileOfLines(highlighted: highlighted, lines: count)
                    panel.show(path: file.path, verdict: file.verdict)
                    let gutter = try gutter(of: panel)
                    widths.append(gutter.width)

                    XCTAssertEqual(gutter.lineCount, count, "\(count) lines, \(context)")
                    XCTAssertEqual(
                        gutter.frame.width, gutter.width, accuracy: 0.5,
                        "\(count) lines, frame, \(context)")
                    XCTAssertEqual(gutter.labels.count, count, "\(count) lines, \(context)")
                    for label in gutter.labels {
                        XCTAssertEqual(
                            label.point.x, gutter.width - padding, accuracy: 0.0001,
                            "\(label.text) of \(count) lines, \(context)")
                    }
                }
                XCTAssertEqual(widths[0] - widths[1], allowance, accuracy: 0.01, context)
                XCTAssertEqual(widths[2] - widths[1], allowance, accuracy: 0.01, context)
            }
        }
    }

    func testEachLinesCodeStartsEightPointsAfterItsNumber() throws {
        for highlighted in [false, true] {
            for appearance in [aqua, darkAqua] {
                let kind = kindName(highlighted: highlighted)
                let panel = makePanel()
                panel.appearance = appearance
                let file = fileOfLines(highlighted: highlighted, lines: 10)
                panel.show(path: file.path, verdict: file.verdict)

                let geometry = try geometry(of: codeView(of: panel))

                XCTAssertEqual(geometry.numberEnds.count, 10)
                assertPaddedAndSeparated(geometry, "\(kind) under \(appearance.name)")
            }
        }
    }

    /// The text scrolled 300 points aside leaves the gutter, its numbers and the band where they
    /// were, and draws nothing over them (CP-373); scrolled back, each line starts at the edge
    /// again (CP-372).
    func testHorizontalScrollLeavesNumbersAndPaddingFixedAndClipsTheCode() throws {
        for highlighted in [false, true] {
            for appearance in [aqua, darkAqua] {
                let kind = kindName(highlighted: highlighted)
                let context = "\(kind) under \(appearance.name)"
                let panel = makePanel()
                panel.appearance = appearance
                let file = fileWithAWideFirstLine(highlighted: highlighted)
                panel.show(path: file.path, verdict: file.verdict)
                let codeView = try codeView(of: panel)
                let scrollView = try XCTUnwrap(codeView.textView.enclosingScrollView)
                let gutter = codeView.gutter
                let before = try geometry(of: codeView)
                assertPaddedAndSeparated(before, "at the left end, \(context)")
                let renderedBefore = try render(codeView)
                let gutterColumns = 0..<renderedBefore.columns(endingAt: gutter.frame.maxX)
                let codeEnd = renderedBefore.columns(endingAt: codeView.bounds.width)
                let codeColumns = renderedBefore.column(atOrAfter: gutter.frame.maxX)..<codeEnd
                let band = band(of: renderedBefore, gutterWidth: gutter.frame.maxX)
                let gutterInkBefore = renderedBefore.inkedPixels(columns: gutterColumns)

                XCTAssertFalse(band.isEmpty, "the band has drawn columns, \(context)")
                XCTAssertTrue(
                    renderedBefore.inkedPixels(columns: band).isEmpty,
                    "the band is ground before the scroll, \(context)")
                XCTAssertFalse(gutterInkBefore.isEmpty, "the numbers are drawn, \(context)")
                XCTAssertTrue(
                    renderedBefore.hasInk(columns: codeColumns),
                    "the code is drawn before the scroll, \(context)")

                try scroll(codeView, to: NSPoint(x: 300, y: 0))

                XCTAssertEqual(
                    try clipView(of: codeView).bounds.minX, 300, accuracy: 0.5,
                    "the clip view reached the position, \(context)")
                let scrolled = try geometry(of: codeView)
                XCTAssertEqual(scrolled.frame, before.frame, context)
                XCTAssertEqual(scrolled.numberEnds, before.numberEnds, context)
                XCTAssertEqual(scrollView.frame.minX, gutter.frame.maxX, accuracy: 0.5, context)
                let renderedAfter = try render(codeView)
                XCTAssertTrue(
                    renderedAfter.inkedPixels(columns: band).isEmpty,
                    "the band is ground after the scroll, \(context)")
                XCTAssertEqual(
                    renderedAfter.inkedPixels(columns: gutterColumns), gutterInkBefore,
                    "the numbers' ink is where it was, \(context)")
                XCTAssertTrue(
                    renderedAfter.hasInk(columns: codeColumns),
                    "the code is drawn after the scroll, \(context)")

                try scroll(codeView, to: .zero)

                assertPaddedAndSeparated(try geometry(of: codeView), "back at the left, \(context)")
            }
        }
    }

    func testHighlightedAndPlainFilesHaveTheSameGutterGeometry() throws {
        for appearance in [aqua, darkAqua] {
            var shown: [GutterGeometry] = []
            for highlighted in [true, false] {
                let kind = kindName(highlighted: highlighted)
                let panel = makePanel()
                panel.appearance = appearance
                let file = fileOfLines(highlighted: highlighted, lines: 12)
                panel.show(path: file.path, verdict: file.verdict)

                let geometry = try geometry(of: codeView(of: panel))

                XCTAssertEqual(geometry.numberEnds.count, 12)
                XCTAssertEqual(
                    geometry.columnWidth, 24 + digitsWidth(2), accuracy: 0.01,
                    "\(kind) under \(appearance.name)")
                assertPaddedAndSeparated(geometry, "\(kind) under \(appearance.name)")
                shown.append(geometry)
            }
            assertSameGeometry(shown[0], shown[1], "highlighted and plain under \(appearance.name)")
        }
    }

    /// The appearance changes while the file stays shown, in each direction (CP-374).
    func testAppearanceChangesMoveNeitherNumbersNorCode() throws {
        for highlighted in [false, true] {
            for (from, to) in [(aqua, darkAqua), (darkAqua, aqua)] {
                let kind = kindName(highlighted: highlighted)
                let context = "\(kind), \(from.name) to \(to.name)"
                let panel = makePanel()
                panel.appearance = from
                let file = fileOfLines(highlighted: highlighted, lines: 10)
                panel.show(path: file.path, verdict: file.verdict)
                let codeView = try codeView(of: panel)
                let before = try geometry(of: codeView)

                panel.appearance = to
                panel.layoutSubtreeIfNeeded()

                let after = try geometry(of: codeView)
                assertSameGeometry(after, before, context)
                assertPaddedAndSeparated(after, context)
            }
        }
    }

    // MARK: - The panel draws through the code view (CP-331, CP-333, CP-343)

    /// The gutter the panel's code view carries, found by walking the panel.
    private func gutter(of panel: ReadingPanelView) throws -> CodeGutterView {
        // Labels are for the rows the gutter's frame shows, so the panel is laid out first.
        panel.layoutSubtreeIfNeeded()
        return try XCTUnwrap(descendants(of: panel).compactMap { $0 as? CodeGutterView }.first)
    }

    func testNotesTxtIsDrawnInTheCodeTypePrimaryInkOnSurfaceUnderEachAppearance() throws {
        let panel = makePanel()
        panel.show(path: "notes.txt", verdict: .text("hello\n", .plain))
        let scrollView = try XCTUnwrap(panel.contentView.enclosingScrollView)
        let gutter = try gutter(of: panel)

        for (appearance, ink, ground, number) in [
            (aqua, Token.primary.values.light, Self.surfaceValues.light, Token.gutter.values.light),
            (
                darkAqua, Token.primary.values.dark, Self.surfaceValues.dark,
                Token.gutter.values.dark
            ),
        ] {
            panel.appearance = appearance
            let resolvedUnder = panel.contentView.effectiveAppearance
            for (index, colour) in foregrounds(of: panel).enumerated() {
                let storage = try XCTUnwrap(panel.contentView.textStorage)
                XCTAssertEqual(
                    storage.attribute(.font, at: index, effectiveRange: nil) as? NSFont,
                    CodeType.font, "unit \(index) font")
                assertSame(
                    srgb(try XCTUnwrap(colour), under: resolvedUnder), hex(ink),
                    "unit \(index) ink under \(appearance.name) (CP-333)")
            }
            assertSame(
                srgb(panel.contentView.backgroundColor, under: resolvedUnder), hex(ground),
                "text view ground under \(appearance.name)")
            assertSame(
                srgb(scrollView.backgroundColor, under: resolvedUnder), hex(ground),
                "scroll view ground under \(appearance.name)")
            assertSame(
                srgb(gutter.ground, under: gutter.effectiveAppearance), hex(ground),
                "gutter ground under \(appearance.name)")
            XCTAssertEqual(labelTexts(gutter), ["1"])
            let label = try XCTUnwrap(gutter.labels.first)
            XCTAssertEqual(label.attributes[.font] as? NSFont, CodeType.font)
            assertSame(
                srgb(
                    try XCTUnwrap(label.attributes[.foregroundColor] as? NSColor),
                    under: gutter.effectiveAppearance),
                hex(number), "gutter label under \(appearance.name)")
        }
    }

    func testMarkdownSourceTakesTheCodeViewWithOneInkAndNumberedLines() throws {
        let panel = makePanel()
        let source = "# Title\n\n**bold** and [a link](https://example.com)\n"

        panel.show(path: "README.md", verdict: .text(source, .plain))

        let ink = Set(
            try foregrounds(of: panel).map { colour -> [CGFloat] in
                srgb(try XCTUnwrap(colour), under: aqua)
            }.map { $0.map { "\($0)" }.joined(separator: ",") })
        XCTAssertEqual(ink.count, 1, "one ink")
        assertSame(
            srgb(try XCTUnwrap(foregrounds(of: panel).first ?? nil), under: aqua),
            hex(Token.primary.values.light), "the one ink is {colors.primary} (CP-333)")
        let gutter = try gutter(of: panel)
        XCTAssertEqual(gutter.lineCount, 3)
        XCTAssertEqual(labelTexts(gutter), ["1", "2", "3"])
    }

    func testLinesAreTwentyPointOneFivePitchNotSixteen() throws {
        let panel = makePanel()
        panel.show(path: "three.txt", verdict: .text("one\ntwo\nthree\n", .plain))

        let rows = try layoutRows(of: panel.contentView)

        XCTAssertEqual(rows.count, 3)
        let pitch = rows[1].baseline - rows[0].baseline
        XCTAssertEqual(pitch, 20.15, accuracy: 0.5)
        XCTAssertNotEqual(pitch, 16, accuracy: 1)
    }

    func testCodeViewAndGutterAreHiddenForEveryStateWithNoText() throws {
        let numbered = FileVerdict.text("a\nb\n", .plain)
        let cases: [(String, (ReadingPanelView) -> Void)] = [
            ("empty text", { $0.show(path: "e", verdict: .text("", .plain)) }),
            (
                "empty floor verdict",
                { $0.show(path: "e", verdict: self.floorVerdict("", .json, [])) }
            ),
            ("cannot display", { $0.show(path: "e", verdict: .cannotDisplay(.invalidUTF16)) }),
            ("failed", { $0.show(path: "e", verdict: .failed(.outside)) }),
            ("no file after a numbered file", { $0.showNoFile() }),
            (
                "empty verdict after a numbered file",
                { $0.show(path: "e", verdict: .text("", .plain)) }
            ),
        ]
        for (name, enter) in cases {
            let panel = makePanel()
            panel.show(path: "n", verdict: numbered)
            XCTAssertFalse(try gutter(of: panel).isHiddenOrHasHiddenAncestor, "numbered first")
            enter(panel)
            XCTAssertTrue(try gutter(of: panel).isHiddenOrHasHiddenAncestor, name)
            XCTAssertTrue(panel.contentView.isHiddenOrHasHiddenAncestor, name)
        }
        for (name, enter) in cases {
            let panel = makePanel()
            enter(panel)
            XCTAssertTrue(try gutter(of: panel).isHiddenOrHasHiddenAncestor, "fresh \(name)")
        }
    }

    func testAnAppearanceChangeRecoloursInkGutterAndGroundWithoutSelectingAgain() throws {
        let panel = makePanel()
        panel.appearance = aqua
        panel.show(
            path: "app.py",
            verdict: floorVerdict(
                "print(\"hi\")\n", .python, [CodeSpan(start: 0, end: 5, tokenClass: .name)]))
        let gutter = try gutter(of: panel)

        panel.appearance = darkAqua

        let resolvedUnder = gutter.effectiveAppearance
        let storage = try XCTUnwrap(panel.contentView.textStorage)
        let ink = try XCTUnwrap(
            storage.attribute(.foregroundColor, at: 7, effectiveRange: nil) as? NSColor)
        assertSame(srgb(ink, under: resolvedUnder), hex(Token.primary.values.dark), "ink")
        let label = try XCTUnwrap(
            gutter.labels.first?.attributes[.foregroundColor] as? NSColor)
        assertSame(srgb(label, under: resolvedUnder), hex(Token.gutter.values.dark), "label")
        assertSame(
            srgb(gutter.ground, under: resolvedUnder), hex(Self.surfaceValues.dark), "ground")
    }

    func testNoStateOfThePanelRegistersADraggedTypeOrDrawsAControl() throws {
        let verdicts: [FileVerdict?] = [
            nil, .text("x\n", .plain), .text("", .plain), .cannotDisplay(.invalidUTF16),
            .failed(.outside),
        ]
        for verdict in verdicts {
            let panel = makePanel()
            if let verdict { panel.show(path: "f", verdict: verdict) } else { panel.showNoFile() }
            let gutter = try gutter(of: panel)
            let codeView = try XCTUnwrap(gutter.superview)

            for view in [gutter, codeView] {
                XCTAssertTrue(view.registeredDraggedTypes.isEmpty, "\(view)")
                XCTAssertFalse(view is NSControl, "\(view)")
            }
            XCTAssertFalse(panel.contentView.isEditable)
        }
    }

    func testContentViewStillAnswersItsEnclosingScrollViewAndHoldsTheFilesText() throws {
        let panel = makePanel()
        panel.show(path: "a.txt", verdict: .text("body\n", .plain))

        XCTAssertNotNil(panel.contentView.enclosingScrollView)
        XCTAssertEqual(panel.contentView.string, "body\n")
        XCTAssertTrue(
            panel.contentView.isDescendant(of: try XCTUnwrap(gutter(of: panel).superview)))
    }

    // MARK: - Reading and stopped (CP-345 – CP-351)

    // Every sentence below is a string literal and never read from `ConditionSentences`: a test
    // that reads the constant proves nothing about the wording (CP-355).

    private func visibleGlyphs(_ panel: NSView) -> [NSImage?] {
        visible(panel).compactMap { $0 as? NSImageView }.map(\.image)
    }

    func testReadingDrawsOnlyThePendingSentenceAfterAShownFile() {
        let panel = makePanel()
        panel.show(path: "a.txt", verdict: .text("hello", .plain))

        panel.showReading()

        let strings = visibleStrings(panel)
        XCTAssertEqual(strings, ["Reading this file."])
        XCTAssertFalse(isShowingContent(panel))
        XCTAssertEqual(panel.contentView.string, "")
        let glyphs = visibleGlyphs(panel)
        XCTAssertTrue(glyphs.count == 1 && glyphs[0] === statusGlyphs.empty, "\(glyphs)")
        for banned in ["%", "…", "..."] + "0123456789".map(String.init) {
            XCTAssertFalse(strings.joined().contains(banned), "\(banned) in \(strings)")
        }
    }

    func testReadingReplacesEveryEarlierState() {
        let earlier: [(String, (ReadingPanelView) -> Void)] = [
            ("fresh", { _ in }),
            ("cannot display", { $0.show(path: "a.dat", verdict: .cannotDisplay(.invalidUTF8)) }),
            ("failed read", { $0.show(path: "a.txt", verdict: .failed(.missing)) }),
            ("stopped", { $0.showStopped(path: "a.txt") }),
        ]
        for (name, enter) in earlier {
            let panel = makePanel()
            enter(panel)

            panel.showReading()

            XCTAssertEqual(visibleStrings(panel), ["Reading this file."], name)
        }
    }

    func testEachVerdictReplacesReading() {
        let cases: [(FileVerdict, String, Int)] = [
            (.text("hello", .plain), "a.txt", 1),
            (.text("", .plain), "empty.txt", 1),
            (.cannotDisplay(.invalidUTF8), "bin.dat", 2),
            (.failed(.missing), "ln", 2),
        ]
        for (verdict, path, count) in cases {
            let panel = makePanel()
            panel.showReading()

            panel.show(path: path, verdict: verdict)

            let strings = visibleStrings(panel)
            XCTAssertEqual(strings.count, count, "\(path): \(strings)")
            XCTAssertEqual(strings.first, path)
            XCTAssertFalse(strings.contains("Reading this file."), "\(path): \(strings)")
        }
        let text = makePanel()
        text.showReading()
        text.show(path: "a.txt", verdict: .text("hello", .plain))
        XCTAssertEqual(text.contentView.string, "hello")
        XCTAssertTrue(isShowingContent(text))
    }

    func testStoppedDrawsThePathAndTheFaultSentence() {
        let panel = makePanel()
        panel.show(path: "a.txt", verdict: .text("hello", .plain))

        panel.showStopped(path: "b.txt")

        XCTAssertEqual(
            visibleStrings(panel),
            [
                "b.txt",
                "Nozoki stopped while reading this file and can't tell why. "
                    + "The rest of the folder is still readable — select another file.",
            ])
        XCTAssertFalse(isShowingContent(panel))
        XCTAssertEqual(panel.contentView.string, "")
        let glyphs = visibleGlyphs(panel)
        XCTAssertTrue(glyphs.count == 1 && glyphs[0] === statusGlyphs.failure, "\(glyphs)")
    }

    func testNeitherNewStateDrawsAControlAcceptsADropOrEdits() throws {
        let states: [(String, (ReadingPanelView) -> Void)] = [
            ("reading", { $0.showReading() }),
            ("stopped", { $0.showStopped(path: "f") }),
        ]
        for (name, enter) in states {
            let panel = makePanel()
            panel.show(path: "a.txt", verdict: .text("x\n", .plain))
            enter(panel)

            for view in descendants(of: panel) {
                XCTAssertFalse(view is NSButton, "\(name): \(view)")
                if let field = view as? NSTextField { XCTAssertFalse(field.isEditable, name) }
                if let text = view as? NSTextView { XCTAssertFalse(text.isEditable, name) }
            }
            let gutter = try gutter(of: panel)
            let codeView = try XCTUnwrap(gutter.superview)
            for view in [gutter, codeView] {
                XCTAssertTrue(view.registeredDraggedTypes.isEmpty, "\(name): \(view)")
                XCTAssertFalse(view is NSControl, "\(name): \(view)")
            }
            XCTAssertFalse(panel.contentView.isEditable, name)
        }
    }

    func testEveryVerdictAndNoFileReplaceTheStoppedState() {
        let entries: [(String, (ReadingPanelView) -> Void)] = [
            ("text", { $0.show(path: "a.txt", verdict: .text("hello", .plain)) }),
            ("empty text", { $0.show(path: "a.txt", verdict: .text("", .plain)) }),
            ("cannot display", { $0.show(path: "a.dat", verdict: .cannotDisplay(.invalidUTF16)) }),
            ("failed read", { $0.show(path: "a.txt", verdict: .failed(.outside)) }),
            ("no file", { $0.showNoFile() }),
        ]
        for (name, enter) in entries {
            let panel = makePanel()
            panel.showStopped(path: "a.txt")

            enter(panel)

            for string in visibleStrings(panel) {
                XCTAssertFalse(
                    string.contains("Nozoki stopped while reading this file"),
                    "\(name): \(string)")
            }
        }
    }

    func testStoppedForASecondPathLeavesOneMessage() {
        let panel = makePanel()
        panel.showStopped(path: "a.txt")

        panel.showStopped(path: "b.txt")

        XCTAssertEqual(
            visibleStrings(panel),
            [
                "b.txt",
                "Nozoki stopped while reading this file and can't tell why. "
                    + "The rest of the folder is still readable — select another file.",
            ])
        XCTAssertEqual(visibleGlyphs(panel).count, 1)
    }

    func testReadingFollowedByStoppedLeavesOnlyTheFault() {
        let panel = makePanel()
        panel.showReading()

        panel.showStopped(path: "b.txt")

        XCTAssertEqual(
            visibleStrings(panel),
            [
                "b.txt",
                "Nozoki stopped while reading this file and can't tell why. "
                    + "The rest of the folder is still readable — select another file.",
            ])
        let glyphs = visibleGlyphs(panel)
        XCTAssertTrue(glyphs.count == 1 && glyphs[0] === statusGlyphs.failure, "\(glyphs)")
    }

    func testPendingEndsWithTheExactStatusSentenceOrEmptyTextAndNoOldGlyph() {
        let cases: [(FileVerdict, [String], NSImage?)] = [
            (.text("", .plain), ["b.txt"], nil),
            (
                .cannotDisplay(.invalidUTF8), ["b.txt", "b.txt can't be shown as text."],
                statusGlyphs.empty
            ),
            (
                .failed(.missing), ["b.txt", "Nozoki looked for b.txt and didn't find it."],
                statusGlyphs.failure
            ),
        ]
        for (verdict, strings, glyph) in cases {
            let panel = makePanel()
            panel.showReading()

            panel.show(path: "b.txt", verdict: verdict)

            XCTAssertEqual(visibleStrings(panel), strings)
            XCTAssertFalse(isShowingContent(panel))
            XCTAssertEqual(panel.contentView.string, "")
            if let glyph {
                let shown = visibleGlyphs(panel)
                XCTAssertTrue(shown.count == 1 && shown[0] === glyph)
            } else {
                XCTAssertTrue(visibleGlyphs(panel).isEmpty)
            }
        }
    }

    func testReadingReplacesReadingAndNoFileWhollyReplacesIt() {
        let panel = makePanel()
        panel.showReading()
        panel.showReading()

        XCTAssertEqual(visibleStrings(panel), ["Reading this file."])
        XCTAssertEqual(visibleGlyphs(panel).count, 1)

        panel.showNoFile()

        XCTAssertEqual(visibleStrings(panel), ["Select a file to view."])
        XCTAssertFalse(isShowingContent(panel))
        let glyphs = visibleGlyphs(panel)
        XCTAssertTrue(glyphs.count == 1 && glyphs[0] === statusGlyphs.empty)
    }

    // MARK: - The path line's row and hairline (CP-356 – CP-367)

    /// What lies beneath the path line's hairline in a state that shows the line.
    private enum Beneath {
        case content, nothing, message
    }

    /// One state of the reading panel in which the path line is shown, and how to put the panel in it.
    private struct LineState {
        let name: String
        let beneath: Beneath
        let enter: (ReadingPanelView) -> Void
    }

    /// A path whose first character, `█`, inks from its pen position, so the first drawn ink is where
    /// the text begins; the rest is an ordinary folder-relative path with a descender and an ascender.
    private let linePath = "█pg/lib.rs"

    /// The line's states: text with content, empty text, both cannot-display reasons, a failed read
    /// for every `Condition`, and stopped (`change_design.md` § 5, "The line's states").
    private var lineStates: [LineState] {
        let path = linePath
        var states = [
            LineState(
                name: "text", beneath: .content,
                enter: { $0.show(path: path, verdict: .text("fn main() {}\n", .plain)) }),
            LineState(
                name: "empty text", beneath: .nothing,
                enter: { $0.show(path: path, verdict: .text("", .plain)) }),
            LineState(
                name: "stopped", beneath: .message, enter: { $0.showStopped(path: path) }),
        ]
        for reason in [CannotDisplayReason.invalidUTF8, .invalidUTF16] {
            states.append(
                LineState(
                    name: "cannot display \(reason)", beneath: .message,
                    enter: { $0.show(path: path, verdict: .cannotDisplay(reason)) }))
        }
        for condition in Condition.allCases {
            states.append(
                LineState(
                    name: "failed \(condition)", beneath: .message,
                    enter: { $0.show(path: path, verdict: .failed(condition)) }))
        }
        return states
    }

    /// A 600 by 400 panel under `appearance`, put in `state` and laid out.
    private func makeLinePanel(
        _ state: LineState, under appearance: NSAppearance, width: CGFloat = 600
    ) -> ReadingPanelView {
        let panel = ReadingPanelView(statusGlyphs: statusGlyphs)
        panel.appearance = appearance
        panel.frame = NSRect(x: 0, y: 0, width: width, height: 400)
        state.enter(panel)
        panel.layoutSubtreeIfNeeded()
        return panel
    }

    private func eachLineState(
        _ check: (LineState, NSAppearance, ReadingPanelView) throws -> Void
    ) rethrows {
        for state in lineStates {
            for appearance in [aqua, darkAqua] {
                try check(state, appearance, makeLinePanel(state, under: appearance))
            }
        }
    }

    private func surface(under appearance: NSAppearance) -> UInt32 {
        appearance.name == .darkAqua ? Self.surfaceValues.dark : Self.surfaceValues.light
    }

    private func value(of token: Token, under appearance: NSAppearance) -> UInt32 {
        appearance.name == .darkAqua ? token.values.dark : token.values.light
    }

    /// Distance of `frame`'s top below `panel`'s top. The panel is unflipped (`change_design.md` § 5).
    private func topDown(_ frame: NSRect, in panel: NSView) -> CGFloat {
        panel.bounds.maxY - frame.maxY
    }

    private func frame(of view: NSView, in panel: NSView) -> NSRect {
        view.convert(view.bounds, to: panel)
    }

    /// The panel as drawn: a bitmap whose rows run top-down, with the points-to-pixels scale.
    private struct Capture {
        let rep: NSBitmapImageRep
        let scale: CGFloat
        let width: CGFloat

        /// The sRGB colour of the pixel at `x` points from the left and `y` points below the top.
        func colour(x: CGFloat, y: CGFloat) -> [CGFloat] {
            guard
                let pixel = rep.colorAt(x: Int(x * scale), y: Int(y * scale))?.usingColorSpace(
                    .sRGB)
            else { return [] }
            return [pixel.redComponent, pixel.greenComponent, pixel.blueComponent]
        }

        /// Where ink lies among the rows from `top` to `bottom` points: pixels unlike `ground`.
        func ink(
            from top: CGFloat, to bottom: CGFloat, ground: [CGFloat], onlyColumns: Range<Int>? = nil
        ) -> (minX: CGFloat, maxX: CGFloat, minY: CGFloat, maxY: CGFloat)? {
            var columns: [Int] = []
            var rows: [Int] = []
            // The bitmap's last column is rounded up from a fractional width and is never drawn.
            let drawnColumns = onlyColumns ?? (0..<Int((width * scale).rounded(.down)))
            for row in Int(top * scale)..<Int(bottom * scale) {
                for column in drawnColumns {
                    guard let pixel = rep.colorAt(x: column, y: row)?.usingColorSpace(.sRGB),
                        [pixel.redComponent, pixel.greenComponent, pixel.blueComponent]
                            .enumerated().contains(where: {
                                abs($0.element - ground[$0.offset]) > 0.15
                            })
                    else { continue }
                    columns.append(column)
                    rows.append(row)
                }
            }
            guard let minColumn = columns.min(), let maxColumn = columns.max(),
                let minRow = rows.min(), let maxRow = rows.max()
            else { return nil }
            return (
                CGFloat(minColumn) / scale, CGFloat(maxColumn + 1) / scale,
                CGFloat(minRow) / scale, CGFloat(maxRow + 1) / scale
            )
        }
    }

    private func capture(_ panel: NSView) throws -> Capture {
        let rep = try XCTUnwrap(panel.bitmapImageRepForCachingDisplay(in: panel.bounds))
        panel.cacheDisplay(in: panel.bounds, to: rep)
        return Capture(
            rep: rep, scale: CGFloat(rep.pixelsWide) / panel.bounds.width, width: panel.bounds.width
        )
    }

    private func assertPixel(
        _ capture: Capture, x: CGFloat, y: CGFloat, is expected: UInt32, _ message: String,
        file: StaticString = #filePath, line: UInt = #line
    ) {
        let actual = capture.colour(x: x, y: y)
        XCTAssertEqual(actual.count, 3, message, file: file, line: line)
        for (a, e) in zip(actual, hex(expected)) {
            // A pixel is 8 bits through a colour-space conversion: far finer than any two tokens apart.
            XCTAssertEqual(a, e, accuracy: 0.02, message, file: file, line: line)
        }
    }

    private func visibleMessages(_ panel: NSView) -> [StatusMessageView] {
        visible(panel).compactMap { $0 as? StatusMessageView }
    }

    private func glyphMinX(of message: StatusMessageView, in panel: NSView) throws -> CGFloat {
        let glyph = try XCTUnwrap(descendants(of: message).compactMap { $0 as? NSImageView }.first)
        return frame(of: glyph, in: panel).minX
    }

    private func isShown(_ panel: ReadingPanelView) -> Bool {
        !panel.pathLine.isHiddenOrHasHiddenAncestor
    }

    func testPathLineUsesTwelvePointRegularMonospacedTypeAndMutedInk() throws {
        try eachLineState { state, appearance, panel in
            let name = "\(state.name) under \(appearance.name)"
            XCTAssertEqual(
                panel.pathLine.font, .monospacedSystemFont(ofSize: 12, weight: .regular),
                "\(name): type (CP-356)")
            XCTAssertEqual(panel.pathLine.font?.pointSize, 12, name)
            let ink = try XCTUnwrap(panel.pathLine.textColor)
            assertSame(
                srgb(ink, under: panel.pathLine.effectiveAppearance),
                hex(value(of: .inkMuted, under: appearance)), "\(name): ink (CP-357)")
            // The first character's block is solid ink, so its middle is the text colour as drawn.
            let drawn = try capture(panel)
            assertPixel(
                drawn, x: 16 + 2, y: 12, is: value(of: .inkMuted, under: appearance),
                "\(name): the drawn text's colour (CP-357)")
        }
    }

    func testPathRowIsTwentyFourPointsAtThePanelTopOnSurface() throws {
        try eachLineState { state, appearance, panel in
            let name = "\(state.name) under \(appearance.name)"
            let row = panel.pathRow.frame
            XCTAssertTrue(panel.pathRow.superview === panel, name)
            XCTAssertEqual(row.minX, 0, accuracy: 0.001, name)
            XCTAssertEqual(row.width, panel.bounds.width, accuracy: 0.001, name)
            XCTAssertEqual(row.height, 24, accuracy: 0.001, "\(name): row height (CP-360)")
            XCTAssertEqual(topDown(row, in: panel), 0, accuracy: 0.001, "\(name): row top (CP-360)")
            assertSame(
                srgb(panel.pathRow.ground, under: panel.pathRow.effectiveAppearance),
                hex(surface(under: appearance)), "\(name): the row's ground (CP-358)")
            let drawn = try capture(panel)
            for x in [CGFloat(2), 300, 596] {
                assertPixel(
                    drawn, x: x, y: 12, is: surface(under: appearance),
                    "\(name): the row drawn on surface at x \(x) (CP-358)")
            }
        }
    }

    func testPathRowAndHairlineFollowPanelWidth() throws {
        let long = "█" + String(repeating: "-", count: 150) + "█"
        for appearance in [aqua, darkAqua] {
            for state in lineStates {
                let panel = makeLinePanel(state, under: appearance)
                for width in [CGFloat(900), 600] {
                    panel.frame.size.width = width
                    panel.layoutSubtreeIfNeeded()
                    let name = "\(state.name) under \(appearance.name), \(width) wide"
                    XCTAssertEqual(panel.pathRow.frame.minX, 0, accuracy: 0.001, name)
                    XCTAssertEqual(panel.pathRow.frame.width, width, accuracy: 0.001, name)
                    XCTAssertEqual(panel.pathHairline.frame.minX, 0, accuracy: 0.001, name)
                    XCTAssertEqual(panel.pathHairline.frame.width, width, accuracy: 0.001, name)
                    let drawn = try capture(panel)
                    assertPixel(
                        drawn, x: width - 4, y: 12, is: surface(under: appearance),
                        "\(name): the row drawn to the right edge (CP-358)")
                    assertPixel(
                        drawn, x: width - 4, y: 24.5, is: value(of: .line, under: appearance),
                        "\(name): the hairline drawn to the right edge (CP-363)")
                }
            }
            let panel = makeLinePanel(lineStates[0], under: appearance)
            panel.show(path: long, verdict: .text("x\n", .plain))
            for width in [CGFloat(900), 600] {
                panel.frame.size.width = width
                panel.layoutSubtreeIfNeeded()
                let extent = try XCTUnwrap(
                    try capture(panel).ink(
                        from: 0, to: 24, ground: hex(surface(under: appearance))))
                let pixel = 1 / (try capture(panel)).scale
                XCTAssertEqual(
                    extent.minX, 16, accuracy: pixel + 0.001, "left limit at \(width) wide (CP-361)"
                )
                XCTAssertLessThanOrEqual(
                    extent.maxX, width - 16 + 0.001, "right limit at \(width) wide (CP-361)")
            }
        }
    }

    func testPathHairlineIsOnePointDirectlyBelowTheRow() throws {
        try eachLineState { state, appearance, panel in
            let name = "\(state.name) under \(appearance.name)"
            let hairline = panel.pathHairline.frame
            XCTAssertTrue(panel.pathHairline.superview === panel, name)
            XCTAssertEqual(hairline.height, 1, accuracy: 0.001, "\(name): thickness (CP-363)")
            XCTAssertEqual(
                topDown(hairline, in: panel), 24, accuracy: 0.001, "\(name): top, 24 down (CP-363)")
            XCTAssertEqual(
                hairline.maxY, panel.pathRow.frame.minY, accuracy: 0.001,
                "\(name): its top is the row's bottom (CP-363)")
            XCTAssertEqual(hairline.minX, 0, accuracy: 0.001, name)
            XCTAssertEqual(hairline.width, panel.bounds.width, accuracy: 0.001, name)
            assertSame(
                srgb(panel.pathHairline.color, under: panel.pathHairline.effectiveAppearance),
                hex(value(of: .line, under: appearance)), "\(name): the hairline's colour (CP-363)")
            let drawn = try capture(panel)
            for x in [CGFloat(2), 300, 596] {
                assertPixel(
                    drawn, x: x, y: 24.5, is: value(of: .line, under: appearance),
                    "\(name): the hairline drawn at x \(x) (CP-363)")
            }
        }
    }

    func testPathTextStaysWhollyInsideItsRow() throws {
        try eachLineState { state, appearance, panel in
            let name = "\(state.name) under \(appearance.name)"
            let label = frame(of: panel.pathLine, in: panel)
            XCTAssertTrue(
                panel.pathRow.frame.contains(label), "\(name): the label \(label) lies in the row")
            let drawn = try capture(panel)
            let extent = try XCTUnwrap(
                drawn.ink(from: 0, to: 24, ground: hex(surface(under: appearance))), name)
            let pixel = 1 / drawn.scale
            XCTAssertGreaterThanOrEqual(
                extent.minY, pixel, "\(name): no ink clipped at the top (CP-362)")
            XCTAssertLessThanOrEqual(
                extent.maxY, 24 - pixel, "\(name): no ink clipped at the bottom (CP-362)")
            for x in stride(from: CGFloat(1), to: 600, by: 7) {
                assertPixel(
                    drawn, x: x, y: 24.5, is: value(of: .line, under: appearance),
                    "\(name): no ink on the hairline at x \(x) (CP-362)")
            }
        }
    }

    func testPathTextBeginsSixteenPointsFromThePanelEdge() throws {
        try eachLineState { state, appearance, panel in
            let name = "\(state.name) under \(appearance.name)"
            let drawn = try capture(panel)
            let extent = try XCTUnwrap(
                drawn.ink(from: 0, to: 24, ground: hex(surface(under: appearance))), name)
            XCTAssertEqual(
                extent.minX, 16, accuracy: 1 / drawn.scale + 0.001,
                "\(name): the first ink column (CP-361)")
        }
    }

    func testLongPathTruncatesInTheMiddleInsideBothInsets() throws {
        // A block at each end: the head and the tail each end on a tall glyph, where a tail
        // truncation would end on the low dots of an ellipsis.
        let long = "█" + String(repeating: "-", count: 100) + "█"
        for appearance in [aqua, darkAqua] {
            let panel = makeLinePanel(lineStates[0], under: appearance, width: 300)
            panel.show(path: long, verdict: .text("x\n", .plain))
            panel.layoutSubtreeIfNeeded()
            let name = "under \(appearance.name)"

            let drawn = try capture(panel)
            let ground = hex(surface(under: appearance))
            let extent = try XCTUnwrap(drawn.ink(from: 0, to: 24, ground: ground), name)
            XCTAssertEqual(
                extent.minX, 16, accuracy: 1 / drawn.scale + 0.001, "\(name): left (CP-361)")
            XCTAssertLessThanOrEqual(extent.maxX, 300 - 16 + 0.001, "\(name): right limit (CP-361)")
            let fullWidth = (long as NSString).size(withAttributes: [
                .font: panel.pathLine.font as Any
            ]).width
            XCTAssertLessThan(extent.maxX - extent.minX, fullWidth, "\(name): shortened (CP-361)")
            XCTAssertEqual(panel.pathLine.stringValue, long, "\(name): the path itself is whole")
            let firstColumn = Int(extent.minX * drawn.scale)
            let head = try XCTUnwrap(
                drawn.ink(
                    from: 0, to: 24, ground: ground,
                    onlyColumns: firstColumn..<(firstColumn + 2)))
            XCTAssertGreaterThan(
                head.maxY - head.minY, 8,
                "\(name): the line starts on the head, not an ellipsis (CP-361)")
            // The last drawn glyph is the tail's block: ink as tall as a block over its last columns.
            let lastColumn = Int(extent.maxX * drawn.scale) - 1
            let tail = try XCTUnwrap(
                drawn.ink(
                    from: 0, to: 24, ground: ground,
                    onlyColumns: (lastColumn - 1)..<(lastColumn + 1)))
            XCTAssertGreaterThan(
                tail.maxY - tail.minY, 8,
                "\(name): the line ends on the tail, so its middle was shortened (CP-361)")
        }
    }

    func testContentAndMessagesBeginEightPointsBelowTheHairline() throws {
        try eachLineState { state, appearance, panel in
            let name = "\(state.name) under \(appearance.name)"
            let hairline = panel.pathHairline.frame
            switch state.beneath {
            case .content:
                let codeView = try XCTUnwrap(
                    descendants(of: panel).first {
                        $0 is CodeView && !$0.isHiddenOrHasHiddenAncestor
                    })
                let top = topDown(frame(of: codeView, in: panel), in: panel)
                XCTAssertEqual(top, 33, accuracy: 0.001, "\(name): the code view's top (CP-364)")
                XCTAssertEqual(
                    top - topDown(hairline, in: panel) - hairline.height, 8, accuracy: 0.001, name)
                XCTAssertLessThanOrEqual(
                    frame(of: codeView, in: panel).maxY, hairline.minY,
                    "\(name): no overlap (CP-364)")
            case .message:
                let messages = visibleMessages(panel)
                XCTAssertEqual(messages.count, 1, name)
                let message = try XCTUnwrap(messages.first)
                let box = frame(of: message, in: panel)
                XCTAssertEqual(
                    topDown(box, in: panel), 33, accuracy: 0.001,
                    "\(name): the message's top, 8 below the hairline (CP-364)")
                XCTAssertLessThanOrEqual(box.maxY, hairline.minY, "\(name): no overlap (CP-364)")
                XCTAssertEqual(
                    try glyphMinX(of: message, in: panel), 24, accuracy: 0.001,
                    "\(name): the glyph's left edge (CP-365)")
            case .nothing:
                XCTAssertTrue(visibleMessages(panel).isEmpty, name)
                XCTAssertFalse(isShowingContent(panel), name)
            }
        }
    }

    func testNoFileAndPendingKeepTheirTwentyFourPointInsetsWithoutAPathRow() throws {
        for appearance in [aqua, darkAqua] {
            let states: [(String, (ReadingPanelView) -> Void)] = [
                ("no file", { $0.showNoFile() }),
                ("pending", { $0.showReading() }),
                (
                    "no file after a shown file",
                    {
                        $0.show(path: self.linePath, verdict: .text("x\n", .plain))
                        $0.showNoFile()
                    }
                ),
                (
                    "pending after a shown file",
                    {
                        $0.show(path: self.linePath, verdict: .failed(.missing))
                        $0.showReading()
                    }
                ),
            ]
            for (name, enter) in states {
                let panel = ReadingPanelView(statusGlyphs: statusGlyphs)
                panel.appearance = appearance
                panel.frame = NSRect(x: 0, y: 0, width: 600, height: 400)
                enter(panel)
                panel.layoutSubtreeIfNeeded()
                let label = "\(name) under \(appearance.name)"

                for hidden in [panel.pathLine, panel.pathRow, panel.pathHairline] as [NSView] {
                    XCTAssertTrue(
                        hidden.isHiddenOrHasHiddenAncestor, "\(label): \(hidden) (CP-363)")
                }
                let message = try XCTUnwrap(visibleMessages(panel).first, label)
                XCTAssertEqual(visibleMessages(panel).count, 1, label)
                XCTAssertEqual(
                    topDown(frame(of: message, in: panel), in: panel), 24, accuracy: 0.001,
                    "\(label): top inset (CP-366)")
                XCTAssertEqual(
                    try glyphMinX(of: message, in: panel), 24, accuracy: 0.001,
                    "\(label): left inset (CP-366)")
            }
        }
    }

    func testPathDrawingShowsAndHidesTogetherAcrossStateChanges() throws {
        let path = linePath
        let steps: [(String, Bool, (ReadingPanelView) -> Void)] = [
            ("text", true, { $0.show(path: path, verdict: .text("body\n", .plain)) }),
            ("reading", false, { $0.showReading() }),
            ("stopped", true, { $0.showStopped(path: path) }),
            ("no file", false, { $0.showNoFile() }),
            (
                "cannot display", true,
                { $0.show(path: path, verdict: .cannotDisplay(.invalidUTF8)) }
            ),
            ("reading again", false, { $0.showReading() }),
            ("failed", true, { $0.show(path: path, verdict: .failed(.unreadable)) }),
            ("text again", true, { $0.show(path: path, verdict: .text("again\n", .plain)) }),
            ("empty text", true, { $0.show(path: path, verdict: .text("", .plain)) }),
        ]
        for appearance in [aqua, darkAqua] {
            let panel = ReadingPanelView(statusGlyphs: statusGlyphs)
            panel.appearance = appearance
            panel.frame = NSRect(x: 0, y: 0, width: 600, height: 400)
            for (name, shown, enter) in steps {
                enter(panel)
                panel.layoutSubtreeIfNeeded()
                let label = "\(name) under \(appearance.name)"

                for view in [panel.pathLine, panel.pathRow, panel.pathHairline] as [NSView] {
                    XCTAssertEqual(
                        !view.isHiddenOrHasHiddenAncestor, shown, "\(label): \(view) (CP-363)")
                }
                switch name {
                case "text", "text again":
                    XCTAssertTrue(isShowingContent(panel), label)
                    XCTAssertTrue(visibleMessages(panel).isEmpty, "\(label): no stale message")
                    let codeView = try XCTUnwrap(
                        descendants(of: panel).first {
                            $0 is CodeView && !$0.isHiddenOrHasHiddenAncestor
                        })
                    XCTAssertEqual(
                        topDown(frame(of: codeView, in: panel), in: panel), 33, accuracy: 0.001,
                        "\(label): the content, back after a hidden state, hangs at 33 (CP-364)")
                case "empty text":
                    XCTAssertFalse(isShowingContent(panel), "\(label): no stale content")
                    XCTAssertTrue(visibleMessages(panel).isEmpty, "\(label): no stale message")
                default:
                    XCTAssertFalse(isShowingContent(panel), "\(label): no stale content")
                    XCTAssertEqual(visibleMessages(panel).count, 1, label)
                }
            }
        }
    }

    func testPathDrawingRecoloursWhenAppearanceChangesWithoutReselection() throws {
        for state in lineStates {
            let panel = makeLinePanel(state, under: aqua)
            // aqua, darkAqua, then aqua again: both directions, with no `show` between them.
            for appearance in [aqua, darkAqua, aqua] {
                panel.appearance = appearance
                let name = "\(state.name) under \(appearance.name)"
                let ink = try XCTUnwrap(panel.pathLine.textColor)
                assertSame(
                    srgb(ink, under: panel.pathLine.effectiveAppearance),
                    hex(value(of: .inkMuted, under: appearance)), "\(name): text colour (CP-359)")
                assertSame(
                    srgb(panel.pathRow.ground, under: panel.pathRow.effectiveAppearance),
                    hex(surface(under: appearance)), "\(name): row ground (CP-359)")
                assertSame(
                    srgb(panel.pathHairline.color, under: panel.pathHairline.effectiveAppearance),
                    hex(value(of: .line, under: appearance)), "\(name): hairline colour (CP-359)")
                let drawn = try capture(panel)
                assertPixel(
                    drawn, x: 16 + 2, y: 12, is: value(of: .inkMuted, under: appearance),
                    "\(name): the drawn text (CP-359)")
                assertPixel(
                    drawn, x: 596, y: 12, is: surface(under: appearance),
                    "\(name): the drawn row (CP-359)")
                assertPixel(
                    drawn, x: 300, y: 24.5, is: value(of: .line, under: appearance),
                    "\(name): the drawn hairline (CP-359)")
            }
        }
    }

    // MARK: Input lands on nothing (CP-367)

    private func mouse(
        _ type: NSEvent.EventType, at point: NSPoint, in window: NSWindow
    ) throws -> NSEvent {
        try XCTUnwrap(
            NSEvent.mouseEvent(
                with: type, location: point, modifierFlags: [], timestamp: 0,
                windowNumber: window.windowNumber, context: nil, eventNumber: 0, clickCount: 1,
                pressure: 1))
    }

    private func keyDown(in window: NSWindow) throws -> NSEvent {
        try XCTUnwrap(
            NSEvent.keyEvent(
                with: .keyDown, location: .zero, modifierFlags: [], timestamp: 0,
                windowNumber: window.windowNumber, context: nil, characters: "a",
                charactersIgnoringModifiers: "a", isARepeat: false, keyCode: 0))
    }

    /// A drag session the test hands to a view the way AppKit would: a pasteboard and a location in
    /// the window. The pasteboard is the system's drag pasteboard unless the test hands one of its
    /// own, which a test whose verdict depends on what is dropped must do.
    private final class StubDragInfo: NSObject, NSDraggingInfo {
        let window: NSWindow
        let location: NSPoint
        let pasteboard: NSPasteboard
        init(
            window: NSWindow, location: NSPoint,
            pasteboard: NSPasteboard = NSPasteboard(name: .drag)
        ) {
            self.window = window
            self.location = location
            self.pasteboard = pasteboard
        }
        var draggingDestinationWindow: NSWindow? { window }
        var draggingSourceOperationMask: NSDragOperation { .copy }
        var draggingLocation: NSPoint { location }
        var draggedImageLocation: NSPoint { location }
        var draggedImage: NSImage? { nil }
        var draggingPasteboard: NSPasteboard { pasteboard }
        var draggingSource: Any? { nil }
        var draggingSequenceNumber: Int { 1 }
        var draggingFormation: NSDraggingFormation = .default
        var animatesToDestination: Bool = false
        var numberOfValidItemsForDrop: Int = 1
        var springLoadingHighlight: NSSpringLoadingHighlight { .none }
        func slideDraggedImage(to screenPoint: NSPoint) {}
        func resetSpringLoading() {}
        func enumerateDraggingItems(
            options enumOpts: NSDraggingItemEnumerationOptions, for view: NSView?,
            classes classArray: [AnyClass], searchOptions: [NSPasteboard.ReadingOptionKey: Any],
            using block: (NSDraggingItem, Int, UnsafeMutablePointer<ObjCBool>) -> Void
        ) {}
    }

    private final class KeyRecipient: NSResponder {
        var characters: [String] = []

        override var acceptsFirstResponder: Bool { true }

        override func keyDown(with event: NSEvent) {
            characters.append(event.characters ?? "")
        }
    }

    func testPathDrawingIgnoresClicksDragsDropsAndKeysWithoutMovingFocus() throws {
        try eachLineState { state, appearance, panel in
            let name = "\(state.name) under \(appearance.name)"
            let window = NSWindow(
                contentRect: NSRect(x: 0, y: 0, width: 600, height: 400), styleMask: [.titled],
                backing: .buffered, defer: true)
            window.isReleasedWhenClosed = false
            window.contentView = panel
            defer { window.close() }
            let keyRecipient = KeyRecipient()
            XCTAssertTrue(window.makeFirstResponder(keyRecipient), name)
            panel.layoutSubtreeIfNeeded()
            let responder = window.firstResponder
            let shownBefore = visibleStrings(panel)
            let pathBefore = panel.pathLine.stringValue

            // The label, a blank point of the row's ground, and the hairline, in the window's
            // coordinates (the panel fills the window's content, unflipped).
            let label = panel.pathLine.convert(
                NSPoint(x: panel.pathLine.bounds.midX, y: panel.pathLine.bounds.midY), to: nil)
            let ground = panel.convert(
                NSPoint(x: panel.bounds.maxX - 6, y: panel.pathRow.frame.midY), to: nil)
            let hairline = panel.convert(
                NSPoint(x: panel.bounds.midX, y: panel.pathHairline.frame.midY), to: nil)
            for (place, point) in [
                ("label", label), ("row ground", ground), ("hairline", hairline),
            ] {
                XCTAssertTrue(
                    panel.hitTest(panel.convert(point, from: nil)).map {
                        $0 === panel.pathLine || $0 === panel.pathRow || $0 === panel.pathHairline
                    } ?? false,
                    "\(name): the \(place) point lands on the path drawing")
                for type in [NSEvent.EventType.leftMouseDown, .leftMouseDragged, .leftMouseUp] {
                    window.sendEvent(try mouse(type, at: point, in: window))
                }
                // A drop at this point. AppKit offers a drag, and delivers its drop, to the nearest
                // view at or above the hit view that registered a dragged type; none of them did, so
                // nothing is offered. The hit view's own answers to the negotiation and the
                // delivery refuse as well (its default prepare answer is true, so it is not asserted).
                let hit = try XCTUnwrap(panel.hitTest(panel.convert(point, from: nil)))
                var receiver: NSView? = hit
                while let candidate = receiver {
                    XCTAssertTrue(
                        candidate.registeredDraggedTypes.isEmpty,
                        "\(name): \(candidate) takes no drop at the \(place) (CP-367)")
                    receiver = candidate.superview
                }
                let drag = StubDragInfo(window: window, location: point)
                XCTAssertEqual(
                    hit.draggingEntered(drag), [], "\(name): no drag is accepted at the \(place)")
                XCTAssertFalse(
                    hit.performDragOperation(drag),
                    "\(name): no drop is delivered at the \(place)")
            }
            window.sendEvent(try keyDown(in: window))
            XCTAssertEqual(keyRecipient.characters, ["a"], "\(name): the key was delivered")

            XCTAssertTrue(
                window.firstResponder === responder, "\(name): focus did not move (CP-367)")
            XCTAssertEqual(panel.pathLine.stringValue, pathBefore, name)
            XCTAssertEqual(visibleStrings(panel), shownBefore, name)
            for view in descendants(of: panel) {
                if let field = view as? NSTextField {
                    XCTAssertFalse(field.isEditable, "\(name): \(field)")
                }
                if let text = view as? NSTextView {
                    XCTAssertFalse(text.isEditable, "\(name): \(text)")
                }
            }
            // Not controls, no first responder, no dragged type: AppKit offers a drag, and delivers a
            // drop, only to a view that registered a type, and none of these did.
            for view in [panel.pathRow, panel.pathHairline] as [NSView] {
                XCTAssertFalse(view is NSControl, "\(name): \(view)")
                XCTAssertFalse(view.acceptsFirstResponder, "\(name): \(view)")
                XCTAssertTrue(view.registeredDraggedTypes.isEmpty, "\(name): \(view)")
            }
            XCTAssertTrue(panel.pathLine.registeredDraggedTypes.isEmpty, name)
            XCTAssertFalse(panel.pathLine.isEditable, name)
            XCTAssertFalse(panel.pathLine.isSelectable, name)
            XCTAssertFalse(panel.pathLine.acceptsFirstResponder, name)
        }
    }

    func testReplacingNestedPathWithRootPathKeepsTheFolderRelativeText() {
        let panel = makePanel()

        panel.show(path: "src/lib.rs", verdict: .text("fn main() {}\n", .plain))
        XCTAssertEqual(panel.pathLine.stringValue, "src/lib.rs")
        panel.show(path: "README", verdict: .text("hello\n", .plain))

        XCTAssertEqual(panel.pathLine.stringValue, "README")
        XCTAssertFalse(panel.pathLine.stringValue.hasPrefix("/"))
        XCTAssertFalse(panel.pathLine.stringValue.hasPrefix("./"))
    }

    // MARK: - The panel cannot write (R-48, R-49)

    /// What a test counts to know no intent was raised: the workbench's file selection and the
    /// tree's folder listing.
    @MainActor
    private final class IntentCounts {
        var selectFile = 0
        var listTree = 0
    }

    /// A file shown in the reading panel of a workbench hosted in a window, with its text view the
    /// first responder and both intents counted from zero.
    @MainActor
    private struct ShownFile {
        let window: NSWindow
        let panel: ReadingPanelView
        let intents: IntentCounts

        var textView: NSTextView { panel.contentView }
    }

    /// What the panel draws, read before and after a drive: the text, its attributes (a write
    /// that only restyled the text would leave the string alone) and the path line.
    @MainActor
    private struct Drawn {
        let text: String
        let attributedText: NSAttributedString
        let path: String

        init(_ panel: ReadingPanelView) {
            text = panel.contentView.string
            attributedText = panel.contentView.attributedString()
            path = panel.pathLine.stringValue
        }
    }

    /// The tree lists `a.txt` so that a keystroke `a` which landed on the tree, and not on the
    /// text view, would select it and raise `selectFile`: "no intent" then has something to catch.
    private func makeShownFile() -> ShownFile {
        let glyph = NSImage(size: NSSize(width: 1, height: 1))
        let glyphs = StatusGlyphs(empty: glyph, failure: glyph)
        let tree = RootItemsView(
            folderGlyph: glyph, fileGlyph: glyph, fileCodeGlyph: glyph, statusGlyphs: glyphs)
        tree.show(
            .observed([
                Entry(name: "a.txt", path: "a.txt", kind: .file, state: .observed),
                Entry(name: "b.txt", path: "b.txt", kind: .file, state: .observed),
            ]))
        let workbench = WorkbenchView(
            rootItemsView: tree, statusGlyphs: glyphs, railFolderGlyph: glyph, railGitGlyph: glyph)
        let intents = IntentCounts()
        workbench.selectFile = { _, _ in intents.selectFile += 1 }
        tree.listTree = { _, _ in intents.listTree += 1 }

        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 800, height: 500), styleMask: [.titled],
            backing: .buffered, defer: true)
        window.isReleasedWhenClosed = false
        window.contentView = workbench
        workbench.readingPanel.show(
            path: "notes.txt", verdict: .text("first line\nsecond line\nthird line\n", .plain))
        window.layoutIfNeeded()
        window.layoutIfNeeded()

        let shown = ShownFile(window: window, panel: workbench.readingPanel, intents: intents)
        // Asserted before anything is driven: a key sent while something else holds focus, or at
        // a view that was never ready, would pass without testing the text view
        // (change_design.md § 3, *What the shared fixture holds*).
        XCTAssertTrue(window.makeFirstResponder(shown.textView), "the text view takes focus")
        XCTAssertTrue(window.firstResponder === shown.textView, "the text view is first responder")
        XCTAssertFalse(shown.textView.isEditable, "the shown file's text view is not editable")
        XCTAssertEqual(intents.selectFile, 0, "no selection was raised by setting up")
        XCTAssertEqual(intents.listTree, 0, "no listing was raised by setting up")
        return shown
    }

    private func assertNothingChanged(
        since before: Drawn, in shown: ShownFile, file: StaticString = #filePath,
        line: UInt = #line
    ) {
        let after = Drawn(shown.panel)
        XCTAssertEqual(after.text, before.text, "the text", file: file, line: line)
        XCTAssertEqual(
            after.attributedText, before.attributedText, "the attributed text", file: file,
            line: line)
        XCTAssertEqual(after.path, before.path, "the path line", file: file, line: line)
        XCTAssertEqual(shown.intents.selectFile, 0, "selectFile raised", file: file, line: line)
        XCTAssertEqual(shown.intents.listTree, 0, "listTree raised", file: file, line: line)
    }

    func testAKeystrokeIntoAShownFileChangesNothingAndRaisesNoIntent() throws {
        let shown = makeShownFile()
        defer { shown.window.close() }
        let before = Drawn(shown.panel)

        shown.window.sendEvent(try keyDown(in: shown.window))

        assertNothingChanged(since: before, in: shown)
    }

    func testAPasteIntoAShownFileChangesNothingAndRaisesNoIntent() {
        let shown = makeShownFile()
        defer { shown.window.close() }
        // A pasteboard of this test's own, never the general one: that is the owner's clipboard,
        // and an empty one would let the test pass having pasted nothing (change_design.md § 4,
        // *Paste test*).
        let pasteboard = NSPasteboard(name: NSPasteboard.Name("nozoki.tests.\(UUID().uuidString)"))
        defer { pasteboard.releaseGlobally() }
        let pasted = "PASTED INTO THE PANEL"
        pasteboard.clearContents()
        XCTAssertTrue(pasteboard.setString(pasted, forType: .string))
        XCTAssertEqual(
            pasteboard.string(forType: .string), pasted, "the pasteboard holds the paste")
        XCTAssertFalse(shown.textView.string.contains(pasted), "the file does not hold the paste")
        let before = Drawn(shown.panel)

        // The answer is not asserted: what the text view returns for a refused paste is its own
        // detail, and what the test owns is that nothing was written (change_spec.md I-3).
        _ = shown.textView.readSelection(from: pasteboard)

        assertNothingChanged(since: before, in: shown)
        let pasteItem = NSMenuItem(
            title: "Paste", action: #selector(NSText.paste(_:)), keyEquivalent: "")
        XCTAssertFalse(
            shown.textView.validateMenuItem(pasteItem), "the text view refuses paste at validation")
    }

    func testAShownFilesTextViewIsNotEditableAndNothingUpToTheWindowTakesADrop() throws {
        let shown = makeShownFile()
        defer { shown.window.close() }
        let window = shown.window
        let contentView = try XCTUnwrap(window.contentView)
        let frameView = try XCTUnwrap(contentView.superview)
        let textView = shown.textView
        XCTAssertFalse(textView.isEditable)
        let before = Drawn(shown.panel)

        // A point over the text view, in the window's coordinates. The hit view is asserted to be
        // the text view or one of its descendants: a drop at any other point would walk another
        // chain of views and pass without testing this one (change_design.md § 3, *Not editable,
        // takes no drop*).
        let point = textView.convert(
            NSPoint(x: textView.bounds.midX, y: textView.bounds.midY), to: nil)
        let hit = try XCTUnwrap(contentView.hitTest(frameView.convert(point, from: nil)))
        XCTAssertTrue(
            hit === textView || hit.isDescendant(of: textView), "the point is over the text")

        // AppKit offers a drag, and delivers its drop, to the nearest view at or above the hit view
        // that registered a dragged type, so the walk goes up to the window's content view: the
        // ground `testPathDrawingIgnoresClicksDragsDropsAndKeysWithoutMovingFocus` states for the
        // path drawing (CP-367).
        var receiver: NSView? = hit
        var reachedContentView = false
        while let candidate = receiver, !reachedContentView {
            XCTAssertTrue(candidate.registeredDraggedTypes.isEmpty, "\(candidate) takes no drop")
            reachedContentView = candidate === contentView
            receiver = candidate.superview
        }
        XCTAssertTrue(reachedContentView, "the walk reached the window's content view")

        // The drop carries text from a pasteboard of this test's own, never the system's drag
        // pasteboard: that one is shared, so what it happened to hold would decide whether a text
        // view that wrongly took the drop changed anything (the Swift packet's testing.md, "a test
        // that shares state gets its own state").
        let pasteboard = NSPasteboard(name: NSPasteboard.Name("nozoki.tests.\(UUID().uuidString)"))
        defer { pasteboard.releaseGlobally() }
        let dropped = "DROPPED ON THE PANEL"
        pasteboard.clearContents()
        XCTAssertTrue(pasteboard.setString(dropped, forType: .string))
        XCTAssertEqual(pasteboard.string(forType: .string), dropped, "the drag holds the text")
        XCTAssertFalse(textView.string.contains(dropped), "the file does not hold the text")

        let drag = StubDragInfo(window: window, location: point, pasteboard: pasteboard)
        XCTAssertEqual(hit.draggingEntered(drag), [], "no drag is accepted over the text")
        XCTAssertFalse(hit.performDragOperation(drag), "no drop is delivered over the text")

        assertNothingChanged(since: before, in: shown)
    }

    // MARK: - The text's right-click menu offers no editing entry (R-49, CP-377 – CP-382)

    /// Every title CP-378 names, which the stock text menu carries today (change_spec.md
    /// Verified Claim 3). The list is the floor a title check can reach; CP-377's rule is the
    /// action check in `assertOnlyCopyIsOffered`.
    private let editingTitles = [
        "Cut", "Paste", "Paste and Match Style", "Font", "Show Fonts", "Show Colors",
        "Show Writing Tools", "Summarize", "Spelling and Grammar", "Show Spelling and Grammar",
        "Check Document Now", "Check Spelling While Typing", "Check Grammar With Spelling",
        "Correct Spelling Automatically", "Substitutions", "Show Substitutions", "Smart Copy/Paste",
        "Smart Quotes", "Smart Dashes", "Smart Links", "Data Detectors", "Text Replacement",
    ]

    /// A right-click as the design's probe made it: no window, location (5, 5)
    /// (change_design.md Architect Review Notes, *Probe disagreement*).
    private func rightClick() throws -> NSEvent {
        try XCTUnwrap(
            NSEvent.mouseEvent(
                with: .rightMouseDown, location: NSPoint(x: 5, y: 5), modifierFlags: [],
                timestamp: 0, windowNumber: 0, context: nil, eventNumber: 0, clickCount: 1,
                pressure: 1))
    }

    /// The menu a right-click on the text of a shown file gets, with `selection` selected when
    /// given. Nil would fail the caller's assertions, so it is unwrapped here.
    private func textMenu(
        showing path: String, _ verdict: FileVerdict, selecting selection: NSRange? = nil
    ) throws -> NSMenu {
        let panel = makePanel()
        panel.show(path: path, verdict: verdict)
        if let selection { panel.contentView.setSelectedRange(selection) }
        return try XCTUnwrap(panel.contentView.menu(for: try rightClick()))
    }

    /// Every entry of `menu` at every depth, separators included.
    private func entries(of menu: NSMenu) -> [NSMenuItem] {
        menu.items.flatMap { [$0] + ($0.submenu.map(entries(of:)) ?? []) }
    }

    /// The titles of the entries of `menu` at every depth, separators left out.
    private func titles(of menu: NSMenu) -> [String] {
        entries(of: menu).filter { !$0.isSeparatorItem }.map(\.title)
    }

    /// Presence, never enablement: an enabled and a disabled editing entry fail alike
    /// (change_design.md § 5, T1).
    private func assertCopyAndNoEditingEntry(
        _ menu: NSMenu, file: StaticString = #filePath, line: UInt = #line
    ) {
        let present = titles(of: menu)
        XCTAssertEqual(
            present.filter { editingTitles.contains($0) }, [], "editing entries in \(present)",
            file: file, line: line)
        XCTAssertTrue(
            entries(of: menu).contains {
                $0.title == "Copy" && $0.action == #selector(NSText.copy(_:))
            }, "Copy is offered in \(present)", file: file, line: line)
    }

    /// No separator first or last, and none beside another, in `menu` and in each submenu.
    private func separatorFaults(in menu: NSMenu) -> [String] {
        var faults: [String] = []
        for (index, item) in menu.items.enumerated() {
            if item.isSeparatorItem {
                if index == 0 { faults.append("first in \"\(menu.title)\"") }
                if index == menu.items.count - 1 { faults.append("last in \"\(menu.title)\"") }
                if index > 0, menu.items[index - 1].isSeparatorItem {
                    faults.append("beside another in \"\(menu.title)\"")
                }
            }
            if let submenu = item.submenu { faults += separatorFaults(in: submenu) }
        }
        return faults
    }

    func testPlainTextMenuOffersCopyAndNoEditingEntryWithoutSelection() throws {
        let menu = try textMenu(showing: "src/lib.rs", .text("fn main() {}\n", .plain))

        assertCopyAndNoEditingEntry(menu)
    }

    func testSelectedTextMenuOffersCopyAndNoEditingEntry() throws {
        let menu = try textMenu(
            showing: "src/lib.rs", .text("fn main() {}\n", .plain),
            selecting: NSRange(location: 0, length: 2))

        assertCopyAndNoEditingEntry(menu)
    }

    func testHighlightedPythonMenuOffersCopyAndNoEditingEntry() throws {
        let menu = try textMenu(showing: "m.py", floorVerdict(fixtureM, .python, fixtureMSpans))

        assertCopyAndNoEditingEntry(menu)
    }

    func testMarkdownSourceMenuOffersCopyAndNoEditingEntry() throws {
        let menu = try textMenu(showing: "README.md", .text("# Title\n\nbody\n", .plain))

        assertCopyAndNoEditingEntry(menu)
    }

    func testTextMenuHoldsExactlyOneCopyItemWithTheCopyAction() throws {
        let menu = try textMenu(showing: "src/lib.rs", .text("fn main() {}\n", .plain))

        let actions = entries(of: menu).compactMap(\.action)
        XCTAssertEqual(actions, [#selector(NSText.copy(_:))], "every action at every depth")
        XCTAssertEqual(entries(of: menu).count, 1, "nothing else at any depth, separators included")
    }

    func testTextMenuDisablesDisplayTimeAdditions() throws {
        let menu = try textMenu(showing: "src/lib.rs", .text("fn main() {}\n", .plain))

        XCTAssertFalse(menu.allowsContextMenuPlugIns, "no contextual-menu plug-in entries")
        if #available(macOS 15.2, *) {
            XCTAssertFalse(menu.automaticallyInsertsWritingToolsItems, "no Writing Tools entries")
        }
    }

    func testMenuCopyPreservesSelectedCharactersAndShownText() throws {
        let panel = makePanel()
        panel.show(path: "src/lib.rs", verdict: .text("fn main() {}\n", .plain))
        panel.contentView.setSelectedRange(NSRange(location: 0, length: 2))
        let menu = try XCTUnwrap(panel.contentView.menu(for: try rightClick()))
        let copy = try XCTUnwrap(entries(of: menu).first { $0.title == "Copy" })
        XCTAssertEqual(copy.action, #selector(NSText.copy(_:)))
        // A pasteboard of this test's own, never the general one: that is the owner's clipboard.
        let pasteboard = NSPasteboard(name: NSPasteboard.Name("nozoki-test-\(UUID().uuidString)"))
        defer { pasteboard.releaseGlobally() }

        pasteboard.clearContents()
        XCTAssertTrue(
            panel.contentView.writeSelection(
                to: pasteboard, types: panel.contentView.writablePasteboardTypes))

        XCTAssertEqual(pasteboard.string(forType: .string), "fn")
        XCTAssertEqual(panel.contentView.string, "fn main() {}\n")
    }

    func testTextMenuAddsNoTitleToTheMatchingStockMenu() throws {
        let content = "fn main() {}\n"
        let selection = NSRange(location: 0, length: 2)
        let menu = try textMenu(
            showing: "src/lib.rs", .text(content, .plain), selecting: selection)
        // The stock view is built the way `CodeView` builds its text view: TextKit 1, not
        // editable, not rich text, selectable. The stock menu is read at run time, so the test
        // holds on a machine whose non-editing entries differ (change_design.md § 5, T9).
        let storage = NSTextStorage()
        let layoutManager = NSLayoutManager()
        storage.addLayoutManager(layoutManager)
        let container = NSTextContainer(size: NSSize(width: 600, height: 400))
        layoutManager.addTextContainer(container)
        let stock = NSTextView(
            frame: NSRect(x: 0, y: 0, width: 600, height: 400), textContainer: container)
        stock.isEditable = false
        stock.isRichText = false
        stock.isSelectable = true
        stock.string = content
        stock.setSelectedRange(selection)
        let stockMenu = try XCTUnwrap(stock.menu(for: try rightClick()))

        let stockTitles = Set(titles(of: stockMenu))
        let added = titles(of: menu).filter { !stockTitles.contains($0) }
        XCTAssertEqual(added, [], "titles the stock menu does not carry")
    }

    func testTextMenuHasNoEmptySeparatorGroupWithOrWithoutSelection() throws {
        let content = "fn main() {}\n"
        let unselected = try textMenu(showing: "src/lib.rs", .text(content, .plain))
        let selected = try textMenu(
            showing: "src/lib.rs", .text(content, .plain),
            selecting: NSRange(location: 0, length: 2))

        XCTAssertEqual(separatorFaults(in: unselected), [], "no selection")
        XCTAssertEqual(separatorFaults(in: selected), [], "`fn` selected")
    }

    // The filter, driven with menus the tests build (change_design.md § 5, T5 and T7).

    private func menuItem(_ title: String, _ action: Selector?) -> NSMenuItem {
        NSMenuItem(title: title, action: action, keyEquivalent: "")
    }

    func testTextMenuRejectsUnlistedEditingActionsAndKeepsInputWhole() throws {
        let transformations = NSMenu(title: "Transformations")
        transformations.addItem(
            menuItem("Make Upper Case", #selector(NSResponder.uppercaseWord(_:))))
        let transformationsItem = menuItem("Transformations", nil)
        transformationsItem.submenu = transformations
        let input = NSMenu(title: "")
        input.addItem(menuItem("Copy", #selector(NSText.copy(_:))))
        input.addItem(.separator())
        // A title no macOS offers: the rule is the action, not a list of today's titles.
        input.addItem(menuItem("Shout Louder", #selector(NSResponder.lowercaseWord(_:))))
        input.addItem(transformationsItem)

        let kept = try XCTUnwrap(keptTextMenu(from: input))

        XCTAssertEqual(kept.items.map(\.title), ["Copy"])
        XCTAssertEqual(kept.items.map(\.action), [#selector(NSText.copy(_:))])
        XCTAssertEqual(input.items.count, 4, "the input keeps all its entries")
        XCTAssertEqual(input.items[3].submenu?.items.map(\.title), ["Make Upper Case"])
    }

    func testNestedCopyIsNotPromotedIntoTheTextMenu() throws {
        let submenu = NSMenu(title: "Nested")
        submenu.addItem(menuItem("Nested Copy", #selector(NSText.copy(_:))))
        let parent = menuItem("Nested", nil)
        parent.submenu = submenu
        let input = NSMenu(title: "")
        input.addItem(parent)

        XCTAssertNil(keptTextMenu(from: input), "only top-level Copy entries may survive")

        input.addItem(menuItem("Top-level Copy", #selector(NSText.copy(_:))))
        let kept = try XCTUnwrap(keptTextMenu(from: input))

        XCTAssertEqual(titles(of: kept), ["Top-level Copy"])
        XCTAssertEqual(submenu.items.map(\.title), ["Nested Copy"])
        XCTAssertTrue(input.items[0] === parent)
        XCTAssertTrue(parent.submenu === submenu)
    }

    func testMenuWithNoKeptActionReturnsNoMenu() {
        let editingOnly = NSMenu(title: "")
        editingOnly.addItem(menuItem("Cut", #selector(NSText.cut(_:))))
        editingOnly.addItem(menuItem("Paste", #selector(NSText.paste(_:))))

        XCTAssertNil(keptTextMenu(from: editingOnly))
        XCTAssertNil(keptTextMenu(from: NSMenu(title: "")), "an empty menu keeps nothing either")
    }

    func testMenuUsesActionsRatherThanLocalizedTitles() throws {
        let input = NSMenu(title: "")
        input.addItem(menuItem("Kopieren", #selector(NSText.copy(_:))))
        input.addItem(menuItem("Copy", #selector(NSText.paste(_:))))

        let kept = try XCTUnwrap(keptTextMenu(from: input))

        XCTAssertEqual(kept.items.map(\.title), ["Kopieren"], "a localized Copy stays")
        XCTAssertEqual(kept.items.map(\.action), [#selector(NSText.copy(_:))])
    }

    func testKeptMenuItemIsAnIndependentCopyWithItsStockProperties() throws {
        let target = NSObject()
        let original = NSMenuItem(
            title: "Copy", action: #selector(NSText.copy(_:)), keyEquivalent: "c")
        original.target = target
        original.isEnabled = false
        let input = NSMenu(title: "")
        input.addItem(original)

        let kept = try XCTUnwrap(keptTextMenu(from: input)).items[0]

        XCTAssertFalse(kept === original, "not the input's own item")
        XCTAssertEqual(kept.title, "Copy")
        XCTAssertTrue(kept.target === target)
        XCTAssertEqual(kept.action, #selector(NSText.copy(_:)))
        XCTAssertEqual(kept.keyEquivalent, "c")
        XCTAssertFalse(kept.isEnabled)
        kept.title = "Changed"
        kept.isEnabled = true
        XCTAssertEqual(original.title, "Copy")
        XCTAssertFalse(original.isEnabled)
    }
}
