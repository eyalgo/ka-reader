# Self-answer report — `docs/adr/` and `docs/nfdr.md`

## Header

- **Companion:** `docs/architecture_open_issues.md`
- **Document:** `docs/adr/` and `docs/nfdr.md` (NFDR v79, Draft; one item open)
- **Decided by:** `<CORE>/../skills/companion/.claude/skills/companion-self-answer/prompts/rich.md` v1.3.1
- **Date:** 2026-11-06
- **Sources re-read:** None. The answer rests on this repository alone: `checks/gate.sh` and `checks/tests/test_read_only.sh` at `ka-reader@2529a42` and `ka-reader@d6bc3a3`, and `docs/nfdr.md` v79.
- **Liveness check:** the header names `adr/` and `nfdr.md` as bare names. Both sit beside the companion on disk, so it is live.
- **What was read:** the whole companion. From NFDR v79: its header and version lines, § 8's dated gate readings (`:L2000-L2047`), § 9's opening paragraph (`:L2358-L2375`), every line that mentions the displayed-file scene or a gate version, and RN-89. From the SDD (v70, Settled): § 6 S-6. Also `docs/trail/architecture/self_answer-73.md`, the report of the run that raised this item. As input only, and cited nowhere in the records: the project's open station for the open-file slice, which lists what the slice still has to show. Which ADRs were opened: none. The item sits in the NFDR's § 8 and § 9 alone and touches no record.
- **Scope:** one item, § 2.1, with a **Confirm-or-override** slot. No item list was given, so it was this run's. It is the Principal Architect's: the edit lands in `docs/nfdr.md` and binds only how accurate its gate readings are. It commits nothing to a person or an outside party.

## Items worked

### 2.1 — The displayed-file scene's two gate steps are not yet recorded in § 9 or § 8

- **Bucket:** 2. Choices to confirm — the Principal Architect drafted a best-effort answer; confirm or override
- **Verdict:** confirmed with addition
- **Why:** Take the draft. Add two things: § 9's new sentence is a dated reading, and § 8's reading names the gate's ordering comment.

  **Check 1: the seat is this one.** The edit lands in `docs/nfdr.md` § 8 and § 9. It only fixes how accurately the NFDR reads the gate, and it binds no person and no outside party. The item was raised by an earlier run of this skill, not by the producing run. That run left the slot open for a later round, and this is that round.

  **Check 2: every measurement in the draft holds.** All of these were re-read at `ka-reader@d6bc3a3`. `checks/gate.sh:L2` is the 1.9.0 version line, and 1.8.0's line is `:L3`. `grep -c '^run_step '` prints 38, and the first and last calls are at `:L54` and `:L145`. *Displayed-file scene* (`cargo test --locked -p ka-reader-bridge --test open_file_scene`) is at `:L112`. *Read-only, displayed-file scene* (`checks/read-only.sh checks/fixtures/open-file-scene`) is at `:L113`. Both sit after *Read-only, tree scene, killed* (`:L108`) and before *Read-only suite* (`:L114`). The tree scene's steps are at `:L107-L108`, and *Tree scene helper suite* is at `:L133`. That matches the pin NFDR v79 already gave QC-65. Nothing under `checks/` or `crates/` has changed between `d6bc3a3` and `HEAD` (`5a6ecad`), so the reading is also the current one. The draft's reason holds too: § 9 says each scene enters the gate "when their slice delivers" and then names only the tree scene's steps, so a cold reader takes the displayed-file scene as not yet gated, and at `d6bc3a3` that is false.

  **Addition 1, from check 4's stale case: § 9 states a reading, not a delivery.** § 9's sentence before the list reads "The tree scene's have", which says the tree scene's slice has delivered. If the fold puts "the displayed-file scene's have" next to it, that says the same of `follow-the-file`. Nothing this run read settles that. The slice's bar still names regression cases that may join the gate as steps of their own, such as the case on the order of two `select_file` calls. So the fold should record the two steps as present at `ka-reader@d6bc3a3`. Which further regression cases join the gate is for the next re-measurement to record, and § 9 should not close that question. A dated reading stays true at its commit whatever is added later. A delivery claim does not.

  **Addition 2, from check 2's incomplete case: § 8 names the comment.** At `:L109-L111` the gate carries a comment explaining the order: the scene runs before its read-only walk because the walk's fixture is the scene's final state, which the scene asserts. A failing scene therefore names the defect before the walk reports a fixture the scene never produced. § 8's earlier dated readings record such comments where they explain an order (the 1.5.0 reading's *Strings check* comment, `docs/nfdr.md:L2018-L2022`). This one is the ground for the order, and a later change that swapped the two steps would break it, so the reading should say so.

  **Check 3: nothing settled is contradicted.** The draft and both additions keep v77's rule that every `checks/gate.sh` locator carries its commit (RN-87). They keep the form § 8 uses for a moved gate line: the current pin first, the earlier pin kept as its dated reading. They also agree with v79's QC-65 pin of `:L133`. SDD v70 is still the SDD in force and moves no slice, edge, seam or part, so nothing upstream changes what § 9 should say. *Read-only suite* gained a case for the open file's model calls at `d6bc3a3` (`checks/tests/test_read_only.sh` v1.2.0, `test_the_folder_mode_reaches_the_open_files_model_calls`). It runs under a step § 8 already names, so the draft owes it no new locator.

  **Check 4, the other paths.** *Concurrent:* if a further gate step lands before the fold runs, the `d6bc3a3` reading stays true at its commit, and the new step is the next re-measurement's. *Absent* and *empty* do not apply, since both new steps exist and run real fixtures. *Refused:* if the owner overrides, nothing supersedes and no obligation changes, as the draft says.

  I came close to a bare **confirmed**. What tipped it was § 9's "have": as the draft words it, the fold would turn a source reading into a delivery claim nobody has measured.

## Left for the owner

None this run.

## Skipped

None this run.

## Companions opened

None this run.

## Launchers owed

- **docs/adr/ and docs/nfdr.md** — `<CORE>/launchers/skill/launcher.sh product-architecture ka-reader`
