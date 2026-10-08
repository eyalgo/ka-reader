import AppKit
import XCTest

final class GlyphDecodeTests: XCTestCase {
    /// `ka-reader-mac/Tests/ShellTests/GlyphDecodeTests.swift` → the repository root, four levels up.
    private var repositoryRoot: URL {
        URL(fileURLWithPath: #filePath)
            .deletingLastPathComponent()
            .deletingLastPathComponent()
            .deletingLastPathComponent()
            .deletingLastPathComponent()
    }

    /// The tree's three glyphs and the status messages' two (`docs/DESIGN.md` § Components "Status
    /// messages"): each vendored file the bundle hands the shell decodes to an image.
    func testVendoredFolderAndFileGlyphsDecode() throws {
        for name in ["folder", "file", "file-code", "info", "circle-alert"] {
            let source =
                repositoryRoot
                .appendingPathComponent("third_party/lucide/icons/\(name).svg")

            let image = try XCTUnwrap(NSImage(contentsOf: source), "\(name).svg did not decode")

            XCTAssertGreaterThan(image.size.width, 0, name)
            XCTAssertGreaterThan(image.size.height, 0, name)
        }
    }
}
