# Architecture open issues — KA-Reader

> Companion to `adr/` and `nfdr.md`, for the Principal Architect and the seats answering its
> items. Answer inline, commit this file, then re-run `product-architecture`. It preserves the
> answered companion under `docs/trail/architecture/`, folds the answers and deletes this file
> when no item remains.

## 1. Open issues — questions with no answer yet

None.

## 2. Choices to confirm — the Principal Architect drafted a best-effort answer; confirm or override

None.

## 3. Raised from downstream — an item from a seat that did not write these records

### 3.1 QC-19's comparison must isolate the selector change

- **Raised by:** Principal PM — 2026-10-30
- **Which record:** `nfdr.md` § 1.4 QC-19 and § 10's QC-19 verification-map row.
- **Tracked by:** `ka-reader · nemawashi · 2026-10-30_the-selector-check-measures-its-own-change`
- **What it blocks:** A verification of selector isolation that excludes the earlier diff and
  history features while retaining the unchanged-viewing-surface obligation.
- **Where it shows:** QC-19 (`nfdr.md:L737-L746`) uses
  `git diff --stat <first-public-release tag>..HEAD -- ka-reader-mac`, admitting only selector
  and launch-restore files. `SDD.md` § 6 S-8 and S-9 add reading-panel and Git-view treatments
  after that first release, before S-10's preferred placement; the SDD's same comparison is
  raised on `SDD_open_issues.md` § 5.1. Reasoning: this range includes those intervening changes,
  so it cannot distinguish the selector's own edit from their edits. Re-derive QC-19's
  verification and its § 10 row after the CTO settles the SDD item, keeping NFR-12 and FDR PD-29.
- **If a document has to be written:** No additional document; `product-architecture` folds
  this item into the existing NFDR. No ADR change is requested.
- **Answer:** <the Principal Architect fills this in>
