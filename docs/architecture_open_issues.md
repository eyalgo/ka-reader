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

> **Provenance:** hand-authored 2026-11-02 in an interactive kensaiapp-opensource session. The
> `product-architecture` run that folded cycle-66 had its commit refused by Codex's approval review.
> It also left its full reread undone, so the owner committed its work by hand with the NFDR at
> `Draft` (`7d091b5`). The product-docs chain reads only whether a companion exists, so without
> this file it reports the NFDR as settled.

---

## 1. Open issues — questions with no answer yet

None.

## 2. Choices to confirm — the Principal Architect drafted a best-effort answer; confirm or override

None.

## 3. Raised from downstream — an item from a seat that did not write these records

### 3.1 NFDR v75 was committed before its run's full reread

- **Raised by:** Product (owner) — 2026-11-02
- **Which record:** `nfdr.md` v75 as a whole: the cycle-66 § 3.1 fold (QC-66, QC-48, QC-46, QC-40, the
  bridge `watcher` placement, and the § 10 verification-map rows).
- **Tracked by:** `ka-reader · tobiishi · 2026-11-02_the-tree-follows-the-disk`
- **What it blocks:** The re-run of that change from `development-specs`, which needs a settled NFDR.
- **Where it shows:** `nfdr.md:L3` reads `Draft`. The folding run's final message says "Product checks and
  the skill's complete reread were not performed" (session `01a19d6e-e1fd-73e1-b560-3da2d22f247c`).
- **If a document has to be written:** No additional document. No ADR change is requested.
- **Answer:** Do the full reread that the cycle-66 fold skipped, against `docs/SDD.md` v66 and the
  owner's answer at `docs/trail/architecture/cycle-66.md` § 3.1. Correct whatever the reread finds,
  without reopening that answer. Then mark the NFDR `Settled`. No new obligation and no ADR change.
