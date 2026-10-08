# SDD open issues — KA-Reader

> Companion to `SDD.md`. The CTO wrote the SDD; this file holds what that run could not settle from
> its inputs (the PRD, the SRS, the UXD, and any context or constraints), and the calls that are the
> CPO's or the CDO's to make. An item whose call is the CPO's or the CDO's carries that seat's
> `Seat:`; an item whose call is the CTO's carries `cto` or no `Seat:` field.
>
> **Answer inline** — fill each **Answer** / **Confirm or override** / **Keep or re-cut** /
> **Your call** slot — **commit this file**, then re-run `product-sdd`. It folds your answers into
> the SDD and drops the resolved items. When nothing is left open, `product-sdd` **deletes this
> file**: no file = the SDD is done.
>
> Your answers are never thrown away. Each time `product-sdd` folds them in, it first copies this
> file whole to `docs/trail/sdd/` — so what you decided, and why, stays readable and citable for good.
>
> **An item may name the seat that answers it.** Any item in any section carries an optional
> `- **Seat:** <seat>` field beside its other fields. Its value is the name of the agent whose posture
> answers the item — `cto`, `cpo` or `cdo`. An item with no usable value, whether the field is absent,
> empty or still the `<seat>` placeholder, is answered in the seat of the skill that produced this file.
> The field names the *answering* seat. It is not the seat that raised the item (`Raised by:` /
> `Held by:`), and it is not the document an answer belongs to.
>
> **An item in §§ 1–3 names the seat that raised it.** An item the CPO raised is a product call and
> an item the CTO raised is a technical one, and the answer that settles one does not settle the
> other. **§ 4 names two seats and no raiser** — a
> disagreement is not something one seat asked, it is two positions held by different seats, and the
> answer that settles it picks between them.
>
> **§ 5 names a raiser from outside the SDD's lanes entirely.** §§ 1–4 are all the SDD's own three
> lane seats; § 5 is a seat that never held a lane in it, reading it long after it settled and
> finding something only the SDD can fix. Its `Raised by:` therefore takes a wider set than §§ 1–3's,
> which stay fixed to the three lane seats on purpose.

> **No `product-sdd` run wrote this file.** The PM opened it on 2026-10-04 from the SDD's own companion
> template. The bridge now runs the config search-path switch and exports `ka_reader_read_git`
> (`ka-reader@392177d`). Four statements of the SDD were true of the tree before that build and are not
> true of it now. The SDD is Settled, and with no companion on disk a `product-sdd` re-run reads it as
> done and has nothing to act on. Its four items are in § 5.

---

## 1. Open issues — questions with no answer yet

None.

## 2. Choices to confirm — a best-effort answer was drafted; confirm or override

None.

## 3. Cut calls to confirm — where the slicing could reasonably have gone another way

None.

---

## 4. Disagreements — two seats hold different positions and neither yields

None.

## 5. Raised from downstream — an item from a seat that did not write the SDD

### 5.1 § 3 `GitState` says the model holds `HeadState` and nothing else; it now holds both lists
- **Raised by:** PM — 2026-10-04
- **Seat:** cto
- **Tracked by:** `ka-reader · nemawashi · 2026-10-02_git-says-what-changed`
- **What it blocks:** nothing fails. The Git view and the tree's markers read the entity to learn what
  the model holds, and the entity says the lists are not in it.
- **Where it shows:** § 3 *What the system holds*, `GitState` (`docs/SDD.md:L485-L487`): "it holds the
  port's `HeadState` and nothing else (`:L166-L168`); the changed and staged entries this entity lists
  are the design, and no landed change puts them in the model". In the tree, `pub struct GitState`
  holds `head: HeadState` and `status: StatusLists`, with a `status()` accessor beside `head()`
  (`crates/ka-reader-core/src/folder_model.rs:L169-L181`, at `ka-reader@392177d`). One read fills both. The
  likely fold: the model holds the port's `HeadState` and `StatusLists` from one read, re-pinned at
  that commit.
- **If a document has to be written:** none. The entity's sentence in `SDD.md`.
- **Answer:** Take the likely fold, with three additions. Answered in the CTO's seat by an unattended
  run on 2026-10-04. § 3 `GitState` says the model holds the port's `HeadState` and its `StatusLists`,
  and builds both from one read. The sentence "the changed and staged entries this entity lists are
  the design, and no landed change puts them in the model" goes, and the entity's pins move to the
  commit the fold is made on. Checked at `ka-reader@0aab3e7`: `pub struct GitState` holds `head:
  HeadState` and `status: StatusLists` (`crates/ka-reader-core/src/folder_model.rs:L169-L172`), and one
  read asks `state` and then `status` and builds the value from both (`:L300-L306`).
  (a) The entity says what a failed part does. `status` is asked only if `state` succeeded, and a
  failure of either makes the whole Git item `failed` with the condition of the operation that
  failed; the model never holds a `GitState` with one of the two missing (`:L267-L273`,
  `:L300-L306`). This is § 4 C-I1 applied to the one Git item, and the entity cites it.
  (b) The entity says what is still the design and in no landed change: the history window and the
  `Diff`, both beyond v1, and the tree's changed marker, which `FolderModel`'s line gives
  `TreeEntry` (`grep -n marker crates/ka-reader-core/src/folder_model.rs` prints nothing at
  `ka-reader@0aab3e7`).
  (c) Nothing else in the entity moves: the model still defines the type, and the port still never
  returns it. Reasoning: `docs/trail/sdd/self_answer-38.md` § 5.1.

### 5.2 § 4 C-I3 leaves the core suites' isolation to "the change that builds the switch"; that change built it and isolated nothing
- **Raised by:** PM — 2026-10-04
- **Seat:** cto
- **Tracked by:** `ka-reader · nemawashi · 2026-10-02_git-says-what-changed`
- **What it blocks:** nothing fails. A later Git change reads C-I3 to learn whether `ka-reader-core`'s Git
  suites see the machine config, and the clause says that is still to be designed.
- **Where it shows:** § 4 C-I3 (`docs/SDD.md:L726-L731`): "How those suites are isolated is the design
  of the change that builds the switch". The switch is built (`crates/ka-reader-bridge/src/machine_config.rs`;
  its read-back case `crates/ka-reader-bridge/tests/search_path.rs:L36`, `cargo test --locked -p
  ka-reader-bridge` green at `ka-reader@392177d`). `ka-reader-core`'s in-process Git suites still run with no
  switch, and the answers the bridge serves are proved in the bridge's suite after the switch has run.
  The likely fold: state that the core suites are not isolated, and that the shipped answers are
  proved after the switch in the bridge's suite.
- **If a document has to be written:** none. C-I3's sentence in `SDD.md`.
- **Answer:** Take the likely fold, with three additions. Answered in the CTO's seat by an unattended
  run on 2026-10-04. C-I3's sentence "How those suites are isolated is the design of the change
  that builds the switch" goes. In its place C-I3 says three things. The change that built the
  switch isolated nothing. `ka-reader-core`'s in-process Git suites still run with the machine-level
  config reads on (`grep -rn 'set_search_path\|search_path' crates/ka-reader-core checks` prints
  nothing at `ka-reader@0aab3e7`). The answers the bundle serves are proved in the bridge's suite,
  after the switch has run: `crates/ka-reader-bridge/tests/git_item.rs` and `read_git_export.rs` read
  through the production-wired session, and `tests/search_path.rs:L36` reads the four paths back
  empty (`cargo test --locked -p ka-reader-bridge --test search_path`: 1 passed at `ka-reader@0aab3e7`).
  (a) The read-only walk is a third caller with the reads on, and C-I3 names it.
  `checks/walk.rs:L292` calls `read_git` with the libgit2 adapter and no switch. So
  `checks/read-only.sh`'s `unchanged` on a Git fixture is shown for libgit2 as the harness
  configures it, and the bundle configures it differently. No check runs the hash with the reads
  off. This stays under "no check holds", as the third thing, restated.
  (b) Isolating the core suites and the walk is not designed here. It is the CTO's call, and it is
  raised by the first measured difference: a suite answer or a `read-only.sh` hash that differs
  between the two configurations. None is cited today.
  (c) Two more sentences state the same landed change as still to come, and the fold re-pins them
  with this one. C-I3: "The switch and its test are not in the tree at `ka-reader@f471a9e`. They land
  in the change that wires the libgit2 adapter in the bridge" (`docs/SDD.md:L745-L746`). C-R6:
  "`crates/ka-reader-bridge/Cargo.toml` names no `git2` at `ka-reader@f471a9e` and gains its line with
  the search-path switch" (`docs/SDD.md:L636-L637`). Both are in the tree:
  `crates/ka-reader-bridge/src/machine_config.rs`, and `crates/ka-reader-bridge/Cargo.toml:L23` with
  default features off. Reasoning: `docs/trail/sdd/self_answer-38.md` § 5.2.

### 5.3 § 4 C-I3 says the `nm` transport read is not in `checks/view.sh`; it is
- **Raised by:** PM — 2026-10-04
- **Seat:** cto
- **Tracked by:** `ka-reader · nemawashi · 2026-10-02_git-says-what-changed`
- **What it blocks:** nothing fails. The clause still reads "until that build the claim is stated and
  not proved", and the build it names has landed.
- **Where it shows:** § 4 C-I3 (`docs/SDD.md:L736-L740`): "The read is not in the script at
  `ka-reader@814a369`. `see-git-status` owes it, with its suite case, no later than the build that first
  exports a function reaching `git-reader`". That build is here: `ka_reader_read_git` is exported
  (`crates/ka-reader-bridge/src/exports.rs:L105`; admitted at `crates/ka-reader-bridge/tests/exports.rs:L21`).
  The read is in the script (`checks/view.sh:L379`, the `nm` presence check), with its suite cases in
  `checks/tests/test_view.sh`. One thing the read does not yet see: the release executable holds no
  `ka_reader_read_git` symbol until a Swift caller links it, so the read has met only a build where the
  new export is dropped by the linker (the integrity pass on that build, `nm` on
  `ka-reader-mac/assemble.sh`'s output). The likely fold: the read is in the script from that build, and
  the claim is proved for the linked export once the shell calls it.
- **If a document has to be written:** none. C-I3's sentence in `SDD.md`, and RC-4's *Still
  unresolved* list (`:L2630-L2634`), which names the same read among three things tied to this build.
- **Answer:** Take the likely fold, with four additions. Answered in the CTO's seat by an unattended
  run on 2026-10-04. C-I3 says the `nm` read is in `checks/view.sh` from the build at
  `ka-reader@392177d` (`checks/view.sh:L379-L404`), with its suite cases
  (`checks/tests/test_view.sh:L58-L64`). The sentences "The read is not in the script at
  `ka-reader@814a369`", "until that build the claim is stated and not proved" and "no bridge function
  names `git-reader`" go.
  (a) The claim is proved for more than the item says. This run built the bundle at
  `ka-reader@0aab3e7` (`ka-reader-mac/assemble.sh`, exit 0) and ran `checks/view.sh` on it (exit 0). `nm`
  on that executable prints no `_ka_reader_read_git`, as the item says. It also prints 731 defined
  `_git_` symbols, `_git_repository_open_ext` and `_git_status_list_new` among them, no
  `git_smart_subtransport_` symbol, and no undefined `_connect`, `_socket` or `_getaddrinfo`. So
  the read has met an executable that links libgit2's open and status code. C-I3 states the claim
  as proved for that executable, and as not yet read on one that links the `ka_reader_read_git`
  export. The read runs on every build, so it meets that executable in the build where `mac-shell`
  first calls the export, with nothing further owed. A red read there is § 11 R-15.
  (b) § 11 R-15 says the link "has not been measured on this product" and that "no bridge function
  names `git-reader`" at `ka-reader@814a369` (`docs/SDD.md:L2750-L2753`). The fold replaces both with
  the measurement in (a). R-15 stays a risk and is not closed: the build that links the export has
  not been read.
  (c) The same `nm` output defines three symbols the read's pattern does not match:
  `_git_socket_stream_global_init`, `_git_stream_registry_global_init` and
  `_git_transport_ssh_libssh2_global_init`. The executable imports none of `connect`, `socket` or
  `getaddrinfo`. The fold names the three beside C-R6's bound that the three names "are a floor",
  so a reader who runs `nm` is not left to work out what they are. The read's pattern does not
  widen: no network call behind them is cited.
  (d) RC-4's *Still unresolved* takes a dated parenthesis and keeps its words, as RC-2's and RC-3's
  did. It says: the switch and its test landed at `ka-reader@392177d`; the `nm` read landed there, as
  (a) states; the config-named-path item did not, and item 5.4's answer gives its new bound; and
  the first of the list's questions was settled by that build, which reads the Git item on the
  first ask after each successful open and answers an `observed` or `failed` item with no second
  read (`crates/ka-reader-bridge/src/session.rs:L650-L653`). Decided together with 5.4.
  Reasoning: `docs/trail/sdd/self_answer-38.md` § 5.3.

### 5.4 R-16's settling deadline has passed: the first export reaching `git-reader` shipped without it
- **Raised by:** PM — 2026-10-04
- **Seat:** cto
- **Tracked by:** `ka-reader · nemawashi · 2026-10-02_git-says-what-changed`
- **What it blocks:** the SDD's own order. *Open Questions*, last item (`docs/SDD.md:L5560-L5572`), says
  the config-named-path case is "Settled in `see-git-status`, no later than the build that first
  exports a function reaching `git-reader`". RC-4's *Still unresolved* (`:L2630-L2634`) ties the same
  item to that build, "which `ka_reader_read_git` is". That build has landed (`ka-reader@392177d`), and it
  does not settle the item. No fixture names an outside path in its config: `grep -rn
  'include.path\|excludesfile' checks/fixtures` prints nothing.
- **Where it shows:** *Open Questions*, last item, and § 10 RC-4 *Still unresolved*. Neither form the
  item names is chosen. The second form adds a condition a reader sees, and the item says it is
  written into `git-reader`'s row and § 11 R-16 before it is built.
- **If a document has to be written:** none. The SDD says which build the item is settled by now that
  the named one has passed: a later build of `see-git-status`, before the slice closes, or a stated
  move out of the slice. The form, where it is the second, also lands in `git-reader`'s row and R-16.
- **Answer:** The item stays in `see-git-status`. Answered in the CTO's seat by an unattended run on
  2026-10-04. It is settled no later than the build in which `mac-shell` first calls
  `ka_reader_read_git`, which is the first build whose release executable links that export, and in
  every case before the slice is reached. *Open Questions*, last item, and RC-4's *Still
  unresolved* take that bound in place of "the build that first exports a function reaching
  `git-reader`". Each carries a dated note that the first bound passed unmet at `ka-reader@392177d`.
  The reason for the new bound: until the shell calls the export, the bundle opens no repository.
  The Git item is read on the first ask (`crates/ka-reader-bridge/src/exports.rs:L102-L103`), no Swift
  source asks (`grep -rn 'ka_reader_read_git\|read_git' ka-reader-mac/Sources` prints nothing at
  `ka-reader@0aab3e7`), and the release executable built at that commit holds no `_ka_reader_read_git`
  symbol.
  Three things stay as they are. Which of the two forms closes R-16 is not chosen by this answer:
  it is still settled by a fixture whose config names an outside path and a case showing the path
  is not read. The second form is still written into `git-reader`'s row and § 11 R-16 before it is
  built. R-16's sentence that no such fixture is in the tree is re-pinned and not removed: `grep
  -rn 'include.path\|excludesfile\|attributesfile' checks/fixtures` prints nothing at
  `ka-reader@0aab3e7`.
  One thing the fold states as not held. No check enforces this bound, which is how the first one
  passed. It is held by review of the change that makes the shell call the export. This is a dated
  correction and not a § 10 re-cut: no slice's *Reached when*, *Delivers*, edge or order moves.
  Decided together with 5.3. Reasoning: `docs/trail/sdd/self_answer-38.md` § 5.4.

**How it closes.** `product-sdd` folds these on its next run like every other item in this file, and
the trail copy and the delete-when-empty behaviour are unchanged.
