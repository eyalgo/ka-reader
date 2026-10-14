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
- **Answer:** <the owner fills this in>

**How it closes.** `product-sdd` folds it on its next run like every other item in this file, and
the trail copy and the delete-when-empty behaviour are unchanged.
