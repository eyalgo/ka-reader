# Self-answer report — DESIGN.md

## Header

- **Companion:** `docs/DESIGN_open_issues.md`
- **Document:** `docs/DESIGN.md` (Draft, v11)
- **Decided by:** `decide_companion_answers.md` v1.3.0
- **Date:** 2026-09-30
- **Sources re-read:** three, each read on 2026-09-30.
  - W3C, *Relative luminance* (https://www.w3.org/WAI/GL/wiki/Relative_luminance), Note 1: "For
    the sRGB colorspace, the relative luminance of a color is defined as L = 0.2126 * R + 0.7152 *
    G + 0.0722 * B". § 2.1's *a hex colour is an sRGB value* rests on it.
  - Apple, `NSFont.monospacedSystemFont(ofSize:weight:)`
    (https://developer.apple.com/documentation/appkit/nsfont/monospacedsystemfont(ofsize:weight:),
    read through the page's own data file under `developer.apple.com/tutorials/data/`): "Returns
    a monospace version of the system font with the specified size and weight", macOS 10.15 and
    later. § 2.1's *the shell asks the platform for its monospaced system font* rests on it.
  - Apple, `NSWindow.titleVisibility`, its `.hidden` case, and `NSWindow.title` (same site, same
    route): `.hidden` — "The window hides the title and moves the toolbar up into the area
    previously occupied by the title"; `title` — "Setting this property also sets the title of the
    window's miniaturized window." The property's one-line summary reads "the visibility of the
    window's title and title bar buttons", which leaves open whether the buttons go with the
    title, so that was measured and not assumed: a window made with the shell's own style mask
    and `titleVisibility = .hidden` on macOS 26.6.2 reports all three standard buttons present
    and not hidden, keeps its title string, and has a title bar 32 points high (a Swift script
    run on 2026-09-30; it is not kept in the repository). § 2.2 rests on it.

## Items worked

### 1.1 — The application ships an icon that no document designs, and the one on disk is a plain blue square — is the icon the design language's, and what is it?

- **Bucket:** 1. Open issues
- **Verdict:** confirmed with addition
- **Why:** The icon is `DESIGN.md`'s to rule on, and it is KA-Reader's own icon, drawn without hue.
  The blue square is not kept. The item sits in the open-issues bucket but carries a lean ("This
  seat's lean is that one, drawn in the shell's own ink on the shell's own surface with no hue"),
  so it was weighed as a draft and not answered from nothing. The lean holds. Four things are
  added, because as written it leaves the document without a rule until somebody draws an asset.

  **Check 1 — whose it is.** The edit lands in `docs/DESIGN.md`, which is the CDO's, and this run
  is in the CDO's seat. The answer commits nobody outside the repository, no money and no legal
  position, and it changes nothing the product promises its user. No ground is out of sight: the
  one earlier identity decision, the owner declining the removed design reference with its
  wordmark treatment, is on the record (`docs/trail/design/cycle-1.md` § 1.1) and was about
  reusing old values, not about whether the product has a mark. The authoring rule gives the
  whole visual call to the CDO and keeps sign-off for the owner
  (`<CORE>/prompts/cdo_create_design.md:L265-L268`), and the drawn figure still comes back for
  that sign-off (addition 2). So this is answered and not left.

  **Check 2 — the facts, re-measured.** `ka-reader-mac/icon.icns` rendered with `sips -s format png`
  on 2026-09-30 is one uniform blue field with no figure. `ka-reader-mac/Info.plist:L11-L12` names it
  as the bundle's icon and `ka-reader-mac/assemble.sh:L61` copies it in. `ka-reader@15e8790` added it
  as "a byte copy of crates/ka-reader-app/icons/icon.icns". No document rules on it: the item's
  `git grep` finds only this revision's own RN-31 (`docs/DESIGN.md:L1275`).
  **The item asks two things, and both are this seat's**, so they are answered in one slot.
  *Is the icon this document's?* Yes. Every answer the item lists ends with `DESIGN.md` recording
  something, and no other document holds a visual value. *What is it?* The document's own order
  for a case no rule covers (`docs/DESIGN.md:L355-L358`) starts with "show only what the job puts
  on the surface". In the Dock and the application switcher the job is telling this application
  from the others, and the generic icon is shared by every application that has none. So the
  first line of that order asks for an icon of KA-Reader's own, and only its last line, fewer
  elements, shapes it: one figure, no hue. The blue square fails on its own terms. Nobody chose
  it, it is a leftover of a host the product no longer has, and the instance's direction starts
  every product from "No placeholder asset"
  (`system/experience/visual_direction.md` § Overview, line 5).

  **The additions.** (1) *The blue square is never a decided value.* A release carries the drawn
  icon or the bundle names no icon file. Without this the answer is only a promise of a future
  asset, and the square ships in the meantime. No release exists yet (`README.md:L10-L17`), so
  nothing a stranger holds changes. (2) *The contract, not the figure.* The figure is an
  aesthetic call, and it is made in the run that draws it
  (`<CORE>/doctrine/governance/where_taste_appears.md` § The rule). It returns as a pointer item
  on this companion, which is the fourth authorization the design language accepts
  (`<CORE>/prompts/cdo_create_design.md:L242-L244`). (3) *From the tokens the document has.* No
  colour token enters. The light values are used because the frontmatter carries the light
  polarity (`docs/DESIGN.md` RN-17). The figure is not lettering: RN-9 keeps the name and the
  kanji on the README, and `docs/CONTENT.md:L143-L144` says the kanji never appears in the
  running product. The fold also has to say which of the window's rules reach the icon, since
  "no larger radius exists" (`docs/DESIGN.md:L550-L551`) is written about the window and the
  icon's outline is the platform's. (4) *One case is not covered:* a second drawing for a dark
  system appearance.

  **Check 3.** Nothing settled moves. RN-2's achromatic signature is kept outside the window
  too. RN-9 is about the shell and is not contradicted: the icon is not in the shell.
  `docs/SDD.md`, `docs/SRS.md`, `docs/fdr.md`, `docs/nfdr.md` and `docs/adr/` do not mention
  `icon.icns` (`git grep -n -i "icon\.icns" HEAD --` over those paths prints nothing), so
  "names no icon file" breaks no stated condition. § 2.2 was decided after this item and then
  read against it, and the two agree: the window is the folder's, and KA-Reader is identified in
  the system's own places.

  **Check 4.** *Empty* — no asset yet: addition 1. *Absent* — the design run never happens: the
  same rule holds indefinitely and the product ships the generic icon. *Stale* — a token value
  later moves: the icon is a fixed file and does not follow; the fold should say the icon is
  redrawn when the two tokens it uses change. *Concurrent* — none; one bundle, one icon.
  *Refused* — the owner overrides to no icon or to the blue square: the item already states what
  each moves.

  **What I was close to deciding differently:** leaving it for the owner, as the product's one
  mark. It was decided because the mark itself is not decided here. This answer settles that
  there is one and what it may be made of; the drawing still goes to the owner before it is
  folded. **Found while checking, for the PM to route:** `ka-reader-mac/assemble.sh:L37` refuses to
  build without `icon.icns`, so under addition 1 the build has to change before a release, by
  gaining the drawn icon or by dropping the requirement.

### 2.1 — § Overview says the language is realised in AppKit views, with no web engine, no markup and no stylesheet — applied at v11 on the evidence, awaiting your sign-off

- **Bucket:** 2. Choices to confirm
- **Verdict:** confirmed
- **Why:** Revision 11 says what the product is, its evidence is as the item reports it, and
  each of its three calls is the one that moves least. Nothing is added to it.

  **Check 1.** The wording is `docs/DESIGN.md`'s own and binds nothing outside it. No token
  moves, so no owner-confirmed value is touched. This seat's.

  **Check 2 — the grounds, each opened on 2026-09-30.** `README.md:L46-L48` reads "an AppKit
  shell in Swift (`ka-reader-mac`) over a Rust library … There is no web engine in it". The item's
  `grep` for `WebKit|WKWebView|\.css|html` over `ka-reader-mac/Sources`, `Package.swift` and
  `assemble.sh` prints nothing. The frontmatter is revision 10's byte for byte: `diff` of lines
  1–296 of `ka-reader@da88347:docs/DESIGN.md` against the file on disk prints nothing. Every place
  the item names reads as quoted (`docs/DESIGN.md:L331-L345`, `:L445-L450`, `:L484-L485`,
  `:L513`, `:L528-L533`, `:L745-L751`, `:L758-L759`, RN-31 at `:L1261`). The arithmetic holds:
  0.06 × 11 is 0.66, and 44 × 16 is 704. A search of the document for `css`, `stylesheet`,
  `markup`, `html`, `browser` and `web` finds no sentence that still speaks as if a stylesheet
  existed. What remains is the history in RN-1 and RN-31, and the Don't's fourth noun, which is
  `docs/UXD.md` UX-I15's own list (`docs/UXD.md:L317-L318`).
  *The font stacks stay.* The shell can ask for both families without naming one: Apple documents
  a monospaced system font from macOS 10.15 (§ Header), and the product requires 14.0
  (`ka-reader-mac/Info.plist:L13-L14`). One correction to the item's wording, which changes nothing:
  it says the owner "confirmed the two families in those words". The owner said "confirm" and
  nothing more; the stacks were in the item they confirmed (`docs/trail/design/cycle-1.md`
  § 2.2). *`44rem` stays*, and sixteen points is a number this seat chose. The document says so
  itself (RN-31, "this seat's reading of a unit no revision ever gave a root size to"), and the
  length it gives is the one revisions 1–10 drew in a browser. *The clipped-row clause* is re-said
  in the only way that agrees with the rest of the document. Read as a markup attribute, "the
  row's title" would have raised a tooltip on every row, and the Don'ts allow a tooltip on a
  status letter and nowhere else (`docs/DESIGN.md:L779-L781`).
  *A hex colour is sRGB* is what RN-6's measurements already assumed, and the W3C note says it in
  those words (§ Header).

  **Check 3.** `docs/SDD.md` § 2 chose the native view and `docs/SRS.md` C-11 is macOS only. The
  sentence now agrees with both and with the README. The override the item offers, keeping the
  CSS sentence, would put this document against all three.

  **Check 4.** *Empty / Absent* — nothing here depends on a runtime state. *Stale* — the README
  or the shell moves again: that is the same *change in the evidence* authorization, and the
  item shows it working. *Concurrent* — a high-density display: a `px` as one point is the
  platform's own unit and scales with it. *Refused* — the owner overrides to native token
  values: the item states what moves (ten type levels and one spacing token, no drawn size).
  *One case not covered, and named:* a clipped **folder** name. A clipped file's whole name is on
  the path line once the file is open (`docs/DESIGN.md:L643-L645`); a folder never opens there,
  so a folder whose name clips is shown whole nowhere. `docs/CONTENT.md:L487-L490` holds that
  clipping a name costs nothing, and the sidebar is sized for "a five-level path"
  (`docs/DESIGN.md:L498-L500`), so no change is raised for it.

  **What I was close to deciding differently:** the override that restates the tokens natively,
  since a `rem` in a product with no stylesheet is an odd thing to keep. It stayed *confirmed*
  because the token format "writes a value the way a stylesheet would" whatever the product is
  (`docs/DESIGN.md:L338`), and restating eleven values to change no drawn size spends a wording
  the owner signed off for nothing.

### 2.2 — The window's title bar: the platform's own, carrying its three window buttons and no drawn title; the window's title is the viewed folder's name, never the product's

- **Bucket:** 2. Choices to confirm
- **Verdict:** confirmed with addition
- **Why:** The proposed rule is taken: the platform's own title bar with its three buttons and no
  drawn title, and a window titled with the viewed folder's name. It extends a rule the owner
  already confirmed to a place that rule never mentioned, in the same direction. Four things are
  added, each a case the proposal did not reach.

  **Check 1.** The edit lands in `docs/DESIGN.md` § Layout. It looks like a layout change, which
  would be the UXD's, and it is not one: the title bar is what the shell already has
  (`ka-reader-mac/Sources/Shell/WindowPresenting.swift:L45`), so confirming moves no structure. The
  override that *would* move structure, making the chrome the title bar, is the one the item
  itself sends to the SDD first. The title string is not `docs/CONTENT.md`'s to write either: it
  is the folder's own name, the reader's word, exactly as the chrome's label is. This seat's.

  **Check 2 — the grounds, each opened.** The shell makes a standard titled window and sets
  `window.title = "KA-Reader"` (`WindowPresenting.swift:L45`, `:L48`). The design language draws the
  chrome as "one strip across the top" and is silent on what sits above it
  (`docs/DESIGN.md:L504-L506`). The owner confirmed "no wordmark, logo, or product name in the
  shell" (`docs/trail/design/cycle-1.md` § 2.6), and `docs/CONTENT.md:L144` reads it as "the
  shell carries no product name at all". The proposal follows the document's own order for an
  uncovered case (`docs/DESIGN.md:L355-L358`) and the reasoning holds at each step: the folder
  and not the product; the platform's bar and buttons; the folder named once. The platform can do
  what the rule asks. Measured on 2026-09-30 (§ Header): a window with its title hidden keeps all
  three buttons and keeps its title string, which the system still uses for the miniaturized
  window.

  **The additions.** (1) *One string, not two rules.* The proposal says "the viewed folder's
  name" and leaves open which name when the folder is renamed, switched, or is a volume's root.
  Binding the title to the string the chrome shows answers all three at once and keeps one
  source. (2) *The theme.* The user may override the theme (`docs/UXD.md` UX-I9). A title bar
  that followed only the system would sit light above a dark shell. Its ground is the platform's
  material and comes from no token, while the first Do says every colour is read from one
  (`docs/DESIGN.md:L758-L759`); the fold has to state that one exception or the bar reads as a
  defect. (3) *Where the rule stops.* macOS shows the application's name in the menu bar, the
  Dock and the switcher. A reader holding "no product name" strictly would call each a breach;
  they are the platform's and outside the window. The same goes for the three window buttons
  against "Do keep the chrome to two controls" (`docs/DESIGN.md:L771`) and against UX-A4's "no
  control … by a glyph alone" (`docs/UXD.md:L386-L387`). (4) *The dependency.* Hiding the title is
  right only because the chrome names the folder. The shell as built draws no chrome yet:
  `grep -rn -i -E "chrome|folderName|lastPathComponent|displayName" ka-reader-mac/Sources`, run
  2026-09-30, prints nothing. A build that hid the title and changed nothing else would name the
  folder nowhere. Stating the ground inside the rule lets the delivery seats land the two
  together without this document naming a slice.

  **Check 3.** Agrees with RN-9, with `docs/UXD.md` § 4 ("The viewed folder is identified in the
  shell chrome", `:L86-L87`) and with "One window" (`:L65`). On the startup surface the title is
  the product's name and is not drawn, so `docs/CONTENT.md:L143-L144` still reads true of what
  the shell draws. It agrees with § 1.1 above: nothing of KA-Reader's is drawn in the window, and
  the system's own places are where it is identified, which is why those places get an icon.

  **Check 4.** *Empty* — the startup surface has no folder: the proposal covers it. *Absent* —
  the folder's name cannot be read: the title follows the chrome, whatever the chrome shows
  (addition 1). *Stale* — the folder is renamed while viewed: the same. *Concurrent* — there is
  one window, and no second title to disagree. *Refused* — the three overrides are stated in the
  item. *Not covered, and named:* full-screen, where the platform hides the title bar itself;
  nothing here rules on it.

  **Two consequences that ride down once this is folded, neither raised now** because no document
  states anything false today. `docs/CONTENT.md` may owe a line naming the window's title as a
  place the product's name is set. The shell as built draws "KA-Reader" in the bar and never
  retitles the window (`WindowPresenting.swift:L48`), which becomes a departure from the design
  language for the PM to route.

  **What I was close to deciding differently:** a plain *confirmed*. It became *confirmed with
  addition* on the theme case. The proposal as written would fold into a rule that says nothing
  about a light title bar over a dark shell, and that is the first thing a user who picks Dark on
  a light system would see.

## Left for the owner

None this run.

## Skipped

None this run.

## Companions opened

None this run.

## Launchers owed

- **`docs/DESIGN.md`** — `<CORE>/launchers/skill/launcher.sh product-design ka-reader`
