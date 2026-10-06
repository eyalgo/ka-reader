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

> **No `product-sdd` run wrote this file.** The PM opened it on 2026-10-06 from the SDD's own
> companion template. The alternates check R-16 describes is now built (`nozoki@66f428d`), and the
> SDD reads differently from what was built and measured in three places: R-16 and the *Open
> Questions* item still say the alternates check and its case are not built and are owed, the
> `read-only-harness` row counts eleven fixture folders where there are twelve, and the alternates
> condition says *outside* for an entry the adapter does not locate, which RN-101 ruled out for the
> config condition's matching case. The SDD is Settled, and with no companion on disk a
> `product-sdd` re-run reads it as done and has nothing to act on. Its three items are in § 5.

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

### 5.1 R-16 and the *Open Questions* item say the alternates check and its case are not built, and both are in the tree
- **Raised by:** PM — 2026-10-06
- **Seat:** cto
- **Tracked by:** `nozoki · nemawashi · 2026-10-02_git-says-what-changed`
- **What it blocks:** nothing is cut by it. A reader of R-16 is told the alternates read is a stated
  limit with nothing bounding it in the harness, and that is no longer true.
- **Where it shows:** four passages, each measured at `nozoki@2d7692c` or `nozoki@3b6754d`.
  § 11 R-16, the paragraph before *Not covered*: "A third case holds the alternates check … and it
  is still owed" (`docs/SDD.md:L3316-L3319`). *The proof*: "No fixture carries an alternates file
  … Until the case exists this read is a stated limit and not a held property" (`:L3392-L3396`).
  *Until the checks are built*: "The alternates check is not built … No build inside the slice
  bounds the alternates read before that check lands" (`:L3404-L3409`). *Open Questions*, the
  config-named-path item: "the sandbox stays the only bound on the alternates read" (`:L7478-L7479`).
  At `nozoki@66f428d` the check is `check_alternates`
  (`crates/nozoki-core/src/git_reader/libgit2.rs:L303`), called before the open behind `state()` and
  `status()` (`:L114`), on each verified submodule (`:L449`) and on the probe (`:L475`). The fixture
  is `checks/fixtures/alternates-names-outside` with its `.git.tar`, whose
  `.git/objects/info/alternates` is the one line `../../../elsewhere/objects`, and
  `crates/nozoki-core/tests/git_state.rs` holds the case over it. `cargo test --workspace --locked`
  passes, 499 tests, 0 failed. The case runs the adapter in-process. No case runs the check on the
  built bundle. The likely fold: the four passages re-measured at a current commit, with the
  *Open Questions* item left open on its `.gitmodules` case alone.
- **If a document has to be written:** none. A change in `SDD.md` § 11 and *Open Questions*,
  written by `product-sdd`.
- **Answer:** Take the fold, at six passages and not four. The alternates check and its case are
  in the tree, so every sentence of § 11 R-16 and of the *Open Questions* item that says they are
  not built, or still owed, is re-measured at the commit the fold reads. The *Open Questions* item
  stays open on its `.gitmodules` case alone.
  *Measured in this run*, at `nozoki@2309ba5`, whose tree outside `docs/` is `nozoki@66f428d`'s:
  `git diff --stat 66f428d HEAD` lists the two companion files and nothing else.
  `check_alternates` is defined at `crates/nozoki-core/src/git_reader/libgit2.rs:L303`. It is
  called at `:L114`, before `open_at` in the helper behind `state()` and `status()`; at `:L449`, on
  each submodule; and at `:L475`, on the probe. The fixture is
  `checks/fixtures/alternates-names-outside` with `alternates-names-outside.git.tar`, whose
  `.git/objects/info/alternates` holds the one line `../../../elsewhere/objects`. The case that
  meets *The proof*'s bar is `test_the_outside_object_directory_is_never_read_on_the_three_calls`
  (`crates/nozoki-core/tests/git_state.rs:L1733`). `cargo test --workspace --locked` printed 499
  passed and 0 failed.
  *The two passages the item does not list.* *Until the checks are built*: "For the alternates
  read the sandbox is still the only bound in the bundle … not a held property"
  (`docs/SDD.md:L3414-L3417`). *Open Questions*: "of its four cases two are still owed … So this
  item stays open on the alternates case and the `.gitmodules` case" (`:L7448-L7454`).
  *Three things the re-measured passages state*, so the read is not described as held further
  than it is. (1) What the case watches. It makes a FIFO at the outside object directory's
  `info/alternates` and asserts that none of the three calls opened it (`git_state.rs:L1715-L1726`,
  `:L1742-L1746`). It watches that one file. It does not watch a `stat` of the directory, which is
  the first thing libgit2 does to an alternate (`libgit2-sys 0.18.8+1.9.7`,
  `libgit2/src/libgit2/odb.c:L697`). That no `stat` is made rests on the order in the code, where
  the check runs before the open (`libgit2.rs:L112-L115`), and not on the case. (2) The case runs
  the adapter in-process, and no case runs the check on the built bundle. The alternates read is a
  held property in the harness, and on the bundle the check has not been run. (3) The past stays
  stated, in the past tense, as *Until the checks are built* states it for the config-named read:
  from the first build in which `mac-shell` calls `nozoki_read_git` until the tree at
  `nozoki@66f428d`, the sandbox was the only bound on the alternates read in the bundle, and
  nothing bounded it in the harness.
  *What is left.* The sandbox is the only bound on one read, the repository the submodule map
  opens outside the folder. The fourth case stays owed: `ls checks/fixtures` lists no fixture for
  it. § 3's `git-reader` row, § 4 C-D3 and § 6 S-4 state the alternates check without saying it is
  unbuilt, and they take no change from this item. Answer 5.3 changes what the condition says for
  one kind of entry and moves nothing here. Reasoning: `docs/trail/sdd/self_answer-50.md` § 5.1.

### 5.2 The `read-only-harness` row counts eleven fixture folders, and `checks/fixtures/` now holds twelve
- **Raised by:** PM — 2026-10-06
- **Seat:** cto
- **Tracked by:** `nozoki · nemawashi · 2026-10-02_git-says-what-changed`
- **What it blocks:** nothing is cut by it. The row says a file that lands in `checks/` after its
  pinned commit owes this row an item, and this is that item.
- **Where it shows:** § 3, the `read-only-harness` row, "eleven fixture folders" measured at
  `nozoki@2d7692c` (`docs/SDD.md:L354`). `ls checks/fixtures` at `nozoki@66f428d` also lists
  `alternates-names-outside` and `alternates-names-outside.git.tar`, R-16's alternates fixture: a
  repository whose `objects/info/alternates` names an objects directory outside the fixture.
  `git_state.rs` unpacks it and `root_finding.rs` does not. The likely fold: the row re-measured at
  a current commit, with the alternates fixture named beside the two config fixtures.
- **If a document has to be written:** none. A change in `SDD.md` § 3, written by `product-sdd`.
- **Answer:** Take the fold. The row's count reads twelve, its pin moves to the commit the fold
  measures at, and `alternates-names-outside` is named beside the two config fixtures as § 11
  R-16's third, with the suite that reads it. Nothing else in the cell moves.
  *Measured in this run*, at `nozoki@2309ba5`. `ls -d checks/fixtures/*/` lists twelve folders,
  and the one the row does not name is `alternates-names-outside`, with
  `alternates-names-outside.git.tar` beside it. `git diff --stat 2d7692c HEAD -- checks` lists two
  files, that archive and `checks/fixtures/alternates-names-outside/README.md`. So the scripts,
  their lists and helpers, the eight suites under `checks/tests/` and the other eleven folders
  stand as the row states them. `crates/nozoki-core/tests/git_state.rs` unpacks the archive
  (`:L1736-L1739`, `:L1753-L1756`), and `grep -c alternates
  crates/nozoki-core/tests/root_finding.rs` prints 0.
  *One sentence the row gains for this fixture.* The tracked folder holds a `README.md` and
  nothing else, and the repository is in the archive: `git ls-files checks/fixtures | grep
  alternates` prints those two paths. The row says so, as it says what each scene archive holds.
  The sentence in § 11 R-16 that names "Two such fixtures" (`docs/SDD.md:L3081-L3084`) counts
  fixtures whose config carries a member key. The alternates fixture is not one of those, and
  that sentence takes no change. Reasoning: `docs/trail/sdd/self_answer-50.md` § 5.2.

### 5.3 The alternates condition says *outside* for an entry the adapter does not locate, which the config condition does not
- **Raised by:** PM — 2026-10-06
- **Seat:** cto
- **Tracked by:** `nozoki · nemawashi · 2026-10-02_git-says-what-changed`
- **What it blocks:** the Git view's sentence for an alternates entry that begins with neither `.`
  nor `/`. Nothing can be written for it that is true in every case until the SDD says what the
  adapter observed there.
- **Where it shows:** R-16 *The spellings follow libgit2's own rule* says such an entry is passed on
  as written, so "the operating system resolves it against the process's working directory and not
  against the folder, and it is refused as outside" (`docs/SDD.md:L3369-L3372`). § 6 S-4 *Reached
  when*, the alternates passage, then has the item say the object store "names a location outside
  the folder they opened" for every refusal (`:L1870-L1876`), and § 3's `git-reader` row gives one
  condition with no observation beside it (`:L345`). For the config check's matching case, a
  relative `core.excludesfile` or `core.attributesfile` that "has no base" (`:L3145-L3147`), the
  same document says the item "does not say the path is outside the folder, because the tool did not
  observe that" (`:L1855-L1863`; RN-101). The two passages disagree on one kind of value. In the
  product: such an entry is classed `Outside` with no location found
  (`crates/nozoki-core/src/git_reader/alternates_scan.rs:L12-L14`, `:L47`); the case for
  `relative/objects` answers the alternates condition (`crates/nozoki-core/tests/git_state.rs:L1781-L1787`);
  and the shipped sentence says "Nozoki found a Git object store that names {path}, outside the
  folder you opened" for it (`nozoki-mac/Sources/Surfaces/GitSentences.swift:L58-L61`). If the
  process's working directory were the opened folder, the entry would lead inside it and the
  sentence would be false. The § 6 passage is the CDO's clause, so its wording follows the CTO's
  answer on what is observed. The likely fold: either the alternates condition gains the config
  condition's second observation for this kind of entry, or R-16 states why *outside* is observed
  here and not for a relative excludes file.
- **If a document has to be written:** none. A change in `SDD.md` § 3, § 6 S-4 and § 11 R-16,
  written by `product-sdd`; the sentence itself is then `docs/CONTENT.md`'s.
- **Answer:** The alternates condition gains the config condition's second observation. For an
  entry that begins with neither `.` nor `/`, the adapter observes the form alone: the
  repository's object store names a location the adapter does not locate. For that entry the
  condition does not say *outside*. Every entry refused today stays refused.
  *Why not the other fold.* R-16 cannot state why *outside* is observed for this entry, because
  it is not observed. The adapter classes the entry by its first byte and reads nothing
  (`crates/nozoki-core/src/git_reader/alternates_scan.rs:L43-L48`), and it refuses the entry
  before spelling any location (`crates/nozoki-core/src/git_reader/libgit2.rs:L350-L352`). Where
  such an entry leads depends on who reads it. libgit2 passes it on as written (`libgit2-sys
  0.18.8+1.9.7`, `libgit2/src/libgit2/odb.c:L800`), so the operating system resolves it against
  the process's working directory, and `git-reader` reads no working directory: `grep -rn
  'current_dir\|getcwd\|set_current_dir' crates nozoki-mac/Sources` prints three lines, all under
  `tests/`. Git reads the same entry from the object directory that holds the file. Its
  documentation says relative paths are "relative to the object database"
  (`https://git-scm.com/docs/gitrepository-layout`, `objects/info/alternates`), and under git
  2.54.0 an entry `store` was read from `.git/objects/store`
  (`docs/trail/sdd/self_answer-50.md` § 5.3, *The measurement*). So the entry has two places it
  can lead, the adapter locates neither, and the place Git reads lay inside the folder in that
  measurement. § 4 C-E4's precedent does not reach this entry, for the reason R-16 gives for the
  two config forms (`docs/SDD.md:L3128-L3131`): the scanner tells it apart with no read.
  *Locating the entry was not taken.* Spelling it from the working directory follows libgit2 and
  makes the answer depend on what launched the process. Spelling it from the object directory
  follows Git and checks a place libgit2 does not read. Under either, a pass lets libgit2 `stat`
  a place the adapter did not check. The refusal stays.
  *What each part says.* § 11 R-16, "A third way out": *The condition* states the two
  observations, and *The spellings* says such an entry "is refused without being located" in
  place of "is refused as outside". The first observation stands for an entry spelled from the
  object directory, for an absolute entry, and for a link at `objects`, `info` or `alternates`.
  The adapter spells each of those to a location and finds it outside the folder
  (`libgit2.rs:L354-L357`, `:L388-L392`). The condition carries which of the two was observed,
  beside the entry as the file spells it, on the probe, on both reads and for a submodule, and it
  crosses SM-2, SM-4 and SM-8 with them. Whether that is a field on the one condition or a second
  condition is the design of the change that builds it. § 3's `git-reader` row and § 4 C-D3
  follow. § 6 S-4 *Reached when*, observable half, gains the second observation beside the first.
  That clause is the CDO's, and it follows from `docs/UXD.md` UX-S3's Error cell, "that item shows
  what the tool observed" (`:L241`), as the config passage did.
  *Four cases the answer reaches.* (1) The form is every entry whose first byte is neither `.` nor
  `/`. A leading space or a leading `~` puts an entry in it, because nothing is trimmed and
  nothing is expanded (`alternates_scan.rs:L24-L27`; `odb.c:L789-L800`). (2) Such an entry is
  refused whether or not anything is there. *What is not a refusal* lets pass an entry "that
  spells inside the folder with nothing there" (`docs/SDD.md:L3374-L3375`), and that sentence does
  not reach an entry the adapter does not locate. (3) Where a file holds entries of both kinds,
  the condition carries the first refused entry met, in the order the check reads, with that
  entry's observation (`libgit2.rs:L292-L297`). (4) *What the refusal costs a reader* gains one
  case: a repository whose alternates file carries such an entry shows a failed Git item where
  `git status` in a terminal works, because Git reads the entry from the object directory.
  **A known defect, until a change lands.** At `nozoki@66f428d` the adapter answers one condition
  for both observations (`crates/nozoki-core/src/git_reader.rs:L216-L221`;
  `alternates_scan.rs:L12-L14`). The case for `relative/objects` asserts that condition
  (`crates/nozoki-core/tests/git_state.rs:L1781-L1788`). The shipped sentence says "outside the
  folder you opened" for it (`nozoki-mac/Sources/Surfaces/GitSentences.swift:L58-L62`), and the
  model's phrase says "the object store names a location outside the folder"
  (`crates/nozoki-core/src/folder_model.rs:L235-L236`). For an entry that leads into the opened
  folder those words are false. The refusal itself holds. R-16 names this beside the claim, as it
  does for the config sentence. The second sentence's words are `docs/CONTENT.md`'s, under its
  rule that "A message says what Nozoki observed" (`:L62`).
  This item is raised from downstream and asks the SDD for a form it does not state. It is taken
  because the item cites where the form occurs in the product. Reasoning:
  `docs/trail/sdd/self_answer-50.md` § 5.3.
