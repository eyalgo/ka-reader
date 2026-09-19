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
> post-build review.** Both records are Settled at NFDR v7 and had no companion on disk. Without one,
> a `product-architecture` re-run would read them as done and find nothing to act on. The companion
> holds two § 3 items, each a check the first built code shows the records state wider or narrower
> than it can run: QC-24's command list, and QC-61's `set_logger` scope.

---

## 3. Raised from downstream — an item from a seat that did not write these records

### 3.1 QC-24's set equality names the whole command list, and the tree's check holds the commands built so far
- **Raised by:** PM — 2026-09-19
- **Which record:** NFDR § 1 QC-24 and its § 10 row
- **Tracked by:** `nozoki · nemawashi · 2026-09-15_open-a-folder`
- **What it blocks:** Nothing fails today, because the check in the tree is not the check the entry
  states. QC-24 is verified by "set equality against the list" (`nfdr.md:L205-L209`), and the list is
  `open_folder`, `list_tree`, `select_file`, `open_relative_link`, `set_theme`, with three more
  where built, plus the asset scheme. Read literally, no build before the last slice passes it.
- **Where it shows:**
  - QC-24 (`nfdr.md:L205-L209`) and its § 10 row (`nfdr.md:L641`).
  - The tree at `nozoki@1741429`: `crates/nozoki-app/capabilities/main.json:L5` grants
    `allow-open-folder` and `allow-list-tree`, and `crates/nozoki-app/tests/config.rs:L231` holds
    set equality against those two. No asset scheme is granted.
  - QC-23 (`nfdr.md:L188-L200`) already states the same kind of staging for C-R7's CSP half, keyed on
    what C-R7 carries. QC-24 has no counterpart for the command half.
  - The list comes from `docs/SDD.md` § 4 C-R7 and § 3 SM-4, which state it as "exactly" the whole
    list, while the SDD's S-2 bar adds `select_file` to the grant in the slice that builds it
    (`SDD.md:L1117`). That side is `SDD_open_issues.md` § 5.1.
- **If a document has to be written:** none. What is owed is QC-24's check stated for the build in
  hand, re-derived from whatever C-R7 settles in `SDD_open_issues.md` § 5.1. The PM's lean is set
  equality against the commands the built slices register, plus the asset scheme once its form is
  settled.
- **Answer:** <the owner fills this in>

### 3.2 QC-61's `structure.sh` check reaches test binaries that must install a logger
- **Raised by:** PM — 2026-09-19
- **Which record:** NFDR § 1 QC-61 and its § 10 row
- **Tracked by:** `nozoki · nemawashi · 2026-09-15_open-a-folder`
- **What it blocks:** `checks/structure.sh` as QC-61 states it. The check is "`log::set_logger` and
  `log::set_boxed_logger` appear only in `nozoki-app`" (`nfdr.md:L480-L481`), and nothing scopes it
  to shipped sources. A script that follows the words fails on the tree as it stands.
- **Where it shows:**
  - QC-61 *verified by* (`nfdr.md:L478-L481`) and its § 10 row (`nfdr.md:L668`).
  - The tree at `nozoki@1741429`: `grep -rn set_logger crates/` outside `crates/nozoki-app/src/`
    prints `crates/nozoki-core/tests/failure_log.rs:52` and
    `crates/nozoki-core/tests/failure_log_kinds.rs:61`. Each installs a capturing logger in its own
    test binary to observe the warn line `nozoki-core` emits for a failed read. The logger is
    process-global, so a test that asserts on log output has to install one.
  - The property QC-61 protects is about the shipped process: "installed once at startup in
    `nozoki-app`, the composition root" (`nfdr.md:L467-L468`). A test binary is not shipped.
- **If a document has to be written:** none. What is owed is the check's scope stated in the entry.
  The PM's lean is: `set_logger` / `set_boxed_logger` appear only under `crates/nozoki-app/src/`
  among shipped sources, and test targets under `crates/*/tests/` are outside the check.
- **Answer:** <the owner fills this in>

**How it closes.** `product-architecture` folds it on its next run like any other item here.
