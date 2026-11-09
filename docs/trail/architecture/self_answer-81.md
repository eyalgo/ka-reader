# Self-answer report — `adr/` and `nfdr.md`

## Header

- **Companion:** `docs/architecture_open_issues.md`
- **Document:** `adr/` and `nfdr.md` (NFDR v86, Settled)
- **Decided by:** `<CORE>/../skills/companion/.claude/skills/companion-self-answer/prompts/rich.md` v1.3.1
- **Date:** 2026-11-09
- **Sources re-read:** None. Every answer rests on the product's own workflows, scripts, suites and
  records, read in this repository, and on no source outside it.

The companion holds three items, all under § 3, opened by the PM on 2026-11-09. Each item's *If a
document has to be written* line proposes what the fold would write, and this run read each as a
draft. Measured at `ka-reader@703f818`, whose only changes from `2d7c4f9` are under `docs/`
(`git diff --stat 2d7c4f9 HEAD -- . ':!docs'` prints nothing), so every reading below holds at
`2d7c4f9`, the commit the items cite. Between `3fa227e` and `2d7c4f9` the only existing file under
`checks/` or `.github/` that changed is `checks/gate.sh` (+13 lines); the rest of that diff is the
new workflow, the five release scripts and their five suites (`git diff --stat 3fa227e 2d7c4f9 --
checks/ .github/`).

All three items correct statements the tree has made false. None widens the NFDR, so § *A widening
item waits until it occurs* does not apply. All three are this seat's: the edits land in the NFDR,
and they commit no person, outside party or risk. Check 3 also read the SDD at v82, whose
`read-only-harness` row was re-pinned at `2d7c4f9` the same day. It counts twenty-one scripts and
twenty-two suites, puts the dispatcher at `:L40-L47`, and leaves QC-64, § 9's count and QC-70 to this
seat. None of the three answers contradicts it.

## Items worked

### 3.1 — QC-64 says "the CI workflow" holds no rule of its own; the tree now holds two workflows, and the release one holds a gate no gate step runs

- **Bucket:** 3. Raised from downstream — an item from a seat that did not write these records
- **Verdict:** confirmed with addition
- **Why:** QC-64 and its row name `ci.yml` as the workflow they mean, and one added sentence says
  where `release.yml` is held. The draft is right. It leaves out three things a cold reader of the
  NFDR needs.

  1. **What is false, measured.** `ls .github/workflows/` prints `ci.yml` and `release.yml`.
     `release.yml:L63-L66` runs `cargo audit`, and `grep -n audit checks/gate.sh` finds no step that
     runs it. `release.yml:L77-L78` runs `shasum -a 256 -c SHA256SUMS`, which no gate step runs
     either. So "the workflow holds no rule of its own" (`docs/nfdr.md:L2360-L2361`) and the row's
     "the workflow holds none of its own" (`:L3210`) are false as soon as "the workflow" can mean
     either file. Both stay true of `ci.yml`: `grep -nE '^[[:space:]]+run:' .github/workflows/ci.yml`
     still prints only `:L28` (`checks/gate.sh`) and `:L34` (packaging).
  2. **Check 2: the draft leaves two things out.**
     - *How much the shape check holds.* The draft says `release-shape.sh` holds `release.yml`'s step
       list. It holds more than that. Its *No other write* requirement (CP-1181,
       `checks/release-shape.sh:L484`) refuses any step it does not list, and *order*
       (`:L344-L359`) holds the order, the audit's place between the install and the version check
       included. So `release.yml` has the *nothing else* half that QC-64 says no script holds for
       `ci.yml`. The `development-design` review gate in QC-64's tail therefore stays scoped to
       `ci.yml` and does not reach the new file. Leaving that unsaid would invite a reader to apply
       the review gate to both files, or to neither.
     - *Who runs the audit.* QC-27's tail says `cargo audit` is "a release gate" but not what runs
       it, and QC-27's § 10 row says "release". `release.yml` is now that runner. It is also the only
       step under QC-27 that sits outside the change gate, so QC-27's tail names it.
  3. **Check 3.**
     - *QC-28.* `release-shape.sh`'s *No secret, no signing, one permission* (CP-1182, `:L485`) agrees
       with QC-28's "the release workflow holds no signing identity". This answer does not touch
       QC-28.
     - *QC-29.* QC-29 already names `release.yml` as the build, and this answer only adds which
       step checks the sums.
     - *§ 8.* § 8's "No release can be built the way C-R4 states either" while Actions is off is
       still true. The SDD at v82 re-read the platform on 2026-11-09 and found Actions off and
       `release.yml` never run.
  4. **Check 4: the failure paths.**
     - *Absent (Actions off).* `release.yml` runs at no point, so QC-27's audit gates nothing. That
       costs nothing until a release exists, and QC-29 offers no release unless that workflow built
       it from its tag. The answer says this outright rather than leaving it to inference, because it
       is the case a reader of QC-27 most needs.
     - *Refused.* The audit reads the advisory database over the network (`release.yml:L56-L58`). If
       it cannot, the step fails and nothing after it runs (`:L4-L5`), so the release fails closed.
     - *Concurrent.* A second run for the same tag queues behind the first and stops at *Existing
       Release* (`:L28-L32`, `:L80-L83`). That is the workflow's own behaviour and needs no
       constraint here.
     - *Stale.* The locators are dated at `2d7c4f9`, in the form QC-64 already uses.

  **What could have tipped it:** if `release-shape.sh` did not hold the whole step set, `release.yml`
  would have needed the same review gate as `ci.yml`, and the verdict would still have been
  *confirmed with addition*, with a wider review clause.

### 3.2 — § 9's harness-suites bullet counts seventeen suites; the tree holds twenty-two

- **Bucket:** 3. Raised from downstream — an item from a seat that did not write these records
- **Verdict:** confirmed with addition
- **Why:** The bullet is re-measured at `2d7c4f9`, and the seventeen at `3fa227e` become a dated
  reading. That is how the bullet has kept every earlier count (RN-95, RN-82, RN-80 and back). The
  draft is right. It does not say which other sentences in the bullet move with the count.

  1. **Measured.** `ls checks/tests/*.sh | wc -l` prints `22`. For each suite, the `run_step` line in
     `checks/gate.sh` whose whole command is that path: `:L59`, `:L77`, `:L90`, `:L92`, `:L95`,
     `:L97`, `:L107`, `:L118`, `:L120`, `:L122`, `:L128`, `:L129`, `:L136`–`:L141`, `:L147`–`:L150`.
     The slot gives the full mapping. Every suite is one step, so QC-64's
     `for s in checks/tests/*.sh; do grep -q "$s" checks/gate.sh || echo "$s"; done` still prints
     nothing.
  2. **Check 2: what moves with the count.**
     - *The pairing sentence.* "Three of the seventeen have no `checks/<name>.sh` of their own name"
       now reads three of twenty-two. They are the same three: `test_secret_scan_planted.sh`,
       `test_strings_step.sh`, `test_vm_refusal.sh`. Each of the five new suites pairs by name with
       a `checks/release-*.sh`.
     - *The suites counted at v85.* The bullet's clause naming them should name the five counted
       now.
     - *The `Test gate` locator.* `ci.yml:L28` is unmoved. `release.yml` runs the gate through its
       own `Test gate` step at `:L53-L54`. 3.1 states that once, in QC-64, and this bullet does not
       repeat it. The two answers were decided together on this point.
  3. **Check 3.** The SDD at v82 counts twenty-two suites at the same commit, so the two documents
     agree.
  4. **Check 4.**
     - *Stale.* The count is a dated reading by construction. The bullet already says a further
       suite, or a step inserted, moves it.
     - *Empty and concurrent.* Neither applies.

### 3.3 — QC-70's dated reading of the statuses the tree holds names none of the five release scripts

- **Bucket:** 3. Raised from downstream — an item from a seat that did not write these records
- **Verdict:** confirmed with addition
- **Why:** The reading is re-measured at `2d7c4f9`, and the `3fa227e` reading stays dated. The draft
  is right, but the reading needs two locators the item does not name.

  1. **Measured.**
     - `grep -nE 'exit [0-9]+|trap ' checks/release-*.sh` confirms each line the item cites: `exit 2`
       at `release-version.sh:L39`, `release-pack.sh:L43`, `release-sums.sh:L33`,
       `release-absent.sh:L34` and `release-shape.sh:L39`, and `trap 'exit 1' HUP INT TERM` at
       `release-pack.sh:L68`. Each script's other literal exit is 1.
     - `grep -ohE 'exit [0-9]+' checks/*.sh | sort | uniq -c` finds only 0, 1, 2, 130 and 143.
     - The statuses therefore stay within QC-70's five.
     - QC-70 names `checks/offline-page.sh` as the one script that maps a signal to 1. It should now
       name both.
  2. **Check 2: what the item narrowed.** The item asks about the five release scripts. Re-measuring
     the whole reading turns up two more things:
     - *The dispatcher moved.* `grep -n 'run_step() {' checks/gate.sh` prints `40`, and `38` at
       `3fa227e`. So QC-70's `checks/gate.sh:L38-L45 at ka-reader@3fa227e` is now `:L40-L47`, the
       locator the SDD at v82 also gives.
     - *`checks/tree-walk.sh` passes its child's status through.* It ends `exit "$scene_status"`
       (`:L128`), the status `tart exec` returns for `checks/tree-scene.sh` run in the guest
       (`:L113`, `:L115`). `git cat-file -e 3fa227e:checks/tree-walk.sh` shows it was already in the tree when
       the reading was taken, and the reading named only `checks/own-state-step.sh` for that
       clause. It is named now.
  3. **Check 3.**
     - *The other locators.* `git diff --stat 3fa227e 2d7c4f9 -- checks/` changes no existing script
       but `gate.sh`, so every other locator in the reading, and the known-gap lines at `:L219-L224`,
       hold as written.
     - *The SDD.* It counts twenty-one scripts at the same commit.
  4. **Check 4: one case not covered, and not raised.**
     - *Under `tart exec`.* `tree-walk.sh`'s status is `tart exec`'s. When the guest cannot be
       reached, that is `tart`'s own error status and not the child's.
     - *Under `set -euo pipefail`.* An unguarded command that fails ends a script with that
       command's status. `ditto` at `checks/release-pack.sh:L95` is one example.
     - *Why it is not raised.* Neither case has a measured status outside the five. QC-70 already
       says its reading is "not a check, because no literal scan reads a status a script computes".
       So both stay inside the limit the entry states, and a separate raise on them would be a
       widening with no occurrence. They are named here and not raised.

## Left for the owner

None this run.

## Skipped

None this run.

## Companions opened

None this run.

## Launchers owed

- **docs/adr/ and docs/nfdr.md** — `<CORE>/launchers/skill/launcher.sh product-architecture ka-reader`
