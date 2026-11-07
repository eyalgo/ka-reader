//! Layer 2: `Session::asset_bytes` over real folders and the real containment check. The answer is a
//! contained bitmap's exact bytes or a refusal, and the check is asked afresh on every call, so a file
//! that changes between two calls changes the answer (CP-1086 – CP-1088).
//!
//! Run them with `cargo test --locked -p ka-reader-bridge --test asset_bytes`.

#[allow(
    dead_code,
    reason = "each test crate uses a subset of the shared helpers"
)]
mod common;

use std::fs;

use common::TempDir;
use ka_reader_bridge::session::Session;

/// The eight bytes every PNG file begins with. They are not UTF-8, so a byte answer that went through
/// text would not give them back.
const PNG_SIGNATURE: [u8; 8] = [0x89, b'P', b'N', b'G', 0x0D, 0x0A, 0x1A, 0x0A];

/// A folder holding the PNG, an SVG and a link out, opened by a session, with the folder the link
/// leads to kept alive beside them.
struct Scene {
    folder: TempDir,
    outside: TempDir,
    session: Session,
}

fn scene() -> Scene {
    let folder = TempDir::new();
    let outside = TempDir::new();
    let target = outside.write_file("secret.png", "not for the page");
    folder.write_bytes("logo.png", &PNG_SIGNATURE);
    folder.write_file(
        "diagram.svg",
        "<svg xmlns=\"http://www.w3.org/2000/svg\"/>\n",
    );
    folder.make_link("escape.png", target);
    let session = Session::default();
    session.open(folder.path().to_path_buf());
    Scene {
        folder,
        outside,
        session,
    }
}

#[test]
fn test_asset_bytes_gives_the_in_folder_pngs_exact_bytes_twice() {
    let scene = scene();

    for call in ["first", "second"] {
        assert_eq!(
            scene.session.asset_bytes("logo.png"),
            Some(PNG_SIGNATURE.to_vec()),
            "the {call} call"
        );
    }
}

#[test]
fn test_asset_bytes_refuses_each_escaping_or_non_bitmap_path_the_same_twice() {
    let scene = scene();
    let absolute = scene.folder.path().join("logo.png");

    for refused in [
        "diagram.svg",
        "../outside.png",
        "escape.png",
        absolute.to_str().expect("the path is text"),
    ] {
        for call in ["first", "second"] {
            assert_eq!(
                scene.session.asset_bytes(refused),
                None,
                "{refused}, the {call} call"
            );
        }
    }
}

#[test]
fn test_asset_bytes_asks_the_check_again_after_the_file_became_a_symlink_out() {
    let scene = scene();
    assert_eq!(
        scene.session.asset_bytes("logo.png"),
        Some(PNG_SIGNATURE.to_vec()),
        "before the swap"
    );
    let outside_png = scene.outside.write_file("other.png", "outside the folder");
    fs::remove_file(scene.folder.path().join("logo.png")).expect("the file is removed");
    scene.folder.make_link("logo.png", outside_png);

    assert_eq!(
        scene.session.asset_bytes("logo.png"),
        None,
        "after the swap"
    );
}

#[test]
fn test_asset_bytes_answers_bytes_once_a_refused_path_becomes_a_contained_png() {
    let scene = scene();
    assert_eq!(
        scene.session.asset_bytes("later.png"),
        None,
        "while missing"
    );
    scene.folder.write_bytes("later.png", &PNG_SIGNATURE);

    assert_eq!(
        scene.session.asset_bytes("later.png"),
        Some(PNG_SIGNATURE.to_vec()),
        "once written"
    );
}

#[test]
fn test_asset_bytes_with_no_folder_open_is_a_refusal() {
    let session = Session::default();

    assert_eq!(session.asset_bytes("logo.png"), None);
}
