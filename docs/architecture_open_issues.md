# Architecture open issues — KA-Reader

> Companion to `adr/` and `nfdr.md`. The Principal Architect authored both records
> non-interactively; this file holds what the run could not settle from its inputs — the SRS, the SDD
> and the FDR.
> **Answer inline** — fill each **Answer** / **Confirm-or-override** slot — **commit this file**, then
> re-run `product-architecture`. It folds your answers into the records and drops the resolved items.
> When nothing is left open, `product-architecture` **deletes this file**: no file = the records are
> done.
>
> Your answers are never thrown away. Each time the Principal Architect folds them in, it first copies
> this file whole to `docs/trail/architecture/` — so what you decided, and why, stays readable and
> citable for good.
>
> **§ 3 is raised, not asked.** These records bind every later change, so the seats that live under
> them find gaps the authoring run could not. § 3 is where such a seat says so, against both records
> — an ADR's binding and an NFDR obligation reach the same file.

> **No `product-architecture` run wrote this file.** The Principal PM opened it on 2026-10-14, from
> the `nemawashi-refine` run answering the retired seed
> `ka-reader · nemawashi · 2026-10-14_the-hosted-suite-prints-the-sandbox-control`, to carry item
> 3.1 below. QC-25 says the hosted reading has not been taken, and it now has been. The records are
> Settled, so without a companion the change would reach no one.

---

## 1. Open issues — questions with no answer yet

None.

## 2. Choices to confirm — the Principal Architect drafted a best-effort answer; confirm or override

None.

## 3. Raised from downstream — an item from a seat that did not write these records

### 3.1 QC-25's hosted reading has been taken on `macos-26` and reads `denied`, but the entry still says it has not been read
- **Raised by:** Principal PM — 2026-10-14
- **Which record:** `nfdr.md` § 2, QC-25: the narrowing passage (lines 806–812), the runner-reading
  passage (lines 827–834) and its tail on the two outcomes (lines 850–852). Also § 10's QC-25 row
  (line 1912).
- **Tracked by:** no seed. It was raised while answering the retired seed
  `ka-reader · nemawashi · 2026-10-14_the-hosted-suite-prints-the-sandbox-control`, whose walk produced the reading.
- **What it blocks:** nothing. But the entry draws a line at a run, and that run exists. QC-25 says
  "**The hosted reading is not yet taken**". It also says "until a hosted run on `main` that holds
  `970ad65` concludes *Bundle probe suite* `success`, an empty read is the measurable *not yet*… From
  that run on, a hosted build… for which this command prints no `out-of-grant-read:` line breaks this
  entry". That run is GitHub Actions run 38577309118 on `main` at `ka-reader@f357008`, created
  2026-10-14T14:04:45Z, on image `macos-26-arm64` 20260907.0351.1, macOS 26.6.2 (25G83). It holds
  `970ad65` (`git merge-base --is-ancestor 970ad65 f357008` → true), and its *Bundle probe suite*
  step concluded `success`. On it, QC-25's own command prints:
  `wall	Bundle probe suite	2026-10-14T14:15:35.9622300Z out-of-grant-read: denied`. By the entry's own
  tail, "a `denied` reading leaves the narrowing standing, re-dated here with the run id and the image
  version, and the first reading on each image version is the one recorded". So this reading is the
  first on that image version. The narrowing passage still dates the narrowing to `macos-14` alone
  (run 35797893381) and says it "has not been read" on `macos-26`.
- **Where it shows:** lines 806–812, which date the narrowing to `macos-14`. Lines 827–834, which
  state the not-yet and its boundary run. Line 1912, the § 10 row, whose "empty read is the not-yet"
  no longer holds on `main`. All measured at `ka-reader@f357008`. SDD § 4 C-I3, which QC-25 traces
  to, is raised the same way in `docs/SDD_open_issues.md` § 5.1.
- **If a document has to be written:** none. This is a fold into `nfdr.md`.
- **Answer:** <the owner fills this in>

**How it closes.** `product-architecture` folds it on its next run like any other item here.
