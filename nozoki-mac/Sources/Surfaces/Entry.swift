/// One listed entry: its name, its path relative to the open folder's root, and its kind.
///
/// This is the projection a row is drawn from, and nothing else feeds a row (CP-82).
public struct Entry: Decodable, Equatable, Sendable {
    public let name: String
    public let path: String
    public let kind: EntryKind

    public init(name: String, path: String, kind: EntryKind) {
        self.name = name
        self.path = path
        self.kind = kind
    }
}
