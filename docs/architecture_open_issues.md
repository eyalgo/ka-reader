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

---

## 1. Open issues — questions with no answer yet

None.

## 2. Choices to confirm — the Principal Architect drafted a best-effort answer; confirm or override

### 2.1 ADR-0016 says only `git-reader` imports the libgit2 binding, and SDD v27 adds a `core-bridge` exception; the run drafted a superseding record, ADR-0020, rather than a correction in place

- **Lands in:** `adr/0020-physical-unit-set-the-bridge-switches-off-libgit2-machine-config-reads.md`
  and `adr/0016-physical-unit-set-core-bridge-mac-checks.md`; `nfdr.md` QC-11, QC-13, QC-17 and
  QC-35 name ADR-0020 in their traces
- **Drafted into the records:** ADR-0020, at **Proposed — supersedes ADR-0016 on acceptance**. It
  restates ADR-0016's four units and their map, with the `nozoki-bridge` row extended. It states
  the exception: `core-bridge` names the binding in the composition root's config search-path
  switch and that switch's test, and nowhere else. It records the switch: four `set_search_path`
  calls before the adapter is wired, failing closed, once per process. Its alternatives are the
  SDD's — accept the reads and lower R-101, `unsafe` in `git-reader`, patch the vendored build, a
  re-export from `git-reader` — beside ADR-0016's three. ADR-0016 stays Accepted, with nothing in
  it edited, until you answer. The NFDR does not wait: QC-11, QC-13, QC-17 and QC-35 already
  re-derive from SDD v27, which is their authorization (`nfdr.md` RN-43).
- **Rationale:** ADR-0016 § Decision says "only `git-reader` imports the libgit2 binding", and
  `docs/SDD.md` v27 now says "with one exception" (§ 3, the *Four physical units* paragraph and
  the `core-bridge` row; RN-87). A rule inside the decision moved, and the log's mechanic for a
  moved decision is a superseding record. The two dated corrections in place this log carries,
  ADR-0010's (NFDR RN-20) and ADR-0016's own (`docs/trail/architecture/cycle-10.md` § 3.4), each
  corrected a reason while the decision held, and each was authorized by an answer. Here no answer
  covers the sentence. Choosing between the two is yours, because a wrong guess either loses the
  history or rewrites an accepted record. The switch clears the three gates on its own. It is
  costly to reverse once the adapter is wired. It is surprising without context: "why does the
  bridge name `git2`?". And it is a real trade-off, against lowering a product promise.
- **If overridden:** with "override: correct ADR-0016 in place", ADR-0016 takes a dated correction
  of its import sentence, ADR-0020 is rewritten as a record of the switch alone, superseding
  nothing, and the index changes to match. With "override: no record", ADR-0020 is deleted while it
  is still Proposed, ADR-0016 takes the dated correction, and the switch's *why* lives only in SDD
  RN-87. The NFDR moves in neither case, except that QC-11, QC-13, QC-17 and QC-35 drop or re-point
  their ADR-0020 trace.
- **Confirm or override:** <"confirm", or "override: <what to do instead>">

### 2.2 QC-30's boundary set misses the C environment reads libgit2 brings, and the run drafted them as a member of half (2), checked by `checks/entry-points.sh` reading `getenv` in C sources, rather than a review-only gate

- **Lands in:** `nfdr.md` QC-30 (the statement, half (2)'s verification, the trace) and § 10's
  second QC-30 row
- **Drafted into the records:** QC-30 now says a C `getenv` in a linked crate is a read of half
  (2), named on `checks/entry-points.allow` as a Rust read is. It names what this fold measured at
  `nozoki@8edec4f`. Two of the 37 crates the command resolves carry `getenv` in C: `libgit2-sys`
  and `libz-sys`. A repository open reaches libgit2's `APP_SANDBOX_CONTAINER_ID`, `HOME` and
  `XDG_CONFIG_HOME` at init (`libgit2/src/libgit2/sysdir.c:L347`, `:L357`, `:L402-L405`,
  `:L458-L459`), and `SUDO_UID` only when the effective user is root
  (`libgit2/src/util/fs_path.c:L2030-L2033`). None of the four opens a file. libgit2's other sites
  sit behind calls the port never makes, or in `src/cli`, which is not compiled. `libz-sys`'s one
  site is in its zlib-ng copy, which this build does not compile. Half (2)'s verification gains a
  rule this document adds to the script: the scan reads each crate's C and C++ sources for
  `getenv` against the same list. Until the change that adds it, a C read's gate is review of the
  lockfile diff at `development-design`. QC-9's "when `git-reader` links it" is corrected to "which
  `git-reader` links" as a fact SDD v26 and v27 § 3 state, and it needs nothing from you.
- **Rationale:** The item as raised (`docs/trail/architecture/cycle-29.md` § 2.2) proposed naming
  the three init reads as *Not covered*, with review as their gate. This fold measured two things
  that change the draft. First, three is not the whole set, so a list of members written from that
  reading would have gone stale at once. Second, a class-2 gate must argue that no command can
  check it (`docs/nfdr.md` preamble). One can: `checks/entry-points.sh` already scans each crate's
  whole package directory and already lists uncompiled reads with their reason
  (`checks/entry-points.allow:L30-L31`, the `libz-sys` lines). The item's open question is answered
  by measurement: `libz-sys` builds zlib-ng only under a zlib-ng feature
  (`libz-sys-1.1.29/build.rs:L15-L18`), the lock resolves only `libc`, and the build's script
  output links the system `libz`. Measurement detail is in `nfdr.md` RN-43.
- **If overridden:** with "override: review only, as the item proposed", QC-30's half (2) drops the
  `getenv` rule, the *Not covered* clause names a C `getenv` in a linked crate with the four reached
  reads as its present members, and § 10's row loses its parenthesis. With "override: name nothing",
  QC-30 goes back to calling "exact" a set missing reads the shipped process makes once libgit2
  initialises. Either way QC-9's correction stands.
- **Confirm or override:** <"confirm", or "override: <what to do instead>">

## 3. Raised from downstream — an item from a seat that did not write these records

None.
