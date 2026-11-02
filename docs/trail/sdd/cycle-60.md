# SDD open issues — KA-Reader

> Companion to `SDD.md`, for the CTO and the seats answering its items. Answer inline, commit
> this file, then re-run `product-sdd`. It preserves the answered companion under
> `docs/trail/sdd/`, folds the answers and deletes this file when no item remains.

> **Provenance:** hand-authored 2026-11-02 in an interactive kensaiapp-opensource session, from the
> planning halt of `ka-reader · tobiishi · 2026-11-02_the-tree-follows-the-disk` (its
> `halt_report.md`, §§ 1–2). The answers are the owner's. The NFDR side of item 5.2 is raised
> separately on `architecture_open_issues.md` § 3.1, so its producer follows the settled SDD.

## 1. Open issues — questions with no answer yet

None.

## 2. Choices to confirm — a best-effort answer was drafted; confirm or override

None.

## 3. Cut calls to confirm — where the slicing could reasonably have gone another way

None.

## 4. Disagreements — two seats hold different positions and neither yields

None.

## 5. Raised from downstream — an item from a seat that did not write the SDD

### 5.1 The `watcher` row places an FSEvents binding in the unit that imports no Apple framework

- **Raised by:** Tech Lead (development-plan halt) — 2026-11-02, carried by the owner
- **Seat:** cto
- **Tracked by:** `ka-reader · tobiishi · 2026-11-02_the-tree-follows-the-disk`
- **What it blocks:** Any design for automatic tree refresh. Every design either puts an Apple
  binding in `ka-reader-core` or departs from the parts table.
- **Where it shows:** § 3 parts table, the `watcher` row: "Lives in `crates/ka-reader-core`" and
  "One FSEvents subscription". The units paragraph below the table says `crates/ka-reader-core`
  "imports no Apple framework". `docs/nfdr.md` QC-9 says the same, and so does ADR-0020. The
  SDD therefore contradicts itself. The halted design resolved this by setting QC-9 aside for one
  dependency (`notify` with `macos_fsevent`), which the planning step correctly refused.
- **If a document has to be written:** No additional document; revise the parts table and
  every section that places `watcher` through `product-sdd`. No ADR change is requested.
- **Answer:** Keep the architecture: `ka-reader-core` imports no Apple framework and no binding
  to one, and QC-9 and ADR-0020 stand unchanged. Move `watcher` out of `ka-reader-core` into a
  unit that may hold the FSEvents subscription. Which unit, `ka-reader-bridge` or `ka-reader-mac`,
  is the CTO's call. State the unit, how its coalesced path reports reach `folder-model`, and any
  dependency or SM-4 crossing that follows from the choice. Keep the row's ownership:
  `watcher` reports paths and nothing else, it reads no content and interprets no change, and
  `folder-model` decides what to read. `checks/structure.sh` still finds the subscription in
  `watcher` alone.

### 5.2 S-5 is one slice, but its checks are owed by two routes

- **Raised by:** Tech Lead (development-plan halt) — 2026-11-02, carried by the owner
- **Seat:** cto
- **Tracked by:** `ka-reader · tobiishi · 2026-11-02_the-tree-follows-the-disk`
- **What it blocks:** A change that delivers the tree part of S-5 alone. The full churn check, the
  latency measurement and the built-bundle retention proof can pass only once the displayed file
  and Git state also follow the disk. So a tree-only change can neither run them nor leave them out.
- **Where it shows:** § 6 S-5 *Reached when*. One observable and one command bar cover the tree,
  the displayed file and Git state together: `checks/churn.sh` includes "the displayed file, Git
  operations mid-flight, and `git init`", plus the `TreeMarkers|GitRowOrder` grep and
  `checks/latency.sh`. The open station on the ka-reader route delivers the tree part only, and
  its Guardrail defers displayed-file refresh, latency and the built-bundle log proof to the
  later items of the same seed.
- **If a document has to be written:** No additional document; re-cut S-5 under § 10's existing
  re-cut rule through `product-sdd`.
- **Answer:** Split S-5 into two slices in delivery order, and keep every check: each one moves
  to the slice that can first run it, and none is dropped or weakened.
  1. **Tree slice, first.** Delivers: the tree follows the disk on its own, expansion, collapse,
     selection, sidebar mode, open file and reading position kept, and an unreadable entry marked
     with the rest of the tree standing. Its checks: a thirty-second **tree-only** churn scene
     (create, change and delete entries, nested expanded folders included, the displayed file
     untouched, no Git operations) running under `cargo test --locked -p ka-reader-core --test watch`
     with no panic, and the live tree equal to a fresh read of the fixture afterwards; the
     removal-then-return case with a fresh listing; the failed-read sibling case (C-I1);
     `checks/read-only.sh` against that scene's final state, and `checks/read-only.sh --kill`
     mid-scene, both printing `unchanged`; `checks/structure.sh` finding the FSEvents subscription
     in `watcher` alone (item 5.1); `checks/no-network.sh` exits 0.
  2. **Open file and Git slice, second; it keeps the slug `follow-the-folder`.** Delivers the
     rest of today's S-5: the open file updating in place and stating it is gone when deleted,
     the Git view and markers following, `git init` and `.git` removal at the root. Its checks:
     today's full `checks/churn.sh <fixture> 30` command bar, including the displayed file, Git
     operations, the mid-run status-change case and final-snapshot equality; the
     `TreeMarkers|GitRowOrder` grep printing nothing; `checks/latency.sh` (C-I4), measured once,
     when every refresh path exists; and the built-bundle diagnostic-retention proof that
     `docs/nfdr.md` QC-40 says is owed with the watcher/churn capability.
  The tree slice's churn scene is a narrower scene, not a stand-in for the full one, and S-5's
  promise clause holds for both. Update § 7's order and every place that names S-5 or
  `follow-the-folder` as the owner of these checks.
