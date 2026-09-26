//! fs-reader: turns a requested path into a location known to lie inside a canonical root, and
//! lists that location's direct entries, each with its own state.

use std::collections::VecDeque;
use std::ffi::OsString;
use std::fs;
use std::io;
use std::os::unix::ffi::{OsStrExt, OsStringExt};
use std::os::unix::fs::MetadataExt;
use std::path::{Component, Path, PathBuf};

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
#[derive(Debug, Clone, PartialEq, Eq)]
pub enum ItemState<T> {
    Pending,
    Observed(T),
    Failed(Condition),
}

/// One direct entry of a listed folder.
///
/// A folder is `Pending`, and a file is `Observed`. An entry that failed is always a `File`.
#[derive(Debug, Clone, PartialEq, Eq)]
pub struct Entry {
    pub name: String,
    pub path: String,
    pub kind: EntryKind,
    pub state: ItemState<()>,
}

/// The most symbolic links one requested path may pass through before the answer is `TooManyLinks`.
const MAX_LINK_HOPS: usize = 32;

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
}

impl Blocked {
    fn outside() -> Self {
        Self {
            condition: Condition::Outside,
            text: OUTSIDE_TEXT.to_string(),
        }
    }

    fn cycle() -> Self {
        Self {
            condition: Condition::Cycle,
            text: CYCLE_TEXT.to_string(),
        }
    }

    /// A link's target ran into a file where it needs a folder. The link leads to something that is
    /// not there, and the log line keeps what the operating system says of a file met as a folder.
    fn through_a_file() -> Self {
        Self {
            condition: Condition::Missing,
            text: io::Error::from(io::ErrorKind::NotADirectory).to_string(),
        }
    }

    fn too_many_links() -> Self {
        Self {
            condition: Condition::TooManyLinks,
            text: TOO_MANY_LINKS_TEXT.to_string(),
        }
    }
}

impl From<&io::Error> for Blocked {
    fn from(error: &io::Error) -> Self {
        Self {
            condition: condition_for(error.kind()),
            text: error.to_string(),
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
    match resolve(filesystem, root, Path::new(requested))
        .and_then(|at| list_folder(filesystem, root, &at.below_root))
    {
        Ok(entries) => ItemState::Observed(entries),
        Err(blocked) => {
            log::warn!("fs-reader: list failed: {}", blocked.text);
            ItemState::Failed(blocked.condition)
        }
    }
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
    while let Some(step) = pending.pop_front() {
        match step {
            Step::Parent => {
                if position == root {
                    volume_facts = volume_facts_for(filesystem, root);
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
                    if is_admitted_case_folded_return(root, &position, &name, &volume_facts) {
                        position = root.to_path_buf();
                    } else {
                        position = position.join(&name);
                    }
                    continue;
                }
                let candidate = position.join(&name);
                let metadata = filesystem
                    .symlink_metadata(&candidate)
                    .map_err(|error| Blocked::from(&error))?;
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
            .unwrap_or_else(|| ignores_letter_case(root)),
    }
}

fn ignores_letter_case(root: &Path) -> Option<bool> {
    for entry in fs::read_dir(root).ok()? {
        let entry = entry.ok()?;
        let name = entry.file_name();
        let name = name.to_str()?;
        let alternate = alternate_case(name)?;
        let metadata = fs::symlink_metadata(entry.path()).ok()?;
        if metadata.is_symlink() || !metadata.is_dir() {
            continue;
        }
        let alternate_metadata = match fs::symlink_metadata(root.join(alternate)) {
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
                root_name != name
                    && root_name
                        .to_str()
                        .is_some_and(|root_name| root_name.to_lowercase() == name.to_lowercase())
            })
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
struct Listed {
    raw_name: OsString,
    entry: Entry,
}

/// Puts `items` in the order the FDR fixes for a folder's entries: every entry that lists as a folder
/// first, then everything else. Within a group, names compare on their lowercase forms by code
/// point, with digits as characters. A tie falls back to the reported name's bytes, and then to the
/// raw name's bytes. No Unicode normalization is applied. The order comes from this key alone and
/// never from the order the disk listed the entries in.
fn order(items: &mut [Listed]) {
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
) -> Result<Vec<Entry>, Blocked> {
    let mut items = Vec::new();
    for item in fs::read_dir(root.join(below_root)).map_err(|error| Blocked::from(&error))? {
        let item = item.map_err(|error| Blocked::from(&error))?;
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
            },
            raw_name: name,
        });
    }
    order(&mut items);
    Ok(items.into_iter().map(|item| item.entry).collect())
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
mod tests {
    use super::*;
    use crate::test_support::TempDir;
    use std::cell::RefCell;
    use std::os::unix::ffi::OsStringExt;
    use std::os::unix::fs::PermissionsExt as _;
    use std::time::SystemTime;

    struct RecordingFilesystem {
        root: PathBuf,
        mount_point: Option<PathBuf>,
        case_fact: Option<bool>,
        outside_queries: RefCell<Vec<PathBuf>>,
    }

    impl RecordingFilesystem {
        fn new(root: &Path, root_is_volume_root: Option<bool>, case_fact: Option<bool>) -> Self {
            let mount_point = root_is_volume_root.map(|is_root| {
                if is_root {
                    root.to_path_buf()
                } else {
                    root.parent().expect("root parent").to_path_buf()
                }
            });
            Self {
                root: root.to_path_buf(),
                mount_point,
                case_fact,
                outside_queries: RefCell::new(Vec::new()),
            }
        }

        fn outside_queries(&self) -> Vec<PathBuf> {
            self.outside_queries.borrow().clone()
        }

        fn guard(&self, path: &Path) -> io::Result<()> {
            if path.starts_with(&self.root) {
                return Ok(());
            }
            self.outside_queries.borrow_mut().push(path.to_path_buf());
            Err(io::Error::from(io::ErrorKind::PermissionDenied))
        }
    }

    impl Filesystem for RecordingFilesystem {
        fn symlink_metadata(&self, path: &Path) -> io::Result<fs::Metadata> {
            self.guard(path)?;
            fs::symlink_metadata(path)
        }
        fn read_link(&self, path: &Path) -> io::Result<PathBuf> {
            self.guard(path)?;
            fs::read_link(path)
        }
        fn mount_point(&self, _: &Path) -> Option<PathBuf> {
            self.mount_point.clone()
        }
        fn case_fact(&self) -> Option<Option<bool>> {
            Some(self.case_fact)
        }
    }

    /// The entries of an observed answer, sorted by name, or a panic naming the answer.
    fn entries_of(outcome: ItemState<Vec<Entry>>) -> Vec<Entry> {
        match outcome {
            ItemState::Observed(mut entries) => {
                entries.sort_by(|left, right| left.name.cmp(&right.name));
                entries
            }
            other => panic!("expected Observed, got {other:?}"),
        }
    }

    /// The listed entries as `(name, path, kind)` triples, sorted by name.
    fn listed(outcome: ItemState<Vec<Entry>>) -> Vec<(String, String, EntryKind)> {
        entries_of(outcome)
            .into_iter()
            .map(|entry| (entry.name, entry.path, entry.kind))
            .collect()
    }

    fn names(outcome: ItemState<Vec<Entry>>) -> Vec<String> {
        listed(outcome).into_iter().map(|triple| triple.0).collect()
    }

    fn entry(name: &str, path: &str, kind: EntryKind, state: ItemState<()>) -> Entry {
        Entry {
            name: name.to_string(),
            path: path.to_string(),
            kind,
            state,
        }
    }

    fn failed(condition: Condition) -> ItemState<Vec<Entry>> {
        ItemState::Failed(condition)
    }

    #[derive(Debug, PartialEq, Eq)]
    struct SnapshotEntry {
        path: PathBuf,
        kind: &'static str,
        link_target: Option<PathBuf>,
        bytes: Option<Vec<u8>>,
        mode: u32,
        length: u64,
        modified: Option<SystemTime>,
    }

    fn snapshot(root: &Path) -> Vec<SnapshotEntry> {
        fn visit(root: &Path, path: &Path, entries: &mut Vec<SnapshotEntry>) {
            let mut children = fs::read_dir(path)
                .expect("snapshot directory")
                .collect::<Result<Vec<_>, _>>()
                .expect("snapshot entries");
            children.sort_by_key(fs::DirEntry::file_name);
            for child in children {
                let child_path = child.path();
                let metadata = fs::symlink_metadata(&child_path).expect("snapshot metadata");
                let file_type = metadata.file_type();
                let kind = if file_type.is_symlink() {
                    "symlink"
                } else if file_type.is_dir() {
                    "directory"
                } else {
                    "file"
                };
                entries.push(SnapshotEntry {
                    path: child_path
                        .strip_prefix(root)
                        .expect("snapshot path below root")
                        .to_path_buf(),
                    kind,
                    link_target: file_type
                        .is_symlink()
                        .then(|| fs::read_link(&child_path).expect("snapshot link target")),
                    bytes: file_type
                        .is_file()
                        .then(|| fs::read(&child_path).expect("snapshot file bytes")),
                    mode: metadata.permissions().mode(),
                    length: metadata.len(),
                    modified: metadata.modified().ok(),
                });
                if file_type.is_dir() {
                    visit(root, &child_path, entries);
                }
            }
        }

        let mut entries = Vec::new();
        visit(root, root, &mut entries);
        entries
    }

    #[test]
    fn test_relative_path_inside_root_resolves_inside() {
        let temp = TempDir::new();
        temp.write_file("top.txt", "");
        temp.write_file("src/inner.txt", "");
        temp.write_file("src/deep/leaf.txt", "");

        assert_eq!(names(list(temp.path(), "")), ["src", "top.txt"]);
        assert_eq!(names(list(temp.path(), "src")), ["deep", "inner.txt"]);
        assert_eq!(names(list(temp.path(), "src/deep")), ["leaf.txt"]);
    }

    #[test]
    fn test_dotdot_leaving_root_is_outside() {
        let temp = TempDir::new();
        temp.make_folder("src");

        assert_eq!(list(temp.path(), ".."), failed(Condition::Outside));
        assert_eq!(list(temp.path(), "../x"), failed(Condition::Outside));
        assert_eq!(list(temp.path(), "src/../../x"), failed(Condition::Outside));
    }

    #[test]
    fn test_volume_root_fact_is_conservative() {
        let temp = TempDir::new();
        let root = temp.make_folder("nozoki");

        assert_eq!(
            volume_facts_for(&RecordingFilesystem::new(&root, Some(true), None), &root)
                .root_is_volume_root,
            Some(true),
        );
        assert_eq!(
            volume_facts_for(&RecordingFilesystem::new(&root, Some(false), None), &root)
                .root_is_volume_root,
            Some(false),
        );
        assert_eq!(
            volume_facts_for(&RecordingFilesystem::new(&root, None, None), &root)
                .root_is_volume_root,
            None,
        );
    }

    #[test]
    fn test_letter_case_fact_uses_an_inside_real_directory_witness() {
        let temp = TempDir::new();
        let root = temp.make_folder("nozoki");
        temp.make_folder("nozoki/123");
        let witness = temp.make_folder("nozoki/witness");
        let alternate = root.join("WITNESS");
        let expected = match fs::symlink_metadata(&alternate) {
            Ok(metadata) => {
                let witness = fs::symlink_metadata(witness).expect("witness metadata");
                Some(
                    metadata.is_dir()
                        && (metadata.dev(), metadata.ino()) == (witness.dev(), witness.ino()),
                )
            }
            Err(error) if error.kind() == io::ErrorKind::NotFound => Some(false),
            Err(_) => None,
        };

        assert_eq!(ignores_letter_case(&root), expected);
        assert_eq!(
            ignores_letter_case(&temp.make_folder("nozoki-empty/123")),
            None
        );
    }

    #[test]
    fn test_other_case_return_to_root_is_cycle_without_outside_io() {
        let temp = TempDir::new();
        let root = temp.make_folder("nozoki");
        temp.make_link("nozoki/self", "../NOZOKI");
        let filesystem = RecordingFilesystem::new(&root, Some(false), Some(true));

        assert_eq!(
            list_with_filesystem(&filesystem, &root, "self"),
            failed(Condition::Cycle),
        );
        assert!(filesystem.outside_queries().is_empty());
    }

    #[test]
    fn test_other_case_return_then_child_lists_inside_without_outside_io() {
        let temp = TempDir::new();
        let root = temp.make_folder("nozoki");
        temp.write_file("nozoki/docs/guide.md", "guide");
        temp.make_folder("nozoki/docs/images");
        temp.make_link("nozoki/up", "../NOZOKI/docs");
        let filesystem = RecordingFilesystem::new(&root, Some(false), Some(true));

        assert_eq!(
            list_with_filesystem(&filesystem, &root, "up"),
            list_with_filesystem(&filesystem, &root, "docs"),
        );
        assert!(filesystem.outside_queries().is_empty());
    }

    #[test]
    fn test_other_case_reentry_requires_both_confirmed_facts() {
        let temp = TempDir::new();
        let root = temp.make_folder("nozoki");
        temp.make_link("nozoki/self", "../NOZOKI");

        for root_is_volume_root in [Some(true), None] {
            for ignores_letter_case in [Some(true), Some(false), None] {
                let filesystem =
                    RecordingFilesystem::new(&root, root_is_volume_root, ignores_letter_case);
                assert_eq!(
                    list_with_filesystem(&filesystem, &root, "self"),
                    failed(Condition::Outside),
                );
                assert!(filesystem.outside_queries().is_empty());
            }
        }

        for ignores_letter_case in [Some(false), None] {
            let filesystem = RecordingFilesystem::new(&root, Some(false), ignores_letter_case);
            assert_eq!(
                list_with_filesystem(&filesystem, &root, "self"),
                failed(Condition::Outside),
            );
            assert!(filesystem.outside_queries().is_empty());
        }
    }

    #[test]
    fn test_multi_level_other_case_return_stays_outside_without_outside_io() {
        let temp = TempDir::new();
        let root = temp.make_folder("projects/nozoki");
        temp.make_folder("projects/nozoki/docs");
        temp.make_link("projects/nozoki/far", "../../projects/NOZOKI/docs");
        let filesystem = RecordingFilesystem::new(&root, Some(false), Some(true));

        assert_eq!(
            list_with_filesystem(&filesystem, &root, "far"),
            failed(Condition::Outside),
        );
        assert!(filesystem.outside_queries().is_empty());
    }

    #[test]
    fn test_normalization_only_return_stays_outside_without_outside_io() {
        let temp = TempDir::new();
        let root = temp.make_folder("café");
        temp.make_link("café/self", "../CAFE\u{301}");
        let filesystem = RecordingFilesystem::new(&root, Some(false), Some(true));

        assert_eq!(
            list_with_filesystem(&filesystem, &root, "self"),
            failed(Condition::Outside),
        );
        assert!(filesystem.outside_queries().is_empty());
    }

    #[test]
    fn test_volume_root_return_stays_outside_without_outside_io() {
        let temp = TempDir::new();
        let root = temp.make_folder("nozoki");
        temp.make_link("nozoki/back", "../NOZOKI");
        let filesystem = RecordingFilesystem::new(&root, Some(true), Some(true));

        assert_eq!(
            list_with_filesystem(&filesystem, &root, "back"),
            failed(Condition::Outside),
        );
        assert!(filesystem.outside_queries().is_empty());
    }

    #[test]
    fn test_containment_spellings_leave_the_filesystem_unchanged() {
        let temp = TempDir::new();
        let root = temp.make_folder("projects/nozoki");
        temp.write_file("projects/nozoki/docs/guide.md", "guide");
        temp.make_link("projects/nozoki/self", "../NOZOKI");
        temp.make_link("projects/nozoki/up", "../NOZOKI/docs");
        temp.make_link("projects/nozoki/far", "../../projects/NOZOKI/docs");
        let before = snapshot(temp.path());

        let admitted = RecordingFilesystem::new(&root, Some(false), Some(true));
        let volume_root = RecordingFilesystem::new(&root, Some(true), Some(true));
        let unknown_case = RecordingFilesystem::new(&root, Some(false), None);
        for (filesystem, requested) in [
            (&admitted, "self"),
            (&admitted, "up"),
            (&admitted, "far"),
            (&volume_root, "self"),
            (&unknown_case, "self"),
        ] {
            let _ = list_with_filesystem(filesystem, &root, requested);
        }

        assert_eq!(snapshot(temp.path()), before);
    }

    #[test]
    fn test_dotdot_staying_inside_root_is_allowed() {
        let temp = TempDir::new();
        temp.write_file("src/inner.txt", "");

        assert_eq!(
            listed(list(temp.path(), "src/../src")),
            [(
                "inner.txt".to_string(),
                "src/inner.txt".to_string(),
                EntryKind::File
            )]
        );
    }

    #[test]
    fn test_current_dir_and_repeated_separators_are_ignored() {
        let temp = TempDir::new();
        temp.write_file("src/inner.txt", "");

        assert_eq!(names(list(temp.path(), "./src//./"),), ["inner.txt"]);
    }

    #[test]
    fn test_absolute_path_outside_root_is_outside() {
        let temp = TempDir::new();

        assert_eq!(list(temp.path(), "/etc"), failed(Condition::Outside));
    }

    #[test]
    fn test_absolute_path_inside_canonical_root_is_allowed() {
        let temp = TempDir::new();
        temp.write_file("src/inner.txt", "");
        let absolute = temp.path().join("src");

        assert_eq!(
            names(list(temp.path(), absolute.to_str().expect("utf-8 path"))),
            ["inner.txt"]
        );
    }

    #[test]
    fn test_absolute_dotdot_leaving_root_is_outside() {
        let temp = TempDir::new();
        let leaving = format!("{}/../elsewhere", temp.path().display());

        assert_eq!(list(temp.path(), &leaving), failed(Condition::Outside));
    }

    #[test]
    fn test_absolute_path_through_symlinked_ancestor_is_outside() {
        let temp = TempDir::new();
        temp.write_file("real/src/inner.txt", "");
        temp.make_link("alias", temp.path().join("real"));
        let root = temp.path().join("real");
        let through_alias = format!("{}/alias/src", temp.path().display());

        assert_eq!(list(&root, &through_alias), failed(Condition::Outside));
    }

    #[test]
    fn test_symlink_to_outside_is_outside_without_touching_target() {
        let temp = TempDir::new();
        let root = temp.make_folder("root");
        temp.write_file("outside/locked/child", "");
        temp.set_mode("outside/locked", 0o000);
        temp.make_link("root/absolute", temp.path().join("outside/locked/child"));
        temp.make_link("root/relative", "../outside/locked/child");

        // A read of the target would fail on the mode and answer Unreadable, not Outside.
        assert_eq!(list(&root, "absolute"), failed(Condition::Outside));
        assert_eq!(list(&root, "relative"), failed(Condition::Outside));
    }

    #[test]
    fn test_relative_symlink_escaping_root_is_outside() {
        let temp = TempDir::new();
        let root = temp.make_folder("root");
        temp.make_folder("sibling");
        temp.make_link("root/up", "../sibling");

        assert_eq!(list(&root, "up"), failed(Condition::Outside));
    }

    #[test]
    fn test_symlink_to_inside_resolves_inside() {
        let temp = TempDir::new();
        temp.write_file("real/inner.txt", "");
        temp.make_link("relative", "real");
        temp.make_link("absolute", temp.path().join("real"));

        assert_eq!(names(list(temp.path(), "relative")), ["inner.txt"]);
        assert_eq!(names(list(temp.path(), "absolute")), ["inner.txt"]);
    }

    #[test]
    fn test_path_continuing_through_a_symlink_to_a_folder_resolves() {
        let temp = TempDir::new();
        temp.write_file("real/sub/inner.txt", "");
        temp.make_link("link", "real");

        assert_eq!(
            listed(list(temp.path(), "link/sub")),
            [(
                "inner.txt".to_string(),
                "real/sub/inner.txt".to_string(),
                EntryKind::File
            )]
        );
    }

    #[test]
    fn test_path_continuing_through_a_symlink_to_a_file_is_failed() {
        let temp = TempDir::new();
        temp.write_file("plain.txt", "");
        temp.make_link("link", "plain.txt");

        assert_eq!(
            list(temp.path(), "link/below"),
            failed(Condition::NotAFolder)
        );
    }

    #[test]
    fn test_symlink_chain_within_hop_limit_resolves() {
        let temp = TempDir::new();
        temp.write_file("real/inner.txt", "");
        temp.make_link("first", "second");
        temp.make_link("second", "third");
        temp.make_link("third", "real");

        assert_eq!(names(list(temp.path(), "first")), ["inner.txt"]);
    }

    #[test]
    fn test_symlink_cycle_is_failed_not_hung() {
        let temp = TempDir::new();
        temp.make_link("ping", "pong");
        temp.make_link("pong", "ping");

        assert_eq!(list(temp.path(), "ping"), failed(Condition::Cycle));
    }

    #[test]
    fn test_dangling_symlink_is_failed() {
        let temp = TempDir::new();
        temp.make_link("dangling", "nowhere");

        assert_eq!(list(temp.path(), "dangling"), failed(Condition::Missing));
    }

    #[test]
    fn test_listing_returns_every_direct_entry_with_kind() {
        let temp = TempDir::new();
        temp.write_file(".env", "");
        temp.make_folder(".git");
        temp.write_file("file.txt", "");
        temp.write_file("folder/below.txt", "");
        temp.make_link("link", "folder");

        assert_eq!(
            entries_of(list(temp.path(), "")),
            [
                entry(".env", ".env", EntryKind::File, ItemState::Observed(())),
                entry(".git", ".git", EntryKind::Folder, ItemState::Pending),
                entry(
                    "file.txt",
                    "file.txt",
                    EntryKind::File,
                    ItemState::Observed(())
                ),
                entry("folder", "folder", EntryKind::Folder, ItemState::Pending),
                entry("link", "link", EntryKind::Folder, ItemState::Pending),
            ]
        );
    }

    #[test]
    fn test_empty_folder_lists_as_empty_and_not_failed() {
        let temp = TempDir::new();
        temp.make_folder("empty");

        assert_eq!(list(temp.path(), "empty"), ItemState::Observed(Vec::new()));
    }

    #[test]
    fn test_root_entry_path_equals_name_and_nested_path_is_slash_joined() {
        let temp = TempDir::new();
        temp.write_file("src/inner.txt", "");

        assert_eq!(
            listed(list(temp.path(), "")),
            [("src".to_string(), "src".to_string(), EntryKind::Folder)]
        );
        assert_eq!(
            listed(list(temp.path(), "src")),
            [(
                "inner.txt".to_string(),
                "src/inner.txt".to_string(),
                EntryKind::File
            )]
        );
    }

    #[test]
    fn test_listing_a_file_is_failed() {
        let temp = TempDir::new();
        temp.write_file("plain.txt", "");

        assert_eq!(
            list(temp.path(), "plain.txt"),
            failed(Condition::NotAFolder)
        );
    }

    #[test]
    fn test_path_through_a_file_is_failed() {
        let temp = TempDir::new();
        temp.write_file("plain.txt", "");

        assert_eq!(
            list(temp.path(), "plain.txt/.."),
            failed(Condition::NotAFolder)
        );
        assert_eq!(
            list(temp.path(), "plain.txt/below"),
            failed(Condition::NotAFolder)
        );
    }

    #[test]
    fn test_listing_a_missing_path_is_failed() {
        let temp = TempDir::new();

        assert_eq!(list(temp.path(), "missing"), failed(Condition::Missing));
    }

    #[test]
    fn test_listing_an_unreadable_folder_is_failed() {
        let temp = TempDir::new();
        temp.make_folder("locked");
        temp.set_mode("locked", 0o000);

        assert_eq!(list(temp.path(), "locked"), failed(Condition::Unreadable));
    }

    #[test]
    fn test_io_error_kinds_map_to_their_conditions() {
        assert_eq!(condition_for(io::ErrorKind::NotFound), Condition::Missing);
        assert_eq!(
            condition_for(io::ErrorKind::NotADirectory),
            Condition::NotAFolder
        );
        assert_eq!(
            condition_for(io::ErrorKind::PermissionDenied),
            Condition::Unreadable
        );
        // A kind the table does not name is still an unreadable read (design § 3 A, "every other I/O kind").
        assert_eq!(
            condition_for(io::ErrorKind::Interrupted),
            Condition::Unreadable
        );
    }

    fn listed_entry(raw_name: &[u8], name: &str, kind: EntryKind) -> Listed {
        let state = match kind {
            EntryKind::Folder => ItemState::Pending,
            EntryKind::File => ItemState::Observed(()),
        };
        Listed {
            raw_name: OsString::from_vec(raw_name.to_vec()),
            entry: entry(name, name, kind, state),
        }
    }

    fn ordered_names(mut items: Vec<Listed>) -> Vec<String> {
        order(&mut items);
        items.into_iter().map(|item| item.entry.name).collect()
    }

    #[test]
    fn test_order_puts_folders_first_then_names_without_regard_to_case() {
        let items = [
            ("B", EntryKind::Folder),
            ("a", EntryKind::Folder),
            ("file10", EntryKind::File),
            ("file2", EntryKind::File),
            (".dot", EntryKind::File),
            ("Readme", EntryKind::File),
            ("readme", EntryKind::File),
        ]
        .map(|(name, kind)| listed_entry(name.as_bytes(), name, kind));

        assert_eq!(
            ordered_names(items.into()),
            ["a", "B", ".dot", "file10", "file2", "Readme", "readme"]
        );
    }

    #[test]
    fn test_order_breaks_a_lowercase_tie_by_byte_order() {
        let upper = || listed_entry(b"Readme", "Readme", EntryKind::File);
        let lower = || listed_entry(b"readme", "readme", EntryKind::File);

        assert_eq!(ordered_names(vec![lower(), upper()]), ["Readme", "readme"]);
        assert_eq!(ordered_names(vec![upper(), lower()]), ["Readme", "readme"]);
    }

    #[test]
    fn test_order_is_total_for_names_with_the_same_lossy_form() {
        // Both raw names are invalid UTF-8 and both report as "\u{FFFD}" once made lossy.
        let low = || listed_entry(&[0xFF], "\u{FFFD}", EntryKind::File);
        let high = || listed_entry(&[0xFE], "\u{FFFD}", EntryKind::File);
        let raw_order = |items: Vec<Listed>| {
            let mut items = items;
            order(&mut items);
            items
                .into_iter()
                .map(|item| item.raw_name.into_vec())
                .collect::<Vec<_>>()
        };

        assert_eq!(raw_order(vec![low(), high()]), [vec![0xFE], vec![0xFF]]);
        assert_eq!(raw_order(vec![high(), low()]), [vec![0xFE], vec![0xFF]]);
    }

    #[test]
    fn test_order_compares_the_reported_name_before_the_raw_bytes() {
        // Both names lowercase to "\u{FFFD}a". Raw byte order puts `[0x80, b'a']` first, and the
        // reported names put "\u{FFFD}A" first, so only the reported-name key decides this pair.
        let lossy = || listed_entry(&[0x80, b'a'], "\u{FFFD}a", EntryKind::File);
        let valid = || listed_entry("\u{FFFD}A".as_bytes(), "\u{FFFD}A", EntryKind::File);

        assert_eq!(
            ordered_names(vec![lossy(), valid()]),
            ["\u{FFFD}A", "\u{FFFD}a"]
        );
        assert_eq!(
            ordered_names(vec![valid(), lossy()]),
            ["\u{FFFD}A", "\u{FFFD}a"]
        );
    }

    #[test]
    fn test_a_failed_entry_and_a_socket_sort_with_the_files() {
        let failed = Listed {
            raw_name: OsString::from("a-failed"),
            entry: entry(
                "a-failed",
                "a-failed",
                EntryKind::File,
                ItemState::Failed(Condition::Missing),
            ),
        };
        let items = vec![
            listed_entry(b"z-folder", "z-folder", EntryKind::Folder),
            listed_entry(b"m-socket", "m-socket", EntryKind::File),
            failed,
        ];

        assert_eq!(ordered_names(items), ["z-folder", "a-failed", "m-socket"]);
    }
}
