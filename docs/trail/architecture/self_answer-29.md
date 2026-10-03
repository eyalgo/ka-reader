# Self-answer report — `docs/adr/` and `docs/nfdr.md`

## Header

- **Companion:** `docs/architecture_open_issues.md`
- **Document:** `docs/adr/` and `docs/nfdr.md`. The NFDR is v27 and `Settled` (`docs/nfdr.md:L3-L5`).
  The PM opened this companion on 2026-10-03, after `nozoki@b158052` landed (`docs/architecture_open_issues.md:L19-L23`),
  and it carries one item, § 3.1, about `nfdr.md` only. No ADR is touched.
- **Decided by:** `decide_companion_answers.md` v1.3.0
- **Date:** 2026-10-03
- **Sources re-read:** one source outside this checkout: the remote, read for the *How a suite joins*
  record. After `git fetch origin`, `origin/main` is `d234b57`. `git merge-base --is-ancestor b158052
  origin/main` fails, so the merge that landed the suite has not been pushed, and
  `git rev-list --count origin/main..main` prints `66`. The newest run in
  `gh run list --repo kensaiapp/nozoki --workflow ci.yml` is 36958237363 (`success`,
  2026-10-02T03:00:44Z, "product-design: clarify the reading panel path line during pending"), which
  predates `b158052`. Everything else rests on this repository's own tree at HEAD `nozoki@0670083`.

## Items worked

### 3.1 — § 10's linked-tree row omits the suite `checks/entry-points.sh` now has, and § 9 counts seven suites where eight are on steps

- **Bucket:** 3. Raised from downstream — an item from a seat that did not write these records
- **Verdict:** answered
- **Why:** **Both halves are corrections to the NFDR, and the fold takes both. No record moves and no
  `QC` is added.** The item has no draft. Both of its questions belong to this document, so they are
  answered together in one slot and not split. It is a correction, not a widening: § 10's own rule
  and § 9's own pinned count now read false against the tree, which is the case the prompt's
  *A widening item waits until it occurs* keeps out of that section. Every claim in the item holds
  when re-measured:
  - **(a) § 10's QC-30 / QC-58 linked-tree row gains its suite tag**, so it reads
    "`checks/entry-points.sh` (suite `test_entry_points.sh`) against `checks/entry-points.allow`".
    § 10's preamble makes the tag a rule. A row naming a script that has a suite under
    `checks/tests/` names that suite beside it (`docs/nfdr.md:L1233-L1235`). The row at `:L1273`
    carries none. The tag is earned, and does not just match a filename: per its header, the suite
    drives the real `checks/entry-points.sh` through its own seams, against the allow list
    (`checks/tests/test_entry_points.sh:L8-L17`). Its cases include the clean tree passing, an
    unlisted read, a stale list line and a package that cannot be opened (`:L44-L60`). Those are the
    failures QC-30's half (2) says the script exits non-zero on (`docs/nfdr.md:L599-L604`). The suite
    also runs as its own fatal step, `Entry-points check suite` (`.github/workflows/ci.yml:L37-L38`).
    `grep -nE 'continue-on-error|^[[:space:]]+if:' .github/workflows/ci.yml` prints nothing. That
    meets the preamble's whole meaning of the tag. The row's other cells hold: it already says
    `CI build`, and that matches the step `Entry-points check` (`ci.yml:L34-L35`).
  - **(b) § 9's count becomes eight**, re-measured and re-pinned, in the place § 9 itself names as
    the count's one home (`docs/nfdr.md:L1074-L1075`). The pin is `nozoki@b158052`, the merge that
    landed the suite. Nothing that pin covers has moved since: `git diff --stat b158052 0670083 --
    .github/workflows/ci.yml checks/` prints nothing. At that pin `ls checks/tests` lists eight
    `test_*.sh`. Each is the whole `run` of its own step: `:L31-L32` `test_structure.sh`;
    `:L37-L38` `test_entry_points.sh`; `:L47-L48` `test_bundle.sh`; `:L53-L54` `test_view.sh`;
    `:L64-L65` `test_renderer.sh`; `:L73-L74` `test_read_only.sh`; `:L79-L80`
    `test_no_network.sh`; `:L82-L83` `test_own_state.sh`. The test command (`:L26`) still runs none
    of them. The bullet's own *verified by* loop (`for s in checks/tests/*.sh; do grep -q "$s"
    .github/workflows/ci.yml || echo "$s"; done`) prints nothing at HEAD. The old seven-suite
    sentence goes into the bullet's history, the way the v25 six did (`:L1075-L1079`). § 9 calls
    this case "a re-measurement of this sentence and not a contradiction of it" (`:L1072-L1073`).
  - **Checked against the inputs (check 3).** The Settled SDD, v25, already describes this state.
    The `read-only-harness` row lists `entry-points.sh` with `entry-points.allow`, and "one
    `test_<name>.sh` suite for each of the eight scripts above, each the whole `run` of its own CI
    step" (`docs/SDD.md:L332`, pinned at `nozoki@7a125b4`). The NFDR is behind its input here, not
    ahead of it. No other count of suites stands in the NFDR: `grep -nE '[Ss]even suites|all seven'
    docs/nfdr.md` finds only `:L1065`, `:L1067` and Review Notes history (`:L3096`, `:L3352`).
  - **What the fold also owes, so the bullet does not go stale while it is being fixed (check 4,
    the stale and absent cases).** The bullet's *How a suite joins* rule holds that a suite's first
    CI run is its hosted-runner reading, and that the bullet records it (`docs/nfdr.md:L1087-L1105`).
    For `Entry-points check suite`, and for `Entry-points check` beside it, that run has not
    happened: `nozoki@b158052` is not on `origin/main`, which is `d234b57` (Sources re-read). The
    fold should write that state the way the bullet wrote it for the five earlier suites. Both steps
    are fatal and not yet run on the hosted runner, and the first push carrying `b158052` is their
    reading. The tail's review gate stands for the same reason it stood before: no script in the
    tree compares `checks/tests/` against `ci.yml`. `grep -l 'ci.yml' checks/*.sh checks/tests/*.sh`
    prints nothing, and that holds now that `structure.sh` and `entry-points.sh` are in the tree.
    The tail's `ls checks/*.sh` at `nozoki@ab39502` stays true at its own pin, so re-pinning it is
    optional.
  - **What would have tipped me elsewhere.** If the suite only matched the script's name and did not
    drive the script against the list, half (a) would have been *overridden*, and the row would have
    stayed untagged, because the tag "does not reach a rule the script does not hold"
    (`docs/nfdr.md:L1239`). It does drive the script, so the tag stands.

## Left for the owner

None this run.

## Skipped

None this run.

## Companions opened

None this run.

## Launchers owed

- **`docs/adr/` and `docs/nfdr.md`** — `<CORE>/launchers/skill/launcher.sh product-architecture nozoki`
