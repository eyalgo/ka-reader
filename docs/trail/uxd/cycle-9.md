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
- **Confirm or override:** confirm, with four additions for the fold, decided in the CDO's seat.
  (1) **The case the item leaves open is now settled upstream, and the lean stands on it.** The
  SRS settled at v14 after this item was written (`ka-reader@c7440d7`). Its FR-35 and AC-26
  (`docs/SRS.md:L255-L264`, `:L660-L667`) carry the statement as a system state, and they name
  this very case as uncovered on the surface. In the read-at-open state, a repository created at
  the opened folder's root after it was opened is not followed: the view goes on presenting a plain
  folder with no statement, and the README's known gaps tell the user. So UX-I17's wordless view
  carries no statement in the beta, as the draft leans. The draft's own reason, the owner's wordless
  view (`docs/trail/prd/cycle-10.md` § 2.2), still holds, and drawing it the other way would
  contradict a settled requirement. RN-28's *"a transition that cannot occur is not a state this
  document draws differently"* was written for a narrowing that removes the transition. The beta
  keeps the change on disk and drops only the following, which is why the SRS names the case and
  this document should too.
  (2) **The tree's line stands on a clean repository too.** Each surface carries the statement
  wherever it shows Git state it read at open. On the tree that includes a repository with nothing
  changed: no markers in a repository is itself the Git state read at open. In the beta an agent's
  later edits reach the tree with no marker, and without the line that reads as *unchanged*, which
  is the driving scenario misled (UX-U2). The draft's "at the head of the tree's markers" therefore
  reads *at the head of the tree*. The line is absent only where no Git state is shown: before the
  read (UX-S2 and UX-S3 Loading, UX-I13), in a plain folder (UX-I17), and where finding out
  stopped (UX-I16).
  (3) **A Git-state failure observed at open does not recover in the beta, and the UXD says so.**
  UX-S3 Error ("recovers on refresh"), UX-F2's failure line ("recovers on a later refresh") and
  UX-I16 ("the next successful read replaces it") each assume a later Git read. In the beta there
  is none (`docs/SRS.md` FR-35; `docs/SDD.md` § 6 S-4 *Not in this slice*, S-8 *Rests on*). The fold
  carries the beta's case on each. An item observed unreadable at open, such as a lock or an
  unreadable file, is part of the state read when the folder was opened, and the view's line stands
  over it as over the rest of the view. It stays until the folder is opened again, which in v1
  means starting KA-Reader again (UX-S4). The surface promises no recovery, and the route out stays
  the tree and the panel (UX-I10, UX-I14). So the draft's bound (3), "never over a fault (UX-S3
  Error, UX-I16)", narrows to the unexplained fault, whose slot draws only that the work stopped
  (UX-I16). The words are `docs/CONTENT.md`'s, and its lock message promises the recovery the beta
  never makes. That is raised at `docs/CONTENT_open_issues.md` § 2.2 (`ka-reader@39e9229`).
  (4) **UX-F3's and UX-I17's live sentences carry the beta's bound.** UX-F3 has Git state follow
  the disk, and UX-I17 has a repository appearing or leaving the root mid-session arrive "as every
  change does". In the beta neither is true (`docs/SDD.md` § 6 S-8 *Delivers*). Each sentence says
  what holds instead. The tree and the open file follow the disk. Git state stays as read at open,
  under the statement. A repository leaving the root leaves the read-at-open view standing under
  its statement, and one appearing is (1)'s uncovered case.
  The draft's placement, one line on the Git view beside the short status and one at the head of
  the tree, in words on the surface, is confirmed as this seat's call. So are its withdrawal and the
  words being `docs/CONTENT.md`'s. Reasoning: `docs/trail/uxd/self_answer-6.md` § 2.1.

## 3. Raised from downstream — an item from a seat that did not write the UXD

None.
