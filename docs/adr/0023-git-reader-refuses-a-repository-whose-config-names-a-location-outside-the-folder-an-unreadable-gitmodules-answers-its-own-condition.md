# ADR-0023: `git-reader` refuses a repository whose Git config, `.gitmodules` or alternates file names a location outside the folder — by a check of its own, read inside the folder before libgit2 reads what that file names — and a `.gitmodules` the check cannot read answers a condition of its own

**Status:** Accepted — supersedes ADR-0022
**Date:** 2026-10-07

## Context

ADR-0022 decided how `git-reader` keeps libgit2 from following a path that a repository's own files
name outside the folder. One line of its *Decision* gave every file the check cannot read the
condition for an unreadable Git directory
(`docs/adr/0022-git-reader-refuses-a-repository-whose-config-names-a-location-outside-the-folder.md:L58-L60`).

That line no longer holds for one file. In `docs/SDD.md` v46 the CTO gave a `.gitmodules` the
adapter cannot read a condition of its own, `GitmodulesUnreadable`, and kept the unreadable-Git-directory
condition for a file that `.gitmodules` includes (§ 11 R-16, *Not covered, and named so it is not
read as coverage*, under *The sixth member*; RN-106 (1)). The change that built the `.gitmodules`
refusals built it (`nozoki@772c63b`). The ground is § 4 C-E4, "Never a cause the tool did not
observe". `.gitmodules` lies in the working tree, not in the Git directory, so the sentence for an
unreadable Git directory would name a cause the tool did not observe. RN-106 surfaced the departure
for this seat to record. The PM raised it on this log's companion, and the owner's seat chose a
superseding record over an in-place amendment and over no record
(`docs/trail/architecture/cycle-39.md` § 3.2).

The forces ADR-0022 recorded stand, and are restated so this record reads alone. The product reads
nothing outside the viewed folder except its own data location (`docs/fdr.md` R-101, `:L188`), and
`docs/SDD.md` § 4 C-D1's *Violated by* names any such read. ADR-0020 switched off libgit2's four
machine-level config levels. A path the repository's own config names is content, written by
whoever wrote the folder (§ 4 C-D3). Three facts made its closing a decision rather than a default:

- libgit2 has no option that stops these paths being followed (`libgit2-sys 0.18.8+1.9.7`,
  `libgit2/include/git2/common.h:L214-L262`, as SDD v42's *Open Questions* config-named-path item
  read it; SDD v46 removed that item once everything in it was built, RN-106 (7)).
- The paths are many, not three. § 11 R-16 states the domain as a rule — every path libgit2 takes
  from a config file it loads for the repository, during the open, the state read and the status
  read — and measures six members at that libgit2 version: `include.path`,
  `includeIf.<condition>.path`, `core.worktree`, `core.excludesfile`, `core.attributesfile`, and
  `submodule.<name>.path` in `.gitmodules`, which libgit2 loads as config during the status read
  and not during the open.
- A second way out is not config at all: `objects/info/alternates`, whose entries libgit2 adds as
  object stores with no containment check (§ 11 R-16, "A third way out").

## Decision

**`git-reader` reads, itself, every file in the domain, inside the folder, and refuses the
repository where one names a location outside it — before libgit2 reads what that file names.** The
adapter's reads use its own spelling walk, which follows `fs-reader`'s containment rule and reads
nothing at a position outside the folder (`docs/SDD.md` § 3, the `git-reader` row).

- **Where each check runs.** The config check runs before the probe's open and before the open
  behind `state()` and `status()`: the repository's `config`, `config.worktree` where
  `extensions.worktreeConfig` is set, and every file those include that spells inside the folder,
  to libgit2's include depth of ten. The alternates check runs where the config check runs, to
  libgit2's depth of five. The `.gitmodules` check runs after the open and before the status read,
  on `status()` alone, in the working tree of the repository and of each submodule it verifies.
  Each submodule the status read can open is verified first (its locations, its config, its
  alternates). The status read never runs with a submodule left out.
- **A refusal, never a follow and never a verify-and-allow.** A value that spells outside the
  folder refuses. A value in a form the adapter does not locate refuses as *not located*, not as
  *outside*: a value beginning `~/` under the five keys named first, a relative
  `core.excludesfile` or `core.attributesfile`, a `.gitmodules` section path beginning `/`, and an
  alternates entry beginning with neither `.` nor `/`. An `includeIf` path that spells outside the
  folder, or is in a form the adapter does not locate, refuses whatever its condition, and the
  condition is not evaluated. One that spells inside the folder is followed, as an inside include
  is. Where a `.gitmodules` section would make the status read open, or report, another location
  for a path that read looks up, the read is refused.
- **Each refusal is a condition of its own that states what was observed.** A refusal of a value
  is never the read-failed condition, because no read of what the value names was tried. The Git
  item is `failed` with it, the tree and the panel stand, and the log line holds no path. The
  check's own reads answer the conditions that already exist, with one exception. A file the check
  cannot read answers the condition for an unreadable Git directory, **except a `.gitmodules` at
  depth 0 of a level's walk** — the repository's, or a verified submodule's. When that file cannot
  be read for any reason but its absence — the read is not permitted, it is a link, it is not a
  regular file, or it is over the size bound — it answers `GitmodulesUnreadable`, on `status()`
  alone, and the Git item is `failed` with it. A file that the `.gitmodules` includes keeps the
  unreadable-Git-directory condition. An absent file, at any depth, is skipped. A config the check
  cannot parse to the end as Git's syntax answers the read-failed condition, because it cannot
  prove what libgit2 would follow.
- **The domain is pinned to one libgit2 version.** A `libgit2-sys` version change re-measures it in
  the lockfile review `docs/SDD.md` § 4 C-R6 already requires.

## Alternatives ruled out

*(The first eight are the SDD's own weighing, transcribed from ADR-0022. The last two are the
choice this record makes, weighed in the owner's seat. None is this seat's own.)*

- **A libgit2 setting that stops the paths being followed** — none exists. SDD v42's *Open
  Questions* config-named-path item named this as the first of its two forms and closed it on that
  ground.
- **The sandbox as the only bound** — it holds in the shipped bundle, and whether libgit2's open or
  status read survives its refusal has not been run. Nothing bounds the read in the in-process
  harness, so the promise would hold in one configuration and not the other. For a `.gitmodules`
  section that names another location *inside* the folder, the sandbox bounds nothing in either
  (§ 11 R-16, *The status read and the submodule map*).
- **Accept the reads and lower R-101** — a product promise, and the owner's to lower, which is
  ADR-0020's ground for the machine levels too. No seat took it.
- **Exclude submodules from the status read** — a submodule whose commit moved would leave the
  changed list while `git status` lists it, against `docs/SRS.md` FR-12. Moving a settled
  requirement is not the SDD's to do (§ 11 R-16, *Submodules are in the domain*).
- **Locate a `~/` value through the home directory** — `git-reader` reads no home directory, which
  home libgit2 takes inside the sandboxed bundle was not read, and where the folder lies under the
  home directory a condition saying *outside* would be false (§ 11 R-16, *Why the two forms are not
  located*; `docs/trail/sdd/cycle-36.md` § 5.1).
- **Verify the other repository a `.gitmodules` section points to, then run status** — restores
  containment and leaves the list reporting another repository's state under the gitlink's name.
  This is the SDD's argument; it reads such a list as the failure the row already refuses when it
  will not run status with a submodule left out (§ 11 R-16, *The response*;
  `docs/trail/sdd/cycle-37.md` § 2.1).
- **Evaluate an `includeIf` condition and refuse only a match** — refusing whatever the condition
  stays true across a libgit2 version that adds a condition. Its cost is refusing a repository
  whose condition would not have matched (§ 11 R-16, *The spellings*).
- **Answer a refusal with the read-failed condition** — that condition reports a read that was
  tried. Here none is, and § 4 C-E4 holds "Never a cause the tool did not observe".
- **Keep the unreadable-Git-directory condition for an unreadable `.gitmodules`** — ADR-0022's
  line, and one condition fewer to carry across three seams. It loses on C-E4: `.gitmodules` lies
  in the working tree, and the shipped sentence for that condition says the Git directory could not
  be read, a cause the tool did not observe (§ 11 R-16, *Not covered*;
  `nozoki-mac/Sources/Surfaces/GitSentences.swift:L26-L28`).
- **Amend ADR-0022's line in place, or leave it and let the SDD state the exception** — the first
  rewrites an Accepted record, which this log never does (`docs/adr/README.md:L4-L5`). The second
  keeps a present-tense rule in an Accepted *Decision* that is false of the product. The delivery
  tier reads that record as fixed, so a later change could cite it to move the condition back
  (`docs/trail/architecture/cycle-39.md` § 3.2).

## Consequences

Easier: R-101 holds in the in-process harness, not only in the bundle, for what the checks cover,
and the harness can observe it. Six cases watch the one outside path each scene names, through a
FIFO whose non-blocking open succeeds only once a reader holds it
(`crates/nozoki-core/tests/git_state.rs:L1155-L1206`): the repository's config
(`test_no_answer_reads_the_path_the_config_names_outside`, `:L1212`), a submodule's config
(`:L1228`), an include from `.gitmodules` (`:L1795`), an include through an inside link
(`:L1886`), the outside object directory's `info/alternates`
(`test_the_outside_object_directory_is_never_read_on_the_three_calls`, `:L1995`), and a
`.gitmodules` section leading through a link to a repository outside the folder
(`test_section_leading_through_a_link_to_an_outside_x_opens_nothing_outside`, `:L2680`, over
`checks/fixtures/gitmodules-names-outside`). `cargo test --locked -p nozoki-core --test git_state`
printed 120 passed and 0 failed on a disposable copy of `nozoki@d90814b`, run for this record. The
six run the adapter in-process, and no case runs the check on the built bundle. A reader sees the
cause in the Git view instead of a status read from somewhere else. A reader whose `.gitmodules`
cannot be read is told so, in words that name no Git directory: "Nozoki couldn't read how a
repository in the folder you opened names and places its submodules, so it doesn't read the
folder's Git status. The file tree and the reading panel are unaffected."
(`nozoki-mac/Sources/Surfaces/GitSentences.swift:L30-L33`).

Harder: `git-reader` parses Git's config syntax itself (`crates/nozoki-core/src/git_reader/config_scan.rs`),
a second reader beside libgit2's, and the two must agree on what libgit2 would follow. The check and
libgit2's read are two reads, so a file rewritten between them is followed unchecked. A
`.gitmodules` readable at the check and unreadable at libgit2's read is that race, not a case of
its own. The sandbox bounds the race in the bundle, and nothing bounds it in the harness. A link
elsewhere inside the Git directory that leads out — a linked `HEAD`, `index` or `refs` — is covered
by no check. The submodule-map refusal is decided against the set of paths the status read looks
up, measured as the index's gitlinks at the pinned libgit2 version (§ 11 R-16, *Which paths the
status read looks up*; `SectionScope`, `crates/nozoki-core/src/git_reader/libgit2.rs:L223-L230`). A
libgit2 that looked up more would leave a section naming the extra path unchecked. And a reader
pays: a clone made with `git clone --shared` or `--reference` from outside the folder, a config
that includes `~/…`, or a `.gitmodules` that maps a submodule elsewhere shows a failed Git item
where `git status` in a terminal works. One condition more crosses three seams.

**Built and not built, at `nozoki@d90814b`** (one tree outside `docs/` with `nozoki@772c63b`;
`git diff --stat 772c63b d90814b -- . ':!docs'` prints nothing). Everything this record decides is
built. The config check (`check_config`, `crates/nozoki-core/src/git_reader/libgit2.rs:L201`) and
the alternates check (`check_alternates`, `:L440`) run before the open (`:L113-L114`), and the
alternates check was built at `nozoki@66f428d`. The submodule verification is `verify_submodules`
(`:L543`). The `.gitmodules` check, for its include keys and for every section, runs on `status()`
alone (`:L100-L104`). It is built at `nozoki@772c63b`: `check_section_value` answers
`ConfigNotLocated`, `ConfigNamesOutside` and `SubmoduleElsewhere` (`:L330-L358`), and
`unreadable_config_file` answers `GitmodulesUnreadable` at depth 0 (`:L280-L290`). The variant is
`crates/nozoki-core/src/git_reader.rs:L238-L241`, on the wire `gitmodules_unreadable`
(`crates/nozoki-bridge/src/session.rs:L586-L588`), and the shell's own case
(`nozoki-mac/Sources/Surfaces/GitItem.swift:L114`). `test_unreadable_gitmodules_answers_gitmodules_unreadable`
(`git_state.rs:L2950`) and `test_unreadable_included_file_keeps_git_directory_unreadable`
(`:L2990`) hold the exception and what it leaves. Not covered, and named so it is not read as
coverage: the two-reads race and the linked `HEAD`, `index` or `refs`, both above.

What undoing it costs: the conditions cross SM-2, SM-4 and SM-8 and carry sentences a reader sees
(`docs/CONTENT.md`), so removing the check changes the published surface as well as reopening
R-101 outside the bundle. Moving `GitmodulesUnreadable` back to the unreadable-Git-directory
condition changes a wire value the shell decodes and a sentence a reader sees.

**What this rests on, and whose it stays.** libgit2's maintainers hold every fact the domain is
measured from: which files it loads as config, its include depth of ten, its alternates depth of
five, its rule for spelling each key, its submodule map keyed by section name, and which paths its
status read looks up. The domain and the looked-up set are pinned to the version
`Cargo.lock:L122-L123` resolves. If that holder goes silent, the vendored copy stays as locked and
this check stays true of it. A lockfile change that moves `libgit2-sys` is where both are
re-measured, and a member it misses is a read this check does not refuse.

## Traces to

- `docs/SDD.md` at v46 (Settled) — § 3, the `git-reader` and `core-bridge` rows; § 4 C-D1, C-D3,
  C-E4, C-R6; § 6 `see-git-status`, *Reached when*, observable half; § 11 R-16 whole, and in it
  *Which paths the status read looks up*, *Built, and the cases that hold it* and *Not covered*
  under *The sixth member*, and "A third way out", *The condition*; § SDD Review Notes RN-87,
  RN-99 – RN-103, RN-105, RN-106 (its *Surfaced for the Principal Architect to record*, both
  items).
- `docs/trail/architecture/cycle-39.md` § 3.2 — the PM's item, and the answer in the owner's seat
  that chose this record and named what it carries (`docs/trail/architecture/self_answer-44.md`
  § 3.2). § 3.1 of the same cycle moves the constraint set's traces here.
- `docs/trail/sdd/cycle-34.md` §§ 5.1 – 5.4; `cycle-35.md` § 2.1; `cycle-36.md` §§ 5.1 – 5.4;
  `cycle-37.md` § 2.1; `cycle-41.md` §§ 5.1 – 5.3 — answered in the CTO's seat; the submodule-map
  measurement, `docs/trail/sdd/self_answer-49.md`, *The measurement*.
- `docs/fdr.md` R-101; `docs/SRS.md` FR-12.
- ADR-0022 — the record this one supersedes. Its decision is restated here whole, with the one
  line changed, so nothing in this record depends on that one being open. Its traces stand under
  this record: `docs/SDD.md` at v42, `docs/trail/architecture/cycle-37.md` § 2.1 and
  `docs/trail/architecture/self_answer-42.md`. ADR-0020 (the switch, and the read it left to this
  decision); ADR-0019 (the port and its one adapter); ADR-0018 (the probe reads only inside the
  folder).
- **Beyond the answer's words, one:** *Decision*'s list of forms the adapter does not locate gains
  the alternates entry beginning with neither `.` nor `/`. ADR-0022's list was pinned to SDD v42,
  where that entry was not yet a form of its own. This record traces to v46, where it is (§ 11
  R-16, "A third way out", *The condition*; RN-105), and it is built
  (`crates/nozoki-core/src/git_reader/libgit2.rs:L487-L491`). The rule it applies is ADR-0022's
  unchanged.
- The tree at `nozoki@d90814b`, read at the lines cited above.
- `libgit2-sys 0.18.8+1.9.7` — the lines cited are the SDD's, read there and not re-read for this
  record.
- Inputs read for this record: SDD Settled v46 · SRS Settled v12 · FDR Settled v10.

## Binds

QC-6, QC-15, QC-30, QC-35.
