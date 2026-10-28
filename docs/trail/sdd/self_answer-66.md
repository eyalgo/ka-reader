# Self-answer report — `docs/SDD.md`

The record of one unattended run that met `docs/SDD_open_issues.md` in the CTO's seat on 2026-10-28
and decided its one item. It is for the owner, who reads it to learn what was decided and on what,
and for the `product-sdd` run that folds the answer.

## Header

- **Companion:** `docs/SDD_open_issues.md`
- **Document:** `docs/SDD.md` (v59, `Status:` Settled)
- **Decided by:** `<CORE>/../skills/companion/.claude/skills/companion-self-answer/prompts/rich.md` v1.3.1
- **Date:** 2026-10-28
- **Sources re-read:** One. The row's sentence that GitHub Actions is disabled on the repository
  rests on the platform, and the answer repeats it as current, so it was re-read at the source:
  `gh api repos/eyalgo/ka-reader/actions/permissions` → `{"enabled":false,"sha_pinning_required":false}`
  on 2026-10-28; it still holds. The two pinned gitleaks digests are the row's other outside fact and
  the answer does not rest on them (nothing about `secret-scan.sh` moves); they were read at the vendor
  on 2026-10-23 (`docs/trail/sdd/self_answer-64.md` § Header) and not re-read here. Every other claim
  is a file in this repository, read at its own locator in the main checkout, read-only, at
  `ka-reader@28d255d`, whose tree outside `docs/` is `cd65c02`'s (`git diff --stat cd65c02 28d255d
  -- . ':!docs'` prints nothing). Measured: `git diff --name-status 1b32500 cd65c02 -- checks .github`
  → `M checks/gate.sh`, `A checks/strings.sh`, `A checks/tests/test_strings.sh`; `git diff --stat
  1b32500 cd65c02 -- checks/fixtures` → nothing; `git diff 1b32500 cd65c02 -- checks/gate.sh` → one
  line added at `:L2` and one at `:L105`; `cat -n checks/gate.sh` whole (123 lines), giving the line
  map; `grep -c '^run_step' checks/gate.sh` → 32; `ls checks/*.sh | wc -l` → 13; `ls
  checks/tests/*.sh | wc -l` → 14; `ls -d checks/fixtures/*/ | wc -l` → 13; `wc -l
  checks/fixtures/.gitignore` → 6; `wc -l .github/workflows/ci.yml` → 41; `git ls-files -s` on the
  two new files → both `100755`; `checks/strings.sh` whole (505 lines); `checks/tests/test_strings.sh:L1-L36`,
  `:L55-L106` (fifty case names, counted), `:L121-L127`, `:L146-L151`, `:L183-L196`, `:L541-L545`,
  `:L1080-L1099`, `:L1100-L1139`; `grep -n 'support/vm_refusal.sh' checks/tests/*.sh` → the same six
  suites; `checks/tests/test_vm_refusal.sh:L237-L240`; `grep -n 'strings' checks/tests/test_secret_scan.sh`
  → nothing; `grep -n 'Banned in the words KA-Reader writes' docs/CONTENT.md` → `:L190`;
  `docs/nfdr.md:L1545-L1549`; `docs/SDD.md:L1-L16`, `:L371` whole (read as 69 sentences), `:L826-L834`,
  `:L890-L903`, `:L8705-L8735`; `grep -n -o -E 'gate\.sh:L[0-9]+' docs/SDD.md` over the whole file →
  outside the row, only `:L831` and `:L895` are live (the rest sit in the header's version notes or in
  dated notes); `grep -n` over the whole file for `QC-53`, `strings.sh`, `test_strings`, `lint`, and
  for every count phrase (`30 steps`, `thirteen suites`, `twelve scripts` and their neighbours) →
  nothing outside the row and the header's dated version notes, so no other sentence of the SDD goes
  false with this one. The document was not read end to end (9,229 lines, ~970 KB); the whole-file
  greps above are what stood in for that, and they are scoped to what this answer could contradict.
  `docs/trail/sdd/self_answer-65.md` whole; of the inputs, `docs/architecture_open_issues.md` whole
  (the NFDR's counts and QC-53's suite naming are carried there, § 3.1) and the seed and refine
  record this item's `Tracked by:` names, read as inputs and cited in the answer nowhere.

## Items worked

### 5.1 — § 3's `read-only-harness` row counts twelve scripts, thirteen suites and a 30-step gate; at `ka-reader@cd65c02` there are thirteen scripts, fourteen suites and 31 steps

- **Bucket:** 5. Raised from downstream — an item from a seat that did not write the SDD
- **Verdict:** confirmed with addition
- **Why:** The item's lean holds — a dated reading of thirteen scripts, fourteen suites and the
  31-step gate at a named commit, the gate locators re-pinned, the new script and suite named, the
  `1b32500` reading kept as a dated note — and it stops short of what the fold has to move and say, so
  it is confirmed with the rest measured and added.

  *Check 1.* The edit lands in `docs/SDD.md` § 3's `read-only-harness` row and in two § 4 C-I3
  clauses, the same file. The item carries `Seat: cto`, this run's posture. The answer binds nothing
  but the document's agreement with the tree: no person, no outside party, no risk the owner carries,
  and no ground I cannot name. Mine, in the CTO's seat.

  *Check 2.* The item sits under *Raised from downstream*, cites its occurrence (`cd65c02`), and
  corrects counts and locators found false — the row's own rule calls a later `checks/` change a
  re-measurement, not a contradiction — so it widens nothing and "not until it occurs" does not apply.
  Its supporting text is right: every measurement it gives reproduces (three files in the diff, 13 and
  14, version 1.4.0 at `:L2`, 32 `run_step` lines, the step at `:L105` after `:L104`, no step running
  the lint itself, no fixture folder, no network). The lean reaches the right conclusion and is
  incomplete in seven places, each added. (1) The gate's new reading and the one thing the item names
  but the lean does not carry: no step runs `checks/strings.sh` itself. The row describes each step by
  what it runs, so the fold has to say how QC-53 reaches the gate at this pin — through the suite's
  `test_unchanged_catalogue_copy_passes`, which runs the real lint over a copy of the tree's own
  catalogue and `CONTENT.md` (`test_strings.sh:L121-L127`, `:L541-L545`) and fails on a `QC-53` line
  (`:L183-L196`) — and has to qualify its own sentence that "every script and suite named below runs
  as a step of the gate", which `strings.sh` now falsifies as written. Whether the lint gets a step of
  its own is not the SDD's to say; the row's rule records it when it lands. (2) The whole line map,
  and the rule behind it: the item says "every gate locator after `:L104` has moved by one" and does
  not say the version line at `:L2` moved every locator above it by one as well, so a fold following
  the item alone would leave every locator from old `:L2` to old `:L103` one line short. Two
  insertions, two shifts — one higher through old `:L103`, two higher from old `:L104` — and each
  mapped locator was checked against `grep -n '^run_step'` at the tip. (3) Two § 4 C-I3 locator sets
  outside the row (`docs/SDD.md:L831`, `:L895-L896`) move with the file; a fold of the row alone
  leaves them stale, as the two previous folds found for their steps (RN-118, RN-119). The whole-file
  grep shows they are the only live ones outside the row. (4) What the lint is, as the row describes
  every other script by what it does — read from its code, not only its header: argument, inputs,
  what counts as a hit, the output on a hit and on a clean read, the never-pass-on-nothing exits, no
  network, nothing installed. (5) What the suite is, the same way: fifty cases, the real lint over
  copies under `mktemp -d`, the planted-word and every-term controls, the altered-lint controls, the
  originating-tree case, the runner's exit rule, no network, no helper sourced. (6) The counts stated
  with their reasons: twelve paired checks plus `gate.sh`; twelve paired suites plus the two beside
  them; `vm_refusal.sh` sourced by the same six; fixtures, `.gitignore` and workflow unchanged, so
  every `ci.yml` and other-file locator stands. (7) The sentences that do not move, said so rather
  than left to inference: the fetch sentence (the new step adds no fetch and the offline failure point
  stays at *Secret scan*, `:L60`); `test_vm_refusal.sh` covering the new suite off the disk with no
  change; and the hosted-result sentence, re-read at the platform rather than copied forward. The item
  is one question with one landing and one seat; it does not split. The NFDR's §§ 8–10 are another
  record's and already on `docs/architecture_open_issues.md` § 3.1 — the answer names that and raises
  nothing there.

  *Check 3.* Nothing settled moves. The row's pin rule is what the answer applies. `docs/SRS.md` NFR-8
  binds the product during operation; the lint and its suite run in the harness and reach no network,
  so the row's fetch sentence and the NFR are untouched. `docs/nfdr.md` QC-53's *verified by* names
  `checks/strings.sh` (`:L1545`) and the row names the script, not the rule — the same seam the row
  keeps for QC-28, QC-30, QC-64 and QC-65. The lint's table title matches `docs/CONTENT.md:L190`
  exactly, so the row's description of what it reads is true of the document it reads. The SDD says
  nothing else about a lint, QC-53 or the counts outside this row and the header's dated notes
  (whole-file greps), so no second sentence has to agree. The previous answer (`self_answer-65.md`),
  folded at v59, is the record this one extends: same row, same rule, the next pin; its line map is
  carried forward as history and not re-derived. The station that landed the step and the seed it
  belongs to are inputs here and the answer cites neither; the answer names nothing under `system/`.

  *Check 4.* **Stale** — the answer is pinned to `cd65c02`, the merge; the tip read, `28d255d`,
  differs from it under `docs/` alone, and a `checks/` change landing before the fold is, by the row's
  rule, one more item. **Absent** — no network: the gate still ends at *Secret scan* (`:L60`) with
  "nothing was scanned" before the new step is reached, so it adds no earlier failure; a tree with no
  catalogue folder, no `.swift` file, no `docs/CONTENT.md`, no banned table or no term under its
  *Never* column ends the lint at exit 1 with a line naming which (`strings.sh:L439-L464`), and the
  suite has a case for each (`:L75-L77`, `:L92-L93`), so an empty input is never a pass. **Refused**
  — an unreadable `.swift` file is reported by path and fails the lint (`:L496-L501`); a `mktemp -d`
  the suite cannot create ends it at exit 1 naming the directory, with no case run (`:L1105-L1108`); a
  lint that is not executable ends it the same way (`:L1114-L1117`). **Concurrent** — two suite runs
  at once: each builds its copies under its own `mktemp -d` and removes it on exit, and writes nothing
  to the checkout (the originating-tree case), so *Own state*'s clean-tree condition is not reached by
  it; a step run twice, or two gates at once, is not a case the row has to state. **Empty** — the
  catalogue with no literal in it passes the lint (nothing to hit) and the suite's planted cases are
  what prove the lint can fail, which is the control the row names; covered by (5).

  *Close to a different verdict.* Plain *confirmed* was close: the item's lean is right as far as it
  goes and its measurements all reproduce. What tipped it is (2) — a line map the item states as a
  single shift when there are two, which a fold following the lean alone would get wrong for every
  locator above `:L104` — and (1) — the row's own "every script … runs as a step of the gate" sentence,
  now false for one script, which the lean's "the new script and suite named" does not reach.

## Left for the owner

None this run.

## Skipped

None this run.

## Companions opened

None this run.

## Launchers owed

- **docs/SDD.md** — `<CORE>/launchers/skill/launcher.sh product-sdd ka-reader`
