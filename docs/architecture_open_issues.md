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
> own companion template. `git-reader` now exists in the tree, binding libgit2 behind the Git port
> (`crates/nozoki-core/src/git_reader.rs`, `crates/nozoki-core/src/git_reader/libgit2.rs`, `nozoki@126ef75`).
> Five statements of the records no longer match what landed, or leave open a choice the code had to
> make provisionally. The records are Settled, and with no companion on disk a `product-architecture` re-run
> reads them as done and has nothing to act on. Its five items are in § 3.

---

## 1. Open issues — questions with no answer yet

None.

## 2. Choices to confirm — the Principal Architect drafted a best-effort answer; confirm or override

None.

## 3. Raised from downstream — an item from a seat that did not write these records

### 3.1 ADR-0005 does not say what `probe` answers for a `.git` file, and the adapter answers it provisionally
- **Raised by:** PM — 2026-10-03
- **Which record:** `adr/0005-root-finding-behind-the-git-port.md`
- **Tracked by:** `nozoki · nemawashi · 2026-10-02_git-says-what-changed`
- **What it blocks:** the Git-state work for a linked worktree and a submodule. It cannot replace the
  provisional answer until the record states the real one.
- **Where it shows:** ADR-0005 § Decision gives `probe` two answers, `root` or `plain`
  (`docs/adr/0005-root-finding-behind-the-git-port.md:L21-L23`). Its § Consequences says a `.git` file's
  Git directory outside the grant is something "the port must report" (`:L51-L54`), without saying at
  which call. `docs/SDD.md` § 11 R-3 does say: "`probe` answering `root` and `state()` failing on the
  gitdir path" (`docs/SDD.md:L2514-L2516`). `docs/fdr.md` R-15 counts a linked worktree's top level and a
  submodule's folder as roots, and R-21 places the failure at the Git-state read. The adapter in the tree
  answers neither: a `.git` entry that is not a folder returns
  `RootFinding::Failed(ProbeCondition::GitEntryNotDirectory)`
  (`crates/nozoki-core/src/git_reader/libgit2.rs:L39`). That arm is a placeholder the code had to return,
  set while the choice was left with this record. The `linked-worktree` and `submodule` cases in
  `crates/nozoki-core/tests/root_finding.rs` assert no outcome for it. The likely fold: ADR-0005 states
  the `.git`-file outcome — R-3's reading (`root`, then `state()` reports where the Git directory lies), or
  a condition at `probe` with R-3 and R-21 moved to match. It also states what `probe` may read to answer
  `root` for a `.git` file without following it past the grant (`docs/fdr.md` R-101).
- **If a document has to be written:** none. ADR-0005, or a record superseding it.
- **Answer:** <the owner fills this in>

### 3.2 QC-11's trace and ADR-0004 place the Git port's types in the model; the tree holds them in `git-reader`
- **Raised by:** PM — 2026-10-03
- **Which record:** `nfdr.md` QC-11's trace; `adr/0004-git-read-through-libgit2-behind-a-port.md` § Decision
- **Tracked by:** `nozoki · nemawashi · 2026-10-02_git-says-what-changed`
- **What it blocks:** nothing fails: `checks/structure.sh` exits 0 at `nozoki@126ef75`. The trace is
  what a later change reads to decide where the port's next methods and types go, and it points the
  other way from the tree.
- **Where it shows:** QC-11's trace says SM-1's model "does not hold the types, unlike SM-2's port"
  (`docs/nfdr.md:L260-L261`). ADR-0004 says "the Git port owned by the folder model"
  (`docs/adr/0004-git-read-through-libgit2-behind-a-port.md:L22`). In the tree, `pub trait GitPort` is at
  `crates/nozoki-core/src/git_reader.rs:L33`, beside `RootFinding` and `ProbeCondition`, and
  `crates/nozoki-core/src/folder_model.rs` names none of them. A trait the model held would need a
  `git-reader` → `folder-model` import, which QC-11 forbids. That is why it lives where it does. The
  same point is raised against `docs/SDD.md` SM-2 on `docs/SDD_open_issues.md` § 5.2. The likely fold:
  QC-11's trace reads SM-2 the way it now reads SM-1 — the model owns the contract and the reader holds
  the types — and ADR-0004's sentence says the same.
- **If a document has to be written:** none.
- **Answer:** <the owner fills this in>

### 3.3 QC-15 gives `git-reader` Git reads "through libgit2"; the adapter also reads the folder's and `.git`'s metadata itself
- **Raised by:** PM — 2026-10-03
- **Which record:** `nfdr.md` QC-15
- **Tracked by:** `nozoki · nemawashi · 2026-10-02_git-says-what-changed`
- **What it blocks:** nothing fails: `checks/structure.sh` exits 0, because `git-reader` is an I/O owner.
  The entry's description is what review reads to judge a later read in `git-reader`. It describes less
  than the unit does.
- **Where it shows:** QC-15 says folder reads are `git-reader`'s for "Git's on-disk state through libgit2"
  (`docs/nfdr.md:L332-L334`). The adapter reads with `std::fs` before libgit2 is asked: the opened
  folder's metadata, its `.git` entry's metadata without following a link, and `.git/HEAD`'s
  (`crates/nozoki-core/src/git_reader/libgit2.rs:L31`, `:L35`, `:L63`). Those reads are how `probe` keeps
  discovery off and answers a missing or unreadable `.git` as data. The likely fold: QC-15's
  `git-reader` clause names these bounded metadata reads of the folder, its `.git` entry and that
  entry's `HEAD` beside the libgit2 reads.
- **If a document has to be written:** none.
- **Answer:** <the owner fills this in>

### 3.4 QC-3 and ADR-0004 say no shipped unit links a network transport; the vendored libgit2 compiles `git://` and `http://` unconditionally
- **Raised by:** PM — 2026-10-03
- **Which record:** `nfdr.md` QC-3; `adr/0004-git-read-through-libgit2-behind-a-port.md` § Decision
- **Tracked by:** `nozoki · nemawashi · 2026-10-02_git-says-what-changed`
- **What it blocks:** QC-3's two halves verify the tree against the list and judge each listed name
  "in the features the lockfile resolves" (`docs/nfdr.md:L104-L117`). Neither half sees a transport that
  no feature turns off. The bridge's static library now carries libgit2 (the
  `nozoki-mac/Package.swift` link entries landed for it at `nozoki@126ef75`), so the claim reaches
  the shipped executable, and nothing checks it there.
- **Where it shows:** `libgit2-sys 0.18.8+1.9.7`, the version the lock resolves, compiles
  `libgit2/src/libgit2/transports` whatever its features (`build.rs:L152-L155` in the registry copy).
  Its transport table registers `git://` and `http://` with no `#ifdef` (`libgit2/src/libgit2/transport.c:L33-L34`).
  HTTPS and SSH are off as QC-3's first clause says: `cargo tree --locked -p nozoki-core --prefix none |
  grep -Ei 'openssl|native-tls|rustls|libssh2|schannel|security-framework'` prints nothing at
  `nozoki@126ef75`. `checks/deps.review.md`'s `libgit2-sys` row records the exception and the link
  evidence the bundle owes. The same point is raised against `docs/SDD.md` § 4 C-R6 on
  `docs/SDD_open_issues.md` § 5.3. ADR-0004's correction would be a new record, since an accepted ADR is
  superseded, not edited. The likely fold is one of two. QC-3 states what the build holds (no TLS and no
  SSH; the plain transports compiled in and never called by a read-only port). Or it names a link-level
  verification on the shipped executable. Either way the verification map gains that row.
- **If a document has to be written:** a superseding ADR for ADR-0004's transport sentence, if the fold
  changes it.
- **Answer:** <the owner fills this in>

### 3.5 QC-35 says the product reads nothing outside the grant; libgit2's repository open loads the global, XDG and system Git config, and no unit may turn that off
- **Raised by:** PM — 2026-10-03
- **Which record:** `nfdr.md` QC-35, with QC-9, QC-11 and QC-13
- **Tracked by:** `nozoki · nemawashi · 2026-10-02_git-says-what-changed`
- **What it blocks:** the Git commands' export through the bridge, the first point where `probe` runs
  inside the sandboxed app. `docs/SDD.md`'s Open Questions, second item, settles there.
- **Where it shows:** the adapter opens the repository with `Repository::open_ext`
  (`crates/nozoki-core/src/git_reader/libgit2.rs:L52`). In the vendored libgit2 that open takes a config
  snapshot (`libgit2/src/libgit2/repository.c:L997`), which loads the global and system levels
  (`:L1318`, `:L1330`): reads of the user's home and of system paths, outside the granted folder and
  the container that QC-35 bounds (`docs/nfdr.md:L718-L719`; `docs/fdr.md` R-101). In the unit's
  in-process cases those reads are unconfined. Under the sandbox they are refused, and whether the open
  survives the refusal has not been run. The one switch that stops them, `git2::opts::set_search_path`,
  is an `unsafe fn` (`git2-0.21.0/src/opts.rs:L23`). `nozoki-core` holds no `unsafe` (QC-9). The bridge,
  which may, does not import the binding — QC-11 gives that to `git-reader` alone. So the rules as
  written leave no unit that may make the call. The likely fold: the records say where the search-path
  override is allowed to live, or state that the open is proved to answer under the grant with those
  reads refused, and add the check that shows it.
- **If a document has to be written:** none.
- **Answer:** <the owner fills this in>

**How it closes.** `product-architecture` folds it on its next run like any other item here.
