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

> **No `product-design` run wrote this file.** The PM opened it on 2026-10-02 from the design
> language's own companion template, after the reading panel's path line was drawn in its tokens.
> `DESIGN.md` is Settled, and with no companion on disk a `product-design` re-run reads it as done
> and has nothing to act on. Its one item is in § 3.

---

## 3. Raised from downstream — an item from a seat that did not write the design language

### 3.1 Where the path line's text stands, vertically, inside its row
- **Raised by:** PM — 2026-10-02
- **Tracked by:** `nozoki · nemawashi · 2026-10-01_a-file-reads-in-the-panel`
- **What it blocks:** nothing is blocked. The path line is built. What is missing is a rule that
  says whether its text is placed right inside its row.
- **Where it shows:** `{components.path-line}` gives the row `height: "{spacing.row}"` (24) and
  `typography: "{typography.path}"` (`docs/DESIGN.md:L207-L212`), and `{typography.path}` is 12px
  mono with `lineHeight: 1.5` (`:L45-L49`), so its 18-point line sits in a 24-point row with 6
  points to place. § Components *The reading panel* says the line is the panel's first row with a
  hairline beneath it (`:L658-L662`) and does not say where in the row the text stands. Three
  readings are open: (a) centred vertically in the row; (b) on a baseline shared with the tree's
  24-point rows (`{components.tree-row}`, `:L161-L166`); (c) top-aligned in the row. As built, the
  text is centred: `pathLine.centerYAnchor.constraint(equalTo: pathRow.centerYAnchor)`
  (`nozoki-mac/Sources/Surfaces/ReadingPanelView.swift:L112`). That placement was landed as a
  placeholder for this document to confirm or replace, not as a design decision. The other
  24-point rows in the language may be read the same way, and the answer may name them too.
- **If a document has to be written:** none. § Components *The reading panel*, or the
  `{components.path-line}` contract.
- **Answer:** <the owner fills this in>

**How it closes.** `product-design` folds it on its next run like any other item here.
