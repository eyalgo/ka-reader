# Self-answer report — `docs/adr/` and `docs/nfdr.md`

This report records one unattended run on `docs/architecture_open_issues.md`. The run answered both
of the companion's open items, raised one item on the same companion, and opened one companion on
the SDD. It is written for the owner, and for the `product-architecture` and `product-sdd` runs that
fold the two companions.

## Header

- **Companion:** `docs/architecture_open_issues.md`
- **Document:** `docs/adr/` and `docs/nfdr.md`
- **Decided by:** `<CORE>/../skills/companion/.claude/skills/companion-self-answer/prompts/rich.md` v1.3.1
- **Date:** 2026-10-06
- **Sources re-read:** the registry copy of `libgit2-sys 0.18.8+1.9.7`, the version the SDD pins:
  - `libgit2/src/libgit2/submodule.c:L2243-L2260`: `gitmodules_snapshot` opens
    `$WORK_TREE/.gitmodules` with `git_config_open_ondisk`.
  - `:L665`: the snapshot is called from `git_submodule__map` (`:L634`), and `git_submodule__map`
    from `git_submodule_cache_init` (`:L283-L294`).
  - `libgit2/src/libgit2/diff_generate.c:L759-L760`: the diff that status runs starts that cache.

  The § 3.2 answer and the SDD item rest on this source. This run did not open the
  `config_file.c` include handling. It took that from SDD § 11 R-16's own citation
  (`docs/SDD.md:L3043-L3044`).

## Items worked

### 3.1 — QC-11's tail says the libgit2-import bound is review, and the script now holds it by file

- **Bucket:** 3. Raised from downstream — an item from a seat that did not write these records
- **Verdict:** confirmed with addition
- **Why:** § 3 items carry no draft field, but this one ends in a "likely fold", which is a lean. I
  treated it as a draft.
  - **Check 1, the seat.** The change lands in `nfdr.md` QC-11, this companion's own document. It
    commits nothing to a person or a third party. So the seat is this run's.
  - **Check 2, what the item states.** I re-measured each claim at `ka-reader@b25b407`:
    - The header's QC-11 *libgit2 binding* row reads every shipped-scope file in any crate, with two
      exemptions: the `git_reader` unit and `crates/ka-reader-bridge/src/machine_config.rs`
      (`checks/structure.sh:L130-L142`, the `case` at `:L1186`).
    - The row landed in `ka-reader@a611cf1`, an ancestor of the merge `ka-reader@fc14574`.
    - `bash checks/structure.sh` prints "16 Rust files in 2 crates read — nothing found" and exits 0.
    - QC-11's tail still says the bound "stays review until a change adds it"
      (`docs/nfdr.md:L357-L364`). That change has landed, so the tail's claim is now false. This is
      a correction, not a widening, and the item cites where it occurs.
  - **What the item's fold leaves out.** It keeps review only for the bound inside
    `machine_config.rs`, and that is one of two parts the script does not hold. The other is
    `crates/ka-reader-bridge/tests/`. QC-11 allows the binding in "that switch's test" and in no other
    test (`docs/nfdr.md:L355-L356`). The script reads `tests/` for the layer-5 rule alone
    (`checks/structure.sh:L41-L42`), so a second bridge test that names `git2` draws no finding.
    Today only `tests/search_path.rs` names it (`grep -rln git2 crates/ka-reader-bridge`). The
    addition names both parts. It also says why the file exemption is coarse: `machine_config.rs`
    holds the adapter's constructor beside the switch (`:L138-L139`).
  - **I checked the other test tree too.** The only `ka-reader-core` file under `tests/` that names
    `git2` is `tests/unit/libgit2.rs`. That file is the adapter's own `mod tests`, loaded by
    `#[path]` from `src/git_reader/libgit2.rs:L770`, so it belongs to `git-reader` and is not a
    second exception.
  - **Check 3, against the settled record.** SDD § 3's `core-bridge` row says "The bridge names the
    libgit2 binding in those calls and their test and nowhere else" (`docs/SDD.md:L350`). The
    answer agrees with it.
  - **Check 4, the failure paths.**
    - A new file under `src/git_reader/` is exempt with no edit, by the wildcard at `:L1186`.
    - A switch moved out of `machine_config.rs` turns the script red, which is the right outcome.
    - A second `git2` use inside `machine_config.rs`, or a second test that names it, is caught
      only by review. The answer names both rather than leaving them unstated.
  - **What would have changed the verdict.** Had the script read `tests/` for this rule, I would
    have confirmed the fold as it stands.

### 3.2 — QC-15's list of `git-reader`'s reads outside libgit2 names no config read

- **Bucket:** 3. Raised from downstream — an item from a seat that did not write these records
- **Verdict:** confirmed with addition
- **Why:** As in § 3.1, I treated the item's "likely fold" as a draft.
  - **Check 1, the seat.** The change lands in `nfdr.md` QC-15, so the seat is this run's for
    every read the SDD owns.
  - **The rule for this item.** The item widens QC-15, because it asks the list to state reads it
    does not state. It is raised from downstream, so it gets only the forms it cites an occurrence
    for (prompt § *A widening item waits until it occurs*). I checked each form:
    - **The config reads.** They occur at `crates/ka-reader-core/src/git_reader/libgit2.rs:L191-L247`:
      `config` in the common directory, `config.worktree` where `extensions.worktreeConfig` is set,
      and each include that spells inside the folder. SDD § 3's `git-reader` row owns them
      (`docs/SDD.md:L338`, RN-99). They are taken.
    - **The submodule reads.** They occur at `:L285-L340`: each gitlink folder's `.git` entry
      metadata, its location reads and its config check. The row owns them as "verifies each
      submodule repository". They are taken.
    - **The alternates read** (RN-100). It is not built: `grep -n alternates` over the adapter
      prints nothing. The answer is **not until it occurs**, which matches the item's own "once
      built". The building change owes QC-15 the read, through review at `development-design`.
  - **Check 2, two gaps in the draft.**
    - **The positions along each value's path.** The draft names the files the check reads but not
      the walk's reads along each config value. `follow` spells every key value with the same walk
      (`:L252-L280`), and so reads metadata and link text at positions along those paths. QC-15's
      clause names such positions only along the paths to the Git directory and the common
      directory (`docs/nfdr.md:L458-L460`). The SDD owns these reads: "with the spelling walk it
      already locates the Git directory by". This addition is taken.
    - **`.gitmodules`.** The adapter reads `.gitmodules` in the working tree of the repository and
      of each submodule, and follows its include keys (`:L292-L303`, `:L238`). libgit2 loads it as
      a config file during the status read (see *Sources re-read*). The SDD's row neither owns that
      read nor makes an exception for it. The exceptions in its *Must not own* cell cover a file
      the repository's config includes and the `info/alternates` file, and `.gitmodules` is
      neither. The SDD mentions `.gitmodules` only as a fixture's contents (`docs/SDD.md:L7023`).
  - **Check 3, against the settled record.** The NFDR derives its entries and never invents them
    (`docs/nfdr.md:L8-L10`). So QC-15 cannot name a read the SDD does not own. That half of the
    change belongs to the SDD first, and I opened `docs/SDD_open_issues.md` § 2.1 for it
    (`ka-reader@ed6e634`), before writing this slot.
  - **Why this is not a split.** The item did not ask about `.gitmodules`. I found it while
    checking the item's own claim, so it is an addition the draft missed whose change lands
    upstream, not a second question inside the item.
  - **Check 4, the failure paths.**
    - A missing config, `config.worktree` or `.gitmodules` file is skipped: `NotFound` continues,
      at `:L223`. The list still holds.
    - Stale: when the alternates read is built, or when the SDD folds § 2.1, QC-15 is owed a
      re-derivation. Until then, review at `development-design` reads the `.gitmodules` read as
      not on the list. That is the honest state, and the open SDD item makes it visible.
  - **What would have changed the verdict.** Had the SDD's row owned `.gitmodules`, the fold would
    have taken all of it with no upstream item.

## Left for the owner

None this run.

## Skipped

None this run.

## Raised on this document

### 2.1 — QC-6, QC-30 and QC-35 still call config-named paths uncovered, though SDD v39 – v41 now has `git-reader` refuse them before libgit2 opens

- **What the document is owed:** QC-6's and QC-35's uncovered-case sentences, and QC-30's pointer
  at them, re-derived on SDD v41. The re-derivation states three things:
  - `git-reader` refuses a repository whose config names a path outside the folder, or one it does
    not locate, before libgit2 opens anything;
  - § 11 R-16 measures the domain as five keys, not three;
  - the alternates read is the one case still uncovered.
- **Why it is worth a cycle:** it meets two of the grounds in
  `<CORE>/../skills/companion/.claude/skills/companion-self-answer/prompts/rich.md` § *The items
  are not the whole of what a document is owed*:
  - **Something upstream moved and it has not seen it.** The NFDR was last re-derived on SDD v33
    (`docs/nfdr.md:L5`). SDD v39 – v41 rewrote § 4 C-D3 (`docs/SDD.md:L1009-L1016`), § 11 R-16
    (`:L3041-L3047`) and the *Open Questions* item (`:L7138-L7160`).
  - **A fact in it is now false.** "which libgit2 follows with no containment check" and the
    three-key list (`docs/nfdr.md:L256-L257`, `:L954-L955`) describe the product before the check
    was built (`crates/ka-reader-core/src/git_reader/libgit2.rs:L191`, merged at `ka-reader@fc14574`).

  The decision about the alternates read was made together with § 3.2's answer. Both say that
  read is not built. This item asks the entries to name it as uncovered and never as owned, so the
  two answers do not contradict each other.

## Companions opened

- **`docs/SDD_open_issues.md`** — **opened** — companion to `SDD.md`, landed in commit `ed6e634`

## Launchers owed

- **`docs/adr/` and `docs/nfdr.md`** — `<CORE>/launchers/skill/launcher.sh product-architecture ka-reader`
- **`docs/SDD.md`** — `<CORE>/launchers/skill/launcher.sh product-sdd ka-reader`
