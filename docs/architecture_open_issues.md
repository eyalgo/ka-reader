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
> own companion template. `checks/structure.sh` now holds the `git-reader` adapter's file as a third
> QC-15 filesystem owner (`nozoki@48308ff`), and QC-15's *verified by* still describes the script as it
> stood before. The records are Settled, and with no companion on disk a `product-architecture` re-run
> reads them as done and has nothing to act on. Its one item is in § 3.

---

## 1. Open issues — questions with no answer yet

None.

## 2. Choices to confirm — the Principal Architect drafted a best-effort answer; confirm or override

None.

## 3. Raised from downstream — an item from a seat that did not write these records

### 3.1 QC-15's *verified by* describes a two-owner scan and an owner rule still to come; the script now holds three owners
- **Raised by:** PM — 2026-10-03
- **Which record:** `nfdr.md` QC-15, its *verified by*
- **Tracked by:** `nozoki · nemawashi · 2026-10-02_git-says-what-changed`
- **What it blocks:** nothing fails: `bash checks/structure.sh` exits 0 ("14 Rust files in 2 crates read
  — nothing found"). The entry's *verified by* is what review reads to know which half of QC-15's
  `git-reader` bound a script holds and which half review holds, and it now gives the wrong split.
- **Where it shows:** `docs/nfdr.md:L408-L418` says the filesystem clause "exempts two owner files by
  exact path, `fs_reader.rs` and `log_writer.rs`", that the script "names QC-15's other owners as not
  held (`:L247`)", and that the rule adding `crates/nozoki-core/src/git_reader/libgit2.rs` is to come:
  "Until the change that adds it … the bound is review at `development-design`". The script now reads
  "In every crate except in the three owner files", naming `fs_reader.rs`, `log_writer.rs` and
  `git_reader/libgit2.rs` (`checks/structure.sh:L77-L80`, the exempting `case` at `:L1161`). Its *WHAT
  IS NOT HELD* no longer lists QC-15's other owners. It lists two parts still unheld, both for review at
  `development-design`: which read the adapter makes inside its owner file, and `git-reader`'s
  `Path`-method reads (`:L253-L256`). The adapter line citations are stale as well. The entry cites
  `libgit2.rs:L31`, `:L35` and `:L63`. The `Path`-method reads now sit at `libgit2.rs:L38`, `:L42` and
  `:L136`, and the `.git` file's open sits at `:L62`, with its handle's `metadata()` at `:L69`. The likely
  fold: the *verified by* names the three exact-path owners at a pinned commit, keeps review at
  `development-design` as the gate for those two unheld parts only, and re-pins the adapter citations.
- **If a document has to be written:** none.
- **Answer:** <the owner fills this in>

**How it closes.** `product-architecture` folds it on its next run like any other item here.
