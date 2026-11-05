import Foundation
import Testing

@testable import Shell

/// A delivery that holds every piece of work it is handed, so a test decides when the main actor
/// runs it. It records the order of what touched it into the shared log.
private final class HoldingMainDelivery: MainDelivering, @unchecked Sendable {
    // `@unchecked Sendable` because the receiver calls it from a background thread and the test
    // releases from the main actor. The lock is enough: `held` is read and written only inside it.
    private let lock = NSLock()
    private var held: [@MainActor @Sendable () -> Void] = []
    private let log: EventLog

    init(log: EventLog) {
        self.log = log
    }

    var heldCount: Int { lock.withLock { held.count } }

    func deliver(_ work: @escaping @MainActor @Sendable () -> Void) {
        log.record("scheduled")
        lock.withLock { held.append(work) }
    }

    /// Runs every held piece of work, on the main actor.
    @MainActor
    func releaseAll() {
        let work = lock.withLock {
            let all = held
            held = []
            return all
        }
        for piece in work { piece() }
    }
}

/// What the receiver's handler was given, noted on the main actor.
@MainActor
private final class Delivered {
    var payloads: [Data] = []
    var onMain: [Bool] = []
    var freedAtDelivery: [[UInt]] = []
}

@MainActor
struct ModelChangesReceiverTests {
    private func makeReceiver(
        bridge: RecordingBridge, delivery: HoldingMainDelivery, into delivered: Delivered
    ) -> ModelChangesReceiver {
        ModelChangesReceiver(bridge: bridge, main: delivery) { _, payload in
            delivered.payloads.append(payload)
            delivered.onMain.append(Thread.isMainThread)
            delivered.freedAtDelivery.append(bridge.freed)
        }
    }

    private func buffer(_ text: String, handle: UInt) -> BridgeBuffer {
        BridgeBuffer(payload: Data(text.utf8), handle: handle)
    }

    @Test func aBufferTakenOnABackgroundThreadIsHandedToTheSeamOnTheMainThread() async {
        let log = EventLog()
        let bridge = RecordingBridge(log: log)
        let delivery = HoldingMainDelivery(log: log)
        let delivered = Delivered()
        let receiver = makeReceiver(bridge: bridge, delivery: delivery, into: delivered)
        let taken = buffer(#"{"listings":[]}"#, handle: 7)

        await withCheckedContinuation { continuation in
            DispatchQueue.global().async {
                receiver.take(taken)
                continuation.resume()
            }
        }

        #expect(delivery.heldCount == 1)
        #expect(delivered.payloads.isEmpty, "nothing runs until the main actor takes the work")

        delivery.releaseAll()

        #expect(delivered.payloads == [taken.payload])
        #expect(delivered.onMain == [true])
    }

    @Test func eachBufferIsFreedExactlyOnce() {
        let log = EventLog()
        let bridge = RecordingBridge(log: log)
        let delivery = HoldingMainDelivery(log: log)
        let delivered = Delivered()
        let receiver = makeReceiver(bridge: bridge, delivery: delivery, into: delivered)

        for handle: UInt in [3, 4, 5] { receiver.take(buffer("{}", handle: handle)) }
        delivery.releaseAll()

        #expect(bridge.freed == [3, 4, 5])
        #expect(delivered.payloads.count == 3)
    }

    @Test func theCopyIsHandedOnAfterTheBufferIsFreed() {
        let log = EventLog()
        let bridge = RecordingBridge(log: log)
        let delivery = HoldingMainDelivery(log: log)
        let delivered = Delivered()
        let receiver = makeReceiver(bridge: bridge, delivery: delivery, into: delivered)
        let taken = buffer(#"{"listings":[{"path":"","answer":{"state":"pending"}}]}"#, handle: 9)

        receiver.take(taken)

        #expect(log.events == ["free", "scheduled"])

        delivery.releaseAll()

        #expect(delivered.payloads == [taken.payload])
        #expect(delivered.freedAtDelivery == [[9]])
    }
}
