# Self-answer report — DESIGN.md

## Header

- **Companion:** `docs/DESIGN_open_issues.md`
- **Document:** `docs/DESIGN.md`
- **Decided by:** `<CORE>/../skills/companion/.claude/skills/companion-self-answer/prompts/rich.md` v1.3.1
- **Date:** 2026-10-04
- **Sources re-read:** Apple, *Using Tracking-Area Objects*
  (<https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/EventOverview/TrackingAreaObjects/TrackingAreaObjects.html>),
  read 2026-10-04: a tracking area declared `NSTrackingActiveInKeyWindow` asks AppKit to send
  `mouseEntered:`, `mouseExited:` and `mouseMoved:` "whenever its window is the key window"; it says
  nothing about an exit message at the moment the window stops being key. Apple's reference page
  for the option (`…/nstrackingarea/options-swift.struct/activeinkeywindow`) was fetched and
  returned only its title, so its text is unread. Apple Developer Forums thread 711343
  (<https://developer.apple.com/forums/thread/711343>), read 2026-10-04: one developer reports that
  on macOS 13 a `mouseExited` is generated when the window resigns key with these exact options,
  and that earlier versions did not send it; the thread has no replies and no Apple answer. It is a
  report, not documented behaviour, and § 3.1's answer does not rest on it.

## Items worked

### 3.1 — What a row's hover fill does when the window stops being the key window under a still pointer

- **Bucket:** 3. Raised from downstream — an item from a seat that did not write the design language
- **Verdict:** answered
- **Why:** The fill leaves when the window stops being the key window. The tooltip over that row
  leaves at the same moment. When the window is key again, the fill comes back on the row under the
  pointer at that moment, and the tooltip waits for a fresh 500ms rest.

  *Seat.* This is the design language's own question. The edit is a sentence in `docs/DESIGN.md`
  § Components "Rows" and "The tooltip". The answer binds only how the window draws, and
  `docs/SDD.md` RN-96 (`:L6193-L6199`) names it the CDO's. I can name no ground I cannot see:
  the owner's hover decision was about *which* rows take a fill, "rows that are actually
  clickable" (`docs/DESIGN.md` RN-11, `:L1000-L1003`), not about window state. So the item is
  mine, in the owner's seat.

  *Widening.* The item asks the document to state a case it does not state now, so it widens. It
  cites an occurrence: the product's own tracking area is declared `.activeInKeyWindow`
  (`ka-reader-mac/Sources/Surfaces/RowHover.swift:L29`), and the fill clears only on an exit or a
  forget (`:L45-L53`). I read both lines at `ka-reader@7c1acad` and they say what the item says. So the
  item is answered rather than held "until it occurs".

  *Check 2 — the question.* The item has no draft. It sets out two readings and says what each
  costs, so I answered it from scratch. It hides a second question: the moment the window becomes
  key again. An answer covering only the moment the window stops being key would come back as a
  new item. Both halves have the same seat, so this is one item answered on both, not a split.

  *Why "leaves".* The fill is a promise that a click acts (`docs/DESIGN.md:L860-L861`, "a promise
  with nothing behind it is a lie"). When the window is not key, a click on the row is not
  promised to act: the window has to become key first. A fill left on a row in a window the reader
  has left marks a row they are no longer pointing into. The shell's own tracking also answers the
  pointer only while the window is key (the Apple guide above), so a fill left in place would stay
  until the pointer moved after the window came back — indefinitely, in a background window. The
  design language's fallback order agrees: "show only what the job puts on the surface", and of two
  treatments "take the one with fewer elements" (`docs/DESIGN.md:L358-L361`). The other reading
  ("stays until the pointer next moves") passes neither test.

  *Why the tooltip goes with it.* "The tooltip" says it "stacks with the row's hover fill, which
  is the row's" (`docs/DESIGN.md:L666-L667`). If the fill left and the tooltip stayed, that
  sentence would be false, and keeping it true is the cheaper fix. The shell already gives the
  tooltip the fill's tracking options, "so the fill and the tooltip answer the same pointer under
  the same conditions" (`RowHover.swift:L7-L9`; `LetterTooltip.swift:L146`, `:L165`). So the
  answer matches what the shell meant to do.

  *Why the fill returns at once but the tooltip does not.* A fill under the pointer in the key
  window is true: a click there acts. Leaving the row bare until the pointer moves would withhold a
  promise that holds, and drawing it costs nothing new. The tooltip is a timed appearance after a
  rest (`docs/DESIGN.md:L663-L665`, RN-23), so bringing it back with no rest would make it appear
  without its trigger. A fresh rest counted from the moment the window is key keeps that one rule.

  *Check 3.* Nothing settled moves. No token, colour or component changes. The no-transition rule
  (`:L625`, `:L864-L866`) holds, because the fill leaves and returns in place. "Selection outranks
  hover" (`:L624-L625`) holds, because the selected row's fill and bar are not hover. The UXD names
  no hover (`grep -n -i hover docs/UXD.md` prints nothing). UX-I2's "only what actually changed
  changes" holds: becoming or ceasing to be key *is* a change, and the Traceability row's "the hover
  fill and the tooltip are pointer-driven and never fire on an update" (`docs/DESIGN.md:L1657`) is
  untouched, since key status is not a content update. I did not rest on the forum report: the rule
  is stated in the language, so it holds whether or not the platform sends an exit at that moment.
  The product's floor is macOS 14 (`ka-reader-mac/Package.swift:L14`), and if that report is right the
  shell may already clear the fill there. That is unmeasured, and the delivery tier must not lean on
  undocumented behaviour to meet this rule.

  *Check 4.* **Empty:** with no row under the pointer, nothing is drawn either way. **Stale:** a
  refresh that moves rows while the window is not key draws nothing. On return, the fill is read
  against the rows as they stand then, not the row it left. **Concurrent:** a panel taking key from
  the window (the Open panel behind *Browse…*) is the same moment, and the fill leaves, which is
  right because the next click goes to the panel. **Absent:** if the pointer left the window while
  it was not key, there is no row under it on return and nothing is drawn. **Named and not
  covered:** what the selected row's own fill and bar do in a window that is not key. macOS dims a
  selection in an inactive window by default, and the design language draws selection from tokens.
  That is a different question from this item's, no item raises it, and no occurrence of it is cited.

  *Close to another verdict?* I weighed "the fill returns only when the pointer next moves". It is
  simpler for the shell, and it is not a lie, since a missing fill promises nothing. It lost because
  it leaves the one row a click now acts on unmarked, for no saving in what the language has to say.

### 3.2 — Whether the row of an entry that cannot be read is a row "that selection or opening acts on"

- **Bucket:** 3. Raised from downstream — an item from a seat that did not write the design language
- **Verdict:** confirmed with addition
- **Why:** Yes. A file row whose file cannot be read, and a folder row whose listing failed, are
  rows that selection or opening acts on, so both take the fill. The addition is the test behind
  that and the line it draws. A row takes the fill because of what a click on it does, never
  because of the state of its entry's read. The words a failed entry carries in its row do not
  make the row inert.

  *Bucket reading.* The item carries a lean: "the CDO's confirmation of a call the shell already
  draws". So I treated the shell's behaviour as the draft, under the prompt's rule for an item that
  arrives with a lean.

  *Seat.* This is the design language's own question. The edit is one clause in
  `docs/DESIGN.md` § Components "Rows", and `docs/SDD.md` RN-96 (`:L6193-L6199`) names it the
  CDO's. I can name no ground I cannot see.

  *Widening.* The item asks for a clause the document lacks. It cites an occurrence: the shell
  draws the fill on both rows (`ka-reader-mac/Tests/SurfacesTests/RootItemsViewHoverTests.swift:L302-L311`,
  read at `ka-reader@7c1acad`, as cited). So it is answered.

  *Check 2 — does the draft hold for its reason?* The item gives two reasons. I checked both
  against source rather than taking them from the item.
  - A click on a failed file row raises the file selection. `outlineViewSelectionDidChange`
    raises `fileSelected` for any file row with no guard on its read state
    (`ka-reader-mac/Sources/Surfaces/RootItemsView.swift:L570-L575`). The reading panel then shows the
    path line over "an observed failed read, including a file gone or unreadable"
    (`docs/DESIGN.md:L671-L674`).
  - A failed folder row can be expanded and read again. Every folder row is expandable
    (`RootItemsView.swift:L516-L517`), and "every expansion reads the folder again"
    (`:L18-L19`, `:L581-L584`).

  So the conclusion holds for the reason it gives. What the draft lacks is why the question arose
  at all. § Components "Status messages" lists "an unreadable entry" among the states the
  status-message component covers (`docs/DESIGN.md:L743-L745`), and "Rows" says a status message
  never takes the fill (`:L622-L624`). Read together, those two make an unreadable entry's row look
  inert. The addition separates the two things: the status message is the statement of what was
  observed, and the entry's row is still a row a click acts on. It also keeps the genuinely inert
  case inert. The line drawn beneath an expanded folder while its read is out, or when it is empty
  (`RootItemsView.swift:L460`), is a status message rather than the folder's row, and the shell
  already gives it no fill (`:L144-L147` returns no row view for anything but an entry row).

  *Check 3.* This agrees with the UXD: "A single unreadable item degrades only its own
  presentation, never the shell" (`docs/UXD.md:L136`; UX-I10, `:L284-L286`). Withholding the fill
  would make the row look dead when a click still acts on it, which degrades more than the row's
  own presentation. It agrees with the owner's scope for hover, "rows that are actually clickable"
  (`docs/DESIGN.md` RN-11, `:L1000-L1003`). And it agrees with § 3.1 above, which was decided
  first: § 3.1's key-window rule covers these rows like any other clickable row, and nothing here
  bends it.

  *Check 4.* **Stale:** if a refresh turns a readable entry unreadable under a still pointer, the
  row keeps the fill, because a click still acts. The fill follows "the row now under the pointer"
  rule the shell already keeps (`RowHover.swift:L9-L11`). **Absent:** a file that vanished leaves
  the tree on refresh and takes its row with it, so there is nothing to fill. Until then, a click
  shows "a file gone" in the panel, which is the same case as unreadable. **Concurrent:** a
  re-read under way beneath an expanded failed folder draws its pending line beneath, and that line
  is inert, as above.

  *Named and not covered — a shell defect, not this document's.* The failed entry's sentence, which
  now sits on `{colors.hover}` while the pointer is over the row, is drawn in the system's
  `.secondaryLabelColor` (`RootItemsView.swift:L308`, `:L349`). The rule is to read it from a token
  (`docs/DESIGN.md:L840-L841`), and the shell has the token
  (`ka-reader-mac/Sources/Surfaces/CodeTokens.swift:L12`, `inkMuted`). `{colors.ink-muted}` on
  `{colors.hover}` is a specified, measured pair (`docs/DESIGN.md:L437`; RN-22, `:L1098-L1100`).
  `.secondaryLabelColor` on `{colors.hover}` was never measured. The design language is right as
  it stands, so this is not raised on it. It is for the delivery tier to repair, and this run may
  write no product source.

  *Close to another verdict?* Plain **confirmed** was close. It lost because the confirmation alone
  would leave "Status messages" and "Rows" still readable as contradicting each other on these rows,
  and that contradiction is what produced this item.

## Left for the owner

None this run.

## Skipped

None this run.

## Companions opened

None this run.

## Launchers owed

- **docs/DESIGN.md** — `<CORE>/launchers/skill/launcher.sh product-design ka-reader`
