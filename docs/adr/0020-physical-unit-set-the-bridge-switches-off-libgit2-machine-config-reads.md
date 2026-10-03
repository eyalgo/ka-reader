# ADR-0020: The physical unit set, with one exception to the libgit2 import rule — `core-bridge`, the Rust-side composition root, names the binding to empty libgit2's four machine-level config search paths before the adapter is wired, and nowhere else

**Status:** Proposed — supersedes ADR-0016 on acceptance
**Date:** 2026-10-03

## Context

ADR-0016 fixed four units — `nozoki-core`, `nozoki-bridge`, `nozoki-mac`, `checks/` — and stated
three rules the unit boundaries are built on: `nozoki-core` holds no `unsafe` and imports no Apple
framework, `nozoki-bridge` is the only unit that holds `unsafe`, and "only `git-reader` imports the
libgit2 binding".

When `git-reader` landed (`nozoki@126ef75`), the third rule met the product's read promise. Every
libgit2 repository open takes a config snapshot that adds four machine-level levels — system,
global, XDG and programdata (`libgit2-sys 0.18.8+1.9.7`,
`libgit2/src/libgit2/repository.c:L997-L999`, `:L1316-L1338`). Under the App Sandbox the global
level's home is taken from the password entry, which is the user's real home (`sysdir.c:L347-L359`).
Those files lie outside the granted folder and the container. The product reads nothing there
(`docs/fdr.md` R-101), and `docs/SDD.md` § 4 C-D1's *Violated by* names any such read. The one call
that stops them is `git2::opts::set_search_path`, which is an `unsafe fn` because it mutates global
state with no thread safety (`git2-0.21.0/src/opts.rs:L20-L23`). So the rules as ADR-0016 states
them leave no unit that may make the call: the core holds no `unsafe`, and the bridge may not name
the binding.

The SDD resolved it at v27, in the CTO's seat (`docs/SDD.md` § 3, the `core-bridge` row and the
*Four physical units* paragraph; § SDD Review Notes RN-87). The item carried `Seat: cto`, so no
owner's answer stands behind that note. R-101 and C-D1 stand as written.

## Decision

Four physical units, and the map from the design's parts to them — ADR-0016's, with the
`nozoki-bridge` row's last column extended:

| Unit | Kind | Holds | Is the only unit that |
|---|---|---|---|
| `nozoki-core` (`crates/nozoki-core`) | Rust library crate | `fs-reader`, `git-reader` (with the Git port), `watcher`, `folder-model`, `own-state`, `markdown-renderer`, `highlighter` | reads the folder, reads Git's on-disk state, renders Markdown to a `MarkdownDocument`, produces spans, and writes own-state |
| `nozoki-bridge` (`crates/nozoki-bridge`) | Rust static library crate (`libnozoki_bridge.a`) | `core-bridge`: the C ABI over `folder-model`'s API — `SM-4`'s function list, the `model_changed` callback, `asset_bytes`, `nozoki_free`; the generated header; the diagnostic log writer; the Rust-side composition root | exports a C ABI; holds `unsafe`; wires the libgit2 adapter to the Git port; empties libgit2's machine-level config search paths; installs the log writer |
| `nozoki-mac` | Swift package building the app's one executable | `mac-shell` (the `NSApplication`, the one window, the Open panel and its grant, the Swift-side composition root, `Info.plist`, `Entitlements.plist`, the bundle's assembly) and `surfaces` (every view, the theme tokens as values, the message catalogue) | imports AppKit; draws anything; presents the Open panel |
| `checks/` | Scripts, fixtures and one probe, build-time, not shipped | the read-only harness, the bundle probe and its control, the renderer gate and its `idle-shell` control, `view.sh`, `deps.allow`, the fixtures, and from `v1.0.0` `contract.sh` with its pin | drives the built bundle |

`nozoki-core` imports no Apple framework and holds no `unsafe`. **Only `git-reader` imports the
libgit2 binding, with one exception: `core-bridge` names it in the composition root's
config search-path switch and that switch's test, and nowhere else.** Only `own-state` and the
bridge's log writer write anything. `nozoki-bridge` is the **Rust-side composition root** — the
one place a concrete adapter is wired to the Git port and the log writer is installed — and holds
no read logic: every exported function decodes its arguments, calls `folder-model` and returns
plain data. `nozoki-mac`'s `mac-shell` is the **app's composition root** on the Swift side — the
one place `SM-4` is called — and `surfaces` never reaches the bridge, handing `mac-shell` intents
instead. `nozoki-mac` declares no package dependency and links `libnozoki_bridge.a` statically,
`nozoki-core` inside it. `checks/` may import `nozoki-core` and is never a dependency of a shipped
unit. The Rust crates sit under `crates/`, and the Swift frame lands inside `nozoki-mac/`, as
ADR-0016 records.

**The switch.** Before the libgit2 adapter is wired, and before any thread can reach libgit2, the
composition root makes four `set_search_path` calls. Each sets one of the system, global, XDG and
programdata levels to an empty search path, so a repository open adds none of the four
machine-level config files. The switch fails closed: if any of the four calls fails, the adapter
is not wired and the Git item is `failed`, so a repository is never opened with the reads on. It
runs once per process, and a second arrival at the composition root repeats nothing. The bridge's
manifest names `git2` with default features off. The switch is process setup, as the log
writer's install is, and not read logic.

## Alternatives ruled out

- **Accept the reads and lower the promise** — R-101 would then say the product reads the machine's
  Git config, which is a product promise and the owner's to lower. The SDD did not take it
  (`docs/SDD.md` RN-87; `docs/trail/sdd/self_answer-34.md` § 2.1, *Whose call it is*).
- **`unsafe` inside `git-reader`, so the reader makes the call itself** — gives up, for one call,
  the property the unit set is built on: the harness links a core with no `unsafe`.
- **Patch the vendored libgit2 build** — repeats a cost § 11 R-15 already names, and moves a
  product rule into a fork of someone else's build.
- **`git-reader` re-exports `set_search_path` and the bridge calls the re-export** — keeps the
  letter of "only `git-reader` imports the binding" and breaks what SM-2 means by it, "the adapter
  is the only thing that knows libgit2". A stated exception is easier for a cold reader to check
  than a rule kept by spelling (`docs/trail/sdd/self_answer-34.md` § 2.1, *The other readings,
  weighed*).
- **One Rust crate holding core and bridge**, and **one crate per part** — ADR-0016's readings,
  which stand and are this seat's, not the SDD's. One crate would permit `unsafe` across the whole
  library, since the workspace's `forbid` is relaxed per manifest. One crate per part draws crate
  boundaries that match neither of the two seams a reviewer reads.
- **The view in Rust through `objc2`** — weighed in the SDD and not taken; the record is ADR-0014.

## Consequences

Easier: the read promise holds for a repository open without a fork of libgit2, and `unsafe` stays
in the one unit that already holds it. The exception is narrow enough to check: the switch and its
test, and nowhere else.

Harder: with the machine-level config off, the reader sees two things differently from `git
status` in a terminal. The user's global ignore file is not applied, so a file it hides there is
listed as untracked (`libgit2/src/libgit2/attrcache.c:L345`). And a repository the current user
does not own fails to open, because the `safe.directory` entry that would allow it is read from
those levels (`repository.c:L629-L634`, `:L1172-L1173`). It is a `failed` Git item. Both follow
from R-101 as it stands, and honouring either would mean a read outside the grant.

Three things the switch does not reach. A path the repository's own config names —
`include.path`, `core.excludesfile`, `core.attributesfile` — is followed by libgit2 with no
containment check (`docs/SDD.md` § 11 R-16). How that is closed is the SDD's last *Open Question*.
`nozoki-core`'s in-process Git suites run without the bridge, so they run with the reads on. And
libgit2 still reads `HOME`, `XDG_CONFIG_HOME` and `APP_SANDBOX_CONTAINER_ID` from the environment at
init, which opens no file (`sysdir.c:L347`, `:L357`, `:L402-L405`; `docs/nfdr.md` QC-30).

The evidence is partial. The bridge's test proves the four search paths are empty, and it observes
no read. The step from an empty path to no file touched is `sysdir.c:L559-L560`, read and not run.
A libgit2 release that adds a fifth level would not be caught by a test naming four. The lockfile
change reviewed as code is the only gate for that (`docs/SDD.md` § 4 C-R6, C-I3).

What undoing it costs: removing the exception needs another unit that may make an `unsafe` call,
or the promise lowered.

**What this rests on, and whose it stays.** Two platform facts. The first is libgit2's config
levels and its rule that an empty search path touches no file. libgit2's maintainers hold that
rule, and a release may add a level or change the rule. The second is `git2`'s `set_search_path`,
held by the `git2` maintainers. If either holder goes silent, the vendored copy stays as locked and
the switch keeps working on it. The first lockfile change that moves either crate is where the
exception is re-read.

## Traces to

- `docs/SDD.md` at v27 (Settled) — § 3, the `core-bridge` and `git-reader` rows, the *Four
  physical units* paragraph, SM-2; § 4 C-D1, C-D3, C-R6, C-I3; § 6 `see-git-status`, *Reached
  when*, command half; § 11 R-15, R-16; § *Open Questions*, second and last items; § SDD Review
  Notes RN-87.
- `docs/trail/sdd/cycle-22.md` § 2.1, answered in the CTO's seat, and its reasoning,
  `docs/trail/sdd/self_answer-34.md` § 2.1.
- `docs/trail/architecture/cycle-29.md` § 3.5 — the PM's item that raised the reads, and its answer
  raising the unit question to the SDD (reasoning `docs/trail/architecture/self_answer-33.md`
  § 3.5).
- `docs/fdr.md` R-101, R-153. `docs/SRS.md` NFR-7, DR-6.
- `libgit2-sys 0.18.8+1.9.7` and `git2-0.21.0`, in the registry copies the lock resolves, at the
  lines cited above.
- ADR-0016 — the record this one supersedes on acceptance. ADR-0013 (the seams), ADR-0014 (the
  languages), ADR-0019 (the port).
- Inputs read for this record: SDD Settled v27 · SRS Settled v12 · FDR Settled v10.

## Binds

QC-8 – QC-17, QC-20, QC-35.
