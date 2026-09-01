# CONTENT open issues — Nozoki 覗き

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

> **One item was answered and folded; one is carried over unanswered.** The trail-pointer repair
> that opened this companion is confirmed and landed at `docs/CONTENT.md` v5, and the answered item
> is retired whole to `docs/trail/content/cycle-4.md` § 2.1. The item below is the same one that
> file records as **§ 2.2** — renumbered here because it is now the only item, and named by both
> numbers so the trail citation stays followable.

---

## 1. Open issues — questions with no answer yet

None this round.

## 2. Choices to confirm — the Content Editor drafted a best-effort answer; confirm or override

### 2.1 RN-24 cites a file outside this repository, which RN-15 rules this document never does

> **Raised by a `companion-self-answer` run, not by a `product-content` run**, and no item asked
> for it — it was found by reading the document whole while answering the pointer repair. The slot
> below is left unanswered on purpose: the reasoning is that run's, the decision is yours, because
> the second option moves a rule rather than a note. Its report is
> `docs/trail/content/self_answer-1.md`. Re-verified on disk 2026-09-01 by the run that folded
> cycle 4: `system/projects/nozoki/agari.md` is still absent from this repository, and it is still
> the only pointer in `docs/CONTENT.md` to a file outside it.

- **What this document says:** RN-15 rules that this document "quotes and cites only files a reader
  who has cloned this repository can open", and that "a pointer a reader cannot follow is worse
  than no pointer". RN-24 then cites `system/projects/nozoki/agari.md` for the wording of the
  product's defining read-only promise.
- **What is true:** that file is not in this repository. It lives in the kensaiapp-opensource
  instance repo — verified 2026-09-01, absent from `nozoki` and present at
  `kensaiapp-opensource/system/projects/nozoki/agari.md`. It is the only pointer to a file outside
  this repository anywhere in the document, so this is the one place the rule is broken, not a
  pattern.
- **Why it is worth the round:** the citation authorizes the wording of the promise the whole
  product rests on, and the reader who cannot open it is exactly the reader RN-15 was written for —
  a stranger who cloned the public repository and has nobody to ask.
- **Drafted:** apply RN-15 as it stands — state the Agari's ground in Nozoki's own words inside
  RN-24 and drop the pointer, which is what RN-15 already prescribes for a limit inherited from the
  publishing organisation. The alternative is to narrow RN-15 to admit a named instance-repo
  citation; that moves a rule rather than a note, which is why this is asked rather than done.
- **What moves if you override:** nothing else in the document. RN-24's own argument for the
  widened read-only wording, and the wording itself in § Terminology *Standing sentences*, stand
  either way — this decides only whether the note points at the Agari or restates its ground. Take
  the alternative and RN-15 changes, which reaches every citation in the document rather than this
  one.
- **Confirm or override:** <"confirm", or "override: <what to do instead>">
