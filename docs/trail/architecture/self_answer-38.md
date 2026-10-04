# Self-answer report — `docs/adr/` and `docs/nfdr.md`

This report records one unattended run that answered `docs/architecture_open_issues.md` in the
owner's seat. It is written for the owner, who reads it to learn what was decided and why. It is also
written for the `product-architecture` run that folds the answers.

## Header

- **Companion:** `docs/architecture_open_issues.md`
- **Document:** `docs/adr/` and `docs/nfdr.md`
- **Decided by:** `decide_companion_answers.md` v1.3.0
- **Date:** 2026-10-04
- **Sources re-read:** None. Every answer rests on this repository's code, its CI workflow, its
  checks, and the Settled SDD. Two claims the records repeat about libgit2's registry copy
  (`sysdir.c:L559-L560` and `transport.c:L33-L35`) are not leaned on by either answer, so neither was
  re-read.

## Items worked

### 3.1 — QC-3 says the `nm` read is not in `checks/view.sh` and its gate is still `development-design`

- **Bucket:** 3. Raised from downstream — an item from a seat that did not write these records
- **Verdict:** confirmed with addition
- **Why:** **The PM's fold is right: the read is in the script from `nozoki@392177d`, and the script
  is the gate. Three more things go with it.** The item carries no draft, only a "likely fold". A
  likely fold is a lean, so I weighed it as a draft, as the prompt directs for an item that carries
  one.

  *The PM's claims, re-measured.* Nothing under `crates`, `checks`, `nozoki-mac` or `.github` has
  changed since the merge (`git diff --stat 392177d HEAD -- crates checks nozoki-mac .github` prints
  nothing), so these readings hold at `nozoki@27e2bbf`.
  - The read is `checks/view.sh:L379-L404`. It is red on a defined `git_smart_subtransport_*`, on an
    undefined `connect`, `socket` or `getaddrinfo`, and where `nm` is missing, fails or prints no
    symbol. That is QC-3's half (3) word for word (`docs/nfdr.md:L149-L153`). The header names QC-3
    (3) as its source (`checks/view.sh:L21-L26`).
  - Its suite cases are `checks/tests/test_view.sh:L58-L64`. The item cites `:L62-L64`, which holds
    only the three cause cases (nm absent, failing, printing nothing). The four symbol reds sit at
    `:L58-L61`. The item's supporting text is narrower than the suite, and the answer cites the whole
    range.
  - CI runs `nozoki-mac/assemble.sh`, then `checks/view.sh`, then its suite, on every push
    (`.github/workflows/ci.yml:L11`, `:L41`, `:L51`, `:L54`).
  - `nozoki_read_git` is exported (`crates/nozoki-bridge/src/exports.rs:L105`), and no Swift source
    calls it (`grep -rn nozoki_read_git` over `nozoki-mac` prints nothing).
  - I ran `bash checks/view.sh` on the release bundle in this working copy, built at 08:20 on
    2026-10-04, after the 08:10 merge. It exited 0. `nm` on that executable shows 781 defined `_git_`
    symbols, `_git_repository_open_ext` among them. It shows no `git_smart_subtransport_` symbol, no
    undefined `_connect`, `_socket` or `_getaddrinfo`, and no `_nozoki_read_git`. That matches the
    SDD's own measurement on the bundle built at `nozoki@0aab3e7` (`docs/SDD.md:L763-L772`).

  *Check 1 — whose seat.* **This one is mine, in the owner's seat.** The edit lands in `nfdr.md`
  QC-3 and nowhere else. The SDD already folded the same facts upstream at v31, in the CTO's seat
  (`docs/SDD.md:L759-L775`; trail `docs/trail/sdd/cycle-26.md` § 5.3). So the NFDR is the one
  document that has not seen them. ADR-0019 cites `nozoki@8edec4f` only as a dated measurement
  (`docs/adr/0019-…-the-executable-links-no-transport.md:L124`). A record's dated measurement is not
  falsified by a later build, so no new record is owed. The answer binds no person and no outside
  party.

  *Check 2 — the draft.* The conclusion is right. The argument is right but incomplete, in two places
  and with one framing slip.
  - **QC-3 says "no bridge function reaches `git-reader` at that commit."** The fold must drop that
    clause, or a reader takes it as still true. `nozoki_read_git` now reaches it.
  - **The item's last sentence implies the read is waiting on something.** It reads "the read has not
    yet met a build with the export linked in." That is true, but it is not what the read is for. It
    has already met an executable that links libgit2's open and status code, and passed. The export
    adds no new kind of libgit2 code the read has not seen. The SDD settled that "with nothing
    further owed" (`docs/SDD.md:L772-L774`). The fold should state it the SDD's way, so the NFDR
    does not invent a pending obligation.
  - **C-R6 moved at v31, and the item does not mention it.** C-R6 now names three symbols the
    release executable defines and the pattern does not match: `_git_socket_stream_global_init`,
    `_git_stream_registry_global_init` and `_git_transport_ssh_libssh2_global_init`
    (`docs/SDD.md:L639-L645`). I re-read them on the local executable: all three are present, as
    local `t` symbols. QC-3 traces C-R6 "as it reads at v27" and says "The three names are a floor".
    So it is missing the bound its own source now carries. This is the same entry and the same half
    the item asks about, so it rides this answer rather than a separate item.

  *Check 3 — the settled record.* The answer moves nothing the SDD has settled. It restates C-I3 and
  C-R6 at v31. R-15 still takes a red read. FDR PD-27 still makes stating the claim lower the
  owner's call. Nothing here touches either. QC-26's review half (2) and the tree half (1) are
  unchanged.

  *Check 4 — failure paths.*
  - **Absent or empty:** an `nm` that is missing, fails or prints nothing is red, by a suite case each
    (`test_view.sh:L62-L64`).
  - **Stale:** my measurement is of a local build, not a CI run, and it is not the citation the fold
    should use. The SDD's measurement is pinned to a commit and a report, so the fold cites that. The
    gate going forward is the script on every push, which no single measurement stands in for.
  - **The build that first links the export:** the read runs on it unchanged. A red read there is
    R-15, already stated.
  - **Not covered, and named:** the read does not look at the three symbols above. QC-3 should say so
    in the form the SDD does, without widening the pattern.

  *What would have tipped it.* I would have left this for the owner if the C-R6 bound widened what
  QC-3 promises. It narrows only what the check is said to see, and the SDD's CTO seat already made
  that call.

### 3.2 — QC-17 says the search-path switch and its test are not in the tree; both are

- **Bucket:** 3. Raised from downstream — an item from a seat that did not write these records
- **Verdict:** confirmed with addition
- **Why:** **The PM's fold is right: name `test_the_switch_against_the_real_libgit2` as the read-back,
  and the bridge's suite as the gate. Also name the tests that hold the switch's other two
  promises.** As with 3.1, the "likely fold" is a lean, and I weighed it as a draft.

  *The PM's claims, re-measured.*
  - The switch is `crates/nozoki-bridge/src/machine_config.rs`. `run_switch` empties the four levels
    and answers `Failed` at the first that errs, without trying the rest (`:L59-L69`). A `OnceLock`
    guard runs it once per process (`:L71`, `:L129-L133`). The adapter is made only in this module
    (`:L135-L140`).
  - The read-back is `crates/nozoki-bridge/tests/search_path.rs:L36`. Step 0 asserts that the global
    level starts non-empty (`:L39-L43`). Step 1's first arrival is a production session's open, and
    after it all four levels read empty (`:L47-L55`). Steps 2 and 3 show that a second arrival sets
    nothing (`:L62-L73`).
  - I ran `cargo test --locked -p nozoki-bridge` at `nozoki@27e2bbf`. It is green: every target
    passed, `search_path` 1 of 1 among them. CI runs it inside `cargo test --workspace --locked` on
    every push (`.github/workflows/ci.yml:L26`).

  *Check 1 — whose seat.* **This one is mine, in the owner's seat.** The edit lands in `nfdr.md`
  QC-17. The SDD folded the same facts at v31 (`docs/SDD.md:L776-L785`, RN-91). ADR-0020 decides the
  switch and makes no claim about whether it has landed, so it is untouched.

  *Check 2 — the draft.* The draft is right and incomplete. QC-17 makes three promises about the
  switch: four empty paths, failing closed ("if any of the four fails, the adapter is not wired and
  the Git item is `failed`"), and running once per process before any thread can reach libgit2
  (`docs/nfdr.md:L469-L471`). The read-back test holds only the first. The other two are held by
  tests the item does not name:
  - `machine_config.rs`'s `mod tests`: any one of the four erring is `Failed` (`:L213`), no retry
    after `Failed` (`:L249`), and concurrent first arrivals set four paths in total (`:L262`).
  - `session.rs`'s erring-setter cases: the Git item answers that the config was not switched off
    (`:L1729`), and stays that way after a second folder opens (`:L1740`).

  Naming only the read-back would leave the fail-closed promise looking held by a test that cannot
  see it.

  *Check 3 — the settled record.* The answer moves nothing settled. The entry's *Violated by* clause
  stays: a bridge that wires the adapter with no switch run before it, or with no test of it. So do
  the uncovered-fifth-level sentence and the "read and not run" step to `sysdir.c`. QC-11 and QC-13
  name the switch and its test as the libgit2 binding's one exception in the bridge. That stays true:
  `grep -rln git2 crates/nozoki-bridge` prints only the manifest, `src/machine_config.rs` and
  `tests/search_path.rs`.

  *Check 4 — failure paths.*
  - **Ordering, the case QC-17's "before any thread can reach libgit2" turns on:** the switch runs on
    the session's first successful open (`session.rs:L594-L597`). The core's `open_folder` before it
    reads through `fs_reader` alone (`crates/nozoki-core/src/folder_model.rs:L56-L64`). `probe`, the
    first libgit2 call, runs through the wired port afterwards (`:L296`). So nothing reaches libgit2
    first.
  - **Absent:** a setter that errs leaves the Git item `failed`, and it logs one warning
    (`session.rs:L598-L603`, `:L1956`).
  - **Concurrent:** covered (`machine_config.rs:L262`).
  - **Empty:** if a machine starts with the global level already empty, the read-back's Step 0 goes
    red instead of passing vacuously.
  - **Not covered, and already named in the entry:** a fifth level in a later libgit2.

  *What would have tipped it.* I would have answered "confirmed" with no addition if QC-17 promised
  only the four empty paths.

## Left for the owner

None this run.

## Skipped

None this run.

## Raised on this document

### 2.1 — QC-11 hands its exception's check to "the change that builds the switch"; that change landed and left `checks/structure.sh` as it was

- **What the document is owed:** QC-11's tail should say, in the past tense, that the change that
  built the switch (`nozoki@392177d`) did not add the exception's rule to the script. The bound stays
  review at `development-design` until a change adds it, and the script locator is re-pinned to
  `checks/structure.sh:L257-L258`.
- **Why it is worth a cycle:** *A fact in it is now false.* QC-11 says "changing it for the exception
  is the design of the change that builds the switch (SDD RN-87)" (`docs/nfdr.md:L326-L328`). That
  sentence describes a change to come. The change has landed. `git log --oneline 8edec4f..392177d
  -- checks/structure.sh` lists only the probe change (`48308ff`, `0a095f9`), and the script still
  lists the clause under *WHAT IS NOT HELD* (`checks/structure.sh:L257-L258`). The bound itself holds
  today, by review: only `machine_config.rs`, `tests/search_path.rs` and the manifest name `git2` in
  the bridge. My doubt is that the sentence named whose design the choice was, which is not strictly
  false. Read cold, it says the choice is still to be made. I raised it because the round is owed
  anyway, for 3.1 and 3.2, so this costs no extra cycle. Found while deciding 3.2. It is not 3.2's
  split half: 3.2 is decided without it.

## Companions opened

None this run.

## Launchers owed

- **`docs/adr/` and `docs/nfdr.md`** — `<CORE>/launchers/skill/launcher.sh product-architecture nozoki`
