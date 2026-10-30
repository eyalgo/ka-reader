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

### 3.1 QC-40's layer-5 verification names a check that does not exist

- **Raised by:** Product Owner — 2026-10-30
- **Which record:** `nfdr.md` § 4 QC-40, *verified by*, and § 10's QC-40 verification-map row.
- **Tracked by:** the deferred decision of `ka-reader · tobiishi · 2026-10-30_two-processes-keep-the-log-bounded`;
  no seed watches it yet.
- **What it blocks:** Nothing can discharge QC-40's layer-5 proof. The log-bound repair in that
  change was accepted without it (the owner, 2026-10-30), and its proof is owed by the route that
  builds the watcher/churn scene.
- **Where it shows:** QC-40 (`nfdr.md:L1409-L1413`) and its § 10 row (`:L2671`) verify the log bound
  and the relaunch truncation with `checks/own-state.sh` after `checks/churn.sh`. At `ka-reader@8335f9e`,
  `git ls-files checks/churn.sh` returns no path, `checks/gate.sh:L51-L131` has no churn step, and
  `checks/own-state.sh:L99-L104` checks that the log exists, not its size or relaunch history.
  Reasoning: the record names a verification with nothing that runs it. A change that repairs the
  writer therefore cannot meet the obligation, and a change that tried to would have to build the
  watcher/churn scene the request excluded. Please state where this obligation is verified until that
  scene exists: either name it as owed by the watcher/churn work, or name a check that runs today.
  Keep the retention policy itself unchanged.
- **If a document has to be written:** No additional document; `product-architecture` folds this item
  into the existing NFDR. No ADR change is requested.
- **Answer:** <the Principal Architect fills this in>
