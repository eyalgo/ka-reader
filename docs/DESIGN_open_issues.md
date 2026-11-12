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

---

## 1. Open issues

None.

## 2. Choices to confirm

None.

## 3. Raised from downstream — an item from a seat that did not write the design language

### 3.1 "The application icon" names the stand-in at a path the tree no longer holds
- **Raised by:** PM — 2026-11-12
- **Tracked by:** `ka-reader · nemawashi · 2026-10-30_a-stranger-can-install-the-first-release`
- **What it blocks:** nothing is built wrong; the sentence describes where the stand-in lies, and a reader following it finds nothing there.
- **Where it shows:** § Components, "The application icon" says "the uniform blue square at `ka-reader-mac/icon.icns` is a leftover of an earlier host and is never a decided value" (`docs/DESIGN.md:L891-L892`). At `ka-reader@03bb989` that path is gone (`ls ka-reader-mac/icon.icns` → "No such file or directory"); the bundle's icon is generated from `docs/design/app_icon.svg`, and the stand-in's bytes survive only as a check's fixture, `checks/fixtures/stand-in-icon.icns`, which `checks/bundle.sh` refuses in a bundle. The sentence should say that the stand-in survives only as that fixture, the rule "No stand-in ships" unchanged. RN-44's and the history notes' mentions of the old path (`docs/DESIGN.md:L1541`, `:L1575`) are records of their day and need no change.
- **If a document has to be written:** none.
- **Answer:** Confirmed, with two additions. Replace the clause in § Components "The application icon" so it says: the uniform blue square the bundle carried before the icon was drawn is never a decided value; its bytes are kept only as the icon check's control, at `checks/fixtures/stand-in-icon.icns`, and `checks/bundle.sh` refuses a bundle that carries a copy of them. "No stand-in ships", the drawn icon, and "the bundle's icon is generated from that file (RN-44)" stay as written. Addition 1: say *why* the bytes still exist (they are the check's control), so a reader who finds the fixture does not take it for a second icon. Addition 2: besides RN-33 (`docs/DESIGN.md:L1541`, `:L1575`), RN-34's "the bundle as built still names the blue square" (`:L1630`) is also a record of its day and does not move. Record this fold in a new review note. Measured: `ka-reader-mac/icon.icns` was removed at `ka-reader@338288d`, which is on main; the fixture matches the removed file byte for byte; `Info.plist` still names `icon.icns`, which is now the generated one. Reasoning: `docs/trail/design/self_answer-13.md` § 3.1.

**How it closes.** `product-design` folds it on its next run like any other item here.
