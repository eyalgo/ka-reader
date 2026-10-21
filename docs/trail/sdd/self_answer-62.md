# Self-answer report — `docs/SDD.md`

The record of one unattended run that met `docs/SDD_open_issues.md` in the CTO's seat on 2026-10-22
and decided its one item. It is for the owner, who reads it to learn what was decided and on what,
and for the `product-sdd` run that folds the answer.

## Header

- **Companion:** `docs/SDD_open_issues.md`
- **Document:** `docs/SDD.md` (v55, `Status:` Settled)
- **Decided by:** `<CORE>/../skills/companion/.claude/skills/companion-self-answer/prompts/rich.md` v1.3.1
- **Date:** 2026-10-22
- **Sources re-read:** None. No answer this run gave rests on a source outside this repository.
  Every claim was read at its own locator in the main checkout, read-only, at `ka-reader@060fc76`,
  whose tree outside `docs/` is `c268945`'s (`git diff --stat c268945 060fc76 -- . ':!docs'` prints
  nothing). Measured: `git diff --name-status 8b93322 c268945 -- checks .github crates` →
  `M checks/read-only.sh`, `M checks/tests/test_entry_points.sh`, `M checks/tests/test_read_only.sh`;
  `sed -n 2,3p checks/read-only.sh` → version 1.1.0; `tar -tf checks/fixtures/<name>.git.tar | grep -v
  '^\.git/'` → `submodule` 2 members (`.gitmodules`, `submodule/.git`), `linked-worktree` 38,
  `parent-of-two` 46, `submodule-config-names-outside` 4, the other four archives 0;
  `git check-ignore -v` → `checks/fixtures/.gitignore:5` and `:6` match the two paths;
  `grep -n 'read-only\.sh:L\|in-place' docs/SDD.md` → `:L367`, `:L802`, `:L804`, `:L2077`, `:L2081`,
  `:L7461`, `:L7471`, the last two inside RN-101; `checks/gate.sh:L68-L70` the three walk steps,
  `:L26-L33` the dispatcher, `:L91` *Own state*.

## Items worked

### 5.1 — § 4 C-I3 says the walk's restore unpacks into the fixture folder, and § 3 gives `fixtures/.gitignore` a reason that no longer holds

- **Bucket:** 5. Raised from downstream — an item from a seat that did not write the SDD
- **Verdict:** confirmed with addition
- **Why:** The item's lean holds — re-say C-I3's restore as staged extraction of only the missing
  entries, removed after the verdict, pin the locators to a named commit, and say the `.gitignore`
  has no reason left — and it under-counts what the change moved and what the file still does, so
  it is confirmed with those added.

  *Check 1.* The edit lands in `docs/SDD.md` § 4 C-I3 and § 3's `read-only-harness` row. The item
  carries `Seat: cto`, this run's posture. The answer binds nothing but the document's agreement with
  the tree. The one thing near the edge is the file's removal, and the answer does not make it: a
  file leaving `checks/` is a change to code, carried by the journey, and the SDD's row records it
  when it lands by its own rule. No ground I cannot see: nothing here turns on a person, a
  commitment or a risk the owner carries. Mine, in the CTO's seat.

  *Check 2.* The item sits under *Raised from downstream*, cites its occurrence (`c268945`) and
  corrects facts found false, so it widens nothing. Its lean reaches the right conclusion and is
  incomplete in four places, each added. (a) The label "in-place restore" also stands in the row
  itself, where the four root-finding scenes are named, and twice in § 6 S-4 (`docs/SDD.md:L2077`,
  `:L2081`); the same correction reaches them in the same fold, and RN-101's `:L73-L76` is a dated
  measurement that stays. (b) What the two patterns still do: only KILL and STOP skip the finalizer
  (`checks/read-only.sh:L179-L180`), and for that case the file hides the residue of one fixture
  while three other archives with members outside `.git` have no pattern — so it was never the
  safeguard the doubt reads it as. (c) Inside the gate the file does nothing: a killed walk step
  ends the run before *Own state* (`checks/gate.sh:L26-L33`, `:L91`). (d) The design's own
  principle runs against it — `own-state.sh` condition 2 names ignored entries so nothing hides
  (`checks/own-state.sh:L23-L27`). The item is one question, one landing, one seat; it does not
  split. The `.gitignore` question is not a second seat: the row has to say what the file is for
  either way, and the removal is nobody's document.

  *Check 3.* Nothing settled moves. `docs/nfdr.md` QC-2's sentence still holds, and its locators
  are carried by `docs/architecture_open_issues.md` § 3.1, not here. QC-49's `--kill` is the host
  killed mid-churn, a promise the SDD lists under `follow-the-folder`; the answer names it and
  leaves it. The row's other locators stand: `own-state.sh:L28`, `:L118`, `gate.sh:L70`, `:L91`
  were re-read and name what the row says. No other product document names `fixtures/.gitignore`
  (`grep` over `docs/nfdr.md`, `docs/adr/`, `docs/SRS.md`, `docs/fdr.md`, `docs/DESIGN.md`,
  `docs/CONTENT.md`, `docs/what_left.md` → nothing; the NFDR's `.gitignore:L32` hits are the
  root file and the bundle). The station that landed the change is closed — its record sits at
  `shukuba/trail/`, and the shukuba root holds only the README — so this commit resolves against
  the Agari.

  *Check 4.* **Stale** — the answer is pinned to `c268945` and the tip read holds its tree
  outside `docs/`. **Absent** — the fresh-clone walk the item measures was not re-run here; the
  answer says so and rests on the item's measurement, the suite's signal case
  (`checks/tests/test_read_only.sh:L922`) and the script read whole. **Concurrent** — two walks of
  one fixture at once: the second finds `.git` present and skips its restore, and the first's
  teardown then removes entries under the second's hash, which reports them as changed — a loud,
  non-destructive failure that no document states and the gate, running steps in order, never
  reaches; named, not covered. **Refused** — a removal that fails is printed as `restored entry not
  removed` and the exit is non-zero (`:L311-L317`, `:L347`); the row says nothing about it and
  need not. **Empty** — a fixture with no archive: `restore()` returns at `:L212` and the ledger
  stays empty, nothing to remove.

  *Close to a different verdict.* Had the item asked the SDD to decide that the file is removed, the
  answer would have been that this is not the SDD's: a design document says what the design relies
  on, and a `checks/` change carries the file out. The item asked whether it "still has a reason to
  exist", which the row can answer, so the verdict is confirmation and not override.

## Left for the owner

None this run.

## Skipped

None this run.

## Companions opened

None this run.

## Launchers owed

- **docs/SDD.md** — `<CORE>/launchers/skill/launcher.sh product-sdd ka-reader`
