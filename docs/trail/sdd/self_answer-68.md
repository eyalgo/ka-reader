# Self-answer report — SDD

This report records the CTO's decision on the SDD companion for the owner and the run that folds it.

## Header

- **Companion:** `docs/SDD_open_issues.md`
- **Document:** `docs/SDD.md`
- **Decided by:** `<CORE>/../skills/companion/.claude/skills/companion-self-answer/prompts/rich.md` v1.3.1
- **Date:** 2026-10-29
- **Sources re-read:** None outside the product repository underlies the inventory decision. No vendor behaviour or current hosted-run result is asserted.
- **Inputs read:** PRD Settled · SRS Settled · UXD Settled · SDD Settled · writing bar Draft
- **Reading scope:** The PRD was read whole. The SDD, SRS and UXD were read in sections; some long reads were truncated. The skill's whole-document reading requirement was not completed. This limits the contradiction check beyond the cited sections.
- **Measurement pin:** `ka-reader@3431b7de250ddf37b8381bdf18d57f4db3a8d038`. The checkout was at `0248869c5a7cf2c7843cf69ef9c318ff36a12664` when inspected.

## Items worked

### 5.1 — § 3's `read-only-harness` row counts fourteen suites and a 32-step gate at 1.5.0; at `ka-reader@3431b7d` there are fifteen and 33, and the new suite holds the *Strings check* step

- **Bucket:** 5. Raised from downstream — an item from a seat that did not write the SDD
- **Verdict:** confirmed with addition
- **Why:** Confirm the proposed refresh, adding the related C-I3 locators and the suite's exact scope. The row explicitly pins its inventory and calls for re-measurement when another file lands (`docs/SDD.md:L373`); the old count is true at its pin. This is the CTO's internal consistency decision under the SDD's lane table (`docs/SDD.md:L130-L132`), with no new product promise or owner commitment. The item proposes a concrete answer despite sitting in the downstream bucket, so it is assessed as a proposal.

  The occurrence is the added suite and gate entry at the named commit, not a hypothetical widening: `git diff --name-status f25fdbb 3431b7d -- checks .github` returned only `M checks/gate.sh` and `A checks/tests/test_strings_step.sh`. The suite's executable mode is 100755 (`git ls-tree 3431b7d checks/tests/test_strings_step.sh`). The following reads were made with `git -C <product>`; paths below are product-relative:

  ```text
  git show 3431b7d:checks/gate.sh | rg -c '^run_step '
  33
  git ls-tree --name-only 3431b7d:checks/tests | rg -c '\.sh$'
  15
  git ls-tree --name-only 3431b7d:checks | rg -c '\.sh$'
  13
  ```

  The literal space in the first pattern excludes the dispatcher definition. The gate's version is 1.6.0 at line 2, its dispatcher is lines 33–40, and its step list is lines 51–131 at the pin. The lint, its suite, and the new step suite are lines 111–113. The new suite recognises exactly one full lint command line and requires it before the first suite step; it reads text rather than executing the gate (`checks/tests/test_strings_step.sh:L7-L20`, `:L112-L158`, at the pin). Its controls prove their deletion or move happened before judging the altered copy (`:L240-L293`). It is a third unpaired suite, not a thirteenth check script.

  The addition follows the same insertion beyond the row: C-I3 cites the dispatcher at lines 32–39 and the build/view steps at lines 72 and 88 (`docs/SDD.md:L829-L833`, `:L896-L904`). At the new pin those sites are lines 33–40, 73 and 89 of the gate. Refresh them with the row, retaining the old readings as dated notes. The gate diff inserts a version line at new line 2 and the suite step at new line 113; old lines 2–111 therefore move one line and old line 112 onward two. Historical notes retain their original locators.

  The proposal changes a build-time inventory, with the harness outside the shipped units (`docs/SDD.md:L375-L379`). It does not alter the product's read-only or network requirements (`docs/SRS.md:L310-L336`), or the experience described in `docs/UXD.md:L26-L35`. The corresponding NFDR refresh already has its own open item (`docs/architecture_open_issues.md` § 3.1), so no duplicate companion item is added. The answer owes no project-card field: the card's test command remains `checks/gate.sh` (`system/projects/ka-reader/project.md`, **Test command**, in the instance).

- **Failure paths and limits:** An empty or missing gate is not evidence for a successful check; the suite explicitly rejects missing lint and missing suite lines (`checks/tests/test_strings_step.sh:L139-L150`, at the pin). A repeated lint line is rejected too (`:L143-L146`). The immutable pin avoids mixing concurrent revisions. At the inspected checkout, `git diff --numstat 3431b7d 0248869 -- checks/tests/test_strings_step.sh checks/gate.sh` printed nothing; later changes in `checks/` affect only comment annotations in two other suites (`git diff 3431b7d 0248869 -- checks/tests/test_structure.sh checks/tests/test_view.sh`). Any later inventory change needs a new measurement. No product suite or full gate ran here, so the item's earlier “27 of 27 passed” is not adopted as this run's result. Neither hosted success nor current Actions availability was checked. A failed earlier gate step prevents reaching this suite, as the dispatcher states (`checks/gate.sh:L33-L40`); presence in the list alone does not prove execution.

## Left for the owner

None this run.

## Skipped

None this run. Zero filled answer slots were skipped; item 5.1 was the companion's only item.

## Companions opened

None this run.

## Launchers owed

- **docs/SDD.md** — `<CORE>/launchers/skill/launcher.sh product-sdd ka-reader`

