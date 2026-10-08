# SDD open issues — KA-Reader

> Companion to `SDD.md`. The CTO wrote the SDD; this file holds what that run could not settle from
> its inputs (the PRD, the SRS, the UXD, and any context or constraints), and the calls that are the
> CPO's or the CDO's to make. An item whose call is the CPO's or the CDO's carries that seat's
> `Seat:`; an item whose call is the CTO's carries `cto` or no `Seat:` field.
>
> **Answer inline** — fill each **Answer** / **Confirm or override** / **Keep or re-cut** /
> **Your call** slot — **commit this file**, then re-run `product-sdd`. It folds your answers into
> the SDD and drops the resolved items. When nothing is left open, `product-sdd` **deletes this
> file**: no file = the SDD is done.
>
> Your answers are never thrown away. Each time `product-sdd` folds them in, it first copies this
> file whole to `docs/trail/sdd/` — so what you decided, and why, stays readable and citable for good.
>
> **An item may name the seat that answers it.** Any item in any section carries an optional
> `- **Seat:** <seat>` field beside its other fields. Its value is the name of the agent whose posture
> answers the item — `cto`, `cpo` or `cdo`. An item with no usable value, whether the field is absent,
> empty or still the `<seat>` placeholder, is answered in the seat of the skill that produced this file.
> The field names the *answering* seat. It is not the seat that raised the item (`Raised by:` /
> `Held by:`), and it is not the document an answer belongs to.
>
> **An item in §§ 1–3 names the seat that raised it.** An item the CPO raised is a product call and
> an item the CTO raised is a technical one, and the answer that settles one does not settle the
> other. **§ 4 names two seats and no raiser** — a
> disagreement is not something one seat asked, it is two positions held by different seats, and the
> answer that settles it picks between them.
>
> **§ 5 names a raiser from outside the SDD's lanes entirely.** §§ 1–4 are all the SDD's own three
> lane seats; § 5 is a seat that never held a lane in it, reading it long after it settled and
> finding something only the SDD can fix. Its `Raised by:` therefore takes a wider set than §§ 1–3's,
> which stay fixed to the three lane seats on purpose.

> **No `product-sdd` run wrote this file.** The PM opened it on 2026-10-04 from the SDD's own companion
> template. `git-reader` now answers `state` and `status`, and `folder-model` folds the answer into a Git
> item (`ka-reader@6a0725c`). Four statements of the SDD no longer match what landed: two hand-offs to "the
> design of the change that adds" a type, which that change has now made, and two clauses of S-4's
> reducer case. The SDD is Settled, and with no companion on disk a `product-sdd` re-run reads it as done
> and has nothing to act on. Its four items are in § 5.

---

## 1. Open issues — questions with no answer yet

None.

## 2. Choices to confirm — a best-effort answer was drafted; confirm or override

### 2.1 § 4 C-I1 and S-5's command half say a failed read leaves "`observed` on its siblings"; a sibling not yet read is `pending`

> **No `product-sdd` run wrote this item.** The `companion-self-answer` run answering this file
> raised it on 2026-10-04, under `<CORE>/prompts/decide_companion_answers.md` § *The items are not
> the whole of what a document is owed*, which covers the document being answered. It came from
> answering § 5.4: the wording § 5.4 corrects in S-4 and RN-44 is quoted from C-I1, and C-I1 and
> S-5 still carry it. The sentence at the head of this file, "Its four items are in § 5", was
> written before this item was added. The slot below is left at its placeholder: the reasoning is
> that run's, and the decision belongs to the next round. Reasoning:
> `docs/trail/sdd/self_answer-35.md`, § *Raised on this document*.

- **Raised by:** `companion-self-answer`, answering this file in the CTO's seat — 2026-10-04
- **Seat:** cto
- **Drafted into the SDD:** Nothing has been written into the SDD. As it stands, § 4 C-I1 reads "a
  failure to read one file, one entry or one part of Git state yields `failed` or `stopped` on that
  item and `observed` on its siblings" (`docs/SDD.md:L682-L683`), and S-5's *Command* reads "an
  unreadable entry yields `failed` on that item and `observed` on its siblings"
  (`docs/SDD.md:L1783-L1784`). The draft change: both say the failure is held on that item and its
  siblings stand as they were — `observed` where read, `pending` where not yet read, `failed` where
  an earlier read failed. RN-44's parenthesis, which quotes C-I1, follows.
- **Rationale:** The wording cannot be met by any folder that holds a folder. `list_tree` reports a
  folder it has not expanded as `Pending` (`crates/ka-reader-core/src/fs_reader.rs:L137`, `:L853`), so
  a failed entry beside an unexpanded folder has a sibling that is not `observed`. § 5.4 of this
  file records the same defect met in S-4: the reducer case had to choose a tree of files only. S-5
  has not been built, and its `--test watch` case would meet it again. The requirement C-I1 cites
  says what the draft says: `docs/SRS.md` NFR-3, "degrades only that item's view"
  (`docs/SRS.md:L297-L298`). The doubt: a reader may take "`observed` on its siblings" as shorthand
  for "its siblings are untouched", and then nothing is false. It is raised because S-5's clause is
  a command bar, and a bar is read literally by the change that has to pass it.
- **If overridden:** C-I1 and S-5 keep their wording, and § 5.4's fold leaves S-4 saying "as they
  were" where the condition it cites says "`observed`". No part, seam, slice, edge or place in the
  order moves either way. `docs/nfdr.md:L1010` repeats the wording and re-derives from whichever
  the SDD holds.
- **Confirm or override:** <"confirm", or "override: <what to do instead>">

## 3. Cut calls to confirm — where the slicing could reasonably have gone another way

None.

---

## 4. Disagreements — two seats hold different positions and neither yields

None.

## 5. Raised from downstream — an item from a seat that did not write the SDD

### 5.1 § 3 `GitState` leaves a choice to "the change that adds `state`"; that change has made it
- **Raised by:** PM — 2026-10-04
- **Seat:** cto
- **Tracked by:** `ka-reader · nemawashi · 2026-10-02_git-says-what-changed`
- **What it blocks:** nothing fails. The next Git surface reads the entity to learn what the model holds,
  and the entity still says the choice is open.
- **Where it shows:** § 3 `GitState` (`docs/SDD.md:L479-L481`): "whether it is the type the port returns
  or one the model builds from what the port returns is the design of the change that adds `state`".
  In the tree, the model builds it: `pub struct GitState` is defined in `folder-model`
  (`crates/ka-reader-core/src/folder_model.rs:L166`) and holds the `HeadState` the port answers
  (`crates/ka-reader-core/src/git_reader.rs:L74`). The port answers its parts through separate calls,
  `state` and `status`. The likely fold: state that the model builds `GitState` from the port's answers
  and defines it in `folder-model`.
- **If a document has to be written:** none. The § 3 entity in `SDD.md`.
- **Answer:** Take the likely fold, with one bound. § 3 `GitState` states the choice as made:
  `GitState` is a type `folder-model` defines and builds from what the port returns, and the port
  never returns it. The hand-off to "the change that adds `state`" goes. The bound: do not say the
  model builds it from `state` and `status` both. At `ka-reader@6a0725c` the model asks `state` alone
  and `GitState` holds the port's `HeadState` and nothing else
  (`crates/ka-reader-core/src/folder_model.rs:L166-L168`, `:L273-L278`); the changed and staged entries
  the entity lists are the design, and no landed change puts them in the model yet. The rest of the
  entity stands as written. Answered in the CTO's seat by an unattended run; reasoning in
  `docs/trail/sdd/self_answer-35.md`.

### 5.2 SM-2 leaves where the crossing types live to "the design of the change that adds it"; they live in `git-reader`
- **Raised by:** PM — 2026-10-04
- **Seat:** cto
- **Tracked by:** `ka-reader · nemawashi · 2026-10-02_git-says-what-changed`
- **What it blocks:** nothing fails. A later port method (`diff`, `walk`) reads SM-2 to place its types,
  and the row gives two homes with no choice made between them.
- **Where it shows:** SM-2's row (`docs/SDD.md:L420`): a crossing type "is defined in `git-reader`, or in
  a module of `ka-reader-core` that is no part, and which of the two is the design of the change that adds
  it". Every type `state` and `status` answer is defined in `git-reader`: `HeadState`, `BranchElement`,
  `RepositoryState`, `StatusLists`, `StatusEntry`, `StatusCategory` and `GitReadCondition`
  (`crates/ka-reader-core/src/git_reader.rs:L74-L194`). The likely fold: say that the types `state` and
  `status` answer are defined in `git-reader`.
- **If a document has to be written:** none. SM-2's row in `SDD.md`.
- **Answer:** Take the likely fold, and keep the rule. SM-2's row says where the types that cross
  today live: every type `probe`, `state` and `status` answer is defined in `git-reader`, beside the
  trait (`crates/ka-reader-core/src/git_reader.rs:L74-L263`), which is also what the row's own earlier
  sentence, "with the plain-data types that cross beside it", already says. The rule itself stays
  as written for a type a later method brings: never in `folder-model`, and its home is the design
  of the change that adds it. The row is not asked to choose a home for the types of `diff` and
  `walk`. Neither method exists, the item cites no type of theirs, and a choice written before the
  types exist is not until it occurs. Answered in the CTO's seat by an unattended run; reasoning in
  `docs/trail/sdd/self_answer-35.md`.

### 5.3 S-4 and RN-44 say the reducer case needs a double because `linked-worktree` reads fine in-process; the adapter now refuses it there
- **Raised by:** PM — 2026-10-04
- **Seat:** cto
- **Tracked by:** `ka-reader · nemawashi · 2026-10-02_git-says-what-changed`
- **What it blocks:** nothing fails. The reason the slice gives for its double is now false, and a
  reader taking it at its word would think the in-process harness cannot produce the R-3 failure.
- **Where it shows:** S-4's *Command* (`docs/SDD.md:L1720-L1721`) says the double is "injected because
  the in-process harness runs under no sandbox grant and the `linked-worktree` fixture reads fine there".
  RN-44 (`docs/SDD.md:L3317-L3320`) says the fixtures "cannot produce the failure on their own" and that
  "libgit2 reads a gitdir outside the opened folder there without complaint". In the tree, the
  in-process adapter refuses both fixtures by the path's spelling before libgit2 opens anything:
  `test_linked_worktree_and_submodule_answer_outside_from_both_calls`
  (`crates/ka-reader-core/tests/git_state.rs:L715-L725`) asserts `GitDirectoryOutside`, and it passes
  (`cargo test --locked -p ka-reader-core --test git_state`: 36 passed, run 2026-10-04 at `ka-reader@6a0725c`).
  The double is still how the reducer case reaches the model with no adapter. The likely fold: give
  that as the reason, and say the in-process adapter now refuses the fixture by spelling.
- **If a document has to be written:** none. S-4 and RN-44 in `SDD.md`.
- **Answer:** Take the likely fold, with three additions. S-4's *Command* gives the double's real
  reason: the reducer case reaches the model with no adapter behind it, because what it checks is the
  reducer's (C-I1) and not the port's. The clause "injected because … the `linked-worktree` fixture
  reads fine there" goes. One: RN-44 carries three false clauses, not two. "The failure R-3 names
  exists only under the bundle's grant (C-R2)" is false for the same reason as the two the item
  quotes, and is corrected with them. Two: the fold says where the in-process refusal is exercised.
  The `git_state` suite runs the `linked-worktree` and `submodule` fixtures through the adapter, and
  both `state` and `status` answer the outside condition, because the adapter locates the Git
  directory and the common directory by spelling before libgit2 opens anything
  (`crates/ka-reader-core/src/git_reader/libgit2.rs:L79-L81`;
  `crates/ka-reader-core/tests/git_state.rs:L714-L725`; `cargo test --locked -p ka-reader-core --test
  git_state`: 36 passed, re-run 2026-10-04 at `ka-reader@22e36c3`). Three: the fold claims nothing
  about the bundle. A refusal by spelling shows nothing about the sandbox, so § 11 R-3 and *Open
  Questions*' second item stand as written. RN-44 is corrected where it stands, and a new review
  note records what it said. Answered in the CTO's seat by an unattended run; reasoning in
  `docs/trail/sdd/self_answer-35.md`.

### 5.4 S-4 and RN-44 say "every tree item `observed`"; a tree holding an unexpanded folder holds it `Pending`
- **Raised by:** PM — 2026-10-04
- **Seat:** cto
- **Tracked by:** `ka-reader · nemawashi · 2026-10-02_git-says-what-changed`
- **What it blocks:** nothing fails. The bar is unmeetable as worded for any tree with a folder in it, and
  the case that meets it had to choose a tree of files only.
- **Where it shows:** S-4's *Command* (`docs/SDD.md:L1721-L1722`) and RN-44 (`docs/SDD.md:L3315`) ask
  that after the failed Git read "every tree item `observed`". `list_tree` reports a folder it has not
  expanded as `Pending` (`crates/ka-reader-core/src/fs_reader.rs:L137`, `:L853`). The reducer case passes
  by using a tree of files only (`model_over_files`, `crates/ka-reader-core/tests/git_state.rs:L940-L947`)
  and asserting the tree is unchanged by the fold. The likely fold: say the failed Git read leaves every
  tree item as it was — `observed`, or `pending` for a folder not yet expanded.
- **If a document has to be written:** none. S-4 and RN-44 in `SDD.md`.
- **Answer:** Take the likely fold, stated as the rule it comes from. In S-4's *Command* and in
  RN-44's first sentence, "every tree item `observed`" becomes: the failed Git read changes the Git
  item and nothing else, so the tree and every item in it stand as they were before the read. A
  file stays `observed`, a folder not yet expanded stays `pending`, and an entry that had failed
  stays `failed`. The item's wording names the first two; the third is the same rule and is added so
  the bar does not read as "no tree item may be `failed`". It rests on the fold itself, which
  replaces the Git item alone (`crates/ka-reader-core/src/folder_model.rs:L273-L288`), and on what the
  case asserts, that the tree is equal before and after
  (`crates/ka-reader-core/tests/git_state.rs:L952-L985`). RN-44's parenthesis quoting C-I1, "its
  siblings `observed`", is not reworded here: it quotes a § 4 condition that has the same defect,
  and that is § 2.1 of this file. Answered in the CTO's seat by an unattended run; reasoning in
  `docs/trail/sdd/self_answer-35.md`.

**How it closes.** `product-sdd` folds it on its next run like every other item in this file, and
the trail copy and the delete-when-empty behaviour are unchanged.
