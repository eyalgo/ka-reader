/// One listed entry: its name, its path relative to the open folder's root, its kind and its state.
///
/// This is the projection a row is drawn from, and nothing else feeds a row (CP-82).
package struct Entry: Decodable, Equatable, Sendable {
    package let name: String
    package let path: String
    package let kind: EntryKind
    package let state: EntryState

    package init(name: String, path: String, kind: EntryKind, state: EntryState) {
        self.name = name
        self.path = path
        self.kind = kind
        self.state = state
    }

    private enum Key: String, CodingKey {
        case name, path, kind, state, condition
    }

    /// The wire's `state` values. A `condition` key appears beside `failed` only.
    private enum StateTag: String, Decodable {
        case pending, observed, failed
    }

    package init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Key.self)
        name = try container.decode(String.self, forKey: .name)
        path = try container.decode(String.self, forKey: .path)
        kind = try container.decode(EntryKind.self, forKey: .kind)
        switch try container.decode(StateTag.self, forKey: .state) {
        case .pending: state = .pending
        case .observed: state = .observed
        case .failed: state = .failed(try container.decode(Condition.self, forKey: .condition))
        }
    }
}
