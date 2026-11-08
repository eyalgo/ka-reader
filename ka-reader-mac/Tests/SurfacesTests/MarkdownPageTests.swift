import AppKit
import Foundation
import Surfaces
import Testing

/// The rendered page (CP-1105 – CP-1112): blocks in source order, text drawn as the nodes hold it,
/// code coloured by its spans, images decoded from the bytes handed over, a placeholder box for every
/// other image, and a view nothing can change. The page is handed a document and the answered bytes
/// and asks for nothing itself.

private let unreadable = "KA-Reader can't read this image."

@MainActor
@Test
func headingsParagraphsListsQuotesAndRulesAreDrawnInSourceOrder() throws {
    let page = makePage(
        pageDocument([
            .heading(.two, [.text("Title")]),
            textParagraph("Body words"),
            .list(.unordered, items: [[textParagraph("alpha")], [textParagraph("beta")]]),
            .list(
                .ordered(start: 3),
                items: [
                    [
                        textParagraph("three"),
                        .list(.unordered, items: [[textParagraph("nested")]]),
                    ],
                    [textParagraph("four")],
                ]),
            .quote([textParagraph("quoted")]),
            .rule,
            textParagraph("After"),
        ]))

    let order = [
        "Title", "Body words", "alpha", "beta", "three", "nested", "four", "quoted", "After",
    ]
    let positions = try order.map { try page.range(of: $0).location }
    #expect(positions == positions.sorted())
    #expect(page.textView.string.contains("3. three"))
    #expect(page.textView.string.contains("4. four"))
    #expect(page.textView.string.contains("• alpha"))
    let title = try #require(try page.attribute(.font, at: "Title") as? NSFont)
    let body = try #require(try page.attribute(.font, at: "Body words") as? NSFont)
    #expect(title.pointSize > body.pointSize)
    let nested = try #require(
        try page.attribute(.paragraphStyle, at: "nested") as? NSParagraphStyle)
    let outer = try #require(try page.attribute(.paragraphStyle, at: "three") as? NSParagraphStyle)
    #expect(nested.headIndent > outer.headIndent)
    let ruleRange = (page.textView.string as NSString).range(of: "\u{A0}")
    #expect(ruleRange.location != NSNotFound)
    let ruleStorage = try page.storage
    let strike = unsafe ruleStorage.attribute(
        .strikethroughStyle, at: ruleRange.location, effectiveRange: nil)
    #expect(strike != nil)
}

@MainActor
@Test
func anEmptyDocumentDrawsAnEmptyPageWithNoMessage() throws {
    let page = makePage(pageDocument([]))

    #expect(page.textView.string.isEmpty)
    #expect(try page.attachments().isEmpty)
}

@MainActor
@Test
func aPythonBlockCarriesItsSpanColoursAndAPlainBlockOneInk() throws {
    // `é` is two UTF-8 bytes and one UTF-16 unit, so a span after it lands on the right range.
    let source = "é = def"
    let spans = [
        CodeSpan(start: 5, end: 8, tokenClass: .keyword)
    ]
    let page = makePage(
        pageDocument([
            .code(source, .floor(.python, spans)),
            .code("def plain", .plain),
            .code("fn other", .plain),
        ]))

    let keyword = try #require(try page.ink(at: "def\n"))
    let base = try #require(try page.ink(at: "é"))
    #expect(keyword != base)
    let python = try page.range(of: source)
    var colours = Set<String>()
    let pythonStorage = try page.storage
    unsafe pythonStorage.enumerateAttribute(.foregroundColor, in: python) { value, range, _ in
        if let colour = value as? NSColor, let rgb = resolved(colour) {
            colours.insert("\(range.location):\(rgb)")
        }
    }
    #expect(colours.count == 2)
    #expect(try page.range(of: "def").location == python.location + 4)
    let plainInk = try #require(try page.ink(at: "def plain"))
    let otherInk = try #require(try page.ink(at: "fn other"))
    #expect(plainInk == base)
    #expect(otherInk == plainInk)
    var plainColours = Set<NSColor>()
    let plainRange = try page.range(of: "def plain")
    unsafe pythonStorage.enumerateAttribute(.foregroundColor, in: plainRange) { value, _, _ in
        if let colour = resolved(value as? NSColor) { plainColours.insert(colour) }
    }
    #expect(plainColours.count == 1)
}

@MainActor
@Test
func rawHtmlReadsAsItsLiteralSourceText() throws {
    let pieces = [
        "<script>alert(1)</script>",
        "<img src=x onerror=alert(2)>",
        "<iframe src=\"https://example.com/frame\"></iframe>",
        "<style>body { display: none }</style>",
        "<div class=\"box\">\nraw block content\n</div>",
    ]
    let page = makePage(pageDocument(pieces.map { textParagraph($0) }))

    for piece in pieces {
        #expect(page.textView.string.contains(piece))
    }
    #expect(try page.attachments().isEmpty)
    let storage = try page.storage
    var links = 0
    unsafe storage.enumerateAttribute(.link, in: NSRange(location: 0, length: storage.length)) {
        value, _, _ in
        if value != nil { links += 1 }
    }
    #expect(links == 0)
}

@MainActor
@Test
func aResolvedImageIsDrawnFromTheHandedBytes() throws {
    let bytes = try renderedPNG(width: 3, height: 2)
    let page = makePage(
        pageDocument([
            .paragraph([.text("before "), .image(alt: "logo", .resolved(path: "logo.png"))])
        ]),
        imageBytes: ["logo.png": bytes])

    let attachments = try page.attachments()
    #expect(attachments.count == 1)
    let drawn = try #require(attachments.first?.attachment.image)
    let expected = try #require(NSImage(data: bytes))
    #expect(drawn.tiffRepresentation == expected.tiffRepresentation)
    #expect(attachments.first?.index == (page.textView.string as NSString).length - 1)
    #expect(try page.boxes().isEmpty)
}

@MainActor
@Test
func anImageWhoseBytesAreNilDrawsTheUnreadableBox() throws {
    let page = makePage(
        pageDocument([
            .paragraph([.image(alt: "the logo", .resolved(path: "img/logo.png"))]),
            textParagraph("still here"),
        ]))

    #expect(try page.boxes() == [["the logo", "img/logo.png", unreadable]])
    #expect(try page.attachments().isEmpty)
    #expect(page.textView.string.contains("still here"))
    try expectPlaceholderBox(page, alt: "the logo", source: "img/logo.png", sentence: unreadable)
}

@MainActor
@Test(arguments: malformedFixtureNames)
func eachMalformedBitmapDrawsTheUnreadableBoxAndThePageSurvives(name: String) throws {
    let bytes = try malformedFixture(name)
    let page = makePage(
        pageDocument([
            .paragraph([.image(alt: "broken", .resolved(path: "logo.png"))]),
            textParagraph("after the image"),
        ]),
        imageBytes: ["logo.png": bytes])

    #expect(try page.boxes() == [["broken", "logo.png", unreadable]])
    #expect(try page.attachments().isEmpty)
    #expect(page.textView.string.contains("after the image"))
    try expectPlaceholderBox(page, alt: "broken", source: "logo.png", sentence: unreadable)
}

private let placeholderConditionSentences: [(ImagePlaceholderCondition, String)] = [
    (
        ImagePlaceholderCondition.outsideTheFolder,
        "This image is outside the folder you opened, so KA-Reader doesn't read it."
    ),
    (ImagePlaceholderCondition.missing, "There's no file where this image points."),
    (ImagePlaceholderCondition.unreadable, "KA-Reader can't read this image."),
    (ImagePlaceholderCondition.formatNotDecoded, "KA-Reader doesn't show images in this format."),
]

@MainActor
@Test(arguments: placeholderConditionSentences)
func aPlaceholderBoxHoldsTheAltTheSourceAndItsConditionsSentence(
    condition: ImagePlaceholderCondition, sentence: String
) throws {
    let page = makePage(
        pageDocument([
            .paragraph([.image(alt: "alt words", .placeholder(condition, source: "pics/a b.svg"))])
        ]))

    #expect(try page.boxes() == [["alt words", "pics/a b.svg", sentence]])
    #expect(try page.attachments().isEmpty)
    if condition != .outsideTheFolder {
        #expect(!page.textView.string.contains("outside the folder"))
    }
}

// MARK: - The placeholder box's surface (CP-1156 – CP-1160, CP-1162)

private let lineLight: UInt32 = 0xD8D8D4
private let lineDark: UInt32 = 0x3B3C41
private let pageGroundLight: UInt32 = 0xFBFBFA
private let pageGroundDark: UInt32 = 0x1B1C1E
private let boxPadding: CGFloat = 12
private let boxHairline: CGFloat = 1

/// The one block a placeholder box's three paragraphs sit in: the canvas background, a one-point
/// `{colors.line}` border and `{spacing.md}` of padding on every edge, in both appearances.
@MainActor
private func expectPlaceholderBox(
    _ page: MarkdownPageView, alt: String, source: String, sentence: String
) throws {
    let held = try [alt, source, sentence].map { try page.textBlocks(at: $0) }
    #expect(held.allSatisfy { $0.count == 1 })
    let block = try #require(held.first?.first)
    #expect(held.allSatisfy { $0.first === block })
    #expect(hexValue(of: block.backgroundColor, under: .aqua) == canvasLight)
    #expect(hexValue(of: block.backgroundColor, under: .darkAqua) == canvasDark)
    for edge in allEdges {
        #expect(block.width(for: .border, edge: edge) == boxHairline)
        #expect(hexValue(of: block.borderColor(for: edge), under: .aqua) == lineLight)
        #expect(hexValue(of: block.borderColor(for: edge), under: .darkAqua) == lineDark)
        #expect(block.width(for: .padding, edge: edge) == boxPadding)
    }
}

@MainActor
@Test(arguments: placeholderConditionSentences)
func aPlaceholderBoxWearsTheCanvasTheHairlineAndThePaddingInEveryCondition(
    condition: ImagePlaceholderCondition, sentence: String
) throws {
    let page = makePage(
        pageDocument([
            .paragraph([.image(alt: "alt words", .placeholder(condition, source: "pics/a b.svg"))])
        ]))

    try expectPlaceholderBox(page, alt: "alt words", source: "pics/a b.svg", sentence: sentence)
    #expect(hexValue(of: page.textView.backgroundColor, under: .aqua) == pageGroundLight)
    #expect(hexValue(of: page.textView.backgroundColor, under: .darkAqua) == pageGroundDark)
}

@MainActor
@Test
func aPlaceholderBoxInAListItemWearsTheSameToken() throws {
    let sentence = "There's no file where this image points."
    let page = makePage(
        pageDocument([
            .list(
                .unordered,
                items: [[.paragraph([.image(alt: "deep", .placeholder(.missing, source: "d.png"))])]])
        ]))

    try expectPlaceholderBox(page, alt: "deep", source: "d.png", sentence: sentence)
    let block = try #require(try page.textBlocks(at: "deep").first)
    for edge in allEdges {
        #expect(block.width(for: .margin, edge: edge) == 0)
    }
}

@MainActor
@Test
func theViewIsNotEditableAndRegistersNoDragType() {
    let page = makePage(pageDocument([textParagraph("words")]))

    #expect(!page.textView.isEditable)
    #expect(page.textView.isSelectable)
    #expect(page.textView.registeredDraggedTypes.isEmpty)
}

@MainActor
@Test
func aTypedKeyAPasteAndADropLeaveTheStorageUnchanged() throws {
    let page = makePage(pageDocument([textParagraph("words")]))
    let before = page.textView.string
    let pasteboard = NSPasteboard(
        name: NSPasteboard.Name("ka-reader-page-test-\(UUID().uuidString)"))
    defer { pasteboard.releaseGlobally() }
    pasteboard.clearContents()
    pasteboard.setString("pasted", forType: .string)

    page.textView.insertText("x", replacementRange: NSRange(location: 0, length: 0))
    _ = page.textView.readSelection(from: pasteboard)
    page.textView.insertText("dropped", replacementRange: NSRange(location: 0, length: 5))

    #expect(page.textView.string == before)
}

@MainActor
@Test
func theContextualMenuHoldsCopyAlone() throws {
    let page = makePage(pageDocument([textParagraph("words")]))
    let window = NSWindow(
        contentRect: NSRect(x: 0, y: 0, width: 600, height: 400), styleMask: [.titled],
        backing: .buffered, defer: true)
    window.contentView = page
    let event = try #require(
        NSEvent.mouseEvent(
            with: .rightMouseDown, location: NSPoint(x: 40, y: 40), modifierFlags: [],
            timestamp: 0, windowNumber: window.windowNumber, context: nil, eventNumber: 0,
            clickCount: 1, pressure: 1))

    let menu = page.textView.menu(for: event)

    let actions = (menu?.items ?? []).compactMap(\.action)
    #expect(actions == [#selector(NSText.copy(_:))])
}

@MainActor
@Test
func theRenderedPageShowsThePathLineAboveIt() {
    let panel = makeMarkdownPanel(recorder: AssetRecorder())

    panel.show(path: "docs/guide.md", verdict: .markdown(pageDocument([textParagraph("words")])))
    panel.layoutSubtreeIfNeeded()

    #expect(panel.pathLine.stringValue == "docs/guide.md")
    #expect(!panel.pathLine.isHiddenOrHasHiddenAncestor)
    // The panel is not flipped: "above" is a larger y.
    let pathBottom = panel.pathLine.convert(panel.pathLine.bounds, to: panel).minY
    let pageTop = panel.markdownPage.convert(panel.markdownPage.bounds, to: panel).maxY
    #expect(pathBottom >= pageTop)
}

@MainActor
@Test
func noControlAndNoSentenceMentionsARawView() {
    let panel = makeMarkdownPanel(recorder: AssetRecorder())

    panel.show(
        path: "README.md", verdict: .markdown(pageDocument([textParagraph("The page words")])))
    panel.layoutSubtreeIfNeeded()

    let visible = panel.allDescendants.filter { !$0.isHiddenOrHasHiddenAncestor }
    let strings = visible.compactMap { ($0 as? NSTextField)?.stringValue }
    #expect(strings == ["README.md"])
    #expect(panel.markdownPage.textView.string == "The page words")
    #expect(!visible.contains { $0 is NSButton })
    for text in strings + [panel.markdownPage.textView.string] {
        #expect(!text.localizedCaseInsensitiveContains("raw"))
        #expect(!text.localizedCaseInsensitiveContains("switch"))
    }
}

// MARK: - The code block's canvas surface (CP-1146, CP-1149, CP-1150)

private let canvasLight: UInt32 = 0xF2F2F0
private let canvasDark: UInt32 = 0x232427
private let codePadding: CGFloat = 4
private let allEdges: [NSRectEdge] = [.minX, .minY, .maxX, .maxY]

/// A Python block of two lines: `import` is a keyword, `name` a name and `"x"` a string.
private let pythonSource = "import os\nname = \"x\"\n"
private let pythonSpans = [
    CodeSpan(start: 0, end: 6, tokenClass: .keyword),
    CodeSpan(start: 10, end: 14, tokenClass: .name),
    CodeSpan(start: 17, end: 20, tokenClass: .string),
]

/// The one canvas block a code block's paragraphs sit in: the canvas background, the padding on
/// every edge and no border.
@MainActor
private func expectCanvasBlock(_ blocks: [NSTextBlock]) throws {
    #expect(blocks.count == 1)
    let block = try #require(blocks.first)
    #expect(hexValue(of: block.backgroundColor, under: .aqua) == canvasLight)
    for edge in allEdges {
        #expect(block.width(for: .padding, edge: edge) == codePadding)
        #expect(block.width(for: .border, edge: edge) == 0)
    }
}

@MainActor
@Test
func aFencedBlockSitsInOneCanvasTextBlockOnEveryParagraph() throws {
    let page = makePage(
        pageDocument([
            textParagraph("Before"),
            .code(pythonSource, .floor(.python, pythonSpans)),
            textParagraph("After"),
        ]))

    let first = try page.textBlocks(at: "import os")
    let second = try page.textBlocks(at: "name = ")
    try expectCanvasBlock(first)
    try expectCanvasBlock(second)
    #expect(first.first === second.first)
    #expect(try page.textBlocks(at: "Before").isEmpty)
    #expect(try page.textBlocks(at: "After").isEmpty)
}

@MainActor
@Test
func aFloorLanguageBlockKeepsItsSpanColoursOnTheCanvas() throws {
    let page = makePage(
        pageDocument([.code(pythonSource, .floor(.python, pythonSpans))]))

    // The light values of `docs/DESIGN.md` § Colors: each span keeps its token's ink, and the
    // text no span covers keeps `{colors.primary}` (CP-1149).
    let expected: [(String, UInt32)] = [
        ("import", 0x7A2E8F), ("name", 0x0F5A9A), ("\"x\"", 0x1A6B3A), ("os", 0x1E1F22),
    ]
    for (needle, value) in expected {
        let ink = try page.attribute(.foregroundColor, at: needle) as? NSColor
        #expect(hexValue(of: ink, under: .aqua) == value, "\(needle)")
    }
    let font = try #require(try page.attribute(.font, at: "import") as? NSFont)
    #expect(font.fontDescriptor.symbolicTraits.contains(.monoSpace))
    try expectCanvasBlock(try page.textBlocks(at: "import"))
}

@MainActor
@Test
func anIndentedBlockInAListItemCarriesTheCanvasBlock() throws {
    let page = makePage(
        pageDocument([
            .list(.unordered, items: [[textParagraph("item"), .code("run it\nnow", .plain)]])
        ]))

    try expectCanvasBlock(try page.textBlocks(at: "run it"))
    try expectCanvasBlock(try page.textBlocks(at: "now"))
    #expect(try page.textBlocks(at: "item").isEmpty)
}

@MainActor
@Test
func aCodeBlockInAQuoteCarriesTheCanvasBlock() throws {
    let page = makePage(
        pageDocument([.quote([textParagraph("said"), .code("quoted code", .plain)])]))

    try expectCanvasBlock(try page.textBlocks(at: "quoted code"))
    #expect(try page.textBlocks(at: "said").isEmpty)
}

@MainActor
@Test
func aBlocksCanvasResolvesToItsDesignValueInBothAppearances() throws {
    let page = makePage(pageDocument([.code("fn canvas", .plain)]))

    let block = try #require(try page.textBlocks(at: "fn canvas").first)
    #expect(hexValue(of: block.backgroundColor, under: .aqua) == canvasLight)
    #expect(hexValue(of: block.backgroundColor, under: .darkAqua) == canvasDark)
}

@MainActor
@Test
func aPlaceholderBoxIsStillTheOnlyBoxOnAPageWithACodeBlock() throws {
    let codeOnly = makePage(pageDocument([.code(pythonSource, .plain)]))
    #expect(try codeOnly.boxes().isEmpty)

    let both = makePage(
        pageDocument([
            .paragraph([.image(alt: "the logo", .resolved(path: "img/logo.png"))]),
            .code(pythonSource, .plain),
        ]))
    #expect(try both.boxes() == [["the logo", "img/logo.png", unreadable]])
}

// MARK: - The inline code run's canvas fill (CP-1147, CP-1148, CP-1149, CP-1150)

/// Whether every character of `needle` carries the canvas as its background colour, in the light
/// appearance.
@MainActor
private func carriesCanvas(_ page: MarkdownPageView, on needle: String) throws -> Bool {
    let colours = try page.backgrounds(in: try page.range(of: needle))
    return !colours.isEmpty
        && colours.allSatisfy { hexValue(of: $0, under: .aqua) == canvasLight }
}

@MainActor
@Test
func inlineCodeCarriesTheCanvasOnItsOwnCharactersAlone() throws {
    let page = makePage(
        pageDocument([
            .paragraph([.text("Run "), .code("make"), .text(" now.")]),
            textParagraph("Second paragraph"),
        ]))

    #expect(page.paragraphs.first == "Run make now.")
    #expect(try carriesCanvas(page, on: "make"))
    let make = try page.range(of: "make")
    let around = [
        NSRange(location: make.location - 1, length: 1),
        NSRange(location: NSMaxRange(make), length: 1),
    ]
    for range in around {
        #expect(try page.backgrounds(in: range).allSatisfy { $0 == nil })
    }
    let second = try page.range(of: "Second paragraph")
    #expect(try page.backgrounds(in: second).allSatisfy { $0 == nil })
    #expect(try page.textBlocks(at: "Run").isEmpty)
    #expect(try page.ink(at: "make") == page.ink(at: "Run"))
    let font = try #require(try page.attribute(.font, at: "make") as? NSFont)
    #expect(font.fontDescriptor.symbolicTraits.contains(.monoSpace))
}

@MainActor
@Test
func inlineCodeInAHeadingCarriesTheCanvas() throws {
    let page = makePage(pageDocument([.heading(.one, [.text("Install "), .code("ka-reader")])]))

    #expect(try carriesCanvas(page, on: "ka-reader"))
}

@MainActor
@Test
func inlineCodeInAListItemAndAQuoteCarriesTheCanvas() throws {
    let page = makePage(
        pageDocument([
            .list(.unordered, items: [[.paragraph([.text("use "), .code("listed")])]]),
            .quote([.paragraph([.text("say "), .code("quoted")])]),
        ]))

    #expect(try carriesCanvas(page, on: "listed"))
    #expect(try carriesCanvas(page, on: "quoted"))
}

@MainActor
@Test
func inlineCodeInsideARelativeLinkKeepsTheUnderlineAndTheControl() throws {
    let page = makePage(
        pageDocument([
            .paragraph([
                .link(
                    [.code("open_relative_link")], destination: "docs/api.md",
                    .relative(path: "docs/api.md"))
            ])
        ]))

    #expect(try carriesCanvas(page, on: "open_relative_link"))
    #expect(try page.attribute(.underlineStyle, at: "open_relative_link") != nil)
    #expect(try page.attribute(.link, at: "open_relative_link") != nil)
}

@MainActor
@Test
func anInlineCodeRunInAnExternalLinkKeepsTheUnderlineAndHasNoControl() throws {
    let page = makePage(
        pageDocument([
            .paragraph([
                .link([.code("site")], destination: "https://example.com", .external)
            ])
        ]))

    #expect(try carriesCanvas(page, on: "site"))
    #expect(try page.attribute(.underlineStyle, at: "site") != nil)
    let storage = try page.storage
    var controls = 0
    unsafe storage.enumerateAttribute(.link, in: NSRange(location: 0, length: storage.length)) {
        value, _, _ in
        if value != nil { controls += 1 }
    }
    #expect(controls == 0)
}

/// CP-1147: the fill covers the code run's characters and nothing else, so the destination an
/// external link shows after its content (CP-1143) carries no canvas.
@MainActor
@Test
func anExternalLinksDestinationAfterAnInlineCodeRunCarriesNoCanvas() throws {
    let page = makePage(
        pageDocument([
            .paragraph([
                .link([.code("site")], destination: "https://example.com", .external)
            ])
        ]))

    #expect(try carriesCanvas(page, on: "site"))
    let destination = try page.range(of: " (https://example.com)")
    #expect(try page.backgrounds(in: destination).allSatisfy { $0 == nil })
}

@MainActor
@Test
func inlineCodeInsideAnEmphasisGainsTheFillAndKeepsTheCodeFont() throws {
    let page = makePage(
        pageDocument([.paragraph([.emphasis(.single, [.text("see "), .code("x")])])]))

    #expect(try carriesCanvas(page, on: "x"))
    let font = try #require(try page.attribute(.font, at: "x") as? NSFont)
    #expect(font.fontDescriptor.symbolicTraits.contains(.monoSpace))
}

@MainActor
@Test
func anEmptyInlineCodeNodeAddsNoCanvasAnywhere() throws {
    let page = makePage(pageDocument([.paragraph([.text("a"), .code(""), .text("b")])]))

    #expect(page.textView.string == "ab")
    #expect(try !page.carriesAnyBackground())
}

@MainActor
@Test
func theInlineCanvasResolvesToItsDesignValueInBothAppearances() throws {
    let page = makePage(pageDocument([.paragraph([.text("Run "), .code("make")])]))

    let canvas = try #require(try page.attribute(.backgroundColor, at: "make") as? NSColor)
    #expect(hexValue(of: canvas, under: .aqua) == canvasLight)
    #expect(hexValue(of: canvas, under: .darkAqua) == canvasDark)
}
