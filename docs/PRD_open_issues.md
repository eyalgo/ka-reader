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
> interactive session in the CPO's seat, after deciding what the first public release carries.
> The PRD is Settled, so without a companion the decision would reach no one.

---

## 1. Open issues — product-defining questions with no answer yet

None.

## 2. Choices to confirm — the CPO drafted a best-effort answer; confirm or override

None.

## 3. Raised from downstream — an item from a seat that did not write this document

### 3.1 The first public release is a beta below 1.0.0, and its Git view does not yet follow the disk
- **Raised by:** Product (owner) — 2026-11-06
- **Which section:** § *Scope (In)* (`PRD.md` line 323: "v1 cuts to browsing, reading, status,
  and live refresh"), § *Assumptions* **Versioning** (`PRD.md` lines 409–414), and the rule
  "the view never lies" (`PRD.md` lines 244–246). The PRD says nothing about when the first
  public release comes. The ordering lives downstream: `SDD.md` § 5 step 1 E-7 (lines 1673–1682)
  places `first-public-release` "after the v1 cut", quoting the owner — "The first public release
  waits for the full v1 cut the PRD names, so the first thing a stranger meets is the product
  `docs/PRD.md` calls v1, not a partial" — and line 2414 repeats it.
- **What moved:** the owner now wants the first public release earlier. It is a **beta**, below
  1.0.0, released once the tree and the open file follow the disk and Markdown reads rendered.
  The Git view's live refresh (the Git panel and the tree's changed markers following the disk)
  comes **after** the beta, on the way to 1.0.0. Diffs, history and folder switching were never
  in it.
- **Why:** the Git view's live refresh is a whole further piece of work, and the beta is useful
  without it: the tree and the open file are live, Markdown renders, and the Git view works as
  read at open. The beta is below 1.0.0, so "anything may change" is already its stated posture.
- **The condition that keeps the rule:** "the view never lies" still binds. In the beta the Git
  view and the changed markers state plainly that they show the Git state read when the folder
  was opened, and the README's known gaps say the same. A Git view that quietly shows the state
  at open as if it were current is not admitted.
- **What it reaches downstream:** `SDD.md` E-7's placement and line 2414's sentence (the CTO's,
  by its own companion); the wording of the Git view's "read at open" statement (`UXD.md`,
  `CONTENT.md`, by their seats); the install seed's order
  (`system/projects/ka-reader/journey/nemawashi/unpicked/2026-10-30_a-stranger-can-install-the-first-release.md`,
  the Principal PM's, already directed in its context on 2026-11-06).
- **Answer:** The first public release is a beta below 1.0.0. It ships once the tree and the open
  file follow the disk and Markdown reads rendered, and it does not wait for the Git view to follow
  the disk. In the beta, the Git view and the changed markers say plainly that they show the state
  read when the folder was opened, and the README's known gaps say so too. The Git view's live
  refresh stays part of what v1 means and lands before 1.0.0. The "full v1 cut before the first
  public release" ruling quoted in `SDD.md` is withdrawn for this beta.

**How it closes.** `product-prd` folds it on its next run; the documents downstream follow by
their own companions.
