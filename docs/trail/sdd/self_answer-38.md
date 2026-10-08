# Self-answer report — `docs/SDD.md`

## Header

- **Companion:** `docs/SDD_open_issues.md`
- **Document:** `docs/SDD.md` (v30, Settled)
- **Decided by:** `decide_companion_answers.md` v1.3.0
- **Date:** 2026-10-04
- **Sources re-read:** None. Every answer rests on `docs/SDD.md` and on the product's own tree at
  `ka-reader@0aab3e7`, and on no source outside this repository. The SDD's statements about libgit2's
  own source are quoted from the SDD where an answer mentions them, and no answer depends on one.

**What this run read, and what it did not.** `docs/SDD.md` was read in full for its header, § 3
(`:L311-L495`), § 4 from C-R6 to C-I3 (`:L600-L769`), § 6 S-4, the head of § 10 and RC-4, § 11 R-15
and R-16, and *Open Questions*. The rest was searched for `RC-4`, `R-16`, `ka_reader_read_git`,
`StatusLists` and the commits the items pin, and was not read whole. `docs/PRD.md`, `docs/SRS.md`
and `docs/UXD.md` were not re-read: no answer moves a requirement or an experience entry. A
contradiction with a part not read is therefore not excluded.

**What this run measured.** The code under `crates/`, `checks/` and `ka-reader-mac/` is the same at
`ka-reader@0aab3e7` as at `ka-reader@392177d`; the two commits between them change `docs/` only (`git log
--oneline -3`). At `ka-reader@0aab3e7`:

- `cargo test --locked -p ka-reader-bridge --test search_path` printed `test result: ok. 1 passed; 0
  failed`.
- `ka-reader-mac/assemble.sh` exited 0, and `checks/view.sh` exited 0 on its output, printing "links
  no WebKit or JavaScriptCore and carries no Git transport — nothing found".
- `nm` on `target/release/bundle/macos/KA-Reader.app/Contents/MacOS/KAReader` printed four `_ka_reader_`
  symbols: `_ka_reader_free`, `_ka_reader_list_tree`, `_ka_reader_open_folder`, `_ka_reader_select_file`. It
  printed no `_ka_reader_read_git`.
- The same `nm` output holds 731 defined `_git_` symbols, among them `_git_repository_open_ext`,
  `_git_status_list_new` and `_git_libgit2_opts`. It holds no `git_smart_subtransport_` symbol and
  no undefined `_connect`, `_socket` or `_getaddrinfo`.
- The same output defines three symbols with a transport or stream name:
  `_git_socket_stream_global_init`, `_git_stream_registry_global_init` and
  `_git_transport_ssh_libssh2_global_init`.
- `grep -rn 'ka_reader_read_git\|read_git' ka-reader-mac/Sources` printed nothing.
- `grep -rn 'set_search_path\|search_path' crates/ka-reader-core checks` printed nothing.
- `grep -rn 'include.path\|excludesfile\|attributesfile' checks/fixtures crates checks/*.sh
  checks/tests` printed nothing.
- `git tag` printed nothing.

## Items worked

### 5.1 — § 3 `GitState` says the model holds `HeadState` and nothing else; it now holds both lists

- **Bucket:** 5. Raised from downstream — an item from a seat that did not write the SDD
- **Verdict:** confirmed with addition
- **Why:** The item's "likely fold" is a lean, so it was weighed as a draft. It holds, and three
  things are added.

  **Whose it is.** The item's `Seat:` is `cto`. The edit lands in one entity of § 3 *What the system
  holds*, which is the CTO's part of the SDD. It binds nobody outside the document.

  **It is a correction, not a widening.** The entity states that the model "holds the port's
  `HeadState` and nothing else" (`docs/SDD.md:L486`). The tree says otherwise: `pub struct GitState`
  holds `head: HeadState` and `status: StatusLists`
  (`crates/ka-reader-core/src/folder_model.rs:L169-L172`).

  **The draft holds.** One read fills both: the model asks `state`, then `status`, and builds
  `GitState { head, status }` (`crates/ka-reader-core/src/folder_model.rs:L300-L306`).

  **Addition (a), the failed part.** The draft says "from one read" and does not say what a failed
  half does. The code asks `status` only if `state` succeeded, and either failure makes the whole
  Git item `failed`: "never a root missing an element"
  (`crates/ka-reader-core/src/folder_model.rs:L269-L272`). § 4 C-I1 speaks of a failure to read "one
  part of Git state" (`docs/SDD.md:L688`), and a reader could take that as a `GitState` with one
  list missing. The entity now says there is no such value.

  **Addition (b), what is still only the design.** The sentence being removed was the entity's one
  statement of the gap between the design and the tree. Removing it whole would read as "everything
  listed here is built". The history window, the `Diff` and the tree's changed marker are not in
  the model, so the entity says so.

  **Addition (c).** The rest of the entity stands. The model defines the type and the port never
  returns it, as SM-2 says (`docs/SDD.md:L423`).

  **On the failure paths.** *Empty:* a clean repository gives two empty lists inside an `observed`
  root, which the entity already allows. *Absent and refused:* covered by addition (a). *Stale:* the
  entity's pin moves to the commit of the fold, so a later change to the struct is a re-measurement
  and not a contradiction. *Concurrent:* not touched; which side orders two asks stays where § 3's
  `surfaces` row leaves it (`docs/SDD.md:L336`).

  **What would have tipped it.** Had the model held the lists in a second item with its own state,
  the entity would need two items and C-I1 would apply to each. It does not: there is one item.

### 5.2 — § 4 C-I3 leaves the core suites' isolation to "the change that builds the switch"; that change built it and isolated nothing

- **Bucket:** 5. Raised from downstream — an item from a seat that did not write the SDD
- **Verdict:** confirmed with addition
- **Why:** The item's "likely fold" is a lean, so it was weighed as a draft. It holds, and three
  things are added.

  **Whose it is.** The item's `Seat:` is `cto`, and the edit lands in § 4 C-I3 and one sentence of
  C-R6, both the CTO's. What it decides is how the product's own test suites are configured on a
  developer's or a runner's machine. It commits nothing to a reader of the shipped bundle: the
  bundle runs the switch before the adapter is wired, and `docs/SDD.md:L334` states that.

  **It is a correction.** C-I3 hands a design to "the change that builds the switch"
  (`docs/SDD.md:L729-L730`). That change has landed and designed no isolation. The sentence now
  points a reader at a design that does not exist.

  **The draft holds.** Its two halves were each checked. The core suites run with no switch: no
  file under `crates/ka-reader-core` or `checks` names `search_path` (the grep in the header). The
  shipped answers are proved after the switch: `crates/ka-reader-bridge/tests/git_item.rs:L1-L3` says
  the real adapter is reached only through `Session::default()`, and
  `crates/ka-reader-bridge/tests/search_path.rs:L45-L47` says that session's open is the process's
  first arrival at the switch.

  **Addition (a), the walk.** The draft names the core suites and stops. `checks/walk.rs:L292` calls
  `read_git(FolderModel::new(opened), &Libgit2)`, and nothing in `checks/` runs the switch. C-I3
  rests the read-only promise on `checks/read-only.sh` printing `unchanged`
  (`docs/SDD.md:L716-L719`). For a Git fixture that proof is made with the machine-level reads on,
  which is not how the bundle runs. I know of no way the two configurations differ in what they
  write, and I did not test for one. A proof made under one configuration and claimed for another
  is a limit, and the writing bar asks that a limit sit beside its claim
  (`system/doctrine/writing_bar.md` § 1.6, in the instance).

  **Addition (b), why no isolation is designed now.** The item asks for a false sentence to be
  corrected. It does not ask the SDD to design the isolation, and it cites no suite answer that
  differed. Designing it here would add a requirement on the strength of a case nobody has seen.
  The answer names the trigger: a measured difference. This is the reading I was closest to
  changing. If the walk's hash is ever shown to differ with the reads off, the walk goes through
  the switch and this becomes a check.

  **Addition (c), two neighbouring sentences.** `docs/SDD.md:L745-L746` and `:L636-L637` say the
  switch, its test and the bridge manifest's `git2` line are still to land. Each is pinned to
  `ka-reader@f471a9e` and so is literally true of that commit. A reader takes them as the present
  state, as the PM took the sentence in item 5.3, which is pinned the same way. They are the same
  landed change as this item, so they ride this answer and no separate item is raised.

  **On the failure paths.** *Empty:* a machine with no global config gives the same answers in
  both configurations, which is why no suite has differed. *Absent:* a failed switch leaves the
  adapter unwired and the Git item `failed` (`docs/SDD.md:L334`); the core suites never reach that
  path, and the bridge's suite does. *Stale:* covered by re-pinning. *Concurrent:* the search paths
  are process-global, which is why `search_path.rs` is its own test binary
  (`crates/ka-reader-bridge/tests/search_path.rs:L3-L4`); any later isolation of the core suites meets
  the same constraint, and the answer leaves that to the change that does it. *Refused:* not
  reached.

### 5.3 — § 4 C-I3 says the `nm` transport read is not in `checks/view.sh`; it is

- **Bucket:** 5. Raised from downstream — an item from a seat that did not write the SDD
- **Verdict:** confirmed with addition
- **Why:** The item's "likely fold" is a lean, so it was weighed as a draft. Its conclusion holds.
  One of its supporting sentences is true and incomplete, and four things are added.

  **Whose it is.** The item's `Seat:` is `cto`. The edit lands in § 4 C-I3, § 11 R-15 and § 10
  RC-4's *Still unresolved*, all the CTO's. The claim the read supports is a product decision the
  SDD quotes from `docs/fdr.md` PD-27 (`docs/SDD.md:L2758-L2759`). This answer does not restate or
  lower that claim. It records what evidence now exists for it.

  **It is a correction.** C-I3 says "The read is not in the script at `ka-reader@814a369`"
  (`docs/SDD.md:L736-L737`). The read is at `checks/view.sh:L379-L404`, and its red cases are
  `checks/tests/test_view.sh:L58-L64`.

  **Where the draft is incomplete.** The item says the read "has met only a build where the new
  export is dropped by the linker". That is true: `nm` prints no `_ka_reader_read_git`. It reads as
  though no libgit2 code were in that executable. This run built the bundle and looked. The
  executable defines 731 `_git_` symbols, `_git_repository_open_ext` and `_git_status_list_new`
  among them. So the read has already met libgit2 linked in, and passed. The item's text is left
  as the PM wrote it.

  **Addition (a).** C-I3 states the claim at the strength the measurement supports: proved for an
  executable that links libgit2's open and status code, and not yet read on one that links the
  export. The draft's "proved for the linked export once the shell calls it" is kept.

  **Addition (b), R-15.** R-15 says whether the link drops the transports "has not been measured
  on this product" (`docs/SDD.md:L2750-L2751`). It now has been, on one build. Leaving R-15 as
  written would contradict the corrected C-I3 two sections away. R-15 is not closed. Its *shows up
  as* names "the first release build after a Git command is exported" (`docs/SDD.md:L2754-L2755`).
  That build was green, and the export was not in it. The build that links the export is the one
  R-15 is still waiting for.

  **Addition (c), three symbols.** The executable defines `_git_socket_stream_global_init`,
  `_git_stream_registry_global_init` and `_git_transport_ssh_libssh2_global_init`. The read's
  pattern is `git_smart_subtransport_` (`checks/view.sh:L399`) and matches none of them. The
  executable imports none of `connect`, `socket` or `getaddrinfo`, so nothing behind those names
  can open a connection through those calls. I did not read what the three functions do. C-R6
  already says "The three names are a floor" (`docs/SDD.md:L631-L632`). A stranger who runs `nm`
  on the release and greps for "transport" finds one of these, and the SDD says nothing of it
  today. The answer asks for them to be named. It does not ask for the read's pattern to widen: no
  occurrence of a network call behind them is cited.

  **Addition (d), RC-4.** The item names RC-4's list (`docs/SDD.md:L2630-L2634`). The same list
  opens with "When the model reads Git state — at open or on the first ask — and whether an ask on
  a `failed` item reads again" (`:L2625-L2626`). The build settled both:
  `crates/ka-reader-bridge/src/session.rs:L650-L653`. A fold that dated three of the list's entries
  and left the first standing would leave the list half current. The form is a dated parenthesis,
  which the version line records for RC-2 and RC-3 (`docs/SDD.md`, the `Version 18` entry of the
  header).

  **Against the settled record and my other answers.** This answer and 5.4's both name one build:
  the one in which `mac-shell` first calls `ka_reader_read_git`. They were decided together. C-R6's
  words on what is claimed stand.

  **On the failure paths.** *Empty:* `nm` printing no symbol is red
  (`checks/tests/test_view.sh:L64`). *Absent:* `nm` missing or failing is red (`:L62-L63`).
  *Stale:* this run's measurement is of one build at `ka-reader@0aab3e7`; the fold pins it, and the
  read re-runs on every build. *Concurrent:* not reached. *Refused:* a red read is R-15's
  response, a re-cut recorded before anything is built on the export.

### 5.4 — R-16's settling deadline has passed: the first export reaching `git-reader` shipped without it

- **Bucket:** 5. Raised from downstream — an item from a seat that did not write the SDD
- **Verdict:** answered
- **Why:** The item gives two routes and no lean, so it was answered from scratch. The item stays
  in `see-git-status`, and its bound moves to the build in which `mac-shell` first calls
  `ka_reader_read_git`.

  **Whose it is.** The item's `Seat:` is `cto`. I asked whether it is the owner's instead, because
  R-16 is a read outside the granted folder and `docs/fdr.md` R-101 is quoted against it
  (`docs/SDD.md:L328`). It is not, for a reason that can be checked. The answer changes when a
  question is settled, and not whether the read is allowed. In the bundle "the wall is C-R2's and
  it is the only bound, so no byte outside the grant is read there" (`docs/SDD.md:L2771-L2772`),
  and the answer leaves that as it stands. Nothing has been released: `git tag` prints nothing. If
  form two is found, a reader sees a new condition, and the *Open Questions* item already says that
  is written into `git-reader`'s row and R-16 before it is built (`docs/SDD.md:L5569-L5571`). That
  later step is where a call for another seat could arise. This one is not it.

  **One question, not two.** The item notes that neither form is chosen. Choosing the form is not
  asked here and is not answered. RN-87 placed it in *Open Questions* on purpose: "How R-16 is
  closed is an Open Question and not a companion item" (`docs/SDD.md:L5258`). It is settled by a
  fixture and a case, in the slice.

  **Why it stays in the slice.** The read R-16 names is made by the repository open and the status
  read, and those are the calls `see-git-status` delivers. Moving the item out would let the slice
  close with § 4 C-D1 standing as "a stated limit … outside the sandbox, not a held property"
  (`docs/SDD.md:L2774-L2775`) for the one slice that introduces the read.

  **Why that build.** The first bound was chosen because an export reaching `git-reader` was
  taken to be the moment a repository is first opened through the bridge. The build showed those
  are two moments. The bridge reads the Git item "on the first ask after each successful open"
  (`crates/ka-reader-bridge/src/exports.rs:L102-L103`). No Swift source asks:
  `grep -rn 'ka_reader_read_git\|read_git' ka-reader-mac/Sources` prints nothing, and the release
  executable holds no `_ka_reader_read_git`. So no repository has yet been opened by the bundle. The
  first build in which the shell calls the export is the first in which a reader's own repository
  reaches libgit2. That is the moment the first bound was aiming at.

  **Why the passed bound is recorded.** The SDD's § 10 says a contradiction is recorded before it
  is redrawn (`docs/SDD.md:L2373-L2374`). This is not a re-cut by that section's four triggers: no
  *Reached when* is unmet, and no slice moved. It is recorded with a dated note in *Open Questions*
  and in RC-4, for the same reason.

  **Against the settled record and my other answers.** 5.3's answer names the same build for the
  `nm` read's first meeting with the linked export. The two were decided together. 5.2's answer
  says the harness walk runs with the machine-level reads on; that is R-16's neighbour and not
  R-16, which is about the repository's own config.

  **On the failure paths.**
  - *Empty:* no fixture carries one of the three keys, so the harness reads no outside path today.
    That is also why no case can pass or fail yet.
  - *Absent:* in the harness `checks/walk.rs:L292` opens Git fixtures through libgit2 with no
    sandbox. Until the item is settled nothing bounds a config-named read there, as R-16 says.
  - *Stale:* the first bound passed with no check noticing, and the PM found it by reading. The
    new bound is held the same way, by review. The answer says so in those words.
  - *Concurrent:* not reached.
  - *Refused:* whether the open or the status read survives the sandbox refusing a config-named
    path "has not been run" (`docs/SDD.md:L2770-L2771`). The build this answer names is the first
    where it can be run on the bundle.

  **What would have tipped it.** If a Swift caller already linked the export, the bound would
  have been "the next build", and I would have weighed stopping the slice until then. If form two
  needs a state the UXD does not draw, the item may have to leave the slice. That is a later
  finding, and it would be raised then.

  **One thing in the item's text.** The item says the build "does not settle the item". The build
  could not have: neither form had been chosen before it. The deadline and the choice of form were
  one sentence in *Open Questions*, and only the deadline is answered here.

## Left for the owner

None this run.

## Skipped

None this run.

## Companions opened

None this run.

## Launchers owed

- **`docs/SDD.md`** — `<CORE>/launchers/skill/launcher.sh product-sdd ka-reader`
