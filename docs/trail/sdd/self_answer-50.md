# Self-answer report — `docs/SDD.md`

This is the record of one unattended run that answered `docs/SDD_open_issues.md` in the CTO's
seat on 2026-10-06. It is for the owner, who reads it to learn what was decided and why, and for
the `product-sdd` run that folds the answers.

## Header

- **Companion:** `docs/SDD_open_issues.md`
- **Document:** `docs/SDD.md` (v42, `Status:` Settled)
- **Decided by:** `<CORE>/../skills/companion/.claude/skills/companion-self-answer/prompts/rich.md` v1.3.1
- **Date:** 2026-10-06
- **Sources re-read:** two sources outside this repository, each opened in this run.
  - libgit2's source, as vendored by `libgit2-sys 0.18.8+1.9.7` in the cargo registry
    (`libgit2-sys-0.18.8+1.9.7/libgit2/src/libgit2/odb.c`), the version `Cargo.lock:L122-L123`
    resolves. `:L697-L700`: libgit2 runs `p_stat` on an alternate's object directory and returns
    with no error where the `stat` fails. `:L789-L791`: an empty line and a line beginning `#`
    are skipped. `:L794-L798`: an entry whose first byte is `.` is joined onto the object
    directory that holds the file, at every depth. `:L800`: every entry is then passed to
    `git_odb__add_default_backends`, so an entry beginning with neither `.` nor `/` is passed on
    as written. These lines were read and not run.
  - Git's documentation, `https://git-scm.com/docs/gitrepository-layout`, the entry for
    `objects/info/alternates`, fetched on 2026-10-06: "this will usually work if you have
    relative paths (relative to the object database, not to the repository!) in your alternates
    file". Checked by one measurement under git 2.54.0, recorded in § 5.3 below.
- **What was read of the document:** `docs/SDD.md` is 7,519 lines and was not read whole. This
  run read the header, *Who decides what* (`:L93-L152`), § 3's `git-reader` and
  `read-only-harness` rows (`:L345`, `:L354`), § 4 C-I3's walk-fixture rule (`:L770-L781`), § 4
  C-D3's *Not covered* passage (`:L1012-L1022`), § 4 C-E4 (`:L1064-L1082`), § 6 S-4 *Reached
  when* (`:L1836-L1885`), § 11 R-16 (`:L3070-L3425`), RN-101 (`:L7083-L7128`), *Open Questions*
  (`:L7378-L7519`), and every line `grep -n -i alternates docs/SDD.md` prints. A sentence
  elsewhere that bears on the alternates file in other words was not seen. Of the SDD's inputs,
  `docs/UXD.md` was read at `:L241` and `docs/CONTENT.md` at `:L58-L66` and `:L329-L338`;
  `docs/PRD.md` and `docs/SRS.md` were searched for `object store` (0 lines each) and not read.
- **The tree the answers were measured on:** `ka-reader@2309ba5`. `git diff --stat 66f428d HEAD`
  lists `docs/SDD_open_issues.md` and `docs/architecture_open_issues.md` and nothing else, so
  outside `docs/` it is the tree at `ka-reader@66f428d`. `cargo test --workspace --locked` printed
  499 passed, 0 failed and 0 ignored on it in this run.

## Items worked

### 5.1 — R-16 and the *Open Questions* item say the alternates check and its case are not built, and both are in the tree

- **Bucket:** 5. Raised from downstream — an item from a seat that did not write the SDD
- **Verdict:** confirmed with addition
- **Why:** The item's "likely fold" is a lean, so it was weighed as a draft. It holds, and it is
  taken with two additions. The item corrects statements that are now false, so it does not
  widen the document.

  **What was checked.** Each claim of the item was opened at its source.
  `check_alternates` is defined at `crates/ka-reader-core/src/git_reader/libgit2.rs:L303` and called
  at `:L114`, `:L449` and `:L475`. `git ls-files checks/fixtures | grep alternates` prints the
  archive and the fixture's `README.md`. `tar -xOf checks/fixtures/alternates-names-outside.git.tar
  .git/objects/info/alternates` prints `../../../elsewhere/objects`. The four SDD passages read
  as the item quotes them (`docs/SDD.md:L3316-L3319`, `:L3392-L3396`, `:L3404-L3409`,
  `:L7478-L7479`).

  **Addition one: six passages, not four.** Two more sentences say the same false thing and the
  item does not list them. *Until the checks are built* ends "For the alternates read the sandbox
  is still the only bound in the bundle, and nothing bounds it in the harness. Until the
  alternates fixture and its case exist that read is a stated limit"
  (`docs/SDD.md:L3414-L3417`). The *Open Questions* item says "of its four cases two are still
  owed" and "this item stays open on the alternates case and the `.gitmodules` case"
  (`:L7448-L7454`). A fold of the four listed passages alone would leave R-16 contradicting
  itself inside one paragraph.

  **Addition two: the passages say what is held, and no more.** R-16's bar for this proof is "one
  case showing that directory is not read" (`docs/SDD.md:L3392-L3393`). The case in the tree,
  `test_the_outside_object_directory_is_never_read_on_the_three_calls`
  (`crates/ka-reader-core/tests/git_state.rs:L1733`), makes a FIFO at the outside directory's
  `info/alternates` and asserts no call opened it (`:L1715-L1726`, `:L1742-L1746`). That is the
  file a load of the directory would open, and it is the same kind of watch the config case
  makes, which R-16 already accepts as its proof (`docs/SDD.md:L3299-L3301`). It is not a watch
  on a `stat` of the directory, and a `stat` is the first thing libgit2 does to an alternate
  (`odb.c:L697`). R-16 states that § 4 C-D1 counts a look outside the grant as a read
  (`docs/SDD.md:L3167-L3169`).
  So the case holds that the file is not opened, and the absence of the `stat` rests on the
  check running before the open (`libgit2.rs:L112-L115`). The answer has R-16 say which is
  which. It also keeps two statements the item already makes: the case runs in-process, and no
  case runs the check on the built bundle.

  **What was not checked.** The case's own comment says it was shown red on the tree before the
  check (`git_state.rs:L1728-L1731`). This run did not build an earlier commit to see it red.

  **What would have tipped it.** If the case had asserted only the condition the calls answer,
  and watched nothing, the proof's bar would not be met and the *Open Questions* item would have
  stayed open on the alternates case.

### 5.2 — The `read-only-harness` row counts eleven fixture folders, and `checks/fixtures/` now holds twelve

- **Bucket:** 5. Raised from downstream — an item from a seat that did not write the SDD
- **Verdict:** confirmed with addition
- **Why:** The item's "likely fold" is a lean, so it was weighed as a draft, and it holds. The
  row's own rule asks for this item: a file landing in `checks/` after the pinned commit "owes
  this row an item" (`docs/SDD.md:L354`). It corrects a count, so it does not widen the document.

  **What was checked.** `ls -d checks/fixtures/*/ | wc -l` prints 12 at `ka-reader@2309ba5`. The
  row names eleven, and the twelfth is `alternates-names-outside`.

  **The addition: the rest of the cell was measured, not assumed.** The item re-measures one
  count, and the row pins its whole enumeration to one commit. `git diff --stat 2d7692c HEAD --
  checks` lists two files, `checks/fixtures/alternates-names-outside.git.tar` and
  `checks/fixtures/alternates-names-outside/README.md`. So the pin can move to the current
  commit with one count and one name changed, and the fold has no second re-measurement to make
  in that cell. The answer also has the row say that the tracked folder holds only a `README.md`
  and that the repository is in the archive, because a reader who lists the folder finds no
  repository in it.

  **One place checked and left alone.** § 11 R-16 says "Two such fixtures are in the tree"
  (`docs/SDD.md:L3081-L3084`). "Such" there is a fixture "whose config carries a member key with
  a path outside the fixture". The alternates fixture carries no such key, so two is still the
  count and that sentence takes no change.

  **What would have tipped it.** A third file under `checks/` in that diff would have made this
  an answer naming every changed part of the cell, and none was there.

### 5.3 — The alternates condition says *outside* for an entry the adapter does not locate, which the config condition does not

- **Bucket:** 5. Raised from downstream — an item from a seat that did not write the SDD
- **Verdict:** answered
- **Why:** The item offers two folds and leans to neither, so it was answered from scratch. The
  first fold is taken: the alternates condition gains the second observation the config
  condition already has, and does not say *outside* for an entry it does not locate.

  **Check 1 — whose.** The edit lands in `docs/SDD.md` § 3, § 6 S-4 and § 11 R-16, and nowhere
  else. It binds what the product tells a reader, under a rule the document already holds: C-E4,
  "Never a cause the tool did not observe" (`docs/SDD.md:L1072`). One owner's call sits near it:
  C-E4 lets the outside sentence stand for three spellings that may lead in, "that is the owner's
  call (`docs/trail/sdd/cycle-15.md` § 5.1) and the price of C-D1" (`:L1077-L1080`). It does not
  reach here, for the reason RN-101 gave for the two config forms: those three cannot be told
  from a true outside without a read outside the grant, and this entry is told apart by the
  scanner with no read (`crates/ka-reader-core/src/git_reader/alternates_scan.rs:L43-L48`). No
  ground the run cannot see was found, so the item is the CTO's, in the owner's seat. The § 6
  clause is the CDO's; it follows from `docs/UXD.md` UX-S3's Error cell (`:L241`) as RN-101's
  did, and the fold names it so. That is one question with a wide consequence, not two seats, so
  the item does not split.

  **Check 2 — the question.** It is the right question and it hides none. The item's own
  reading of the product was opened and holds: `EntryClass::Outside` is "any other entry"
  (`alternates_scan.rs:L12-L14`, `:L47`); the case for `relative/objects` asserts
  `ObjectStoreNamesOutside` on all three calls (`crates/ka-reader-core/tests/git_state.rs:L1781-L1788`);
  the shipped sentence says "outside the folder you opened"
  (`ka-reader-mac/Sources/Surfaces/GitSentences.swift:L58-L62`). One more place says it: the
  model's phrase, "the object store names a location outside the folder"
  (`crates/ka-reader-core/src/folder_model.rs:L235-L236`).

  **Check 3 — the settled record.** R-16's own sentence for this entry rests on where the
  operating system resolves it (`docs/SDD.md:L3369-L3372`), and that is a claim about a process,
  not an observation the adapter makes: `grep -rn 'current_dir\|getcwd\|set_current_dir' crates
  ka-reader-mac/Sources` prints three lines, all in test files. The source behind the sentence was
  re-read: `odb.c:L794-L798` joins only an entry beginning `.`, and `:L800` passes every other
  entry on as written. Git's rule was read at its own page and measured (below): Git reads the
  same entry from the object directory. So the entry has two places it can lead and the adapter
  locates neither, which is the config condition's second observation exactly
  (`docs/SDD.md:L3100-L3103`). Answer 5.1 was decided first and this answer moves nothing in it;
  5.1 says so.

  **Check 4 — the failure paths.** Empty: an empty line is no entry (`odb.c:L790-L791`;
  `alternates_scan.rs:L35`). Absent: the entry is refused whether or not anything is there, and
  the answer says that the "nothing there" pass (`docs/SDD.md:L3374-L3375`) does not reach it.
  Stale: nothing new; the two-reads limit already stated for the alternates file holds
  (`:L3335-L3337`). Concurrent, in the sense of two entries at once: the first refused entry met
  carries its own observation (`libgit2.rs:L292-L297`), and a config refusal comes first
  (`:L113-L114`). Refused: the reader sees a failed Git item whose sentence is true of what was
  observed, and `git status` in a terminal works for that repository, which the answer adds to
  *What the refusal costs a reader*. Two more forms were walked and fall in the class by its
  rule: a leading space and a leading `~` (`alternates_scan.rs:L24-L27`), neither of which
  libgit2 trims or expands (`odb.c:L789-L800`).

  **The measurement.** In a scratch folder under `/private/tmp`, with git 2.54.0 (Apple
  Git-157): `git init a; git init b`; a blob written into `a` with `git hash-object -w --stdin`
  (`ce013625030ba8dba906f756967f9e9ca394464a` for `hello\n`); its `objects/ce` directory copied to
  `b/.git/objects/store/ce`; `git -C b cat-file -t <sha>` printed "could not get object info".
  Then `b/.git/objects/info/alternates` was written as the one line `store`, and the same command
  printed `blob`, run with the shell's working directory at the ka-reader repository, which holds no
  `store`. So Git read `store` from `b/.git/objects/`. libgit2's reading of the same line was not
  run; it is read from `odb.c:L800`.

  **Why not locate the entry.** Considered and not taken. Against the working directory: the
  answer would then depend on what launched the process, and the adapter would be reading
  process state to describe folder state. Against the object directory: Git's place, but libgit2
  reads another, so a pass would let libgit2 `stat` a place the adapter never checked. The
  refusal is the only answer true under both readers.

  **What would have tipped it.** Had `odb.c` joined every relative entry onto the object
  directory, as Git does, the entry would have had one place to lead, the adapter could have
  spelled it, and the first observation would have been the right one. It does not, at 1.9.7.

  **Downstream, not raised.** `docs/adr/0022-…md:L29` and `docs/nfdr.md` name the alternates
  read and do not state the condition's words: `grep -c 'object store' docs/nfdr.md` prints 0.
  Nothing there is false today; the records follow the SDD after it folds, and
  `docs/architecture_open_issues.md` is already open on the same change (§§ 3.1, 3.2).
  `docs/CONTENT.md` is owed nothing: its rules at `:L62` and `:L331-L337` already decide how the
  second sentence is worded, and the sentence is written by the change that builds the
  observation.

## Left for the owner

None this run.

## Skipped

None this run.

## Companions opened

None this run.

## Launchers owed

- **`docs/SDD.md`** — `<CORE>/launchers/skill/launcher.sh product-sdd ka-reader`
