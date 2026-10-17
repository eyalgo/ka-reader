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

> **No `product-architecture` run wrote this file.** The PM opened it on 2026-10-17, from a
> `shukuba-refine` review on the seed `ka-reader · nemawashi · 2026-10-16_every-ci-rule-is-held-at-the-change`,
> to carry items 3.1 to 3.3 below. The NFDR is Settled, so without a companion they would reach no one.

---

## 1. Open issues — questions with no answer yet

None.

## 2. Choices to confirm — the Principal Architect drafted a best-effort answer; confirm or override

None.

## 3. Raised from downstream — an item from a seat that did not write these records

### 3.1 QC-25's hosted-log read selects a workflow step that no longer exists
- **Raised by:** PM — 2026-10-17
- **Which record:** `nfdr.md` QC-25, the runner reading (`docs/nfdr.md:L824-L858`), and § 10's QC-25 row
  (`:L2196`): `gh run view <run-id> --repo eyalgo/ka-reader --log | awk -F'\t' '$2 == "Bundle probe suite" &&
  /out-of-grant-read:/'`.
- **Tracked by:** `ka-reader · nemawashi · 2026-10-16_every-ci-rule-is-held-at-the-change`
- **What it blocks:** nothing while Actions is off. On the next hosted run the command prints nothing, and
  QC-25 reads an empty read on a run as a break whether or not the wall held.
- **Where it shows:** at `ka-reader@8b93322` the workflow has one step that runs a rule, `Test gate`, whose
  whole `run:` is `checks/gate.sh` (`.github/workflows/ci.yml:L26`); the bundle probe's suite runs inside it.
  `grep -c 'Bundle probe suite' .github/workflows/ci.yml` → 0. QC-25 itself says a change that renames or
  drops that step changes this command in the same change (`:L857-L858`).
- **If a document has to be written:** none. The fold would select `Test gate` in the recipe and the § 10
  row, keep the one-line reading rule, and leave earlier readings under their old step name.
- **Answer:** <the owner fills this in>

### 3.2 § 8, QC-64 and QC-65 still say `checks/gate.sh` is not in the tree
- **Raised by:** PM — 2026-10-17
- **Which record:** `nfdr.md` § 8, *Until the script lands* (`docs/nfdr.md:L1544-L1551`); QC-64's
  *verified by* tail, "Until `checks/gate.sh` lands, no command holds this entry" (`:L1658-L1659`); QC-65's
  *verified by* tail, "Until `checks/gate.sh` runs the suites that hold those cases" (`:L1706-L1709`); and
  § 9's *Toolchain* passage, "Until the script lands, the card's `swift test` in the guest holds the arm"
  (`:L2116-L2117`).
- **Tracked by:** `ka-reader · nemawashi · 2026-10-16_every-ci-rule-is-held-at-the-change`
- **What it blocks:** nothing. Each sentence's condition is half met. The script is in the tree from
  `ka-reader@8b93322`, mode `100755`, with 26 steps. The card's test command does not run it yet
  (`Test command:` on the project card), so the "no run at the change" half still holds.
- **Where it shows:** the four sentences above. Measured at `8b93322`: `grep -nE '^[[:space:]]+run:'
  .github/workflows/ci.yml` prints the gate line and the `ditto` line only; `for s in checks/tests/*.sh; do
  grep -q "$s" checks/gate.sh || echo "$s"; done` prints nothing. In the macOS guest, `checks/gate.sh` exited 0
  at `726a234`, printing `swift --version` and the SDK version first. A copy with step 13 replaced by `false`
  exited 1 with `gate.sh: step failed: Renderer gate` and ran no later step. That run includes every
  refusal suite QC-65 names.
- **If a document has to be written:** none. The fold would say the script has landed and record its guest
  run as the direct reading. It keeps the gap that the card does not run the script, and keeps QC-64's two
  tree comparisons as review gates.
- **Answer:** <the owner fills this in>

### 3.3 § 9 says each harness suite is its own CI step, and the suites are now steps of `checks/gate.sh`
- **Raised by:** PM — 2026-10-17
- **Which record:** `nfdr.md` § 9, the bullet "The harness's own suites, `checks/tests/`, run as CI steps —
  stated once, here" and its *verified by* (`docs/nfdr.md:L1843-L1938`).
- **Tracked by:** `ka-reader · nemawashi · 2026-10-16_every-ci-rule-is-held-at-the-change`
- **What it blocks:** nothing is blocked. But the bullet's rule, "a script that lands with a suite lands
  the suite's CI step in the same change", now contradicts QC-64's "the workflow holds no rule of its own". Its
  comparison, `grep -q "$s" .github/workflows/ci.yml`, now prints all eleven suites.
- **Where it shows:** at `ka-reader@8b93322` each of the eleven suites is the whole command of one
  `run_step` call in `checks/gate.sh`. The workflow's one rule step runs that script (`ci.yml:L26`). The
  bullet's step locators (`:L40-L41` … `:L101-L102` at `13e8d42`) name lines the workflow no longer has.
- **If a document has to be written:** none. The fold would say a suite joins as a step of `checks/gate.sh`,
  and that the workflow runs it through `Test gate`. It would aim the comparison at the script, as QC-64's
  tail already does, and keep the old locators as history.
- **Answer:** <the owner fills this in>

**How it closes.** `product-architecture` folds it on its next run like any other item here.
