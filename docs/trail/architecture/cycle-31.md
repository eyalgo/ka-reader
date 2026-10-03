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
> own companion template. `checks/structure.sh` now holds the `git-reader` adapter's file as a third
> QC-15 filesystem owner (`nozoki@48308ff`), and QC-15's *verified by* still describes the script as it
> stood before. The records are Settled, and with no companion on disk a `product-architecture` re-run
> reads them as done and has nothing to act on. Its one item is in § 3.

---

## 1. Open issues — questions with no answer yet

None.

## 2. Choices to confirm — the Principal Architect drafted a best-effort answer; confirm or override

### 2.1 QC-5's *verified by* says its three named cases are unwritten and go red until the provisional `.git`-file arm is replaced; the same change that made QC-15's third owner replaced the arm, and all three cases are written and pass

> **No `product-architecture` run wrote this item.** A `companion-self-answer` run raised it on
> 2026-10-03 while answering § 3.1 in the owner's seat. It read QC-5 beside QC-15, because the change
> § 3.1 measures (`nozoki@48308ff`, "probe answers root for a git file") is also the change QC-5's
> tail waits on. No item asked about QC-5. The slot below is the next round's.

- **Lands in:** `nfdr.md` QC-5
- **Drafted into the records:** Nothing yet — this run writes no record. Proposed: QC-5's *verified
  by* states the three cases it names as written and passing, pinned at `nozoki@48308ff`:
  `linked-worktree` answers `Root` (`crates/nozoki-core/tests/root_finding.rs:L175`), `submodule`
  answers `Root` (`:L185`), and a `.git` file naming a Git directory that does not exist answers
  `Root` (`:L196`), the case that goes red if `probe` ever follows the pointer. It drops "None of the
  three is written at `nozoki@8edec4f`" and "All three go red when they are written, until the
  change that replaces that arm lands", keeping them as a dated parenthetical in the document's own
  manner. The provisional arm is gone. The adapter answers a `.git` regular file through
  `probe_git_file` (`crates/nozoki-core/src/git_reader/libgit2.rs:L46`, `:L58`). § 10's QC-5 row
  does not move: it names the same command, and *the change* / `development-implementation` is the
  row shape QC-4's `cargo test` row also takes.
- **Rationale:** Something QC-5 says of the tree is no longer true. Its sentences are pinned at
  `nozoki@8edec4f` and still true there, but its forward clause, "until the change that replaces
  that arm lands", describes something that has already happened. The delivery tier reads QC-5 to
  learn whether the read bound has a check. As written, it learns that it does not.
  `cargo test --locked -p nozoki-core --test root_finding` at `nozoki@188b141` prints "37 passed; 0
  failed", including `test_linked_worktree_answers_root`, `test_submodule_answers_root` and
  `test_git_file_naming_a_missing_git_directory_answers_root`, and CI runs it under
  `cargo test --workspace --locked` (`.github/workflows/ci.yml:L26`). ADR-0018 does not move. Its
  § Consequences already says that case turns red if `probe` follows the pointer, and its citations
  are pinned at `nozoki@8edec4f`.
- **If overridden:** QC-5 keeps reading as though the bound has no check. A later change touching
  `probe` reads the entry and could treat those three cases as optional, when they are the check.
  The fold of § 3.1 still lands, and QC-5 stays out of step with QC-15, which by then names the same
  merge.
- **Confirm or override:** <"confirm", or "override: <what to do instead>">

## 3. Raised from downstream — an item from a seat that did not write these records

### 3.1 QC-15's *verified by* describes a two-owner scan and an owner rule still to come; the script now holds three owners
- **Raised by:** PM — 2026-10-03
- **Which record:** `nfdr.md` QC-15, its *verified by*
- **Tracked by:** `nozoki · nemawashi · 2026-10-02_git-says-what-changed`
- **What it blocks:** nothing fails: `bash checks/structure.sh` exits 0 ("14 Rust files in 2 crates read
  — nothing found"). The entry's *verified by* is what review reads to know which half of QC-15's
  `git-reader` bound a script holds and which half review holds, and it now gives the wrong split.
- **Where it shows:** `docs/nfdr.md:L408-L418` says the filesystem clause "exempts two owner files by
  exact path, `fs_reader.rs` and `log_writer.rs`", that the script "names QC-15's other owners as not
  held (`:L247`)", and that the rule adding `crates/nozoki-core/src/git_reader/libgit2.rs` is to come:
  "Until the change that adds it … the bound is review at `development-design`". The script now reads
  "In every crate except in the three owner files", naming `fs_reader.rs`, `log_writer.rs` and
  `git_reader/libgit2.rs` (`checks/structure.sh:L77-L80`, the exempting `case` at `:L1161`). Its *WHAT
  IS NOT HELD* no longer lists QC-15's other owners. It lists two parts still unheld, both for review at
  `development-design`: which read the adapter makes inside its owner file, and `git-reader`'s
  `Path`-method reads (`:L253-L256`). The adapter line citations are stale as well. The entry cites
  `libgit2.rs:L31`, `:L35` and `:L63`. The `Path`-method reads now sit at `libgit2.rs:L38`, `:L42` and
  `:L136`, and the `.git` file's open sits at `:L62`, with its handle's `metadata()` at `:L69`. The likely
  fold: the *verified by* names the three exact-path owners at a pinned commit, keeps review at
  `development-design` as the gate for those two unheld parts only, and re-pins the adapter citations.
- **If a document has to be written:** none.
- **Answer:** confirmed with addition — fold it as the item proposes, pinned at `nozoki@48308ff`
  (`git diff --stat 48308ff 188b141 -- checks crates` prints nothing). QC-15's *verified by* names
  the scan's three exact-path owner files (`checks/structure.sh:L77-L80`, the exempting `case` at
  `:L1161`). It drops "names QC-15's other owners as not held" and "Until the change that adds it".
  It keeps review at `development-design` as the gate only for the two parts the script lists as
  unheld (`:L253-L256`): which read the adapter makes inside its owner file, and `git-reader`'s
  `Path`-method reads. It re-pins the adapter citations: the `Path`-method reads at
  `libgit2.rs:L38`, `:L42` and `:L136`, the `.git` file's open at `:L62`, and its handle's
  `metadata()` at `:L69`. Three additions. (1) The exact path now has a test of its own, and the
  tail names it. `checks/tests/test_structure.sh` `test_exemption_is_exact_for_the_adapter_name`
  (`:L961`) plants a `std::fs` write under the adapter's file name at six other paths and requires a
  QC-15 finding at each. `test_git_owner_write_is_still_one_qc2_finding` (`:L931`) holds that the
  exemption lifts this clause only. `bash checks/tests/test_structure.sh` exits 0 at
  `nozoki@188b141`. (2) "Only" narrows the review gate, not the gap. The sentence saying the scan
  does not see a `Path` method that touches the filesystem stays, for every crate. It is re-pinned
  to the script's *GAPS THE RULES ABOVE DO NOT CLOSE* (`:L266-L267`), because a `Path`-method read
  outside `git-reader` is as unseen as before. (3) No ADR moves. ADR-0018 binds QC-15, and its
  citations are pinned at `nozoki@8edec4f`, where they still read as quoted. The decision did not
  change; its realization landed. Reasoning: `docs/trail/architecture/self_answer-35.md` § 3.1.

**How it closes.** `product-architecture` folds it on its next run like any other item here.
