# Self-answer report — `adr/` and `nfdr.md`

## Header

- **Companion:** `docs/architecture_open_issues.md`
- **Document:** `docs/adr/` and `docs/nfdr.md` (every item names `docs/nfdr.md`; none touches a record)
- **Decided by:** `<CORE>/../skills/companion/.claude/skills/companion-self-answer/prompts/rich.md` v1.3.1
- **Date:** 2026-10-16
- **Sources re-read:** the managing instance's card, `system/projects/ka-reader/project.md` in
  `kensaiapp-opensource`, last moved at `a4204e5b`. Its **Test command** is still `cargo test --workspace
  --locked && ka-reader-mac/assemble.sh && swift test --package-path ka-reader-mac && checks/structure.sh &&
  checks/tests/test_structure.sh`, so it runs none of QC-65's guarded steps. No other answer rests on a
  source outside this repository. **What was read in this repository:** the NFDR's header, § 8, § 9, § 10
  and RN-67 in full, not the whole NFDR (580 KB); `docs/adr/README.md`'s head; and at `ka-reader@13e8d42`
  (`HEAD` is `55c2195`, and `git diff --stat 13e8d42 HEAD -- checks .github` prints nothing),
  `.github/workflows/ci.yml`'s step list, the six refusal lines, the headers and case lists of
  `test_own_state.sh`, `test_launch.sh`, `test_own_state_step.sh` and `test_vm_refusal.sh`,
  `checks/own-state.sh`'s and `checks/own-state-step.sh`'s headers, and `checks/tests/support/vm_refusal.sh`.
  No suite and no `checks/*.sh` script was run, so the `2 of 14 passed` figure is the PM's measurement,
  not this run's.

## Items worked

### 3.1 — QC-65's cost sentence says a contributor with no VM runs every step but the guarded ones, and the own-state suite now fails off a VM too

- **Bucket:** 3. Raised from downstream — an item from a seat that did not write these records
- **Verdict:** answered
- **Why:** The item offers two folds and picks neither, so this is a decision from scratch. **Name the suite
  in the cost, and leave it outside the set.** QC-65's set is defined by what a step does: it launches the
  bundle or reads the machine's home. `checks/tests/test_own_state.sh` does neither. Its header says its
  cases point `HOME` at a temporary directory, and it starts no bundle. The suite fails off a VM only because
  twelve of its fourteen cases call the real `checks/own-state.sh` with no admitting reading. That is a fact
  about how the cases are written, not about what the suite touches. Moving the suite into the set would
  stretch the set past what the owner's requirement 2 names (`docs/trail/architecture/cycle-49.md` § 3.1, by
  way of RN-67). It would also force the suite to refuse as a whole, which moves its refusal case out to
  `checks/tests/test_vm_refusal.sh`, as happened for `test_bundle.sh` and `test_renderer.sh`. That is more
  structure to make one sentence true. **Not a widening.** The cost sentence is false at `ka-reader@13e8d42`,
  and fixing it is a correction. **The item's supporting text is wrong in one place, reported and not
  edited.** It says QC-65 "forbids the one way to keep it true". QC-65 forbids an option, flag or variable *of
  the script's own* (`docs/nfdr.md:L1672-L1673`). A stand-in `uname` and `sysctl` first on `PATH` is not one.
  The suite's own `test_admits_on_a_vm_reading` already admits the real script that way
  (`checks/tests/test_own_state.sh:L279-L288`), and `checks/tests/support/vm_refusal.sh` is built on exactly
  that technique. So a third way exists: the twelve cases admit as the admit case does. That is the delivery
  tier's call, not this document's, because QC-65 already leaves "how a script tells a virtual machine from a
  physical Mac" to that tier. The answer lets the fold say so in one clause and re-measure the sentence the
  day it happens. **Check 3:** naming the suite contradicts nothing. § 9's *How a suite joins* binds only
  suites that launch or read the home, and QC-64's script runs this suite in the guest, where it is admitted.
  The other three new suites are written to run on any host (each header's *USAGE*), so the own-state suite
  is the only one outside the set that the cost sentence has to name. **Check 4:** *stale*: the sentence is
  pinned at `13e8d42`, so a change to the suite is a re-measurement. *Refused*: under the owner's-Mac option
  no gate passes anyway, and QC-65 already says so. *Empty* (a contributor with a VM): nothing changes for
  them. **What would have tipped it the other way:** a suite whose cases actually read the real
  `$HOME/Library/Containers/…`. This one does not.

### 3.2 — QC-65's "until the refusal lands" names an event that has happened

- **Bucket:** 3. Raised from downstream — an item from a seat that did not write these records
- **Verdict:** confirmed with addition
- **Why:** The item's proposed fold holds, and holds for the reason it gives. All six refusals are at the
  lines it cites at `ka-reader@13e8d42` (`checks/bundle.sh:L66`, `checks/renderer.sh:L90`,
  `checks/own-state.sh:L43`, `checks/launch.sh:L44`, `checks/tests/test_bundle.sh:L48`,
  `checks/tests/test_renderer.sh:L47`, each the `|| { echo "<name>: refused: …"` line, re-read this run).
  The suites holding the cases run only on workflow steps, and `checks/gate.sh` is not in the tree (`git show
  13e8d42:checks/gate.sh` fails). So the meanwhile clause still describes the state, but its condition is now
  the gate script's landing, not the refusal's. The card's command, re-read at source, still runs none of the
  guarded steps, so "what holds meanwhile" stays true word for word. Keeping the `Environment:` half separate
  is right: the gate tool writes that half on every change whatever the scripts hold. **Addition 1, a case
  the item missed.** The *verified by* places the refusal case "in each guarded script's suite". Two guarded
  steps are suites, `test_bundle.sh` and `test_renderer.sh`. A suite that refuses cannot run its own refusal
  case, and `checks/tests/test_vm_refusal.sh`'s header says so. Its `CASES` list holds
  `test_bundle_suite_refuses_off_vm_before_work` and `test_renderer_suite_refuses_off_vm_before_work`. The
  item credits that suite with "the workflow side" only. So the tail, and § 10's QC-65 row (a projection of
  it), name `test_vm_refusal.sh` as where those two cases live. Without it, a reader checking the tail would
  look in `test_bundle.sh` for a case that is not there. **Addition 2, a re-pin the fold may make.** QC-65's
  list of today's steps is pinned at `ka-reader@bb2e4cb`. At `13e8d42` the launch is `checks/launch.sh` and
  the own-state step is `checks/own-state-step.sh`. That script carries no admission and relies on its
  child's refusal (its header, *WHAT IT DOES NOT DO*), which `test_own_state_step.sh`'s
  `test_real_child_refusal_off_vm` proves. Nothing in the list is false, because the pin dates it. This is a
  re-measurement the fold can make while it is in the entry, not a defect. **Check 3:** the item agrees with §
  8 *Until the script lands* and QC-64, and with the 3.1 answer above (the own-state suite stays outside the
  set, and its refusal case stays in it). **Check 4:** *stale*: from the change that lands `checks/gate.sh`,
  this clause moves again, and § 8 already states that rule once. *Absent*: if `.github/workflows/ci.yml`
  leaves the tree, the gate moves to the owner's Mac and goes red, which § 8 and QC-65 already say.

### 3.3 — § 9's harness-suites count says eight, and eleven are in the tree

- **Bucket:** 3. Raised from downstream — an item from a seat that did not write these records
- **Verdict:** confirmed with addition
- **Why:** The count is false and the bullet calls itself the count's one home, so this is the strongest kind
  of correction: a measurement. `git ls-tree --name-only 13e8d42 checks/tests/` lists eleven `.sh` suites and
  `support/`. `support/` is no suite: its helper is sourced, and its header says it sits outside the
  top-level glob so no loop mistakes it for one. The bullet's own *verified by* loop, run over `13e8d42`'s
  workflow this pass, printed nothing, so all eleven are on steps. Each step's `name:` and `run:` lines were
  read from `git show 13e8d42:.github/workflows/ci.yml`, and the answer lists all eleven pairs so the fold
  can pin them in one go. **Addition 1:** `test_vm_refusal.sh` pairs with no `checks/<name>.sh`, yet the
  bullet frames its rule around "each `checks/<name>.sh` script with a suite beside it". The fold says the
  suite is counted and on a step anyway, so a reader does not hunt for its script. **Addition 2:** the tail's
  "an eighth suite … is a re-measurement" becomes "a further suite". Left as is, it names a number that is
  now history, and the next reader stalls on it. **Check 3:** QC-64's suites loop is aimed at
  `checks/gate.sh`, which is not in the tree. So the re-measured list is the one the gate-script work reads,
  and the fold, as the item says, does not claim the script runs them. **Check 4:** *stale*: the count and
  the lines are pinned at `13e8d42`, as the bullet's own rule requires.

## Left for the owner

None this run.

## Skipped

None this run.

## Companions opened

None this run.

## Launchers owed

- **`docs/adr/` and `docs/nfdr.md`** — `<CORE>/launchers/skill/launcher.sh product-architecture ka-reader`
