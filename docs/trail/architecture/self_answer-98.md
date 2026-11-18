# Self-answer report — `adr/` and `nfdr.md`

## Header

- **Companion:** `docs/architecture_open_issues.md`
- **Document:** `docs/adr/` and `docs/nfdr.md`
- **Decided by:** `<CORE>/../skills/companion/.claude/skills/companion-self-answer/prompts/rich.md` v1.3.1
- **Date:** 2026-11-18
- **Sources re-read:** None outside this repository. Every answer rests on the product's own tree,
  read at `main`, `ka-reader@3463d17`: `docs/nfdr.md` v101 (§ 9's suites bullet `:L3182-L3205`,
  its dependent counts `:L3335` and `:L3369`, QC-14 `:L736-L756`, QC-65 `:L2615-L2703`, RN-22
  `:L4705-L4840`), `checks/gate.sh` 1.24.0, `checks/readme-capture.sh`,
  `checks/tests/test_readme_capture.sh`, `checks/window_probe/main.swift`, `README.md`, and
  `docs/SDD.md`'s matching passage (`:L3709-L3716`). `git diff --stat 2777e89 3463d17 -- . ':!docs'`
  prints nothing, so every reading at `main` is also the reading at `ka-reader@2777e89`, the commit
  the four items cite.

## Items worked

### 3.1 — § 9 counts thirty top-level suites where the tree holds thirty-two

- **Bucket:** 3. Raised from downstream — an item from a seat that did not write these records
- **Verdict:** answered
- **Why:** **Re-measure the suites bullet at `main` and keep the thirty at `ka-reader@21f611f` as a
  dated reading. This is a correction, not a widening.**

  *Seat.* The edit lands in `nfdr.md` § 9, this companion's own document. It commits no person and
  no promise. It only makes a count true again. So it is answered in the owner's seat.

  *The question.* The item asks for the fold to re-measure. Its facts hold. At `ka-reader@3463d17`
  `git ls-tree --name-only HEAD checks/tests/ | grep -c '/test_.*\.sh$'` prints `32`. Every one of the
  thirty-two is the whole command of exactly one `run_step` line of `checks/gate.sh`, whose header
  reads `Version: 1.24.0`. I checked this with an exact-line match per suite, the bullet's own method,
  and ran no suite. The two new suites are `test_readme_picture.sh` (`checks/gate.sh:L198`) and
  `test_readme_capture.sh` (`:L213`). Every other locator has moved too, for example
  `test_secret_scan.sh` from `:L76` to `:L78`. So the fold re-pins all of them, as the v100 fold did.

  *Check 3 — what else must move.* Two counts in the same bullet are counts of the same set, and the
  v100 fold moved both of them (RN-110). "Four of the thirty have no `checks/<name>.sh`" (`:L3335`)
  becomes "Four of the thirty-two". It is the same four: `test_assemble.sh`,
  `test_secret_scan_planted.sh`, `test_strings_step.sh` and `test_vm_refusal.sh`. Both new suites pair
  by name with a script, `checks/readme-picture.sh` and `checks/readme-capture.sh`. "All thirty"
  (`:L3369`) becomes "all thirty-two". The item did not name these counts. Leaving them would make the
  bullet contradict itself.

  *Check 4 — stale.* The count is a reading, so it goes stale again the moment main gains a suite.
  If a commit lands between this answer and the fold, the fold's own measurement governs, and the
  numbers above are a reading at `3463d17`, not a target. **Empty**, **absent**, **concurrent** and
  **refused** add nothing, because the bullet describes the tree and runs nothing.

  No obligation changes and no ADR is owed.

### 3.2 — QC-65's set of what starts the bundle does not name the README picture's capture

- **Bucket:** 3. Raised from downstream — an item from a seat that did not write these records
- **Verdict:** answered
- **Why:** **QC-65's set names `checks/readme-capture.sh` beside the two scene helpers, in the shape
  they already have. Its suite stays outside the set.**

  *Seat.* The edit lands in QC-65, this companion's own document. QC-65 itself says that "a step
  added later that launches the bundle … joins this set in the change that adds it". The delivery tier
  cannot write the NFDR, so this item is how that rule gets carried out. That makes it a correction of
  a set that is now short, not a widening. It is answered in the owner's seat.

  *Check 2 — the facts.* Each claim holds at `3463d17`. The script's admission is its first work,
  inline, before anything is opened, found or read (`checks/readme-capture.sh:L64-L71`). It needs both
  `uname -s` reading `Darwin` and `sysctl -n kern.hv_vmm_present` reading `1`, and it exits 1
  otherwise (`:L69-L71`). It launches the bundle with `open -n` (`:L339`). Its header says "A person
  runs it in the macOS guest … The gate does not run it". Its suite records `open`, `ps` and `kill`
  through stand-ins (`checks/tests/test_readme_capture.sh:L49`, its `STAND_INS`), and the gate's own
  comment says the same (`checks/gate.sh:L200-L206`). The refusal case the item names is at
  `checks/tests/test_readme_capture.sh:L484`. The item did not give that line, and the fold needs it.

  *Check 3 — one difference from the other helpers.* QC-65's *verified by* names a twin for each of
  the two scene helpers in `checks/tests/test_vm_refusal.sh`. `grep -n readme
  checks/tests/test_vm_refusal.sh` finds nothing, so there is no twin for this script. QC-65 does not
  require one. Its rule puts each script's case in that script's own suite. The refusal suite exists
  for the two guarded steps that are suites themselves and cannot run their own case. So the fold
  names the own-suite case only, and it must not copy the helpers' "beside …" clause onto a twin that
  does not exist.

  *Check 4 — the home.* The script reads the account's login name, full name and home folder path,
  and the host and computer names (`id`, `hostname`, `scutil`). It reads them only to refuse a picture
  whose metadata carries them, and it refuses a work folder under the home folder. It never reads the
  app's container. So "read the running machine's home", in the sense this entry guards and in which
  it set the host walks' Desktop output aside, does not reach it. Only the launch does. The fold
  should say this, so a later reader does not count the script in twice or argue it out. **Refused:**
  off a VM it exits 1 and says why, the same status the scene helpers use. **Concurrent:** a second
  copy of the bundle already running is the script's own concern (it records only the new process),
  and QC-65 does not reach it.

  § 10's QC-65 row follows. No record is owed.

### 3.3 — QC-14's list of programs a check compiles at run time does not name the window probe

- **Bucket:** 3. Raised from downstream — an item from a seat that did not write these records
- **Verdict:** answered
- **Why:** **QC-14's list names the window probe — Foundation, ImageIO and CoreGraphics, compiled by
  `checks/readme-capture.sh` into its own work folder — and the list is re-pinned at one commit.**

  *Seat.* The edit is a list inside QC-14, this companion's own document. The clause already allows
  "a program a check compiles into a temporary folder of its own at run time". The list is the
  measured reading of which programs those are. Adding one that exists is a correction. It is
  answered in the owner's seat.

  *Check 2 — the facts.* `checks/window_probe/main.swift:L1-L3` imports CoreGraphics, Foundation and
  ImageIO. `checks/readme-capture.sh:L320` compiles it with `swiftc` into `$work`. That work folder is
  made by `mktemp -d` under `/tmp/ka-reader-picture.XXXXXX` (`:L226`), and the script refuses one
  under the home folder. It is the same shape as the icon probe. The item's "`:L89`" is the line that
  names the source (`PROBE_SOURCE`), not the compile. Both are right for what they cite.

  *Check 3 and the whole of the list.* I asked whether the list is now complete. A search of
  `checks/*.sh` for `swiftc` and `rustc` finds exactly four programs compiled at run time: the
  idle-shell control (`checks/renderer.sh:L331`), the icon probe (`checks/app-icon.sh:L120`), the
  sandbox probe (`checks/bundle.sh:L434`) and the window probe. (The gate's `rustc -V` and
  `rustc -vV` only print versions.) So with this addition the list is whole at `3463d17`. Two of the
  three existing locators have moved since `03bb989`. The bundle compile is `:L434` alone now, not
  `:L433-L434`. So the fold re-pins all four at one commit and keeps the `03bb989` reading as dated,
  the NFDR's usual form.

  *Check 4 — never shipping.* The existing verifiers hold the new entry unchanged.
  `checks/bundle.sh` finds nothing of `checks/` under `Contents/`. What a run-time program imports
  stays `development-design`'s review, because no check reads those imports. **Stale:** a fifth
  program would make the list short again. QC-14 has no check that catches it, which is the review's
  known limit, already stated in its *verified by*. This answer does not widen that.

  No record is owed.

### 3.4 — The NFDR cites the README's stack and proof sentences by line numbers that hold other text

- **Bucket:** 3. Raised from downstream — an item from a seat that did not write these records
- **Verdict:** answered
- **Why:** **Do not re-point the locator in place. Pin it to the commit it was true at, add a dated
  note that what it called owed has landed, and cite today's sentences by section.**

  *Check 2 — the framing is narrower than the item.* The item's facts about today hold. At
  `3463d17`, `README.md:L44-L51` is a blank line, the "inspection rather than authoring" paragraph
  and its first bullet. `## Stack` is `:L58`, and its sentence opens at `:L60`. The only
  `README.md:L` citation in the NFDR is `docs/nfdr.md:L4834`. But that line is not a live claim in a
  constraint. It sits in RN-22, the review note of the v11 fold. `git log -L4834,4834:docs/nfdr.md`
  shows it was written in `38aaa48`, the v11 commit. At that commit `README.md:L44` is `## Stack` and
  `:L46-L51` hold the stack sentence and the `checks/` proof sentence. **So the locator was true when
  it was written.** It is stale only because it never carried its commit. "Re-point the locator"
  would rewrite what a past note recorded, and the note is history. The NFDR keeps old readings as
  dated readings rather than overwriting them, and the fold should do that here too.

  *Check 3 — what the clause says is also out of date.* RN-22 lists the README sentences and the
  project card's `Languages:` and test command as "Owed outside this document". Both have landed. The
  SDD's own copy of the same clause (`docs/SDD.md:L3709-L3716`) already records this. The card moved
  at `kensaiapp-opensource@5b27023` (SDD RN-66). The README's `## Stack` names the one bundle and
  process with no web engine, and keeps the proof sentence word for word, from `ka-reader@61748fe`
  (SDD RN-68). The NFDR's RN-22 never got that note. So a cold reader would take two finished items
  as still owed. This is the same clause the item points at, so fixing it is part of this answer, not
  a new item.

  *The answer.* The fold (a) pins the locator as `ka-reader@38aaa48:README.md:L46-L51`. It (b) adds a
  dated note, in the form the SDD's RN-68 note uses, saying that both owed items landed and naming the
  two commits above. It (c) cites today's sentences by section, `README.md` § *Stack*, not by line.

  *Check 4 — stale.* The item says the README is about to gain an image paragraph that moves every
  line below it by two. A line locator pinned at `main` today would be false again after that change.
  A section citation survives it. If the heading `## Stack` is renamed, the section citation goes stale
  too, so the note carries its commit as well. No obligation changes and no ADR is owed.

## Left for the owner

None this run.

## Skipped

None this run.

## Companions opened

None this run.

## Launchers owed

- **docs/adr/ and docs/nfdr.md** — `<CORE>/launchers/skill/launcher.sh product-architecture ka-reader`
