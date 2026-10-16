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
- **Answer:** <the owner fills this in>

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
- **Answer:** <the owner fills this in>

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
- **Answer:** <the owner fills this in>

**How it closes.** `product-architecture` folds it on its next run like any other item here.
