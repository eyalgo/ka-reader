//! The libgit2 adapter of the Git port. Every Git read and the binding itself live in this file.

use std::ffi::OsStr;
use std::io::{self, Read};
use std::os::unix::fs::OpenOptionsExt;
use std::path::Path;

use git2::{ErrorCode, Repository, RepositoryOpenFlags};
use rustix::fs::OFlags;

use super::{GitPort, ProbeCondition, RootFinding};

const GIT_ENTRY: &str = ".git";
const GIT_HEAD: &str = "HEAD";
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
}

/// A `.git` regular file is answered from its own bytes and nothing the file names is ever opened:
/// `Root` when it holds a `gitdir:` line, `Plain` for any other content.
///
/// The open is read-only, without following a link and without blocking, so an entry swapped in
/// between the look and the open fails the open (a link) or is refused below (a FIFO, a device)
/// before any byte is read. The handle's own type is asked first for the same reason.
fn probe_git_file(path: &Path) -> RootFinding {
    let flags = i32::try_from((OFlags::NOFOLLOW | OFlags::NONBLOCK).bits())
        .expect("the two open flags are small bits that fit the i32 `custom_flags` takes");
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

    use super::names_a_git_directory;

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
}
