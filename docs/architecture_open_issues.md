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

### 2.1 QC-67 admits no seam for handing a check script its `git` or `tar`: a suite hands a script its tools through `PATH`, which QC-67 already names as the platform's
> Raised by `companion-self-answer` (report `docs/trail/architecture/self_answer-87.md`), not by a
> `product-architecture` run. It is the answered half of § 3.5, moved out because § 3.5 asks two
> questions with two seats. This half is whether QC-67 owes a seam for a suite to hand a script its
> own `git`. What § 3.5 is left asking is the other half alone: may the harness suites run the
> host's real `git` and `tar`, against `testing_doctrine.md` § *A test reads nothing of the machine
> it runs on*, "the test fakes every process the code starts, the host's tools included"? That is a
> departure from core doctrine, which is the owner's, and § 3.5's slot stays open for it.
- **Lands in:** `nfdr.md` QC-67
- **Drafted into the records:** not yet written. On the fold, QC-67 gains one sentence: a suite hands a check script its tools, real or stand-in, by putting them first on `PATH`. `PATH` is the platform's variable, which QC-67 already places outside "a variable of the script's own", so it is neither a bound nor a seam. QC-67 admits no variable of a script's own for choosing a tool. At `ka-reader@528c152`, `checks/tests/test_git_beta_scene.sh` links the host's `git` and `tar` into its stand-in `PATH` (`:L134-L136`), and `checks/tests/test_git_beta_walk.sh` does so for `git` (`:L216`) and, in one case, for `tar` (`:L364`). Neither script reads a variable of its own beyond the platform's `HOME`.
- **Rationale:** the suites already hand the tools in the way QC-67 leaves open. A `GIT_BETA_SCENE_SH_GIT`-style variable would be a script's own variable that can swap a tool under a gate run. That is the sharper case QC-67's part (3) exists to keep out of a gate, and it would gain nothing `PATH` does not already give. Whichever way the owner settles § 3.5, the hand-off is the same: a stand-in `git` or the real one, first on `PATH`. So this half does not wait on that call.
- **If overridden:** QC-67 admits a third kind, a tool seam, with a name form and a rule that no gate step sets it. Its two owed verifiers then read that kind too, and both suites move their `git` and `tar` onto the seam.
- **Confirm or override:** <"confirm", or "override: <what to do instead>">

## 3. Raised from downstream — an item from a seat that did not write these records

### 3.1 QC-65 does not name the Git beta scene helper and its host walk
- **Raised by:** PM — 2026-11-11
- **Which record:** `nfdr.md` QC-65
- **Tracked by:** `ka-reader · nemawashi · 2026-10-30_a-stranger-can-install-the-first-release`
- **What it blocks:** nothing runs wrong; QC-65's list of scripts that start the bundle with `open -n` ("Today they are …", and "The set also holds `checks/tree-scene.sh` …", `docs/nfdr.md:L2569-L2580`) is now short by one, so a reader of QC-65 cannot tell that `checks/git-beta-scene.sh` belongs to it.
- **Where it shows:** `checks/git-beta-scene.sh` and `checks/git-beta-walk.sh` are on `main` at `ka-reader@528c152` (`git ls-tree --name-only main checks/ | grep git-beta`). The scene helper starts the bundle with `open -n`; it is a person's tool and no gate step, and its suite records `open` through a stand-in, so the suite is outside the set, as the tree-scene helper's is.
- **If a document has to be written:** none.
- **Answer:** QC-65's *The set also holds* sentence names `checks/git-beta-scene.sh` beside `checks/tree-scene.sh`, re-pinned at `ka-reader@528c152`, with the `2529a42` and `13e8d42` readings kept as dated ones. The helper starts the bundle with `open -n` (`checks/git-beta-scene.sh:L643`) and refuses off a virtual machine before it sets up or launches anything (`:L106`). It is a person's tool and no gate step. The gate runs its suite, `checks/tests/test_git_beta_scene.sh` (*Git beta scene helper suite*, `checks/gate.sh:L178`), which records `open` through a stand-in and launches nothing, so that suite is outside the set, as the tree-scene helper's is. The tail's verifiers gain `test_off_a_vm_it_exits_one_having_launched_nothing_copied_nothing_and_read_no_home` (`checks/tests/test_git_beta_scene.sh:L312`) and `test_the_git_beta_helper_refuses_off_a_vm_in_the_refusal_suite` (`checks/tests/test_vm_refusal.sh:L217`), and § 10's QC-65 row follows. The same sentence names the two host walks, `checks/git-beta-walk.sh` and `checks/tree-walk.sh`, as **outside** the set, with the reason, so neither reads as missed. Each runs on the host by design and starts no bundle there: it builds and launches inside the guest through `tart exec`, where the helper's own refusal applies. Neither reads the app's container; each writes its results to a folder on the host's Desktop (`~/Desktop/git-beta-walk/`, `~/Desktop/tree-walk-end.png`). The reasoning is in `docs/trail/architecture/self_answer-87.md`.

### 3.2 § 9's suites bullet counts twenty-five suites; the tree holds twenty-seven
- **Raised by:** PM — 2026-11-11
- **Which record:** `nfdr.md` § 9, the suites bullet
- **Tracked by:** `ka-reader · nemawashi · 2026-10-30_a-stranger-can-install-the-first-release`
- **What it blocks:** a count measured false (`docs/nfdr.md:L2938`, "Twenty-five top-level shell suites are in the tree").
- **Where it shows:** `git ls-tree --name-only main checks/tests/ | grep -c '/test_.*\.sh$'` → `27` at `ka-reader@528c152`; the two added are `checks/tests/test_git_beta_scene.sh` and `checks/tests/test_git_beta_walk.sh`, each a fatal step of `checks/gate.sh` (`:L178-L179`, gate Version 1.17.0). The twenty-five may be kept as a dated reading.
- **If a document has to be written:** none.
- **Answer:** § 9's suites bullet is re-measured at `ka-reader@528c152`. It now counts twenty-seven top-level shell suites, each the whole command of one `run_step` line of `checks/gate.sh` (1.17.0): `test_secret_scan.sh` (`:L71`), `test_secret_scan_planted.sh` (`:L89`), `test_structure.sh` (`:L102`), `test_entry_points.sh` (`:L104`), `test_bundle.sh` (`:L107`), `test_view.sh` (`:L109`), `test_renderer.sh` (`:L119`), `test_read_only.sh` (`:L130`), `test_no_network.sh` (`:L132`), `test_notices.sh` (`:L140`), `test_offline_page.sh` (`:L142`), `test_strings.sh` (`:L148`), `test_strings_step.sh` (`:L149`), `test_readme.sh` (`:L153`), `test_git_beta.sh` (`:L155`), `test_release_shape.sh` (`:L162`), `test_release_version.sh` (`:L163`), `test_release_pack.sh` (`:L164`), `test_release_sums.sh` (`:L165`), `test_release_absent.sh` (`:L166`), `test_own_state.sh` (`:L167`), `test_vm_refusal.sh` (`:L174`), `test_launch.sh` (`:L175`), `test_own_state_step.sh` (`:L176`), `test_tree_scene.sh` (`:L177`), `test_git_beta_scene.sh` (`:L178`) and `test_git_beta_walk.sh` (`:L179`). The twenty-five at `7a88215` stays as a dated reading. Two sentences of the same bullet were left behind by earlier re-measurements and move with this one. "Three of the twenty-three have no `checks/<name>.sh` of their own name" reads "three of the twenty-seven": they are still `test_secret_scan_planted.sh`, `test_strings_step.sh` and `test_vm_refusal.sh`. The four suites added since v89 pair by name with `checks/readme.sh`, `checks/git-beta.sh`, `checks/git-beta-scene.sh` and `checks/git-beta-walk.sh`. The workflow's `Test gate` clause, "and through it all seventeen", reads "all twenty-seven". The reasoning is in `docs/trail/architecture/self_answer-87.md`.

### 3.3 QC-70's dated readings of each check script's ends do not cover the two new scripts
- **Raised by:** PM — 2026-11-11
- **Which record:** `nfdr.md` QC-70
- **Tracked by:** `ka-reader · nemawashi · 2026-10-30_a-stranger-can-install-the-first-release`
- **What it blocks:** QC-70 reads each check script's statuses; two scripts it does not list now end with statuses of their own.
- **Where it shows:** `checks/git-beta-scene.sh` ends 0, 1 (a refusal, or a state whose setup failed), 2 (a wrong invocation, before anything is set up), 130 on INT and 143 on TERM; `checks/git-beta-walk.sh` ends 1 on its own refusals (not Darwin, no `tart`, no guest, a guest without a window, a failed build in the guest) and otherwise passes the scene's status through. Both at `ka-reader@528c152`, held by `checks/tests/test_git_beta_scene.sh` and `checks/tests/test_git_beta_walk.sh`.
- **If a document has to be written:** none.
- **Answer:** QC-70 gains a dated reading at `ka-reader@528c152`. `checks/git-beta-scene.sh` 1.3.2 states its statuses in its header (`:L47-L51`). It ends 0 once every requested state is walked, and 1 on a refusal: off a virtual machine, a Desktop folder of a copy's name with no note, a state whose setup failed, no new process after `open`, or end of input. It ends 2 on a wrong invocation, before anything is read or launched, and 130 on INT and 143 on TERM (`:L285-L286`). `checks/git-beta-walk.sh` 1.0.0 ends 1 on its own refusals and otherwise with the scene's status (`exit "$scene_status"`, `:L201`). That is the pass-through QC-70 admits, and `checks/tree-walk.sh` already takes it. Their suites hold each status: `test_git_beta_scene.sh` `:L312`, `:L325`, `:L350`, `:L376`, `:L391`, `:L476` and `:L993`, and `test_git_beta_walk.sh` `:L265`–`:L301` and `test_the_scenes_status_is_the_scripts_status` (`:L378`). Every status is in the five. The fold carries two additions. (1) The scene's 2 is not only an argument count. It is also returned for an argument it does not take: a built-from line with a line break, an id that is not a state id, or an id given twice (`:L153`, `:L167`, `:L170`; case `:L350`). So QC-70's definition of 2 reads "an argument count, or an argument, the script does not take". (2) The literal scan `grep -ohE 'exit [0-9]+' checks/*.sh` now prints 3 as well. The 3 comes from awk programs inside two command substitutions in `checks/readme.sh` (`:L85`, `:L92`, `:L171`), and each is mapped to 1 before the script ends (`:L95-L103`, `:L172`). The reading says so, and "the literal scan still finds only 0, 1, 2, 130 and 143" stays as the `06e4a34` reading. One case is named as uncovered: the walk passes through whatever `tart exec` returns. That is the scene's status when the guest answers, but a guest lost mid-scene returns tart's own status, which no case holds. The reasoning is in `docs/trail/architecture/self_answer-87.md`.

### 3.4 No record sets aside the Shell packet's pytest line, though every check suite is bash
- **Raised by:** PM — 2026-11-11
- **Which record:** `nfdr.md` § 9 (the harness), and QC-70, which sets aside only the Shell packet's two-status line
- **Tracked by:** `ka-reader · nemawashi · 2026-11-08_the-check-scripts-hold-their-own-bar`
- **What it blocks:** each change that adds a suite under `checks/tests/` diverges from the Shell packet's "The tool is pytest, and the tests are written in Python" (`languages/shell/testing.md`) with no product record behind it, and records the divergence again.
- **Where it shows:** all twenty-seven suites under `checks/tests/` are bash scripts run by `checks/gate.sh` (for example `checks/tests/test_tree_scene.sh:L1`); the macOS guest's `python3` has no pytest (`languages/shell/environment.md` § *In the macOS guest*). The choice is the records': state that the harness's suites are bash and why, or move them to pytest.
- **If a document has to be written:** none.
- **Answer:** § 9's harness bullet states that every suite under `checks/tests/` is a bash script that is its own runner, run as a fatal step of `checks/gate.sh`. It sets aside the Shell packet's "The tool is pytest, and the tests are written in Python" (`languages/shell/testing.md` v1.3.0) for `checks/tests/`, under `languages/README.md` § Precedence, as QC-70 sets aside the two-status line. The suites stay bash and do not move to pytest. Three grounds. First, the product carries no Python: the one `.py` file in the tree is the highlighter fixture `checks/fixtures/highlight/sample.py`. Second, the guest's `python3` has no pytest (`languages/shell/environment.md` § *In the macOS guest*), so pytest would add a `pip install` of an unpinned package at every gate run, a step reaching the network beside the two § 8 names. Third, moving twenty-seven suites gains no rule. The statement goes in § 9 and not in QC-70, which is about statuses. It is held by `find checks/tests -maxdepth 1 -type f ! -name '*.sh'` printing nothing, which matters because the gate's membership checks read `checks/tests/*.sh` alone, so a suite in another form would join no step. That check is not in the tree, so `development-design` reading the entry is its gate until it lands. The reasoning, and a stale citation in two suite headers found on the way, are in `docs/trail/architecture/self_answer-87.md`.

### 3.5 The harness suites run the host's own `git` and `tar`, and QC-67 admits no seam for them
- **Raised by:** PM — 2026-11-11
- **Which record:** `nfdr.md` QC-67
- **Tracked by:** `ka-reader · nemawashi · 2026-11-08_the-check-scripts-hold-their-own-bar`
- **What it blocks:** the testing doctrine's "the test fakes every process the code starts, the host's tools included" (`testing_doctrine.md` § *A test reads nothing of the machine it runs on*) is not met by the harness, and no record says it is set aside.
- **Where it shows:** `checks/tests/test_git_beta_scene.sh` links the host's `git` and `tar` into its stand-in PATH, and `checks/tests/test_git_beta_walk.sh` builds its checkout with the host's `git` and streams it with the host's `tar` (`ka-reader@528c152`). The state cases need the real `git` to prove what `git status` says of each staged state. QC-67 lists a script's admitted variables and names no seam for a suite to hand a script its own `git`. The records' choice: admit such a seam, or state that harness suites may run the host's `git` and `tar`.
- **If a document has to be written:** none.
- **Answer:**

**How it closes.** `product-architecture` folds it on its next run like any other item here.
