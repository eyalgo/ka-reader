# Self-answer report — SDD

## Header

- **Companion:** `docs/SDD_open_issues.md`
- **Document:** `docs/SDD.md` (v67, Settled; the companion carries item 1.1, the CPO's, its **Answer** slot filled by hand on 2026-11-06, and item 2.1, raised by the previous self-answer run at `ka-reader@5bc79c2`, seated `cto`, its **Confirm or override** slot open)
- **Decided by:** `<CORE>/../skills/companion/.claude/skills/companion-self-answer/prompts/rich.md` v1.3.1
- **Date:** 2026-11-06
- **Sources re-read:** Three, all in the instance rather than in this repository, and none outside it. The instance tree: `system/projects/ka-reader/agari.md` — `test -e` exits 1; `system/projects/ka-reader/finish_line.md` — exits 0, read whole, carrying the three conditions as `SDD.md` § 1 states them. The instance's history: `git log -- system/projects/ka-reader/finish_line.md system/projects/ka-reader/agari.md` lists `de384e69` "satellite take-up: Agari becomes the finish line" as the rename. The migration map: `<CORE>/doctrine/setup/kensaiapp_structure.md` § 6, line 2572, the row `system/projects/<name>/agari.md` → `system/projects/<name>/finish_line.md`. No answer rests on a vendor's or platform's published source.

## Items worked

### 2.1 — The SDD points at the project's done by a file that no longer exists, under a name the instance retired

- **Bucket:** 2. Choices to confirm — a best-effort answer was drafted; confirm or override
- **Verdict:** confirmed
- **Why:** Check 1 — mine, in the CTO's seat the item names: the edit lands in `SDD.md` and nowhere else, it binds no person, party or risk, and there is no ground I cannot see — a path either resolves or it does not. Check 2 — the draft holds for the reason it gives. Its three facts were re-measured, not taken from the item: the old path is absent and the new one present (exit codes above); the rename is `de384e69` by `git mv`; and the migration map carries the row at the line cited. Its inventory of the live body is right: `grep -n 'agari\|Agari' docs/SDD.md` finds the path at lines 198, 274, 1473, 1482 and 1786 — the five the draft names — and the name at § 2's hexagonal row (307), § 5 steps 1–4 and *Six cuts* (1397–1761), § 6's preamble (1784) and S-9 (2572), § 7's row (2810), § 8's row (2854) and § 12 (4015); every other hit is a dated record — the header's version lines, § 10, the Review Notes. The draft's split between the live body and the dated records is the SDD's own convention: every sentence whose claim changes keeps its old words in a dated note beside it (the header's version lines say so for every fold). Check 3 — nothing settled moves. `finish_line.md` keeps the three conditions § 1 restates, word for word in substance (the v1 surface plus diffs, history and switching inside; search / filter, pane resizing and keyboard navigation outside; zero violations; MIT at 1.0.0 or later), so the pointer changes and the claim does not. The PRD precedent holds: `docs/PRD.md` at v18 cites `finish_line.md` at line 354 and names the finish line at lines 295 and 435, with no `agari` left. The PRD's cycle-15 trail copy shows its own § 2.1 slot still at the placeholder, so the repair there landed on the fold's reading rather than on a filled slot — a fact about that trail, not about this answer, and not worth a cycle: the PRD is right. Item 1.1, read as settled context, does not touch this: it moves slices, this moves citations. Check 4 — *absent*: if the fold cannot read the instance tree, the migration map's row is the second source and the answer stands on it. *Stale*: a second rename would be a second row in the same map; nothing here pins the name beyond it. *Refused*: an `override` leaves the path dead and the cost is the item's own *If overridden*. *Concurrent*: the PRD's fold already made the same move; the SDD's rides the fold item 1.1 owes, and no other run writes this document.
- **What was close to tipping it:** *confirmed with addition*, for the one thing the item names and leaves to the fold — § 12's PRD-boundary sentence pinning the PRD at v15. It is not added here because it is already carried: the item says it, and item 2.2 below names the same sentence with the version the fold now reads, v18.

## Left for the owner

None this run.

## Skipped

- **1.1 — The first public release no longer waits for the full v1 cut — PRD v17 moved it ahead of the Git view's live refresh** — its **Answer** slot is filled: the CPO raised and answered it in one hand (`ka-reader@0f53847`) and amended the answer at `ka-reader@cb25715` to move `choose-a-theme` after the release. An answer already given; left exactly as it stands for `product-sdd` to fold. Read as settled context: it is consistent with `docs/PRD.md` v18 on the two things it decides — the beta's placement and the theme's order (§ Scope (In), **The first public release — a beta**) — and it is what item 2.2 extends. 1 filled slot skipped.

## Raised on this document

### 2.2 — The SDD's first public release has not seen PRD v18 — the repository goes public with its own history, after a privacy check

- **What the document is owed:** the fold item 1.1 owes reads the PRD at v18 rather than v17; § 6 S-8 `first-public-release` carries the v18 clause that the repository goes public with its own commit history, not as a fresh copy, and only once that history has been checked for anything private — in *Delivers*, in *Reached when*'s command half as a release condition beside the `gitleaks git` check already there, and in *Traces to*; § 12's PRD boundary pins v18.
- **Why it is worth a cycle:** *Something upstream moved and it has not seen it* (`<CORE>/../skills/companion/.claude/skills/companion-self-answer/prompts/rich.md` § The items are not the whole of what a document is owed).
  1. The change: `git diff ce9ba62 d1ea3ac -- docs/PRD.md` adds to § Assumptions **Public identity** the sentences "The repository goes public with its own commit history, not as a fresh copy ... the repository goes public only once its history has been checked for anything private", owner-confirmed at `trail/prd/cycle-16.md` § 3.1, and bumps the version line to 18. `d1ea3ac` landed at 16:50; the companion's last edit before this run, `cb25715`, landed at 16:42, so no item saw it.
  2. The consequence: S-8's *Delivers* (line 2466) says what a stranger finds at the repository and says nothing about its history; its command half (line 2495) has `gitleaks git` exits 0 and `gh secret list` prints no entry — a secrets scan of the history, which is the mechanical half of the check and not the "anything private" half, which is a person's read. A `first-public-release` seed cut from S-8 as it stands (§ 8) would not carry that the history is published or that it must be read first.
  3. What does not reach the SDD and is said so in the item: the beta's purpose, to be shown and pointed to from kensaiapp's public repository, is the owner's act outside the product — the PRD fold's own commit message excludes it from `docs/what_left.md` on that ground.
  4. It costs no extra run: the SDD is owed `product-sdd` for item 1.1 and this rides it.
  5. **What was close to tipping it:** not raising, on the reading that `product-sdd` re-reads the PRD whole on every fold and would meet v18 on its own. Raising won because item 1.1's text cites v17 and the previous SDD folds pinned the PRD version they read (§ 12 still says v15), so a fold that reads only what the item names would carry v17 forward; the doubt is in the item, and the prompt's rule for doubt is to raise.
  6. The item was appended under § 2 after item 2.1, taking the next free number. No existing item was renumbered, and no other section moved.

## Companions opened

None this run.

## Launchers owed

- **docs/SDD.md** — `<CORE>/launchers/skill/launcher.sh product-sdd ka-reader`
