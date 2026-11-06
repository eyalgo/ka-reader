//! The open-and-list state behind the bridge's two calls, and their wire shapes. Every operation
//! delegates to `ka-reader-core` and only formats the result (QC-13). It never presents a panel: the
//! location comes in as a plain `Option<PathBuf>`, so none of this needs a window or a runtime.

use std::panic::{self, AssertUnwindSafe};
use std::path::{Path, PathBuf};
use std::sync::atomic::{AtomicBool, Ordering};
use std::sync::{Arc, Mutex, MutexGuard, PoisonError, Weak};

use ka_reader_core::{
    BranchElement, CannotDisplayReason, Condition, ConfigNamedPath, Entry, EntryKind, FileRead,
    FileRequest, FileView, FolderKind, FolderModel, GitCondition, GitPort, GitReadCondition,
    ItemState, Language, OpenFailure, OpenFolderOutcome, OpenedFolder, PathReports, ProbeCondition,
    ReadingPosition, RepositoryState, Span, StatusCategory, StatusEntry, SubmoduleNamedPath,
    TokenClass, TreeChanges, TreeRequest, list_tree, open_folder, read_file, read_git_item,
};
use serde::Serialize;

use crate::boundary::changes_payload;
use crate::delivery_gate::DeliveryGate;
use crate::machine_config::{SwitchOutcome, arrive_in_process, production_port};
use crate::watcher::{FsEvents, PathSink, Subscription, Watching};

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
    /// A re-read of the open file found nothing at its path. It carries no content.
    Gone,
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
            ItemState::Observed(FileView::Gone) => Self::Gone,
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
/// `object_store_names_outside` and `object_store_not_located`, and `name` and `path` beside
/// `submodule_elsewhere` alone. The bridge carries the core's item
/// and decides nothing: no count, wording or sort key crosses (CP-543).
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
        name: Option<String>,
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

/// A failed Git item's condition on the wire, one string from the closed set of eighteen. Five of
/// the probe's conditions carry a `probe_` prefix, because two share names with read conditions.
/// The two config conditions and the two object store conditions are each one value for the probe
/// and the reads: one message whichever operation met it.
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
    ObjectStoreNotLocated,
    SubmoduleElsewhere,
    GitmodulesUnreadable,
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
            ProbeCondition::ObjectStoreNotLocated(_) => Self::ObjectStoreNotLocated,
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
            name: None,
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
            name: None,
            path: Some(named.path.clone()),
        }
    }

    /// The submodule-map condition's answer: the section's name beside its path, as the core spelled
    /// them. It is the one answer that carries a `name`.
    fn submodule_elsewhere(named: &SubmoduleNamedPath) -> Self {
        Self::Failed {
            condition: GitConditionDto::SubmoduleElsewhere,
            git_directory: None,
            key: None,
            name: Some(named.name.clone()),
            path: Some(named.path.clone()),
        }
    }

    /// The outside object store condition's answer, whichever operation met it. The core has already
    /// spelled the value lossily, so it crosses as the string the core holds, in `path` alone.
    fn object_store_names_outside(value: &str) -> Self {
        Self::object_store_refused(GitConditionDto::ObjectStoreNamesOutside, value)
    }

    /// The not-located object store condition's answer: the same members, under its own condition.
    fn object_store_not_located(value: &str) -> Self {
        Self::object_store_refused(GitConditionDto::ObjectStoreNotLocated, value)
    }

    fn object_store_refused(condition: GitConditionDto, value: &str) -> Self {
        Self::Failed {
            condition,
            git_directory: None,
            key: None,
            name: None,
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
            ItemState::Failed(GitCondition::Probe(ProbeCondition::ObjectStoreNotLocated(
                value,
            ))) => Self::object_store_not_located(value),
            ItemState::Failed(GitCondition::Probe(condition)) => Self::failed(condition.into()),
            ItemState::Failed(GitCondition::Read(condition)) => match condition {
                GitReadCondition::GitDirectoryOutside(path) => Self::Failed {
                    // Lossy, as the core spells every other path: serde's `PathBuf` impl fails on a
                    // non-UTF-8 path and would turn the whole answer into NULL.
                    condition: GitConditionDto::GitDirectoryOutside,
                    git_directory: Some(path.to_string_lossy().into_owned()),
                    key: None,
                    name: None,
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
                GitReadCondition::ObjectStoreNotLocated(value) => {
                    Self::object_store_not_located(value)
                }
                GitReadCondition::SubmoduleElsewhere(named) => Self::submodule_elsewhere(named),
                GitReadCondition::GitmodulesUnreadable => {
                    Self::failed(GitConditionDto::GitmodulesUnreadable)
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

/// What the reader did to a folder row. The boundary decodes the wire's number into this closed set,
/// and a number that is neither reaches the session as no act at all.
///
/// # Examples
///
/// ```
/// use ka_reader_bridge::session::{ListAnswerDto, Session, TreeAct};
///
/// let session = Session::default();
/// assert_eq!(session.list("src", Some(TreeAct::Collapse)), ListAnswerDto::Pending);
/// assert_eq!(session.list("src", None), ListAnswerDto::Pending);
/// ```
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum TreeAct {
    /// The reader disclosed the folder.
    Expand,
    /// The reader hid the folder.
    Collapse,
}

/// Where the session sends a `model_changed` payload: the serialized JSON bytes. A delivery is called
/// on a thread the watcher owns, never while a model lock is held, and never after the open that
/// replaces it has returned.
pub type Delivery = Arc<dyn Fn(Vec<u8>) + Send + Sync>;

/// Core's listing as the answer the shell reads.
pub(crate) fn list_answer(listing: ItemState<Vec<Entry>>) -> ListAnswerDto {
    match listing {
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

/// An opened folder as a model, with the wiring of the arrival its open made and a token naming that
/// open, so a read answers only for the open it was made for.
struct Held {
    model: FolderModel,
    wiring: Wiring,
    open: u64,
    /// How many batches this grant has applied, whether or not they changed anything. An open
    /// compares it before and after its read, outside the lock, to see that a batch landed meanwhile.
    batches: u64,
    /// The revision of the last payload that carried the open file; the next carries one more.
    revision: u64,
    /// Where this grant's payloads go, when it has one.
    delivery: Option<Delivery>,
    /// Lets a delivery run only while the grant is live and lets the replacing open wait for those
    /// in flight.
    gate: Arc<DeliveryGate>,
    /// The open's watcher subscription: stopping it drains every callback in flight.
    subscription: Option<Subscription>,
}

impl Held {
    /// Ends the grant: the subscription stops, then the gate closes and waits for the deliveries
    /// still in flight, so no callback is called after the open that replaced it has returned.
    fn retire(mut self) {
        drop(self.subscription.take());
        self.gate.close();
    }

    /// The payload for `changes`, whose revision rises only when it carries the open file.
    fn payload_for(&mut self, changes: &TreeChanges) -> Result<Option<Vec<u8>>, serde_json::Error> {
        if changes.is_empty() {
            return Ok(None);
        }
        let revision = self.revision + 1;
        let payload = changes_payload(changes, revision)?;
        if changes.open_file().is_some() {
            self.revision = revision;
        }
        Ok(Some(payload))
    }
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

/// A payload with the gate of the grant it is delivered through.
type Outgoing = (Vec<u8>, Arc<DeliveryGate>);

/// One watcher batch, for the grant `token`: a batch for any other grant is dropped. The next model
/// is computed on a clone and assigned only once it and its payload exist, so a panic leaves the held
/// model as it was. The delivery is called after the lock is released, only when something changed.
/// A panic, or a payload that cannot be serialized, delivers nothing and writes one `stopped` line.
fn deliver_batch(
    state: &Mutex<State>,
    token: u64,
    batch: Vec<PathBuf>,
    reduce: impl FnOnce(FolderModel, PathReports) -> FolderModel,
    delivery: &Delivery,
) {
    let outcome = panic::catch_unwind(AssertUnwindSafe(|| {
        let payload = apply_batch(state, token, batch, reduce)?;
        if let Some((payload, gate)) = payload {
            gate.deliver(delivery, payload);
        }
        Ok::<(), serde_json::Error>(())
    }));
    match outcome {
        Ok(Ok(())) => {}
        Ok(Err(_)) => {
            log::warn!("core-bridge: model_changed stopped: answer serialization failed");
        }
        Err(_) => log::warn!("core-bridge: model_changed stopped: boundary panicked"),
    }
}

/// The locked half of [`deliver_batch`]: reduce, take the changes, serialize, then assign.
fn apply_batch(
    state: &Mutex<State>,
    token: u64,
    batch: Vec<PathBuf>,
    reduce: impl FnOnce(FolderModel, PathReports) -> FolderModel,
) -> Result<Option<Outgoing>, serde_json::Error> {
    let mut guard = state.lock().unwrap_or_else(PoisonError::into_inner);
    let Some(held) = guard.held.as_mut().filter(|held| held.open == token) else {
        return Ok(None);
    };
    held.batches += 1;
    let next = reduce(held.model.clone(), PathReports::new(batch));
    let changes = next.changes_since(&held.model);
    let payload = held.payload_for(&changes)?;
    held.model = next;
    Ok(payload.map(|payload| (payload, Arc::clone(&held.gate))))
}

/// The session: at most one opened folder, starting empty, replaced whole by a successful open.
/// The bridge holds exactly one for the life of the process.
///
/// # Examples
///
/// ```
/// use ka_reader_bridge::session::{ListAnswerDto, Session, TreeAct};
///
/// let session = Session::default();
///
/// assert_eq!(
///     serde_json::to_value(session.list("", Some(TreeAct::Expand))).expect("the answer serializes"),
///     serde_json::json!({ "state": "pending" }),
///     "nothing is open yet"
/// );
/// assert_eq!(session.list("", Some(TreeAct::Expand)), ListAnswerDto::Pending);
/// ```
pub struct Session {
    state: Arc<Mutex<State>>,
    arrive: Arrival,
    watching: Arc<dyn Watching>,
    switch_failure_logged: AtomicBool,
}

impl Default for Session {
    /// The production session: each open arrives at the process's switch.
    fn default() -> Self {
        Self::with_wiring(Box::new(production_arrival))
    }
}

impl Session {
    /// A session whose opens arrive through `arrive`, in place of the production switch, and whose
    /// delivering opens watch through the platform's `FsEvents`.
    pub fn with_wiring(arrive: Box<dyn Fn() -> Wiring + Send + Sync>) -> Self {
        Self::with_parts(arrive, Arc::new(FsEvents))
    }

    /// A session whose opens arrive through `arrive` and whose delivering opens watch through
    /// `watching`. A stream starts only for an open that carries a delivery.
    ///
    /// # Examples
    ///
    /// ```
    /// use std::sync::Arc;
    /// use ka_reader_bridge::session::{ListAnswerDto, Session, Wiring};
    /// use ka_reader_bridge::watcher::fakes::ManualWatching;
    ///
    /// let watching = Arc::new(ManualWatching::new());
    /// let session = Session::with_parts(Box::new(|| Wiring::SwitchFailed), watching.clone());
    /// assert_eq!(session.list("", None), ListAnswerDto::Pending);
    /// assert!(watching.recorded().is_empty());
    /// ```
    pub fn with_parts(
        arrive: Box<dyn Fn() -> Wiring + Send + Sync>,
        watching: Arc<dyn Watching>,
    ) -> Self {
        Self {
            state: Arc::new(Mutex::new(State::default())),
            arrive,
            watching,
            switch_failure_logged: AtomicBool::new(false),
        }
    }

    fn lock(&self) -> MutexGuard<'_, State> {
        self.state.lock().unwrap_or_else(PoisonError::into_inner)
    }

    /// Opens one chosen folder, for a host that only sends commands: no watcher subscription starts.
    /// A successful open replaces the held model whole and makes one arrival at the composition
    /// root; a failed open touches neither.
    pub fn open(&self, chosen: PathBuf) -> OpenResult {
        self.open_with(chosen, None)
    }

    /// Opens one chosen folder and watches it: every change the disk reports reaches `delivery` as
    /// a serialized payload of the listings that changed. The folder it replaces is no longer
    /// watched when this returns, and its delivery is never called after. A failed open registers
    /// nothing, and a watcher that cannot start leaves the folder open with no delivery.
    ///
    /// # Examples
    ///
    /// ```
    /// use std::sync::Arc;
    /// use ka_reader_bridge::session::{OpenResult, Session, Wiring};
    /// use ka_reader_bridge::watcher::fakes::ManualWatching;
    ///
    /// let watching = Arc::new(ManualWatching::new());
    /// let session = Session::with_parts(Box::new(|| Wiring::SwitchFailed), watching.clone());
    /// let delivery = Arc::new(|payload: Vec<u8>| drop(payload));
    ///
    /// let result = session.open_delivering(std::env::temp_dir(), delivery);
    /// assert!(matches!(result, OpenResult::Opened));
    /// assert_eq!(watching.recorded().len(), 1);
    /// ```
    pub fn open_delivering(&self, chosen: PathBuf, delivery: Delivery) -> OpenResult {
        self.open_with(chosen, Some(delivery))
    }

    fn open_with(&self, chosen: PathBuf, delivery: Option<Delivery>) -> OpenResult {
        let folder = match open_folder(chosen) {
            OpenFolderOutcome::Opened(folder) => folder,
            OpenFolderOutcome::Failed(failure) => {
                return OpenResult::Failed {
                    condition: failure.into(),
                };
            }
        };
        let wiring = (self.arrive)();
        if matches!(wiring, Wiring::SwitchFailed)
            && !self.switch_failure_logged.swap(true, Ordering::SeqCst)
        {
            log::warn!(
                "core-bridge: search-path switch failed: the machine-level config could not be switched off; the Git item stays failed"
            );
        }
        // Under one hold of the lock: take the grant token, start the subscription, read the
        // snapshot and install. A report that arrives during the snapshot waits on the lock and is
        // applied right after the install, so nothing between subscribing and reading is lost.
        let replaced = {
            let mut state = self.lock();
            state.opens += 1;
            let open = state.opens;
            let gate = Arc::new(DeliveryGate::default());
            let subscription = delivery
                .clone()
                .and_then(|delivery| self.subscribe(folder.root(), open, delivery));
            let model = FolderModel::new(folder);
            state.held.replace(Held {
                model,
                wiring,
                open,
                batches: 0,
                revision: 0,
                delivery,
                gate,
                subscription,
            })
        };
        // The replaced grant stops and drains outside the lock, because its callbacks may be waiting on it.
        if let Some(replaced) = replaced {
            replaced.retire();
        }
        OpenResult::Opened
    }

    /// Starts the watcher on `root` with a sink tied to the grant `token`. The sink holds the state
    /// weakly, so a dropped session is not kept alive by its own subscription.
    fn subscribe(&self, root: &Path, token: u64, delivery: Delivery) -> Option<Subscription> {
        let state = Arc::downgrade(&self.state);
        let sink: PathSink = Box::new(move |batch| {
            if let Some(state) = Weak::upgrade(&state) {
                deliver_batch(
                    &state,
                    token,
                    batch,
                    |model, reports| model.list_tree(TreeRequest::Invalidate(reports)),
                    &delivery,
                );
            }
        });
        // A subscription that cannot start leaves the folder open with no delivery, and writes no
        // line: the log holds one line per failed or stopped item (QC-39, QC-52), and a
        // subscription is no item.
        self.watching.subscribe(root, sink).ok()
    }

    /// Lists `path` inside the opened folder and applies the act the reader made there. `Expand`
    /// reads the folder, holds it expanded and answers the held listing; `Collapse` reads nothing and
    /// answers the listing held, or `pending` when none is. The root (the empty path) answers a fresh
    /// read, and so does a path the model refuses (outside, not a folder, missing), with core's own
    /// condition. `None` is an act the boundary could not decode: nothing changes and the answer is
    /// `pending`. Core's item is carried over as it is: `observed` with the entries, or `failed`
    /// with its condition. No folder open is `pending`, because nothing was read.
    pub fn list(&self, path: &str, act: Option<TreeAct>) -> ListAnswerDto {
        let Some(act) = act else {
            return ListAnswerDto::Pending;
        };
        let mut guard = self.lock();
        let Some(held) = guard.held.as_mut() else {
            return ListAnswerDto::Pending;
        };
        if path.is_empty() {
            return list_answer(list_tree(held.model.folder(), path));
        }
        let request = match act {
            TreeAct::Expand => TreeRequest::Expand(PathBuf::from(path)),
            TreeAct::Collapse => TreeRequest::Collapse(PathBuf::from(path)),
        };
        held.model = held.model.clone().list_tree(request);
        let held_listing = held.model.listing(Path::new(path)).cloned();
        match act {
            TreeAct::Expand if held.model.place().is_expanded(Path::new(path)) => {
                held_listing.map_or(ListAnswerDto::Pending, list_answer)
            }
            TreeAct::Expand => list_answer(list_tree(held.model.folder(), path)),
            TreeAct::Collapse => held_listing.map_or(ListAnswerDto::Pending, list_answer),
        }
    }

    /// Answers the open folder's Git item. No folder open is `pending`. A failed switch answers its
    /// own condition and the model is never asked. An item held as `pending` is read, outside the
    /// lock, and stored and answered only if its folder is still the open one; an item already
    /// `observed` or `failed` is answered with no read.
    pub fn read_git(&self) -> GitAnswerDto {
        let (folder, port, open) = {
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
            (held.model.folder().clone(), Arc::clone(port), held.open)
        };
        let item = read_git_item(&folder, port.as_ref());
        let mut state = self.lock();
        // Only the Git item is folded, into the model held now: the clone the read started from
        // would lose any tree update that landed while the read was out.
        if let Some(held) = state.held.as_mut()
            && held.open == open
            && matches!(held.model.kind(), ItemState::Pending)
        {
            held.model = held.model.clone().with_git_item(item);
        }
        state.answer()
    }
}

/// What the reader did to a file row. The boundary decodes the wire's number into this closed set,
/// and a number that is neither reaches the session as no act at all.
///
/// # Examples
///
/// ```
/// use ka_reader_bridge::session::{FileAct, FileAnswerDto, Session};
/// use ka_reader_core::ReadingPosition;
///
/// let session = Session::default();
/// let top = ReadingPosition::new(b"top".as_slice());
/// assert_eq!(session.select_file("a.txt", Some(FileAct::Open(top))), FileAnswerDto::Pending);
/// assert_eq!(session.select_file("a.txt", None), FileAnswerDto::Pending);
/// ```
#[derive(Debug, Clone, PartialEq, Eq)]
pub enum FileAct {
    /// The reader clicked the file: it is selected and opened at the position.
    Open(ReadingPosition),
    /// The reader scrolled the open file: its position becomes this one.
    Position(ReadingPosition),
}

impl Session {
    /// Applies the act the reader made on the file at `path` inside the opened folder. `Open`
    /// selects and opens it at the position and answers its verdict; `Position` sets the open
    /// file's position when `path` is the open file, reads nothing and answers `pending`; `None` is
    /// an act the boundary could not decode and applies nothing. No folder open is `pending`,
    /// because nothing was read.
    pub fn select_file(&self, path: &str, act: Option<FileAct>) -> FileAnswerDto {
        self.act_on_file(path, act, read_file)
    }

    /// `select_file` with the read passed in, so a test can make a batch land while the read is out.
    #[cfg(any(test, feature = "testing"))]
    pub fn select_file_with(
        &self,
        path: &str,
        act: Option<FileAct>,
        read: impl FnOnce(&OpenedFolder, &Path) -> FileRead,
    ) -> FileAnswerDto {
        self.act_on_file(path, act, read)
    }

    /// A copy of the held model's place, for a test that asserts what the session holds.
    #[cfg(any(test, feature = "testing"))]
    pub fn held_place(&self) -> Option<ka_reader_core::ReaderPlace> {
        self.lock()
            .held
            .as_ref()
            .map(|held| held.model.place().clone())
    }

    fn act_on_file(
        &self,
        path: &str,
        act: Option<FileAct>,
        read: impl FnOnce(&OpenedFolder, &Path) -> FileRead,
    ) -> FileAnswerDto {
        match act {
            Some(FileAct::Open(position)) => self.open_file(path, position, read),
            Some(FileAct::Position(position)) => {
                self.position_file(path, position);
                FileAnswerDto::Pending
            }
            None => FileAnswerDto::Pending,
        }
    }

    /// The open act. The opened folder is cloned under the lock and the read runs after it is
    /// released, so a long read never stalls a listing behind it (CP-283). The fold joins the model
    /// under the lock, only for the grant the read was made for; where a batch landed meanwhile, the
    /// open file is read once more under that same hold, so a change during the read is not lost.
    fn open_file(
        &self,
        path: &str,
        position: ReadingPosition,
        read: impl FnOnce(&OpenedFolder, &Path) -> FileRead,
    ) -> FileAnswerDto {
        let held = self
            .lock()
            .held
            .as_ref()
            .map(|held| (held.model.folder().clone(), held.open, held.batches));
        let Some((folder, open, batches)) = held else {
            return FileAnswerDto::Pending;
        };
        let read = read(&folder, Path::new(path));
        let answer = FileAnswerDto::from(read.answer().clone());
        let mut outgoing = None;
        if let Some(held) = self.lock().held.as_mut()
            && held.open == open
        {
            let mut model = held.model.clone().open_read(read, position);
            if held.batches != batches {
                model = model.reread_open_file();
            }
            outgoing = Self::open_payload(held, &model);
            held.model = model;
        }
        // Delivered after the lock is released, from this caller's thread, before the export returns.
        if let Some((payload, delivery, gate)) = outgoing {
            gate.deliver(&delivery, payload);
        }
        answer
    }

    /// The payload an open sends, when the open changed the open file and the grant has a delivery.
    /// A payload that cannot be serialized delivers nothing and writes one `stopped` line.
    fn open_payload(
        held: &mut Held,
        model: &FolderModel,
    ) -> Option<(Vec<u8>, Delivery, Arc<DeliveryGate>)> {
        let delivery = held.delivery.clone()?;
        let changes = model.changes_since(&held.model);
        changes.open_file()?;
        match held.payload_for(&changes) {
            Ok(payload) => Some((payload?, delivery, Arc::clone(&held.gate))),
            Err(_) => {
                log::warn!("core-bridge: model_changed stopped: answer serialization failed");
                None
            }
        }
    }

    /// The position act: applied only when `path` is the open file, and it reads nothing.
    fn position_file(&self, path: &str, position: ReadingPosition) {
        if let Some(held) = self.lock().held.as_mut()
            && held
                .model
                .open_file()
                .is_some_and(|open| open.path() == Path::new(path))
        {
            held.model = held
                .model
                .clone()
                .select_file(FileRequest::Position(position));
        }
    }
}

#[cfg(test)]
mod tests {
    //! Layer 1: the session over temporary folders. The panel belongs to the shell, so every open
    //! here hands in the location as a plain `Option<PathBuf>`.

    use std::path::PathBuf;

    use serde_json::{Value, json};

    use ka_reader_core::{ItemState, ReadingPosition, list_tree, open_folder, read_file};

    use super::{FileAct, FileAnswerDto, Session, TreeAct};
    use crate::test_support::TempDir;

    /// The act a click makes: open at the top.
    fn top() -> FileAct {
        FileAct::Open(ReadingPosition::new(b"top".as_slice()))
    }

    #[test]
    fn test_the_gone_answer_maps_to_the_wire_state_gone() {
        use ka_reader_core::FileView;

        let answer = FileAnswerDto::from(ItemState::Observed(FileView::Gone));

        assert_eq!(answer, FileAnswerDto::Gone);
        assert_eq!(
            serde_json::to_string(&answer).expect("the answer serializes"),
            r#"{"state":"gone"}"#
        );
    }

    #[test]
    fn test_a_read_in_progress_does_not_hold_the_session_lock() {
        use std::sync::mpsc;
        use std::time::Duration;

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
                session.select_file_with("a.txt", Some(top()), |folder, path| {
                    parked_tx.send(()).expect("the test is listening");
                    release_rx.recv().expect("the test releases the read");
                    read_file(folder, path)
                });
            });
            parked_rx
                .recv_timeout(Duration::from_secs(10))
                .expect("the read parked");
            scope.spawn(move || {
                session.list("", Some(TreeAct::Expand));
                listed_tx.send(()).expect("the test is listening");
            });
            let listed = listed_rx.recv_timeout(Duration::from_secs(10));
            release_tx.send(()).expect("the read is parked");
            assert!(listed.is_ok(), "list completed while a read was parked");
        });
    }

    /// The model the session holds right now, cloned out for a test to read.
    fn held_model(session: &Session) -> ka_reader_core::FolderModel {
        session
            .lock()
            .held
            .as_ref()
            .expect("a folder is open")
            .model
            .clone()
    }

    #[test]
    fn test_expand_holds_the_folder_and_collapse_leaves_the_selection_and_expansion_as_made() {
        let folder = TempDir::new();
        folder.write_file("src/main.rs", "fn main() {}");
        folder.write_file("docs/guide.txt", "x");
        let session = Session::default();
        opened(&session, &folder);

        session.list("src", Some(TreeAct::Expand));
        session.list("docs", Some(TreeAct::Expand));
        session.select_file("src/main.rs", Some(top()));
        session.list("docs", Some(TreeAct::Collapse));

        let place = held_model(&session).place().clone();
        assert!(place.is_expanded(std::path::Path::new("src")));
        assert!(!place.is_expanded(std::path::Path::new("docs")));
        assert_eq!(place.selected(), Some(std::path::Path::new("src/main.rs")));
    }

    #[test]
    fn test_a_collapse_reads_nothing() {
        let folder = TempDir::new();
        folder.write_file("src/main.rs", "fn main() {}");
        folder.make_folder("never-expanded");
        let session = Session::default();
        opened(&session, &folder);
        session.list("src", Some(TreeAct::Expand));
        folder.write_file("src/added-after-the-expand.rs", "x");

        let held = answer_to(&session, "src", Some(TreeAct::Collapse));
        let never_held = answer_to(&session, "never-expanded", Some(TreeAct::Collapse));

        assert_eq!(
            names(&held),
            vec!["main.rs"],
            "the held listing, not a fresh read"
        );
        assert_eq!(never_held, json!({ "state": "pending" }));
    }

    #[test]
    fn test_an_unknown_act_changes_nothing_and_answers_pending() {
        let folder = TempDir::new();
        folder.write_file("src/main.rs", "fn main() {}");
        let session = Session::default();
        opened(&session, &folder);
        let before = held_model(&session);

        let answered = answer_to(&session, "src", None);

        assert_eq!(answered, json!({ "state": "pending" }));
        assert_eq!(held_model(&session), before);
    }

    /// The answer to `path` for `act`, as the JSON the shell reads.
    fn answer_to(session: &Session, path: &str, act: Option<TreeAct>) -> Value {
        serde_json::to_value(session.list(path, act)).expect("the answer serializes")
    }

    /// The answer to `path` as the JSON the shell reads.
    fn answer(session: &Session, path: &str) -> Value {
        serde_json::to_value(session.list(path, Some(TreeAct::Expand)))
            .expect("the answer serializes")
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
        let missing = session.open(PathBuf::from("/nonexistent/ka-reader/folder"));

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
        use ka_reader_core::Condition;

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

        use ka_reader_core::{
            BranchElement, ConfigNamedPath, FolderModel, GitPort, GitReadCondition, HeadState,
            OpenFolderOutcome, ProbeCondition, RepositoryState, RootFinding, StatusCategory,
            StatusEntry, StatusLists, SubmoduleNamedPath, open_folder, read_git,
        };
        use serde_json::{Value, json};

        use crate::session::{GitAnswerDto, GitConditionDto};
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
        fn test_each_of_the_conditions_and_the_switch_failure_have_eighteen_distinct_wire_values() {
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
                (
                    wire(&read_failure(GitReadCondition::ObjectStoreNotLocated(
                        "relative/objects".to_string(),
                    ))),
                    "object_store_not_located",
                ),
                (
                    wire(&read_failure(GitReadCondition::SubmoduleElsewhere(
                        SubmoduleNamedPath {
                            name: "submodule".to_string(),
                            path: "evil".to_string(),
                        },
                    ))),
                    "submodule_elsewhere",
                ),
                (
                    wire(&read_failure(GitReadCondition::GitmodulesUnreadable)),
                    "gitmodules_unreadable",
                ),
            ];
            // The probe's variant and the read's variant are one wire value.
            let probe_variant = wire(&probe_failure(ProbeCondition::ConfigNamesOutside(
                named_config_path(),
            )));
            assert_eq!(probe_variant["condition"], "config_names_outside");
            assert_eq!(probe_variant, answers[answers.len() - 6].0);
            let probe_alternates = wire(&probe_failure(ProbeCondition::ObjectStoreNamesOutside(
                "../../../elsewhere/objects".to_string(),
            )));
            assert_eq!(probe_alternates["condition"], "object_store_names_outside");
            assert_eq!(probe_alternates, answers[answers.len() - 5].0);
            let probe_not_located = wire(&probe_failure(ProbeCondition::ConfigNotLocated(
                named_config_path(),
            )));
            assert_eq!(probe_not_located["condition"], "config_not_located");
            assert_eq!(probe_not_located, answers[answers.len() - 4].0);
            let probe_object_store_not_located = wire(&probe_failure(
                ProbeCondition::ObjectStoreNotLocated("relative/objects".to_string()),
            ));
            assert_eq!(
                probe_object_store_not_located["condition"],
                "object_store_not_located"
            );
            assert_eq!(probe_object_store_not_located, answers[answers.len() - 3].0);
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
            assert_eq!(distinct.len(), 18);
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
        fn test_the_object_store_not_located_condition_serializes_exactly_condition_path_and_state()
        {
            let non_utf8_entry = OsStr::from_bytes(b"relative/\xff/objects");
            let value = non_utf8_entry.to_string_lossy().into_owned();
            let from_read = wire(&read_failure(GitReadCondition::ObjectStoreNotLocated(
                value.clone(),
            )));
            let from_probe = wire(&probe_failure(ProbeCondition::ObjectStoreNotLocated(
                value.clone(),
            )));
            // The condition's own conversion, which no answer reaches through the probe's arm.
            assert_eq!(
                serde_json::to_value(GitConditionDto::from(
                    &ProbeCondition::ObjectStoreNotLocated(value)
                ))
                .expect("the condition serializes"),
                json!("object_store_not_located")
            );

            let expected = json!({
                "state": "failed",
                "condition": "object_store_not_located",
                "path": "relative/\u{fffd}/objects"
            });
            assert_eq!(from_read, expected);
            assert_eq!(from_probe, expected);
            assert_eq!(members(&from_read), vec!["condition", "path", "state"]);
        }

        #[test]
        fn test_submodule_elsewhere_serializes_exactly_condition_name_path_state() {
            let non_utf8_name = OsStr::from_bytes(b"vendor-\xff");
            let name = non_utf8_name.to_string_lossy().into_owned();
            let answer = wire(&read_failure(GitReadCondition::SubmoduleElsewhere(
                SubmoduleNamedPath {
                    name,
                    path: "~/lib".to_string(),
                },
            )));

            assert_eq!(
                answer,
                json!({
                    "state": "failed",
                    "condition": "submodule_elsewhere",
                    "name": "vendor-\u{fffd}",
                    "path": "~/lib"
                })
            );
            assert_eq!(members(&answer), vec!["condition", "name", "path", "state"]);
        }

        #[test]
        fn test_gitmodules_unreadable_serializes_exactly_condition_and_state() {
            let answer = wire(&read_failure(GitReadCondition::GitmodulesUnreadable));

            assert_eq!(
                answer,
                json!({ "state": "failed", "condition": "gitmodules_unreadable" })
            );
            assert_eq!(members(&answer), vec!["condition", "state"]);
        }

        #[test]
        fn test_no_other_condition_carries_a_name_member() {
            let named = ConfigNamedPath {
                key: "submodule.x.path".to_string(),
                path: "../outside-x".to_string(),
            };
            let answers = [
                wire(&probe_failure(ProbeCondition::FolderUnavailable)),
                wire(&read_failure(GitReadCondition::NotARoot)),
                wire(&read_failure(GitReadCondition::GitDirectoryOutside(
                    PathBuf::from("/elsewhere/.git"),
                ))),
                wire(&read_failure(GitReadCondition::ConfigNamesOutside(
                    named.clone(),
                ))),
                wire(&read_failure(GitReadCondition::ConfigNotLocated(named))),
                wire(&read_failure(GitReadCondition::ObjectStoreNamesOutside(
                    "../objects".to_string(),
                ))),
                wire(&read_failure(GitReadCondition::ObjectStoreNotLocated(
                    "objects".to_string(),
                ))),
                wire(&read_failure(GitReadCondition::GitmodulesUnreadable)),
                serde_json::to_value(GitAnswerDto::machine_config_not_switched_off())
                    .expect("the answer serializes"),
            ];

            for answer in answers {
                assert!(!members(&answer).contains(&"name".to_string()), "{answer}");
            }
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

        use ka_reader_core::{
            BranchElement, GitPort, GitReadCondition, HeadState, RepositoryState, RootFinding,
            StatusLists,
        };
        use serde_json::{Value, json};

        use crate::machine_config::{Level, SetterFailure, SwitchGuard};
        use crate::session::{Session, TreeAct, Wiring, arrive_wiring};
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
                serde_json::to_value(session.list("", Some(TreeAct::Expand)))
                    .expect("the answer serializes")
            };
            let selected = |session: &Session| {
                serde_json::to_value(session.select_file(
                    "README.md",
                    Some(super::super::FileAct::Open(
                        ka_reader_core::ReadingPosition::new(b"top".as_slice()),
                    )),
                ))
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
        fn test_a_tree_act_during_a_parked_git_read_survives_the_write_back() {
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
            let folder = TempDir::new();
            folder.write_file("src/main.rs", "fn main() {}");
            open(&session, folder.path());

            let session_ref = &session;
            let git = std::thread::scope(|scope| {
                let ask = scope.spawn(move || git_item(session_ref));
                parked_rx
                    .recv_timeout(Duration::from_secs(10))
                    .expect("the Git read parked");
                session_ref.list("src", Some(TreeAct::Expand));
                release_tx.send(()).expect("the read is parked");
                ask.join().expect("the ask finishes")
            });

            assert_eq!(git["state"], "observed");
            let model = session.lock().held.as_ref().expect("open").model.clone();
            assert!(
                model.place().is_expanded(Path::new("src")),
                "the expansion made while the read was out is still held"
            );
            assert!(matches!(
                model.kind(),
                ka_reader_core::ItemState::Observed(_)
            ));
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

    /// Task 12: delivery. The grant token, the sink adapter and `open_delivering`, over the fake
    /// watcher a test drives by hand.
    mod delivery {
        use std::path::{Path, PathBuf};
        use std::sync::atomic::{AtomicBool, AtomicUsize, Ordering};
        use std::sync::mpsc::{Receiver, Sender, channel};
        use std::sync::{Arc, Mutex, Weak};
        use std::thread::JoinHandle;
        use std::time::Duration;

        use ka_reader_core::{
            BranchElement, Entry, FolderModel, GitPort, GitReadCondition, HeadState, ItemState,
            RepositoryState, RootFinding, StatusLists, list_tree,
        };
        use serde_json::Value;

        use crate::session::{Delivery, OpenResult, Session, TreeAct, Wiring, deliver_batch};
        use crate::test_support::{TempDir, begin_log_capture, take_log_records};
        use crate::watcher::fakes::{ManualWatching, RecordedSubscription};
        use crate::watcher::{PathSink, SubscribeError, Subscription, Watching};

        const WAIT: Duration = Duration::from_secs(10);

        /// Tells the test the read parked, and waits for the test to release it.
        type Gate = (Mutex<Sender<()>>, Mutex<Receiver<()>>);

        /// A Git port double: a plain answer, and the first `state` call parks when it holds a gate.
        struct Port {
            gate: Option<Gate>,
            used: AtomicUsize,
        }

        impl Port {
            fn plain() -> Self {
                Self {
                    gate: None,
                    used: AtomicUsize::new(0),
                }
            }
        }

        impl GitPort for Port {
            fn probe(&self, _folder: &Path) -> RootFinding {
                RootFinding::Root
            }

            fn state(&self, _root: &Path) -> Result<HeadState, GitReadCondition> {
                if let Some((parked, release)) = &self.gate
                    && self.used.fetch_add(1, Ordering::SeqCst) == 0
                {
                    parked
                        .lock()
                        .expect("the gate lock")
                        .send(())
                        .expect("the test is listening");
                    release
                        .lock()
                        .expect("the gate lock")
                        .recv_timeout(WAIT)
                        .expect("the test releases the read");
                }
                Ok(HeadState {
                    branch: BranchElement::Branch("main".to_string()),
                    state: RepositoryState::Normal,
                })
            }

            fn status(&self, _root: &Path) -> Result<StatusLists, GitReadCondition> {
                Ok(StatusLists {
                    staged: Vec::new(),
                    changed: Vec::new(),
                })
            }
        }

        /// Every payload a delivery received, parsed, in the order they arrived.
        #[derive(Clone, Default)]
        struct Received(Arc<Mutex<Vec<Value>>>);

        impl Received {
            fn delivery(&self) -> Delivery {
                let log = Arc::clone(&self.0);
                Arc::new(move |bytes: Vec<u8>| {
                    let payload = serde_json::from_slice(&bytes).expect("a JSON payload");
                    log.lock().expect("the payload log").push(payload);
                })
            }

            fn all(&self) -> Vec<Value> {
                self.0.lock().expect("the payload log").clone()
            }
        }

        fn session_over(watching: &Arc<ManualWatching>, port: Port) -> Session {
            let port: Arc<dyn GitPort + Send + Sync> = Arc::new(port);
            Session::with_parts(
                Box::new(move || Wiring::Wired(Arc::clone(&port))),
                Arc::clone(watching) as Arc<dyn Watching>,
            )
        }

        fn session_with(watching: &Arc<ManualWatching>) -> Session {
            session_over(watching, Port::plain())
        }

        fn open_delivering(session: &Session, folder: &TempDir, received: &Received) {
            let result = session.open_delivering(folder.path().to_path_buf(), received.delivery());
            assert!(matches!(result, OpenResult::Opened), "the folder must open");
        }

        fn root_of(folder: &TempDir) -> PathBuf {
            folder.path().canonicalize().expect("a canonical folder")
        }

        fn subscription_on(watching: &ManualWatching, folder: &TempDir) -> RecordedSubscription {
            watching
                .subscription_for(&root_of(folder))
                .expect("a subscription on the folder")
        }

        fn held_model(session: &Session) -> FolderModel {
            session
                .lock()
                .held
                .as_ref()
                .expect("a folder open")
                .model
                .clone()
        }

        fn root_names(model: &FolderModel) -> Vec<String> {
            let ItemState::Observed(entries) = model.tree() else {
                panic!("the root listing is observed");
            };
            entries
                .iter()
                .map(|entry: &Entry| entry.name.clone())
                .collect()
        }

        #[test]
        fn test_a_pushed_batch_delivers_a_payload_holding_the_changed_listing() {
            let folder = TempDir::new();
            folder.write_file("a.txt", "");
            let watching = Arc::new(ManualWatching::new());
            let session = session_with(&watching);
            let received = Received::default();
            open_delivering(&session, &folder, &received);
            assert!(received.all().is_empty(), "opening delivers nothing");

            folder.write_file("b.txt", "");
            subscription_on(&watching, &folder).push(vec![root_of(&folder).join("b.txt")]);

            let payloads = received.all();
            assert_eq!(payloads.len(), 1, "{payloads:?}");
            let listings = payloads[0]["listings"]
                .as_array()
                .expect("a listings array");
            assert_eq!(listings.len(), 1, "only the root listing changed");
            assert_eq!(listings[0]["path"], "");
            let entries = listings[0]["answer"]["entries"]
                .as_array()
                .expect("entries");
            let names: Vec<&str> = entries
                .iter()
                .map(|entry| entry["name"].as_str().expect("a name"))
                .collect();
            assert_eq!(names, ["a.txt", "b.txt"]);
        }

        #[test]
        fn test_a_batch_that_changes_nothing_delivers_nothing() {
            let folder = TempDir::new();
            folder.write_file("a.txt", "");
            let watching = Arc::new(ManualWatching::new());
            let session = session_with(&watching);
            let received = Received::default();
            open_delivering(&session, &folder, &received);

            let recorded = subscription_on(&watching, &folder);
            recorded.push(vec![root_of(&folder).join("a.txt")]);
            recorded.push(vec![]);

            assert!(received.all().is_empty(), "{:?}", received.all());
        }

        /// A watcher that, between starting a subscription and returning it, changes the disk and
        /// has a report pushed from another thread, as a real stream can.
        struct ChangesAtSubscribe {
            inner: Arc<ManualWatching>,
            make_change: Box<dyn Fn() + Send + Sync>,
            report: PathBuf,
            pushers: Mutex<Vec<JoinHandle<()>>>,
        }

        impl Watching for ChangesAtSubscribe {
            fn subscribe(
                &self,
                root: &Path,
                sink: PathSink,
            ) -> Result<Subscription, SubscribeError> {
                let subscription = self.inner.subscribe(root, sink)?;
                (self.make_change)();
                let recorded = self.inner.subscription_for(root).expect("recorded");
                let report = self.report.clone();
                self.pushers
                    .lock()
                    .expect("the pusher list")
                    .push(std::thread::spawn(move || recorded.push(vec![report])));
                Ok(subscription)
            }
        }

        #[test]
        fn test_a_change_made_at_subscribe_time_is_not_lost() {
            let folder = Arc::new(TempDir::new());
            let root = folder.path().canonicalize().expect("canonical");
            let made = Arc::clone(&folder);
            let watching = Arc::new(ChangesAtSubscribe {
                inner: Arc::new(ManualWatching::new()),
                make_change: Box::new(move || {
                    made.write_file("early.txt", "");
                }),
                report: root.join("early.txt"),
                pushers: Mutex::new(Vec::new()),
            });
            let port: Arc<dyn GitPort + Send + Sync> = Arc::new(Port::plain());
            let session = Session::with_parts(
                Box::new(move || Wiring::Wired(Arc::clone(&port))),
                Arc::clone(&watching) as Arc<dyn Watching>,
            );
            let received = Received::default();

            let result = session.open_delivering(root.clone(), received.delivery());
            assert!(matches!(result, OpenResult::Opened));
            for pusher in watching.pushers.lock().expect("the pusher list").drain(..) {
                pusher.join().expect("the report was applied");
            }

            let model = held_model(&session);
            assert_eq!(root_names(&model), ["early.txt"]);
            assert_eq!(
                model.tree(),
                &list_tree(model.folder(), ""),
                "the held root equals a fresh read"
            );
        }

        #[test]
        fn test_two_threads_pushing_while_acts_arrive_end_equal_to_fresh_reads() {
            let folder = TempDir::new();
            folder.make_folder("d0");
            folder.make_folder("d1");
            let watching = Arc::new(ManualWatching::new());
            let session = session_with(&watching);
            let received = Received::default();
            open_delivering(&session, &folder, &received);
            session.list("d0", Some(TreeAct::Expand));
            session.list("d1", Some(TreeAct::Expand));
            let recorded = subscription_on(&watching, &folder);
            let root = root_of(&folder);

            std::thread::scope(|scope| {
                for directory in ["d0", "d1"] {
                    let recorded = recorded.clone();
                    let root = &root;
                    let folder = &folder;
                    scope.spawn(move || {
                        for index in 0..20 {
                            folder.write_file(&format!("{directory}/f{index}.txt"), "");
                            recorded.push(vec![root.join(directory)]);
                        }
                    });
                }
                for round in 0..20 {
                    let act = if round % 2 == 0 {
                        TreeAct::Collapse
                    } else {
                        TreeAct::Expand
                    };
                    session.list("d0", Some(act));
                    session.list("d1", Some(act));
                }
            });

            let model = held_model(&session);
            for directory in ["d0", "d1"] {
                assert_eq!(
                    model.listing(Path::new(directory)),
                    Some(&list_tree(model.folder(), directory)),
                    "{directory} equals a fresh read"
                );
            }
        }

        /// A misbehaving watcher: its stop does nothing, so a sink the session replaced stays
        /// callable. The sink adapter's grant token is what must refuse it.
        struct Leaky {
            sinks: Mutex<Vec<Arc<PathSink>>>,
        }

        impl Watching for Leaky {
            fn subscribe(
                &self,
                _root: &Path,
                sink: PathSink,
            ) -> Result<Subscription, SubscribeError> {
                self.sinks
                    .lock()
                    .expect("the sink list")
                    .push(Arc::new(sink));
                Ok(Subscription::new(|| {}))
            }
        }

        #[test]
        fn test_a_push_to_a_replaced_grants_sink_delivers_nothing_and_leaves_the_model() {
            let first = TempDir::new();
            let second = TempDir::new();
            let leaky = Arc::new(Leaky {
                sinks: Mutex::new(Vec::new()),
            });
            let port: Arc<dyn GitPort + Send + Sync> = Arc::new(Port::plain());
            let session = Session::with_parts(
                Box::new(move || Wiring::Wired(Arc::clone(&port))),
                Arc::clone(&leaky) as Arc<dyn Watching>,
            );
            let first_received = Received::default();
            let second_received = Received::default();
            open_delivering(&session, &first, &first_received);
            open_delivering(&session, &second, &second_received);
            let old_sink = Arc::clone(&leaky.sinks.lock().expect("the sink list")[0]);
            first.write_file("late.txt", "");
            second.write_file("kept.txt", "");
            let before = held_model(&session);

            old_sink(vec![root_of(&first).join("late.txt")]);

            assert!(first_received.all().is_empty());
            assert!(second_received.all().is_empty());
            assert_eq!(held_model(&session), before, "the held model is unchanged");
        }

        #[test]
        fn test_the_old_subscription_is_stopped_and_drained_before_open_delivering_returns() {
            let first = TempDir::new();
            let second = TempDir::new();
            let watching = Arc::new(ManualWatching::new());
            let session = Arc::new(session_with(&watching));
            let (inside_tx, inside_rx) = channel::<()>();
            let (release_tx, release_rx) = channel::<()>();
            let release_rx = Mutex::new(release_rx);
            let inside_tx = Mutex::new(inside_tx);
            let parked_delivery: Delivery = Arc::new(move |_payload| {
                inside_tx
                    .lock()
                    .expect("the lock")
                    .send(())
                    .expect("listening");
                release_rx
                    .lock()
                    .expect("the lock")
                    .recv_timeout(WAIT)
                    .expect("released");
            });
            let result = session.open_delivering(first.path().to_path_buf(), parked_delivery);
            assert!(matches!(result, OpenResult::Opened));
            let old = subscription_on(&watching, &first);
            first.write_file("x.txt", "");
            let report = root_of(&first).join("x.txt");
            let replaced = Arc::new(AtomicBool::new(false));

            std::thread::scope(|scope| {
                let old_push = old.clone();
                scope.spawn(move || old_push.push(vec![report]));
                inside_rx
                    .recv_timeout(WAIT)
                    .expect("the callback is in flight");
                let replacing = Arc::clone(&session);
                let flag = Arc::clone(&replaced);
                let second_path = second.path().to_path_buf();
                let opener = scope.spawn(move || {
                    let result =
                        replacing.open_delivering(second_path, Received::default().delivery());
                    flag.store(true, Ordering::SeqCst);
                    result
                });
                std::thread::sleep(Duration::from_millis(200));
                assert!(
                    !replaced.load(Ordering::SeqCst),
                    "open_delivering waits for the callback in flight"
                );
                release_tx.send(()).expect("the callback is parked");
                let result = opener.join().expect("the replacing open finishes");
                assert!(matches!(result, OpenResult::Opened));
            });

            assert!(old.is_stopped());
            assert!(old.sink_is_released());
        }

        #[test]
        fn test_the_delivery_can_call_list_from_inside_itself() {
            let folder = TempDir::new();
            folder.write_file("a.txt", "");
            let watching = Arc::new(ManualWatching::new());
            let session = Arc::new(session_with(&watching));
            let (listed_tx, listed_rx) = channel::<Value>();
            let listed_tx = Mutex::new(listed_tx);
            let weak: Weak<Session> = Arc::downgrade(&session);
            let delivery: Delivery = Arc::new(move |_payload| {
                let session = weak.upgrade().expect("the session is alive");
                let answer = serde_json::to_value(session.list("", Some(TreeAct::Expand)))
                    .expect("the answer serializes");
                listed_tx
                    .lock()
                    .expect("the lock")
                    .send(answer)
                    .expect("listening");
            });
            let result = session.open_delivering(folder.path().to_path_buf(), delivery);
            assert!(matches!(result, OpenResult::Opened));
            folder.write_file("b.txt", "");
            let recorded = subscription_on(&watching, &folder);
            let report = root_of(&folder).join("b.txt");

            let pusher = std::thread::spawn(move || recorded.push(vec![report]));
            let answer = listed_rx
                .recv_timeout(WAIT)
                .expect("the delivery listed from inside itself");
            pusher.join().expect("the push finishes");

            assert_eq!(answer["entries"].as_array().expect("entries").len(), 2);
        }

        #[test]
        fn test_a_command_only_open_starts_no_subscription() {
            let folder = TempDir::new();
            let watching = Arc::new(ManualWatching::new());
            let session = session_with(&watching);

            let result = session.open(folder.path().to_path_buf());

            assert!(matches!(result, OpenResult::Opened));
            assert!(watching.recorded().is_empty());
        }

        #[test]
        fn test_a_failed_open_leaves_the_earlier_grants_subscription_as_it_was() {
            let folder = TempDir::new();
            folder.write_file("a.txt", "");
            let watching = Arc::new(ManualWatching::new());
            let session = session_with(&watching);
            let received = Received::default();
            open_delivering(&session, &folder, &received);
            let missing = folder.path().join("no-such-folder");

            let result = session.open_delivering(missing, Received::default().delivery());

            assert!(matches!(result, OpenResult::Failed { .. }));
            assert_eq!(
                watching.recorded().len(),
                1,
                "a failed open registers nothing"
            );
            let recorded = subscription_on(&watching, &folder);
            assert!(!recorded.is_stopped());
            folder.write_file("b.txt", "");
            recorded.push(vec![root_of(&folder).join("b.txt")]);
            assert_eq!(
                received.all().len(),
                1,
                "the earlier delivery still answers"
            );
        }

        #[test]
        fn test_a_batch_applied_during_a_parked_git_read_survives_the_write_back() {
            let (parked_tx, parked_rx) = channel::<()>();
            let (release_tx, release_rx) = channel::<()>();
            let port = Port {
                gate: Some((Mutex::new(parked_tx), Mutex::new(release_rx))),
                used: AtomicUsize::new(0),
            };
            let folder = TempDir::new();
            folder.write_file("a.txt", "");
            let watching = Arc::new(ManualWatching::new());
            let session = session_over(&watching, port);
            let received = Received::default();
            open_delivering(&session, &folder, &received);
            let recorded = subscription_on(&watching, &folder);

            let session_ref = &session;
            std::thread::scope(|scope| {
                let ask = scope.spawn(move || session_ref.read_git());
                parked_rx.recv_timeout(WAIT).expect("the Git read parked");
                folder.write_file("b.txt", "");
                recorded.push(vec![root_of(&folder).join("b.txt")]);
                release_tx.send(()).expect("the read is parked");
                ask.join().expect("the ask finishes");
            });

            let model = held_model(&session);
            assert_eq!(root_names(&model), ["a.txt", "b.txt"]);
            assert!(matches!(model.kind(), ItemState::Observed(_)));
        }

        #[test]
        fn test_a_panicking_batch_delivers_nothing_writes_one_stopped_line_and_leaves_the_model_intact()
         {
            let _serial = begin_log_capture();
            let folder = TempDir::new();
            folder.write_file("a.txt", "");
            let watching = Arc::new(ManualWatching::new());
            let session = session_with(&watching);
            let received = Received::default();
            open_delivering(&session, &folder, &received);
            let before = held_model(&session);
            let token = session.lock().held.as_ref().expect("open").open;
            take_log_records();

            deliver_batch(
                &session.state,
                token,
                vec![root_of(&folder).join("a.txt")],
                |_model, _reports| panic!("the reduction failed"),
                &received.delivery(),
            );

            let lines: Vec<String> = take_log_records()
                .into_iter()
                .filter(|record| record.contains("core-bridge"))
                .collect();
            assert!(received.all().is_empty());
            assert_eq!(held_model(&session), before);
            assert_eq!(
                lines,
                ["core-bridge: model_changed stopped: boundary panicked"]
            );
        }

        #[test]
        fn test_a_subscription_that_cannot_start_opens_the_folder_with_no_delivery() {
            let folder = TempDir::new();
            folder.write_file("a.txt", "");
            let watching = Arc::new(ManualWatching::failing());
            let session = session_with(&watching);
            let received = Received::default();

            open_delivering(&session, &folder, &received);

            assert!(watching.recorded().is_empty());
            assert_eq!(root_names(&held_model(&session)), ["a.txt"]);
            assert!(received.all().is_empty());
        }

        #[test]
        fn test_a_failed_subscribe_logs_nothing() {
            let _serial = begin_log_capture();
            let folder = TempDir::new();
            let watching = Arc::new(ManualWatching::failing());
            let session = session_with(&watching);
            take_log_records();

            open_delivering(&session, &folder, &Received::default());

            // The capture is the process logger, so a test running beside this one that logs from
            // another crate's code lands here too. Only the bridge's own lines are this test's.
            let lines: Vec<String> = take_log_records()
                .into_iter()
                .filter(|record| record.contains("core-bridge"))
                .collect();
            assert_eq!(lines, Vec::<String>::new());
        }
    }
}
