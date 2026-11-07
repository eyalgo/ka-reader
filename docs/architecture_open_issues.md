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
- **Answer:** <the owner fills this in>

### 3.2 QC-11's *verified by* tail says `markdown-renderer` has no file yet
- **Raised by:** PM — 2026-11-07
- **Which record:** `nfdr.md` § 1.2, QC-11, the *verified by* tail
- **Tracked by:** `ka-reader · nemawashi · 2026-10-02_markdown-reads-rendered`
- **What it blocks:** nothing is blocked; the tail says *held* is not *measured on its code*, and there is code now.
- **Where it shows:** "`markdown-renderer` has no file yet: its clauses are held as rules, proved on planted files, and judged from the run in which its first file appears" (`docs/nfdr.md:L499-L501`). At `ka-reader@71f9f69` the unit has files at `crates/ka-reader-core/src/markdown_renderer.rs` and under `src/markdown_renderer/` (`fence.rs`, `fold.rs`, `references.rs`), and `checks/structure.sh` judges them; the tail can say it is measured on them, pinned at that commit.
- **If a document has to be written:** none.
- **Answer:** <the owner fills this in>

### 3.3 § 9's layer-2 row names neither `--test containment` nor the containment port's contract suite
- **Raised by:** PM — 2026-11-07
- **Which record:** `nfdr.md` § 9, the test table's layer-2 row
- **Tracked by:** `ka-reader · nemawashi · 2026-10-02_markdown-reads-rendered`
- **What it blocks:** nothing is blocked; a suite the gate runs is missing from the row that lists the layer's targets.
- **Where it shows:** the row at `docs/nfdr.md:L2435`: its *Scope* cell names the Git port's contract suite as the one port suite, and its *Tool* cell lists the core's targets as `--test git_state`, `--test root_finding`, `--test markdown`, `--test highlight`, `--test watch`. At `ka-reader@71f9f69` `crates/ka-reader-core/tests/containment.rs` runs the containment port's contract suite against `FolderContainment` and its one fake, `SeededContainment` (`src/fs_reader/fakes.rs`); both cells can name it.
- **If a document has to be written:** none.
- **Answer:** <the owner fills this in>

### 3.4 QC-10 lets `folder-model` import `fs-reader`; it does not say whether that sets aside the packet's trait-collaborator line for the containment check
- **Raised by:** PM — 2026-11-07
- **Which record:** `nfdr.md` § 1.2, QC-10
- **Tracked by:** `ka-reader · nemawashi · 2026-10-02_markdown-reads-rendered`
- **What it blocks:** nothing is blocked today; the next change on `folder-model` meets the same open call. The Rust packet says a unit is given its collaborators through a trait, and a stage that meets code building its own collaborator fixes it in its own run unless a record sets the line aside. QC-10 grants the import edge only.
- **Where it shows:** QC-10 (`docs/nfdr.md:L430-L436`): "`folder-model` may import `fs-reader` … the model calls … `markdown-renderer` for a Markdown file, on the bytes `fs-reader` returned". At `ka-reader@71f9f69` five model entry points build `FolderContainment` themselves (`crates/ka-reader-core/src/folder_model.rs:L181`, `:L229`, `:L991`, `:L1182`, `:L1252`); only the fold the layer-1 tests drive and the renderer take the check through the `ContainmentCheck` trait. Read as setting the line aside, the code keeps its form. Read the other way, `folder-model` takes its `fs-reader` collaborators, the reads and the check together, through ports wired at the bridge's composition root, and the public signatures of `select_file`, `read_file` and `FolderModel` change with every caller. QC-10 should say which.
- **If a document has to be written:** none.
- **Answer:** <the owner fills this in>

**How it closes.** `product-architecture` folds it on its next run like any other item here.
