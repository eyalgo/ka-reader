# CONTENT open issues — KA-Reader

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
> reading the shell on `main` at `ka-reader@46bb275`, which draws four sentences on a link's tree row
> that `CONTENT.md` does not hold.

---

## 1. Open issues

None.

## 2. Choices to confirm

None.

## 3. Raised from downstream — an item from a seat that did not write the verbal language

### 3.1 A tree row for a link that cannot be followed has no sentence in the verbal language
- **Raised by:** PM — 2026-09-25
- **Tracked by:** `ka-reader · nemawashi · 2026-09-15_open-a-folder`
- **What it blocks:** the wording standard behind four sentences the product already ships. The tree
  marks a link that cannot be followed with what the product observed (`docs/fdr.md` R-33, R-34,
  R-152). Four conditions reach a row, and `CONTENT.md` § Message patterns, Partial
  (`docs/CONTENT.md:L304-L315`) has one example on a tree row, *"KA-Reader can't read this folder."*,
  and none for a link. The shell therefore draws four sentences no rule stands behind, from
  `ka-reader-mac/Sources/Surfaces/ConditionSentences.swift:L18-L25`. Its own doc comment calls them
  provisional (`:L4-L5`):
  - the link leads outside the folder — *"This link leads outside this folder, and KA-Reader reads
    nothing outside it."*;
  - the link loops back on itself — *"This link loops back on itself, so KA-Reader can't read it."*;
  - the link's target does not exist — *"This link leads to something that isn't there."*;
  - the link runs through more links than the product follows — *"This link leads through too many
    other links, so KA-Reader can't read it."*
- **Where it shows:** UX-S2, the file tree's one-entry error state (`docs/CONTENT.md:L421`, "Marked
  on the row; the rest of the tree stands"). The four follow the Partial formula, the contraction
  rule and the banned list as far as a reader can check. The outside sentence echoes the document's
  own *"KA-Reader fetches nothing from outside this folder."* (`:L310`). Whether these are the
  product's words is the verbal language's call, and it has not made it.
- **If a document has to be written:** none. `CONTENT.md` § Message patterns, Partial takes the
  sentences, or others in their place, as examples. `product-content` is the tool.
- **Answer:** The verbal language takes all four cases: two sentences as the shell has them, and two
  replaced. § Message patterns, Partial gains them as tree-row examples beside *"KA-Reader can't read
  this folder."*:
  - outside — *"This link leads outside the folder you opened, so KA-Reader doesn't read it."*
    (**replaced**). On a tree row, *this folder* already means the row's own folder in the sibling
    example, so the shell's sentence says two things with one phrase. Its *"KA-Reader reads nothing
    outside it"* also claims more than is true, because KA-Reader reads its own remembered state from
    outside the folder (`docs/UXD.md` UX-I9). That is the shape RN-16 corrected;
  - loops — *"This link loops back on itself, so KA-Reader can't read it."* (**as the shell has it**);
  - missing target — *"This link leads to something that isn't there."* (**as the shell has it**);
  - too many links — *"This link leads through more links than KA-Reader follows."* (**replaced**).
    *Too many* describes the reader's own links as failing the tool, which is the *Strict* row of
    § Voice. The replacement puts the limit on KA-Reader, and it states no number, because no document
    fixes the bound: it is a constant in `crates/ka-reader-core/src/fs_reader.rs:L56`, and § Grammar
    allows only numbers counted from the folder.

  None of the four names a next step. The rest of the tree is the way on, and it is already on screen
  (`docs/SDD.md` § 4 C-E4). Two consequences go with the fold:
  - § Terminology gains **link**, for a symbolic link in the folder. *Symlink* is rejected as an
    abbreviation the product never expands. *Alias* is rejected because on macOS it names Finder's
    own, different thing.
  - § Accessibility of text's reading bar has to admit *link*, which none of its three sources holds.
    `README.md` does not use the word. The Partial example already there, with *image*, *loaded* and
    *fetches*, also falls outside the bar as written. So the fold adds a fourth source, *a word
    § Terminology fixes*, and checks the Partial examples against it.

  § Traceability's UX-S2 one-entry row names the link cases. Reasoning:
  `docs/trail/content/self_answer-3.md`.

**How it closes.** `product-content` folds it on its next run exactly as it folds §§ 1–2.
