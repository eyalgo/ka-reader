import AppKit
import Foundation
import Surfaces
import Testing

/// Links on the rendered page (CP-1114 – CP-1117): every link reads its own content followed by its
/// destination in parentheses, an external one is text and nothing more, and a relative one raises its
/// target path (never its destination) through the page's sink.

@MainActor
private func linkValues(in page: MarkdownPageView) throws -> [Any] {
    let storage = try page.storage
    var found: [Any] = []
    unsafe storage.enumerateAttribute(.link, in: NSRange(location: 0, length: storage.length)) {
        value, _, _ in
        if let value { found.append(value) }
    }
    return found
}

/// What the page draws for a link's destination, for a kind of target.
@MainActor
private func linkDocument(_ target: MarkdownLinkTarget, destination: String) -> MarkdownDocument {
    pageDocument([.paragraph([.link([.text("guide")], destination: destination, target)])])
}

@MainActor
@Test
func anExternalLinkReadsContentThenItsDestinationOnOneLineWithNoLinkAttribute() throws {
    var raised: [String] = []
    let page = makePage(linkDocument(.external, destination: "https://example.com"))
    page.relativeLinkSink = { raised.append($0) }

    #expect(page.textView.string == "guide (https://example.com)")
    #expect(try linkValues(in: page).isEmpty)
    let delegate = try #require(page.textView.delegate)
    let handled = delegate.textView?(page.textView, clickedOnLink: "https://example.com", at: 0)
    #expect(handled == true)
    #expect(raised.isEmpty)
}

@MainActor
@Test
func aRelativeLinkRaisesItsTargetPathNotItsDestination() throws {
    var raised: [String] = []
    let page = makePage(
        linkDocument(.relative(path: "docs/guide.md"), destination: "./docs/guide.md"))
    page.relativeLinkSink = { raised.append($0) }

    let values = try linkValues(in: page)
    #expect(values.count == 1)
    for value in values {
        #expect(!(value is URL))
        #expect(String(describing: value) != "./docs/guide.md")
        #expect(String(describing: value) != "docs/guide.md")
    }
    let token = try #require(values.first)
    let delegate = try #require(page.textView.delegate)
    let handled = delegate.textView?(page.textView, clickedOnLink: token, at: 0)

    #expect(handled == true)
    #expect(raised == ["docs/guide.md"])
    #expect(page.textView.linkTextAttributes?.isEmpty ?? true)
}

@MainActor
@Test
func aRelativeAndAnExternalLinkWithTheSameContentAndDestinationLookTheSame() throws {
    let relative = makePage(linkDocument(.relative(path: "x.md"), destination: "same"))
    let external = makePage(linkDocument(.external, destination: "same"))

    #expect(relative.textView.string == external.textView.string)
    let keys: [NSAttributedString.Key] = [
        .font, .foregroundColor, .underlineStyle, .underlineColor,
    ]
    for needle in ["guide", "(same)"] {
        for key in keys {
            let one = try relative.attribute(key, at: needle)
            let other = try external.attribute(key, at: needle)
            #expect(String(describing: one) == String(describing: other), "\(needle) \(key)")
        }
    }
    #expect(try relative.attribute(.underlineStyle, at: "guide") != nil)
}

@MainActor
@Test
func aRelativeLinkToAFolderIsStillAControl() throws {
    var raised: [String] = []
    let page = makePage(linkDocument(.relative(path: "src"), destination: "src"))
    page.relativeLinkSink = { raised.append($0) }

    let token = try #require(try linkValues(in: page).first)
    let delegate = try #require(page.textView.delegate)
    _ = delegate.textView?(page.textView, clickedOnLink: token, at: 0)

    #expect(raised == ["src"])
}
