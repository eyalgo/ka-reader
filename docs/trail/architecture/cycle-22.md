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
- **Answer:** The site conforms, and `checks/structure.sh` does not read a test target's `#[path]`
  into `checks/` as a dependency. QC-14's "never a dependency of `nozoki-core`, `nozoki-bridge` or
  `nozoki-mac`" means of each unit **as it ships** — the `nozoki-core` library, the `nozoki-bridge`
  static library, the `nozoki-mac` executable — and never of a test target declared in one of their
  manifests. Three grounds. (1) Both sources QC-14 traces to already carry the qualifier: ADR-0016
  "never a dependency of a shipped unit" (`docs/adr/0016-physical-unit-set-core-bridge-mac-checks.md:L40-L41`)
  and SDD § 3 `read-only-harness` "Being a dependency of any shipped unit" (`docs/SDD.md:L332`);
  QC-14 dropped it in transcription, and the entry is the copy. (2) Cargo compiles each file under
  `tests/` "as a separate crate", which "can use the public API of the package's library"
  (https://doc.rust-lang.org/cargo/reference/cargo-targets.html, re-read 2026-10-01). So
  `crates/nozoki-core/tests/walk.rs` is a crate that imports `nozoki-core`, and `checks/walk.rs`,
  compiled into it, imports only `nozoki_core`'s public items (`checks/walk.rs:L20`). That is the
  direction QC-14's first clause allows ("`checks/` may import `nozoki-core`"), and the library
  compiles no file of `checks/` (`cargo tree --offline --locked -p nozoki-bridge | grep -ci checks`
  → `0`, 2026-10-01). (3) § 9's scope bullet already keeps `crates/*/tests/` out of every rule of
  `structure.sh`, "every other rule of the script alike" (`docs/nfdr.md:L1001-L1016`), and QC-14's
  rule is one of them. **The fold:** QC-14's first clause says "a dependency of any shipped unit —"
  and names the three units as shipped artifacts, tracing to ADR-0016 and SDD § 3 as it does now.
  The § 10 row needs no new command. No `QC` is added. **Not covered, and named so it is not read as
  coverage:** a `#[path]` or `include!` from a shipped source under `src/` into `checks/` would make
  `checks/` a dependency of a shipped unit and break QC-14. No such site exists (`grep -rn '#\[path'
  crates/` finds this test target and two `#[cfg(test)]` sites into `tests/common/`), so no grep rule
  is owed for it until one occurs. Reasoning: `docs/trail/architecture/self_answer-26.md` § 3.1.

**How it closes.** `product-architecture` folds it on its next run like any other item here.
