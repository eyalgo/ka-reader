# DESIGN open issues — nozoki

> Companion to `DESIGN.md`. The CDO authored the design language non-interactively; this file
> holds the calls it made and wants your sign-off on — each with the reason behind it, and what
> moves underneath it if you override — plus the few things it genuinely could not settle, and,
> when a design run has produced output for this product, the pointer to it.
> **Answer inline** — fill each **Answer** / **Confirm-or-override** slot — **commit this file**, then
> re-run `product-design`. It folds your answers into `DESIGN.md` and drops the resolved
> items. When nothing is left open, `product-design` **deletes this file**: no file = the
> design language is done.
>
> **Commit before re-running.** The run that finishes a round removes this file, and git
> refuses to remove a file with uncommitted edits in it — so an uncommitted answer stops
> that run before it can commit anything, and the round's work is left on the floor.
>
> Your answers are never thrown away. Each time the CDO folds them in, it first copies this
> file whole to `docs/trail/design/` — so what you decided, and why, stays readable and citable
> for good.
>
> **§ 3 is not the CDO asking.** The design language is read by everything built after it, and a
> seat downstream can find a rule missing that the authoring run had no occasion to write. That item
> lands in § 3 and is folded by the same run.

> **No `product-design` run opened this companion.** A `companion-self-answer` run answering
> `docs/SDD_open_issues.md` § 5.1 opened it on 2026-09-30 with one item, § 2.1
> (`nozoki@a047914`; its report is `docs/trail/sdd/self_answer-27.md`).
>
> **Where this round stands.** A `product-design` run has taken the file up and found the slot of
> § 2.1 empty, so it folded no answer and retired no trail cycle. It applied § 2.1 anyway, on the
> authorization its own rule gives a change in the evidence: the product's own source is an AppKit
> shell with no web engine (`README.md:L46-L48`; `nozoki-mac/`). `DESIGN.md` is at v11 and reads
> Draft while this file is on disk; what moved is recorded at its RN-31. § 2.1 is kept as **your
> sign-off on what was applied**. The same run read the shell's source and found two things the
> design language does not rule on. They are § 1.1 and § 2.2, and neither is applied: `DESIGN.md`
> says nothing new about either until you answer.

---

## 1. Open issues

### 1.1 The application ships an icon that no document designs, and the one on disk is a plain blue square — is the icon the design language's, and what is it?
- **Why it matters:** `docs/DESIGN.md` governs the one window (its frontmatter `description:`), and
  § Overview now says so: "Nothing the window draws is shipped that the machine does not already
  have" (`docs/DESIGN.md:L335-L336`). The icon is the one thing of Nozoki's drawn outside that
  window: in the Dock, in the application switcher, in Finder, and on the disk image a release is
  offered as (`README.md:L17-L18`). It is also the only place a colour that is Nozoki's own
  appears, beside a shell whose confirmed signature is that it has none (`docs/DESIGN.md` RN-2;
  `docs/trail/design/cycle-1.md` § 2.1). Until this is answered the design language has no rule a
  builder or a release can hold the icon to, and the blue square ships as it is.
- **What was searched:** `nozoki-mac/icon.icns` (12662 bytes), rendered on 2026-09-30 with
  `sips -s format png`: one uniform blue field and no figure. It is named as the bundle's icon at
  `nozoki-mac/Info.plist:L11-L12` and copied into the bundle at `nozoki-mac/assemble.sh:L61`. It
  was not drawn for this product's shell: `nozoki@15e8790` adds it as "a byte copy of
  crates/nozoki-app/icons/icon.icns", a file that entered with the earlier host at
  `nozoki@9cc163d`. No document rules on it:
  `git grep -n -i -E "icns|app icon|application icon|CFBundleIconFile|bundle's icon" HEAD -- docs/`
  prints nothing at `nozoki@f287d73`. `docs/trail/design/cycle-1.md` § 2.6 confirms no wordmark, logo or product name
  *in the shell* and does not speak to the icon. The instance holds no shared mark to derive one
  from (`system/experience/visual_direction.md` RN-9), and its direction starts every product
  from "No placeholder asset" (same file, § Overview, line 5).
- **What each answer moves:** *The icon is this document's* — the next run writes its contract
  into `DESIGN.md` (what it shows, in which ink, on which ground) and a drawn asset is owed, which
  this run cannot produce and a design run can. This seat's lean is that one, drawn in the shell's
  own ink on the shell's own surface with no hue, so that the signature holds outside the window
  too. *No icon of its own* — the bundle names no icon file and macOS draws its generic
  application icon; `DESIGN.md` records the absence. *The blue square stays* — it becomes a
  decided value: `DESIGN.md` records the colour and the reason, and RN-2 gains the one exception
  to a shell with no hue of its own.
- **Answer:** <the owner fills this in>

## 2. Choices to confirm

### 2.1 § Overview says the language is realised in AppKit views, with no web engine, no markup and no stylesheet — applied at v11 on the evidence, awaiting your sign-off
- **Drafted into DESIGN.md:** at v11 — § Overview `:L331-L336`, "realised in AppKit views drawn by
  the product's own Swift package, in one macOS window and one process, with no web engine, no
  markup and no stylesheet", and the new paragraph *How the values are read* (`:L338-L345`): a
  `px` is one point; an `em` is its level's own font size; the `rem` is sixteen points, so
  `{spacing.prose-measure}` is 704; a line height with no unit multiplies its level's font size;
  a hex colour is an sRGB value; and a token is defined once in the shell's source and read from
  there. With it: § Typography says each font stack is the token format's name for a platform
  family and that the shell asks the platform for its system font and its monospaced system font
  (`:L447-L450`), and its clipped-row clause reads "the row clips at its end, and the text the
  row holds is the whole name" (`:L484-L485`) where it read "the full name is the row's title";
  § Layout gives the measure as "44rem — 704 points" (`:L513`); § Elevation & Depth spells out
  the shadow's numbers (`:L531`); § Components "Icons" says the shell supplies the ink the glyph
  files leave to `currentColor` (`:L748-L751`); the first Do names "where a surface is drawn" in
  place of "a stylesheet" (`:L758-L759`); RN-1 and RN-19 are brought to the same fact; RN-31
  (`:L1261`) records all of it. **No token value moves**: the frontmatter is revision 10's, byte
  for byte (`diff` of lines 1–296 against `nozoki@da88347`, the v10 commit, prints nothing), and
  the pinned lint reports the counts it reported at v10.
- **Grounds:** the sentence v1–v10 carried stood on `docs/proposal.md` § Styling and on
  `README.md` § Planned stack (`docs/DESIGN.md` RN-1 as it read at v10). The README has no such
  heading now; its § Stack reads "an AppKit shell in Swift (`nozoki-mac`) over a Rust library …
  There is no web engine in it" (`README.md:L46-L48`, since `nozoki@61748fe`), and the shell on
  disk is that package:
  `grep -rn -i -E 'WebKit|WKWebView|\.css|html' nozoki-mac/Sources nozoki-mac/Package.swift nozoki-mac/assemble.sh`
  prints nothing (2026-09-30). The product's own source is first in the design language's
  grounding order, so the sentence follows it without waiting on an answer. Three calls inside
  the fold are this seat's, and they are what your sign-off covers. **The font stacks stay as
  written**, because you confirmed the two families in those words
  (`docs/trail/design/cycle-1.md` § 2.2) and a stack still names its family exactly; the text
  beside them now says how the shell asks for it. **`44rem` stays as written** and the `rem` is
  fixed at sixteen points, so the token keeps its value and its length is one number. **"The
  row's title" is re-said, not dropped**: it was a markup attribute, and what it meant without
  one is that the row clips in the drawing and keeps the whole name as its text;
  `docs/CONTENT.md:L487-L490` already holds that clipping a file name costs nothing.
- **If you override:** *restate the tokens for the native shell* — `fontFamily` becomes the two
  family names and `prose-measure` becomes `704px`; ten typography levels and one spacing token
  change their written value and no drawn size moves; RN-31 records the override and the cycle-1
  § 2.2 wording it replaces. *Keep the CSS sentence* — `DESIGN.md` then disagrees with
  `README.md` § Stack and `docs/SDD.md` § 2, and that is theirs to reconcile through their own
  runs.
- **Confirm or override:** <"confirm", or "override: <what to do instead>">

### 2.2 The window's title bar: the platform's own, carrying its three window buttons and no drawn title; the window's title is the viewed folder's name, never the product's
- **Drafted into DESIGN.md:** nothing yet — this is proposed, and applied only if you confirm. The
  rule proposed, for § Layout beside the chrome's line (`docs/DESIGN.md:L504`): *the window keeps
  the platform's own title bar, which carries the platform's three window buttons and draws no
  title; the chrome is the strip beneath it and is where the folder is named. The window's title
  — what the system shows in its own window lists — is the viewed folder's name; on the startup
  surface, where there is no folder, it is the product's name, and it is drawn there no more than
  anywhere else.*
- **Grounds:** the design language draws the chrome as "one strip across the top"
  (`docs/DESIGN.md:L504-L506`) and says nothing of the title bar above it:
  `git grep -n -i -E "title bar|titlebar|window title|window's title" HEAD -- docs/` at
  `nozoki@f287d73` prints no rule, only one line of a trail recording what a build showed
  (`docs/trail/sdd/cycle-8.md:38`, "one window titled "Nozoki""). The shell as built draws a standard titled
  window and titles it "Nozoki" (`nozoki-mac/Sources/Shell/WindowPresenting.swift:L45`, `:L48`).
  You confirmed "no wordmark, logo, or product name in the shell"
  (`docs/trail/design/cycle-1.md` § 2.6; `docs/DESIGN.md:L574-L575`, RN-9), and `docs/CONTENT.md`
  reads that as "the shell carries no product name at all" (`docs/CONTENT.md:L144`); whether the
  title bar is the shell is the thing nobody wrote down. The proposal follows § Overview's own
  order for a case no rule covers (`docs/DESIGN.md:L355-L358`): only what the job puts on the
  surface, so the folder and not the product; the way macOS draws it, so the platform's title
  bar and buttons; fewer elements, so the folder is named once, in the chrome, which is the
  control that names it (`docs/UXD.md` § 4, UX-F5).
- **If you override:** *draw the folder's name in the title bar* — the folder is named twice, in
  the bar and in the chrome beneath it. *Make the chrome the title bar* — the window's content
  runs under a transparent bar and the three window buttons sit at the chrome's left end;
  § Layout's chrome line changes (the selector starts to the right of the buttons, and the 36px
  height is re-checked against them), and whether the window can be built that way is the SDD's
  to answer before it is written here. *Keep "Nozoki" as the drawn title* — RN-9 and the wordmark
  Don't gain their one exception, and `docs/CONTENT.md:L144` no longer reads true.
- **Confirm or override:** <"confirm", or "override: <what to do instead>">

## 3. Raised from downstream — an item from a seat that did not write the design language

None.
