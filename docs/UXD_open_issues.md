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

> **This companion was opened by a `companion-self-answer` run, not by a `product-uxd` run.**
> `UXD.md` is Settled at v7 and its companion was correctly deleted. It is opened because a run
> answering the FDR's companion (`docs/fdr_open_issues.md`, recorded in
> `docs/trail/fdr/self_answer-1.md` § Companions opened) read the UXD against the SDD and the FDR
> and found two entries still carrying text the owner overrode two rounds ago, with nothing raised
> here since — and because the answers that run wrote into the FDR's companion add states § 6 has
> no cell for. With no companion on disk a `product-uxd` re-run reads the UXD as done and has
> nothing to act on. The one item below arrives with the run's finding and its reasoning; the
> decision is the next round's.

---

## 2. Choices to confirm — the CDO drafted a best-effort answer; confirm or override

### 2.1 UX-F2 and UX-S6 still carry the pre-answer text the owner overrode in the SDD round, and the FDR's answered companion adds states § 6 does not draw
- **Drafted into the UXD:** UX-F2's step reads *"They open a changed file from the Git view to read
  it (opening from the Git view behaves exactly as a tree selection)"* (`docs/UXD.md` § 5.2); § 4
  and UX-S6 say the history is *reached from* the Git view and do not say where it is drawn
  (`docs/UXD.md` § 4 "Beyond v1, inside the terminus"; § 6 UX-S6). And § 6 has no cell for four
  behaviours the FDR's companion now carries as answers.
- **Rationale:** the owner answered both entries by demonstration, against VS Code's Source Control
  view: the Git-view row opens the **diff** — one click target, the status letter a label and never
  a second target, the file itself read from the tree — and the history sits **in the sidebar**, as
  commit rows beneath the changes list, a selected commit's diff taking the reading panel
  (`docs/trail/sdd/cycle-1.md` § 1.2, § 1.3). `docs/SDD.md` § SDD Review Notes RN-20 records that
  *"the UXD at v6 still carries the pre-answer text in UX-F2 and UX-S6; the entries are revised by
  the UXD's own run, not here"*, and the SDD's v3 status line repeats it of v7. Two UXD rounds
  since (v6, v7) touched neither, because nothing raised them in this file. The FDR carries the
  answer as R-70 and R-73 and names UX-F2 as this seat's to revise (`docs/fdr.md` § FDR Review
  Notes RN-1, RN-14); the FDR companion's self-answer confirmed R-70
  (`docs/trail/fdr/self_answer-1.md` § 2.1).
  The second half is contingent on `product-fdr` folding that companion. Its answers state four
  behaviours § 6 has no cell for: **(a)** the Open panel cancelled at launch, before any folder is
  chosen — the startup surface with its two routes and no failure sentence, where UX-S4's *Empty*
  cell reads *"n/a — the surface exists only in failure"* (`docs/fdr_open_issues.md` § 1.1);
  **(b)** the folder selector lists the ten most recently viewed folders, most recent first, the
  current one marked, with no control that removes an entry — UX-S7's success cell (§ 1.2);
  **(c)** the history states at its end that older commits are not shown, where the loaded window
  ends before the history does — UX-S6's success cell (§ 1.3); **(d)** an image reference inside
  the folder whose file is missing, unreadable, or not an image takes a placeholder stating what
  was observed, never a broken-image glyph — UX-I12 names remote content only (§ 2.8). The short
  status's content is defined there too (§ 1.4), for UX-S3's success cell to carry or point at.
  `docs/CONTENT.md` and `docs/DESIGN.md` follow this document's revision for the words and the
  drawing; nothing is raised on them for this.
- **If overridden:** leaving UX-F2 and UX-S6 as written keeps this document in contradiction with
  the SDD's settled RN-20 and with the FDR's R-70 and R-73 at the closing release, and the SDD goes
  on citing the trail instead of the entries. Declining the four states leaves them stated in the
  FDR with no experience cell, and CONTENT and DESIGN with nothing to trace them to.
- **Confirm or override:**
