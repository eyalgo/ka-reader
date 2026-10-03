//! Layer 2: the Git port's `probe` over real folders. Every case takes the port as `&dyn GitPort`
//! from one helper, copies its scene into a temporary root of its own, and checks that the answer
//! carries no path and that nothing under that root changed.

mod common;

use std::fs;
use std::path::{Path, PathBuf};

use common::{Snapshot, TempDir};
use nozoki_core::{GitPort, ProbeCondition, RootFinding};

/// The only place the adapter is named, so a second adapter runs the same cases.
fn port() -> &'static dyn GitPort {
    use nozoki_core::Libgit2;
    &Libgit2
}

/// CP-491: an answer holds no path, so its text holds no separator; and CP-496: the whole
/// temporary root is what it was before the probe.
fn assert_clean(outcome: &RootFinding, before: &Snapshot, scene: &TempDir) {
    assert!(
        !format!("{outcome:?}").contains('/'),
        "the answer {outcome:?} holds a path"
    );
    assert_eq!(&scene.snapshot(), before, "the probe changed the scene");
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
fn test_linked_worktree_leaves_the_scene_unchanged() {
    let (scene, folder) = archived_scene("linked-worktree");

    probe_leaving_the_scene_unchanged(&scene, &folder);
}

#[test]
fn test_submodule_leaves_the_scene_unchanged() {
    let (scene, folder) = archived_scene("submodule");

    probe_leaving_the_scene_unchanged(&scene, &folder);
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

#[test]
fn test_symbolic_git_entry_leaves_the_scene_unchanged() {
    let (scene, _) = repository_scene();
    let folder = scene.copy_fixture("plain");
    scene.make_link("plain/.git", "repo/.git");

    probe_leaving_the_scene_unchanged(&scene, &folder);
}

#[test]
fn test_invalid_git_config_reports_observed_failure() {
    let (scene, repository) = repository_scene();
    fs::write(repository.join(".git/config"), "[core\n\tbare = = nonsense\n")
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

#[test]
fn test_worktree_elsewhere_answers_plain() {
    let (scene, repository) = repository_scene();
    scene.make_folder("elsewhere");
    rewrite_config(
        &repository,
        "bare = false",
        "bare = false\n\tworktree = ../../elsewhere",
    );

    assert_eq!(
        probe_leaving_the_scene_unchanged(&scene, &repository),
        RootFinding::Plain
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
