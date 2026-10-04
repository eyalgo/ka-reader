# Self-answer report — DESIGN.md

## Header

- **Companion:** `docs/DESIGN_open_issues.md`
- **Document:** `docs/DESIGN.md`
- **Decided by:** `<CORE>/../skills/companion/.claude/skills/companion-self-answer/prompts/rich.md` v1.3.1
- **Date:** 2026-10-04
- **Sources re-read:** Apple, *NSTableRowView — isEmphasized*, read 2026-10-04 through the page's
  data file
  (<https://developer.apple.com/tutorials/data/documentation/appkit/nstablerowview/isemphasized.json>):
  "When emphasized is true, the view will draw with the alternateSelectedControlColor defined by
  NSColor. When false it will use the secondarySelectedControlColor defined by NSColor." The page
  does not say when AppKit sets the property, and I don't know when it does. § 3.1 relies only on
  the part the page states: both of the table's own selection colours are system colours, so
  neither is a token.

## Items worked

### 3.1 — What the selected row's `{colors.selection}` and bar do in a window that is not the key window

- **Bucket:** 3. Raised from downstream — an item from a seat that did not write the design language
- **Verdict:** answered
- **Why:** The selected row looks the same in either window: the `{colors.selection}` fill edge to
  edge and the `{colors.primary}` bar. This holds in the tree, the Git view and on every other
  selected list row. Nothing dims, nothing is taken away, and a change of key window changes
  nothing on that row.

  *Seat.* This is the design language's own question. The edit lands in `docs/DESIGN.md`
  § Components "Rows". The answer binds only how the window draws. `docs/SDD.md` RN-97 names it the
  CDO's, as case (c) (`docs/SDD.md:L6298-L6299`). I can name no ground I cannot see. The owner's
  hover decision was about which rows take a fill (RN-11, `docs/DESIGN.md:L1021-L1024`), and it
  says nothing about selection or window state. So the item is mine to answer in the owner's seat.

  *Widening.* The item asks the document to state a case it does not state now, so it widens. It
  cites an occurrence. The shell's selected drawing reads no key status
  (`nozoki-mac/Sources/Surfaces/BarRowView.swift:L59-L73`), and the tree's selection is the table's
  own (`:L4-L5`). I read both at `nozoki@9e8a544`, and they say what the item says. So the item is
  answered, not held "until it occurs".

  *Check 2 — the question.* There is no draft. The item lists three readings and no lean, so I
  answered it from scratch. The question is one question with one seat.

  *Why "unchanged".* The key-window rule exists because the hover fill promises that a click acts.
  In a window that is not key, no click is promised to act (RN-40, `docs/DESIGN.md:L1691-L1694`).
  The tooltip leaves for the same reason: the pointer raises it. A selection promises no click. It
  states which item is open, and the reading panel goes on showing that item when the window stops
  being key. Nothing the selection reports has changed. The UXD's motion dial reads "only what
  actually changed changes" (`docs/UXD.md:L42`), and the document's own Don't says "nothing moves
  that did not change" (`docs/DESIGN.md:L885-L887`). So the row does not change.

  *Why not the other two readings.* **The platform's look per surface** draws the tree's selection
  in the table's own colours. Apple's page above names them as `alternateSelectedControlColor` and
  `secondarySelectedControlColor`. Neither is a token. The first Do calls a colour not read from a
  token a defect, and it allows two exceptions, the title bar's ground and the icon
  (`docs/DESIGN.md:L858-L861`). This reading would also let the tree and the Git view differ. RN-2
  was confirmed on the premise that the left bar and one achromatic selection make the selected
  state unambiguous (`docs/DESIGN.md:L933-L934`). Two selection looks would undo that. **Dimming the
  fill while keeping the bar** needs a value for the dimmed fill. The only tone the language has
  between `canvas` and `selection` is `{colors.hover}`, and it holds that slot so that rest, hover
  and selected read as one sequence (RN-22, `docs/DESIGN.md:L1113-L1119`). Drawing the selected row
  in the hover tone in a window that is not key would put the "a click acts" tone on a row in
  exactly the window where RN-40 withdrew that promise. A new token would be a 21st colour, and the
  fallback order's last line is "take the one with fewer elements" (`docs/DESIGN.md:L358-L361`).

  *Check 3.* RN-40 already says the key-window rule "changes nothing for the selected row"
  (`docs/DESIGN.md:L639-L640`), so this answer states the case that sentence implied and closes
  RN-40's *named and not covered* (`:L1706-L1708`). "Selection outranks hover" (`:L634-L635`) and
  "Selection is a fill and a bar" (`:L574-L577`) stand. The § Overview fallback order
  (`:L358-L361`) puts "draw it the way macOS would draw it by default" second. That line does not
  decide here: the first Do excludes the platform's colours, and the first line of the order, "show
  only what the job puts on the surface", draws the same open item in either window. **Decided
  together with § 3.3.** Its answer rests on this one: the selected row keeps its fill, and the
  tooltip still leaves.

  *Check 4.* **Empty:** with no selected row, there is nothing to draw. **Absent:** the application
  in the background, with no window key, is the same case as a window that is not key. **Stale:** a
  read still pending when the window stops being key leaves the selection and the panel's pending
  message as they are. A refresh that moves or removes the selected row is
  `follow-the-folder`'s, case (d) of SDD RN-97 (`docs/SDD.md:L6299-L6302`), and is not covered here.
  **Concurrent:** the pointer resting on the selected row when the window stops being key shows no
  hover fill there anyway, since selection outranks hover. A tooltip shown over it leaves (§ 3.3).
  The window becoming key again changes nothing on the row.

  *Named and not covered — a shell defect, not this document's.* The tree's selected row is drawn
  by the table's own selection. `BarRowView` does not override the table row's selection drawing
  (the whole file, `BarRowView.swift:L1-L74`), and
  `grep -rn selectionHighlightStyle nozoki-mac/Sources` prints nothing. By Apple's page above, that
  drawing uses one of two system colours, and neither is `{colors.selection}`. The tree's selected
  row is therefore outside "Selection is a fill and a bar" in both windows, apart from this item's
  case. The design language is right as it stands, so nothing is raised on it. This is for the
  delivery tier to repair, and this run may not write product source. I don't know which colour the
  tree draws on screen in each window state. The check is to run the app and look at a selected
  tree row with the window key and with it not key.

  *Close to another verdict?* Dimming to `{colors.hover}` was the nearest alternative. It would win
  if the owner wanted the rows themselves to say which window has focus. Nothing on record says
  that.

### 3.2 — Whether a Git-view file row is drawn selected when its file was opened from the tree

- **Bucket:** 3. Raised from downstream — an item from a seat that did not write the design language
- **Verdict:** answered
- **Why:** The Git view's selected row is the row the reader last activated there. A file opened
  any other way, including from the tree, leaves the Git view with no selected row, even where that
  file has a row in the list. This is what the shell draws.

  *Seat.* This is the design language's question. The edit is a clause in § Components "Rows",
  and SDD RN-97 names it the CDO's, as case (a) (`docs/SDD.md:L6294-L6297`). No ground I cannot see
  bears on it.

  *Widening.* The item widens the document and cites an occurrence: the shell clears the Git view's
  selection on every tree selection (`nozoki-mac/Sources/Surfaces/WorkbenchView.swift:L160-L165`),
  read at `nozoki@9e8a544`. So it is answered.

  *Check 2 — the question.* There is no draft. The item gives two readings and no lean, so I
  answered it from scratch. Inside it is SDD RN-97's case (b): which row is selected when one file
  has a row under both *Changes* and *Staged*. That question has the same seat, so the one answer
  covers both: the row the reader clicked, which is the SDD's own sentence (1)
  (`docs/SDD.md:L6297-L6298`).

  *Why "the row activated there".* A Git-view row does not always open what a tree row opens.
  Wherever a diff exists, the row opens that file's diff, and "the file itself is read from the
  tree" (`docs/UXD.md` UX-F2, `:L140-L146`; `docs/SRS.md` FR-13). A Git-view row drawn selected for a
  file opened from the tree would therefore say the diff is open when the file is. A rule that
  showed the row selected only while no diff exists would make the row's look change whenever a
  diff appears. That is a rule the reader cannot see, and an extra case for the fallback order's
  "fewer elements" to strike (`docs/DESIGN.md:L358-L361`). Drawing only the row the reader clicked
  is true in both cases.

  *Check 3.* This agrees with UX-F2's "the open file and their reading position are untouched
  throughout" a switch to Git and back (`docs/UXD.md:L146-L147`). Switching the rail opens nothing,
  so the Git view's selected row survives the switch. A relative link opens its target "exactly as
  a tree selection does" (`docs/UXD.md:L301-L302`), so "any other way" covers it with no clause of
  its own. The answer does not depend on § 3.1 or § 3.3.

  *Check 4.* **Empty:** a clean Git view has no file rows, so nothing is selected. **Absent:** a
  plain folder's Git view shows nothing (UX-I17). **Refused:** a file or diff that cannot be read
  leaves its row selected, and the panel states the failure under the path. The row is the one the
  reader clicked, and the outcome is what the click produced. This is the same reasoning RN-39 gives
  for a failed row (`docs/DESIGN.md:L1669-L1674`). **Concurrent:** the reader opens a file from Git
  and then clicks that same file in the tree. The Git row clears even though the same file stays
  open. This is correct because the tree opened the file and the row would open its diff where one
  exists. **Stale:** a refresh that moves the selected row between lists, or removes it, is
  `follow-the-folder`'s, case (d) of SDD RN-97, and is not covered here.

  *Named and not covered, held "until it occurs".* One form is the mirror case: whether the tree
  draws a file as selected while the reading panel shows that file's diff. It could arise only once a
  diff is drawn, and `grep -rli diff nozoki-mac/Sources` prints nothing. Another is whether opening
  a commit from the history clears a Git file row's selection. No item cites an occurrence of
  either, so neither goes into the fold.

  *Close to another verdict?* No. The other reading fails on the diff case alone.

### 3.3 — What the status letter's tooltip sits over on the selected row, which never takes the hover fill

- **Bucket:** 3. Raised from downstream — an item from a seat that did not write the design language
- **Verdict:** answered
- **Why:** "Its row's fill" means whichever fill the row shows: `{colors.hover}` on a row under the
  pointer, or `{colors.selection}` on the selected row. The selected row raises the tooltip like any
  other row, and the tooltip sits over the selection fill. The tooltip leaves the moment the window
  stops being the key window, on every row. On the selected row the fill and bar stay, and the
  tooltip leaves anyway.

  *Seat.* This is the design language's own sentence. The edit is in § Components "The tooltip",
  and it binds only how the window draws. The item is mine.

  *Correction, not widening.* The item says a sentence of the document reads false on one row:
  "the row shows `{colors.hover}` and the tooltip sits over it" (`docs/DESIGN.md:L681-L682`) against
  "selection outranks hover" (`:L634-L635`). Correcting a statement found false is not widening, so
  the occurrence bar does not apply. The item cites an occurrence anyway. The shell's selected row
  shows no hover (`BarRowView.swift:L59`), and the tooltip reads no selection
  (`grep -n -i select nozoki-mac/Sources/Surfaces/LetterTooltip.swift` prints nothing, run
  2026-10-04).

  *Check 2 — the question.* There is no draft. The item gives two readings and no lean, so I
  answered from scratch. It hides a second question: the tooltip's leaving sentence rests on the
  fill leaving ("it is never shown without its row's fill", `:L683-L684`), and on the selected row
  the fill does not leave (§ 3.1). The second question has the same seat, so it is answered here.

  *Why "whichever fill".* The tooltip has one job: to say the letter's word, because "a single
  letter is not a word, so the view expands it" (`docs/CONTENT.md:L432`). The selected row is the
  file being read, which is the one whose letter the reader is likeliest to ask about. A selected
  row that raised no tooltip would make the tooltip's presence depend on a state unrelated to the
  letter. That is a rule nobody could see, and it would take away the word on exactly that row.

  *Why it still leaves on the selected row.* The tooltip is raised by a pointer rest, and RN-40
  treats it as the pointer's: it leaves with the window's key status and returns only on a fresh
  rest (`docs/DESIGN.md:L1694-L1698`). The selection is not raised by the pointer. The tooltip's own leaving list already names "the window stops being the
  key window" (`:L680`), so this is not a new trigger. Only the sentence giving the reason changes,
  from "at the same moment as that fill" to a rule that holds on every row. "Never shown without its
  row's fill" stays true. On return, the tooltip still waits for a fresh 500ms rest (`:L684-L685`).

  *Check 3.* This answer rests on § 3.1: the selection is unchanged in a window that is not key.
  The two were decided together, and each *why* says so. RN-23's "stacked over the row's hover
  fill" (`:L1130`) is a record, and like RN-29 it keeps the words its decision was made in
  (`:L1326-L1328`); the component sentence is what moves. RN-40's reason for the tooltip leaving, "a
  tooltip left without its fill would make that sentence false" (`:L1695-L1696`), holds for a
  hovered row. The fold should give the pointer-raised reason for the selected row.

  *Check 4.* **Ground:** the tooltip sits below or above the letter, over a neighbouring row. That
  row can be a selected one in any reading, so this case exists already. `{colors.surface}` over
  `{colors.selection}` is a larger step in tone than over `{colors.canvas}` in both themes
  (`#FBFBFA`/`#E2E3DF` against `#F2F2F0`; `#1B1C1E`/`#34363B` against `#232427`,
  `docs/DESIGN.md:L416-L420`), and the hairline bounds it, so "tone and line say *over*" (`:L551-L554`)
  holds. **Stale:** a refresh that changes the row's state removes the tooltip, by the existing rule.
  **Concurrent:** the pointer resting on the selected row's letter when the window stops being key
  removes the tooltip, and the fill and bar stay. **Empty:** a row with no letter raises no tooltip.

  *Close to another verdict?* No. The reading with no tooltip on the selected row was weighed and
  lost on the tooltip's one job.

## Left for the owner

None this run.

## Skipped

None this run.

## Companions opened

None this run.

## Launchers owed

- **docs/DESIGN.md** — `<CORE>/launchers/skill/launcher.sh product-design nozoki`
