/// Where an entry stands: not read yet, read, or failed to read for a named reason.
package nonisolated enum EntryState: Equatable, Sendable {
    case pending
    case observed
    case failed(Condition)
}
