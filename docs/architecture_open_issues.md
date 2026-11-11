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

---

## 1. Open issues — questions with no answer yet

None.

## 2. Choices to confirm — the Principal Architect drafted a best-effort answer; confirm or override

None.

## 3. Raised from downstream — an item from a seat that did not write these records

### 3.1 QC-65 does not name the Git beta scene helper and its host walk
- **Raised by:** PM — 2026-11-11
- **Which record:** `nfdr.md` QC-65
- **Tracked by:** `ka-reader · nemawashi · 2026-10-30_a-stranger-can-install-the-first-release`
- **What it blocks:** nothing runs wrong; QC-65's list of scripts that start the bundle with `open -n` ("Today they are …", and "The set also holds `checks/tree-scene.sh` …", `docs/nfdr.md:L2569-L2580`) is now short by one, so a reader of QC-65 cannot tell that `checks/git-beta-scene.sh` belongs to it.
- **Where it shows:** `checks/git-beta-scene.sh` and `checks/git-beta-walk.sh` are on `main` at `ka-reader@528c152` (`git ls-tree --name-only main checks/ | grep git-beta`). The scene helper starts the bundle with `open -n`; it is a person's tool and no gate step, and its suite records `open` through a stand-in, so the suite is outside the set, as the tree-scene helper's is.
- **If a document has to be written:** none.
- **Answer:**

### 3.2 § 9's suites bullet counts twenty-five suites; the tree holds twenty-seven
- **Raised by:** PM — 2026-11-11
- **Which record:** `nfdr.md` § 9, the suites bullet
- **Tracked by:** `ka-reader · nemawashi · 2026-10-30_a-stranger-can-install-the-first-release`
- **What it blocks:** a count measured false (`docs/nfdr.md:L2938`, "Twenty-five top-level shell suites are in the tree").
- **Where it shows:** `git ls-tree --name-only main checks/tests/ | grep -c '/test_.*\.sh$'` → `27` at `ka-reader@528c152`; the two added are `checks/tests/test_git_beta_scene.sh` and `checks/tests/test_git_beta_walk.sh`, each a fatal step of `checks/gate.sh` (`:L178-L179`, gate Version 1.17.0). The twenty-five may be kept as a dated reading.
- **If a document has to be written:** none.
- **Answer:**

### 3.3 QC-70's dated readings of each check script's ends do not cover the two new scripts
- **Raised by:** PM — 2026-11-11
- **Which record:** `nfdr.md` QC-70
- **Tracked by:** `ka-reader · nemawashi · 2026-10-30_a-stranger-can-install-the-first-release`
- **What it blocks:** QC-70 reads each check script's statuses; two scripts it does not list now end with statuses of their own.
- **Where it shows:** `checks/git-beta-scene.sh` ends 0, 1 (a refusal, or a state whose setup failed), 2 (a wrong invocation, before anything is set up), 130 on INT and 143 on TERM; `checks/git-beta-walk.sh` ends 1 on its own refusals (not Darwin, no `tart`, no guest, a guest without a window, a failed build in the guest) and otherwise passes the scene's status through. Both at `ka-reader@528c152`, held by `checks/tests/test_git_beta_scene.sh` and `checks/tests/test_git_beta_walk.sh`.
- **If a document has to be written:** none.
- **Answer:**

### 3.4 No record sets aside the Shell packet's pytest line, though every check suite is bash
- **Raised by:** PM — 2026-11-11
- **Which record:** `nfdr.md` § 9 (the harness), and QC-70, which sets aside only the Shell packet's two-status line
- **Tracked by:** `ka-reader · nemawashi · 2026-11-08_the-check-scripts-hold-their-own-bar`
- **What it blocks:** each change that adds a suite under `checks/tests/` diverges from the Shell packet's "The tool is pytest, and the tests are written in Python" (`languages/shell/testing.md`) with no product record behind it, and records the divergence again.
- **Where it shows:** all twenty-seven suites under `checks/tests/` are bash scripts run by `checks/gate.sh` (for example `checks/tests/test_tree_scene.sh:L1`); the macOS guest's `python3` has no pytest (`languages/shell/environment.md` § *In the macOS guest*). The choice is the records': state that the harness's suites are bash and why, or move them to pytest.
- **If a document has to be written:** none.
- **Answer:**

### 3.5 The harness suites run the host's own `git` and `tar`, and QC-67 admits no seam for them
- **Raised by:** PM — 2026-11-11
- **Which record:** `nfdr.md` QC-67
- **Tracked by:** `ka-reader · nemawashi · 2026-11-08_the-check-scripts-hold-their-own-bar`
- **What it blocks:** the testing doctrine's "the test fakes every process the code starts, the host's tools included" (`testing_doctrine.md` § *A test reads nothing of the machine it runs on*) is not met by the harness, and no record says it is set aside.
- **Where it shows:** `checks/tests/test_git_beta_scene.sh` links the host's `git` and `tar` into its stand-in PATH, and `checks/tests/test_git_beta_walk.sh` builds its checkout with the host's `git` and streams it with the host's `tar` (`ka-reader@528c152`). The state cases need the real `git` to prove what `git status` says of each staged state. QC-67 lists a script's admitted variables and names no seam for a suite to hand a script its own `git`. The records' choice: admit such a seam, or state that harness suites may run the host's `git` and `tar`.
- **If a document has to be written:** none.
- **Answer:**

**How it closes.** `product-architecture` folds it on its next run like any other item here.
