//! The export-set check (CP-86, CP-88): the names the built static library exports, the names the
//! generated header declares, and the admitted set must be one set. The library is built by this test
//! itself, because `cargo test` does not produce a `staticlib`; the header is the one the bridge's
//! build script wrote. The comparison is a pure function of three sets, so its negative cases run on
//! synthetic inputs.

use std::collections::BTreeSet;
use std::env;
use std::fs;
use std::path::{Path, PathBuf};
use std::process::Command;
use std::sync::Mutex;

/// The rule, written here on purpose: the export and declared sets come from the library and the
/// header, and never from a list kept in this test. A name joins this array with the change that lands
/// the function (SM-4's file chooser, for one, is not here yet).
const ADMITTED: [&str; 3] = ["nozoki_open_folder", "nozoki_list_tree", "nozoki_free"];

/// The nested builds and the header they rewrite are one shared resource.
static SERIAL: Mutex<()> = Mutex::new(());

fn repo_root() -> PathBuf {
    Path::new(env!("CARGO_MANIFEST_DIR"))
        .ancestors()
        .nth(2)
        .expect("the crate sits two levels below the repository root")
        .to_path_buf()
}

fn header_path() -> PathBuf {
    repo_root().join("target/include/nozoki_bridge.h")
}

fn library_path() -> PathBuf {
    let profile = if cfg!(debug_assertions) {
        "debug"
    } else {
        "release"
    };
    repo_root()
        .join("target")
        .join(profile)
        .join("libnozoki_bridge.a")
}

/// Builds the static library in the profile this test runs in.
fn build_library() -> Result<(), String> {
    let cargo = env::var("CARGO").map_err(|error| format!("CARGO is not set: {error}"))?;
    let mut command = Command::new(cargo);
    command
        .args(["build", "-p", "nozoki-bridge", "--lib", "--locked"])
        .current_dir(repo_root());
    if !cfg!(debug_assertions) {
        command.arg("--release");
    }
    let status = command
        .status()
        .map_err(|error| format!("cargo build could not run: {error}"))?;
    status
        .success()
        .then_some(())
        .ok_or_else(|| format!("cargo build failed: {status}"))
}

/// Apple's `nm` cannot read the LLVM bitcode of the precompiled `std` members a Rust static library
/// carries, and exits 1 after listing every member it can read. That is not a failed listing, so this
/// accepts a non-zero exit only when nm's whole complaint is unreadable members that belong to a
/// dependency, and never one of the bridge's own (`nozoki_bridge-<hash>…` objects), which is where
/// an export lives. A member with no symbols is no complaint: it has no export to miss. Any other
/// complaint, or none at all, is a listing that cannot be trusted (QC-24).
fn only_dependency_members_unreadable(stderr: &[u8]) -> bool {
    let text = String::from_utf8_lossy(stderr);
    let complaints: Vec<&str> = text
        .lines()
        .map(str::trim)
        .filter(|l| !l.is_empty() && !l.ends_with(": no symbols"))
        .collect();
    !complaints.is_empty()
        && complaints.iter().all(|line| {
            let member = line
                .split_once("error: ")
                .and_then(|(_, rest)| rest.split_once(".a("))
                .and_then(|(_, rest)| rest.split_once("): "))
                .map(|(member, _)| member);
            member.is_some_and(|member| !member.starts_with("nozoki_bridge-"))
        })
}

/// The `nozoki_` names `nm -gU` reports for `library`. Mach-O prefixes a C symbol with `_`.
fn exported_names(nm: &str, library: &Path) -> Result<BTreeSet<String>, String> {
    let output = Command::new(nm)
        .arg("-gU")
        .arg(library)
        .output()
        .map_err(|error| format!("{nm} could not run: {error}"))?;
    if !output.status.success() && !only_dependency_members_unreadable(&output.stderr) {
        return Err(format!(
            "{nm} failed: {}: {}",
            output.status,
            String::from_utf8_lossy(&output.stderr)
        ));
    }
    Ok(String::from_utf8_lossy(&output.stdout)
        .lines()
        .filter_map(|line| line.split_whitespace().last())
        .filter_map(|symbol| symbol.strip_prefix('_'))
        .filter(|name| name.starts_with("nozoki_"))
        .map(str::to_string)
        .collect())
}

/// The `nozoki_` function names the header declares: an identifier followed by an opening parenthesis.
fn declared_names(header: &Path) -> Result<BTreeSet<String>, String> {
    let text = fs::read_to_string(header)
        .map_err(|error| format!("{} could not be read: {error}", header.display()))?;
    let mut names = BTreeSet::new();
    for line in text.lines() {
        let Some(start) = line.find("nozoki_") else {
            continue;
        };
        let name: String = line[start..]
            .chars()
            .take_while(|c| c.is_ascii_alphanumeric() || *c == '_')
            .collect();
        if line[start + name.len()..].trim_start().starts_with('(') {
            names.insert(name);
        }
    }
    Ok(names)
}

/// Every way the three sets disagree; empty means they are one set.
fn findings(
    exported: &BTreeSet<String>,
    declared: &BTreeSet<String>,
    admitted: &[&str],
) -> Vec<String> {
    let admitted: BTreeSet<String> = admitted.iter().map(|name| name.to_string()).collect();
    let mut found = Vec::new();
    for name in exported.difference(declared) {
        found.push(format!("{name} is exported but not declared"));
    }
    for name in declared.difference(exported) {
        found.push(format!("{name} is declared but not exported"));
    }
    for name in exported
        .union(declared)
        .filter(|name| !admitted.contains(*name))
    {
        found.push(format!("{name} is not admitted"));
    }
    for name in admitted.difference(exported) {
        found.push(format!("{name} is admitted but not exported"));
    }
    found
}

fn set(names: &[&str]) -> BTreeSet<String> {
    names.iter().map(|name| name.to_string()).collect()
}

#[test]
fn test_exports_equal_declarations_equal_admitted_set() {
    let _serial = SERIAL
        .lock()
        .unwrap_or_else(|poisoned| poisoned.into_inner());
    build_library().expect("the static library builds");

    let exported = exported_names("nm", &library_path()).expect("the exports can be listed");
    let declared = declared_names(&header_path()).expect("the header can be read");

    assert_eq!(
        findings(&exported, &declared, &ADMITTED),
        Vec::<String>::new()
    );
    assert_eq!(exported, set(&ADMITTED));
    assert_eq!(declared, set(&ADMITTED));
}

#[test]
fn test_export_the_header_lacks_fails() {
    let exported = set(&[
        "nozoki_open_folder",
        "nozoki_list_tree",
        "nozoki_free",
        "nozoki_extra",
    ]);
    let declared = set(&ADMITTED);

    let found = findings(&exported, &declared, &ADMITTED);

    assert!(
        found
            .iter()
            .any(|finding| finding == "nozoki_extra is exported but not declared"),
        "{found:?}"
    );
}

#[test]
fn test_declaration_with_no_export_fails() {
    let exported = set(&["nozoki_open_folder", "nozoki_list_tree"]);
    let declared = set(&ADMITTED);

    let found = findings(&exported, &declared, &ADMITTED);

    assert!(
        found
            .iter()
            .any(|finding| finding == "nozoki_free is declared but not exported"),
        "{found:?}"
    );
}

#[test]
fn test_unlanded_sm4_name_exported_and_declared_fails() {
    let both = set(&[
        "nozoki_open_folder",
        "nozoki_list_tree",
        "nozoki_free",
        "nozoki_select_file",
    ]);

    let found = findings(&both, &both, &ADMITTED);

    assert!(
        found
            .iter()
            .any(|finding| finding == "nozoki_select_file is not admitted"),
        "{found:?}"
    );
}

#[test]
fn test_unreadable_export_listing_fails() {
    let library = library_path();

    assert!(exported_names("nm-that-does-not-exist-anywhere", &library).is_err());
    assert!(exported_names("nm", Path::new("/nonexistent/libnozoki_bridge.a")).is_err());
    assert!(declared_names(Path::new("/nonexistent/nozoki_bridge.h")).is_err());
}

#[test]
fn test_hand_edited_header_is_regenerated() {
    let _serial = SERIAL
        .lock()
        .unwrap_or_else(|poisoned| poisoned.into_inner());
    build_library().expect("the static library builds");
    fs::write(header_path(), "/* a hand edit: nozoki_extra(void); */\n")
        .expect("the header is writable");

    build_library().expect("the static library builds again");

    let declared = declared_names(&header_path()).expect("the header can be read");
    assert_eq!(
        declared,
        set(&ADMITTED),
        "the build rewrote the header from the source"
    );
}

#[test]
fn test_unreadable_dependency_member_does_not_fail_the_listing() {
    let stderr = b"nm: error: lib.a(std-1.rcgu.o): Unknown attribute kind (105)\n\nnm: error: lib.a(object-2.rcgu.o): Unknown attribute kind (105)\nlib.a:cfg_if-1.rcgu.o: no symbols\n";

    assert!(only_dependency_members_unreadable(stderr));
}

#[test]
fn test_unreadable_bridge_member_fails_the_listing() {
    let stderr = b"nm: error: lib.a(std-1.rcgu.o): x\nnm: error: lib.a(nozoki_bridge-9f.0.rcgu.o): Unknown attribute kind (105)\n";

    assert!(!only_dependency_members_unreadable(stderr));
}

#[test]
fn test_a_complaint_that_names_no_member_fails_the_listing() {
    assert!(!only_dependency_members_unreadable(
        b"nm: error: no such file\n"
    ));
    assert!(!only_dependency_members_unreadable(b""));
}
