import CKAReaderBridge
import Foundation
import Shell

/// The one C-backed bridge: `Shell`'s protocol over the five exported functions.
///
/// It is the only type in the package that sees the C struct. A returned buffer is copied into a
/// Swift value the moment it arrives, and its pointer travels as the buffer's handle until the flow
/// gives it back to be released.
struct NativeBridge: Bridging {
    func openFolder(location: URL) -> BridgeBuffer? {
        // The file-system representation, because a location's bytes need not be UTF-8: a string
        // round-trip through `path` would not preserve them.
        return location.withUnsafeFileSystemRepresentation { adopt(ka_reader_open_folder($0)) }
    }

    func listTree(path: String) -> BridgeBuffer? {
        path.withCString { adopt(ka_reader_list_tree($0)) }
    }

    func selectFile(path: String) -> BridgeBuffer? {
        path.withCString { adopt(ka_reader_select_file($0)) }
    }

    func readGit() -> BridgeBuffer? {
        adopt(ka_reader_read_git())
    }

    func free(_ buffer: BridgeBuffer) {
        ka_reader_free(UnsafeMutablePointer<KAReaderBuffer>(bitPattern: buffer.handle))
    }

    private func adopt(_ raw: UnsafeMutablePointer<KAReaderBuffer>?) -> BridgeBuffer? {
        guard let raw else {
            return nil
        }
        let payload = Data(bytes: raw.pointee.bytes, count: raw.pointee.len)
        return BridgeBuffer(payload: payload, handle: UInt(bitPattern: raw))
    }
}
