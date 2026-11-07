import Foundation

/// An owned buffer the bridge returned: the payload's bytes, and the handle the caller gives
/// back to release it.
///
/// `Shell` cannot see the C struct, so a buffer is a Swift value. The `KAReader` target builds
/// one from the C return and turns the handle back into the C pointer to free it.
package struct BridgeBuffer: Equatable, Sendable {
    package let payload: Data
    package let handle: UInt

    /// Whether this is an `asset_bytes` refusal: a buffer with no bytes at all, which still carries
    /// its handle so it is released once. An empty file's bytes are an empty payload that is not a
    /// refusal. Every other function's buffer is a non-refusal.
    package let isRefusal: Bool

    package init(payload: Data, handle: UInt, isRefusal: Bool = false) {
        self.payload = payload
        self.handle = handle
        self.isRefusal = isRefusal
    }
}
