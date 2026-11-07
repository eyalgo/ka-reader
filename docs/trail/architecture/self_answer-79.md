# Self-answer report — `adr/` and `nfdr.md`

## Header

- **Companion:** `docs/architecture_open_issues.md`
- **Document:** `adr/` and `nfdr.md` (NFDR v84, Settled)
- **Decided by:** `<CORE>/../skills/companion/.claude/skills/companion-self-answer/prompts/rich.md` v1.3.1
- **Date:** 2026-11-07
- **Sources re-read:** two engineering-doctrine files outside this repository, which § 3.3's answer
  rests on, read at the pinned core this run resolved. (1) The shell packet's `errors_logging.md`
  v1.0.4, `:L33-L34`: "**It exits 1.** The corpus uses exactly two exit values, `exit 0` (18
  occurrences) and `exit 1` (19). There is no third status, and nothing encodes a reason in a
  number." (2) `languages/README.md` § Precedence: project decision files (ADR / NFDR / FDR) sit
  above the language packet, and "a packet never overrides the product's own records".

All three items sit under § 3 and carry no draft. Each states what the fold would write, which this
run read as the question's framing rather than as a lean. They are taken in the companion's order.
Measured at `ka-reader@03e10ee`, whose `checks/` and `.github/` trees are `3fa227e`'s
(`git diff --stat 3fa227e HEAD -- checks/` prints nothing).

## Items worked

### 3.1 — § 9's harness-suites bullet counts fifteen suites; the tree holds seventeen

- **Bucket:** 3. Raised from downstream — an item from a seat that did not write these records
- **Verdict:** answered
- **Why:** The bullet is re-measured at `3fa227e`: seventeen suites, each the whole command of one
  gate step. This is a fact in the NFDR that is now false, which makes it a correction and not a
  widening, and the edit lands in the NFDR, so it is this seat's. The item gets the count right but
  names only one of the two new suites. `git ls-tree` gives 15 suites at `33b8661`, 16 at `d6bc3a3`
  (with `test_tree_scene.sh` added) and 17 at `3fa227e` (with `test_offline_page.sh` added). So the
  bullet was already a suite short before the offline-page check landed, and the fold has to add
  both. Every `checks/tests/*.sh` path at `3fa227e` matches exactly one whole-command `run_step`
  line in `checks/gate.sh`: `test_secret_scan.sh` `:L57`, `test_secret_scan_planted.sh` `:L75`,
  `test_structure.sh` `:L88`, `test_entry_points.sh` `:L90`, `test_bundle.sh` `:L93`,
  `test_view.sh` `:L95`, `test_renderer.sh` `:L105`, `test_read_only.sh` `:L116`,
  `test_no_network.sh` `:L118`, `test_offline_page.sh` `:L120`, `test_strings.sh` `:L126`,
  `test_strings_step.sh` `:L127`, `test_own_state.sh` `:L128`, `test_vm_refusal.sh` `:L134`,
  `test_launch.sh` `:L135`, `test_own_state_step.sh` `:L136`, `test_tree_scene.sh` `:L137`.
  "Three of the fifteen have no script of their own name" stays at three. The two new suites pair
  with `checks/tree-scene.sh` and `checks/offline-page.sh`, under the same underscore-to-hyphen
  pairing as `test_read_only.sh` and `read-only.sh`. The three without a script remain
  `test_vm_refusal.sh`, `test_secret_scan_planted.sh` and `test_strings_step.sh`. The workflow's
  `Test gate` step is still `ci.yml:L28` and runs `checks/gate.sh`. Check 4, the *stale* case: the
  bullet's own rule already calls a further suite a re-measurement, so the fifteen-suite reading
  stays as a dated reading at `33b8661`, the same way the fourteen-suite reading at `f25fdbb` did.
  The SDD's `read-only-harness` row is pinned at `3fa227e` and counts seventeen suites there, so the
  re-measured bullet agrees with it (check 3).

### 3.2 — QC-2's locator for the walk's dropped Git answer points at lines that no longer hold it

- **Bucket:** 3. Raised from downstream — an item from a seat that did not write these records
- **Verdict:** answered
- **Why:** Re-pin the live citations and keep the old one as a dated reading. This is a correction
  of a stale locator. It lands in the NFDR, so it is this seat's. At `3fa227e` the comment and the
  drop are `checks/walk.rs:L1237-L1241`, and `let _ = read_git(FolderModel::new(opened), &Libgit2);`
  is at `:L1241`. Tracking that line through `walk.rs`'s history shows it at `:L292` from
  `ccc9e46` through `c915d52` (2026-10-04 to 2026-10-08), with `:L288-L292` holding the comment and
  the drop at `c915d52`. It moved at `13074b3` (`:L367`) and then six more times on 2026-11-05 to 07.
  So the old locator was true at `c915d52`, and that is the pin its dated reading takes. The item
  lists `:L135`, `:L145` and `:L6324`, which is narrower than the document needs, because there are
  two more sites. QC-35's bound (2) at `docs/nfdr.md:L1466` cites `checks/walk.rs:L292`, with no
  commit, as the walk's libgit2 call with no switch. That is a live obligation and is stale the same
  way, so it is re-pinned to `:L1241` at `3fa227e`. Its claim still holds: the call passes `&Libgit2`,
  and `walk.rs` names no machine-config switch. RN-91's "read at HEAD" (`:L5850`) and RN-66's
  sentences (`:L6324`, `:L6345`) are Review Notes, which record what was read when they were
  written, and `:L145` sits inside a quoted older tail ("through v42 … read"). None of the four is
  rewritten: rewriting a record of a reading would erase the reading. Check 2 on the claim the
  locator carries: the walk still discards the answer, so the sentence's reason, that a case and not
  the walk holds the Git answer, still stands. Only its address moves.

### 3.3 — No record states the check scripts' exit statuses, so their usage exit of 2 departs from the shell packet with nothing setting the packet line aside

- **Bucket:** 3. Raised from downstream — an item from a seat that did not write these records
- **Verdict:** answered
- **Why:** The NFDR states the statuses as the product's own (the item's first option) and sets
  the packet line aside for `checks/*.sh`. **Seat (check 1):** the edit lands in the NFDR. It binds
  nobody outside the product. The doctrine allows it in so many words, since project decision files
  outrank a language packet (`languages/README.md` § Precedence). The NFDR has set a packet line
  aside before, for QC-10, tracing it to an SDD decision. So this seat can make the call, and there is
  no ground here that only the owner can see. **Widening, with an occurrence:** the item asks the NFDR
  to state something it does not state now, and it cites two scripts that exit 2 at named lines, so
  the widening is taken. **Check 3, against the settled record:** the second option, "they exit 0 or
  1 alone", contradicts the SDD. SDD § 3's `read-only-harness` row already states
  `offline-page.sh`'s "usage and exit 2 on any other count". Four suite cases assert that status:
  `test_read_only.sh:L546` and `:L559`, and `test_offline_page.sh:L327` and `:L332`. Narrowing
  would mean two script edits and four suite edits to satisfy a rule the product's own records
  outrank, and no reader is missing that change. **Check 4, the failure paths, is where the item's
  framing was incomplete.** "0, 1, 2" does not describe the tree. A script ended by a signal exits
  128 + n: `read-only.sh`'s `on_signal` (`:L215-L226`), and `trap 'exit 130' INT` /
  `trap 'exit 143' TERM` in `bundle.sh` (`:L154-L155`), `renderer.sh` (`:L183-L184`) and
  `tree-scene.sh` (`:L145-L146`). `offline-page.sh` maps a signal to 1 instead (its
  `trap 'exit 1' HUP INT TERM`). A script that runs another check script passes its child's status
  through (`own-state-step.sh:L61-L63`). A statement listing only three values would be broken by the
  tree on the day it landed, so the answer states five cases: 0, 1, 2, 128 + n through the script's
  own trap, and a child's status passed through. Each is non-zero except a pass. **What the
  difference costs:** `run_step` (`checks/gate.sh:L38-L45`) reads only zero or non-zero and exits 1
  itself, so no gate turns on which non-zero value a script returns. The 2 exists for the person who
  typed the command and for the suites. **Enforcement:** the four suite cases hold the usage status
  where it exists. A new script is held by `development-design` reading the entry. A scan of
  `grep -n 'exit [0-9]' checks/*.sh` at `3fa227e` lists only 0, 1, 2, 130 and 143, which the fold
  may record as a dated reading. Where it lands (a new QC beside QC-67, or § 9) is the fold's to
  place. **What could have tipped it:** if the SDD had not already chosen exit 2, this would have been
  a structural call with no source, and the right move would have been to raise it on the SDD for the
  CTO rather than answer here.

## Left for the owner

None this run.

## Skipped

None this run.

## Companions opened

None this run.

## Launchers owed

- **docs/adr/ and docs/nfdr.md** — `<CORE>/launchers/skill/launcher.sh product-architecture ka-reader`
