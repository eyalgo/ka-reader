import Foundation

/// An owned buffer the bridge returned: the payload's bytes, and the handle the caller gives
/// back to release it.
///
/// `Shell` cannot see the C struct, so a buffer is a Swift value. The `KAReader` target builds
/// one from the C return and turns the handle back into the C pointer to free it.
package struct BridgeBuffer: Equatable, Sendable {
    package let payload: Data
    package let handle: UInt

    package init(payload: Data, handle: UInt) {
        self.payload = payload
        self.handle = handle
    }
}
