# Self-answer report — `docs/SDD.md`

This is the record of one unattended run that answered `docs/SDD_open_issues.md` in the CTO's seat,
with nobody present. It is for the owner, who reads it to learn what was decided and why, and for
the `product-sdd` run that folds the answers.

## Header

- **Companion:** `docs/SDD_open_issues.md`
- **Document:** `docs/SDD.md`
- **Decided by:** `decide_companion_answers.md` v1.3.0
- **Date:** 2026-10-04
- **Sources re-read:** None. No answer rests on a source outside this repository. Every answer rests
  on the product's own tree, read at `nozoki@22e36c3`. `git diff --stat 6a0725c HEAD -- crates
  checks` prints nothing, so the code is what the items measured at `nozoki@6a0725c`.

**What this run read.** The companion whole. Of `docs/SDD.md` (5,280 lines): the header and version
lines (`:L1-L60`), § 3 whole (`:L308-L489`), § 4 C-I1 (`:L681-L692`), § 6 S-4 whole
(`:L1672-L1751`) and S-5's command clause (`:L1776-L1786`), § 11 R-1 to R-3 (`:L2566-L2585`),
RN-42 to RN-44 (`:L3262-L3326`), RN-85 (`:L5037-L5085`) and *Open Questions* whole
(`:L5209-L5280`). The rest was searched for `GitState`, `design of the change that adds`, `every
tree item`, `reads fine`, `without complaint`, `linked-worktree`, `on their own`, `only under the
bundle`, `port double`, `reducer case` and `siblings`, and each hit was read. **§ 1, § 2, § 5, § 6's
other slices, §§ 7–10, § 12 and the review notes outside those hits were not read line by line.**
The prompt asks for the document whole; this run did not do that, and a sentence in those sections
that bears on an item and uses none of those words was not seen.

Outside the SDD: `crates/nozoki-core/src/git_reader.rs` (`:L36-L74`, `:L185-L263` and its list of
public items), `src/git_reader/libgit2.rs:L60-L145`, `src/folder_model.rs:L150-L200` and
`:L268-L290`, `src/fs_reader.rs:L120-L140` and its `Pending` hits, `src/lib.rs`'s module list,
`tests/git_state.rs:L700-L730` and `:L900-L1010`; `docs/SRS.md:L297-L299`;
`docs/adr/0018-…md:L88-L102`; `docs/architecture_open_issues.md` whole. `docs/nfdr.md`, `docs/fdr.md`,
`docs/SRS.md`, `docs/UXD.md`, `docs/CONTENT.md` and `docs/adr/` were searched for the same phrases
and not otherwise opened, because no answer moves a requirement or a surface. `docs/PRD.md` was not
opened. One command was run: `cargo test --locked -p nozoki-core --test git_state`, which printed
"test result: ok. 36 passed; 0 failed".

**All four items sit under § 5, *Raised from downstream*.** Each carries a "likely fold", which is a
lean, so each was weighed as a draft and not answered from scratch. None widens the SDD without an
occurrence: each cites the code that makes a standing sentence false or out of date. The one place
an item's reach would have widened the document is § 5.2, and the answer says so.

## Items worked

### 5.1 — § 3 `GitState` leaves a choice to "the change that adds `state`"; that change has made it

- **Bucket:** 5. Raised from downstream — an item from a seat that did not write the SDD
- **Verdict:** confirmed with addition
- **Why:** The likely fold is taken. § 3 `GitState` says the choice is made: `folder-model` defines
  the type and builds it from what the port returns, and the port never returns it.

  **Whose call it is.** The item carries `Seat: cto`, and the three tests agree. The edit lands in
  this document's § 3. The answer binds only what the SDD says about a type that already exists. No
  ground this run can name is hidden from it.

  **Why the fold holds.** `pub struct GitState` is at `crates/nozoki-core/src/folder_model.rs:L166`.
  The port's trait returns `HeadState` and `StatusLists` and never `GitState`
  (`src/git_reader.rs:L46-L58`). The sentence the SDD carries, "whether it is the type the port
  returns or one the model builds … is the design of the change that adds `state`"
  (`docs/SDD.md:L479-L481`), hands off a choice that has since been made.

  **The addition.** The item says "The port answers its parts through separate calls, `state` and
  `status`", and a fold could read that as "the model builds `GitState` from both". It does not, yet.
  `read_git` asks `probe` and `state` and never `status` (`src/folder_model.rs:L273-L278`), and
  `GitState` has one field, `head: HeadState` (`:L166-L168`). The test double panics if the reducer
  asks `status` (`tests/git_state.rs:L929-L931`). So the fold says where the type lives and who
  builds it, and does not say the model holds the changed and staged entries today. Those stay in
  the entity as the design, which is what § 3's "Design-level; the physical layout is the
  developer's" (`docs/SDD.md:L437`) already makes them.

  **Checked against the settled record.** SM-2 says a type that crosses the seam "is never defined
  in `folder-model`" (`docs/SDD.md:L420`). `GitState` does not cross SM-2: the model builds it on
  its own side. `FolderModel`'s "`root(GitState)`" (`:L440`) matches
  `ItemState::Observed(FolderKind::Root(GitState { head }))` in the tree.

  **Failure paths.** *Empty* and *absent*: a plain folder or a failed read has no `GitState`, and
  the entity already says "present only where `kind` is `root`". *Stale*: the fold cites a commit,
  and a later change that brings `status` into the model re-measures it. The others do not apply to
  a sentence about where a type is defined.

  **Not raised.** `docs/adr/0018-…md:L97` carries a hand-off in the same words, about how `state()`
  decides a location is outside. An ADR is a dated record and the sentence is not false, so nothing
  is raised on it.

### 5.2 — SM-2 leaves where the crossing types live to "the design of the change that adds it"; they live in `git-reader`

- **Bucket:** 5. Raised from downstream — an item from a seat that did not write the SDD
- **Verdict:** confirmed with addition
- **Why:** The likely fold is taken: SM-2's row says the types `state` and `status` answer are
  defined in `git-reader`. The rule beside it stays as written.

  **Whose call it is.** `Seat: cto`. The edit lands in SM-2's row of this document and binds
  nothing outside it.

  **Why the fold holds.** Every public type the port answers is in
  `crates/nozoki-core/src/git_reader.rs`: `HeadState` (`:L74`), `BranchElement` (`:L90`),
  `RepositoryState` (`:L110`), `StatusLists` (`:L132`), `StatusEntry` (`:L151`), `StatusCategory`
  (`:L168`), `GitReadCondition` (`:L194`), `RootFinding` (`:L228`) and `ProbeCondition` (`:L249`).
  `nozoki-core`'s modules that are no part, `error.rs` and `language.rs` (`src/lib.rs:L3-L8`), hold
  none of them.

  **The addition, and what the answer declines.** The item's "What it blocks" says a later method,
  `diff` or `walk`, "reads SM-2 to place its types, and the row gives two homes with no choice made".
  That reads as a request to choose for those methods too. The answer does not. The rule is written
  for each change: "which of the two is the design of the change that adds it". For `state` and
  `status` the change has chosen, and the row records it. For `diff` and `walk` no type exists and
  the item cites none, so writing their home now would add a decision to the SDD that no occurrence
  asks for. That part is answered "not until it occurs". The row also already says "The port is a
  trait defined in `git-reader`, with the plain-data types that cross beside it", so the fold makes
  the row's two sentences agree: the first states the fact for what has landed, and the second keeps
  the rule for what has not.

  **What would have tipped it.** Had a type of `diff` or `walk` already been defined somewhere, the
  answer would have recorded its home too.

  **Failure paths.** *Stale* is the one that applies: the row will be out of date again when `diff`
  lands, and the rule's own words send that change back to this row. RN-85's account of the rule is
  a dated note and is left as it is.

### 5.3 — S-4 and RN-44 say the reducer case needs a double because `linked-worktree` reads fine in-process; the adapter now refuses it there

- **Bucket:** 5. Raised from downstream — an item from a seat that did not write the SDD
- **Verdict:** confirmed with addition
- **Why:** The likely fold is taken. S-4's *Command* gives the double's real reason, and the false
  one goes.

  **Whose call it is.** `Seat: cto`. The edits land in § 6 S-4's command half and in RN-44, both
  the CTO's lane. No promise is lowered and no bar is removed.

  **Why the fold holds.** S-4 says the R-3 case is "injected because the in-process harness runs
  under no sandbox grant and the `linked-worktree` fixture reads fine there"
  (`docs/SDD.md:L1720-L1721`). In the tree the fixture does not read fine in-process.
  `open_verified` calls `verified_locations` before `Repository::open_ext`
  (`crates/nozoki-core/src/git_reader/libgit2.rs:L79-L81`), and `locate_inside` answers
  `GitDirectoryOutside` for a location outside the folder "whether or not anything is there"
  (`:L129-L142`). `test_linked_worktree_and_submodule_answer_outside_from_both_calls`
  (`tests/git_state.rs:L714-L725`) asserts it for both fixtures, and the suite passes: 36 passed,
  re-run by this run. The double is still needed. `read_git` takes any `GitPort`
  (`src/folder_model.rs:L273`), and the reducer case checks what the model does with a failure,
  which is C-I1's question and not the adapter's.

  **Three additions.**
  1. *RN-44 has a third false clause.* The item quotes "cannot produce the failure on their own" and
     "libgit2 reads a gitdir outside the opened folder there without complaint". The same sentence
     ends "the failure R-3 names exists only under the bundle's grant (C-R2)"
     (`docs/SDD.md:L3319-L3320`). The adapter produces that failure with no grant in play, so this
     clause is false for the same reason and is corrected with the other two.
  2. *The fold says where the refusal is exercised.* RN-44 also says the two fixtures "ran only
     through `root_finding`" (`:L3317`). They now run through `git_state` as well. Saying so keeps
     S-4's command half from reading as though nothing in-process covers the adapter's side of R-3.
  3. *The fold claims nothing about the bundle.* The refusal is by spelling. It shows what the
     adapter does and shows nothing about what the sandbox does. § 11 R-3 (`:L2577-L2585`) stays as
     written, and so does *Open Questions*' second item (`:L5227-L5235`), which waits on the built
     bundle.

  **The form of RN-44's correction.** RN-44 is corrected where it stands, and a new review note
  records what it said and why it moved. The SDD has done both before: run 5 "repointed RN-41 and
  RN-42" in place (`docs/SDD.md:L21`), and RN-85 is a *(changed)* note recording corrections. A
  reader who opens RN-44 alone should not be told the fixtures cannot produce the failure.

  **Failure paths.** *Absent*: a fixture archive that fails to unpack fails the suite, which is
  the harness's and not this sentence's. *Stale*: the test's line numbers move with the file, so
  the fold pins them to a commit. *Refused*: covered by addition 3.

  **Not checked.** Whether raw libgit2, asked directly, would read the outside Git directory
  in-process was not run. The fold does not need it: the harness never asks libgit2 before the
  adapter's own check.

### 5.4 — S-4 and RN-44 say "every tree item `observed`"; a tree holding an unexpanded folder holds it `Pending`

- **Bucket:** 5. Raised from downstream — an item from a seat that did not write the SDD
- **Verdict:** confirmed with addition
- **Why:** The likely fold is taken and stated as the rule behind it: a failed Git read changes the
  Git item and nothing else, so the tree and every item in it stand as they were.

  **Whose call it is.** `Seat: cto`. The edit lands in § 6 S-4's command half and RN-44. It makes
  a bar meetable and does not lower it: the case still asserts the tree is untouched.

  **Why the fold holds.** S-4 and RN-44 ask for "every tree item `observed`"
  (`docs/SDD.md:L1722-L1723`, `:L3315`). A folder not yet expanded is `Pending`
  (`crates/nozoki-core/src/fs_reader.rs:L137`, `:L853`), so the bar fails on any tree that holds a
  folder, whatever the Git read did. The case passes by using files only (`model_over_files`,
  `tests/git_state.rs:L941-L948`) and asserting `folded.tree() == tree_before` (`:L983`).

  **The addition.** The item's wording is "`observed`, or `pending` for a folder not yet expanded".
  A third state exists: an entry whose read failed is `failed` (`src/fs_reader.rs:L137`, "An entry
  that failed is always a `File`"). Two named states would read as a closed list, and a tree with a
  failed entry would then break the bar for a reason that has nothing to do with Git. The rule
  covers all three, and the code is the rule: `read_git` returns `FolderModel { kind, ..model }`
  (`src/folder_model.rs:L287`), replacing the Git item alone.

  **Decided together with § 2.1.** RN-44's parenthesis reads "(C-I1: a failure is a state, its
  siblings `observed`)". It quotes § 4 C-I1, which carries the same wording. This answer leaves
  the parenthesis alone and the run raised C-I1 as § 2.1 of the companion, so that a § 4 condition
  is not reworded inside the answer to an item about one slice.

  **Failure paths.** *Empty*: a folder with no entries has no tree item, and "as they were" holds.
  *Absent*: a tree whose own listing failed stays failed. *Concurrent*: a tree read landing between
  the Git read and its fold is `follow-the-folder`'s, and this slice reads Git once at open
  (`docs/SDD.md:L1745-L1746`).

## Left for the owner

None this run.

## Skipped

None this run. The companion held four open items, all with `Seat: cto` and all at their
placeholders, and the invocation listed none.

## Raised on this document

### 2.1 — § 4 C-I1 and S-5's command half say a failed read leaves "`observed` on its siblings"; a sibling not yet read is `pending`

- **What the document is owed:** § 4 C-I1 and § 6 S-5's command clause say a failed read is held
  on that item and leaves its siblings as they were, in place of "`observed` on its siblings".
- **Why it is worth a cycle:** *A fact in it is now false* (`decide_companion_answers.md` § *The
  items are not the whole of what a document is owed*). C-I1 reads "yields `failed` or `stopped`
  on that item and `observed` on its siblings" (`docs/SDD.md:L682-L683`), and S-5 reads "an
  unreadable entry yields `failed` on that item and `observed` on its siblings"
  (`:L1783-L1784`). A folder not yet expanded is `Pending`
  (`crates/nozoki-core/src/fs_reader.rs:L137`, `:L853`), so neither can be met by a folder that
  holds a folder. This is the defect § 5.4 records in S-4, at its source. S-5 is not built, and its
  `--test watch` case would meet it as S-4's case did. The requirement C-I1 cites says what the
  draft says: NFR-3, "degrades only that item's view" (`docs/SRS.md:L297-L298`).

  **The doubt, stated.** "`observed` on its siblings" can be read as shorthand for "its siblings
  are untouched", and on that reading nothing is false. It was raised because S-5's clause is a
  command bar, and S-4's same wording was read literally by the change that had to pass it.

  **Where it sits.** The item replaced the line "None." under § 2 of the companion, as the run
  that raised `docs/trail/sdd/cycle-18.md` § 2.1 did. `docs/nfdr.md:L1010` repeats the wording.
  Nothing was raised on it: it derives from the SDD, and the SDD's change is not decided yet.

## Companions opened

None this run.

## Launchers owed

- **`docs/SDD.md`** — `<CORE>/launchers/skill/launcher.sh product-sdd nozoki`
