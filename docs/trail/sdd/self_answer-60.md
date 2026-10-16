# Self-answer report — `docs/SDD.md`

The record of one unattended run that met `docs/SDD_open_issues.md` in the CTO's seat on 2026-10-16
and decided its one item. It is for the owner, who reads it to learn what was decided and on what,
and for the `product-sdd` run that folds the answer.

## Header

- **Companion:** `docs/SDD_open_issues.md`
- **Document:** `docs/SDD.md` (v53, `Status:` Settled)
- **Decided by:** `<CORE>/../skills/companion/.claude/skills/companion-self-answer/prompts/rich.md` v1.3.1
- **Date:** 2026-10-16
- **Sources re-read:** None. Every claim the answer rests on is inside this repository — the six
  files, the workflow, the scripts and suites the row already names, the NFDR and the SDD — and each
  was read at its own locator at `ka-reader@ee80fc9`, whose tree outside `docs/` is `13e8d42`'s
  (`git diff --stat 13e8d42 ee80fc9 -- . ':!docs'` prints nothing). Measured in the main checkout,
  read-only: `git log --diff-filter=A --name-only b12e48c..13e8d42 -- checks` → the item's six files
  and no other; the same command over `13e8d42..HEAD` → nothing; over `checks/fixtures` → nothing;
  `ls checks/tests` → eleven `test_*.sh` and `support/`; `git diff -M --stat b12e48c HEAD -- crates`
  → `git_state.rs` 52 lines, `root_finding.rs` 6, `walk.rs` a pure rename; and each locator the row
  pins, read at `b12e48c` (`git show b12e48c:<path>`) and found again at HEAD by its content. No
  product check was run — the item is a documentary re-measurement and nothing in it turns on a
  suite's result.
- **What was read of the document:** `docs/SDD.md` is 8,652 lines and was not read whole. This run
  read the header (`:L1-L70`), § 3 whole from the `fs-reader` row through the unit paragraph after
  the table (`:L355-L375`), § 4 C-I3 (`:L788-L818`), § 6 S-4's command half around the `submodule`
  walk (`:L2068-L2092`), and every line `grep -n` prints for `read-only-harness`, `ci.yml`, `suite`,
  `eight`, `virtual machine`, `owner's Mac` and `C-I3`. Of the inputs and neighbours: `docs/nfdr.md`
  QC-64 and QC-65 whole (`:L1639-L1690`) and § 9's harness-suites bullet (`:L1818-L1840`);
  `docs/architecture_open_issues.md` whole. Of the product: `checks/launch.sh`,
  `checks/own-state-step.sh` and `checks/tests/support/vm_refusal.sh` whole; the headers and case
  lists of the three new suites; `.github/workflows/ci.yml` whole; `checks/own-state.sh`,
  `checks/bundle.sh`, `checks/tests/test_own_state.sh`, `checks/fixtures/.gitignore`,
  `crates/ka-reader-core/tests/git_state.rs`, `root_finding.rs` and `walk.rs` at the lines the row
  pins. The journey was read as an input and is cited in no answer:
  `system/projects/ka-reader/journey/shukuba/` holds no open station, and the tracking seed's folder
  holds the refine report that raised this item.

## Items worked

### 5.1 — The `read-only-harness` row's inventory misses six files that landed in `checks/`

- **Bucket:** 5. Raised from downstream — an item from a seat that did not write the SDD
- **Verdict:** confirmed with addition
- **Why:** The item's *If a document has to be written* field carries a lean — re-measure the cell at
  a named commit and keep the `b12e48c` inventory as history — so I weighed it as a draft rather than
  answering from scratch. **Seat:** the CTO's. The edit lands in § 3's `read-only-harness` row, the
  CTO's column of § *Who decides what*; it commits nothing to anyone outside the document; and I can
  name no ground I cannot see. **It is a correction, not a widening**, by the row's own rule: "a
  file landing in `checks/` after that commit is a re-measurement of this cell and not a
  contradiction of it, and it owes this row an item" (`docs/SDD.md:L365`), so § *A widening item
  waits until it occurs* does not reach it — and the occurrence is cited anyway, six files by path.
  **The draft's conclusion holds and its argument is incomplete in four places**, which are the
  additions. (1) *The named commit.* The item names `13e8d42`; I confirmed that `ee80fc9`, the tip
  the fold will read, holds the same tree outside `docs/`, so the pin names what the fold measures
  and not a tree three doc-only commits behind it. (2) *Where the six files sit in the cell.* The
  cell is not a flat list — it sorts scripts, their helpers, suites and fixtures, and says of each
  script what it does — so six names appended would be a different cell from the one that stands.
  Read at the source: `launch.sh` and `own-state-step.sh` are each the whole `run` of a CI step
  (`ci.yml:L112-L113`, `:L117-L118`); `launch.sh`'s first work is the QC-65 admission (`:L42-L44`),
  then one `open` and a 240-tick wait held in a child (`:L46-L71`); `own-state-step.sh` runs
  `own-state.sh` as a child under the same bound and has no admission of its own (`:L22-L27`, its
  header's own words). The three suites are each the whole `run` of a step (`:L95-L96`, `:L98-L99`,
  `:L101-L102`); `test_vm_refusal.sh` pairs with no script, and its header says why — a suite that
  refuses cannot hold its own refusal case, so the cases that run `test_bundle.sh` and
  `test_renderer.sh` as subjects live in a suite that launches nothing (`:L7-L17`). The helper is
  sourced, never run (`vm_refusal.sh:L4-L5`, `:L43-L46`), by six suites — the item says the
  refusal is "shared", and the count is the measurement: `grep -n 'source .*vm_refusal'
  checks/tests/*.sh` prints six lines — and sits under `support/` so no loop over
  `checks/tests/*.sh` takes it for a suite (`:L11-L12`). That placement matters to the cell because
  the NFDR's suite count and QC-64's loop are over that glob, and a helper mis-filed as a suite
  would be counted. (3) *The counts.* "One `test_<name>.sh` suite for each of the eight scripts
  above" goes false: ten scripts and eleven suites, one of them with no script. The fixture-folder
  count does not move — no file landed under `checks/fixtures` in the range — and the `.gitignore` is
  still six lines. (4) *The cell's locators.* Every prior fold of this row re-pinned the lines that
  moved under it, and they moved again: the diff from `b12e48c` to HEAD touches `bundle.sh`,
  `own-state.sh`, `test_own_state.sh`, `ci.yml` and `git_state.rs`. I read each pinned line at
  `b12e48c` and found it at HEAD by content; the answer lists the new values, and the fold re-reads
  them at its own commit. `root_finding.rs:L55`, `:L63` and `tests/walk.rs:L6` hold as written. **What
  the answer does not write, and why.** The QC-65 admission in `bundle.sh`, `renderer.sh`,
  `own-state.sh` and two suites is a condition, and the row "names the script and not its
  conditions" (its own `.gitignore` note); QC-65 is the NFDR's entry and the SDD does not restate it.
  `docs/nfdr.md` § 9's count ("Eight suites are in the tree", `:L1824`) is false at HEAD too, but it
  is carried already — `docs/architecture_open_issues.md` § 3.3, opened by the same review — so I
  opened nothing and appended nothing there. **Against the settled record:** § 4 C-I3's "proved on
  every build" is unchanged — on the hosted runner, a virtual machine, every step still runs, and the
  SDD nowhere claims the checks run on the owner's Mac (`grep -n "owner's Mac" docs/SDD.md` prints
  two lines, both about reads already made); § 6 S-4's command half pins its `ci.yml` locators at
  `b12e48c` and says so, so it stays true as a dated pin; the RNs are dated records and stand; the
  slice-owed half of the cell is unchanged, none of its files being in the tree. No seam, no
  *Delivers*, no slice order, no part's *Must not own* moves. **Failure paths:** *stale* — the pin
  goes stale with the next file under `checks/`, and the row's own rule is what catches it; *absent*
  — the slice-owed files are absent as the row says, measured; *concurrent* — a `checks/` change
  landing between this answer and the fold is caught by the fold's own `git diff --stat 13e8d42
  <its commit> -- checks`, the check every prior fold of this row ran; *empty*, *refused* — not reached
  by a documentary correction. One bound named and not covered: the hosted result of the three new
  steps is unread, Actions being off, so the row says they are on disk and on steps and does not say
  they are green. **What was close:** *confirmed* as it stood. What would have tipped it is a cell
  that listed files flat; this one sorts, counts and pins, so a confirm without the four additions
  would have left the fold to re-derive them, or to append six names under a sentence that still says
  eight.

## Left for the owner

None this run.

## Skipped

None this run.

## Companions opened

None this run.

## Launchers owed

- **`docs/SDD.md`** — `<CORE>/launchers/skill/launcher.sh product-sdd ka-reader`
