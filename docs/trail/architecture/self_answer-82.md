# Self-answer report — `adr/` and `nfdr.md`

## Header

- **Companion:** `docs/architecture_open_issues.md`
- **Document:** `adr/` and `nfdr.md` (NFDR v87, Settled)
- **Decided by:** `<CORE>/../skills/companion/.claude/skills/companion-self-answer/prompts/rich.md` v1.3.1
- **Date:** 2026-11-09
- **Sources re-read:** None. No answer was written, and the two items this run raised elsewhere rest
  on the product's own documents, read in this repository.

The companion holds one item, § 3.1, and its **Answer** slot was already filled when this run reached
it: the owner's answer, committed at `ka-reader@3363a86`. So there was nothing here for this run to
decide. That answer moves two documents besides the records: the FDR and the SRS. Neither had a
companion, so nothing else could carry the change to them. This run opened one on each.

## Items worked

None this run.

## Left for the owner

None this run.

## Skipped

- **3.1 — `SECURITY.md` is held to two wordings of the support posture, and no file can carry
  both** — its **Answer** slot was already filled with the owner's answer of 2026-11-09:
  `docs/CONTENT.md`'s wording binds, and QC-44 stands as written. A filled slot is an answer already
  given, and it is never rewritten, so this run did not revisit it. `product-architecture` folds it
  on its next run.

  **What the answer leaves owed elsewhere, and where it now goes.** The answer says the FDR's PD-22,
  R-143 and R-138 and the SRS's C-7 and C-13 "are brought to that wording by their own seats, citing
  the CONTENT row". This run read each site to check that:
  - `docs/fdr.md:262` (R-138), `:267` (R-143) and `:296` (PD-22) quote or require the PRD's
    sentences. RN-16 (`:419`) records why they quote the PRD.
  - `docs/SRS.md` C-7 and C-13 do the same, and its RN-16 and RN-24 record why.
  - `docs/SRS.md` AC-14 inspects the README's "support posture in the PRD's terms", so it moves with
    C-13.
  - `docs/CONTENT.md:223` holds the one wording the answer chose.

  Both documents are Settled, at v13 and v14, with no companion on disk. `product-architecture`
  folds into its own records and opens no companion on an upstream document. Its prompt sends a
  disagreement into a Review Note or its own companion (`product-architecture/prompts/rich.md`
  § *Inputs you work from*). So without this run, a `product-fdr` or `product-srs` re-run would find
  its document done and act on nothing, and the owner's answer would reach neither. That is the
  prompt's ground *It contradicts a document it must agree with*: once the answer is folded, QC-44
  binds the CONTENT wording, and R-143 / C-7 bind another one.

  Both items go in *choices to confirm*, with the owner's answer as the lean. Check 4 covers one
  case each item names: the CONTENT row does not say in words that no acknowledgement is promised.
  The PRD's sentence stays the limit of what is promised, held by QC-42. Each item asks the fold to
  keep that "promises nothing beyond" clause, so the missing acknowledgement promise still binds.

  The README split (R-138, C-13) rides in the same items, as the owner's answer names it.

## Companions opened

- **`docs/fdr_open_issues.md`** — **opened** — companion to `fdr.md`, landed in commit `41c9423`
- **`docs/SRS_open_issues.md`** — **opened** — companion to `SRS.md`, landed in commit `c2b7a5d`

## Launchers owed

- **docs/adr/ and docs/nfdr.md** — `<CORE>/launchers/skill/launcher.sh product-architecture ka-reader`
- **`docs/SRS.md`** — `<CORE>/launchers/companion-self-answer/launcher.sh ka-reader SRS`
- **`docs/fdr.md`** — `<CORE>/launchers/companion-self-answer/launcher.sh ka-reader fdr`
