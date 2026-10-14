/// The order of a Git list's rows (CP-558): the path each row shows, lowercased and compared by
/// Unicode scalar value, then by the original's UTF-8 bytes, with no normalization.
///
/// This is the key `fs-reader` orders the tree by (`crates/ka-reader-core/src/fs_reader.rs:L818-L832`),
/// written out over scalars and bytes. Swift's `String` `<` compares under canonical equivalence and
/// `localizedStandardCompare` compares digits as numbers, and each breaks one of the two clauses.
package nonisolated enum GitRowOrder {
    /// `entries` in row order. The result does not depend on the order they arrive in.
    package static func ordered(_ entries: [GitEntry]) -> [GitEntry] {
        entries.sorted { precedes($0.path, $1.path) }
    }

    private static func precedes(_ left: String, _ right: String) -> Bool {
        let leftScalars = left.lowercased().unicodeScalars.map(\.value)
        let rightScalars = right.lowercased().unicodeScalars.map(\.value)
        if leftScalars != rightScalars {
            return leftScalars.lexicographicallyPrecedes(rightScalars)
        }
        return left.utf8.lexicographicallyPrecedes(right.utf8)
    }
}
