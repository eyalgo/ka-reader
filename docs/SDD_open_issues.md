# SDD open issues — ka-reader

> Companion to `SDD.md`. The CTO wrote the SDD; this file holds what that run could not settle from
> its inputs (the PRD, the SRS, the UXD, and any context or constraints), and the calls that are the
> CPO's or the CDO's to make. An item whose call is the CPO's or the CDO's carries that seat's
> `Seat:`; an item whose call is the CTO's carries `cto` or no `Seat:` field.
>
> **Answer inline** — fill each **Answer** / **Confirm or override** / **Keep or re-cut** /
> **Your call** slot — **commit this file**, then re-run `product-sdd`. It folds your answers into
> the SDD and drops the resolved items. When nothing is left open, `product-sdd` **deletes this
> file**: no file = the SDD is done.
>
> Your answers are never thrown away. Each time `product-sdd` folds them in, it first copies this
> file whole to `docs/trail/sdd/` — so what you decided, and why, stays readable and citable for good.
>
> **An item may name the seat that answers it.** Any item in any section carries an optional
> `- **Seat:** <seat>` field beside its other fields. Its value is the name of the agent whose posture
> answers the item — `cto`, `cpo` or `cdo`. An item with no usable value, whether the field is absent,
> empty or still the `<seat>` placeholder, is answered in the seat of the skill that produced this file.
> The field names the *answering* seat. It is not the seat that raised the item (`Raised by:` /
> `Held by:`), and it is not the document an answer belongs to.
>
> **An item in §§ 1–3 names the seat that raised it.** An item the CPO raised is a product call and
> an item the CTO raised is a technical one, and the answer that settles one does not settle the
> other. **§ 4 names two seats and no raiser** — a
> disagreement is not something one seat asked, it is two positions held by different seats, and the
> answer that settles it picks between them.
>
> **§ 5 names a raiser from outside the SDD's lanes entirely.** §§ 1–4 are all the SDD's own three
> lane seats; § 5 is a seat that never held a lane in it, reading it long after it settled and
> finding something only the SDD can fix. Its `Raised by:` therefore takes a wider set than §§ 1–3's,
> which stay fixed to the three lane seats on purpose.

> **No `product-sdd` run wrote this file.** The PM opened it on 2026-11-08, reading the settled SDD
> (v80) against the product at `ka-reader@ac8951f`, where the placeholder box gained its canvas surface
> and rounded outline. Two items follow in § 5; the SDD is not edited.

---

## 1. Open issues — questions with no answer yet

None.

## 2. Choices to confirm — a best-effort answer was drafted; confirm or override

None.

## 3. Cut calls to confirm — where the slicing could reasonably have gone another way

None.

---

## 4. Disagreements — two seats hold different positions and neither yields

None.

## 5. Raised from downstream — an item from a seat that did not write the SDD

### 5.1 `surfaces`' layout form and § 6 S-3 still call the placeholder box an undrawn cell
- **Raised by:** PM — 2026-11-08
- **Seat:** cto
- **Tracked by:** `ka-reader · nemawashi · 2026-10-02_markdown-reads-rendered`
- **What it blocks:** nothing is blocked; two passages say the opposite of the tree.
- **Where it shows:** § 3, the `surfaces` row, *The Markdown page's layout form* (`docs/SDD.md:L537`): "a
  placeholder box is an `NSTextBlock` with a one-point border and padding … (`:L322-L340`)", and "**The
  placeholder box is the one cell the build has not settled — a known defect at `ka-reader@ffce34d` until a
  change of `read-markdown` lands:** it draws neither `{colors.canvas}` nor `{rounded.sm}` … `appendBox` sets
  `CodeColors.surface` (`MarkdownPageView.swift:L328`) and no radius"; and § 6 S-3 (`:L2276-L2277`), "the
  placeholder box's canvas and radius the known defect the row states". At `ka-reader@ac8951f` the box is a
  `PlaceholderBoxBlock` (`ka-reader-mac/Sources/Surfaces/PlaceholderBoxBlock.swift`), built by `appendBox`
  (`ka-reader-mac/Sources/Surfaces/MarkdownPageView.swift:L323`) with `CodeColors.canvas`, a one-point
  `CodeColors.line` border on every edge and `{spacing.md}` (12 points) of padding, filling and stroking one
  rounded outline at `{rounded.sm}` in `drawBackground(withFrame:in:characterRange:layoutManager:)`; the
  attribute-level tests hold the canvas, the border and the padding under both appearances
  (`ka-reader-mac/Tests/SurfacesTests/MarkdownPageTests.swift:L241`, `:L256`). The outline itself is held by
  no test and is the release walk's (§ 11 R-11). The row's locators into `MarkdownPageView.swift` have moved.
- **If a document has to be written:** none — both passages are re-measured at the new pin, the old reading
  kept as a dated note.
- **Answer:** Confirmed with addition. Both passages are re-measured at `ka-reader@ac8951f` and the `ffce34d` reading is kept as a dated note. What the row states as built: the box is a `PlaceholderBoxBlock` (`ka-reader-mac/Sources/Surfaces/PlaceholderBoxBlock.swift`), an `NSTextBlock` subclass that `appendBox` builds with `CodeColors.canvas` and `CodeColors.line` (`ka-reader-mac/Sources/Surfaces/MarkdownPageView.swift:L323`), carrying a one-point border, `{spacing.md}` (12 points) of padding and no margin on every edge (`PlaceholderBoxBlock.swift:L27-L29`); it fills and strokes one rounded outline at `{rounded.sm}` (3 points) in `drawBackground(withFrame:in:characterRange:layoutManager:)`, inset by half the hairline so the stroke lies inside the frame, resolved in the appearance the view draws under, and never calls `super` — a text block has no radius property and its own `drawBackground` draws the border square (`:L37-L56`); the same hook `CodeBlockSurface` draws its fill in. The attribute-level tests hold the canvas, the hairline and its `{colors.line}` colour on every edge, and the padding, in both appearances and in every placeholder condition, and the zero margin in a list item (`ka-reader-mac/Tests/SurfacesTests/MarkdownPageTests.swift:L222-L237`, `:L241`, `:L256`); the drawn outline — the fill and the radius on screen — is asserted by no test and is § 11 R-11's release walk, as the passage already says of geometry. Three clauses move, not two: the known-defect sentence; the passage's later clause "the placeholder box's canvas and radius are what the known-defect sentence above still names"; and § 6 S-3's closing clause. The row's "the same hook that draws the placeholder box's own `{rounded.sm}`" is now true as written and stays. The `e95896f` page locators stay as the dated finding they are; what this fold writes is pinned at `ac8951f`. The box's text ink and type are 5.2's, not this item's. Not decided here: whether the box takes its list item's or quote's indent — its three paragraphs carry a fresh paragraph style with no indent and the block's margin is 0 in every container (`MarkdownPageView.swift:L329-L336`), where the fenced block takes the indent as its left margin; `docs/DESIGN.md` places the box "where the image would be" and states no indent for it (`:L769-L772`), so that is its to state. Reasoning: `docs/trail/sdd/self_answer-89.md` § 5.1.

### 5.2 The placeholder box's text is drawn in an ink and a type `image-placeholder` does not give it, and no passage says so
- **Raised by:** PM — 2026-11-08
- **Seat:** cto
- **Tracked by:** `ka-reader · nemawashi · 2026-10-02_markdown-reads-rendered`
- **What it blocks:** nothing is blocked; the product departs from a settled design token, and no passage of the
  SDD names the departure or the slice that owes it.
- **Where it shows:** `docs/DESIGN.md` `{components.image-placeholder}` gives the box `textColor:
  "{colors.ink-muted}"` and `typography: "{typography.ui}"` (`docs/DESIGN.md:L286-L291`), and § Typography puts
  "placeholders" at `{typography.ui}`, one size (`:L462-L463`). At `ka-reader@ac8951f` `appendBox` draws the alt
  text in `CodeColors.primary` at `PageType.body` and the sentence in `CodeColors.inkMuted` at `PageType.body`;
  only the source line is at `PageType.path` (`ka-reader-mac/Sources/Surfaces/MarkdownPageView.swift:L324-L328`).
  § 3 `surfaces`, *The Markdown page's layout form* (`docs/SDD.md:L537`), names only the box's canvas and radius
  as its known defect, so the text's ink and type are owed by no slice.
- **If a document has to be written:** the SDD names the box's text ink and type as a known defect and the slice
  that owes it — or, if the alt text is meant to read in `{colors.primary}` at the body size, that is
  `docs/DESIGN.md`'s to state (Seat: cdo for that half).
- **Answer:** Confirmed with addition — the first branch. § 3's `surfaces` row, *The Markdown page's layout form*, names the box's text ink and type a known defect at `ka-reader@ac8951f` against `docs/DESIGN.md`, until a change of `read-markdown` lands — the slice that owed the box's canvas and radius owes this, and § 6 S-3's closing clause names it the same way. The bar, line by line: `{components.image-placeholder}` gives the box `{colors.ink-muted}` at `{typography.ui}` (`docs/DESIGN.md:L286-L291`; 13px, `:L28-L32`), § Typography puts placeholders at `{typography.ui}` — "the shell speaks at one size" (`:L462-L463`) — and § Components' Rendered Markdown passage puts the source line in `{typography.path}` (`:L771-L772`); so the alt text and the sentence are `{typography.ui}` in `{colors.ink-muted}`, and the source is `{typography.path}` in `{colors.ink-muted}`. Built: the alt text in `CodeColors.primary` at `PageType.body` (15 points), the sentence in `CodeColors.inkMuted` at `PageType.body`, the source in `CodeColors.inkMuted` at `PageType.path` (`ka-reader-mac/Sources/Surfaces/MarkdownPageView.swift:L324-L328`); the source line meets the bar and the other two do not, and no test reads the box's text's ink or font — the tests read the block (`ka-reader-mac/Tests/SurfacesTests/MarkdownPageTests.swift:L222-L237`) and the strings (`ka-reader-mac/Tests/SurfacesTests/MarkdownPageSupport.swift:L78`). The second branch is not taken and nothing is raised on `docs/DESIGN.md`: the design already decides it — the box is the shell speaking, not the reader's prose, under its ink rule that `{colors.ink-muted}` is every word that *describes* rather than *is* (`:L369-L372`); the token has stood since v1 and no reader has found it wrong; and the build's departure records no reason — at `ffce34d` the same lines drew the box on `CodeColors.surface` with 8 points of padding, so the text's ink and type predate the token being read at all. A cycle to confirm a settled token as written is not owed. Not decided here: what the box's first line draws when the alt text is empty — today an empty 15-point line in the block — which is `docs/DESIGN.md`'s to state, as the empty fenced block is. Reasoning: `docs/trail/sdd/self_answer-89.md` § 5.2.
