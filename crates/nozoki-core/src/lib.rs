//! nozoki-core: the crate's public surface. No implementation lives here.

mod error;
mod folder_model;
mod fs_reader;
mod language;

pub use error::Error;
pub use folder_model::{
    OpenFailure, OpenFolderOutcome, OpenedFolder, list_tree, open_folder, select_file,
};
pub use fs_reader::{
    CannotDisplayReason, Condition, Entry, EntryKind, FileContent, ItemState, Language,
};

// Shared with the integration tests, which reach the same file as `tests/common/mod.rs`.
#[cfg(test)]
#[path = "../tests/common/mod.rs"]
#[allow(
    dead_code,
    reason = "each test crate uses a subset of the shared helpers"
)]
mod test_support;
