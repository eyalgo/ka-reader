# ADR-0018: The root finding lives behind the Git port and reads only inside the opened folder — a `.git` file answers `root` from its own content, and the Git directory it names is `state()`'s to report

**Status:** Accepted — supersedes ADR-0005
**Date:** 2026-10-03

## Context

Git is read only when the opened folder is itself the top level of a Git working tree. A folder
inside a repository and a folder holding repositories each open as a plain folder. The finding
creates nothing, and it is live (`docs/SRS.md` § 3.1 FR-33, FR-34). The owner's rule holds it:
"what the tree shows and what the Git view reports are always the same folder"
(`docs/trail/prd/cycle-10.md` § 2.4). Git resolves a repository from any folder beneath its root,
which is the behaviour that rule forbids (`docs/SRS.md` § SRS Review Notes RN-32).

ADR-0005 put the finding behind the Git port and gave `probe` two answers, `root` or `plain`. It
did not say what `probe` answers when the opened folder's `.git` entry is a file. That is the
linked worktree and the submodule. Its § Consequences said a `.git` file pointing outside the
grant is something "the port must report", and did not say which call reports it. The product
requires two things here. Such a folder is a root whether or not its Git directory can be reached
(`docs/fdr.md` R-15). And the Git view names where the Git directory lies when it cannot be read
(`docs/fdr.md` R-21). The design already placed the report: "`probe` answering `root` and
`state()` failing on the gitdir path" (`docs/SDD.md` § 11 R-3). The adapter that landed answered
neither reading. It returned a provisional condition for a `.git` that is not a folder
(`crates/ka-reader-core/src/git_reader/libgit2.rs:L38-L40` at `ka-reader@8edec4f`), and the delivery
tier had parked the choice on the argument that `root` "requires following the link outside the
folder".

That argument does not hold. A `.git` file sits inside the opened folder, and its first line is
the `gitdir:` form libgit2 itself parses (`libgit2-sys 0.18.8+1.9.7`,
`libgit2/src/libgit2/repository.c:L76`). `probe` can answer `root` from that file's content
without reading anything past it. ADR-0005 also said `probe` reads "nothing", which the adapter
has never met: it reads the folder's metadata and the `.git` entry's, and opens a `.git` folder
through libgit2.

## Decision

The **root finding is a port call, `probe(folder)`**, answered by `git-reader` with repository
discovery disabled. It returns `root` or `plain` and never a path above the folder. The **model
consumes the answer as a state**: `root` carries a `GitState`, and `plain` carries none, so every
Git-derived projection is empty and the tree carries no marker. The **surfaces draw that state**,
and draw the Git view empty on `plain`. The **watcher includes the root's `.git` entry**, so a
repository appearing at the root mid-session, or leaving it, is one more change the reducer
applies by re-running the finding. A build with no Git surface links no `git-reader`, and its
model's root finding is pending and never asked. All of this is ADR-0005's decision, unchanged.

Two things are new.

**A `.git` file answers `root`, and the Git directory it names is `state()`'s.** A `.git` file
whose content is a `gitdir:` line answers `root`. Any other content answers `plain`, as a `.git`
folder that is not a repository does. A `.git` file the operating system will not let `probe` read
is a condition. A `.git` that is a symbolic link is not followed and keeps a condition. Where the
Git directory lies, and whether it can be read, is reported by `state()`, which names it when it
lies outside the folder (`docs/SDD.md` § 11 R-3; `docs/fdr.md` R-21).

**`probe` reads only inside the opened folder.** It reads the folder's own metadata, the `.git`
entry's metadata without following a link, an entry inside a `.git` folder, and a `.git` file's
own content. It never opens the Git directory a `.git` file names, never reads a path past the
folder, never follows a link out of it, and creates nothing.

## Alternatives ruled out

- **A condition at `probe` for a `.git` file** — R-21 requires the failure to name where the Git
  directory lies. A condition raised by `probe` could do that only by carrying the path, and the
  path lies above the folder: both fixture scenes' pointers start `../`. The rule against a path
  above the folder forbids it, and the type already cannot carry one: `RootFinding` "holds no path
  and no text" (`crates/ka-reader-core/src/git_reader.rs`, the doc comment above `RootFinding`, at
  `ka-reader@8edec4f`).
- **libgit2 opening the `.git` file inside `probe`** — the open follows the `gitdir:` pointer, and
  for a linked worktree or a submodule the Git directory lies outside the grant
  (`docs/fdr.md` R-101; `docs/SDD.md` § 4 C-D1).
- **`plain` for a `.git` file** — a linked worktree's top level and a submodule's folder are roots
  (`docs/fdr.md` R-15).
- **Answer the finding in `fs-reader`, as a check for a `.git` entry** — ADR-0005's reason, which
  stands: the finding reads Git's on-disk layout, and the one part that may be substituted
  (ADR-0019) must carry it in every adapter, so a check outside the port would have to be right
  for both (`ka-reader@70a879a:docs/SDD.md` § 3, the paragraph following the parts table).
- **Answer it in the model** — the model consumes the answer and does not know how it was found,
  which is what `docs/SRS.md` FR-33 asks for ("how the determination is made is the SDD's").
- **Ask Git and accept what it finds** — Git walks up from the folder and reports an ancestor's
  repository, the case the PRD excludes (`docs/PRD.md` § Out of Scope, "Git found anywhere but at
  the opened folder's root").
- **Fold the `.git`-file clause into the constraint set alone and leave ADR-0005 standing** — the
  delivery tier reads the log as a fixed reference, and the silence in ADR-0005 is what let a
  provisional answer land (`docs/trail/architecture/self_answer-33.md` § 3.1, *What was close*).

## Consequences

Easier: one part answers the finding in every adapter. The plain folder costs the surfaces no
branch. The first read slice is buildable without any Git code. A linked worktree and a submodule
open as roots, as the product says. The read bound is a check rather than a sentence: a `.git` file
naming a Git directory that does not exist must answer `root`, so a `probe` that ever follows the
pointer turns that case red (`docs/nfdr.md` QC-5).

Harder: `state()` now carries the outside-the-grant failure. It must decide that the Git directory
lies outside the grant without reading there (`docs/SDD.md` § 4 C-D1). It cannot borrow
`fs-reader`'s containment check, because the readers import none of one another
(`docs/nfdr.md` QC-11). How it does so is the design of the change that adds `state`. A linked
worktree's Git directory also carries a `commondir`, which can point outside even when the Git
directory is inside, and that too is `state()`'s. Whether libgit2 opens a repository under a
read-only grant with discovery disabled is unverified until the first Git slice's fixtures run
on the built bundle (`docs/SDD.md` § *Open Questions*, second item).

What undoing it costs: moving the `.git`-file answer to a condition at `probe` moves this record,
R-21's failure state, and the rule against a path above the folder together. Moving the finding
out of the port touches `git-reader` and the model's consumption of it, which is cheap in code.
But the cut of the first two slices rests on the finding staying out of the first one.

**What this rests on, and whose it stays.** Git's on-disk format: a `.git` file whose content is
a `gitdir:` line. Git's maintainers hold that format, and libgit2 parses the same prefix. If Git
ever writes a `.git` file in another form, `probe` answers `plain` for it, and the folder opens
with no Git view until this record is superseded. That failure is visible and reads nothing
outside the grant.

## Traces to

- `docs/SDD.md` at v27 (Settled) — § 3, the `git-reader`, `folder-model` and `watcher` rows and
  SM-2; § 4 C-D1, C-R3; § 11 R-3; § *Open Questions*, second item.
  `ka-reader@70a879a:docs/SDD.md` § 3, the paragraph after the parts table, and § SDD Review Notes
  RN-24 (3)–(5).
- `docs/SRS.md` § 3.1 FR-33, FR-34; § 8 AC-24, AC-25; § SRS Review Notes RN-32, RN-33.
- `docs/fdr.md` R-12 – R-18, R-21 – R-26, R-101, PD-5, PD-37.
- `docs/trail/prd/cycle-10.md` § 2.2, § 2.4 — the owner's plain-folder and root-only rulings.
- `docs/trail/architecture/cycle-29.md` § 3.1 — raised by the PM after `git-reader` landed
  (`ka-reader@126ef75`). The answer, given in the owner's seat by a `companion-self-answer` run on
  2026-10-03, ordered this record. Its reasoning is `docs/trail/architecture/self_answer-33.md`
  § 3.1, and the read bound is decided together with § 3.3.
- `crates/ka-reader-core/src/git_reader/libgit2.rs:L31`, `:L35`, `:L38-L40`, `:L52`, `:L63`, and
  the `RootFinding` type in `crates/ka-reader-core/src/git_reader.rs`, at `ka-reader@8edec4f`.
  `libgit2-sys 0.18.8+1.9.7`, `libgit2/src/libgit2/repository.c:L76`, in the registry copy the
  lock resolves.
- ADR-0005 — the record this one supersedes.
- Inputs read for this record: SDD Settled v27 · SRS Settled v12 · FDR Settled v10.

## Binds

QC-5, QC-15.
