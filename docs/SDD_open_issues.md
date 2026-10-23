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
>
> **An item may name the seat that answers it.** Any item in any section carries an optional
> `- **Seat:** <seat>` field beside its other fields. Its value is the name of the agent whose posture
> answers the item — `cto`, `cpo` or `cdo`. An item with no usable value is answered in the seat of
> the skill that produced this file.
>
> **§ 5 names a raiser from outside the SDD's lanes entirely.**

> **No `product-sdd` run wrote this file.** The PM opened it on 2026-10-23, from a `shukuba-refine`
> review, to carry item 5.1 below: the SDD is Settled with no companion beside it, so without this
> file its own producing skill would find nothing to act on.

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

### 5.1 § 3's `read-only-harness` row counts eleven scripts, eleven suites and 27 gate steps; at `ka-reader@8235240` there are twelve, twelve and 29
- **Raised by:** PM — 2026-10-23
- **Seat:** cto
- **Tracked by:** `ka-reader · nemawashi · 2026-10-03_no-secret-reaches-the-repository`
- **What it blocks:** nothing. The row is pinned to `ka-reader@389adad` and is true of that tree; by
  its own rule a later change to `checks/` is a re-measurement the row is owed, not a contradiction.
- **Where it shows:** § 3, the `read-only-harness` row (`docs/SDD.md:L369`), counts "eleven scripts,
  eleven suites, thirteen fixture folders" and calls `gate.sh` "the one ordered list of 27 steps"
  (`checks/gate.sh:L45-L100` at the pin, version 1.1.0). At `ka-reader@8235240`:
  `git diff --name-status 389adad 8235240 -- checks .github` lists two added files,
  `checks/secret-scan.sh` (version 1.0.0) and `checks/tests/test_secret_scan.sh`, and modifications
  to `.github/workflows/ci.yml`, `checks/gate.sh`, `checks/no-network.sh`, `checks/structure.sh`,
  `checks/tests/test_no_network.sh` and `checks/tests/test_structure.sh`. `checks/gate.sh` is at
  version 1.2.0 (`:L2`) and `grep -c '^run_step' checks/gate.sh` prints 30 — 29 steps and the
  `run_step()` definition. The two new steps are *Secret scan suite* (`:L48`, running
  `checks/tests/test_secret_scan.sh`) and *Secret scan* (`:L58`, running
  `checks/secret-scan.sh gitleaks git`), with the comment above it at `:L49-L57` naming gitleaks
  8.30.1 and how the step fetches it. Both sit between *Toolchain* (`:L47`) and *Build the workspace*
  (`:L59`), so every gate locator the row pins below `:L47` has moved. The workflow's checkout gained
  `with: fetch-depth: 0` (`.github/workflows/ci.yml:L22-L23`), so the row's `ci.yml` locators want the
  same re-read. No `.gitleaksignore` is in the tree (`ls .gitleaksignore` → no such file). The
  new script fetches a pinned release archive and checks its SHA-256 before running it; the fold
  decides whether the row's *Owns* cell names that, beside the scanner and its suite.
- **If a document has to be written:** none. The fold would add a dated reading of the 29-step gate,
  twelve scripts and twelve suites at a named commit, with its locators re-pinned, and keep the
  `389adad` reading as a dated note.
- **Answer:** <the owner fills this in>

**How it closes.** `product-sdd` folds it on its next run like every other item in this file, and
the trail copy and the delete-when-empty behaviour are unchanged.
