import Foundation
import Surfaces

/// Where a folder read runs: `read` off the main thread, then its result to `deliver` on the main
/// actor. A seam, so a test can run the read inline or hold it.
///
/// `read` returns the decoded listing and nothing else, so a bridge buffer never leaves the thread
/// that made it.
@MainActor
package protocol ReadRunning {
    func run(
        _ read: @escaping @Sendable () -> RootListing?,
        deliver: @escaping @MainActor (RootListing?) -> Void)
}

/// The production runner: the read on a background queue, the delivery on a later main-queue turn.
/// The delivery never re-enters the caller, because it is dispatched rather than called.
package struct OffMainReadRunner: ReadRunning {
    package nonisolated init() {}

    package func run(
        _ read: @escaping @Sendable () -> RootListing?,
        deliver: @escaping @MainActor (RootListing?) -> Void
    ) {
        DispatchQueue.global(qos: .userInitiated).async {
            let listing = read()
            DispatchQueue.main.async {
                MainActor.assumeIsolated { deliver(listing) }
            }
        }
    }
}
