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

> **No `product-sdd` run wrote this file.** The PM opened it on 2026-10-07 from the SDD's own
> companion template. The `.gitmodules` section-path refusals and the refusal on the submodule map
> are now built (`nozoki@772c63b`), an unreadable `.gitmodules` answers a condition of its own, and
> the set of paths the status read looks up has been measured. The SDD still reads all three as
> unbuilt or undecided, in § 3, § 4 C-D3, § 6 S-4, § 11 R-16 and *Open Questions*. The SDD is
> Settled, and with no companion on disk a `product-sdd` re-run reads it as done and has nothing to
> act on. Its four items are in § 5.

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

### 5.1 § 3, § 4 C-D3, § 6 S-4, § 11 R-16 and *Open Questions* call the `.gitmodules` section-path and submodule-map refusals a known defect, and all three refusals are built
- **Raised by:** PM — 2026-10-07
- **Seat:** cto
- **Tracked by:** `nozoki · nemawashi · 2026-10-02_git-says-what-changed`
- **What it blocks:** nothing is cut by it. A reader of these passages is told that two of the
  `.gitmodules` check's three refusals are not built, that R-16's fourth case is owed, and that
  the harness holds twelve fixture folders. None of that is true at `nozoki@772c63b`.
- **Where it shows:** § 3, the `git-reader` row, "The `.gitmodules` check" (`docs/SDD.md:L348`),
  and the `read-only-harness` row, "twelve fixture folders" (`:L357`). § 4 C-D3: "Two of its
  refusals are not built, which § 11 R-16 states as a known defect" (`:L1019-L1020`). § 6 S-4
  *Reached when*: "At `nozoki@5f3e895` the include-key refusal is built and the other two are
  not … which § 11 R-16 names as a known defect until a change lands" (`:L1923-L1925`). § 11 R-16
  *A known defect, until a change lands* (`:L3346-L3352`), and *The proof*: "A fourth case is
  owed" (`:L3400-L3404`). *Open Questions*, the config-named-path item: "this item stays open on
  the `.gitmodules` case alone" (`:L7896-L7904`). At `nozoki@772c63b`:
  `check_section_value` answers `ConfigNotLocated` for a section path beginning `/` and
  `ConfigNamesOutside` for one spelled outside the folder
  (`crates/nozoki-core/src/git_reader/libgit2.rs:L330-L348`), and `SubmoduleElsewhere` for a
  looked-up name whose path spells to another location (`:L353`), on the repository's
  `.gitmodules` and on each verified submodule's, on `status()` alone. The new condition is
  `GitReadCondition::SubmoduleElsewhere(SubmoduleNamedPath)` (`crates/nozoki-core/src/git_reader.rs:L237`),
  its wire value is `submodule_elsewhere` with a `name` member (`crates/nozoki-bridge/src/session.rs:L488`,
  `:L585`), and the Git view draws "Nozoki found that a .gitmodules gives the submodule at {name}
  the path {path}, which leads somewhere else, so it doesn't read the folder's Git status. The file
  tree and the reading panel are unaffected." (`nozoki-mac/Sources/Surfaces/GitSentences.swift:L78-L82`).
  The log phrase is "a .gitmodules section names another location for a looked-up path"
  (`crates/nozoki-core/src/folder_model.rs:L259-L260`). R-16's fourth case is in the tree:
  `checks/fixtures/gitmodules-names-outside` and its `.git.tar`, and
  `test_section_leading_through_a_link_to_an_outside_x_opens_nothing_outside`
  (`crates/nozoki-core/tests/git_state.rs:L2680`), which fails against the crates at
  `nozoki@799c3d6` with "a call opened the outside x". `checks/fixtures` holds thirteen fixture
  folders. `cargo test --workspace --locked` passes (558 passed, 0 failed),
  `swift test --package-path nozoki-mac` passes (146 tests, 0 failures), and
  `checks/read-only.sh` prints `unchanged` on all thirteen. The likely fold: the passages
  re-measured at a current commit, the known-defect sentences replaced by what is built in the form
  of *Built, and the cases that hold it*, and the *Open Questions* item closed on its last case.
- **If a document has to be written:** none. A change in `SDD.md` § 3, § 4 C-D3, § 6 S-4, § 11
  R-16 and *Open Questions*, written by `product-sdd`.
- **Answer:** <the owner fills this in>

### 5.2 § 3 and § 11 R-16 say an unreadable `.gitmodules` answers the unreadable-Git-directory condition, and it answers a condition of its own
- **Raised by:** PM — 2026-10-07
- **Seat:** cto
- **Tracked by:** `nozoki · nemawashi · 2026-10-02_git-says-what-changed`
- **What it blocks:** nothing is cut by it. R-16 leaves the choice to "the design of the change
  that builds the two refusals", and that choice is made.
- **Where it shows:** § 3, the `git-reader` row: "a `.gitmodules` the adapter cannot read answers
  the existing condition for an unreadable Git directory, as built, which § 11 R-16 names as a
  limit" (`docs/SDD.md:L348`). § 11 R-16 *Not covered, and named so it is not read as coverage*
  (`:L3353-L3363`), which says the case answers that condition and that which condition it answers
  "is not decided by this version". At `nozoki@772c63b` a `.gitmodules` that cannot be read for any
  reason but its absence (not permitted, a link, not a regular file, over the size bound) answers
  `GitReadCondition::GitmodulesUnreadable` on `status()` alone, at depth 0 of the walk
  (`crates/nozoki-core/src/git_reader/libgit2.rs:L285`; `git_reader.rs:L241`). A file a
  `.gitmodules` includes still answers the unreadable-Git-directory condition. The wire value is
  `gitmodules_unreadable` (`crates/nozoki-bridge/src/session.rs:L1621`), the log phrase "a
  .gitmodules could not be read" (`folder_model.rs:L263`), and the Git view draws "Nozoki couldn't
  read how a repository in the folder you opened names and places its submodules, so it doesn't
  read the folder's Git status. The file tree and the reading panel are unaffected."
  (`nozoki-mac/Sources/Surfaces/GitSentences.swift:L30-L33`), which does not say the Git directory
  could not be read — § 4 C-E4's "never a cause the tool did not observe". The case is
  `test_unreadable_gitmodules_answers_gitmodules_unreadable` (`crates/nozoki-core/tests/git_state.rs:L2950`).
  This departs from ADR-0022's *Decision* line on the check's own reads, which is raised on the
  architecture companion.
- **If a document has to be written:** none. A change in `SDD.md` § 3 and § 11 R-16, written by
  `product-sdd`.
- **Answer:** <the owner fills this in>

### 5.3 § 11 R-16 says the set of paths the status read looks up is measured by the change that builds the refusal, and it has been measured: the index's gitlinks, and nothing more
- **Raised by:** PM — 2026-10-07
- **Seat:** cto
- **Tracked by:** `nozoki · nemawashi · 2026-10-02_git-says-what-changed`
- **What it blocks:** nothing is cut by it. R-16 states that a working-tree folder holding `.git`
  with no gitlink "is looked up by its path too", from three source lines "read and not run", and
  that measurement disagrees.
- **Where it shows:** § 11 R-16 *Which paths the status read looks up* (`docs/SDD.md:L3332-L3337`)
  and *Open Questions*, the config-named-path item, which names the measurement as a thing the
  building change settles (`:L7916-L7918`). The measurement, against `libgit2-sys 0.18.8+1.9.7`
  (`Cargo.lock:L122-L123`), watched for an open with a FIFO at the other location's `.git/config`
  in a committed repository, with a positive control that did see an opener. Two candidate kinds
  were run, each with a section whose path names another location: (i) a working-tree folder
  holding `.git` with no gitlink, and (ii) a gitlink in HEAD's tree that the index no longer holds.
  Neither saw an opener, so the looked-up set is the index's gitlinks alone, and the refusal tests
  that set. A FIFO at `.git/HEAD`, the method R-16's wording implies, sees no opener even in the
  positive control, because libgit2 does not open that `.git` as a repository. The status read at
  an entry's own location, with no section, opened nothing in either kind. The finding is held by
  `test_looked_up_kinds_the_measurement_found_are_refused`
  (`crates/nozoki-core/tests/git_state.rs:L3017`), a case over kind (i) that answers the lists with
  no opener at the other location. The likely fold: the paragraph states the measured set, its
  method and its `libgit2-sys` version, and keeps the three source lines as what was read.
- **If a document has to be written:** none. A change in `SDD.md` § 11 R-16 and *Open
  Questions*, written by `product-sdd`.
- **Answer:** <the owner fills this in>

### 5.4 § 11 R-16 *The sixth member* quotes an adapter comment that no longer exists, and does not say what a section with no `path` key is refused under
- **Raised by:** PM — 2026-10-07
- **Seat:** cto
- **Tracked by:** `nozoki · nemawashi · 2026-10-02_git-says-what-changed`
- **What it blocks:** nothing is cut by it.
- **Where it shows:** § 11 R-16 *The sixth member*: "The adapter's own comment says of this file
  that "only includes follow paths" (`libgit2.rs:L236-L237`)" (`docs/SDD.md:L3281-L3282`).
  `git grep -n -i 'only includes follow' 772c63b -- crates` prints nothing. *Its spelling and its
  refusals* (`:L3283-L3295`) says a refusal carries the key and the path as the file spells them,
  and a section with no `path` key has neither. At `nozoki@772c63b` such a section is decided on its
  name, and the refusal carries the section word as the file writes it as the key and the name as
  the path: `[submodule "../outside-n"]` answers `ConfigNamesOutside` with key `submodule` and path
  `../outside-n`, never `submodule.../outside-n.path`
  (`test_name_only_section_naming_a_path_outside_is_refused_with_the_section_word_as_key`,
  `crates/nozoki-core/tests/git_state.rs:L2748`). Every value is spelled from the working tree of the
  repository whose `.gitmodules` holds it, sections in included files too
  (`test_a_section_in_an_included_file_is_decided_and_spelled_from_the_levels_working_tree`,
  `:L2893`). The likely fold: the quoted comment goes to a dated note, and the spelling paragraph
  names the key a name-only section carries.
- **If a document has to be written:** none. A change in `SDD.md` § 11 R-16, written by
  `product-sdd`.
- **Answer:** <the owner fills this in>
