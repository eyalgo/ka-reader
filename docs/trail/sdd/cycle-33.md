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

> **No `product-sdd` run wrote this file.** The PM opened it on 2026-10-04 from the SDD's own
> companion template. The shell now draws the clickable row's hover fill and the status letter's
> tooltip from whether the window is the key window as well as from the pointer, and § 3's `surfaces`
> row names the pointer as the only first-hand observation they are drawn from. The SDD is Settled,
> and with no companion on disk a `product-sdd` re-run reads it as done and has nothing to act on.
> Its one item is in § 5.

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

### 5.1 § 3 `surfaces` does not name the window's key status, which the hover fill and the tooltip are now drawn from
- **Raised by:** PM — 2026-10-04
- **Seat:** cto
- **Tracked by:** `ka-reader · nemawashi · 2026-10-02_git-says-what-changed`
- **What it blocks:** nothing is cut by it. A part's sentence reads incomplete against the shell, and
  a later change that reads § 3 to place a second first-hand observation finds only the pointer
  named.
- **Where it shows:** the `surfaces` row, in the sentence beginning "Read with the exception, and not
  a second one", says "what the pointer is over is the shell's own observation of the pointer", and
  that "the clickable row's hover fill and the status letter's tooltip are drawn from it"
  (`docs/SDD.md:L343`). Its *Owns* cell names no observation of the window's key status. `docs/DESIGN.md`
  § Components "Rows" and "The tooltip" now draw both only while the window is the key window (RN-40,
  `docs/DESIGN.md:L635-L640`, `:L681-L685`), and the shell observes that first-hand: a key-window
  source in `surfaces` (`ka-reader-mac/Sources/Surfaces/KeyWindowSource.swift:L7`, its live value from
  `:L50`) gates both the fill (`RowHover.swift`) and the tooltip (`LetterTooltip.swift`). It is not a
  state of the folder, is not held across a redraw, and raises no intent across SM-8 — the same bounds
  the sentence states for the pointer. The likely fold: the window's key status named beside the
  pointer in that sentence as the shell's second first-hand observation, under the same bounds, so the
  exception above it stays the only one.
- **If a document has to be written:** none. A change in `SDD.md` § 3, written by `product-sdd`.
- **Answer:** Take the fold the item names, with three additions. Decided in the CTO's seat by an
  unattended run.
  **The fold.** In § 3's `surfaces` row, the clause "Read with the exception, and not a second one"
  names the window's key status beside the pointer. Whether the window is the key window is the
  shell's own observation of the window and is no state of the folder. The clickable row's hover
  fill and the status letter's tooltip are drawn from the pointer and from it together
  (`docs/DESIGN.md` § *Components*, "Rows" and "The tooltip"). The same bounds hold it. It is asked
  each time the row or letter under the pointer is resolved and at the two moments the window stops
  being and becomes the key window, and it is held across no redraw. It raises no intent across
  SM-8. It says nothing about the folder. A surface that is in no window reads as not key and draws
  neither. The observation stays inside `surfaces` and crosses no seam, so SM-8 does not move and
  the exception above the clause stays the only one. The clause does not call it a "second
  first-hand observation": the row already calls the pending gap "the one thing the shell observes
  first-hand", and RN-96 reads that sentence as one about state.
  **Addition one.** § 6 S-1 *Reached when*, command half, repeats the § 3 clause as its "second
  reading clause" (`docs/SDD.md:L1569-L1571`). It gains the key status in the same words and still
  adds no test for itself.
  **Addition two.** The hover sentences in S-1's and S-4's observable halves
  (`docs/SDD.md:L1547-L1550`, `:L1794-L1797`) and the hover cases in their command halves
  (`:L1577-L1581`, `:L1845-L1853`) say a row shows the fill while the pointer is over it, with no
  condition. Each is stated for a window that is the key window. The observable sentences are the
  CDO's clauses and `docs/DESIGN.md:L640-L645` and `:L690-L700` settle them, so no call is left for
  that seat.
  **Addition three.** Each of the two command halves gains three cases the shell's suites already
  hold at `ka-reader@6f92b29`: when the window stops being the key window the fill leaves under a
  still pointer; while it is not key, no row shows the fill, whatever the pointer does and whatever
  rows move under it; when it becomes key again the fill is on the row under the pointer as the
  rows stand then. S-4 gains one more: a raised tooltip leaves when the window stops being key and
  returns only after a fresh rest.
  **What does not move.** No *Delivers*, no seam, no part's *Must not own*, no § 10 entry. The
  commit row and the menu item take nothing: neither is built, and the item cites no site for
  either.
  **One correction to the item's text.** Its `docs/DESIGN.md` line numbers were written before that
  document moved to v19. "Rows" states the rule at `:L640-L645`, and "The tooltip" at `:L690-L700`.
  Reasoning, the failure paths walked, and what this run did not read:
  `docs/trail/sdd/self_answer-45.md`.

**How it closes.** `product-sdd` folds it on its next run like every other item in this file, and
the trail copy and the delete-when-empty behaviour are unchanged.
