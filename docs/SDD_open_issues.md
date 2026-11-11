# SDD open issues — KA-Reader

> Companion to `SDD.md`. The CTO wrote the SDD; this file holds what that run could not settle from
> its inputs (the PRD, the SRS, the UXD, and any context or constraints), and the calls that are the
> CPO's or the CDO's to make. An item whose call is the CPO's or the CDO's carries that seat's
> `Seat:`; an item whose call is the CTO's carries `cto` or no `Seat:` field.
>
> **Answer inline** — fill each **Answer** / **Confirm or override** / **Keep or re-cut** /
> **Your call** slot — **commit this file**, then re-run `product-sdd`. It folds your answers into
> the SDD and drops the resolved items. When nothing is left open, `product-sdd` **deletes this
> file**: no file = the SDD is done.
>
> Your answers are never thrown away. Each time `product-sdd` folds them in, it first copies this
> file whole to `docs/trail/sdd/` — so what you decided, and why, stays readable and citable for good.

---

## 1. Open issues — questions with no answer yet

None.

## 2. Choices to confirm — a best-effort answer was drafted; confirm or override

None.

## 3. Cut calls to confirm — where the slicing could reasonably have gone another way

None.

---

## 4. Disagreements — two seats hold different positions and neither yields

None.

## 5. Raised from downstream — an item from a seat that did not write the SDD

### 5.1 § 3's `read-only-harness` row, pinned at `7a88215`, no longer enumerates the tree
- **Raised by:** PM — 2026-11-11
- **Seat:** cto
- **Tracked by:** `ka-reader · nemawashi · 2026-10-30_a-stranger-can-install-the-first-release`
- **What it blocks:** nothing runs wrong; the row's enumeration is measured false at the current main line, so a reader of § 3 gets the wrong set of person's tools and gate steps.
- **Where it shows:** `docs/SDD.md:L544`, measured at `ka-reader@7a88215`, says every check script but six runs as a gate step, with `tree-scene.sh` and `tree-walk.sh` the person's tools. At `ka-reader@528c152` the person's tools are four — `tree-scene.sh`, `tree-walk.sh`, `git-beta-scene.sh` and `git-beta-walk.sh` — so the scripts no gate step runs are eight; the scripts and suites each gain two (`checks/tests/test_git_beta_scene.sh`, `checks/tests/test_git_beta_walk.sh`; 27 suites by `git ls-tree --name-only main checks/tests/ | grep -c '/test_.*\.sh$'`), `checks/gate.sh` gains two steps (`:L178-L179`, Version 1.17.0), the fixtures gain `checks/fixtures/git-beta-scene/`, and the line map follows. Re-measure at the current main line.
- **If a document has to be written:** none.
- **Answer:**

**How it closes.** `product-sdd` folds it on its next run like every other item in this file, and
the trail copy and the delete-when-empty behaviour are unchanged.
