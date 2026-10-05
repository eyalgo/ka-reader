/// Every string the Git view and the Files/Git switch draw, and the only place those strings exist.
/// Each one is placed as `change_text.md` writes it; the ones `docs/CONTENT.md` already writes are
/// copied literally. Every choice is an exhaustive `switch` with no `default`, so a state or
/// condition added later fails to compile here instead of drawing nothing.
package enum GitSentences {
    /// The switch's two labels: no full stop (`docs/CONTENT.md:L113-L115`).
    package static let filesLabel = "Files"
    package static let gitLabel = "Git"

    /// The headings over the two lists, in sentence case (`docs/CONTENT.md:L106-L112`).
    package static let changesHeading = "Changes"
    package static let stagedHeading = "Staged"

    /// Drawn while no answer has been drawn and for a `pending` answer (`docs/CONTENT.md:L510`).
    package static let pending = "Reading Git status."

    /// A repository in the normal state with nothing staged and nothing changed
    /// (`docs/CONTENT.md:L299-L300`).
    package static let clean = "Nothing has changed in this repository."

    /// The unexplained fault (`docs/CONTENT.md:L288-L289`), placed character for character.
    package static let fault =
        "Nozoki stopped while reading this repository's Git status and can't tell why. "
        + "The file tree is unaffected; the Git view shows the status again if Nozoki can read it."

    private static let unreadableGitDirectory =
        "Nozoki can't read the Git directory in the folder you opened, so it can't show the "
        + "folder's Git status. The file tree and the reading panel are unaffected."

    /// The short status for a repository state, or nil for `normal`, which the lists decide.
    package static func statusSentence(for state: RepositoryState) -> String? {
        switch state {
        case .normal: return nil
        case .merge: return "A merge is in progress in this repository."
        case .rebase: return "A rebase is in progress in this repository."
        case .cherryPick: return "A cherry-pick is in progress in this repository."
        case .revert: return "A revert is in progress in this repository."
        case .bisect: return "A bisect is in progress in this repository."
        case .am: return "An am session is in progress in this repository."
        case .detachedHead: return "HEAD is detached in this repository."
        }
    }

    /// The one message a failed answer draws. A condition Nozoki observed gets a statement naming
    /// only what it records; one that records only that Git refused or failed takes the fault.
    package static func failure(_ failure: GitFailure) -> String {
        switch failure {
        case .gitDirectoryOutside(let gitDirectory):
            return
                "This repository's Git directory is at \(gitDirectory), outside the folder you "
                + "opened, so Nozoki doesn't read its Git status. "
                + "The file tree and the reading panel are unaffected."
        case .configNamesOutside(let key, let path):
            return
                "Nozoki found \(key) set to \(path), outside the folder you opened, so it doesn't "
                + "read the folder's Git status. "
                + "The file tree and the reading panel are unaffected."
        case .condition(let condition):
            return sentence(for: condition)
        }
    }

    private static func sentence(for condition: GitCondition) -> String {
        switch condition {
        case .probeFolderUnavailable:
            return
                "Nozoki couldn't look in the folder you opened to find out whether it's a repository."
        case .probeGitDirectoryUnreadable, .probeGitFileUnreadable, .gitDirectoryUnreadable:
            return unreadableGitDirectory
        case .probeGitEntryNotDirectory:
            return
                "In the folder you opened, the Git directory is a link, or something that is "
                + "neither a file nor a folder, so Nozoki doesn't read the folder's Git status. "
                + "The file tree and the reading panel are unaffected."
        case .gitDirectoryMissing:
            return
                "There's nothing where this repository's Git directory points, so Nozoki can't "
                + "read its Git status. The file tree and the reading panel are unaffected."
        case .notARepository:
            return
                "Nozoki looked in the Git directory in the folder you opened and found no "
                + "repository there. The file tree and the reading panel are unaffected."
        case .probeRepositoryReadFailed, .notARoot, .repositoryReadFailed,
            .machineConfigNotSwitchedOff:
            return fault
        }
    }

    /// The letter a row draws beside its path (`docs/DESIGN.md:L627-L630`).
    package static func letter(for category: GitStatusCategory) -> String {
        switch category {
        case .added: return "A"
        case .untracked: return "U"
        case .modified: return "M"
        case .deleted: return "D"
        case .inConflict: return "C"
        case .renamed: return "R"
        }
    }

    /// The word a status letter stands for (`docs/CONTENT.md:L423-L426`, `U` and `C` at
    /// `:L434-L436`): lower case, no punctuation. `C` is conflict, not Git porcelain's copied.
    package static func word(for category: GitStatusCategory) -> String {
        switch category {
        case .added: return "added"
        case .modified: return "modified"
        case .deleted: return "deleted"
        case .renamed: return "renamed"
        case .untracked: return "untracked"
        case .inConflict: return "conflict"
        }
    }

    /// The tooltip a status letter raises: the row's name exactly as the row prints it, a space, an
    /// em dash and a space, then the letter's word. Placed as `change_text.md` writes it, six whole
    /// strings with one placeholder each, so none is assembled from a fragment of Nozoki's prose.
    package static func letterTooltip(name: String, category: GitStatusCategory) -> String {
        switch category {
        case .added: return "\(name) \u{2014} added"
        case .modified: return "\(name) \u{2014} modified"
        case .deleted: return "\(name) \u{2014} deleted"
        case .renamed: return "\(name) \u{2014} renamed"
        case .untracked: return "\(name) \u{2014} untracked"
        case .inConflict: return "\(name) \u{2014} conflict"
        }
    }
}
