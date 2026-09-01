# Self-answer report — PRD.md

## Header

- **Companion:** `docs/PRD_open_issues.md`
- **Document:** `docs/PRD.md` (Settled, v11)
- **Decided by:** `decide_companion_answers.md` v1.0.0
- **Date:** 2026-09-01

## Items worked

### 2.1 — Every trail pointer in this document is dead — the folders moved and the citations did not

- **Bucket:** 2. Choices to confirm
- **Verdict:** confirmed with addition
- **Why:** The draft's repair is right and its measurement of this document is wrong by a factor of
  thirty. `docs/prd_trail/` genuinely does not exist — the seven answer-trail folders moved to
  `docs/trail/<x>/` at `nozoki@1e8bf3d`, which updated no citing document — so the drafted rule
  (`docs/<x>_trail/` → `docs/trail/<x>/`) stands. The addition is what the rule does not reach.

  **The scale in this document.** The item counted **2**, from a grep for `docs/<x>_trail/`. The PRD
  carries **62**: the 2 with a `docs/` prefix are both on the version line (`docs/PRD.md:5`), and the
  other **60** are the bare form the document cites its trail in everywhere else — `prd_trail/cycle-N.md`
  (58 occurrences) and `srs_trail/cycle-N.md` (2). Measured with `grep -o '[a-z]*_trail/' docs/PRD.md`
  (62) against `grep -o 'docs/[a-z]*_trail/'` (2). The bare form resolves relative to `docs/`, where
  the PRD sits, to the same missing folders, and these are the document's authorization pointers —
  nearly every `owner-confirmed:` marker in the body is one. So the drafted rule, applied literally,
  repairs the version line and leaves the body dead. The repair extends without the prefix:
  `prd_trail/` → `trail/prd/`, `srs_trail/` → `trail/srs/`. All nine distinct files cited
  (`prd_trail/cycle-{1,2,5,7,8,9,10}.md`, `srs_trail/cycle-{1,5}.md`) exist at their new location —
  checked one by one on 2026-09-01.

  **The pinned exception is inert here.** The item said this document carries 0 commit-pinned
  citations; that was checked against the `docs/`-prefixed form only. Re-checked on the whole file
  for any `@<sha>:` form: still 0. Nothing has to be excluded from the PRD's repair.

  **The undercount is this document's alone.** The same two greps on the five siblings give equal
  totals — SRS 80/80, SDD 40/40, UXD 71/71, DESIGN 30/30, CONTENT 12/12 — so the sibling companions'
  own counts and drafted repairs stand, and the repo-wide figure they all quote moves from 235 to
  **295** for the PRD's reason only. I did not revise the sibling items for that figure: it is
  context in each of them, not the repair, and each item's repair is correct for its document. The
  one operational consequence is recorded in the PRD's slot instead — a sweep whose pattern requires
  the `docs/` prefix misses this file almost whole.

  **Check 1.** The edit lands in `docs/PRD.md`, the CPO's own document, and binds nobody outside it;
  no unseeable ground. Yours, in the owner's seat. **Check 3.** Nothing the PRD states changes, and
  the answer agrees with the UXD companion's already-filled § 2.1 (same repair, same pinned
  exception). One thing the fold owes that no item says: the writing bar's § 1.6 requires a change to
  a settled statement to be recorded in the document with its reason, and the PRD's own version line
  is where it records changes (`docs/PRD.md:5`, and the template note at `:7-11`) — the slot names
  `nozoki@1e8bf3d` as that reason so the fold has it in hand. **Check 4.** *Concurrent:* if the owner
  runs one sweep across the six documents before re-running `product-prd`, the fold meets a document
  already repaired and the confirmed item becomes a no-op — the answer still folds cleanly. If the
  fold runs first with only the drafted rule, 60 pointers stay dead, which is why the addition is
  load-bearing rather than a footnote. *Stale:* the pointers went dead once because a folder moved
  and the citing documents were not in the sweep; nothing in this answer prevents a second move doing
  it again, and I have not proposed a citation form that would — that is a convention question for
  the seat that owns `kensaiapp_structure.md` § *A trail is not the document's sibling*, not a PRD
  item. Named, not covered.

  **What I was close to deciding differently:** the item's closing sentence leaves *how* the repair is
  done — one sweep or six cycles — as the owner's call, and I considered leaving the whole item for
  them on that ground. It does not hold: the slot decides whether the PRD's pointers are repaired and
  to what, not the mechanism, and the mechanism binds nobody. My answer on it, for the record: one
  mechanical sweep across all six product documents (pattern `\b[a-z]+_trail/`, excluding the
  `@<sha>:` form), then each producing skill's re-run folds a no-op and closes its companion.

## Left for the owner

None this run.

## Skipped

None this run.

## Companions opened

- **`/Users/eyalgolan/projects/kensai/kensaiapp-opensource/system/projects/nozoki/agari_open_issues.md`** — **opened** — companion to `agari.md`, landed in commit `acaff0f`
- **`/Users/eyalgolan/projects/kensai/kensaiapp-opensource/system/doctrine/writing_bar_open_issues.md`** — **opened** — companion to `system/doctrine/writing_bar.md`, landed in commit `4e974c0`

Both are entry-2 openings — documents this run read while answering, each with two or nine trail
citations now dead on the instance side (`system/projects/nozoki/agari_trail/`,
`system/doctrine/writing_bar_trail/` — moved under `trail/` at `kensaiapp-opensource@cca5603`,
citing documents not updated). The same defect reaches five more instance documents this run did not
read — `doctrine_structure.md` 2, `visual_direction.md` 6, `visual_restrictions.md` 20,
`voice_direction.md` 14, `voice_restrictions.md` 13; 66 in all across seven — and no companion is
opened on those here: raising one means having read the document, and each opened companion says so
and carries the count, so the owner's sweep can take all seven at once.

## Launchers owed

- **`docs/PRD.md`** — `/Users/eyalgolan/projects/kensai/kensaiapp-dev/core/launchers/launch-product-prd/launcher.sh nozoki`
- **`system/projects/nozoki/agari.md`** — `/Users/eyalgolan/projects/kensai/kensaiapp-dev/core/launchers/project-agari/launcher.sh nozoki`
- **`system/doctrine/writing_bar.md`** — `/Users/eyalgolan/projects/kensai/kensaiapp-dev/core/launchers/kensaiapp-writing-bar/launcher.sh /Users/eyalgolan/projects/kensai/kensaiapp-opensource`
