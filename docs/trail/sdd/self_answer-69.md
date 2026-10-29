# Self-answer report — SDD

This report records the CTO's citation decision for the owner and the run that folds the answer.

## Header

- **Companion:** `docs/SDD_open_issues.md`
- **Document:** `docs/SDD.md`
- **Decided by:** `<CORE>/../skills/companion/.claude/skills/companion-self-answer/prompts/rich.md` v1.3.1
- **Date:** 2026-10-29
- **Sources re-read:** None outside the product repository underlies this citation decision. The evidence is the committed source file, not an earlier report's description of it.
- **Inputs read:** PRD Settled · SRS Settled · UXD Settled · SDD Settled · writing bar Draft
- **Reading limit:** The companion, answering prompt and PRD were read whole. The SDD, SRS and UXD were read in sections; long reads were truncated. The skill's whole-document reading requirement was not completed. This decision verifies the named citation correction, not the consistency of the entire definition set.
- **Measurement pin:** `ka-reader@3431b7de250ddf37b8381bdf18d57f4db3a8d038`. The checkout inspected was `e4bf37d2cfc7ab3e37e3f71479551fb426c8fb44`.
- **Report home:** `docs/trail/sdd/self_answer-69.md`, under `<CORE>/doctrine/setup/kensaiapp_structure.md` § A trail is not the document's sibling — it is filed under `trail/`. The directory's highest existing self-answer number was 68 before this report was created.

## Items worked

### 2.1 — Point the strings-step suite's evidence at the cases that actually assert it

- **Bucket:** 2. Choices to confirm — a best-effort answer was drafted; confirm or override
- **Verdict:** confirmed
- **Why:** Confirm the proposed correction. It repairs evidence in the SDD's own component description, which the CTO decides (`docs/SDD.md:L130-L132`); it introduces no product commitment or owner-only trade-off. This is a concrete proposed correction in the choices bucket, even though it has not yet been folded into the SDD (`docs/SDD_open_issues.md` § 2.1).

  At the measurement pin, `gate_verdict` occupies `checks/tests/test_strings_step.sh:L113-L156`. The independent real-gate case is `:L333-L338`: it passes the real gate to `run_verdict` and requires a zero result. The deletion and move controls are `:L346-L382`: each makes its edit, checks that the edit took effect, requires rejection, and checks the missing-step or ordering diagnostic. These are the proposed locators, verified directly with `git show 3431b7de250ddf37b8381bdf18d57f4db3a8d038:checks/tests/test_strings_step.sh` and numbered output.

  The current row's real-gate locator, `:L240-L247`, instead opens the deletion helper and the start of the move helper; its controls locator, `:L256-L293`, opens the end of the move helper and the edit-effect helpers (`docs/SDD.md:L374`; the same pinned test file at those ranges). The existing `:L112-L158` range already contains `gate_verdict`; narrowing it to `:L113-L156` makes the function's bounds exact. The proposed correction therefore holds for the reason given, without changing the described behavior.

  Reasoning against the inputs: changing these locators alters neither the product's requirements nor its experience. The cited row places the harness outside the shipped units (`docs/SDD.md:L374-L379`), the SRS states the product's read-only and network requirements (`docs/SRS.md:L310-L336`), and the UXD defines the reading experience (`docs/UXD.md:L26-L35`). No upstream sentence needs to move to make this correction. The project card's command remains outside this edit: `system/projects/ka-reader/project.md`, **Test command**, in the instance.

  RN-122 repeats the old control locator (`docs/SDD.md:L9352-L9354`). It is the earlier fold's record, not independent proof of the controls; this verdict relies on the source above. The producing run's new correction record can name that earlier reading while retaining its history. No new question or separate companion is needed for the same citation correction.

- **Failure paths and limits:** The pinned helper rejects an absent exact lint line, repeated lint lines, a missing suite line and the wrong order (`checks/tests/test_strings_step.sh:L139-L154`, at the measurement pin). The old control locator covers checks that an edit happened but misses the rejection assertions; the new range covers both (`:L346-L382`). An immutable commit keeps the references meaningful when the working tree changes. `git diff 3431b7d f5eb32e -- checks/tests/test_strings_step.sh` and `git diff 3431b7d e4bf37d2cfc7ab3e37e3f71479551fb426c8fb44 -- checks/tests/test_strings_step.sh` both returned empty output. These comparisons establish identical file content at those revisions, not a passing test run. No product check, gate, or hosted workflow ran here. A missing source revision or refused read would leave the locator unverified; neither occurred in the reads above.

## Left for the owner

None this run.

## Skipped

None this run. Zero filled answer slots were skipped; § 2.1 was the only item carrying an open answer slot in `docs/SDD_open_issues.md`.

## Companions opened

None this run.

## Launchers owed

- **docs/SDD.md** — `<CORE>/launchers/skill/launcher.sh product-sdd ka-reader`
