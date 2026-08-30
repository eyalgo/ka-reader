# PRD open issues — Nozoki 覗き

> Companion to `PRD.md`. The CPO authored the PRD non-interactively; this file holds
> what it could not settle from the inputs. **Answer inline** — fill each **Answer** /
> **Confirm-or-override** slot — **commit this file**, then re-run `product-prd`. It folds
> your answers into the PRD and drops the resolved items. When nothing is left unresolved,
> `product-prd` clears this file: no file = the PRD is done.
>
> Your answers are never thrown away. Each time the CPO folds them in, it first copies
> this file whole to `docs/prd_trail/` — so what you decided, and why, stays readable
> and citable for good.

> **This companion was opened by the owner, not by a CPO run.** The PRD reached Settled at v6
> on 2026-08-01 with no companion beside it. It is reopened to hand in one instruction — already
> answered below, so the next `product-prd` run is a fold rather than a fresh round. Anything the
> fold cannot settle goes back into a rewritten companion as usual.

---

## 1. Open issues — product-defining questions with no answer yet

None — the one item this companion carries is a decided instruction, in §2.

## 2. Choices to confirm — the CPO drafted a best-effort answer; confirm or override

### 2.1 Whether this PRD is re-authored against the machinery as it stands today

- **Drafted into the PRD:** nothing. `PRD.md` is v6, Settled, written 2026-08-01 against the
  carriers as they were that day.
- **Rationale:** the PRD's two carriers have moved since, in one commit. `bcd6ba70` (2026-08-12,
  *"the PRD carries a blurb, and it is not a gate"*) added a `## Blurb` section to
  `<CORE>/templates/product-templates/prd_template.md` (1.8.0 → 1.9.0) ahead of `## Purpose`, and
  `## The blurb` to `<CORE>/prompts/cpo_create_prd.md` (2.4.0 → 2.5.0), which names the CPO as its
  author and Purpose + Problem Statement as what it derives from. That is the whole of the carrier
  drift: `SKILL.md` is byte-identical across it, the diagnostic stays at ten questions, and the
  principle count stays at twelve. `PRD.md` on disk has no `## Blurb`.
- **Confirm or override:** **OVERRIDE — make this run a re-authoring pass over the whole PRD,
  against the template and prompt as they stand today.** Owner's instruction, 2026-08-25.
  - *The product does not change here.* No intent, scope, user, metric or exclusion is reopened by
    this item. Every value the owner has already confirmed in `docs/prd_trail/` stays authorized
    and stays as written; principle 7 governs, and this instruction is not the fresh authorization
    it asks for.
  - *What the pass produces.* The `## Blurb` the current template carries, written per the prompt's
    `## The blurb` — a distillation of `## Purpose` and `## Problem Statement`, saying nothing
    those two do not. Note that the blurb is explicitly **not a gate**: its absence was never an
    open issue, so nothing about the PRD's earlier Settled state was wrong.
  - *And a read of the whole document against the current bar.* Walk `PRD.md` under the prompt's
    twelve principles and the template's section shape as they read today, not as they read on
    2026-08-01. `## Gates & External Dependencies` is optional by the template's own note — its
    absence is correct where there are no gates, and it is not to be invented.
  - *Surface, never silently edit.* Where the current bar would not settle something the way the
    PRD on disk settles it, that is a **choice to confirm in the rewritten companion**, with what
    the PRD says now and what the bar would say instead. A wording repair that changes no product
    fact is yours to make; anything that moves a product fact is the owner's.
  - *The version line.* Bump `Version:` on any run that changes the PRD's content, per the skill's
    Step 2, and say in the line what moved.

## 3. Directives — an external action the owner confirms as a gate

None.
