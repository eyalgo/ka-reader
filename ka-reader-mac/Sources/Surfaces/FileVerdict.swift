/// What a selected file turned out to be, as the bridge names it on the wire (design § 3 E): its
/// text, the fact that it can't be shown as text, or the condition that stopped the read.
///
/// The projection carries no path: the panel is handed the entry's own `path` beside it.
package enum FileVerdict: Equatable, Sendable {
    /// The file's decoded characters, whole, and how they are drawn.
    case text(String, Language)
    /// The file is not text, for the reason named.
    case cannotDisplay(CannotDisplayReason)
    /// The read could not happen, for the condition named.
    case failed(Condition)
}

/// How a text file is drawn: `plain`, with no colour, or one of the six floor languages with the
/// spans its grammar found. A plain verdict with spans, and a floor verdict with no span list,
/// cannot be represented; a floor verdict's list may be empty.
package enum Language: Equatable, Sendable {
    case plain
    case floor(FloorLanguage, [CodeSpan])
}

/// The six languages KA-Reader highlights, spelled as the bridge names them on the wire.
package enum FloorLanguage: String, CaseIterable, Sendable {
    case python
    case shell
    case javascript
    case json
    case yaml
    case toml
}

/// What a token is drawn as, spelled as the bridge names it on the wire.
package enum TokenClass: String, CaseIterable, Decodable, Sendable {
    case keyword
    case string
    case number
    case comment
    case name
}

/// One token: `start` and `end` are UTF-8 byte offsets into the verdict's content, as the wire
/// carries them and unconverted. The decoder guarantees the span conforms to the content (CP-310);
/// the panel relies on that.
package struct CodeSpan: Equatable, Sendable {
    package let start: Int
    package let end: Int
    package let tokenClass: TokenClass

    package init(start: Int, end: Int, tokenClass: TokenClass) {
        self.start = start
        self.end = end
        self.tokenClass = tokenClass
    }
}

/// Why a file is not text, as the bridge names it on the wire.
package enum CannotDisplayReason: String, Decodable, Sendable {
    case invalidUTF8 = "invalid_utf8"
    case invalidUTF16 = "invalid_utf16"
}
