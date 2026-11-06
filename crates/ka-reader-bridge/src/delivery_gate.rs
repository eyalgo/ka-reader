//! The delivery gate of one grant: it lets a `model_changed` delivery run only while the grant is
//! live, and lets a replacing open wait for the deliveries still in flight (SM-4's lifetime).
//! It counts deliveries rather than holding a lock while one runs, so a delivery that calls the
//! session from inside itself cannot deadlock against it.

use std::sync::{Condvar, Mutex, MutexGuard, PoisonError};

use crate::session::Delivery;

#[derive(Default)]
struct GateState {
    closed: bool,
    in_flight: usize,
}

/// Open while its grant is live; closed, once and for good, by the open that replaces the grant.
///
/// # Examples
///
/// ```
/// use std::sync::Arc;
/// use std::sync::atomic::{AtomicUsize, Ordering};
/// use ka_reader_bridge::delivery_gate::DeliveryGate;
///
/// let gate = DeliveryGate::default();
/// let calls = Arc::new(AtomicUsize::new(0));
/// let counted = Arc::clone(&calls);
/// let delivery: ka_reader_bridge::session::Delivery =
///     Arc::new(move |_payload| { counted.fetch_add(1, Ordering::SeqCst); });
///
/// gate.deliver(&delivery, Vec::new());
/// gate.close();
/// gate.deliver(&delivery, Vec::new());
///
/// assert_eq!(calls.load(Ordering::SeqCst), 1, "nothing is delivered once the gate is closed");
/// ```
#[derive(Default)]
pub struct DeliveryGate {
    state: Mutex<GateState>,
    idle: Condvar,
}

/// Leaves the gate when a delivery ends, however it ends.
struct Leave<'a>(&'a DeliveryGate);

impl Drop for Leave<'_> {
    fn drop(&mut self) {
        let mut state = self.0.lock();
        state.in_flight -= 1;
        self.0.idle.notify_all();
    }
}

impl DeliveryGate {
    fn lock(&self) -> MutexGuard<'_, GateState> {
        self.state.lock().unwrap_or_else(PoisonError::into_inner)
    }

    /// Calls `delivery` with `payload` if the gate is open, with no lock held; once closed it
    /// calls nothing.
    pub fn deliver(&self, delivery: &Delivery, payload: Vec<u8>) {
        {
            let mut state = self.lock();
            if state.closed {
                return;
            }
            state.in_flight += 1;
        }
        let _leave = Leave(self);
        delivery(payload);
    }

    /// Closes the gate and waits until every delivery in flight has ended.
    pub fn close(&self) {
        let mut state = self.lock();
        state.closed = true;
        while state.in_flight > 0 {
            state = self
                .idle
                .wait(state)
                .unwrap_or_else(PoisonError::into_inner);
        }
    }
}
