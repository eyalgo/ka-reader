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
- **Answer:** Measure the selector contribution between its own before-and-after commits,
  keeping S-10 last in the preferred order and keeping the untouched-viewing-surface bar.
  For each landed selector change, record full commit SHAs for `B`, the destination tip
  immediately before that change, and `T`, the result of landing it. For a merge commit,
  `B` is its first parent and `T` is that merge commit; resolve both to full SHAs in the
  evidence. Run `git diff --stat B T -- ka-reader-mac` and
  `git diff --name-status --no-renames B T -- ka-reader-mac`, substituting those SHAs.
  Check the complete package output: only selector and `mac-shell` launch-time-restore
  files may differ; any tree, Git-view or reading-panel file fails the bar, including a
  deletion or a move. Do not narrow the path filter to allowed files or subtract changes
  from the result. The earlier diff/history work is already in the before state.
  Where S-10 lands through several changes, retain and check every pair that contributes
  to it; the last pair alone does not prove the whole slice, and a broad interval containing
  unrelated work is not the replacement. A pre-landing check may compare a candidate
  against its recorded destination base only when the candidate includes that base and
  its difference contains only the selector contribution; refresh the check if that base
  or candidate changes, and retain the actual landing comparisons, including conflict
  resolutions. Missing commits, a failed command or an unexplained endpoint pair leaves
  the check unproven. Empty output alone does not establish that switching was delivered:
  all existing S-10 observable, command and promise checks still apply.
  This corrects the comparison, not the delivery order or the NFR-12 / PD-29 obligation
  (`docs/SRS.md:L363-L365`; `docs/fdr.md:L303`). Have `product-sdd` fold the replacement
  into S-10 and record the corrected command bar under § 10's existing re-cut rule;
  no shape or seam changes are requested. The separately raised QC-19 correction remains
  with `docs/architecture_open_issues.md` § 3.1.
  Reasoning and failure cases: `docs/trail/sdd/self_answer-70.md`.
