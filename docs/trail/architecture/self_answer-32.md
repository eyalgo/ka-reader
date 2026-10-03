# Self-answer report — `adr/` and `nfdr.md`

## Header

- **Companion:** `docs/architecture_open_issues.md`
- **Document:** `docs/adr/` and `docs/nfdr.md` (NFDR v30, Settled; the companion was opened by the
  PM at `nozoki@7a8f61d`, not by a `product-architecture` run)
- **Decided by:** `decide_companion_answers.md` v1.3.0
- **Date:** 2026-10-03
- **Sources re-read:** None. The one answer rests only on files in this repository at
  `nozoki@7a8f61d`: `docs/nfdr.md` §§ 1–10 (read whole) and the Review Notes that name these sites
  (RN-19's fold at `:L1968-L1998`, RN-36, RN-37); `checks/structure.sh` (header, *WHAT IS READ*,
  *THE SCAN TABLE*, *WHAT IS NOT HELD*); the three `#[path]` declaring files and their three bodies.
  The § 9 bullet's own external citation (the Rust Reference on `#[cfg(test)]`, re-read 2026-10-03
  by v30) is one this answer does not lean on: nothing here turns on what `#[cfg(test)]` compiles,
  only on where the three sites are and what the script reports.

## Items worked

### 3.1 — § 9's `checks/structure.sh` scope bullet names two `#[cfg(test)]` `#[path]` sites; the tree holds three

- **Bucket:** 3. Raised from downstream — an item from a seat that did not write these records
- **Verdict:** confirmed with addition
- **Why:** The PM's likely fold is right: § 9 names three sites. But the draft's reason for adding
  QC-2 is narrower than the tree, and two sentences of the bullet would go wrong if the fold only
  appended a third site to them.

  *Check 1 — whose.* The edit lands in `docs/nfdr.md` § 9, which is these records' own document,
  and it binds nothing outside the document's agreement with the tree. No ground I cannot see bears
  on it. It corrects a count that is now false, so it is not a widening
  (`decide_companion_answers.md` § *A widening item waits until it occurs*: "Correcting a statement
  found false is not widening"). It is mine to answer in the owner's seat.

  *Check 2 — is the draft sound.* Every measurement in the item holds at `nozoki@7a8f61d`:
  - `crates/nozoki-core/src/fs_reader.rs:L894-L896` reads `#[cfg(test)]`,
    `#[path = "../tests/unit/fs_reader.rs"]`, `mod tests;`.
  - `crates/nozoki-core/tests/unit/fs_reader.rs:L753` and `:L953` are `fs::write` calls.
  - The bullet's current text is at `docs/nfdr.md:L1076-L1082`, and RN-36's "two `#[cfg(test)]`
    sites" is at `:L3384`.
  - The two existing sites' pointers still hold: `crates/nozoki-core/src/lib.rs:L18-L24` and
    `crates/nozoki-bridge/src/lib.rs:L10-L16` are each a gated `mod test_support`, and the bodies'
    `use std::fs;` / `use std::process;` are at the lines the bullet cites.

  The draft is incomplete in two places.

  1. **The third body is not like the other two.** It imports no `std::process`. It gets `fs`
     through `use super::*` from `fs_reader.rs:L6`, and it imports
     `std::os::unix::fs::PermissionsExt` itself (`tests/unit/fs_reader.rs:L5`). Judged by module,
     it belongs to `fs_reader.rs`, the file QC-15 exempts by exact path (`checks/structure.sh`,
     *THE SCAN TABLE*, QC-15 filesystem row). So it adds no QC-15 and no QC-36 finding. The
     sentence "both bodies import `std::fs` and `std::process`" has to stay about the two
     `test_support` bodies. Rewriting it to "all three" would be false.
  2. **QC-2 is not owed by the third site alone.** The script's QC-2 row reads every shipped file
     of `nozoki-core`, with `fs_reader.rs` included ("no file exempt"). That row entered the script
     at `nozoki@e7f151e`, in the same merge as the body move (`nozoki@73c408e`), and both are after
     NFDR v30 (`git merge-base --is-ancestor 0b62d5f <commit>` exits 0 for `e7f151e` and for
     `04ad072`). So, judged by module, the core's `test_support` body raises QC-2 as well:
     `crates/nozoki-core/tests/common/mod.rs:L9` (`symlink` in a `use` tree), `:L33`, `:L47`,
     `:L55`, `:L57`, `:L65`, `:L81`. The bullet's list was not short by one site. Its rule set
     moved under it in the same change.

  *How the findings were measured, not inferred.* I made a throwaway clone at `nozoki@7a8f61d`,
  copied each `test_support` body into its crate's `src/`, and appended the `fs_reader` test body
  to `fs_reader.rs`, so that the owner exemption still applied to it. Then I ran the unmodified
  `checks/structure.sh`. The baseline run printed `12 Rust files in 2 crates read — nothing found`.
  With the bodies in place it printed:
  - **QC-2:** the core body's seven lines above, and the fs_reader body's two lines (at
    896 + 753 and 896 + 953).
  - **QC-15:** the core body at `:L8` and `:L9`, and the bridge body at `:L2`, `:L8` and `:L10`.
  - **QC-36:** the core body at `:L11` and the bridge body at `:L13`. The core's line is also a
    **QC-9** finding (the script's process row reports "In nozoki-core the same occurrence is also
    a QC-9 finding").

  So the measured set is QC-2, QC-9, QC-15 and QC-36 in `nozoki-core`, and QC-15 and QC-36 in
  `nozoki-bridge`. QC-9 was already missing from the bullet at v26, since the script's process
  clause dates from its v1.0.0. The fold should state the list as measured, with the commit it was
  measured at.

  *The addition, and why it is not taste.* The count went false silently because it was written
  with no commit and no command. § 9's own `checks/tests/` bullet already takes the form that
  prevents this: "The count and the lines are dated and pinned … a re-measurement of this sentence
  and not a contradiction of it" (`docs/nfdr.md:L1110-L1112`). The fold should pin the site count
  the same way, with the command that produces it. `grep -rn '#\[path' crates/*/src` prints exactly
  the three `src/` sites. The item's `grep -rn '#\[path' crates/` also lists
  `crates/nozoki-core/tests/walk.rs:L6`, a test target, and a doc comment at
  `crates/nozoki-bridge/tests/common/mod.rs:L3`, and both have to be read out by hand.

  *Check 3 — does it contradict anything settled.* No. The scope stays by file path, as RN-37
  decided for §§ 3.3 and 3.4 of cycle 23. No rule moves and no `QC` is touched. The escape
  sentence ("the reading is safe only while the module stays gated") still holds, because all
  three sites carry `#[cfg(test)]`, and the third does at `fs_reader.rs:L894`. RN-36 is a dated
  fold note ("re-run for this fold"), so I agree with the item that it is left as written. No ADR
  names these sites (`grep -rnE '#\[path|tests/unit|tests/common' docs/adr` prints nothing). QC-6's
  tail cites `fs_reader.rs` `mod tests` at `:L412-L578` pinned to `nozoki@368f127`. That is still
  true at its pin, and the module is still declared in that file.

  *Check 4 — failure paths.* **Stale:** a fourth site, or a site removed, makes a pinned count a
  re-measurement rather than a contradiction. That is the addition's point. **Absent:** if a body
  moves back inline under `src/`, it is inside every rule (`test_inline_test_module_is_scanned`,
  `checks/tests/test_structure.sh:L819`), and its `fs::write` lines fail QC-2 loudly. Nothing
  passes silently. **Refused (the ungated case):** a `#[path]` into `tests/` without
  `#[cfg(test)]` is still the review catch the bullet names, and no site in the tree is ungated
  today. **Not covered, and named:** the measured findings list holds for the rules the script has
  at `nozoki@7a8f61d` (v1.3.0). The next rule added to the script can lengthen it, which is why the
  list is stated with its commit and not as permanent.

  I came close to *confirmed*. What tipped it is that the draft's one-line fold ("add QC-2 to the
  findings") would have recorded the wrong cause, a third site, for a change whose larger cause was
  the script gaining a rule. It would also have left QC-9 missing.

  *Seen while reading, not raised.* Two things, judged below the bar for reopening a document. (a)
  § 9's layer-1 row says unit tests live "inside each `nozoki-core` / `nozoki-bridge` module". The
  `fs_reader` tests are still a child module of `fs_reader` in the module tree, so the row is
  literally true. A reader looking for them finds the declaration and follows it. That would become
  worth a cycle if a second module's tests moved under `tests/unit/` and that became the norm the
  row does not describe. (b) `checks/structure.sh` *WHAT IS NOT HELD* lists QC-7, QC-12, QC-15's
  other owners and QC-20. It does not list QC-63, and the scan table says the core's value modules
  are "never a subject". So QC-63's import rule is not held, which its NFDR tail already says
  ("until the change that adds it, its gate is `development-design`"). The gap is in the script's
  header, a delivery-tier file, not in either record, so it is not this companion's.

## Left for the owner

None this run.

## Skipped

None this run.

## Companions opened

None this run.

## Launchers owed

- **`docs/adr/` and `docs/nfdr.md`** — `<CORE>/launchers/skill/launcher.sh product-architecture nozoki`
