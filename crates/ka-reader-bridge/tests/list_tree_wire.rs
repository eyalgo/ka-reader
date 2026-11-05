//! Layer 2: the listing across the bridge, over a temporary folder holding the name table. The
//! answer is one JSON object tagged by `state`, and a file entry names its language in the closed
//! set while a folder entry names none. The committed wire file is the one the shell's suite
//! decodes and draws, so the two ends are held to the same bytes.

#[allow(
    dead_code,
    reason = "each test crate uses a subset of the shared helpers"
)]
mod common;

use std::fs;
use std::path::PathBuf;

use common::TempDir;
use ka_reader_bridge::session::{Session, TreeAct};

/// Every file the name table sends to a floor language, the six floor names first, then their
/// alternate extensions, a mixed-case spelling and a name whose last extension decides.
/// `Build.YmL` is the mixed-case yaml spelling: `Deploy.YmL` cannot sit beside `deploy.yml` on a
/// case-insensitive volume. A name that is not UTF-8 is left out, its wire name being lossy.
const FLOOR_NAMES: [&str; 18] = [
    "setup.sh",
    "app.py",
    "index.js",
    "package.json",
    "deploy.yml",
    "Cargo.toml",
    "stubs.pyi",
    "gui.pyw",
    "x.bash",
    "x.zsh",
    "index.mjs",
    "index.cjs",
    "App.jsx",
    "ci.yaml",
    "Build.YmL",
    "RUN.SH",
    "x.Py",
    "archive.tar.json",
];

/// Every file the name table sends to plain: outside the set, no extension, Markdown, a last
/// extension that is not a floor one, and an extension case folding does not reach.
const PLAIN_NAMES: [&str; 12] = [
    "notes.txt",
    "main.rs",
    "README",
    "Makefile",
    ".bashrc",
    ".py",
    "notes.",
    "README.md",
    "guide.markdown",
    "notes.MARKDOWN",
    "x.ſh",
    "Makefile.py.bak",
];

/// CP-318 – CP-321: the name table's listing, serialized through the real core, answers byte for
/// byte the wire file the shell's suite decodes. The folder `scripts.py` carries no language and
/// the link `gone.py`, whose target is missing, is a failed file that still carries Python.
#[test]
fn test_list_tree_answers_the_name_table_listing_byte_for_byte() {
    let folder = TempDir::new();
    for name in FLOOR_NAMES.into_iter().chain(PLAIN_NAMES) {
        folder.write_file(name, "");
    }
    folder.make_folder("scripts.py");
    folder.make_link("gone.py", "nowhere");
    let session = Session::default();
    session.open(folder.path().to_path_buf());
    let committed = fs::read_to_string(
        PathBuf::from(env!("CARGO_MANIFEST_DIR")).join("tests/fixtures/list_tree_name_table.json"),
    )
    .expect("the shared wire file exists");

    let serialized = serde_json::to_string(&session.list("", Some(TreeAct::Expand)))
        .expect("the answer serializes");

    assert_eq!(serialized, committed);
}
