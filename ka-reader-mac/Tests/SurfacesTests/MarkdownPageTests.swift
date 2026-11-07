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
}

@MainActor
@Test(arguments: [
    (
        ImagePlaceholderCondition.outsideTheFolder,
        "This image is outside the folder you opened, so KA-Reader doesn't read it."
    ),
    (ImagePlaceholderCondition.missing, "There's no file where this image points."),
    (ImagePlaceholderCondition.unreadable, "KA-Reader can't read this image."),
    (ImagePlaceholderCondition.formatNotDecoded, "KA-Reader doesn't show images in this format."),
])
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
