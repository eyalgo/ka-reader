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

> **No `product-architecture` run wrote this file.** The PM opened it on 2026-10-21, from a
> `shukuba-refine` review on the seed `ka-reader · nemawashi · 2026-10-01_ci-and-harness-to-their-bar`,
> to carry item 3.1 below. The NFDR is Settled, so without a companion it would reach no one.

---

## 1. Open issues — questions with no answer yet

None.

## 2. Choices to confirm — the Principal Architect drafted a best-effort answer; confirm or override

None.

## 3. Raised from downstream — an item from a seat that did not write these records

### 3.1 QC-2's three locators into `checks/read-only.sh` no longer name what they cite
- **Raised by:** PM — 2026-10-21
- **Which record:** `nfdr.md` QC-2, the walk-fixture sentence (`docs/nfdr.md:L100-L102`).
- **Tracked by:** `ka-reader · nemawashi · 2026-10-01_ci-and-harness-to-their-bar`
- **What it blocks:** nothing. A reader following the locators lands on the wrong lines.
- **Where it shows:** QC-2 cites the in-place restore at `checks/read-only.sh:L73-L76`, and what is
  hashed at `:L17-L20` and `:L84`. None of the three is pinned to a commit. At `ka-reader@c268945`
  `:L73-L76` is the usage refusal, the hashing header is at `:L19-L22`, the restore is `restore()` at
  `:L210` with its header at `:L24-L29`, and the first hash is at `:L368`. The restore now unpacks the
  archive in scratch space, copies in only the entries the fixture lacks, and removes them once the
  verdict is taken (`:L31-L36`). So it still builds a walk fixture whole for the walk, and QC-2's
  sentence still holds. Only its locators moved.
- **If a document has to be written:** none. The fold would pin the three locators to a named commit.
  The sentence's claim does not change.
- **Answer:** <the owner fills this in>

**How it closes.** `product-architecture` folds it on its next run like any other item here.
