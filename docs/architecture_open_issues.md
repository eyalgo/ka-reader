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

### 3.1 §§ 8 and 9 count the gate at 27 steps and the harness at eleven suites; at `ka-reader@8235240` the gate has 29 steps, twelve suites, and `gitleaks git` is one of its steps

- **Raised by:** PM — 2026-10-23
- **Which record:** `nfdr.md` § 8, the paragraph **Until the card runs the script**
  (`docs/nfdr.md:L1644-L1660`, its gate count and locators), and § 9, the bullet **The harness's own
  suites** (`:L2021` onward, its suite enumeration and locators)
- **Tracked by:** `ka-reader · nemawashi · 2026-10-03_no-secret-reaches-the-repository`
- **What it blocks:** nothing is blocked; both passages are pinned to a commit and true of it, and by
  § 9's own wording a step added to the gate is a re-measurement of those sentences.
- **Where it shows:** § 8 says the script is version 1.1.0 with 27 steps at `ka-reader@389adad`
  (`:L1650-L1653`); § 9 says "Eleven suites are in the tree" and lists them with their `gate.sh`
  lines at `ka-reader@8b93322`. At `ka-reader@8235240`, `checks/gate.sh` is version 1.2.0 (`:L2`,
  "the scan of the whole history for a secret, and its suite, join the list (NFDR QC-28)") and
  `grep -c '^run_step' checks/gate.sh` prints 30 — 29 steps and the `run_step()` definition. The two
  new steps are *Secret scan suite* (`:L48`, `checks/tests/test_secret_scan.sh`) and *Secret scan*
  (`:L58`, `checks/secret-scan.sh gitleaks git`), both before *Build the workspace* (`:L59`), so the
  gate locators both passages cite below `:L47` have moved. `git ls-tree --name-only 8235240
  checks/tests/` lists twelve suites, the eleven § 9 names and `test_secret_scan.sh`, which pairs with
  the new script `checks/secret-scan.sh`. The scan step is QC-28's tree half realized at the gate:
  it runs gitleaks 8.30.1, fetched and checked against a pinned SHA-256 on every run (the comment at
  `checks/gate.sh:L49-L57`). It passes `--exit-code 2` to the tool (`checks/secret-scan.sh:L195`),
  so a finding and a tool error exit differently, where QC-28's tail states the vendor default
  (`docs/nfdr.md:L1078`, "exit 1 on a leak or an error"). The whole gate exited 0 in the macOS
  guest at `ka-reader@38158f4`, the scan printing `commits scanned: 1279`, and
  `git diff --stat 38158f4 8235240` prints nothing. The workflow's checkout gained `fetch-depth: 0`
  (`.github/workflows/ci.yml:L22-L23`).
- **If a document has to be written:** none — sentences of `nfdr.md`, folded by
  `product-architecture`. Whether QC-28's *verified by* or § 10's row should now name the gate step,
  and whether the exit-code note belongs in QC-28's tail, is the fold's call.
- **Answer:** <the owner fills this in>

**How it closes.** `product-architecture` folds it on its next run like any other item here.
