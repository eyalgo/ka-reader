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
- **Answer:** confirmed with addition — § 9 reads the seven as adopted in the tree at `ka-reader@f0f1e5f`, dated, with the item's artifact-bundle route and module-map source, and the departure's words go to a dated note. Additions: (1) date the adoption to the tree, not to CI — `main` is 8 commits ahead of `origin/main` (`3f7a68d`) and no hosted run has built `f0f1e5f`; the hosted `macos-26` Swift is 6.3.3 (3.2's answer), so the 6.2 manifest is expected to load, and the first hosted build of it is the confirming reading; (2) the `type == "system"` clause holds in the manifest but nothing checks it — `checks/no-network.sh` refuses only a non-empty `dependencies` array and a target with a `url` (`:L31-L32`, `:L131-L138`), so a system target added back would pass every gate; § 9 names that refusal as owed to `no-network.sh` and its suite, and the `development-design` review on `Package.swift` holds it until it lands; (3) the departure-only text — the measured source cost, "No target carries `StrictConcurrency` meanwhile", "with Swift 5 mode held", and "Which Swift it carries is unread … 6.0.3 … below 6.2" — goes to the dated note with the rest; (4) the *verified by* gate "flip together or not at all" is spent and is re-aimed to "the seven stay adopted", read off `swift package --package-path ka-reader-mac dump-package`, which exits 0 on a fresh clone without the bridge artifact (measured 2026-10-14: tools `6.2.0`, language mode `6`, the settings on the targets the item names, `CKAReaderBridge` of type `binary`, no `system` target, no `url`); (5) `:L3212-L3226` is RN-25, a review note recording an earlier fold — it stays as written, and this fold's new note records the supersession; (6) no record is owed — the adoption is the departure's own trigger firing (`docs/SDD.md` RN-108), not a new decision. Reasoning: `docs/trail/architecture/self_answer-47.md` § 3.1.

### 3.2 § 9's *Toolchain* clause gives CI's old step order, and the package now needs its bridge assembled before `swift test` runs
- **Raised by:** PM — 2026-10-14
- **Which record:** `nfdr.md` § 9, the `ka-reader-mac` bullet, *Toolchain — measured on every build* (`docs/nfdr.md:L1699-L1705` at `ka-reader@f0f1e5f`).
- **Tracked by:** `ka-reader · nemawashi · 2026-10-13_ka-reader-builds-and-proves-on-its-26-floor`
- **What it blocks:** the clause says CI runs `swift test --package-path ka-reader-mac` in `Test gate` and then `ka-reader-mac/assemble.sh` at a later step. At `ka-reader@f0f1e5f`, `.github/workflows/ci.yml:L31-L32` runs `Build KA-Reader.app` (`assemble.sh`) before `Test gate` at `:L34-L35`. The order is now load-bearing, not habit: on a fresh clone at `ka-reader@f0f1e5f`, `swift build --package-path ka-reader-mac` with no assembly first exits 1 with `error: local binary target 'CKAReaderBridge' at '…/ka-reader-mac/CKAReaderBridge.artifactbundle' does not contain a binary artifact.` (measured 2026-10-14). So the test command the records name for the Swift package (`swift test --package-path ka-reader-mac`, beside `cargo test --workspace --locked`) does not pass on a fresh checkout unless `ka-reader-mac/assemble.sh` runs first.
- **Where it shows:** the *Toolchain* clause's step citations, and every place these records give the Swift half of the test command without the assembly it now needs. The hosted `macos-26` toolchain re-measurement the clause names as not yet taken stays owed; nothing here changes it.
- **If a document has to be written:** none — a § 9 re-reading in `nfdr.md`, and wherever the records state the test command.
- **Answer:** confirmed with addition, overriding the item's last sentence — the *Toolchain* clause cites `ci.yml:L31-L32` (`Build KA-Reader.app`, `assemble.sh`) before `:L34-L35` (`Test gate`) at `ka-reader@f0f1e5f`, with the old citations in a dated note. Additions: (1) state the precondition once, where § 9 names the packet's runner (`docs/nfdr.md:L1490`), not in each of the eleven *verified by* tails and § 10 rows that cite `swift test --package-path ka-reader-mac` — they all read under that one sentence; (2) the precondition is *every run*, not only a fresh checkout: `assemble.sh` deletes and rebuilds `CKAReaderBridge.artifactbundle` from the checkout each time (`assemble.sh:L70-L74`), so a bundle left by an earlier run holds that run's bridge, and `swift test` without assembly in an old checkout tests a stale bridge with no error — CI's order (assemble, then test) is the rule; (3) § 8 states the project card's `Test command:`, whose Swift half fails on every fresh checkout, including each new worktree the delivery tier opens; the card is `product-card`'s to derive, so § 8 names that move as owed rather than editing the card, in the form RN-60 used; (4) the item says the hosted `macos-26` re-measurement "stays owed", and that is false — `ka-reader@fcb2e2f` is an ancestor of `origin/main`, and GitHub Actions run 38463966607 on `ka-reader@4601cd9` (2026-10-13, the first `main` run on that image) prints Apple Swift 6.3.3 (swiftlang-6.3.3.1.3), SDK 26.5, image `macos-26-arm64` 20260907.0351.1, and run 38501500758 on `ka-reader@3f7a68d` prints the same. The first run failed at `Test gate`, but its `Toolchain` step passed, so the reading stands; the clause records it as the `macos-26` measurement, and "none exists yet" goes to the dated note. Reasoning: `docs/trail/architecture/self_answer-47.md` § 3.2.

**How it closes.** `product-architecture` folds it on its next run like any other item here.
