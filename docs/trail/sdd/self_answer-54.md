# Self-answer report — `docs/SDD.md`

This is the record of one unattended run that answered `docs/SDD_open_issues.md` in the CTO's
seat on 2026-10-07. It is for the owner, who reads it to learn what was decided and why, and for
the `product-sdd` run that folds the answers.

## Header

- **Companion:** `docs/SDD_open_issues.md`
- **Document:** `docs/SDD.md` (v46, `Status:` Settled)
- **Decided by:** `<CORE>/../skills/companion/.claude/skills/companion-self-answer/prompts/rich.md` v1.3.1
- **Date:** 2026-10-07
- **Sources re-read:** None. Both answers rest on the product's own tree at `ka-reader@b12e48c` and
  on nothing outside this repository.
- **What was read of the document:** `docs/SDD.md` is 8,000 lines and was not read whole. This
  run read the header (`:L1-L34`), the heading map (`grep -n '^#'`), § 3's `read-only-harness`
  row whole (`:L358`) with the rows around it (`:L350-L366`), § 4 C-I3 whole (`:L763-L800`), § 6
  S-4 *Reached when*'s promise clause and *Rests on* (`:L1960-L2000`), and every line
  `grep -n -E 'Two limits|two limits|plain. and .repo. alone|read-only-harness|C-I3|1d5c3cf|made by hand|walk.rs:L288'`
  prints — the two claims the items correct occur in the document at `:L1981-L1988` and nowhere
  else. Of the SDD's inputs, none was opened: both items are measurements of what the tree holds
  against what the document says of it, and no answer moves a sentence the PRD, the SRS or the UXD
  settled. Downstream, `docs/nfdr.md` QC-2 (`:L100-L115`) and `docs/architecture_open_issues.md`
  were read whole: the NFDR's matching tail already has its item there (§ 3.1, opened by the PM at
  `ka-reader@258b472`), so no companion is opened by this run.
- **The tree the answers were measured on:** `ka-reader@b12e48c`, the merge both items cite, which is
  `main`'s HEAD less the two companion-opening commits (`git log --oneline -8`: `258b472`,
  `bcac6fc`, then `b12e48c`); `git status --short` printed nothing. `b12e48c` is on no remote
  branch (`git branch -r --contains b12e48c` printed nothing), and `origin/main` is at
  `ka-reader@799c3d6`, an ancestor 29 commits back. On a disposable copy (`git archive b12e48c |
  tar -x -C /tmp/ka-reader-scratch.OESAgw`), never in the main checkout: `checks/read-only.sh` printed
  `unchanged` on `checks/fixtures/plain`, `repo` and `submodule`; `cargo test --locked -p
  ka-reader-core --test git_state submodule` printed `test result: ok. 17 passed; 0 failed`. The
  workspace-wide `cargo test --workspace --locked` the items report (23 `ok` lines) was not re-run
  here; the two answers rest on the walks and the 17 cases, which were.

## Items worked

### 5.1 — § 6 S-4's promise clause says two limits stand beside the `submodule` walk until a change closes them, and both are closed

- **Bucket:** 5. Raised from downstream — an item from a seat that did not write the SDD
- **Verdict:** confirmed with addition
- **Why:** The item's "likely fold" is a lean, so it was weighed as a draft, and it holds for the
  reason it gives: both limits the clause states are closed at `ka-reader@b12e48c`, and it is taken
  with three additions.

  *Check 1 — the seat.* The edit lands in `docs/SDD.md` § 6 S-4, the promise clause
  (`:L1981-L1988`); the item carries `Seat: cto`, and the clause is the CTO's command half. It
  commits nothing to anyone outside the document, and there is no ground this run cannot see.
  Mine, in the owner's seat. The one place the same words recur outside the SDD is `docs/nfdr.md`
  QC-2 (`:L107-L111`), and that half is already an item on the Principal Architect's companion
  (`docs/architecture_open_issues.md` § 3.1), so nothing is raised upstream.

  *Check 2 — the draft.* Every fact the item rests on was re-measured at `b12e48c`, not taken from
  the item: the step `Read-only, submodule` is at `.github/workflows/ci.yml:L73-L74`, after
  `Read-only, repository` (`:L70-L71`) and before `Read-only suite` (`:L76`); the case
  `test_read_git_on_the_restored_submodule_answers_root_with_its_status` is at
  `crates/ka-reader-core/tests/git_state.rs:L787`, the scene case at `:L771`, the three layouts at
  `:L802`, `:L815` and `:L828`, and `restored_submodule_scene` at `:L722`; and `checks/walk.rs` is
  unchanged since `ka-reader@275e179` (`git diff --quiet 275e179 b12e48c -- checks/walk.rs` exits 0),
  so the walk still drops the answer and the case is what holds it — which the item says. Where
  the draft is incomplete, and what the three additions are: **(1)** the clause has a third
  sentence that goes false with the two limits and the item does not name it — "that it does is
  read from the restored folder's layout and from `git status --porcelain` on a copy of it … and it
  was not run through the adapter". The case runs it through `read_git` on a `FolderModel`
  (`git_state.rs:L730-L736`), so that sentence joins the old words in the dated note; and the
  sentence that *stays* true, "the walk drops the Git answer (`checks/walk.rs:L288-L292`)", stays
  in the clause as the reason the case and not the walk holds the answer. **(2)** The CI half is
  bounded by what can be read: the step is in the workflow at `b12e48c`, but no hosted run has
  executed it — `b12e48c` is on no remote branch, and `gh run list --limit 5` names runs on
  `main` at `ka-reader@…` pushes up to 2026-10-07T03:00 only. So the fold says the step is in the
  workflow and does not say it is green. **(3)** The pin moves: `ka-reader@2d7692c` (`ci.yml:L67-L71`)
  becomes `ka-reader@b12e48c` (`:L67-L74`).

  *Check 3 — the settled record.* § 4 C-I3 (`:L763-L800`) states the rule for a walk fixture and
  says "every walk fixture"; it names no step list, so it does not move, and the folded clause
  agrees with it — the `submodule` walk now sits where C-I3's "on every build" puts it. § 3's
  `read-only-harness` row is item 5.2's and is decided beside this one, below; neither answer
  moves a word of the other's passage. No input document is touched: the PRD, the SRS and the
  UXD say nothing about which fixtures CI walks.

  *Check 4 — the failure paths.* **Absent:** the hosted runner's result for the step is unread,
  and the answer names that rather than claiming it (addition 2). **Stale:** the clause is pinned
  to `b12e48c`; a later change to `ci.yml` or `git_state.rs` re-measures it, which is the pin's
  own rule. **Refused:** if the hosted step goes red, that is § 4 C-I3's "on every build" holding —
  a red build — and not the clause going false. **Empty** and **concurrent** do not reach a
  statement about which steps a workflow holds. Nothing is left uncovered.

  What would have tipped it the other way: nothing short of the case or the step being absent at
  `b12e48c`, and both are there. The fold is `product-sdd`'s, as the item says; the clause's old
  words go into a dated note the way the v46 header records earlier re-pins, and the fold owes a
  new RN.

### 5.2 — § 3's `read-only-harness` row is pinned at `ka-reader@1d5c3cf`, and `checks/fixtures/.gitignore` has landed since

- **Bucket:** 5. Raised from downstream — an item from a seat that did not write the SDD
- **Verdict:** confirmed with addition
- **Why:** The item's "likely fold" is a lean, so it was weighed as a draft, and it holds: the row's
  own rule says a file landing in `checks/` after its pin "owes this row an item", one landed, and
  the fold is the cell re-measured at the current commit. It is taken with two additions.

  *Check 1 — the seat.* The edit lands in `docs/SDD.md` § 3, the `read-only-harness` row's *Owns*
  cell (`:L358`); `Seat: cto`, and the cell is the CTO's. It binds only the document's own
  consistency with the tree. Mine, in the owner's seat. `docs/nfdr.md` § 9 pins a suite count, and
  no suite file landed, so the NFDR is owed nothing by this item.

  *Check 2 — the draft.* Re-measured, not taken from the item: `git diff --stat 1d5c3cf b12e48c --
  checks` lists exactly `checks/fixtures/.gitignore` (6 insertions), `checks/own-state.sh` (35 lines
  changed) and `checks/tests/test_own_state.sh` (67 lines changed). The new file holds four comment
  lines and the two patterns `/submodule/.gitmodules` and `/submodule/submodule/`
  (`checks/fixtures/.gitignore:L1-L6`), and its own comment states what it is for: "so that git's
  own view of checks/fixtures agrees with a restore made in place (checks/read-only.sh)". That is
  `own-state.sh`'s condition 3 (`checks/own-state.sh:L21`, "`git status --porcelain checks/fixtures`
  prints nothing"), and the reason it is needed now is CI's order — the `Read-only, submodule` step
  (`ci.yml:L73-L74`) restores the fixture in place before `Own state` runs (`:L116`). The item says
  "keeps an in-place restore out of git's view" and does not name the condition; the answer does.
  The `own-state.sh` diff is the `implied_folders` helper (`:L43-L52`) applied to the archive's
  listing as well as the tracked set (`:L64-L68`), with condition 2's comment widened to "and the
  folders that listing implies" (`:L16-L20`); the row names `own-state.sh` and none of its
  conditions, so no other word in it goes false — the item says so and it is right. The three
  `test_own_state.sh` cases the item cites are at `:L212`, `:L222` and `:L233` as it states. Where
  the draft is incomplete: **(1)** the cell pins six locators into `git_state.rs` and two into
  `root_finding.rs`, and the station inserted 125 lines into `git_state.rs` (`git diff --stat
  1d5c3cf b12e48c -- crates/ka-reader-core/tests`, the only file in that diff) — all of them above
  `:L1214`, since the first inserted case is at `:L722` — so every one of the six has moved by
  exactly 125 and the row, pinned at `1d5c3cf`, now points at the wrong lines. The re-pins are in
  the answer, each verified by the fixture name on the line at both commits; `root_finding.rs` is
  not in the diff and `:L55`/`:L63` stand. This is the same thing the v46 note records happening
  under the row at `5331b85` → `1d5c3cf`, and the fold records it the same way. **(2)** The counts:
  the `.gitignore` is a file under `fixtures/`, not a fourteenth folder, so "thirteen fixture
  folders" stands, as do eight scripts and one suite each.

  *Check 3 — the settled record.* The row's pin rule is its own and is what this item invokes.
  § 4 C-I3 cites `checks/read-only.sh:L73-L76`, `:L17-L20`, `:L84` and `git_state.rs:L146-L155`;
  `read-only.sh` is not in the diff, and `:L146-L155` is above the insertion, so C-I3's locators
  do not move and C-I3 is not touched. Item 5.1's answer re-pins § 6 S-4 at the same commit, so
  the two passages carry one pin, `b12e48c`, after the fold. No input document is touched.

  *Check 4 — the failure paths.* **Stale:** the cell is pinned to `b12e48c`, and the next file to
  land in `checks/` owes the row another item — the row's own rule, which this answer keeps.
  **Absent / empty / concurrent / refused:** not reached by an enumeration of what a commit holds.
  Nothing is left uncovered.

  What would have tipped it: if the `.gitignore` had changed what the walk hashes or what the
  suites unpack, the row's "on disk" / "owed by a slice" split would have needed re-deriving; it
  changes git's view of the fixtures and nothing the harness reads, so it does not. The fold is
  `product-sdd`'s, and it owes a new RN.

## Left for the owner

None this run.

## Skipped

None this run.

## Companions opened

None this run.

## Launchers owed

- **`docs/SDD.md`** — `<CORE>/launchers/skill/launcher.sh product-sdd ka-reader`
