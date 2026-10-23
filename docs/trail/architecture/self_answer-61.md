# Self-answer report — `docs/adr/` and `docs/nfdr.md`

## Header

- **Companion:** `docs/architecture_open_issues.md`
- **Document:** `docs/adr/` and `docs/nfdr.md`. The one open item names `docs/nfdr.md` § 8 and § 9.
  Its answer also reaches QC-28, QC-64 and § 10's QC-28 row. It touches no record.
- **Decided by:** `<CORE>/../skills/companion/.claude/skills/companion-self-answer/prompts/rich.md` v1.3.1
- **Date:** 2026-10-23
- **Sources re-read:** the gitleaks README (https://github.com/gitleaks/gitleaks/blob/master/README.md),
  read on 2026-10-23. It says `--exit-code` sets the exit code "when leaks have been encountered
  (default 1)", and that the defaults are "0 - no leaks present", "1 - leaks or error encountered"
  and "126 - unknown flag". So RN-3's sentence is still true of bare `gitleaks git`. Everything else
  the answer rests on is in this repository, read at `ka-reader@8235240`, and `HEAD` `feac758`
  holds the same tree outside `docs/`:
  - `checks/gate.sh`. `:L2-L3` gives version 1.2.0, and `grep -c '^run_step'` prints 30 (29 steps
    plus the definition at `:L29`). *Secret scan suite* is at `:L48`, *Secret scan* at `:L58`,
    *Build the workspace* at `:L59`, *Build KA-Reader.app* at `:L62`, *Test gate* at `:L63`, the
    sanitizer at `:L70`, and the structure pair at `:L71-L72`. The suite steps are at `:L72`, `:L74`,
    `:L77`, `:L79`, `:L89`, `:L93`, `:L95`, `:L96`, `:L99`, `:L100` and `:L101`.
  - `git ls-tree --name-only 8235240 checks/tests/` lists twelve `test_*.sh` and `support`.
  - `checks/secret-scan.sh`: its header (*USAGE*, *.GITLEAKSIGNORE*), `--exit-code 2` at `:L195`,
    the shallow refusal, and the verdicts at `:L213-L228`.
  - `.github/workflows/ci.yml:L21-L23` has the checkout with `fetch-depth: 0`.
  - `git diff --stat 38158f4 8235240` prints nothing, and `38158f4` is an ancestor of `8235240`.
  - `docs/nfdr.md` v65. Read: the header (`:L1-L45`), QC-26 – QC-30 (`:L1049-L1120`), all of § 8
    (`:L1526-L1893`), § 9 through the suites bullet (`:L1895-L2143`), § 10's preamble and QC-28 row
    (`:L2361-L2380`, `:L2427`) and RN-3 (`:L2480-L2496`). The NFDR runs to 6,835 lines and was not
    read whole.
  - `docs/SDD.md` v58 (Settled), RN-118. It carries 29 steps and twelve suites in its
    `read-only-harness` row, and it leaves QC-28's *verified by* and § 8's count to this companion.
  - `docs/trail/architecture/cycle-49.md` § 3.1: the owner's four requirements, none of which
    states a step order.

## Items worked

### 3.1 — §§ 8 and 9 count the gate at 27 steps and the harness at eleven suites; at `ka-reader@8235240` the gate has 29 steps, twelve suites, and `gitleaks git` is one of its steps

- **Bucket:** 3. Raised from downstream — an item from a seat that did not write these records
- **Verdict:** answered
- **Why:** Yes, fold it. Every fact the item states holds when re-read at its source. This is a
  correction, not a widening: §§ 8 and 9 hold counts and locators that are pinned and true at their
  pins, and `8235240` moved them, which § 9 itself calls "a re-measurement of this sentence". The
  item also cites where it occurs: the two steps exist. The change lands in `nfdr.md`, the document
  this companion belongs to. It commits nothing to a person and no ground is hidden from this run, so
  check 1 puts it in the Principal Architect's seat, answered here. The item has no draft, only open
  questions for the fold, so this run answered it from scratch, on all of them.

  Check 3 found no conflict. SDD v58 is Settled and already states the 29 steps and twelve suites,
  and its RN-118 names this item as the owner of QC-28 and § 8. A fetch at gate time is the
  harness's own, as RN-118 says, so SRS NFR-8 is not touched. QC-32 already draws that line for
  `cargo audit`'s databases.

  What the answer adds beyond the item:
  1. **The exception file.** QC-28's tail must say that a finding passes only through a reviewed
     `.gitleaksignore` fingerprint. That is the check's one way through, and without it "exits 0"
     reads as unconditional. This is check 4's *refused* path: a false positive.
  2. **QC-64's order sentence is now false.** It says every `checks/*.sh` script runs after the
     workspace build, and `secret-scan.sh` and its suite run before it. That order was the NFDR's
     own wording for the steps moved from the workflow. The owner's requirements at cycle-49 § 3.1
     name no order. So the sentence is re-worded, and the placement is not treated as a breach.
     This came from the same commit and the same cause as the item, so it rides in the same answer
     rather than as a raised item.
  3. **Two failure paths, named as consequences.** First, *absent*: the vendor archive stops being
     served. The step then fails closed and every change stays red until the pin moves. That is the
     platform dependence the instance's lens asks a record to name. Second, a shallow checkout: the
     script refuses it, so `fetch-depth: 0` is what keeps the hosted run passing.

  Neither path needs a new `QC`. Both already fail red and never read green, which is ADR-0012's
  rule. Under *stale*, the counts stay pinned, and a further step is a re-measurement under § 9's
  own rule. Under *concurrent*, the script refuses to report a count if `HEAD` moved during the
  scan. *Empty* does not apply, because an absent `.gitleaksignore` means no exceptions.

  On the exit-code question the item left open: QC-28's tail should state the script's contract,
  where a finding exits 2 and an error exits 1. RN-3 keeps the vendor default, because it is still
  true of the bare tool.

  On an ADR: none is owed. The step realizes QC-28 at the change, and it is cheap to reverse. I came
  close to proposing one for the per-run fetch from a platform this product does not control. What
  tipped it the other way is that the step fails closed and is undone by moving one pin. Neither
  half is hard to reverse, so the dependence belongs in the NFDR entry's tail, not in a record.

## Left for the owner

None this run.

## Skipped

None this run.

## Companions opened

None this run.

## Launchers owed

- **`docs/adr/` and `docs/nfdr.md`** — `<CORE>/launchers/skill/launcher.sh product-architecture ka-reader`
