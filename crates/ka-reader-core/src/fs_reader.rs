//! fs-reader: turns a requested path into a location known to lie inside a canonical root, and
//! lists that location's direct entries, each with its own state.

use std::collections::VecDeque;
use std::ffi::{OsStr, OsString};
use std::fs;
use std::io::{self, Read};
use std::os::unix::ffi::{OsStrExt, OsStringExt};
use std::os::unix::fs::{MetadataExt, OpenOptionsExt};
use std::path::{Component, Path, PathBuf};

use rustix::fs::OFlags;

use crate::language::Language;

#[cfg(any(test, feature = "testing"))]
pub mod fakes;

/// The observed condition that stopped opening a chosen folder.
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum OpenFailure {
    Missing,
    NotAFolder,
    Unreadable,
}

/// A private opening failure with the public condition and safe diagnostic detail.
#[derive(Debug, PartialEq, Eq)]
pub(crate) struct OpeningFailure {
    pub(crate) condition: OpenFailure,
    pub(crate) text: String,
}

impl OpeningFailure {
    fn from_error(error: io::Error) -> Self {
        let condition = match error.kind() {
            io::ErrorKind::NotFound => OpenFailure::Missing,
            io::ErrorKind::NotADirectory => OpenFailure::NotAFolder,
            _ => OpenFailure::Unreadable,
        };
        Self {
            condition,
            text: error.to_string(),
        }
    }

    fn not_a_folder() -> Self {
        Self {
            condition: OpenFailure::NotAFolder,
            text: "the selected path is not a folder".to_string(),
        }
    }
}

trait OpeningFilesystem {
    fn canonicalize(&self, path: &Path) -> io::Result<PathBuf>;
    fn is_directory(&self, path: &Path) -> io::Result<bool>;
    fn read_directory(&self, path: &Path) -> io::Result<()>;
}

struct NativeOpeningFilesystem;

impl OpeningFilesystem for NativeOpeningFilesystem {
    fn canonicalize(&self, path: &Path) -> io::Result<PathBuf> {
        path.canonicalize()
    }

    fn is_directory(&self, path: &Path) -> io::Result<bool> {
        Ok(fs::metadata(path)?.is_dir())
    }

    fn read_directory(&self, path: &Path) -> io::Result<()> {
        fs::read_dir(path).map(|_| ())
    }
}

/// Observes whether a chosen path is a readable directory without producing its entries.
pub(crate) fn open_root(path: &Path) -> Result<PathBuf, OpeningFailure> {
    open_root_with_filesystem(&NativeOpeningFilesystem, path)
}

fn open_root_with_filesystem(
    filesystem: &impl OpeningFilesystem,
    path: &Path,
) -> Result<PathBuf, OpeningFailure> {
    let root = filesystem
        .canonicalize(path)
        .map_err(OpeningFailure::from_error)?;
    let is_directory = filesystem
        .is_directory(&root)
        .map_err(OpeningFailure::from_error)?;
    if !is_directory {
        return Err(OpeningFailure::not_a_folder());
    }
    filesystem
        .read_directory(&root)
        .map_err(OpeningFailure::from_error)?;
    Ok(root)
}

/// What a directory entry is once it is resolved. A link lists as the folder or file it reaches.
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum EntryKind {
    Folder,
    File,
}

/// Why an item could not be read, drawn from a closed set. It carries no text and no path.
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum Condition {
    /// The operating system refused the read, or the read failed in a way this set does not name.
    Unreadable,
    /// The path or link target leaves the opened folder. Nothing outside it was touched.
    Outside,
    /// A link whose resolution loops back on itself.
    Cycle,
    /// Something on the path is not there. A link whose target runs through a file is Missing too:
    /// the target names something that is not there.
    Missing,
    /// A file was listed, or a path the caller spelled went through one.
    NotAFolder,
    /// A chain of links longer than [`MAX_LINK_HOPS`], with no cycle found.
    TooManyLinks,
}

/// Where an item stands: not read yet, read, or failed to read for a named reason.
///
/// Only the failure arm takes a second type parameter, so a read whose failure must carry more than
/// [`Condition`] can (the Git item, whose failure may hold the Git directory's path) is an item too.
/// `C` defaults to [`Condition`], so `ItemState<T>` keeps meaning what it always meant.
#[derive(Debug, Clone, PartialEq, Eq)]
pub enum ItemState<T, C = Condition> {
    Pending,
    Observed(T),
    Failed(C),
}

impl<T, C> ItemState<T, C> {
    /// The same state with an observed value carried through `convert`; `Pending` and `Failed` pass
    /// as they are.
    pub(crate) fn map<U>(self, convert: impl FnOnce(T) -> U) -> ItemState<U, C> {
        match self {
            Self::Pending => ItemState::Pending,
            Self::Observed(value) => ItemState::Observed(convert(value)),
            Self::Failed(condition) => ItemState::Failed(condition),
        }
    }
}

/// One direct entry of a listed folder.
///
/// A folder is `Pending`, and a file is `Observed`. An entry that failed is always a `File`.
/// A file carries the language its own name gives it (a link its own name, never its target's), in
/// every state, and a folder carries none, so `language.is_some() == (kind == File)`.
#[derive(Debug, Clone, PartialEq, Eq)]
pub struct Entry {
    pub name: String,
    pub path: String,
    pub kind: EntryKind,
    pub state: ItemState<()>,
    pub language: Option<Language>,
}

/// What a selected file turned out to be: its text, or the fact that it cannot be shown as text.
#[derive(Debug, Clone, PartialEq, Eq)]
pub enum FileContent {
    /// The file's decoded characters, whole, with no byte-order mark among them.
    Text { content: String, language: Language },
    /// The decoded characters of a text file whose name is a Markdown name (see
    /// [`MARKDOWN_EXTENSIONS`]), whole, with no byte-order mark among them. The model renders it;
    /// this part only names it.
    Markdown { content: String },
    /// The file is not text under the text rule, for the reason named.
    CannotDisplay(CannotDisplayReason),
}

/// Why a file is not text: the two ways the text rule turns a file away.
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum CannotDisplayReason {
    /// The bytes are not valid UTF-8.
    InvalidUtf8,
    /// The bytes begin with a UTF-16 byte-order mark and the rest does not decode as UTF-16.
    InvalidUtf16,
}

/// The most symbolic links one requested path may pass through before the answer is `TooManyLinks`.
const MAX_LINK_HOPS: usize = 32;

/// UTF-8's byte-order mark, which is stripped and is not among a file's characters.
const UTF8_MARK: [u8; 3] = [0xEF, 0xBB, 0xBF];

/// The marks that name a UTF-16 file's byte order, each stripped before the rest is decoded.
const UTF16_LITTLE_ENDIAN_MARK: [u8; 2] = [0xFF, 0xFE];
const UTF16_BIG_ENDIAN_MARK: [u8; 2] = [0xFE, 0xFF];

/// The text a log line carries for something that is not a regular file. The operating system was
/// never asked, so there is no error text of its own.
const NOT_A_REGULAR_FILE_TEXT: &str = "the path is not a regular file";

/// The text a log line carries for a path that leaves the opened folder. The operating system was
/// never asked, so there is no error text of its own.
const OUTSIDE_TEXT: &str = "the path leaves the opened folder";

/// The text a log line carries when the hop bound is passed.
const TOO_MANY_LINKS_TEXT: &str = "too many levels of symbolic links";

/// The text a log line carries when a link leads back to itself. The operating system was never
/// asked, so there is no error text of its own.
const CYCLE_TEXT: &str = "the link leads back to itself";

/// The two spellings that end a link's target in a demand that its last name be a folder. Both are
/// dropped by `Path::components`, so [`target_steps_of`] looks for them in the raw bytes.
const FOLDER_DEMANDING_ENDINGS: [&[u8]; 2] = [b"/", b"/."];

/// One step of a requested path, still to be taken.
enum Step {
    Parent,
    Name(OsString),
    /// A link target's demand, spelled by a trailing separator or a trailing `.`, that the name
    /// before it be a folder. `Path::components` drops both spellings, so the demand is queued as a
    /// step of its own. Taking it moves nothing and changes nothing.
    MustBeFolder,
    /// The end of a link's target. It sits in the queue behind the target's own steps, so a link is
    /// still being resolved for as long as its marker is queued. `link` is the link's location and
    /// `parent` is the position the link was met from.
    EndOfLink {
        link: PathBuf,
        parent: PathBuf,
    },
}

#[derive(Default)]
struct VolumeFacts {
    root_is_volume_root: Option<bool>,
    ignores_letter_case: Option<bool>,
}

trait Filesystem {
    fn symlink_metadata(&self, path: &Path) -> io::Result<fs::Metadata>;
    fn read_link(&self, path: &Path) -> io::Result<PathBuf>;
    fn read_dir(&self, path: &Path) -> io::Result<Vec<fs::DirEntry>>;
    fn mount_point(&self, root: &Path) -> Option<PathBuf>;
    fn case_fact(&self) -> Option<Option<bool>> {
        None
    }
}

struct NativeFilesystem;

impl Filesystem for NativeFilesystem {
    fn symlink_metadata(&self, path: &Path) -> io::Result<fs::Metadata> {
        fs::symlink_metadata(path)
    }
    fn read_link(&self, path: &Path) -> io::Result<PathBuf> {
        fs::read_link(path)
    }
    fn read_dir(&self, path: &Path) -> io::Result<Vec<fs::DirEntry>> {
        fs::read_dir(path)?.collect()
    }
    #[cfg(target_os = "macos")]
    fn mount_point(&self, root: &Path) -> Option<PathBuf> {
        let filesystem = rustix::fs::statfs(root.as_os_str().as_bytes()).ok()?;
        let bytes = filesystem.f_mntonname;
        let end = bytes.iter().position(|byte| *byte == 0)?;
        Some(PathBuf::from(OsString::from_vec(
            bytes[..end].iter().map(|byte| *byte as u8).collect(),
        )))
    }
    #[cfg(not(target_os = "macos"))]
    fn mount_point(&self, _: &Path) -> Option<PathBuf> {
        None
    }
}

/// Why a requested path did not resolve to a location that can be listed. `text` is what a log
/// line carries: the operating system's own error text, or a fixed phrase. It never names a path.
struct Blocked {
    condition: Condition,
    text: String,
    /// The walk met no entry at a step of the path as the caller spelled it, or a non-folder where
    /// the spelled path goes on, with no link's target being resolved at that step. It is a fact
    /// about where the walk stopped, so building a `Blocked` from an error never sets it.
    nothing_there: bool,
}

impl Blocked {
    fn outside() -> Self {
        Self {
            condition: Condition::Outside,
            text: OUTSIDE_TEXT.to_string(),
            nothing_there: false,
        }
    }

    fn cycle() -> Self {
        Self {
            condition: Condition::Cycle,
            text: CYCLE_TEXT.to_string(),
            nothing_there: false,
        }
    }

    /// A link's target ran into a file where it needs a folder. The link leads to something that is
    /// not there, and the log line keeps what the operating system says of a file met as a folder.
    fn through_a_file() -> Self {
        Self {
            condition: Condition::Missing,
            text: io::Error::from(io::ErrorKind::NotADirectory).to_string(),
            nothing_there: false,
        }
    }

    /// A folder, or something that is not a regular file once opened: a read has nothing to return.
    /// It is the set's catch-all, since no condition is added for it.
    fn not_a_regular_file() -> Self {
        Self {
            condition: Condition::Unreadable,
            text: NOT_A_REGULAR_FILE_TEXT.to_string(),
            nothing_there: false,
        }
    }

    /// The same failure, marked as the walk finding nothing at the caller's spelled path.
    fn nothing_there(self) -> Self {
        Self {
            nothing_there: true,
            ..self
        }
    }

    fn too_many_links() -> Self {
        Self {
            condition: Condition::TooManyLinks,
            text: TOO_MANY_LINKS_TEXT.to_string(),
            nothing_there: false,
        }
    }
}

impl From<&io::Error> for Blocked {
    fn from(error: &io::Error) -> Self {
        Self {
            condition: condition_for(error.kind()),
            text: error.to_string(),
            nothing_there: false,
        }
    }
}

/// The condition an I/O error kind is reported as. A kind this set does not name is `Unreadable`.
fn condition_for(kind: io::ErrorKind) -> Condition {
    match kind {
        io::ErrorKind::NotFound => Condition::Missing,
        io::ErrorKind::NotADirectory => Condition::NotAFolder,
        _ => Condition::Unreadable,
    }
}

/// A location resolution reached, below the root, and what the last step found there.
struct Resolved {
    below_root: PathBuf,
    kind: EntryKind,
}

/// Lists the direct entries of `requested`, a path relative to `root` or absolute, where `root` is
/// a canonical folder path.
///
/// The answer is `Observed` with the entries, or `Failed` with the condition that stopped it. It is
/// never `Pending`. A path that resolves outside `root` is `Failed(Outside)`, and nothing outside
/// `root` is touched to decide that. One record is logged at `warn` for a failed answer, prefixed
/// `fs-reader: list failed: `, and one for each entry that failed, prefixed
/// `fs-reader: entry failed: `. Each carries the operating system's error text or a fixed phrase,
/// and no path.
pub fn list(root: &Path, requested: &str) -> ItemState<Vec<Entry>> {
    list_with_filesystem(&NativeFilesystem, root, requested)
}

fn list_with_filesystem(
    filesystem: &impl Filesystem,
    root: &Path,
    requested: &str,
) -> ItemState<Vec<Entry>> {
    observe_listing_with_filesystem(filesystem, root, Path::new(requested))
        .map(ListingObservation::into_entries)
}

/// Observes the direct entries of `requested`, a path relative to `root`, keeping what [`list`]'s
/// answer discards: the folder's resolved location and, for each entry, the raw name the operating
/// system reported. The path is resolved by the walk [`list`] uses and each entry is classified the
/// way [`list`] classifies it, so the two answers agree entry for entry. The answer is `Observed`
/// or `Failed`, never `Pending`, and a failure is logged exactly as [`list`] logs it.
pub(crate) fn observe_listing(root: &Path, requested: &Path) -> ItemState<ListingObservation> {
    observe_listing_with_filesystem(&NativeFilesystem, root, requested)
}

fn observe_listing_with_filesystem(
    filesystem: &impl Filesystem,
    root: &Path,
    requested: &Path,
) -> ItemState<ListingObservation> {
    match resolve(filesystem, root, requested).and_then(|at| {
        list_folder(filesystem, root, &at.below_root).map(|items| ListingObservation {
            location: at.below_root,
            items,
        })
    }) {
        Ok(observation) => ItemState::Observed(observation),
        Err(blocked) => {
            log::warn!("fs-reader: list failed: {}", blocked.text);
            ItemState::Failed(blocked.condition)
        }
    }
}

/// The entry a reference reached: its path below the root, as the walk resolved it, and what it is.
///
/// A link is the folder or file it reaches, so `path` names the target and never the spelling the
/// reference used.
#[derive(Debug, Clone, PartialEq, Eq)]
pub struct ContainedEntry {
    pub path: PathBuf,
    pub kind: EntryKind,
}

/// The containment check for a path derived from content, such as the target of an image or a link in
/// a Markdown file.
///
/// `folder` is the folder that holds the file, below the root (empty for the root itself). `reference`
/// is the path text exactly as the parser gave it, with no scheme and any fragment already removed by
/// the caller. The reference is percent-decoded, placed under `folder` (a reference that starts with
/// `/` stays as written), and walked from the root by the same walk [`list`] uses, so nothing outside
/// the root is touched. The answer is the entry reached, or the [`Condition`] the walk observed. No
/// log line is written: a refused reference is an answer the caller holds, not a failed read.
///
/// # Examples
///
/// ```
/// use std::path::Path;
///
/// use ka_reader_core::{Condition, ContainmentCheck, FolderContainment, open_folder};
///
/// let opened = open_folder(std::env::temp_dir()).expect("the temporary folder opens");
/// let check = FolderContainment::new(opened.root().to_path_buf());
/// assert_eq!(check.check(Path::new(""), "%2E%2E/escape.png"), Err(Condition::Outside));
/// ```
pub trait ContainmentCheck {
    fn check(&self, folder: &Path, reference: &str) -> Result<ContainedEntry, Condition>;
}

/// The real [`ContainmentCheck`], over one canonical root.
#[derive(Debug, Clone, PartialEq, Eq)]
pub struct FolderContainment {
    root: PathBuf,
}

impl FolderContainment {
    /// A check over `root`, which must be canonical, as an opened folder's root is.
    pub fn new(root: PathBuf) -> Self {
        Self { root }
    }
}

impl ContainmentCheck for FolderContainment {
    fn check(&self, folder: &Path, reference: &str) -> Result<ContainedEntry, Condition> {
        // Only the reference is decoded, and before it is placed: a folder whose own name holds `%`
        // is a name, not an encoding. `resolve` is called directly because `locate` writes a line.
        let requested = folder.join(percent_decode(reference));
        resolve(&NativeFilesystem, &self.root, &requested)
            .map(|at| ContainedEntry {
                path: at.below_root,
                kind: at.kind,
            })
            .map_err(|blocked| blocked.condition)
    }
}

/// `reference` with each `%` and the two hex digits after it turned into their byte, and every other
/// byte, an invalid escape included, kept as it is. It works on bytes, so a decoded byte that is not
/// UTF-8 reaches the walk unchanged, and it runs once: `%252E` becomes the three characters `%2E`.
fn percent_decode(reference: &str) -> PathBuf {
    let bytes = reference.as_bytes();
    let mut decoded = Vec::with_capacity(bytes.len());
    let mut at = 0;
    while at < bytes.len() {
        let escaped = (bytes[at] == b'%')
            .then(|| bytes.get(at + 1..at + 3))
            .flatten()
            .and_then(hex_byte);
        match escaped {
            Some(byte) => {
                decoded.push(byte);
                at += PERCENT_ESCAPE_LENGTH;
            }
            None => {
                decoded.push(bytes[at]);
                at += 1;
            }
        }
    }
    PathBuf::from(OsString::from_vec(decoded))
}

/// The length of a percent escape: the `%` and its two hex digits.
const PERCENT_ESCAPE_LENGTH: usize = 3;

/// The byte two hex digits spell, or `None` when either is not a hex digit.
fn hex_byte(digits: &[u8]) -> Option<u8> {
    let high = char::from(*digits.first()?).to_digit(16)?;
    let low = char::from(*digits.get(1)?).to_digit(16)?;
    u8::try_from(high * 16 + low).ok()
}

/// Where a requested path resolves to, below the root, and what the last step found there.
///
/// `identity` is the resolved location, so two requests that reach one folder (a link shown as a
/// folder and its target) share it, and it is never the spelling the caller asked with.
#[derive(Debug, Clone, PartialEq, Eq)]
pub(crate) struct Location {
    pub(crate) identity: PathBuf,
    pub(crate) kind: EntryKind,
}

/// Resolves `requested`, a path relative to `root`, to its [`Location`] by the containment walk
/// [`list`] uses, reading no folder's entries and no file's bytes. A failure is the walk's own
/// condition, logged at `warn` as `fs-reader: locate failed: ` with a fixed phrase and no path.
pub(crate) fn locate(root: &Path, requested: &Path) -> Result<Location, Condition> {
    resolve(&NativeFilesystem, root, requested)
        .map(|at| Location {
            identity: at.below_root,
            kind: at.kind,
        })
        .map_err(|blocked| {
            log::warn!("fs-reader: locate failed: {}", blocked.text);
            blocked.condition
        })
}

/// The [`Location`] of the folder that holds `requested`. It is the question to ask of a removed
/// entry, whose own path no longer resolves while its parent still does.
pub(crate) fn locate_parent(root: &Path, requested: &Path) -> Result<Location, Condition> {
    locate(root, requested.parent().unwrap_or(Path::new("")))
}

/// Reads the file at `requested`, a path relative to `root`, and decides its verdict.
///
/// The path is resolved by the same containment walk [`list`] uses, so the check has one
/// implementation. The answer is `Observed` with the file's verdict, or `Failed` with the condition
/// that stopped it, and it is never `Pending`. A folder, and anything that is not a regular file once
/// opened, is `Failed(Unreadable)`. One record is logged at `warn` for a failed answer, prefixed
/// `fs-reader: read failed: `, carrying the operating system's error text or a fixed phrase and no
/// path. A text or cannot-display answer logs nothing.
pub(crate) fn read(root: &Path, requested: &str) -> ItemState<FileContent> {
    read_with_filesystem(&NativeFilesystem, root, requested)
}

fn read_with_filesystem(
    filesystem: &impl Filesystem,
    root: &Path,
    requested: &str,
) -> ItemState<FileContent> {
    observe_file_with_filesystem(filesystem, root, Path::new(requested))
}

/// Reads the file at `requested`, a path relative to `root`, exactly as [`read`] reads the same
/// path spelled as text: the one difference is that the caller keeps the path as the native value
/// it holds, so a name that is not UTF-8 reaches the walk unchanged.
pub(crate) fn observe_file(root: &Path, requested: &Path) -> ItemState<FileContent> {
    observe_file_with_filesystem(&NativeFilesystem, root, requested)
}

fn observe_file_with_filesystem(
    filesystem: &impl Filesystem,
    root: &Path,
    requested: &Path,
) -> ItemState<FileContent> {
    failed_or_observed(attempt_file(filesystem, root, requested).outcome)
}

/// What a re-read of one file found at its path: nothing, or a read with its own outcome.
#[derive(Debug, Clone, PartialEq, Eq)]
pub(crate) enum Reobserved {
    /// Nothing is at the path as the caller spelled it: the walk met no entry at a step of it, or
    /// met a non-folder where it goes on, and no link's target was being resolved at that step.
    /// It carries nothing, and no log line is written for it.
    Absent,
    /// Something is at the path, or the walk was stopped by something else: the outcome
    /// [`observe_file`] gives, and the location below the root when the walk resolved to a file.
    Read {
        state: ItemState<FileContent>,
        location: Option<PathBuf>,
    },
}

/// Reads the file at `requested`, a path relative to `root`, as [`observe_file`] does, and tells
/// the two ways a re-read can come back empty apart: [`Reobserved::Absent`] when nothing is at the
/// path, and [`Reobserved::Read`] with `Failed(condition)` for everything else that stops it.
///
/// Every failure other than *absent* writes the `fs-reader: read failed: ` line [`observe_file`]
/// writes. A link whose target is missing, outside the folder, looping or too long, a folder at the
/// path, and an unreadable or non-regular file are each a failed read, never absent. Containment is
/// the walk's own, so nothing outside `root` is touched.
pub(crate) fn reobserve_file(root: &Path, requested: &Path) -> Reobserved {
    reobserve_file_with_filesystem(&NativeFilesystem, root, requested)
}

fn reobserve_file_with_filesystem(
    filesystem: &impl Filesystem,
    root: &Path,
    requested: &Path,
) -> Reobserved {
    let FileAttempt { location, outcome } = attempt_file(filesystem, root, requested);
    match outcome {
        Err(blocked) if blocked.nothing_there => Reobserved::Absent,
        outcome => Reobserved::Read {
            state: failed_or_observed(outcome),
            location,
        },
    }
}

/// The walk and the read of one file, before any failure is logged.
struct FileAttempt {
    /// The file's location below the root, when the walk resolved to a file.
    location: Option<PathBuf>,
    outcome: Result<FileContent, Blocked>,
}

fn attempt_file(filesystem: &impl Filesystem, root: &Path, requested: &Path) -> FileAttempt {
    let at = match resolve(filesystem, root, requested) {
        Ok(at) => at,
        Err(blocked) => {
            return FileAttempt {
                location: None,
                outcome: Err(blocked),
            };
        }
    };
    match at.kind {
        EntryKind::Folder => FileAttempt {
            location: None,
            outcome: Err(Blocked::not_a_regular_file()),
        },
        EntryKind::File => {
            let file_name = requested.file_name().unwrap_or_default();
            let outcome =
                read_bytes(&root.join(&at.below_root)).map(|bytes| decode(bytes, file_name));
            FileAttempt {
                location: Some(at.below_root),
                outcome,
            }
        }
    }
}

/// The item a read's outcome is, with the one `warn` line a failed read writes.
fn failed_or_observed(outcome: Result<FileContent, Blocked>) -> ItemState<FileContent> {
    match outcome {
        Ok(content) => ItemState::Observed(content),
        Err(blocked) => {
            log::warn!("fs-reader: read failed: {}", blocked.text);
            ItemState::Failed(blocked.condition)
        }
    }
}

/// The whole contents of the regular file at `location`.
///
/// It is opened for reading only (QC-2). `O_NOFOLLOW` makes a link swapped in after the walk fail
/// instead of being followed, and `O_NONBLOCK` keeps a FIFO from hanging the open. The handle is then
/// asked what it is, so a FIFO, a device or a folder is refused before any byte is read. The flags
/// come from `rustix`, which is already a dependency; `std` opens, so a deep path is not bounded.
fn read_bytes(location: &Path) -> Result<Vec<u8>, Blocked> {
    let flags = i32::try_from((OFlags::NOFOLLOW | OFlags::NONBLOCK).bits())
        .expect("the two open flags are small bits that fit the i32 `custom_flags` takes");
    let mut file = fs::OpenOptions::new()
        .read(true)
        .custom_flags(flags)
        .open(location)
        .map_err(|error| Blocked::from(&error))?;
    let metadata = file.metadata().map_err(|error| Blocked::from(&error))?;
    if !metadata.is_file() {
        return Err(Blocked::not_a_regular_file());
    }
    let mut bytes = Vec::new();
    file.read_to_end(&mut bytes)
        .map_err(|error| Blocked::from(&error))?;
    Ok(bytes)
}

/// The text rule. UTF-8, with or without its mark, is text; so is UTF-16 that begins with its mark
/// and decodes in the order that mark names. Anything else is not text. The decode is strict, never
/// lossy, so a file that is not text can never come back as text full of U+FFFD.
///
/// A text file is `Markdown` when its name says so, and otherwise `Text` in the language its name
/// gives; both are decided from `file_name` alone, as the spelling the reader was asked with.
fn decode(bytes: Vec<u8>, file_name: &OsStr) -> FileContent {
    let (content, reason) = if let Some(units) = bytes.strip_prefix(&UTF16_LITTLE_ENDIAN_MARK) {
        (
            decode_utf16(units, u16::from_le_bytes),
            CannotDisplayReason::InvalidUtf16,
        )
    } else if let Some(units) = bytes.strip_prefix(&UTF16_BIG_ENDIAN_MARK) {
        (
            decode_utf16(units, u16::from_be_bytes),
            CannotDisplayReason::InvalidUtf16,
        )
    } else {
        let characters = bytes.strip_prefix(&UTF8_MARK).unwrap_or(&bytes);
        (
            std::str::from_utf8(characters).ok().map(str::to_owned),
            CannotDisplayReason::InvalidUtf8,
        )
    };
    match content {
        Some(content) if is_markdown_name(file_name) => FileContent::Markdown { content },
        Some(content) => FileContent::Text {
            content,
            language: language_of(file_name),
        },
        None => FileContent::CannotDisplay(reason),
    }
}

/// `units` as UTF-16 in the byte order `to_unit` reads, or `None` for an odd trailing byte or an
/// unpaired surrogate.
fn decode_utf16(units: &[u8], to_unit: fn([u8; 2]) -> u16) -> Option<String> {
    let (pairs, remainder) = units.as_chunks::<2>();
    if !remainder.is_empty() {
        return None;
    }
    let code_units: Vec<u16> = pairs.iter().map(|pair| to_unit(*pair)).collect();
    String::from_utf16(&code_units).ok()
}

/// The floor languages and the extensions that name them (SDD § 4 C-I5). Compared without ASCII case.
const EXTENSIONS_BY_LANGUAGE: [(Language, &[&str]); 6] = [
    (Language::Python, &["py", "pyi", "pyw"]),
    (Language::Shell, &["sh", "bash", "zsh"]),
    (Language::JavaScript, &["js", "mjs", "cjs", "jsx"]),
    (Language::Json, &["json"]),
    (Language::Yaml, &["yaml", "yml"]),
    (Language::Toml, &["toml"]),
];

/// The extensions that name a Markdown file, the extension map's Markdown row. Compared without
/// ASCII case, by the same last-extension rule [`language_of`] uses.
const MARKDOWN_EXTENSIONS: [&str; 2] = ["md", "markdown"];

/// Whether the last extension of `file_name` is a Markdown one. `.md` alone and `notes.md.txt` are
/// not Markdown, for the reasons `language_of` gives for its own table.
fn is_markdown_name(file_name: &OsStr) -> bool {
    Path::new(file_name)
        .extension()
        .and_then(OsStr::to_str)
        .is_some_and(|extension| {
            MARKDOWN_EXTENSIONS
                .iter()
                .any(|known| known.eq_ignore_ascii_case(extension))
        })
}

/// The language a text file is drawn as, from the last extension of its name alone, so content never
/// reaches it. The extension is the text after the name's last `.` when that `.` is neither its first
/// nor its last character (CP-289). A name without one, an extension that is not UTF-8 and an extension
/// outside the table are `Plain`; ASCII case is ignored and nothing else is (CP-290, CP-291).
fn language_of(file_name: &OsStr) -> Language {
    let Some(extension) = Path::new(file_name).extension().and_then(OsStr::to_str) else {
        return Language::Plain;
    };
    EXTENSIONS_BY_LANGUAGE
        .iter()
        .find(|(_, extensions)| {
            extensions
                .iter()
                .any(|known| known.eq_ignore_ascii_case(extension))
        })
        .map_or(Language::Plain, |(language, _)| *language)
}

/// The steps of `path`, in order. A root or prefix component carries no step: an absolute path's
/// walk starts at `/` instead (see [`resolve`]).
fn steps_of(path: &Path) -> VecDeque<Step> {
    path.components()
        .filter_map(|component| match component {
            Component::ParentDir => Some(Step::Parent),
            Component::Normal(name) => Some(Step::Name(name.to_os_string())),
            Component::CurDir | Component::RootDir | Component::Prefix(_) => None,
        })
        .collect()
}

/// The steps of a link's `target`: its own steps, and a [`Step::MustBeFolder`] behind them when the
/// target is spelled with a trailing separator or a trailing `.`, both of which [`steps_of`] drops.
fn target_steps_of(target: &Path) -> VecDeque<Step> {
    let mut steps = steps_of(target);
    let spelling = target.as_os_str().as_bytes();
    if FOLDER_DEMANDING_ENDINGS
        .iter()
        .any(|ending| spelling.ends_with(ending))
    {
        steps.push_back(Step::MustBeFolder);
    }
    steps
}

/// Resolves `requested` to a location, returned as its path below `root`, with the kind of what the
/// last step found.
///
/// The walk keeps one lexical position: the root for a relative path, `/` for an absolute one, and
/// `/` again for a link's absolute target. A `..` moves it up lexically. While the position lies
/// outside the root, a name moves it down lexically and **nothing is touched**. Only a name whose
/// position already lies inside the root is read with `lstat`, and a link's target with
/// `read_link`. So a path that leaves the root and names it again resolves inside it, and one whose
/// walk ends outside is `Outside`, without a filesystem call on any path outside the root. An
/// absolute path spelled through a symlinked ancestor of the root never lexically meets the
/// canonical root, so it is `Outside`. No caller across the IPC boundary sends an absolute path.
///
/// A file met where the path needs a folder ends the walk. It is `Missing` when the step that needs
/// the folder belongs to a link's target, at any depth of links, and `NotAFolder` when it belongs to
/// the path the caller spelled.
///
/// A link entry is classified by resolving its own path here, so the containment check has one
/// implementation. The kind is the one the last step's `lstat` reported. A walk that ends on the
/// root, or on a `..`, reached a folder.
///
/// A link's target is resolved from the link's parent position, and the link stays "being resolved"
/// until its target is finished. A link met again while it is being resolved is a `Cycle`, and so is
/// a link whose finished target lies inside the root and holds the link's own position. A link that
/// finished earlier may be followed again. A target that lies outside the root is left to the
/// lexical walk, so a link to an ancestor of the root ends `Outside`. One hop count runs across the
/// whole request, and past `MAX_LINK_HOPS` the answer is `TooManyLinks`, so a hostile tree still
/// produces a state and never hangs.
fn resolve(
    filesystem: &impl Filesystem,
    root: &Path,
    requested: &Path,
) -> Result<Resolved, Blocked> {
    let mut position = if requested.is_absolute() {
        PathBuf::from("/")
    } else {
        root.to_path_buf()
    };
    let mut pending = steps_of(requested);
    let mut links_followed = 0;
    let mut kind = EntryKind::Folder;
    let mut volume_facts = VolumeFacts::default();
    let mut case_folded_return_is_one_level = false;
    while let Some(step) = pending.pop_front() {
        match step {
            Step::Parent => {
                if position == root {
                    volume_facts = volume_facts_for(filesystem, root);
                    case_folded_return_is_one_level = true;
                } else if !position.starts_with(root) {
                    case_folded_return_is_one_level = false;
                }
                position.pop();
                kind = EntryKind::Folder;
            }
            Step::MustBeFolder => {}
            Step::EndOfLink { parent, .. } => {
                if position.starts_with(root) && holds(filesystem, root, &position, &parent)? {
                    return Err(Blocked::cycle());
                }
            }
            Step::Name(name) => {
                if !position.starts_with(root) {
                    if case_folded_return_is_one_level
                        && is_admitted_case_folded_return(root, &position, &name, &volume_facts)
                    {
                        position = root.to_path_buf();
                    } else {
                        position = position.join(&name);
                    }
                    case_folded_return_is_one_level = false;
                    continue;
                }
                let candidate = position.join(&name);
                let metadata = filesystem.symlink_metadata(&candidate).map_err(|error| {
                    let blocked = Blocked::from(&error);
                    // A queued end-of-link marker means this name is a step of a link's target.
                    if error.kind() == io::ErrorKind::NotFound
                        && !a_link_is_being_resolved(&pending)
                    {
                        blocked.nothing_there()
                    } else {
                        blocked
                    }
                })?;
                if metadata.is_symlink() {
                    if pending.iter().any(
                        |queued| matches!(queued, Step::EndOfLink { link, .. } if *link == candidate),
                    ) {
                        return Err(Blocked::cycle());
                    }
                    links_followed += 1;
                    if links_followed > MAX_LINK_HOPS {
                        return Err(Blocked::too_many_links());
                    }
                    let target = filesystem
                        .read_link(&candidate)
                        .map_err(|error| Blocked::from(&error))?;
                    let parent = position.clone();
                    if target.is_absolute() {
                        position = PathBuf::from("/");
                    }
                    pending.push_front(Step::EndOfLink {
                        link: candidate,
                        parent,
                    });
                    for step in target_steps_of(&target).into_iter().rev() {
                        pending.push_front(step);
                    }
                } else if !metadata.is_dir() && goes_on(&pending) {
                    return Err(if next_step_is_a_links_target(&pending) {
                        Blocked::through_a_file()
                    } else {
                        Blocked::from(&io::Error::from(io::ErrorKind::NotADirectory))
                            .nothing_there()
                    });
                } else {
                    kind = if metadata.is_dir() {
                        EntryKind::Folder
                    } else {
                        EntryKind::File
                    };
                    position = candidate;
                }
            }
        }
    }
    position
        .strip_prefix(root)
        .map(|below_root| Resolved {
            below_root: below_root.to_path_buf(),
            kind,
        })
        .map_err(|_| Blocked::outside())
}

fn volume_facts_for(filesystem: &impl Filesystem, root: &Path) -> VolumeFacts {
    VolumeFacts {
        root_is_volume_root: filesystem.mount_point(root).map(|mount| mount == root),
        ignores_letter_case: filesystem
            .case_fact()
            .unwrap_or_else(|| ignores_letter_case(filesystem, root)),
    }
}

fn ignores_letter_case(filesystem: &impl Filesystem, root: &Path) -> Option<bool> {
    for entry in filesystem.read_dir(root).ok()? {
        let name = entry.file_name();
        let Some(name) = name.to_str() else {
            continue;
        };
        let Some(alternate) = alternate_case(name) else {
            continue;
        };
        let metadata = filesystem.symlink_metadata(&entry.path()).ok()?;
        if metadata.is_symlink() || !metadata.is_dir() {
            continue;
        }
        let alternate_metadata = match filesystem.symlink_metadata(&root.join(alternate)) {
            Ok(metadata) => metadata,
            Err(error) if error.kind() == io::ErrorKind::NotFound => return Some(false),
            Err(_) => return None,
        };
        return Some(
            alternate_metadata.is_dir()
                && (metadata.dev(), metadata.ino())
                    == (alternate_metadata.dev(), alternate_metadata.ino()),
        );
    }
    None
}

fn alternate_case(name: &str) -> Option<String> {
    let alternate = name
        .chars()
        .map(|character| {
            if character.is_lowercase() {
                character.to_uppercase().to_string()
            } else if character.is_uppercase() {
                character.to_lowercase().to_string()
            } else {
                character.to_string()
            }
        })
        .collect::<String>();
    (alternate != name).then_some(alternate)
}

fn is_admitted_case_folded_return(
    root: &Path,
    position: &Path,
    name: &std::ffi::OsStr,
    facts: &VolumeFacts,
) -> bool {
    facts.root_is_volume_root == Some(false)
        && facts.ignores_letter_case == Some(true)
        && root.parent() == Some(position)
        && root
            .file_name()
            .zip(name.to_str())
            .is_some_and(|(root_name, name)| {
                root_name
                    .to_str()
                    .is_some_and(|root_name| is_case_only_spelling(root_name, name))
            })
}

// Whole-string lowercase equality admits İ versus i + combining dot, and it
// admits two capitals that only share a lowercase, such as Kelvin sign versus
// K (CP-213; change_design.md §4). Case-only means each original scalar
// corresponds to exactly one candidate scalar, and that scalar is a
// single-scalar case mapping of the other — not a third character both lower to.
fn is_case_only_spelling(root_name: &str, candidate: &str) -> bool {
    if root_name == candidate {
        return false;
    }
    let mut root_scalars = root_name.chars();
    let mut candidate_scalars = candidate.chars();
    loop {
        match (root_scalars.next(), candidate_scalars.next()) {
            (None, None) => return true,
            (Some(root_scalar), Some(candidate_scalar)) => {
                if !scalars_match_as_one_case(root_scalar, candidate_scalar) {
                    return false;
                }
            }
            _ => return false,
        }
    }
}

fn scalars_match_as_one_case(left: char, right: char) -> bool {
    if left == right {
        return true;
    }
    // Shared lowercase is the old proof. Final sigma's uppercase is capital
    // sigma while its lowercase is not small sigma, so a pair whose lowercases
    // differ stays refused (CP-215).
    match (lowercase_one_scalar(left), lowercase_one_scalar(right)) {
        (Some(left_lower), Some(right_lower)) if left_lower == right_lower => {
            one_scalar_maps_to(left.to_lowercase(), right)
                || one_scalar_maps_to(right.to_lowercase(), left)
                || one_scalar_maps_to(left.to_uppercase(), right)
                || one_scalar_maps_to(right.to_uppercase(), left)
        }
        _ => false,
    }
}

fn one_scalar_maps_to(mut mapped: impl Iterator<Item = char>, target: char) -> bool {
    mapped.next() == Some(target) && mapped.next().is_none()
}

fn lowercase_one_scalar(scalar: char) -> Option<char> {
    let mut lowered = scalar.to_lowercase();
    let first = lowered.next()?;
    lowered.next().is_none().then_some(first)
}

/// Whether `target`, a location inside `root`, is the folder `parent` or one that holds it, where
/// `parent` is the position inside `root` a link was met from.
///
/// Folders are compared as folders, by device and inode, and not only by how their paths are spelled:
/// on a volume that ignores letter case, `../A` names the folder `a`, and a link reaching it that way
/// still reaches the folder that holds it. Every path read here lies inside `root`, and none holds a
/// link, because a position only ever moves onto a location that `lstat` found was not one.
fn holds(
    filesystem: &impl Filesystem,
    root: &Path,
    target: &Path,
    parent: &Path,
) -> Result<bool, Blocked> {
    if parent.starts_with(target) {
        return Ok(true);
    }
    let target = filesystem
        .symlink_metadata(target)
        .map_err(|error| Blocked::from(&error))?;
    if !target.is_dir() {
        return Ok(false);
    }
    for folder in parent
        .ancestors()
        .take_while(|ancestor| ancestor.starts_with(root))
    {
        let folder = filesystem
            .symlink_metadata(folder)
            .map_err(|error| Blocked::from(&error))?;
        if (folder.dev(), folder.ino()) == (target.dev(), target.ino()) {
            return Ok(true);
        }
    }
    Ok(false)
}

/// Whether the walk still has a name or a `..` to take. A queued end-of-link marker takes no step.
fn goes_on(pending: &VecDeque<Step>) -> bool {
    pending
        .iter()
        .any(|queued| !matches!(queued, Step::EndOfLink { .. }))
}

/// Whether a link's target is being resolved: its end-of-link marker is still queued. The step
/// just taken then belongs to that target, and the caller's own steps are queued behind the marker.
fn a_link_is_being_resolved(pending: &VecDeque<Step>) -> bool {
    pending
        .iter()
        .any(|queued| matches!(queued, Step::EndOfLink { .. }))
}

/// Whether the next step to take belongs to some link's target. A link's target steps are queued
/// ahead of that link's end-of-link marker, so that holds exactly when a marker is still queued
/// behind the next step. The caller's own steps are queued last, with no marker behind them.
fn next_step_is_a_links_target(pending: &VecDeque<Step>) -> bool {
    pending
        .iter()
        .skip_while(|queued| matches!(queued, Step::EndOfLink { .. }))
        .skip(1)
        .any(|queued| matches!(queued, Step::EndOfLink { .. }))
}

/// An entry beside the raw name the operating system reported for it. The reported name is lossy
/// for a name that is not UTF-8, so the raw bytes are what make the order total.
///
/// This is the entry observation: the entry's native path is its folder's location joined with
/// `raw_name`, so no path is stored twice.
#[derive(Debug, Clone, PartialEq, Eq)]
pub(crate) struct Listed {
    pub(crate) raw_name: OsString,
    pub(crate) entry: Entry,
}

/// One folder as observed: the resolved location it was read at, and its entries in the FDR's
/// order with the raw names behind them.
#[derive(Debug, Clone, PartialEq, Eq)]
pub(crate) struct ListingObservation {
    pub(crate) location: PathBuf,
    pub(crate) items: Vec<Listed>,
}

impl ListingObservation {
    /// The public projection: each entry as [`list`] answers it.
    pub(crate) fn into_entries(self) -> Vec<Entry> {
        self.items.into_iter().map(|item| item.entry).collect()
    }
}

/// Puts `items` in the order the FDR fixes for a folder's entries: every entry that lists as a folder
/// first, then everything else. Within a group, names compare on their lowercase forms by code
/// point, with digits as characters. A tie falls back to the reported name's bytes, and then to the
/// raw name's bytes. No Unicode normalization is applied. The order comes from this key alone and
/// never from the order the disk listed the entries in. It is pure: it reads nothing, so a listing
/// merged from retained and fresh observations is ordered by the key a fresh listing uses.
pub(crate) fn order(items: &mut [Listed]) {
    items.sort_by_cached_key(|item| {
        (
            item.entry.kind != EntryKind::Folder,
            item.entry.name.to_lowercase(),
            item.entry.name.clone(),
            item.raw_name.as_bytes().to_vec(),
        )
    });
}

/// The direct entries of the folder at `below_root`, each with its own state, in the FDR's order.
///
/// An error on the directory stream itself carries no name to attach, so it fails the whole answer.
/// An error on one named entry's kind fails that entry, and its siblings stand.
fn list_folder(
    filesystem: &impl Filesystem,
    root: &Path,
    below_root: &Path,
) -> Result<Vec<Listed>, Blocked> {
    let mut items = Vec::new();
    for item in filesystem
        .read_dir(&root.join(below_root))
        .map_err(|error| Blocked::from(&error))?
    {
        let name = item.file_name();
        let path = below_root.join(&name);
        let (kind, state) = match item.file_type() {
            Err(error) => failed_entry(&Blocked::from(&error)),
            Ok(file_type) if file_type.is_dir() => (EntryKind::Folder, ItemState::Pending),
            Ok(file_type) if file_type.is_symlink() => match resolve(filesystem, root, &path) {
                Ok(reached) => item_of(reached.kind),
                Err(blocked) => failed_entry(&blocked),
            },
            Ok(_) => (EntryKind::File, ItemState::Observed(())),
        };
        items.push(Listed {
            entry: Entry {
                name: name.to_string_lossy().into_owned(),
                path: path.to_string_lossy().into_owned(),
                kind,
                state,
                language: language_of_entry(kind, &name),
            },
            raw_name: name,
        });
    }
    order(&mut items);
    Ok(items)
}

/// The language an entry carries, taken from the raw name the system reported (never the lossy
/// text, which is not the name a read of the same entry is given): none for a folder.
fn language_of_entry(kind: EntryKind, raw_name: &OsStr) -> Option<Language> {
    match kind {
        EntryKind::Folder => None,
        EntryKind::File => Some(language_of(raw_name)),
    }
}

/// The kind and state an entry has when it is a folder or a file that was read.
fn item_of(kind: EntryKind) -> (EntryKind, ItemState<()>) {
    match kind {
        EntryKind::Folder => (EntryKind::Folder, ItemState::Pending),
        EntryKind::File => (EntryKind::File, ItemState::Observed(())),
    }
}

/// The kind and state of an entry that failed, and its one log line. A failed entry is a file.
fn failed_entry(blocked: &Blocked) -> (EntryKind, ItemState<()>) {
    log::warn!("fs-reader: entry failed: {}", blocked.text);
    (EntryKind::File, ItemState::Failed(blocked.condition))
}

#[cfg(test)]
#[path = "../tests/unit/fs_reader.rs"]
mod tests;
