# Self-answer report — `docs/adr/` and `docs/nfdr.md`

## Header

- **Companion:** `docs/architecture_open_issues.md`
- **Document:** `docs/adr/` and `docs/nfdr.md`. The one open item names `docs/nfdr.md` §§ 8, 9 and
  10 and QC-53. It touches no record.
- **Decided by:** `<CORE>/../skills/companion/.claude/skills/companion-self-answer/prompts/rich.md` v1.3.1
- **Date:** 2026-10-28
- **Sources re-read:** None outside this repository. No answer rests on a vendor statement. The
  lint's exit 0 (`Swift files read: 30; banned terms read: 49`), the suite's `50 of 50 passed` and the
  guest's gate run are the PM's measurements (item 3.1, *Where it shows*); this run did not repeat
  them. Everything else was read in this repository at `HEAD` `ka-reader@16b42d1`, whose `checks/`
  equals `cd65c02`'s (`git diff --stat cd65c02 HEAD -- checks` prints nothing):
  - `checks/gate.sh` at `cd65c02` and at `1b32500`, side by side (`git show <sha>:checks/gate.sh |
    grep -n '^run_step'`). At `cd65c02`: version 1.4.0 at `:L2`; the definition at `:L31` and 31
    calls, `:L49` *Toolchain* through `:L123` *Own state*; *Strings check suite* at `:L105`, between
    *No-network suite* `:L104` and *Own state suite* `:L106`. At `1b32500` the same calls sit one line
    higher up to `:L103`, and two lines higher from `:L104` on.
  - `ls checks/tests/*.sh`: fourteen, the thirteen § 9 names and `test_strings.sh`.
    `git diff --name-status 1b32500 cd65c02 -- checks`: `M checks/gate.sh`, `A checks/strings.sh`,
    `A checks/tests/test_strings.sh`. `grep -c "checks/strings.sh'" checks/gate.sh`: 0.
  - `checks/tests/test_strings.sh`: `new_copy_at` (`:L121-L127`) copies `docs/CONTENT.md` and the
    tree's `Sources/Surfaces/`; `expect_clean` (`:L183-L196`); `test_unchanged_catalogue_copy_passes`
    (`:L541-L545`). `grep -nE 'curl|wget|https?://|git (clone|fetch)'` over the lint and its suite
    finds only a URL inside a planted Swift fixture string (`:L410`), so neither fetches.
  - `checks/tests/test_vm_refusal.sh:L237`: QC-64's loop globs `checks/tests/*.sh`, so it covers the
    new suite without a change.
  - `docs/nfdr.md` v67: the header, QC-53 (`:L1542-L1549`), § 8's *Until the card runs the script*
    (`:L1678-L1720`), § 9's suites bullet (`:L2092-L2145`), § 10's QC-53 row (`:L2533`) and the rows
    around it, RN-3 (`:L2567`). A `grep` for *thirteen*, *30 steps*, `strings.sh` and `test_strings`
    found the stale counts only in §§ 8 and 9 and the record notes, which stay as records. The NFDR
    runs to 7,039 lines and was not read whole.
  - `docs/SDD.md` v60, Settled: its `read-only-harness` row (`:L372`) and its v60 Review Note
    (`:L9150-L9225`), which re-measured the same tree at `cd65c02` and left these NFDR sentences to
    this item.

## Items worked

### 3.1 — §§ 8 and 9 count the gate at 30 steps and the harness at thirteen suites, and § 10's QC-53 row names no suite; at `ka-reader@cd65c02` the gate has 31 steps, fourteen suites, and `checks/strings.sh` has its suite

- **Bucket:** 3. Raised from downstream — an item from a seat that did not write these records
- **Verdict:** confirmed with addition
- **Why:** Fold it as the item proposes, with two additions.

  **Whose it is, and what was handed.** Every change it calls for lands in `nfdr.md`, which is the
  document this companion belongs to. It commits nothing to a person or an outside party, and I can
  name no ground I cannot see. So check 1 puts it in the Principal Architect's seat, answered here in
  the owner's. The item's *If a document has to be written* line is a lean: re-measure, re-pin, name
  the suite, keep the old readings. I treated it as a draft to weigh, not answered from scratch. It is
  one question with a wide consequence, not two, so it does not split.

  **Not a widening.** Every sentence it moves was true at `1b32500` and is a stale count at
  `cd65c02`. § 9 says itself that an added suite is "a re-measurement" of those sentences. Naming
  the suite in QC-53 adds no requirement either: QC-53 already binds the tree, and the item cites the
  occurrence, which is the suite file and its step at `checks/gate.sh:L105`. The precedent is the
  same: v67 named `test_secret_scan_planted.sh` in QC-28 and its § 10 row on the same grounds (RN-78).

  **Check 2: the draft is right but incomplete in two places.**
  1. *The locator shift is wider than the item says.* It says every locator "after `:L104`" moved by
     one. Comparing the two scripts shows that the new version line at `:L2` moved **every** locator
     by one, and those after the new step by two. Examples: *Secret scan suite* `:L49`→`:L50`,
     *Planted secret suite* `:L67`→`:L68` (its comment `:L61-L66`→`:L62-L67`), *Bundle probe suite*
     `:L85`→`:L86`, *Own state suite* `:L104`→`:L106`, and the last three suites
     `:L107-L109`→`:L109-L111`. A fold that re-pinned only what the item named would leave § 8's
     reading and most of § 9's thirteen locators one line off. The item's supporting text is wrong on
     this one point, and that is reported here rather than corrected in the item.
  2. *How the lint reaches the gate is not said.* No step runs `checks/strings.sh` itself. Naming the
     suite beside the script, the way QC-28 does, would read as if both run as steps. The lint
     reaches the gate only because the suite's `test_unchanged_catalogue_copy_passes` runs the real
     lint over a fresh copy of the tree's own catalogue and `docs/CONTENT.md`, and fails on a non-zero
     exit or a `QC-53` line. So a banned term in the catalogue turns *Strings check suite* red, and
     that is what holds QC-53's *CI build* gate today. QC-53's tail should say this.

  **Check 3.** Nothing settled contradicts the answer, and one settled document requires addition 2.
  SDD v60 (Settled) already says the lint "is in no step of its own and reaches the gate through its
  suite" (`docs/SDD.md:L372`). An NFDR whose tail implies a lint step would disagree with it. § 8's
  sentence "Two steps reach the network on every run" stays true, because neither the lint nor its
  suite fetches. The SDD fold named the new step as fetching nothing, and the answer has § 8 do the
  same, so a reader counts it. No ADR is owed. Naming a check that already verifies an existing
  obligation is undone with one line, which fails the significance test. No `QC` is added. I went
  back over my own earlier answer (`self_answer-62.md`, QC-28's control) and this one matches it.

  **Check 4.**
  - *Stale:* the copy is taken from the tree at each run (`new_copy_at`, `:L121-L127`), so the
    suite reads the current catalogue, not a frozen one. The counts and locators stay dated pins, so
    the next added step is a re-measurement and not a contradiction, as § 9 already says.
  - *Absent:* if the suite's case is ever removed, the lint reaches no gate and QC-53's tree half
    stops being checked. Naming that one case in QC-53's tail is what makes this visible to a
    reviewer. Whether the lint should also get a step of its own is not asked here, and I do not
    raise it. No failure has been seen, and the SDD left it open too.
  - *Refused:* if the lint exits non-zero, or prints a `QC-53` line, the suite goes red and the gate
    stops at *Strings check suite*.
  - *Empty and concurrent:* not reached. The catalogue is not empty (`Swift files read: 30`), and
    the step adds no fetch, so it shares nothing with another run.

  **What would have tipped it.** I came close to a plain **confirmed**, treating the locator count as
  the fold's own detail. What decided it is that the fold re-pins from the item's text. An item that
  says "after `:L104`" invites a partial re-pin, and the mismatch shows up on the first comparison.

## Left for the owner

None this run.

## Skipped

None this run.

## Companions opened

None this run.

## Launchers owed

- **`docs/adr/` and `docs/nfdr.md`** — `<CORE>/launchers/skill/launcher.sh product-architecture ka-reader`
