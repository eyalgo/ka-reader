# Architecture open issues — KA-Reader

> Companion to `adr/` and `nfdr.md`. The Principal Architect authored both records
> non-interactively; this file holds what the run could not settle from its inputs — the FDR, the
> PRD, the project's finish line and the documents the project card's `Source material:` line names,
> and the SRS and the SDD where the product has them. A decision none of those inputs states, which
> the run wrote into the decisions document, `architecture_decisions.md`, is still a choice to confirm
> here.
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

### 3.1 NFDR § 9's suites bullet, pinned at `3463d17` with thirty-two suites, reads one short
- **Raised by:** PM — 2026-11-24
- **Which record:** `docs/nfdr.md` § 9, the bullet *The harness's own suites, `checks/tests/`, run as steps of `checks/gate.sh`*
- **Tracked by:** `ka-reader · nemawashi · 2026-10-30_a-stranger-can-install-the-first-release`
- **What it blocks:** nothing runs wrong; the bullet's count and its locators describe a tree the main line has left.
- **Where it shows:** `git ls-tree --name-only 3463d17 checks/tests/ | grep -c '\.sh$'` → 32; at `ka-reader@35d5e02` `ls checks/tests/*.sh | wc -l` → 33. The new suite is `checks/tests/test_readme_badge.sh`, run as the fatal step *README badge check suite* (`checks/gate.sh:L210`), after its check *README badge check* (`:L209`). `git diff -U0 66f28cb 35d5e02 -- checks/gate.sh` → two lines added after old `:L1` and seven after old `:L201`, so the bullet's `gate.sh` locators move with them.
- **If a document has to be written:** none; § 9's suites bullet is re-measured and re-pinned.
- **Answer:** <the owner fills this in>

**How it closes.** `product-architecture` folds it on its next run like any other item here.
