//! Layer 2: the hostile corpus (`checks/fixtures/hostile.md`) read through `select_file`, a
//! `FolderModel` open and `read_file`, over folders the test makes. Each hostile piece must reach
//! the document as inert text or as a placeholder, and no route may differ from another
//! (CP-1073 – CP-1077).

#[allow(
    dead_code,
    reason = "each test crate uses a subset of the shared helpers"
)]
mod common;

use std::path::{Path, PathBuf};

use common::TempDir;
use ka_reader_core::{
    Block, FileRequest, FileView, FolderModel, ImageTarget, Inline, ItemState, Language,
    LinkTarget, MarkdownDocument, PlaceholderCondition, ReadingPosition, open_folder, read_file,
    select_file,
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
            walked
                .texts
                .iter()
                .any(|text| text.trim_end() == piece.source),
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
