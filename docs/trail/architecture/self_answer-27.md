# Self-answer report — `docs/adr/` and `docs/nfdr.md`

## Header

- **Companion:** `docs/architecture_open_issues.md`
- **Document:** `docs/adr/` and `docs/nfdr.md`. The NFDR is v25 and Settled (`docs/nfdr.md:L3-L5`).
  No `product-architecture` run wrote this companion. The PM opened it at `nozoki@c308b2f` with four
  items in § 3, raised from downstream after `checks/structure.sh` and its suite landed at
  `nozoki@463acb9`. All four are about `nfdr.md`. None touches an ADR.
- **Decided by:** `decide_companion_answers.md` v1.3.0
- **Date:** 2026-10-03
- **Sources re-read:** Two, both behind 3.4's answer.
  - The Rust Reference, *Conditional compilation*,
    https://doc.rust-lang.org/reference/conditional-compilation.html, re-read 2026-10-03. On the
    `test` option it says: "Enabled when compiling the test harness. Done with `rustc` by using the
    `--test` flag." So a `#[cfg(test)]` module is not compiled into the library a normal build
    produces.
  - The Rust Reference, *Modules*, https://doc.rust-lang.org/reference/items/modules.html, re-read
    2026-10-03. It says "The directories and files used for loading external file modules can be
    influenced with the `path` attribute", resolved relative to the directory of the declaring file.
    So `#[path = "../tests/common/mod.rs"]` in `src/lib.rs` loads the module's body from
    `tests/common/mod.rs`, a file under `tests/`.

  The Cargo reference's "as a separate crate" sentence, which § 9 already cites
  (`docs/nfdr.md:L1007-L1008`), was re-read on 2026-10-01 by `self_answer-26.md`. No answer here
  rests on anything that page has said since.

## Items worked

### 3.1 — The header ties a command's executability to its script's existence, and `checks/structure.sh` now exists holding a subset of its rules

- **Bucket:** 3. Raised from downstream — an item from a seat that did not write these records
- **Verdict:** confirmed with addition
- **Why:** The item's correction holds. A command's executability is tied to each rule, not to the
  script. I added one case the item did not follow, and I settled where the list of held rules lives.

  *Seat.* The edit lands in `nfdr.md`'s header (`docs/nfdr.md:L35-L37`), which is this companion's
  document. It commits no person, outside party or risk. It decides only what one sentence of the
  constraint set promises about its own gates. I can name no ground I cannot see, so I answered it
  in the owner's seat. The item carries a lean ("The correction owed is for the NFDR to say so: tie
  executability to each rule rather than to the script"), so I weighed it as a draft, not as an
  open question.

  *Check 2: does the draft hold, and for its stated reason?* Yes. The header says each command
  "becomes executable in the change that lands its script, and until then the gate is
  `development-design` reading the entry" (`docs/nfdr.md:L35-L37`). Now that `checks/structure.sh`
  is in the tree, that sentence makes every rule § 10 assigns to the script read as executable. The
  script holds four clauses (`checks/structure.sh:L35-L84`) and names the rest "NOT held"
  (`:L86-L93`). On the tree at `nozoki@c308b2f`, running `bash checks/structure.sh` printed
  `structure.sh: 12 Rust files in 2 crates read — nothing found` and exited 0. That pass covers the
  four clauses and nothing else. So the header's sentence is a coverage claim nothing provides.
  The script's header already reads the sentence per rule (`:L88-L90`). The NFDR should say the
  same, so that the script is not the only file holding the reading.

  *Where the list of held rules lives.* The item leaves open whether the per-rule state belongs in
  § 9's `checks/structure.sh` bullet. It does not belong in the NFDR at all. The script's header
  states it, and the NFDR points there. The document already has this shape: QC-62 cites
  `checks/renderer.sh`'s frame list as "cited and not copied here … so the next re-measurement
  moves one file" (`docs/nfdr.md:L497-L499`). A list copied into the NFDR would be wrong the day
  the next rule lands, and nothing in that change would touch the NFDR. The item's own list shows
  how fast a copy goes wrong. It leaves out QC-7 and § 9's layer-5 placement rule (no
  `CARGO_BIN_EXE_` under `crates/*/tests/`, `docs/nfdr.md:L1000-L1001`), and both are among the
  rules the script's header names as not held (`checks/structure.sh:L90-L93`).

  *Check 3: does it contradict anything settled?* No. It agrees with the SDD, which stages
  `checks/structure.sh`'s rules slice by slice. The Git slice's bar has the script find "no
  `std::process` in any shipped crate and the libgit2 import in `git-reader` alone"
  (`docs/SDD.md:L1663-L1664`). The watcher slice's bar has it find "the FSEvents subscription in
  `watcher` alone" (`:L1723-L1724`). The own-state slice's bar has it find "the container path in
  `own-state` and the bridge's log module alone" (`:L1781`). Each slice lands its own rule, and that
  is the per-rule executability this answer states. The SDD's `read-only-harness` row names
  `structure.sh` among the harness scripts (`docs/SDD.md:L332`) and says nothing that ties every
  rule to the script's arrival.

  *The addition: § 10's* Gated at *column.* The item is about the header and § 9. It does not follow
  the sentence into § 10, where the same false coverage shows. Every row naming
  `checks/structure.sh` gives `CI build` as its gate. On the QC-20 row (`docs/nfdr.md:L1213`) the
  script is the only command, and the script does not hold QC-20. A reader of § 10 alone finds a CI
  gate that does not run. The fix is one sentence, not nine row edits. State once, in the header
  sentence or in § 10's preamble, that a row's `CI build` holds only for the rules its command
  already holds, and that `development-design` is the gate for the rest. § 10 already defers to
  the entries ("When a row disagrees with its entry, the entry is right", `docs/nfdr.md:L1189-L1190`).
  The one sentence keeps that true without a per-row state that goes stale.

  *Check 4: the failure paths.* **Stale:** the script gains a rule and its header is not updated.
  The NFDR then names `development-design` as the gate for a rule CI already holds. That errs on
  the side of more review and breaks no promise. The reverse case is a header that claims a rule
  with no code behind it. § 9's rule catches it: the suite proves the script "reads what its entry
  says it reads" (`docs/nfdr.md:L1033-L1035`). `checks/tests/test_structure.sh` has cases for each
  of the four clauses held today (for example `test_case_3_core_process_names_both_rules`,
  `test_case_5_core_non_owner_filesystem_is_rejected`). **Absent:** a script not yet in the tree
  (`checks/entry-points.sh`, `checks/latency.sh` and others; `ls checks/` at `nozoki@c308b2f`)
  holds no rule, so the per-rule sentence covers it and the header needs no second clause.
  **Empty:** a script that lands holding no rule is the same as an absent one. **Concurrent:** two
  changes add rules in parallel. Each one's header edit is its own, and the NFDR changes for
  neither.

  Decided together with 3.2. That item adds `(suite test_structure.sh)` to the same rows, and
  this answer is what keeps that tag from reading as coverage of rules the script does not hold.
  A verdict of **confirmed** alone was close. The § 10 column is what tipped it to *with
  addition*: it is the same defect in a section the item did not open.

### 3.2 — § 10's rows naming `checks/structure.sh` omit its suite, and § 9 / § 10 count six suites where seven are on steps

- **Bucket:** 3. Raised from downstream — an item from a seat that did not write these records
- **Verdict:** confirmed with addition
- **Why:** Tag the nine rows and re-count to seven, as the item says. Two additions: the same
  sentence's `ci.yml` line numbers are now false and need re-citing to a commit, and § 10's
  preamble should point at § 9 for the count instead of repeating it.

  *Seat.* Every edit lands in `nfdr.md` § 9 and § 10, this companion's document. It commits nobody
  to anything, and it is a correction of measured facts, not a widening. Answered in the owner's
  seat. The item's last sentence is its lean: "§ 9 calls a seventh 'a re-measurement of this
  sentence and not a contradiction of it', so the count is owed its re-measurement". I weighed it
  as a draft.

  *Check 2: the draft holds.* § 10's rule: "Where a row names a `checks/<name>.sh` script that has
  a suite under `checks/tests/`, the suite is named beside it" (`docs/nfdr.md:L1192-L1193`).
  `checks/tests/test_structure.sh` exists and runs as `Structure check suite`
  (`.github/workflows/ci.yml:L31-L32`). I checked the nine rows the item cites by line
  (`docs/nfdr.md:L1201`, `:L1206`, `:L1208`, `:L1209`, `:L1210`, `:L1213`, `:L1223`, `:L1228`,
  `:L1245`). Each names `checks/structure.sh` with no suite beside it, and `grep -n 'structure.sh'
  docs/nfdr.md` finds no other row in § 10 that names it. `ls checks/tests` at `nozoki@c308b2f` lists seven
  `test_*.sh`. § 9's own *verified by* loop (`for s in checks/tests/*.sh; do grep -q "$s"
  .github/workflows/ci.yml || echo "$s"; done`) printed nothing. So all seven are on steps, and
  "six" in § 9 (`docs/nfdr.md:L1039-L1041`) and in § 10's preamble (`:L1195`) is now false. § 9
  itself says this is a re-measurement and not a contradiction (`:L1045-L1046`).

  *Addition 1: the line numbers in the same sentence.* The two structure steps landed at
  `ci.yml:L28-L32`, and every step after them moved down six lines. At `nozoki@ab39502`,
  `git show ab39502:.github/workflows/ci.yml` puts the six suites' `run:` lines at 36, 42, 53, 62,
  68 and 71. Those match § 9's citations, so the citations were true when written. At
  `nozoki@463acb9` (`git diff --stat 463acb9 HEAD -- .github/workflows/ci.yml` is empty, so the
  same holds at HEAD) the steps are: `test_structure.sh` `:L31-L32`, `test_bundle.sh` `:L41-L42`,
  `test_view.sh` `:L47-L48`, `test_renderer.sh` `:L58-L59`, `test_read_only.sh` `:L67-L68`,
  `test_no_network.sh` `:L73-L74` and `test_own_state.sh` `:L76-L77`. The bullet's opening
  citation "the way `Bundle probe suite` runs `checks/tests/test_bundle.sh`
  (`.github/workflows/ci.yml:L35-L36`)" (`docs/nfdr.md:L1036-L1037`) carries no commit, and at HEAD
  `:L35` is `run: nozoki-mac/assemble.sh`. A re-measurement that fixed the count and left these
  would leave the sentence half-false. Pin them to a commit, as QC-62's tail already does
  ("`.github/workflows/ci.yml:L46-L47` at `nozoki@ab39502`", `docs/nfdr.md:L493`), so the next
  inserted step makes them dated rather than wrong.

  *Addition 2: one home for the count.* The count went stale in two places because it is written
  in two: § 9's bullet and § 10's preamble ("all six suites are on steps", `docs/nfdr.md:L1195`).
  § 10's preamble already names § 9's bullet as "the rule" (`:L1194`). It should point there for
  the count as well and stop restating it. Then the eighth suite moves one sentence, not two.

  *Check 3: against 3.1's answer.* § 10's preamble says the named suite "proves the script reads
  what the row says it reads" (`docs/nfdr.md:L1193-L1194`). On a row whose rule the script does
  not hold, QC-20 for one, that would be a coverage claim. 3.1's sentence is what stops it: a
  row's gate holds only for the rules its command already holds, and the suite proves only those.
  I decided the two together. The tag still goes on all nine rows, because § 10's rule works per
  script, and 3.1's sentence states what the tag does not claim.

  *Check 4.* **Stale:** an eighth suite. The pinned line numbers become dated history rather than
  wrong pointers, and the count lives in one sentence. **Absent:** a script with no suite carries
  no tag. That is § 10's rule as written, and it does not change. **Refused:** a suite red on the
  hosted runner. § 9's *How a suite joins* already covers this case (`docs/nfdr.md:L1054-L1061`),
  and nothing here changes it. The one fact the item did not measure is whether `Structure check
  suite` has run on the hosted runner yet. I did not read that, so this answer makes no claim
  about it. Under § 9's own rule the first push carrying the step is its reading.

### 3.3 — § 9 says the tree holds no `#[path]` site pulling a file from `tests/`, and it holds two

- **Bucket:** 3. Raised from downstream — an item from a seat that did not write these records
- **Verdict:** confirmed with addition
- **Why:** Name the two test-only sites, and name what separates them from the escape: the
  `#[cfg(test)]` gate. Rewrite the sentence's reason from "no such site" to "no *shipped* site".
  The escape stays a review catch, and no grep rule is owed.

  *Decided together with 3.4.* These two items are one distinction seen from two sides: what makes
  a `#[path]` into `tests/` harmless here, and which file the scan judges. I took 3.3 first, in the
  companion's order, with 3.4's answer in view. Each answer names the other.

  *Seat.* The edit lands in § 9's `checks/structure.sh` bullet (`docs/nfdr.md:L1025-L1028`), in
  this companion's document. It commits no one. Answered in the owner's seat. The item's lean is
  "The sentence should state the test-only sites and say how they differ from a shipped `#[path]`
  inclusion", and I weighed it as a draft.

  *Check 2: the draft's conclusion holds, and the heading overstates it.* The sentence names the
  escape as "shipped code that pulls a file from `tests/` in through a `#[path]` attribute" and
  leaves it a review catch "because the tree holds no such site to shape one against"
  (`docs/nfdr.md:L1026-L1028`). "Such site" means shipped code. The two sites the item found
  (`crates/nozoki-core/src/lib.rs:L18-L24`, `crates/nozoki-bridge/src/lib.rs:L10-L16`, both opened
  this run) are each gated `#[cfg(test)]`. The Rust Reference says the `test` option is "Enabled
  when compiling the test harness", so neither site ships, and the sentence is not false as
  written. The item's own text says so: "Neither is shipped code, so the escape itself is not
  present." The heading's "and it holds two" reads the sentence more broadly than it is written.
  I am reporting that, not correcting it. The draft is still right that the sentence owes the two
  sites. A reader who greps `#[path` meets them before reaching the qualifier, and nothing in the
  document says why they are not the escape. They landed after the sentence was written: the core
  site at `233e7eb` (2026-09-19) and the bridge site at `b042edb` (2026-09-23), per
  `git log -S'#[path = "../tests/common/mod.rs"]'`.

  *The addition: what separates them is the gate.* The draft asks the fold to "say how they differ"
  and leaves the answer open. The answer is one attribute. `#[path]` into `tests/` on a module
  gated `#[cfg(test)]` builds into the test harness only. The same attribute without the gate ships
  the body, and no scan reads it, because `checks/structure.sh` reads files by path and leaves out
  every file under `tests/` (`checks/structure.sh:L29-L33`). The review catch has to look for
  exactly that difference. So the sentence's reason becomes "no *shipped* site". The review catch
  stays at `development-design`. By RN-19's own terms, "a rule becomes owed the day a site appears"
  (`docs/nfdr.md:L1885-L1886`), and a shipped site has not appeared.

  *Close to a different verdict.* There are now real gated sites, so a grep rule could be written:
  accept a `#[path]` into `tests/` under `#[cfg(test)]` and refuse one without the gate. That is
  more than "no site to shape against" allowed. I did not answer that a rule is owed. The item does
  not ask for one. A new rule would widen the document, and no shipped occurrence is cited, so
  under the prompt's *A widening item waits until it occurs* it is "not until it occurs". If a
  later item cites an ungated site, that tips it.

  *Check 3.* It agrees with QC-14 at v25, which also judges a unit "as it ships" and leaves out a
  test target's `#[path]` into `checks/` (`docs/nfdr.md:L5`). The third `#[path]` site in the tree,
  `crates/nozoki-core/tests/walk.rs:L6` into `checks/walk.rs`, is that QC-14 case. It sits under
  `tests/` and is not this item's. It agrees with 3.4's answer.

  *Check 4.* **Stale:** a change removes `#[cfg(test)]` from either `test_support`. The body ships
  with `std::process` and `std::fs` in it. `checks/structure.sh` stays silent, and only the review
  catch sees it. That is the named gap, and the script's header names it too
  (`checks/structure.sh:L100-L102`). **Empty:** a crate with no shared test helper has no site,
  and nothing changes.

### 3.4 — § 9 keeps a `#[cfg(test)]` module inside `src/` under every rule, and does not say which wins when its body is a file under excluded `tests/`

- **Bucket:** 3. Raised from downstream — an item from a seat that did not write these records
- **Verdict:** answered
- **Why:** The file the body sits in decides, and the scope is by path. A body loaded from
  `crates/*/tests/` is outside every rule. The inline-module sentence keeps its meaning for a body
  written inside a file under `src/`.

  *Decided together with 3.3* (see its entry). 3.3's escape is the case this answer leaves to
  review.

  *Seat.* The edit lands in § 9's `checks/structure.sh` bullet (`docs/nfdr.md:L1023-L1024`). It
  decides what a check reads, not what ships, so it carries no risk the owner bears. Answered in
  the owner's seat. The item asks "whether a module declared in `src/` is judged by its declaring
  file or by the file that holds its body" and gives no lean, so it is **answered**.

  *Check 2: is it one question?* Yes. The item notes that the script follows the file scope today
  (`checks/structure.sh` printed `nothing found` on the tree), but that is a measurement, not a
  second question.

  *The answer and its ground.* § 9 grounds the whole scope in one sentence: "Every property the
  script holds is about the process an adopter runs" (`docs/nfdr.md:L1006-L1007`). The `tests/`
  exclusion and the `build.rs` exclusion both follow from it. A `#[cfg(test)]` body is compiled
  only "when compiling the test harness" (Rust Reference, re-read 2026-10-03), so it never enters
  the adopter's process. It is out on the same ground. The module-by-module reading would put it
  back in. That reading fails the tree as built, and wrongly. The core body imports `std::process`
  (`crates/nozoki-core/tests/common/mod.rs:L11`) and the bridge body does too
  (`crates/nozoki-bridge/tests/common/mod.rs:L13`), which is QC-36 in every crate and QC-9 in the
  core. Both import `std::fs` (`:L8` in each) outside the two filesystem owners, which is QC-15.
  RN-19 already turned down that kind of reach when it scoped QC-61: "The check overreached the
  property, which is about the shipped process" (`docs/nfdr.md:L1866`). The sentence "a
  `#[cfg(test)]` module inside `src/` stays inside every rule" (`docs/nfdr.md:L1024`) keeps its
  meaning for a module whose body is written inside a file under `src/`. That case is read and
  fails closed, and `checks/tests/test_structure.sh` holds it as
  `test_inline_test_module_is_scanned`. The script's own *WHAT IS READ* already reads it this way
  (`checks/structure.sh:L29-L33`). The NFDR is owed the same sentence, so the reading is not held
  in the script alone.

  *Close to a different verdict.* Reading by module fails closed, and a check that fails closed
  usually wins a tie. What tipped it: here failing closed means a red CI on code that never ships.
  The only fix would be to move `std::process` out of the helper or to exempt it by name, and both
  are the overreach RN-19 removed.

  *Check 3.* It agrees with § 9's scope (`docs/nfdr.md:L1005-L1007`), with the script's header,
  with RN-19's QC-61 ground, and with QC-14's "as it ships" at v25. It agrees with 3.3.

  *Check 4.* **Stale:** the gate is removed (3.3's check 4). The body ships unread. The file
  reading is safe only while the module stays `#[cfg(test)]`, so the bullet should say that the two
  answers rest on each other. **Concurrent:** a helper used by both `src/` unit tests and `tests/`
  integration targets is exactly what these two modules are, and nothing here changes for it.
  **Absent:** a `#[path]` whose target file does not exist fails to compile, before any scan
  runs. **Uneven, named:** an inline `#[cfg(test)]` module is read, and an out-of-line one under
  `tests/` is not. A developer can move test code that the scan would flag into `tests/common/` and
  so step outside the scan. That is allowed, because the code still does not ship. It is the price
  of a scan that reads by file path, and the price is paid only on test code.

## Left for the owner

None this run.

## Skipped

None this run.

## Raised on this document

### 2.1 — § 9's `nozoki-mac` bullet says `ci.yml:L29` runs `nozoki-mac/assemble.sh`, and at HEAD `:L29` runs `checks/structure.sh`

- **What the document is owed:** re-cite the *Toolchain — not yet measured* clause's `ci.yml:L29`
  (`docs/nfdr.md:L1107-L1109`) and its `:L22-L29` range (`:L1120-L1121`) to a named commit. At
  `nozoki@463acb9` that is `:L35` and `:L22-L35`. The other way is to pin the existing numbers to
  `nozoki@0aca57e`.
- **Why it is worth a cycle:** *A fact in it is now false* (`decide_companion_answers.md` § The
  items are not the whole of what a document is owed). I measured `git show
  0aca57e:.github/workflows/ci.yml`: `:L29` there is `run: nozoki-mac/assemble.sh`, so the
  citation was true when written. In the tree at `nozoki@463acb9` and at HEAD, `:L29` is `run:
  checks/structure.sh`, and `assemble.sh` runs at `:L35` (`grep -n 'assemble.sh'
  .github/workflows/ci.yml`). The `:L22-L29` range backs "`ci.yml` has no `swift --version` step".
  That claim still holds for the whole file (`grep -n 'swift --version'` prints nothing), but the
  range no longer reaches the build step. The cause is the same six-line shift as 3.2's, and
  `product-architecture` is already folding 3.2, so this costs no extra cycle. No item named this
  bullet. 3.2 is about the `checks/tests/` bullet and § 10.

  *Seen and not raised.* Every other `ci.yml` line citation in `nfdr.md` outside the Review Notes
  is pinned to a commit or belongs to 3.2. QC-62's tail reads "`.github/workflows/ci.yml:L46-L47`
  at `nozoki@ab39502`" (`docs/nfdr.md:L493`). The Review Notes' citations are dated history.
  ADR-0012 cites `ci.yml:L43-L44` unpinned (`docs/adr/0012-renderer-run-proved-on-the-shipped-bundle-beside-the-wall.md:L77`),
  but an accepted record is append-only and not rewritten. Its later line records the move at
  `nozoki@ab39502` (`:L140`).

  *On the edit to the companion.* § 2 read "None." I replaced that one word with the provenance
  blockquote and item 2.1, because leaving it beside an item would make the section say two
  opposite things. No other line already in the file moved.

## Companions opened

None this run.

## Launchers owed

- **`docs/adr/` and `docs/nfdr.md`** — `<CORE>/launchers/skill/launcher.sh product-architecture nozoki`
