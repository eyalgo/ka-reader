# Self-answer report — `adr/` and `nfdr.md`

## Header

- **Companion:** `docs/architecture_open_issues.md`
- **Document:** `docs/adr/` and `docs/nfdr.md`
- **Decided by:** `<CORE>/../skills/companion/.claude/skills/companion-self-answer/prompts/rich.md` v1.3.1
- **Date:** 2026-11-14
- **Sources re-read:** None outside this repository. Both answers rest on the product's own tree,
  re-read at `main` for this run: `checks/gate.sh` at `ka-reader@21f611f` and at `ka-reader@32bdbc1`
  (byte-identical; `git diff --stat 21f611f 32bdbc1 -- . ':!docs'` prints nothing), `git ls-tree` of
  `checks/tests/` and `checks/`, and the header of `checks/git-view-memory.sh`.

## Items worked

### 3.1 — § 8 quotes the test gate as it stood before the gate split the Git view memory suite out

- **Bucket:** 3. Raised from downstream — an item from a seat that did not write these records
- **Verdict:** confirmed with addition
- **Why:** **§ 8 should quote the test gate as the gate now runs it, name the two memory steps after
  it, and § 9's runner paragraph should state the same precondition.** The item proposes the fix
  itself, so the run weighed that proposal rather than starting from nothing.

  *Seat.* The change goes in `nfdr.md`, this companion's own document. It binds nothing outside the
  record's agreement with the tree, so the run can answer it in the owner's seat.

  *Is the proposal sound?* Yes, and it is a correction, not a widening: § 8 states a command that is
  no longer the gate's. Re-read at `main`: *Test gate* is `checks/gate.sh:L98` and carries
  `--skip "^ShellTests\.GitViewMemoryBoundTests/"`. *Git view memory bound* is `:L104` and its suite
  is `:L105`. Both new files are mode 100755. The workspace build is `:L87` and the bridge's assembly
  is `:L97`. § 8's paragraph pins all three of those steps, so all three are re-pinned. The old pins
  are kept as dated readings, which is how that paragraph has handled each earlier move.

  *Check 3 — what it must agree with.* § 8 goes on to say that the structure pair and the rest come
  "after them". That stays true: the sanitizer is at `:L112` and the structure pair at `:L113-L114`,
  both after the memory steps. The SDD made the same re-pin at v89 (RN-175), so the two records will
  agree. The addition comes from § 9's runner paragraph (`docs/nfdr.md:L2992-L3006`). § 8 names it
  as the one home of the Swift runner's preconditions. It says every `verified by:` tail naming
  `swift test --package-path ka-reader-mac` reads under it. The gate's run of that command now skips
  one suite, and the reason is a run precondition of the same kind as the window-server one already
  stated there. So it belongs in that paragraph. No tail in the NFDR names `GitViewMemoryBoundTests`
  (a search of the file finds none), so no tail is made false.

  *Check 4 — failure paths.* **Stale:** the pins will move again. Pinning each locator to a commit,
  as the paragraph already does, keeps a later move a re-measurement and not a contradiction.
  **Absent:** if the memory step is ever removed, the skip goes with it. The dated reading records
  when it held. **Concurrent:** this is the reason for the split. A case run in a shared, parallel
  process would count other tests' memory, which the answer states. **Empty** and **refused** add
  nothing.

  I was close to plain *confirmed*. What tipped it was § 9 claiming to be the runner's one home: if
  § 8 alone named the split, that claim would be false by omission.

### 3.2 — § 9 counts twenty-nine suites where the tree holds thirty

- **Bucket:** 3. Raised from downstream — an item from a seat that did not write these records
- **Verdict:** confirmed with addition
- **Why:** **Thirty suites at `ka-reader@21f611f`, each a whole gate step. The re-measurement is
  written into the slot, so the fold copies it and does not redo it.** The item asks for a
  re-measurement and does not give one, so the run made it.

  *Seat.* This is § 9's count and its one home (`docs/nfdr.md:L3323`). It is a fact about the tree,
  so the run can decide it.

  *The measurement.* `git ls-tree --name-only main checks/tests/ | grep -c '/test_.*\.sh$'` prints
  `30`, and the same command at `21f611f` prints `30`. Each of the thirty paths was matched against
  `^run_step '<name>' '<path>'$` in `checks/gate.sh`, and each matches exactly one line. The slot
  lists them in gate order. As every earlier reading did, the measurement runs no suite.

  *Check 3 — the counts that hang off it.* The bullet says "Four of the twenty-nine have no
  `checks/<name>.sh` of their own name". `test_git_view_memory.sh` pairs by name with
  `checks/git-view-memory.sh`, which is in the tree (the underscore-to-hyphen pairing that
  `test_git_beta_scene.sh` ↔ `git-beta-scene.sh` already uses). So it is still four, the same four,
  out of thirty. The bullet's tail says "through it all twenty-nine" (`docs/nfdr.md:L3311`), and that
  becomes thirty. The SDD's harness row counts thirty suites at the same pin (RN-175), so the records
  agree.

  *The addition.* The item asks for the count, but the bullet pins a line for every suite. Every
  line below the new steps moved: two lines for anything above old `:L96`, nine for anything at or
  below old `:L97`, as RN-175 measured from the diff's two hunks. Re-pinning the count and leaving
  twenty-nine stale locators would fix the item's heading and leave the bullet false, so the fold
  re-pins the whole list.

  *Check 4.* **Stale:** this is a dated, pinned reading, and the bullet's own rule makes the next
  suite a re-measurement. **Empty**, **absent**, **concurrent** and **refused** do not apply to a
  count of files at a commit.

## Left for the owner

None this run.

## Skipped

None this run.

## Raised on this document

### 2.1 — § 5 does not say where the Git view's memory ceiling stands against QC-45

- **What the document is owed:** § 5 names the 154,000,000-byte Git view memory ceiling that the
  gate now holds, as a regression bound the delivery tier set. It says the ceiling is not a product
  requirement, and that making it one is the SRS's by revision under QC-45's own rule.
- **Why it is worth a cycle:** this falls under *It contradicts a document it must agree with* in
  `<CORE>/../skills/companion/.claude/skills/companion-self-answer/prompts/rich.md` § The items are
  not the whole of what a document is owed. Here the "document" is the tree that the constraint set
  binds. § 5 says it "asserts no number of its own", and QC-45 opens "A performance number is
  measured, never asserted" (`docs/nfdr.md:L1794-L1796`, `:L1798`). Since `21f611f`,
  `ka-reader-mac/Tests/ShellTests/GitViewMemoryBoundTests.swift:L18` asserts
  `riseBound = 154_000_000`, and *Git view memory bound* (`checks/gate.sh:L104`) holds it at every
  change. No SRS, SDD or FDR revision carries the figure. The SDD records it only as the suite's
  (`docs/SDD.md` § 3 `read-only-harness`, RN-175). QC-45's ban names latency and folder size, not
  memory, so nothing in § 5 is false as worded. The run is unsure the gap is worth a cycle and says
  so in the item. It raised the item because §§ 3.1–3.2 already owe this file a fold, so this costs
  no extra run, and a cold reader otherwise cannot tell whether the suite breaks QC-45 or the NFDR
  has not seen it. The item's lean goes in *choices to confirm* and its slot is left for the next
  round.

## Companions opened

None this run.

## Launchers owed

- **docs/adr/ and docs/nfdr.md** — `<CORE>/launchers/skill/launcher.sh product-architecture ka-reader`
