# Architecture open issues — KA-Reader

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

> **No `product-architecture` run wrote this file.** The PM opened it on 2026-10-04 from the records'
> own companion template. The bridge now runs the config search-path switch, holds its test, and
> exports `ka_reader_read_git`, and `checks/view.sh` holds the `nm` transport read (`ka-reader@392177d`). Two
> NFDR entries still say these are not in the tree. The records are Settled, and with no companion on
> disk a `product-architecture` re-run reads them as done and has nothing to act on. Its two items are
> in § 3.

---

## 1. Open issues — questions with no answer yet

None.

## 2. Choices to confirm — the Principal Architect drafted a best-effort answer; confirm or override

> **No `product-architecture` run wrote this section or its item.** A `companion-self-answer` run
> added it on 2026-10-04 while answering § 3.1 and § 3.2 (`docs/trail/architecture/self_answer-38.md`,
> § Raised on this document). It came from reading QC-11 against the change § 3.2 measures. That
> change is the switch, landed at `ka-reader@392177d`, and QC-11 still names it as a change to come. No
> item raised this one, and it is no split half of § 3.1 or § 3.2: both are decided without it. It
> sits in this bucket because the run has a lean. Its slot is for the next round.

### 2.1 QC-11 hands its exception's check to "the change that builds the switch"; that change landed and left `checks/structure.sh` as it was
- **Lands in:** `nfdr.md` QC-11
- **Drafted into the records:** Nothing. No producing run wrote this, and the run that raised it
  writes no record. The change it proposes is to QC-11's *verified by* tail. Keep that the
  exception's bound is review at `development-design`. Replace "and changing it for the exception is
  the design of the change that builds the switch (SDD RN-87)" with a past-tense statement. The change
  that built the switch (`ka-reader@392177d`) did not add the rule to the script. The bound stays review
  at `development-design` until a change adds it, by the header's rule. Re-pin the script locator to
  where it now reads (`checks/structure.sh:L257-L258`). At `ka-reader@392177d`, the bridge sources that
  name `git2` are `crates/ka-reader-bridge/src/machine_config.rs` and
  `crates/ka-reader-bridge/tests/search_path.rs`, plus the manifest. That is exactly the exception's
  bound.
- **Rationale:** QC-11 (`docs/nfdr.md:L324-L328`) gives the exception's check to a change that has
  now landed. A later reader takes that change to be still pending and waits for it. Three
  measurements support the fix. `git log --oneline 8edec4f..392177d -- checks/structure.sh` lists
  only `48308ff` and `0a095f9`, the probe change, and not the switch change. The script still names
  the clause as not held: *WHAT IS NOT HELD*, "'only `git-reader` imports the libgit2 binding' outside
  the three units' files" (`checks/structure.sh:L257-L258`). And
  `grep -rln git2 crates/ka-reader-bridge` prints only `Cargo.toml`, `src/machine_config.rs` and
  `tests/search_path.rs`, so the bound holds today. It holds by review, not by the script. The
  switch's own source states the bound ("It is the only bridge source that names `git2`",
  `machine_config.rs:L5-L6`). This is the same correction § 3.1 and § 3.2 make to QC-3 and QC-17:
  a gate written as owed by a change that has since landed. The doubt is that the sentence named whose
  design the choice was, which is not strictly false. Read cold, though, it says the choice is still
  to be made, and it was made: the change chose review. The record is owed that fact.
- **If overridden:** If the override is "leave QC-11 as it reads", the entry keeps pointing at a
  landed change as the place its check will come from, and the next change that touches the bridge
  inherits no named owner for the rule. If the override is "add the rule now", that is a change to
  `checks/structure.sh` and goes through the delivery tier, not this record. QC-11's tail would
  then name the rule as held from that change.
- **Confirm or override:** <"confirm", or "override: <what to do instead>">

## 3. Raised from downstream — an item from a seat that did not write these records

### 3.1 QC-3 says the `nm` read is not in `checks/view.sh` and its gate is still `development-design`
- **Raised by:** PM — 2026-10-04
- **Which record:** `nfdr.md` § 1.1, QC-3
- **Tracked by:** `ka-reader · nemawashi · 2026-10-02_git-says-what-changed`
- **What it blocks:** nothing fails. A later change reads QC-3 to learn what holds the transport
  claim, and finds a review gate where a script now runs on every push.
- **Where it shows:** QC-3 (`docs/nfdr.md:L156-L159`): "The read is not in the script at
  `ka-reader@8edec4f` … and no bridge function reaches `git-reader` at that commit. The build that first
  exports one owes the read, and until that build its gate is `development-design`". That build has
  landed: `ka_reader_read_git` is exported (`crates/ka-reader-bridge/src/exports.rs:L105`). The read is in
  the script (`checks/view.sh:L379`), with its red cases in `checks/tests/test_view.sh:L62-L64`, and
  CI runs both after `ka-reader-mac/assemble.sh` (`.github/workflows/ci.yml:L41`, `:L51`, `:L54`). The
  release executable holds no `ka_reader_read_git` symbol until a Swift caller links it, so the read has
  not yet met a build with the export linked in. The likely fold: the read is in the script from
  that build, and its gate is the script.
- **If a document has to be written:** none. QC-3's sentence in `nfdr.md`.
- **Answer:** Fold it, with three additions. QC-3's half (3) is held by the script from the build
  at `ka-reader@392177d`: the `nm` read is `checks/view.sh:L379-L404`, its suite cases are
  `checks/tests/test_view.sh:L58-L64` (`:L58-L61` the four symbol reds, `:L62-L64` the three cause
  reds), and CI runs both on every push after `ka-reader-mac/assemble.sh` (`.github/workflows/ci.yml:L41`,
  `:L51`, `:L54`). Its gate is that script, and the sentence "The read is not in the script at
  `ka-reader@8edec4f` … until that build its gate is `development-design`" goes. (1) Its clause "no
  bridge function reaches `git-reader` at that commit" goes with it: `ka_reader_read_git`
  (`crates/ka-reader-bridge/src/exports.rs:L105`) reaches it. (2) State what the read has met, as SDD
  § 4 C-I3 does at v31 (`docs/SDD.md:L759-L775`). It has met an executable that links libgit2's open
  and status code. It has not met one that links `ka_reader_read_git`, which no Swift source calls. The
  read runs on every build, so it meets that executable in the build where `mac-shell` first calls
  the export, with nothing further owed, and a red read there is SDD § 11 R-15. (3) Beside "The three
  names are a floor", carry C-R6's bound at v31 (`docs/SDD.md:L639-L645`). The pattern does not match
  `_git_socket_stream_global_init`, `_git_stream_registry_global_init` or
  `_git_transport_ssh_libssh2_global_init`, which the release executable defines. What they do was
  not read, and the pattern is not widened for them. Re-pin the trace to SDD § 4 C-R6 and C-I3 as
  they read at v31 (SDD RN-91). Reasoning: `docs/trail/architecture/self_answer-38.md` § 3.1.

### 3.2 QC-17 says the search-path switch and its test are not in the tree; both are
- **Raised by:** PM — 2026-10-04
- **Which record:** `nfdr.md` § 1.3, QC-17
- **Tracked by:** `ka-reader · nemawashi · 2026-10-02_git-says-what-changed`
- **What it blocks:** nothing fails. The entry's gate reads "until that change the gate is
  `development-design`", and that change has landed.
- **Where it shows:** QC-17 (`docs/nfdr.md:L483-L486`): "The switch and its test are not in the tree at
  `ka-reader@8edec4f`. They land in the change that wires the libgit2 adapter in the bridge". The switch is
  `crates/ka-reader-bridge/src/machine_config.rs`, and its read-back is
  `crates/ka-reader-bridge/tests/search_path.rs:L36` (`test_the_switch_against_the_real_libgit2`). That
  test makes its first arrival through a session's open, and so reads the four levels back after the
  production arrival. `cargo test --locked -p ka-reader-bridge` is green at `ka-reader@392177d`. The likely
  fold: name that test as the one that reads the four paths back, and the suite as the gate.
- **If a document has to be written:** none. QC-17's sentence in `nfdr.md`.
- **Answer:** Fold it, with one addition. The switch is `crates/ka-reader-bridge/src/machine_config.rs`,
  landed at `ka-reader@392177d`. The read-back is `test_the_switch_against_the_real_libgit2`
  (`crates/ka-reader-bridge/tests/search_path.rs:L36`). Its first arrival is a production session's
  open, and after it the test reads all four levels' search paths back empty (`:L47-L55`). The gate
  is `cargo test --locked -p ka-reader-bridge`, which CI runs on every push inside `cargo test
  --workspace --locked` (`.github/workflows/ci.yml:L26`). The sentences "The switch and its test are
  not in the tree at `ka-reader@8edec4f`" and "until that change the gate is `development-design`" go.
  The violation clause stays: a bridge that wires the adapter with no switch run before it, or with
  no test of the switch, still violates the entry. Addition: the read-back test holds only the
  four-empty half. Name the tests that hold the fail-closed and once-per-process halves. They are
  `machine_config.rs`'s `mod tests`: any of the four erring is `Failed` (`:L213`), no retry after
  `Failed` (`:L249`), and concurrent first arrivals set four paths in total (`:L262`). They are also
  `session.rs`'s erring-setter cases (`:L1729`, `:L1740`): the Git item answers that the config was
  not switched off, and it stays that way after a second open. Re-pin the trace to SDD § 4 C-I3 as it
  reads at v31 (`docs/SDD.md:L776-L785`, SDD RN-91). Reasoning:
  `docs/trail/architecture/self_answer-38.md` § 3.2.

**How it closes.** `product-architecture` folds it on its next run like any other item here.
