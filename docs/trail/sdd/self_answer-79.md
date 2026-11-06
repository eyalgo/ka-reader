# Self-answer report — SDD

## Header

- **Companion:** `docs/SDD_open_issues.md`
- **Document:** `docs/SDD.md` (v70, Settled; the companion was re-opened by the PM at `ka-reader@0d3af45` with three items under § 5 *Raised from downstream*, all seated `cto`; the invocation listed no items, so all three were this run's)
- **Decided by:** `<CORE>/../skills/companion/.claude/skills/companion-self-answer/prompts/rich.md` v1.3.1
- **Date:** 2026-11-06
- **Sources re-read:** None — no answer rests on a source outside this repository. Every claim was measured in the tree at `ka-reader@f44d370`, the merge the items name (the parent of `HEAD`): `ka-reader-mac/Sources/Shell/LaunchFlow.swift`, `ka-reader-mac/Sources/KAReader/NativeBridge.swift`, `ka-reader-mac/Tests/ShellTests/LaunchFlowSelectionTests.swift`; `crates/ka-reader-bridge/src/boundary.rs`, `session.rs`, `exports.rs`, `tests/exports.rs`, `tests/last_selection.rs`; `crates/ka-reader-core/src/folder_model.rs`. The SDD was read at § 3 (the `surfaces`, SM-4 and SM-5 rows) and § 6 S-6; the open station `2026-11-06_the-open-file-follows-or-says-it-is-gone` as an input. The SRS, UXD, NFDR, FDR and ADRs were searched for the same statement and carry none of it; `CHANGELOG.md` already records the fix for a user.

## Items worked

### 5.1 — § 3's `surfaces` row still calls the order of two quick selections a known defect; it holds at `ka-reader@f44d370`

- **Bucket:** 5. Raised from downstream — an item from a seat that did not write the SDD
- **Verdict:** answered
- **Why:** Check 1 — mine: the edit lands in § 3's `surfaces` row, a CTO column; it binds nobody outside the document and no ground is unseeable. Check 2 — a correction, not a widening: the row states a fact ("the built order does not hold it, a known defect until a change lands") that is false at the commit the item cites, so § *A widening item waits until it occurs* does not apply, and the occurrence is cited anyway. The PM's account held on every point measured: the selection act goes on the serial tree-act runner (`LaunchFlow.swift:L190-L193`, `:L73`), the open only from its delivery on the concurrent runner (`:L212-L214`, `:L72`); the bridge applies the act under the lock before any read (`session.rs:L1085-L1088`, `:L1155-L1160`); the model folds an open only for the latest unanswered selection act, once (`folder_model.rs:L758-L768`, `:L1163-L1166`, `:L1201-L1211`); the proof is ten cases in `tests/last_selection.rs`, both completion orders at `:L202`. Three things the item did not say that the row must: `Select(None)` marks the awaited act answered (`:L1157-L1159`); a model that admitted no act folds as before, so § 4 C-I3's harness route is untouched; and the awaited act is "not part of the reader's place" (`:L752-L754`), which matters because the `folder-model` row says the place is the reader's acts and a delta carries it — this state is neither. The answer also names the shell half of the proof (`LaunchFlowSelectionTests.swift:L106-L124`), which the item left out, and re-points § 6 S-6 *Reached when*'s citation of the known defect, which the item names only as "reads it as the order still owed". Check 3 — nothing settled moves: the row's rule is unchanged and now built; the grant check and batch re-read stand (`session.rs:L1118-L1124`); SM-4's export set is unchanged (5.2); the answers to 5.2 and 5.3 were decided with this one and say the same thing about where the selection joins. Check 4 — *empty:* a first open with no selection act (the harness) folds as always. *Absent:* a selection act for a path that does not admit as a file changes nothing, and an open whose read resolved to no file returns the model as it was. *Stale:* the row is pinned to `f44d370` and its predecessor is kept dated, the row's own pattern; a read for a folder switched away is dropped by the grant check. *Concurrent:* the case itself, in both orders, plus three selections, A-B-A and the same file twice (`last_selection.rs:L229`, `:L246`, `:L271`). *Refused:* a file that cannot be displayed is still held when the earlier read finishes last (`:L312`).

### 5.2 — § 3 SM-4's `select_file` clause names no act `2` and keeps the two-quick-selections bound; both changed at `ka-reader@f44d370`

- **Bucket:** 5. Raised from downstream — an item from a seat that did not write the SDD
- **Verdict:** answered
- **Why:** Check 1 — mine: § 3 SM-4, a CTO column. Check 2 — all three of the PM's points held: act `2` is `FileAct::Select` (`boundary.rs:L261`), applied under the lock and answered `pending` (`session.rs:L1085-L1088`, `:L1155-L1160`); the first bound is false because the act is applied before the read and the fold is admitted only for the latest act (5.1); the shell's open locator moved (`LaunchFlow.swift:L190-L193`, `:L212-L214`; `NativeBridge.swift:L44-L50`). One addition the item missed: the clause's position-act locator (`:L224-L225`) moved in the same commit, to `:L197-L200`, and the bridge's to `session.rs:L1165`; and the second bound's locator (`:L1093-L1118`, `:L1114-L1116`) moved to `:L1101-L1131`, `:L1118-L1124`. The clause's "no function joins this list" was checked rather than taken: the export set is the same five (`exports.rs`, five `extern "C"` functions; `tests/exports.rs:L18-L22`), the new act riding `ka_reader_select_file`'s code argument. Check 3 — § 4 C-R7's grant is untouched; SM-4's "ten calls and `ka_reader_free` down" stands; the clause's second bound stands as written. Check 4 — *empty / absent:* a NULL, empty or non-UTF-8 path, or no folder open, answers `pending` for every act, as before. *Stale:* the clause is pinned at `f44d370` with the earlier text dated, its third such parenthetical. *Concurrent:* the act is applied under one lock hold in arrival order; the open's grant check is unchanged. *Refused:* an unknown act code applies nothing.

### 5.3 — § 3 SM-5's description of `FolderModel::open_read` and of how the bridge drives an open omits the selection act

- **Bucket:** 5. Raised from downstream — an item from a seat that did not write the SDD
- **Verdict:** answered
- **Why:** Check 1 — mine: § 3 SM-5, a CTO column. Check 2 — the PM's statement of `open_read`'s condition is the function's own doc comment and body (`folder_model.rs:L1201-L1211`), and the bridge's selection act is where the item says (`session.rs:L1155-L1160`). The answer adds what the item left implicit: the `AwaitedOpen` state that carries the condition (`:L758-L768`), how it is set and answered (`:L1163-L1166`, `:L1157-L1159`), that it sits outside the reader's place and crosses no seam, and that the bridge's open is now three steps in a fixed order (the act under the lock, `read_file` outside it, `open_read` under it). Check 3 — § 4 C-I3 is unchanged: `FileRequest`'s three arms stay the model's API, and a harness opening through `open_read` with no selection act folds as before. 5.1 and 5.2 were decided with this item and agree. Check 4 — *empty / absent:* `open_read` on a read that resolved to no file returns the model as it was, awaited state untouched. *Stale:* the cell is pinned at `f44d370` with the earlier wording dated. *Concurrent:* a read that answers an earlier act folds nothing, once per act. *Refused:* none in a seam description.

## Left for the owner

None this run.

## Skipped

None this run.

## Companions opened

None this run.

## Launchers owed

- **`docs/SDD.md`** — `<CORE>/launchers/skill/launcher.sh product-sdd ka-reader`
