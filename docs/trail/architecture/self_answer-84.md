# Self-answer report — `adr/` and `nfdr.md`

## Header

- **Companion:** `docs/architecture_open_issues.md`
- **Document:** `adr/` and `nfdr.md` (NFDR v89, Settled)
- **Decided by:** `<CORE>/../skills/companion/.claude/skills/companion-self-answer/prompts/rich.md` v1.3.1
- **Date:** 2026-11-09
- **Sources re-read:** None. The answer rests only on the product's own tree and the NFDR. It
  re-reads no licence text and no outside platform's behaviour. The licence grounds behind QC-41's
  statement were re-read at their sources in `self_answer-83.md` and do not move here.

The companion holds one item, in § 3. The PM raised it on 2026-11-09 against `ka-reader@98867b3`,
and it was not yet answered. The run decided it in the owner's seat. Every measurement below was
taken at `HEAD` (`b503b6d`). `git diff --stat 98867b3 b503b6d` over `checks/`, `ka-reader-mac/`,
`.github/`, `LICENSE` and `THIRD_PARTY_NOTICES.md` prints nothing, so each reading holds at both
commits. The item's *If a document has to be written* line is the PM's draft, and it was weighed as
one.

## Items worked

### 3.1 — QC-41 says no check holds the bundle's copies; `checks/bundle.sh` and its suite now hold them at every change

- **Bucket:** 3. Raised from downstream — an item from a seat that did not write these records
- **Verdict:** confirmed with addition
- **Why:** The item is right, and it is a correction, not a widening. QC-41's tail says "Two rules
  are owed to a check and held by none at `ka-reader@06e4a34`" (`docs/nfdr.md:L1619`). The tree
  now proves that false for one of the two rules:
  - `checks/bundle.sh:L358-L359` pairs the tree's `LICENSE` with
    `Contents/Resources/KA-Reader-LICENSE`, and the tree's `THIRD_PARTY_NOTICES.md` with
    `Contents/Resources/THIRD_PARTY_NOTICES.md`.
  - Its header states the rule against QC-41 by name (`:L30-L39`).
  - `checks/tests/test_bundle.sh` holds the missing, differing, symlinked and unreadable cases, by
    name (`test_licence_copy_missing_fails`, `test_notices_copy_differing_fails`,
    `test_symlinked_copy_reads_as_missing`, `test_unreadable_tree_licence_is_refused` and the rest,
    `:L156-L171`).
  - Both run through the gate's fatal `run_step`, at `checks/gate.sh:L95` and `:L97`.

  The § 10 row and the review-gate list repeat the stale claim, so all three places move together.

  - **Seat: this one.** The edit lands in QC-41, its § 10 row and § 10's closing list, all in this
    document. It commits nobody to anything. It only makes the record match what the tree holds.
    The owner's call behind QC-41 (`docs/trail/architecture/cycle-80.md` §§ 3.4–3.5) is not
    reopened. The bundle carries the copies, byte-identical, and that obligation is now enforced.
  - **The addition — four things the draft did not say:**
    1. **The release half is named, and the step behind it.** The draft says "at the change and at
       the release" and names no step. At a tag, `.github/workflows/release.yml`'s *Test gate*
       (`:L53-L54`) runs `checks/gate.sh`, so *Bundle probe* runs on
       `target/release/bundle/macos/KA-Reader.app`. *Disk image* (`:L72`) then packs that same
       path. So the bundle the check read is the one the image ships.
    2. **The copy dragged off the image has its own holder, and the tail names it.** QC-41's
       statement says "a copy of the app dragged off the image keeps them". The holder for that is
       the *Release image suite* step (`checks/gate.sh:L148`), whose
       `checks/tests/test_release_pack.sh:L205-L208` compares both files in the dragged copy with
       the tree's. The item mentions this suite but its draft line drops it. Without it, the row
       names a check that holds the built bundle and nothing that holds the image's copy.
    3. **Release inspection on the downloaded bundle stays.** The cycle-80 answer kept it. The
       draft's "at the change and at the release" could be read as replacing it. It does not: no
       command reads the bundle a stranger downloads from the release page.
    4. **The statement's locators are re-pinned in the same pass.** `ka-reader-mac/assemble.sh:L111`
       and `:L115` at `06e4a34` pointed at the icon licence's copy and at `codesign`, before the
       copies existed. At `b503b6d` the copies are at `:L120-L121`, the icon licence at `:L119` and
       `codesign` at `:L125`. The old lines are true at their own commit, so they are kept as the
       dated reading, not erased. The name the delivery tier chose, `KA-Reader-LICENSE`, may be
       stated as a reading. Choosing the name stays the delivery tier's, as QC-41 says.
  - **What stays owed.** The copyright-lines rule. `checks/notices.sh` still compares names only
    (its header, `:L4-L25`; no copyright reading in the script). So that half keeps
    `development-design` and release inspection before the first tag as its gate. This matches SDD
    v84's § 6 S-7, folded today, which says the same.
  - **Check 3.** Nothing settled moves. The SDD makes no claim that the bundle's copies are unheld
    (`grep` of `docs/SDD.md` for `KA-Reader-LICENSE` and the copies finds none). § 10's own
    preamble, that a row's `CI build` holds for the rules its command already holds, is the rule
    this answer applies.
  - **Check 4.**
    - *Absent:* a checkout without either tree file builds no bundle, because `assemble.sh`'s
      `required` loop (`:L52`) refuses it. A tree file `bundle.sh` cannot read ends its run and is
      named.
    - *Stale:* byte-identity catches a bundle built from an older notices file.
    - *Refused:* `bundle.sh` refuses to run off a macOS VM (QC-65). The gate tool runs it in the
      macOS guest, and § 10's preamble reads `CI build` as `development-implementation`, so the
      change-time gate does not lapse while Actions is off.
    - *Not covered:* the *release* half runs only on a tag push. While Actions is off there is
      none, which is true of every `release` cell in the map, and release inspection is what reads
      the published artifact.
  - **Close to plain *confirmed*.** That would have been the verdict if the draft had named the
    dragged-copy suite and kept release inspection. The tail would then be complete without
    additions.

## Left for the owner

None this run.

## Skipped

None this run.

## Companions opened

None this run.

## Launchers owed

- **docs/adr/ and docs/nfdr.md** — `<CORE>/launchers/skill/launcher.sh product-architecture ka-reader`
