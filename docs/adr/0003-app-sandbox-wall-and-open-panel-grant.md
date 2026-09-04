# ADR-0003: The App Sandbox is the write-and-network wall, so the folder is granted through the Open panel and never typed

**Status:** Accepted
**Date:** 2026-09-01

## Context

The read-only promises must hold during and after crashes and abnormal exits (`docs/SRS.md` § 4.2
NFR-4). Convention cannot promise that and an operating-system sandbox can (`docs/SDD.md` § 2,
force 5). Under Apple's App Sandbox a folder is readable only when the user selected it: the
read-only entitlement grants "read-only access to files the user has selected using an Open or Save
dialog" (https://developer.apple.com/documentation/bundleresources/entitlements/com.apple.security.files.user-selected.read-only),
and outgoing connections are what a separate network entitlement enables
(https://developer.apple.com/documentation/bundleresources/security-entitlements). So the wall and
the start mechanism are one decision: the sandbox decides how a folder can be opened at all.

## Decision

The bundle runs under the App Sandbox with **exactly these entitlements**:
`com.apple.security.app-sandbox`, `com.apple.security.files.user-selected.read-only`, and — once
the folder selector exists — `com.apple.security.files.bookmarks.app-scope`. **No network
entitlement is present**, so an outgoing connection is refused by the operating system
(`docs/SDD.md` § 4 C-R2).

The folder is **granted, never typed**: the host presents the system Open panel, the grant is made
once per folder, and a remembered folder is a security-scoped bookmark re-opened without asking.
Once the selector exists, launch restores the last-viewed folder from its bookmark and presents the
panel only when nothing is remembered or the bookmark no longer resolves. A path that does not
exist, is not a folder, or cannot be read is reported in the app's window, never on a terminal
(`docs/SDD.md` § 4 C-R3; owner-confirmed with the per-folder reconciliation,
`nozoki@70a879a:docs/trail/sdd/cycle-1.md` § 2.3).

## Alternatives ruled out

- **No sandbox, with a typed path or a launch argument as the start** — the sandbox cannot grant a
  typed path, so the read-only entitlement goes and the OS wall goes with it; the no-write promise
  then rests on the harness and the code alone — § 1's "if the code is careful". This is the
  override branch the owner was shown and did not take (`nozoki@70a879a:docs/trail/sdd/cycle-1.md` § 2.3, "If
  overridden").
- **The sandbox with the network-client entitlement present** — nothing in the SRS needs a
  connection during operation (`docs/SRS.md` § 4.3 NFR-8; § 5.3), and an entitlement nobody uses is
  a wall with a door in it.

## Consequences

Easier: no write and no connection because the operating system refuses, not because the code
declines; the read-only, Git-state and zero-traffic checks (`docs/SRS.md` § 8 AC-1 – AC-3) hold
structurally. Harder: the Open panel is the start, which can read as a setup step to a stranger
(`docs/SDD.md` § 11 R-9); remembering a folder needs bookmarks; a linked worktree or a submodule
whose Git directory lies outside the granted folder cannot be read past the grant, and the product
shows that as a Git-view failure naming the folder to choose (`docs/SDD.md` § 11 R-3;
`docs/fdr.md` R-21); whether a folder dropped on the Dock icon or opened with *Open With* is granted
the same way is unverified (`docs/SDD.md` § Open Questions, first item).

What undoing it costs: one entitlements file — and the wall (`docs/SDD.md` § 9 TO-3).

**What this rests on, and whose it stays.** The App Sandbox, its entitlement semantics and the
Open-panel grant are Apple's, and they move with macOS on Apple's schedule. Two things are
unverified from documents and are proved on the first built bundle instead: that the sandbox is
enforced under an ad-hoc signature (ADR-0007, ADR-0008), and the drop / Open-With grant above. If
Apple narrows what a user-selected grant covers, what is un-made is the start mechanism (C-R3) and
the bookmark path — not the shape (ADR-0001), whose renderer still holds nothing.

## Traces to

- `docs/SDD.md` § 2 force 5; § 4 C-R2, C-R3; § 9 TO-3; § 11 R-3, R-8, R-9;
  § Open Questions (first and fourth items); `nozoki@70a879a:docs/SDD.md` § SDD Review Notes RN-9.
- `nozoki@70a879a:docs/trail/sdd/cycle-1.md` § 2.3 — the owner's confirmation and the per-folder reconciliation.
- `docs/SRS.md` § 4.2 NFR-4; § 4.3 NFR-5, NFR-8; § 3.1 FR-2, FR-3.
- `docs/fdr.md` R-3, R-4, R-5, R-7, R-8, R-21, PD-14, OOS-19.
- Apple's two entitlement pages, cited above, as the SDD cites them.

## Binds

QC-2, QC-25, QC-32, QC-33, QC-35, QC-49, QC-58.
