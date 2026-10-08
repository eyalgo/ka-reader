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

> **No `product-architecture` run wrote this file.** The PM opened it on 2026-10-03 from the records'
> own companion template. `crates/ka-reader-core/src/fs_reader.rs` now loads its `#[cfg(test)]` module's
> body through `#[path]` from `crates/ka-reader-core/tests/` (`ka-reader@73c408e`), so § 9's
> `checks/structure.sh` scope bullet states a count of such sites the tree no longer has. The NFDR is
> Settled, and with no companion on disk a `product-architecture` re-run reads it as done and has
> nothing to act on. Its one item is in § 3.

---

## 1. Open issues — questions with no answer yet

None.

## 2. Choices to confirm — the Principal Architect drafted a best-effort answer; confirm or override

None.

## 3. Raised from downstream — an item from a seat that did not write these records

### 3.1 § 9's `checks/structure.sh` scope bullet names two `#[cfg(test)]` `#[path]` sites; the tree holds three
- **Raised by:** PM — 2026-10-03
- **Which record:** `nfdr.md` § 9, the `checks/structure.sh` scope bullet
- **Tracked by:** `ka-reader · nemawashi · 2026-10-01_the-tree-is-checked-for-its-shape`
- **What it blocks:** nothing fails; the bullet's account of the test-only sites, which is what makes
  the by-file-path reading safe to check against the tree, is short by one site.
- **Where it shows:** the bullet says "The tree holds two such sites, `crates/ka-reader-core/src/lib.rs:L18-L24`
  and `crates/ka-reader-bridge/src/lib.rs:L10-L16`" and gives their bodies' `std::fs` and `std::process`
  imports as the reason a reading by module would fail the tree (`docs/nfdr.md:L1076-L1082`). A third
  site now exists: `crates/ka-reader-core/src/fs_reader.rs:L894-L896` is a `#[cfg(test)]`
  `#[path = "../tests/unit/fs_reader.rs"]` `mod tests;` (`grep -rn '#\[path' crates/` lists it beside
  the two `lib.rs` sites and `crates/ka-reader-core/tests/walk.rs:L6`, which is a test target, not a
  `src/` declaration). Its body holds two `fs::write` fixture writes
  (`crates/ka-reader-core/tests/unit/fs_reader.rs:L753`, `:L953`), so a reading by module would also add
  a QC-2 finding in `ka-reader-core` to the overreach the bullet lists. The likely fold: name three sites,
  adding `fs_reader`'s `tests` module, and add QC-2 to the findings a reading by module would raise.
  RN-36's "two `#[cfg(test)]` sites" (`docs/nfdr.md:L3384`) is a dated revision note and is left as
  written.
- **If a document has to be written:** none. The § 9 bullet in `nfdr.md`.
- **Answer:** confirmed with addition — fold as drafted, with three things the fold states with it.
  (1) Name three sites, adding `crates/ka-reader-core/src/fs_reader.rs:L894-L896` (`#[cfg(test)]`
  `#[path = "../tests/unit/fs_reader.rs"]` `mod tests;`). The third body does not share the other
  two's imports: it holds no `std::process`, and its filesystem use sits in `fs-reader`, QC-15's
  owner. So "both bodies import `std::fs` and `std::process`" stays a sentence about the two
  `test_support` sites and is not widened to all three. (2) Re-measure the findings list rather than
  adding one name to it. `checks/structure.sh` gained its QC-2 rule at `ka-reader@e7f151e`, in the same
  merge (`ka-reader@73c408e`) that moved the `fs_reader` body. So a reading by module now raises QC-2
  from the core's `test_support` body too (`crates/ka-reader-core/tests/common/mod.rs:L9`, `:L33`,
  `:L47`, `:L55`, `:L57`, `:L65`, `:L81`), and not only from the third body
  (`crates/ka-reader-core/tests/unit/fs_reader.rs:L753`, `:L953`). Measured at `ka-reader@7a8f61d` by
  placing each body where a module reading judges it and running the script: QC-2, QC-9, QC-15 and
  QC-36 in `ka-reader-core`, and QC-15 and QC-36 in `ka-reader-bridge`. (3) Pin the count to the fold's
  commit and name its command, `grep -rn '#\[path' crates/*/src`, which prints exactly the three
  `src/` sites at `ka-reader@7a8f61d`. The next site is then a re-measurement and not a false sentence,
  which is the form § 9's `checks/tests/` bullet already takes for its suite count. RN-36 stays as
  written. Reasoning: `docs/trail/architecture/self_answer-32.md` § 3.1.

**How it closes.** `product-architecture` folds it on its next run like any other item here.
