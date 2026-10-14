/// Every sentence unique to the startup surface.
package nonisolated enum OpeningSentences {
    package static let empty = "Choose a folder to view."
    package static let stopped = "KA-Reader couldn't open this folder."

    package static func observedFailure(for condition: OpeningCondition) -> String {
        switch condition {
        case .missing:
            return "KA-Reader couldn't find this folder."
        case .notAFolder:
            return "KA-Reader found a file where it needs a folder."
        case .unreadable:
            return "KA-Reader can't read this folder."
        }
    }
}
