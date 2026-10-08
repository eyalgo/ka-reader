# Self-answer report — `docs/SDD.md`

This is the record of one unattended run that answered `docs/SDD_open_issues.md` in the CTO's seat,
with nobody present. It is for the owner, who reads it to learn what was decided and why, and for
the `product-sdd` run that folds the answer.

## Header

- **Companion:** `docs/SDD_open_issues.md`
- **Document:** `docs/SDD.md`
- **Decided by:** `decide_companion_answers.md` v1.3.0
- **Date:** 2026-10-03
- **Sources re-read:** Two, both for § 2.1, both in the cargo registry copies of the crates
  `Cargo.lock` resolves (`Cargo.lock:L72-L73`, `:L122-L123`), under
  `~/.cargo/registry/src/index.crates.io-1949cf8c6b5b557f/`.
  - **`libgit2-sys 0.18.8+1.9.7`**, files under `libgit2/src/libgit2/`. Every line the item cites
    was opened and says what the item says it says: `repository.c:L997-L999` (the open takes a
    config snapshot, and a failure other than not-found fails the open), `:L1316-L1338` (the
    global, XDG, system and programdata levels are added), `sysdir.c:L282` (the system level is
    `/etc`), `:L347-L359` (under `APP_SANDBOX_CONTAINER_ID` the home comes from the password
    entry), `:L458-L459` (every level is guessed at init), `:L559-L560` (an empty search path
    returns before any file is touched), `config_file.c:L117-L123` (an unreadable config file is
    treated as absent), `config.c:L143-L147` (a `stat` refused with anything but `ENOENT` or
    `ENOTDIR` is an error). Five places the item does not cite were read for the additions:
    `config_file.c:L564` (`parse_include`), `ignore.c:L362-L364` (`core.excludesfile`),
    `attr.c:L413` (`core.attributesfile`), `attrcache.c:L345` (the XDG ignore and attributes
    fallback goes through the same search path), and `repository.c:L618-L634`, `:L668-L704`,
    `:L1172-L1173`, `:L2156-L2173` (ownership validation reads `safe.directory` from the same four
    levels).
  - **`git2 0.21.0`**, `src/opts.rs:L10-L34`: `set_search_path` is an `unsafe fn`, takes one of the
    four levels, initialises the library first (`:L27`) and returns a `Result`.

**What this run read.** The companion whole. Of `docs/SDD.md` (5,136 lines): the header and version
lines (`:L1-L30`), § 3 whole (`:L307-L431`), § 4 C-I3 (`:L694-L730`) and C-D1 to C-D3
(`:L850-L870`), § 6 S-4's command clause (`:L1676-L1702`), § 11 R-3 (`:L2549-L2558`) and R-13 to
R-15 (`:L2616-L2656`), and *Open Questions* (`:L5083-L5136`). The rest was searched for `libgit2`,
`git2`, `unsafe`, `composition root`, `gitconfig`, `search path`, `alternates`, `include.path`,
`excludesFile`, `safe.directory`, `untracked` and `ignored`, and each hit was read. **§ 1, § 2,
§ 5, § 6's other slices, §§ 7–10, § 12 and the review notes outside those hits were not read line
by line**, so a sentence there that bears on this item and uses none of those words was not seen.
Outside the SDD: `docs/fdr.md` R-97 to R-104 (`:L184-L191`), R-66 and R-153 (`:L90`, `:L137`);
`docs/architecture_open_issues.md` §§ 2.1, 2.2 and 3.5; `crates/ka-reader-core/Cargo.toml:L9`;
`crates/ka-reader-bridge/Cargo.toml`; `crates/ka-reader-core/src/git_reader/libgit2.rs:L40-L58`;
`checks/structure.sh:L100-L106`. `docs/SRS.md`, `docs/PRD.md` and `docs/UXD.md` were searched for
the ignore, untracked and config words and not otherwise opened, because the answer moves no
requirement and no surface.

## Items worked

### 2.1 — libgit2's repository open reads the user's global and the system Git config outside the grant, and the rules as written leave no unit that may switch it off

- **Bucket:** 2. Choices to confirm — a best-effort answer was drafted; confirm or override
- **Verdict:** confirmed with addition
- **Why:** The proposed reading is taken. `docs/SDD.md` § 4 C-D1 and `docs/fdr.md` R-101 stay as
  written, and `core-bridge` empties libgit2's four machine-level search paths at the Rust-side
  composition root, before the libgit2 adapter is wired.

  **Whose call it is.** The item carries `Seat: cto`, and the three tests agree. The edit lands in
  this document's § 3. The answer binds only how the units are divided; it lowers no promise and
  commits nothing to anyone outside. And there is no ground this run can name and cannot see. The
  one reading that would have been the owner's is "accept the reads", because it lowers R-101
  (`docs/fdr.md:L188`). That reading is not taken, so nothing here waits on the owner.

  **Why the proposal holds, for the reason it gives.** Each fact in its rationale was re-read at
  the source (the header above lists them) and each stands. The rules do leave no unit that may
  make the call: `ka-reader-core` holds no `unsafe` (`SDD.md:L336`; `grep -rn unsafe
  crates/ka-reader-core/src` prints nothing), and only `git-reader` may import the binding (`:L347`).
  The bridge is the right unit. It is already the Rust-side composition root, the one unit that
  holds `unsafe`, and the place the adapter is wired (`:L330`). It already runs process setup
  before first use: the diagnostic log writer's install is in the same *Owns* cell. That precedent
  also answers the cell's *Must not own* clause, "Anything the harness could not exercise through
  SM-5". The harness does not reach the log install through SM-5 either. The clause keeps read
  logic out of the bridge, and the switch is setup, not read logic.

  **The other readings, weighed.** `unsafe` inside `git-reader` gives up the property the units
  paragraph is built on, that the harness links a core with no `unsafe`, for one call. Patching the
  vendored build repeats a cost § 11 R-15 already names. A fourth reading the item does not list
  was considered and rejected: `git-reader` could re-export `git2::opts::set_search_path` without
  writing `unsafe` itself, and the bridge could call the re-export. That keeps the letter of "only
  `git-reader` imports the binding" and breaks what SM-2 means by it, "the adapter is the only
  thing that knows libgit2" (`SDD.md:L417`). A stated exception is easier for a cold reader to
  check than a rule kept by spelling.

  **The six additions, and what each rests on.** The proposal is right and incomplete; these are
  the cases it does not reach.
  1. *The clause must not say "and no other".* The proposal's first edit ends "A repository open
     then reads the repository's own config, inside the grant, and no other." That sentence would
     be false in the SDD. The repository's own config can name a path outside the grant, and
     libgit2 opens it: `include.path` (`config_file.c:L564`), `core.excludesfile`
     (`ignore.c:L362-L364`), `core.attributesfile` (`attr.c:L413`). None passes `fs-reader`'s
     containment check, although C-D3 says every path derived from content does
     (`SDD.md:L862-L864`). The SDD says nothing about these today: a search for `include.path`,
     `excludesFile` and `alternates` in `docs/SDD.md` and `docs/nfdr.md` prints nothing. The fold
     names them as an uncovered case and as a § 11 risk beside R-3. This run does not decide how
     the hole is closed. It did not find a libgit2 switch for it, and it did not look for long.
  2. *Fail closed, once.* `set_search_path` returns a `Result` (`opts.rs:L23`). The proposal does
     not say what happens when it fails. The answer: the adapter is not wired and the Git item is
     `failed`, so a repository is never opened with the reads on. The call mutates global state
     with no thread safety (`opts.rs:L20-L22`), so it runs once per process.
  3. *Default features off in the bridge's manifest.* The bridge has no `git2` line today
     (`crates/ka-reader-bridge/Cargo.toml`). The core's line turns default features off
     (`crates/ka-reader-core/Cargo.toml:L9`). Cargo unifies features across a build, so a bridge line
     with defaults on would turn on HTTPS and SSH for both crates, against § 4 C-R6
     (`SDD.md:L604-L629`). That cargo unifies features is this run's knowledge of the tool and was
     not re-read at a source; `checks/no-network.sh` reads the inverse feature trees
     (`checks/deps.allow:L13-L14`) and would turn red on it.
  4. *Every statement of the rule moves together.* The proposal's second edit names `:L347`. § 6
     S-4's command clause states the same rule as a check: "`checks/structure.sh` finds … the
     libgit2 import in `git-reader` alone" (`SDD.md:L1698`). Left alone, the SDD would say two
     things. `checks/structure.sh` also treats the binding's name outside `git-reader` as a
     finding (`:L103-L105`), so the exception is stated narrowly enough to check: the composition
     root's search-path call and its test, and nowhere else. Changing the script is the change's.
  5. *What the reader sees changes in two places.* With the global and XDG levels empty, the
     user's global ignore file is not applied (`attrcache.c:L345` goes through the same search
     path), so a file it hides from `git status` shows here as untracked. And a repository the
     current user does not own fails to open: ownership is validated on open
     (`repository.c:L1172-L1173`), and the `safe.directory` entry that would allow it is read from
     the four levels now empty (`:L629-L634`, `:L2164-L2167`). The adapter maps any open error but
     not-found to a failed probe (`crates/ka-reader-core/src/git_reader/libgit2.rs:L56`). Both follow
     from R-101 as it stands. Honouring either means reading outside the grant, which is the
     owner's to allow and is not proposed.
  6. *What the evidence does not reach.* The proposed bridge test asserts the four search paths
     are empty. It observes no read; the step from "empty" to "no file touched" is
     `sysdir.c:L559-L560`, read and not run. `ka-reader-core`'s own Git suites run without the bridge
     and so with the reads on, and with addition 5 that is more than the proposal's "a fault of
     the test environment": an answer there can differ from the bundle's on a machine with a
     global ignore file. C-I3 already keeps a list of "things no check holds" (`SDD.md:L701`), and
     this joins it. How the suites are isolated is left to the change that builds the switch.

  **Failure paths walked.** *Empty:* a machine with no Git config at all behaves the same with the
  switch as without. *Absent or refused:* addition 2. *Stale:* a libgit2 release that adds a fifth
  config level would not be covered by a test naming four; the lockfile change reviewed as code
  (C-R6) is the only gate, and the answer does not add one. *Concurrent:* addition 2's once-only
  rule, and the proposal's own placement before the adapter is wired.

  **Not covered by this answer.** The proposal's own three named gaps stand as it states them. The
  environment reads at init are carried at `docs/architecture_open_issues.md` § 2.2. Whether the
  open survives under the sandbox stays *Open Questions*' second item until the bundle run.

  **What would have tipped it.** Had the bridge held read logic to make this call, or had the
  switch needed a second unit to hold `unsafe`, the answer would have been an override toward
  patching the vendored build. Neither is the case.

  **Downstream, nothing opened by this run.** The NFDR's QC-9, QC-11, QC-13, QC-17 and QC-35
  re-derive from the folded SDD, and `docs/architecture_open_issues.md` §§ 2.1 and 2.2 already hold
  the NFDR open for it. Addition 5 touches what `docs/fdr.md` R-153 means by "an ignored file"
  (`:L90`): after the fold it is a file the folder's own rules ignore. That rides down from the
  folded SDD to the FDR's own seat and is not raised from here, because R-153 is not false today
  and no bridge function reaches `git-reader` yet (`SDD.md:L2650`).

## Left for the owner

None this run.

## Skipped

None this run. The companion holds one item, and its slot was at its placeholder.

## Companions opened

None this run.

## Launchers owed

- **`docs/SDD.md`** — `<CORE>/launchers/skill/launcher.sh product-sdd ka-reader`
