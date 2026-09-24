# Self-answer report — `docs/SDD.md`

## Header

- **Companion:** `docs/SDD_open_issues.md`
- **Document:** `docs/SDD.md` (Settled, v16)
- **Decided by:** `decide_companion_answers.md` v1.3.0
- **Date:** 2026-09-24
- **Sources re-read:** None. Neither answer rests on a source outside this repository. Both rest
  on this repository's own history, which was read directly: `git show 61748fe -- README.md`,
  `git show a4ab8e6:README.md`, `git show a4ab8e6:nozoki-ui/src/main.ts`,
  `git show a4ab8e6:crates/nozoki-app/src/main.rs`, and
  `git diff --stat ba63b44 a4ab8e6 -- nozoki-ui/src/main.ts crates/nozoki-app/src/main.rs crates/nozoki-app/Entitlements.plist`,
  which printed nothing.
- **What was read:** the companion whole; the decision prompt whole; `SDD.md`'s header and
  Version line, § 10 RC-3 whole, RN-52 (L3243–L3319), RN-59, RN-60 and RN-66 whole, and
  *Open Questions*; every line of `SDD.md` naming `crates/nozoki-app` or `nozoki-ui`; and a sweep
  of every backticked file path in `SDD.md` checked for existence at `HEAD`. **The rest of the
  3,824-line SDD was not read line by line.** Both items are narrow corrections of fact, so the
  sweep and the named sections are what they depend on.

## Items worked

### 5.1 — RC-3's *Still unresolved* lists the README's stack sentences as not yet moved, and they have moved

- **Bucket:** 5. Raised from downstream — an item from a seat that did not write the SDD
- **Verdict:** confirmed with addition
- **Why:** The PM's claim holds. `SDD.md:L2321-L2327` lists "`README.md:L46-L51`'s stack and proof
  sentences" as owed outside the document. `git show 61748fe -- README.md` shows `## Stack`
  rewritten to one bundle and one process: `nozoki-mac`, `crates/nozoki-core`,
  `crates/nozoki-bridge`, no web engine. It also shows the status block renaming the same three
  units. The proof sentence ("A shell harness under `checks/` proves the read-only and no-network
  promises on every build") was kept word for word, and it is still true. `61748fe` is on `main`
  (`git merge-base --is-ancestor 61748fe HEAD`). The item corrects a false statement, so it is not
  a widening, and the downstream-widening rule does not apply.
  **Check 1:** the edit lands in `SDD.md` and binds nothing but the document's own consistency. It
  is this document's, in the owner's seat.
  **Check 2:** the lean (a dated parenthesis, in RN-66's form) is right, but it covers less than
  the document needs. **First**, RC-3's citation `README.md:L46-L51` is unpinned. At `HEAD` those
  lines hold the new paragraph and the start of `## Roadmap`, not the sentences the clause meant.
  The parenthesis should pin them at `nozoki@a4ab8e6:README.md:L46-L51`, where they stand
  unchanged since `ba63b44` (`diff` of the two ranges printed nothing). **Second**, two other
  sentences still name the README as owed: RN-59 ("`README.md:L46-L49` … moves with the README in
  its own change") and RN-60's *Owed outside this document*. RN-66 set the precedent when the card
  moved: it gave RC-3 *and* RN-60 the same dated parenthesis. Folding RC-3 alone would leave two
  places saying the README is still owed.
  **Check 3:** nothing settled moves. RC-3's other *Still unresolved* members (the renderer frames,
  TextKit, the grammar engine, the records and NFDR entries owed in § 12) are untouched.
  **Check 4 (stale):** a pin cannot go stale. That is the reason for the pin rather than a bare
  line range, since the unpinned range is exactly what went stale here.
  I was close to plain *confirmed*. What tipped it is that RN-66, the precedent the lean itself
  cites, dated both of the sentences that named the card as owed.

### 5.2 — Three Review Note citations point into files that no longer exist, with no pin

- **Bucket:** 5. Raised from downstream — an item from a seat that did not write the SDD
- **Verdict:** confirmed with addition
- **Why:** The claim holds. `git ls-files nozoki-ui crates/nozoki-app | wc -l` prints `0`. The
  files were deleted by `fad4e78` and reached `main` through the merge `0aca57e`. At `a4ab8e6`,
  `nozoki-ui/src/main.ts:L14-L19` is `start()` calling `runStartFlow(invoke)`, and
  `crates/nozoki-app/src/main.rs:L17-L19` is `open_folder` calling `pick_folder()`. These are what
  RN-52 says they are.
  **Check 1:** this document's, in the owner's seat. It is a citation fix inside `SDD.md`.
  **Check 2:** the conclusion is right, but the reason given does not hold as written. `a4ab8e6`
  is not "the last commit where both files stood". `5d37fae` (`fad4e78^`, on the merged branch) is
  later. The pin is still the right one for two reasons. `a4ab8e6` is the last commit on `main`'s
  first-parent line before the removal merged (`git log --first-parent`). And the three files are
  byte-identical from `ba63b44`, the run-10 commit that first wrote these citations
  (`git log -S`), through `a4ab8e6`, so the pinned lines are the lines RN-52 read. The draft also
  covers less than the item's heading. RN-52's source list at `SDD.md:L3318` cites
  `crates/nozoki-app/Entitlements.plist`, a fourth citation into a removed file. It has no line
  anchor, so the item's grep missed it. It gets the same pin.
  **Check 3:** the pin form `nozoki@<sha>:<path>` is already used in the same note
  (`nozoki@70a879a:docs/trail/sdd/cycle-1.md`, `SDD.md:L3319`), so nothing new is introduced.
  **Check 4:** a sweep of every backticked file path in `SDD.md` against `HEAD` found three more
  mentions of removed files: `main.ts` at L2223, `tauri.conf.json` at L3266, and RN-4's *Lives in*
  cells at L2599-L2600. These are deliberately left without a pin. Each one describes the previous shape
  as history and claims no file content at a line, so a reader has nothing to follow. The other
  missing paths the sweep printed are checks that are planned and not yet built (`checks/renderer.sh`,
  `checks/latency.sh`, …), instance-tree paths, or bare filenames. None of them is a citation that
  the removal broke.

## Left for the owner

None this run.

## Skipped

None this run.

## Companions opened

None this run.

## Launchers owed

- **`docs/SDD.md`** — `<CORE>/launchers/product-sdd/launcher.sh nozoki`
