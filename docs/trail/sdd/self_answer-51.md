# Self-answer report — `docs/SDD.md`

This is the record of one unattended run that answered `docs/SDD_open_issues.md` in the CTO's
seat on 2026-10-07. It is for the owner, who reads it to learn what was decided and why, and for
the `product-sdd` run that folds the answers.

## Header

- **Companion:** `docs/SDD_open_issues.md`
- **Document:** `docs/SDD.md` (v43, `Status:` Settled)
- **Decided by:** `<CORE>/../skills/companion/.claude/skills/companion-self-answer/prompts/rich.md` v1.3.1
- **Date:** 2026-10-07
- **Sources re-read:** None. Neither answer rests on a source outside this repository: both items
  ask whether a build exists in the tree and what the document says about it, and the tree was
  read directly. libgit2's behaviour, which R-16 cites elsewhere, is not what either item turns on.
- **What was read of the document:** `docs/SDD.md` is 7,702 lines and was not read whole. This
  run read the header (`:L1-L30`), § 3's `git-reader` and `core-bridge` rows (`:L346`, `:L352`),
  § 4 C-D3's *Not covered* passage (`:L1005-L1025`), § 6 S-4 *Reached when*, observable half
  (`:L1830-L1910`), § 11 R-16 (`:L3070-L3160`, `:L3280-L3320`, `:L3360-L3430`), RN-101
  (`:L7166-L7240`), RN-103 (`:L7460-L7509`), and every line
  `grep -n -i 'known defect\|not located\|ConfigNotLocated\|config_not_located\|does not locate'`
  prints. A sentence elsewhere that bears on the config condition in other words was not seen. Of
  the SDD's inputs, `docs/UXD.md` was read at `:L241` and `docs/CONTENT.md` at `:L58-L66` and
  `:L329-L338`; `docs/fdr.md` was searched for `not locate` and `known defect` (0 lines) and not
  read; `docs/PRD.md` and `docs/SRS.md` were not opened. Downstream, `docs/nfdr.md` was read at
  `:L270-L285` and `:L4795-L4815` and searched for the config defect, and
  `docs/adr/0022-….md` at `:L40-L60` and `:L115-L130`.
- **The tree the answers were measured on:** `nozoki@d7f79c7`, the HEAD at intake, with
  `git status --short` printing nothing. `git diff --stat c25201a HEAD -- . ':!docs'` prints
  nothing, so outside `docs/` it is the tree at `nozoki@c25201a`, the merge the items cite, and
  `git merge-base --is-ancestor c25201a HEAD` exits 0. `cargo test --workspace --locked` printed
  511 passed, 0 failed, 0 ignored, summed over every `test result` line; `swift test
  --package-path nozoki-mac` printed "Executed 136 tests, with 0 failures". Both ran in this run.

## Items worked

### 5.1 — § 6 S-4 and § 11 R-16 call the config condition's one condition a known defect, and both observations are built

- **Bucket:** 5. Raised from downstream — an item from a seat that did not write the SDD
- **Verdict:** confirmed with addition
- **Why:** The item's "likely fold" is a lean, so it was weighed as a draft. It holds, and it is
  taken with two additions. The item corrects two statements that are now false, so it does not
  widen the document and § *A widening item waits until it occurs* does not apply.

  **Check 1 — whose.** The edit lands in `docs/SDD.md` § 6 S-4 and § 11 R-16 and nowhere else,
  the item carries `Seat: cto`, and this run is the CTO's. It binds no person, party or risk: a
  refusal that stays a refusal changes no scope. The one clause near it that is another seat's,
  the observable half of § 6 S-4, does not move — RN-101 settled its second-observation sentence
  from `docs/UXD.md` UX-S3 Error (`docs/UXD.md:L241`, "what the tool observed") and
  `docs/CONTENT.md:L62`, and what changes here is the sentence after it, which states the build.
  No ground this run cannot see was found. Mine, in the owner's seat.

  **Check 2 — the draft, and what was opened.** Every claim of the item was opened at its
  source and read as the item states it: the two SDD passages (`docs/SDD.md:L1870-L1872`,
  `:L3144-L3150`); `ConfigNotLocated` returned for `Placement::NotLocated`
  (`crates/nozoki-core/src/git_reader/libgit2.rs:L274`), the placement given to a `~/` value and to a
  relative excludes or attributes file (`config_scan.rs:L178`, `:L182`); the probe's mapping
  (`libgit2.rs:L486`); the phrase arms (`folder_model.rs:L206`, `:L223`; the constant at `:L237`);
  the wire value under `rename_all = "snake_case"` (`crates/nozoki-bridge/src/session.rs:L362`,
  `:L378`), asserted as the string `config_not_located` at `:L1576`; the shell's decode
  (`BridgePayload.swift:L383-L384`); the sentence at `GitSentences.swift:L58-L62`, which holds no
  "outside", with the outside sentence unchanged at `:L53-L57`. The test counts the item gives
  are the counts this run measured.

  **Addition one: name the cases.** The item lists the source and not the cases that hold it,
  and the document's own precedent is that a passage stating a property as built names its case
  (RN-103's *The proof*, `docs/SDD.md:L7485-L7486`). The cases are in the tree:
  `test_a_tilde_slash_value_is_refused_as_not_located_on_all_three_calls`
  (`crates/nozoki-core/tests/git_state.rs:L1534`), `test_a_relative_excludesfile_is_refused_as_not_located`
  (`:L1556`), `test_a_tilde_slash_value_in_a_submodules_config_is_not_located_on_status_alone`
  (`:L1543`), the log case `test_failed_git_item_with_the_not_located_condition_logs_one_warn_without_the_path`
  (`crates/nozoki-core/tests/git_state_log.rs:L214`), and the shell's sentence case
  (`nozoki-mac/Tests/SurfacesTests/GitSentencesTests.swift:L222-L226`). Their names were read;
  their bodies, past the lines cited, were not.

  **Addition two: the sixth key is not reached.** R-16 says a `.gitmodules` section path
  beginning `/` "answers this second observation" (`docs/SDD.md:L3116-L3118`), and a fold that
  reads "both observations are built" across all six keys would be false for that one: the
  section-path refusals are the `.gitmodules` known defect (`:L3290-L3296`), and at `nozoki@c25201a`
  the adapter still skips every `.gitmodules` key but the include keys (`libgit2.rs:L247-L248`;
  the SDD's own locator for that skip, `:L235-L240`, was pinned at `nozoki@5f3e895` and has moved
  since). So the fold's replacement sentences are scoped to the five keys named first, and the
  three `.gitmodules` defect passages (`:L1017-L1018`, `:L1903-L1906`, `:L3290-L3296`) stand.

  **Check 3 — the settled record.** R-16 already states that the condition "carries which of
  the two was observed … on the probe, on both reads and for a submodule's config, and it crosses
  SM-2, SM-4 and SM-8 with them" (`docs/SDD.md:L3118-L3120`); the build does exactly that, so no
  settled sentence of R-16 moves except the known-defect paragraph. Downstream: ADR-0022 already
  records the rule — "refuses as *not located*, not as *outside*"
  (`docs/adr/0022-…md:L49-L50`) — and `docs/nfdr.md:L275` says the same; neither states the
  config defect as current (`grep -n -i 'one condition for both' docs/nfdr.md` prints one line,
  `:L4808`, and it is the alternates defect at `nozoki@66f428d`, which is still true). So no
  companion is owed elsewhere. `docs/CONTENT.md` carries no catalogue of the Git failure sentences
  (`grep -n -i "work out where\|not locate" docs/CONTENT.md` prints nothing, and nor does the
  config-outside sentence appear there), so "the message's words are `docs/CONTENT.md`'s" reads
  as the rule at `:L62` and `:L331-L337`, as RN-101 read it; nothing there is false. No external
  source was relied on. Item 5.2 was decided after this one and moves nothing here.

  **Check 4 — the failure paths.** Empty: a config with no member key answers no condition, and
  nothing here changes that. Absent: the commit the fold pins must hold the build —
  `c25201a` is an ancestor of HEAD and the tree outside `docs/` has not moved since. Stale: the
  item's locators were measured at `c25201a` and hold at HEAD for the same reason; the fold
  re-pins at its own commit. Concurrent, as two refused values in one config: the check carries the
  first reference it refuses, in reading order (`libgit2.rs:L194-L196`, `:L228-L245`), which R-16
  already states for the alternates file and does not need to for config here. Refused: the
  reader sees a failed Git item whose sentence states what was observed and no more; `git status`
  in a terminal works for that repository, which R-16 already says.

  **What would have tipped it.** Had `GitConditionDto` carried the observation as a member of
  `config_names_outside` rather than as a value of its own, the shell's sentence would have had to
  branch on a field, and the "known defect" sentence would have been half true — the condition
  distinct in the core and merged on the wire. It is not: `:L378` is its own variant.

### 5.2 — R-16 leaves open whether the config condition's observation is a field or a second condition, and it is a second condition

- **Bucket:** 5. Raised from downstream — an item from a seat that did not write the SDD
- **Verdict:** confirmed
- **Why:** The item's "likely fold" is a lean, so it was weighed as a draft, and it holds as it
  stands. The sentence assigns a design choice to a change that has since made it, so the item is
  a correction and not a widening.

  **Check 1 — whose.** The edit is one sentence of `docs/SDD.md` § 11 R-16 (`:L3120-L3121`),
  the item carries `Seat: cto`, and the choice it records was the building change's — a technical
  shape inside the CTO's columns, binding nothing outside the document. Mine, in the owner's seat.

  **Check 2 — the draft, and what was opened.** The fact is read at every seam R-16 names
  (`docs/SDD.md:L3118-L3120`: SM-2, SM-4, SM-8). SM-2, the port: `ConfigNotLocated(ConfigNamedPath)`
  is a variant of its own on `GitReadCondition` (`crates/nozoki-core/src/git_reader.rs:L221`) and on
  `ProbeCondition` (`:L314`). SM-4, the wire: `GitConditionDto::ConfigNotLocated`
  (`crates/nozoki-bridge/src/session.rs:L378`) serialises as `config_not_located` under
  `rename_all = "snake_case"` (`:L362`), which the bridge's own test asserts (`:L1576`), and the
  members ride beside it as they do for `config_names_outside` (`:L280`). SM-8, the shell:
  `BridgePayload.swift:L383-L384` decodes the string to its own case, and `GitSentences.swift:L58-L62`
  draws a sentence of its own for it. The model has its own phrase (`folder_model.rs:L237`). The
  draft's second half, that the alternates sentence is left as it stands, was checked the same
  way: `GitReadCondition` has one object-store variant, `ObjectStoreNamesOutside(String)`
  (`git_reader.rs:L227`), and so does `ProbeCondition` (`:L318`), so for the alternates condition the
  choice is still the building change's and `docs/SDD.md:L3378-L3380` is still true. Nothing was
  added: the item asks one question and the tree answers it.

  **Check 3 — the settled record.** RN-101 says "No seam moved. The condition crosses SM-2, SM-4
  and SM-8 as it did, carrying one more fact, and no function joins SM-4's list"
  (`docs/SDD.md:L7226-L7228`). A second condition is a new value under SM-4's existing functions,
  not a new function: `git diff 218e250 c25201a -- crates/nozoki-bridge` adds no `extern` or
  `no_mangle` line. The SDD pins no count of wire conditions
  (`grep -n -i 'closed set of\|fourteen\|fifteen' docs/SDD.md` prints three lines, none about
  conditions), so the set growing by one falsifies nothing there; the bridge's own comment says
  "the closed set of fifteen" (`session.rs:L357`), which is the source's and not the document's.
  RN-101's own copy of the field-or-condition sentence (`:L7227-L7228`) is a review note recording
  what v41 decided, and the document's convention keeps a changed claim's old words in a dated
  note beside the live sentence rather than rewriting the record; that is the fold's to apply, and
  this answer only says the record is not false. Answer 5.1 was decided first; this answer rests
  on the same tree and moves nothing in it. No external source was relied on.

  **Check 4 — the failure paths.** Stale is the one that bites: the sentence is true only as
  pinned, and the fold pins at its own commit, where `git diff --stat c25201a HEAD -- . ':!docs'`
  prints nothing today. Absent: a shell build older than the bridge would meet an unknown string
  — `BridgePayload.swift:L385-L389` throws `dataCorrupted` on one, which is the existing rule for
  a value the shell does not know and is not this item's. Empty, concurrent and refused add
  nothing a single sentence about a type's shape has to carry.

  **What would have tipped it.** Had the core carried the observation as a boolean on
  `ConfigNamesOutside` and only the wire split it, the honest sentence would have been "a field in
  the core and a value on the wire", and the item's heading would have been wrong as stated. The
  core has two variants, so it is not.

## Left for the owner

None this run.

## Skipped

None this run.

## Companions opened

None this run.

## Launchers owed

- **`docs/SDD.md`** — `<CORE>/launchers/skill/launcher.sh product-sdd nozoki`
