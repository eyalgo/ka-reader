# Self-answer report — `docs/SDD.md`

This is the record of one unattended run that answered `docs/SDD_open_issues.md` in the owner's
seat. It is for the owner, who reads it to learn what was decided and why, and for the
`product-sdd` run that folds the answers.

## Header

- **Companion:** `docs/SDD_open_issues.md`
- **Document:** `docs/SDD.md`
- **Decided by:** `decide_companion_answers.md` v1.3.0
- **Date:** 2026-10-03
- **Sources re-read:** One, for § 5.3. The `libgit2-sys 0.18.8+1.9.7` crate as published, read in
  the cargo registry copy on this machine
  (`~/.cargo/registry/src/index.crates.io-1949cf8c6b5b557f/libgit2-sys-0.18.8+1.9.7/`):
  `build.rs:L152-L156` compiles `libgit2/src/libgit2/transports` and `…/streams` with no feature
  condition, under the comment "they're all unconditionally always compiled";
  `libgit2/src/libgit2/transport.c:L32-L36` registers `git://`, `http://`, `https://` and `file://`
  with no `#ifdef`, and `:L38-L42` registers the three SSH schemes under `#ifdef GIT_SSH`. §§ 5.1
  and 5.2 rest on this repository's documents and tree at `ka-reader@136b227`, and on no source
  outside it.

**What this run read, for all three items.** `docs/SDD.md` from its first line through § 4
(`:L1-L954`), § 6 S-4 (`:L1610-L1689`), § 9 (`:L2202-L2288`), § 11 R-1 to R-3 (`:L2500-L2521`),
RN-13 (`:L2892-L2897`), RN-84's closing half (`:L4880-L4945`) and *Open Questions*
(`:L4947-L5000`). The rest was searched for `transport`, `C-R6`, `libgit2`, `SM-2`, `GitPort`,
"the port is", the four fixture names and the pin's commit, and each hit was read. § 5, § 6's other
slices, § 7, § 8, § 10, § 12 and the review notes outside those hits were not read line by line.
Of the SDD's inputs, `docs/SRS.md` NFR-7 to NFR-9 (`:L318-L330`) were read; the PRD and the UXD
were not opened, because no answer moves a requirement or a surface. Downstream of the SDD,
`docs/nfdr.md` QC-3, QC-10 and QC-11, `docs/adr/0004-git-read-through-libgit2-behind-a-port.md`,
`docs/fdr.md` PD-27 and `docs/architecture_open_issues.md` were read whole or at the entry named.

## Items worked

### 5.1 — The `read-only-harness` row lists the four Git fixture scenes as owed; they are on disk

- **Bucket:** 5. Raised from downstream — an item from a seat that did not write the SDD
- **Verdict:** confirmed with addition
- **Why:** The item's likely fold is taken: the four scenes move, each with its archive, from
  *Owed by a slice* to *On disk*. Three things are added. The item carries a lean, its "likely
  fold", so it is weighed as a draft and not answered from scratch.

  **The widening rule, first.** The item sits under the heading carrying *Raised from downstream*.
  It is a correction and not a widening: the row states that four named fixtures are not on disk,
  and they are. The row also asks for this item in its own words, "a file landing in `checks/`
  after that commit … owes this row an item" (`docs/SDD.md:L332`). The change proceeds.

  **Check 1: the seat.** The edit lands in § 3's `read-only-harness` row, which the ownership table
  gives the CTO (`docs/SDD.md:L91`). It binds no person and no outside party and moves no slice's
  bar. I can name no ground I cannot see. The item is mine in the owner's seat.

  **Check 2: the draft.** It holds, and for the reason it gives. `ls checks/fixtures` at
  `ka-reader@136b227` prints `inside-a-repo`, `linked-worktree`, `parent-of-two` and `submodule`, each
  beside a `<name>.git.tar`. `git diff --name-status 7a125b4 136b227 -- checks/` shows all eight as
  added since the pin. The draft is incomplete in three places, which are the additions:

  1. *The pin.* The draft says "re-measure the cell at the current commit". The commit the item
     measured at, `ka-reader@126ef75`, is already two commits behind `HEAD`. So the answer names the
     commit the fold is made on, and asks the fold to measure the tree itself. RN-84 did the same
     the last time this cell moved ("Re-verified before writing, not taken from the item or the
     answer", `docs/SDD.md:L4913`).
  2. *The count.* The cell says "five fixture folders" (`docs/SDD.md:L332`). With four more on disk
     it is nine. A fold that moved the names and left the number would leave the cell false again.
  3. *The slice-owed list.* The four were everything the cell said `see-git-status` owed. Once
     they move, that slice's clause leaves the list. The other slices' clauses stay as they are.

  **What the archives are for.** `crates/ka-reader-core/tests/root_finding.rs:L49` unpacks
  `<name>.git.tar` into a scene of its own, as `:L41` does for `repo.git.tar`. That file is the
  only reader of the four names under `checks/`, `crates/*/tests` and `.github`
  (`grep -rln` for the four names prints it alone). The cell already describes `repo.git.tar` as
  "the `.git` the suites unpack into it", so the same form serves the four.

  **Check 3: against the settled record.**
  - § 6 S-4's command half (`docs/SDD.md:L1650-L1652`) names the six fixtures `root_finding` runs
    over, the four among them. The cell now agrees with the bar instead of trailing it. The bar
    does not move.
  - "`checks` is build-time and never shipped" (`docs/SDD.md:L339`) holds for the eight new paths:
    a test target reads them and nothing in the bundle does.
  - The six other changed paths under `checks/` since the pin are modifications to files the row
    names already: `deps.allow`, `deps.review.md`, `entry-points.allow`, `structure.sh`,
    `tests/test_no_network.sh` and `tests/test_structure.sh`. A modified file is not a file
    landing, so the row's enumeration owes them nothing.
  - `docs/nfdr.md` § 10's linked-tree rows may owe the same re-measurement. That is the Principal
    Architect's, and nothing is raised there from here: the SDD row is not yet folded, and the
    NFDR re-derives from the row once it is.

  **Check 4: the failure paths.**
  - *Stale.* This is the path that matters, and addition 1 answers it. A pin does not update
    itself; the next file under `checks/` still owes the row an item.
  - *Absent.* Three planned scripts and five planned fixture sets stay slice-owed and not on disk.
    The answer strikes none of them.
  - *Empty*, *concurrent*, *refused*: not reached. An ownership cell has no empty case, no second
    actor and nobody to refuse it.
  - One thing the answer does not cover: `linked-worktree` and `submodule` each track one file
    (`git ls-files checks/fixtures/linked-worktree | wc -l` prints 1), and what that file is was
    not read. The cell names folders and archives, and their contents are the fixture's own.

  **What was close.** *Confirmed*, with no addition, was the other verdict. It did not carry
  because the draft's "current commit" names a commit that has already passed, and the cell's
  count would have been left wrong.

### 5.2 — SM-2 says the port is a trait the model owns; the trait and its outcome types live in `git-reader`

- **Bucket:** 5. Raised from downstream — an item from a seat that did not write the SDD
- **Verdict:** confirmed with addition
- **Why:** The item's likely fold is taken: `folder-model` keeps the contract, and SM-2 says the
  trait and its types are held in `git-reader`. Two things are added: the reason, and a rule for
  the types the later Git methods bring. The item carries a lean, so it is weighed as a draft.

  **The widening rule, first.** A correction, not a widening. SM-2 states where the trait is
  owned, and the tree and the SDD's own parts table say otherwise. The occurrence is cited and
  re-read: `pub trait GitPort` is at `crates/ka-reader-core/src/git_reader.rs:L33`, with
  `RootFinding` and `ProbeCondition` below it, and
  `grep -n 'GitPort\|git_reader\|RootFinding\|ProbeCondition' crates/ka-reader-core/src/folder_model.rs`
  prints nothing.

  **Check 1: the seat.** The edit lands in § 3's seams table, the CTO's (`docs/SDD.md:L91`). It
  commits nothing to a person or an outside party. It is mine in the owner's seat. The same
  sentence in ADR-0004 is another document's; that half is already on that document's companion
  (`docs/architecture_open_issues.md` § 3.2), so nothing is opened or appended there.

  **Check 2: the draft.** The conclusion holds. The reason the item gives is `docs/nfdr.md`
  QC-11's "must not import `folder-model`". That reason is true and is one step downstream of the
  real one. The NFDR is derived from the SDD, and the SDD says it itself: "the readers, the watcher,
  the highlighter and the renderer import neither the model nor one another"
  (`docs/SDD.md:L347-L348`). A trait defined in the model would need the adapter to import the
  model to implement it. So SM-2's sentence contradicts the SDD's own units paragraph, and it also
  contradicts the `git-reader` row, whose *Owns* cell opens "The **Git port**" and ends "and its
  one adapter" (`docs/SDD.md:L323`). The SDD has said two things about one port since SM-2 was
  written. The tree took the reading the parts table and the units paragraph give. The fold makes
  SM-2 agree with them. That is addition one: the fold cites the SDD's own paragraph as the
  reason, so a later reader does not inherit a reason that lives only in a downstream record.

  **Addition two, and why it is in the answer.** The item says what turns on SM-2: "every later
  Git station reads SM-2 to decide where the port's methods (`state`, `status`) and their types
  are added". Today the port has one method and two small types. The methods to come return Git
  state, and *What the system holds* lists `GitState` as something the model holds
  (`docs/SDD.md:L471-L475`). A change that read "the model holds `GitState`" as "the model defines
  the type `state()` returns" would put a `folder-model` import into `git-reader`, the same edge
  this item is about. So the answer states the rule for every type that crosses SM-2, and leaves
  to the change which of two homes each type takes: `git-reader`, or a module of `ka-reader-core`
  that is no part. The second home is not invented here. `docs/SDD.md:L433` leaves the physical
  layout to the developer, and `docs/nfdr.md` QC-63 already admits a module that is no part and
  that any part may import.

  **Check 3: against the settled record.**
  - SM-1's owner cell (`docs/SDD.md:L415`): "it states what a read must return; the reader
    implements it". SM-2 now reads the same way. `docs/nfdr.md` QC-11's trace records the same
    reading of SM-1 and contrasts it with SM-2 ("does not hold the types, unlike SM-2's port",
    `docs/nfdr.md:L260-L261`). That contrast goes stale with this fold, and it is the item already
    raised at `docs/architecture_open_issues.md` § 3.2.
  - `docs/nfdr.md` QC-10: "`folder-model` may import `fs-reader`, the Git port trait, …" and "must
    not import the libgit2 binding, `git-reader`'s adapter". The answer's "the model imports the
    trait and never the adapter" is that entry as it stands.
  - The `core-bridge` row (`docs/SDD.md:L329`): "wiring the libgit2 adapter to the Git port". It
    does not move. The bridge wires; the model is handed a port.
  - § 2's hexagonal row and § 9 TO-10 call SM-2 the one port the design keeps. Neither says where
    the trait is defined, and neither moves.
  - § 6 S-4's command half uses "a port double" in `git_state` (`docs/SDD.md:L1656`). A double
    implements the trait from `ka_reader_core`'s public surface
    (`crates/ka-reader-core/src/lib.rs:L15`), wherever the trait is defined. Unaffected.
  - My answer to § 5.1 touches a different table and nothing here bears on it.

  **Check 4: the failure paths.**
  - *A second adapter* (§ 11 R-1, the installed `git`). It lives in `git-reader` beside the first,
    implements the same trait, and passes the same contract tests. The contract tests are what
    "the model owns the contract" means in practice, and the answer keeps that clause.
  - *Stale.* Addition two is the stale case: SM-2 is read again each time a method is added.
  - *Absent.* On a plain folder the port answers `plain` and no further type crosses. Nothing to
    add.
  - *Empty*, *concurrent*, *refused*: not reached by a statement of where a trait is defined.

  **What was close.** A third placement was weighed: the trait and its types in a module that is
  no part, so that neither the model nor the reader "holds" the port. It was not taken as the
  rule. The tree has the trait in `git-reader`, the parts table gives the port to `git-reader`,
  and moving landed code needs a reason the documents do not supply. It is kept as an allowed home
  for a type, where a later change finds a reason.

### 5.3 — C-R6 says no shipped unit links a network transport; the vendored libgit2 compiles its `git://` and `http://` transports unconditionally

- **Bucket:** 5. Raised from downstream — an item from a seat that did not write the SDD
- **Verdict:** answered
- **Why:** C-R6 keeps its claim, moves it to the level where it can be true, and names the check
  that proves it there. The item offers two folds and picks neither, so it is a question and not a
  draft, and it is answered from scratch. The answer is the item's second fold with its first
  fold's facts stated beside it.

  **The widening rule, first.** A correction, with its occurrence cited and re-read at the source.
  C-R6 says "no shipped unit links a network transport" (`docs/SDD.md:L600`). § 3 names
  `crates/ka-reader-core` as a unit (`docs/SDD.md:L395`). That unit now compiles libgit2's transports
  in: `libgit2-sys 0.18.8+1.9.7`, the version `Cargo.lock:L122-L123` resolves, adds
  `libgit2/src/libgit2/transports` and `…/streams` with no condition (`build.rs:L155-L156`). So
  the sentence is false of a unit as written, and unproven of the executable. The check the answer
  adds is what makes the corrected sentence true. It is not a new requirement.

  **Check 1: the seat.** The edits land in § 4 C-R6 and § 3's `git-reader` row, both the CTO's
  (`docs/SDD.md:L91-L92`). Whether the item is mine turns on which fold is taken, so the folds
  were weighed before the seat was settled.
  - *The first fold* states the claim lower: no TLS, no SSH, the plain transports compiled in and
    never called. That lowers a stated security property. `docs/fdr.md` PD-27 carries the property
    as a product decision, "Nothing the product ships carries a network transport"
    (`docs/fdr.md:L294`). Lowering it is a security trade-off and a change to what the product may
    claim. That call is the owner's and not this seat's.
  - *The second fold* keeps every statement upstream and downstream true and binds only this
    document and its harness. That is mine.

  The second fold is taken, so the item is mine in the owner's seat. The first fold's call stays
  the owner's, and the answer says when it would arise.

  **Check 2: the question.** It hides a second one, with the same seat. The item asks which fold.
  It also shows, without saying so, that the first half of C-R6's sentence is loose. "Built
  without its HTTPS … transport" is not what the source shows: `https://` is registered with no
  guard (`transport.c:L35`), and what is absent is the TLS stream behind it. Both questions are
  the CTO's, so both are answered in the one slot: statement (1) restates the first half as what
  the build holds, features off and no TLS backend or libssh2.

  **Why the second fold, on its merits.**
  - The instance's own posture for this seat: "No network code linked when no network is
    promised" (`system/loaders/cto.md`, § *The domain*, in the kensaiapp-opensource instance). A
    claim of "compiled in and never called" is held by convention. A claim about what the shipped
    executable links is held by structure and can be shown.
  - `checks/deps.review.md`'s `libgit2-sys` row already reached the same place: "the property that
    holds is at the shipped executable's link, not at the build of the library", and "the bundle
    owes `nm` evidence". The SDD is the authoring surface (`docs/SDD.md:L494-L501`), so the claim
    and its evidence belong in C-R6 and not only in a review file.
  - § 3 says the product ships as one executable (`docs/SDD.md:L424-L428`). "Shipped unit" then
    has one honest referent, and the claim is checkable against it.

  **What was measured here, and what was not.**
  - `cargo tree --locked --offline -p ka-reader-core --prefix none | grep -Ei
    'openssl|native-tls|rustls|libssh2|schannel|security-framework'` prints nothing at
    `ka-reader@136b227`.
  - `crates/ka-reader-core/src/git_reader/libgit2.rs:L90-L95` asserts `!version.https()` and
    `!version.ssh()`.
  - `nm -u ka-reader-mac/.build/out/Products/Debug/KAReader` (built 2026-10-03 20:11) lists `_connect`,
    `_getaddrinfo` and `_socket`. The same file holds no symbol containing `git_` and 77
    containing `std3net`. So a debug executable imports the three through Rust's standard
    library, with no libgit2 in it. That is why the import half is bound to the release
    executable.
  - `nm -u` on `ka-reader-mac/.build/out/Products/Release/KAReader` and on
    `target/release/bundle/macos/KA-Reader.app/Contents/MacOS/KAReader` (both built 2026-10-02 21:39,
    before `git-reader` merged) lists none of the three. So a release executable can pass the
    import half. These two say nothing about libgit2, which they predate.
  - **Not measured:** a release executable built at `ka-reader@136b227` or later. I don't know
    whether it defines a transport symbol. The check that finds out is a release build followed by
    `nm` on the executable, which is the check the answer puts in the harness. The only evidence
    on record is the architect's scratch measurement that `checks/deps.review.md` quotes, and this
    run did not re-run it. `crates/ka-reader-bridge/src` names nothing of `git-reader` today
    (`grep -rn 'git_reader\|GitPort\|Libgit2' crates/ka-reader-bridge/src` prints nothing), so no
    shipped code path reaches libgit2 yet.

  **Check 3: against the settled record.**
  - `docs/SRS.md` NFR-8 (`:L321-L327`): "makes no network call during operation". It is a
    requirement about calls. § 4 C-R2 holds it at the operating system. C-R6's sentence is a
    second line, and the answer says so, so that nobody reads the link check as the wall.
  - `docs/fdr.md` PD-27 stays true under the answer, since it speaks of what the product ships.
  - § 6 S-4's command half, "names it and still no TLS or SSH crate (C-R6)"
    (`docs/SDD.md:L1649-L1650`): statement (1) is that same evidence. No slice's bar moves; the
    new check is inherited through C-I3 like every other script.
  - § 4 C-R7 (`docs/SDD.md:L628-L629`): `checks/view.sh` already runs `otool -L` on the built
    executable. The answer puts the `nm` read beside a check of the same kind on the same file,
    and leaves the choice of script to the fold, where C-I3 names it.
  - My answer to § 5.1: if the fold kept the check in an existing script, the harness row gains
    no file. If it chose a new script, that script would be one more name for the re-measured
    cell. The two answers do not conflict either way.
  - `docs/nfdr.md` QC-3 and ADR-0004 carry the same sentence. Both are the Principal Architect's
    and both are already raised at `docs/architecture_open_issues.md` § 3.4, which offers the same
    two folds. Where the two documents disagree after their folds, the § 4 statement wins and the
    NFDR is re-derived (`docs/SDD.md:L498-L499`). Nothing is opened or appended there.

  **Check 4: the failure paths.**
  - *Refused.* The check turns red once a Git command is exported and libgit2's transport code is
    pulled into the executable. Then the claim is false of what ships. The answer names what
    follows: a re-cut in § 10, and the choice between changing the build and lowering the claim.
    Lowering it is the owner's.
  - *Absent.* No built executable, or no `nm`. The check must fail and not pass having read
    nothing, as `checks/view.sh` already does for `otool` (`checks/view.sh:L20-L21`). The fold
    inherits that rule with the script.
  - *Stale.* A libgit2 version that renames its transport symbols would pass the symbol half
    silently. The import half does not depend on libgit2's names, which is why the answer keeps
    both halves.
  - *Empty.* Today's case: nothing reaches libgit2, and the check passes with nothing to find. It
    still runs, so the first build that changes that is the build that says so.
  - *Not covered, and named:* a transport reached through a socket call outside the three, or
    through a framework. `ka-reader-mac/Package.swift:L35-L37` now links `z`, `Security` and
    `CoreFoundation` for libgit2. `Security` is not a transport, and § 4 C-R7's link list names
    only `WebKit` and `JavaScriptCore`. Whether that list should say anything about `Security` was
    not weighed here.

  **One error in the item's supporting text, reported and not corrected.** The item says the
  transport table registers `git://` and `http://` with no `#ifdef`. It registers `https://` the
  same way, at `transport.c:L35`. The answer is written to the fuller fact.

  **What was close.** Leaving the item for the owner was the other outcome. It would have been
  right had the first fold been the only one that could be true. It is not: the second fold is
  achievable on the evidence on record, and it relaxes nothing. What would tip it: a release
  build whose executable defines `git_smart_subtransport_git`. From that point the item is the
  owner's, and the answer I would hand them is to keep PD-27 as written and patch the vendored
  build before stating the claim lower.

## Left for the owner

None this run.

## Skipped

None this run. The companion holds three items, and each slot was at its placeholder.

## Weighed and not raised

Two things, recorded so the owner can overrule the judgment.

- *On `docs/SDD.md` itself.* `docs/architecture_open_issues.md` § 3.5 says libgit2's repository
  open reads the global and system Git config, outside the grant, and that no unit may make the
  call that stops it. The rules it cites come from § 3's units paragraph and § 4 C-D1. No SDD
  sentence is false because of it: the rules stand, and *Open Questions*' second item already
  holds the question of libgit2 under the grant. The Principal Architect's answer to § 3.5 raises
  an SDD item if a rule here has to move. This run did not verify § 3.5's citations.
- *A garbled sentence at `docs/SDD.md:L585-L586`,* "The runtime does is not forced by the stack".
  It is a wording slip that misleads no reader about the floor. It is not worth an item, and this
  run may not edit the document.

## Companions opened

None this run.

## Launchers owed

- **`docs/SDD.md`** — `<CORE>/launchers/skill/launcher.sh product-sdd ka-reader`
