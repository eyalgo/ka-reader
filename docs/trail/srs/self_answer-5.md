# Self-answer report — `docs/SRS.md`

## Header

- **Companion:** `docs/SRS_open_issues.md`
- **Document:** `docs/SRS.md` (Settled, v14)
- **Decided by:** `<CORE>/../skills/companion/.claude/skills/companion-self-answer/prompts/rich.md` v1.3.1
- **Date:** 2026-11-09
- **Sources re-read:** None. The one answer rests on documents in this repository: `docs/PRD.md`
  § Assumptions, "Support posture"; `docs/CONTENT.md` § Terminology, *Standing sentences*;
  `docs/nfdr.md` QC-42 and QC-44; `docs/architecture_open_issues.md` § 3.1 and its commit
  `3363a86`.

## Items worked

### 2.1 — C-7 and C-13 require the support posture in `docs/CONTENT.md`'s one wording, not "in the PRD's terms"

- **Bucket:** 2. Choices to confirm — the CTO drafted a best-effort answer; confirm or override
- **Verdict:** confirmed with addition
- **Why:** The draft is right. The owner made this call, the change lands in the SRS, and it carries
  that call out without widening it. The draft's conclusion holds. The draft misses one case, and one
  of its steps goes against the SRS's own rule. Four additions follow.

  *Whose call this is.* The decision is the owner's, and it is already made:
  `docs/architecture_open_issues.md` § 3.1, *Answer*, "(owner, 2026-11-09)". It landed in
  `3363a86`, authored by the owner, as "the owner answers the records item". That answer says the
  SRS's C-7 and C-13 are "brought to that wording by their own seats, citing the CONTENT row, not
  the PRD's sentence". The edit lands in `docs/SRS.md`, so the item belongs to this document and was
  answered here in the owner's seat. Nothing in it commits the owner to anything they had not
  already decided.

  *Why the draft holds, with a stronger reason added.* The draft rests on the owner's answer and on
  QC-44's `grep -F`. Both are sound. The content guide itself gives a stronger reason. Below its
  table, `docs/CONTENT.md` § Standing sentences says: "Whether the product states a promise at all
  is the PRD's, and whether a promise is true of the built system is the SRS's. This table fixes
  only the words, once the promise exists." So when C-7 and C-13 take their words from the CONTENT
  row and their limit from the PRD, they split the work the way that guide already does. They do not
  hand a downstream document a requirement it does not own.

  *Addition 1: each surface carries the row whole.* C-13 today quotes only the PRD's issues sentence
  for the README. Read alone, the draft's "the same change goes to C-13" could be folded as the
  issues half of the CONTENT row on the README and the security half on `SECURITY.md`. The row
  forbids that: "every surface that states it carries that wording — no paraphrase, no shortened
  version". The owner's answer binds both surfaces to "the one wording … verbatim". So the README
  carries all three sentences, including "Security reports have a private channel and are read on
  the same terms." `SECURITY.md` carries the two issues sentences as well. That promises nothing
  false: C-7 already requires the private channel. The FDR's matching item drafted the opposite
  ("or the half of it that applies to its surface"). Its two items are meant to be answered the same
  way, so that item was revised to match this one (see § Companions opened).

  *Addition 2: name the row as the wording's home.* C-7 and C-13 should point at the CONTENT row as
  where the wording lives, and any words they quote must be the row's, verbatim. This covers the
  case where the wording goes stale. The row can be reworded by the Content Manager. A requirement
  that carries its own copy of the words would then be held to wording nothing else carries, and
  that is the same split this item exists to close. RN-24 requires a commitment to be quoted, never
  paraphrased (`system/doctrine/writing_bar.md` § 1.5). Quoting the row verbatim, or pointing at
  it, meets that rule.

  *Addition 3: the PRD's limit stays, and it is what carries "no acknowledgement".* The PRD says
  security reports are read "with no acknowledgement or response time promised". The CONTENT row
  says only "read on the same terms", and the owner accepted that. C-7's "promising nothing the PRD
  does not" and C-13's "promises nothing beyond it" must stay word for word, now measured against
  the PRD's sentence as what the posture *means*. That is what keeps a promise of acknowledgement
  ruled out on both surfaces. It matches `docs/nfdr.md` QC-42, which binds no wording and only that
  limit. AC-14's README clause ("states the support posture in the PRD's terms") moves to the
  CONTENT wording. Its clause "SECURITY.md promises nothing the PRD does not" stands as written.

  *Addition 4: the propagation step, corrected.* The draft says RN-24 and RN-16 "are revised". This
  SRS does not revise settled notes. RN-20 says notes written before v5 "are settled wording and
  are left as written", and RN-35 shows the practice: "the note stands as written, this one records
  the close". So RN-24 and RN-16 stay as the record of why C-7 and C-13 once quoted the PRD. A new
  note records the move and traces it to the owner's answer (`3363a86`, and the architecture trail
  cycle that folds it). The fold should treat its own rule as the authority here. This addition only
  names that rule.

  *Against what is already settled.* No requirement outside C-7, C-13 and AC-14 names the posture
  (`grep` for "support posture" and "PRD's terms" in `docs/SRS.md` finds C-7, C-13, AC-14 and RN-24
  only). C-12, C-4 and C-9 do not move. The PRD's "the README says this plainly rather than implying
  more" still holds, because the CONTENT row states the posture plainly and promises nothing beyond
  it.

  *On the failure paths.* **Stale:** handled by addition 2. **Absent:** if the CONTENT row were
  removed, C-7 and C-13 would point at nothing. Their PRD limit would still bind, but no wording
  would. Removing the row is a Content Manager change that would reopen this, and this answer does
  not cover that case. **Concurrent:** the FDR's item and this one could be folded two different
  ways. That is closed by revising the FDR item to say the same as this one. **Refused:** the
  item's own "If overridden" holds. An override reopens the owner's architecture answer, and
  `SECURITY.md` stays unwritable until it is reopened.

  *What would have changed the verdict.* If the owner's answer had named the README's half alone,
  or if the content guide allowed a surface to carry part of a standing sentence, addition 1 would
  go and this would be a plain **confirmed**.

## Left for the owner

None this run.

## Skipped

None this run.

## Companions opened

- **`docs/fdr_open_issues.md`** — **updated** — companion to `fdr.md`, item `2.1`, which previously read "Each quotes that row, *"Issues and questions are welcome … read on the same terms."*, or the half of it that applies to its surface, and cites the CONTENT row.", landed in commit `0ada86b`

## Launchers owed

- **`docs/SRS.md`** — `<CORE>/launchers/skill/launcher.sh product-srs ka-reader`
- **`docs/fdr.md`** — `<CORE>/launchers/companion-self-answer/launcher.sh ka-reader fdr`
