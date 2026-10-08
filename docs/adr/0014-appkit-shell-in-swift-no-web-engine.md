# ADR-0014: The view is AppKit in Swift, in the one process — no web engine of any kind; the core stays Rust behind a C ABI; one bundle

**Status:** Accepted — supersedes ADR-0002
**Date:** 2026-09-23

## Context

ADR-0002 decided the runtime: Tauri 2, a Rust host over `ka-reader-core`, the surfaces in the system
WKWebView, one bundle — and priced the renderer technology as not replaceable inside the terminus.
What moved is that the renderer cannot start under the wall: WebKit's XPC services check the host's
network entitlement at their own start, and the owner's rule grants none (`docs/SDD.md` § 10 RC-2;
ADR-0011). The owner ruled on 2026-09-23 that the renderer leaves WKWebView, and left which native
technology, and what the seams become, to the SDD's § 2 to weigh (`docs/trail/sdd/cycle-9.md`
§ 1.1, the owner's (a)). The SDD did, at v13 (§ SDD Review Notes RN-60).

The forces that decide it, restated so this record reads alone. The acquisition path is one path,
no build from source, at most one named prerequisite, five minutes (`docs/SRS.md` § 7 C-3; § 4.7
NFR-13). Every dependency is a decision reviewed as code (`docs/SDD.md` § 4 C-R6). Markdown must
render (`docs/SRS.md` § 3.3 FR-30), now without a web engine. The design language was drawn to look
like the platform from the start — "it starts from what a stock Mac already draws: the platform's
own fonts, its own text sizes, its own flat list rows" (`docs/DESIGN.md` § Overview) — so every
token value survives re-expression natively and only the CSS realisation sentence does not (the
CDO's pricing, `docs/trail/sdd/cycle-9.md` § 1.1). The Rust workspace forbids `unsafe`
(`Cargo.toml`, `[workspace.lints.rust]`).

## Decision

The product is **one macOS application bundle, `KA-Reader.app`, bundle identifier
`com.kensaiapp.ka-reader`, and one process: an AppKit shell written in Swift (`ka-reader-mac`) over the
`ka-reader-core` library, reached through `ka-reader-bridge`'s C ABI, with no web engine of any kind** —
no WKWebView, no WebKitLegacy `WebView`, no HTML import through `NSAttributedString`, no
JavaScriptCore (`docs/SDD.md` § 4 C-R1). The tree is an `NSOutlineView`; the reading panel is an
`NSTextView`, and rendered Markdown is laid out by TextKit from a `MarkdownDocument` rather than by
a web engine from CSS (§ 3 `surfaces`; ADR-0015). `ka-reader-mac/Package.swift` declares **no
dependency** and no `Package.resolved` exists (C-R6). No runtime is installed; the fourteen icons
and the six grammars ship inside the bundle; fonts are the platform's and none ship
(`docs/DESIGN.md` § Typography).

**The view's language is Swift**, not Rust through `objc2`, and **the view is AppKit, not
SwiftUI**: the reading panel is a text view with attachments and block layout, which is TextKit's
through `NSTextView`, and a SwiftUI layer over it would add a second layout system for no surface
that needs one (`docs/SDD.md` § 2, "The view is AppKit, and its language is Swift").

## Alternatives ruled out

- **Keeping the system WKWebView by granting what it needs** — `com.apple.security.network.client`,
  or the `mach-lookup` exception for `com.apple.nsurlsessiond` — refused by the owner, for what
  passing the check starts as much as for the entitlement's name (ADR-0011 § Alternatives ruled
  out; `docs/trail/sdd/cycle-9.md` § 1.1, exits (b) and (c)).
- **A Rust-native toolkit, single process** — egui, iced, gpui or Slint: one language throughout,
  and it loses the look the design starts from — a toolkit that rasterises its own text and ships a
  GPU stack is a second look and the largest dependency tree of any row, brought to the one seat
  where the design asks for nothing shipped (`docs/SDD.md` § 2, table row 5; `docs/DESIGN.md`
  § Overview; `docs/UXD.md` § 9).
- **An in-process web engine** — WebKitLegacy's `WebView`, or HTML imported through
  `NSAttributedString`: deprecated since macOS 10.14, a script engine inside the one process the
  wall covers, and whether it starts and stays offline under the rule is unmeasured — the renderer
  wall gone *and* an interpreter in the host (`docs/SDD.md` § 2, table row 6).
- **AppKit through `objc2`, keeping the product to one language** — every message send is `unsafe`
  in a workspace that forbids it, TextKit and `NSOutlineView` are driven through bindings written
  for a different idiom, and the contributor who knows AppKit knows it in Swift (`docs/SDD.md`
  § 2, the view-language paragraph).
- **SwiftUI for the view** — a second layout system over the TextKit view the reading panel needs,
  for no surface that needs one (same paragraph).
- **Electron** — ADR-0002 ruled it out for the browser engine it bundles against a five-minute
  install and an allowlisted tree, and that ground stands (`ka-reader@70a879a:docs/SDD.md` § SDD Review
  Notes RN-7; `docs/SDD.md` § 4 C-R6).

## Consequences

Easier: no engine bundled and no UI dependency at all — the view brings nothing to the tree
(C-R6); the look the design starts from is drawn by the platform that defines it; and the wall
covers everything that draws, because everything that draws is the one process (ADR-0013).

Harder: a second language, Swift, beside Rust — the count this product already carried with
TypeScript — and one C ABI between them (`docs/SDD.md` § 3 SM-4); Markdown laid out by TextKit from
a document tree, where UX-I12's two hard cells — an image or its placeholder in the flow of the
prose, and fenced code on its own surface — are the priced cost, settled in `read-markdown`'s first
build (`docs/SDD.md` § Open Questions, third item; § 11 R-11); layout fixtures re-walked on every
macOS generation the floor admits, per release (§ 4 C-R5); and two public sentences owed outside
this log — `README.md` § Stack, which names the WKWebView and plain CSS, and `docs/DESIGN.md`'s
realisation sentence — each in its own document's run (`docs/SDD.md` § SDD Review Notes RN-59,
RN-62).

What undoing it costs: replacing the view technology costs every surface rewritten — the core, the
bridge's contract and the harness survive (`docs/SDD.md` § 2, "Undoing it"). **That price was paid
once already, from the WKWebView, at the cheapest moment it could be: one slice scaffolded, nothing
shipped** (§ 10 RC-3). It is not foreseen again inside the terminus: the platform is not
replaceable, and the view technology was replaced once, before any public release, and is not
replaceable again (`docs/fdr.md` PD-29 at v8; `docs/SDD.md` § 2, force 4). A second swap is a change
that contradicts PD-29 and goes to the owner, the way this one did (`docs/trail/fdr/cycle-5.md`
§ 2.1).

**What this rests on, and whose it stays.** AppKit, TextKit (`NSTextLayoutManager`, available from
macOS 12.0 — `docs/SDD.md` § 4 C-R5), `NSImage`'s decoders and the Swift toolchain are all Apple's,
moving with macOS on Apple's schedule, and no third-party holder stands between this product and
them — the one dependency this view has is the platform it is drawn on. If TextKit's layout of an
attachment or a text block moves with a macOS release, what moves is the treatment's layout, never
the `MarkdownDocument` or the containment check — R-11's re-cut, walked on every floor macOS before
each release. If Apple ever drops WebKit's entitlement check, the WKWebView returns to the SDD's
§ 2 as a candidate and nothing here moves on its own (ADR-0013). Unmeasured as this record is
written: `swift build` and `swift test` on the GitHub-hosted `macos-14` runner, which S-1's first
native build settles (`docs/SDD.md` § 6 S-1, command half).

## Traces to

- `docs/SDD.md` at v13 (`ka-reader@b236e7b`, Draft) — § 2 (forces 4 and 6; table rows 1, 5 and 6;
  "The view is AppKit, and its language is Swift"; "Undoing it"); § 3, the units table and the
  Swift-frame paragraph; § 4 C-R1, C-R5, C-R6, C-R7; § 9 TO-4, TO-7, TO-8; § 10 RC-2, RC-3; § 11
  R-11; § SDD Review Notes RN-53, RN-59, RN-60, RN-62; § Open Questions, third item.
- `docs/trail/sdd/cycle-9.md` § 1.1 — the owner's (a); the CTO's, CDO's and CPO's positions, the
  CDO's pricing of what the design language keeps and loses among them.
- `docs/fdr.md` at v8 — PD-29 (the view replaced once, before any public release, and not again;
  `docs/trail/fdr/cycle-5.md` § 2.1, the owner's confirm), PD-15, PD-17, PD-28.
- `docs/DESIGN.md` § Overview, § Typography, § DESIGN Review Notes RN-1; `docs/UXD.md` § 9,
  UX-I12, UX-I15.
- `docs/SRS.md` § 7 C-3, C-11; § 3.3 FR-30; § 4.7 NFR-13.
- `Cargo.toml` `[workspace.lints.rust]` — `unsafe_code = "forbid"`, opened for this record on
  2026-09-23.
- ADR-0002 — the record this one supersedes; its decision is restated here whole. Its owner
  confirmation of the previous runtime (`ka-reader@70a879a:docs/trail/sdd/cycle-1.md` § 2.2) is that
  runtime's and stands as history under it.
- ADR-0011 (the rule the renderer could not start under), ADR-0013 (the shape), ADR-0015 (what the
  view is handed), ADR-0016 (the units).
- `docs/trail/architecture/cycle-8.md` § 2.3 — the item that raised this record as owed;
  `docs/trail/architecture/cycle-9.md` § 2.3 — the owner's confirm, given in the owner's seat by a
  `companion-self-answer` run on 2026-09-23 (its reasoning,
  `docs/trail/architecture/self_answer-12.md` § 2.3), on which this record is Accepted and
  ADR-0002 superseded. Accepted with `docs/SDD.md` at v14 (`ka-reader@2739007`, Draft): v14 moves
  nothing of § 2, the view or the Swift frame (SDD RN-64).
- Inputs read for this record: SDD Draft v13 · SRS Settled v12 · FDR Settled v8.

## Binds

QC-1, QC-8, QC-13, QC-17, QC-21, QC-23, QC-55.
