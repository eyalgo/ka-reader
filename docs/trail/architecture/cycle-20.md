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

> **No `product-architecture` run wrote this file.** The PM opened it on 2026-10-01 from the records'
> own companion template, while re-reading the route after the grammar engine was first built, because
> the NFDR is Settled and with no companion on disk a `product-architecture` re-run reads it as done and
> has nothing to act on. Both items are in § 3. § 3.1 pairs with `docs/SDD_open_issues.md` § 5.1, which
> asks the SDD to close its engine question on the same record.

---

## 1. Open issues — questions with no answer yet

None.

## 2. Choices to confirm — the Principal Architect drafted a best-effort answer; confirm or override

None.

> **No `product-architecture` run wrote § 2.1, and the "None." above is from before it was added.** A
> `companion-self-answer` run added it on 2026-10-01 while answering §§ 3.1 and 3.2
> (`docs/trail/architecture/self_answer-24.md`, § Raised on this document). No item raised it. It
> turned up while measuring every crate QC-30 half (2)'s `cargo tree` command resolves, for § 3.2. It
> sits in this bucket because the run holds a lean, and its slot is for the next round to fill.

### 2.1 QC-30 half (2) scans every crate its `cargo tree` command names, and that command names the product's own two crates, which have no registry copy
- **Lands in:** `nfdr.md` QC-30, *verified by*, half (2)
- **Drafted into the records:** Nothing. No producing run wrote this, and the run that raised it writes
  no record. The proposed change: half (2) scans only the crates the command resolves from outside
  the workspace. `nozoki-core` and `nozoki-bridge` are half (1)'s, so half (2) skips them. The skip is
  keyed on workspace membership, not on a list of names. Any other crate whose sources cannot be
  opened still fails the build, as the entry says now.
- **Rationale:** The entry says half (2) scans "for every crate the `cargo tree` command above
  names, … the crate's whole package directory in the Cargo registry", and fails "on any resolved
  crate whose sources it cannot open" (`docs/nfdr.md:L572-L577`). The command, run this round with
  `--offline` added, names `nozoki-bridge v0.0.0 (…/crates/nozoki-bridge)` and `nozoki-core v0.0.0
  (…/crates/nozoki-core)`. Neither has a registry copy. So a `checks/entry-points.sh` written to the
  entry as it reads fails on every build, before it reads a single dependency. That blocks the same
  script § 3.2 blocks. The two crates are already covered: half (1) names them as "the product's own
  units" (`:L556-L557`) and checks them with `checks/structure.sh`, under § 9's scope, which leaves out
  each crate's build script. The intent is plain from "**(2) The linked dependency tree**". The entry's
  words are what is wrong, and a developer writing the script from them has to guess.
- **If overridden:** Half (2) stays as it reads, and `checks/entry-points.sh` either fails on the two
  product crates or skips them without any entry saying it may. Skipping silently is the kind of pass
  the entry forbids. Nothing else in the records moves either way.
- **Confirm or override:** <"confirm", or "override: <what to do instead>">

## 3. Raised from downstream — an item from a seat that did not write these records

### 3.1 QC-3 still calls the one-time review of the 17 names owed, and the review is recorded
- **Raised by:** PM — 2026-10-01
- **Which record:** `nfdr.md` QC-3 (the second half's tail) and RN-25's carried note
- **Tracked by:** `nozoki · nemawashi · 2026-10-01_a-file-reads-in-the-panel`
- **What it blocks:** nothing is blocked. QC-3 states as owed a review that is now on the tree, so a
  reader of § 1.1 is sent to do work that is done.
- **Where it shows:** QC-3 reads "So the one-time review is still owed, over those 17"
  (`docs/nfdr.md:L120`) and gives the list as "one `cargo:` section of 17 names" (`:L112-L113`), and
  RN-25's note repeats it (`:L2487`, `:L2491`). `checks/deps.review.md` now records the review as code, landed in
  one commit with `checks/deps.allow` and `Cargo.lock` (`nozoki@85d9fa7`). It covers every name on the
  list at that commit: the 17, the three added at `nozoki@21589c7` (`bitflags`, `errno`, `rustix`), and
  20 the grammar engine brings (`tree-sitter` and its grammars, `cc`, the `regex` family and their
  dependencies). `bash checks/no-network.sh` prints "ok — 40 cargo names match checks/deps.allow". QC-3
  should say that the review is recorded at `checks/deps.review.md`, over every name on the list when
  it landed, and that every later addition is reviewed under the second half as usual.
- **If a document has to be written:** none. QC-3's tail and the list's count.
- **Answer:** Take the change as raised, with three additions. QC-3's tail stops saying the one-time
  review is owed and says it is recorded at `checks/deps.review.md`, landed at `nozoki@85d9fa7` with
  `checks/deps.allow` and `Cargo.lock`, over all 40 names on the list at that commit, and that every
  later addition is reviewed under the second half as before. The record is the review QC-3 asks for,
  not a name-only reading: each row reads `cargo tree --offline --locked -e features -i <crate>` and the
  registry copy at the locked version, and `comm` of its names against the list prints nothing (re-run
  this round). (1) Pin the record to `nozoki@85d9fa7` when citing it. Its own title says "every name on
  `checks/deps.allow`", which stops being true the next time a name is added. (2) Keep the dated clause
  "At `nozoki@0aca57e` the list is one `cargo:` section of 17 names". It is still true as history; add
  the current count beside it. (3) Leave RN-25 alone. A review note is a dated record of its own
  version, and RN-18 sets the rule that dated mentions stay as written. The fold records the closure in
  its own new review note. Reasoning: `docs/trail/architecture/self_answer-24.md` § 3.1.

### 3.2 QC-30's registry scan excepts a crate's root `build.rs`, and the tree's build scripts are not all at the root
- **Raised by:** PM — 2026-10-01
- **Which record:** `nfdr.md` QC-30, *verified by*, half (2)
- **Tracked by:** `nozoki · nemawashi · 2026-10-01_the-tree-is-checked-for-its-shape`
- **What it blocks:** `checks/entry-points.sh` is not written yet. Written to QC-30 as it reads, it
  fails on a build script's own reads, which run at build time and are not an entry point of the
  shipped unit.
- **Where it shows:** half (2) scans "the crate's whole package directory in the Cargo registry — its
  root `build.rs` excepted" (`docs/nfdr.md:L572-L573`). A crate names its build script in its
  manifest's `build` key, and `build.rs` at the root is only the default. `tree-sitter` 0.27.0 sets
  `build = "binding_rust/build.rs"` (`Cargo.toml:L21` of its registry copy), and that file holds six
  `env::var` reads (`grep -c 'env::var'` → `6`). Each grammar crate sets `build = "bindings/rust/build.rs"`
  (for example `tree-sitter-python` 0.25.0, `Cargo.toml:L20`). The exception should name the
  package's build script, which is the path the manifest's `build` key names and `build.rs` by
  default, not the root file alone.
- **If a document has to be written:** none. QC-30's half (2), and the § 10 row that names
  `checks/entry-points.sh`.
- **Answer:** Take the change as raised, with three additions. The exception names the package's build
  script: the file the `build` key in that registry copy's `Cargo.toml` names, at the version the lock
  resolves. Cargo's own reference says the default is `build.rs` at the package root, that another
  path can be named instead, and that `build = false` turns detection off
  (https://doc.rust-lang.org/cargo/reference/manifest.html, § The `build` field, re-read this round).
  Measured on the tree this round, over the 32 registry crates the command resolves: 17 name a script
  (`tree-sitter` → `binding_rust/build.rs`, six reads; the six grammars → `bindings/rust/build.rs`), 14
  set `false`, and `streaming-iterator` sets no key and has no root `build.rs`, so the default finds no
  script there. (1) Where `build = false`, or the default file is absent, nothing is excepted. (2) The
  same root-only wording is in § 9's `checks/structure.sh` bullet ("QC-30's second half already takes
  for a dependency's root `build.rs`", `docs/nfdr.md:L975-L976`) and changes with it. RN-24's mention
  is dated history and stays. (3) Narrowing: the § 10 row does not carry the exception, so it does not
  change. Not covered, and named: a build script that pulls in other files through `mod`, `#[path]` or
  `include!` has those files scanned. That fails loud, not silent, and none in the tree does it (scan
  of all 17 scripts, this round), so it waits until it happens. Reasoning:
  `docs/trail/architecture/self_answer-24.md` § 3.2.

**How it closes.** `product-architecture` folds it on its next run like any other item here.
