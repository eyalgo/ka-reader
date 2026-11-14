/// The order of a Git list's rows (CP-558): the path each row shows, lowercased and compared by
/// Unicode scalar value, then by the original's UTF-8 bytes, with no normalization.
///
/// This is the key `fs-reader` orders the tree by (`crates/ka-reader-core/src/fs_reader.rs:L818-L832`),
/// written out over scalars and bytes. Swift's `String` `<` compares under canonical equivalence and
/// `localizedStandardCompare` compares digits as numbers, and each breaks one of the two clauses.
package nonisolated enum GitRowOrder {
    /// `entries` in row order. The result does not depend on the order they arrive in.
    ///
    /// Each entry's key is built once, before the sort, so the sort's many comparisons read keys and
    /// do not lowercase and map a path each time.
    package static func ordered(_ entries: [GitEntry]) -> [GitEntry] {
        entries.map { (entry: $0, key: RowKey($0.path)) }
            .sorted { $0.key.precedes($1.key) }
            .map(\.entry)
    }

    /// One path's two comparison keys: its lowercased Unicode scalar values, then its UTF-8 bytes.
    private struct RowKey {
        let lowercasedScalars: [UInt32]
        let utf8Bytes: [UInt8]

        init(_ path: String) {
            lowercasedScalars = path.lowercased().unicodeScalars.map(\.value)
            utf8Bytes = Array(path.utf8)
        }

        func precedes(_ other: RowKey) -> Bool {
            if lowercasedScalars != other.lowercasedScalars {
                return lowercasedScalars.lexicographicallyPrecedes(other.lowercasedScalars)
            }
            return utf8Bytes.lexicographicallyPrecedes(other.utf8Bytes)
        }
    }
}
