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
- **Answer:** <the owner fills this in>

### 5.2 § 3 SM-4's `select_file` clause names no act `2` and keeps the two-quick-selections bound; both changed at `ka-reader@f44d370`
- **Raised by:** PM — 2026-11-06
- **Seat:** cto
- **Tracked by:** `ka-reader · nemawashi · 2026-10-13_the-tree-and-the-open-file-follow-the-disk`
- **What it blocks:** nothing is blocked; three sentences of the clause are now false.
- **Where it shows:** § 3, the SM-4 row. (1) "Any other act applies nothing and answers `pending`" — act `2` now applies `FileRequest::Select` before any read, reads no content and answers `pending` (`crates/ka-reader-bridge/src/boundary.rs:L261`; `crates/ka-reader-bridge/src/session.rs:L1085`, `:L1155`); only an act other than `0`, `1` and `2` applies nothing. (2) The first of its "Two bounds", "the selection still joins the model after the read … so the `surfaces` row's known defect, two quick selections, stands at `d6bc3a3`" — the selection act is applied before the read, and the fold is admitted only for the latest selection act (5.1). (3) Its citation of the shell's open at `LaunchFlow.swift:L215-L216` — the shell now sends the selection act on the tree-act runner, then the open from its delivery (`ka-reader-mac/Sources/Shell/LaunchFlow.swift:L190-L193`, `:L213`; `ka-reader-mac/Sources/KAReader/NativeBridge.swift:L49`, code `2`). No function joins SM-4's list.
- **If a document has to be written:** none.
- **Answer:** <the owner fills this in>

### 5.3 § 3 SM-5's description of `FolderModel::open_read` and of how the bridge drives an open omits the selection act
- **Raised by:** PM — 2026-11-06
- **Seat:** cto
- **Tracked by:** `ka-reader · nemawashi · 2026-10-13_the-tree-and-the-open-file-follow-the-disk`
- **What it blocks:** nothing is blocked; the Down cell no longer says when an open's read is folded.
- **Where it shows:** § 3, the SM-5 row: `FolderModel::open_read` "folds that read in, the path selected and open at the position, when it resolved to a file, else the model as it was", and "an open is `read_file` outside the lock, then `open_read` under it". At `ka-reader@f44d370` the fold is made only when no selection act was admitted since the model was made, or when the read answers the latest selection act not yet answered (`crates/ka-reader-core/src/folder_model.rs:L760`, `:L1201`); the bridge's selection act is `select_file(FileRequest::Select)` under the lock, before the open's read (`crates/ka-reader-bridge/src/session.rs:L1155`).
- **If a document has to be written:** none.
- **Answer:** <the owner fills this in>
