# Architecture open issues — Nozoki

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

> **No `product-architecture` run opened this companion. The PM opened it on 2026-09-26.**
> `nfdr.md` is Settled at v19, and the records had no companion on disk, so a `product-architecture`
> re-run would read them as done and find nothing to act on. The companion holds two items, §§ 3.1 and
> 3.2. Both come from measuring `nozoki-mac` on `main` at `nozoki@f46269a` against § 9's statement of
> the Swift packet, which says "a rule of it not named here is followed as written"
> (`docs/nfdr.md:L1033-L1034`).

---

## 1. Open issues — questions with no answer yet

None.

## 2. Choices to confirm — the Principal Architect drafted a best-effort answer; confirm or override

> **No `product-architecture` run wrote this section or its item.** A `companion-self-answer` run
> added it on 2026-09-26 while answering §§ 3.1 – 3.2 (`docs/trail/architecture/self_answer-20.md`,
> § Raised on this document). It was found by reading `nfdr.md` § 9 whole against the Swift packet's
> `toolchain.md` § Toolchain version, not raised by any item. It sits in this bucket because the run
> holds a lean, and its slot is the next round's.

### 2.1 § 9's tools-version departure has two more consequences the bullet does not name — `.strictMemorySafety()` and `.defaultIsolation(MainActor.self)` are `PackageDescription` 6.2 settings the manifest cannot state, and the bullet says each is followed as written
- **Lands in:** `nfdr.md` § 9, the `nozoki-mac` bullet's *Departed from* list, beside the three it
  names and the language mode § 3.2 adds.
- **Drafted into the records:** Nothing. No producing run wrote this; the run that raised it writes
  no record. The change it proposes: both settings join *Departed from* under the same flip as the
  three, adopted with the `6.2` tools version — `.strictMemorySafety()` on every target
  (`conventions.md`: "Every target the package builds carries the quality gates' manifest settings,
  unconditionally"; `quality_gates.md` § Types), and `.defaultIsolation(MainActor.self)` on the
  targets the packet's rule places it on (`conventions.md`, the `.defaultIsolation` bullet — the
  executable and the target holding the UI code, not a target called from any isolation domain),
  which targets those are being the flip's change's placement under that rule. The cost named with
  each: strict memory safety will require the `unsafe` keyword at every pointer crossing
  `CNozokiBridge` (`quality_gates.md` § Types: "a pointer crossing the bridge does"), and default
  main-actor isolation lands on code that today runs off the main thread by design
  (`nozoki-mac/Sources/Shell/ReadRunning.swift`).
- **Rationale:** `toolchain.md` § Toolchain version names three manifest settings "First available in
  PackageDescription 6.2" — `.treatAllWarnings(as:)`, `.strictMemorySafety()` and
  `.defaultIsolation(_:)` (`:L48-L53`) — and the bullet's list names the first alone
  (`docs/nfdr.md:L1060-L1064`). `nozoki-mac/Package.swift` carries no `swiftSettings` on any target
  (`grep -n swiftSettings nozoki-mac/Package.swift` prints nothing at `nozoki@6e1d79f`). By the
  bullet's own words a packet rule not named is followed as written; neither of these can be, under
  a `5.9` manifest, so both are the same false claim § 3.2 found for the language mode, and the same
  cause. One item for both, because they share the cause and the flip.
- **If overridden:** The bullet keeps claiming two rules followed that the manifest cannot state. A
  reader at `development-design` holding the packet and § 9 would require a setting tools version
  5.9 refuses, or would read the manifest's silence as a departure nobody recorded — the shape
  §§ 3.1 and 3.2 were raised for.
- **Confirm or override:** <"confirm", or "override: <what to do instead>">

## 3. Raised from downstream — an item from a seat that did not write these records

### 3.1 § 9 says the Swift test framework is followed, but new tests are XCTest and no departure is recorded
- **Raised by:** PM — 2026-09-26
- **Which record:** `nfdr.md` § 9 *Test strategy*, the bullet "`nozoki-mac` against the Swift
  packet", its *Framework — followed* clause (`docs/nfdr.md:L1034-L1039`).
- **Tracked by:** `nozoki · nemawashi · 2026-09-15_open-a-folder`
- **What it blocks:** a true statement of the framework rule. The clause says the existing XCTest
  files stay, and a new test is Swift Testing. It also says the first new test finds out whether
  CI's toolchain runs Swift Testing, and that a departure is recorded here, with the measurement, if
  it cannot. At `nozoki@f46269a`:
  - `nozoki-mac/Tests/SurfacesTests/RootItemsViewExpansionTests.swift` is a new test file, added at
    `nozoki@a5fc189`. It imports `XCTest` and runs 23 cases.
  - `grep -rl 'import Testing' nozoki-mac/Tests` prints nothing.
  - `grep -rl 'import XCTest' nozoki-mac/Tests` lists five files, where the clause counted four on
    2026-09-23.

  The ground given in the new file's commits is that `macos-14`'s default Xcode is 15.4, read from
  the runner image's readme. The same bullet rules that this label does not settle which toolchain
  CI builds with (`docs/nfdr.md:L1049-L1056`), so the measurement the clause asks for has not been
  taken. The framework is departed from, and the departure is not recorded.
- **Where it shows:** the *Framework* clause and its count. The bullet's *Departed from* list
  (`:L1060-L1064`) names the tools version, the link route and `.treatAllWarnings(as:)`. It does not
  name the framework.
- **If a document has to be written:** none. One reading adds the framework to the departures that
  flip with the toolchain: new tests are XCTest until a CI log on `main` names a toolchain that runs
  Swift Testing, and then new tests are Swift Testing. The other reading keeps the rule and names the
  measurement CI owes before the next new test file. Which one is the records' call.
- **Answer:** Answered, the item's first reading, made exact — decided in the owner's seat by a
  `companion-self-answer` run; reasoning at `docs/trail/architecture/self_answer-20.md` § 3.1. The
  framework joins the bullet's *Departed from* list as a departure with a flip of its own, beside the
  four that flip together on a Swift 6.2 toolchain and not among them: a new test is XCTest, in the
  test targets that exist, until a CI log on `main` names a toolchain that runs Swift Testing — the
  log the *Toolchain — not yet measured* clause already waits for — and from that log on a new test
  is Swift Testing and the XCTest files stay, as the packet keeps them (`testing.md` § One
  framework). The flip is separate because its ground is: Swift Testing ships "with the Swift 6
  toolchain and Xcode 16" (the Swift Testing README, read 2026-09-26), and the `macos-14` image
  carries Xcode 16.1 and 16.2 beside its 15.4 default (the image readme, read 2026-09-26) — so this
  departure can end on a `ci.yml` step that selects an Xcode the image already holds, the delivery
  tier's change, reviewed against this bullet, while the three wait on a 6.2 toolchain the image does
  not offer. The *Framework* clause's count is corrected and dated: five files import XCTest at
  `nozoki@f46269a`, the fifth `nozoki-mac/Tests/SurfacesTests/RootItemsViewExpansionTests.swift`
  (`nozoki@a5fc189`), and its "not known" sentence becomes the departure's flip. The *verified by*
  tail gains a trigger: review at `development-design` on any change that adds a file under
  `nozoki-mac/Tests/`, against the *Framework* clause — the tail reads `Package.swift` and
  `.github/workflows/*.yml` only, which is how three changes wrote XCTest and none reached this
  file. Not the second reading: the clause already gave the first new test the measurement, three
  changes wrote XCTest and none took it, because nothing in the tree prints the toolchain and the
  owner's seat left adding that step to the delivery tier (`docs/trail/architecture/cycle-13.md`
  § 2.1) — a rule whose measurement no step produces is not one a change can be caught breaking.

### 3.2 § 9 does not state the Swift language mode, so it claims the Swift 6 mode is followed, and the package builds in the Swift 5 mode
- **Raised by:** PM — 2026-09-26
- **Which record:** `nfdr.md` § 9 *Test strategy*, the bullet "`nozoki-mac` against the Swift
  packet", its *Departed from* list (`docs/nfdr.md:L1060-L1064`). Where an ADR records the step
  down, it is that ADR too.
- **Tracked by:** `nozoki · nemawashi · 2026-09-15_open-a-folder`
- **What it blocks:** a true statement of the language mode, and the data-race checks that go with
  it. The packet builds a package in the Swift 6 language mode. A target that steps down to the Swift
  5 mode is recorded in the product's `docs/adr/` with its reason, because that "removes that
  module's data-race checks outright". Such a target also carries
  `.enableUpcomingFeature("StrictConcurrency")` (`languages/swift/toolchain.md` § *Language mode —
  Swift 6, stated in the manifest*).
  - `nozoki-mac/Package.swift:L1` reads `// swift-tools-version:5.9`. Under that tools version every
    target builds in the Swift 5 mode.
  - No target carries a language-mode or concurrency setting. `grep -n -i
    "swiftLanguage\|StrictConcurrency\|swiftSettings" nozoki-mac/Package.swift` prints nothing.
  - No record states it. `grep -n -i "StrictConcurrency\|language mode\|swiftLanguageMode\|Sendable"
    docs/nfdr.md docs/adr/*.md` prints nothing.

  So the rule is not named here, and by the bullet's own words it is followed as written. It is not.
- **Where it shows:** `nozoki-mac/Sources/Shell/LaunchFlow.swift:L52-L53`. A closure run off the main
  thread captures `bridge`, an `any Bridging`. `Bridging` is not `Sendable`
  (`nozoki-mac/Sources/Shell/Bridging.swift:L7`), and the build gives no diagnostic. The packet
  measured this form building silently under the Swift 5 mode. Whether `StrictConcurrency` reports it
  here has not been measured. Whether tools version 5.9 accepts that feature under that spelling has
  not been measured either.
- **If a document has to be written:** none. The language mode joins the *Departed from* list as the
  tools version's consequence, with the same flip. Whether each target carries `StrictConcurrency`
  in the meantime is the records' call, and the list says which.
- **Answer:** Answered — decided in the owner's seat by a `companion-self-answer` run; reasoning at
  `docs/trail/architecture/self_answer-20.md` § 3.2. The language mode joins the *Departed from*
  list as the tools version's consequence, with the same flip: under `swift-tools-version:5.9` every
  target builds in the Swift 5 mode, and at the `6.2` tools version every target builds in the
  Swift 6 mode with `swiftLanguageModes: [.v6]` written out (`toolchain.md` § Language mode), the
  three and the mode adopted together. No target carries `StrictConcurrency` in the meantime, and
  the list says so with the ground: without `.treatAllWarnings(as: .error)` — departed with the same
  flip — the feature's diagnostics are warnings the Test gate cannot fail on (measured 2026-09-26 in
  a copy of `nozoki-mac` at `nozoki@6e1d79f`, Apple Swift 6.4: `.enableUpcomingFeature("StrictConcurrency")`
  on `Surfaces` and `Shell` under tools 5.9 was accepted and `swift build --target Shell` completed
  with three warnings and no error); and the setting's spelling follows the compiler —
  `enableExperimentalFeature` under 5.9 and 5.10 tools, `enableUpcomingFeature` from 6.0 (the Swift
  migration guide, read 2026-09-26) — while CI's toolchain is, by this bullet's own clause, not yet
  measured, so the record could not spell the setting it required. What the list names instead is
  the cost, so the flip's change knows its bar: the two sites the Swift 6 mode refuses, measured in
  that build — `nozoki-mac/Sources/Shell/LaunchFlow.swift:L53` (`bridge`, `any Bridging`, captured
  in a `@Sendable` closure) and `nozoki-mac/Sources/Shell/ReadRunning.swift:L28` (`deliver`, a
  `@MainActor (RootListing?) -> Void`, sent across one) — each reported as "an error in the Swift 6
  language mode", plus any site a later change adds before the flip. No ADR: no target steps down
  alone; the package sits in the Swift 5 mode as a consequence of a departure these records already
  hold in § 9, where ADR-0016 § Consequences places every departure from the Swift packet.

**How it closes.** `product-architecture` folds it on its next run like any other item here.
