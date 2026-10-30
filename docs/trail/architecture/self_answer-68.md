# Self-answer report — KA-Reader architecture

This report records the answer to the architecture companion for the owner and the Principal Architect who folds it.

## Header

- **Companion:** `docs/architecture_open_issues.md`
- **Document:** `docs/adr/` and `docs/nfdr.md`
- **Decided by:** `<CORE>/../skills/companion/.claude/skills/companion-self-answer/prompts/rich.md` v1.3.1
- **Date:** 2026-10-30
- **Sources re-read:** None outside this repository supplies a technical premise of the answer.
- **Inputs read:** NFDR Settled · SRS Settled · SDD Settled · FDR Settled · writing bar Draft
- **Evidence baseline:** `ka-reader@33d37e57eeb53a2db7a148e181b7637571b02c28`.
- **Review limit:** This is a review of the cited requirement, verification and implementation sections, the ADR index and the relevant harness record; the full NFDR, SDD and decision-log histories were not read. No product test or bundle check was executed in this run, and no passing result is claimed.

## Items worked

### 3.1 — QC-40's layer-5 verification names a check that does not exist

- **Bucket:** 3. Raised from downstream — an item from a seat that did not write these records
- **Verdict:** answered
- **Why:** Correct the verification description and retain the obligation. QC-40 assigns the size and relaunch assertions to `checks/own-state.sh` after `checks/churn.sh`, and § 10 repeats that assignment (`docs/nfdr.md:L1409-L1415`, `:L2671`). At the baseline above, `git ls-files checks/churn.sh` returns no path; the complete step list contains no churn invocation (`checks/gate.sh:L51-L131`); the inspection checks log existence, fixture entries and fixture cleanliness, not size or earlier-session lines (`checks/own-state.sh:L21-L30`, `:L99-L135`). Reasoning: this is a correction of a named verification, not a widening request that needs a new occurrence.

  **Seat.** The correction belongs in the NFDR's verification tail and its projected row; that row follows its entry (`docs/nfdr.md:L2594-L2597`). Reasoning: no requirement, architecture choice, external commitment or privacy trade-off needs deciding, because the answer retains NFR-11 and AC-13 exactly. The Principal Architect can answer it here, with no split or upstream companion.

  **Existing evidence and its limit.** The writer has cases for creating and truncating its file, emptying it at the cap, continuing after truncation, clipping oversized ASCII and multibyte lines, the production bound, and silent failure without retry (`crates/ka-reader-bridge/src/log_writer.rs:L214-L233`, `:L334-L429`). These are source-read cases, not results from this run. The NFDR places built-bundle proof outside `cargo test` (`docs/nfdr.md:L2139-L2145`), so the answer keeps the writer command without promoting its results to layer 5.

  **Consistency.** NFR-11 expressly binds the on-disk file even when two instances write it, and AC-13 requires the size and relaunch observations (`docs/SRS.md:L348-L359`, `:L563-L568`). C-I2 carries the same retention and failure rules (`docs/SDD.md:L789-L795`). S-5 supplies the thirty-second churn scene (`docs/SDD.md:L2213-L2234`). The NFDR already makes `development-design` the gate for a rule until its executable check is added (`docs/nfdr.md:L39-L43`). Reasoning: naming that review gate and carrying the layer-5 proof with S-5 applies the existing verification model; it neither waives the policy nor certifies the current build. The own-state retention clauses remain untouched (`docs/fdr.md:L207`, `:L239-L243`).

  **Failure paths.** Reasoning: first launch must still exercise creation; relaunch must begin with a known earlier line; size proof must include admitted output so a writer that drops everything cannot pass. Missing churn, failed or refused execution, and a check that only sees an empty file leave the bundle proof outstanding. Concurrent writers remain subject to NFR-11's one on-disk bound, not one allowance per process. At a later fold, re-read the scripts before claiming their coverage changed; the baseline above is evidence for this answer, not a permanent claim about the tree.

  **Alternative declined.** Reasoning: naming the present `own-state.sh` as sufficient would preserve the false verification claim. Treating the writer command as the whole proof would erase the layer distinction. The answer therefore keeps the executable writer tests and explicitly carries the outstanding bundle proof to the existing churn capability, without inventing a substitute command.

## Left for the owner

None this run.

## Skipped

None this run. Zero filled answer slots were skipped; item 3.1 was the only placeholder answer slot (`docs/architecture_open_issues.md` § 3.1 before this answer).

## Companions opened

None this run.

## Launchers owed

- **docs/adr/ and docs/nfdr.md** — `<CORE>/launchers/skill/launcher.sh product-architecture ka-reader`
