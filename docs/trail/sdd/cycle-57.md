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

### 5.1 § 3's `read-only-harness` row counts fourteen suites and a 32-step gate at 1.5.0; at `ka-reader@3431b7d` there are fifteen and 33, and the new suite holds the *Strings check* step
- **Raised by:** PM — 2026-10-28
- **Seat:** cto
- **Tracked by:** `ka-reader · nemawashi · 2026-10-03_no-internal-text-reaches-a-surface`
- **What it blocks:** nothing. The row is pinned to `ka-reader@f25fdbb` and is true of that tree. It says
  itself that a file landing in `checks/` after that commit "is a re-measurement of this cell and not a
  contradiction of it, and it owes this row an item" (`docs/SDD.md:L373`). This is that item.
- **Where it shows:** § 3, the `read-only-harness` row (`docs/SDD.md:L373`). It reads `gate.sh` at version
  1.5.0 with 32 steps and fourteen suites. At `ka-reader@3431b7d`, `checks/gate.sh` is version 1.6.0
  (`:L2`; 1.5.0 now at `:L3`), `grep -c '^run_step' checks/gate.sh` prints 34 (33 steps and the
  `run_step()` definition at `:L33`), and `ls checks/tests/*.sh | wc -l` prints 15. The new suite is
  `checks/tests/test_strings_step.sh` (version 1.0.0, executable), run by the gate's *Strings check step
  suite* step, `run_step 'Strings check step suite' 'checks/tests/test_strings_step.sh'` (`:L113`),
  directly after *Strings check suite* (`:L112`). It pairs with no script: it reads `checks/gate.sh` and,
  on copies of it, fails when the *Strings check* line (`:L111`) is deleted, naming the step, or moved
  after *Strings check suite*, naming the order. It runs on any host: no network, no git, never runs the
  gate. `git diff --name-only 4e50fd1 3431b7d` lists `checks/gate.sh` and the new suite alone;
  `checks/strings.sh` and `checks/tests/test_strings.sh` are byte-identical. Measured in a disposable
  clone at `ka-reader@3431b7d` on the host: the suite printed `27 of 27 passed`; with the line deleted
  it exited 1 naming the missing *Strings check* step; with it moved after its suite it exited 1 naming
  the order.
- **If a document has to be written:** none. The fold would re-measure the cell at a named commit:
  version 1.6.0, 33 steps, fifteen suites with the new one named and unpaired, every `gate.sh` locator
  through *Strings check suite* one higher and every one after it two higher, and keep the `f25fdbb` reading as a dated note.
- **Answer:** Confirm the re-measurement at `ka-reader@3431b7de250ddf37b8381bdf18d57f4db3a8d038`: `checks/gate.sh` is version 1.6.0, with 33 step calls and fifteen top-level suites (`checks/gate.sh:L2`, `:L51-L131`; the inventory commands and outputs are in the report). Name `checks/tests/test_strings_step.sh` as the third suite paired with no check script of its own, run by *Strings check step suite* immediately after *Strings check suite* (`:L112-L113`). Describe its text check precisely: exactly one full *Strings check* command line, before the first *Strings check suite* line; its controls delete or move that line in disposable copies, and it never executes the gate (`checks/tests/test_strings_step.sh:L7-L20`, `:L112-L158`, `:L240-L293`, at the same commit). Keep thirteen scripts, thirteen fixture folders, the six-line fixture ignore file and the 41-line workflow; the only files changed from `f25fdbb` under `checks/` and `.github/` are the gate and the new suite. Refresh the row's gate locators by content: old lines 2–111 move one line, old line 112 onward two lines. Also refresh § 4 C-I3's dispatcher to `checks/gate.sh:L33-L40` and its build/view references to `:L73` and `:L89`, preserving the former readings as dated evidence. Retain the `f25fdbb` inventory as a dated note. This is a source-backed inventory refresh, not a claim that the full gate passed; this run executed no product check. The NFDR's matching change is already carried by `docs/architecture_open_issues.md` § 3.1 and remains that document's decision. Reasoning and verification: `docs/trail/sdd/self_answer-68.md`.

**How it closes.** `product-sdd` folds it on its next run like every other item in this file, and
the trail copy and the delete-when-empty behaviour are unchanged.
