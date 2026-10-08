# Self-answer report — UXD.md

## Header

- **Companion:** /Users/eyalgolan/products/ka-reader/docs/UXD_open_issues.md
- **Document:** `docs/UXD.md` — the UXD, Draft at v8
- **Decided by:** `decide_companion_answers.md` v1.0.0
- **Date:** 2026-09-01

Read whole before the item was decided: the companion; `docs/UXD.md` (v8); and, as the item
names them, `docs/trail/sdd/cycle-1.md` § 1.2, § 1.3, § 2.3, § 2.4; `docs/SDD.md` (v3) § 4 C-R3,
S-6 – S-8, RN-20; `docs/fdr.md` (v1) R-69, R-70, R-73, RN-1, RN-12, RN-14; `docs/fdr_open_issues.md`
§ 1.1 – § 1.4, § 2.1, § 2.8 and `docs/trail/fdr/self_answer-1.md`; `docs/SRS.md` (v12) FR-1 – FR-3,
FR-13, FR-17 – FR-19, FR-22 and `docs/trail/srs/cycle-10.md` § 2.1; `docs/PRD.md` (v12) § Key Use
Cases, § UX Notes; `docs/ux_reference/README.md` § Owner directives; `<CORE>/prompts/cdo_create_uxd.md`
§ *Inputs you work from*, § *On a re-run or a re-authoring*. The siblings the UXD may read and not
cite — `docs/DESIGN.md` (v6) § Components "The chrome and its controls", "The menu", "The branch
chip", RN-13, and its live companion `docs/DESIGN_open_issues.md` § 2.1; `docs/CONTENT.md` (v6)
§ Message patterns, § Terminology, § Traceability — were read for collision on every state the
item adds. Every fact the item states was re-measured on disk: `docs/fdr.md` last changed at
`a50718a` and its companion was answered at `ec2b3f9`; the SRS folded FR-13's two readings at v12
(`5c9dda7`); the UXD's last content change is v7 (`05eac42`) and v8 (`3fce6ed`) moved only its
status line.

## Items worked

### 2.1 — UX-F2 and UX-S6 still carry the pre-answer text the owner overrode in the SDD round, and the FDR's answered companion adds states § 6 does not draw

- **Bucket:** 2. Choices to confirm — the CDO drafted a best-effort answer; confirm or override
- **Verdict:** confirmed with addition
- **Why:** Confirmed: UX-F2, § 4 and UX-S6 take the owner's two answers, and § 6 gains the four
  states. The item's "draft" is the stale text itself, so what was weighed is the revision its
  rationale and the seat's four additions propose — and every ground it gives was opened and
  holds. The owner decided the Git-view row and the history's home by demonstration
  (`docs/trail/sdd/cycle-1.md` § 1.2 — *"the row opens the diff. One click target on the row; the
  file itself is read by clicking it in the tree"*; § 1.3 — *"The sidebar ... the commit graph is
  drawn as rows in the sidebar below the changes list"*). The SDD carries both (`docs/SDD.md`
  RN-20, S-7, S-8) and says of UXD v6 and v7 that the entries are *"revised by the UXD's own run,
  not here"*; the FDR carries them as R-70 and R-73 and names UX-F2 as this seat's (RN-1, RN-14);
  the SRS has already done its half — FR-13 at v12 states the two readings as a system state
  (`docs/SRS.md` § 3.4 FR-13; `docs/trail/srs/cycle-10.md` § 2.1). A document three settled
  siblings describe as stale, on a call the owner made, is *"a fact in it is now false"* and the
  revision is not a taste change. Check 1: the edits land in the UXD, which is this seat's; the
  answer binds no person, party or risk; and no ground the owner has reserved could be named —
  the demonstrations are the owner's decision, and applying them is the CDO's. Check 3: PRD Key
  Use Case 2 *"opens the changed files to read them"* names no control and still holds from the
  tree, so UX-F2 is marked *changed* and the PRD is not reopened — the reading the SRS's RN-37
  already made, and re-made here on the same facts. UX-F4 already says *diff* and does not move.

  **The four states were each weighed on their own grounds, not taken from the FDR.** The FDR is
  downstream and never a source (`<CORE>/prompts/cdo_create_uxd.md` § *Inputs you work from*),
  and its companion was answered by a run, not the owner (`ec2b3f9`). Each holds as a UXD entry
  by this document's own rule that an unhandled state is a defect here (RN-4): **(a)** a cancelled
  Open panel is a state the shell can land in and no cell names; **(b)** UX-S7's success cell
  says *"lists remembered folders"* and states no bound, order or removal rule — three defaults
  nobody has decided, and a default is a design decision this seat records with its reason (ten
  because a glance holds it and an unbounded list needs a removal control or a search, which
  § 10 excludes; recency because the list exists to go back to what was just watched; no removal
  because aging out does the work and `docs/DESIGN.md` § Components "The menu" draws no per-row
  control); **(c)** a history that stops silently presents a partial history as whole, which
  UX-I4's *"stale content is never presented as current"* forbids; **(d)** a broken-image glyph
  is a surface the product did not draw and a state it never established (UX-I13).

  **Seven additions, each changing what the fold lands.** *(1) One row, not two* — overriding the
  seat's own lean in its point (4). UX-S4 becomes the *Startup surface* with the cancelled panel
  as its Empty cell, rather than a new row beside a *Startup failure* row. § 6 says its rows are
  surfaces, and RN-27(a) already refused a row per state for the plain folder because *"a row
  would name a screen the product does not have"*; two rows for one startup surface is that
  shape. The cost is a re-titled row that `docs/CONTENT.md` § Traceability and `docs/DESIGN.md`
  cite by label; both cite the ID too, and both are owed a round for the new states regardless.
  *(2) The [OPEN] closes.* The item said where the startup surface renders *"stays in § Open
  Questions either way"*. It does not: the question's own text names its closing condition —
  *"Settled by `docs/SDD.md` when it fixes the start mechanism"* — and the SDD fixed it as the
  system Open panel with UX-S4 in the app's window, owner-confirmed (`docs/SDD.md` § 4 C-R3;
  `docs/trail/sdd/cycle-1.md` § 2.3). Drawing (a) depends on it: a surface with two routes is a
  window's, not a terminal line's. RN-11's `terminal-no-color-no-tty` clause and RN-20's
  handed-forward seam close with it. *(3) In-folder images render* — check 2's "argument right and
  incomplete": (d) names the failure of an in-folder image, and UX-I12 has never said an in-folder
  image loads at all; the owner overrode the SDD's draft to load them
  (`docs/trail/sdd/cycle-1.md` § 2.4) and this document is silent. UX-I12 gains all three cases,
  and "remote" reads "outside the folder", which is what `docs/CONTENT.md`'s sentence already says
  (*"KA-Reader fetches nothing from outside this folder"*). *(4) The Git view carries an entry for the
  history* — `docs/SDD.md` S-8 opens the history *"by the entry the Git view carries for it"* and
  `docs/DESIGN.md` § Components draws `clock` for it; the UXD says only *"reached from the Git
  view"*, which does not say how. *(5) The row never falls back* — SRS FR-13 and FDR R-70 both
  state it, and check 4's absent case (a diff that cannot be produced) needs it: UX-S5's failure
  cell takes the diff, the file stays readable from the tree. The per-row cases (staged and
  modified, untracked, conflicted) stay at the FDR's altitude, as the SRS run also ruled.
  *(6) The short status is carried, not pointed at* — the item offered UX-S3 *"carry or point
  at"* it; the UXD may not point at the FDR, so the cell states what the status says, the words
  `docs/CONTENT.md`'s (its UX-S3 mid-operation row already routes them to *Voice*). The rebase
  case is named uncovered, as the FDR named it. *(7) The selector's first run* — the one genuine
  collision check 3 found. The owner's directive reads *"On first run the list is empty and only
  the browse entry is there"* (`docs/ux_reference/README.md` § Owner directives 2; UX-S7 Empty,
  RN-15), `docs/DESIGN.md` § Components "The menu" repeats it and also draws a *current item*,
  and the FDR's answer lists the current folder *"among them and marked"*. All three hold at once
  only if "first run" is the state before any folder has been viewed — which, beyond v1, is the
  startup surface's selector — and from the first folder viewed the list holds it, marked. That
  is what the answer says, and it is the close call: if the owner meant the workbench's first
  opening, the current folder is omitted from the list and "marked" is the selector's label
  alone — one sentence on the fold. It is decided here rather than left because it reconciles an
  owner's words with a run's, binds nothing outside this document, and the owner's directive's
  letter is kept for the state it describes.

  **Check 4, walked.** Empty: no commits (UX-S6 Empty stands); no remembered folders (UX-S7
  Empty, re-read); no folder chosen (the new cell). Absent: a diff that cannot be produced (5);
  a remembered folder gone (UX-S7 Error stands — the Error cell already reuses UX-S4's language,
  and the answer keeps stale entries listed until they age out so a folder on an unmounted volume
  does not flicker in and out). Stale: the history's loaded end while commits arrive — the live
  refresh (UX-F3) redraws, unchanged. Concurrent: the panel dismissed twice — the same surface,
  stated. Refused: the person declines the panel — that is (a), and it is not a failure, so
  UX-I14 does not bind it and no failure sentence is written.

  **What is not opened, and why.** `docs/CONTENT.md` (Settled, no companion) and
  `docs/DESIGN.md` (companion live at § 2.1) are each owed a round *after* the fold: sentences
  for the cancelled-panel surface, the stated history end, the in-folder image placeholder and
  the short status; the drawing of the startup surface's empty state and of the marked selector
  entry. Neither is opened now. The prompt's ground is *"something upstream moved and it has not
  seen it"*, and upstream has not moved yet — a Content Editor or `product-design` run reading an
  item today would find no settled UXD text to write to. The close call was to open them
  contingent on the fold, the way this very item was opened contingent on the FDR's; what tipped
  it is that the FDR's contingency was a fold of answers already written, while here the text
  does not exist. The fold's own review note is asked to record both debts so the next run that
  reads the UXD raises them. `docs/PRD.md` is not reopened (above). Nothing is raised on the
  UXD beyond this item: the two further defects reading it whole found — UX-I12's silence on
  in-folder images, the closable [OPEN] — sit inside entries this item already revises, and a
  second item would be the near-duplicate the skill forbids.

## Left for the owner

None this run.

## Skipped

None this run. The companion carries one item and one slot; the item was open and is answered.

## Companions opened

None this run.

## Launchers owed

- **`docs/UXD.md`** — `/Users/eyalgolan/projects/kensai/kensaiapp-dev/core/launchers/product-uxd/launcher.sh ka-reader`
