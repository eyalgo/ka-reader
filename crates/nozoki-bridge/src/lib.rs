//! nozoki-bridge: the crate's public surface. No implementation lives here.

pub mod boundary;
pub mod exports;
pub mod log_install;
pub mod log_writer;
pub mod session;

// Shared with the unit tests. It lives under `tests/common/` so `src/` holds no filesystem code but the log module's.
#[cfg(test)]
#[path = "../tests/common/mod.rs"]
#[allow(
    dead_code,
    reason = "each test crate uses a subset of the shared helpers"
)]
mod test_support;
