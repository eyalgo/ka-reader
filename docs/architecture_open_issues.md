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
- **Answer:** <the owner fills this in>

**How it closes.** `product-architecture` folds it on its next run like any other item here.
