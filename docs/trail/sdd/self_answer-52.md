# Self-answer report — `docs/SDD.md`

This is the record of one unattended run that answered `docs/SDD_open_issues.md` in the CTO's
seat on 2026-10-07. It is for the owner, who reads it to learn what was decided and why, and for
the `product-sdd` run that folds the answers.

## Header

- **Companion:** `docs/SDD_open_issues.md`
- **Document:** `docs/SDD.md` (v44, `Status:` Settled)
- **Decided by:** `<CORE>/../skills/companion/.claude/skills/companion-self-answer/prompts/rich.md` v1.3.1
- **Date:** 2026-10-07
- **Sources re-read:** None. Neither answer rests on a source outside this repository: both items
  ask whether a build exists in the tree and what the document says about it, and the tree was
  read directly. libgit2's `odb.c`, which R-16 cites for where an entry leads, is not what either
  item turns on — the adapter refuses the entry before spelling it, so where libgit2 would take it
  decides nothing here.
- **What was read of the document:** `docs/SDD.md` is 7,826 lines and was not read whole. This
  run read the header (`:L1-L12`), § 3's `git-reader` and `read-only-harness` rows (`:L347`,
  `:L356`), § 4 C-D3's *Not covered* passage (`:L1015-L1028`), § 6 S-4 *Reached when*, observable
  half (`:L1886-L1910`), § 11 R-16 at *The refusal and its condition* and *Built, and the cases
  that hold it* (`:L3130-L3175`) and at "A third way out" (`:L3400-L3460`), RN-103 (`:L7506-L7599`),
  RN-104 (`:L7600-L7679`), and every line
  `grep -n -i 'known defect\|not located\|ObjectStoreNotLocated\|object_store_not_located\|does not locate\|ObjectStoreNamesOutside\|66f428d'`
  prints. A sentence elsewhere that states the alternates defect in other words was not seen. Of
  the SDD's inputs, `docs/UXD.md` was read at `:L235-L245` and `docs/CONTENT.md` at `:L62`;
  `docs/fdr.md` was searched for `alternates` and `not locate` (0 lines); `docs/PRD.md` and
  `docs/SRS.md` were not opened. Downstream, `docs/nfdr.md` was read at `:L1-L6` and
  `:L4795-L4830` and searched for every alternates-condition phrase, and `docs/adr/` was listed and
  searched (ADR-0022 names the alternates read at `:L28`, `:L43`, `:L47`, `:L121`, `:L125`, `:L134`
  and the condition's words nowhere).
- **The tree the answers were measured on:** `nozoki@a6add8f`, the HEAD at intake, with
  `git status --short` printing nothing. `git diff --stat 0909fe0 HEAD -- . ':!docs'` prints
  nothing, so outside `docs/` it is the tree at `nozoki@0909fe0`, the merge the items cite, and
  `git merge-base --is-ancestor 0909fe0 HEAD` exits 0; `66f428d` precedes `c25201a`, which
  precedes `0909fe0`, each an ancestor of the next. `cargo test --workspace --locked` printed 517
  passed, 0 failed, 0 ignored, summed over its 23 `test result` lines; `swift test --package-path
  nozoki-mac` printed "Executed 140 tests, with 0 failures". Both ran in this run.

## Items worked

### 5.1 — § 3, § 6 S-4 and § 11 R-16 call the alternates condition's one condition a known defect, and both observations are built

- **Bucket:** 5. Raised from downstream — an item from a seat that did not write the SDD
- **Verdict:** confirmed with addition
- **Why:** The item's "likely fold" is a lean, so it was weighed as a draft. It holds, and it is
  taken with two additions. The item corrects three statements that are now false, so it does not
  widen the document and § *A widening item waits until it occurs* does not apply.

  **Check 1 — whose.** The edit lands in `docs/SDD.md` § 3, § 6 S-4 and § 11 R-16 and nowhere
  else, the item carries `Seat: cto`, and this run is the CTO's. It binds no person, party or
  risk: a refusal that stays a refusal changes no scope, and the station's guardrail says the same
  of the build — "every entry refused before is refused now, and none newly refused". The one
  clause near it that is another seat's, the CDO's sentence in the observable half of § 6 S-4
  (`docs/SDD.md:L1887-L1892`), does not move — RN-103 settled it from `docs/UXD.md` UX-S3 Error
  ("that item shows what the tool observed", `docs/UXD.md:L241`) and `docs/CONTENT.md:L62` ("A
  message says what Nozoki observed, never why it happened"), and what changes is the build-state
  sentence after it (`:L1895-L1898`), the CTO's statement of what the tree holds. The same shape
  RN-104 took for the config passage. No ground this run cannot see was found. Mine, in the
  owner's seat.

  **Check 2 — the draft, and what was opened.** Every claim of the item was opened at its source
  and read as the item states it: the three SDD passages (`docs/SDD.md:L347`, the sentence "At
  `nozoki@66f428d` the adapter answers one condition for both observations, which § 11 R-16
  states as a known defect until a change lands"; `:L1895-L1898`; `:L3432-L3444`);
  `spell_entry` returning `ObjectStoreNotLocated` when the entry's class is not-located, before
  `spell_location` is called (`crates/nozoki-core/src/git_reader/libgit2.rs:L350-L353`), and
  `ObjectStoreNamesOutside` for a spelled entry that lies outside (`:L358-L360`); the probe's
  mapping (`:L495-L496`); the model's phrase arms (`crates/nozoki-core/src/folder_model.rs:L210-L211`,
  `:L230-L231`) and the constant they name (`:L252-L253`); the wire enum's variant
  (`crates/nozoki-bridge/src/session.rs:L379`) under `rename_all = "snake_case"` (`:L362`), the
  probe's mapping (`:L437`), the constructor sharing `object_store_refused` with the outside value
  (`:L480-L486`), and the string asserted at `:L1582` and `:L1707-L1728`; the shell's decode
  (`nozoki-mac/Sources/Shell/BridgePayload.swift:L388-L389`); the sentence at
  `nozoki-mac/Sources/Surfaces/GitSentences.swift:L68-L72`, over which `grep -i -c outside` printed
  `0`, with the outside sentence unchanged at `:L63-L67`. The test counts the item gives are the
  counts this run measured.

  **Addition one: name the cases.** The item lists the source and two of the cases; the
  document's own precedent is that a passage stating a property as built names every case that
  holds it (RN-104's *Built, and the cases that hold it*, `docs/SDD.md:L3165`). The cases are in
  the tree: `test_a_bare_relative_entry_is_refused_as_not_located_and_carried_as_written`
  (`crates/nozoki-core/tests/git_state.rs:L2046`, asserting all three calls through
  `assert_object_store_not_located` at `:L1924`),
  `test_every_entry_beginning_with_neither_dot_nor_slash_is_refused_as_not_located_as_written`
  (`:L2058`, four rows: a leading space, `~/`, a bare relative entry, and the same entry one level
  down), `test_an_own_outside_entry_is_met_before_a_level_one_not_located_entry` (`:L2097`),
  `test_a_submodules_not_located_alternates_entry_fails_status_alone` (`:L2453`), the log case
  `test_failed_git_item_with_the_object_store_not_located_condition_logs_one_warn_without_the_entry`
  (`crates/nozoki-core/tests/git_state_log.rs:L325`, whose phrase constant at `:L318-L319` holds no
  *outside*), the shell's decode case (`nozoki-mac/Tests/ShellTests/BridgePayloadGitTests.swift:L95-L97`)
  and its two sentence cases (`nozoki-mac/Tests/SurfacesTests/GitSentencesTests.swift:L321`,
  `:L338`, the second asserting that "outside" is absent). Their names and the lines cited were
  read; their bodies past those lines were not.

  **Addition two: the re-measurement reaches *The condition*'s own locators.** The item asks for
  the three passages "re-measured at a current commit", and its lean reads that as the
  known-defect sentences. It is wider: R-16 *The condition* cites the adapter at `libgit2.rs:L354-L356`,
  `:L388-L392`, `:L350-L352` and `:L292-L297` and the scanner at `alternates_scan.rs:L43-L48`,
  every one written against `nozoki@66f428d` (RN-103, *Measured in this fold*), and the station's
  diff touched both files (`git diff --stat c25201a 0909fe0 -- . ':!docs'`: `libgit2.rs` 26 lines,
  `alternates_scan.rs` 9 lines, among seventeen files). At `nozoki@0909fe0` the not-located
  refusal is `:L350-L353`, the spelled-outside arm `:L358-L360`, the link arm `:L394-L396`, the
  first-refused-entry rule `:L291-L297`, and the class rule `alternates_scan.rs:L44-L50`. What each
  names is unchanged — the fold re-pins; it does not re-argue. Without this, the fold would state
  the build at one commit beside locators true at another, which the harness row's own
  convention (`:L356`) and RN-104's *What does not move* both avoid.

  **The fold stops at the alternates condition.** Three things near it stand. The three
  `.gitmodules` known-defect passages (`:L1018-L1019`, `:L1915`, `:L3336`) stand: the adapter still
  skips every `.gitmodules` key but the include keys (`libgit2.rs:L247-L248`), and the station's
  guardrail names the section-path checks as items 13 and 14 of the seed, "no station yet". The
  config condition's *Built* paragraph (`:L3165`) stands as pinned at `nozoki@fadff58`. And the
  harness row (`:L356`) stands: the station's diff lists no file under `checks/`
  (`git diff --stat c25201a 0909fe0 -- checks` prints nothing), so its twelve-fixture count and
  its pin at `nozoki@5331b85` are not contradicted.

  **Check 3 — the settled record.** § 3's `git-reader` row and R-16 *The condition* already
  state the condition as carrying which of the two was observed, "on the probe, on both reads and
  for a submodule", crossing SM-2, SM-4 and SM-8 (`:L347`; `:L3428-L3430`); the build does exactly
  that, so no settled sentence of either moves except the known-defect ones and the locators
  named above. Downstream: ADR-0022 records the rule — a form the adapter does not locate
  "refuses as *not located*, not as *outside*" — and names the alternates read without the
  condition's words; `docs/nfdr.md` names the alternates refusal's not-located form as already in
  QC-6 and records "SDD v43's known defect at `nozoki@66f428d`" as a dated judgment that the
  defect "touches no entry" (`docs/nfdr.md:L4799-L4810`), which stays true of v43 and of the entries.
  Neither states the defect as current, and NFDR v44 (`:L5`) chose not to record the second
  observation as a decision ("a candidate that earns no record"), on a ground the build does not
  disturb. So no companion is owed elsewhere; the one thing that would have tipped it is an NFDR
  or ADR sentence saying the Git view *says outside* for a not-located entry, and
  `grep -n -i 'object store names\|one condition for both' docs/nfdr.md docs/adr/*.md` prints only
  the dated line at `:L4808`. `docs/CONTENT.md` carries no catalogue of the Git failure sentences
  (`grep -n -i 'object store\|not locate\|work out where' docs/CONTENT.md` prints nothing), so
  "the message's words are `docs/CONTENT.md`'s" reads as the rule at `:L62`, as RN-103 read it;
  nothing there is false. No external source was relied on. Item 5.2 was decided after this one
  and moves nothing here.

  **Check 4 — the failure paths.** Empty: no alternates file, or one holding only comments and
  blank lines, answers as before the check existed (`git_state.rs:L2138`), and nothing here changes
  that. Absent: the commit the fold pins must hold the build — `0909fe0` is an ancestor of HEAD and
  the tree outside `docs/` has not moved since. Stale: the item's locators were measured at
  `0909fe0` and hold at HEAD for the same reason; the fold re-pins at its own commit, and addition
  two is the stale case applied to the locators the item did not name. Concurrent, as two refused
  entries in one file or across levels: the first refused entry met in reading order is carried
  (`libgit2.rs:L293`; `git_state.rs:L2097`), and where the config check and the alternates check
  both refuse, the config condition answers (`:L2498`) — R-16 already states the first and the
  second is unchanged. Refused: the reader sees a failed Git item whose sentence states what was
  observed and no more, the tree and the panel stand (§ 4 C-I1), and `git status` in a terminal
  works for that repository, which R-16 already says.

  **What would have tipped it.** Had the shell drawn one sentence for both wire values — had
  `BridgePayload.swift` folded `object_store_not_located` into `.objectStoreNamesOutside` — the
  core's two conditions would have reached the reader as one, and the known-defect sentence at
  `:L1895-L1898` would have been half true: distinct in the core, merged on screen. It is not:
  `:L388-L389` is its own case, and `GitSentences.swift:L68-L72` is its own sentence.

### 5.2 — R-16 leaves open whether the alternates condition's observation is a field or a second condition, and it is a second condition

- **Bucket:** 5. Raised from downstream — an item from a seat that did not write the SDD
- **Verdict:** confirmed
- **Why:** The item's "likely fold" is a lean, so it was weighed as a draft, and it holds as it
  stands. The sentence assigns a design choice to a change that has since made it, so the item is
  a correction and not a widening.

  **Check 1 — whose.** The edit is one sentence of `docs/SDD.md` § 11 R-16 (`:L3424-L3426`), the
  item carries `Seat: cto`, and the choice it records was the building change's — a technical
  shape inside the CTO's columns, binding nothing outside the document. Mine, in the owner's seat.

  **Check 2 — the draft, and what was opened.** The fact is read at every seam R-16 names
  (`:L3430`: SM-2, SM-4, SM-8). SM-2, the port: `ObjectStoreNotLocated(String)` is a variant of
  its own on `GitReadCondition` (`crates/nozoki-core/src/git_reader.rs:L233`, beside
  `ObjectStoreNamesOutside(String)` at `:L227`) and on `ProbeCondition` (`:L328`, beside `:L324`).
  SM-4, the wire: `GitConditionDto::ObjectStoreNotLocated` (`crates/nozoki-bridge/src/session.rs:L379`)
  serialises as `object_store_not_located` under `rename_all = "snake_case"` (`:L362`), which the
  bridge's own test asserts (`:L1582`, `:L1707-L1728`), and the members ride beside it exactly as
  they do for `object_store_names_outside`, both built by `object_store_refused` (`:L480-L486`).
  SM-8, the shell: `BridgePayload.swift:L388-L389` decodes the string to its own case,
  `GitFailure.objectStoreNotLocated(path:)` (`nozoki-mac/Sources/Surfaces/GitItem.swift:L92`),
  and `GitSentences.swift:L68-L72` draws a sentence of its own for it. The model has its own
  phrase (`crates/nozoki-core/src/folder_model.rs:L252-L253`). The item's precedent — the config
  sentence folded the same way at `:L3130-L3141` — was read, and the draft's form, "the second
  condition as built, at SM-2, SM-4 and SM-8, with the locator at each seam", is that paragraph's.
  Nothing was added: the item asks one question and the tree answers it.

  **Check 3 — the settled record.** *The condition* says the condition "crosses SM-2, SM-4 and
  SM-8 as the config condition does" (`:L3430`), and RN-101's "no seam moved" rule for the config
  condition — a second value under SM-4's existing functions is not a new function — holds here:
  `git diff c25201a 0909fe0 -- crates/nozoki-bridge` touches `src/session.rs` alone and adds no
  line carrying `no_mangle`, `extern "C"` or `pub extern` (`grep -c` prints `0`). The SDD pins no
  count of wire conditions (`grep -n -i 'closed set of\|fourteen\|fifteen\|sixteen' docs/SDD.md`
  prints six lines — icons, grammars, ADR records and check names — none about conditions), so
  the set growing from fifteen to sixteen falsifies nothing there; the bridge's own comment now
  says "the closed set of sixteen" (`session.rs:L357`), which is the source's and not the
  document's. RN-103's copy of the field-or-condition sentence (`:L7527`) and RN-104's *What does
  not move* (`:L7619-L7623`, "for that condition the split is still the building change's") are
  dated records of v43 and v44, and the document's convention keeps a changed claim's old words in
  a dated note beside the live sentence rather than rewriting the record; that is the fold's to
  apply, and this answer only says the records are not false. Answer 5.1 was decided first; this
  answer rests on the same tree and moves nothing in it. No external source was relied on.

  **Check 4 — the failure paths.** Stale is the one that bites: the sentence is true only as
  pinned, and the fold pins at its own commit, where `git diff --stat 0909fe0 HEAD -- . ':!docs'`
  prints nothing today. Absent: a shell build older than the bridge would meet an unknown string
  — `BridgePayload.swift:L390-L391` falls through to `GitCondition(rawValue:)` and then throws,
  which is the existing rule for a value the shell does not know and is not this item's. Empty,
  concurrent and refused add nothing a single sentence about a type's shape has to carry.

  **What would have tipped it.** Had the core carried the observation as a boolean on
  `ObjectStoreNamesOutside` and only the wire split it, the honest sentence would have been "a
  field in the core and a value on the wire", and the item's heading would have been wrong as
  stated. The core has two variants at both `GitReadCondition` and `ProbeCondition`, so it is not.

## Left for the owner

None this run.

## Skipped

None this run.

## Companions opened

None this run.

## Launchers owed

- **`docs/SDD.md`** — `<CORE>/launchers/skill/launcher.sh product-sdd nozoki`
