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

> **Where this round stands.** `DESIGN.md` is at v12. The three answers of the last round are
> folded and retired whole to `docs/trail/design/cycle-8.md`: the application icon's contract
> (RN-33), the title bar (RN-32), and revision 11's AppKit wording, confirmed as applied. One
> item is here, and it is new: the icon's answer named one case it did not cover, and this file
> raises it. Nothing about it is written into `DESIGN.md`, which reads Draft while this file is
> on disk.
>
> **One thing this file does not ask.** What the icon's figure depicts is drawn in a design run
> and comes back here as a pointer item, written by that run (`docs/trail/design/cycle-8.md`
> § 1.1, its second addition). No item stands in for it meanwhile: the contract in `DESIGN.md`
> is complete without the drawing, and until one exists the rule is that the bundle names no
> icon file.

---

## 1. Open issues

None.

## 2. Choices to confirm

### 2.1 The application icon is one drawing, shown as it is under every system appearance — no second drawing for dark
- **Drafted into DESIGN.md:** nothing yet — this is proposed, and applied only if you confirm.
  The sentence proposed, for § Components "The application icon", in place of its last one
  ("It is one drawing; whether a second is owed for a dark system appearance is not ruled
  here"): *the icon is one drawing, at the light values, and it is shown as it is under every
  system appearance; no second drawing is made for a dark one.*
- **Grounds:** the answer that made the icon this document's fixed its two values as the light
  theme's and named this case as not covered (`docs/trail/design/cycle-8.md` § 1.1, its third
  and fourth additions), so the contract as folded rules one drawing and is silent on a second
  (`docs/DESIGN.md` § Components "The application icon"; RN-33). The case is real on this
  platform: Apple's icon tool produces, from one file, an icon for "different appearances
  (default, dark, and mono)" on macOS
  (https://developer.apple.com/documentation/xcode/creating-your-app-icon-using-icon-composer,
  read 2026-09-30). The call is this seat's, and it is a taste call held by one rule of the
  document: of two treatments that both satisfy it, take the one with fewer elements
  (`docs/DESIGN.md` § Overview, its last paragraph). One drawing is one asset and two token
  values to keep in step; two drawings are two assets and four. The icon is also not a themed
  surface. The window's two themes exist because a reader reads in them (`docs/UXD.md` UX-I9);
  the icon is looked at for a moment, to tell this application from the others, and one
  drawing does that in a light Dock and a dark one. **Not checked by this run:** what macOS
  draws under its dark icon appearance for an application that supplies one drawing only. I
  don't know. The check that would find out is to assemble the bundle with a drawn icon and
  look at it in the Dock with the system's icon appearance set to dark.
- **If you override:** *a second drawing for dark* — the same figure in the dark values of the
  same two tokens, `{colors.primary}` `#E7E7E4` on `{colors.surface}` `#1B1C1E`
  (`docs/DESIGN.md` § Colors, "The two themes"). The contract gains that sentence, the design
  run that draws the figure owes two drawings and the owner signs off both, and the redraw
  rule covers four values where it covers two. The bundle would also have to carry the icon in
  a form that holds more than one appearance, and whether it can is the SDD's to answer before
  the sentence is written here. *Leave it unruled* — the contract keeps its present last
  sentence, and the first design run to draw the icon decides it for the document.
- **Confirm or override:** <"confirm", or "override: <what to do instead>">

## 3. Raised from downstream — an item from a seat that did not write the design language

None.
