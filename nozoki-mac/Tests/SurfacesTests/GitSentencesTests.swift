import XCTest

@testable import Surfaces

/// The Git words (CP-547, CP-553, CP-557, CP-559, CP-560). Every expected sentence is a string
/// literal here and never read from `GitSentences`: a test that reads the constant proves nothing
/// about the wording.
final class GitSentencesTests: XCTestCase {
    private let nonNormalStates = RepositoryState.allCases.filter { $0 != .normal }

    /// Every failure the catalogue words, with a path that holds no digit.
    private var everyFailure: [GitFailure] {
        [
            .gitDirectoryOutside(gitDirectory: "/elsewhere/.git/worktrees/wt"),
            .configNamesOutside(key: "include.path", path: "../../outside.config"),
            .configNotLocated(key: "include.path", path: "~/x.config"),
            .objectStoreNamesOutside(path: "../../../elsewhere/objects"),
            .objectStoreNotLocated(path: "relative/objects"),
            .submoduleElsewhere(name: "submodule", path: "evil"),
        ] + GitCondition.allCases.map { .condition($0) }
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
            .gitmodulesUnreadable: gitmodulesUnreadableMessage,
        ]

        XCTAssertEqual(expected.count, GitCondition.allCases.count)
        for condition in GitCondition.allCases {
            XCTAssertEqual(
                GitSentences.failure(.condition(condition)), expected[condition],
                condition.rawValue)
        }
    }

    /// `change_text.md`'s string for a repository config that names a path outside the folder: the
    /// key and the path, each unchanged and unquoted, between the words around them.
    private func configSentence(key: String, path: String) -> String {
        "Nozoki found \(key) set to \(path), outside the folder you opened, so it doesn't read the "
            + "folder's Git status. The file tree and the reading panel are unaffected."
    }

    func test_theConfigNamesOutsideCaseDrawsChangeTextsSentenceCharacterForCharacter() {
        XCTAssertEqual(
            GitSentences.failure(
                .configNamesOutside(key: "core.excludesfile", path: "/Users/you/shared/ignore")),
            "Nozoki found core.excludesfile set to /Users/you/shared/ignore, outside the folder you "
                + "opened, so it doesn't read the folder's Git status. "
                + "The file tree and the reading panel are unaffected.")
    }

    func test_theConfigSentencePlacesTheKeyAndThePathUnchangedAndUnquoted() {
        let cases = [
            (key: "include.path", path: "../../outside.config"),
            (key: "includeIf.gitdir:~/work/.path", path: "~/.gitignore_global"),
            (key: "core.attributesfile", path: "/Users/you/shared/attributes"),
            (key: "core.worktree", path: "/elsewhere/\u{FFFD}/tree"),
        ]

        for (key, path) in cases {
            let sentence = GitSentences.failure(.configNamesOutside(key: key, path: path))

            XCTAssertEqual(sentence, configSentence(key: key, path: path), key)
            XCTAssertFalse(sentence.contains("\"\(key)\""), sentence)
            XCTAssertFalse(sentence.contains("\"\(path)\""), sentence)
            let wordsAround =
                sentence.replacingOccurrences(of: key, with: "")
                .replacingOccurrences(of: path, with: "")
            XCTAssertFalse(wordsAround.localizedCaseInsensitiveContains("config"), sentence)
        }
    }

    /// `change_text.md`'s message for a config key set to a value Nozoki does not locate: the key
    /// and the path, each unchanged and unquoted, between the words around them.
    private func notLocatedMessage(key: String, path: String) -> String {
        "Nozoki found \(key) set to \(path) and doesn't work out where that path leads, so it "
            + "doesn't read the folder's Git status. "
            + "The file tree and the reading panel are unaffected."
    }

    func test_theConfigNotLocatedCaseDrawsChangeTextsMessageCharacterForCharacter() {
        let cases = [
            (key: "include.path", path: "~/x.config"),
            (key: "core.excludesfile", path: "ignore-rel"),
            (key: "core.attributesfile", path: "/x"),
        ]

        for (key, path) in cases {
            let message = GitSentences.failure(.configNotLocated(key: key, path: path))

            XCTAssertEqual(message, notLocatedMessage(key: key, path: path), key)
            XCTAssertFalse(message.contains("\"\(key)\""), message)
            XCTAssertFalse(message.contains("\"\(path)\""), message)
        }
        XCTAssertEqual(
            GitSentences.failure(.configNotLocated(key: "core.excludesfile", path: "ignore-rel")),
            "Nozoki found core.excludesfile set to ignore-rel and doesn't work out where that "
                + "path leads, so it doesn't read the folder's Git status. "
                + "The file tree and the reading panel are unaffected.")
    }

    func test_theConfigNotLocatedMessageNeverSaysOutsideOrAForbiddenWord() {
        let message = GitSentences.failure(.configNotLocated(key: "include.path", path: "a"))
        let forbidden = [
            "outside", "invalid", "unsupported", "illegal", "malformed", "refused", "!",
        ]

        for word in forbidden {
            XCTAssertFalse(message.localizedCaseInsensitiveContains(word), "\(word): \(message)")
        }
    }

    func test_theNotLocatedMessageDiffersFromEveryOtherFailureSentenceAndTheFault() {
        let message = GitSentences.failure(.configNotLocated(key: "include.path", path: "a"))
        let others =
            [
                GitFailure.gitDirectoryOutside(gitDirectory: "a"),
                .configNamesOutside(key: "include.path", path: "a"),
                .objectStoreNamesOutside(path: "a"),
                .objectStoreNotLocated(path: "a"),
            ] + GitCondition.allCases.map { GitFailure.condition($0) }

        XCTAssertNotEqual(message, GitSentences.fault)
        XCTAssertNotEqual(message, GitSentences.pending)
        for other in others {
            XCTAssertNotEqual(message, GitSentences.failure(other))
        }
    }

    func test_theConfigSentenceIsNeitherTheFaultNorAnyOtherFailureSentence() {
        let config = GitSentences.failure(.configNamesOutside(key: "include.path", path: "a"))
        let others =
            [GitFailure.gitDirectoryOutside(gitDirectory: "a")]
            + GitCondition.allCases.map { GitFailure.condition($0) }

        XCTAssertNotEqual(config, GitSentences.fault)
        for other in others {
            XCTAssertNotEqual(config, GitSentences.failure(other))
        }
    }

    /// `change_text.md`'s string for an object store that names a location outside the folder: the
    /// value, unchanged and unquoted, between the words around it.
    private func alternatesSentence(path: String) -> String {
        "Nozoki found a Git object store that names \(path), outside the folder you opened, so "
            + "Nozoki doesn't read the folder's Git status. "
            + "The file tree and the reading panel are unaffected."
    }

    func test_theAlternatesFailureReadsAsChangeTextWritesIt() {
        XCTAssertEqual(
            GitSentences.failure(.objectStoreNamesOutside(path: "/Users/you/src/app/.git/objects")),
            "Nozoki found a Git object store that names /Users/you/src/app/.git/objects, outside "
                + "the folder you opened, so Nozoki doesn't read the folder's Git status. "
                + "The file tree and the reading panel are unaffected.")

        for path in [
            "/Users/you/src/app/.git/objects", "../../../elsewhere/objects", "relative/objects",
        ] {
            let sentence = GitSentences.failure(.objectStoreNamesOutside(path: path))

            XCTAssertEqual(sentence, alternatesSentence(path: path), path)
            XCTAssertFalse(sentence.contains("\"\(path)\""), sentence)
            XCTAssertFalse(sentence.contains("'\(path)'"), sentence)
        }
    }

    func test_theAlternatesSentenceIsDistinctFromEveryOtherFailureSentence() {
        let alternates = GitSentences.failure(.objectStoreNamesOutside(path: "a"))
        let others =
            [
                GitFailure.gitDirectoryOutside(gitDirectory: "a"),
                .configNamesOutside(key: "include.path", path: "a"),
                .configNotLocated(key: "include.path", path: "a"),
                .objectStoreNotLocated(path: "a"),
            ] + GitCondition.allCases.map { GitFailure.condition($0) }

        XCTAssertNotEqual(alternates, GitSentences.fault)
        for other in others {
            XCTAssertNotEqual(alternates, GitSentences.failure(other))
        }
    }

    /// `change_text.md`'s message for an alternates entry the reader does not locate: the entry,
    /// unchanged and unquoted, between the words around it. Three sentences, because a joined clause
    /// would make the object store the subject of "doesn't work out".
    private func objectStoreNotLocatedMessage(path: String) -> String {
        "Nozoki found a Git object store that names \(path). "
            + "Nozoki doesn't work out where that path leads, so it doesn't read the folder's "
            + "Git status. The file tree and the reading panel are unaffected."
    }

    func test_theObjectStoreNotLocatedMessageReadsAsChangeTextWritesIt() {
        XCTAssertEqual(
            GitSentences.failure(.objectStoreNotLocated(path: "relative/objects")),
            "Nozoki found a Git object store that names relative/objects. "
                + "Nozoki doesn't work out where that path leads, so it doesn't read the "
                + "folder's Git status. The file tree and the reading panel are unaffected.")

        // A value beginning `/` still draws this message (CP-707): the case, not the path, decides.
        for path in ["relative/objects", " /abs/objects", "~/objects", "/x"] {
            let message = GitSentences.failure(.objectStoreNotLocated(path: path))

            XCTAssertEqual(message, objectStoreNotLocatedMessage(path: path), path)
            XCTAssertFalse(message.contains("\"\(path)\""), message)
            XCTAssertFalse(message.contains("'\(path)'"), message)
        }
    }

    func test_theObjectStoreNotLocatedMessageNeverSaysOutsideOrAForbiddenWord() {
        let message = GitSentences.failure(.objectStoreNotLocated(path: "a"))
        let forbidden = [
            "outside", "invalid", "unsupported", "illegal", "malformed", "refused", "!",
        ]

        for word in forbidden {
            XCTAssertFalse(message.localizedCaseInsensitiveContains(word), "\(word): \(message)")
        }
    }

    func test_theObjectStoreNotLocatedMessageDiffersFromEveryOtherSentence() {
        let message = GitSentences.failure(.objectStoreNotLocated(path: "a"))
        let others =
            [
                GitFailure.gitDirectoryOutside(gitDirectory: "a"),
                .configNamesOutside(key: "include.path", path: "a"),
                .configNotLocated(key: "include.path", path: "a"),
                .objectStoreNamesOutside(path: "a"),
            ] + GitCondition.allCases.map { GitFailure.condition($0) }

        XCTAssertNotEqual(message, GitSentences.fault)
        XCTAssertNotEqual(message, GitSentences.pending)
        XCTAssertNotEqual(message, GitSentences.clean)
        for other in others {
            XCTAssertNotEqual(message, GitSentences.failure(other))
        }
    }

    // MARK: The `.gitmodules` messages (CP-721, CP-729, CP-730, CP-733)

    /// `change_text.md`'s message for a section whose path leads somewhere else: the name and the
    /// path, each unchanged and unquoted, between the words around them.
    private func submoduleElsewhereMessage(name: String, path: String) -> String {
        "Nozoki found that a .gitmodules gives the submodule at \(name) the path \(path), which "
            + "leads somewhere else, so it doesn't read the folder's Git status. "
            + "The file tree and the reading panel are unaffected."
    }

    /// `change_text.md`'s message for a `.gitmodules` Nozoki couldn't read. It names no file.
    private let gitmodulesUnreadableMessage =
        "Nozoki couldn't read how a repository in the folder you opened names and places its "
        + "submodules, so it doesn't read the folder's Git status. "
        + "The file tree and the reading panel are unaffected."

    private let forbiddenInTheGitmodulesMessages = [
        "outside", "invalid", "unsupported", "illegal", "malformed", "refused", "!",
        "repo ", "symlink", "config", "settings", "error", "failed",
    ]

    func test_configSentencesCarryASubmodulePathKeyAndPathCharacterForCharacter() {
        for path in ["../outside-x", "/abs/x"] {
            XCTAssertEqual(
                GitSentences.failure(.configNamesOutside(key: "submodule.x.path", path: path)),
                configSentence(key: "submodule.x.path", path: path), path)
            XCTAssertEqual(
                GitSentences.failure(.configNotLocated(key: "submodule.x.path", path: path)),
                notLocatedMessage(key: "submodule.x.path", path: path), path)
        }
    }

    func test_submoduleElsewhereMessageIsChangeTextsWithNameAndPathUnquotedAndUnchanged() {
        XCTAssertEqual(
            GitSentences.failure(.submoduleElsewhere(name: "submodule", path: "evil")),
            "Nozoki found that a .gitmodules gives the submodule at submodule the path evil, "
                + "which leads somewhere else, so it doesn't read the folder's Git status. "
                + "The file tree and the reading panel are unaffected.")

        let cases = [
            (name: "submodule", path: "evil"), (name: "vendor/lib", path: "nothing-here"),
            (name: "x", path: "~/lib"), (name: "Sub", path: "sub"),
            (name: "\u{FFFD}", path: "a/\u{FFFD}"),
        ]
        for (name, path) in cases {
            let message = GitSentences.failure(.submoduleElsewhere(name: name, path: path))

            XCTAssertEqual(message, submoduleElsewhereMessage(name: name, path: path), name)
            XCTAssertFalse(message.contains("\"\(name)\""), message)
            XCTAssertFalse(message.contains("\"\(path)\""), message)
            XCTAssertFalse(message.contains("'\(path)'"), message)
        }
    }

    func test_submoduleElsewhereMessageHasNoOutsideNoBangAndDiffersFromEveryOther() {
        let message = GitSentences.failure(.submoduleElsewhere(name: "a", path: "b"))
        let others =
            [
                GitFailure.gitDirectoryOutside(gitDirectory: "a"),
                .configNamesOutside(key: "include.path", path: "a"),
                .configNotLocated(key: "include.path", path: "a"),
                .objectStoreNamesOutside(path: "a"),
                .objectStoreNotLocated(path: "a"),
            ] + GitCondition.allCases.map { GitFailure.condition($0) }

        for word in forbiddenInTheGitmodulesMessages {
            XCTAssertFalse(message.localizedCaseInsensitiveContains(word), "\(word): \(message)")
        }
        XCTAssertNotEqual(message, GitSentences.fault)
        XCTAssertNotEqual(message, GitSentences.pending)
        XCTAssertNotEqual(message, GitSentences.clean)
        for other in others {
            XCTAssertNotEqual(message, GitSentences.failure(other))
        }
    }

    func test_gitmodulesUnreadableMessageIsChangeTextsAndIsNotTheGitDirectorySentence() {
        let message = GitSentences.failure(.condition(.gitmodulesUnreadable))
        let unreadableGitDirectory = GitSentences.failure(.condition(.gitDirectoryUnreadable))
        let others =
            [
                GitFailure.gitDirectoryOutside(gitDirectory: "a"),
                .configNamesOutside(key: "include.path", path: "a"),
                .configNotLocated(key: "include.path", path: "a"),
                .objectStoreNamesOutside(path: "a"),
                .objectStoreNotLocated(path: "a"),
                .submoduleElsewhere(name: "a", path: "b"),
            ]
            + GitCondition.allCases.filter { $0 != .gitmodulesUnreadable }
            .map { GitFailure.condition($0) }

        XCTAssertEqual(message, gitmodulesUnreadableMessage)
        XCTAssertFalse(message.localizedCaseInsensitiveContains("git directory"), message)
        for word in forbiddenInTheGitmodulesMessages {
            XCTAssertFalse(message.localizedCaseInsensitiveContains(word), "\(word): \(message)")
        }
        XCTAssertNotEqual(message, unreadableGitDirectory)
        XCTAssertNotEqual(message, GitSentences.fault)
        for other in others {
            XCTAssertNotEqual(message, GitSentences.failure(other))
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

    // MARK: The status letter's tooltip (CP-591, CP-592)

    /// The six words, each a literal here (`docs/CONTENT.md:L423-L426`, `U` and `C` at `:L434-L436`).
    private let wordOfEachCategory: [(GitStatusCategory, String)] = [
        (.added, "added"), (.modified, "modified"), (.deleted, "deleted"),
        (.renamed, "renamed"), (.untracked, "untracked"), (.inConflict, "conflict"),
    ]

    func test_eachCategoryGivesItsWord() {
        for (category, word) in wordOfEachCategory {
            XCTAssertEqual(GitSentences.word(for: category), word)
        }
        XCTAssertEqual(wordOfEachCategory.count, GitStatusCategory.allCases.count)
    }

    func test_theTooltipIsTheNameThenTheJoiningThenTheWord() {
        // The joining is a space, U+2014, a space (`change_text.md`).
        for (category, word) in wordOfEachCategory {
            XCTAssertEqual(
                GitSentences.letterTooltip(name: "b.txt", category: category),
                "b.txt \u{2014} " + word)
        }
    }

    func test_aNonAsciiNameComesBackByteForByte() {
        XCTAssertEqual(
            GitSentences.letterTooltip(name: "caf\u{e9}.txt", category: .modified),
            "caf\u{e9}.txt \u{2014} modified")
    }

    func test_aPathWithASlashComesBackByteForByte() {
        XCTAssertEqual(
            GitSentences.letterTooltip(name: "src/c.txt", category: .modified),
            "src/c.txt \u{2014} modified")
    }

    func test_uIsUntrackedAndCIsConflict() {
        XCTAssertEqual(
            GitSentences.letterTooltip(name: "n", category: .untracked), "n \u{2014} untracked")
        XCTAssertEqual(
            GitSentences.letterTooltip(name: "n", category: .inConflict), "n \u{2014} conflict")
        XCTAssertNotEqual(
            GitSentences.word(for: .untracked), GitSentences.word(for: .inConflict))
    }
}
