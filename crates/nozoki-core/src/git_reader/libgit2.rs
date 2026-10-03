//! The libgit2 adapter of the Git port. Every Git read and the binding itself live in this file.

use std::collections::VecDeque;
use std::ffi::{OsStr, OsString};
use std::io::{self, Read};
use std::os::unix::ffi::OsStrExt;
use std::os::unix::fs::OpenOptionsExt;
use std::path::{Component, Path, PathBuf};

use git2::{
    ErrorCode, Repository, RepositoryOpenFlags, RepositoryState as GitRepositoryState, Status,
    StatusOptions,
};
use rustix::fs::OFlags;

use super::{
    BranchElement, GitPort, GitReadCondition, HeadState, ProbeCondition, RepositoryState,
    RootFinding, StatusCategory, StatusEntry, StatusLists,
};

const GIT_ENTRY: &str = ".git";
const GIT_HEAD: &str = "HEAD";
const HEAD_REFERENCE: &str = "HEAD";
const BRANCH_REFERENCE_PREFIX: &str = "refs/heads/";
const COMMON_DIRECTORY_FILE: &str = "commondir";
/// The most links one spelled location may pass through, as `fs-reader` bounds a requested path.
const MAX_LINK_HOPS: usize = 32;
/// The most bytes of a `.git` or `commondir` file the bound holds: a path longer than this names
/// nothing, and a larger file is refused as unreadable instead of being held whole.
const SPELLING_FILE_LIMIT: u64 = 1 << 20;
/// What a `.git` file's first seven bytes must be for it to name a Git directory.
const GIT_FILE_PREFIX: &[u8] = b"gitdir:";
/// How many bytes are read at a time while looking for the first byte after the prefix that is not
/// whitespace: the file is read only as far as that byte, so no size is ever held.
const GIT_FILE_CHUNK: usize = 512;

/// The port's one adapter, linked against the libgit2 compiled into the crate.
///
/// The type is named here so a caller can wire it, and a caller never constructs it in shipped
/// source: only the composition root does.
///
/// # Examples
///
/// ```
/// use nozoki_core::{GitPort, Libgit2};
///
/// fn assert_port<T: GitPort>() {}
/// assert_port::<Libgit2>();
/// ```
pub struct Libgit2;

impl GitPort for Libgit2 {
    fn probe(&self, folder: &Path) -> RootFinding {
        match folder.metadata() {
            Ok(metadata) if metadata.is_dir() => {}
            _ => return RootFinding::Failed(ProbeCondition::FolderUnavailable),
        }
        match folder.join(GIT_ENTRY).symlink_metadata() {
            Err(error) if error.kind() == io::ErrorKind::NotFound => RootFinding::Plain,
            Err(_) => RootFinding::Failed(ProbeCondition::FolderUnavailable),
            Ok(metadata) if metadata.is_dir() => open_repository(folder),
            Ok(metadata) if metadata.is_file() => probe_git_file(&folder.join(GIT_ENTRY)),
            Ok(_) => RootFinding::Failed(ProbeCondition::GitEntryNotDirectory),
        }
    }

    fn state(&self, root: &Path) -> Result<HeadState, GitReadCondition> {
        head_state(&open_verified(root)?)
    }

    fn status(&self, root: &Path) -> Result<StatusLists, GitReadCondition> {
        status_lists(&open_verified(root)?)
    }
}

/// Locates the Git directory and the common directory by spelling, refuses either one outside the
/// folder, opens libgit2 on `root` only then, and requires what libgit2 opened to be what was
/// verified. Both calls share this one helper, so they refuse alike.
fn open_verified(root: &Path) -> Result<Repository, GitReadCondition> {
    let locations = verified_locations(root)?;
    let repository = Repository::open_ext(root, RepositoryOpenFlags::NO_SEARCH, no_ceilings())
        .map_err(|error| match error.code() {
            ErrorCode::NotFound => GitReadCondition::NotARepository,
            _ => GitReadCondition::RepositoryReadFailed,
        })?;
    let opened_what_was_verified = repository.path() == locations.git_directory
        && repository.commondir() == locations.common_directory
        && repository.workdir() == Some(root);
    if opened_what_was_verified {
        Ok(repository)
    } else {
        Err(GitReadCondition::RepositoryReadFailed)
    }
}

/// The two locations a read of a root's Git state opens, both verified to lie inside the folder.
struct Locations {
    git_directory: PathBuf,
    common_directory: PathBuf,
}

fn verified_locations(root: &Path) -> Result<Locations, GitReadCondition> {
    let git_directory = match root.join(GIT_ENTRY).symlink_metadata() {
        Err(error) if error.kind() == io::ErrorKind::NotFound => {
            return Err(GitReadCondition::NotARoot);
        }
        Err(_) => return Err(GitReadCondition::GitDirectoryUnreadable),
        Ok(metadata) if metadata.is_dir() => root.join(GIT_ENTRY),
        Ok(metadata) if metadata.is_file() => {
            let value = gitdir_value(&root.join(GIT_ENTRY))?;
            locate_inside(root, root, Path::new(OsStr::from_bytes(&value)))?
        }
        Ok(_) => return Err(GitReadCondition::NotARoot),
    };
    let common_directory = match read_spelling_file(&git_directory.join(COMMON_DIRECTORY_FILE)) {
        Ok(content) => {
            let value = up_to_nul(trim_end_c_space(&content));
            locate_inside(root, &git_directory, Path::new(OsStr::from_bytes(value)))?
        }
        Err(error) if error.kind() == io::ErrorKind::NotFound => git_directory.clone(),
        Err(_) => return Err(GitReadCondition::GitDirectoryUnreadable),
    };
    Ok(Locations {
        git_directory,
        common_directory,
    })
}

/// Spells `value` from `base`, and answers the location only when it lies inside `root` and is
/// there. A location outside is refused with its spelled path, whether or not anything is there.
fn locate_inside(root: &Path, base: &Path, value: &Path) -> Result<PathBuf, GitReadCondition> {
    let location =
        spell_location(root, base, value, &inspect_on_disk).map_err(|stop| match stop {
            WalkStop::Missing => GitReadCondition::GitDirectoryMissing,
            WalkStop::Unreadable => GitReadCondition::GitDirectoryUnreadable,
            WalkStop::TooManyLinks => GitReadCondition::RepositoryReadFailed,
        })?;
    if lies_inside(root, &location) {
        Ok(location)
    } else {
        Err(GitReadCondition::GitDirectoryOutside(location))
    }
}

/// What the walk learns about one position inside the folder.
enum Inspected {
    Absent,
    NotALink,
    /// The position is a link, with the text it holds.
    Link(PathBuf),
    Unreadable,
}

/// Why a walk stopped before ending at a location.
#[derive(Debug)]
enum WalkStop {
    Missing,
    Unreadable,
    TooManyLinks,
}

fn inspect_on_disk(position: &Path) -> Inspected {
    match position.symlink_metadata() {
        Err(error) if error.kind() == io::ErrorKind::NotFound => Inspected::Absent,
        Err(_) => Inspected::Unreadable,
        Ok(metadata) if metadata.file_type().is_symlink() => match std::fs::read_link(position) {
            Ok(text) => Inspected::Link(text),
            Err(_) => Inspected::Unreadable,
        },
        Ok(_) => Inspected::NotALink,
    }
}

/// Whether `location` is `root` or below it, compared by components and never by string prefix.
fn lies_inside(root: &Path, location: &Path) -> bool {
    location.starts_with(root)
}

/// Walks `value` component by component from `base`, by spelling. An absolute value replaces the
/// position, `.` moves nothing and `..` goes to the parent. A name at an inside position is looked
/// at without following it, and a link's own text is spliced in by spelling. At an outside position
/// nothing is looked at and names apply by spelling, so re-entry is only on the folder's own path,
/// exactly as spelled.
fn spell_location(
    root: &Path,
    base: &Path,
    value: &Path,
    inspect: &dyn Fn(&Path) -> Inspected,
) -> Result<PathBuf, WalkStop> {
    let mut position = base.to_path_buf();
    let mut pending = VecDeque::new();
    queue_steps(value, &mut position, &mut pending);
    let mut hops = 0;
    while let Some(step) = pending.pop_front() {
        let Some(name) = step else {
            position.pop();
            continue;
        };
        position.push(&name);
        if !lies_inside(root, &position) || position == root {
            continue;
        }
        match inspect(&position) {
            Inspected::Absent => return Err(WalkStop::Missing),
            Inspected::Unreadable => return Err(WalkStop::Unreadable),
            Inspected::NotALink => {}
            Inspected::Link(text) => {
                hops += 1;
                if hops > MAX_LINK_HOPS {
                    return Err(WalkStop::TooManyLinks);
                }
                position.pop();
                queue_steps(&text, &mut position, &mut pending);
            }
        }
    }
    Ok(position)
}

/// Puts `value`'s steps in front of the pending ones, `None` standing for `..`. An absolute value
/// moves the position to the filesystem root first.
fn queue_steps(value: &Path, position: &mut PathBuf, pending: &mut VecDeque<Option<OsString>>) {
    if value.is_absolute() {
        *position = PathBuf::from("/");
    }
    let steps: Vec<_> = value
        .components()
        .filter_map(|component| match component {
            Component::ParentDir => Some(None),
            Component::Normal(name) => Some(Some(name.to_os_string())),
            Component::Prefix(_) | Component::RootDir | Component::CurDir => None,
        })
        .collect();
    for step in steps.into_iter().rev() {
        pending.push_front(step);
    }
}

/// The value a `.git` file names, parsed by libgit2's own rule (`read_gitfile` in the vendored
/// libgit2 1.9.7): the file's end is trimmed, it must be longer than `gitdir:` and begin with it, and
/// the value is what follows once leading whitespace is skipped, up to the first NUL byte.
fn gitdir_value(file: &Path) -> Result<Vec<u8>, GitReadCondition> {
    let content = read_spelling_file(file).map_err(|_| GitReadCondition::GitDirectoryUnreadable)?;
    let trimmed = trim_end_c_space(&content);
    if trimmed.len() <= GIT_FILE_PREFIX.len() || !trimmed.starts_with(GIT_FILE_PREFIX) {
        return Err(GitReadCondition::NotARoot);
    }
    let after_prefix = &trimmed[GIT_FILE_PREFIX.len()..];
    let start = after_prefix
        .iter()
        .position(|byte| !is_c_space(*byte))
        .unwrap_or(after_prefix.len());
    Ok(up_to_nul(&after_prefix[start..]).to_vec())
}

/// What libgit2 reads of a value it holds as a C string: the bytes before the first NUL, so the bound
/// verifies the location libgit2 opens and not one spelled by bytes libgit2 never sees.
fn up_to_nul(bytes: &[u8]) -> &[u8] {
    bytes
        .iter()
        .position(|byte| *byte == 0)
        .map_or(bytes, |end| &bytes[..end])
}

fn trim_end_c_space(bytes: &[u8]) -> &[u8] {
    let end = bytes
        .iter()
        .rposition(|byte| !is_c_space(*byte))
        .map_or(0, |last| last + 1);
    &bytes[..end]
}

/// Reads a regular file the bound looks at, opened without following a link and without blocking,
/// held up to [`SPELLING_FILE_LIMIT`] bytes.
fn read_spelling_file(path: &Path) -> io::Result<Vec<u8>> {
    let mut file = std::fs::OpenOptions::new()
        .read(true)
        .custom_flags(no_follow_non_blocking_flags())
        .open(path)?;
    if !file.metadata()?.is_file() {
        return Err(io::Error::other("not a regular file"));
    }
    let mut content = Vec::new();
    file.by_ref()
        .take(SPELLING_FILE_LIMIT + 1)
        .read_to_end(&mut content)?;
    if content.len() as u64 > SPELLING_FILE_LIMIT {
        return Err(io::Error::other("file too large"));
    }
    Ok(content)
}

fn no_follow_non_blocking_flags() -> i32 {
    i32::try_from((OFlags::NOFOLLOW | OFlags::NONBLOCK).bits())
        .expect("the two open flags are small bits that fit the i32 `custom_flags` takes")
}

/// HEAD's own reference, unresolved: a symbolic one names the branch, born or not, and a direct one
/// names the commit HEAD is detached at.
fn head_state(repository: &Repository) -> Result<HeadState, GitReadCondition> {
    let failed = |_| GitReadCondition::RepositoryReadFailed;
    let head = repository.find_reference(HEAD_REFERENCE).map_err(failed)?;
    let branch = match (head.symbolic_target_bytes(), head.target()) {
        (Some(target), _) => {
            let target = String::from_utf8_lossy(target);
            BranchElement::Branch(
                target
                    .strip_prefix(BRANCH_REFERENCE_PREFIX)
                    .unwrap_or(&target)
                    .to_string(),
            )
        }
        (None, Some(commit)) => BranchElement::Detached(commit.to_string()),
        (None, None) => return Err(GitReadCondition::RepositoryReadFailed),
    };
    let detached = matches!(branch, BranchElement::Detached(_));
    Ok(HeadState {
        branch,
        state: repository_state(repository.state(), detached),
    })
}

/// An exhaustive match with no wildcard arm: a state a later git2 adds fails the build and is never
/// answered as `Normal`.
fn repository_state(state: GitRepositoryState, head_detached: bool) -> RepositoryState {
    match state {
        GitRepositoryState::Clean if head_detached => RepositoryState::DetachedHead,
        GitRepositoryState::Clean => RepositoryState::Normal,
        GitRepositoryState::Merge => RepositoryState::Merge,
        GitRepositoryState::Revert | GitRepositoryState::RevertSequence => RepositoryState::Revert,
        GitRepositoryState::CherryPick | GitRepositoryState::CherryPickSequence => {
            RepositoryState::CherryPick
        }
        GitRepositoryState::Bisect => RepositoryState::Bisect,
        GitRepositoryState::Rebase
        | GitRepositoryState::RebaseInteractive
        | GitRepositoryState::RebaseMerge
        | GitRepositoryState::ApplyMailboxOrRebase => RepositoryState::Rebase,
        GitRepositoryState::ApplyMailbox => RepositoryState::Am,
    }
}

/// One `statuses()` call that writes nothing: untracked files and the files inside untracked folders
/// are listed, ignored ones are not, a rename is looked for between HEAD and the index only, and the
/// index is never refreshed on disk.
fn status_lists(repository: &Repository) -> Result<StatusLists, GitReadCondition> {
    let mut options = StatusOptions::new();
    options
        .include_untracked(true)
        .recurse_untracked_dirs(true)
        .include_ignored(false)
        .renames_head_to_index(true)
        .renames_index_to_workdir(false)
        .update_index(false);
    let statuses = repository
        .statuses(Some(&mut options))
        .map_err(|_| GitReadCondition::RepositoryReadFailed)?;
    let mut lists = StatusLists {
        staged: Vec::new(),
        changed: Vec::new(),
    };
    for found in statuses.iter() {
        let status = found.status();
        if status.contains(Status::CONFLICTED) {
            lists.changed.push(StatusEntry {
                path: spelled_lossily(found.path_bytes()),
                category: StatusCategory::InConflict,
            });
            continue;
        }
        if let Some(category) = staged_category(&found) {
            lists.staged.push(category);
        }
        if let Some(category) = changed_category(status) {
            lists.changed.push(StatusEntry {
                path: changed_path(&found),
                category,
            });
        }
    }
    Ok(lists)
}

/// The staged entry for a file that differs between HEAD and the index, if it does.
fn staged_category(found: &git2::StatusEntry<'_>) -> Option<StatusEntry> {
    let status = found.status();
    let delta = found.head_to_index()?;
    let old_path = spelled_lossily(delta.old_file().path_bytes().unwrap_or_default());
    let new_path = spelled_lossily(delta.new_file().path_bytes().unwrap_or_default());
    let (path, category) = if status.contains(Status::INDEX_RENAMED) {
        (new_path, StatusCategory::Renamed { from: old_path })
    } else if status.contains(Status::INDEX_NEW) {
        (new_path, StatusCategory::Added)
    } else if status.intersects(Status::INDEX_MODIFIED | Status::INDEX_TYPECHANGE) {
        (new_path, StatusCategory::Modified)
    } else if status.contains(Status::INDEX_DELETED) {
        (old_path, StatusCategory::Deleted)
    } else {
        return None;
    };
    Some(StatusEntry { path, category })
}

/// The path a changed entry is at: the index side of the index-to-working-tree delta. For a staged
/// rename that is the path renamed to, where `path_bytes()` names the path it left.
fn changed_path(found: &git2::StatusEntry<'_>) -> String {
    found
        .index_to_workdir()
        .and_then(|delta| delta.old_file().path_bytes().map(spelled_lossily))
        .unwrap_or_else(|| spelled_lossily(found.path_bytes()))
}

fn changed_category(status: Status) -> Option<StatusCategory> {
    if status.contains(Status::WT_NEW) {
        Some(StatusCategory::Untracked)
    } else if status.contains(Status::WT_DELETED) {
        Some(StatusCategory::Deleted)
    } else if status.intersects(Status::WT_MODIFIED | Status::WT_TYPECHANGE) {
        Some(StatusCategory::Modified)
    } else {
        None
    }
}

/// A path's bytes spelled as `list_tree` spells an entry's path: lossily.
fn spelled_lossily(bytes: &[u8]) -> String {
    String::from_utf8_lossy(bytes).into_owned()
}

/// A `.git` regular file is answered from its own bytes and nothing the file names is ever opened:
/// `Root` when it holds a `gitdir:` line, `Plain` for any other content.
///
/// The open is read-only, without following a link and without blocking, so an entry swapped in
/// between the look and the open fails the open (a link) or is refused below (a FIFO, a device)
/// before any byte is read. The handle's own type is asked first for the same reason.
fn probe_git_file(path: &Path) -> RootFinding {
    let flags = no_follow_non_blocking_flags();
    let unreadable = RootFinding::Failed(ProbeCondition::GitFileUnreadable);
    let Ok(file) = std::fs::OpenOptions::new()
        .read(true)
        .custom_flags(flags)
        .open(path)
    else {
        return unreadable;
    };
    match file.metadata() {
        Ok(metadata) if metadata.is_file() => match names_a_git_directory(file) {
            Ok(true) => RootFinding::Root,
            Ok(false) => RootFinding::Plain,
            Err(_) => unreadable,
        },
        Ok(_) => RootFinding::Failed(ProbeCondition::GitEntryNotDirectory),
        Err(_) => unreadable,
    }
}

/// Whether the bytes begin with `gitdir:` and some byte after it is not whitespace, which is the
/// same as a `gitdir:` line left holding something once its end is trimmed. The whitespace is the six
/// bytes C `isspace` names, libgit2's set, and not `u8::is_ascii_whitespace`, which leaves out the
/// vertical tab. Reading stops at the first such byte or at the end of the bytes.
fn names_a_git_directory(mut bytes: impl Read) -> io::Result<bool> {
    let mut prefix = [0_u8; GIT_FILE_PREFIX.len()];
    let mut filled = 0;
    while filled < prefix.len() {
        match read_retrying_interrupts(&mut bytes, &mut prefix[filled..])? {
            0 => return Ok(false),
            read => filled += read,
        }
    }
    if prefix != GIT_FILE_PREFIX {
        return Ok(false);
    }
    let mut chunk = [0_u8; GIT_FILE_CHUNK];
    loop {
        match read_retrying_interrupts(&mut bytes, &mut chunk)? {
            0 => return Ok(false),
            read if chunk[..read].iter().any(|byte| !is_c_space(*byte)) => return Ok(true),
            _ => {}
        }
    }
}

fn read_retrying_interrupts(bytes: &mut impl Read, buffer: &mut [u8]) -> io::Result<usize> {
    loop {
        match bytes.read(buffer) {
            Err(error) if error.kind() == io::ErrorKind::Interrupted => {}
            outcome => return outcome,
        }
    }
}

fn is_c_space(byte: u8) -> bool {
    matches!(byte, b' ' | b'\t' | b'\n' | 0x0B | 0x0C | b'\r')
}

/// libgit2 is asked about the `.git` entry the look found and nothing else: told neither to append
/// `.git` nor to search, it cannot take the opened folder itself, or a folder above it, as the Git
/// directory when that entry is not one (`tests/root_finding.rs`,
/// `test_git_directory_opened_directly_holding_a_git_folder_answers_plain`).
fn open_repository(folder: &Path) -> RootFinding {
    let flags = RepositoryOpenFlags::NO_SEARCH | RepositoryOpenFlags::NO_DOTGIT;
    match Repository::open_ext(folder.join(GIT_ENTRY), flags, no_ceilings()) {
        Ok(repository) if is_top_level(&repository) => RootFinding::Root,
        Ok(_) => RootFinding::Plain,
        Err(error) if error.code() == ErrorCode::NotFound => look_inside_git_directory(folder),
        Err(_) => RootFinding::Failed(ProbeCondition::RepositoryReadFailed),
    }
}

/// libgit2 reports `NotFound` both for a readable `.git` that is not a repository and for one the
/// operating system will not let it enter, so the split is made here by looking at one entry inside.
fn look_inside_git_directory(folder: &Path) -> RootFinding {
    match folder.join(GIT_ENTRY).join(GIT_HEAD).symlink_metadata() {
        Err(error) if error.kind() != io::ErrorKind::NotFound => {
            RootFinding::Failed(ProbeCondition::GitDirectoryUnreadable)
        }
        _ => RootFinding::Plain,
    }
}

/// Whether libgit2 itself reports a working repository whose git-dir is a `.git` folder directly
/// inside its working directory, compared by components so the caller's spelling never matters.
fn is_top_level(repository: &Repository) -> bool {
    if repository.is_bare() {
        return false;
    }
    let git_dir = repository.path();
    git_dir.file_name() == Some(OsStr::new(GIT_ENTRY))
        && repository.workdir().is_some()
        && repository.workdir() == git_dir.parent()
}

fn no_ceilings() -> [&'static OsStr; 0] {
    []
}

#[cfg(test)]
mod tests {
    use std::io::{self, Read};
    use std::path::{Path, PathBuf};

    use super::{Inspected, lies_inside, names_a_git_directory, spell_location};

    /// Hands out at most one byte per read, and fails the first read with `Interrupted`.
    struct Trickle<'a> {
        remaining: &'a [u8],
        interrupted: bool,
    }

    impl Read for Trickle<'_> {
        fn read(&mut self, buffer: &mut [u8]) -> io::Result<usize> {
            if !self.interrupted {
                self.interrupted = true;
                return Err(io::ErrorKind::Interrupted.into());
            }
            let Some((first, rest)) = self.remaining.split_first() else {
                return Ok(0);
            };
            buffer[0] = *first;
            self.remaining = rest;
            Ok(1)
        }
    }

    #[test]
    fn test_gitdir_test_survives_short_and_interrupted_reads() {
        let reader = |bytes| Trickle {
            remaining: bytes,
            interrupted: false,
        };

        assert!(names_a_git_directory(reader(b"gitdir: ../a\n")).expect("the read succeeds"));
        assert!(!names_a_git_directory(reader(b"gitdir: \x0B\n")).expect("the read succeeds"));
        assert!(!names_a_git_directory(reader(b"gitdir")).expect("the read succeeds"));
    }

    /// Hands out one byte per read, failing every read once with `Interrupted` before it does, and
    /// at the end fails with `end` where it is given instead of reporting the end of the bytes.
    struct Stutter<'a> {
        remaining: &'a [u8],
        interrupt_next: bool,
        end: Option<io::ErrorKind>,
    }

    impl<'a> Stutter<'a> {
        fn new(remaining: &'a [u8], end: Option<io::ErrorKind>) -> Self {
            Self {
                remaining,
                interrupt_next: true,
                end,
            }
        }
    }

    impl Read for Stutter<'_> {
        fn read(&mut self, buffer: &mut [u8]) -> io::Result<usize> {
            if self.interrupt_next {
                self.interrupt_next = false;
                return Err(io::ErrorKind::Interrupted.into());
            }
            self.interrupt_next = true;
            let Some((first, rest)) = self.remaining.split_first() else {
                return self.end.map_or(Ok(0), |kind| Err(kind.into()));
            };
            buffer[0] = *first;
            self.remaining = rest;
            Ok(1)
        }
    }

    /// An interrupt is retried wherever it lands, after the prefix as much as inside it.
    #[test]
    fn test_gitdir_test_retries_an_interrupt_before_every_read() {
        let answer = |bytes| names_a_git_directory(Stutter::new(bytes, None));

        assert!(answer(b"gitdir:   \n\t a").expect("every interrupt is retried"));
        assert!(!answer(b"gitdir:   \n\t ").expect("every interrupt is retried"));
    }

    /// A read that fails for any reason but an interrupt is a failure and never an answer, inside
    /// the prefix or after it, so the probe can answer `GitFileUnreadable` and not `Plain`.
    #[test]
    fn test_gitdir_test_reports_a_read_failure_and_never_answers() {
        for bytes in [&b"gitd"[..], b"gitdir:", b"gitdir:  \n"] {
            let outcome = names_a_git_directory(Stutter::new(bytes, Some(io::ErrorKind::Other)));
            assert_eq!(
                outcome.map_err(|error| error.kind()),
                Err(io::ErrorKind::Other),
                "{bytes:?}"
            );
        }
    }

    #[test]
    fn test_linked_library_is_vendored_without_https_or_ssh() {
        let version = git2::Version::get();

        assert!(version.vendored(), "libgit2 is the copy compiled in");
        assert!(!version.https(), "HTTPS is off");
        assert!(!version.ssh(), "SSH is off");
    }

    /// No position on the way is a link, so the walk is spelling alone.
    fn no_links(_position: &Path) -> Inspected {
        Inspected::NotALink
    }

    fn spelled(root: &str, base: &str, value: &str) -> PathBuf {
        spell_location(
            Path::new(root),
            Path::new(base),
            Path::new(value),
            &no_links,
        )
        .expect("a walk over no links never stops")
    }

    #[test]
    fn test_parent_escape_lands_beside_the_folder() {
        let landed = spelled("/a/S", "/a/S", "../nowhere/.git");

        assert_eq!(landed, Path::new("/a/nowhere/.git"));
        assert!(!lies_inside(Path::new("/a/S"), &landed));
    }

    #[test]
    fn test_absolute_value_replaces_the_position() {
        assert_eq!(spelled("/a/S", "/a/S", "/x/../y"), Path::new("/y"));
    }

    #[test]
    fn test_dot_dot_back_inside_stays_inside() {
        let landed = spelled("/a/S", "/a/S", "sub/../.realgit");

        assert_eq!(landed, Path::new("/a/S/.realgit"));
        assert!(lies_inside(Path::new("/a/S"), &landed));
    }

    #[test]
    fn test_reentry_on_the_folders_own_spelled_name_is_inside() {
        let landed = spelled("/a/S", "/a/S", "../S/.realgit");

        assert_eq!(landed, Path::new("/a/S/.realgit"));
        assert!(lies_inside(Path::new("/a/S"), &landed));
    }

    #[test]
    fn test_dot_dot_at_filesystem_root_stays_at_root() {
        assert_eq!(spelled("/a/S", "/", "../../x"), Path::new("/x"));
    }

    #[test]
    fn test_sibling_with_shared_prefix_is_not_inside() {
        assert!(!lies_inside(Path::new("/a/S"), Path::new("/a/Sx")));
        assert!(!lies_inside(Path::new("/a/S"), Path::new("/a/Sx/.git")));
        assert!(lies_inside(Path::new("/a/S"), Path::new("/a/S/.git")));
    }
}
