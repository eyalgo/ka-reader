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

> **No `product-architecture` run wrote this file.** The PM opened it on 2026-10-01 from the records'
> own companion template, while re-reading the route after `select_file` was first built, because the
> NFDR is Settled and with no companion on disk a `product-architecture` re-run reads it as done and has
> nothing to act on. Its one item is in § 3; it pairs with `docs/SDD_open_issues.md` § 5.1, which asks
> the SDD the same question at C-R7 and C-I3.

---

## 1. Open issues — questions with no answer yet

None.

## 2. Choices to confirm — the Principal Architect drafted a best-effort answer; confirm or override

None.

## 3. Raised from downstream — an item from a seat that did not write these records

### 3.1 QC-2's verification and QC-24's staging read false while `read-a-file` is built across several changes
- **Raised by:** PM — 2026-10-01
- **Which record:** `nfdr.md` QC-2 (*verified by*) and QC-24
- **Tracked by:** `nozoki · nemawashi · 2026-10-01_a-file-reads-in-the-panel`
- **What it blocks:** nothing is blocked; two obligations state a verification and a staging rule the
  build does not meet today, so § 10's map reads as covering a command it does not exercise.
- **Where it shows:** QC-2 says `checks/read-only.sh <fixture>` prints `unchanged` "after every command
  the build exports"; `nozoki_select_file` is exported now, and the walk the script drives calls
  `list_tree` alone (`crates/nozoki-core/tests/walk.rs:L1-L6`). Until the walk drives `select_file`,
  QC-2 should name what holds the read: `cargo test --locked -p nozoki-bridge --test select_file` keeps
  `checks/fixtures/text/` byte-identical. QC-24 says "No listed function is exported before a slice
  lands it", and `select_file` is exported while § 6 S-2's highlighter and read-only bars are not yet
  met; it should follow whichever reading `docs/SDD_open_issues.md` § 5.1 settles for C-R7 — exported
  from the first change of the slice that builds it, or held until the slice is whole. The set-equality
  mechanism is unaffected.
- **If a document has to be written:** none — QC-2's *verified by*, QC-24, and their § 10 rows.
- **Answer:** <the owner fills this in>

**How it closes.** `product-architecture` folds it on its next run like any other item here.
