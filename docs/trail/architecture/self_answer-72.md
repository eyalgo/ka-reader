# Self-answer report — `docs/adr/` and `docs/nfdr.md`

## Header

- **Companion:** `docs/architecture_open_issues.md`
- **Document:** `docs/adr/` and `docs/nfdr.md` (NFDR v77, Settled; re-opened by the companion a `companion-self-answer` run opened at `ka-reader@5986be5`)
- **Decided by:** `<CORE>/../skills/companion/.claude/skills/companion-self-answer/prompts/rich.md` v1.3.1
- **Date:** 2026-11-06
- **Sources re-read:** None. The one answer rests on this repository only: `docs/SDD.md` at v69 (`ka-reader@b10c7e9`) and `docs/nfdr.md` at v77.
- **Liveness check:** the header names `adr/` and `nfdr.md` as bare names; both are siblings of the companion on disk. Live.
- **What was read:** the companion whole; SDD v69's header lines for v68 and v69, § 6 S-6 whole, the § 6 headings S-1 – S-13, § 10 RC-8 whole, the `surfaces` row of § 3 and RN-127 and RN-132; NFDR v77's header, QC-40's verified-by clause, QC-46's trace, QC-48 whole, § 9's opening paragraph, the three § 10 rows the item names, and every line `grep -n 'S-6\b' docs/nfdr.md` prints; every ADR line that names `S-6` or `follow-the-folder`.
- **Scope:** one item, under § 2 *Choices to confirm*, with a **Confirm-or-override** slot. No item list was given, so it was this run's. It is the Principal Architect's: the change lands in `docs/nfdr.md` and binds only its consistency with the SDD it derives from. It is not the owner's call.

## Items worked

### 2.1 — Live refresh is three SDD slices since v68, and the NFDR's live-refresh obligations still cite `follow-the-folder` as `SDD § 6 S-6` — a number that now names `follow-the-file`

- **Bucket:** 2. Choices to confirm — the Principal Architect drafted a best-effort answer; confirm or override
- **Verdict:** confirmed with addition
- **Why:** The draft is right, and right for the reason it gives. SDD v69 § 6 heads S-6 *The open file follows the disk* (`follow-the-file`) and S-8 *Git follows the disk* (`follow-the-folder`). RC-8 § *Changed* (5) says "S-6 – S-12 become S-7 – S-13; current references follow these numbers, earlier dated notes keep theirs". RC-8 § *Retained* says the NFDR's references to `follow-the-folder` "stay true of the narrowed slice". So each live NFDR line that pairs `S-6` with `follow-the-folder` now points a reader at the wrong slice. The draft's line numbers hold at v77: QC-40 at `docs/nfdr.md:L1499`, QC-46 at `:L1567`, QC-48 at `:L1617` and `:L1623`, § 9 at `:L2353`, and the § 10 rows at `:L2946`, `:L2950` and `:L2952`. Its second half also holds. SDD S-6's command half carries the displayed-file scene: change, delete and recreate the open file, the gone state, the reading position crossing through `select_file`, and two `select_file` calls in both completion orders. Its *Not in this slice* line leaves the churn, the markers, the row-order migration, the latency figure and the built-bundle retention proof to `follow-the-folder`. That is the split the draft proposes. No ADR is owed. ADR-0009 cites `S-6` only at a pinned commit (`ka-reader@70a879a:docs/SDD.md`), which is historical. ADR-0021 uses the slug `follow-the-folder` for the Git push, and that is still the slug's meaning. RC-8 also says "no ADR is owed".

  **Addition (a), § 9.** The draft fixes § 9's `S-5–S-6` citation and misses the sentence it sits in. § 9 opens "Refresh proof follows the two slices in SDD § 6", and it says "The two scene commands and their regression cases enter the product gate under QC-64". Since RC-8 there are three slices and three scenes: the tree scene (S-5), the displayed-file scene (S-6, SDD S-6's own words: "This scene is neither the tree-only scene nor the full `checks/churn.sh` proof") and the full churn (S-8). The fold makes § 9 say three. Each scene enters the gate under QC-64 when its slice delivers, and no scene's pass discharges another's. This is a correction, not a widening: the fact is false at v77 and SDD S-6 states the replacement.

  **Addition (b), QC-48's allowance.** QC-48 says the marker join and the row order "stand in `surfaces` from `see-git-status` through `follow-the-tree` until `follow-the-folder` is reached". It then says "This allowance continues through `follow-the-tree`". When this was written, the next slice was `follow-the-folder`. Now `follow-the-file` and `first-public-release` come between them. A reader could take the allowance as ending at S-5, which would make the beta owe the migration. SDD § 3 `surfaces` ("both end when `follow-the-folder` is reached … § 6 S-8") and RC-8 § *Retained* keep the migration with `follow-the-folder`. So the fold says the allowance runs through S-6 and S-7 and ends at S-8.

  **Check 3.** The draft was written when the SDD was Draft at v68. The SDD has since settled at v69 (`ka-reader@b10c7e9`), and its header says "No slice, edge, seam, part or place in the order moves". So every fact the draft rests on holds at v69, and the fold reads v69. **Check 4, stale.** The answer names its targets by entry and slug, not only by line number, so a fold that finds the lines shifted can still locate every one. Dated review notes keep their old numbers, as RC-8 requires: `:L3327`, `:L3350`, `:L3376`, `:L7749` and `:L7802` are history and do not move. I nearly confirmed the draft without additions, because neither addition changes what any obligation requires. What tipped it is that both are statements the NFDR makes that are now false, and a fold already in that paragraph costs nothing to fix them.

## Left for the owner

None this run.

## Skipped

None this run.

## Companions opened

None this run.

## Launchers owed

- **docs/adr/ and docs/nfdr.md** — `<CORE>/launchers/skill/launcher.sh product-architecture ka-reader`
