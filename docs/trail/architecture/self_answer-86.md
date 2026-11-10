# Self-answer report — `adr/` and `nfdr.md` (KA-Reader architecture records)

## Header

- **Companion:** `docs/architecture_open_issues.md`
- **Document:** `docs/adr/` and `docs/nfdr.md`. Both items bear on the NFDR (v91, Settled), and no ADR moves.
- **Decided by:** `<CORE>/../skills/companion/.claude/skills/companion-self-answer/prompts/rich.md` v1.3.1
- **Date:** 2026-11-11
- **Sources re-read:** (1) The Swift packet's `testing.md`, read at the source, v1.2.0. It says
  "`@testable import` is for layer 1 only … Layers 2 and 3 use a plain `import`", and the line is
  in every version of the file in its history, v1.1.0 included, which is the version the NFDR
  records. (2) Swift Evolution SE-0386, *`package` access modifier*, status "Implemented
  (Swift 5.9)". It says `package` "allows symbols to be accessed from outside of their defining
  module, but only from other modules in the same package", and "if a client outside of the
  package tries to access the helper API, it will not be allowed". No other source outside this
  repository is leaned on.

Read whole for this run: the companion; NFDR v91's header, QC-44, QC-70's README paragraph, § 9's
suites bullet and its `ka-reader-mac` bullet, and § 10's QC-44 row and review-gate list (the NFDR is
9,084 lines; `grep -n 'git-beta'` and `grep -in testable` over it both print nothing); SRS v17 C-9;
SDD v86's header, § 3 `read-only-harness` row and RN-172. Measured on a fresh clone at
`ka-reader@7a88215`, whose tree outside `docs/` is the current head's (`git diff --stat 7a88215
c52e3ca -- . ':!docs'` prints nothing): `checks/gate.sh` 1.15.0, `checks/git-beta.sh` 1.0.0,
`checks/readme.sh` 1.1.0, `checks/support/git-beta-inputs.sh` 1.0.0, and `ka-reader-mac`'s
manifest and tests.

## Items worked

### 3.1 — QC-44 still says no script checks the beta wording or the catalogue, and § 9 and § 10 do not name the one that now does

- **Bucket:** 3. Raised from downstream — an item from a seat that did not write these records
- **Verdict:** confirmed with addition
- **Why:** QC-44 states something that is now false. Its tail says that at `ka-reader@b46d896` no
  script runs the catalogue `grep`. Its *Local README realization* paragraph leaves "the beta
  wording and its catalogue/surface checks" outside every script. And § 10's row names only
  `checks/readme.sh` (`docs/nfdr.md:L1693-L1714`, `:L3420`). Since `ka-reader@7a88215`, two
  scripts hold that half. The item is a correction, not a widening, so § *A widening item waits
  until it occurs* does not apply. I took the item's *If a document has to be written* line as its
  draft and confirmed it, after checking every claim myself on the clone:
  `checks/git-beta.sh` exits 0, `checks/readme.sh` exits 0, `checks/tests/test_git_beta.sh` passes
  10 of 10, and `checks/tests/test_readme.sh` passes 39 of 39.

  **What the answer adds.**
  - **The README check's locator in the item is stale.** At `7a88215` (`checks/gate.sh` 1.15.0),
    *README check* and *README check suite* are `:L150-L151`. The item's `:L143-L144` is the
    `1ee6ba1` reading. The beta pair is `:L152-L153`, as the item says. The fold re-pins at `7a88215`
    and keeps the `1ee6ba1` reading as a dated one.
  - **What each script holds, named, because the item names less than the scripts do.**
    `checks/git-beta.sh` reads `GitReadPolicy.build`. On `atOpen` it runs QC-44's own catalogue
    `grep -rF` over `ka-reader-mac/Sources/Surfaces`. In both modes it requires the notice in
    `GitSentences.swift` to agree with CONTENT's beta row. `checks/readme.sh` 1.1.0 holds QC-44's
    README half in **both** modes. On `atOpen` the known gaps must hold exactly one delimited beta
    block carrying the whole wording. On `followed` there must be no block, and the notice's wording
    must appear nowhere in the displayed prose (`checks/readme.sh:L641-L675`). That is QC-44's "on
    a release that follows Git state it must find nothing", so the README's `grep` is held at every
    change and not only at the release. Both scripts read the shared
    `checks/support/git-beta-inputs.sh`, which SDD v86 names as the harness's second helper.
  - **§ 9's suite inventory.** Twenty-five top-level suites are in the tree at `7a88215`. The one
    added since `1ee6ba1` is `test_git_beta.sh` (`:L153`). Every one of the 25 is the whole command
    of a gate step: a loop over `checks/tests/test_*.sh`, looking for each path quoted in
    `checks/gate.sh`, missed none. The twenty-four at `1ee6ba1` stays as a dated reading.
  - **QC-70.** `git-beta.sh` is a new script, and QC-70's review gate covers "a new script's
    statuses". Its header states 0 on a complete pass, 1 on a finding, a failed inspection or a
    caught HUP/INT/TERM, and 2 on usage. All of these are in QC-70's set. They are held by
    `test_catalogue_statuses_signals_and_inputs_are_preserved`. The fold records them as it
    recorded the README script's.
  - **What stays outside any script,** with release inspection or `development-design` reading the
    entry as now: the release-note wordings (`readme.sh` reads no release notes), the README's
    uncovered-case line, the rendered four items, when and where each surface draws the statement
    (FDR R-192 – R-195, SRS AC-26), and every downloaded-release proof.

  **Checked against the settled record (check 3).** SDD v86's § 3 `read-only-harness` row is
  already re-measured at `7a88215` with both beta checks, their suites and the second helper
  (RN-172). SRS v17 C-9 still names four first-screen items, and QC-44 points at C-9 rather than
  copying it, so PRD v20's change of the first step leaves QC-44 true. No upstream document is
  owed a change.

  **Failure paths (check 4).** *Stale*: if the build's policy flips to `followed`, `readme.sh`
  refuses a README that still carries the block or the statement. `git-beta.sh` then skips the
  catalogue `grep`, and QC-44 requires the catalogue wording only on an `atOpen` build, so nothing
  is left unheld. *Absent* or *refused*: an unreadable policy, CONTENT row or catalogue ends 1 with
  a named input, never a silent pass. The suites' policy, canonical-row and failed-read cases hold
  that.

  **Decided together with 2.1.** The passages this answer revises were written by a delivery-tier
  commit, not by an NFDR revision. The slot points at 2.1 so the fold takes both together.

  **The verdict was close to "confirmed".** What tipped it to "with addition" was the README
  locator, which the item gives wrong, and the README check's `followed` half, which the item does
  not name.

### 3.2 — § 9 leaves the Swift packet's "`@testable import` is for layer 1 only" in force, and 34 of the 54 Swift test files depart from it

- **Bucket:** 3. Raised from downstream — an item from a seat that did not write these records
- **Verdict:** answered
- **Why:** The item gives no draft. Its *If a document has to be written* line offers both options
  and picks neither, so I answered from scratch. **The rule binds, and § 9 names no departure.**

  **Whose call (check 1).** It is this document's. § 9's `ka-reader-mac` bullet is where the product
  records each packet rule as followed, adopted or departed from, and it already says "a rule of it
  not named here is followed as written". The answer commits no person, money or outside party. Its
  one consequence, widening a declaration to `package`, stays inside the package (below). So the
  call is mine in the owner's seat. It is not the CTO's, because no part, edge or interface in the
  SDD moves.

  **Is the framing sound (check 2).** Its facts hold. On the clone, 54 Swift test files, and
  `grep -rl '@testable import'` lists 34 (27 of 37 in `SurfacesTests` and 7 of 17 in
  `ShellTests`). But the item overstates how far the tree departs. I made every `@testable` a plain
  import on a scratch copy of `7a88215` and built the tests. To do that I took the bridge's binary
  target and the app target out of the manifest: `Surfaces`, `Shell` and both test targets use
  neither. Then I put `@testable` back only on the files that failed, round by round. The build ran
  on Swift 6.4.2, not the recorded 6.3.2. Access control does not differ between the two.
  - 16 of the 34 files build with a plain import and nothing else changed. `WorkbenchViewTests`,
    which the item cites, is one of them.
  - 18 need it. Together they reach these `internal` declarations: `BridgePayload` (4
    `ShellTests` files), `BarRowView`, `CodeView`, `CodeGutterView`, `CodeType`, `CodeSpacing`,
    `LetterTooltipView`, `StatusMessageView`, `RowHover`'s initializer, and the members
    `currentPosition`, `refresh` and `forget`. `GitReadNotice`, which the item names, is reached by
    no test.
  - The three `BridgePayload…Tests` files test decoding a payload. That is a layer-1 subject, so if
    the split places them in `ShellUnitTests`, `@testable` stays there under the rule. The fourth
    file that reaches `BridgePayload`, `LaunchFlowOpenFileTests`, tests a flow, and where it goes is
    the split's call.

  **Why the rule and not a departure.** The packet's ground is `testing_doctrine.md`'s rule that a
  test enters through the same door production does, and a departure would need a reason that
  outweighs it. The one on offer is that following the rule widens declarations to `package`.
  That is real, but it is small and bounded. SE-0386 (re-read) makes a `package` declaration
  visible to the package's own modules only, never to a client outside it. `ka-reader-mac` declares
  no `products:`, so it exposes no library to strangers. The tool's public contract is the app and
  its surfaces, and neither moves. Widening adds no target edge, so § 1's import graph stands. SM-4's
  rule binds the calls the shell *issues*, not what it could see, so it stands too. A layer-4 test
  can also reach most of those view parts through the `package` view that composes them. Inside
  `Surfaces`, `StatusMessageView`, `BarRowView` and `RowHover` are composed by `RootItemsView` and
  `GitView`, and `CodeView` by `ReadingPanelView`. All three of those are `package` already. The answer leaves that choice per case to the delivery tier. It is a placement
  call, like the layer word each target takes, which § 9 already gives the delivery tier.

  **Checked against the settled record (check 3).** The packet's rule has stood since the NFDR
  adopted the packet: it is in `testing.md` v1.1.0, the version the NFDR records, and in every
  version since. § 9's "followed as written" therefore already binds. The answer adds the sentence
  that makes the binding visible, plus the gate that holds it. It matches the *Test targets* clause,
  which already says `SurfacesTests` and `ShellTests` predate the packet "and are owed it". Neither
  the SDD nor the NFDR says anything about access levels: `grep` for `package access`, `access
  level` and `` `internal` `` over both prints nothing. So nothing settled contradicts the answer.
  The answer shares no sentence with my 3.1 answer.

  **Failure paths (check 4).** *Stale*: a test file added or moved after this revision with
  `@testable` above layer 1. Today no script can tell which layer a file is in, because the two
  targets carry no layer word. So until the split lands, `development-design` reviews each moved or
  added test file against the rule, beside the review the *Framework* clause already holds there.
  Once the targets are named `<Target><Layer>Tests`, a `grep -rl '@testable import'
  ka-reader-mac/Tests` that lists a file outside a `…UnitTests` directory is the violation. That
  check is owed to the delivery tier. *Refused*: a declaration that cannot sensibly become `package`
  is reached through its composing view. If neither works, the case is a layer-1 case, and the
  placement decides that. *Empty*: a layer-2–4 target that reaches nothing internal needs nothing.
  *Concurrent* does not arise.

  **Where I was close to a different verdict.** I was close to a narrow departure for layer 4
  alone, on the ground that a view's render detail is easiest to reach from inside its module. What
  tipped it is the measurement: the departure would cover about 15 files and about ten declarations,
  most of which a composing `package` view already reaches. A departure recorded for that would
  outlive the split it was meant to ease.

## Left for the owner

None this run.

## Skipped

None this run. Both open items had owner slots at their placeholder, and the invocation listed no
items, so both were this run's.

## Raised on this document

### 2.1 — Four NFDR passages were written by a delivery-tier commit, outside any NFDR revision, and carry no trace

- **What the document is owed:** the revision that folds § 3.1 also takes in four passages as its
  own: QC-44's *Local README realization*, QC-70's *README command status reading*, § 9's
  *Additional measurement at `ka-reader@1ee6ba1`*, and § 10's QC-44 row. Its version line names
  them, and an RN records that `ka-reader@5c1a640` wrote them inside v91 with no version and no RN.
  No obligation changes.
- **Why it is worth a cycle:** the document contradicts a document it must agree with, and its own
  header contract. `git show 5c1a640 -- docs/nfdr.md` shows a `development-implementation` run
  (2026-11-10, "task 3 review the change's scope") adding those four passages. None of them carries
  a `traces to`, an RN or a version, and v91's version line names only the cycle-82 fold. The SDD
  took the same commit's edit to its § 3 into a revision of its own at v86, through RN-172, which
  names `5c1a640`. So the two records disagree on whether that commit's text is settled. It costs no
  extra cycle: § 3.1's fold rewrites three of the four passages anyway.
- **Not raised, reported here instead.** The commit's own notes say why it edited the NFDR:
  `development-implementation`'s *A correction owed outside this change's reach* paragraph tells a
  developer to correct a tracked file on the branch as a found-while-walking defect. The Principal
  Architect's loader says nothing downstream edits the NFDR, and a discrepancy is "surfaced back …
  never patched in place". These are two shared skill and role files that disagree. Neither is a
  document with a companion template, so this run writes nothing on them. The owner should know of
  it, because the next delivery run will do the same.

## Companions opened

None this run. Every upstream document already agrees with both answers: SDD v86 names the beta
checks, SRS v17 C-9 is pointed at rather than copied, and nothing upstream rules on access levels.

## Launchers owed

- **docs/adr/ and docs/nfdr.md** — `<CORE>/launchers/skill/launcher.sh product-architecture ka-reader`
