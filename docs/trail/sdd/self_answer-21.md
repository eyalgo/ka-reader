# Self-answer report — docs/SDD.md

## Header

- **Companion:** docs/SDD_open_issues.md
- **Document:** docs/SDD.md
- **Decided by:** `decide_companion_answers.md` v1.3.0
- **Date:** 2026-09-23
- **Sources re-read:** None. The answer rests on nothing outside this repository. The only external
  sources it touches are Apple's entitlement names in C-R2, and neither draft moved them.

## Items worked

### 2.3 — C-I3 still checks the bundle "against C-R2's exact list", and C-R2 and C-I3 name records that ADR-0011 and ADR-0012 now carry

- **Bucket:** 2. Choices to confirm — a seat drafted a best-effort answer; confirm or override
- **Verdict:** confirmed with addition
- **Why:** Both drafts are on disk as the item describes, and both hold. The addition is one word
  in each record line, which will not stay true.

  *Seat.* Every edit lands in `docs/SDD.md` § 4 and binds only the document's own consistency.
  It commits no person, money or risk, and no unseen ground can be named. So the item is answered
  here in the owner's seat.

  *Draft 1, C-I3's wording.* C-R2 binds "a **rule**, not held as a list" (`docs/SDD.md:L504-L535`).
  C-I3 now reads "against the set C-R2's rule admits, as the script's expected set records it —
  set equality, the expected set widened only by a change reviewed against the rule"
  (`docs/SDD.md:L638-L640`). That matches `docs/nfdr.md` QC-25's two halves: set equality against
  the set the script expects, and any widening reviewed against the rule (`docs/nfdr.md:L243-L262`).
  The contradiction the item found is gone. Checked on the failure paths:
  - Empty: before the selector slice, the expected set is C-R2's two.
  - Concurrent: two slices that each widen the set meet at one set when their changes are joined,
    and each widening is reviewed.
  - Refused: a rejected widening leaves the build red, which is the check working.

  *Draft 2, the record lines.* C-R2 names ADR-0011 as superseding ADR-0003 on acceptance, with
  ADR-0003 in force until then. C-I3 names ADR-0010 and ADR-0012. That is exactly what the index
  shows on 2026-09-23 (`docs/adr/README.md`, rows ADR-0003, ADR-0010, ADR-0011, ADR-0012). ADR-0012's
  own § Consequences says its mechanism, its control and possibly its observable's name are
  re-derived when the SDD carries the replacement renderer (`docs/adr/0012-…md:L74-L80`), and
  C-I3's line says the same.

  *Addition, the stale case (check 4).* Both lines carry the word *Proposed*, and the draft says
  the CTO moves it to *Accepted* "on the next fold here". There may be no next fold here. This item
  is the companion's last, so `product-sdd` removes the file when it folds this answer. Meanwhile
  `docs/architecture_open_issues.md` § 2.1 is already confirmed (`nozoki@c5a2e76`), so the next
  `product-architecture` run is the one that turns ADR-0011 and ADR-0012 to Accepted. After that,
  the SDD would state a status that is false, with no companion left to carry the fix. The lines
  should therefore leave the status to the index row they already cite and not copy the word.
  C-R2's conditional, "until it is Accepted, ADR-0003 is the record in force", is true in both
  states and stays as written. ADR-0012 may also be re-derived or superseded under the RC-3 work
  raised below, and pointing at the index row covers that too.

  *What would have tipped it.* I was close to a plain *confirm*, because the draft names who moves
  the word. It would have held if the SDD companion stayed open past the architecture fold. The
  companion does not stay open, because the file empties on this fold.

## Left for the owner

None this run.

## Skipped

- **§ 1 — Open issues** — none open. The section's own text says § 1.1 was folded at cycle 9.

## Companions opened

- **docs/architecture_open_issues.md** — **appended** — companion to `adr/` and `nfdr.md`, item
  § 2.3 (proposed, not drafted, slot at its placeholder), landed in commit `c2cb01c`. The SDD's
  § 10 RC-3 *Changed* says the decision log is owed superseding records for ADR-0001, ADR-0002,
  ADR-0006 and ADR-0009. It also says the NFDR is owed a re-derivation of every entry written
  against the previous shape, and that both are the Principal Architect's. The same departures
  are listed in § 12's downstream boundary (RN-60). No companion carried either debt, and the
  architecture companion's §§ 2.1 and 2.2 were both answered, so its next fold would have cleared
  it with the records still describing Tauri and WKWebView. This meets the prompt's "something
  upstream moved and it has not seen it". The SDD moved to v13 underneath the architecture records.
  Two confirmed answers on that file now read against the moved input. § 2.2's answer is "no
  record supersedes ADR-0002 until the SDD carries the replacement renderer", and the SDD now
  carries it. § 2.1's addition says QC-62's control is a "renderer-removed" build, but C-I3 at v13
  fixes that control as `checks/fixtures/idle-shell`.

Also noticed, and raised nowhere. RN-60 says the project card's `Languages:` line and test command
are owed `Swift` and `swift test` (`docs/SDD.md:L397-L399`), and that `README.md:L46-L51` is owed
new stack and proof sentences. Neither the card nor the README has a companion template on disk,
so this run wrote nothing for them. The SDD already records both as outside itself.

## Launchers owed

- **`docs/SDD.md`** — `<CORE>/launchers/product-sdd/launcher.sh nozoki`
- **`docs/adr/` and `docs/nfdr.md`** — `<CORE>/launchers/skill/launcher.sh product-architecture nozoki`
