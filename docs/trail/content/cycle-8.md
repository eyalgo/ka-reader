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

> **One item is open: § 2.1.** `product-content` folded § 3.1 into `CONTENT.md` v8 on 2026-09-26,
> and the answered file is kept whole at `docs/trail/content/cycle-7.md`. § 2.1 was raised on this
> companion by a `companion-self-answer` run and has not been answered.

---

## 1. Open issues

None.

## 2. Choices to confirm

### 2.1 The reading panel's sentence for a file that is gone says it left the folder, which Nozoki did not observe

> **No `product-content` run wrote this item.** A `companion-self-answer` run raised it on
> 2026-09-26 while answering the former § 3.1 from a whole reading of `CONTENT.md`. What prompted
> it: that answer gives a gone folder *"This folder is no longer there."*, in the phrase every
> upstream document uses, and `CONTENT.md` v8 now carries it (§ Message patterns, *Partial*; RN-34).
> This document's sentence for the same state in the reading panel claims more. The reasoning is in
> `docs/trail/content/self_answer-5.md`.

- **Written into CONTENT.md:** *"This file is no longer in the folder."*, the reading panel's
  sentence for the open file gone from disk. It appears three times: in § Voice's *Urgent* row as
  the example (`docs/CONTENT.md:L65`), in § Message patterns, *Recovered* (`:L380-L381`), and in
  § Traceability's UX-S1 file-gone row (`:L501`). This item proposes *"This file is no longer
  there."* in all three places.
- **Grounds:** Nozoki observes that nothing is at the file's path. It does not observe that the
  file left the folder. When a file is renamed or moved inside the folder, which is what an agent
  working in it does, the file is still in the folder under another name, and the sentence is false
  (§ Voice's first row: *"never states something it has not read"*). The upstream documents word
  this state as *no longer there*: UX-S1 says the panel *"states plainly that it is no longer
  there"* (`docs/UXD.md:L236`), and so do `docs/SDD.md:L1604` and `docs/fdr.md` R-81. No shipped
  string carries the current wording: `grep -rn "no longer in the folder"` over `nozoki-mac/` and
  `crates/` finds nothing, so the change costs no string. With it, the two gone sentences, file and
  folder, share one shape.
- **What moves if you override:** Nothing else. The three places keep the current sentence, and
  the folder sentence in § Message patterns, *Partial* stands on its own grounds either way
  (RN-34).
- **Confirm or override:** confirm — all three places take *"This file is no longer there."*, and
  the grounds gain one: the current sentence's bare *the folder* can be read as the open file's
  own parent folder or as the folder you opened. § Terminology's *folder* row names the opened
  one *the folder you opened*, so the bare phrase is neither. Reasoning:
  `docs/trail/content/self_answer-6.md`.

## 3. Raised from downstream — an item from a seat that did not write the verbal language

None.

**How it closes.** `product-content` folds it on its next run exactly as it folds §§ 1–2.
