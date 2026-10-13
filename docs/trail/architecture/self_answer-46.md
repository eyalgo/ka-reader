# Self-answer report — `docs/adr/` and `docs/nfdr.md`

## Header

- **Companion:** `docs/architecture_open_issues.md`
- **Document:** `docs/adr/` and `docs/nfdr.md` (one companion for both, by its header's pointer)
- **Decided by:** `<CORE>/../skills/companion/.claude/skills/companion-self-answer/prompts/rich.md` v1.3.1
- **Date:** 2026-10-13
- **Sources re-read:** swift.org, *Announcing Swift 6* (https://www.swift.org/blog/announcing-swift-6/,
  re-read 2026-10-13): "Swift Testing is included directly in Swift 6 toolchains". This is the ground
  under § 9's *Framework* clause, which 3.1 relies on to say the flip has happened. Nothing else
  outside this repository was relied on. The `macos-26` image's Xcode list (SDD RN-108, read
  2026-10-13 by that fold) is named in this report but not relied on: both answers read the
  toolchain from a log, never from the image label.

**What this run read.** The companion, whole. In `docs/nfdr.md` (v47, 5,103 lines): the header
(`:L1-L46`), QC-25 and QC-62 (`:L765-L855`), § 8 with QC-55 to QC-60 (`:L1354-L1457`), and § 9 and
§ 10 whole (`:L1458-L1833`). The NFDR was also searched for `QC-25` and `QC-56` across all its
sections. In `docs/SDD.md` (v48): § 4 C-I3's probe and renderer-gate passages (`:L880-L960`), RN-48
whole, and RN-108 whole. In `docs/adr/0010-*.md`: the hosted-runner passages (`:L54-L55`, `:L101`).
In the tree at `ka-reader@c8dc81c`: `.github/workflows/ci.yml` whole; `git diff 8926052 fcb2e2f`;
`ka-reader-mac/Package.swift:L1-L16`; both `Info.plist`s; `assemble.sh`'s deployment target;
`BundleManifestTests.swift:L30-L36`; `checks/bundle.sh:L360-L440`;
`checks/sandbox_probe.rs:L140-L152`; and `checks/tests/test_bundle.sh:L138-L150`, `:L618-L640`
and `:L1565-L1585`. From GitHub: `gh run list` for `ci.yml` (the newest twelve runs, and the
`2026-10-13_ci-runs-on-macos-26` branch, which has none), and the `Toolchain` and `Set up job` lines
of runs 37845881070 and 38449250910.

## Items worked

### 3.1 — § 9's Swift-packet bullet still states, in the present tense, that CI runs on `macos-14` with Xcode 16.x selectable

- **Bucket:** 3. Raised from downstream — an item from a seat that did not write these records
- **Verdict:** confirmed with addition
- **Why:** The lean holds, except for one clause, and the bullet owes more than the item lists.
  The verdict is *confirmed with addition*. Part of what the addition does is override one clause
  of the lean, and this entry names that clause.

  *Check 1, the seat.* The change lands in `docs/nfdr.md` § 9, which is this seat's own document.
  It commits nothing to any person and has no ground this run cannot see. So the item is the
  Principal Architect's, answered here in the owner's seat. It is a correction of a false
  statement, not a widening, so § *A widening item waits until it occurs* does not apply.

  *Check 2, the lean.* The PM's two citations are right. `ci.yml:L18` reads `runs-on: macos-26`,
  and `:L19` reads "The job builds with the image's own default Xcode; it selects none of its own".
  `git diff 8926052 fcb2e2f` shows that the merge removed `runs-on: macos-14` and the
  `DEVELOPER_DIR` pin and changed nothing else. One clause of the lean is false: "Until that log
  exists the toolchain is unread, and the Swift Testing flip … still waits on it."

  The toolchain has been read on `main` since 2026-10-08. `ka-reader@d852457` ("ci: build with the
  image's Xcode 16.2, and name the toolchain") added the `Toolchain` step
  (`swift --version && xcrun --show-sdk-version`, now `ci.yml:L23-L24`), and that commit is an
  ancestor of `origin/main`. Its first `main` run, 37845881070 on `ka-reader@fcc3d4f`, logs "Apple
  Swift version 6.0.3 (swiftlang-6.0.3.1.10 clang-1600.0.30.1)" and SDK `15.2` on image
  `macos-14-arm64`, version 20260831.0302.1. Run 38449250910 on `ka-reader@8926052`, the newest on
  `main`, logs the same.

  The *Framework* clause departs from Swift Testing only "until a CI log on `main` names a toolchain
  that runs Swift Testing". The clause's own premise is that Swift Testing ships with the Swift 6
  toolchain, and swift.org confirms it. So the trigger fired at run 37845881070, five days before the
  item was raised. That makes three sentences of the same bullet false today, beyond the two the
  item names:
  - *Toolchain — not yet measured.*
  - "`ci.yml` has no `swift --version` step … `grep -n 'swift --version'` … prints nothing over the
    whole file". The grep half is unpinned, and it now prints `:L24`.
  - The *verified by*'s ground, "no command reads which toolchain CI builds with".

  A delivery-tier reader who takes § 9 as written would write a new test in XCTest after the rule
  has flipped. No such test exists yet: `git log --since=2026-10-08 --diff-filter=A` over
  `ka-reader-mac/Tests/` lists no file, and no file imports `Testing`. So the defect is in the
  record only, and folding it now keeps it there.

  *Check 3, against what is settled.* The tools-6.2 departure carries three triggers in one bullet:
  - `:L1691-L1692`: "until CI builds `ka-reader-mac` on an image carrying a Swift 6.2".
  - `:L1707-L1710`: "all six are adopted then. Otherwise the change that moves CI … adopts all six".
  - `:L1711-L1718`, the v47 trigger: the change that writes the `6.2` tools version adopts them.

  The CI move has now landed and adopted none of them (`Package.swift:L1` still reads `5.9`). The
  review gate at the *verified by* ("flip together or not at all") was honoured, but the second
  trigger is now spent and false. SDD RN-108 is the settled source. It ties the tools version to the
  floor ("`Package.swift:L1` moves with the floor") and leaves "which change carries them" to the PM.
  So the one trigger that agrees with the SDD is v47's. The answer keeps that trigger, as the item's
  lean asks, and drops the other two to dated notes.

  *Check 4, the failure paths.*
  - **Absent:** there is no `macos-26` log yet. `main` is three commits ahead of `origin/main`, and
    `gh run list` shows no run on that image, not even on the change's own branch. The answer
    therefore records the `macos-14` reading as the first measurement and names the `macos-26`
    reading as owed, not as taken.
  - **Stale:** a label's default Xcode moves under the same name. This is the bullet's own reason for
    recording the run id and the image version with the Swift version. The `Toolchain` step now runs
    on every build, so every build is a reading, and a later one is a re-measurement, not a
    contradiction.
  - **Refused:** if the `macos-26` toolchain were below 6.2, the change that writes
    `swift-tools-version:6.2` would fail its own CI build, because the line is a floor the compiler
    enforces (`toolchain.md` § Toolchain version). The adoption's ground therefore checks itself, and
    no separate gate is owed.

  *Where I was close to another verdict.* I nearly raised the toolchain and *Framework* corrections
  as a separate item on this companion. I did not, because they correct a clause inside this item's
  own lean, in the same bullet the item asks to have re-derived. A separate bucket-2 item would cost
  another round, with the flip already five days stale. Decided together with 3.2: both re-derive
  `:L1707-L1718`, and this answer takes the trigger while 3.2 takes the measurement.

### 3.2 — § 9 does not say which change re-measures QC-25's hosted-runner narrowing on the new image

- **Bucket:** 3. Raised from downstream — an item from a seat that did not write these records
- **Verdict:** answered
- **Why:** The item offered two candidate owners, the tools-6.2 change or a change of its own, and
  asked for a command, not a lean toward one answer. So I answered it from scratch. The answer
  rejects both readings of "owner" that tie the measurement to an event. It makes the reading
  standing instead: the unentitled control's `out-of-grant-read:` line is visible in the
  `Bundle probe suite` step's log on every hosted build. The change that writes it is one of its
  own, scheduled by the PM.

  *Check 1, the seat.* The change lands in `docs/nfdr.md`: QC-25's tail, § 9's `:L1709-L1710`, and
  § 10's QC-25 row. Those are this seat's, and the answer commits nothing to any person. Naming which
  change unit carries the work would be scheduling, which is the PM's (the global loader's
  *Non-responsibilities*, and SDD RN-108's own "which change carries them … is the PM's"). The answer
  therefore states an obligation and its gate, and leaves the unit to the PM. Part of the change does
  belong to another document. C-I3 (`SDD.md:L889-L894`) states the same narrowing with no image
  named, and QC-25 traces to C-I3 under § 4's rule that the § 4 statement wins. That part is raised
  on `docs/SDD_open_issues.md` § 2.1, which is in this repository and was committed at `b1679d5`
  before this slot was written. The item is not split. The SDD half only dates a sentence. The
  NFDR's answer stands without it, because QC-25 can date its own copy from RN-48, which names the
  run. So this is one question with a consequence upstream, and the upstream consequence is raised
  rather than answered.

  *Check 2, the question.* The PM's evidence holds, and I re-read it:
  - The control prints its report before its summary (`checks/bundle.sh:L382`; the fields at
    `checks/sandbox_probe.rs:L143-L150`).
  - The suite captures the output (`test_bundle.sh:L144-L146`) and, on success, prints only `ok` and
    the case name (`:L1573-L1577`).
  - The `Bundle probe` step prints the entitled bundle's report, but not the control's.

  So a green run cannot show the reading. The question does hide a second question, which is when
  the reading is owed at all. § 9's sentence answered that with "the change that moves CI", and the
  CI move has now landed without the reading. That is the failure mode of an event-bound owner:
  `macos-14` retires on 2026-11-02, and SDD § 11 R-17 already records that the floor follows a runner
  image's lifetime, so the next move will come on GitHub's schedule. A per-build reading answers both
  questions at once, and it gives QC-25's runner clause an enforcement surface. Today that clause
  rests on one run from 2026-09-23.

  *Check 3, against what is settled.* The tools-6.2 change was rejected as the owner for three
  reasons:
  - Its scope is the manifest, and the *verified by* binds its seven flips "together or not at all".
  - RN-108 leaves its timing to the PM, tied to the floor move.
  - A harness print has no relation to the Swift toolchain.

  Nothing settled makes the reading belong to it. The answer agrees with C-I3's renderer-gate half,
  which v48 already dated as "readings on an image CI leaves". It does not contradict 3.1, which keeps
  `:L1711-L1718` as the adoption's only trigger. This answer removes the measurement from that
  sentence's neighbour, `:L1709-L1710`, and the two were decided together. No record is owed.
  ADR-0010 dates its runner measurement (`:L131-L136`, "measured on 2026-09-23"), and the log is
  append-only. If the `macos-26` reading contradicts the narrowing, the change starts at C-I3 and a
  record follows then, not now.

  *Check 4, the failure paths.*
  - **Absent:** no `macos-26` run exists yet, because `fcb2e2f` is on no remote branch. The answer
    therefore dates the narrowing to `macos-14` and states the `macos-26` reading as not yet taken,
    instead of inferring it.
  - **Empty:** the command prints nothing until the suite prints the line. That empty output is the
    measurable "not yet", not a pass.
  - **Stale:** the label's image version moves under the same name. A per-build reading is re-taken
    on every build, so a later reading is a re-measurement.
  - **Refused:** if the control's read is reported `allowed` on `macos-26`, the narrowing lifts and
    C-I3 is restated by the CTO, with QC-25 following. If it is `denied`, the narrowing stands,
    re-dated. In the interim nothing is overclaimed, because the narrowing only removes evidence and
    the control passes on `sandboxed: no` alone.
  - **Concurrent:** does not apply. One control runs per build.

  *What the answer does not cover.* The command reads one run's log, and logs expire under the
  repository's retention. Whether the NFDR records each reading or only the first reading on each
  image is the fold's call. I would record the first reading per image version, as the toolchain
  rule does.

  *Where I was close to another verdict.* I nearly answered "the tools-6.2 change", because it is the
  next change sure to touch CI's results. Its seven-flip gate and its timing, which the SDD leaves to
  the PM's floor schedule, are what tipped me away from it.

## Left for the owner

None this run.

## Skipped

None this run.

## Companions opened

- **`docs/SDD_open_issues.md`** — **opened** — companion to `SDD.md`, landed in commit `b1679d5`

## Launchers owed

- **`docs/adr/` and `docs/nfdr.md`** — `<CORE>/launchers/skill/launcher.sh product-architecture ka-reader`
- **`docs/SDD.md`** — `<CORE>/launchers/skill/launcher.sh product-sdd ka-reader`
