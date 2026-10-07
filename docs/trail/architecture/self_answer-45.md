# Self-answer report — `docs/adr/` and `docs/nfdr.md`

## Header

- **Companion:** `docs/architecture_open_issues.md`
- **Document:** `docs/adr/` and `docs/nfdr.md` (one companion for both, by its header's pointer)
- **Decided by:** `<CORE>/../skills/companion/.claude/skills/companion-self-answer/prompts/rich.md` v1.3.1
- **Date:** 2026-10-07
- **Sources re-read:** None. The answer rests on nothing outside this repository. It rests on the
  tree at `nozoki@b12e48c`, read at the lines cited and run below, and on `docs/SDD.md` v47.

**What this run read.** The companion, whole. In `docs/nfdr.md` (v45, 4,936 lines): the header and
its two citing paragraphs (`:L1-L46`), § 1's opening and QC-1 through QC-3 (`:L48-L140`), which
hold QC-2 whole (`:L84-L119`), § 9's suite-count paragraph (`:L1536-L1560`), and § 10's QC-2 row
(`:L1748`). Beyond those, the NFDR was searched for `submodule`, `by hand`, `drops the`,
`joins them`, `ci.yml` and `QC-2`, and every entry line that printed was read. In `docs/SDD.md`
v47: the header's version line, and RN-107 whole. The ADRs were searched for `submodule`,
`by hand` and `` plain` and `repo` ``. The two hits that mention the harness's fixtures are
ADR-0010:L38-L42 and ADR-0008:L23. Both state the harness runs on every CI build, which the new
step makes truer and does not falsify. The other two hits, ADR-0016:L43 and ADR-0020:L62, are about
other matters.

Also read, at `nozoki@b12e48c`:

- `.github/workflows/ci.yml:L55-L85`, and its diff from `076eac2`, which inserts only the three
  lines of `Read-only, submodule` at `:L73-L75`.
- `checks/walk.rs:L280-L296`.
- `crates/nozoki-core/tests/git_state.rs:L715-L845`, which holds the scene, `read_git_over`, the
  normal-root helper and the four cases.
- `main_head`, in the same file.

**Measured.** At intake, `git -C nozoki status --short` printed nothing. HEAD was `c1032b5`.
`git diff --stat b12e48c HEAD -- . ':!docs'` printed nothing, so every code locator holds at HEAD.
`git fetch origin` then `git log -1 origin/main` printed `799c3d6`. `git branch -r --contains
b12e48c` printed nothing, so no hosted run of the new step exists to read.

The runs used a disposable copy: `git archive b12e48c | tar -x` into `/private/tmp/nozoki-qc2.Lv9h`,
never the main checkout. In that copy:

- `cargo test --locked -p nozoki-core --test git_state submodule` printed `test result: ok.
  17 passed; 0 failed`.
- `test_read_git_on_the_restored_submodule_answers_root_with_its_status` passed alone.
- `checks/read-only.sh` printed `unchanged` on `plain`, `repo` and `submodule`.

The workspace-wide `cargo test` was not run here. The item's 23 `ok` lines are the PM's
measurement, not this run's.

## Items worked

### 3.1 — QC-2 says two limits stand beside the `submodule` walk fixture until a change closes them, and both are closed

- **Bucket:** 3. Raised from downstream — an item from a seat that did not write these records
- **Verdict:** confirmed with addition
- **Why:** **The verdict.** The tail is restated with both limits closed at `nozoki@b12e48c`. It
  names the CI step and the case, keeps the old words in a dated note, and makes four additions.
  This document owns the call, so the answer is the Principal Architect's to give in the owner's
  seat. The change lands in `docs/nfdr.md` QC-2 and nowhere else. It commits nothing to a person or
  an outside party.

  **The item's facts hold.** The item is a correction, not a widening. QC-2's tail
  (`docs/nfdr.md:L107-L111`) makes two claims that are false at `nozoki@b12e48c`. It says "no
  case asserts what `read_git` answers on it", and it says CI "runs the walk on `plain` and `repo`
  alone". So § *A widening item waits until it occurs* does not apply. The item is in bucket 3
  with no confirm slot, but it carries a lean: "the likely fold is the tail restated…". This run
  read that lean as a draft and weighed it.

  Each fact the item states was re-read at the source:

  - `ci.yml:L73-L74` is `Read-only, submodule`, running
    `checks/read-only.sh checks/fixtures/submodule`.
  - The case at `git_state.rs:L787` asserts HEAD on `main`, `RepositoryState::Normal`, staged
    empty, and changed = {`README.md` untracked, `submodule` modified`}. It does this through
    `changed_of_a_normal_root_on_main` (`:L742-L751`) and `main_head`.
  - `:L771`, `:L802`, `:L815` and `:L828` are the scene and the three layouts, as the item says.
  - This run's own measurement agrees with the item's (see *Measured* above).

  **Addition 1: the case is also a QC-2 proof.** The item treats the case only as asserting the
  answer. But `read_git_over` (`git_state.rs:L730-L738`) snapshots the whole scene before the call
  and asserts it is unchanged after. So the case is a layer-2 no-write proof on the restored
  `submodule`, which is QC-2's own obligation. The fold should say so. Otherwise a reader takes
  the case as being about the Git view's answer and misses that it holds the entry it is cited in.

  **Addition 2: the CI half is bounded (stale).** The step is in the workflow. Its result on the
  hosted runner is unread, because `b12e48c` is on no remote branch and `origin/main` is at
  `nozoki@799c3d6` (measured above). The tail must say "in the workflow", not "passing on every
  build". SDD RN-107 bounds the same half the same way, so the two documents agree.

  **Addition 3: one sentence stays.** "The walk drops the Git answer" (`checks/walk.rs:L288-L292`)
  is still true, and it is the reason the case holds the answer rather than the walk. It stays in
  the tail as that reason. Only the "so no case asserts" consequence goes.

  **Addition 4: the trace moves (upstream moved).** QC-2's trace reads "SDD § 4 C-I3 and § 6 S-4,
  command half, as they read at v42". The SDD folded its own clause at v47 (SDD RN-107). The trace
  moves to § 6 S-4 as it reads at v47, and the v42 reading goes into the dated note.

  **Checked, and nothing moves (check 3).**

  - § 10's QC-2 row (`docs/nfdr.md:L1748`) reads "on every walk fixture", which the new step now
    makes literal. Its `--test git_state` gloss names the three outside scenes. That gloss is
    incomplete but not false, because the row names the target and the target already runs the
    case. I was close to adding the restored `submodule` to the gloss. What tipped it: the row is
    an index of commands, and QC-2's body is the home of what each command proves.
  - § 9's suite count (`:L1540-L1548`) is pinned at `nozoki@b158052`. Its own sentence makes "a
    step inserted above these" a re-measurement and not a contradiction. The new step runs a
    script, not a suite, so the count of eight stands.
  - Every unpinned `ci.yml` locator in the NFDR sits above `:L73`: `:L18`, `:L26`, `:L41`, `:L51`,
    `:L54`. None of them moved.
  - The "Not covered" export-set clause does not touch the fixture set.
  - No ADR names the two limits.

  **Failure paths (check 4).**

  - *Absent*: a missing fixture or archive fails the case, because `copy_fixture` and
    `unpack_fixture_archive` panic. The gap then reads red, not silently covered.
  - *Refused*: the layout where the walk refuses is held by `:L828`, which returns a `Failed`
    outside item.
  - *Stale*: the line locators are pinned at `nozoki@b12e48c`, as the SDD's are. A later insertion
    above them is a re-measurement.
  - *Concurrent*: QC-2's harness runs one walk per fixture in sequence, so there is no concurrent
    path to state.
  - *Empty*: none applies, because the fixture's content is fixed.

## Left for the owner

None this run.

## Skipped

None this run.

## Companions opened

None this run.

## Launchers owed

- **`docs/adr/` and `docs/nfdr.md`** — `<CORE>/launchers/skill/launcher.sh product-architecture nozoki`
