# Self-answer report — `docs/adr/` and `docs/nfdr.md`

This report records one unattended run that answered `docs/architecture_open_issues.md` in the
owner's seat. It is written for the owner, who reads it to learn what was decided and why, and for the
`product-architecture` run that folds the answers.

## Header

- **Companion:** `docs/architecture_open_issues.md`
- **Document:** `docs/adr/` and `docs/nfdr.md`
- **Decided by:** `decide_companion_answers.md` v1.3.0
- **Date:** 2026-10-03
- **Sources re-read:** None. Both answers rest on this repository alone: on `checks/`, `crates/`
  and `.github/` at `ka-reader@188b141`, and on commands run against them, which are named in each
  entry. Nothing outside the repository was relied on, and nothing was read on the web.

**What this run read.** The companion, whole. From `docs/nfdr.md`: the header and preamble
(`:L1-L44`), all of § 1 (`:L48-L489`), the opening of § 2, the `#[path]` passage of § 9
(`:L1230-L1260`), § 10's preamble and its QC-4 and QC-5 rows (`:L1456-L1481`), and RN-43 and RN-44
whole (`:L3840-L3990`). ADR-0018, whole. `docs/SDD.md`, grepped for the owner-file and
`structure.sh` wording (none of its lines moves on either item). The script: `checks/structure.sh`'s
*THE SCAN TABLE* QC-15 row (`:L60-L93`), *WHAT IS NOT HELD* and *GAPS*
(`:L235-L275`), and the exempting `case` (`:L1140-L1180`). The four new git-owner tests in
`checks/tests/test_structure.sh`. The probe's functions in
`crates/ka-reader-core/src/git_reader/libgit2.rs`, and the test names in
`crates/ka-reader-core/tests/root_finding.rs`. **Not read whole:** `docs/nfdr.md` (373 KB) and
`docs/SDD.md` (492 KB). Each answer is checked against the entries it moves or rests on, which are
listed above.

**Run, not only read, at `ka-reader@188b141`.** `bash checks/structure.sh` prints "14 Rust files in 2
crates read — nothing found" and exits 0. `bash checks/tests/test_structure.sh` exits 0, with 88
`ok` lines. `cargo test --locked -p ka-reader-core --test root_finding` prints "37 passed; 0 failed".
`git diff --stat 48308ff 188b141 -- checks crates` prints nothing, so a pin at the merge
`ka-reader@48308ff` is a pin on this tree.

## Items worked

### 3.1 — QC-15's *verified by* describes a two-owner scan and an owner rule still to come; the script now holds three owners

- **Bucket:** 3. Raised from downstream — an item from a seat that did not write these records
- **Verdict:** confirmed with addition
- **Why:** **Fold it as the PM proposed, and add three things.**

  *Treated as a draft.* The item ends with "The likely fold:", which is a lean. Under
  `decide_companion_answers.md` § *The two buckets*, a lean makes it a draft to weigh, not a
  question to answer from scratch. That is why the verdict is a confirm and not *answered*.

  *Check 1 — whose.* The edit lands in `docs/nfdr.md` QC-15, this companion's own document. It binds
  only the record's agreement with the tree: no person, no outside party, no risk anyone carries.
  This seat answers it.

  *Not a widening.* QC-15 states a split between what the script holds and what review holds, and
  the tree moved under that statement. Correcting a statement found false is not a widening
  (§ *A widening item waits until it occurs*), so the "not until it occurs" rule does not apply.

  *Check 2 — is the draft sound?* Every measurement the item gives matched the tree when re-read.
  `checks/structure.sh:L77-L80` says "In every crate except in the three owner files" and names
  `fs_reader.rs`, `log_writer.rs` and `git_reader/libgit2.rs`. The `case` at `:L1161` exempts
  exactly those three paths. *WHAT IS NOT HELD* (`:L253-L256`) lists two unheld parts of QC-15's
  filesystem owners: which read the adapter makes inside its owner file, and `git-reader`'s
  `Path`-method reads. It no longer names "QC-15's other owners" as not held. In `libgit2.rs`, the
  `Path`-method reads sit at `:L38` (`folder.metadata()`), `:L42` (`symlink_metadata`) and `:L136`
  (`symlink_metadata` on `.git/HEAD`), the `.git` file's open at `:L62`, and its handle's
  `metadata()` at `:L69`. RN-43 named "the adapter's file added to the clause's owner files by
  exact path" as this document's realization (`docs/nfdr.md:L3851-L3855`), and the change has now
  landed it. So the draft's conclusion holds, and for the reason it gives. It is incomplete in two
  places, below.

  *Addition 1 — the exact path has its own test, and the tail should name it.* RN-43's realization
  makes a `std::fs` read anywhere else in `git-reader` a finding. Two new suite cases now hold that.
  `test_exemption_is_exact_for_the_adapter_name` (`checks/tests/test_structure.sh:L961`) plants a
  `std::fs::write` under the adapter's file name at six other paths: `git_reader.rs`, `libgit2.rs` at
  the crate root, a deeper `git_reader/sub/`, a different parent, the bridge, and another crate. It
  requires a QC-15 finding at each. `test_git_owner_write_is_still_one_qc2_finding` (`:L931`) holds
  that the exemption lifts only the filesystem clause, so a write API in the adapter is still a QC-2
  finding. Naming them in the tail gives the realization an enforcement surface someone can see,
  and that is the point of a *verified by*.

  *Addition 2 — "only" narrows the review gate, not the gap statement.* The draft says review stays
  "the gate for those two unheld parts only". Read alone, that could drop the sentence QC-15 carries
  today: the scan "does not see a `Path` method that touches the filesystem". That gap is not
  `git-reader`'s alone. A `Path::metadata` call in `folder-model` or `watcher` is just as unseen, and
  the script still names it as a general gap (`:L266-L267`, *GAPS THE RULES ABOVE DO NOT CLOSE*). So
  the gap sentence stays for every crate and is re-pinned to `:L266-L267`. Only the `development-design`
  gate for the *bounded reads* narrows to the two parts.

  *Addition 3 — no record in the log moves.* ADR-0018 binds QC-15 (`## Binds`), and every line it
  cites is pinned at `ka-reader@8edec4f`, where it still reads as quoted. The decision ("`probe` reads
  only inside the opened folder") did not move. Its realization in the script landed. A realization
  landing is not a decision moving, so there is nothing to supersede.

  *Check 3 — does it contradict anything settled?* No. QC-15's body (`:L400-L407`) is unchanged; only
  its tail moves. QC-2's *verified by* already names the write rule the second test holds. § 10's
  QC-15/QC-17 row (`:L1488`) names `checks/structure.sh (suite test_structure.sh)`, which already
  covers the new cases, so the row does not move. The NFDR's header rule ("a rule a command names
  becomes executable in the change that adds that rule", `:L36-L38`) is what makes the old "until"
  clause expire, so the fold applies the document's own rule.

  *Check 4 — failure paths.* **Stale:** the next edit to `checks/structure.sh` moves these line
  numbers. Pinning them at `ka-reader@48308ff` turns that into a re-measurement rather than a
  contradiction, as § 9 already says of its own pinned counts (`:L1245-L1247`). **Absent:** if the
  adapter file is renamed or moved, the exemption no longer matches. A `std::fs` read at the new path
  then becomes a QC-15 finding, so the bound fails closed, and the exactness test is what proves it.
  **Concurrent / empty / refused:** none applies to a source scan's statement of coverage.

  *What was close.* I nearly answered *confirmed* without additions. Addition 2 is what tipped it: a
  fold that reads "only" literally deletes a gap statement that is still true, and it does so
  silently, in the one entry that says which I/O nothing is checking.

## Left for the owner

None this run.

## Skipped

None this run.

## Raised on this document

### 2.1 — QC-5's *verified by* says its three named cases are unwritten and go red until the provisional `.git`-file arm is replaced; the same change that made QC-15's third owner replaced the arm, and all three cases are written and pass

- **What the document is owed:** QC-5's tail should state its three named cases as written and
  passing at `ka-reader@48308ff` (`crates/ka-reader-core/tests/root_finding.rs:L175`, `:L185`, `:L196`).
  The "none written / go red until" clause becomes a dated parenthetical. § 10's QC-5 row and
  ADR-0018 do not move.
- **Why it is worth a cycle:** *A fact in it is now false*, measured. QC-5 (`docs/nfdr.md:L194-L198`)
  says "None of the three is written at `ka-reader@8edec4f`" and "All three go red when they are
  written, until the change that replaces that arm lands". The pinned half is still true at its
  commit. The forward clause is not true of the tree: the arm is replaced (`libgit2.rs:L46` sends a
  `.git` regular file to `probe_git_file`, `:L58`), and `cargo test --locked -p ka-reader-core --test
  root_finding` at `ka-reader@188b141` passes all three named cases among 37. A reader of QC-5 learns
  that the read bound has no check, when it has one that CI runs (`.github/workflows/ci.yml:L26`).
  The fold costs almost nothing extra: § 3.1 already sends `product-architecture` to re-measure
  this same merge. It is in *choices to confirm* because this run has a lean; its slot is the next
  round's.

## Companions opened

None this run.

## Launchers owed

- **`docs/adr/` and `docs/nfdr.md`** — `<CORE>/launchers/skill/launcher.sh product-architecture ka-reader`
