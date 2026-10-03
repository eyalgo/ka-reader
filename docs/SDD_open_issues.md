# SDD open issues — Nozoki

> Companion to `SDD.md`. Three seats — the CTO, the CPO and the CDO — authored the SDD
> non-interactively in one run; this file holds what that run could not settle from its inputs (the
> PRD, the SRS, the UXD, and any context or constraints).
>
> **Answer inline** — fill each **Answer** / **Confirm or override** / **Keep or re-cut** /
> **Your call** slot — **commit this file**, then re-run `product-sdd`. It folds your answers into
> the SDD and drops the resolved items. When nothing is left open, `product-sdd` **deletes this
> file**: no file = the SDD is done.
>
> Your answers are never thrown away. Each time the seats fold them in, they first copy this file
> whole to `docs/trail/sdd/` — so what you decided, and why, stays readable and citable for good.
>
> **§ 5 names a raiser from outside the run entirely.** It is a seat that never wrote the SDD,
> reading it after it settled and finding something only the SDD can fix.

> **No `product-sdd` run wrote this file.** The PM opened it on 2026-10-03 from the SDD's own
> companion template, after `checks/entry-points.sh` and `checks/entry-points.allow` landed
> (`nozoki@b158052`). `SDD.md` is Settled, and with no companion on disk a `product-sdd` re-run reads
> it as done and has nothing to act on. Its one item is in § 5.

---

## 5. Raised from downstream — an item from a seat that did not write the SDD

### 5.1 The `read-only-harness` row's list of what the unit owns omits files `checks/` holds
- **Raised by:** PM — 2026-10-03
- **Tracked by:** `nozoki · nemawashi · 2026-10-01_the-tree-is-checked-for-its-shape`
- **What it blocks:** nothing is blocked. The two files sit in `checks/`, the unit the row names, and
  are wired on CI. What is missing is the row naming them among what the unit owns.
- **Where it shows:** § 3's `read-only-harness` row enumerates the unit's scripts and lists
  (`docs/SDD.md:L332`): `read-only.sh`, `no-network.sh`, `bundle.sh`, `renderer.sh`, `view.sh`,
  `own-state.sh`, `churn.sh`, `latency.sh`, `structure.sh`, `deps.allow` and the fixture folders.
  `ls checks/` on `nozoki@b158052` also lists `entry-points.sh` and `entry-points.allow`, which the
  NFDR names as this unit's QC-30 check and its reviewed list (`docs/nfdr.md:L599-L604`, `:L992`).
  The same listing holds three more files the row does not name: `walk.rs`, `sandbox_probe.rs` and
  `deps.review.md`.
- **If a document has to be written:** none. § 3's `read-only-harness` row.
- **Answer:** <the owner fills this in>

**How it closes.** `product-sdd` folds it on its next run like every other item in this file, and
the trail copy and the delete-when-empty behaviour are unchanged.
