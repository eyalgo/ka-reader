# SDD open issues — KA-Reader

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

> **No `product-sdd` run wrote this file.** The PM opened it on 2026-10-14, from a `shukuba-refine`
> review, to carry item 5.1 below: a line locator in § 4 C-I3 and RN-109 that is wrong at every
> commit it is read against. The SDD is Settled, so without a companion the correction would reach
> no one.

---

## 1. Open issues — questions with no answer yet

None.

## 2. Choices to confirm — a best-effort answer was drafted; confirm or override

None.

## 3. Cut calls to confirm — where the slicing could reasonably have gone another way

None.

## 4. Disagreements — two seats hold different positions and neither yields

None.

## 5. Raised from downstream — an item from a seat that did not write the SDD

### 5.1 C-I3 and RN-109 cite `checks/bundle.sh:L382` for the control's report, and the line is `:L383`
- **Raised by:** PM — 2026-10-14
- **Seat:** cto
- **Tracked by:** `ka-reader · nemawashi · 2026-10-14_the-hosted-suite-prints-the-sandbox-control`
- **What it blocks:** nothing. A reader who follows the locator lands one line above the
  `printf '%s\n' "$probe_output"` that prints the control's report.
- **Where it shows:** § 4 C-I3, line 903 ("the control's report that `checks/bundle.sh:L382`
  prints"), and RN-109, line 8195 ("`checks/bundle.sh:L382` prints the control's report"). The
  printf is at `:L383` at `4601cd9`, the commit C-I3 pins, and also at `fcb2e2f`, `24be581` and
  `970ad65`. Measured with
  `git show <sha>:checks/bundle.sh | grep -n "printf '%s\\n' \"\$probe_output\""`.
  At `970ad65` the suite prints the control's one reading after its `ok` line
  (`checks/tests/test_bundle.sh:L1710`). C-I3's dated sentence about `4601cd9` still holds for
  that commit. Whether the clause should now say the line is printed is the CTO's call, together
  with the first `macos-26` reading. That reading has not been taken: `origin/main` is
  `ka-reader@24be581`, which does not hold the change.
- **If a document has to be written:** none. This is a fold into `SDD.md`.
- **Answer:** Fold both, in the CTO's column. (1) The locator: `checks/bundle.sh:L382` reads
  `:L383` in § 4 C-I3 and in RN-109, each pinned to the commit it is read at — the `printf '%s\n'
  "$probe_output"` line is `:L383` at `ka-reader@4601cd9`, `fcb2e2f`, `24be581` and `970ad65`
  (`git show <sha>:checks/bundle.sh | grep -n probe_output`), so RN-109's "read at source" sentence
  carried a mis-read locator on the day it was written, and the new revision note says that in those
  words rather than leaving RN-109 as it stands. (2) The clause: C-I3's dated sentence about
  `ka-reader@4601cd9` stays as written, and gains one dated sentence after it — at `ka-reader@970ad65`
  the suite validates the control's report, exactly one line matching
  `^out-of-grant-read: (denied|allowed)$` and the case fails otherwise
  (`checks/tests/test_bundle.sh:L629-L661`), and forwards that one line after the control's `ok` line
  (`:L1710`); so the line owed at `4601cd9` is carried from `970ad65`, and C-I3's *Violated by*
  missing-line case is live from that commit and is enforced by the suite going red, not by a reader of
  the log. (3) The `macos-26` reading is still not taken, and its ground moves: the hosted image now
  reaches *Bundle probe suite* — GitHub Actions run 38551538187 on `ka-reader@24be581`, created
  2026-10-14T10:43:17Z, concluded `success` with that step `success`, and `docs/nfdr.md` QC-25's command
  on it prints nothing, the expected not-yet, because `24be581` does not hold the change — and
  `origin/main` is `24be581` (`git ls-remote origin refs/heads/main`), so no hosted run holds `970ad65`.
  The first `macos-26` reading is that line in the log of the first hosted run on `main` that holds
  `970ad65` and concludes with *Bundle probe suite* `success`, whichever later commit that run is on;
  it is recorded when read, by a later item, and this fold does not wait for it. Nothing else moves: no
  slice, edge, seam or part, and `Status:` stays Settled. The push and the reading are not this
  document's. Reasoning: `docs/trail/sdd/self_answer-57.md` § 5.1.

**How it closes.** `product-sdd` folds it on its next run like every other item in this file, and
the trail copy and the delete-when-empty behaviour are unchanged.
