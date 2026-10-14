/// What a listed entry is, as the bridge names it on the wire (design § 3 C).
///
/// The set is closed: decoding any other string fails, so a kind the shell has no glyph for cannot
/// enter a row. A link never appears here: the reader lists it as the folder or file it reaches, and
/// a link that could not be resolved is a `file` whose state is `failed`.
package nonisolated enum EntryKind: String, Decodable, Sendable {
    case folder
    case file
}
