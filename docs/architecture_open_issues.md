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
> own companion template, after `checks/entry-points.sh`, `checks/entry-points.allow` and the suite
> `checks/tests/test_entry_points.sh` landed (`nozoki@b158052`). Two NFDR statements no longer match
> the tree. The NFDR is Settled, and with no companion on disk a `product-architecture` re-run reads it
> as done and has nothing to act on. Its one item is in § 3.

---

## 1. Open issues — questions with no answer yet

None.

## 2. Choices to confirm — the Principal Architect drafted a best-effort answer; confirm or override

None.

## 3. Raised from downstream — an item from a seat that did not write these records

### 3.1 § 10's linked-tree row omits the suite `checks/entry-points.sh` now has, and § 9 counts seven suites where eight are on steps
- **Raised by:** PM — 2026-10-03
- **Which record:** `nfdr.md` § 10, the QC-30 / QC-58 linked-tree row; § 9's `checks/tests/` bullet
- **Tracked by:** `nozoki · nemawashi · 2026-10-01_the-tree-is-checked-for-its-shape`
- **What it blocks:** nothing is blocked. A rule of § 10's own reads broken, and § 9's pinned count is
  owed the re-measurement it names.
- **Where it shows:** § 10 says a row naming a script that has a suite names the suite beside it as
  `(suite test_<name>.sh)` (`docs/nfdr.md:L1233-L1235`). `checks/tests/test_entry_points.sh` exists
  and runs as its own CI step, `Entry-points check suite` (`.github/workflows/ci.yml:L36-L37`;
  `grep -c 'checks/tests/test_entry_points.sh' .github/workflows/ci.yml` → `1`). The row reads
  "`checks/entry-points.sh` against `checks/entry-points.allow`" with no suite tag
  (`docs/nfdr.md:L1273`). § 9 says "Seven suites are in the tree" and lists them
  (`docs/nfdr.md:L1065-L1071`); `ls checks/tests` now lists eight `test_*.sh`, the eighth
  `test_entry_points.sh`. § 9 calls an eighth suite "a re-measurement of this sentence and not a
  contradiction of it" (`:L1072-L1073`), so the count and its step lines are owed that re-measurement.
- **If a document has to be written:** none. § 10's QC-30 / QC-58 linked-tree row, and § 9's count.
- **Answer:** <the owner fills this in>

**How it closes.** `product-architecture` folds it on its next run like any other item here.
