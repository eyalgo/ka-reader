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
> own companion template, after `checks/structure.sh` and its suite `checks/tests/test_structure.sh`
> landed (`nozoki@463acb9`). Four NFDR statements no longer match the tree. The NFDR is Settled, and
> with no companion on disk a `product-architecture` re-run reads it as done and has nothing to act on.
> Its four items are in § 3.

---

## 1. Open issues — questions with no answer yet

None.

## 2. Choices to confirm — the Principal Architect drafted a best-effort answer; confirm or override

None.

## 3. Raised from downstream — an item from a seat that did not write these records

### 3.1 The header ties a command's executability to its script's existence, and `checks/structure.sh` now exists holding a subset of its rules
- **Raised by:** PM — 2026-10-03
- **Which record:** `nfdr.md` header (`docs/nfdr.md:L35-L37`), and the § 10 rows that name `checks/structure.sh`
- **Tracked by:** `nozoki · nemawashi · 2026-10-01_the-tree-is-checked-for-its-shape`
- **What it blocks:** nothing is blocked. The header reads as coverage nothing provides.
- **Where it shows:** the header says each command "becomes executable in the change that lands its
  script, and until then the gate is `development-design` reading the entry" (`docs/nfdr.md:L35-L37`).
  `checks/structure.sh` is in the tree, and its own header names what it holds: "QC-9's unsafe,
  Apple-framework and process clauses, QC-36's Rust half, QC-15's two filesystem owners"
  (`checks/structure.sh:L2`). The § 10 rows naming it for QC-2, QC-10 – QC-12, QC-13's import set,
  QC-14, QC-17, QC-20, QC-30 / QC-58's first half and QC-61 (`docs/nfdr.md:L1201`, `:L1208-L1210`,
  `:L1213`, `:L1223`, `:L1245`) now read as executable gates under that sentence, and the script holds
  none of those rules. The script's own header names them "Not held", and it reads the NFDR's
  sentence its own way: "a rule is executable from the change that adds it here. Until then its gate
  is the design review" (`checks/structure.sh:L88-L93`). The correction owed is for the NFDR to say
  so: tie executability to each rule rather than to the script, so that every rule the script does
  not hold keeps the `development-design` gate.
- **If a document has to be written:** none. The `nfdr.md` header sentence, and § 9's
  `checks/structure.sh` bullet if it is where the rule-by-rule state belongs.
- **Answer:** <the owner fills this in>

### 3.2 § 10's rows naming `checks/structure.sh` omit its suite, and § 9 / § 10 count six suites where seven are on steps
- **Raised by:** PM — 2026-10-03
- **Which record:** `nfdr.md` § 10 preamble and rows; § 9's `checks/tests/` bullet
- **Tracked by:** `nozoki · nemawashi · 2026-10-01_the-tree-is-checked-for-its-shape`
- **What it blocks:** nothing is blocked. A rule of § 10's own reads broken.
- **Where it shows:** § 10 says a row naming a script that has a suite names the suite beside it as
  `(suite test_<name>.sh)` (`docs/nfdr.md:L1192-L1196`). `checks/tests/test_structure.sh` exists, and
  it runs as its own CI step (`.github/workflows/ci.yml:L31-L32`, `Structure check suite`). The rows
  naming `checks/structure.sh` (`docs/nfdr.md:L1201`, `:L1206`, `:L1208`, `:L1209`, `:L1210`, `:L1213`,
  `:L1223`, `:L1228`, `:L1245`) carry no `(suite test_structure.sh)`. § 10's preamble says "all six
  suites are on steps" (`:L1195`), and § 9's bullet counts six (`:L1039-L1041`).
  `ls checks/tests` now lists seven `test_*.sh`. § 9 calls a seventh "a re-measurement of this
  sentence and not a contradiction of it", so the count is owed its re-measurement.
- **If a document has to be written:** none. § 10's rows and preamble, and § 9's count.
- **Answer:** <the owner fills this in>

### 3.3 § 9 says the tree holds no `#[path]` site pulling a file from `tests/`, and it holds two
- **Raised by:** PM — 2026-10-03
- **Which record:** `nfdr.md` § 9, the `checks/structure.sh` bullet (`docs/nfdr.md:L1025-L1028`)
- **Tracked by:** `nozoki · nemawashi · 2026-10-01_the-tree-is-checked-for-its-shape`
- **What it blocks:** nothing is blocked. The ground § 9 gives for leaving the escape a review catch
  is false as written.
- **Where it shows:** § 9 leaves "shipped code that pulls a file from `tests/` in through a `#[path]`
  attribute" a review catch "because the tree holds no such site to shape one against"
  (`docs/nfdr.md:L1025-L1028`). `grep -rn '#\[path' crates/*/src` prints two sites:
  `crates/nozoki-core/src/lib.rs:L19` and `crates/nozoki-bridge/src/lib.rs:L11`. Each is
  `#[path = "../tests/common/mod.rs"]` on a `mod test_support` gated `#[cfg(test)]`
  (`crates/nozoki-core/src/lib.rs:L18-L24`, `crates/nozoki-bridge/src/lib.rs:L10-L16`). Neither is
  shipped code, so the escape itself is not present. The sentence should state the test-only sites
  and say how they differ from a shipped `#[path]` inclusion.
- **If a document has to be written:** none. § 9's `checks/structure.sh` bullet.
- **Answer:** <the owner fills this in>

### 3.4 § 9 keeps a `#[cfg(test)]` module inside `src/` under every rule, and does not say which wins when its body is a file under excluded `tests/`
- **Raised by:** PM — 2026-10-03
- **Which record:** `nfdr.md` § 9, the `checks/structure.sh` bullet (`docs/nfdr.md:L1023-L1024`)
- **Tracked by:** `nozoki · nemawashi · 2026-10-01_the-tree-is-checked-for-its-shape`
- **What it blocks:** nothing is blocked today. The script follows the file scope. A later reading
  of the bullet could ask it to follow the module instead, and the records do not say which.
- **Where it shows:** § 9 says the script reads sources "outside `crates/*/tests/`" (`:L1005-L1007`)
  and that "a `#[cfg(test)]` module inside `src/` stays inside every rule" (`:L1023-L1024`).
  `mod test_support` is such a module in both crates (3.3's sites), and its body is
  `tests/common/mod.rs`, a file outside the read scope that names `std::fs` and `std::process`
  (`crates/nozoki-core/tests/common/mod.rs:L8`, `:L11`; `crates/nozoki-bridge/tests/common/mod.rs:L8`,
  `:L13`). `checks/structure.sh` reads files by path and passes these modules (its run on the tree:
  `nothing found`). The bullet should say whether a module declared in `src/` is judged by its
  declaring file or by the file that holds its body.
- **If a document has to be written:** none. § 9's `checks/structure.sh` bullet.
- **Answer:** <the owner fills this in>

**How it closes.** `product-architecture` folds it on its next run like any other item here.
