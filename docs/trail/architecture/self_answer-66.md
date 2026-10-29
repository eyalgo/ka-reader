# Self-answer report — KA-Reader architecture

This report records the decision on the architecture companion for the owner and the Principal
Architect run that folds it.

## Header

- **Companion:** `docs/architecture_open_issues.md`
- **Document:** `docs/adr/` and `docs/nfdr.md`
- **Decided by:** `<CORE>/../skills/companion/.claude/skills/companion-self-answer/prompts/rich.md` v1.3.1
- **Date:** 2026-10-29
- **Sources re-read:** No vendor source was needed for this decision. Its evidence is the product's
  own gate, suites and cited definition sections, measured at
  `ka-reader@f5eb32e3fc6b3eed96b3170924fe0b6aa767fb19`.
- **Inputs read:** NFDR Settled · SDD Settled · SRS Settled · FDR Settled · writing bar Draft
- **Review limit:** This run read the companion and the strings-step suite whole, and reviewed the
  relevant definition sections and ADR-0012. It did not complete the skill's required whole-document
  reread of the NFDR, the complete ADR set and all upstream documents. The decision below is supported
  by the cited sections and direct checks; this report is not evidence of that broader review.

## Items worked

### 3.1 — § 9 counts fourteen suites at `ka-reader@f25fdbb`; at `ka-reader@3431b7d` there are fifteen, and QC-53 names no check that holds its *Strings check* step in place

- **Bucket:** 3. Raised from downstream — an item from a seat that did not write these records
- **Verdict:** confirmed with addition
- **Why:** Confirm the proposed refresh, with the verifier's exact limits added. Both requested
  edits belong to this record: § 9 owns the suite enumeration, and QC-53 and its § 10 row own the
  enforcement references (`docs/nfdr.md:L2183-L2239`, `:L1544-L1585`, `:L2624`). This is a
  measurement of a landed check, not a new product requirement or an owner's risk decision.
  The occurrence cited by the item exists: `git diff --name-only 4e50fd1 3431b7d` prints
  `checks/gate.sh` and `checks/tests/test_strings_step.sh`, and nothing else. Treat the downstream
  item's proposed fold as a draft, despite its being outside the choices-to-confirm bucket.

  At the checked tip, the top-level `checks/tests/*.sh` set contains fifteen suites. Each is the
  entire command of one gate step; the new suite is at `checks/gate.sh:L113`, directly after
  *Strings check suite* at `:L112`, and the lint itself is at `:L111`. The fifteen and their
  step lines are recorded below. Three are unpaired: `test_vm_refusal.sh`,
  `test_secret_scan_planted.sh` and `test_strings_step.sh`; the twelve others have a corresponding
  check script, using the repository's underscore-to-hyphen spelling. Update that part of § 9
  too, retaining the old measurement as history rather than treating its pin as a false claim.

  The addition is precision about what the new verifier proves. `gate_verdict` accepts exactly one
  complete lint command line before the first recognized *Strings check suite* line
  (`checks/tests/test_strings_step.sh:L113-L156`). It does not execute the lint or the gate and
  does not require adjacency: `test_another_step_between_strings_check_and_its_suite_passes`
  explicitly accepts an intervening step (`:L464-L467`). Keep the lint, its own suite and the
  three Swift error-path cases in QC-53; the new suite proves the gate's wiring, not catalogue
  contents or rendered messages. Reword the two-path explanation to distinguish a surviving
  content-checking path from a green gate: removing the direct lint line now makes the independent
  real-gate case fail whenever this suite is reached (`:L333-L338`). If an earlier step fails,
  the gate is already red and the suite is not reached (`checks/gate.sh:L33-L40`).

  This agrees with the upstream rule against internal diagnostic text
  (`docs/SDD.md:L786-L796`, `:L1209-L1218`; `docs/fdr.md:L180-L181`) and adds no requirement to
  SRS NFR-11 (`docs/SRS.md:L348-L359`). The SDD's § 3 `read-only-harness` row already names the
  fifteen suites and the new step at its `3431b7d` pin. The citation correction found in that row
  is carried separately by `docs/SDD_open_issues.md` § 2.1, committed as
  `82cbe810f2e1eda6a2372adab65b9c28e3808e47`; it does not change this answer's seat.

  Carry the same gate re-measurement through § 8's existing version-and-step paragraph:
  `checks/gate.sh:L2`, `:L33-L40` and its call list at `:L51-L131` show version 1.6.0 and 33
  calls. Preserve the `f25fdbb` reading at `docs/nfdr.md:L1767-L1786` as dated history. This is
  the operational consequence of the same added step, not a new constraint or an ADR reversal.

  Failure paths were checked by running `checks/tests/test_strings_step.sh` in a disposable clone
  at `f5eb32e3fc6b3eed96b3170924fe0b6aa767fb19`: exit 0, **27 of 27 passed**. Those cases include
  deletion, movement after the suite, an edit that changed nothing, duplicate commands, an empty
  gate, a missing suite, missing gate input and failure to create temporary storage; their names
  are in `checks/tests/test_strings_step.sh:L58-L86`, and the runner counts actual cases at
  `:L603-L620`. `git status --porcelain` in the clone was empty afterward. This was a suite run,
  not a full gate or a hosted CI run. Concurrent future edits remain a measurement limit: the
  fold must name the commit it checks, and must re-measure if these files move. A refused read or
  failed check is not evidence of a passing gate.

**Measured suite-to-step mapping at `f5eb32e3fc6b3eed96b3170924fe0b6aa767fb19`:** the sorted
`checks/tests/*.sh` files were matched to exact whole-command `run_step` lines in `checks/gate.sh`.
The check printed `top-level suites: 15` and exactly one line number for each:

| Suite under `checks/tests/` | Gate line |
|---|---:|
| `test_bundle.sh` | 88 |
| `test_entry_points.sh` | 85 |
| `test_launch.sh` | 118 |
| `test_no_network.sh` | 106 |
| `test_own_state.sh` | 114 |
| `test_own_state_step.sh` | 119 |
| `test_read_only.sh` | 104 |
| `test_renderer.sh` | 100 |
| `test_secret_scan.sh` | 52 |
| `test_secret_scan_planted.sh` | 70 |
| `test_strings.sh` | 112 |
| `test_strings_step.sh` | 113 |
| `test_structure.sh` | 83 |
| `test_view.sh` | 90 |
| `test_vm_refusal.sh` | 117 |

The existing gate-list case enumerates top-level suites dynamically and requires each as a whole
step command (`checks/tests/test_vm_refusal.sh:L232-L243`); it therefore reads the new suite's
presence without gaining a hard-coded name. No run of that suite is claimed here.

## Left for the owner

None this run.

## Skipped

None this run. Zero filled answer slots were skipped.

## Companions opened

- **docs/SDD_open_issues.md** — **opened** — companion to `docs/SDD.md`, item 2.1 corrects the strings-step suite's evidence locators, landed in commit `82cbe810f2e1eda6a2372adab65b9c28e3808e47`

## Launchers owed

- **docs/adr/ and docs/nfdr.md** — `<CORE>/launchers/skill/launcher.sh product-architecture ka-reader`
- **docs/SDD.md** — `<CORE>/launchers/companion-self-answer/launcher.sh ka-reader SDD`
