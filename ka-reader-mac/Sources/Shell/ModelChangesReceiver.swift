import Foundation

/// Where work goes to run on the main actor: later, and never inside the caller. A seam, so a test
/// can hold the work and release it when it chooses. The bridge's callback arrives on a thread of
/// its own, so a delivery crosses to the main actor here and nowhere else.
package protocol MainDelivering: Sendable {
    func deliver(_ work: @escaping @MainActor @Sendable () -> Void)
}

/// The production seam: the work runs on a later main-queue turn.
package struct MainQueueDelivery: MainDelivering {
    package init() {}

    package func deliver(_ work: @escaping @MainActor @Sendable () -> Void) {
        DispatchQueue.main.async {
            MainActor.assumeIsolated { work() }
        }
    }
}

/// The shell's side of one open's `model_changed` callback. One is made for each open, so it also
/// names the grant its deliveries belong to.
///
/// The bridge hands over an owned buffer on any thread, and this takes it: it copies the bytes,
/// frees the buffer once through the bridge, and only then hands the copy to the main actor. The
/// buffer never outlives the call, and the main actor never sees one.
package final class ModelChangesReceiver: Sendable {
    /// What the main actor does with a delivery: the receiver it came through, and the payload.
    package typealias Handler = @MainActor @Sendable (ModelChangesReceiver, Data) -> Void

    private let bridge: any Bridging
    private let main: any MainDelivering
    private let handler: Handler

    package init(bridge: any Bridging, main: any MainDelivering, handler: @escaping Handler) {
        self.bridge = bridge
        self.main = main
        self.handler = handler
    }

    /// Takes one buffer the bridge delivered, on any thread.
    package func take(_ buffer: BridgeBuffer) {
        let payload = buffer.payload
        bridge.free(buffer)
        main.deliver { [self] in handler(self, payload) }
    }
}
