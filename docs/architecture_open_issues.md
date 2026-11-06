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

### 3.1 An unpinned `checks/gate.sh` line locator in the NFDR now names a different line
- **Raised by:** PM — 2026-11-06
- **Which record:** `nfdr.md`, the passage at its line 2297 (the *Tree scene helper suite* locator)
- **Tracked by:** `ka-reader · nemawashi · 2026-10-13_the-tree-and-the-open-file-follow-the-disk`
- **What it blocks:** nothing is blocked; a reader following the locator lands on the wrong step.
- **Where it shows:** "the gate's *Tree scene helper suite* step, `checks/gate.sh:L127`" names no commit. At `ka-reader@d6bc3a3` the gate holds two displayed-file steps after *Read-only, tree scene, killed* (`checks/gate.sh:L112-L113`), and the step is at `checks/gate.sh:L133`; `:L127` is now a comment line. Re-pin it at a commit, or name the step alone.
- **If a document has to be written:** none.
- **Answer:** <the owner fills this in>

**How it closes.** `product-architecture` folds it on its next run like any other item here.
