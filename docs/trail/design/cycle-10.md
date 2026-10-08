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

> **No `product-design` run wrote this file.** The PM opened it on 2026-10-01 from the design
> language's own companion template, while re-reading the route after the code view was built with
> its line-number gutter. `DESIGN.md` is Settled, and with no companion on disk a `product-design`
> re-run reads it as done and has nothing to act on. Its one item is in § 3.

---

## 3. Raised from downstream — an item from a seat that did not write the design language

### 3.1 The code gutter does not say how much space separates its numbers from the code
- **Raised by:** PM — 2026-10-01
- **Tracked by:** `ka-reader · nemawashi · 2026-10-01_a-file-reads-in-the-panel`
- **What it blocks:** nothing is blocked; the code view is built. What is missing is the rule that
  says whether it is built right. As built, the line numbers end exactly where the code begins, with
  no space between them. That may be what the language means, or it may leave the numbers pressed
  against the text. Only the design language can say which.
- **Where it shows:** § Components *Code* gives `{components.code-gutter}` line numbers in
  `{colors.gutter}` "right-aligned in a column `{spacing.xl}` wide plus the digits the file needs"
  (`docs/DESIGN.md:L664-L666`). The `code-gutter` token carries no padding (`docs/DESIGN.md:L218-L221`).
  So the language fixes the column's width but not where inside it the numbers sit beyond
  "right-aligned", and it names no space between the column and the code. The literal reading is
  what the app draws now: each number's right end is the gutter's right edge
  (`ka-reader-mac/Sources/Surfaces/CodeGutterView.swift:L46`, `:L67`, `:L144`), and the code's scroll
  view begins at that same edge (`ka-reader-mac/Sources/Surfaces/CodeView.swift:L88`), so the 24 points
  of `{spacing.xl}` all lie to the numbers' left. Three readings are open: (a) the literal one, as
  drawn, with no space; (b) part of `{spacing.xl}` to the numbers' right, between them and the code,
  with the language saying how much; (c) a gap token of the language's own beside the column.
- **If a document has to be written:** none. § Components *Code* and the `code-gutter` token.
- **Answer:** Choose (b). Keep the gutter column at {spacing.xl} plus the width of the digits the current file needs; reserve {spacing.sm} inside that column at its right edge as right padding for {components.code-gutter}. Right-align each number to the start of that padding, with the code beginning at the column's outer right edge. Thus the separation is {spacing.sm}, included in the existing width rather than added to it. Keep {spacing.lg} before the column and the existing code insets. The padding stays with the fixed gutter, outside horizontally scrolling content, so scrolling cannot erase the separation or draw code over the numbers. Apply the same column padding where the diff contract reuses this gutter column for its sign; this changes no diff content or numbering rule. The spacing is the same in both themes and for plain text, highlighted code and raw Markdown. A change in digit count changes the digit allowance, not the padding; empty content invents no number. Fold the padding reference into the code-gutter token and clarify § Components Code and its shared-column Diff consequence. Reasoning: docs/trail/design/self_answer-6.md.

**How it closes.** `product-design` folds it on its next run like any other item here.
