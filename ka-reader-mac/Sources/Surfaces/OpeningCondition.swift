/// The filesystem conditions an opening probe can observe.
package nonisolated enum OpeningCondition: CaseIterable, Equatable {
    case missing
    case notAFolder
    case unreadable
}
