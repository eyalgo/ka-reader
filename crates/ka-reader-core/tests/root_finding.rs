//! Layer 2: the Git port's `probe` over real folders. Every case takes the port as `&dyn GitPort`
//! from one helper, copies its scene into a temporary root of its own, and checks that the answer
//! carries no path and that nothing under that root changed.

#[allow(
    dead_code,
    reason = "each test crate uses a subset of the shared helpers"
)]
mod common;

use std::fs;
use std::path::{Path, PathBuf};
use std::process::Command;
use std::sync::mpsc;
use std::time::Duration;

use common::{Snapshot, TempDir};
use ka_reader_core::{ConfigNamedPath, GitPort, ProbeCondition, RootFinding};

/// The only place the adapter is named, so a second adapter runs the same cases.
fn port() -> &'static dyn GitPort {
    use ka_reader_core::Libgit2;
    &Libgit2
}

/// CP-491: an answer holds no path, so its text holds no separator, except the config conditions and
/// the object store conditions, which carry the value their repository's own file spells and whose
/// own cases assert that payload; and CP-496: the whole temporary root is what it was before the
/// probe.
fn assert_clean(outcome: &RootFinding, before: &Snapshot, scene: &TempDir) {
    let carries_the_repositorys_words = matches!(
        outcome,
        RootFinding::Failed(
            ProbeCondition::ConfigNamesOutside(_)
                | ProbeCondition::ConfigNotLocated(_)
                | ProbeCondition::ObjectStoreNamesOutside(_)
                | ProbeCondition::ObjectStoreNotLocated(_)
        )
    );
    assert!(
        carries_the_repositorys_words || !format!("{outcome:?}").contains('/'),
        "the answer {outcome:?} holds a path"
    );
    scene.assert_unchanged_since(before, "the probe changed the scene");
}

/// Probes `folder` and returns the answer, after checking the two contracts every case shares.
fn probe_leaving_the_scene_unchanged(scene: &TempDir, folder: &Path) -> RootFinding {
    let before = scene.snapshot();
    let outcome = port().probe(folder);
    assert_clean(&outcome, &before, scene);
    outcome
}

/// A copy of `repo/` with its `.git` unpacked, in a root of its own.
fn repository_scene() -> (TempDir, PathBuf) {
    let scene = TempDir::new();
    let repository = scene.copy_fixture("repo");
    scene.unpack_fixture_archive("repo.git.tar", "repo");
    (scene, repository)
}

/// A scene whose archive plants its own `.git` entries at the root of the copy.
fn archived_scene(name: &str) -> (TempDir, PathBuf) {
    let scene = TempDir::new();
    let folder = scene.copy_fixture(name);
    scene.unpack_fixture_archive(&format!("{name}.git.tar"), ".");
    (scene, folder)
}

/// A copy of the `plain` folder whose `.git` is a regular file holding exactly `contents`.
fn git_file_scene(contents: &[u8]) -> (TempDir, PathBuf) {
    let scene = TempDir::new();
    let folder = scene.copy_fixture("plain");
    fs::write(folder.join(".git"), contents).expect("the .git file can be written");
    (scene, folder)
}

/// Probes a `.git` file holding `contents`, in a scene of its own.
fn probe_git_file(contents: &[u8]) -> RootFinding {
    let (scene, folder) = git_file_scene(contents);
    probe_leaving_the_scene_unchanged(&scene, &folder)
}

fn rewrite_config(repository: &Path, from: &str, to: &str) {
    let config = repository.join(".git/config");
    let text = fs::read_to_string(&config).expect("the config can be read");
    assert!(text.contains(from), "the config holds {from:?}");
    fs::write(&config, text.replace(from, to)).expect("the config can be written");
}

#[test]
fn test_plain_folder_answers_plain() {
    let scene = TempDir::new();
    let folder = scene.copy_fixture("plain");

    assert_eq!(
        probe_leaving_the_scene_unchanged(&scene, &folder),
        RootFinding::Plain
    );
}

#[test]
fn test_repository_top_level_answers_root() {
    let (scene, repository) = repository_scene();

    assert_eq!(
        probe_leaving_the_scene_unchanged(&scene, &repository),
        RootFinding::Root
    );
}

#[test]
fn test_repository_child_answers_plain() {
    let (scene, folder) = archived_scene("inside-a-repo");

    assert_eq!(
        probe_leaving_the_scene_unchanged(&scene, &folder),
        RootFinding::Plain
    );
}

#[test]
fn test_parent_of_repositories_answers_plain() {
    let (scene, folder) = archived_scene("parent-of-two");

    assert_eq!(
        probe_leaving_the_scene_unchanged(&scene, &folder),
        RootFinding::Plain
    );
}

#[test]
fn test_bare_repository_answers_plain() {
    let scene = TempDir::new();
    scene.make_folder("stage");
    scene.unpack_fixture_archive("repo.git.tar", "stage");
    let bare = scene.path().join("bare.git");
    fs::rename(scene.path().join("stage/.git"), &bare).expect("the git folder can be moved");
    let config = bare.join("config");
    let text = fs::read_to_string(&config).expect("the config can be read");
    fs::write(&config, text.replace("bare = false", "bare = true")).expect("the config is written");

    assert_eq!(
        probe_leaving_the_scene_unchanged(&scene, &bare),
        RootFinding::Plain
    );
}

#[test]
fn test_git_directory_opened_directly_answers_plain() {
    let (scene, repository) = repository_scene();

    assert_eq!(
        probe_leaving_the_scene_unchanged(&scene, &repository.join(".git")),
        RootFinding::Plain
    );
}

/// CP-493's `.git` opened directly, holding a `.git` folder of its own: Git, told not to search,
/// takes the opened folder itself as the Git directory, whose working tree is the folder above.
#[test]
fn test_git_directory_opened_directly_holding_a_git_folder_answers_plain() {
    let (scene, repository) = repository_scene();
    scene.make_folder("repo/.git/.git");

    assert_eq!(
        probe_leaving_the_scene_unchanged(&scene, &repository.join(".git")),
        RootFinding::Plain
    );
}

#[test]
fn test_unreadable_git_directory_reports_condition() {
    let (scene, repository) = repository_scene();
    let before = scene.snapshot();
    scene.set_mode("repo/.git", 0o000);

    let outcome = port().probe(&repository);
    scene.set_mode("repo/.git", 0o755);

    assert_eq!(
        outcome,
        RootFinding::Failed(ProbeCondition::GitDirectoryUnreadable)
    );
    assert_clean(&outcome, &before, &scene);
}

#[test]
fn test_linked_worktree_answers_root() {
    let (scene, folder) = archived_scene("linked-worktree");

    assert_eq!(
        probe_leaving_the_scene_unchanged(&scene, &folder),
        RootFinding::Root
    );
}

#[test]
fn test_submodule_answers_root() {
    let (scene, folder) = archived_scene("submodule");

    assert_eq!(
        probe_leaving_the_scene_unchanged(&scene, &folder),
        RootFinding::Root
    );
}

/// QC-5: the file's pointer is never followed, so a target that does not exist changes nothing.
#[test]
fn test_git_file_naming_a_missing_git_directory_answers_root() {
    assert_eq!(
        probe_git_file(b"gitdir: ../nowhere/.git\n"),
        RootFinding::Root
    );
}

#[test]
fn test_git_file_with_an_absolute_outside_path_answers_root() {
    assert_eq!(
        probe_git_file(b"gitdir: /nonexistent/x\n"),
        RootFinding::Root
    );
}

#[test]
fn test_git_file_naming_an_unreadable_folder_answers_root() {
    let (scene, folder) = git_file_scene(b"gitdir: ../sibling\n");
    scene.make_folder("sibling");
    let before = scene.snapshot();
    scene.set_mode("sibling", 0o000);

    let outcome = port().probe(&folder);
    scene.set_mode("sibling", 0o755);

    assert_eq!(outcome, RootFinding::Root);
    assert_clean(&outcome, &before, &scene);
}

/// The three line shapes of the examples: no space after the colon, a CRLF ending, and a second
/// line after the first.
#[test]
fn test_gitdir_line_shapes_answer_root() {
    for contents in [
        &b"gitdir:../nowhere\n"[..],
        b"gitdir: ../nowhere\r\n",
        b"gitdir: ../a\nsecond\n",
    ] {
        assert_eq!(probe_git_file(contents), RootFinding::Root, "{contents:?}");
    }
}

#[test]
fn test_gitdir_content_need_not_be_utf8() {
    assert_eq!(probe_git_file(b"gitdir: \xFF\xFE\n"), RootFinding::Root);
}

/// CP-502: a target inside the opened folder that is not a Git directory is still not opened.
#[test]
fn test_gitdir_target_inside_the_folder_answers_root() {
    let (scene, folder) = git_file_scene(b"gitdir: inner\n");
    scene.make_folder("plain/inner");

    assert_eq!(
        probe_leaving_the_scene_unchanged(&scene, &folder),
        RootFinding::Root
    );
}

/// Red on a reader that stops after a fixed window: the one non-whitespace byte comes after 64 KiB.
#[test]
fn test_gitdir_after_a_long_run_of_whitespace_answers_root() {
    let mut padded = b"gitdir:".to_vec();
    padded.extend(b" \n".repeat(32 * 1024));
    let without_a_target = padded.clone();
    padded.push(b'a');

    assert_eq!(probe_git_file(&padded), RootFinding::Root);
    assert_eq!(probe_git_file(&without_a_target), RootFinding::Plain);
}

#[test]
fn test_gitdir_single_non_whitespace_byte_at_end_of_file_answers_root() {
    assert_eq!(probe_git_file(b"gitdir:x"), RootFinding::Root);
}

/// CP-501: seven contents that are not a `gitdir:` line, one scene each.
#[test]
fn test_non_gitdir_git_file_contents_answer_plain() {
    for contents in [
        &b"gitdir:\n"[..],
        b"gitdir:    \n",
        b" gitdir: ../a\n",
        b"GITDIR: ../a\n",
        b"",
        b"hello\n",
        b"x\ngitdir: ../a\n",
    ] {
        assert_eq!(probe_git_file(contents), RootFinding::Plain, "{contents:?}");
    }
}

/// The six bytes C `isspace` names. The vertical tab is the member `u8::is_ascii_whitespace` leaves
/// out, so it is the one that locks the whole set.
#[test]
fn test_gitdir_followed_only_by_each_whitespace_byte_answers_plain() {
    for whitespace in [0x20_u8, 0x09, 0x0A, 0x0B, 0x0C, 0x0D] {
        let mut contents = b"gitdir:".to_vec();
        contents.push(whitespace);
        assert_eq!(
            probe_git_file(&contents),
            RootFinding::Plain,
            "followed by {whitespace:#04x}"
        );
    }
}

/// The set is closed at six: a byte beside a member, a control byte, and the two bytes a Unicode or
/// Latin-1 reading of a byte calls whitespace (NEL, no-break space) are not whitespace, so each one
/// alone after the prefix is a `gitdir:` line. The answer does not vary with a locale.
#[test]
fn test_gitdir_followed_by_a_byte_outside_the_whitespace_set_answers_root() {
    for outside in [
        0x00_u8, 0x08, 0x0E, 0x1C, 0x1F, 0x21, 0x7F, 0x85, 0xA0, 0xFF,
    ] {
        let mut contents = b"gitdir:".to_vec();
        contents.push(outside);
        assert_eq!(
            probe_git_file(&contents),
            RootFinding::Root,
            "followed by {outside:#04x}"
        );
    }
}

#[test]
fn test_byte_order_mark_before_the_prefix_answers_plain() {
    assert_eq!(
        probe_git_file(b"\xEF\xBB\xBFgitdir: ../a\n"),
        RootFinding::Plain
    );
}

#[test]
fn test_git_file_shorter_than_the_prefix_answers_plain() {
    assert_eq!(probe_git_file(b"gitdir"), RootFinding::Plain);
}

#[test]
fn test_git_file_holding_exactly_the_prefix_answers_plain() {
    assert_eq!(probe_git_file(b"gitdir:"), RootFinding::Plain);
}

#[test]
fn test_unreadable_git_file_reports_condition() {
    let (scene, folder) = git_file_scene(b"gitdir: ../a\n");
    let before = scene.snapshot();
    scene.set_mode("plain/.git", 0o000);

    let outcome = port().probe(&folder);
    scene.set_mode("plain/.git", 0o644);

    assert_eq!(
        outcome,
        RootFinding::Failed(ProbeCondition::GitFileUnreadable)
    );
    assert_clean(&outcome, &before, &scene);
}

/// A link to a file holding a `gitdir:` line is not followed: the answer is for the link itself.
/// Holds at the base, and guards the else-branch of the three-way split.
#[test]
fn test_symbolic_git_entry_to_a_gitdir_file_reports_condition() {
    let scene = TempDir::new();
    let folder = scene.copy_fixture("plain");
    scene.write_file("gitfile", "gitdir: ../a\n");
    scene.make_link("plain/.git", "../gitfile");

    assert_eq!(
        probe_leaving_the_scene_unchanged(&scene, &folder),
        RootFinding::Failed(ProbeCondition::GitEntryNotDirectory)
    );
}

/// A FIFO with no writer: an open that blocks would hang here, so the probe runs on its own thread
/// and the case waits on a channel. Holds at the base, and guards the else-branch.
#[test]
fn test_fifo_git_entry_reports_condition_and_returns() {
    let scene = TempDir::new();
    let folder = scene.copy_fixture("plain");
    let status = Command::new("mkfifo")
        .arg(folder.join(".git"))
        .status()
        .expect("mkfifo runs");
    assert!(status.success(), "mkfifo made the FIFO");
    let before = scene.snapshot();
    let (sender, receiver) = mpsc::channel();
    let probed = folder.clone();
    std::thread::spawn(move || {
        sender.send(port().probe(&probed)).ok();
    });

    let outcome = receiver
        .recv_timeout(Duration::from_secs(10))
        .expect("the probe returned instead of blocking on the FIFO");

    assert_eq!(
        outcome,
        RootFinding::Failed(ProbeCondition::GitEntryNotDirectory)
    );
    assert_clean(&outcome, &before, &scene);
}

#[test]
fn test_missing_folder_reports_condition() {
    let scene = TempDir::new();

    assert_eq!(
        probe_leaving_the_scene_unchanged(&scene, &scene.path().join("missing")),
        RootFinding::Failed(ProbeCondition::FolderUnavailable)
    );
}

#[test]
fn test_file_instead_of_folder_reports_condition() {
    let scene = TempDir::new();
    let file = scene.write_file("notes.txt", "not a folder\n");

    assert_eq!(
        probe_leaving_the_scene_unchanged(&scene, &file),
        RootFinding::Failed(ProbeCondition::FolderUnavailable)
    );
}

/// The discovery witness: with discovery on, the open would walk up to the copy root's repository.
#[test]
fn test_empty_git_directory_inside_repository_does_not_discover_parent() {
    let (scene, folder) = archived_scene("inside-a-repo");
    scene.make_folder("inside-a-repo/.git");

    assert_eq!(
        probe_leaving_the_scene_unchanged(&scene, &folder),
        RootFinding::Plain
    );
}

/// The link points at real Git metadata elsewhere in the root, so the scene is one a probe that
/// followed it could read and change; a dangling link would prove nothing about that.
#[test]
fn test_symbolic_git_entry_leaves_the_scene_unchanged() {
    let (scene, repository) = repository_scene();
    let folder = scene.copy_fixture("plain");
    scene.make_link("plain/.git", "../repo/.git");
    assert_eq!(
        folder
            .join(".git")
            .canonicalize()
            .expect("the link resolves"),
        repository.join(".git"),
        "the link points at the repository's Git metadata"
    );

    assert_eq!(
        probe_leaving_the_scene_unchanged(&scene, &folder),
        RootFinding::Failed(ProbeCondition::GitEntryNotDirectory)
    );
}

/// A `.git` folder that can be read and holds a `HEAD` but not a repository's layout is CP-493's
/// readable non-repository: `Plain`, not the unreadable condition.
#[test]
fn test_readable_git_directory_that_is_not_a_repository_answers_plain() {
    let scene = TempDir::new();
    let folder = scene.copy_fixture("plain");
    scene.write_file("plain/.git/HEAD", "ref: refs/heads/main\n");

    assert_eq!(
        probe_leaving_the_scene_unchanged(&scene, &folder),
        RootFinding::Plain
    );
}

/// The folder can be looked at but not searched, so its `.git` entry cannot be: a condition, never
/// `Plain`, although a repository sits behind it.
#[test]
fn test_folder_that_cannot_be_searched_reports_condition() {
    let (scene, repository) = repository_scene();
    let before = scene.snapshot();
    scene.set_mode("repo", 0o000);

    let outcome = port().probe(&repository);
    scene.set_mode("repo", 0o755);

    assert_eq!(
        outcome,
        RootFinding::Failed(ProbeCondition::FolderUnavailable)
    );
    assert_clean(&outcome, &before, &scene);
}

#[test]
fn test_invalid_git_config_reports_observed_failure() {
    let (scene, repository) = repository_scene();
    fs::write(
        repository.join(".git/config"),
        "[core\n\tbare = = nonsense\n",
    )
    .expect("the config can be written");

    assert_eq!(
        probe_leaving_the_scene_unchanged(&scene, &repository),
        RootFinding::Failed(ProbeCondition::RepositoryReadFailed)
    );
}

#[test]
fn test_bare_config_at_folder_root_answers_plain() {
    let (scene, repository) = repository_scene();
    rewrite_config(&repository, "bare = false", "bare = true");

    assert_eq!(
        probe_leaving_the_scene_unchanged(&scene, &repository),
        RootFinding::Plain
    );
}

/// A `core.worktree` that spells outside the folder is refused before the open, with the config
/// condition (SDD § 11 R-16, *The spellings*): it is spelled from the Git directory, so
/// `../../elsewhere` from `.git/` lies beside the folder.
#[test]
fn test_worktree_elsewhere_answers_the_config_condition() {
    let (scene, repository) = repository_scene();
    scene.make_folder("elsewhere");
    rewrite_config(
        &repository,
        "bare = false",
        "bare = false\n\tworktree = ../../elsewhere",
    );

    assert_eq!(
        probe_leaving_the_scene_unchanged(&scene, &repository),
        RootFinding::Failed(ProbeCondition::ConfigNamesOutside(ConfigNamedPath {
            key: "core.worktree".to_string(),
            path: "../../elsewhere".to_string(),
        }))
    );
}

/// The same root spelled with a `.` component, with a trailing separator, and relative to the
/// working directory, which the test leaves alone.
#[test]
fn test_root_finding_is_independent_of_folder_spelling() {
    let (scene, repository) = repository_scene();
    let with_dot = repository.join(".");
    let with_separator = PathBuf::from(format!("{}/", repository.display()));
    let working_directory = std::env::current_dir().expect("the working directory is known");
    let depth = working_directory.components().count() - 1;
    let relative: PathBuf = std::iter::repeat_n("..", depth)
        .map(PathBuf::from)
        .chain(repository.strip_prefix("/").map(Path::to_path_buf))
        .collect();

    for spelling in [with_dot, with_separator, relative] {
        assert_eq!(
            probe_leaving_the_scene_unchanged(&scene, &spelling),
            RootFinding::Root,
            "spelled {spelling:?}"
        );
    }
}
