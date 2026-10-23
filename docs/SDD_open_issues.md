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

### 5.1 § 3's `read-only-harness` row counts twelve suites and 29 gate steps, and says one step fetches; at `ka-reader@1b32500` there are thirteen suites and 30 steps, and two steps fetch
- **Raised by:** PM — 2026-10-23
- **Seat:** cto
- **Tracked by:** `ka-reader · nemawashi · 2026-10-03_no-secret-reaches-the-repository`
- **What it blocks:** nothing. The row is pinned to `ka-reader@8235240` and is true of that tree; by
  its own rule a file landing in `checks/` after that commit is a re-measurement the row is owed, not
  a contradiction.
- **Where it shows:** § 3, the `read-only-harness` row (`docs/SDD.md:L370`), calls `gate.sh` "the
  one ordered list of the gate's 29 steps" at version 1.2.0 (`checks/gate.sh:L47-L113` at the pin),
  counts twelve suites, and says the *Secret scan* step "reaches the network on every run … and no
  other step fetches" except the sanitizer step's first run. At `ka-reader@1b32500`:
  `git diff --name-status 8235240 1b32500 -- checks` lists `A checks/tests/test_secret_scan_planted.sh`
  and `M checks/gate.sh`, and nothing else under `checks/`. `checks/gate.sh` is at version 1.3.0
  (`:L2`) and `grep -c '^run_step' checks/gate.sh` prints 31 — 30 steps and the `run_step()`
  definition. The new step is *Planted secret suite* (`:L67`), directly after *Build the workspace*
  (`:L60`), with its ordering comment at `:L61-L66`; *Secret scan suite* is now at `:L49` and
  *Secret scan* at `:L59`, so every gate locator the row pins has moved. The new suite is a negative
  control for `secret-scan.sh`: it runs the real script twice over a disposable repository it builds,
  clean and then with one commit holding a secret-shaped string built at run time, and passes only
  when the clean run exits 0 and the planted run exits non-zero with a finding at the planted commit.
  It pairs with no new script, so the script count does not grow, and it adds no fixture folder. Each
  of its two runs fetches gitleaks 8.30.1's archive and checks the pinned SHA-256, so the row's
  sentence that no step but *Secret scan* fetches on every run no longer holds. Measured in a
  disposable clone at `ka-reader@1b32500` on the host: the suite exited 0, `19 of 19 passed`, and
  `checks/secret-scan.sh gitleaks git` printed `ok` with `commits scanned: 1291`.
- **If a document has to be written:** none. The fold would add a dated reading of the 30-step gate
  and thirteen suites at a named commit, with its locators re-pinned and the new suite named, and
  keep the `8235240` reading as a dated note.
- **Answer:** <the owner fills this in>

**How it closes.** `product-sdd` folds it on its next run like every other item in this file, and
the trail copy and the delete-when-empty behaviour are unchanged.
