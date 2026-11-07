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

None.

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
- **Answer:** <the owner fills this in>

**How it closes.** `product-architecture` folds it on its next run like any other item here.
