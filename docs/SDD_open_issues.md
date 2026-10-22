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
> answers the item — `cto`, `cpo` or `cdo`. An item with no usable value, whether the field is absent,
> empty or still the `<seat>` placeholder, is answered in the seat of the skill that produced this file.
> The field names the *answering* seat. It is not the seat that raised the item (`Raised by:` /
> `Held by:`), and it is not the document an answer belongs to.
>
> **An item in §§ 1–3 names the seat that raised it.** An item the CPO raised is a product call and
> an item the CTO raised is a technical one, and the answer that settles one does not settle the
> other. **§ 4 names two seats and no raiser** — a
> disagreement is not something one seat asked, it is two positions held by different seats, and the
> answer that settles it picks between them.
>
> **§ 5 names a raiser from outside the SDD's lanes entirely.** §§ 1–4 are all the SDD's own three
> lane seats; § 5 is a seat that never held a lane in it, reading it long after it settled and
> finding something only the SDD can fix. Its `Raised by:` therefore takes a wider set than §§ 1–3's,
> which stay fixed to the three lane seats on purpose.

> **No `product-sdd` run wrote this file.** The PM opened it on 2026-10-22, from a `shukuba-refine`
> review on the seed `ka-reader · nemawashi · 2026-10-01_the-bridge-runs-under-the-sanitizer`,
> to carry item 5.1 below. The SDD is Settled, so without a companion it would reach no one.

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

### 5.1 § 3's `read-only-harness` row counts the gate at 26 steps; at `ka-reader@389adad` it has 27
- **Raised by:** PM — 2026-10-22
- **Seat:** cto
- **Tracked by:** `ka-reader · nemawashi · 2026-10-01_the-bridge-runs-under-the-sanitizer`
- **What it blocks:** nothing. The row is pinned to `ka-reader@8b93322` and is true of that tree; by
  its own rule a later change to `checks/` is a re-measurement the row is owed, not a contradiction.
- **Where it shows:** § 3, the `read-only-harness` row (`docs/SDD.md:L368`), calls `gate.sh` "the one
  ordered list of the gate's 26 steps" (`checks/gate.sh:L43-L91` at the pin). At `ka-reader@389adad`
  `grep -c '^run_step' checks/gate.sh` prints 28 — 27 steps and the `run_step()` definition (`:L27`);
  at `8b93322` it prints 27. The added step is *Bridge tests under the address sanitizer*
  (`checks/gate.sh:L57`), between *Test gate* (`:L50`) and *Structure check* (`:L58`), so the row's
  locators below that step are not where the row pins them. No script, suite or fixture was added,
  removed or renamed: `git diff --name-status --diff-filter=ADR 8b93322 389adad -- checks` prints
  nothing, so the eleven scripts, eleven suites and thirteen fixture folders do not move. Other files
  in `checks/` did change in that range (comments re-wrapped at `ae72bdc`), so the row's other
  locators want the same re-read; the step itself is `checks/gate.sh`'s only change since `eb50e87`
  (`git diff --stat eb50e87 389adad -- checks`: `checks/gate.sh`, 8 lines added).
- **If a document has to be written:** none. The fold would add a dated reading of the 27-step gate
  at a named commit, with its locators re-pinned, and keep the `8b93322` inventory as a dated note.
- **Answer:** <the owner fills this in>

**How it closes.** `product-sdd` folds it on its next run like every other item in this file, and
the trail copy and the delete-when-empty behaviour are unchanged.
