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

> **No `product-architecture` run wrote this file.** The PM opened it on 2026-10-17, from a
> `shukuba-refine` review on the seed `ka-reader · nemawashi · 2026-10-16_every-ci-rule-is-held-at-the-change`,
> to carry items 3.1 to 3.3 below. The NFDR is Settled, so without a companion they would reach no one.

---

## 1. Open issues — questions with no answer yet

None.

## 2. Choices to confirm — the Principal Architect drafted a best-effort answer; confirm or override

### 2.1 QC-56 says its workflow runner check is held by no script, and a suite has held it since `ka-reader@13e8d42`

> **No `product-architecture` run wrote this item.** A `companion-self-answer` run raised it on
> 2026-10-20, while answering §§ 3.2 and 3.3. Those items led it to `checks/tests/test_vm_refusal.sh`,
> which holds more of the NFDR's comparisons than the NFDR says. Two are carried in those items' answers.
> This one is in QC-56, which no item names. The reasoning is
> `docs/trail/architecture/self_answer-53.md` § *Raised on this document*.

- **Lands in:** `nfdr.md` QC-56, its *verified by* tail ("this document's own realization of C-R5's
  workflow case, held by no script, so `development-design` reading this entry is its gate for a change
  under `.github/workflows/`", `docs/nfdr.md:L1566-L1569`), and § 10's QC-56 row (`:L2221`). No ADR.
- **Drafted into the records:** nothing yet. This is the change proposed. The tail names
  `checks/tests/test_vm_refusal.sh`'s `test_every_runner_names_macos_26` as the check. It runs the tail's
  own comparison over `.github/workflows/*.yml`: the same `grep -h -E '^[[:space:]]*runs-on:'`, the same
  `macos-26` pattern, and it fails on any other runner. It also fails when no workflow names a runner,
  which the tail's command does not. It is a step of the gate (`checks/gate.sh:L77`). Until the card runs
  the script, by § 8, no run issues it at a change, so `development-design` stays the gate meanwhile. The
  ground moves from "held by no script" to that run gap. Release inspection keeps its reading. § 10's row
  adds the suite beside the command.
- **Rationale:** a fact in the NFDR is false, and it was measured this run. The case is in the suite at
  `ka-reader@13e8d42` (`git show 13e8d42:checks/tests/test_vm_refusal.sh`, `:L210-L215`), and v57 pinned
  the guarded set at that very commit. It is unchanged at `8b93322`. In a clone of `8b93322` the suite
  passed 9 of 9. With `runs-on: macos-26` changed to `macos-latest`, it failed with "a runner other than
  macos-26". It derives from SDD § 4 C-R5's workflow case, as the entry already traces.
- **If overridden:** QC-56 goes on saying no script holds the check. A contributor then reads a gate as
  review-only when a suite holds it, and a change that drops the case from the suite goes unnoticed,
  because the NFDR does not name the case as the check. No record moves either way.
- **Confirm or override:** <"confirm", or "override: <what to do instead>">

## 3. Raised from downstream — an item from a seat that did not write these records

### 3.1 QC-25's hosted-log read selects a workflow step that no longer exists
- **Raised by:** PM — 2026-10-17
- **Which record:** `nfdr.md` QC-25, the runner reading (`docs/nfdr.md:L824-L858`), and § 10's QC-25 row
  (`:L2196`): `gh run view <run-id> --repo eyalgo/ka-reader --log | awk -F'\t' '$2 == "Bundle probe suite" &&
  /out-of-grant-read:/'`.
- **Tracked by:** `ka-reader · nemawashi · 2026-10-16_every-ci-rule-is-held-at-the-change`
- **What it blocks:** nothing while Actions is off. On the next hosted run the command prints nothing, and
  QC-25 reads an empty read on a run as a break whether or not the wall held.
- **Where it shows:** at `ka-reader@8b93322` the workflow has one step that runs a rule, `Test gate`, whose
  whole `run:` is `checks/gate.sh` (`.github/workflows/ci.yml:L26`); the bundle probe's suite runs inside it.
  `grep -c 'Bundle probe suite' .github/workflows/ci.yml` → 0. QC-25 itself says a change that renames or
  drops that step changes this command in the same change (`:L857-L858`).
- **If a document has to be written:** none. The fold would select `Test gate` in the recipe and the § 10
  row, keep the one-line reading rule, and leave earlier readings under their old step name.
- **Answer:** Change the selector, but not to `Test gate` alone. Inside that one step, every green run now
  logs two `out-of-grant-read:` lines. The first is the shipped bundle's own report, which `checks/bundle.sh`
  prints on every pass (`:L457` at `ka-reader@8b93322`, run by the gate's `Bundle probe` step,
  `checks/gate.sh:L53`). The second is the control's, which the suite passes on (`Bundle probe suite`,
  `:L55`). Run 38577309118's log, re-read this run, has one of each, under the two old step names. So the
  fold as drafted would print two lines, the first always `denied`. The one-line rule would fail on every
  run, and an empty read could never happen, so the break could never fire. The fold takes the
  `out-of-grant-read:` line directly after `ok   test_negative_control_reports_unsandboxed`, inside
  `$2 == "Test gate"`. The suite already proves that line follows the control's `ok` line and nothing else
  does (`test_negative_control_missing_read_fails_the_suite`, `checks/tests/test_bundle.sh:L867-L869`). One
  spelling, tried on run 38577309118 with its two old steps read as one, prints exactly the control's line:
  `gh run view <run-id> --repo eyalgo/ka-reader --log | awk -F'\t' '$2 == "Test gate" { if (after && /out-of-grant-read:/) print; after = /ok   test_negative_control_reports_unsandboxed$/ }'`.
  The break becomes: a hosted run on a commit that holds `ka-reader@8b93322`, whose `Test gate` step
  concludes `success`, and for which this prints no line. Runs on earlier commits keep the
  `Bundle probe suite` selector, and run 38577309118's reading stands under it. The review gate now names
  two names. A change that renames the workflow's `Test gate` step, or the control case, changes this
  command in the same change. The clause "no script holds that name — § 9's suites bullet holds that the
  step exists, not what it is called" is rewritten to say so. § 10's QC-25 row follows. While Actions is
  off there is no hosted run, so the first one is this command's reading. Decided together with 3.3.
  Reasoning: `docs/trail/architecture/self_answer-53.md` § 3.1.

### 3.2 § 8, QC-64 and QC-65 still say `checks/gate.sh` is not in the tree
- **Raised by:** PM — 2026-10-17
- **Which record:** `nfdr.md` § 8, *Until the script lands* (`docs/nfdr.md:L1544-L1551`); QC-64's
  *verified by* tail, "Until `checks/gate.sh` lands, no command holds this entry" (`:L1658-L1659`); QC-65's
  *verified by* tail, "Until `checks/gate.sh` runs the suites that hold those cases" (`:L1706-L1709`); and
  § 9's *Toolchain* passage, "Until the script lands, the card's `swift test` in the guest holds the arm"
  (`:L2116-L2117`).
- **Tracked by:** `ka-reader · nemawashi · 2026-10-16_every-ci-rule-is-held-at-the-change`
- **What it blocks:** nothing. Each sentence's condition is half met. The script is in the tree from
  `ka-reader@8b93322`, mode `100755`, with 26 steps. The card's test command does not run it yet
  (`Test command:` on the project card), so the "no run at the change" half still holds.
- **Where it shows:** the four sentences above. Measured at `8b93322`: `grep -nE '^[[:space:]]+run:'
  .github/workflows/ci.yml` prints the gate line and the `ditto` line only; `for s in checks/tests/*.sh; do
  grep -q "$s" checks/gate.sh || echo "$s"; done` prints nothing. In the macOS guest, `checks/gate.sh` exited 0
  at `726a234`, printing `swift --version` and the SDK version first. A copy with step 13 replaced by `false`
  exited 1 with `gate.sh: step failed: Renderer gate` and ran no later step. That run includes every
  refusal suite QC-65 names.
- **If a document has to be written:** none. The fold would say the script has landed and record its guest
  run as the direct reading. It keeps the gap that the card does not run the script, and keeps QC-64's two
  tree comparisons as review gates.
- **Answer:** Confirmed, with three additions. The fold holds for the reason the item gives. Each sentence
  waits on two things: the script in the tree, and the card running it. Only the first has happened.
  `checks/gate.sh` is in the tree from `ka-reader@8b93322`, mode `100755`, with 26 `run_step` calls. The
  card's `Test command:`, re-read this run, still does not run it. So each sentence waits on the card half
  only. § 8's paragraph becomes *Until the card runs the script*, the pointers to it in QC-64, QC-65 and
  § 9's *Toolchain* passage move with it, and the v57 words stay in a dated note. A fifth sentence of the
  same kind moves too: § 9's suites bullet, "While Actions is off and the script is not in the tree, a suite
  on a workflow step alone runs nowhere" (`docs/nfdr.md:L1867`). **(1)** The guest reading at `726a234`
  carries over to `8b93322`. `git diff 726a234 8b93322 -- checks/gate.sh` only re-wraps two comments and
  changes no step. **(2)** QC-64's tail is also false in a second way. It says the two comparisons "are held
  by no script", and "That absence is the review gate's only ground". `checks/tests/test_vm_refusal.sh`
  v1.1.0 is a step of the gate (`checks/gate.sh:L77`), and it holds both comparisons more strictly. Its case
  `test_every_toplevel_suite_is_an_entire_fatal_step` requires each top-level suite to be the whole command
  of a gate step. Its case `test_moved_steps_are_single_line_commands_in_order` requires exactly one
  workflow step whose whole `run:` is `checks/gate.sh`, directly before `Package KA-Reader.app`. Run in a
  clone of `8b93322` this run, 9 of 9 cases passed. With an unlisted suite added and the runner renamed,
  both of those cases went red. The workflow case does not hold the comparison's "nothing else" half: an
  extra `run:` step before the gate step, or after packaging, passes it. That half stays a review gate,
  argued on that ground. Until the card runs the script, these cases run at no change either, so by § 8
  their gate stays `development-design`. What changes is the ground: the script holds the check, but no
  run issues it. **(3)** Nothing the NFDR names still stands in front of the card's move. The refusal is in
  the tree from `13e8d42`, and the script has passed in the guest. So the move § 8 owes `product-card` is
  ready now: the card's `Test command:` runs `checks/gate.sh`, and how the field spells that is the card's.
  Reasoning: `docs/trail/architecture/self_answer-53.md` § 3.2.

### 3.3 § 9 says each harness suite is its own CI step, and the suites are now steps of `checks/gate.sh`
- **Raised by:** PM — 2026-10-17
- **Which record:** `nfdr.md` § 9, the bullet "The harness's own suites, `checks/tests/`, run as CI steps —
  stated once, here" and its *verified by* (`docs/nfdr.md:L1843-L1938`).
- **Tracked by:** `ka-reader · nemawashi · 2026-10-16_every-ci-rule-is-held-at-the-change`
- **What it blocks:** nothing is blocked. But the bullet's rule, "a script that lands with a suite lands
  the suite's CI step in the same change", now contradicts QC-64's "the workflow holds no rule of its own". Its
  comparison, `grep -q "$s" .github/workflows/ci.yml`, now prints all eleven suites.
- **Where it shows:** at `ka-reader@8b93322` each of the eleven suites is the whole command of one
  `run_step` call in `checks/gate.sh`. The workflow's one rule step runs that script (`ci.yml:L26`). The
  bullet's step locators (`:L40-L41` … `:L101-L102` at `13e8d42`) name lines the workflow no longer has.
- **If a document has to be written:** none. The fold would say a suite joins as a step of `checks/gate.sh`,
  and that the workflow runs it through `Test gate`. It would aim the comparison at the script, as QC-64's
  tail already does, and keep the old locators as history.
- **Answer:** Confirmed, with three additions. The bullet's rule moves: a script that lands with a suite
  lands the suite as a step of `checks/gate.sh` in the same change, and the workflow runs it through
  `Test gate` (`ci.yml:L26`). The step locators at `13e8d42` stay as history. The new pin is
  `checks/gate.sh` at `ka-reader@8b93322`, and the count is still eleven: `:L50` `test_structure.sh`,
  `:L52` `test_entry_points.sh`, `:L55` `test_bundle.sh`, `:L57` `test_view.sh`, `:L67`
  `test_renderer.sh`, `:L71` `test_read_only.sh`, `:L73` `test_no_network.sh`, `:L74`
  `test_own_state.sh`, `:L77` `test_vm_refusal.sh`, `:L78` `test_launch.sh`, `:L79`
  `test_own_state_step.sh`. **(1)** A second sentence in the bullet is now false, and the item does not
  name it: "the test command (`ci.yml:L26`) runs none of them". At `8b93322`, `ci.yml:L26` is
  `run: checks/gate.sh`, which runs all eleven. **(2)** The check the tail says is owed has landed. The
  tail reads: "What is owed … a `checks/` script that runs the comparison … The day it lands, this tail
  names it and the review gate drops." `checks/tests/test_vm_refusal.sh`'s
  `test_every_toplevel_suite_is_an_entire_fatal_step` is that comparison, aimed at the script. It is
  stricter than the tail's `grep -q`, because it requires the whole command (`grep -x`). It has been in the
  tree since `13e8d42`, and it went red this run on a clone with an unlisted suite added. So the tail names
  it, and the review gate's ground becomes § 8's run gap, not a missing script. The tail's
  `grep -q … ci.yml` loop, which now prints all eleven suites, becomes history. The same suite's
  `test_no_conditional_or_nonfatal_step` holds the ruled-out way to join (`continue-on-error`, `if:`), and
  *How a suite joins* can name it. **(3)** § 10's preamble repeats "runs as its own CI step on every
  build", and it moves with the bullet. Decided together with 3.1, whose selector rests on the suites
  running inside `Test gate`. Reasoning: `docs/trail/architecture/self_answer-53.md` § 3.3.

**How it closes.** `product-architecture` folds it on its next run like any other item here.
