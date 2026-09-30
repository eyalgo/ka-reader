# Self-answer report — DESIGN.md

## Header

- **Companion:** `docs/DESIGN_open_issues.md`
- **Document:** `docs/DESIGN.md` (Draft, v12)
- **Decided by:** `decide_companion_answers.md` v1.3.0
- **Date:** 2026-09-30
- **Sources re-read:** two, each read on 2026-09-30 through the page's own data file under
  `developer.apple.com/tutorials/data/`.
  - Apple, *Creating your app icon using Icon Composer*
    (https://developer.apple.com/documentation/xcode/creating-your-app-icon-using-icon-composer):
    "Icon Composer shows you a preview of your app icon on different platforms (iOS, macOS, and
    watchOS) and, for iOS and macOS, different appearances (default, dark, and mono). For mono,
    you can preview clear and tinted variants as well." The item quotes it correctly. The same
    page also says: "The system automatically renders your app icon for the different platforms,
    appearances, and sizes from your single Icon Composer file."
  - Apple, *Human Interface Guidelines — App icons*
    (https://developer.apple.com/design/human-interface-guidelines/app-icons), § Appearances:
    "In iOS, iPadOS, and macOS, people can choose whether their Home Screen app icons are
    default, dark, clear, or tinted in appearance. … You can design app icon variants for every
    appearance variant, and the system automatically generates variants you don't provide." The
    item did not cite this page. Addition 1 of § 2.1 rests on it.

## Items worked

### 2.1 — The application icon is one drawing, shown as it is under every system appearance — no second drawing for dark

- **Bucket:** 2. Choices to confirm
- **Verdict:** confirmed with addition
- **Why:** The choice is taken: Nozoki supplies one drawing of its icon, at the light values, and
  makes no second one. One clause of the proposed sentence is not taken, because Apple's own
  guidelines say the opposite of it, and two things are added that the proposal did not reach.

  **Check 1 — whose it is.** The edit lands in `docs/DESIGN.md` § Components "The application
  icon", which is the CDO's document, and this run is in the CDO's seat. The answer commits
  nobody outside the repository. It is a taste call, and the owner has not reserved it: the
  answer that made the icon this document's left this case "this seat's to propose and the
  owner's to confirm" (`docs/DESIGN.md` RN-33, its fourth point), and the drawn figure itself
  still returns to the owner for sign-off before it is recorded (`docs/DESIGN.md:L779-L781`).
  So it is answered and not left.

  **Check 2 — the draft, re-read.** The conclusion holds, for the reason given and for a stronger
  one. The reason given is the last line of the document's order for an uncovered case, fewer
  elements: one asset and two copied token values, against two assets and four
  (`docs/DESIGN.md:L357-L360`). The draft skipped the line before it in that same order, "draw it
  the way macOS would draw it by default". That line decides the case on its own: the platform's
  default for an application that supplies one icon is to generate the other appearances itself
  (HIG § Appearances, § Header above). Supplying one drawing is doing it the platform's way.

  **What does not hold** is the proposed sentence's middle clause, "it is shown as it is under
  every system appearance". The draft flagged this itself as not checked. Apple's guidelines say
  the system "automatically generates variants you don't provide", so under a dark, clear or
  tinted icon appearance the platform may show something other than the drawing as supplied. A
  document that promised "shown as it is" would state a thing it does not control and that its
  platform's vendor contradicts.

  **The additions.** (1) *The clause is dropped.* The sentence says what Nozoki supplies, one
  drawing at the light values and no second, and says nothing about how the platform shows it.
  (2) *Every appearance, not only dark.* The item's heading asks about dark. The platform has
  four: default, dark, clear and tinted. The draft answered the smaller question; the answer
  covers all of them, so no later round has to ask about tinted. (3) *The contract binds the
  supplied drawing.* The icon's paragraph says "No other colour appears in it — no hue, and
  neither pure black nor pure white" (`docs/DESIGN.md:L775-L776`), and the Don't repeats it
  (`docs/DESIGN.md:L831-L832`). A tinted variant the system generates carries a hue the user
  chose. Without this addition a careful reader would call that a breach. It is the platform's
  rendering, outside the rule in the same way the title bar's ground is (`docs/DESIGN.md` RN-32,
  "that rule binds what this document draws").

  **Check 3.** Nothing settled moves. RN-33 rules one drawing and is silent on a second; this
  fills the silence in the same direction. The redraw rule keeps two values
  (`docs/DESIGN.md:L784-L785`). The window's two themes are untouched: `docs/UXD.md` UX-I9 is
  about the window (`docs/UXD.md:L273-L274`). `docs/SDD.md` and `docs/SRS.md` say nothing of the
  application icon: `grep -n -i 'icns\|CFBundleIcon'` over `docs/SDD.md`,
  `docs/SDD_open_issues.md`, `docs/SRS.md` and `docs/PRD.md` prints nothing (2026-09-30), so one
  icon file in the bundle meets no stated condition and breaks none. The override that *would*
  reach the SDD, a bundle form holding more than one appearance, is not taken.

  **Check 4.** *Empty* — no drawn icon exists yet: the bundle names no icon file and macOS draws
  its generic one (`docs/DESIGN.md:L781-L783`); this rule has nothing to act on and says nothing
  false. *Absent* — the system generates no variant, for instance on a macOS with no icon
  appearances (the product's minimum is 14.0, `nozoki-mac/Info.plist:L13-L14`): the one drawing
  is all there is, and the rule still reads true because it promises only what is supplied.
  *Stale* — a token's light value moves: the redraw rule covers it, at two values. *Concurrent* —
  one bundle, one icon; none. *Refused* — the owner overrides to a second drawing: the item
  states what moves, and the SDD answers the bundle form first.
  **Not covered, and named:** what macOS actually draws from an icon the bundle names as a
  single `.icns` file through `CFBundleIconFile` (`nozoki-mac/Info.plist:L11-L12`). The HIG
  sentence is general and does not name that form. I don't know. The check is the one the item
  names: assemble the bundle with the drawn icon and look at it in the Dock under each icon
  appearance. It was not run here because no drawn icon exists and because it means changing a
  system setting on the owner's machine. If that look shows a generated variant nobody can
  accept, that is a change in the evidence and reopens this.

  **What I was close to deciding differently:** *overridden*, since a clause of the proposed
  sentence is replaced. It stayed *confirmed with addition* because the thing the item asks the
  owner to sign off, one drawing and no second, is taken whole, and the clause that goes is the
  one the draft itself marked as unchecked.

## Left for the owner

None this run.

## Skipped

None this run.

## Companions opened

None this run.

## Launchers owed

- **`docs/DESIGN.md`** — `<CORE>/launchers/skill/launcher.sh product-design nozoki`
