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

> **No `product-architecture` run wrote this file.** The PM opened it on 2026-10-05 from the records'
> own companion template. From `nozoki@4a50e68`, `checks/structure.sh` holds QC-11's libgit2-import
> clause over the whole shipped scope, and `git-reader` reads Git's config files itself before libgit2
> opens. QC-11's *verified by* tail still says the clause is held by review, and QC-15's list of
> `git-reader`'s reads outside libgit2 names no config read. The records are Settled, and with no
> companion on disk a `product-architecture` re-run reads them as done and has nothing to act on. Its
> two items are in § 3.

---

## 1. Open issues — questions with no answer yet

None.

## 2. Choices to confirm — the Principal Architect drafted a best-effort answer; confirm or override

None.

## 3. Raised from downstream — an item from a seat that did not write these records

### 3.1 QC-11's tail says the libgit2-import bound is review, and the script now holds it by file
- **Raised by:** PM — 2026-10-05
- **Which record:** `nfdr.md` QC-11
- **Tracked by:** `nozoki · nemawashi · 2026-10-02_git-says-what-changed`
- **What it blocks:** nothing is cut by it. A reviewer at `development-design` is told to hold by hand
  a rule the script already holds, and the one part the script does not hold is not named.
- **Where it shows:** QC-11's *verified by* says "The exception's bound — the switch and its test, and
  nowhere else in the bridge — is review at `development-design`: the script does not hold the import
  rule outside the three units' files it reads (`checks/structure.sh:L257-L258` at `nozoki@392177d`)",
  and that the bound "stays review until a change adds it" (`docs/nfdr.md:L357-L362`). That change has
  landed. The script's header now carries the clause over "every file of the shipped scope in any
  crate", with two exemptions, every file of the `git_reader` unit and
  `crates/nozoki-bridge/src/machine_config.rs` (`checks/structure.sh:L130-L142`, the exempting `case`
  at `:L1186`). At `nozoki@fc14574` it exits 0: "16 Rust files in 2 crates read — nothing found". The
  switch's test lies under `tests/`, outside the shipped scope. What the script holds is a file, not
  the switch: a second `git2` use added inside `machine_config.rs` draws no finding, while QC-11
  allows the binding "in the composition root's config search-path switch and that switch's test,
  and nowhere else" (`docs/nfdr.md:L355-L356`). The likely fold: the tail names the script as the
  check for the clause over the shipped scope, and keeps review only for the bound inside
  `machine_config.rs`, which is that file being the switch alone.
- **If a document has to be written:** none. A change in `nfdr.md` QC-11, written by
  `product-architecture`.
- **Answer:** <the owner fills this in>

### 3.2 QC-15's list of `git-reader`'s reads outside libgit2 names no config read
- **Raised by:** PM — 2026-10-05
- **Which record:** `nfdr.md` QC-15
- **Tracked by:** `nozoki · nemawashi · 2026-10-02_git-says-what-changed`
- **What it blocks:** nothing is cut by it. QC-15 fixes I/O ownership by list, and a read the list
  does not name reads as a read nobody owns.
- **Where it shows:** QC-15 gives `git-reader` "reads bounded to the opened folder": the folder's own
  metadata, its `.git` entry's metadata, an entry inside a `.git` folder, a `.git` file's content, the
  positions along the spelled paths, and the `commondir` file (`docs/nfdr.md:L455-L461`). The adapter
  now also reads, before libgit2 opens: the repository's `config`; `config.worktree` where
  `extensions.worktreeConfig` is set; each config file those include that spells inside the folder,
  the working tree included; and, before the status read, the same files and the `.git` entry,
  `.git` file, spelled positions and `commondir` of each submodule it verifies
  (`crates/nozoki-core/src/git_reader/libgit2.rs:L190-L250`, `:L289-L320`). `docs/SDD.md` § 3's
  `git-reader` row already owns these reads (`docs/SDD.md:L338`, RN-99). Its alternates read (RN-100) is
  not built yet. The likely fold: QC-15's list gains the config reads and the submodule reads in those
  terms, and, once built, the alternates file.
- **If a document has to be written:** none. A change in `nfdr.md` QC-15, written by
  `product-architecture`.
- **Answer:** <the owner fills this in>

**How it closes.** `product-architecture` folds it on its next run like any other item here.
