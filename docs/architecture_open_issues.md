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

> **No `product-architecture` run wrote this file.** A `companion-self-answer` run opened it on
> 2026-10-04 from the records' own companion template, while answering `docs/SDD_open_issues.md`
> § 5.1 in the CTO's seat. That answer moves the bound of the SDD's config-named-path item, and
> `docs/nfdr.md` repeats the old bound in two entries. The records are Settled, and with no companion
> on disk a `product-architecture` re-run reads them as done and has nothing to act on. Its one item
> is § 2.1. Nothing was drafted into the records: the run that opened this file does not write them.
> The reasoning is in `docs/trail/sdd/self_answer-39.md`.

---

## 1. Open issues — questions with no answer yet

None.

## 2. Choices to confirm — the Principal Architect drafted a best-effort answer; confirm or override

### 2.1 QC-6 and QC-35 repeat a bound on the config-named-path item that the SDD is about to move
- **Lands in:** `nfdr.md` QC-6 and QC-35
- **Drafted into the records:** nothing. This is a proposed change, raised by the run named above.
  Both entries say the SDD's config-named-path item is "settled no later than the build in which
  `mac-shell` first calls `nozoki_read_git`" (QC-6, `docs/nfdr.md:L248-L249`; QC-35,
  `docs/nfdr.md:L938-L940`, both read at `nozoki@78e823a`). The proposal: each entry states the
  bound as the SDD's *Open Questions* item states it after the fold, and QC-6's pin "§ 11 R-16 as
  it reads at v31" is re-pinned to the SDD version that carries the new bound. Nothing else in
  either entry moves. What is not covered, and why, stays as written.
- **Rationale:** The NFDR derives this bound from the SDD and does not set it. The owner chose on
  2026-10-04 to move it (`docs/SDD_open_issues.md` § 5.1, *The route the owner chose*, at
  `nozoki@78e823a`). The answer written into that item on 2026-10-04 sets the new bound: the item is
  settled in `see-git-status` before the slice is reached, and the build in which the shell first
  calls the export no longer bounds it. A later change reads QC-6 and QC-35 to learn what its review
  must hold. If they keep the old bound, the build that first calls `nozoki_read_git` is still
  refused by the NFDR after the SDD has stopped refusing it.
  **One doubt, stated.** When this item was raised the SDD still read v31, and the two entries
  agreed with it. The change is owed only once `product-sdd` has folded § 5.1. If the SDD still
  states the old bound when this item is reached, there is nothing to change yet, and the item
  should stay open and not be closed as done.
- **If overridden:** QC-6 and QC-35 keep the old bound. The two documents then disagree on which
  build the item must be settled by. The SDD's § 4 opening note gives the direction: where the two
  disagree the SDD's statement wins and the NFDR entry is re-derived (`docs/SDD.md:L513-L520`).
  No ADR is superseded either way: the bound is a date for settling an open question, not a
  decision in the log.
- **Confirm or override:** <"confirm", or "override: <what to do instead>">

## 3. Raised from downstream — an item from a seat that did not write these records

None.
