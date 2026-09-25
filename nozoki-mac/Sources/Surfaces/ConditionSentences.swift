/// Every sentence this surface shows for a condition or for the root, and the only place those
/// strings exist (CP-185).
///
/// The row sentences for a link that leads outside, loops, points at nothing or runs past the link
/// limit are provisional: `docs/CONTENT.md` holds no sentence for them yet.
package enum ConditionSentences {
    /// The line for a root that could not be read, whatever the condition.
    package static let failedRoot = "Nozoki can't read this folder."

    /// The line for a root that was read and holds nothing (`docs/CONTENT.md`).
    package static let emptyRoot = "This folder has no files."

    /// The sentence shown on the row of an entry that failed with `condition`.
    package static func row(for condition: Condition) -> String {
        switch condition {
        case .unreadable, .notAFolder:
            return "Nozoki can't read this folder."
        case .outside:
            return "This link leads outside this folder, and Nozoki reads nothing outside it."
        case .cycle:
            return "This link loops back on itself, so Nozoki can't read it."
        case .missing:
            return "This link leads to something that isn't there."
        case .tooManyLinks:
            return "This link leads through too many other links, so Nozoki can't read it."
        }
    }
}
