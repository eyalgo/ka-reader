/// What a selected file turned out to be, as the bridge names it on the wire (design § 3 E): its
/// text, the fact that it can't be shown as text, or the condition that stopped the read.
///
/// The projection carries no path: the panel is handed the entry's own `path` beside it.
package nonisolated enum FileVerdict: Equatable, Sendable {
    /// The file's decoded characters, whole, and how they are drawn.
    case text(String, Language)
    /// The file is not text, for the reason named.
    case cannotDisplay(CannotDisplayReason)
    /// The read could not happen, for the condition named.
    case failed(Condition)
    /// A re-read of the open file found nothing at its path. It carries no content.
    case gone
}

/// What the bridge answered to a relative link's activation. The link's selection act and its read
/// are one call, so the answer says whether the target opened.
package nonisolated enum RelativeLinkAnswer: Equatable, Sendable {
    /// The target is a contained file and opened, with its verdict.
    case opened(FileVerdict)
    /// The bridge answered `pending`: no contained file, so nothing changed.
    case nothing
    /// The call carried no verdict: it failed, or its answer did not conform.
    case stopped
}

/// Where the reader is in the open file: the first line shown at the panel's top, zero-based, and
/// the code view's horizontal offset in points. The model holds it as opaque bytes; this is the
/// shell's and the panel's reading of them.
package nonisolated struct ReadingPosition: Equatable, Sendable {
    package let topLine: Int
    package let horizontalOffset: Double

    package init(topLine: Int, horizontalOffset: Double) {
        self.topLine = topLine
        self.horizontalOffset = horizontalOffset
    }

    /// The first line, not scrolled sideways: where a file the reader opens is drawn.
    package static let topLeft = ReadingPosition(topLine: 0, horizontalOffset: 0)
}

/// What an automatic update of the open file carries: the file's folder-relative path, what a
/// re-read of it gave, and the reading position the model holds.
package nonisolated struct OpenFileUpdate: Equatable, Sendable {
    package let path: String
    package let verdict: FileVerdict
    package let position: ReadingPosition

    package init(path: String, verdict: FileVerdict, position: ReadingPosition) {
        self.path = path
        self.verdict = verdict
        self.position = position
    }
}

/// How a text file is drawn: `plain`, with no colour, or one of the six floor languages with the
/// spans its grammar found. A plain verdict with spans, and a floor verdict with no span list,
/// cannot be represented; a floor verdict's list may be empty.
package nonisolated enum Language: Equatable, Sendable {
    case plain
    case floor(FloorLanguage, [CodeSpan])
}

/// The six languages KA-Reader highlights, spelled as the bridge names them on the wire.
package nonisolated enum FloorLanguage: String, CaseIterable, Sendable {
    case python
    case shell
    case javascript
    case json
    case yaml
    case toml
}

/// What a token is drawn as, spelled as the bridge names it on the wire.
package nonisolated enum TokenClass: String, CaseIterable, Decodable, Sendable {
    case keyword
    case string
    case number
    case comment
    case name
}

/// One token: `start` and `end` are UTF-8 byte offsets into the verdict's content, as the wire
/// carries them and unconverted. The decoder guarantees the span conforms to the content (CP-310);
/// the panel relies on that.
package nonisolated struct CodeSpan: Equatable, Sendable {
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
package nonisolated enum CannotDisplayReason: String, Decodable, Sendable {
    case invalidUTF8 = "invalid_utf8"
    case invalidUTF16 = "invalid_utf16"
}
