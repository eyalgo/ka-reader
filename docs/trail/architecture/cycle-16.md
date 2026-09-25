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

> **How this companion came to be.** No `product-architecture` run opened it. The PM opened it on
> 2026-09-25 with a § 3.1 on QC-4's layer-4 check (`nozoki@41915e6`); a `companion-self-answer` run
> answering `docs/fdr_open_issues.md` § 2.2 appended § 2.1 in the Principal PM's posture
> (`nozoki@9cfb727`); § 3.1 was answered in the owner's seat (`nozoki@fcd7ac5`). The
> `product-architecture` run of 2026-09-25 folded § 3.1 into NFDR v18 and dropped it — the companion
> as it stood is `docs/trail/architecture/cycle-15.md`. One item stays: § 2.1, whose draft that run
> wrote into QC-6 under the SDD's own move (NFDR RN-29), and whose slot is the owner's.

---

## 1. Open issues — questions with no answer yet

None.

## 2. Choices to confirm — the Principal Architect drafted a best-effort answer; confirm or override

### 2.1 QC-6 is re-derived on SDD v20 § 3 `fs-reader` — the canonical form taken inside the grant only, names compared as spelled outside it, and three spellings refused although they may lead in

- **Lands in:** `nfdr.md` QC-6 — the obligation, its *verified by* and its trace tag (§ 1.1).
  § 10's QC-6 row names commands only and did not move.
- **Drafted into the records:** QC-6 at v18 states the check as `docs/SDD.md` § 3 `fs-reader`
  defines it at v20 (`:L322`): after percent-decoding, position by position from the granted
  folder; at every position inside the grant the canonical form is taken, symlinks resolved; at a
  position outside it nothing is read — no `lstat`, no `realpath` — and names are compared as
  spelled, the walk re-entering the grant only on the folder's own name met from its parent
  position, as spelled or in another letter case where the folder is not the root of its volume and
  that volume ignores letter case (both read from the folder itself), and as spelled wherever it
  cannot be sure; three spellings are refused as outside although they may lead in — more than one
  level out and back in another case, a Unicode-normalization difference, a granted folder that is
  its volume's root. The *verified by* keeps the two layer-2 commands and names the layer-1 cases
  for the four spellings `docs/fdr.md`'s example rows fix (`:L357-L358`; R-183 `:L87`, R-184
  `:L88`) beside the `..` and symlink-out cases — and says what the tree does: none of the four is
  written at `nozoki@69cc4b2` (`crates/nozoki-core/src/fs_reader.rs` `mod tests` holds the `..` and
  symlink cases), and the re-entry case goes red when it is, because the walk keeps one lexical
  position and answers `Outside` for `../<NAME>` (`:L170-L177`; measured at
  `docs/trail/sdd/cycle-15.md` § 5.1 on `nozoki@46bb275`, the crates unchanged since). That nothing
  is read outside the grant stays QC-35's, at layer 5. The trace adds ADR-0011, SDD § 4 C-D1 and
  § 9 TO-6, SRS FR-32 and NFR-16, FDR R-183 and R-184, and the owner's answer at
  `docs/trail/sdd/cycle-15.md` § 5.1. **Written under the SDD's move, not under an answer here:** a
  settled entry changes on a new upstream sentence or an owner's answer, and both exist — SDD v20
  § 3 (RN-71) and the owner's answer in the SDD's trail. RN-29 records the fold; this slot is what
  the item was opened for.
- **Rationale:** v17's QC-6 stated a fact its source no longer states. "On the canonical path,
  symlinks resolved and after decoding" was SDD § 3's wording at v13; at v20 the same row takes
  the canonical form only inside the grant and reads nothing at a position outside it, and § 4
  C-D1's *Violated by* names a canonicalizing `lstat` or `realpath` outside the grant as a forbidden
  read. Read as written, v17's QC-6 asked for the read C-D1 forbids and QC-35 excludes, and its two
  fixtures exercised none of the spellings the definition turns on. The FDR carries the definition
  as R-183 and R-184, confirmed in the owner's seat at `docs/trail/fdr/cycle-6.md` § 2.2. The move
  landed after v17 (`nozoki@4b9425b` above `nozoki@18250d6`), so no run of these records had read
  it; SDD RN-71 and FDR RN-34 each named QC-6 as owed, and the item that raised it here said a re-run
  re-deriving on its own is confirmed at no cost.
- **If overridden:** *Override back to v17's wording* — QC-6 disagrees with SDD v20 § 3, C-D1 and
  FDR R-183 / R-184 on one spelling: the change that builds the re-entry fails the obligation while
  meeting the SDD and the FDR, and the QA seat has no NFDR line to derive the three refused
  spellings' bar from. *Override the draft's detail* — a layer-1 case to add or drop, a trace to
  remove, the tree-state clause to cut — moves QC-6 at v19 under that answer and nothing else;
  § 10's row does not move either way.
- **Confirm or override:** confirm, with one addition — decided in the owner's seat by a
  `companion-self-answer` run; reasoning at `docs/trail/architecture/self_answer-19.md` § 2.1.
  The obligation, the trace and § 10's row stand as v18 holds them. The addition is to the
  *verified by*'s layer-1 list and its source only: `docs/fdr.md`'s example rows (`:L357-L358`)
  fix three of the four spellings, not four — the re-entry in two forms (`self → ../NOZOKI`
  ending `Cycle`, R-152; `up → ../NOZOKI/docs` resolving inside and read as its target, R-34,
  R-151), the multi-level return (`far`) and the volume root (`back`) — and the
  Unicode-normalization refusal has no example row, resting on R-184's second clause and SDD
  § 11 R-10. The list cites it there, and names both re-entry forms, both `Outside` on the walk
  at `nozoki@88b237f` (`crates/nozoki-core/src/fs_reader.rs:L211-L215`) until the change that
  builds the re-entry lands.

## 3. Raised from downstream — an item from a seat that did not write these records

None.
