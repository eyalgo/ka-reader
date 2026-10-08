# Self-answer report — `docs/adr/` and `docs/nfdr.md`

## Header

- **Companion:** `docs/architecture_open_issues.md`
- **Document:** `docs/adr/` and `docs/nfdr.md` (NFDR v19, Settled — its header reads Settled because
  no `product-architecture` run has opened the companion; the PM opened it at `ka-reader@53bded6`, so
  the records are owed a fold. The inputs the items name are SDD v20 Settled, FDR v10 Settled, the
  Swift packet at `toolchain.md` v1.1.0 / `testing.md` v1.1.0 / `conventions.md` /
  `quality_gates.md` v1.1.0 — outside this repository, read at `<CORE>/doctrine/engineering/languages/swift/`.)
- **Decided by:** `decide_companion_answers.md` v1.3.0
- **Date:** 2026-09-26
- **Sources re-read:**
  - The Swift Testing README (https://github.com/swiftlang/swift-testing/blob/main/README.md):
    "Swift Testing is included with the Swift 6 toolchain and Xcode 16." — § 3.1 rests on it.
  - The `macos-14-arm64` runner image readme
    (https://github.com/actions/runner-images/blob/main/images/macos/macos-14-arm64-Readme.md): image
    20260831.0302.1, macOS 14.8.9; Xcode 16.2, 16.1, 15.4 (default), 15.3, 15.2, 15.1, 15.0.1; no Swift
    version listed — § 3.1 rests on it; it says what `docs/nfdr.md:L1049-L1057` said on 2026-09-23.
  - SwiftPM `BuildSettings.swift`
    (https://github.com/swiftlang/swift-package-manager/blob/main/Sources/Runtimes/PackageDescription/BuildSettings.swift):
    `enableUpcomingFeature` "First available in PackageDescription 5.8"; `swiftLanguageMode` 6.0;
    `treatAllWarnings` 6.2 — § 3.2 rests on it.
  - The Swift migration guide, *Enable data-race safety*
    (https://github.com/swiftlang/swift-migration-guide/blob/main/Guide.docc/EnableDataRaceSafety.md):
    tools version 6.0 "enables the Swift 6 language mode for all targets"; the `StrictConcurrency`
    setting is `enableExperimentalFeature` for Swift 5.9/5.10 tools and `enableUpcomingFeature` for
    6.0 and later — § 3.2 rests on it.
  - GitHub Actions run 36034875098 on `ka-reader@c79270f`, the newest run on `main` (`gh run list
    --repo kensaiapp/ka-reader --workflow ci.yml`, 2026-09-26): `success`, image `macos-14-arm64`; its
    809-line log names no Swift version — the only `swift-version` lines are the build file's name,
    as run 35968105480's were. So the toolchain clause's "waits for a log on `main` that names the
    toolchain" is still true, and no answer here rests on knowing CI's toolchain.

Two items, both in § 3 *Raised from downstream*, both this document's seat, both answered. One item
raised on this document, § 2.1. Nothing left for the owner: neither item commits a person, a party
or a risk, and the one ground the run could not see — which toolchain CI builds with — is one the
records themselves hold as unmeasured, so each answer is built to hold either way. Local
measurements were taken on the tree at `ka-reader@6e1d79f` (HEAD; `ka-reader-mac/` unchanged since
`ka-reader@f46269a`, the merge the items measured — `git diff --stat f46269a HEAD -- ka-reader-mac` prints
nothing), and the one build measurement was made in a copy under `/tmp`, removed afterwards; the
tree was not touched.

## Items worked

### 3.1 — § 9 says the Swift test framework is followed, but new tests are XCTest and no departure is recorded

- **Bucket:** 3. Raised from downstream — an item from a seat that did not write these records
- **Verdict:** answered
- **Why:** Answered with the item's first reading — the framework joins *Departed from* — made exact
  in three ways the item left open: the flip is the framework's own and not the four's; the count is
  corrected; and the *verified by* tail gains the trigger whose absence let this happen.

  **Every claim in the item re-measures true.** `ka-reader-mac/Tests/SurfacesTests/RootItemsViewExpansionTests.swift:L2`
  reads `import XCTest`, added at `ka-reader@a5fc189` (`git log --oneline -- <file>`: `a5fc189`,
  `cc0e030`). `grep -rl 'import Testing' ka-reader-mac/Tests` prints nothing. `grep -rl 'import
  XCTest' ka-reader-mac/Tests` lists five files where `docs/nfdr.md:L1035-L1036` counts four. The
  ground the change gave is at the code-integrity report, not the commits the item names — the
  closing marker as that report quotes it: "this image's default Xcode is 15.4, and that Swift
  Testing ships with Xcode 16"
  (`system/projects/ka-reader/journey/tobiishi/trail/2026-09-25_the-tree-opens/code-integrity-report.md:L110-L118`,
  in the instance repository) — and the flow findings for that change already say what the item
  says: the ground "rests on a document the product's own NFDR says is not a measurement"
  (`…/flow_findings/development-implementation.md:L15`). The item's supporting text is right in
  substance and off by one word ("commits"); no correction is owed.

  **Why the framework's flip is its own.** The four departures the bullet holds flip "until CI
  builds `ka-reader-mac` on an image carrying a Swift 6.2 or later toolchain" (`:L1057-L1059`), and the
  image tops out at Xcode 16.2 (the readme, re-read). Swift Testing needs "the Swift 6 toolchain and
  Xcode 16" (the README, re-read) — which the image *has*, at 16.1 and 16.2, behind a 15.4 default.
  So the framework departure can end on a `ci.yml` step selecting an installed Xcode, a change the
  delivery tier can make on today's image, while the three cannot end until the image moves. Folding
  the framework into the four would hold new tests to XCTest for as long as the runner lacks 6.2,
  for no reason the framework has. Two flips, both read the way the toolchain clause reads
  everything: from a log on `main` that names the toolchain (`:L1049-L1056`), never from the label.
  The *verified by*'s "the four departures flip together or not at all" stands as written for the
  four; the answer adds a sentence beside it, it does not move it.

  **Why not the second reading** (keep the rule; name the measurement CI owes). The rule already did
  that: the *Framework* clause gave "the change that writes the first new test" the job of finding
  out (`:L1037-L1039`). Three changes have written new XCTest since — the native shell, the root in
  order, the tree opens — and each recorded the choice in its own change records and none in this
  file, because nothing in the tree prints the toolchain (`grep -n 'swift --version'
  .github/workflows/ci.yml` prints nothing) and the owner's seat left adding that step to the
  delivery tier (`docs/trail/architecture/cycle-13.md` § 2.1, confirmed). A rule whose measurement
  no step produces cannot be violated in a way anyone can name — the enforceability test this seat
  applies to every constraint — and the second reading would leave § 9 stating a rule the tree
  breaks, with no sentence saying when it stops.

  **The addition the item did not ask for, and why it is in the answer rather than raised
  separately:** the bullet's *verified by* triggers on `ka-reader-mac/Package.swift` and
  `.github/workflows/*.yml` (`:L1096-L1102`). A new test file touches neither, so the one gate that
  reads the Framework clause never fired for the three changes that departed from it. The answer
  adds `ka-reader-mac/Tests/` to the trigger. It is part of this item because it is the mechanism by
  which this item's defect occurred, not a second defect.

  **Failure paths.** *Empty:* no new test written — the clause binds nothing and says nothing false.
  *Absent:* no CI log on `main` ever names the toolchain — the departure stands and the tree stays
  true to it; a `ci.yml` change selecting Xcode is reviewed against the bullet (existing trigger),
  and the log after it is what flips the clause. *Stale:* the image's default moves to an Xcode 16
  under the same label — nothing in the record flips on the label, by the clause's own rule, so the
  record stays true until a log says otherwise; that is the cost the toolchain clause already
  accepted. *Concurrent:* XCTest and Swift Testing in one test target after the flip — the packet's
  own README quotes "side-by-side" (`testing.md` § One framework). *Refused:* a change after the flip
  writes XCTest anyway — a violation with a name, caught at the new `ka-reader-mac/Tests/` trigger.

  **What would have tipped it.** A CI log on `main` naming a Swift 6 toolchain. Then the rule is
  followed as written, the one XCTest file added since the packet landed is a fact the fold dates
  and the packet keeps, and the answer would have been the second reading with nothing owed.

### 3.2 — § 9 does not state the Swift language mode, so it claims the Swift 6 mode is followed, and the package builds in the Swift 5 mode

- **Bucket:** 3. Raised from downstream — an item from a seat that did not write these records
- **Verdict:** answered
- **Why:** Answered: the language mode joins *Departed from* as the tools version's consequence with
  the same flip; no target carries `StrictConcurrency` in the meantime; the two sites the Swift 6
  mode will refuse are named as the flip's cost; no ADR is written.

  **Every claim re-measures true, and the two the item left unmeasured are now measured.**
  `ka-reader-mac/Package.swift:L1` reads `// swift-tools-version:5.9`; `grep -n -i
  "swiftLanguage\|StrictConcurrency\|swiftSettings" ka-reader-mac/Package.swift` prints nothing; the
  records grep prints nothing. `LaunchFlow.swift:L52-L53` captures `bridge` in the closure handed to
  `reader.run`, whose parameter is `@escaping @Sendable () -> RootListing?`
  (`ka-reader-mac/Sources/Shell/ReadRunning.swift:L12`), and `Bridging` is a plain `package protocol`
  (`Bridging.swift:L7`). Measured 2026-09-26, in a copy of `ka-reader-mac` (`.build` excluded) at
  `ka-reader@6e1d79f`, Xcode 27.0, Apple Swift 6.4: with
  `.enableUpcomingFeature("StrictConcurrency")` on `Surfaces` and `Shell`, `swift build --target
  Shell` printed `Build complete!` with three warnings and no error — `ReadRunning.swift:28:44`
  twice (capture of `deliver`, non-Sendable `@MainActor (RootListing?) -> Void`, in a `@Sendable`
  closure; "sending 'deliver' risks causing data races; this is an error in the Swift 6 language
  mode") and `LaunchFlow.swift:53:58` (capture of `bridge`, `any Bridging`; "this is an error in the
  Swift 6 language mode"). So under tools 5.9 a Swift 6 compiler accepts the `enableUpcomingFeature`
  spelling (`BuildSettings.swift`: first available in 5.8), the feature does report the item's site
  and one more, and it reports them as warnings a build completes through.

  **Why the mode is a departure and not a per-target step-down.** The packet's step-down rule is for
  "a target that is not ready for the Swift 6 mode" inside a Swift 6 package (`toolchain.md`
  § Language mode). Here no target chose anything: the manifest's `5.9` puts every target in the
  Swift 5 mode (the migration guide, re-read: tools 6.0 is what enables the Swift 6 mode for all
  targets), and `5.9` is a departure these records already hold as one decision with a stated flip
  (`docs/nfdr.md:L1057-L1067`, RN-24, RN-25; the owner's seat at `docs/trail/architecture/cycle-11.md`
  § 3.6, "flips together with the three"). The mode is that decision's consequence and takes its
  flip. ADR-0016 § Consequences places "a Swift package whose departures from the Swift packet … are
  this product's own to record" in `docs/nfdr.md` § 9 (`adr/0016-…md:L78-L79`), so the home is § 9
  and no ADR is written — the item's "where an ADR records the step down" has no such ADR, and
  writing one for a consequence of a recorded departure would be a record with no decision in it.

  **Why not `StrictConcurrency` in the meantime — the call the item left to the records.** Three
  grounds, each measured or read at source. (1) *It cannot go red.* The packet's own ground for the
  feature is that under `.treatAllWarnings(as: .error)` "the feature restores the checks at full
  strength" (`toolchain.md` § Language mode); that setting is departed from with the same flip
  (`:L1062`), and without it the build above completed. A gate that cannot go red has not run —
  ADR-0012's rule, which § 9 already applies to suites (`:L1002`). (2) *The record cannot spell
  it.* The migration guide gives `enableExperimentalFeature` for 5.9/5.10 tools and
  `enableUpcomingFeature` for 6.0 and later; which compiler CI uses is, by this bullet's own clause,
  not yet measured (`:L1049-L1056`), so a constraint requiring the setting could not say which
  spelling satisfies it. (3) *The packet's reason does not reach this case.* "The step-down buys
  source compatibility, not silence" is written for a target that opts down inside a Swift 6
  package; this package is pre-6 by a toolchain the runner does not offer, and the checks return
  whole with the flip. What the answer gives instead is what this seat owes on any departure: its
  cost, measured — the two sites the Swift 6 mode refuses — so the change that adopts the three
  knows the migration it carries. That is a bar a change can be caught missing.

  **Failure paths.** *Empty:* no off-main code — nothing to report, nothing false. *Absent:* CI's
  toolchain never measured — the departure stands and the spelling question never arises. *Stale:*
  the image gains a 6.2 toolchain — the flip fires with the three and the two sites go red, which
  the answer names as expected. *Concurrent:* the two sites are the concurrent case, and they are
  the answer's content. *Refused:* after the flip a change steps one target down to `.v5` — the
  packet's per-target rule applies then, unchanged: an ADR with the reason, and the feature carried.

  **What would have tipped it.** A CI log on `main` naming a Swift 6 toolchain. Then the spelling is
  fixed (`enableUpcomingFeature`, measured accepted under 5.9), and carrying the feature would cost
  nothing and show the two sites on every build — still as warnings, so the answer's ground (1)
  would still stand, and the call would have been closer than it is.

## Left for the owner

None this run.

## Skipped

None this run.

## Raised on this document

### 2.1 — § 9's tools-version departure has two more consequences the bullet does not name — `.strictMemorySafety()` and `.defaultIsolation(MainActor.self)` are `PackageDescription` 6.2 settings the manifest cannot state, and the bullet says each is followed as written

- **What the document is owed:** two more entries on the `ka-reader-mac` bullet's *Departed from*
  list, under the three's flip, with the cost of each named.
- **Why it is worth a cycle:** *A fact in it is now false* — the bullet's "a rule of it not named
  here is followed as written" (`docs/nfdr.md:L1033-L1034`) is false for two rules by the same
  measurement § 3.2 makes for the language mode: `toolchain.md` § Toolchain version names three
  settings "First available in PackageDescription 6.2" (`:L48-L53`) — `.treatAllWarnings(as:)`,
  `.strictMemorySafety()`, `.defaultIsolation(_:)` — and the list names the first alone
  (`:L1060-L1064`); `conventions.md` requires the second on every target unconditionally and the
  third on the app's and the UI's targets; `ka-reader-mac/Package.swift` carries no `swiftSettings` on
  any target (`grep -n swiftSettings ka-reader-mac/Package.swift` prints nothing, 2026-09-26). It is
  raised as one item because both share § 3.2's cause and flip, and the fold that takes § 3.2 is the
  fold that should take them. No separate cycle is spent: the companion is already open.

## Companions opened

None this run.

## Launchers owed

- **`docs/adr/` and `docs/nfdr.md`** — `<CORE>/launchers/skill/launcher.sh product-architecture ka-reader`
