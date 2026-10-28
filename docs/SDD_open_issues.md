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

### 5.1 § 3's `read-only-harness` row says `strings.sh` is in no step of its own and counts a 31-step gate; at `ka-reader@f25fdbb` the lint is a step and the gate has 32
- **Raised by:** PM — 2026-10-28
- **Seat:** cto
- **Tracked by:** `ka-reader · nemawashi · 2026-10-03_no-internal-text-reaches-a-surface`
- **What it blocks:** nothing. The row is pinned to `ka-reader@cd65c02` and is true of that tree. It also says
  that "a step whose whole command is `checks/strings.sh` is not in the list, and by this row's own rule the
  row records one when it lands", and a file landing in `checks/` "owes this row an item" (`docs/SDD.md:L372`).
- **Where it shows:** § 3, the `read-only-harness` row (`docs/SDD.md:L372`). It calls `gate.sh` version 1.4.0, "the
  one ordered list of the gate's 31 steps" (`checks/gate.sh:L49-L123`; `grep -c '^run_step'` prints 32). It says
  "every check script but one run as steps of the gate, and the one, `strings.sh`, is in no step of its own",
  and "No step runs `checks/strings.sh` itself". At `ka-reader@f25fdbb`, `checks/gate.sh` is version 1.5.0
  (`:L2`; 1.4.0 at `:L3`). `grep -c '^run_step' checks/gate.sh` prints 33: 32 steps, `:L50-L129`, and the
  `run_step()` definition at `:L32`. The new step is *Strings check*, `run_step 'Strings check'
  'checks/strings.sh'` (`:L110`), directly after *No-network suite* (`:L105`) and directly before *Strings
  check suite* (`:L111`), with a four-line comment at `:L106-L109` saying why it comes first.
  `git diff --name-status cd65c02 f25fdbb -- checks` lists `M checks/gate.sh` alone, so the counts of
  scripts and suites are unchanged: `ls checks/*.sh | wc -l` prints 13 and `ls checks/tests/*.sh | wc -l`
  prints 14. Every `gate.sh` locator the row pins moved: by one for the new version line, and by five more
  after `:L105`. Measured in a disposable clone at `ka-reader@f25fdbb` on the host: `checks/strings.sh` exited
  0 (`Swift files read: 30; banned terms read: 49`). With a banned word planted in a string literal, the gate
  from *Strings check* onward exited 1 with `gate.sh: step failed: Strings check`. The whole gate exited 0 in
  the macOS guest at `ka-reader@2ea9323`, whose tree `f25fdbb` carries unchanged.
- **If a document has to be written:** none. The fold would re-measure the cell at a named commit: version
  1.5.0, 32 steps, the moved locators, every check script a step of the gate, and *Strings check* named
  directly before *Strings check suite*. It keeps the `cd65c02` reading as a dated note.
- **Answer:**

**How it closes.** `product-sdd` folds it on its next run like every other item in this file, and
the trail copy and the delete-when-empty behaviour are unchanged.
