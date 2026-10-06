//! The open-and-list state behind the bridge's two calls, and their wire shapes. Every operation
//! delegates to `nozoki-core` and only formats the result (QC-13). It never presents a panel: the
//! location comes in as a plain `Option<PathBuf>`, so none of this needs a window or a runtime.

use std::path::PathBuf;
use std::sync::atomic::{AtomicBool, Ordering};
use std::sync::{Arc, Mutex, MutexGuard, PoisonError};

use nozoki_core::{
    BranchElement, CannotDisplayReason, Condition, ConfigNamedPath, EntryKind, FileView,
    FolderKind, FolderModel, GitCondition, GitPort, GitReadCondition, ItemState, Language,
    OpenFailure, OpenFolderOutcome, OpenedFolder, ProbeCondition, RepositoryState, Span,
    StatusCategory, StatusEntry, TokenClass, list_tree, open_folder, read_git, select_file,
};
use serde::Serialize;

use crate::machine_config::{SwitchOutcome, arrive_in_process, production_port};

/// What `open_folder` answers across the bridge.
#[derive(Debug, Clone, Copy, PartialEq, Eq, Serialize)]
#[serde(tag = "state", rename_all = "snake_case")]
pub enum OpenResult {
    Opened,
    Failed { condition: OpenFailureDto },
}

#[derive(Debug, Clone, Copy, PartialEq, Eq, Serialize)]
#[serde(rename_all = "snake_case")]
pub enum OpenFailureDto {
    Missing,
    NotAFolder,
    Unreadable,
}

impl From<OpenFailure> for OpenFailureDto {
    fn from(failure: OpenFailure) -> Self {
        match failure {
            OpenFailure::Missing => Self::Missing,
            OpenFailure::NotAFolder => Self::NotAFolder,
            OpenFailure::Unreadable => Self::Unreadable,
        }
    }
}

/// An entry's kind on the wire: `"folder"` or `"file"`.
#[derive(Debug, Clone, Copy, PartialEq, Eq, Serialize)]
#[serde(rename_all = "lowercase")]
pub enum KindDto {
    Folder,
    File,
}

impl From<EntryKind> for KindDto {
    fn from(kind: EntryKind) -> Self {
        match kind {
            EntryKind::Folder => Self::Folder,
            EntryKind::File => Self::File,
        }
    }
}

/// A failure's condition on the wire, one string from the closed set: `"unreadable"`, `"outside"`,
/// `"cycle"`, `"missing"`, `"not_a_folder"` or `"too_many_links"`. It carries no text and no path.
#[derive(Debug, Clone, Copy, PartialEq, Eq, Serialize)]
#[serde(rename_all = "snake_case")]
pub enum ConditionDto {
    Unreadable,
    Outside,
    Cycle,
    Missing,
    NotAFolder,
    TooManyLinks,
}

impl From<Condition> for ConditionDto {
    fn from(condition: Condition) -> Self {
        match condition {
            Condition::Unreadable => Self::Unreadable,
            Condition::Outside => Self::Outside,
            Condition::Cycle => Self::Cycle,
            Condition::Missing => Self::Missing,
            Condition::NotAFolder => Self::NotAFolder,
            Condition::TooManyLinks => Self::TooManyLinks,
        }
    }
}

/// An entry's state on the wire, tagged by `state`. `condition` appears only beside `"failed"`.
#[derive(Debug, Clone, Copy, PartialEq, Eq, Serialize)]
#[serde(tag = "state", rename_all = "snake_case")]
pub enum EntryStateDto {
    Pending,
    Observed,
    Failed { condition: ConditionDto },
}

impl From<ItemState<()>> for EntryStateDto {
    fn from(state: ItemState<()>) -> Self {
        match state {
            ItemState::Pending => Self::Pending,
            ItemState::Observed(()) => Self::Observed,
            ItemState::Failed(condition) => Self::Failed {
                condition: condition.into(),
            },
        }
    }
}

/// One listed entry on the wire: `name`, `path`, `kind` and `state`, and `condition` when failed,
/// and `language` on a file entry. The bridge carries core's language over as it is and decides
/// none: a folder entry has no `language` member.
#[derive(Debug, Clone, PartialEq, Eq, Serialize)]
pub struct EntryDto {
    pub name: String,
    pub path: String,
    pub kind: KindDto,
    #[serde(flatten)]
    pub state: EntryStateDto,
    #[serde(skip_serializing_if = "Option::is_none")]
    pub language: Option<LanguageDto>,
}

/// What `list_tree` answers across the bridge, tagged by `state`: `observed` with its entries in
/// core's order, `failed` with a condition, or `pending` when nothing was read.
#[derive(Debug, Clone, PartialEq, Eq, Serialize)]
#[serde(tag = "state", rename_all = "snake_case")]
pub enum ListAnswerDto {
    Observed { entries: Vec<EntryDto> },
    Failed { condition: ConditionDto },
    Pending,
}

/// A text file's language on the wire, one string from the closed set: `"python"`, `"shell"`,
/// `"javascript"`, `"json"`, `"yaml"`, `"toml"` or `"plain"`.
#[derive(Debug, Clone, Copy, PartialEq, Eq, Serialize)]
#[serde(rename_all = "snake_case")]
pub enum LanguageDto {
    Python,
    Shell,
    Javascript,
    Json,
    Yaml,
    Toml,
    Plain,
}

impl From<Language> for LanguageDto {
    fn from(language: Language) -> Self {
        // Every value is named, with no wildcard arm, so a language added to the core is a compile
        // error here and not a silent `plain`.
        match language {
            Language::Python => Self::Python,
            Language::Shell => Self::Shell,
            Language::JavaScript => Self::Javascript,
            Language::Json => Self::Json,
            Language::Yaml => Self::Yaml,
            Language::Toml => Self::Toml,
            Language::Plain => Self::Plain,
        }
    }
}

/// A span's class on the wire, one string from the closed set: `"keyword"`, `"string"`,
/// `"number"`, `"comment"` or `"name"`.
#[derive(Debug, Clone, Copy, PartialEq, Eq, Serialize)]
#[serde(rename_all = "snake_case")]
pub enum TokenClassDto {
    Keyword,
    String,
    Number,
    Comment,
    Name,
}

impl From<TokenClass> for TokenClassDto {
    fn from(class: TokenClass) -> Self {
        match class {
            TokenClass::Keyword => Self::Keyword,
            TokenClass::String => Self::String,
            TokenClass::Number => Self::Number,
            TokenClass::Comment => Self::Comment,
            TokenClass::Name => Self::Name,
        }
    }
}

/// One span on the wire: `start` and `end` are UTF-8 byte offsets into the answer's `content`, and
/// `class` names its token.
#[derive(Debug, Clone, Copy, PartialEq, Eq, Serialize)]
pub struct SpanDto {
    pub start: usize,
    pub end: usize,
    pub class: TokenClassDto,
}

impl From<Span> for SpanDto {
    fn from(span: Span) -> Self {
        Self {
            start: span.start,
            end: span.end,
            class: span.class.into(),
        }
    }
}

/// Why a file cannot be shown as text, on the wire: `"invalid_utf8"` or `"invalid_utf16"`.
#[derive(Debug, Clone, Copy, PartialEq, Eq, Serialize)]
#[serde(rename_all = "snake_case")]
pub enum CannotDisplayReasonDto {
    InvalidUtf8,
    InvalidUtf16,
}

impl From<CannotDisplayReason> for CannotDisplayReasonDto {
    fn from(reason: CannotDisplayReason) -> Self {
        match reason {
            CannotDisplayReason::InvalidUtf8 => Self::InvalidUtf8,
            CannotDisplayReason::InvalidUtf16 => Self::InvalidUtf16,
        }
    }
}

/// What `select_file` answers across the bridge, tagged by `state`: `text` with its decoded
/// `content`, its `language` and, for a floor language, its `spans`; `cannot_display` with a
/// `reason`; `failed` with a `condition`; or `pending` when nothing was read.
#[derive(Debug, Clone, PartialEq, Eq, Serialize)]
#[serde(tag = "state", rename_all = "snake_case")]
pub enum FileAnswerDto {
    Text {
        content: String,
        language: LanguageDto,
        /// Present exactly when `language` is a floor language, even as `[]`; a plain answer has
        /// no such member. Keyed on the language, never on emptiness.
        #[serde(skip_serializing_if = "Option::is_none")]
        spans: Option<Vec<SpanDto>>,
    },
    CannotDisplay {
        reason: CannotDisplayReasonDto,
    },
    Failed {
        condition: ConditionDto,
    },
    Pending,
}

impl From<ItemState<FileView>> for FileAnswerDto {
    fn from(state: ItemState<FileView>) -> Self {
        match state {
            ItemState::Observed(FileView::Text {
                content,
                language,
                spans,
            }) => Self::Text {
                content,
                spans: match language {
                    Language::Plain => None,
                    Language::Python
                    | Language::Shell
                    | Language::JavaScript
                    | Language::Json
                    | Language::Yaml
                    | Language::Toml => Some(spans.into_iter().map(SpanDto::from).collect()),
                },
                language: language.into(),
            },
            ItemState::Observed(FileView::CannotDisplay(reason)) => Self::CannotDisplay {
                reason: reason.into(),
            },
            ItemState::Failed(condition) => Self::Failed {
                condition: condition.into(),
            },
            ItemState::Pending => Self::Pending,
        }
    }
}

/// The Git item on the wire, tagged by `state` and holding exactly the members its state names:
/// `pending` and nothing else; `observed` with its `kind`; or `failed` with a `condition`, plus
/// `git_directory` only beside `git_directory_outside`, `key` and `path` beside
/// `config_names_outside` and `config_not_located`, and `path` alone beside
/// `object_store_names_outside`. The bridge carries the core's item and decides nothing: no count,
/// wording or sort key crosses (CP-543).
#[derive(Debug, Clone, PartialEq, Eq, Serialize)]
#[serde(tag = "state", rename_all = "snake_case")]
pub enum GitAnswerDto {
    Pending,
    Observed(ObservedGitDto),
    Failed {
        condition: GitConditionDto,
        #[serde(skip_serializing_if = "Option::is_none")]
        git_directory: Option<String>,
        #[serde(skip_serializing_if = "Option::is_none")]
        key: Option<String>,
        #[serde(skip_serializing_if = "Option::is_none")]
        path: Option<String>,
    },
}

/// What an observed Git item is: a plain folder, or a repository's top level with its four parts.
#[derive(Debug, Clone, PartialEq, Eq, Serialize)]
#[serde(tag = "kind", rename_all = "snake_case")]
pub enum ObservedGitDto {
    Plain,
    Root {
        branch: BranchDto,
        repository_state: RepositoryStateDto,
        staged: Vec<GitEntryDto>,
        changed: Vec<GitEntryDto>,
    },
}

/// The branch element on the wire: a branch's short name, or a detached HEAD's full identifier.
#[derive(Debug, Clone, PartialEq, Eq, Serialize)]
#[serde(tag = "kind", rename_all = "snake_case")]
pub enum BranchDto {
    Branch { name: String },
    Detached { commit: String },
}

/// A repository state on the wire, one string from the closed set: `"normal"`, `"merge"`,
/// `"rebase"`, `"cherry_pick"`, `"revert"`, `"bisect"`, `"am"` or `"detached_head"`.
#[derive(Debug, Clone, Copy, PartialEq, Eq, Serialize)]
#[serde(rename_all = "snake_case")]
pub enum RepositoryStateDto {
    Normal,
    Merge,
    Rebase,
    CherryPick,
    Revert,
    Bisect,
    Am,
    DetachedHead,
}

/// A status category on the wire, one string from the closed set: `"added"`, `"modified"`,
/// `"deleted"`, `"renamed"`, `"untracked"` or `"in_conflict"`.
#[derive(Debug, Clone, Copy, PartialEq, Eq, Serialize)]
#[serde(rename_all = "snake_case")]
pub enum StatusCategoryDto {
    Added,
    Modified,
    Deleted,
    Renamed,
    Untracked,
    InConflict,
}

/// One listed entry: `path` and `category`, and `from` only where the category is `renamed`.
#[derive(Debug, Clone, PartialEq, Eq, Serialize)]
pub struct GitEntryDto {
    pub path: String,
    pub category: StatusCategoryDto,
    #[serde(skip_serializing_if = "Option::is_none")]
    pub from: Option<String>,
}

/// A failed Git item's condition on the wire, one string from the closed set of fifteen. Five of
/// the probe's conditions carry a `probe_` prefix, because two share names with read conditions.
/// The two config conditions and the object store condition are each one value for the probe and
/// the reads: one message whichever operation met it.
#[derive(Debug, Clone, Copy, PartialEq, Eq, Serialize)]
#[serde(rename_all = "snake_case")]
pub enum GitConditionDto {
    ProbeFolderUnavailable,
    ProbeGitDirectoryUnreadable,
    ProbeGitEntryNotDirectory,
    ProbeGitFileUnreadable,
    ProbeRepositoryReadFailed,
    GitDirectoryOutside,
    NotARoot,
    GitDirectoryMissing,
    GitDirectoryUnreadable,
    NotARepository,
    RepositoryReadFailed,
    MachineConfigNotSwitchedOff,
    ConfigNamesOutside,
    ObjectStoreNamesOutside,
    ConfigNotLocated,
}

impl From<RepositoryState> for RepositoryStateDto {
    fn from(state: RepositoryState) -> Self {
        // Every state is named, with no wildcard arm, so a state the core adds is a compile error
        // here and never silently merged.
        match state {
            RepositoryState::Normal => Self::Normal,
            RepositoryState::Merge => Self::Merge,
            RepositoryState::Rebase => Self::Rebase,
            RepositoryState::CherryPick => Self::CherryPick,
            RepositoryState::Revert => Self::Revert,
            RepositoryState::Bisect => Self::Bisect,
            RepositoryState::Am => Self::Am,
            RepositoryState::DetachedHead => Self::DetachedHead,
        }
    }
}

impl From<BranchElement> for BranchDto {
    fn from(branch: BranchElement) -> Self {
        match branch {
            BranchElement::Branch(name) => Self::Branch { name },
            BranchElement::Detached(commit) => Self::Detached { commit },
        }
    }
}

impl From<StatusEntry> for GitEntryDto {
    fn from(entry: StatusEntry) -> Self {
        let (category, from) = match entry.category {
            StatusCategory::Added => (StatusCategoryDto::Added, None),
            StatusCategory::Modified => (StatusCategoryDto::Modified, None),
            StatusCategory::Deleted => (StatusCategoryDto::Deleted, None),
            StatusCategory::Renamed { from } => (StatusCategoryDto::Renamed, Some(from)),
            StatusCategory::Untracked => (StatusCategoryDto::Untracked, None),
            StatusCategory::InConflict => (StatusCategoryDto::InConflict, None),
        };
        Self {
            path: entry.path,
            category,
            from,
        }
    }
}

impl From<&ProbeCondition> for GitConditionDto {
    fn from(condition: &ProbeCondition) -> Self {
        match condition {
            ProbeCondition::FolderUnavailable => Self::ProbeFolderUnavailable,
            ProbeCondition::GitDirectoryUnreadable => Self::ProbeGitDirectoryUnreadable,
            ProbeCondition::GitEntryNotDirectory => Self::ProbeGitEntryNotDirectory,
            ProbeCondition::GitFileUnreadable => Self::ProbeGitFileUnreadable,
            ProbeCondition::RepositoryReadFailed => Self::ProbeRepositoryReadFailed,
            ProbeCondition::ConfigNamesOutside(_) => Self::ConfigNamesOutside,
            ProbeCondition::ConfigNotLocated(_) => Self::ConfigNotLocated,
            ProbeCondition::ObjectStoreNamesOutside(_) => Self::ObjectStoreNamesOutside,
        }
    }
}

impl GitAnswerDto {
    /// The answer when the machine-level config could not be switched off. It has no core item, and it
    /// holds no path and no library text.
    pub fn machine_config_not_switched_off() -> Self {
        Self::failed(GitConditionDto::MachineConfigNotSwitchedOff)
    }

    fn failed(condition: GitConditionDto) -> Self {
        Self::Failed {
            condition,
            git_directory: None,
            key: None,
            path: None,
        }
    }

    /// The config condition's answer, whichever operation met it. The core has already spelled the
    /// key and the path lossily, so both cross as the strings the core holds.
    fn config_names_outside(named: &ConfigNamedPath) -> Self {
        Self::config_refused(GitConditionDto::ConfigNamesOutside, named)
    }

    /// The not-located condition's answer: the same four members, under its own condition.
    fn config_not_located(named: &ConfigNamedPath) -> Self {
        Self::config_refused(GitConditionDto::ConfigNotLocated, named)
    }

    fn config_refused(condition: GitConditionDto, named: &ConfigNamedPath) -> Self {
        Self::Failed {
            condition,
            git_directory: None,
            key: Some(named.key.clone()),
            path: Some(named.path.clone()),
        }
    }

    /// The object store condition's answer, whichever operation met it. The core has already spelled
    /// the value lossily, so it crosses as the string the core holds, in `path` alone.
    fn object_store_names_outside(value: &str) -> Self {
        Self::Failed {
            condition: GitConditionDto::ObjectStoreNamesOutside,
            git_directory: None,
            key: None,
            path: Some(value.to_string()),
        }
    }
}

impl From<&ItemState<FolderKind, GitCondition>> for GitAnswerDto {
    fn from(item: &ItemState<FolderKind, GitCondition>) -> Self {
        match item {
            ItemState::Pending => Self::Pending,
            ItemState::Observed(FolderKind::Plain) => Self::Observed(ObservedGitDto::Plain),
            ItemState::Observed(FolderKind::Root(git)) => Self::Observed(ObservedGitDto::Root {
                branch: git.head().branch.clone().into(),
                repository_state: git.head().state.into(),
                staged: git
                    .status()
                    .staged
                    .iter()
                    .cloned()
                    .map(Into::into)
                    .collect(),
                changed: git
                    .status()
                    .changed
                    .iter()
                    .cloned()
                    .map(Into::into)
                    .collect(),
            }),
            ItemState::Failed(GitCondition::Probe(ProbeCondition::ConfigNamesOutside(named))) => {
                Self::config_names_outside(named)
            }
            ItemState::Failed(GitCondition::Probe(ProbeCondition::ConfigNotLocated(named))) => {
                Self::config_not_located(named)
            }
            ItemState::Failed(GitCondition::Probe(ProbeCondition::ObjectStoreNamesOutside(
                value,
            ))) => Self::object_store_names_outside(value),
            ItemState::Failed(GitCondition::Probe(condition)) => Self::failed(condition.into()),
            ItemState::Failed(GitCondition::Read(condition)) => match condition {
                GitReadCondition::GitDirectoryOutside(path) => Self::Failed {
                    // Lossy, as the core spells every other path: serde's `PathBuf` impl fails on a
                    // non-UTF-8 path and would turn the whole answer into NULL.
                    condition: GitConditionDto::GitDirectoryOutside,
                    git_directory: Some(path.to_string_lossy().into_owned()),
                    key: None,
                    path: None,
                },
                GitReadCondition::NotARoot => Self::failed(GitConditionDto::NotARoot),
                GitReadCondition::GitDirectoryMissing => {
                    Self::failed(GitConditionDto::GitDirectoryMissing)
                }
                GitReadCondition::GitDirectoryUnreadable => {
                    Self::failed(GitConditionDto::GitDirectoryUnreadable)
                }
                GitReadCondition::NotARepository => Self::failed(GitConditionDto::NotARepository),
                GitReadCondition::RepositoryReadFailed => {
                    Self::failed(GitConditionDto::RepositoryReadFailed)
                }
                GitReadCondition::ConfigNamesOutside(named) => Self::config_names_outside(named),
                GitReadCondition::ConfigNotLocated(named) => Self::config_not_located(named),
                GitReadCondition::ObjectStoreNamesOutside(value) => {
                    Self::object_store_names_outside(value)
                }
            },
        }
    }
}

/// What one arrival at the composition root yields: the Git port to read through, or the fact that
/// the machine-level config could not be switched off, so no port exists in this process.
#[derive(Clone)]
pub enum Wiring {
    Wired(Arc<dyn GitPort + Send + Sync>),
    SwitchFailed,
}

/// One arrival at the composition root, made on each successful open.
type Arrival = Box<dyn Fn() -> Wiring + Send + Sync>;

/// The wiring a switch outcome allows: `port` is called, to make the adapter, only behind
/// [`SwitchOutcome::Off`]. A failed switch makes no port.
pub(crate) fn arrive_wiring(
    outcome: SwitchOutcome,
    port: impl FnOnce() -> Arc<dyn GitPort + Send + Sync>,
) -> Wiring {
    match outcome {
        SwitchOutcome::Off => Wiring::Wired(port()),
        SwitchOutcome::Failed => Wiring::SwitchFailed,
    }
}

/// The production arrival: runs the process's switch and, once it is off, hands out the production
/// port (QC-17).
fn production_arrival() -> Wiring {
    arrive_wiring(arrive_in_process(), production_port)
}

/// An opened folder as a model, with the wiring of the arrival its open made and a token naming that
/// open, so a read answers only for the open it was made for.
struct Held {
    model: FolderModel,
    wiring: Wiring,
    open: u64,
}

#[derive(Default)]
struct State {
    held: Option<Held>,
    opens: u64,
}

impl State {
    /// What the session holds of the Git item right now, with no read.
    fn answer(&self) -> GitAnswerDto {
        match &self.held {
            None => GitAnswerDto::Pending,
            Some(Held {
                wiring: Wiring::SwitchFailed,
                ..
            }) => GitAnswerDto::machine_config_not_switched_off(),
            Some(held) => GitAnswerDto::from(held.model.kind()),
        }
    }
}

/// The session: at most one opened folder, starting empty, replaced whole by a successful open.
/// The bridge holds exactly one for the life of the process.
///
/// # Examples
///
/// ```
/// use nozoki_bridge::session::{ListAnswerDto, Session};
///
/// let session = Session::default();
///
/// assert_eq!(
///     serde_json::to_value(session.list("")).expect("the answer serializes"),
///     serde_json::json!({ "state": "pending" }),
///     "nothing is open yet"
/// );
/// assert_eq!(session.list(""), ListAnswerDto::Pending);
/// ```
pub struct Session {
    state: Mutex<State>,
    arrive: Arrival,
    switch_failure_logged: AtomicBool,
}

impl Default for Session {
    /// The production session: each open arrives at the process's switch.
    fn default() -> Self {
        Self::with_wiring(Box::new(production_arrival))
    }
}

impl Session {
    /// A session whose opens arrive through `arrive`, in place of the production switch.
    pub fn with_wiring(arrive: Box<dyn Fn() -> Wiring + Send + Sync>) -> Self {
        Self {
            state: Mutex::new(State::default()),
            arrive,
            switch_failure_logged: AtomicBool::new(false),
        }
    }

    fn lock(&self) -> MutexGuard<'_, State> {
        self.state.lock().unwrap_or_else(PoisonError::into_inner)
    }

    /// Opens one chosen folder. A successful open replaces the held model whole and makes one
    /// arrival at the composition root; a failed open touches neither.
    pub fn open(&self, chosen: PathBuf) -> OpenResult {
        match open_folder(chosen) {
            OpenFolderOutcome::Opened(folder) => {
                let wiring = (self.arrive)();
                if matches!(wiring, Wiring::SwitchFailed)
                    && !self.switch_failure_logged.swap(true, Ordering::SeqCst)
                {
                    log::warn!(
                        "core-bridge: search-path switch failed: the machine-level config could not be switched off; the Git item stays failed"
                    );
                }
                let model = FolderModel::new(folder);
                let mut state = self.lock();
                state.opens += 1;
                let open = state.opens;
                state.held = Some(Held {
                    model,
                    wiring,
                    open,
                });
                OpenResult::Opened
            }
            OpenFolderOutcome::Failed(failure) => OpenResult::Failed {
                condition: failure.into(),
            },
        }
    }

    /// Lists `path` inside the opened folder. Core's item is carried over as it is: `observed`
    /// with the entries, or `failed` with its condition. No folder open is `pending`, because
    /// nothing was read.
    pub fn list(&self, path: &str) -> ListAnswerDto {
        let guard = self.lock();
        let Some(held) = guard.held.as_ref() else {
            return ListAnswerDto::Pending;
        };
        match list_tree(held.model.folder(), path) {
            ItemState::Observed(entries) => ListAnswerDto::Observed {
                entries: entries
                    .into_iter()
                    .map(|entry| EntryDto {
                        name: entry.name,
                        path: entry.path,
                        kind: entry.kind.into(),
                        state: entry.state.into(),
                        language: entry.language.map(LanguageDto::from),
                    })
                    .collect(),
            },
            ItemState::Failed(condition) => ListAnswerDto::Failed {
                condition: condition.into(),
            },
            ItemState::Pending => ListAnswerDto::Pending,
        }
    }

    /// Answers the open folder's Git item. No folder open is `pending`. A failed switch answers its
    /// own condition and the model is never asked. An item held as `pending` is read, outside the
    /// lock, and stored and answered only if its folder is still the open one; an item already
    /// `observed` or `failed` is answered with no read.
    pub fn read_git(&self) -> GitAnswerDto {
        let (model, port, open) = {
            let state = self.lock();
            let Some(held) = state.held.as_ref() else {
                return GitAnswerDto::Pending;
            };
            let Wiring::Wired(port) = &held.wiring else {
                return state.answer();
            };
            if !matches!(held.model.kind(), ItemState::Pending) {
                return state.answer();
            }
            (held.model.clone(), Arc::clone(port), held.open)
        };
        let read = read_git(model, port.as_ref());
        let mut state = self.lock();
        if let Some(held) = state.held.as_mut()
            && held.open == open
            && matches!(held.model.kind(), ItemState::Pending)
        {
            held.model = read;
        }
        state.answer()
    }
}

impl Session {
    /// Reads the file at `path` inside the opened folder and answers its verdict. No folder open
    /// is `pending`, because nothing was read.
    pub fn select_file(&self, path: &str) -> FileAnswerDto {
        self.select_file_with(path, select_file)
    }

    /// `select_file` with the read passed in. The opened folder is cloned under the lock and the
    /// read runs after it is released, so a long read never stalls a listing behind it (CP-283).
    fn select_file_with(
        &self,
        path: &str,
        read: impl FnOnce(&OpenedFolder, &str) -> ItemState<FileView>,
    ) -> FileAnswerDto {
        let folder = self
            .lock()
            .held
            .as_ref()
            .map(|held| held.model.folder().clone());
        folder.map_or(FileAnswerDto::Pending, |folder| read(&folder, path).into())
    }
}

#[cfg(test)]
mod tests {
    //! Layer 1: the session over temporary folders. The panel belongs to the shell, so every open
    //! here hands in the location as a plain `Option<PathBuf>`.

    use std::path::PathBuf;

    use serde_json::{Value, json};

    use nozoki_core::{ItemState, list_tree, open_folder};

    use super::Session;
    use crate::test_support::TempDir;

    #[test]
    fn test_a_read_in_progress_does_not_hold_the_session_lock() {
        use std::sync::mpsc;
        use std::time::Duration;

        use nozoki_core::{CannotDisplayReason, FileView};

        let folder = TempDir::new();
        folder.write_file("a.txt", "x");
        let session = Session::default();
        opened(&session, &folder);
        let (parked_tx, parked_rx) = mpsc::channel::<()>();
        let (release_tx, release_rx) = mpsc::channel::<()>();
        let (listed_tx, listed_rx) = mpsc::channel::<()>();

        let session = &session;
        std::thread::scope(|scope| {
            scope.spawn(move || {
                session.select_file_with("a.txt", |_, _| {
                    parked_tx.send(()).expect("the test is listening");
                    release_rx.recv().expect("the test releases the read");
                    ItemState::Observed(FileView::CannotDisplay(CannotDisplayReason::InvalidUtf8))
                });
            });
            parked_rx
                .recv_timeout(Duration::from_secs(10))
                .expect("the read parked");
            scope.spawn(move || {
                session.list("");
                listed_tx.send(()).expect("the test is listening");
            });
            let listed = listed_rx.recv_timeout(Duration::from_secs(10));
            release_tx.send(()).expect("the read is parked");
            assert!(listed.is_ok(), "list completed while a read was parked");
        });
    }

    /// The answer to `path` as the JSON the shell reads.
    fn answer(session: &Session, path: &str) -> Value {
        serde_json::to_value(session.list(path)).expect("the answer serializes")
    }

    /// The names of the entries of an observed answer, sorted.
    fn names(answer: &Value) -> Vec<String> {
        let mut names: Vec<String> = entries_of(answer)
            .iter()
            .map(|entry| entry["name"].as_str().expect("a name").to_string())
            .collect();
        names.sort();
        names
    }

    fn entries_of(answer: &Value) -> &Vec<Value> {
        assert_eq!(answer["state"], "observed", "{answer}");
        answer["entries"].as_array().expect("an entries array")
    }

    fn opened(session: &Session, folder: &TempDir) {
        let result = session.open(folder.path().to_path_buf());
        assert!(
            matches!(result, super::OpenResult::Opened),
            "the folder must open"
        );
    }

    #[test]
    fn test_open_with_chosen_folder_replaces_session() {
        let folder = TempDir::new();
        folder.write_file("chosen.txt", "");
        let session = Session::default();

        let result = session.open(folder.path().to_path_buf());

        assert!(matches!(result, super::OpenResult::Opened));
        assert_eq!(names(&answer(&session, "")), vec!["chosen.txt"]);
    }

    #[test]
    fn test_open_replaces_previous_folder_whole() {
        let first = TempDir::new();
        first.write_file("from-a.txt", "");
        let second = TempDir::new();
        second.write_file("from-b.txt", "");
        let session = Session::default();
        opened(&session, &first);

        opened(&session, &second);

        assert_eq!(names(&answer(&session, "")), vec!["from-b.txt"]);
    }

    #[test]
    fn test_unopenable_choice_returns_not_opened_and_keeps_session() {
        let folder = TempDir::new();
        folder.write_file("kept.txt", "");
        let a_file = folder.write_file("not-a-folder.txt", "");
        let session = Session::default();
        opened(&session, &folder);

        let result = session.open(a_file);
        let missing = session.open(PathBuf::from("/nonexistent/nozoki/folder"));

        assert!(matches!(result, super::OpenResult::Failed { .. }));
        assert!(matches!(missing, super::OpenResult::Failed { .. }));
        assert_eq!(
            names(&answer(&session, "")),
            vec!["kept.txt", "not-a-folder.txt"]
        );
    }

    #[test]
    fn test_open_result_serializes_as_an_exact_tagged_answer() {
        let session = Session::default();
        let folder = TempDir::new();

        let value = serde_json::to_value(session.open(folder.path().to_path_buf()))
            .expect("the result serializes");

        assert_eq!(value, json!({ "state": "opened" }));
    }

    #[test]
    fn test_list_answers_state_and_condition_for_each_entry() {
        let folder = TempDir::new();
        folder.write_file("docs/guide.txt", "");
        folder.write_file(".hidden-note", "");
        folder.write_file("readme.txt", "");
        let outside = TempDir::new();
        folder.make_link("outside-link", outside.path());
        let session = Session::default();
        opened(&session, &folder);
        let core_folder = open_folder(folder.path()).expect("the folder opens");
        let ItemState::Observed(core_entries) = list_tree(&core_folder, "") else {
            panic!("the root lists");
        };
        let core_names: Vec<String> = core_entries.into_iter().map(|entry| entry.name).collect();

        let root = answer(&session, "");

        let entries = entries_of(&root);
        let listed: Vec<String> = entries
            .iter()
            .map(|entry| entry["name"].as_str().expect("a name").to_string())
            .collect();
        assert_eq!(listed, core_names, "core's order, none added or dropped");
        for entry in entries {
            let keys: Vec<&str> = entry
                .as_object()
                .expect("an object")
                .keys()
                .map(String::as_str)
                .collect();
            let expected = match (entry["kind"] == "folder", entry["state"] == "failed") {
                (true, _) => 4,
                (false, false) => 5,
                (false, true) => 6,
            };
            assert_eq!(
                keys.len(),
                expected,
                "name, path, kind and state; a file also language; when failed, condition: {keys:?}"
            );
            assert_eq!(
                entry.get("language").is_some(),
                entry["kind"] == "file",
                "a file names its language and a folder does not: {keys:?}"
            );
            if let Some(condition) = entry.get("condition") {
                assert!(
                    !condition.as_str().expect("a string").contains('/'),
                    "a condition holds no path: {condition}"
                );
            }
        }
        let outside_link = entries
            .iter()
            .find(|entry| entry["name"] == "outside-link")
            .expect("the link is listed");
        assert_eq!(outside_link["state"], "failed");
        assert_eq!(outside_link["condition"], "outside");
        assert_eq!(outside_link["kind"], "file");
    }

    #[test]
    fn test_list_formats_listed_entries() {
        let folder = TempDir::new();
        folder.write_file("src/main.rs", "");
        folder.write_file("top.txt", "");
        folder.make_link("link", "top.txt");
        let session = Session::default();
        opened(&session, &folder);

        let root = answer(&session, "");
        let nested = answer(&session, "src");

        let mut root_kinds: Vec<(String, String, String)> = entries_of(&root)
            .iter()
            .map(|entry| {
                let keys: Vec<&String> = entry.as_object().expect("an object").keys().collect();
                let expected = if entry["kind"] == "folder" { 4 } else { 5 };
                assert_eq!(
                    keys.len(),
                    expected,
                    "name, path, kind and state, and a file also its language: {keys:?}"
                );
                (
                    entry["name"].as_str().expect("a name").to_string(),
                    entry["kind"].as_str().expect("a kind").to_string(),
                    entry["state"].as_str().expect("a state").to_string(),
                )
            })
            .collect();
        root_kinds.sort();
        assert_eq!(
            root_kinds,
            vec![
                (
                    "link".to_string(),
                    "file".to_string(),
                    "observed".to_string()
                ),
                (
                    "src".to_string(),
                    "folder".to_string(),
                    "pending".to_string()
                ),
                (
                    "top.txt".to_string(),
                    "file".to_string(),
                    "observed".to_string()
                ),
            ]
        );
        assert_eq!(
            nested,
            json!({
                "state": "observed",
                "entries": [
                    {
                        "name": "main.rs",
                        "path": "src/main.rs",
                        "kind": "file",
                        "state": "observed",
                        "language": "plain"
                    }
                ]
            })
        );
    }

    /// A file entry sends the language its name gives it, in the closed wire set, and a folder
    /// sends none, even when its name is a floor name. A failed link sends its name's language
    /// beside its condition.
    #[test]
    fn test_list_sends_each_files_language_and_none_for_a_folder() {
        let folder = TempDir::new();
        for name in [
            "app.py",
            "setup.sh",
            "index.js",
            "package.json",
            "deploy.yml",
            "Cargo.toml",
            "notes.txt",
        ] {
            folder.write_file(name, "");
        }
        folder.make_folder("src");
        folder.make_link("gone.py", "nowhere");
        let session = Session::default();
        opened(&session, &folder);

        let root = answer(&session, "");

        let entries = entries_of(&root);
        let sent: Vec<(&str, Option<&str>)> = entries
            .iter()
            .map(|entry| {
                (
                    entry["name"].as_str().expect("a name"),
                    entry
                        .get("language")
                        .map(|language| language.as_str().expect("a string")),
                )
            })
            .collect();
        assert_eq!(
            sent,
            vec![
                ("src", None),
                ("app.py", Some("python")),
                ("Cargo.toml", Some("toml")),
                ("deploy.yml", Some("yaml")),
                ("gone.py", Some("python")),
                ("index.js", Some("javascript")),
                ("notes.txt", Some("plain")),
                ("package.json", Some("json")),
                ("setup.sh", Some("shell")),
            ]
        );
        let gone = entries
            .iter()
            .find(|entry| entry["name"] == "gone.py")
            .expect("the link is listed");
        assert_eq!(gone["state"], "failed");
        assert_eq!(gone["condition"], "missing");
    }

    #[test]
    fn test_list_outside_answers_failed_outside() {
        let folder = TempDir::new();
        folder.write_file("inside.txt", "");
        let session = Session::default();
        opened(&session, &folder);
        let expected = json!({ "state": "failed", "condition": "outside" });

        assert_eq!(answer(&session, ".."), expected);
        assert_eq!(answer(&session, "/etc"), expected);
    }

    #[test]
    fn test_list_file_answers_failed_not_a_folder() {
        let folder = TempDir::new();
        folder.write_file("a-file", "");
        let session = Session::default();
        opened(&session, &folder);

        assert_eq!(
            answer(&session, "a-file"),
            json!({ "state": "failed", "condition": "not_a_folder" })
        );
        assert_eq!(names(&answer(&session, "")), vec!["a-file"]);
    }

    /// CP-195: a link whose target runs through a file is `missing`, and the bridge carries the
    /// core's condition across as it stands, as the entry's condition and as the listed answer.
    #[test]
    fn test_a_link_through_a_file_crosses_as_missing() {
        let folder = TempDir::new();
        folder.write_file("notes.txt", "");
        folder.make_link("bad", "notes.txt/x");
        let session = Session::default();
        opened(&session, &folder);

        let root = answer(&session, "");
        let bad = entries_of(&root)
            .iter()
            .find(|entry| entry["name"] == "bad")
            .expect("the link is listed");
        assert_eq!(bad["state"], "failed");
        assert_eq!(bad["condition"], "missing");
        assert_eq!(
            answer(&session, "bad"),
            json!({ "state": "failed", "condition": "missing" })
        );
    }

    #[test]
    fn test_list_with_no_folder_open_answers_pending() {
        let session = Session::default();

        assert_eq!(answer(&session, ""), json!({ "state": "pending" }));
    }

    #[test]
    fn test_list_keeps_core_order() {
        let folder = TempDir::new();
        for name in ["zeta.txt", "alpha.txt", "mid", ".dot", "Beta.txt"] {
            folder.write_file(name, "");
        }
        let session = Session::default();
        opened(&session, &folder);
        let opened_folder = open_folder(folder.path()).expect("the folder opens");
        let ItemState::Observed(core_entries) = list_tree(&opened_folder, "") else {
            panic!("the root lists");
        };
        let core_names: Vec<String> = core_entries.into_iter().map(|entry| entry.name).collect();

        let listed: Vec<String> = entries_of(&answer(&session, ""))
            .iter()
            .map(|entry| entry["name"].as_str().expect("a name").to_string())
            .collect();

        assert_eq!(
            listed, core_names,
            "compared in sequence, never sorted here"
        );
        assert_eq!(listed.len(), 5);
    }

    // ---- Added by development-code-integrity (2026-09-25), derived from the intent it cites ----

    /// CP-181: from the answer alone the shell "can tell which condition a failed item carries".
    /// Design § 3 C fixes the six strings, and the Swift shell decodes them from that document and
    /// not from this code, so nothing but this test holds the Rust side to them. Each condition is
    /// checked both as a failed answer and as a failed entry's state.
    #[test]
    fn test_every_condition_crosses_the_wire_as_its_design_string() {
        use nozoki_core::Condition;

        use super::{ConditionDto, EntryStateDto, ListAnswerDto};

        for (condition, wire) in [
            (Condition::Unreadable, "unreadable"),
            (Condition::Outside, "outside"),
            (Condition::Cycle, "cycle"),
            (Condition::Missing, "missing"),
            (Condition::NotAFolder, "not_a_folder"),
            (Condition::TooManyLinks, "too_many_links"),
        ] {
            let answer = ListAnswerDto::Failed {
                condition: ConditionDto::from(condition),
            };
            let entry_state = EntryStateDto::from(ItemState::<()>::Failed(condition));

            assert_eq!(
                serde_json::to_value(answer).expect("the answer serializes"),
                json!({ "state": "failed", "condition": wire }),
                "{condition:?} as an answer"
            );
            assert_eq!(
                serde_json::to_value(entry_state).expect("the state serializes"),
                json!({ "state": "failed", "condition": wire }),
                "{condition:?} as an entry's state"
            );
        }
    }

    /// Task 5: the Git item's wire, mapped from the core's item. The model is built through the core's
    /// public API (`open_folder`, then `read_git` over a port double), because `GitState` has no
    /// public constructor.
    mod git_wire {
        use std::collections::BTreeSet;
        use std::ffi::OsStr;
        use std::os::unix::ffi::OsStrExt;
        use std::path::{Path, PathBuf};

        use nozoki_core::{
            BranchElement, ConfigNamedPath, FolderModel, GitPort, GitReadCondition, HeadState,
            OpenFolderOutcome, ProbeCondition, RepositoryState, RootFinding, StatusCategory,
            StatusEntry, StatusLists, open_folder, read_git,
        };
        use serde_json::{Value, json};

        use crate::session::GitAnswerDto;
        use crate::test_support::TempDir;

        /// A port double that answers what it was given, for every folder.
        struct Scripted {
            probe: RootFinding,
            state: Result<HeadState, GitReadCondition>,
            status: Result<StatusLists, GitReadCondition>,
        }

        impl Scripted {
            fn root(head: HeadState, status: StatusLists) -> Self {
                Self {
                    probe: RootFinding::Root,
                    state: Ok(head),
                    status: Ok(status),
                }
            }

            fn root_in(state: RepositoryState) -> Self {
                Self::root(
                    HeadState {
                        branch: BranchElement::Branch("main".to_string()),
                        state,
                    },
                    StatusLists {
                        staged: Vec::new(),
                        changed: Vec::new(),
                    },
                )
            }

            fn root_changed(changed: Vec<StatusEntry>) -> Self {
                Self::root(
                    HeadState {
                        branch: BranchElement::Branch("main".to_string()),
                        state: RepositoryState::Normal,
                    },
                    StatusLists {
                        staged: Vec::new(),
                        changed,
                    },
                )
            }
        }

        impl GitPort for Scripted {
            fn probe(&self, _folder: &Path) -> RootFinding {
                self.probe.clone()
            }

            fn state(&self, _root: &Path) -> Result<HeadState, GitReadCondition> {
                self.state.clone()
            }

            fn status(&self, _root: &Path) -> Result<StatusLists, GitReadCondition> {
                self.status.clone()
            }
        }

        fn opened_model() -> FolderModel {
            let folder = TempDir::new();
            let OpenFolderOutcome::Opened(opened) = open_folder(folder.path()) else {
                panic!("the temporary folder opens");
            };
            FolderModel::new(opened)
        }

        /// The wire of the item `port` makes the model hold.
        fn wire(port: &Scripted) -> Value {
            let model = read_git(opened_model(), port);
            serde_json::to_value(GitAnswerDto::from(model.kind())).expect("the answer serializes")
        }

        fn members(value: &Value) -> Vec<String> {
            let mut names: Vec<String> = value
                .as_object()
                .expect("an object")
                .keys()
                .cloned()
                .collect();
            names.sort();
            names
        }

        fn entry(path: &str, category: StatusCategory) -> StatusEntry {
            StatusEntry {
                path: path.to_string(),
                category,
            }
        }

        #[test]
        fn test_pending_item_is_exactly_state_pending() {
            let model = opened_model();

            let value = serde_json::to_value(GitAnswerDto::from(model.kind()))
                .expect("the answer serializes");

            assert_eq!(value, json!({ "state": "pending" }));
        }

        #[test]
        fn test_observed_plain_is_exactly_state_and_kind() {
            let value = wire(&Scripted {
                probe: RootFinding::Plain,
                state: Err(GitReadCondition::NotARoot),
                status: Err(GitReadCondition::NotARoot),
            });

            assert_eq!(value, json!({ "state": "observed", "kind": "plain" }));
        }

        #[test]
        fn test_observed_root_holds_exactly_the_six_named_members() {
            let value = wire(&Scripted::root_in(RepositoryState::Normal));

            assert_eq!(
                members(&value),
                vec![
                    "branch",
                    "changed",
                    "kind",
                    "repository_state",
                    "staged",
                    "state"
                ]
            );
            assert_eq!(value["state"], "observed");
            assert_eq!(value["kind"], "root");
            assert_eq!(value["staged"], json!([]));
            assert_eq!(value["changed"], json!([]));
        }

        #[test]
        fn test_every_entry_holds_exactly_path_and_category_except_renamed() {
            let value = wire(&Scripted::root(
                HeadState {
                    branch: BranchElement::Branch("main".to_string()),
                    state: RepositoryState::Normal,
                },
                StatusLists {
                    staged: vec![
                        entry("a", StatusCategory::Added),
                        entry(
                            "b",
                            StatusCategory::Renamed {
                                from: "old-b".to_string(),
                            },
                        ),
                    ],
                    changed: vec![
                        entry("c", StatusCategory::Modified),
                        entry("d", StatusCategory::Deleted),
                        entry("e", StatusCategory::Untracked),
                        entry("f", StatusCategory::InConflict),
                    ],
                },
            ));

            let staged = value["staged"].as_array().expect("a staged list");
            let changed = value["changed"].as_array().expect("a changed list");
            assert_eq!(members(&staged[0]), vec!["category", "path"]);
            assert_eq!(members(&staged[1]), vec!["category", "from", "path"]);
            assert_eq!(
                staged[1],
                json!({ "path": "b", "category": "renamed", "from": "old-b" })
            );
            for entry in changed {
                assert_eq!(members(entry), vec!["category", "path"], "{entry}");
            }
        }

        #[test]
        fn test_three_changed_files_cross_as_three_entries_in_the_core_order() {
            let value = wire(&Scripted::root_changed(vec![
                entry("zeta.txt", StatusCategory::Modified),
                entry("alpha.txt", StatusCategory::Modified),
                entry("mid.txt", StatusCategory::Untracked),
            ]));

            let paths: Vec<&str> = value["changed"]
                .as_array()
                .expect("a changed list")
                .iter()
                .map(|entry| entry["path"].as_str().expect("a path"))
                .collect();
            assert_eq!(paths, vec!["zeta.txt", "alpha.txt", "mid.txt"]);
            assert_eq!(
                members(&value),
                vec![
                    "branch",
                    "changed",
                    "kind",
                    "repository_state",
                    "staged",
                    "state"
                ],
                "no count member and no sort key"
            );
        }

        #[test]
        fn test_each_of_the_eight_repository_states_has_its_own_wire_value() {
            let states = [
                (RepositoryState::Normal, "normal"),
                (RepositoryState::Merge, "merge"),
                (RepositoryState::Rebase, "rebase"),
                (RepositoryState::CherryPick, "cherry_pick"),
                (RepositoryState::Revert, "revert"),
                (RepositoryState::Bisect, "bisect"),
                (RepositoryState::Am, "am"),
                (RepositoryState::DetachedHead, "detached_head"),
            ];

            let wires: Vec<Value> = states
                .iter()
                .map(|(state, _)| wire(&Scripted::root_in(*state))["repository_state"].clone())
                .collect();

            let expected: Vec<Value> = states.iter().map(|(_, text)| json!(text)).collect();
            assert_eq!(wires, expected);
            let distinct: BTreeSet<String> = wires.iter().map(Value::to_string).collect();
            assert_eq!(distinct.len(), 8);
        }

        #[test]
        fn test_each_of_the_six_categories_has_its_own_wire_value() {
            let categories = [
                (StatusCategory::Added, "added"),
                (StatusCategory::Modified, "modified"),
                (StatusCategory::Deleted, "deleted"),
                (
                    StatusCategory::Renamed {
                        from: "was".to_string(),
                    },
                    "renamed",
                ),
                (StatusCategory::Untracked, "untracked"),
                (StatusCategory::InConflict, "in_conflict"),
            ];

            let wires: Vec<Value> = categories
                .iter()
                .map(|(category, _)| {
                    wire(&Scripted::root_changed(vec![entry("p", category.clone())]))["changed"][0]
                        ["category"]
                        .clone()
                })
                .collect();

            let expected: Vec<Value> = categories.iter().map(|(_, text)| json!(text)).collect();
            assert_eq!(wires, expected);
            let distinct: BTreeSet<String> = wires.iter().map(Value::to_string).collect();
            assert_eq!(distinct.len(), 6);
        }

        fn probe_failure(condition: ProbeCondition) -> Scripted {
            Scripted {
                probe: RootFinding::Failed(condition),
                state: Err(GitReadCondition::NotARoot),
                status: Err(GitReadCondition::NotARoot),
            }
        }

        fn read_failure(condition: GitReadCondition) -> Scripted {
            Scripted {
                probe: RootFinding::Root,
                state: Err(condition),
                status: Err(GitReadCondition::NotARoot),
            }
        }

        #[test]
        fn test_each_of_the_conditions_and_the_switch_failure_have_fifteen_distinct_wire_values() {
            let mut answers: Vec<(Value, &str)> = vec![
                (
                    wire(&probe_failure(ProbeCondition::FolderUnavailable)),
                    "probe_folder_unavailable",
                ),
                (
                    wire(&probe_failure(ProbeCondition::GitDirectoryUnreadable)),
                    "probe_git_directory_unreadable",
                ),
                (
                    wire(&probe_failure(ProbeCondition::GitEntryNotDirectory)),
                    "probe_git_entry_not_directory",
                ),
                (
                    wire(&probe_failure(ProbeCondition::GitFileUnreadable)),
                    "probe_git_file_unreadable",
                ),
                (
                    wire(&probe_failure(ProbeCondition::RepositoryReadFailed)),
                    "probe_repository_read_failed",
                ),
                (
                    wire(&read_failure(GitReadCondition::GitDirectoryOutside(
                        PathBuf::from("/elsewhere/.git"),
                    ))),
                    "git_directory_outside",
                ),
                (
                    wire(&read_failure(GitReadCondition::NotARoot)),
                    "not_a_root",
                ),
                (
                    wire(&read_failure(GitReadCondition::GitDirectoryMissing)),
                    "git_directory_missing",
                ),
                (
                    wire(&read_failure(GitReadCondition::GitDirectoryUnreadable)),
                    "git_directory_unreadable",
                ),
                (
                    wire(&read_failure(GitReadCondition::NotARepository)),
                    "not_a_repository",
                ),
                (
                    wire(&read_failure(GitReadCondition::RepositoryReadFailed)),
                    "repository_read_failed",
                ),
                (
                    wire(&read_failure(GitReadCondition::ConfigNamesOutside(
                        named_config_path(),
                    ))),
                    "config_names_outside",
                ),
                (
                    wire(&read_failure(GitReadCondition::ObjectStoreNamesOutside(
                        "../../../elsewhere/objects".to_string(),
                    ))),
                    "object_store_names_outside",
                ),
                (
                    wire(&read_failure(GitReadCondition::ConfigNotLocated(
                        named_config_path(),
                    ))),
                    "config_not_located",
                ),
            ];
            // The probe's variant and the read's variant are one wire value.
            let probe_variant = wire(&probe_failure(ProbeCondition::ConfigNamesOutside(
                named_config_path(),
            )));
            assert_eq!(probe_variant["condition"], "config_names_outside");
            assert_eq!(probe_variant, answers[answers.len() - 3].0);
            let probe_alternates = wire(&probe_failure(ProbeCondition::ObjectStoreNamesOutside(
                "../../../elsewhere/objects".to_string(),
            )));
            assert_eq!(probe_alternates["condition"], "object_store_names_outside");
            assert_eq!(probe_alternates, answers[answers.len() - 2].0);
            let probe_not_located = wire(&probe_failure(ProbeCondition::ConfigNotLocated(
                named_config_path(),
            )));
            assert_eq!(probe_not_located["condition"], "config_not_located");
            assert_eq!(probe_not_located, answers[answers.len() - 1].0);
            answers.push((
                serde_json::to_value(GitAnswerDto::machine_config_not_switched_off())
                    .expect("the answer serializes"),
                "machine_config_not_switched_off",
            ));

            for (answer, condition) in &answers {
                assert_eq!(answer["state"], "failed", "{answer}");
                assert_eq!(answer["condition"], *condition, "{answer}");
            }
            let distinct: BTreeSet<String> = answers
                .iter()
                .map(|(answer, _)| answer["condition"].to_string())
                .collect();
            assert_eq!(distinct.len(), 15);
        }

        fn named_config_path() -> ConfigNamedPath {
            ConfigNamedPath {
                key: "include.path".to_string(),
                path: "../../elsewhere/extra".to_string(),
            }
        }

        #[test]
        fn test_the_config_condition_serializes_exactly_its_four_members() {
            let non_utf8_path = OsStr::from_bytes(b"/outside/\xff.list");
            let named = ConfigNamedPath {
                key: "core.excludesfile".to_string(),
                path: non_utf8_path.to_string_lossy().into_owned(),
            };
            let from_read = wire(&read_failure(GitReadCondition::ConfigNamesOutside(
                named.clone(),
            )));
            let from_probe = wire(&probe_failure(ProbeCondition::ConfigNamesOutside(named)));

            let expected = json!({
                "state": "failed",
                "condition": "config_names_outside",
                "key": "core.excludesfile",
                "path": "/outside/\u{fffd}.list"
            });
            assert_eq!(from_read, expected);
            assert_eq!(from_probe, expected);
            assert_eq!(
                members(&from_read),
                vec!["condition", "key", "path", "state"]
            );
        }

        #[test]
        fn test_the_not_located_condition_serializes_exactly_its_four_members() {
            let non_utf8_path = OsStr::from_bytes(b"ignore-\xff.list");
            let named = ConfigNamedPath {
                key: "core.excludesfile".to_string(),
                path: non_utf8_path.to_string_lossy().into_owned(),
            };
            let from_read = wire(&read_failure(GitReadCondition::ConfigNotLocated(
                named.clone(),
            )));
            let from_probe = wire(&probe_failure(ProbeCondition::ConfigNotLocated(named)));

            let expected = json!({
                "state": "failed",
                "condition": "config_not_located",
                "key": "core.excludesfile",
                "path": "ignore-\u{fffd}.list"
            });
            assert_eq!(from_read, expected);
            assert_eq!(from_probe, expected);
            assert_eq!(
                members(&from_read),
                vec!["condition", "key", "path", "state"]
            );
        }

        #[test]
        fn test_the_alternates_condition_serializes_exactly_condition_path_and_state() {
            let non_utf8_entry = OsStr::from_bytes(b"/outside/\xff/objects");
            let value = non_utf8_entry.to_string_lossy().into_owned();
            let from_read = wire(&read_failure(GitReadCondition::ObjectStoreNamesOutside(
                value.clone(),
            )));
            let from_probe = wire(&probe_failure(ProbeCondition::ObjectStoreNamesOutside(
                value,
            )));

            let expected = json!({
                "state": "failed",
                "condition": "object_store_names_outside",
                "path": "/outside/\u{fffd}/objects"
            });
            assert_eq!(from_read, expected);
            assert_eq!(from_probe, expected);
            assert_eq!(members(&from_read), vec!["condition", "path", "state"]);
        }

        #[test]
        fn test_git_directory_member_appears_only_for_git_directory_outside() {
            let outside = wire(&read_failure(GitReadCondition::GitDirectoryOutside(
                PathBuf::from("/elsewhere/.git"),
            )));
            let others = [
                wire(&probe_failure(ProbeCondition::FolderUnavailable)),
                wire(&read_failure(GitReadCondition::NotARoot)),
                wire(&read_failure(GitReadCondition::RepositoryReadFailed)),
                serde_json::to_value(GitAnswerDto::machine_config_not_switched_off())
                    .expect("the answer serializes"),
            ];

            assert_eq!(
                outside,
                json!({
                    "state": "failed",
                    "condition": "git_directory_outside",
                    "git_directory": "/elsewhere/.git"
                })
            );
            for other in others {
                assert_eq!(members(&other), vec!["condition", "state"], "{other}");
            }
        }

        #[test]
        fn test_branch_and_detached_identifier_spell_as_the_core_reads_them() {
            let commit = "62290d82ec30f74dbffb792140ea647be14eb18c";
            let on_branch = wire(&Scripted::root_in(RepositoryState::Normal));
            let detached = wire(&Scripted::root(
                HeadState {
                    branch: BranchElement::Detached(commit.to_string()),
                    state: RepositoryState::DetachedHead,
                },
                StatusLists {
                    staged: Vec::new(),
                    changed: Vec::new(),
                },
            ));

            assert_eq!(
                on_branch["branch"],
                json!({ "kind": "branch", "name": "main" })
            );
            assert_eq!(
                detached["branch"],
                json!({ "kind": "detached", "commit": commit })
            );
            assert_eq!(commit.len(), 40);
        }

        #[test]
        fn test_non_utf8_git_directory_is_a_non_null_answer_with_the_lossy_spelling() {
            let path = PathBuf::from(OsStr::from_bytes(b"/elsewhere/\xff/.git"));
            let model = read_git(
                opened_model(),
                &read_failure(GitReadCondition::GitDirectoryOutside(path)),
            );

            let value = serde_json::to_value(GitAnswerDto::from(model.kind()))
                .expect("a non-UTF-8 path still serializes");

            assert_eq!(value["state"], "failed");
            assert_eq!(value["git_directory"], "/elsewhere/\u{fffd}/.git");
        }

        #[test]
        fn test_switch_failure_carries_no_path_and_no_library_text() {
            let value = serde_json::to_value(GitAnswerDto::machine_config_not_switched_off())
                .expect("the answer serializes");

            assert_eq!(
                value,
                json!({ "state": "failed", "condition": "machine_config_not_switched_off" })
            );
        }
    }

    /// Task 6: the session's Git answer over wirings of the test's own making: a port double, or the
    /// switch's run with an erring setter.
    mod git_session {
        use std::path::{Path, PathBuf};
        use std::sync::atomic::{AtomicUsize, Ordering};
        use std::sync::mpsc::{Receiver, Sender, channel};
        use std::sync::{Arc, Mutex};
        use std::time::Duration;

        use nozoki_core::{
            BranchElement, GitPort, GitReadCondition, HeadState, RepositoryState, RootFinding,
            StatusLists,
        };
        use serde_json::{Value, json};

        use crate::machine_config::{Level, SetterFailure, SwitchGuard};
        use crate::session::{Session, Wiring, arrive_wiring};
        use crate::test_support::{TempDir, begin_log_capture, take_log_records};

        type SharedPort = Arc<dyn GitPort + Send + Sync>;

        /// A port double that counts each operation and answers a root whose branch is named for the
        /// folder it was asked about, so an answer says which folder it was read for.
        struct Counting {
            probes: AtomicUsize,
            states: AtomicUsize,
            statuses: AtomicUsize,
            state_failure: Option<GitReadCondition>,
            status_failure: Option<GitReadCondition>,
            /// When set, the first `state` call tells `parked` and waits for `release`.
            gate: Option<Gate>,
        }

        struct Gate {
            parked: Mutex<Sender<()>>,
            release: Mutex<Receiver<()>>,
            used: AtomicUsize,
        }

        impl Counting {
            fn new() -> Self {
                Self {
                    probes: AtomicUsize::new(0),
                    states: AtomicUsize::new(0),
                    statuses: AtomicUsize::new(0),
                    state_failure: None,
                    status_failure: None,
                    gate: None,
                }
            }

            fn counts(&self) -> (usize, usize, usize) {
                (
                    self.probes.load(Ordering::SeqCst),
                    self.states.load(Ordering::SeqCst),
                    self.statuses.load(Ordering::SeqCst),
                )
            }
        }

        impl GitPort for Counting {
            fn probe(&self, _folder: &Path) -> RootFinding {
                self.probes.fetch_add(1, Ordering::SeqCst);
                RootFinding::Root
            }

            fn state(&self, root: &Path) -> Result<HeadState, GitReadCondition> {
                self.states.fetch_add(1, Ordering::SeqCst);
                if let Some(gate) = &self.gate
                    && gate.used.fetch_add(1, Ordering::SeqCst) == 0
                {
                    gate.parked
                        .lock()
                        .expect("the gate lock")
                        .send(())
                        .expect("the test is listening");
                    gate.release
                        .lock()
                        .expect("the gate lock")
                        .recv_timeout(Duration::from_secs(10))
                        .expect("the test releases the read");
                }
                if let Some(condition) = &self.state_failure {
                    return Err(condition.clone());
                }
                Ok(HeadState {
                    branch: BranchElement::Branch(
                        root.file_name()
                            .expect("a folder name")
                            .to_string_lossy()
                            .into_owned(),
                    ),
                    state: RepositoryState::Normal,
                })
            }

            fn status(&self, _root: &Path) -> Result<StatusLists, GitReadCondition> {
                self.statuses.fetch_add(1, Ordering::SeqCst);
                match &self.status_failure {
                    Some(condition) => Err(condition.clone()),
                    None => Ok(StatusLists {
                        staged: Vec::new(),
                        changed: Vec::new(),
                    }),
                }
            }
        }

        fn session_over(port: &Arc<Counting>) -> Session {
            let shared: SharedPort = port.clone();
            Session::with_wiring(Box::new(move || Wiring::Wired(shared.clone())))
        }

        /// A session wired by the switch's own run over an erring setter, and the count of setter calls.
        fn erring_session() -> (Session, Arc<AtomicUsize>) {
            let calls = Arc::new(AtomicUsize::new(0));
            let counted = calls.clone();
            let guard = SwitchGuard::new(move |level: Level| {
                counted.fetch_add(1, Ordering::SeqCst);
                if level == Level::Xdg {
                    Err(SetterFailure)
                } else {
                    Ok(())
                }
            });
            let session = Session::with_wiring(Box::new(move || {
                arrive_wiring(guard.arrive(), || Arc::new(Counting::new()))
            }));
            (session, calls)
        }

        fn open(session: &Session, folder: &Path) {
            let result = session.open(folder.to_path_buf());
            assert!(
                matches!(result, crate::session::OpenResult::Opened),
                "the folder must open"
            );
        }

        fn git_item(session: &Session) -> Value {
            serde_json::to_value(session.read_git()).expect("the answer serializes")
        }

        fn switch_failed() -> Value {
            json!({ "state": "failed", "condition": "machine_config_not_switched_off" })
        }

        #[test]
        fn test_erring_setter_session_answers_machine_config_not_switched_off() {
            let _serial = begin_log_capture();
            let scene = TempDir::new();
            let repository = scene.repository_copy();
            let (session, _calls) = erring_session();
            open(&session, &repository);

            assert_eq!(git_item(&session), switch_failed());
        }

        #[test]
        fn test_erring_setter_session_stays_failed_after_a_second_folder_opens() {
            let _serial = begin_log_capture();
            let scene = TempDir::new();
            let repository = scene.repository_copy();
            let second = TempDir::new();
            let (session, calls) = erring_session();
            open(&session, &repository);
            assert_eq!(git_item(&session), switch_failed());
            let calls_after_first = calls.load(Ordering::SeqCst);
            assert_eq!(calls_after_first, 3, "system, global, then the erring XDG");

            open(&session, second.path());

            assert_eq!(git_item(&session), switch_failed());
            assert_eq!(calls.load(Ordering::SeqCst), calls_after_first, "no retry");
        }

        #[test]
        fn test_erring_setter_and_real_wired_sessions_answer_list_and_select_file_equally() {
            let _serial = begin_log_capture();
            let scene = TempDir::new();
            let repository = scene.repository_copy();
            let (erring, _calls) = erring_session();
            let real = Session::default();
            open(&erring, &repository);
            open(&real, &repository);

            let listed = |session: &Session| {
                serde_json::to_value(session.list("")).expect("the answer serializes")
            };
            let selected = |session: &Session| {
                serde_json::to_value(session.select_file("README.md"))
                    .expect("the answer serializes")
            };

            // CP-542: "whatever state the Git item is in". The real session is answered while its
            // item is pending, then again once it is observed, and the erring one while failed.
            let pending = (listed(&real), selected(&real));
            assert_eq!(git_item(&real)["state"], "observed");
            let observed = (listed(&real), selected(&real));
            assert_eq!(git_item(&erring), switch_failed());
            let failed = (listed(&erring), selected(&erring));

            assert_eq!(
                observed, pending,
                "reading the Git item changed no other answer"
            );
            assert_eq!(
                failed, observed,
                "a failed Git item changes no other answer"
            );
            assert_eq!(observed.0["state"], "observed");
            assert_eq!(observed.1["state"], "text");
        }

        /// A port double whose first `probe` panics and whose later ones answer `plain`.
        struct PanicsOnce {
            probes: AtomicUsize,
        }

        impl GitPort for PanicsOnce {
            fn probe(&self, _folder: &Path) -> RootFinding {
                if self.probes.fetch_add(1, Ordering::SeqCst) == 0 {
                    panic!("the first read panics");
                }
                RootFinding::Plain
            }

            fn state(&self, _root: &Path) -> Result<HeadState, GitReadCondition> {
                Err(GitReadCondition::NotARoot)
            }

            fn status(&self, _root: &Path) -> Result<StatusLists, GitReadCondition> {
                Err(GitReadCondition::NotARoot)
            }
        }

        /// Design (b1): "a read that panicked was never stored, so the item is still `pending` and
        /// the next ask reads". The panic is the boundary's to catch; the session must not be left
        /// holding a read that never finished.
        #[test]
        fn test_a_read_that_panicked_leaves_the_item_pending_and_the_next_ask_reads() {
            let port = Arc::new(PanicsOnce {
                probes: AtomicUsize::new(0),
            });
            let shared: SharedPort = port.clone();
            let session = Session::with_wiring(Box::new(move || Wiring::Wired(shared.clone())));
            let folder = TempDir::new();
            open(&session, folder.path());

            let first =
                std::panic::catch_unwind(std::panic::AssertUnwindSafe(|| session.read_git()));
            let next = git_item(&session);

            assert!(first.is_err(), "the first read panicked");
            assert_eq!(next, json!({ "state": "observed", "kind": "plain" }));
            assert_eq!(
                port.probes.load(Ordering::SeqCst),
                2,
                "the next ask read again"
            );
        }

        #[test]
        fn test_status_failure_answers_failed_with_the_status_condition_never_a_root() {
            let mut port = Counting::new();
            port.status_failure = Some(GitReadCondition::NotARepository);
            let port = Arc::new(port);
            let session = session_over(&port);
            let folder = TempDir::new();
            open(&session, folder.path());

            assert_eq!(
                git_item(&session),
                json!({ "state": "failed", "condition": "not_a_repository" })
            );
        }

        #[test]
        fn test_two_asks_on_one_open_read_once() {
            let port = Arc::new(Counting::new());
            let session = session_over(&port);
            let folder = TempDir::new();
            open(&session, folder.path());

            let first = git_item(&session);
            let second = git_item(&session);

            assert_eq!(first, second);
            assert_eq!(first["state"], "observed");
            assert_eq!(port.counts(), (1, 1, 1));
        }

        #[test]
        fn test_a_new_open_of_the_same_folder_reads_again() {
            let port = Arc::new(Counting::new());
            let session = session_over(&port);
            let folder = TempDir::new();
            open(&session, folder.path());
            git_item(&session);

            open(&session, folder.path());
            git_item(&session);

            assert_eq!(port.counts(), (2, 2, 2));
        }

        #[test]
        fn test_failed_item_is_answered_without_a_second_read() {
            let mut port = Counting::new();
            port.state_failure = Some(GitReadCondition::GitDirectoryMissing);
            let port = Arc::new(port);
            let session = session_over(&port);
            let folder = TempDir::new();
            open(&session, folder.path());

            let first = git_item(&session);
            let second = git_item(&session);

            assert_eq!(
                first,
                json!({ "state": "failed", "condition": "git_directory_missing" })
            );
            assert_eq!(second, first);
            assert_eq!(
                port.counts(),
                (1, 1, 0),
                "the failed item makes no port call"
            );
        }

        #[test]
        fn test_a_parked_ask_does_not_answer_a_later_folders_item() {
            let (parked_tx, parked_rx) = channel::<()>();
            let (release_tx, release_rx) = channel::<()>();
            let mut port = Counting::new();
            port.gate = Some(Gate {
                parked: Mutex::new(parked_tx),
                release: Mutex::new(release_rx),
                used: AtomicUsize::new(0),
            });
            let port = Arc::new(port);
            let session = session_over(&port);
            let folder_a = TempDir::new();
            let folder_b = TempDir::new();
            open(&session, folder_a.path());
            let name_of = |folder: &TempDir| -> String {
                let canonical: PathBuf = folder.path().canonicalize().expect("canonical");
                canonical
                    .file_name()
                    .expect("a name")
                    .to_string_lossy()
                    .into_owned()
            };

            let session_ref = &session;
            let parked_answer = std::thread::scope(|scope| {
                let ask = scope.spawn(move || git_item(session_ref));
                parked_rx
                    .recv_timeout(Duration::from_secs(10))
                    .expect("the first read parked");
                open(session_ref, folder_b.path());
                release_tx.send(()).expect("the read is parked");
                ask.join().expect("the ask finishes")
            });

            assert_ne!(
                parked_answer["branch"]["name"],
                json!(name_of(&folder_a)),
                "folder A's item is not answered after B opened"
            );
            let next = git_item(&session);
            assert_eq!(next["branch"]["name"], json!(name_of(&folder_b)));
        }

        #[test]
        fn test_a_switch_failure_emits_one_warn_and_a_repeat_ask_emits_none() {
            // The capture is process-wide, and the cases that read through a failing double warn
            // under `git-reader`; this case counts only the switch's own line.
            let serial = begin_log_capture();
            let folder = TempDir::new();
            let (session, _calls) = erring_session();
            let switch_lines = |records: Vec<String>| -> Vec<String> {
                records
                    .into_iter()
                    .filter(|record| record.contains("core-bridge"))
                    .collect()
            };

            open(&session, folder.path());
            let after_arrival = switch_lines(take_log_records());
            git_item(&session);
            git_item(&session);
            let after_asks = switch_lines(take_log_records());
            drop(serial);

            assert_eq!(after_arrival.len(), 1, "{after_arrival:?}");
            assert!(
                after_arrival[0].contains("search-path switch"),
                "{after_arrival:?}"
            );
            assert!(after_asks.is_empty(), "an ask logs nothing: {after_asks:?}");
        }
    }
}
