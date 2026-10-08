# Self-answer report — `adr/` and `nfdr.md`

## Header

- **Companion:** /Users/eyalgolan/products/ka-reader/docs/architecture_open_issues.md
- **Document:** `adr/` and `nfdr.md` (`docs/adr/`, `docs/nfdr.md`) — the companion's own header names both
- **Decided by:** `decide_companion_answers.md` v1.3.0
- **Date:** 2026-09-19
- **Sources re-read:**
  - The `log` crate's `set_logger` page (https://docs.rs/log/latest/log/fn.set_logger.html), read
    2026-09-19. It says the function "Sets the global logger to a `&'static Log`", that it "may
    only be called once in the lifetime of a program", and that "An error is returned if a logger
    has already been set." Item 3.2 rests on this.
  - The Cargo reference, *Cargo Targets* § Integration tests
    (https://doc.rust-lang.org/cargo/reference/cargo-targets.html), read 2026-09-19. It says "Files
    located under the `tests` directory are integration tests. When you run `cargo test`, Cargo
    will compile each of these files as a separate crate, and execute them", and that shared code
    goes in "a separate module such as `tests/common/mod.rs`". Item 3.2 rests on this.
  - Item 3.1 rests on no source outside the repository. It rests on `docs/SDD.md` at v7, read at
    the lines its entry names.

## Items worked

### 3.1 — QC-24's set equality names the whole command list, and the tree's check holds the commands built so far

- **Bucket:** 3. Raised from downstream — an item from a seat that did not write these records
- **Verdict:** confirmed with addition
- **Why:** QC-24 is re-derived from the SDD's C-R7 as it reads at v7, which is what the PM's lean
  proposed. The item sits in the raised-from-downstream bucket and carries a lean, so the lean was
  weighed as a draft.

  *Whose it is.* The edit lands in `docs/nfdr.md` QC-24, which is this companion's own record. The
  answer binds nothing but that entry's agreement with the SDD. No person, outside party or
  reserved taste is involved, so it is answered in the owner's seat.

  *The item waited on an SDD item, and that item is closed.* The item says what is owed is
  "re-derived from whatever C-R7 settles in `SDD_open_issues.md` § 5.1". That companion was
  answered at `ka-reader@d9ffe66` and folded at `ka-reader@c1f8a20`, both after this item was written
  (`ka-reader@07beb5b`). `docs/SDD.md` is Settled at v7 (`docs/SDD.md:L3`, `:L9`), and
  `docs/SDD_open_issues.md` is no longer on disk (`ls docs/*_open_issues.md` prints
  `docs/architecture_open_issues.md` alone).

  *Why this is a derivation and not a call.* The SDD fixes the relation between the two stores:
  "the § 4 statement wins and the NFDR entry is re-derived" (`docs/SDD.md:L408`). C-R7 now says "A
  build grants the renderer exactly the commands its landed slices register", that the set "is
  always inside SM-4's list", that "From `v1.0.0` the set is SM-4's list whole", and that the check
  "reads the registered set and never a hand-kept copy of it" (`docs/SDD.md:L486-L492`). RN-47 says
  QC-24 "still states the whole list and is the Principal Architect's to bring into line"
  (`docs/SDD.md:L2614-L2615`). Two architects reading C-R7 at v7 write the same entry.

  *Not a widening that waits.* The item asks QC-24 to state staging it does not state now. It is a
  correction that follows an upstream sentence, and it cites a site in the product:
  `crates/ka-reader-app/capabilities/main.json:L5` grants two commands, confirmed this run. So the
  prompt's "not until it occurs" answer does not apply.

  *What the answer adds to the lean.* The lean said "set equality against the commands the built
  slices register, plus the asset scheme once its form is settled". Five things it did not say,
  each from C-R7 or from a failure path:
  1. The check reads the registered set and never a hand-kept copy. This is C-R7's sentence, and
     it matters because the test as built holds two hand-kept constants
     (`crates/ka-reader-app/tests/config.rs:L228`, `:L231`). The test passes today and does not meet
     the re-derived tail. The answer says so, the way RN-18 said `checks/bundle.sh` was red against
     QC-25 (`docs/nfdr.md:L1160-L1163`), so a delivery reader does not take a green test for a met
     entry.
  2. The granted set is held inside SM-4's list, and from `v1.0.0` it is the list whole, where
     QC-59's pin already reads the capability file's command list (`docs/nfdr.md:L550-L555`).
  3. The case the staged check does not cover: before `v1.0.0`, a change that stops registering a
     built command passes. C-R7 names it "so it is not read as coverage" (RN-47), and an entry that
     dropped it would claim more than the check holds.
  4. The asset scheme is keyed on C-R7's placeholder state, the same key QC-23 uses
     (`docs/nfdr.md:L191-L200`). QC-24 says when the scheme enters and not where its grant is
     written, because where is open in the SDD (`docs/SDD.md:L2644`).
  5. A registered set the test cannot read fails the test. This clause is this run's own and goes
     beyond C-R7's words. It is the absent case: a check that reads a set has to say what an
     unreadable set means, and a pass would be the silent one. QC-30's tail already takes this
     form for a crate it cannot scan (`docs/nfdr.md:L280-L282`).

  *Checked against the settled record.* No ADR states a whole-list grant (`grep -n 'open_folder'
  docs/adr/*.md` prints nothing, and `grep -n 'command list'` finds "the closed command list the
  host registers" at `docs/adr/0002-tauri-2-rust-host-wkwebview-renderer.md:L45`, which holds
  under staging). So no record is superseded. QC-1 and QC-34 name "the closed IPC command list"
  and "the commands and the scheme QC-24 names" (`docs/nfdr.md:L50-L51`, `:L320-L321`), and both
  stay true. § 10's row (`docs/nfdr.md:L641`) names the command and not the mechanism, so it
  stands, although the item named it as owed.

  *Failure paths.* Empty: a host that registers nothing meets set equality on two empty sets. It
  does not arise, because the first slice registers two commands. Concurrent: two slices that each
  register a command apart from one another "meet at one set when their changes are joined"
  (`docs/SDD.md:L492-L493`). Stale and absent are additions 1 and 5 above.

  *Seen and not raised.* QC-2's tail says `checks/read-only.sh` runs "after every IPC command"
  (`docs/nfdr.md:L56-L57`), and C-I3 now says "every command the build grants"
  (`docs/SDD.md:L526-L527`). For any one build the two name the same commands, so nothing is false.
  The fold reads it with the rest of the SDD's v6 → v7 move.

  *What would have tipped it.* Had C-R7 still read as it did when the item was written, the answer
  would have been the same lean held on the PM's reasoning alone, and the verdict would have
  waited on the SDD. It did not have to.

### 3.2 — QC-61's `structure.sh` check reaches test binaries that must install a logger

- **Bucket:** 3. Raised from downstream — an item from a seat that did not write these records
- **Verdict:** confirmed with addition
- **Why:** The PM's lean is taken for QC-61, and the answer adds that the scope belongs to
  `checks/structure.sh` as a whole, because the tree holds the same kind of site against four more
  of the script's rules. The item carries a lean, so the lean was weighed as a draft.

  *Whose it is.* The edit lands in `docs/nfdr.md`. QC-61's check is this document's own
  realization, answered in the owner's seat at `docs/trail/architecture/cycle-2.md` § 1.1
  (`docs/nfdr.md:L485`), and no upstream document states it. The answer binds only what a script
  in this repository scans. It is answered in the owner's seat.

  *Why the lean holds, and for the reason it gives.* QC-61's property is that the logger is
  "installed once at startup in `ka-reader-app`, the composition root" (`docs/nfdr.md:L467-L468`).
  The check says `log::set_logger` and `log::set_boxed_logger` "appear only in `ka-reader-app`"
  (`docs/nfdr.md:L480-L481`) and states no scope. The tree at `ka-reader@1741429` holds
  `crates/ka-reader-core/tests/failure_log.rs:L52` and
  `crates/ka-reader-core/tests/failure_log_kinds.rs:L61`, confirmed this run, and each test installs
  a capturing logger to assert on `ka-reader-core`'s warn line. Two outside facts carry the lean, and
  both were re-read at their source. Cargo compiles each file under `tests/` "as a separate crate",
  so these binaries are never the shipped process. `set_logger` sets "the global logger" and "may
  only be called once in the lifetime of a program", so a test cannot observe a log line except by
  installing a logger in its own binary. The check overreached the property. Narrowing it relaxes
  nothing the property protects: `grep -rn 'set_logger\|set_boxed_logger' crates/` finds the one
  shipped site at `crates/ka-reader-app/src/log_writer.rs:L142` and none under
  `crates/ka-reader-core/src/`.

  *Not a widening that waits.* The item cites two sites in the product, by path and line. A check
  that fails a correct tree is a statement found false, which is a correction.

  *The addition, and why it sits in this answer.* Check 4 on the lean found the case it did not
  serve. `checks/structure.sh` is one script (`docs/nfdr.md:L598`), and four more of its rules
  name a crate and state no scope. The tree holds a test-target site against each:
  - QC-2, *no write API in `ka-reader-core` outside `own-state`* (`docs/nfdr.md:L58`):
    `crates/ka-reader-core/tests/common/mod.rs:L57`, `fs::write` building a fixture.
  - QC-9, *`ka-reader-core` must not import `std::process`* (`docs/nfdr.md:L98-L99`), the rule QC-7's
    tail shares (`docs/nfdr.md:L85`): `crates/ka-reader-core/tests/common/mod.rs:L11`, used for
    `process::id()` in a temporary folder's name (`:L29`).
  - QC-13, *`ka-reader-app` must not import `std::fs` outside its log module*
    (`docs/nfdr.md:L115-L116`): `crates/ka-reader-app/tests/config.rs:L11`. That file is the test
    QC-23, QC-24 and QC-36 name, and it has to read `tauri.conf.json` and the capability file.
  - QC-30 half (1), *no `std::env::args` in the product's own crates* (`docs/nfdr.md:L275-L276`):
    `crates/ka-reader-core/tests/walk.rs:L66`. That file is the driver `checks/read-only.sh` runs
    (`checks/read-only.sh:L88`), and it takes the fixture path as its argument.

  Each of those properties is about shipped code, for the same reason QC-61's is. If the fold wrote
  the scope into QC-61 alone, a cold reader would take the contrast to mean the other rules do
  reach test targets, and the first `checks/structure.sh` written to the words would fail the tree
  on four rules where today it fails on one. So the answer states the scope once, where § 9
  describes the script. It keeps the one rule that reads `crates/*/tests/` on purpose: no
  `CARGO_BIN_EXE_` reference there (`docs/nfdr.md:L611-L613`). The previous round set the
  precedent for an answer reaching sibling entries that carry the same defect: the item on QC-30
  moved QC-58 and QC-61 with it (`docs/nfdr.md:L1177`).

  *What would have tipped it.* This was close to a different shape: answer QC-61 alone, and raise
  the script-wide scope as a new item on this companion for the next round. Two things decided
  against it. The item's own subject is that `structure.sh` reaches test binaries, which the PM
  narrowed to the one rule they had met, so the wider scope is the item's question and not a
  change no item raised. And a second round would have the fold write QC-61's scope at one version
  and the script's at the next, for one fact. **The owner can overturn the addition alone:** strike
  the answer's paragraph headed *The addition*, and QC-61's scope stands by itself.

  *Failure paths, each named in the slot so it is not read as coverage.* A `#[cfg(test)]` module
  inside `src/` stays inside every rule. The tree holds no such site that breaks one
  (`grep -rn 'fs::write\|set_logger' crates/*/src/` finds only the log module), so nothing is
  decided for it. `crates/ka-reader-app/build.rs` and any later `benches/` or `examples/` are not
  excluded, because no site needs them to be. Shipped code that includes a file from `tests/`
  through a `#[path]` attribute would escape the rules, and that is left as a review catch, with
  no grep rule invented for it.

  *Checked against the settled record.* No ADR names `set_logger`
  (`grep -n 'set_logger' docs/adr/*.md` prints nothing), so no record moves. § 10's row for QC-61
  (`docs/nfdr.md:L668`) names the two scripts and stands, although the item named it as owed.
  `checks/structure.sh` is not in the tree (`ls checks/` prints `bundle.sh`, `fixtures`,
  `own-state.sh`, `read-only.sh`, `tests`), so no built script is made wrong by this answer. It is
  consistent with item 3.1's answer: `crates/ka-reader-app/tests/config.rs` is the test 3.1 asks to
  read the registered set, and it can only do that from outside the rules QC-13 states.

  *The item's supporting text, one correction.* It says a script that follows the words "fails on
  the tree as it stands". That is right about the words. No such script exists yet, so nothing
  fails today.

## Left for the owner

None this run.

## Skipped

None this run. The companion holds two items, both under § 3, and both had their **Answer** slot
at its placeholder. No slot was already filled, and no item is addressed to the producing skill.

## Companions opened

None this run.

## Launchers owed

- **`adr/` and `nfdr.md`** — `/Users/eyalgolan/projects/kensai/kensaiapp-dev/core/launchers/skill/launcher.sh product-architecture ka-reader`
