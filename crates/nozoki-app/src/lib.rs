//! nozoki-app: the crate's public surface. No implementation lives here.

pub mod error;
pub mod log_writer;
pub use error::Error;

#[cfg(test)]
mod test_support;
