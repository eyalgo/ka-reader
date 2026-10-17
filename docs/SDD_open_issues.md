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

> **No `product-sdd` run wrote this file.** The PM opened it on 2026-10-17, from a `shukuba-refine`
> review on the seed `ka-reader · nemawashi · 2026-10-16_every-ci-rule-is-held-at-the-change`,
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

### 5.1 The `read-only-harness` row does not name `checks/gate.sh`, and it puts each script and suite on a workflow step of its own
- **Raised by:** PM — 2026-10-17
- **Seat:** cto
- **Tracked by:** `ka-reader · nemawashi · 2026-10-16_every-ci-rule-is-held-at-the-change`
- **What it blocks:** nothing. The row's own rule says a file that lands in `checks/` after its pin
  (`ka-reader@13e8d42`) owes it an item.
- **Where it shows:** § 3, the `read-only-harness` row (`docs/SDD.md:L366`).
  `git diff --name-status 13e8d42 8b93322 -- checks` lists one new file, `checks/gate.sh`, and one changed
  file, `checks/tests/test_vm_refusal.sh`. The new file is the one ordered list of every rule the workflow
  held, each step fatal. The suite now checks the gate's list, not the workflow's shape. The row calls
  `launch.sh` and `own-state-step.sh` "the whole `run`" of their own workflow steps, and calls each of the
  eleven suites "the whole `run` of its own CI step". At `8b93322` the workflow's one rule step runs
  `checks/gate.sh` (`.github/workflows/ci.yml:L26`), and each of those is a step of the gate.
- **If a document has to be written:** none. The fold would re-measure the cell at a named commit. It would
  add `gate.sh`, say the workflow calls the gate, and keep the `13e8d42` inventory as history. The eleven
  suites, the sourced helper and the thirteen fixture folders do not change.
- **Answer:** <the owner fills this in>

**How it closes.** `product-sdd` folds it on its next run like every other item in this file, and
the trail copy and the delete-when-empty behaviour are unchanged.
