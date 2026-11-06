# Self-answer report — SDD

## Header

- **Companion:** `docs/SDD_open_issues.md`
- **Document:** `docs/SDD.md` (v69, Settled; the companion was re-opened by the PM at `ka-reader@65e5166` with four items under § 5 *Raised from downstream*, all seated `cto`; the invocation listed no items, so all four were this run's)
- **Decided by:** `<CORE>/../skills/companion/.claude/skills/companion-self-answer/prompts/rich.md` v1.3.1
- **Date:** 2026-11-06
- **Sources re-read:** None — no answer rests on a source outside this repository. Every claim was measured in the tree at `ka-reader@d6bc3a3`, the landing commit the items name (an ancestor of `HEAD`): `crates/ka-reader-bridge/src/exports.rs`, `boundary.rs`, `session.rs`, `tests/exports.rs`, `tests/open_file.rs`; `crates/ka-reader-core/src/folder_model.rs`, `fs_reader.rs`, `lib.rs`; `ka-reader-mac/Sources/KAReader/NativeBridge.swift`, `Shell/LaunchFlow.swift`, `Surfaces/ReadingPanelView.swift`, `Surfaces/CodeView.swift`. The SDD was read at § 3 (the `folder-model`, `core-bridge`, `surfaces`, SM-4 and SM-5 rows; *What the system holds*), § 6 S-6 and S-8, § 10 and *Open Questions*; the SRS at FR-27, FR-28 and DR-3; the station and the PM's refine report of 2026-11-06 as inputs.

## Items worked

### 5.1 — § 3 SM-4's `select_file` clause says the reading position does not cross yet; it crosses at `ka-reader@d6bc3a3`

- **Bucket:** 5. Raised from downstream — an item from a seat that did not write the SDD
- **Verdict:** answered
- **Why:** Check 1 — mine: the edit lands in § 3 SM-4, a CTO column, binds nobody outside the document, and no ground is unseeable. Check 2 — a correction, not a widening: the clause states a fact ("do not cross yet") that is false at the commit the item cites, so § *A widening item waits until it occurs* does not apply, and the occurrence is cited anyway. The PM's account held on every point measured: the export takes path, act and position (`exports.rs:L112-L116`); act `0` opens at the position and act `1` sets the position only on the open file and answers `pending` (`boundary.rs:L246-L262`; `session.rs:L1073-L1083`, `:L1146-L1156`); any other act applies nothing; the admitted export set is unchanged (`tests/exports.rs:L18-L22`); the shell sends all three (`NativeBridge.swift:L44-L63`; `LaunchFlow.swift:L215-L216`, `:L224-L225`). Two things the item did not say that the row must, or the restatement overclaims: the selection still joins the model *after* the read — the read runs outside the lock and `open_read` folds it in once it returns (`session.rs:L1093-L1118`) — so the `surfaces` row's known defect at `2529a42` is not settled by this commit, which the station's fourth reached-when line and the PM's refine both carry; and the open's fold applies only to the grant the read was made for, with a second re-read when a batch landed meanwhile (`:L1114-L1116`). The clause's "stays with `follow-the-folder` as RC-7 assigns it" is struck: RC-8 moved the crossing to S-6, which built it. Check 3 — nothing settled moves: SM-4's "ten calls and `ka_reader_free` down" and C-R7's grant stand, the crossing being an argument on a listed call (the first form the collapse-and-scroll item named); the `surfaces` row stands as written, by the first bound. Check 4 — *empty:* a NULL position on an open is the empty position; on a position act it applies nothing. *Absent:* no folder open, or a NULL, empty or non-UTF-8 path, answers `pending`. *Stale:* the clause is pinned to `d6bc3a3` and its predecessor is kept dated, the row's own pattern. *Concurrent:* the grant check and the batch re-read above; the position act is applied under the lock and reads nothing. *Refused:* no refusal path — an unknown act is `pending`.

### 5.2 — § 3's `FileView` bullet names *gone* but not the form it is held in, which § 6 S-6 says the slice writes into § 3

- **Bucket:** 5. Raised from downstream — an item from a seat that did not write the SDD
- **Verdict:** answered
- **Why:** Check 1 — mine: S-6 *Rests on* says in so many words that the form found is written into § 3's `folder-model` row, a CTO column. Check 2 — the PM's statement of the form held against the code: `FileView::Gone` as a variant (`folder_model.rs:L107-L136`), held `Observed`, reached only by `reread_open_file` → `reduce_open_file` (`:L1201`, `:L1241`) when `reobserve_file` answers *absent* (`fs_reader.rs:L476-L514`), every other stop a `failed(condition)`; the delta carries the open file on a change of path or view and not of position alone (`:L558-L590`, `:L821`); the revision rises only on a payload that carries it (`session.rs:L686-L713`). One narrowing the item's text made that the answer corrects: "the held position is drawn as far as the content reaches" is the surfaces' behaviour on a recovery or a first draw; on an update over text the panel keeps its *own* scroll, clamped, and does not apply the model's position, because a position act may still be on its way (`ReadingPanelView.swift:L200-L234`). The answer names that as `surfaces`' and the UXD's, not the `folder-model` row's, so the row does not claim the drawing. Check 3 — agrees with SRS FR-28 ("states plainly that it is gone — never presenting the vanished content"), FR-27 and DR-3 (the position preserved, in-session); with the `folder-model` row's place clause (the place is the reader's acts, never a read); and with § 4 C-I1 (every read held as an `ItemState`). Check 4 — *empty:* an empty file re-read is *text* with no content, not *gone*. *Absent:* the case itself; and a link whose target vanished is `failed`, by the walk's own rule, which the answer states so a reader does not expect *gone* there. *Stale:* a *gone* file recreated is replaced by the next re-read; a batch over unchanged bytes carries no open-file member. *Concurrent:* `reduce_open_file` is pure and the bridge's batch-during-read case is pinned by `tests/open_file.rs:L160`, `:L471`. *Refused:* an unreadable file is `failed`, never *gone*. Named and not decided, as the row already leaves it: the root's own disappearance.

### 5.3 — § 3 SM-5 names only the request types going down; `select_file` and the open file's re-read now reach the model through named functions

- **Bucket:** 5. Raised from downstream — an item from a seat that did not write the SDD
- **Verdict:** answered
- **Why:** Check 1 — mine: § 3 SM-5, a CTO column. Check 2 — the three functions exist and are public (`read_file` `:L222`, `open_read` `:L1174`, `reread_open_file` `:L1201`; `lib.rs:L12-L14`), and the bridge drives them as the answer states (`session.rs:L1093-L1118`, `:L1146-L1156`); the Git read's split the item compares to is real (`read_git_item` `:L1007`, `with_git_item` `:L1015`). The answer adds what the item left implicit: that `TreeRequest::Invalidate` is the third route to the open file's re-read, through `open_file_to_reread` (`:L1212`), and that `FileRequest::Open` is no longer the bridge's path for an open while it remains the model's API. Check 3 — § 4 C-I3 (the harness calls the model's API in-process) is unchanged by naming public functions; SM-4's clause (5.1) and this answer were decided together and say the same thing about where the selection joins. Check 4 — *empty / absent:* `open_read` on a read that resolved to no file returns the model as it was; `reread_open_file` with no open file returns the model as it was. *Stale:* the row is pinned at `d6bc3a3` with the earlier list kept dated. *Concurrent:* the batch-during-read re-read is the session's and named in 5.1. *Refused:* none.

### 5.4 — *Open Questions*' collapse-and-scroll item has met its own settling condition

- **Bucket:** 5. Raised from downstream — an item from a seat that did not write the SDD
- **Verdict:** answered
- **Why:** Check 1 — mine: *Open Questions* is the SDD's own list, not the companion's, and the section's header says it holds what resolves downstream, which this did. Check 2 — the item's own clause is "settled by the first build in which the shell supplies that argument, `--test exports` still passing with SM-4's ten"; both hold at `d6bc3a3` (`LaunchFlow.swift:L187-L194`, `:L215-L216`, `:L224-L225`; `tests/exports.rs:L18-L22`). The collapse half settled at `2529a42` and is already in the item. The answer settles what the item did not say: how it leaves. The section's own convention closed the WKWebView question by striking it and recording the close in the review notes (RN-60), so this item goes the same way; and two live citations of it — § 3 SM-4's `list_tree` clause and § 6 S-6 *Reached when* — are re-pointed to the record note, which is the part a fold that only struck the item would miss. Check 3 — nothing settled moves: the first form was the one built, no list, grant or set moved, so no § 10 entry; C-E2 binds the refresh independently; S-8's citation is inside an "until v68" parenthetical and is dated history. Check 4 — *stale:* the citations in RC-4, RC-7, RC-8 and the RN entries are dated and stay. *Concurrent / refused:* none in an index entry. The one thing the item could be misread as closing, named so it is not: the order of two quick selections, which is the `surfaces` row's known defect and the open station's fourth line, not this question.

## Left for the owner

None this run.

## Skipped

None this run.

## Companions opened

None this run.

## Launchers owed

- **`docs/SDD.md`** — `<CORE>/launchers/skill/launcher.sh product-sdd ka-reader`
