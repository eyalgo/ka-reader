# PRD open issues — Nozoki 覗き

> Companion to `PRD.md`. The CPO authored the PRD non-interactively; this file holds
> what it could not settle from the inputs. **Answer inline** — fill each **Answer** /
> **Confirm-or-override** slot — **commit this file**, then re-run `product-prd`. It folds
> your answers into the PRD and drops the resolved items. When nothing is left unresolved,
> `product-prd` clears this file: no file = the PRD is done.
>
> **Commit before re-running.** The run that finishes a round removes this file, and git
> refuses to remove a file with uncommitted edits in it — so an uncommitted answer stops
> that run before it can commit anything, and the round's work is left on the floor.
>
> Your answers are never thrown away. Each time the CPO folds them in, it first copies
> this file whole to `docs/trail/prd/` — so what you decided, and why, stays readable
> and citable for good.

> **This companion was opened by a `companion-self-answer` run, not by a `product-prd` run.**
> `docs/PRD.md` is Settled and had no companion, which is the done signal and was correct. It is
> opened because a run answering `docs/UXD_open_issues.md` measured one defect across every document
> in `docs/` and this document carries **2** of it — and with no companion on disk a `product-prd`
> re-run reads the document as done and has nothing to act on. **One item, and it is a pointer
> repair**: nothing this document says is in question. The full measurement is
> `docs/trail/uxd/self_answer-1.md`.

---

## 2. Choices to confirm

### 2.1 Every trail pointer in this document is dead — the folders moved and the citations did not

- **Raised by:** the `companion-self-answer` run named above — not this document's own seat, and no
  item asked for it.
- **What this document says:** **2** citations of the form `docs/<x>_trail/…` (`docs/prd_trail/`).
- **What is true:** none of those folders exists. The retired cycles live at `docs/trail/<x>/`, moved
  by `nozoki@1e8bf3d` ("the six answer-trails move under `docs/trail/`"), which did not update the
  documents citing them. Every one is a pointer a cold reader follows and finds nothing, and these are
  mostly **authorization** pointers — the owner answer a Review Note rests on cannot be opened to
  check it.
- **Drafted:** each `docs/<x>_trail/` becomes `docs/trail/<x>/`. Nothing the document says changes;
  only where it points. A pointer repair, not a revision — so this round need not reopen anything else.
- **One exception, and it is not hypothetical.** A citation pinned to a commit — the form
  `nozoki@<sha>:docs/<x>_trail/…` — must be left exactly as it is: it resolves at a commit where that
  path did exist (verified — `git show 1d5c553:docs/uxd_trail/cycle-1.md` returns the file), so
  rewriting it breaks a citation that currently works. This document carries **0** of those;
  `docs/UXD.md` carries 4. A sweep that does not exclude the pinned form is wrong.
- **Scale, so this is not read as a local slip:** **235** dead pointers across six documents — PRD 2,
  SRS 80, SDD 40, UXD 71, DESIGN 30, CONTENT 12; 231 of them unpinned. The cheapest repair is plainly
  one mechanical sweep across all six rather than six document cycles, and which way it is done is the
  owner's call. This item exists so the defect is not invisible if no cycle is ever spent on it.
- **Confirm or override:** **confirm — with one addition, and it changes what the repair must
  touch.** The drafted rule stands: each `docs/<x>_trail/` becomes `docs/trail/<x>/`. But this
  document carries **62** dead trail pointers, not 2. The 2 measured are the only ones written with
  a `docs/` prefix (both on the version line, `docs/PRD.md:5`); the other **60** are the bare form
  the PRD cites its trail in throughout — `prd_trail/cycle-N.md` (58) and `srs_trail/cycle-N.md`
  (2) — which resolve relative to `docs/`, where the PRD sits, to the same missing folders. The same
  move applies without the prefix: `prd_trail/` becomes `trail/prd/`, `srs_trail/` becomes
  `trail/srs/`. Every one of the nine distinct files cited exists at its new location (verified
  2026-09-01). Pinned form: **0** in this file, checked on the whole document, so the exception is
  inert here. The undercount is this document's alone — the five siblings' totals equal their
  `docs/`-prefixed counts — so the repo-wide figure is **295**, not 235, and a sweep whose pattern
  requires the `docs/` prefix misses this file almost whole. The fold records the change on the
  version line with its reason, `nozoki@1e8bf3d`. Reasoning: `docs/trail/prd/self_answer-1.md`
  § 2.1.
