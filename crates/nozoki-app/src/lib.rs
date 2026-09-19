//! nozoki-app: the crate's public surface. No implementation lives here.

pub mod commands;
pub mod error;
pub mod log_writer;
pub use error::Error;

// Shared with the unit tests. It lives under `tests/common/` so `src/` holds no filesystem code but the log module's.
#[cfg(test)]
#[path = "../tests/common/mod.rs"]
#[allow(
    dead_code,
    reason = "each test crate uses a subset of the shared helpers"
)]
mod test_support;
