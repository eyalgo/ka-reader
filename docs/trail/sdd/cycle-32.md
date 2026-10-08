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
> companion template. `DESIGN.md` gives the Git view's selected file row the selection fill and the
> bar, the shell draws the bar alone, and § 6 S-4's command half names a selection fill on that row
> that no slice builds. The SDD is Settled, and with no companion on disk a `product-sdd` re-run reads
> it as done and has nothing to act on. Its one item is in § 5.

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

### 5.1 No slice delivers the selection fill on the Git view's selected file row, and S-4's case names one
- **Raised by:** PM — 2026-10-04
- **Seat:** cto
- **Tracked by:** `ka-reader · nemawashi · 2026-10-02_git-says-what-changed`
- **What it blocks:** a seed for the Git view's selection fill. Seeds are cut from slices, and no
  slice's *Delivers* or *Reached when* builds it, so nothing on any route draws it. It also leaves one
  of `see-git-status`'s six hover cases naming a drawing the shell does not have.
- **Where it shows:** `docs/DESIGN.md:L612-L618` makes `{components.tree-row}` "every list row in
  the product", the Git view's changed and staged files among them, and "The selected row is
  `{components.tree-row-selected}` with the left bar"; `:L624-L625` keeps "`{colors.selection}` and
  its bar under the pointer". The Git view draws its selected row with the bar alone: its selection
  sets `drawsBar` on one row and nothing else (`ka-reader-mac/Sources/Surfaces/GitView.swift:L190-L194`),
  and `grep -rn isSelected ka-reader-mac/Sources` finds no Git-view row marked selected. `docs/SDD.md`
  § 6 S-4 *Reached when*, command half, holds a case that "the selected row under the pointer keeps
  its selection fill and its bar" (`:L1844-L1845`), and RN-96 places no selection fill in any slice
  (`:L6120-L6199`). The tree's selected row carries both (S-1, `:L1578`), so the gap is the Git view's
  alone. The likely fold: the Git view's selection fill placed in the *Delivers* and *Reached when* of
  the slice that owns the Git view's file row, or S-4's case read as the bar kept and no hover fill,
  with the fill left to a later slice that names it.
- **If a document has to be written:** none. A change in `SDD.md` § 6, written by `product-sdd`.
- **Answer:** The Git view's selection fill goes into `see-git-status` (S-4), in *Reached when* and
  *Rests on* alone. This is the first of the two folds the item offers, without its *Delivers*
  half. Decided in the CTO's seat by an unattended `companion-self-answer` run.
  **Observable half (the CDO's clause, settled by `docs/DESIGN.md`).** One sentence is added after
  "They click a changed file's row: the file opens in the panel to read": the row they clicked is
  drawn as `docs/DESIGN.md` § *Components*, "Rows", draws the selected row, with the selection fill
  and the left bar, and the bar is the cue that survives without colour (`docs/UXD.md` UX-A2). The
  sentence cites the section and states no value, the way S-1 cites § *Layout*.
  **Command half.** The case "the selected row under the pointer keeps its selection fill and its
  bar" stands as written. One case is added before it: after a click on a file row, with the
  pointer over no row, the clicked row shows the selection fill and the bar, and no other row
  shows either.
  **Rests on.** The `surfaces` parenthesis gains the Git view's selected row's fill.
  **What does not move.** *Delivers* keeps its words: the fill shows which row is open and adds
  nothing a developer can do, the reason RN-96 gave for the hover fill. No slice is added: § 5
  step 4 says "§ 6 holds no slice whose decision is a surface's drawing" (`docs/SDD.md:L1329`).
  § 10 gains no entry: the bar can be met as written. S-1 keeps its words.
  **Why not the second fold.** Reading S-4's case as "the bar kept and no hover fill" makes this
  document say less than `docs/DESIGN.md`, which is Settled and gives every list row, "the Git
  view's changed and staged files" among them, `{components.tree-row-selected}` "with the left
  bar" when selected (`:L613-L619` at `ka-reader@6cf1014`). It also leaves the fill to a later slice
  whose only decision is a drawing, which step 4 excludes.
  **What the fold states as a known limit.** On this bar `see-git-status` is not reached on `main`
  at `ka-reader@6cf1014`: the Git view's selection sets the bar and nothing else
  (`ka-reader-mac/Sources/Surfaces/GitView.swift:L190-L194`), and the shell's test for the existing
  case holds the row's image unchanged under the pointer, which passes with the bar alone
  (`ka-reader-mac/Tests/SurfacesTests/GitViewHoverTests.swift:L178-L194`). What that means for work
  in flight is the PM's.
  **Named and not covered.** Four cases, none decided here. (1) Whether a Git-view row is drawn
  selected when its file was opened from the tree: the shell clears the Git view's selection on a
  tree selection (`ka-reader-mac/Sources/Surfaces/WorkbenchView.swift:L161-L165`), and
  `docs/DESIGN.md` does not say. (2) Which row is drawn selected when one file has a row in both
  lists; the answer's "the clicked row" is the reading the shell already draws. (3) What the
  selected row's fill does in a window that is not the key window, which `docs/DESIGN.md` RN-40
  names as not covered. (4) What a refresh does to a selected row that leaves or moves in the
  list, which is `follow-the-folder`'s and is bound by § 4 C-E2. Cases (1) to (3) are the CDO's,
  in `docs/DESIGN.md`.
  **One correction to this item's own text, reported and not edited.** `docs/DESIGN.md` moved to
  v18 at `ka-reader@6cf1014` after the item was written: the lines it cites as `:L612-L618` are now
  `:L613-L619`, and `:L624-L625` are now `:L634-L635`. The quoted words stand.
  Reasoning: `docs/trail/sdd/self_answer-44.md` § 5.1.

**How it closes.** `product-sdd` folds it on its next run like every other item in this file, and
the trail copy and the delete-when-empty behaviour are unchanged.
