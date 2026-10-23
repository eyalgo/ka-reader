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

### 2.1 QC-15's *verified by* cites four unpinned lines of the scan and its suite, and at `ka-reader@c35081a` each lands on a different passage

> Raised by `companion-self-answer`, answering § 3.1 on 2026-10-23. No producing run wrote this item.
> Reading QC-15's tail beside QC-11's showed the same defect § 3.1 corrects there: unpinned line
> locators into `checks/structure.sh` that the scan's 2026-10-22 re-wrap and its v1.6.0 moved.
> § 2 read "None." when this run reached it, and that line is left as the producing run wrote it.

- **Lands in:** `nfdr.md` QC-15
- **Drafted into the records:** nothing. The records are not written by this run. The proposed call:
  QC-15's tail re-pins its four unpinned locators to a named commit, as RN-71 did for QC-2's.
- **Rationale:** QC-15's *verified by* pins its first two locators (`checks/structure.sh:L77-L80`,
  `:L1161`, at `ka-reader@48308ff`) and then cites four with no commit. They are
  `checks/tests/test_structure.sh:L961` and `:L931` for the exemption's two suite cases, and
  `checks/structure.sh:L266-L267` (*GAPS THE RULES ABOVE DO NOT CLOSE*, the `Path`-method gap) and
  `:L253-L256` (the two `git-reader` parts not held). At `48308ff` the scan's two locators are
  right. At `c35081a` they land in the QC-17 adapter-construction row and the QC-2 write-API row.
  The passages are now at `:L341-L342` and `:L327-L330`, and the two cases are defined at
  `test_structure.sh:L988` and `:L958`. What the tail says is still true: the scan's *WHAT IS NOT
  HELD* still names both parts as review at `development-design`. Only the pointers are false, and
  a reader following one at `HEAD` reads the wrong rule.
- **If overridden:** QC-15 keeps the four locators, read as inheriting the `48308ff` pin. The cost
  is a reader at `HEAD` reaching the QC-17 and QC-2 rows. Nothing else moves.
- **Confirm or override:** <"confirm", or "override: <what to do instead>">

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
- **Answer:** Confirmed, with three additions: correct QC-11's *verified by* as proposed. Re-measured
  at `ka-reader@c35081a`, whose `checks/structure.sh` is the blob at `82a3fb1`: the scan's v1.6.0
  header holds QC-11's `git_reader`, `watcher` and `markdown_renderer` subjects (*THE SCAN TABLE*,
  the unit-edge row `:L110-L149` and the libgit2-binding row `:L167-L181`); *WHAT IS NOT HELD*
  (`:L321-L336`) names, of QC-11, only the `markdown-renderer` → `fs-reader` bound (`:L331-L334`);
  the scan exits 0 and `checks/tests/test_structure.sh` exits 0 with 112 `ok` lines. **(1)** The
  sentence points at the header's *THE SCAN TABLE* and *WHAT IS NOT HELD* as the owner of what is
  held, the NFDR header's own rule, and names QC-11's three review-held parts at
  `development-design`: the two binding-exception bounds the tail already states, and the
  renderer's containment-only bound. **(2)** Every other locator in that tail is re-pinned to a
  named commit. At `c35081a` all three point at wrong lines: the binding row `:L130-L142` is now
  `:L167-L181`, the exempting `case` `:L1186` is now `:L1459`, and the *tests/ for layer-5 only*
  locator `:L41-L42` is now `:L46-L47`. Each was true at `076eac2`, the commit the tail names, and
  none carried the pin. **(3)** The sentence says `watcher` and `markdown-renderer` have no file
  yet. Their clauses are held as rules, proved on planted files
  (`test_future_unit_files_are_judged_without_editing_the_scan`), and judged from the run in which
  a file of either first appears. The fold cites no journey artifact (the *Tracked by* line names a
  seed), and no ADR moves. Reasoning: `docs/trail/architecture/self_answer-58.md`.

**How it closes.** `product-architecture` folds it on its next run like any other item here.
