/// The compiled read timing labels observations without asking for another read.
package nonisolated enum GitReadPolicy: Equatable, Sendable {
    case atOpen
    case followed

    /// This build reads Git once when the folder opens.
    package static let build: GitReadPolicy = .atOpen

    /// Whether this item has an observation that the read-at-open notice describes.
    package func showsNotice(for item: GitItem) -> Bool {
        switch self {
        case .followed: return false
        case .atOpen:
            switch item {
            case .repository: return true
            case .failed(let failure): return failure.hasObservedCondition
            case .pending, .plain, .stopped: return false
            }
        }
    }
}
