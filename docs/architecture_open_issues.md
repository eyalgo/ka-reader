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

> **Provenance:** hand-authored 2026-11-02 in an interactive kensaiapp-opensource session, from the
> planning halt of `ka-reader · tobiishi · 2026-11-02_the-tree-follows-the-disk`. The answers are
> the owner's. Run `product-architecture` only after `product-sdd` has folded `SDD_open_issues.md`
> §§ 5.1–5.2, because this item follows the SDD.

---

## 1. Open issues — questions with no answer yet

None.

## 2. Choices to confirm — the Principal Architect drafted a best-effort answer; confirm or override

None.

## 3. Raised from downstream — an item from a seat that did not write these records

### 3.1 The S-5 checks follow the SDD's split, and QC-9 stands

- **Raised by:** Tech Lead (development-plan halt) — 2026-11-02, carried by the owner
- **Which record:** `nfdr.md` QC-48, QC-46 and QC-40 (*verified by* and "owed by" tails), their § 10
  verification-map rows, and every NFDR line placing `watcher`.
- **Tracked by:** `ka-reader · tobiishi · 2026-11-02_the-tree-follows-the-disk`
- **What it blocks:** The tree-only change. QC-48 ties one concurrent-change check to
  `follow-the-folder`, and QC-46 and QC-40 tie their outstanding proofs to the same
  watcher/churn capability. So a tree-only change inherits checks it cannot pass.
- **Where it shows:** QC-48 (`nfdr.md` § 4, "What runs them is owed by `follow-the-folder`"), QC-46,
  and QC-40's tail added at v74. `SDD_open_issues.md` § 5.2 re-cuts S-5 into a tree slice and a
  `follow-the-folder` slice, and § 5.1 moves `watcher` out of `ka-reader-core`.
- **If a document has to be written:** No additional document; `product-architecture` folds this item
  into the existing NFDR. No ADR change is requested.
- **Answer:** Follow the settled SDD. Give the tree slice its own obligation, either a split of QC-48
  or a new QC: the tree-only churn scene with no panic, the live tree equal to a fresh read, the
  removal-then-return and failed-read sibling cases, and `checks/read-only.sh` with `--kill`
  against the scene's final state. Keep QC-48's full check, QC-46's latency measurement and
  QC-40's built-bundle proof whole, owed by `follow-the-folder`, and drop none of them. QC-9 stands
  unchanged: `ka-reader-core` imports no Apple framework or binding. Update any NFDR line that places
  `watcher` in `ka-reader-core` to the unit the SDD names. No ADR change.
