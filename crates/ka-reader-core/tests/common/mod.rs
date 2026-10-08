//! Test support shared by every test in `ka-reader-core`: a temporary folder built from `std` alone.
//!
//! `tempfile` is not used because it would add a package name to `Cargo.lock`, which QC-26 holds to
//! a reviewed list (`docs/nfdr.md` QC-26), and `std` already covers what a test needs. A helper
//! shared between test files lives in `tests/common/mod.rs` and not `tests/common.rs`, which would
//! become a test crate of its own that reports zero tests
//! (`<CORE>/doctrine/engineering/languages/rust/testing.md`, "Helpers shared between those files").

use std::collections::BTreeMap;
use std::fs;
use std::os::unix::fs::{PermissionsExt, symlink};
use std::path::{Path, PathBuf};
use std::process::{self, Command};
use std::sync::atomic::{AtomicU64, Ordering};

/// One entry of a [`Snapshot`], recorded without following a link.
#[derive(Debug, PartialEq, Eq)]
pub enum SnapshotEntry {
    Folder,
    File(Vec<u8>),
    Link(PathBuf),
    /// An entry that is neither a link, a folder nor a regular file (a FIFO, a socket, a device),
    /// recorded by kind alone: opening a FIFO with no writer blocks forever.
    Other,
}

/// Every entry under a temporary root, keyed by its path relative to that root.
pub type Snapshot = BTreeMap<PathBuf, SnapshotEntry>;

static NEXT_FOLDER: AtomicU64 = AtomicU64::new(0);

/// What follows a scene's name in the file name of its archive under `checks/fixtures/`.
const ARCHIVE_SUFFIX: &str = ".git.tar";

/// One path an archive creates when it is unpacked, relative to the folder it is unpacked into.
struct ArchiveMember {
    path: PathBuf,
    is_folder: bool,
}

impl ArchiveMember {
    /// Whether unpacking creates `relative`: it is this member, or it lies under this member's folder.
    fn creates(&self, relative: &Path) -> bool {
        relative == self.path || (self.is_folder && relative.starts_with(&self.path))
    }
}

/// A temporary folder under the system temporary directory, removed when dropped.
///
/// Its path is canonical, so a test can hand it to code that compares against a canonical root.
/// Dropping restores read and search permission on every folder inside it first, so a test that
/// set a folder to mode `000` cannot leave a tree behind that `remove_dir_all` cannot enter.
pub struct TempDir {
    root: PathBuf,
}

impl TempDir {
    pub fn new() -> Self {
        let name = format!(
            "ka-reader-core-test-{}-{}",
            process::id(),
            NEXT_FOLDER.fetch_add(1, Ordering::Relaxed)
        );
        let unresolved = std::env::temp_dir().join(name);
        fs::create_dir(&unresolved).expect("the temporary folder can be created");
        let root = unresolved
            .canonicalize()
            .expect("the temporary folder can be canonicalized");
        Self { root }
    }

    pub fn path(&self) -> &Path {
        &self.root
    }

    /// Creates `relative` and every missing parent, and returns its absolute path.
    pub fn make_folder(&self, relative: &str) -> PathBuf {
        let path = self.root.join(relative);
        fs::create_dir_all(&path).expect("the folder can be created");
        path
    }

    /// Creates a file with `contents`, and any missing parent folder, and returns its path.
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
        let path = self.root.join(relative);
        if let Some(parent) = path.parent() {
            fs::create_dir_all(parent).expect("the parent folder can be created");
        }
        symlink(target, &path).expect("the symlink can be created");
    }

    /// Copies the committed fixture folder `checks/fixtures/<scene>` to `<root>/<scene>`, keeping
    /// every symlink as a symlink, and returns the copy's path.
    ///
    /// The copy leaves out every path that unpacking `<scene>.git.tar` into the fixture folder
    /// would create, which is where `checks/read-only.sh` unpacks it: a walk leaves those entries
    /// in the folder, and a test then lays the scene down itself with
    /// [`TempDir::unpack_fixture_archive`], so the copy holds the committed files and nothing a run
    /// left behind. A fixture with no archive copies whole.
    pub fn copy_fixture(&self, scene: &str) -> PathBuf {
        let fixtures = PathBuf::from(env!("CARGO_MANIFEST_DIR")).join("../../checks/fixtures");
        let source = fixtures.join(scene);
        let destination = self.root.join(scene);
        let archive_members =
            list_archive_members(&fixtures.join(format!("{scene}{ARCHIVE_SUFFIX}")));
        copy_keeping_links(&source, &destination, Path::new(""), &archive_members);
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

    /// Records every entry under the root by kind, bytes and link target, following no link and
    /// opening nothing that is not a regular file.
    pub fn snapshot(&self) -> Snapshot {
        let mut entries = Snapshot::new();
        record(&self.root, &self.root, &mut entries);
        entries
    }

    /// Panics with `message` when the folder no longer matches `before`, naming each path that was
    /// added, removed or changed rather than printing both snapshots: those carry every `.git`
    /// file's bytes, and a CI log cut off after the first of them never shows what differed.
    pub fn assert_unchanged_since(&self, before: &Snapshot, message: &str) {
        let after = self.snapshot();
        if &after == before {
            return;
        }
        let mut differences = Vec::new();
        for (path, entry) in before {
            match after.get(path) {
                None => {
                    differences.push(format!("removed {} ({})", path.display(), describe(entry)))
                }
                Some(now) if now != entry => differences.push(format!(
                    "changed {} ({} -> {})",
                    path.display(),
                    describe(entry),
                    describe(now)
                )),
                Some(_) => {}
            }
        }
        for (path, entry) in &after {
            if !before.contains_key(path) {
                differences.push(format!("added {} ({})", path.display(), describe(entry)));
            }
        }
        panic!("{message}:\n  {}", differences.join("\n  "));
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

/// The members `tar -tf` lists for `archive`, or none when the scene has no archive.
fn list_archive_members(archive: &Path) -> Vec<ArchiveMember> {
    if !archive.exists() {
        return Vec::new();
    }
    let listing = Command::new("tar")
        .arg("-tf")
        .arg(archive)
        .output()
        .expect("tar runs");
    assert!(listing.status.success(), "tar listed {}", archive.display());
    String::from_utf8_lossy(&listing.stdout)
        .lines()
        .map(|line| {
            let trimmed = line.strip_prefix("./").unwrap_or(line);
            ArchiveMember {
                path: PathBuf::from(trimmed.trim_end_matches('/')),
                is_folder: trimmed.ends_with('/'),
            }
        })
        .collect()
}

/// Copies `source` to `destination`, skipping every path (`relative`, from the scene's root) that
/// `left_out` creates.
fn copy_keeping_links(
    source: &Path,
    destination: &Path,
    relative: &Path,
    left_out: &[ArchiveMember],
) {
    if left_out.iter().any(|member| member.creates(relative)) {
        return;
    }
    let metadata = fs::symlink_metadata(source).expect("the source can be looked at");
    if metadata.is_symlink() {
        let target = fs::read_link(source).expect("the link can be read");
        symlink(target, destination).expect("the symlink can be copied");
    } else if metadata.is_dir() {
        fs::create_dir(destination).expect("the folder can be created");
        for entry in fs::read_dir(source).expect("the folder can be listed") {
            let entry = entry.expect("the entry can be read");
            copy_keeping_links(
                &entry.path(),
                &destination.join(entry.file_name()),
                &relative.join(entry.file_name()),
                left_out,
            );
        }
    } else {
        fs::copy(source, destination).expect("the file can be copied");
    }
}

/// A [`SnapshotEntry`] in a few words: a file by its length, and by its text when it is short.
fn describe(entry: &SnapshotEntry) -> String {
    match entry {
        SnapshotEntry::Folder => "folder".to_string(),
        SnapshotEntry::Link(target) => format!("link to {}", target.display()),
        SnapshotEntry::Other => "other".to_string(),
        SnapshotEntry::File(bytes) if bytes.len() <= 120 => {
            format!(
                "file, {} bytes: {:?}",
                bytes.len(),
                String::from_utf8_lossy(bytes)
            )
        }
        SnapshotEntry::File(bytes) => format!("file, {} bytes", bytes.len()),
    }
}

fn record(root: &Path, folder: &Path, entries: &mut Snapshot) {
    for entry in fs::read_dir(folder).expect("the folder can be listed") {
        let path = entry.expect("the entry can be read").path();
        let relative = path
            .strip_prefix(root)
            .expect("the entry sits under the root")
            .to_path_buf();
        let metadata = fs::symlink_metadata(&path).expect("the entry can be looked at");
        if metadata.is_symlink() {
            let target = fs::read_link(&path).expect("the link can be read");
            entries.insert(relative, SnapshotEntry::Link(target));
        } else if metadata.is_dir() {
            entries.insert(relative, SnapshotEntry::Folder);
            record(root, &path, entries);
        } else if metadata.is_file() {
            let bytes = fs::read(&path).expect("the file can be read");
            entries.insert(relative, SnapshotEntry::File(bytes));
        } else {
            entries.insert(relative, SnapshotEntry::Other);
        }
    }
}
