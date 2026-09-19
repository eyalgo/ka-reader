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
- **Answer:** Answered in the owner's seat by a `companion-self-answer` run, 2026-09-19. **The
  PM's lean is confirmed, with additions, and the item no longer waits on anything.**
  `docs/SDD_open_issues.md` § 5.1 was answered (`nozoki@d9ffe66`) and folded (`nozoki@c1f8a20`).
  `docs/SDD.md` is Settled at v7, and § 4 C-R7 (`docs/SDD.md:L483-L503`) states the staged grant.
  The SDD's own rule is that "the § 4 statement wins and the NFDR entry is re-derived"
  (`docs/SDD.md:L408`), so QC-24 is re-derived from C-R7 as it reads at v7. That is transcription,
  not a call.

  **What QC-24 states.** A build's capability file grants the renderer exactly the commands the
  host registers — the commands its landed slices built — and no plugin. That set is always inside
  the closed list `docs/SDD.md` § 3 SM-4 names (`docs/SDD.md:L352`), and from `v1.0.0` it is that
  list whole. The asset scheme enters the grant in the slice that settles its origin form, keyed
  on C-R7's state the way QC-23 is: while C-R7 carries the `<asset-scheme>` placeholder, no asset
  scheme is granted. QC-24 says when the scheme enters the grant and not where the grant is
  written, because where is part of the SDD's open question (`docs/SDD.md:L2644`).

  **What verifies it.** `cargo test --locked -p nozoki-app --test config`, holding four things:
  set equality between the commands the capability file grants and the commands the host
  registers; that set inside SM-4's list; no plugin; and no asset scheme while the placeholder
  stands. The test reads the registered set and never a hand-kept copy of it, which is C-R7's own
  sentence. One clause is this answer's own and goes beyond C-R7's words: a registered set the
  test cannot read fails the test, the way QC-30's tail fails on a crate it cannot scan. From
  `v1.0.0` the whole list is held by QC-59's pin, which already reads the capability file's
  command list.

  **What it does not cover, carried from C-R7 so it is not read as coverage.** Before `v1.0.0`, a
  change that stops registering a command an earlier slice built passes, because the grant and the
  registration move together. Only that slice's own bar holds the command until the pin exists.

  **What a delivery reader needs and no entry states.** The test as built holds two hand-kept
  constants (`crates/nozoki-app/tests/config.rs:L228`, `:L231`, at `nozoki@1741429`). It passes
  today and does not yet meet the re-derived tail. The entry follows the SDD and the test follows
  the entry, which is how RN-18 read QC-25 against `checks/bundle.sh`. How the test comes to read
  the registered set is the delivery tier's to plan (`docs/SDD.md` § SDD Review Notes RN-47).

  **What does not move.** § 10's row for QC-24 (`nfdr.md:L641`) names the command and not the
  mechanism, so it stands. No record moves: no ADR states a whole-list grant, and ADR-0002's "the
  closed command list the host registers"
  (`docs/adr/0002-tauri-2-rust-host-wkwebview-renderer.md:L45`) holds under the staged grant. QC-1,
  QC-34 and QC-59 read QC-24 and stay true. Reasoning:
  `docs/trail/architecture/self_answer-9.md` § 3.1.

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
- **Answer:** Answered in the owner's seat by a `companion-self-answer` run, 2026-09-19. **The
  PM's lean is confirmed, with one addition: the scope belongs to `checks/structure.sh`, not to
  QC-61's rule alone.**

  **QC-61.** `log::set_logger` and `log::set_boxed_logger` appear only under
  `crates/nozoki-app/src/`, and test targets under `crates/*/tests/` are outside the rule. The
  obligation clause does not move. The property is "installed once at startup in `nozoki-app`, the
  composition root" (`nfdr.md:L467-L468`), which is about the shipped process. Cargo compiles each
  file under `tests/` "as a separate crate"
  (https://doc.rust-lang.org/cargo/reference/cargo-targets.html, read 2026-09-19), so a logger
  installed there is never in the process an adopter runs. `set_logger` sets "the global logger"
  and "may only be called once in the lifetime of a program"
  (https://docs.rs/log/latest/log/fn.set_logger.html, read 2026-09-19), so a test that asserts on
  `nozoki-core`'s warn line can observe it only by installing a logger in its own binary.
  "`nozoki-core` … initializes nothing" stays true of the library:
  `grep -rn set_logger crates/nozoki-core/src/` prints nothing at `nozoki@1741429`.

  **The addition.** The same script carries other rules that say "in `nozoki-core`", "in
  `nozoki-app`" or "in the product's own crates" and state no scope. The tree at `nozoki@1741429`
  holds a test-target site against each:
  - QC-2's *no write API in `nozoki-core` outside `own-state`* —
    `crates/nozoki-core/tests/common/mod.rs:L57` (`fs::write`, building a fixture).
  - QC-9's *`nozoki-core` must not import `std::process`*, the rule QC-7's tail shares —
    `crates/nozoki-core/tests/common/mod.rs:L11`.
  - QC-13's *`nozoki-app` must not import `std::fs` outside its log module* —
    `crates/nozoki-app/tests/config.rs:L11`, the test QC-23 and QC-24 name.
  - QC-30 half (1)'s *no `std::env::args` in the product's own crates* —
    `crates/nozoki-core/tests/walk.rs:L66`, the driver `checks/read-only.sh` runs, which has to
    read its fixture argument.

  Each property is about shipped code, as QC-61's is. Scoping QC-61 alone would leave a reader to
  infer that the other rules do reach test targets. So the scope is stated once, where § 9
  describes the script (`nfdr.md:L598`): `checks/structure.sh`'s rules read the product crates'
  sources outside `crates/*/tests/`. The one rule that reads exactly that path — no
  `CARGO_BIN_EXE_` reference under `crates/*/tests/` — stays as it is. QC-61's tail carries the
  scope in words, because the item asked it of that entry. Whether the other tails repeat it or
  point at § 9 is the fold's drafting.

  **Not covered, named.** (1) A `#[cfg(test)]` module inside `src/` stays inside every rule. The
  tree holds no such site that breaks one, so nothing is decided for it: a layer-1 test that needs
  a write or a logger sits under `tests/` until a site shows otherwise. (2)
  `crates/nozoki-app/build.rs`, and any later `benches/` or `examples/`, are not excluded. No site
  in the tree needs them to be. (3) Shipped code that pulls in a file from `tests/` through a
  `#[path]` attribute would escape the rules. No grep rule is added for it. It is a review catch
  at `development-design`.

  **What does not move.** § 10's row for QC-61 (`nfdr.md:L668`) names the scripts and stands. No
  record moves. No `QC` is added. `checks/structure.sh` is not in the tree yet (`ls checks/`), so
  no script changes; the first one written follows the entry as it then reads. Reasoning:
  `docs/trail/architecture/self_answer-9.md` § 3.2.

**How it closes.** `product-architecture` folds it on its next run like any other item here.
