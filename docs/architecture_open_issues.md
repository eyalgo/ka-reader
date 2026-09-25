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

None.

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
- **Answer:** <the owner fills this in>

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
- **Answer:** <the owner fills this in>

**How it closes.** `product-architecture` folds it on its next run like any other item here.
