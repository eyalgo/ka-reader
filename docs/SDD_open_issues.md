# SDD open issues — nozoki

> Companion to `SDD.md`. Three seats — the CTO, the CPO and the CDO — authored the SDD
> non-interactively in one run; this file holds what that run could not settle from its inputs (the
> PRD, the SRS, the UXD, and any context or constraints).
>
> **Answer inline** — fill each **Answer** / **Confirm or override** / **Keep or re-cut** /
> **Your call** slot — **commit this file**, then re-run `product-sdd`. It folds your answers into
> the SDD and drops the resolved items. When nothing is left open, `product-sdd` **deletes this
> file**: no file = the SDD is done.
>
> Your answers are never thrown away. Each time the seats fold them in, they first copy this file
> whole to `docs/trail/sdd/` — so what you decided, and why, stays readable and citable for good.
>
> **An item in §§ 1–3 names the seat that raised it.** An item the CPO raised is a product call and
> an item the CTO raised is a technical one, and the answer that settles one does not settle the
> other. **§ 4 names two seats and no raiser** — a disagreement is not something one seat asked, it
> is something two seats answered differently, and the answer that settles it picks between them.
>
> **§ 5 names a raiser from outside the run entirely.** §§ 1–4 are all the SDD's own three seats;
> § 5 is a seat that never wrote the SDD, reading it long after it settled and finding something
> only the SDD can fix. Its `Raised by:` therefore takes a wider set than §§ 1–3's, which stay fixed
> to the three authoring seats on purpose.

> **No `product-sdd` run opened this companion. The PM opened it on 2026-09-30.** `SDD.md` is
> Settled at v20 and has no companion on disk, so a `product-sdd` re-run would read it as done and
> find nothing to act on. The companion holds one item, § 5.1. It comes from reading the tree on
> `main` at `nozoki@8e738b7` against `docs/DESIGN.md`: the window S-1 describes is drawn, and it
> departs from `docs/DESIGN.md` at three places no slice's *Reached when* holds.

---

## 1. Open issues — questions with no answer yet

None.

## 2. Choices to confirm — a seat drafted a best-effort answer; confirm or override

None.

## 3. Cut calls to confirm — where the slicing could reasonably have gone another way

None.

---

## 4. Disagreements — two seats hold different positions and neither yields

None.

## 5. Raised from downstream — an item from a seat that did not write the SDD

### 5.1 § 6 names no slice whose *Reached when* holds `docs/DESIGN.md`'s layout and component drawing for the surfaces S-1 draws
- **Raised by:** PM — 2026-09-30
- **Tracked by:** `nozoki · nemawashi · 2026-09-15_open-a-folder`
- **What it blocks:** whether `open-a-folder` is reached by the window as it is drawn now. S-1's
  observable half cites the UXD's screen states and no clause of `docs/DESIGN.md`
  (`docs/SDD.md:L1292-L1316`). § 4 says every token value is `docs/DESIGN.md`'s and that no
  condition there fixes one (`docs/SDD.md:L820-L821`). `choose-a-theme` holds the colour tokens and
  puts "any token value" out of its slice (`docs/SDD.md:L1659`, `:L1685-L1686`). So the three
  places below pass every bar § 6 states, and no later slice is named as the one that lands them:
  1. **The window's width.** The window opens 480 points wide and sets no minimum
     (`nozoki-mac/Sources/Shell/WindowPresenting.swift:L21`, `:L44`), and the sidebar is held at 260
     (`nozoki-mac/Sources/Surfaces/WorkbenchView.swift:L14`, `:L32-L34`), which leaves the reading
     panel at most 220. `docs/DESIGN.md:L487-L489` sets a 720-point minimum width, "below which the
     panel stops being dominant and the product stops being what the PRD says it is". S-1 itself
     traces to the UXD's "sidebar beside a dominant reading panel" (`docs/SDD.md:L1353-L1354`;
     `docs/UXD.md:L65`).
  2. **The tree's own status line.** The empty-folder and failed-root sentences are centred in the
     sidebar (`nozoki-mac/Sources/Surfaces/RootItemsView.swift:L69-L72`, `:L91-L93`).
     `docs/DESIGN.md:L914` (RN-14) says a status message is top-left, glyph-led and never centred.
  3. **The startup surface's routes and message.** The two routes are standard bordered buttons and
     the message has no leading glyph (`nozoki-mac/Sources/Surfaces/StartupView.swift:L67-L68`;
     `grep -n -i 'NSImage\|symbol' nozoki-mac/Sources/Surfaces/StartupView.swift` prints nothing).
     `docs/DESIGN.md:L695-L705` draws the routes as text alone and leads the message with `info` or
     `circle-alert`.
- **Where it shows:** § 6 S-1 `open-a-folder`, *Reached when* (observable) and *Not in this slice*
  (`docs/SDD.md:L1292-L1316`, `:L1361-L1365`); § 6 S-6 `choose-a-theme`, *Not in this slice*
  (`docs/SDD.md:L1685-L1686`).
- **If a document has to be written:** none. What is missing is a sentence in § 6: either S-1's
  observable half holds `docs/DESIGN.md` § Layout and § Components for the surfaces it draws, or a
  named later slice does and S-1 says so under *Not in this slice*. The PM's lean is the second for
  the glyphs and the text-alone routes, which arrive with the token pairs, and no lean on the
  window's minimum width: that one decides whether the reading panel is dominant in the first
  window a stranger sees, and it is the seats' call.
- **Answer:** <the owner fills this in>

**How it closes.** `product-sdd` folds it on its next run like every other item in this file, and
the trail copy and the delete-when-empty behaviour are unchanged.
