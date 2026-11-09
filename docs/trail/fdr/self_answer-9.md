# Self-answer report — `docs/fdr.md`

## Header

- **Companion:** `docs/fdr_open_issues.md`
- **Document:** `docs/fdr.md` (Settled, v13)
- **Decided by:** `<CORE>/../skills/companion/.claude/skills/companion-self-answer/prompts/rich.md` v1.3.1
- **Date:** 2026-11-09
- **Sources re-read:** None. Every answer rests on documents in this repository: `docs/PRD.md` v18,
  `docs/SRS.md` v15, `docs/CONTENT.md` v15, `docs/nfdr.md`, and `docs/architecture_open_issues.md`
  § 3.1 (the owner's answer).

## Items worked

### 2.1 — The support posture on `SECURITY.md` and the README takes `docs/CONTENT.md`'s one wording, not the PRD's sentence

- **Bucket:** 2. Choices to confirm — the Principal PM drafted a best-effort answer; confirm or override
- **Verdict:** overridden
- **Why:** The draft is right about what to do, but wrong about one part of how. That part is
  replaced, and the rest stands.

  **What stands.** The owner decided this at `docs/architecture_open_issues.md` § 3.1, *Answer*
  (`ka-reader@3363a86`): CONTENT's wording binds on `SECURITY.md` and the README, cited from the
  CONTENT row and not from the PRD's sentence. The PRD's sentence stays the posture's meaning. The
  SRS has since folded the same answer and settled at v15 (`ka-reader@86802c6`; `docs/SRS.md`
  C-7, C-13, RN-41). Its rules are that each surface carries the row whole and the PRD stays the
  limit. The draft's PD-22 rewording, its "promises nothing beyond" limit in R-143, and its point
  that the row says only "read on the same terms" while the PRD promises no acknowledgement — all
  of these hold, and the answer keeps them. This item is the FDR's own, because the edit lands in
  `docs/fdr.md`. The owner has already made the call that matters, so nothing here needs them.

  **What is replaced: the FDR points at the row instead of quoting it.** The draft had R-143 and
  R-138 each "quote that row whole … and cite the CONTENT row". That puts a second copy of the
  row's words in the FDR. Three things weigh against it, and nothing in the draft argues for it:
  1. The owner's answer says "citing the CONTENT row". It does not say copying it.
  2. The SRS, folding the same answer, decided the opposite: "C-7 and C-13 point at it and quote
     none of its words, so a change to the row cannot leave this document holding a stale copy"
     (`docs/SRS.md` RN-41). The draft was written before that fold, when
     `docs/SRS_open_issues.md` was still open. Its own "If overridden" asks that the two be
     answered the same way.
  3. This FDR already handles the accessibility row this way. R-139 carries "the wording
     `docs/CONTENT.md` § Standing sentences fixes" and quotes none of it. RN-16's ground, the
     writing bar's rule to quote a commitment rather than paraphrase it, is met by pointing at the
     row's exact words, as SRS RN-41 says.

  **One gap in the draft is closed.** The draft calls "the PRD's sentence" the limit for both
  rules. But the README now carries the security sentence too, so R-138's limit has to include
  the PRD's security sentence beside its issues sentence. Otherwise a README could promise an
  acknowledgement and R-138 would not catch it. `docs/SRS.md` C-13 made exactly this change.

  **One choice the draft left open is settled.** The draft says RN-16 is "revised or superseded".
  The answer is superseded. RN-16 stays as the record of why the rules first quoted the PRD, as
  RN-29 stays as the record of v3 and as SRS RN-41 leaves its own RN-16 and RN-24. A new RN-39
  records the move.

  **Check 3, against the settled record.** The answer matches SRS v15 C-7, C-13 and AC-14
  word for word in what it binds. It leaves `docs/nfdr.md` QC-44 (the exact-text `grep -F` of the
  row against `README.md` and `SECURITY.md`) and QC-42 (`SECURITY.md` promises nothing beyond the
  PRD's security sentence) both satisfiable by the same file. It does not conflict with § 2.2,
  raised below, which also reaches the README rules. One fold can take both.

  **Check 4, on the failure paths.** *Stale*: if the row's wording changes later, a rule that
  points at it stays true, and a rule that quoted it would go stale. That is the case the
  override exists for. *Absent*: if the row is removed, R-138 and R-143 keep the PRD limit and
  lose their wording, which reopens this question. That is the same consequence SRS RN-41 names.
  *Empty*: before the first public release, R-143's "before the first public release" binds as
  now. *Concurrent* and *refused*: nothing in this item reaches them.

  **What I was close to.** I nearly confirmed with an addition. What tipped it to overridden is
  that "quotes that row whole" is a stated instruction the fold would carry out. It is not
  something missing that an addition could fill.

  **Wrong supporting text, reported and not edited.** The item's *If overridden* says
  `docs/SRS_open_issues.md` § 2.1 "carries" the same split. That companion was answered
  (`ka-reader@8ffe965`) and folded into SRS v15 (`ka-reader@86802c6`), and the file is gone.

## Left for the owner

None this run.

## Skipped

None this run.

## Raised on this document

### 2.2 — The FDR has not seen the beta: the PRD, the SRS, the UXD and CONTENT moved to it after v13 settled

- **What the document is owed:** a re-derivation against PRD v18, SRS v15, UXD v13 and CONTENT v15.
  At the least: R-105's "from the first release" takes SRS FR-20's bound (both themes and the kept
  choice in place before 1.0.0, a release below 1.0.0 not held to them), with the theme rules
  following it. A rule carries SRS FR-35's read-at-open statement. The README rules take AC-14's
  known-gaps line.
- **Why it is worth a cycle:** three of the prompt's grounds apply at once. A fact in the FDR is now
  false: R-105 promises both themes "from the first release", and the first public release is now
  the beta, which SRS FR-20 does not hold to them. Something upstream moved and the FDR has not
  seen it: `git log 9ce336b..HEAD -- docs/PRD.md docs/SRS.md docs/SDD.md docs/CONTENT.md
  docs/UXD.md` lists PRD v17 – v18, SRS v14 – v15, UXD v13, CONTENT v15 and SDD v68 – v82, all
  after FDR v13. A search of `docs/fdr.md` for `FR-35`, `read-at-open` and `beta` finds nothing.
  And the FDR now contradicts a document it must agree with, SRS FR-20. It matters now because the
  Product Owner checks every change against the FDR, and the beta is the release being walked.

## Companions opened

None this run.

## Launchers owed

- **docs/fdr.md** — `<CORE>/launchers/skill/launcher.sh product-fdr ka-reader`
