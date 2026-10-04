# CONTENT open issues — Nozoki

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
> the folder to a word Nozoki writes, and `CONTENT.md` rules on neither the joining mark nor the type
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
- **Tracked by:** `nozoki · nemawashi · 2026-10-02_git-says-what-changed`
- **What it blocks:** a standard for the six tooltip strings and for any later label that joins a name
  to a word. They ship meanwhile with a space, U+2014, a space.
- **Where it shows:** `nozoki-mac/Sources/Surfaces/GitSentences.swift:L114-L119` (`"\(name) \u{2014}
  modified"` and its five siblings). `docs/CONTENT.md:L423-L433` fixes the two words and their order,
  and § Grammar and mechanics (`:L113-L127`) covers full stops, the ellipsis, `!` and `?`, and quotation
  marks, but says nothing of a dash or of joining. The mark was chosen because it is the one joining
  mark a shipped string already uses (`docs/CONTENT.md:L287-L288`); a verb was ruled out because
  *conflict* is a noun and the other five are participles. The likely fold: a line in § Grammar and
  mechanics that confirms the mark or names another.
- **If a document has to be written:** none. A line in `CONTENT.md`, written by `product-content`.
- **Answer:** <the owner fills this in>

### 3.2 Whether "a name from the folder is set in the path type" reaches into the tooltip
- **Raised by:** PM — 2026-10-04
- **Tracked by:** `nozoki · nemawashi · 2026-10-02_git-says-what-changed`
- **What it blocks:** a settled reading of two documents that seem to say different things about the
  same name.
- **Where it shows:** `docs/CONTENT.md:L126-L127` says a name taken from the folder "is set in the path
  type rather than quoted". `docs/DESIGN.md:L648-L649` sets the whole tooltip in `{typography.ui}`. The
  tooltip's first half is such a name, and the shell draws the whole line in one UI font
  (`nozoki-mac/Sources/Surfaces/LetterTooltip.swift:L48`, `:L64`). Either the rule stops short of the
  tooltip, or the tooltip's name owes the path type. The type itself stays the design language's; what
  the verbal standard owes is whether its rule reaches here. The likely fold: one clause on the rule's
  reach, and a `DESIGN.md` item only if the answer is that it does.
- **If a document has to be written:** none. A clause in `CONTENT.md`, written by `product-content`.
- **Answer:** <the owner fills this in>

**How it closes.** `product-content` folds it on its next run exactly as it folds §§ 1–2.
