# Self-answer report — `docs/SDD.md`

## Header

- **Companion:** `docs/SDD_open_issues.md`
- **Document:** `docs/SDD.md` (Settled, v20)
- **Decided by:** `decide_companion_answers.md` v1.3.0
- **Date:** 2026-09-30
- **Sources re-read:** None. No answer here rests on a source outside this repository. Every
  fact the answer leans on was re-read in the tree on `main` at `ka-reader@8e738b7` before writing:
  `ka-reader-mac/Sources/Shell/WindowPresenting.swift:L21` (480 × 640) and `:L44-L47` (no minimum
  size), `ka-reader-mac/Sources/Surfaces/WorkbenchView.swift:L14` and `:L32-L34` (the sidebar held at
  260), `:L46-L53` (the prompt as a plain label, top-left, inset 24, no glyph),
  `ka-reader-mac/Sources/Surfaces/RootItemsView.swift:L69-L72` (the root line centred),
  `ka-reader-mac/Sources/Surfaces/StartupView.swift:L65-L70` (two `NSButton`s) and
  `grep -n -i 'NSImage\|symbol' ka-reader-mac/Sources/Surfaces/StartupView.swift` exiting 1;
  `docs/DESIGN.md:L483-L489` (260, 720), `:L668-L688` (status messages), `:L695-L705` (the startup
  surface), `:L849-L856` (RN-8, every measurement owner-confirmed), `:L914-L920` (RN-14);
  `docs/UXD.md:L65-L67` (§ 4, the dominant reading panel).

## Items worked

### 5.1 — § 6 names no slice whose *Reached when* holds `docs/DESIGN.md`'s layout and component drawing for the surfaces S-1 draws

- **Bucket:** 5. Raised from downstream — an item from a seat that did not write the SDD
- **Verdict:** answered
- **Why:** S-1 holds `docs/DESIGN.md` § Layout and § Components for the surfaces it draws, cited
  by section; no later slice is named, and S-6 does not move. There was no draft — the item offered
  two options and a lean on part of one — so the answer was worked out from the document.

  **The widening rule, first.** The item sits under the heading carrying *Raised from downstream*,
  and it widens the SDD: § 6 states nothing today about which slice holds the design language's
  layout and component rules. So the prompt's § *A widening item waits until it occurs* applies,
  and the question is whether the item cites an occurrence. It cites three, each a path and line in
  the product as it stands on `main` (`ka-reader@8e738b7`), and each was re-read above and holds: the
  window opens 480 wide with no minimum, the tree's status line is centred, the startup routes are
  bordered buttons with no glyph before the message. Occurrences cited, so the widening proceeds.

  **Check 1: the seat.** The edit lands in `docs/SDD.md` § 6 — S-1's observable half (the CDO's
  lane) and, had the second option been taken, S-1's and S-6's *Not in this slice* (the CPO's). It
  is the SDD's own item. Is it the owner's? The answer commits no person, money or outside party.
  It moves no promise: every value it reaches — 720, 260, top-left, glyph-led, text-alone routes
  — is already `docs/DESIGN.md`'s and already owner-confirmed there (RN-8: "Every measurement
  confirmed by the owner"; RN-14; the startup surface at RN-28). What the answer decides is which
  slice's bar holds them, which is how the work is divided and not what the product promises — the
  SDD's own routing rule for the owner's turn (RN-19: an item goes to the owner when its answer
  changes what the product promises, not when it changes how the work is divided). The PM named the
  window's minimum width as "the seats' call", and it is. I can name no ground I cannot see. So the
  item is mine in the owner's seat, and the answer goes in the slot.

  **Check 2: the question.** It is one question with a wide consequence — which slice's *Reached
  when* holds the drawing — and not two: the three places share one seat and one answer, and the
  item's two options are the two answers to that one question. Not a split. The item's supporting
  text is right on every count I checked: § 4's CDO clause does say every token value is
  `docs/DESIGN.md`'s and fixes none (`docs/SDD.md:L820-L821`); S-1's observable half cites UXD screen
  states and no DESIGN clause (`:L1292-L1316`); S-6's fence says "any token value —
  `docs/DESIGN.md`'s" (`:L1685-L1686`). One narrowing in the item, named: it lists three places, and
  the sentence the answer asks for also reaches a fourth of the same form the item's own reading
  covers — the reading panel's prompt, drawn top-left at `{spacing.xl}` (`WorkbenchView.swift:L42-L53`
  cites RN-14 for it) but with no leading `info` glyph, which § Components "Status messages" gives
  every empty state. The answer names it as covered by the same sentence, not as a new claim.

  **Why the first option, for all three.** Two grounds.

  *No later slice has this as its decision.* § 5 step 4 sizes each slice against the one decision
  inside it. E-6 → `choose-a-theme`'s decision is that own state lands in the container and nowhere
  else; its bar is the two themes present over every surface already drawn, held against § Colors'
  tokens and the contrast floor (`docs/SDD.md:L1653-L1662`); its *Rests on* names "the token pairs"
  — colour pairs. Making it the slice that gives the startup surface its glyph and its text-alone
  routes, or the tree its top-left status line, puts a second decision — what a surface's components
  look like — inside a slice sized against a different one, which is § 5 step 4's "too broad": two
  answers hiding in one slice. The PM's lean, "which arrive with the token pairs", reads S-6's
  *Rests on* as if the pairs were the whole of § Components; they are its colour half. No other
  slice comes closer: S-2 to S-5 and S-7 to S-11 each name their own surface or proof, and none is
  "the window's layout". Naming one would invent a slice, and § 6 is the CPO's cut, not this
  answer's to redraw.

  *S-1 already claims the layout.* S-1's *Traces to* carries `docs/UXD.md` § 4 "Information
  Architecture (one window, one shell; the sidebar beside a dominant reading panel)"
  (`docs/SDD.md:L1353-L1354`). Dominance is something a person watching sees, and the window as
  drawn does not show it: at 480 wide with the sidebar at 260, the reading panel is 220 — narrower
  than the sidebar. `docs/DESIGN.md:L487-L489` is the number the UXD's word resolves to ("below
  which the panel stops being dominant and the product stops being what the PRD says it is"). So
  holding § Layout in S-1 closes a bar S-1 was already held to and could not meet; it does not add
  one. The same holds for the surfaces: S-1's observable half is the one that names the empty tree,
  the failed root, the empty panel and the startup surface as things a person sees (UX-S1 Empty,
  UX-S2 Empty and Error, UX-S4 Empty and Error); how they are drawn is `docs/DESIGN.md`'s, and the
  slice that shows them is the slice whose bar holds how.

  **How the sentence cites, and what it does not touch.** By section, never by value — S-6 already
  cites "the contrast floor `docs/DESIGN.md` § *Colors* states" rather than the number, and § 12's
  UXD boundary says this document "cites the delegate and fixes nothing of its own". A cited section
  survives a DESIGN revision; a copied number would not, and single-source forbids the copy. Not
  added to *Traces to*: that field carries PRD, SRS and UXD clauses only, and S-10 states the rule
  for a DESIGN fact ("is `docs/DESIGN.md`'s and is not traced here"). S-1's fences stand: the rail's
  entries, the chrome's two controls and the Git view are `see-git-status`'s, `choose-a-theme`'s
  and `switch-the-folder`'s (RN-37), so the layout S-1 holds is the two panels it draws and the
  window's minimum, with the rail strip and the chrome's contents arriving with their slices. The
  720 minimum is held as `docs/DESIGN.md` states it, not re-derived for an intermediate window with
  no rail: the value is that document's and its RN-8 is the owner's confirm.

  **Check 3: against the settled record.**
  - `docs/SDD.md` § 4 CDO clause (`:L820-L821`): unchanged — no condition fixes a value, and S-1's
    bar cites sections, as S-6 does.
  - § 12, the UXD boundary: "every token value to `docs/DESIGN.md` … this document cites the
    delegate and fixes nothing of its own" — the answer is that sentence applied to S-1.
  - S-6's *Not in this slice* "any token value — `docs/DESIGN.md`'s": unchanged, and still true.
  - RN-37 (the sidebar holds the Files view alone until `see-git-status`): unchanged; the answer
    keeps the rail's entries fenced.
  - § 5 step 4, E-1's sizing ("one bar on one artifact … the window drawn is now a native one"):
    the layout is part of "the window drawn", and holding it changes no decision inside the slice,
    so the sizing stands — neither too broad nor too narrow.
  - § 3 `surfaces` ("The shell's views as the UXD draws them … the theme tokens as values"): the
    part that draws them is already S-1's (*Rests on*).
  - `docs/fdr.md` v10: it derives from SDD §§ 1, 3, 4, 9, 11, 12 and not § 6 (its RN-31), and
    `grep -n -i '720\|minimum width\|centred\|top-left' docs/fdr.md` finds nothing — no FDR sentence
    moves, and no FDR item is opened.
  - `docs/nfdr.md`: `grep -n -i '720\|minimum width' docs/nfdr.md` finds nothing — no entry binds
    the window's layout, so none re-derives.
  - `docs/UXD.md` v10 § 4 and § 6: the answer binds observations the UXD already names and moves no
    entry; no UXD gap.
  - The sealed unit `2026-09-30_the-launch-window-draws-its-surfaces` (`change_spec.md` § Out of
    Scope, Gaps 1, 2 and 4): it left the minimum width, the sidebar's width and the glyphs out
    because the request did not ask for them and "reported [them] to the PM" — which is this item.
    The answer contradicts nothing sealed.
  - The seed `2026-09-15_open-a-folder` and station `2026-09-27_the-startup-surface`: the
    station's condition 4 walks "S-1's observable half as written" and cites it by line
    (`docs/SDD.md:L1292-L1316`). The fold widens what that walk checks, which is how the change
    reaches the product without a new seed; the station's line citation goes stale on the fold and
    is the PM's to re-point at the next `shukuba-refine`, as the seed's five prior re-cuts were.
    Journey files are the PM's, and nothing is written there from here.
  - `docs/DESIGN.md` itself is the one settled document the answer leans on that is owed a change
    — see § Companions opened. The answer is built on DESIGN's values as they stand; the false
    sentence is in its § Overview and touches no value.

  **Check 4: the failure paths.**
  - **Absent — the glyphs.** C-E7 forbids "a glyph the tool does not ship", so a glyph-led status
    message in S-1 needs the icons in the bundle. C-R1 says the fourteen ship inside
    `Contents/Resources`; the shell already carries a `GlyphSource` seam and draws `folder` and
    `file` from the bundle (`ka-reader-mac/Sources/Shell/GlyphSource.swift:L1-L16`,
    `LaunchFlow.swift:L8-L9`), and `third_party/lucide/icons/` holds `circle-alert.svg` among the
    set. `info` and `circle-alert` reach the startup surface and the status lines through the same
    seam. Not a new capability, and not a UXD gap.
  - **Empty / pending — the startup surface's `reading` projection** (`StartupView.swift:L38-L39`):
    a pending state, so § Components gives it `info`, the same as the empty state. Covered by the
    sentence; named so it is not read as uncovered.
  - **Stale — DESIGN.md moves.** It "may legitimately trail the SDD" (its header). S-1 cites
    sections, so a changed value moves nothing in the SDD; only a section renamed would, and that is
    a DESIGN change the CDO seat folds.
  - **Concurrent — the station is mid-walk.** The open station reads S-1's observable half by
    reference and follows the fold; the seed records five re-cuts of exactly this shape (2026-09-19,
    2026-09-23, two on 2026-09-24, 2026-09-26). Named above.
  - **Refused — the CDO seat, at the fold, reads the minimum width as the window's rather than a
    surface's.** It is still S-1's: `mac-shell`, which owns the window, is in S-1's *Rests on*.
  - **The 720 minimum with no rail.** DESIGN's number is 48 + 260 + 412; the intermediate window has
    no rail strip. The answer holds the number as stated and does not derive 672: the value is
    DESIGN's, the rail strip arrives with its entries, and a panel of 460 in the meantime is
    dominant either way.

  **What was close.** The second option for the startup surface's glyph and routes, as the PM
  leaned — S-6 does re-read every surface in both themes, the startup surface named among them, so
  a reader could place "how the startup surface looks" there. What tipped it: S-6's bar is a theme
  check over surfaces already drawn, and its decision is own state; giving it a component's shape
  is the "two answers hiding inside one slice" § 5 step 4 exists to catch. What would have tipped
  it the other way is a slice in § 6 whose decision is the surfaces' drawing, and there is none.

## Left for the owner

None this run.

## Skipped

None this run.

## Companions opened

- **`docs/DESIGN_open_issues.md`** — **opened** — companion to `DESIGN.md`, landed in commit
  `a047914e84eb683efeea4405ce6bac022b7bff03`. Found while reading `docs/DESIGN.md` for the answer
  above, not routed by the item: § Overview's realisation sentence ("plain CSS custom properties
  over the product's own markup", `docs/DESIGN.md:L331-L333`) and RN-1's "every value here is a CSS
  value" (`:L786-L787`) are a fact now false — one AppKit process, no web engine, no markup since
  `docs/SDD.md` v13 (§ 10 RC-3). The SDD has carried it as owed to DESIGN's own run since RN-53
  (2026-09-23) and re-checked it at RN-69 (2026-09-24); DESIGN reached v10 on 2026-09-25
  (`ka-reader@da88347`) with the sentence unchanged, because the SDD is not among its inputs
  (`docs/DESIGN.md:L303`) and it had no companion — the case the prompt's § *The items are not the
  whole of what a document is owed* was written for. The item sits in § 2 *Choices to confirm* with
  its slot at the placeholder; it decides no value and names § Typography's font-stack syntax as the
  CDO's call, not its own. `grep -l -i css docs/trail/design/*.md` finds no prior decision to keep
  the sentence.

## Launchers owed

- **`docs/SDD.md`** — `<CORE>/launchers/product-sdd/launcher.sh ka-reader`
- **`docs/DESIGN.md`** — `<CORE>/launchers/skill/launcher.sh product-design ka-reader`
