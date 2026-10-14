# Self-answer report — `docs/adr/` and `docs/nfdr.md`

## Header

- **Companion:** `docs/architecture_open_issues.md`
- **Document:** `docs/adr/` and `docs/nfdr.md` (one companion for both, by its header's pointer)
- **Decided by:** `<CORE>/../skills/companion/.claude/skills/companion-self-answer/prompts/rich.md` v1.3.1
- **Date:** 2026-10-14
- **Sources re-read:** GitHub, read 2026-10-14. `git ls-remote origin refs/heads/main` prints
  `24be581344cee53ca7741c5b66a9a9bae0623c4b`. `gh run list --repo kensaiapp/ka-reader --branch main
  --limit 3` lists run 38551538187 on `24be581` (2026-10-14T10:43:17Z, `success`) as the newest,
  then 38549778886 on `47e8e6b` (`failure`) and 38501500758 on `3f7a68d` (`success`). 3.1's answer
  relies on these readings for "no hosted run holds `970ad65`". No run log was re-read: the item's
  statement that QC-25's command prints nothing on run 38551538187 follows from that run's commit,
  which does not hold the change that prints the line. Nothing else outside this repository was
  relied on.

**What this run read.** The companion, whole. In `docs/nfdr.md` (v49, 5,428 lines): the header and
section map, QC-25 whole (`:L772-L850`), § 9's suites-as-CI-steps bullet (`:L1623-L1632`), § 10's
QC-25 row (`:L1886`), and the RN passage around `:L5257`. `grep -rn 'L382\|1573-L1577\|L144-L146'
docs/adr docs/nfdr.md` finds the stale locators only at `nfdr.md:L820-L822` and `:L5257-L5258`, and
none in `docs/adr/`. `docs/SDD.md` at v50, through the diff of `ka-reader@a67c257` (C-I3's probe
half and RN-110). In the tree: `checks/bundle.sh` at `0aca57e`, `81734d9`, `fcb2e2f`, `4601cd9`,
`24be581` and `970ad65`, searched for the `printf … "$probe_output"` lines. `checks/tests/test_bundle.sh`
at `970ad65`, `:L625-L665`, `:L1700-L1715`, and every `out-of-grant-read` line; the same file at
`fcb2e2f`, `:L144-L146` and `:L1573-L1577`. `.github/workflows/ci.yml` at `970ad65`, `:L40-L60`.
`git merge-base --is-ancestor 970ad65 origin/main` fails. In the instance: the open station
`ka-reader · shukuba · 2026-10-14_the-hosted-suite-prints-the-control-line` (its *Guardrail* places
recording the reading in the NFDR with the Principal Architect).

## Items worked

### 3.1 — QC-25 still describes a suite that prints no control reading, and cites the wrong `bundle.sh` line

- **Bucket:** 3. Raised from downstream — an item from a seat that did not write these records
- **Verdict:** confirmed with addition
- **Why:** The item is right on both halves, and both are corrections of statements that are now
  false, not widenings. **The seat** is this document's: every edit lands in `docs/nfdr.md`, and the
  answer binds nothing but the NFDR's agreement with the tree and with the SDD, so it is answered in
  the owner's seat. **The facts hold at their source.** The `printf '%s\n' "$probe_output"` line that
  prints the control's report is `checks/bundle.sh:L383` at every commit checked: `0aca57e`,
  `81734d9`, `fcb2e2f`, `4601cd9`, `24be581` and `970ad65`. At `970ad65`, `publish_control_reading`
  (`checks/tests/test_bundle.sh:L629-L644`) counts `out-of-grant-read:` lines, fails on zero or more
  than one, fails when the one line does not match `^out-of-grant-read: (denied|allowed)$`, and
  prints it. The runner forwards the control case's output after its `ok` line (`:L1710`).
  `test_negative_control_missing_read_fails_the_suite` (`:L833`) checks those refusals. So QC-25's
  "prints only `ok` and the case name on success" and its gate "until the change that makes the
  suite's log carry the line lands" describe a tree that has moved on.

  **Check 3, against the settled record.** SDD v50 (`ka-reader@a67c257`, RN-110) has already folded
  the same reading into C-I3, so the NFDR is behind its input. QC-25's
  `(C-I3's *Violated by* at SDD v49; RN-60)` and its trace (`:L846-L848`) re-read at v50. That is
  addition 1. It adds nothing new: the NFDR follows the SDD there. The answer leaves the hosted
  reading unmeasured, as the item asks. That agrees with SDD v50, which names the first `macos-26`
  reading as the line in the first hosted run on `main` that holds `970ad65`.

  **Check 4, on the failure paths.** Three cases needed more than the item gave.
  - *Absent.* The item retires the `development-design` gate on all three paths. For
    `checks/bundle.sh` and `checks/tests/test_bundle.sh` that is right, because the suite now goes
    red. It is not right for `.github/workflows/`. QC-25's command picks the step out by its name,
    `$2 == "Bundle probe suite"`. § 9's bullet holds that the suite runs as a CI step, but no script
    holds the step's name. A rename leaves every check green, and the command then prints nothing,
    which reads the same as the not-yet. The gate is narrowed to that rename or removal rather than
    retired (addition 2).
  - *Stale.* "Empty means not yet" is true only while no hosted run holds `970ad65`. Once one
    concludes *Bundle probe suite* `success`, an empty read is a defect. The entry has to say where
    that boundary is (addition 3). The fold also runs later than this answer. It re-reads
    `origin/main` at its own time and takes the first `macos-26` line if one exists by then
    (addition 5).
  - *Refused.* If the suite step fails, the build is red, and the reading is not read off a red
    run. QC-25 already covers this by "concludes `success`", so it needs no addition.

  **What the item gets slightly wrong.** It asks to correct line 5257 the same way as line 820.
  Line 5257 is inside a review note that records what an earlier run measured at `81734d9`. `:L383`
  was already the line at `81734d9`, so that note mis-read the line on the day it was written. A
  review note is history, so the correction goes in a dated note beside it rather than rewriting it.
  This follows the SDD's own handling of RN-109 at v50 (addition 4).

  **No record is owed.** Nothing here is a new decision, and no ADR cites the stale lines (addition 6).
  **What would have tipped it to plain *confirmed*:** a check that already held the workflow step's
  name. If one existed, the gate could retire whole, as the item asks.

## Left for the owner

None this run.

## Skipped

None this run.

## Companions opened

None this run.

## Launchers owed

- **`docs/adr/` and `docs/nfdr.md`** — `<CORE>/launchers/skill/launcher.sh product-architecture ka-reader`
