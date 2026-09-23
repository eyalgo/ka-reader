import AppKit
import XCTest

@testable import Surfaces

@MainActor
final class RootItemsViewTests: XCTestCase {
    private let folderGlyph = NSImage(size: NSSize(width: 1, height: 1))
    private let fileGlyph = NSImage(size: NSSize(width: 2, height: 2))

    private func makeView(showing entries: [Entry]) -> RootItemsView {
        let view = RootItemsView(folderGlyph: folderGlyph, fileGlyph: fileGlyph)
        view.show(entries)
        return view
    }

    private func cell(_ view: RootItemsView, row: Int) throws -> NSTableCellView {
        let made = view.outlineView.view(atColumn: 0, row: row, makeIfNecessary: true)
        return try XCTUnwrap(made as? NSTableCellView)
    }

    func testRowsEqualEntriesInCountAndOrder() throws {
        let entries = [
            Entry(name: "docs", path: "docs", kind: .folder),
            Entry(name: "README.md", path: "README.md", kind: .file),
            Entry(name: "src", path: "src", kind: .folder),
        ]
        let view = makeView(showing: entries)

        XCTAssertEqual(view.outlineView.numberOfRows, entries.count)
        for (index, entry) in entries.enumerated() {
            XCTAssertEqual(try cell(view, row: index).textField?.stringValue, entry.name)
        }
    }

    func testEmptyListingDrawsNoRow() {
        XCTAssertEqual(makeView(showing: []).outlineView.numberOfRows, 0)
    }

    func testDotNamedEntryIsKept() throws {
        let view = makeView(showing: [Entry(name: ".hidden-note", path: ".hidden-note", kind: .file)])

        XCTAssertEqual(view.outlineView.numberOfRows, 1)
        XCTAssertEqual(try cell(view, row: 0).textField?.stringValue, ".hidden-note")
    }

    func testNestedEntryIsLabelledByNameNotPath() throws {
        let view = makeView(showing: [Entry(name: "guides", path: "docs/guides", kind: .folder)])

        XCTAssertEqual(try cell(view, row: 0).textField?.stringValue, "guides")
    }

    func testFolderKindDrawsFolderGlyph() throws {
        let view = makeView(showing: [Entry(name: "docs", path: "docs", kind: .folder)])

        XCTAssertTrue(try cell(view, row: 0).imageView?.image === folderGlyph)
    }

    func testFileAndSymlinkKindsDrawFileGlyph() throws {
        let view = makeView(showing: [
            Entry(name: "a.txt", path: "a.txt", kind: .file),
            Entry(name: "link", path: "link", kind: .symlink),
        ])

        XCTAssertTrue(try cell(view, row: 0).imageView?.image === fileGlyph)
        XCTAssertTrue(try cell(view, row: 1).imageView?.image === fileGlyph)
    }

    func testRowsAreNotReordered() throws {
        let names = ["zebra", "apple", "mango"]
        let view = makeView(showing: names.map { Entry(name: $0, path: $0, kind: .file) })

        for (index, name) in names.enumerated() {
            XCTAssertEqual(try cell(view, row: index).textField?.stringValue, name)
        }
    }

    func testKindDecodesFromTheThreeWireStrings() throws {
        let wire = #"[{"name":"a","path":"a","kind":"folder"},"#
            + #"{"name":"b","path":"b","kind":"file"},"#
            + #"{"name":"c","path":"c","kind":"symlink"}]"#

        let entries = try JSONDecoder().decode([Entry].self, from: Data(wire.utf8))

        XCTAssertEqual(entries.map(\.kind), [.folder, .file, .symlink])
    }

    func testUnknownKindFailsToDecode() {
        let wire = #"[{"name":"a","path":"a","kind":"socket"}]"#

        XCTAssertThrowsError(try JSONDecoder().decode([Entry].self, from: Data(wire.utf8)))
    }
}
