# Self-answer report — `docs/adr/` and `docs/nfdr.md`

## Header

- **Companion:** `docs/architecture_open_issues.md`
- **Document:** `docs/adr/` and `docs/nfdr.md`. The NFDR is v22 and Settled (`docs/nfdr.md:L3-L5`).
  The PM opened the companion on 2026-10-01 at `nozoki@438279b` with two items in § 3.
- **Decided by:** `decide_companion_answers.md` v1.3.0
- **Date:** 2026-10-01
- **Sources re-read:** Cargo's manifest reference, § The `build` field
  (https://doc.rust-lang.org/cargo/reference/manifest.html, read 2026-10-01). It says: "The default
  is `"build.rs"`, which loads the script from a file named `build.rs` in the root of the package.
  Use `build = "custom_build_name.rs"` to specify a path to a different file or `build = false` to
  disable automatic detection of the build script." § 3.2's answer rests on this. The local Cargo
  registry copies at the versions `Cargo.lock` resolves were also read, but they are this machine's
  copies of the sources, not a published claim.

## Items worked

### 3.1 — QC-3 still calls the one-time review of the 17 names owed, and the review is recorded

- **Bucket:** 3. Raised from downstream — an item from a seat that did not write these records
- **Verdict:** confirmed with addition
- **Why:** The item proposes an answer ("QC-3 should say that the review is recorded…"), so I weighed
  it as a draft. It holds, with three additions.

  *Seat.* The change lands in QC-3's tail in `nfdr.md`. That is this companion's document, and it
  commits no person, money or risk, so it is answered in the owner's seat. It corrects a statement
  that has become false. It does not widen the document, so "not until it occurs" does not apply.

  *Is the record the review QC-3 asks for?* This is where the round turned. A previous round
  (`docs/trail/architecture/cycle-11.md` § 3.2, carried at RN-25, `docs/nfdr.md:L2480-L2487`)
  refused to call a name-only reading the review. QC-3 defines the review as judging each name "in
  the features the lockfile resolves", read with `cargo tree --offline --locked -e features -i
  <crate>` (`docs/nfdr.md:L105-L108`). So I read `checks/deps.review.md` whole instead of trusting the
  item. Each of its 40 rows names that command and the features it resolves. Each row also scans the
  registry copy at the locked version and reads any hit in place. For example, `rustix` resolves only
  `fs`, and `src/net/` is behind `#[cfg(feature = "net")]` at `src/lib.rs:L245`. I re-ran both this
  round: `cargo tree --offline --locked -e features -i rustix` shows `rustix feature "fs"` only, and
  line 245 of the registry copy is that `cfg`. Its coverage holds too: `comm -3` of the record's names
  against the `cargo:` section of `checks/deps.allow` printed nothing. `bash checks/no-network.sh`
  printed "ok — 40 cargo names match checks/deps.allow" and exited 0.
  `git merge-base --is-ancestor 85d9fa7 main` succeeds. `git show --stat 85d9fa7` lists
  `Cargo.lock`, `checks/deps.allow`, `checks/deps.review.md` and `crates/nozoki-core/Cargo.toml`. So
  "the change that first realizes this half … records that review as code in the same change"
  (`:L120-L122`) has happened, and "still owed" (`:L120`) is false.

  *Addition 1 (the stale case).* The record calls itself a review of "every name on
  `checks/deps.allow`" (`checks/deps.review.md:L1`). That stops being true the first time a name is
  added. QC-3 should cite it pinned to `nozoki@85d9fa7`, as QC-25 pins `checks/bundle.sh`. A later
  addition is reviewed under the second half at `development-design`, as the entry already says.
  Nothing upstream requires the record to grow a row per later name, so the fold should not make it.

  *Addition 2.* The clause "At `nozoki@0aca57e` the list is one `cargo:` section of 17 names"
  (`:L112-L113`) is pinned to a commit and still true. It stays as history, with the current count
  beside it. The item's "If a document has to be written" field ("the list's count") could be read as
  rewriting it.

  *Addition 3.* The item names RN-25's note (`:L2487`, `:L2491`) as a place the claim shows. RN-25 is
  the dated record of v14. The NFDR's own practice, stated at RN-18, is that dated mentions in earlier
  notes stay as written. The fold records the closure in its own new review note and does not edit
  RN-25.

  *What would have changed my verdict:* if the record had read names only, without
  `-e features`, I would have overridden the item and kept "still owed". It does not.

### 3.2 — QC-30's registry scan excepts a crate's root `build.rs`, and the tree's build scripts are not all at the root

- **Bucket:** 3. Raised from downstream — an item from a seat that did not write these records
- **Verdict:** confirmed with addition
- **Why:** The item proposes an answer ("The exception should name the package's build script…"), so I
  weighed it as a draft. It is right, and it is right for the reason it gives.

  *Seat.* It lands in QC-30 half (2) in `nfdr.md`. It is internal to the document, so it is answered
  in the owner's seat. It corrects a wrong path rather than widening anything: the exception exists
  for build-time code (§ 9, `docs/nfdr.md:L972-L976`), and "root `build.rs`" names that code wrongly.

  *Checked at the source.* Cargo's reference says `build.rs` at the root is only the default, that the
  `build` key can name another file, and that `build = false` turns detection off (Header, Sources
  re-read). The item's citations reproduce in the registry copies: `tree-sitter-0.27.0/Cargo.toml`
  line 21 is `build = "binding_rust/build.rs"`. That file holds 6 `env::var` reads, and the package
  has no root `build.rs`. `tree-sitter-python-0.25.0/Cargo.toml` line 20 is
  `build = "bindings/rust/build.rs"`. So a scanner written to the entry as it reads would put
  `tree-sitter`'s six build-time reads (`OUT_DIR`, `TARGET`, `CARGO_FEATURE_WASM`, …) on
  `checks/entry-points.allow`, a list that claims to describe the shipped process. The correction
  matters for whether that list is true, not only for whether the build is green.

  *What the whole tree does (check 4).* I measured every crate that QC-30's own command
  (`cargo tree -p nozoki-bridge --target aarch64-apple-darwin -e normal --locked`, with `--offline`)
  resolves: 34 crates. 2 are the workspace's own (see § 2.1 below). Of the 32 registry crates, 17 name
  a script in `build` (10 at the root, 7 under a subdirectory), 14 set `build = false`, and
  `streaming-iterator` 0.1.9 sets no key and has no root `build.rs`. So the default case, a missing
  key, does occur, which is why the wording must say "`build.rs` by default" and not only "the key".

  *Addition 1 (empty/absent).* Where `build = false`, or the default file is missing, nothing is
  excepted. A file called `build.rs` that Cargo never compiles is not build-time code.

  *Addition 2 (contradiction with the document's own text).* § 9's `checks/structure.sh` bullet repeats
  the root-only reading: "the ground QC-30's second half already takes for a dependency's root
  `build.rs`" (`docs/nfdr.md:L975-L976`). It has to change with QC-30, or the two read differently.
  RN-24's matching sentence (`:L2330-L2331`) is dated history and stays.

  *Addition 3 (narrowing).* The item names the § 10 row for `checks/entry-points.sh` as a place the
  change lands. That row (`docs/nfdr.md:L1187`) reads "the linked tree's environment and argument
  reads, against the reviewed list" and does not mention build scripts, so it does not change.

  *Not covered, named.* A build script can pull in other files through `mod`, `#[path]` or
  `include!`. "The build script" read as one file would leave those files in the scan. That fails loud
  (a read not on the list fails the build), not silent. Grepping each of the 17 scripts for those three
  forms (all 17 opened) printed nothing, so no crate in the tree does this. Under the prompt's rule that a case waits
  until it occurs, the answer names the case and does not widen the entry.

  *Seen and not raised.* The scan also reads proc-macro crates (`syn`, `quote`, `proc-macro2`,
  `serde_derive`, `thiserror-impl`), whose code runs at compile time. `syn` 3.0.6 has one textual hit,
  a doc comment (`src/file.rs:L27`, `///     let mut args = env::args();`). RN-18 already leaves
  sorting such hits to whoever writes the first `checks/entry-points.allow`, so it is not raised again.

## Left for the owner

None this run.

## Skipped

None this run.

## Raised on this document

### 2.1 — QC-30 half (2) scans every crate its `cargo tree` command names, and that command names the product's own two crates, which have no registry copy

- **What the document is owed:** QC-30 half (2) should scan only the crates the command resolves from
  outside the workspace, keyed on workspace membership. `nozoki-core` and `nozoki-bridge` are already
  half (1)'s.
- **Why it is worth a cycle:** On the ground `decide_companion_answers.md` § *The items are not the
  whole of what a document is owed* calls "a fact in it is now false", read here as a statement that
  cannot be carried out as written. The entry scans "for every crate the `cargo tree` command above
  names, … the crate's whole package directory in the Cargo registry", and fails "on any resolved
  crate whose sources it cannot open" (`docs/nfdr.md:L572-L577`). The command, run 2026-10-01 with
  `--offline` added, names `nozoki-bridge v0.0.0 (/Users/eyalgolan/products/nozoki/crates/nozoki-bridge)`
  and `nozoki-core v0.0.0 (/Users/eyalgolan/products/nozoki/crates/nozoki-core)`. Neither has a
  registry copy. So a script written to the words fails on every build. That blocks
  `checks/entry-points.sh`, the same script § 3.2 is about, and `ls checks/entry-points*` finds
  nothing yet, so this is the cheapest moment to fix it. The intent is clear from half (2)'s own
  heading, "The linked dependency tree", and from half (1) covering the two crates
  (`:L556-L557`). The words are the defect. The fold that takes § 3.2 re-cuts the same sentence, so
  this costs the round almost nothing extra. I raised it rather than adding it to § 3.2's answer
  because it is a separate question about the same half: which crates are scanned, not which files in
  them are excepted.

## Companions opened

None this run.

## Launchers owed

- **`docs/adr/` and `docs/nfdr.md`** — `<CORE>/launchers/skill/launcher.sh product-architecture nozoki`
