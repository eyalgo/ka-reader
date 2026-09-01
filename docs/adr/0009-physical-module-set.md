# ADR-0009: The physical module set — `nozoki-core` as a library both the host and the harness link, `nozoki-app` as the only Tauri-aware unit, `nozoki-ui` as a capability-free bundle, `checks/` outside the bundle

**Status:** Accepted
**Date:** 2026-09-01

## Context

The design names three deliverables — `nozoki-core` (a Rust library), `nozoki-app` (the Tauri host
binary), `nozoki-ui` (the renderer) — in one bundle, plus a build-time harness under `checks/`, and
assigns each of nine parts to one of them with what it owns and must not own (`docs/SDD.md` § 3,
"The parts"). That `nozoki-core` is a **library separate from the host binary** is visible in the
design — the harness exercises "every command on the IPC list through `nozoki-core`"
(`docs/SDD.md` § 4 C-I3), the first slice's bar says "`nozoki-core` links no `git-reader` in this
slice" (§ 6 S-1), and the sixth's names `nozoki-ui/src/tree`, `nozoki-ui/src/git-view` and
`nozoki-ui/src/reading-panel` (§ 6 S-6) — but the choice is argued in none of the SDD's three
decision surfaces. **This record is reconstructed** from those facts; its alternatives are this
seat's reading of what the design implies, not a weighing the SDD performed.

## Decision

Four physical units, and the map from the design's parts to them:

| Unit | Kind | Holds | Is the only unit that |
|---|---|---|---|
| `nozoki-core` | Rust library crate | `fs-reader`, `git-reader` (with the Git port), `watcher`, `folder-model`, `own-state`, `markdown-renderer` | reads the folder, reads Git's on-disk state, renders Markdown, and writes own-state |
| `nozoki-app` | Rust binary crate (the Tauri 2 host) | `ipc-surface`: the closed command list, the asset handler, the window, the entitlements, the Content Security Policy, the diagnostic log | imports Tauri; wires the libgit2 adapter behind the Git port; writes the log |
| `nozoki-ui` | TypeScript package, bundled into the app | `surfaces`, with the highlighter and its bundled grammars | renders anything |
| `checks/` | Scripts and fixtures, build-time, not shipped | the read-only harness, the bundle probe, the fixtures | drives the built bundle |

`nozoki-app` is the **composition root**: the one place a concrete implementation is wired to the
Git port and the one place the Tauri runtime is touched (drawn on: `arch_defaults.md` v2.0.0
§ Composition Root — a doctrine default this product's design already matches). `nozoki-core`
imports no Tauri crate, so the harness links it without a window; only `git-reader` imports the
libgit2 binding; only `own-state` and the host's log module write anything; `checks/` may import
`nozoki-core` and is never a dependency of a shipped unit.

## Alternatives ruled out

*(Reconstructed — readings of the design, not the SDD's own weighing.)*

- **One crate holding host and core** — the harness would need the Tauri runtime to exercise a
  read, and the read-only property of the pipeline could not be proved apart from the app; the
  first slice's own bar ("`nozoki-core` links no `git-reader`") could not be stated.
- **One crate per part** — more units than seams; the design draws two boundaries a reviewer must
  read (the Git port and the IPC surface), and a crate boundary that matches neither buys nothing.

## Consequences

Easier: the harness proves the pipeline without a window; the substitution seam (the Git port) and
the capability seam (the IPC surface) fall on unit boundaries a reviewer reads in a diff; a forbidden
import across a crate boundary is a build failure, not a convention. Harder: a Rust workspace of two
crates plus a TypeScript package, and two toolchains — `cargo` and, for the renderer, the
TypeScript packet's `pnpm` and Vite (`docs/nfdr.md` § 9).

What undoing it costs: merging or splitting crates is a workspace edit; the module boundaries this
record fixes are the ones `docs/nfdr.md` § 1.2 binds, and moving one moves that section with it.

## Traces to

- Reconstructed from `docs/SDD.md` § 3 ("Three deliverables …" and the parts table), § 4 C-I3,
  § 6 S-1 (the command half of *Reached when*) and § 6 S-6 (the `git diff --stat` paths).
- `arch_defaults.md` v2.0.0 § Package Structure, § Composition Root — drawn on, not applied; a
  doctrine file of the organisation that publishes this product, outside this repository.
- ADR-0001 (the seams), ADR-0002 (the units' languages), ADR-0004 (the port).
- `docs/trail/architecture/cycle-1.md` § 2.5 — the owner's confirmation: the record moves to
  Accepted with its *(Reconstructed …)* marking kept, because the unit set is settled SDD content
  and only the weighing is this seat's.

## Binds

QC-8 – QC-17.
