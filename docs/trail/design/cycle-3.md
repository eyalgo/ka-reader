# DESIGN open issues — Nozoki 覗き

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
> file whole to `docs/design_trail/` — so what you decided, and why, stays readable and citable
> for good.

> **This companion was opened by the owner, not by a `product-design` run.** `DESIGN.md` is settled
> at v3 and its companion was correctly deleted. It is re-opened because `docs/UXD.md` reached **v5**
> after this document was last authored, adding an entry (**UX-I16**) that v3 could not have seen —
> v3 landed at `nozoki@e5f0c02`, UX-I16 entered at `nozoki@8af3e8d`. Both items below are
> **derivable and already answered**; neither needs an owner decision, and no token, colour, type,
> spacing or radius value moves.

---

## 1. Open issues

### 1.1 `{components.status-message}` claims to cover every failure state the UXD names, and no longer does

- **Why it matters:** `docs/DESIGN.md:657-659` defines the component as *"every empty, pending, and
  failure state the UXD names (`docs/UXD.md` § 6)"* and then enumerates them: the empty reading
  panel, the empty tree, the clean Git view, a cannot-display placeholder, a vanished file, an
  unreadable entry, a startup failure. Every one is a condition Nozoki **observed**. `docs/UXD.md`
  § 6 now states that **every failure cell holds two classes** — the observed condition and the
  **unexplained fault** — and **UX-I16** gives the second its presentation. So the component's own
  claim of completeness is no longer true, and the enumeration is the part that went stale, not the
  treatment.
- **What was searched:** `docs/DESIGN.md` for `UX-I16` — **zero** occurrences; `:657-668` for the
  component's contract; `docs/UXD.md` § 6 preamble and UX-I16 for what the second class requires.
  `docs/CONTENT.md` was checked as the sibling that folded later and carries UX-I16 in ten places,
  so the verbal side is already current — this is the last document that has not caught up.
- **Answer:** **Add the unexplained fault to the enumeration; change nothing else.** The treatment
  already fits it exactly: `circle-alert` glyph rather than `info`, `{typography.ui}` in
  `{colors.ink-muted}` on `{colors.surface}`, inset `{spacing.xl}`, top-left and never centred, the
  glyph never standing alone, and the route out following on the same surface — which is precisely
  what UX-I16 asks for (*what was observed and nothing more, scoped to the item that stopped,
  recovering without ceremony*) and what UX-I14 already required of every failure. **No new
  component, no new token, and no value moves.** The component's sentence gains the second class;
  the rest of the paragraph stands as written.

  Two things that are already right and must not be "fixed" while doing this: the tooltip stays
  bound to the status letter alone — RN-23 and the Don't at `:708` say it is raised by no other
  surface, which is what keeps UXD **RN-24** satisfied, since no control may reveal or expand a
  fault's detail. And the fault message carries no reveal, expand or copy control of any kind.

### 1.2 The traceability table stops at UX-I15 and has no row for UX-I16

- **Why it matters:** `docs/DESIGN.md:986-989` runs UX-I12, UX-I13, UX-I14, UX-I15 and stops. This
  document's own convention gives every UXD entry a row saying where it is honoured, and UX-I16 is a
  UXD entry with a home in this document.
- **What was searched:** `docs/DESIGN.md:983-989` for the run of `UX-I1*` rows; the UX-I14 row for
  the shape the new one should take — *"§ Components 'Status messages': the route follows the
  message; the Do's require it"*.
- **Answer:** **Add the row, in the shape UX-I14's row already uses.** It points at § Components
  *"Status messages"* — the unexplained fault is the second class of the same component, drawn in
  the surface's own failure slot with the same treatment and the same route out — and records that
  UXD RN-24's no-detail-control rule is held here by the tooltip's single home (RN-23) and the Don't
  that binds it. Nothing else in the table moves.
