# Self-answer report — DESIGN.md

## Header

- **Companion:** `docs/DESIGN_open_issues.md`
- **Document:** `docs/DESIGN.md`
- **Decided by:** `<CORE>/../skills/companion/.claude/skills/companion-self-answer/prompts/rich.md` v1.3.1
- **Date:** 2026-10-04
- **Sources re-read:** None. No answer this run rests on a source outside this repository. The
  answer rests on `docs/DESIGN.md`, `docs/CONTENT.md`, the shell's source, and the developer's
  closing commit in the instance repository (`kensaiapp-opensource@ad3d7cc`).
- **Inputs read:** DESIGN Settled (read whole) · CONTENT Settled, with a live companion beside it
  (`docs/CONTENT_open_issues.md`, two open items in § 3, neither answered here) · SDD Settled, with a
  live companion beside it (`docs/SDD_open_issues.md` § 5, the hover fill, not this item's)

## Items worked

### 3.1 — Where the tooltip goes when there is no room below the letter, or to its left

- **Bucket:** 3. Raised from downstream — an item from a seat that did not write the design language
- **Verdict:** answered
- **Why:** Each edge gets one rule. **Bottom:** the tooltip goes above the letter when the visible
  part of its surface ends less than the tooltip's height below the letter. **Left:** the tooltip
  is never wider than the space from the surface's visible left edge to the letter's right edge.
  Its line is right-aligned inside it, so a line that is too long loses the start of the name. The
  joining mark and the letter's word always stay whole. The full answer is in the companion's slot.
  I answered from scratch. The item's closing *"the likely fold: a sentence … for each edge"*
  describes where the answer goes, not what it is, so there was no draft to confirm or override.

  **The bar for an item raised from downstream.** The item asks the document to state two cases it
  does not state now, so it widens the document. It cites where each one occurs. The placement site
  is `nozoki-mac/Sources/Surfaces/LetterTooltip.swift:L195-L196`. Read on this run, that line puts
  the tooltip below the letter and right-aligns it, with no other case. The same code also does no
  clamping, so the line covers both edges. The left edge also has a measured failure: the
  developer's closing commit records that *"a 110-point tooltip anchored on a letter at x 52 hangs
  off the host's left edge and the hit test at its centre then falls outside the window"*
  (`kensaiapp-opensource@ad3d7cc`, commit message, Task 2 tests). That measurement was taken in a
  test host, with the letters at x 40 and 100 in the window's own content view. It was not taken in
  the sidebar. The item says *"its host"*, which is accurate. In the product, the same failure needs
  a tooltip wider than the space from the sidebar's left edge to the letter's right edge. The
  sidebar is fixed at 260 points (`docs/DESIGN.md` § Layout), and a file name has no length limit.
  I did not measure a real name in the real sidebar. Where a name crosses that width is a
  measurement this run did not take. With an occurrence cited for both edges, "not until it occurs"
  does not apply.

  **Seat (check 1): mine, in the owner's seat.** The change lands in `docs/DESIGN.md` § Components
  "The tooltip", which already owns where the tooltip goes. `docs/CONTENT.md` gives the design
  language *"what raises it and how it is drawn"* and keeps only *"the two words it carries, and
  their order"* (§ Accessibility of text). The answer commits nothing beyond this document's own
  consistency. I can name no ground I cannot see. The owner's tooltip decision was that a tooltip
  exists and behaves as VS Code's does (`docs/trail/design/cycle-2.md` § 1.1, as quoted at
  `docs/DESIGN.md` RN-23). It said nothing about placement. The item asks a second question, which
  half of the line survives a cut. It has the same seat, because it is a drawing question about the
  same component, so I answered both in the one slot.

  **Check 2: why these rules.** *Bottom:* above is the only other place where the tooltip still
  touches the letter, keeps its right edge on the letter's right edge, and covers one neighbouring
  row, as "below" already does. Moving it sideways would break the right-edge rule that keeps it
  inside the sidebar. *Left:* the right-edge rule is not relaxed. It is the one constraint
  § Components gives a reason for, *"so it never runs past the sidebar"*. So the tooltip can only
  narrow. Once it narrows, the question is which part of the line to keep. The word has to stay
  whole: it is the reason the tooltip exists (*"A single letter is not a word, so the view expands
  it"*, `docs/CONTENT.md` § Accessibility of text). The name is the part that can lose something,
  and CONTENT already says clipping a name *"costs nothing"* (`docs/CONTENT.md:L493-L496`, the layout
  constraint under § Localization). I chose to cut the name's start rather than its end,
  for two reasons. First, a cut at the tooltip's own left edge is visible as a cut, the same way a
  row's cut at its right edge is. A cut in the middle of the line, just before the dash, would join
  a shortened name to the word and read as the whole name. Second, the row clips the name at its
  end (`docs/DESIGN.md` § Typography), so the end is the part the reader has not seen, and the
  tooltip now shows it. Between the row and the tooltip, the reader sees both ends of the name. I
  rejected an ellipsis because the language uses none on a name. § Typography forbids one *"in the
  middle"*, and rows clip with none. Of two treatments that both work, § Overview's order takes the
  one with fewer elements. What would have tipped me towards cutting the end: CONTENT ruling that
  the tooltip's name must be read from its start, which no line in it does.

  **Check 3: the settled record.** The answer leaves these as written: "one line, never wrapped";
  the right edge on the letter's right edge; the 500ms rest; leaving on pointer exit or on a
  refresh; no transition; no shadow; the tokens (`docs/DESIGN.md` § Components "The tooltip",
  § Elevation & Depth). The word order CONTENT owns is kept: name first, word second. The answer
  depends on neither of the two open CONTENT items (`docs/CONTENT_open_issues.md` § 3.1, the joining
  mark; § 3.2, whether the name takes the path type). Whatever mark joins the two halves stays
  whole with the word. Whatever face the name takes, the name is what gets cut. The SDD draws the
  tooltip *"as `docs/DESIGN.md` § Components, 'The tooltip'"* and states no placement of its own
  (`docs/SDD.md:L1076-L1079`). So the shell's placement code will need to change, which is delivery work,
  but no other document will. One sentence in the document has to be read together with this
  answer: § Typography's *"the row clips at its end"*. It governs rows, and the tooltip is not a
  row. The answer asks the fold to say so, so that a later reader does not see the tooltip's
  start-cut as a contradiction.

  **Check 4: failure paths.** *Both edges at once:* the rules are independent, so the tooltip goes
  above and is cut at its start. *No room above or below:* this happens on a surface shorter than
  three rows' worth of height. The language sets no minimum window height. The tooltip stays below
  and is cut, which is the stated default, so nothing new is introduced for a case that may never
  arise. I chose not to add a third placement. *Stale:* the position is decided at appearance and
  never moves while the tooltip is shown. Scrolling moves the letter out from under the pointer, and
  a refresh that changes the row's state removes the tooltip, both under rules that exist today
  (`docs/DESIGN.md` § Components "The tooltip"; the host's dismiss call,
  `nozoki-mac/Sources/Surfaces/LetterTooltip.swift:L152-L161`). A theme change does not move it.
  *Empty or absent:* every row that carries a letter has a name, so the tooltip always has text. A
  surface that is not on screen raises nothing, because the pointer cannot rest on it. *Width:* the
  space left is always enough for the joining mark and the longest word, *untracked*. The sidebar is
  260 points (`docs/DESIGN.md` § Layout), and the letter sits right-aligned in the row. One case is
  named and not covered: a letter whose right edge is less than one word's width from the surface's
  left edge. In the sidebar that cannot happen, because every letter is right-aligned in a 260-point
  row.

## Left for the owner

None this run.

## Skipped

None this run.

## Companions opened

None this run.

## Launchers owed

- **docs/DESIGN.md** — `<CORE>/launchers/skill/launcher.sh product-design nozoki`
