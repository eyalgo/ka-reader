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

> **No `product-architecture` run wrote this file.** The PM opened it on 2026-10-03 from the records'
> own companion template. `crates/nozoki-core/src/fs_reader.rs` now loads its `#[cfg(test)]` module's
> body through `#[path]` from `crates/nozoki-core/tests/` (`nozoki@73c408e`), so § 9's
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
- **Tracked by:** `nozoki · nemawashi · 2026-10-01_the-tree-is-checked-for-its-shape`
- **What it blocks:** nothing fails; the bullet's account of the test-only sites, which is what makes
  the by-file-path reading safe to check against the tree, is short by one site.
- **Where it shows:** the bullet says "The tree holds two such sites, `crates/nozoki-core/src/lib.rs:L18-L24`
  and `crates/nozoki-bridge/src/lib.rs:L10-L16`" and gives their bodies' `std::fs` and `std::process`
  imports as the reason a reading by module would fail the tree (`docs/nfdr.md:L1076-L1082`). A third
  site now exists: `crates/nozoki-core/src/fs_reader.rs:L894-L896` is a `#[cfg(test)]`
  `#[path = "../tests/unit/fs_reader.rs"]` `mod tests;` (`grep -rn '#\[path' crates/` lists it beside
  the two `lib.rs` sites and `crates/nozoki-core/tests/walk.rs:L6`, which is a test target, not a
  `src/` declaration). Its body holds two `fs::write` fixture writes
  (`crates/nozoki-core/tests/unit/fs_reader.rs:L753`, `:L953`), so a reading by module would also add
  a QC-2 finding in `nozoki-core` to the overreach the bullet lists. The likely fold: name three sites,
  adding `fs_reader`'s `tests` module, and add QC-2 to the findings a reading by module would raise.
  RN-36's "two `#[cfg(test)]` sites" (`docs/nfdr.md:L3384`) is a dated revision note and is left as
  written.
- **If a document has to be written:** none. The § 9 bullet in `nfdr.md`.
- **Answer:** <the owner fills this in>

**How it closes.** `product-architecture` folds it on its next run like any other item here.
