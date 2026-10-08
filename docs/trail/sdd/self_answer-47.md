# Self-answer report — `docs/SDD.md`

## Header

- **Companion:** `docs/SDD_open_issues.md`
- **Document:** `docs/SDD.md` (v39, Draft)
- **Decided by:** `<CORE>/../skills/companion/.claude/skills/companion-self-answer/prompts/rich.md` v1.3.1
- **Date:** 2026-10-04
- **Sources re-read:** libgit2's source, as vendored by `libgit2-sys 0.18.8+1.9.7` in the cargo
  registry (`libgit2-sys-0.18.8+1.9.7/libgit2/src/libgit2/`), the version `Cargo.lock:L122-L123`
  resolves. Each line below was opened in this run.
  - `odb.c:L25`, `:L27`: the alternates file is `info/alternates`, and the depth bound is five.
  - `odb.c:L697-L700`: an alternate whose directory cannot be `stat`ed is skipped with no error.
    That `stat` is made on the alternate's path whether or not it lies inside the folder.
  - `odb.c:L758`: every object directory added has its own alternates file loaded in turn.
  - `odb.c:L761-L808`: the alternates file is read whole. Lines are split on `\r` and `\n`. An
    empty line and a line beginning `#` are skipped (`:L790-L791`). An entry beginning `.` is
    joined to the objects directory (`:L794-L798`). Any other entry is passed on as written
    (`:L800`). No containment check is made.
  - `repository.c:L1485-L1497`: the objects directory is the repository's own unless the
    repository was opened from the environment. `:L1499-L1533`: the
    `GIT_ALTERNATE_OBJECT_DIRECTORIES` variable is read only in that case.
  - `repository.c:L1535-L1573`: the object store is opened on first use, not during the open.
    `object.c:L211`: an object lookup is such a use. `status.c:L289`: the status read looks up
    the `HEAD` tree.

  None of it was run. Each is a reading of the source.

**What this run read, and what it did not.** The companion was read whole. `docs/SDD.md` is 6,762
lines and was not read whole. The run read its header, § 3 whole (`:L320-L521`), § 4 C-I6 to
C-E10 (`:L940-L1101`), § 6 S-4's observable half at `:L1812-L1834`, § 11 whole (`:L2848-L3080`),
RN-99 (`:L6543-L6646`) and *Open Questions* whole (`:L6648-L6762`). It searched the rest for
`alternates` and `outside the folder` and read what that printed. A sentence elsewhere that bears
on this item in other words was not seen. `docs/trail/sdd/self_answer-46.md` was read whole.
`docs/nfdr.md` was read at `:L1-L25` and `:L436-L470`, `docs/SRS.md` at `:L200-L208`, and
`docs/CONTENT.md` at `:L326-L344`. The adapter was read at
`crates/ka-reader-core/src/git_reader/libgit2.rs:L76-L240`, and the condition type at
`crates/ka-reader-core/src/git_reader.rs:L180-L212`, both at `ka-reader@8892311`. The PRD, the UXD and
the FDR were not opened. No test was run and no fixture was built.

## Items worked

### 2.1 — § 11 R-16 names `objects/info/alternates` as a third way Git's layout points outside the folder, uncovered until a check holds it

- **Bucket:** 2. Choices to confirm — a best-effort answer was drafted; confirm or override
- **Verdict:** confirmed with addition
- **Why:** The draft is taken. The limit stays named in § 11 R-16 and § 4 C-D3, and the adapter
  refuses a repository whose alternates file names a location outside the folder. Five things
  are added, and the first replaces one clause of the draft.

  **Seat.** The item carries `Seat: cto`. The edit lands in `docs/SDD.md`'s `git-reader` row,
  § 4 C-D3 and § 11 R-16, and it binds the port's contract. It is the CTO's.

  **Why the refusal and not the named limit alone.** The companion offers a narrower override:
  keep the limit and build nothing. It was not taken, for three reasons. § 4 C-D1 counts a
  `stat` outside the grant as a read (`docs/SDD.md:L963-L965`), and libgit2 makes one on every
  alternate (`odb.c:L697`). The config-named path is the same class and was answered with a
  refusal (`docs/trail/sdd/cycle-34.md` §§ 5.1, 5.3), so leaving this one open would hold two
  outside reads to two different bars. And the limit alone leaves a worse state for the reader
  in the bundle. Where the sandbox denies the `stat`, libgit2 skips the alternate without an
  error (`odb.c:L698-L700`), so a repository whose objects live in that alternate would then
  fail its status read with nothing that names the cause. That sequence is read from the source
  and was not run.

  **What the refusal costs a reader.** A clone made with `git clone --reference` or `--shared`
  from a repository outside the folder keeps its objects in an outside alternate. That
  repository shows a failed Git item with the cause, where `git status` in a terminal works.
  `docs/SRS.md` FR-12 (`:L204-L207`) asks the Git view to present a repository's state. The
  refusal is read as consistent with it on the precedent of § 11 R-3 and the config refusal,
  both of which already show a failed item for a repository the grant cannot cover. This is the
  place the run was closest to a different verdict. An upstream sentence saying such a clone
  must show its status would make this the CPO's call, and no document read in this run holds
  one.

  **Addition 1, the condition.** The draft's "with the condition above" does not hold. That
  condition reports that the repository's config names a path, and it carries a key
  (`docs/SDD.md:L3010-L3015`). An alternates file is not config and has no key, so the message
  would name a cause the tool did not observe, against `docs/SDD.md` § 4 C-E4. The same ground
  gave the config refusal a condition of its own (`docs/trail/sdd/self_answer-46.md`, 5.1). The
  cost is one more condition crossing SM-2, SM-4 and SM-8 and one more passage in § 6 S-4. The
  words are the Content Editor's, under `docs/CONTENT.md`'s rule that anything outside the
  folder is said one way (`:L331-L337`).

  **Addition 2, where it runs and what it reads.** The object store is opened on first use, and
  the status read is what reaches it. The check is still placed with the config check, on the
  probe and before both opens, so that one check runs in one place. Refusing early breaks no
  promise, and § 6 S-4 already draws a refusal alike "whether the refusal met the root finding
  or a later read" (`docs/SDD.md:L1830-L1831`). The check follows inside alternates because
  libgit2 does (`odb.c:L758`, `:L800`), which is the reason the config check follows inside
  includes. The walk to the file passes `objects`, so a linked `objects` directory that leads
  out is refused by the walk's existing rule. That covers half of what the item's rationale
  left unchecked. The adapter today locates the Git directory and the common directory and
  nothing below them (`libgit2.rs:L102-L125`).

  **Addition 3, the spellings.** The companion says an entry not beginning `.` "is taken as
  written". For an absolute entry that is complete. For a relative entry that does not begin
  `.` it means the operating system resolves it against the process's working directory, which
  is not the folder. The answer refuses such an entry as outside.

  **Addition 4, the failure paths.** Empty: no file, or only blank lines and comments, passes.
  Absent: an inside entry with nothing there passes, as libgit2 skips it; an unreadable
  alternates file answers the existing unreadable condition. Concurrent and stale: the check
  and libgit2's read are two reads, and a file rewritten between them is followed unchecked.
  R-16 already names that case for the config (`docs/SDD.md:L3058-L3060`), and the answer asks
  it to name this one. Refused: in the bundle the sandbox still refuses the read.

  **Addition 5, submodules and the proof.** Each submodule repository has an object store of
  its own, so its verification gains this check. Whether the status read opens a submodule's
  object store was not read in the source; the check is asked for anyway, because it reads only
  inside the folder. The proof stays one fixture and one case, owed before `see-git-status` is
  reached.

  **Not covered, and named in the answer.** A link elsewhere inside the Git directory that
  leads out, such as a linked `HEAD`, `index` or `refs`. This run did not read how libgit2
  opens those files. The answer asks R-16's *Not covered* to say it was not checked.

  **The item's supporting text.** It is accurate against the source. Its line range
  `odb.c:L761-L803` ends five lines before the function does (`:L808`), which changes nothing.

  **The environment path.** `GIT_ALTERNATE_OBJECT_DIRECTORIES` is a fourth way to name an
  object directory. The adapter opens with `NO_SEARCH` and never from the environment
  (`libgit2.rs:L81`, `:L501-L502`), so libgit2 does not read it (`repository.c:L1507-L1508`). No
  change is asked for.

## Left for the owner

None this run.

## Skipped

- **`docs/nfdr.md` QC-15** — not raised on the NFDR. Its list of the reads `git-reader` makes
  outside libgit2 (`docs/nfdr.md:L455-L461`) names no config file and no alternates file. The
  NFDR's header says it was last re-derived on `docs/SDD.md` v33, and the SDD is at v39 and
  Draft. Re-deriving it from a settled SDD is the Principal Architect's.
- **A link inside the Git directory that leads out** — not raised as an item of its own. It is
  named in answer 2.1 as not checked, which is what this run can state about it.

## Companions opened

None this run.

## Launchers owed

- **`docs/SDD.md`** — `<CORE>/launchers/skill/launcher.sh product-sdd ka-reader`
