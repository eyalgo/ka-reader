//! The libgit2 adapter of the Git port. Every Git read and the binding itself live in this file.

use std::collections::{HashSet, VecDeque};
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

use super::alternates_scan::{self, AlternateEntry, EntryClass};
use super::config_scan::{self, ConfigReference, Placement, ReferenceKind};
use super::{
    BranchElement, ConfigNamedPath, GitPort, GitReadCondition, HeadState, ProbeCondition,
    RepositoryState, RootFinding, StatusCategory, StatusEntry, StatusLists,
};

const GIT_ENTRY: &str = ".git";
const GIT_HEAD: &str = "HEAD";
const HEAD_REFERENCE: &str = "HEAD";
const BRANCH_REFERENCE_PREFIX: &str = "refs/heads/";
const COMMON_DIRECTORY_FILE: &str = "commondir";
const CONFIG_FILE: &str = "config";
const WORKTREE_CONFIG_FILE: &str = "config.worktree";
const SUBMODULE_CONFIG_FILE: &str = ".gitmodules";
const OBJECTS_DIRECTORY: &str = "objects";
const INFO_DIRECTORY: &str = "info";
const ALTERNATES_FILE: &str = "alternates";
/// The mode an index entry holds for a submodule's commit.
const GITLINK_MODE: u32 = 0o160_000;
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

/// The three depths the checks stop at. Each is named so a unit test can drive a small bound.
struct Bounds {
    /// A config file this deep through includes, counting the repository's own `config` as 0, is
    /// refused as libgit2 refuses it (`MAX_INCLUDE_DEPTH` in `config_file.c`).
    include_depth: usize,
    /// A submodule nested this deep, counting the repository's own as 0, is refused.
    submodule_depth: usize,
    /// An alternates file is read this many levels down, counting the repository's own as 0, and
    /// an alternate one level past it that holds an alternates file at all is refused, as libgit2
    /// refuses a chain deeper than `GIT_ALTERNATES_MAX_DEPTH` in `odb.c`.
    alternates_depth: usize,
}

const BOUNDS: Bounds = Bounds {
    include_depth: 10,
    submodule_depth: 10,
    alternates_depth: 5,
};

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
            Ok(metadata) if metadata.is_dir() => probe_git_folder(folder),
            Ok(metadata) if metadata.is_file() => probe_git_file(&folder.join(GIT_ENTRY)),
            Ok(_) => RootFinding::Failed(ProbeCondition::GitEntryNotDirectory),
        }
    }

    fn state(&self, root: &Path) -> Result<HeadState, GitReadCondition> {
        head_state(&open_verified(root)?)
    }

    fn status(&self, root: &Path) -> Result<StatusLists, GitReadCondition> {
        let repository = open_verified(root)?;
        verify_submodules(root, &repository, root, 0, &BOUNDS)?;
        status_lists(&repository)
    }
}

/// Locates the Git directory and the common directory by spelling, refuses either one outside the
/// folder, checks the config for a path outside the folder, opens libgit2 on `root` only then, and
/// requires what libgit2 opened to be what was verified. Both calls share this one helper, so they
/// refuse alike.
fn open_verified(root: &Path) -> Result<Repository, GitReadCondition> {
    let locations = verified_locations(root, root)?;
    check_config(root, &locations, &BOUNDS)?;
    check_alternates(root, &locations, &BOUNDS)?;
    open_at(root, &locations)
}

/// Opens libgit2 on `folder` without searching, and requires what it opened to be the verified
/// `locations` and `folder` as its working tree.
fn open_at(folder: &Path, locations: &Locations) -> Result<Repository, GitReadCondition> {
    let repository = Repository::open_ext(folder, RepositoryOpenFlags::NO_SEARCH, no_ceilings())
        .map_err(|error| match error.code() {
            ErrorCode::NotFound => GitReadCondition::NotARepository,
            _ => GitReadCondition::RepositoryReadFailed,
        })?;
    let opened_what_was_verified = repository.path() == locations.git_directory
        && repository.commondir() == locations.common_directory
        && repository.workdir() == Some(folder);
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

/// Locates the Git directory of `folder`'s `.git` entry and its common directory, both required to
/// lie inside `grant`, the folder the user opened. For the top level `folder` is `grant`; for a
/// submodule it is the submodule's folder.
fn verified_locations(grant: &Path, folder: &Path) -> Result<Locations, GitReadCondition> {
    let git_directory = match folder.join(GIT_ENTRY).symlink_metadata() {
        Err(error) if error.kind() == io::ErrorKind::NotFound => {
            return Err(GitReadCondition::NotARoot);
        }
        Err(_) => return Err(GitReadCondition::GitDirectoryUnreadable),
        Ok(metadata) if metadata.is_dir() => folder.join(GIT_ENTRY),
        Ok(metadata) if metadata.is_file() => {
            let value = gitdir_value(&folder.join(GIT_ENTRY))?;
            locate_inside(grant, folder, Path::new(OsStr::from_bytes(&value)))?
        }
        Ok(_) => return Err(GitReadCondition::NotARoot),
    };
    let common_directory = common_directory_of(grant, &git_directory)?;
    Ok(Locations {
        git_directory,
        common_directory,
    })
}

/// The common directory of `git_directory`: itself, or what its `commondir` file spells, which must
/// lie inside `grant` and be there.
fn common_directory_of(grant: &Path, git_directory: &Path) -> Result<PathBuf, GitReadCondition> {
    match read_spelling_file(&git_directory.join(COMMON_DIRECTORY_FILE)) {
        Ok(content) => {
            let value = up_to_nul(trim_end_c_space(&content));
            locate_inside(grant, git_directory, Path::new(OsStr::from_bytes(value)))
        }
        Err(error) if error.kind() == io::ErrorKind::NotFound => Ok(git_directory.to_path_buf()),
        Err(_) => Err(GitReadCondition::GitDirectoryUnreadable),
    }
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

/// Reads the repository's config, and every file it includes that spells inside the folder, with
/// the scanner (never with libgit2, whose open follows an include wherever it points), and refuses
/// the first key libgit2 would follow to a path outside the folder. A file is read only after its
/// location has spelled inside, so a path outside is never opened.
///
/// The files are the `config` in the common directory and, where a file sets
/// `extensions.worktreeConfig`, the `config.worktree` in the Git directory.
fn check_config(
    grant: &Path,
    locations: &Locations,
    bounds: &Bounds,
) -> Result<(), GitReadCondition> {
    check_config_file(
        grant,
        locations,
        locations.common_directory.join(CONFIG_FILE),
        ConfigPurpose::Repository,
        bounds,
    )
}

#[derive(Clone, Copy, PartialEq, Eq)]
enum ConfigPurpose {
    Repository,
    Submodules,
}

fn check_config_file(
    grant: &Path,
    locations: &Locations,
    file: PathBuf,
    purpose: ConfigPurpose,
    bounds: &Bounds,
) -> Result<(), GitReadCondition> {
    let mut pending = VecDeque::from([(file, 0)]);
    let mut worktree_config_queued = false;
    while let Some((file, depth)) = pending.pop_front() {
        let content = match read_spelling_file(&file) {
            Ok(content) => content,
            Err(error) if error.kind() == io::ErrorKind::NotFound => continue,
            Err(_) => return Err(GitReadCondition::GitDirectoryUnreadable),
        };
        if depth >= bounds.include_depth {
            return Err(GitReadCondition::RepositoryReadFailed);
        }
        let scan =
            config_scan::scan(&content).map_err(|_| GitReadCondition::RepositoryReadFailed)?;
        if purpose == ConfigPurpose::Repository && scan.worktree_config && !worktree_config_queued {
            worktree_config_queued = true;
            pending.push_back((locations.git_directory.join(WORKTREE_CONFIG_FILE), 0));
        }
        for reference in &scan.references {
            // libgit2's submodule.c reads submodule fields from this config; only includes
            // follow paths. Repository options in .gitmodules do not configure the repository.
            if purpose == ConfigPurpose::Submodules && reference.kind != ReferenceKind::Include {
                continue;
            }
            if let Some(included) = follow(grant, locations, &file, reference)? {
                pending.push_back((included, depth + 1));
            }
        }
    }
    Ok(())
}

/// Spells what one refused key names. A value the reader does not locate refuses as not located, and
/// a path that spells outside the folder refuses as outside; an include that spells
/// inside is answered so its file is read next; anything else that spells inside, or is not there,
/// is left to the open.
fn follow(
    grant: &Path,
    locations: &Locations,
    file: &Path,
    reference: &ConfigReference,
) -> Result<Option<PathBuf>, GitReadCondition> {
    let named = || ConfigNamedPath {
        key: reference.key.clone(),
        path: spelled_lossily(&reference.value),
    };
    let base = match reference.placement {
        Placement::NotLocated => return Err(GitReadCondition::ConfigNotLocated(named())),
        Placement::FromTheFile => file.parent().unwrap_or(file),
        Placement::FromTheGitDirectory => &locations.git_directory,
    };
    let value = Path::new(OsStr::from_bytes(&reference.value));
    let location = match spell_location(grant, base, value, &inspect_on_disk) {
        Ok(location) => location,
        Err(WalkStop::Missing) => return Ok(None),
        Err(WalkStop::Unreadable) => return Err(GitReadCondition::GitDirectoryUnreadable),
        Err(WalkStop::TooManyLinks) => return Err(GitReadCondition::RepositoryReadFailed),
    };
    if !lies_inside(grant, &location) {
        return Err(GitReadCondition::ConfigNamesOutside(named()));
    }
    Ok((reference.kind == ReferenceKind::Include).then_some(location))
}

/// The alternates check, run where the config check runs. It reads `objects/info/alternates` under
/// the common directory, and the same file of each alternate that spells inside the folder, level
/// by level and top to bottom, so the first refused value met is the one carried. It refuses any
/// entry that begins with neither `.` nor `/` as not located, and any entry, or any link at
/// `objects`, `info` or `alternates`, that spells outside the folder as outside, and reads nothing
/// there. An alternate already reached is not read again, as libgit2 adds an object
/// directory once.
///
/// Files are read down to `bounds.alternates_depth`, counting the repository's own as level 0. An
/// alternate one level past it is not read, and is refused as too deep when it holds an alternates
/// file at all, as libgit2 reads none there. A spelling that leaves the folder at that level is
/// refused the same way, since nothing was observed being read.
fn check_alternates(
    grant: &Path,
    locations: &Locations,
    bounds: &Bounds,
) -> Result<(), GitReadCondition> {
    let Some(objects) = spell_step(grant, &locations.common_directory, OBJECTS_DIRECTORY)? else {
        return Ok(());
    };
    let mut reached = HashSet::from([objects.clone()]);
    let mut pending = VecDeque::from([(objects, 0)]);
    while let Some((objects, level)) = pending.pop_front() {
        let file = alternates_file_of(grant, &objects);
        if level > bounds.alternates_depth {
            return match file {
                Ok(None) => continue,
                Ok(Some(_)) | Err(GitReadCondition::ObjectStoreNamesOutside(_)) => {
                    Err(GitReadCondition::RepositoryReadFailed)
                }
                Err(other) => Err(other),
            };
        }
        let Some(file) = file? else {
            continue;
        };
        let Some(content) = read_alternates(&file)? else {
            continue;
        };
        for entry in alternates_scan::scan(&content) {
            if let Some(alternate) = spell_entry(grant, &objects, &entry)?
                && reached.insert(alternate.clone())
            {
                pending.push_back((alternate, level + 1));
            }
        }
    }
    Ok(())
}

/// Where one alternates entry lies, spelled from `objects`, the object directory that holds the
/// file. An entry that begins with neither `.` nor `/` is refused as not located, as the file spells
/// it, before anything is spelled. An entry whose spelling lies outside the folder is refused as
/// outside, as the file spells it. `None` when the entry spells inside and nothing is there.
fn spell_entry(
    grant: &Path,
    objects: &Path,
    entry: &AlternateEntry,
) -> Result<Option<PathBuf>, GitReadCondition> {
    if entry.class == EntryClass::NotLocated {
        return Err(GitReadCondition::ObjectStoreNotLocated(spelled_lossily(
            &entry.value,
        )));
    }
    let value = Path::new(OsStr::from_bytes(&entry.value));
    match spell_location(grant, objects, value, &inspect_on_disk) {
        Ok(location) if lies_inside(grant, &location) => Ok(Some(location)),
        Ok(_) => Err(GitReadCondition::ObjectStoreNamesOutside(spelled_lossily(
            &entry.value,
        ))),
        Err(WalkStop::Missing) => Ok(None),
        Err(WalkStop::Unreadable) => Err(GitReadCondition::GitDirectoryUnreadable),
        Err(WalkStop::TooManyLinks) => Err(GitReadCondition::RepositoryReadFailed),
    }
}

/// The bytes of an alternates file, bounded as every file the check reads is. A file that is not there
/// is no file; one the check cannot read, that is too large or that is not a regular file is
/// unreadable.
fn read_alternates(file: &Path) -> Result<Option<Vec<u8>>, GitReadCondition> {
    match read_spelling_file(file) {
        Ok(content) => Ok(Some(content)),
        Err(error) if error.kind() == io::ErrorKind::NotFound => Ok(None),
        Err(_) => Err(GitReadCondition::GitDirectoryUnreadable),
    }
}

/// The location of `info/alternates` under an object directory, spelled one position at a time.
/// `None` when a position is not there, so there is no file.
fn alternates_file_of(grant: &Path, objects: &Path) -> Result<Option<PathBuf>, GitReadCondition> {
    let Some(info) = spell_step(grant, objects, INFO_DIRECTORY)? else {
        return Ok(None);
    };
    spell_step(grant, &info, ALTERNATES_FILE)
}

/// Spells `name` from `base` by the same walk every position of the object store takes, and answers
/// the location only when it lies inside the folder. A location outside is refused carrying that
/// location, which is a link's own spelling reached and never a path under it. `None` when the
/// position is not there.
fn spell_step(grant: &Path, base: &Path, name: &str) -> Result<Option<PathBuf>, GitReadCondition> {
    match spell_location(grant, base, Path::new(name), &inspect_on_disk) {
        Ok(location) if lies_inside(grant, &location) => Ok(Some(location)),
        Ok(location) => Err(GitReadCondition::ObjectStoreNamesOutside(spelled_lossily(
            location.as_os_str().as_bytes(),
        ))),
        Err(WalkStop::Missing) => Ok(None),
        Err(WalkStop::Unreadable) => Err(GitReadCondition::GitDirectoryUnreadable),
        Err(WalkStop::TooManyLinks) => Err(GitReadCondition::RepositoryReadFailed),
    }
}

/// Verifies every submodule the index names, before `statuses()` opens any of them: each one's Git
/// directory and common directory are located inside `grant`, its config is checked, and only then
/// is it opened, for the gitlinks it holds in turn. The first failure is the answer.
fn verify_submodules(
    grant: &Path,
    repository: &Repository,
    folder: &Path,
    depth: usize,
    bounds: &Bounds,
) -> Result<(), GitReadCondition> {
    // libgit2 1.9.7 submodule.c:2243-2260 opens .gitmodules with the config reader,
    // which follows includes before the submodule fields are filtered.
    check_config_file(
        grant,
        &Locations {
            git_directory: repository.path().to_path_buf(),
            common_directory: repository.commondir().to_path_buf(),
        },
        folder.join(SUBMODULE_CONFIG_FILE),
        ConfigPurpose::Submodules,
        bounds,
    )?;
    let index = repository
        .index()
        .map_err(|_| GitReadCondition::RepositoryReadFailed)?;
    for entry in index.iter().filter(|entry| entry.mode == GITLINK_MODE) {
        let relative = Path::new(OsStr::from_bytes(&entry.path));
        let submodule_folder = match spell_location(grant, folder, relative, &inspect_on_disk) {
            Ok(location) => location,
            Err(WalkStop::Missing) => continue,
            Err(WalkStop::Unreadable) => return Err(GitReadCondition::GitDirectoryUnreadable),
            Err(WalkStop::TooManyLinks) => return Err(GitReadCondition::RepositoryReadFailed),
        };
        if !lies_inside(grant, &submodule_folder) {
            return Err(GitReadCondition::GitDirectoryOutside(submodule_folder));
        }
        match submodule_folder.join(GIT_ENTRY).symlink_metadata() {
            Err(error) if error.kind() == io::ErrorKind::NotFound => continue,
            Err(_) => return Err(GitReadCondition::GitDirectoryUnreadable),
            Ok(_) => {}
        }
        if depth + 1 > bounds.submodule_depth {
            return Err(GitReadCondition::RepositoryReadFailed);
        }
        let locations =
            verified_locations(grant, &submodule_folder).map_err(|condition| match condition {
                GitReadCondition::NotARoot => GitReadCondition::RepositoryReadFailed,
                other => other,
            })?;
        check_config(grant, &locations, bounds)?;
        check_alternates(grant, &locations, bounds)?;
        let submodule = match open_at(&submodule_folder, &locations) {
            Ok(submodule) => submodule,
            Err(GitReadCondition::NotARepository) => continue,
            Err(other) => return Err(other),
        };
        verify_submodules(grant, &submodule, &submodule_folder, depth + 1, bounds)?;
    }
    Ok(())
}

/// The probe over a `.git` folder: the common directory is located by the same spelling the reads
/// use, and the config is checked, before libgit2 opens anything. A common directory outside the
/// folder opens nothing and answers `Root`, as a `.git` file's target does, so `state()` refuses it.
fn probe_git_folder(folder: &Path) -> RootFinding {
    let git_directory = folder.join(GIT_ENTRY);
    let common_directory = match common_directory_of(folder, &git_directory) {
        Ok(common_directory) => common_directory,
        Err(GitReadCondition::GitDirectoryOutside(_)) => return RootFinding::Root,
        Err(condition) => return RootFinding::Failed(probe_condition(condition)),
    };
    let locations = Locations {
        git_directory,
        common_directory,
    };
    match check_config(folder, &locations, &BOUNDS)
        .and_then(|()| check_alternates(folder, &locations, &BOUNDS))
    {
        Ok(()) => open_repository(folder),
        Err(condition) => RootFinding::Failed(probe_condition(condition)),
    }
}

/// What the probe answers for a condition the shared steps found. A location that is missing is
/// unreadable to the probe, which has no condition for a missing one.
fn probe_condition(condition: GitReadCondition) -> ProbeCondition {
    match condition {
        GitReadCondition::ConfigNamesOutside(named) => ProbeCondition::ConfigNamesOutside(named),
        GitReadCondition::ConfigNotLocated(named) => ProbeCondition::ConfigNotLocated(named),
        GitReadCondition::ObjectStoreNamesOutside(entry) => {
            ProbeCondition::ObjectStoreNamesOutside(entry)
        }
        GitReadCondition::ObjectStoreNotLocated(entry) => {
            ProbeCondition::ObjectStoreNotLocated(entry)
        }
        GitReadCondition::GitDirectoryUnreadable | GitReadCondition::GitDirectoryMissing => {
            ProbeCondition::GitDirectoryUnreadable
        }
        GitReadCondition::GitDirectoryOutside(_)
        | GitReadCondition::NotARoot
        | GitReadCondition::NotARepository
        | GitReadCondition::RepositoryReadFailed => ProbeCondition::RepositoryReadFailed,
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
#[path = "../../tests/unit/libgit2.rs"]
mod tests;
