//! ka-reader-core: the crate's public surface. No implementation lives here.

mod error;
mod folder_model;
mod fs_reader;
mod git_reader;
mod highlighter;
mod language;
mod markdown_renderer;

pub use error::Error;
pub use folder_model::{
    FileRead, FileRequest, FileView, FolderKind, FolderModel, GitCondition, GitState, ModelDelta,
    OpenFile, OpenFolderOutcome, OpenedFolder, PathReports, ReaderPlace, ReadingPosition,
    TreeChanges, TreeRequest, list_tree, open_folder, read_file, read_git, read_git_item,
    select_file,
};
#[cfg(feature = "testing")]
pub use fs_reader::fakes::SeededContainment;
pub use fs_reader::{
    CannotDisplayReason, Condition, ContainedEntry, ContainmentCheck, Entry, EntryKind,
    FolderContainment, ItemState, OpenFailure,
};
pub use git_reader::{
    BranchElement, ConfigNamedPath, GitPort, GitReadCondition, HeadState, Libgit2, ProbeCondition,
    RepositoryState, RootFinding, StatusCategory, StatusEntry, StatusLists, SubmoduleNamedPath,
};
pub use highlighter::{Span, TokenClass, highlight};
pub use language::Language;
pub use markdown_renderer::{
    Block, EmphasisStrength, HeadingLevel, ImageTarget, Inline, LinkTarget, ListKind,
    MarkdownDocument, PlaceholderCondition,
};

// Shared with the integration tests, which reach the same file as `tests/common/mod.rs`.
#[cfg(test)]
#[path = "../tests/common/mod.rs"]
#[allow(
    dead_code,
    reason = "each test crate uses a subset of the shared helpers"
)]
mod test_support;
