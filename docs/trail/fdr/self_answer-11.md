# Self-answer report — fdr.md

## Header

- **Companion:** docs/fdr_open_issues.md
- **Document:** docs/fdr.md
- **Decided by:** `<CORE>/../skills/companion/.claude/skills/companion-self-answer/prompts/rich.md` v1.3.1
- **Date:** 2026-11-09
- **Sources re-read:** GitHub's repository records for `<owner>/<repository>` and `<owner>/<repository>-dev`, read with
  `gh api` on 2026-11-09. `<owner>/<repository>` is a repository of its own (created 2026-07-23), private, and it
  holds every branch of the work (`main`, the dated change branches and two others). `<owner>/<repository>-dev`
  is a separate repository, created 2026-11-09, also private. The product checkout's `origin` points at
  `ka-reader-dev`. This agrees with `docs/SDD.md` v85's note that on 2026-11-09 the public repository
  "held every private branch". The answer to § 3.1 uses this fact in check 4 (see below).

## Items worked

### 3.1 — R-198 locks the one repository made public with its own history; PRD v19 publishes the main line's history from a private `ka-reader-dev` into the public repository

- **Bucket:** 3. Raised from downstream — an item raised against the FDR after it settled
- **Verdict:** answered
- **Why:** **Check 1 — mine, in the owner's seat.** The FDR is the Principal PM's document and the change
  lands in R-198. The decision behind it is the owner's, and the owner has already made it at
  `docs/trail/prd/cycle-17.md` § 3.1. That decision is now folded into the settled PRD v19 (§ Assumptions
  "Public identity", lines 411–431), the settled SRS v16 (§ 7 C-12, § 8 AC-14, RN-42) and the settled SDD v85
  (§ 6 S-7). So the FDR only has to follow the documents above it. Its answer commits nobody to anything
  new, and there is no ground I cannot see.
  **Is this a widening?** No. It is a correction. R-198 says the repository R-128 names "is made public with
  its own commit history". That is false against v19: the public repository receives only the main line's
  history, and the work and every branch stay in a separate private repository. A false statement being
  corrected is not a widening (prompt § *A widening item waits until it occurs*), so the item does not
  wait for an occurrence.
  **Check 2 — the question.** The item gives no draft. Its "If a document has to be written" line says
  "R-198 restates what the public repository receives and when", which is a direction and not a wording.
  So I answered from scratch. The question also contains a smaller second question: does R-128 move? The
  item answers it itself, and I checked it: no. v19 leaves R-128's address as the one home
  of the release, and C-12 keeps that address. Both questions have the same seat, so the item stays whole.
  The answer carries all four of C-12's statements at the FDR's level: (1) a private repository keeps
  every branch; (2) the public one carries the main line's own history as it was made, not a fresh copy
  and not a cut tree, and holds no other branch; (3) only checked commits arrive, at every arrival; and
  (4) the history is never rewritten.
  **Check 3 — the settled record.** R-128 (the one acquisition path), R-131 (no clone of the source
  repository), R-143 (private vulnerability reporting on R-128's repository) and PD-21 (published from
  `<owner>/<repository>`) all name the public repository, and none of them conflicts with a private second
  repository. The private repository offers nothing to a user, so it is not a second acquisition path
  under R-128 or PD-15. RN-40 stays as the dated record of why R-198 was first added. Three things are
  left out of the rule because no source above the FDR states them as behaviour: what is done about a
  private finding (the PRD names no remedy, as SRS RN-42 says), where the tagged build runs, and which
  refs and which root commit the check compares. Those are the SDD's § 6 S-7 and the NFDR's. Putting
  them in would break the FDR's altitude rule ("keep the *how* out").
  **Check 4 — failure paths.** *Empty:* at the first publication the public repository gets the main
  line's whole history, and "from the second release on" covers the case where there is no earlier public
  history to keep whole. *Stale:* a commit that reaches the main line after the check is not sent until it
  has been checked itself. This is C-12's clause and it is carried in the answer. Also stale: the GitHub
  records show that the repository R-128 names already holds every private branch today. So a rule that
  only said what the public repository *receives* would hold while that repository still held the
  branches. That is why the answer says it **holds no branch but the main line**. This is AC-14's own
  check, and it is the one place the outside source changed how the answer is worded. *Absent / refused:*
  where the check finds something private, nothing is sent. *Concurrent:* a later release only adds to the
  history and never rewrites it. *Visibility:* the check applies whether or not the repository is visible
  yet, so commits pushed while it is still private are covered too.
  I came close to leaving the private repository's name out, because it is a name and not a behaviour.
  I kept it because SRS C-12 names it at the same level as R-128's address. The fold may drop it without
  changing what the rule means.

## Left for the owner

None this run.

## Skipped

None this run. The companion's one open item was worked. No other item carries a slot.

## Companions opened

None this run. Every document upstream of the FDR already states the two repositories: PRD v19, SRS v16
and SDD v85 are each Settled with no companion. The NFDR's QC-71 is already raised at
`docs/architecture_open_issues.md` (`ka-reader@2c16303`). No document I read is owed a change that no
item raised.

## Launchers owed

- **docs/fdr.md** — `<CORE>/launchers/skill/launcher.sh product-fdr ka-reader`
