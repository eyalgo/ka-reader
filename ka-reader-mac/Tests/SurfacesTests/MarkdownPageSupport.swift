import AppKit
import Foundation
import Surfaces
import Testing

/// What the rendered-page tests share: a page laid out at a size, documents built by hand, a PNG the
/// test renders itself, and a reader for the page's text storage. The storage is read as the page
/// built it, node by node.

@MainActor
func makePage(_ document: MarkdownDocument, imageBytes: [String: Data] = [:]) -> MarkdownPageView {
    let page = MarkdownPageView()
    page.frame = NSRect(x: 0, y: 0, width: 600, height: 400)
    page.show(document, imageBytes: imageBytes)
    page.layoutSubtreeIfNeeded()
    return page
}

func document(_ blocks: [MarkdownBlock]) -> MarkdownDocument {
    MarkdownDocument(blocks: blocks)
}

func paragraph(_ text: String) -> MarkdownBlock {
    .paragraph([.text(text)])
}

/// A PNG of the given pixel size that the test renders itself.
func renderedPNG(width: Int, height: Int) throws -> Data {
    let bitmap = try #require(
        NSBitmapImageRep(
            bitmapDataPlanes: nil, pixelsWide: width, pixelsHigh: height, bitsPerSample: 8,
            samplesPerPixel: 4, hasAlpha: true, isPlanar: false, colorSpaceName: .deviceRGB,
            bytesPerRow: 0, bitsPerPixel: 0))
    return try #require(bitmap.representation(using: .png, properties: [:]))
}

/// The bytes of one of the four malformed fixtures, read relative to this file.
func malformedFixture(_ name: String, filePath: String = #filePath) throws -> Data {
    let root = URL(fileURLWithPath: filePath)
        .deletingLastPathComponent().deletingLastPathComponent()
        .deletingLastPathComponent().deletingLastPathComponent()
    return try Data(
        contentsOf: root.appendingPathComponent("checks/fixtures/malformed-images/\(name)"))
}

let malformedFixtureNames = ["malformed.png", "malformed.jpg", "malformed.gif", "malformed.webp"]

extension MarkdownPageView {
    var storage: NSTextStorage {
        get throws { try #require(textView.textStorage) }
    }

    /// The paragraphs of the page's text, in order, without their line breaks.
    var paragraphs: [String] {
        textView.string.components(separatedBy: "\n")
    }

    /// Every attachment on the page, with the character index it stands at.
    func attachments() throws -> [(index: Int, attachment: NSTextAttachment)] {
        var found: [(Int, NSTextAttachment)] = []
        let storage = try storage
        storage.enumerateAttribute(.attachment, in: NSRange(location: 0, length: storage.length)) {
            value, range, _ in
            if let attachment = value as? NSTextAttachment { found.append((range.location, attachment)) }
        }
        return found
    }

    /// The paragraphs that sit in a text block (the placeholder box), grouped one box per run.
    func boxes() throws -> [[String]] {
        let storage = try storage
        let text = storage.string as NSString
        var boxes: [[String]] = []
        var current: [String] = []
        var location = 0
        while location < text.length {
            let range = text.paragraphRange(for: NSRange(location: location, length: 0))
            let style = storage.attribute(.paragraphStyle, at: range.location, effectiveRange: nil)
                as? NSParagraphStyle
            if style?.textBlocks.isEmpty == false {
                current.append(
                    text.substring(with: range).trimmingCharacters(in: .newlines))
            } else if !current.isEmpty {
                boxes.append(current)
                current = []
            }
            location = NSMaxRange(range)
        }
        if !current.isEmpty { boxes.append(current) }
        return boxes
    }

    /// The range of `needle` in the page's text.
    func range(of needle: String) throws -> NSRange {
        let found = (textView.string as NSString).range(of: needle)
        try #require(found.location != NSNotFound, "\(needle) is on the page")
        return found
    }

    /// The attribute at the first character of `needle`.
    func attribute(_ key: NSAttributedString.Key, at needle: String) throws -> Any? {
        try storage.attribute(key, at: try range(of: needle).location, effectiveRange: nil)
    }

    /// The foreground colour at the first character of `needle`, resolved in the light appearance.
    func ink(at needle: String) throws -> NSColor? {
        let color = try attribute(.foregroundColor, at: needle) as? NSColor
        return resolved(color)
    }
}

/// A dynamic colour resolved to its light value, so two can be compared.
@MainActor
func resolved(_ color: NSColor?) -> NSColor? {
    var result: NSColor?
    NSAppearance(named: .aqua)?.performAsCurrentDrawingAppearance {
        result = color?.usingColorSpace(.sRGB)
    }
    return result
}
