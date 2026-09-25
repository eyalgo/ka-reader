import Foundation
import Surfaces

/// Where a folder read runs: `read` off the main thread, then its result to `deliver` on the main
/// actor. A seam, so a test can run the read inline or hold it.
@MainActor
package protocol ReadRunning {
    func run(
        _ read: @escaping @Sendable () -> RootListing?,
        deliver: @escaping @MainActor (RootListing?) -> Void)
}

/// The production runner.
package struct OffMainReadRunner: ReadRunning {
    package nonisolated init() {}

    package func run(
        _ read: @escaping @Sendable () -> RootListing?,
        deliver: @escaping @MainActor (RootListing?) -> Void
    ) {}
}
