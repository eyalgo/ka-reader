# SDD open issues — ka-reader

> Companion to `SDD.md`. The CTO wrote the SDD; this file holds what that run could not settle from
> its inputs (the PRD, the SRS, the UXD, and any context or constraints), and the calls that are the
> CPO's or the CDO's to make. An item whose call is the CPO's or the CDO's carries that seat's
> `Seat:`; an item whose call is the CTO's carries `cto` or no `Seat:` field.
>
> **Answer inline** — fill each **Answer** / **Confirm or override** / **Keep or re-cut** /
> **Your call** slot — **commit this file**, then re-run `product-sdd`. It folds your answers into
> the SDD and drops the resolved items. When nothing is left open, `product-sdd` **deletes this
> file**: no file = the SDD is done.
>
> Your answers are never thrown away. Each time `product-sdd` folds them in, it first copies this
> file whole to `docs/trail/sdd/` — so what you decided, and why, stays readable and citable for good.
>
> **An item may name the seat that answers it.** Any item in any section carries an optional
> `- **Seat:** <seat>` field beside its other fields. Its value is the name of the agent whose posture
> answers the item — `cto`, `cpo` or `cdo`. An item with no usable value, whether the field is absent,
> empty or still the `<seat>` placeholder, is answered in the seat of the skill that produced this file.
> The field names the *answering* seat. It is not the seat that raised the item (`Raised by:` /
> `Held by:`), and it is not the document an answer belongs to.
>
> **An item in §§ 1–3 names the seat that raised it.** An item the CPO raised is a product call and
> an item the CTO raised is a technical one, and the answer that settles one does not settle the
> other. **§ 4 names two seats and no raiser** — a
> disagreement is not something one seat asked, it is two positions held by different seats, and the
> answer that settles it picks between them.
>
> **§ 5 names a raiser from outside the SDD's lanes entirely.** §§ 1–4 are all the SDD's own three
> lane seats; § 5 is a seat that never held a lane in it, reading it long after it settled and
> finding something only the SDD can fix. Its `Raised by:` therefore takes a wider set than §§ 1–3's,
> which stay fixed to the three lane seats on purpose.

## 1. Open issues — questions with no answer yet

None.

## 2. Choices to confirm — a best-effort answer was drafted; confirm or override

None.

## 3. Cut calls to confirm — where the slicing could reasonably have gone another way

None.

## 4. Disagreements — two seats hold different positions and neither yields

None.

## 5. Raised from downstream — an item from a seat that did not write the SDD

### 5.1 § 3's `surfaces` row still calls the order of two quick selections a known defect; it holds at `ka-reader@f44d370`
- **Raised by:** PM — 2026-11-06
- **Seat:** cto
- **Tracked by:** `ka-reader · nemawashi · 2026-10-13_the-tree-and-the-open-file-follow-the-disk`
- **What it blocks:** nothing is blocked; the row is now false, and `follow-the-file` (§ 6 S-6) reads it as the order still owed.
- **Where it shows:** § 3, the `surfaces` row: "At `ka-reader@2529a42` the built order does not hold it, a known defect until a change lands: … `select_file` runs on the concurrent runner … and the selection joins the model after the read". At `ka-reader@f44d370` a click crosses as two acts: the selection act goes on the serial tree-act runner as `select_file` act `2`, before any read (`ka-reader-mac/Sources/Shell/LaunchFlow.swift:L190-L193`, `:L73`), and the open is sent only from that act's delivery and stays on the concurrent runner (`:L213`, `:L72`). The model folds an open only when it answers the latest selection act, at most once per act (`crates/ka-reader-core/src/folder_model.rs:L760`, `:L1201`). The row's "its proof is a bridge case" is met by `crates/ka-reader-bridge/tests/last_selection.rs` (10 cases, both completion orders).
- **If a document has to be written:** none — the row is re-stated at that commit.
- **Answer:** The row is re-stated at `ka-reader@f44d370`: the rule — the model's selection is the reader's last selection act, in the order the reader made them, whatever order the reads answer in — now holds in the built order, and the "known defect" sentence becomes dated history in the row's own pattern (*until 2026-11-06 this read "At `ka-reader@2529a42` the built order does not hold it, a known defect until a change lands: …" — true at `2529a42`*). How it holds: a click crosses SM-4 as two acts. The selection act, `select_file` act `2`, goes on the serial tree-act runner in the reader's order (`ka-reader-mac/Sources/Shell/LaunchFlow.swift:L190-L193`; `treeActs` is `SerialReadRunner`, `:L73`) and the bridge applies it under one lock hold before any read (`crates/ka-reader-bridge/src/session.rs:L1085-L1088`, `:L1155-L1160`); the open, act `0`, is sent only from that act's delivery and stays on the concurrent runner (`:L212-L214`; `reader` is `OffMainReadRunner`, `:L72`), so a read is never ordered and never stalls a listing. The model admits a selection act as the one awaiting its open (`crates/ka-reader-core/src/folder_model.rs:L758-L768`, `:L1163-L1166`) and folds an open only when its read answers the latest selection act not yet answered, once per act, else returns the model as it was (`:L1201-L1211`); so a read that answers an earlier act lands and folds nothing, in either completion order. `Select(None)` marks the awaited act answered (`:L1157-L1159`), and a model that has admitted no selection act folds an open as before (`NoActYet`), which keeps § 4 C-I3's in-process harness route unchanged. The awaited act is model bookkeeping, "not part of the reader's place" (`:L752-L754`), so no delta carries it. The proof the row asked for is `crates/ka-reader-bridge/tests/last_selection.rs` — ten cases, `test_two_quick_selections_end_on_the_second_in_both_completion_orders` at `:L202` and the three-selection, A-B-A and same-file-twice orders beside it — and the shell half is `ka-reader-mac/Tests/ShellTests/LaunchFlowSelectionTests.swift:L106-L124`, which shows the panel on the second file when the first click's read finishes last. The grant check and the batch-during-read re-read the open already had stand unchanged (`session.rs:L1118-L1124`). The row's "the change that settles it is the crossing RC-7 assigned … RC-8 moves to `follow-the-file`" is written as landed: the split it names (`FileRequest::Select` apart from `Open`, the act applied before the read) is the one built. One citation outside the row moves with it: § 6 S-6 *Reached when*'s "the rule § 3's `surfaces` row states and names a known defect at `ka-reader@2529a42`" is re-pointed to the rule alone, the defect being history; the condition itself stands and is met by the cases above. Reasoning in `docs/trail/sdd/self_answer-79.md`.

### 5.2 § 3 SM-4's `select_file` clause names no act `2` and keeps the two-quick-selections bound; both changed at `ka-reader@f44d370`
- **Raised by:** PM — 2026-11-06
- **Seat:** cto
- **Tracked by:** `ka-reader · nemawashi · 2026-10-13_the-tree-and-the-open-file-follow-the-disk`
- **What it blocks:** nothing is blocked; three sentences of the clause are now false.
- **Where it shows:** § 3, the SM-4 row. (1) "Any other act applies nothing and answers `pending`" — act `2` now applies `FileRequest::Select` before any read, reads no content and answers `pending` (`crates/ka-reader-bridge/src/boundary.rs:L261`; `crates/ka-reader-bridge/src/session.rs:L1085`, `:L1155`); only an act other than `0`, `1` and `2` applies nothing. (2) The first of its "Two bounds", "the selection still joins the model after the read … so the `surfaces` row's known defect, two quick selections, stands at `d6bc3a3`" — the selection act is applied before the read, and the fold is admitted only for the latest selection act (5.1). (3) Its citation of the shell's open at `LaunchFlow.swift:L215-L216` — the shell now sends the selection act on the tree-act runner, then the open from its delivery (`ka-reader-mac/Sources/Shell/LaunchFlow.swift:L190-L193`, `:L213`; `ka-reader-mac/Sources/KAReader/NativeBridge.swift:L49`, code `2`). No function joins SM-4's list.
- **If a document has to be written:** none.
- **Answer:** The clause is re-stated at `ka-reader@f44d370`, three sentences replaced and one locator moved, with the earlier text kept dated in the clause's own pattern (*until 2026-11-06 this clause read "… Any other act applies nothing and answers `pending` … the selection still joins the model after the read … so the `surfaces` row's known defect, two quick selections, stands at `d6bc3a3`" — true at `d6bc3a3`*). (1) Act `2` is the selection: it applies `FileRequest::Select(Some(path))` to the held model under one lock hold, in the order the acts arrive, reads no content and answers `pending` (`crates/ka-reader-bridge/src/boundary.rs:L261`; `crates/ka-reader-bridge/src/session.rs:L1085-L1088`, `:L1155-L1160`); only an act other than `0`, `1` and `2` applies nothing and answers `pending` (`boundary.rs:L262`). A NULL, empty or non-UTF-8 path, or no folder open, still answers `pending` for every act. (2) The first of the two bounds is replaced: the selection joins the model *before* the read — the shell sends act `2` on the serial tree-act queue and the open only from that act's delivery (`ka-reader-mac/Sources/Shell/LaunchFlow.swift:L190-L193`, `:L212-L214`), and the model folds the open only when its read answers the latest selection act not yet answered, once (`crates/ka-reader-core/src/folder_model.rs:L1201-L1211`) — so the `surfaces` row's rule holds at `f44d370` and the known defect is history (§ 5.1). The second bound stands as it was: the fold is made only for the grant the read was made for, with one more re-read of the open file when a batch landed during the read, now at `session.rs:L1118-L1124` (the open as a whole `:L1101-L1131`). (3) The locators: the shell's crossing is `ka-reader-mac/Sources/KAReader/NativeBridge.swift:L44-L50` (`.select` is code `2`), the open `LaunchFlow.swift:L190-L193` with the read at `:L212-L214`, and the position act — which the item did not name and which moved in the same commit — `:L197-L200`, on the tree-act queue, drawing nothing; the position act in the bridge is `session.rs:L1165`. No function joins the list: the export set is the same five, `ka_reader_select_file` taking the new act as a code (`crates/ka-reader-bridge/src/exports.rs:L114`; `crates/ka-reader-bridge/tests/exports.rs:L18-L22`), so § 4 C-R7's grant is untouched. Reasoning in `docs/trail/sdd/self_answer-79.md`.

### 5.3 § 3 SM-5's description of `FolderModel::open_read` and of how the bridge drives an open omits the selection act
- **Raised by:** PM — 2026-11-06
- **Seat:** cto
- **Tracked by:** `ka-reader · nemawashi · 2026-10-13_the-tree-and-the-open-file-follow-the-disk`
- **What it blocks:** nothing is blocked; the Down cell no longer says when an open's read is folded.
- **Where it shows:** § 3, the SM-5 row: `FolderModel::open_read` "folds that read in, the path selected and open at the position, when it resolved to a file, else the model as it was", and "an open is `read_file` outside the lock, then `open_read` under it". At `ka-reader@f44d370` the fold is made only when no selection act was admitted since the model was made, or when the read answers the latest selection act not yet answered (`crates/ka-reader-core/src/folder_model.rs:L760`, `:L1201`); the bridge's selection act is `select_file(FileRequest::Select)` under the lock, before the open's read (`crates/ka-reader-bridge/src/session.rs:L1155`).
- **If a document has to be written:** none.
- **Answer:** The Down cell's `open_read` sentence and its "how the bridge drives them" sentence are re-stated at `ka-reader@f44d370`, the earlier wording kept dated (*until 2026-11-06 the cell read "folds that read in, the path selected and open at the position, when it resolved to a file, else the model as it was" and "an open is `read_file` outside the lock, then `open_read` under it" — true at `d6bc3a3`*). `FolderModel::open_read(FileRead, ReadingPosition)` (`crates/ka-reader-core/src/folder_model.rs:L1201`) folds the read in — the path selected and open at the position — only when it resolved to a file *and* either no selection act was admitted since the model was made or the read answers the latest selection act not yet answered; a selection act is answered by one fold; otherwise the model is returned as it was (`:L1201-L1211`). Which act awaits its open is the model's own `AwaitedOpen` state (`:L758-L768`), set by `select_file(FileRequest::Select(Some(path)))` on admission (`:L1163-L1166`), marked answered by `Select(None)` (`:L1157-L1159`), and "not part of the reader's place" (`:L752-L754`), so it crosses no seam and no delta carries it. How the bridge drives an open is now three steps: the selection act first, `select_file(FileRequest::Select(Some(path)))` under the lock, in arrival order, reading nothing (`crates/ka-reader-bridge/src/session.rs:L1155-L1160`, from act `2`, `:L1085-L1088`); then `read_file` outside the lock; then `open_read` under it, with `reread_open_file` when a batch landed during the read (`:L1101-L1127`). The position act (`:L1165`) and the watcher batch's re-read through `open_file_to_reread` are as the cell states. Two things the cell keeps: `FileRequest`'s `Select`, `Open` and `Position` stay the model's API and the harness's route, and a harness that opens through `open_read` with no selection act folds as before, so § 4 C-I3 is unchanged. Reasoning in `docs/trail/sdd/self_answer-79.md`.
