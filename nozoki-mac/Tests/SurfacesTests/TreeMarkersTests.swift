import XCTest

@testable import Surfaces

/// The join of a Git item onto the tree's row paths (CP-573, CP-574, CP-577, CP-579).
final class TreeMarkersTests: XCTestCase {
    private func entry(_ path: String, _ category: GitStatusCategory) -> GitEntry {
        GitEntry(path: path, category: category)
    }

    private func repository(
        changed: [GitEntry] = [], staged: [GitEntry] = []
    ) -> TreeMarkers {
        TreeMarkers(
            .repository(
                GitRepository(
                    branch: .named("main"), state: .normal, staged: staged, changed: changed)
            ))
    }

    func test_noRepositoryAnswerMarksNoRow() {
        let items: [GitItem] = [
            .pending,
            .plain,
            .failed(.gitDirectoryOutside(gitDirectory: "/elsewhere/.git/worktrees/wt")),
            .failed(.condition(.repositoryReadFailed)),
            .stopped,
        ]
        let paths = ["b.txt", "sub", "inner", "src/c.txt", ""]
        for item in items {
            let markers = TreeMarkers(item)
            for path in paths {
                XCTAssertNil(markers.category(forRowPath: path), "\(item) marks \(path)")
            }
        }
        for path in paths {
            XCTAssertNil(TreeMarkers.none.category(forRowPath: path))
        }
    }

    func test_aRepositoryAnswerWithEmptyListsMarksNoRow() {
        let markers = repository()
        for path in ["b.txt", "sub", "src/c.txt", "inner/"] {
            XCTAssertNil(markers.category(forRowPath: path))
        }
    }

    func test_theFirstExampleJoinsEachListedPathToOneCategory() {
        let markers = repository(
            changed: [
                entry("b.txt", .modified), entry("d.txt", .untracked), entry("new.txt", .modified),
                entry("newdir/x.txt", .untracked),
            ],
            staged: [
                entry("d.txt", .deleted), entry("moved.txt", .renamed), entry("new.txt", .added),
                entry("src/c.txt", .modified),
            ])

        XCTAssertEqual(markers.category(forRowPath: "b.txt"), .modified)
        XCTAssertEqual(markers.category(forRowPath: "d.txt"), .untracked)
        XCTAssertEqual(markers.category(forRowPath: "moved.txt"), .renamed)
        XCTAssertEqual(markers.category(forRowPath: "new.txt"), .modified)
        XCTAssertEqual(markers.category(forRowPath: "src/c.txt"), .modified)
        XCTAssertEqual(markers.category(forRowPath: "newdir/x.txt"), .untracked)
        XCTAssertNil(markers.category(forRowPath: "src"))
        XCTAssertNil(markers.category(forRowPath: "newdir"))
    }

    func test_aListedFolderPathMarksItsRowAndNothingBeneathIt() {
        let submodule = repository(changed: [entry("sub", .modified)])
        XCTAssertEqual(submodule.category(forRowPath: "sub"), .modified)

        let nested = repository(changed: [entry("inner/", .untracked)])
        XCTAssertEqual(nested.category(forRowPath: "inner"), .untracked)
        XCTAssertNil(nested.category(forRowPath: "inner/i.txt"))
        XCTAssertNil(nested.category(forRowPath: "inner/.git"))
    }

    func test_onlyOneTrailingSlashIsDropped() {
        let markers = repository(changed: [entry("inner//", .untracked)])
        XCTAssertNil(markers.category(forRowPath: "inner"))
    }

    func test_aListedPathMarksTheRowWhateverItsKind() {
        let markers = repository(changed: [entry("sub", .modified), entry("readme", .added)])
        XCTAssertEqual(markers.category(forRowPath: "sub"), .modified)
        XCTAssertEqual(markers.category(forRowPath: "readme"), .added)
    }

    func test_spellingIsExactIncludingCase() {
        let markers = repository(changed: [entry("readme.md", .modified), entry("A.txt", .deleted)])
        XCTAssertNil(markers.category(forRowPath: "README.md"))
        XCTAssertNil(markers.category(forRowPath: "a.txt"))
        XCTAssertEqual(markers.category(forRowPath: "readme.md"), .modified)
    }

    func test_spellingIsExactIncludingUnicodeNormalization() {
        let precomposed = "caf\u{E9}.txt"
        let decomposed = "cafe\u{301}.txt"

        let listedPrecomposed = repository(changed: [entry(precomposed, .modified)])
        XCTAssertEqual(listedPrecomposed.category(forRowPath: precomposed), .modified)
        XCTAssertNil(listedPrecomposed.category(forRowPath: decomposed))

        let listedDecomposed = repository(changed: [entry(decomposed, .modified)])
        XCTAssertEqual(listedDecomposed.category(forRowPath: decomposed), .modified)
        XCTAssertNil(listedDecomposed.category(forRowPath: precomposed))
    }

    func test_anExactEntryBeatsATrailingSlashEntryInOneList() {
        let slashFirst = repository(changed: [
            entry("inner/", .untracked), entry("inner", .modified),
        ])
        XCTAssertEqual(slashFirst.category(forRowPath: "inner"), .modified)

        let exactFirst = repository(changed: [
            entry("inner", .modified), entry("inner/", .untracked),
        ])
        XCTAssertEqual(exactFirst.category(forRowPath: "inner"), .modified)
    }

    func test_ofTwoExactEntriesInOneListTheEarlierWins() {
        let markers = repository(changed: [entry("a.txt", .added), entry("a.txt", .deleted)])
        XCTAssertEqual(markers.category(forRowPath: "a.txt"), .added)
    }
}
