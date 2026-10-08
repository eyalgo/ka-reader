# CONTENT open issues — KA-Reader

> Companion to `CONTENT.md`. The Content Manager authored the verbal language non-interactively;
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
> Your answers are never thrown away. Each time the Content Manager folds them in, it first copies
> this file whole to `docs/trail/content/` — so what you decided, and why, stays readable and
> citable for good.
>
> **§ 3 comes from outside this run.** The verbal language is read by everyone who writes a string,
> and a seat downstream can find a pattern it has no rule for. It is recorded there, answered here,
> and folded by the same run.

> **No `product-content` run wrote this file.** The PM opened it on 2026-10-04 from the verbal
> language's own companion template. The product now ships six tooltip strings that join a name from
> the folder to a word KA-Reader writes, and `CONTENT.md` rules on neither the joining mark nor the type
> the name takes there. The document is Settled, and with no companion on disk a `product-content`
> re-run reads it as done and has nothing to act on. Its two items are in § 3.

---

## 1. Open issues

None.

## 2. Choices to confirm

None.

## 3. Raised from downstream — an item from a seat that did not write the verbal language

### 3.1 No rule for the mark that joins a name to a word in a label that is not a sentence
- **Raised by:** PM — 2026-10-04
- **Tracked by:** `ka-reader · nemawashi · 2026-10-02_git-says-what-changed`
- **What it blocks:** a standard for the six tooltip strings and for any later label that joins a name
  to a word. They ship meanwhile with a space, U+2014, a space.
- **Where it shows:** `ka-reader-mac/Sources/Surfaces/GitSentences.swift:L114-L119` (`"\(name) \u{2014}
  modified"` and its five siblings). `docs/CONTENT.md:L423-L433` fixes the two words and their order,
  and § Grammar and mechanics (`:L113-L127`) covers full stops, the ellipsis, `!` and `?`, and quotation
  marks, but says nothing of a dash or of joining. The mark was chosen because it is the one joining
  mark a shipped string already uses (`docs/CONTENT.md:L287-L288`); a verb was ruled out because
  *conflict* is a noun and the other five are participles. The likely fold: a line in § Grammar and
  mechanics that confirms the mark or names another.
- **If a document has to be written:** none. A line in `CONTENT.md`, written by `product-content`.
- **Answer:** Join them with a space, U+2014 and a space: the name first, the letter's word last, as
  the six strings already ship (`ka-reader-mac/Sources/Surfaces/GitSentences.swift:L114-L119`). The fold
  is one line in § Grammar and mechanics: where a label puts a name taken from the folder before a
  word KA-Reader writes, the name is the row's own text, unchanged, then a space, U+2014 and a space,
  then the word, and the label carries no full stop (a label carries none, `docs/CONTENT.md:L113-L115`).
  This is the one dash KA-Reader's own writing already uses (`ka-reader-mac/Sources/Surfaces/ConditionSentences.swift:L23`,
  `docs/CONTENT.md:L287-L288`). A hyphen and an en dash are ruled out because names in this repository
  already carry hyphens (`ka-reader-mac`, `self_answer-8.md`), so either would not read as a join; a
  colon, because a path followed by a colon reads as tool output; a bare space and parentheses,
  because neither separates a name from a word at a glance; a verb, for the reason the item gives
  (*conflict* is a noun, the other five are participles). The word is always last, so a name that
  itself holds a spaced U+2014 still reads right. Stated for this shape only: a label that puts the
  word first, carries two words or adds a count has no occurrence, and waits until it occurs.
  `docs/DESIGN.md:L661` already says the joining mark is drawn whole and names none, so it takes no
  change. Reasoning: `docs/trail/content/self_answer-9.md` § 3.1.

### 3.2 Whether "a name from the folder is set in the path type" reaches into the tooltip
- **Raised by:** PM — 2026-10-04
- **Tracked by:** `ka-reader · nemawashi · 2026-10-02_git-says-what-changed`
- **What it blocks:** a settled reading of two documents that seem to say different things about the
  same name.
- **Where it shows:** `docs/CONTENT.md:L126-L127` says a name taken from the folder "is set in the path
  type rather than quoted". `docs/DESIGN.md:L648-L649` sets the whole tooltip in `{typography.ui}`. The
  tooltip's first half is such a name, and the shell draws the whole line in one UI font
  (`ka-reader-mac/Sources/Surfaces/LetterTooltip.swift:L48`, `:L64`). Either the rule stops short of the
  tooltip, or the tooltip's name owes the path type. The type itself stays the design language's; what
  the verbal standard owes is whether its rule reaches here. The likely fold: one clause on the rule's
  reach, and a `DESIGN.md` item only if the answer is that it does.
- **If a document has to be written:** none. A clause in `CONTENT.md`, written by `product-content`.
- **Answer:** No. The rule does not reach the tooltip, and the clause is narrowed so that this document
  names no type for a name. The fold replaces "is set in the path type rather than quoted
  (`docs/DESIGN.md` § Typography, `{typography.path}`)" in § Grammar and mechanics with: a name taken
  from the folder is never put in quotation marks, and the type it is drawn in is `docs/DESIGN.md`'s
  (§ Typography). The clause stated a type for names on surfaces where the design language draws
  another: the tooltip is `{typography.ui}` whole (`docs/DESIGN.md:L649`), tree rows, Git rows and
  status messages are `{typography.ui}` (`:L461-L462`, `:L760`), and `{typography.path}` is the path
  line, a link's destination, commit identifiers and branch chips (`:L468-L470`). The shell draws
  the tooltip in one font (`ka-reader-mac/Sources/Surfaces/LetterTooltip.swift:L48`, `:L64`). So no
  `DESIGN.md` item is raised: the tooltip is already as the design language draws it. Decided with
  § 3.1: the name and the mark are one line in one type, and the name is never quoted. Reasoning:
  `docs/trail/content/self_answer-9.md` § 3.2.

**How it closes.** `product-content` folds it on its next run exactly as it folds §§ 1–2.
