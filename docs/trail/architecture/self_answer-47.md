# Self-answer report — `docs/adr/` and `docs/nfdr.md`

## Header

- **Companion:** `docs/architecture_open_issues.md`
- **Document:** `docs/adr/` and `docs/nfdr.md` (one companion for both, by its header's pointer)
- **Decided by:** `<CORE>/../skills/companion/.claude/skills/companion-self-answer/prompts/rich.md` v1.3.1
- **Date:** 2026-10-14
- **Sources re-read:** GitHub Actions, the `Set up job` and `Toolchain` lines of runs 38463966607
  (`ka-reader@4601cd9`, 2026-10-13, `failure` at `Test gate`) and 38501500758 (`ka-reader@3f7a68d`,
  2026-10-14, `success`), read 2026-10-14 with `gh run view --log`. Both print "Apple Swift version
  6.3.3 (swiftlang-6.3.3.1.3 clang-2100.1.1.101)", SDK `26.5`, and image `macos-26-arm64`, version
  20260907.0351.1. 3.1 and 3.2 both rely on this reading. Nothing else outside this repository was
  relied on.

**What this run read.** The companion, whole. In `docs/nfdr.md` (v48, 5,237 lines): the header, the
section map, § 8's test-command paragraph (`:L1377-L1392`), § 9's runner paragraph
(`:L1481-L1496`), and § 9's `ka-reader-mac` bullet whole (`:L1666-L1812`). RN-25's lines the item
cites (`:L3200-L3232`). The NFDR's lines below `:L1890` (its review notes) were searched for
`systemLibrary`, `5.9`, `CKAReaderBridge` and `swift test --package-path`. `docs/adr/*.md` was
searched for the same terms and has none of them. In `docs/SDD.md`: the section map, § 4 C-I3's
CI-order sentence (`:L841-L856`) and RN `:L6574-L6582`. In the instance: the project card
(`system/projects/ka-reader/project.md:L1-L12`), the PM's report on the station
`ka-reader · shukuba · 2026-10-14_the-bundle-declares-the-26-floor` (its *Moves* and *Considered*
tables), and `<CORE>/doctrine/setup/kensaiapp_structure.md:L538-L560` (`product-card`'s fields). In
the tree at `ka-reader@f0f1e5f`: `ka-reader-mac/Package.swift` whole; `.github/workflows/ci.yml`
whole; `.gitignore:L32`; `ka-reader-mac/assemble.sh:L1-L80`; `checks/no-network.sh`, searched for
`system`, `binary`, `url` and `type`; and `git grep artifactbundle`, which finds `assemble.sh` as the
only writer of the bridge artifact.

**Measured this run, in a disposable clone of `ka-reader@f0f1e5f`** (local Swift 6.4, macOS 26):

- `swift package --package-path ka-reader-mac dump-package` exited 0 without the bridge artifact.
  It printed tools `6.2.0`, language mode `6`, and platform `macos 26.0`.
  - `Surfaces` and `KAReader` carry `treatAllWarnings(error)`, `strictMemorySafety` and
    `defaultIsolation(MainActor)`.
  - `Shell`, `SurfacesTests` and `ShellTests` carry the first two settings only.
  - `CKAReaderBridge` is type `binary` at `CKAReaderBridge.artifactbundle`.
  - No target is type `system`, and none carries a `url`.
- `swift build --package-path ka-reader-mac` exited 1 with "error: local binary target
  'CKAReaderBridge' at '…/ka-reader-mac/CKAReaderBridge.artifactbundle' does not contain a binary
  artifact."

**Git state.** `git merge-base --is-ancestor` shows `fcb2e2f` is in `origin/main` and `f0f1e5f` is
not. `main` is 8 commits ahead of `origin/main` (`3f7a68d`).

## Items worked

### 3.1 — § 9 still describes the seven tools-6.2 departures as open, and they were adopted at `ka-reader@f0f1e5f`

- **Bucket:** 3. Raised from downstream — an item from a seat that did not write these records
- **Verdict:** confirmed with addition
- **Why:** The item's reading holds, every fact in it measured again. The bullet owes more than
  the item lists, though. One of the clauses it would have § 9 call "followed as written" has no
  check behind it.

  *Check 1, the seat.* The change lands in `docs/nfdr.md` § 9, this seat's own document. It commits
  nothing to any person, and I can name no ground I cannot see. So it is the Principal Architect's,
  answered here in the owner's seat. It corrects statements that became false, so it is not a
  widening, and § *A widening item waits until it occurs* does not apply.

  *Check 2, the item's proposal.* The item asks for the clause to read as adopted and dated, with
  the artifact-bundle route and the module-map source. Every citation in it holds at
  `ka-reader@f0f1e5f`:
  - `Package.swift:L1` reads `// swift-tools-version:6.2`.
  - `:L23` reads `platforms: [.macOS(.v26)]`.
  - `:L30` reads `.binaryTarget(name: "CKAReaderBridge", path: "CKAReaderBridge.artifactbundle")`.
  - `.gitignore:L32` ignores the bundle.
  - `assemble.sh:L56-L74` builds it from `Sources/CKAReaderBridge/module.modulemap`.
  - My own `dump-package` (Header) agrees with the item's on every setting and every target.

  The bullet's one trigger, "the change that writes the `6.2` tools version" (`nfdr.md:L1754`),
  has fired, and all seven flipped together, as the bullet's review gate requires.

  The proposal is incomplete in four places, which are the additions:
  1. **The adoption is the tree's, not yet CI's.** `f0f1e5f` is not in `origin/main`, so no hosted
     run has built the 6.2 manifest. The bullet's own self-check still applies: a toolchain below
     6.2 refuses the manifest and the job goes red. That risk is now measured away: the hosted
     `macos-26` Swift is 6.3.3 (Sources). § 9 should therefore say "adopted in the tree at
     `f0f1e5f`", name the first hosted build of it as the confirming reading, and not claim a CI
     result that does not exist.
  2. **The `type == "system"` clause holds with nothing to enforce it.** Through v48, `no-network.sh`
     stood in the packet gate's place on two of its three conditions. The third, a system target,
     was the departure itself. With the departure ended, "the packet's gate is followed as written"
     is true of the manifest today. But `checks/no-network.sh` refuses only a non-empty
     `dependencies` array and a target carrying a `url` (`:L31-L32`, `:L131-L138`). A change that
     put a `.systemLibrary` back would pass every gate in the tree. That fails this seat's
     enforceability test. So § 9 names the refusal as owed to `checks/no-network.sh` and its suite,
     and until it lands, the `development-design` review on any change to `Package.swift` holds it.
     Whether to write that check is the delivery tier's call. The NFDR's part is to say it is owed
     and what holds in the meantime.
  3. **The departure's own text is history now.** Four pieces go to the dated note with the rest:
     - the measured source cost of adopting (`:L1769-L1782`);
     - "No target carries `StrictConcurrency` meanwhile";
     - "with Swift 5 mode held";
     - "Which Swift it carries is unread … the last one measured, Swift 6.0.3 on `macos-14`, is below
       6.2" (`:L1742-L1745`). This sentence is now false twice over (Sources).
  4. **The *verified by* review gate is spent.** "The seven … flip together or not at all" described
     a flip, and the flip has happened. The gate becomes "the seven stay adopted". It is read off
     `swift package --package-path ka-reader-mac dump-package`, which runs without the bridge
     artifact (measured above). That makes it cheaper than a build.

  *Check 3, against what is settled.*
  - `docs/SDD.md` RN-108 ties the tools version to the floor, and the floor change carried it.
    Nothing settled moves.
  - The item also cites `:L3212-L3226`. That is RN-25, a review note recording the cycle-11 fold,
    and review notes are history. It stays as written, and the fold's new note records that § 9's
    departure ended. The item's "the same reading" therefore asks for no edit there.
  - No decision record is owed. The adoption is the departure's own stated trigger firing, not a new
    decision. The artifact-bundle link is the route the packet lists first, and undoing it would be
    a one-file change, so it fails the significance test. `docs/adr/` mentions none of this.
  - The SDD's mention of CI's order (`SDD.md:L851`, `ci.yml:L41` and `:L51`) is a measurement pinned
    to `ka-reader@cc3a63f` (`:L849`) and was true there. So no SDD companion is owed.
  - This answer agrees with 3.2. Both rewrite the same bullet: this one the departure paragraphs, 3.2
    the *Toolchain* clause and the runner's precondition. They were decided together.

  *Check 4, the failure paths.*
  - **Absent:** the bridge artifact is missing on a fresh checkout. The re-aimed review reading still
    works there, because `dump-package` does not need the artifact. The build does (3.2).
  - **Stale:** the adoption is dated to a commit no hosted run has built. The first hosted build is
    named as the confirming reading, so a red there reads as a contradiction of this clause and not
    as noise.
  - **Refused:** a hosted Swift below 6.2 would refuse the manifest. The reading is 6.3.3, so this is
    not expected. If a later image moved below 6.2, the job would go red by itself.
  - **Concurrent:** does not apply.

  *Where I was close to another verdict.* I nearly raised the missing system-target refusal as an
  item of its own. I did not, because it is the enforcement half of the clause this item asks to
  have re-read. Splitting it off would cost a second round on one sentence.

### 3.2 — § 9's *Toolchain* clause gives CI's old step order, and the package now needs its bridge assembled before `swift test` runs

- **Bucket:** 3. Raised from downstream — an item from a seat that did not write these records
- **Verdict:** confirmed with addition
- **Why:** The item's correction holds, and I measured its failure myself. I add three things and
  override one clause: the item's last sentence, that the hosted `macos-26` re-measurement "stays
  owed", is false.

  *Check 1, the seat.* The change lands in `docs/nfdr.md`, in § 9's *Toolchain* clause, § 9's
  runner paragraph and § 8. That is this seat's document, with nothing owed to a person. One
  consequence reaches another document: the project card's `Test command:`. That field is
  `product-card`'s, the Principal PM's skill, derived from the settled set
  (`kensaiapp_structure.md:L549-L560`). No companion template names the project card (all twelve
  templates' pointers were read), so no companion can be opened on it. The route that exists is the
  one the NFDR already uses: § 8 states the card's command and names a move as owed when the card
  falls behind, as it did with RN-60. So this stays one item, answered here, and the card's half is
  carried by § 8 naming it. It is not raised upstream.

  *Check 2, the item.* The citations hold at `ka-reader@f0f1e5f`:
  - `ci.yml:L31-L32` runs `Build KA-Reader.app` (`assemble.sh`), and `:L34-L35` runs `Test gate`
    after it.
  - `:L29-L30` states the reason in a comment.
  - The *Toolchain* clause's `:L26` and `:L35` citations are false at this commit, and so is its
    order.

  The fresh-clone failure is my measurement too (Header). `swift test` resolves the same binary
  target before it builds (`assemble.sh:L10-L12` says so), so the test command fails the same way.

  The item's "every place these records give the Swift half of the test command" is broader than
  the fix it needs. **The addition narrows it:**
  1. The precondition is stated once, where § 9 names the packet's runner (`:L1490`). It is not
     repeated in each of the eleven *verified by* tails and § 10 rows that cite
     `swift test --package-path ka-reader-mac` (lines 230, 383, 1183, 1273, 1318, 1798, 1840, 1844,
     1867, 1875 and 1877). Each of them reads under that one sentence. Eleven copies would be eleven
     places to go stale.
  2. The precondition is **every run, not only a fresh checkout.** `assemble.sh` deletes and rebuilds
     `CKAReaderBridge.artifactbundle` from the checkout each time (`:L70-L74`). A bundle left by an
     earlier run holds that run's bridge, so `swift test` without assembly in an old checkout tests a
     stale bridge and says nothing. The rule is CI's order, assemble then test, on every run.
  3. **§ 8's card command is false in practice.** The card reads `cargo test --workspace --locked &&
     swift test --package-path ka-reader-mac` (`project.md:L8`). Its Swift half fails on every fresh
     checkout, and each worktree the delivery tier opens is one. The PM's station report already
     found this and routed it through this item. § 8 names the move as owed to `product-card`, and
     the form of the command is that skill's to choose.

  **The override.** The item says the hosted `macos-26` re-measurement "stays owed", and the
  *Toolchain* clause says none exists because `fcb2e2f` "is on no remote branch". Both are false
  today:
  - `fcb2e2f` is in `origin/main`.
  - Run 38463966607 on `4601cd9`, the first `main` run on `macos-26`, prints Swift 6.3.3, SDK 26.5,
    image 20260907.0351.1. Run 38501500758 on `3f7a68d` prints the same.
  - The first run failed at `Test gate` (the drag test that `3f7a68d` fixed), but its `Toolchain`
    step passed, so the reading stands.

  The clause records it as the `macos-26` measurement, with the run id and image version beside it
  as the clause's own rule requires. "None exists yet" goes to the dated note.

  *Check 3, against what is settled.*
  - The SDD's bars (§ 6 S-1) name `swift test` exiting 0. That is still true once the artifact
    exists, so no SDD change is owed.
  - This answer agrees with 3.1. The 6.3.3 reading is what 3.1's first addition rests on, and the
    two were decided together.
  - The *Framework* clause's flip (v48) is unaffected. 6.3.3 is a Swift 6 toolchain.

  *Check 4, the failure paths.*
  - **Empty:** the first run in a new worktree has no artifact. That is the case the precondition
    exists for.
  - **Stale:** a leftover bundle from an earlier run is covered by addition 2.
  - **Refused:** if `assemble.sh` fails (a missing glyph directory, an unrecognised host triple, a
    `codesign` failure), the Swift half never runs and the gate is red. That is the correct outcome,
    because the script fails loudly with what is missing (`:L44-L47`, `:L58-L67`).
  - **Concurrent:** two worktrees each keep their own bundle and their own `target/`, because both
    paths come from the script's own location (`:L38-L40`), so they cannot cross.
  - **Not covered:** `assemble.sh` builds and signs the whole app, which is more than the test needs.
    Whether a lighter bridge-only step is worth writing is the delivery tier's call, and nothing
    here requires one.

  *Where I was close to another verdict.* I nearly opened a separate item for the 6.3.3 reading. It
  sits inside the clause this item asks to have re-read, and the item's own last sentence states the
  opposite. Folding it here costs nothing. A separate item would leave this answer contradicting a
  fact for a round.

## Left for the owner

None this run.

## Skipped

None this run.

## Companions opened

None this run.

## Launchers owed

- **`docs/adr/` and `docs/nfdr.md`** — `<CORE>/launchers/skill/launcher.sh product-architecture ka-reader`
