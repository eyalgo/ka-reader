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
- **Tracked by:** `ka-reader · nemawashi · 2026-09-15_open-a-folder`
- **What it blocks:** QC-25's *verified by*. Its second half, "`APP_SANDBOX_CONTAINER_ID` is set in
  the launched bundle's environment" (`nfdr.md:L199-L204`), fails on the built ad-hoc bundle even
  though the kernel enforces its sandbox. It also fails on the main process of a team-signed
  sandboxed app. The evidence is in `SDD_open_issues.md` § 5.1.
- **Where it shows:** `nfdr.md:L202-L203` (QC-25 *verified by*); `nfdr.md:L595` (the § 10 row);
  `adr/0008-…:L28` and `:L60`, which hold the marker as "an observed macOS behaviour".
- **If a document has to be written:** none. The SDD owns the observable (C-I3), and its item is
  `SDD_open_issues.md` § 5.1. QC-25 and ADR-0008 follow whatever that item settles. This item is here
  so that neither record keeps a check the SDD has retired.
- **Answer:** Answered in the owner's seat by a `companion-self-answer` run, 2026-09-19. The SDD
  item this one waited on is settled: `docs/SDD.md` v6 § 4 C-I3 states the new observable, with
  § 10 RC-1 and RN-45 behind it (`ka-reader@b3439e8`). Two things follow, one per record.
  **(1) QC-25 is re-derived from C-I3 as it reads now**, under the SDD's own rule that the § 4
  statement wins and the NFDR entry is re-derived (`docs/SDD.md:L408`). Its *verified by* drops the
  `APP_SANDBOX_CONTAINER_ID` clause and carries C-I3's probe whole. `checks/bundle.sh` checks the
  entitlement list, launches the bundle and takes the pid of the main process it started. It fails
  unless the operating system reports that pid sandboxed, with an out-of-grant file read and an
  outbound connection both denied. The same binary built with no entitlements must fail the probe.
  The build also fails when `sandbox_check` is missing or returns an error, or when the pid count
  is not one. A container directory that already exists is never evidence. The trace gains
  `SDD § 10 RC-1`. The § 10 row names the script and not the marker, so it stands. QC-25 asserts
  nothing about a GitHub-hosted runner: that is the SDD's open question, settled by the probe's
  first CI run.
  **(2) ADR-0008 is superseded, not edited.** The marker sits in its § Decision (`:L28`) and in the
  platform fact its last paragraph rests on (`:L59-L62`), so this answer contradicts an accepted
  record, and that lands as a new record. ADR-0010 restates ADR-0008's decision whole — the
  harness over `ka-reader-core`, the probe on every build from the first — with C-I3's observable. It
  rules out the environment marker and the container directory, each with RC-1's measurement. It
  names what it rests on: `sandbox_check` is exported by libSystem and is not declared in the
  SDK's `sandbox.h`, no vendor page documents it, and the negative control is what turns a silent
  change in it into a red build. ADR-0008's Status line becomes `Superseded by ADR-0010` and
  nothing else in that file moves. The index follows, and the NFDR's traces to ADR-0008 are
  re-pointed in place. ADR-0001, ADR-0003 and ADR-0007 name ADR-0008 and stand as written; its
  Status line forwards their reader. This answer means a reversal of the record's mechanism, not a
  correction to be edited into it, and says so here so the fold does not have to guess between
  the two. Reasoning: `docs/trail/architecture/self_answer-8.md` § 3.1.

### 3.2 QC-23's string-equality check cannot pass until the `<asset-scheme>` form is settled
- **Raised by:** PM — 2026-09-19
- **Which record:** NFDR § 1 QC-23
- **Tracked by:** `ka-reader · nemawashi · 2026-09-15_open-a-folder`
- **What it blocks:** QC-23 says the CSP "equals" a string that contains `<asset-scheme>`, which is
  "the origin form settled for `ka-reader-asset`" (`nfdr.md:L188-L192`). It is verified by "string
  equality against the entry". The SDD settles that form only in the first Markdown slice
  (`SDD.md:L2504-L2507`, third Open Question). Until then no build can pass QC-23 as written. The
  first build's config test asserts equality with the string minus the asset scheme, plus the
  entry's prohibitions (`crates/ka-reader-app/tests/config.rs:181-182`), and nothing in the NFDR states
  that as the check in force.
- **Where it shows:** QC-23 *verified by* (`nfdr.md:L192`).
- **If a document has to be written:** none. QC-23's check needs to say what it verifies before the
  asset origin is settled.
- **Answer:** Answered in the owner's seat by a `companion-self-answer` run, 2026-09-19. QC-23's
  check is stated in two states, keyed on what `docs/SDD.md` § 4 C-R7 carries, so that it is in
  force at every build and needs no revision on the day the form is found.
  **While C-R7 carries the `<asset-scheme>` placeholder**, the declared policy equals C-R7's
  string with that token absent — `default-src 'none'; script-src 'self'; style-src 'self';
  img-src 'self' data:; font-src 'self'` — and no directive admits `http:`, `https:`, `file:`,
  `asset:` or `*`. **From the SDD revision at which C-R7 carries the literal origin form**, the
  policy equals C-R7's string whole. Both are string equality in
  `cargo test --locked -p ka-reader-app --test config`.
  Three grounds. A policy with no asset source is narrower than C-R7's, and C-R7 is violated only
  by "any widening". No asset handler exists before the first Markdown slice, so nothing needs the
  source. The SDD itself places the full-string bar in that slice (`docs/SDD.md:L1185-L1188`).
  This is what the first build's test already asserts (`crates/ka-reader-app/tests/config.rs:L17`,
  `:L181-L187`), so no code moves. The entry names C-R7's state and no slice. A change that adds
  an asset source before C-R7 carries the form fails the first state's equality, which is the
  intended result. Once C-R7 carries the form, the next revision of this document re-derives
  QC-23 to the literal string and drops the first state.
  Not covered here, and the SDD's to settle: WKWebView accepting no origin form without a plugin
  (`docs/SDD.md` § 11 R-11), which would meet QC-24's *no plugin*. No record moves. ADR-0006
  already says the form is open until the first Markdown slice (`docs/adr/0006-…:L63-L66`).
  Reasoning: `docs/trail/architecture/self_answer-8.md` § 3.2.

### 3.3 QC-30 forbids environment variables, and the Tauri runtime the product links reads one
- **Raised by:** PM — 2026-09-19
- **Which record:** NFDR § 1 QC-30
- **Tracked by:** `ka-reader · nemawashi · 2026-09-15_open-a-folder`
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
- **Answer:** Answered in the owner's seat by a `companion-self-answer` run, 2026-09-19. **Yes:
  QC-30's boundary set covers what the shipped process reads, whichever crate reads it.** The
  floor QC-30 realizes speaks of "the product", and an adopter runs one process. So QC-30's "no
  argument vector, no environment variable" is false of the built product as written, and this is
  a correction of a statement measured false, not a new requirement. No upstream document makes
  the absolute claim: `docs/fdr.md` R-2 and `docs/SRS.md` FR-1 say "the only input the product
  requires", which still holds. QC-30 is restated in two halves.
  **(1) The product's own crates** — `ka-reader-core` and `ka-reader-app` — read no argument, no
  environment variable and no configuration file, and open no socket: `checks/structure.sh`, as
  now. "Any shipped crate" becomes "the product's own crates", because a dependency ships in the
  binary too and the phrase read both ways.
  **(2) The linked dependency tree** — every environment or argument read in the crates
  `cargo tree -p ka-reader-app` resolves for the macOS target is a named member of the boundary set,
  held in a reviewed list under `checks/`, one line per crate and name, each with what it changes.
  A scan of those crates' sources is diffed against the list, and a read not on it fails the build
  until the list change is reviewed as code in the same change, the way `checks/deps.allow` is
  (QC-26). It is a machine check because the primitives are enumerable, which is the floor's own
  test: measured on the resolved tree this run, 216 crates, 17 with a textual hit, several of them
  build-time only. The script and the list format are this document's realization, in the way
  RN-3's tools are. The first list names at least `TAURI_WEBVIEW_AUTOMATION`
  (`tauri-runtime-wry` 2.11.4 `src/lib.rs:4792`). This run also saw the argument vector captured
  by `tauri-utils` 2.9.3 `Env::default()` (`src/lib.rs:282`). The full enumeration is the fold's to
  measure, and this run does not claim one. The review gate at `development-design` stays for the
  trust assumption.
  **What the set does not reach, stated in the entry:** reads made by the operating system's own
  frameworks inside the process. They are the platform's, no lockfile names them, and the sandbox
  (QC-25) is what bounds them.
  **What follows in the same document:** QC-58 shares the rule and takes the same two halves — the
  product offers no configuration surface, and the linked tree's reads are the named list. QC-61
  argues that "QC-30 and QC-58 forbid `std::env::var` in any shipped crate, so an off-the-shelf
  logger fails `checks/structure.sh`"; a logger is a dependency, so that sentence is re-pointed to
  half (2) and to `checks/deps.allow`, and its conclusion stands. § 10 gains the row. No record
  moves: ADR-0001 binds QC-30 and its decision is untouched.
  Reasoning: `docs/trail/architecture/self_answer-8.md` § 3.3.

**How it closes.** `product-architecture` folds these items on its next run like any other item here.
