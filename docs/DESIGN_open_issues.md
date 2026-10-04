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
> language's own companion template. The shell now draws the Git view's selected file row with
> `{colors.selection}` and the bar, and draws the hover fill only in the key window. Three cases of
> those drawings are named the CDO's — two by `docs/SDD.md` RN-97 (`:L6293-L6301`), one by this
> document's RN-40 (`:L1706-L1708`) — and no sentence of `DESIGN.md` rules on them, while the shell
> already draws an answer to each. The document is Settled, and with no companion on disk a
> `product-design` re-run reads it as done and has nothing to act on. Its three items are in § 3.

---

## 1. Open issues

None.

## 2. Choices to confirm

None.

## 3. Raised from downstream — an item from a seat that did not write the design language

### 3.1 What the selected row's `{colors.selection}` and bar do in a window that is not the key window
- **Raised by:** PM — 2026-10-04
- **Tracked by:** `nozoki · nemawashi · 2026-10-02_git-says-what-changed`
- **What it blocks:** the CDO's ruling on a drawing the shell already makes. Nothing is cut by it;
  if the language rules that the selection dims, the Git view's selected row changes and the tree's
  is checked against the same sentence.
- **Where it shows:** § Components "Rows" makes the hover fill key-window only and says the rule
  "changes nothing for the selected row" (`docs/DESIGN.md:L635-L640`), and RN-40 records "what the
  selected row's own fill and bar do in a window that is not the key window" as named and not
  covered, with no item raising it (`:L1706-L1708`). `docs/SDD.md` RN-97 names the same case the
  CDO's, case (c) (`:L6298-L6301`). The shell draws the Git view's selected row the same whether or
  not the window is key: its selected drawing reads no key status
  (`nozoki-mac/Sources/Surfaces/BarRowView.swift:L59-L66`). The tree's selected row is the table's
  own selection (`:L3-L6`), whose look in a window that is not key is the platform's. Three readings
  were seen: the fill and the bar are drawn the same in either window; the fill dims and the bar
  stays, as a macOS selection does in an inactive window; or each surface follows what its platform
  control does by default, which would let the tree and the Git view differ. The likely fold: one
  sentence in § Components "Rows" beside the key-window rule.
- **If a document has to be written:** none. A sentence in `DESIGN.md`, written by `product-design`.
- **Answer:** <the owner fills this in>

### 3.2 Whether a Git-view file row is drawn selected when its file was opened from the tree
- **Raised by:** PM — 2026-10-04
- **Tracked by:** `nozoki · nemawashi · 2026-10-02_git-says-what-changed`
- **What it blocks:** the CDO's ruling on a drawing the shell already makes. Nothing is cut by it;
  if the language rules that the Git row follows the open file, the Git view gains a selected row it
  does not draw today.
- **Where it shows:** § Components "Rows" draws the selected row as
  `{components.tree-row-selected}` with the left bar (`docs/DESIGN.md:L618-L619`) and does not say which Git-view row is selected when the open file
  was chosen in the tree. `docs/SDD.md` RN-97 names it the CDO's, case (a) (`:L6293-L6297`). The shell
  clears the Git view's selection whenever the tree selects a file, so a file opened from the tree
  has no selected row in the Git view even where that file is listed there
  (`nozoki-mac/Sources/Surfaces/WorkbenchView.swift:L160-L165`). Two readings were seen: the Git
  view's selected row is only the one the reader clicked there, which is what the shell draws; or the
  row of the open file is drawn selected in whichever view lists it. The likely fold: one clause in
  § Components "Rows".
- **If a document has to be written:** none. A clause in `DESIGN.md`, written by `product-design`.
- **Answer:** <the owner fills this in>

### 3.3 What the status letter's tooltip sits over on the selected row, which never takes the hover fill
- **Raised by:** PM — 2026-10-04
- **Tracked by:** `nozoki · nemawashi · 2026-10-02_git-says-what-changed`
- **What it blocks:** a sentence of the language that reads false on one row. Nothing is cut by it.
- **Where it shows:** § Components "The tooltip" says it "stacks with the row's hover fill … the row
  shows `{colors.hover}` and the tooltip sits over it", and that it "is never shown without its row's
  fill" (`docs/DESIGN.md:L681-L684`). § Components "Rows" says "selection outranks hover"
  (`:L634-L635`), so the selected row never shows `{colors.hover}`. The shell follows both: the
  selected row shows no hover fill (`nozoki-mac/Sources/Surfaces/BarRowView.swift:L59`), and a rest on
  its status letter raises the tooltip, because the tooltip reads no selection
  (`grep -n -i select nozoki-mac/Sources/Surfaces/LetterTooltip.swift` prints nothing). So on the
  selected row the tooltip sits over `{colors.selection}`, which the sentence does not name. Two
  readings were seen: "its row's fill" means whichever fill the row shows, hover or selection, which
  is what the shell draws; or the selected row raises no tooltip. The likely fold: the tooltip's
  sentence names the selection fill beside the hover fill.
- **If a document has to be written:** none. A clause in `DESIGN.md`, written by `product-design`.
- **Answer:** <the owner fills this in>

**How it closes.** `product-design` folds it on its next run like any other item here.
