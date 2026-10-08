# Self-answer report — `docs/SDD.md`

## Header

- **Companion:** `docs/SDD_open_issues.md`
- **Document:** `docs/SDD.md` (v36, Settled)
- **Decided by:** `<CORE>/../skills/companion/.claude/skills/companion-self-answer/prompts/rich.md` v1.3.1
- **Date:** 2026-10-04
- **Sources re-read:** None. The answer rests on files in this repository alone. It names no
  AppKit mechanism for drawing the fill, so no platform documentation was relied on.

**What this run read, and what it did not.** The companion was read whole. Of `docs/SDD.md`
(6,328 lines) the run read the header and version lines, *Who holds what, inside one run*
(`:L87-L138`), § 6 S-1 to S-5 (`:L1491-L1950`), SDD Review Notes RN-95's tail and RN-96
(`:L6040-L6221`), and *Open Questions* (`:L6223-L6328`). It searched the rest for `selection` and
`selected` and read § 5 step 4's sentence at `:L1329` and § 4 C-E2 at `:L1016-L1019`. The other
sections were not read, so a sentence there that speaks of the Git view's selected row in other
words was not seen. `docs/DESIGN.md` was read at `:L556-L645`, at its tokens `:L161-L173`, and at
RN-39 and RN-40 (`:L1662-L1710`). `docs/UXD.md`, `docs/SRS.md` and `docs/PRD.md` were searched for
`selected` and `selection` and read at the lines that search printed. The shell was read at
`ka-reader-mac/Sources/Surfaces/BarRowView.swift` whole, `GitView.swift:L36-L60` and `:L150-L270`,
`WorkbenchView.swift:L150-L168` and `ka-reader-mac/Tests/SurfacesTests/GitViewHoverTests.swift:L170-L196`,
all at `ka-reader@6cf1014`.

## Items worked

### 5.1 — No slice delivers the selection fill on the Git view's selected file row, and S-4's case names one

- **Bucket:** 5. Raised from downstream — an item from a seat that did not write the SDD
- **Verdict:** answered
- **Why:** The Git view's selection fill goes into `see-git-status` (S-4), in *Reached when* and
  *Rests on*. The observable half gains one sentence, the command half gains one case, and the
  `surfaces` parenthesis in *Rests on* gains the fill. *Delivers* does not move, no slice is added,
  and § 10 gains no entry.

  **Whose item it is (check 1).** The change lands in `docs/SDD.md` § 6, which is the document
  this companion belongs to. The item carries `Seat: cto`. The sentence in the observable half is
  the CDO's clause by the SDD's own table (`docs/SDD.md:L113`). It is written here on the same
  ground RN-96 used for the hover fill (`docs/SDD.md:L6135-L6145`): `docs/DESIGN.md`, which is
  Settled (`:L301`), already states the drawing, so the clause leaves the CDO no call to make.
  The answer commits nothing to a person or an outside party, and this run can name no ground it
  cannot see. The item is answered in its slot.

  **Is it a widening with no occurrence?** No. The item sits under *Raised from downstream* and
  asks the SDD to state a drawing no slice states, which is a widening. It cites the site: the Git
  view's selection sets `drawsBar` and nothing else
  (`ka-reader-mac/Sources/Surfaces/GitView.swift:L190-L194`). That is a path and line where the form
  is present in the product as it stands, so the form is taken.

  **The item's framing holds (check 2).** Each fact it gives was re-measured at `ka-reader@6cf1014`.
  `grep -rn isSelected ka-reader-mac/Sources` prints one line, `BarRowView.swift:36`, which reads the
  flag and marks no Git-view row selected. `docs/SDD.md:L1844-L1845` holds the case "the selected
  row under the pointer keeps its selection fill and its bar". S-4's observable half names no
  selected row at all; the only observable sentence about a selected row is S-2's, and it is about
  the tree (`docs/SDD.md:L1641`). One fact in the item has drifted and is reported under *Skipped*
  below: its `docs/DESIGN.md` line numbers.

  **Why S-4, and why not *Delivers*.** This is reasoning. The Git view's file row is first drawn
  and first clickable in `see-git-status`, and RN-95 and RN-96 each placed a row's drawing in the
  slice that first draws the row. *Delivers* states what a developer can do after the slice. The
  fill shows which row is open and adds nothing they can do, which is the reason RN-96 gave for
  leaving *Delivers* alone (`docs/SDD.md:L6154-L6156`). *Delivers* is also the CPO's field
  (`docs/SDD.md:L111`), and nothing here needs it to move. The item's first fold named *Delivers*
  and *Reached when*; the answer takes the *Reached when* half and says why the other is left.

  **Why not the second fold.** The item's alternative reads S-4's case as "the bar kept and no
  hover fill" and leaves the fill to a later slice. `docs/DESIGN.md` § *Components*, "Rows", makes
  `{components.tree-row}` "every list row in the product", names "the Git view's changed and
  staged files", and says "The selected row is `{components.tree-row-selected}` with the left
  bar" (`:L613-L619`). It also says "The selected row keeps `{colors.selection}` and its bar under
  the pointer" (`:L634-L635`). The second fold has the SDD hold less than the design language it
  cites, with no record of why. The later slice it leaves the fill to would be a slice whose only
  decision is a drawing, and § 5 step 4 says § 6 holds none (`docs/SDD.md:L1329`).

  **Against the settled record (check 3).** No requirement moves. `docs/SRS.md` FR-7 is about the
  tree (`:L144-L145`) and is untouched. `docs/UXD.md` UX-A2 asks that "the selected file" carry a
  cue that survives without colour; the bar is that cue (`docs/DESIGN.md:L574-L577`), and the
  added observable sentence says so. S-1's and S-2's words stand. RN-96's sentence that "S-4's
  selected-row case has a row to test" (`docs/SDD.md:L6185-L6186`) stays true: the row exists, and
  what it lacked was the fill. The prior answer on this companion's last round
  (`docs/trail/sdd/self_answer-43.md`) gave S-4 "the same cases" as S-1, which carried the tree's
  selected-row case into a view whose selected row had no fill. This answer adds to that one and
  reverses nothing in it.

  **On the failure paths (check 4).**
  - *Empty.* A clean repository or a plain folder draws no file row, so there is no selected row
    and nothing is drawn. The answer needs no sentence for it.
  - *Absent.* A row for a deleted file, or for a file that cannot be read, is still a row a click
    acts on. The clicked row is drawn selected whatever the read answers, the same rule
    `docs/DESIGN.md` RN-39 gives for the hover fill (`:L1662-L1684`). The added case is written on
    the click, not on the read.
  - *Stale.* In `see-git-status` the Git view shows the state read when the folder opened, so no
    refresh moves a row there. A refresh that moves or removes the selected row is
    `follow-the-folder`'s. § 4 C-E2 holds "the open file" through every refresh
    (`docs/SDD.md:L1016-L1019`) and does not name the Git view's selected row in those words. The
    answer adds no sentence to `follow-the-folder` and names the case as not covered.
  - *Concurrent.* One file can have a row in both lists. The shell selects by row index, so the
    clicked row alone is drawn selected (`GitView.swift:L56`, `:L190-L194`), and the answer's
    "the clicked row" matches that. `docs/DESIGN.md` does not state it. Named as not covered.
  - *Refused.* Nothing in this drawing can be refused.

  Two more cases are named and not covered. The shell clears the Git view's selection when a file
  is selected from the tree (`ka-reader-mac/Sources/Surfaces/WorkbenchView.swift:L161-L165`), so a
  Git-view row is drawn selected only after a click in the Git view; `docs/DESIGN.md` does not
  say whether that is the rule. And `docs/DESIGN.md` RN-40 already names as not covered what the
  selected row's fill and bar do in a window that is not the key window (`:L1706-L1708`). Both are
  the CDO's, in `docs/DESIGN.md`. This run opened no item on that document: none of the three is
  a false fact, an unseen upstream change or a contradiction between two settled documents, and
  the answer turns on none of them.

  **What the built shell shows.** At `ka-reader@6cf1014` the Git view's selected row draws the bar
  alone. The shell's test for the existing S-4 case is named
  `test_hover_s4_selected_row_under_pointer_keeps_selected_drawing_and_bar` and asserts that the
  row's image is the same with the pointer over it as with the pointer elsewhere
  (`ka-reader-mac/Tests/SurfacesTests/GitViewHoverTests.swift:L178-L194`). That passes with no fill
  drawn, so the case as the SDD words it is held by a test that does not check a fill. The added
  case closes that: it asserts the fill with the pointer away. On this bar `see-git-status` is not
  reached on `main`, and what that means for work in flight is the PM's.

  **Downstream, not raised.** `grep -n -i 'hover\|selection fill' docs/nfdr.md` and
  `grep -n -i hover docs/fdr.md` each print nothing, so neither document restates the S-4 cases
  this answer adds to. No companion was opened on either.

  **What would have tipped it.** Had `docs/DESIGN.md` limited the selection fill to the tree, the
  second fold would have been the answer. § *Shapes* does say "The selected tree row is
  `{colors.selection}` edge to edge" (`:L574`), which read alone points that way. "Rows" names the
  Git view's file rows as the same component and gives the selected row the fill, and this answer
  reads the two together. A reader who takes § *Shapes* alone reaches the second fold, and that
  reading is the CDO's to settle in `docs/DESIGN.md`.

## Left for the owner

None this run.

## Skipped

- **5.1 — the item's `docs/DESIGN.md` line numbers** — the item's supporting text is stale by
  line, reported and not edited. `docs/DESIGN.md` moved to v18 at `ka-reader@6cf1014` after the item
  was written at `ka-reader@7c1acad`. The lines the item cites as `:L612-L618` are now `:L613-L619`,
  and `:L624-L625` are now `:L634-L635`. The quoted words stand, and the item was answered. The
  correction is `product-sdd`'s to carry into the fold.

## Companions opened

None this run.

## Launchers owed

- **`docs/SDD.md`** — `<CORE>/launchers/skill/launcher.sh product-sdd ka-reader`
