# Self-answer report — `docs/SDD.md`

## Header

- **Companion:** `docs/SDD_open_issues.md`
- **Document:** `docs/SDD.md` (v40, Settled)
- **Decided by:** `<CORE>/../skills/companion/.claude/skills/companion-self-answer/prompts/rich.md` v1.3.1
- **Date:** 2026-10-06
- **Sources re-read:** libgit2's source, as vendored by `libgit2-sys 0.18.8+1.9.7` in the cargo
  registry (`libgit2-sys-0.18.8+1.9.7/libgit2/src/`), the version `Cargo.lock:L122-L123` resolves.
  Each line below was opened in this run.
  - `libgit2/config_file.c:L523-L530`: an include path beginning `~/` is expanded from the home
    directory, and any other path is joined to the directory passed in. `:L564-L578`: that
    directory is the directory of the including file. `:L755`: a conditional include that matches
    calls the same function. `:L826-L830`: both include keys are followed as the parser meets
    them.
  - `libgit2/repository.c:L403-L437`: `core.worktree` is looked up and resolved against the Git
    directory, and those lines expand no `~/`. `util/fs_path.c:L379-L391`: a value that is not
    rooted is joined to that base.
  - `libgit2/attrcache.c:L322-L353`: a `core.excludesfile` or `core.attributesfile` value
    beginning `~/` is expanded from the home directory, and any other value is kept as written.
    `:L424-L430`: both keys are read through that function.
  - `libgit2/ignore.c:L245-L255`, `:L362-L368`: the excludes file is loaded with a null base.
    The matching load of the attributes file (`attr.c:L413`, `:L691`) was not opened.
  - `libgit2/sysdir.c:L640-L650`: the home expansion joins the file name to the home directory
    libgit2 finds.

  None of it was run. Each is a reading of the source.

**What this run read, and what it did not.** The companion was read whole. `docs/SDD.md` is 6,927
lines and was not read whole. The run read its header (`:L1-L30`), § 3 whole (`:L321-L522`), § 4
C-I3 (`:L752-L826`), C-D1 to C-D4 (`:L959-L1004`) and C-E4 (`:L1041-L1063`), § 6 S-4 whole
(`:L1785-L1922`), § 11 R-3, R-10 and R-16 (`:L2874-L2882`, `:L2920-L2927`, `:L2997-L3148`) and
*Open Questions* whole (`:L6808-L6927`). It searched the rest for `R-16`, `C-I3`, the fixture
names, `spelled from` and `six fixtures`, and read what that printed. A sentence elsewhere that
bears on these items in other words was not seen. `docs/CONTENT.md` was read at `:L62` and
`:L320-L350`, `docs/UXD.md` at `:L241` and `:L284-L286`, and `docs/trail/sdd/cycle-15.md` at
§ 5.1. `docs/SRS.md`, `docs/fdr.md` and `docs/nfdr.md` were searched for the fixture names and
`read-only.sh` and not read. `docs/PRD.md` was not opened. `docs/architecture_open_issues.md`,
`docs/trail/sdd/self_answer-46.md` and `docs/trail/sdd/self_answer-47.md` were read whole.

The product was read at `nozoki@d3f9e6a`, whose tree outside `docs/` is the tree at
`nozoki@fc14574`: `crates/nozoki-core/src/git_reader/config_scan.rs`, `checks/read-only.sh`,
`checks/walk.rs` and `nozoki-mac/Sources/Surfaces/GitSentences.swift` whole;
`crates/nozoki-core/src/git_reader/libgit2.rs:L76-L375`;
`crates/nozoki-core/tests/root_finding.rs:L1-L135`; and
`crates/nozoki-core/tests/git_state.rs:L1-L12`, `:L136-L158`, `:L712-L740` and `:L1180-L1254`.

Four things were run. `cargo test --locked -p nozoki-core --test git_state` on the two cases
answer 5.2 names. `tar -tf` on each archive in `checks/fixtures/`. A copy of each of the four
scene fixtures, made in a temporary folder outside the repository, with its archive unpacked
into it as `checks/read-only.sh:L73-L76` does. And `git diff --name-status 814a369 d3f9e6a --
checks`. `checks/read-only.sh` itself was not run, because its restore writes into
`checks/fixtures/`.

**How the widening rule was read.** All four items sit under *Raised from downstream*. Items 5.1,
5.2 and 5.3 each correct a statement measured false, which the prompt does not count as widening.
Item 5.4 asks which of three routes holds, and its answer narrows a clause and adds none. Each
item cites sites in the product by path and line, so none was answered "not until it occurs".

## Items worked

### 5.1 — The config refusal says the path is outside the folder for values the check refuses without locating them

- **Bucket:** 5. Raised from downstream — an item from a seat that did not write the SDD
- **Verdict:** answered
- **Why:** The condition states what the adapter observed. For a value it refuses without
  locating, that is the form of the value and not that the path is outside. No refusal changes.

  **Seat.** The item carries `Seat: cto`. The edit lands in `docs/SDD.md` § 11 R-16 and the
  places that repeat it, and it binds the port's contract. § 6 S-4's observable clause is the
  CDO's, and it follows from the condition: `docs/UXD.md` UX-S3's Error cell has a failed item
  show "what the tool observed" (`:L241`). That is one question with a wide consequence, so the
  item was not split.

  **The item's facts hold.** The scanner gives `Placement::Outside` to a value beginning `~/`
  under any key and to a relative excludes or attributes file
  (`crates/nozoki-core/src/git_reader/config_scan.rs:L175-L186`), and the adapter refuses that
  placement before it spells anything (`libgit2.rs:L264-L265`). The shipped sentence then says
  "outside the folder you opened" (`nozoki-mac/Sources/Surfaces/GitSentences.swift:L53-L57`). A
  reader whose folder is `~/proj` and whose config includes `~/proj/local.config` is told a path
  inside the folder is outside it. That reader can check the sentence against the path it
  prints.

  **Which fold.** The item offers two: one weaker statement for every refusal, or the two
  unlocated forms named apart. The second was taken. `docs/CONTENT.md:L331-L337` requires
  anything that leads outside the folder to be said as "outside the folder you opened". A
  located path does lead outside, so one weaker sentence for all would stop saying so where it
  is true. The cost is that the condition carries which observation was made across SM-2, SM-4
  and SM-8, and the catalogue gains a sentence. No new read is needed, because the scanner
  already separates the two.

  **Why the value is not located instead.** libgit2 expands `~/` from the home directory
  (`config_file.c:L526-L527`, `attrcache.c:L338-L339`, `sysdir.c:L640-L650`). Locating the value
  means the adapter finds that directory too. The crate's own source reads no environment
  variable for it (`grep -rn 'env::var\|HOME' crates/nozoki-core/src` prints only the prefix
  constant), and which directory libgit2 takes as home inside the sandboxed bundle was not read
  in this run. A relative excludes file has no base at all: libgit2 keeps the value as written
  and loads it with a null base (`attrcache.c:L341-L342`, `ignore.c:L362-L368`). This run reads
  that as the operating system resolving it against the process's working directory. That step
  is reasoning and was not run.

  **Why § 4 C-E4's precedent does not cover it.** C-E4 lets the outside sentence stand for three
  spellings that may lead in, on the owner's call, because telling them from a true outside takes
  a read outside the grant (`docs/SDD.md:L1051-L1060`; `docs/trail/sdd/cycle-15.md` § 5.1). The
  two forms here are told apart with no read. So the false sentence is not the price of § 4 C-D1,
  and the seat can correct it.

  **Failure paths.** A folder under the home directory with a `~/` path into it: the new
  statement is true there, and the old one was false. A submodule's config goes through the same
  step (`libgit2.rs:L331`), and so does the probe (`:L356`), so the observation crosses on all of
  them. A config rewritten between the check and libgit2's open is the case R-16 already names.
  Between now and the change that builds this, the shipped sentence still says outside for both
  forms. The answer has R-16 state that as a known defect, pinned to `nozoki@fc14574`.

  **Decided together with 5.3**, which names the same two forms in *The spellings*. Both say
  "refused without being located", and neither says "outside by rule".

  **What would have tipped it.** An owner's statement that the outside sentence may stand for
  these two forms as it does for C-E4's three. This run found none. The override, if the owner
  wants it, is one sentence in § 4 C-E4 naming the two forms beside the three, and no change to
  the condition.

  **The item's supporting text.** It says "nothing reads `HOME`". That holds for the crate's own
  source. libgit2's C reads `HOME` in-process in the harness (`checks/walk.rs:L16-L18`). The
  answer does not depend on the difference.

### 5.2 — The `read-only-harness` row counts nine fixture folders, and `checks/fixtures/` now holds eleven

- **Bucket:** 5. Raised from downstream — an item from a seat that did not write the SDD
- **Verdict:** confirmed with addition
- **Why:** The item's likely fold is taken: the row is re-measured at a current commit and names
  the two R-16 fixtures. The item has no draft slot, so its "likely fold" sentence was read as
  the draft. One thing is added.

  **Seat.** The item carries `Seat: cto`, and the edit lands in § 3's `read-only-harness` row.
  The row itself says a file landing in `checks/` after its pinned commit "owes this row an
  item" (`docs/SDD.md:L347`).

  **The measurement.** `ls checks/fixtures` at `nozoki@d3f9e6a` lists eleven folders and seven
  archives. `git diff --name-status 814a369 d3f9e6a -- checks` shows four added paths and no
  other added file: `config-names-outside/README.md`, `submodule-config-names-outside/README.md`
  and the two archives. Five files under `checks/` were modified between those commits. None was
  added, and the row enumerates files, so the enumeration gains the two fixtures and nothing
  else.

  **A correction to the likely fold's wording.** The fold says "named beside the four
  root-finding scenes". The two fixtures are not root-finding scenes. `git_state.rs` unpacks them
  (`:L1204-L1205`, `:L1220-L1224`), and `root_finding.rs` does not. The answer has the row say
  which suite reads them.

  **The addition.** The same landing made four other statements stale, and naming the fixtures in
  § 3 would leave § 11 saying no such fixture exists. R-16's *shows up as* says "No such fixture
  is in the tree" (`:L3013-L3015`). *The proof* says all three cases are owed (`:L3058-L3068`).
  *Until the checks are built* says no build bounds the config-named read (`:L3140-L3148`).
  *Open Questions* says the proof stays open (`:L6878`). Each is pinned to an older commit or
  written as a condition, so none is false as dated. A reader at v40 still takes from them that
  the config check has no case. Two cases exist and passed in this run at `nozoki@d3f9e6a`: the
  top-level one (`git_state.rs:L1202`) and the submodule-config one (`:L1218`). The alternates
  case does not exist, so the *Open Questions* item does not close on this answer.

  **Why this is an addition and not a raised item.** It is a re-measurement that follows from
  the answer itself and asks the fold for no decision. Raising it as its own item would hold the
  SDD open for one more round to confirm a count.

  **Not checked.** The two cases were run alone. The rest of the suite was not run. Whether the
  submodule half's second form, a submodule whose `.git` file names an outside path, is held by
  `test_a_submodule_with_an_outside_git_directory_fails_status_only` (`git_state.rs:L1343`) was
  not read. The answer leaves that to the fold's own re-read.

### 5.3 — R-16's spelling sentence gives every relative value the directory of its file, and only the include keys take it

- **Bucket:** 5. Raised from downstream — an item from a seat that did not write the SDD
- **Verdict:** confirmed with addition
- **Why:** The item's likely fold is taken, with its wording changed in one place and one case
  added. The "likely fold" sentence was read as the draft.

  **Seat.** The item carries `Seat: cto`. The edit lands in § 11 R-16 *The spellings* and binds
  only that section's agreement with the library and the adapter.

  **The item's facts hold, at the source.** The sentence at `docs/SDD.md:L3030-L3031` gives one
  base to every key and cites `config_file.c:L573-L578`. Those lines are inside `parse_include`,
  which only the two include keys reach (`:L826-L830`, `:L755`). `core.worktree` is resolved
  against the Git directory (`repository.c:L436-L437`). An excludes or attributes value is kept
  as written (`attrcache.c:L341-L342`), and the excludes file is loaded with a null base
  (`ignore.c:L362-L368`). The adapter's three placements match (`config_scan.rs:L175-L186`;
  `libgit2.rs:L264-L268`). So the SDD's sentence is wrong and the code is right, and the fold
  moves no code.

  **The wording changed.** The likely fold gives the excludes and attributes files "their
  outside-by-rule placement". Answer 5.1 settles that a value the check does not locate is never
  called outside. The two were decided together, and this answer uses 5.1's words: refused
  without being located.

  **The case added.** *The spellings* says "A value beginning `~/` is outside" for every key.
  libgit2 expands `~/` for four of the five keys (`config_file.c:L526-L527`,
  `attrcache.c:L338-L339`). For `core.worktree` the lines that resolve the value expand nothing,
  and a value that is not rooted is joined to the Git directory (`repository.c:L403-L437`;
  `util/fs_path.c:L387-L391`). The adapter refuses `~/` under all five (`config_scan.rs:L178`,
  with a test at `:L527-L535`). For `core.worktree` that is a refusal of a value libgit2 would
  have resolved under the Git directory. The answer keeps it. The adapter requires the opened
  working tree to be the folder (`libgit2.rs:L116-L123`), so that repository does not open as the
  folder's own with or without the refusal, and the config condition tells the reader which key
  caused it. The answer has R-16 state the difference so the section does not claim libgit2
  expands a value it does not.

  **The item's supporting text.** It says the same sentence stands in § 3's `git-reader` row.
  `grep -n 'spelled from the directory' docs/SDD.md` prints `:L3030` and no line of the row. The
  answer says the row needs no edit for this item. The row does repeat the refusal's statement,
  which answer 5.1 covers.

  **Not checked.** How libgit2 loads the attributes file (`attr.c:L413`, `:L691`) was not opened.
  The no-base statement is read for the excludes file and carried to the attributes file on the
  shared lookup at `attrcache.c:L322-L353`. No value under any key was run.

### 5.4 — C-I3's six-fixture walk restores four scene fixtures as scenes other than the ones they name

- **Bucket:** 5. Raised from downstream — an item from a seat that did not write the SDD
- **Verdict:** answered
- **Why:** Three scenes leave the walk's bar and are named as proved by the suites.
  `submodule` stays, described as the superproject the walk's restore builds. The item gives
  three routes and no lean, so this was decided from scratch. The answer is the item's second
  route for three fixtures and its third for one.

  **Seat.** The item carries `Seat: cto`. The edit lands in § 6 S-4's command half, which the
  SDD marks as the CTO's (`docs/SDD.md:L1852-L1853`, `:L1895-L1896`), and in § 4 C-I3. No
  settled input repeats the six-fixture clause: a search of `docs/SRS.md`, `docs/fdr.md` and
  `docs/nfdr.md` for the scene names and `read-only.sh` printed three NFDR lines, all about the
  layer-2 suites (`docs/nfdr.md:L215-L216`, `:L233`).

  **The item's facts hold, and reach further than it says.** The item says two of the four
  scenes miss the read they exist for. This run rebuilt all four in a temporary folder the way
  `checks/read-only.sh:L73-L76` restores them. None is the scene it names. `inside-a-repo`
  becomes a repository's root. `submodule` becomes the superproject. `linked-worktree` has no
  `.git` at its root. `parent-of-two` has none, and holds its repositories one folder further
  down. The archives are laid out for the suites, which unpack them at a scene's root with the
  fixture copied beneath it (`crates/nozoki-core/tests/root_finding.rs:L54-L59`).

  **The ground.** A walk fixture proves that nothing under the fixture folder changed
  (`checks/read-only.sh:L17-L20`, `:L84`). For a scene whose Git directory lies outside the
  opened folder, the place a wrong write would land is outside the hash. The suites hold that
  property with a wider instrument: they snapshot the whole scene root before and after the
  probe (`root_finding.rs:L22-L43`) and before and after `state` and `status`
  (`crates/nozoki-core/tests/git_state.rs:L146-L155`, `:L719-L738`). So the walk is the weaker
  proof for those scenes even when built correctly, and building them correctly in the script
  costs a second scene builder.

  **Why `parent-of-two` leaves too.** Its repositories lie inside the folder, so the hash could
  cover it. But the probe answers plain on it (`root_finding.rs:L113-L121`), and after a plain
  answer the walk's `read_git` asks nothing more (`checks/walk.rs:L5-L7`). The run adds nothing
  to the run on `plain`.

  **Why `submodule` stays.** § 11 R-16 says the status read opens each submodule's repository
  (`docs/SDD.md:L3048-L3050`). The restored `submodule` folder is the one fixture where that
  happens under the hash: on the temporary copy the index held the gitlink `submodule`,
  `submodule/.git` read `gitdir: ../.git/modules/submodule`, and `git status --porcelain`
  printed ` M submodule` and `?? README.md`. Dropping it would remove the only walk over a status
  read that meets a second repository. Keeping it costs one sentence that says what the run
  walks.

  **Check 3.** § 4 C-I3 says "no test of a slice's own stands in for `read-only.sh`"
  (`:L758-L759`). That sentence is about commands: the walk calls each exported command in the
  build that exports it. It still does, on `repo` and `plain`. C-I3 also says a fixture that
  offers a command nothing to act on "exercises nothing for that command" (`:L761-L763`), which
  is the rule the three dropped runs fail.

  **Failure paths.** The walk drops the Git answer (`checks/walk.rs:L288-L292`). Nothing asserts
  that `read_git` reaches the status read on the restored `submodule`. That is read from the
  layout and from `git status`, and was not run through the adapter. CI runs the walk on `plain`
  and `repo` alone (`.github/workflows/ci.yml:L68`, `:L71`), so the `submodule` run is made by
  hand until a change adds it. The answer has S-4 name both limits beside the clause. Which
  change closes them is the journey's.

  **Where this was closest to a different verdict.** The item's third route, with all six runs
  kept and each described for what it walks. It costs no edit outside the SDD. It was refused
  because three of those runs prove nothing that `plain` and `repo` do not, and a bar that lists
  them invites a reader to count them as coverage. An owner who wants the six runs kept for
  their own sake overrides with that route.

  **Not decided here.** Whether the changed promise clause is a § 10 re-cut entry. That is the
  fold's reading of the template's own rule.

## Left for the owner

None this run.

## Skipped

- **`docs/nfdr.md`** — nothing was appended to `docs/architecture_open_issues.md`. The config
  reads QC-15 does not list are already raised there (§ 3.2). No answer in this run makes an
  NFDR statement false before the SDD is folded, and the Principal Architect re-derives the
  record from the folded SDD.
- **`docs/CONTENT.md`** — no companion was opened on it. Answer 5.1 needs one more catalogue
  sentence, which a change writes under the standing rule at `docs/CONTENT.md:L62`. No rule in
  that document is made false.
- **A case asserting the Git answer on the restored `submodule` fixture** — named in answer 5.4
  as not held, and not raised as an item of its own.

## Companions opened

None this run.

## Launchers owed

- **`docs/SDD.md`** — `<CORE>/launchers/skill/launcher.sh product-sdd nozoki`
