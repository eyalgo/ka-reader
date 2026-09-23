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

> **No `product-architecture` run opened this companion. The PM opened it on 2026-09-23.**
> `nfdr.md` is settled at v12 and the records had no companion on disk. Without one, a
> `product-architecture` re-run would read them as done and find nothing to act on. The companion
> holds four items, §§ 3.1 – 3.4. Each was found by measuring the `nozoki-bridge` crate,
> `nozoki-mac` and the project card as they now stand against these records.

---

## 2. Choices to confirm — the Principal Architect drafted a best-effort answer; confirm or override

### 2.1 QC-24 holds the export set inside SM-4's list, and the bridge exports `nozoki_free`, which that list leaves out

> **No `product-architecture` run wrote this item, and no record was edited for it.** A
> `companion-self-answer` run raised it on 2026-09-23 while answering `docs/SDD_open_issues.md`
> § 5.1. That item finds a flaw in the SDD's C-R7: it holds the bridge's export set inside SM-4's
> list, but SM-4's own return rule needs `nozoki_free`, and `nozoki_free` is not on the list. The
> run answered it with `nozoki_free` standing *beside* the list, as the seam's one release
> function, not on it. QC-24 transcribes C-R7, so the same correction is owed here. The run's
> reasoning is `docs/trail/sdd/self_answer-23.md` § 5.1. This section heading is added with the
> item, because the file held § 3 alone.

- **Lands in:** `nfdr.md` QC-24, and QC-59's pin wherever it reads "`SM-4`'s function list as the
  bridge exports it"
- **Drafted into the records:** Nothing yet. This run edits no record. The draft it proposes is
  this. QC-24 holds the export set inside SM-4's list and `nozoki_free`, where it now says inside
  the list alone. From `v1.0.0` the set is the list whole and `nozoki_free`. The *verified by*
  clause changes to match: "that set inside the list above, and `nozoki_free`". QC-59's pin
  records `nozoki_free` along with the nine functions, because the pin reads the export set.
- **Rationale:** The SDD's § 4 opening note says the NFDR is re-derived from § 4 where the two
  disagree. When `product-sdd` folds § 5.1, C-R7 will admit `nozoki_free` and QC-24 will not.
  QC-24 is already false against the built tree. `crates/nozoki-bridge/src/exports.rs:L61`
  exports `nozoki_free`, and `crates/nozoki-bridge/tests/exports.rs:L17` admits it, but QC-24's
  rule refuses it (`nfdr.md:L296-L303`). The records already place `nozoki_free` beside the
  list. ADR-0013 names it after the nine (`adr/0013-sandboxed-single-process-read-pipeline.md:L47-L48`),
  and ADR-0016 lists it separately from SM-4's functions
  (`adr/0016-physical-unit-set-core-bridge-mac-checks.md:L28`). So this is a transcription, and
  no record is superseded. `nozoki_free` is not a command. QC-2's "`checks/read-only.sh` after
  every function the build exports, driven through `SM-5`" does not reach it, because SM-5 is the
  model's API and `nozoki_free` never calls the model.
- **If overridden:** QC-24 stays stricter than the SDD's C-R7. The export test as built already
  admits a function the entry refuses, and a check written to QC-24's letter would fail the
  bridge that has been built.
- **The order:** If this round runs before `product-sdd` folds § 5.1, the SDD's C-R7 does not yet
  carry the sentence this item transcribes. Whether to wait for that fold or take the wording from
  that item's answer is the Principal Architect's call.
- **Confirm or override:** <"confirm", or "override: <what to do instead>">

---

## 3. Raised from downstream — an item from a seat that did not write these records

### 3.1 QC-13's import list, read as exhaustive, forbids the four crates the bridge now imports
- **Raised by:** PM — 2026-09-23
- **Which record:** `nfdr.md` QC-13
- **Tracked by:** `nozoki · nemawashi · 2026-09-15_open-a-folder`
- **What it blocks:** The obligation `checks/structure.sh` will enforce once it exists. QC-13 says
  "`nozoki-bridge` may import `nozoki-core` and the standard library" (`nfdr.md:L177`). Read as a
  closed list, that makes every other dependency a breach.
- **Where it shows:** `crates/nozoki-bridge/Cargo.toml` on `main` declares `log`, `serde`,
  `serde_json` and `libc` beside `nozoki-core`. Each is on `checks/deps.allow`, so it has passed
  QC-3's review. QC-13 does not say whether "may import" is the whole list or only the edge that
  matters to the layering. The first reading makes the bridge as built a violation. The second
  leaves unstated which crates the bridge may take.
- **If a document has to be written:** None. QC-13 is owed one clause that says which reading it
  means. **The PM's lean:** the bridge may import `nozoki-core`, the standard library and the crates
  `checks/deps.allow` lists, and QC-13 names them or points at the list.
- **Answer:** <the owner fills this in>

### 3.2 § 9's scope for `checks/structure.sh` reaches the bridge's build script, which uses `std::fs` and never ships
- **Raised by:** PM — 2026-09-23
- **Which record:** `nfdr.md` § 9, the `checks/structure.sh` scope bullet; QC-13's `std::fs` rule
- **Tracked by:** `nozoki · nemawashi · 2026-09-15_open-a-folder`
- **What it blocks:** A `checks/structure.sh` written to § 9 as it stands would go red on a file
  that is not in the shipped process. § 9 says the script's rules "read the product crates' sources
  outside `crates/*/tests/`" (`nfdr.md:L837-L839`), and among the rules it binds is "QC-13's *no
  `std::fs` in `nozoki-bridge` outside its log writer*" (`:L843`).
- **Where it shows:** `crates/nozoki-bridge/build.rs` imports `std::fs` (`:L11`) and writes the
  generated header with it (`:L25`, `:L28`). Cargo runs a build script at compile time and never
  links it into the library. It sits outside `crates/*/tests/`, so § 9's scope reads it. § 9's own
  reasoning for the scope is that a property is "about the process an adopter runs", and that
  reasoning excludes the build script just as it excludes the tests.
- **If a document has to be written:** None. § 9's scope is owed a statement on build scripts.
  **The PM's lean:** the rules read shipped sources, outside `crates/*/tests/` and outside each
  crate's `build.rs`.
- **Answer:** <the owner fills this in>

### 3.3 § 8 states the project card as naming TypeScript and Vitest, and the card has moved
- **Raised by:** PM — 2026-09-23
- **Which record:** `nfdr.md` § 8
- **Tracked by:** `nozoki · nemawashi · 2026-09-15_open-a-folder`
- **What it blocks:** Nothing is blocked from being built. But § 8 is the record's one statement of
  the change-time gate, and it is now false. It says the card runs "Vitest for `nozoki-ui`" and
  that "its `Languages:` line names Rust, TypeScript and Shell", stated "as it reads at
  `kensaiapp-opensource@defe740`", and that it "goes false at the card's next move until RN-6 is
  extended" (`nfdr.md:L709-L717`).
- **Where it shows:** The card moved at `kensaiapp-opensource@5b27023` (2026-09-23). It now reads
  `Languages: Rust, Swift, Shell`, with `cargo test --workspace --locked && swift test
  --package-path nozoki-mac` as its test command. That is the move § 8 names as owed.
- **If a document has to be written:** None. § 8 and RN-6 are owed the card as it now reads, and
  the "owed a move" sentence is owed its removal.
- **Answer:** <the owner fills this in>

### 3.4 § 9 and ADR-0016 say no Swift packet exists, and `nozoki-mac` departs from the packet that now does
- **Raised by:** PM — 2026-09-23
- **Which record:** `nfdr.md` § 9 (the Swift sentence, `:L798-L806`) and RN-7; `adr/0016-physical-unit-set-core-bridge-mac-checks.md` (`:L44`, `:L74`)
- **Tracked by:** `nozoki · nemawashi · 2026-09-15_open-a-folder`
- **What it blocks:** § 9 fixes `nozoki-mac`'s testing tool as "this product's own, recorded here
  as the doctrine asks of a product whose language has no packet". It says XCTest through Swift
  Package Manager, and it rests that on "For `nozoki-mac` no packet exists" (`nfdr.md:L798-L806`).
  ADR-0016 rests the frame's layout on the same premise (`:L44`, `:L74`). The premise is gone. Where
  the product departs from the packet, no record says so or why.
- **Where it shows:** The registry carries `languages/swift/` since `kensaiapp-dev@3ab2e8553`
  (2026-09-23). `nozoki-mac` on `main` departs from it in five places:
  - Tests use XCTest, where the packet writes tests in Swift Testing (`testing.md:L17`).
  - The bridge links as `.systemLibrary` with a `-L` flag, where the packet's route for a library
    built by another toolchain is `.binaryTarget` over a local artifact bundle (`layout.md:L123`).
  - `// swift-tools-version:5.9` (`nozoki-mac/Package.swift:L1`), where the packet asks for `6.2` or
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
- **Answer:** <the owner fills this in>

**How it closes.** `product-architecture` folds it on its next run like any other item here.
