import CKAReaderBridge
import Foundation
import Shell
import Surfaces

/// The one C-backed bridge: `Shell`'s protocol over the seven exported functions.
///
/// It is the only type in the package that sees the C struct. A returned buffer is copied into a
/// Swift value the moment it arrives, and its pointer travels as the buffer's handle until the flow
/// gives it back to be released.
///
/// It holds no state and the C functions it calls are thread-safe on their own terms, so it is
/// `Sendable` and `nonisolated`: a folder read calls it from a background queue. It stays nonisolated
/// under this executable's main-actor default, for the same reason.
nonisolated struct NativeBridge: Bridging {
    func openFolder(location: URL, changes: ModelChangesReceiver?) -> BridgeBuffer? {
        // The context is the receiver, passed unretained: `LaunchFlow` holds its lifetime until the
        // open that replaces it has returned (SM-4). A `nil` receiver is a NULL callback and context.
        let context = unsafe changes.map { unsafe Unmanaged.passUnretained($0).toOpaque() }
        let callback: KAReaderModelChanged? = unsafe changes == nil ? nil : modelChangedTrampoline
        // The file-system representation, because a location's bytes need not be UTF-8: a string
        // round-trip through `path` would not preserve them.
        return unsafe location.withUnsafeFileSystemRepresentation {
            unsafe adopt(unsafe ka_reader_open_folder($0, callback, context))
        }
    }

    // Swift 6.3 counts `withCString` as an unsafe use and Swift 6.4 does not, and each rejects the
    // other's spelling under strict memory safety with warnings as errors: CI builds with 6.3.3
    // (`docs/nfdr.md` § 9) and a Mac may build with 6.4. The two branches make the same call.
    func listTree(path: String, act: DisclosureAct) -> BridgeBuffer? {
        let code: UInt32 =
            switch act {
            case .expand: 0
            case .collapse: 1
            }
        #if compiler(>=6.4)
            return path.withCString { unsafe adopt(unsafe ka_reader_list_tree($0, code)) }
        #else
            return unsafe path.withCString { unsafe adopt(unsafe ka_reader_list_tree($0, code)) }
        #endif
    }

    func selectFile(path: String, act: FileAct, position: String) -> BridgeBuffer? {
        let code: UInt32 =
            switch act {
            case .open: 0
            case .position: 1
            case .select: 2
            }
        #if compiler(>=6.4)
            return path.withCString { path in
                position.withCString { position in
                    unsafe adopt(unsafe ka_reader_select_file(path, code, position))
                }
            }
        #else
            return unsafe path.withCString { path in
                unsafe position.withCString { position in
                    unsafe adopt(unsafe ka_reader_select_file(path, code, position))
                }
            }
        #endif
    }

    func readGit() -> BridgeBuffer? {
        unsafe adopt(unsafe ka_reader_read_git())
    }

    // Same two branches as `listTree`, for the same reason.
    func openRelativeLink(path: String) -> BridgeBuffer? {
        #if compiler(>=6.4)
            return path.withCString { unsafe adopt(unsafe ka_reader_open_relative_link($0)) }
        #else
            return unsafe path.withCString {
                unsafe adopt(unsafe ka_reader_open_relative_link($0))
            }
        #endif
    }

    /// An `asset_bytes` refusal is a buffer with NULL `bytes` and `len` 0, which `adopt` would trap
    /// on. It is adopted without reading its bytes and keeps its handle so it is freed once. A
    /// non-NULL `bytes` with `len` 0 is an empty file's bytes, not a refusal (`KAReaderBuffer`).
    func assetBytes(path: String) -> BridgeBuffer? {
        #if compiler(>=6.4)
            return path.withCString { unsafe adoptAsset(unsafe ka_reader_asset_bytes($0)) }
        #else
            return unsafe path.withCString { unsafe adoptAsset(unsafe ka_reader_asset_bytes($0)) }
        #endif
    }

    func free(_ buffer: BridgeBuffer) {
        unsafe ka_reader_free(
            unsafe UnsafeMutablePointer<KAReaderBuffer>(bitPattern: buffer.handle))
    }

    @unsafe private func adoptAsset(_ raw: UnsafeMutablePointer<KAReaderBuffer>?) -> BridgeBuffer? {
        guard let raw = unsafe raw else {
            return nil
        }
        guard unsafe raw.pointee.bytes != nil else {
            return BridgeBuffer(payload: Data(), handle: UInt(bitPattern: raw), isRefusal: true)
        }
        return unsafe adopt(raw)
    }

    @unsafe private func adopt(_ raw: UnsafeMutablePointer<KAReaderBuffer>?) -> BridgeBuffer? {
        guard let raw = unsafe raw else {
            return nil
        }
        let payload = unsafe Data(bytes: raw.pointee.bytes, count: raw.pointee.len)
        return BridgeBuffer(payload: payload, handle: UInt(bitPattern: raw))
    }
}

/// The `model_changed` callback. It runs on a thread of the bridge's own, recovers the receiver from
/// the context, adopts the owned buffer as `adopt` does and hands it over; the receiver frees it.
private nonisolated let modelChangedTrampoline: KAReaderModelChanged = { context, raw in
    guard let context = unsafe context, let raw = unsafe raw else { return }
    let receiver = unsafe Unmanaged<ModelChangesReceiver>.fromOpaque(context)
        .takeUnretainedValue()
    let payload = unsafe Data(bytes: raw.pointee.bytes, count: raw.pointee.len)
    receiver.take(BridgeBuffer(payload: payload, handle: UInt(bitPattern: raw)))
}
