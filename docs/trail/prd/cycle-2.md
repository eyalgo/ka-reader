# PRD open issues — nozoki

> Companion to `PRD.md`. **Answer inline** — fill each **Answer** /
> **Confirm-or-override** slot — **commit this file**, then re-run `product-prd`. It folds
> your answers into the PRD and drops the resolved items. When nothing is left unresolved,
> `product-prd` clears this file: no file = the PRD is done.
>
> **This cycle was opened by the owner, not by the CPO.** The PRD settled at v2 with no
> companion; reading it, the owner is changing two things. Both entries below are therefore
> already decided — "Drafted into the PRD" describes what the settled PRD says today, and
> the override says what to make it say. Nothing here is a question.
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

None — both items this cycle are owner decisions already made.

## 2. Choices to confirm — the CPO drafted a best-effort answer; confirm or override

### 2.1 Nozoki is not defined by reference to VS Code
- **Drafted into the PRD:** VS Code is the PRD's reference point for what Nozoki *is* —
  "a stripped-down, VS Code-like shell" (Purpose), "anyone who has used VS Code needs no
  learning" (Goals), "instantly familiar to anyone who has used VS Code" (UX Notes), "a
  VS Code-like shell is what makes inspection comfortable" (the familiarity thesis,
  Assumptions), and "looking like VS Code invites expecting VS Code" (Risks).
- **Rationale:** it explains the product by pointing at somebody else's product, and it sets
  the usability bar at *having used a particular editor*.
- **Confirm or override:** **Override — remove VS Code as the product's identity, in all five
  places, and reset the bar.** The property underneath is real and states itself without
  borrowing a name: it looks and works like a familiar code editor, and it needs no learning.
  **The bar is not editor experience.** It is this: *anyone who can find their way around a
  repository on GitHub and follow a README should be able to use Nozoki.* That is lower and
  broader than "has used VS Code," and it is the bar to write into the PRD.
  - **Purpose** — drop "VS Code-like": a stripped-down shell for browsing a project's files
    and inspecting its Git status, in which nothing can be changed.
  - **Goals** — replace the "Zero-config familiarity" bullet with the text in 2.2 below, which
    carries both this change and that one.
  - **UX Notes** — instantly usable without instruction; the layout explains itself. No
    onboarding, no configuration surface.
  - **Assumptions** — the familiarity thesis becomes: a conventional editor-style layout — a
    file tree beside a reading panel — is what makes inspection comfortable. Still the
    product's central unproven bet; just not borrowed.
  - **Risks** — looking like an editor invites expecting an editor: editing, search,
    extensions.
  - **`Why This` is the one exception — keep it.** There VS Code is the alternative a
    developer actually reaches for today, and the two verified citations (its read-only
    settings are per-path, not whole-repository; Restricted Mode still permits editing) are
    the evidence that Nozoki's guarantee is not already available. Write the section around
    *a full code editor*, and name VS Code only inside those citations, where it is evidence
    rather than identity. Do not weaken or drop the citations.

### 2.2 "Launching requires naming a repository" is a mechanism the PRD already handed to the CTO
- **Drafted into the PRD:** Goals says "launching requires naming a repository and nothing
  else"; the Zero-required-configuration metric says "launching against a repository requires
  the repository's location and nothing else."
- **Rationale:** cycle 1 struck the acquisition and start mechanism from the PRD as the CTO's
  (it is now an explicit Out of Scope line). These two sentences describe *how you start it* —
  the same decision, leaking back in through a goal and a bar.
- **Confirm or override:** **Override — say the property, not the mechanism.** Neither line
  should describe when or how the repository is supplied.
  - **Goals** — replace the "Zero-config familiarity" bullet with, in substance: **No learning
    curve** — anyone who can find their way around a repository on GitHub and follow a README
    can use Nozoki. No editor experience required, no onboarding, and no configuration of any
    kind: no settings, no project file, no setup step. The only input it ever needs is which
    repository to view. *(This single bullet carries 2.1's change too.)*
  - **Success Metrics** — Zero required configuration becomes: the only input Nozoki requires
    is which repository to view — no settings, no project file, no setup step. Bar: pass/fail,
    checked at each release.

## 3. Directives — an external action the owner confirms as a gate

None this cycle.
