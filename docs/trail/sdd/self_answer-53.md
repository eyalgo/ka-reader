# Self-answer report — `docs/SDD.md`

This is the record of one unattended run that answered `docs/SDD_open_issues.md` in the CTO's
seat on 2026-10-07. It is for the owner, who reads it to learn what was decided and why, and for
the `product-sdd` run that folds the answers.

## Header

- **Companion:** `docs/SDD_open_issues.md`
- **Document:** `docs/SDD.md` (v45, `Status:` Settled)
- **Decided by:** `<CORE>/../skills/companion/.claude/skills/companion-self-answer/prompts/rich.md` v1.3.1
- **Date:** 2026-10-07
- **Sources re-read:** libgit2's vendored source, outside this repository, at
  `~/.cargo/registry/src/*/libgit2-sys-0.18.8+1.9.7/libgit2/src/`. Answer 5.3 rests on why a FIFO
  at `.git/HEAD` sees no opener: `libgit2/repository.c:L287` returns before any read when
  `git_fs_path_contains_file(repository_path, GIT_HEAD_FILE)` is false; `util/fs_path.c:L799-L802`
  tests that with `git_fs_path_isfile`, and `:L603-L611` returns `S_ISREG(st.st_mode) != 0`, which
  is false for a FIFO. Each said what `measurement.md` says it says. The three lines R-16 keeps "as
  read and not run" were also opened: `libgit2/diff_generate.c:L668` and `:L1157` are
  `git_submodule_lookup(…, entry.path)` / `(…, nitem->path)` calls, `:L771` is
  `git_submodule__lookup_with_cache(`, and `libgit2/submodule.c:L1270` is the
  `git_submodule_open_bare` call under the comment "calling submodule open grabs the HEAD OID if
  possible". They are the calls R-16 names; what they do at run time is the measurement's, not
  theirs. No other answer rests on a source outside the repository.
- **What was read of the document:** `docs/SDD.md` is 7,826 lines and was not read whole. This
  run read the header (`:L1-L14`), § 3's `git-reader`, `core-bridge` and `read-only-harness` rows
  (`:L348`, `:L354`, `:L357`), § 4 C-D3's *Not covered* passage (`:L1010-L1028`), § 6 S-4 *Reached
  when*, observable half (`:L1840-L1930`) and *Rests on* (`:L1995-L2003`), § 11 R-16 whole
  (`:L3094-L3610`), *Open Questions*, the config-named-path item (`:L7887-L7952`), RN-102
  (`:L7421-L7500`) and the heads of RN-103, RN-104 and RN-105, and every line
  `grep -n -i 'known defect\|only includes follow\|twelve fixture\|thirteen fixture\|gitmodules'`
  and `grep -n 'only bound'` print. Of the SDD's inputs, none was opened: the four items are about
  what the tree holds and what the document says of it, and no answer moves a sentence the PRD,
  the SRS or the UXD settled — the one CDO clause near the fold (§ 6 S-4's three-case passage) was
  settled at v42 (RN-102, (5)) and does not move. Downstream, `docs/architecture_open_issues.md`
  was read whole, `docs/adr/0022-…md` at `:L33-L62`, and `docs/nfdr.md` was searched for
  `looked up`, `no gitlink`, `gitlinks` (0 lines) and `cannot read answers` / `unreadable Git
  directory` (`:L4732`, a dated record of ADR-0022's line). `docs/CONTENT.md` was searched for
  `gitmodules` and `submodule` (`:L436`, `:L909`, neither a Git failure sentence).
- **The tree the answers were measured on:** `ka-reader@ccbe02a`, the HEAD at intake, with
  `git status --short` printing nothing. `git diff --stat 772c63b ccbe02a -- . ':!docs'` prints
  nothing, so outside `docs/` it is the tree at `ka-reader@772c63b`, the merge the items cite;
  `git merge-base --is-ancestor 772c63b ccbe02a` exits 0, and `799c3d6` precedes `772c63b`. The
  suites ran in a disposable copy (`git archive ccbe02a | tar -x -C /tmp/ka-reader-scratch.*`), never
  in the main checkout: `cargo test --workspace --locked` printed 558 passed, 0 failed, 0 ignored,
  summed over its 23 `test result` lines; `swift test --package-path ka-reader-mac` printed "Executed
  146 tests, with 0 failures"; `checks/read-only.sh <folder>` printed `unchanged` for each of the
  thirteen folders under `checks/fixtures/` (the script takes one folder per call). The claim that
  R-16's fourth case fails against the crates at `ka-reader@799c3d6` was not re-run: the case names
  `GitReadCondition::SubmoduleElsewhere`, which does not exist at that commit, so it does not
  compile there, and the claim is read from the item and the station's own *Reached when* 2.

## Items worked

### 5.1 — § 3, § 4 C-D3, § 6 S-4, § 11 R-16 and *Open Questions* call the `.gitmodules` section-path and submodule-map refusals a known defect, and all three refusals are built

- **Bucket:** 5. Raised from downstream — an item from a seat that did not write the SDD
- **Verdict:** confirmed with addition
- **Why:** The item's "likely fold" is a lean, so it was weighed as a draft. It holds, and it is
  taken with three additions. The item corrects statements that are now false — a build-state, a
  count, an owed case — so it does not widen the document, and § *A widening item waits until it
  occurs* does not apply.

  **Check 1 — whose.** The edit lands in `docs/SDD.md` § 3, § 4 C-D3, § 6 S-4, § 11 R-16 and
  *Open Questions*, and nowhere else; the item carries `Seat: cto`, and this run is the CTO's. It
  binds no person, party or risk: every refusal built before is refused now and none is loosened,
  which is the station's own guardrail ("No refusal outside this station's three, and no check
  loosened"). The one clause near the fold that is another seat's — the CDO's three-case passage in
  § 6 S-4's observable half (`docs/SDD.md:L1909-L1922`) — does not move: RN-102 (5) settled it at
  v42 from `docs/UXD.md` UX-S3 Error and `docs/CONTENT.md:L62`, and what changes is the build-state
  sentence after it ("At `ka-reader@5f3e895` the include-key refusal is built and the other two are
  not …", `:L1923-L1925`), the CTO's statement of what the tree holds — the same shape RN-104 and
  RN-105 took. No ground this run cannot see was found. Mine, in the owner's seat.

  **Check 2 — the draft, and what was opened.** Every claim of the item was opened at its source
  and reads as the item states it. The passages: § 3's `git-reader` row, "At `ka-reader@5f3e895` the
  check is built for the include keys alone …" (`:L348`); the `read-only-harness` row's "twelve
  fixture folders" (`:L357`); § 4 C-D3 "Two of its refusals are not built" (`:L1019-L1020`); § 6
  S-4 (`:L1923-L1925`); § 11 R-16 *A known defect, until a change lands* (`:L3346-L3352`) and *The
  proof*'s "A fourth case is owed" (`:L3400-L3404`); *Open Questions* "stays open on the
  `.gitmodules` case alone" (`:L7901-L7904`). The build: `status()` alone calls
  `verify_submodules` (`crates/ka-reader-core/src/git_reader/libgit2.rs:L100-L104`; `state()` at
  `:L96-L98` does not), which reads the level's `.gitmodules` for its sections under
  `ConfigPurpose::Submodules` (`:L270-L275`, `:L558-L571`); `check_section_value` answers
  `ConfigNotLocated` for a value beginning `/` (`:L344-L346`), `ConfigNamesOutside` for one spelled
  outside (`:L347-L350`) and `SubmoduleElsewhere` for a looked-up name whose value spells to
  another location (`:L351-L357`); the variant is `GitReadCondition::SubmoduleElsewhere(SubmoduleNamedPath)`
  (`crates/ka-reader-core/src/git_reader.rs:L235-L237`); the wire value is `submodule_elsewhere`
  with a `name` member (`crates/ka-reader-bridge/src/session.rs:L486-L495`, `:L585`, asserted at
  `:L1617`); the log phrase (`crates/ka-reader-core/src/folder_model.rs:L259-L260`); the sentence
  (`ka-reader-mac/Sources/Surfaces/GitSentences.swift:L78-L82`). The fixture
  `checks/fixtures/gitmodules-names-outside` holds `.gitmodules`, `README.md` and `link`, with its
  `.git.tar` beside it; the case at `git_state.rs:L2680` watches a FIFO at the outside `x`'s
  `.git/config` through the three calls and asserts no opener, `probe` → `Root`, `state` ok and
  `status` → `ConfigNamesOutside("submodule.sub.path", "link/x")`. `ls checks/fixtures` lists
  thirteen folders and nine archives. The suites ran as the Header records.

  **Addition one: name the cases.** The item names one case; the document's precedent is that a
  passage stating a property as built names every case that holds it (RN-104's and RN-105's
  *Built, and the cases that hold it*). They are in the tree, and their names and the cited lines
  were read; their bodies past those lines were not, except L2653, L2680, L2748 and L3017. Core,
  `crates/ka-reader-core/tests/git_state.rs`:
  `test_section_path_outside_the_folder_is_refused_config_names_outside` (L2620),
  `test_section_path_beginning_slash_is_refused_config_not_located` (L2638),
  `test_submodule_section_for_a_looked_up_name_with_another_path_is_refused` (L2653, at both
  levels), `test_section_leading_through_a_link_to_an_outside_x_opens_nothing_outside` (L2680),
  `test_gitmodules_with_no_gitlink_in_the_index_is_still_refused` (L2710),
  `test_tilde_path_on_a_section_that_is_no_looked_up_name_answers_the_lists` (L2737),
  `test_name_only_section_naming_a_path_outside_is_refused_with_the_section_word_as_key` (L2748),
  `test_path_nothing_here_is_refused_submodule_elsewhere` (L2761),
  `test_uninitialised_gitlink_with_another_path_is_refused_submodule_elsewhere` (L2776),
  `test_two_refused_sections_give_one_condition_with_one_sections_own_values` (L2817),
  `test_refused_include_and_refused_section_give_one_answer_with_one_values_own_values` (L2836),
  `test_a_looked_up_names_section_meets_the_first_refusal_in_cp723s_order` (L2857),
  `test_a_section_in_an_included_file_is_decided_and_spelled_from_the_levels_working_tree` (L2893),
  `test_a_verified_submodules_section_is_spelled_from_its_own_working_tree` (L2939),
  `test_state_ok_and_status_submodule_elsewhere_is_a_failed_item` (L3035). Unit,
  `crates/ka-reader-core/tests/unit/libgit2.rs`: the four `test_section_path_…` cases at L499, L521,
  L541, L555. Log: `test_failed_git_item_with_the_gitmodules_conditions_logs_one_warn_each_without_a_name_or_path`
  (`crates/ka-reader-core/tests/git_state_log.rs:L388`). Shell:
  `BridgePayloadGitTests.swift:L255`, `:L264`; `LaunchFlowGitTests.swift:L171`, `:L194`;
  `GitSentencesTests.swift:L401`, `:L423`; `GitViewTests.swift:L283`.

  **Addition two: the sentences that state the defect in other words.** The item lists the
  passages headed or worded "known defect". Three more sentences say the same thing without those
  words, and the fold that leaves them leaves the document contradicting itself: § 11 R-16
  *Until the checks are built*, "The sandbox is now the only bound on one read: the repository
  the submodule map opens outside the folder" (`docs/SDD.md:L3599-L3601`), and the paragraph's
  closing sentence, "The `.gitmodules` check is a third check. It is built for the file's include
  keys and not for a section's path, and the refusal on the submodule map is not built"
  (`:L3607-L3610`); and *Open Questions*, "the sandbox stays the only bound on a repository the
  submodule map opens outside the folder" (`:L7931-L7932`). At `ccbe02a` the adapter refuses the
  status read before libgit2 opens that repository (`libgit2.rs:L351-L357`, run at `:L102` before
  `status_lists` at `:L103`), so in the harness that read is a held property, and the sandbox is
  no longer the only bound on any read R-16 names. Each sentence keeps its old words in a dated
  note, as the document does for every changed claim. The previous run's report said "A sentence
  elsewhere that states the … defect in other words was not seen" of the alternates fold; this
  run grepped for `only bound` and found these.

  **Addition three: the harness row's re-measurement is exact.** The row pins its enumeration at
  `ka-reader@5331b85` and says a later file in `checks/` "owes this row an item" (`:L357`). This is
  that item. `git diff --stat 5331b85 ccbe02a -- checks` lists `gitmodules-names-outside.git.tar`,
  `gitmodules-names-outside/.gitmodules`, `/README.md` and `/link`, four files and nothing else,
  so the cell re-pins at the fold's commit with thirteen folders, names the fourth fixture as §
  11 R-16's with what its tracked folder holds (a `.gitmodules`, a `README.md` and a link; the
  repository is in the archive) and the suite that unpacks it (`git_state.rs:L2683-L2686`), and
  moves nothing else — the shape RN-103 gave the alternates fixture.

  **The fold stops at the three refusals.** The include-key sentences and their three cases
  stand (`git_state.rs:L1795`, `:L1806`, `:L1834`, now at those lines rather than the L1533,
  L1544, L1572 the document cites at `ka-reader@5f3e895`; the fold re-pins them as RN-105 re-pinned
  the alternates locators, with a dated note). *The sixth member*'s `~/` sentence stands, held by
  L2737. *Measured.* stands as a dated record of the measurement at `ka-reader@bd382c8`. The config
  and alternates *Built* paragraphs stand as pinned at `ka-reader@fadff58` and `ka-reader@6d3ef53`. The
  config condition's *Built* paragraph's last sentence — "This paragraph holds for the five keys
  named first: the sixth key's not-located form … is not built" (`:L3199-L3202`) — is a fourth
  sentence in other words, and it moves with the item: the sixth key's not-located form is built
  (L2638).

  **Check 3 — the settled record.** § 3's `git-reader` row, § 6 S-4's three cases and R-16 *The
  condition* already state the refusals and what each carries, exactly as built — the station was
  cut from them — so no settled sentence moves except the build-state ones and the locators named
  above. Downstream: `docs/nfdr.md` QC-6 and QC-35 and ADR-0022's *Decision* are on
  `docs/architecture_open_issues.md` §§ 3.1 and 3.2, raised by the PM at `ka-reader@ccbe02a`, so no
  companion is owed elsewhere by this item. `docs/CONTENT.md` carries no catalogue of the Git
  failure sentences, so "The message's words are `docs/CONTENT.md`'s" reads as the rule at
  `:L62`, as RN-102 read it; the words came through the change's content step. Answers 5.2, 5.3
  and 5.4 were decided after this one; closing the *Open Questions* item "on its last case" also
  needs the two things the item says the change settles (`:L7916-L7918`), and 5.2 and 5.3 settle
  them, so the three answers are consistent and nothing here was changed for them.

  **Check 4 — the failure paths.** Empty: a `.gitmodules` with no section, or one holding only
  include keys that spell inside, answers the lists as before. Absent: no `.gitmodules` is
  skipped at `libgit2.rs:L244` and nothing is refused; the commit the fold pins must hold the
  build, and `772c63b` is an ancestor of HEAD with the tree outside `docs/` unmoved since. Stale:
  the fold pins at its own commit, and every locator in this answer was measured at `ccbe02a`.
  Concurrent: a `.gitmodules` rewritten between the check and libgit2's read is followed
  unchecked — *Not covered*'s first sentence (`:L3353-L3355`) stays true and the fold keeps it;
  two refused sections in one file give one condition with one section's own values (L2817), and
  a refused include beside a refused section give one answer (L2836), which R-16's "first refused
  entry" rule already states for the other two checks. Refused: the reader sees a failed Git item
  whose sentence states what was observed and nothing else (`GitViewTests.swift:L283`, "draws one
  message and nothing else"), the tree and the panel stand (§ 4 C-I1), and `git status` in a
  terminal works for that repository, which R-16 *What the refusals cost a reader* already says.

  **What would have tipped it.** Had the check run on `state()` as well as `status()`, the
  station's guardrail ("only `status()` meets the new refusals") would be broken and the fold
  would have had to say so rather than state the build; `state()` calls `open_verified` alone
  (`libgit2.rs:L96-L98`). And had the shell drawn the config sentence for `submodule_elsewhere`,
  the third refusal would reach the reader as a config refusal; it has its own case in
  `BridgePayload.swift` and its own sentence at `GitSentences.swift:L78-L82`.

### 5.2 — § 3 and § 11 R-16 say an unreadable `.gitmodules` answers the unreadable-Git-directory condition, and it answers a condition of its own

- **Bucket:** 5. Raised from downstream — an item from a seat that did not write the SDD
- **Verdict:** confirmed with addition
- **Why:** The item's "likely fold" is a lean, so it was weighed as a draft, and it holds; one
  addition names the cases. The sentence being corrected assigned a design choice to a change
  that has since made it, so the item is a correction and not a widening.

  **Check 1 — whose.** The edit is in `docs/SDD.md` § 3 (the `git-reader` row, `:L348`) and §
  11 R-16 *Not covered* (`:L3353-L3363`); the item carries `Seat: cto`; the choice it records
  was the building change's, inside the CTO's columns, and binds nothing outside the document.
  The sentence the shell draws is published text, whose words are the content step's under
  `docs/CONTENT.md`'s rule — not this document's to write, and the fold quotes it. Mine, in the
  owner's seat.

  **Check 2 — the draft, and what was opened.** `unreadable_config_file` answers
  `GitmodulesUnreadable` for `ConfigPurpose::Submodules(_)` at depth 0 and
  `GitDirectoryUnreadable` for every other file of either walk (`libgit2.rs:L280-L290`); the
  walk reaches it for any read error but `NotFound`, which is skipped (`:L242-L245`), so "for any
  reason but its absence" holds, and the four reasons the item lists are the four kinds the case
  runs — `mode`, `link`, `directory`, `oversize` — at both levels (`git_state.rs:L2950-L2994`),
  each asserting `probe` → `Root`, `state` ok, `status` → `GitmodulesUnreadable` and the scene
  unchanged. The variant and its doc comment (`git_reader.rs:L238-L241`), the wire arm
  (`session.rs:L585-L587`) and its asserted string (`:L1619-L1622`), the phrase
  (`folder_model.rs:L262-L263`), and the sentence (`GitSentences.swift:L30-L33`) each say what the
  item says; `grep -c 'Git directory'` over the sentence's lines prints `0`, which is § 4 C-E4's
  "never a cause the tool did not observe" — the ground R-16 bound the choice by. The item's
  cross-reference holds: `docs/architecture_open_issues.md` § 3.2 is on disk at `ccbe02a`, on
  ADR-0022's *Decision* line (`docs/adr/0022-…md:L58-L60`, read).

  **Addition: the cases.** `test_unreadable_gitmodules_answers_gitmodules_unreadable`
  (`git_state.rs:L2950`); `test_unreadable_included_file_keeps_git_directory_unreadable`
  (`:L2990`), which holds the other half of the item's claim; the model case
  `test_state_ok_and_status_gitmodules_unreadable_is_a_failed_item` (`:L3053`); the log case at
  `git_state_log.rs:L388`; the shell's `test_gitmodulesUnreadableDecodesWithNoOtherMember`
  (`BridgePayloadGitTests.swift:L288`),
  `test_gitmodulesUnreadableMessageIsChangeTextsAndIsNotTheGitDirectorySentence`
  (`GitSentencesTests.swift:L445`) and
  `test_theGitmodulesUnreadableFailureDrawsOneMessageAndNothingElse` (`GitViewTests.swift:L299`).
  The companion's answer was first written citing the included-file case at `:L2996` and corrected
  to `:L2990` in this run before the commit.

  **Check 3 — the settled record.** § 6 S-4 needs no new passage: its observable half already
  says "Git state the tool could not read — a lock, an unreadable file — shows on that item what
  was observed, and the rest of the view stands" (`docs/SDD.md:L1851-L1853`), and the new sentence
  is what was observed, so the CDO's clause is met better than before and nothing of theirs moves.
  ADR-0022's *Decision* says "a file the check cannot read answers the condition for an unreadable
  Git directory" (`:L58-L60`), and the build departs from it for `.gitmodules` itself; that is the
  Principal Architect's record and is raised on their companion (§ 3.2), so this fold states the
  exception as the SDD's own and cites no ADR change. `docs/nfdr.md:L4732` repeats the ADR line as
  a dated record and states nothing of its own. No external source was relied on. Answer 5.1 was
  decided first; this answer rests on the same tree and moves nothing in it.

  **Check 4 — the failure paths.** Empty: an empty or comment-only `.gitmodules` reads and scans
  to nothing, and nothing is refused. Absent: skipped at `:L244`, as above — the one case the
  item's "for any reason but its absence" carves out, and the test's `remove_file` before each
  kind is what makes the four kinds the whole set. Stale: the sentence is true as pinned, and the
  fold pins at its own commit. Concurrent: a `.gitmodules` made unreadable between the check and
  libgit2's read is the rewrite case *Not covered* already names. Refused: the `mode` kind is the
  read refused by permission, and the scene's mode is restored after the assertion, so the walk
  fixture is unchanged (`checks/read-only.sh` is not what holds that; the case's own
  `snapshot()` is).

  **What would have tipped it.** Had the shell folded `gitmodules_unreadable` into
  `.gitDirectoryUnreadable`, the core's condition would reach the reader as the Git-directory
  sentence and the item's heading would be half true; the shell decodes it as its own case
  (`BridgePayloadGitTests.swift:L288`) and draws its own sentence (`GitSentencesTests.swift:L445`
  asserts it "is not the Git directory sentence").

### 5.3 — § 11 R-16 says the set of paths the status read looks up is measured by the change that builds the refusal, and it has been measured: the index's gitlinks, and nothing more

- **Bucket:** 5. Raised from downstream — an item from a seat that did not write the SDD
- **Verdict:** confirmed with addition
- **Why:** The item's "likely fold" is a lean, so it was weighed as a draft. It holds, and it is
  taken with three additions. The paragraph it corrects says a measurement is owed and states a
  reading of three source lines that the measurement disagrees with; replacing that with the
  measured finding is a correction.

  **Check 1 — whose.** The edit is in `docs/SDD.md` § 11 R-16 *Which paths the status read looks
  up* (`:L3332-L3337`) and the *Open Questions* item's sentence naming the measurement as owed
  (`:L7916-L7918`); the item carries `Seat: cto`; a measurement of a library's behaviour is a
  technical fact inside the CTO's columns and binds nothing outside the document. Mine, in the
  owner's seat.

  **Check 2 — the draft, and what was opened.** The measurement's record was read whole. It was
  run at the base adapter (`git_reader/libgit2.rs` unchanged from `799c3d6`), against
  `libgit2-sys 0.18.8+1.9.7` (`Cargo.lock:L122-L123`, read), with a FIFO at the other location's
  `.git/config` watched by `opener_seen_during_the_three_calls` — a non-blocking write open that
  succeeds only while a reader holds the FIFO, so a libgit2 call blocked on it cannot return
  unseen. Eleven scenes, repeated three times with identical output. The positive control (an
  index gitlink `sub`, section `[submodule "sub"] path = elsewhere`) saw the opener; kind (i) (an
  untracked folder holding a repository, no gitlink) and kind (ii) (a gitlink in HEAD's tree the
  index no longer holds, with and without the folder) did not, with or without a control section;
  the own-location scenes S1o and S2o, with no `.gitmodules`, saw no opener. The adapter built on
  that: `verify_submodules` collects the index's `GITLINK_MODE` entries as the looked-up set
  (`libgit2.rs:L553-L557`) and `SectionScope`'s comment says nothing beyond them was measured as
  looked up (`:L222-L230`); `test_looked_up_kinds_the_measurement_found_are_refused`
  (`git_state.rs:L3017-L3033`) is kind (i) with a FIFO at the other location, asserting no opener
  and the lists answered. All as the item states. The item's "watched for an open with a FIFO at
  the other location's `.git/config` … with a positive control that did see an opener" is the
  record's own method, and its reading of why a FIFO at `.git/HEAD` sees nothing was re-read at
  the libgit2 source (the Header).

  **Addition one: say why the instruction's method does not work.** The item mentions it in
  passing. The fold states it, because the next person to measure will reach for `HEAD` first:
  libgit2 returns from `git_repository_open` before any read when `HEAD` is not a regular file
  (`repository.c:L287`; `fs_path.c:L799-L802`, `:L603-L611`), so a FIFO there measures nothing,
  and the control proved it. The three lines R-16 keeps "as read and not run" were opened and are
  the lookup and open calls the document names; the paragraph keeps them as what was read, with
  the measurement beside them as what was run, and does not say the lines are wrong — only that
  for kinds (i) and (ii) no open was observed in the scenes run.

  **Addition two: pin the set to the version.** R-16 already says the domain "is pinned to that
  libgit2 version, and a `libgit2-sys` version change re-measures it in the lockfile review § 4
  C-R6 already requires" (`:L3110-L3112`). The looked-up set is the same kind of fact and takes
  the same sentence; without it, a version bump re-measures the keys and not the set.

  **Addition three: the bound, and where the record lives.** The record's own words are "a bound
  on these scenes, not a proof for every folder" of the own-location question, and the paragraph
  carries that bound rather than "nothing more" as an absolute. The record is
  `measurement.md` in the change's folder under the instance's journey, which this document never
  cites (`setting_up_a_project.md` § *The definition set never names the journey*); the paragraph
  states the method, the scenes and the result in its own words, as R-16 *Measured.* did for the
  earlier measurement, and cites the case. One thing is reported and not the SDD's to fix: the
  adapter's doc comment at `libgit2.rs:L225` cites `measurement.md`, a file that is not in this
  repository (`git ls-files | grep -i measurement` prints nothing); a reader of the source cannot
  follow it. That is a code comment, the product's, for a later change.

  **Check 3 — the settled record.** `docs/nfdr.md` states nothing about which paths the status
  read looks up (`grep -n -i 'looked up\|no gitlink\|gitlinks'` prints nothing), and the
  architecture companion's § 3.1 already records that QC-15 owes nothing for kind (i) — the
  measurement's own consequence — so no companion is owed elsewhere. R-16 *The status read and the
  submodule map* and *Measured.* describe the open the map makes for an index gitlink, which is
  the positive control's finding and is not contradicted. Answers 5.1 and 5.2 were decided
  first; the *Open Questions* item's closing in 5.1 needs this answer and 5.2, and they agree.

  **Check 4 — the failure paths.** Empty: an index with no gitlink gives an empty looked-up set,
  so no section can answer `SubmoduleElsewhere`, and sections are still decided for outside and
  `/` (L2710 holds that the check does not depend on the index naming the section). Absent: a
  gitlink whose folder is missing is skipped by the verification (`libgit2.rs:L574-L578`) and its
  section is still in the set — L2776 holds the uninitialised case. Stale: the set is true at the
  version pinned, which addition two carries. Concurrent: a gitlink added to the index between
  the check and the read is the rewrite case the document already names as uncovered. Refused:
  n/a — this is a measurement, not a refusal.

  **What would have tipped it.** Had kind (i) seen an opener, the looked-up set would include a
  working-tree folder holding `.git` with no gitlink, the adapter would have to collect those by
  walking the working tree, and QC-15 would owe a read; the control was built to make that visible
  and it did not happen. And had the positive control not seen the opener with the FIFO at
  `config`, the method would prove nothing and the paragraph could say only that nothing was
  measured; it did.

### 5.4 — § 11 R-16 *The sixth member* quotes an adapter comment that no longer exists, and does not say what a section with no `path` key is refused under

- **Bucket:** 5. Raised from downstream — an item from a seat that did not write the SDD
- **Verdict:** confirmed with addition
- **Why:** The item's "likely fold" is a lean, so it was weighed as a draft. It holds, and one
  addition names the sentence the second half replaces. A quoted comment that is no longer in the
  source is a citation now false, and a design choice the paragraph left to the change is now
  made; both are corrections.

  **Check 1 — whose.** The edit is in `docs/SDD.md` § 11 R-16 *The sixth member*
  (`:L3281-L3282`) and *Its spelling and its refusals* (`:L3283-L3295`); the item carries
  `Seat: cto`; what a refusal carries as its key is a technical shape inside the CTO's columns.
  Mine, in the owner's seat.

  **Check 2 — the draft, and what was opened.** `git grep -n -i 'only includes follow' ccbe02a --
  crates` exits 1 with no output. The comment now at `libgit2.rs:L260-L261` reads "Only an include
  key follows a path to a file. A submodule section's own `path` is decided below, and repository
  options in .gitmodules do not configure the repository" — the source now says what the
  paragraph argued, so the fold cites it in the dead quotation's place and keeps the old quotation
  in a dated note (as said at `:L236-L237` at `ka-reader@5f3e895`). For a section with no `path`
  key, `check_section` passes `section.word` as the key and `section.written_name` as the written
  path (`:L300-L310`); `word` is "The section word as the file writes it: `submodule`,
  `Submodule`" (`config_scan.rs:L59-L60`); and the case at `git_state.rs:L2748` asserts
  `ConfigNamesOutside(config_named("submodule", "../outside-n"))` for `[submodule "../outside-n"]`.
  Spelling from the level's working tree, sections in included files too, is L2893, and a
  verified submodule's from its own working tree is L2939. All as the item states.

  **Addition: the sentence that moves.** The paragraph's last sentence — "What the condition
  carries as the key for a section that has no `path` key is the design of the change that builds
  the check" (`:L3293-L3295`) — is the one the second half replaces, and the fold replaces it
  rather than appending beside it, with its old words in a dated note.

  **Check 3 — the settled record.** R-16 *The sixth member*'s reading of libgit2 — a section's
  path is its `path` value or its name where it has none (`submodule.c:L2080-L2091`, `:L1953`) —
  is what the build follows, and the name-only rule holds it. The config condition's members on
  the wire are a key and a path (`session.rs`, `config_names_outside` with "exactly its four
  members", `BridgePayloadGitTests.swift:L125`), and a key of `submodule` rides them unchanged, so
  SM-4 does not move. Nothing upstream names the key's form. Answers 5.1 to 5.3 were decided
  first and nothing here reads against them.

  **Check 4 — the failure paths.** Empty: a section header with no entries and a name that spells
  inside is decided on its name and passes. Absent: n/a. Stale: the comment's locator is pinned
  by the fold at its own commit, and the dated note carries where the old one was. Concurrent:
  n/a. Refused: a name-only section naming an outside path is refused with the section word as
  the key, which is what the case holds; the shell draws "KA-Reader found submodule set to
  ../outside-n, outside the folder you opened …" for it, which is the config sentence with that
  key, and says nothing the adapter did not observe.

  **What would have tipped it.** Had the adapter spelled a synthetic key — `submodule.<name>.path`
  — for a name-only section, the refusal would name a key the file does not hold, against
  *Its spelling and its refusals*' "as the file spells them"; L2748 asserts it does not.

## Left for the owner

None this run.

## Skipped

None this run.

## Companions opened

None this run.

## Launchers owed

- **`docs/SDD.md`** — `<CORE>/launchers/skill/launcher.sh product-sdd ka-reader`
