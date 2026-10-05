use std::io::{self, Read};
use std::path::{Path, PathBuf};

use crate::test_support::TempDir;

use super::{
    Bounds, GitReadCondition, Inspected, Locations, MAX_LINK_HOPS, check_config, lies_inside,
    names_a_git_directory, spell_location, verify_submodules,
};

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

fn bounds(include_depth: usize, submodule_depth: usize) -> Bounds {
    Bounds {
        include_depth,
        submodule_depth,
    }
}

/// A repository folder `S` in a scene, with the Git directory `S/.git` and nothing in it yet.
fn folder_with_a_git_directory() -> (TempDir, PathBuf, Locations) {
    let scene = TempDir::new();
    let root = scene.make_folder("S");
    scene.make_folder("S/.git");
    let locations = Locations {
        git_directory: root.join(".git"),
        common_directory: root.join(".git"),
    };
    (scene, root, locations)
}

/// `.git/config` includes `f1`, which includes `f2`, which includes `f3`, which holds no
/// include. The config is depth 0 and each include one deeper, as libgit2 counts.
fn chain_of_includes() -> (TempDir, PathBuf, Locations) {
    let (scene, root, locations) = folder_with_a_git_directory();
    scene.write_file("S/.git/config", "[include]\n\tpath = f1\n");
    scene.write_file("S/.git/f1", "[include]\n\tpath = f2\n");
    scene.write_file("S/.git/f2", "[include]\n\tpath = f3\n");
    scene.write_file("S/.git/f3", "[user]\n\tname = Someone\n");
    (scene, root, locations)
}

#[test]
fn test_an_include_chain_to_the_bound_is_read_and_one_over_it_is_refused() {
    let (_scene, root, locations) = chain_of_includes();

    assert_eq!(check_config(&root, &locations, &bounds(4, 10)), Ok(()));
    assert_eq!(
        check_config(&root, &locations, &bounds(3, 10)),
        Err(GitReadCondition::RepositoryReadFailed)
    );
}

#[test]
fn test_an_absent_include_at_the_bound_is_no_refusal() {
    let (_scene, root, locations) = chain_of_includes();
    std::fs::remove_file(root.join(".git/f3")).expect("the file goes");

    assert_eq!(check_config(&root, &locations, &bounds(3, 10)), Ok(()));
}

#[test]
fn test_an_include_cycle_is_refused_at_the_bound() {
    let (scene, root, locations) = folder_with_a_git_directory();
    scene.write_file("S/.git/config", "[include]\n\tpath = config\n");

    assert_eq!(
        check_config(&root, &locations, &bounds(10, 10)),
        Err(GitReadCondition::RepositoryReadFailed)
    );
}

#[test]
fn test_a_link_chain_over_the_hop_bound_at_an_includes_spelling_is_refused() {
    let (scene, root, locations) = folder_with_a_git_directory();
    scene.write_file("S/.git/config", "[include]\n\tpath = l0\n");
    let hops = MAX_LINK_HOPS + 8;
    for number in 0..hops {
        scene.make_link(&format!("S/.git/l{number}"), format!("l{}", number + 1));
    }
    scene.write_file(&format!("S/.git/l{hops}"), "[user]\n\tname = Someone\n");

    assert_eq!(
        check_config(&root, &locations, &bounds(10, 10)),
        Err(GitReadCondition::RepositoryReadFailed)
    );
}

#[test]
fn test_a_config_that_includes_the_git_directory_itself_is_unreadable() {
    let (scene, root, locations) = folder_with_a_git_directory();
    scene.write_file("S/.git/config", "[include]\n\tpath =\n");

    assert_eq!(
        check_config(&root, &locations, &bounds(10, 10)),
        Err(GitReadCondition::GitDirectoryUnreadable)
    );
}

#[test]
fn test_a_link_at_the_config_itself_is_unreadable_and_a_fifo_never_blocks() {
    let (scene, root, locations) = folder_with_a_git_directory();
    scene.write_file("S/.git/real", "[user]\n\tname = Someone\n");
    scene.make_link("S/.git/config", "real");
    assert_eq!(
        check_config(&root, &locations, &bounds(10, 10)),
        Err(GitReadCondition::GitDirectoryUnreadable)
    );

    let (_scene, root, locations) = folder_with_a_git_directory();
    let status = std::process::Command::new("mkfifo")
        .arg(root.join(".git/config"))
        .status()
        .expect("mkfifo runs");
    assert!(status.success());
    assert_eq!(
        check_config(&root, &locations, &bounds(10, 10)),
        Err(GitReadCondition::GitDirectoryUnreadable)
    );
}

#[test]
fn test_a_missing_config_is_no_refusal() {
    let (_scene, root, locations) = folder_with_a_git_directory();

    assert_eq!(check_config(&root, &locations, &bounds(10, 10)), Ok(()));
}

/// A repository at `S` whose index holds one gitlink, `sub`, and a repository of its own at
/// `S/sub`.
fn repository_with_one_submodule() -> (TempDir, PathBuf, git2::Repository) {
    let scene = TempDir::new();
    let root = scene.make_folder("S");
    let repository = git2::Repository::init(&root).expect("the repository is made");
    git2::Repository::init(root.join("sub")).expect("the submodule is made");
    let mut index = repository.index().expect("the index opens");
    let gitlink = git2::IndexEntry {
        ctime: git2::IndexTime::new(0, 0),
        mtime: git2::IndexTime::new(0, 0),
        dev: 0,
        ino: 0,
        mode: 0o160_000,
        uid: 0,
        gid: 0,
        file_size: 0,
        id: git2::Oid::from_bytes(&[1; 20]).expect("an id"),
        flags: 0,
        flags_extended: 0,
        path: b"sub".to_vec(),
    };
    index.add(&gitlink).expect("the gitlink is added");
    index.write().expect("the index is written");
    (scene, root, repository)
}

#[test]
fn test_submodule_nesting_to_the_bound_is_verified_and_one_over_it_is_refused() {
    let (_scene, root, repository) = repository_with_one_submodule();

    assert_eq!(
        verify_submodules(&root, &repository, &root, 0, &bounds(10, 1)),
        Ok(())
    );
    assert_eq!(
        verify_submodules(&root, &repository, &root, 0, &bounds(10, 0)),
        Err(GitReadCondition::RepositoryReadFailed)
    );
}

#[test]
fn test_a_gitlink_whose_folder_holds_no_git_entry_is_skipped() {
    let (_scene, root, repository) = repository_with_one_submodule();
    std::fs::remove_dir_all(root.join("sub/.git")).expect("the entry goes");

    assert_eq!(
        verify_submodules(&root, &repository, &root, 0, &bounds(10, 0)),
        Ok(())
    );
}
