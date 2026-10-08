/// One listed entry: its name, its path relative to the open folder's root, its kind, its state and,
/// for a file, the language its name carries.
///
/// This is the projection a row is drawn from, and nothing else feeds a row (CP-82).
package struct Entry: Decodable, Equatable, Sendable {
    package let name: String
    package let path: String
    package let kind: EntryKind
    package let state: EntryState
    /// The floor language the core's name table gives a file's name, or nil for a plain file. A
    /// folder has none, whatever its name.
    package let language: FloorLanguage?

    package init(
        name: String, path: String, kind: EntryKind, state: EntryState,
        language: FloorLanguage? = nil
    ) {
        self.name = name
        self.path = path
        self.kind = kind
        self.state = state
        self.language = language
    }

    private enum Key: String, CodingKey {
        case name, path, kind, state, condition, language
    }

    /// A file entry's `language` member: `plain` or one of the six floor languages. Any other value
    /// throws, so a listing the shell does not understand is refused whole.
    private enum WireLanguage: Decodable {
        case plain
        case floor(FloorLanguage)

        init(from decoder: Decoder) throws {
            let name = try decoder.singleValueContainer().decode(String.self)
            if name == "plain" {
                self = .plain
            } else if let floor = FloorLanguage(rawValue: name) {
                self = .floor(floor)
            } else {
                throw DecodingError.dataCorrupted(
                    .init(codingPath: decoder.codingPath, debugDescription: "unknown language"))
            }
        }
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
        switch kind {
        case .folder:
            language = nil
        case .file:
            switch try container.decode(WireLanguage.self, forKey: .language) {
            case .plain: language = nil
            case .floor(let floor): language = floor
            }
        }
    }
}
