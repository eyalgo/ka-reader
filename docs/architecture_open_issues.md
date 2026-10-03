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

> **No `product-architecture` run wrote this section or its item.** A `companion-self-answer` run
> added it on 2026-10-03 while answering § 3.1 (`docs/trail/architecture/self_answer-30.md`,
> § Raised on this document). It came from reading § 1.2 against the tree and against
> `checks/structure.sh`'s unit-graph rule while deciding § 3.1. It is not § 3.1's split half, and no
> item raised it. It sits in this bucket because the run has a lean. Its slot is for the next round.

### 2.1 § 1.2 says "may import" is the whole allowed set, but every part in the core imports `language`, a module of no part, and only the script says that is allowed
- **Lands in:** `nfdr.md` § 1.2 — the lead paragraph, or a new `QC` beside QC-10 and QC-11
- **Drafted into the records:** Nothing. No producing run wrote this, and the run that raised it
  writes no record. The change it proposes is a new entry in § 1.2. A module of `nozoki-core` that is
  no SDD part may be imported by any part, and that import is not an edge. Such a module is a value
  module: it holds types two or more parts share, it does no I/O, and **it imports no part**. Today
  those modules are `language` and `error`, plus `lib.rs` as the re-export surface. The new entry
  is verified by `checks/structure.sh`, with one rule added there: a file of no unit that imports a
  unit is a finding.
- **Rationale:** The record and the tree disagree. § 1.2 says "'May import' is the whole allowed
  set; 'must not import' is stated explicitly and never inferred" (`docs/nfdr.md:L208-L209`).
  QC-10's allowed set for `folder-model` does not include `language` (`:L236-L237`). Even so,
  `folder_model.rs:L8`, `fs_reader.rs:L15` and `highlighter.rs:L13` all import `crate::language`. The
  only statement that this is allowed is in the script, not the record:
  `checks/structure.sh:L97-L98` says lib.rs, language.rs and error.rs "belong to no unit, are never a
  subject, and importing one is never an edge". That makes the script hold a rule the NFDR never
  stated. It also leaves a gap no check covers. A file of no unit is never a subject, so it can
  import a part without any finding, and two parts that must not reach each other could route the
  edge through it. Neither SDD § 3 nor ADR-0016 names a module of no part, so both readings of the
  tree are open. The draft takes the one the tree and the script already use (`language.rs:L1-L4`
  gives the reason: "Neither imports the other, so the type lives here"), and closes the route by
  requiring that such a module import no part. § 3.1's answer does not depend on this item: it puts
  `OpenFailure` in `fs-reader`, which needs no new rule.
- **If overridden:** If the override is "no module of no part", then `language` and `error` each move
  into a part, and QC-10's allowed set, QC-11's stated edges, or both must name the import that
  results — for `language`, `highlighter` → `fs-reader` or the reverse, which QC-11 forbids today.
  The script's no-unit carve-out then goes. If the override is "allowed, without the import-no-part
  bound", the record states what the script already does, and the route around the graph stays
  open, with no name for it.
- **Confirm or override:** <"confirm", or "override: <what to do instead>">

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
- **Answer:** (a). QC-11 stands as written, and the edge goes. `OpenFailure` moves out of
  `folder-model` into `fs-reader` — beside `Condition`, the type of the same kind already there
  (`crates/nozoki-core/src/fs_reader.rs:L100`) — by a behaviour-preserving source change that leaves
  `lib.rs`'s `pub use` path, `nozoki_core::OpenFailure`, unchanged, so the bridge's import
  (`crates/nozoki-bridge/src/session.rs:L9`) does not move. The Rust module spelling stays the
  developer's (`docs/nfdr.md:L56-L57`). Any home `fs-reader` may import satisfies QC-11. A module of
  no part does not satisfy it yet, because § 1.2 states no such module; that is § 2.1 below. Reading
  (b) is not this document's to grant. QC-11 transcribes `docs/SDD.md` § 3's units paragraph ("the
  readers, the watcher, the highlighter and the renderer import neither the model nor one another",
  `:L347-L348`), and that document is Settled.
  An NFDR edge from `fs-reader` into the model would contradict it. SM-1's owner cell does not ask
  for the edge either. It says the model *states* what a read must return (`docs/SDD.md:L415`). It
  does not say the model holds the types, unlike SM-2, whose port "is a trait the model owns"
  (`:L416`). The tree already reads SM-1 the first way: five of the types that cross SM-1 —
  `ItemState`, `Condition`, `Entry`, `FileContent` and `CannotDisplayReason` — are defined in
  `fs_reader.rs` (`:L93-L149`), and the model imports them (`folder_model.rs:L6`), which QC-10
  allows. `OpenFailure` is the one exception. For the fold: QC-11's text does not change. Its trace
  should record this reading of SM-1 — a type crossing SM-1 is defined where `fs-reader` may import
  it, never in `folder-model` — and that `checks/structure.sh` holds the clause from the change that
  moves the type. No SDD change is owed. Reasoning: `docs/trail/architecture/self_answer-30.md`.

**How it closes.** `product-architecture` folds it on its next run like any other item here.
