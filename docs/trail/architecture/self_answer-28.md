# Self-answer report — `docs/adr/` and `docs/nfdr.md`

## Header

- **Companion:** `docs/architecture_open_issues.md`
- **Document:** `docs/adr/` and `docs/nfdr.md`. The NFDR is v26 and `Draft`, because this companion
  stands (`docs/nfdr.md:L3-L5`). The companion carries one open slot, § 2.1, which the v26 fold
  drafted into § 9 (RN-37, `docs/nfdr.md:L3330`). That item is about `nfdr.md` only. No ADR is touched.
- **Decided by:** `decide_companion_answers.md` v1.3.0
- **Date:** 2026-10-03
- **Sources re-read:** None. The answer rests only on this repository's own tree: `ci.yml` at
  `nozoki@0aca57e`, `nozoki@ab39502`, `nozoki@463acb9` and HEAD `nozoki@7ef2386`.

## Items worked

### 2.1 — § 9's `nozoki-mac` bullet re-cites the two `ci.yml` pointers that moved, pinned to `nozoki@463acb9`

- **Bucket:** 2. Choices to confirm — the Principal Architect drafted a best-effort answer; confirm or override
- **Verdict:** confirmed
- **Why:** The draft corrects a false pointer, and every pointer it writes is true. I re-measured
  each one.
  - At `nozoki@0aca57e`, `.github/workflows/ci.yml:L29` is `run: nozoki-mac/assemble.sh`, so the v25
    citation was true when it was written (`git show 0aca57e:.github/workflows/ci.yml`).
  - At `nozoki@463acb9`, `:L29` is `run: checks/structure.sh` and `:L35` is `run: nozoki-mac/assemble.sh`.
    `:L26` is still `cargo test --workspace --locked && swift test --package-path nozoki-mac`.
    `:L28-L32` are `Structure check` and `Structure check suite`, which is the six-line shift the
    draft names (`git show 463acb9:.github/workflows/ci.yml | cat -n`).
  - `git diff --stat 463acb9 HEAD -- .github/workflows/ci.yml` prints nothing at HEAD `nozoki@7ef2386`.
    The pin therefore reads the file as it is today, not only as it was.
  - `grep -n 'swift --version' .github/workflows/ci.yml` prints nothing and exits 1. The clause's
    *no `swift --version` step* still holds for the whole file. The widened range `:L22-L35` reaches
    the build step again, which the old `:L22-L29` no longer did.

  The draft's argument also holds for the reason it gives. It applies the rule from the owner's
  seat's answer at `docs/trail/architecture/cycle-23.md` § 3.2: re-cite pinned to a commit, so the
  next inserted step leaves the citation dated rather than wrong. The fold already applied that rule
  to § 9's `checks/tests/` bullet at the same pin (`docs/nfdr.md:L1063-L1073`). Pinning the sibling
  bullet to the same commit keeps § 9 readable against one tree.

  **The verdict I came close to.** `self_answer-27.md` § Raised on this document named an
  alternative: keep `:L29` and pin it to `nozoki@0aca57e`. That is just as true, but it points a
  reader at a tree two structure steps behind today's. They would have to check out an old commit
  to confirm a step that still exists. It would also split § 9 across two pins for one file. What
  would have tipped me to it: if a later commit had moved `ci.yml` again between `463acb9` and HEAD.
  None has.

  **Check 3, against the settled record.** The other `ci.yml` line citations in §§ 1–10 are either
  pinned or still true at HEAD:
  - QC-62's tail is pinned to `nozoki@ab39502` (`docs/nfdr.md:L500-L502`). At that commit `:L46-L47`
    is `Renderer gate` and `:L31-L32` is `Bundle probe`, as written.
  - The unpinned `ci.yml:L26` (`:L1071`, `:L1143`) and `ci.yml:L18` (`:L1174`) read `swift test` and
    `runs-on: macos-14` at HEAD.

  ADR-0012 cites `:L43-L44` unpinned
  (`docs/adr/0012-renderer-run-proved-on-the-shipped-bundle-beside-the-wall.md:L77`). It is
  `Accepted` (`:L3`), so it is append-only, and its own later line dates the move (`:L140`). The
  item is right that it does not move. A line pointer is no change of decision, so it does not earn
  a superseding record.

  **Check 4, on the failure paths.** Stale is the path this draft exists for: another step inserted
  above `:L35` makes the pointer dated, not false. The whole-file grep stays the live check on the
  *no `swift --version` step* claim. If a later change adds such a step, the grep prints it and the
  clause's *not yet measured* reading is owed a re-measurement. That is the behaviour wanted. Empty,
  absent, concurrent and refused do not apply to a line citation. `nozoki@463acb9` is a merge commit
  on `main`, so the pin stays reachable.

  **Read, and not re-read at its source.** The bullet's runner-image facts — `macos-14` carrying
  Xcode 15.0.1 – 16.2 with 15.4 the default (`docs/nfdr.md:L1135-L1136`, `:L1174-L1175`) — rest on a
  vendor's published image. This answer does not rely on them, so check 3's source rule did not
  reach them.

## Left for the owner

None this run.

## Skipped

None this run.

## Companions opened

None this run.

## Launchers owed

- **`docs/adr/` and `docs/nfdr.md`** — `<CORE>/launchers/skill/launcher.sh product-architecture nozoki`
