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
            static let reason = Key(stringValue: "reason")
            static let condition = Key(stringValue: "condition")
        }

        private enum StateTag: String, Decodable {
            case text
            case cannotDisplay = "cannot_display"
            case failed
            case pending
        }

        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: Key.self)
            let state = try container.decode(StateTag.self, forKey: .state)
            let expected: [String]
            switch state {
            case .text: expected = ["state", "content", "language"]
            case .cannotDisplay: expected = ["state", "reason"]
            case .failed: expected = ["state", "condition"]
            case .pending: expected = ["state"]
            }
            guard Set(container.allKeys.map(\.stringValue)) == Set(expected) else {
                throw DecodingError.dataCorruptedError(
                    forKey: .state, in: container,
                    debugDescription: "\(state.rawValue) has the wrong members")
            }
            switch state {
            case .text:
                verdict = .text(
                    try container.decode(String.self, forKey: .content),
                    try container.decode(Language.self, forKey: .language))
            case .cannotDisplay:
                verdict = .cannotDisplay(
                    try container.decode(CannotDisplayReason.self, forKey: .reason))
            case .failed:
                verdict = .failed(try container.decode(Condition.self, forKey: .condition))
            case .pending:
                verdict = nil
            }
        }
    }

    /// The verdict a `nozoki_select_file` answer carries, or `nil` for `pending`, a NULL buffer and
    /// anything that does not conform.
    static func decodeFile(_ buffer: BridgeBuffer?) -> FileVerdict? {
        guard let buffer else { return nil }
        return (try? JSONDecoder().decode(FileAnswer.self, from: buffer.payload))?.verdict
    }
}
