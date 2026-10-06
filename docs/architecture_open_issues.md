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

> **No `product-architecture` run wrote this file.** The PM opened it on 2026-10-06 from the
> architecture companion template. The alternates check is now built (`nozoki@66f428d`), and four
> passages of the records still say it is not: three in `nfdr.md` (QC-6, QC-15, QC-35) and one in
> ADR-0022. Both records are Settled or Accepted, and with no companion on disk a
> `product-architecture` re-run reads them as done and has nothing to act on. Its two items are in § 3.

---

## 1. Open issues — questions with no answer yet

None.

## 2. Choices to confirm — the Principal Architect drafted a best-effort answer; confirm or override

None.

## 3. Raised from downstream — an item from a seat that did not write these records

### 3.1 QC-6, QC-15 and QC-35 say the alternates read is not built, and it is
- **Raised by:** PM — 2026-10-06
- **Which record:** `nfdr.md` QC-6, QC-15 and QC-35
- **Tracked by:** `nozoki · nemawashi · 2026-10-02_git-says-what-changed`
- **What it blocks:** nothing is cut by it. QC-15's list says the change that builds the read "owes
  this list that read", and this is that item.
- **Where it shows:** QC-6, *Still uncovered* (b): "the alternates read, whose refusal is stated and
  not built, with the sandbox its only bound in the bundle and nothing in the harness"
  (`docs/nfdr.md:L282-L284`). QC-15: "The alternates read is owned by SDD § 3's `git-reader` row and
  is not built … so the list does not name it until it occurs" (`:L546-L549`). QC-35, *Not
  covered* (1): "the `objects/info/alternates` read and a `.gitmodules` section's path, whose
  refusals are stated and not built" (`:L1025-L1027`). At `nozoki@66f428d` the read is the
  adapter's, in its owner file: `check_alternates` (`crates/nozoki-core/src/git_reader/libgit2.rs:L303`)
  reads each alternates file through `read_alternates` and the walk's `inspect_on_disk`, and the
  line rule it parses with reads nothing (`crates/nozoki-core/src/git_reader/alternates_scan.rs`,
  where `grep -nE 'std::fs|File::|read_to|OpenOptions|read_link|metadata'` prints nothing). The
  fixture `checks/fixtures/alternates-names-outside` and its case in
  `crates/nozoki-core/tests/git_state.rs` hold the read in the harness, in-process; no case runs it
  on the built bundle. The `.gitmodules` half of QC-6 (a) and QC-35 (1) is still not built
  (`docs/SDD.md:L345`, "the section-path refusals and the refusal on the submodule map are not
  built"). The likely fold: QC-15's list names the alternates reads, and QC-6 and QC-35 keep only
  the `.gitmodules` refusals as uncovered.
- **If a document has to be written:** none. A change in `nfdr.md`, written by `product-architecture`.
- **Answer:** Confirmed, with additions. The record is now false, and folding the correction is this document's own work. Re-derive QC-6, QC-15 and QC-35 from `docs/SDD.md` v43 (Settled, RN-103). Its § 11 R-16 *Until the checks are built* and *The proof* state the alternates check and its case as in the tree at `nozoki@66f428d`, and its *Open Questions* config-named-path item is open on the `.gitmodules` case alone. That is the fresh authorization. Five changes follow. (1) **QC-15**: the list names the alternates check's reads, as SDD § 3's `git-reader` row states them. Before libgit2 opens anything, it reads `objects/info/alternates` under the common directory, and the `info/alternates` of each alternate object directory that spells inside the folder, to libgit2's depth of five. It reads the metadata, and a link's own text, at each position along the spelled path of `objects`, `info`, `alternates` and each entry. Each verified submodule gets the same reads. The tail names `check_alternates` (`crates/nozoki-core/src/git_reader/libgit2.rs:L303`) beside `check_config`, and the scanner `alternates_scan::scan`, which takes bytes and reads nothing, beside `config_scan.rs`. The sentence "The alternates read … is not built … so the list does not name it until it occurs" moves to a dated note. (2) **QC-6** *Still uncovered*: (b) leaves, and only (a), the `.gitmodules` section path and the submodule map, remains. "open on its alternates and `.gitmodules` cases" becomes open on the `.gitmodules` case alone. (3) **QC-35** *Not covered* (1): the alternates read leaves the not-built clause. The clause about a file rewritten between the check and libgit2's read keeps "alternates", because that limit stands. (4) **QC-35** *verified by*: this addition is not in the item. Name the fifth FIFO case, `test_the_outside_object_directory_is_never_read_on_the_three_calls` (`crates/nozoki-core/tests/git_state.rs:L1733`), beside the four. Say what SDD v43's *The proof* says it does not watch: a `stat` of the outside directory. That no such `stat` happens rests on the check running before the open (`libgit2.rs:L112-L115`). Also say that no case runs the check on the built bundle. Re-pin the count: 82 passed at `nozoki@4a49995`, whose tree outside `docs/` is `nozoki@66f428d`'s. The four-case tail would otherwise understate what the harness holds. (5) Keep ADR-0022 in each entry's trace, and name SDD v43 RN-103 as the source. Reasoning: `docs/trail/architecture/self_answer-43.md`.

### 3.2 ADR-0022 lists the alternates check and its case as not built, and both are in the tree
- **Raised by:** PM — 2026-10-06
- **Which record:** `adr/0022-git-reader-refuses-a-repository-whose-config-names-a-location-outside-the-folder.md`
- **Tracked by:** `nozoki · nemawashi · 2026-10-02_git-says-what-changed`
- **What it blocks:** nothing is cut by it. A reader of the record is told the sandbox is the only
  bound on the alternates read in the bundle and that nothing bounds it in the harness.
- **Where it shows:** *Built and not built, at `nozoki@076eac2`*: "Not built: the alternates check
  (`grep -rl alternates checks crates nozoki-mac/Sources` prints nothing) … The proof's alternates
  case and its `.gitmodules` case are owed before `see-git-status` is reached"
  (`docs/adr/0022-git-reader-refuses-a-repository-whose-config-names-a-location-outside-the-folder.md:L117-L127`).
  At `nozoki@66f428d` that grep lists seven files under `crates/`, among them
  `crates/nozoki-core/src/git_reader/libgit2.rs`, where `check_alternates` is defined (`:L303`) and
  called (`:L114`, `:L449`, `:L475`). The alternates case is in `crates/nozoki-core/tests/git_state.rs`
  over `checks/fixtures/alternates-names-outside`. The `.gitmodules` section-path refusals and the
  refusal on the submodule map are still not built. The record is Accepted, so how it takes the
  correction (a re-measured paragraph, or a note beside it) is the record's seat's call.
- **If a document has to be written:** none. A change to ADR-0022, made by `product-architecture`.
- **Answer:** No change to ADR-0022. Neither form the item offers is open to an Accepted record. `product-architecture`'s own rule is that once Status reads Accepted the file is never rewritten, and the only line that ever changes is the Status line, on supersession (`SKILL.md:L75`). A re-measured paragraph and a note beside it would both touch the body. Superseding it fails the significance test, because nothing was decided anew: the check the record decided is the check that was built. The paragraph is also not false. Its heading pins it, *Built and not built, at `nozoki@076eac2`*, and at that commit the alternates check was not built. A pinned measurement in an accepted record is history, which is how RN-53 read ADR-0020's sentence pinned to SDD v27. Its own wording also anticipates the change: "Until they land, the sandbox is the only bound". The present state lives where the log sends a reader. ADR-0022's `## Binds` names QC-6, QC-15, QC-30 and QC-35, and the answer to § 3.1 carries the built state into QC-6, QC-15 and QC-35. Decided together with § 3.1. Uncovered, and named: a reader who opens ADR-0022 alone and reads past its pin still meets the old state. The pin and `## Binds` are the only guard against that. Reasoning: `docs/trail/architecture/self_answer-43.md`.
