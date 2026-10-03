# Architecture open issues — Nozoki

> Companion to `adr/` and `nfdr.md`. The Principal Architect authored both records
> non-interactively; this file holds what the run could not settle from its inputs — the SRS, the SDD
> and the FDR.
> **Answer inline** — fill each **Answer** / **Confirm-or-override** slot — **commit this file**, then
> re-run `product-architecture`. It folds your answers into the records and drops the resolved items.
> When nothing is left open, `product-architecture` **deletes this file**: no file = the records are
> done.
>
> Your answers are never thrown away. Each time the Principal Architect folds them in, it first copies
> this file whole to `docs/trail/architecture/` — so what you decided, and why, stays readable and
> citable for good.
>
> **§ 3 is raised, not asked.** These records bind every later change, so the seats that live under
> them find gaps the authoring run could not. § 3 is where such a seat says so, against both records
> — an ADR's binding and an NFDR obligation reach the same file.

> **No `product-architecture` run wrote this file.** The PM opened it on 2026-10-03 from the records'
> own companion template, after `checks/structure.sh` gained the unit-graph rules (`nozoki@8c3ab40`).
> The tree has one edge that QC-11 forbids and SM-1 seems to need, so the script cannot hold that clause
> until the records say which one governs. The NFDR is Settled, and with no companion on disk a
> `product-architecture` re-run reads it as done and has nothing to act on. Its one item is in § 3.

---

## 1. Open issues — questions with no answer yet

None.

## 2. Choices to confirm — the Principal Architect drafted a best-effort answer; confirm or override

None.

## 3. Raised from downstream — an item from a seat that did not write these records

### 3.1 QC-11 forbids `fs-reader` importing `folder-model`, but SM-1 makes `folder-model` the owner of what a read returns
- **Raised by:** PM — 2026-10-03
- **Which record:** `nfdr.md` QC-11, read against QC-10's "neither imports the model"
- **Tracked by:** `nozoki · nemawashi · 2026-10-01_the-tree-is-checked-for-its-shape`
- **What it blocks:** `checks/structure.sh` cannot hold QC-11's `fs-reader` → `folder-model` clause.
  Holding it would fail the real tree, and the CI step `Structure check` is fatal. The script names the
  clause as not held, with its site (`checks/structure.sh`, `# WHAT IS NOT HELD`).
- **Where it shows:** QC-11 says `fs-reader` "must not import" `folder-model` (`docs/nfdr.md:L251-L254`),
  and QC-10 repeats it: "neither imports the model" (`:L240-L241`). The tree has that edge:
  `crates/nozoki-core/src/fs_reader.rs:L14` is `use crate::folder_model::OpenFailure;`. `fs_reader`
  maps I/O errors onto it (`:L20-L39`), and the type is defined at
  `crates/nozoki-core/src/folder_model.rs:L38`. The SDD's SM-1 row names `folder-model` as the owner of
  the `fs-reader` ↔ `folder-model` contract: "it states what a read must return; the reader implements
  it" (`docs/SDD.md:L415`). SM-2 says the same for the Git port, and QC-10 lists "the Git port trait"
  apart from the model (`docs/nfdr.md:L236`). SM-1 has no such separate thing. Two readings fit:
  - (a) QC-11 stands and the edge goes. The condition type moves to a module of no unit, as `language`
    already is, by a behaviour-preserving source change with `lib.rs`'s public re-exports unchanged.
    SM-1's owner cell may then want a sentence saying the model states the contract without holding its
    type;
  - (b) QC-11 grants `fs-reader` an edge into the contract types SM-1 gives the model, and names them.
- **If a document has to be written:** none. QC-11 and QC-10's sentence in `nfdr.md`, and under (a)
  perhaps SM-1's owner cell in `SDD.md`.
- **Answer:** <the owner fills this in>

**How it closes.** `product-architecture` folds it on its next run like any other item here.
