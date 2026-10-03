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

> **This companion was rewritten by the `product-architecture` run of 2026-10-03, the cycle-26
> fold.** The PM opened it on 2026-10-03 with one item raised from downstream, § 3.1. The owner's
> seat answered it, and the fold placed it in QC-11's trace at NFDR v29
> (`docs/trail/architecture/cycle-26.md` holds it as answered; `nfdr.md` RN-40). What remains is
> § 2.1, the item the answering run raised on these records, now drafted into them as QC-63, with
> its slot still empty.

---

## 1. Open issues — questions with no answer yet

None.

## 2. Choices to confirm — the Principal Architect drafted a best-effort answer; confirm or override

> **No `product-architecture` run raised this item.** A `companion-self-answer` run added it on
> 2026-10-03 while answering § 3.1 (`docs/trail/architecture/self_answer-30.md`, § Raised on this
> document). It came from reading § 1.2 against the tree and against `checks/structure.sh`'s
> unit-graph rule. The v29 run drafted it into the records (RN-40). Its slot is the owner's.

### 2.1 § 1.2 says "may import" is the whole allowed set, but every part in the core imports `language`, a module of no part, and only the script says that is allowed
- **Lands in:** `nfdr.md` § 1.2 — the lead paragraph, or a new `QC` beside QC-10 and QC-11
- **Drafted into the records:** `nfdr.md` **QC-63** in § 1.2, its § 10 row, and one sentence in
  § 1.2's lead pointing at it — at v29, by the `product-architecture` run of 2026-10-03 (RN-40).
  QC-63 says a module of `nozoki-core` that is no SDD part is a value module: it holds types and
  values only, holds no I/O (QC-15), and imports no part. Any part may import it, and that import
  is not an edge. `lib.rs` is named as the re-export surface, neither a part nor a value module,
  because it re-exports from every module (`crates/nozoki-core/src/lib.rs:L9-L15`). That is one
  step beyond the item as raised. `checks/structure.sh` gains one rule, owed by the change that
  adds it: a file of no unit, `lib.rs` aside, that imports a unit is a finding. Until then the
  gate is `development-design`. Re-measured at `nozoki@803b599`: `language.rs` and `error.rs`
  import no part, so the rule would raise nothing on the tree today. *As raised, this field read
  "Nothing": the raising run wrote no record.* The change the item proposed, kept as it was
  raised: a new entry in § 1.2. A module of `nozoki-core` that is
  no SDD part may be imported by any part, and that import is not an edge. Such a module is a value
  module: it holds types two or more parts share, it does no I/O, and **it imports no part**. Today
  those modules are `language` and `error`, plus `lib.rs` as the re-export surface. The new entry
  is verified by `checks/structure.sh`, with one rule added there: a file of no unit that imports a
  unit is a finding.
- **Rationale:** *(As raised; its `docs/nfdr.md` line numbers are v28's, at `nozoki@803b599` — v29
  moved them by the lead's new sentence.)* The record and the tree disagree. § 1.2 says "'May import' is the whole allowed
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
  open, with no name for it. Either way the next fold rewrites or withdraws QC-63, its § 10 row and
  the lead's pointer; QC-63 is new at v29, so no record and no other entry traces to it yet.
- **Confirm or override:** confirm, with one addition. This was decided in the owner's seat by a
  `companion-self-answer` run, not by the owner. QC-63 stands as v29 drafted it, and it is true of
  the tree at `nozoki@a3caabd`, whose `crates/` and `checks/` are `nozoki@803b599`'s:
  `language.rs:L30-L39` is one enum and `error.rs:L4-L9` a variantless enum that only `lib.rs:L9`
  re-exports, and their only crate-relative lines, `language.rs:L43` and `error.rs:L26`, sit in test
  modules and name their own type. **The addition.** "Holds types and values only" has no check, and
  by this document's preamble an obligation with no nameable verification is not yet an entry. The
  scan cannot reach it. SDD § 3 gives the extension map that names a language to `fs-reader`
  (`docs/SDD.md:L322`) and denies it to `highlighter` ("Naming the language", `:L327`). Moved into
  `language.rs` as a `Language` method, that map imports no part and does no I/O, so it passes the
  new rule and QC-15 while taking owned behaviour out of its part. QC-63's *verified by* names review
  at `development-design` for that half, in QC-13's form for its delegation half — what counts as
  logic is not greppable — and the review asks whether the module holds anything a part's *Owns*
  cell in SDD § 3 names. § 10's closing list of review gates names "QC-63 (the types-and-values
  half)" beside "QC-13 (the delegation half)". **One reason corrected, and nothing in the entry moves
  for it.** The rationale says both readings of the tree are open, and RN-40 says an SDD reader could
  derive it another way. At this document's altitude they are not open. `Language` crosses SM-1
  upward, "the floor language named" (`docs/SDD.md:L415`), so cycle 26's reading keeps it out of
  `folder-model`. `fs-reader` names it and `highlighter` consumes it, and the units paragraph states
  exactly two edges among the readers (`:L347-L349`). So placing it in any part needs an edge the SDD
  does not state, which would be the CTO's change and not this document's. And SDD § 3 leaves the
  physical layout to the developer (`:L433`). QC-63's trace cites `:L433` and SM-1 as that ground.
  Reasoning: `docs/trail/architecture/self_answer-31.md` § 2.1.

## 3. Raised from downstream — an item from a seat that did not write these records

None.
