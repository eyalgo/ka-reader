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

use common::{Snapshot, TempDir};
use std::cell::Cell;

use nozoki_core::{
    BranchElement, FolderKind, FolderModel, GitCondition, GitPort, GitReadCondition, HeadState,
    ItemState, ProbeCondition, RepositoryState, RootFinding, StatusCategory, StatusEntry,
    StatusLists, open_folder, read_git,
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

/// CP-521: a failure other than the outside one holds no path, so its text holds no separator.
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

/// What libgit2 would open is not what the bound verified, so neither call answers a state.
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

    assert!(
        answers.state.is_err(),
        "state() answered {:?}",
        answers.state
    );
    assert!(
        answers.status.is_err(),
        "status() answered {:?}",
        answers.status
    );
    assert_pathless(answers.failure());
}

/// A port that answers what it was given and counts how often `probe` and `state` were asked, so
/// the reducer cases reach the model with no adapter.
struct Double {
    finding: RootFinding,
    head: Result<HeadState, GitReadCondition>,
    probes: Cell<usize>,
    states: Cell<usize>,
}

impl Double {
    fn new(finding: RootFinding, head: Result<HeadState, GitReadCondition>) -> Self {
        Self {
            finding,
            head,
            probes: Cell::new(0),
            states: Cell::new(0),
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
        panic!("the reducer step never asks status");
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
        ItemState::Observed(FolderKind::Root(git)) => assert_eq!(git.head(), &main_head()),
        other => panic!("expected an observed root, got {other:?}"),
    }
    assert_eq!(double.states.get(), 1);
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
