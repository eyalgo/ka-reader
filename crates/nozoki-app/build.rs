//! Declares the app manifest: the two commands S-1 registers, and nothing else.
//!
//! Without a manifest Tauri does not check a local origin's app commands against a capability at
//! all (`tauri-2.11.5/src/webview/mod.rs:L1819-L1826`), so this is what makes the grant in
//! `capabilities/` bite. Naming the commands here generates the permissions `allow-open-folder` and
//! `allow-list-tree` that the capability grants (`tauri-utils-2.9.3/src/acl/build.rs:L290-L296`).

use tauri_build::{AppManifest, Attributes};

fn main() {
    tauri_build::try_build(
        Attributes::new().app_manifest(AppManifest::new().commands(&["open_folder", "list_tree"])),
    )
    .expect("the Tauri build script must succeed");
}
