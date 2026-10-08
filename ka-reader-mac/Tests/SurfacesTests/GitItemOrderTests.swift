import XCTest

@testable import Surfaces

/// The order of a Git list's rows (CP-558): the path each row shows, lowercased and compared by
/// Unicode scalar value, then by the original's UTF-8 bytes, with no normalization.
final class GitItemOrderTests: XCTestCase {
    private func entries(_ paths: [String]) -> [GitEntry] {
        paths.map { GitEntry(path: $0, category: .modified) }
    }

    private func orderedPaths(_ paths: [String]) -> [String] {
        GitRowOrder.ordered(entries(paths)).map(\.path)
    }

    func test_orderIgnoresCaseAndComparesDigitsAsCharacters() {
        XCTAssertEqual(orderedPaths(["file2", "File1", "file10"]), ["File1", "file10", "file2"])
    }

    func test_twoPathsEqualWithoutCaseKeepByteOrder() {
        XCTAssertEqual(orderedPaths(["Readme", "README"]), ["README", "Readme"])
        XCTAssertEqual(orderedPaths(["README", "Readme"]), ["README", "Readme"])
    }

    func test_canonicallyEquivalentPathsAreNotMerged() {
        let precomposed = "caf\u{E9}.txt"
        let decomposed = "cafe\u{301}.txt"

        let forward = orderedPaths([precomposed, decomposed])
        let backward = orderedPaths([decomposed, precomposed])

        // Swift's `==` calls the two equal, so compare by bytes.
        XCTAssertEqual(
            forward.map { Array($0.utf8) }, [decomposed, precomposed].map { Array($0.utf8) })
        XCTAssertEqual(backward.map { Array($0.utf8) }, forward.map { Array($0.utf8) })
    }

    func test_theSixCategoryExampleOrdersAsSpecified() {
        let staged = [
            GitEntry(path: "src/new.txt", category: .added),
            GitEntry(path: "READ.md", category: .renamed),
        ]
        let changed = [
            GitEntry(path: "b.txt", category: .modified),
            GitEntry(path: "A.txt", category: .deleted),
            GitEntry(path: "tmp.log", category: .untracked),
            GitEntry(path: "c.txt", category: .inConflict),
        ]

        XCTAssertEqual(GitRowOrder.ordered(staged).map(\.path), ["READ.md", "src/new.txt"])
        XCTAssertEqual(
            GitRowOrder.ordered(changed).map(\.path), ["A.txt", "b.txt", "c.txt", "tmp.log"])
    }

    func test_theInputOrderDoesNotChangeTheOutput() {
        let paths = ["file2", "File1", "file10", "File2", "a/b", "A"]
        let expected = orderedPaths(paths)

        for rotation in 0..<paths.count {
            let rotated = Array(paths[rotation...] + paths[..<rotation])
            XCTAssertEqual(orderedPaths(rotated), expected)
            XCTAssertEqual(orderedPaths(rotated.reversed()), expected)
        }
    }

    func test_anEmptyListOrdersToAnEmptyList() {
        XCTAssertEqual(GitRowOrder.ordered([]), [])
    }

    func test_aSingleEntryOrdersToItself() {
        let only = GitEntry(path: "only.txt", category: .added)

        XCTAssertEqual(GitRowOrder.ordered([only]), [only])
    }
}
