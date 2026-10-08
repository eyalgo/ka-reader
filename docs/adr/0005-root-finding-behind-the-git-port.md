# ADR-0005: The root finding lives behind the Git port, and a plain folder is a model with no Git state

**Status:** Superseded by ADR-0018
**Date:** 2026-09-01

## Context

Git is read only when the opened folder is itself the top level of a Git working tree; a folder
inside a repository and a folder holding repositories each open as a plain folder; finding out
creates nothing; and the determination is live (`docs/SRS.md` § 3.1 FR-33, FR-34). The rule that
holds it is the owner's: "what the tree shows and what the Git view reports are always the same
folder" — the monorepo variant, Git scoped to a subtree, was put to the owner and rejected
(`docs/trail/prd/cycle-10.md` § 2.4). Git itself resolves a repository from any folder beneath its
root, which is exactly the behaviour the rule forbids, so a determination that asks Git naively
would specify the excluded behaviour (`docs/SRS.md` § SRS Review Notes RN-32). In a plain folder
the Git view is present and shows nothing — no message, no control — and the tree carries no
markers (`docs/PRD.md` § Core Features; `docs/UXD.md` UX-I17).

## Decision

The **root finding is a port call, `probe(folder)`**, answered by `git-reader` — with repository
discovery disabled, reading and creating nothing — and it returns `root` or `plain`, never a path
above the folder. The **model consumes the answer as a state**: `root` carries a `GitState`;
`plain` carries none, and every Git-derived projection is empty and the tree carries no marker. The
**surfaces draw that state**, and draw the Git view empty on `plain`. The **watcher includes the
root's `.git` entry**, so a repository appearing at the root mid-session, or leaving it, is one more
change the reducer applies by re-running the finding (`docs/SDD.md` § 3, the `git-reader`,
`folder-model` and `watcher` rows; `ka-reader@70a879a:docs/SDD.md` § 3, the paragraph following the parts table, and
§ SDD Review Notes RN-24 (3)–(4)). A build with no Git surface links no `git-reader` at all, and its model's root
finding is pending-and-never-asked.

## Alternatives ruled out

- **Answer it in `fs-reader`, as a check for a `.git` entry** — the finding is a read of Git's
  on-disk layout (a `.git` folder, or a `.git` file naming a `gitdir`), and the one part that may be
  substituted (ADR-0004) must carry it too: an installed-`git` adapter answers it with
  `git rev-parse --show-toplevel` compared to the folder, a libgit2 adapter by opening with
  discovery disabled. A check outside the port would have to be right for both
  (`ka-reader@70a879a:docs/SDD.md` § 3, the paragraph following the parts table).
- **Answer it in the model** — the same reason; the model consumes the answer and does not know how
  it was found, which is what `docs/SRS.md` FR-33 asks for ("how the determination is made is the
  SDD's").
- **Ask Git and accept what it finds** — walks up from the folder and reports an ancestor's
  repository, the case the PRD excludes (`docs/PRD.md` § Out of Scope, "Git found anywhere but at
  the opened folder's root").

## Consequences

Easier: one part answers the question in every adapter; the plain folder costs the surfaces no
branch — they project an absent `GitState` as nothing; the first read slice is buildable without
any Git code, because the finding is not asked until a Git surface exists. Harder: a `.git` *file*
(a linked worktree, a submodule) points at a Git directory that may lie outside the sandbox grant,
which the port must report and the Git view present as a failure naming the folder to choose
(`docs/SDD.md` § 11 R-3; `docs/fdr.md` R-21); disabling discovery in libgit2 is unverified until the
first Git slice's fixtures run (`docs/SDD.md` § Open Questions, second item).

What undoing it costs: moving the finding touches `git-reader` and the model's consumption of it;
cheap in code, but the cut of the first two slices rests on the finding staying out of the first
one.

## Traces to

- `docs/SDD.md` § 3 — the `git-reader`, `folder-model`, `watcher` rows; seam 2; § 4 C-R3 (a plain
  folder is not a startup failure); § 11 R-3; `ka-reader@70a879a:docs/SDD.md` § 3, the paragraph after the parts
  table, and § SDD Review Notes RN-24 (3)–(5).
- `docs/SRS.md` § 3.1 FR-33, FR-34; § 8 AC-24, AC-25; § SRS Review Notes RN-32, RN-33.
- `docs/trail/prd/cycle-10.md` § 2.2, § 2.4 — the owner's plain-folder and root-only rulings.
- `docs/fdr.md` R-12 – R-18, R-22 – R-26, PD-5, PD-37.

## Binds

QC-5.
