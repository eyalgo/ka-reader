import AppKit
import XCTest

final class GlyphDecodeTests: XCTestCase {
    /// `nozoki-mac/Tests/ShellTests/GlyphDecodeTests.swift` → the repository root, four levels up.
    private var repositoryRoot: URL {
        URL(fileURLWithPath: #filePath)
            .deletingLastPathComponent()
            .deletingLastPathComponent()
            .deletingLastPathComponent()
            .deletingLastPathComponent()
    }

    func testVendoredFolderAndFileGlyphsDecode() throws {
        for name in ["folder", "file"] {
            let source =
                repositoryRoot
                .appendingPathComponent("third_party/lucide/icons/\(name).svg")

            let image = try XCTUnwrap(NSImage(contentsOf: source), "\(name).svg did not decode")

            XCTAssertGreaterThan(image.size.width, 0, name)
            XCTAssertGreaterThan(image.size.height, 0, name)
        }
    }
}
