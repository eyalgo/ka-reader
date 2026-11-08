//! Layer 2: the hostile corpus (`checks/fixtures/hostile.md`) read through `select_file`, a
//! `FolderModel` open and `read_file`, over folders the test makes. Each hostile piece must reach
//! the document as inert text or as a placeholder, and no route may differ from another
//! (CP-1073 – CP-1077).

#[allow(
    dead_code,
    reason = "each test crate uses a subset of the shared helpers"
)]
mod common;

use std::os::unix::fs::PermissionsExt as _;
use std::path::{Path, PathBuf};

use common::TempDir;
use ka_reader_core::{
    Block, FileRequest, FileView, FolderContainment, FolderModel, ImageTarget, Inline, ItemState,
    Language, LinkTarget, MarkdownDocument, OpenedFolder, PathReports, PlaceholderCondition,
    ReadingPosition, TreeRequest, asset_bytes, link_file, open_folder, read_file, select_file,
};

/// The eight bytes every PNG file begins with, then nothing a decoder is asked about: the renderer
/// reads no byte of the image, so the signature is all the test needs the file to be.
const PNG_SIGNATURE: [u8; 8] = [0x89, b'P', b'N', b'G', 0x0D, 0x0A, 0x1A, 0x0A];

/// One piece of CP-1073: its name, and the source text the corpus holds for it.
struct Piece {
    name: &'static str,
    source: &'static str,
}

/// The twelve pieces, each with the text of `checks/fixtures/hostile.md` that is that piece.
const PIECES: [Piece; 12] = [
    Piece {
        name: "script",
        source: "<script>alert(1)</script>",
    },
    Piece {
        name: "event attribute",
        source: "<b onclick=\"steal()\">",
    },
    Piece {
        name: "frame",
        source: "<iframe src=\"https://example.com/frame\"></iframe>",
    },
    Piece {
        name: "style",
        source: "<style>body { display: none }</style>",
    },
    Piece {
        name: "html block",
        source: "<div class=\"box\">\nraw block content\n</div>",
    },
    Piece {
        name: "remote image",
        source: "![remote](https://example.com/remote.png)",
    },
    Piece {
        name: "png image",
        source: "![logo](logo.png)",
    },
    Piece {
        name: "svg image",
        source: "![diagram](diagram.svg)",
    },
    Piece {
        name: "climb image",
        source: "![climb](../outside.png)",
    },
    Piece {
        name: "symlink-out image",
        source: "![escape](escape.png)",
    },
    Piece {
        name: "external link",
        source: "[example](https://example.com/page)",
    },
    Piece {
        name: "relative link",
        source: "[other](other.md)",
    },
];

fn corpus_source() -> String {
    std::fs::read_to_string(
        PathBuf::from(env!("CARGO_MANIFEST_DIR")).join("../../checks/fixtures/hostile.md"),
    )
    .expect("the committed corpus reads")
}

/// A folder holding the corpus and the files its references name: the PNG, the SVG, the link whose
/// target lies outside (`outside` holds that target), and the relative link's file.
struct Scene {
    folder: TempDir,
    _outside: TempDir,
}

fn scene() -> Scene {
    let folder = TempDir::new();
    let outside = TempDir::new();
    let target = outside.write_file("secret.png", "not for the page");
    folder.write_file("hostile.md", &corpus_source());
    folder.write_bytes("logo.png", &PNG_SIGNATURE);
    folder.write_file(
        "diagram.svg",
        "<svg xmlns=\"http://www.w3.org/2000/svg\"/>\n",
    );
    folder.make_link("escape.png", target);
    folder.write_file("other.md", "# Other\n");
    Scene {
        folder,
        _outside: outside,
    }
}

fn document_of(answer: ItemState<FileView>) -> MarkdownDocument {
    match answer {
        ItemState::Observed(FileView::Markdown(document)) => document,
        other => panic!("expected a document, got {other:?}"),
    }
}

/// Every inline node of `blocks`, depth first, and every code block met on the way.
#[derive(Default)]
struct Walked {
    texts: Vec<String>,
    images: Vec<(String, ImageTarget)>,
    links: Vec<(String, LinkTarget)>,
    code_spans: usize,
}

/// The walk names every kind of the closed set and no other: a new kind is a compile error here.
fn walk_blocks(blocks: &[Block], walked: &mut Walked) {
    for block in blocks {
        match block {
            Block::Heading { content, .. } | Block::Paragraph(content) => {
                walk_inlines(content, walked);
            }
            Block::List { items, .. } => {
                for item in items {
                    walk_blocks(item, walked);
                }
            }
            Block::Quote(inner) => walk_blocks(inner, walked),
            Block::Rule => {}
            Block::Code { spans, .. } => walked.code_spans += spans.len(),
        }
    }
}

fn walk_inlines(inlines: &[Inline], walked: &mut Walked) {
    for inline in inlines {
        match inline {
            Inline::Text(text) | Inline::Code(text) => walked.texts.push(text.clone()),
            Inline::Emphasis { content, .. } => walk_inlines(content, walked),
            Inline::Image { alt, target } => walked.images.push((alt.clone(), target.clone())),
            Inline::Link {
                content,
                destination,
                target,
            } => {
                walked.links.push((destination.clone(), target.clone()));
                walk_inlines(content, walked);
            }
        }
    }
}

fn walked(document: &MarkdownDocument) -> Walked {
    let mut walked = Walked::default();
    walk_blocks(&document.blocks, &mut walked);
    walked
}

/// CP-1076: the corpus holds all twelve pieces; the test fails naming any that is missing.
#[test]
fn test_the_hostile_corpus_has_every_piece() {
    let source = corpus_source();
    let scene = scene();

    let missing: Vec<&str> = PIECES
        .iter()
        .filter(|piece| !source.contains(piece.source))
        .map(|piece| piece.name)
        .collect();

    assert!(missing.is_empty(), "the corpus lacks: {missing:?}");
    for name in [
        "hostile.md",
        "logo.png",
        "diagram.svg",
        "escape.png",
        "other.md",
    ] {
        assert!(
            scene.folder.path().join(name).symlink_metadata().is_ok(),
            "the scene grants {name}"
        );
    }
}

#[test]
fn test_each_hostile_piece_is_inert_in_the_document() {
    let scene = scene();
    let opened = open_folder(scene.folder.path()).expect("the folder opens");

    let document = document_of(select_file(&opened, "hostile.md"));

    let walked = walked(&document);
    for piece in PIECES.iter().take(5) {
        assert!(
            walked.texts.iter().any(|text| text == piece.source),
            "{} is a text node holding its source verbatim: {:?}",
            piece.name,
            walked.texts
        );
    }
    let placeholder = |condition, source: &str| ImageTarget::Placeholder {
        condition,
        source: source.to_string(),
    };
    assert_eq!(
        walked.images,
        vec![
            (
                "remote".to_string(),
                placeholder(
                    PlaceholderCondition::OutsideTheFolder,
                    "https://example.com/remote.png"
                )
            ),
            (
                "logo".to_string(),
                ImageTarget::Resolved(PathBuf::from("logo.png"))
            ),
            (
                "diagram".to_string(),
                placeholder(PlaceholderCondition::FormatNotDecoded, "diagram.svg")
            ),
            (
                "climb".to_string(),
                placeholder(PlaceholderCondition::OutsideTheFolder, "../outside.png")
            ),
            (
                "escape".to_string(),
                placeholder(PlaceholderCondition::OutsideTheFolder, "escape.png")
            ),
        ]
    );
    assert_eq!(
        walked.links,
        vec![
            ("https://example.com/page".to_string(), LinkTarget::External),
            (
                "other.md".to_string(),
                LinkTarget::Relative(PathBuf::from("other.md"))
            ),
        ]
    );
}

/// CP-1075: every route gives one document, and none of them carries a span.
#[test]
fn test_every_route_gives_the_hostile_document_and_no_spans() {
    let scene = scene();
    let opened = open_folder(scene.folder.path()).expect("the folder opens");
    let by_select = select_file(&opened, "hostile.md");
    let by_read = read_file(&opened, Path::new("hostile.md")).answer().clone();
    let model = FolderModel::new(opened).select_file(FileRequest::Open(
        "hostile.md".into(),
        ReadingPosition::new(b"top".as_slice()),
    ));
    let by_open = model.open_file().expect("the file opens").view().clone();

    let document = document_of(by_select.clone());

    assert_eq!(by_read, by_select);
    assert_eq!(by_open, by_select);
    assert_eq!(walked(&document).code_spans, 0);
}

/// The renderer's fence table and the file reader's extension map name the same languages.
#[test]
fn test_a_fence_and_a_file_extension_agree_on_the_language() {
    const EXTENSIONS: [&str; 15] = [
        "py", "pyi", "pyw", "sh", "bash", "zsh", "js", "mjs", "cjs", "jsx", "json", "yaml", "yml",
        "toml", "PY",
    ];
    let folder = TempDir::new();
    for word in EXTENSIONS {
        folder.write_file(&format!("x.{word}"), "x\n");
        folder.write_file(&format!("fence-{word}.md"), &format!("```{word}\nx\n```\n"));
    }
    let opened = open_folder(folder.path()).expect("the folder opens");

    for word in EXTENSIONS {
        let ItemState::Observed(FileView::Text { language: file, .. }) =
            select_file(&opened, &format!("x.{word}"))
        else {
            panic!("x.{word} is text");
        };
        let document = document_of(select_file(&opened, &format!("fence-{word}.md")));

        assert_ne!(file, Language::Plain, "{word} names a floor language");
        assert!(
            matches!(&document.blocks[..], [Block::Code { language, .. }] if *language == file),
            "a fence of `{word}` takes {file:?}: {document:?}"
        );
    }
}

/// The document a file in `docs` makes of an image `img/a.png` and a link `../README.md`, read from
/// `docs`: both resolve. Read from the root instead, the image would be missing and the link outside.
fn image_and_link_from_docs(alt: &str) -> ItemState<FileView> {
    ItemState::Observed(FileView::Markdown(MarkdownDocument {
        blocks: vec![
            Block::Paragraph(vec![Inline::Image {
                alt: alt.to_string(),
                target: ImageTarget::Resolved(PathBuf::from("docs/img/a.png")),
            }]),
            Block::Paragraph(vec![Inline::Link {
                content: vec![Inline::Text("up".to_string())],
                destination: "../README.md".to_string(),
                target: LinkTarget::Relative(PathBuf::from("README.md")),
            }]),
        ],
    }))
}

fn image_and_link_source(alt: &str) -> String {
    format!("![{alt}](img/a.png)\n\n[up](../README.md)\n")
}

/// CP-1055 with CP-1068: every route that fills the open file reads a Markdown file's references
/// from the folder that holds it, so a file below the root resolves what it names beside it.
#[test]
fn test_every_route_reads_references_from_the_markdown_files_own_folder() {
    let folder = TempDir::new();
    folder.write_file("README.md", "# Top\n");
    folder.write_bytes("docs/img/a.png", &PNG_SIGNATURE);
    folder.write_file("docs/guide.md", &image_and_link_source("first"));
    let opened = open_folder(folder.path()).expect("the folder opens");
    let position = ReadingPosition::new(b"top".as_slice());

    assert_eq!(
        select_file(&opened, "docs/guide.md"),
        image_and_link_from_docs("first"),
        "select_file"
    );
    let read = read_file(&opened, Path::new("docs/guide.md"));
    assert_eq!(
        read.answer(),
        &image_and_link_from_docs("first"),
        "read_file"
    );

    let by_open = FolderModel::new(opened.clone())
        .select_file(FileRequest::Open("docs/guide.md".into(), position.clone()));
    assert_eq!(
        by_open.open_file().expect("open").view(),
        &image_and_link_from_docs("first"),
        "a FolderModel open"
    );

    let by_open_read = FolderModel::new(opened).open_read(read, position);
    assert_eq!(
        by_open_read.open_file().expect("open").view(),
        &image_and_link_from_docs("first"),
        "open_read"
    );

    folder.write_file("docs/guide.md", &image_and_link_source("second"));
    let root = by_open_read.folder().root().to_path_buf();
    let invalidated = by_open_read.list_tree(TreeRequest::Invalidate(PathReports::new(vec![
        root.join("docs/guide.md"),
    ])));
    assert_eq!(
        invalidated.open_file().expect("open").view(),
        &image_and_link_from_docs("second"),
        "a re-read by invalidation"
    );

    folder.write_file("docs/guide.md", &image_and_link_source("third"));
    let reread = invalidated.reread_open_file();
    assert_eq!(
        reread.open_file().expect("open").view(),
        &image_and_link_from_docs("third"),
        "reread_open_file"
    );
}

/// The real check over the opened folder's root, as the bridge's session builds it.
fn check_of(opened: &OpenedFolder) -> FolderContainment {
    FolderContainment::new(opened.root().to_path_buf())
}

/// The scene, opened, with the folder (`images`) and the unreadable file (`locked.png`) the byte
/// cases also ask about.
fn byte_scene() -> (Scene, OpenedFolder) {
    let scene = scene();
    std::fs::create_dir(scene.folder.path().join("images")).expect("the folder can be made");
    let locked = scene.folder.write_bytes("locked.png", &PNG_SIGNATURE);
    std::fs::set_permissions(&locked, std::fs::Permissions::from_mode(0o000))
        .expect("the file can be locked");
    let opened = open_folder(scene.folder.path()).expect("the folder opens");
    (scene, opened)
}

#[test]
fn test_asset_bytes_gives_a_contained_pngs_exact_bytes_twice() {
    let (_scene, opened) = byte_scene();
    let check = check_of(&opened);

    for call in ["first", "second"] {
        assert_eq!(
            asset_bytes(&opened, "logo.png", &check),
            Some(PNG_SIGNATURE.to_vec()),
            "the {call} call"
        );
    }
}

#[test]
fn test_asset_bytes_refuses_an_svg_a_climb_out_a_symlink_out_and_an_absolute_path() {
    let (scene, opened) = byte_scene();
    let check = check_of(&opened);
    let absolute = scene.folder.path().join("logo.png");

    for refused in [
        "diagram.svg",
        "../outside.png",
        "escape.png",
        absolute.to_str().expect("the path is text"),
    ] {
        assert_eq!(asset_bytes(&opened, refused, &check), None, "{refused}");
    }
}

#[test]
fn test_asset_bytes_refuses_a_folder_a_missing_entry_and_an_unreadable_file() {
    let (_scene, opened) = byte_scene();
    let check = check_of(&opened);

    for refused in ["images", "missing.png", "locked.png"] {
        assert_eq!(asset_bytes(&opened, refused, &check), None, "{refused}");
    }
}

#[test]
fn test_asset_bytes_judges_the_resolved_file_not_the_spelled_name() {
    let (scene, opened) = byte_scene();
    scene.folder.make_link("pic.png", "diagram.svg");

    assert_eq!(
        asset_bytes(&opened, "pic.png", &check_of(&opened)),
        None,
        "a bitmap name that reaches an SVG"
    );
}

#[test]
fn test_asset_bytes_reads_a_name_holding_a_percent_as_that_name() {
    let (scene, opened) = byte_scene();
    scene.folder.write_bytes("100%41.png", b"its own bytes");
    scene.folder.write_bytes("100A.png", b"the other file");

    assert_eq!(
        asset_bytes(&opened, "100%41.png", &check_of(&opened)),
        Some(b"its own bytes".to_vec())
    );
}

#[test]
fn test_asset_bytes_ignores_ascii_case_in_the_extension() {
    let (scene, opened) = byte_scene();
    let letter_case_is_ignored = scene.folder.path().join("LOGO.PNG").exists();

    let answer = asset_bytes(&opened, "LOGO.PNG", &check_of(&opened));

    if letter_case_is_ignored {
        assert_eq!(
            answer,
            Some(PNG_SIGNATURE.to_vec()),
            "a volume that ignores letter case gives logo.png's bytes"
        );
    } else {
        assert_eq!(
            answer, None,
            "a volume that keeps letter case has no LOGO.PNG"
        );
    }
}

#[test]
fn test_an_empty_path_is_refused_by_both_operations() {
    let (_scene, opened) = byte_scene();
    let check = check_of(&opened);

    assert_eq!(asset_bytes(&opened, "", &check), None);
    assert_eq!(link_file("", &check), None);
}

#[test]
fn test_link_file_gives_the_path_as_given_for_a_contained_file() {
    let (scene, opened) = byte_scene();
    scene.folder.write_file("src/main.rs", "fn main() {}\n");
    let check = check_of(&opened);

    assert_eq!(
        link_file("other.md", &check),
        Some(PathBuf::from("other.md"))
    );
    assert_eq!(
        link_file("src/main.rs", &check),
        Some(PathBuf::from("src/main.rs"))
    );
}

#[test]
fn test_link_file_refuses_what_is_not_a_contained_file() {
    let (scene, opened) = byte_scene();
    let check = check_of(&opened);
    let absolute = scene.folder.path().join("other.md");

    for refused in [
        "images",
        "../outside.md",
        "escape.png",
        absolute.to_str().expect("the path is text"),
        "missing.md",
    ] {
        assert_eq!(link_file(refused, &check), None, "{refused}");
    }
}

#[test]
fn test_link_file_reads_a_name_holding_a_percent_as_that_name() {
    let (scene, opened) = byte_scene();
    scene.folder.write_file("a%41.md", "# literal\n");

    assert_eq!(
        link_file("a%41.md", &check_of(&opened)),
        Some(PathBuf::from("a%41.md"))
    );
}

/// CP-1141 and CP-1145: a link whose path the real check reaches at a folder, directly or through a
/// symbolic link, is external and carries its destination exactly as written; one it reaches at a
/// file through a symbolic link stays relative and carries the path the check reached.
#[test]
fn test_a_link_the_check_reaches_at_a_folder_is_external_with_its_destination() {
    let folder = TempDir::new();
    folder.write_file("docs/guide.md", "# Guide\n");
    folder.write_file("src/main.md", "# Main\n");
    folder.make_link("lnk", "src");
    folder.write_file("real/guide.md", "# Real\n");
    folder.make_link("alias.md", "real/guide.md");
    folder.write_file(
        "links.md",
        "[d](docs) [d](docs/) [d](docs#part) [d](docs/#install) [alias](lnk) [guide](alias.md)\n",
    );
    let opened = open_folder(folder.path()).expect("the folder opens");

    let document = document_of(select_file(&opened, "links.md"));

    let targets: Vec<(String, LinkTarget)> = walked(&document).links;
    let external = |destination: &str| (destination.to_string(), LinkTarget::External);
    assert_eq!(
        targets,
        vec![
            external("docs"),
            external("docs/"),
            external("docs#part"),
            external("docs/#install"),
            external("lnk"),
            (
                "alias.md".to_string(),
                LinkTarget::Relative(PathBuf::from("real/guide.md"))
            ),
        ]
    );
}

#[test]
fn test_a_relative_link_nodes_target_fed_back_as_given_is_a_contained_file() {
    let (_scene, opened) = byte_scene();
    let document = document_of(select_file(&opened, "hostile.md"));
    let targets: Vec<PathBuf> = walked(&document)
        .links
        .into_iter()
        .filter_map(|(_, target)| match target {
            LinkTarget::Relative(path) => Some(path),
            LinkTarget::External => None,
        })
        .collect();
    assert_eq!(
        targets,
        vec![PathBuf::from("other.md")],
        "the corpus's relative link"
    );

    for target in targets {
        let as_given = target.to_str().expect("the target is text");
        assert_eq!(
            link_file(as_given, &check_of(&opened)),
            Some(target.clone()),
            "{as_given}"
        );
    }
}

#[test]
fn test_asset_bytes_answers_each_bitmap_format_in_any_letter_case_and_refuses_any_other_extension()
{
    let (scene, opened) = byte_scene();
    let check = check_of(&opened);
    // Each name is a file of its own, so no answer depends on whether the volume ignores letter case.
    let answered = [
        "shot.png",
        "shot.jpg",
        "shot.jpeg",
        "shot.gif",
        "shot.webp",
        "upper.PNG",
        "mixed.JpEg",
        "mixed.WebP",
    ];
    let refused = [
        "shot.bmp",
        "shot.tiff",
        "notes.txt",
        "shot.png.txt",
        "noextension",
    ];
    for name in answered.iter().chain(refused.iter()) {
        scene.folder.write_bytes(name, name.as_bytes());
    }

    for name in answered {
        assert_eq!(
            asset_bytes(&opened, name, &check),
            Some(name.as_bytes().to_vec()),
            "{name} is one of the four bitmap formats"
        );
    }
    for name in refused {
        assert_eq!(
            asset_bytes(&opened, name, &check),
            None,
            "{name} is no bitmap format"
        );
    }
}
