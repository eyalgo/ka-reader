//! The libgit2 adapter of the Git port. Every Git read and the binding itself live in this file.

use std::ffi::OsStr;
use std::io;
use std::path::Path;

use git2::{ErrorCode, Repository, RepositoryOpenFlags};

use super::{GitPort, ProbeCondition, RootFinding};

const GIT_ENTRY: &str = ".git";
const GIT_HEAD: &str = "HEAD";

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
            Ok(metadata) if !metadata.is_dir() => {
                RootFinding::Failed(ProbeCondition::GitEntryNotDirectory)
            }
            Ok(_) => open_repository(folder),
        }
    }
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
    #[test]
    fn test_linked_library_is_vendored_without_https_or_ssh() {
        let version = git2::Version::get();

        assert!(version.vendored(), "libgit2 is the copy compiled in");
        assert!(!version.https(), "HTTPS is off");
        assert!(!version.ssh(), "SSH is off");
    }
}
