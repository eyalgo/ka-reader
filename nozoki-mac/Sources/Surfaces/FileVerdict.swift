/// What a selected file turned out to be, as the bridge names it on the wire (design § 3 E): its
/// text, the fact that it can't be shown as text, or the condition that stopped the read.
///
/// The projection carries no path: the panel is handed the entry's own `path` beside it.
package enum FileVerdict: Equatable, Sendable {
    /// The file's decoded characters, whole, and the language they are drawn as.
    case text(String, Language)
    /// The file is not text, for the reason named.
    case cannotDisplay(CannotDisplayReason)
    /// The read could not happen, for the condition named.
    case failed(Condition)
}

/// The language a text file is drawn as. Only `plain` exists until highlighting lands.
package enum Language: String, Decodable, Sendable {
    case plain
}

/// Why a file is not text, as the bridge names it on the wire.
package enum CannotDisplayReason: String, Decodable, Sendable {
    case invalidUTF8 = "invalid_utf8"
    case invalidUTF16 = "invalid_utf16"
}
