# Self-answer report — `adr/` and `nfdr.md` (KA-Reader architecture records)

## Header

- **Companion:** `docs/architecture_open_issues.md`
- **Document:** `docs/adr/` and `docs/nfdr.md`. Both open items bear on the NFDR (v93, Draft), and no ADR moves.
- **Decided by:** `<CORE>/../skills/companion/.claude/skills/companion-self-answer/prompts/rich.md` v1.3.1
- **Date:** 2026-11-11
- **Sources re-read:** None. Neither answer rests on a source outside this repository and the
  managing core. The core rule 3.1 turns on, `testing_doctrine.md` v2.9.0 § *A test reads nothing
  of the machine it runs on*, was read at the managing core itself.

Read for this run: the companion, whole; `docs/trail/architecture/self_answer-87.md`, whole, which
raised § 2.1 and drafted the answer to § 3.1's remainder; NFDR v93's header and version line, QC-67
whole, and RN-103 whole. From the managing core: `testing_doctrine.md` v2.9.0 § *A test reads
nothing of the machine it runs on*, through its table of which place checks which rule. Measured
at `main` (`44757d1`), whose `checks/`, `crates/` and `ka-reader-mac/` are `528c152`'s
(`git log 528c152..HEAD` over those paths is empty): `checks/tests/test_git_beta_scene.sh`
`:L134-L136`, `:L276`, `:L408`, `:L813`; `checks/tests/test_git_beta_walk.sh:L53`, `:L210-L216`,
`:L243`, `:L361-L364`; `checks/tests/support/vm_refusal.sh:L64`, `:L149-L157`;
`checks/git-beta-scene.sh:L208-L214`; and the suites whose headers say a stub "runs the real" tool
(`grep -ln`): `test_entry_points.sh`, `test_notices.sh`, `test_no_network.sh`,
`test_secret_scan.sh`, `test_secret_scan_planted.sh`.

## Items worked

### 2.1 — QC-67 admits no seam for handing a check script its `git` or `tar`: a suite hands a script its tools through `PATH`, which QC-67 already names as the platform's

- **Bucket:** 2. Choices to confirm — the Principal Architect drafted a best-effort answer; confirm or override
- **Verdict:** confirmed with addition
- **Why:** The draft holds: QC-67 needs no tool seam. One phrase in the sentence it put into QC-67
  describes the suites more weakly than they work, and it should be fixed on the fold.

  **Whose call (check 1).** This document's. Only QC-67's own sentence moves, and it binds no
  person or outside party. It was split out of what is now § 3.1 by `self_answer-87.md`, whose
  three-condition argument for the split I re-read and which still holds. Whatever the owner rules
  on § 3.1, the tool reaches the script the same way.

  **Is the draft sound (check 2).** Its conclusion is right, and so is its reason. QC-67's taxonomy
  covers "a variable of the script's own — one the script names, not the platform's `PATH`, `HOME`
  or `TMPDIR`". A `GIT_BETA_SCENE_SH_GIT` variable would be a script's own variable that can swap a
  tool under a gate run, which is what part (3) keeps out of a gate. The draft is right to refuse
  it.

  **The addition.** The sentence says a suite hands a script its tools "by putting them first on
  `PATH`". That is not what the suites do. Each runs the script under `/usr/bin/env -i
  PATH="$SCENE/bin:$SCENE/ordinary"` (`test_git_beta_scene.sh:L276`, `:L408`, `:L813`;
  `test_git_beta_walk.sh:L243`). That is a whole `PATH` built from an empty environment, with every
  tool, real or stand-in, linked into it by name (`:L134-L136`; `:L210-L216`;
  `support/vm_refusal.sh:L149-L157`). The difference matters on the *absent* failure path. With
  "first on `PATH`", the host's own `PATH` still sits behind the stand-ins. A tool a suite forgot to
  link would then be found on the host, and the case would pass on it without anyone seeing. Under
  the built `PATH` the tool is missing, and the script refuses with "was not found on PATH"
  (`checks/git-beta-scene.sh:L212`). So QC-67 should state the stronger form the suites actually
  use. That form is also what keeps a stand-in from being bypassed.

  **Checked against the settled record (check 3).** Part (3) still holds: no gate step sets the
  suites' `PATH`. So does QC-65's reading that a stand-in `uname` and `sysctl` on `PATH` is "not an
  option, flag or variable of the script's own", because that is the same built `PATH`. This answer
  agrees with my answer under § 3.1 below. Both read the same `env -i` lines, and the hand-off
  carries the real tool or a stand-in unchanged either way.

  **Failure paths (check 4).** *Absent*: covered by the addition. *Stale*: the line numbers are
  dated readings at `528c152`, which QC-67's own pins already allow for. *Concurrent*, *empty* and
  *refused* do not arise for a sentence about how a suite builds its environment.

  **Where I was close to a different verdict.** I was close to a plain confirm, because "first" is
  literally true of the built `PATH`. What tipped it is that the sentence is the rule a later suite
  will be written against. A suite that prepends to the host's `PATH` meets "first on `PATH`" as
  written and loses the property the existing suites have.

## Left for the owner

### 3.1 — The harness suites run the host's own `git` and `tar`, and QC-67 admits no seam for them

- **Bucket:** 3. Raised from downstream — an item from a seat that did not write these records
- **Verdict:** left for the owner
- **Why:** This is the remainder of the item after its QC-67 half went to § 2.1. It asks whether
  the harness suites may run the host's real `git` and `tar` at all. `testing_doctrine.md` v2.9.0
  says "the test fakes every process the code starts, the host's tools included", and says this
  holds "on every layer, in every language, in every instance and every product". That is core
  doctrine, not a language packet. `languages/README.md` § Precedence lets the NFDR set aside a
  packet's line, as QC-70 and § 9 already do, but it does not reach doctrine. The cross-role
  contract says "Doctrine is user-owned; role-level override of doctrine is not permitted". So any
  sentence in the NFDR allowing the host's tools would be a seat relaxing your rule. Nothing has
  changed since `self_answer-87.md` reached the same verdict. The doctrine is at the same version,
  no answer of yours bears on it, and the suites are unmoved at `528c152`. The ground I cannot see,
  named: whether you meant the host-tools rule to reach a shell product's own check suites.

  **A premise you should have, measured this run, and not a second question.** The item, and the
  answer drafted last run, frame the departure as `git` and `tar` (and `cargo` in older suites). It
  is wider than that. Every harness suite that runs a check script under a stand-in `PATH` links
  the host's ordinary tools into it as real binaries. `support/vm_refusal.sh:L64` lists 37 of them
  (`bash`, `sh`, `awk`, `sed`, `grep`, `find`, `cp`, `rm`, `date`, `stat`, …), and
  `test_git_beta_walk.sh:L53` lists 26. A check script is a shell script, and these tools are what it
  is made of. Faking `sed` and `awk` for a script whose job is reading text would test the fakes.
  So the doctrine as written cannot be met by this product's check suites at all, not only by the
  two Git cases. That does not make the call for you. It does take one option off the table: you
  cannot rule "the doctrine binds as written" and expect a small rewrite of two state cases. That
  ruling would mean rewriting every harness suite, or deciding that shell check suites are outside
  the rule.
- **The answer I would have given:** keep the real tools, bounded, and record it as a departure you
  authorize, either as an exception in `testing_doctrine.md` or in NFDR § 9 under your answer. The
  bound I would write has four parts:
  1. **The script's own language.** A suite may link the host's shell and its ordinary text and
     file tools into the `PATH` it builds for the script. These are the tools the script is
     written in.
  2. **Tools whose output is the subject.** A suite may run the host's `git` or `tar` only where the
     case asserts what that tool makes of a state the suite built, and only on temporary copies the
     suite made. The scene's state cases exist to prove what `git status` says of each staged
     state, which is what a person compares with the app's window (`test_git_beta_scene.sh` reads
     it back with the real `git`). A stand-in `git` there would prove the stand-in.
  3. **Machine configuration is shut out.** Every such run shuts out machine-level `git`
     configuration (`GIT_CONFIG_GLOBAL=/dev/null`, `GIT_CONFIG_NOSYSTEM=1`, and `GIT_CONFIG_COUNT=0`
     where a commit is made), as both suites already do.
  4. **Everything else is faked, and nothing leaks in.** Every tool that reaches outside the
     temporary folder, or whose answer is what the script refuses on, stays a stand-in: `open`,
     `tart`, `uname`, `sysctl`, `ps`, `kill`, `screencapture`. The `PATH` is built from an empty
     environment (§ 2.1), so no host tool reaches the script that the suite did not name.

  The doctrine's own ground, that a host tool "can be missing on the next machine, or behave
  differently there", is real but small here. Every suite runs in the one macOS guest, and `git` is
  a precondition of the gate anyway, because *Secret scan* runs it. If you rule instead that the
  doctrine binds as written, part 1 is where it bites. The five suites whose headers say a stub
  "runs the real" tool, and every suite that calls `vmr_install_ordinary`, would all have to move,
  not only the two Git suites.

## Skipped

None this run. Both open items had owner slots, and the invocation listed no items, so both were
this run's.

## Companions opened

None this run. No upstream document is owed a change. § 3.1's remainder is your call on core
doctrine. `testing_doctrine.md` has no companion template, so there is no companion to open, and
the call reaches you through this report.

## Launchers owed

- **docs/adr/ and docs/nfdr.md** — `<CORE>/launchers/skill/launcher.sh product-architecture ka-reader`
