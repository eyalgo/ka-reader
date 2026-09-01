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
>
> **Where this round stands.** A `product-uxd` run has taken this file up, found its one answer slot
> empty, and so folded nothing and retired no trail cycle. That run changed one thing in the UXD and
> nothing else: its `Status:` line, which read `Settled` while this companion sat beside it, and the
> `Version:` line that records why. **No flow, screen row, interaction pattern, accessibility
> requirement or review note changed** — an unanswered re-run may not touch settled content
> (`<CORE>/prompts/cdo_create_uxd.md` § *On a re-run or a re-authoring — fold, don't re-author*).
> Item 2.1 is the original, with one bullet added by this seat.

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
- **What this seat adds, taking the item up:** four things the finding does not say, after opening
  every source it cites and finding each as described. **(1) The contingency has moved.** Since this
  item was written the owner answered the FDR's companion (`docs/fdr_open_issues.md`, committed at
  `nozoki@ec2b3f9`): § 2.1 reads *confirm* on R-70 and sends UX-F2 to this item by name; § 1.1,
  § 1.2, § 1.3, § 1.4 and § 2.8 each answer the state named above as (a), (b), (c), the short status
  and (d), and none is overridden. `product-fdr` has not folded them — `docs/fdr.md` last changed at
  `nozoki@a50718a`, before the answers. That fold is no longer what this item waits on. The FDR is
  downstream of this document and never a source it may trace to (`<CORE>/prompts/cdo_create_uxd.md`
  § *Inputs you work from*), so an answer written there does not authorize a fold here; the
  authorization the fold would cite is this companion's own trail cycle, which is why the slot below
  is filled here rather than the FDR's *confirm* read as the answer. **(2) The sibling has settled
  its half.** `docs/SRS.md` § 3.4 FR-13 now reads that activating a changed file's row opens the
  file where the diff (FR-17) is not present and that file's diff where it is, the row never falling
  back (confirmed at `docs/trail/srs/cycle-10.md` § 2.1). UX-F2 as written — *"behaves exactly as a
  tree selection"* — collides with that sibling wherever the diff exists; a collision noted, not a
  source. Confirming would state UX-F2 the same way, as a system state and not a delivery moment, and
  UX-F4 (§ 5.4, *"from the Git view, the user opens a changed file's **diff**"*) then agrees with
  it. **(3) What the fold would touch**, so the answer settles what lands: UX-F2's step and its data
  line; § 4 *Beyond v1, inside the terminus* gains where the history is drawn — commit rows in the
  sidebar beneath the changes list, a selected commit's diff taking the reading panel; UX-S6's
  success cell gains that placement and the stated end (c); UX-S7's success cell gains (b); UX-S3's
  success cell carries or points at the short status's content; UX-I12 gains the in-folder
  missing, unreadable or not-an-image placeholder (d); the § 11 rows for each of those; and one
  review note recording the owner answer, with UX-F2 marked *changed* against the PRD's Key Use
  Case 2 *"opens the changed files to read them"* — that sentence is the CPO's, and nothing is opened
  on the PRD from here. **(4) Two things (a) leaves open, for the answer to settle or leave.** UX-S4
  is named *Startup failure* and its Empty cell reads *"n/a — the surface exists only in failure"*;
  a cancelled Open panel is not a failure, so this seat would land it as its own row — a startup
  surface with its two routes — and leave UX-S4 as the failure case, rather than rename UX-S4; say so
  in the slot if the one row is preferred. And where the startup surface renders stays in § Open
  Questions either way; the cancelled-panel cell does not settle it.
- **Confirm or override:**
