# UXD open issues — KA-Reader

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
  `ka-reader@ec2b3f9`): § 2.1 reads *confirm* on R-70 and sends UX-F2 to this item by name; § 1.1,
  § 1.2, § 1.3, § 1.4 and § 2.8 each answer the state named above as (a), (b), (c), the short status
  and (d), and none is overridden. `product-fdr` has not folded them — `docs/fdr.md` last changed at
  `ka-reader@a50718a`, before the answers. That fold is no longer what this item waits on. The FDR is
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
- **Confirm or override:** confirm — UX-F2, § 4 and UX-S6 take the owner's two demonstrated
  answers, and § 6 gains the four states, with the following settled so the fold lands one shape.
  **(1) The Git-view row.** UX-F2 states the row as a system state, in this document's own terms:
  where the diff (UX-S5) is not present, opening a changed file from the Git view reads it exactly
  as a tree selection does; where it is present, the row opens that file's diff in the reading
  panel — one click target, the status letter a label and never a second one — and the file is
  read from the tree. The row never falls back: a diff that cannot be produced is UX-S5's failure
  cell, and the file stays readable from the tree. UX-F2's data line gains the diff's presence;
  UX-F4 already agrees and does not move. Which diff a staged-and-modified, untracked or
  conflicted row opens is behaviour at the FDR's altitude and is not lifted here. UX-F2 carries
  the *changed* marker at the entry against PRD § Key Use Cases 2, with a review note in RN-25's
  shape; the PRD is not reopened — that sentence names no control, and the changed files are
  still opened and read, from the tree. **(2) The history's home.** § 4 *Beyond v1, inside the
  terminus* and UX-S6's success cell state that the Git view carries an entry for the history
  and, opened, the history is drawn in the sidebar as commit rows beneath the changes list, a
  selected commit's diff taking the reading panel; nothing else in UX-S6 or RN-14 moves.
  **(3) The stated end (c).** UX-S6's success cell: where the history shown ends before the
  repository's does, the view states at its end that older commits are not shown; where the
  whole history fits, nothing is stated; no control loads more; a chosen branch whose divergence
  lies past that end runs to it without its join drawn. **(4) The startup surface (a) — one
  row, not two.** UX-S4 is re-titled *Startup surface*; its Empty cell holds the Open panel
  dismissed before any folder is chosen — the surface with its two routes (choose a folder,
  leave) and no failure sentence, because nothing failed; dismissing the panel again returns to
  the same surface, as often as it happens; beyond v1, when the panel is presented for want of a
  remembered folder, the selector's browse entry is the route. Its Error cell stands as written;
  Loading and Success stay n/a with their reasons. A separate row is not opened: § 6's rows are
  surfaces, and RN-27(a)'s ground — a row per state names a screen the product does not have —
  holds here too. **And the [OPEN] closes:** the startup surface renders in the app's window,
  never as terminal text. The question named its own closing condition — *settled by the SDD
  when it fixes the start mechanism* — and the SDD has: the system Open panel at launch, UX-S4 in
  the window (`docs/SDD.md` § 4 C-R3; owner-confirmed `docs/trail/sdd/cycle-1.md` § 2.3). RN-11's
  terminal-fence clause and RN-20's handed-forward seam close with it. **(5) The selector (b).**
  UX-S7's success cell: the list holds the ten folders most recently viewed, most recent first,
  the current one among them and marked, an eleventh viewed dropping the one viewed longest ago;
  an entry stays until it ages out — choosing one whose folder is gone is the Error cell as
  written, the current folder still viewed — and no control removes an entry or clears the list.
  The Empty cell is read as the state before any folder has been viewed — the startup surface's
  selector, beyond v1 — and says so; from the first folder viewed the list holds it. How the
  current entry is marked is `docs/DESIGN.md`'s. **(6) Images (d).** UX-I12 states three cases:
  an image inside the folder renders in place (the owner's call, `docs/trail/sdd/cycle-1.md`
  § 2.4 — this document has never said so); an image whose reference points outside the folder —
  remote, or a path that escapes it — takes the stated not-fetched placeholder, its "remote"
  reading "outside the folder"; an image inside the folder whose file is missing, unreadable or
  not an image takes a placeholder stating what was observed, never a broken-image glyph.
  **(7) The short status.** UX-S3's success cell carries what the status says, not a pointer:
  the repository's non-normal state in Git's own word — merge, rebase, cherry-pick, revert,
  bisect, detached — or that nothing has changed when the tree and index are clean; it carries
  no count, the two lists do; on a detached HEAD the branch element shows the commit's
  identifier; during a rebase the branch being rebased is not shown — named uncovered. The words
  are `docs/CONTENT.md`'s. **Authorization and traces:** every delta cites this companion's own
  trail cycle; the owner's demonstrations (`docs/trail/sdd/cycle-1.md` § 1.2, § 1.3, § 2.3,
  § 2.4) are the evidence the review note quotes, and the FDR is cited nowhere. § 11 gains a row
  per touched entry. `docs/CONTENT.md` and `docs/DESIGN.md` are owed a round **after** this
  fold — the sentences for the new states and the drawing of the startup surface's empty
  state — and nothing is opened on either now, because there is no settled text yet for them to
  follow. Reasoning: `docs/trail/uxd/self_answer-3.md` § 2.1.

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
