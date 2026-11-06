# Self-answer report — PRD.md

## Header

- **Companion:** `docs/PRD_open_issues.md`
- **Document:** `docs/PRD.md` (Settled, v16)
- **Decided by:** `<CORE>/../skills/companion/.claude/skills/companion-self-answer/prompts/rich.md` v1.3.1
- **Date:** 2026-11-06
- **Sources re-read:** None. No answer this run gave rests on a source outside the repository: the
  one change raised rests on the instance's own tree and history, measured on disk.

## Items worked

None this run.

## Left for the owner

None this run.

## Skipped

- **3.1 — The first public release is a beta below 1.0.0, and its Git view does not yet follow the
  disk** — its **Answer** slot is already filled, by the owner, in an interactive session in the
  CPO's seat (product repo commit `66bf779`, 2026-11-06). A filled slot is an answer already given,
  so it was read as settled context and not re-weighed. 1 filled slot skipped. The fold of this
  answer into the PRD is `product-prd`'s next run.

## Raised on this document

### 2.1 — The PRD points at the project's done by a file that no longer exists, under a name the instance retired

- **What the document is owed:** § *Out of Scope* should cite
  `system/projects/ka-reader/finish_line.md` instead of `system/projects/ka-reader/agari.md`, and say
  "finish line" instead of "Agari" there and in the two relation markers that name it (§ *UX Notes*
  "The bounds v1 draws", § *Assumptions* **Versioning**). Nothing the PRD says about the product
  changes.
- **Why it is worth a cycle:** *A fact in it is now false* — here, a path
  (`<CORE>/../skills/companion/.claude/skills/companion-self-answer/prompts/rich.md` § The items are
  not the whole of what a document is owed).
  1. `PRD.md` line 336 cites `system/projects/ka-reader/agari.md`. That file is not on disk
     (`ls system/projects/ka-reader/agari.md` in the instance: *No such file or directory*). It was
     moved to `finish_line.md` by `git mv` in instance commit `de384e69` (2026-11-03, "satellite
     take-up: Agari becomes the finish line"). The instance's migration map lists the same move
     (`<CORE>/doctrine/setup/kensaiapp_structure.md` § 6, the row `system/projects/<name>/agari.md` →
     `system/projects/<name>/finish_line.md`).
  2. What the PRD cites the file for still holds at the new path, so only the pointer and the name
     are stale, not the claim. `finish_line.md` line 27 keeps sidebar search / filter, pane resizing
     and keyboard navigation outside the terminus, and line 40 still closes on a public 1.0.0.
  3. That same commit kept `docs/` as written, calling it a record. I read that as the take-up not
     editing documents other seats own, not as a ruling that a live, Settled PRD keeps a dead path.
     The PRD is read cold by the CTO, the CDO, the Principal PM and the Principal Architect, and a
     reader who follows its one path citation finds nothing. The relation markers' trail citations
     are records and are left as written in the proposal.
  4. It costs no extra run. The PRD is already owed a `product-prd` fold this round for § 3.1, and
     this item rides that fold.
  5. **What was close to tipping it:** not raising it, because the take-up commit chose to leave
     `docs/` alone. Raising won because the item is cheap here and the prompt's rule for doubt is
     to raise. If the owner meant that commit to keep product definition documents on the old name
     for good, the answer is `override`, and the PRD keeps its wording.
  6. **Found beyond this document, not raised:** the same dead path appears in `docs/SRS.md`,
     `docs/UXD.md`, `docs/SDD.md`, `docs/fdr.md` and `docs/DESIGN.md`
     (`grep -n "agari" docs/*.md`). This run did not read those documents whole, so it raises
     nothing on them. Their seats can carry the repair when each next folds. § 3.1 already sends
     companions to the SDD, the UXD and CONTENT.
  7. The item was written under § 2 in place of that section's "None." line. No existing item was
     renumbered, and no other section moved.

## Companions opened

None this run.

## Launchers owed

- **docs/PRD.md** — `<CORE>/launchers/skill/launcher.sh product-prd ka-reader`
