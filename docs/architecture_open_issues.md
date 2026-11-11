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
> `product-architecture` run. It is the answered half of what is now § 3.1 (§ 3.5 in cycle-84), moved out because that item asks two
> questions with two seats. This half is whether QC-67 owes a seam for a suite to hand a script its
> own `git`. What § 3.1 is left asking is the other half alone: may the harness suites run the
> host's real `git` and `tar`, against `testing_doctrine.md` § *A test reads nothing of the machine
> it runs on*, "the test fakes every process the code starts, the host's tools included"? That is a
> departure from core doctrine, which is the owner's, and § 3.1's slot stays open for it.
- **Lands in:** `nfdr.md` QC-67
- **Drafted into the records:** written into `nfdr.md` QC-67 at v93 (RN-103). QC-67 now says a suite hands a check script its tools, real or stand-in, by putting them first on `PATH`. `PATH` is the platform's variable, which QC-67 already places outside "a variable of the script's own", so it is neither a bound nor a seam, and no variable of a script's own chooses a tool. At `ka-reader@528c152`, `checks/tests/test_git_beta_scene.sh` links the host's `git` and `tar` into its stand-in `PATH` (`:L134-L136`), and `checks/tests/test_git_beta_walk.sh` does so for `git` (`:L216`) and, in one case, for `tar` (`:L364`). Neither script reads a variable of its own beyond the platform's `HOME`. The sentence says it does not settle whether a suite may hand a script the host's real tools; that is § 3.1.
- **Rationale:** the suites already hand the tools in the way QC-67 leaves open. A `GIT_BETA_SCENE_SH_GIT`-style variable would be a script's own variable that can swap a tool under a gate run. That is the sharper case QC-67's part (3) exists to keep out of a gate, and it would gain nothing `PATH` does not already give. Whichever way the owner settles § 3.1, the hand-off is the same: a stand-in `git` or the real one, first on `PATH`. So this half does not wait on that call.
- **If overridden:** QC-67 admits a third kind, a tool seam, with a name form and a rule that no gate step sets it. Its two owed verifiers then read that kind too, and both suites move their `git` and `tar` onto the seam.
- **Confirm or override:** confirm, with one addition to QC-67's sentence. No seam: the suites already hand a check script its tools through `PATH`, which is the platform's, and a tool seam of the script's own would be the variable part (3) keeps out of a gate. **Addition:** the suites do not put their tools *first* on `PATH`; they build the whole `PATH` the script runs under, from an empty environment (`/usr/bin/env -i PATH="$SCENE/bin:$SCENE/ordinary"`, `checks/tests/test_git_beta_scene.sh:L276`, `:L408`, `:L813`; `checks/tests/test_git_beta_walk.sh:L243`, at `ka-reader@528c152`), with every tool, real or stand-in, linked into it by name. The sentence should say that, because "first on `PATH`" leaves the host's `PATH` behind the stand-ins, where a tool a suite forgot to link would be the host's and the case would pass on it. Under the built `PATH` that tool is absent and the script refuses with "was not found on PATH" (`checks/git-beta-scene.sh:L212`). Decided in the owner's seat by a `companion-self-answer` run, 2026-11-11; the reasoning is `docs/trail/architecture/self_answer-88.md` § 2.1.

## 3. Raised from downstream — an item from a seat that did not write these records

### 3.1 The harness suites run the host's own `git` and `tar`, and QC-67 admits no seam for them
> § 3.5 in cycle-84, renumbered on the v93 fold. Its seam half is § 2.1, drafted into QC-67 at v93; what
> is left is whether the harness suites may run the host's real `git` and `tar` at all, which would set
> aside a core testing rule, so it is yours. A bounded answer is drafted in
> `docs/trail/architecture/self_answer-87.md` § *Left for the owner*, for you to take, change or refuse.
- **Raised by:** PM — 2026-11-11
- **Which record:** `nfdr.md` QC-67
- **Tracked by:** `ka-reader · nemawashi · 2026-11-08_the-check-scripts-hold-their-own-bar`
- **What it blocks:** the testing doctrine's "the test fakes every process the code starts, the host's tools included" (`testing_doctrine.md` § *A test reads nothing of the machine it runs on*) is not met by the harness, and no record says it is set aside.
- **Where it shows:** `checks/tests/test_git_beta_scene.sh` links the host's `git` and `tar` into its stand-in PATH, and `checks/tests/test_git_beta_walk.sh` builds its checkout with the host's `git` and streams it with the host's `tar` (`ka-reader@528c152`). The state cases need the real `git` to prove what `git status` says of each staged state. QC-67 lists a script's admitted variables and names no seam for a suite to hand a script its own `git`. The records' choice: admit such a seam, or state that harness suites may run the host's `git` and `tar`.
- **If a document has to be written:** none.
- **Answer:**

**How it closes.** `product-architecture` folds it on its next run like any other item here.
