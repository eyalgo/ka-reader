# Self-answer report — SDD

## Header

- **Companion:** `docs/SDD_open_issues.md`
- **Document:** `docs/SDD.md` (v67, Settled; the companion carries one item the CPO raised by hand on 2026-11-06 at `ka-reader@0f53847`, seated `cto`, its **Answer** slot already filled)
- **Decided by:** `<CORE>/../skills/companion/.claude/skills/companion-self-answer/prompts/rich.md` v1.3.1
- **Date:** 2026-11-06
- **Sources re-read:** Three, all in the instance rather than in this repository, read for the item raised below and for nothing else. `<CORE>/doctrine/setup/kensaiapp_structure.md` § 6 — the migration row `system/projects/<name>/agari.md` → `system/projects/<name>/finish_line.md`. The instance's `system/projects/ka-reader/finish_line.md` — present; three conditions, as § 1 of the SDD states them (the v1 surface plus diffs, history and switching inside done; search / filter, pane resizing and keyboard navigation outside; zero violations; public under MIT at 1.0.0 or later). The instance's history — `agari.md` renamed to `finish_line.md` by `git mv` in commit `de384e69` (2026-11-03). No answer this run gave rests on a source outside the instance.

## Items worked

None this run.

## Left for the owner

None this run.

## Skipped

- **1.1 — The first public release no longer waits for the full v1 cut — PRD v17 moved it ahead of the Git view's live refresh** — its **Answer** slot is filled: the CPO raised the item and answered it in one hand (`ka-reader@0f53847`), so it is an answer already given and is left exactly as it stands for `product-sdd` to fold. Read as settled context, it is consistent with what it cites: `docs/PRD.md` v17 carries the beta in § Scope (In), **The first public release — a beta**, and in § UX Notes, "the view never lies"; `SDD.md` lines 1673–1682 and 2414 read as the item quotes them. One thing the fold meets that the answer implies and does not spell: once `first-public-release` moves ahead of `follow-the-folder`, no `depends_on` row in § 7 orders `follow-the-folder` before `promise-one-point-zero` — that slice depends on `first-public-release`, `switch-the-folder` and `read-the-history`, none of which depends on `follow-the-folder` — so "the Git view's live refresh lands before 1.0.0" is carried by a new edge or by a placement, which is step 3's call. Moving the placement is a re-cut by the SDD's own rule (§ 6 S-8 *Why here in the order*; § 7's closing paragraph), so § 10 gains an entry.

## Raised on this document

### 2.1 — The SDD points at the project's done by a file that no longer exists, under a name the instance retired

- **What the document is owed:** the five live-body citations of `system/projects/ka-reader/agari.md` (§ 1, § 2 force 4, § 5 step 1 twice, § 6's preamble) should cite `system/projects/ka-reader/finish_line.md`, and the live body should say "finish line" where it says "Agari"; dated records — the version lines, § 10, the Review Notes, trail citations — stay as written. Nothing the SDD designs changes.
- **Why it is worth a cycle:** *A fact in it is now false* — here, a path (`<CORE>/../skills/companion/.claude/skills/companion-self-answer/prompts/rich.md` § The items are not the whole of what a document is owed).
  1. `SDD.md` cites `system/projects/ka-reader/agari.md` at lines 198, 274, 1473, 1482 and 1786. In the instance, `test -e` on that path exits 1; `finish_line.md` beside it exits 0. The move is instance commit `de384e69` (2026-11-03, "satellite take-up: Agari becomes the finish line"), and the migration map carries the row.
  2. What the SDD cites the file for still holds at the new path — the three conditions § 1 restates are the finish line's, unchanged — so the pointer and the name are stale, not the claim.
  3. The PRD took the same repair at v17 (`docs/trail/prd/self_answer-4.md` § *Raised on this document*, folded at `ka-reader@ce9ba62`), and that report named this document among those carrying the dead path and left the repair to this seat's next fold. This is that fold.
  4. It costs no extra run. The SDD is owed `product-sdd` for item 1.1, and this item rides it.
  5. **What was close to tipping it:** not raising it, because a name alone is not a defect and the take-up commit left `docs/` as written. Raising won because the path is a fact a cold reader follows and finds nothing, and the PRD precedent already settled the direction. If the owner meant the SDD to keep the old name, the answer is `override`, and the path citations alone still need the repair.
  6. Seen beside it and named in the item for the fold, not raised separately: § 12's PRD-boundary sentence (line 4014) still pins the PRD at v15; item 1.1's fold re-reads the PRD at v17.
  7. The item was written under § 2 in place of that section's "None." line. No existing item was renumbered, and no other section moved.

## Companions opened

None this run.

## Launchers owed

- **docs/SDD.md** — `<CORE>/launchers/skill/launcher.sh product-sdd ka-reader`
