# Self-answer report — `docs/adr/` and `docs/nfdr.md`

## Header

- **Companion:** `docs/architecture_open_issues.md`
- **Document:** `docs/adr/` and `docs/nfdr.md` (NFDR Settled at v12; the companion was opened by the PM on 2026-09-23, not by a `product-architecture` run)
- **Decided by:** `decide_companion_answers.md` v1.3.0
- **Date:** 2026-09-23
- **Sources re-read:**
  - https://doc.rust-lang.org/cargo/reference/build-scripts.html — Cargo compiles a build script
    and runs it "just before building the package". The script is not part of the final library.
    Generated Rust goes into `OUT_DIR` and reaches the crate through `include!`. And "Scripts should
    not modify any files outside of that directory". (§ 3.2)
  - https://github.com/actions/runner-images/blob/main/images/macos/macos-14-arm64-Readme.md —
    Xcode 15.0.1 – 15.4 and 16.1 – 16.2 installed, 15.4 the default; nothing newer than 16.2. (§ 3.4)
  - The Swift packet at `<CORE>/doctrine/engineering/languages/swift/` — `testing.md` v1.1.0,
    `layout.md` v1.0.0, `toolchain.md` v1.1.0, `quality_gates.md` v1.1.0, `README.md` v1.0.1 — each
    line the item cites was opened. (§ 3.4)

## Items worked

### 2.1 — QC-24 holds the export set inside SM-4's list, and the bridge exports `nozoki_free`, which that list leaves out

- **Bucket:** 2. Choices to confirm — the Principal Architect drafted a best-effort answer; confirm or override
- **Verdict:** confirmed with addition
- **Why:** The draft is right: QC-24 transcribes C-R7, and C-R7 now admits `nozoki_free`
  beside SM-4's list. The item's open **order** question is moot. `product-sdd` folded the SDD's
  § 5.1 and the SDD is Settled at v16. C-R7 reads "inside SM-4's list and `nozoki_free`"
  (`docs/SDD.md:L596-L607`), and SM-4's Down cell names `nozoki_free` "beside the list and not on
  it" (`docs/SDD.md:L414`). So the fold takes its words from the SDD as it stands, including C-R7's
  new sentence that no second plumbing export is admitted until a slice raises one. On the built tree:
  `crates/nozoki-bridge/src/exports.rs:L61` exports `nozoki_free`, and
  `crates/nozoki-bridge/tests/exports.rs:L17` admits it. **The draft's QC-2 argument fails.**
  It says QC-2's "every function the build exports … driven through `SM-5`" does not reach `nozoki_free`.
  Read to the letter, those words do reach it, because it is a function the build exports. So QC-2 takes the carve-out
  C-I3 now states: a command is a call on SM-4's list, and `nozoki_free` is no command
  (`docs/SDD.md:L729-L732`). **Two more entries say the same thing and follow (check 3).**
  QC-1 says the shell's "only channel to the core is `SM-4`'s exported function list"
  (`docs/nfdr.md:L57-L58`), which is false of a shell that calls `nozoki_free`. QC-59's pin reads
  "`SM-4`'s function list as the bridge exports it" (`docs/nfdr.md:L765-L766`), where C-I6 now reads
  "SM-4's function list and `nozoki_free`" (`docs/SDD.md:L748`). **QC-30 does not move.** Its
  boundary set is about what the process reads, and `nozoki_free` reads nothing. That is the SDD's
  own ground for placing it beside the list ("it reads nothing and grants nothing", RN-66). No record
  moves: ADR-0013 and ADR-0016 already name `nozoki_free` separately from the nine
  (`docs/adr/0013-sandboxed-single-process-read-pipeline.md` § Decision; `docs/adr/0016-physical-unit-set-core-bridge-mac-checks.md`, the
  units table). **Check 4:** the stale case is the one C-R7 names. A later plumbing export would
  pass QC-24's set equality while sitting outside the held set. C-R7's new sentence names that
  case, and QC-24 carries it. I was close to answering **confirmed**; the QC-2 hole tipped it.

### 3.1 — QC-13's import list, read as exhaustive, forbids the four crates the bridge now imports

- **Bucket:** 3. Raised from downstream — an item from a seat that did not write these records
- **Verdict:** confirmed with addition
- **Why:** I treated the PM's lean as a draft. The item's framing is partly wrong (check 2). It
  says QC-13 "does not say" whether "may import" is the whole list, but § 1.2's preamble does say so:
  "'May import' is the whole allowed set; 'must not import' is stated explicitly and never inferred"
  (`docs/nfdr.md:L128-L129`). So only the first reading is open, and under it the bridge as built
  breaks QC-13. `crates/nozoki-bridge/Cargo.toml` declares `log`, `nozoki-core`, `serde`,
  `serde_json` and `libc`, and all four outside crates are on `checks/deps.allow` (`:L111`, `:L114`,
  `:L164`, `:L169`). **The stronger ground is inside this document (check 3):** QC-61 requires "Every
  shipped Rust crate" to depend on `log`, and the bridge's own writer to implement `log::Log`
  (`docs/nfdr.md:L661-L666`). So QC-13, read as § 1.2 says to read it, contradicts QC-61.
  This is a correction of two settled entries that disagree, not a widening. **Of the lean's two
  forms, I chose "points at the list".** QC-9 already bounds `nozoki-core` the same way ("any crate
  outside `checks/deps.allow`", `docs/nfdr.md:L142-L143`). Naming four crates in QC-13 would be a
  hand-kept copy of the manifest, and it would go false at the bridge's next reviewed dependency.
  **Check 4 — what widens.** The list is workspace-wide, so in principle the bridge could import
  anything `nozoki-core` uses. Two rules hold it. QC-11's "Only `git-reader` imports the libgit2
  binding" keeps the Git binding out, and QC-13's own delegation rule ("holds no read logic") is a
  review gate that catches a parser or a grammar engine imported into the bridge. The tail names
  that review as the catch. Every other clause of QC-13 stands. No record moves: ADR-0016 fixes the
  unit, not its dependency list.

### 3.2 — § 9's scope for `checks/structure.sh` reaches the bridge's build script, which uses `std::fs` and never ships

- **Bucket:** 3. Raised from downstream — an item from a seat that did not write these records
- **Verdict:** confirmed with addition
- **Why:** I treated the PM's lean as a draft. The item cites an occurrence:
  `crates/nozoki-bridge/build.rs:L11` imports `std::fs`, and `:L25` and `:L28`–`:L30` read and write
  with it (opened this run). § 9 currently says the opposite on purpose: "a crate's `build.rs` … [is]
  not excluded" (`docs/nfdr.md:L849-L850`). That was written when no build script existed to shape
  a rule against, and one now exists. **The lean holds, for the reason § 9 already gives.** The scope
  exists because "Every property the script holds is about the process an adopter runs"
  (`docs/nfdr.md:L838-L839`). Cargo compiles a build script and runs it "just before building the
  package", and the script is not part of the library (Cargo reference, re-read today, Header).
  QC-30's second half already excepts a dependency's root `build.rs` on this ground
  (`docs/nfdr.md:L459-L460`), so the product's own crates now match their dependencies.
  **Additions.** (1) The same file calls `std::env::var("CARGO_MANIFEST_DIR")` (`build.rs:L18`),
  which the first half of QC-30 and QC-58 ("no `std::env::var` … in the product's own crates") would
  also catch. The scope exclusion covers every rule of the script, so it clears that read too, and the
  tails need no edit. (2) **Check 4 — what the exclusion opens.** A build script can generate Rust
  into `OUT_DIR` that a shipped file pulls in with `include!`. That code ships, and no grep over
  sources reads it. § 9 names this case as it names `#[path]`: a review catch at
  `development-design`, because no site exists (`grep -rn OUT_DIR crates/` prints nothing today).
  (3) `benches/` and `examples/` stay not excluded. No item cites one, so under § *A widening item
  waits until it occurs* they are answered "not until it occurs".

### 3.3 — § 8 states the project card as naming TypeScript and Vitest, and the card has moved

- **Bucket:** 3. Raised from downstream — an item from a seat that did not write these records
- **Verdict:** confirmed with addition
- **Why:** § 8 is false against the card, a fact measured today and the strongest case for a
  change. The card reads `Test command: cargo test --workspace --locked && swift test --package-path
  nozoki-mac` and `Languages: Rust, Swift, Shell`
  (`kensaiapp-opensource:system/projects/nozoki/project.md:L7-L8`). **Addition:** the card has
  moved twice since the `defe740` § 8 pins, not once. `5b27023` put Swift in place of TypeScript
  (Languages, test command, `Language roots:`), and `ec80077` made the `Languages:` comment name
  Swift's packet (`git log -- system/projects/nozoki/project.md`, run today). RN-6 gains both, and
  § 8 pins whichever commit the fold reads. "Owed a move" goes, because the move happened.
  **Decided together with § 3.4 (check 3):** RN-7's step-1 sentence names the TypeScript packet for
  the renderer. It becomes history, and Swift resolves to the Swift packet from the same line.
  This is a correction, not a widening.

### 3.4 — § 9 and ADR-0016 say no Swift packet exists, and `nozoki-mac` departs from the packet that now does

- **Bucket:** 3. Raised from downstream — an item from a seat that did not write these records
- **Verdict:** answered
- **Why:** The item gives no lean; it asks for a re-read. So I answered from scratch, one verdict
  per point, and put the direction in the slot for the fold to write. **The premise is false.**
  The registry carries `swift/` (`<CORE>/doctrine/engineering/languages/`, listed today), so
  `docs/nfdr.md:L798-L806` and ADR-0016's "because no Swift packet exists" (§ Decision) and "a Swift
  package with no language packet behind it" (§ Consequences) are false. The SDD already corrected
  its own copy at v16 (`docs/SDD.md:L396-L401`; RN-66).
  **(1) XCTest is not a departure. The item's supporting text is partly wrong here, and I report it
  rather than correct it.** The packet keeps existing XCTest tests: "XCTest tests a product already
  has stay as they are" (`testing.md:L24-L26`). The four test files are XCTest
  (`nozoki-mac/Tests/`). New tests follow the packet. I don't know whether the Xcode on the CI
  image runs Swift Testing. The change that writes the first new test finds out, and records a
  departure if it can't.
  **(2), (3), (5): one decision, not three.** The 6.2 tools version, the `.binaryTarget` artifact
  bundle, and warnings-as-errors through `.treatAllWarnings(as:)` all need a Swift 6.2 toolchain
  (`toolchain.md` § *Toolchain version*: "First available in PackageDescription 6.2"; § *Linking a
  C library built by another toolchain*: SE-0482 "Implemented (Swift 6.2)"). The only CI this
  product has runs `macos-14` (`.github/workflows/ci.yml:L18`), and that image offers nothing past
  Xcode 16.2 (runner-images readme, re-read today). An entry adopting them now would bind a manifest
  no CI build parses. That is a hole with an entry sitting on top of it, so the verdict is
  **depart, with that reason and a named flip**. The change that moves CI to an image carrying Swift
  6.2 or later adopts all three together, and re-measures QC-25's hosted-runner narrowing. That
  narrowing was measured on `macos-14` (`docs/SDD.md` RN-48), so a new image is its *stale* case
  (check 4). **I was close to "adopt and move the runner".** The CI rewrite is already pending in
  the native shell's deferred tasks 10–15, so the cost would land in a change that is coming anyway.
  What tipped it: the records bind no runner, so choosing one is not this document's decision, and
  the departure costs nothing the day the runner moves. If the owner wants the move, the flip clause
  already says what follows.
  **(4) Test target names: adopt** `<Target><Layer>Tests` (`layout.md:L158`). It needs no
  toolchain. The current names `SurfacesTests` and `ShellTests` (`nozoki-mac/Package.swift`) predate
  the packet, and a packet outranks the code's own habits (`languages/README.md` § Precedence,
  L122). Nothing in the records gives a product reason to depart.
  **Also owed:** the packet asks that the CI toolchain version be recorded in this document where
  no `.swift-version` pin exists (`toolchain.md` § *Toolchain version*). CI does not build
  `nozoki-mac` yet (`ci.yml` still builds the Tauri shape), so § 9 says the value comes from the
  first CI log that builds it. `nozoki-mac/Package.swift:L5-L6` already says "the runner's Swift is
  read from the first CI log".
  **ADR-0016: dated correction in place, not a superseding record.** No decision reverses: the four
  units, the frame inside `nozoki-mac/` and "declares no package dependency" all stand, and even the
  artifact-bundle route, if adopted later, stays inside `nozoki-mac`. Only a *because* clause and a
  consequence clause go false. This is RN-20's case for ADR-0010, a correction the owner's seat
  ruled on in terms, and not RN-18's case, where § Decision's observable itself moved. What would
  tip it to a superseding record: a verdict here that moved a unit or the frame's location, and
  none does.
  **Seat (check 1):** these are this document's own departures, the job RN-7 did for the Rust
  packet. The one ground I cannot see is whether the owner wants contributors held to a newer Xcode.
  The departure on (2), (3) and (5) commits no one to that, which is part of why I chose it.

## Left for the owner

None this run.

## Skipped

- **2.1 — The order** — the field asked the Principal Architect to choose between waiting for the
  SDD's fold and taking its answer's words. The SDD has folded (v16, Settled), so there is nothing
  left to choose. This is recorded under the 2.1 verdict, not decided separately.

## Companions opened

None this run.

**Seen and not raised.** `crates/nozoki-bridge/build.rs:L19` and `:L30` write the header to
`<repo>/target/include/`. The Cargo reference says "Scripts should not modify any files outside of
that directory [`OUT_DIR`]" (re-read today). That is a delivery-code matter under a doctrine
convention, not an NFDR obligation, and no entry here states it. It belongs to the delivery tier.
Separately, the Swift packet's README says a rule is "checked against the first Swift tree this
instance writes" and corrected in the packet. Whether `nozoki-mac` counts as that tree for the
shared core is the packet author's question. Items (2), (3) and (5) above are the evidence they
would read. Neither is a product document with a companion template, so nothing was opened.

## Launchers owed

- **`docs/adr/` and `docs/nfdr.md`** — `<CORE>/launchers/skill/launcher.sh product-architecture nozoki`
