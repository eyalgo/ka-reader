# Self-answer report — `docs/SDD.md`

## Header

- **Companion:** `docs/SDD_open_issues.md`
- **Document:** `docs/SDD.md` (v33, Settled)
- **Decided by:** `decide_companion_answers.md` v1.3.0
- **Date:** 2026-10-04
- **Sources re-read:** None. Both answers rest on the SDD, on the product's own tree and on the
  change's records in the instance. Neither rests on a source outside these repositories.

**What this run read, and what it did not.** `docs/SDD.md` was not read whole. It is 5,934 lines.
This run read the header and the seat table (`:L1-L144`), § 2 and § 3 whole (`:L204-L505`), § 4
C-I1 (`:L705-L722`) and C-E1 (`:L991-L1001`), § 6 S-4 and S-5 whole (`:L1738-L1891`), § 7
(`:L2241-L2289`) and § 10 RC-4 (`:L2635-L2702`). It searched the rest for `marker`, `row order`,
`GitRowOrder`, `order key`, `CP-581`, `CP-585` and `model_changed`. A sentence elsewhere that
gives the marker or the row order an owner in other words was not seen. `docs/PRD.md`,
`docs/SRS.md` and `docs/UXD.md` were not opened: the answers move no requirement and no
experience entry. `docs/fdr.md` was searched for `marker` and `order`. `docs/nfdr.md` and
`docs/adr/` were searched for `TreeEntry`, `changed marker`, `changed-file marker`,
`no state the bridge did not send`, `row order`, `GitRowOrder` and `TreeMarkers`, and
`docs/nfdr.md` for `marker`.

**The change's records.** Read in the instance repository
`/Users/eyalgolan/projects/kensai/kensaiapp-opensource`, at commit `8f2c5f1` on the branch
`2026-10-04_the-tree-marks-what-changed`, under
`system/projects/nozoki/journey/tobiishi/2026-10-04_the-tree-marks-what-changed/`:
`code-integrity-report.md` whole, `change_design.md:L150-L260`, and the rules CP-573 to CP-585 of
`change_spec.md`. `change_request.md` was read on the instance's `main`. The sealed change's report
was read at
`system/projects/nozoki/journey/tobiishi/trail/2026-10-04_the-shell-shows-git/code-integrity-report.md:L155-L168`.

**What this run measured**, on the product tree at `nozoki@6a51cbc` (`main`):

- `git show 6c49d5c:nozoki-mac/Sources/Surfaces/TreeMarkers.swift` prints the 68-line join. The
  file is not on `main`: `ls nozoki-mac/Sources/Surfaces/TreeMarkers.swift` prints "No such file
  or directory", and `git merge-base --is-ancestor 6c49d5c HEAD` fails.
- `nozoki-mac/Sources/Surfaces/GitRowOrder.swift` is on `main`, and
  `git merge-base --is-ancestor d65eec4 HEAD` succeeds.
- `grep -rn model_changed crates nozoki-mac/Sources` prints nothing.
- `grep -n marker crates/nozoki-core/src/folder_model.rs` prints nothing.
- `crates/nozoki-core/src/git_reader.rs:L121` reads "The two lists a status read answers. Neither
  carries a count, and no order is promised."
- `crates/nozoki-bridge/src/session.rs:L279-L280` reads "The bridge carries the core's item and
  decides nothing: no count, wording or sort key crosses (CP-543)."
- No test and no build was run. The answers place logic and do not judge whether it works. The
  code-integrity report gives the gate as green (`code-integrity-report.md`, § *What was
  reviewed*), and this run did not repeat it.

## Items worked

### 5.1 — Which part owns the tree's changed-file marker: `folder-model`, as § 3 says, or `surfaces`, where the change built it?

- **Bucket:** 5. Raised from downstream — an item from a seat that did not write the SDD
- **Verdict:** answered
- **Why:** The item carries no lean ("The owner recorded no lean and asked the SDD's seat to
  decide"), so it was answered from scratch. `folder-model` owns the marker, and the SDD keeps
  saying so. For `see-git-status` alone the join stands in `surfaces`, as a placement the SDD
  states with four bounds and an end in `follow-the-folder`.

  **Whose it is.** The item's `Seat:` is `cto`. Every sentence the answer moves is in the CTO's
  column of the SDD's seat table: § 3, § 6 *Rests on*, the command half of § 6 *Reached when*,
  and § 10 where the CTO's ground moved (`docs/SDD.md:L95-L131`). It was asked whether this is the
  owner's, because the rule that stopped the step is the owner's 2026-10-01 ruling
  (`code-integrity-report.md`, § *Calls made*, "Whose"). It is not. The answer leaves that rule as
  it is and changes what the parts table says, which is the SDD's, and the owner asked this seat
  to do that. It was also asked whether lifting the `crates/` bar is this seat's. It is not: the
  bar is the change request's (`change_request.md`, "`crates/` and `checks/deps.allow` must not
  change"), and the answer does not lift it.

  **Not a widening.** The item asks the SDD to choose between what it states and what a change
  built. It cites the occurrence: `TreeMarkers.swift` at `nozoki@6c49d5c`.

  **Why `folder-model` stays the owner.** Three reasons, each from the SDD or the code.
  1. The shape the SDD took is "an AppKit shell that draws the model's projections"
     (`docs/SDD.md:L266`), and `folder-model`'s *Owns* includes "the projections the surfaces
     draw" (`:L333`). Which row carries which letter is a projection: it is computed from the
     tree and the Git state, both of which the model holds.
  2. A rule placed in the shell is out of the harness's reach. The harness calls the model
     directly, "in-process, with no window" (SM-5, `:L429`), and S-5's command half proves a
     moving folder by comparing "the model's final snapshot" with a fresh open (`:L1855-L1856`).
     S-5 also promises that "the tree's markers follow" (`:L1845-L1846`). A marker that exists
     only in Swift is not in that snapshot.
  3. The join's own header shows the cost of the language. It keys on bytes "because Swift's
     `String` equality and hashing fold canonically equivalent spellings together"
     (`TreeMarkers.swift:L5-L8`, at `nozoki@6c49d5c`). The core compares paths as it reads them
     and needs no such guard.

  **Why the join still stands in `surfaces` for this slice.** Three reasons.
  1. No path from the core reaches a row the tree has already drawn.
     `grep -rn model_changed crates nozoki-mac/Sources` prints nothing, and § 10 RC-4 holds that
     registration back to `follow-the-folder` on purpose: a callback "adds a function pointer, a
     context lifetime and a second thread to the one unit that holds `unsafe`"
     (`docs/SDD.md:L2677-L2680`). The spec requires that rows "already drawn when that answer
     arrives are marked from that moment" (CP-575), and that the tree "asks for nothing"
     (CP-581).
  2. Building the marker in the core now would need an interim crossing, for example a changed
     `read_git` answer or a re-asked `list_tree`. `follow-the-folder` then replaces that crossing
     with the callback's delta. The work thrown away would be on SM-4, the C ABI. Under this
     answer the work thrown away is one 68-line Swift file that the design calls "one place,
     reversible" (`change_design.md`, ARN 1, third bullet).
  3. The join stays inside what the wall and the view rules protect. It reads nothing, asks
     nothing and marks only from a repository answer (`TreeMarkers.swift:L18-L25`). So § 4 C-I1's
     "No surface draws a marker … from an item that is not `observed`" (`docs/SDD.md:L719-L720`)
     and C-E1 (`:L991`) hold.

  **Why the answer asks for an end a build can check.** "Until `follow-the-folder`" written only
  in § 3 is a promise nobody is made to keep. S-5's *Rests on* and command half are this seat's, so
  the debt goes there: the slice cannot be claimed reached while the shell still joins. This is
  the part of the answer nearest to drafting the SDD's words, and the fold may word it
  differently. What it may not do is state the placement with no end.

  **Why a § 10 entry.** S-4's *Rests on* says "`folder-model` (`kind` resolved; `GitState`; the
  tree's markers)" (`:L1802-L1803`). The build contradicts that, and the SDD's own header says
  "When the build contradicts the cut, § 10 records the contradiction before the cut is redrawn"
  (`:L78-L80`).

  **Against the settled record.**
  - The `surfaces` row says it draws "no state the bridge did not send, with **one exception**"
    (`:L339`). The answer does not add a second exception to that rule. Both inputs of the join
    are projections the bridge sent, and the clause is a dated placement of logic. This matters
    for `docs/nfdr.md:L1291`, which reads "A view is drawn from a projection and from nothing
    else — read with the one exception `docs/SDD.md` § 3's `surfaces` row names". That sentence
    stays true, so no item is raised on the records' companion. The searches listed in the
    header found no other record that quotes the sentences this answer moves.
  - SM-8 says "a surface never holds a path it did not receive in a projection" (`:L432`). The
    join holds the Git item's listed paths, which arrived in a projection.
  - The `GitState` sentence says the marker is "in no landed change" (`:L492-L496`). That is
    still true on `main`. The answer asks the fold for wording that is true before and after the
    change merges.
  - § 7 places `first-public-release` after `follow-the-folder`, as "the owner's decided
    ordering" (`:L2278-L2280`). So no public release ships with the join in the shell.

  **On the failure paths.**
  - *Empty:* a repository answer with empty lists marks nothing. A folder where Git was never
    shown is never asked, so nothing is marked (CP-581). That second case is the spec's, and the
    answer does not move it.
  - *Absent:* `pending`, `plain`, `failed` and `stopped` mark nothing (`TreeMarkers.swift:L18-L22`).
  - *Stale:* in this slice the Git item is read once after each open and is not re-read
    (`docs/SDD.md:L2690-L2693`), so the held item cannot go stale against itself. It can go stale
    against the disk, which is what S-4's *Not in this slice* already says (`:L1818-L1819`).
  - *Concurrent:* which side orders two asks in flight is open in the SDD (`:L2683-L2684`). The
    join adds no ask, so it adds nothing to that question.
  - *Refused:* `follow-the-folder`'s design may find that the delta cannot carry the marker. Then
    the new command clause stays red and the slice is not reached. That is a re-cut under § 10,
    and it is the stop that brings the question back here.
  - *Not covered:* the SDD does not say what happens if `follow-the-folder` is re-cut or
    re-ordered. The bound names the slice, so a re-cut of the slice owes the bound a new end.

  **What this answer does not decide.** It does not say that a design may move logic out of its
  owning part by naming another one. The code-integrity report warned against that reading
  (§ *Calls made*, reading (a)). Here the SDD's seat changed the parts table. A design did not.
  Whether a design that cannot place logic in its owning part must stop before it is built is
  `<CORE>/doctrine/flow/development_flow.md`'s to say, and this run did not read that file beyond
  the report's quote of it.

  **What would have tipped it.** If a core-to-shell path to a drawn row already existed in this
  slice, the answer would be ruling 2: the marker goes into the core now. If a public release
  fell between the two slices, the answer would also be ruling 2, because a stranger would then
  receive a build whose placement the SDD calls temporary.

### 5.2 — The Git view's row order, `GitRowOrder`, already landed in `surfaces` on the same reading. Is it in place?

- **Bucket:** 5. Raised from downstream — an item from a seat that did not write the SDD
- **Verdict:** answered
- **Why:** The item carries no lean, so it was answered from scratch, after § 5.1 and in
  agreement with it. `GitRowOrder` is not in place. The order of the Git lists' rows is part of
  the projection, so `folder-model` owns it. It stands in `surfaces` under the same bounded
  clause as the marker join and leaves the shell no later than `follow-the-folder`.

  **Whose it is.** `Seat:` is `cto`. The change lands in § 3 and in S-5's CTO halves. It commits
  nobody outside the document. When the move is scheduled is the PM's, and the answer says so
  and sets only the latest point.

  **Not a widening without an occurrence.** The item asks § 3 to name an owner it does not name
  now. It cites the occurrence: `GitRowOrder.swift`, on `main` since `nozoki@d65eec4`.

  **Two questions, one seat.** The item asks whether the file is in place and what the SDD
  should write. Both are the CTO's and both are answered in the one slot.

  **Why `folder-model` owns the order.**
  1. The tree's order is already the core's. `list_tree` answers "with its entries in core's
     order" (`crates/nozoki-bridge/src/session.rs:L123-L124`), from `fs-reader`'s `order`
     (`crates/nozoki-core/src/fs_reader.rs:L818-L832`). The Git lists are the other list the
     shell draws, and nothing in the SDD gives a reason for the shell to own one and the core
     the other.
  2. `GitRowOrder` is a second implementation of a rule the core already has. Its header says
     so: "This is the key `fs-reader` orders the tree by …, written out over scalars and bytes"
     (`GitRowOrder.swift:L1-L6`). The SDD's own position on a rule with two callers is SM-7's:
     "the check is its and has one implementation; the two callers do not re-implement it"
     (`docs/SDD.md:L431`).
  3. The core does not order the lists today. `git_reader.rs:L121` says "no order is promised",
     and the bridge sends no sort key (`session.rs:L279-L280`). So the core's snapshot of the Git
     lists is in libgit2's order, and S-5's snapshot comparison (`docs/SDD.md:L1855-L1856`) would
     compare lists whose drawn order the model does not hold.

  **Why it stands until `follow-the-folder`, and may move sooner.** Nothing fails, as the item
  says. The sealed change is not reopened by this answer. Unlike the marker, this move needs no
  new seam: the core sorts the lists, the shell draws them as they arrive, and no answer changes
  its shape. So any change that opens `crates/` may make it. The answer ties the latest point to
  the same slice as the marker so that the `surfaces` row carries one bounded clause with one
  end.

  **Why no § 11 risk.** The item offers "a § 11 risk or later slice". § 11's rule is that a risk
  has a trigger and a response. That rule is taken from the earlier report's quote of it,
  `docs/trail/sdd/self_answer-40.md` § 5.2, and § 11 was not re-read this run. A misplacement with
  a named owner and a named end is a debt on a slice. It is not a risk.

  **The one thing this run could not measure.** I don't know whether the two implementations
  ever order the same names differently. `fs-reader` compares `to_lowercase()` forms in Rust,
  and `GitRowOrder` compares `lowercased()` scalars in Swift. The check that would find out is
  one list of names with non-ASCII letter case, run through both, with the results compared. No
  such test was found or run. The answer does not rest on a divergence. It rests on there being
  two implementations.

  **Against the settled record.** § 5.1's answer and this one were decided in order and agree:
  one clause in the `surfaces` row and one debt on S-5 carry both. CP-582 freezes the Git view's
  rows and "their order" for the open change, and this answer changes no order: it names who
  computes it. `docs/fdr.md` R-30 and R-149 fix the tree's order (`docs/fdr.md:L78-L80`). The
  search of `docs/fdr.md` for `order` found no rule for the Git lists' order, so the answer asks
  the SDD to name the owner and not to restate a rule.

  **On the failure paths.**
  - *Empty:* an empty list has no order to compute.
  - *Absent:* a Git item that is not a repository answer has no lists.
  - *Stale:* the order is a function of the list. Nothing is cached.
  - *Concurrent:* not reached.
  - *Refused:* if the move is never scheduled, the S-5 clause stays red and the slice is not
    reached, as in § 5.1.

  **The sealed record.** The item says the earlier report "treated 'cannot be moved without a
  core change' as 'already in place'". The sealed report's words are "Moving it would be a core
  change, so it is not a placement move" (its `code-integrity-report.md:L161-L164`). This answer
  says the placement was wrong by the parts table as the SDD will now read. It does not touch
  that record.

  **What would have tipped it.** If the SDD or the FDR gave the Git lists' order to the view, as
  a presentation choice, `GitRowOrder` would be in place. Neither does. If a measured divergence
  between the two implementations had been found, the answer would ask for the move in the next
  change that opens `crates/` and would not wait for `follow-the-folder`.

## Left for the owner

None this run.

## Skipped

None this run.

## Companions opened

None this run.

## Launchers owed

- **`docs/SDD.md`** — `<CORE>/launchers/skill/launcher.sh product-sdd nozoki`
