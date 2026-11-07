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
> settled records against the product at `ka-reader@71f9f69`, where the Markdown renderer and the
> containment check's port first have code. Four items follow in § 3; neither record is edited.

---

## 1. Open issues — questions with no answer yet

None.

## 2. Choices to confirm — the Principal Architect drafted a best-effort answer; confirm or override

None.

## 3. Raised from downstream — an item from a seat that did not write these records

### 3.1 ADR-0015's *Decision* says every block holds inline nodes and names fenced code alone
- **Raised by:** PM — 2026-11-07
- **Which record:** `adr/0015-markdown-as-a-typed-document-three-walls-in-one-process.md`, § *Decision*, first paragraph
- **Tracked by:** `ka-reader · nemawashi · 2026-10-02_markdown-reads-rendered`
- **What it blocks:** nothing is blocked; the binding describes a node shape the core does not have.
- **Where it shows:** "block nodes — heading with its level, paragraph, list, quote, rule, fenced code with its language and `highlighter`'s spans — each holding inline nodes" (`docs/adr/0015-…:L26-L29`). At `ka-reader@71f9f69` a heading and a paragraph hold inline nodes, a list item and a quote hold the block nodes inside them in source order, and code is fenced or indented, an indented block plain with no spans (`crates/ka-reader-core/src/markdown_renderer.rs:L38-L52`). The same correction is raised on `SDD.md` § 3 *What the system holds*; this one is in the form an Accepted record takes.
- **If a document has to be written:** none.
- **Answer:** Supersede. ADR-0015 is Accepted, so it is not edited. A new record, ADR-0025, supersedes it and restates its decision whole, with one change: the closed node set as the core builds it at `ka-reader@71f9f69` and as `docs/SDD.md` v72 § 3 now states it (RN-145). That set is a heading and a paragraph holding inline nodes; a list, whose items, and a quote, each hold block nodes in source order; a rule; and code, fenced or indented, carrying its language and `highlighter`'s spans, with a block in no floor language `Plain` and holding no spans. Nesting adds no kind, and an empty list or quote holds no blocks. The inline set, the image and link forms, the three walls, the SVG cut, the alternatives and the dependence paragraph carry over unchanged. ADR-0015's Status line becomes `Superseded by ADR-0025`, and that is the only line edited. The index gains its row. The NFDR's traces to ADR-0015 read "ADR-0025, which superseded ADR-0015 at v<n>", as ADR-0024's did, and its Binds stay QC-6, QC-11, QC-22, QC-31 and QC-37. ADR-0025 also says that adding a node kind later, such as a table, changes the closed set and takes its own record. Reasoning: `docs/trail/architecture/self_answer-75.md` § 3.1.

### 3.2 QC-11's *verified by* tail says `markdown-renderer` has no file yet
- **Raised by:** PM — 2026-11-07
- **Which record:** `nfdr.md` § 1.2, QC-11, the *verified by* tail
- **Tracked by:** `ka-reader · nemawashi · 2026-10-02_markdown-reads-rendered`
- **What it blocks:** nothing is blocked; the tail says *held* is not *measured on its code*, and there is code now.
- **Where it shows:** "`markdown-renderer` has no file yet: its clauses are held as rules, proved on planted files, and judged from the run in which its first file appears" (`docs/nfdr.md:L499-L501`). At `ka-reader@71f9f69` the unit has files at `crates/ka-reader-core/src/markdown_renderer.rs` and under `src/markdown_renderer/` (`fence.rs`, `fold.rs`, `references.rs`), and `checks/structure.sh` judges them; the tail can say it is measured on them, pinned at that commit.
- **If a document has to be written:** none.
- **Answer:** Yes. QC-11's tail now says `markdown-renderer` is measured on its code, pinned at `ka-reader@71f9f69`. Its files are `crates/ka-reader-core/src/markdown_renderer.rs` and `src/markdown_renderer/fence.rs`, `fold.rs` and `references.rs`. The scan's version 1.7.1 header says "watcher and markdown_renderer have files, and each is judged on them" (`checks/structure.sh:L126-L127` at that commit). Measured in a disposable clone at `71f9f69` on 2026-11-07: the script exits 0, printing "26 Rust files in 2 crates read — nothing found", and its suite exits 0 with 120 `ok` lines. A `use crate::folder_model::FolderModel;` planted in `fold.rs` makes the script exit 1 with "QC-11: markdown_renderer imports folder_model". The sentence "`markdown-renderer` has no file yet … *held* is not *measured on its code*" becomes a dated reading, true until `71f9f69`. Part (3) of the review-held bound stays as written: the edge into `fs-reader` reaching the containment check alone is still not held by the scan. Its *WHAT IS NOT HELD* locator is `checks/structure.sh:L354-L357` at `71f9f69`, beside the `:L331-L334` already pinned at `82a3fb1`. Reasoning: `docs/trail/architecture/self_answer-75.md` § 3.2.

### 3.3 § 9's layer-2 row names neither `--test containment` nor the containment port's contract suite
- **Raised by:** PM — 2026-11-07
- **Which record:** `nfdr.md` § 9, the test table's layer-2 row
- **Tracked by:** `ka-reader · nemawashi · 2026-10-02_markdown-reads-rendered`
- **What it blocks:** nothing is blocked; a suite the gate runs is missing from the row that lists the layer's targets.
- **Where it shows:** the row at `docs/nfdr.md:L2435`: its *Scope* cell names the Git port's contract suite as the one port suite, and its *Tool* cell lists the core's targets as `--test git_state`, `--test root_finding`, `--test markdown`, `--test highlight`, `--test watch`. At `ka-reader@71f9f69` `crates/ka-reader-core/tests/containment.rs` runs the containment port's contract suite against `FolderContainment` and its one fake, `SeededContainment` (`src/fs_reader/fakes.rs`); both cells can name it.
- **If a document has to be written:** none.
- **Answer:** Yes, both cells. The *Scope* cell adds "the containment port's contract suite against `FolderContainment` and the port's one fake, `SeededContainment`" beside the Git port's suite. The *Tool* cell adds `--test containment` to the core's targets. Both are measured at `ka-reader@71f9f69`: `crates/ka-reader-core/tests/containment.rs`, with `test_real_containment_meets_the_contract` and `test_seeded_containment_meets_the_contract`, and the fake in `src/fs_reader/fakes.rs`. The gate already runs the suite through `cargo test --workspace --locked` (`checks/gate.sh:L77` at that commit), so this is a correction to the map and changes nothing about what runs. The Git port's "owed" note stays, because QC-50's suite is still not on disk at `71f9f69`. Not asked here: the *Tool* cell is a map, not an inventory, and seven other core targets are not named in it either. This answer does not widen the cell to them. No QC entry for the containment port's one fake and suite, a counterpart to QC-50, is written until the SDD states the port (`docs/SDD_open_issues.md` § 2.1). Reasoning: `docs/trail/architecture/self_answer-75.md` § 3.3.

### 3.4 QC-10 lets `folder-model` import `fs-reader`; it does not say whether that sets aside the packet's trait-collaborator line for the containment check
- **Raised by:** PM — 2026-11-07
- **Which record:** `nfdr.md` § 1.2, QC-10
- **Tracked by:** `ka-reader · nemawashi · 2026-10-02_markdown-reads-rendered`
- **What it blocks:** nothing is blocked today; the next change on `folder-model` meets the same open call. The Rust packet says a unit is given its collaborators through a trait, and a stage that meets code building its own collaborator fixes it in its own run unless a record sets the line aside. QC-10 grants the import edge only.
- **Where it shows:** QC-10 (`docs/nfdr.md:L431-L437`): "`folder-model` may import `fs-reader` … the model calls … `markdown-renderer` for a Markdown file, on the bytes `fs-reader` returned". At `ka-reader@71f9f69` five model entry points build `FolderContainment` themselves (`crates/ka-reader-core/src/folder_model.rs:L181`, `:L229`, `:L991`, `:L1182`, `:L1252`); only the fold the layer-1 tests drive and the renderer take the check through the `ContainmentCheck` trait. Read as setting the line aside, the code keeps its form. Read the other way, `folder-model` takes its `fs-reader` collaborators, the reads and the check together, through ports wired at the bridge's composition root, and the public signatures of `select_file`, `read_file` and `FolderModel` change with every caller. QC-10 should say which.
- **If a document has to be written:** none.
- **Answer:** It sets the line aside, for this edge only, and the code keeps its form. QC-10 gains a sentence: `folder-model` reaches `fs-reader` directly — the reads (`read`, `observe_file`, `reobserve_file`) and the building of `FolderContainment` from the model's own root. This sets aside the Rust packet's "a unit is given its collaborators through a trait" for that edge alone, on `docs/SDD.md` § 2 *The four-layer default, declined by name* (`:L339-L363` at v72, RN-126). That passage declines porting `fs-reader`, because the filesystem under the grant is the product's subject and `folder-model`'s tests run on folders they make, which `testing_doctrine.md` admits at layer 1. `<CORE>/doctrine/engineering/languages/README.md` § *A fix that hands a collaborator in is not a topology decision* lets the NFDR record this setting-aside, and the SDD alone does not. The setting-aside has three bounds. (1) It reaches `fs-reader` and nothing else: the Git port still arrives through SM-2's trait, and any other collaborator the model would build is fixed in the run that meets it. (2) The renderer and the fold the layer-1 tests drive (`reduce_open_file`) keep taking the check through `ContainmentCheck`, so a layer-1 test of either is handed `SeededContainment`. (3) If the SDD's decline paragraph moves, the setting-aside loses its ground and is re-opened. Verified by review at `development-design`, since no scan can tell a permitted construction from a forbidden one. Rejected: the other reading, ports wired at `core-bridge`'s composition root, would contradict the settled SDD § 2 and re-cut SM-1, QC-8 – QC-11 and the public signatures of `select_file`, `read_file` and `FolderModel` with no upstream decision behind it. The SDD's own statement of the containment port is raised at `docs/SDD_open_issues.md` § 2.1. Reasoning: `docs/trail/architecture/self_answer-75.md` § 3.4.

**How it closes.** `product-architecture` folds it on its next run like any other item here.
