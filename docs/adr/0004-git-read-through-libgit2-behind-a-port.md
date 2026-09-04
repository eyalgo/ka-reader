# ADR-0004: Git state is read through libgit2 behind a port; the installed git is the standing substitute and is not built until it is needed

**Status:** Accepted
**Date:** 2026-09-01

## Context

The SRS leaves the Git-reading mechanism to the design, bounded by no write and no Git mutation
(`docs/SRS.md` § 5.3; § 4.3 NFR-5, NFR-6). Two facts about the alternative decided it. On a fresh
macOS, "invoking any command in Xcode or the command-line tools package (such as git) from the
command line prompts you to download and install the Command Line Tools"
(https://developer.apple.com/documentation/xcode/installing-the-command-line-tools) — a
prerequisite install that would consume the five-minute bar (`docs/SRS.md` § 7 C-3). And `git
status` by default "will automatically refresh the index … and writing out the result" unless
`--no-optional-locks` is given (https://git-scm.com/docs/git-status) — a write under `.git` that
the read-only check counts (`docs/SRS.md` § 8 AC-1). The mechanism is also the one substitution the
design expects to exercise (`docs/SDD.md` § 2, force 2).

## Decision

Git state is read through **libgit2, linked into `nozoki-core` and built without its HTTPS and SSH
transports**, behind the **Git port** owned by the folder model: `probe(folder)` (ADR-0005), then —
only on a root — `state()`, `status()`, `diff(kind, path)` and `walk(tips, window)`, each returning
plain data and each documented as read-only (`docs/SDD.md` § 3, seam 2; § 4 C-R6). The **installed-
`git` adapter** is the port's standing substitute — run with `--no-optional-locks` so it too
refreshes nothing — and is **built only when the lag risk fires**, never ahead of it
(`docs/SDD.md` § 11 R-1; § 5 step 2's rule against building infrastructure ahead of its subject).

## Alternatives ruled out

- **Spawning the installed `git`** — a Command Line Tools prompt on a fresh Mac inside the
  install clock, an index refresh under `.git` unless every call carries the right flag, and a
  porcelain output to parse; and a spawned process is a capability the host would then hold
  (`nozoki@70a879a:docs/SDD.md` § SDD Review Notes RN-8; `docs/SDD.md` § 3, `git-reader` "Must not own").
- **No port — libgit2 called directly from the model** — insulating a stable edge is ceremony
  everywhere except here, because this is the one mechanism that may be swapped when libgit2 lags
  Git (`docs/SDD.md` § 2, force 2; § 11 R-1). The port is the hexagonal alternative's one useful
  piece, kept (ADR-0001).

## Consequences

Easier: zero prerequisites; no optional-lock write to `.git/index`; a library links only the calls
the tool makes, so the absence of a mutating call is a fact of the binary rather than a discipline
(`docs/SDD.md` § 9 TO-2; `nozoki@70a879a:docs/SDD.md` § SDD Review Notes RN-8). Harder: a native C dependency to vendor and
build; feature lag behind Git — a newer index format, a sparse index, an extension libgit2 does not
know — surfacing first in the harness's fixtures and then in an adopter's report (`docs/SDD.md` § 11
R-1); whether libgit2 reads correctly under a read-only sandbox grant with discovery disabled is an
open question the first Git slice settles (`docs/SDD.md` § Open Questions, second item).

What undoing it costs: the installed-`git` adapter behind the port — the seam is already drawn for
it (`docs/SDD.md` § 9 TO-2).

**What this rests on, and whose it stays.** Two platform facts, neither this product's: libgit2's
maintenance and Git's on-disk format. Lag is libgit2's expected state, not a surprise, and the port
exists because of it. If libgit2's holder stops answering, the substitute costs exactly what this
decision bought: the installed `git` is a prerequisite a fresh Mac does not have, so C-3's
"presuming at most one widely-available prerequisite" is spent on it and the five-minute clock
(`docs/SRS.md` § 4.7 NFR-13) absorbs a Command Line Tools install. That is the decision the lag
would un-make — not the port, and not the read-only bar, which the `--no-optional-locks` adapter
keeps.

## Traces to

- `docs/SDD.md` § 2 force 2; § 3, `git-reader` row and seam 2; § 4 C-R6; § 9 TO-2; § 11 R-1, R-6;
  § 12, "The downstream boundary"; § Open Questions (second item); `nozoki@70a879a:docs/SDD.md` § SDD Review Notes RN-8.
- `docs/SRS.md` § 5.3; § 4.3 NFR-5, NFR-6; § 7 C-3; § 8 AC-1, AC-2.
- `docs/fdr.md` PD-27, PD-29.
- Apple's Command Line Tools page and Git's `git-status` page, cited above, as the SDD cites them.

## Binds

QC-3, QC-7, QC-10, QC-11, QC-18, QC-26, QC-36, QC-50.
