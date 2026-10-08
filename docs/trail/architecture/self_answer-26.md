# Self-answer report — `docs/adr/` and `docs/nfdr.md`

## Header

- **Companion:** `docs/architecture_open_issues.md`
- **Document:** `docs/adr/` and `docs/nfdr.md`. The NFDR is v24 and Settled (`docs/nfdr.md:L3-L5`).
  No `product-architecture` run wrote this companion. The PM opened it at `ka-reader@b15a89a` with one
  item, § 3.1, raised from downstream.
- **Decided by:** `decide_companion_answers.md` v1.3.0
- **Date:** 2026-10-01
- **Sources re-read:** One. The Cargo reference,
  https://doc.rust-lang.org/cargo/reference/cargo-targets.html, *Integration tests*, re-read
  2026-10-01. It says "Cargo will compile each of these files as a separate crate" and
  "Integration tests can use the public API of the package's library." The NFDR's § 9 already cites
  this page for the first sentence, read 2026-09-19. The page still says it.

## Items worked

### 3.1 — QC-14 does not say whether a `ka-reader-core` test target that compiles harness source counts as "a dependency of `ka-reader-core`"

- **Bucket:** 3. Raised from downstream — an item from a seat that did not write these records
- **Verdict:** answered
- **Why:** The site conforms. QC-14 means a dependency of each unit *as it ships*, and a test
  target is not part of a shipped unit. `checks/structure.sh` does not treat the test target's
  `#[path]` into `checks/` as a dependency.

  *Seat.* The edit goes into QC-14's first clause, in `nfdr.md`, which is this companion's
  document. The answer commits no person, outside party or risk. It decides only what one
  constraint means. I can name no ground I cannot see. So I answered it in the owner's seat, and the
  item carries no draft to confirm, which makes the verdict **answered**. The item is not a widening
  without an occurrence. It cites one: `crates/ka-reader-core/tests/walk.rs:L6-L7`, opened this run and
  found as cited.

  *Is the question sound?* Yes, with one correction to how it is framed. The item says QC-14 has
  "no shipped/unshipped distinction". The qualifier is in fact missing only from QC-14's own words.
  Both sources QC-14 traces to carry it. ADR-0016 says `checks/` "is never a dependency of a shipped
  unit" (`docs/adr/0016-physical-unit-set-core-bridge-mac-checks.md:L40-L41`). SDD § 3
  `read-only-harness` says it must not own "Being a dependency of any shipped unit"
  (`docs/SDD.md:L332`). QC-14 lost the qualifier when it was transcribed. When an entry and the
  record it traces to disagree, the entry is the copy, so this is a correction and not a choice
  between two live readings. The item also asks what the § 10 row should say. The same seat owns
  that, and it gets the same answer, so the item is one question and does not split.

  *Does it contradict anything settled? No, and three settled facts support it.*
  1. **The records above.** ADR-0016 and SDD § 3 say "shipped unit", as quoted.
  2. **The direction of the dependency.** Cargo compiles each file under `tests/` "as a separate
     crate" that "can use the public API of the package's library" (re-read at source, see the
     header). So `crates/ka-reader-core/tests/walk.rs` is its own crate that depends on
     `ka-reader-core`. `checks/walk.rs` is compiled into that crate and imports only `ka_reader_core`'s
     public items (`checks/walk.rs:L20`: `use ka_reader_core::{EntryKind, ItemState, OpenedFolder,
     list_tree, open_folder, select_file};`). That is `checks/` importing `ka-reader-core`, which is
     the direction QC-14's first clause explicitly allows. The library itself compiles no file of
     `checks/`. QC-14's own first command confirms it:
     `cargo tree --manifest-path Cargo.toml --offline --locked -p ka-reader-bridge | grep -ci checks`
     prints `0` (run 2026-10-01). The test target is declared `harness = false` under
     `[[test]] name = "walk"` (`crates/ka-reader-core/Cargo.toml:L23-L25`). It is a test target,
     and the shipped library does not contain it.
  3. **§ 9's scope bullet.** It already keeps `crates/*/tests/` out of every rule of
     `checks/structure.sh`, binding "every other rule of the script alike"
     (`docs/nfdr.md:L1001-L1016`). QC-14's `structure.sh` half is one of those rules. Without this
     answer, the first `structure.sh` written to QC-14's literal words would have had to
     contradict § 9 to fail this tree.

  *What the fold should do.* Restore the qualifier in QC-14's first clause: "never a dependency of
  any shipped unit — the `ka-reader-core` library, the `ka-reader-bridge` static library, the
  `ka-reader-mac` executable". Keep the traces to ADR-0016 and SDD § 3. The § 10 row
  (`docs/nfdr.md:L1204`) needs no new command, because its commands already read only what ships.
  No `QC` is added and no record moves.

  *Failure paths.*
  - **Absent:** a `#[path]` or `include!` from a shipped source under `src/` into `checks/` would
    really make `checks/` a dependency of a shipped unit and break QC-14. No such site exists. Today
    `grep -rn '#\[path' crates/` finds only this test target and two `#[cfg(test)]` sites into
    `tests/common/` (`crates/ka-reader-core/src/lib.rs:L18-L19`,
    `crates/ka-reader-bridge/src/lib.rs:L10-L11`). Neither is compiled into the shipped library. No
    grep rule is owed for that case until a site occurs. I named it in the slot so it is not read
    as covered.
  - **Stale:** the walk could move out of `tests/`, for example to `src/bin/`, which `structure.sh`
    reads. It would then fall inside the script's scope and be judged as a source file. The
    shipped-unit reading still decides whether its `#[path]` breaks QC-14. Nothing in this answer
    needs to change in that case.
  - **Empty, concurrent, refused:** none applies. The question is about what a static constraint
    means, not about anything that runs.

  *What would have tipped me another way:* the item would have been the owner's if ADR-0016 or the
  SDD had said "never a dependency of the unit or any of its targets". Then QC-14's reading would
  have been a choice between two records. Neither says that.

## Left for the owner

None this run.

## Skipped

None this run.

*Seen and not raised.* There are two, and neither meets the bar for reopening a settled document.
(1) RN-19 cites `crates/ka-reader-core/tests/walk.rs:L66` for a `std::env::args` site
(`docs/nfdr.md:L1870`). The file now has 11 lines, because the walk moved to `checks/walk.rs` at
`ka-reader@f823adc`. A Review Note is a dated record of what one fold measured, so it is history and
not a present-tense claim. (2) § 9 says the tree holds no site where shipped code pulls in a
file from `tests/` through `#[path]` (`docs/nfdr.md:L1021-L1023`). The two `#[cfg(test)]` sites
above do point into `tests/common/`. The core site existed when RN-19 wrote that sentence: it was
added at `ka-reader@233e7eb`, which is an ancestor of `ka-reader@e0edd37`, the v8 fold. RN-19's writer
therefore read `#[cfg(test)]` code as not shipped. That reading is still true, so the sentence is
not false.

## Companions opened

None this run.

## Launchers owed

- **`docs/adr/` and `docs/nfdr.md`** — `<CORE>/launchers/skill/launcher.sh product-architecture ka-reader`
