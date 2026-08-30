# PRD open issues — Nozoki 覗き

> Companion to `PRD.md`. **Answer inline** — fill each **Answer** /
> **Confirm-or-override** slot — **commit this file**, then re-run `product-prd`. It folds
> your answers into the PRD and drops the resolved items. When nothing is left unresolved,
> `product-prd` clears this file: no file = the PRD is done.
>
> **This cycle was opened by the owner, not by the CPO.** The PRD settled with no companion;
> the single entry below is a decision already made, not a question.
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

None — the one item this cycle is an owner decision already made.

## 2. Choices to confirm — the CPO drafted a best-effort answer; confirm or override

### 2.1 `## UX Notes` is written for the reader who designs the whole experience from it

- **Drafted into the PRD:** `## UX Notes` (`docs/PRD.md:129-142`) is seven bullets — the editor
  panel as the dominant surface with text-first navigation, dark and light themes, instantly
  usable without instruction, the view following the tree with no refresh control, one
  empty-state prompt, v1 as mouse-driven with keyboard navigation out of scope, and English as
  the UI language. Each is a true property of the product; together they read as asides
  appended after the features rather than the product's experience stated whole.
- **Rationale:** the section was authored for readers who design nothing from it. It now has a
  reader who does — one who works from this section and reads the PRD cold.
- **Confirm or override:** **Override — re-author `## UX Notes` for that reader.**
  - Its current bullets are **not settled for this cycle**; principle 7's protection is lifted
    on this section by this answer.
  - The standard: someone who has read only this PRD should be able to design the product's
    whole experience from `## UX Notes` — what it feels like to use, the states it puts a
    person in and how they move between them, and what must be effortless — without needing a
    decision back from the CPO.
  - **What the section should contain is yours to determine from that standard.** The current
    bullets are neither floor nor ceiling: keep what still holds, and what a design reader
    would need and cannot find is what is missing.
  - The two existing boundaries hold: no visual design, and no mechanism.
  - Anything the standard demands that the PRD has no basis to settle is an **open issue** next
    round, not a guess.

## 3. Directives — an external action the owner confirms as a gate

None this cycle.
