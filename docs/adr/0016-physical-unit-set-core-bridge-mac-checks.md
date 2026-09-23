# ADR-0016: The physical unit set — `nozoki-core` a Rust library with no `unsafe` and no Apple framework; `nozoki-bridge` a Rust static library, the only unit that exports the C ABI and the only one that holds `unsafe`; `nozoki-mac` a Swift package with no dependency, the only unit that imports AppKit; `checks/` outside the bundle

**Status:** Accepted — supersedes ADR-0009
**Date:** 2026-09-23

## Context

ADR-0009 fixed four units — `nozoki-core`, `nozoki-app` (the Tauri host), `nozoki-ui` (the
renderer), `checks/` — reconstructed from a design that assigned every part a home and weighed
the split nowhere. The re-cut at `docs/SDD.md` § 10 RC-3 retires `nozoki-app` and `nozoki-ui` and
brings `nozoki-bridge` and `nozoki-mac`, and `highlighter` joins `nozoki-core` as a part of its
own. At v13 the unit set is stated in the design's own table and paragraph (§ 3, "Four physical
units carry the eleven parts", the units table), and the one boundary that matters most is
argued: `nozoki-core` "imports no Apple framework and holds no `unsafe`, so the harness links it
without a window", and `nozoki-bridge` is "the only unit that exports a C ABI and the only one
that holds `unsafe`" — the workspace forbids `unsafe` and one manifest relaxes it with its reason
(`Cargo.toml`, `[workspace.lints.rust]`; § 3 `core-bridge` row). What the design still does not
weigh — one crate against two on the Rust side, and one crate per part — is this seat's reading,
marked as such below, as ADR-0009's was.

## Decision

Four physical units, and the map from the design's parts to them:

| Unit | Kind | Holds | Is the only unit that |
|---|---|---|---|
| `nozoki-core` (`crates/nozoki-core`) | Rust library crate | `fs-reader`, `git-reader` (with the Git port), `watcher`, `folder-model`, `own-state`, `markdown-renderer`, `highlighter` | reads the folder, reads Git's on-disk state, renders Markdown to a `MarkdownDocument`, produces spans, and writes own-state |
| `nozoki-bridge` (`crates/nozoki-bridge`) | Rust static library crate (`libnozoki_bridge.a`) | `core-bridge`: the C ABI over `folder-model`'s API — `SM-4`'s function list, the `model_changed` callback, `asset_bytes`, `nozoki_free`; the generated header; the diagnostic log writer; the Rust-side composition root | exports a C ABI; holds `unsafe`; wires the libgit2 adapter to the Git port; installs the log writer |
| `nozoki-mac` | Swift package building the app's one executable | `mac-shell` (the `NSApplication`, the one window, the Open panel and its grant, the Swift-side composition root, `Info.plist`, `Entitlements.plist`, the bundle's assembly) and `surfaces` (every view, the theme tokens as values, the message catalogue) | imports AppKit; draws anything; presents the Open panel |
| `checks/` | Scripts, fixtures and one probe, build-time, not shipped | the read-only harness, the bundle probe and its control, the renderer gate and its `idle-shell` control, `view.sh`, `deps.allow`, the fixtures, and from `v1.0.0` `contract.sh` with its pin | drives the built bundle |

`nozoki-core` imports no Apple framework and holds no `unsafe`; only `git-reader` imports the
libgit2 binding; only `own-state` and the bridge's log writer write anything. `nozoki-bridge` is
the **Rust-side composition root** — the one place a concrete adapter is wired to the Git port and
the log writer is installed — and holds no read logic: every exported function decodes its
arguments, calls `folder-model` and returns plain data. `nozoki-mac`'s `mac-shell` is the **app's
composition root** on the Swift side — the one place `SM-4` is called — and `surfaces` never
reaches the bridge, handing `mac-shell` intents instead (`docs/SDD.md` § 3 SM-8). `nozoki-mac`
declares no package dependency and links `libnozoki_bridge.a` statically, `nozoki-core` inside it
(§ 3, "Two libraries, one executable, one bundle"). `checks/` may import `nozoki-core` and is never
a dependency of a shipped unit. The Rust crates sit under `crates/` — the owner's ruling for every
Rust product in this instance (`kensaiapp-dev@49e0444f`, carried by `docs/nfdr.md` § 9) — and the
Swift frame (`Package.swift`, `Sources/`, `Tests/`) lands inside `nozoki-mac/`, laid out by hand
in the slice that landed it, its inner layout the Swift packet's and `docs/nfdr.md` § 9's
(`docs/SDD.md` § 3, the Swift-frame paragraph at v16) *(corrected in place 2026-09-23 — as
accepted earlier that day this clause read "laid out by the slice that lands it, because no Swift
packet exists in the organisation's language registry"; the registry gained `languages/swift/`
the same day, `kensaiapp-dev@3ab2e8553`; the answer at `docs/trail/architecture/cycle-10.md`
§ 3.4)*. Drawn on, not applied: `arch_defaults.md` v2.0.0
§ Composition Root — two roots, one per language, each the single place its runtime is touched.

## Alternatives ruled out

*(The first two are reconstructed — this seat's readings of the design, not the SDD's own
weighing; the third is the SDD's.)*

- **One Rust crate holding core and bridge** — `unsafe` would then be permitted across the whole
  library, since the workspace's `forbid` is relaxed per manifest and not per module, and the
  harness would link the C-ABI unit to make an in-process read; splitting them keeps
  `unsafe_code = "forbid"` true of everything that reads and gives the C ABI one review surface
  (`docs/SDD.md` § 3, the units paragraph; § 11 R-13).
- **One crate per part** — more units than seams: the design draws two boundaries a reviewer must
  read on the Rust side (the Git port and the C ABI), and a crate boundary that matches neither
  buys nothing — ADR-0009's reading, unchanged.
- **The view in Rust, through `objc2`, so the product is one language and one toolchain** —
  weighed in the SDD and not taken (`docs/SDD.md` § 2, the view-language paragraph); the record is
  ADR-0014, and the unit set follows it.

## Consequences

Easier: the harness proves the pipeline without a window, through `SM-5` (`docs/SDD.md` § 4 C-I3);
`unsafe` lives in one unit with one review; a forbidden import across a crate boundary is a build
failure, not a convention; the substitution seam (the Git port) and the capability seam (`SM-4`)
fall on unit boundaries a reviewer reads in a diff; and the Swift side brings nothing to the tree.
Harder: two toolchains — `cargo` and `swift` — and a C ABI to keep honest: a generated header
never hand-edited, every buffer owned and freed by `nozoki_free` alone, every function catching a
panic at the boundary, the bridge's tests under the address sanitizer in CI (§ 11 R-13); and a
Swift package whose departures from the Swift packet — and the toolchain CI builds it with — are
this product's own to record (`docs/nfdr.md` § 9) *(corrected in place 2026-09-23, as in
§ Decision; as accepted it read "with no language packet behind it, so its layout and its testing
tool are this product's own to record")*.

What undoing it costs: merging or splitting crates is a workspace edit; the module boundaries this
record fixes are the ones `docs/nfdr.md` § 1.2 binds, and moving one moves that section with it.

**What this rests on, and whose it stays.** Cargo's workspace and its lint table are the Rust
project's; Swift Package Manager and its `swift build` / `swift test` are Apple's. Neither holder
owes this product anything, and the unit set survives either moving: the seams are a trait (the
Git port), a C header and an intent set, none of which a toolchain owns. The one fact that makes
`nozoki-bridge` *the* unit holding `unsafe` is a line in `Cargo.toml` this product controls.

## Traces to

- `docs/SDD.md` at v13 (`nozoki@b236e7b`, Draft) — § 3: the parts table (`core-bridge`,
  `mac-shell`, `surfaces`, `highlighter`, `read-only-harness` rows), "Four physical units carry
  the eleven parts", the units table, the Swift-frame paragraph, SM-4, SM-5, SM-8, "Two libraries,
  one executable, one bundle"; § 4 C-R1, C-R6, C-R7, C-I3; § 6 S-1, command half; § 9 TO-1; § 10
  RC-3; § 11 R-13; § SDD Review Notes RN-4, RN-36, RN-60.
- `Cargo.toml` — `[workspace] members = ["crates/*"]` and `[workspace.lints.rust]
  unsafe_code = "forbid"`, opened for this record on 2026-09-23.
- `arch_defaults.md` v2.0.0 § Package Structure, § Composition Root — drawn on, not applied; a
  doctrine file of the organisation that publishes this product, outside this repository.
  `languages/rust/layout.md` § A multi-crate product, and the owner's ruling `kensaiapp-dev@49e0444f`,
  as `docs/nfdr.md` § 9 and RN-7 carry them; `<CORE>/doctrine/engineering/languages/` listed
  2026-09-23 — `javascript`, `python`, `rust`, `shell`, `typescript`, no Swift.
- ADR-0009 — the record this one supersedes; its reconstructed marking is kept here for the two
  readings that are still this seat's. ADR-0013 (the seams), ADR-0014 (the languages), ADR-0004
  (the port).
- `docs/trail/architecture/cycle-8.md` § 2.3 — the item that raised this record as owed;
  `docs/trail/architecture/cycle-9.md` § 2.3 — the owner's confirm, given in the owner's seat by a
  `companion-self-answer` run on 2026-09-23 (its reasoning,
  `docs/trail/architecture/self_answer-12.md` § 2.3), on which this record is Accepted and
  ADR-0009 superseded. Accepted with `docs/SDD.md` at v14 (`nozoki@2739007`, Draft): v14's edge
  — the model calls `markdown-renderer` and `highlighter` to fill a `FileView`, neither importing
  the model (§ 3, RN-64) — runs inside `nozoki-core` and moves no unit and no boundary this record
  fixes; the import it adds is `docs/nfdr.md` QC-10's.
- `docs/SDD.md` at v16 (`nozoki@097ef33`, Settled) — § 3, the Swift-frame paragraph as it now
  rests on the Swift packet; § SDD Review Notes RN-66. `<CORE>/doctrine/engineering/languages/swift/`
  — `layout.md` v1.0.0, `testing.md` v1.1.0, `toolchain.md` v1.1.0 — in the registry since
  `kensaiapp-dev@3ab2e8553`, merged at 18:46 on 2026-09-23, after this record was accepted at
  15:13 (`nozoki@1dfdd86`); the listing in the bullet above was true when taken. Read for the two
  in-place corrections dated 2026-09-23 above, each authorized in the owner's seat at
  `docs/trail/architecture/cycle-10.md` § 3.4 as a correction to this record and not a reversal of
  it — reasoning `docs/trail/architecture/self_answer-13.md` § 3.4; the item as raised and answered
  on the SDD is `docs/trail/sdd/cycle-12.md` § 5.2. Where `nozoki-mac` stands against the packet —
  followed, adopted, departed from — is `docs/nfdr.md` § 9's, not this record's. What those
  corrections do not touch: § Decision's four units and their map, the frame's location inside
  `nozoki-mac/`, "declares no package dependency"; § Alternatives ruled out; § Binds.
- Inputs read for this record: SDD Draft v13 · SRS Settled v12 · FDR Settled v8.

## Binds

QC-8 – QC-17, QC-20.
