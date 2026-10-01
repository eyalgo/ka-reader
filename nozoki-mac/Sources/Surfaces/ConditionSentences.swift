/// Every sentence this surface shows for a condition or for the root, and the only place those
/// strings exist (CP-185).
///
/// The row sentences are `docs/CONTENT.md` v7's, § Message patterns, *Partial* (CP-203).
package enum ConditionSentences {
    /// The line for a root that could not be read, whatever the condition.
    package static let failedRoot = "Nozoki can't read this folder."

    /// The line for a root that was read and holds nothing (`docs/CONTENT.md`).
    package static let emptyRoot = "This folder has no files."

    /// The line drawn beneath a folder while its read is out (`docs/CONTENT.md`, *Loading*).
    package static let readingFolder = "Reading this folder."

    /// The line drawn beneath a folder that was read and holds nothing.
    package static let emptyFolder = emptyRoot

    /// The sentence shown on the row of an entry that failed with `condition`.
    package static func row(for condition: Condition) -> String {
        switch condition {
        case .unreadable, .notAFolder:
            return "Nozoki can't read this folder."
        case .outside:
            return "This link leads outside the folder you opened, so Nozoki doesn't read it."
        case .cycle:
            return "This link loops back on itself, so Nozoki can't read it."
        case .missing:
            return "This link leads to something that isn't there."
        case .tooManyLinks:
            return "This link leads through more links than Nozoki follows."
        }
    }

    /// The one sentence drawn beneath the path line of a file that is not text (`docs/CONTENT.md`
    /// § Terminology: *can't be shown as text*, said of the file). Both reasons read the same: the
    /// reader is told what Nozoki observed about the file, not how it is encoded.
    package static func cannotDisplay(fileNamed name: String) -> String {
        "\(name) can't be shown as text."
    }

    /// The statement drawn beneath the path line of a file whose read failed with `condition`:
    /// what Nozoki observed, naming the file, in one sentence (`docs/CONTENT.md` § Message
    /// patterns, *Error — an observed condition*). The switch has no `default`, so a seventh
    /// condition fails to compile here instead of drawing nothing.
    package static func reading(fileNamed name: String, failedWith condition: Condition) -> String {
        switch condition {
        case .unreadable, .notAFolder:
            return "Nozoki can't read \(name)."
        case .outside:
            return
                "\(name) is a link that leads outside the folder you opened, so Nozoki doesn't read it."
        case .cycle:
            return "\(name) is a link that loops back on itself, so Nozoki can't read it."
        case .missing:
            return "\(name) is no longer there."
        case .tooManyLinks:
            return "\(name) leads through more links than Nozoki follows."
        }
    }
}
