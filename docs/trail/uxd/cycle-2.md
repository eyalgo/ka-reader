# UXD open issues — Nozoki 覗き

> Companion to `UXD.md`. The CDO authored the UXD non-interactively; this file holds
> what it could not settle from the inputs (the PRD, the project's Agari and its doctrine, the
> SRS when present, and any context the owner handed over) — and, when a design run has produced
> output for this product, the pointer to it. **Answer inline** — fill each **Answer** / **Confirm-or-override**
> slot — **commit this file**, then re-run `product-uxd`. It folds your answers into the UXD
> and drops the resolved items. When nothing is left open, `product-uxd` **deletes this file**:
> no file = the UXD is done.
>
> **Commit before re-running.** The run that finishes a round removes this file, and git
> refuses to remove a file with uncommitted edits in it — so an uncommitted answer stops
> that run before it can commit anything, and the round's work is left on the floor.
>
> Your answers are never thrown away. Each time the CDO folds them in, it first copies this
> file whole to `docs/uxd_trail/` — so what you decided, and why, stays readable and citable
> for good.

> **This companion was opened by the owner, not by a `product-uxd` run, and it carries exactly one
> item.** The UXD was settled at v2 (`nozoki@7505e1b`) and its companion was correctly deleted. It
> is re-opened here because the **design** round that followed produced one consequence the UXD
> must absorb, and the UXD's own loop has no other way to be told: with no companion on disk a
> `product-uxd` re-run reads the document as done and has nothing to act on. The item below is
> already answered — the owner settled it while walking `DESIGN_open_issues.md` § 2.5
> (`nozoki@e90027a`) — so this round is a fold, not a question. Nothing else in `UXD.md` is
> reopened, and no other item is parked here.

---

## 1. Open issues — experience questions with no answer yet

### 1.1 Where does the theme override control that UX-I9 requires actually live?

- **Why it matters:** UX-I9 (`docs/UXD.md:228-232`) commits the product to a user-settable theme —
  "The user may override, and the choice is remembered in the tool's own state" — but the UXD never
  says **where** that control sits. § 4 describes the shell's chrome and does not place it. So the
  UXD requires a control it does not locate, and `DESIGN.md` had to choose a home in order to
  specify one; that choice is now confirmed and the UXD is the document left disagreeing with
  itself. What depends on it: § 4 (the shell chrome's inventory), and UX-I9's own trace.
- **What was searched:** `docs/UXD.md` — UX-I9 at :228-232 states the requirement and its
  persistence; § 4 carries the chrome's elements (the identity element / repository selector, RN-2,
  RN-15) and names no theme control; the traceability row for UX-I9 (:391) cites the PRD's
  character section, § Data & Privacy, and the owner's cycle-1 § 2.5 answer, none of which place it.
- **Answer:** **The chrome's right end.** The control is a `sun`/`moon` glyph plus the word
  *Light*/*Dark*, naming the theme it switches **to**. `docs/UXD.md` § 4 records the chrome as its
  home, alongside the identity element that RN-2 and RN-15 already put there.

  This is the owner's settled call, made at `DESIGN_open_issues.md` § 2.5 and committed at
  `nozoki@e90027a`: *"confirm all three"*, answered after being told in the same turn that
  confirming carried this UXD amendment with it. The design side of the same call is already in
  `DESIGN.md` § Components "The chrome" (RN-10, RN-12); this item is the UXD half, so that the two
  documents state one placement between them rather than one stating it and the other leaving a gap.

  Placement grounds, as put to the owner before they answered: the theme is **shell-scoped state**,
  exactly like the repository selector they placed in the chrome at `docs/uxd_trail/cycle-1.md`
  § 2.2 — and the sidebar's foot, the other candidate, would tie a whole-shell setting to one of the
  sidebar's two modes. Labelling the control with its destination avoids the ambiguity of a lone
  moon glyph.

## 2. Choices to confirm — the CDO drafted a best-effort answer; confirm or override

None this round. This companion carries one already-answered item and parks no new call.
