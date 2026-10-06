# Self-answer report — `docs/adr/` and `docs/nfdr.md`

This report records one unattended run on `docs/architecture_open_issues.md`. The run answered the
companion's one open item. It raised nothing on this document and opened no companion elsewhere. It
is written for the owner and for the `product-architecture` run that folds the answer.

## Header

- **Companion:** `docs/architecture_open_issues.md`
- **Document:** `docs/adr/` and `docs/nfdr.md`
- **Decided by:** `<CORE>/../skills/companion/.claude/skills/companion-self-answer/prompts/rich.md` v1.3.1
- **Date:** 2026-10-06
- **Sources re-read:** the registry copy of `libgit2-sys 0.18.8+1.9.7`, the version
  `Cargo.lock:L122-L123` resolves:
  - `libgit2/include/git2/common.h:L214-L262`, the whole `git_libgit2_opt_t` enum. No option
    stops libgit2 following a path named by an include, `core.worktree`, an excludes or attributes
    file, or an alternates file. ADR-0022's first ruled-out alternative stands on this, and it
    holds.
  - `:L253`, `GIT_OPT_SET_HOMEDIR`, together with `libgit2/src/libgit2/config_file.c:L523-L527`
    and `sysdir.c:L640-L648`. libgit2 expands a `~/` include through `git_sysdir_find_homedir`,
    and that option can set the home directory. The *Why* below weighs what this means for the
    `~/` alternative.

## Items worked

### 2.1 — Accept ADR-0022: `git-reader` refuses a repository whose Git config, `.gitmodules` or alternates file names a location outside the folder, by a check of its own

- **Bucket:** 2. Choices to confirm — the Principal Architect drafted a best-effort answer; confirm or override
- **Verdict:** confirmed with addition
- **Why:** **Accept ADR-0022. Before its status moves, scope two sentences of its *Decision* to
  what `docs/SDD.md` v42 says.** The record is Proposed, so either change is still free. Once it
  is accepted it can never be edited.

  *Check 1 — whose seat.* **Mine, in the owner's seat.** The decision was made in the CTO's seat,
  in SDD v39 – v42. The SDD is Settled (`docs/SDD.md:L3`), and RN-101 and RN-102 surface the
  sub-decisions for this seat to record (`docs/SDD.md:L7147`, `:L7318`). This item asks only
  whether the log carries the record as Accepted. That binds the log's consistency with the SDD
  and commits nothing to anyone outside it. The log has answered acceptance in the owner's seat
  before: ADR-0021 in `docs/trail/architecture/self_answer-39.md`, and ADR-0020 in
  `docs/trail/architecture/cycle-30.md` § 2.1. I cannot name any ground I am missing.

  *Check 2 — the draft.* **The draft holds on all three gates, and for the reasons it gives.**
  - **Hard to reverse.** The refusal conditions cross SM-2, SM-4 and SM-8. The config refusal
    already has a shipped sentence (`nozoki-mac/Sources/Surfaces/GitSentences.swift`, cited at
    `docs/SDD.md:L3135`).
  - **Surprising without context.** A repository that `git status` reads in a terminal fails here.
  - **A real trade-off.** The record names eight ruled-out alternatives, and I counted eight.

  It also passes the domain's own test. A "never reads outside the folder" promise has to be a
  structure, and this record names one: the adapter's check, held by four FIFO cases in
  `git_state`. I found all of them at HEAD (`crates/nozoki-core/tests/git_state.rs:L1202`,
  `:L1218`, `:L1533`, and `test_an_include_link_to_outside_is_refused_without_opening_its_target`
  at `:L1624`).

  The record's facts about the code hold at `nozoki@58a7a2b`. Its tree outside `docs/` matches
  `076eac2`, the commit the record pins (`git diff --quiet 076eac2 HEAD -- . ':!docs'` exits 0).
  `check_config` is at `libgit2.rs:L191` and `verify_submodules` at `:L285`.
  `grep -rl alternates checks crates nozoki-mac/Sources` prints nothing, which matches the
  record's "Not built". I did not re-run the 58-test suite.

  Three parts of the decision are not built: the alternates check, the section-path refusals and
  the refusal on the submodule map. That is no reason to hold the record back. A record carries a
  decision, not a build. ADR-0019 was accepted with its substitute "not built until it is needed".
  This record says what is unbuilt and pins that statement to a commit, so it stays true as
  history once the record is frozen.

  *Where the draft falls short — fidelity, two sentences.* I compared the *Decision* line by line
  with SDD § 3's `git-reader` row (`docs/SDD.md:L345`) and § 11 R-16 (`:L3062-L3330`). Two
  sentences say more than the SDD does:
  - **(a)** ADR-0022 `:L52` says "An `includeIf` path refuses whatever its condition". The SDD
    says "An `includeIf` whose path spells outside is refused whatever its condition"
    (`docs/SDD.md:L3163-L3165`). The row follows an inside include, to depth ten. A cold reader of
    the frozen record could take it as refusing every `includeIf`, and could cite it to justify a
    change that does.
  - **(b)** ADR-0022 `:L55-L56` says a refusal is "never the read-failed condition, because no
    read was tried". The SDD routes two of the check's own outcomes to existing conditions. A
    config the check cannot parse to the end answers the read-failed condition, "because it cannot
    prove what libgit2 would follow". A file it cannot read answers the condition for an unreadable
    Git directory (`docs/SDD.md:L3114-L3116`, and the same in the § 3 row). Read alone, the
    record's sentence contradicts the first of these.

  Neither change moves a decision, an alternative, a binding or an NFDR obligation. This is
  *confirmed with addition*, not *overridden*. The draft's conclusion and its reasons stand. What
  the addition fixes is two places where the record's wording goes beyond its source.

  *Check 3 — against the settled record, and at the source.*
  - **The SDD.** Settled at v42, and every sub-decision in the record traces to RN-99 – RN-102.
    The two fidelity points above are the only places I found where the record says something
    the SDD does not.
  - **Not superseding ADR-0020.** RN-53 reasons that ADR-0022 does not supersede ADR-0020
    (`docs/nfdr.md:L4644-L4646`). The switch ADR-0020 records still stands, and its pointer to the
    *Open Question* is pinned to SDD v27, so it is history. Accepting ADR-0022 changes nothing in
    ADR-0020, and the log stays append-only.
  - **The NFDR.** QC-6, QC-15, QC-30 and QC-35 already derive from SDD v42, as RN-53 states. On
    acceptance, only their "(Proposed)" markers fall away. That is the fold's work, not mine.
  - **At the source.** libgit2's option list has no setting that stops these paths being followed
    (*Sources re-read*), so the first ruled-out alternative holds.
  - **One thing the source shows that the record does not.** libgit2's home directory can be set
    (`GIT_OPT_SET_HOMEDIR`, `common.h:L253`), and `~/` expansion reads it (`sysdir.c:L640-L648`).
    So "which home libgit2 takes inside the sandboxed bundle" could be made knowable. That does
    not change the decision. A pinned home anywhere but inside the folder makes every `~/` value
    an outside value, so it is refused all the same. Pinning it would only change which of the
    two observations the condition reports, and the condition the SDD settled is truthful as it
    stands. Nothing in the SDD or the record is made false by this, so I raised no item. The
    record's alternatives are the SDD's own, transcribed, so this seat would not add one of its
    own there either.

  *Check 4 — the failure paths.*
  - **Stale.** The domain is pinned to one libgit2 version, and a version change re-measures it at
    the C-R6 lockfile review, which the record names. The *Built and not built* paragraph is
    pinned to `nozoki@076eac2`, so it stays true as history after later changes land.
  - **Concurrent.** A file rewritten between the check and libgit2's read is named in
    *Consequences*.
  - **Absent.** A missing config, `config.worktree` or `.gitmodules` file is skipped. An unreadable
    or unparseable one is addition (b), which the record does not cover now and will once the
    fold takes the addition.
  - **Refused.** What a reader pays is named: a `--shared` or `--reference` clone, a `~/` include,
    or a remapped `.gitmodules` shows a failed Git item.
  - **Empty.** A repository with no member key, no alternates file and no `.gitmodules` passes the
    check, and the record implies nothing different.

  *What would have changed the verdict.* If the SDD had stated the two sentences the way the
  record does, I would have confirmed it as it stands. If the record had added an alternative or
  a sub-decision the SDD does not hold, that would have been an override, sent to the CTO's lane
  through `docs/SDD_open_issues.md`. It does not.

## Left for the owner

None this run.

## Skipped

None this run.

## Companions opened

None this run.

## Launchers owed

- **`docs/adr/` and `docs/nfdr.md`** — `<CORE>/launchers/skill/launcher.sh product-architecture nozoki`
