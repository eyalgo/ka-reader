# ADR-0015: Markdown becomes a typed document on the host and never markup; image bytes cross the seam as bytes for a contained path and are decoded by the platform inside the one process

**Status:** Superseded by ADR-0025
**Date:** 2026-09-23

## Context

ADR-0006 decided that Markdown → HTML happens on the host through a sanitizer, that the renderer
sees inert HTML plus one read-only asset scheme, and that three walls fail independently — the
sanitizer, the renderer's Content Security Policy, and the asset handler's containment check. With
no web engine in the product (ADR-0014) there is no HTML for a sanitizer to emit, no origin for a
policy to name, and no policy to declare: two of the three walls were walls around an engine the
shape no longer has.

The requirements stand unchanged. Content read from the folder is displayed and never executed
(`docs/SRS.md` § 4.3 NFR-16); rendering fetches nothing from outside the folder, an external link is
displayed and not followed, a relative link may open its target (§ 3.3 FR-32); the folder is
untrusted input (§ 6 DR-6). The owner's override that an image inside the granted folder is loaded
and shown in place, a remote one never (`ka-reader@70a879a:docs/trail/sdd/cycle-1.md` § 2.4), stands and
is carried forward from ADR-0006. UX-I12's three image cases and the readable link destination bind
whichever engine renders (`docs/UXD.md` UX-I12; the CDO's position, `docs/trail/sdd/cycle-9.md`
§ 1.1).

## Decision

**`markdown-renderer` emits a `MarkdownDocument`, and no HTML.** The document is a closed set of
typed nodes: block nodes — heading with its level, paragraph, list, quote, rule, fenced code with
its language and `highlighter`'s spans — each holding inline nodes — text, emphasis, code, image,
link. An image node is *resolved* (a folder-relative path that passed `fs-reader`'s containment
check, in one of the four formats below) or a *placeholder* carrying the condition observed —
outside the folder, missing, unreadable, or a format not decoded. A link node is *external* (inert,
its destination readable) or *relative* (a contained target path the shell turns into the existing
`select_file` call). Raw HTML in the source is a text node. No node carries markup, and none names
a URL the shell fetches (`docs/SDD.md` § 3, `markdown-renderer` row and the `MarkdownDocument`
entity).

**Three walls fail independently.** *The containment check*: every path derived from content — an
image reference, a relative link, an `asset_bytes` call — passes `fs-reader`'s check on the
canonical path, symlinks resolved and after decoding, before any open, and `asset_bytes` re-runs
it on every call; the check has one implementation and its two callers do not re-implement it
(`docs/SDD.md` § 3 SM-7). *The document is data*: the node set is closed and the shell has no
interpreter to hand a node to — no web engine, no HTML import (§ 4 C-R7) — so "nothing executes"
is a property of the type, not of a filter over markup. *Image bytes cross only as bytes, for a
contained path*: `asset_bytes` returns bytes read-only for a path the check passes, and the shell
decodes them with the platform's own decoder, `NSImage`, for **PNG, JPEG, GIF and WebP alone**; a
hostile bitmap's failure is the decoder's, inside the one sandboxed process, with no write and no
connection for it to reach (§ 4 C-D3; § 11 R-4). **SVG is excluded in v1** — it is a document, not
a bitmap, and `NSImage` renders it as one — and an in-folder SVG takes the placeholder stating that
the format is one the tool does not render; the exclusion is a v1 cut with a stated reopening
condition, evidence and never taste, and adding a format is additive under the 1.0.0 contract
(§ 4 C-D3; § SDD Review Notes RN-8).

## Alternatives ruled out

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
  already confirmed is inside the folder" (`ka-reader@70a879a:docs/trail/sdd/cycle-1.md` § 2.4; carried
  from ADR-0006).
- **An out-of-process image decoder** — a second process, which under the rule exists only for a
  view that starts under it; priced as this decision's undo, not taken ahead of a reason
  (`docs/SDD.md` § 9 TO-6).

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
block and its source line is a mapping with no other use (§ 9 TO-5).

What undoing it costs: an out-of-process decoder — a second process, under the rule — or the
placeholder returning for every image (`docs/SDD.md` § 9 TO-6).

**What this rests on, and whose it stays.** `NSImage`'s decoders and TextKit are Apple's and move
with macOS on Apple's schedule; the Markdown parser `ka-reader-core` links is a crate under the
allowlist, chosen by the dependency review `read-markdown` carries (§ 4 C-R6), and which crate is
that slice's to name. If the parser's holder stops answering — the expected trajectory of an
open-source dependency — the closed node set is this product's own type and a replacement parser
lands behind it; the document's shape, the three walls and every test over the hostile corpus stand.
If Apple's decoder changes what it accepts, what moves is a fixture, never the wall: the decoder is
fed by the check alone.

## Traces to

- `docs/SDD.md` at v13 (`ka-reader@b236e7b`, Draft) — § 3, the `markdown-renderer` and `highlighter`
  rows, the `MarkdownDocument` entity, SM-7; § 4 C-R1, C-R6, C-R7, C-D3; § 6 S-3; § 9 TO-5, TO-6;
  § 10 RC-3; § 11 R-4, R-10, R-11; § SDD Review Notes RN-8, RN-10, RN-60; § Open Questions, third
  item.
- `docs/trail/sdd/cycle-9.md` § 1.1 — the CDO's position: UX-I12's cells bind whichever engine
  renders, and which two of them are the cost.
- `ka-reader@70a879a:docs/trail/sdd/cycle-1.md` § 2.4 — the owner's image override, carried from
  ADR-0006; `docs/trail/sdd/cycle-1.md` § 2.1 — the SVG exclusion confirmed on the re-authored SDD's
  own trail.
- `docs/SRS.md` § 3.3 FR-30, FR-31, FR-32; § 4.3 NFR-16; § 6 DR-6; § 8 AC-23.
- `docs/fdr.md` R-52, R-56 – R-62, R-160, PD-11, PD-12, PD-13; `docs/UXD.md` UX-I12, UX-I13.
- ADR-0006 — the record this one supersedes; its decision is restated here whole, and its
  containment-check half is carried unchanged.
- ADR-0013 (the shape), ADR-0014 (the view with no interpreter), ADR-0016 (`asset_bytes` in the
  bridge).
- `docs/trail/architecture/cycle-8.md` § 2.3 — the item that raised this record as owed;
  `docs/trail/architecture/cycle-9.md` § 2.3 — the owner's confirm, given in the owner's seat by a
  `companion-self-answer` run on 2026-09-23 (its reasoning,
  `docs/trail/architecture/self_answer-12.md` § 2.3), on which this record is Accepted and
  ADR-0006 superseded. Accepted with `docs/SDD.md` at v14 (`ka-reader@2739007`, Draft): v14 names
  `folder-model` as the unit that calls `markdown-renderer` (§ 3, RN-64), which this record does
  not fix and whose import is `docs/nfdr.md` QC-10's; and S-3's command half tests `asset_bytes`
  in the bridge's crate, where § 3 places it — the decision here is unchanged. The four-format
  claim rests on Apple's type-level pages (`UTType.webP`, macOS 11.0) and the decode itself is
  what S-3's `swift test` case settles — named in the confirm's reasoning, and covered by the
  placeholder for *a format not decoded* if it does not.
- Inputs read for this record: SDD Draft v13 · SRS Settled v12 · FDR Settled v8.

## Binds

QC-6, QC-11, QC-22, QC-31, QC-37.
