# Self-answer report — `adr/` and `nfdr.md` (KA-Reader architecture records)

## Header

- **Companion:** `docs/architecture_open_issues.md`
- **Document:** `docs/adr/` and `docs/nfdr.md`. Both open items bear on the NFDR (v94, Draft), and no ADR moves.
- **Decided by:** `<CORE>/../skills/companion/.claude/skills/companion-self-answer/prompts/rich.md` v1.3.1
- **Date:** 2026-11-11
- **Sources re-read:** None. Neither answer rests on a source outside this repository and the
  managing core. The core rule both items turn on, `testing_doctrine.md` v2.9.0 § *A test reads
  nothing of the machine it runs on*, was read at the managing core itself, through its table of
  which place checks which rule. It is at the version `self_answer-88.md` read.

Read for this run: the companion, whole; `docs/trail/architecture/self_answer-88.md`, whole, which
answered cycle-85 § 2.1 and left § 3.1; NFDR v94's header and version line, QC-65's tail, QC-67
whole, RN-103 and RN-104 whole. Measured at `main` (`148a2d7`), whose tree outside `docs/` is
`528c152`'s (`git diff --stat 528c152 HEAD -- . ':!docs'` prints nothing), every file read with
`git show HEAD:<path>`: across all twenty-seven `checks/tests/test_*.sh`, a count of `env -i` lines
and of `PATH=` assignments carrying `$PATH`; for the eight suites with neither, the line that
launches the script (`test_release_shape.sh:L97`, `test_release_sums.sh:L64`,
`test_release_version.sh:L96`, `test_secret_scan_planted.sh:L258`, `:L426`, `test_strings.sh:L148`,
`:L158`, `test_structure.sh:L194-L195`, `test_strings_step.sh:L237`, `:L349-L386`);
`checks/tests/support/vm_refusal.sh:L42-L45`, `:L185-L195`; and, across every `checks/*.sh`, a scan
for a tool called by absolute path outside a comment. It found two lines, both in
`checks/offline-page.sh` (`:L102`, `:L181`), and both are the text of a refusal message, not a call.

## Items worked

### 2.1 — QC-67 states the two ways a suite builds a check script's `PATH` and requires neither: whether every suite must build it from an empty environment is open

- **Bucket:** 2. Choices to confirm — the Principal Architect drafted a best-effort answer; confirm or override
- **Verdict:** overridden
- **Why:** The draft was "state both forms and require neither". It is replaced by the built form
  as the rule, the alternative the item drafts under *If overridden*, with two corrections that
  alternative needs. The draft's reasons for holding back do not hold, and its reading of the
  suites is incomplete.

  **Whose call (check 1).** This document's. The change lands in QC-67's own sentence and its
  `verified by:` tail. It binds no person or outside party. The draft calls this "a call two
  architects could make either way", so "not this seat's to settle on its own". That is a general
  chance of being overruled, and it names no ground this run cannot see. Its one concrete reason
  is that it "leans on § 3.1", which is the owner's. So I tested whether the two can be separated.
  They can: the built form is the right rule on both answers § 3.1 could get.
  - If the owner rules the doctrine binds as written, the draft's own rationale applies: "only an
    empty environment proves nothing else was reached".
  - If the owner authorizes a bounded departure, the built form is part 4 of the bound
    `self_answer-88.md` drafted: "no host tool reaches the script that the suite did not name".

  Either way the built form is what makes the host tools a suite uses a list someone can read. It
  decides nothing about whether those tools may be the host's. So answering it does not presuppose
  § 3.1, and it does not turn one open item into two.

  **Is the draft sound (check 2).** The draft's main cost argument does not hold. It says the rule
  "would make fourteen suites known gaps in one move", and treats that as a reason not to have the
  rule. This document already carries known gaps under a rule, held by `development-design` until
  a change lands. QC-67 itself carries three, with "part (3) is held by nothing". A known gap blocks
  no change. What the rule changes is that the next suite is written in the built form, and that
  each old one is visibly owed a move.

  Without the rule, the doctrine is already unmet, silently. `testing_doctrine.md` says "the test
  fakes every process the code starts, the host's tools included". A suite that prepends its
  stand-ins to the host's `PATH` runs a tool it forgot to fake on the host's copy, and the case
  passes. The doctrine names exactly that: a test that "passes on a machine where that thing is as
  the test expects, and proves nothing anywhere else". Requiring neither form leaves the record
  saying nothing about a breach it has measured. The built form tightens toward a core rule, which
  any seat may do. Relaxing one is what no seat may do, and that is § 3.1, not this item. The
  trace is a doctrine default, which the NFDR's header allows.

  **The draft answers a smaller question than the item asks.** The heading asks whether every
  suite must build its `PATH`. The reading under it sees two forms, and there are three. Measured
  at `528c152`:
  - **Built from `env -i`:** six suites, not five. `test_vm_refusal.sh` builds its `PATH` through
    its helper `vmr_run` (`checks/tests/support/vm_refusal.sh:L190-L191`), so a count of `env -i`
    lines in the suite files alone misses it.
  - **Prepended to the host's `PATH`:** the fourteen QC-67 names.
  - **The host's `PATH` taken whole, with no stand-in on it:** six suites QC-67 does not name —
    `test_release_shape.sh`, `test_release_sums.sh`, `test_release_version.sh`,
    `test_secret_scan_planted.sh`, `test_strings.sh` and `test_structure.sh`. Each runs the real
    script directly (`"$SCRIPT" "$@"` and the like).
  - **Not measured to the end:** `test_strings_step.sh`, which runs copies of `checks/gate.sh`. I
    did not read how those copies are launched, so the fold measures it.

  So the rule's known gaps are twenty suites, not fourteen. A third form is worse than the
  prepended one: every tool its script starts is the host's. `test_notices.sh:L490`'s
  `env -i PATH="$STUBS:/usr/bin:/bin"` is a gap too, as RN-104 already counts it. A forgotten tool
  in `/usr/bin` is the host's there as well. The slot says this. "QC-67 states two forms" is a
  supporting-text error in the item and in RN-104, reported here and not corrected in the item.
  The rule replaces that reading, so the fold re-measures it in one move.

  **Checked against the settled record (check 3).** QC-67's no-seam reading, confirmed at v94,
  stands. The built form is still `PATH`, the platform's variable, so it stays neither a bound nor
  a seam. QC-65's reading, that a stand-in `uname` and `sysctl` on `PATH` is "not an option, flag
  or variable of the script's own", is unchanged, because `vmr_run` is already the built form.
  Part (3) is untouched: the rule binds the suites, and no gate step sets a suite's `PATH`. This
  answer agrees with my answer under § 3.1 below. Both read the same `env -i` lines and the same
  doctrine. The left answer's part 4 rests on this rule, and this rule does not rest on that answer.

  **Failure paths (check 4).**
  - *Absent:* the case the rule exists for. A tool a suite forgot is missing, and the script stops
    loudly. Either it refuses, as `checks/git-beta-scene.sh:L212` does, or the shell's own "command
    not found" fails the case. The rule adds one case it does not cover: a script that probes for
    an optional tool with `command -v` and takes a fallback branch when it is missing. Under the
    built form that script takes the fallback silently. It does not pass on the host's tool, but
    the case runs a branch its author may not mean. Uncovered, and named.
  - *Empty:* a suite with no stand-ins at all, such as the release suites, still builds a `PATH`,
    of links to the tools its script is written in. The rule does not require a stand-in. It
    requires that nothing arrives unnamed.
  - *Refused:* when the guest lacks a tool the suite links, the suite fails at setup. That is the
    doctrine's "missing on the next machine" made loud, which is the intended outcome.
  - *Stale:* the three-form counts are a dated reading at `528c152`. The scan named in the slot
    replaces the reading as the thing that holds the rule, and until it lands `development-design`
    holds new suites to it. A tool called by absolute path reaches the host under any `PATH`. No
    check script does that at `528c152`, but a later one could, so the slot names it as uncovered.
  - *Concurrent:* does not arise for a rule about how a suite builds a script's environment.

  **Where I was close to a different verdict.** I was close to *left for the owner*, on the
  draft's lean on § 3.1. What tipped it is that the built form gives the same answer on both of
  § 3.1's branches, which the draft did not test. If the owner rules on § 3.1 in a way neither
  branch covers, for instance that shell check suites are outside the doctrine entirely, this rule
  would still be the cheap one to keep. It costs a suite a list of links, and it is what makes any
  later exception readable.

## Left for the owner

### 3.1 — The harness suites run the host's own `git` and `tar`, and QC-67 admits no seam for them

- **Bucket:** 3. Raised from downstream — an item from a seat that did not write these records
- **Verdict:** left for the owner
- **Why:** This is the third run to reach this verdict, and nothing it rests on has moved.
  `testing_doctrine.md` is still v2.9.0, and it still says "the test fakes every process the code
  starts, the host's tools included", on "every layer, in every language, in every instance and
  every product". That is core doctrine, not a language packet. `languages/README.md` § Precedence
  lets the NFDR set a packet's line aside, but it does not reach doctrine. The cross-role contract
  says "Doctrine is user-owned; role-level override of doctrine is not permitted". So a sentence in
  the NFDR allowing the host's tools would be a seat relaxing your rule. The suites are unmoved,
  the tree outside `docs/` still being `528c152`'s, and no answer of yours has reached the item.
  The ground I cannot see, named: whether you meant the host-tools rule to reach a shell product's
  own check suites. The item was raised from downstream and cites where it occurs
  (`test_git_beta_scene.sh`, `test_git_beta_walk.sh`), so "not until it occurs" does not apply.

  **A premise measured this run, which is not a second question.** The departure is wider than
  `self_answer-88.md` measured. Besides the suites that link host tools into a built `PATH`, six
  suites run their script on the host's `PATH` whole (§ 2.1 above names them), and fourteen
  prepend stand-ins to it. So at `528c152` every suite whose launch I measured, twenty-six of the
  twenty-seven, reaches host tools one way or another. A ruling that the doctrine binds as written means rewriting the whole
  harness, or deciding that shell check suites are outside the rule. It does not mean fixing two
  Git cases.

  **How § 2.1 bears on this.** § 2.1 above makes the built form QC-67's rule. It does not decide
  this item, and it holds on either answer you give. What it changes for you is that, once it
  lands, the host tools each suite uses become a named list. That is the list part 1 of my answer
  below would bound.
- **The answer I would have given:** the same answer `self_answer-88.md` gave. Keep the real
  tools, bounded, and record it as a departure you authorize, either as an exception in
  `testing_doctrine.md` or in NFDR § 9 under your answer. The bound has four parts:
  1. **The script's own language.** A suite may link the host's shell and its ordinary text and
     file tools into the `PATH` it builds for the script. These are the tools the script is
     written in (`support/vm_refusal.sh:L64` lists 37 of them, and `test_git_beta_walk.sh:L53`
     lists 26).
  2. **Tools whose output is the subject.** A suite may run the host's `git` or `tar` only where
     the case asserts what that tool makes of a state the suite built, and only on temporary
     copies the suite made. A stand-in `git` in the scene's state cases would prove the stand-in,
     not what `git status` says of each staged state.
  3. **Machine configuration is shut out.** Every such run shuts out machine-level `git`
     configuration (`GIT_CONFIG_GLOBAL=/dev/null`, `GIT_CONFIG_NOSYSTEM=1`, and
     `GIT_CONFIG_COUNT=0` where a commit is made), as both Git suites already do.
  4. **Everything else is faked, and nothing leaks in.** Every tool that reaches outside the
     temporary folder, or whose answer is what the script refuses on, stays a stand-in: `open`,
     `tart`, `uname`, `sysctl`, `ps`, `kill`, `screencapture`. The `PATH` is built from an empty
     environment, which § 2.1 now makes QC-67's rule, so no host tool reaches the script that the
     suite did not name.

  The doctrine's own ground, that a host tool "can be missing on the next machine, or behave
  differently there", is real but small here. Every suite runs in the one macOS guest, and `git`
  is a precondition of the gate anyway, because *Secret scan* runs it.

## Skipped

None this run. Both open items had owner slots, and the invocation listed no items, so both were
this run's.

## Companions opened

None this run. No upstream document is owed a change. § 2.1's answer lands in QC-67, this
document's own entry. § 3.1 is your call on core doctrine, and `testing_doctrine.md` has no
companion template, so the call reaches you through this report.

## Launchers owed

- **docs/adr/ and docs/nfdr.md** — `<CORE>/launchers/skill/launcher.sh product-architecture ka-reader`
