import Foundation
import Surfaces

/// Reads the bridge's JSON payloads. Anything that does not conform reads as the failure value:
/// not opened, or no entries.
enum BridgePayload {
    private struct OpenResult: Decodable {
        let opened: Bool
    }

    static func decodeOpened(_ buffer: BridgeBuffer?) -> Bool {
        guard let buffer else { return false }
        let result = try? JSONDecoder().decode(OpenResult.self, from: buffer.payload)
        return result?.opened ?? false
    }

    static func decodeEntries(_ buffer: BridgeBuffer?) -> [Entry] {
        guard let buffer else { return [] }
        return (try? JSONDecoder().decode([Entry].self, from: buffer.payload)) ?? []
    }
}
