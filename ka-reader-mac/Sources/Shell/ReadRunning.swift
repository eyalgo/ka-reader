import Foundation
import Surfaces

/// Where a folder read runs: `read` off the main thread, then its result to `deliver` on the main
/// actor. A seam, so a test can run the read inline or hold it.
///
/// `read` returns the decoded listing and nothing else, so a bridge buffer never leaves the thread
/// that made it.
@MainActor
package protocol ReadRunning {
    func run<Answer: Sendable>(
        _ read: @escaping @Sendable () -> Answer,
        deliver: @escaping @MainActor @Sendable (Answer) -> Void)
}

/// The production runner: the read on a background queue, the delivery on a later main-queue turn.
/// The delivery never re-enters the caller, because it is dispatched rather than called.
package struct OffMainReadRunner: ReadRunning {
    package nonisolated init() {}

    package func run<Answer: Sendable>(
        _ read: @escaping @Sendable () -> Answer,
        deliver: @escaping @MainActor @Sendable (Answer) -> Void
    ) {
        DispatchQueue.global(qos: .userInitiated).async {
            let listing = read()
            DispatchQueue.main.async {
                MainActor.assumeIsolated { deliver(listing) }
            }
        }
    }
}

/// The tree acts' runner: every read runs off the main thread, one after another in the order they
/// were asked, so two acts the reader made reach the bridge in that order. The delivery is dispatched
/// to a later main-queue turn, as `OffMainReadRunner`'s is.
package struct SerialReadRunner: ReadRunning {
    private let queue = DispatchQueue(label: "ka-reader.tree-acts", qos: .userInitiated)

    package nonisolated init() {}

    package func run<Answer: Sendable>(
        _ read: @escaping @Sendable () -> Answer,
        deliver: @escaping @MainActor @Sendable (Answer) -> Void
    ) {
        queue.async {
            let listing = read()
            DispatchQueue.main.async {
                MainActor.assumeIsolated { deliver(listing) }
            }
        }
    }
}
