# Self-answer report — `docs/adr/` and `docs/nfdr.md`

This report records one unattended run on `docs/architecture_open_issues.md`. The run answered both
of the companion's open items, which the PM raised in § 3. It raised nothing on this document and
opened no companion elsewhere. It is written for the owner and for the `product-architecture` run
that folds the answers.

## Header

- **Companion:** `docs/architecture_open_issues.md`
- **Document:** `docs/adr/` and `docs/nfdr.md`
- **Decided by:** `<CORE>/../skills/companion/.claude/skills/companion-self-answer/prompts/rich.md` v1.3.1
- **Date:** 2026-10-06
- **Sources re-read:** None outside this repository. Both answers rest on the tree and on
  `docs/SDD.md` v43. One rule outside the repository is cited: the append-only rule, from the
  organisation's own `product-architecture` skill (`SKILL.md:L75`). That skill was read for this
  run, but it is the producing skill's own record and not a platform source. This run measured the
  following at `ka-reader@4a49995`. `git diff --stat 66f428d HEAD -- . ':!docs'` printed nothing.
  `cargo test --locked -p ka-reader-core --test git_state` printed 82 passed, 0 failed. The ten cases
  whose names carry `alternates` all printed `ok`. `bash checks/structure.sh` printed "17 Rust files
  in 2 crates read — nothing found" and exited 0. `grep -nE
  'std::fs|File::|read_to|OpenOptions|read_link|metadata'
  crates/ka-reader-core/src/git_reader/alternates_scan.rs` printed nothing.

## Items worked

### 3.1 — QC-6, QC-15 and QC-35 say the alternates read is not built, and it is

- **Bucket:** 3. Raised from downstream — an item from a seat that did not write these records
- **Verdict:** confirmed with addition
- **Why:** The item carries a lean, its "likely fold", so this run read the lean as a draft and
  weighed it. **Seat:** the edit lands in `nfdr.md`, which is this companion's document. It binds
  only the document's consistency with the tree and with the SDD, so the call is this run's to
  make in the owner's seat. **Not widening:** it corrects a statement that is now false, which
  § *A widening item waits until it occurs* excludes from widening. QC-15's own text says the change
  that builds the read "owes this list that read", so the item also cites its occurrence.
  **The record is false, measured at the source.** `check_alternates` is defined at
  `crates/ka-reader-core/src/git_reader/libgit2.rs:L303`. It is called in `open_verified` before
  `open_at` (`:L114`), on each verified submodule (`:L449`) and on the probe (`:L475`). The scanner
  holds no filesystem call. The fixture `checks/fixtures/alternates-names-outside` and its case
  `test_the_outside_object_directory_is_never_read_on_the_three_calls` (`tests/git_state.rs:L1733`)
  are in the tree and pass. **Upstream already moved.** `docs/SDD.md` v43, Settled at
  `ka-reader@4a49995` (RN-103), states the alternates check and its case as built. Its config-named-path
  *Open Question* is open on the `.gitmodules` case alone. That is the fresh authorization a settled
  entry needs, and the fold re-derives from it. **The draft holds, and it is incomplete in two
  places.** First, QC-35's *verified by* names four FIFO cases and "58 passed at `ka-reader@076eac2`".
  The fifth case is now in the tree, and the tail would understate the harness without it. The
  addition also names what SDD v43's *The proof* says the case does not watch, a `stat` of the
  outside directory, and that no case runs the check on the built bundle. Second, QC-6 and QC-35
  both say the config-named-path item is "open on its alternates and `.gitmodules` cases". That
  becomes `.gitmodules` alone. **Failure paths (check 4).** *Concurrent:* an alternates file
  rewritten between the check and libgit2's read is still followed unchecked, so QC-35 keeps that
  clause, alternates included. *Stale:* every new count and locator is pinned to `ka-reader@4a49995`,
  whose tree outside `docs/` is `ka-reader@66f428d`'s. *Absent and refused:* the cases for no
  alternates file, an unreadable file, an oversized file and a level-six alternate exist and pass.
  The wording of the conditions belongs to `docs/CONTENT.md` (QC-53), so SDD v43's "known defect" in
  the shipped alternates sentence touches no entry here. *Bundle:* the check has not been run on
  the built bundle. QC-35 says so, and does not claim it. **What would have tipped it:** if SDD v43
  were still Draft, or still said "not built", the fold would have had no authorization and this
  would have been raised against the SDD instead. Decided together with § 3.2.

### 3.2 — ADR-0022 lists the alternates check and its case as not built, and both are in the tree

- **Bucket:** 3. Raised from downstream — an item from a seat that did not write these records
- **Verdict:** answered
- **Why:** The item offers two forms, "a re-measured paragraph, or a note beside it", and leans
  toward neither. It leaves the choice to the record's seat, so this run answered it from scratch.
  **The answer is no change to ADR-0022.** **Seat:** the change would land in ADR-0022. That is this
  companion's document, and the decision binds only the log's consistency, so it is this run's to
  make. **Both offered forms are closed by the log's own rule.** An Accepted record "is never
  rewritten; the only line that ever changes in it is that Status line, and only to record its
  supersession" (`<CORE>/../skills/principal-architect/.claude/skills/product-architecture/SKILL.md:L75`).
  The record template says the same: "a commit touching an accepted record's body is visibly
  wrong". A re-measured paragraph and a note beside it both touch the body. **Superseding the record
  fails the significance test.** A superseding record would restate the same decision to update a
  build-status sentence, so it would record nothing decided. **The paragraph is not false.** Its
  heading is *Built and not built, at `ka-reader@076eac2`*, and at that commit
  `grep -rl alternates checks crates ka-reader-mac/Sources` printed nothing (`nfdr.md` RN-53, *Measured
  for this run*). Its "Until they land, the sandbox is the only bound" was written for this change.
  `nfdr.md` RN-53 read ADR-0020 the same way: a sentence pinned to SDD v27 by its own traces "is
  history". **The present state goes where the log points.** ADR-0022's `## Binds` names QC-6,
  QC-15, QC-30 and QC-35, and § 3.1's answer moves the built state into QC-6, QC-15 and QC-35.
  **Check 3:** this agrees with § 3.1. The two were decided together, and the NFDR, which revises in
  place, carries the live state. **Check 4, stale:** a reader who opens ADR-0022 alone and reads
  past its commit pin meets the old state. Only the pin and `## Binds` guard against that. The guard
  is named here and not closed. **What would have tipped it:** a sentence in the record that was
  false at its own pin. That would be a defect in an accepted record, and only a superseding record
  could carry the correction.

## Left for the owner

None this run.

## Skipped

None this run.

## Companions opened

None this run.

## Launchers owed

- **`docs/adr/` and `docs/nfdr.md`** — `<CORE>/launchers/skill/launcher.sh product-architecture ka-reader`
