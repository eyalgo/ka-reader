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

### 2.1 QC-35 says nothing is read outside the grant, while libgit2's repository open reads the global and system Git config; until the SDD answers, QC-35 names those reads as an uncovered case

> **No `product-architecture` run wrote this item.** A `companion-self-answer` run raised it on
> 2026-10-03 while answering § 3.5 in the owner's seat. It is the half of § 3.5 that run could answer
> here: what the NFDR states in the meantime. § 3.5's other half — where libgit2's search path may
> be switched off, or whether the reads are accepted instead — is the SDD's, and is raised at
> `docs/SDD_open_issues.md` § 2.1 (`nozoki@4f028c7`). That is all § 3.5 is now left asking, though
> its heading still names the whole question. The slot below is the next round's.

- **Lands in:** `nfdr.md` QC-35, and § 10's QC-35 row
- **Drafted into the records:** Nothing yet — this run writes no record. Proposed: QC-35's tail
  gains a named uncovered case. libgit2's repository open reads the global level — under the App
  Sandbox from the password entry's home, which is the user's real home — and the system level at
  `/etc` (`libgit2/src/libgit2/repository.c:L997`, `:L1318`, `:L1330`; `sysdir.c:L282`,
  `:L356-L359`, in the `libgit2-sys 0.18.8+1.9.7` registry copy). In the harness's in-process cases
  these are real reads. Under the sandbox, whether the open survives their refusal has not been run.
  Where the reads are switched off is raised at `docs/SDD_open_issues.md` § 2.1, and until that
  folds, this entry does not hold for a repository open. The tail also says what holds the reads
  half today: `checks/own-state.sh` and `checks/read-only.sh` observe writes, and neither observes a
  read, so the sandbox (QC-25) is the reads half's only bound.
- **Rationale:** A fact in QC-35 is now false of landed code, and the delivery tier reads the entry
  as fixed while the change that exports `probe` is designed. The structural fix is the SDD's and
  cannot land here first. What can land here is the record saying, at the entry a reader opens, that
  the promise has a known hole and where its repair is decided. Sources: `docs/fdr.md` R-101;
  `docs/SDD.md` C-D1 (`:L852-L857`); `crates/nozoki-core/src/git_reader/libgit2.rs:L52`.
- **If overridden:** QC-35 stays unqualified until the SDD's answer re-derives into it. A change
  that exports `probe` in that window reads a promise the open does not keep, and only § 3.5's trail
  copy says otherwise.
- **Confirm or override:** <"confirm", or "override: <what to do instead>">

### 2.2 Two NFDR statements went false when `git-reader` linked libgit2: QC-30's boundary set misses libgit2's C environment reads and its config-file reads, and QC-9 still says "when `git-reader` links it"

> **No `product-architecture` run wrote this item.** A `companion-self-answer` run raised it on
> 2026-10-03. It read libgit2's source to answer § 3.5, read QC-30 and QC-9 beside it, and found
> both stating something `nozoki@126ef75` made false. No item asked about either. The slot below is
> the next round's.

- **Lands in:** `nfdr.md` QC-30 and QC-9
- **Drafted into the records:** Nothing yet — this run writes no record. Proposed:
  1. **QC-30.** The entry says the set is "exactly" what it lists, including "the environment and
     argument reads of the linked dependency tree, each named in `checks/entry-points.allow`", and
     that it "covers what the shipped process reads, whichever crate holds the line". libgit2's C
     reads `APP_SANDBOX_CONTAINER_ID`, `HOME` and `XDG_CONFIG_HOME` when the library initialises
     (`libgit2/src/libgit2/sysdir.c:L347`, `:L357`, `:L402-L405`, all guessed at init, `:L458-L459`),
     and none is named. The scan cannot name them: `checks/entry-points.sh` lists "a C `getenv`"
     among what it does not see (`:L66`), and `checks/entry-points.allow`'s `git2` line says those
     reads "are not held here" (`:L29`). Listing them in the allowlist would not work either,
     because the script fails on a listed line it no longer finds. So QC-30's *Not covered* names a C
     `getenv` in a linked crate, with these three reads as its present members and review of the
     lockfile diff at `development-design` as their gate. The git config files libgit2 opens are the
     other read the set does not name. They are § 2.1's and `docs/SDD_open_issues.md` § 2.1's, and
     QC-30 points there rather than listing them. One more C `getenv` is in the tree, in libz-sys's
     vendored zlib-ng (`src/zlib-ng/arch/arm/arm_features.c:L36`, `QEMU_EMULATING`). libz-sys came in
     only through libgit2-sys. Whether that file is compiled into this build was not established, and
     the fold measures it before naming it.
  2. **QC-9.** "and libgit2 when `git-reader` links it" becomes "and libgit2, which `git-reader`
     links". `crates/nozoki-core/Cargo.toml:L9` has named `git2` with `vendored-libgit2` since
     `nozoki@126ef75`.
- **Rationale:** Both meet the strongest ground for reopening a settled document: a fact in it is
  now false, by measurement. The libgit2 reads are dormant in the shipped process today, since no
  bridge function reaches `git-reader` (`docs/SDD.md` RN-85). But QC-30's half (2) is stated of the
  crates the tree resolves, and `git2` is among them.
- **If overridden:** QC-30 goes on calling "exact" a set that is missing three reads the shipped
  process makes once libgit2 initialises, and QC-9 reads as if libgit2 were not yet linked.
- **Confirm or override:** <"confirm", or "override: <what to do instead>">

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
- **Answer:** answered — `probe` answers `root` for a `.git` file, and `state()` reports where the Git
  directory lies: `docs/SDD.md` § 11 R-3's reading, which `docs/fdr.md` R-15 and R-21 already follow.
  `probe` reads the opened folder's own metadata, the `.git` entry's metadata without following a
  link, and, for a `.git` file, that file's own content — all inside the folder. It never opens the
  Git directory the file names. A `.git` file whose content is a `gitdir:` line answers `root`; any
  other content answers `plain`, as a `.git` folder that is not a repository does; a `.git` file the
  operating system will not let `probe` read is a condition; a `.git` that is a link is not followed
  and keeps a condition. A condition at `probe` is ruled out, because naming the Git directory as R-21
  requires would carry a path above the folder, which ADR-0005 and QC-5 forbid. The fold is a new
  record superseding ADR-0005, and QC-5's verification gains `root_finding` cases asserting `Root` for
  `linked-worktree` and `submodule`, and `Root` for a `.git` file naming a Git directory that does not
  exist — the case that goes red if `probe` follows the pointer. Reasoning:
  `docs/trail/architecture/self_answer-33.md` § 3.1.

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
- **Answer:** confirmed with addition — QC-11's trace reads SM-2 as `docs/SDD.md` v26 states it
  (`docs/SDD.md:L417`, RN-85): `folder-model` states what the port must answer, `git-reader` defines
  the trait and the plain-data types that cross beside it, and a type that crosses SM-2 is never
  defined in `folder-model` — it is defined in `git-reader` or in a value module (QC-63). Two
  additions. QC-10's may-import set names "the Git port trait" alone and is the whole allowed set, so
  it gains "and the types that cross SM-2 beside it" — SM-2's "the model imports the trait and those
  types, and never the adapter". And ADR-0004's "the Git port owned by the folder model" is corrected
  by the one new record that supersedes ADR-0004 for § 3.4, stating both halves — the model owns the
  contract, `git-reader` defines the trait — and not by a second record. Reasoning:
  `docs/trail/architecture/self_answer-33.md` § 3.2.

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
- **Answer:** confirmed with addition — QC-15's `git-reader` clause names its bounded reads beside
  the libgit2 reads: the opened folder's own metadata, its `.git` entry's metadata without following
  a link, the metadata of `HEAD` inside a `.git` folder
  (`crates/nozoki-core/src/git_reader/libgit2.rs:L31`, `:L35`, `:L63`), and, after § 3.1's fold, a
  `.git` file's own content — every one inside the opened folder, none past it. One addition to the
  verification. `checks/structure.sh` does not pass because `git-reader` is an owner: its filesystem
  clause exempts two files only, `fs_reader.rs` and `log_writer.rs` (`checks/structure.sh:L76-L78`),
  it lists "QC-15's other owners" as not held (`:L247`), and the adapter's reads are `Path` methods
  the scan does not see (`:L258`). QC-15's tail says so, holds the bound at `development-design`, and
  names as this document's realization the rule that adds the adapter's file to the clause's owner
  files by exact path. Decided together with § 3.1. Reasoning:
  `docs/trail/architecture/self_answer-33.md` § 3.3.

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
- **Answer:** answered — QC-3 follows `docs/SDD.md` § 4 C-R6 as v26 states it
  (`docs/SDD.md:L598-L629`; RN-85), which took the item's second fold with the first fold's facts
  beside it. The claim is made of the shipped executable: `Nozoki.app/Contents/MacOS/Nozoki` links no
  network transport. What the build holds: libgit2 vendored with its `https` and `ssh` features off,
  so no TLS backend and no libssh2. What it does not hold: the transports and streams are compiled
  whatever the features, and `git://`, `http://` and `https://` are registered with no guard.
  QC-3's verification gains a third half: the `nm` read of the release executable in
  `checks/view.sh`, red on a defined `git_smart_subtransport_*` symbol, on an undefined `connect`,
  `socket` or `getaddrinfo`, and where `nm` is missing, fails or prints nothing. The build that
  first exports a function reaching `git-reader` owes it; until then its gate is
  `development-design`, under this document's header rule. § 10's QC-3 row gains it. A red read is
  SDD § 11 R-15's, and stating the claim lower is the owner's call under `docs/fdr.md` PD-27.
  ADR-0004's transport sentence is corrected by a new record superseding ADR-0004, which also
  carries § 3.2's port sentence. Reasoning: `docs/trail/architecture/self_answer-33.md` § 3.4.

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
- **Answer:** raised upstream — carried at `docs/SDD_open_issues.md` § 2.1 (`nozoki@4f028c7`). Where
  libgit2's configuration search path may be switched off is a change to `docs/SDD.md` § 3: the
  units paragraph ("Only `git-reader` imports the libgit2 binding", `:L347`; `nozoki-core` "holds no
  `unsafe`", `:L336`) and the `core-bridge` row (`:L330`). Accepting the reads instead would lower
  `docs/fdr.md` R-101. Neither is the NFDR's to decide, and QC-9, QC-11, QC-13, QC-17 and QC-35
  re-derive from whichever the SDD states. The item there proposes the bridge, as the Rust-side
  composition root, emptying the four levels' search paths before the adapter is wired. The NFDR's
  own half — QC-35 naming these reads as an uncovered case until the SDD answers — moved to § 2.1 of
  this file. Reasoning: `docs/trail/architecture/self_answer-33.md` § 3.5.

**How it closes.** `product-architecture` folds it on its next run like any other item here.
