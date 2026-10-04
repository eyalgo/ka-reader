# DESIGN open issues — Nozoki

> Companion to `DESIGN.md`. The CDO authored the design language non-interactively; this file
> holds the calls it made and wants your sign-off on — each with the reason behind it, and what
> moves underneath it if you override — plus the few things it genuinely could not settle, and,
> when a design run has produced output for this product, the pointer to it.
> **Answer inline** — fill each **Answer** / **Confirm-or-override** slot — **commit this file**, then
> re-run `product-design`. It folds your answers into `DESIGN.md` and drops the resolved
> items. When nothing is left open, `product-design` **deletes this file**: no file = the
> design language is done.
>
> **Commit before re-running.** The run that finishes a round removes this file, and git
> refuses to remove a file with uncommitted edits in it — so an uncommitted answer stops
> that run before it can commit anything, and the round's work is left on the floor.
>
> Your answers are never thrown away. Each time the CDO folds them in, it first copies this
> file whole to `docs/trail/design/` — so what you decided, and why, stays readable and citable
> for good.
>
> **§ 3 is not the CDO asking.** The design language is read by everything built after it, and a
> seat downstream can find a rule missing that the authoring run had no occasion to write. That item
> lands in § 3 and is folded by the same run.

> **No `product-design` run wrote this file.** The PM opened it on 2026-10-04 from the design
> language's own companion template. The tooltip on a status letter is now drawn in the tree and the
> Git view, and `DESIGN.md` § Components "The tooltip" places it only where there is room below and to
> the left of the letter. The document is Settled, and with no companion on disk a `product-design`
> re-run reads it as done and has nothing to act on. Its one item is in § 3.

---

## 1. Open issues

None.

## 2. Choices to confirm

None.

## 3. Raised from downstream — an item from a seat that did not write the design language

### 3.1 Where the tooltip goes when there is no room below the letter, or to its left
- **Raised by:** PM — 2026-10-04
- **Tracked by:** `nozoki · nemawashi · 2026-10-02_git-says-what-changed`
- **What it blocks:** a drawn answer for two edges the tooltip now meets. Until the language rules on
  them, the shell keeps the one placement § Components states, and the tooltip is cut by its host.
- **Where it shows:** `docs/DESIGN.md:L646-L650` puts the tooltip "below" the letter, "its right edge
  on the letter's right edge so it never runs past the sidebar", "one line, never wrapped", and says
  nothing else about where it goes. The shell places it exactly so, with no other case
  (`nozoki-mac/Sources/Surfaces/LetterTooltip.swift:L195-L196`), inside the surface that draws the
  letter. Two edges follow. **Bottom:** a letter on the last visible row of the tree or the Git view
  has no room below it inside that surface, so the tooltip is cut by the surface's bottom edge.
  **Left:** a name wider than the room left of the letter carries the tooltip past the surface's left
  edge, so the start of the line is not drawn; it was measured while the tooltip was built — a
  110-point tooltip on a letter at x 52 hung off its host's left edge. The second edge also decides
  which half of the line survives a cut. `docs/CONTENT.md:L493-L496` says clipping a name costs little
  and clipping a sentence costs its point, but it rules for a status message only, and the tooltip's
  word is the half that carries its one job. The likely fold: a sentence in § Components "The tooltip"
  for each edge — where it goes instead, or what is cut and what is kept.
- **If a document has to be written:** none. A sentence in `DESIGN.md`, written by `product-design`.
- **Answer:** <the owner fills this in>

**How it closes.** `product-design` folds it on its next run like any other item here.
