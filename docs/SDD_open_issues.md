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
- **Answer:** <the owner fills this in>

### 5.2 § 3's `FileView` bullet names *gone* but not the form it is held in, which § 6 S-6 says the slice writes into § 3
- **Raised by:** PM — 2026-11-06
- **Seat:** cto
- **Tracked by:** `ka-reader · nemawashi · 2026-10-13_the-tree-and-the-open-file-follow-the-disk`
- **What it blocks:** § 6 S-6 *Rests on*: "the form found is written into § 3's `folder-model` row"; the form is built and the row does not hold it.
- **Where it shows:** § 3, *What the system holds*, the `FileView` bullet: "*gone* (the file vanished under the reader — FR-28)". Built at `ka-reader@d6bc3a3` (`crates/ka-reader-core/src/folder_model.rs:L131-L136`, `:L1201`, `:L1238`): *gone* is a form of the open `FileView`'s content, held as `observed` — a re-read of the open file found nothing at its path (no entry at a step of the path as spelled, or a step above it no longer a folder, with no link's target being resolved there). It carries no content; the path and the reading position stay the reader's. A re-read that finds something at the path it cannot read as the file (a folder, an unreadable file, a link that leads outside, loops or leads to nothing) is `failed` with the condition observed, never *gone*. Only a re-read of the open file reaches *gone*; a selection of a path where nothing is answers `failed` as before. The next re-read that reads the file replaces *gone* or `failed`, and the held position is drawn as far as the content reaches. The `model_changed` delta carries the open file (path, position, view) whenever its path or view changes, stamped with a revision that rises within the grant, so the shell draws only the newest.
- **If a document has to be written:** none.
- **Answer:** <the owner fills this in>

### 5.3 § 3 SM-5 names only the request types going down; `select_file` and the open file's re-read now reach the model through named functions
- **Raised by:** PM — 2026-11-06
- **Seat:** cto
- **Tracked by:** `ka-reader · nemawashi · 2026-10-13_the-tree-and-the-open-file-follow-the-disk`
- **What it blocks:** nothing is blocked; the row no longer lists every call the bridge makes into the model.
- **Where it shows:** § 3, the SM-5 row ("Down: the operations the functions name, as plain Rust calls — the model's request types, `TreeRequest` (…) and `FileRequest` (`Select`, `Open`, `Position`)"). At `ka-reader@d6bc3a3` `select_file`'s open goes through `read_file` and `FolderModel::open_read` (`folder_model.rs:L222`, `:L1174`) and the open file's re-read through `FolderModel::reread_open_file` (`:L1201`), beside the request types, as the Git read's split (`read_git_item`, `with_git_item`) already stands.
- **If a document has to be written:** none.
- **Answer:** <the owner fills this in>

### 5.4 *Open Questions*' collapse-and-scroll item has met its own settling condition
- **Raised by:** PM — 2026-11-06
- **Seat:** cto
- **Tracked by:** `ka-reader · nemawashi · 2026-10-13_the-tree-and-the-open-file-follow-the-disk`
- **What it blocks:** nothing is blocked; the item still says "the reading position reaches the model from nowhere yet".
- **Where it shows:** *Open Questions*, the collapse-and-scroll item: "Settled by the first build in which the shell supplies that argument, `--test exports` still passing with SM-4's ten". At `ka-reader@d6bc3a3` the shell supplies the position through `select_file` (5.1) and the export check holds the closed set, so the item is settled and may leave the list.
- **If a document has to be written:** none.
- **Answer:** <the owner fills this in>
