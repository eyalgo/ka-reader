# ADR-0022: `git-reader` refuses a repository whose Git config, `.gitmodules` or alternates file names a location outside the folder — by a check of its own, read inside the folder before libgit2 reads what that file names

**Status:** Proposed
**Date:** 2026-10-06

## Context

The product reads nothing outside the viewed folder except its own data location
(`docs/fdr.md` R-101, `:L188`), and `docs/SDD.md` § 4 C-D1's *Violated by* names any such read.
ADR-0020 switched off libgit2's four machine-level config levels and named what that switch does
not reach: "A path the repository's own config names … is followed by libgit2 with no containment
check … How that is closed is the SDD's last *Open Question*" (ADR-0020, *Consequences*). That
config is content, written by whoever wrote the folder (`docs/SDD.md` § 4 C-D3).

The SDD settled how it is closed between v39 and v42, in the CTO's seat, over four companion
cycles (`docs/trail/sdd/cycle-34.md` §§ 5.1 – 5.4, `cycle-35.md` § 2.1, `cycle-36.md` §§ 5.1 – 5.4,
`cycle-37.md` § 2.1; SDD RN-99 – RN-102). Three facts forced a decision rather than a default:

- libgit2 has no option that stops these paths being followed (`libgit2-sys 0.18.8+1.9.7`,
  `libgit2/include/git2/common.h:L214-L262`, as the SDD's *Open Questions* config-named-path item
  reads it).
- The paths are many, not three. § 11 R-16 states the domain as a rule — every path libgit2 takes
  from a config file it loads for the repository, during the open, the state read and the status
  read — and measures six members at that libgit2 version: `include.path`,
  `includeIf.<condition>.path`, `core.worktree`, `core.excludesfile`, `core.attributesfile`, and
  `submodule.<name>.path` in `.gitmodules`, which libgit2 loads as config during the status read
  and not during the open.
- A second way out is not config at all: `objects/info/alternates`, whose entries libgit2 adds as
  object stores with no containment check (§ 11 R-16, "A third way out").

The SDD's RN-101 and RN-102 surface the sub-decisions below for this seat to record.

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
  `core.excludesfile` or `core.attributesfile`, and a `.gitmodules` section path beginning `/`.
  An `includeIf` path refuses whatever its condition, and the condition is not evaluated. Where a
  `.gitmodules` section would make the status read open, or report, another location for a path
  that read looks up, the read is refused.
- **Each refusal is a condition of its own that states what was observed.** It is never the
  read-failed condition, because no read was tried. The Git item is `failed` with it, the tree and
  the panel stand, and the log line holds no path.
- **The domain is pinned to one libgit2 version.** A `libgit2-sys` version change re-measures it in
  the lockfile review `docs/SDD.md` § 4 C-R6 already requires.

## Alternatives ruled out

*(Every option below is the SDD's own weighing, transcribed. None is this seat's.)*

- **A libgit2 setting that stops the paths being followed** — none exists. The *Open Questions*
  item names this as the first of its two forms and closes it on that ground.
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

## Consequences

Easier: R-101 holds in the in-process harness, not only in the bundle, for what the checks cover,
and the harness can observe it. The cases watch the one outside path each scene names through a
FIFO whose non-blocking open succeeds only once a reader holds it
(`crates/nozoki-core/tests/git_state.rs:L1156-L1166`): the repository's config
(`test_no_answer_reads_the_path_the_config_names_outside`, `:L1202`), a submodule's config
(`:L1218`), an include from `.gitmodules` (`:L1533`) and an include through an inside link
(`:L1624`). `cargo test --locked -p nozoki-core --test git_state` printed 58 passed at
`nozoki@076eac2`, run for this record. A reader sees the cause in the Git view instead of a status
read from somewhere else.

Harder: `git-reader` parses Git's config syntax itself (`crates/nozoki-core/src/git_reader/config_scan.rs`),
a second reader beside libgit2's, and the two must agree on what libgit2 would follow. The check and
libgit2's read are two reads, so a file rewritten between them is followed unchecked. The sandbox
bounds that in the bundle and nothing does in the harness. A link elsewhere inside the Git
directory that leads out — a linked `HEAD`, `index` or `refs` — is covered by no check. And a reader
pays: a clone made with `git clone --shared` or `--reference` from outside the folder, a config
that includes `~/…`, or a `.gitmodules` that maps a submodule elsewhere shows a failed Git item
where `git status` in a terminal works.

**Built and not built, at `nozoki@076eac2`** (one tree outside `docs/` with `nozoki@5f3e895`,
`git diff --quiet 5f3e895 076eac2 -- . ':!docs'`). Built: the config check (`check_config`,
`crates/nozoki-core/src/git_reader/libgit2.rs:L191`), the submodule verification
(`verify_submodules`, `:L285`) and the `.gitmodules` check for its include keys (`:L290-L303`). Not
built: the alternates check (`grep -rl alternates checks crates nozoki-mac/Sources` prints nothing),
the `.gitmodules` section-path refusals, and the refusal on the submodule map. The SDD states the
last two as a known defect until a change lands (§ 11 R-16). Until they land, the sandbox is the
only bound on those reads in the bundle, and nothing bounds them in the harness. For a section that
names another location inside the folder, nothing bounds the read in either. The proof's alternates
case and its `.gitmodules` case are owed before `see-git-status` is reached, by the *Open Questions*
item's bound.

What undoing it costs: the conditions cross SM-2, SM-4 and SM-8 and carry sentences a reader sees
(`docs/CONTENT.md`), so removing the check changes the published surface as well as reopening
R-101 outside the bundle.

**What this rests on, and whose it stays.** libgit2's maintainers hold every fact the domain is
measured from: which files it loads as config, its include depth of ten, its alternates depth of
five, its rule for spelling each key, and its submodule map keyed by section name. The domain is
pinned to the version `Cargo.lock:L122-L123` resolves. If that holder goes silent, the vendored
copy stays as locked and this check stays true of it. A lockfile change that moves `libgit2-sys` is
where the domain is re-measured, and a member it misses is a read this check does not refuse.

## Traces to

- `docs/SDD.md` at v42 (Settled) — § 3, the `git-reader` and `core-bridge` rows; § 4 C-D1, C-D3,
  C-E4, C-R6; § 6 `see-git-status`, *Reached when*, observable half; § 11 R-16 whole; *Open
  Questions*, the config-named-path item; § SDD Review Notes RN-87, RN-99, RN-100, RN-101 (its
  *Surfaced for the Principal Architect to record*, first decision), RN-102 (the same, both
  decisions).
- `docs/trail/sdd/cycle-34.md` §§ 5.1 – 5.4; `cycle-35.md` § 2.1; `cycle-36.md` §§ 5.1 – 5.4;
  `cycle-37.md` § 2.1 — answered in the CTO's seat; the submodule-map measurement,
  `docs/trail/sdd/self_answer-49.md`, *The measurement*.
- `docs/fdr.md` R-101; `docs/SRS.md` FR-12.
- ADR-0020 — the switch, and the read it left to this decision; ADR-0019 (the port and its one
  adapter); ADR-0018 (the probe reads only inside the folder).
- `crates/nozoki-core/src/git_reader/libgit2.rs` and `config_scan.rs`,
  `crates/nozoki-core/tests/git_state.rs`, read at `nozoki@076eac2` at the lines cited above.
- `libgit2-sys 0.18.8+1.9.7` — the lines cited are the SDD's, read there and not re-read for this
  record.
- Inputs read for this record: SDD Settled v42 · SRS Settled v12 · FDR Settled v10.

## Binds

QC-6, QC-15, QC-30, QC-35.
