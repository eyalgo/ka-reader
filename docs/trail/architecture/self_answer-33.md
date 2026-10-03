# Self-answer report — `docs/adr/` and `docs/nfdr.md`

This is the record of one unattended run that answered `docs/architecture_open_issues.md` in the
owner's seat. It is for the owner, who reads it to learn what was decided and why, and for the
`product-architecture` run that folds the answers.

## Header

- **Companion:** `docs/architecture_open_issues.md`
- **Document:** `docs/adr/` and `docs/nfdr.md`
- **Decided by:** `decide_companion_answers.md` v1.3.0
- **Date:** 2026-10-03
- **Sources re-read:** The registry copies of the two crates the lock resolves, on this machine
  (`~/.cargo/registry/src/index.crates.io-1949cf8c6b5b557f/`), at the versions
  `Cargo.lock:L122-L123` names:
  - `libgit2-sys-0.18.8+1.9.7/build.rs:L152-L156` compiles `libgit2/src/libgit2/transports` and
    `…/streams` with no feature condition, under the comment "they're all unconditionally always
    compiled apparently".
  - `…/libgit2/src/libgit2/transport.c:L32-L36` registers `git://`, `http://`, `https://` and
    `file://` with no guard; `:L38-L42` registers the three SSH schemes under `#ifdef GIT_SSH`.
  - `…/libgit2/src/libgit2/repository.c:L997` takes a config snapshot on every open and fails the
    open on any error but `GIT_ENOTFOUND` (`:L998-L999`); the snapshot adds the global (`:L1318`),
    XDG (`:L1324`), system (`:L1330`) and programdata (`:L1336`) levels.
  - `…/libgit2/src/libgit2/sysdir.c`: the system level is `/etc` (`:L282`). Under the App Sandbox —
    `APP_SANDBOX_CONTAINER_ID` set (`:L347`) — the global level's home is taken from the password
    entry and not from `HOME` (`:L356-L359`). The XDG level reads `XDG_CONFIG_HOME`, then `HOME`
    (`:L402-L405`). Every level is guessed at library init (`:L458-L459`), and a level whose search
    path is empty is skipped before any file is touched (`:L559-L560`).
  - `…/libgit2/src/libgit2/config_file.c:L117-L123` treats a config file it may not read as absent,
    "particularly important for sandboxed applications on macOS"; `…/config.c:L143-L147` fails on
    a `stat` error other than `ENOENT` or `ENOTDIR` before that point is reached.
  - `…/libgit2/src/libgit2/repository.c:L76` defines the gitfile prefix as `gitdir:`.
  - `git2-0.21.0/src/opts.rs:L23` declares `set_search_path` an `unsafe fn`, because it mutates
    global state without thread safety (`:L20-L22`), and calls `crate::init()` before setting the
    path (`:L27`).

  Nothing outside this repository was read on the web. Each answer below names which of these it
  rests on.

**What this run read, for all five items.** The companion whole. `docs/adr/README.md`, ADR-0004
and ADR-0005 whole. `docs/nfdr.md`: the header and § 1 whole (`:L1-L390`), QC-26 to QC-37
(`:L574-L740`), QC-47 to QC-50 (`:L819-L847`) and § 10's rows for QC-3, QC-5, QC-9, QC-15, QC-30
and QC-35. The rest of the NFDR was not read line by line. `docs/SDD.md`: the cycle-21 fold's diff
whole (`git show 4160b57 -- docs/SDD.md`), the units paragraph (`:L335-L353`), SM-2 (`:L417`),
C-D1 (`:L852-L857`), § 11 R-3 (`:L2549-L2556`), RN-44 (`:L3268-L3275`) and *Open Questions*
(`:L5083-L5130`). `docs/trail/sdd/self_answer-33.md` whole. `docs/fdr.md` R-15, R-20, R-21,
R-101, PD-27 and the linked-worktree example row (`:L351`). The SRS was not opened, because no
answer moves a requirement. In the tree at `nozoki@4160b57`: `crates/nozoki-core/src/git_reader.rs`
and `git_reader/libgit2.rs` whole, `crates/nozoki-core/Cargo.toml`, `src/lib.rs`, the
`root_finding` test list and its scene helpers, the two fixtures' `.git` files, and
`checks/structure.sh`'s and `checks/entry-points.sh`'s headers. As input and not as a source, the
change design behind `nozoki@126ef75`. Nothing here cites it, because the definition set does not
name the journey.

**The SDD moved after this companion was opened, and every answer reads it as it stands now.** The
companion was opened at `nozoki@136b227`. The SDD's companion was then answered (`814a369`) and
folded into SDD v26 (`4160b57`), which settled SM-2's placement (RN-85 § 5.2) and C-R6's transport
claim (RN-85 § 5.3). Items 3.2 and 3.4 are about those same sentences downstream, so their answers
follow v26 rather than re-deciding it.

## Items worked

### 3.1 — ADR-0005 does not say what `probe` answers for a `.git` file, and the adapter answers it provisionally

- **Bucket:** 3. Raised from downstream — an item from a seat that did not write these records
- **Verdict:** answered
- **Why:** `probe` answers `root` for a `.git` file, and `state()` reports where the Git directory
  lies. That is the first of the item's two folds. The item offers two and leans to neither, so it
  is a question and not a draft, and it is answered from scratch.

  **The widening rule, first.** The item asks a record to state a case it does not state now, so
  it widens. It cites an occurrence: the `.git`-file arm is in the product at
  `crates/nozoki-core/src/git_reader/libgit2.rs:L38-L40`, and the two fixtures it answers for are
  on disk. Their `.git` files read `gitdir: ../main-repo/.git/worktrees/linked-worktree` and
  `gitdir: ../.git/modules/submodule` (`tar -xOf` on each archive). The change proceeds.

  **Check 1: the seat.** The edit lands in the decision log, as a record superseding ADR-0005, and
  in NFDR QC-5. Both are this seat's. The answer binds no person and no outside party. The design
  call itself is already made upstream, and this answer records it: `docs/SDD.md` § 11 R-3 says the
  case "shows up as `probe` answering `root` and `state()` failing on the gitdir path"
  (`docs/SDD.md:L2549-L2551`). Mine, in the owner's seat.

  **Check 2: the question.** It holds, and it hides a second question with the same seat: what
  `probe` may read to answer `root` without following the file past the grant. Both are answered
  here. The delivery tier parked this choice on one argument: "`root` requires following the link
  outside the folder". That argument does not hold. `probe` can answer `root` from the `.git` file's
  own content. The file sits inside the opened folder, and its `gitdir:` line is the form libgit2
  itself parses (`repository.c:L76`). R-15 counts that folder a root whether or not the Git
  directory can be reached (`docs/fdr.md:L57`). Nothing past the pointer needs reading to answer
  `root`.

  **Why `root` and not a condition at `probe`.** R-21 requires the Git view to name where the Git
  directory lies (`docs/fdr.md:L63`, and the example row at `:L351`). A condition raised by `probe`
  could only meet that by carrying the path, and the path lies above the folder: both fixtures'
  pointers start `../`. ADR-0005 forbids that ("never a path above the folder"), QC-5 forbids it
  ("The root finding never answers with a path above the granted folder"), and the type already
  says it cannot: `RootFinding` "holds no path and no text" (`git_reader.rs:L38-L39`). The second
  fold therefore moves QC-5 and ADR-0005's decision, not only R-3 and R-21 as the item says. Under
  the first fold, `state()` carries the path, and that is the one call the SDD already designs for
  it. `see-git-status`'s reducer case is "a port double whose `probe` answers `root` and whose
  `state()` returns the error naming a Git directory outside the folder" (`docs/SDD.md:L3268-L3270`).

  **What the fold writes.** ADR-0005 is Accepted, and the log is append-only, so the record cannot
  be edited. A new record supersedes it. It restates ADR-0005's decision and adds the `.git`-file
  outcome, the read bound and the rejected alternatives: a condition at `probe`, for the reason
  above; libgit2 opening the `.git` file in `probe`, which follows the gitdir outside the grant
  (R-101, C-D1); and `plain`, which R-15 rules out. It replaces ADR-0005's "reading and creating
  nothing", which the adapter has never met, since `probe` reads metadata and opens a repository.
  The replacement is the read bound stated as a rule. The record earns its place under the
  significance test. It is surprising without its context: the delivery tier reached the opposite
  reading. It is a real trade-off. And it is costly to reverse once the Git view draws a failed
  item from `state()`. QC-5 gains the `.git`-file clause and three `root_finding` cases.
  `linked-worktree` and `submodule` assert `Root`; today they assert no outcome
  (`crates/nozoki-core/tests/root_finding.rs:L158-L169`). A third case plants a `.git` file naming a
  Git directory that does not exist and asserts `Root`. That is the case that goes red if `probe`
  ever follows the pointer, so the read bound has a check and is not only a sentence.

  **Check 3: against the settled record.**
  - `docs/SDD.md` § 11 R-3 and RN-44, `docs/fdr.md` R-15, R-21 and the example row all agree with
    the answer. None of them moves.
  - QC-5 and ADR-0005's "never a path above the folder" hold, because `probe` carries no path.
  - `docs/SDD.md` *Open Questions*, second item, already contemplates "a `.git` file naming a gitdir
    inside the grant" (`docs/SDD.md:L5101-L5104`). Under this answer that case answers `root`, and
    `state()` reads the Git directory normally.
  - R-101 and C-D1 (`docs/fdr.md:L188`; `docs/SDD.md:L852-L857`): `probe` reads nothing outside the
    folder under this answer. `state()` is bound by them too. It may not read past the grant to find
    out that the Git directory lies outside it.
  - QC-11 forbids `git-reader` importing `fs-reader`, so `state()` cannot borrow the containment
    check. How `state()` establishes "outside" without a read outside is the design of the change
    that adds `state`. It is named in check 4 and not decided here.
  - § 3.3's answer is decided together with this one: the read of a `.git` file's content is a
    `git-reader` read QC-15 must name.

  **Check 4: the failure paths.**
  - *Empty.* An empty `.git` file is not a `gitdir:` line, so it answers `plain`. That matches the
    adapter's answer for a readable `.git` folder that is not a repository (`libgit2.rs:L60-L69`).
  - *Absent.* A `gitdir:` line naming a path that does not exist answers `root`, because `probe` does
    not follow it. `state()` then fails and names where the Git directory was said to lie, so the
    Git view shows a failure and never nothing (R-20). This is also the check that proves the bound.
  - *Refused.* A `.git` file the operating system will not let `probe` read is a condition, as an
    unreadable `.git` folder already is (`GitDirectoryUnreadable`). Which variant it takes is the
    change's.
  - *Stale.* The finding is live through the watcher on the root's `.git` entry (ADR-0005). A `.git`
    file rewritten mid-session re-runs `probe`. Nothing new is needed.
  - *Concurrent.* The `.git` file is replaced between `probe` and `state()`. `state()` reads the
    pointer for itself, and the replacement is the next event the reducer applies.
  - *A link.* A `.git` that is a symbolic link (`root_finding.rs:L207`) is not followed, so `probe`
    cannot tell and keeps a condition. Following it could leave the grant.
  - *Not covered, and named.* (1) How `state()` decides that a Git directory lies outside the grant
    without reading there, under C-D1 and with QC-11 keeping it from `fs-reader`'s check, is the
    `state` change's design. (2) A linked worktree's Git directory carries a `commondir` that can
    point outside even when the Git directory itself is inside. That too is `state()`'s, not
    `probe`'s.

  **What was close.** One alternative was folding the clause into QC-5 alone and leaving ADR-0005
  standing. It did not carry. The delivery tier reads the log as a fixed reference, and the gap in
  ADR-0005 is what let a provisional arm land. What would have tipped it: had ADR-0005's decision
  already said "a `.git` file answers `root`", the constraint would have been the only thing owed.

### 3.2 — QC-11's trace and ADR-0004 place the Git port's types in the model; the tree holds them in `git-reader`

- **Bucket:** 3. Raised from downstream — an item from a seat that did not write these records
- **Verdict:** confirmed with addition
- **Why:** The item's likely fold is taken. QC-11's trace reads SM-2 the way it reads SM-1, and
  ADR-0004 says the same. Two things are added: QC-10's may-import set, and the form ADR-0004's
  correction takes. The item carries a lean, so it is weighed as a draft.

  **The widening rule, first.** This is a correction. QC-11's trace states that SM-2's model "holds
  the types" (`docs/nfdr.md:L260-L261`, "does not hold the types, unlike SM-2's port"), and the tree
  and the SDD now say otherwise.

  **Check 1: the seat.** The edits land in NFDR QC-10 and QC-11, and in the decision log. Both are
  this seat's. The upstream sentence has already moved: SDD v26 rewrote SM-2 to "The port is a trait
  defined in `git-reader`, with the plain-data types that cross beside it … The model imports the
  trait and those types, and never the adapter", and kept `folder-model` as owner of the contract
  (`docs/SDD.md:L417`; RN-85 § 5.2). Recording it is mine.

  **Check 2: the draft.** It holds, for a reason one step upstream of the one it gives. The item
  reasons from QC-11's forbidden import. The SDD's own reason is its units paragraph: "the readers …
  import neither the model nor one another" (`docs/SDD.md:L347-L349`). QC-11 derives from that
  paragraph, so the trace should cite the SDD as its source and not itself. The draft is incomplete
  in two places, and those are the additions.
  1. *QC-10.* Its may-import set reads "`fs-reader`, the Git port trait, `watcher`, …"
     (`docs/nfdr.md:L237`). § 1.2 says "'May import' is the whole allowed set … never inferred". Read
     to the letter, then, the model may import the trait but not `RootFinding` or `ProbeCondition`,
     which the trait's own signature returns (`git_reader.rs:L35`). SM-2 at v26 says the model
     imports "the trait and those types". QC-10 gains that phrase. Otherwise the fold of QC-11 alone
     would leave QC-10 narrower than the seam it realizes.
  2. *ADR-0004's form.* ADR-0004 is Accepted and cannot be edited. Its sentence "the **Git port**
     owned by the folder model" (`docs/adr/0004-git-read-through-libgit2-behind-a-port.md:L22`) is
     half true under v26: the model owns the contract, and `git-reader` defines the trait. § 3.4
     needs ADR-0004 superseded anyway, for its transport sentence. One new record carries both
     corrections, so the log does not gain two records superseding one.

  **Check 3: against the settled record.**
  - QC-63 already admits a value module that any part may import (`docs/nfdr.md:L268-L296`). SM-2's
    "or in a module of `nozoki-core` that is no part" is that module. The trace names QC-63 and
    invents no third home.
  - QC-10's "must not import the libgit2 binding, `git-reader`'s adapter" stands as written. It is
    SM-2's "never the adapter".
  - `checks/structure.sh` forbids `folder_model` only `own_state` among the units (`:L422`), and it
    lists QC-10's adapter clause as not held (`:L248`). Widening QC-10's prose to the crossing types
    changes no script finding. The adapter clause stays a review at `development-design`.
  - QC-50 and QC-18 speak of the port and its contract tests. They do not say where the trait is
    defined, and neither moves.
  - My § 3.1 answer writes a record about `probe`. That record names the port in v26's terms, so the
    two new records agree.

  **Check 4: the failure paths.**
  - *Stale.* This is the path that matters: `state`, `status`, `diff` and `walk` each bring types.
    The rule in QC-11's trace — a crossing type is defined in `git-reader` or a value module, never
    in `folder-model` — covers each one as it lands, and which home a type takes is the design of the
    change that adds it (SM-2).
  - *A second adapter* (§ 11 R-1). It lives in `git-reader` beside the first and implements the same
    trait. QC-50 is unchanged.
  - *Empty*, *absent*, *concurrent*, *refused*: not reached by a statement of where a trait is
    defined.

  **What was close.** *Confirmed* with no addition. It did not carry, because QC-10 would then have
  contradicted SM-2 at v26 the day the fold landed.

### 3.3 — QC-15 gives `git-reader` Git reads "through libgit2"; the adapter also reads the folder's and `.git`'s metadata itself

- **Bucket:** 3. Raised from downstream — an item from a seat that did not write these records
- **Verdict:** confirmed with addition
- **Why:** The item's likely fold is taken. QC-15's `git-reader` clause names the bounded reads
  the adapter makes before libgit2 is asked. Two things are added: the read § 3.1's answer brings,
  and the verification QC-15 actually has. The item carries a lean, so it is weighed as a draft.

  **The widening rule, first.** This is a correction. The entry describes a unit's reads, and the
  unit makes reads the entry does not name, at `libgit2.rs:L31` (`folder.metadata()`), `:L35`
  (`.git`'s `symlink_metadata()`) and `:L63` (`.git/HEAD`'s `symlink_metadata()`).

  **Check 1: the seat.** The edit lands in NFDR QC-15 and § 10's QC-15 row. It is this seat's. The
  SDD's `git-reader` row gives it "Git's own on-disk layout" and nothing past it ("A file outside
  Git's own on-disk layout", *Must not own*, `docs/SDD.md:L324`). The folder's metadata and a `.git`
  entry's are reads of that layout's root, so nothing upstream moves. Mine, in the owner's seat.

  **Check 2: the draft.** The conclusion holds. One statement in the item's support does not:
  "`checks/structure.sh` exits 0, because `git-reader` is an I/O owner". The script's filesystem
  clause exempts exactly two files by path, `crates/nozoki-core/src/fs_reader.rs` and
  `crates/nozoki-bridge/src/log_writer.rs` (`checks/structure.sh:L76-L78`), and it lists "QC-15's
  other owners" — `git-reader` among them — as not held (`:L247`). The scan passes because the
  adapter reads through `Path` methods, and the script names that as a gap it does not close: "a
  `Path` method that touches the filesystem (exists, metadata, read_dir, canonicalize), which names
  no filesystem module" (`:L258`). Had the adapter written `std::fs::symlink_metadata`, the scan would
  have reported a QC-15 finding outside its owner file. The error is reported here and not
  corrected in the companion. The answer is written to the fact.

  That fact is the first addition. QC-15's tail says "each Rust I/O primitive appears only in its
  owner", which a reader takes as covering `git-reader`. It does not, so the tail has to say what
  holds the bound. Today that is review at `development-design`. The rule that would make it a
  check is the adapter's file, `crates/nozoki-core/src/git_reader/libgit2.rs`, added to the clause's
  owner files by exact path. The adapter could then write `std::fs` in the open, and a `std::fs` read
  anywhere else in `git-reader` would still be a finding. The NFDR names that rule as its own
  realization, as it has for other rules it adds to the script (the header's "Executability is per
  rule"). The delivery tier reached the same rule independently.

  The second addition is decided together with § 3.1. Under that answer `probe` reads a `.git`
  file's content to answer `root`, which is one more bounded `git-reader` read the clause must name.

  **The bound, stated as one rule.** Every read `git-reader` makes outside libgit2 is inside the
  opened folder: the folder's own metadata, its `.git` entry's metadata without following a link, an
  entry inside a `.git` folder, and a `.git` file's content. It never reads a path past the folder
  and never follows a link out of it. That is what review reads a later `git-reader` read against.

  **Check 3: against the settled record.**
  - QC-35 and R-101: every read named is inside the folder. The libgit2 config reads are another
    matter, § 3.5's, and nothing here claims they are bounded.
  - QC-11's "Only `git-reader` imports the libgit2 binding" is unaffected. These reads use `std`.
  - QC-30 half (1) scans every workspace member for config-file reads. A `.git` file is Git's
    on-disk state and not a configuration file of the product's, so it is not that rule's subject.

  **Check 4: the failure paths.**
  - *Refused.* Each read already maps a refusal to a condition (`libgit2.rs:L33`, `:L37`, `:L65`).
    The bound adds no case.
  - *Stale.* The next unit read added in `git-reader` — `state()`'s re-read of a `.git` file, for one
    — is judged against the rule above. The owner-file rule, once added, makes `std::fs` reads in the
    adapter visible to the scan. `Path`-method reads stay the script's named gap until a rule reads
    them.
  - *Empty*, *absent*, *concurrent*: not reached by a statement of which unit owns a read.

  **What was close.** *Confirmed* with no addition. It did not carry, because the tail would have
  kept describing coverage the scan does not give.

### 3.4 — QC-3 and ADR-0004 say no shipped unit links a network transport; the vendored libgit2 compiles `git://` and `http://` unconditionally

- **Bucket:** 3. Raised from downstream — an item from a seat that did not write these records
- **Verdict:** answered
- **Why:** QC-3 keeps the claim and makes it of the shipped executable, with the build's facts
  stated beside it and an `nm` read as its third verification half. ADR-0004 is superseded by a new
  record that says the same. The item offers two folds and picks neither, so it is answered from
  scratch. The answer is both folds together, in the form the SDD has now taken.

  **The widening rule, first.** This is a correction, with its occurrence re-read at the source. QC-3
  says "No shipped unit links a network transport: libgit2 is built without its HTTPS and SSH
  transports" (`docs/nfdr.md:L104-L105`). `libgit2-sys-0.18.8+1.9.7/build.rs:L152-L156` compiles the
  transports and streams whatever the features, and `transport.c:L32-L36` registers `git://`,
  `http://` and `https://` with no guard. So "built without its HTTPS … transports" is false of the
  library. What is absent is the TLS stream behind `https://`. And "no shipped unit" is false of
  `nozoki-core` as a unit.

  **Check 1: the seat.** The edits land in NFDR QC-3, § 10, and the decision log. They are this
  seat's. Which claim stands was not mine to pick, and it no longer needs picking. SDD v26 C-R6
  restated it: "The transport claim is made of the shipped executable, and of nothing smaller", with
  what the build holds, what it does not, the `nm` evidence, three bounds, and *Violated by*
  (`docs/SDD.md:L598-L629`; RN-85 § 5.3). The SDD's answer took the item's second fold on the
  ground that the first lowers a product decision, `docs/fdr.md` PD-27, "Nothing the product ships
  carries a network transport" (`docs/fdr.md:L294`), which is the owner's to lower. I agree with that
  ground, and recording C-R6 is mine.

  **Check 2: the question.** It hides one error in its support, which the SDD's answer already
  reported. The transport table registers `https://` without a guard as well as `git://` and
  `http://` (`transport.c:L35`). The answer is written to the fuller fact.

  **What the fold writes.**
  - *QC-3's statement:* "The shipped executable links no network transport", followed by what the
    build holds and what it does not, as C-R6 states them. The allowlist clause stays.
  - *QC-3's verification:* the two halves stay — the tree equals the list, and the list is reviewed
    against the domain. A third half is added: the `nm` read on the release executable, riding
    `checks/view.sh` under that script's rule that it never passes having read nothing, with a
    suite case that turns it red (C-I3, `docs/SDD.md:L708-L714`). The read is not in the script at
    `nozoki@4160b57`: `grep -n 'nm ' checks/view.sh` prints nothing and exits 1, run for this answer. The
    NFDR's header rule already says what that means: the rule is executable from the change that
    adds it, and its gate is `development-design` until then. C-I3 names who owes it: the build that
    first exports a function reaching `git-reader`.
  - *What follows a red read:* SDD § 11 R-15, a re-cut recorded before anything is built on that
    export (`docs/SDD.md:L2645-L2657`). The NFDR cites it and does not restate it.
  - *The record:* a new record superseding ADR-0004. It keeps ADR-0004's decision — libgit2 behind a
    port, the installed `git` as the standing substitute — and corrects two sentences: the transport
    claim (this item) and the port's placement (§ 3.2). Its *What this rests on* gains a platform
    fact ADR-0004 did not name: libgit2-sys compiles the transports unconditionally
    (`build.rs:L152-L156`), and that holder may change it in either direction in any release. The
    `nm` read is what keeps the claim independent of that fact. If the holder goes silent, the
    vendored copy stays as locked and the claim still rests on the read, not on the library.

  **Check 3: against the settled record.**
  - `docs/SRS.md` NFR-8 and § 4 C-R2: the wall that holds "no network call" is the sandbox, and the
    `nm` read is the second line behind it. C-R6 says so, and QC-3 keeps QC-25 and QC-32 as the
    wall's entries without moving them.
  - QC-26 and § 10's QC-26 row are unaffected. The allowlist and the review are as they were.
  - QC-8 already runs `otool -L` on the same executable through `checks/view.sh`. The new read sits
    beside that check, on the same file.
  - QC-9's statement about the C `nozoki-core` links is unaffected by this item. Its tense is raised
    separately, in § 2.2 of the companion.
  - My § 3.2 answer puts its correction into the same superseding record, so the log gains one record
    for ADR-0004, not two.

  **Check 4: the failure paths.**
  - *Refused.* The read turns red once libgit2's transport code reaches the executable. R-15 owns
    what follows, and lowering the claim is the owner's.
  - *Absent.* No release executable, or no `nm`: red, never a silent pass, under `view.sh`'s rule.
  - *Stale.* A libgit2 release that renames its transport symbols would pass the symbol half. The
    import half does not depend on libgit2's names, so both halves stay.
  - *Empty.* Today no bridge function reaches `git-reader`, so the read passes with nothing to find.
    Its value is that the first build which changes that is the build that says so.
  - *Not covered, and named.* A transport reached through a framework, or through a socket call
    outside the three names. C-R6 bounds the three names as a floor and gives the rest to C-R7's
    scan. The NFDR inherits that bound and claims no more.
  - *Not measured.* No release executable built after `git-reader` merged has been read with `nm`.
    The only measurement on record is the scratch binary `checks/deps.review.md` quotes. I don't know
    whether the claim holds once a Git command is exported. The check that finds out is the read
    itself, on that build.

  **What was close.** Leaving the item for the owner. It would have been right if lowering the claim
  were the only true fold. It is not, and the SDD has already taken the fold that relaxes nothing.

### 3.5 — QC-35 says the product reads nothing outside the grant; libgit2's repository open loads the global, XDG and system Git config, and no unit may turn that off

- **Bucket:** 3. Raised from downstream — an item from a seat that did not write these records
- **Verdict:** raised upstream
- **Why:** The item is two questions with two seats, and it splits. Where the reads are switched
  off, or whether they are accepted instead, is the SDD's, and this verdict covers it: it is raised
  at `docs/SDD_open_issues.md` § 2.1 (`nozoki@4f028c7`), carrying my answer as its proposal. What the
  NFDR states while the SDD decides is mine. That half is answered below, under 2.1, and moved to
  § 2.1 of this companion.

  **The widening rule, first.** This is a correction, with its occurrence cited and re-read at the
  source. The adapter opens at `libgit2.rs:L52`, and every open takes a config snapshot
  (`repository.c:L997`) that adds the global, XDG, system and programdata levels
  (`:L1318`, `:L1324`, `:L1330`, `:L1336`).

  **The item's facts, re-read at the source, and one it did not have.**
  - *Confirmed:* `set_search_path` is an `unsafe fn` (`opts.rs:L23`); `nozoki-core` holds no `unsafe`
    (QC-9; `docs/SDD.md:L336`); only `git-reader` imports the binding (QC-11; `docs/SDD.md:L347`). The
    rules as written leave no unit that may make the call, as the item says.
  - *Sharper than the item:* under the App Sandbox, libgit2 deliberately takes the global level's
    home from the password entry and not from `HOME` (`sysdir.c:L347`, `:L356-L359`). So it reaches
    for the user's real `~/.gitconfig`, outside the container as well as outside the grant. The
    system level is `/etc` (`sysdir.c:L282`). The XDG level reads `XDG_CONFIG_HOME`, then `HOME`
    (`:L402-L405`). Where `HOME` points inside the sandbox I have not measured, so I don't know
    whether the XDG read lands inside the container. The check that finds out is printing `HOME` from
    the sandboxed bundle.
  - *Still unrun, and now with its mechanism:* libgit2 treats an unreadable config file as absent
    and names sandboxed macOS apps as the reason (`config_file.c:L117-L123`). A `stat` refused with
    any errno but `ENOENT` or `ENOTDIR` fails first (`config.c:L143-L147`), and a failed snapshot
    fails the open (`repository.c:L998-L999`). Whether the open survives depends on which errno the
    sandbox returns for a refused `stat`. That is `docs/SDD.md` *Open Questions*' second item, and
    only the bundle run settles it.
  - *The switch works:* a level whose search path is empty is skipped before any file is touched
    (`sysdir.c:L559-L560`).

  **Check 1: the seat, asked of each half.**
  - *Where the switch lives, or whether the reads are accepted.* The edit lands in `docs/SDD.md` § 3:
    the units paragraph's two sentences and the `core-bridge` row (`:L330`). QC-9, QC-11 and QC-13
    derive from those sentences, so writing an exception into the NFDR first would make the NFDR
    disagree with its source, which this seat's posture forbids. Accepting the reads lands in
    `docs/fdr.md` R-101 and C-D1. It lowers a product promise, which is the owner's call. So this half
    is another seat's: raised upstream. The answer I carried there: keep R-101, and have the bridge
    empty the four levels' search paths at the composition root before the adapter is wired. The
    bridge is already the one unit that holds `unsafe` and the one place the adapter is wired (QC-17;
    `docs/SDD.md:L330`), and keeping `unsafe` out of the core keeps the property the units paragraph
    is built on.
  - *What QC-35 says meanwhile.* The edit lands in QC-35's tail. It is mine, and it does not depend
    on which reading the SDD takes. That half moved out (2.1, below).

  **The split's three conditions.** The halves are separable: naming a known hole does not presuppose
  how it is closed. They resolve to different seats. And the reachable half is reached, under 2.1.
  The check the item asks for ("add the check that shows it") stays with the SDD's half, because
  which check it is depends on the reading taken.

  **Check 3: against the settled record.**
  - `docs/SDD.md` *Open Questions*' second item asks whether libgit2 opens under a read-only grant. It
    does not name the config levels. The upstream item names them as the side the question is met
    from, and it moves no slice.
  - SDD § 11 R-15 already prices patching the vendored build for transports. The upstream item names
    that as an alternative rather than proposing it twice.
  - `docs/trail/sdd/self_answer-33.md` § *Weighed and not raised* expected this: "The Principal
    Architect's answer to § 3.5 raises an SDD item if a rule here has to move." A rule does have to
    move, under every reading but lowering R-101.
  - § 2.2 of this companion, raised below, carries the environment reads the switch does not remove.

  **Check 4: the failure paths** (of the proposal carried upstream).
  - *Concurrent.* `set_search_path` is not thread-safe (`opts.rs:L20-L22`). Made once at the
    composition root before the adapter is wired, it runs before any thread can reach libgit2.
  - *Absent.* With all four levels empty, an open reads the repository's own config alone, inside
    the grant. A repository whose behaviour depends on the user's global config (an `include`, a
    `safe.directory`) reads as Git with no global config. That is the read-only viewer's intent.
  - *Stale.* `set_search_path` initialises the library first (`opts.rs:L27`), and every level is
    guessed at init (`sysdir.c:L458-L459`). So `HOME`, `XDG_CONFIG_HOME` and
    `APP_SANDBOX_CONTAINER_ID` are still read. They open no file. That is § 2.2's.
  - *Not covered, and named.* `nozoki-core`'s in-process cases do not pass through the bridge and
    still read the machine's config files.

  **What was close.** Leaving the item for the owner, since lowering R-101 is theirs. It did not carry,
  because a reading exists that lowers nothing and is the CTO's to draw. The owner meets the lowering
  only if the SDD round rejects that reading.

### 2.1 — QC-35 says nothing is read outside the grant, while libgit2's repository open reads the global and system Git config; until the SDD answers, QC-35 names those reads as an uncovered case

- **Bucket:** 2. Choices to confirm — the Principal Architect drafted a best-effort answer; confirm or override
- **Verdict:** answered
- **Why:** This is the half of § 3.5 the split moved out. § 3.5 is raised upstream, as its entry
  above says. My answer to this half: QC-35's tail names the config reads as an uncovered case,
  points at `docs/SDD_open_issues.md` § 2.1 for their repair, and says what holds the reads half
  today. Its slot in the companion stays at its placeholder: the reasoning is this run's, and the
  decision is the next round's.

  **Check 1.** The edit lands in QC-35 and § 10's QC-35 row. It binds no person and moves nothing
  upstream. Mine.

  **Check 2.** The question is whether a record should state a known hole before its repair is
  decided. It should. QC-35 is read as a fixed reference by the change that will export `probe`, and
  an unqualified "reads nothing outside" tells that change something false.

  **An addition the item did not ask for, in the same entry.** QC-35's verification is
  `checks/own-state.sh`, `checks/read-only.sh` and the sandbox grant (`docs/nfdr.md:L718-L721`). The
  first two observe writes: changed files under `$HOME`, and hashes of the fixture. Neither observes a
  read. The reads half is held by the sandbox alone, and the tail should say so. Otherwise a read the
  sandbox allows would pass every listed check. Whether the sandbox allows reading `/etc/gitconfig` I
  don't know. The check that finds out is the bundle run of *Open Questions*' second item.

  **Check 3.** No upstream sentence moves. The entry points at the SDD item and does not pre-empt
  it. If the SDD takes the bridge reading, the uncovered case is removed on the re-derivation and
  QC-35 gains that reading's evidence. If the owner lowers R-101 instead, QC-35's statement changes
  with it. Both happen in a later round.

  **Check 4.** *Stale:* the uncovered case names the SDD item by path, so it goes stale when that
  item folds. The re-derivation is what removes it, and the clause says so. *Empty*, *concurrent*,
  *refused*: not reached by a statement of a known gap.

## Left for the owner

None this run.

## Skipped

None this run. The companion held five items, each with its slot at the placeholder, and every one
was decided.

## Raised on this document

### 2.2 — Two NFDR statements went false when `git-reader` linked libgit2: QC-30's boundary set misses libgit2's C environment reads and its config-file reads, and QC-9 still says "when `git-reader` links it"

- **What the document is owed:** QC-30 names a C `getenv` in a linked crate as uncovered, with
  libgit2's three init-time reads as its members and review as their gate, and points at the config
  reads' item. QC-9 states libgit2 as linked.
- **Why it is worth a cycle:** *A fact in it is now false*, the first ground of
  `decide_companion_answers.md` § *The items are not the whole of what a document is owed*. QC-30
  calls the set "exactly" what it lists, and libgit2 reads `APP_SANDBOX_CONTAINER_ID`, `HOME` and
  `XDG_CONFIG_HOME` at init (`sysdir.c:L347`, `:L357`, `:L402-L405`, `:L458-L459`), which are not
  listed. `checks/entry-points.sh:L66` admits the scan cannot see a C `getenv`, and
  `checks/entry-points.allow:L29` admits the reads are "not held here". QC-9 says libgit2 is linked
  "when `git-reader` links it", and `crates/nozoki-core/Cargo.toml:L9` has linked it since
  `nozoki@126ef75`. A grep for `getenv` in the C sources of every crate `cargo tree --locked
  -p nozoki-bridge -e normal` resolves finds two crates. One is libgit2-sys, with the reads above.
  The other is libz-sys, in its vendored zlib-ng (`src/zlib-ng/arch/arm/arm_features.c:L36`,
  `QEMU_EMULATING`). libz-sys entered the tree only through libgit2-sys, with its `libc` feature
  (`cargo tree -e features -i libz-sys`), and reached `checks/deps.allow` in the same change
  (`8eea114`). Whether that zlib-ng file is compiled into this build I did not establish, so the item
  names libgit2's three reads and leaves that one to the fold's own measurement. Either way, the gap
  opened with the git binding. It is one item and not two because both go false at the same commit and belong to the same
  fold.

## Companions opened

- **`docs/SDD_open_issues.md`** — **opened** — companion to `SDD.md`, landed in commit `4f028c7`

## Launchers owed

- **`docs/adr/` and `docs/nfdr.md`** — `<CORE>/launchers/skill/launcher.sh product-architecture nozoki`
- **`docs/SDD.md`** — `<CORE>/launchers/skill/launcher.sh product-sdd nozoki`
