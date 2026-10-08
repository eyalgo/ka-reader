# Self-answer report — `docs/SDD.md`

## Header

- **Companion:** `docs/SDD_open_issues.md`
- **Document:** `docs/SDD.md` (v35, Settled)
- **Decided by:** `<CORE>/../skills/companion/.claude/skills/companion-self-answer/prompts/rich.md` v1.3.1
- **Date:** 2026-10-04
- **Sources re-read:** None. The answer rests on the SDD, on `docs/DESIGN.md` beside it and on the
  product's own tree. It rests on no source outside this repository.

**What this run read, and what it did not.** `docs/SDD.md` was not read whole. It is 6,205 lines.
This run read the version line and the seat table (`:L1-L9`, `:L86-L145`), §§ 1 and 2
(`:L147-L314`), the `surfaces` row and SM-8 in § 3 (`:L341`, `:L434`), § 4 C-E1 to C-E10
(`:L995-L1093`), § 5 step 4 (`:L1284-L1414`), §§ 6, 7 and 8 whole (`:L1490-L2370`), and SDD Review
Notes RN-75 and RN-95 (`:L4659-L4690`, `:L5995-L6040`). It searched the rest for `hover`,
`DESIGN.md` and `Components`. The rest of § 3, § 4's runtime and data conditions, §§ 9 to 12 and
the other review notes were not read, and a sentence there that speaks of the pointer in other
words was not seen. In `docs/DESIGN.md` it read the lines each claim below cites and every line
`grep -n -i hover` prints. It searched `docs/UXD.md`, `docs/SRS.md`, `docs/PRD.md`, `docs/fdr.md`,
`docs/nfdr.md` and `docs/CONTENT.md` for `hover`; none was read whole. The companion was read
whole. The product was read at `ka-reader@a7ff3b6`, where `git status --short` printed nothing before
this run wrote.

## Items worked

### 5.1 — No slice delivers the clickable row's hover fill that `DESIGN.md` draws

- **Bucket:** `## 5. Raised from downstream — an item from a seat that did not write the SDD`
- **Verdict:** answered
- **Why:** The fill goes into `open-a-folder` for the tree row and into `see-git-status` for the
  Git view's file row. It gets no slice of its own and changes no *Delivers*. The commit row and
  the menu item are answered "not until it occurs".

  **Why "answered" and not "confirmed".** The item carries a lean, "The likely fold", and the lean
  offers two fills side by side: the slice that owns each row, or one slice of its own. A lean
  that names both alternatives decides nothing, so this run answered from scratch. The answer
  takes the first alternative's *Reached when* half, drops its *Delivers* half, and rejects the
  second alternative.

  **The seat.** Every edit lands in `docs/SDD.md` and commits nothing to a person or an outside
  party, so the item is this document's and the answer is in its slot.

  **The item's measurements hold.** At `ka-reader@a7ff3b6`, `grep -rn -i hover ka-reader-mac/Sources |
  wc -l` prints `0`, and `grep -n -i -c hover` prints `0` for `docs/SDD.md` and for `docs/UXD.md`.
  `docs/DESIGN.md:L618-L626` states the rule the item quotes. The fill is the owner's own
  decision: `docs/DESIGN.md:L1000-L1003` quotes "hovering is something that developers use" and
  scopes it to rows that are clickable. It has been in the design language since
  `ka-reader@95f1279`, dated 2026-08-26.

  **One statement in the item is narrower than it reads.** The item says no slice's *Reached when*
  names the fill. No slice names it by word. `docs/SDD.md:L1533-L1535` has `open-a-folder` hold
  `docs/DESIGN.md` § *Components* "for the surfaces it draws, cited by section and never by
  value", and "Rows" is a paragraph of § *Components* (`docs/DESIGN.md:L612`). That sentence
  entered the SDD at `ka-reader@3f13391`, dated 2026-09-30, after the fill was already in the design
  language. So the tree row's fill is inside S-1's bar as written, and the built shell does not
  meet it. The finding stands and gets stronger for the tree row. No slice holds § *Components*
  for the Git view's file row, so there the gap is the one the item describes.

  **It widens the SDD, and it cites an occurrence for two of the four rows.** The item asks the
  SDD to state something it does not state now, so the prompt's rule for a widening item raised
  from downstream applies. The item cites a measured failure, the `grep` above, against a shell
  "where the tree and the Git view are both built". This run opened both: every tree row is a
  `BarRowView` (`ka-reader-mac/Sources/Surfaces/RootItemsView.swift:L524-L530`), every Git-view file
  row is one (`GitView.swift:L253-L254`), and `BarRowView.swift:L1-L27` draws a bar and no fill
  under the pointer. Those two forms occur and take their change. The item cites no site for a
  commit row or for a menu item. The answer for those two is "not until it occurs", and the SDD
  takes no change for them.

  **Why these two slices. This is reasoning.** Each row's fill goes where the row is first drawn,
  the same placement `docs/SDD.md:L5995-L6040` (RN-95) gave the status letter's tooltip. A slice
  of its own is ruled out by the SDD itself: `docs/SDD.md:L1327-L1330` says § 6 holds no slice
  whose decision is a surface's drawing, and `:L1292-L1293` calls a slice too narrow when its
  result cannot change what happens next. `follow-the-folder` has no claim on it either, since
  nothing about the fill waits on a refresh.

  **Why no *Delivers* changes.** *Delivers* says what a developer can do after the slice
  (`docs/SDD.md:L1507`, `:L1758`). The fill tells them a row can be clicked and adds nothing they
  can do. The tooltip went into S-4's *Delivers* because it shows the letter's meaning, which is
  new information on screen. *Delivers* is the CPO's field (`docs/SDD.md:L110`), and leaving it as
  written makes no call in that column.

  **The other seat's column.** The observable half is the CDO's (`docs/SDD.md:L112`), and the
  item carries `Seat: cto`. This run answered the item whole, because each sentence it asks for in
  that half restates `docs/DESIGN.md:L618-L626` and `:L860-L869`, a settled document of the CDO's
  own. The answer tells the fold to send back, with `Seat: cdo`, any call there that those lines
  leave open. RN-95 records the same handling for the tooltip.

  **Check 3, against the settled record.** One sentence of the SDD does not sit with a
  pointer-driven fill as written. The `surfaces` row says the part "draws projections and draws
  no state the bridge did not send, with **one exception**" (`docs/SDD.md:L341`), and S-1's
  command half tests "that a row is drawn from a projection and from nothing else"
  (`:L1560-L1561`). A fill drawn from where the pointer is comes from neither a projection nor
  that exception. The tooltip folded in v35 is in the same position: it is drawn from a tracking
  area the shell installs (`ka-reader-mac/Sources/Surfaces/LetterTooltip.swift:L143-L146`). So the
  answer asks for one reading clause in the `surfaces` row, which is the CTO's part
  (`docs/SDD.md:L101`). The clause says the pointer's position is the shell's own observation
  and no state of the folder, so the exception count stays at one. That the sentence was written
  about the folder's state is this run's reading, from its own grounds: C-E1 and UX-I13 speak of
  what the tool has observed of the folder (`docs/SDD.md:L1004-L1014`). The rest holds. SM-8's
  intents are unchanged (`:L434`), because a fill raises none. C-E2 holds, because
  `docs/DESIGN.md:L625` gives the fill no transition and `:L1657` says it never fires on an
  update. C-E8 asks that no state distinction rest on hue alone
  (`docs/SDD.md:L1071-L1073`). This run reads the fill as passing it, because the fill marks the
  row the pointer is on, and the pointer's own position says the same thing without colour. That
  is a reading, and the clause is the CDO's. `choose-a-theme` already holds § *Colors* for
  every surface (`docs/SDD.md:L1943-L1944`), and `{colors.hover}` has a value in both themes
  (`docs/DESIGN.md:L420`). The token's value is outside the 1.0.0 contract
  (`docs/SDD.md:L2220-L2223`).

  **The release bars need no edit.** `first-public-release` has every surface behave "as S-1 to
  S-6's observable halves state" (`docs/SDD.md:L1996`), and `promise-one-point-zero` walks S-1 to
  S-10 (`:L2227-L2228`). Once the fill is in S-1 and S-4 it is inside both. `git tag` prints
  nothing at `ka-reader@a7ff3b6`, so no release has shipped without it.

  **No § 10 entry.** The triggers are at `docs/SDD.md:L128-L131`: a *Reached when* that cannot be
  met, a slice that turned out a fragment, no slice that can be started, or an upstream change.
  None holds. The bars can be met, and the PRD, the SRS and the UXD did not move. RN-95 reached
  the same reading for the tooltip. A fold that reads the triggers differently writes the entry.

  **Check 4, the failure paths.** *Empty:* an empty folder draws a status message and a clean
  repository draws no file row, and neither is a row a click acts on, so no fill. *Absent:* a
  pending or failed line is a status message and takes none. *Stale:* rows move under a pointer
  that has not moved when the reader scrolls, expands or collapses. The answer's command half
  names that case, so a fill left behind on a row the pointer is no longer over goes red.
  *Concurrent:* selection outranks the fill (`docs/DESIGN.md:L624-L625`), and the tooltip stacks
  over it (`:L666-L667`). Both are in the answer. *Refused:* a row nothing acts on never takes
  the fill (`:L622-L624`), and both slices get a case for it.

  **Not covered, named.** Four things. First, whether the row of an entry that cannot be read is
  one "a click acts on". `docs/DESIGN.md:L619-L620` gives the rule and this run did not test that
  row against it. Second, a refresh that moves a row under a still pointer. The answer's wording,
  "the row now under the pointer", reaches it, and no sentence is added to `follow-the-folder`,
  because the shell refreshes nothing yet: `TreeMarkers.swift` and `GitRowOrder.swift` are still
  in `ka-reader-mac/Sources/Surfaces/`, which `docs/SDD.md:L1889-L1890` says ends when that slice is
  reached. Third, what the fill does when the window stops being the active one with the pointer
  still over a row. `docs/DESIGN.md` does not say, and that is the design language's to state.
  Fourth, this run built nothing and ran no test.

  **The two rows that wait.** The history and the folder selector are not built.
  `grep -rn -i 'walk_history\|switch_folder\|open_diff' ka-reader-mac/Sources crates` prints two
  lines, both in `crates/ka-reader-bridge/tests/exports.rs` (`:L266`, `:L274`), where
  `ka_reader_open_diff` is a name the test refuses. The only `NSMenu` in the shell is the reading
  panel's text menu (`ka-reader-mac/Sources/Surfaces/CodeView.swift:L130-L155`), which is the
  platform's context menu and not the selector's list. When either surface is built with no fill,
  that is the occurrence, and the PM's refine can raise it then.

  **Downstream, not raised.** After the fold, `docs/nfdr.md` may restate S-1's and S-4's command
  halves without the new cases. That is the Principal Architect's, and it does not exist until
  the fold is made, so this run opened no item on it. `docs/fdr.md` carries no requirement for
  the fill (`grep -n -i -c hover docs/fdr.md` prints `0`). Whether it should is the Principal
  PM's, and it also follows the fold.

  What would have tipped it: had S-1 not already held § *Components* by section, the tree row
  would have stood on the `grep` alone, as the Git row does, and the answer would have been the
  same with a weaker ground. Had the item cited a built commit row or selector menu, those rows
  would have taken the same change.

## Left for the owner

None this run.

## Skipped

None this run.

## Companions opened

None this run.

## Launchers owed

- **`docs/SDD.md`** — `<CORE>/launchers/skill/launcher.sh product-sdd ka-reader`
