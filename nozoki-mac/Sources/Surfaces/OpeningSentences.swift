/// Every sentence unique to the startup surface.
package enum OpeningSentences {
    package static let empty = "Choose a folder to view."
    package static let stopped = "Nozoki couldn't open this folder."

    package static func observedFailure(for condition: OpeningCondition) -> String {
        switch condition {
        case .missing:
            return "Nozoki couldn't find this folder."
        case .notAFolder:
            return "Nozoki found a file where it needs a folder."
        case .unreadable:
            return "Nozoki can't read this folder."
        }
    }
}
