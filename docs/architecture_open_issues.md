# Architecture open issues — KA-Reader

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

### 2.1 QC-15's *verified by* cites four unpinned lines of the scan and its suite, and at `ka-reader@c35081a` each lands on a different passage

> Raised by `companion-self-answer`, answering § 3.1 on 2026-10-23. No producing run wrote this item.
> Reading QC-15's tail beside QC-11's showed the same defect § 3.1 corrects there: unpinned line
> locators into `checks/structure.sh` that the scan's 2026-10-22 re-wrap and its v1.6.0 moved.
> § 2 read "None." when that run reached it; the `product-architecture` fold of 2026-10-23 removed
> that line.

- **Lands in:** `nfdr.md` QC-15
- **Drafted into the records:** nothing. The records are not written by this run. The proposed call:
  QC-15's tail re-pins its four unpinned locators to a named commit, as RN-71 did for QC-2's.
- **Rationale:** QC-15's *verified by* pins its first two locators (`checks/structure.sh:L77-L80`,
  `:L1161`, at `ka-reader@48308ff`) and then cites four with no commit. They are
  `checks/tests/test_structure.sh:L961` and `:L931` for the exemption's two suite cases, and
  `checks/structure.sh:L266-L267` (*GAPS THE RULES ABOVE DO NOT CLOSE*, the `Path`-method gap) and
  `:L253-L256` (the two `git-reader` parts not held). At `48308ff` the scan's two locators are
  right. At `c35081a` they land in the QC-17 adapter-construction row and the QC-2 write-API row.
  The passages are now at `:L341-L342` and `:L327-L330`, and the two cases are defined at
  `test_structure.sh:L988` and `:L958`. What the tail says is still true: the scan's *WHAT IS NOT
  HELD* still names both parts as review at `development-design`. Only the pointers are false, and
  a reader following one at `HEAD` reads the wrong rule.
- **If overridden:** QC-15 keeps the four locators, read as inheriting the `48308ff` pin. The cost
  is a reader at `HEAD` reaching the QC-17 and QC-2 rows. Nothing else moves.
- **Confirm or override:** <"confirm", or "override: <what to do instead>">

## 3. Raised from downstream — an item from a seat that did not write these records

None.

**How it closes.** `product-architecture` folds it on its next run like any other item here.
