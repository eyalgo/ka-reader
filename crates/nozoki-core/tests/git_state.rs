//! Layer 2: the Git port's `state()` and `status()` over real folders. Every adapter case takes the
//! port as `&dyn GitPort` from one helper, builds its scene in a canonical temporary root with the
//! `git` command line, snapshots the whole root (`.git/index` included) before and after, and
//! checks that no failure other than the outside one holds a path.

#[allow(
    dead_code,
    reason = "each test crate uses a subset of the shared helpers"
)]
mod common;

use std::ffi::OsStr;
use std::fs;
use std::os::unix::ffi::OsStrExt;
use std::path::{Path, PathBuf};
use std::process::Command;
use std::sync::mpsc;
use std::time::{Duration, Instant};

use common::{Snapshot, TempDir};
use std::cell::Cell;

use nozoki_core::{
    BranchElement, ConfigNamedPath, FolderKind, FolderModel, GitCondition, GitPort,
    GitReadCondition, HeadState, ItemState, ProbeCondition, RepositoryState, RootFinding,
    StatusCategory, StatusEntry, StatusLists, open_folder, read_git,
};

/// The only place the adapter is named, so a second adapter runs the same cases.
fn port() -> &'static dyn GitPort {
    use nozoki_core::Libgit2;
    &Libgit2
}

/// A `git` invocation in `dir` that reads no machine-level configuration and runs no hook.
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

fn git(dir: &Path, args: &[&str]) {
    let output = git_command(dir, args)
        .output()
        .expect("the git command line runs");
    assert!(
        output.status.success(),
        "git {args:?} failed: {}",
        String::from_utf8_lossy(&output.stderr)
    );
}

/// A command that is meant to stop partway (a conflict, a patch that does not apply).
fn git_that_stops(dir: &Path, args: &[&str]) {
    let output = git_command(dir, args)
        .output()
        .expect("the git command line runs");
    assert!(
        !output.status.success(),
        "git {args:?} was expected to stop partway"
    );
}

fn git_output(dir: &Path, args: &[&str]) -> String {
    let output = git_command(dir, args)
        .output()
        .expect("the git command line runs");
    assert!(output.status.success(), "git {args:?} failed");
    String::from_utf8(output.stdout)
        .expect("git printed UTF-8")
        .trim()
        .to_string()
}

fn commit_all(dir: &Path, message: &str) {
    git(dir, &["add", "-A"]);
    git(dir, &["commit", "-m", message]);
}

fn head_id(dir: &Path) -> String {
    git_output(dir, &["rev-parse", "HEAD"])
}

/// An empty repository on `main`, in a folder named `S` inside a scene of its own.
fn new_repository() -> (TempDir, PathBuf) {
    let scene = TempDir::new();
    let root = scene.make_folder("S");
    git(&root, &["init", "-q", "-b", "main"]);
    (scene, root)
}

/// `main` and `other` each changed `a.txt` from the same base, so combining them conflicts. HEAD is
/// on `main`.
fn diverged_repository() -> (TempDir, PathBuf) {
    let (scene, root) = new_repository();
    fs::write(root.join("a.txt"), "base\n").expect("the file is written");
    commit_all(&root, "base");
    git(&root, &["checkout", "-q", "-b", "other"]);
    fs::write(root.join("a.txt"), "other\n").expect("the file is written");
    commit_all(&root, "other");
    git(&root, &["checkout", "-q", "main"]);
    fs::write(root.join("a.txt"), "main\n").expect("the file is written");
    commit_all(&root, "main");
    (scene, root)
}

/// Three commits on `main`, each changing `a.txt`.
fn linear_repository() -> (TempDir, PathBuf) {
    let (scene, root) = new_repository();
    for (number, message) in [("1", "first"), ("2", "second"), ("3", "third")] {
        fs::write(root.join("a.txt"), format!("{number}\n")).expect("the file is written");
        commit_all(&root, message);
    }
    (scene, root)
}

/// One commit holding `a.txt`, `b.txt` and `c.txt`, on `main`.
fn committed_files_repository() -> (TempDir, PathBuf) {
    let (scene, root) = new_repository();
    for name in ["a.txt", "b.txt", "c.txt"] {
        fs::write(root.join(name), format!("{name}\n")).expect("the file is written");
    }
    commit_all(&root, "files");
    (scene, root)
}

/// Both answers for `root`, after checking the folder is what `before` recorded.
fn read_against(before: &Snapshot, scene: &TempDir, root: &Path) -> Answers {
    let state = port().state(root);
    let status = port().status(root);
    assert_eq!(&scene.snapshot(), before, "a read changed the scene");
    Answers { state, status }
}

/// Reads `root` and checks the whole scene is what it was before.
fn read(scene: &TempDir, root: &Path) -> Answers {
    read_against(&scene.snapshot(), scene, root)
}

struct Answers {
    state: Result<HeadState, GitReadCondition>,
    status: Result<StatusLists, GitReadCondition>,
}

impl Answers {
    fn head(&self) -> &HeadState {
        self.state.as_ref().expect("state() answers a state")
    }

    fn lists(&self) -> &StatusLists {
        self.status.as_ref().expect("status() answers lists")
    }

    /// Both calls answer the same failure, and returns it.
    fn failure(&self) -> &GitReadCondition {
        let from_state = self.state.as_ref().expect_err("state() answers a failure");
        let from_status = self
            .status
            .as_ref()
            .expect_err("status() answers a failure");
        assert_eq!(from_state, from_status, "the two calls refuse alike");
        from_state
    }
}

fn entry(path: &str, category: StatusCategory) -> StatusEntry {
    StatusEntry {
        path: path.to_string(),
        category,
    }
}

fn sorted(mut entries: Vec<StatusEntry>) -> Vec<StatusEntry> {
    entries.sort_by_key(|entry| format!("{}|{:?}", entry.path, entry.category));
    entries
}

/// The lists are compared as sets: no order is promised.
fn assert_lists(answers: &Answers, staged: Vec<StatusEntry>, changed: Vec<StatusEntry>) {
    let lists = answers.lists();
    assert_eq!(sorted(lists.staged.clone()), sorted(staged), "staged");
    assert_eq!(sorted(lists.changed.clone()), sorted(changed), "changed");
}

fn assert_head(answers: &Answers, branch: BranchElement, state: RepositoryState) {
    assert_eq!(
        answers.head(),
        &HeadState { branch, state },
        "the branch element and the repository's state"
    );
}

fn on_branch(name: &str) -> BranchElement {
    BranchElement::Branch(name.to_string())
}

fn detached_at(id: String) -> BranchElement {
    BranchElement::Detached(id)
}

/// CP-521: a failure other than the outside one and the config one holds no path, so its text holds
/// no separator. The config one carries the key and the value its config spells, and holds a
/// separator whenever that value does.
fn assert_pathless(condition: &GitReadCondition) {
    assert!(
        !format!("{condition:?}").contains('/'),
        "the failure {condition:?} holds a path"
    );
}

/// A copy of the `repo` fixture with its `.git` unpacked, in a root of its own.
fn fixture_repository() -> (TempDir, PathBuf) {
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

/// `S` holds a `.git` file whose whole content is `contents`.
fn git_file_scene(contents: &str) -> (TempDir, PathBuf) {
    let scene = TempDir::new();
    let root = scene.make_folder("S");
    scene.write_file("S/.git", contents);
    (scene, root)
}

/// `S` holds a whole repository's Git directory under the name `relocated`, found through a `.git`
/// file that says `gitdir: <value>`.
fn relocated_repository(value: &str, relocated: &str) -> (TempDir, PathBuf) {
    let (scene, root) = new_repository();
    fs::write(root.join("a.txt"), "a\n").expect("the file is written");
    commit_all(&root, "first");
    fs::rename(root.join(".git"), root.join(relocated)).expect("the Git directory moves");
    scene.write_file("S/.git", &format!("gitdir: {value}\n"));
    (scene, root)
}

// --- state and status -------------------------------------------------------------------------

#[test]
fn test_branch_normal_and_lists_match_e1() {
    let (scene, root) = committed_files_repository();
    git(&root, &["checkout", "-q", "-b", "feature"]);
    fs::write(root.join("a.txt"), "staged\n").expect("the file is written");
    git(&root, &["add", "a.txt"]);
    fs::write(root.join("a.txt"), "changed again\n").expect("the file is written");
    git(&root, &["mv", "b.txt", "b-renamed.txt"]);
    fs::remove_file(root.join("c.txt")).expect("the file is removed");
    fs::write(root.join("new.txt"), "new\n").expect("the file is written");
    git(&root, &["add", "new.txt"]);
    scene.write_file("S/ud/deep/u.txt", "u\n");
    scene.write_file("S/untracked.txt", "u\n");

    let answers = read(&scene, &root);

    assert_head(&answers, on_branch("feature"), RepositoryState::Normal);
    assert_lists(
        &answers,
        vec![
            entry("a.txt", StatusCategory::Modified),
            entry(
                "b-renamed.txt",
                StatusCategory::Renamed {
                    from: "b.txt".to_string(),
                },
            ),
            entry("new.txt", StatusCategory::Added),
        ],
        vec![
            entry("a.txt", StatusCategory::Modified),
            entry("c.txt", StatusCategory::Deleted),
            entry("ud/deep/u.txt", StatusCategory::Untracked),
            entry("untracked.txt", StatusCategory::Untracked),
        ],
    );
}

#[test]
fn test_merge_conflict_is_changed_only() {
    let (scene, root) = diverged_repository();
    git_that_stops(&root, &["merge", "other"]);

    let answers = read(&scene, &root);

    assert_head(&answers, on_branch("main"), RepositoryState::Merge);
    assert_lists(
        &answers,
        vec![],
        vec![entry("a.txt", StatusCategory::InConflict)],
    );
}

#[test]
fn test_rebase_conflict_is_detached_rebase() {
    let (scene, root) = diverged_repository();
    git(&root, &["checkout", "-q", "other"]);
    git_that_stops(&root, &["rebase", "main"]);

    let answers = read(&scene, &root);

    assert_head(
        &answers,
        detached_at(head_id(&root)),
        RepositoryState::Rebase,
    );
    assert_lists(
        &answers,
        vec![],
        vec![entry("a.txt", StatusCategory::InConflict)],
    );
}

#[test]
fn test_rebase_apply_and_interactive_edit_stop_are_rebase() {
    let (scene, root) = diverged_repository();
    git(&root, &["checkout", "-q", "other"]);
    git_that_stops(&root, &["rebase", "--apply", "main"]);
    let answers = read(&scene, &root);
    assert_head(
        &answers,
        detached_at(head_id(&root)),
        RepositoryState::Rebase,
    );

    let (scene, root) = linear_repository();
    let stopped_at_edit = git_command(&root, &["rebase", "-i", "HEAD~1"])
        .env("GIT_SEQUENCE_EDITOR", "sed -i.bak -e '1s/^pick/edit/'")
        .output()
        .expect("the git command line runs");
    assert!(stopped_at_edit.status.success(), "the edit step stops");
    // The editor's backup is the scene's own, so it is gone before the read is judged.
    for backup in fs::read_dir(root.join(".git/rebase-merge"))
        .expect("the rebase is in progress")
        .flatten()
        .filter(|found| found.file_name().as_bytes().ends_with(b".bak"))
    {
        fs::remove_file(backup.path()).expect("the backup is removed");
    }
    let answers = read(&scene, &root);
    assert_head(
        &answers,
        detached_at(head_id(&root)),
        RepositoryState::Rebase,
    );
    assert_lists(&answers, vec![], vec![]);
}

#[test]
fn test_detached_head_is_full_identifier() {
    let (scene, root) = linear_repository();
    git(&root, &["switch", "-q", "--detach", "HEAD~1"]);

    let answers = read(&scene, &root);

    let id = head_id(&root);
    assert_eq!(id.len(), 40, "a SHA-1 repository's identifier");
    assert_head(&answers, detached_at(id), RepositoryState::DetachedHead);
    assert_lists(&answers, vec![], vec![]);
}

#[test]
fn test_cherry_pick_revert_am_on_a_branch() {
    let (scene, root) = diverged_repository();
    git_that_stops(&root, &["cherry-pick", "other"]);
    let answers = read(&scene, &root);
    assert_head(&answers, on_branch("main"), RepositoryState::CherryPick);

    let (scene, root) = linear_repository();
    git_that_stops(&root, &["revert", "HEAD~1"]);
    let answers = read(&scene, &root);
    assert_head(&answers, on_branch("main"), RepositoryState::Revert);

    let (scene, root) = diverged_repository();
    let patch = git_output(&root, &["format-patch", "-1", "other", "--stdout"]);
    let patch_file = scene.write_file("change.patch", &format!("{patch}\n"));
    git_that_stops(&root, &["am", &patch_file.to_string_lossy()]);
    let answers = read(&scene, &root);
    assert_head(&answers, on_branch("main"), RepositoryState::Am);
}

#[test]
fn test_bisect_and_merge_on_detached_head() {
    let (scene, root) = linear_repository();
    git(&root, &["bisect", "start"]);
    git(&root, &["bisect", "bad", "HEAD"]);
    git(&root, &["bisect", "good", "HEAD~2"]);
    let answers = read(&scene, &root);
    assert_head(
        &answers,
        detached_at(head_id(&root)),
        RepositoryState::Bisect,
    );

    let (scene, root) = diverged_repository();
    git(&root, &["checkout", "-q", "--detach"]);
    git_that_stops(&root, &["merge", "other"]);
    let answers = read(&scene, &root);
    assert_head(
        &answers,
        detached_at(head_id(&root)),
        RepositoryState::Merge,
    );
}

#[test]
fn test_unborn_branch_answers_branch_normal() {
    let (scene, root) = new_repository();
    scene.write_file("S/x.txt", "x\n");

    let answers = read(&scene, &root);

    assert_head(&answers, on_branch("main"), RepositoryState::Normal);
    assert_lists(
        &answers,
        vec![],
        vec![entry("x.txt", StatusCategory::Untracked)],
    );

    git(&root, &["add", "x.txt"]);
    let answers = read(&scene, &root);
    assert_lists(
        &answers,
        vec![entry("x.txt", StatusCategory::Added)],
        vec![],
    );
}

#[test]
fn test_slash_in_branch_name_is_kept() {
    let (scene, root) = committed_files_repository();
    git(&root, &["checkout", "-q", "-b", "feature/x"]);

    let answers = read(&scene, &root);

    assert_head(&answers, on_branch("feature/x"), RepositoryState::Normal);
}

#[test]
fn test_type_change_is_modified_in_the_list_it_is_in() {
    let (scene, root) = committed_files_repository();
    fs::remove_file(root.join("a.txt")).expect("the file is removed");
    std::os::unix::fs::symlink("b.txt", root.join("a.txt")).expect("the link is made");

    let answers = read(&scene, &root);
    assert_lists(
        &answers,
        vec![],
        vec![entry("a.txt", StatusCategory::Modified)],
    );

    git(&root, &["add", "a.txt"]);
    let answers = read(&scene, &root);
    assert_lists(
        &answers,
        vec![entry("a.txt", StatusCategory::Modified)],
        vec![],
    );
}

#[test]
fn test_cached_removal_is_staged_deleted() {
    let (scene, root) = committed_files_repository();
    git(&root, &["rm", "-q", "--cached", "a.txt"]);

    let answers = read(&scene, &root);

    assert_lists(
        &answers,
        vec![entry("a.txt", StatusCategory::Deleted)],
        vec![entry("a.txt", StatusCategory::Untracked)],
    );
}

#[test]
fn test_upstream_ahead_changes_nothing_in_the_answer() {
    let (scene, root) = linear_repository();
    let behind = git_output(&root, &["rev-parse", "HEAD~1"]);
    git(
        &root,
        &["config", "remote.origin.url", "/nonexistent/remote"],
    );
    git(
        &root,
        &[
            "config",
            "remote.origin.fetch",
            "+refs/heads/*:refs/remotes/origin/*",
        ],
    );
    git(&root, &["config", "branch.main.remote", "origin"]);
    git(&root, &["config", "branch.main.merge", "refs/heads/main"]);
    git(&root, &["update-ref", "refs/remotes/origin/main", &behind]);

    let answers = read(&scene, &root);

    assert_head(&answers, on_branch("main"), RepositoryState::Normal);
    assert_lists(&answers, vec![], vec![]);
}

#[test]
fn test_unstaged_move_is_deleted_plus_untracked_never_renamed() {
    let (scene, root) = committed_files_repository();
    fs::rename(root.join("c.txt"), root.join("c-moved.txt")).expect("the file moves");

    let answers = read(&scene, &root);

    assert_lists(
        &answers,
        vec![],
        vec![
            entry("c.txt", StatusCategory::Deleted),
            entry("c-moved.txt", StatusCategory::Untracked),
        ],
    );
}

#[test]
fn test_staged_rename_carries_from_and_new_path() {
    let (scene, root) = committed_files_repository();
    git(&root, &["mv", "a.txt", "renamed.txt"]);

    let answers = read(&scene, &root);

    assert_lists(
        &answers,
        vec![entry(
            "renamed.txt",
            StatusCategory::Renamed {
                from: "a.txt".to_string(),
            },
        )],
        vec![],
    );
}

/// CP-516's "staged and changed again since appears in both lists, once in each", for a staged
/// rename: the changed entry is the file as it now stands, at the path it was renamed to (CP-514),
/// and never the path it left, which is in neither the index nor the working tree.
#[test]
fn test_staged_rename_changed_again_is_changed_at_the_new_path() {
    let (scene, root) = committed_files_repository();
    git(&root, &["mv", "a.txt", "renamed.txt"]);
    fs::write(root.join("renamed.txt"), "changed after the rename\n").expect("the file is written");

    let answers = read(&scene, &root);

    assert_lists(
        &answers,
        vec![entry(
            "renamed.txt",
            StatusCategory::Renamed {
                from: "a.txt".to_string(),
            },
        )],
        vec![entry("renamed.txt", StatusCategory::Modified)],
    );

    let (scene, root) = committed_files_repository();
    git(&root, &["mv", "b.txt", "renamed.txt"]);
    fs::remove_file(root.join("renamed.txt")).expect("the file is removed");

    let answers = read(&scene, &root);

    assert_lists(
        &answers,
        vec![entry(
            "renamed.txt",
            StatusCategory::Renamed {
                from: "b.txt".to_string(),
            },
        )],
        vec![entry("renamed.txt", StatusCategory::Deleted)],
    );
}

#[test]
fn test_ignored_file_and_empty_untracked_folder_are_absent() {
    let (scene, root) = new_repository();
    fs::write(root.join(".gitignore"), "*.log\n").expect("the file is written");
    commit_all(&root, "ignore");
    scene.write_file("S/x.log", "ignored\n");
    scene.make_folder("S/empty-folder");

    let answers = read(&scene, &root);

    assert_lists(&answers, vec![], vec![]);
}

#[test]
fn test_untracked_and_conflict_occur_only_in_changed() {
    let (scene, root) = diverged_repository();
    git_that_stops(&root, &["merge", "other"]);
    scene.write_file("S/untracked.txt", "u\n");

    let answers = read(&scene, &root);

    let lists = answers.lists();
    assert!(
        lists.staged.iter().all(|staged| !matches!(
            staged.category,
            StatusCategory::Untracked | StatusCategory::InConflict
        )),
        "staged holds {:?}",
        lists.staged
    );
    assert!(
        lists
            .changed
            .iter()
            .all(|changed| !matches!(changed.category, StatusCategory::Renamed { .. })),
        "changed holds {:?}",
        lists.changed
    );
    assert!(
        lists
            .changed
            .contains(&entry("untracked.txt", StatusCategory::Untracked)),
        "the scene has an untracked file, and it is in changed"
    );
}

/// Not every file system takes a name that is not UTF-8, so the path enters through the index.
#[test]
fn test_non_utf8_path_is_spelled_lossily() {
    let (scene, root) = committed_files_repository();
    let blob = git_output(&root, &["hash-object", "-w", "a.txt"]);
    let mut cacheinfo = format!("100644,{blob},").into_bytes();
    cacheinfo.extend_from_slice(b"n\xFFme.txt");
    let added = git_command(&root, &["update-index", "--add", "--cacheinfo"])
        .arg(OsStr::from_bytes(&cacheinfo))
        .output()
        .expect("the git command line runs");
    assert!(added.status.success(), "the index takes the path");

    let answers = read(&scene, &root);

    let lists = answers.lists();
    assert!(
        lists
            .staged
            .iter()
            .any(|staged| staged.path == "n\u{FFFD}me.txt"
                && staged.category == StatusCategory::Added),
        "staged holds {:?}",
        lists.staged
    );
}

#[test]
fn test_nested_untracked_path_is_slash_separated_relative() {
    let (scene, root) = committed_files_repository();
    scene.write_file("S/ud/deep/u.txt", "u\n");

    let answers = read(&scene, &root);

    assert_lists(
        &answers,
        vec![],
        vec![entry("ud/deep/u.txt", StatusCategory::Untracked)],
    );
}

#[test]
fn test_state_on_a_plain_folder_answers_not_a_root() {
    let scene = TempDir::new();
    let root = scene.make_folder("plain");
    scene.write_file("plain/readme.txt", "plain\n");

    let answers = read(&scene, &root);

    assert_eq!(answers.failure(), &GitReadCondition::NotARoot);
    assert_pathless(answers.failure());
}

#[test]
fn test_git_entry_that_is_a_link_or_has_no_value_answers_not_a_root() {
    let (scene, root) = git_file_scene("gitdir:   \n");
    let answers = read(&scene, &root);
    assert_eq!(answers.failure(), &GitReadCondition::NotARoot);
    assert_pathless(answers.failure());

    let scene = TempDir::new();
    let root = scene.make_folder("S");
    scene.make_link("S/.git", "elsewhere");
    let answers = read(&scene, &root);
    assert_eq!(answers.failure(), &GitReadCondition::NotARoot);
    assert_pathless(answers.failure());
}

// --- the read bound ---------------------------------------------------------------------------

#[test]
fn test_linked_worktree_and_submodule_answer_outside_from_both_calls() {
    let (scene, folder) = archived_scene("linked-worktree");
    let answers = read(&scene, &folder);
    assert_eq!(
        answers.failure(),
        &GitReadCondition::GitDirectoryOutside(
            scene
                .path()
                .join("main-repo/.git/worktrees/linked-worktree")
        )
    );

    let (scene, folder) = archived_scene("submodule");
    let answers = read(&scene, &folder);
    assert_eq!(
        answers.failure(),
        &GitReadCondition::GitDirectoryOutside(scene.path().join(".git/modules/submodule"))
    );
}

#[test]
fn test_gitdir_outside_with_nothing_there_answers_outside() {
    let (scene, root) = git_file_scene("gitdir: ../nowhere/.git\n");
    assert_eq!(
        read(&scene, &root).failure(),
        &GitReadCondition::GitDirectoryOutside(scene.path().join("nowhere/.git"))
    );

    let (scene, root) = git_file_scene("gitdir: /nonexistent/x\n");
    assert_eq!(
        read(&scene, &root).failure(),
        &GitReadCondition::GitDirectoryOutside(PathBuf::from("/nonexistent/x"))
    );
}

#[test]
fn test_unreadable_outside_directory_still_answers_outside() {
    let (scene, root) = git_file_scene("gitdir: ../locked\n");
    scene.make_folder("locked");
    let before = scene.snapshot();
    scene.set_mode("locked", 0o000);

    let answers = read_against_locked(&before, &scene, &root, "locked");

    assert_eq!(
        answers.failure(),
        &GitReadCondition::GitDirectoryOutside(scene.path().join("locked"))
    );
}

/// Reads while `locked` is mode `000`, then restores it so the scene can be snapshotted again.
fn read_against_locked(before: &Snapshot, scene: &TempDir, root: &Path, locked: &str) -> Answers {
    let state = port().state(root);
    let status = port().status(root);
    scene.set_mode(locked, 0o755);
    assert_eq!(&scene.snapshot(), before, "a read changed the scene");
    Answers { state, status }
}

#[test]
fn test_commondir_outside_answers_outside() {
    let (scene, root) = git_file_scene("gitdir: .wt\n");
    scene.write_file("S/.wt/HEAD", "ref: refs/heads/main\n");
    let common = scene.path().join("common-outside");
    scene.write_file("S/.wt/commondir", &format!("{}\n", common.display()));

    assert_eq!(
        read(&scene, &root).failure(),
        &GitReadCondition::GitDirectoryOutside(common)
    );
}

/// The bound reads a `gitdir:` or `commondir` value by libgit2's own rule, so what it verifies is
/// what libgit2 opens: libgit2 takes each value as a C string, which ends at the first NUL byte
/// (`read_gitfile` and `lookup_commondir` in the vendored libgit2 1.9.7). Here what follows the NUL
/// would lead back inside, while the location libgit2 would open lies outside and is not there.
#[test]
fn test_value_ends_at_a_nul_byte_as_libgit2_reads_it() {
    let (scene, root) = relocated_repository("../nowhere\0/../S/.realgit", ".realgit");
    assert_eq!(
        read(&scene, &root).failure(),
        &GitReadCondition::GitDirectoryOutside(scene.path().join("nowhere"))
    );

    let (scene, root) = git_file_scene("gitdir: .wt\n");
    scene.write_file("S/.wt/HEAD", "ref: refs/heads/main\n");
    let common = scene.path().join("common-outside");
    scene.write_file(
        "S/.wt/commondir",
        &format!("{}\0/../S/.wt\n", common.display()),
    );
    assert_eq!(
        read(&scene, &root).failure(),
        &GitReadCondition::GitDirectoryOutside(common)
    );
}

#[test]
fn test_gitdir_through_a_link_out_carries_the_spliced_path() {
    let (scene, root) = git_file_scene("gitdir: inner/g\n");
    let elsewhere = scene.make_folder("elsewhere");
    scene.make_link("S/inner", &elsewhere);
    assert_eq!(
        read(&scene, &root).failure(),
        &GitReadCondition::GitDirectoryOutside(elsewhere.join("g"))
    );

    // A walk that read past `S` would answer a missing condition for this one.
    let (scene, root) = git_file_scene("gitdir: inner/g\n");
    let gone = scene.path().join("gone");
    scene.make_link("S/inner", &gone);
    assert_eq!(
        read(&scene, &root).failure(),
        &GitReadCondition::GitDirectoryOutside(gone.join("g"))
    );
}

#[test]
fn test_gitdir_inside_spellings_open_normally() {
    let (scene, root) = relocated_repository(".realgit", ".realgit");
    let answers = read(&scene, &root);
    assert_head(&answers, on_branch("main"), RepositoryState::Normal);

    let (scene, root) = relocated_repository("alias/.realgit", ".realgit");
    scene.make_link("S/alias", ".");
    let answers = read(&scene, &root);
    assert_head(&answers, on_branch("main"), RepositoryState::Normal);

    let (scene, root) = relocated_repository("../S/.realgit", ".realgit");
    let answers = read(&scene, &root);
    assert_head(&answers, on_branch("main"), RepositoryState::Normal);
}

#[test]
fn test_missing_empty_and_unreadable_inside_directory() {
    let (scene, root) = git_file_scene("gitdir: .nothere\n");
    let answers = read(&scene, &root);
    assert_eq!(answers.failure(), &GitReadCondition::GitDirectoryMissing);
    assert_pathless(answers.failure());

    let (scene, root) = git_file_scene("gitdir: .realgit\n");
    scene.make_folder("S/.realgit");
    let answers = read(&scene, &root);
    assert_eq!(answers.failure(), &GitReadCondition::NotARepository);
    assert_pathless(answers.failure());

    let (scene, root) = git_file_scene("gitdir: .realgit\n");
    scene.make_folder("S/.realgit");
    let before = scene.snapshot();
    scene.set_mode("S/.realgit", 0o000);
    let answers = read_against_locked(&before, &scene, &root, "S/.realgit");
    assert_eq!(answers.failure(), &GitReadCondition::GitDirectoryUnreadable);
    assert_pathless(answers.failure());
}

/// What libgit2 would open is not what the bound verified, so neither call answers a state. A
/// `core.worktree` that spells outside the folder is the config condition, refused before the open
/// (SDD § 11 R-16, *The spellings*: it is spelled from the Git directory).
#[test]
fn test_core_worktree_elsewhere_answers_err_from_both_calls() {
    let (scene, repository) = fixture_repository();
    scene.make_folder("elsewhere");
    let config = repository.join(".git/config");
    let text = fs::read_to_string(&config).expect("the config can be read");
    fs::write(
        &config,
        text.replace("bare = false", "bare = false\n\tworktree = ../../elsewhere"),
    )
    .expect("the config can be written");

    let answers = read(&scene, &repository);

    assert_eq!(
        answers.failure(),
        &GitReadCondition::ConfigNamesOutside(ConfigNamedPath {
            key: "core.worktree".to_string(),
            path: "../../elsewhere".to_string(),
        })
    );
}

/// A port that answers what it was given and counts how often `probe`, `state` and `status` were
/// asked, so the reducer cases reach the model with no adapter.
struct Double {
    finding: RootFinding,
    head: Result<HeadState, GitReadCondition>,
    lists: Result<StatusLists, GitReadCondition>,
    probes: Cell<usize>,
    states: Cell<usize>,
    statuses: Cell<usize>,
}

impl Double {
    fn new(finding: RootFinding, head: Result<HeadState, GitReadCondition>) -> Self {
        Self::with_status(finding, head, Ok(standing_lists()))
    }

    fn with_status(
        finding: RootFinding,
        head: Result<HeadState, GitReadCondition>,
        lists: Result<StatusLists, GitReadCondition>,
    ) -> Self {
        Self {
            finding,
            head,
            lists,
            probes: Cell::new(0),
            states: Cell::new(0),
            statuses: Cell::new(0),
        }
    }
}

impl GitPort for Double {
    fn probe(&self, _folder: &Path) -> RootFinding {
        self.probes.set(self.probes.get() + 1);
        self.finding.clone()
    }

    fn state(&self, _root: &Path) -> Result<HeadState, GitReadCondition> {
        self.states.set(self.states.get() + 1);
        self.head.clone()
    }

    fn status(&self, _root: &Path) -> Result<StatusLists, GitReadCondition> {
        self.statuses.set(self.statuses.get() + 1);
        self.lists.clone()
    }
}

/// Lists whose order is not the alphabetical one, so a fold that sorted them would show.
fn standing_lists() -> StatusLists {
    StatusLists {
        staged: vec![
            StatusEntry {
                path: "src/new.txt".to_string(),
                category: StatusCategory::Added,
            },
            StatusEntry {
                path: "a.txt".to_string(),
                category: StatusCategory::Deleted,
            },
        ],
        changed: vec![
            StatusEntry {
                path: "z.txt".to_string(),
                category: StatusCategory::Untracked,
            },
            StatusEntry {
                path: "b.txt".to_string(),
                category: StatusCategory::Modified,
            },
        ],
    }
}

fn main_head() -> HeadState {
    HeadState {
        branch: on_branch("main"),
        state: RepositoryState::Normal,
    }
}

/// A model over a root of files only, so every tree item is `Observed` before the fold.
fn model_over_files() -> (TempDir, FolderModel) {
    let scene = TempDir::new();
    scene.write_file("a.txt", "a");
    scene.write_file("b.txt", "b");
    let opened = open_folder(scene.path()).expect("the scene opens");
    (scene, FolderModel::new(opened))
}

/// The fold of an outside failure leaves the tree and the folder as they were, and the item carries
/// exactly the path the port named.
#[test]
fn test_outside_failure_keeps_tree_and_folder_untouched() {
    let (_scene, model) = model_over_files();
    let outside = PathBuf::from("/nowhere-near/the-folder/.git");
    let double = Double::new(
        RootFinding::Root,
        Err(GitReadCondition::GitDirectoryOutside(outside.clone())),
    );
    let tree_before = model.tree().clone();
    let folder_before = model.folder().clone();
    assert!(matches!(tree_before, ItemState::Observed(_)));

    let folded = read_git(model, &double);

    assert_eq!(
        folded.kind(),
        &ItemState::Failed(GitCondition::Read(GitReadCondition::GitDirectoryOutside(
            outside.clone()
        )))
    );
    let text = format!("{:?}", folded.kind());
    assert!(text.contains(outside.to_str().expect("the path is UTF-8")));
    assert_eq!(
        text.matches('/').count(),
        outside
            .to_str()
            .expect("the path is UTF-8")
            .matches('/')
            .count(),
        "no other path appears in {text}"
    );
    assert_eq!(folded.tree(), &tree_before);
    assert_eq!(folded.folder(), &folder_before);
}

#[test]
fn test_root_with_state_is_observed_root() {
    let (_scene, model) = model_over_files();
    let double = Double::new(RootFinding::Root, Ok(main_head()));

    let folded = read_git(model, &double);

    match folded.kind() {
        ItemState::Observed(FolderKind::Root(git)) => {
            assert_eq!(git.head(), &main_head());
            assert_eq!(git.status(), &standing_lists());
        }
        other => panic!("expected an observed root, got {other:?}"),
    }
    assert_eq!(double.states.get(), 1);
    assert_eq!(double.statuses.get(), 1);
}

#[test]
fn test_state_ok_and_status_failing_is_a_failed_item() {
    let (_scene, model) = model_over_files();
    let double = Double::with_status(
        RootFinding::Root,
        Ok(main_head()),
        Err(GitReadCondition::RepositoryReadFailed),
    );
    let tree_before = model.tree().clone();
    let folder_before = model.folder().clone();

    let folded = read_git(model, &double);

    assert_eq!(
        folded.kind(),
        &ItemState::Failed(GitCondition::Read(GitReadCondition::RepositoryReadFailed))
    );
    assert_eq!(folded.tree(), &tree_before);
    assert_eq!(folded.folder(), &folder_before);
}

#[test]
fn test_state_failing_never_asks_status() {
    let (_scene, model) = model_over_files();
    let double = Double::new(RootFinding::Root, Err(GitReadCondition::NotARepository));

    let folded = read_git(model, &double);

    assert_eq!(
        folded.kind(),
        &ItemState::Failed(GitCondition::Read(GitReadCondition::NotARepository))
    );
    assert_eq!(double.statuses.get(), 0);
}

#[test]
fn test_plain_is_observed_plain_and_never_asks_state() {
    let (_scene, model) = model_over_files();
    let double = Double::new(RootFinding::Plain, Ok(main_head()));

    let folded = read_git(model, &double);

    assert_eq!(folded.kind(), &ItemState::Observed(FolderKind::Plain));
    assert_eq!(double.states.get(), 0);
}

#[test]
fn test_read_git_on_plain_asks_neither_state_nor_status() {
    let (_scene, model) = model_over_files();
    let double = Double::new(RootFinding::Plain, Ok(main_head()));

    let _ = read_git(model, &double);

    assert_eq!(double.states.get(), 0);
    assert_eq!(double.statuses.get(), 0);
}

#[test]
fn test_probe_failure_is_failed_probe_and_never_asks_state() {
    let (_scene, model) = model_over_files();
    let double = Double::new(
        RootFinding::Failed(ProbeCondition::GitFileUnreadable),
        Ok(main_head()),
    );

    let folded = read_git(model, &double);

    assert_eq!(
        folded.kind(),
        &ItemState::Failed(GitCondition::Probe(ProbeCondition::GitFileUnreadable))
    );
    assert_eq!(double.states.get(), 0);
}

#[test]
fn test_read_git_on_a_probe_failure_asks_neither_state_nor_status() {
    let (_scene, model) = model_over_files();
    let double = Double::new(
        RootFinding::Failed(ProbeCondition::GitFileUnreadable),
        Ok(main_head()),
    );

    let _ = read_git(model, &double);

    assert_eq!(double.states.get(), 0);
    assert_eq!(double.statuses.get(), 0);
}

#[test]
fn test_new_model_git_item_is_pending() {
    let (_scene, model) = model_over_files();

    assert_eq!(model.kind(), &ItemState::Pending);
}

#[test]
fn test_read_git_asks_again_whatever_the_item_held() {
    let (_scene, model) = model_over_files();
    let double = Double::new(RootFinding::Plain, Ok(main_head()));

    let once = read_git(model, &double);
    let twice = read_git(once, &double);

    assert_eq!(double.probes.get(), 2);
    assert_eq!(twice.kind(), &ItemState::Observed(FolderKind::Plain));
}

// --- the config check (R-16) ------------------------------------------------------------------

/// Runs `probe`, `state` and `status` on a thread over `folder` while this thread polls the write
/// end of the FIFO at `fifo` with a non-blocking open, which succeeds only once a reader holds the
/// FIFO. Returns whether any opener was seen, after all three calls returned. A build that reads
/// the path the config names opens the FIFO and blocks until this poll lets it through.
fn fifo_opener_seen_during_the_three_calls(folder: &Path, fifo: &Path) -> bool {
    make_fifo(fifo);
    opener_seen_during_the_three_calls(folder, fifo)
}

/// Makes a FIFO at `fifo`, whose parent folder exists.
fn make_fifo(fifo: &Path) {
    let status = Command::new("mkfifo")
        .arg(fifo)
        .status()
        .expect("mkfifo runs");
    assert!(status.success(), "mkfifo made the FIFO");
}

/// [`fifo_opener_seen_during_the_three_calls`] over a FIFO that already exists.
fn opener_seen_during_the_three_calls(folder: &Path, fifo: &Path) -> bool {
    use rustix::fs::{Mode, OFlags, open};

    let (sender, receiver) = mpsc::channel();
    let watched = folder.to_path_buf();
    std::thread::spawn(move || {
        let _ = port().probe(&watched);
        let _ = port().state(&watched);
        let _ = port().status(&watched);
        sender.send(()).ok();
    });
    let deadline = Instant::now() + Duration::from_secs(10);
    let mut opener_seen = false;
    loop {
        if receiver.try_recv().is_ok() {
            return opener_seen;
        }
        assert!(
            Instant::now() < deadline,
            "the three calls did not return in ten seconds"
        );
        if open(
            fifo.as_os_str().as_bytes(),
            OFlags::WRONLY | OFlags::NONBLOCK,
            Mode::empty(),
        )
        .is_ok()
        {
            opener_seen = true;
        }
        std::thread::sleep(Duration::from_millis(1));
    }
}

/// CP-655 to CP-657, through the libgit2 adapter and no port double: the repository's `config`
/// names `../../outside.config` from `.git/`, which is beside the copy, and the FIFO there is what
/// a read of that path would open.
#[test]
fn test_no_answer_reads_the_path_the_config_names_outside() {
    let scene = TempDir::new();
    let folder = scene.copy_fixture("config-names-outside");
    scene.unpack_fixture_archive("config-names-outside.git.tar", "config-names-outside");

    let opener_seen =
        fifo_opener_seen_during_the_three_calls(&folder, &scene.path().join("outside.config"));

    assert!(
        !opener_seen,
        "a call opened the path the config names outside the folder"
    );
}

/// The same watch over a superproject whose submodule's own config includes the outside path.
#[test]
fn test_no_status_read_opens_what_a_submodules_config_includes_outside() {
    let scene = TempDir::new();
    let folder = scene.copy_fixture("submodule-config-names-outside");
    scene.unpack_fixture_archive(
        "submodule-config-names-outside.git.tar",
        "submodule-config-names-outside",
    );

    let opener_seen =
        fifo_opener_seen_during_the_three_calls(&folder, &scene.path().join("outside.config"));

    assert!(
        !opener_seen,
        "a call opened the path the submodule's config names outside the folder"
    );
}

fn config_named(key: &str, path: &str) -> ConfigNamedPath {
    ConfigNamedPath {
        key: key.to_string(),
        path: path.to_string(),
    }
}

/// `S` holds one commit of `a.txt` and an untracked `secret.txt`.
fn repository_with_a_secret() -> (TempDir, PathBuf) {
    let (scene, root) = new_repository();
    fs::write(root.join("a.txt"), "a\n").expect("the file is written");
    commit_all(&root, "first");
    fs::write(root.join("secret.txt"), "secret\n").expect("the file is written");
    (scene, root)
}

/// Appends `text` to the repository's own `config`.
fn append_to_config(root: &Path, text: &str) {
    use std::io::Write;

    let mut config = fs::OpenOptions::new()
        .append(true)
        .open(root.join(".git/config"))
        .expect("the config opens");
    config
        .write_all(text.as_bytes())
        .expect("the config can be written");
}

#[test]
fn test_the_excludesfile_pointing_outside_refuses_with_the_config_condition() {
    let (scene, root) = repository_with_a_secret();
    let outside = scene.write_file("outside-ignore", "secret.txt\n");
    let value = outside.display().to_string();
    git(&root, &["config", "core.excludesfile", &value]);
    let before = scene.snapshot();

    let probed = port().probe(&root);
    let answers = read_against(&before, &scene, &root);

    let named = config_named("core.excludesfile", &value);
    assert_eq!(
        probed,
        RootFinding::Failed(ProbeCondition::ConfigNamesOutside(named.clone()))
    );
    assert_eq!(
        answers.failure(),
        &GitReadCondition::ConfigNamesOutside(named)
    );
    assert_eq!(&scene.snapshot(), &before, "the probe changed the scene");
}

#[test]
fn test_an_inside_include_is_followed_to_an_outside_path() {
    let (scene, root) = repository_with_a_secret();
    let outside = scene.path().join("outside.config");
    let inner = scene.write_file(
        "S/inner.config",
        &format!("[include]\n\tpath = {}\n", outside.display()),
    );
    append_to_config(&root, &format!("[include]\n\tpath = {}\n", inner.display()));

    let answers = read(&scene, &root);

    assert_eq!(
        answers.failure(),
        &GitReadCondition::ConfigNamesOutside(config_named(
            "include.path",
            &outside.display().to_string()
        ))
    );
}

#[test]
fn test_an_inside_excludesfile_answers_the_lists_with_the_file_applied() {
    let (scene, root) = repository_with_a_secret();
    let listing = scene.write_file("S/.git/ignore-list", "secret.txt\n");
    git(
        &root,
        &[
            "config",
            "core.excludesfile",
            &listing.display().to_string(),
        ],
    );

    let answers = read(&scene, &root);

    assert_lists(&answers, vec![], vec![]);
}

#[test]
fn test_an_inside_include_with_no_refused_key_answers_as_without_it() {
    let (scene, root) = repository_with_a_secret();
    let inner = scene.write_file("S/.git/inner.config", "[user]\n\tname = Someone\n");
    append_to_config(&root, &format!("[include]\n\tpath = {}\n", inner.display()));

    let answers = read(&scene, &root);

    assert_head(&answers, on_branch("main"), RepositoryState::Normal);
    assert_lists(
        &answers,
        vec![],
        vec![entry("secret.txt", StatusCategory::Untracked)],
    );
}

#[test]
fn test_a_submodule_with_an_outside_git_directory_fails_status_only() {
    let scene = TempDir::new();
    let origin = scene.make_folder("origin");
    git(&origin, &["init", "-q", "-b", "main"]);
    fs::write(origin.join("o.txt"), "o\n").expect("the file is written");
    commit_all(&origin, "origin");
    let root = scene.make_folder("S");
    git(&root, &["init", "-q", "-b", "main"]);
    git(
        &root,
        &[
            "-c",
            "protocol.file.allow=always",
            "submodule",
            "add",
            "-q",
            &origin.display().to_string(),
            "sub",
        ],
    );
    commit_all(&root, "with a submodule");
    let outside = scene.make_folder("outside-modules");
    fs::rename(root.join(".git/modules/sub"), outside.join("sub")).expect("the directory moves");
    scene.write_file("S/sub/.git", "gitdir: ../../outside-modules/sub\n");

    let state = port().state(&root);
    let status = port().status(&root);

    assert!(state.is_ok(), "state() answered {state:?}");
    assert_eq!(
        status,
        Err(GitReadCondition::GitDirectoryOutside(
            scene.path().join("outside-modules/sub")
        ))
    );
}

#[test]
fn test_failure_paths_of_the_check() {
    let (scene, root) = repository_with_a_secret();
    scene.set_mode("S/.git/config", 0o000);
    let probed = port().probe(&root);
    let state = port().state(&root);
    let status = port().status(&root);
    scene.set_mode("S/.git/config", 0o644);
    assert_eq!(
        probed,
        RootFinding::Failed(ProbeCondition::GitDirectoryUnreadable)
    );
    assert_eq!(state, Err(GitReadCondition::GitDirectoryUnreadable));
    assert_eq!(status, Err(GitReadCondition::GitDirectoryUnreadable));

    append_to_config(&root, "[unterminated\n");
    assert_eq!(
        port().probe(&root),
        RootFinding::Failed(ProbeCondition::RepositoryReadFailed)
    );
    assert_eq!(
        port().state(&root),
        Err(GitReadCondition::RepositoryReadFailed)
    );
    assert_eq!(
        port().status(&root),
        Err(GitReadCondition::RepositoryReadFailed)
    );
}

/// `extensions.worktreeConfig` makes `config.worktree` a config file of the repository, so the
/// check reads it too, in the Git directory, and a refused key in it refuses all three calls.
#[test]
fn test_the_worktree_config_is_read_where_the_extension_is_set() {
    let (scene, root) = repository_with_a_secret();
    let outside = scene.path().join("outside-ignore");
    append_to_config(&root, "[extensions]\n\tworktreeConfig = true\n");
    scene.write_file(
        "S/.git/config.worktree",
        &format!("[core]\n\texcludesfile = {}\n", outside.display()),
    );
    let named = config_named("core.excludesfile", &outside.display().to_string());

    assert_eq!(
        port().probe(&root),
        RootFinding::Failed(ProbeCondition::ConfigNamesOutside(named.clone()))
    );
    assert_eq!(
        read(&scene, &root).failure(),
        &GitReadCondition::ConfigNamesOutside(named)
    );
}

/// Without the extension libgit2 never loads `config.worktree`, so the check does not read it.
#[test]
fn test_the_worktree_config_is_not_read_without_the_extension() {
    let (scene, root) = repository_with_a_secret();
    let outside = scene.path().join("outside-ignore");
    scene.write_file(
        "S/.git/config.worktree",
        &format!("[core]\n\texcludesfile = {}\n", outside.display()),
    );

    let answers = read(&scene, &root);

    assert_head(&answers, on_branch("main"), RepositoryState::Normal);
}

/// An absent file is no refusal: an include whose file is not there, and an excludes file inside
/// the folder with nothing at it, are skipped as libgit2 skips them.
#[test]
fn test_an_absent_inside_file_is_no_refusal() {
    let (scene, root) = repository_with_a_secret();
    append_to_config(
        &root,
        &format!(
            "[include]\n\tpath = {}\n[core]\n\texcludesfile = {}\n",
            root.join(".git/not-there.config").display(),
            root.join(".git/not-there-either").display()
        ),
    );

    let answers = read(&scene, &root);

    assert_head(&answers, on_branch("main"), RepositoryState::Normal);
}

/// A value beginning `~/` is never expanded and never located: the refusal carries the value as
/// written, as not located, and nothing under a home folder is read.
#[test]
fn test_a_home_spelled_value_is_refused_as_written() {
    let (scene, root) = repository_with_a_secret();
    append_to_config(&root, "[include]\n\tpath = ~/nozoki-never-read.config\n");

    let answers = read(&scene, &root);

    assert_eq!(
        answers.failure(),
        &GitReadCondition::ConfigNotLocated(config_named(
            "include.path",
            "~/nozoki-never-read.config"
        ))
    );
}

/// What the repository's own config answers on all three calls for `text`, as not located.
fn assert_not_located_in_the_repositorys_config(text: &str, key: &str, value: &str) {
    let (scene, root) = repository_with_a_secret();
    append_to_config(&root, text);

    assert_failed_on_all_three(
        &scene,
        &root,
        ProbeCondition::ConfigNotLocated(config_named(key, value)),
        GitReadCondition::ConfigNotLocated(config_named(key, value)),
    );
}

/// Appends `text` to a verified submodule's own config.
fn append_to_the_submodules_config(root: &Path, text: &str) {
    use std::io::Write;

    let mut config = fs::OpenOptions::new()
        .append(true)
        .open(root.join(".git/modules/submodule/config"))
        .expect("the submodule config opens");
    config
        .write_all(text.as_bytes())
        .expect("the submodule config can be written");
}

/// A verified submodule's config answers on `status()` alone: `probe` finds the root and `state()`
/// reads.
fn assert_refused_on_status_alone(scene: &TempDir, root: &Path, read: GitReadCondition) {
    let before = scene.snapshot();

    assert_eq!(port().probe(root), RootFinding::Root);
    assert!(port().state(root).is_ok());
    assert_eq!(port().status(root), Err(read));
    assert_eq!(&scene.snapshot(), &before, "a call changed the scene");
}

/// CP-694 (a): a `~/` value is not located, and the observation is the value's, not the key's.
#[test]
fn test_a_tilde_slash_value_is_refused_as_not_located_on_all_three_calls() {
    assert_not_located_in_the_repositorys_config(
        "[include]\n\tpath = ~/x.config\n",
        "include.path",
        "~/x.config",
    );
}

#[test]
fn test_a_tilde_slash_value_in_a_submodules_config_is_not_located_on_status_alone() {
    let (scene, root) = submodule_repository_without_outside_config();
    append_to_the_submodules_config(&root, "\n[include]\n\tpath = ~/x.config\n");

    assert_refused_on_status_alone(
        &scene,
        &root,
        GitReadCondition::ConfigNotLocated(config_named("include.path", "~/x.config")),
    );
}

/// CP-694 (b): a relative excludes file is handed on with no base, so it is not located.
#[test]
fn test_a_relative_excludesfile_is_refused_as_not_located() {
    assert_not_located_in_the_repositorys_config(
        "[core]\n\texcludesfile = ignore-rel\n",
        "core.excludesfile",
        "ignore-rel",
    );

    let (scene, root) = submodule_repository_without_outside_config();
    append_to_the_submodules_config(&root, "\n[core]\n\texcludesfile = ignore-rel\n");
    assert_refused_on_status_alone(
        &scene,
        &root,
        GitReadCondition::ConfigNotLocated(config_named("core.excludesfile", "ignore-rel")),
    );
}

/// CP-694 (c): a value that spells a location beside the folder is outside, not unlocated.
#[test]
fn test_a_value_spelled_outside_is_refused_as_outside() {
    let (scene, root) = repository_with_a_secret();
    append_to_config(&root, "[include]\n\tpath = ../../outside.config\n");
    assert_failed_on_all_three(
        &scene,
        &root,
        ProbeCondition::ConfigNamesOutside(config_named("include.path", "../../outside.config")),
        GitReadCondition::ConfigNamesOutside(config_named("include.path", "../../outside.config")),
    );

    let (scene, root) = submodule_repository_without_outside_config();
    append_to_the_submodules_config(
        &root,
        "\n[include]\n\tpath = ../../../../outside.config\n",
    );
    assert_refused_on_status_alone(
        &scene,
        &root,
        GitReadCondition::ConfigNamesOutside(config_named(
            "include.path",
            "../../../../outside.config",
        )),
    );
}

/// The other not-located forms, and the rule that the key's own text never decides the observation.
#[test]
fn test_the_other_not_located_forms_and_the_key_text_rule() {
    assert_not_located_in_the_repositorys_config(
        "[core]\n\tattributesfile = ../attrs\n",
        "core.attributesfile",
        "../attrs",
    );
    assert_not_located_in_the_repositorys_config(
        "[core]\n\tworktree = ~/w\n",
        "core.worktree",
        "~/w",
    );

    let (scene, root) = repository_with_a_secret();
    let outside = scene.path().join("outside.config");
    let value = outside.display().to_string();
    append_to_config(
        &root,
        &format!("[includeIf \"gitdir:~/work/\"]\n\tpath = {value}\n"),
    );
    let probed = port().probe(&root);
    let RootFinding::Failed(ProbeCondition::ConfigNamesOutside(named)) = probed else {
        panic!("the outside absolute value is refused as outside, not as not located: {probed:?}");
    };
    assert_eq!(named.path, value);
    assert!(
        named.key.to_lowercase().starts_with("includeif.") && named.key.ends_with(".path"),
        "the key carries the `~/` the config spells it with: {named:?}"
    );
    assert_eq!(
        port().state(&root),
        Err(GitReadCondition::ConfigNamesOutside(named.clone()))
    );
    assert_eq!(port().status(&root), Err(GitReadCondition::ConfigNamesOutside(named)));
}

/// A `.gitmodules` include is read by `status()` alone and is followed like any config's.
#[test]
fn test_a_tilde_slash_include_in_gitmodules_is_not_located_on_status_alone() {
    let (scene, root) = submodule_repository_without_outside_config();
    append_to_gitmodules(&root, "\n[include]\n\tpath = ~/mods.config\n");

    assert_refused_on_status_alone(
        &scene,
        &root,
        GitReadCondition::ConfigNotLocated(config_named("include.path", "~/mods.config")),
    );
}

/// CP-686: with two refused values in one config, each answer carries one value's key, path and
/// observation, never one value's key and path under the other's observation. No order is pinned.
#[test]
fn test_two_refused_values_in_one_config_carry_one_values_key_path_and_observation() {
    let (scene, root) = repository_with_a_secret();
    let outside = scene.path().join("outside.config");
    let outside_value = outside.display().to_string();
    append_to_config(
        &root,
        &format!("[include]\n\tpath = {outside_value}\n[core]\n\texcludesfile = ignore-rel\n"),
    );
    let outside_read =
        GitReadCondition::ConfigNamesOutside(config_named("include.path", &outside_value));
    let not_located_read =
        GitReadCondition::ConfigNotLocated(config_named("core.excludesfile", "ignore-rel"));

    let state = port().state(&root).expect_err("the config is refused");
    assert!(
        state == outside_read || state == not_located_read,
        "{state:?}"
    );
    assert_eq!(port().status(&root), Err(state.clone()));
    let probe = match state {
        GitReadCondition::ConfigNamesOutside(named) => ProbeCondition::ConfigNamesOutside(named),
        GitReadCondition::ConfigNotLocated(named) => ProbeCondition::ConfigNotLocated(named),
        other => panic!("{other:?}"),
    };
    assert_eq!(port().probe(&root), RootFinding::Failed(probe));
}

/// A `commondir` that names a location inside the folder with nothing there: the probe, which has no
/// condition for a missing location, answers the unreadable one; the reads answer the missing one.
#[test]
fn test_a_missing_commondir_is_unreadable_to_the_probe_and_missing_to_the_reads() {
    let (scene, root) = repository_with_a_secret();
    scene.write_file("S/.git/commondir", "nothing-here\n");

    assert_eq!(
        port().probe(&root),
        RootFinding::Failed(ProbeCondition::GitDirectoryUnreadable)
    );
    assert_eq!(
        read(&scene, &root).failure(),
        &GitReadCondition::GitDirectoryMissing
    );
}

/// The existing submodule scene, with only the hostile include removed from its own config.
fn submodule_repository_without_outside_config() -> (TempDir, PathBuf) {
    let scene = TempDir::new();
    let root = scene.copy_fixture("submodule-config-names-outside");
    scene.unpack_fixture_archive(
        "submodule-config-names-outside.git.tar",
        "submodule-config-names-outside",
    );
    let config = root.join(".git/modules/submodule/config");
    let original = fs::read_to_string(&config).expect("the submodule config is read");
    fs::write(
        &config,
        original.split("[include]").next().expect("base config"),
    )
    .expect("the submodule's own config names no outside include");
    (scene, root)
}

fn append_to_gitmodules(root: &Path, text: &str) {
    use std::io::Write;
    let mut file = fs::OpenOptions::new()
        .append(true)
        .create(true)
        .open(root.join(".gitmodules"))
        .expect("the modules config opens");
    file.write_all(text.as_bytes())
        .expect("the modules config is written");
}

/// CP-658 and SDD R-16 include every config libgit2 loads for the repository.
#[test]
fn test_no_status_read_opens_an_outside_include_from_gitmodules() {
    let (scene, root) = submodule_repository_without_outside_config();
    append_to_gitmodules(&root, "\n[include]\n\tpath = ../outside.config\n");

    assert!(
        !fifo_opener_seen_during_the_three_calls(&root, &scene.path().join("outside.config")),
        "status opened the outside path named by .gitmodules"
    );
}

#[test]
fn test_gitmodules_outside_include_answers_its_condition_and_preserves_the_scene() {
    for nested in [false, true] {
        let (scene, root) = submodule_repository_without_outside_config();
        let owner = if nested {
            root.join("submodule")
        } else {
            root.clone()
        };
        let outside = scene.path().join("outside.config");
        append_to_gitmodules(
            &owner,
            &format!("\n[include]\n\tpath = {}\n", outside.display()),
        );
        let before = scene.snapshot();

        assert!(port().state(&root).is_ok());
        assert_eq!(
            port().status(&root),
            Err(GitReadCondition::ConfigNamesOutside(config_named(
                "include.path",
                &outside.display().to_string()
            )))
        );
        assert_eq!(scene.snapshot(), before);
    }
}

#[test]
fn test_an_inside_gitmodules_include_keeps_the_status_answer() {
    let (scene, root) = submodule_repository_without_outside_config();
    let before = port()
        .status(&root)
        .expect("the scene's status is readable");
    scene.write_file(
        "submodule-config-names-outside/.git/modules-extra",
        "[core]\n\tattributesfile = ../outside\n[extensions]\n\tworktreeConfig = true\n",
    );
    append_to_gitmodules(&root, "\n[include]\n\tpath = .git/modules-extra\n");
    let after = port()
        .status(&root)
        .expect("the inside include leaves status readable");

    assert_eq!(after.staged, before.staged);
    assert!(
        after
            .changed
            .iter()
            .all(|entry| entry.path == ".gitmodules")
    );
}

/// Task 5 bounds every config read, including an inside include, before libgit2 opens it.
#[test]
fn test_an_oversize_config_or_include_is_unreadable_on_every_call() {
    for included in [false, true] {
        let (_scene, root) = repository_with_a_secret();
        let large = vec![b' '; (1 << 20) + 1];
        if included {
            fs::write(root.join(".git/large"), &large).expect("the include is written");
            append_to_config(&root, "[include]\n\tpath = large\n");
        } else {
            fs::write(root.join(".git/config"), &large).expect("the config is written");
        }
        assert_eq!(
            port().probe(&root),
            RootFinding::Failed(ProbeCondition::GitDirectoryUnreadable)
        );
        assert_eq!(
            port().state(&root),
            Err(GitReadCondition::GitDirectoryUnreadable)
        );
        assert_eq!(
            port().status(&root),
            Err(GitReadCondition::GitDirectoryUnreadable)
        );
    }
}

/// CP-658: a path that looks inside but follows a link outside must be refused as written.
#[test]
fn test_an_include_link_to_outside_is_refused_without_opening_its_target() {
    let (scene, root) = repository_with_a_secret();
    scene.make_link("S/.git/linked", "../../outside.config");
    append_to_config(&root, "[include]\n\tpath = linked\n");

    assert!(!fifo_opener_seen_during_the_three_calls(
        &root,
        &scene.path().join("outside.config")
    ));
    assert_eq!(
        port().state(&root),
        Err(GitReadCondition::ConfigNamesOutside(config_named(
            "include.path",
            "linked"
        )))
    );
}

// --- the alternates check (R-16, the third way out) -------------------------------------------

/// The repository's own alternates file, which `git init` leaves no file at.
const ALTERNATES: &str = "S/.git/objects/info/alternates";

/// What each of the three calls answers when `entry` is refused, whatever the repository is.
fn assert_object_store_refused(scene: &TempDir, root: &Path, entry: &str) {
    let before = scene.snapshot();
    let condition = GitReadCondition::ObjectStoreNamesOutside(entry.to_string());

    assert_eq!(
        port().probe(root),
        RootFinding::Failed(ProbeCondition::ObjectStoreNamesOutside(entry.to_string()))
    );
    assert_eq!(port().state(root), Err(condition.clone()));
    assert_eq!(port().status(root), Err(condition));
    assert_eq!(&scene.snapshot(), &before, "a call changed the scene");
}

/// What each of the three calls answers when the alternates check refuses nothing: a repository
/// the way it answered before the check existed.
fn assert_answers_as_without_an_alternates_file(scene: &TempDir, root: &Path) {
    let before = scene.snapshot();

    assert_eq!(port().probe(root), RootFinding::Root);
    let answers = read_against(&before, scene, root);
    assert_head(&answers, on_branch("main"), RepositoryState::Normal);
    assert_lists(
        &answers,
        vec![],
        vec![entry("secret.txt", StatusCategory::Untracked)],
    );
}

/// Each of the three calls answers `probe` and `read`, and none changes the scene.
fn assert_failed_on_all_three(
    scene: &TempDir,
    root: &Path,
    probe: ProbeCondition,
    read: GitReadCondition,
) {
    let before = scene.snapshot();

    assert_eq!(port().probe(root), RootFinding::Failed(probe));
    assert_eq!(port().state(root), Err(read.clone()));
    assert_eq!(port().status(root), Err(read));
    assert_eq!(&scene.snapshot(), &before, "a call changed the scene");
}

/// A folder named `outside-store` beside the repository's folder, holding an `objects/info`, and its
/// absolute spelling.
fn outside_store(scene: &TempDir) -> String {
    scene.make_folder("outside-store/objects/info");
    scene
        .path()
        .join("outside-store/objects")
        .display()
        .to_string()
}

/// Makes a FIFO at `fifo`, runs the three calls over `folder` while it is watched, and holds that no
/// call opened it and that none changed the scene, which a snapshot taken once the FIFO stands
/// compares before and after.
fn assert_no_opener_and_scene_unchanged(scene: &TempDir, folder: &Path, fifo: &Path) {
    make_fifo(fifo);
    let before = scene.snapshot();

    let opener_seen = opener_seen_during_the_three_calls(folder, fifo);

    assert!(
        !opener_seen,
        "a call opened the object directory the alternates check must not read"
    );
    assert_eq!(&scene.snapshot(), &before, "a call changed the scene");
}

/// CP-677 and E19, through the libgit2 adapter and no port double: the archive's alternates file
/// names `../../../elsewhere/objects` from `.git/objects/`, which is beside the copy, and the FIFO
/// at that directory's `info/alternates` is what a load of that object directory would open. This
/// case names no new variant, so it is the one shown red on the tree before the check (CP-678).
#[test]
fn test_the_outside_object_directory_is_never_read_on_the_three_calls() {
    let scene = TempDir::new();
    let folder = scene.copy_fixture("alternates-names-outside");
    scene.unpack_fixture_archive(
        "alternates-names-outside.git.tar",
        "alternates-names-outside",
    );
    scene.make_folder("elsewhere/objects/info");

    assert_no_opener_and_scene_unchanged(
        &scene,
        &folder,
        &scene.path().join("elsewhere/objects/info/alternates"),
    );
}

#[test]
fn test_the_three_calls_answer_the_alternates_condition_for_the_fixture() {
    let scene = TempDir::new();
    let folder = scene.copy_fixture("alternates-names-outside");
    scene.unpack_fixture_archive(
        "alternates-names-outside.git.tar",
        "alternates-names-outside",
    );

    assert_object_store_refused(&scene, &folder, "../../../elsewhere/objects");
}

/// E1.
#[test]
fn test_an_absolute_entry_is_refused_and_carried_as_written() {
    let (scene, root) = repository_with_a_secret();
    let outside = outside_store(&scene);
    scene.write_file(ALTERNATES, &format!("{outside}\n"));

    assert_object_store_refused(&scene, &root, &outside);
}

/// E2: the entry is carried as the file spells it, and never as the path it resolves to.
#[test]
fn test_a_comment_and_a_blank_line_are_skipped_then_a_dotdot_entry_is_refused_as_spelled() {
    let (scene, root) = repository_with_a_secret();
    scene.make_folder("outside-store/objects");
    scene.write_file(ALTERNATES, "# shared\n\n../../../outside-store/objects\n");

    assert_object_store_refused(&scene, &root, "../../../outside-store/objects");
}

/// E3.
#[test]
fn test_a_bare_relative_entry_is_refused_as_outside_and_carried_as_written() {
    let (scene, root) = repository_with_a_secret();
    scene.write_file(ALTERNATES, "relative/objects\n");

    assert_object_store_refused(&scene, &root, "relative/objects");
}

/// E4: an alternate inside the folder is read, and its own file's outside entry is the refusal.
#[test]
fn test_an_inside_alternate_whose_own_file_names_an_outside_path_is_refused_with_that_path() {
    let (scene, root) = repository_with_a_secret();
    let outside = outside_store(&scene);
    scene.write_file(ALTERNATES, "./vendor-store\n");
    scene.write_file(
        "S/.git/objects/vendor-store/info/alternates",
        &format!("{outside}\n"),
    );

    assert_object_store_refused(&scene, &root, &outside);
}

/// E5: the check walks level by level, so the repository's own entry is met before a level-one
/// file's, whichever line it stands on.
#[test]
fn test_the_repositorys_own_file_is_met_before_a_level_one_file() {
    let (scene, root) = repository_with_a_secret();
    scene.write_file(ALTERNATES, "./vendor-store\n/own-outside/objects\n");
    scene.write_file(
        "S/.git/objects/vendor-store/info/alternates",
        "/level-one-outside/objects\n",
    );

    assert_object_store_refused(&scene, &root, "/own-outside/objects");
}

/// E6.
#[test]
fn test_no_alternates_file_and_a_file_of_only_comments_and_blank_lines_answer_as_today() {
    let (scene, root) = repository_with_a_secret();
    assert_answers_as_without_an_alternates_file(&scene, &root);

    scene.write_file(ALTERNATES, "# shared\r\n\r\n# nothing else\r\n\r\n");
    assert_answers_as_without_an_alternates_file(&scene, &root);
}

/// E7.
#[test]
fn test_an_inside_entry_with_nothing_there_answers_as_today() {
    let (scene, root) = repository_with_a_secret();
    scene.write_file(ALTERNATES, "./missing\n");

    assert_answers_as_without_an_alternates_file(&scene, &root);
}

/// An alternates chain of `levels` inside alternates, `.git/chain/l1` to `.git/chain/l<levels>`, the last
/// holding no alternates file, and a level past it, `.git/chain/l<levels + 1>`, with none either.
fn repository_with_a_chain_of(levels: usize) -> (TempDir, PathBuf) {
    let (scene, root) = repository_with_a_secret();
    let entry =
        |number: usize| format!("{}\n", root.join(format!(".git/chain/l{number}")).display());
    scene.write_file(ALTERNATES, &entry(1));
    for number in 1..=levels {
        scene.write_file(
            &format!("S/.git/chain/l{number}/info/alternates"),
            &entry(number + 1),
        );
    }
    scene.make_folder(&format!("S/.git/chain/l{}", levels + 1));
    (scene, root)
}

/// E8.
#[test]
fn test_a_chain_to_level_five_whose_level_six_alternate_has_no_file_is_not_a_refusal() {
    let (scene, root) = repository_with_a_chain_of(5);

    assert_answers_as_without_an_alternates_file(&scene, &root);
}

/// E9.
#[test]
fn test_a_level_six_alternate_with_an_alternates_file_answers_read_failed_on_all_three() {
    let (scene, root) = repository_with_a_chain_of(5);
    scene.write_file("S/.git/chain/l6/info/alternates", "# deeper\n");

    assert_failed_on_all_three(
        &scene,
        &root,
        ProbeCondition::RepositoryReadFailed,
        GitReadCondition::RepositoryReadFailed,
    );
}

/// The architect's level-6 note: a spelling that leaves the folder is the too-deep answer, and
/// nothing past it is read.
#[test]
fn test_a_level_six_file_whose_spelling_leaves_the_folder_answers_read_failed_and_reads_nothing_past_it()
 {
    let (scene, root) = repository_with_a_chain_of(5);
    scene.make_folder("outside-info");
    scene.make_link("S/.git/chain/l6/info", scene.path().join("outside-info"));

    assert_failed_on_all_three(
        &scene,
        &root,
        ProbeCondition::RepositoryReadFailed,
        GitReadCondition::RepositoryReadFailed,
    );
    assert_no_opener_and_scene_unchanged(
        &scene,
        &root,
        &scene.path().join("outside-info/alternates"),
    );
}

/// E10: `objects` is a link to a directory beside the scene. The refusal carries the link's own
/// spelled location, and nothing under that directory is opened.
#[test]
fn test_a_link_at_objects_leaving_the_folder_is_refused_carrying_the_links_location_and_nothing_is_read_under_it()
 {
    let (scene, root) = repository_with_a_secret();
    fs::rename(
        root.join(".git/objects"),
        scene.path().join("cache-objects"),
    )
    .expect("the object directory moves");
    let cache = scene.path().join("cache-objects");
    scene.make_link("S/.git/objects", &cache);

    assert_object_store_refused(&scene, &root, &cache.display().to_string());
    assert_no_opener_and_scene_unchanged(&scene, &root, &cache.join("info/alternates"));
}

/// CP-667's second position: a link at `info`.
#[test]
fn test_a_link_at_info_leaving_the_folder_is_refused_carrying_the_links_location() {
    let (scene, root) = repository_with_a_secret();
    fs::rename(
        root.join(".git/objects/info"),
        scene.path().join("outside-info"),
    )
    .expect("the info directory moves");
    let outside = scene.path().join("outside-info");
    scene.make_link("S/.git/objects/info", &outside);

    assert_object_store_refused(&scene, &root, &outside.display().to_string());
    assert_no_opener_and_scene_unchanged(&scene, &root, &outside.join("alternates"));
}

/// CP-667's third position: a link at `alternates` whose spelling leaves the folder is refused
/// carrying the location the link reaches, and the file there is never opened.
#[test]
fn test_a_link_at_alternates_leaving_the_folder_is_refused_carrying_the_links_location_and_nothing_is_read_there()
 {
    let (scene, root) = repository_with_a_secret();
    let outside = scene.path().join("outside-alternates");
    scene.make_link(ALTERNATES, &outside);

    assert_object_store_refused(&scene, &root, &outside.display().to_string());
    assert_no_opener_and_scene_unchanged(&scene, &root, &outside);
}

/// CP-667 for an inside alternate, not only the repository: a link at a level-one alternate's
/// `info` whose spelling leaves the folder is refused carrying the location the link reaches.
#[test]
fn test_a_link_at_an_inside_alternates_info_leaving_the_folder_is_refused_carrying_the_links_location()
 {
    let (scene, root) = repository_with_a_secret();
    scene.make_folder("S/.git/objects/vendor-store");
    let outside = scene.make_folder("outside-info");
    scene.make_link("S/.git/objects/vendor-store/info", &outside);
    scene.write_file(ALTERNATES, "./vendor-store\n");

    assert_object_store_refused(&scene, &root, &outside.display().to_string());
    assert_no_opener_and_scene_unchanged(&scene, &root, &outside.join("alternates"));
}

/// CP-665 and CP-671: an entry that begins `.` but reaches outside through a link inside the folder
/// spells outside, so it is refused as the file spells it, and the object directory the link
/// reaches is never opened.
#[test]
fn test_an_entry_reaching_outside_through_an_inside_link_is_refused_as_spelled_and_nothing_is_read_there()
 {
    let (scene, root) = repository_with_a_secret();
    let outside = PathBuf::from(outside_store(&scene));
    scene.make_link("S/.git/objects/vendor-link", &outside);
    scene.write_file(ALTERNATES, "./vendor-link\n");

    assert_object_store_refused(&scene, &root, "./vendor-link");
    assert_no_opener_and_scene_unchanged(&scene, &root, &outside.join("info/alternates"));
}

/// The design's spelling base (Architect Review Notes (b)): an entry beginning `.` is spelled from
/// the object directory as the walk resolved it, which is where the operating system takes `..`
/// from when libgit2 joins the entry onto its own path. Here `objects` is a link to a folder one
/// level nearer the root than `.git/objects`, so `../../` leaves the folder from where the link
/// leads, and would stay inside if spelled from `.git/objects` as written.
#[test]
fn test_a_dot_entry_is_spelled_from_where_an_inside_objects_link_leads_and_not_from_its_lexical_path()
 {
    let (scene, root) = repository_with_a_secret();
    fs::rename(root.join(".git/objects"), root.join("object-store"))
        .expect("the object directory moves");
    scene.make_link("S/.git/objects", "../object-store");
    let outside = PathBuf::from(outside_store(&scene));
    scene.write_file(
        "S/object-store/info/alternates",
        "../../outside-store/objects\n",
    );

    assert_object_store_refused(&scene, &root, "../../outside-store/objects");
    assert_no_opener_and_scene_unchanged(&scene, &root, &outside.join("info/alternates"));
}

/// E11: a link at `alternates` to a file inside the folder is followed, and its entries are spelled
/// from the object directory and not from where the link or its target stands.
#[test]
fn test_a_link_at_alternates_inside_the_folder_is_followed_and_its_entry_is_spelled_from_the_object_directory()
 {
    let (scene, root) = repository_with_a_secret();
    scene.write_file("S/.git/objects/alternates-target", "./x\n");
    scene.make_link(ALTERNATES, "../alternates-target");
    assert_answers_as_without_an_alternates_file(&scene, &root);

    scene.write_file("S/.git/objects/alternates-target", "../../../../beside\n");
    assert_object_store_refused(&scene, &root, "../../../../beside");
}

/// E12.
#[test]
fn test_an_oversize_alternates_file_answers_unreadable_on_all_three() {
    let (scene, root) = repository_with_a_secret();
    fs::write(
        root.join(".git/objects/info/alternates"),
        vec![b'#'; (1 << 20) + 1],
    )
    .expect("the file is written");

    assert_failed_on_all_three(
        &scene,
        &root,
        ProbeCondition::GitDirectoryUnreadable,
        GitReadCondition::GitDirectoryUnreadable,
    );
    drop(scene);
}

/// E14 and CP-669: a file the operating system will not let the check read, the repository's own
/// and a level-one alternate's.
#[test]
fn test_an_unreadable_alternates_file_answers_unreadable_for_the_repositorys_own_and_for_a_level_one_alternate()
 {
    let (scene, root) = repository_with_a_secret();
    scene.write_file(ALTERNATES, "# own\n");
    let before_own = scene.snapshot();
    scene.set_mode(ALTERNATES, 0o000);
    let own = (
        port().probe(&root),
        port().state(&root),
        port().status(&root),
    );
    scene.set_mode(ALTERNATES, 0o644);
    assert_eq!(&scene.snapshot(), &before_own, "a call changed the scene");
    assert_eq!(
        own,
        (
            RootFinding::Failed(ProbeCondition::GitDirectoryUnreadable),
            Err(GitReadCondition::GitDirectoryUnreadable),
            Err(GitReadCondition::GitDirectoryUnreadable),
        )
    );

    scene.write_file(ALTERNATES, "./vendor-store\n");
    scene.write_file("S/.git/objects/vendor-store/info/alternates", "# nested\n");
    let before_nested = scene.snapshot();
    scene.set_mode("S/.git/objects/vendor-store/info/alternates", 0o000);
    let nested = (
        port().probe(&root),
        port().state(&root),
        port().status(&root),
    );
    scene.set_mode("S/.git/objects/vendor-store/info/alternates", 0o644);
    assert_eq!(
        &scene.snapshot(),
        &before_nested,
        "a call changed the scene"
    );
    assert_eq!(
        nested,
        (
            RootFinding::Failed(ProbeCondition::GitDirectoryUnreadable),
            Err(GitReadCondition::GitDirectoryUnreadable),
            Err(GitReadCondition::GitDirectoryUnreadable),
        )
    );
}

/// E15: a submodule's alternates file naming an outside directory fails the status read alone, as a
/// submodule's outside Git directory does, and the outside directory is never opened on the way.
#[test]
fn test_a_submodules_outside_alternates_entry_fails_status_alone() {
    let scene = TempDir::new();
    let origin = scene.make_folder("origin");
    git(&origin, &["init", "-q", "-b", "main"]);
    fs::write(origin.join("o.txt"), "o\n").expect("the file is written");
    commit_all(&origin, "origin");
    let root = scene.make_folder("S");
    git(&root, &["init", "-q", "-b", "main"]);
    git(
        &root,
        &[
            "-c",
            "protocol.file.allow=always",
            "submodule",
            "add",
            "-q",
            &origin.display().to_string(),
            "sub",
        ],
    );
    commit_all(&root, "with a submodule");
    let outside = outside_store(&scene);
    scene.write_file(
        "S/.git/modules/sub/objects/info/alternates",
        &format!("{outside}\n"),
    );

    let fifo = scene.path().join("outside-store/objects/info/alternates");
    make_fifo(&fifo);
    let before = scene.snapshot();

    assert_eq!(port().probe(&root), RootFinding::Root);
    assert!(port().state(&root).is_ok());
    assert_eq!(
        port().status(&root),
        Err(GitReadCondition::ObjectStoreNamesOutside(outside))
    );
    assert_eq!(&scene.snapshot(), &before, "a call changed the scene");
    assert!(!opener_seen_during_the_three_calls(&root, &fifo));
    assert_eq!(&scene.snapshot(), &before, "a call changed the scene");
}

/// E16: both checks refuse, and the config check, which runs first, is the answer.
#[test]
fn test_a_config_and_an_alternates_refusal_together_answer_the_config_condition_on_all_three() {
    let (scene, root) = repository_with_a_secret();
    append_to_config(&root, "[core]\n\texcludesfile = /outside/ignore\n");
    let outside = outside_store(&scene);
    scene.write_file(ALTERNATES, &format!("{outside}\n"));

    assert_failed_on_all_three(
        &scene,
        &root,
        ProbeCondition::ConfigNamesOutside(config_named("core.excludesfile", "/outside/ignore")),
        GitReadCondition::ConfigNamesOutside(config_named("core.excludesfile", "/outside/ignore")),
    );
}

/// Architect note (a): a root whose `.git` is a file is probed without opening what it names, so the
/// probe answers `Root` and `state()` is the first call to answer the condition.
#[test]
fn test_a_git_file_root_probes_as_root_and_state_answers_the_condition() {
    let (scene, root) = relocated_repository("relocated", "relocated");
    let outside = outside_store(&scene);
    scene.write_file(
        "S/relocated/objects/info/alternates",
        &format!("{outside}\n"),
    );
    let before = scene.snapshot();

    assert_eq!(port().probe(&root), RootFinding::Root);
    let condition = GitReadCondition::ObjectStoreNamesOutside(outside);
    assert_eq!(port().state(&root), Err(condition.clone()));
    assert_eq!(port().status(&root), Err(condition));
    assert_eq!(&scene.snapshot(), &before, "a call changed the scene");
}
