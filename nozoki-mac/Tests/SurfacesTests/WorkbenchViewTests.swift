import AppKit
import XCTest

@testable import Surfaces

@MainActor
final class WorkbenchViewTests: XCTestCase {
    func testWorkbenchHostsTheRealRootItemsViewInTheFilesSidebar() {
        let root = RootItemsView(folderGlyph: NSImage(), fileGlyph: NSImage())
        let workbench = WorkbenchView(rootItemsView: root)

        XCTAssertTrue(workbench.filesSidebar.documentView === root)
    }

    func testEmptyReadingPaneDrawsOnlySelectAFileToView() {
        let root = RootItemsView(folderGlyph: NSImage(), fileGlyph: NSImage())
        let workbench = WorkbenchView(rootItemsView: root)

        XCTAssertEqual(workbench.readingText, "Select a file to view.")
    }
}
