# Self-answer report — `docs/adr/` and `docs/nfdr.md`

## Header

- **Companion:** `docs/architecture_open_issues.md`
- **Document:** `docs/adr/` and `docs/nfdr.md` (NFDR v19, Settled; the companion says the PM opened
  it outside `product-architecture`, so the records still owe the fold —
  `docs/architecture_open_issues.md:L19-L24`).
- **Decided by:** `decide_companion_answers.md` v1.3.0
- **Date:** 2026-09-26
- **Sources re-read:**
  - Swift Evolution SE-0458
    (https://github.com/swiftlang/swift-evolution/blob/main/proposals/0458-strict-memory-safety.md):
    implemented in Swift 6.2; strict memory safety identifies unsafe constructs, SwiftPM exposes
    `.strictMemorySafety()` per module, and pointer-bearing C APIs are unsafe while value-only C
    calls are safe (§ *C(++) interoperability* and § *SwiftPM integration*).
  - Swift Evolution SE-0466
    (https://github.com/swiftlang/swift-evolution/blob/main/proposals/0466-control-default-actor-isolation.md):
    implemented in Swift 6.2; `SwiftSetting.defaultIsolation` is first available in
    `PackageDescription` 6.2, is applied per target, and changes unannotated declarations in that
    module rather than imported modules (§ *Specifying default isolation per module*).

One unfilled item was worked and overridden; §§ 3.1 and 3.2 were skipped because their answer slots
were already filled (`docs/architecture_open_issues.md:L67-L182`). Nothing is left for the owner: the
item binds only the records' internal account of a packet departure, the seat ADR-0016 assigns to
NFDR § 9 (`docs/adr/0016-physical-unit-set-core-bridge-mac-checks.md:L75-L81`,
`docs/adr/0016-physical-unit-set-core-bridge-mac-checks.md:L125-L128`).

## Items worked

### 2.1 — § 9's tools-version departure has two more consequences the bullet does not name — `.strictMemorySafety()` and `.defaultIsolation(MainActor.self)` are `PackageDescription` 6.2 settings the manifest cannot state, and the bullet says each is followed as written

- **Bucket:** 2. Choices to confirm — the Principal Architect drafted a best-effort answer; confirm
  or override
- **Verdict:** overridden
- **Why:** The conclusion stands and the draft's placement and cost do not: both settings join NFDR
  § 9's *Departed from* list under the tools-version flip, but strict memory safety applies to every
  Swift target, default main-actor isolation applies only to `Surfaces` and `KAReader`, strict memory
  safety reaches AppKit as well as the C bridge, and default isolation does not reach
  `ReadRunning.swift`. The answer slot records that replacement
  (`docs/architecture_open_issues.md:L40-L79`).

  **What survives the draft.** The package still declares tools 5.9 and no target has
  `swiftSettings` (`ka-reader-mac/Package.swift:L1-L36`), while the packet requires tools 6.2 because
  `.strictMemorySafety()` and `.defaultIsolation(_:)` first become manifest APIs there
  (`<CORE>/doctrine/engineering/languages/swift/toolchain.md:L41-L53`). NFDR § 9 already makes the
  tools version a recorded departure with a later 6.2 flip (`docs/nfdr.md:L1057-L1067`), so these
  settings are consequences of that one decision rather than new architectural decisions; ADR-0016
  explicitly places Swift-packet departures in NFDR § 9
  (`docs/adr/0016-physical-unit-set-core-bridge-mac-checks.md:L75-L81`).

  **The placement correction.** The packet puts `.strictMemorySafety()` on every Swift target
  (`<CORE>/doctrine/engineering/languages/swift/quality_gates.md:L169-L184`) and puts
  `.defaultIsolation(MainActor.self)` on the app executable and UI target, while excluding a logic
  library or anything called from a background task
  (`<CORE>/doctrine/engineering/languages/swift/conventions.md:L169-L188`). In this manifest those
  target roles are `KAReader` and `Surfaces`; `Shell` owns the explicit off-main runner, and the two
  test targets are neither the app executable nor the UI target (`ka-reader-mac/Package.swift:L16-L35`,
  `ka-reader-mac/Sources/Shell/ReadRunning.swift:L4-L30`). The draft therefore cannot attribute
  `ReadRunning.swift`'s off-main work to default isolation; § 3.2 already and correctly records its
  Swift 6 language-mode failures (`docs/architecture_open_issues.md:L162-L182`).

  **The cost correction, measured on the current tree.** A copy of `ka-reader-mac` at `ka-reader@f3e3467`
  was given tools 6.2, `swiftLanguageModes: [.v5]` to hold § 3.2's separate change still,
  `.treatAllWarnings(as: .error)` and `.strictMemorySafety()` on every Swift target, and
  `.defaultIsolation(MainActor.self)` on `Surfaces` and `KAReader`. `swift test --package-path
  /private/tmp/ka-reader-companion-probe.z7GqBe/ka-reader-mac` exited 1 first at
  `RootItemsView.swift:57,128,129,154,327,336,337`, each an AppKit `unowned(unsafe)` property; after
  those expressions were acknowledged in the copy, `swift build --package-path
  /private/tmp/ka-reader-companion-probe.z7GqBe/ka-reader-mac --target KA-Reader` exited 1 at
  `NativeBridge.swift:13,17,21,25,29,32`, each involving unsafe pointer types. Those two command
  outputs make the draft's pointer cost true but incomplete; the product sources at those sites are
  `ka-reader-mac/Sources/Surfaces/RootItemsView.swift:L55-L59`,
  `ka-reader-mac/Sources/Surfaces/RootItemsView.swift:L112-L159`,
  `ka-reader-mac/Sources/Surfaces/RootItemsView.swift:L319-L345`, and
  `ka-reader-mac/Sources/KAReader/NativeBridge.swift:L10-L34`.

  With `.strictMemorySafety()` removed from that copy and the language mode still held at Swift 5,
  the same `swift build … --target KA-Reader` exited 0 with `Build complete! (1,51 sec)` while default
  isolation remained on `Surfaces` and `KAReader`. That result does not promise that a future tree has
  no isolation migration; it establishes only the answer this record needs now: the current
  off-main errors are not a consequence of applying default isolation at the packet's target
  boundaries.

  **Contradiction check.** The replacement preserves § 3.2's earlier answer by assigning its two
  `Shell` concurrency diagnostics to the Swift 6 language-mode flip, and it preserves the packet's
  separation between UI modules and modules callable from any isolation domain
  (`docs/architecture_open_issues.md:L162-L182`,
  `<CORE>/doctrine/engineering/languages/swift/conventions.md:L169-L182`). It creates no ADR because
  no target-specific relaxation is chosen; all Swift targets adopt strict memory safety, and the two
  targets the packet names adopt default isolation at the recorded flip
  (`<CORE>/doctrine/engineering/languages/swift/quality_gates.md:L169-L184`,
  `docs/adr/0016-physical-unit-set-core-bridge-mac-checks.md:L125-L128`).

  **Failure paths.** *Absent:* while CI lacks a measured 6.2-or-later toolchain, the departure and its
  flip remain as NFDR § 9 already states (`docs/nfdr.md:L1049-L1067`). *Error:* once the flip lands,
  the strict-memory diagnostics become build failures because the same packet requires warnings as
  errors (`<CORE>/doctrine/engineering/languages/swift/quality_gates.md:L155-L184`). *Concurrent:*
  `Shell` remains nonisolated by default and its off-main seam is handled by the Swift 6 migration,
  not silently pulled onto the main actor (`ka-reader-mac/Sources/Shell/ReadRunning.swift:L4-L30`,
  `docs/architecture_open_issues.md:L162-L182`). *A later target:* every added Swift target must carry
  strict memory safety, while default isolation follows the target's role; the packet says manifest
  review, not an automated gate, enforces both placements
  (`<CORE>/doctrine/engineering/languages/swift/conventions.md:L177-L188`). *Refused:* relaxing strict
  memory safety for one target would require that target's reason in `docs/adr/`, which this answer
  does not authorize (`<CORE>/doctrine/engineering/languages/swift/quality_gates.md:L169-L184`).

  **What would have tipped it.** A packet rule applying default isolation to `Shell`, or a compile
  probe showing `ReadRunning.swift` failing while the language mode stayed at Swift 5, would have
  preserved the draft's cost attribution; the packet excludes background-called targets and the
  isolated target build completed instead
  (`<CORE>/doctrine/engineering/languages/swift/conventions.md:L169-L182`; `swift build
  --package-path /private/tmp/ka-reader-companion-probe.z7GqBe/ka-reader-mac --target KA-Reader` → exit 0,
  `Build complete! (1,51 sec)`).

## Left for the owner

None this run.

## Skipped

- **3.1 — § 9 says the Swift test framework is followed, but new tests are XCTest and no departure
  is recorded** — its Answer slot is already filled (`docs/architecture_open_issues.md:L110-L131`).
- **3.2 — § 9 does not state the Swift language mode, so it claims the Swift 6 mode is followed, and
  the package builds in the Swift 5 mode** — its Answer slot is already filled
  (`docs/architecture_open_issues.md:L162-L182`).

## Companions opened

None this run.

## Launchers owed

- **`docs/adr/` and `docs/nfdr.md`** — `<CORE>/launchers/skill/launcher.sh product-architecture ka-reader`
