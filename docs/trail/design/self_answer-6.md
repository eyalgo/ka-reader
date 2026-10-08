# Self-answer report — DESIGN.md

This records the gutter-spacing decision for the owner and the CDO run that folds `docs/DESIGN_open_issues.md`.

## Header

- **Companion:** docs/DESIGN_open_issues.md
- **Document:** DESIGN.md
- **Decided by:** `decide_companion_answers.md` v1.3.0 (`/Users/eyalgolan/projects/kensai/kensaiapp-dev/core/prompts/decide_companion_answers.md:L1-L3`)
- **Date:** 2026-10-01
- **Sources re-read:** No vendor or external-platform source underpins this answer. The local answering prompt above and the CDO's taste boundary were read at their owners (`/Users/eyalgolan/projects/kensai/kensaiapp-dev/core/doctrine/governance/where_taste_appears.md:L19-L34`). The geometry and token evidence below are from this product's own files.
- **Inputs read:** DESIGN Settled · UXD Settled · Writing bar Draft

## Items worked

### 3.1 — The code gutter does not say how much space separates its numbers from the code

- **Bucket:** 3. Raised from downstream — an item from a seat that did not write the design language
- **Verdict:** answered
- **Why:** Answered from scratch: the item offers three readings and proposes none (`docs/DESIGN_open_issues.md:L40-L52`). Choose (b): `{spacing.sm}` right padding inside the existing gutter column, represented as a token reference on `components.code-gutter`. Keep the column's total width, the outer inset and the code's starting edge. This is design judgment about separating an index from the content it indexes, using space already allocated by the language (`docs/DESIGN.md:L84-L89`, `:L664-L670`).

  **Seat.** The answer belongs in this design language: its Code contract owns the gutter width and alignment, and its token presently names colour and typography but no padding (`docs/DESIGN.md:L218-L221`, `:L664-L666`). It changes neither product scope nor an external commitment. No reserved owner preference is named in the item (`docs/DESIGN_open_issues.md:L33-L52`).

  **Framing and occurrence.** The reported contact is supported by the source: a number's right end is `width`, and drawing subtracts only that number's measured width; the scroll view starts at the gutter's trailing edge and text starts at its own x = 0 (`ka-reader-mac/Sources/Surfaces/CodeGutterView.swift:L65-L68`, `:L138-L145`; `ka-reader-mac/Sources/Surfaces/CodeView.swift:L83-L91`, `:L121-L126`). This is a cited occurrence, so the downstream widening rule does not defer the question. The source is evidence of the ambiguity, not an authority to keep zero spacing.

  **Settled constraints.** The chosen padding uses `{spacing.sm}` from the existing rhythm; `{spacing.xl}` remains the column base and `{spacing.lg}` remains the outer inset (`docs/DESIGN.md:L84-L89`, `:L521-L526`, `:L664-L666`). Reasoning: allocating 8 of the 24 points to the right leaves 16 to the left of the widest number, in addition to the panel's outer inset. It gives the index a separate reading position without narrowing the code viewport or introducing another spacing magnitude. A separate gap, reading (c), would be justified by evidence that the existing column cannot accommodate that separation; this item supplies none (`docs/DESIGN_open_issues.md:L40-L50`). The requirement to keep the reading panel dominant and to draw no decorative elements is upstream, and this allocation adds no element (`docs/UXD.md:L65-L66`, `:L395-L400`).

  **Failure paths.** Reserve the padding in the fixed gutter, before the code's clipping boundary: the current layout already puts the gutter outside the scroll view (`ka-reader-mac/Sources/Surfaces/CodeView.swift:L3-L10`, `:L79-L91`). Reasoning: padding there survives horizontal scrolling; padding inside scrolling text could disappear. Size the digit allowance from the current file and keep padding constant through digit-count changes; the source already recomputes that allowance on reload (`ka-reader-mac/Sources/Surfaces/CodeGutterView.swift:L92-L120`). Empty content creates no invented label; a loading or failure surface uses its existing state treatment (`docs/DESIGN.md:L704-L735`). Use the same spacing in both themes, without altering any colour or font. The Diff contract shares this column, so its sign receives the same padding, without introducing a new diff behaviour (`docs/DESIGN.md:L672-L678`). Refresh preserves the reader's place under the existing upstream rule (`docs/UXD.md:L253-L255`); this answer defines spacing, not a refresh or scrolling mechanism.

## Left for the owner

None this run.

## Skipped

None this run. Zero filled slots and zero items addressed to another actor were skipped (`docs/DESIGN_open_issues.md:L31-L54`).

## Companions opened

None this run.

## Launchers owed

- **DESIGN.md** — `/Users/eyalgolan/projects/kensai/kensaiapp-dev/core/launchers/skill/launcher.sh product-design ka-reader`
