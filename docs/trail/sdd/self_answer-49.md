# Self-answer report — `docs/SDD.md`

This is the record of one unattended run that answered `docs/SDD_open_issues.md` in the CTO's
seat on 2026-10-06. It is for the owner, who reads it to learn what was decided and why, and for
the `product-sdd` run that folds the answer.

## Header

- **Companion:** `docs/SDD_open_issues.md`
- **Document:** `docs/SDD.md` (v41, `Status:` Draft)
- **Decided by:** `<CORE>/../skills/companion/.claude/skills/companion-self-answer/prompts/rich.md` v1.3.1
- **Date:** 2026-10-06
- **Sources re-read:** libgit2's source, as vendored by `libgit2-sys 0.18.8+1.9.7` in the cargo
  registry (`libgit2-sys-0.18.8+1.9.7/libgit2/src/`), the version `Cargo.lock:L122-L123` resolves.
  Each line below was opened in this run.
  - `libgit2/submodule.c:L665` and `:L2252-L2255`: the submodule map takes a snapshot of
    `.gitmodules` in the working tree, opened with `git_config_open_ondisk`. The item's reading
    holds.
  - `libgit2/diff_generate.c:L759-L766`: the status read's diff starts the submodule map the
    first time it compares a gitlink. The item cites `:L759-L760`; the call is at `:L766`.
  - `libgit2/submodule.c:L1953`, `:L2091`: a section's path is its `path` value, and its name
    where it has no `path` key.
  - `libgit2/submodule.c:L479-L498`, `:L2204`, and `util/fs_path.h:L650-L652`: the path is
    refused only for an empty component or a `.` or `..` component, and the empty-component
    refusal is switched off for this call.
  - `libgit2/submodule.c:L691`, `:L2228-L2231`: for every section in the map, libgit2 asks
    whether the path under the working tree is a directory and whether it holds `.git`.
  - `libgit2/submodule.c:L2211`, `:L346`, and `libgit2/diff_generate.c:L771`: the map is keyed by
    section name, and the diff looks a gitlink up in it by the gitlink's path.
  - `libgit2/submodule.c:L1884`, `:L1647-L1665`: the status of that entry opens the repository at
    the working tree joined with the section's path and `.git`, and reads its `HEAD`.
  - `libgit2/submodule.c:L1725`: the entry's index id is looked up by the section's path, not by
    the gitlink's path.
  - `util/str.c:L778`, `:L830`: the join drops a leading `/` from the second part, so an absolute
    path value is taken under the working tree.
  - `libgit2/diff_generate.c:L668`, `:L1157`, and `libgit2/submodule.c:L1270`: a working-tree
    folder that holds `.git` is looked up by its path too, and the first of those lookups can
    open the repository. Read and not run.
  - `libgit2/config_file.c:L727` and `libgit2/config.c:L174`: `.gitmodules` is loaded with no
    repository, and a conditional include is skipped when there is none. Read and not run.

- **What was read of the document.** `docs/SDD.md` is 7,207 lines, and this run did not read it
  whole. It read *Who decides what* (`:L92-L148`), § 3's `git-reader` row (`:L344`), § 4 C-D3's
  *Not covered* passage (`:L1008-L1016`), § 11 whole (`:L2898-L3266`) and the *Open Questions*
  config item (`:L7138-L7190`). It searched the rest for `gitmodules`, `submodule`, `RN-99`,
  `RN-100` and `RN-101` and read each line found. Of the inputs it opened `docs/SRS.md` FR-12
  (`:L204-L207`), `docs/fdr.md` R-101 (`:L188`) and `docs/CONTENT.md:L62`. It did not open
  `docs/PRD.md` or `docs/UXD.md` beyond their status lines.

## Items worked

### 2.1 — The config check also reads `.gitmodules` and the files it includes, and the `git-reader` row neither owns that read nor makes an exception for it

- **Bucket:** 2. Choices to confirm — a best-effort answer was drafted; confirm or override
- **Verdict:** confirmed with addition
- **Why:** The draft is right that the SDD must own this read, and it is taken. One clause of it
  is wrong, and two things are added.

  **Whose call.** The item carries `Seat: cto`. Every change it asks for lands in § 3 and § 11 of
  `docs/SDD.md`, which the lane table gives the CTO (`docs/SDD.md:L111`, `:L130`). The answer
  adds a refusal, which tightens a rule the document already holds. It moves no requirement
  upstream: `docs/fdr.md:L188` says "The product reads nothing outside the viewed folder except
  its own data location on the machine", and the answer follows from it as it stands.

  **What holds as drafted.** libgit2 loads `.gitmodules` as a config file during the status
  read, and that loader follows includes. The adapter already checks the file before status runs
  (`crates/ka-reader-core/src/git_reader/libgit2.rs:L292-L303`, the same lines at `ka-reader@bd382c8`
  as at the item's `ka-reader@b25b407`: `git diff --stat fc14574 HEAD -- crates ka-reader-mac checks`
  prints nothing). Three cases hold it (`crates/ka-reader-core/tests/git_state.rs:L1533`, `:L1544`,
  `:L1572`), which the item does not name. So the three drafted changes are confirmed: the row
  owns the read, the row excepts it, and R-16 names the file.

  **What does not hold: "the check reading only its include keys".** R-16's rule is "every path
  libgit2 takes from a config file it loads for the repository, during the open, the state read
  and the status read" (`docs/SDD.md:L3041-L3043`). `.gitmodules` carries a second such path,
  `submodule.<name>.path`. libgit2 looks at that location for every section, and it opens the
  repository there when the section's name is a gitlink's path. The adapter's comment says "only
  includes follow paths" (`libgit2.rs:L236-L237`). The source and the measurement below say
  otherwise. Confirming the draft whole would have written into the SDD that the include keys
  are the only reach of this file, with a hole under the sentence.

  **The measurement.** A scratch program outside the repository called the product's adapter,
  `ka_reader_core::Libgit2`, built from the tree at `ka-reader@bd382c8` against
  `libgit2-sys 0.18.8+1.9.7`. It printed `probe()` and `status()` for four folders. Each folder
  is a repository with a gitlink `sub` in its index and a clean repository at `sub`, at the
  gitlink's commit. Only `.gitmodules` and what lies beside the folder differ.

  | Scene | `.gitmodules`, section `sub` | Beside it | `git status --porcelain` | The adapter's `changed` list |
  |---|---|---|---|---|
  | e0 | `path = sub` | nothing | (nothing) | (empty) |
  | e1 | `path = evil` | a second repository at `evil`, inside the folder | `?? evil/` | `evil/` untracked, `sub` modified |
  | e2 | `path = link/x` | `link` is a link to a directory outside the folder, with a repository at `x` there | `?? link` | `link` untracked, `sub` modified |
  | e2c | `path = link/x` | the same link, with nothing at `x` | `?? link` | `link` untracked |

  `probe()` answered `Root` and `status()` answered `Ok` on all four. The only difference between
  e2 and e2c is whether a repository exists outside the folder, and the answer differs. So the
  status read opened a repository outside the folder and read its `HEAD`, and none of the
  adapter's checks saw it. In e1 the list says `sub` is modified where Git says nothing changed.

  To repeat it: build each scene with `git init`, a commit in `sub`,
  `git update-index --add --cacheinfo 160000,<sub's commit>,sub`, the `.gitmodules` above
  committed with it, and the second repository or the link; then call `Libgit2.status(<folder>)`.
  The scratch files were kept outside the product and are not part of any commit.

  **Why the response is a refusal in two parts.** A path that spells outside the folder is the
  case R-16 already refuses for five keys, so the sixth takes the same condition and the same
  sentence. The shipped sentence names the key and the path and no file
  (`ka-reader-mac/Sources/Surfaces/GitSentences.swift:L53-L57`), so it stays true for a key that
  comes from `.gitmodules`. The second part is new. Where a section's name is a gitlink's path
  and its path is another location inside the folder, nothing spells outside, yet libgit2 opens
  a repository the adapter never verified and reports it in the gitlink's place. Verifying that
  other repository would restore containment and leave the list wrong. The `git-reader` row
  already refuses a partial answer on this ground: "Status is never run with that submodule left
  out, because the list would then read as whole" (`docs/SDD.md:L344`). A list that names the
  wrong repository's state is the same failure, so the adapter refuses that read too.

  **What this answer does not decide.** The second refusal needs a condition a reader sees.
  Neither observation of the config condition is true of it, and the fault sentence says KA-Reader
  "can't tell why" (`GitSentences.swift:L22-L24`), which is false when it can. The observable
  half of a condition is the CDO's (`docs/SDD.md:L122`), and `docs/CONTENT.md:L62` holds the
  words to "A message says what KA-Reader observed". The fold drafts it, and raises an item
  carrying `Seat: cdo` where those documents do not settle it. The exact set of paths the status
  read looks up beyond the index's gitlinks is left to the change that builds the check, because
  one member of it was read and not run.

  **The failure paths.** No `.gitmodules`, or one with no include and no section, passes. A
  section with no `path` key is spelled by its name. A `.gitmodules` that is a link is not
  followed by the adapter, which opens it without following
  (`libgit2.rs:L505-L511`), and it answers the unreadable-Git-directory condition
  (`:L221-L225`). That condition's sentence says "the Git directory"
  (`GitSentences.swift:L26-L28`), and `.gitmodules` is in the working tree. It is named as a
  limit and not decided, for the same reason as the condition above. A file rewritten between
  the check and libgit2's read is followed unchecked. In the bundle the sandbox still refuses a
  read outside the folder, and in the harness nothing does, which are the two bounds R-16 states
  for the config file (`docs/SDD.md:L3178-L3180`). A refusal leaves the tree and the reading
  panel as they were, as every Git refusal does (`docs/SDD.md:L3079-L3080`).

  **What was close.** This was close to *overridden*, because a clause of the draft is replaced.
  It is *confirmed with addition* because all three drafted changes are taken and the
  replacement widens one of them. It would have been *overridden* had the measurement shown
  libgit2 does not load `.gitmodules` during the status read.

  **Wrong in the item's supporting text, reported and not corrected.** The item cites the
  `git-reader` row at `docs/SDD.md:L338`. The row is at `:L344`, at `ka-reader@ed6e634` and now.
  The item cites `diff_generate.c:L759-L760` for the call that starts the map; the call is at
  `:L766`.

  **Downstream, and not raised here.** `docs/nfdr.md` QC-15 will owe the `.gitmodules` read once
  the SDD states it. That is already carried in the answer to
  `docs/architecture_open_issues.md` § 3.2. The same companion's § 2.1 proposes that QC-6 and
  QC-35 say R-16 measures "five keys". After this fold R-16 measures six, so a fold of that item
  made before the SDD's is one key short. This run did not edit that item: the SDD still says
  five, and the records derive from the SDD as it stands.

## Left for the owner

None this run.

## Skipped

None this run.

## Companions opened

None this run.

## Launchers owed

- **`docs/SDD.md`** — `<CORE>/launchers/skill/launcher.sh product-sdd ka-reader`
