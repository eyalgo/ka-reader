# SDD open issues — KA-Reader

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

> **No `product-sdd` run wrote this file.** The PM opened it on 2026-10-16, from a `shukuba-refine`
> review on the seed `ka-reader · nemawashi · 2026-10-13_the-tree-and-the-open-file-follow-the-disk`,
> to carry items 5.1 and 5.2 below. The SDD is Settled, so without a companion they would reach no one.

---

## 1. Open issues — questions with no answer yet

None.

## 2. Choices to confirm — a best-effort answer was drafted; confirm or override

None.

## 3. Cut calls to confirm — where the slicing could reasonably have gone another way

None.

---

## 4. Disagreements — two seats hold different positions and neither yields

None.

## 5. Raised from downstream — an item from a seat that did not write the SDD

### 5.1 The collapse-and-scroll item says the model has no operation to set a reading position, and it now has one
- **Raised by:** PM — 2026-10-16
- **Seat:** cto
- **Tracked by:** `ka-reader · nemawashi · 2026-10-13_the-tree-and-the-open-file-follow-the-disk`
- **What it blocks:** nothing. But the item describes a state that no longer holds. *Open Questions*,
  the collapse-and-scroll item (lines 8496–8513), says "SM-5 carries the operations those functions
  name and no others, so `follow-the-folder`'s `--test watch` has no operation to set a reading
  position with", and that the item is "settled by `follow-the-folder`'s first build keeping the place
  under `checks/churn.sh`, or by an earlier change that brings the held state into the model". The
  held state is now in the model, in the first of the three forms, at the model's API:
  `FolderModel::list_tree(self, request: TreeRequest)` and `FolderModel::select_file(self, request:
  FileRequest)` (`crates/ka-reader-core/src/folder_model.rs:L631`, `:L654`) take the expansion, the
  collapse, the selection and the open file's reading position as arguments on the operations SM-4's
  `list_tree` and `select_file` name, and `cargo test --locked -p ka-reader-core --test watch`
  passes 13 cases including `place_survives_mixed_delta`. No export was added:
  `cargo test --locked -p ka-reader-bridge --test exports` passes 11, unedited. The C ABI has not
  acquired the arguments: the shell still calls `ka_reader_list_tree` and `ka_reader_select_file` with
  the path alone (`ka-reader-mac/Sources/KAReader/NativeBridge.swift:L26-L39`). All measured at
  `ka-reader@8ef8c5b`.
- **Where it shows:** *Open Questions*, the collapse-and-scroll item; SM-4's row, which the item says
  the first form is "written into … when found".
- **If a document has to be written:** none. The fold would state that the first form is found at the
  model's API, that the C ABI and the Swift callers have not yet acquired the arguments, and that SM-4's
  row owes its description once that crossing is built. It would not describe the shell-to-model path
  as built.
- **Answer:** Confirm, with additions. The sentence is false at `ka-reader@8ef8c5b`: the first form
  is found, at the model's API. `FolderModel::list_tree(TreeRequest)` takes the expansion, the
  collapse and the disk's delta, and `FolderModel::select_file(FileRequest)` takes the selection, the
  open with its reading position, and the position alone
  (`crates/ka-reader-core/src/folder_model.rs:L631`, `:L654`; `TreeRequest` `:L400-L408`,
  `FileRequest` `:L491-L499`, `ReadingPosition` `:L286`); in a fresh clone at `ka-reader@a2b9389`,
  whose tree outside `docs/` is `8ef8c5b`'s, `cargo test --locked -p ka-reader-core --test watch`
  passes 13, `place_survives_mixed_delta` among them, and `cargo test --locked -p ka-reader-bridge
  --test exports` passes 11. SM-4 is unchanged: `ka_reader_list_tree` and `ka_reader_select_file`
  take the path alone (`crates/ka-reader-bridge/src/exports.rs:L74`, `:L91`;
  `ka-reader-mac/Sources/KAReader/NativeBridge.swift:L26-L39`), and no export was added. The fold
  writes four things and describes no shell-to-model path as built. (1) *Open Questions*, the
  collapse-and-scroll item **narrows and does not close**: the three-form fork is settled — the
  first form is the one built, so the second and third are off and no § 10 entry is owed, since
  form one moves no list and no bar failed; what stays open is the crossing of SM-4 alone — the
  collapse, the selection and the reading position as arguments on `list_tree` and `select_file`
  with no new export — settled by the first build in which the shell calls them with those
  arguments and `--test exports` still passes with SM-4's ten; a crossing that needs an eleventh
  call is the third form again, and the item's own rule for it — recorded in § 10 before it is
  built, an eleventh call without one failing C-R7's set equality — stays as written. The sentence
  "SM-5 carries the operations those functions name and no others, so … has no operation to set a
  reading position with" becomes a dated account. (2) SM-4's row takes the form now, as the item's
  own rule says — "written into SM-4's row when found" — and not once the crossing is built: `list_tree`
  carries the expansion or the collapse of a folder, `select_file` the selection, the open with the
  reading position, or the position alone; built at the model's API at `ka-reader@8ef8c5b`, the C ABI
  taking the path alone until the shell's crossing is built, and no function joins the list. The row
  already describes calls ahead of their build with a build-state clause, so this is its own style.
  (3) SM-5's row: "the operations the functions name" now reads as the model's request types,
  `TreeRequest` and `FileRequest`, pinned — a delta is SM-3's events applied through this seam and
  not a shell call. (4) § 6 `follow-the-folder` *Rests on*: the model holds the place from
  `ka-reader@8ef8c5b`, and "how a collapse and a scroll reach it across SM-4 is open" stands,
  narrowed as in (1). RN-77 stands as a dated record. Reasoning:
  `docs/trail/sdd/self_answer-59.md` § 5.1.

### 5.2 No document says what the held expansion and selection hold when the entry they name is removed
- **Raised by:** PM — 2026-10-16
- **Seat:** cto
- **Tracked by:** `ka-reader · nemawashi · 2026-10-13_the-tree-and-the-open-file-follow-the-disk`
- **What it blocks:** the walk of `follow-the-folder` past its tree half. A refresh can remove an
  expanded folder, a folder above one, or the selected file. § 3 gives `folder-model` the tree's
  expansion and the selection, and § 4 C-E2 binds that a refresh does not collapse a node, but no
  clause says what either holds once its own entry is gone. The model as built keeps it: applying a
  delta does not touch the held place (`reduce`, `crates/ka-reader-core/src/folder_model.rs:L772`), and
  a collapse of a folder that no longer resolves is refused at admission, so that folder stays held
  expanded (`admit` and `collapse`, `:L710-L739`). At `ka-reader@8ef8c5b`. The forms seen are three:
  drop the held state for the removed entry and everything under it; keep it, inert, until an entry
  at that path returns; or keep it and have the tree say the entry is gone. `docs/fdr.md` R-81
  ("stale content is never presented as current") bears on the second and third once the shell draws
  the place. The open file's own removal is not this item: `docs/fdr.md` R-80 and the file-gone state
  already state it.
- **Where it shows:** § 3, the `folder-model` row; § 4 C-E2; *Open Questions* holds no item for it.
- **If a document has to be written:** none. A clause in § 4 C-E2, or an *Open Questions* item settled
  in `follow-the-folder`, would carry it.
- **Answer:** The second form, bounded, with two consequences the reducer carries. **The rule:** the
  reader's place — the expanded set, the selection, the open file's path and position — is the
  reader's acts and not a read of the disk, and a delta carries it as it was
  (`crates/ka-reader-core/src/folder_model.rs:L405-L407`, `:L772`). When a delta reports the entry
  it names removed, the model keeps it, inert: it is drawn nowhere, because the parent's listing no
  longer lists the entry (`reduce_listing`, `:L795-L815`) and a surface draws only from listings;
  when an entry at that path returns, the held flag or selection binds to it again. Not the first
  form, because the churn this slice is for removes and recreates folders — a branch checkout, a
  build directory, an agent's rewrite — and a node collapsed on its return is the refresh taking the
  place away that § 4 C-E2's *Violated by* and `docs/fdr.md` R-78 forbid. Not the third form,
  because a row for an entry its parent's listing no longer carries is state the bridge did not send
  from a read (§ 3, the `surfaces` row's one exception), and the "marked as no longer there" half of
  UX-I4 is already met where it occurs: `docs/CONTENT.md` § *Message patterns* → *Partial*'s folder
  sentence covers a row listed and then found empty before the parent re-lists, and R-80 covers the
  open file; neither needs a held ghost row after the parent re-lists. **Consequence one, measured
  and binding:** the held *listing* under a removed folder is not the place and is not kept as
  current. At `ka-reader@8ef8c5b` `reduce` touches only listings whose folder a reported path's
  parent resolves to (`apply_delta`, `:L669-L705`), so a removed folder's own listing stays; a
  folder expanded over `a.rs`, removed and reported, then recreated holding `b.rs` and reported,
  answers `listing("src")` as `["a.rs"]` while the disk holds `b.rs` (measured in a disposable clone
  at `ka-reader@a2b9389` through the public API). Drawn under the returned, still-expanded folder,
  that is stale content presented as current — R-81, UX-I4. So the fold states the reducer's rule:
  an entry reported removed drops every held listing at and under its path, the listings and never
  the place; an entry reported present at a path the place holds expanded is read in that same
  delta, so the folder returns with its listing fresh or `pending`, never the old one. Both are
  SM-5's and move no seam. **Consequence two, measured and stated as a bound:** a collapse or an
  expand of a path that no longer resolves is refused at admission (`admit`, `:L710-L714`; `expand`
  `:L716`; `collapse` `:L732`), so the held flag cannot change while the entry is absent — and no row
  is drawn, so no act reaches it; `Select(None)` still clears the selection (measured). **Where it
  lands:** § 3, the `folder-model` row — one clause stating the rule and both consequences; § 6
  `follow-the-folder` *Reached when*, command half — "expansion, selection and reading position
  surviving" reads through the removal and return of their own entries, with the returned folder's
  listing fresh, as a `--test watch` case; *Open Questions* gains nothing, because the form is
  decided here; § 4 C-E2 does not move — the CDO's condition already binds the surface's half. Not
  this item: the open file's own removal (R-80), and the root's own disappearance. Reasoning:
  `docs/trail/sdd/self_answer-59.md` § 5.2.
