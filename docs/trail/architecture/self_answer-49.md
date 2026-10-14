# Self-answer report — `adr/` and `nfdr.md`

## Header

- **Companion:** `docs/architecture_open_issues.md`
- **Document:** `docs/adr/` and `docs/nfdr.md` (v50, Settled), the item reaching `docs/nfdr.md` only
- **Decided by:** `<CORE>/../skills/companion/.claude/skills/companion-self-answer/prompts/rich.md` v1.3.1
- **Date:** 2026-10-14
- **Sources re-read:** GitHub Actions, at the source and not from the item or the SDD:
  `gh run view 38577309118 --repo kensaiapp/ka-reader --json …` → `headBranch` `main`, `headSha`
  `f3570082ed190b472635d7c87c391fc36c3170a8`, `event` `push`, `createdAt` 2026-10-14T14:04:45Z,
  `conclusion` `success`, job `wall` with step *Bundle probe suite* `success`. The run's log, through
  QC-25's own command (`awk -F'\t' '$2 == "Bundle probe suite" && /out-of-grant-read:/'`), prints
  exactly one line: `wall	Bundle probe suite	2026-10-14T14:15:35.9622300Z out-of-grant-read: denied`.
  The log's *Set up job* step prints `Image: macos-26-arm64`, `Version: 20260907.0351.1`, macOS
  `26.6.2` `25G83`. `gh run list --branch main --limit 5` lists 38577309118 as the newest run on
  `main`, with 38551538187 (`24be581`) and 38501500758 (`3f7a68d`) the earlier `success` runs.
  Repository: `git merge-base --is-ancestor 970ad65 f357008` holds, and `origin/main` is `f357008`
  after a fetch.

## Items worked

### 3.1 — QC-25's hosted reading has been taken on `macos-26` and reads `denied`, but the entry still says it has not been read

- **Bucket:** 3. Raised from downstream — an item from a seat that did not write these records
- **Verdict:** answered
- **Why:** **Fold it into `nfdr.md`. The narrowing stands, re-dated to run 38577309118 and image
  `macos-26-arm64` 20260907.0351.1. The not-yet passage becomes a dated account, and the break rule
  is now live.**

  *Check 1, the seat.* The change goes into `nfdr.md` § 2 QC-25 and § 10's QC-25 row, which this
  seat writes. It commits nobody to anything outside the document. The only upstream fact it rests
  on, SDD C-I3's probe half, has already moved the same way (below), so nothing goes upstream. This
  is not an owner's call either. QC-25's tail says what a `denied` reading does: it "leaves the
  narrowing standing, re-dated here with the run id and the image version, and the first reading on
  each image version is the one recorded" (`docs/nfdr.md:850-852`). That rule was set on the owner's
  seat's answer (`docs/trail/architecture/cycle-41.md` § 3.2, RN-59), and applying it decides
  nothing new.

  *Check 2, the question.* The item has no draft. Its "If a document has to be written: none. This
  is a fold" is a lean, and it holds. This is a correction, not a widening: QC-25 states something
  that was true at v50 and is false now ("**The hosted reading is not yet taken**",
  `docs/nfdr.md:827-828`; "the narrowing has not been read there", `:811-812`). So § *A widening
  item waits until it occurs* does not apply. The question is one question with one seat, so there
  is no split. There is one more consequence the item does not name, and it belongs to the same fold:
  QC-25's trace reads C-I3 "as it reads at SDD v50" (`:868-872`), and the SDD is now v51.

  *Check 3, the settled record and the source.* I re-read the reading at GitHub; see the Header's
  *Sources re-read*. Every fact the item states matches the run: the commit, that it holds
  `970ad65`, the step conclusion, the image and its version, the OS build, and the one `denied` line.
  The SDD already agrees. SDD v51 (`ka-reader@761bd6e`, RN-111) re-dates C-I3's probe half to this
  same run and image, and keeps the narrowing standing: "on `macos-26` as on `macos-14`"
  (`docs/SDD.md:896-905`). QC-25 traces to C-I3, so the fold's trace should read C-I3 at SDD v51 and
  SDD RN-111. The NFDR then follows its input, the way RN-61 did at v50, and does not state the
  reading on its own authority. `git log f357008..HEAD -- docs/nfdr.md docs/adr` prints nothing, so
  the item's line numbers, measured at `f357008`, are still where they say. The `Inputs read:` line
  stays as it is, because the SDD's status is still Settled. No ADR names the not-yet:
  ADR-0010/0011/0012 bind the probe and the wall, not a runner reading. So no record is touched, and
  re-dating is cheap to undo and involves no trade-off, which means no new record is owed.

  *What the fold changes, by site:*
  1. **The narrowing passage (`:806-815`).** The narrowing becomes a reading of two images: `macos-14`
     at run 35797893381 (SDD RN-48), and `macos-26-arm64` 20260907.0351.1, macOS 26.6.2 (25G83), at
     run 38577309118 on `ka-reader@f357008`. That run is the first reading on this image version, so
     it is the one recorded. "CI has run on `macos-26` since `ka-reader@fcb2e2f`, and the narrowing
     has not been read there", and the "The gap overclaims nothing …" sentence that argues about that
     gap, move into a dated note. They were true at v50. "Why the runner reports it that way is not
     known" stays, because it is still true.
  2. **The runner-reading passage (`:827-836`).** "**The hosted reading is not yet taken.** Read on
     2026-10-14: …" and the "Until … an empty read is the measurable *not yet*" sentence move into a
     dated account. In their place: the boundary run exists, it is 38577309118, and from it on a
     hosted build whose *Bundle probe suite* step concludes `success` and whose log gives this command
     no `out-of-grant-read:` line breaks this entry. The rename sentence changes in step: once the
     not-yet is gone, a renamed step makes the command print nothing, and that reads as a break
     rather than as the not-yet. That is an extra reason the existing `development-design` gate on a
     workflow change that renames or drops the step stays as it is.
  3. **The trace (`:868-872`).** C-I3's probe half at SDD v51, SDD RN-111, beside the v50 reading,
     which goes into the existing dated chain.
  4. **§ 10's QC-25 row (`:1912`).** The command cell drops "whose empty read is the not-yet until a
     hosted `main` run holding `ka-reader@970ad65` concludes the step `success`, and a break after
     it". It names the break directly: an empty read on a run whose *Bundle probe suite* step
     concluded `success`, from run 38577309118 on. The row is a projection of the entry, as RN-61
     (b) put it, so it carries no dated note of its own. The gate cell does not move.

  *Check 4, the failure paths.*
  - **Stale:** the next `macos-26-arm64` image version is a new image version. The tail's own rule
    covers it: its first reading is the one recorded. A `denied` reading re-dates again. An `allowed`
    reading means "C-I3 is restated by the CTO, and this entry follows" (`:852-853`). Nothing new is
    needed.
  - **Absent:** runs 38501500758 and 38551538187 printed nothing. They stay readings from before the
    boundary, not breaks, because neither commit holds `970ad65`
    (`git merge-base --is-ancestor 970ad65 3f7a68d` and `… 970ad65 24be581` both fail, measured by this run). The fold must not call
    them breaks retroactively.
  - **Refused:** a red suite is already a red build, so the break is written only for a step that
    concluded `success`. This is RN-61 (a)'s rule, and it is unchanged.
  - **Concurrent:** a run on a branch other than `main`, or a pull-request run, is outside what the
    item asks. The entry's break clause already says "a hosted build". This answer does not widen or
    narrow it.
  - **Empty:** does not apply. There is one reading, and it is present.

  *What would have tipped it.* If the SDD had not moved at v51, the fold would still go ahead,
  because the reading is measured at the source and the NFDR's tail rule decides it. But the trace
  would then have had to name the source directly and raise C-I3 with the CTO. That route is closed:
  the SDD companion's § 5.1 was answered (`ka-reader@b236572`) and folded at v51.

## Left for the owner

None this run.

## Skipped

None this run.

## Companions opened

None this run.

## Launchers owed

- **`docs/adr/` and `docs/nfdr.md`** — `<CORE>/launchers/skill/launcher.sh product-architecture ka-reader`
