# SDD open issues — Nozoki

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
> item (`nozoki@6a0725c`). Four statements of the SDD no longer match what landed: two hand-offs to "the
> design of the change that adds" a type, which that change has now made, and two clauses of S-4's
> reducer case. The SDD is Settled, and with no companion on disk a `product-sdd` re-run reads it as done
> and has nothing to act on. Its four items are in § 5.

---

## 1. Open issues — questions with no answer yet

None.

## 2. Choices to confirm — a best-effort answer was drafted; confirm or override

None.

## 3. Cut calls to confirm — where the slicing could reasonably have gone another way

None.

---

## 4. Disagreements — two seats hold different positions and neither yields

None.

## 5. Raised from downstream — an item from a seat that did not write the SDD

### 5.1 § 3 `GitState` leaves a choice to "the change that adds `state`"; that change has made it
- **Raised by:** PM — 2026-10-04
- **Seat:** cto
- **Tracked by:** `nozoki · nemawashi · 2026-10-02_git-says-what-changed`
- **What it blocks:** nothing fails. The next Git surface reads the entity to learn what the model holds,
  and the entity still says the choice is open.
- **Where it shows:** § 3 `GitState` (`docs/SDD.md:L479-L481`): "whether it is the type the port returns
  or one the model builds from what the port returns is the design of the change that adds `state`".
  In the tree, the model builds it: `pub struct GitState` is defined in `folder-model`
  (`crates/nozoki-core/src/folder_model.rs:L166`) and holds the `HeadState` the port answers
  (`crates/nozoki-core/src/git_reader.rs:L74`). The port answers its parts through separate calls,
  `state` and `status`. The likely fold: state that the model builds `GitState` from the port's answers
  and defines it in `folder-model`.
- **If a document has to be written:** none. The § 3 entity in `SDD.md`.
- **Answer:** <the owner fills this in>

### 5.2 SM-2 leaves where the crossing types live to "the design of the change that adds it"; they live in `git-reader`
- **Raised by:** PM — 2026-10-04
- **Seat:** cto
- **Tracked by:** `nozoki · nemawashi · 2026-10-02_git-says-what-changed`
- **What it blocks:** nothing fails. A later port method (`diff`, `walk`) reads SM-2 to place its types,
  and the row gives two homes with no choice made between them.
- **Where it shows:** SM-2's row (`docs/SDD.md:L420`): a crossing type "is defined in `git-reader`, or in
  a module of `nozoki-core` that is no part, and which of the two is the design of the change that adds
  it". Every type `state` and `status` answer is defined in `git-reader`: `HeadState`, `BranchElement`,
  `RepositoryState`, `StatusLists`, `StatusEntry`, `StatusCategory` and `GitReadCondition`
  (`crates/nozoki-core/src/git_reader.rs:L74-L194`). The likely fold: say that the types `state` and
  `status` answer are defined in `git-reader`.
- **If a document has to be written:** none. SM-2's row in `SDD.md`.
- **Answer:** <the owner fills this in>

### 5.3 S-4 and RN-44 say the reducer case needs a double because `linked-worktree` reads fine in-process; the adapter now refuses it there
- **Raised by:** PM — 2026-10-04
- **Seat:** cto
- **Tracked by:** `nozoki · nemawashi · 2026-10-02_git-says-what-changed`
- **What it blocks:** nothing fails. The reason the slice gives for its double is now false, and a
  reader taking it at its word would think the in-process harness cannot produce the R-3 failure.
- **Where it shows:** S-4's *Command* (`docs/SDD.md:L1720-L1721`) says the double is "injected because
  the in-process harness runs under no sandbox grant and the `linked-worktree` fixture reads fine there".
  RN-44 (`docs/SDD.md:L3317-L3320`) says the fixtures "cannot produce the failure on their own" and that
  "libgit2 reads a gitdir outside the opened folder there without complaint". In the tree, the
  in-process adapter refuses both fixtures by the path's spelling before libgit2 opens anything:
  `test_linked_worktree_and_submodule_answer_outside_from_both_calls`
  (`crates/nozoki-core/tests/git_state.rs:L715-L725`) asserts `GitDirectoryOutside`, and it passes
  (`cargo test --locked -p nozoki-core --test git_state`: 36 passed, run 2026-10-04 at `nozoki@6a0725c`).
  The double is still how the reducer case reaches the model with no adapter. The likely fold: give
  that as the reason, and say the in-process adapter now refuses the fixture by spelling.
- **If a document has to be written:** none. S-4 and RN-44 in `SDD.md`.
- **Answer:** <the owner fills this in>

### 5.4 S-4 and RN-44 say "every tree item `observed`"; a tree holding an unexpanded folder holds it `Pending`
- **Raised by:** PM — 2026-10-04
- **Seat:** cto
- **Tracked by:** `nozoki · nemawashi · 2026-10-02_git-says-what-changed`
- **What it blocks:** nothing fails. The bar is unmeetable as worded for any tree with a folder in it, and
  the case that meets it had to choose a tree of files only.
- **Where it shows:** S-4's *Command* (`docs/SDD.md:L1721-L1722`) and RN-44 (`docs/SDD.md:L3315`) ask
  that after the failed Git read "every tree item `observed`". `list_tree` reports a folder it has not
  expanded as `Pending` (`crates/nozoki-core/src/fs_reader.rs:L137`, `:L853`). The reducer case passes
  by using a tree of files only (`model_over_files`, `crates/nozoki-core/tests/git_state.rs:L940-L947`)
  and asserting the tree is unchanged by the fold. The likely fold: say the failed Git read leaves every
  tree item as it was — `observed`, or `pending` for a folder not yet expanded.
- **If a document has to be written:** none. S-4 and RN-44 in `SDD.md`.
- **Answer:** <the owner fills this in>

**How it closes.** `product-sdd` folds it on its next run like every other item in this file, and
the trail copy and the delete-when-empty behaviour are unchanged.
