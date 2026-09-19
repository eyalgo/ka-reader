//! fs-reader: turns a requested path into a location known to lie inside a canonical root, and
//! lists that location's direct entries.

use std::collections::VecDeque;
use std::ffi::OsString;
use std::fmt;
use std::fs;
use std::io;
use std::path::{Component, Path, PathBuf};

/// What a directory entry is, read without following a link.
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum EntryKind {
    Folder,
    File,
    Symlink,
}

/// One direct entry of a listed folder.
#[derive(Debug, Clone, PartialEq, Eq)]
pub struct Entry {
    pub name: String,
    pub path: String,
    pub kind: EntryKind,
}

/// Why a listing inside the root could not be produced.
#[derive(Debug, Clone, PartialEq, Eq)]
pub enum Failure {
    /// The operating system refused a read. `os_error` is its own text, which never names a path.
    Io {
        kind: io::ErrorKind,
        os_error: String,
    },
    /// A chain of symbolic links was followed further than [`MAX_LINK_HOPS`], as a cycle would be.
    LinkLimit,
}

impl Failure {
    fn from_io(error: &io::Error) -> Self {
        Self::Io {
            kind: error.kind(),
            os_error: error.to_string(),
        }
    }
}

impl fmt::Display for Failure {
    fn fmt(&self, formatter: &mut fmt::Formatter<'_>) -> fmt::Result {
        match self {
            Self::Io { os_error, .. } => formatter.write_str(os_error),
            Self::LinkLimit => formatter.write_str("too many levels of symbolic links"),
        }
    }
}

/// The three outcomes of listing one requested path.
#[derive(Debug, Clone, PartialEq, Eq)]
pub enum Listing {
    Listed(Vec<Entry>),
    Refused,
    Failed(Failure),
}

/// The most symbolic links one requested path may pass through before it is called a cycle.
const MAX_LINK_HOPS: usize = 32;

/// One step of a requested path, still to be taken.
enum Step {
    Parent,
    Name(OsString),
}

/// Why a requested path did not resolve to a location that can be listed.
enum Blocked {
    Outside,
    Failed(Failure),
}

impl From<&io::Error> for Blocked {
    fn from(error: &io::Error) -> Self {
        Self::Failed(Failure::from_io(error))
    }
}

/// Lists the direct entries of `requested`, a path relative to `root` or absolute, where `root` is
/// a canonical folder path.
///
/// A path that resolves outside `root` is [`Listing::Refused`], and nothing outside `root` is
/// touched to decide that. A path inside `root` that cannot be listed is [`Listing::Failed`], and
/// only then is one record logged at `warn`, carrying the operating system's error text and no path.
pub fn list(root: &Path, requested: &str) -> Listing {
    match resolve(root, requested).and_then(|below_root| list_folder(root, &below_root)) {
        Ok(entries) => Listing::Listed(entries),
        Err(Blocked::Outside) => Listing::Refused,
        Err(Blocked::Failed(failure)) => {
            log::warn!("fs-reader: list failed: {failure}");
            Listing::Failed(failure)
        }
    }
}

/// The steps of `path`, in order. A root or prefix component carries no step: an absolute path's
/// walk starts at `/` instead (see [`resolve`]).
fn steps_of(path: &Path) -> VecDeque<Step> {
    path.components()
        .filter_map(|component| match component {
            Component::ParentDir => Some(Step::Parent),
            Component::Normal(name) => Some(Step::Name(name.to_os_string())),
            Component::CurDir | Component::RootDir | Component::Prefix(_) => None,
        })
        .collect()
}

/// Resolves `requested` to a location, returned as its path below `root`.
///
/// The walk keeps one lexical position: the root for a relative path, `/` for an absolute one, and
/// `/` again for a link's absolute target. A `..` moves it up lexically. While the position lies
/// outside the root, a name moves it down lexically and **nothing is touched**. Only a name whose
/// position already lies inside the root is read with `lstat`, and a link's target with
/// `read_link`. So a path that leaves the root and names it again resolves inside it, and one whose
/// walk ends outside is refused, without a filesystem call on any path outside the root. An absolute
/// path spelled through a symlinked ancestor of the root never lexically meets the canonical root,
/// so it is refused. No caller across the IPC boundary sends an absolute path.
fn resolve(root: &Path, requested: &str) -> Result<PathBuf, Blocked> {
    let requested = Path::new(requested);
    let mut position = if requested.is_absolute() {
        PathBuf::from("/")
    } else {
        root.to_path_buf()
    };
    let mut pending = steps_of(requested);
    let mut links_followed = 0;
    while let Some(step) = pending.pop_front() {
        match step {
            Step::Parent => {
                position.pop();
            }
            Step::Name(name) => {
                let candidate = position.join(&name);
                if !position.starts_with(root) {
                    position = candidate;
                    continue;
                }
                let metadata =
                    fs::symlink_metadata(&candidate).map_err(|error| Blocked::from(&error))?;
                if metadata.is_symlink() {
                    links_followed += 1;
                    if links_followed > MAX_LINK_HOPS {
                        return Err(Blocked::Failed(Failure::LinkLimit));
                    }
                    let target =
                        fs::read_link(&candidate).map_err(|error| Blocked::from(&error))?;
                    if target.is_absolute() {
                        position = PathBuf::from("/");
                    }
                    for step in steps_of(&target).into_iter().rev() {
                        pending.push_front(step);
                    }
                } else if !pending.is_empty() && !metadata.is_dir() {
                    return Err(Blocked::from(&io::Error::from(
                        io::ErrorKind::NotADirectory,
                    )));
                } else {
                    position = candidate;
                }
            }
        }
    }
    position
        .strip_prefix(root)
        .map(Path::to_path_buf)
        .map_err(|_| Blocked::Outside)
}

fn list_folder(root: &Path, below_root: &Path) -> Result<Vec<Entry>, Blocked> {
    let mut entries = Vec::new();
    for item in fs::read_dir(root.join(below_root)).map_err(|error| Blocked::from(&error))? {
        let item = item.map_err(|error| Blocked::from(&error))?;
        let file_type = item.file_type().map_err(|error| Blocked::from(&error))?;
        let name = item.file_name();
        entries.push(Entry {
            name: name.to_string_lossy().into_owned(),
            path: below_root.join(&name).to_string_lossy().into_owned(),
            kind: if file_type.is_symlink() {
                EntryKind::Symlink
            } else if file_type.is_dir() {
                EntryKind::Folder
            } else {
                EntryKind::File
            },
        });
    }
    Ok(entries)
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::test_support::TempDir;

    /// The listed entries as sorted `(name, path, kind)` triples, or a panic naming the outcome.
    fn listed(outcome: Listing) -> Vec<(String, String, EntryKind)> {
        match outcome {
            Listing::Listed(entries) => {
                let mut triples: Vec<_> = entries
                    .into_iter()
                    .map(|entry| (entry.name, entry.path, entry.kind))
                    .collect();
                triples.sort_by(|left, right| left.0.cmp(&right.0));
                triples
            }
            other => panic!("expected Listed, got {other:?}"),
        }
    }

    fn names(outcome: Listing) -> Vec<String> {
        listed(outcome).into_iter().map(|triple| triple.0).collect()
    }

    fn assert_failed(outcome: Listing) {
        assert!(
            matches!(outcome, Listing::Failed(_)),
            "expected Failed, got {outcome:?}"
        );
    }

    #[test]
    fn test_relative_path_inside_root_resolves_inside() {
        let temp = TempDir::new();
        temp.write_file("top.txt", "");
        temp.write_file("src/inner.txt", "");
        temp.write_file("src/deep/leaf.txt", "");

        assert_eq!(names(list(temp.path(), "")), ["src", "top.txt"]);
        assert_eq!(names(list(temp.path(), "src")), ["deep", "inner.txt"]);
        assert_eq!(names(list(temp.path(), "src/deep")), ["leaf.txt"]);
    }

    #[test]
    fn test_dotdot_leaving_root_is_refused() {
        let temp = TempDir::new();
        temp.make_folder("src");

        assert_eq!(list(temp.path(), ".."), Listing::Refused);
        assert_eq!(list(temp.path(), "../x"), Listing::Refused);
        assert_eq!(list(temp.path(), "src/../../x"), Listing::Refused);
    }

    #[test]
    fn test_dotdot_staying_inside_root_is_allowed() {
        let temp = TempDir::new();
        temp.write_file("src/inner.txt", "");

        assert_eq!(
            listed(list(temp.path(), "src/../src")),
            [(
                "inner.txt".to_string(),
                "src/inner.txt".to_string(),
                EntryKind::File
            )]
        );
    }

    #[test]
    fn test_current_dir_and_repeated_separators_are_ignored() {
        let temp = TempDir::new();
        temp.write_file("src/inner.txt", "");

        assert_eq!(names(list(temp.path(), "./src//./"),), ["inner.txt"]);
    }

    #[test]
    fn test_absolute_path_outside_root_is_refused() {
        let temp = TempDir::new();

        assert_eq!(list(temp.path(), "/etc"), Listing::Refused);
    }

    #[test]
    fn test_absolute_path_inside_canonical_root_is_allowed() {
        let temp = TempDir::new();
        temp.write_file("src/inner.txt", "");
        let absolute = temp.path().join("src");

        assert_eq!(
            names(list(temp.path(), absolute.to_str().expect("utf-8 path"))),
            ["inner.txt"]
        );
    }

    #[test]
    fn test_absolute_dotdot_leaving_root_is_refused() {
        let temp = TempDir::new();
        let leaving = format!("{}/../elsewhere", temp.path().display());

        assert_eq!(list(temp.path(), &leaving), Listing::Refused);
    }

    #[test]
    fn test_absolute_path_through_symlinked_ancestor_is_refused() {
        let temp = TempDir::new();
        temp.write_file("real/src/inner.txt", "");
        temp.make_link("alias", temp.path().join("real"));
        let root = temp.path().join("real");
        let through_alias = format!("{}/alias/src", temp.path().display());

        assert_eq!(list(&root, &through_alias), Listing::Refused);
    }

    #[test]
    fn test_symlink_to_outside_is_refused_without_touching_target() {
        let temp = TempDir::new();
        let root = temp.make_folder("root");
        temp.write_file("outside/locked/child", "");
        temp.set_mode("outside/locked", 0o000);
        temp.make_link("root/absolute", temp.path().join("outside/locked/child"));
        temp.make_link("root/relative", "../outside/locked/child");

        // A read of the target would fail on the mode and report Failed, not Refused.
        assert_eq!(list(&root, "absolute"), Listing::Refused);
        assert_eq!(list(&root, "relative"), Listing::Refused);
    }

    #[test]
    fn test_relative_symlink_escaping_root_is_refused() {
        let temp = TempDir::new();
        let root = temp.make_folder("root");
        temp.make_folder("sibling");
        temp.make_link("root/up", "../sibling");

        assert_eq!(list(&root, "up"), Listing::Refused);
    }

    #[test]
    fn test_symlink_to_inside_resolves_inside() {
        let temp = TempDir::new();
        temp.write_file("real/inner.txt", "");
        temp.make_link("relative", "real");
        temp.make_link("absolute", temp.path().join("real"));

        assert_eq!(names(list(temp.path(), "relative")), ["inner.txt"]);
        assert_eq!(names(list(temp.path(), "absolute")), ["inner.txt"]);
    }

    #[test]
    fn test_path_continuing_through_a_symlink_to_a_folder_resolves() {
        let temp = TempDir::new();
        temp.write_file("real/sub/inner.txt", "");
        temp.make_link("link", "real");

        assert_eq!(
            listed(list(temp.path(), "link/sub")),
            [(
                "inner.txt".to_string(),
                "real/sub/inner.txt".to_string(),
                EntryKind::File
            )]
        );
    }

    #[test]
    fn test_path_continuing_through_a_symlink_to_a_file_is_failed() {
        let temp = TempDir::new();
        temp.write_file("plain.txt", "");
        temp.make_link("link", "plain.txt");

        assert_failed(list(temp.path(), "link/below"));
    }

    #[test]
    fn test_symlink_chain_within_hop_limit_resolves() {
        let temp = TempDir::new();
        temp.write_file("real/inner.txt", "");
        temp.make_link("first", "second");
        temp.make_link("second", "third");
        temp.make_link("third", "real");

        assert_eq!(names(list(temp.path(), "first")), ["inner.txt"]);
    }

    #[test]
    fn test_symlink_cycle_is_failed_not_hung() {
        let temp = TempDir::new();
        temp.make_link("ping", "pong");
        temp.make_link("pong", "ping");

        assert_eq!(
            list(temp.path(), "ping"),
            Listing::Failed(Failure::LinkLimit)
        );
    }

    #[test]
    fn test_dangling_symlink_is_failed() {
        let temp = TempDir::new();
        temp.make_link("dangling", "nowhere");

        assert_failed(list(temp.path(), "dangling"));
    }

    #[test]
    fn test_listing_returns_every_direct_entry_with_kind() {
        let temp = TempDir::new();
        temp.write_file(".env", "");
        temp.make_folder(".git");
        temp.write_file("file.txt", "");
        temp.write_file("folder/below.txt", "");
        temp.make_link("link", "folder");

        assert_eq!(
            listed(list(temp.path(), "")),
            [
                (".env".to_string(), ".env".to_string(), EntryKind::File),
                (".git".to_string(), ".git".to_string(), EntryKind::Folder),
                (
                    "file.txt".to_string(),
                    "file.txt".to_string(),
                    EntryKind::File
                ),
                (
                    "folder".to_string(),
                    "folder".to_string(),
                    EntryKind::Folder
                ),
                ("link".to_string(), "link".to_string(), EntryKind::Symlink),
            ]
        );
    }

    #[test]
    fn test_empty_folder_lists_as_empty_and_not_failed() {
        let temp = TempDir::new();
        temp.make_folder("empty");

        assert_eq!(list(temp.path(), "empty"), Listing::Listed(Vec::new()));
    }

    #[test]
    fn test_root_entry_path_equals_name_and_nested_path_is_slash_joined() {
        let temp = TempDir::new();
        temp.write_file("src/inner.txt", "");

        assert_eq!(
            listed(list(temp.path(), "")),
            [("src".to_string(), "src".to_string(), EntryKind::Folder)]
        );
        assert_eq!(
            listed(list(temp.path(), "src")),
            [(
                "inner.txt".to_string(),
                "src/inner.txt".to_string(),
                EntryKind::File
            )]
        );
    }

    #[test]
    fn test_listing_a_file_is_failed() {
        let temp = TempDir::new();
        temp.write_file("plain.txt", "");

        assert_failed(list(temp.path(), "plain.txt"));
    }

    #[test]
    fn test_path_through_a_file_is_failed() {
        let temp = TempDir::new();
        temp.write_file("plain.txt", "");

        assert_failed(list(temp.path(), "plain.txt/.."));
        assert_failed(list(temp.path(), "plain.txt/below"));
    }

    #[test]
    fn test_listing_a_missing_path_is_failed() {
        let temp = TempDir::new();

        assert_failed(list(temp.path(), "missing"));
    }

    #[test]
    fn test_listing_an_unreadable_folder_is_failed() {
        let temp = TempDir::new();
        temp.make_folder("locked");
        temp.set_mode("locked", 0o000);

        assert_failed(list(temp.path(), "locked"));
    }
}
