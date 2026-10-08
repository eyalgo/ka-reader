# DESIGN open issues — KA-Reader

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
- **Tracked by:** `ka-reader · nemawashi · 2026-10-02_git-says-what-changed`
- **What it blocks:** a drawn answer for a moment the shell now reaches. Until the language rules on
  it, what the reader sees is whatever the shell's pointer observation happens to report.
- **Where it shows:** `docs/DESIGN.md:L618-L625` draws the fill "while the pointer is over a row that
  selection or opening acts on", and § Components "The tooltip" stacks the tooltip over it; neither
  says what a fill already shown does when the window stops being the key window and the pointer has
  not moved. The shell draws the fill from a tracking area declared `.activeInKeyWindow`
  (`ka-reader-mac/Sources/Surfaces/RowHover.swift:L29`) and clears it only when the pointer leaves or the
  surface forgets it (`:L53`); no rule for the key-window moment exists in the source. Two readings
  were seen, and each costs something: the fill leaves at that moment, and the tooltip raised over it
  is held to the same rule, or the stacking "It stacks with the row's hover fill" (`:L666-L667`) breaks
  while a tooltip stays; or the fill stays until the pointer next moves, and marks a row in a window
  the reader has left. `docs/SDD.md` RN-96 (`:L6193-L6199`) names the question the CDO's. The likely
  fold: one sentence in § Components "Rows" for that moment, and the same for "The tooltip" where the
  answer moves it.
- **If a document has to be written:** none. A sentence in `DESIGN.md`, written by `product-design`.
- **Answer:** The fill leaves. A row's hover fill is drawn only while the window is the key window:
  when the window stops being the key window, the fill leaves at that moment under a still pointer,
  in place and with no transition, and a status letter's tooltip raised over that row leaves at the
  same moment — so "The tooltip"'s stacking never shows a tooltip without its row's fill. When the
  window becomes the key window again, the fill is drawn on the row under the pointer at that
  moment, read against the rows as they stand then; the tooltip is not restored, and is raised again
  only by a fresh 500ms rest on the letter, counted from that moment. The rule holds for every row
  that takes a hover fill — tree rows, Git-view file rows, commit rows and menu items — and changes
  nothing for the selected row, since selection outranks hover. The fold states it in § Components
  "Rows" and "The tooltip", and in the two other places that state when the fill is drawn: § Colors'
  `{colors.hover}` line and the hover Do. Reasoning: `docs/trail/design/self_answer-10.md` § 3.1.

### 3.2 Whether the row of an entry that cannot be read is a row "that selection or opening acts on"
- **Raised by:** PM — 2026-10-04
- **Tracked by:** `ka-reader · nemawashi · 2026-10-02_git-says-what-changed`
- **What it blocks:** the CDO's confirmation of a call the shell already draws. Nothing is cut by it;
  if the language rules the other way, the fill narrows on those rows.
- **Where it shows:** `docs/DESIGN.md:L618-L623` gives the fill to "a row that selection or opening
  acts on" and withholds it from "a row that nothing acts on", and names neither a file row whose
  file cannot be read nor a folder row whose listing failed. The shell gives both the fill
  (`ka-reader-mac/Tests/SurfacesTests/RootItemsViewHoverTests.swift:L302-L311`,
  `test_hover_unreadable_file_and_folder_rows_take_fill`), reading the language's own test: a click on
  such a file row still raises the file selection, and the reading panel states what was observed; a
  failed folder row is still selected by a click and can be expanded to read again. `docs/SDD.md` RN-96
  (`:L6193-L6199`) names the question the CDO's. The likely fold: one clause in § Components "Rows"
  saying whether those rows take the fill.
- **If a document has to be written:** none. A clause in `DESIGN.md`, written by `product-design`.
- **Answer:** Yes — confirmed as the shell draws it. A file row whose file cannot be read and a
  folder row whose listing failed are rows that selection or opening acts on, and both take the
  fill. Whether a row takes the fill is decided by what a click on it does, never by the state of
  its entry's read: a click on that file row selects it and the reading panel states what was
  observed under the file's path, and a click on that folder row selects it and expanding it reads
  the folder again. The words a failed entry carries beside its name are part of its row and lie
  under the fill; they make the row no status message and no inert row — the status message for an
  unreadable entry that § Components "Status messages" lists is the statement of what was observed,
  not the entry's row. What stays inert is unchanged: the line drawn beneath an expanded folder
  while its read is out or when it holds nothing is a status message, not the folder's row, and
  never takes the fill. The fold is one clause in § Components "Rows", beside its list of clickable
  rows. Reasoning: `docs/trail/design/self_answer-10.md` § 3.2.

**How it closes.** `product-design` folds it on its next run like any other item here.
