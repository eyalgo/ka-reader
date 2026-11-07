# ADR-0025: Markdown becomes a typed document on the host and never markup, a closed set of six block kinds of which a list and a quote hold blocks; image bytes cross the seam as bytes for a contained path and are decoded by the platform inside the one process

**Status:** Superseded by ADR-0026
**Date:** 2026-11-07

## Context

ADR-0015 decided that a Markdown file becomes a `MarkdownDocument`, a closed set of typed nodes,
and that three walls fail independently. Its *Decision* listed that set as "block nodes — heading
with its level, paragraph, list, quote, rule, fenced code with its language and `highlighter`'s
spans — each holding inline nodes" (`docs/adr/0015-markdown-as-a-typed-document-three-walls-in-one-process.md:L26-L29`).
The core built the set at `ka-reader@71f9f69`, and two parts of that list are false of the type.
A list's items and a quote hold block nodes, not inline nodes. A code block is fenced or indented,
not fenced alone (`crates/ka-reader-core/src/markdown_renderer.rs:L35-L57` at that commit). The
SDD restated the entity as built at v72 (`docs/SDD.md` § 3 `MarkdownDocument`, RN-145).

The list is not an illustration. It is the definition of the second wall, "the document is data",
and a node outside the set is a red test. A delivery stage reads an Accepted record as fixed, so a
change checked against ADR-0015 would treat an indented code block, or a list holding a quote, as
outside the set. The PM raised the gap on this log's companion, and the owner's seat answered it:
supersede, with the node set as built and nothing else changed
(`docs/trail/architecture/cycle-72.md` § 3.1).

The forces ADR-0015 recorded stand, and are restated so this record reads alone. With no web
engine in the product (ADR-0014) there is no HTML for a sanitizer to emit, no origin for a policy
to name, and no policy to declare, so two of ADR-0006's three walls were walls around an engine the
shape no longer has. Content read from the folder is displayed and never executed (`docs/SRS.md`
§ 4.3 NFR-16). Rendering fetches nothing from outside the folder: an external link is displayed and
not followed, and a relative link may open its target (§ 3.3 FR-32). The folder is untrusted input
(§ 6 DR-6). The owner's override that an image inside the granted folder is loaded and shown in
place, and a remote one never (`ka-reader@70a879a:docs/trail/sdd/cycle-1.md` § 2.4), stands. UX-I12's
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
unreadable, or a format not decoded. A link node is *external* (inert, its destination readable) or
*relative* (a contained target path the shell turns into the existing `select_file` call). Raw HTML
in the source is a text node. No node carries markup, and none names a URL the shell fetches
(`docs/SDD.md` § 3, the `markdown-renderer` row and the `MarkdownDocument` entity). **Adding a node
kind** — a table, a task list — changes the closed set, and takes a record of its own.

**Three walls fail independently.** *The containment check*: every path derived from content — an
image reference, a relative link, an `asset_bytes` call — passes `fs-reader`'s check on the
canonical path, symlinks resolved and after decoding, before any open, and `asset_bytes` re-runs
it on every call. The check has one implementation and its two callers do not re-implement it
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

*(The first five are ADR-0015's, transcribed unchanged. The last two are the form of this
correction, weighed on the owner's answer. None reopens the decision.)*

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
- **Amend ADR-0015's node list in place** — the smallest edit, and the one this log never makes:
  an Accepted record is not rewritten (`docs/adr/README.md:L4-L5`). ADR-0024 corrected ADR-0007 the
  same way, by a superseding record.
- **No record: let the SDD's entity carry the shape, and read ADR-0015's list as an
  illustration** — weighed and lost in the owner's seat. The list is the second wall's own
  definition, and a delivery stage reads the record, not the SDD's entity
  (`docs/trail/architecture/self_answer-75.md` § 3.1, *Close call*).

## Consequences

Easier: a README with in-folder images renders whole with the network off; no scheme, no handler
and no policy to widen; a bypass of any one wall still moves no byte across the folder's edge; the
hostile-document corpus grows with every reported case, and a node outside the closed set or a text
node that does not hold its source verbatim is a red test rather than a silent render (`docs/SDD.md`
§ 11 R-4).

Harder: a hostile bitmap is decoded inside the process the wall covers — a decoder crash is a crash
inside a process that cannot write or connect (`docs/SRS.md` NFR-4), and malformed PNG, JPEG, GIF
and WebP join the fixtures; the containment check must be right about `..`, symlinks,
percent-encoding and Unicode normalization, and runs twice (§ 11 R-10); TextKit's layout of an
image or its placeholder in the flow and of code on its own surface is settled in the first
Markdown slice and re-walked per macOS generation (§ 11 R-11); and the raw-source view is still
not built, re-read under the native view with the same judgment — the position between a rendered
block and its source line is a mapping with no other use (§ 9 TO-5). A new node kind costs a new
record, because the set is closed by this one.

What undoing it costs: an out-of-process decoder — a second process, under the rule — or the
placeholder returning for every image (`docs/SDD.md` § 9 TO-6).

**What this rests on, and whose it stays.** `NSImage`'s decoders and TextKit are Apple's and move
with macOS on Apple's schedule. The Markdown parser `ka-reader-core` links is a crate under the
allowlist, chosen by the dependency review `read-markdown` carries (§ 4 C-R6), and which crate is
that slice's to name. If the parser's holder stops answering — the expected trajectory of an
open-source dependency — the closed node set is this product's own type and a replacement parser
lands behind it; the document's shape, the three walls and every test over the hostile corpus stand. If Apple's decoder changes what it accepts, what moves
is a fixture, never the wall: the decoder is fed by the check alone.

## Traces to

- `docs/trail/architecture/cycle-72.md` § 3.1 — the PM's item and the owner's seat's answer:
  supersede, with the closed node set as built and as `docs/SDD.md` v72 § 3 states it; reasoning
  at `docs/trail/architecture/self_answer-75.md` § 3.1.
- `docs/SDD.md` at v73 (Settled) — § 3, the `markdown-renderer` and `highlighter` rows, the
  `MarkdownDocument` entity (`:L633-L648`), SM-7; § SDD Review Notes RN-145 (the entity restated at
  v72). Carried from ADR-0015: § 2, table row 6; § 4 C-R1, C-R6, C-R7, C-D3; § 9 TO-5, TO-6; § 10
  RC-3; § 11 R-4, R-10, R-11; § SDD Review Notes RN-8.
- `crates/ka-reader-core/src/markdown_renderer.rs:L35-L57` at `ka-reader@71f9f69` — the six block
  kinds as built, read by this run.
- `docs/trail/sdd/cycle-9.md` § 1.1 — the CDO's position: UX-I12's cells bind whichever engine
  renders.
- `ka-reader@70a879a:docs/trail/sdd/cycle-1.md` § 2.4 — the owner's image override;
  `docs/trail/sdd/cycle-1.md` § 2.1 — the SVG exclusion confirmed on the re-authored SDD's trail.
- `docs/SRS.md` § 3.3 FR-30, FR-31, FR-32; § 4.3 NFR-16; § 6 DR-6; § 8 AC-23.
- `docs/fdr.md` R-52, R-56 – R-62, R-160, PD-11, PD-12, PD-13; `docs/UXD.md` UX-I12, UX-I13.
- ADR-0015 — the record this one supersedes. Its decision is restated here whole with the node set
  changed, so nothing in this record depends on that one being open. Its traces stand under this
  record, including the four-format claim's ground on Apple's type-level pages.
- ADR-0006 (superseded by ADR-0015; its containment-check half is carried unchanged), ADR-0014 (the
  view with no interpreter), ADR-0021 (the shape), ADR-0020 (`asset_bytes` in the bridge).
- **Beyond the answer's words, two:** (1) the *Decision* says six kinds, the count SDD v73's
  entity gives; the answer lists the same six without counting them. (2) The *Traces to* cite
  ADR-0021 and ADR-0020 where ADR-0015 cited ADR-0013 and ADR-0016, because those two superseded them
  (`docs/adr/README.md`, the ADR-0021 and ADR-0020 rows). The decisions they name are the same.
- Inputs read for this record: PRD Settled v18 · SRS Settled v14 · UXD Settled v13 · SDD Settled
  v73 · FDR Settled v13.

## Binds

QC-6, QC-11, QC-22, QC-31, QC-37.
