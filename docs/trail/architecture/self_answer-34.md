# Self-answer report — `docs/adr/` and `docs/nfdr.md`

This is the record of one unattended run that answered `docs/architecture_open_issues.md` in the
owner's seat. It is for the owner, who reads it to learn what was decided and why, and for the
`product-architecture` run that folds the answers.

## Header

- **Companion:** `docs/architecture_open_issues.md`
- **Document:** `docs/adr/` and `docs/nfdr.md`
- **Decided by:** `decide_companion_answers.md` v1.3.0
- **Date:** 2026-10-03
- **Sources re-read:** The registry copies of the crates the lock resolves, on this machine
  (`~/.cargo/registry/src/index.crates.io-1949cf8c6b5b557f/`):
  - `git2-0.21.0/src/opts.rs:L20-L23` — `set_search_path` is a `pub unsafe fn`, because it
    "mutates the global state but cannot guarantee thread-safety", and returns a `Result`.
  - `libgit2-sys-0.18.8+1.9.7/libgit2/src/libgit2/sysdir.c` — `:L347`
    `getenv("APP_SANDBOX_CONTAINER_ID")`; `:L357` `git__getenv(out, "HOME")`, else the password
    entry; `:L402-L405` `XDG_CONFIG_HOME`, then `HOME`; `:L458-L459` every level guessed at init;
    `:L559-L560` an empty search path leaves (`goto done`) before any file is touched.
  - `…/libgit2/src/util/fs_path.c:L2030-L2033` — the `SUDO_UID` lookup runs only when
    `euid == 0`.
  - `…/libgit2/src/util/unix/process.c:L21-L23`, `:L113`, `:L128` — `environ` (on macOS
    `*_NSGetEnviron()`) read to build a child's environment. `build.rs:L208` compiles
    `libgit2/src/util/unix`. The only caller of `git_process_new` in `libgit2/src` is
    `libgit2/transports/ssh_exec.c` (`grep -rln git_process_new libgit2/src`).
  - `libz-sys-1.1.29/build.rs:L15-L22` — zlib-ng is built only under the `zlib-ng` or
    `zlib-ng-no-cmake-experimental-community-maintained` feature, and not under `stock-zlib`.
  - The crate set: `cargo tree -p nozoki-bridge --target aarch64-apple-darwin -e normal --locked`
    at `nozoki@4917cbb` resolves 37 crates. A grep of their `.c`, `.h`, `.cc` and `.cpp` files
    finds `getenv` in `libgit2-sys` (10 files) and `libz-sys` (1 file) only, and whole-word
    `environ` or `_NSGetEnviron` in `libgit2-sys` (1 file) only.

  Nothing was read on the web; no answer rests on a source outside this repository other than these
  registry copies.

**What this run read, for both items.** The companion whole. `docs/adr/README.md`; ADR-0016,
ADR-0020 whole; ADR-0004 and ADR-0019 § Consequences. `docs/nfdr.md`: the preamble (`:L1-L44`), § 1's
opening paragraph, QC-9, QC-11, QC-13, QC-17, QC-30, QC-35, § 10's preamble and QC-30 rows,
RN-20's opening, RN-24's append-only passage (`:L2682-L2696`), RN-41's QC-63 passage
(`:L3748-L3762`), RN-43 whole. `docs/SDD.md` v27: the header, § 3's `core-bridge` row, the *Four
physical units* paragraph, RN-87's first half. `docs/trail/architecture/cycle-29.md` §§ 2.1, 2.2.
`checks/entry-points.sh:L1-L140`; `checks/entry-points.allow` whole. In core: the
`product-architecture` skill's append-only rules (`SKILL.md:L80-L92`, `:L225-L230`), the ADR
record template's notes (`adr_record_template.md:L15-L60`), and
`principal_architect_create_architecture.md:L138-L141`. **Not read whole:** `docs/nfdr.md`
(365 KB) and `docs/SDD.md` (492 KB). Each answer is checked against the entries and sections it
moves or rests on, which are listed above.

## Items worked

### 2.1 — ADR-0016 says only `git-reader` imports the libgit2 binding, and SDD v27 adds a `core-bridge` exception; the run drafted a superseding record, ADR-0020, rather than a correction in place

- **Bucket:** 2. Choices to confirm — the Principal Architect drafted a best-effort answer; confirm or override
- **Verdict:** confirmed with addition
- **Why:** **Accept ADR-0020 as a superseding record, after it is made to stand alone.**

  *Check 1 — whose call.* The drafting run left this to the owner because "a wrong guess either
  loses the history or rewrites an accepted record". That names the cost of a wrong answer, not a
  ground this run cannot see. The change lands in `docs/adr/`, this companion's own document. It
  binds only the log's internal consistency: no person, outside party or promise. And the log's
  own rules decide it, as shown next. The `product-architecture` skill sends this ambiguity to a
  companion item (`SKILL.md:L91-L92`), and the owner's seat on that item is the one this run holds.
  So it is mine to answer.

  *Check 2 — does the draft hold, and for its stated reason.* The conclusion holds. The draft's
  reason, "a rule inside the decision moved", is right but thinner than the test the log already
  uses. NFDR RN-24 drew the line when ADR-0016 itself was corrected: a correction in place is
  allowed where "the record's observable, its units table, its alternatives and its binds have not
  moved", which is RN-20's case for ADR-0010. A superseding record is needed where they move, which
  is RN-18's case for ADR-0008 (`nfdr.md:L2689-L2690`). Here three of the four move:
  - the units table, where the `nozoki-bridge` row's last column gains "empties libgit2's
    machine-level config search paths" (`adr/0020-…:L37`);
  - the alternatives, which gain the SDD's four (`:L65-L76`);
  - the binds, which gain QC-35 (`:L138`).

  The ADR template also says a record "is never rewritten", and that a reversal is a new record
  (`adr_record_template.md:L22-L28`). Rewriting ADR-0016's § Decision sentence in place is exactly
  that rewrite.

  *The addition, from the same check.* The argument is right but incomplete about what the new
  record must hold. Once accepted, ADR-0020 is the in-force record of the whole unit set, and
  ADR-0016 becomes history. Yet ADR-0020 points back at ADR-0016 for part of its decision ("as
  ADR-0016 records", `:L51-L52`). Its § Consequences and *rests on* also cover only the switch, so
  ADR-0016's are silently dropped from what is in force:
  - the harness without a window;
  - `unsafe` in one unit with one review;
  - a forbidden import as a build failure;
  - two toolchains;
  - the C ABI kept honest under the address sanitizer;
  - the Swift package's departures recorded in `nfdr.md` § 9;
  - the workspace-edit undo cost;
  - Cargo's lint table and Swift Package Manager as the platform facts it rests on.

  The log's last supersession did the opposite: ADR-0019 restates ADR-0004's consequences and
  dependency paragraph whole, then extends them (ADR-0019 § Consequences against ADR-0004's). A cold
  reader, whom the posture says these records are written for, should not have to read a superseded
  record to learn what the one in force costs. ADR-0020 is still Proposed, so the producing run may
  revise it freely (`product-architecture` `SKILL.md:L90`).

  *Check 3 — does it contradict anything settled.* No. SDD v27 is Settled and states the exception
  in § 3's units paragraph and `core-bridge` row (`SDD.md:L331`, `:L348-L350`). QC-11, QC-13, QC-17
  and QC-35 already state it, tracing "ADR-0020, Proposed". The claims ADR-0020 rests on were
  re-read at the source: `set_search_path` is `unsafe` (`opts.rs:L20-L23`), and an empty path
  touches no file (`sysdir.c:L559-L560`). The fold has a consequence the draft did not follow:
  every NFDR trace naming ADR-0016 must move to ADR-0020, as RN-43 moved ADR-0004's to ADR-0019.
  Those traces include § 1's opening paragraph, which says "The physical module set is ADR-0016's"
  (`nfdr.md:L50`), and more entries than ADR-0016's `## Binds` lists (QC-63 traces it too, RN-41).
  So the slot says "every NFDR trace" rather than a list.

  *Check 4 — failure paths.* **Stale:** a later release adding a fifth config level, or the SDD
  dropping the exception, is a new record superseding ADR-0020. ADR-0020 already names the
  fifth-level case and its gate. **Refused:** the switch's own failure is in the record — it fails
  closed and the Git item is `failed`. **Concurrent:** the record's "before any thread can reach
  libgit2" and "once per process" cover it.

  *Where I came close to another verdict.* A plain **confirmed**: ADR-0020's decision is faithful
  to the SDD, and the gap is in what it carries, not what it decides. What tipped it is that the
  gap only bites after acceptance. That is exactly when it can no longer be fixed without another
  supersession, because an accepted record is never edited.

### 2.2 — QC-30's boundary set misses the C environment reads libgit2 brings, and the run drafted them as a member of half (2), checked by `checks/entry-points.sh` reading `getenv` in C sources, rather than a review-only gate

- **Bucket:** 2. Choices to confirm — the Principal Architect drafted a best-effort answer; confirm or override
- **Verdict:** confirmed with addition
- **Why:** **A C environment read is a named member of half (2), held by the scan, as drafted.
  The scan also reads `environ`, and QC-30 names the reads that the (crate, name) pairing lets
  through.**

  *Check 1.* The change lands in `nfdr.md` QC-30 and § 10, this companion's document. It binds the
  constraint set's internal consistency and no person. Mine.

  *Check 2.* The draft holds, for its stated reason. A review-only gate is a class-2 downgrade, and
  class 2 "must be argued": an entry claiming it states why no command can check it
  (`principal_architect_create_architecture.md:L138-L139`). Here a command can.
  `checks/entry-points.sh` already reads every file under each crate's package directory "whatever
  its extension" (`:L50-L51`). It already lists uncompiled reads with their reason
  (`entry-points.allow:L30-L31`). So a C pattern is a rule added to an existing scan, which the
  NFDR preamble's per-rule executability already accommodates: the gate is `development-design`
  until the change that adds the rule.

  Every measurement the draft gives held when re-read at the source:
  - two of 37 crates carry C `getenv`, with 10 files in `libgit2-sys` and 1 in `libz-sys`;
  - the init reads are at `sysdir.c:L347`, `:L357`, `:L402-L405` and `:L458-L459`;
  - `SUDO_UID` is read only under `euid == 0` (`fs_path.c:L2030-L2033`);
  - zlib-ng is feature-gated (`libz-sys build.rs:L15-L22`).

  **Supporting text wrong, reported and not corrected:** the rationale cites "`docs/nfdr.md`
  preamble" for the class-2 rule. The preamble (`nfdr.md:L1-L44`) does not state it, and its
  nearest sentence is "An entry with no nameable verification is not yet an entry". The rule lives
  in the authoring prompt cited above. The answer's slot names the right source, so the fold does
  not inherit the wrong citation.

  *The addition, from check 4.* Two cases the draft's rule does not reach.
  1. **Absent from the pattern: `environ`.** A `getenv` pattern finds every C read made through
     `getenv`, but not one made through the process's environment array. libgit2's
     `src/util/unix/process.c` reads `environ`, defined on macOS as `(*_NSGetEnviron())`
     (`:L21-L23`), when building a child's environment (`:L113`, `:L128`). `build.rs:L208`
     compiles the file, so QC-30's "exactly" is false without it. It is dormant: `git_process_new`'s
     only caller in `libgit2/src` is `transports/ssh_exec.c`, a remote the port never makes. That
     is the same class the draft already names for `getenv` ("a remote … the SSH transport, a
     spawned process"). The cheapest true fix is the same rule reading `environ` and
     `_NSGetEnviron` beside `getenv`. Measured across the 37 crates, only `libgit2-sys` matches, so
     the list gains one line saying the read is dormant. Naming it "not covered" instead would be a
     class-2 claim with the same missing argument the draft correctly refused.
  2. **Stale: the scan's unit is the pair (crate, name)** (`entry-points.sh:L55`; the list holds
     "one line per crate and name"). With `libgit2-sys | getenv` listed, any new C `getenv` inside
     `libgit2-sys` matches an existing pair and passes. That covers a new variable after a libgit2
     bump, and a site moving from uncompiled to compiled. The same holds for `libz-sys` if a
     feature flip ever compiles zlib-ng. The draft's QC-30 names four reached reads as members, but
     the command can only tell that `libgit2-sys` reads the environment somewhere. That gap is a
     covered-looking hole, so QC-30 names it as not covered. Its gate is the lockfile change
     reviewed as code (QC-26), with the list's text re-read against the new sources. The list's own
     header already asks for that (`entry-points.allow:L20-L21`, `:L23-L26`), so the entry states an
     existing obligation rather than inventing one. Rust reads have the same granularity, and QC-30
     already accepts it there. It is named for C because `libgit2-sys`'s line, unlike most Rust
     lines on the list, covers reads the shipped process actually makes.

  *Check 3.* The addition contradicts nothing settled. QC-35's third uncovered case already sends
  libgit2's environment reads to QC-30 (`nfdr.md:L843-L844`). ADR-0020 § Consequences cites QC-30
  for the init reads (`adr/0020-…:L100-L101`). QC-9's correction stands as the draft says.

  *Where I came close to another verdict.* **Override: review only**, on the ground that a pattern
  scan at crate granularity proves little for `libgit2-sys`. What tipped it is that the scan still
  fails on the case that matters most: a newly linked crate bringing its first C environment read.
  It also fails on a listed site that disappears. Review stays the gate for what the pairing lets
  through, and the addition is what says so.

## Left for the owner

None this run.

## Skipped

None this run. Sections 1 and 3 of the companion hold no items ("None.").

## Companions opened

None this run.

## Launchers owed

- **`docs/adr/` and `docs/nfdr.md`** — `<CORE>/launchers/skill/launcher.sh product-architecture nozoki`
