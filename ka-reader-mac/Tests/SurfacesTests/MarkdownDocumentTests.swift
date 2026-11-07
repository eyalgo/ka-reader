import Surfaces
import Testing

/// The document the shell draws, and its one piece of logic: the folder-relative path of every
/// resolved image node, in source order, nested ones included, once per node (the panel asks once
/// per node). A placeholder contributes none.

private func resolvedImage(_ path: String) -> MarkdownInline {
    .image(alt: "", .resolved(path: path))
}

private func paragraph(_ inlines: [MarkdownInline]) -> MarkdownBlock {
    .paragraph(inlines)
}

private func document(_ blocks: [MarkdownBlock]) -> MarkdownDocument {
    MarkdownDocument(blocks: blocks)
}

@Test
func resolvedImagePathsAreListedInSourceOrder() {
    let page = document([
        paragraph([.text("one "), resolvedImage("a.png")]),
        paragraph([resolvedImage("b/b.gif"), .text(" two"), resolvedImage("c.jpg")]),
    ])

    #expect(page.resolvedImagePaths == ["a.png", "b/b.gif", "c.jpg"])
}

@Test
func aResolvedImageInsideAListItemAQuoteEmphasisAndALinkIsListed() {
    let page = document([
        .list(.unordered, items: [[paragraph([resolvedImage("item.png")])]]),
        .quote([paragraph([resolvedImage("quote.png")])]),
        paragraph([.emphasis(.strong, [resolvedImage("emphasis.png")])]),
        paragraph([
            .link([resolvedImage("link.png")], destination: "x.md", .relative(path: "x.md"))
        ]),
        .heading(.two, [resolvedImage("heading.png")]),
        .list(
            .ordered(start: 3),
            items: [[.quote([.list(.unordered, items: [[paragraph([resolvedImage("deep.png")])]])])]]
        ),
    ])

    #expect(
        page.resolvedImagePaths == [
            "item.png", "quote.png", "emphasis.png", "link.png", "heading.png", "deep.png",
        ])
}

@Test
func aPlaceholderImageContributesNoPath() {
    let conditions: [ImagePlaceholderCondition] = [
        .outsideTheFolder, .missing, .unreadable, .formatNotDecoded,
    ]
    let placeholders = conditions.map { condition in
        MarkdownInline.image(alt: "alt", .placeholder(condition, source: "a.png"))
    }
    let page = document([paragraph(placeholders + [resolvedImage("kept.png")])])

    #expect(page.resolvedImagePaths == ["kept.png"])
}

@Test
func aPathThatAppearsTwiceIsListedTwice() {
    let page = document([
        paragraph([resolvedImage("logo.png"), resolvedImage("logo.png")]),
        paragraph([resolvedImage("logo.png")]),
    ])

    #expect(page.resolvedImagePaths == ["logo.png", "logo.png", "logo.png"])
}

@Test
func anEmptyDocumentListsNoPath() {
    #expect(document([]).resolvedImagePaths.isEmpty)
    #expect(document([.rule, .code("x", .plain)]).resolvedImagePaths.isEmpty)
}

@Test
func relativeLinkAnswersCarryAVerdictOrNothing() {
    #expect(RelativeLinkAnswer.opened(.gone) != RelativeLinkAnswer.nothing)
    #expect(RelativeLinkAnswer.nothing != RelativeLinkAnswer.stopped)
    #expect(RelativeLinkAnswer.opened(.gone) == RelativeLinkAnswer.opened(.gone))
}
