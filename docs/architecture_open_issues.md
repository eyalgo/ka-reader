# Architecture open issues — KA-Reader

> Companion to `adr/` and `nfdr.md`. The Principal Architect authored both records
> non-interactively; this file holds what the run could not settle from its inputs — the SRS, the SDD
> and the FDR.
> **Answer inline** — fill each **Answer** / **Confirm-or-override** slot — **commit this file**, then
> re-run `product-architecture`. It folds your answers into the records and drops the resolved items.
> When nothing is left open, `product-architecture` **deletes this file**: no file = the records are
> done.
>
> Your answers are never thrown away. Each time the Principal Architect folds them in, it first copies
> this file whole to `docs/trail/architecture/` — so what you decided, and why, stays readable and
> citable for good.
>
> **§ 3 is raised, not asked.** These records bind every later change, so the seats that live under
> them find gaps the authoring run could not. § 3 is where such a seat says so, against both records
> — an ADR's binding and an NFDR obligation reach the same file.

> **No `product-architecture` run wrote this file.** The PM opened it on 2026-11-07, reading the
> settled records against the product at `ka-reader@98aaa71`, where `asset_bytes` and
> `open_relative_link` first have code. One item follows in § 3; neither record is edited.

---

## 1. Open issues — questions with no answer yet

None.

## 2. Choices to confirm — the Principal Architect drafted a best-effort answer; confirm or override

### 2.1 QC-10's setting-aside loses its ground for the model's reads: SDD v74 moved the decline paragraph its bound (3) rests on
> Raised by a `companion-self-answer` run on 2026-11-07. No producing run wrote it. That run answered
> § 3.1 and read SDD v74 (Settled) as QC-10's input. At v74, § 2 narrows *The four-layer default,
> declined by name* to the building of the containment walk and adds *One read seam beside the
> decline* (SDD RN-154). The SDD says QC-10's re-opening is this seat's, on this companion
> (`docs/SDD.md:L441-L444`). No item asked for it, so this run raises it.
> Reasoning: `docs/trail/architecture/self_answer-76.md` § *Raised on this document*.
- **Lands in:** `nfdr.md` QC-10 (the setting-aside paragraph, its three bounds and its trace)
- **Drafted into the records:** nothing yet. The fold would narrow QC-10's setting-aside of the Rust packet's "a unit is given its collaborators through a trait" to the building of `FolderContainment` inside `folder-model`. That is the one thing SDD v74 § 2 still keeps outside a seam: five constructions in the model at `ka-reader@98aaa71` (`folder_model.rs:L182`, `:L230`, `:L1057`, `:L1248`, `:L1318`). The model's reads would then be stated as SM-1's trait, which SDD v74 states as design and not code. The trait is defined in `fs-reader` and has one real implementation and one `cfg`-gated fake beside `SeededContainment`. The real reader is handed to the model's entry points from the composition roots: the bridge's session and § 4 C-I3's harness. At `98aaa71` the crossing is still fifteen free-function calls into nine reads (SDD SM-1 cell). So until the change that builds the trait, `development-design` holds two things by review: no new direct read from `folder-model` into `fs-reader`, and no reader the model builds for itself. Bound (1) would read: the setting-aside reaches the walk's construction and nothing else, with the Git port arriving through SM-2's trait and the reads through SM-1's. Bound (3) stays, now aimed at the narrowed paragraph. The trace's § 2 locator moves to v74 (`docs/SDD.md:L340-L402`, and the read seam at `:L404-L449`). One related obligation is the fold's call, and the lean is to write it now as owed: the reads port's one implementation, one fake and one contract suite. That would be a QC-68 counterpart, the way QC-50 was written "owed at" a commit before its suite existed.
- **Rationale:** QC-10's bound (3) says that if the SDD's decline paragraph moves, "the setting-aside loses its ground and is re-opened" (`docs/nfdr.md:L456`). At v74 it moved. The decline's ground "for `folder-model`'s entry points: they call `fs-reader` and build `FolderContainment` themselves" now reads as the building of the walk alone. The reads move to a trait because `root` ignores a file mode, so a real folder cannot force a failed read for every runner (SDD RN-154; 37 `0o000` sites at the pin). The SDD's own text says QC-8, QC-9, QC-11, `checks/structure.sh` and the eleven-part table do not move, and names QC-10 as the one entry that does. The CTO's run left this to this seat's round on purpose (`docs/trail/sdd/self_answer-82.md` § 5.5, check 3). The fold should take it together with § 3.1 (b), which corrects the same sentence's list of reads.
- **If overridden:** no record supersedes. QC-10 keeps a setting-aside whose stated ground is gone, and nothing tells `development-design` to hold the reads to SM-1's form. The change that builds the seam would then meet an obligation that still permits the free-function calls it removes.
- **Confirm or override:** <"confirm", or "override: <what to do instead>">

## 3. Raised from downstream — an item from a seat that did not write these records

### 3.1 QC-10 lists the model's reads, its edge into the renderer and what takes the check through the port, and `asset_bytes` and `link_file` are in none of the three
- **Raised by:** PM — 2026-11-07
- **Which record:** `nfdr.md`, QC-10
- **Tracked by:** `ka-reader · nemawashi · 2026-10-02_markdown-reads-rendered`
- **What it blocks:** nothing is blocked; the obligation's three lists are one short each against the core.
- **Where it shows:** QC-10 (`docs/nfdr.md:L431-L455`), three phrases, each against `ka-reader@98aaa71`:
  (a) "`markdown-renderer` and `highlighter` — the last two to fill the open `FileView` … That is the one edge from the model into the two" — the model also asks the renderer's bitmap-format test for `asset_bytes` (`crates/ka-reader-core/src/folder_model.rs:L18`, `:L284`, `is_bitmap`);
  (b) "`folder-model` reaches `fs-reader` directly: the reads (`read`, `observe_file`, `reobserve_file`)" — it also reaches `read_contained_bytes` (`folder_model.rs:L287`; `crates/ka-reader-core/src/fs_reader.rs:L704`);
  (c) bound (2), "`markdown-renderer`, and the model's `fill_view` and `reduce_open_file`, keep taking the check through `ContainmentCheck`" — so do `asset_bytes` and `link_file` (`folder_model.rs:L278-L282`, `:L305`).
  The same facts are raised on `SDD.md` § 3 (the `SM-5` and `SM-7` rows and the units paragraph); this one is in the form an obligation takes.
- **If a document has to be written:** none.
- **Answer:** Correct all three, and widen (b) past what the item names. The facts hold at `ka-reader@09397d3` as they did at `98aaa71`: no code under `crates/` moved between the two. (a) Keep "the one edge from the model into the two" and say what crosses it. The model calls `highlighter` and `markdown-renderer` to fill the open `FileView`. It also calls the renderer's bitmap-format test, `is_bitmap`, for `asset_bytes`, and only on a path the check has already admitted (`folder_model.rs:L18`, `:L283-L284`). That is SDD v74 § 3's units paragraph (RN-152). QC-10's allowed import set does not move. (b) The reads list is short by more than the item says. At `98aaa71` the model calls nine `fs-reader` reads, in fifteen calls: `open_root`, `list`, `read`, `observe_file`, `reobserve_file`, `observe_listing`, `locate`, `locate_parent` and `read_contained_bytes`. SDD v74 § 2 *One read seam beside the decline* and its SM-1 cell count them that way. The fold should point at SM-1's cell rather than list them again. Item 2.1, raised by this run, rewrites the same sentence, and the list moves again when SM-1's trait is built, so fold the two together. (c) Bound (2) names `asset_bytes` and `link_file` beside the renderer, `fill_view` and `reduce_open_file`. Both take the check through `ContainmentCheck`, asked once per call (`contained_file`, `:L251`). The bridge, as the composition root, hands each one a `FolderContainment` (SDD v74 SM-7, RN-151; `session.rs:L1114`, `:L1253`). The bound's "a layer-1 test is handed `SeededContainment`" holds for today's tests. Both functions are tested in `tests/markdown.rs`, which § 9 places at layer 2 over the real check, and neither has a layer-1 test yet. The review clause "has the renderer, `fill_view` or `reduce_open_file` build its own check" names the two as well. Reasoning: `docs/trail/architecture/self_answer-76.md` § 3.1.

**How it closes.** `product-architecture` folds it on its next run like any other item here.
