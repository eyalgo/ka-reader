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

> **No `product-sdd` run wrote this file.** The PM opened it on 2026-10-28, from a `shukuba-refine`
> review, to carry item 5.1 below: the SDD is Settled with no companion beside it, so without this
> file its own producing skill would find nothing to act on.

---

## 1. Open issues — questions with no answer yet

## 2. Choices to confirm — a best-effort answer was drafted; confirm or override

## 3. Cut calls to confirm — where the slicing could reasonably have gone another way

## 4. Disagreements — two seats hold different positions and neither yields

## 5. Raised from downstream — an item from a seat that did not write the SDD

### 5.1 § 3's `read-only-harness` row counts twelve scripts, thirteen suites and a 30-step gate; at `ka-reader@cd65c02` there are thirteen scripts, fourteen suites and 31 steps
- **Raised by:** PM — 2026-10-28
- **Seat:** cto
- **Tracked by:** `ka-reader · nemawashi · 2026-10-03_no-internal-text-reaches-a-surface`
- **What it blocks:** nothing. The row is pinned to `ka-reader@1b32500` and is true of that tree; by
  its own rule "a file landing in `checks/` after that commit is a re-measurement of this cell and
  not a contradiction of it, and it owes this row an item" (`docs/SDD.md:L371`).
- **Where it shows:** § 3, the `read-only-harness` row (`docs/SDD.md:L371`), calls `gate.sh` "the one
  ordered list of the gate's 30 steps" at version 1.3.0 (`checks/gate.sh:L48-L121` at the pin), counts
  "twelve scripts — eleven checks with a `test_<name>.sh` each, and `gate.sh`" and "thirteen suites",
  and names no `strings.sh`. At `ka-reader@cd65c02`: `git diff --name-status 1b32500 cd65c02 -- checks`
  lists `M checks/gate.sh`, `A checks/strings.sh` and `A checks/tests/test_strings.sh`, and nothing
  else. `checks/strings.sh` is a new check: a lint over the string literals of the `.swift` files under
  `ka-reader-mac/Sources/Surfaces/` for the terms in the *Never* column of `docs/CONTENT.md`
  § Terminology's banned table, read from that file at run time, non-zero with a `QC-53` line per file
  and term on a hit. `checks/tests/test_strings.sh` is its suite. `ls checks/*.sh | wc -l` prints 13
  and `ls checks/tests/*.sh | wc -l` prints 14. `checks/gate.sh` is version 1.4.0 (`:L2`) and
  `grep -c '^run_step' checks/gate.sh` prints 32 — 31 steps, `:L49-L123`, and the `run_step()`
  definition at `:L31`. The new step is *Strings check suite* (`:L105`), directly after *No-network
  suite* (`:L104`); no step runs `checks/strings.sh` itself (`grep -c "checks/strings.sh'"
  checks/gate.sh` prints 0). The new files add no fixture folder and reach no network. Measured in a
  disposable clone at `ka-reader@cd65c02` on the host: `checks/strings.sh` exited 0 with `Swift files
  read: 30; banned terms read: 49`, and the suite exited 0, `50 of 50 passed`.
- **If a document has to be written:** none. The fold would add a dated reading of thirteen scripts,
  fourteen suites and the 31-step gate at a named commit, with the gate locators re-pinned and the new
  script and suite named, and keep the `1b32500` reading as a dated note.
- **Answer:** <the owner fills this in>

**How it closes.** `product-sdd` folds it on its next run like every other item in this file, and
the trail copy and the delete-when-empty behaviour are unchanged.
