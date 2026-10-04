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
> language's own companion template. The clickable row's hover fill is now drawn in the tree and the
> Git view, and `docs/SDD.md` RN-96 (`:L6193-L6199`) names two cases of that fill as the CDO's that
> `DESIGN.md` § Components "Rows" does not state. The shell now answers both without the language. The
> document is Settled, and with no companion on disk a `product-design` re-run reads it as done and has
> nothing to act on. Its two items are in § 3.

---

## 1. Open issues

None.

## 2. Choices to confirm

None.

## 3. Raised from downstream — an item from a seat that did not write the design language

### 3.1 What a row's hover fill does when the window stops being the key window under a still pointer
- **Raised by:** PM — 2026-10-04
- **Tracked by:** `nozoki · nemawashi · 2026-10-02_git-says-what-changed`
- **What it blocks:** a drawn answer for a moment the shell now reaches. Until the language rules on
  it, what the reader sees is whatever the shell's pointer observation happens to report.
- **Where it shows:** `docs/DESIGN.md:L618-L625` draws the fill "while the pointer is over a row that
  selection or opening acts on", and § Components "The tooltip" stacks the tooltip over it; neither
  says what a fill already shown does when the window stops being the key window and the pointer has
  not moved. The shell draws the fill from a tracking area declared `.activeInKeyWindow`
  (`nozoki-mac/Sources/Surfaces/RowHover.swift:L29`) and clears it only when the pointer leaves or the
  surface forgets it (`:L53`); no rule for the key-window moment exists in the source. Two readings
  were seen, and each costs something: the fill leaves at that moment, and the tooltip raised over it
  is held to the same rule, or the stacking "It stacks with the row's hover fill" (`:L666-L667`) breaks
  while a tooltip stays; or the fill stays until the pointer next moves, and marks a row in a window
  the reader has left. `docs/SDD.md` RN-96 (`:L6193-L6199`) names the question the CDO's. The likely
  fold: one sentence in § Components "Rows" for that moment, and the same for "The tooltip" where the
  answer moves it.
- **If a document has to be written:** none. A sentence in `DESIGN.md`, written by `product-design`.
- **Answer:** <the owner fills this in>

### 3.2 Whether the row of an entry that cannot be read is a row "that selection or opening acts on"
- **Raised by:** PM — 2026-10-04
- **Tracked by:** `nozoki · nemawashi · 2026-10-02_git-says-what-changed`
- **What it blocks:** the CDO's confirmation of a call the shell already draws. Nothing is cut by it;
  if the language rules the other way, the fill narrows on those rows.
- **Where it shows:** `docs/DESIGN.md:L618-L623` gives the fill to "a row that selection or opening
  acts on" and withholds it from "a row that nothing acts on", and names neither a file row whose
  file cannot be read nor a folder row whose listing failed. The shell gives both the fill
  (`nozoki-mac/Tests/SurfacesTests/RootItemsViewHoverTests.swift:L302-L311`,
  `test_hover_unreadable_file_and_folder_rows_take_fill`), reading the language's own test: a click on
  such a file row still raises the file selection, and the reading panel states what was observed; a
  failed folder row is still selected by a click and can be expanded to read again. `docs/SDD.md` RN-96
  (`:L6193-L6199`) names the question the CDO's. The likely fold: one clause in § Components "Rows"
  saying whether those rows take the fill.
- **If a document has to be written:** none. A clause in `DESIGN.md`, written by `product-design`.
- **Answer:** <the owner fills this in>

**How it closes.** `product-design` folds it on its next run like any other item here.
