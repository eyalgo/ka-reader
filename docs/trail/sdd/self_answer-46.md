# Self-answer report — `docs/SDD.md`

## Header

- **Companion:** `docs/SDD_open_issues.md`
- **Document:** `docs/SDD.md` (v38, Settled)
- **Decided by:** `<CORE>/../skills/companion/.claude/skills/companion-self-answer/prompts/rich.md` v1.3.1
- **Date:** 2026-10-04
- **Sources re-read:** libgit2's source, as vendored by `libgit2-sys 0.18.8+1.9.7` in the cargo
  registry (`libgit2-sys-0.18.8+1.9.7/libgit2/`), the version the items cite. Each line below was
  opened in this run.
  - `src/libgit2/config_file.c:L25`, `:L848`: an include depth of ten. `:L523-L530`: a path
    beginning `~/` is expanded from the home directory, any other is joined to the including
    file's directory. `:L564-L590`: `parse_include` reads the included file. `:L600-L640`: the
    `gitdir` conditions compare strings and read nothing. `:L661-L690`: `onbranch` reads `HEAD`
    in the Git directory. `:L826-L830`: `include.path` and `includeif.*.path` are followed as the
    parser meets them.
  - `src/libgit2/repository.c:L406`, `:L436`: `core.worktree` is looked up and resolved during
    the open. `:L997-L999`: the open takes a config snapshot. `:L1297-L1308`: the repository's
    `config` is loaded, then `config.worktree` where the extension is set.
  - `src/libgit2/attrcache.c:L424-L430`: `core.attributesfile` and `core.excludesfile` are looked
    up as paths. `repository.c:L2576` and `mailmap.c:L370`: the two other path-valued config
    reads, neither on the open, state or status path.
  - `include/git2/common.h:L214-L262`: the option list holds no option that turns includes off.
  - `src/libgit2/diff_generate.c:L745-L754`: with submodules ignored the diff returns before any
    lookup. `:L668-L671`, `:L881-L882`: a gitlink entry leads to a submodule lookup and status.
    `src/libgit2/submodule.c:L1270`, `:L1878-L1884`, `:L1658`: those open the submodule's
    repository.
  - `src/libgit2/odb.c:L761-L803`: the alternates file is read and each entry is added as an
    object store.

  None of it was run. Each is a reading of the source.

**What this run read, and what it did not.** The companion was read whole. `docs/SDD.md` is 6,569
lines and was not read whole. The run read its headings, § 3's parts table (`:L319-L346`), the
`GitState` entity (`:L486-L512`), § 4 C-D1 to C-D3 (`:L959-L991`), § 6 S-4 whole (`:L1777-L1900`),
§ 11 whole (`:L2835-L2999`) and *Open Questions* whole (`:L6464-L6569`). It searched the rest for
`R-16`, `submodule`, `core.worktree`, `includeIf`, `RepositoryReadFailed`, `QC-15`, `alternates`
and the two forms, and read what that printed. A sentence elsewhere that bears on these items in
other words was not seen. The halt report and `change_spec.md:L55-L175` were read at the instance's
commit `e414dc2`. `docs/nfdr.md` was read at `:L440-L470`, `docs/SRS.md` at `:L139-L143`,
`:L202-L207`, `:L220-L224` and `:L297-L300`, `docs/fdr.md` at `:L136-L137` and `:L184-L192`, and
`docs/CONTENT.md` at the lines a search for `outside the folder` and `UX-S3` printed. The adapter
was read at `crates/nozoki-core/src/git_reader/libgit2.rs:L1-L140`, `:L330-L365` and `:L490-L520`,
at `nozoki@8b50506`. No test was run.

**How the widening rule was read.** All four items sit under *Raised from downstream*, and each
asks the SDD to state something it does not state now. The prompt answers such an item "not until
it occurs" unless it cites an occurrence. Each item does:

- 5.1 and 5.2 cite a measured failure. The build at `nozoki@de11388` reads a path that
  `include.path` and `core.excludesfile` name outside the folder (`change_spec.md`, *Verified
  Claims*), and the design could not land (the halt report).
- 5.3 and 5.4 cite sites. The path-following code is in the library the product links, and the
  status read that leaves submodules on is at `libgit2.rs:L346-L357`.

A library line in the cargo registry was taken as a site in the product, because it is compiled
into `nozoki-core`. A stricter reading would have answered 5.3's two keys "not until it occurs",
since neither was run. That is the place this run was closest to a different verdict.

## Items worked

### 5.1 — R-16's second form: which condition does the refusal answer — `RepositoryReadFailed`, or a new one that names the cause?

- **Bucket:** 5. Raised from downstream — an item from a seat that did not write the SDD
- **Verdict:** answered
- **Why:** A new condition that names the cause, on the probe and on the reads.

  **Seat.** The edit lands in `SDD.md`'s `git-reader` row and § 11 R-16, and binds only the
  port's contract. It is the CTO's.

  **The ground.** Reuse costs less: no new words, and the change touches one part. It was
  refused because the message would be false. `RepositoryReadFailed` reports a read that was
  tried and failed, and under the second form the adapter tries none. `docs/CONTENT.md:L62` holds
  a message to what Nozoki observed, and `:L331-L342` fixes the sentence for anything outside the
  folder. § 6 S-4 asks that a failed Git item show what was observed
  (`docs/SDD.md:L1815-L1816`). § 11 R-3 already gives the outside Git directory a condition of
  its own (`:L2851-L2859`). A reader whose repository config includes a file in their home
  directory would otherwise see "could not be read" and have nothing to act on.

  **What it costs.** The change publishes text. It reaches `folder-model`, `core-bridge` and the
  shell's Git item, as the halt report lists. The message's words are the Content Editor's, under
  the standing rule in `docs/CONTENT.md`; that document needs no change, so no item was raised on
  it.

  **The probe.** The probe's open loads the same config (`libgit2.rs:L500-L508`), so it refuses
  alike and the root finding is failed with the cause. `docs/UXD.md` UX-I16 already draws a
  stopped finding in the Git view's slot.

  **Failure paths.** An unreadable config answers the existing unreadable condition. A config the
  adapter cannot parse to the end is refused, because it cannot prove what libgit2 would follow.
  One case is not covered and is named in the answer: the check and libgit2's open are two reads,
  and a config rewritten between them is followed unchecked. The sandbox bounds that in the
  bundle and nothing bounds it in the harness.

  **What would have tipped it.** A rule that the change must stay inside `git-reader`. No
  document states one.

### 5.2 — What may the second form's check read beyond libgit2: an *inside* include that sits in the working tree?

- **Bucket:** 5. Raised from downstream — an item from a seat that did not write the SDD
- **Verdict:** answered
- **Why:** The check reads every config file libgit2 would load for the repository, anywhere
  inside the folder, and `git-reader` makes the read.

  **The ground.** An include that stays inside the folder can name an outside path in turn. A
  check that stops at the first file either misses it or must refuse every repository that has an
  include, which breaks the spec's rule that a repository naming no outside path answers as today
  (`change_spec.md:L84`). Reading a file inside the folder is inside the grant (§ 4 C-D1) and
  inside `docs/fdr.md` R-101, so no promise moves.

  **Which part.** `fs-reader` must not own Git in any form (`docs/SDD.md:L335`), and the adapter
  already locates the Git directory with a spelling walk of its own (`libgit2.rs:L162-L184`). So
  the read is `git-reader`'s, and its *Must not own* clause gains one exception. *Open Questions*
  says "through `fs-reader`'s check"; the answer reads that as the rule and asks the fold to name
  the part.

  **Failure paths.** A size bound on each file, libgit2's depth of ten, and the walk's link
  bound; past any of them the repository is refused. `config.worktree` is included because
  libgit2 loads it (`repository.c:L1305-L1308`).

  **Downstream.** `docs/nfdr.md` QC-15's list (`:L455-L461`) goes false once the SDD is folded.
  No item was opened on the NFDR: it is true of the SDD as it stands, and it is re-derived from
  the SDD by its own seat. The answer names this so the fold carries it.

  **A defect seen and not raised.** § 11 R-10 says the containment check "has one
  implementation" (`docs/SDD.md:L2903`), and the adapter holds a walk of its own. This run did
  not compare the two, so it raises nothing on it.

### 5.3 — Which paths are in R-16's domain beyond its three keys: `includeIf.<condition>.path`, and `core.worktree`?

- **Bucket:** 5. Raised from downstream — an item from a seat that did not write the SDD
- **Verdict:** answered
- **Why:** Both are in. The domain is a rule, and the five keys are its measurement at the
  pinned libgit2 version.

  **The ground.** A list of keys reads as closed while the property is wider, which is the
  spec's own Gap 6. The rule is every path libgit2 takes from a config file it loads for the
  repository during the open, the state read and the status read. The five members and the two
  non-members were each read in the source (*Sources re-read*, above).

  **`includeIf`.** Refused whenever its path spells outside, with the condition not evaluated.
  This over-refuses a repository whose condition would not match. It was chosen because it stays
  true if a later libgit2 adds a condition.

  **`core.worktree`.** libgit2 resolves it during the open (`repository.c:L436`), and § 4 C-D1
  counts a `realpath` outside the grant as a read. A value that spells outside is refused before
  the open. Today that repository already answers `failed` after the open
  (`libgit2.rs:L86-L92`), so what changes is when, and which condition.

  **The item's supporting text.** It says matching an `includeIf` condition "is a read of its
  own". Only `onbranch` reads, and it reads inside the Git directory. The answer does not depend
  on it.

  **Not covered.** Three of the five keys have been read in the source and not run. The answer
  keeps the bar at one fixture and one case and has R-16 say which keys no case holds.

### 5.4 — Is a submodule's repository in R-16's domain, which `status()` opens?

- **Bucket:** 5. Raised from downstream — an item from a seat that did not write the SDD
- **Verdict:** answered
- **Why:** Yes. The check covers every submodule repository the status read opens, and status
  keeps submodules on.

  **The three routes.** Excluding submodules is the simplest and is structural: libgit2 returns
  before any lookup (`diff_generate.c:L752-L754`). It was refused on check 3. A submodule whose
  commit moved would leave the changed list while `git status` lists it, against `docs/SRS.md`
  FR-12 (`:L204-L207`) and `docs/fdr.md` R-65 and R-66 (`:L136-L137`). That route needs a settled
  requirement to move, and neither document is this seat's. Naming a top-level-only limit was
  refused because R-101 has no such qualifier and the case has a site in the product. Covering
  the submodule repositories moves no requirement.

  **What it costs.** It is the most to build. The adapter must enumerate the gitlink entries,
  verify each repository against the opened folder, and descend to nested ones under a depth
  bound. The rule rests on which opens libgit2 makes during status; those lines were read and not
  run. The answer therefore holds the submodule half to a case of its own, and has R-16 state it
  as a limit until that case exists.

  **A correction made while writing.** The first wording said the branch would still show when
  status refuses. § 3 `GitState` says a failure of either read makes the whole Git item `failed`
  (`docs/SDD.md:L495-L497`). The answer was corrected to that before the commit.

  **Which change carries it** is left to the journey. The bound is the one *Open Questions*
  already sets, before `see-git-status` is reached.

  **What would have tipped it.** An upstream sentence saying the Git view does not list
  submodule entries. With that, excluding submodules would be the smaller and safer route. The
  item's own search found none, and this run's reading of FR-12 and R-65 agrees.

## Left for the owner

None this run.

## Skipped

- **5.2 — `docs/nfdr.md` QC-15** — not raised on the NFDR. It goes false only when the SDD is
  folded, and the Principal Architect re-derives it from the new SDD version.
- **§ 11 R-10's "one implementation"** — seen while answering 5.2 and not checked, so not raised.

## Raised on this document

### 2.1 — § 11 R-16 names `objects/info/alternates` as a third way Git's layout points outside the folder, uncovered until a check holds it

- **What the document is owed:** § 11 R-16 and § 4 C-D3 name the alternates file as an uncovered
  outside read, and the adapter's check refuses a repository whose alternates file names a
  location outside the folder.
- **Why it is worth a cycle:** the ground is *a fact in it is now false*
  (`<CORE>/../skills/companion/.claude/skills/companion-self-answer/prompts/rich.md` § The items
  are not the whole of what a document is owed). R-16 calls R-3 "the other way" Git's layout
  points outside (`docs/SDD.md:L2980-L2981`), and C-D3 names one thing as not covered
  (`:L989-L991`). libgit2 reads `objects/info/alternates` and adds each entry as an object store
  with no containment check (`odb.c:L761-L803`). The SDD, the NFDR and the adapter do not mention
  it: `grep -n -i alternates` over the three prints nothing at `nozoki@8b50506`.

  The doubt, stated: the read was not run, no fixture carries an alternates file, and the
  prompt's own bar for a downstream item would call this a form with no measured failure. It was
  raised because the sentence it corrects is a coverage statement in a document whose promise is
  "never", and a missing name there reads as coverage. The confirm-or-override slot is left at its
  placeholder, so the item stays open through the next fold and costs one more round.

## Companions opened

None this run.

## Launchers owed

- **`docs/SDD.md`** — `<CORE>/launchers/skill/launcher.sh product-sdd nozoki`
