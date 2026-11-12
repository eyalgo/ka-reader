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

### 5.1 § 3's `read-only-harness` row, pinned at `528c152`, no longer enumerates the tree
- **Raised by:** PM — 2026-11-12
- **Seat:** cto
- **Tracked by:** `ka-reader · nemawashi · 2026-10-30_a-stranger-can-install-the-first-release`
- **What it blocks:** nothing runs wrong; the row says a file landing in `checks/` after its pin "owes this row an item" (`docs/SDD.md:L545`), and nine have.
- **Where it shows:** `git diff --name-status 528c152 03bb989 -- checks .github ka-reader-mac/icon.icns` lists `checks/app-icon.sh`, `checks/icon_probe/main.swift`, `checks/tests/test_app_icon.sh` and `checks/tests/test_assemble.sh` added; `ka-reader-mac/icon.icns` renamed to `checks/fixtures/stand-in-icon.icns`; and `checks/bundle.sh`, `checks/gate.sh`, `checks/tests/test_bundle.sh` and `checks/tests/test_readme.sh` changed; nothing under `.github/`. The scripts gain one gate step's script and a compiled probe folder, the suites two (29 by `git ls-tree --name-only main checks/tests/ | grep -c '/test_.*\.sh$'`), `checks/gate.sh` three steps (`:L114`, `:L115`, `:L119`, Version 1.20.0), and the fixtures one binary file. Re-measure at the current main line.
- **If a document has to be written:** none.
- **Answer:**

**How it closes.** `product-sdd` folds it on its next run like every other item in this file, and
the trail copy and the delete-when-empty behaviour are unchanged.
