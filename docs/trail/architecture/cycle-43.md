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

> **No `product-architecture` run wrote this file.** The PM opened it on 2026-10-14, from a
> `shukuba-refine` review, to carry item 3.1 below: two statements in `nfdr.md` QC-25 that the tree no
> longer matches. The records are Settled, so without a companion the change would reach no one.

---

## 1. Open issues — questions with no answer yet

None.

## 2. Choices to confirm — the Principal Architect drafted a best-effort answer; confirm or override

None.

## 3. Raised from downstream — an item from a seat that did not write these records

### 3.1 QC-25 still describes a suite that prints no control reading, and cites the wrong `bundle.sh` line
- **Raised by:** PM — 2026-10-14
- **Which record:** `nfdr.md` § 2, the runner-reading passage of QC-25 (lines 815–828), and § 10's QC-25 row (line 1886); also the measured-record passage at line 5257.
- **Tracked by:** `ka-reader · nemawashi · 2026-10-14_the-hosted-suite-prints-the-sandbox-control`
- **What it blocks:** nothing is blocked, but § 2 now gates on a condition that has been met. It says that "until the change that makes the suite's log carry the line lands, `development-design` reading this entry is the gate", and that the suite "prints only `ok` and the case name on success". At `ka-reader@970ad65`, `checks/tests/test_bundle.sh` checks the control's report. It requires exactly one line, `out-of-grant-read: denied` or `out-of-grant-read: allowed`, and prints it after the control's `ok` line (`:L629-L661` validates it, `:L1710` forwards it). A report with no reading, a malformed reading or more than one reading fails the suite, and the case `test_negative_control_missing_read_fails_the_suite` proves those refusals on every run. So the gate that relies on `development-design` reading the entry, and § 10's "until the line prints" wording, describe a tree that no longer exists. Whether this is still unmeasured depends on the hosted image. `origin/main` is `ka-reader@24be581` and does not yet hold the change: `git ls-remote origin refs/heads/main`. QC-25's command on run 38551538187 (`main`, `24be581`, `success`) prints nothing.
- **Where it shows:** two places. First, § 2 lines 819–825 and § 10 line 1886: they should state the suite's one validated control reading and its failure on a missing or malformed report, and retire the gate that rests on `development-design` reading the entry. Keep the observation pinned at `fcb2e2f` as a dated record. Leave the hosted reading unmeasured until a run on `main` that holds `970ad65` is read with QC-25's command. Second, the locator: § 2 line 820 and line 5257 cite `checks/bundle.sh:L382` for `printf '%s\n' "$probe_output"`, but that line is `:L383` at `fcb2e2f`, `4601cd9`, `24be581` and `970ad65` (`git show <sha>:checks/bundle.sh | grep -n "printf '%s\\n' \"\$probe_output\""`).
- **If a document has to be written:** none. This is a fold into `nfdr.md`.
- **Answer:** confirmed with addition — fold both halves as the item says: § 2's runner-reading passage (`:L815-L828`) and § 10's QC-25 row (`:L1886`) state that at `ka-reader@970ad65` the suite requires exactly one line matching `^out-of-grant-read: (denied|allowed)$` in the control's report, fails the case on none, a malformed one or more than one (`checks/tests/test_bundle.sh:L629-L661`, held on every run by `test_negative_control_missing_read_fails_the_suite`, `:L833`), and forwards that line after the control's `ok` (`:L1710`); the `fcb2e2f` observation (`:L144-L146`, `:L1573-L1577`) stays as a dated note; the hosted reading stays unmeasured, because `origin/main` is still `ka-reader@24be581`, `970ad65` is not an ancestor of it, and the newest `main` run, 38551538187, is on `24be581`. Correct the locator to `checks/bundle.sh:L383`, the line at every commit checked, `0aca57e`, `81734d9`, `fcb2e2f`, `4601cd9`, `24be581` and `970ad65`. Additions: (1) QC-25's trace and its `(C-I3's *Violated by* at SDD v49; RN-60)` re-read C-I3 at SDD v50, which already states this (`ka-reader@a67c257`, SDD RN-110), so the NFDR follows its input rather than restating it fresh; (2) retire the `development-design` gate for `checks/bundle.sh` and `checks/tests/test_bundle.sh` only: the suite now goes red on a missing line. A residue stays for `.github/workflows/`. QC-25's command matches the step by its name, `Bundle probe suite`. § 9's suites-as-CI-steps bullet holds that the step exists, but nothing holds its name. A renamed step makes the command print nothing, and that reads the same as the not-yet. So a workflow change that renames or drops that step must change QC-25's command in the same change, and the review of the workflow at `development-design` is that gate; (3) the empty read stops meaning "not yet" once a hosted run on `main` that holds `970ad65` concludes *Bundle probe suite* `success`: from that run on, an empty read breaks the entry; before it, it is still the not-yet; (4) line 5257 sits in a review note recording what an earlier run measured, so it is corrected by a dated note beside it, not rewritten — `:L383` was already the line at `81734d9`, the commit that note names, so the note mis-read it on the day it was written; (5) the fold re-reads `origin/main` and the newest `main` run at its own time: if a run holding `970ad65` has concluded the suite step `success` by then, its line is the first `macos-26` reading, recorded with the run id and image version as QC-25 already says, and otherwise the not-yet stands; (6) no ADR is owed and none cites the stale lines (`grep -rn L382 docs/adr` prints nothing). No `QC` is added. Reasoning: `docs/trail/architecture/self_answer-48.md` § 3.1.

**How it closes.** `product-architecture` folds it on its next run like any other item here.
