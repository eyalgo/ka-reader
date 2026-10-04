import XCTest

@testable import Surfaces

/// The Git words (CP-547, CP-553, CP-557, CP-559, CP-560). Every expected sentence is a string
/// literal here and never read from `GitSentences`: a test that reads the constant proves nothing
/// about the wording.
final class GitSentencesTests: XCTestCase {
    private let nonNormalStates = RepositoryState.allCases.filter { $0 != .normal }

    /// Every failure the catalogue words, with a path that holds no digit.
    private var everyFailure: [GitFailure] {
        [.gitDirectoryOutside(gitDirectory: "/elsewhere/.git/worktrees/wt")]
            + GitCondition.allCases.map { .condition($0) }
    }

    /// Every sentence the catalogue can put in front of a person, the switch labels, headings and
    /// letters apart.
    private var everySentence: [String] {
        [GitSentences.pending, GitSentences.clean, GitSentences.fault]
            + nonNormalStates.compactMap { GitSentences.statusSentence(for: $0) }
            + everyFailure.map { GitSentences.failure($0) }
    }

    func test_theCataloguedSentencesEqualContentMdLiterally() {
        XCTAssertEqual(GitSentences.pending, "Reading Git status.")
        XCTAssertEqual(GitSentences.clean, "Nothing has changed in this repository.")
        XCTAssertEqual(
            GitSentences.statusSentence(for: .rebase), "A rebase is in progress in this repository."
        )
        XCTAssertEqual(
            GitSentences.statusSentence(for: .am),
            "An am session is in progress in this repository.")
        XCTAssertEqual(
            GitSentences.statusSentence(for: .detachedHead), "HEAD is detached in this repository.")
    }

    func test_theFaultEqualsContentMd() {
        let fault =
            "Nozoki stopped while reading this repository's Git status and can't tell why. "
            + "The file tree is unaffected; the Git view shows the status again if Nozoki can read it."

        XCTAssertEqual(GitSentences.fault, fault)
    }

    func test_theFourSentencesTheContentStepWroteAreWholeSentencesInGitsWords() {
        XCTAssertEqual(
            GitSentences.statusSentence(for: .merge), "A merge is in progress in this repository.")
        XCTAssertEqual(
            GitSentences.statusSentence(for: .cherryPick),
            "A cherry-pick is in progress in this repository.")
        XCTAssertEqual(
            GitSentences.statusSentence(for: .revert),
            "A revert is in progress in this repository.")
        XCTAssertEqual(
            GitSentences.statusSentence(for: .bisect),
            "A bisect is in progress in this repository.")
    }

    func test_aNormalStateHasNoShortStatusSentence() {
        XCTAssertNil(GitSentences.statusSentence(for: .normal))
    }

    func test_theSevenNonNormalSentencesArePairwiseDistinctAndNeverTheCleanOne() {
        let sentences = nonNormalStates.compactMap { GitSentences.statusSentence(for: $0) }

        XCTAssertEqual(nonNormalStates.count, 7)
        XCTAssertEqual(sentences.count, 7)
        XCTAssertEqual(Set(sentences).count, 7)
        XCTAssertFalse(sentences.contains(GitSentences.clean))
    }

    func test_noSentenceHoldsAForbiddenWordOrADigit() {
        for sentence in everySentence {
            for word in ["paused", "stuck", "interrupted", "broken"] {
                XCTAssertFalse(sentence.localizedCaseInsensitiveContains(word), sentence)
            }
            XCTAssertNil(sentence.rangeOfCharacter(from: .decimalDigits), sentence)
        }
    }

    func test_theSixLettersAreAUMDCR() {
        let letters: [GitStatusCategory: String] = [
            .added: "A", .untracked: "U", .modified: "M", .deleted: "D", .inConflict: "C",
            .renamed: "R",
        ]

        XCTAssertEqual(letters.count, GitStatusCategory.allCases.count)
        for category in GitStatusCategory.allCases {
            XCTAssertEqual(GitSentences.letter(for: category), letters[category])
        }
    }

    func test_theSwitchLabelsAreFilesAndGitWithNoFullStop() {
        XCTAssertEqual(GitSentences.filesLabel, "Files")
        XCTAssertEqual(GitSentences.gitLabel, "Git")
    }

    func test_theHeadingsAreChangesAndStagedWithNoFullStop() {
        XCTAssertEqual(GitSentences.changesHeading, "Changes")
        XCTAssertEqual(GitSentences.stagedHeading, "Staged")
    }

    func test_noFailureSentenceNamesAWireNameOrAPath() {
        for condition in GitCondition.allCases {
            let sentence = GitSentences.failure(.condition(condition))

            XCTAssertFalse(sentence.contains(condition.rawValue), sentence)
            XCTAssertFalse(sentence.contains("/"), sentence)
            XCTAssertFalse(sentence.contains(".git"), sentence)
            XCTAssertFalse(sentence.contains("commondir"), sentence)
        }
    }

    func test_theOutsideSentenceHoldsTheAnsweredPathExactlyAsAnswered() {
        let path = "/elsewhere/.git/worktrees/wt"

        XCTAssertEqual(
            GitSentences.failure(.gitDirectoryOutside(gitDirectory: path)),
            "This repository's Git directory is at /elsewhere/.git/worktrees/wt, outside the "
                + "folder you opened, so Nozoki doesn't read its Git status. "
                + "The file tree and the reading panel are unaffected.")
    }

    func test_theTenConditionsTheContentStepClassedTakeTheirOwnSentenceOrTheFault() {
        let unreadable =
            "Nozoki can't read the Git directory in the folder you opened, so it can't show the "
            + "folder's Git status. The file tree and the reading panel are unaffected."
        let expected: [GitCondition: String] = [
            .probeFolderUnavailable:
                "Nozoki couldn't look in the folder you opened to find out whether it's a repository.",
            .probeGitDirectoryUnreadable: unreadable,
            .probeGitFileUnreadable: unreadable,
            .gitDirectoryUnreadable: unreadable,
            .probeGitEntryNotDirectory:
                "In the folder you opened, the Git directory is a link, or something that is "
                + "neither a file nor a folder, so Nozoki doesn't read the folder's Git status. "
                + "The file tree and the reading panel are unaffected.",
            .gitDirectoryMissing:
                "There's nothing where this repository's Git directory points, so Nozoki can't "
                + "read its Git status. The file tree and the reading panel are unaffected.",
            .notARepository:
                "Nozoki looked in the Git directory in the folder you opened and found no "
                + "repository there. The file tree and the reading panel are unaffected.",
            .probeRepositoryReadFailed: GitSentences.fault,
            .notARoot: GitSentences.fault,
            .repositoryReadFailed: GitSentences.fault,
            .machineConfigNotSwitchedOff: GitSentences.fault,
        ]

        XCTAssertEqual(expected.count, GitCondition.allCases.count)
        for condition in GitCondition.allCases {
            XCTAssertEqual(
                GitSentences.failure(.condition(condition)), expected[condition],
                condition.rawValue)
        }
    }

    func test_theUnexplainedFaultIsTheOneSentenceForEveryConditionWithNothingObserved() {
        let faults = GitCondition.allCases
            .filter { GitSentences.failure(.condition($0)) == GitSentences.fault }

        XCTAssertEqual(
            Set(faults),
            [
                .probeRepositoryReadFailed, .notARoot, .repositoryReadFailed,
                .machineConfigNotSwitchedOff,
            ])
    }
}
