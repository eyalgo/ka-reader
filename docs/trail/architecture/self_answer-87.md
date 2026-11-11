# Self-answer report — `adr/` and `nfdr.md` (KA-Reader architecture records)

## Header

- **Companion:** `docs/architecture_open_issues.md`
- **Document:** `docs/adr/` and `docs/nfdr.md`. All five items bear on the NFDR (v92, Settled), and no ADR moves.
- **Decided by:** `<CORE>/../skills/companion/.claude/skills/companion-self-answer/prompts/rich.md` v1.3.1
- **Date:** 2026-11-11
- **Sources re-read:** None. No answer rests on a source outside this repository and the managing
  core. The one platform behaviour that would have been leaned on is what `tart exec` returns when
  its guest is lost. 3.3 names that as an uncovered case and does not assume it.

Read for this run: the companion, whole. NFDR v92's header and version lines, § 8 (QC-55–QC-60,
QC-64, QC-65, QC-67, QC-70), § 9 through the suites bullet's dated readings, and § 10's QC-64–QC-71
rows and review-gate list. The NFDR is 9,215 lines; the five items touch only these sections, and
`grep -n` over the whole file found no other passage naming `git-beta`, `tree-walk`, `pytest` or a
harness suite's tools. Also SDD v87's version line (the `read-only-harness` row re-pinned at
`528c152`, 27 suites, "the scripts no gate step runs are eight"). From the managing core: the Shell
packet's `testing.md` v1.3.0 and `environment.md` § *In the macOS guest*, `testing_doctrine.md`
v2.9.0 § *A test reads nothing of the machine it runs on*, and `languages/README.md` § Precedence.
Measured at `ka-reader@528c152`, the tree the items cite (`git ls-tree`, `git show`, and a
`git archive` copy for the literal status scan, removed afterwards): `checks/gate.sh` 1.17.0,
`checks/git-beta-scene.sh` 1.3.2, `checks/git-beta-walk.sh` 1.0.0, `checks/tree-walk.sh` 1.2.0,
`checks/readme.sh`, and the suites `test_git_beta_scene.sh`, `test_git_beta_walk.sh` and
`test_vm_refusal.sh`. `main` is at `4b84afc`, and `git log 528c152..main -- checks` is empty.

## Items worked

### 3.1 — QC-65 does not name the Git beta scene helper and its host walk

- **Bucket:** 3. Raised from downstream — an item from a seat that did not write these records
- **Verdict:** answered
- **Why:** QC-65 lists the scripts that start the bundle with `open`, and that list is now short by
  one. This is a correction, not a widening: the item cites the occurrence, a script on `main` that
  does what the list describes. The item has no draft, so I answered it.

  **Whose call (check 1).** It is this document's. Only QC-65's own sentence moves, and it binds no
  person or outside party.

  **Is the question sound (check 2).** Its facts hold at `528c152`. `checks/git-beta-scene.sh`
  starts the bundle with `open -n` (`:L643`) and refuses off a virtual machine with a QC-65 line
  before it sets up or launches anything (`:L106`). No gate step runs it. Its suite is the gate's
  *Git beta scene helper suite* (`checks/gate.sh:L178`), whose header says `open` "only records".
  The refusal is held twice: in the helper's own suite (`test_git_beta_scene.sh:L312`), and in the
  refusal suite (`test_vm_refusal.sh:L217`), as the tree-scene helper's refusal is. So the helper
  joins the set exactly as `checks/tree-scene.sh` did at v77, and its suite stays outside it.

  **The heading asks a second question, and it has the same seat.** The heading names "its host
  walk" too, so I answered that as well, in the same slot. `checks/git-beta-walk.sh` is **not** in
  the set, and QC-65 should say so. The walk runs on the physical Mac by design. It starts the guest
  (`tart run`), builds in it, and launches the bundle only inside it, through `tart exec`, where the
  helper's own refusal still applies. It reads no app container. Its one write on the host is its
  results folder, `~/Desktop/git-beta-walk/`. `checks/tree-walk.sh` stands the same way, writing
  `~/Desktop/tree-walk-end.png`, and QC-65 has never named it. Naming both as outside the set, with
  the reason, keeps a cold reader from taking either for a missed member. Without it, a reader of
  QC-65's "never on a physical Mac" would find two scripts in `checks/` that run there and could
  not tell whether that was allowed.

  **Checked against the settled record (check 3).** SDD v87 calls both new scripts "person's tools,
  run by no step". QC-66 owns the person's walk, and this answer does not touch it. Writing to the
  Desktop is not QC-65's "read the running machine's home": that phrase is the app's container
  under `$HOME`, which `checks/own-state.sh` reads.

  **Failure paths (check 4).** *Refused*: off a VM, the helper ends 1 having launched nothing. That
  is the suite case. *Concurrent*: the walk refuses a guest running without a window, because a gate
  may be using it (`checks/git-beta-walk.sh:L81-L82`), so it never takes over a gate's guest.
  *Stale*: the set's locators are dated readings at `528c152`, and a later move is a
  re-measurement, as QC-65 already says of its own pins.

  **Where I was close to a different verdict.** I was close to leaving the walk out of the answer,
  since the item's body is about the helper alone. What tipped it is that the heading names the walk
  and the item's own text gives no ground for dropping it. The prompt answers a two-part question on
  both parts.

### 3.2 — § 9's suites bullet counts twenty-five suites; the tree holds twenty-seven

- **Bucket:** 3. Raised from downstream — an item from a seat that did not write these records
- **Verdict:** answered
- **Why:** The count is a measured fact that is now false, so this is a correction. My own loop at
  `528c152` found 27 `checks/tests/test_*.sh` files, each the whole command of one `run_step` line,
  with no file missing a step. That matches SDD v87's 27. The bullet's own rule says a new suite "is
  a re-measurement of this sentence and not a contradiction of it". So the answer re-measures it,
  keeps the twenty-five at `7a88215` as a dated reading, and re-pins every locator: the 1.16.0 and
  1.17.0 version lines moved every step two lines down from the 1.15.0 reading.

  **What the answer adds (check 2: the item answers a smaller question than the bullet needs).** Two
  other sentences in the same bullet are false today, because earlier re-measurements did not carry
  them along:
  - "Three of the twenty-three have no `checks/<name>.sh` of their own name". The v92 fold counted
    25 and left this at twenty-three. Measured at `528c152`, it is three of the twenty-seven, the
    same three: `test_secret_scan_planted.sh`, `test_strings_step.sh` and `test_vm_refusal.sh`. The
    four suites added since v89 each pair by name, hyphens for underscores: `readme.sh`,
    `git-beta.sh`, `git-beta-scene.sh` and `git-beta-walk.sh`.
  - "the workflow's `Test gate` step … runs `checks/gate.sh`, and through it all seventeen". That
    has read seventeen since v85. It reads all twenty-seven.

  These belong in this answer rather than in a raised item, because they are the same bullet, the
  same seat and the same measurement.

  **Checked against the settled record (check 3).** SDD v87 says 27. § 10 points at this bullet for
  the count and repeats none of it, so nothing else moves. This answer agrees with 3.1 and 3.3: both
  new suites are fatal gate steps, and both scripts are run by no step.

  **Failure paths (check 4).** *Stale*: the next suite makes this a dated reading again, by the
  bullet's own rule. The two sentences fixed here are counts too, and the fold should re-measure them
  together with the main count each time, or they drift again. The answer says so in effect by
  re-measuring them now, and the bullet's "a further suite … is a re-measurement of this sentence"
  covers them only if the fold reads them as part of the sentence. I note it for the fold.

### 3.3 — QC-70's dated readings of each check script's ends do not cover the two new scripts

- **Bucket:** 3. Raised from downstream — an item from a seat that did not write these records
- **Verdict:** answered
- **Why:** QC-70's review gate covers "a new script's statuses", and these are two new scripts, so
  the entry records them as it recorded `git-beta.sh`'s at v92. Both scripts fit the five statuses.
  The scene ends 0, 1, 2, 130 and 143. Its header is at `:L47-L51`, its traps at `:L285-L286`, and
  each status has a case in its suite at `:L312`, `:L325`, `:L350`, `:L376`, `:L391`, `:L476` and
  `:L993`. The walk ends 1 on its own refusals and otherwise passes the scene's status through
  (`:L201`). That is the pass-through QC-70 admits ("a script whose job is to run one other check
  script exits with that script's status"), with `checks/tree-walk.sh` as the precedent. Its suite
  holds both (`:L265`–`:L301`, `:L378`).

  **Two findings beyond the item, both in QC-70's own text.**
  1. **QC-70's definition of 2 is narrower than the scene's 2.** QC-70 reads "2 is a wrong
     invocation, an argument count the script does not take". The scene also ends 2 on a malformed
     argument when the count is right: a built-from line with a line break (`:L153`), an id that is
     not a state id (`:L167`), and an id given twice (`:L170`). Version 1.3.2 adds one more: two ids
     in one argument. The status is inside the five, but the stated meaning does not cover it, so a
     reader checking the scene against QC-70 would find a 2 that QC-70 does not explain. The fix
     widens the meaning, not the set: "an argument count, or an argument, the script does not take".
     It cites its occurrence, so § *A widening item waits until it occurs* takes it.
  2. **The literal scan sentence is false at `528c152`.** QC-70's dated reading says
     `grep -ohE 'exit [0-9]+' checks/*.sh` "finds only 0, 1, 2, 130 and 143". At `528c152` it also
     prints `exit 3`, from awk programs run inside command substitutions in `checks/readme.sh`
     (`:L85`, `:L92`, `:L171`). No script ends 3: the substitution's 3 becomes a message and
     `exit 1` (`:L95-L103`), or `return 1` (`:L172`). So QC-70 still holds, and the scan's limit,
     which QC-70 already names ("no literal scan reads a status a script computes"), now has a
     second face: a literal scan also reads statuses that are not the script's. The reading says so,
     and the `06e4a34` sentence stays as that commit's reading. The v92 README reading at `1ee6ba1`
     said `readme.sh` "adds no status". That is true of what it returns, and the `exit 3` is already
     there at `7a88215`. Nothing upstream depends on it.

  **Checked against the settled record (check 3).** QC-70 was set aside from the shell packet's
  two-status line at v85, and nothing here moves that. SDD v87 records "the status sentences for both
  scripts", and this answer agrees with them.

  **Failure paths (check 4).** *Absent*: when the guest stops answering mid-scene, the walk's
  `scene_status` is what `tart exec` returned, not the scene's. Which value that is, is tart's
  behaviour, which this run did not read at its source. The stand-in `tart` in the suite returns the
  scene's status only. So the answer names it as an uncovered case rather than as a sixth status.
  *Refused*: the walk's refusals all end 1 before anything starts, and the suite holds each one.

### 3.4 — No record sets aside the Shell packet's pytest line, though every check suite is bash

- **Bucket:** 3. Raised from downstream — an item from a seat that did not write these records
- **Verdict:** answered
- **Why:** The suites stay bash, and § 9 says so and why. It sets aside the packet's "The tool is
  pytest, and the tests are written in Python" for `checks/tests/`.

  **Whose call (check 1).** It is this document's. The line is a language packet's, and
  `languages/README.md` § Precedence puts the product's own records above a packet ("A packet never
  overrides the product's own records"). QC-70 already uses the same ground for the same packet's
  two-status line. No person, money or outside party is bound.

  **Is the question sound (check 2).** The item offers two moves, state bash or move to pytest, and
  gives no lean. Its facts hold. All 27 suites are bash, and the guest's `python3` has no pytest:
  the packet's own `environment.md` measured `ModuleNotFoundError` in `kensai-macos` on 2026-10-23.
  The decision rests on three grounds. (1) The product has no Python. The one `.py` file at
  `528c152` is `checks/fixtures/highlight/sample.py`, a highlighter fixture, so pytest would bring
  in a language for its tests alone. (2) Running pytest in the guest needs a `pip install` at every
  gate run. That is an unpinned network fetch, added to the two network steps § 8 names, each of
  which § 8 pins by SHA-256. It would be a supply-chain surface the product does not have today.
  (3) Moving 27 working suites gains no rule. The packet's line describes the managing core's own
  shell files, measured over that tree, and the reason it gives for pytest (no shell framework is
  installed) applies equally to bash suites that are their own runner.

  **Where it lands.** § 9's harness bullet is the "stated once, here" home of how the suites run.
  QC-70 is about statuses, so the statement goes in § 9 and not in QC-70.

  **Checked against the settled record (check 3).** Three suite headers already say the pytest
  runner is not used "because the product has no Python (docs/nfdr.md § 9 names its toolchains)".
  This answer makes § 9 say what they cite it for. Two other headers cite QC-70 for the same thing,
  which QC-70 does not say; that is reported under `## Companions opened`. Nothing in the SDD
  addresses the harness's test language.

  **Failure paths (check 4).** *Stale*: a suite added later in another form, a `test_*.py` say,
  would be invisible to the gate's membership checks, which read `checks/tests/*.sh` alone, so it
  would join no step. Hence the answer's verifier: `find checks/tests -maxdepth 1 -type f ! -name
  '*.sh'` prints nothing. `checks/tests/support/` is a directory and falls outside that test. Until
  the verifier is in a suite, `development-design` reading the entry is its gate. *Empty* and
  *concurrent* do not arise.

### 2.1 — QC-67 admits no seam for handing a check script its `git` or `tar`: a suite hands a script its tools through `PATH`, which QC-67 already names as the platform's

- **Bucket:** 2. Choices to confirm — the Principal Architect drafted a best-effort answer; confirm or override
- **Verdict:** answered
- **Why:** This is the answered half of § 3.5, which asks two questions with two seats. The
  remainder, whether the suites may run the host's real `git` and `tar` at all, is under
  `## Left for the owner` below, as 3.5.

  **The question.** § 3.5 offers QC-67 two moves: admit a seam for a suite to hand a script its own
  `git`, or state that suites may run the host's tools. These are two questions. The first is about
  QC-67's mechanism, and the second is about the testing doctrine.

  **The answer to this half: no seam.** QC-67 defines a variable "of the script's own" as "one the
  script names, not the platform's `PATH`, `HOME` or `TMPDIR`". Both suites hand the script its
  `git`, and `tar` where a case needs it, by linking the tool into a stand-in directory first on
  `PATH` (`test_git_beta_scene.sh:L134-L136`; `test_git_beta_walk.sh:L216`, `:L364`). Neither script
  reads a variable of its own beyond the platform's `HOME` (`git-beta-scene.sh:L216`). So the suites
  are already inside QC-67 as written. A tool seam, such as a `GIT_BETA_SCENE_SH_GIT` variable,
  would be worse. It would be a variable of the script's own that can swap a tool under a gate run,
  which is the case QC-67's part (3) exists to keep out of a gate, and it would give nothing `PATH`
  does not already give. QC-67 owes one sentence saying so, so the next reader does not raise this
  again.

  **Why the split meets the prompt's three conditions.** (1) The halves are separable. Whatever the
  owner rules on the doctrine half, the hand-off is the same `PATH` link, to the real tool or to a
  stand-in, so this half does not presuppose that answer. (2) The seats differ. This half binds only
  QC-67's own consistency, so it is mine. The other half relaxes a core doctrine rule written for
  "every product", which is the owner's (below). (3) This half is reached: checks 3 and 4 ran on it.
  *Check 3*: QC-67's part (3), "every step of `checks/gate.sh` runs its script at the script's
  defaults", is untouched, because no gate step sets the suites' `PATH`. QC-65's "no option, flag or
  variable of its own that skips the refusal" is untouched too: the refusal suite already admits
  scripts through a stand-in `uname` and `sysctl` on `PATH`, and QC-65 calls that "not an option,
  flag or variable of the script's own". *Check 4*, *stale*: QC-67's inventory of variables is
  pinned at `2529a42`. The two new scripts add no variable of their own, so the inventory stays true,
  and the fold may re-pin it at `528c152` with nothing to add.

  **Where it sits.** It is moved out as companion § 2.1, with its confirm-or-override slot at its
  placeholder. § 3.5's slot is left exactly as it stood.

## Left for the owner

### 3.5 — The harness suites run the host's own `git` and `tar`, and QC-67 admits no seam for them

- **Bucket:** 3. Raised from downstream — an item from a seat that did not write these records
- **Verdict:** left for the owner
- **Why:** This is the remainder of § 3.5 after its QC-67 half moved to § 2.1, which answers that no
  seam is needed. What is left is whether the harness suites may run the host's real `git` and `tar`
  at all. `testing_doctrine.md` v2.9.0 § *A test reads nothing of the machine it runs on* says "the
  test fakes every process the code starts, the host's tools included", and says it holds "in every
  layer, in every language, in every instance and every product". That is core doctrine, not a
  language packet. The NFDR may set aside a packet's line under `languages/README.md` § Precedence,
  as it does for the shell packet's two-status line, and as 3.4 does for its pytest line. But
  Precedence ranks only product records, packets and `developer_standards.md`, and the testing
  doctrine is not in that chain. The cross-role contract states that "Doctrine is user-owned;
  role-level override of doctrine is not permitted". So a sentence in QC-67 or § 9 saying "harness
  suites may run the host's `git` and `tar`" would be this seat relaxing your rule. The ground I
  cannot see, named: whether you meant the 2026-10-29 host-tools rule to reach a product's check
  suites whose subject *is* what the tool reports. The doctrine's examples (a pin's Python, `root`
  and `chmod`, the terminal) do not say.
- **The answer I would have given:** keep the real `git` and `tar`, bounded, and record it as a
  departure you authorize, either in `testing_doctrine.md` as an exception or in § 9 under your
  answer. The state cases exist to prove what `git status` says of each staged state. That sentence
  is exactly what the scene puts in front of a person to compare with the app's window
  (`test_git_beta_scene.sh:L161-L162` reads it back), so a stand-in `git` would make the cases prove
  the stand-in. The same holds for the walk's one real-`tar` case
  (`test_the_checkout_reaches_the_guest_without_git_target_or_build`, `:L361`), which proves what the
  real stream leaves out. The doctrine's ground, that a tool "can be missing on the next machine, or
  behave differently there", is real but small here. `git` is a precondition of the gate anyway,
  because *Secret scan* runs it, and every suite runs in the one guest. The bound I would write:
  (1) a harness suite may run the host's `git` or `tar` only where the case asserts what that tool
  makes of a state the suite built, and only on temporary copies it made; (2) machine-level `git`
  configuration is shut out on every such run (`GIT_CONFIG_GLOBAL=/dev/null`,
  `GIT_CONFIG_NOSYSTEM=1`), as both suites already do (`test_git_beta_scene.sh:L161`,
  `test_git_beta_walk.sh:L235`); (3) every other process the script starts stays a stand-in. Not
  widened, but you should know: two older suites run the real `cargo` the same way
  (`test_entry_points.sh` and `test_no_network.sh` say "a stub … runs the real tool"), so a ruling
  here reaches them too. If you rule instead that the doctrine binds as written, the two suites'
  state cases are rewritten against a stand-in `git`, and § 2.1's `PATH` hand-off carries that
  stand-in unchanged.

## Skipped

None this run. All five open items had owner slots at their placeholder, and the invocation listed
no items, so all five were this run's.

## Companions opened

None this run. No upstream document is owed a change. SDD v87 already re-pins the harness row at
`528c152` with both scripts, both suites and their statuses, and the remainder of 3.5 is the owner's
call on core doctrine, which has no companion template.

Found while walking, product code, and not written by this run, which writes no product file: the
headers of `checks/tests/test_git_beta_scene.sh` (`:L28`) and `checks/tests/test_git_beta_walk.sh`
(`:L21`) say "docs/nfdr.md QC-70 sets the shell packet's pytest line aside". QC-70 does not. Once
3.4 lands, § 9 does, and those two headers owe a repoint to § 9, as `test_no_network.sh`,
`test_entry_points.sh` and `test_notices.sh` already cite § 9. Both headers also cite a
`deferred_decisions.md` that is not in the product tree. That repoint is the delivery tier's on its
next change under `checks/tests/`.

The companion's § 2 read "None." before this run. The appended item replaced that line, which was
the empty section's placeholder and not an item.

## Launchers owed

- **docs/adr/ and docs/nfdr.md** — `<CORE>/launchers/skill/launcher.sh product-architecture ka-reader`
