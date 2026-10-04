//! Test support for `nozoki-bridge`'s unit tests: a temporary folder built from `std` alone. It lives
//! under `tests/common/` and not `src/`, so the production source names no `std::fs`; the unit tests
//! include it through `#[path]` (see `lib.rs`).
//!
//! `tempfile` is not used because it would add a package name to `Cargo.lock` and to
//! `checks/deps.allow`, and a dependency the tests can do without is not one to review.

use std::fs;
use std::io::Read;
use std::os::unix::fs::{PermissionsExt, symlink};
use std::os::unix::io::FromRawFd;
use std::path::{Path, PathBuf};
use std::process::{self, Command};
use std::sync::atomic::{AtomicU64, Ordering};
use std::sync::{Mutex, MutexGuard, Once};

use log::{Log, Metadata, Record};

static NEXT_FOLDER: AtomicU64 = AtomicU64::new(0);
static LOG_SERIAL: Mutex<()> = Mutex::new(());
static INSTALL_CAPTURE: Once = Once::new();

struct CaptureLog {
    records: Mutex<Vec<String>>,
}

impl Log for CaptureLog {
    fn enabled(&self, _metadata: &Metadata<'_>) -> bool {
        true
    }

    fn log(&self, record: &Record<'_>) {
        self.records
            .lock()
            .unwrap_or_else(|poisoned| poisoned.into_inner())
            .push(record.args().to_string());
    }

    fn flush(&self) {}
}

static CAPTURE_LOG: CaptureLog = CaptureLog {
    records: Mutex::new(Vec::new()),
};

/// Owns the process logger until dropped and starts with an empty capture.
pub fn begin_log_capture() -> MutexGuard<'static, ()> {
    let serial = LOG_SERIAL
        .lock()
        .unwrap_or_else(|poisoned| poisoned.into_inner());
    INSTALL_CAPTURE.call_once(|| {
        log::set_logger(&CAPTURE_LOG).expect("the test capture is the process logger");
        log::set_max_level(log::LevelFilter::Warn);
    });
    CAPTURE_LOG
        .records
        .lock()
        .unwrap_or_else(|poisoned| poisoned.into_inner())
        .clear();
    serial
}

pub fn take_log_records() -> Vec<String> {
    std::mem::take(
        &mut *CAPTURE_LOG
            .records
            .lock()
            .unwrap_or_else(|poisoned| poisoned.into_inner()),
    )
}

/// Redirects the process's standard error for one non-panicking operation and returns its bytes.
pub fn capture_stderr<T>(work: impl FnOnce() -> T) -> (T, String) {
    let mut pipe = [0; 2];
    // SAFETY: `pipe` has room for the two descriptors the operating system writes.
    assert_eq!(unsafe { libc::pipe(pipe.as_mut_ptr()) }, 0);
    // SAFETY: duplicating the live standard-error descriptor either returns a descriptor or -1.
    let saved = unsafe { libc::dup(libc::STDERR_FILENO) };
    assert!(saved >= 0);
    // SAFETY: both descriptors are live, and `dup2` makes stderr refer to the pipe writer.
    assert_eq!(
        unsafe { libc::dup2(pipe[1], libc::STDERR_FILENO) },
        libc::STDERR_FILENO
    );
    // SAFETY: stderr now owns a duplicate, so this original writer descriptor can close.
    assert_eq!(unsafe { libc::close(pipe[1]) }, 0);

    let answer = work();

    // SAFETY: flushing all C streams and restoring stderr use live process descriptors.
    unsafe { libc::fflush(std::ptr::null_mut()) };
    assert_eq!(
        unsafe { libc::dup2(saved, libc::STDERR_FILENO) },
        libc::STDERR_FILENO
    );
    // SAFETY: stderr owns the restored duplicate.
    assert_eq!(unsafe { libc::close(saved) }, 0);
    // SAFETY: `pipe[0]` is the only live owner of the read descriptor.
    let mut reader = unsafe { fs::File::from_raw_fd(pipe[0]) };
    let mut stderr = String::new();
    reader
        .read_to_string(&mut stderr)
        .expect("captured stderr is readable UTF-8");
    (answer, stderr)
}

/// A temporary folder under the system temporary directory, removed when dropped. Dropping restores
/// access to every folder inside it first, so a test that set one to mode `000` cannot leave a tree
/// behind that `remove_dir_all` cannot enter.
pub struct TempDir {
    root: PathBuf,
}

impl TempDir {
    pub fn new() -> Self {
        let name = format!(
            "nozoki-bridge-test-{}-{}",
            process::id(),
            NEXT_FOLDER.fetch_add(1, Ordering::Relaxed)
        );
        let root = std::env::temp_dir().join(name);
        fs::create_dir(&root).expect("the temporary folder can be created");
        Self { root }
    }

    pub fn path(&self) -> &Path {
        &self.root
    }

    pub fn make_folder(&self, relative: &str) -> PathBuf {
        let path = self.root.join(relative);
        fs::create_dir_all(&path).expect("the folder can be created");
        path
    }

    /// Creates a file with `contents`, and any missing parent folder.
    pub fn write_file(&self, relative: &str, contents: &str) -> PathBuf {
        let path = self.root.join(relative);
        if let Some(parent) = path.parent() {
            fs::create_dir_all(parent).expect("the parent folder can be created");
        }
        fs::write(&path, contents).expect("the file can be written");
        path
    }

    /// Creates a symlink at `relative` whose target is written exactly as `target`.
    pub fn make_link(&self, relative: &str, target: impl AsRef<Path>) {
        symlink(target, self.root.join(relative)).expect("the symlink can be created");
    }

    /// Copies the committed fixture folder `checks/fixtures/<scene>` to `<root>/<scene>`, keeping
    /// every symlink as a symlink, and returns the copy's path.
    pub fn copy_fixture(&self, scene: &str) -> PathBuf {
        let source = PathBuf::from(env!("CARGO_MANIFEST_DIR"))
            .join("../../checks/fixtures")
            .join(scene);
        let destination = self.root.join(scene);
        copy_keeping_links(&source, &destination);
        destination
    }

    /// Unpacks `checks/fixtures/<archive>` with `tar` into `<root>/<into>`, which must exist.
    pub fn unpack_fixture_archive(&self, archive: &str, into: &str) {
        let archive_path = PathBuf::from(env!("CARGO_MANIFEST_DIR"))
            .join("../../checks/fixtures")
            .join(archive);
        let status = Command::new("tar")
            .arg("-xf")
            .arg(&archive_path)
            .arg("-C")
            .arg(self.root.join(into))
            .status()
            .expect("tar runs");
        assert!(status.success(), "tar unpacked {archive}");
    }

    /// A copy of the `repo` fixture with its `.git` unpacked from `repo.git.tar`: a repository whose
    /// one commit is on `main` and whose tree is clean. Returns the repository's path.
    pub fn repository_copy(&self) -> PathBuf {
        let repository = self.copy_fixture("repo");
        self.unpack_fixture_archive("repo.git.tar", "repo");
        repository
    }

    pub fn set_mode(&self, relative: &str, mode: u32) {
        let path = self.root.join(relative);
        fs::set_permissions(&path, fs::Permissions::from_mode(mode)).expect("the mode can be set");
    }
}

impl Drop for TempDir {
    fn drop(&mut self) {
        restore_access(&self.root);
        // Drop cannot return an error, and a panic here during unwinding would abort the run and
        // hide the failure being reported. A folder left behind is the operating system's to reap.
        fs::remove_dir_all(&self.root).ok();
    }
}

fn copy_keeping_links(source: &Path, destination: &Path) {
    let metadata = fs::symlink_metadata(source).expect("the source can be looked at");
    if metadata.is_symlink() {
        let target = fs::read_link(source).expect("the link can be read");
        symlink(target, destination).expect("the symlink can be copied");
    } else if metadata.is_dir() {
        fs::create_dir(destination).expect("the folder can be created");
        for entry in fs::read_dir(source).expect("the folder can be listed") {
            let entry = entry.expect("the entry can be read");
            copy_keeping_links(&entry.path(), &destination.join(entry.file_name()));
        }
    } else {
        fs::copy(source, destination).expect("the file can be copied");
    }
}

/// A `git` invocation in `dir` that reads no machine-level configuration and runs no hook, so a
/// scene built with it is the same on every machine.
fn git_command(dir: &Path, args: &[&str]) -> Command {
    let mut command = Command::new("git");
    command
        .arg("-C")
        .arg(dir)
        .args([
            "-c",
            "core.hooksPath=/dev/null",
            "-c",
            "commit.gpgsign=false",
            "-c",
            "advice.detachedHead=false",
        ])
        .args(args)
        .env("GIT_CONFIG_GLOBAL", "/dev/null")
        .env("GIT_CONFIG_NOSYSTEM", "1")
        .env("GIT_AUTHOR_NAME", "Scene")
        .env("GIT_AUTHOR_EMAIL", "scene@example.invalid")
        .env("GIT_COMMITTER_NAME", "Scene")
        .env("GIT_COMMITTER_EMAIL", "scene@example.invalid")
        .env("GIT_EDITOR", "true");
    command
}

/// Runs `git args…` in `dir` through [`git_command`] and asserts it succeeded.
pub fn git(dir: &Path, args: &[&str]) {
    let output = git_command(dir, args)
        .output()
        .expect("the git command line runs");
    assert!(
        output.status.success(),
        "git {args:?} failed: {}",
        String::from_utf8_lossy(&output.stderr)
    );
}

fn restore_access(folder: &Path) {
    let Ok(metadata) = fs::symlink_metadata(folder) else {
        return;
    };
    if !metadata.is_dir() {
        return;
    }
    // Best effort by the same reasoning as `drop`: a folder that cannot be restored is left as is.
    fs::set_permissions(folder, fs::Permissions::from_mode(0o700)).ok();
    let Ok(entries) = fs::read_dir(folder) else {
        return;
    };
    for entry in entries.flatten() {
        restore_access(&entry.path());
    }
}
