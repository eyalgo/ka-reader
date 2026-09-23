/// What a listed entry is, as the bridge names it on the wire (design § 3 A).
///
/// The set is closed: decoding any other string fails, so a kind the shell has no
/// glyph for cannot enter a row.
package enum EntryKind: String, Decodable, Sendable {
    case folder
    case file
    case symlink
}
