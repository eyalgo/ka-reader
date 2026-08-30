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

> **Round 2 on the fault state.** The companion you opened (`nozoki@0713035`) carried one item
> with three parts and said which seat each belongs to. This run took the two it was told it
> could: **where** the unexplained-fault state is shown is now `UXD.md` § 6 and UX-I16 (RN-23),
> and **whether a control reveals the fault's detail** is drafted as *no* and put up for your
> sign-off below (§ 2.1). The third part — **whether v1 has this class at all** — is a scope
> call and is yours; it is § 1.1, unchanged in substance and not settled by implication: UX-I16
> is written for *the first fault that proves the class real* and says so.

---

## 1. Open issues — experience questions with no answer yet

### 1.1 Does v1 ship with the unexplained-fault class at all, or only with the surfaces that would carry it?

- **Why it matters:** `UXD.md` UX-I16 and § 6 now declare where an unexplained fault is shown,
  and `docs/CONTENT.md` § Message patterns *Error* carries its wording — but both are written
  the way § Message patterns *Recovered* is: for the first release that reaches the state. What
  neither settles is scope. Two answers are legitimate and complete:
  - **v1 has the class.** The delivery tier treats every read path (file, tree entry, Git state,
    the repository at startup) as one that can end in *stopped, can't tell why*, and builds the
    UX-I16 presentation on each. The SDD sizes it.
  - **v1 ships without it.** Every failure v1 can reach is one it observed (the § 6 cells as they
    stood at v3); UX-I16 and the CONTENT formula stand written for the first release that proves
    otherwise, and no v1 change is asked to implement them. This is the reading the raising item
    named as legitimate (`nozoki@0713035`; `docs/CONTENT_open_issues.md` § 1.1, part 3).
  The call moves nothing in `UXD.md` either way — the entry is scope-neutral by design — but it
  decides whether v1 is built to reach the state at all, so it has to be yours.
- **Answer:** **Yes — v1 has the class.** The owner's word was "yes", answering the question as the
  item put it. That is the first of the two readings the item set out, and it is taken with the
  consequence the item states: the delivery tier treats **every read path** — a file, a tree entry,
  Git state, the repository at startup — as one that can end in *stopped, can't tell why*, and builds
  the UX-I16 presentation on each. **The SDD sizes it.**

  So the class is not written-for-later: it is in scope for v1.
  Nothing in `UXD.md` moves on this answer — the entry is scope-neutral by design, as the item
  records — but `product-sdd` now inherits a live requirement rather than a pattern held in reserve.

### 1.2 RN-20 cites a file under `journey/`, which a definition document may not do

- **Why it matters:** `docs/UXD.md` **RN-20** (`UXD.md:637-640`) sources its claim to
  `system/projects/nozoki/journey/shukuba/2026-08-26_experience.md` § Guardrail. That is a citation
  a definition document may not make: *"A product document's sources are the PRD, the project's
  Agari, its doctrine, and its sibling documents — all of which settle. A journey file moves to
  `trail/` the week after, so a settled product document that cites one cites a path that no longer
  exists"* (`<CORE>/doctrine/setup/setting_up_a_project.md` § *The definition set never names the
  journey*). The station is a legitimate **input** to the run — its guardrail binds, and a run that
  ignored it would be the defect — but it is not a legitimate source. This is the only such citation
  in the whole set; `PRD.md`, `SRS.md`, `DESIGN.md`, `CONTENT.md` and `README.md` carry none.
- **What was searched:** every settled document in `docs/` plus `README.md`, for any citation of a
  path under `journey/` and for each of that folder's stage names — one hit, `UXD.md:640`. Citations of
  `system/projects/nozoki/agari.md` were checked and are **not** this: the Agari is a declaration and
  a named legitimate source, not a journey file.
- **Answer:** **Re-source RN-20 to the SRS itself.** The note's fact does not change — no entry here
  traces to `docs/SRS.md`; it was read for collisions and none was found; its UI-visible requirements
  FR-3, FR-4 and FR-23–FR-32 say what this document says. Cite those requirements directly, which is
  where the fact actually lives, and drop the clause that reaches for the station. The FR-2 seam the
  note hands forward is unaffected and stays as written.

  **Make the change silently.** RN-20 should read as though it had always been sourced this way: no
  new review note, no added clause explaining what it no longer cites, and no version-line entry
  describing the correction. A note explaining the change would have to name what was removed, which
  would put the reference back into `UXD.md` permanently and undo the point of the item. Nothing else
  in the document moves.

## 2. Choices to confirm — the CDO drafted a best-effort answer; confirm or override

### 2.1 No control on any surface reveals, expands or copies an unexplained fault's detail

- **Drafted into the UXD:** UX-I16's closing rule — no reveal / expand / copy control, no
  message that asks the reader to report the fault; where the tool keeps a diagnostic it keeps
  it away from every surface, and where that is is the SRS's (RN-24).
- **Rationale:** three rules already on the record leave such a control nothing legitimate to
  show or do. The text it would reveal is banned from anything a person sees
  (`docs/CONTENT.md` § Terminology, *Banned*: *error, exception, stack trace, ENOENT, EACCES*).
  The one thing a copied detail is for is a report to a channel this instance does not staff —
  not a route out under UX-I14, and not answered under
  `system/doctrine/kensaiapp_doctrine.md` § Maintainer capacity. And the diagnostic already has
  a home off the surface: `docs/SRS.md` NFR-11 keeps it with the tool's own state, never
  transmitted. The cost is stated rather than hidden: a fault nobody can see is a fault nobody
  can report. The surface gives the reader the smaller true thing — the limit of what the tool
  knows, and what still works.
- **If overridden:** UX-I16 gains a control (its label and placement), which is a component
  `docs/DESIGN.md` must carry and a string `docs/CONTENT.md` must write — and CONTENT's ban on
  internal text needs a stated exception for what the control shows, which reopens
  `product-content`. The SRS gains a requirement for what the detail is and where it is copied
  from (NFR-11 today says only where it lives), so `product-srs` re-runs to cost it. UX-I14
  itself does not move: a copy control beside a message is not a route out and never stands
  alone, so the surface's route out stays the shell around the failed item.
- **Confirm or override:** **confirm** — UX-I16's closing rule stands: no control on any surface
  reveals, expands or copies an unexplained fault's detail, and no message asks the reader to report
  it. Where the tool keeps a diagnostic it keeps it away from every surface, and where that is stays
  the SRS's (RN-24, `docs/SRS.md` NFR-11).

  The owner said "confirm" and nothing more. The three grounds the draft rests on are the CDO's, not
  restated as theirs: the text such a control would reveal is banned from anything a person sees
  (`docs/CONTENT.md` § Terminology, *Banned*); a copied detail's one use is a report to a channel
  this instance does not staff, which is not a route out under UX-I14; and the diagnostic already has
  a home off the surface (`docs/SRS.md` NFR-11). The stated cost is accepted with the confirm: **a
  fault nobody can see is a fault nobody can report.**

  **Consequence of confirming, as against overriding:** nothing reopens. `product-content` owes no
  string and no exception to its ban on internal text, `docs/DESIGN.md` owes no control component,
  and `product-srs` does not re-run — NFR-11 already says where the diagnostic lives, and confirming
  asks it for nothing more.
