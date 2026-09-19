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

> **No `product-architecture` run opened this companion. The PM opened it on 2026-09-19, from a
> post-build review.** Both records are Settled and had no companion on disk. Without one, a
> `product-architecture` re-run would read them as done and find nothing to act on. The companion
> holds three § 3 items. Each is a place where the first built code shows that a record's
> verification cannot run the way the record states it.

---

## 3. Raised from downstream — an item from a seat that did not write these records

### 3.1 QC-25 and ADR-0008 prove the sandbox with an observable a sandboxed app's own process does not carry
- **Raised by:** PM — 2026-09-19
- **Which record:** NFDR § 1 QC-25 and its § 10 row; `adr/0008-harness-over-core-and-bundle-probe-from-first-build.md`
- **Tracked by:** `nozoki · nemawashi · 2026-09-15_open-a-folder`
- **What it blocks:** QC-25's *verified by*. Its second half, "`APP_SANDBOX_CONTAINER_ID` is set in
  the launched bundle's environment" (`nfdr.md:L199-L204`), fails on the built ad-hoc bundle even
  though the kernel enforces its sandbox. It also fails on the main process of a team-signed
  sandboxed app. The evidence is in `SDD_open_issues.md` § 5.1.
- **Where it shows:** `nfdr.md:L202-L203` (QC-25 *verified by*); `nfdr.md:L595` (the § 10 row);
  `adr/0008-…:L28` and `:L60`, which hold the marker as "an observed macOS behaviour".
- **If a document has to be written:** none. The SDD owns the observable (C-I3), and its item is
  `SDD_open_issues.md` § 5.1. QC-25 and ADR-0008 follow whatever that item settles. This item is here
  so that neither record keeps a check the SDD has retired.
- **Answer:** <the owner fills this in>

### 3.2 QC-23's string-equality check cannot pass until the `<asset-scheme>` form is settled
- **Raised by:** PM — 2026-09-19
- **Which record:** NFDR § 1 QC-23
- **Tracked by:** `nozoki · nemawashi · 2026-09-15_open-a-folder`
- **What it blocks:** QC-23 says the CSP "equals" a string that contains `<asset-scheme>`, which is
  "the origin form settled for `nozoki-asset`" (`nfdr.md:L188-L192`). It is verified by "string
  equality against the entry". The SDD settles that form only in the first Markdown slice
  (`SDD.md:L2504-L2507`, third Open Question). Until then no build can pass QC-23 as written. The
  first build's config test asserts equality with the string minus the asset scheme, plus the
  entry's prohibitions (`crates/nozoki-app/tests/config.rs:181-182`), and nothing in the NFDR states
  that as the check in force.
- **Where it shows:** QC-23 *verified by* (`nfdr.md:L192`).
- **If a document has to be written:** none. QC-23's check needs to say what it verifies before the
  asset origin is settled.
- **Answer:** <the owner fills this in>

### 3.3 QC-30 forbids environment variables, and the Tauri runtime the product links reads one
- **Raised by:** PM — 2026-09-19
- **Which record:** NFDR § 1 QC-30
- **Tracked by:** `nozoki · nemawashi · 2026-09-15_open-a-folder`
- **What it blocks:** QC-30 says the product has "no other entry point — no argument vector, no
  environment variable" (`nfdr.md:L238-L241`). Its check, `checks/structure.sh`, scans "any shipped
  crate" for `std::env::var` (`nfdr.md:L242-L243`). The resolved `tauri-runtime-wry` 2.11.4
  (`Cargo.lock:3209-3210`) reads `std::env::var("TAURI_WEBVIEW_AUTOMATION")`
  (`tauri-runtime-wry-2.11.4/src/lib.rs:L4792`, in the Cargo registry). A dependency falls outside a
  scan of shipped crates, so the check as stated would pass, and the NFDR does not say whether a dependency's read is an entry point QC-30
  covers.
- **Where it shows:** QC-30's boundary set and *verified by* (`nfdr.md:L238-L244`).
- **If a document has to be written:** none. QC-30 needs to say whether the boundary set covers
  environment reads by linked dependencies, and if it does, what verifies them.
- **Answer:** <the owner fills this in>

**How it closes.** `product-architecture` folds these items on its next run like any other item here.
