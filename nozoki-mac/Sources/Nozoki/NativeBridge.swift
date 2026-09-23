import CNozokiBridge
import Foundation
import Shell

/// The one C-backed bridge: `Shell`'s protocol over the three exported functions.
///
/// It is the only type in the package that sees the C struct. A returned buffer is copied into a
/// Swift value the moment it arrives, and its pointer travels as the buffer's handle until the flow
/// gives it back to be released.
struct NativeBridge: Bridging {
    func openFolder(location: URL?) -> BridgeBuffer? {
        guard let location else {
            return adopt(nozoki_open_folder(nil))
        }
        // The file-system representation, because a location's bytes need not be UTF-8: a string
        // round-trip through `path` would not preserve them.
        return location.withUnsafeFileSystemRepresentation { adopt(nozoki_open_folder($0)) }
    }

    func listTree(path: String) -> BridgeBuffer? {
        path.withCString { adopt(nozoki_list_tree($0)) }
    }

    func free(_ buffer: BridgeBuffer) {
        nozoki_free(UnsafeMutablePointer<NozokiBuffer>(bitPattern: buffer.handle))
    }

    private func adopt(_ raw: UnsafeMutablePointer<NozokiBuffer>?) -> BridgeBuffer? {
        guard let raw else {
            return nil
        }
        let payload = Data(bytes: raw.pointee.bytes, count: raw.pointee.len)
        return BridgeBuffer(payload: payload, handle: UInt(bitPattern: raw))
    }
}
