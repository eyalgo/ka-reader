# Self-answer report — `docs/SDD.md`

## Header

- **Companion:** `docs/SDD_open_issues.md`
- **Document:** `docs/SDD.md` (v37, Settled)
- **Decided by:** `<CORE>/../skills/companion/.claude/skills/companion-self-answer/prompts/rich.md` v1.3.1
- **Date:** 2026-10-04
- **Sources re-read:** None. The answer rests on files in this repository alone. It names no
  AppKit mechanism for reading the window's key status, so no platform documentation was relied
  on.

**What this run read, and what it did not.** The companion was read whole. `docs/SDD.md` is 6,429
lines and was not read whole. The run read the version lines (`:L1-L30`), *Who holds what, inside
one run* (`:L88-L139`), § 3 whole (`:L318-L518`), RN-96 and RN-97 (`:L6127-L6322`) and *Open
Questions* (`:L6324-L6429`). It searched the rest for `hover`, `tooltip`, `the pointer` and
`key window`, and read what that search printed in § 4 C-E8 (`:L1076-L1084`), § 6 S-1
(`:L1545-L1551`, `:L1566-L1582`, `:L1599-L1602`), § 6 S-4 (`:L1788-L1798`, `:L1842-L1860`) and
§ 6 S-5 (`:L1901-L1906`). The other sections were not read, so a sentence there that speaks of
the window's key status in other words was not seen. `docs/DESIGN.md` was read at `:L625-L645`,
`:L675-L702` and RN-40's opening (`:L1700-L1712`). `docs/UXD.md`, `docs/SRS.md`, `docs/PRD.md`,
`docs/fdr.md`, `docs/nfdr.md` and `docs/CONTENT.md` were searched for `key window` and each count
is 0; their bodies were not read. The shell was read at
`ka-reader-mac/Sources/Surfaces/KeyWindowSource.swift` whole, `RowHover.swift` whole and
`LetterTooltip.swift:L172-L222`, and the test names in `ka-reader-mac/Tests/SurfacesTests/` were
listed, all at `ka-reader@6f92b29`. No test was run.

## Items worked

### 5.1 — § 3 `surfaces` does not name the window's key status, which the hover fill and the tooltip are now drawn from

- **Bucket:** 5. Raised from downstream — an item from a seat that did not write the SDD
- **Verdict:** confirmed with addition
- **Why:** The item's "likely fold" is taken: § 3's `surfaces` row names the window's key status
  beside the pointer, under the same bounds. Three things are added. The same words go into S-1's
  command half, where the § 3 clause is repeated. The hover sentences and cases in S-1 and S-4 are
  stated for a window that is the key window. Each of the two command halves gains the key-window
  cases the shell's suites already hold.

  **Why "confirmed", when the slot is an *Answer* slot.** The item has no draft in the SDD, and
  it carries a lean in its own text: "The likely fold: the window's key status named beside the
  pointer in that sentence". This run treated that lean as a draft and weighed it.

  **Whose item it is (check 1).** The change lands in `docs/SDD.md` § 3, which is the document
  this companion belongs to, and § 3 is the CTO's part (`docs/SDD.md:L103`). The item carries
  `Seat: cto`. The answer binds no person and no outside party, and this run can name no ground
  it cannot see. It is answered in its slot.

  **Is it a widening with no occurrence?** It is a widening, and it cites its occurrence. The
  item sits under *Raised from downstream* and asks § 3 to name an observation it does not name.
  It cites the site: `ka-reader-mac/Sources/Surfaces/KeyWindowSource.swift:L7` and `:L50`. At
  `ka-reader@6f92b29` that file defines the source (`:L7`) and its live value, which asks the
  host's window whether it is the key window (`:L50-L51`). The hover fill is gated on it
  (`RowHover.swift:L52`, `:L81`) and so is the tooltip (`LetterTooltip.swift:L194`, `:L214`). The
  form is present in the product as it stands, so it is taken.

  **The lean holds, and for the reason it gives (check 2).** Each fact was re-measured.
  - The sentence is where the item says it is. `docs/SDD.md:L343` reads "what the pointer is over
    is the shell's own observation of the pointer and is no state of the folder. The clickable
    row's hover fill and the status letter's tooltip are drawn from it". `grep -n -i 'key
    window' docs/SDD.md` prints two lines, `:L6203` and `:L6299`, both inside review notes that
    list it as something not decided. No part's row names it.
  - `docs/DESIGN.md` is Settled (`:L301`) and states the rule: "The fill is drawn only while the
    window is the key window" (`:L640`), and the tooltip leaves when "the window stops being the
    key window" (`:L691`).
  - The three bounds the item claims hold in the code. The key status is not stored: `RowHover`
    keeps a point and a subscription and asks `isKey` again at each resolve
    (`RowHover.swift:L18-L20`, `:L52`). Losing key status un-flags the row and gaining it reads
    the pointer again (`:L69-L78`); neither raises an intent. `LetterTooltip` does the same
    (`LetterTooltip.swift:L176-L191`).
  - The observation stays inside `surfaces`. The three surfaces that hold a source default it to
    the live one themselves (`GitView.swift:L64`, `RootItemsView.swift:L173`,
    `WorkbenchView.swift:L83`), so nothing is handed down SM-8 and that seam's row stays as
    written.

  One phrase of the item is not taken. It calls the key status "the shell's second first-hand
  observation". The row already says the pending gap is "the one thing the shell observes
  first-hand" (`docs/SDD.md:L343`), and RN-96 reads that sentence as "a statement about the
  folder's state" (`:L6167`). Counting the pointer as the first and the key status as the second
  makes that sentence read false. The answer has the clause say what each observation is of, the
  pointer and the window, and give neither a number.

  **The lean is right and incomplete (check 2, continued).** § 3 is not the only place the SDD
  says what the fill is drawn from. Three additions follow, all in this document.
  1. S-1's command half repeats the § 3 clause: "what the pointer is over is the shell's own
     observation and no projection, which is a second reading clause" (`:L1569-L1571`). If § 3
     gains the key status and this does not, the two disagree about what the shell observes.
  2. The hover sentences and cases are written with no condition. S-1: "While the pointer is over
     a tree row that a click acts on, that row and no other shows the fill" (`:L1547-L1549`), and
     the case "a tree row a click acts on shows the fill while the pointer is over it"
     (`:L1577-L1578`). S-4 says the same of the Git view's file row (`:L1794-L1795`,
     `:L1845-L1853`). In a window that is not the key window `docs/DESIGN.md:L640` now says the
     opposite. Each is stated for the key window. The two observable sentences are the CDO's
     clauses (`docs/SDD.md:L114`). They are written here on the ground RN-96 used
     (`:L6142-L6152`): the settled design language already states the rule and leaves that seat no
     call.
  3. The command halves hold four and six hover cases and none for the key window. The shell's
     suites hold them at `ka-reader@6f92b29`: for the tree,
     `ka-reader-mac/Tests/SurfacesTests/RootItemsViewHoverTests.swift:L443`, `:L468`, `:L484` and
     `:L500`; for the Git view, `GitViewHoverTests.swift:L403`, `:L444`, `:L463` and `:L517`. The
     answer adds three cases to each slice and a tooltip case to S-4, which is the slice that
     holds the tooltip (`docs/SDD.md:L1790-L1794`). This run read those tests' names and not their
     bodies, and ran none.

  **Against the settled record (check 3).** No requirement moves: `key window` appears in none of
  `docs/SRS.md`, `docs/UXD.md` and `docs/PRD.md`. The `surfaces` row's *Must not own* cell forbids
  "Filesystem, network or process capability of any kind" (`docs/SDD.md:L343`), and asking a
  window whether it is key is none of those. `mac-shell` owns "the one window" (`:L342`);
  `surfaces` reads one fact about that window and owns nothing of it. RN-96 lists "what the fill
  does when the window stops being the key window" among things the design language does not
  state (`:L6202-L6203`). That was true when written and `docs/DESIGN.md` RN-40 has since stated
  it. RN-96 is a dated note and keeps its words; the fold's own note says what changed. The
  earlier answers on this companion (`docs/trail/sdd/self_answer-43.md`, `self_answer-44.md`)
  gave the two slices their hover cases and the selected row's case. This answer adds a condition
  and cases to those and reverses nothing in them.

  **On the failure paths (check 4).**
  - *Empty.* A surface with no clickable row draws no fill and no tooltip, key or not. The answer
    needs no sentence for it.
  - *Absent.* A surface that is in no window has no window to ask. The shell reads that as not
    key (`KeyWindowSource.swift:L51`), and the answer says so: such a surface draws neither.
  - *Stale.* The key status is asked at each resolve and never kept, so a refresh that arrives
    while the window is not key draws no fill (`RowHover.swift:L52`). The answer's "held across
    no redraw" covers it, and `follow-the-folder` takes no sentence.
  - *Concurrent.* The design has one window (`docs/SDD.md:L342`). While the Open panel or a menu
    is up, which window is key is the platform's answer. The answer says nothing about either
    case and names both as not covered.
  - *Refused.* Nothing in this observation can be refused.

  **Named and not taken.** `docs/DESIGN.md:L645-L648` now says the selected row looks the same
  whether or not the window is key, and the shell holds a test for it
  (`GitViewHoverTests.swift:L574`). The SDD's selected-row sentences cite the design language by
  section and are not made false by the rule, and the selected row is not drawn from the key
  status. That is outside this item's question, and no case is added for it.

  **Downstream, not raised.** `grep -n -i 'observation of the pointer\|hover' docs/nfdr.md
  docs/fdr.md` prints nothing, so neither document restates the clause or the cases. No companion
  was opened on either.

  **What would have tipped it.** The § 3 fold and addition one stand on their own. Additions two
  and three move two slices' bars. Both slices keep their reach on these bars only if the cited
  tests pass, and this run did not run them. A reader who holds that a slice's bar should not
  grow from an item that asked about § 3 alone would take the fold and addition one and leave the
  rest for an item of its own. This run took them together because the unconditioned sentences
  now contradict a settled document the SDD cites.

## Left for the owner

None this run.

## Skipped

- **5.1 — the item's `docs/DESIGN.md` line numbers** — the item's supporting text is stale by
  line, reported and not edited. The item was written at `ka-reader@9e8a544`, and `docs/DESIGN.md`
  moved to v19 at `ka-reader@6f92b29`. The item cites "Rows" at `:L635-L640` and "The tooltip" at
  `:L681-L685`. The key-window rule for the fill is now at `:L640-L645` and for the tooltip at
  `:L690-L700`. The item was answered, and its answer carries the current lines.

## Companions opened

None this run.

## Launchers owed

- **`docs/SDD.md`** — `<CORE>/launchers/skill/launcher.sh product-sdd ka-reader`
