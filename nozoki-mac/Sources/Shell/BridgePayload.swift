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

            init?(stringValue: String) {
                self.stringValue = stringValue
            }

            let intValue: Int? = nil

            init?(intValue: Int) {
                return nil
            }

            static let state = Key(stringValue: "state")!
            static let condition = Key(stringValue: "condition")!
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
}
