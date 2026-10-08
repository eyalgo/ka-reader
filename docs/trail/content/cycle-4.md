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

> **This companion was opened by a `companion-self-answer` run, not by a `product-content` run.**
> `docs/CONTENT.md` is Settled and had no companion, which is the done signal and was correct. It is
> opened because a run answering `docs/UXD_open_issues.md` measured one defect across every document
> in `docs/` and this document carries **12** of it — and with no companion on disk a `product-content`
> re-run reads the document as done and has nothing to act on. **One item, and it is a pointer
> repair**: nothing this document says is in question. The full measurement is
> `docs/trail/uxd/self_answer-1.md`.

---

## 2. Choices to confirm

### 2.1 Every trail pointer in this document is dead — the folders moved and the citations did not

- **Raised by:** the `companion-self-answer` run named above — not this document's own seat, and no
  item asked for it.
- **What this document says:** **12** citations of the form `docs/<x>_trail/…` (`docs/content_trail/`, `docs/prd_trail/`).
- **What is true:** none of those folders exists. The retired cycles live at `docs/trail/<x>/`, moved
  by `ka-reader@1e8bf3d` ("the six answer-trails move under `docs/trail/`"), which did not update the
  documents citing them. Every one is a pointer a cold reader follows and finds nothing, and these are
  mostly **authorization** pointers — the owner answer a Review Note rests on cannot be opened to
  check it.
- **Drafted:** each `docs/<x>_trail/` becomes `docs/trail/<x>/`. Nothing the document says changes;
  only where it points. A pointer repair, not a revision — so this round need not reopen anything else.
- **One exception, and it is not hypothetical.** A citation pinned to a commit — the form
  `ka-reader@<sha>:docs/<x>_trail/…` — must be left exactly as it is: it resolves at a commit where that
  path did exist (verified — `git show 1d5c553:docs/uxd_trail/cycle-1.md` returns the file), so
  rewriting it breaks a citation that currently works. This document carries **0** of those;
  `docs/UXD.md` carries 4. A sweep that does not exclude the pinned form is wrong.
- **Scale, so this is not read as a local slip:** **235** dead pointers across six documents — PRD 2,
  SRS 80, SDD 40, UXD 71, DESIGN 30, CONTENT 12; 231 of them unpinned. The cheapest repair is plainly
  one mechanical sweep across all six rather than six document cycles, and which way it is done is the
  owner's call. This item exists so the defect is not invisible if no cycle is ever spent on it.
- **Confirm or override:** confirm — the repair stands exactly as drafted, and this document is the
  clean case the other five were not. Verified on disk 2026-09-01: **12** pointers, and the bare form
  that ambushed the PRD is absent here — `grep -o 'docs/[a-z]*_trail/'` and `grep -o '[a-z]*_trail/'`
  both return 12 — so the rule as written reaches every one. **0** are commit-pinned, so the exception
  this item names is inert and nothing has to be excluded, unlike `docs/UXD.md` where four pinned
  citations would have been broken by the same literal sweep. All four cited files exist at their new
  location, and so does every one of the nine `§` sections they point into, so this is a full repair
  and not a path fix landing on a missing anchor.
  Two additions, neither changing what to do. **The ground is stronger than the item states:** RN-15
  of this document rules that it "quotes and cites only files a reader who has cloned this repository
  can open", so these twelve are not merely broken links — they are this document breaking its own
  stated rule. **And the item's scale paragraph is stale:** its 235-across-six was already 295 (the
  PRD carried 62, not 2 — `docs/trail/prd/self_answer-1.md`), and four of the six are now repaired —
  PRD v12 (`2d8c99d`), SRS v9 (`82c199a`), UXD v7 (`05eac42`), DESIGN v6 (`c4f3c60`). Only this
  document and `docs/SDD.md` still carry the defect, so the "one sweep or six cycles" choice the item
  left open is closed by events: a sweep would now save nothing that is not already open. Reasoning in
  `docs/trail/content/self_answer-1.md`.

### 2.2 RN-24 cites a file outside this repository, which RN-15 rules this document never does

> **Raised by a `companion-self-answer` run, not by a `product-content` run**, and no item asked for
> it — it was found by reading the document whole while answering § 2.1. The slot below is left
> unanswered on purpose: the reasoning is that run's, the decision is this round's.

- **What this document says:** RN-15 rules that this document "quotes and cites only files a reader
  who has cloned this repository can open", and that "a pointer a reader cannot follow is worse than
  no pointer". RN-24 then cites `system/projects/ka-reader/agari.md` for the wording of the product's
  defining read-only promise.
- **What is true:** that file is not in this repository. It lives in the kensaiapp-opensource
  instance repo — verified 2026-09-01, absent from `ka-reader` and present at
  `kensaiapp-opensource/system/projects/ka-reader/agari.md`. It is the only `system/` pointer in the
  document, so this is the one place the rule is broken, not a pattern.
- **Why it is worth the round:** the citation authorizes the wording of the promise the whole product
  rests on, and the reader who cannot open it is exactly the reader RN-15 was written for — a
  stranger who cloned the public repository and has nobody to ask. The round is already open for
  § 2.1, so this costs no cycle of its own.
- **Drafted:** apply RN-15 as it stands — state the Agari's ground in KA-Reader's own words inside RN-24
  and drop the pointer, which is what RN-15 already prescribes for a limit inherited from the
  publishing organisation. The alternative is to narrow RN-15 to admit a named instance-repo
  citation; that moves a rule rather than a note, which is why this is asked rather than done.
- **Confirm or override:** <"confirm", or "override: <what to do instead>">
