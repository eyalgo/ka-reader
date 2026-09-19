//! Test support for `nozoki-app`'s unit tests: a temporary folder built from `std` alone. It lives
//! under `tests/common/` and not `src/`, so the production source names no `std::fs`; the unit tests
//! include it through `#[path]` (see `lib.rs`).
//!
//! `tempfile` is not used because it would add a package name to `Cargo.lock`, and QC-26 lets this
//! change add exactly one (`rfd`).

use std::fs;
use std::os::unix::fs::{PermissionsExt, symlink};
use std::path::{Path, PathBuf};
use std::process;
use std::sync::atomic::{AtomicU64, Ordering};

static NEXT_FOLDER: AtomicU64 = AtomicU64::new(0);

/// A temporary folder under the system temporary directory, removed when dropped. Dropping restores
/// access to every folder inside it first, so a test that set one to mode `000` cannot leave a tree
/// behind that `remove_dir_all` cannot enter.
pub struct TempDir {
    root: PathBuf,
}

impl TempDir {
    pub fn new() -> Self {
        let name = format!(
            "nozoki-app-test-{}-{}",
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
