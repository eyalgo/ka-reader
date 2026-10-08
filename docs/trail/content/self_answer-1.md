# Self-answer report — CONTENT.md

## Header

- **Companion:** `docs/CONTENT_open_issues.md`
- **Document:** `docs/CONTENT.md` (Settled, v4)
- **Decided by:** `decide_companion_answers.md` v1.0.0
- **Date:** 2026-09-01

## Items worked

### 2.1 — Every trail pointer in this document is dead — the folders moved and the citations did not

- **Bucket:** 2. Choices to confirm
- **Verdict:** confirmed with addition
- **Why:** The drafted repair is right and, unusually for this defect, right exactly as written.
  `docs/content_trail/` and `docs/prd_trail/` do not exist; the answer-trails moved to
  `docs/trail/<x>/` at `ka-reader@1e8bf3d`, which updated no citing document. Everything the item claims
  about *this* document verifies on disk (2026-09-01), which is worth stating because the same item's
  claims about its siblings did not.

  **This document is the clean case.** The PRD's undercount does not reach it: `grep -o
  'docs/[a-z]*_trail/' docs/CONTENT.md` and `grep -o '[a-z]*_trail/' docs/CONTENT.md` both return
  **12**, so there is no bare-form body citation for the prefixed rule to miss — the trap that left 60
  PRD pointers dead under the same drafted rule. And **0** are commit-pinned (`@<sha>:` searched over
  the whole file), so the exception the item names is inert here, where in `docs/UXD.md` it protected
  four working citations from being broken.

  **The repair is complete, not just path-deep.** All four distinct cited files exist at the new
  location (`trail/content/cycle-{1,2,3}.md`, `trail/prd/cycle-10.md`), and all nine distinct `§`
  anchors they point into resolve in the moved files — checked one by one. So no repaired pointer
  lands on a file that exists but a section that does not.

  **First addition — the ground is stronger than the item gives.** The item argues from these being
  authorization pointers. True, and there is a harder reason it did not reach: RN-15 of this document
  *rules* that it "quotes and cites only files a reader who has cloned this repository can open", and
  that "a pointer a reader cannot follow is worse than no pointer". So the twelve are this document
  breaking its own stated rule, which is a defect in it rather than collateral from a folder move.
  A later reader inheriting only the item's reason would not know the document had a rule at stake.

  **Second addition — the item's scale paragraph is stale, and the choice it left open has closed.**
  Reported, not corrected, since the supporting text is the producing skill's. Its "235 across six
  documents (PRD 2 …)" was already wrong when written — the PRD carried 62, not 2
  (`docs/trail/prd/self_answer-1.md`), taking the true figure to 295 — and four of the six have since
  been repaired: PRD v12 (`2d8c99d`), SRS v9 (`82c199a`), UXD v7 (`05eac42`), DESIGN v6 (`c4f3c60`).
  Only `docs/CONTENT.md` and `docs/SDD.md` still carry it. That closes the "one mechanical sweep or
  six document cycles" question the item left as the owner's: five cycles were opened and four have
  been spent, so a sweep would now save nothing that is not already open.

  **Check 1.** The edit lands in `docs/CONTENT.md`, this seat's own document, and binds nobody outside
  it — no money, no outside party, no reserved taste, and no ground I cannot see. Mine, in the owner's
  seat. The item's closing sentence hands the *mechanism* to the owner, and I considered leaving the
  whole item on that ground; it does not hold, for the reason the PRD run gave and events have now
  confirmed — the slot decides whether this document's pointers are repaired and to what, not how the
  repair is executed. **Check 3.** Nothing the document states changes; only where it points. It
  agrees with the four sibling answers already given (same rule, same pinned exception). The writing
  bar's *"a change to a settled statement … is recorded in that document, with the reason that
  authorized it"* (`system/doctrine/writing_bar.md`) is met by the fold naming `ka-reader@1e8bf3d` on the
  version line. **Check 4.** *Concurrent:* if a sweep repairs the file before `product-content`
  re-runs, the fold meets an already-repaired document and the confirmed item folds as a no-op —
  clean either way. *Stale:* nothing here stops a second folder move doing this again; no
  citation form is proposed that would, because that is a convention question for the seat owning
  `kensaiapp_structure.md` § *A trail is not the document's sibling*, not a CONTENT item. Named, not
  covered. *Absent:* every target verified present, so the repair cannot land on a missing file.

## Left for the owner

None this run.

## Skipped

None this run — the companion carried one item and it was open.

## Raised on this document

### 2.2 — RN-24 cites a file outside this repository, which RN-15 rules this document never does

- **What the document is owed:** RN-24 cites `system/projects/ka-reader/agari.md` for the wording of the
  read-only promise, and that file is not in this repository — it is in the kensaiapp-opensource
  instance repo. RN-15 of the same document rules that it cites only files a reader who cloned this
  repository can open.
- **Why it is worth a cycle:** the prompt's *"It contradicts a document it must agree with"*
  (`decide_companion_answers.md` § The items are not the whole of what a document is owed), in its
  sharpest form — the document contradicts itself, one note breaking a rule another note states.
  Verified 2026-09-01: absent from `ka-reader`, present at
  `kensaiapp-opensource/system/projects/ka-reader/agari.md`, and the only `system/` pointer in the file.
  It is not taste: the dead pointer authorizes the wording of the product's defining promise, and the
  reader who cannot follow it is the stranger with nobody to ask that RN-15 was written for. The cycle
  is already open for § 2.1, so it costs no run of its own.

**One further defect was examined and deliberately not raised.** `docs/CONTENT.md` reads
`**Status:** Settled` while this companion sits live beside it — the state the writing bar's own
re-run called *"the one state the loop reads as done"* when it hit it (`c46e0de`, kensaiapp-opensource).
It is not raised because it is the producing skill's own bookkeeping and self-heals: `product-content`
sets `Status:` from the companion's absence rather than from a tally of answers — Settled only when a
run ends with no companion on disk, Draft otherwise
(`.claude/skills/product-content/SKILL.md:250-253`). The same fold that reads § 2.1 corrects it, so an
item would ask the owner to confirm a transition no owner decision governs.

## Companions opened

None this run — the one change found belongs to the document being answered, so it was raised on its
own companion (§ Raised on this document) rather than elsewhere.

## Launchers owed

- **`docs/CONTENT.md`** — `/Users/eyalgolan/projects/kensai/kensaiapp-dev/core/launchers/product-content/launcher.sh ka-reader`
