//! Layer 2 — the host's configuration, read as data.
//!
//! `tauri.conf.json` and the entitlements file are what the bundle is built from, so a regression in
//! either shows here at `cargo test` time, before `checks/bundle.sh` runs on the built artifact.
//! Every test reads the same files the bundler reads, and none launches anything.
//!
//! The records these hold: `docs/SDD.md` C-R2 (the two entitlements) and C-R7 (the Content Security
//! Policy), and `docs/nfdr.md` QC-23 (the CSP), QC-24 (the empty grant) and QC-36 (no plugin).

use std::collections::BTreeSet;
use std::fs;
use std::path::{Path, PathBuf};

use serde_json::Value;

/// The declared Content Security Policy: C-R7's string with the unsettled `<asset-scheme>` token
/// left out. The change serves no asset yet, so `img-src` needs no scheme.
const DECLARED_CSP: &str = "default-src 'none'; script-src 'self'; style-src 'self'; img-src 'self' data:; font-src 'self'";

/// A Content Security Policy source that would let the renderer reach beyond the bundle (QC-23).
const FORBIDDEN_SOURCES: [&str; 5] = ["http:", "https:", "file:", "asset:", "*"];

const APP_SANDBOX_ENTITLEMENT: &str = "com.apple.security.app-sandbox";
const USER_SELECTED_READ_ONLY_ENTITLEMENT: &str =
    "com.apple.security.files.user-selected.read-only";

fn crate_dir() -> PathBuf {
    PathBuf::from(env!("CARGO_MANIFEST_DIR"))
}

fn read_crate_file(relative: impl AsRef<Path>) -> String {
    let path = crate_dir().join(relative);
    fs::read_to_string(&path)
        .unwrap_or_else(|error| panic!("{} must be readable: {error}", path.display()))
}

fn config() -> Value {
    serde_json::from_str(&read_crate_file("tauri.conf.json"))
        .expect("tauri.conf.json is the host's own file and must be valid JSON")
}

fn macos_bundle_setting(config: &Value, key: &str) -> Value {
    config["bundle"]["macOS"][key].clone()
}

fn declared_csp(config: &Value) -> String {
    config["app"]["security"]["csp"]
        .as_str()
        .expect("app.security.csp must be declared as one string")
        .to_owned()
}

/// Every forbidden source found in any directive of `csp`, as `(directive, source)`.
fn forbidden_sources_in(csp: &str) -> Vec<(String, &'static str)> {
    csp.split(';')
        .map(str::trim)
        .filter(|directive| !directive.is_empty())
        .flat_map(|directive| {
            FORBIDDEN_SOURCES
                .iter()
                .filter(move |forbidden| directive.contains(**forbidden))
                .map(move |forbidden| (directive.to_owned(), *forbidden))
        })
        .collect()
}

const DEPENDENCY_TABLES: [&str; 3] = ["dependencies", "dev-dependencies", "build-dependencies"];

/// Every dependency named `tauri-plugin-*` in `manifest`, in any dependency table, target-specific
/// ones included.
fn plugin_crates_in(manifest: &str) -> Vec<String> {
    let manifest: toml::Table = manifest
        .parse()
        .expect("a Cargo manifest must be valid TOML");

    let target_tables = manifest
        .get("target")
        .and_then(toml::Value::as_table)
        .into_iter()
        .flat_map(|targets| targets.values())
        .filter_map(toml::Value::as_table);

    std::iter::once(&manifest)
        .chain(target_tables)
        .flat_map(|table| DEPENDENCY_TABLES.iter().filter_map(|name| table.get(*name)))
        .filter_map(toml::Value::as_table)
        .flat_map(|dependencies| dependencies.keys())
        .filter(|name| name.starts_with("tauri-plugin-"))
        .cloned()
        .collect()
}

fn is_absent_or_empty(value: &Value) -> bool {
    match value {
        Value::Null => true,
        Value::Array(items) => items.is_empty(),
        Value::Object(members) => members.is_empty(),
        _ => false,
    }
}

#[test]
fn identifier_is_com_kensaiapp_nozoki() {
    assert_eq!(config()["identifier"], "com.kensaiapp.nozoki");
}

#[test]
fn product_name_is_nozoki() {
    assert_eq!(config()["productName"], "Nozoki");
}

#[test]
fn minimum_system_version_is_14_0() {
    assert_eq!(
        macos_bundle_setting(&config(), "minimumSystemVersion"),
        "14.0"
    );
}

#[test]
fn signing_identity_is_ad_hoc() {
    assert_eq!(macos_bundle_setting(&config(), "signingIdentity"), "-");
}

#[test]
fn bundle_target_is_app_only() {
    // The `.dmg` is out of this change's scope: the bundle command writes `Nozoki.app` and nothing
    // else (tl_instruction Task 2, *What to build*; Task 3, "and no `.dmg`").
    assert_eq!(config()["bundle"]["targets"], serde_json::json!(["app"]));
}

#[test]
fn entitlements_file_is_configured_and_exists() {
    let configured = macos_bundle_setting(&config(), "entitlements");
    let relative = configured
        .as_str()
        .expect("bundle.macOS.entitlements must name a file");

    assert!(
        crate_dir().join(relative).is_file(),
        "{relative} is named by bundle.macOS.entitlements and must exist beside tauri.conf.json"
    );
}

#[test]
fn entitlements_file_declares_exactly_the_two_c_r2_keys_as_true() {
    let configured = macos_bundle_setting(&config(), "entitlements");
    let relative = configured
        .as_str()
        .expect("bundle.macOS.entitlements must name a file");
    let entitlements = plist::Value::from_file(crate_dir().join(relative))
        .expect("the entitlements file must be a valid property list")
        .into_dictionary()
        .expect("the entitlements file's root must be a dictionary");

    let mut declared: Vec<(&str, Option<bool>)> = entitlements
        .iter()
        .map(|(key, value)| (key.as_str(), value.as_boolean()))
        .collect();
    declared.sort_unstable();

    assert_eq!(
        declared,
        [
            (APP_SANDBOX_ENTITLEMENT, Some(true)),
            (USER_SELECTED_READ_ONLY_ENTITLEMENT, Some(true)),
        ]
    );
}

#[test]
fn exactly_one_window_is_configured() {
    let windows = config()["app"]["windows"]
        .as_array()
        .expect("app.windows must be a list")
        .len();

    assert_eq!(windows, 1);
}

#[test]
fn declared_csp_equals_the_c_r7_string_without_the_asset_scheme() {
    assert_eq!(declared_csp(&config()), DECLARED_CSP);
}

#[test]
fn no_csp_directive_admits_a_forbidden_source() {
    assert_eq!(forbidden_sources_in(&declared_csp(&config())), []);
}

#[test]
fn the_forbidden_source_detector_flags_each_forbidden_token() {
    // The test above passes on an empty answer, so it is worth nothing unless the detector can
    // give a non-empty one.
    for forbidden in FORBIDDEN_SOURCES {
        let csp = format!("default-src 'none'; connect-src {forbidden}example");

        assert_eq!(
            forbidden_sources_in(&csp),
            [(format!("connect-src {forbidden}example"), forbidden)]
        );
    }
}

#[test]
fn no_dev_url_is_configured() {
    // A `devUrl` is an http origin that ships inside the embedded configuration, and the plain
    // `cargo build` profile would load it (`tauri-codegen` `context.rs`: `dev && dev_url`).
    assert!(is_absent_or_empty(&config()["build"]["devUrl"]));
}

#[test]
fn frontend_dist_is_supplied_by_the_bundle_command_not_the_committed_config() {
    // `tauri-codegen` panics at compile time when a configured `frontendDist` directory does not
    // exist, and `nozoki-ui/dist` is gitignored. Leaving the key out is what lets `cargo build`
    // and `cargo test` succeed on a clean clone; only the bundle command passes it, after the
    // renderer build. CI builds the renderer first, so only this assertion holds that property
    // there.
    assert!(is_absent_or_empty(&config()["build"]["frontendDist"]));
}

#[test]
fn no_plugin_is_configured() {
    assert!(is_absent_or_empty(&config()["plugins"]));
}

/// The two commands S-1 grants, by the permission identifiers Tauri generates for them.
const GRANTED_PERMISSIONS: [&str; 2] = ["allow-open-folder", "allow-list-tree"];

/// The two commands the app manifest names, as the renderer invokes them.
const GRANTED_COMMANDS: [&str; 2] = ["open_folder", "list_tree"];

/// Every file in `capabilities/`, in no particular order.
fn capability_files() -> Vec<PathBuf> {
    let directory = crate_dir().join("capabilities");
    fs::read_dir(&directory)
        .unwrap_or_else(|error| panic!("{} must be readable: {error}", directory.display()))
        .map(|entry| entry.expect("a directory entry is readable").path())
        .collect()
}

/// The one capability file, parsed. Fails when there is not exactly one.
fn the_capability() -> Value {
    let files = capability_files();
    assert_eq!(
        files.len(),
        1,
        "capabilities/ must hold one file: {files:?}"
    );
    let text = fs::read_to_string(&files[0])
        .unwrap_or_else(|error| panic!("{} must be readable: {error}", files[0].display()));
    serde_json::from_str(&text).expect("the capability file must be valid JSON")
}

/// A JSON array of strings, as a set. Panics on any element that is not a plain string, so a
/// permission carrying a scope object cannot slip past a set comparison.
fn string_set(value: &Value) -> BTreeSet<String> {
    value
        .as_array()
        .unwrap_or_else(|| panic!("expected an array, got {value}"))
        .iter()
        .map(|element| {
            element
                .as_str()
                .unwrap_or_else(|| panic!("expected a plain string, got {element}"))
                .to_owned()
        })
        .collect()
}

fn owned_set(names: &[&str]) -> BTreeSet<String> {
    names.iter().map(|name| (*name).to_owned()).collect()
}

/// The command names `build.rs` passes to the app manifest, read from its text: every quoted string
/// between `commands(&[` and the `]` that closes it.
fn commands_declared_in(build_script: &str) -> BTreeSet<String> {
    let after = build_script
        .split("commands(&[")
        .nth(1)
        .expect("build.rs must declare the app manifest's commands");
    let list = after
        .split(']')
        .next()
        .expect("the commands list must be closed");
    list.split('"')
        .enumerate()
        .filter(|(index, _)| index % 2 == 1)
        .map(|(_, name)| name.to_owned())
        .collect()
}

#[test]
fn capabilities_are_not_declared_in_the_config() {
    let declared = &config()["app"]["security"]["capabilities"];
    assert!(
        is_absent_or_empty(declared),
        "capabilities are declared in tauri.conf.json, so capabilities/ would not be what is read: {declared}"
    );
}

#[test]
fn exactly_one_capability_file_is_on_disk() {
    assert_eq!(capability_files().len(), 1);
}

#[test]
fn the_capability_grants_exactly_the_two_commands() {
    assert_eq!(
        string_set(&the_capability()["permissions"]),
        owned_set(&GRANTED_PERMISSIONS)
    );
}

#[test]
fn the_capability_names_no_core_or_plugin_permission() {
    let permissions = string_set(&the_capability()["permissions"]);

    // A `core:` permission and a `<plugin>:` permission both carry a colon; an app permission never does.
    let outside_the_app: Vec<&String> = permissions
        .iter()
        .filter(|permission| permission.contains(':'))
        .collect();

    assert!(
        outside_the_app.is_empty(),
        "core or plugin permissions: {outside_the_app:?}"
    );
}

#[test]
fn the_capability_applies_to_the_main_window_only() {
    assert_eq!(
        string_set(&the_capability()["windows"]),
        owned_set(&["main"])
    );
}

#[test]
fn the_app_manifest_names_exactly_the_two_commands() {
    assert_eq!(
        commands_declared_in(&read_crate_file("build.rs")),
        owned_set(&GRANTED_COMMANDS)
    );
}

#[test]
fn the_command_reader_finds_every_quoted_name_and_no_other_text() {
    // The assertion above passes on an empty answer if the reader finds nothing.
    let script =
        r#"fn main() { build(AppManifest::new().commands(&["one_two", "three"])); "other" }"#;

    assert_eq!(
        commands_declared_in(script),
        owned_set(&["one_two", "three"])
    );
}

#[test]
fn no_tauri_plugin_crate_in_the_manifest() {
    assert_eq!(
        plugin_crates_in(&read_crate_file("Cargo.toml")),
        Vec::<String>::new()
    );
}

#[test]
fn the_plugin_crate_detector_flags_a_plugin_in_every_dependency_table() {
    // Same reason as the CSP detector's test: the assertion above passes on an empty answer.
    let manifest = r#"
        [dependencies]
        tauri-plugin-shell = "2"
        [dev-dependencies]
        tauri-plugin-fs = "2"
        [build-dependencies]
        tauri-plugin-os = "2"
        [target.'cfg(target_os = "macos")'.dependencies]
        tauri-plugin-dialog = "2"
        [dependencies.serde]
        version = "1"
    "#;

    assert_eq!(
        plugin_crates_in(manifest),
        [
            "tauri-plugin-shell",
            "tauri-plugin-fs",
            "tauri-plugin-os",
            "tauri-plugin-dialog"
        ]
    );
}
