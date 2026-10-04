/// Which status category, if any, a tree row carries: the join of the open folder's Git item onto
/// the rows' folder-relative paths (CP-573, CP-574, CP-577).
///
/// Only a repository answer marks a row (CP-579). A row is listed when its path's UTF-8 bytes equal
/// a listed path's bytes, and a listed path ending in one `/` also lists the row spelled without it.
/// The lookup is keyed on bytes because Swift's `String` equality and hashing fold canonically
/// equivalent spellings together (measured with Swift 6.4: `"caf\u{e9}" == "cafe\u{301}"`), and
/// CP-574 matches byte for byte.
package struct TreeMarkers: Equatable, Sendable {
    /// Marks no row: what the tree holds before any Git answer reaches it.
    package static let none = TreeMarkers(changed: ListedPaths(), staged: ListedPaths())

    private let changed: ListedPaths
    private let staged: ListedPaths

    /// The markers `item` gives: none for every case but a repository answer.
    package init(_ item: GitItem) {
        guard case .repository(let repository) = item else {
            self = .none
            return
        }
        self.init(
            changed: ListedPaths(repository.changed), staged: ListedPaths(repository.staged))
    }

    private init(changed: ListedPaths, staged: ListedPaths) {
        self.changed = changed
        self.staged = staged
    }

    /// The one category the row at the folder-relative `path` carries, or nil when the item lists
    /// no such row. The changed list's entry wins over the staged list's (CP-577), whatever the
    /// row's kind (CP-574).
    package func category(forRowPath path: String) -> GitStatusCategory? {
        let key = Array(path.utf8)
        return changed.category(forKey: key) ?? staged.category(forKey: key)
    }
}

/// One list's entries indexed by the bytes of the row path each one lists.
private struct ListedPaths: Equatable, Sendable {
    private static let slash = UInt8(ascii: "/")

    /// Entries spelled exactly as the row's path.
    private var exact: [[UInt8]: GitStatusCategory] = [:]
    /// Entries that list a row by their trailing `/`, keyed by the spelling without that one `/`.
    private var trailingSlash: [[UInt8]: GitStatusCategory] = [:]

    init() {}

    /// An exact entry beats a trailing-`/` entry for the same row, and the earlier of two entries
    /// of one kind wins, so the result depends on the list and not on insertion order into a map.
    init(_ entries: [GitEntry]) {
        for entry in entries {
            let bytes = Array(entry.path.utf8)
            if exact[bytes] == nil {
                exact[bytes] = entry.category
            }
            if bytes.last == Self.slash, trailingSlash[Array(bytes.dropLast())] == nil {
                trailingSlash[Array(bytes.dropLast())] = entry.category
            }
        }
    }

    func category(forKey key: [UInt8]) -> GitStatusCategory? {
        exact[key] ?? trailingSlash[key]
    }
}
