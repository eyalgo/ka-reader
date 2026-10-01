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
- **Answer:** <the owner fills this in>

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
- **Answer:** <the owner fills this in>

**How it closes.** `product-architecture` folds it on its next run like any other item here.
