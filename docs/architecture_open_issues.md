# Architecture open issues — KA-Reader

> Companion to `adr/` and `nfdr.md`. The Principal Architect authored both records
> non-interactively; this file holds what the run could not settle from its inputs — the SRS, the SDD
> and the FDR.
> **Answer inline** — fill each **Answer** / **Confirm-or-override** slot — **commit this file**, then
> re-run `product-architecture`. It folds your answers into the records and drops the resolved items.
> When nothing is left open, `product-architecture` **deletes this file**: no file = the records are
> done.
>
> Your answers are never thrown away. Each time the Principal Architect folds them in, it first copies
> this file whole to `docs/trail/architecture/` — so what you decided, and why, stays readable and
> citable for good.
>
> **§ 3 is raised, not asked.** These records bind every later change, so the seats that live under
> them find gaps the authoring run could not. § 3 is where such a seat says so, against both records
> — an ADR's binding and an NFDR obligation reach the same file.

---

## 1. Open issues — questions with no answer yet

None.

## 2. Choices to confirm — the Principal Architect drafted a best-effort answer; confirm or override

None.

## 3. Raised from downstream — an item from a seat that did not write these records

### 3.1 § 9 still describes the seven tools-6.2 departures as open, and they were adopted at `ka-reader@f0f1e5f`
- **Raised by:** PM — 2026-10-14
- **Which record:** `nfdr.md` § 9, the `ka-reader-mac` bullet against the Swift packet: *Departed from, as one decision, until the change that writes the `6.2` tools version* (`docs/nfdr.md:L1731-L1782` at `ka-reader@f0f1e5f`) and *Departed from, with the same flip — the packet's dependency gate's `type == "system"` clause* (`:L1783-L1797`); the same reading at `:L3212-L3226`.
- **Tracked by:** `ka-reader · nemawashi · 2026-10-13_ka-reader-builds-and-proves-on-its-26-floor`
- **What it blocks:** nothing is blocked; the clauses are false of the tree. They say `Package.swift:L1` reads `5.9` and that the bridge links through `.systemLibrary(name: "CKAReaderBridge")` with `-L` flags. At `ka-reader@f0f1e5f`, `Package.swift:L1` reads `// swift-tools-version:6.2`, `:L23` reads `platforms: [.macOS(.v26)]`, `:L30` links the bridge as `.binaryTarget(name: "CKAReaderBridge", path: "CKAReaderBridge.artifactbundle")`, and `swift package dump-package` shows Swift 6 language mode, `treatAllWarnings` and `strictMemorySafety` on all five Swift targets, `defaultIsolation` MainActor on `Surfaces` and `KAReader` only, no `system` target and no `unsafeFlags`. The flip the clause names as its one trigger has happened, all seven together.
- **Where it shows:** a delivery reader holding § 9 as written would treat the packet's dependency gate's `type == "system"` clause as departed from, and the six settings as not yet owed, when the manifest now follows the packet as written. The clause should read as adopted, dated, with the local artifact-bundle route (`ka-reader-mac/assemble.sh` writes the git-ignored `CKAReaderBridge.artifactbundle`; `.gitignore` carries `/ka-reader-mac/CKAReaderBridge.artifactbundle/`) and the tracked module-map source it is built from (`ka-reader-mac/Sources/CKAReaderBridge/module.modulemap`).
- **If a document has to be written:** none — a § 9 re-reading in `nfdr.md`.
- **Answer:** <the owner fills this in>

### 3.2 § 9's *Toolchain* clause gives CI's old step order, and the package now needs its bridge assembled before `swift test` runs
- **Raised by:** PM — 2026-10-14
- **Which record:** `nfdr.md` § 9, the `ka-reader-mac` bullet, *Toolchain — measured on every build* (`docs/nfdr.md:L1699-L1705` at `ka-reader@f0f1e5f`).
- **Tracked by:** `ka-reader · nemawashi · 2026-10-13_ka-reader-builds-and-proves-on-its-26-floor`
- **What it blocks:** the clause says CI runs `swift test --package-path ka-reader-mac` in `Test gate` and then `ka-reader-mac/assemble.sh` at a later step. At `ka-reader@f0f1e5f`, `.github/workflows/ci.yml:L31-L32` runs `Build KA-Reader.app` (`assemble.sh`) before `Test gate` at `:L34-L35`. The order is now load-bearing, not habit: on a fresh clone at `ka-reader@f0f1e5f`, `swift build --package-path ka-reader-mac` with no assembly first exits 1 with `error: local binary target 'CKAReaderBridge' at '…/ka-reader-mac/CKAReaderBridge.artifactbundle' does not contain a binary artifact.` (measured 2026-10-14). So the test command the records name for the Swift package (`swift test --package-path ka-reader-mac`, beside `cargo test --workspace --locked`) does not pass on a fresh checkout unless `ka-reader-mac/assemble.sh` runs first.
- **Where it shows:** the *Toolchain* clause's step citations, and every place these records give the Swift half of the test command without the assembly it now needs. The hosted `macos-26` toolchain re-measurement the clause names as not yet taken stays owed; nothing here changes it.
- **If a document has to be written:** none — a § 9 re-reading in `nfdr.md`, and wherever the records state the test command.
- **Answer:** <the owner fills this in>

**How it closes.** `product-architecture` folds it on its next run like any other item here.
