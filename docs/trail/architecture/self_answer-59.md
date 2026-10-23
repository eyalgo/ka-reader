# Self-answer report — `docs/adr/` and `docs/nfdr.md`

## Header

- **Companion:** `docs/architecture_open_issues.md`
- **Document:** `docs/adr/` and `docs/nfdr.md`. The one open item names `docs/nfdr.md` QC-15 and
  touches no record.
- **Decided by:** `<CORE>/../skills/companion/.claude/skills/companion-self-answer/prompts/rich.md` v1.3.1
- **Date:** 2026-10-23
- **Sources re-read:** None. The answer rests only on sources in this repository, re-measured at
  `HEAD` `ka-reader@7f1c949`. `git diff --stat 82a3fb1 7f1c949 -- checks` prints nothing, so the
  scan and its suite at `HEAD` are the same as at `82a3fb1`.
  - `checks/structure.sh` at `48308ff`: `:L77-L80` is the start of the QC-15 filesystem row, listing
    the three owner files, which are spelled `nozoki-*` there. `:L1161` is the exempting `case`
    pattern. `:L253-L256` is the *WHAT IS NOT HELD* bullet on QC-15's two `git-reader` parts.
    `:L266-L267` is the `Path`-method gap. In `checks/tests/test_structure.sh`, `:L961` defines
    `test_exemption_is_exact_for_the_adapter_name` and `:L931` defines
    `test_git_owner_write_is_still_one_qc2_finding`.
  - The same files at `82a3fb1` and `7f1c949`. The QC-15 row is `:L82-L85`, the `case` pattern
    `:L1451`, the two-parts bullet `:L327-L330`, *GAPS THE RULES ABOVE DO NOT CLOSE* `:L338` with
    the `Path`-method sentence at `:L341-L342`, and the two cases at `:L988` and `:L958`. The old
    unpinned lines `:L253-L256`, `:L266-L267`, `:L931` and `:L961` now land inside other rows and
    other cases' bodies.
  - `crates/ka-reader-core/src/git_reader/config_scan.rs`: `scan` is at `:L66` at `66f428d` and
    `076eac2`, and at `:L93` from `c915d52` through `HEAD` (`git log --follow`). `alternates_scan.rs`
    has `scan` at `:L28` at `66f428d` and `:L29` at `HEAD`. Run over both scanner files at `HEAD`,
    the tail's `grep -nE 'std::fs|File::|read_to|OpenOptions|read_link|metadata'` still prints
    nothing.
  - The NFDR, `docs/nfdr.md` v63: the header and its citing rule (`:L1-L45`), § 1's opening, all of
    § 1.3 (QC-15 – QC-17, `:L590-L717`), RN-71, RN-72, RN-73 and RN-74 (`:L6501-L6701`), and every
    line that names QC-15 (`grep -n`). The NFDR runs to 6,701 lines and was not read whole. The ADRs
    were not opened, because the item moves no record and RN-74 records that no ADR cites
    `checks/structure.sh`.

## Items worked

### 2.1 — QC-15's *verified by* cites four unpinned lines of the scan and its suite, and at `ka-reader@c35081a` each lands on a different passage

- **Bucket:** 2. Choices to confirm — the Principal Architect drafted a best-effort answer; confirm or override
- **Verdict:** confirmed with addition
- **Why:** The draft is right, for the reason it gives. It leaves one thing open (which commit) and
  misses two neighbouring cases, so I confirmed it with those added.
  - **Seat (check 1).** It is the Principal Architect's, decided here in the owner's seat. The edit is
    QC-15's *verified by* tail in `nfdr.md`. It commits no person and no outside party, moves no ADR,
    and changes no obligation. It corrects pointers, so it is a correction and not a widening.
  - **The draft holds (check 2).** I re-measured every claim at source and did not take them from
    the item. At `48308ff` all four locators named what the tail says they name. At `82a3fb1` and at
    `HEAD`, `:L253-L256` and `:L266-L267` fall in other scan rows and `:L931` and `:L961` fall in
    other cases' bodies. The passages are now where the item says: `:L327-L330`, `:L341-L342`,
    `:L958` and `:L988`. What the tail *claims* is still true. *WHAT IS NOT HELD* still names the
    adapter's in-file reads and `git-reader`'s `Path`-method reads, and still says review at
    development-design holds both. Only the pointers are false.
  - **Addition 1: which commit.** The draft says "a named commit" and does not name one. That
    restates part of the question, so I answered that part. The commit is `82a3fb1`, the merge that
    landed scan v1.6.0, which QC-11's tail has carried since v63 (RN-74). `checks/` is unchanged from
    it through `HEAD`. Sharing the pin means the next scan change makes both tails stale at the same
    commit, and one re-measurement repairs both.
  - **Addition 2: the tail's other locators.**
    - **The two already pinned at `48308ff`** (`:L77-L80`, `:L1161`). They are true at their pin, so
      leaving them would be defensible. I chose to move them to `82a3fb1` (`:L82-L85`, `:L1451`),
      with the old reading in a dated note, for two reasons. First, at `48308ff` the owner files are
      spelled `crates/nozoki-*`, while the tail spells them `crates/ka-reader-*`, so a reader who
      follows the pin finds names the sentence does not use. Second, two different pins in one
      sentence is what produced this item: the later locators read as if they inherited the earlier
      pin. RN-74 did the same for QC-11, re-pinning every scan locator in the tail, including ones
      that had not moved.
    - **The `config_scan.rs:L66` locator.** It is not into the scan or its suite. It sits in the same
      tail and has the same defect: its parenthesis carries no commit, and the `66f428d` pin appears
      only in the next parenthesis, on `alternates_scan.rs`. It is true at `66f428d` and reads
      `:L93` at `HEAD`. Writing `66f428d` into its own parenthesis is a smaller change than
      re-measuring, and it is true. The no-I/O `grep` the sentence cites still prints nothing at
      `HEAD`, so the claim stands.
    - **Not added:** the `libgit2.rs` locators. Each is pinned at its own commit (`6a0725c`,
      `076eac2`, `66f428d`) and none of them is the defect this item names.
  - **Check 3 (the settled record).** RN-71 fixed QC-2's unpinned locators the same way, and RN-74
    fixed QC-11's, so this answer agrees with both. § 10's QC-15/QC-17 row names the scan and its
    suite and no line, so it does not move. The NFDR header's own scan locator is pinned at
    `463acb9`, so it is out of scope. No earlier answer in this run conflicts, because this run
    worked one item.
  - **Check 4 (the failure paths).**
    - *Stale:* a pinned locator stays true of its commit, which is the point of pinning. The next
      scan change makes the tail point at the past, not into the wrong row.
    - *Concurrent:* if a change to `checks/` lands before the fold, the fold still pins `82a3fb1` and
      reads the lines there. It does not re-measure at a moved `HEAD` under the old pin.
    - *Empty / absent / refused:* none applies to a citation.
  - **What would have tipped it.** If the fold re-pinned only the four lines the item names, that
    would be a plain *confirmed*, and it would be enough if the owner wants the smallest edit. In
    that case addition 2 should be dropped and the four lines pinned at `82a3fb1`. An *override*
    would have been right only if *WHAT IS NOT HELD* no longer named the two parts. It still does.

## Left for the owner

None this run.

## Skipped

None this run.

## Companions opened

None this run.

## Launchers owed

- **`docs/adr/` and `docs/nfdr.md`** — `<CORE>/launchers/skill/launcher.sh product-architecture ka-reader`
