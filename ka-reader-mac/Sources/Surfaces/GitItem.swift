/// The open folder's Git item as `Shell` decodes it and hands it down: exactly one of five things.
/// Every set in it is closed, and there is no "unknown" member anywhere: a value the wire does not
/// name never reaches a surface, because the decoder refuses it and the item is *stopped* (CP-561).
package nonisolated enum GitItem: Equatable, Sendable {
    /// The bridge answered `pending`: nothing was read.
    case pending
    /// The folder is not a repository's top level.
    case plain
    /// A repository's top level, with its branch, state and the two lists.
    case repository(GitRepository)
    /// The bridge answered a failure, and which one.
    case failed(GitFailure)
    /// The shell found no verdict: no buffer, or an answer that does not conform.
    case stopped
}

/// A repository's top level as the answer states it.
package nonisolated struct GitRepository: Equatable, Sendable {
    package let branch: GitBranch
    package let state: RepositoryState
    package let staged: [GitEntry]
    package let changed: [GitEntry]

    package init(
        branch: GitBranch, state: RepositoryState, staged: [GitEntry], changed: [GitEntry]
    ) {
        self.branch = branch
        self.state = state
        self.staged = staged
        self.changed = changed
    }
}

/// What the branch element shows.
package nonisolated enum GitBranch: Equatable, Sendable {
    /// A branch's short name.
    case named(String)
    /// A detached HEAD's commit identifier, carried in full (CP-556).
    case detached(commit: String)
}

/// The eight repository states, each raw value the wire's own string.
package nonisolated enum RepositoryState: String, CaseIterable, Sendable {
    case normal
    case merge
    case rebase
    case cherryPick = "cherry_pick"
    case revert
    case bisect
    case am
    case detachedHead = "detached_head"
}

/// The six status categories, each raw value the wire's own string.
package nonisolated enum GitStatusCategory: String, CaseIterable, Sendable {
    case added
    case untracked
    case modified
    case deleted
    case inConflict = "in_conflict"
    case renamed
}

/// One listed file: its folder-relative path (for `renamed`, the path renamed to) and its category.
package nonisolated struct GitEntry: Equatable, Sendable {
    package let path: String
    package let category: GitStatusCategory

    package init(path: String, category: GitStatusCategory) {
        self.path = path
        self.category = category
    }
}

/// The eighteen conditions a failed answer names: the six that carry text, and the other twelve.
package nonisolated enum GitFailure: Equatable, Sendable {
    /// The Git directory lies outside the opened folder, at `gitDirectory` as the answer spells it.
    case gitDirectoryOutside(gitDirectory: String)
    /// The repository's own Git config sets `key` to `path`, a path outside the opened folder, both
    /// as the answer spells them.
    case configNamesOutside(key: String, path: String)
    /// The repository's own Git config sets `key` to `path`, a value KA-Reader does not locate, both as
    /// the answer spells them. Where `path` leads is not observed, so the case says nothing of
    /// outside.
    case configNotLocated(key: String, path: String)
    /// A Git object store the repository names, by an alternates entry or a link, lies outside the
    /// opened folder, at `path` as the answer spells it.
    case objectStoreNamesOutside(path: String)
    /// A Git object store the repository names holds an alternates entry KA-Reader does not locate, at
    /// `path` as the answer spells it. Where `path` leads is not observed, so the case says nothing
    /// of outside.
    case objectStoreNotLocated(path: String)
    /// A `.gitmodules` section named `name` gives the submodule there the path `path`, which leads
    /// somewhere else inside the opened folder, both as the answer spells them. Where `path` leads is
    /// not observed, so the case says nothing of outside.
    case submoduleElsewhere(name: String, path: String)
    case condition(GitCondition)

    /// Whether the answer names an observed condition rather than an unexplained read failure.
    package var hasObservedCondition: Bool {
        switch self {
        case .gitDirectoryOutside, .configNamesOutside, .configNotLocated,
            .objectStoreNamesOutside, .objectStoreNotLocated, .submoduleElsewhere:
            return true
        case .condition(let condition):
            switch condition {
            case .probeRepositoryReadFailed, .notARoot, .repositoryReadFailed,
                .machineConfigNotSwitchedOff:
                return false
            case .probeFolderUnavailable, .probeGitDirectoryUnreadable,
                .probeGitEntryNotDirectory, .probeGitFileUnreadable, .gitDirectoryMissing,
                .gitDirectoryUnreadable, .notARepository, .gitmodulesUnreadable:
                return true
            }
        }
    }

}

/// The twelve conditions a failed answer names without a path, each raw value the wire's own string.
package nonisolated enum GitCondition: String, CaseIterable, Sendable {
    case probeFolderUnavailable = "probe_folder_unavailable"
    case probeGitDirectoryUnreadable = "probe_git_directory_unreadable"
    case probeGitEntryNotDirectory = "probe_git_entry_not_directory"
    case probeGitFileUnreadable = "probe_git_file_unreadable"
    case probeRepositoryReadFailed = "probe_repository_read_failed"
    case notARoot = "not_a_root"
    case gitDirectoryMissing = "git_directory_missing"
    case gitDirectoryUnreadable = "git_directory_unreadable"
    case notARepository = "not_a_repository"
    case repositoryReadFailed = "repository_read_failed"
    case machineConfigNotSwitchedOff = "machine_config_not_switched_off"
    /// A `.gitmodules` the check reads could not be read.
    case gitmodulesUnreadable = "gitmodules_unreadable"
}
