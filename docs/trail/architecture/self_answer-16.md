# Self-answer report — `docs/adr/` and `docs/nfdr.md`

## Header

- **Companion:** `docs/architecture_open_issues.md`
- **Document:** `docs/adr/` and `docs/nfdr.md` (NFDR v15, Draft, at `ka-reader@8d6f4c6`)
- **Decided by:** `decide_companion_answers.md` v1.3.0
- **Date:** 2026-09-24
- **Sources re-read:**
  - GitHub Actions run 35968105480 (`gh run view 35968105480 --json status,conclusion,headSha,headBranch,event`):
    `completed`, `success`, branch `main`, event `push`, `headSha` `c461b29ec27e…`.
  - The same run's log (`gh run view 35968105480 --log`, 646 lines). Runner image header:
    `Image: macos-14-arm64`, `Version: 20260831.0302.1`, operating system `macOS 14.8.9` (`23J631`).
    `Test gate` ran `cargo test --workspace --locked && swift test --package-path ka-reader-mac`.
    `grep -iE 'swift-?version|Apple Swift|swiftlang|toolchain'` finds only two lines, both
    `Write swift-version-76B232A4806BA581.txt`, a build file's name. No line names a Swift version.
  - `gh run list --branch main --workflow CI --limit 15`: five runs on `main`. The newest is
    35968105480 (`c461b29`). The four before it are on `a4ab8e6`, `e7b2bcd`, `3ab7e03` and
    `9b192fc`. None of those four contains `0aca57e`, and `git show <sha>:.github/workflows/ci.yml |
    grep -c 'swift test'` prints `0` for each of them and `1` for `c461b29`.

**What was read.** The companion whole. `docs/nfdr.md`'s header and version note (`:L1-L37`), § 1's
opening paragraph (`:L41-L61`), § 9 whole (`:L858-L1026`) and § 10 whole (`:L1028-L1089`). The body
from `:L62` to `:L857` was scanned for claims about CI runs on `main` (`no CI run`, `origin/main`,
`not yet measured`, `first CI`, run ids). The one hit is QC-62's runner reading (`:L370-L371`), a
branch run that this item does not touch. `docs/trail/architecture/self_answer-15.md`, the run that
raised this item, was read for what it measured. `.github/workflows/ci.yml` was read whole at HEAD
and `:L15-L32` at `c461b29`. `git log origin/main..main` counts 21 commits: local `main` is ahead of
the last pushed commit, which is `c461b29`.

## Items worked

### 2.1 — § 9 says no CI run on `main` has built `ka-reader-mac`. Run 35968105480 on `main` did, and its log names no Swift version

- **Bucket:** 2. Choices to confirm — the Principal Architect drafted a best-effort answer; confirm or override
- **Verdict:** confirmed with addition
- **Why:** The draft holds, and it holds for the reason it gives. *Check 1:* the change lands in
  `nfdr.md` § 9. That is this companion's document, and the change binds only the record's own
  accuracy, so the item is this seat's. *Check 2:* every fact in the drafted clause
  (`nfdr.md:L967-L985`) was re-read at its source (§ Header). The run is `success` on `main` at
  `c461b29`. Its image and macOS version match. Its only `swift-version` lines are a build file's
  name. The claim that it was the *first* such run is also true: none of the four earlier runs on
  `main` had `swift test` in `ci.yml`. The draft applies the bullet's own rule correctly. The first
  log does not name a toolchain, so the line stays *not yet measured*. The review gate and the four
  departures also stay put. The draft takes the stale sentence out of the present tense and keeps it
  as dated history. It does not delete it. *Check 3:* the drafted clause matches the rest of the
  document. The v15 header note (`:L5`) describes the same draft. The bullet's `verified by` tail
  (`:L1016-L1022`) still reads "until a CI log on `main` names the toolchain", which agrees with it.
  The citations `ci.yml:L18`, `:L26`, `:L29` and `:L22-L29` all still hold at HEAD. `Test gate` is
  still at `:L25-L26`, and no step between `:L22` and `:L29` runs `swift --version`. *Check 4:* the
  clause has to stay true as things change. It does, for these reasons. **Stale:** local `main` is
  21 commits ahead of `origin/main`, so the next push makes a new run. Without a `swift --version`
  step, that run's log will also name no toolchain. The clause already covers this: it waits for a
  log that does, and the drafted parenthesis makes adding that step the delivery tier's call.
  **Absent:** if GitHub stops serving this run's log, the clause still stands, because it records
  what the log said and does not only point at it. **The addition** is a consequence the draft did
  not follow. The clause's closing parenthesis names `docs/architecture_open_issues.md` § 2.1 as
  where the owner confirms it. The fold that takes this answer deletes that file. Left alone, the
  parenthesis would point at nothing. The fold re-points it to the trail cycle that keeps this
  answer, in the form every earlier cycle pointer in these entries takes. For example,
  `cycle-11.md` § 3.4 appears at `:L971-L972`. This is not a hypothetical risk: v15 itself had to
  re-point two dead *Open Questions* pointers (`:L5`). I considered a plain *confirmed*, because the
  fold might re-point the parenthesis anyway. I chose the addition because nothing in the draft
  asks the fold to do it.

## Left for the owner

None this run.

## Skipped

None this run.

## Companions opened

None this run.

## Launchers owed

- **`docs/adr/` and `docs/nfdr.md`** — `<CORE>/launchers/skill/launcher.sh product-architecture ka-reader`
