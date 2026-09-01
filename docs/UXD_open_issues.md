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
> file whole to `docs/trail/uxd/` — so what you decided, and why, stays readable and citable
> for good.

> **Where this round stands.** A `product-uxd` run took this file up carrying two items. Its
> § 2.1 — UX-F2 and UX-S6's pre-answer text, and the four states § 6 did not draw — held an
> answer, and the run folded it into `docs/UXD.md` at v9 (RN-29) after retiring this file whole,
> as it then stood, to `docs/trail/uxd/cycle-6.md`. The item below is the one that remains. It
> was raised by a `companion-self-answer` run, not by a `product-uxd` run, its slot is at its
> placeholder, and it keeps the number § 2.2 because sibling records already cite it by that
> number (`docs/trail/design/self_answer-2.md` § Companions opened; `docs/DESIGN_open_issues.md`
> § 2.1). `docs/UXD.md` reads Draft while this file is on disk.

---

## 1. Open issues — experience questions with no answer yet

None this round.

## 2. Choices to confirm — the CDO drafted a best-effort answer; confirm or override

### 2.2 Five body entries still say *repository* where RN-25 says the document now says *folder* — § 2's two dials, § 4's path line, UX-I4, UX-I7 / UX-I9, and § 10's start sentence

> **This item was raised by a `companion-self-answer` run, not by a `product-uxd` run.** The run was
> answering `docs/DESIGN_open_issues.md` § 2.1 — the DESIGN's sign-off on its own *folder* /
> *folder selector* rename — and that item keeps two DESIGN sentences worded *repository* only
> because this document still reads so at § 2 and § 4. Reading this document to test that ground
> found the five places below, none of them in RN-25's list of what moved and none in its list of
> what deliberately stays. Reasoning: `docs/trail/design/self_answer-2.md` § Companions opened.

- **Drafted into the UXD:** nothing — this is a finding, not a drafted change. RN-25 states that
  *"every place this document said 'repository' where it meant the input now says 'folder'"* and
  lists them (§ 1, UX-U3, § 4's identity element and its beyond-v1 bullet, UX-F1, UX-F3, UX-F5,
  UX-S7, UX-I16), and states what stays on purpose — *"Where the PRD keeps 'repository' … this
  document keeps it too: UX-U1 and UX-U2 do not move"* (`docs/UXD.md` § UXD Review Notes RN-25).
  Five body places are in neither list and still name the input *repository*, measured on v8
  (`grep -n -i repositor docs/UXD.md`, 2026-09-01): **§ 2 Design Dials** — MOTION *"Content moves
  because the repository moves"* (`:41`) and DENSITY *"Dense where the repository is dense … the
  density is the repository's, not the shell's"* (`:42`); **§ 4** — *"The open file's
  repository-relative path"* (`:101`); **UX-I4** — *"what is shown is the repository's current
  state"* (`:247`); **UX-I7** — *"no user action changes anything in the repository"* (`:258`) and
  **UX-I9** — *"remembered in the tool's own state — never in the repository"* (`:267`); **§ 10**
  — *"begins with the shell open against a repository (UX-F1)"* (`:432`), where UX-F1 itself now
  opens against a folder. The lean: each reads *folder* (the path line *folder-relative*), on the
  authority RN-25 already carries, and RN-25's list of what moved grows by these entries.
- **Rationale:** the document contradicts its own review note — RN-25's *"every place"* is false by
  measurement — and the instance's writing bar binds one name per term across every document here
  (`system/doctrine/writing_bar.md` § 1.2). Each of the five means the viewed input, not Git: a
  plain folder's density is its own, its file paths are relative to it, its state is what the view
  shows, and the tool writes nothing into it. Two of them are quoted downstream as they read —
  `docs/DESIGN.md` § Overview *"Density is the repository's"* and its `{components.path-line}`
  *"repository-relative path"*, kept at DESIGN v7 *because* § 2 and § 4 here still say so (RN-27
  there) — so the residue here is what holds the residue there. The FDR's RN-14 treated the same
  class in DESIGN as *"a stale sibling … the CDO's to revise"* (`docs/fdr.md` § FDR Review Notes
  RN-14). The doubt, stated: UX-U1's *repository* is deliberate per RN-25 and is not in this
  list; whether any of the five is likewise a deliberate mirror of the PRD is this seat's to say
  when it folds, and if so the answer is to add it to RN-25's keep list rather than rename it.
- **If overridden:** the five stand as written, RN-25's keep list names them so the residue reads
  as a decision and not an oversight, and `docs/DESIGN.md` keeps its two quoted phrases on the
  same ground. Nothing downstream moves.
- **Confirm or override:** <"confirm", or "override: <what to do instead>">
