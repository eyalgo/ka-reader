# CONTENT open issues — Nozoki

> Companion to `CONTENT.md`. The Content Editor authored the verbal language non-interactively;
> this file holds the calls it made and wants your sign-off on — each with the reason behind it,
> and what moves underneath it if you override — plus the few things it genuinely could not
> settle.
> **Answer inline** — fill each **Answer** / **Confirm-or-override** slot — **commit this file**,
> then re-run `product-content`. It folds your answers into `CONTENT.md` and drops the resolved
> items. When nothing is left open, `product-content` **deletes this file**: no file = the verbal
> language is done.
>
> **Commit before re-running.** The run that finishes a round removes this file, and git refuses
> to remove a file with uncommitted edits in it — so an uncommitted answer stops that run before
> it can commit anything, and the round's work is left on the floor.
>
> Your answers are never thrown away. Each time the Content Editor folds them in, it first copies
> this file whole to `docs/trail/content/` — so what you decided, and why, stays readable and
> citable for good.
>
> **§ 3 comes from outside this run.** The verbal language is read by everyone who writes a string,
> and a seat downstream can find a pattern it has no rule for. It is recorded there, answered here,
> and folded by the same run.

> **No `product-content` run opened this companion. The PM opened it on 2026-09-25.**
> `CONTENT.md` is Settled at v6, and it had no companion on disk, so a `product-content` re-run would
> read it as done and find nothing to act on. The companion holds one item, § 3.1. It comes from
> reading the shell on `main` at `nozoki@46bb275`, which draws four sentences on a link's tree row
> that `CONTENT.md` does not hold.

---

## 1. Open issues

None.

## 2. Choices to confirm

None.

## 3. Raised from downstream — an item from a seat that did not write the verbal language

### 3.1 A tree row for a link that cannot be followed has no sentence in the verbal language
- **Raised by:** PM — 2026-09-25
- **Tracked by:** `nozoki · nemawashi · 2026-09-15_open-a-folder`
- **What it blocks:** the wording standard behind four sentences the product already ships. The tree
  marks a link that cannot be followed with what the product observed (`docs/fdr.md` R-33, R-34,
  R-152). Four conditions reach a row, and `CONTENT.md` § Message patterns, Partial
  (`docs/CONTENT.md:L304-L315`) has one example on a tree row, *"Nozoki can't read this folder."*,
  and none for a link. The shell therefore draws four sentences no rule stands behind, from
  `nozoki-mac/Sources/Surfaces/ConditionSentences.swift:L18-L25`. Its own doc comment calls them
  provisional (`:L4-L5`):
  - the link leads outside the folder — *"This link leads outside this folder, and Nozoki reads
    nothing outside it."*;
  - the link loops back on itself — *"This link loops back on itself, so Nozoki can't read it."*;
  - the link's target does not exist — *"This link leads to something that isn't there."*;
  - the link runs through more links than the product follows — *"This link leads through too many
    other links, so Nozoki can't read it."*
- **Where it shows:** UX-S2, the file tree's one-entry error state (`docs/CONTENT.md:L421`, "Marked
  on the row; the rest of the tree stands"). The four follow the Partial formula, the contraction
  rule and the banned list as far as a reader can check. The outside sentence echoes the document's
  own *"Nozoki fetches nothing from outside this folder."* (`:L310`). Whether these are the
  product's words is the verbal language's call, and it has not made it.
- **If a document has to be written:** none. `CONTENT.md` § Message patterns, Partial takes the
  sentences, or others in their place, as examples. `product-content` is the tool.
- **Answer:** <the owner fills this in>

**How it closes.** `product-content` folds it on its next run exactly as it folds §§ 1–2.
