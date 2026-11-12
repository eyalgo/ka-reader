# DESIGN open issues — KA-Reader

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

> **No `product-design` run wrote this file.** It was opened on 2026-11-11 from the shape of the
> design language's earlier companions, to carry the owner's sign-off of the application icon's
> drawing. `DESIGN.md` § Components, "The application icon", says the figure "is drawn separately
> and recorded in this paragraph once the owner has signed it off". The document is Settled, and
> with no companion on disk a `product-design` re-run reads it as done and has nothing to act on.
> Its one item is in § 3, already answered.

---

## 1. Open issues

None.

## 2. Choices to confirm

None.

## 3. Raised from downstream — an item from a seat that did not write the design language

### 3.1 The application icon's drawing is signed off: an eye
- **Raised by:** owner — 2026-11-11
- **Tracked by:** `ka-reader · nemawashi · 2026-10-30_a-stranger-can-install-the-first-release`
- **What it blocks:** the first tag. The first-public-release station holds that no tag is cut
  while the bundle names the stand-in `ka-reader-mac/icon.icns`, and the owner chose a drawn icon
  over shipping with none.
- **Where it shows:** the signed-off drawing is `docs/design/app_icon.svg`, a 1024-point canvas
  holding the platform's rounded application-icon outline in `{colors.surface}` (`#FBFBFA`) and one
  figure in `{colors.primary}` (`#1E1F22`): an eye drawn as an almond outline with a round pupil,
  nothing else. No other colour, no lettering — the owner first asked for "ka and an eye" and
  dropped the "ka" under the paragraph's no-lettering rule. It was chosen from four candidates
  (option B, "the calm eye") as the quietest and the one that stays clear at 32 points.
- **If a document has to be written:** none. The drawing is the file above; the bundle's
  `icon.icns` is generated from it by the change that replaces the stand-in.
- **Answer:** Signed off (owner, 2026-11-11). Record the figure in § Components, "The application
  icon": KA-Reader's icon is an eye — an almond outline with a round pupil, in `{colors.primary}` on
  `{colors.surface}` — drawn at `docs/design/app_icon.svg`. Every other rule of that paragraph
  stands.

**How it closes.** `product-design` folds it on its next run like any other item here.
