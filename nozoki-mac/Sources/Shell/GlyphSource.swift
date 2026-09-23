import AppKit

/// Where the shell's two glyph images come from. A seam, because `Bundle.main` in a test run is
/// the test runner's.
public protocol GlyphSource {
    func glyph(named name: String) -> NSImage?
}

/// The glyphs the assembled bundle carries in `Contents/Resources`, found through `Bundle`'s image
/// lookup. C-R7 admits `Bundle.main` reads inside `Contents/Resources` and forbids reading a
/// file's bytes any other way, whatever the file is (CP-98).
public struct BundleGlyphSource: GlyphSource {
    public init() {}

    public func glyph(named name: String) -> NSImage? {
        Bundle.main.image(forResource: NSImage.Name(name))
    }
}
