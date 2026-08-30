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

> **This companion was opened by the owner, not by a `product-design` run.** `DESIGN.md` is settled
> at v4 and its companion was correctly deleted. It is re-opened deliberately because the **UXD has
> moved again** — it is now Settled at **v6** and adds an entry v4 could not have seen — and this
> document's loop has no other channel: with no companion on disk a `product-design` re-run reads
> the language as done and has nothing to act on.
>
> **This is the same shape as cycle-3**, which was itself opened by hand for the same reason (the
> UXD reaching v5 after v3 was authored; RN-25). Both items below are derivable and arrive
> answered. Neither needs an owner decision, and no token, colour, type, spacing or radius value is
> expected to move.

---

## 1. Open issues

### 1.1 `{components.status-message}` claims *every* empty state; UXD v6 adds one that carries no message

- **What was searched:** `DESIGN.md:657-660` defines `{components.status-message}` as "every empty,
  pending, and failure state the UXD names (`docs/UXD.md` § 6)" and enumerates seven — the empty
  reading panel, the empty tree, the clean Git view, a cannot-display placeholder, a vanished file,
  an unreadable entry, a startup failure. `grep -c 'UX-I17' DESIGN.md` returns **0**.
- **Why it matters:** `docs/UXD.md` v6 adds **UX-I17** — in a plain folder the Git view is present
  and shows **nothing**: no message, no label, no explanation, no control, and nothing that offers
  to create a repository. That is an empty state which is **not** a status message, and the word
  *every* does not admit it. What went stale is the enumeration and its scope claim, not the
  treatment — exactly as at cycle-3.
- **The substance, and the part that is easy to get wrong.** After UXD v6 the Git view has **three**
  appearances, and only two of them are `{components.status-message}`:
  1. **Reading** — before the tool has found whether the folder is a repository's root: *"not a
     clean tree, and not nothing"* (UX-I13, UX-I17). **A status message.**
  2. **An observed plain folder** — nothing at all (UX-I17, RN-27). **Not** a status message.
  3. **A fault while finding out** — the unexplained fault, *"shown as a fault and never as
     nothing"* (UX-I16, RN-27). **A status message.**
  Drawing 2 as a status message puts words on a surface the owner decided is wordless; drawing 3 as
  nothing hides a fault behind an ordinary state. The distinction is the point of this item.
- **Answer:** state the exception where the scope claim is made. `{components.status-message}`
  covers every empty, pending and failure state UXD § 6 names **except one**: the observed plain
  folder's Git view, which carries no message and therefore no instance of this component. Say why
  in one clause — the surface has no truthful next step, because the two actions a Git-less folder
  would otherwise invite are writes this product can never offer (`docs/prd_trail/cycle-10.md`
  § 2.2, the owner's decision). Keep the reading and fault appearances inside the component
  explicitly, so the exception cannot be read wider than it is.

  **A clean repository and a plain folder are told apart by what the clean view carries** — the
  branch and its stated "nothing changed" — **against nothing at all; the shell adds no other cue**
  (`docs/UXD.md` RN-27). No new component, affordance or cue is to be introduced to disambiguate
  them: that was put to the owner and settled as *simple*.

### 1.2 The Traceability table has no row for UX-I17

- **What was searched:** the Traceability table at `DESIGN.md:1004-1015` gives every UXD entry a
  row — UX-A2, UX-A4, UX-I2/I3, UX-I9, UX-I12, UX-I13, UX-I14, UX-I15, UX-I16, UX-F5/RN-15,
  UX-S5/UX-S6. There is no UX-I17 row.
- **Why it matters:** this document gives every UXD entry a home, and a missing row is how the next
  reader concludes the entry has no design consequence when in fact it has an unusual one — the
  absence of a component.
- **Answer:** add one row for UX-I17 in the shape the UX-I16 row already uses, pointing at the
  exception stated in 1.1 rather than at a treatment. The honest content of the row is that this
  entry is satisfied by drawing **nothing**.

## 2. Choices to confirm — the CDO drafted a best-effort answer; confirm or override

*(none — both items above are derivable from the settled UXD and arrive answered.)*

**Standing, and not reopened by this round:** every token, colour, type, spacing and radius value in
this document. The plain folder is *"a condition on the surfaces that already exist, not a surface
of its own"* (`docs/UXD.md` v6), so this round is expected to add **no component and move no
value** — the shape both cycle-2 and cycle-3 closed with. A round that finds it must move one
should say so explicitly in its record rather than doing it quietly.
