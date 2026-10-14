import CoreFoundation
import Foundation
import XCTest

/// The two manifests the assembled bundle carries, read from the package as they are committed.
final class BundleManifestTests: XCTestCase {
    /// `ka-reader-mac/Tests/ShellTests/BundleManifestTests.swift` → `ka-reader-mac`, three levels up.
    private var packageDirectory: URL {
        URL(fileURLWithPath: #filePath)
            .deletingLastPathComponent()
            .deletingLastPathComponent()
            .deletingLastPathComponent()
    }

    private func plist(named name: String) throws -> [String: Any] {
        let data = try Data(contentsOf: packageDirectory.appendingPathComponent(name))
        let value = try PropertyListSerialization.propertyList(from: data, format: nil)
        return try XCTUnwrap(value as? [String: Any], "\(name) is a dictionary")
    }

    private func isBooleanTrue(_ value: Any) -> Bool {
        let object = value as CFTypeRef
        guard CFGetTypeID(object) == CFBooleanGetTypeID() else {
            return false
        }
        return CFBooleanGetValue(unsafeBitCast(object, to: CFBoolean.self))
    }

    func testInfoPlistIdentifiesTheBundle() throws {
        let info = try plist(named: "Info.plist")

        XCTAssertEqual(info["CFBundleIdentifier"] as? String, "com.kensaiapp.ka-reader")
        XCTAssertEqual(info["CFBundleExecutable"] as? String, "KAReader")
        XCTAssertEqual(info["LSMinimumSystemVersion"] as? String, "26.0")
    }

    func testInfoPlistNamesTheBundleTypeAndTheIcon() throws {
        let info = try plist(named: "Info.plist")

        XCTAssertEqual(info["CFBundlePackageType"] as? String, "APPL")
        XCTAssertEqual(info["CFBundleIconFile"] as? String, "icon.icns")
    }

    func testEntitlementsAreExactlyCR2sTwoKeysEachTrue() throws {
        let entitlements = try plist(named: "Entitlements.plist")

        XCTAssertEqual(
            Set(entitlements.keys),
            [
                "com.apple.security.app-sandbox",
                "com.apple.security.files.user-selected.read-only",
            ])
        for (key, value) in entitlements {
            XCTAssertTrue(isBooleanTrue(value), "\(key) is boolean true")
        }
    }

    func testEntitlementsCarryNoNetworkKey() throws {
        let keys = try plist(named: "Entitlements.plist").keys

        XCTAssertFalse(keys.contains { $0.contains("network") }, "no network key")
        XCTAssertFalse(keys.contains { $0.contains("mach-lookup") }, "no mach-lookup exception")
        XCTAssertFalse(
            keys.contains { $0.contains("files.bookmarks.app-scope") }, "no app-scoped bookmarks")
    }
}
