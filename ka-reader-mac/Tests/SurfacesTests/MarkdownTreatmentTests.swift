import AppKit
import Foundation
import Surfaces
import Testing

/// The Markdown treatment on the real reading panel (CP-1119): a resolved image is asked for by its
/// path and drawn from the bytes answered, a placeholder asks for nothing, no attributed string is
/// built from HTML, and every image that cannot be drawn takes the unreadable box.

private let unreadable = "KA-Reader can't read this image."

@MainActor
@Test
func aResolvedImageIsAskedForByItsPathAndDrawnFromTheBytesAnswered() throws {
    let recorder = AssetRecorder()
    let bytes = try renderedPNG(width: 4, height: 3)
    recorder.bytes = ["logo.png": bytes]
    let panel = makeMarkdownPanel(recorder: recorder)

    panel.show(
        path: "README.md",
        verdict: .markdown(
            pageDocument([.paragraph([.image(alt: "logo", .resolved(path: "logo.png"))])])))

    #expect(recorder.asked == ["logo.png"])
    let attachments = try panel.markdownPage.attachments()
    let drawn = try #require(attachments.first?.attachment.image)
    #expect(drawn.tiffRepresentation == NSImage(data: bytes)?.tiffRepresentation)
}

@MainActor
@Test
func aPlaceholderIsDrawnWithNoBytesAskedForAtAll() throws {
    let recorder = AssetRecorder()
    let panel = makeMarkdownPanel(recorder: recorder)
    let sentences: [ImagePlaceholderCondition: String] = [
        .outsideTheFolder:
            "This image is outside the folder you opened, so KA-Reader doesn't read it.",
        .missing: "There's no file where this image points.",
        .unreadable: "KA-Reader can't read this image.",
        .formatNotDecoded: "KA-Reader doesn't show images in this format.",
    ]

    for condition in ImagePlaceholderCondition.allCases {
        panel.show(
            path: "README.md",
            verdict: .markdown(
                pageDocument([
                    .paragraph([.image(alt: "alt", .placeholder(condition, source: "a/b.png"))])
                ])))

        #expect(
            try panel.markdownPage.boxes() == [
                ["alt", "a/b.png", try #require(sentences[condition])]
            ])
        #expect(try panel.markdownPage.attachments().isEmpty)
        if condition != .outsideTheFolder {
            #expect(!panel.markdownPage.textView.string.contains("outside the folder"))
        }
    }
    #expect(recorder.asked.isEmpty)
}

@MainActor
@Test
func rawHtmlIsNeverBuiltIntoAnAttributedString() throws {
    let recorder = AssetRecorder()
    let pieces = [
        "<script>alert(1)</script>", "<img src=x onerror=steal()>",
        "<iframe src=\"https://example.com/frame\"></iframe>",
        "<style>body { display: none }</style>", "<div class=\"box\">raw</div>",
    ]
    let panel = makeMarkdownPanel(recorder: recorder)

    panel.show(
        path: "hostile.md", verdict: .markdown(pageDocument(pieces.map { textParagraph($0) })))

    for piece in pieces { #expect(panel.markdownPage.textView.string.contains(piece)) }
    #expect(try panel.markdownPage.attachments().isEmpty)
    #expect(recorder.asked.isEmpty)
}

@MainActor
@Test(arguments: malformedFixtureNames)
func eachMalformedBitmapHandedOverAsBytesDrawsTheUnreadableBox(name: String) throws {
    let recorder = AssetRecorder()
    recorder.bytes = ["logo.png": try malformedFixture(name)]
    let panel = makeMarkdownPanel(recorder: recorder)

    panel.show(
        path: "README.md",
        verdict: .markdown(
            pageDocument([
                .paragraph([.image(alt: "logo", .resolved(path: "logo.png"))]),
                textParagraph("the paragraph after"),
            ])))

    #expect(try panel.markdownPage.boxes() == [["logo", "logo.png", unreadable]])
    #expect(panel.markdownPage.textView.string.contains("the paragraph after"))
}

@MainActor
@Test
func anAnswerOfNilFromTheIntentDrawsTheUnreadableBox() throws {
    let recorder = AssetRecorder()
    let panel = makeMarkdownPanel(recorder: recorder)

    panel.show(
        path: "README.md",
        verdict: .markdown(
            pageDocument([.paragraph([.image(alt: "logo", .resolved(path: "logo.png"))])])))

    #expect(recorder.asked == ["logo.png"])
    #expect(try panel.markdownPage.boxes() == [["logo", "logo.png", unreadable]])
}

@MainActor
@Test
func withNoAssetBytesIntentSetEveryResolvedImageDrawsTheUnreadableBox() throws {
    let panel = makeMarkdownPanel()

    panel.show(
        path: "README.md",
        verdict: .markdown(
            pageDocument([
                .paragraph([.image(alt: "one", .resolved(path: "one.png"))]),
                textParagraph("between"),
                .paragraph([.image(alt: "two", .resolved(path: "two.png"))]),
            ])))

    #expect(
        try panel.markdownPage.boxes() == [
            ["one", "one.png", unreadable], ["two", "two.png", unreadable],
        ])
}

@MainActor
@Test
func aRelativeLinkActivationIsForwardedWithTheTargetPath() throws {
    var raised: [String] = []
    let panel = makeMarkdownPanel()
    panel.relativeLinkActivated = { raised.append($0) }
    panel.show(
        path: "README.md",
        verdict: .markdown(
            pageDocument([
                .paragraph([
                    .link(
                        [.text("guide")], destination: "./docs/guide.md",
                        .relative(path: "docs/guide.md"))
                ])
            ])))

    let storage = try panel.markdownPage.storage
    let token = try #require(unsafe storage.attribute(.link, at: 0, effectiveRange: nil))
    let delegate = try #require(panel.markdownPage.textView.delegate)
    _ = delegate.textView?(panel.markdownPage.textView, clickedOnLink: token, at: 0)

    #expect(raised == ["docs/guide.md"])
}
