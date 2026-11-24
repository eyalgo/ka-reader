# Self-answer report — `adr/` and `nfdr.md`

## Header

- **Companion:** `docs/architecture_open_issues.md`
- **Document:** `docs/adr/` and `docs/nfdr.md`
- **Decided by:** `<CORE>/../skills/companion/.claude/skills/companion-self-answer/prompts/rich.md` v1.5.0
- **Date:** 2026-11-24
- **Sources re-read:** None outside this repository. The answer rests only on the product's own
  tree. I read `docs/nfdr.md` v102: its header, § 9's suites bullet at `:L3172-L3430`, and its
  other uses of "thirty-two" at `:L5`, `:L746`, `:L3376`, `:L3412` and RN-112. I read
  `checks/gate.sh` at `ka-reader@3463d17` and at `ka-reader@35d5e02`, and `checks/tests/` at both.
  I also read the SDD's RN-179 (`docs/SDD.md:L11342`), the CTO's re-measure of the same merge.
  `git diff --stat 35d5e02 HEAD -- . ':!docs'` prints nothing at `bffd5fe`, so a reading at
  `35d5e02` is also a reading at `main`.

## Items worked

### 3.1 — NFDR § 9's suites bullet, pinned at `3463d17` with thirty-two suites, reads one short

- **Bucket:** 3. Raised from downstream — an item from a seat that did not write these records
- **Verdict:** confirmed with addition
- **Why:** **Re-measure the bullet at `ka-reader@35d5e02`, which gives thirty-three suites under
  `checks/gate.sh` 1.27.0. Keep the thirty-two at `3463d17` as a dated reading. Move every count
  and locator in the bullet that depends on the set.**

  *Seat (check 1).* The edit lands in `nfdr.md` § 9, which is this companion's own document. It
  commits no person and no promise. It only makes a count true again. It is a correction, not a
  widening: the bullet says thirty-two where the tree holds thirty-three. So it is answered in the
  owner's seat, as cycle-93 § 3.1 was.

  *What I was handed (check 2).* The item proposes "re-measured and re-pinned", which I take as the
  draft. Its count holds. `git ls-tree --name-only 3463d17 checks/tests/ | grep -c '\.sh$'` prints
  32, and the same at `35d5e02` prints 33. The new suite is `test_readme_badge.sh`, run by
  *README badge check suite* at `checks/gate.sh:L210`, directly after *README badge check* at
  `:L209`. **But the item measures the line shift from the wrong commit.** It diffs from `66f28cb`.
  The bullet is pinned at `3463d17`, and `66f28cb` came after that pin: it is the merge that put
  *README picture check* (`checks/readme-picture.sh`) into the gate as a step of its own, at gate
  1.25.0. Measured from the bullet's own pin, `git diff -U0 3463d17 35d5e02 -- checks/gate.sh` has
  three hunks:
  - `@@ -1,0 +2,3 @@` adds three version lines, 1.25.0 to 1.27.0;
  - `@@ -197 +200,3 @@` turns old `:L197`, a comment line, into three lines: the comment, one
    line longer, and the *README picture check* step at `:L202`;
  - `@@ -198,0 +204,7 @@` adds the badge comment and the badge steps.

  So old `:L2`–`:L196` read three higher, old `:L198` reads five higher, and every line from old
  `:L199` reads twelve higher. A fold that used the item's "two lines, then seven" would put every
  locator after `:L1` in the wrong place, and the gate's version too. I checked every suite's line
  directly, not by arithmetic. For each `checks/tests/*.sh` at `35d5e02` I looked for an exact
  whole-command `run_step '<name>' '<path>'` line, the bullet's own method, and ran no suite. Each
  of the thirty-three matches exactly one line. The full list is in the companion's slot.

  *What else has to move (check 3).* The bullet counts the same set in three more places, and the
  v102 fold moved each of them when the count last changed (RN-112):
  - "Four of the thirty-two have no `checks/<name>.sh`" becomes "Four of the thirty-three". It is
    the same four: `test_assemble.sh`, `test_secret_scan_planted.sh`, `test_strings_step.sh` and
    `test_vm_refusal.sh`. `test_readme_badge.sh` pairs by name with `checks/readme-badge.sh`, which
    is in the tree, so that pairing joins the bullet's list of pairings.
  - "All thirty-two" becomes "all thirty-three".
  - The `test_assemble.sh` locator `checks/gate.sh:L127` at `ka-reader@3463d17` is the comment
    above *Build KA-Reader.app suite*. That comment is at `:L131` at `35d5e02`.

  The sentence "The tree outside `docs/` is unchanged at `ka-reader@9c2ed61`" moves to the fold's
  own check from `35d5e02`. The other uses of "thirty-two" in the NFDR do not move. `:L746`
  (QC-14) carries its own `3463d17` pin, and `:L5` and RN-112 are history. The answer also agrees
  with the settled SDD: RN-179 counts `ls checks/tests/*.sh | wc -l` 33 at `35d5e02`, the same
  merge, and it names this item as the Principal Architect's without opening anything.

  I considered whether the NFDR is also owed a sentence about the two non-suite steps,
  *README picture check* and *README badge check*. It is not owed one. The bullet lists suites, and
  it names a script's own step only where it explains a pairing, as it does for *Strings check*.
  Adding the two steps would be a widening that no item asks for and no obligation needs. Had an
  obligation named either script as its *verified by*, the answer would have tipped the other way.

  *Failure paths (check 4).* **Stale** is the one that applies. The count is a reading, so it goes
  out of date as soon as `main` gains a suite or a step above these lines. If the tree outside
  `docs/` has moved past `35d5e02` by the time of the fold, the fold measures what it reads, and
  the figures here are a reading, not a target. **Empty**, **absent**, **concurrent** and
  **refused** add nothing, because the bullet describes the tree and runs nothing.

  No obligation changes and no ADR is owed. The item's supporting text names the wrong base commit
  for its diff. I report that here and leave the item's text as it is.

## Left for the owner

None this run.

## Skipped

None this run.

## Companions opened

None this run.

## Launchers owed

- **docs/adr/ and docs/nfdr.md** — `<CORE>/launchers/skill/launcher.sh product-architecture ka-reader`
