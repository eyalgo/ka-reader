# Self-answer report — `adr/` and `nfdr.md`

## Header

- **Companion:** `docs/architecture_open_issues.md`
- **Document:** `docs/adr/` and `docs/nfdr.md` (the one item names `docs/nfdr.md`; none touches a record)
- **Decided by:** `<CORE>/../skills/companion/.claude/skills/companion-self-answer/prompts/rich.md` v1.3.1
- **Date:** 2026-10-20
- **Sources re-read:** GitHub's workflow syntax reference, which says workflow files in
  `.github/workflows` use the `.yml` or `.yaml` extension
  (https://docs.github.com/en/enterprise-server@3.21/actions/reference/workflow-syntax-for-github-actions,
  read 2026-10-20 through a search result; the github.com edition was not opened). Addition 1 rests on it.
  The managing instance's card, `system/projects/ka-reader/project.md` in `kensaiapp-opensource`, last moved at
  `kensaiapp-opensource@a4204e5b`. Its **Test command** still ends `checks/structure.sh && checks/tests/test_structure.sh`
  and does not run `checks/gate.sh`, so the draft's "until the card's command runs the script" still holds.
  **What was read in this repository:** the NFDR's header, § 8 in full (QC-55 to QC-60 and QC-64, QC-65),
  § 9's suites bullet tail, § 10's preamble and every row from QC-41 down, and RN-69 in full. Not the whole
  NFDR (6,336 lines). Also the SDD's `read-only-harness` row and the C-R5 lines that name the runner. At
  `ka-reader@8b93322` (`HEAD` is `aaa07ea`, and `git diff --stat 8b93322 HEAD -- checks .github` prints
  nothing): `checks/tests/test_vm_refusal.sh`'s header, `CASES` list and runner case,
  `checks/gate.sh:L70-L82`, `.github/workflows/ci.yml:L15-L20`, `ka-reader-mac/Info.plist`,
  `ka-reader-mac/Package.swift`. At `ka-reader@13e8d42`: `checks/tests/test_vm_refusal.sh:L200-L225`.
  `test_vm_refusal.sh` was run in a disposable clone of `8b93322`: 9 of 9 passed. With `runs-on: macos-26`
  changed to `macos-latest`: 8 of 9, failing `test_every_runner_names_macos_26` with "a runner other than
  macos-26:     runs-on: macos-latest". The clone was removed afterwards.

## Items worked

### 2.1 — QC-56 says its workflow runner check is held by no script, and a suite has held it since `ka-reader@13e8d42`

- **Bucket:** 2. Choices to confirm — the Principal Architect drafted a best-effort answer; confirm or override
- **Verdict:** confirmed with addition
- **Why:** The draft is right, for the reason it gives. QC-56's v57 tail said the runner check was "held by
  no script". That was false: `test_every_runner_names_macos_26` is in `checks/tests/test_vm_refusal.sh` at
  `13e8d42` (`:L211-L216`, the function itself, as the item says) and at `8b93322`. It is in the suite's
  `CASES` list, so it runs. The suite is the gate's `VM refusal suite` step (`checks/gate.sh:L77`). It
  runs the tail's own `grep` with the same `macos-26` pattern. It also fails when no workflow names a
  runner, which the command does not. Measured again this run, in a clone of `8b93322`: 9 of 9, and 8 of 9
  with the runner changed to `macos-latest`. The draft keeps `development-design` as the gate while the card
  does not run the script, and gives that run gap as the reason. That matches what v58 did to QC-64 and
  § 9, and the card still does not run the script.
  **Check 1:** this is my call to make in the owner's seat. The change lands in `docs/nfdr.md`, which this
  companion belongs to. It commits nobody to anything; it only makes the record say what the tree holds.
  **Check 3:** it agrees with the settled record. The SDD's `read-only-harness` row already names the suite
  as reading the workflow "for every runner naming `macos-26` (`:L245-L251`)". SDD § 4 C-R5's *Violated by*
  includes a workflow whose `runs-on` names an alias or an image below the floor's major. QC-64 and § 9
  name the same suite as a gate step. Left as it was in v57, QC-56 would be the one entry denying a check
  the other two name.
  **Addition 1, found on check 4 (an edge case the draft does not reach):** QC-56 binds "every `runs-on` in
  the product's CI", but the command and the case both read only `.github/workflows/*.yml`. GitHub runs a
  workflow file ending `.yaml` too (source in the header). So a second workflow such as `release.yaml` with
  `runs-on: macos-latest` passes both while breaking the entry. The draft's "the same `grep`, the same
  pattern" is accurate, but it hides that both readers share this blind spot. The tail should say so and
  name `development-design` reading the entry as the gate for a workflow file ending `.yaml`. Unlike the
  run gap, that gate does not go away when the card runs the script: the case would still not read the
  file. Whether to widen the case to `*.y*ml` is the delivery tier's; the record only has to stop implying
  full coverage. A matrix runner, a quoted label or the list form all fail the `grep` and turn it red,
  which is the safe direction, so they need no addition.
  **Addition 2, a stale sentence in the same tail:** the sentence right after the tail reads "At
  `ka-reader@d6405e2` the tree meets neither half … that check prints `runs-on: macos-14`". It is true at
  its pin. But it sits beside a tail that now names a check which passes, so a cold reader takes it as
  the current state and reads QC-56 as unmet. At `8b93322` the tree meets both halves:
  `ka-reader-mac/Info.plist:L13-L14` holds `26.0`, `ka-reader-mac/Package.swift:L23` names
  `.macOS(.v26)`, `.github/workflows/ci.yml:L18` is the one runner, `macos-26`, and the suite passes. The
  fold re-measures the sentence at `8b93322` and moves the `d6405e2` words into a dated note, which is how
  this document handles a re-measurement. The fold is already editing this tail, so this costs no extra
  cycle; on its own I would not have raised it, because the document treats a pinned sentence as true at
  its pin.
  **Close call:** I nearly confirmed with no addition, because the `.yaml` gap was already there in v57
  and the item does not ask about it. What decided it is that the item rewrites exactly this tail's claim
  of what the check covers. Folding it as drafted would restate a coverage claim that is wider than what
  the check reads.
  **Check 4, other cases:** *Empty*: no workflow names a runner. The case fails and the command does not,
  as the draft says. *Absent*: if `.github/workflows/` is gone, the glob matches nothing and the case
  fails. § 8 already says what happens to the gate then. *Stale*: `checks/gate.sh:L77` and the 9-case
  count are pinned at `8b93322`. The "until the card runs the script" clause ends itself the day the card
  moves.
  **If overridden:** as the item states. The v57 words come back, and QC-56 alone again denies a check
  that QC-64 and § 9 name.

## Left for the owner

None this run.

## Skipped

None this run.

## Companions opened

None this run.

## Launchers owed

- **`docs/adr/` and `docs/nfdr.md`** — `<CORE>/launchers/skill/launcher.sh product-architecture ka-reader`
