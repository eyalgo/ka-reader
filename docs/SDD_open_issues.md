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
- **Answer:** <the owner fills this in>

### 5.2 The third Open Question still stands, and the `surfaces` row names no layout form; the build used one
- **Raised by:** PM — 2026-11-07
- **Seat:** cto
- **Tracked by:** `ka-reader · nemawashi · 2026-10-02_markdown-reads-rendered`
- **What it blocks:** nothing is blocked; § 6 S-3's command half says "the third Open Question closes and `surfaces`' row names the layout form found in this slice" (`docs/SDD.md:L2221-L2223`), and neither has happened.
- **Where it shows:** *Open Questions*, third item (`docs/SDD.md:L10997-L11002`), and the `surfaces` row, "rendered Markdown laid out from a `MarkdownDocument` by TextKit" (`:L532`). The form the build used, in `ka-reader-mac/Sources/Surfaces/MarkdownPageView.swift`: TextKit 1 from construction, an `NSLayoutManager` over the page's storage (`:L29-L36`), because "the placeholder box is a text block, which TextKit 2 does not lay out" (`:L15-L16`); a resolved image is an `NSTextAttachment` in the flow of the prose (`:L300-L303`); a placeholder box is an `NSTextBlock` with a border and padding holding the alt text, the source and the sentence (`:L322-L340`); a fenced code block is its text in the code font with its spans' colours (`:L352-L362`), with no block or surface of its own. The question's settling run — the layout fixtures at `docs/DESIGN.md`'s prose measure on the floor macOS — was not recorded by the build.
- **If a document has to be written:** none — the item is struck and the row names the form. Whether a fenced block with no surface of its own meets the question's "fenced code on its own surface inside prose" is the CTO's to say.
- **Answer:** <the owner fills this in>

### 5.3 The `read-only-harness` row's enumeration has no entry for `checks/fixtures/malformed-images/`
- **Raised by:** PM — 2026-11-07
- **Seat:** cto
- **Tracked by:** `ka-reader · nemawashi · 2026-10-02_markdown-reads-rendered`
- **What it blocks:** nothing is blocked; the row's on-disk inventory is one fixture folder short.
- **Where it shows:** § 3, the `read-only-harness` row (`docs/SDD.md:L533`), pinned at `ka-reader@71f9f69`; `grep -c 'malformed-images' docs/SDD.md` → `0`. At `ka-reader@e95896f` `checks/fixtures/malformed-images/` holds `malformed.png`, `malformed.jpg`, `malformed.gif` and `malformed.webp` (§ 11 R-4's malformed fixtures), read by `ka-reader-mac/Tests/SurfacesTests/MarkdownTreatmentTests.swift` (`:L85`, `eachMalformedBitmapHandedOverAsBytesDrawsTheUnreadableBox`) and `MarkdownPageTests.swift`.
- **If a document has to be written:** none — the enumeration is re-measured.
- **Answer:** <the owner fills this in>

### 5.4 A relative link to a folder is drawn as a control that does nothing, and the closed node set has no way to say so
- **Raised by:** PM — 2026-11-07
- **Seat:** cto
- **Tracked by:** `ka-reader · nemawashi · 2026-10-02_markdown-reads-rendered`
- **What it blocks:** `docs/UXD.md` UX-I12, "it is a control only where activating it does something", cannot be met for a relative link whose target is a folder.
- **Where it shows:** § 3's `MarkdownDocument`, "A link node is *external* (inert, its destination readable) or *relative* (a contained target path)" (`docs/SDD.md:L737-L738`). The renderer makes a *relative* node for any entry the containment check reaches, a folder included (`crates/ka-reader-core/src/markdown_renderer/references.rs:L95`; pinned by `crates/ka-reader-core/tests/unit/markdown_renderer.rs:L685`, `test_a_relative_link_carries_the_entry_the_check_reached_whatever_its_kind`). The node carries no kind, and `surfaces` draws only what the bridge sent, so the page makes every relative node a control (`ka-reader-mac/Sources/Surfaces/MarkdownPageView.swift:L280-L281`); activating one whose target is a folder answers `pending` and nothing happens. Two routes close it: a relative node that knows its target is a folder, or a folder target built as an inert node. Either moves the closed set, and `docs/adr/0025-markdown-as-a-typed-document-the-closed-node-set-as-built.md` binds that set.
- **If a document has to be written:** none in the SDD beyond the node set's line; the ADR follows whichever route is taken.
- **Answer:** <the owner fills this in>
