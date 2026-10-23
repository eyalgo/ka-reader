# Self-answer report — `docs/adr/` and `docs/nfdr.md`

## Header

- **Companion:** `docs/architecture_open_issues.md`
- **Document:** `docs/adr/` and `docs/nfdr.md`. The one open item names `docs/nfdr.md` and touches no
  record.
- **Decided by:** `<CORE>/../skills/companion/.claude/skills/companion-self-answer/prompts/rich.md` v1.3.1
- **Date:** 2026-10-23
- **Sources re-read:** None. Every answer rests on sources in this repository, all re-measured at
  `ka-reader@c35081a`, whose `checks/structure.sh` and its suite are the same blobs as at `82a3fb1`
  (`git diff --stat 82a3fb1 c35081a` names only the companion):
  - `checks/structure.sh`, v1.6.0: its version line (`:L2-L3`), *THE SCAN TABLE* (the unit-edge row
    `:L110-L149`, the libgit2-binding row `:L167-L181`), *WHAT IS NOT HELD* (`:L321-L336`), *GAPS
    THE RULES ABOVE DO NOT CLOSE* (`:L338` onward) and the exempting `case` (`:L1459`). Running
    `grep -c -F "QC-11's clauses whose subject is" checks/structure.sh` prints `0`.
  - The scan and its suite, run in a disposable clone at `c35081a`: `checks/structure.sh` exits 0
    and prints "17 Rust files in 2 crates read — nothing found". `checks/tests/test_structure.sh`
    exits 0 with 112 `ok` lines and no failing case.
  - The same scan at `076eac2`, `fc14574`, `48308ff`, `c915d52` and `ae72bdc` (`git show`), to tell
    which locators were true at the commit their passage names and when they moved.
  - `crates/ka-reader-bridge/src/machine_config.rs:L135-L140`: the adapter's constructor,
    `Arc::new(Libgit2)`, is still in the file the scan exempts whole. Running
    `grep -rln git2 crates/ka-reader-bridge` prints the manifest, `src/machine_config.rs` and
    `tests/search_path.rs`.
  - The NFDR, `docs/nfdr.md` v62: the header and its citing rule (`:L1-L45`); § 1 through QC-15's
    tail (`:L49-L625`); the QC-17 *verified by* (`:L660-L668`); § 10's rows that name
    `checks/structure.sh`; and every line that cites `structure.sh:L`. The NFDR runs to 6,626
    lines and was not read whole. No ADR cites `checks/structure.sh` (`grep -l` over `docs/adr/`).

## Items worked

### 3.1 — QC-11's *verified by* says the structure scan leaves three of its subjects unheld; the scan holds them

- **Bucket:** 3. Raised from downstream — an item from a seat that did not write these records
- **Verdict:** confirmed with addition
- **Why:** The item is right, and the fold should do what it proposes. The item carries a proposal
  (point the sentence at the scan's header and keep QC-11's review-held parts), so I weighed it as
  a draft rather than answering from scratch.
  - **Not a widening.** The item corrects a sentence that is now false and asks the NFDR to state
    nothing new, so the "not until it occurs" rule for downstream items does not apply.
  - **Seat.** The Principal Architect's. The edit is one sentence of `nfdr.md` QC-11 and its
    locators. It commits no person and no outside party, and no ADR moves.
  - **Check 2: the draft holds, for the reason it gives.** I re-measured every claim rather than
    taking it from the item. The scan's version line says v1.6.0 "holds … QC-11's git_reader,
    watcher and markdown_renderer subjects". The unit-edge row gives each of the three its forbidden
    set. *WHAT IS NOT HELD* names, of QC-11, only the bound on the `markdown-renderer` →
    `fs-reader` edge. The phrase the NFDR quotes is gone from the script. The scan and its 112-case
    suite pass. Pointing at the header rather than restating it is the NFDR's own rule: "Which rules
    a script holds is stated in the script's own header and is cited, never copied here"
    (`docs/nfdr.md:L40-L42`). The two review-held parts of the exception's bound still stand.
    `machine_config.rs` is exempted whole (`:L1459`) and still holds the constructor. `tests/` is
    still read for the layer-5 rule alone (`:L46-L47`), and the bridge files that name `git2` are
    still the bound exactly. The scan's new QC-17 adapter-construction rule reads only outside
    `crates/ka-reader-bridge/src/`, so it does not narrow the first part.
  - **The additions.**
    1. **The draft fixes one locator, and the same tail holds three more that are now false.** At
       `c35081a` the binding row `:L130-L142` is `:L167-L181`, the exempting `case` `:L1186` is
       `:L1459`, and the *tests/ for layer-5 only* locator `:L41-L42` is `:L46-L47`. All three were
       true at `076eac2`, the commit the tail names, and none carried a pin. They moved at the scan's
       2026-10-22 re-wrap (`ae72bdc`) and again at v1.6.0. A corrected sentence beside three false
       pointers would leave the entry half-repaired, so the fold re-pins all of them to a named
       commit. One small correction to the item's text: it says `:L270` "was stale before the scan
       moved, too". At `076eac2` that line is exactly the QC-11 not-held line. It went stale at the
       re-wrap, which is the scan moving.
    2. **`watcher` and `markdown-renderer` have no file today.** Their clauses are held as rules,
       not yet on any file of theirs. The scan says a file of either "is judged from the run in which
       it first appears, with no edit here", and `test_future_unit_files_are_judged_without_editing_the_scan`
       proves that on planted files. The corrected sentence should say so, so that "held" is not
       read as "measured on their code".
    3. **What the fold may cite.** Its ground is the scan's header and the suite at a pinned commit.
       The item's *Tracked by* line names a Nemawashi seed, and the definition set never names the
       journey, so that line stays out of the NFDR.
  - **Check 3.** QC-10's adapter clause (`docs/nfdr.md:L425`) and QC-17's constructor clause
    (`:L665-L666`) cite the scan and claim no gap, which agrees with v1.6.0. § 10's QC-9 – QC-12 row
    already names the scan and its suite, so it does not move. The NFDR header's own scan locator
    (`:L42`) is pinned at `463acb9`, so it is still true.
  - **Check 4.**
    - *Stale:* a pinned locator stays true of its commit. The header pointer survives the next rule
      the scan gains, which is why it is the better owner of the coverage account.
    - *Empty:* the two units with no file are covered by addition 2.
    - *Absent / refused / concurrent:* nothing in this sentence reaches them.
  - **What would have tipped it.** A plain *confirmed* would have been enough if the tail's other
    three locators had carried a pin. An *override* would have been right if *WHAT IS NOT HELD* had
    still named a `git-reader` or `watcher` clause. It does not.

## Left for the owner

None this run.

## Skipped

None this run.

## Raised on this document

### 2.1 — QC-15's *verified by* cites four unpinned lines of the scan and its suite, and at `ka-reader@c35081a` each lands on a different passage

- **What the document is owed:** QC-15's tail re-pins `checks/structure.sh:L266-L267` and
  `:L253-L256`, and `checks/tests/test_structure.sh:L961` and `:L931`, to a named commit. At
  `c35081a` those passages are at `:L341-L342`, `:L327-L330`, `:L988` and `:L958`.
- **Why it is worth a cycle:** *A fact in it is now false*
  (`<CORE>/../skills/companion/.claude/skills/companion-self-answer/prompts/rich.md` § The items
  are not the whole of what a document is owed). The two scan locators were right at `48308ff`, the
  commit the passage pins two sentences earlier, but they carry no pin of their own. At `HEAD` they
  land in the QC-17 adapter-construction row and the QC-2 write-API row. The two suite locators land
  inside other cases' bodies. What the tail says is still true; only its pointers are false. This
  is the same defect § 3.1 corrects in QC-11, and RN-71 treated it as worth a cycle for QC-2. The
  fold for § 3.1 runs anyway, so the added cost is one more entry in it. I was close to calling it
  not worth a cycle, on the reading that the earlier pin carries over. A reader at `HEAD` has no way
  to know that, which is what tipped it.

## Companions opened

None this run.

## Launchers owed

- **`docs/adr/` and `docs/nfdr.md`** — `<CORE>/launchers/skill/launcher.sh product-architecture ka-reader`
