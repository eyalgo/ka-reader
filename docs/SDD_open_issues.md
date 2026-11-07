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
> which stay fixed to the three lane seats on purpose.

> **No `product-sdd` run wrote this file.** The PM opened it on 2026-11-07, reading the settled SDD
> against the product at `ka-reader@98aaa71`, where `asset_bytes` and `open_relative_link` first have
> code. Five items follow in § 5; the SDD itself is not edited.

## 1. Open issues — questions with no answer yet

None.

## 2. Choices to confirm — a best-effort answer was drafted; confirm or override

None.

## 3. Cut calls to confirm — where the slicing could reasonably have gone another way

None.

## 4. Disagreements — two seats hold different positions and neither yields

None.

## 5. Raised from downstream — an item from a seat that did not write the SDD

### 5.1 `SM-5`'s *Down* cell says three functions stand beside the request types; five do at `ka-reader@98aaa71`
- **Raised by:** PM — 2026-11-07
- **Seat:** cto
- **Tracked by:** `ka-reader · nemawashi · 2026-10-02_markdown-reads-rendered`
- **What it blocks:** nothing is blocked; the cell names the bridge's fixed orders, and the link's is missing.
- **Where it shows:** § 3, the `SM-5` row (`docs/SDD.md:L562`): "At `ka-reader@d6bc3a3` three functions stand beside the request types", with its paragraph on how the bridge drives them. At `ka-reader@98aaa71` `folder-model` also holds `asset_bytes(folder, path, check)`, answering a contained bitmap's bytes or `None` (`crates/ka-reader-core/src/folder_model.rs:L278`), and `link_file(path, check)`, answering the path as given when the check passes it to a file (`:L305`); both take the check through `ContainmentCheck` and ask it once per call. The bridge's link is one more fixed order: `link_file` and the selection act under one lock hold, `read_file` outside it, then the open's fold under it (`crates/ka-reader-bridge/src/session.rs:L1243`, `link_to`; `:L1211`, `read_and_fold`).
- **If a document has to be written:** none — the cell is re-stated.
- **Answer:** <the owner fills this in>

### 5.2 `SM-7` says `asset_bytes` is not built and stands as design; it is built at `ka-reader@98aaa71`
- **Raised by:** PM — 2026-11-07
- **Seat:** cto
- **Tracked by:** `ka-reader · nemawashi · 2026-10-02_markdown-reads-rendered`
- **What it blocks:** nothing is blocked; the row describes as future what the core now does.
- **Where it shows:** § 3, the `SM-7` row (`docs/SDD.md:L564`): "`asset_bytes` is not built at that pin and stands as design — when built it is handed `FolderContainment` from the composition root". At `ka-reader@98aaa71` the bridge's session builds `FolderContainment` over the held folder's root (`crates/ka-reader-bridge/src/session.rs:L1114`, `:L1253`) and hands it to `folder-model`'s `asset_bytes` and `link_file`.
- **If a document has to be written:** none — the row is re-stated.
- **Answer:** <the owner fills this in>

### 5.3 § 3's units paragraph names one edge from the model into the renderer, to fill a `FileView`; `asset_bytes` adds a second use of it
- **Raised by:** PM — 2026-11-07
- **Seat:** cto
- **Tracked by:** `ka-reader · nemawashi · 2026-10-02_markdown-reads-rendered`
- **What it blocks:** nothing is blocked; the paragraph states what the edge carries, and it now carries one more call.
- **Where it shows:** § 3, the units paragraph (`docs/SDD.md:L463-L466`): "The model calls down to `markdown-renderer` and `highlighter` to fill a `FileView` … the one edge from the model into the two". At `ka-reader@98aaa71` the model also calls the renderer's bitmap-format test for `asset_bytes` (`crates/ka-reader-core/src/folder_model.rs:L18`, `:L284`, `is_bitmap`). It is still the one edge, in that direction only.
- **If a document has to be written:** none — the paragraph is re-stated.
- **Answer:** <the owner fills this in>

### 5.4 `SM-4`'s locator for the admitted export set points at lines that moved
- **Raised by:** PM — 2026-11-07
- **Seat:** cto
- **Tracked by:** `ka-reader · nemawashi · 2026-10-02_markdown-reads-rendered`
- **What it blocks:** nothing is blocked; a reader following the locator lands on the wrong lines.
- **Where it shows:** § 3, the `SM-4` row (`docs/SDD.md:L561`): "`--test exports` holds the admitted set (`crates/ka-reader-bridge/tests/exports.rs:L18-L22`)". At `ka-reader@98aaa71` the set is seven names at `crates/ka-reader-bridge/tests/exports.rs:L26-L34` (`const ADMITTED: [&str; 7]`).
- **If a document has to be written:** none — the locator is re-pinned.
- **Answer:** <the owner fills this in>

### 5.5 § 2's decline of a filesystem port rests on tests that make their own folders, and does not say how a test forces a failed read
- **Raised by:** PM — 2026-11-07
- **Seat:** cto
- **Tracked by:** `ka-reader · nemawashi · 2026-11-06_failed-reads-go-through-a-seam`
- **What it blocks:** that seed's route: a seam for the model's reads is the port this paragraph declines, and `docs/nfdr.md` QC-10's setting-aside re-opens only when this paragraph moves (its bound (3)).
- **Where it shows:** § 2, *The four-layer default, declined by name* (`docs/SDD.md:L340-L352`): "`folder-model`'s tests run against folders they make themselves, which `testing_doctrine.md` … admits at layer 1". The same doctrine's § *A test reads nothing of the machine it runs on*, "Who runs it", says a file made unreadable with a mode proves nothing when `root` runs the test, and that the code reads through a seam instead. At `ka-reader@98aaa71` 37 sites in 13 files force a failed read with mode `0o000` (`git grep -c '0o000' -- crates`), among them `crates/ka-reader-core/tests/markdown.rs:L403`; the model's reads have no door a test can hand a failing reader through (`crates/ka-reader-core/src/folder_model.rs:L287`, `read_contained_bytes`). Lean: the decline stands for the filesystem as the subject, and a read seam narrow enough to hand in a failure is stated beside it.
- **If a document has to be written:** none — the paragraph is re-stated, and QC-10 follows by its own bound.
- **Answer:** <the owner fills this in>

**How it closes.** `product-sdd` folds it on its next run like every other item in this file, and
the trail copy and the delete-when-empty behaviour are unchanged.
