# SDD open issues — ka-reader

> Companion to `SDD.md`. The CTO wrote the SDD; this file holds what that run could not settle from
> its inputs (the PRD, the SRS, the UXD, and any context or constraints), and the calls that are the
> CPO's or the CDO's to make. An item whose call is the CPO's or the CDO's carries that seat's
> `Seat:`; an item whose call is the CTO's carries `cto` or no `Seat:` field.
>
> **Answer inline** — fill each **Answer** / **Confirm or override** / **Keep or re-cut** /
> **Your call** slot — **commit this file**, then re-run `product-sdd`. It folds your answers into
> the SDD and drops the resolved items. When nothing is left open, `product-sdd` **deletes this
> file**: no file = the SDD is done.
>
> Your answers are never thrown away. Each time `product-sdd` folds them in, it first copies this
> file whole to `docs/trail/sdd/` — so what you decided, and why, stays readable and citable for good.
>
> **An item may name the seat that answers it.** Any item in any section carries an optional
> `- **Seat:** <seat>` field beside its other fields. Its value is the name of the agent whose posture
> answers the item — `cto`, `cpo` or `cdo`. An item with no usable value, whether the field is absent,
> empty or still the `<seat>` placeholder, is answered in the seat of the skill that produced this file.
> The field names the *answering* seat. It is not the seat that raised the item (`Raised by:` /
> `Held by:`), and it is not the document an answer belongs to.
>
> **An item in §§ 1–3 names the seat that raised it.** An item the CPO raised is a product call and
> an item the CTO raised is a technical one, and the answer that settles one does not settle the
> other. **§ 4 names two seats and no raiser** — a
> disagreement is not something one seat asked, it is two positions held by different seats, and the
> answer that settles it picks between them.
>
> **§ 5 names a raiser from outside the SDD's lanes entirely.** §§ 1–4 are all the SDD's own three
> lane seats; § 5 is a seat that never held a lane in it, reading it long after it settled and
> finding something only the SDD can fix. Its `Raised by:` therefore takes a wider set than §§ 1–3's,

> **No `product-sdd` run wrote this file.** The PM opened it on 2026-11-07, reading the settled SDD
> against the product at `ka-reader@e95896f`, where the reading panel first draws a Markdown page.
> Four items follow in § 5; the SDD itself is not edited.

## 1. Open issues — questions with no answer yet

None.

## 2. Choices to confirm — a best-effort answer was drafted; confirm or override

None.

## 3. Cut calls to confirm — where the slicing could reasonably have gone another way

None.

## 4. Disagreements — two seats hold different positions and neither yields

None.

## 5. Raised from downstream — an item from a seat that did not write the SDD

### 5.1 The `surfaces` row says a link's read is never ordered; a relative link's read is ordered at `ka-reader@e95896f`
- **Raised by:** PM — 2026-11-07
- **Seat:** cto
- **Tracked by:** `ka-reader · nemawashi · 2026-10-02_markdown-reads-rendered`
- **What it blocks:** nothing is blocked; the built-order passage describes every open as unordered, and one is not.
- **Where it shows:** § 3, the `surfaces` row (`docs/SDD.md:L532`), the built-order passage: "the open, act `0`, is sent only from that act's delivery and stays on the concurrent runner …, so a read is never ordered and never stalls a listing behind it". That holds for a click. A relative link crosses as one `open_relative_link` call on the serial tree-act runner, because that export admits the selection act and reads in one call (`ka-reader-mac/Sources/Shell/LaunchFlow.swift:L202-L207`; `crates/ka-reader-bridge/src/session.rs:L1249`, `link_to`), so its read is ordered and a tree act raised after it waits behind it.
- **If a document has to be written:** none — the passage is re-stated: "a click's read is never ordered", with the link's ordered read beside it.
- **Answer:** Confirmed with addition. The built-order passage is re-stated as the item proposes: a *click's* read is never ordered and never stalls a listing behind it — the open, act `0`, stays on the concurrent runner — and beside it, a *relative link's* read is ordered. The shell sends an activated link as one `open_relative_link` call on the serial tree-act runner (`ka-reader-mac/Sources/Shell/LaunchFlow.swift:L202-L207`; `treeActs` is a `SerialReadRunner`, every read off the main thread one after another in the order asked, `ReadRunning.swift:L34-L38`), because the export admits the selection act and reads in one call — `link_to` runs the containment check and the admission under one lock hold and the read from the snapshot taken in it (`crates/ka-reader-bridge/src/session.rs:L1243-L1249`) — so a tree act raised after the link waits behind that one read. Added, so the passage says why and what it costs and not only that it is so: the one-call form is the price of admitting a selection only for a path the check reaches — split into a select act and an open as a click is, the model would hold a selection for a path the check then refuses — and what waits is bounded by one read of one contained file; a link whose target is not a contained file answers `pending` with no read, so nothing waits behind it but the lock hold (`crates/ka-reader-bridge/tests/open_relative_link.rs:L203`); and the row's own rule, the model's selection is the reader's last selection act in the order made, keeps the link as a case, as SM-5's cell already says (RN-150): a tree or Git selection made while the link's read is out wins (`open_relative_link.rs:L288`, `test_a_later_select_act_during_the_links_read_wins`; `ka-reader-mac/Sources/Surfaces/WorkbenchView.swift:L264-L272`). Pinned at `ka-reader@e95896f`. Reasoning: `docs/trail/sdd/self_answer-84.md` § 5.1.

### 5.2 The third Open Question still stands, and the `surfaces` row names no layout form; the build used one
- **Raised by:** PM — 2026-11-07
- **Seat:** cto
- **Tracked by:** `ka-reader · nemawashi · 2026-10-02_markdown-reads-rendered`
- **What it blocks:** nothing is blocked; § 6 S-3's command half says "the third Open Question closes and `surfaces`' row names the layout form found in this slice" (`docs/SDD.md:L2221-L2223`), and neither has happened.
- **Where it shows:** *Open Questions*, third item (`docs/SDD.md:L10997-L11002`), and the `surfaces` row, "rendered Markdown laid out from a `MarkdownDocument` by TextKit" (`:L532`). The form the build used, in `ka-reader-mac/Sources/Surfaces/MarkdownPageView.swift`: TextKit 1 from construction, an `NSLayoutManager` over the page's storage (`:L29-L36`), because "the placeholder box is a text block, which TextKit 2 does not lay out" (`:L15-L16`); a resolved image is an `NSTextAttachment` in the flow of the prose (`:L300-L303`); a placeholder box is an `NSTextBlock` with a border and padding holding the alt text, the source and the sentence (`:L322-L340`); a fenced code block is its text in the code font with its spans' colours (`:L352-L362`), with no block or surface of its own. The question's settling run — the layout fixtures at `docs/DESIGN.md`'s prose measure on the floor macOS — was not recorded by the build.
- **If a document has to be written:** none — the item is struck and the row names the form. Whether a fenced block with no surface of its own meets the question's "fenced code on its own surface inside prose" is the CTO's to say.
- **Answer:** Confirmed with addition. The third Open Question is struck and the `surfaces` row names the form found at `ka-reader@e95896f`, in `ka-reader-mac/Sources/Surfaces/MarkdownPageView.swift`: the page is one `NSTextView` under TextKit 1 from construction — an `NSLayoutManager` over the page's storage (`:L29-L36`), because the placeholder box is a text block and TextKit 2 does not lay out an `NSTextBlock` (`:L15-L16`); a resolved image is an `NSTextAttachment` in the flow of the prose, scaled to no wider than the prose measure, 704 points (`:L300-L303`, `:L404-L408`); a placeholder box is an `NSTextBlock` with a one-point border and padding, holding the alt text, the source and the sentence (`:L322-L340`); no custom layout fragment. Three additions. **One — the code cell is not settled by the build, and the row says so as a known defect until a change lands.** A fenced block is drawn as its text in the code font with its spans' colours and nothing else (`:L352-L362`): no background, no padding, no block. `docs/DESIGN.md` puts fenced and inline code "on `{colors.canvas}` so code stands off the prose without a border" (`:L483-L484`) and gives `{components.prose-code}` that background, `{rounded.sm}` and `{spacing.xs}` padding (`:L272-L277`); so "fenced code on its own surface inside prose" is not met at the pin, and inline code (`:L262-L264`) misses the same surface. The form for it is the one the box already proves lays out in the flow: an `NSTextBlock` carrying the canvas background and the padding and no border — the same mechanism under the same manager — and the row names it as the design, with the drawing at the pin a known defect until a change of this slice lands. The question closes because the form is found for both cells, not because both are drawn. **Two — § 4 C-R5's parenthetical moves with it.** It says the Markdown treatment lays out with "TextKit 2's `NSTextLayoutManager`", available from macOS 12.0 (`docs/SDD.md:L885-L887`); the treatment lays out with TextKit 1's `NSLayoutManager`, as the code treatment does for its gutter (`CodeView.swift:L14-L15`, `:L37`), older still, and the clause's point — the floor is the maintainer's narrowing, not the stack's — stands. **Three — what the settling run was.** The question said the layout fixtures rendered at the prose measure on the floor macOS settle it. The build's tests assert the string — its attachments and its blocks (`ka-reader-mac/Tests/SurfacesTests/MarkdownPageSupport.swift:L62`, `:L77`) in a 600-point frame (`:L13`) — and no geometry, and the macOS the gate ran on at `470abf2` is not recorded; the row says so, and the rendering at the measure on every macOS the floor admits stays § 11 R-11's release walk, as `docs/nfdr.md` already reads it — "walked by hand … not asserted" (`:L2583-L2585`). § 9 TO-4, § 11 R-11 and RN-63 keep their words: each says the form is written into the row, which this does. Reasoning: `docs/trail/sdd/self_answer-84.md` § 5.2.

### 5.3 The `read-only-harness` row's enumeration has no entry for `checks/fixtures/malformed-images/`
- **Raised by:** PM — 2026-11-07
- **Seat:** cto
- **Tracked by:** `ka-reader · nemawashi · 2026-10-02_markdown-reads-rendered`
- **What it blocks:** nothing is blocked; the row's on-disk inventory is one fixture folder short.
- **Where it shows:** § 3, the `read-only-harness` row (`docs/SDD.md:L533`), pinned at `ka-reader@71f9f69`; `grep -c 'malformed-images' docs/SDD.md` → `0`. At `ka-reader@e95896f` `checks/fixtures/malformed-images/` holds `malformed.png`, `malformed.jpg`, `malformed.gif` and `malformed.webp` (§ 11 R-4's malformed fixtures), read by `ka-reader-mac/Tests/SurfacesTests/MarkdownTreatmentTests.swift` (`:L85`, `eachMalformedBitmapHandedOverAsBytesDrawsTheUnreadableBox`) and `MarkdownPageTests.swift`.
- **If a document has to be written:** none — the enumeration is re-measured.
- **Answer:** Confirmed with addition. The row is re-measured at `ka-reader@e95896f` and re-pinned there. `git diff --name-status 71f9f69 e95896f -- checks .github` lists five files: four added under `checks/fixtures/malformed-images/` — `malformed.png`, `malformed.jpg`, `malformed.gif` and `malformed.webp`, § 11 R-4's four malformed bitmaps — and `checks/walk.rs` changed; nothing else under `checks/` or `.github` moved, so `gate.sh` stays at 1.9.0 with its 38 steps, `fixtures/.gitignore` six lines, the workflow 41 lines, and every other count and locator stands as pinned. The count reads sixteen fixture folders, and `malformed-images` joins the enumeration with what reads it: `ka-reader-mac/Tests/SurfacesTests/MarkdownPageSupport.swift:L38-L46` reads each of the four by the repository-relative path `checks/fixtures/malformed-images/<name>`, resolved from the test file's own location, and two suites take all four by name — `MarkdownTreatmentTests.swift:L84-L85`, `eachMalformedBitmapHandedOverAsBytesDrawsTheUnreadableBox`, which hands the bytes to the panel as `asset_bytes`' answer and expects the unreadable box and the paragraph after it, and `MarkdownPageTests.swift:L166-L168` — run by `swift test` in the gate's *Test gate* step (`checks/gate.sh:L77`). Like `fixtures/hostile.md`, the folder is paired with no `checks/` suite and is the whole command of no step; unlike it, its reader is the Swift package, the one fixture under `checks/` a Swift suite reads. The addition: the re-measurement names `checks/walk.rs` too, because the pin moves for the whole of `checks/` — the walk now calls `asset_bytes` and `link_file` through the real containment check on the root and on every file entry, drives the open a link makes where `link_file` answers a file, and refuses a pass that reached either zero times (`checks/walk.rs:L1-L9`; built at `f0d767c`, in the bridge change, § 4 C-I3's rule) — and the row's one mention of `walk.rs` carries no line locator, so no sentence of the row went stale from it. Reasoning: `docs/trail/sdd/self_answer-84.md` § 5.3.

### 5.4 A relative link to a folder is drawn as a control that does nothing, and the closed node set has no way to say so
- **Raised by:** PM — 2026-11-07
- **Seat:** cto
- **Tracked by:** `ka-reader · nemawashi · 2026-10-02_markdown-reads-rendered`
- **What it blocks:** `docs/UXD.md` UX-I12, "it is a control only where activating it does something", cannot be met for a relative link whose target is a folder.
- **Where it shows:** § 3's `MarkdownDocument`, "A link node is *external* (inert, its destination readable) or *relative* (a contained target path)" (`docs/SDD.md:L737-L738`). The renderer makes a *relative* node for any entry the containment check reaches, a folder included (`crates/ka-reader-core/src/markdown_renderer/references.rs:L95`; pinned by `crates/ka-reader-core/tests/unit/markdown_renderer.rs:L685`, `test_a_relative_link_carries_the_entry_the_check_reached_whatever_its_kind`). The node carries no kind, and `surfaces` draws only what the bridge sent, so the page makes every relative node a control (`ka-reader-mac/Sources/Surfaces/MarkdownPageView.swift:L280-L281`); activating one whose target is a folder answers `pending` and nothing happens. Two routes close it: a relative node that knows its target is a folder, or a folder target built as an inert node. Either moves the closed set, and `docs/adr/0025-markdown-as-a-typed-document-the-closed-node-set-as-built.md` binds that set.
- **If a document has to be written:** none in the SDD beyond the node set's line; the ADR follows whichever route is taken.
- **Answer:** Answered: the second route — a relative link whose target the check reaches at a folder is built as an inert node, and the closed set says so. `MarkdownDocument`'s line reads: a link node is *external* (inert, its destination readable — a scheme or a fragment, a path the check refuses, or a contained entry that is not a file) or *relative* (a contained file's path). No kind joins a node and no node kind joins the set: *external* already means "nothing here to open", since a missing or escaping path is an external node today (`crates/ka-reader-core/src/markdown_renderer/references.rs:L94-L96`, `Err(_) => External`), and a folder is one more thing nothing opens — the panel reads files (`docs/UXD.md` UX-I12, "opens the target file in the reading panel exactly as a tree selection does"; `docs/SRS.md` FR-32, "a relative link to a file inside the viewed folder"). The first route — a relative node carrying its target's kind — was weighed and not taken: the kind would be read by exactly one consumer, the page's is-it-a-control decision, which the two forms already answer, so it widens the type for no behaviour. At `ka-reader@e95896f` this is a known defect until a change lands: `link_target` makes a *relative* node for any entry the check reaches (`references.rs:L95`), the unit test `test_a_relative_link_carries_the_entry_the_check_reached_whatever_its_kind` (`crates/ka-reader-core/tests/unit/markdown_renderer.rs:L685`) pins that and is re-stated by the change, and the page makes every relative node a control (`ka-reader-mac/Sources/Surfaces/MarkdownPageView.swift:L279-L281`), one whose activation on a folder answers `pending` and draws nothing (`crates/ka-reader-bridge/tests/open_relative_link.rs:L203`, `src` in its refused list; `WorkbenchView.swift:L279`). What stays: the check at activation — `link_file` answers only a contained file (`crates/ka-reader-core/src/folder_model.rs:L305-L307`) — so a file that becomes a folder after the render is still a control that does nothing, the case the symlink-swap test already accepts (`open_relative_link.rs:L257`), and a folder that becomes a file stays inert until the document is read again; the kind is read at render and the page never asks again. ADR-0025 binds the set and its link sentence moves with this: raised on `docs/architecture_open_issues.md` § 3.2, beside the PM's § 3.1 on the same sentence, landed in commit `0b17e99`. Reasoning: `docs/trail/sdd/self_answer-84.md` § 5.4.
