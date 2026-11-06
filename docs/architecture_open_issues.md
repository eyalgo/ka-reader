# Architecture open issues — ka-reader

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

> **No `product-architecture` run wrote this file.** A `companion-self-answer` run opened it on
> 2026-11-06, in the CPO's seat, while answering `docs/SDD_open_issues.md` item 2.3 — the SDD at
> v68 (§ 10 RC-8) cut `follow-the-file` out of `follow-the-folder` and renumbered S-6 – S-12 to
> S-7 – S-13, and the NFDR at v77 still points its live-refresh obligations at `SDD § 6 S-6` as
> `follow-the-folder`. `nfdr.md` is Settled at v77 and its companion was correctly deleted; it is
> re-opened because the SDD moved after v77 was authored (SDD v67 is the last version RN-87 names)
> and the records have no other channel: with no companion on disk a `product-architecture` re-run
> reads them as done and has nothing to act on. The reasoning is in
> `docs/trail/sdd/self_answer-76.md` § *Companions opened*.

---

## 1. Open issues — questions with no answer yet

None.

## 2. Choices to confirm — the Principal Architect drafted a best-effort answer; confirm or override

### 2.1 Live refresh is three SDD slices since v68, and the NFDR's live-refresh obligations still cite `follow-the-folder` as `SDD § 6 S-6` — a number that now names `follow-the-file`
- **Lands in:** `nfdr.md` QC-40, QC-46, QC-48 — their entries and their § 10 verification-map rows
- **Drafted into the records:** nothing — this run writes no document. Proposed, for the
  `product-architecture` run that folds this item, reading `docs/SDD.md` at v68 or later: (1) every
  live citation of `SDD § 6 S-6` that means `follow-the-folder` reads `S-8`, where that slug sits
  since SDD v68 (§ 10 RC-8: "S-6 – S-12 become S-7 – S-13; current references follow these numbers,
  earlier dated notes keep theirs") — by this run's read, at `ka-reader@0375085`: QC-40's entry
  (`docs/nfdr.md:L1499`), QC-46's trace (`:L1567`), QC-48's verified-by clause (`:L1617`) and trace
  (`:L1623`), the paragraph at `:L2353` (`§ 6 S-5–S-6`), and the three verification-map rows
  (`:L2946`, `:L2950`, `:L2952`); dated review notes keep their numbers. (2) Where the records say
  which slice first runs the displayed-file half of QC-48's scene, they name it: SDD v68 § 6 S-6
  `follow-the-file` carries the displayed-file scene — the open file's content updated in place, the
  gone state and its recovery, the reading position across SM-4 and the order of two `select_file`
  calls — and S-8 `follow-the-folder` re-walks it as regression inside the full churn. QC-40's
  built-bundle proof, QC-46's first complete-refresh figures and QC-48's full churn, marker and
  row-order migration stay `follow-the-folder`'s, as RC-8 § *Retained* says. Nothing else in the
  records moves: no obligation changes what it requires, and no ADR is touched (RC-8: "no ADR is
  owed").
- **Rationale:** *a fact in the records is now false, and something upstream moved that they have
  not seen.* `grep -n 'S-6\b' docs/nfdr.md` prints thirteen lines at v77; the eight named above are
  live entries and rows, each pairing the number with the slug `follow-the-folder`, and at SDD v68
  that number names `follow-the-file` — a slice whose bar holds none of the proofs these entries
  assign. A reader of QC-40 or QC-46 who follows the number lands on the open-file slice and reads
  the retention proof or the latency figures as owed there, and that slice is the one the product's
  next change delivers. `grep -c 'follow-the-file' docs/nfdr.md` → 0: the records have not seen the
  slice. The SDD is Draft at v68, owed a `product-sdd` fold for `docs/SDD_open_issues.md`; the run
  that folds this item reads it at the version it finds and says so in the entry's trace. The SDD's
  own § 3 `surfaces` row carries the same stale number once, and the SDD's companion item 2.3
  names it for that fold.
- **If overridden:** the eight pointers stay at S-6 and send every reader of the live-refresh
  obligations to the wrong slice, and `follow-the-file` stays unnamed in the records, so the
  displayed-file proofs are owed by name only to the slice that re-walks them.
- **Confirm or override:** confirm — with two additions the fold makes in the same pass, both facts SDD v68 made false and the draft did not name: (a) § 9's opening paragraph reads "the two slices in SDD § 6" and "the two scene commands"; since RC-8 live refresh is three slices and three scenes — the tree scene (`follow-the-tree`, S-5), the displayed-file scene (`follow-the-file`, S-6) and the full churn (`follow-the-folder`, S-8) — each entering the gate under QC-64 when its slice delivers, and no one scene's pass discharging another's; (b) QC-48's "This allowance continues through `follow-the-tree`" reads as continuing through `follow-the-file` and `first-public-release` too, ending only when `follow-the-folder` (S-8) is reached, as SDD § 3 `surfaces` and RC-8 § *Retained* hold. The SDD has since settled at v69 (`ka-reader@b10c7e9`) and moves no slice, so the fold reads v69. Reasoning: `docs/trail/architecture/self_answer-72.md` § 2.1.

## 3. Raised from downstream — an item from a seat that did not write these records

None.
