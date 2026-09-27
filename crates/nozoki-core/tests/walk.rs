//! The in-process walk `checks/read-only.sh` consumes.
//!
//! Folder mode, taken when the first argument is an absolute path: open that folder, then call
//! `list_tree` on its root and on every entry it returns, descending only into folders. It prints
//! the number of `list_tree` calls it made and exits 0 once the walk is complete, or non-zero when
//! the folder did not open.
//!
//! No-argument mode, taken for any other argument too (a libtest filter is not a folder): walk the
//! committed fixtures, and exit 0 when both walks complete and each root lists at least one entry.
//!
//! It installs no logger, writes nothing, starts no process and reads no environment variable.
//! Its only input is its argument list.

use std::path::{Path, PathBuf};

use std::collections::HashSet;

use nozoki_core::{EntryKind, ItemState, OpenedFolder, list_tree, open_folder};

const FIXTURES: [&str; 2] = ["plain", "repo"];

/// One walk's outcome: how many `list_tree` calls it made, and whether the root listed entries.
struct Walk {
    calls: usize,
    root_has_entries: bool,
}

/// Calls `list_tree` on `path`, then on each entry it returns. A folder entry is walked in turn, and
/// every other entry is listed once and not descended. A failed answer stops nothing: it has no
/// entries to go on to. No path is listed twice, so folder links that reach each other end.
fn walk_from(
    opened: &OpenedFolder,
    path: &str,
    listed: &mut HashSet<String>,
    calls: &mut usize,
) -> bool {
    if !listed.insert(path.to_string()) {
        return false;
    }
    *calls += 1;
    let ItemState::Observed(entries) = list_tree(opened, path) else {
        return false;
    };
    for entry in &entries {
        match entry.kind {
            EntryKind::Folder => {
                walk_from(opened, &entry.path, listed, calls);
            }
            EntryKind::File => {
                if listed.insert(entry.path.clone()) {
                    *calls += 1;
                    list_tree(opened, &entry.path);
                }
            }
        }
    }
    !entries.is_empty()
}

fn walk_folder(folder: &Path) -> Option<Walk> {
    let opened = open_folder(folder).expect("the read-only fixture opens");
    let mut calls = 0;
    let mut listed = HashSet::new();
    let root_has_entries = walk_from(&opened, "", &mut listed, &mut calls);
    Some(Walk {
        calls,
        root_has_entries,
    })
}

fn fixture_path(name: &str) -> PathBuf {
    PathBuf::from(env!("CARGO_MANIFEST_DIR"))
        .join("../../checks/fixtures")
        .join(name)
}

/// Ends the process with status 0 on `Ok` and non-zero on `Err`, whose text goes to stderr.
fn main() -> Result<(), String> {
    let argument = std::env::args().nth(1);
    match argument.filter(|argument| argument.starts_with('/')) {
        Some(folder) => {
            let walk = walk_folder(Path::new(&folder))
                .ok_or_else(|| format!("{folder} did not open as a folder"))?;
            println!("{}", walk.calls);
            Ok(())
        }
        None => {
            for name in FIXTURES {
                let walk = walk_folder(&fixture_path(name))
                    .ok_or_else(|| format!("fixture {name} did not open as a folder"))?;
                if !walk.root_has_entries {
                    return Err(format!("fixture {name} listed no entries at its root"));
                }
            }
            Ok(())
        }
    }
}
