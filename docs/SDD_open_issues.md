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


> No producing run wrote this file. The Principal Architect's companion-self-answer run opened it
> on 2026-10-29 while checking `docs/architecture_open_issues.md` § 3.1. The SDD's description of
> the strings-step suite cites helpers where it says it cites the real-gate case and the controls.
> This companion carries the citation correction to the CTO; it changes no test or design decision.

---

## 1. Open issues — questions with no answer yet

## 2. Choices to confirm — a best-effort answer was drafted; confirm or override

### 2.1 Point the strings-step suite's evidence at the cases that actually assert it

- **Raised by:** Principal Architect — 2026-10-29
- **Seat:** cto
- **Proposed correction (not yet drafted into the SDD):** In `SDD.md` § 3's `read-only-harness`
  row, keep the description of `tests/test_strings_step.sh` and correct its evidence locators:
  `gate_verdict` is `checks/tests/test_strings_step.sh:L113-L156`; the independent real-gate
  case is `:L333-L338`; the deletion and move controls are `:L346-L382`. Pin these readings to
  `ka-reader@3431b7de250ddf37b8381bdf18d57f4db3a8d038`, the row's own measurement commit.
- **Rationale:** The row currently points its real-gate claim at `:L240-L247`, which contains
  the deletion helper and the start of the move helper, not the real-gate test. Its control
  reference `:L256-L293` covers the end of the move helper and the edit-effect helpers, not
  the controls' rejection assertions. `git show 3431b7d:checks/tests/test_strings_step.sh`
  places the independent case at lines 333–338 and the asserting controls at 346–382;
  `git diff 3431b7d f5eb32e -- checks/tests/test_strings_step.sh` prints nothing. A reader
  following the existing references cannot inspect the assertions the paragraph attributes
  to them. The behavior described remains supported by those cases.
- **If overridden:** Retain another source locator only if it opens the named assertion at
  the stated commit. No slice, seam, requirement, or test needs to change for this correction.
- **Confirm or override:** <"confirm", or "override: <what to do instead>">

## 3. Cut calls to confirm — where the slicing could reasonably have gone another way

## 4. Disagreements — two seats hold different positions and neither yields

## 5. Raised from downstream — an item from a seat that did not write the SDD
