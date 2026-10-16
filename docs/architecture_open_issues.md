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

> **No `product-architecture` run wrote this file.** The PM opened it on 2026-10-16, from a
> `shukuba-refine` review on the seed `ka-reader · nemawashi · 2026-10-16_every-ci-rule-is-held-at-the-change`,
> to carry items 3.1 to 3.3 below. The NFDR is Settled, so without a companion they would reach no one.

---

## 1. Open issues — questions with no answer yet

None.

## 2. Choices to confirm — the Principal Architect drafted a best-effort answer; confirm or override

None.

## 3. Raised from downstream — an item from a seat that did not write these records

### 3.1 QC-65's cost sentence says a contributor with no VM runs every step but the guarded ones, and the own-state suite now fails off a VM too
- **Raised by:** PM — 2026-10-16
- **Which record:** `nfdr.md` QC-65, its cost sentence (`docs/nfdr.md:L1677-L1679`): "a contributor with
  no virtual machine runs every step but these".
- **Tracked by:** `ka-reader · nemawashi · 2026-10-16_every-ci-rule-is-held-at-the-change`
- **What it blocks:** nothing is blocked. The sentence is false at `ka-reader@13e8d42`. `checks/own-state.sh`
  refuses off a VM (`checks/own-state.sh:L43`). The own-state suite is outside QC-65's set, but its cases run
  that script, so off a VM they get the refusal. Measured on the owner's Mac in a clone at `13e8d42`:
  `checks/tests/test_own_state.sh` exits 1, `2 of 14 passed`. Only the refusal case and the admit case pass.
- **Where it shows:** QC-65's cost sentence. QC-65 also forbids the one way to keep it true: the script
  offers "no option, flag or variable of its own that skips the refusal", so a `HOME` the suite sets cannot
  turn it off.
- **If a document has to be written:** none. The fold either names the own-state suite in the cost (it
  stays outside the guarded set, and still cannot pass off a VM), or moves that suite into the set. The
  choice is the Principal Architect's.
- **Answer:** Name the suite in the cost; do not move it into the set. The own-state suite, `checks/tests/test_own_state.sh`, launches nothing and reads no machine home: its cases point `HOME` at a temporary directory (its header, *WHY THIS EXISTS*, at `ka-reader@13e8d42`). So by QC-65's own definition it is outside the set. Moving it in would stretch the set past what the owner's requirement 2 names, and its refusal case would have to move out to `checks/tests/test_vm_refusal.sh`, as the two guarded suites' did. The fold rewrites the cost sentence, pinned at `ka-reader@13e8d42`: a contributor with no virtual machine runs every step but the guarded ones and the own-state suite. That suite is outside the set and still fails off a VM, because twelve of its fourteen cases run the real `checks/own-state.sh` with no admitting reading (the PM's measurement: exit 1, `2 of 14 passed`). One correction to this item's own text: QC-65 does not forbid the way to make the suite pass off a VM. It forbids an option, flag or variable *of the script's own*. A stand-in `uname` and `sysctl` first on `PATH` is not one, and the suite's `test_admits_on_a_vm_reading` already admits the real script that way (`checks/tests/test_own_state.sh:L279-L288`). The fold may say so in one clause. Whether the other cases admit the same way is the delivery tier's call, and the cost sentence is re-measured the day they do. Reasoning: `docs/trail/architecture/self_answer-52.md` § 3.1.

### 3.2 QC-65's "until the refusal lands" names an event that has happened
- **Raised by:** PM — 2026-10-16
- **Which record:** `nfdr.md` QC-65, *verified by* (`docs/nfdr.md:L1685-L1689`): "Until the refusal lands,
  no command holds this entry, and `development-design` reading it is its gate."
- **Tracked by:** `ka-reader · nemawashi · 2026-10-16_every-ci-rule-is-held-at-the-change`
- **What it blocks:** nothing. At `ka-reader@13e8d42` all six guarded steps refuse off a VM (`checks/bundle.sh:L66`,
  `checks/renderer.sh:L90`, `checks/own-state.sh:L43`, `checks/launch.sh:L44`,
  `checks/tests/test_bundle.sh:L48`, `checks/tests/test_renderer.sh:L47`). Each guarded script's suite holds
  the refusal case, and `checks/tests/test_vm_refusal.sh` holds the workflow side. Those suites still run
  only on workflow steps (`.github/workflows/ci.yml:L53-L102`), and Actions is off. So the meanwhile clause
  still holds at the card, but its condition is now `checks/gate.sh` landing, not the refusal.
- **Where it shows:** QC-65's *verified by*, its temporary-gate sentence.
- **If a document has to be written:** none. The fold would name the refusal cases as landed, and keep the
  gap until `checks/gate.sh` runs them (QC-64; § 8, *Until the script lands*). It keeps the every-change
  `Environment:` half separate.
- **Answer:** Confirm the fold this item proposes, with two additions. The refusal has landed. All six guarded steps refuse off a VM at `ka-reader@13e8d42`, at the lines this item cites (re-read this run), and the card's test command still runs none of them (re-read 2026-10-16). So the fold replaces "Until the refusal lands" as follows. The refusal and its cases are in the tree from `ka-reader@13e8d42`. Until `checks/gate.sh` runs the suites that hold those cases (QC-64; § 8, *Until the script lands*), no run holds the entry's suite half, and `development-design` reading it is its gate. What holds meanwhile is still that the card's command runs none of these steps. The every-change `Environment:` half stays separate. **Addition 1 — where the cases live.** The *verified by* says the refusal case is "in each guarded script's suite". That is true of `checks/bundle.sh`, `checks/renderer.sh`, `checks/own-state.sh` and `checks/launch.sh`. But two guarded steps are suites themselves, `checks/tests/test_bundle.sh` and `checks/tests/test_renderer.sh`, and a suite that refuses cannot run its own refusal case. Those two cases are in `checks/tests/test_vm_refusal.sh` (its header, *WHY THIS EXISTS*, and its `CASES` list). The fold names that suite in the tail, and § 10's QC-65 row follows. **Addition 2 — the set's locators.** They are pinned at `ka-reader@bb2e4cb`. At `ka-reader@13e8d42` the launch runs through `checks/launch.sh`, and the own-state step runs through `checks/own-state-step.sh`. That script has no admission of its own and relies on its child's refusal (its header, *WHAT IT DOES NOT DO*). The fold may re-pin the set at `13e8d42`. That is a re-measurement, not a defect. Reasoning: `docs/trail/architecture/self_answer-52.md` § 3.2.

### 3.3 § 9's harness-suites count says eight, and eleven are in the tree
- **Raised by:** PM — 2026-10-16
- **Which record:** `nfdr.md` § 9, the harness-suites bullet (`docs/nfdr.md:L1818-L1838`), which calls itself
  the count's one home.
- **Tracked by:** `ka-reader · nemawashi · 2026-10-16_every-ci-rule-is-held-at-the-change`
- **What it blocks:** QC-64's suites comparison is aimed at this list, and the gate-script work reads it.
- **Where it shows:** "Eight suites are in the tree". `git ls-tree --name-only 13e8d42 checks/tests/` lists
  eleven `.sh` suites. The three new ones are `test_launch.sh`, `test_own_state_step.sh` and
  `test_vm_refusal.sh`, each the whole `run` of its own step (`.github/workflows/ci.yml:L95-L102`). The
  bullet itself says a new suite is a re-measurement, not a contradiction.
- **If a document has to be written:** none. The fold re-measures the count and the step locators at a
  named commit. It keeps the earlier counts as history, and does not claim `checks/gate.sh` runs them yet.
- **Answer:** Confirm: the fold re-measures the count to eleven at `ka-reader@13e8d42` and keeps eight as history. `git ls-tree --name-only 13e8d42 checks/tests/` lists eleven `.sh` suites and the `support/` folder. That folder is not a suite: it holds the sourced helper `vm_refusal.sh`, kept outside the `checks/tests/*.sh` glob on purpose (its header). The bullet's own loop over the workflow prints nothing at `13e8d42` (re-run this pass), so all eleven are on steps, each the whole `run` of its own step: `:L40-L41` `test_structure.sh`, `:L46-L47` `test_entry_points.sh`, `:L53-L54` `test_bundle.sh`, `:L59-L60` `test_view.sh`, `:L70-L71` `test_renderer.sh`, `:L82-L83` `test_read_only.sh`, `:L88-L89` `test_no_network.sh`, `:L91-L92` `test_own_state.sh`, `:L95-L96` `test_vm_refusal.sh`, `:L98-L99` `test_launch.sh`, `:L101-L102` `test_own_state_step.sh`. Two additions. (1) One of the eleven pairs with no script. `test_vm_refusal.sh` tests two other suites' refusals and the workflow's shape, while the bullet opens on "each `checks/<name>.sh` script with a suite beside it". So the fold says that this suite is counted and on a step, though no script stands beside it. (2) The bullet's tail reads "an eighth suite, or a step inserted above these, is a re-measurement". At eleven that reads wrong, so the fold makes it "a further suite". As this item says, the fold does not claim `checks/gate.sh` runs them yet. Reasoning: `docs/trail/architecture/self_answer-52.md` § 3.3.

**How it closes.** `product-architecture` folds it on its next run like any other item here.
