//! Cargo entry point for the read-only harness's list_tree/select_file walk.
//!
//! The harness logic lives with its owning part (docs/SDD.md § 3, read-only-harness).
//! This test-only target keeps the command consumed by checks/read-only.sh stable.

#[path = "../../../checks/walk.rs"]
mod walk;

fn main() -> Result<(), String> {
    walk::run()
}
