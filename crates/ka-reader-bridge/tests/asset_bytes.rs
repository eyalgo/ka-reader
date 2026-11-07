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

use std::ffi::CString;
use std::fs;
use std::ptr;

use common::TempDir;
use ka_reader_bridge::boundary::asset_answer;
use ka_reader_bridge::exports::{ka_reader_asset_bytes, ka_reader_free};
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

#[test]
fn test_asset_answer_refuses_a_null_an_empty_and_a_non_utf8_path_without_reaching_the_session() {
    let scene = scene();
    let empty = CString::new("").expect("no interior NUL");
    let non_utf8 = CString::new(vec![b'l', 0xFF, b'.', b'p', b'n', b'g']).expect("no interior NUL");
    let valid = CString::new("logo.png").expect("no interior NUL");

    // SAFETY: each pointer is NULL or a live NUL-terminated string for the call.
    let answers = unsafe {
        [
            asset_answer(&scene.session, ptr::null()),
            asset_answer(&scene.session, empty.as_ptr()),
            asset_answer(&scene.session, non_utf8.as_ptr()),
        ]
    };

    assert_eq!(answers, [None, None, None]);
    // SAFETY: `valid` is a live NUL-terminated string for the call.
    let control = unsafe { asset_answer(&scene.session, valid.as_ptr()) };
    assert_eq!(control, Some(PNG_SIGNATURE.to_vec()), "a valid path reaches it");
}

/// The only test of this target that reaches the process-global session, so no folder is open in it.
#[test]
fn test_the_asset_export_with_no_folder_open_answers_a_refusal_buffer() {
    let path = CString::new("logo.png").expect("no interior NUL");

    // SAFETY: `path` is a live NUL-terminated string for the call.
    let buffer = unsafe { ka_reader_asset_bytes(path.as_ptr()) };

    assert!(!buffer.is_null(), "a refusal is a buffer, not the failure value");
    // SAFETY: the buffer was returned a moment ago, is read before the free and freed once.
    unsafe {
        assert!((*buffer).bytes.is_null(), "a refusal has NULL bytes");
        assert_eq!((*buffer).len, 0);
        ka_reader_free(buffer);
    }
}
