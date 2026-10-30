# SDD open issues — KA-Reader

> Companion to `SDD.md`, for the CTO and the seats answering its items. Answer inline, commit
> this file, then re-run `product-sdd`. It preserves the answered companion under
> `docs/trail/sdd/`, folds the answers and deletes this file when no item remains.

## 1. Open issues — questions with no answer yet

None.

## 2. Choices to confirm — a best-effort answer was drafted; confirm or override

None.

## 3. Cut calls to confirm — where the slicing could reasonably have gone another way

None.

## 4. Disagreements — two seats hold different positions and neither yields

None.

## 5. Raised from downstream — an item from a seat that did not write the SDD

### 5.1 The selector's isolation check includes the earlier diff and history work

- **Raised by:** Principal PM — 2026-10-30
- **Seat:** cto
- **Tracked by:** `ka-reader · nemawashi · 2026-10-30_the-selector-check-measures-its-own-change`
- **What it blocks:** A downstream cut of `switch-the-folder` with a command bar that measures
  the selector's change alone, preserving SRS NFR-12 and FDR PD-29.
- **Where it shows:** `SDD.md` § 6 S-10 *Reached when*, command half (`:L2513-L2516`), uses
  `git diff --stat <first-public-release tag>..HEAD -- ka-reader-mac` and admits only selector
  and launch-restore files, with no tree, Git-view or reading-panel file. The same SDD's S-8
  adds the diff treatment after S-7's first release (`:L2384-L2394`), S-9 adds history in the
  Git view and a commit's diff in the panel (`:L2432-L2448`), and S-10 prefers to land last
  (`:L2537-L2542`; § 7). Reasoning: the tag-to-HEAD comparison accumulates those intervening
  surfaces and cannot identify the selector change's own reach. Please settle the comparison
  that proves the stated isolation without changing the delivery order or weakening NFR-12.
  `nfdr.md` QC-19 carries the same comparison and is separately raised on
  `architecture_open_issues.md` § 3.1 so its producer follows the settled SDD.
- **If a document has to be written:** No additional document; revise this command bar through
  `product-sdd`, and record any order change through the SDD's existing re-cut mechanism.
- **Answer:** <the CTO fills this in>
