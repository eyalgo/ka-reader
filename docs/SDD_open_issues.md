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
- **Answer:** <the owner fills this in>

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
- **Answer:** <the owner fills this in>
