# Architecture open issues — Nozoki 覗き

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

---

## 1. Open issues — questions with no answer yet

None.

## 2. Choices to confirm — the Principal Architect drafted a best-effort answer; confirm or override

### 2.1 QC-30 half (2) scans only crates from outside the workspace, and skips the product's own two crates by membership
- **Lands in:** `nfdr.md` QC-30, *verified by*, half (2)
- **Drafted into the records:** QC-30 half (2) now scans "every crate the `cargo tree` command above
  names from outside the workspace". `nozoki-core` and `nozoki-bridge` are half (1)'s, and the scan
  skips them because they are workspace members, not because their names are on a list. Any other
  crate whose sources the scan cannot open still fails the build (`docs/nfdr.md:L585-L594`; RN-34).
  This item was raised by the `companion-self-answer` run of 2026-10-01
  (`docs/trail/architecture/cycle-20.md` § 2.1). That run left it undrafted. This run drafted it.
- **Rationale:** Before this draft, half (2) scanned every crate the command names and failed on
  any it could not open. Run again for this fold, the command names `nozoki-bridge v0.0.0
  (…/crates/nozoki-bridge)` and `nozoki-core v0.0.0 (…/crates/nozoki-core)`, and neither has a
  registry copy. A `checks/entry-points.sh` written to the old words would therefore fail every
  build before it read a single dependency. Half (1) already holds both crates by name
  (`docs/nfdr.md` QC-30, "**(1) The product's own units**"), and the half's own heading, "**(2) The
  linked dependency tree**", already reads this way. The draft makes the words match that intent.
  It goes to you because it changes what the check does.
- **If overridden:** Half (2) goes back to its old words. `checks/entry-points.sh` then either fails
  on the two product crates every time or skips them with no entry allowing it. The entry forbids a
  silent skip of that kind. Only QC-30's half (2) and RN-34's § 2.1 paragraph move. No record moves.
- **Confirm or override:** <"confirm", or "override: <what to do instead>">

### 2.2 The tree-sitter grammar engine earns a record — ADR-0017, written at Proposed
- **Lands in:** `adr/0017-floor-grammars-compiled-by-tree-sitter-native-c-in-the-core.md`; the
  index; `nfdr.md` QC-9, QC-26 and QC-30, whose trace tags name it
- **Drafted into the records:** ADR-0017 records that the six floor grammars are compiled by
  tree-sitter: native C, built from source into `nozoki-core` on every build, behind `highlighter`
  alone. It records the two alternatives the dependency review ruled out, hand-written lexers and
  `syntect`, and what the decision rests on: the tree-sitter and tree-sitter-grammars projects, a C
  compiler at build time, and the runtime's grammar-ABI range. It binds QC-9, QC-26 and QC-30.
  Separately, QC-9 gains the limit SDD § 3 now states: *no `unsafe`* is about each crate's own Rust
  source, and the C the core links is outside it (`docs/nfdr.md:L217-L222`). That limit traces to
  the SDD and stays whichever way you answer.
- **Rationale:** SDD v23 added the engine as § 9 TO-11 (`docs/SDD.md:L2252-L2265`), and a § 9
  trade-off is one of the places a record is found. The decision clears two of the three gates
  plainly. It is surprising without its context, because a core whose own source forbids `unsafe`
  parses the folder's bytes in C. And it was a real trade-off, with two alternatives weighed
  (`nozoki@85d9fa7:checks/deps.review.md` § *The engine chosen*). The third gate, hard to reverse,
  could be read either way. TO-11 says undoing it rewrites one part and moves no seam. Against that,
  the rewrite is six languages' worth of lexing or a second engine with vendored syntaxes. The run
  leans toward a record. ADR-0004 recorded libgit2, the product's other body of native C, and TO-2
  names the same kind of cost.
- **If overridden:** ADR-0017 is deleted, which is allowed because it is still Proposed and no one
  has accepted it. Its index row goes, and `ADR-0017` leaves the trace tags of QC-9, QC-26 and
  QC-30. QC-9's limit stays, tracing to SDD § 3 and § 11 R-14. RN-34 records that the engine failed
  the reversal gate. TO-11 and `checks/deps.review.md` remain the only places the weighing is
  written.
- **Confirm or override:** <"confirm", or "override: <what to do instead>">

## 3. Raised from downstream — an item from a seat that did not write these records

None.
