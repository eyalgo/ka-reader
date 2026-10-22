# Self-answer report — `docs/SDD.md`

The record of one unattended run that met `docs/SDD_open_issues.md` in the CTO's seat on 2026-10-22
and decided its one item. It is for the owner, who reads it to learn what was decided and on what,
and for the `product-sdd` run that folds the answer.

## Header

- **Companion:** `docs/SDD_open_issues.md`
- **Document:** `docs/SDD.md` (v56, `Status:` Settled)
- **Decided by:** `<CORE>/../skills/companion/.claude/skills/companion-self-answer/prompts/rich.md` v1.3.1
- **Date:** 2026-10-22
- **Sources re-read:** one. GitHub Actions' state on the repository — the row's "hosted result is
  unread" bound rests on it — re-read at its source: `gh api repos/eyalgo/ka-reader/actions/permissions`
  → `{"enabled":false,"sha_pinning_required":false}` on 2026-10-22. Every other claim is inside this
  repository and was read at its own locator in the main checkout, read-only, at `ka-reader@9a765e8`,
  whose tree outside `docs/` is `389adad`'s (`git diff --stat 389adad 9a765e8 -- . ':!docs'` prints
  nothing). Measured: `grep -c '^run_step' checks/gate.sh` → 28 at the tip, 27 at `8b93322`
  (`git show 8b93322:checks/gate.sh | grep -c '^run_step'`); `git diff --name-status
  --diff-filter=ADR 8b93322 HEAD -- checks` → nothing; `git diff --stat 8b93322 HEAD -- checks
  .github crates/ka-reader-core/tests` → 22 files, all under `checks/`; `git diff --stat c268945
  HEAD -- checks` → 21 files, `read-only.sh` 3 lines, `test_entry_points.sh` 3 lines;
  `git show --stat ae72bdc` → the same 21 files; `git merge-base --is-ancestor c268945 ae72bdc` →
  true; `git diff 8b93322 HEAD -- checks/gate.sh` → the version line at `:L2`, two comments
  re-wrapped, and the step with its six-line comment at `:L51-L57`; `git diff c268945 HEAD --
  checks/read-only.sh` → the usage line at `:L6` wrapped into two, nothing else; every locator the
  row and § 4 C-I3 carry into `checks/` was read at its pin and found again at the tip by its own
  line (the map is in the answer); `cat -n .github/workflows/ci.yml` `:L25-L26`, `:L31-L32`,
  `:L34-L39` → the gate step, packaging and upload, unchanged; `grep -n '26 steps' docs/*.md
  docs/adr/*.md` → `docs/SDD.md:L368` and `docs/nfdr.md:L1577` only; `grep -n 'gate.sh' docs/SDD.md`
  outside the review notes → `:L368`, `:L824`, `:L882`; `grep -n -i sanitizer docs/SDD.md` → R-13
  (`:L3195-L3202`), R-14 (`:L3221`), and dated review notes only.

## Items worked

### 5.1 — § 3's `read-only-harness` row counts the gate at 26 steps; at `ka-reader@389adad` it has 27

- **Bucket:** 5. Raised from downstream — an item from a seat that did not write the SDD
- **Verdict:** confirmed with addition
- **Why:** The item's lean holds — a dated reading of the 27-step gate at a named commit, its
  locators re-pinned, the `8b93322` inventory kept as a dated note — and it stops short of what the
  fold has to move, so it is confirmed with the rest measured and added.

  *Check 1.* The edit lands in `docs/SDD.md` § 3's `read-only-harness` row and in two C-I3 clauses
  that carry the same script's locators. The item carries `Seat: cto`, this run's posture. The
  answer binds nothing but the document's agreement with the tree: no person, no outside party, no
  risk the owner carries, and no ground I cannot name. The one call near the edge — whether the
  step's `-asan-globals=0` meets `docs/nfdr.md` QC-13 — is not made here: it is the Principal
  Architect's, already on `docs/architecture_open_issues.md` § 3.2, and the answer states the flag as
  what is on disk and leaves the ruling there. Mine, in the CTO's seat.

  *Check 2.* The item sits under *Raised from downstream*, cites its occurrence (`389adad`), and
  corrects a count found false — the row's own rule calls a later `checks/` change a re-measurement,
  not a contradiction — so it widens nothing and "not until it occurs" does not apply. The lean
  reaches the right conclusion and is incomplete in three places, each added. (a) `gate.sh`'s
  locators stand outside the row too — C-I3's dispatcher locator at `docs/SDD.md:L824` and its
  *Build KA-Reader.app* / *View check* locators at `:L882` — and a fold that re-pins the row alone
  leaves two stale. (b) The item names the `ae72bdc` re-wrap and leaves the re-read to the fold;
  I did it. Twenty-one files moved, and every one of the row's locators into them was found again
  by content; the answer carries the map so the fold pins rather than searches. The one file with
  a single-line shift, `read-only.sh`, carries eighteen of C-I3's locators, all one line higher.
  (c) What the step is, as the row describes every other step by what it does: the crate, the
  nightly named inside the command, the two flags, and `RUSTUP_AUTO_INSTALL=1` — a toolchain fetch
  on first run, which the row should say because every other step runs offline. The item is one
  question with one landing and one seat; it does not split. The step count in `docs/nfdr.md` § 8
  is not a second seat inside this item — it is another document's, and it is already raised there.

  *Check 3.* Nothing settled moves. The row's pin rule is what the answer applies. § 11 R-13 says the
  bridge's tests run under `-Zsanitizer=address` in CI on every build; the step makes that true of
  the gate and the answer does not touch R-13. The dated review note at `docs/SDD.md:L5789-L5793`
  recorded the tree not carrying the run; dated, it stays. The row's dated notes point at
  `docs/architecture_open_issues.md` §§ 3.1 and 3.3 of an earlier companion, since folded and
  removed (`ka-reader@435bb4e`) and re-opened today with different items; they are inside dated
  "Measured at" parentheses and stay as history, as the row's convention holds. `ci.yml`,
  `checks/fixtures/` and `crates/ka-reader-core/tests/` did not change, so the workflow, fixture
  and Rust-test locators hold as pinned. The station that landed the step is open
  (`system/projects/ka-reader/journey/shukuba/2026-10-22_the-sanitizer-step-runs.md`, reached by its
  own refine), read as an input and cited nowhere in the answer.

  *Check 4.* **Stale** — the answer is pinned to `389adad`, the merge; the tip read, `9a765e8`,
  holds its tree outside `docs/`, and a `checks/` change landing before the fold is, by the row's
  rule, one more item. **Absent** — the gate was not run here, and the nightly was not fetched: the
  answer says so and rests on the station's reached-when (the gate exited 0 in the guest with the
  step in it) and on the script read whole; a guest with no network and no cached nightly fails
  the step loudly, which is what the `RUSTUP_AUTO_INSTALL=1` sentence is for. **Concurrent** — two
  gates at once share one `target/` and one rustup home; nothing in the row speaks to it and the
  gate runs its steps in order, so it is named, not covered. **Refused** — a host whose rustup
  refuses the nightly ends the run at that step with the step's name, by the dispatcher; the row's
  "each fatal" already says this. **Empty** — not reached; the list is never empty.

  *Close to a different verdict.* Plain *confirmed* was close: the item's lean is right as far as it
  goes. What tipped it is (a) — two `gate.sh` locators the row does not own would have been left
  pointing at the wrong lines by a fold that confirmed the item as written.

## Left for the owner

None this run.

## Skipped

None this run.

## Companions opened

None this run.

## Launchers owed

- **docs/SDD.md** — `<CORE>/launchers/skill/launcher.sh product-sdd ka-reader`
