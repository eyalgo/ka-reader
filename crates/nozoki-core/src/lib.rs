//! nozoki-core: the crate's public surface. No implementation lives here.

pub mod error;
pub mod fs_reader;
pub use error::Error;

// Shared with the integration tests, which reach the same file as `tests/common/mod.rs`.
#[cfg(test)]
#[path = "../tests/common/mod.rs"]
#[allow(
    dead_code,
    reason = "each test crate uses a subset of the shared helpers"
)]
mod test_support;
