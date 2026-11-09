# Self-answer report — `docs/fdr.md`

## Header

- **Companion:** `docs/fdr_open_issues.md`
- **Document:** `docs/fdr.md` (Draft, v14)
- **Decided by:** `<CORE>/../skills/companion/.claude/skills/companion-self-answer/prompts/rich.md` v1.3.1
- **Date:** 2026-11-09
- **Sources re-read:** None. Every answer rests on documents in this repository: `docs/PRD.md` v18,
  `docs/SRS.md` v15, `docs/UXD.md` v13, `docs/CONTENT.md` v15, `docs/SDD.md` § 3
  `markdown-renderer`, and `docs/nfdr.md` v87. No source moved after FDR v14:
  `git log bfed710..HEAD -- docs/` printed nothing before this run's commits.

## Items worked

### 2.1 — The FDR now knows the beta: the theme rules wait for 1.0.0, and the read-at-open state has its own rules

- **Bucket:** 2. Choices to confirm — the Principal PM drafted a best-effort answer; confirm or override
- **Verdict:** confirmed with addition
- **Why:** The fold is right in all five parts. Three small things it missed are added.

  **Seat.** This is the FDR's own item. Every edit lands in `docs/fdr.md`, and the calls behind it
  were already made upstream by the owner (PRD v18 § Scope (In), "The first public release — a
  beta", owner-confirmed at `trail/prd/cycle-15.md` § 3.1 and `cycle-16.md` § 3.1). Nothing here
  commits the owner to anything new.

  **Check 2 and 3, part by part, against the sources.**
  1. *Themes.* R-105 now uses SRS FR-20's own words: "Both themes and the choice are in place
     before 1.0.0, and a release below 1.0.0 is not held to them." R-107's "a release that does not
     offer it carries no theme control" matches UXD UX-I9: such a release "draws no theme control
     and says nothing about one to come". The new example row says the same. R-106's condition
     ("offers both themes") is different from R-107's ("offers the theme choice"). That is right,
     because a release could carry both themes, following the platform, without the choice.
  2. *The read-at-open state.* R-192 – R-194 follow SRS FR-35 and AC-26 closely and, like the SRS,
     describe a state rather than a release. R-192's "a clean repository included" is UXD v13's
     (its header: "a clean repository included, absent where no Git state is shown") and CONTENT's
     tone row ("a clean repository carries it exactly as a changed one does"). R-192 points at the
     CONTENT row and quotes none of it, as RN-39 does for the support posture. R-195 is correctly
     derived. Nothing reads Git state again in this state, so "recovers on a later refresh" would be
     false. CONTENT § Message patterns already gives the beta's form, which names starting
     KA-Reader again as the way on, so R-88's "what to do next" is still met.
  3. *The release.* R-197 matches SRS AC-14's known-gaps clause, and R-198 matches SRS C-12's
     public-history sentence word for word.
  4. *R-196.* `docs/SDD.md` line 739 reads "a block in no floor language is plain and holds no
     spans, which is every indented block and any fence whose first word names no floor language".
     R-196 says the same.
  5. *Examples.* The read-at-open row matches AC-26's "an external Git staging operation after open
     leaves the state shown unchanged".

  **What is added.**
  1. **R-197 points at CONTENT's beta row.** As drafted, R-197 says what the known gaps state but
     not in which words. CONTENT v15 says its beta sentence is "one wording that the Git view, the
     letters beside changed files and the README's known gaps all carry". A README written to R-197
     alone could paraphrase it and still meet the rule, while breaking CONTENT. So R-197 carries the
     first half in the one wording that row fixes, pointed at and not quoted, as R-192 and R-138 do.
     The second half, about a repository created after open, has no row: CONTENT says that sentence
     "is written with the README, to this document's rules". R-197 says so.
  2. **The "Version 0.4" example row gains its theme condition.** It still says "the theme follows
     the platform". Versions 0.4 and 0.5 are both below 1.0.0, which is exactly where FR-20 no longer
     promises both themes, so the row is now true only of a release that offers both themes. It
     gains that condition, as the dark-appearance row did. R-168 itself can stay as written: "the
     theme R-106 gives" already carries R-106's new condition.
  3. **RN-40's "What is left for others: none found" is corrected.** The NFDR has not seen the beta.
     QC-44 names six standing sentences and CONTENT v15 has seven. A search of `docs/nfdr.md` for
     `FR-35`, `AC-26`, `read once`, `commit history` and `anything private` finds nothing. So
     `checks/readme.sh`, as QC-44 binds it, would pass a README that leaves out the beta's sentence.
     This run raised that at `docs/architecture_open_issues.md` § 2.1 (`ka-reader@316e337`), and
     RN-40 should name it.

  **Check 4, on the failure paths.** *Stale*: in the read-at-open state, an edit after open reaches
  the tree's content and not its markers. R-194 and the new example row cover that, and the
  statement is what makes it honest. *Absent*: a repository removed from the root after open is
  still shown as read, under the statement. That is true by the statement's own words ("They do not
  update while KA-Reader is open"). *Empty*: a clean repository carries the statement (R-192). In a
  plain folder there is no statement and no markers (R-193). *Concurrent*: a lock at open stands
  until a relaunch (R-195), and the message names that way out. *Refused*: nothing in this item
  reaches it.

  **What I was close to.** Plain "confirm". Addition 1 is what tipped it. Without it, the README
  rule is the one place the beta's wording is left to paraphrase, and CONTENT forbids that.

## Left for the owner

None this run.

## Skipped

None this run.

## Companions opened

- **docs/architecture_open_issues.md** — **appended** — companion to `adr/` and `nfdr.md`, item
  2.1, landed in commit `316e337`. The NFDR has not seen the beta: QC-44's list misses CONTENT
  v15's seventh standing sentence, and nothing checks SRS v14's AC-14 known-gaps line, its C-12
  history check, or FR-35 / AC-26. The section said "None." before. That placeholder was replaced by
  the item, and § 3.1's owner answer was left untouched.

## Launchers owed

- **docs/fdr.md** — `<CORE>/launchers/skill/launcher.sh product-fdr ka-reader`
- **docs/architecture_open_issues.md** — `<CORE>/launchers/companion-self-answer/launcher.sh ka-reader architecture`
