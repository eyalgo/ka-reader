# Self-answer report — `docs/adr/` and `docs/nfdr.md`

## Header

- **Companion:** `docs/architecture_open_issues.md`
- **Document:** `docs/adr/` and `docs/nfdr.md` (NFDR v14, Settled; ADR-0012 Accepted)
- **Decided by:** `decide_companion_answers.md` v1.3.0
- **Date:** 2026-09-24
- **Sources re-read:**
  - GitHub Actions run 35988399477 (`gh run view --json headSha,conclusion,headBranch`): `success`,
    `headSha` `37a962d`, branch `2026-09-24_the-shell-is-seen-at-the-panel`.
    `git diff --stat 37a962d HEAD -- checks/renderer.sh checks/fixtures/idle-shell ka-reader-mac/Sources`
    prints nothing, so the run read the script and shell `main` holds. Its *Renderer gate* lines are
    quoted by the item and re-verified by the SDD's fold (`docs/SDD.md` RN-70); this run did not
    re-download that log.
  - GitHub Actions run 35968105480 on `main` (`gh run view --log`): `headSha` `c461b29`, `success`.
    Image `macos-14-arm64`, version 20260831.0302.1, macOS 14.8.9. `Test gate` ran
    `cargo test --workspace --locked && swift test --package-path ka-reader-mac`, and the XCTest suites
    ran with 0 failures. No line prints a Swift version.
  - `gh repo view kensaiapp/ka-reader --json visibility` → `PRIVATE`.
  - https://docs.github.com/en/billing/concepts/product-billing/github-actions, read 2026-09-24:
    usage "is free for self-hosted runners and for public repositories that use standard
    GitHub-hosted runners". Private repositories receive "a quota of free minutes … depending on the
    account's plan". macOS 3-core or 4-core runners cost $0.062 a minute.

**What was read.** The companion whole. `docs/nfdr.md` whole (§§ 1–10; RN-16 onward read in full, and
RN-1 – RN-15 for what they record). `docs/adr/0012-…md` whole. `docs/SDD.md` § 4 C-I3 as it reads at v18
(Settled, `ka-reader@399ef71`) and its RN-70, which folded the SDD's half of § 3.2 and closed the
hosted-runner question. The tree at HEAD: `checks/` and `checks/tests/` listed; `checks/renderer.sh`'s
header (`:L1-L70`); `checks/view.sh`'s scan table (`:L33-L87`) and `:L116`; `.github/workflows/ci.yml`
whole; `ka-reader-mac/Sources/Shell/LaunchFlow.swift:L34-L37` and `OpenFolderPanel.swift:L9-L15`.
`bash checks/tests/test_renderer.sh` run at HEAD printed `test_renderer.sh: 1 case(s) failed`, the
case being `test_header_names_the_runner_reading`. `git diff --stat 153f5a1 HEAD` over `checks`,
`.github`, `ka-reader-mac`, `docs/nfdr.md` and `docs/adr` prints nothing, so every item's measurement
at `ka-reader@153f5a1` holds at HEAD. The occurrence bar for a widening downstream item was read at
`<CORE>/prompts/pm_shukuba_refine.md` § *A gap is carried only where it occurs*.

**How the items were taken.** In the companion's order. §§ 3.1 and 3.2 were decided together, because
both rewrite QC-62's tail and ADR-0012's same paragraphs. Each *why* says so.

## Items worked

### 3.1 — QC-62 says the renderer gate and its control are not in the tree, and that the gate is red until the native shell lands. Both are in the tree, and the gate passes

- **Bucket:** 3. Raised from downstream — an item from a seat that did not write these records
- **Verdict:** confirmed with addition
- **Why:** The lean holds, and for the reason it gives: every sentence it corrects is measured false.
  `ls checks checks/fixtures` lists `renderer.sh` and `idle-shell`. `ci.yml:L43-L44` runs the gate
  as `Renderer gate`, after `Bundle probe` at `:L31-L32`. The script's header records the Mac reading
  (`:L58-L61`). Run 35988399477 is the runner reading, on a tree whose `renderer.sh` is byte-equal to
  `main`'s. *Check 1:* the change lands in `nfdr.md` QC-62, this companion's document, so it is this
  seat's. *Check 2:* the lean says only that "the not-covered clause closes". Closing it with nothing
  in its place would read as full coverage. `docs/SDD.md` § 4 C-I3 at v18 does not do that: it
  replaces the "unmeasured" sentence with a standing rule. A runner image or macOS whose Open-panel
  frames read differently turns the gate red on the next build, a re-cut trigger on the mechanism and
  never on the gate. SDD RN-70 also names the half the gate does not cover: a thread sample shows the
  shell in the panel's run, not the panel on screen. So the addition carries both. *Check 3:* the SDD
  is upstream and moved to v18 after this companion was opened (RN-70). Its seventh Open Questions
  item is gone, so QC-62's two pointers to "§ Open Questions, last item" now land on a different
  question; the addition re-points them. ADR-0012 carries the same now-false sentences: § Consequences
  says "is unmeasured" and points at the same Open Questions item, and § Decision's
  red-by-construction paragraph states a condition that has lapsed. The item names only QC-62. The
  companion covers both records, though, and correcting one while leaving the other would make the
  record and its entry disagree. The ADR edits are dated in-place corrections, not a superseding
  record. This NFDR has used that form before (ADR-0010 at v9, RN-20; ADR-0016 at v13, RN-24) whenever
  a premise moved and no decision reversed. No decision reverses here: the record states that "what
  this record fixes is the gate, its two rules … and its place after the wall probe, not the frames".
  *Check 4 (stale):* the runner reading comes from a branch run, and no CI run on `origin/main`
  (`c461b29`) has run the gate yet, because `main`'s local commits from `153f5a1` on are not pushed.
  The correction cites the run id, image and macOS version together, so a later image's reading is
  distinguishable. *Check 4 (absent):* the script's header does not carry the runner reading. That is
  task 6 of the change that landed the gate, deferred (`kensaiapp-opensource`,
  `system/projects/ka-reader/journey/tobiishi/trail/2026-09-24_the-shell-is-seen-at-the-panel/change_request.md:L77`).
  So the correction cites the run, not the header. I was close to leaving ADR-0012 out and raising it
  as a separate item. A second item would ask the next round the same question twice, and that is
  what tipped it.

### 3.2 — QC-62 and ADR-0012 put the observation "inside `open_folder`'s call", and the native shell calls `open_folder` only after the panel returns

- **Bucket:** 3. Raised from downstream — an item from a seat that did not write these records
- **Verdict:** confirmed with addition
- **Why:** The lean's wording is taken exactly. It is now also the upstream wording: `docs/SDD.md`
  § 4 C-I3 at v18 reads "parked in the Open panel's modal run, inside the shell's launch frames".
  This NFDR's standing rule is that the § 4 statement wins and the entry is re-derived. So this is
  transcription, and check 3 is the strongest ground. The item's evidence is re-verified at HEAD.
  `LaunchFlow.swift:L35-L37` calls `panel.chooseFolder()` and only then `bridge.openFolder`.
  `renderer.sh:L44-L57` lists five frames with no bridge frame, and says why. *Check 1:* it lands in
  QC-62 and ADR-0012, this companion's records. *Check 2:* the draft is right but leaves out three
  things, which are the additions. (a) The frame list is cited from the script's header, not copied.
  C-I3 cites it the same way, and a copy would put the frames in three files to move at the next
  re-measurement. (b) QC-62's *verified by* says the frames "are re-measured on the first slice's
  first native bundle". That is future tense for a fact now past, so it moves with this item.
  (c) The form of the ADR edit: a dated in-place correction, on the same ground as § 3.1. *Check 4:*
  a sample taken before the main queue is up labels the thread `Main Thread`, and the script
  accepts both labels (`renderer.sh` header, THE FRAMES). A panel that never presents turns the gate
  red, which is what the gate is for. A macOS release that renames AppKit's modal-run symbols is the
  re-cut trigger § 3.1 carries. Decided together with § 3.1.

### 3.3 — QC-51's *verified by* says there is no modal presentation in `ka-reader-mac/Sources`, and the Open panel's is there

- **Bucket:** 3. Raised from downstream — an item from a seat that did not write these records
- **Verdict:** confirmed with addition
- **Why:** The tail is measured false. `OpenFolderPanel.swift:L14` holds `panel.runModal()`, and C-R3
  requires the panel at launch. *Check 1:* the change lands in QC-51's tail, so it is this seat's.
  *Check 2:* the lean's wording, "other than the Open panel's own presentation", is right but looser
  than what the scan enforces. `checks/view.sh` F13 (`:L80-L86`) admits exactly one no-argument
  `.runModal()` in `OpenFolderPanel.swift`. It reports a second one there, one with an argument, and
  any in another file. The record should state the bound the check holds, or a reader would take a
  sheet or a second panel under `Shell/` as admitted. That bound is the addition. *Check 3:* QC-51's
  rule sentence ("no modal … carries a failure") is not false, because the Open panel carries no
  failure, so only the tail moves. RN-22 (3) records the modal symbols as this document's realization
  of `surfaces`' "Must not own", and that realization now carries the C-R3 exception. The trace gains
  C-R3. *Check 4:* a future second modal need (the folder selector, S-10) is not admitted by this
  wording. It would need its own C-R3-level source and a same-change edit of F13, which is the right
  default.

### 3.4 — QC-34's *verified by* gives its forbidden set as the whole scan, and `checks/view.sh` scans thirteen families

- **Bucket:** 3. Raised from downstream — an item from a seat that did not write these records
- **Verdict:** confirmed with addition
- **Why:** The lean offers two branches, and this takes the second: point at `checks/view.sh`'s header
  as the list, and keep C-R7's set as the floor. *Check 2:* the first branch, naming the thirteen
  families in QC-34, would put a second copy of a list in this repository. It would go stale the first
  time QC-34's own same-change clause adds a family, and the clause invites exactly that. The script
  already states the relation the second branch asks for: "QC-34's, QC-1's and QC-23's lists point
  here: this header is the list, and C-R7's set is its floor" (`view.sh:L87`). That removes the
  first branch's premise that the record must carry the list for a reader to find it. The pointer is
  inside this repository, so the NFDR's rule that an out-of-repo trace must state its rule in full
  does not apply. The fourteen names QC-34 lists are C-R7's set and stay as the floor; every one is
  inside F2–F8 and F10. *Check 3:* QC-1 points at QC-34, and QC-23's *verified by* names "the
  forbidden-symbol scan" with no list. Neither is false, so the addition is that they follow QC-34's
  tail and gain no text of their own. The item named them; this says why they need no edit. QC-30
  half (1) names three symbols this document added to the scan, and F11 holds all three, so it is
  consistent. *Check 4:* a shell API neither the header nor C-R7 names is still caught by QC-34's
  same-change review clause, which stands.

### 3.5 — No record says where the harness's own suites run, and one is red on `main` while every gate is green

- **Bucket:** 3. Raised from downstream — an item from a seat that did not write these records
- **Verdict:** confirmed with addition
- **Why:** This item widens § 9 and § 10, which state nothing today about `checks/tests/`
  (`grep -n 'checks/tests' docs/nfdr.md` prints nothing). It cites an occurrence: a measured failure.
  `test_renderer.sh` fails one case at HEAD, re-run by this run, while CI is green. So the widening is
  admitted, and it is admitted for the form that occurs: five of six suites are on no gate.
  *Check 1:* where suites run is § 9's test-strategy realization, this document's own. *Check 2:* the
  lean offers three branches and claims "either way, a red suite is no longer invisible to every
  gate". That claim fails for its third branch: owner-run suites that gate nothing leave a red
  suite invisible to every gate, which is the state on `main` now. So the third branch is struck. Of
  the first two, a CI step per suite is taken. It is the form already standing: `Bundle probe suite`
  (`ci.yml:L35-L36`), which QC-25's tail requires ("the script's suite runs the same probe … without
  which the probe has not run"). It is also the rule ADR-0012 states for the renderer gate: "a gate
  that cannot go red has not run". A harness script whose suite runs nowhere is that rule broken one
  level down. *Check 3:* nothing settled contradicts it. § 9's "Layers 6–7" bullet already says the
  layer-6 scripts run in CI. *Check 4 (ordering):* the red case,
  `test_header_names_the_runner_reading`, is the test of task 6, deferred (the runner reading in the
  script's header). Adding `test_renderer.sh`'s step before that task lands turns `main` red on a
  known, carried gap. So that step lands with the task or after it, never by skipping the case.
  *Check 4 (absent):* whether each suite can run on the hosted runner is unmeasured. `test_renderer.sh`
  drives stand-ins and the real bundle. `test_own_state.sh` reads the container, which the CI's
  launch step notes can wait on a consent prompt (`ci.yml:L57-L59`). A suite that cannot run there is
  recorded with its measurement and runs as a named release step, and is never left silent.
  **Where I was close to leaving it for the owner:** the repository is private, and GitHub bills
  private-repo macOS minutes past a plan quota at $0.062 a minute (source above). How close the
  account is to its quota, and what it pays, are things this run cannot see. It stayed a decision
  here because the owner already pays for macOS CI on every push (their cycle-8 answer 4 put the
  renderer gate there). Six suites, mostly over stand-ins, add to that CI rather than start it. What
  would tip it: if minutes are the constraint, the lean's second branch, the suites as one named
  release step, is the fallback. The slot says so, so an override takes it in one line.

## Left for the owner

None this run.

## Skipped

None this run.

## Raised on this document

### 2.1 — § 9 says no CI run on `main` has built `ka-reader-mac`. Run 35968105480 on `main` did, and its log names no Swift toolchain

- **What the document is owed:** § 9's `ka-reader-mac` toolchain clause records run 35968105480 on
  `ka-reader@c461b29` (image `macos-14-arm64` 20260831.0302.1, macOS 14.8.9) as the first `main` run to
  build `ka-reader-mac`, and records that its log names no Swift version. So, by the clause's own rule,
  it stays *not yet measured* and waits for a log that names the toolchain. The `a4ab8e6` reading
  becomes dated history.
- **Why it is worth a cycle:** "A fact in it is now false", and the bullet names its own trigger.
  "The first CI log on `main` that runs those steps supplies the value and this line takes it … if
  the first log names none, this line stays *not yet measured* and says it waits for a log that
  does." That log exists (`gh run view 35968105480` → `success`, `c461b29`; `Test gate` ran
  `swift test --package-path ka-reader-mac`), and its only `swift-version` line is a build file name,
  `Write swift-version-76B232A4806BA581.txt`. The clause is what a review of a CI or `Package.swift`
  change reads. The round is already owed for §§ 3.1 – 3.5, so this rides the same
  `product-architecture` run and costs no extra cycle. It was appended as § 2 of the companion
  (*Choices to confirm*), a section the companion did not carry. The section and its one item were
  added in the template's position before § 3. No existing item or section moved. Its slot is at its
  placeholder.

## Companions opened

None this run.

## Launchers owed

- **`docs/adr/` and `docs/nfdr.md`** — `<CORE>/launchers/skill/launcher.sh product-architecture ka-reader`
