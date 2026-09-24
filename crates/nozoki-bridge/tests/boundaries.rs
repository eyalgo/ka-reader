//! The boundary check (CP-124): two properties of the source tree, read as data.
//!
//! - Every crate but `nozoki-bridge` forbids `unsafe`, and the workspace root is what makes the
//!   inherited level a real one.
//! - Only `nozoki-bridge` installs a logger: no other crate names `set_logger` or `set_boxed_logger`
//!   in its `src/`.
//!
//! The rule is one pure function of texts, so its negative cases run on synthetic manifests and
//! sources; one more case runs it on the real tree. The manifests are read with `std` alone, because
//! a TOML crate would add a package to `Cargo.lock`.

use std::fs;
use std::io;
use std::path::{Path, PathBuf};

/// The one crate that may relax `unsafe` and install a logger, named by its directory under `crates/`.
const BRIDGE_CRATE: &str = "nozoki-bridge";

/// A source file of a crate: its path relative to the crate, `/`-separated, and its text.
struct SourceFile {
    path: String,
    text: String,
}

/// A workspace member as the workspace glob admits it: a directory under `crates/` holding a
/// `Cargo.toml`.
struct CrateSource {
    directory: String,
    manifest: String,
    sources: Vec<SourceFile>,
}

/// The lint whose level the first boundary pins.
const UNSAFE_LINT: &str = "unsafe_code";
/// The level a crate must hold it at, as a manifest writes the value.
const FORBID_VALUE: &str = "\"forbid\"";
/// The value of `workspace` in a member's `[lints]` table that opts it into the workspace's levels.
const INHERIT_VALUE: &str = "true";

/// One line of a manifest that this reader recognizes: a table header, or a `key = value` line under
/// the table header above it (the empty table name is the top of the file).
enum ManifestItem {
    Table {
        name: String,
        is_array: bool,
    },
    Pair {
        table: String,
        key: String,
        value: String,
    },
}

/// The line without its `#` comment. A `#` inside a double-quoted string is not a comment.
fn without_comment(line: &str) -> &str {
    let mut inside_string = false;
    for (index, character) in line.char_indices() {
        match character {
            '"' => inside_string = !inside_string,
            '#' if !inside_string => return &line[..index],
            _ => {}
        }
    }
    line
}

/// Table headers and `key = value` lines, in file order. A line of any other shape (the tail of a
/// multi-line value, say) is skipped, and is caught where it matters by the key that opened it.
fn manifest_items(text: &str) -> Vec<ManifestItem> {
    let mut table = String::new();
    let mut items = Vec::new();
    for raw_line in text.lines() {
        let line = without_comment(raw_line).trim();
        if line.is_empty() {
            continue;
        }
        let header = line
            .strip_prefix("[[")
            .map(|inner| (inner.trim_end_matches(']'), true))
            .or_else(|| {
                line.strip_prefix('[')
                    .map(|inner| (inner.trim_end_matches(']'), false))
            });
        if let Some((name, is_array)) = header {
            table = name.trim().to_string();
            items.push(ManifestItem::Table {
                name: table.clone(),
                is_array,
            });
        } else if let Some((key, value)) = line.split_once('=') {
            items.push(ManifestItem::Pair {
                table: table.clone(),
                key: key.trim().to_string(),
                value: value.trim().to_string(),
            });
        }
    }
    items
}

/// Whether the root manifest's `[workspace.lints.rust]` sets `unsafe_code = "forbid"`.
fn root_forbids_unsafe(root_manifest: &str) -> bool {
    manifest_items(root_manifest).iter().any(|item| {
        matches!(item, ManifestItem::Pair { table, key, value }
            if table == "workspace.lints.rust" && key == UNSAFE_LINT && value == FORBID_VALUE)
    })
}

/// What a crate's manifest says about lints, in the two forms this check recognizes.
struct CrateLints {
    /// `[lints]` holds `workspace = true`.
    inherits_workspace: bool,
    /// The value `[lints.rust]` gives `unsafe_code`, as written, when it gives one.
    unsafe_level: Option<String>,
}

/// Reads a crate manifest's lints. Anything that names lints in a form other than `[lints]` with
/// `workspace = true`, or a `[lints.<tool>]` table, is an `Err` naming the form: a form this reader
/// does not know is never read as "no lints".
fn read_crate_lints(manifest: &str) -> Result<CrateLints, String> {
    let mut lints = CrateLints {
        inherits_workspace: false,
        unsafe_level: None,
    };
    for item in manifest_items(manifest) {
        match item {
            ManifestItem::Table { name, is_array } => {
                let segments: Vec<&str> = name.split('.').map(str::trim).collect();
                let names_lints = segments.contains(&"lints");
                let recognized = !is_array
                    && (segments == ["lints"] || (segments.len() == 2 && segments[0] == "lints"));
                if names_lints && !recognized {
                    return Err(format!("the table header `[{name}]`"));
                }
            }
            ManifestItem::Pair { table, key, value } => match table.as_str() {
                "lints" if key == "workspace" && value == INHERIT_VALUE => {
                    lints.inherits_workspace = true;
                }
                "lints" => return Err(format!("`{key} = {value}` under `[lints]`")),
                "lints.rust" if key == UNSAFE_LINT => lints.unsafe_level = Some(value),
                "lints.rust" if key.starts_with(&format!("{UNSAFE_LINT}.")) => {
                    return Err(format!("the dotted key `{key}` under `[lints.rust]`"));
                }
                _ if key == "lints" || key.starts_with("lints.") => {
                    return Err(format!("the key `{key}` under `[{table}]`"));
                }
                _ => {}
            },
        }
    }
    Ok(lints)
}

/// The violation a crate's manifest carries, if it does not forbid `unsafe`. A crate forbids it when
/// its own `[lints.rust]` sets the level to forbid, or when it inherits a workspace level that is.
fn unsafe_violation(directory: &str, manifest: &str, root_forbids: bool) -> Option<String> {
    let lints = match read_crate_lints(manifest) {
        Ok(lints) => lints,
        Err(form) => {
            return Some(format!(
                "crate {directory}: a lints form this check does not recognize ({form}); it cannot tell whether `unsafe` is forbidden"
            ));
        }
    };
    match lints.unsafe_level {
        Some(level) if level == FORBID_VALUE => None,
        Some(level) => Some(format!(
            "crate {directory}: sets `{UNSAFE_LINT} = {level}`, which does not forbid `unsafe`"
        )),
        None if lints.inherits_workspace && root_forbids => None,
        None => Some(format!(
            "crate {directory}: does not forbid `unsafe` (no `[lints] workspace = true` under a root that forbids it, and no `{UNSAFE_LINT} = {FORBID_VALUE}` of its own)"
        )),
    }
}

/// The two `log` functions that install a logger.
const LOGGER_INSTALLERS: [&str; 2] = ["set_logger", "set_boxed_logger"];
/// The directory of a crate whose sources the logger boundary reads.
const SOURCE_DIRECTORY_PREFIX: &str = "src/";

/// The violations in one crate's `src/`: each file that names a logger installer in the code of a
/// line, meaning the part before any `//`. The match is by substring, so `set_logger_racy` is caught
/// with `set_logger`, and `use log::set_logger as install;` is caught where it names the function.
fn logger_violations(member: &CrateSource) -> Vec<String> {
    member
        .sources
        .iter()
        .filter(|file| file.path.starts_with(SOURCE_DIRECTORY_PREFIX) && file.path.ends_with(".rs"))
        .filter(|file| {
            file.text.lines().any(|line| {
                let code = line.split("//").next().unwrap_or_default();
                LOGGER_INSTALLERS
                    .iter()
                    .any(|installer| code.contains(installer))
            })
        })
        .map(|file| {
            format!(
                "crate {}: {} installs a logger, and only `{BRIDGE_CRATE}` may",
                member.directory, file.path
            )
        })
        .collect()
}

/// The violations of a check with nothing to check. Each boundary holds trivially on a tree with no
/// crate, no bridge to exempt, or no other crate to constrain, so each of those is a failure.
fn vacuity_violations(crates: &[CrateSource]) -> Vec<String> {
    if crates.is_empty() {
        return vec!["no crate found under `crates/`, so no boundary was checked".to_string()];
    }
    let mut violations = Vec::new();
    if !crates.iter().any(|member| member.directory == BRIDGE_CRATE) {
        violations.push(format!(
            "no `{BRIDGE_CRATE}` crate found under `crates/`, so the exemption named for it matches nothing"
        ));
    }
    if !crates.iter().any(|member| member.directory != BRIDGE_CRATE) {
        violations.push(format!(
            "no crate other than `{BRIDGE_CRATE}` found under `crates/`, so no boundary was checked"
        ));
    }
    violations
}

/// Every boundary violation in the tree these texts describe. An empty result means every boundary
/// holds. It is a violation for the texts to hold no crate, no bridge, or no crate beside the bridge.
fn boundary_violations(root_manifest: &str, crates: &[CrateSource]) -> Vec<String> {
    let mut violations = Vec::new();
    let root_forbids = root_forbids_unsafe(root_manifest);
    if !root_forbids {
        violations.push(format!(
            "root manifest: `[workspace.lints.rust]` does not set `{UNSAFE_LINT} = {FORBID_VALUE}`"
        ));
    }
    for member in crates
        .iter()
        .filter(|member| member.directory != BRIDGE_CRATE)
    {
        violations.extend(unsafe_violation(
            &member.directory,
            &member.manifest,
            root_forbids,
        ));
        violations.extend(logger_violations(member));
    }
    violations.extend(vacuity_violations(crates));
    violations
}

fn repo_root() -> PathBuf {
    Path::new(env!("CARGO_MANIFEST_DIR"))
        .ancestors()
        .nth(2)
        .expect("the crate sits two levels below the repository root")
        .to_path_buf()
}

/// Every `.rs` file under `directory`, at any depth, with its path relative to `crate_root`.
fn read_rust_files(
    crate_root: &Path,
    directory: &Path,
    into: &mut Vec<SourceFile>,
) -> io::Result<()> {
    let mut entries = fs::read_dir(directory)?.collect::<Result<Vec<_>, _>>()?;
    entries.sort_by_key(|entry| entry.file_name());
    for entry in entries {
        let path = entry.path();
        if path.is_dir() {
            read_rust_files(crate_root, &path, into)?;
        } else if path.extension().is_some_and(|extension| extension == "rs") {
            let relative = path
                .strip_prefix(crate_root)
                .expect("a file under the crate is under the crate")
                .components()
                .map(|component| component.as_os_str().to_string_lossy().into_owned())
                .collect::<Vec<_>>()
                .join("/");
            into.push(SourceFile {
                path: relative,
                text: fs::read_to_string(&path)?,
            });
        }
    }
    Ok(())
}

/// The real tree: the root manifest's text and every directory under `crates/` that holds a
/// `Cargo.toml`, the same set the workspace glob `crates/*` admits.
fn read_real_tree() -> io::Result<(String, Vec<CrateSource>)> {
    let root = repo_root();
    let root_manifest = fs::read_to_string(root.join("Cargo.toml"))?;
    let mut directories = fs::read_dir(root.join("crates"))?.collect::<Result<Vec<_>, _>>()?;
    directories.sort_by_key(|entry| entry.file_name());
    let mut crates = Vec::new();
    for entry in directories {
        let crate_root = entry.path();
        let manifest_path = crate_root.join("Cargo.toml");
        if !manifest_path.is_file() {
            continue;
        }
        let mut sources = Vec::new();
        read_rust_files(&crate_root, &crate_root, &mut sources)?;
        crates.push(CrateSource {
            directory: entry.file_name().to_string_lossy().into_owned(),
            manifest: fs::read_to_string(manifest_path)?,
            sources,
        });
    }
    Ok((root_manifest, crates))
}

const ROOT_FORBIDDING: &str =
    "[workspace]\nmembers = [\"crates/*\"]\n\n[workspace.lints.rust]\nunsafe_code = \"forbid\"\n";
const ROOT_WITHOUT_FORBID: &str = "[workspace]\nmembers = [\"crates/*\"]\n";
const INHERITING: &str =
    "[package]\nname = \"member\"\nedition = \"2024\"\n\n[lints]\nworkspace = true\n";
const WITHOUT_LINTS: &str = "[package]\nname = \"member\"\nedition = \"2024\"\n";
const ALLOWING_UNSAFE: &str =
    "[package]\nname = \"member\"\nedition = \"2024\"\n\n[lints.rust]\nunsafe_code = \"allow\"\n";
const FORBIDDING_LOCALLY: &str =
    "[package]\nname = \"member\"\nedition = \"2024\"\n\n[lints.rust]\nunsafe_code = \"forbid\"\n";
const DOTTED_WORKSPACE_LINTS: &str =
    "[package]\nname = \"member\"\nedition = \"2024\"\nlints.workspace = true\n";
const INLINE_WORKSPACE_LINTS: &str =
    "[package]\nname = \"member\"\nedition = \"2024\"\nlints = { workspace = true }\n";

fn member(directory: &str, manifest: &str, sources: &[(&str, &str)]) -> CrateSource {
    CrateSource {
        directory: directory.to_string(),
        manifest: manifest.to_string(),
        sources: sources
            .iter()
            .map(|(path, text)| SourceFile {
                path: (*path).to_string(),
                text: (*text).to_string(),
            })
            .collect(),
    }
}

/// The bridge relaxing `unsafe`, and one crate that inherits: a tree with every boundary holding.
fn clean_crates() -> Vec<CrateSource> {
    vec![
        member(BRIDGE_CRATE, ALLOWING_UNSAFE, &[]),
        member("nozoki-core", INHERITING, &[]),
    ]
}

fn names_the_crate(violations: &[String], directory: &str) -> bool {
    violations
        .iter()
        .any(|violation| violation.contains(&format!("crate {directory}")))
}

#[test]
fn test_real_tree_holds_every_boundary() {
    let (root_manifest, crates) = read_real_tree().expect("the real tree can be read");

    let violations = boundary_violations(&root_manifest, &crates);

    assert!(
        violations.is_empty(),
        "boundary violations: {violations:#?}"
    );
}

#[test]
fn test_root_manifest_without_forbid_fails() {
    let violations = boundary_violations(ROOT_WITHOUT_FORBID, &clean_crates());

    assert!(
        violations
            .iter()
            .any(|violation| violation.contains("root manifest")),
        "no violation names the root manifest: {violations:#?}"
    );
}

#[test]
fn test_crate_that_stops_inheriting_workspace_lints_fails() {
    let crates = vec![
        member(BRIDGE_CRATE, ALLOWING_UNSAFE, &[]),
        member("nozoki-core", WITHOUT_LINTS, &[]),
    ];

    let violations = boundary_violations(ROOT_FORBIDDING, &crates);

    assert_eq!(violations.len(), 1, "{violations:#?}");
    assert!(
        names_the_crate(&violations, "nozoki-core"),
        "{violations:#?}"
    );
}

#[test]
fn test_other_crate_allowing_unsafe_fails() {
    let crates = vec![
        member(BRIDGE_CRATE, ALLOWING_UNSAFE, &[]),
        member("nozoki-core", ALLOWING_UNSAFE, &[]),
    ];

    let violations = boundary_violations(ROOT_FORBIDDING, &crates);

    assert_eq!(violations.len(), 1, "{violations:#?}");
    assert!(
        names_the_crate(&violations, "nozoki-core"),
        "{violations:#?}"
    );
}

#[test]
fn test_bridge_allowing_unsafe_passes() {
    let violations = boundary_violations(ROOT_FORBIDDING, &clean_crates());

    assert!(violations.is_empty(), "{violations:#?}");
}

#[test]
fn test_crate_forbidding_unsafe_locally_passes() {
    let crates = vec![
        member(BRIDGE_CRATE, ALLOWING_UNSAFE, &[]),
        member("nozoki-core", FORBIDDING_LOCALLY, &[]),
    ];

    let violations = boundary_violations(ROOT_FORBIDDING, &crates);

    assert!(violations.is_empty(), "{violations:#?}");
}

#[test]
fn test_unrecognized_lints_form_fails() {
    for manifest in [DOTTED_WORKSPACE_LINTS, INLINE_WORKSPACE_LINTS] {
        let crates = vec![
            member(BRIDGE_CRATE, ALLOWING_UNSAFE, &[]),
            member("nozoki-core", manifest, &[]),
        ];

        let violations = boundary_violations(ROOT_FORBIDDING, &crates);

        assert_eq!(violations.len(), 1, "{manifest}: {violations:#?}");
        assert!(
            names_the_crate(&violations, "nozoki-core"),
            "{manifest}: {violations:#?}"
        );
    }
}

fn violations_for_source_in(directory: &str, path: &str, text: &str) -> Vec<String> {
    let crates = vec![
        member(BRIDGE_CRATE, ALLOWING_UNSAFE, &[]),
        member(directory, INHERITING, &[(path, text)]),
    ];
    boundary_violations(ROOT_FORBIDDING, &crates)
}

#[test]
fn test_set_logger_in_another_crates_src_fails() {
    let violations = violations_for_source_in(
        "nozoki-core",
        "src/lib.rs",
        "fn start() {\n    log::set_logger(&WRITER).unwrap();\n}\n",
    );

    assert_eq!(violations.len(), 1, "{violations:#?}");
    assert!(
        names_the_crate(&violations, "nozoki-core"),
        "{violations:#?}"
    );
}

#[test]
fn test_set_boxed_logger_in_another_crates_src_fails() {
    let violations = violations_for_source_in(
        "nozoki-core",
        "src/lib.rs",
        "fn start() {\n    log::set_boxed_logger(Box::new(Writer)).unwrap();\n}\n",
    );

    assert_eq!(violations.len(), 1, "{violations:#?}");
    assert!(
        names_the_crate(&violations, "nozoki-core"),
        "{violations:#?}"
    );
}

#[test]
fn test_aliased_set_logger_import_fails() {
    let violations = violations_for_source_in(
        "nozoki-core",
        "src/session.rs",
        "use log::set_logger as install;\n",
    );

    assert_eq!(violations.len(), 1, "{violations:#?}");
    assert!(
        names_the_crate(&violations, "nozoki-core"),
        "{violations:#?}"
    );
}

#[test]
fn test_set_logger_in_the_bridge_passes() {
    let crates = vec![
        member(
            BRIDGE_CRATE,
            ALLOWING_UNSAFE,
            &[("src/log_writer.rs", "    log::set_logger(writer)?;\n")],
        ),
        member("nozoki-core", INHERITING, &[]),
    ];

    let violations = boundary_violations(ROOT_FORBIDDING, &crates);

    assert!(violations.is_empty(), "{violations:#?}");
}

#[test]
fn test_set_logger_in_another_crates_tests_passes() {
    let violations = violations_for_source_in(
        "nozoki-core",
        "tests/failure_log.rs",
        "    log::set_logger(&CAPTURE).expect(\"no other logger\");\n",
    );

    assert!(violations.is_empty(), "{violations:#?}");
}

#[test]
fn test_set_logger_in_a_line_comment_passes() {
    let violations = violations_for_source_in(
        "nozoki-core",
        "src/lib.rs",
        "// log::set_logger belongs to the bridge\nfn quiet() {} // never set_boxed_logger here\n",
    );

    assert!(violations.is_empty(), "{violations:#?}");
}

// Added by the code-integrity review. CP-124 fails when another crate calls a logger installer in its
// sources; the `//` exclusion exists for comments (test_set_logger_in_a_line_comment_passes), and a `//`
// inside a string literal starts no comment.

#[test]
fn test_set_logger_after_a_url_in_a_string_fails() {
    let violations = violations_for_source_in(
        "nozoki-core",
        "src/lib.rs",
        "fn start() {\n    let origin = \"http://x\"; log::set_logger(&WRITER).unwrap();\n}\n",
    );

    assert_eq!(violations.len(), 1, "{violations:#?}");
    assert!(
        names_the_crate(&violations, "nozoki-core"),
        "{violations:#?}"
    );
}

#[test]
fn test_set_logger_in_a_comment_after_a_url_in_a_string_passes() {
    let violations = violations_for_source_in(
        "nozoki-core",
        "src/lib.rs",
        "fn start() {\n    let origin = \"http://x\"; // never log::set_logger here\n}\n",
    );

    assert!(violations.is_empty(), "{violations:#?}");
}

#[test]
fn test_other_crate_denying_unsafe_fails() {
    let denying = "[package]\nname = \"member\"\nedition = \"2024\"\n\n[lints.rust]\nunsafe_code = \"deny\"\n";
    let crates = vec![
        member(BRIDGE_CRATE, ALLOWING_UNSAFE, &[]),
        member("nozoki-core", denying, &[]),
    ];

    let violations = boundary_violations(ROOT_FORBIDDING, &crates);

    assert_eq!(violations.len(), 1, "{violations:#?}");
    assert!(
        names_the_crate(&violations, "nozoki-core"),
        "{violations:#?}"
    );
}

#[test]
fn test_crate_inheriting_from_a_root_that_does_not_forbid_fails() {
    let violations = boundary_violations(ROOT_WITHOUT_FORBID, &clean_crates());

    assert!(
        names_the_crate(&violations, "nozoki-core"),
        "an inheriting crate under a root that does not forbid is not named: {violations:#?}"
    );
}

#[test]
fn test_no_crate_found_fails() {
    let violations = boundary_violations(ROOT_FORBIDDING, &[]);

    assert!(!violations.is_empty());
}

#[test]
fn test_no_bridge_found_fails() {
    let crates = vec![
        member("nozoki-core", INHERITING, &[]),
        member("nozoki-other", INHERITING, &[]),
    ];

    let violations = boundary_violations(ROOT_FORBIDDING, &crates);

    assert!(!violations.is_empty());
}

#[test]
fn test_no_other_crate_found_fails() {
    let crates = vec![member(BRIDGE_CRATE, ALLOWING_UNSAFE, &[])];

    let violations = boundary_violations(ROOT_FORBIDDING, &crates);

    assert!(!violations.is_empty());
}
