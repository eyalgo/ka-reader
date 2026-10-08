# ADR-0020: The physical unit set, with one exception to the libgit2 import rule — `core-bridge`, the Rust-side composition root, names the binding to empty libgit2's four machine-level config search paths before the adapter is wired, and nowhere else

**Status:** Accepted — supersedes ADR-0016
**Date:** 2026-10-03

## Context

ADR-0016 fixed four units — `ka-reader-core`, `ka-reader-bridge`, `ka-reader-mac`, `checks/` — and stated
three rules the unit boundaries are built on: `ka-reader-core` holds no `unsafe` and imports no Apple
framework, `ka-reader-bridge` is the only unit that holds `unsafe`, and "only `git-reader` imports the
libgit2 binding". The unit set itself came from the re-cut at `docs/SDD.md` § 10 RC-3, which
retired the Tauri host and the web renderer, and the SDD states it in its own words (§ 3, "Four
physical units carry the eleven parts"). The boundary that matters most is argued there:
`ka-reader-core` "imports no Apple framework and holds no `unsafe`, so the harness links it without a
window", and the workspace forbids `unsafe` while one manifest relaxes it with its reason
(`Cargo.toml` `[workspace.lints.rust]`; `crates/ka-reader-bridge/Cargo.toml`).

When `git-reader` landed (`ka-reader@126ef75`), the third rule met the product's read promise. Every
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

Four physical units, and the map from the design's parts to them:

| Unit | Kind | Holds | Is the only unit that |
|---|---|---|---|
| `ka-reader-core` (`crates/ka-reader-core`) | Rust library crate | `fs-reader`, `git-reader` (with the Git port), `watcher`, `folder-model`, `own-state`, `markdown-renderer`, `highlighter` | reads the folder, reads Git's on-disk state, renders Markdown to a `MarkdownDocument`, produces spans, and writes own-state |
| `ka-reader-bridge` (`crates/ka-reader-bridge`) | Rust static library crate (`libka_reader_bridge.a`) | `core-bridge`: the C ABI over `folder-model`'s API — `SM-4`'s function list, the `model_changed` callback, `asset_bytes`, `ka_reader_free`; the generated header; the diagnostic log writer; the Rust-side composition root | exports a C ABI; holds `unsafe`; wires the libgit2 adapter to the Git port; empties libgit2's machine-level config search paths; installs the log writer |
| `ka-reader-mac` | Swift package building the app's one executable | `mac-shell` (the `NSApplication`, the one window, the Open panel and its grant, the Swift-side composition root, `Info.plist`, `Entitlements.plist`, the bundle's assembly) and `surfaces` (every view, the theme tokens as values, the message catalogue) | imports AppKit; draws anything; presents the Open panel |
| `checks/` | Scripts, fixtures and one probe, build-time, not shipped | the read-only harness, the bundle probe and its control, the renderer gate and its `idle-shell` control, `view.sh`, `deps.allow`, the fixtures, and from `v1.0.0` `contract.sh` with its pin | drives the built bundle |

`ka-reader-core` imports no Apple framework and holds no `unsafe`. **Only `git-reader` imports the
libgit2 binding, with one exception: `core-bridge` names it in the composition root's
config search-path switch and that switch's test, and nowhere else.** Only `own-state` and the
bridge's log writer write anything. `ka-reader-bridge` is the **Rust-side composition root** — the
one place a concrete adapter is wired to the Git port and the log writer is installed — and holds
no read logic: every exported function decodes its arguments, calls `folder-model` and returns
plain data. `ka-reader-mac`'s `mac-shell` is the **app's composition root** on the Swift side — the
one place `SM-4` is called — and `surfaces` never reaches the bridge, handing `mac-shell` intents
instead (`docs/SDD.md` § 3 SM-8). `ka-reader-mac` declares no package dependency and links
`libka_reader_bridge.a` statically, `ka-reader-core` inside it (§ 3, "Two libraries, one executable, one
bundle"). `checks/` may import `ka-reader-core` and is never a dependency of a shipped unit.

**Where the units sit.** The Rust crates sit under `crates/`, because that placement is the owner's
ruling for every Rust product in this instance (`kensaiapp-dev@49e0444f`, carried by
`docs/nfdr.md` § 9; `docs/SDD.md` § 3, the *Four physical units* paragraph), and the workspace's
`members = ["crates/*"]` makes a crate created there a member with no manifest edit. The Swift
frame (`Package.swift`, `Sources/`, `Tests/`) lands inside `ka-reader-mac/`, where the project's test
command goes to find it. It was laid out by hand in the slice that landed it, and its inner layout
is the Swift packet's and `docs/nfdr.md` § 9's (`docs/SDD.md` § 3, the Swift-frame paragraph).

**The switch.** Before the libgit2 adapter is wired, and before any thread can reach libgit2, the
composition root makes four `set_search_path` calls. Each sets one of the system, global, XDG and
programdata levels to an empty search path, so a repository open adds none of the four
machine-level config files. The switch fails closed: if any of the four calls fails, the adapter
is not wired and the Git item is `failed`, so a repository is never opened with the reads on. It
runs once per process, and a second arrival at the composition root repeats nothing. The bridge's
manifest names `git2` with default features off. The switch is process setup, as the log
writer's install is, and not read logic.

Drawn on, not applied: `arch_defaults.md` v2.0.0 § Composition Root — two roots, one per language,
each the single place its runtime is touched.

## Alternatives ruled out

*(The fifth and sixth are reconstructed — this seat's readings of the design, carried from ADR-0016
and before it ADR-0009, not the SDD's own weighing. The rest are the SDD's.)*

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
- **One Rust crate holding core and bridge** — `unsafe` would then be permitted across the whole
  library, since the workspace's `forbid` is relaxed per manifest and not per module, and the
  harness would link the C-ABI unit to make an in-process read. Splitting them keeps
  `unsafe_code = "forbid"` true of everything that reads and gives the C ABI one review surface
  (`docs/SDD.md` § 3, the units paragraph; § 11 R-13).
- **One crate per part** — more units than seams. The design draws two boundaries a reviewer must
  read on the Rust side, the Git port and the C ABI, and a crate boundary that matches neither buys
  nothing.
- **The view in Rust, through `objc2`, so the product is one language and one toolchain** —
  weighed in the SDD and not taken (`docs/SDD.md` § 2, the view-language paragraph); the record is
  ADR-0014, and the unit set follows it.

## Consequences

Easier: the harness proves the pipeline without a window, through `SM-5` (`docs/SDD.md` § 4 C-I3).
`unsafe` lives in one unit with one review, and the switch adds no second one. A forbidden import
across a crate boundary is a build failure, not a convention. The substitution seam (the Git port)
and the capability seam (`SM-4`) fall on unit boundaries a reviewer reads in a diff. The Swift side
brings nothing to the tree. The read promise holds for a repository open without a fork of
libgit2, and the exception is narrow enough to check: the switch and its test, and nowhere else.

Harder: two toolchains, `cargo` and `swift`. A C ABI to keep honest: a generated header never
hand-edited, every buffer owned and freed by `ka_reader_free` alone, every function catching a panic
at the boundary, and the bridge's tests under the address sanitizer in CI (§ 11 R-13). A Swift
package whose departures from the Swift packet, and the toolchain CI builds it with, are this
product's own to record (`docs/nfdr.md` § 9).

With the machine-level config off, the reader sees two things differently from `git status` in a
terminal. The user's global ignore file is not applied, so a file it hides there is listed as
untracked (`libgit2/src/libgit2/attrcache.c:L345`). And a repository the current user does not own
fails to open, because the `safe.directory` entry that would allow it is read from those levels
(`repository.c:L629-L634`, `:L1172-L1173`). It is a `failed` Git item. Both follow from R-101 as it
stands, and honouring either would mean a read outside the grant.

Three things the switch does not reach. A path the repository's own config names —
`include.path`, `core.excludesfile`, `core.attributesfile` — is followed by libgit2 with no
containment check (`docs/SDD.md` § 11 R-16). How that is closed is the SDD's last *Open Question*.
`ka-reader-core`'s in-process Git suites run without the bridge, so they run with the reads on. And
libgit2 still reads `HOME`, `XDG_CONFIG_HOME` and `APP_SANDBOX_CONTAINER_ID` from the environment at
init, which opens no file (`sysdir.c:L347`, `:L357`, `:L402-L405`; `docs/nfdr.md` QC-30).

The evidence is partial. The bridge's test proves the four search paths are empty, and it observes
no read. The step from an empty path to no file touched is `sysdir.c:L559-L560`, read and not run.
A libgit2 release that adds a fifth level would not be caught by a test naming four. The lockfile
change reviewed as code is the only gate for that (`docs/SDD.md` § 4 C-R6, C-I3).

What undoing it costs: merging or splitting crates is a workspace edit, and the module boundaries
this record fixes are the ones `docs/nfdr.md` § 1.2 binds, so moving one moves that section with
it. Removing the exception needs another unit that may make an `unsafe` call, or the promise
lowered.

**What this rests on, and whose it stays.** Cargo's workspace and its lint table are the Rust
project's; Swift Package Manager and its `swift build` / `swift test` are Apple's. Neither holder
owes this product anything, and the unit set survives either moving: the seams are a trait (the Git
port), a C header and an intent set, none of which a toolchain owns. The one fact that makes
`ka-reader-bridge` *the* unit holding `unsafe` is a line in `crates/ka-reader-bridge/Cargo.toml` this
product controls. The switch rests on two more platform facts. The first is libgit2's config levels
and its rule that an empty search path touches no file. libgit2's maintainers hold that rule, and a
release may add a level or change the rule. The second is `git2`'s `set_search_path`, held by the
`git2` maintainers. If either holder goes silent, the vendored copy stays as locked and the switch
keeps working on it. The first lockfile change that moves either crate is where the exception is
re-read.

## Traces to

- `docs/SDD.md` at v27 (Settled) — § 2, the view-language paragraph; § 3, the `core-bridge`,
  `git-reader`, `mac-shell`, `surfaces`, `highlighter` and `read-only-harness` rows, the *Four
  physical units* paragraph, the Swift-frame paragraph, SM-2, SM-4, SM-5, SM-8, "Two libraries, one
  executable, one bundle"; § 4 C-D1, C-D3, C-R6, C-I3; § 6 `see-git-status`, *Reached when*,
  command half; § 10 RC-3; § 11 R-13, R-15, R-16; § *Open Questions*, second and last items; § SDD
  Review Notes RN-4, RN-60, RN-66, RN-87.
- `docs/trail/sdd/cycle-22.md` § 2.1, answered in the CTO's seat, and its reasoning,
  `docs/trail/sdd/self_answer-34.md` § 2.1.
- `docs/trail/architecture/cycle-29.md` § 3.5 — the PM's item that raised the reads, and its answer
  raising the unit question to the SDD (reasoning `docs/trail/architecture/self_answer-33.md`
  § 3.5).
- `docs/trail/architecture/cycle-30.md` § 2.1 — the confirm, given in the owner's seat by a
  `companion-self-answer` run on 2026-10-03, on which this record is Accepted and ADR-0016
  superseded. Its addition ordered that this record carry ADR-0016's grounds for the `crates/`
  placement and the Swift frame, its consequences, its undo cost, what it rests on and its
  *drawn on* line, so the record in force stands alone. Reasoning:
  `docs/trail/architecture/self_answer-34.md` § 2.1.
- `docs/fdr.md` R-101, R-153. `docs/SRS.md` NFR-7, DR-6.
- `Cargo.toml` — `members = ["crates/*"]` (`:L8`) and `[workspace.lints.rust]
  unsafe_code = "forbid"` (`:L11`, `:L16`); `crates/ka-reader-bridge/Cargo.toml:L11-L15`, the one
  relaxation and its reason. Read at `ka-reader@2f15e2c`.
- `libgit2-sys 0.18.8+1.9.7` and `git2-0.21.0`, in the registry copies the lock resolves, at the
  lines cited above.
- `arch_defaults.md` v2.0.0 § Package Structure, § Composition Root — drawn on, not applied; a
  doctrine file of the organisation that publishes this product, outside this repository. The
  owner's ruling `kensaiapp-dev@49e0444f` and the Rust and Swift packets, as `docs/nfdr.md` § 9
  carries them.
- ADR-0016 — the record this one supersedes; ADR-0009 before it. ADR-0013 (the seams), ADR-0014
  (the languages), ADR-0019 (the port).
- Inputs read for this record: SDD Settled v27 · SRS Settled v12 · FDR Settled v10.

## Binds

QC-8 – QC-17, QC-20, QC-24, QC-35, QC-61, QC-63.
