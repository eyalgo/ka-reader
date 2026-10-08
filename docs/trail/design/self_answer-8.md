# Self-answer report — DESIGN.md

This report records the path-line placement decision for the owner and the CDO run that folds
`docs/DESIGN_open_issues.md` § 3.1.

## Header

- **Companion:** `docs/DESIGN_open_issues.md`
- **Document:** `docs/DESIGN.md`
- **Decided by:** `decide_companion_answers.md` v1.3.0
- **Date:** 2026-10-02
- **Sources re-read:** None. The answer rests on the product's design language, UXD and cited source.
- **Inputs read:** DESIGN Settled · UXD Settled · Writing bar Draft

## Items worked

### 3.1 — Where the path line's text stands, vertically, inside its row

- **Bucket:** 3. Raised from downstream — an item from a seat that did not write the design language
- **Verdict:** answered
- **Why:** Centre the path text vertically in its own row. This is a decision from scratch:
  the item presents three alternatives and calls the existing placement a placeholder
  (`docs/DESIGN_open_issues.md:L38-L48`).

  **Seat.** The edit belongs in DESIGN's reading-panel contract, where the path line's
  typography and row height already live (`docs/DESIGN.md:L207-L212`, `L658-L672`).
  The UXD places the path with the content and requires the same path line across the
  reading treatments (`docs/UXD.md:L104-L106`, `L423-L424`).
  Reasoning: choosing placement within that existing row requires no product-scope change,
  outside commitment or reserved owner choice, so this run answers it in the CDO seat.

  **Framing and choice.** The path level is 12 with a line-height multiplier of 1.5,
  and the row is 24 (`docs/DESIGN.md:L45-L49`, `L90-L90`, `L207-L212`).
  DESIGN defines a unitless line height as a multiplier and a px as a point
  (`docs/DESIGN.md:L341-L346`).
  Calculated from those tokens, the line box is 18 points and equal remaining space is
  3 points above and below it. Those are derived dimensions, not new tokens.
  Reasoning: equal space places this single identifying line within its row without
  adding a baseline dependency on another pane. A shared baseline would couple the path
  level to tree rows that use a different type level (`docs/DESIGN.md:L28-L32`,
  `L45-L49`, `L161-L166`). Top alignment would put all remaining space below the
  line; I prefer equal space for this row. A documented requirement to align these
  separate panes by baseline would have tipped the choice.

  **Settled record.** The contract keeps the hairline below the path row, and the same
  path line serves code, rendered Markdown, raw source and diff
  (`docs/DESIGN.md:L658-L672`). The answer uses those existing tokens and one treatment.
  The cited implementation centres the text field's frame
  (`ka-reader-mac/Sources/Surfaces/ReadingPanelView.swift:L96-L112`).
  That source establishes the constraint, not a measurement of the rendered line box:
  the nominal 18-point line height above is token arithmetic. No rendered-position
  measurement is claimed by this report.

  **Failure paths.** Empty text, cannot-display, an observed failed read and an unexplained
  fault retain the path under DESIGN's existing state rule; no-file and selected-file pending
  have no path row to align (`docs/DESIGN.md:L658-L668`).
  Reasoning: centring depends on the path row, not on whether readable content follows it,
  so those outcomes need no different placement. A long path stays a single line under
  the row's no-wrap contract (`docs/DESIGN.md:L609-L625`); clipping its width leaves
  the vertical treatment the same. Both themes use one system and the same path type
  (`docs/DESIGN.md:L364-L367`, `L658-L662`).
  For replacement selection and obsolete replies, the existing path-visibility rule
  governs whether the row appears; centring adds no exception
  (`docs/DESIGN.md:L663-L668`).
  Live refresh retains the reader's place under UX-I3
  (`docs/UXD.md:L256-L258`).
  Reasoning: these checks settle the cited path occurrence. They do not require a second
  decision about the other list rows.

## Left for the owner

None this run.

## Skipped

None this run.

## Companions opened

None this run.

## Launchers owed

- **docs/DESIGN.md** — `/Users/eyalgolan/projects/kensai/kensaiapp-dev/core/launchers/skill/launcher.sh product-design ka-reader`
