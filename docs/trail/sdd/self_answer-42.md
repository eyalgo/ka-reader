# Self-answer report — `docs/SDD.md`

## Header

- **Companion:** `docs/SDD_open_issues.md`
- **Document:** `docs/SDD.md` (v34, Settled)
- **Decided by:** `decide_companion_answers.md` v1.3.0
- **Date:** 2026-10-04
- **Sources re-read:** None. Both answers rest on the SDD, on the documents beside it under `docs/`
  and on the product's own tree. Neither rests on a source outside this repository.

**What this run read, and what it did not.** `docs/SDD.md` was not read whole. It is 6,082 lines.
This run read the header and the seat table (`:L1-L145`), § 3 whole (`:L315-L514`), § 4 C-E3 to
C-E10 (`:L1020-L1087`), § 6 S-4 and S-5 whole (`:L1748-L1909`), § 7 (`:L2259-L2308`), § 10's
opening note (`:L2445-L2464`) and RC-5 (`:L2722-L2767`), and SDD Review Notes RN-94
(`:L5893-L5976`). It searched the rest for `tooltip`, `R-38`, `status letter` and `RN-94`. A
sentence elsewhere that speaks of the status letter's expansion in other words was not seen. Of the
other documents it read the lines each answer cites and searched `docs/fdr.md`, `docs/UXD.md`,
`docs/SRS.md`, `docs/PRD.md`, `docs/CONTENT.md` and `docs/DESIGN.md` for `tooltip` and `R-38`;
none was read whole. The companion was read whole. The product was read at `ka-reader@c79b26c`, with
`git status --short` printing nothing.

## Items worked

### 5.1 — § 3 `GitState` says the marker join is built at a commit not on `main`; that commit is now on `main`

- **Bucket:** `## 5. Raised from downstream — an item from a seat that did not write the SDD`
- **Verdict:** confirmed with addition
- **Why:** The item is a correction of a statement measured false, so it is not a widening and it
  takes its fold. It carries a draft, "The likely fold", and the draft holds: the join is on
  `main`, in the shell, under the `surfaces` row's four bounds. The seat is this document's: the
  edit is one sentence of `docs/SDD.md` § 3, a CTO part (`docs/SDD.md:L100`), and it commits
  nothing to anyone outside the document.

  **The measurement.** At `ka-reader@c79b26c`, `git merge-base --is-ancestor 6c49d5c main` exits 0.
  `git merge-base --is-ancestor 6c49d5c 67d103d` exits 0 and the same test against `67d103d^1`
  exits 1, so `67d103d` is the merge that brought the join to `main`, which is the commit the draft
  names. `git diff --stat 6c49d5c main -- ka-reader-mac/Sources/Surfaces/TreeMarkers.swift` prints
  nothing, so the file on `main` is byte for byte the one the SDD cites as built at
  `ka-reader@6c49d5c`.

  **The addition.** The draft names the sentence to change. The answer also names what keeps its
  words, because a fold that swept every mention of "not on `main`" would falsify three true
  statements. The sentence before it (`docs/SDD.md:L502`) is pinned to `ka-reader@b640345` and is true
  of that commit. The `surfaces` row's clause (`docs/SDD.md:L340`) is pinned the same way and says
  "this clause reads the same whether or not it merges". § 10 RC-5's *Observed reality*
  (`docs/SDD.md:L2731-L2736`) is a dated record. The model-side statements also stand:
  `git grep -n marker main -- crates/ka-reader-core/src/folder_model.rs` prints nothing, so the marker
  is still in no change landed in the model, as `docs/SDD.md:L493-L497` says.

  **The four bounds still hold on `main`.** `TreeMarkers.swift:L17-L21` on `main` marks nothing
  for every case but a repository answer, which is bound two. The file is identical to the one
  RN-94 checked, so the other three bounds are as RN-94 read them; this run did not re-derive them.

  **Failure paths.** *Stale:* the new sentence names a merge commit, which is an identity, so it
  stays true as `main` advances. When `follow-the-folder` moves the join into the model, "on `main`
  from `ka-reader@67d103d`" becomes history, and the entity's next sentence already says both pieces
  move by then. *Empty, absent, concurrent, refused:* a one-sentence correction of a fact has none
  of these. **Not covered:** this run built nothing and ran no test on `main`; that the merged join
  works is the merged change's own record, not this answer's.

  What would have tipped it: had the file on `main` differed from the one at `ka-reader@6c49d5c`, the
  four bounds would have needed a fresh read before the sentence could say "under the four bounds".

### 5.2 — No slice delivers `docs/fdr.md` R-38's status-letter expansion, and two surfaces now draw the letters

- **Bucket:** `## 5. Raised from downstream — an item from a seat that did not write the SDD`
- **Verdict:** answered
- **Why:** `see-git-status` delivers the expansion, and the slice is not reached without it. The
  item carries no draft, so it is answered from scratch.

  **It widens the SDD, and it cites its occurrence.** The item asks the SDD to state something it
  does not state now, so the prompt's rule for a widening item applies: it takes a change only
  where an occurrence is cited. The item cites two sites in the product where the letters are drawn
  with nothing expanding them, and this run opened both: `ka-reader-mac/Sources/Surfaces/GitView.swift:L24`
  ("The letter is a label and the view raises no tooltip") and `RootItemsView.swift:L236` (the
  tree row's status letter). `grep -rn -i tooltip ka-reader-mac/Sources` prints two lines, both
  comments saying none is raised. The form occurs, so the item takes its change.

  **It is two questions, and both have the same seat.** Which slice delivers the expansion, and
  whether `see-git-status` is reached without it. The second follows from the first: a slice is
  reached when its *Reached when* holds, so once the expansion is in that slice the answer is no.
  Both edits land in `docs/SDD.md` and commit nothing to a person or an outside party, so both are
  answered in the one slot and the item does not split.

  **What is settled, and where.** The owner put the tooltip in v1: `docs/DESIGN.md:L990-L992`
  quotes "i think that tooltips should be included in v1" and records it "as a v1 decision rather
  than a one-off exception". The v1 cut ends at `follow-the-folder`: `docs/SDD.md:L1908`, "it is
  the last of the v1 cut". `docs/fdr.md:L93` R-38 requires the behaviour. `docs/CONTENT.md:L422-L426`
  gives the six words and their order, and `docs/DESIGN.md:L644-L656` draws the tooltip and gives
  it one home, "a status letter, wherever one is drawn — the tree and the Git view". The SDD itself
  said it before it was re-authored: `ka-reader@70a879a:docs/SDD.md:L439-L441`, § 4 C-E6, "a status
  letter's expansion is raised by the letter, as the tooltip, and nowhere else". The re-authored
  C-E8 (`docs/SDD.md:L1068-L1075`) dropped that clause, and R-38's trace still points at it. So
  the only open choice is between the two v1 slices that have letters on screen, `see-git-status`
  and `follow-the-folder`.

  **Why `see-git-status`. This is reasoning.** It is the slice that first draws the letters on
  both surfaces (`docs/SDD.md:L1765-L1768`), and `docs/CONTENT.md:L145` says "A single-letter code
  is never the whole of a statement". Nothing technical places the expansion later. The row's name
  and its status category already reach `surfaces` in projections (`GitItem.swift:L56-L61` holds
  the six categories; `GitSentences.swift:L85-L92` maps each to its letter). The words belong in
  the message catalogue, which `surfaces` owns (`docs/SDD.md:L340`). No part, seam or SM-4 call is
  added, so § 7 gains no edge. Placing it in `follow-the-folder` would attach it to the hardest
  slice in the cut for no dependency. A slice of its own would deliver a tooltip with no letter to
  rest on.

  **Check 3, against the settled record.** The tooltip is raised by pointer rest and not by a
  click, so S-4's "one click target, the status letter a label" stands (`docs/SDD.md:L1768`;
  `docs/DESIGN.md:L1630`). C-E6 stands: a plain folder draws no letter, so nothing raises a
  tooltip there. C-E3's "no control reveals, expands or copies its detail" speaks of a fault's
  detail, and a status letter is not a fault (`docs/SDD.md:L1022-L1023`). The row order and the
  marker join that item 5.1 and RN-94 speak of are untouched, and this answer does not contradict
  the 5.1 answer given earlier in this pass.

  **Check 4, the failure paths.** *Empty:* a clean repository and a plain folder draw no letter,
  so there is nothing to rest on. *Absent:* a failed or stopped Git item draws no letter, and a
  letter is drawn only from an observed answer, so a tooltip never states a status the tool did not
  read. *Stale:* `docs/DESIGN.md:L651-L652` has the tooltip leave when "a refresh changes the
  row's state". `see-git-status` shows the state read when the folder opened
  (`docs/SDD.md:L1829-L1830`), so no refresh can change a row there, and that half is first
  observable in `follow-the-folder`; the answer says so. *Concurrent:* the tooltip stacks with the
  row's hover fill, which `docs/DESIGN.md:L653-L654` settles. *Refused:* nothing here asks the
  reader or the system for anything. **Not covered:** a row name longer than the sidebar is wide.
  `docs/DESIGN.md:L650` says "one line, never wrapped" and nothing says what is cut; that is the
  design language's, and this run raised no item on it because it cited no site where it occurs.
  Folder rows are covered by `docs/CONTENT.md:L424-L428`, which this run read and did not test.

  **The columns.** The fold lands in three seats' columns of `docs/SDD.md:L96-L123`: *Delivers*
  is the CPO's, the observable half and § 4's experience conditions are the CDO's, and *Rests on*
  and the command half are the CTO's. The item carries `Seat: cto`, and this run answered it whole
  rather than leave two thirds of it open, because every part of the answer in the other two
  columns restates a decision already recorded in another settled document. The answer tells the
  fold to send back, under the right `Seat:`, any call in those columns that those documents do not
  settle.

  **No § 10 entry, and this was close.** The section's four triggers are at
  `docs/SDD.md:L2452-L2454`. S-4's *Reached when* can be met as written, no slice became a
  fragment, a slice can still be started, and the PRD, the SRS and the UXD did not change. The
  change adds to a slice's *Delivers* and *Reached when*, which looks like a re-cut. What tipped it
  is that nothing the cut assumed was contradicted by the build: a clause the earlier SDD carried
  was lost in re-authoring. A fold that reads the triggers differently writes the entry.

  **Downstream, not raised.** After the fold, `docs/nfdr.md` may restate S-4's command half without
  the new case. That is the Principal Architect's, and it does not exist until the fold is made, so
  this run opened no item on it.

  **A limit of the item's supporting text.** It cites `RootItemsView.swift:L208` as a place the
  letters are drawn. That line declares the letter's identifier; the label is at `:L236`. The
  finding stands.

## Left for the owner

None this run.

## Skipped

None this run.

## Companions opened

None this run.

## Launchers owed

- **`docs/SDD.md`** — `<CORE>/launchers/skill/launcher.sh product-sdd ka-reader`
