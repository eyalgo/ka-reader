# ADR-0019: Git state is read through libgit2 behind a port that `git-reader` defines and `folder-model` states; the shipped executable links no network transport; the installed git is the standing substitute and is not built until it is needed

**Status:** Accepted — supersedes ADR-0004
**Date:** 2026-10-03

## Context

The SRS leaves the Git-reading mechanism to the design, bounded by no write and no Git mutation
(`docs/SRS.md` § 5.3; § 4.3 NFR-5, NFR-6). Two facts about the alternative decided it. On a fresh
macOS, "invoking any command in Xcode or the command-line tools package (such as git) from the
command line prompts you to download and install the Command Line Tools"
(https://developer.apple.com/documentation/xcode/installing-the-command-line-tools). That is a
prerequisite install that would consume the five-minute bar (`docs/SRS.md` § 7 C-3). And
`git status` by default "will automatically refresh the index … and writing out the result" unless
`--no-optional-locks` is given (https://git-scm.com/docs/git-status). That is a write under `.git`
that the read-only check counts (`docs/SRS.md` § 8 AC-1). The mechanism is also the one
substitution the design expects to exercise (`docs/SDD.md` § 2, force 2).

ADR-0004 recorded that decision. Two of its sentences stopped matching the product once
`git-reader` landed (`nozoki@126ef75`). It said the port is "owned by the folder model". In the
tree the trait is defined in `git-reader`, with the types that cross beside it
(`crates/nozoki-core/src/git_reader.rs:L33`, `pub trait GitPort`), and `folder-model` names none of
them. A trait the model defined would need an import from the reader into the model, and the
readers import neither the model nor one another (`docs/SDD.md` § 3, the *Four physical units*
paragraph). ADR-0004 also said libgit2 is "built without its HTTPS and SSH transports". The vendored
library compiles its transports and its streams whatever the features, and registers `git://`,
`http://` and `https://` with no guard (`libgit2-sys 0.18.8+1.9.7`, `build.rs:L152-L156`,
`libgit2/src/libgit2/transport.c:L33-L35`). What the features turn off is the TLS stream behind
`https://` and the SSH schemes. The SDD corrected both sentences at v26 (`docs/SDD.md` § 3 SM-2;
§ 4 C-R6; § SDD Review Notes RN-85).

## Decision

Git state is read through **libgit2, vendored and linked into `nozoki-core` with its `https` and
`ssh` features off**, behind the **Git port**. `probe(folder)` comes first (ADR-0018). Then, only
on a root, `state()`, `status()`, `diff(kind, path)` and `walk(tips, window)` run, each returning
plain data and each documented as read-only (`docs/SDD.md` § 3, `git-reader` row and SM-2).

**The port's contract is the model's, and its trait is the reader's.** `folder-model` states what
the port must answer, and a second adapter passes the same contract tests. `git-reader` defines
the trait and the plain-data types that cross beside it, and implements it. A type that crosses
the seam is never defined in `folder-model`. It is defined in `git-reader`, or in a module of
`nozoki-core` that is no part. The model imports the trait and those types, and never the adapter.
The adapter is the only thing that knows libgit2, with the one exception the SDD states at v27: the
Rust-side composition root names the binding to switch off libgit2's machine-level config reads
(`docs/SDD.md` § 3, the *Four physical units* paragraph and the `core-bridge` row; RN-87). That
exception is drafted as its own record, ADR-0020.

**The transport claim is made of the shipped executable, and of nothing smaller.**
`Nozoki.app/Contents/MacOS/Nozoki` links no network transport. No TLS backend and no libssh2 is
compiled or linked, and an `nm` read of the release executable shows no defined libgit2 transport
symbol and no import of `connect`, `socket` or `getaddrinfo` (`docs/SDD.md` § 4 C-R6). The claim
says nothing of the library, or of `nozoki-core` as a unit.

The **installed-`git` adapter** is the port's standing substitute. It runs with
`--no-optional-locks`, so it too refreshes nothing, and it is **built only when the lag risk
fires**, never ahead of it (`docs/SDD.md` § 11 R-1).

## Alternatives ruled out

- **Spawning the installed `git`** — a Command Line Tools prompt on a fresh Mac inside the install
  clock; an index refresh under `.git` unless every call carries the right flag; a porcelain output
  to parse; and a spawned process would be a capability the process then holds
  (`nozoki@70a879a:docs/SDD.md` § SDD Review Notes RN-8; `docs/SDD.md` § 3, `git-reader`
  *Must not own*).
- **No port, with libgit2 called directly from the model** — insulating a stable edge is ceremony
  everywhere except here, because this is the one mechanism that may be swapped when libgit2 lags
  Git (`docs/SDD.md` § 2, force 2; § 11 R-1). The port is the hexagonal alternative's one useful
  piece, kept (ADR-0013).
- **The trait defined in `folder-model`, as ADR-0004 read it** — the adapter would have to import
  the model to implement it, and the readers import neither the model nor one another. The SDD
  took the reading the tree had already taken (`docs/SDD.md` § 3 SM-2, owner cell; RN-85 § 5.2).
- **The transport claim made of the library, or of `nozoki-core`** — false by the source, since
  the transports compile whatever the features (`build.rs:L152-L156`).
- **The transport claim stated lower** — `docs/fdr.md` PD-27 carries it as a product decision,
  "Nothing the product ships carries a network transport", and lowering it is the owner's call.
  The SDD did not take that fold (`docs/SDD.md` § SDD Review Notes RN-85 § 5.3).

## Consequences

Easier: zero prerequisites. No optional-lock write to `.git/index`. A library links only the calls
the tool makes, so the absence of a mutating call is a fact of the binary rather than a discipline
(`docs/SDD.md` § 9 TO-2). The trait's home matches the import graph, so the next method's types go
where a reviewer expects them. The transport claim now has evidence a build can fail on.

Harder: a native C dependency to vendor and build. Feature lag behind Git — a newer index format, a
sparse index, an extension libgit2 does not know — shows up first in the harness's fixtures and
then in an adopter's report (`docs/SDD.md` § 11 R-1). Whether the link drops the transport code
from an executable that calls into libgit2 is not measured: the only reading on record is a scratch
binary calling `Repository::open_ext` alone (`checks/deps.review.md`, the `libgit2-sys` row). The
first release build after a Git command is exported is the build that says so, and a red read is a
re-cut recorded before anything is built on that export (`docs/SDD.md` § 11 R-15). Changing the
build so that the claim holds is the SDD's to draw. Lowering the claim is the owner's.

What undoing it costs: the installed-`git` adapter behind the port, for which the seam is already
drawn (`docs/SDD.md` § 9 TO-2). Moving the trait into the model would cost an edge the units
paragraph forbids.

**What this rests on, and whose it stays.** Three platform facts, none of them this product's.
libgit2's maintenance and Git's on-disk format: lag is libgit2's expected state, and the port
exists because of it. If libgit2's holder stops answering, the substitute costs exactly what this
decision bought: the installed `git` is a prerequisite a fresh Mac does not have, so C-3's "at most
one widely-available prerequisite" is spent on it, and the five-minute clock (`docs/SRS.md` § 4.7
NFR-13) absorbs a Command Line Tools install. That is the decision the lag would un-make — not the
port, and not the read-only bar, which the `--no-optional-locks` adapter keeps. The third fact is
new: `libgit2-sys` compiles the transports unconditionally (`build.rs:L152-L156`), and its holder
may change that in either direction in any release. The `nm` read keeps the claim independent of
that fact. If the holder goes silent, the vendored copy stays as locked, and the claim still rests
on the read and not on the library.

## Traces to

- `docs/SDD.md` at v27 (Settled) — § 2 force 2; § 3, the `git-reader` and `core-bridge` rows, the
  *Four physical units* paragraph and SM-2; § 4 C-R6, C-I3; § 9 TO-2; § 11 R-1, R-15; § 12, "The
  downstream boundary"; § *Open Questions*, second item; § SDD Review Notes RN-85, RN-87.
  `nozoki@70a879a:docs/SDD.md` § 11 R-6, § SDD Review Notes RN-8.
- `docs/SRS.md` § 5.3; § 4.3 NFR-5, NFR-6, NFR-8; § 7 C-3; § 8 AC-1, AC-2.
- `docs/fdr.md` PD-27, PD-29.
- `docs/trail/architecture/cycle-29.md` § 3.2 and § 3.4 — raised by the PM after `git-reader`
  landed. The answers, given in the owner's seat by a `companion-self-answer` run on 2026-10-03,
  ordered one record superseding ADR-0004 that carries both corrections. Their reasoning is
  `docs/trail/architecture/self_answer-33.md` § 3.2 and § 3.4.
- `crates/nozoki-core/src/git_reader.rs:L33` and `crates/nozoki-core/Cargo.toml:L9` at
  `nozoki@8edec4f`. `libgit2-sys 0.18.8+1.9.7`, `build.rs:L152-L156` and
  `libgit2/src/libgit2/transport.c:L33-L35`, in the registry copy the lock resolves.
- Apple's Command Line Tools page and Git's `git-status` page, cited above, as the SDD cites them.
- ADR-0004 — the record this one supersedes.
- Inputs read for this record: SDD Settled v27 · SRS Settled v12 · FDR Settled v10.

## Binds

QC-3, QC-7, QC-10, QC-11, QC-18, QC-26, QC-36, QC-50.
