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

### 2.1 QC-67 states the two ways a suite builds a check script's `PATH` and requires neither: whether every suite must build it from an empty environment is open
> Raised by the v94 fold, as the residue of cycle-85 § 2.1. That answer confirmed that QC-67 owes no
> tool seam, and asked QC-67 to say the suites build the whole `PATH` from an empty environment,
> because a later suite will be written against the sentence. It is true of the two suites it read
> and not of the rest, so it went in as a reading, and the rule it implies is this question.
- **Lands in:** `nfdr.md` QC-67
- **Drafted into the records:** QC-67 at v94 (RN-104) states both forms at `ka-reader@528c152` and requires neither. Five suites build the whole `PATH` from `/usr/bin/env -i` with every tool linked in by name: the two Git beta suites, `test_tree_scene.sh`, `test_launch.sh` and `test_own_state_step.sh`. A tool such a suite forgot to supply is absent, and the script refuses. Fourteen suites put their stand-ins in front of the host's `PATH`, `PATH="$stubs:$PATH"` (`checks/tests/test_bundle.sh:L209`, `checks/tests/test_no_network.sh:L78` and twelve more, listed in QC-67). A tool such a suite forgot to stand in is the host's, and the case runs on it without anyone seeing.
- **Rationale:** as a rule, the built form would make fourteen suites known gaps in one move. The answer did not weigh that, because its ground was that the existing suites already had the property. Which form a suite must take is a call two architects could make either way: the built form closes a silent pass, and the prepend form is how most suites are written and what their stand-ins rely on. So it is not this seat's to settle on its own. It also leans on § 3.1. If the suites may not run the host's tools at all, the built form is how a case shows it, because only an empty environment proves nothing else was reached.
- **If overridden:** QC-67 states the built form as the rule for every suite that launches a check script, and names the fourteen prepend-form suites as known gaps until a change moves each one. Its `verified by:` tail gains a check of the launch lines under `checks/tests/`, held by `development-design` until one exists. § 10's QC-67 row gains it too.
- **Confirm or override:** override: QC-67 makes the built form the rule — every suite under `checks/tests/` that launches a check script launches it under `/usr/bin/env -i` with a `PATH` made only of directories the suite built, every tool on it, real or stand-in, linked in by name, and no host directory (`$PATH`, `/usr/bin`, `/bin`) on it. It realizes `testing_doctrine.md` § *A test reads nothing of the machine it runs on* ("the test fakes every process the code starts, the host's tools included") as a doctrine default, and it holds on either answer to § 3.1: under the doctrine as written it is how a case shows nothing else was reached, and under a bounded departure it is what keeps every host tool named. The dated reading needs correcting as the rule goes in, because it has three forms at `ka-reader@528c152`, not two. Built: six suites — the five named, plus `test_vm_refusal.sh` through `checks/tests/support/vm_refusal.sh:L190-L191`. Prepend: the fourteen named. Host `PATH` taken whole, with no stand-in on it: `test_release_shape.sh`, `test_release_sums.sh`, `test_release_version.sh`, `test_secret_scan_planted.sh`, `test_strings.sh` and `test_structure.sh`. `test_strings_step.sh` runs copies of `checks/gate.sh`, and the fold measures its form. Every suite outside the built form is a known gap until a change moves it, and `test_notices.sh:L490`'s `PATH="$STUBS:/usr/bin:/bin"` is a gap too. Make the `verified by:` tail and § 10's QC-67 row as drafted under *If overridden*: a layer-6 scan of the launch lines under `checks/tests/`, with `development-design` holding it until the scan exists. Uncovered, and named: a check script that calls a tool by absolute path reaches the host's tool under any `PATH`. None does at `528c152`. Reasoning: `docs/trail/architecture/self_answer-89.md` § 2.1.

## 3. Raised from downstream — an item from a seat that did not write these records

### 3.1 The harness suites run the host's own `git` and `tar`, and QC-67 admits no seam for them
> § 3.5 in cycle-84, renumbered on the v93 fold. Its seam half was cycle-85 § 2.1, confirmed into
> QC-67 at v94: no tool seam, a suite hands a script its tools through `PATH`. What is left is whether
> the harness suites may run the host's real `git` and `tar` at all, which would set aside a core
> testing rule, so it is yours. A bounded answer is drafted in
> `docs/trail/architecture/self_answer-87.md` § *Left for the owner*, for you to take, change or refuse.
- **Raised by:** PM — 2026-11-11
- **Which record:** `nfdr.md` QC-67
- **Tracked by:** `ka-reader · nemawashi · 2026-11-08_the-check-scripts-hold-their-own-bar`
- **What it blocks:** the testing doctrine's "the test fakes every process the code starts, the host's tools included" (`testing_doctrine.md` § *A test reads nothing of the machine it runs on*) is not met by the harness, and no record says it is set aside.
- **Where it shows:** `checks/tests/test_git_beta_scene.sh` links the host's `git` and `tar` into its stand-in PATH, and `checks/tests/test_git_beta_walk.sh` builds its checkout with the host's `git` and streams it with the host's `tar` (`ka-reader@528c152`). The state cases need the real `git` to prove what `git status` says of each staged state. QC-67 lists a script's admitted variables and names no seam for a suite to hand a script its own `git`. The records' choice: admit such a seam, or state that harness suites may run the host's `git` and `tar`.
- **If a document has to be written:** none.
- **Answer:**

**How it closes.** `product-architecture` folds it on its next run like any other item here.
