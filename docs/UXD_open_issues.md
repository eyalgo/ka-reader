# UXD open issues — Nozoki 覗き

> Companion to `UXD.md`. The CDO authored the UXD non-interactively; this file holds
> what it could not settle from the inputs (the PRD, the project's Agari and its doctrine, the
> SRS when present, and any context the owner handed over). **Answer inline** — fill each
> **Answer** / **Confirm-or-override** slot — **commit this file**, then re-run `product-uxd`.
> It folds your answers into the UXD and drops the resolved items. When nothing is left open,
> `product-uxd` **deletes this file**: no file = the UXD is done.
>
> **Commit before re-running.** The run that finishes a round removes this file, and git
> refuses to remove a file with uncommitted edits in it — so an uncommitted answer stops
> that run before it can commit anything, and the round's work is left on the floor.
>
> Your answers are never thrown away. Each time the CDO folds them in, it first copies this
> file whole to `docs/uxd_trail/` — so what you decided, and why, stays readable and citable
> for good.

---

## 1. Open issues — experience questions with no answer yet

None this cycle — every unsettled call carried a defensible lean, so each is listed under §2 as
a choice to confirm.

## 2. Choices to confirm — the CDO drafted a best-effort answer; confirm or override

### 2.1 The design direction — a restrained code-workbench built from primitives, no established component design system

- **Drafted into the UXD:** § 1 (Design Read) and § 9 (Design-System Direction): no established
  component design system; a restrained code-workbench aesthetic built from primitives — reading
  panel dominant, text-first navigation, minimal chrome, nothing decorative. One system for the
  product. `DESIGN.md` will be authored from primitives against § 9's constraints (both themes
  first-class with the initial polarity from the platform signal; state distinctions legible
  without color, with deficiency-safe pairs as swappable tokens; legible code-reading text;
  syntax highlighting and monospace held as expectations).
- **Rationale:** the PRD's familiarity thesis names the layout — a conventional editor-style
  workbench, which no general-purpose component design system provides — and the character
  ("calm, truthful, still"; nothing decorative) rules out imported component aesthetics. In this
  domain restraint is the credibility signal. The aesthetic lean is a taste call, so however
  confidently drafted, it is yours to confirm.
- **If overridden** (an established design system named instead): § 1's read and § 9's direction
  and constraints re-anchor to that system; `DESIGN.md` would be authored from the named
  system's official package rather than from primitives; § 2's dial reasoning is re-checked
  against the system's own idiom (values may move); RN-8 records the override. The flows,
  screens, and states (§§ 5–6) do not move — they are layout- and state-level, not
  aesthetic-level.
- **Confirm or override:**

### 2.2 The v1 accessibility posture is stated in the README (UX-A3)

- **Drafted into the UXD:** UX-A3 — one plain sentence on the README stating what UX-A1 holds:
  v1 is mouse-driven and makes no assistive-technology promise. No claim beyond the settled
  posture.
- **Rationale:** the posture you settled (`docs/prd_trail/cycle-5.md`) currently lives in the
  PRD and the UXD, which an adopter never reads. A silent floor fails them quietly; a stated
  narrow floor is information they can act on before spending their first minute, and a claim
  the project can be held to. It adds a line to a surface the CPO owns — the README, whose
  first-screen content the PRD already fixes — which is why this is routed to you rather than
  asserted.
- **If overridden** (keep the posture out of the README): UX-A3 drops from the UXD and RN-10
  records the decision; UX-A1 (the posture itself) and UX-A2 (no meaning by hue alone) stand
  untouched; the posture stays discoverable only in the product documents.
- **Confirm or override:**
