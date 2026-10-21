# Self-answer report — `docs/adr/` and `docs/nfdr.md`

## Header

- **Companion:** `docs/architecture_open_issues.md`
- **Document:** `docs/adr/` and `docs/nfdr.md` (the one item names `docs/nfdr.md`; none touches a record)
- **Decided by:** `<CORE>/../skills/companion/.claude/skills/companion-self-answer/prompts/rich.md` v1.3.1
- **Date:** 2026-10-22
- **Sources re-read:** None. No answer rests on a source outside this repository.
  **What was read in this repository:** the NFDR's header and QC-2 in full (`docs/nfdr.md:L1-L120`), and
  every line of it that names `checks/read-only.sh` (`grep -n 'read-only.sh' docs/nfdr.md`). Not the whole
  NFDR (6,389 lines). The ADR index. In the SDD, C-I3's restore passage (`docs/SDD.md:L815-L840`) and the
  S-4 promise clause (`:L2095-L2110`), and the item that re-said them, `docs/trail/sdd/cycle-51.md` § 5.1.
  `checks/read-only.sh` at `ka-reader@c268945`: its header (`:L1-L37`), `manifest()` (`:L45-L65`),
  `restore()` (`:L209-L212` and its guard), and the main flow (`:L355-L403`). The script at `HEAD`
  (`ka-reader@b5c8042`) is byte-identical to `c268945`'s, and `git diff --stat c268945 HEAD -- . ':!docs'`
  prints nothing.

## Items worked

### 3.1 — QC-2's three locators into `checks/read-only.sh` no longer name what they cite

- **Bucket:** 3. Raised from downstream — an item from a seat that did not write these records
- **Verdict:** confirmed with addition
- **Why:** The PM's proposal is right, and it answers a smaller question than QC-2 needs answered.
  Confirmed: every fact in the item holds at `ka-reader@c268945`. `:L73-L76` is the usage refusal, the
  hashing header is `:L19-L22`, the restore header is `:L24-L29`, `restore()` is at `:L210`, the first hash
  is at `:L368`, and `:L31-L36` states what goes once the verdict is taken. The fix is a correction, not a
  widening. It states no new case, so § *A widening item waits until it occurs* does not apply. The seat
  is this document's. The change lands in QC-2, and it binds nobody outside the document, so the run
  answers it in the owner's seat.
  **Addition 1, the full locator set.** "Pin the three" leaves the fold to work out what each one now
  points at, so the answer names them. The restore is `:L210-L252` with its header `:L24-L29`. The removal
  is `:L31-L36`. The hashing is `:L19-L22` and `manifest()` at `:L45-L65`, run once after the restore
  (`:L368`) and once after the walk (`:L389`). These are the same locators the SDD's fold took for C-I3 on
  the same commit (`docs/trail/sdd/cycle-51.md` § 5.1), so the two documents cite the script the same way.
  **Addition 2, the label.** The item says "only its locators moved". Check 3 shows that is not all. The
  SDD is the input QC-2 traces to through C-I3, and on the same facts its v56 fold dropped the label
  "in-place restore" from both places it stood (`docs/SDD.md:L824-L829`, `:L2103`). The reason was that
  the archive is now unpacked in scratch space and only the entries the fixture lacks are copied in. QC-2
  still says "the script's in-place restore" twice, at `docs/nfdr.md:L101` and `:L116`. Left alone, the
  NFDR would name the mechanism one way and its input another. That is one of the prompt's grounds for a
  change on its own ("It contradicts a document it must agree with"). It has the same seat and lands in
  the same sentence, so it rides this item's slot rather than a new one.
  **The claim stands.** It survives every failure path. *Absent*: a fixture with no archive beside it,
  such as `plain`, makes `restore()` return at once (`:L212`), and the fixture is walked as it is.
  *Refused*: a restore that fails exits before the first hash (`:L366`), so no `unchanged` is ever printed
  over a half-built fixture. *Stale*: the pinned commit is the fix. A locator that moves later is a
  re-measurement against a named commit, not a false statement. *Concurrent*: two walks of one fixture at
  once is a case the SDD names as uncovered (`docs/SDD.md:L820-L824`). QC-2's sentence makes no claim
  about it, and this answer adds none.
  **What would have tipped it.** If QC-2's "builds whole" had depended on the extraction being in place,
  the claim itself would have moved, and the verdict would have been an override. It does not. The
  fixture is whole before the first hash either way.

## Left for the owner

None this run.

## Skipped

None this run.

## Companions opened

None this run.

## Launchers owed

- **`docs/adr/` and `docs/nfdr.md`** — `<CORE>/launchers/skill/launcher.sh product-architecture ka-reader`
