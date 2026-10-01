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
> own companion template, while re-reading the route after the read-only walk began reading every file
> it lists. The NFDR is Settled, and with no companion on disk a `product-architecture` re-run reads it
> as done and has nothing to act on. Its one item is in § 3.

---

## 1. Open issues — questions with no answer yet

None.

## 2. Choices to confirm — the Principal Architect drafted a best-effort answer; confirm or override

None.

## 3. Raised from downstream — an item from a seat that did not write these records

### 3.1 QC-14 does not say whether a `nozoki-core` test target that compiles harness source counts as "a dependency of `nozoki-core`"
- **Raised by:** PM — 2026-10-01
- **Which record:** `nfdr.md` QC-14 and its § 10 row (QC-9 – QC-12, QC-14)
- **Tracked by:** `nozoki · nemawashi · 2026-10-01_the-tree-is-checked-for-its-shape`
- **What it blocks:** `checks/structure.sh` is not written yet, and it is QC-14's layer-6 check. As
  QC-14 reads now, the script could either fail the tree on the site below or pass it, and nothing in
  the records says which is right.
- **Where it shows:** QC-14 says `checks/` is "**never a dependency** of `nozoki-core`, `nozoki-bridge`
  or `nozoki-mac`" (`docs/nfdr.md:L275-L276`), with no shipped/unshipped distinction. SDD § 3
  `read-only-harness` narrows what it must not own to "Being a dependency of any shipped unit"
  (`docs/SDD.md:L332`). The tree now has a site where the two readings part. `nozoki-core`'s own
  Cargo test target compiles the harness's walk in with `#[path = "../../../checks/walk.rs"] mod walk;`
  (`crates/nozoki-core/tests/walk.rs:L6-L7`). It is test-only: the shipped library, the manifests and
  the bundle are unchanged, and `cargo tree -p nozoki-bridge` still names no `checks` crate. Under the
  SDD's reading the site conforms. Under QC-14's words it may not. QC-14 should say which, and its
  § 10 row should say whether `structure.sh` reads a `nozoki-core` test target's `#[path]` into
  `checks/` as a dependency.
- **If a document has to be written:** none. QC-14's first clause, and the § 10 row that names
  `checks/structure.sh` for it.
- **Answer:** <the owner fills this in>

**How it closes.** `product-architecture` folds it on its next run like any other item here.
