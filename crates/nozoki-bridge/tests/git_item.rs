//! Layer 3: the Git item across the session, with the production wiring. The real adapter
//! is reached only through `Session::default()`, never named here (QC-50). Every scene is a copy of
//! a committed fixture, built and changed with an isolated `git`.

#[allow(
    dead_code,
    reason = "each test crate uses a subset of the shared helpers"
)]
mod common;

use std::path::PathBuf;

use common::{TempDir, git};
use nozoki_bridge::session::{OpenResult, Session};
use serde_json::{Value, json};

const REPO_ROOT_ANSWER: fn() -> Value = || {
    json!({
        "state": "observed",
        "kind": "root",
        "branch": { "kind": "branch", "name": "main" },
        "repository_state": "normal",
        "staged": [],
        "changed": []
    })
};

fn opened(session: &Session, folder: PathBuf) {
    let result = session.open(folder);
    assert!(matches!(result, OpenResult::Opened), "the folder must open");
}

fn git_item(session: &Session) -> Value {
    serde_json::to_value(session.read_git()).expect("the answer serializes")
}

fn members(value: &Value) -> Vec<String> {
    let mut names: Vec<String> = value
        .as_object()
        .expect("an object")
        .keys()
        .cloned()
        .collect();
    names.sort();
    names
}

#[test]
fn test_repo_fixture_answers_the_observed_root() {
    let scene = TempDir::new();
    let repository = scene.repository_copy();
    let session = Session::default();
    opened(&session, repository);

    assert_eq!(git_item(&session), REPO_ROOT_ANSWER());
}

#[test]
fn test_plain_fixture_answers_observed_plain_and_differs_from_repo() {
    let scene = TempDir::new();
    let plain = scene.copy_fixture("plain");
    let session = Session::default();
    opened(&session, plain);

    let answer = git_item(&session);

    assert_eq!(answer, json!({ "state": "observed", "kind": "plain" }));
    assert_ne!(answer, REPO_ROOT_ANSWER(), "never a clean tree");
}

#[test]
fn test_staged_and_unstaged_changes_cross_with_their_categories() {
    let scene = TempDir::new();
    let repository = scene.repository_copy();
    std::fs::write(repository.join("src/new.txt"), "new\n").expect("the file is written");
    git(&repository, &["add", "src/new.txt"]);
    std::fs::write(repository.join("README.md"), "changed\n").expect("the file is written");
    let session = Session::default();
    opened(&session, repository);

    let answer = git_item(&session);

    assert_eq!(
        answer["staged"],
        json!([{ "path": "src/new.txt", "category": "added" }])
    );
    assert_eq!(
        answer["changed"],
        json!([{ "path": "README.md", "category": "modified" }])
    );
}

#[test]
fn test_staged_rename_crosses_with_from() {
    let scene = TempDir::new();
    let repository = scene.repository_copy();
    git(&repository, &["mv", "README.md", "READ.md"]);
    let session = Session::default();
    opened(&session, repository);

    let answer = git_item(&session);

    assert_eq!(
        answer["staged"],
        json!([{ "path": "READ.md", "category": "renamed", "from": "README.md" }])
    );
}

#[test]
fn test_detached_copy_answers_the_full_identifier_and_detached_head() {
    let scene = TempDir::new();
    let repository = scene.repository_copy();
    git(&repository, &["checkout", "--detach", "HEAD"]);
    let session = Session::default();
    opened(&session, repository);

    let answer = git_item(&session);

    assert_eq!(
        answer["branch"],
        json!({ "kind": "detached", "commit": "62290d82ec30f74dbffb792140ea647be14eb18c" })
    );
    assert_eq!(answer["repository_state"], "detached_head");
}

#[test]
fn test_linked_worktree_answers_git_directory_outside_with_the_only_path() {
    let scene = TempDir::new();
    let folder = scene.copy_fixture("linked-worktree");
    scene.unpack_fixture_archive("linked-worktree.git.tar", ".");
    let session = Session::default();
    opened(&session, folder);

    let answer = git_item(&session);

    assert_eq!(
        members(&answer),
        vec!["condition", "git_directory", "state"],
        "no other member holds a path"
    );
    assert_eq!(answer["state"], "failed");
    assert_eq!(answer["condition"], "git_directory_outside");
    let expected = scene
        .path()
        .canonicalize()
        .expect("the scene canonicalizes")
        .join("main-repo/.git/worktrees/linked-worktree");
    assert_eq!(answer["git_directory"], expected.to_string_lossy().as_ref());
}

#[test]
fn test_no_folder_open_answers_exactly_pending() {
    let session = Session::default();

    assert_eq!(git_item(&session), json!({ "state": "pending" }));
}

#[test]
fn test_opening_plain_after_repo_answers_plains_item_with_nothing_of_repos() {
    let scene = TempDir::new();
    let repository = scene.repository_copy();
    let plain = scene.copy_fixture("plain");
    let session = Session::default();
    opened(&session, repository);
    assert_eq!(git_item(&session), REPO_ROOT_ANSWER());

    opened(&session, plain);

    assert_eq!(
        git_item(&session),
        json!({ "state": "observed", "kind": "plain" })
    );
}

#[test]
fn test_a_failed_open_leaves_the_held_answer_with_no_second_read() {
    let scene = TempDir::new();
    let repository = scene.repository_copy();
    let session = Session::default();
    opened(&session, repository.clone());
    assert_eq!(git_item(&session), REPO_ROOT_ANSWER());
    // A second read would now see this change, so an unchanged answer shows none was made.
    std::fs::write(repository.join("README.md"), "changed after the read\n")
        .expect("the file is written");

    let missing = session.open(PathBuf::from("/nonexistent/nozoki/folder"));

    assert!(matches!(missing, OpenResult::Failed { .. }));
    assert_eq!(git_item(&session), REPO_ROOT_ANSWER());
}
