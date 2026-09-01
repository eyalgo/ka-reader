# ADR-0001: Nozoki is a capability-split read pipeline, and its promise is held by withholding capability

**Status:** Accepted
**Date:** 2026-09-01

## Context

The one rule this product must never break is negative: nothing writes to the viewed folder,
nothing connects to a network, nothing read from the folder is executed — and each of those must
hold through a crash, not only in normal operation (`docs/SRS.md` § 4.2 NFR-4; § 4.3 NFR-5, NFR-6,
NFR-8, NFR-16). The folder is live, untrusted input that may change at any moment (§ 6 DR-6). The
design document set itself a test before naming a shape: a candidate that answers "is the no-write,
no-network promise true by construction?" with *if the code is careful* loses to one that answers it
structurally, whatever else it costs (`docs/SDD.md` § 1, last paragraph). A negative invariant is
not held by a guarded domain core; it is held by withholding a capability at a boundary something
outside the code enforces (`docs/SDD.md` § 2, force 3).

## Decision

The system is a **capability-split read pipeline**: two read-only sources — the filesystem and,
where the granted folder is itself a repository's root, that repository's Git state — feed one
in-memory folder model, and the surfaces are projections of it. The surfaces run in a **renderer
process that holds no filesystem, network or shell capability**; the host holds read capability
only, fenced by the operating-system sandbox (ADR-0003). The seam between them is a closed list of
commands plus one read-only asset scheme, and that seam *is* the promise: a builder of the renderer
who holds only that contract cannot write, cannot connect, and cannot read outside the folder
(`docs/SDD.md` § 3, seam 4).

Adding a **read surface** — a diff, a history, a folder chosen at runtime — is priced cheap. Adding a
**capability** — a write, a socket, a shell — costs a visible change to a boundary a reviewer reads
(an entitlement, a command on the closed list, a directive in the Content Security Policy), on
purpose (`docs/SDD.md` § 2, force 1).

## Alternatives ruled out

- **Hexagonal — a domain core behind ports, an adapter at every edge** — the product has two stable
  edges (Apple's filesystem, Git's on-disk format) and a core that would hold the folder model and
  no rule; the ports would guard nothing. Its one useful port, the Git reader, is kept (ADR-0004).
  It wins only if the agent-workflow front end ever comes inside the terminus and brings its own
  edges, which the project's terminus places outside done (`docs/SDD.md` § 2, table row 2;
  `docs/fdr.md` OOS-14).
- **Layered, one process — UI over services over a data-access layer** — the data layer's generic
  filesystem and network access is exactly the capability this product must not hold, so not-writing
  becomes discipline. Fails § 1's first question by construction (`docs/SDD.md` § 2, table row 3).
- **Native single-process model-view (AppKit / SwiftUI) under the same sandbox** — the honest
  runner-up: it keeps the sandbox wall and loses the renderer wall. Ruled out because Markdown must
  render (`docs/SRS.md` § 3.3 FR-30) and the design language is expressed as CSS tokens and vendored
  SVG icons (`docs/UXD.md` § 9; `docs/DESIGN.md` § DESIGN Review Notes RN-1). The runtime half of
  this weighing is ADR-0002 (`docs/SDD.md` § 2, table row 4).
- **Local server + browser tab — the input proposal's "web app"** — a listening socket is a network
  call during operation, which NFR-8 forbids; and the README no longer calls the product a web app
  (`docs/PRD.md` § Out of Scope, last item; `docs/SDD.md` § 2, table row 5).

## Consequences

Easier: the read-only and no-network acceptance criteria (`docs/SRS.md` § 8 AC-1 – AC-3) pass because
the write and the network are *absent*, not avoided; every foreseen change is a new read surface on
the same two sources, and the model in the middle survives every reversal below. Harder: two
processes, one serialized seam, and every projection crossing it; a second wall (sanitizer and CSP —
ADR-0006) to keep NFR-16 once untrusted content is rendered as HTML.

What undoing it costs: collapsing the two processes into one costs the IPC surface rewritten as
direct calls, and nothing else — the model survives. Replacing the renderer technology costs every
surface (ADR-0002). Removing the sandbox costs one entitlements file — and the wall, which is why its
presence is checked on every build rather than assumed (ADR-0008) (`docs/SDD.md` § 2, "Undoing it").

## Traces to

- `docs/SDD.md` § 2 — the seven forces, the candidates table, and "Undoing it"; § 3 seam 4; § 12,
  "The downstream boundary" (surfaced for an ADR); § SDD Review Notes RN-6.
- `docs/SRS.md` § 4.2 NFR-4; § 4.3 NFR-5, NFR-6, NFR-8, NFR-16; § 6 DR-6; § 7 C-1.
- `docs/fdr.md` PD-1, PD-6, PD-7, PD-26, PD-29 — the behaviour this shape realizes.
- Inputs read for this record: SDD Settled v2 · SRS Settled v8 · FDR Draft v1.

## Binds

QC-1, QC-2, QC-8, QC-9, QC-15, QC-16, QC-24, QC-30, QC-32, QC-34.
