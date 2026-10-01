# Self-answer report — `docs/SDD.md`

## Header

- **Companion:** `docs/SDD_open_issues.md`
- **Document:** `docs/SDD.md` (Settled, v21)
- **Decided by:** `decide_companion_answers.md` v1.3.0
- **Date:** 2026-10-01
- **Sources re-read:** None. No answer here rests on a source outside this repository. Every
  fact the answers lean on was re-read in the tree on `main` at `nozoki@fcb7910` before writing:
  `crates/nozoki-bridge/tests/exports.rs:L17-L22` (the admitted set names `nozoki_select_file`),
  and `cargo test --locked -p nozoki-bridge --test exports` → `10 passed; 0 failed`;
  `crates/nozoki-core/tests/walk.rs:L1-L6` and `:L41-L53` (the walk calls `list_tree` and nothing
  else); `checks/read-only.sh:L88` (the script runs that walk);
  `crates/nozoki-bridge/tests/select_file.rs:L103-L105`
  (`test_reading_every_text_fixture_leaves_its_bytes_unchanged`, over `checks/fixtures/text`);
  `crates/nozoki-core/src/folder_model.rs:L13-L15` (an opened folder holds its root and nothing
  else), `:L69-L71` ("Nothing is cached, so every call reads again") and `:L99-L101`
  (`select_file` delegates to `fs_reader::read` and keeps nothing);
  `nozoki-mac/Sources/Surfaces/WorkbenchView.swift:L44-L45` and `:L78-L93` (the selection count and
  the shown file are the workbench's); `nozoki-mac/Sources/Surfaces/RootItemsView.swift:L18-L19`
  (every expansion reads the folder again) and `:L54-L61` (`openFilePath` is the tree view's); `checks/renderer.sh:L44-L64` (four frames, the Mac
  reading, the runner reading); `nozoki-mac/Sources/Shell/LaunchFlow.swift:L35-L37`, `:L53-L57`
  and `:L69`.

## Items worked

### 5.1 — C-R7 and C-I3 do not say what holds while a slice is built across several changes

- **Bucket:** 5. Raised from downstream — an item from a seat that did not write the SDD
- **Verdict:** answered
- **Why:** A function is exported from the first build in which a change of its slice has built
  it, and C-I3 stays as strict as it reads: every build's `read-only.sh` exercises every command
  that build grants, with no named test standing in for it. The item carried no draft. It set out
  two readings and asked which binds, so the answer was worked out from the document.

  **The widening rule, first.** The item sits under the heading carrying *Raised from downstream*
  and it widens the SDD: C-R7, SM-4 and C-I3 state nothing today about a slice built across
  several changes. It cites an occurrence for each half, a site in the product as it stands, and
  both were re-read and hold: `exports.rs:L20` admits `nozoki_select_file`, and `walk.rs:L1-L6`
  drives `list_tree` alone. Occurrences cited, so the widening proceeds.

  **Check 1: the seat.** Every sentence the answer moves is in `docs/SDD.md`: § 4 C-R7, § 3 SM-4
  and § 4 C-I3, all the CTO's lanes. The answer binds no person, money or outside party. It
  changes no promise: the read-only bar stays "zero violations" at every release (`docs/SRS.md`
  NFR-9), and no release ships before the whole v1 cut (`docs/SDD.md` RN-17). What it decides is
  when a function crosses the seam during a build, and which build owes the harness a call, which
  is how the work is divided. The SDD's own routing rule sends that to the seat, not the owner
  (RN-19: an item goes to the owner "when its answer changes what the product promises, not when
  it changes how the work is divided"). I can name no ground I cannot see. The item is mine in the
  owner's seat, and the answer goes in the slot.

  **Check 2: the question.** The item holds two questions: when a function is exported, and what
  the harness owes a build that exports one. Both have the same seat, so the item is one item
  answered on both, in the one slot. The supporting text is right on every count checked. One
  claim was tested separately: "`cargo test --locked -p nozoki-bridge --test select_file` holds
  `checks/fixtures/text/` byte-identical today" is true (`select_file.rs:L103-L105`).

  **The export.** The first reading binds. A slice is cut into one or more seeds and each share
  is "worth something on its own, or it is a fragment" (`docs/SDD.md` § 8, the *Delivers* row).
  No share of `read-a-file` shows a file in the panel without the shell calling `select_file`
  across SM-4. So the second reading, the export waiting for the slice whole, makes every share
  but the last one a fragment, or forces the slice into one change. The sentence C-R7 guards is a
  different one: no function is exported before anything built it, and none outside SM-4's list.
  That guard survives the first reading whole. The earlier answer on this condition already put
  the grant on what is built, in a tree where one slice was one seed
  (`docs/trail/sdd/cycle-5.md` § 5.1: "no command is granted before a slice registers it"). This
  answer states the same rule at the grain the work now has.

  **The harness.** The item's first reading came with a proposal for C-I3: name what covers the
  read until the walk drives `select_file`. I did not take it. Three grounds.
  - C-I3's headline is "The promises are proved on every build, from the first slice's first
    green build". The reason the document gives for checking from the first build is that a
    finding arrives with the least built on top of it. It says so of the bundle probe: "the
    finding arrives with one reader written" (`docs/SDD.md` § 11 R-8), and "publishing late does
    not require verifying late" (RN-11). The same reasoning reaches the harness, and that reading
    across is mine. An interval with a granted command unwalked removes the early finding for the
    newest code, which is where a write would be.
  - The interval is never forced. The harness drives SM-5, not the bridge's exports (§ 4 C-I3;
    § 3 SM-5). A build that exports a command has its operation on SM-5, so the walk can call it
    in that same build. On `main` the gap is where the route placed the walk's work, in the
    seed's last station, and not something the design requires.
  - Naming a per-slice test inside a § 4 condition writes a sentence that is false again the day
    the walk drives the command. Generalising it, to any test of the slice's own, relaxes how the
    read-only promise is proved. That relaxation is the one move here I would not make unattended.

  So C-I3 keeps its reading and its *Violated by* takes the unit its headline already names: a
  build, where it reads "a slice". The two halves were decided together. Exporting from the first
  change is safe to state because the harness follows the export in the same build.

  **What this says about `main`.** On `main` at `nozoki@fcb7910`, C-I3 is unmet as it reads: the
  build grants `select_file` and `read-only.sh` does not exercise it. The read itself is held by
  the bridge's own test over `checks/fixtures/text`, so nothing is known to write. The walk
  driving `select_file` closes it. That work sits on the seed's last station
  (`nozoki · nemawashi · 2026-10-01_a-file-reads-in-the-panel`, `the-panel-cannot-write`), and
  under this answer it is owed by the next build, not the slice's last. Journey files are the
  PM's and nothing is written there from here. This is the line for the PM's next re-read of the
  route.

  **Check 3: against the settled record.**
  - `docs/trail/sdd/cycle-5.md` § 5.1 (the staged grant): agrees. Its three additions stand,
    including the uncovered case before `v1.0.0`.
  - `docs/trail/sdd/cycle-12.md` § 5.1 (`nozoki_free` beside the list, exported from the first
    build): untouched.
  - `docs/SDD.md` § 8: a *Reached when* "divides", and the slice's bar is met when its last seed
    closes. S-2's promise clause stays part of that bar. C-I3 is a § 4 condition and binds every
    build, the way C-R6's "reviewed in the same change" does. It names no change unit and proposes
    no route, so § 8's fence on the PM's checklist is not crossed.
  - § 6 S-2's command half ("`select_file` is on SM-4's list and exported") and S-7's promise
    clause ("every command the build grants"): both read the same under this answer.
  - § 4 C-I6 and § 11 R-12: the pin and the pre-1.0.0 gap are unchanged.
  - `docs/nfdr.md` QC-24 (`:L358-L365`, "No listed function is exported before a slice lands it")
    follows C-R7. It is already raised at `docs/architecture_open_issues.md` § 3.1, a live
    companion with its slot open, so nothing is appended there.
  - `docs/nfdr.md` QC-2's *verified by* ("after every command the build exports") agrees with
    C-I3 as it stands. `docs/architecture_open_issues.md` § 3.1 proposes an interim clause for
    QC-2 naming the bridge's test. This answer takes no such clause for C-I3, and the NFDR
    re-derives from § 4 (`docs/SDD.md` § 4, the opening note). That item's own round reads this
    answer; its slot is not mine to fill and its text is not edited.

  **Check 4: the failure paths.**
  - **Empty.** A build that exports nothing new owes the harness nothing new. `nozoki_free` is no
    command and stays outside C-I3 (RN-66).
  - **Absent.** A fixture with no entry a command can act on exercises nothing for it: `open_diff`
    over a fixture with no changed file, for one. Which fixture a command needs is its slice's
    own bar (S-8 names `checks/fixtures/repo`, S-9 `checks/fixtures/history`). Named in the slot
    as not covered.
  - **Stale.** A seed parked or dropped mid-slice leaves its function exported. Under this answer
    it is still walked, so no interval outlives the seed. Removing the export passes the check,
    which is C-R7's named case before `v1.0.0`.
  - **Concurrent.** Two changes on two branches, one exporting and one extending the walk, meet
    at the merge. The condition is on every build of the joined tree, which is why the answer is
    worded per build and not per change.
  - **Refused.** Nothing in the build compares the walk's calls with the export set, so a change
    that exports and does not extend the walk passes CI, as `main` shows. The condition is held
    by review until a change makes it a check. Named in the slot. Asking for that check is a
    further widening, and it is left to the seat at the fold.

  **What was close.** Taking the item's proposal for C-I3, with the interval covered by the
  slice's own test. The document supports it in two places: C-I3's *Violated by* says "a slice
  that lands a command", and § 8 lets a slice's bar close with its last seed. What tipped it is
  that the interval is never forced, and that the other answer relaxes how the promise is proved.
  Had there been a command whose SM-5 operation the harness cannot call in the build that exports
  it, the interim cover would have been the right answer, and it would have been the owner's to
  give.

### 5.2 — § 3 gives `folder-model` the open file, and the built product holds it in `surfaces`

- **Bucket:** 5. Raised from downstream — an item from a seat that did not write the SDD
- **Verdict:** answered
- **Why:** § 3 stands. The open file is `folder-model`'s, and the model holds it no later than
  `follow-the-folder`. The one thing the SDD owes is a clause in that slice's *Rests on*. The
  item carried no draft. It named two outcomes and asked which the SDD states.

  **The widening rule, first.** The item sits under the heading carrying *Raised from
  downstream*, and it asks the SDD to state something it does not state now: in which slice the
  model comes to hold the open file. It cites its occurrence, and both sites were re-read and
  hold. `select_file` in `crates/nozoki-core/src/folder_model.rs:L99-L101` reads, answers and
  keeps nothing. The selection and the shown file live in
  `nozoki-mac/Sources/Surfaces/WorkbenchView.swift:L78-L93`. Occurrence cited, so the widening
  proceeds.

  **Check 1: the seat.** The edit lands in `docs/SDD.md`: § 6 S-5 *Rests on*, the CTO's field. It
  binds no person and no outside party, and it moves no promise. Keeping § 3 as it stands is this
  seat's to do. The other outcome is different in kind: moving the open file to `surfaces`
  reverses a settled placement and redraws S-5's bar, which is a re-cut under § 10. Had that been
  the answer I reached, it would have been the owner's to give. It is not the answer I reached, so
  the item is mine in the owner's seat.

  **Check 2: the question.** One question: where the open file is held, and from when. The
  supporting text is right as far as it goes, and narrower than the product. The item names the
  open file. § 3's phrase is "the selection and expansion, the open file", and all three are the
  shell's today: the tree view holds `openFilePath` and its outline's expansion
  (`RootItemsView.swift:L18-L19`, `:L54-L61`), and the core caches nothing
  (`folder_model.rs:L69-L71`). The answer covers all three by one rule and says so. That is the
  item's own question at its real width, and no second item.

  **Why § 3 stands.** Four settled statements need the model to hold this state, and one of them
  is a command.
  - S-5's command half asserts in `nozoki-core`, in-process and with no window, "the model's
    final snapshot equal to a fresh open of the fixture, and expansion, selection and reading
    position surviving". A test in the core can assert that only of state the core holds.
  - SM-3: "The model decides what to re-read." A model that does not know which file is open
    cannot decide to re-read it, or say it is gone (`docs/SRS.md` FR-27, FR-28).
  - The `surfaces` row: "draws no state the bridge did not send". SM-8: a surface "never holds a
    path it did not receive in a projection".
  - § 4 C-I3 and § 9 TO-7: no harness drives the AppKit views, "accepted because the shell holds
    no I/O the harness could catch it using". With the open file in `surfaces`, keeping the
    reader's place under churn becomes shell logic that only the release walk exercises.

  So the second outcome is not a wording change to one § 3 row. It moves S-5's command half out
  of the core, changes SM-3 and SM-8, and reopens TO-7's acceptance.

  **Why `follow-the-folder`, and why "no later than".** S-5's bar is the first that cannot be met
  with the state in the shell. Before it, nothing asserts that the model holds the open file.
  S-2's bar is met by `select_file` answering the file's content through SM-5. S-3's is met by
  `select_file` yielding the `FileView` for a `.md`. S-4's reducer case has the model holding the
  Git item and the tree items, and does not name the open file. Asking for the move inside
  `read-a-file` would build held state with nothing reading it, the shape § 5 step 2 exists to
  catch: "infrastructure built ahead of its subject". A change that brings it earlier, with the first items the
  model holds, breaks nothing, so the answer sets the latest point and no earlier one.

  **What the fold writes.** One clause in S-5's *Rests on*: the `folder-model` entry names the
  held state beside the reducer. That field is what the seat cutting seeds reads to know which
  parts a seed touches (RN-65), and as it reads today a seed cut from S-5 would take the held
  state as already in the model. § 3's rows do not move. S-2's "`folder-model` (`FileView`)"
  stands: S-2 realizes the value `select_file` answers, and S-5 realizes the model holding it
  across events. The SDD takes no sentence about where the shell keeps the state in the meantime.

  **Check 3: against the settled record.**
  - `docs/SDD.md` § 3 `folder-model`, `surfaces`, SM-3, SM-5, SM-8, *What the system holds*:
    unchanged, and the answer rests on them.
  - RN-64 and RN-65 (the model fills the open `FileView`, confirmed at
    `docs/trail/sdd/cycle-11.md` § 2.4): agrees. The fill is the model's, and this answer keeps
    the filled value there.
  - `docs/nfdr.md` QC-10 (`:L206-L214`, the model's imports "to fill the open `FileView`"):
    untouched.
  - `docs/fdr.md` R-124 (a switched folder returns the shell to its arrival state, traced to
    `folder-model`'s replace-whole): holds, and rests on the model holding the state by S-10.
  - § 6 S-10's command half ("a model equal to a fresh open of B with no item of A remaining"):
    needs the same held state, and comes after S-5.
  - The sealed unit `2026-10-01_a-text-file-reads`: its design kept the selection in the shell
    "for this change", and its audit recorded that as a divergence with no review note
    (`nozoki · tobiishi · 2026-10-01_a-text-file-reads`, in the instance at
    `system/projects/nozoki/journey/tobiishi/trail/2026-10-01_a-text-file-reads/flow_findings/development-design.md:L6`).
    The answer contradicts nothing sealed. It says where that divergence ends.
  - This run's own § 5.1 answer: no conflict. That answer is about exports and the walk, and it
    asks nothing of the model's held state.

  **Check 4: the failure paths.**
  - **Empty.** No file selected: the model holds no open file and the tree's expansion alone.
    Nothing in the answer needs a file to be open.
  - **Absent.** The open file vanishes. This is the case the answer exists for: the model's
    `FileView` goes to *gone* (FR-28), which a shell-held selection cannot produce without the
    shell interpreting change events.
  - **Stale.** Until the move, a build shows an open file that does not follow the disk. S-2's
    *Not in this slice* already fences that to `follow-the-folder`, so no release and no bar
    reads it as current.
  - **Concurrent.** Two selections in flight. The shell's count orders them today
    (`WorkbenchView.swift:L78-L93`). Once the model holds the selection, which side orders them
    is the moving change's design. The SDD does not state it, and the slot names it as not
    covered.
  - **Refused.** A read the sandbox refuses is a `failed` item wherever the open file is held.
    Unaffected.
  - **The seed for S-5 is cut before the fold lands.** S-5's command half still forces the move.
    The risk is a seed that reads smaller than it is, which the *Rests on* clause removes.

  **What was close.** Placing the selection and expansion in `surfaces` and keeping only the
  open `FileView` in the model. AppKit's outline view holds expansion and selection natively,
  and § 3 says "the physical layout is the developer's". What tipped it is S-5's command half,
  which names "expansion, selection and reading position" as surviving in a core test. An owner
  decision to prove FR-27 under `swift test` in place of that command would tip it the other
  way. That decision is a re-cut and is not made here.

## Left for the owner

None this run.

## Skipped

None this run.

## Raised on this document

### 2.1 — C-I3 cites lines that have moved, and names a five-frame list where the gate reads four

- **What the document is owed:** § 4 C-I3's four line citations and its "five-frame list", and
  § 6 S-1's one citation of the same script, brought to what the tree on `main` holds: re-pointed
  or pinned to the commit each was read at, with the runner's reading dated to the list it
  matched.
- **Why it is worth a cycle:** *A fact in it is now false* (`decide_companion_answers.md` § *The
  items are not the whole of what a document is owed*). The measurements, on `main` at
  `nozoki@fcb7910`:
  - `docs/SDD.md:L706` cites `nozoki-mac/Sources/Shell/LaunchFlow.swift:L35-L37` for "the shell
    calls it only after the panel returns". `sed -n 35,37p` on that file prints the
    `statusGlyphs` declaration. The panel call is at `:L53-L57` and `openFolder` at `:L69`.
  - `docs/SDD.md:L708`, `:L715`, `:L725` and `:L1369` cite `checks/renderer.sh:L44-L57`,
    `:L53-L61`, `:L58-L61` and `:L53-L57`. The frame list is `:L53-L56` and the Mac reading
    `:L57-L60`.
  - `docs/SDD.md:L727-L729` says "the runner matched the script's five-frame list". The script
    lists four frames. `git show b75348f -- checks/renderer.sh` (2026-09-27) removes
    `LaunchFlow.run()` from the header and from `FRAME_LIST`. The SDD's last revision,
    `nozoki@3f13391` (2026-09-30), came after that commit, so the count was false at v21.

  C-I3 is a condition every slice inherits, and the frame list is what its gate clause describes.
  The review notes are left out: a note is dated history (RN-55).

  **The doubt, stated.** Line citations drift with every change to the file they cite, and this
  document has repaired stale ones before with no item, as found-while-walking fixes inside a
  fold (RN-69). A reader could hold that the same route serves here and that an item is one more
  round than the defect is worth. I raised it because the count is checked against the script by
  anyone who reads the gate, and because no fold is certain to walk C-I3. The companion was
  already open, so the item does not reopen a closed document. Its slot is at its placeholder and
  the decision is the next round's.

## Companions opened

None this run.

## Launchers owed

- **`docs/SDD.md`** — `<CORE>/launchers/product-sdd/launcher.sh nozoki`
