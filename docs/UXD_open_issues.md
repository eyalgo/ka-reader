# UXD open issues — ka-reader

> Companion to `UXD.md`. The CDO authored the UXD non-interactively; this file holds
> what it could not settle from the inputs (the PRD, the project's finish line and its doctrine, the
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
> file whole to `docs/trail/uxd/` — so what you decided, and why, stays readable and citable
> for good.
>
> **A third source of items, and it is not the CDO.** § 3 holds what a seat downstream of the UXD
> found missing while working from documents the UXD fed. It is answered here and folded by the same
> run, but it was never this run's question.

> **No `product-uxd` run wrote this file.** A `companion-self-answer` run opened it on 2026-11-06,
> in the CDO's seat, while answering `docs/SDD_open_issues.md` item 2.4 — the PRD at v17 – v18
> (`docs/trail/prd/cycle-15.md` § 3.1, owner-confirmed) added the beta's case to "the view never
> lies": in the beta the Git view and the tree's changed-file markers say plainly that they show the
> Git state read when the folder was opened. `UXD.md` is Settled at v12, derives UX-I4 from that
> rule, and carries no such case; its companion was correctly deleted, and it is re-opened because
> the PRD moved after v12 was authored and the document has no other channel: with no companion on
> disk a `product-uxd` re-run reads it as done and has nothing to act on. The SDD at v68 (§ 6 S-7)
> binds the beta's seed to the statement and names this document as where it sits. The reasoning
> is in `docs/trail/sdd/self_answer-77.md` § 2.4 and § *Companions opened*.

---

## 1. Open issues — experience questions with no answer yet

None.

## 2. Choices to confirm — the CDO drafted a best-effort answer; confirm or override

### 2.1 The beta's statement — "the Git state read when the folder was opened" — is a state of the Git view and of the tree's markers, and this document does not draw it
- **Drafted into the UXD:** nothing — this run writes no document. Proposed, for the `product-uxd`
  run that folds this item, reading `docs/PRD.md` at v18 (`ka-reader@d1ea3ac`) and `docs/SDD.md` at
  v68 or later: (1) UX-I4 carries the beta's case the PRD's rule now carries — in the beta, before
  the Git view follows the disk, the Git view and the tree's changed-file markers say plainly that
  they show the Git state read when the folder was opened; a Git view that quietly shows that state
  as if it were current is not admitted (`docs/PRD.md` § UX Notes "the view never lies", the beta's
  case; § Scope (In), *The first public release — a beta*). (2) The UX-S3 row and the UX-S2 row
  each carry the statement as a **state of that surface while the beta stands**, and the row says
  where it sits — this seat's to draw; the lean is one line on the Git view beside the short
  status, and one line at the head of the tree's markers — in words on the surface, and not by
  colour or the tooltip alone (UX-A2 carries the colour half; the tooltip is drawn only under the
  pointer in the key window, `docs/DESIGN.md` § Components "The tooltip", so a stranger who never
  hovers never reads it). (3) Its bounds are this document's own invariants applied, and the row
  states them: the statement is drawn only once the Git state it describes has been read (UX-I13)
  — never over the pending treatment, and never over a fault (UX-S3 Error, UX-I16); in a plain
  folder the view stays wordless and the tree carries no markers, so neither surface says it
  (UX-I17) and the README's known gaps carry the beta's limit for that case. (4) It is withdrawn
  from both surfaces when the Git view follows the disk (`docs/SDD.md` § 6 S-8; § 7, the
  `supersedes` row) — a release-bound state, named so in the row, not a permanent one. The words
  are `docs/CONTENT.md`'s: its companion is opened beside it, `docs/CONTENT_open_issues.md` § 2.1.
  **One case this seat decides and this run does not:** in the beta the root finding is not re-run
  mid-session (`docs/SDD.md` § 6 S-8 *Rests on*), so a repository created at a plain folder's root
  after it was opened leaves the wordless view standing over a repository. Whether UX-I17's
  wordless view carries the statement in the beta, or the README's known gaps carry it alone, is
  the drawing's call. The lean: the view stays wordless and the README carries it — the wordless
  view is the owner's (`docs/trail/prd/cycle-10.md` § 2.2), made so the view says nothing about
  itself, and a statement about state the view does not show is the tool talking about itself.
- **Rationale:** *something upstream moved and this document has not seen it.* PRD v17
  (`docs/trail/prd/cycle-15.md` § 3.1) added the beta's case to "the view never lies"
  (`docs/PRD.md:L244-L246`, `:L261-L263`) and to § Scope (In) (`:L327-L329`); the UXD at v12
  derives UX-I4 (`docs/UXD.md:L259-L261`) from that rule and carries no such case —
  `grep -c 'read when the folder was opened' docs/UXD.md` prints 0 at `ka-reader@796f7df`, and the
  UX-S3 row draws the Git view's cells with no read-at-open state (`:L241`). The SDD at v68 § 6 S-7's
  observable half binds the beta's seed to the statement being there, in words, and names this
  document as where it sits (`docs/SDD.md` § 6 S-7 *Reached when*; § 12, the UXD boundary). A
  statement a surface must carry is a state of that surface — what cannot move late is anything
  changing the states a component must carry (`<CORE>/roles/loaders/cdo_global.md` § *Output*) —
  so it is this document's to draw, and no slice can be built against a state the UXD never names.
- **If overridden:** S-7's bar stands on the PRD's sentence alone, with no UXD counterpart: the
  delivery Architect designing the beta's change has no drawn state to fit the statement into and
  decides its place, its bounds and its withdrawal at the change — structural UX decided after the
  architecture, which is the failure this seat exists to prevent.
- **Confirm or override:** <"confirm", or "override: <what to do instead>">

## 3. Raised from downstream — an item from a seat that did not write the UXD

None.
