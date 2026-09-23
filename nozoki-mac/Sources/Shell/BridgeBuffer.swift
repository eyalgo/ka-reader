import Foundation

/// An owned buffer the bridge returned: the payload's bytes, and the handle the caller gives
/// back to release it.
///
/// `Shell` cannot see the C struct, so a buffer is a Swift value. The `Nozoki` target builds
/// one from the C return and turns the handle back into the C pointer to free it.
public struct BridgeBuffer: Equatable, Sendable {
    public let payload: Data
    public let handle: UInt

    public init(payload: Data, handle: UInt) {
        self.payload = payload
        self.handle = handle
    }
}
