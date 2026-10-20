# Self-answer report — `adr/` and `nfdr.md`

## Header

- **Companion:** `docs/architecture_open_issues.md`
- **Document:** `docs/adr/` and `docs/nfdr.md` (every item names `docs/nfdr.md`; none touches a record)
- **Decided by:** `<CORE>/../skills/companion/.claude/skills/companion-self-answer/prompts/rich.md` v1.3.1
- **Date:** 2026-10-20
- **Sources re-read:** GitHub Actions run 38577309118's log, re-read with
  `gh run view 38577309118 --repo eyalgo/ka-reader --log`. The second tab-separated column is the
  workflow step's name. `out-of-grant-read:` appears twice: once under `Bundle probe` and once under
  `Bundle probe suite`. In the suite, the control's line comes directly after
  `ok   test_negative_control_reports_unsandboxed`. The managing instance's card,
  `system/projects/ka-reader/project.md` in `kensaiapp-opensource`. Its **Test command** is still
  `cargo test --workspace --locked && ka-reader-mac/assemble.sh && swift test --package-path ka-reader-mac
  && checks/structure.sh && checks/tests/test_structure.sh`, so it does not run `checks/gate.sh`. No other
  answer rests on a source outside this repository. **What was read in this repository:** the NFDR's header,
  QC-25 in full, § 8, § 9 and § 10 in full, not the whole NFDR (6,187 lines). Also the SDD's § 4 C-I3 probe
  half. At `ka-reader@8b93322` (`HEAD` is `5f79d60`, and `git diff --stat 8b93322 5f79d60 -- checks .github`
  prints nothing): `.github/workflows/ci.yml`, `checks/gate.sh`, `checks/bundle.sh:L370-L460`, the runner
  and the publishing case of `checks/tests/test_bundle.sh`, and `checks/tests/test_vm_refusal.sh`'s header
  and its workflow, suite and runner cases. `test_vm_refusal.sh` was run in a disposable clone of `8b93322`:
  9 of 9 passed. Then a second run, with an unlisted suite added and `runs-on: macos-26` changed to
  `macos-latest`: 7 of 9 passed, failing `test_every_toplevel_suite_is_an_entire_fatal_step` and
  `test_every_runner_names_macos_26`. The guest run of `checks/gate.sh` at `726a234` is the PM's
  measurement, not this run's. The guarded steps refuse off a virtual machine, and this run had none.

## Items worked

### 3.1 — QC-25's hosted-log read selects a workflow step that no longer exists

- **Bucket:** 3. Raised from downstream — an item from a seat that did not write these records
- **Verdict:** overridden
- **Why:** The selector has to move, and the item is right about that. But the fold it proposes would
  break QC-25 another way. The item asks for `$2 == "Test gate"` and keeps the one-line reading rule. That
  is a draft, so it is weighed as one. Here is what it misses. The old `Bundle probe` and
  `Bundle probe suite` steps are now both inside the one workflow step, `Test gate`. Each prints an
  `out-of-grant-read:` line. `checks/bundle.sh` prints the shipped bundle's report on every pass
  (`printf '%s\n' "$probe_output"`, `:L457`, before the pass check). The suite's runner then prints the
  control's reading (`checks/tests/test_bundle.sh`, the runner's `printf '%s\n' "$result"` after
  `echo "ok   $case_name"`). This is measured, not inferred. Run 38577309118's log has one such line under
  each old step name. So `$2 == "Test gate"` would print two lines on every green run, and the first would
  always read `denied`, because the shipped bundle passes only when its read is denied. Two results follow.
  The one-line rule fails on every run. And the break, "the step concluded `success` and the command prints
  no line", can never fire, since a green run always prints the shipped bundle's line. A suite that stopped
  passing on the control's reading would go unseen. **The answer:** select the line by the line before it.
  Inside `Test gate`, take the `out-of-grant-read:` line that comes right after
  `ok   test_negative_control_reports_unsandboxed`. The adjacency is not a habit of the script. The suite
  enforces it on every run: `test_negative_control_missing_read_fails_the_suite` requires the control's
  stdout to be exactly its `ok` line followed by its reading (`:L867-L869`). One spelling of the command
  was tried on run 38577309118's real log, with the two old step names read as one step. It printed exactly
  the control's line, where selecting the step alone printed two. **Check 3:** this agrees with SDD § 4
  C-I3. C-I3 places the reading in the suite's output, and the gate passes that output through unchanged
  (`checks/gate.sh`, *WHY NO RETRY, CAPTURE OR FILTER*). So the SDD is not owed a change. **Check 4:**
  *Stale*: runs on commits before `8b93322` keep the `Bundle probe suite` selector, and 38577309118's
  reading stands under it. The boundary is the commit, so neither rule reads the other's logs. *Absent*:
  Actions is off, so no hosted run exists. The command's first hosted run is its reading, and until then
  nothing can break it. *Refused*: if the gate fails before the suite runs, `Test gate` concludes
  `failure`, and the break, which needs `success`, does not apply. *Renamed*: the command now depends on
  two names, the workflow's `Test gate` step and the control case. The review gate names both, and the
  clause "no script holds that name" is rewritten to match. **What would have tipped it to "confirmed":**
  a gate that printed nothing from the shipped bundle's probe. It prints the report on every pass.

### 3.2 — § 8, QC-64 and QC-65 still say `checks/gate.sh` is not in the tree

- **Bucket:** 3. Raised from downstream — an item from a seat that did not write these records
- **Verdict:** confirmed with addition
- **Why:** The item's fold holds, for the reason it gives. Each of the four sentences waits on two
  conditions, and only the script's landing has happened. `git ls-files -s checks/gate.sh` shows `100755`,
  and the script has 26 `run_step` calls. The card, re-read at source, does not run it. So each sentence
  waits on the card alone. **Addition 1, a fifth sentence of the same kind:** § 9's suites bullet says
  "While Actions is off and the script is not in the tree, a suite on a workflow step alone runs nowhere"
  (`docs/nfdr.md:L1867`). **Addition 2, the guest reading carries over:** the PM ran the script at `726a234`,
  and the item cites the merge `8b93322`. `git diff 726a234 8b93322 -- checks/gate.sh` only re-wraps two
  header comments, so the reading holds at the merge. **Addition 3, QC-64's tail is false a second time,
  and the item does not say so.** It says the two tree comparisons "are held by no script", and "That
  absence is the review gate's only ground". `checks/tests/test_vm_refusal.sh` v1.1.0 is the gate's
  `VM refusal suite` step (`checks/gate.sh:L77`). It holds the suites comparison as
  `test_every_toplevel_suite_is_an_entire_fatal_step`, which requires each top-level suite to be a gate
  step's whole command. It holds the workflow's shape as `test_moved_steps_are_single_line_commands_in_order`,
  which requires exactly one step whose whole `run:` is `checks/gate.sh`, directly before
  `Package KA-Reader.app`. Both pass at `8b93322`, and both went red in the mutated clone. The workflow case
  does not hold the comparison's "nothing else" half. An extra `run:` step inserted before the gate step
  shifts both positions and still passes, and so does one after packaging. So that half stays a review gate,
  argued on that ground. Because no run issues the script until the card runs it, `development-design`
  stays the gate on both meanwhile. What moves is the ground. **And the card's move is now ready.** QC-65
  put the refusal before the card's move, and the refusal has landed (`13e8d42`). § 8 put the script before
  it, and the script has landed and passed in the guest. Nothing the NFDR names still blocks the move § 8
  already owes `product-card`, so the card is named last under *Launchers owed*. **Check 3:** this answer
  and 3.3 read the same suite, and they agree. 3.3 takes the suites comparison into § 9's tail, and this
  answer takes it into QC-64's. **Check 4:** *Absent*: if the card's move never comes, the sentences stay
  true as re-conditioned, because they wait on the card. *Stale*: the 26 steps and the line numbers are
  pinned at `8b93322`.

### 3.3 — § 9 says each harness suite is its own CI step, and the suites are now steps of `checks/gate.sh`

- **Bucket:** 3. Raised from downstream — an item from a seat that did not write these records
- **Verdict:** confirmed with addition
- **Why:** The rule and the item's fold hold. QC-64 says the workflow holds no rule of its own, so a suite's
  step belongs in the script, and the workflow reaches it through `Test gate`. Measured at `8b93322`: each of
  the eleven suites is the whole command of one `run_step` call (`checks/gate.sh:L50`, `:L52`, `:L55`,
  `:L57`, `:L67`, `:L71`, `:L73`, `:L74`, `:L77`, `:L78`, `:L79`), and `grep -c 'Bundle probe suite'
  .github/workflows/ci.yml` prints `0`. The slot lists the pairs so the fold can pin them in one go.
  **Addition 1:** "the test command (`ci.yml:L26`) runs none of them" is false at `8b93322`. `:L26` is
  `run: checks/gate.sh`, which runs all eleven. **Addition 2, the larger one:** the tail has carried "What is
  owed … a `checks/` script that runs the comparison … The day it lands, this tail names it and the review
  gate drops" since v15. That check has been in the tree since `13e8d42`, as
  `test_vm_refusal.sh`'s `test_every_toplevel_suite_is_an_entire_fatal_step`. At `13e8d42` it was aimed at
  the workflow. At `8b93322` it is aimed at the script. It is stricter than the tail's loop: `grep -x -F`
  on the whole command, not `grep -q` on a substring. It went red this run when an unlisted suite was
  added. So the tail names the case. The review gate's ground becomes § 8's run gap (the card does not run
  the script yet), not a missing script. The `grep -q … ci.yml` loop, which now prints all eleven suites,
  becomes history. The same suite's `test_no_conditional_or_nonfatal_step` holds *How a suite joins*'s
  ruled-out join, and that passage can name it. **Addition 3:** § 10's preamble repeats "runs as its own CI
  step on every build", and it moves with the bullet, since § 10 is a projection. **Check 3:** decided
  together with 3.1. 3.1's selector rests on the suites running inside `Test gate`, which is what this fold
  states. **Check 4:** *Stale*: the count, eleven, and the lines are pinned at `8b93322`. A further suite is
  a re-measurement. *Absent*: a suite added to `checks/tests/` with no gate step turns
  `test_vm_refusal.sh` red. That suite holds the gate at the change once the card runs the script, and
  until then `development-design` holds it.

## Left for the owner

None this run.

## Skipped

None this run.

## Raised on this document

### 2.1 — QC-56 says its workflow runner check is held by no script, and a suite has held it since `ka-reader@13e8d42`

- **What the document is owed:** QC-56's *verified by* tail and § 10's QC-56 row name
  `checks/tests/test_vm_refusal.sh`'s `test_every_runner_names_macos_26` as the runner check. The
  review gate's ground moves from "held by no script" to § 8's run gap.
- **Why it is worth a cycle:** *A fact in it is now false*
  (`<CORE>/../skills/companion/.claude/skills/companion-self-answer/prompts/rich.md` § The items are not
  the whole of what a document is owed). The case runs the tail's own comparison:
  `grep -h -E '^[[:space:]]*runs-on:'` over `.github/workflows/*.yml`, failing on any runner other than
  `macos-26`. It also fails when no workflow names a runner. It is in the suite at `13e8d42` (`:L210-L215`)
  and unchanged at `8b93322`, where `diff` over the two function bodies prints nothing. It went red this
  run, in a clone of `8b93322`, on `runs-on: macos-latest`, with "a runner other than macos-26". The claim
  was already false at v57's own pin, `13e8d42`, so the last fold missed it. That is why it is raised now
  rather than left for the next measurement. QC-64's and § 9's matching claims are carried in the answers
  to 3.2 and 3.3. This one is the only one in an entry no item names.

## Companions opened

None this run.

## Launchers owed

- **`docs/adr/` and `docs/nfdr.md`** — `<CORE>/launchers/skill/launcher.sh product-architecture ka-reader`
- **system/projects/ka-reader/project.md** — `<CORE>/launchers/product-card/launcher.sh ka-reader`
