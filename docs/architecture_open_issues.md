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

> **No `product-architecture` run wrote this item.** A `companion-self-answer` run added it on
> 2026-10-03 while answering §§ 3.1 – 3.4 (`docs/trail/architecture/self_answer-27.md`, § Raised on
> this document). It came from re-reading `nfdr.md`'s citations into `.github/workflows/ci.yml` for
> 3.2. The step insertion behind 3.2 also moved a citation in § 9's `nozoki-mac` bullet, and no item
> named that bullet. It sits in this bucket because the run has a lean. Its slot is for the next
> round to fill.

### 2.1 § 9's `nozoki-mac` bullet says `ci.yml:L29` runs `nozoki-mac/assemble.sh`, and at HEAD `:L29` runs `checks/structure.sh`
- **Lands in:** `nfdr.md` § 9, the `nozoki-mac` bullet's *Toolchain — not yet measured* clause
  (`docs/nfdr.md:L1107-L1109`, `:L1120-L1121`)
- **Drafted into the records:** nothing. This run writes no record. The change it proposes: the
  clause reads "from `nozoki@0aca57e` CI builds `nozoki-mac` in two steps —
  `.github/workflows/ci.yml:L26` runs `swift test …` in `Test gate`, and `:L29` runs
  `nozoki-mac/assemble.sh`" (`docs/nfdr.md:L1107-L1109`). That was true at `nozoki@0aca57e`
  (`git show 0aca57e:.github/workflows/ci.yml`, `:L29` is `run: nozoki-mac/assemble.sh`). From
  `nozoki@463acb9`, `Structure check` and `Structure check suite` sit at `:L28-L32`. So `:L29` is
  `run: checks/structure.sh`, and `assemble.sh` runs at `:L35`. Re-cite it as `:L35` pinned to
  `nozoki@463acb9`, or pin the existing `:L29` to `nozoki@0aca57e`. Either way the next inserted
  step makes the citation dated rather than wrong. The same clause's "`ci.yml` has no
  `swift --version` step (`:L22-L29`)" (`docs/nfdr.md:L1120-L1121`) is still true of the whole file.
  `grep -n 'swift --version' .github/workflows/ci.yml` prints nothing. But the cited range now
  ends before `Build Nozoki.app`, so it should cover `:L22-L35`, or the whole file, under the same
  pin. `Test gate` at `:L26` has not moved.
- **Rationale:** a pointer in the document is now false: a reader who opens `ci.yml:L29` to find
  the build step finds the structure check. This is the strongest ground the answering prompt
  names for reopening a settled document ("A fact in it is now false … a path"). It costs nothing
  extra, because `product-architecture` is already folding § 3.2, whose root cause is the same six-line
  shift. Every other `ci.yml` citation in `nfdr.md` outside the Review Notes is pinned to a commit
  (`docs/nfdr.md:L493`) or is § 3.2's. The Review Notes are dated history and are left alone.
  ADR-0012's citations (`docs/adr/0012-…md:L77`, `:L140`, `:L217`) are in an accepted record, which
  is append-only, so they are not raised.
- **If overridden:** the clause keeps a pointer to the wrong step. Nothing is gated on it, so no
  obligation moves and no record supersedes.
- **Confirm or override:** <"confirm", or "override: <what to do instead>">

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
- **Answer:** Tie executability to each rule, not to the script. A rule that a command names
  becomes executable in the change that adds that rule to the command, and until then its gate is
  `development-design` reading the entry. A script not yet in the tree is the case where no rule has
  been added, so the header sentence needs no second clause for it. Which of `checks/structure.sh`'s
  rules are held is stated by the script's own header (`checks/structure.sh:L35-L93`, *THE SCAN
  TABLE* and *WHAT IS NOT HELD*). The NFDR cites that header and never copies its list, the way
  QC-62 cites `checks/renderer.sh`'s frame list "cited and not copied here … so the next
  re-measurement moves one file" (`docs/nfdr.md:L497-L499`). A copied list would go stale at the next
  rule added, and that change adds no NFDR edit. **Added:** the same sentence has to govern § 10's
  *Gated at* column. Every row naming `checks/structure.sh` reads `CI build`, including rows whose
  rule the script does not hold — QC-20 (`docs/nfdr.md:L1213`) names `checks/structure.sh` alone. State once, in
  the header sentence or in § 10's preamble, that a row's `CI build` holds only for the rules its
  command already holds and that `development-design` is the gate for the rest. Do not edit the rows
  one by one. The item's list of unheld rules leaves out QC-7 and § 9's layer-5 placement rule, which
  the script's header names as not held (`checks/structure.sh:L90-L93`). That gap is one more reason
  to point at the header rather than list the rules. Reasoning: `docs/trail/architecture/self_answer-27.md`.

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
- **Answer:** Add `(suite test_structure.sh)` to every § 10 row that names `checks/structure.sh`,
  all nine the item lists. § 10's rule works per script, not per rule (`docs/nfdr.md:L1192-L1194`). Re-measure § 9's
  count as seven: `ls checks/tests` lists seven `test_*.sh`, and § 9's own loop over
  `.github/workflows/ci.yml` prints nothing at `nozoki@463acb9`, so all seven are on steps.
  **Added:** the same sentence's `ci.yml` line numbers are owed the same re-measurement.
  `Structure check` and `Structure check suite` landed at `:L28-L32`, so every later step moved
  down six lines, and § 9's citations now point at the wrong steps. Its first `:L35-L36`
  (`docs/nfdr.md:L1037`) is now `nozoki-mac/assemble.sh`. Re-cite them pinned to a commit. At
  `nozoki@463acb9` they are `test_structure.sh` `:L31-L32`, `test_bundle.sh` `:L41-L42`,
  `test_view.sh` `:L47-L48`, `test_renderer.sh` `:L58-L59`, `test_read_only.sh` `:L67-L68`,
  `test_no_network.sh` `:L73-L74` and `test_own_state.sh` `:L76-L77`. Also make § 10's preamble
  point at § 9 for the count instead of repeating "all six". Two copies of the count is why it
  went stale in two places. The suite tag does not mean the suite covers rules the script does not
  hold. 3.1's answer keeps that distinction, and the two were decided together. Reasoning:
  `docs/trail/architecture/self_answer-27.md`.

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
- **Answer:** State both sites and the line that separates them from the escape. The escape is a
  `#[path]` on a module that ships. The tree holds two `#[path]` sites in `src/` that load a file
  from `tests/`: `crates/nozoki-core/src/lib.rs:L18-L24` and `crates/nozoki-bridge/src/lib.rs:L10-L16`.
  Each is `#[path = "../tests/common/mod.rs"]` on `mod test_support`, gated `#[cfg(test)]`. That gate
  compiles only into the test harness ("Enabled when compiling the test harness",
  https://doc.rust-lang.org/reference/conditional-compilation.html, re-read 2026-10-03), so neither
  site ships. The escape is the same attribute on a module without that gate. Its body would then
  ship, and no scan would read it. Rewrite the sentence's reason to match: the tree holds no
  *shipped* site, not "no such site". The escape stays a review catch at `development-design`. No
  grep rule is owed until a shipped site appears, by RN-19's own terms. Read narrowly, the current
  sentence is not false: it speaks of shipped code. But a reader who greps `#[path` finds two sites
  and is left to work this out alone. The item's heading reads the sentence more broadly than it is
  written. Decided together with 3.4, which settles how the scan reads these two modules. Reasoning:
  `docs/trail/architecture/self_answer-27.md`.

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
- **Answer:** A module declared in `src/` is judged by the file that holds its body, so the scope is
  by file path. The declaring file is read like any file under `src/`. A body loaded through
  `#[path]` from a file under `crates/*/tests/` is outside every rule, as that file is. "A
  `#[cfg(test)]` module inside `src/` stays inside every rule" (`docs/nfdr.md:L1024`) keeps its
  meaning for a module whose body is written inside a file under `src/`. `checks/tests/test_structure.sh`'s
  `test_inline_test_module_is_scanned` holds that case, and it stays fail-closed. The ground is
  § 9's own: "Every property the script holds is about the process an adopter runs"
  (`docs/nfdr.md:L1006-L1007`). A `#[cfg(test)]` body never enters that process, so it is out for
  the same reason `tests/` is out. Reading by module would fail the tree as built. Both bodies
  import `std::process` (`crates/nozoki-core/tests/common/mod.rs:L11`,
  `crates/nozoki-bridge/tests/common/mod.rs:L13`), which is a QC-36 finding in every crate, and
  `std::fs` outside the two filesystem owners, which is a QC-15 finding. That is the kind of
  overreach RN-19 removed when it scoped QC-61. **Not covered, named:** the file reading is safe only
  while the module stays gated. Drop the `#[cfg(test)]` and the body ships unread. That is 3.3's
  escape and 3.3's review catch, and the script's header already names this gap
  (`checks/structure.sh:L100-L102`). Write the bullet so it says the two answers rest on each other.
  Reasoning: `docs/trail/architecture/self_answer-27.md`.

**How it closes.** `product-architecture` folds it on its next run like any other item here.
