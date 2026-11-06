# PRD open issues — KA-Reader

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

> **No `product-prd` run wrote this file.** The owner opened it on 2026-11-06, in an
> interactive session in the CPO's seat, to state the beta's priority and why. The PRD is
> Settled, so without a companion the decision would reach no one.

---

## 1. Open issues — product-defining questions with no answer yet

None.

## 2. Choices to confirm — the CPO drafted a best-effort answer; confirm or override

None.

## 3. Raised from downstream — an item from a seat that did not write this document

### 3.1 The beta release is the highest priority, and why: it is the public evidence of kensaiapp's work
- **Raised by:** Product (owner) — 2026-11-06
- **Which section:** § *Goals* (`PRD.md` lines 88 onward) and § *Assumptions* — **Versioning**
  and **Public identity** (`PRD.md` lines 410–419). PRD v17 says what the beta carries
  (`trail/prd/cycle-15.md` § 3.1) but not how it ranks against the rest of the work, nor why.
- **What moved:** the owner ranks the public beta above every other piece of work on KA-Reader,
  and narrows what precedes it: the beta ships once the tree and the open file follow the disk and
  Markdown reads rendered. Choosing and keeping a theme waits for after the beta, as the Git view's
  live refresh already does (PRD v17).
- **Why:** once the beta is out and can be used, even at a basic level, the owner points to it
  from the public kensaiapp repository. KA-Reader is then the visible, working evidence of what
  kensaiapp builds. That is also why the repository goes public with its real commit history,
  after a privacy check, rather than as a fresh copy: the history is the work being shown.
- **What it reaches downstream:** `SDD.md` § 6–§ 7 (the theme slice's edge before
  `first-public-release`, by its own companion item); the install seed's "start after" line and
  the seed order (the Principal PM's, already directed in its context on 2026-11-06).
- **Answer:** The public beta is KA-Reader's highest priority. It ships once the tree and the open
  file follow the disk and Markdown reads rendered; theme choice and the Git view's live refresh
  come after it, before 1.0.0. The beta's purpose is to be used and to be shown: the owner links
  it from the public kensaiapp repository as the working evidence of kensaiapp's work, so the
  repository goes public with its own commit history, after a privacy check of that history.

**How it closes.** `product-prd` folds it on its next run; the documents downstream follow by
their own companions.
