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

> **This companion was opened by a `companion-self-answer` run, not by a `product-design` run.**
> `docs/DESIGN.md` is Settled and had no companion, which is the done signal and was correct. It is
> opened because a run answering `docs/UXD_open_issues.md` measured one defect across every document
> in `docs/` and this document carries **30** of it — and with no companion on disk a `product-design`
> re-run reads the document as done and has nothing to act on. **One item, and it is a pointer
> repair**: nothing this document says is in question. The full measurement is
> `docs/trail/uxd/self_answer-1.md`.

---

## 2. Choices to confirm

### 2.1 Every trail pointer in this document is dead — the folders moved and the citations did not

- **Raised by:** the `companion-self-answer` run named above — not this document's own seat, and no
  item asked for it.
- **What this document says:** **30** citations of the form `docs/<x>_trail/…` (`docs/design_trail/`, `docs/prd_trail/`, `docs/uxd_trail/`).
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
- **Confirm or override:** confirm — the rule as drafted, `docs/<x>_trail/` → `docs/trail/<x>/`,
  applied to all 30, and the measurement holds for this document: 30 citations with the `docs/`
  prefix and 30 without it, so there is no bare-form citation the pattern misses (the PRD's case,
  `docs/trail/prd/self_answer-1.md` § 2.1), and 0 pinned to a commit, so nothing is excluded. All
  seven distinct targets exist at the new path and all seventeen cited sections carry the heading
  this document attributes to them, checked one by one on 2026-09-01. The six `docs/uxd_trail/`
  citations are to the re-authored UXD's trail, not the one removed at `ka-reader@9017ae2`: this
  document's v1 was authored 2026-08-26 off UXD v2 (`ka-reader@e1e54f6`), and the sections it cites
  (cycle-1 § 2.5 and § 2.6; cycle-2 § 1.1, cited with `ka-reader@f4bc928`) exist only in the
  re-authored files — so the hazard the SRS run found on its own `uxd_trail` lines
  (`docs/trail/srs/self_answer-1.md` § 2.2) does not arise here and none of the six is repaired by
  hand. The reason to record on the version line is `ka-reader@1e8bf3d`. Reasoning:
  `docs/trail/design/self_answer-1.md` § 2.1.
