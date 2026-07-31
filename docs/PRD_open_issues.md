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
> this file whole to `docs/prd_trail/` — so what you decided, and why, stays readable
> and citable for good.

---

## 1. Open issues — product-defining questions with no answer yet

None this cycle — the one unsettled call carries a defensible lean, so it is listed under §2
as a choice to confirm.

## 2. Choices to confirm — the CPO drafted a best-effort answer; confirm or override

### 2.1 v1's accessibility posture beyond the mouse-driven line
- **Drafted into the PRD:** in `## UX Notes` ("The bounds v1 draws"): beyond the
  no-keyboard-navigation line, v1 makes no assistive-technology promise — its accessibility
  surface is what the product already carries (two themes, text-first navigation), kept small
  with the rest of the surface.
- **Rationale:** your re-authoring standard is that the design reader should not need a
  decision back from the CPO — and the design station authors an accessibility bar, while the
  PRD's only accessibility statement was the keyboard line. The lean rests on the PRD's own
  basis: the precedent of the keyboard cut (an accessibility dimension deliberately cut from
  v1 without promise — and held outside the product's terminus by the Agari,
  `agari_trail/cycle-1.md`), and the small-surface sustainability strategy in Assumptions.
  The counter-lean is real, which is why this is yours: the no-learning-curve goal claims
  "anyone who can find their way around a repository on GitHub" — read literally, an
  assistive-technology user is inside that audience, and promising them anything in v1
  changes product scope. Scope is the owner's.
- **Confirm or override:** <"confirm", or "override: <what v1 promises instead>">

## 3. Directives — an external action the owner confirms as a gate

None this cycle.
