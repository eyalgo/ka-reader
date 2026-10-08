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

> **No `product-architecture` run opened this companion. The PM opened it on 2026-09-23.**
> `nfdr.md` is settled at v12 and the records had no companion on disk. Without one, a
> `product-architecture` re-run would read them as done and find nothing to act on. The companion
> holds four items, §§ 3.1 – 3.4. Each was found by measuring the `ka-reader-bridge` crate,
> `ka-reader-mac` and the project card as they now stand against these records.

---

## 2. Choices to confirm — the Principal Architect drafted a best-effort answer; confirm or override

### 2.1 QC-24 holds the export set inside SM-4's list, and the bridge exports `ka_reader_free`, which that list leaves out

> **No `product-architecture` run wrote this item, and no record was edited for it.** A
> `companion-self-answer` run raised it on 2026-09-23 while answering `docs/SDD_open_issues.md`
> § 5.1. That item finds a flaw in the SDD's C-R7: it holds the bridge's export set inside SM-4's
> list, but SM-4's own return rule needs `ka_reader_free`, and `ka_reader_free` is not on the list. The
> run answered it with `ka_reader_free` standing *beside* the list, as the seam's one release
> function, not on it. QC-24 transcribes C-R7, so the same correction is owed here. The run's
> reasoning is `docs/trail/sdd/self_answer-23.md` § 5.1. This section heading is added with the
> item, because the file held § 3 alone.

- **Lands in:** `nfdr.md` QC-24, and QC-59's pin wherever it reads "`SM-4`'s function list as the
  bridge exports it"
- **Drafted into the records:** Nothing yet. This run edits no record. The draft it proposes is
  this. QC-24 holds the export set inside SM-4's list and `ka_reader_free`, where it now says inside
  the list alone. From `v1.0.0` the set is the list whole and `ka_reader_free`. The *verified by*
  clause changes to match: "that set inside the list above, and `ka_reader_free`". QC-59's pin
  records `ka_reader_free` along with the nine functions, because the pin reads the export set.
- **Rationale:** The SDD's § 4 opening note says the NFDR is re-derived from § 4 where the two
  disagree. When `product-sdd` folds § 5.1, C-R7 will admit `ka_reader_free` and QC-24 will not.
  QC-24 is already false against the built tree. `crates/ka-reader-bridge/src/exports.rs:L61`
  exports `ka_reader_free`, and `crates/ka-reader-bridge/tests/exports.rs:L17` admits it, but QC-24's
  rule refuses it (`nfdr.md:L296-L303`). The records already place `ka_reader_free` beside the
  list. ADR-0013 names it after the nine (`adr/0013-sandboxed-single-process-read-pipeline.md:L47-L48`),
  and ADR-0016 lists it separately from SM-4's functions
  (`adr/0016-physical-unit-set-core-bridge-mac-checks.md:L28`). So this is a transcription, and
  no record is superseded. `ka_reader_free` is not a command. QC-2's "`checks/read-only.sh` after
  every function the build exports, driven through `SM-5`" does not reach it, because SM-5 is the
  model's API and `ka_reader_free` never calls the model.
- **If overridden:** QC-24 stays stricter than the SDD's C-R7. The export test as built already
  admits a function the entry refuses, and a check written to QC-24's letter would fail the
  bridge that has been built.
- **The order:** If this round runs before `product-sdd` folds § 5.1, the SDD's C-R7 does not yet
  carry the sentence this item transcribes. Whether to wait for that fold or take the wording from
  that item's answer is the Principal Architect's call.
- **Confirm or override:** confirm, with additions. Take QC-24's words from `docs/SDD.md` § 4 C-R7 as it now reads. The SDD folded its § 5.1 and is Settled at v16 (`docs/SDD.md:L596-L607`), so **The order** is moot. The held set is SM-4's list and `ka_reader_free`, and from `v1.0.0` the list whole and `ka_reader_free`. Carry C-R7's other new sentence as well: no second plumbing export (a `model_changed` registration call, or any other) is admitted until the slice that needs one raises it. **Additions.** (1) QC-2's tail reads "after every function the build exports (C-R7), driven through `SM-5`". Read literally, that does reach `ka_reader_free`, so the draft's reason that QC-2 does not reach it fails on QC-2's own words. QC-2 takes C-I3's carve-out: a command is a call on SM-4's list, and `ka_reader_free` is no command (`docs/SDD.md:L729-L732`). (2) QC-1 says the shell's "only channel to the core is `SM-4`'s exported function list", but the shell calls `ka_reader_free` too. QC-1 reads "SM-4's list and `ka_reader_free`", as SM-4's Down cell now does (`docs/SDD.md:L414`). (3) QC-59's pin reads "`SM-4`'s function list and `ka_reader_free`", as C-I6 does (`docs/SDD.md:L748`). (4) QC-24's trace reads C-R7 at v16. QC-30's boundary set does not move, because `ka_reader_free` reads nothing. Reasoning: `docs/trail/architecture/self_answer-13.md` § 2.1.

---

## 3. Raised from downstream — an item from a seat that did not write these records

### 3.1 QC-13's import list, read as exhaustive, forbids the four crates the bridge now imports
- **Raised by:** PM — 2026-09-23
- **Which record:** `nfdr.md` QC-13
- **Tracked by:** `ka-reader · nemawashi · 2026-09-15_open-a-folder`
- **What it blocks:** The obligation `checks/structure.sh` will enforce once it exists. QC-13 says
  "`ka-reader-bridge` may import `ka-reader-core` and the standard library" (`nfdr.md:L177`). Read as a
  closed list, that makes every other dependency a breach.
- **Where it shows:** `crates/ka-reader-bridge/Cargo.toml` on `main` declares `log`, `serde`,
  `serde_json` and `libc` beside `ka-reader-core`. Each is on `checks/deps.allow`, so it has passed
  QC-3's review. QC-13 does not say whether "may import" is the whole list or only the edge that
  matters to the layering. The first reading makes the bridge as built a violation. The second
  leaves unstated which crates the bridge may take.
- **If a document has to be written:** None. QC-13 is owed one clause that says which reading it
  means. **The PM's lean:** the bridge may import `ka-reader-core`, the standard library and the crates
  `checks/deps.allow` lists, and QC-13 names them or points at the list.
- **Answer:** Answered in the owner's seat by a `companion-self-answer` run, 2026-09-23. **"May import" is the whole list.** § 1.2's own preamble says so ("'May import' is the whole allowed set", `docs/nfdr.md:L128`). So the bridge as built breaks QC-13. QC-13 also contradicts QC-61, which requires every shipped Rust crate to depend on `log` and the bridge's writer to implement `log::Log` (`docs/nfdr.md:L662-L666`). Fix QC-13, not the bridge. `ka-reader-bridge` may import `ka-reader-core`, the standard library and the crates `checks/deps.allow` names. QC-13 points at the list, the form QC-9 already uses for `ka-reader-core`, rather than naming four crates: a named list is a hand-kept copy that goes false at the bridge's next dependency. Every other clause of QC-13 stands: no Apple framework, no `std::fs` outside the log writer, no read logic. QC-11's "only `git-reader` imports the libgit2 binding" still keeps the binding out of the bridge. The list does not stop a listed crate being used to put read logic in the bridge. That stays QC-13's delegation review at `development-design`, and the tail says so. Reasoning: `docs/trail/architecture/self_answer-13.md` § 3.1.

### 3.2 § 9's scope for `checks/structure.sh` reaches the bridge's build script, which uses `std::fs` and never ships
- **Raised by:** PM — 2026-09-23
- **Which record:** `nfdr.md` § 9, the `checks/structure.sh` scope bullet; QC-13's `std::fs` rule
- **Tracked by:** `ka-reader · nemawashi · 2026-09-15_open-a-folder`
- **What it blocks:** A `checks/structure.sh` written to § 9 as it stands would go red on a file
  that is not in the shipped process. § 9 says the script's rules "read the product crates' sources
  outside `crates/*/tests/`" (`nfdr.md:L837-L839`), and among the rules it binds is "QC-13's *no
  `std::fs` in `ka-reader-bridge` outside its log writer*" (`:L843`).
- **Where it shows:** `crates/ka-reader-bridge/build.rs` imports `std::fs` (`:L11`) and writes the
  generated header with it (`:L25`, `:L28`). Cargo runs a build script at compile time and never
  links it into the library. It sits outside `crates/*/tests/`, so § 9's scope reads it. § 9's own
  reasoning for the scope is that a property is "about the process an adopter runs", and that
  reasoning excludes the build script just as it excludes the tests.
- **If a document has to be written:** None. § 9's scope is owed a statement on build scripts.
  **The PM's lean:** the rules read shipped sources, outside `crates/*/tests/` and outside each
  crate's `build.rs`.
- **Answer:** Answered in the owner's seat by a `companion-self-answer` run, 2026-09-23. **Yes, with additions.** § 9's scope for `checks/structure.sh` excludes each crate's build script, beside `crates/*/tests/`. Cargo compiles a build script and runs it "just before building the package", and the script is not part of the library it builds (https://doc.rust-lang.org/cargo/reference/build-scripts.html, re-read 2026-09-23). So it is not in the process an adopter runs, which is § 9's own reason for the scope. QC-30's second half already excepts a dependency's root `build.rs` on the same ground (`docs/nfdr.md:L459-L460`). **Additions.** (1) The bridge's `build.rs` also calls `std::env::var` (`crates/ka-reader-bridge/build.rs:L18`), which the first half of QC-30 and QC-58 would catch. The exclusion covers the whole scope, so it covers that read too. (2) § 9's "What the scope does not do" drops `build.rs` and names the case the exclusion opens. Rust source that a build script generates into `OUT_DIR`, and that a shipped file pulls in with `include!`, is shipped code that no grep rule reads. Like the `#[path]` case, it is a review catch at `development-design`. The tree has no such site today (`grep -rn OUT_DIR crates/` prints nothing). (3) `benches/` and `examples/` are still not excluded: no item cites one, so they wait until one occurs. Reasoning: `docs/trail/architecture/self_answer-13.md` § 3.2.

### 3.3 § 8 states the project card as naming TypeScript and Vitest, and the card has moved
- **Raised by:** PM — 2026-09-23
- **Which record:** `nfdr.md` § 8
- **Tracked by:** `ka-reader · nemawashi · 2026-09-15_open-a-folder`
- **What it blocks:** Nothing is blocked from being built. But § 8 is the record's one statement of
  the change-time gate, and it is now false. It says the card runs "Vitest for `ka-reader-ui`" and
  that "its `Languages:` line names Rust, TypeScript and Shell", stated "as it reads at
  `kensaiapp-opensource@defe740`", and that it "goes false at the card's next move until RN-6 is
  extended" (`nfdr.md:L709-L717`).
- **Where it shows:** The card moved at `kensaiapp-opensource@5b27023` (2026-09-23). It now reads
  `Languages: Rust, Swift, Shell`, with `cargo test --workspace --locked && swift test
  --package-path ka-reader-mac` as its test command. That is the move § 8 names as owed.
- **If a document has to be written:** None. § 8 and RN-6 are owed the card as it now reads, and
  the "owed a move" sentence is owed its removal.
- **Answer:** Answered in the owner's seat by a `companion-self-answer` run, 2026-09-23. **Yes.** § 8 states the card as it now reads: test command `cargo test --workspace --locked && swift test --package-path ka-reader-mac`, and `Languages: Rust, Swift, Shell`. The "owed a move" sentence goes. The card has moved twice since `defe740`, not once, and RN-6's pinned history gains both. `kensaiapp-opensource@5b27023` put Swift in place of TypeScript on the `Languages:` line, the test command and `Language roots:`. `kensaiapp-opensource@ec80077` made the `Languages:` comment name Swift's packet (`git log -- system/projects/ka-reader/project.md`, 2026-09-23). § 8 pins whichever card commit the fold reads. Decided together with § 3.4: RN-7's sentence that the renderer resolves to the TypeScript packet from the card becomes history, and Swift now resolves to the Swift packet at step 1 from this line. Reasoning: `docs/trail/architecture/self_answer-13.md` § 3.3.

### 3.4 § 9 and ADR-0016 say no Swift packet exists, and `ka-reader-mac` departs from the packet that now does
- **Raised by:** PM — 2026-09-23
- **Which record:** `nfdr.md` § 9 (the Swift sentence, `:L798-L806`) and RN-7; `adr/0016-physical-unit-set-core-bridge-mac-checks.md` (`:L44`, `:L74`)
- **Tracked by:** `ka-reader · nemawashi · 2026-09-15_open-a-folder`
- **What it blocks:** § 9 fixes `ka-reader-mac`'s testing tool as "this product's own, recorded here
  as the doctrine asks of a product whose language has no packet". It says XCTest through Swift
  Package Manager, and it rests that on "For `ka-reader-mac` no packet exists" (`nfdr.md:L798-L806`).
  ADR-0016 rests the frame's layout on the same premise (`:L44`, `:L74`). The premise is gone. Where
  the product departs from the packet, no record says so or why.
- **Where it shows:** The registry carries `languages/swift/` since `kensaiapp-dev@3ab2e8553`
  (2026-09-23). `ka-reader-mac` on `main` departs from it in five places:
  - Tests use XCTest, where the packet writes tests in Swift Testing (`testing.md:L17`).
  - The bridge links as `.systemLibrary` with a `-L` flag, where the packet's route for a library
    built by another toolchain is `.binaryTarget` over a local artifact bundle (`layout.md:L123`).
  - `// swift-tools-version:5.9` (`ka-reader-mac/Package.swift:L1`), where the packet asks for `6.2` or
    later (`toolchain.md:L48-L49`).
  - The test targets are `SurfacesTests` and `ShellTests`, where the packet names them
    `<Target><Layer>Tests` (`layout.md:L158`).
  - The manifest sets no warnings-as-errors level, where the packet sets one on every target
    (`quality_gates.md:L148`).

  The packet also asks that the CI toolchain version be recorded (`toolchain.md` § *Toolchain
  version*). The project's precedence rule puts these records above a packet, so the departures are
  legitimate. But § 9 still records them as the floor case, not as departures.
- **If a document has to be written:** None. § 9, RN-7 and ADR-0016 are owed a re-read against the
  packet, with each of the five marked adopted or departed-from, and why.
- **Answer:** Answered in the owner's seat by a `companion-self-answer` run, 2026-09-23. **The premise is gone. § 9, RN-7 and ADR-0016 are corrected, and each of the five gets its own verdict.** **(1) XCTest is not a departure.** The packet keeps the XCTest tests a product already has ("XCTest tests a product already has stay as they are", `testing.md:L24-L26`); only *new* tests are Swift Testing. § 9 adopts that. The change that writes the first new test records which toolchain ran it (see the CI toolchain record below). If that toolchain cannot run Swift Testing, that change records the departure in § 9 with the measurement. **(2), (3) and (5): the tools version, the artifact-bundle link and warnings-as-errors depart for now, as one decision.** All three need a Swift 6.2 toolchain. The packet asks for `swift-tools-version` 6.2 or later. `.binaryTarget` over a static-library artifact bundle is SE-0482, "Implemented (Swift 6.2)". `.treatAllWarnings(as:)` is "First available in PackageDescription 6.2" (`toolchain.md` § *Toolchain version*, § *Linking a C library built by another toolchain*). The product's only CI runs on `macos-14` (`.github/workflows/ci.yml:L18`). That image's newest Xcode is 16.2 and its default is 15.4 (https://github.com/actions/runner-images/blob/main/images/macos/macos-14-arm64-Readme.md, read 2026-09-23). An entry adopting the three now would bind a manifest that no CI build can parse. The condition that flips them is named: the change that moves CI to an image with a Swift 6.2 or later toolchain adopts all three together. The same change re-measures QC-25's hosted-runner narrowing on the new image, because that measurement was taken on `macos-14` (SDD RN-48). **(4) Test target names: adopt `<Target><Layer>Tests`** (`layout.md:L158`). This needs no toolchain move. Nothing in the records grounds the current names: they predate the packet, and a packet outranks the code's own habits (`languages/README.md` § Precedence). **Also owed from the packet:** § 9 records the toolchain version CI builds `ka-reader-mac` with (`toolchain.md` § *Toolchain version*). CI does not build `ka-reader-mac` yet, so § 9 says so, and the first CI log that builds it supplies the value. **ADR-0016 takes a dated correction in place, not a superseding record.** The unit set, the frame's location and "no package dependency" do not move. Only the reason ("because no Swift packet exists") and the matching § Consequences clause are false, which is the form RN-20 used for ADR-0010. Reasoning: `docs/trail/architecture/self_answer-13.md` § 3.4.

**How it closes.** `product-architecture` folds it on its next run like any other item here.
