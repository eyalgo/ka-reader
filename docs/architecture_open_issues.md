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

---

## 1. Open issues — questions with no answer yet

None.

## 2. Choices to confirm — the Principal Architect drafted a best-effort answer; confirm or override

None.

## 3. Raised from downstream — an item from a seat that did not write these records

### 3.1 QC-11's *verified by* says the structure scan leaves three of its subjects unheld; the scan holds them

- **Raised by:** PM — 2026-10-23
- **Which record:** `nfdr.md` § 1.2, QC-11's *verified by* sentence (`docs/nfdr.md:L438-L440` at
  `ka-reader@82a3fb1`)
- **Tracked by:** `ka-reader · nemawashi · 2026-10-22_the-harness-holds-the-rules-the-code-already-keeps`
- **What it blocks:** nothing is blocked; the obligation is verified, and the record says it is not.
  A reader of QC-11 is told its `git-reader`, `watcher` and `markdown-renderer` clauses wait on review
  at `development-design`, when the gate already fails on a break of any of them.
- **Where it shows:** the sentence reads "it still lists QC-11's clauses whose subject is
  `git-reader`, `watcher` or `markdown-renderer` as not held (`checks/structure.sh:L270`)". At
  `ka-reader@82a3fb1` `checks/structure.sh` is at version 1.6.0, whose top line says it "holds …
  QC-11's git_reader, watcher and markdown_renderer subjects" (`checks/structure.sh:L2-L3`); its
  *WHAT IS NOT HELD* lists QC-7, QC-12 and QC-20 and, of QC-11, only the bound on the
  `markdown-renderer` → `fs-reader` edge (`:L321-L333`); and
  `grep -c -F "QC-11's clauses whose subject is" checks/structure.sh` prints `0`. The suite
  `checks/tests/test_structure.sh` holds the planted breaks (`test_git_reader_unit_edges_are_rejected`,
  `test_future_unit_files_are_judged_without_editing_the_scan`) and exits 0 with 112 `ok` lines. The
  `:L270` locator was stale before the scan moved, too. The sentence would point at the scan's current
  header as the owner of its coverage account, and keep QC-11's two review-held parts: the
  binding-exception bounds and the renderer's containment-only bound. QC-10's adapter clause and QC-17's
  constructor clause, held by the same version, name the scan in their own *verified by* lines and
  claim no gap in it (`docs/nfdr.md:L425`, `:L665-L666`), so only QC-11's sentence is false.
- **If a document has to be written:** none — a sentence of `nfdr.md`, folded by `product-architecture`.
- **Answer:** <the owner fills this in>

**How it closes.** `product-architecture` folds it on its next run like any other item here.
