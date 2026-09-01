# Self-answer report — SRS.md

## Header

- **Companion:** `docs/SRS_open_issues.md`
- **Document:** `docs/SRS.md` (Draft, v11 — one item open)
- **Decided by:** `decide_companion_answers.md` v1.0.0
- **Date:** 2026-09-01

Read whole before the item was decided: the companion; `docs/SRS.md` v11 end to end; and, as
the item names them, `docs/PRD.md` (v12) § Key Use Cases, § Core Features, § UX Notes, § Scope,
§ Out of Scope; `docs/SDD.md` (v3) S-7, RN-20; `docs/trail/sdd/cycle-1.md` § 1.2; `docs/fdr.md`
(v1) R-69, R-70, R-73, RN-1, RN-12, RN-14; `docs/fdr_open_issues.md` § 2.1;
`docs/trail/fdr/self_answer-1.md` § 2.1 and § Companions opened; `docs/trail/srs/cycle-1.md`
§ 2.2; `system/projects/nozoki/agari.md`; `<CORE>/prompts/cto_create_srs.md` § *Inputs you work
from*, § *Every requirement cites its relation to the PRD*, § *On a re-run — fold, don't
re-author*. The siblings the SRS may read and not cite — `docs/UXD.md` (v7) UX-F2, UX-F4,
UX-S5, and its live companion `docs/UXD_open_issues.md` § 2.1 — were read for collision.

## Items worked

### 2.1 — FR-13 and AC-6 have the Git-view row open the file for reading at the closing release, where the owner's answer has it open the diff

- **Bucket:** 2. Choices to confirm — the CTO drafted a best-effort answer; confirm or override
- **Verdict:** confirmed with addition
- **Why:** The draft is taken as it stands — FR-13 states two readings as a system state, AC-6
  takes both, AC-12 gains the row opening the diff, FR-17 and FR-22 do not move — with four
  additions: the marker and the note's shape, the reason the PRD is not reopened, the
  propagation sites beyond the three the item names, and the failure path the row does not take.
  Nothing in the draft's conclusion moves.

  **Check 1 — yours, in the owner's seat.** Every edit lands in `docs/SRS.md` — FR-13, AC-6,
  AC-12 and a review note — the CTO's document outright (`<CORE>/roles/loaders/cto_global.md`
  § What you own). The product call underneath it is already the owner's, made by demonstration
  against VS Code's Source Control view (`docs/trail/sdd/cycle-1.md` § 1.2 — *"the row opens the
  diff. One click target on the row; the file itself is read by clicking it in the tree"*),
  carried by `docs/SDD.md` RN-20 and S-7 and by `docs/fdr.md` R-70 and RN-1, and confirmed again
  in the owner's seat at `docs/trail/fdr/self_answer-1.md` § 2.1. The item asks this seat to make
  its own document say what the owner decided; no person, party, risk or taste is committed by
  answering, and there is no named ground I cannot see. Two rounds sit between the raising
  (`nozoki@dde4493`) and this deciding — a `product-srs` run that moved the status line to Draft
  at v11 (`nozoki@4c79780`) and added the item's last bullet — and every fact below was
  re-measured on disk today.

  **Check 2 — the reasoning holds, for the reason it gives; four things it does not say.** The
  contradiction is on disk both ways: `docs/SRS.md` FR-13 reads *"A file listed in the Git view
  can be opened for reading exactly as a tree selection is"* (§ 3.4) and AC-6 *"its files open
  for reading"* (§ 8), neither conditioned on FR-17; `docs/fdr.md` R-69 keeps that reading where
  the diff does not exist and R-70 has the row open the diff where it does, and RN-1 names the
  SRS revision as the CTO's. The item's two bullets from the seat that took it up are right and
  are kept: the condition is a system state (FR-17 already reads *(beyond v1)*, and the FDR's
  RN-12 conditions R-69 and R-70 the same way — on a capability existing, never a date), and the
  SDD's trail is downstream and not a source a requirement may cite
  (`<CORE>/prompts/cto_create_srs.md` § *Inputs you work from* — the SDD is *"never a source"*;
  § *Every requirement cites its relation to the PRD* — the citable set is *"closed"*). What the
  draft does not say, and the answer adds:
  - *The marker.* The re-run rule requires that *"a requirement whose settled meaning an answer
    changed carries the marker at the requirement itself"* (`cto_create_srs.md` § *On a re-run*),
    and the relation rule requires a departure from the PRD to be a *changed* note and never body
    narrative (§ *Every requirement cites its relation to the PRD*). So FR-13 carries *changed*
    at the requirement, and a new note — the next free number after RN-36 — records it in the
    shape RN-29 already takes for FR-31: what the PRD says, what the SRS now specifies, and why.
    The authorization it cites is this companion's own trail cycle — `docs/trail/srs/cycle-10.md`
    by the trail's max-plus-one rule (`.claude/skills/product-srs/SKILL.md:61-64`; nine cycles on
    disk today) — which will carry the owner's words quoted above. That is the channel RN-35 and
    RN-36 already use for a self-answer in the owner's seat.
  - *The PRD.* The item's first bullet says whether Key Use Case 2 is revised reaches the PRD
    through its own companion, and opens nothing. I went further and decided it: the PRD is not
    owed a change. `docs/PRD.md` § Key Use Cases item 2 reads *"switches the sidebar to the Git
    view — branch, changed files, staged files at a glance — opens the changed files to read
    them"* — it names no control and no row. At the closing release that sentence still
    describes something a developer does: the Git view shows the changed files, and they are
    read from the tree, where FR-6's markers name which files those are. A fact in the PRD is
    not false, nothing upstream of it moved, and it does not contradict the SRS as revised — none
    of the prompt's three grounds (`decide_companion_answers.md` § *The items are not the whole of
    what a document is owed*) is met, so raising it would spend a CPO cycle on taste. The
    *changed* note says this, so the next reverse walk does not re-raise it. I was close to
    calling this *added* rather than *changed* — the PRD does not say the row opens the file
    either — and what tipped it is that the SRS at v1 – v11 read the sentence as the Git view's
    row opening the file and traced FR-13 to it as *from the PRD*; the second reading departs
    from that settled reading, and *changed* is the honest record of a departure, as RN-29 is.
  - *The propagation sites.* The fold's rule is that an answer's propagation *"reaches every
    requirement, criterion, and note that references the changed item"* and that the owner's
    named targets *"are examples, not the boundary"* (`cto_create_srs.md` § *On a re-run*). Beyond
    FR-13, AC-6 and AC-12, `grep -n 'FR-13' docs/SRS.md` finds four sites: FR-32's *"exactly as
    a tree selection does (FR-7, FR-13)"* — stays, because FR-13's first reading still carries
    that wording and the pointer names a shape, not the row; FR-34's list of Git-derived
    presentations that present nothing in a plain folder — stays, true of both readings; RN-31's
    *"a requirement that is Git's alone — FR-13, FR-22 … keeps 'repository'"* — stays. And
    AC-18's *"files still open for reading"* against a mid-merge and a detached-HEAD repository
    (covers FR-26, FR-12) names no surface; it is read as the tree's and stays. The answer names
    these so the fold checks them rather than finds them, and asks it to report any site beyond.
  - *The failure path.* Check 4, below.

  **Check 3 — nothing settled contradicts it.** The SRS's stability rule permits a delta that
  traces to an owner answer in the open-issues file (`cto_create_srs.md` § *On a re-run*), and a
  confirm on this companion is that channel. FR-17 and FR-22 keep the shape the owner set at
  `docs/trail/srs/cycle-1.md` § 2.2 — staged distinguished from unstaged, per-commit diffs — and
  the answer opens the diff FR-17 already requires, from a row that already lists exactly FR-17's
  files. The plain folder needs no clause: FR-13 is Git's alone (RN-31) and FR-34 already has
  every Git-derived presentation, FR-13 named, present nothing there. Downstream, the SDD's S-7
  and the FDR's R-69 / R-70 already state what the SRS will now say, so the fold closes a
  contradiction rather than opening one. The UXD's UX-F2 still carries the pre-answer text and
  its live companion (`docs/UXD_open_issues.md` § 2.1) already raises it — a sibling the SRS may
  not cite and does not need. The Agari's first condition names diffs inside done and says
  nothing of how one is opened; nothing here sits against its edge.

  **Check 4 — the failure paths.**
  - *Absent* — the diff cannot be produced (Git state for that file unreadable, a lock mid-write).
    The row does not fall back to opening the file: NFR-3 degrades that item's view visibly and
    recovers on a later refresh, and the file stays readable from the tree. A row that silently
    changed meaning on failure would present one control as two, which is the shape the owner
    rejected in (b) of the SDD's question. Stated in the answer.
  - *Empty* — a Git view with no changed files has no row to activate; a file listed as changed
    whose diff is empty when opened is FR-17's presentation, and the SDD's S-7 already gives it a
    statement rather than an empty panel. The SRS binds nothing new.
  - *Stale* — a file whose row is gone by the time it is clicked, its change reverted on disk:
    FR-14 and FR-27's territory, the row removed within NFR-2's bar. Nothing new.
  - *Concurrent* — no case: one click, one panel, the reading panel already holds one thing at a
    time — *"two treatments of one reading panel, not two panels"* (`docs/UXD.md` § 9, read
    for collision).
  - *Refused* — the override branch. Keeping FR-13 unconditioned at the closing release removes
    R-70, leaves the diff with no way to open, and puts the SRS against the owner's demonstrated
    call; the item states this and the FDR's § 2.1 states it too. Not taken.
  - *Not lifted.* The three row cases the FDR's self-answer added — staged-and-modified opens the
    diff of the list clicked (R-112), untracked opens the whole file as added, conflicted opens
    the unstaged diff as Git left it — are behaviour at the FDR's altitude and stay there; the
    SRS says the row opens *that file's diff* and FR-17 says what a diff distinguishes.

  **Read whole, nothing else raised.** The SRS was read end to end for a fact now false, an
  upstream move unfolded, or a contradiction with a document it must agree with. PRD v12 changed
  no product unit (its version line: *"nothing about the product changes"*), so no fold is owed
  on that branch; RN-19 and RN-20's history of the UXD's removal was examined and declined by the
  first self-answer run and is not re-weighed; every trail path the document cites resolves on
  disk. No item is raised on this document.

## Left for the owner

None this run.

## Skipped

None this run.

## Companions opened

None this run.

## Launchers owed

- **`docs/SRS.md`** — `/Users/eyalgolan/projects/kensai/kensaiapp-dev/core/launchers/product-srs/launcher.sh nozoki`
