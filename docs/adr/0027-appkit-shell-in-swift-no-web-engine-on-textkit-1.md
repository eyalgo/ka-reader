# ADR-0027: The view is AppKit in Swift, in the one process — no web engine of any kind; the core stays Rust behind a C ABI; one bundle; the Markdown page and the code view lay out with TextKit 1

**Status:** Accepted — supersedes ADR-0014
**Date:** 2026-11-07

## Context

ADR-0014 decided the view: AppKit in Swift, in the one process, with no web engine of any kind. Its
*rests on* paragraph named the platform fact the view depends on as "TextKit (`NSTextLayoutManager`,
available from macOS 12.0 — `docs/SDD.md` § 4 C-R5)"
(`docs/adr/0014-appkit-shell-in-swift-no-web-engine.md:L94-L95`). That is not the class the view
uses. The Markdown page builds TextKit 1's `NSLayoutManager` from construction, because its
placeholder box is an `NSTextBlock` and TextKit 2 does not lay out an `NSTextBlock`
(`ka-reader-mac/Sources/Surfaces/MarkdownPageView.swift:L15-L16`, `:L29-L36` at
`ka-reader@e95896f`). The code view does the same, so its gutter can read rows
(`CodeView.swift:L14-L15`, `:L37`). SDD v76 restated C-R5 to `NSLayoutManager` (SDD RN-159). The
paragraph exists to name what the decision depends on, so naming the wrong class names the wrong
dependency. A later change to the page would be checked against a record that says the view already
rests on TextKit 2. The CTO's seat raised it on this log's companion, and the owner's seat answered:
a superseding record that restates ADR-0014 whole and corrects that paragraph
(`docs/trail/architecture/cycle-75.md` § 3.3).

ADR-0014's own context stands, and is restated so this record reads alone. ADR-0002 decided the
runtime: Tauri 2, a Rust host over `ka-reader-core`, the surfaces in the system WKWebView, one
bundle. What moved is that the renderer cannot start under the wall: WebKit's XPC services check the
host's network entitlement at their own start, and the owner's rule grants none (`docs/SDD.md` § 10
RC-2; ADR-0011). The owner ruled on 2026-09-23 that the renderer leaves WKWebView, and left which
native technology, and what the seams become, to the SDD's § 2 to weigh (`docs/trail/sdd/cycle-9.md`
§ 1.1, the owner's (a)). The SDD did, at v13 (§ SDD Review Notes RN-60).

The forces that decide it. The acquisition path is one path, no build from source, at most one named
prerequisite, five minutes (`docs/SRS.md` § 7 C-3; § 4.7 NFR-13). Every dependency is a decision
reviewed as code (`docs/SDD.md` § 4 C-R6). Markdown must render (`docs/SRS.md` § 3.3 FR-30), without
a web engine. The design language was drawn to look like the platform from the start: "it starts
from what a stock Mac already draws: the platform's own fonts, its own text sizes, its own flat list
rows" (`docs/DESIGN.md` § Overview). So every token value survives re-expression natively and only
the CSS realisation sentence does not (the CDO's pricing, `docs/trail/sdd/cycle-9.md` § 1.1). The
Rust workspace forbids `unsafe` (`Cargo.toml`, `[workspace.lints.rust]`).

## Decision

The product is **one macOS application bundle, `KA-Reader.app`, bundle identifier
`com.kensaiapp.ka-reader`, and one process: an AppKit shell written in Swift (`ka-reader-mac`) over
the `ka-reader-core` library, reached through `ka-reader-bridge`'s C ABI, with no web engine of any
kind** — no WKWebView, no WebKitLegacy `WebView`, no HTML import through `NSAttributedString`, no
JavaScriptCore (`docs/SDD.md` § 4 C-R1). The tree is an `NSOutlineView`. The reading panel is an
`NSTextView`, and rendered Markdown is laid out by TextKit from a `MarkdownDocument` rather than by
a web engine from CSS (§ 3 `surfaces`; ADR-0026). `ka-reader-mac/Package.swift` declares **no
dependency** and no `Package.resolved` exists (C-R6). No runtime is installed; the fourteen icons
and the six grammars ship inside the bundle; fonts are the platform's and none ship
(`docs/DESIGN.md` § Typography).

**The view's language is Swift**, not Rust through `objc2`, and **the view is AppKit, not
SwiftUI**: the reading panel is a text view with attachments and block layout, which is TextKit's
through `NSTextView`, and a SwiftUI layer over it would add a second layout system for no surface
that needs one (`docs/SDD.md` § 2, "The view is AppKit, and its language is Swift").

## Alternatives ruled out

*(The first six are ADR-0014's, transcribed unchanged. The last one is the form of this correction,
weighed on the owner's answer. None reopens the decision.)*

- **Keeping the system WKWebView by granting what it needs** — `com.apple.security.network.client`,
  or the `mach-lookup` exception for `com.apple.nsurlsessiond` — refused by the owner, for what
  passing the check starts as much as for the entitlement's name (ADR-0011 § Alternatives ruled
  out; `docs/trail/sdd/cycle-9.md` § 1.1, exits (b) and (c)).
- **A Rust-native toolkit, single process** — egui, iced, gpui or Slint: one language throughout,
  and it loses the look the design starts from. A toolkit that rasterises its own text and ships a
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
  install and an allowlisted tree, and that ground stands (`ka-reader@70a879a:docs/SDD.md` § SDD
  Review Notes RN-7; `docs/SDD.md` § 4 C-R6).
- **A dated note inside ADR-0014** — the smallest edit, and the one this log never makes: an
  Accepted record's only line that changes is its Status, to record a supersession
  (`docs/adr/README.md:L4-L5`). A dated note is how the NFDR revises in place, not how this log
  does (`docs/trail/architecture/self_answer-78.md` § 3.3, Check 2).

## Consequences

Easier: no engine bundled and no UI dependency at all — the view brings nothing to the tree
(C-R6); the look the design starts from is drawn by the platform that defines it; and the wall
covers everything that draws, because everything that draws is the one process (ADR-0021).

Harder: a second language, Swift, beside Rust — the count this product already carried with
TypeScript — and one C ABI between them (`docs/SDD.md` § 3 SM-4). Markdown is laid out by TextKit
from a document tree, and UX-I12's two hard cells — an image or its placeholder in the flow of the
prose, and fenced code on its own surface — are the priced cost (§ 11 R-11). The first Markdown
slice found the layout form at `ka-reader@e95896f`: one `NSTextView` under TextKit 1, an image as an
attachment in the flow, a placeholder as an `NSTextBlock`. The code cell is not met at that pin, a
known defect until a change of `read-markdown` lands (`docs/SDD.md` § 3, the `surfaces` row, *The
Markdown page's layout form*). Layout fixtures are re-walked on every macOS generation the floor
admits, per release (§ 4 C-R5). Two public sentences were owed outside this log: `README.md`
§ Stack, which named the WKWebView and plain CSS, and `docs/DESIGN.md`'s realisation sentence (SDD
RN-59, RN-62). Each has since landed in its own document's run: `README.md` names no web engine, and
`docs/DESIGN.md`'s Review Notes record the realisation sentence moving to the AppKit shell
(`:L932-L938`).

What undoing it costs: replacing the view technology costs every surface rewritten — the core, the
bridge's contract and the harness survive (`docs/SDD.md` § 2, "Undoing it"). **That price was paid
once already, from the WKWebView, at the cheapest moment it could be: one slice scaffolded, nothing
shipped** (§ 10 RC-3). It is not foreseen again inside the terminus: the platform is not
replaceable, and the view technology was replaced once, before any public release, and is not
replaceable again (`docs/fdr.md` PD-29; `docs/SDD.md` § 2, force 4). A second swap is a change that
contradicts PD-29 and goes to the owner, the way this one did (`docs/trail/fdr/cycle-5.md` § 2.1).

**What this rests on, and whose it stays.** AppKit, TextKit 1 (`NSLayoutManager`, which the
Markdown page and the code view lay out with from construction — `docs/SDD.md` § 4 C-R5),
`NSImage`'s decoders and the Swift toolchain are all Apple's, moving with macOS on Apple's schedule.
No third-party holder stands between this product and them; the one dependency this view has is the
platform it is drawn on. TextKit 2's `NSTextLayoutManager`, available from macOS 12.0, is not what
the view uses. Being older makes TextKit 1 easier on the macOS floor, not on dependence. Apple keeps
TextKit 1 beside its newer text system, and the page depends on a TextKit 1 feature, `NSTextBlock`
layout, that TextKit 2 does not provide. If Apple narrows TextKit 1, the page's layout moves — the
placeholder box goes to a form TextKit 2 lays out — and the `MarkdownDocument`, the containment
check and the view technology do not. If TextKit's layout of an attachment or a text block moves
with a macOS release, the same holds: what moves is the treatment's layout. That is R-11's re-cut,
walked on the floor macOS before each release. If Apple ever drops WebKit's entitlement check, the
WKWebView returns to the SDD's § 2 as a candidate and nothing here moves on its own (ADR-0021). The
Swift build that ADR-0014 recorded as unmeasured on the hosted `macos-14` runner has since been
built and probed there: GitHub Actions run 35988399477, image `macos-14-arm64`. CI runs on the
`macos-26` label, the floor's major, and never on `macos-latest` (C-R5). The first hosted run to get
past the *Test gate* step to the bundle gates on that image is run 38501500758 on
`ka-reader@3f7a68d` (`docs/SDD.md` § 4 C-I3, RN-109, RN-111).

## Traces to

- `docs/trail/architecture/cycle-75.md` § 3.3 — the CTO's item and the owner's seat's answer:
  supersede ADR-0014, restate it whole, correct the *rests on* paragraph to TextKit 1's
  `NSLayoutManager`, say what the decision becomes if Apple narrows TextKit 1, point the traces at
  the records in force, and re-read the `macos-14` sentence against C-R5. Reasoning at
  `docs/trail/architecture/self_answer-78.md` § 3.3, including its re-read of Apple's pages for the
  two classes on 2026-11-07.
- `docs/SDD.md` at v77 (Settled) — § 4 C-R5 (`:L912-L945`; the class restated at v76, RN-159);
  § 3, the `surfaces` row and its passage *The Markdown page's layout form* (`:L534`; *Open
  Questions*' third item, closed by it); § 4 C-I3 (`:L1084`; its hosted readings, `:L1328-L1345`). Carried
  from ADR-0014, re-read at v77: § 2 (force 4; table rows 1, 5 and 6; "The view is AppKit, and its
  language is Swift", `:L483`; "Undoing it", `:L497`); § 3, the units table and the Swift-frame
  paragraph; § 4 C-R1, C-R6, C-R7; § 9 TO-4, TO-7, TO-8; § 10 RC-2, RC-3; § 11 R-11; § SDD
  Review Notes RN-53, RN-59, RN-60, RN-62.
- `ka-reader-mac/Sources/Surfaces/MarkdownPageView.swift:L15-L16`, `:L29-L36`;
  `ka-reader-mac/Sources/Surfaces/CodeView.swift:L14-L15`, `:L37` — at `ka-reader@e95896f`, read by
  this run at `ka-reader@d6e9e4d`, whose tree outside `docs/` is `e95896f`'s. No source under
  `ka-reader-mac/Sources` names `NSTextLayoutManager`.
- `.github/workflows/ci.yml:L18` at `ka-reader@d6e9e4d` — `runs-on: macos-26`.
- `docs/trail/sdd/cycle-9.md` § 1.1 — the owner's (a); the CTO's, CDO's and CPO's positions, the
  CDO's pricing of what the design language keeps and loses among them.
- `docs/fdr.md` at v13 — PD-29 (the view replaced once, before any public release, and not again;
  `docs/trail/fdr/cycle-5.md` § 2.1, the owner's confirm), PD-15, PD-17, PD-28.
- `docs/DESIGN.md` § Overview, § Typography, § DESIGN Review Notes RN-1; `docs/UXD.md` § 9,
  UX-I12, UX-I15.
- `docs/SRS.md` § 7 C-3, C-11; § 3.3 FR-30; § 4.7 NFR-13.
- `Cargo.toml` `[workspace.lints.rust]` — `unsafe_code = "forbid"`.
- ADR-0014 — the record this one supersedes; its decision is restated here whole with the
  *rests on* paragraph corrected, so nothing in this record depends on that one being open. Its
  traces, and ADR-0002's before it, stand under this record.
- ADR-0011 (the rule the renderer could not start under), ADR-0021 (the shape), ADR-0026 (what the
  view is handed), ADR-0020 (the units) — where ADR-0014 named ADR-0013, ADR-0015 and ADR-0016,
  each since superseded.
- **Beyond the answer's words, three:** (1) the *Harder* paragraph's layout sentence no longer says
  the two hard cells are "settled in `read-markdown`'s first build". SDD v76 records the form found,
  and that the code cell is not met at the pin, so the restated record says that. (2) The two public
  sentences ADR-0014 called owed are recorded as landed, read at `README.md` § Stack and
  `docs/DESIGN.md:L932-L938`. (3) ADR-0026 is cited where the answer says ADR-0025, because
  ADR-0026 superseded ADR-0025 in the same fold; the decision it names is the same.
- Inputs read for this record: PRD Settled v18 · SRS Settled v14 · UXD Settled v13 · SDD Settled
  v77 · DESIGN Settled v19 · FDR Settled v13.

## Binds

QC-1, QC-8, QC-13, QC-17, QC-21, QC-23, QC-55.
