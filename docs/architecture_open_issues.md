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

> **No `product-architecture` run wrote this file.** The PM opened it on 2026-10-23, from a
> `shukuba-refine` review, to carry item 3.1 below: the records stand with no companion beside them,
> so without this file their producing skill would find nothing to act on.

---

## 1. Open issues — questions with no answer yet

None.

## 2. Choices to confirm — the Principal Architect drafted a best-effort answer; confirm or override

None.

## 3. Raised from downstream — an item from a seat that did not write these records

### 3.1 §§ 8 and 9 count the gate at 29 steps and the harness at twelve suites, with one step reaching the network; at `ka-reader@1b32500` the gate has 30 steps, thirteen suites, and two steps that fetch on every run

- **Raised by:** PM — 2026-10-23
- **Which record:** `nfdr.md` § 8, the paragraph **Until the card runs the script**
  (`docs/nfdr.md:L1665` onward; its gate reading at `:L1676-L1686`), and § 9, the bullet **The
  harness's own suites** (`:L2059` onward; its suite enumeration and locators at `:L2071-L2080`)
- **Tracked by:** `ka-reader · nemawashi · 2026-10-03_no-secret-reaches-the-repository`
- **What it blocks:** nothing is blocked. Both passages are pinned to `ka-reader@8235240` and true of
  it, and by § 9's own wording a suite added to the gate is a re-measurement of those sentences.
- **Where it shows:** § 8 says the script is version 1.2.0 with 29 steps at `ka-reader@8235240`
  (`:L1678-L1681`), and that "the scan step is the one step that reaches the network on every run"
  (`:L1684-L1685`). § 9 says "Twelve suites are in the tree" and lists them with their `gate.sh`
  lines (`:L2071-L2080`). At `ka-reader@1b32500`, `checks/gate.sh` is version 1.3.0 (`:L2`, "the
  planted-secret suite, the scan's negative control, joins the list") and
  `grep -c '^run_step' checks/gate.sh` prints 31 — 30 steps and the `run_step()` definition. The new
  step is *Planted secret suite* (`:L67`, `checks/tests/test_secret_scan_planted.sh`), directly after
  *Build the workspace* (`:L60`), with the comment at `:L61-L66` saying why it must come after that
  step. *Secret scan suite* is now at `:L49` and *Secret scan* at `:L59`, so every gate locator § 9
  cites has moved. `ls checks/tests/` lists thirteen suites, the twelve § 9 names and
  `test_secret_scan_planted.sh`. That suite pairs with no new script: it runs the real
  `checks/secret-scan.sh gitleaks git` twice, over a disposable repository holding one clean commit
  and then one commit with a secret-shaped string built at run time, and passes only when the clean
  run exits 0 and the planted run exits non-zero with a finding at the planted commit. Each run
  fetches gitleaks 8.30.1 and checks its pinned SHA-256, so the gate now fetches three times on every
  run, in two steps. A machine that cannot reach `github.com` already ends the gate at *Secret scan*,
  before this step. Measured in a disposable clone at `ka-reader@1b32500` on the host: the suite
  exited 0, `19 of 19 passed`, with two `whose release archive matched its pinned SHA-256` lines and
  one `secret-scan.sh: finding at commit` line; `checks/secret-scan.sh gitleaks git` then printed `ok`
  with `commits scanned: 1291`, equal to `git rev-list --count HEAD`. The whole gate exited 0 in the
  macOS guest on the tree of `ka-reader@38b4e3e`, and `git diff --stat 38b4e3e 1b32500` touches only
  `docs/build_cost.md`.
- **If a document has to be written:** none — sentences of `nfdr.md`, folded by
  `product-architecture`. Whether QC-28's *verified by* or its § 10 row should name the negative
  control beside the scan, now that a green scan is shown able to turn red, is the fold's call.
- **Answer:** <the owner fills this in>

**How it closes.** `product-architecture` folds it on its next run like any other item here.
