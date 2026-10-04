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

> **No `product-architecture` run wrote this file.** The PM opened it on 2026-10-04 from the records'
> own companion template. The bridge now runs the config search-path switch, holds its test, and
> exports `nozoki_read_git`, and `checks/view.sh` holds the `nm` transport read (`nozoki@392177d`). Two
> NFDR entries still say these are not in the tree. The records are Settled, and with no companion on
> disk a `product-architecture` re-run reads them as done and has nothing to act on. Its two items are
> in § 3.

---

## 1. Open issues — questions with no answer yet

None.

## 2. Choices to confirm — the Principal Architect drafted a best-effort answer; confirm or override

None.

## 3. Raised from downstream — an item from a seat that did not write these records

### 3.1 QC-3 says the `nm` read is not in `checks/view.sh` and its gate is still `development-design`
- **Raised by:** PM — 2026-10-04
- **Which record:** `nfdr.md` § 1.1, QC-3
- **Tracked by:** `nozoki · nemawashi · 2026-10-02_git-says-what-changed`
- **What it blocks:** nothing fails. A later change reads QC-3 to learn what holds the transport
  claim, and finds a review gate where a script now runs on every push.
- **Where it shows:** QC-3 (`docs/nfdr.md:L156-L159`): "The read is not in the script at
  `nozoki@8edec4f` … and no bridge function reaches `git-reader` at that commit. The build that first
  exports one owes the read, and until that build its gate is `development-design`". That build has
  landed: `nozoki_read_git` is exported (`crates/nozoki-bridge/src/exports.rs:L105`). The read is in
  the script (`checks/view.sh:L379`), with its red cases in `checks/tests/test_view.sh:L62-L64`, and
  CI runs both after `nozoki-mac/assemble.sh` (`.github/workflows/ci.yml:L41`, `:L51`, `:L54`). The
  release executable holds no `nozoki_read_git` symbol until a Swift caller links it, so the read has
  not yet met a build with the export linked in. The likely fold: the read is in the script from
  that build, and its gate is the script.
- **If a document has to be written:** none. QC-3's sentence in `nfdr.md`.
- **Answer:** <the owner fills this in>

### 3.2 QC-17 says the search-path switch and its test are not in the tree; both are
- **Raised by:** PM — 2026-10-04
- **Which record:** `nfdr.md` § 1.3, QC-17
- **Tracked by:** `nozoki · nemawashi · 2026-10-02_git-says-what-changed`
- **What it blocks:** nothing fails. The entry's gate reads "until that change the gate is
  `development-design`", and that change has landed.
- **Where it shows:** QC-17 (`docs/nfdr.md:L483-L486`): "The switch and its test are not in the tree at
  `nozoki@8edec4f`. They land in the change that wires the libgit2 adapter in the bridge". The switch is
  `crates/nozoki-bridge/src/machine_config.rs`, and its read-back is
  `crates/nozoki-bridge/tests/search_path.rs:L36` (`test_the_switch_against_the_real_libgit2`). That
  test makes its first arrival through a session's open, and so reads the four levels back after the
  production arrival. `cargo test --locked -p nozoki-bridge` is green at `nozoki@392177d`. The likely
  fold: name that test as the one that reads the four paths back, and the suite as the gate.
- **If a document has to be written:** none. QC-17's sentence in `nfdr.md`.
- **Answer:** <the owner fills this in>

**How it closes.** `product-architecture` folds it on its next run like any other item here.
