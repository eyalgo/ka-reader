# Self-answer report — PRD.md

## Header

- **Companion:** `docs/PRD_open_issues.md`
- **Document:** `docs/PRD.md` (Settled, v17)
- **Decided by:** `<CORE>/../skills/companion/.claude/skills/companion-self-answer/prompts/rich.md` v1.3.1
- **Date:** 2026-11-06
- **Sources re-read:** None. This run gave no answer, so no answer rests on a source outside the
  repository.

## Items worked

None this run.

## Left for the owner

None this run.

## Skipped

- **3.1 — The beta release is the highest priority, and why: it is the public evidence of
  kensaiapp's work** — the owner already filled its **Answer** slot, in an interactive session in
  the CPO's seat (product repo commit `cb25715`, 2026-11-06). A filled slot is an answer already
  given, so this run read it as settled context and did not weigh it again. 1 filled slot skipped.
  Folding the answer into the PRD is the job of `product-prd`'s next run.

  One reading for that fold, recorded here and not raised: the answer moves *choosing and keeping
  a theme* after the beta, and the PRD's § *UX Notes* "The character" still says "dark and light
  themes from the start". These two do not conflict. The Mac app already draws both appearances
  and follows the platform's setting: `ka-reader-mac/Tests/SurfacesTests/RowHoverTests.swift:106`
  tests a row colour under both `.aqua` and `.darkAqua`. The answer's own words, "choosing and
  keeping", name the in-app control and the remembered choice, which is what the SDD's
  `choose-a-theme` slice delivers (`docs/SDD.md` S-7, *Delivers*). The PRD's sentence about two
  themes therefore stays true in the beta. If the fold reads "theme choice" as the themes
  themselves, then "from the start" would become false for the beta, and the sentence would need
  to change in the same fold.

- **`docs/what_left.md` — no companion template names it.** Its preamble and the *Source* of five
  entries still say "Agari" (§ 上がり Agari — ka-reader's "done"). The instance has retired that
  name for the finish line, whose heading now reads "Finish line — ka-reader's "done"". None of the
  twelve companion templates on disk names `what_left.md` as its document, so this run recorded the
  finding and wrote nothing. Its rules are `<CORE>/doctrine/setup/kensaiapp_structure.md` § 3, *The
  what-left file*.

## Companions opened

None this run.

## Launchers owed

- **docs/PRD.md** — `<CORE>/launchers/skill/launcher.sh product-prd ka-reader`
