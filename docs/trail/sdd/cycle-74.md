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
> (v79) against the product at `ka-reader@ffce34d`, where a folder link became an *external* node and
> both code cells gained their canvas surface. Three items follow in § 5; the SDD is not edited.

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

### 5.1 *What the system holds*, `MarkdownDocument`, still names the folder link a known defect that is now built
- **Raised by:** PM — 2026-11-08
- **Seat:** cto
- **Tracked by:** `ka-reader · nemawashi · 2026-10-02_markdown-reads-rendered`
- **What it blocks:** nothing is blocked; the passage says the opposite of the tree.
- **Where it shows:** § 3 *What the system holds*, `MarkdownDocument` (`docs/SDD.md:L757-L765`): "At
  `ka-reader@e95896f` this is a known defect until a change of `read-markdown` lands: `link_target` makes a
  *relative* node for any entry the check reaches … pinned by
  `test_a_relative_link_carries_the_entry_the_check_reached_whatever_its_kind`". At `ka-reader@ffce34d`,
  `link_target` makes *relative* only for a contained file and *external* for a folder
  (`crates/ka-reader-core/src/markdown_renderer/references.rs`, both `EntryKind` arms), held by
  `test_a_link_the_check_reaches_at_a_folder_is_external_with_its_destination`
  (`crates/ka-reader-core/tests/markdown.rs:L551`); `grep -rn whatever_its_kind crates` prints nothing.
- **If a document has to be written:** none — the sentence is re-measured at the new pin, the old reading kept as a
  dated note.
- **Answer:** Confirmed, with an addition. Re-measured at `ka-reader@ffce34d`: `link_target` answers *relative* for a contained file and *external* for a folder (`crates/ka-reader-core/src/markdown_renderer/references.rs:L96-L101`, both `EntryKind` arms), held by `test_a_link_the_check_reaches_at_a_folder_is_external_with_its_destination` (`crates/ka-reader-core/tests/markdown.rs:L551` — four folder destinations and a symlink to a folder external with the destination as written, a symlink to a file relative with the path the check reached); `grep -rn whatever_its_kind crates` prints nothing; and the page makes a control of a *relative* node alone — the `.link` attribute is set under `case .relative` and nowhere else (`ka-reader-mac/Sources/Surfaces/MarkdownPageView.swift:L282-L283`) — so a folder link draws as no control, which UX-I12 asks. The known-defect sentence is re-measured at that pin as built, and the `e95896f` reading stays as a dated note. The addition, in the same passage: its closing clause still says ADR-0025 binds the set and that its link sentence "moves with this — the Principal Architect's, raised as `docs/architecture_open_issues.md` § 3.2"; that has moved. ADR-0025 reads *Superseded by ADR-0026*; ADR-0026 (*Accepted*, 2026-11-07) states a relative link as a contained file's path and a folder as external; and `docs/architecture_open_issues.md` is no longer in `docs/`. So the clause names ADR-0026 as the record that binds the set and the link sentence, with the raise as history in the dated note. Full reasoning: `docs/trail/sdd/self_answer-88.md`.

### 5.2 `surfaces`' layout form and § 6 S-3 still call both code cells undrawn
- **Raised by:** PM — 2026-11-08
- **Seat:** cto
- **Tracked by:** `ka-reader · nemawashi · 2026-10-02_markdown-reads-rendered`
- **What it blocks:** nothing is blocked; two passages say the opposite of the tree.
- **Where it shows:** § 3, the `surfaces` row, *The Markdown page's layout form* (`docs/SDD.md:L536`): "The code
  cell is not settled by the build — a known defect at `ka-reader@be1d368` … with the drawing at the pin the
  defect"; and § 6 S-3 (`:L2259-L2260`), "the code cell's drawing a known defect the row states". At
  `ka-reader@ffce34d` both forms the row names are built: the fenced block in
  `ka-reader-mac/Sources/Surfaces/CodeBlockSurface.swift`, inline code through
  `ka-reader-mac/Sources/Surfaces/MarkdownPageLayoutManager.swift`, the canvas as `CodeColors.canvas`
  (`CodeTokens.swift`), held by the attribute-level tests in
  `ka-reader-mac/Tests/SurfacesTests/MarkdownPageTests.swift:L320-L531`. The placeholder box's clause in the same
  passage stays true at that pin: `appendBox` still sets `CodeColors.surface` and no radius
  (`MarkdownPageView.swift:L328`).
- **If a document has to be written:** none — both passages are re-measured at the new pin; the box's clause stays.
- **Answer:** Confirmed, with three additions. Re-measured at `ka-reader@ffce34d`: every paragraph of a fenced block sits in one `CodeBlockSurface` — an `NSTextBlock` subclass carrying `CodeColors.canvas`, `{spacing.xs}` of padding, no border and the list or quote indent as its left margin, which draws its own rounded fill at `{rounded.sm}` in `drawBackground(withFrame:in:characterRange:layoutManager:)` (`ka-reader-mac/Sources/Surfaces/CodeBlockSurface.swift`; built once per code node, `MarkdownPageView.swift:L357-L366`); an inline code run carries the canvas as its `backgroundColor` attribute and a marker attribute (`MarkdownPageView.swift:L262-L267`), and the page's one layout manager, `MarkdownPageLayoutManager`, overrides `fillBackgroundRectArray(_:count:forCharacterRange:color:)` to draw that fill alone as one rounded rect per line fragment and hands every other fill to the default (`MarkdownPageLayoutManager.swift`); `CodeCell.padding` is 4 and `CodeCell.cornerRadius` 3 (`CodeTokens.swift`); the attribute-level tests hold both cells (`ka-reader-mac/Tests/SurfacesTests/MarkdownPageTests.swift:L320-L531`), the empty inline node and the run inside a link, a heading, a list item and a quote among them. So *The Markdown page's layout form* stops calling the code cell a known defect and states both forms as built at that pin, § 6 S-3's closing clause says the same, and the `be1d368` readings stay as dated notes. The additions, all in the re-measured passage. One: the known-defect sentence narrows to the placeholder box alone — `appendBox` still sets `CodeColors.surface` and no radius (`MarkdownPageView.swift:L328`) where `image-placeholder` gives `{colors.canvas}` and `{rounded.sm}` — a known defect at `ffce34d` until a change of `read-markdown` lands. Two: the passage's "insetting the fill by `{spacing.xs}`" reads as shrinking it, and the build does the opposite: the fill is grown outward by the padding on each horizontal side and not vertically (`insetBy(dx: -CodeCell.padding, dy: 0)`; a negative inset moves the sides outward — Foundation `NSGeometry.h:L403-L404`, CoreGraphics `CGGeometry.h:L182-L185`), so the room lies between the glyphs and the fill's edge and never inside them; the passage says "grown by", not "inset by". Three: the override tells a code run's fill from a selection's over the same characters by the marker attribute on the run, `KAReaderInlineCodeRun`, together with the colour handed over matching the run's own background — not by the background attribute alone, which is what "read off the storage at the character range handed over" should name, because a selection over a code run arrives at the same primitive over the same range. Full reasoning: `docs/trail/sdd/self_answer-88.md`.

### 5.3 "Composes with … an emphasis's font" reads two ways: which font does inline code inside an emphasis take?
- **Raised by:** PM — 2026-11-08
- **Seat:** cto
- **Tracked by:** `ka-reader · nemawashi · 2026-10-02_markdown-reads-rendered`
- **What it blocks:** nothing is blocked; two downstream readings of one settled sentence disagreed, and the build
  holds one of them.
- **Where it shows:** § 3, the `surfaces` row, *Stated with the form* (`docs/SDD.md:L536`): "the attribute composes
  with a link's underline … and an emphasis's font". One reading is that a code run inside an emphasis takes the
  emphasis's font with the fill. The other, which the tree holds, is that the fill sits beside the emphasis and the
  run keeps the code font: `inlineCodeInsideAnEmphasisGainsTheFillAndKeepsTheCodeFont`
  (`ka-reader-mac/Tests/SurfacesTests/MarkdownPageTests.swift:L520`) at `ka-reader@ffce34d`. Whether the run should
  take the emphasis's traits is a typography call; `docs/DESIGN.md` `{typography.prose-code}` gives the code font and
  says nothing of emphasis.
- **If a document has to be written:** none in the SDD beyond the sentence; if the run should take the emphasis's
  traits, that is `docs/DESIGN.md`'s to state.
- **Answer:** Answered: the run keeps the code font, and the sentence is re-stated so it reads one way. Inside an emphasis an inline code run takes `{typography.prose-code}` whole — 13px mono, no italic or bold trait — because `docs/DESIGN.md` gives inline code one typography token, "13px mono inside rendered Markdown, inline and fenced" (`:L483-L484`), through one component, `{components.prose-code}` (`:L272-L277`, `:L758-L760`), and neither carries a variant under emphasis; its rule "no italic anywhere except where Markdown source asks for it" (`:L487`) permits italic on the emphasis's prose and requires none of the code run. The build holds this reading: the `.code` case replaces the font the emphasis handed down with `PageType.code` and keeps the other attributes it was handed (`ka-reader-mac/Sources/Surfaces/MarkdownPageView.swift:L253-L267`), held by `inlineCodeInsideAnEmphasisGainsTheFillAndKeepsTheCodeFont` (`ka-reader-mac/Tests/SurfacesTests/MarkdownPageTests.swift:L520`). So the passage's clause becomes: the fill composes with a link's underline and its control (`:L279-L283`), and inside an emphasis the run keeps the code font and takes none of the emphasis's traits — the fill sits beside the emphasis, and the emphasis's font stops at the run's edges. The same rule gives an inline code run in a heading the code font at its own size, not the heading's. Whether the design should ever want an emphasis or heading variant of `prose-code` is `docs/DESIGN.md`'s to state and is not raised here: the token is settled with none, and no reader has found it wrong. Full reasoning: `docs/trail/sdd/self_answer-88.md`.
