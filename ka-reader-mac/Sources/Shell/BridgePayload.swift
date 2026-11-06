import Foundation
import Surfaces

/// Reads the bridge's JSON payloads. Anything that does not conform reads as the failure value:
/// not opened, or no listing (`nil`) for the root or for any folder.
enum BridgePayload {
    enum OpenResult: Equatable {
        case opened
        case failed(OpeningCondition)
    }

    private struct OpenAnswer: Decodable {
        let state: State
        let condition: Condition?

        enum State: String, Decodable { case opened, failed }
        enum Condition: String, Decodable {
            case missing
            case notAFolder = "not_a_folder"
            case unreadable
        }

        private struct Key: CodingKey, Hashable {
            let stringValue: String

            private init(_ stringValue: String) {
                self.stringValue = stringValue
            }

            init?(stringValue: String) {
                self.stringValue = stringValue
            }

            let intValue: Int? = nil

            init?(intValue: Int) {
                return nil
            }

            static let state = Key("state")
            static let condition = Key("condition")
        }

        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: Key.self)
            state = try container.decode(State.self, forKey: .state)

            switch state {
            case .opened:
                guard Set(container.allKeys) == [.state] else {
                    throw DecodingError.dataCorruptedError(
                        forKey: .state, in: container, debugDescription: "opened has extra members")
                }
                condition = nil
            case .failed:
                guard Set(container.allKeys) == [.state, .condition] else {
                    throw DecodingError.dataCorruptedError(
                        forKey: .state,
                        in: container,
                        debugDescription: "failed has the wrong members")
                }
                condition = try container.decode(Condition.self, forKey: .condition)
            }
        }
    }

    static func decodeOpen(_ buffer: BridgeBuffer?) -> OpenResult? {
        guard let buffer,
            let answer = try? JSONDecoder().decode(OpenAnswer.self, from: buffer.payload)
        else { return nil }
        switch (answer.state, answer.condition) {
        case (.opened, nil): return .opened
        case (.failed, .missing?): return .failed(.missing)
        case (.failed, .notAFolder?): return .failed(.notAFolder)
        case (.failed, .unreadable?): return .failed(.unreadable)
        default: return nil
        }
    }

    /// The list answer's wire (design § 3 C). `pending` means nothing was read, so it carries no
    /// listing, and a state, entry or condition this shell does not know throws.
    private struct ListAnswer: Decodable {
        let listing: RootListing?

        private enum Key: String, CodingKey {
            case state, entries, condition
        }

        private enum StateTag: String, Decodable {
            case pending, observed, failed
        }

        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: Key.self)
            switch try container.decode(StateTag.self, forKey: .state) {
            case .pending:
                listing = nil
            case .observed:
                listing = .observed(try container.decode([Entry].self, forKey: .entries))
            case .failed:
                listing = .failed(try container.decode(Condition.self, forKey: .condition))
            }
        }
    }

    static func decodeRoot(_ buffer: BridgeBuffer?) -> RootListing? {
        guard let buffer else { return nil }
        return (try? JSONDecoder().decode(ListAnswer.self, from: buffer.payload))?.listing
    }

    /// One changed listing as the `model_changed` payload writes it: exactly `path` (the root is the
    /// empty path) and `answer`, which is the list answer's shape.
    private struct WireChange: Decodable {
        let path: String
        let listing: RootListing?

        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: WireKey.self)
            try BridgePayload.requireMembers(["path", "answer"], in: container)
            path = try container.decode(String.self, forKey: WireKey(stringValue: "path"))
            listing = try container.decode(ListAnswer.self, forKey: WireKey(stringValue: "answer"))
                .listing
        }
    }

    /// The open file as the `model_changed` payload writes it: exactly `revision`, `path`,
    /// `position` and `answer`, which is the file answer's shape. A `pending` answer carries no
    /// verdict, so it refuses the member.
    private struct WireOpenFile: Decodable {
        let revision: UInt64
        let update: OpenFileUpdate

        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: WireKey.self)
            try BridgePayload.requireMembers(
                ["revision", "path", "position", "answer"], in: container)
            revision = try container.decode(UInt64.self, forKey: WireKey(stringValue: "revision"))
            guard
                let verdict = try container.decode(
                    FileAnswer.self, forKey: WireKey(stringValue: "answer")
                ).verdict
            else {
                throw DecodingError.dataCorrupted(
                    .init(
                        codingPath: container.codingPath,
                        debugDescription: "an open file member is never pending"))
            }
            update = OpenFileUpdate(
                path: try container.decode(String.self, forKey: WireKey(stringValue: "path")),
                verdict: verdict,
                position: BridgePayload.decodePosition(
                    try container.decode(String.self, forKey: WireKey(stringValue: "position"))))
        }
    }

    /// The payload's wire: one `listings` array, and an `open_file` member when the open file
    /// changed.
    private struct ChangesPayload: Decodable {
        let changes: [WireChange]
        let openFile: WireOpenFile?

        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: WireKey.self)
            let members = Set(container.allKeys.map(\.stringValue))
            guard members == ["listings"] || members == ["listings", "open_file"] else {
                throw DecodingError.dataCorrupted(
                    .init(codingPath: container.codingPath, debugDescription: "the wrong members"))
            }
            changes = try container.decode(
                [WireChange].self, forKey: WireKey(stringValue: "listings"))
            openFile =
                members.contains("open_file")
                ? try container.decode(WireOpenFile.self, forKey: WireKey(stringValue: "open_file"))
                : nil
        }
    }

    /// What one `model_changed` payload carries: the changed listings in the order written, and the
    /// open file, with the revision it is stamped with, when it changed.
    struct ModelChanges {
        let listings: [(path: String, listing: RootListing?)]
        let openFile: (revision: UInt64, update: OpenFileUpdate)?
    }

    /// The changes a `model_changed` payload carries, or `nil` when the payload does not conform:
    /// one bad listing, or an open file member that does not conform, refuses the whole payload and
    /// none is kept. A `pending` listing answer reads as no listing (`nil`), as it does for a folder
    /// read.
    static func decodeChanges(_ payload: Data) -> ModelChanges? {
        guard let decoded = try? JSONDecoder().decode(ChangesPayload.self, from: payload)
        else { return nil }
        return ModelChanges(
            listings: decoded.changes.map { (path: $0.path, listing: $0.listing) },
            openFile: decoded.openFile.map { (revision: $0.revision, update: $0.update) })
    }

    /// The file answer's wire (design § 3 F): one object tagged by `state`, with exactly the
    /// members the state names. A member that is missing or extra, and a state, language, reason or
    /// condition outside its closed set, throws. `pending` means nothing was read, so it carries no
    /// verdict.
    private struct FileAnswer: Decodable {
        let verdict: FileVerdict?

        /// Any member name, so a member this shell does not know is seen and refused rather than
        /// ignored.
        private struct Key: CodingKey {
            let stringValue: String
            let intValue: Int? = nil

            init(stringValue: String) {
                self.stringValue = stringValue
            }

            init?(intValue: Int) {
                return nil
            }

            static let state = Key(stringValue: "state")
            static let content = Key(stringValue: "content")
            static let language = Key(stringValue: "language")
            static let spans = Key(stringValue: "spans")
            static let reason = Key(stringValue: "reason")
            static let condition = Key(stringValue: "condition")
        }

        private enum StateTag: String, Decodable {
            case text
            case cannotDisplay = "cannot_display"
            case failed
            case gone
            case pending
        }

        /// The `language` member's value: `plain` or one of the six floor languages. Any other value
        /// throws, so `rust` is refused (CP-309).
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

        /// One span as the wire writes it: exactly `start`, `end` and `class`.
        private struct WireSpan: Decodable {
            let span: CodeSpan

            private struct SpanKey: CodingKey {
                let stringValue: String
                let intValue: Int? = nil

                init(stringValue: String) {
                    self.stringValue = stringValue
                }

                init?(intValue: Int) {
                    return nil
                }

                static let start = SpanKey(stringValue: "start")
                static let end = SpanKey(stringValue: "end")
                static let tokenClass = SpanKey(stringValue: "class")
            }

            init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: SpanKey.self)
                guard Set(container.allKeys.map(\.stringValue)) == ["start", "end", "class"] else {
                    throw DecodingError.dataCorrupted(
                        .init(
                            codingPath: decoder.codingPath,
                            debugDescription: "a span has exactly start, end and class"))
                }
                span = CodeSpan(
                    start: try container.decode(Int.self, forKey: .start),
                    end: try container.decode(Int.self, forKey: .end),
                    tokenClass: try container.decode(TokenClass.self, forKey: .tokenClass))
            }
        }

        /// CP-310 over the content's UTF-8 view: `0 ≤ start < end ≤ byte count`, both offsets on
        /// Unicode-scalar boundaries (not grapheme boundaries, the core's own), and each span
        /// starting at or after the end of the one before it. The first failure throws.
        private static func checkedSpans(
            _ spans: [CodeSpan], in content: String, container: KeyedDecodingContainer<Key>
        ) throws -> [CodeSpan] {
            let bytes = Array(content.utf8)
            let isScalarBoundary = { (offset: Int) -> Bool in
                offset == bytes.count || (bytes[offset] & 0b1100_0000) != 0b1000_0000
            }
            var previousEnd = 0
            for span in spans {
                guard span.start >= previousEnd, span.start < span.end, span.end <= bytes.count,
                    isScalarBoundary(span.start), isScalarBoundary(span.end)
                else {
                    throw DecodingError.dataCorruptedError(
                        forKey: .spans, in: container,
                        debugDescription: "a span does not conform to the content")
                }
                previousEnd = span.end
            }
            return spans
        }

        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: Key.self)
            let state = try container.decode(StateTag.self, forKey: .state)
            // The language is read first: it decides whether a spans member is expected (CP-310).
            let wireLanguage: WireLanguage? =
                state == .text ? try container.decode(WireLanguage.self, forKey: .language) : nil
            let expected: [String]
            switch state {
            case .text:
                switch wireLanguage {
                case .floor?: expected = ["state", "content", "language", "spans"]
                case .plain?, nil: expected = ["state", "content", "language"]
                }
            case .cannotDisplay: expected = ["state", "reason"]
            case .failed: expected = ["state", "condition"]
            case .gone, .pending: expected = ["state"]
            }
            guard Set(container.allKeys.map(\.stringValue)) == Set(expected) else {
                throw DecodingError.dataCorruptedError(
                    forKey: .state, in: container,
                    debugDescription: "\(state.rawValue) has the wrong members")
            }
            switch state {
            case .text:
                let content = try container.decode(String.self, forKey: .content)
                switch wireLanguage {
                case .floor(let floor)?:
                    let spans = try container.decode([WireSpan].self, forKey: .spans).map(\.span)
                    verdict = .text(
                        content,
                        .floor(
                            floor, try Self.checkedSpans(spans, in: content, container: container)))
                case .plain?, nil:
                    verdict = .text(content, .plain)
                }
            case .cannotDisplay:
                verdict = .cannotDisplay(
                    try container.decode(CannotDisplayReason.self, forKey: .reason))
            case .failed:
                verdict = .failed(try container.decode(Condition.self, forKey: .condition))
            case .gone:
                verdict = .gone
            case .pending:
                verdict = nil
            }
        }
    }

    /// The wire form of a reading position, `line=<n>;x=<points>`: a short ASCII form this shell
    /// alone writes and reads, which the model holds as opaque bytes.
    static func encodePosition(_ position: ReadingPosition) -> String {
        "line=\(position.topLine);x=\(position.horizontalOffset)"
    }

    /// The position `encodePosition` wrote. A string that is anything else reads as the top-left.
    static func decodePosition(_ wire: String) -> ReadingPosition {
        let members = wire.split(separator: ";", omittingEmptySubsequences: false)
        guard members.count == 2,
            members[0].hasPrefix("line="), members[1].hasPrefix("x="),
            let line = Int(members[0].dropFirst("line=".count)), line >= 0,
            let offset = Double(members[1].dropFirst("x=".count)), offset.isFinite, offset >= 0
        else { return .topLeft }
        return ReadingPosition(topLine: line, horizontalOffset: offset)
    }

    /// The verdict a `ka_reader_select_file` answer carries, or `nil` for `pending`, a NULL buffer and
    /// anything that does not conform.
    static func decodeFile(_ buffer: BridgeBuffer?) -> FileVerdict? {
        guard let buffer else { return nil }
        return (try? JSONDecoder().decode(FileAnswer.self, from: buffer.payload))?.verdict
    }

    /// One object's members, any name, so a member this shell does not know is seen and refused
    /// rather than ignored; each Git object checks its own set with `requireMembers`.
    private struct WireKey: CodingKey {
        let stringValue: String
        let intValue: Int? = nil

        init(stringValue: String) {
            self.stringValue = stringValue
        }

        init?(intValue: Int) {
            return nil
        }
    }

    /// Throws unless the object holds exactly `expected`, no more and no fewer.
    private static func requireMembers(
        _ expected: Set<String>, in container: KeyedDecodingContainer<WireKey>
    ) throws {
        guard Set(container.allKeys.map(\.stringValue)) == expected else {
            throw DecodingError.dataCorrupted(
                .init(codingPath: container.codingPath, debugDescription: "the wrong members"))
        }
    }

    /// A member whose value is one string of a closed set; any other string throws.
    private static func closed<Value: RawRepresentable>(
        _ type: Value.Type, in container: KeyedDecodingContainer<WireKey>, key: String
    ) throws -> Value where Value.RawValue == String {
        let name = try container.decode(String.self, forKey: WireKey(stringValue: key))
        guard let value = Value(rawValue: name) else {
            throw DecodingError.dataCorrupted(
                .init(codingPath: container.codingPath, debugDescription: "\(key) is not known"))
        }
        return value
    }

    /// One listed entry as the wire writes it: `path` and `category`, and `from` exactly where the
    /// category is `renamed`. `from` is checked and then dropped (spec Gap 4).
    private struct WireGitEntry: Decodable {
        let entry: GitEntry

        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: WireKey.self)
            let category = try BridgePayload.closed(
                GitStatusCategory.self, in: container, key: "category")
            try BridgePayload.requireMembers(
                category == .renamed ? ["path", "category", "from"] : ["path", "category"],
                in: container)
            if category == .renamed {
                _ = try container.decode(String.self, forKey: WireKey(stringValue: "from"))
            }
            entry = GitEntry(
                path: try container.decode(String.self, forKey: WireKey(stringValue: "path")),
                category: category)
        }
    }

    /// The branch element: a branch's short name, or a detached HEAD's full identifier.
    private struct WireGitBranch: Decodable {
        let branch: GitBranch

        private enum Kind: String, Decodable { case branch, detached }

        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: WireKey.self)
            switch try container.decode(Kind.self, forKey: WireKey(stringValue: "kind")) {
            case .branch:
                try BridgePayload.requireMembers(["kind", "name"], in: container)
                branch = .named(
                    try container.decode(String.self, forKey: WireKey(stringValue: "name")))
            case .detached:
                try BridgePayload.requireMembers(["kind", "commit"], in: container)
                branch = .detached(
                    commit: try container.decode(
                        String.self, forKey: WireKey(stringValue: "commit")))
            }
        }
    }

    /// The Git answer's wire: one object tagged by `state`, with exactly the members the state
    /// names, at every level. A member missing or extra, and a tag or value outside its closed
    /// set, throws, so the decoder never keeps part of a bad answer.
    private struct GitAnswer: Decodable {
        let item: GitItem

        private enum StateTag: String, Decodable { case pending, observed, failed }
        private enum Kind: String, Decodable { case plain, root }

        /// The condition member's value: the twelve conditions that carry no text, or one of the
        /// six that come beside theirs.
        private enum WireCondition: Decodable {
            case gitDirectoryOutside
            case configNamesOutside
            case configNotLocated
            case objectStoreNamesOutside
            case objectStoreNotLocated
            case submoduleElsewhere
            case condition(GitCondition)

            init(from decoder: Decoder) throws {
                let name = try decoder.singleValueContainer().decode(String.self)
                if name == "git_directory_outside" {
                    self = .gitDirectoryOutside
                } else if name == "config_names_outside" {
                    self = .configNamesOutside
                } else if name == "config_not_located" {
                    self = .configNotLocated
                } else if name == "object_store_names_outside" {
                    self = .objectStoreNamesOutside
                } else if name == "object_store_not_located" {
                    self = .objectStoreNotLocated
                } else if name == "submodule_elsewhere" {
                    self = .submoduleElsewhere
                } else if let condition = GitCondition(rawValue: name) {
                    self = .condition(condition)
                } else {
                    throw DecodingError.dataCorrupted(
                        .init(codingPath: decoder.codingPath, debugDescription: "unknown condition")
                    )
                }
            }
        }

        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: WireKey.self)
            let state = try container.decode(StateTag.self, forKey: WireKey(stringValue: "state"))
            switch state {
            case .pending:
                try BridgePayload.requireMembers(["state"], in: container)
                item = .pending
            case .observed:
                item = try Self.observed(container)
            case .failed:
                item = try Self.failed(container)
            }
        }

        private static func observed(
            _ container: KeyedDecodingContainer<WireKey>
        ) throws -> GitItem {
            switch try container.decode(Kind.self, forKey: WireKey(stringValue: "kind")) {
            case .plain:
                try BridgePayload.requireMembers(["state", "kind"], in: container)
                return .plain
            case .root:
                try BridgePayload.requireMembers(
                    ["state", "kind", "branch", "repository_state", "staged", "changed"],
                    in: container)
                return .repository(
                    GitRepository(
                        branch: try container.decode(
                            WireGitBranch.self, forKey: WireKey(stringValue: "branch")
                        ).branch,
                        state: try BridgePayload.closed(
                            RepositoryState.self, in: container, key: "repository_state"),
                        staged: try container.decode(
                            [WireGitEntry].self, forKey: WireKey(stringValue: "staged")
                        ).map(\.entry),
                        changed: try container.decode(
                            [WireGitEntry].self, forKey: WireKey(stringValue: "changed")
                        ).map(\.entry)))
            }
        }

        private static func failed(_ container: KeyedDecodingContainer<WireKey>) throws -> GitItem {
            let condition = try container.decode(
                WireCondition.self, forKey: WireKey(stringValue: "condition"))
            switch condition {
            case .gitDirectoryOutside:
                try BridgePayload.requireMembers(
                    ["state", "condition", "git_directory"], in: container)
                return .failed(
                    .gitDirectoryOutside(
                        gitDirectory: try container.decode(
                            String.self, forKey: WireKey(stringValue: "git_directory"))))
            case .configNamesOutside:
                try BridgePayload.requireMembers(
                    ["state", "condition", "key", "path"], in: container)
                return .failed(
                    .configNamesOutside(
                        key: try container.decode(String.self, forKey: WireKey(stringValue: "key")),
                        path: try container.decode(
                            String.self, forKey: WireKey(stringValue: "path"))
                    ))
            case .configNotLocated:
                try BridgePayload.requireMembers(
                    ["state", "condition", "key", "path"], in: container)
                return .failed(
                    .configNotLocated(
                        key: try container.decode(String.self, forKey: WireKey(stringValue: "key")),
                        path: try container.decode(
                            String.self, forKey: WireKey(stringValue: "path"))
                    ))
            case .objectStoreNamesOutside:
                try BridgePayload.requireMembers(["state", "condition", "path"], in: container)
                return .failed(
                    .objectStoreNamesOutside(
                        path: try container.decode(
                            String.self, forKey: WireKey(stringValue: "path"))))
            case .objectStoreNotLocated:
                try BridgePayload.requireMembers(["state", "condition", "path"], in: container)
                return .failed(
                    .objectStoreNotLocated(
                        path: try container.decode(
                            String.self, forKey: WireKey(stringValue: "path"))))
            case .submoduleElsewhere:
                try BridgePayload.requireMembers(
                    ["state", "condition", "name", "path"], in: container)
                return .failed(
                    .submoduleElsewhere(
                        name: try container.decode(
                            String.self, forKey: WireKey(stringValue: "name")),
                        path: try container.decode(
                            String.self, forKey: WireKey(stringValue: "path"))
                    ))
            case .condition(let condition):
                try BridgePayload.requireMembers(["state", "condition"], in: container)
                return .failed(.condition(condition))
            }
        }
    }

    /// The Git item a `ka_reader_read_git` answer carries. Not optional: `pending` is an answer here
    /// and stays distinct from a NULL buffer and from anything that does not conform, both of which
    /// are `stopped` (CP-553 against CP-561).
    static func decodeGit(_ buffer: BridgeBuffer?) -> GitItem {
        guard let buffer,
            let answer = try? JSONDecoder().decode(GitAnswer.self, from: buffer.payload)
        else { return .stopped }
        return answer.item
    }
}
