# ADR-0026: Markdown becomes a typed document on the host and never markup, a closed set of six block kinds of which a list and a quote hold blocks, and a relative link is a contained file's path; image bytes cross the seam as bytes for a contained path and are decoded by the platform inside the one process

**Status:** Accepted — supersedes ADR-0025
**Date:** 2026-11-07

## Context

ADR-0025 decided that a Markdown file becomes a `MarkdownDocument`, a closed set of typed nodes
built as the core builds them, and that three walls fail independently. Its *Decision* defined the
two link forms as "*external* (inert, its destination readable) or *relative* (a contained target
path the shell turns into the existing `select_file` call)"
(`docs/adr/0025-markdown-as-a-typed-document-the-closed-node-set-as-built.md:L53-L54`). Two parts
of that sentence are no longer true of the settled design.

The call is wrong. The shell sends an activated relative link as one `open_relative_link` call
(`ka-reader-mac/Sources/Shell/LaunchFlow.swift:L206-L207`, `:L230` at `ka-reader@e95896f`). The
bridge checks the path again and, for a contained file, admits the selection through the model's
`select_file` operation and opens the file (`crates/ka-reader-bridge/src/session.rs:L1249-L1270`;
`docs/SDD.md` § 3 SM-4, SM-5). The definition moved too. The SDD decided on 2026-11-07 that
*relative* is a contained **file's** path, and that a link whose target the check reaches at a
folder is an *external* node (`docs/SDD.md` § 3 `MarkdownDocument`, RN-161). The panel reads files,
and UX-I12 makes a link a control only where activating it does something (`docs/UXD.md` UX-I12;
`docs/SRS.md` § 3.3 FR-32, "a relative link to a file inside the viewed folder").

The link sentence is part of the second wall's definition, "the document is data", and a delivery
stage reads an Accepted record as fixed. The renderer at `ka-reader@e95896f` still makes a
*relative* node for a folder. The SDD names that as a known defect until a change of `read-markdown`
lands (`crates/ka-reader-core/src/markdown_renderer/references.rs:L95`). That change will be checked
against this log, so the record has to agree with the settled SDD before the change lands. The PM
and the CTO's seat raised the two parts on this log's companion. The owner's seat answered both in
one superseding record that restates ADR-0025 whole and changes only the link sentence
(`docs/trail/architecture/cycle-75.md` §§ 3.1, 3.2).

The forces ADR-0025 recorded stand, and are restated so this record reads alone. With no web
engine in the product (ADR-0027) there is no HTML for a sanitizer to emit, no origin for a policy
to name, and no policy to declare, so two of ADR-0006's three walls were walls around an engine the
shape no longer has. Content read from the folder is displayed and never executed (`docs/SRS.md`
§ 4.3 NFR-16). Rendering fetches nothing from outside the folder: an external link is displayed and
not followed, and a relative link may open its target (§ 3.3 FR-32). The folder is untrusted input
(§ 6 DR-6). The owner's override stands: an image inside the granted folder is loaded and shown in
place, and a remote one never is (`ka-reader@70a879a:docs/trail/sdd/cycle-1.md` § 2.4). UX-I12's
three image cases and the readable link destination bind whichever engine renders (`docs/UXD.md`
UX-I12; the CDO's position, `docs/trail/sdd/cycle-9.md` § 1.1).

## Decision

**`markdown-renderer` emits a `MarkdownDocument`, and no HTML.** The document is an ordered list of
block nodes from a closed set of six kinds:

- a **heading** with its level, holding inline nodes;
- a **paragraph**, holding inline nodes;
- a **list** with its kind (unordered, or ordered with its start), whose items each hold block
  nodes in source order;
- a **quote**, holding block nodes in source order;
- a **rule**;
- a **code** block, fenced or indented, carrying its language and `highlighter`'s spans over its
  text. A block in no floor language is plain and holds no spans.

Nesting adds no kind: a list inside a quote inside a list is the same six. An empty list or quote is
a node holding no blocks. The inline nodes are text, emphasis, code, image and link. An image node
is *resolved* (a folder-relative path that passed `fs-reader`'s containment check, in one of the
four formats below) or a *placeholder* carrying the condition observed: outside the folder, missing,
unreadable, or a format not decoded.

**A link node is *external* or *relative*.** *External* is inert, with its destination readable: a
scheme or a fragment, a path the check refuses, a missing path, or a contained entry that is not a
file, such as a folder. *Relative* is a contained file's path. The shell sends an activated relative
link as one `open_relative_link` call. The bridge checks the path again and, for a contained file,
admits the selection through the model's `select_file` operation and opens the file, as a tree
selection does. The kind is read at render and never asked again. A file replaced by a folder after
the render is a control whose activation answers `pending`, because the check at activation still
admits only a contained file (`crates/ka-reader-core/src/folder_model.rs:L305-L307`). The block kinds
are as the core builds them at `ka-reader@71f9f69`. The link form is the settled design's, and at
`ka-reader@e95896f` the renderer does not yet build it for a folder.

Raw HTML in the source is a text node. No node carries markup, and none names a URL the shell
fetches (`docs/SDD.md` § 3, the `markdown-renderer` row and the `MarkdownDocument` entity).
**Adding a node kind**, such as a table or a task list, changes the closed set and takes a record of
its own.

**Three walls fail independently.** *The containment check*: every path derived from content — an
image reference, a relative link, an `asset_bytes` call — passes `fs-reader`'s check on the
canonical path, symlinks resolved and after decoding, before any open, and `asset_bytes` re-runs
it on every call. The check has one implementation and its callers do not re-implement it
(`docs/SDD.md` § 3 SM-7). *The document is data*: the node set is closed and the shell has no
interpreter to hand a node to — no web engine, no HTML import (§ 4 C-R7) — so "nothing executes"
is a property of the type, not of a filter over markup. *Image bytes cross only as bytes, for a
contained path*: `asset_bytes` returns bytes read-only for a path the check passes, and the shell
decodes them with the platform's own decoder, `NSImage`, for **PNG, JPEG, GIF and WebP alone**. A
hostile bitmap's failure is the decoder's, inside the one sandboxed process, with no write and no
connection for it to reach (§ 4 C-D3; § 11 R-4). **SVG is excluded in v1.** It is a document, not
a bitmap, and `NSImage` renders it as one, so an in-folder SVG takes the placeholder stating that
the format is one the tool does not render. The exclusion is a v1 cut with a stated reopening
condition, evidence and never taste, and adding a format is additive under the 1.0.0 contract
(§ 4 C-D3; § SDD Review Notes RN-8).

## Alternatives ruled out

*(The first five are ADR-0015's, carried by ADR-0025 and transcribed unchanged. The last four are
the form of this correction and the link's definition, weighed on the owner's answer and in the
SDD. None reopens the decision.)*

- **Sanitized HTML, a Content Security Policy and an asset scheme** — ADR-0006's three walls. Two
  of them guard an engine the product no longer has: with no web engine there is no policy to
  declare and no origin to serve on, and inert HTML handed to a text view would still be markup a
  later change could interpret. Retired with the shape (`docs/SDD.md` § 10 RC-3).
- **Render in the shell from the Markdown source** — a parser in Swift. It would be a package
  dependency `Package.swift` may not declare (§ 4 C-R6), and it would parse untrusted content in
  the unit that draws, against the rule that every byte a surface shows crossed `SM-4` as data
  (§ 4 C-R7).
- **HTML imported through `NSAttributedString`** — a web engine by another door, and the
  in-process engine § 2's table already rejects: a script engine inside the wall on a deprecated
  API (`docs/SDD.md` § 2, table row 6; § 4 C-R1's forbidden set).
- **Load no image, remote or local** — the run-1 draft the owner overrode: image-bearing READMEs
  render as written, and the wall is kept by narrowing what crosses to "a byte the host has
  already confirmed is inside the folder" (`ka-reader@70a879a:docs/trail/sdd/cycle-1.md` § 2.4;
  carried from ADR-0006).
- **An out-of-process image decoder** — a second process, which under the rule exists only for a
  view that starts under it; priced as this decision's undo, not taken ahead of a reason
  (`docs/SDD.md` § 9 TO-6).
- **Amend ADR-0025's link sentence in place** — the smallest edit, and the one this log never
  makes: an Accepted record is not rewritten (`docs/adr/README.md:L4-L5`). ADR-0025 corrected
  ADR-0015 the same way, and ADR-0024 corrected ADR-0007.
- **Two superseding records, one per item** — both items re-state the same sentence, so the first
  record would carry half the correction while Accepted. Decided together in the owner's seat
  (`docs/trail/architecture/self_answer-78.md` § 3.1, *Decided together with § 3.2*).
- **Record the folder-is-external rule once the renderer builds it** — the change that builds it is
  checked against this log, and a record still saying *relative* is "a contained target path"
  would make that change contradict an Accepted record (same file, § 3.2, Check 2).
- **A relative node carrying its target's kind** — weighed in the SDD and not taken: the kind would
  have one reader, the page's is-it-a-control decision, which the two forms already answer
  (`docs/SDD.md` § 3 `MarkdownDocument`).

## Consequences

Easier: a README with in-folder images renders whole with the network off; no scheme, no handler
and no policy to widen; a bypass of any one wall still moves no byte across the folder's edge; the
hostile-document corpus grows with every reported case, and a node outside the closed set or a text
node that does not hold its source verbatim is a red test rather than a silent render (`docs/SDD.md`
§ 11 R-4). A link to a folder is inert text with its destination readable, not a control that does
nothing.

Harder: a hostile bitmap is decoded inside the process the wall covers. A decoder crash is a crash
inside a process that cannot write or connect (`docs/SRS.md` NFR-4), and malformed PNG, JPEG, GIF
and WebP join the fixtures. The containment check must be right about `..`, symlinks,
percent-encoding and Unicode normalization, and runs twice (§ 11 R-10). TextKit's layout of an
image or its placeholder in the flow and of code on its own surface is re-walked per macOS
generation (§ 11 R-11). The raw-source view is still not built, re-read under the native view with
the same judgment: the position between a rendered block and its source line is a mapping with no
other use (§ 9 TO-5). A relative link costs one export on SM-4's list and an ordered read on the
shell's serial tree-act runner, bounded by one read of one contained file (§ 9 TO-5). The link's
kind is fixed at render, so a target that changes between file and folder after the render is
answered by the check at activation, not by the node. Until the renderer change lands, the core
contradicts this record for a folder target, and that change is the one that closes the gap. A new
node kind costs a new record, because the set is closed by this one.

What undoing it costs: an out-of-process decoder — a second process, under the rule — or the
placeholder returning for every image (`docs/SDD.md` § 9 TO-6).

**What this rests on, and whose it stays.** `NSImage`'s decoders and TextKit are Apple's and move
with macOS on Apple's schedule. The Markdown parser `ka-reader-core` links is a crate under the
allowlist, chosen by the dependency review `read-markdown` carries (§ 4 C-R6), and which crate is
that slice's to name. If the parser's holder stops answering — the expected trajectory of an
open-source dependency — the closed node set is this product's own type and a replacement parser
lands behind it; the document's shape, the three walls and every test over the hostile corpus
stand. If Apple's decoder changes what it accepts, what moves is a fixture, never the wall: the
decoder is fed by the check alone.

## Traces to

- `docs/trail/architecture/cycle-75.md` § 3.1 — the PM's item and the owner's seat's answer:
  supersede ADR-0025, restate it whole, change only the link sentence, trace to SM-4 and SM-5;
  § 3.2 — the CTO's item and its answer: *relative* is a contained file's path, a folder target is
  *external*, the kind is read at render, and the link form is not called built. Reasoning at
  `docs/trail/architecture/self_answer-78.md` §§ 3.1, 3.2.
- `docs/SDD.md` at v77 (Settled) — § 3, the `markdown-renderer` and `highlighter` rows, the
  `MarkdownDocument` entity (`:L729-L776`; the folder-is-external decision, RN-161), SM-4
  (`open_relative_link` among its calls, `:L657`), SM-5 (the link's fixed order, `:L658`), SM-7.
  Carried from ADR-0025: § 2, table row 6; § 4 C-R1, C-R6, C-R7, C-D3; § 9 TO-5, TO-6; § 10 RC-3;
  § 11 R-4, R-10, R-11; § SDD Review Notes RN-8, RN-145.
- `ka-reader-mac/Sources/Shell/LaunchFlow.swift:L206-L207`, `:L230`;
  `crates/ka-reader-bridge/src/session.rs:L1249-L1270`;
  `crates/ka-reader-core/src/folder_model.rs:L305-L307`;
  `crates/ka-reader-core/src/markdown_renderer/references.rs:L94-L96` — at `ka-reader@e95896f`,
  cited by the answers. `crates/ka-reader-core/src/markdown_renderer.rs:L35-L57` at
  `ka-reader@71f9f69` — the six block kinds as built.
- `docs/trail/sdd/cycle-9.md` § 1.1 — the CDO's position: UX-I12's cells bind whichever engine
  renders.
- `ka-reader@70a879a:docs/trail/sdd/cycle-1.md` § 2.4 — the owner's image override;
  `docs/trail/sdd/cycle-1.md` § 2.1 — the SVG exclusion confirmed on the re-authored SDD's trail.
- `docs/SRS.md` § 3.3 FR-30, FR-31, FR-32; § 4.3 NFR-16; § 6 DR-6; § 8 AC-23.
- `docs/fdr.md` R-52, R-56 – R-62, R-160, PD-11, PD-12, PD-13; `docs/UXD.md` UX-I12, UX-I13.
- ADR-0025 — the record this one supersedes. Its decision is restated here whole with the link
  sentence changed, so nothing in this record depends on that one being open. Its traces, and
  ADR-0015's before it, stand under this record.
- ADR-0006 (superseded by ADR-0015; its containment-check half is carried unchanged), ADR-0027
  (the view with no interpreter), ADR-0021 (the shape), ADR-0020 (`asset_bytes` in the bridge).
- **Beyond the answers' words, three:** (1) the *external* form lists what it covers — a scheme or
  a fragment, a path the check refuses, a missing path, a folder — taken from SDD v77's entity, where
  the answer names the folder and the missing or escaping path. (2) TO-5 is cited. The § 3.1 answer
  kept it out because TO-5 still named the old call at v76; SDD v77 restates it to the call the
  shell makes (SDD RN-163), so it now agrees with SM-4 and SM-5. (3) ADR-0027 is cited where
  ADR-0025 cited ADR-0014, because ADR-0027 superseded it in the same fold; the decision it names
  is the same.
- Inputs read for this record: PRD Settled v18 · SRS Settled v14 · UXD Settled v13 · SDD Settled
  v77 · FDR Settled v13.

## Binds

QC-6, QC-11, QC-22, QC-31, QC-37.
