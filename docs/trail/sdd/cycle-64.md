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

### 5.1 § 3 SM-4's `select_file` clause says the reading position does not cross yet; it crosses at `ka-reader@d6bc3a3`
- **Raised by:** PM — 2026-11-06
- **Seat:** cto
- **Tracked by:** `ka-reader · nemawashi · 2026-10-13_the-tree-and-the-open-file-follow-the-disk`
- **What it blocks:** nothing is blocked; the clause is now false, and `follow-the-file` (§ 6 S-6) reads it as the crossing still owed.
- **Where it shows:** § 3, the SM-4 row: "at `ka-reader@2529a42` the export still takes the path alone, … the open with its reading position and the position alone do not cross yet". At `ka-reader@d6bc3a3` the export is `ka_reader_select_file(path, act: u32, position)` (`crates/ka-reader-bridge/src/exports.rs:L112-L116`): act `0` is the open, with the selection, at its position, answering the file's verdict as before; act `1` is the position alone, applied only when the path is the open file, answering `pending`; any other act applies nothing. No function joins SM-4's list.
- **If a document has to be written:** none — the SM-4 row is re-stated at that commit.
- **Answer:** Yes — the clause is false at `ka-reader@d6bc3a3` and the SM-4 row re-states it at that commit. The export is `ka_reader_select_file(path, act: u32, position)` (`crates/ka-reader-bridge/src/exports.rs:L112-L116`) and the shell sends all three (`ka-reader-mac/Sources/KAReader/NativeBridge.swift:L44-L63`; `ka-reader-mac/Sources/Shell/LaunchFlow.swift:L215-L216` the open, `:L224-L225` the position). Act `0` is the open: the file is read, then selected and opened at `position` through `FolderModel::open_read` (5.3), and its verdict is the answer; a NULL position is the empty position (`crates/ka-reader-bridge/src/boundary.rs:L246-L262`). Act `1` is the position alone: applied through `FileRequest::Position` only when the path is the open file, nothing read, answer `pending` (`crates/ka-reader-bridge/src/session.rs:L1146-L1156`); a NULL position with act `1` applies nothing. Any other act applies nothing and answers `pending`; no folder open, and a NULL, empty or non-UTF-8 path, answer `pending` as before. No function joins the list, and `--test exports` holds the admitted set (`crates/ka-reader-bridge/tests/exports.rs:L18-L22`). Two bounds the row keeps, so the restatement does not overclaim: the selection still joins the model after the read — the open's read runs outside the lock and `open_read` folds it under the lock once the read returns (`session.rs:L1093-L1118`) — so the `surfaces` row's known defect (two quick selections) stands at `d6bc3a3` and the station's fourth line carries it; and the fold is made only for the grant the read was made for, with one more re-read of the open file when a batch landed during the read (`:L1114-L1116`). Strike "that crossing stays with `follow-the-folder` as RC-7 assigns it": RC-8 moved it to S-6 and S-6 built it. The 2026-11-05 note stays; the clause it replaces is kept the same way, dated 2026-11-06. Reasoning: `docs/trail/sdd/self_answer-78.md` § 5.1.

### 5.2 § 3's `FileView` bullet names *gone* but not the form it is held in, which § 6 S-6 says the slice writes into § 3
- **Raised by:** PM — 2026-11-06
- **Seat:** cto
- **Tracked by:** `ka-reader · nemawashi · 2026-10-13_the-tree-and-the-open-file-follow-the-disk`
- **What it blocks:** § 6 S-6 *Rests on*: "the form found is written into § 3's `folder-model` row"; the form is built and the row does not hold it.
- **Where it shows:** § 3, *What the system holds*, the `FileView` bullet: "*gone* (the file vanished under the reader — FR-28)". Built at `ka-reader@d6bc3a3` (`crates/ka-reader-core/src/folder_model.rs:L131-L136`, `:L1201`, `:L1238`): *gone* is a form of the open `FileView`'s content, held as `observed` — a re-read of the open file found nothing at its path (no entry at a step of the path as spelled, or a step above it no longer a folder, with no link's target being resolved there). It carries no content; the path and the reading position stay the reader's. A re-read that finds something at the path it cannot read as the file (a folder, an unreadable file, a link that leads outside, loops or leads to nothing) is `failed` with the condition observed, never *gone*. Only a re-read of the open file reaches *gone*; a selection of a path where nothing is answers `failed` as before. The next re-read that reads the file replaces *gone* or `failed`, and the held position is drawn as far as the content reaches. The `model_changed` delta carries the open file (path, position, view) whenever its path or view changes, stamped with a revision that rises within the grant, so the shell draws only the newest.
- **If a document has to be written:** none.
- **Answer:** Yes — the form is built and the `FileView` bullet and the `folder-model` row state it at `ka-reader@d6bc3a3`. *Gone* is a variant of `FileView` (`FileView::Gone`, `crates/ka-reader-core/src/folder_model.rs:L107-L136`), held as `ItemState::Observed(FileView::Gone)` — observed, not failed, because nothing went wrong: nothing was at the path. Only the re-read of the open file reaches it (`FolderModel::reread_open_file`, `:L1201`; `reduce_open_file`, `:L1241`), when `fs_reader::reobserve_file` answers *absent* (`crates/ka-reader-core/src/fs_reader.rs:L476-L514`): no entry at a step of the path as the reader spelled it, or a non-folder where the path goes on, with no link's target being resolved at that step. Everything else that stops a re-read — a folder at the path, an unreadable or non-regular file, a link whose target is missing, outside the folder, looping or too long — is `failed(condition)`, never *gone*; an open or a selection of a path where nothing is answers `failed` as before; an empty file is *text* with no content, not *gone*. It carries no content. The path and the reading position are the reader's place and are never touched by a re-read; the next re-read that reads the file replaces *gone* or `failed` with the view the content makes, with no message. The delta: `TreeChanges` carries the open file — path, position, view — when the earlier model held none, or one with another path or another view; a change of position or resolved location alone is not carried (`:L558-L590`; `changes_since`, `:L821`), so a batch over unchanged bytes delivers no open-file member. The bridge stamps each payload that carries it with a revision that rises by one within the grant (`crates/ka-reader-bridge/src/session.rs:L686-L713`), and the shell draws only the newest. The drawing is `surfaces`' and the UXD's, not this row's, and it stands as: the path line, the failure glyph and one sentence that the file is gone (`ka-reader-mac/Sources/Surfaces/ReadingPanelView.swift:L13`, `:L260`); on an update over text the panel keeps its own scroll, clamped to the new text, and applies the model's position only on a recovery or a first draw (`:L200-L234`). Not decided by this clause, named so it is not read as decided: the root's own disappearance, which the `folder-model` row already leaves open. Reasoning: `docs/trail/sdd/self_answer-78.md` § 5.2.

### 5.3 § 3 SM-5 names only the request types going down; `select_file` and the open file's re-read now reach the model through named functions
- **Raised by:** PM — 2026-11-06
- **Seat:** cto
- **Tracked by:** `ka-reader · nemawashi · 2026-10-13_the-tree-and-the-open-file-follow-the-disk`
- **What it blocks:** nothing is blocked; the row no longer lists every call the bridge makes into the model.
- **Where it shows:** § 3, the SM-5 row ("Down: the operations the functions name, as plain Rust calls — the model's request types, `TreeRequest` (…) and `FileRequest` (`Select`, `Open`, `Position`)"). At `ka-reader@d6bc3a3` `select_file`'s open goes through `read_file` and `FolderModel::open_read` (`folder_model.rs:L222`, `:L1174`) and the open file's re-read through `FolderModel::reread_open_file` (`:L1201`), beside the request types, as the Git read's split (`read_git_item`, `with_git_item`) already stands.
- **If a document has to be written:** none.
- **Answer:** Yes — SM-5's Down cell names the functions beside the request types at `ka-reader@d6bc3a3`, as it already names the Git read's split. Three: `read_file(folder, path) -> FileRead` (`crates/ka-reader-core/src/folder_model.rs:L222`) — the read for an open, touching no model, answering exactly what `select_file` answers for the path together with whether it resolved to a file; `FolderModel::open_read(FileRead, ReadingPosition)` (`:L1174`) — folds that read in, the path selected and open at the position, when it resolved to a file, else the model as it was; `FolderModel::reread_open_file()` (`:L1201`) — re-reads the open file once, whatever was reported, and folds the answer in beside the path and position. How the bridge drives them: an open is `read_file` outside the lock, then `open_read` under it, then `reread_open_file` when a batch landed during the read (`crates/ka-reader-bridge/src/session.rs:L1093-L1118`); the position act is `select_file(FileRequest::Position)` (`:L1146-L1156`); a watcher batch is `TreeRequest::Invalidate`, which also re-reads the open file when the batch names the root, or a path the open file's path or its resolved location starts with (`open_file_to_reread`, `folder_model.rs:L1212`). `FileRequest`'s `Select`, `Open` and `Position` stay the model's API and the harness's route (`:L679`, `:L903`); the bridge's open no longer goes through `FileRequest::Open`, which is what SM-4's clause now says (5.1). All three functions are public (`crates/ka-reader-core/src/lib.rs:L12-L14`), so § 4 C-I3's in-process harness route is unchanged. Up: projections and deltas, the delta now carrying the open file (5.2). Reasoning: `docs/trail/sdd/self_answer-78.md` § 5.3.

### 5.4 *Open Questions*' collapse-and-scroll item has met its own settling condition
- **Raised by:** PM — 2026-11-06
- **Seat:** cto
- **Tracked by:** `ka-reader · nemawashi · 2026-10-13_the-tree-and-the-open-file-follow-the-disk`
- **What it blocks:** nothing is blocked; the item still says "the reading position reaches the model from nowhere yet".
- **Where it shows:** *Open Questions*, the collapse-and-scroll item: "Settled by the first build in which the shell supplies that argument, `--test exports` still passing with SM-4's ten". At `ka-reader@d6bc3a3` the shell supplies the position through `select_file` (5.1) and the export check holds the closed set, so the item is settled and may leave the list.
- **If a document has to be written:** none.
- **Answer:** Yes — the item has met its own settling condition at `ka-reader@d6bc3a3` and leaves *Open Questions*. Both halves are built: the collapse at `ka-reader@2529a42` (already in the item), and the scroll now — the shell supplies the position on `select_file`, at the open and as the position act (`ka-reader-mac/Sources/Shell/LaunchFlow.swift:L187-L194`, `:L215-L216`, `:L224-L225`), and `--test exports` passes with the admitted set and no eleventh call (`crates/ka-reader-bridge/tests/exports.rs:L18-L22`), so the first form held and no § 10 entry is owed. § 4 C-E2 binds the refresh on its own and loses nothing with the item. The item is struck, and the fold records it as a dated note in the review notes, the way the WKWebView question was closed by RC-3 (RN-60); the five other items stand, so the heading stays. Two live citations of the item are re-pointed to that note, so neither names a removed entry: § 3 SM-4's `list_tree` clause ("the first of the collapse-and-scroll item's three forms") and § 6 S-6 *Reached when* ("the crossing *Open Questions*' collapse-and-scroll item leaves to this slice"); the citations inside § 10 RC-4, RC-7, RC-8 and the review notes are dated history and stand. Not settled by it and not reopened by it: the order of two quick selections, which is the `surfaces` row's known defect and the station's fourth line. Reasoning: `docs/trail/sdd/self_answer-78.md` § 5.4.
