# NFDR — Nozoki 覗き

**Status:** Settled
**Owner:** Principal Architect
**Version:** 40 — the close: a re-derivation on `docs/SDD.md` v32, which moved the config-named-path item's bound (SDD RN-92, `docs/trail/sdd/cycle-27.md` § 5.1). QC-6 and QC-35 now state the bound as the SDD states it — settled in `see-git-status` before the slice is reached, no build inside the slice bounding it — in place of "no later than the build in which `mac-shell` first calls `nozoki_read_git`", each with a dated note keeping the old words; QC-6 also names the review that holds the bound and what the builds between hold, and both traces are re-pinned to SDD v32. The companion's one item, § 2.1 (`nozoki@250fc6e:docs/architecture_open_issues.md`), proposed exactly this and carried no answer; the SDD's fold is the authorization, so the item is closed by derivation and not by an owner's answer, and no trail cycle is written. Nothing else moved beneath this document since v39. No `QC` is added, renumbered or reused, no record is written or restatused, and § 10 does not move. Nothing is left for the owner, so the companion is removed and `Status:` is Settled (RN-51).
**Inputs read:** SRS Settled · SDD Settled · FDR Settled · PRD Settled · UXD Settled · DESIGN Settled · CONTENT Settled

> The NFDR is the product's **standing obligations, consolidated and verifiable**: every quality
> constraint a change is checked against, derived from the SRS, the SDD, the FDR and the ADR —
> never invented here. It is updated in place with versioning (unlike the ADRs, which supersede).
> **Every entry carries a stable typed ID** (`QC-n`, never reused or renumbered), **a
> `verified by:` tail** naming the command, test layer, or review gate that fails when the
> obligation is broken, and **an inline trace tag** naming the upstream fact it realizes
> (`SRS NFR-n`/`C-n`, `SDD § 4`, an ADR record, or a doctrine default). An entry with no
> nameable verification is not yet an entry. A conditional section that does not bind this product
> is declared not applicable with the reason — never silently omitted. **`Inputs read:` names every
> upstream document this revision read and the status it carried at the time** — an obligation
> derived from a Draft source is still binding, and the line is how a later reader knows which ones
> were.
>
> **Who reads this.** The delivery-tier Architect, who checks a change design against § 1; the
> Tech Lead, who runs the structural verification off § 1.2; the Developer and the pipeline's test
> gates, off § 10; the QA seat, who realizes § 9's upper layers; and any contributor who arrives
> with a change and no one to ask. The decisions each entry realizes are in `docs/adr/`.
>
> **Two things about how this document cites.** A trace to a `QC` or an `ADR` opens in this
> repository. A trace to `quality_defaults.md` v1.1.0, `arch_defaults.md` v2.0.0,
> `testing_doctrine.md` v2.2.0, the Rust packet (`languages/rust/`, `testing.md` v1.0.1,
> `layout.md` v1.1.1, `errors_logging.md` v1.1.0, `quality_gates.md` v1.1.1, `toolchain.md`
> v1.1.1) or the Swift packet (`languages/swift/`, `README.md` v1.0.1, `testing.md` v1.1.0,
> `layout.md` v1.0.0, `toolchain.md` v1.1.0, `quality_gates.md` v1.1.0) names an
> engineering-doctrine file of
> the organisation that publishes this product, which is not in this repository; every such entry
> states the rule in full here, so the trace is provenance and never a dependency. Every command
> named below is one the SDD names, or one this document names as its own realization and says so
> in § NFDR Review Notes. Executability is per rule, not per script: a rule a command names
> becomes executable in the change that adds that rule to the command, and until then its gate is
> `development-design` reading the entry. A script not yet in the tree is the case where no rule
> has been added. Which rules a script holds is stated in the script's own header and is cited,
> never copied here — for `checks/structure.sh`, *THE SCAN TABLE* and *WHAT IS NOT HELD*
> (`checks/structure.sh:L35-L93` at `nozoki@463acb9`) — so the next rule added moves one file
> *(through v25 this sentence tied executability to the script's landing, which read every rule
> § 10 assigns to `checks/structure.sh` as gated once the script landed holding four of them; on
> the owner's seat's answer at `docs/trail/architecture/cycle-23.md` § 3.1 — RN-37)*.

---

## 1. Structural integrity

The physical module set is ADR-0020's, which supersedes ADR-0016 (confirmed in the owner's seat at
`docs/trail/architecture/cycle-30.md` § 2.1 — RN-44), which superseded ADR-0009 (the owner's confirm,
`docs/trail/architecture/cycle-9.md` § 2.3); this section is re-derived from `docs/SDD.md` § 3 as
it reads at v14 under that document's own rule that the § 4 statement wins (RN-22, RN-23): `nozoki-core` (`crates/nozoki-core`, Rust library — `fs-reader`, `git-reader` with the
Git port, `watcher`, `folder-model`, `own-state`, `markdown-renderer`, `highlighter`),
`nozoki-bridge` (`crates/nozoki-bridge`, Rust static library — `core-bridge`: the C ABI and the
Rust-side composition root), `nozoki-mac` (a Swift package — `mac-shell`, `surfaces`), and
`checks/` (build-time, not shipped). Part names are the SDD's (`docs/SDD.md` § 3); the Rust module
spelling of each is the developer's. **The tree holds ADR-0020's four units and nothing else**
*(corrected in place at v14 — RN-25, on the owner's seat's answer at
`docs/trail/architecture/cycle-11.md` § 3.1; through v12 this paragraph read the tree as holding
the previous shape alone, and at v13 as holding both shapes until the Tauri build's removal)*:
the native shell landed at `nozoki@99e2bac` — `crates/nozoki-bridge` and `nozoki-mac` are on
`main` — and the Tauri build left at `nozoki@0aca57e` (`git ls-files nozoki-ui crates/nozoki-app
| wc -l` → `0`, 2026-09-24; `docs/SDD.md` § 10 RC-3). Measured with `git ls-files`, not `ls`: a
working copy that built the previous shape can still list `nozoki-ui/` and `crates/nozoki-app/`
as untracked build output — `node_modules/`, `dist/`, `gen/`, `permissions/`, whose ignore lines
left with the build — and an `ls` there reads the old shape back into a tree that does not hold
it. The entries follow the SDD and the tree follows the entries — the reading RN-22 fixed for the
new units while they were unbuilt.

### 1.1 Architectural invariants

- **QC-1:** `nozoki-mac` holds no I/O of its own — no filesystem read, no network, no spawned
  process, no URL handed to another program, no web engine — and its only channel to the core is
  `SM-4`'s exported function list and `nozoki_free`, the seam's one release call beside the list,
  read through the generated header. The seam is where the promise
  is read, not where it is held: the wall is the process's entitlements (QC-25), and this entry is
  a source scan and a link check on every build, not a process boundary.
  — *verified by:* `checks/view.sh` (test layer 6) over `nozoki-mac/Sources` and the built
  executable (QC-34); the bridge's export set (QC-24); `checks/no-network.sh` *(traces to:
  ADR-0021; ADR-0014; SDD § 3
  SM-4; § 4 C-R7; re-derived at v11 — RN-22; `nozoki_free` named at v13 on the owner's addition at
  `docs/trail/architecture/cycle-10.md` § 2.1 — RN-24)*
- **QC-2:** No code path in any shipped unit opens a file under the granted folder for writing,
  creates, renames or removes an entry there, or creates a lock file in `.git`.
  — *verified by:* `checks/read-only.sh <fixture>` prints `unchanged` on every fixture after every
  command the build exports — a command being a call on `SM-4`'s list, driven through `SM-5`;
  `nozoki_free` is the seam's release call and no command, it never reaches the model (C-I3, C-R7
  at v16) — `.git` hashed where present (test
  layer 3); structural check (layer 6):
  `checks/structure.sh` rule *no write API in `nozoki-core` outside `own-state`*. The unit is the
  build: a build that exports a command has that command's operation on `SM-5`, so the walk calls
  it in that same build, and no test of a slice's own stands in for `read-only.sh`. **Not covered,
  and named so it is not read as coverage:** nothing in the build compares the calls the walk makes
  with the set the build exports, so their match is held by review of the change that exports a
  command, at `development-design` — the moment QC-3's reviewed half is held at — until a change
  makes it a check; no command does today, which is why that half is a review gate and says so
  here. And a fixture that offers no entry a command can act on exercises nothing for that command;
  which fixture a command needs is its slice's own bar (`docs/SDD.md` § 6) *(traces to:
  SRS NFR-5, NFR-6, C-2; SDD § 4 C-I3; ADR-0021; ADR-0011; the tail's IPC wording corrected on the
  owner's addition at `docs/trail/architecture/cycle-9.md` § 2.3 — RN-23; the command carve-out on
  the owner's addition at `docs/trail/architecture/cycle-10.md` § 2.1 — RN-24; the unit, the two
  uncovered cases and the reviewed half from SDD § 4 C-I3 and C-R7 as they read at v22, on the
  owner's seat's answer at `docs/trail/architecture/cycle-18.md` § 3.1 — RN-32)*
- **QC-3:** The shipped executable, `Nozoki.app/Contents/MacOS/Nozoki`, links no network
  transport, and every crate and package the bundle contains is named in `checks/deps.allow`. The
  claim is made of the executable and of nothing smaller. *What the build holds:* libgit2 is
  vendored with its `https` and `ssh` features off, and every manifest that names `git2` turns its
  default features off — a line with defaults on would turn HTTPS and SSH on for every crate that
  uses it, because Cargo unifies features across a build — so no TLS backend and no libssh2 is
  compiled or linked. *What it does not hold:* the vendored libgit2 compiles its transports and
  streams whatever the features, and registers `git://`, `http://` and `https://` with no guard
  (`libgit2-sys 0.18.8+1.9.7`, `build.rs:L152-L156`, `libgit2/src/libgit2/transport.c:L33-L35`), so
  this entry claims nothing of the library or of `nozoki-core` as a unit *(through v31 the first
  clause read "No shipped unit links a network transport: libgit2 is built without its HTTPS and
  SSH transports", which was false of the library and of `nozoki-core` — RN-43)*.
  — *verified by:* three halves, and the entry holds only with all three. **(1) The tree equals the
  list:** `checks/no-network.sh` — `cargo tree` diffed against the allowlist, non-zero on any hit,
  and non-zero where `nozoki-mac/Package.swift` declares a dependency or a `Package.resolved`
  exists — the view brings nothing to the tree (the tree). That diff proves nothing about a name
  the list admits. **(2) The
  list holds no transport:** the allowlist change reviewed as code in the same change (QC-26, at
  `development-design`), where the review judges each added name against this entry's domain —
  does it, **in the features the lockfile resolves**, link a network transport — and not only
  whether the addition is deliberate. A name alone cannot answer that: `cargo tree --offline
  --locked -e features -i <crate>` is what the review reads for a crate, and a feature-gated
  transport — libgit2's own HTTPS and SSH once a libgit2 binding is on the list, the case this
  entry's first clause states — is a condition no name diff sees. The names on the list before
  this half was stated (218 cargo and 163 pnpm, `bash checks/no-network.sh` at `nozoki@9b36a42`)
  passed the diff and were never reviewed against the domain. At `nozoki@0aca57e` the list is one
  `cargo:` section of 17 names (`checks/deps.allow:L18` onward); the `pnpm:` section and 201 of
  the 218 cargo names left with the Tauri build at `nozoki@fad4e78`, unreviewed, and none of them
  is shipped now; the 17 that stayed were among the 218 never reviewed, and until
  `nozoki@85d9fa7` no record showed the review — `nozoki@6acfb65` generated the list and read its names against the file's header
  rules, which is the reading by name this half says cannot answer the question, and
  `nozoki@fad4e78` records only that the tree equals the list *(the count and the commits on the
  owner's seat's answer at `docs/trail/architecture/cycle-11.md` § 3.2 — RN-25)*. **The one-time
  review is recorded**, at `nozoki@85d9fa7:checks/deps.review.md`, which landed in one commit with
  `checks/deps.allow` and `Cargo.lock`. At that commit the list is one `cargo:` section of 40
  names — the 17, the three `nozoki@21589c7` added (`bitflags`, `errno`, `rustix`) and the 20 the
  grammar engine brings (SDD § 3 `highlighter`) — and the record has one row for each of the 40.
  Every row reads `cargo tree --offline --locked -e features -i <crate>` and the crate's registry
  copy at the version the lock resolves, which is this half's question and not a reading by name.
  The record is cited at that commit because its own title, "every name on `checks/deps.allow`",
  stops being true at the next name added. Every name on the list has now passed one review or
  the other, and every later addition is reviewed under this half as before *(the closure on the
  owner's seat's answer at `docs/trail/architecture/cycle-20.md` § 3.1 — RN-34)*. No command judges
  whether a name is a transport, which is why the second half is a review gate at a named moment
  and says so here. **(3) The executable links none:** `checks/view.sh` (layer 6) reads the release
  executable with `nm`, red on a defined `git_smart_subtransport_*` symbol, on an undefined import
  of `connect`, `socket` or `getaddrinfo`, and where `nm` is missing, fails or prints no symbol,
  with a case in its suite `checks/tests/test_view.sh` that turns it red. The import half reads the
  release executable only, because a debug executable imports all three names through Rust's
  standard library with no libgit2 in it. The three names are a floor: a framework API that reaches
  the network is C-R7's scan's to find (QC-34), and the wall behind all three halves is QC-25.
  Beside that floor, the pattern does not match three symbols the release executable defines —
  `_git_socket_stream_global_init`, `_git_stream_registry_global_init` and
  `_git_transport_ssh_libssh2_global_init`. What they do was not read, no network call behind them
  is cited, and the pattern is not widened for them. The read is in the script from the build at
  `nozoki@392177d` (`checks/view.sh:L379-L404`), with its suite cases in
  `checks/tests/test_view.sh:L58-L64` — the four symbol reds at `:L58-L61`, the three cause reds at
  `:L62-L64` — and CI runs both on every push after `nozoki-mac/assemble.sh`
  (`.github/workflows/ci.yml:L41`, `:L51`, `:L54`). This half's gate is that script. The read has
  met an executable that links libgit2's open and status code. It has not met one that links the
  `nozoki_read_git` export (`crates/nozoki-bridge/src/exports.rs:L105`), which no Swift source
  calls. The read runs on every build, so it meets that executable in the build where `mac-shell`
  first calls the export, with nothing further owed *(through v37 this tail said the read was not
  in the script at `nozoki@8edec4f`, that no bridge function reached `git-reader` at that commit,
  and that its gate was `development-design` until the build that first exported one; that build
  landed at `nozoki@392177d` — RN-49)*. A red read is SDD § 11 R-15's — a re-cut recorded before anything is built on that
  export — and stating the claim lower is the owner's call under FDR PD-27. The manifest clause is
  held by `checks/tests/test_no_network.sh`'s `test_binding_has_no_https_or_ssh_transport`
  (`:L210-L235`), red where `git2` or `libgit2-sys` resolves an `https` or `ssh` feature on either
  macOS target it reads *(traces to: SDD § 4 C-R6 as it reads at v27 — the claim at the shipped
  executable, what the build holds and does not, every manifest's `git2` line, the allowlist change
  "reviewed in the same change"; § 4 C-I3 at v27 — the `nm` read, and `no-network.sh` failing on a
  Swift dependency; § 11 R-15; SRS NFR-8; FDR PD-27; ADR-0019; QC-26; the second half stated on the
  answer at `docs/trail/architecture/cycle-7.md` § 3.1 — RN-20; the claim restated and the third
  half added on the owner's seat's answer at `docs/trail/architecture/cycle-29.md` § 3.4, the
  manifest clause from SDD v27 — RN-43; the read as landed, what it has met, and the three defined
  symbols beside the floor from SDD § 4 C-R6 and C-I3 as they read at v31 (SDD RN-91), on the
  owner's seat's answer at `docs/trail/architecture/cycle-34.md` § 3.1 — RN-49)*
- **QC-4:** Every read the model holds is an item carrying an `ItemState` — `pending`, `observed`,
  `failed(condition)` or `stopped` — and no surface draws a marker, a count or a "nothing changed"
  from an item that is not `observed`.
  — *verified by:* unit tests on the reducer (layer 1): every read path yields a state;
  `swift test --package-path nozoki-mac` (layer 4): a projection with a `pending` item draws no
  marker, no count and no empty-folder sentence, and the only words it may carry for the state
  are the *Loading* sentence `docs/CONTENT.md` § Message patterns fixes — by pointer, never
  copied here (at `nozoki@69cc4b2` the check passes on
  `nozoki-mac/Tests/SurfacesTests/RootItemsViewTests.swift:L96-L115`, a `pending` row drawing its
  name and its glyph and nothing else; the cycle-15 fold, RN-29) *(traces
  to: SDD § 3 ItemState; § 4 C-I1, C-E1; SRS NFR-3; FDR R-19, R-36, R-94 — a state and not a
  string, at v10)*
- **QC-5:** The root finding never answers with a path above the granted folder; on `plain` the
  model holds no `GitState`, every Git-derived projection is empty, and the tree carries no marker.
  A `.git` file whose content is a `gitdir:` line answers `root`, and any other content answers
  `plain`; a `.git` file `probe` may not read is a condition, and a `.git` that is a symbolic link
  is not followed and keeps a condition. `probe` reads only inside the opened folder — the folder's
  own metadata, the `.git` entry's metadata without following a link, an entry inside a `.git`
  folder, and a `.git` file's own content — and never opens the Git directory a `.git` file names.
  Where that directory lies is `state()`'s to report (SDD § 11 R-3).
  — *verified by:* `cargo test --locked -p nozoki-core --test root_finding` over the plain,
  inside-a-repository, parent-of-two, linked-worktree and submodule fixtures (layer 2), with three
  cases this entry names: `linked-worktree` answers `Root`, `submodule` answers `Root`, and a scene
  whose `.git` file names a Git directory that does not exist answers `Root` — the case that goes
  red if `probe` ever follows the pointer, so the read bound has a check. All three are written
  and pass at `nozoki@48308ff`: `test_linked_worktree_answers_root`, `test_submodule_answers_root`
  and `test_git_file_naming_a_missing_git_directory_answers_root`
  (`crates/nozoki-core/tests/root_finding.rs:L175`, `:L185`, `:L196`). The adapter answers a `.git`
  regular file through `probe_git_file` (`crates/nozoki-core/src/git_reader/libgit2.rs:L46`,
  `:L58`), and CI runs the target under `cargo test --workspace --locked`
  (`.github/workflows/ci.yml:L26`). The missing-directory case does not hold the whole read bound.
  It goes red for a `probe` whose attempt to follow the pointer changes the answer. A `probe` that
  tries the pointer, swallows the failed open and still answers `Root` passes it, because the case
  asserts only the answer, that the answer holds no path, and that the scene is unchanged
  (`crates/nozoki-core/tests/root_finding.rs:L24-L37`, `:L65-L68`), and a swallowed open changes
  none of the three. No command can see the attempt. Seeing it would take a trace of every open
  `probe` makes, and this target has none. That half of the bound is held by QC-15's review at
  `development-design`, which judges which read the adapter makes inside its owner file
  *(through v33 this tail said none of the three was written at
  `nozoki@8edec4f`, where the `linked-worktree` and `submodule` cases asserted an unchanged scene
  and no outcome and the adapter answered a `.git` file with a provisional condition, and that all
  three would go red until the change replacing that arm landed. It landed at `nozoki@48308ff`.
  Drafted at v34 and confirmed at `docs/trail/architecture/cycle-32.md` § 2.1 — RN-45, RN-46)*
  *(traces to: ADR-0018; QC-15; SRS FR-33, FR-34, AC-24, AC-25; FDR R-15, R-21, R-101; SDD § 11 R-3;
  the `.git`-file answer, the read bound and the three cases on the owner's seat's answer at
  `docs/trail/architecture/cycle-29.md` § 3.1 — RN-43; the cases as written and passing, and what the
  missing-directory case does not reach, on the owner's seat's answer at
  `docs/trail/architecture/cycle-32.md` § 2.1 — RN-46)*
- **QC-6:** Every path derived from content or from outside — a tree entry, a symlink target, a
  Markdown image reference, a relative link, an `asset_bytes` call — passes `fs-reader`'s
  containment check before any open, and the check is the walk `docs/SDD.md` § 3 `fs-reader`
  defines: after percent-decoding, position by position from the granted folder; at every
  position inside the grant the canonical form is taken, symlinks resolved; at a position outside
  the grant nothing is read — no `lstat`, no `realpath` — and names are compared as spelled, the
  walk re-entering the grant only on the folder's own name met from its parent position — as
  spelled, or in another letter case where the folder is not the root of its volume and that
  volume ignores letter case, both read from the folder itself, and as spelled wherever it cannot
  be sure; a walk that ends inside the grant is contained and one that does not is refused. Three
  spellings are refused as outside although they may lead in: a path that leaves by more than one
  level and returns in another letter case, a Unicode-normalization difference, and a granted
  folder that is the root of its volume. `asset_bytes` re-runs the check on every call, and the
  check has one implementation its two callers do not re-implement. **Not covered, and named so it
  is not read as coverage:** a path the repository's own config names — `include.path`,
  `core.excludesfile`, `core.attributesfile` — which libgit2 follows with no containment check. In
  the bundle the sandbox (QC-25) is its only bound, in the in-process harness nothing bounds it,
  and how it is closed is SDD *Open Questions*' config-named-path item, settled in
  `see-git-status` before the slice is reached, with no build inside the slice bounding it. The
  bound is held by review of the change after which `see-git-status`'s *Reached when* is claimed
  whole: where the item's fixture and its case are missing at that review, the slice is not
  reached. From the first build in which `mac-shell` calls `nozoki_read_git` until the item is
  settled, the bundle opens a reader's own repositories with this read unsettled (SDD § 4 C-D3;
  § 11 R-16 and *Open Questions*' config-named-path item as they read at v32 — RN-51; through v39
  the bound read "no later than the build in which `mac-shell` first calls `nozoki_read_git`",
  from SDD v31 — RN-49; through v37 this pointer read "*Open Questions*' last item", which stopped
  naming this item at SDD v29).
  — *verified by:* unit tests on the check (layer 1, beside the module —
  `crates/nozoki-core/src/fs_reader.rs` `mod tests`): `..` leaving the grant and a symlink out end
  `Outside`; the four spellings the definition turns on — three fixed by `docs/fdr.md`'s example
  rows (`:L357-L358`), the fourth by R-184's second clause: the re-entry on the folder's own name
  in another letter case, in both forms the rows fix — `self → ../NOZOKI`, ending `Cycle`
  (R-152), and `up → ../NOZOKI/docs`, resolving inside and read as its target (R-34, R-151); the
  multi-level return (`far → ../../projects/NOZOKI/docs`) ending `Outside`; the volume root
  (`back → ../Work/notes.txt` under `/Volumes/Work`) ending `Outside`; and a Unicode-normalization
  difference ending `Outside`, which no example row exercises and which rests on R-184's second
  clause and SDD § 11 R-10 alone. None of the four is written at `nozoki@368f127` (`mod tests`
  holds the `..` and symlink cases, `:L412-L578`), and two go red when they are, until the change
  that builds the check as defined lands: the re-entry, in either form — the walk keeps one
  lexical position and at a position outside the grant moves it by name and touches nothing
  (`:L170-L177` states it, `:L211-L215` does it), so `../NOZOKI` ends `Outside` (measured at
  `docs/trail/sdd/cycle-15.md` § 5.1 on `nozoki@46bb275`; `git diff --stat 46bb275 368f127 --
  crates` prints nothing) — and the volume root, read from the code and not run: `..` pops the
  root to its parent (`:L201-L203`), `Work` re-enters lexically to a position equal to the root
  (`:L211-L215`), and `notes.txt` is then `lstat`ed from inside (`:L217`), so the walk reads what
  the definition refuses. That nothing is read at a position outside the grant
  is QC-35's, at layer 5, not a claim of these unit tests. `cargo test --locked -p nozoki-core
  --test markdown` — the `..` and symlink-out fixtures yield a placeholder node — and `cargo test
  --locked -p nozoki-bridge --test asset_bytes` — `asset_bytes` refuses them, tested in the bridge's
  crate where § 3 places the function (SDD § 6 S-3 at v14, RN-64) (layer 2) *(traces to: ADR-0015;
  ADR-0011; SDD § 3 `fs-reader` at v20, SM-7; § 4 C-D1, C-D3 — its uncovered case at v27, RN-43; § 9 TO-6; § 11 R-10, R-16; SRS FR-32,
  NFR-16; FDR R-34, R-59, R-62, R-183, R-184; the owner's answer at `docs/trail/sdd/cycle-15.md`
  § 5.1; the `asset_bytes` half moved to the bridge's crate at v12 — RN-23; re-derived on SDD v20 —
  RN-29; the config-named-path item's bound re-derived on SDD v32 (SDD RN-92) — RN-51)*
- **QC-7:** `git-reader` makes no mutating call — no checkout, index write, ref update or lock
  file — and spawns no process; every port method is read-only.
  — *verified by:* `checks/read-only.sh` on the Git fixtures with `.git/index` hashed (layer 3);
  `checks/structure.sh` rule *no `std::process` in any shipped crate* (layer 6) *(traces to:
  ADR-0019; SRS NFR-6, AC-2; SDD § 3 `git-reader` "Must not own")*

### 1.2 Forbidden imports

One graph, both halves stated. "May import" is the whole allowed set; "must not import" is stated
explicitly and never inferred. A module of `nozoki-core` that is no part is QC-63's, and importing
one is not an edge of this graph *(drafted at v29 — RN-40; confirmed at v30 — RN-41)*.

- **QC-8:** `nozoki-mac` may import AppKit and Foundation — the platform's own — and its own
  modules, and it links `libnozoki_bridge.a` through the generated header. It **must not** declare
  a package dependency (`Package.swift` declares none; no `Package.resolved` exists), **must not
  import** `WebKit` or `JavaScriptCore`, and `surfaces` **must not** reach the bridge — a surface
  hands `mac-shell` an intent and never calls `SM-4`.
  — *verified by:* `checks/view.sh` (layer 6): the forbidden-symbol scan over `nozoki-mac/Sources`
  and `otool -L` on the built executable naming neither `WebKit` nor `JavaScriptCore`;
  `checks/no-network.sh` — no Swift dependency, no `Package.resolved`; `swift test --package-path
  nozoki-mac` — the shell issues no call `SM-4` does not name (SDD § 6 S-1) *(traces to:
  ADR-0021; ADR-0014; ADR-0020; SDD § 3 `mac-shell` and `surfaces` "Must not own", SM-8; § 4 C-R6, C-R7;
  re-derived at v11 — RN-22)*
- **QC-9:** `nozoki-core` **must not import** any Apple framework or a binding to one, any crate
  outside `checks/deps.allow`, or `std::process`, and **holds no `unsafe`** — the workspace forbids
  it, and only `nozoki-bridge`'s manifest relaxes it. *No `unsafe`* is said of each crate's own
  Rust source. The C that `nozoki-core` links — the grammar engine's runtime and six grammars
  today (SDD § 3 `highlighter`), and libgit2, which `git-reader` links — is compiled in beside
  that source and is outside the claim, so this entry does not say the unit runs only
  memory-safe code. A fault in that C is bounded by the sandbox (QC-25), which this entry does
  not replace (SDD § 11 R-14).
  — *verified by:* `checks/no-network.sh`; `checks/structure.sh` (layer 6) — the imports, and
  `unsafe` appearing in no crate but `nozoki-bridge`; `cargo build --workspace --locked` under
  `[workspace.lints.rust] unsafe_code = "forbid"`, a build failure on an `unsafe` block in any
  crate whose manifest does not relax it *(traces to: ADR-0021; ADR-0020; ADR-0017; SDD § 3, the units paragraph; § 4 C-R6; `Cargo.toml`
  `[workspace.lints.rust]`; re-derived at v11 — RN-22; the limit from SDD § 3's units paragraph
  and § 11 R-14 as they read at v23 — RN-34; libgit2 stated as linked, which it has been since
  `nozoki@126ef75` (`crates/nozoki-core/Cargo.toml:L9`) — RN-43)*
- **QC-10:** `folder-model` may import `fs-reader`, the Git port trait and the plain-data types
  that cross SM-2 beside it, `watcher`,
  `markdown-renderer` and `highlighter` — the last two to fill the open `FileView`: the model
  calls `highlighter` for a text file in a floor language and `markdown-renderer` for a Markdown
  file, on the bytes `fs-reader` returned, and holds a call that fails as that item's
  `failed(condition)`. That is the one edge from the model into the two, in that direction only;
  neither imports the model (QC-11). It **must not import** the libgit2 binding, `git-reader`'s
  adapter, or `own-state`. The model's "I/O of any kind" holds through the edge: the renderer's
  containment call reaches the filesystem through `fs-reader` over `SM-7`, never through the
  model.
  — *verified by:* `checks/structure.sh` (layer 6) *(traces to: ADR-0019; ADR-0020; SDD § 3 SM-2 at v26
  — "the model imports the trait and those types, and never the adapter" — added on the owner's
  seat's answer at `docs/trail/architecture/cycle-29.md` § 3.2, RN-43; SDD § 3
  `folder-model` "Owns" and "Must not own" as they read at v14, and the units paragraph's edge
  sentence (SDD RN-64); the reading answered in the owner's seat at
  `docs/trail/architecture/cycle-9.md` § 1.1 and confirmed on the SDD's companion at
  `nozoki@705d306` (its reasoning, `docs/trail/sdd/self_answer-22.md` § 2.4); `arch_defaults.md`
  § Dependency Graph Rules; transcribed at v12 — RN-23)*
- **QC-11:** `fs-reader`, `git-reader`, `watcher`, `highlighter` and `markdown-renderer` **must not
  import** `folder-model`, `own-state`, or one another — with two stated edges: `markdown-renderer`
  imports `fs-reader`'s containment check, and `highlighter` for a fenced block's spans. Only
  `git-reader` imports the libgit2 binding, with one exception: `core-bridge` names it in the
  composition root's config search-path switch and that switch's test, and nowhere else (QC-17).
  — *verified by:* `checks/structure.sh` (layer 6), for the clauses its header holds. The
  exception's bound — the switch and its test, and nowhere else in the bridge — is review at
  `development-design`: the script does not hold the import rule outside the three units' files it
  reads (`checks/structure.sh:L257-L258` at `nozoki@392177d`). The change that built the switch
  (`nozoki@392177d`) did not add the rule to the script, so the bound stays review until a change
  adds it, by the header's rule. At that commit the bridge files that name `git2` are
  `crates/nozoki-bridge/src/machine_config.rs`, `crates/nozoki-bridge/tests/search_path.rs` and the
  manifest, which is the exception's bound exactly *(drafted at v38 — RN-49; confirmed in the
  owner's seat at `docs/trail/architecture/cycle-35.md` § 2.1 — RN-50; through v37 this tail pinned the script at `:L249-L250` at `nozoki@8edec4f` and named
  changing it for the exception as the design of the change that builds the switch, SDD
  RN-87)* *(traces to: ADR-0019; ADR-0015;
  ADR-0020; SDD § 3, the units paragraph at v27 — the exception, RN-87; SDD § 3, the units paragraph's stated edges as it reads at v14 — the two into `fs-reader` and
  `highlighter`; the model's edge into the two runs the other way and is QC-10's — the
  `markdown-renderer` and `highlighter` rows; re-derived at v11 — RN-22; the third edge placed at
  v12 — RN-23; SDD § 3 SM-1's owner cell, read on the owner's seat's answer at
  `docs/trail/architecture/cycle-26.md` § 3.1 — the model *states* what a read must return and
  does not hold the types, and SM-2 reads the same way at v26: `git-reader` defines the port's
  trait and the plain-data types that cross beside it, `folder-model` states what the port must
  answer, and a type that crosses SM-2 is defined in `git-reader` or in a value module (QC-63) and
  never in `folder-model` (SDD SM-2, RN-85; on the owner's seat's answer at
  `docs/trail/architecture/cycle-29.md` § 3.2 — RN-43; through v31 this read "unlike SM-2's
  port") — so a type that crosses SM-1 is defined where `fs-reader` may import it and never in
  `folder-model`; `OpenFailure`, defined at
  `crates/nozoki-core/src/folder_model.rs:L38` and imported at `fs_reader.rs:L14` at
  `nozoki@803b599`, is the one type that does not, and moves to `fs-reader` by a
  behaviour-preserving change that keeps `nozoki_core::OpenFailure`; `checks/structure.sh` holds
  the `fs-reader` → `folder-model` clause from that change, and until it the clause's gate is
  `development-design` — RN-40)*
- **QC-63:** A module of `nozoki-core` that is no SDD part is a **value module**: it holds types
  and values only — shared between parts, or exposed through the crate's public surface — holds no
  I/O (QC-15), and **imports no part**. Any part may import a value module, and that import is not
  an edge of this graph: QC-10's and QC-11's sets neither name it nor need to. A module that would
  have to import a part to hold its type is not a value module; the type moves into a part, under
  QC-10 and QC-11, so no forbidden edge can route through a module the graph does not see.
  `lib.rs` is the crate's re-export surface: it declares the modules and re-exports from them,
  holds no implementation, and is neither a part nor a value module. At `nozoki@803b599` the
  value modules are `language` and `error`, and neither imports a part.
  — *verified by:* `checks/structure.sh` (layer 6): a file of `nozoki-core` that belongs to no
  unit, `lib.rs` aside, and imports a unit is a finding — a rule this document adds to the script
  (RN-40); until the change that adds it, its gate is `development-design` reading this entry, by
  the header's rule. The no-I/O half is QC-15's scan, which already reads every Rust I/O primitive
  against its owner. The types-and-values half is review at `development-design`, in the form
  QC-13 takes for its delegation half: what counts as behaviour is not greppable. A value module
  can hold a part's behaviour while importing no part and doing no I/O — `fs-reader`'s extension
  map moved into `language` as a method on `Language` passes both machine halves — so the review
  asks whether a value module holds anything a part's *Owns* cell in SDD § 3 names *(traces to:
  § 1.2's lead rule, "never inferred"; SDD § 3, the parts table and the units paragraph, which
  name the core's parts and no module beside them, and "the physical layout is the developer's"
  (`docs/SDD.md:L433`), which leaves a module of no part to this section — ADR-0020 hands the
  module boundaries to § 1.2
  (`docs/adr/0020-physical-unit-set-the-bridge-switches-off-libgit2-machine-config-reads.md:L140-L142`,
  carried from ADR-0016 at v33 — RN-44);
  SDD SM-1 (`docs/SDD.md:L415`), across which `Language` passes from `fs-reader`, which names it
  (`:L322`), to `highlighter`, which must not (`:L327`), two parts the units paragraph gives no
  edge between (`:L347-L349`) — so no part holds `Language` without an edge the SDD does not
  state; drafted at v29 — RN-40; confirmed in the owner's seat at
  `docs/trail/architecture/cycle-27.md` § 2.1, the review half added there — RN-41; raised at
  `docs/trail/architecture/self_answer-30.md` § Raised on this document; `arch_defaults.md`
  § Dependency Graph Rules)*
- **QC-12:** `own-state` **must not import** `fs-reader`, `git-reader`, `watcher`, `folder-model`
  or `markdown-renderer`; it reads and writes only inside the app's container.
  — *verified by:* `checks/structure.sh` (layer 6); `checks/own-state.sh` (layer 5) *(traces to:
  ADR-0020; SDD § 3 `own-state`; § 4 C-D2)*
- **QC-13:** `nozoki-bridge` may import `nozoki-core`, the standard library and the crates
  `checks/deps.allow` names — the whole allowed set, in the form QC-9 bounds `nozoki-core` with,
  and never a hand-kept list of names, which goes false at the bridge's next reviewed dependency.
  It **must not
  import** any Apple framework or `std::fs` outside its log writer, and holds no read logic: every
  exported function decodes its arguments, calls `folder-model`, and returns plain data as an
  owned buffer freed by `nozoki_free`. Beside the exported functions it runs process setup before
  first use — the log writer's install and libgit2's config search-path switch (QC-17) — and that
  setup is no read logic. It is the one unit that holds `unsafe`, relaxed in its own
  manifest with the reason recorded; every function catches a panic at the boundary and returns a
  failure value; the header is generated from its source and never hand-edited.
  — *verified by:* `checks/structure.sh` (layer 6) for the imports; `cargo test --locked -p
  nozoki-bridge --test exports` — the header declares what the library exports and nothing else
  (QC-24); the bridge's tests under `-Zsanitizer=address` in CI on every build (layer 2); review at
  `development-design` for the delegation rule — what counts as logic is not greppable, and the
  import rule is the part that is; the allowlist admits a crate to the workspace and not to a
  purpose, so a listed parser or grammar engine imported to put read logic in the bridge is that
  review's catch, and QC-11 keeps the libgit2 binding out by name but for the search-path switch
  and its test (QC-17) *(traces to: ADR-0014; ADR-0020; SDD § 3 `core-bridge`
  "Owns" and "Must not own" as they read at v27 — the switch, RN-87, re-derived at v32, RN-43 —
  SM-4; § 4 C-I2; § 11 R-13; `arch_defaults.md` § Application Layer; re-derived at v11 —
  RN-22; the *may import* set answered in the owner's seat at
  `docs/trail/architecture/cycle-10.md` § 3.1 — RN-24)*
- **QC-14:** `checks/` may import `nozoki-core` and is **never a dependency of any shipped
  unit** — the `nozoki-core` library, the `nozoki-bridge` static library or the `nozoki-mac`
  executable, each as it ships, and never a test target declared in one of their manifests — and
  never ships in the bundle.
  — *verified by:* `cargo tree -p nozoki-bridge` names no `checks` crate; `checks/structure.sh`
  (layer 6); `checks/bundle.sh` — nothing of `checks/` under `Contents/` (layer 5) *(traces to:
  ADR-0010; ADR-0020; SDD § 3 `read-only-harness` "Must not own"; the shipped-unit qualifier
  restored at v25 from those two sources, answered at `docs/trail/architecture/cycle-22.md`
  § 3.1 — RN-36)*

### 1.3 Layer isolation

- **QC-15:** I/O ownership is fixed: folder reads are `fs-reader`'s (bytes, listings) and
  `git-reader`'s (Git's on-disk state through libgit2, and, outside libgit2, reads bounded to the
  opened folder: the folder's own metadata; its `.git` entry's metadata without following a link;
  an entry inside a `.git` folder; a `.git` file's own content; the metadata, and a link's own
  text, at each position inside the folder along the spelled path to the Git directory and to the
  common directory; and the content of the `commondir` file in a Git directory that lies inside
  the folder — never a path past the folder and never a link followed out of it); change
  notifications are `watcher`'s
  (FSEvents); the diagnostic log writer is `nozoki-bridge`'s; the Open panel and the one window
  are `mac-shell`'s, in `nozoki-mac`; drawing is `surfaces`', in `nozoki-mac`, which holds no I/O
  of its own; **no unit owns a socket and no unit spawns a process.**
  — *verified by:* `checks/structure.sh` (layer 6): each Rust I/O primitive appears only in its
  owner. Its filesystem clause exempts three owner files by exact path: `fs_reader.rs`,
  `log_writer.rs` and `git-reader`'s adapter, `crates/nozoki-core/src/git_reader/libgit2.rs`
  (`checks/structure.sh:L77-L80`, the exempting `case` at `:L1161`, at `nozoki@48308ff`). The
  adapter may name `std::fs`, and a `std::fs` read anywhere else in `git-reader` is a finding. The
  suite holds the exemption to the exact path. `test_exemption_is_exact_for_the_adapter_name`
  plants a `std::fs` write under the adapter's file name at six other paths and requires a QC-15
  finding at each, and `test_git_owner_write_is_still_one_qc2_finding` holds that the exemption
  lifts this clause only (`checks/tests/test_structure.sh:L961`, `:L931`). The scan does not see a
  `Path` method that touches the filesystem, in any crate, because such a method names no
  filesystem module (`checks/structure.sh:L266-L267`, *GAPS THE RULES ABOVE DO NOT CLOSE*). Two
  parts of the `git-reader` bound are therefore not held by the script (`:L253-L256`). The first is
  which read the adapter makes inside its owner file: the script admits every filesystem form
  there, so it cannot tell a read inside the folder from one past it. The second is `git-reader`'s
  `Path`-method reads, which is how the adapter reads the folder, the `.git` entry and each
  position along a spelled path (`crates/nozoki-core/src/git_reader/libgit2.rs:L54`, `:L58`,
  `:L103`, `:L163`, `:L513`, at `nozoki@6a0725c`; the `.git` file's open is at `:L439` and its
  handle's `metadata()` at `:L446`) *(through v36 these locators were pinned at `nozoki@48308ff`,
  as `:L38`, `:L42`, `:L136`, `:L62` and `:L69`, before `state()` and the walk landed — RN-48)*.
  For those two parts only, the bound is review
  at `development-design`, which judges each against the clause above *(through v33 this tail
  exempted two owner files at `nozoki@8edec4f`, named QC-15's other owners as not held, and held
  the adapter's file as a rule still to come, with review as the whole bound until it came. The
  change that adds it merged at `nozoki@48308ff`. On the owner's seat's answer at
  `docs/trail/architecture/cycle-31.md` § 3.1 — RN-45)*. `checks/view.sh` (layer 6): no I/O
  primitive in `nozoki-mac/Sources` at all *(traces to: ADR-0021; ADR-0020; ADR-0018; SDD § 3 parts
  table, and the `git-reader` row's *Must not own*, "A file outside Git's own on-disk layout"; § 4
  C-R7; the bounded reads and their gate on the owner's seat's answer at
  `docs/trail/architecture/cycle-29.md` § 3.3 — RN-43; the three owner files, the suite's two
  cases and the narrowed gate on the owner's seat's answer at
  `docs/trail/architecture/cycle-31.md` § 3.1 — RN-45; the walk's reads and the `commondir` read
  named in the list, and the `Path`-method locators re-pinned at `nozoki@6a0725c`, on the owner's
  seat's answer at `docs/trail/architecture/cycle-33.md` § 3.1 — RN-48)*
- **QC-16:** The only writes the product performs are `own-state`'s and the bridge's diagnostic
  log, both inside `~/Library/Containers/com.kensaiapp.nozoki/`.
  — *verified by:* `checks/own-state.sh` — after a session every changed file under `$HOME` is
  under the container and none under the fixture (layer 5) *(traces to: SDD § 4 C-D2, C-I2; SRS
  FR-21, AC-13; ADR-0021; ADR-0020 — the trace its § Binds names, added at v12 against ADR-0016 — RN-23 — and carried to ADR-0020 at v33, RN-44)*
- **QC-17:** Two composition roots, one per language, and each is the single place its runtime is
  touched: `nozoki-bridge` is the Rust-side root — the only place the libgit2 adapter is wired to
  the Git port, the only place the log writer is installed, and the only place libgit2's four
  machine-level config search paths — system, global, XDG and programdata — are set to empty. That
  is four `git2::opts::set_search_path` calls, run once per process, before the adapter is wired and
  before any thread can reach libgit2, and failing closed: if any of the four fails, the adapter is
  not wired and the Git item is `failed`, so no repository is opened with those reads on.
  `mac-shell` in `nozoki-mac` is the
  app's root — the only place `NSApplication` and the one window are created and the only place
  `SM-4` is called.
  — *verified by:* `checks/structure.sh` (layer 6): the adapter's constructor and `log::set_logger`
  / `log::set_boxed_logger` appear only under `crates/nozoki-bridge/src/`; `checks/view.sh`
  (layer 6): a `nozoki_` symbol the header declares is called from `mac-shell`'s sources and from
  no file of `surfaces` — a rule this document adds to the script (RN-22); `cargo test --locked -p
  nozoki-bridge`, which CI runs on every push inside `cargo test --workspace --locked`
  (`.github/workflows/ci.yml:L26`). The switch is `crates/nozoki-bridge/src/machine_config.rs`,
  landed at `nozoki@392177d`, and the suite holds its three promises. The four empty paths:
  `test_the_switch_against_the_real_libgit2` (`crates/nozoki-bridge/tests/search_path.rs:L36`),
  whose first arrival is a production session's open, after which it reads each of the four
  levels' search paths back empty with `git2::opts::get_search_path` (`:L47-L55`). Failing closed
  and once per process: `machine_config.rs`'s `mod tests` — any one of the four erring is `Failed`
  (`:L213`), no retry after `Failed` (`:L249`), and concurrent first arrivals set four paths in
  total (`:L262`) — and `session.rs`'s erring-setter cases, in which the Git item answers that the
  config was not switched off (`:L1729`) and stays so after a second folder opens (`:L1740`). The
  read-back proves four empty paths and observes no read: the step from an empty path to no file
  touched is `libgit2/src/libgit2/sysdir.c:L559-L560` in the registry copy of
  `libgit2-sys 0.18.8+1.9.7`, read and not run. A bridge that wires the adapter with no switch run
  before it, or with no test of the switch, violates this entry *(through v37 this tail said the
  switch and its test were not in the tree at `nozoki@8edec4f`, and that the gate was
  `development-design` until the change that wires the adapter in the bridge; that change landed at
  `nozoki@392177d` — RN-49)*. A libgit2 release that adds a fifth
  level is not caught by a test naming four, and the lockfile change reviewed as code (QC-26) is
  the only gate for it *(traces to: ADR-0014; ADR-0020; SDD § 3 `core-bridge`
  as it reads at v27, `mac-shell`, SM-8; § 4 C-I3 at v27 — the bridge test and what it does not
  reach; SDD RN-87; `arch_defaults.md` § Composition Root; re-derived at v11 — RN-22; the switch
  re-derived at v32 — RN-43; the switch, its read-back and its fail-closed and once-per-process
  tests as landed, from SDD § 4 C-I3 as it reads at v31 (SDD RN-91), on the owner's seat's answer
  at `docs/trail/architecture/cycle-34.md` § 3.2 — RN-49)*

### 1.4 Replaceability

- **QC-18:** Swapping the Git mechanism — libgit2 for the installed `git` run with
  `--no-optional-locks` — touches `git-reader` (the adapter) and `nozoki-bridge`'s wiring only; the
  port, the model and the surfaces do not change.
  — *verified by:* review at `development-design` when a change touches `git-reader`; the port's
  contract tests (QC-50) pass unchanged against the new adapter *(traces to: FDR PD-29; SRS § 5.3;
  ADR-0019)*
- **QC-19:** The viewed folder is an input, not a structural singleton: opening a different folder
  replaces the whole model, and adding the folder selector touches `folder-model`'s replace,
  `own-state`'s bookmarks, `mac-shell`'s launch-time restore and the shell chrome only — the tree,
  the Git view and the reading panel
  do not change.
  — *verified by:* `cargo test --locked -p nozoki-core --test switch` (layer 3);
  `git diff --stat <first-public-release tag>..HEAD -- nozoki-mac` lists only files of the selector
  and of `mac-shell`'s launch-time restore, and no file of the tree, the Git view or the reading
  panel, on the change that adds the selector (the change) *(traces to: SRS NFR-12, FR-19; FDR
  PD-29; SDD § 3 `folder-model`, § 6 S-10 as it reads at v13; re-derived at v11 — RN-22)*
- **QC-20:** Swapping `own-state`'s storage format touches `own-state` only; no other unit reads
  the container.
  — *verified by:* `checks/structure.sh` (layer 6): the container path appears only in `own-state`
  and the bridge's log writer *(traces to: SDD § 3 SM-6; ADR-0020)*
- **QC-21:** No swap invariant is held for the platform or for the view technology. The platform
  is not replaceable inside the terminus. The view technology was replaced **once, before any
  public release** — from the system WKWebView to AppKit in Swift, on the owner's ruling
  (ADR-0014, superseding ADR-0002) — and is not replaceable again inside
  the terminus; reversing it now costs what ADR-0014 states, every surface rewritten. A change that
  claims either is cheap to replace is wrong, and a second swap of the view is a change that
  contradicts `docs/fdr.md` PD-29 and goes to the owner, never a design call inside a change.
  — *verified by:* review at `development-design` — a stated non-invariant has nothing to run
  *(traces to: FDR PD-29 as it reads at v8 — the owner's confirm at `docs/trail/fdr/cycle-5.md`
  § 2.1; SDD § 2 force 4, "Undoing it", § 9 TO-4, § 10 RC-3; ADR-0014;
  re-derived at v11 — RN-22)*

## 2. Security

**Trust boundaries, named.** (1) The granted folder ↔ the core: everything under the folder is
untrusted, live input (`docs/SRS.md` § 6 DR-6). (2) The core ↔ the shell: `SM-4`'s exported
function list, read through the generated header — where the promise is read, not where it is
held (`docs/SDD.md` § 3 SM-4). (3) The bundle ↔ the operating system: the App Sandbox and its
entitlements, bound by a rule (ADR-0011). (4) The dependency tree ↔ the build: the allowlist,
`Cargo.lock`, and a `Package.swift` that declares nothing (`docs/SDD.md` § 4 C-R6). (5) The release
artifact ↔ the adopter: a CI build from a tag with a published checksum (ADR-0007). The threat
classes are a desktop reader's: hostile file content reaching an interpreter or a decoder, a path
that escapes the folder, a dependency that brings a capability, and an artifact that is not the
reviewed tag.

- **QC-22:** Rendering the hostile fixture yields a `MarkdownDocument` — never HTML — in which
  every node's kind is in `docs/SDD.md` § 3's closed set; the script, the event attribute, the
  frame, the style and the raw HTML block are each a text node holding their source verbatim;
  exactly one image node is *resolved* — the in-folder PNG, to its folder-relative path — and the
  remote, `..` and symlink-out references are each a placeholder node carrying *outside the
  folder*, the in-folder SVG a placeholder carrying *a format not decoded*; the external link is an
  *external* node with its destination readable; the relative link is a *relative* node with its
  target path; and no node carries markup or a URL.
  — *verified by:* `cargo test --locked -p nozoki-core --test markdown` over `checks/fixtures/hostile.md`
  (layer 2) *(traces to: SRS NFR-16, FR-32, AC-23; SDD § 3 `markdown-renderer` and the
  `MarkdownDocument` entity; § 4 C-D3; § 6 S-3, command half; § SDD Review Notes RN-8 — the SVG
  case; ADR-0015; re-derived at v11 —
  RN-22)*
- **QC-23:** No web engine of any kind is in the product: `nozoki-mac` links neither `WebKit` nor
  `JavaScriptCore`; its sources hold no `WKWebView`, `WebView`, `JSContext`, or
  `NSAttributedString` initialised from HTML or with the `.html` document type; and no crate in the
  resolved tree is a web engine or a binding to one. There is no Content Security Policy to
  declare, because there is no engine to declare it to — the previous shape's CSP and its
  `<asset-scheme>` keying, which this entry carried through v10, are retired with it.
  — *verified by:* `checks/view.sh` (layer 6): the forbidden-symbol scan over `nozoki-mac/Sources`
  and `otool -L` on the built executable; `checks/no-network.sh` with QC-3's second half — an
  allowlist change that admits a web engine or a binding to one is refused at the same-change
  review, by name, under C-R1 (the tree; the change) *(traces to: SDD § 4 C-R1 — "no web engine of
  any kind", C-R7; § 10 RC-3; ADR-0014;
  ADR-0015; the two-state form this entry carried through v10 was answered in the
  owner's seat at `docs/trail/architecture/cycle-5.md` § 3.2 — RN-18 — and is history; re-derived
  at v11 — RN-22)*
- **QC-24:** A build exports to the shell exactly the functions its landed changes built — set
  equality between the C symbols `libnozoki_bridge.a` exports (`nm -gU`, the `nozoki_` prefix) and
  the functions the generated header declares — and that set is always inside the closed list
  `docs/SDD.md` § 3 `SM-4` names — `open_folder`, `list_tree`, `select_file`, `open_relative_link`,
  `read_git`, `set_theme`, `open_diff`, `walk_history`, `switch_folder`, `asset_bytes`, ten *(nine
  through v37, without `read_git` — RN-49)* — and `nozoki_free`,
  the seam's one release call beside the list and not on it, exported from the first build on
  because every call's return is an owned buffer it alone frees. No listed function is exported
  before a landed change has built it — a change has built a function when the bridge function
  exists and delegates to an operation `folder-model`'s API carries (`SM-5`) — and from `v1.0.0`
  the set is that list whole and `nozoki_free`. No
  second plumbing export — a registration call for `model_changed`, or any other — is admitted:
  one is raised on C-R7 and `SM-4` by the slice that needs it, and not before. The header is generated
  from the bridge's source and never hand-kept; the test reads the exported set and never a
  hand-kept copy of it, and an exported set it cannot read fails the test — never a pass.
  **Not covered before `v1.0.0`, and named so it is not read as coverage:** a change that stops
  exporting a function an earlier slice built passes this check, because the export and the
  header move together; until QC-59's pin exists, only that slice's own bar holds the function.
  — *verified by:* `cargo test --locked -p nozoki-bridge --test exports` (layer 2), holding two
  things: set equality between the exported symbols and the header's declarations, and that set
  inside the list above and `nozoki_free`. From `v1.0.0` the whole list and `nozoki_free` are held
  by QC-59's pin, which reads `SM-4`'s function list and `nozoki_free` as the bridge exports them
  *(traces to: SDD § 3 SM-4 as it reads at v30 — the list of ten, `read_git` added (SDD § 10 RC-4,
  RN-90) — RN-49; § 4 C-R7 as it reads at v22 — the export staged by change and not by
  slice, and what *built* means, on the owner's seat's answer at
  `docs/trail/architecture/cycle-18.md` § 3.1 — RN-32;
  § 4 C-I6; § 11 R-12; § SDD Review Notes RN-47, RN-60, RN-66; ADR-0021 — RN-49, accepted over
  ADR-0013 at v39 — RN-50; ADR-0020, whose units table names `nozoki_free` apart from the list; QC-59; the staged form answered in the owner's seat at
  `docs/trail/architecture/cycle-6.md` § 3.1 — RN-19 — carried from the capability file to the
  export set at v11 — RN-22; `nozoki_free` beside the list confirmed with additions in the owner's
  seat at `docs/trail/architecture/cycle-10.md` § 2.1 — RN-24)*
- **QC-25:** The bundle's entitlement set is bound by C-R2's rule, not held as a list. **No
  network entitlement of any kind** — neither `com.apple.security.network.client` nor
  `com.apple.security.network.server`, and no exception entitlement that reaches the network under
  another name, `com.apple.security.temporary-exception.mach-lookup.global-name` for
  `com.apple.nsurlsessiond` named as the one WebKit's own check would take.
  `com.apple.security.app-sandbox` with `com.apple.security.files.user-selected.read-only` — the
  read-only grant on the chosen folder. `com.apple.security.files.bookmarks.app-scope` from the
  slice that adds the folder selector, its need recorded (ADR-0011). **Any other entitlement only
  with a record in `docs/adr/` naming why it is needed**, and only where the probe below still finds
  the launched process sandboxed with both operations denied. And the launched bundle runs
  sandboxed.
  — *verified by:* two halves, and the entry holds only with both. **(1) The set equals the recorded
  set, and the process is sandboxed:** `checks/bundle.sh` — `codesign -d --entitlements :-
  Nozoki.app` equals the set the script expects (`nozoki@0aca57e:checks/bundle.sh:L132-L133`,
  the range pinned to the commit it was read at — RN-25; the two v1 entitlements today), every
  value boolean true; an entitlement the bundle carries that the script
  does not expect fails the build, and a bundle that fails there is never launched. The script then
  launches the bundle, takes the pid of the main process that run started — found by its absolute
  executable path, with no instance of it running beforehand — and asks the operating system about
  that pid, through libSystem's `sandbox_check`, within a bounded window after launch. It fails
  unless one ask inside the window reports the pid sandboxed **and** reports a file read outside the
  grant and an outbound network connection both denied for it; the pass is the first ask on which
  all three hold at once. The bound is the script's to fix — the SDD states no number — and the
  script prints it on the pass line and on a red run that ended because the window ran out, the only
  red run the bound reaches; a run ended by a failed ask — `sandbox_check` missing or returning an
  error, or the pid no longer naming a process — ends at once, names what failed, and prints no
  bound. Before every ask the script checks that the pid still names a process, because
  `sandbox_check` answers "sandboxed, everything denied" for a pid that names none; a process gone
  before the pass fails, on that same failed-ask path. The build also fails when no pid is found,
  or when more than one is. The script's suite runs the same probe on the same binary built with no
  entitlements — the negative control, without which the probe has not run — and requires it to
  answer `sandboxed: no` on every ask for the whole window; its red run ends at once on the first
  report that is not `sandboxed: no`, and of its lines only the pass line prints the bound. The two
  denials test the wall rather than a proxy for it where the unentitled control reports them
  allowed; on a GitHub-hosted macOS runner that holds of the outbound half only — there the
  out-of-grant read is reported denied for the unentitled control on every ask as well, so on the
  runner the wall is evidenced by the sandboxed report and the outbound denial, and the read denial
  separates nothing. Why the runner reports it that way is not known, and whether the one Mac
  measured reports that read allowed for the control is not recorded. A container directory that
  already exists is never evidence, and no environment variable is. Two cases the window does not
  cover: a report that turns from `yes` back to `no` after the pass is never read; and the
  failed-ask line does not say on which ask the run ended. **(2) The recorded set holds no network
  entitlement, and every member has its record:** the change that widens the script's expected set
  is reviewed as code in the same change, at `development-design` — the pattern QC-26 fixes for
  `checks/deps.allow` — and the review asks two questions of each added key: is it one of Apple's
  two network entitlements, or an exception entitlement that reaches the network under another
  name, which no record may admit; and does a record in `docs/adr/` name its need. No command
  judges whether an exception entitlement reaches the network under another name — WebKit's own
  check treats a `mach-lookup` as a stand-in for that question — which is why the second half is a
  review gate at a named moment and says so here. On every CI build and as a release gate
  (layer 5) *(traces to: SDD § 4 C-R2, C-I3 as they read at SDD v13 — the probe half unchanged since v9;
  § 10 RC-1, RC-2, RC-3 *Retained*; § 11 R-8;
  § SDD Review Notes RN-48, RN-50, RN-52; the owner's ruling at `docs/trail/sdd/cycle-8.md` § 5.1,
  answers 1–2; ADR-0011 — Accepted, superseding ADR-0003; ADR-0010; the tail's window re-derived
  from C-I3 at SDD v8 on the answers at `docs/trail/architecture/cycle-7.md` §§ 3.2, 3.3 — RN-20;
  the rule, the second half and the failed-ask scoping re-derived at v10 — RN-21 — and confirmed
  in the owner's seat at `docs/trail/architecture/cycle-8.md` § 2.1 — RN-22)*
- **QC-62:** The bundle CI ships runs its shell under its shipped entitlements. On every CI build,
  after `checks/bundle.sh` and never instead of it, the launched main process of the bundle CI
  built — launched as a user launches it, its pid taken the way `checks/bundle.sh` takes it — is
  observed **parked in the Open panel's modal run, inside the shell's launch frames** — the
  shell's first and only unconditional act, presenting the Open panel at launch (C-R3) and parked
  in it until someone answers; `open_folder` is not among those frames, because the shell calls it
  only after the panel returns (`nozoki-mac/Sources/Shell/LaunchFlow.swift`, `chooseFolder()` and
  `openAndList(_:through:)` — `:L54-L60` and `:L69` at `nozoki@7c7038f`) and the gate
  sends no input — within a bounded window, and the observation is the operating system's or the
  process's own report: never a marker the product writes for the check, never an environment
  variable, never a code path that exists for the gate. The gate's negative control —
  `checks/fixtures/idle-shell`, a bundle the harness owns: an AppKit executable that opens one
  window and never presents the panel, signed and entitled as the product is — goes red. A runner
  image or macOS whose Open-panel frames read differently turns the gate red on the next build;
  that is a re-cut trigger on the gate's mechanism, never on the gate. A red is never cleared by
  granting an entitlement or by skipping the script *(through v14 this entry read the observation
  as "inside `open_folder`'s call" — the page's act, not the native shell's — and carried the
  owner's cycle-8 rule that the gate is red by construction until the native shell lands, true of
  the tree as written then; from `nozoki@153f5a1` that tree is gone and the rule is history, its
  never-cleared clause standing on C-I3's *Violated by* and ADR-0011; on the owner's seat's
  answers at `docs/trail/architecture/cycle-12.md` §§ 3.1, 3.2 — RN-26)*.
  — *verified by:* `checks/renderer.sh Nozoki.app` and its `idle-shell` control (layer 5), in the
  tree since `nozoki@153f5a1` and run on every CI build as `Renderer gate`
  (`.github/workflows/ci.yml:L46-L47` at `nozoki@ab39502` — `:L43-L44` at `nozoki@153f5a1`, moved
  when `View check suite` landed above it at `:L41-L42`), after `Bundle probe` (`:L31-L32`,
  unmoved) — the script fixes the mechanism it reads and the bound, and prints the bound the way
  `checks/bundle.sh` does; the
  frame list is the script's header's (`checks/renderer.sh`, header § *THE FRAMES* — the list at
  `:L53-L56` at `nozoki@7c7038f`), cited and not copied here,
  the way C-I3 cites it, so the next re-measurement moves one file. The frames were re-measured
  on the first slice's first native bundle: on a Mac, recorded in the script's header
  (`checks/renderer.sh`, header § *THE FRAMES* — `:L57-L60` at `nozoki@7c7038f`, macOS 26.6.2),
  and on a GitHub-hosted runner — GitHub Actions run 35988399477 on `nozoki@37a962d`, image
  `macos-14-arm64` 20260831.0302.1, macOS 14.8.9 — where the product matched the five-frame list
  the script carried at that commit on observation 1 and the control on none of 30, recorded in
  the script's header from `nozoki@2b83dce` (`:L61-L64` at `nozoki@7c7038f`) and cited from there
  as the Mac reading is. The list has held four frames since `nozoki@b75348f`, which removed
  `LaunchFlow.run()` from it; the four-frame list matched on the same runner image at run
  36795836747 (`nozoki@702f7c4`), again on observation 1 with the control matched on none of 30
  (`docs/SDD.md` § 4 C-I3 at v22; SDD RN-76) *(the citations and the frame count re-pointed and
  pinned at v21 — RN-32)*
  *(through v16 cited from the run, the header not carrying the reading yet — true at
  `nozoki@153f5a1`; this cite and the step's lines on the owner's seat's answers at
  `docs/trail/architecture/cycle-14.md` §§ 3.4, 3.5 — RN-28)*. Not covered, and named so it is not
  read as coverage: a thread sample shows the shell in the panel's modal run, not that the panel
  is on screen — S-1's
  observable half (SDD RN-70) *(traces to: SDD § 4 C-I3 at v22 — "The shell's run is proved on
  the shipped bundle, beside the wall", its observable, its two readings, its re-cut rule and its
  *Violated by*; § 4 C-R3; § 3 `read-only-harness`; § 5 step 4 E-1; § 6 S-1, command half; § 10
  RC-2, RC-3; § SDD Review Notes RN-52, RN-60, RN-61, RN-70; the owner's ruling at
  `docs/trail/sdd/cycle-8.md` § 5.1, answer 4; ADR-0012 — revised at v11 against C-I3 at v13,
  Accepted at v12 on the owner's confirm at `docs/trail/architecture/cycle-9.md` § 2.3, and
  corrected in place at v15 and v17 with this entry; ADR-0011; SRS § 8 AC-10, the manual walk this gate
  precedes; added at v10 — RN-21; the owner's addition confirmed at
  `docs/trail/architecture/cycle-8.md` § 2.1, and the mechanism and the control re-derived at v11
  — RN-22; the observable, the tree's state and the two readings at v15 — RN-26; the header's
  runner reading and the step's lines at v17 — RN-28; the citations, the frame count and the
  second runner reading re-pointed to C-I3 at v22, raised at `docs/trail/architecture/cycle-18.md`
  § 2.1 — RN-32)*
- **QC-26:** Every dependency is deliberate: `Cargo.lock` is committed and CI builds with
  `cargo build --locked`; `nozoki-mac/Package.swift` declares no dependency and no
  `Package.resolved` exists — the view brings nothing to the tree; and a lockfile diff that adds a
  name outside `checks/deps.allow` fails the build until the allowlist change is reviewed as code
  in the same change.
  — *verified by:* `checks/no-network.sh` (the tree) — non-zero on a name outside the allowlist, on
  a Swift dependency declared, or on a `Package.resolved` present; the lockfile diff at
  `development-design` (the change) *(traces to: SDD § 4 C-R6, C-I3; `quality_defaults.md`
  § Dependencies; `languages/rust/toolchain.md` § Adding, pinning and locking a dependency;
  ADR-0019; ADR-0014; ADR-0017; re-derived at v11 — RN-22)*
- **QC-27:** A dependency with a known critical vulnerability blocks the next release, for as
  long as it takes to fix, replace or remove the dependency. **No remediation window exists** —
  none, not undecided: the support posture promises "no commitment to fix, and no commitment that
  a fix ever arrives" (`docs/SRS.md` § 7 C-13, quoting `docs/PRD.md` § Assumptions "Support
  posture"; `docs/fdr.md` PD-22), a fix for an advisory is a fix, and where the SRS states the bar
  it outranks the doctrine floor's window. The floor's cost — an obligation nobody is late against
  — is accepted, and is what the posture already tells adopters. The audit databases are fetched
  by CI, never by the product (QC-32).
  — *verified by:* `cargo audit` exits 0 — it has no
  severity threshold, so it gates on every advisory, stricter than *critical*: a non-critical
  advisory a release carries is ignored by id, `--ignore <RUSTSEC-id>`, the ignore and its reason
  added in the change that adds it and reviewed as code the way `checks/deps.allow` is (QC-26);
  over the tree, as a release gate. The Swift package declares no dependency, so there is nothing
  on that side to audit (SDD § 4 C-R6); `pnpm audit` left with `nozoki-ui` at `nozoki@0aca57e`
  (RN-22; RN-25) *(traces to:
  `quality_defaults.md` § Dependencies; SRS C-7,
  C-13; FDR PD-22; the commands are this document's realization — RN-3; the no-window call and the
  `cargo audit` gate confirmed at `docs/trail/architecture/cycle-1.md` § 1.1, § 2.7 — RN-11)*
- **QC-28:** No secret is in the repository, and the release workflow holds no signing identity.
  — *verified by:* `gitleaks git` exits 0 over the repository — exit 1 on a leak or an error;
  `gh secret list --repo kensaiapp/nozoki` prints no entry; `codesign -dv Nozoki.app` on the
  downloaded bundle reports `Signature=adhoc` *(traces to: `quality_defaults.md` § Secrets; SDD § 4
  C-R4; ADR-0007; the scanner is this document's realization — RN-3; the command confirmed at
  `docs/trail/architecture/cycle-1.md` § 2.7 — RN-11)*
- **QC-29:** Every release's `SHA256SUMS` matches its artifact, and the artifact is built from the
  release's tagged commit by `.github/workflows/release.yml`; a release with no build from its tag
  is not offered.
  — *verified by:* `shasum -a 256 -c SHA256SUMS` passes against a rebuild from the tag (the
  release) *(traces to: SDD § 4 C-R4; § 11 R-7; FDR R-132; ADR-0007)*
- **QC-30:** The boundary set is exactly: the Open-panel grant; the granted folder's content
  (files, entries, `.git`); FSEvents for that folder; the `SM-4` functions the shell calls, `asset_bytes` among
  them; the product's own files in its container; and the environment and argument reads of
  the linked dependency tree, each named in `checks/entry-points.allow`. The set covers what the
  shipped process reads, whichever crate holds the line that reads it — an adopter runs one
  process. It is held in two halves. **(1) The product's own units** — every member of the Cargo
  workspace, whose members are the glob `crates/*` (`Cargo.toml` `members`), so a crate created
  there is a member with no manifest edit (`nozoki-core` and `nozoki-bridge` today), and
  `nozoki-mac` — read no argument vector, no environment variable and no
  configuration file, and open no socket. **(2) The linked dependency tree** — every environment or
  argument read in the crates `cargo tree -p nozoki-bridge --target aarch64-apple-darwin -e normal
  --locked` resolves is a named member of the set: one line in `checks/entry-points.allow` per
  crate and name, each with
  what the read changes. A read not on the list fails the build until the list change is reviewed
  as code in the same change, the way `checks/deps.allow` is (QC-26); whether a given read is
  acceptable is decided at that review, by a person. **What the set does not reach:** reads made
  by the operating system's own frameworks inside the process. They are the platform's, no
  lockfile names them, and the sandbox (QC-25) is what bounds them. Nor a path the repository's own
  config names, which libgit2 follows with no containment check; QC-35 names it as uncovered (SDD
  § 11 R-16). **A C environment read in a linked crate is a read of half (2)** — a `getenv`, or a
  read of the process's environment array through `environ` or `_NSGetEnviron` — and is named on the
  list as a Rust read is *(drafted at v32 — RN-43; confirmed at v33, with the environment array
  added — RN-44)*. At `nozoki@8edec4f`, and unchanged at `nozoki@2f15e2c`, two of the 37 crates the
  command resolves carry `getenv` in C: `libgit2-sys`, in ten files, and `libz-sys`, in one; and one
  of them, `libgit2-sys`, reads `environ`, in one file. The reads a repository open reaches are
  libgit2's `APP_SANDBOX_CONTAINER_ID`,
  `HOME` and `XDG_CONFIG_HOME`, read when the library initialises whatever its search paths
  (`libgit2/src/libgit2/sysdir.c:L347`, `:L357`, `:L402-L405`, `:L458-L459`), and `SUDO_UID`, read
  by an open's ownership check only when the effective user is root
  (`libgit2/src/util/fs_path.c:L2030-L2033`). None of the four opens a file. libgit2's other
  sites sit behind calls the port never makes — an open with `GIT_REPOSITORY_OPEN_FROM_ENV`, which
  the adapter does not pass (`repository.c:L926`, `:L1130`), a remote, a signature, the SSH
  transport, a spawned process — or in `src/cli`, which the build does not compile. `libz-sys`'s
  one site is in its vendored zlib-ng (`src/zlib-ng/arch/arm/arm_features.c:L36`), which this build
  does not compile: `build.rs:L15-L22` builds zlib-ng only under a zlib-ng feature, the lock
  resolves only `libc` for `libz-sys`, and the build links the system `libz`. libgit2's `environ`
  read is in `src/util/unix/process.c`, where macOS defines the name as `(*_NSGetEnviron())`
  (`:L21-L23`), read to build a child's environment (`:L113`, `:L128`). The file is compiled
  (`build.rs:L208`), and `git_process_new`, its entry, is called in `libgit2/src` only from
  `transports/ssh_exec.c`, a remote the port never makes, so the read is dormant in the shipped
  process.
  — *verified by:* half (1) — `checks/structure.sh` (layer 6): no `std::env::args`,
  `std::env::var`, socket or config-file read in any workspace member's sources, the scope § 9's
  `checks/structure.sh` bullet states; `checks/view.sh`
  (layer 6): no `CommandLine.arguments`, `ProcessInfo.processInfo.arguments` or
  `ProcessInfo.processInfo.environment` read in `nozoki-mac/Sources` — three names this document
  adds to C-R7's scan to realize C-R3's *Violated by* (RN-22). Half (2) —
  `checks/entry-points.sh` (layer 6): for every crate the `cargo tree` command above names from
  outside the workspace, a scan of the crate's whole package directory in the Cargo registry — its
  build script excepted — for `env::var`, `env::var_os`, `env::vars`, `env::vars_os`, `env::args`
  and `env::args_os`, diffed against `checks/entry-points.allow`; non-zero on a read not listed, on
  a listed line no longer found, and on any resolved crate whose sources it cannot open — a crate
  it cannot scan is a failure, never a pass. The scan covers the package directory and not `src/`,
  because a crate need not keep its sources there (RN-18). **The workspace's own members** —
  `nozoki-core` and `nozoki-bridge` today, which the command names and which have no registry
  copy — are half (1)'s, whose rule reads every member's sources, and the scan skips them by their
  membership in the workspace, never by a list of names. The two halves split on that one test,
  so no crate falls between them; any other crate whose sources it cannot open still fails. The
  scan also reads each such crate's C and C++ sources for `getenv`, which matches libgit2's
  `git__getenv` too, and for `environ` and `_NSGetEnviron` as whole words, against the same list —
  a rule this document adds to the script (RN-43; the two array names at RN-44). The change that
  adds it also admits the three C names to the list's name field, which accepts only the six Rust
  names today (`checks/entry-points.allow:L10`, `:L16`). Until that change, a C read's gate is review
  of the lockfile diff at `development-design`, reading this entry, and the script's header names a
  C `getenv` among what it does not hold (`checks/entry-points.sh:L66`). **Not covered by the scan,
  and named:** a read is the pair (crate, name) (`checks/entry-points.sh:L55`), so once
  `libgit2-sys | getenv` is listed, a new C `getenv` inside `libgit2-sys` matches the listed pair
  and passes — a new variable after a libgit2 bump, or a site that moves from uncompiled code into
  the compiled set. `libz-sys`'s line behaves the same way if a feature change compiles its
  zlib-ng. No command can tell a new read inside a listed pair from the reads already reviewed, so
  this case is a review gate: the lockfile change reviewed as code (QC-26), with each listed line's
  text re-read against the new sources, as the list's own header requires
  (`checks/entry-points.allow:L20-L21`, `:L23-L26`). Rust reads have the same granularity; the case
  is named for C because `libgit2-sys`'s line covers reads the shipped process makes. **The build script excepted**
  is the file the `build` key of that registry copy's `Cargo.toml` names, at the version the lock
  resolves, and `build.rs` at the package root where the manifest sets no key
  (https://doc.rust-lang.org/cargo/reference/manifest.html, § The `build` field); where the key is
  `false`, or the default file is absent, nothing is excepted. A build script runs before the
  build and is not in the shipped process (§ 9, the `checks/structure.sh` bullet). **Not covered,
  and named:** a build script that pulls other files in through `mod`, `#[path]` or `include!` has
  those files scanned, which fails loud and never passes silently; none of the 17 build scripts
  the lock resolves at `nozoki@85d9fa7` does (RN-34). Review at `development-design` when a change adds
  an entry point — a scanner finds a new read or a new socket, not a new trust assumption *(traces
  to: `quality_defaults.md` § The boundary set; SRS NFR-14, FR-1; FDR R-2; SDD § 4 C-R3 *Violated
  by*, C-R7; ADR-0021; ADR-0017; the two
  halves answered in the owner's seat at `docs/trail/architecture/cycle-5.md` § 3.3; the script,
  the list format and the measurement behind them are this document's — RN-18; the IPC member
  corrected on the owner's addition at `docs/trail/architecture/cycle-9.md` § 2.3 — RN-23; the
  build-script exception on the owner's seat's answer at `docs/trail/architecture/cycle-20.md`
  § 3.2; the workspace skip drafted at v23 — RN-34 — and confirmed, with half (1) widened to every
  workspace member, on the owner's seat's answer at `docs/trail/architecture/cycle-21.md` § 2.1 —
  RN-35; the C `getenv` half drafted at v32 on the item raised at
  `docs/trail/architecture/cycle-29.md` § 2.2 — RN-43 — and confirmed in the owner's seat at
  `docs/trail/architecture/cycle-30.md` § 2.2, with the environment array and the (crate, name)
  limit added — RN-44)*
- **QC-31:** Every value entering from outside is validated at the boundary it enters through
  before it reaches the model: a path by the containment check (QC-6), a decoded file by
  `fs-reader`'s text rule — UTF-8 with or without its byte-order mark, or UTF-16 by its mark;
  nothing detected from content and no third encoding — a Git answer by the port's plain-data
  contract.
  — *verified by:* review at `development-design` against the entry points the change touches —
  no machine check tells a real validation from a truthy test; the path half is QC-6's machine
  check *(traces to: `quality_defaults.md` § Input at the boundary; SRS DR-6, FR-10; SDD § 3
  `fs-reader`; FDR R-46, R-154; ADR-0015, which carries ADR-0006's containment half; the rule's second encoding read at SDD v5 — RN-17)*
- **QC-32:** The set of destinations the product connects to is empty.
  — *verified by:* network monitoring across a full session shows zero outbound traffic
  (`docs/SRS.md` AC-3, the release); `checks/no-network.sh` (the tree); the absent network
  entitlement (QC-25) *(traces to: SRS NFR-7, NFR-8, AC-3; `quality_defaults.md` § The boundary
  set; ADR-0021; ADR-0011)*

## 3. Authentication & access control

- **QC-33:** **Identity — not applicable, with the boundary that makes it true.** No identity
  exists: no account, no user record, no device identifier. Authorization is the operating
  system's — the sandbox grant to the folder the user chose in the Open panel is the whole of the
  product's authority over the folder. This stops being true the day the product gains a hosted
  mode, an account, or any identifier — the hosted mode the FDR places out of scope. A second
  granted folder would still be the operating system's grant and creates no identity, so it
  revokes nothing here.
  — *verified by:* review at `development-specs` when a change adds a hosted mode, an account, or
  any identifier — a declared absence has nothing to run *(traces to: SDD § 4 C-D1; SRS NFR-7;
  FDR PD-14, PD-33, OOS-11; ADR-0011; confirmed with the correction at
  `docs/trail/architecture/cycle-1.md` § 2.3 — RN-9)*

The **privilege** half binds. These are *reach* checks, not import checks (§ 1.2): a unit can
import nothing forbidden and still read a path it was never granted.

- **QC-34:** The shell reaches nothing but the functions QC-24 names: `nozoki-mac` opens no socket,
  reads no file, spawns no process, hands no URL to another program, and loads no web engine —
  every byte a surface shows crossed `SM-4`.
  — *verified by:* `checks/view.sh` (layer 6) — the scan over `nozoki-mac/Sources`, whose list of
  what it refuses is the script's own header: the families F1 – F13 of its scan table
  (`checks/view.sh:L33-L87`), which this entry points at and does not copy, so the list lives in
  one place and the same-change clause below adds to it there. C-R7's set is the scan's floor —
  `WKWebView`, `WebView`, `JSContext`, `NSAttributedString` initialised from HTML or with the
  `.html` document type, `URLSession`, `NSURLConnection`, `Process`, `NSWorkspace.open`,
  `NSSharingService`, `FileManager` reads, `Data(contentsOf:)`, `String(contentsOf:)`, `dlopen`,
  and `Bundle.main` reads outside `Contents/Resources` — and the script may refuse more, never
  less; its header states the relation from its side ("this header is the list, and C-R7's set is
  its floor", `:L87`). And `otool -L` on the built executable. The scan is the check and C-R7's
  first sentence is the rule: a shell that reads a file, opens a connection or spawns a process by
  an API the scan does not name is a violation, caught at `development-design` and added to the
  header in the same change. QC-1's and QC-23's pointers at the scan follow this tail and carry
  no list of their own; `checks/no-network.sh` *(traces to: SDD § 4 C-R7 — the forbidden set and
  its *Violated by*; § 3 SM-4; ADR-0021; `quality_defaults.md` § Capability; re-derived at v11 —
  RN-22; the header as the list and C-R7's set as the floor at v15, on the owner's seat's answer
  at `docs/trail/architecture/cycle-12.md` § 3.4 — RN-26)*
- **QC-35:** The product reads nothing outside the granted folder and its own container, and
  writes nothing outside the container. libgit2's four machine-level config levels, which a
  repository open would otherwise read outside both, are switched off before the adapter is wired
  (QC-17). **Not covered, and named so none is read as coverage:** (1) a path the repository's own
  config names — `include.path`, `core.excludesfile`, `core.attributesfile` — which libgit2 follows
  with no containment check (QC-6; SDD § 11 R-16), its closing being SDD *Open Questions*'
  config-named-path item, settled in `see-git-status` before the slice is reached, with no build
  inside the slice bounding it *(through v39 this bound read "no later than the build in which
  `mac-shell` first calls `nozoki_read_git`" — RN-51)*; (2) `nozoki-core`'s in-process Git suites
  and the read-only walk, which call libgit2 without the bridge and so with the machine-level
  reads on — the walk calls `read_git` with the libgit2 adapter and no switch
  (`checks/walk.rs:L292`) — so `checks/read-only.sh`'s
  `unchanged` on a Git fixture is shown for libgit2 as the harness configures it, and no check runs
  the hash with the reads off; isolating them is the CTO's call, raised by the first measured
  difference between the two configurations; (3) libgit2's environment reads at init, which open no file and are
  QC-30's. Whether a repository open survives the sandbox's refusal of a read outside the grant has
  not been run (SDD *Open Questions*, second item).
  — *verified by:* `checks/own-state.sh` and `checks/read-only.sh` (layer 5), which observe writes
  — the changed files under `$HOME`, and the fixture's hashes — and neither observes a read;
  QC-17's bridge test, which proves the four search paths empty and observes no read; and the
  sandbox grant (QC-25), which in the bundle bounds every read the switch does not stop. No command
  observes a read outside the grant: the reads half rests on the wall and on the switch's
  configuration, not on an observation, and this tail says so *(traces to: FDR R-101, R-102; SDD
  § 3 `core-bridge` and `git-reader` at v27; § 4 C-D1, C-D2, C-D3, C-I3 at v27; § 11 R-16;
  § *Open Questions*, second and config-named-path items; ADR-0011; ADR-0020; re-derived against
  SDD v27, with the tail's observes-no-read sentence, at v32 — RN-43; (2)'s walk from SDD § 4 C-I3
  as it reads at v31 (SDD RN-91) — RN-49; (1)'s bound from SDD § 11 R-16 at v31 (SDD RN-91) —
  RN-49, and re-derived from § 11 R-16 and *Open Questions*' config-named-path item as they read
  at v32 (SDD RN-92) — RN-51)*
- **QC-36:** No unit spawns a process: no `std::process` in any shipped crate, and no `Process`
  in `nozoki-mac/Sources`.
  — *verified by:* `checks/structure.sh` (layer 6); `checks/view.sh` (layer 6) *(traces to: SDD
  § 3 `git-reader` "Must not own", `mac-shell` "Must not own"; § 4 C-R7; ADR-0019; ADR-0021; re-derived at v11 — RN-22)*
- **QC-37:** `asset_bytes` returns bytes read-only, only for a path the containment check passes
  and only for the four bitmap formats `docs/SDD.md` § 4 C-D3 names — PNG, JPEG, GIF and WebP —
  and refuses any other request; the shell decodes an image from bytes `asset_bytes` returned and
  from nothing else, with the platform's own decoder. An in-folder SVG is not returned and takes the
  placeholder stating that its format is one the tool does not render; SVG reaches the decoder only
  after C-D3's format list moves on the evidence SDD RN-8 names, never by an `asset_bytes` edit
  alone.
  — *verified by:* `cargo test --locked -p nozoki-bridge --test asset_bytes` — `asset_bytes` returns the
  in-folder PNG's bytes for its path and a refusal for the in-folder SVG and for each escaping
  path, on a second call with the same inputs (layer 2); `swift test --package-path nozoki-mac` — a
  *resolved* image node is drawn from the bytes `asset_bytes` returned and a placeholder node from
  no bytes at all (layer 4) *(traces to: SDD § 3 `core-bridge`, SM-7; § 4 C-D3; § 6 S-3, command
  half; § SDD Review Notes RN-8; ADR-0015;
  the format clause added at v5 on the re-authored SDD — RN-16; re-derived at v11 — RN-22; the
  command follows S-3 at v14 — RN-23)*

## 4. Privacy, data retention & compliance

- **QC-38:** The product holds no personal data. Own-state holds the theme, the window frame, and
  — once the selector exists — remembered folders as security-scoped bookmarks with display names
  and which was viewed last; nothing else, and never folder content.
  — *verified by:* `checks/own-state.sh` — inspection of the container after a session finds
  those fields and no content of the fixture (layer 5); review at `development-specs` when a change
  adds an own-state field *(traces to: SRS DR-5, AC-13; SDD § 4 C-D4; FDR R-108, R-109;
  `quality_defaults.md` § Data)*
- **QC-39:** The diagnostic log holds one line per `failed` or `stopped` item naming the part, the
  operation and the error text — never file content, never a path outside the folder's own
  entries, never transmitted.
  — *verified by:* unit test on the log writer's line shape (layer 1); `checks/own-state.sh` —
  the log lies under the container (layer 5) *(traces to: SDD § 4 C-I2; SRS NFR-11; FDR R-93)*
- **QC-40:** Retention. Own-state: a deliberate choice — the theme, the window state, which folder
  is viewed — persists until the user changes it by the control that made it; the remembered-folders
  list holds the ten folders most recently viewed, an entry persists until an eleventh ages it out,
  no control removes an entry or clears the list, and an aged-out entry is not restored. The
  diagnostic log holds at most the current session's lines: a launch creates the file where none
  exists and truncates it where one does; within a session it is bounded to 1 MiB on disk, past
  which it is emptied and writing continues; a failed write surfaces nowhere, stops no item and is
  not retried.
  — *verified by:* unit tests (layer 1) — the log writer truncates at launch and empties at the
  cap (`cargo test --locked -p nozoki-bridge`), and the remembered list evicts the oldest entry on the eleventh
  and exposes no removal (`cargo test --locked -p nozoki-core`); `checks/own-state.sh` after
  `checks/churn.sh` — the log under the container is no larger than 1 MiB, and a line written
  before a relaunch is absent after it (layer 5; `docs/SRS.md` AC-13's inspection, machine-run)
  *(traces to: SRS NFR-11, AC-13; FDR R-110, R-178, R-180, R-182; SDD § 4 C-I2; § 3 `own-state`;
  the bound raised from this document and folded at SRS v9 — `docs/trail/architecture/cycle-1.md`
  § 1.2, RN-11; the remembered-folder clause brought to FDR v3 — RN-12)*
- **QC-41:** Every release carries `LICENSE` (MIT) and a `THIRD_PARTY_NOTICES.md` listing every
  crate and package the bundle ships with its licence.
  — *verified by:* `checks/notices.sh` — the names in `cargo tree` each appear in the notices
  file, non-zero on a miss; the Swift package declares no dependency to notice (SDD § 4 C-R6, § 6
  S-7) (the release) *(traces to: SRS C-4, C-5, AC-14;
  FDR R-141; the script is this document's realization — RN-3)*
- **QC-42:** Before the first public release, private vulnerability reporting is enabled on
  `github.com/kensaiapp/nozoki` and `SECURITY.md` exists, promising nothing beyond
  *"Security reports have a private channel and are read, with no acknowledgement or response
  time promised"* (`docs/PRD.md` § Assumptions, "Support posture").
  — *verified by:* `gh api repos/kensaiapp/nozoki/private-vulnerability-reporting` returns
  `"enabled": true`; `SECURITY.md` present; release inspection reads its wording (the release)
  *(traces to: SRS C-7, AC-14; FDR R-143, PD-22)*
- **QC-43:** The product's position outside the EU Cyber Resilience Act rests on its free,
  non-monetized, non-commercial character; every release re-affirms that character before it is
  offered.
  — *verified by:* release inspection — a review gate: no command reads commercial character, and
  a change to it is the CPO's call, not a defect a script finds *(traces to: SRS C-10; FDR PD-34;
  PRD § Assumptions "Regulatory posture")*
- **QC-44:** Every standing sentence the product states — the read-only promise, the network
  statement, the pre-1.0.0 statement, the support posture, the archiving sentence, the
  accessibility posture — appears on its surfaces verbatim in the one wording
  `docs/CONTENT.md` § Standing sentences fixes, and the README's first screen carries the four
  items `docs/SRS.md` C-9 names.
  — *verified by:* `checks/readme.sh` — `grep -F` of each standing sentence's exact wording against
  `README.md`, `SECURITY.md` and the release notes, non-zero on a miss (the release); release
  inspection for the four items (`docs/SRS.md` AC-14) *(traces to: SRS C-9, C-13, AC-14; FDR
  R-135 – R-139, R-142; the script is this document's realization — RN-3)*

## 5. Performance & capacity

The SRS states the bars and deliberately leaves every number unset until a build exists to measure
(`docs/SRS.md` § 4.1 NFR-1, NFR-2; § 4.4 NFR-10; § SRS Review Notes RN-4). This section therefore
binds the *process*, and asserts no number of its own.

- **QC-45:** A performance number is measured, never asserted: no threshold for file-switch
  latency, refresh latency or a reference folder size is written into any change's bar until the
  SRS carries it by revision.
  — *verified by:* review at `development-design` — a review gate, because no number exists to
  assert against; the entry becomes a layer-5 timing assertion the day the SRS folds the numbers
  in *(traces to: SDD § 4 C-I4; SRS NFR-1, NFR-2, NFR-10, RN-4; FDR PD-30)*
- **QC-46:** `checks/latency.sh` prints file-switch and refresh p95 in milliseconds over the
  reference fixtures `checks/fixtures/scale-small`, `scale-medium` and `scale-large`, on every CI
  build.
  — *verified by:* the script exits 0 and prints three figures per metric (layer 5) *(traces to:
  SDD § 4 C-I4; § 11 R-5; ADR-0010)*

## 6. Availability & reliability

- **QC-47:** A failure to read one file, one tree entry or one part of Git state degrades only
  that item, and the next successful read of the same item replaces it without ceremony.
  — *verified by:* `cargo test --locked -p nozoki-core --test watch` — an unreadable fixture entry yields
  `failed` on that item and the failure changes no other item: each sibling holds the state its
  own read gave it, `observed`, `pending`, `failed` or `stopped` (layer 2); `swift test --package-path
  nozoki-mac` (layer 4): the failure slot renders and the rest of the surface stands. What a failed
  re-read of a folder already expanded does to the entries listed under it is not held here: those
  entries are not the folder's siblings, and SDD § 4 C-I1 leaves the form to S-5's design (SDD
  *Open Questions*, the failed-re-read item), so this entry gains a clause when C-I1 states it
  *(traces to: SRS NFR-3; SDD § 4 C-I1, C-E3; § 6 S-5 *Reached when*, command half — the sibling
  clause as both read at SDD v29, RN-89, in place of "`observed` on its siblings" — RN-47;
  FDR R-83, R-85)*
- **QC-48:** Under scripted concurrent change — create, modify and delete including the displayed
  file, with Git operations mid-flight, and `git init` at a plain root then its removal — the host
  does not panic, the model's final snapshot equals a fresh open of the fixture, expansion,
  selection and reading position survive, and the fixture is byte-identical to the script's own
  final state.
  — *verified by:* `cargo test --locked -p nozoki-core --test watch` running `checks/churn.sh <fixture> 30`;
  `checks/read-only.sh` against the churn's final state as baseline (layer 3) *(traces to: SRS
  FR-16, NFR-3, NFR-4, AC-8; SDD § 6 S-5; ADR-0010)*
- **QC-49:** The read-only and no-network promises hold through abnormal exit: the host killed
  mid-churn leaves the fixture unchanged and `.git` byte-identical.
  — *verified by:* `checks/read-only.sh --kill` — the harness sends SIGKILL to the host during
  `checks/churn.sh` and re-hashes (layer 5); the sandbox (QC-25) is what makes the property hold
  by construction *(traces to: SRS NFR-4, NFR-9; ADR-0011; ADR-0010; the `--kill` mode is this
  document's addition — RN-4)*
- **QC-50:** The Git port's contract tests are written against the port, not the adapter, so the
  installed-`git` substitute is proved by the same tests when it is built.
  — *verified by:* review at `development-design` when a change touches the port — one adapter
  exists, so "the same tests pass twice" cannot run until the second does; the tests' location is
  the port's, and a test importing the adapter directly fails the review *(traces to: SDD § 3
  seam 2; § 11 R-1; ADR-0019; QC-18)*

## 7. Observability & monitoring

- **QC-51:** A failure the user must know about is visible in the product's own window, in the
  failure slot of the item that stopped, with an enabled route out on the same surface; no
  modal, toast, dialog or terminal line carries a failure.
  — *verified by:* `swift test --package-path nozoki-mac` (layer 4): a `failed` and a `stopped`
  projection each render in the item's slot with the route present; `checks/view.sh` — no
  `NSAlert`, no user-notification API and no modal presentation in `nozoki-mac/Sources` other than
  the Open panel's own presentation, which C-R3 requires: exactly one `.runModal()` with no
  argument, in `nozoki-mac/Sources/Shell/OpenFolderPanel.swift` (`:L14`); a second one there, one
  with an argument, or one in any other file is reported (`checks/view.sh:L80-L86`, F13) — the
  bound is stated as the scan holds it, so a sheet, a second panel or a modal elsewhere under
  `Shell/` is not read as admitted (layer 6; the symbols the script names are this document's
  realization of `surfaces`' "Must not own" — RN-22 — and that realization carries the C-R3
  exception from v15, on the owner's seat's answer at `docs/trail/architecture/cycle-12.md` § 3.3
  — RN-26) *(traces to: SRS NFR-11; SDD § 3 `surfaces` "Must not own"; § 4 C-R3, C-E3, C-I1; FDR
  R-86, R-87, R-90, R-91)*
- **QC-52:** The diagnostic log is written to
  `~/Library/Containers/com.kensaiapp.nozoki/Data/Library/Logs/nozoki.log` and nowhere else, one
  line per `failed` or `stopped` item; it is the product's only diagnostic output.
  — *verified by:* `checks/own-state.sh` (layer 5); unit test on the writer's path and line shape
  (layer 1) *(traces to: SDD § 4 C-I2; SRS NFR-11; FDR PD-32)*
- **QC-61:** The logging facade is `log`, and its implementation is the product's own. Every
  shipped Rust crate depends on the `log` facade for diagnostics and on nothing else — no
  `tracing`, no `slog`, no second facade; `nozoki-core` uses the five macros and initializes
  nothing. The implementation is `nozoki-bridge`'s own log writer — the writer QC-39, QC-40 and
  QC-52 already bind — implementing `log::Log`, installed once at startup in `nozoki-bridge`, the
  Rust-side composition root (QC-17), with no third-party implementation crate; the level it admits is fixed
  in code and read from nothing outside the binary, and it holds what QC-39 and QC-52 describe and
  nothing below it. The implementation is the product's own because of a constraint already here,
  not taste: the stock implementations read their level from the environment — `env_logger` is "a
  simple logger that can be configured via environment variables", `RUST_LOG` controlling the
  filter (https://docs.rs/env_logger/latest/env_logger/) — and an off-the-shelf logger is a
  dependency, so its read of the environment is one QC-30's second half holds by name: it fails
  `checks/entry-points.sh` the day it lands, as it fails the allowlist diff below, and a level read
  from outside the binary is what this entry forbids (re-pointed at v7 — RN-18). Which macro a `failed` and a `stopped` item are emitted at is the delivery tier's
  placement under the packet's ladder, not this entry's.
  — *verified by:* `checks/no-network.sh` — `checks/deps.allow` names `log` and names no
  `tracing*`, `env_logger`, `slog*` or `log4rs` crate, so a swap fails the allowlist diff (QC-3,
  QC-26; the tree); `checks/structure.sh` (layer 6) — `log::set_logger` and
  `log::set_boxed_logger` appear only under `crates/nozoki-bridge/src/`; test targets under
  `crates/*/tests/` are outside this rule, as they are outside every rule of that script but one
  (§ 9) — Cargo compiles each file there as a separate crate, so a logger installed there is never
  in the process an adopter runs *(traces to:
  `languages/rust/errors_logging.md` v1.1.0 § Logging, § Which facade — the packet requires the
  binary to select an implementation and this document to record the facade, and fixes no default;
  SDD § 4 C-I2; SRS NFR-11; FDR PD-32; QC-17, QC-30, QC-39, QC-52, QC-58; ADR-0020 § Decision;
  answered in the owner's seat at `docs/trail/architecture/cycle-2.md` § 1.1 — RN-15; the check's
  scope answered in the owner's seat at `docs/trail/architecture/cycle-6.md` § 3.2 — RN-19)*
- **QC-53:** No internal text reaches any surface: no stack trace, no error code, no library name,
  and none of the words `docs/CONTENT.md` § Terminology bans; every message the product shows is a
  whole sentence from its catalogue.
  — *verified by:* `checks/strings.sh` — a lint over `surfaces`' message catalogue in `nozoki-mac` for the
  banned list, non-zero on a hit (the tree); layer-5 error-path tests that a `stopped` item's
  surface text is a catalogue sentence *(traces to: SDD § 4 C-E4, C-I2; FDR R-89; CONTENT
  § Terminology "Banned", § Localization; `quality_defaults.md` § Failure visibility; the lint is
  this document's realization — RN-3)*
- **QC-54:** **Non-repudiation and accountability — not applicable, with the reason.** The
  product performs no action on the user's data and knows no user; there is no action to
  attribute and no one to attribute it to. This stops being true the day a write path or an
  identity enters, both permanently out of scope.
  — *verified by:* review at `development-specs` when a change adds either *(traces to: FDR PD-1,
  PD-33, OOS-1, OOS-2; SDD § 4 C-D1)*

## 8. Operational constraints

The execution context — execution type, test command, parallelism — is the project card's
(`system/projects/nozoki/project.md` in the managing instance), not restated here. That card's
test command is `cargo test --workspace --locked && swift test --package-path nozoki-mac` — the
SDD's command bar for the Rust workspace, `cargo test --workspace --locked` exits 0
(`docs/SDD.md` § 6 S-1), the bar carrying the Rust packet's `--locked` itself since the SDD's
re-author (`languages/rust/testing.md` § Layers 1–5; RN-16), and `swift test` for `nozoki-mac`,
the command the SDD's bars name (§ 6 S-1) — and its `Languages:` line names Rust, Swift and Shell
(RN-6). The move the SDD named as owed at v13 (RN-60) is made: § 8 states the card as it reads at
`kensaiapp-opensource@ec80077` — two moves past the `defe740` v12 read, `5b27023` (Swift in place
of TypeScript on the `Languages:` line, in the test command and on `Language roots:`) and
`ec80077` (the `Languages:` comment naming Swift's packet), neither this document's to edit
(RN-24) — and goes false at the card's next move until RN-6 is extended (RN-22). Why the
workspace form is this product's change-time run, where the Rust packet classifies it as
release-time, is RN-7. What follows exceeds the card.

- **QC-55:** The product is one macOS application bundle, `Nozoki.app`, bundle identifier
  `com.kensaiapp.nozoki`, and one process; no second binary, no second process the product starts,
  no prerequisite, no runtime install, no fetched asset, and no font shipped — the fonts are the
  platform's.
  — *verified by:* `checks/bundle.sh` — one executable under `Contents/MacOS`, the fourteen icons
  under `Contents/Resources`, and no second executable and no font anywhere under `Contents/`
  (layer 5) *(traces to: SDD § 4 C-R1 as it reads at v13; § 3 "Two libraries, one executable, one
  bundle"; SRS C-3; FDR R-131, PD-15, PD-28; ADR-0014; re-derived at v11 — RN-22)*
- **QC-56:** The minimum macOS version is 14 (Sonoma): the bundle's `LSMinimumSystemVersion` is
  `14.0`, and the floor is stated wherever the install path is offered.
  — *verified by:* `/usr/libexec/PlistBuddy -c 'Print :LSMinimumSystemVersion'
  Nozoki.app/Contents/Info.plist` prints `14.0` (the release); release inspection reads the README
  and the release page (`docs/SRS.md` AC-14) *(traces to: SDD § 4 C-R5; § 9 TO-8; SRS C-11; FDR
  R-133, PD-18; ADR-0007)*
- **QC-57:** There is exactly one install path — download the `.dmg`, drag to Applications, the
  Privacy & Security step — named as the exact click path on the README's first screen, and no
  terminal command is ever the documented route; no cask, no second channel.
  — *verified by:* release inspection (`docs/SRS.md` AC-10, AC-14) — a review gate: the walk is a
  stranger's path and is deliberately not automated *(traces to: SDD § 4 C-R4; SRS C-3, C-9; FDR
  R-128 – R-130; ADR-0007)*
- **QC-58:** The product offers no configuration surface: its own units — every workspace member (QC-30 half (1)) and
  `nozoki-mac` — read no configuration file, no environment variable and no argument, and the only
  input the product requires is the folder chosen in the Open panel. What the linked dependency tree reads from the environment or
  the argument vector is not a surface the product offers: it is the named list QC-30's second
  half holds, and no read enters that list unreviewed.
  — *verified by:* `checks/structure.sh`, `checks/view.sh` and `checks/entry-points.sh`
  (layer 6), the same rules as QC-30; `docs/SRS.md` AC-9 at release *(traces to: SRS NFR-14, FR-1,
  AC-9; FDR R-2; SDD § 4 C-R3; ADR-0011; the two halves follow QC-30 — `docs/trail/architecture/cycle-5.md` § 3.3, RN-18; the units
  set widened with QC-30's half (1) — RN-35)*
- **QC-59:** From the first 1.0.0 release the public contract semantic versioning binds is:
  every rule and product decision in `docs/fdr.md` as observable behaviour; the install path
  (QC-57); the readability of an earlier version's own-state (QC-60); and the macOS floor
  (QC-56). A *breaking* change to any of these — a behaviour the FDR states that no longer holds,
  an install path or a floor that an adopter on the old one loses, a prerequisite added to the
  install path (the move `docs/fdr.md` PD-40 prices; QC-55 forbids it while SDD § 4 C-R1 stands,
  so it arrives only with a C-R1 change and a major version together), an own-state a later
  version can no longer read — is a major version after 1.0.0; an added behaviour that leaves every stated
  rule holding — a seventh highlighted language, a new read surface, a lowered floor — is a minor
  version. `docs/SRS.md` C-6's "the product's public contract" points here; the definition is a
  constraint — a change could ship breaking as minor silently, and a check names it — so it lives
  in this document and no SRS revision carries it. `docs/fdr.md` PD-40 states the same set at its
  own altitude, as a product decision, and the two agree on all four members; where they ever
  differ, PD-40 is upstream and this entry is re-derived.
  — *verified by:* from `v1.0.0`, `checks/contract.sh <tag>` against the pin
  `checks/contract/<major>` — written once at the major's `.0.0` release from the built bundle and
  read as `git show v<major>.0.0:checks/contract/<major>`, holding the macOS floor as
  `LSMinimumSystemVersion` prints it, the release's asset names, and `SM-4`'s function list and
  `nozoki_free`, the set as the bridge exports it (C-I6 at v16) — fails on a tag inside a major
  whose bundle raises the floor, drops an asset
  or drops a function (the release; layer 5): the machine check for the install path, the floor and the
  surfaces' presence; own-state readability is QC-60's check. The behaviour member has no machine
  check — no test reads the FDR — and stays a review gate: review at `development-specs` — a change
  spec names which of the four it touches and whether the change is breaking or additive, and the
  version bump follows; release inspection reads the version against the change set
  (`docs/SRS.md` AC-14). Before `v1.0.0` there is no pin and the script is not run — C-6's
  pre-1.0.0 half, stated rather than tested *(traces to: SRS C-6; FDR R-142, PD-20, PD-40 — the
  FDR's statement of the priced set since its v4, the prerequisite clause an owner answer at
  `docs/trail/fdr/cycle-3.md` § 2.6, folded here at v6 — RN-17; SDD § 4 C-I6 as it reads at v16 — the pin reads the bridge's exports, `nozoki_free` among them (RN-22, RN-24), § 11 R-12 — the
  check added at v5, RN-16; confirmed with the breaking/additive split at
  `docs/trail/architecture/cycle-1.md` § 2.1 — RN-5, RN-11; the own-state member confirmed against
  SDD § 6 S-11 at `docs/trail/architecture/cycle-4.md` § 1.1 — RN-17)*
- **QC-60:** Own-state is read whole or discarded whole, and the rule is symmetric: a version
  that meets own-state it cannot read — written by an earlier version or a later one — discards it
  whole and opens as on first run, never reads it in part, never treats it as a startup failure,
  says nothing about it in the window, and in neither case touches the viewed folder; two instances
  of different versions sharing one own-state each read or discard whole at their own launch.
  Before 1.0.0 a discard is inside the anything-may-change statement where the release is offered;
  after 1.0.0 a discard is a breaking change under QC-59.
  — *verified by:* `checks/own-state.sh --from <previous-tag>` — a container written by the
  previous release is opened by the current build without a write outside the container, and a
  container the build cannot read leaves it at first-run state with no failure surface (layer 5);
  unit test on own-state's reader (layer 1): an unreadable fixture yields the first-run state,
  never a partial one *(traces to: FDR R-168 – R-170, PD-39; SRS DR-5, C-6, FR-3; FDR R-108,
  R-109; the rule raised from this document, answered on the FDR's companion and folded at FDR v2
  — `docs/trail/architecture/cycle-1.md` § 2.2, RN-5, RN-11)*

## 9. Test strategy

The layer set is **not defined here** — it is `testing_doctrine.md` v2.2.0, and this table is one
project's realization of it. Tooling for the core and the bridge comes from the Rust packet
(`languages/rust/testing.md` v1.0.1), and for `nozoki-mac` from the Swift packet
(`languages/swift/testing.md` v1.1.0), in the organisation's language registry since
`kensaiapp-dev@3ab2e8553` (2026-09-23) — each resolving at step 1 of `languages/README.md` § The
resolution chain from the card's `Languages:` line (RN-6). Through v12 this paragraph read that no
Swift packet existed and that `nozoki-mac`'s tooling was this product's own to record; true when
written, and history (RN-24). The packet's runner is `swift test --package-path nozoki-mac`, the
command the SDD's bars name (`docs/SDD.md` § 6 S-1, S-2, S-3, S-8), over `nozoki-mac/Tests/`. What
this table fixes differently from the Rust packet, and why, is RN-7; where `nozoki-mac` stands
against the Swift packet — followed, adopted, or departed from, one by one, and the toolchain CI
builds it with — is the bullet below, and the reasons are RN-24. If
this table and the doctrine disagree on the layers, this table is the copy and is wrong. Through
v10 the renderer's tooling was the TypeScript packet's — Vitest, and Playwright at layer 4 — and it
left with `nozoki-ui` at `nozoki@0aca57e` (RN-22; RN-25).

| Level | Scope | Tool | Where it lives |
|---|---|---|---|
| 1 — Unit | The reducer, `ItemState` transitions, the containment check, the text rule, extension recognition, the log line shape; on the Swift side, a projection decoded from an `SM-4` buffer | `cargo test --locked` (`#[cfg(test)]` beside the module); `swift test --package-path nozoki-mac` | inside each `nozoki-core` / `nozoki-bridge` module; `nozoki-mac/Tests/` |
| 2 — Integration | `fs-reader` and `git-reader` against real fixture folders and repositories; the Markdown pipeline against `hostile.md`; `highlighter` against one fixture per floor language; the bridge's export set against its generated header; `asset_bytes` against the containment check; the bridge under the address sanitizer | `cargo test --locked -p nozoki-core --test git_state`, `--test root_finding`, `--test markdown`, `--test highlight`, `--test watch`; `cargo test --locked -p nozoki-bridge --test exports`, `--test asset_bytes` | `crates/nozoki-core/tests/`, `crates/nozoki-bridge/tests/`, over `checks/fixtures/` |
| 3 — Application | `SM-4`'s function list driven in-process through `SM-5`, bypassing the shell; the whole-model switch | `checks/read-only.sh`; `cargo test --locked -p nozoki-core --test switch` | `checks/`, `crates/nozoki-core/tests/` |
| 4 — UI | A view is drawn from a projection and from nothing else — read with the one exception `docs/SDD.md` § 3's `surfaces` row names, that an intent the surface raised has not been answered yet, under that row's four bounds; the gap is no `ItemState`, and the reading adds no test (`docs/SDD.md` RN-82, v24; RN-37) — and the shell issues no call `SM-4` does not name: nothing drawn from `pending` but the entry's name, its glyph and CONTENT's *Loading* sentence, no marker before `observed`, the Git view empty on `plain`, the failure slot and its route, the text view `isEditable` false and registering no drop type, a *resolved* image drawn from `asset_bytes`' bytes and a placeholder from none, staged told from unstaged by text, both themes | `swift test --package-path nozoki-mac` — the tests on `main` XCTest, which the Swift packet keeps; a new test Swift Testing (the bullet below) | `nozoki-mac/Tests/` |
| 5 — End-to-end | The built bundle: entitlements and sandbox, the shell's run under them, own-state after a session, churn and kill, latency figures; from `v1.0.0` the priced contract against its major's pin; the timed release walk | `checks/bundle.sh`, `checks/renderer.sh` with `checks/fixtures/idle-shell`, `checks/own-state.sh`, `checks/churn.sh`, `checks/latency.sh`, `checks/read-only.sh --kill`, `checks/contract.sh <tag>`; `docs/SRS.md` AC-10 as a manual timed walk | `checks/` |
| 6 — Architecture | § 1.2's graph, § 1.3's I/O ownership, § 3's reach rules, the linked tree's environment and argument reads against their reviewed list (QC-30), the shell's forbidden set and link list (QC-34), and this section's layer-5 placement (no `CARGO_BIN_EXE_` reference under `crates/*/tests/`) | `checks/structure.sh` (Rust, grep rules over shipped sources — its scope is the bullet below); `checks/entry-points.sh` (the resolved dependency tree); `checks/view.sh` (Swift: the source scan over `nozoki-mac/Sources` and `otool -L` on the built executable) | `checks/` |
| 7 — Specification | The SRS's acceptance criteria as scenarios through the real entry point | the SDD's per-slice command bars and the AC walk at release, until a QA seat writes the layer | `checks/` |

- **Layer 3 is present**, realized as the harness: it enters inside the boundary by calling
  `SM-4`'s list in-process through `SM-5`, which is `testing_doctrine.md`'s own test for layer 3
  versus layer 5.
- **Layer 4 is present** — the product has a UI and gets no exemption. It runs on `swift test`,
  which hands a view a projection and asserts on what is drawn, never on a driven session: the
  AppKit views are not driven from outside the process (`docs/SDD.md` § 4 C-I3; § 9 TO-7), which
  is why layer 4 proves *rendering given state* and layer 5 proves the bundle (RN-7). TextKit's
  layout of UX-I12's two hard cells is walked by hand on every macOS the floor admits before each
  release (`docs/SDD.md` § 11 R-11), not asserted here.
- **Layer 5 stays outside `cargo test`**, against the Rust packet's shape (`tests/<flow>.rs` in
  the binary crate): no crate of this product is a binary crate — the executable is
  `nozoki-mac`'s — the `--test` files `nozoki-bridge` carries are `exports` and `asset_bytes` (layer 2), and no
  file under `crates/*/tests/` starts the built bundle — no `CARGO_BIN_EXE_` reference there, a
  `checks/structure.sh` rule (layer 6, row 6). That placement is what makes
  `cargo test --workspace --locked` this product's change-time run (RN-7). The built bundle is
  exercised by the harness scripts and the shell gate, and the rendered UI by the timed manual
  walk, deliberately not automated (`docs/SRS.md` AC-10).
- **`checks/structure.sh` reads shipped sources, and says so once, here.** Its rules read the
  product crates' sources outside `crates/*/tests/` and outside each crate's `build.rs`. Every
  property the script holds is about the process an adopter runs; Cargo compiles each file under
  `tests/` "as a separate crate" (https://doc.rust-lang.org/cargo/reference/cargo-targets.html,
  read 2026-09-19), so a test target is never in that process, and "just before a package is built,
  Cargo will compile a build script into an executable" and run it
  (https://doc.rust-lang.org/cargo/reference/build-scripts.html, read 2026-09-23), so a build
  script is never in it either — the ground QC-30's second half already takes for a dependency's
  build script. The tree holds one: `crates/nozoki-bridge/build.rs` reads and writes the
  generated header with `std::fs` (`:L11`, `:L25`, `:L28-L30`) and reads `CARGO_MANIFEST_DIR`
  through `std::env::var` (`:L18`), and the exclusion covers every rule of the script — QC-13's
  `std::fs` rule and QC-30's and QC-58's first half alike (RN-24). The scope binds each rule that names a crate — QC-2's *no
  write API in `nozoki-core` outside `own-state`*, QC-7's and QC-9's *no `std::process`*, QC-9's
  *no `unsafe` outside `nozoki-bridge`*, QC-13's *no `std::fs` in `nozoki-bridge` outside its log
  writer*, QC-30's and QC-58's first half, QC-61's `set_logger` rule, and every other rule of the
  script alike — and a test target may do what those rules forbid shipped code: build a fixture,
  read a config file, take an argument, install a capturing logger. **One rule reads exactly that
  path on purpose and is unchanged:** no `CARGO_BIN_EXE_` reference under `crates/*/tests/` (the
  layer-5 bullet above). **A module is judged by the file that holds its body**, so the scope is
  by file path: a declaring file under `src/` is read like any file there, and a body loaded
  through `#[path]` from a file under `crates/*/tests/` is outside every rule, as that file is. A
  `#[cfg(test)]` module whose body is written inside a file under `src/` stays inside every rule —
  `checks/tests/test_structure.sh`'s `test_inline_test_module_is_scanned` holds that case, and it
  fails closed. The ground is this bullet's own: a `#[cfg(test)]` item is compiled only "when
  compiling the test harness" (https://doc.rust-lang.org/reference/conditional-compilation.html,
  re-read 2026-10-03), so its body never enters the process an adopter runs, and it is out for the
  reason `tests/` is out. The tree holds three such sites at `nozoki@456098c`, and
  `grep -rn '#\[path' crates/*/src` prints exactly those three. Two are
  `#[path = "../tests/common/mod.rs"]` on a `#[cfg(test)]` `mod test_support`, at
  `crates/nozoki-core/src/lib.rs:L18-L24` and `crates/nozoki-bridge/src/lib.rs:L10-L16`; both of
  those bodies import `std::fs` and `std::process` (`crates/nozoki-core/tests/common/mod.rs:L8`,
  `:L11`; `crates/nozoki-bridge/tests/common/mod.rs:L8`, `:L13`). The third is
  `#[path = "../tests/unit/fs_reader.rs"]` on `fs_reader`'s `#[cfg(test)]` `mod tests`, at
  `crates/nozoki-core/src/fs_reader.rs:L894-L896`. Its body imports no `std::process`, and its
  fixture writes (`crates/nozoki-core/tests/unit/fs_reader.rs:L753`, `:L953`) sit in `fs-reader`,
  a filesystem owner QC-15 exempts. A reading by module would fail the tree as built: with each
  body placed where such a reading judges it, `checks/structure.sh` v1.3.0 at `nozoki@456098c`
  raises QC-2, QC-9, QC-15 and QC-36 in `nozoki-core` and QC-15 and QC-36 in `nozoki-bridge` —
  the overreach RN-19 removed when it scoped QC-61. The count, the lines and the findings are
  dated and pinned: a fourth site, or a rule the script gains, is a re-measurement of this
  sentence and not a contradiction of it *(through v30 this sentence counted two sites and named
  QC-36 and QC-15 alone. The third site arrived at `nozoki@04ad072` and the script's QC-2 rule at
  `nozoki@e7f151e`, both merged at `nozoki@73c408e`; QC-9's process clause has been in the script
  since its v1.0.0 (`checks/structure.sh:L5`), so QC-9 was missing from the list since v26. On
  the owner's seat's answer at `docs/trail/architecture/cycle-28.md` § 3.1 — RN-42)*. **What the scope does not do, named so none of it is read as coverage:** any later
  `benches/` or `examples/` is not excluded, until one occurs; and two escapes are review catches
  at `development-design` and not grep rules, because the tree holds no *shipped* site to shape
  one against — shipped code that pulls a file from `tests/` in through a `#[path]` attribute,
  which is the attribute above on a module without the `#[cfg(test)]` gate, whose body would then
  ship and no scan would read (RN-19). The file reading above and this escape rest on each other:
  the reading is safe only while the module stays gated, and the script's own header names the
  gap (`checks/structure.sh:L101-L102` at `nozoki@463acb9`) *(through v25 this sentence said the
  tree held no such site, true of shipped code and silent on the two test-only ones; on the
  owner's seat's answers at `docs/trail/architecture/cycle-23.md` §§ 3.3, 3.4 — RN-37)*. The
  second escape is Rust source a build script generates into `OUT_DIR` and a shipped file pulls
  in with `include!`, which ships and which no scan of sources reads (`grep -rn OUT_DIR crates/`
  prints nothing, 2026-09-23; RN-24). **`checks/view.sh` has the same scope on the Swift
  side:** it scans `nozoki-mac/Sources`, the path C-R7 names, and `nozoki-mac/Tests/` is outside
  its scan — a test may build an attributed string or read a fixture file that a surface may not.
- **The harness's own suites, `checks/tests/`, run as CI steps — stated once, here.** Each
  `checks/<name>.sh` script with a suite `checks/tests/test_<name>.sh` beside it is proved by that
  suite to read what its entry says it reads, and the suite runs as its own CI step on every
  build, the way `Bundle probe suite` runs `checks/tests/test_bundle.sh`
  (`.github/workflows/ci.yml:L41-L42` at `nozoki@463acb9`) — a script whose suite runs nowhere
  is ADR-0012's rule broken one level down: a gate that cannot go red has not run. A script that lands with a suite
  lands the suite's CI step in the same change. Eight suites are in the tree (`ls checks/tests`:
  `test_bundle.sh`, `test_entry_points.sh`, `test_no_network.sh`, `test_own_state.sh`,
  `test_read_only.sh`, `test_renderer.sh`, `test_structure.sh`, `test_view.sh`) and all eight are
  on steps at `nozoki@b158052`, each the whole `run` of its own step (`.github/workflows/ci.yml` at
  `nozoki@b158052`: `:L31-L32` `test_structure.sh`; `:L37-L38` `test_entry_points.sh`;
  `:L47-L48` `test_bundle.sh`; `:L53-L54` `test_view.sh`; `:L64-L65` `test_renderer.sh`;
  `:L73-L74` `test_read_only.sh`; `:L79-L80` `test_no_network.sh`; `:L82-L83`
  `test_own_state.sh`); the test command (`ci.yml:L26`) runs none of them. The count and the lines are dated and pinned: an eighth suite, or a step inserted
  above these, is a re-measurement of this sentence and not a contradiction of it, and a new suite
  lands its step in the same change by the rule above. This sentence is the count's one home —
  § 10 points here and does not repeat it *(through v25 it counted six, on steps from
  `nozoki@ab39502`, at `:L35-L36`, `:L41-L42`, `:L52-L53`, `:L61-L62`, `:L67-L68` and `:L70-L71`
  with no commit named — true at `nozoki@ab39502`, and moved six lines down when `Structure check`
  and `Structure check suite` landed at `:L28-L32`; on the owner's seat's answer at
  `docs/trail/architecture/cycle-23.md` § 3.2 — RN-37; through v27 it counted seven, on steps at
  `nozoki@463acb9` — `:L31-L32`, `:L41-L42`, `:L47-L48`, `:L58-L59`, `:L67-L68`, `:L73-L74` and
  `:L76-L77` — true at that pin, and re-measured to eight when `test_entry_points.sh` landed with
  its step at `nozoki@b158052`; on the owner's seat's answer at
  `docs/trail/architecture/cycle-25.md` § 3.1 — RN-39)*. *History,
  and the rule it kept:* at `nozoki@153f5a1` one suite was on a step, `test_bundle.sh`, and
  `test_renderer.sh` failed one case, `test_header_names_the_runner_reading`, the test of a task
  that change deferred; the ordering rule then in force — that suite's step lands with the change
  that puts the runner reading in `checks/renderer.sh`'s header, or after it, never by skipping
  or deleting the case — held: the reading went into the header at `nozoki@2b83dce` and the
  suite's step landed at `nozoki@66ba2e8`, both in the change merged at `nozoki@ab39502`, and
  the case passes there (`NOZOKI_TEST_ONLY=test_header_names_the_runner_reading
  checks/tests/test_renderer.sh` → `ok`, exit 0, re-run this fold). **How a suite joins.** A
  suite joins as a fatal step, and its first CI run is its hosted-runner reading: whether a suite
  runs on the hosted runner is not known until it is tried there, and trying it is the join. A
  suite that is red there moves to a named release step on the Mac, recorded in this bullet with
  the measurement, never left silent — and until the next change moves or fixes it, `main` is
  red; the step is never quieted. The one ruled-out way to join: a non-fatal step —
  `continue-on-error`, or an `if:` that skips it — while a suite waits for its reading, a gate
  that cannot go red (ADR-0012 § Decision). Where the five stand as this fold runs (2026-09-24,
  at `nozoki@c26d47c`): not yet run on the hosted runner — no step carries `if:` or
  `continue-on-error` (`grep -nE 'continue-on-error|^[[:space:]]+if:' .github/workflows/ci.yml`
  prints nothing), and `gh run list --repo kensaiapp/nozoki --workflow ci.yml` lists as its
  newest 35988399477 on `nozoki@37a962d` and 35968105480 on `nozoki@c461b29`, `origin/main` is
  `c461b29` and `git rev-list --count origin/main..main` prints `29`, so no push yet carries the
  five steps; on a Mac at `nozoki@ab39502` with the bundle built, all six exit 0 (the PM's
  measurement, `docs/trail/architecture/cycle-14.md` § 3.2). The first push that carries them is
  their reading, and this bullet records it *(through v16 this bullet read one of six on a step
  and the five joining "as each is green on the hosted runner" — a precondition only the join
  could meet; on the owner's seat's answers at `docs/trail/architecture/cycle-14.md` §§ 3.1, 3.2
  — RN-28)*. Where they stand at v28 (2026-10-03, at `nozoki@6dae2ca`, whose `ci.yml` and
  `checks/` are `nozoki@b158052`'s): **the five have their reading, green.** The first push to
  carry them, `nozoki@c79270f`, ran as GitHub Actions run 36034875098 (push to `main`,
  2026-09-24T17:31:13Z, `success`), and `View check suite`, `Renderer gate suite`, `Read-only
  suite`, `No-network suite` and `Own state suite` each read `success` in it, as does `Bundle
  probe suite` (`gh run view 36034875098 --repo kensaiapp/nozoki --json jobs`); the run before
  it, 35988399477 on `nozoki@37a962d`, does not carry `nozoki@ab39502`. **The four steps that joined
  after have none.** `Structure check` and `Structure check suite` landed at `nozoki@463acb9`, and
  `Entry-points check` and `Entry-points check suite` at `nozoki@b158052`. `origin/main` is
  `d234b57`, `git merge-base --is-ancestor <commit> origin/main` exits 1 for both commits, and
  the newest run, 36958237363 on `nozoki@d234b57` (2026-10-02T03:00:44Z, `success`), lists none
  of the four steps. All four are fatal — the grep above still prints nothing — and the first
  push that carries each pair is its reading, which this bullet records *(added at v28: the
  entry-points pair on the owner's seat's answer at `docs/trail/architecture/cycle-25.md` § 3.1,
  the five's reading and the structure pair found while folding it — RN-39)*. § 10 names each
  script's suite beside it.
  — *verified by:* `for s in checks/tests/*.sh; do grep -q "$s" .github/workflows/ci.yml || echo
  "$s"; done` over the tree, which prints the suites on no step — nothing at `nozoki@ab39502`,
  re-run that fold, and nothing at `nozoki@b083f99`, re-run for v26, whose `ci.yml` and
  `checks/` are `nozoki@463acb9`'s (`git diff --stat 463acb9 b083f99` over both prints nothing),
  and nothing at `nozoki@6dae2ca`, re-run for v28, whose `ci.yml` and `checks/` are
  `nozoki@b158052`'s (`git diff --stat b158052 6dae2ca` over both prints nothing) —
  read at `development-design` on any change under `checks/` or to
  `.github/workflows/ci.yml` — a review gate, argued: no script in the tree runs that comparison
  (`ls checks/*.sh` at `nozoki@ab39502`: `bundle.sh`, `no-network.sh`, `own-state.sh`,
  `read-only.sh`, `renderer.sh`, `view.sh`), and that absence is the gate's only ground. What is
  owed, so the change that writes it has a bar: a `checks/` script that runs the comparison and
  exits non-zero when any suite under `checks/tests/` is named by no step of `ci.yml`, on a CI
  step of its own; if that script has a suite, the suite lands its own step in the same change,
  by this bullet's rule. The day it lands, this tail names it and the review gate drops. Until
  then the gap is one-sided, and named: a suite added with no step is caught only at
  `development-design`; a step naming a deleted suite fails the job on its own, a missing file
  exiting non-zero *(through v16 this tail's ground was that a step would be red on every build
  until the five landed, false from `nozoki@ab39502`; on the owner's seat's answer at
  `docs/trail/architecture/cycle-14.md` § 3.3 — RN-28)* *(traces to: SDD § 4 C-I3 — its
  *Violated by*, "a build that skips a script", and its probe-suite clause; § 3
  `read-only-harness`; ADR-0012 § Decision — "a gate that cannot go red has not run"; QC-25's
  tail — the probe's suite, "without which the probe has not run"; added at v15 on the owner's
  seat's answer at `docs/trail/architecture/cycle-12.md` § 3.5 — RN-26; re-cut at v17 on the
  owner's seat's answers at `docs/trail/architecture/cycle-14.md` §§ 3.1 – 3.3 — RN-28)*
- **`nozoki-mac` against the Swift packet, stated once, here** (the reasons are RN-24; the packet
  is `languages/swift/`, and a rule of it not named here is followed as written). *Framework —
  departed from until a CI log on `main` names a toolchain that runs Swift Testing:* new tests use
  XCTest in the test targets that exist. Five files import XCTest at `nozoki@f46269a`; the fifth is
  `nozoki-mac/Tests/SurfacesTests/RootItemsViewExpansionTests.swift`, added at `nozoki@a5fc189`.
  From the first such log onward, new tests use Swift Testing and the existing XCTest files stay,
  as the packet keeps them (`testing.md` § One framework). This flip is separate from the tools-6.2
  flip below: Swift Testing ships with the Swift 6 toolchain and Xcode 16, and the current
  `macos-14` image carries Xcode 16.1 and 16.2 beside its 15.4 default, so a delivery-tier change
  can select a toolchain the image already holds; the flip still waits on the named log, never the
  image label (RN-31). *Test targets — adopted:* named
  `<Target><Layer>Tests`, the packet's form (`layout.md` § Naming); `SurfacesTests` and
  `ShellTests` (`nozoki-mac/Package.swift:L34-L35`) predate the packet and are owed it, and which
  layer word each takes is the delivery tier's placement under this table's rows. *Toolchain —
  not yet measured:* from `nozoki@0aca57e` CI builds `nozoki-mac` in two steps —
  `.github/workflows/ci.yml:L26` runs `swift test --package-path nozoki-mac` in `Test gate`, and
  `:L35` runs `nozoki-mac/assemble.sh`, both at `nozoki@463acb9` *(drafted at v26 — RN-37 — and
  confirmed in the owner's seat at `docs/trail/architecture/cycle-24.md` § 2.1 — RN-38: through
  v25 the build step was cited `:L29` with no commit named, true at `nozoki@0aca57e`, and it
  moved six lines down when `Structure check` and `Structure check suite` landed at `:L28-L32`)*
  *(through v13 this clause read that CI did not build it,
  true of `ci.yml` at `nozoki@99e2bac`; corrected on the owner's seat's answer at
  `docs/trail/architecture/cycle-11.md` § 3.4 — RN-25)* — but the toolchain version CI builds
  it with, which the packet has this document record where no `.swift-version` pin exists, and
  none does (`toolchain.md` § Toolchain version), is still unread. The first CI run on `main` to
  run those steps is GitHub Actions run 35968105480 on `nozoki@c461b29` (`success`; image
  `macos-14-arm64` 20260831.0302.1, macOS 14.8.9), and its log names no Swift version — the one
  `swift-version` line in it is a build file's name, `Write swift-version-76B232A4806BA581.txt` —
  so by this line's own rule it stays *not yet measured* and waits for a log on `main` that names
  the toolchain, recording then the Swift version, the run id and the runner image's version
  together, because `macos-14` is a label whose default Xcode can move under the same name and a
  later reader must tell a re-measurement from a contradiction. `ci.yml` has no `swift --version`
  step (`:L22-L35` at `nozoki@463acb9`, and `grep -n 'swift --version' .github/workflows/ci.yml`
  prints nothing over the whole file — drafted at v26, RN-37, and confirmed at
  `docs/trail/architecture/cycle-24.md` § 2.1, RN-38); whether to add one is the delivery tier's *(through v14 this clause read that
  no CI run on `main` had built it, true at `origin/main` = `a4ab8e6`; drafted at v15 on the item a
  `companion-self-answer` run raised on this document — RN-26 — and confirmed in the owner's seat
  at `docs/trail/architecture/cycle-13.md` § 2.1 — RN-27)*. *Departed from, as one decision, until CI builds
  `nozoki-mac` on an image carrying a Swift 6.2 or later toolchain:* the `6.2` tools version
  (`Package.swift:L1` reads `5.9`); the `.binaryTarget` artifact-bundle link (`:L19`, `:L26-L29`
  link `libnozoki_bridge.a` as a system library with a `-L` linker flag, the route the packet
  lists second among its alternatives); `.treatAllWarnings(as:)` on every target (none set); the
  Swift 6 language mode, written as `swiftLanguageModes: [.v6]` for every target (the 5.9 manifest
  leaves every target in Swift 5 mode); `.strictMemorySafety()` on every Swift target, including
  `SurfacesTests` and `ShellTests`; and `.defaultIsolation(MainActor.self)` on `Surfaces` and
  `Nozoki`, but not on `Shell`, `SurfacesTests` or `ShellTests`. The manifest APIs for the three
  settings need `PackageDescription` 6.2 (`toolchain.md` § Toolchain version; `quality_gates.md`
  § Types; `conventions.md` concurrency rules), and the one image this
  product's CI runs on, `macos-14` (`ci.yml:L18`), offers Xcode 15.0.1 – 16.2
  with 15.4 the default
  (https://github.com/actions/runner-images/blob/main/images/macos/macos-14-arm64-Readme.md, read
  2026-09-23), while Swift 6.2 was released on 2025-09-15
  (https://www.swift.org/blog/swift-6.2-released/, read 2026-09-23). Which Swift each of those
  Xcodes carries is not cited here — the first CI log that builds `nozoki-mac` prints it, and if
  it shows a 6.2 or later toolchain the departure's ground is gone and all six are adopted then.
  Otherwise the change that moves CI to such an image adopts all six together and re-measures
  QC-25's hosted-runner narrowing, taken on `macos-14` (`docs/SDD.md` RN-48), on the new image.
  The adoption's measured source cost is explicit. Swift 6 mode refuses
  `nozoki-mac/Sources/Shell/LaunchFlow.swift:L60`, `:L107` and `:L111` at `nozoki@7c7038f` (each
  `bridge`, an `any Bridging`, captured in a `@Sendable` closure — the measured site was the
  `listTree` closure, `:L53` at `nozoki@6e1d79f` and `:L107` now; `:L60`, the open closure, and
  `:L111`, the `selectFile` closure, were added after it and fail the same way — RN-33) and
  `nozoki-mac/Sources/Shell/ReadRunning.swift:L28` (`deliver`, a
  `@MainActor (RootListing?) -> Void`, sent across one), plus any site added before the flip. No
  target carries `StrictConcurrency` meanwhile: without warnings-as-errors its diagnostics cannot
  fail the Test gate, and CI's unmeasured compiler leaves the setting's required spelling unknown.
  Strict memory safety requires explicit `unsafe` acknowledgements at the C-pointer uses in
  `nozoki-mac/Sources/Nozoki/NativeBridge.swift` and the AppKit `unowned(unsafe)` properties in
  `nozoki-mac/Sources/Surfaces/RootItemsView.swift`. No separate current source failure is named
  for default isolation: with Swift 5 mode held, the current `Nozoki` target builds with default
  isolation on `Surfaces` and `Nozoki` (RN-31).
  *Departed from, with the same flip — the packet's dependency gate's `type == "system"`
  clause:* the packet's gate refuses any target whose `type` is `"system"` (`quality_gates.md`
  § The gates — `select(.url != null or .type == "system")`), and `nozoki-mac` links the bridge
  through `.systemLibrary(name: "CNozokiBridge")` (`Package.swift:L19`), so that gate as written
  fails the tree as built. The departure is that one clause and nothing else, for the same reason
  as the link: the system library is a module map over `nozoki-bridge`'s generated header, that
  crate is this repository's own and is on `checks/deps.allow`, and the link brings nothing new
  into the tree. `checks/no-network.sh` stands in the gate's place: it holds the gate's other two
  conditions — a non-empty `dependencies` array and a target carrying a `url` (`:L31-L32`) —
  reads the dump with `plutil` rather than `jq`, and refuses a `Package.resolved` at any depth
  under the package (`:L149`), wider than the packet's working-directory test. The clause departs
  only because the system-library link exists, so it flips with the six above: when the
  artifact-bundle link replaces the system library, no target has `type == "system"` and the
  packet's gate is followed as written *(on the owner's seat's answer at
  `docs/trail/architecture/cycle-11.md` § 3.6 — RN-25)*.
  — *verified by:* `swift test --package-path nozoki-mac` (the runner, every change);
  `checks/no-network.sh` (the Swift half of the dependency gate, every change); review at
  `development-design` on any change to `nozoki-mac/Package.swift` or `.github/workflows/*.yml`
  against this bullet — the seven tools-6.2 departures, including the dependency-gate clause,
  flip together or not at all — and review at `development-design` on any change that adds a file
  under `nozoki-mac/Tests/`, against the *Framework* clause — review gates because no command reads
  which toolchain CI builds with: CI builds `nozoki-mac` from `nozoki@0aca57e`,
  and the review stands until a CI log on `main` names the toolchain; the day one does, the
  toolchain line above is what that log is checked against.
- **Layers 6–7 are QA-role ATDD work.** No QA seat has written either for this product yet; until
  one does, layer 6 is verified by `checks/structure.sh`, `checks/entry-points.sh` and
  `checks/view.sh`, run in CI, and layer 7 by the SDD's per-slice command bars and the acceptance
  walk at release.

## 10. Verification map

A projection of every machine-checked entry above. When a row disagrees with its entry, the entry
is right and this row is stale.

Where a row names a `checks/<name>.sh` script that has a suite under `checks/tests/`, the suite is
named beside it as `(suite test_<name>.sh)`: the suite proves the script reads what the row says it
reads, and runs as its own CI step on every build — § 9's `checks/tests/` bullet is the rule, and
the one place the suites are counted (added at v15 — RN-26; the count at v17, on the owner's
seat's answer at `docs/trail/architecture/cycle-14.md` § 3.1 — RN-28; through v25 this preamble
repeated the count, and the copy went stale with § 9's — RN-37). The suite tag means the suite
proves what its script holds; it does not reach a rule the script does not hold.

*Gated at* reads by the header's rule, per rule: a row's `CI build` holds for the rules its command
already holds, and `development-design` reading the entry is the gate for the rest. Which rules a
script holds is its own header's to state — for `checks/structure.sh`, *THE SCAN TABLE* and *WHAT
IS NOT HELD* (`checks/structure.sh:L35-L93` at `nozoki@463acb9`) — and no row here copies it
*(on the owner's seat's answer at `docs/trail/architecture/cycle-23.md` § 3.1 — RN-37)*.

| QC | Check | Command / layer | Runs over | Gated at |
|---|---|---|---|---|
| QC-1 | the shell holds no I/O of its own | `checks/view.sh` (suite `test_view.sh`); `checks/no-network.sh` (suite `test_no_network.sh`) | the tree | CI build |
| QC-2 | no write under the folder; the walk's calls against the export set | `checks/read-only.sh <fixture>` (suite `test_read_only.sh`); `checks/structure.sh` (suite `test_structure.sh`); the walk's calls read against the build's export set, reviewed in the change that exports a command | the tree; the change | CI build; release; `development-design` |
| QC-3 | no network transport — the tree equals the list; the list holds no transport; the release executable links none | `checks/no-network.sh` (suite `test_no_network.sh`); the allowlist diff reviewed against the entry's domain, in the resolved features, at `development-design`; `checks/view.sh` (suite `test_view.sh`) — `nm` on the release executable | the tree; the change | CI build; `development-design` |
| QC-4 | ItemState on every read | `cargo test --locked -p nozoki-core` (layer 1); `swift test --package-path nozoki-mac` (layer 4) | the change | `development-implementation` |
| QC-5 | root finding | `cargo test --locked -p nozoki-core --test root_finding` | the change | `development-implementation` |
| QC-6 | containment check | `cargo test --locked -p nozoki-core --test markdown`; `cargo test --locked -p nozoki-bridge --test asset_bytes` | the change | `development-implementation` |
| QC-7 | no mutating Git call, no spawn | `checks/read-only.sh` (suite `test_read_only.sh`); `checks/structure.sh` (suite `test_structure.sh`) | the tree | CI build |
| QC-8 | `nozoki-mac` imports and dependencies | `checks/view.sh` (suite `test_view.sh`); `checks/no-network.sh` (suite `test_no_network.sh`); `swift test --package-path nozoki-mac` | the tree | CI build |
| QC-9 – QC-12, QC-14 | `nozoki-core` / `checks/` imports; no `unsafe` outside the bridge | `checks/structure.sh` (suite `test_structure.sh`); `checks/no-network.sh` (suite `test_no_network.sh`); `cargo tree -p nozoki-bridge`; `cargo build --workspace --locked` | the tree | CI build |
| QC-63 | a module of no part in `nozoki-core` imports no part | `checks/structure.sh` (suite `test_structure.sh`) | the tree | CI build |
| QC-13 | `nozoki-bridge` imports; the export set; the ABI under the sanitizer | `checks/structure.sh` (suite `test_structure.sh`); `cargo test --locked -p nozoki-bridge --test exports`; the bridge's tests under `-Zsanitizer=address` | the tree | CI build |
| QC-15, QC-17 | I/O ownership; the two composition roots; libgit2's machine-level config search paths empty, failing closed, once per process | `checks/structure.sh` (suite `test_structure.sh`); `checks/view.sh` (suite `test_view.sh`); `cargo test --locked -p nozoki-bridge` — the four search paths read back empty, and the switch's fail-closed and once-per-process cases | the tree | CI build |
| QC-16 | writes only in the container | `checks/own-state.sh` (suite `test_own_state.sh`) | the tree | CI build; release |
| QC-19 | folder replace-whole | `cargo test --locked -p nozoki-core --test switch`; `git diff --stat … -- nozoki-mac` | the change | `development-implementation` |
| QC-20 | own-state isolation | `checks/structure.sh` (suite `test_structure.sh`) | the tree | CI build |
| QC-22 | the hostile fixture as a `MarkdownDocument` | `cargo test --locked -p nozoki-core --test markdown` | the change | `development-implementation` |
| QC-23 | no web engine | `checks/view.sh` (suite `test_view.sh`); `checks/no-network.sh` (suite `test_no_network.sh`) | the tree | CI build |
| QC-24 | the export set equals the header, inside `SM-4`'s list and `nozoki_free` | `cargo test --locked -p nozoki-bridge --test exports` | the tree | CI build |
| QC-25 | entitlements; sandbox present | `checks/bundle.sh` (suite `test_bundle.sh`) | the tree | CI build; release gate |
| QC-62 | the shell runs under the shipped entitlements | `checks/renderer.sh Nozoki.app` (suite `test_renderer.sh`) and `checks/fixtures/idle-shell` | the tree | CI build; release gate |
| QC-26 | allowlist; locked build; no Swift dependency | `checks/no-network.sh` (suite `test_no_network.sh`); `cargo build --locked` | the tree | CI build |
| QC-27 | critical vulnerability | `cargo audit` (every advisory; `--ignore <RUSTSEC-id>` with its reason) | the tree | release |
| QC-28 | no secret; no signing identity | `gitleaks git`; `gh secret list --repo kensaiapp/nozoki`; `codesign -dv Nozoki.app` | the tree; the release | CI build; release |
| QC-29 | artifact = tag build | `shasum -a 256 -c SHA256SUMS` against a rebuild | the release | release |
| QC-30, QC-58 | no other entry point; no configuration — the product's own units | `checks/structure.sh` (suite `test_structure.sh`); `checks/view.sh` (suite `test_view.sh`) | the tree | CI build |
| QC-30, QC-58 | the linked tree's environment and argument reads — Rust names, and C `getenv`, `environ` and `_NSGetEnviron` — against the reviewed list | `checks/entry-points.sh` (suite `test_entry_points.sh`) against `checks/entry-points.allow` | the tree | CI build |
| QC-32 | empty egress set | AC-3 network monitor; `checks/no-network.sh` (suite `test_no_network.sh`) | the release; the tree | release; CI build |
| QC-34 | the shell's reach | `checks/view.sh` (suite `test_view.sh`); `checks/no-network.sh` (suite `test_no_network.sh`) | the tree | CI build |
| QC-35 | the product's reach — writes observed; the machine-level config reads switched off | `checks/own-state.sh` (suite `test_own_state.sh`); `checks/read-only.sh` (suite `test_read_only.sh`); `cargo test --locked -p nozoki-bridge` — the four search paths read back empty (QC-17) | the tree | CI build |
| QC-36 | no spawned process | `checks/structure.sh` (suite `test_structure.sh`); `checks/view.sh` (suite `test_view.sh`) | the tree | CI build |
| QC-37 | `asset_bytes` and the decoder | `cargo test --locked -p nozoki-bridge --test asset_bytes`; `swift test --package-path nozoki-mac` | the change | `development-implementation` |
| QC-38 | own-state fields | `checks/own-state.sh` (suite `test_own_state.sh`) | the tree | CI build |
| QC-39, QC-52 | log shape and location | `cargo test --locked -p nozoki-bridge` (layer 1); `checks/own-state.sh` (suite `test_own_state.sh`) | the change; the tree | `development-implementation`; CI build |
| QC-40 | log bound; own-state retention | `cargo test --locked -p nozoki-bridge`, `cargo test --locked -p nozoki-core` (layer 1); `checks/own-state.sh` (suite `test_own_state.sh`) after `checks/churn.sh` | the change; the tree | `development-implementation`; CI build |
| QC-41 | third-party notices | `checks/notices.sh` | the release | release |
| QC-42 | private reporting; SECURITY.md | `gh api repos/kensaiapp/nozoki/private-vulnerability-reporting` | the release | release |
| QC-44 | standing sentences verbatim | `checks/readme.sh` | the release | release |
| QC-46 | latency figures | `checks/latency.sh` | the tree | CI build |
| QC-47, QC-48 | per-item degradation; churn | `cargo test --locked -p nozoki-core --test watch` with `checks/churn.sh`; `swift test --package-path nozoki-mac` (layer 4) | the change | `development-implementation` |
| QC-49 | promises through kill | `checks/read-only.sh --kill` (suite `test_read_only.sh`) | the tree | CI build; release |
| QC-51 | failure visible in window | `swift test --package-path nozoki-mac` (layer 4); `checks/view.sh` (suite `test_view.sh`) | the change; the tree | `development-implementation`; CI build |
| QC-53 | no internal text | `checks/strings.sh`; layer-5 error-path tests | the tree | CI build |
| QC-55 | one bundle, one process | `checks/bundle.sh` (suite `test_bundle.sh`) | the tree | CI build |
| QC-56 | macOS floor in the bundle | `/usr/libexec/PlistBuddy -c 'Print :LSMinimumSystemVersion' …` | the release | release |
| QC-59 | priced contract against its major's pin | `checks/contract.sh <tag>` | the release | release, from `v1.0.0` |
| QC-60 | own-state read across versions | `checks/own-state.sh --from <previous-tag>` (suite `test_own_state.sh`) | the release | release |
| QC-61 | logging facade and its implementation | `checks/no-network.sh` (suite `test_no_network.sh`); `checks/structure.sh` (suite `test_structure.sh`) | the tree | CI build |

Entries with no row are review gates, each arguing its downgrade in its own tail: QC-13 (the
delegation half), QC-63 (the types-and-values half), QC-30 (a new read inside a listed crate and name), QC-18, QC-21, QC-31, QC-33, QC-43, QC-45, QC-50, QC-54, QC-57, and QC-59's behaviour member.

---

## NFDR Review Notes

- **RN-1:** *(the derivation)* Every entry traces to an SRS requirement, an SDD condition, an ADR
  record, an FDR rule or decision, or a doctrine floor named by file and version. No quality floor
  originates here. The SDD's § 4 conditions (`C-R`, `C-I`, `C-D`) are the source of most § 2 – § 8
  entries; the SDD describes each once and this document carries the checkable form, per the
  ownership rule that the enforceable statement lives where the checker looks.
- **RN-2:** *(the FDR at Draft — history, corrected at v2)* v1 of this document read `docs/fdr.md`
  at Draft, v1, with thirteen companion items open — `nozoki@a50718a`, the FDR's v1 commit;
  `git show a50718a:docs/fdr_open_issues.md | grep -c '^### '` prints `13` — and v1 of this note
  said *eight*, which was the second bucket alone and false when written. Every FDR trace v1 wrote
  was to a rule or decision the FDR carried from a settled source, and none turned on an item that
  companion held; the fourteenth item, this document's own QC-60 question (`nozoki@98df76b`), came
  back as R-168 – R-170 and PD-39 and QC-60 traces to them. The FR-13 contradiction v1 recorded —
  the Git-view row opening the diff against the SRS's row opening the file — ended at SRS v12
  (`nozoki@5c9dda7`; `docs/fdr.md` RN-25) and was behaviour throughout. The FDR now stands Settled
  at v3 (`nozoki@3325469`), its companion removed and its two rounds at `docs/trail/fdr/cycle-1.md`
  and `cycle-2.md`; the header's `Inputs read:` line carries the present status. Corrected on the
  owner's-seat answer at `docs/trail/architecture/cycle-1.md` § 2.8, which moved the count under
  its commit and made the note history rather than present state.
- **RN-3:** *(tools this document names where the SDD named none)* `cargo audit`,
  `pnpm audit --audit-level=critical`, `gitleaks git`, `checks/structure.sh`,
  `checks/notices.sh`, `checks/readme.sh`, `checks/strings.sh` and
  `cargo test -p nozoki-app --test config` are this document's realizations of obligations whose
  source names the obligation and not the command — the doctrine floors for secrets and
  dependencies, and the SDD's config, notice and wording bars. Another tool with an exit code
  satisfies the same entry; the tool choice is the CTO's toolchain lane and was put to the owner,
  who confirmed the set with two corrections (`docs/trail/architecture/cycle-1.md` § 2.7):
  `gitleaks detect` — v1's spelling — is deprecated since gitleaks v8.19.0 in favour of
  `gitleaks git` and `gitleaks dir`, exit 0 on no leak and 1 on a leak or an error
  (https://github.com/gitleaks/gitleaks/blob/master/README.md), so QC-28 and § 10 name
  `gitleaks git`; and `cargo audit` has no severity threshold — its only filter is
  `--ignore <RUSTSEC-id>` (https://github.com/rustsec/rustsec/blob/main/cargo-audit/README.md) —
  so QC-27 says its gate is every advisory and gives a non-critical one a recorded way through.
  `pnpm audit --audit-level=critical` is as documented (https://pnpm.io/cli/audit). *(re: QC-9 –
  QC-17, QC-27, QC-28, QC-41, QC-44, QC-53; source: `quality_defaults.md` § Secrets,
  § Dependencies; SDD § 4 C-R7, § 6 S-3, S-7; `docs/trail/architecture/cycle-1.md` § 2.7)*
- **RN-4:** *(an obligation the SRS states and the harness did not cover)* NFR-4 binds the
  promises "during and after crashes and abnormal exits", and the SDD's harness hashes a fixture
  around a clean run. QC-49 adds a kill mid-churn to `checks/read-only.sh`, because a delivery
  session would otherwise find the crash half of NFR-4 unverified at release. Confirmed at
  `docs/trail/architecture/cycle-1.md` § 2.6; how many kills and at which points is the layer-5
  test's realization when it is written, not this entry's. *(re: QC-49; source: SRS NFR-4, NFR-9;
  SDD § 4 C-I3; `docs/trail/architecture/cycle-1.md` § 2.6)*
- **RN-5:** *(two product-shaping gaps, drafted, routed, and answered)* The SRS binds semantic
  versioning from 1.0.0 to "the product's public contract" and defines that contract nowhere
  (C-6); and no document stated what a later version does with an earlier version's own-state
  (DR-5). Both were case-2 silences — two architects could answer differently — so v1 drafted
  QC-59 and QC-60 and routed them. Both are answered. **QC-59** is confirmed with one addition
  (`docs/trail/architecture/cycle-1.md` § 2.1): the word v1 dropped from C-6 — *breaking* — is
  restored, with the additive case named as a minor version, because read literally the draft made
  PD-9's floor growth a major version. The definition stays here rather than landing in the SRS as
  v1 expected: it is a constraint by lifecycle — a change could ship breaking as minor silently and
  `development-specs` naming the parts touched is the check — and C-6's "the product's public
  contract" points at it; three of its four parts are the FDR itself or FDR rules (R-129, R-133).
  **QC-60** was overridden into a wider rule and its behavioural half carried upstream
  (`docs/trail/architecture/cycle-1.md` § 2.2): raised on the FDR's companion (`nozoki@98df76b`),
  confirmed by the owner's seat with the discard made silent (`docs/trail/fdr/cycle-1.md` § 2.9),
  and folded at FDR v2 as R-168 – R-170 and PD-39 (`nozoki@0eb5c67`) — symmetric, so a downgrade
  is covered; never a startup failure, because FR-3's list is closed; silent in the window, the
  release notes carrying the statement. QC-60 keeps its check and traces to those rules; its
  verified-by gains the unreadable-container case and a layer-1 test on the reader — this
  document's realization of R-168 and R-169, the way RN-4 extends C-I3 — and the
  crash-mid-write of own-state that QC-49's kill can produce is exactly the case its
  discard-whole clause exists for. *(re: QC-59, QC-60; source: SRS C-6, DR-5, FR-3; FDR PD-20,
  R-168 – R-170, PD-39; `docs/trail/architecture/cycle-1.md` § 2.1, § 2.2)*
- **RN-6:** *(the project card — history, pinned by commit)* At v1 and v2
  `system/projects/nozoki/project.md` carried a provisional `pytest tests/` test command and no
  `Languages:` line (`kensaiapp-opensource@4bdfddd`, the card as it stood when v2 read it), while
  the SDD's command bar was `cargo test --workspace` and the units Rust and TypeScript; § 8 pointed
  at the card as the template requires and named the disagreement. The card has moved four times
  since, each pinned. The test command became
  `cargo test --workspace && (cd nozoki-ui && pnpm exec vitest run)` — the SDD's S-1 bar for the
  Rust workspace and Vitest for `nozoki-ui`, one gate over the two toolchains ADR-0009 fixes
  (`kensaiapp-opensource@c2155cc`, 2026-09-01). The card declared
  `Languages: Rust, TypeScript, Shell` (`kensaiapp-opensource@0af5fb9`, 2026-09-02). Its
  `Languages:` comment stopped saying Rust had no packet (`kensaiapp-opensource@ff43026`,
  2026-09-02) — the fact v3's fold could not reach and left for the owner, closed in the managing
  instance. And the test command took the Rust packet's `--locked`, a `cto:` run's field
  (`kensaiapp-opensource@3a960a7`, 2026-09-02), so it reads
  `cargo test --workspace --locked && (cd nozoki-ui && pnpm exec vitest run)`. § 8 states the card
  as it reads at the last of those commits, and goes false at the card's next move until this note
  is extended — the accepted cost of a live sentence with its pinned history beside it, the shape
  the owner's seat confirmed for RN-2 and again here (`docs/trail/architecture/cycle-2.md` § 2.2,
  § 2.3). Three moves since, the first pinned at v12 and the last two at v13 (RN-23, RN-24): the
  card gained `Language roots:` (`kensaiapp-opensource@defe740`, 2026-09-23), touching neither
  line § 8 states; Swift replaced TypeScript on the `Languages:` line, in the test command — now
  `cargo test --workspace --locked && swift test --package-path nozoki-mac` — and on `Language
  roots:` (`kensaiapp-opensource@5b27023`, 2026-09-23); and the `Languages:` comment named
  Swift's packet (`kensaiapp-opensource@ec80077`, 2026-09-23). § 8 states the card as it reads at
  the last of these. *(re: § 8; source: SDD § 6 S-1; ADR-0009; ADR-0016;
  `languages/rust/testing.md` v1.0.0; the seven
  commits named)*
- **RN-7:** *(language packets — re-derived at v3)* Both packets resolve at step 1 of
  `languages/README.md` § The resolution chain, from the card's `Languages:` line (RN-6): the
  renderer to the TypeScript packet *(history since the card's `kensaiapp-opensource@5b27023`,
  2026-09-23 — `nozoki-mac` resolves from the same line, at the same step, to the Swift packet,
  and where it stands against that packet is § 9's bullet and RN-24)*, the host and core to the
  Rust packet, which the organisation's
  registry gained on 2026-09-02 (`kensaiapp-dev@d628f75c`). v1 and v2 of this note said no packet
  existed and Rust tooling fell to the language-agnostic floor — true when written, false since. A
  packet refines the floor and never overrides this product's own records (`languages/README.md`
  § Precedence), so what stays here is what this product fixes *differently* from a packet, each
  with its reason; the rest is the packet's and is not restated. **Where § 9 departs from the Rust
  packet.** (1) Layers 3, 5 and 6 are realized by the `checks/` harness and `checks/structure.sh` —
  the SDD names the harness by script (`docs/SDD.md` § 4 C-I3; § 6 S-1) and the owner confirmed
  the tool set (`docs/trail/architecture/cycle-1.md` § 2.7; RN-3) — where the packet's shape is
  `tests/<use_case>.rs`, `tests/<flow>.rs` and `tests/architecture.rs` under `cargo test`
  (`languages/rust/testing.md` § Layers 1–5, § Layers 6–7); the SDD and an owner answer each
  outrank the packet. One consequence follows, and it is this product's own: because layer 5 is
  not under `cargo test`, `cargo test --workspace --locked` is the union of
  `cargo test --locked -p nozoki-core` and `cargo test --locked -p nozoki-app` — layers 1–3 across
  the two crates ADR-0009 fixes — and is this product's *change-time* run, which the project card's
  per-task field carries (RN-6), where the packet classifies the workspace form as release-time for
  the one reason it states: that layer 5 lives in the binary crate's `tests/<flow>.rs` and the
  workspace run includes it (`languages/rust/testing.md` § Layers 1–5). `testing_doctrine.md`'s
  "Layer 5 runs separately" is met by the harness running outside the per-task gate, not by a
  crate selector. The condition that would flip it is named and checked: a
  `crates/nozoki-app/tests/<flow>.rs` that starts the built binary through `CARGO_BIN_EXE_*` would
  put layer 5 inside the workspace run silently, and § 9 forbids it by keeping layer 5 on `checks/`
  — `checks/structure.sh` (layer 6), no `CARGO_BIN_EXE_` reference under `crates/*/tests/`. No SDD
  sentence moves — S-1's bar is a floor the card satisfies — and the card's field stands on this
  ground, which its own commit did not state: it rested the workspace choice on RN-6, which weighed
  only the S-1 bar. Answered in the owner's seat at `docs/trail/architecture/cycle-2.md` § 1.2.
  (2) Layer 4 is present, on Vitest Browser Mode with Playwright — the packet's
  own rule for a Rust product that renders is that it "records its layer-4 tooling in its own
  `docs/nfdr.md` § 9" (`languages/rust/testing.md` § The rules that make that table work); the
  browser Playwright drives is not the WKWebView the product ships in, so § 9 splits what layer 4
  proves (rendering given state) from what layer 5 proves (the bundle) — this product's own,
  unchanged. **Where § 9 now follows the packet.** The Rust test paths sit under `crates/` —
  `crates/nozoki-core/tests/`, `crates/nozoki-app/tests/` — the owner's ruling for every Rust
  product here (`languages/rust/layout.md` § A multi-crate product; `kensaiapp-dev@49e0444f`),
  which names this document's § 9 as the one that adapts; ADR-0009 names the crates by name and
  fixes no directory, so no record moves. And every `cargo test` command in § 9, § 10 and the
  entries' tails carries `--locked`, which the packet puts on every run command with its reason —
  "a run allowed to re-resolve dependencies is a run against a tree nobody reviewed"
  (`languages/rust/testing.md` § Layers 1–5) — where v3 carried it on none and listed it neither as
  followed nor as a departure: an omission, not a decision, so the packet's form is followed
  (confirmed at `docs/trail/architecture/cycle-2.md` § 2.1). The tails move with § 10 because § 10
  is their projection, and a row that disagreed with its entry would be stale by this document's
  own rule. QC-26 already makes the CI build `--locked`; this closes the same hole on the test
  side. **Where the two already agree.** `cargo audit` at
  release with `--ignore <RUSTSEC-id>` and its reason (QC-27) and `cargo build --locked` (QC-26)
  are the packet's own gates since `kensaiapp-dev@5ee506e9`, adopted from this document
  (`languages/rust/quality_gates.md` § Dependency advisories). The packet's per-change gates —
  `cargo fmt --all --check`, `cargo clippy --workspace --all-targets --locked -- -D warnings`,
  `cargo check --workspace --all-targets --locked` — and its `unsafe_code = "forbid"` default bind
  Rust code through the resolution chain and are not entries here, as the TypeScript packet's gates
  are not: no SRS floor names them and the packet is their owner. **What the packet leaves to this
  document** — the logging facade the binary crate must select
  (`languages/rust/errors_logging.md` § Which facade) — is QC-61, answered at
  `docs/trail/architecture/cycle-2.md` § 1.1 (RN-15). The v3 drafts on this note, on § 9's
  preamble and on its `crates/` paths were confirmed there (§ 2.1). *(re: § 8, § 9, § 10; QC-26,
  QC-27, QC-61; source: `languages/README.md` § The resolution chain, § Precedence;
  `languages/rust/` — `testing.md` v1.0.0, `layout.md` v1.1.0, `quality_gates.md` v1.1.0,
  `errors_logging.md` v1.1.0; `languages/typescript/testing.md` v2.0.1; SDD § 4 C-I3, § 6 S-1;
  ADR-0008, ADR-0009; `docs/trail/architecture/cycle-1.md` § 2.7;
  `docs/trail/architecture/cycle-2.md` § 1.2, § 2.1)*
- **RN-8:** *(citations outside this repository)* Entries tracing to `quality_defaults.md`,
  `arch_defaults.md`, `testing_doctrine.md`, the TypeScript packet or the Rust packet name files of
  the publishing organisation that a reader of this repository cannot open. Each such entry states its rule in
  full, so the trace is provenance and never a dependency — the same resolution
  `docs/CONTENT.md` § CONTENT Review Notes RN-15 records for that document. *(re: QC-26 – QC-32,
  QC-38, QC-53, § 9)*
- **RN-9:** *(two not-applicable declarations, confirmed)* § 3's identity half and § 7's
  non-repudiation clause are declared not applicable, each with the boundary that makes it true and
  the change that would revoke it; both reached the owner rather than standing as silent holes, and
  both are confirmed (`docs/trail/architecture/cycle-1.md` § 2.3, § 2.4). One correction rode with
  QC-33: v1's revocation sentence named "a hosted mode or a second folder", and a second granted
  folder is still the operating system's grant and creates no identity — it revokes nothing — so the
  sentence now names what the entry's own verified-by already named, a hosted mode, an account, or
  any identifier, and OOS-12 leaves the trace. The security-scoped bookmark (beyond v1) identifies a
  folder, not a person or a device, and stays inside the declaration. *(re: QC-33, QC-54;
  `docs/trail/architecture/cycle-1.md` § 2.3, § 2.4)*
- **RN-10:** *(what stays out)* The raw-source switch not built (SDD TO-5), the extension set
  (SDD § 4 C-I5) and the default branch set (SDD RN-35) are product-visible behaviour the FDR carries
  (PD-11, R-44, R-117) and earn no record or entry here: each is cheap to reverse and a change to
  it is behaviour-visible, which is the FDR's tell. The macOS floor (SDD TO-8) is an entry (QC-56)
  and not a record, because its undo cost is one value and a machine to test on.
- **RN-11:** *(the cycle-1 fold — what moved, and on whose authority)* Every change to settled
  content in this revision names its authorization; the companion as answered is
  `docs/trail/architecture/cycle-1.md`, and its ten answers were the owner's seat's — nine by a
  `companion-self-answer` run (`docs/trail/architecture/self_answer-1.md`, `nozoki@a44a19e`), one
  more by a second (`self_answer-2.md`, `nozoki@357190e`). § 1.1 → QC-27 (no window; the SRS bar
  C-13 outranks the floor). § 1.2 → QC-40 takes the number the SRS folded at v9 (`nozoki@82c199a`,
  NFR-11, AC-13) and becomes a machine check — the two layer-1 tests and the `checks/own-state.sh`
  reading it names are this document's realization, as RN-3's tools are; the pointer to the
  companion goes. § 2.1 → QC-59's
  breaking/additive split (RN-5). § 2.2 → QC-60 restated on the FDR's R-168 – R-170 and PD-39
  (RN-5). § 2.3 → QC-33's revocation clause (RN-9). § 2.4 → QC-54 stands. § 2.5 → ADR-0009 moves
  to Accepted, its reconstructed marking kept, one trace line added while it was still Proposed;
  the index follows. § 2.6 → QC-49 stands (RN-4). § 2.7 → `gitleaks git` and `cargo audit`'s
  every-advisory gate (RN-3). § 2.8 → RN-2 as history. § 2.9 had no answer and is settled by
  derivation (RN-12). No `QC` ID is renumbered or reused; no accepted record is edited beyond
  ADR-0009's Status line and the one trace line added before it was accepted. *(re: QC-27, QC-28,
  QC-33, QC-40, QC-49, QC-54, QC-59, QC-60, § 10, RN-2 – RN-5, RN-9; ADR-0009; source:
  `docs/trail/architecture/cycle-1.md`)*
- **RN-12:** *(the FDR moved under two accepted records and one entry; settled by derivation)*
  Item 2.9 of the cycle-1 companion was raised by the second self-answer run with an empty slot and
  the note that how the log carries it "is the producing run's call". Both halves are derived here
  rather than routed, because the test between a decision and a derivation — could two architects
  reading the same sources answer differently? — returns the same answer for each. **QC-40.** v1
  wrote "a remembered folder until its entry is removed", true of the FDR at v1 (`nozoki@a50718a`)
  and false at v3: R-178 – R-182 (`nozoki@0eb5c67`) and R-110 as re-worded at v3 (`nozoki@3325469`)
  state that no control removes an entry, the list changes only by viewing a folder, and an
  aged-out entry is not restored. A settled entry changes on a new upstream sentence, and the FDR is
  upstream of this document; QC-40 now states the FDR's rule and traces to it — transcription, not
  a call. **ADR-0003 and ADR-0005.** Each record's § Consequences says the Git view presents the
  outside-the-grant case "as a failure naming the folder to choose", citing `docs/fdr.md` R-21 —
  the FDR's v1 text (`nozoki@a50718a:docs/fdr.md`, R-21). The owner's seat overrode R-21 at v2
  (`docs/trail/fdr/cycle-1.md` § 2.7; `docs/fdr.md` RN-7): the failure state names where the Git
  directory lies, says this folder's Git state is therefore not read, and offers no folder to
  choose, because choosing that folder views *that* folder (PD-4) and the route led somewhere else.
  Neither record's decision moved — the sandbox wall and the port's `probe` reporting the `gitdir`
  target are what they were — and an accepted record is never edited; a superseding record is how a
  *reversal* lands, and no decision reversed. So the two records stand as written, dated, and this
  note is where a reader following their R-21 citation is told the sentence behind it moved: the
  behaviour a delivery reader builds and QA verifies is `docs/fdr.md` R-21 at its current version,
  never a record's consequence sentence, which is a dated reading of the source it cites. No entry
  here restates the failure state's wording — QC-5 binds the finding, not the surface — so nothing
  in § 1 – § 8 was false for it. *(re: QC-40; ADR-0003 § Consequences, ADR-0005 § Consequences;
  source: FDR R-21, R-110, R-178 – R-182, RN-7, RN-26; `docs/trail/fdr/cycle-1.md` § 1.2, § 2.7;
  `docs/trail/fdr/cycle-2.md` § 2.3; `docs/trail/architecture/cycle-1.md` § 2.9)*
- **RN-13:** *(upstream moved under this document since v1 read its sources)* Measured on
  2026-09-01 as `git diff --stat b23ed43 HEAD` over the seven inputs, `b23ed43` being v1's own
  commit. `docs/SRS.md` v8 → v12: NFR-11 and AC-13 gained the log's bound at v9 (`nozoki@82c199a`)
  — QC-40 carries it; FR-13, AC-6 and AC-12 took the Git-view row's two readings at v12
  (`nozoki@5c9dda7`) — behaviour, no entry moves, RN-2 records the close; RN-35's clause closed at
  v10 and 80 trail pointers were repaired at v9 — nothing here cites a repaired path.
  `docs/SDD.md` v2 → v3 (`nozoki@5c776aa`): C-R6 reads `pnpm ls` where it read `npm ls` — QC-3 and
  QC-26 already realized the clause as pnpm, so nothing moves; § 12 and RN-6 – RN-8 name ADR-0001,
  ADR-0002 and ADR-0004; 40 trail pointers repaired. `docs/fdr.md` v1 → v3 (`nozoki@0eb5c67`,
  `nozoki@3325469`), now Settled: R-168 – R-170 and PD-39 — QC-60; R-178 – R-182 and R-110 —
  QC-40 (RN-12); R-21 overridden — RN-12; the 37 rules and one decision v2 added beyond those
  (`docs/fdr.md` header, its v2 clause) and R-166 are behaviour and move no entry. `docs/PRD.md` v11 → v15, `docs/UXD.md` v6 → v10, `docs/DESIGN.md` v5 → v8 and
  `docs/CONTENT.md` v4 → v6: wording, the startup surface, the history's home, the folder rename
  and citation repairs — none states a structural fact, a quality floor or a standing sentence
  differently from what QC-44, QC-51, QC-53 and QC-55 – QC-58 bind, and the six standing sentences
  QC-44 names read at v6 as they read at v4 (`docs/CONTENT.md` § Standing sentences, its table
  diffed against `b23ed43:docs/CONTENT.md` — no line differs). The project card (RN-6) is unchanged and still
  provisional. *(re: header `Inputs read:`; QC-3, QC-26, QC-40, QC-44, QC-60; source: the seven
  documents at HEAD, 2026-09-01)*
- **RN-14:** *(v3 — an input moved under a settled document; what this revision did and did not
  do, and on whose authority)* The registry gained a Rust packet on 2026-09-02
  (`kensaiapp-dev@d628f75c`, merged at `bc12fcbe`), after v2 closed on 2026-09-01
  (`nozoki@1329741`). With no companion on disk a
  `product-architecture` re-run reads both records as done, so the companion was re-opened by an
  owner-directed session (`nozoki@5003906`) with two drafts and one question, and this run — the
  first `product-architecture` run after it — is what applied the drafts: § 2.1 → § 9's preamble,
  § 9's two Rust paths and RN-7; § 2.2 → RN-6 and § 8's preamble. Neither is confirmed: the
  companion's slots are unfilled, so nothing was folded and no trail cycle is written; the items
  stay, now describing edits that are in the document rather than proposed for it, and `Status:`
  reads Draft. The seven inputs did not move: `git diff --stat 1329741 HEAD` over them prints
  nothing (2026-09-02), so the `Inputs read:` line stands. **What waits on the open question.** The
  Rust packet requires the binary crate to select a logging facade and initialize it once, early,
  and leaves the choice — `log` or `tracing` — to this document
  (`languages/rust/errors_logging.md` § Logging, § Which facade; the owner's relaxation of the
  packet's first shape, `kensaiapp-dev@819f6708`). `nozoki-app` is that crate and the composition
  root (ADR-0009 § Decision). No entry names a facade, and none is false for it: QC-39 and QC-52
  bind the log's line shape and location and QC-40 its bound, and each holds under either. What the
  choice moves when made: `checks/deps.allow` gains the facade crate and its implementation — a
  reviewed allowlist change either way (QC-3, QC-26) — and the entry recording the choice lands
  under § 7 beside QC-52, because the packet makes recording it an obligation of this document
  ("Recording it is the part that is not optional", same section) and a facade a change could
  swap silently is a constraint by lifecycle. Two architects reading the same SDD could answer
  differently — the packet's discriminator is whether diagnostics are queried by field or read as
  lines — so it is routed, not derived. **No record moves.** ADR-0009 names `nozoki-core` and
  `nozoki-app` by name and fixes no directory: the `crates/` placement is a layout fact under it,
  not a reversal of it, and ADR-0002's *two languages* and ADR-0009's *two toolchains* stay true.
  *(re: header `Status:`, `Version:`; § 8, § 9, RN-6, RN-7; source:
  `docs/architecture_open_issues.md` § 1.1, § 2.1, § 2.2; `languages/rust/errors_logging.md`
  v1.1.0; ADR-0009; the commits named)*
- **RN-15:** *(v4 — the close of the re-opened companion; what moved, and on whose authority)* The
  companion re-opened at `nozoki@5003906` was answered in the owner's seat by two
  `companion-self-answer` runs — three items (`docs/trail/architecture/self_answer-3.md`,
  `nozoki@5b285e4`), then two more raised by an owner-directed session (`nozoki@b55a6d4`) and
  answered (`self_answer-4.md`, `nozoki@6415c46`) — and as answered is
  `docs/trail/architecture/cycle-2.md`. **§ 1.1 → QC-61:** `log`, the product's own `log::Log`
  writer installed once in `nozoki-app`, no third-party implementation. Two things the entry does
  not carry are recorded here. Why no record: the choice fails the significance test — the packet
  records that a library on `log` stays readable from a binary on `tracing` ("It is not a fork
  paid for twice", `languages/rust/errors_logging.md` § Which facade), so reversal is one allowlist
  change and one revision of QC-61, and neither half of the choice surprises a cold reader; the
  ground for `log` over `tracing` is the packet's own discriminator — diagnostics queried by field
  or attributed to a concurrent operation want `tracing`, diagnostics read as lines do not — and
  this log is read as lines by construction: one line per `failed` or `stopped` item (SDD § 4
  C-I2; QC-39), the most recent lines always the ones present (SRS NFR-11), nothing in the product
  reading it back (QC-52), observability minimal by decision (FDR PD-32). What the entry rests on,
  and whose it stays: the `log` crate is the Rust project's (https://github.com/rust-lang/log;
  "Libraries should link only to the `log` crate", "Executables should choose a logging
  implementation and initialize it early", "The logging system may only be initialized once" —
  https://docs.rs/log/latest/log/, read 2026-09-02); if that holder stops answering, the facade
  still compiles, the writer is this product's own, and the reversal above is the packet's bridge
  — the day the holder goes silent un-makes nothing here. QC-61 traces to ADR-0009 § Decision and
  that record's `## Binds` is not extended: an accepted record is never edited, and the pair stays
  navigable from the entry. **§ 1.2 →** RN-7's departure (1) gains its consequence and § 9 its
  layer-5 rule, run by `checks/structure.sh` under § 9 row 6; nothing in § 10 moves and the card's
  field stands. The rule is held in § 9 rather than minted as a `QC` because it binds the test
  strategy's own realization, which § 9 owns and the answer placed there; a reader who needs it as
  an entry may say so on the next companion. **§ 2.1 →** confirmed, with `--locked` on every
  `cargo test` command in § 9, § 10 and the tails (RN-7). **§ 2.2 →** confirmed; RN-6 as applied
  at v3 stands, and the card's comment the fold could not reach was closed in the managing instance
  (`kensaiapp-opensource@ff43026`). **§ 2.3 →** § 8's sentence reads *satisfies and adds*, and
  RN-6's pinned history gains the card's third and fourth commits. One cite moves under no answer:
  `testing_doctrine.md` is v2.2.0 (`kensaiapp-dev@8db7a6b4`, merged at `f5c9ef2c`, 2026-09-02) —
  the bump added one rule, that a test hands a unit its fake through the seam production wires the
  real collaborator through, and moved no layer, so § 9's table stands and its cite follows the
  file. The seven inputs did not move: `git diff --stat 9229881 HEAD` over them prints nothing
  (2026-09-02), so the `Inputs read:` line stands. QC-61 is the one new ID; no `QC` is renumbered
  or reused; no record is edited — ADR-0009 names its crates by name, and the facade is a
  dependency under a crate, not a unit. *(re: header `Status:`, `Version:`; § 8, § 9, § 10, QC-61,
  RN-6, RN-7; source: `docs/trail/architecture/cycle-2.md`; `languages/rust/errors_logging.md`
  v1.1.0, `testing.md` v1.0.0; `testing_doctrine.md` v2.2.0; the commits named)*
- **RN-16:** *(v5 — the cycle-3 fold, and the SDD re-authored beneath a settled document)* Two
  authorizations, kept apart. **The owner's answer.** The companion re-opened at `nozoki@20b9a94`
  by a `companion-self-answer` run — to carry one finding the SDD's re-author raised (its RN-34),
  no authoring run having written it — was answered by the owner through a `companion-answer` walk
  (`nozoki@07a6b74`) and as answered is `docs/trail/architecture/cycle-3.md`. § 3.1 → the 37
  citations in ADR-0001 – ADR-0008 of the deleted SDD's trail and review notes are pinned: the 14
  of `docs/trail/sdd/cycle-1.md` read `nozoki@70a879a:docs/trail/sdd/cycle-1.md`, the 23 of
  `docs/SDD.md` § SDD Review Notes RN-n read `nozoki@70a879a:docs/SDD.md` § SDD Review Notes RN-n
  — `70a879a` being the last commit that touched the SDD before `nozoki@9c91359` deleted it, and
  carrying RN-1 – RN-34, RN-24 and RN-25 included (`git log 70a879a..9c91359 -- docs/SDD.md`
  returns the deletion alone; re-measured 2026-09-04). Where a review-note citation shared a
  backticked path with section references that still resolve, the pinned path is placed on the
  review-note citation alone and the section references keep the live path — the `## Traces to`
  bullets of ADR-0003, ADR-0004, ADR-0006 and ADR-0008 move the review-note citation to the
  bullet's end for it. Prose edits on the owner's ruling that a citation repair reverses no
  decision: no record's Status, date, decision, alternative or consequence moved, no superseding
  record is written, and ADR-0009 and the index are untouched. And QC-48's `SDD § 6 S-4` reads
  `S-5`, the re-authored SDD's `follow-the-folder`. **The upstream that moved.** The SDD every
  earlier revision read (v1 – v4: `nozoki@70a879a` and before) was deleted at `nozoki@9c91359` on
  2026-09-03 and re-authored from the PRD, SRS and UXD as they stand — v1 at `nozoki@c3eb937`,
  Settled at v3 at `nozoki@827aa1c` on 2026-09-04 (`git diff --stat 7cdc857 HEAD` over the seven
  inputs: `docs/SDD.md` alone, 2,021 insertions and 1,549 deletions). Its § 4 fixes the relation —
  "where the two disagree, the § 4 statement wins and the NFDR entry is re-derived" — and its § 12
  records that its run found no disagreement with this document, one confirmation (C-R5's floor,
  QC-56) and one placement taken from it (the `crates/` layout, § 9). Read whole against § 1 –
  § 10, this revision finds the same: every condition C-R1 – C-R7, C-I1 – C-I5 and C-D1 – C-D4
  keeps its number and its subject, and no entry is false for it. What the re-author renumbered,
  and is re-pointed here because this document revises in place and its trace tags name where a
  fact lives now: QC-19's `§ 6 S-6` → `S-10` (`switch-the-folder`); QC-21's `§ 9 TO-1` → `§ 2
  "Undoing it", § 9 TO-4` (the renderer's cost sits under TO-4 now; TO-1 is the two-process seam);
  QC-47's and QC-51's `C-E2` → `C-E3` and QC-53's `C-E2, C-E8` → `C-E4, C-I2` (the experience
  conditions were re-lettered, and the no-internal-text rule now sits in C-I2 as well); RN-3's
  `§ 6 S-2, S-5` → `S-3, S-7`; RN-10's `SDD RN-12` → `§ 4 C-I5` and `SDD RN-16` → `RN-35`. The
  seam citations (`§ 3 seam 4`, `seam 6`) resolve to the same seams and stand. **Two new
  sentences bind.** (1) § 4 C-I6 — `checks/contract.sh <tag>` against the pin
  `checks/contract/<major>` its major wrote — is the machine check QC-59 lacked for three of its
  four members; the entry's tail takes it from `v1.0.0` as a release gate, § 9 row 5 and § 10 gain
  it, and the behaviour member stays a review gate with its reason stated. Derived, not routed:
  the SDD names the script, what it reads and what fails it (C-I6; § 11 R-12), so two architects
  write the same tail. (2) § 4 C-D3 now names the formats the asset scheme serves — PNG, JPEG,
  GIF, WebP — and keeps SVG off it in v1 with a stated reopening mechanism (SDD RN-8, confirmed at
  `docs/trail/sdd/cycle-1.md` § 2.1 — the re-authored SDD's own trail); a change could widen the
  scheme silently and the markdown test names the break, so QC-37 carries the format clause and
  QC-22's fixture names the PNG and the SVG. **§ 8.** S-1's command bar reads `cargo test
  --workspace --locked` in the re-authored SDD, so the card's field equals the bar rather than
  exceeding it; § 8 says so, RN-6's history stands, and RN-7's "S-1's bar is a floor the card
  satisfies" was true of the SDD v4 read and is history at `nozoki@70a879a`. Nothing else in § 1
  – § 10 moves; the `Inputs read:` line stands on the statuses as read, the SDD Settled at the
  re-authored v3. **What is raised, not folded.** Two items, at
  `docs/architecture_open_issues.md`. § 2.1 — the re-author also moved thirteen further ADR
  citations outside the answer's scope (the Open Questions' fifth item, now the third; § 3's
  paragraph after the parts table; ADR-0002's `TO-1, TO-4`; ADR-0004's `R-6`; ADR-0009's `S-6`),
  and every other `docs/SDD.md` citation in the nine records was written against the deleted
  document; the fold did not widen because the answer bounded it to the 38, so the same pin is
  drafted there for the owner's word. § 1.1 — the SDD's confirmed 1.0.0 contract (§ 6 S-11)
  prices the install path, the floor and the surfaces' presence and lists own-state readability
  nowhere, while `docs/fdr.md` PD-39 and QC-59 price it; which document is owed a sentence is the
  owner's and the CPO's, and QC-59 and QC-60 stand on the FDR until it is answered. One defect
  outside this document, reported and not repaired: `docs/fdr.md` cites the deleted SDD's RN-16,
  RN-19, RN-20 and RN-26 by number — R-59, R-70, R-73, R-106, R-117, R-124, R-126, R-171, R-174
  and its own RN-1, RN-9, RN-21, RN-25 (`grep -n 'Review Notes RN-' docs/fdr.md`, 2026-09-04) —
  and the re-authored SDD leaves RN-20 – RN-29 empty and puts other subjects under RN-16 and
  RN-19; the repair is the Principal PM's, through the FDR's own run. *(re: header `Status:`,
  `Version:`; QC-19, QC-21, QC-22, QC-37, QC-47, QC-48, QC-51, QC-53, QC-59; § 8, § 9, § 10;
  RN-3, RN-10; ADR-0001 – ADR-0008; source: `docs/trail/architecture/cycle-3.md` § 3.1;
  `docs/SDD.md` v3 — § 4 C-D3, C-I6, § 6 S-1, S-5, S-10, S-11, § 11 R-12, § 12, RN-8, RN-34; the
  commits named)*
- **RN-17:** *(v6 — the close of the cycle-4 companion, and two inputs moved beneath a settled
  document)* Three authorizations, kept apart. **The owner's two answers** — the companion the v5
  run wrote at `nozoki@41d8c9f`, answered as `docs/trail/architecture/cycle-4.md`: § 2.1 in the
  owner's seat by a `companion-self-answer` run (`self_answer-6.md`, `nozoki@f60bc3f`), § 1.1 by
  the owner in a `companion-answer` walk (`nozoki@e54f920`). **§ 2.1 → fourteen pins.** The thirteen citations
  the item counted, each measured this run at the line it names and each landing on another subject
  in `docs/SDD.md` v5 as it did in v3, read `nozoki@70a879a:docs/SDD.md` § …: ADR-0002's `§ 9 TO-1,
  TO-4` (three in § Consequences, one in § Traces to) and its `§ Open Questions, fifth item`;
  ADR-0006's fifth item in § Consequences and § Traces to; ADR-0005's *paragraph following / after
  the parts table* in § Decision, § Alternatives ruled out and § Traces to; ADR-0004's `§ 11 R-6`;
  ADR-0009's `§ 6 S-6` in § Context and § Traces to. And the fourteenth the answer added: ADR-0001
  § Context's `§ 1, last paragraph`, cited for the quoted *"if the code is careful"*, which the
  re-authored § 1 no longer holds (the phrase sits in § 2's first table row) — a quotation is a claim
  about the words its author read, so it takes the same pin on the owner's ground (b). The form is
  RN-16's: where a moved citation shared a backticked path with section references that still
  resolve — the `## Traces to` bullets of ADR-0002, ADR-0004, ADR-0005 and ADR-0006, and ADR-0005's
  § Decision — the moved reference joins the bullet's existing pinned path and the live references
  keep `docs/SDD.md`. Not taken, as the answer ruled: pinning every `docs/SDD.md` citation in the nine
  records — a citation that resolves to the same passage today is a live claim that the record and the
  SDD still agree, and freezing it would hide the one signal a later re-author's reader has. Prose
  edits on the owner's cycle-3 ruling (3): no record's Status, date, decision, alternative or
  consequence moves, no superseding record is written, the index is untouched. **§ 1.1 → nothing
  moves.** The owner's answer: the FDR is right and complete; `docs/fdr.md` PD-39 stands, and with it
  QC-59's third member — the readability of an earlier version's own-state — and QC-60's *after 1.0.0
  a discard is a breaking change under QC-59*, both as written; no obligation, no machine check, no
  record. What is owed is `docs/SDD.md` § 6 S-11 *Delivers*, whose priced set names three members
  where the contract has four — the CPO's sentence, through the SDD's own run; the owner declined a
  companion on the SDD and will invoke that chain themselves, so this run writes nothing outside these
  records. One thing the answer settled without naming, recorded so it is not re-raised: the
  self-answer that left § 1.1 for the owner named a gap in QC-60's tail — `--from <previous-tag>`
  proves one step where the rule binds every earlier release of the same major
  (`docs/trail/architecture/self_answer-6.md` § 1.1, *Check 4*) — and the owner's answer, given
  with that report beside it, kept the check as it is (*"QC-60's `checks/own-state.sh` keeps the
  member it verifies"*); so the check stands on an owner's word, and a change to it is a fresh
  authorization, not a fold of this one. **The SDD moved beneath this document**, v3 → v5
  (`nozoki@683db69`, `nozoki@67372a5`; `git diff --stat 827aa1c HEAD -- docs/SDD.md`: 158 lines,
  2026-09-05), read whole against § 1 – § 10. Four sentences moved and one entry follows. (1) § 3
  `fs-reader`'s text rule admits UTF-16 by byte-order mark beside UTF-8 and states its boundary — no
  detection from content, no third encoding, an empty file is text (SDD RN-41): QC-31 said *the UTF-8
  rule*, which is now the rule's half, so it names `fs-reader`'s text rule as the SDD states it and
  traces to `SDD § 3 fs-reader` and `FDR R-46, R-154` — transcription of a new upstream sentence,
  the obligation (validate at the boundary) unchanged. (2) § 4 C-E4 gains the terminal form a
  message's third part may take (SDD RN-43): QC-53 traces to C-E4 for *no internal text*, which C-E4
  still carries — no entry moves. (3) § 11 R-3's response reads the owner's form — the observed
  condition is where the Git directory lies, no folder offered (SDD RN-42): ADR-0003 and ADR-0005 each
  cite `docs/SDD.md` § 11 R-3 and `docs/fdr.md` R-21 for a consequence sentence — *a failure naming
  the folder to choose* — that RN-12 already recorded as a dated reading of the FDR at v1; the SDD has
  now caught up to the FDR, so the two records' sentence diverges from both sources it cites, and
  RN-12's rule holds unchanged: the records stand as written and dated, no decision reversed, and the
  behaviour a delivery reader builds is `docs/fdr.md` R-21 and `docs/SDD.md` § 11 R-3 as they read.
  (4) § 6 S-2's and S-4's command halves gain fixtures and a reducer case (SDD RN-41, RN-44) — the
  route's, read into nothing here; § 9's test names (`--test git_state`, `root_finding`, `markdown`,
  `watch`, `switch`, `config`) are the SDD's and unchanged. Every condition C-R1 – C-R7, C-I1 – C-I6,
  C-D1 – C-D4 keeps its number and subject; every `docs/SDD.md` trace tag in § 1 – § 10 was opened
  and resolves to the passage it names. **The FDR moved beneath this document**, v3 → v6
  (`nozoki@2cd990f`, `4a73c1a`, `356b531`), read whole. (5) PD-40, added at FDR v4 and widened at v5
  by an owner answer (`docs/trail/fdr/cycle-3.md` § 2.6), states the priced set — the install path,
  the macOS floor, every PRD-named surface present, and by PD-39 own-state readability — and prices
  *adding a prerequisite* as a major version. QC-59 stated the same set from SRS C-6 and the FDR's
  R-129 and R-133 at v2 (RN-5), before the FDR carried it; the two agree on all four members, and the
  owner's § 1.1 answer confirms the fourth against the SDD's three. QC-59 gains the prerequisite
  clause — with the structural fact beside it that QC-55 forbids a prerequisite while SDD § 4 C-R1
  stands, so the priced move arrives only with a C-R1 change — traces to PD-40, and says which way the
  two statements are read where they ever differ: PD-40 is upstream. `checks/contract.sh` does not read
  a prerequisite; `checks/bundle.sh` (QC-55) catches one on every build, before any version question,
  so no § 10 row moves. (6) R-46, R-154, R-155 and R-21 now realize SDD sections (FDR RN-30) — the
  traces QC-31 takes in (1). (7) FDR RN-28 re-pointed or pinned the FDR's own citations of the deleted
  SDD's review notes — the defect RN-16 reported as the Principal PM's is closed by that document's own
  run, and `docs/fdr.md` RN-28 (*What is pinned to `nozoki@70a879a:docs/SDD.md`*) is its record. Nothing else the FDR added — R-146 – R-182, PD-40's siblings — moves
  an entry: behaviour, the FDR's tell. **What did not move.** `docs/PRD.md`, `docs/UXD.md`,
  `docs/DESIGN.md`, `docs/CONTENT.md`: `git log 827aa1c..HEAD` over them prints nothing (2026-09-05),
  so the `Inputs read:` line stands on the statuses as read — every input Settled. The doctrine files
  this document cites by version are at the versions it names (`quality_defaults.md` 1.1.0,
  `arch_defaults.md` 2.0.0, `testing_doctrine.md` 2.2.0, the Rust and TypeScript packets as § 9 and
  RN-7 cite them; read 2026-09-05). `docs/acceptance_fdr.md` appeared in the docs folder on 2026-09-04
  — the `acceptance-fdr` stub of the FDR's behavioural gates, the Principal PM's chain's — and binds
  nothing here. The project card (RN-6) is unchanged since `kensaiapp-opensource@3a960a7`. No `QC` is
  added, renumbered or reused; no record is edited beyond the fourteen pins; § 10 is unchanged.
  *(re: header `Status:`, `Version:`; QC-31, QC-59; ADR-0001, ADR-0002, ADR-0004, ADR-0005, ADR-0006,
  ADR-0009; RN-12, RN-16; source: `docs/trail/architecture/cycle-4.md` § 1.1, § 2.1;
  `docs/trail/architecture/self_answer-6.md`; `docs/SDD.md` v5 — § 3 `fs-reader`, § 4 C-E4, § 6
  S-11, § 11 R-3, RN-41 – RN-44; `docs/fdr.md` v6 — PD-39, PD-40, R-46, R-154, R-155, R-21, RN-28,
  RN-30; `docs/trail/fdr/cycle-3.md` § 2.6; the commits named)*
- **RN-18:** *(v7 — the close of the cycle-5 companion: three verifications the first built code
  showed could not run as stated)* **How the companion came to exist.** No `product-architecture`
  run opened it. Both records were Settled with no companion on disk, and a re-run would have read
  them as done; the PM opened it on 2026-09-19 from a post-build review (`nozoki@d9cbefc`) with
  three items, all raised from downstream and none drafted. All three were answered in the owner's
  seat by one `companion-self-answer` run (`nozoki@0f4eab3`; its reasoning,
  `docs/trail/architecture/self_answer-8.md`) and as answered the companion is
  `docs/trail/architecture/cycle-5.md`. Every change below names the answer that authorizes it,
  and what this run added beyond an answer's words is marked as this run's own. **§ 3.1 → QC-25,
  and one record.** `docs/SDD.md` moved v5 → v6 (`nozoki@b3439e8`): § 4 C-I3 states a new
  observable for the bundle probe, § 10 RC-1 records the measurement that retired the old one —
  `APP_SANDBOX_CONTAINER_ID` is absent from a sandboxed main process under either signature and
  from an unsandboxed one, so it separates nothing — and RN-45 hands QC-25 and ADR-0008 to this
  seat. QC-25's tail is re-derived from C-I3 under that document's own rule that the § 4 statement
  wins, carrying each of C-I3's failure conditions because each is a way the check goes red:
  transcription, not a call. The obligation clause does not move, and § 10's row names the script
  and not the mechanism, so it stands. QC-25 asserts nothing about a GitHub-hosted runner; that
  question is the SDD's and is open there. ADR-0008 held the marker in its § Decision and in the
  platform fact its last paragraph rests on, so the answer contradicts an accepted record, says in
  terms that it means a reversal of mechanism and not a correction, and lands as **ADR-0010**,
  which restates the decision whole; ADR-0008's Status line reads `Superseded by ADR-0010` and no
  other line of it moved. RN-12's route — leave the record, note the move here — was open and not
  taken, on the answer's ground: RN-12's stale sentence sat in § Consequences quoting another
  document, and this one sat in § Decision, which the delivery tier builds from. The live traces
  to ADR-0008 — QC-14, QC-25, QC-46, QC-48, QC-49 and § 9's layer-5 bullet — read ADR-0010;
  RN-4's, RN-7's and RN-16's mentions are dated history and stand, and ADR-0001, ADR-0003 and
  ADR-0007 name ADR-0008 and stand as written, its Status line forwarding their reader. Two
  platform facts ADR-0010 rests on were re-read for it on 2026-09-19 rather than transcribed: the
  macOS SDK's `usr/include/sandbox.h` declares `sandbox_init` and `sandbox_free_error` and not
  `sandbox_check` (`grep -c sandbox_check` prints `0`), while `usr/lib/libSystem.B.tbd` and
  `usr/lib/system/libsystem_sandbox.tbd` list `_sandbox_check`; and Apple's App Sandbox page
  carries the Activity Monitor sentence C-I3 quotes and names neither the marker nor the function.
  One fact a delivery reader needs and no entry states: `checks/bundle.sh` as last committed
  (`nozoki@ccb58d8`, v1.0.0) still reads the marker, so QC-25 as it now reads is red against the
  script as built until a change lands C-I3's probe and its control. That is the correct reading,
  not a defect of this revision — the entry follows the SDD, and the script follows the entry.
  **§ 3.2 → QC-23.** The entry promised string equality with a string containing `<asset-scheme>`,
  a form the SDD settles only when the asset handler first exists, so no build could pass it as
  written. It is now stated in two states keyed on what C-R7 carries. The interim string is
  derived and not chosen: C-R7 is violated by "any widening", a policy with no asset source admits
  strictly less, and nothing needs the source before a handler exists. Keyed on C-R7's state
  rather than on this document's next revision, because the delivery tier does not edit this
  document, and an entry that waited on a revision here would contradict the test that lands with
  the form. The first state is what the built test already asserts
  (`nozoki@a4ab8e6:crates/nozoki-app/tests/config.rs:L17`, `:L181-L188`;
  `nozoki@a4ab8e6:crates/nozoki-app/tauri.conf.json:L12`), opened this run.
  The tail's second clause — the scan of every directive for the five forbidden sources — names
  what the prohibition half of the obligation was always checked by; the old tail named the
  equality alone. No record moves: ADR-0006 already says the form is open. Not covered, and the
  SDD's: WKWebView accepting no origin form without a plugin (`docs/SDD.md` § 11 R-11), which
  would meet QC-24's *no plugin*. **§ 3.3 → QC-30, QC-58, QC-61, § 9, § 10.** QC-30 said the
  product has "no argument vector, no environment variable", and the process an adopter runs reads
  both: `tauri-runtime-wry` 2.11.4 reads `TAURI_WEBVIEW_AUTOMATION` (`src/lib.rs:4792`) and
  `tauri-utils` 2.9.3 collects `std::env::args_os()` (`src/lib.rs:282`), each at the version
  `Cargo.lock` resolves. The answer: the boundary set covers what the shipped process reads,
  whichever crate reads it — the floor's subject is *the product* (`quality_defaults.md` § The
  boundary set) — so this is a correction of a statement measured false and no new requirement.
  No upstream document made the absolute claim: `docs/fdr.md` R-2 and `docs/SRS.md` FR-1 say "the
  only input the product requires", which holds, and QC-58 now uses those words. "Any shipped
  crate" became "the product's own crates", because a dependency ships in the binary too and the
  phrase read both ways. The answer accepts no read: it makes the entry true and puts every read
  on a list reviewed as code, the pattern the owner confirmed for `checks/deps.allow` (RN-3,
  QC-26). **The measurement the answer left to this fold**, taken 2026-09-19 with nothing fetched
  or re-resolved: `cargo tree -p nozoki-app --target aarch64-apple-darwin -e normal --locked
  --offline` resolves 216 crates; a scan of their sources for the six primitives QC-30's tail
  names finds a textual hit in 17 — `tauri-utils`, `tauri-macros`, `tauri-codegen`, `tauri`,
  `tauri-runtime-wry`, `dirs`, `dirs-sys`, `brotli`, `brotli-decompressor`, `tokio`, `once_cell`,
  `cargo_metadata`, `winnow`, `syn` (two versions), `string_cache` and `objc2` — the answer's own
  count, reproduced. That count is textual and is a ceiling, not the list: it includes lines in
  doc comments (`once_cell`, `string_cache`), modules written for other platforms (`dirs`'s
  `lin.rs`) and code that runs at build time (`tauri-utils`'s `build` modules, the proc-macro
  crates). Sorting those is the work of writing the first `checks/entry-points.allow`, which is
  the delivery tier's, and this note claims no list. **Three things in QC-30's tail are this
  run's own and go beyond the answer's words.** (1) The names `checks/entry-points.sh` and
  `checks/entry-points.allow`: the answer fixed "a reviewed list under `checks/`" and left the
  script and the format to this document, as RN-3's tools are; another name with the same exit
  code satisfies the entry. (2) The scan covers each crate's whole package directory and not
  `src/`: 7 of the 216 crates keep no `src/` — `cssparser-macros`, `fnv`, `markup5ever`,
  `selectors`, `servo_arc` and `web_atoms` hold `lib.rs` at the package root and `swift-rs` holds
  `src-rs/` — so a scanner keyed on `src/` passes them unread, which is the silent pass the
  answer's own failure path forbids ("a crate absent from the local registry cannot be scanned,
  and the check has to fail on that rather than pass"). (3) A listed line no longer found also
  fails the build: a list that only grows stops describing the process, and these records ship to
  readers who will take the list at its word. QC-61's sentence that QC-30 and QC-58 forbid
  `std::env::var` "in any shipped crate, so an off-the-shelf logger fails `checks/structure.sh`"
  was wrong on the item's own reading — a logger is a dependency, and `checks/structure.sh` never
  scanned one — and is re-pointed to QC-30's second half and the allowlist; its conclusion and
  its tail stand. § 9's row 6 and § 10 gain the script. No record moves for § 3.3: ADR-0001 binds
  QC-30 and its decision is untouched. **Fixed in place, under no answer.** The header said every
  command named is one the SDD names "for a product that has no code yet". The product has code —
  `crates/`, `checks/bundle.sh` — and the self-answer run saw the phrase and left it to this fold
  (`self_answer-8.md`, *Seen in the document and not raised*). It is corrected as a defect found
  while walking, small enough to fix where it stands; the clause a reader acts on — a command
  becomes executable in the change that lands its script — is unchanged. **Seen and not raised.**
  `docs/SDD.md` § 4 C-I3 still ends "The record is ADR-0008". The pointer resolves, and the record
  it reaches forwards its reader by its Status line, so no companion is opened on the SDD for it;
  the sentence is the CTO's to move at that document's next run. **What moved beneath this
  document, and what did not.** `git diff --name-only 00c1bc9 HEAD` over the seven inputs —
  `00c1bc9` being v6's own commit — prints `docs/SDD.md` alone (2026-09-19). The SDD's move is 138
  lines, read whole as a diff and every passage cited here opened: § 4 C-I3, § 5 step 4, § 6
  `open-a-folder`'s command bar, § 10 RC-1, § 11 R-8, § Open Questions, RN-45 and RN-46 — one
  subject, the probe's observable, and QC-25 is the one entry that follows. The SRS, the FDR, the
  PRD, the UXD, DESIGN and CONTENT are byte-for-byte what v6 read whole, so they were not re-read
  whole this run and the `Inputs read:` line stands on the statuses as read — every input
  Settled. No `QC` is added, renumbered or reused; § 1 – § 8 move only where named above. *(re:
  header `Version:`, the citing paragraph; QC-14, QC-23, QC-25, QC-30, QC-46, QC-48, QC-49, QC-58,
  QC-61; § 9, § 10; ADR-0008, ADR-0010; source: `docs/trail/architecture/cycle-5.md` § 3.1 –
  § 3.3; `docs/trail/architecture/self_answer-8.md`; `docs/SDD.md` v6 — § 4 C-I3, C-R7, § 10
  RC-1, § 11 R-8, R-11, RN-45, RN-46; `quality_defaults.md` v1.1.0 § The boundary set;
  https://developer.apple.com/documentation/security/protecting-user-data-with-app-sandbox; the
  commits named)*
- **RN-19:** *(v8 — the close of the cycle-6 companion: two checks the first built code showed the
  entries state wider than they can run)* **How the companion came to exist.** As at RN-18, no
  `product-architecture` run opened it: both records were Settled at v7 with no companion on disk,
  and the PM opened one on 2026-09-19 from a post-build review (`nozoki@07beb5b`, `nozoki@422f6d1`)
  with two items, both raised from downstream and each carrying a lean. Both were answered in the
  owner's seat by one unattended `companion-self-answer` run, not by the owner in person
  (`nozoki@bf99e8e`; its reasoning, `docs/trail/architecture/self_answer-9.md`), and as answered
  the companion is `docs/trail/architecture/cycle-6.md`. Every change below names the answer that
  authorizes it, and what this run added beyond an answer's words is marked as this run's own.
  **§ 3.1 → QC-24.** `docs/SDD.md` moved v6 → v7 (`nozoki@c1f8a20`): § 4 C-R7 states the staged
  grant where it said "exactly SM-4's command list", § 3 SM-4 and § 4 C-I3 follow it, and RN-47
  hands QC-24 to this seat in terms — it "still states the whole list and is the Principal
  Architect's to bring into line". QC-24 is re-derived from C-R7 under that document's own rule
  that the § 4 statement wins: transcription, not a call. The defect it closes: read to its words,
  the old entry failed every build before the last slice, and the built test passed only because
  it was not the check the entry stated. One clause is the answer's own and goes beyond C-R7's
  words — a registered set the test cannot read fails the test — on the ground QC-30's tail already
  takes for a crate it cannot scan: a check that reads a set has to say what an unreadable set
  means, and a pass would be the silent one. **Two things in QC-24 are this run's own.** (1) The
  entry still spells the eight commands out, where the answer wrote "the closed list SM-4 names":
  the tail holds the granted set *inside* that list, the delivery loop reads this document for
  verification, and a check whose list sits only in the SDD is checked against a copy nobody
  named. The entry carried the list before; what it drops is "where built" on the last three,
  following SM-4 at v7. If SM-4's list ever moves, SM-4 is upstream and this entry is re-derived.
  (2) The trace to SDD § 11 R-12, which C-R7 itself cites for the pre-`v1.0.0` half. § 10's row
  names the command and not the mechanism, so it stands, though the item named it as owed. **One
  fact a delivery reader needs and no entry states:** the test as built holds two hand-kept
  constants (`crates/nozoki-app/tests/config.rs:L228`, `:L231`, opened this run at
  `nozoki@bf99e8e`), and the capability file grants `allow-open-folder` and `allow-list-tree`
  (`crates/nozoki-app/capabilities/main.json:L5`). The test is green today and does not yet meet
  the re-derived tail. That is the correct reading, not a defect of this revision — the entry
  follows the SDD, and the test follows the entry. How the test comes to read the registered set is
  the delivery tier's to plan (`docs/SDD.md` RN-47); if it finds no way to read it, that comes back
  here as a raised item and is not settled inside a change. **§ 3.2 → QC-61 and § 9.** QC-61's
  rule said `log::set_logger` appears "only in `nozoki-app`" and stated no scope, and the tree
  holds `crates/nozoki-core/tests/failure_log.rs:L52` and `failure_log_kinds.rs:L61`, each
  installing a capturing logger in its own test binary to assert on `nozoki-core`'s warn line —
  the only way a test can observe one, since `set_logger` "may only be called once in the lifetime
  of a program" (https://docs.rs/log/latest/log/fn.set_logger.html). That sentence and the Cargo
  reference's "as a separate crate" were both re-read at source this fold, 2026-09-19, rather than
  transcribed from the answer. The check overreached the property, which is about the shipped process; narrowing
  it relaxes nothing the property protects — the one shipped site is
  `nozoki@a4ab8e6:crates/nozoki-app/src/log_writer.rs:L142` and `crates/nozoki-core/src/` holds none (`grep -rn
  'set_logger\|set_boxed_logger' crates/`, run this fold). **The answer's addition, folded as
  written:** the same script carries rules against which the tree holds a test-target site each —
  QC-2's write rule (`crates/nozoki-core/tests/common/mod.rs:L57`), QC-7's and QC-9's
  `std::process` (`…/common/mod.rs:L11`), QC-13's `std::fs` (`nozoki@a4ab8e6:crates/nozoki-app/tests/config.rs:L11`,
  the very test QC-23, QC-24 and QC-36 name) and QC-30's `std::env::args`
  (`crates/nozoki-core/tests/walk.rs:L66`, the driver `checks/read-only.sh` runs) — every one
  opened this fold and found as cited. Scoping QC-61 alone would have left a cold reader to infer
  the other rules do reach test targets, and the first `checks/structure.sh` written to the words
  would have failed a correct tree on five rules. So the scope is stated once, in § 9's new bullet,
  with the three things it does not do. The self-answer run marked this addition as the one part
  the owner can overturn alone; doing so strikes the § 9 bullet's reach and leaves QC-61's tail
  standing by itself. **Three things there are this run's own drafting**, which the answer left
  to the fold. (1) The other tails — QC-2, QC-7, QC-9, QC-13, QC-30, QC-58 — are not reworded:
  the § 9 bullet names them, one fact keeps one place, and a settled tail is not rewritten where a
  pointer carries it. (2) The bullet says the scope binds "every other rule of the script alike",
  so no rule is left to inference a second time. (3) The `#[path]` escape is a review catch
  because the tree holds no such site to shape a grep rule against — that is the whole reason, and
  a rule becomes owed the day a site appears. No `QC` is added, as the answer ruled. **Seen this
  fold, and breaks nothing:** `nozoki@a4ab8e6:crates/nozoki-app/src/log_writer.rs:L201` calls `fs::write` inside
  `src/`. It sits in `nozoki-app`'s log module, which QC-13 admits by name, and QC-2's write rule
  names `nozoki-core`; so the scope's first not-covered case stays undecided, as the answer left
  it. `checks/structure.sh` is not in the tree (`ls checks/` prints `bundle.sh`, `fixtures`,
  `own-state.sh`, `read-only.sh`, `tests`), so no built script is made wrong by this revision; the
  first one written follows the entries as they now read. **Seen and not raised.** QC-2's tail
  says `checks/read-only.sh` runs "after every IPC command", § 9's row 3 and its layer-3 bullet
  say "the IPC command list", and C-I3 at v7 says "every command the build grants". For any one
  build these name the same commands, so nothing is false and nothing moves. **No record moves.**
  `grep -n 'open_folder\|command list\|set_logger' docs/adr/*.md` finds no whole-list grant and no
  logger: ADR-0002's "the closed command list the host registers" holds under staging, ADR-0001
  binds QC-24 and its decision is untouched, and the list is still closed — what moved is when a
  member of it is granted, which no record decided. **What moved beneath this document, and what
  did not.** `git diff --name-only 170a9c6 HEAD` over the seven inputs — `170a9c6` being v7's own
  commit — prints `docs/SDD.md` alone (2026-09-19). The SDD's move is 60 lines in and 7 out, read
  whole as a diff and every passage cited here opened: the header, § 3 SM-4, § 4 C-R7 and C-I3,
  § 6 S-7's command half and RN-47 — one subject, the staged grant, and QC-24 is the one entry
  that follows. The SRS, the FDR, the PRD, the UXD, DESIGN and CONTENT are byte-for-byte what v7
  stood on, so they were not re-read whole; each one's `Status:` line was re-read this run and
  the `Inputs read:` line stands — every input Settled. No `QC` is added, renumbered or reused;
  § 1 – § 8 and § 10 move only where named above. *(re: header `Version:`; QC-24, QC-61; § 9 row 6
  and its scope bullet; source: `docs/trail/architecture/cycle-6.md` § 3.1, § 3.2;
  `docs/trail/architecture/self_answer-9.md`; `docs/SDD.md` v7 — § 3 SM-4, § 4 C-R7, C-I3, § 6
  S-7, § 11 R-12, § Open Questions, RN-47;
  https://doc.rust-lang.org/cargo/reference/cargo-targets.html;
  https://docs.rs/log/latest/log/fn.set_logger.html; the commits named)*
- **RN-20:** *(v9 — the close of the cycle-7 companion: one verification that closed over
  itself, and one record and one entry that fixed what the probe reads and not when)* **How the
  companion came to exist.** As at RN-18 and RN-19, no `product-architecture` run opened it: both
  records were Settled at v8 with no companion on disk. The PM opened one on 2026-09-20 from a
  post-build review with § 3.1, added § 3.2 on 2026-09-23 from the first CI runs on a
  GitHub-hosted runner, and a `companion-self-answer` run answering the SDD's own companion added
  § 3.3 the same day, while re-reading the CI run that item cites. All three were answered in the
  owner's seat by one unattended `companion-self-answer` run, not by the owner in person
  (`nozoki@b91ba55`; its reasoning, `docs/trail/architecture/self_answer-10.md`), and as answered
  the companion is `docs/trail/architecture/cycle-7.md`. Every change below names the answer that
  authorizes it, and what this run added beyond an answer's words is marked as this run's own.
  **§ 3.1 → QC-3 and its § 10 row.** The defect: QC-3 states a domain — no shipped unit links a
  network transport — and was verified by a diff of the tree against `checks/deps.allow`, which
  proves the two agree and cannot fail on a name the list admits. Measured on the answer's own
  case and re-run this fold at `nozoki@b91ba55`: `bash checks/no-network.sh` exits 0 while
  `checks/deps.allow:L51` holds `crypto-common` and `:L204` holds `tokio`. The tail now states two
  halves, the second being QC-26's same-change review told what question to ask — each added
  name judged against QC-3's domain in the features the lockfile resolves — which is what
  `docs/SDD.md` § 4 C-R6 already says: the allowlist change "is reviewed in the same change", and
  "no shipped unit links a network transport". A correction, not a widening, by this document's
  own preamble: an entry with no nameable verification is not yet an entry, and the domain half
  had none. The features clause is the answer's, on the ground that a name cannot answer the
  question — `tokio` is on the list and at `nozoki@9b36a42` resolves no `net` feature — and that
  QC-3's own first clause, libgit2 without its HTTPS and SSH transports, is a feature condition a
  name diff never sees once a binding lands (no `git2` is in `crates/*/Cargo.toml` today; grep
  run this fold). The one-time review of the 381 names already on the list is the answer's too:
  they passed the diff and carry no record of being reviewed against the domain, so the change
  that first realizes the half reviews them once and records it as code, after which every name
  has passed one review or the other. **One thing in QC-3 is this run's own:** naming `cargo tree
  --offline --locked -e features -i <crate>` in the tail as what the review reads for a crate. The
  answer used the command as evidence; the tail carries it so a reviewer at `development-design`
  has a command to run rather than a question to ponder, and the pnpm side has no counterpart
  named because the answer stated none and this run derives none. QC-26 is not reworded: one
  fact keeps one place, and QC-3's tail points at QC-26 for the moment of the review. The second
  half is a class-2 gate and argues it in the tail — no command judges whether a name is a
  transport. § 10's QC-3 row gains the review beside the script, as the answer ruled, with *the
  change* beside *the tree* under *Runs over*. **§ 3.2 and § 3.3 → QC-25, and ADR-0010 corrected
  in place.** `docs/SDD.md` moved v7 → v8 (`nozoki@9b36a42`): § 4 C-I3 states the bounded window
  and the hosted-runner narrowing, RN-48 records the measurement, and RN-48 hands both to this
  seat in terms — "the Principal Architect's to bring into line". QC-25's tail is re-derived from
  C-I3 at v8 under that document's own rule that the § 4 statement wins: transcription, not a
  call, carrying each of C-I3's failure conditions because each is a way the check goes red — the
  window and its first-ask-all-three pass, the bound the script's and printed, the per-ask
  live-pid check, the control's whole-window `no`, an error on any ask, and the uncovered `yes` →
  `no` case — and C-I3's narrowing sentence as it reads, the Mac's reading for the control left
  unrecorded as C-I3 leaves it. The sentence v8 carried — that the entry asserted nothing about a
  hosted runner, settled by the probe's first CI run — is false since the run happened (GitHub
  Actions run 35797893381, as RN-48 records it) and is gone. The § 10 row does not move:
  `checks/bundle.sh` is still the command, and the script on `main` already holds the window,
  the printed bound, the whole-window control and the per-ask existence check (`nozoki@cf539a4`;
  `checks/bundle.sh:L2`, `:L78-L79`, `:L290-L292`, `:L326-L329`, opened this fold), so the
  re-derived tail is green against the script as built. **The record, and the append-only rule.**
  The answers rule that neither the window nor the narrowing supersedes ADR-0010: the observable
  (`sandbox_check` on the launched main process's pid), its three answers and the negative
  control are what that record fixed, none has moved, the window is a parameter the SDD hands to
  the script ("the bound is the script's to fix and this document states no number"), and the
  narrowing shrinks a claim's scope while the probe still requires all three answers. This run
  reads the same: the record's own line for another record is "replacing the observable", and
  that has not happened. So ADR-0010 takes three prose corrections in place, each dated in the
  record where a reader meets it — the § Decision sentence "the two denials test the wall itself
  rather than a proxy for it", the § Consequences sentence "its green means the wall and not a
  correlate of it", both narrowed to where the unentitled control reports the denials allowed
  with the runner named as the case where the read denial separates nothing; and the closing
  paragraph, which pointed at an Open Questions item SDD v8 closed and removed, replaced by a
  dated note carrying the measurement and pointing at RN-48. The rule this loop runs under says an
  accepted record is never rewritten and that an owner's answer contradicting one produces a
  superseding record; it also says that where the owner meant a correction and not a reversal,
  that is the owner's call and not the run's to guess. The owner's seat made it, in terms, and
  the log has taken corrections of this kind before — the citation pins of v5 (`nozoki@41d8c9f`,
  eight accepted records) and v6 (`nozoki@00c1bc9`, six) — so this fold follows the ruling and
  records here that it did, rather than writing an ADR-0011 that restates ADR-0010 whole with two
  sentences narrowed, which the answer expressly did not order. What the corrections leave
  untouched, stated so the next reader can check it by diff: § Decision's observable, three
  answers and control, § Alternatives ruled out, and § Binds. **Two things there are this run's
  own.** (1) ADR-0010's § Traces to gains one bullet — the SDD at v8 and the two cycle-7 answers
  as the authorization for the dated corrections — so the record states its own provenance and
  does not depend on this note. (2) The closing paragraph's account of *why* the first ask read
  `no` — a read-once probe racing the process's own sandbox initialisation — is RN-48's reading
  and is cited to it, not measured here. **Supporting text the answers pointed at and this fold
  re-pointed:** § 3.2's item cites `docs/SDD_open_issues.md` § 5.1, a file the SDD removed at v8;
  the item as answered is whole at `docs/trail/sdd/cycle-6.md` § 5.1, and that is what ADR-0010's
  new trace cites. **No record lands and none changes status;** the index is a projection of
  number, title, status and date, and none moved, so it is untouched. **What moved beneath this
  document, and what did not.** `git diff --name-only e0edd37 HEAD` over the seven inputs —
  `e0edd37` being v8's own commit — prints `docs/SDD.md` alone (2026-09-23). The SDD's move is 98
  lines in and 28 out, read as a diff and every passage cited here opened: the header, § 4 C-I3,
  § 10 RC-1's *Still unresolved*, § 11 R-8, Open Questions and RN-48 — one subject, when the
  probe reads and what the read denial proves, and QC-25 is the one entry that follows. The SRS,
  the FDR, the PRD, the UXD, DESIGN and CONTENT are byte-for-byte what v8 stood on, so they were
  not re-read whole; each one's `Status:` line was re-read this run and the `Inputs read:` line
  stands — every input Settled. No `QC` is added, renumbered or reused; § 1 – § 9 move only where
  named above. *(re: header `Version:`; QC-3, QC-25; § 10 QC-3 row; ADR-0010 § Decision,
  § Consequences, § Traces to; source: `docs/trail/architecture/cycle-7.md` § 3.1, § 3.2, § 3.3;
  `docs/trail/architecture/self_answer-10.md`; `docs/SDD.md` v8 — § 4 C-R6, C-I3, § 10 RC-1, § 11
  R-8, RN-48; `docs/trail/sdd/cycle-6.md` § 5.1; `checks/deps.allow`; `checks/bundle.sh`;
  `checks/sandbox_probe.rs:L103-L115`; the commits named)*
- **RN-21:** *(v10 — the SDD moved beneath a settled document, and a companion opened on that
  movement is drafted; nothing is folded)* **How the companion came to exist.** As at RN-18 –
  RN-20, no `product-architecture` run opened it: both records were Settled at v9 with no companion
  on disk. A `companion-self-answer` run answering `docs/SDD_open_issues.md` § 1.1 opened it on
  2026-09-23 (`nozoki@a9f1b8a`; its reasoning, `docs/trail/sdd/self_answer-19.md`) with one § 2
  item, proposed and not drafted, on the ground the SDD itself gives: § 12 and § 10 RC-2 name
  QC-25's *exactly* and ADR-0003's as the Principal Architect's to bring into line, and route it
  nowhere. This run — the first `product-architecture` run after it — is what drafted the item. Its
  slot is unfilled, so nothing is folded, no trail cycle is written, and `Status:` reads Draft; the
  item now describes edits that are in the records rather than proposed for them, the shape RN-14
  records for v3. **What moved beneath this document, and what did not.** `git diff 42bd7b5..HEAD
  --stat -- docs/` — `42bd7b5` being v9's own commit — names `docs/SDD.md`, the two companions and
  `docs/trail/sdd/` and nothing else (2026-09-23), so the SRS, the FDR, the PRD, the UXD, DESIGN and
  CONTENT are byte-for-byte what v9 read whole and were not re-read whole; each one's `Status:` line
  was re-read this run. The SDD moved v8 → v12 (`nozoki@e7b2bcd`, `ba63b44`, `6ebdc42`; 556 lines
  in and 44 out), read whole as a diff and every passage cited here opened: the header, § 1's
  read-only bullet, § 2 row 4, § 4 C-R2 and C-I3, § 5 step 4 E-1, § 6 S-1, § 10 RC-1 and RC-2,
  § 12, RN-49 – RN-58, Open Questions. Two subjects: the form of the wall, and the renderer that
  cannot start under it; QC-25 and a new entry follow, and the `Inputs read:` line reads the SDD
  Draft — its companion holds three answered items awaiting a `product-sdd` fold at
  `nozoki@a1d8f2c`. Which entries turn on the Draft, stated per the rule that the header names the
  run's inputs and a record its own: QC-25's rule and ADR-0011 rest on C-R2, which is the owner's
  ruling (`docs/trail/sdd/cycle-8.md` § 5.1) and holds under every answer to that companion's
  § 1.1; QC-62's and ADR-0012's mechanism rests on C-I3's WKWebView-specific clause and each says
  so. **§ 2.1 → QC-25 and ADR-0011.** QC-25 is re-derived from C-R2 under that document's own rule
  that the § 4 statement wins: the obligation states the rule and its named members, and drops
  *exactly*. **Two things in the tail are this run's own.** (1) The two-halves form, on QC-3's
  precedent (RN-20): the rule admits an entitlement "with a record", which makes the script's
  expected set (`checks/bundle.sh:L127-L128`, opened this run) a reviewed list of the kind
  `checks/deps.allow` is, so the machine half is the script's set equality and the review half is
  the widening reviewed as code at `development-design` against the rule's two questions; the
  network clause is not mechanizable — WebKit's own check treats a `mach-lookup` as a stand-in for
  network access (`docs/SDD.md` RN-56), so "under another name" is a judgment — and the tail says
  so. (2) C-I3's v9 scoping of which lines print the bound (SDD RN-50: the pass line and the
  window-ran-out red line; a failed-ask run names what failed and prints none; the control's red
  ends at once; a second uncovered case) is folded into the probe tail: RN-50 marked it "not
  contradicted, only less precise" and raised no item, and a tail being re-derived anyway takes the
  upstream's current words rather than keeping a less precise copy of an earlier one. One fact a
  delivery reader needs and no entry states: `checks/bundle.sh` at v1.5.0 already realizes half (1)
  as the entry now reads — the set equality at `:L73` and `:L127-L187`, the window, the printed
  bound and the control's whole-window rule since `nozoki@cf539a4` — so QC-25 is green against the
  script as built, and half (2) first runs on the change that adds a key. ADR-0011 restates
  ADR-0003 whole with the rule in place of the list — the form ADR-0010 took over ADR-0008 — and
  lands **Proposed**: the owner has not answered the item, a Proposed record is the run's to
  revise, and the reversal it records is the owner's ruling, not this run's reading. So ADR-0003's
  Status line, its index row, and the seven sites that cite it beside QC-25 — QC-2, QC-32, QC-33,
  QC-35, QC-49, QC-58 and § 2's third trust boundary — do not move this run: a record in force is
  cited until it is not, and they move with the Status line on acceptance. The WebKit sources
  ADR-0011 names are transcribed from the SDD and the self-answer reports and were not re-read
  here, and the record says so. **§ 2.1 → QC-62 and ADR-0012.** Which record carries the renderer
  gate was the item's to leave to this seat. Its own record, and not a clause of ADR-0011 — the
  two have different lifecycles: the rule stands if the gate's mechanism is replaced, the gate
  stands if a fourth entitlement is recorded — and not a superseding record over ADR-0010, whose
  observable, three answers and control have not moved and which nothing reverses; C-I3 names
  ADR-0010 alone as its record and claims none for the gate (RN-56), and extending its record line
  to ADR-0012 is the CTO's at the SDD's next fold, which that document's companion § 2.1 *If
  overridden* already anticipates — reported, not raised on the SDD's companion, which this skill
  does not write. QC-62 sits in § 2 beside QC-25 — this run's placement — because the gate exists
  to keep QC-25's green from being read as a bundle a person can use, and a reader of QC-25 needs
  it in the next entry rather than in § 8. Its tail names the script's absence from the tree
  (`ls checks/`, 2026-09-23), the hosted-runner case the SDD leaves open, and the WKWebView-bound
  mechanism, so none of the three is read as covered. § 9's layer-5 row and § 10 gain the script;
  QC-25's § 10 row does not move, the command being the same. **What is not done, and why
  (companion § 2.2).** The owner answered `docs/SDD_open_issues.md` § 1.1 on 2026-09-23 — (a), the
  renderer leaves WKWebView (`nozoki@5176475`) — an authorized decision that outranks every
  document and reverses ADR-0002's renderer half and `docs/fdr.md` PD-29. No record supersedes
  ADR-0002 this run and QC-21 stands as written: the SDD has not decided what the renderer becomes
  (§ 4 C-R1 at v12 still renders in WKWebView; the answer's own last sentence leaves the technology
  and the seams to § 2's re-weighing), and a superseding record restates the runtime decision whole
  with alternatives weighed — a record written now would carry a hole in its § Decision, which the
  recording lens forbids. QC-21 traces to PD-29 and ADR-0002, both in force; PD-29 is the Principal
  PM's to move through the FDR's own run, and QC-21 is re-derived when the FDR and the SDD carry
  the replacement. A delivery reader who meets QC-21 before then finds this note. The call is
  raised as § 2.2 rather than decided silently, because two architects could time the record
  differently. **Nothing else moves.** `docs/acceptance_fdr.md`, `docs/proposal.md` and
  `docs/ux_reference/` bind nothing here, as at RN-17. The project card (RN-6) is unchanged since
  `kensaiapp-opensource@3a960a7`. QC-62 is the one new ID; no `QC` is renumbered or reused; § 1 –
  § 8 move at QC-25 and QC-62 only; no accepted record is edited *(re: header `Status:`,
  `Version:`, `Inputs read:`; QC-25, QC-62; § 9 row 5; § 10 QC-62 row; ADR-0011, ADR-0012, the
  index; source: `docs/architecture_open_issues.md` § 2.1, § 2.2; `docs/SDD.md` v12 — § 1, § 2 row
  4, § 4 C-R1, C-R2, C-I3, § 5 step 4, § 6 S-1, § 10 RC-2, § 12, RN-50, RN-52, RN-56, RN-58, Open
  Questions; `docs/trail/sdd/cycle-8.md` § 5.1; `docs/SDD_open_issues.md` § 1.1 at
  `nozoki@a1d8f2c`; `docs/trail/sdd/self_answer-19.md`, `self_answer-20.md`;
  `checks/bundle.sh:L73`, `:L127-L187`; `docs/fdr.md` PD-29; the commits named)*

- **RN-22:** *(v11 — the cycle-8 fold, and the SDD's re-cut of the shape beneath a settled
  document: what is folded, what is drafted for the owner, and what this run added of its own)*
  **The fold.** The companion at intake (`docs/architecture_open_issues.md` at `nozoki@c2cb01c`)
  held two answered items and one unanswered, and as answered is
  `docs/trail/architecture/cycle-8.md`; both answers were given in the owner's seat by a
  `companion-self-answer` run (`nozoki@c5a2e76`; its reasoning,
  `docs/trail/architecture/self_answer-11.md`). **§ 2.1 → ADR-0011 Accepted, superseding
  ADR-0003;** ADR-0003's Status line reads `Superseded by ADR-0011` and no other line of it moved;
  the index follows; the seven sites that cited ADR-0003 beside QC-25 — QC-2, QC-32, QC-33, QC-35,
  QC-49, QC-58 and § 2's third trust boundary — read ADR-0011, and QC-25's own trace reads it as
  Accepted. Before acceptance, while still Proposed, ADR-0011 took three edits the run owns: its
  paragraph on what the rule cost, and its § Consequences sentence "until the SDD carries the
  replacement", read the replacement as the SDD now carries it and name ADR-0013 and ADR-0014; its
  § Traces to names the trail cycle in place of the live companion, and re-reads the SDD at v13
  (RC-3 § *Retained* keeps the wall and the rule unchanged); its § Binds is the plain list. Nothing
  the owner confirmed — the rule, answers 1–2 restated whole — moved. **QC-62 takes the owner's
  addition** as written: red by construction until the native shell lands, never cleared by an
  entitlement or by skipping the script, the script and its control landing with the native shell
  or after it. **ADR-0012 is not accepted this run and stays Proposed.** The § 2.1 confirm accepts
  it as drafted; the same seat's later reading, given while answering the SDD's companion, is that
  it "may also move under the RC-3 re-derivation, now raised at
  `docs/architecture_open_issues.md` § 2.3, and the index row follows it wherever it goes"
  (`docs/trail/sdd/cycle-9.md` § 2.3, the owner's addition, `nozoki@18ad26d`) — and it has moved:
  C-I3 at v13 fixes the control as `checks/fixtures/idle-shell` ("a single-process shell has no
  renderer build to remove") and the observable as `open_folder`'s call with the panel presented,
  and names this record as the one "whose mechanism, control and observable's name are re-derived
  from this clause as it now reads" (RN-61). A record still at Proposed is the run's to revise, so
  ADR-0012 is revised against C-I3 at v13 — the control, the observable, the frames re-measured on
  the first native bundle, the owner's addition in its § Decision — and its acceptance rides § 2.3
  with the four records below, so that an accepted record never takes a mechanism sentence that a
  confirmed item is still open on. The § 2.1 answer's residue — ADR-0012's acceptance — re-enters
  the companion as part of the drafted § 2.3, per the loop's rule that an answered item never
  survives the drop. **§ 2.2 → nothing lands, as confirmed**, and its condition is met: the SDD
  carries the replacement (v13, § 10 RC-3) and the FDR closed at v8 with PD-29 moved
  (`docs/trail/fdr/cycle-5.md` § 2.1; `nozoki@5003426`), which is what QC-21's re-derivation
  waited on (RN-21). **What moved beneath this document, and what did not.** `git diff --stat
  bd98225..HEAD -- docs/` — `bd98225` being v10's own commit — names `docs/SDD.md` (run 12,
  `nozoki@b236e7b`, v12 → v13), `docs/fdr.md` (v6 → v8, `nozoki@be1a821`, `nozoki@5003426`), the
  companions and the trails, and nothing else (2026-09-23); the SRS, the PRD, the UXD, DESIGN and
  CONTENT were re-read whole this run and are what v10 read — every one Settled — so the `Inputs
  read:` line stands, the SDD Draft: its companion holds one answered item (§ 2.3 — C-I3's wording
  and two record lines) awaiting a `product-sdd` fold, and nothing here turns on it (the house rule
  for a Draft input is derive and record, never halt — `unsettled_inputs.md`). The SDD's move is
  the re-cut: § 2's shape redone under the owner's (a), § 3's units and seams, § 4 C-R1, C-R6,
  C-R7, C-I3, C-I6, C-D3, § 9, § 10 RC-3, RN-59 – RN-63 — every passage cited below opened. The
  FDR's move is PD-29 (the view replaced once, before any public release, and not again) and two
  re-pointed locators; no other rule or decision moved (`docs/fdr.md` RN-31, RN-32). **What is
  drafted for the owner's confirm, and why now (companion § 2.3).** The item was raised proposed
  and not drafted, by a run holding no posture on these records; the shape this document has taken
  twice before — v3 (RN-14) and v10 (RN-21) — is that the first `product-architecture` run after
  such an item drafts it at Proposed and leaves the slot to the owner, and the owner's § 2.2 answer
  named the SDD carrying the replacement as the moment a record lands. It does. **Four records at
  Proposed, each restating whole the record it supersedes, none accepted, the superseded four
  untouched until acceptance:** ADR-0013 (the sandboxed single-process read pipeline — the shape,
  `SM-4` as a C-ABI seam, the promise held by the process's entitlements; supersedes ADR-0001),
  ADR-0014 (AppKit in Swift, no web engine of any kind, the view's language weighed against
  `objc2` and SwiftUI; supersedes ADR-0002), ADR-0015 (Markdown as a `MarkdownDocument`, the three
  walls redrawn as the check, the document as data and the decoder fed by the check alone;
  supersedes ADR-0006), ADR-0016 (the unit set — `nozoki-core`, `nozoki-bridge`, `nozoki-mac`,
  `checks/`; supersedes ADR-0009, its reconstructed marking kept for the two readings still this
  seat's). Four rather than fewer because the four decisions have four reversal costs: moving the
  view into a second process costs the bridge re-wired as IPC; replacing the view technology costs
  every surface; an out-of-process decoder is a second process; and a unit split is a workspace
  edit — a record that bundled them would give one lifecycle to four (§ 9 TO-1, TO-4, TO-6;
  ADR-0016 § Consequences). **The entries written against the previous shape are re-derived from
  §§ 2–4 at v13** under the SDD's own rule that the § 4 statement wins and the NFDR entry is
  re-derived (§ 4, opening note) — the rule this document followed at v5 – v10 — and each traces to
  the Proposed record *and* to the accepted one it supersedes, the form RN-21 fixed for QC-25, so a
  cold reader sees both the record in force and the record the entry is written against: § 1's
  opening paragraph; QC-1 (the shell holds no I/O — a scan, not a boundary); QC-8 (`nozoki-mac`'s
  imports, no package dependency, `surfaces` never calling `SM-4`); QC-9 (no Apple framework, no
  `unsafe` in the core); QC-11 (`highlighter` among the parts, the second stated edge); QC-13
  (`nozoki-bridge`: delegation, `unsafe`, the generated header, the sanitizer); QC-14, QC-15,
  QC-16, QC-17 (two composition roots); QC-18, QC-19 (the S-10 diff over `nozoki-mac`), QC-20;
  QC-21 (the non-invariant re-stated on PD-29 at v8); § 2's boundaries and threat classes; QC-22
  (the hostile fixture as a `MarkdownDocument`); QC-23 (no web engine, in place of a CSP the shape
  cannot declare); QC-24 (the bridge's export set, in place of the capability file — the staged
  form RN-19 fixed carried across unchanged in kind); QC-26 (no Swift dependency, no
  `Package.resolved`); QC-27 (`pnpm audit` leaves); QC-30 (`-p nozoki-bridge`; the shell in
  half (1)); QC-34 (the shell's reach: C-R7's forbidden set, and its own caveat that the scan is
  the check and the sentence is the rule); QC-36, QC-37 (`asset_bytes` and the decoder), QC-40,
  QC-41, QC-47, QC-51, QC-53, QC-55 (one process; no font; no second executable), QC-58, QC-59
  (the pin reads the exports), QC-61 (the bridge's log writer), QC-62 (above); § 9 whole; § 10
  whole. QC-6 gains `asset_bytes` re-running the check and SM-7's one-implementation clause; QC-3
  gains `no-network.sh`'s `Package.swift` half from C-I3, and the historical pnpm count is marked
  as leaving. **What this run added beyond a direct reading of the upstream text, each marked in
  its entry:** (1) three symbols for `checks/view.sh` — `CommandLine.arguments`,
  `ProcessInfo.processInfo.arguments`, `ProcessInfo.processInfo.environment` — realizing C-R3's
  *Violated by* ("accepts a path by argument, environment or configuration file"), which C-R7's
  scan does not name (QC-30 half (1)); (2) a `view.sh` rule that a `nozoki_` symbol is called
  from `mac-shell`'s sources and from no file of `surfaces`, realizing SM-8's "a surface never
  reaches the bridge" (QC-17); (3) `NSAlert`, the user-notification API and modal presentation as
  the symbols `view.sh` refuses, realizing `surfaces`' "Must not own: a dialog, a toast, a
  notification" (QC-51); (4) `checks/bundle.sh` reading no second executable, no font and nothing
  of `checks/` under `Contents/`, realizing C-R1's one-process clause and the "Two libraries, one
  executable, one bundle" paragraph (QC-14, QC-55); (5) `checks/view.sh`'s scope stated in § 9
  the way `structure.sh`'s is — `Sources/` in, `Tests/` out — from C-R7's own path. Each is a
  realization of an obligation whose source names the obligation and not the symbol, the way
  RN-3's tools are; another symbol with the same exit code satisfies the same entry. **What does
  not move, and why.** ADR-0004, ADR-0005, ADR-0007, ADR-0010 and ADR-0011 stand: RC-3 § *Retained*
  keeps SM-1 – SM-3 and SM-6, the wall, `checks/bundle.sh` whole and TO-2, TO-3, TO-9. Two grounds
  under accepted records are now dated readings and are recorded here rather than edited, RN-12's
  form: ADR-0010's "no WKWebView driver on macOS" is why no harness drove the *previous* renderer,
  and the reason no harness drives the AppKit views is C-I3's and TO-7's — the accessibility surface
  UX-A1 disclaims, and an Xcode project this product does not keep; and ADR-0010's "the closed IPC
  command list" is `SM-4`'s function list now, the same closed list across a different seam. Neither
  reverses ADR-0010's decision — the harness through `nozoki-core` in-process, the probe on every
  build reading the operating system's report — and C-I3 still names ADR-0010 as its record. RN-3's
  tool list names `cargo test -p nozoki-app --test config`, a test the shape retires with
  `tauri.conf.json` and the capability file; the note is dated history and stands. RN-7's "Layer 4
  is present, on Vitest Browser Mode with Playwright" and its TypeScript-packet clauses are history
  as of this revision, and the departure list stands for the Rust packet as written. The doctrine
  cites move under no answer: `languages/rust/testing.md` reads v1.0.1 and `toolchain.md` v1.1.1
  (each read whole this run, 2026-09-23; neither moved a layer or a rule this document cites), and
  the TypeScript packet leaves the citing paragraph with `nozoki-ui`. **One item is raised,
  companion § 1.1, and one entry names it rather than deciding it:** `docs/SDD.md` § 3 at v13 has
  `folder-model` own `FileView` — whose content carries `highlighter`'s spans or a
  `MarkdownDocument` — and `core-bridge` "must not own read logic — every function delegates and
  formats", while `folder-model`'s "Must not own" still lists "Rendering" and QC-10 forbids
  `folder-model` importing `markdown-renderer`; which unit invokes `markdown-renderer` and
  `highlighter` is stated nowhere, and two architects reading the same section would place it
  differently, so it is routed to the SDD's seat through the companion and QC-10 stands as written
  with the gap named. **Seen and not raised, each the SDD's to move at its next run:** `folder-model`'s
  "Must not own" still names "The Tauri runtime" (§ 3, the parts table); RN-8 still says SVG would
  be "served on the same `nozoki-asset` scheme", a mechanism RC-3 retired, while C-D3 carries the
  current reopening condition; and S-3's command half tests `asset_bytes` under `cargo test -p
  nozoki-core --test markdown` where § 3 places `asset_bytes` in `core-bridge` — QC-37 cites the
  command as the SDD states it. **Owed outside this document, named so the fold is not read as
  complete:** the project card's `Languages:` line and test command (§ 8; SDD RN-60);
  `README.md:L46-L51`'s stack and proof sentences (SDD RN-59); `docs/DESIGN.md`'s realisation
  sentence (SDD RN-62). **The tree.** `crates/nozoki-app`, `nozoki-ui` and `checks/` as v10 read
  them (`ls`, 2026-09-23; no `nozoki-mac`, no `crates/nozoki-bridge`, no `checks/view.sh`,
  `renderer.sh` or `idle-shell`), so every entry that names the new units is red against it until
  the change that lands the native shell — the reading RN-18 fixed for QC-25 against
  `checks/bundle.sh` at v7, applied to the whole shape. No `QC` is added, renumbered or reused;
  no accepted record is edited beyond ADR-0003's Status line; two items — this note wrote *three*,
  corrected at v12 on the owner's addition (RN-23) — await the owner and
  `Status:` is Draft *(re: header `Status:`, `Version:`, `Inputs read:`; § 1 – § 3, § 8 – § 10 as
  listed; ADR-0003, ADR-0011, ADR-0012, ADR-0013 – ADR-0016, the index; source:
  `docs/trail/architecture/cycle-8.md` §§ 2.1 – 2.3; `docs/trail/architecture/self_answer-11.md`;
  `docs/SDD.md` v13 — § 2, § 3, § 4 C-R1, C-R2, C-R3, C-R6, C-R7, C-I3, C-I6, C-D3, § 6 S-1 – S-3,
  S-7, S-8, S-10, § 9 TO-1, TO-4, TO-5, TO-6, TO-7, § 10 RC-2, RC-3, § 11 R-11, R-13, § 12, RN-53,
  RN-56, RN-59 – RN-63, Open Questions; `docs/trail/sdd/cycle-9.md` §§ 1.1, 2.3; `docs/fdr.md` v8
  — PD-29, RN-31, RN-32; `docs/trail/fdr/cycle-5.md` § 2.1; `Cargo.toml`;
  `languages/rust/testing.md` v1.0.1, `toolchain.md` v1.1.1; `languages/README.md` § The
  resolution chain; `<CORE>/doctrine/engineering/languages/` listing; the commits named)*
- **RN-23:** *(v12 — the close: the cycle-9 fold, and the SDD moved v13 → v14 beneath this
  document)* **The fold.** The companion at intake (`docs/architecture_open_issues.md` at
  `nozoki@cddc286`) held two items, both answered in the owner's seat by a `companion-self-answer`
  run (its reasoning, `docs/trail/architecture/self_answer-12.md`), and as answered is
  `docs/trail/architecture/cycle-9.md`. **§ 2.3 → ADR-0013, ADR-0014, ADR-0015 and ADR-0016
  Accepted, superseding ADR-0001, ADR-0002, ADR-0006 and ADR-0009;** each superseded record's
  Status line reads `Superseded by ADR-00NN` and no other line of it moved; **ADR-0012 Accepted**;
  the index follows. Before acceptance, while still Proposed, each of the five took one edit the
  run owns: its § Traces to bullet names the trail cycle and the confirm in place of the live
  companion, and reads the SDD at v14 for the acceptance — v14's one move in § 3 (below) sits
  inside `nozoki-core` and touches no sentence of the four; and the four superseding records'
  § Binds is the plain list their "on acceptance" halves named. Every entry that traced to *the
  Proposed record and the accepted one it supersedes* (RN-22's form) traces to the accepted record
  alone: § 1's opening paragraph; QC-1, QC-6, QC-8, QC-9, QC-11 – QC-17, QC-20 – QC-24, QC-26,
  QC-30, QC-32, QC-34, QC-36, QC-37, QC-55, QC-61, QC-62. **The owner's addition**, as written:
  QC-2's tail read `checks/read-only.sh` "after every IPC command" and reads "after every function
  the build exports (C-R7), driven through `SM-5`" — C-I3's own words; QC-30's boundary set listed
  "the renderer's IPC commands and asset requests" and lists "the `SM-4` functions the shell
  calls, `asset_bytes` among them" — RN-22 counted QC-30 as re-derived and missed the member; and
  the count — v11's note and RN-22 said three items awaited the owner where the companion carried
  two — is corrected in both, dated, the way RN-20 corrected the header at v9. **§ 1.1 → QC-10
  transcribed.** The answer chose reading (a) and routed the sentence to the SDD's seat, saying
  QC-10 stays until the SDD folds its § 2.4. The SDD's run 13 drafted (a) into § 3 at v14 —
  `folder-model`'s *Owns* gains the fill of the open `FileView`, its *Must not own* reads
  "Drawing" and "Any Apple framework" where it read "Rendering" and "The Tauri runtime", and the
  units paragraph gains the edge (SDD RN-64) — and the owner confirmed it on that document's
  companion (`nozoki@705d306`; `docs/trail/sdd/self_answer-22.md` § 2.4) with one addition and the
  words "No § 3 text changes; only the stated reason does". The fold that drops the SDD's item is
  still owed to `product-sdd`, and it moves no sentence QC-10 transcribes, so QC-10 is transcribed
  now rather than left contradicting § 3 as it reads — the rule this document has followed since
  v5 (the § 4 statement wins; the entries follow the SDD): `folder-model` may import
  `markdown-renderer` and `highlighter`; its exclusion of `markdown-renderer` is retired; its
  exclusions of the libgit2 binding, `git-reader`'s adapter and `own-state` stand; QC-11 does not
  move and its trace names the third edge as QC-10's. The owner's addition on the SDD's companion
  — "I/O of any kind" means I/O the model performs itself, the renderer's containment call
  reaching the filesystem through `fs-reader` over `SM-7` — is carried in QC-10's text, and
  QC-15's ownership already says it. ADR-0016 does not move: it places every part involved in
  `nozoki-core` under either reading. **What moved beneath this document.** `git diff --stat
  38aaa48..HEAD -- docs/` — `38aaa48` being v11's own commit — names `docs/SDD.md` (run 13,
  `nozoki@2739007`, v13 → v14), the two companions and the trails, and nothing else (2026-09-23);
  the SRS (v12), the FDR (v8), the PRD, the UXD, DESIGN and CONTENT are what v11 read, every one
  Settled, so the `Inputs read:` line stands, the SDD Draft — its companion holds § 2.4 answered,
  awaiting `product-sdd`. The SDD's v14 moves, each opened: § 3 `folder-model` and the units
  edge (QC-10, above); § 4 C-R2's and C-I3's record lines, which name their record and state no
  status word — nothing here cites a status word from the SDD, so nothing moves; § 6 S-3's
  command half, which tests `asset_bytes` under `cargo test --locked -p nozoki-bridge --test
  asset_bytes` — the bridge's crate, where § 3 places the function, the defect RN-22 saw and left
  to that run — so QC-6's and QC-37's tails, § 9's layer-2 row and layer-5 bullet, and § 10's
  QC-6 and QC-37 rows follow, the `MarkdownDocument` assertions staying under `--test markdown`;
  § 12's count of the log and its QC-10 sentence, which this revision makes true. **What this
  run added beyond a direct reading, marked in its entries:** QC-16 traces to ADR-0016, the record
  whose § Binds names it — the pair was navigable one way only; QC-31 reads ADR-0015, which
  carries ADR-0006's containment half whole, where it read the superseded record. **Seen and not
  raised:** ADR-0015's four-format claim rests on Apple's type-level pages and the decode is S-3's
  `swift test` case's to prove — named in the record's acceptance bullet, covered by the
  placeholder if it fails, no wall moving (`docs/trail/architecture/self_answer-12.md`, Header);
  the project card moved once past § 8's `3a960a7` — `kensaiapp-opensource@defe740`, the
  `Language roots:` line — touching neither line § 8 states, so § 8's pin moves and its sentence
  stands; RN-3's and RN-7's dated history stand as RN-22 left them. **The tree.**
  `crates/nozoki-app`, `nozoki-ui` and `checks/` as v11 read them (`ls`, 2026-09-23), so every
  entry naming the new units is red against it until the change that lands the native shell
  (§ 1). No `QC` is added, renumbered or reused; no accepted record is edited beyond the four
  Status lines; nothing is left for the owner, `docs/architecture_open_issues.md` is removed and
  `Status:` is Settled *(re: header `Status:`, `Version:`; § 1 opening; QC-2, QC-6, QC-10, QC-11,
  QC-16, QC-21, QC-30, QC-31, QC-37, QC-62 and the trace tags listed; § 8; § 9 row 2 and the
  layer-5 bullet; § 10 rows QC-6, QC-37; RN-22's count; ADR-0001, ADR-0002, ADR-0006, ADR-0009,
  ADR-0012 – ADR-0016, the index; source: `docs/trail/architecture/cycle-9.md` §§ 1.1, 2.3;
  `docs/trail/architecture/self_answer-12.md`; `docs/SDD.md` v14 — § 3 `folder-model`,
  `core-bridge`, the units paragraph, SM-5, SM-7; § 4 C-R2, C-I3; § 6 S-3; § 12; RN-64;
  `docs/trail/sdd/cycle-10.md` § 2.3; `docs/trail/sdd/self_answer-22.md` § 2.4; `nozoki@705d306`;
  `kensaiapp-opensource@defe740`; the commits named)*
- **RN-24:** *(v13 — the close of the cycle-10 companion: one entry the SDD's fold left behind,
  and four things the built native shell and the moved card showed the records state wrong)*
  **How the companion came to exist.** As at RN-18 – RN-21, no `product-architecture` run opened
  it: both records were Settled at v12 with no companion on disk. The PM opened it on 2026-09-23
  after the native shell landed (`nozoki@196a505`) with four items raised from downstream —
  §§ 3.1 – 3.4 — and a `companion-self-answer` run answering the SDD's own companion added § 2.1
  the same day (`nozoki@a8b662e`), drafted and not written into any record. All five were
  answered in the owner's seat by one unattended `companion-self-answer` run, not by the owner in
  person (`nozoki@5c4bd9a`; its reasoning, `docs/trail/architecture/self_answer-13.md`), and as
  answered the companion is `docs/trail/architecture/cycle-10.md`. Every change below names the
  answer that authorizes it, and what this run added beyond an answer's words is marked as this
  run's own. **§ 2.1 → QC-24, QC-1, QC-2, QC-59 and § 10.** `docs/SDD.md` moved v14 → v16
  beneath this document (`nozoki@1f4961a`, `nozoki@097ef33`; `git diff 1dfdd86..HEAD --stat --
  docs/SDD.md`: 197 lines, read whole as a diff and every passage cited here opened). At v16 § 4
  C-R7 holds the export set inside `SM-4`'s list *and* `nozoki_free`, from `v1.0.0` the list
  whole and `nozoki_free`, states that `nozoki_free` is no command and admits no second plumbing
  export until the slice that needs one raises it; `SM-4`'s Down cell names `nozoki_free` beside
  the list and not on it; C-I3's *Violated by* carries the command parenthesis; C-I6's pin takes
  the same set; S-1's and S-11's command halves follow (SDD RN-66, on the owner's confirm at
  `docs/trail/sdd/cycle-12.md` § 5.1). QC-24 is re-derived from C-R7 at v16 under that document's
  own rule that the § 4 statement wins — transcription, not a call — and the defect it closes is
  measured: the bridge on `main` exports `nozoki_free` (`crates/nozoki-bridge/src/exports.rs:L61`)
  and its test admits it (`crates/nozoki-bridge/tests/exports.rs:L17`), which QC-24 as it read
  refused. The answer's four additions, folded as written: QC-2's tail, whose "every function the
  build exports" reached `nozoki_free` on its own words where the drafted item claimed it did not,
  takes C-I3's carve-out — a command is a call on `SM-4`'s list, driven through `SM-5`, and
  `nozoki_free` never reaches the model; QC-1's "only channel to the core" names `nozoki_free`
  beside the list, as `SM-4`'s Down cell does; QC-59's pin reads the list and `nozoki_free`, as
  C-I6 does; QC-24's trace reads C-R7 at v16. QC-30 does not move — its boundary set is what the
  process reads, and `nozoki_free` reads nothing, the SDD's own ground for placing it beside the
  list. **Two things here are this run's own.** (1) QC-24 carries C-R7's no-second-export
  sentence in the obligation, not only in the trace: a later plumbing export would pass the
  tail's set equality while sitting outside the held set, which is the stale case C-R7 names, and
  an entry that binds the set has to say what a second export means. (2) QC-24's trace gains
  ADR-0016, whose units table already names `nozoki_free` apart from the list (§ Decision, the
  `nozoki-bridge` row) — the record said it before the entry did, and the pair was navigable one
  way only. No record moves: ADR-0013 names `nozoki_free` after the nine and ADR-0016 lists it
  separately, so the log already held what the entry now holds. **§ 3.1 → QC-13.** The item's
  framing was partly wrong and the answer says so: QC-13 did not leave open whether "may import"
  is the whole list — § 1.2's preamble says it is — so under the one reading available the bridge
  as built breaks the entry (`crates/nozoki-bridge/Cargo.toml` declares `log`, `serde`,
  `serde_json` and `libc` beside `nozoki-core`, each on `checks/deps.allow`), and QC-13 read that
  way contradicts QC-61, which requires every shipped Rust crate to depend on `log`. A correction
  of two settled entries that disagree, not a widening. Of the lean's two forms the answer chose
  *points at the list*, QC-9's form for `nozoki-core`, on the ground that four names in the entry
  would be a hand-kept copy of the manifest, false at the bridge's next reviewed dependency; every
  other clause stands. **One thing here is this run's own:** the tail's sentence that the
  allowlist admits a crate to the workspace and not to a purpose, so a listed parser or grammar
  engine imported to put read logic in the bridge is the delegation review's catch — the answer
  named the review as the catch, and the tail says why the list alone cannot be. **§ 3.2 → § 9's
  scope bullet.** The tree holds a build script — `crates/nozoki-bridge/build.rs` reads and writes
  with `std::fs` (`:L11`, `:L25`, `:L28-L30`) and reads `CARGO_MANIFEST_DIR` (`:L18`), each opened
  this fold — and § 9 as it read named `build.rs` as *not excluded*, written when no build script
  existed to shape a rule against (RN-19). The scope's own ground decides it: every property the
  script holds is about the process an adopter runs, and Cargo compiles and runs a build script
  "just before a package is built" — re-read at source this fold, 2026-09-23, rather than
  transcribed from the answer — so a build script is not in that process, the ground QC-30's
  second half already takes for a dependency's root `build.rs`. The exclusion covers every rule of
  the script, so QC-13's `std::fs` rule and QC-30's and QC-58's first half clear the file too, and
  no tail is reworded — one fact keeps one place, RN-19's form. The answer's additions, folded as
  written: the `OUT_DIR` `include!` case named as a review catch beside `#[path]`, because no such
  site exists (`grep -rn OUT_DIR crates/` prints nothing, 2026-09-23); `benches/` and `examples/`
  not excluded until one occurs. **Seen and not raised, the answer's own note carried here:**
  `build.rs` writes the header to `<repo>/target/include/` (`:L19`, `:L30`), outside the `OUT_DIR`
  the Cargo reference says a script "should not modify any files outside of" — a delivery-code
  matter under a doctrine convention, which no entry here states and this seat does not mint.
  **§ 3.3 → § 8 and RN-6.** § 8 was false against the card, measured this fold: the card reads
  `cargo test --workspace --locked && swift test --package-path nozoki-mac` and `Languages: Rust,
  Swift, Shell` (`system/projects/nozoki/project.md:L7-L8`, in the managing instance). The
  answer's addition: the card moved twice since `defe740`, not once — `kensaiapp-opensource@5b27023`
  and `ec80077`, both 2026-09-23 (`git log -- system/projects/nozoki/project.md`) — so RN-6's
  pinned history gains both and § 8 pins `ec80077`, the commit the fold read; the *owed a move*
  sentence is gone because the move happened. Decided with § 3.4: RN-7's step-1 sentence naming
  the TypeScript packet for the renderer takes a dated parenthesis and is history. **§ 3.4 → § 9,
  RN-7 and ADR-0016.** The premise is false: the registry carries `languages/swift/` since
  `kensaiapp-dev@3ab2e8553` (18:46 on 2026-09-23, merged; each file read whole this fold at the
  version § 9 cites), and `docs/nfdr.md` § 9 and ADR-0016 said none existed — true at 15:13 the
  same day, when v12 closed and the record was accepted (`nozoki@1dfdd86`), and false three hours
  later. § 9's preamble reads the packet as `nozoki-mac`'s tooling, resolving at step 1 from the
  card's line as the Rust packet does, and its previous reading is marked as history. **Where
  `nozoki-mac` stands against the Swift packet, one verdict per point, each the answer's and each
  stated in § 9's new bullet.** *(1) Framework — followed, not a departure.* The item's supporting
  text was partly wrong and the answer reports it: the packet keeps a product's existing XCTest
  tests — "XCTest tests a product already has stay as they are" (`testing.md` § One framework) —
  and only a new test is Swift Testing; the four test files on `main` are XCTest (`grep -rl
  'import XCTest' nozoki-mac/Tests`, run this fold, and no `import Testing`). Whether the toolchain
  CI builds with runs Swift Testing is not known; the change that writes the first new test finds
  out, and § 9 records a departure with the measurement if it cannot. *(2), (3) and (5) — departed
  from, as one decision, with the flip named.* The `6.2` tools version, the `.binaryTarget`
  artifact bundle and `.treatAllWarnings(as:)` each need `PackageDescription` 6.2 — the packet
  states it of the manifest settings ("First available in PackageDescription 6.2", `toolchain.md`
  § Toolchain version) and of the artifact route (SE-0482, "Implemented (Swift 6.2)", § Linking a
  C library built by another toolchain), and `nozoki-mac/Package.swift` declares `5.9` (`:L1`),
  links the bridge as a system library with a `-L` flag (`:L19`, `:L26-L29`) and sets no warnings
  level. The one CI image this product runs, `macos-14` (`.github/workflows/ci.yml:L18`; a
  `release.yml:L18` cited beside it through v13 named a file this repository has never held,
  struck at v14 — RN-25), offers Xcode 15.0.1 – 16.2 with 15.4 the default (the runner-images readme,
  re-read this fold, 2026-09-23), and Swift 6.2 was released on 2025-09-15 (swift.org, read this
  fold). **What this run does not claim, stated so the bullet is read at its measure:** which
  Swift each of those Xcodes carries. Four fetches of Apple's and swift.org's pages returned no
  line pairing Xcode 16.2 with a Swift version, so the bullet cites the three facts it has and
  names the check that settles the fourth — the first CI log that builds `nozoki-mac` prints the
  toolchain, and if it shows 6.2 or later the departure's ground is gone and the three are adopted
  then. The answer weighed *adopt and move the runner* and did not take it: the records bind no
  runner, so choosing one is not this document's decision, the departure costs nothing the day
  the runner moves, and it commits no contributor to a newer Xcode. The flip carries QC-25's
  re-measurement because the hosted-runner narrowing was taken on `macos-14` (SDD RN-48), and a
  new image is that measurement's stale case. *(4) Test-target names — adopted.* `<Target><Layer>Tests`
  (`layout.md` § Naming) needs no toolchain; `SurfacesTests` and `ShellTests`
  (`nozoki-mac/Package.swift:L34-L35`) predate the packet, nothing in the records grounds them, and
  a packet outranks the code's own habits (`languages/README.md` § Precedence). Which layer word
  each takes is the delivery tier's placement under § 9's rows, not this document's. *Also owed by
  the packet, and recorded:* the toolchain version CI builds `nozoki-mac` with, where no
  `.swift-version` pin exists — none does (`ls -a`, 2026-09-23) — has no value, because CI does not
  build `nozoki-mac` (`ci.yml` at `nozoki@99e2bac` still builds the Tauri shape, `:L33-L44`); the
  first CI log that builds it supplies one. **The bullet is held in § 9 and not minted as a `QC`**,
  RN-15's form for the layer-5 rule: it binds the test strategy's own realization, which § 9 owns;
  a reader who needs it as an entry may say so on the next companion. Its review half is a
  class-2 gate and argues it in place — no command reads which toolchain CI builds with until CI
  builds `nozoki-mac`. **ADR-0016, and the append-only rule.** The answer rules that the moved
  premise corrects the record and does not reverse it: the four units, the frame inside
  `nozoki-mac/`, and "declares no package dependency" all stand — the artifact-bundle route, if
  adopted, stays inside `nozoki-mac` and declares nothing — and only a *because* clause in
  § Decision and one consequence clause go false. This run reads the same: the record's
  observable, its units table, its alternatives and its binds have not moved, which is RN-20's
  case for ADR-0010 and not RN-18's for ADR-0008. So ADR-0016 takes two prose corrections in
  place, each dated where a reader meets it — the § Decision clause "laid out by the slice that
  lands it, because no Swift packet exists in the organisation's language registry", and the
  § Consequences clause "a Swift package with no language packet behind it, so its layout and its
  testing tool are this product's own to record" — and its § Traces to gains one bullet stating
  that provenance, so the record does not depend on this note; the bullet the record already
  carried, listing the registry without Swift, stands as the dated measurement it was. What the
  corrections do not touch, so the next reader can check it by diff: § Decision's four units and
  their map, the frame's location, "declares no package dependency"; § Alternatives ruled out;
  § Binds. No record lands and none changes status; the index is a projection of number, title,
  status and date, none moved, so it is untouched. **Fixed in place, under no answer.** § 1's
  opening paragraph read the tree as holding the previous shape alone and every entry naming
  `nozoki-bridge` or `nozoki-mac` as red until the native shell landed. It landed
  (`nozoki@99e2bac`, 22:42 on 2026-09-23; `ls crates/` prints `nozoki-app`, `nozoki-bridge`,
  `nozoki-core`, and `nozoki-mac` and `nozoki-ui` both stand at the root), so the tree holds both
  shapes until the Tauri build's removal, and the paragraph says so, dated — a defect found while
  walking, the way RN-18 corrected the header's "no code yet". The header's citing paragraph names
  the Swift packet beside the Rust one, and reads the Rust packet's `layout.md` and
  `quality_gates.md` at v1.1.1 (`kensaiapp-dev@2ec1c46d9`, 2026-09-05, a wording change that
  grounds each file's claims without naming a product; no rule this document cites moved). **What
  moved beneath this document, and what did not.** `git diff --stat 1dfdd86..HEAD -- docs/` —
  `1dfdd86` being v12's own commit — names `docs/SDD.md`, this document's companion and trail, and
  the SDD's companion and trail, and nothing else (2026-09-23). The SDD's two moves: v15 (run 14)
  confirms § 3's `FileView` fill and corrects RN-64's *because* on the owner's addition, gives S-3
  `folder-model` and `SM-5` in *Rests on* and one `select_file` case in its command half, and
  re-aims § 12's pointer at the retired companion (SDD RN-65) — QC-10 already carries the
  corrected reason and no entry moves; v16 (run 15) is the two subjects above — `nozoki_free`
  beside the list, and the Swift-frame paragraph on the packet, with RC-3's *Still unresolved* and
  RN-60 taking dated parentheses (SDD RN-66). The SDD is Settled, its companion removed, so the
  `Inputs read:` line reads it Settled where v12 read it Draft. The SRS (v12), the FDR (v8), the
  PRD (v15), the UXD (v10), DESIGN (v8) and CONTENT (v6) are byte-for-byte what v12 read whole;
  each one's `Status:` line was re-read this run and every one is Settled.
  `docs/acceptance_fdr.md`, `docs/proposal.md` and `docs/ux_reference/` bind nothing here, as at
  RN-21. The doctrine cites: `quality_defaults.md` 1.1.0, `arch_defaults.md` 2.0.0,
  `testing_doctrine.md` 2.2.0, `languages/README.md` 2.5.0 (§ The resolution chain and
  § Precedence read this fold, as cited), the Rust packet as the header now cites it, and the
  Swift packet at `README.md` 1.0.1, `testing.md` 1.1.0, `layout.md` 1.0.0, `toolchain.md` 1.1.0,
  `quality_gates.md` 1.1.0 (each read 2026-09-23). No `QC` is added, renumbered or reused; § 1 –
  § 8 and § 10 move only where named above; no accepted record is edited beyond ADR-0016's two
  dated corrections and one trace bullet. Nothing is left for the owner;
  `docs/architecture_open_issues.md` is removed and `Status:` is Settled *(re: header `Version:`,
  `Inputs read:`, the citing paragraph; § 1 opening; QC-1, QC-2, QC-13, QC-24, QC-59; § 8; § 9
  preamble, row 4, the scope bullet, the `nozoki-mac` bullet; § 10 QC-24 row; RN-6, RN-7;
  ADR-0016 § Decision, § Consequences, § Traces to; source: `docs/trail/architecture/cycle-10.md`
  §§ 2.1, 3.1 – 3.4; `docs/trail/architecture/self_answer-13.md`; `docs/SDD.md` v16 — § 3 SM-4,
  the Swift-frame paragraph, § 4 C-R7, C-I3, C-I6, § 6 S-1, S-3, S-11, § 10 RC-3, § 12, RN-65,
  RN-66; `docs/trail/sdd/cycle-12.md` §§ 5.1, 5.2; `docs/trail/sdd/self_answer-23.md`;
  `crates/nozoki-bridge/Cargo.toml`, `build.rs`, `src/exports.rs`, `tests/exports.rs`;
  `nozoki-mac/Package.swift`; `nozoki-mac/Tests/`; `.github/workflows/ci.yml` (`release.yml`,
  listed here through v13, was never in the tree — struck at v14, RN-25);
  `checks/deps.allow`; `system/projects/nozoki/project.md`; `languages/swift/` — `README.md`,
  `testing.md`, `layout.md`, `toolchain.md`, `quality_gates.md`; `languages/README.md`
  § Precedence, § The resolution chain; https://doc.rust-lang.org/cargo/reference/build-scripts.html;
  https://github.com/actions/runner-images/blob/main/images/macos/macos-14-arm64-Readme.md;
  https://www.swift.org/blog/swift-6.2-released/; the commits named)*
- **RN-25:** *(v14 — the close of the cycle-11 companion: seven facts these records held that the
  Tauri build's removal made false, each raised by the PM from the tree at `nozoki@0aca57e`)*
  **How the companion came to exist.** As at RN-18 – RN-21 and RN-24, no `product-architecture`
  run opened it: both records were Settled at v13 with no companion on disk. The PM opened it on
  2026-09-24 (`nozoki@1e2faad`) with seven items raised from downstream, §§ 3.1 – 3.7, each a
  measurement of `main` at `nozoki@0aca57e` — the merge at which the Tauri build left the tree
  (`docs/SDD.md` § 10 RC-3) — against a sentence here. All seven were answered in the owner's
  seat by one unattended `companion-self-answer` run, not by the owner in person
  (`nozoki@c461b29`; its reasoning, `docs/trail/architecture/self_answer-14.md`), and as answered
  the companion is `docs/trail/architecture/cycle-11.md`. Every change below names the answer
  that authorizes it, and what this run added beyond an answer's words is marked as this run's
  own. Every measurement below was re-run this fold at `nozoki@c461b29`, not taken from the
  answer. **§ 3.1 → § 1's opening paragraph.** `git ls-files nozoki-ui crates/nozoki-app | wc -l`
  prints `0`, so the v13 sentence that the tree holds both shapes is false; the paragraph reads
  the tree as ADR-0016's four units and nothing else from `nozoki@0aca57e`, dated in place in the
  form v13 used for the same paragraph, and its closing clause about the old units "while they
  remain" goes with it, nothing old remaining. The answer's addition, folded as written: the
  measure is `git ls-files`, not the `ls` the v13 sentence cited, because a working copy that
  built the previous shape still lists `nozoki-ui/` and `crates/nozoki-app/` as untracked build
  output — this checkout does (`ls -d nozoki-ui crates/nozoki-app` lists both while `git
  ls-files` tracks neither; the answer names `node_modules/`, `dist/`, `gen/`, `permissions/`),
  their ignore lines having left with the build — and an `ls` there reads the old shape back into
  a tree that does not hold it. The four scripts not yet in the tree — `checks/view.sh`,
  `checks/renderer.sh`, `checks/structure.sh`, `checks/entry-points.sh` (`ls checks/` prints
  `bundle.sh`, `deps.allow`, `fixtures`, `no-network.sh`, `own-state.sh`, `read-only.sh`,
  `sandbox_probe.rs`, `tests`) — stay as the entries name them, under the header's rule that a
  command becomes executable in the change that lands its script. **§ 3.2 → QC-3.** The one item
  the answer overrode, in one clause: the PM's lean had the tail say the review half was realized
  at `nozoki@0aca57e` over the 17 names, and the answer checked that clause against the record and
  found no review — `nozoki@6acfb65` generated the list and read its names against the file's
  header rules, which is the reading by name QC-3's own second half says cannot answer the domain
  question, and `nozoki@fad4e78`'s body records only that the tree equals the list. So the tail
  does not say the half was realized. What it says instead, transcribed from the answer: at
  `nozoki@0aca57e` the list is one `cargo:` section of 17 names (`checks/deps.allow:L18` onward;
  `awk '/^cargo:/{p=1;next} p && !/^#/ && NF' checks/deps.allow | wc -l` → `17`, and
  `grep -c '^pnpm:'` → `0`); the `pnpm:` section (163 names) and 201 of the 218 cargo names left
  with the Tauri build at `nozoki@fad4e78`, unreviewed, and none of them is shipped now; the 17
  that stayed were among the 218 never reviewed; the one-time review is still owed over those 17,
  by the change that first realizes the half, and the rest of the tail stands. The clause "the
  pnpm names leave the list with `nozoki-ui`" is gone from the tail, the leaving having happened.
  § 10's QC-3 row names the script and the review and does not move. **Seen and not written, the
  answer's own note carried here:** read by name, none of the 17 (`itoa`, `libc`, `log`, `memchr`,
  `proc-macro2`, `quote`, the `serde` family, `syn`, `thiserror`, `thiserror-impl`,
  `unicode-ident`, `zmij`, and the two product crates) has a transport for its domain — which is
  exactly the name-level reading QC-3 says is not the review, so it settles nothing. **§ 3.3 →
  QC-25.** `grep -n EXPECTED_ENTITLEMENTS checks/bundle.sh` prints `132:`, and `:L132-L133` hold
  the two entitlements the entry names; QC-25's tail cited `:L127-L128`, true of the script at
  `nozoki@99e2bac` and five lines high since the contents block above the set grew. Of the lean's
  two options the answer took the current range pinned to the commit it was read at,
  `nozoki@0aca57e:checks/bundle.sh:L132-L133` — the form § 3.7 uses, so the two answers agree, and
  a pin fails by being old rather than by pointing at the wrong lines. The answer's addition,
  folded as written: RN-21's two old ranges (`:L127-L128` "opened this run", and `:L127-L187` in
  its source list) are dated history, true when their fold read them, and do not move; only QC-25
  is a live entry. § 10's QC-25 row names the script alone and does not move. **§ 3.4 → § 9's
  `nozoki-mac` bullet, the toolchain clause and the tail.** The clause read that CI does not
  build `nozoki-mac` — true of `ci.yml` at `nozoki@99e2bac` — and on `main`
  `.github/workflows/ci.yml:L26` runs `swift test --package-path nozoki-mac` in `Test gate` and
  `:L29` runs `nozoki-mac/assemble.sh`, both from `nozoki@0aca57e`. The clause now says so, dated
  in place, and says the value is still unread: `git rev-parse --short origin/main` prints
  `a4ab8e6` and `git rev-list --count origin/main..main` prints `14` this fold (`9` when the PM
  measured, `13` when the answer did — the count moves with every local commit and the fact does
  not), so no CI run on `main` has built it. The answer's two additions, folded as written:
  (1) `ci.yml` has no `swift --version` step (`:L22-L29`) and neither the answer nor this run
  knows whether `swift test`'s output names the toolchain, so the clause states what happens if
  the first log is silent — the line stays *not yet measured* and says what it waits for — and
  the tail's review gate, which read "until CI builds `nozoki-mac`", a condition now met while the
  value is still unread, reads "until a CI log on `main` names the toolchain"; (2) `macos-14` is a
  label whose default Xcode the runner-images project can move under the same name, so the line
  will record the runner image's version beside the run id and the Swift version, and a later
  reader can tell a re-measurement from a contradiction. If the first log shows 6.2 or later, the
  bullet's "adopted then" clause comes due, as it already said. **§ 3.5 → § 9 and RN-24.**
  `ls .github/workflows` prints `ci.yml` alone, and `git log --all --oneline --
  .github/workflows/release.yml` prints nothing: no `release.yml` has ever existed on any branch
  of this repository. The image claim in § 9's bullet cites `ci.yml:L18` alone, which is
  `runs-on: macos-14` and holds by itself. The answer's addition, folded as written: RN-24 cited
  `release.yml:L18` in its prose and named `release.yml` in its source list as a file it read, and
  both are false in the same way; each is struck where it stands, with a dated parenthesis saying
  so rather than by rewriting the note — the form the SDD's RN-66 – RN-68 fixed for a note that
  records history, and RN-24 is one. QC-29's `release.yml` states an obligation — the release is
  built by that workflow — not a citation, and stands. **§ 3.6 → § 9's `nozoki-mac` bullet, a
  fourth departure and the tail.** The bullet said a packet rule it does not name is followed as
  written, and the packet's dependency gate refuses any target whose `type` is `"system"`
  (`languages/swift/quality_gates.md` § The gates — `select(.url != null or .type == "system")`,
  read this fold at v1.1.0) while `nozoki-mac/Package.swift:L19` is
  `.systemLibrary(name: "CNozokiBridge")`; a delivery reader writing the packet's gate from the
  bullet's words would fail the tree as built. The bullet names the clause as departed from, for
  the reason the answer gives — the system library is a module map over `nozoki-bridge`'s
  generated header, that crate is this repository's own and is on `checks/deps.allow`, so the link
  brings nothing new into the tree — and names `checks/no-network.sh` as the gate in its place.
  The answer's two additions, folded as written: (1) the departure is that one clause and nothing
  else — `no-network.sh` holds the gate's other two conditions, a non-empty `dependencies` array
  and a target carrying a `url` (`checks/no-network.sh:L31-L32`), reads the dump with `plutil`
  rather than `jq`, and refuses a `Package.resolved` at any depth under the package (`:L149`,
  `find … -name Package.resolved`), wider than the packet's working-directory `test`; (2) the
  clause departs only because the system-library link exists, so it flips with the bullet's three
  departures — when the artifact-bundle link replaces the system library no target has
  `type == "system"` and the packet's gate is followed as written — and the tail's "three
  departures flip together" reads four. **One thing here is this run's own:** the tail names
  `checks/no-network.sh` beside `swift test` as a machine check of the bullet, because the bullet
  now says the script stands in the packet gate's place, and a stand-in the tail does not name is
  a review bar wearing a script's name. **§ 3.7 → RN-18, RN-19 and ADR-0012.** The item's grep,
  re-run this fold, finds the seven unpinned citations the item lists — RN-18's
  `crates/nozoki-app/tests/config.rs:L17`, `:L181-L188` and `tauri.conf.json:L12`; RN-19's
  `log_writer.rs:L142`, `tests/config.rs:L11` and `log_writer.rs:L201`; ADR-0012's
  `nozoki-ui/src/main.ts:L14-L19` and `crates/nozoki-app/src/main.rs:L17-L19` in its § Context
  and again in its § Traces to — and RN-19's `tests/config.rs:L228`, `:L231` and
  `capabilities/main.json:L5`, already pinned to `nozoki@bf99e8e` in their own sentence. Each of
  the seven is pinned to `nozoki@a4ab8e6:` with its full path: `git show a4ab8e6:<path>` opened
  each line this fold and each reads as the records say (`config.rs:L11` `use std::fs;`, `:L17`
  and `:L181-L188` the CSP assertions, `tauri.conf.json:L12` the `csp` string,
  `log_writer.rs:L142` `log::set_logger(writer)?;`, `:L201` `fs::write(…)`, `main.ts:L14-L19`
  `start()` calling `runStartFlow`, `main.rs:L17-L19` `open_folder` with `pick_folder()`);
  `a4ab8e6` is `origin/main` and the last first-parent commit before `0aca57e`, and none of the
  five files changed between it and `15e8790`, the last commit before their removal, so the pin
  names the text every citation was read against and a reader of the public repository can open
  it. The answer's addition, folded as written: ADR-0012 is Accepted, and its three pins are prose
  edits on the owner's cycle-3 ruling that a citation repair reverses no decision, changes no
  context, alternative, consequence or trace, and leaves the record's Status at Accepted
  (`docs/trail/architecture/cycle-3.md` § 3.1, answer (3); RN-16's form, taken again at RN-17 and
  at the SDD's RN-68 for the same two citations) — its § Traces to bullet says so in one sentence
  so the record does not depend on this note; no record is superseded and the index, a projection
  of number, title, status and date, is untouched. `…/common/mod.rs:L11` at RN-19 is
  `crates/nozoki-core/tests/common/mod.rs`, which stands, and is out of the item. **Fixed in
  place, under no answer** — a defect found while walking, RN-24's form for § 1's paragraph:
  QC-27's tail and § 9's preamble each said `pnpm audit` and the TypeScript packet's tooling
  "leaves with `nozoki-ui`", a prediction the removal fulfilled; each reads *left* and is dated to
  `nozoki@0aca57e`, and nothing either binds moves. **What moved beneath this document, and what
  did not.** The SDD moved v16 → v17 (`nozoki@7608edb`, run 16; `git diff --stat 097ef33..7608edb
  -- docs/SDD.md`: 142 insertions, 14 deletions, read whole as a diff): its `Version:` line, a
  dated parenthesis on § 10 RC-3's *Still unresolved* recording that the README's stack and status
  block moved at `nozoki@61748fe`, and the Review Notes — RN-52, RN-53, RN-57 and RN-58 pinning
  citations to `nozoki@a4ab8e6:`, RN-59 and RN-60 taking dated parentheses, RN-67 – RN-69 new. No
  § 1 – § 9 statement moved, so no entry here follows it; the SDD is Settled and its companion
  removed. The SRS (v12), the FDR (v8), the PRD (v15), the UXD (v10), DESIGN (v8) and CONTENT (v6)
  are byte-for-byte what v13 read (`git diff --stat 5c4bd9a..HEAD` over the six is empty); each
  one's `Status:` line was re-read this run and every one is Settled, so the `Inputs read:` line
  stands. The doctrine cites stand as the header states them. No `QC` is added, renumbered or
  reused; § 1, § 2, § 9 and the two review notes move only where named above; § 10 does not move;
  no accepted record is edited beyond ADR-0012's three pins and the one § Traces to sentence that
  states their provenance. Nothing is left for the owner; `docs/architecture_open_issues.md` is
  removed and `Status:` is Settled *(re: header `Version:`; § 1 opening; QC-3, QC-25,
  QC-27; § 9 preamble, the `nozoki-mac` bullet; RN-18, RN-19, RN-24; ADR-0012 § Context,
  § Traces to; source: `docs/trail/architecture/cycle-11.md` §§ 3.1 – 3.7;
  `docs/trail/architecture/self_answer-14.md`; `docs/trail/architecture/cycle-3.md` § 3.1;
  `docs/SDD.md` v17 — § 10 RC-3, RN-67, RN-68; `checks/deps.allow`; `checks/bundle.sh`;
  `checks/no-network.sh`; `nozoki-mac/Package.swift`; `.github/workflows/ci.yml`;
  `nozoki@a4ab8e6:crates/nozoki-app/tests/config.rs`, `:src/log_writer.rs`, `:src/main.rs`,
  `:tauri.conf.json`; `nozoki@a4ab8e6:nozoki-ui/src/main.ts`; `languages/swift/quality_gates.md`
  § The gates; the commits named)*
- **RN-26:** *(v15 — the cycle-12 fold: five facts these records held that the renderer gate's
  landing made false, each raised by the PM from the tree at `nozoki@153f5a1`, and one choice a
  `companion-self-answer` run raised on this document for the owner's confirm)* **How the
  companion came to exist.** As at RN-18 – RN-21, RN-24 and RN-25, no `product-architecture` run
  opened it: both records were Settled at v14 with no companion on disk. The PM opened it on
  2026-09-24 (`nozoki@2bcefd5`, § 3.5 at `nozoki@28eb54f`) with five items raised from
  downstream, §§ 3.1 – 3.5, each a measurement of `main` at `nozoki@153f5a1` — the merge at which
  `checks/view.sh`, `checks/renderer.sh` and `checks/fixtures/idle-shell` landed — against a
  sentence here. All five were answered in the owner's seat by one unattended
  `companion-self-answer` run, not by the owner in person (`nozoki@c28255e`; its reasoning,
  `docs/trail/architecture/self_answer-15.md`), and that run appended one item of its own, § 2.1,
  in the bucket *Choices to confirm*, with its slot empty. As answered the companion is
  `docs/trail/architecture/cycle-12.md`. Every change below names the answer that authorizes it,
  and what this run added beyond an answer's words is marked as this run's own. Every measurement
  below was re-run this fold at `nozoki@c28255e`, not taken from the answer: `git diff --stat
  153f5a1 HEAD -- checks .github nozoki-mac` prints nothing, so the PM's tree is this one.
  **§§ 3.1 and 3.2 → QC-62 and ADR-0012, decided together.** Every sentence the two items correct
  is measured false: `ls checks checks/fixtures` lists `renderer.sh` and `idle-shell`;
  `.github/workflows/ci.yml:L43-L44` runs the gate as `Renderer gate` after `Bundle probe`
  (`:L31-L32`); `nozoki-mac/Sources/Shell/LaunchFlow.swift:L35-L37` calls `panel.chooseFolder()`
  and only then `bridge.openFolder(location:)`; `checks/renderer.sh:L53-L57` lists five frames
  with no bridge frame and `:L51-L52` says why; `:L58-L61` records the Mac reading (macOS
  26.6.2); `gh run view 35988399477 --json headSha,conclusion,headBranch` → `37a962d`, `success`,
  branch `2026-09-24_the-shell-is-seen-at-the-panel`, and `git diff --stat 37a962d HEAD --
  checks/renderer.sh checks/fixtures/idle-shell nozoki-mac/Sources` prints nothing, so the run
  read the script and the shell `main` holds (its *Renderer gate* lines are as SDD RN-70 quotes
  them; this run did not re-download that log). QC-62 reads the observation in the words
  `docs/SDD.md` § 4 C-I3 carries at v18 — parked in the Open panel's modal run, inside the shell's
  launch frames — which is transcription under this document's rule that the § 4 statement wins;
  it says why `open_folder` is not among the frames and cites the frame list from the script's
  header rather than copying it, the way C-I3 does, so the next re-measurement moves one file.
  The answer's additions, folded as written: the not-covered clause is replaced, not removed —
  in its place stand C-I3's re-cut rule (a runner image or macOS whose Open-panel frames read
  differently turns the gate red on the next build, a trigger on the mechanism and never on the
  gate) and the half the gate does not cover (a thread sample shows the shell in the panel's run,
  not the panel on screen — S-1's observable half, RN-70); the two pointers to "§ Open Questions,
  last item", which SDD v18 removed so that they landed on another question, point at C-I3 at v18
  and RN-70; the *verified by* says the frames were re-measured, past tense, and where each
  reading is — the Mac's in the header, the runner's cited from run 35988399477 with its image
  and macOS version, because the header does not carry it yet (task 6 of the change that landed
  the gate, deferred). The red-by-construction sentence and the "not in the tree yet" sentence
  are dated history in a parenthesis, the owner's cycle-8 addition standing as what it was, a
  rule for the tree before the native shell. **One thing here is this run's own:** the never-
  cleared clause of that addition is kept as a live sentence and re-grounded on C-I3's *Violated
  by* ("a renderer gate skipped") and ADR-0011, because a rule that a red is not cleared by an
  entitlement or by skipping is true of the gate on any tree and would otherwise leave with the
  history it came in. ADR-0012 takes the same corrections as six dated in-place parentheses — its
  § Decision's observable and its dead pointer, its red-by-construction paragraph, its
  § Consequences' "process-level read of the shell's call into the bridge" and its "is
  unmeasured", and its "not in the tree" sentence — plus one § Traces to bullet stating their
  provenance, the form ADR-0010 took at v9 (RN-20) and ADR-0016 at v13 (RN-24). No decision
  reverses and no record is superseded: the record says what it fixes is the gate, its two rules
  and its place after the wall probe, not the frames. § 10's QC-62 row names the script and the
  control and does not move beyond the suite annotation below. **§ 3.3 → QC-51's tail.**
  `nozoki-mac/Sources/Shell/OpenFolderPanel.swift:L14` is `return panel.runModal() == .OK ?
  panel.url : nil`, and C-R3 requires the panel at launch, so "no modal presentation in
  `nozoki-mac/Sources`" was false as written. The tail admits the Open panel's own presentation,
  which C-R3 requires, and the answer's addition is folded as written: at the bound the scan
  holds, not the lean's looser "the Open panel's presentation" — exactly one `.runModal()` with
  no argument in that file, a second one there, one with an argument, or one in any other file
  reported (`checks/view.sh:L80-L86`, F13), so a sheet, a second panel or a modal elsewhere under
  `Shell/` is not read as admitted. The rule sentence does not move: the Open panel carries no
  failure. The trace gains SDD § 4 C-R3. § 10's QC-51 row does not move. **§ 3.4 → QC-34's tail,
  the lean's second branch.** `checks/view.sh:L33-L87` holds thirteen families, F1 – F13, several
  marked "design addition" under QC-34's own same-change clause, and `:L87` reads "QC-34's, QC-1's
  and QC-23's lists point here: this header is the list, and C-R7's set is its floor". The tail
  names the header as the list and keeps C-R7's fourteen names as the floor the script may
  exceed and never fall short of. Not the first branch, naming the thirteen families here: that
  is a second copy of a list the repository keeps in one place, and it drifts the first time the
  same-change clause adds a family. The answer's addition, folded as written: QC-1 already points
  at QC-34 and QC-23's tail names the scan with no list, so each follows this tail and gains no
  text. The same-change clause stands, now adding to the header. § 10's QC-34, QC-1 and QC-23
  rows name the script and do not move beyond the suite annotation below. **§ 3.5 → § 9, a new
  bullet, and § 10.** `ls checks/tests` lists six suites; `grep -n 'checks/tests' docs/nfdr.md`
  printed nothing before this fold; `ci.yml:L35-L36` runs `test_bundle.sh` alone, and `for s in
  checks/tests/*.sh; do grep -q "$s" .github/workflows/ci.yml || echo "$s"; done` prints the
  other five; the failing case `test_header_names_the_runner_reading` is at
  `checks/tests/test_renderer.sh:L64` and `:L833`, and the answer's run of the suite at HEAD
  printed `1 case(s) failed` (`docs/trail/architecture/self_answer-15.md`, *What was read*; this
  run did not re-run the suite, which launches the built bundle). The lean's first branch is
  taken and its third struck, for the answer's reason: owner-run suites that gate nothing leave a
  red suite invisible to every gate, which is the state the item measured. § 9 gains a bullet
  beside the `checks/structure.sh` and `checks/view.sh` scope bullets: every suite runs as its
  own CI step on every build, the way `Bundle probe suite` does; a script that lands with a suite
  lands the step in the same change. The answer's additions, folded as written: (1) ordering —
  `test_renderer.sh`'s step lands with the runner-reading task or after it, never by skipping or
  deleting the red case, and the other five join as each is green on the runner; (2) a suite that
  cannot run on the hosted runner is recorded in the bullet with the measurement and runs as a
  named release step, never left silent; (3) the cost the answer could not see — the repository
  is private (`gh repo view`, 2026-09-24) and GitHub bills private-repo macOS minutes past the
  plan's quota — was offered as an override's ground, the fallback being the lean's second branch
  (the suites as one named release step); no override was given, so the fallback is recorded
  here and not in the bullet. **Two things here are this run's own:** the bullet's tail is a
  review gate, argued in the tail — the comparison is a one-line command, no script in the tree
  runs it, and the tree is measured short of the rule today, so a CI step for it would be red on
  every build until the five land; the day they do, the comparison becomes a `checks/` script and
  the tail names it. And § 10 realizes "names its suite beside it" as an annotation
  `(suite test_<name>.sh)` on the first mention of each of the six scripts in each row, with a
  legend above the table pointing at the bullet, so the rows stay a projection and the rule lives
  once. **§ 2.1 → § 9's toolchain clause, drafted for the owner's confirm.** The raising run
  wrote nothing into the records and left the slot for the next round. The clause's own rule is
  that "the first CI log on `main` that runs those steps supplies the value and this line takes
  it", and that log now exists, so this run applied the draft the bucket exists for and left the
  slot empty. Re-read before writing, not taken from the item: `gh run view 35968105480 --json
  headSha,conclusion,headBranch` → `c461b29`, `success`, `main`; its log's *Runner Image* block
  prints `Image: macos-14-arm64`, `Version: 20260831.0302.1` and `14.8.9`; its *Test gate* ran
  `cargo test --workspace --locked && swift test --package-path nozoki-mac` and the XCTest
  suites executed with 0 failures; the only lines matching `swift-version`, `Swift version`,
  `swiftlang` or `Apple Swift` are two `Write swift-version-76B232A4806BA581.txt` build lines. So
  the clause records the run and stays *not yet measured* by its own rule, "no CI run on `main`
  has built it" becoming dated history; the tail's review gate and the four departures do not
  move. An override at § 2.1 reverts the clause on the next run. **Fixed in place, under no
  answer:** none this fold. **What moved beneath this document, and what did not.** The SDD
  moved v17 → v18 (`nozoki@399ef71`, run 17; `git diff --stat 8655a33 HEAD -- docs/SDD.md`:
  85 insertions, 21 deletions): § 4 C-I3's observable, measured-frames sentence and hosted-runner
  sentence with the re-cut rule; § 6 `open-a-folder`'s command half; § 9 TO-7's *costs*; § 10
  RC-2's and RC-3's dated parentheses; the seventh *Open Questions* item removed; RN-70. The
  C-I3 move is the one QC-62 follows, folded above through §§ 3.1 and 3.2; TO-7's acceptance
  (the shell holds no I/O, C-R7) is unchanged, so § 9's layer-4 and layer-5 bullets, which cite
  it, stand. The SRS (v12), the FDR (v8), the PRD (v15), the UXD (v10), DESIGN (v8) and CONTENT
  (v6) are byte-for-byte what v14 read (`git diff --stat 8655a33 HEAD` over the six is empty);
  each one's `Status:` line was re-read this run and every one is Settled, so the `Inputs read:`
  line stands. No `QC` is added, renumbered or reused; § 2, § 7, § 9 and § 10 move only where
  named above; no accepted record is edited beyond ADR-0012's six dated parentheses and the one
  § Traces to bullet that states their provenance; the index, a projection of number, title,
  status and date, is untouched. One item awaits the owner, § 2.1; `docs/architecture_open_issues.md`
  holds it alone and `Status:` is Draft *(re: header `Status:`, `Version:`; QC-34, QC-51, QC-62;
  § 9 the `checks/tests/` bullet and the `nozoki-mac` bullet's toolchain clause; § 10 legend and
  rows; ADR-0012 § Decision, § Consequences, § Traces to; source:
  `docs/trail/architecture/cycle-12.md` §§ 2.1, 3.1 – 3.5;
  `docs/trail/architecture/self_answer-15.md`; `docs/SDD.md` v18 — § 4 C-I3, C-R3, § 9 TO-7,
  RN-70; `docs/trail/sdd/cycle-14.md` §§ 5.1, 5.2; `checks/renderer.sh:L44-L61`;
  `checks/view.sh:L33-L87`; `checks/tests/test_renderer.sh:L64`; `nozoki-mac/Sources/Shell/
  LaunchFlow.swift:L35-L37`; `nozoki-mac/Sources/Shell/OpenFolderPanel.swift:L14`;
  `.github/workflows/ci.yml:L26`, `:L31-L36`, `:L43-L44`; GitHub Actions runs 35988399477 at
  `nozoki@37a962d` and 35968105480 at `nozoki@c461b29`; `nozoki@153f5a1`; the commits named)*
- **RN-27:** *(v16 — the close: the cycle-13 fold, one choice v15 drafted into § 9's toolchain
  clause, confirmed with addition in the owner's seat)* **How the item came to exist.** The
  `companion-self-answer` run that answered cycle 12's five downstream items raised § 2.1 on this
  document (`docs/trail/architecture/self_answer-15.md`, § Raised on this document), from reading
  § 9 whole against the CI runs on `main`; the v15 fold drafted it into the clause and left the
  slot empty (RN-26). It was answered in the owner's seat by a second unattended
  `companion-self-answer` run, not by the owner in person (`nozoki@0f7743e`; its reasoning,
  `docs/trail/architecture/self_answer-16.md`): confirmed, with one addition. As answered the
  companion is `docs/trail/architecture/cycle-13.md`. **Re-measured this fold, not taken from the
  answer** (2026-09-24, at `nozoki@0f7743e`): `gh run view 35968105480 --json
  status,conclusion,headSha,headBranch,event` → `completed`, `success`, `main`, `push`, `c461b29`;
  `gh run list --branch main --workflow CI --limit 6` lists five runs on `main` and 35968105480 is
  the newest — local `main` is 22 commits ahead of `origin/main` at `c461b29` and unpushed, so no
  later `main` run exists whose log could name the toolchain; `.github/workflows/ci.yml:L25-L26`
  still runs `swift test --package-path nozoki-mac` in `Test gate`, and `grep -n 'swift --version'
  .github/workflows/ci.yml` prints nothing. The log's contents — image `macos-14-arm64`
  20260831.0302.1, macOS 14.8.9, no line naming a Swift version — are as RN-26 measured them; this
  run did not re-download the log. **§ 2.1 → § 9's toolchain clause.** The drafted clause stands
  word for word: the run is recorded, the line stays *not yet measured* by its own rule, "no CI run
  on `main` has built it" is dated history, and the tail's review gate and the four departures do
  not move. The addition, folded as written: the clause's closing parenthesis named
  `docs/architecture_open_issues.md` § 2.1 as where the owner confirms it, and this fold deletes
  that file, so the parenthesis now names `docs/trail/architecture/cycle-13.md` § 2.1 — the form
  every earlier cycle pointer in these entries takes (`cycle-11.md` § 3.4, in the same clause).
  Nothing else in this document named the live companion in the present tense: `grep -n
  architecture_open_issues docs/nfdr.md` finds, beside that parenthesis, only the header's and the
  Review Notes' dated accounts of earlier folds, which stand as history, and `grep -rl` over
  `docs/adr/` finds no record naming it. **Fixed in place, under no answer:** none this fold.
  **What moved beneath this document, and what did not.** Nothing: `git diff --stat 8d6f4c6 HEAD
  -- docs` lists the companion and `self_answer-16.md` alone. The SDD (v18), the SRS (v12), the FDR
  (v8), the PRD (v15), the UXD (v10), DESIGN (v8) and CONTENT (v6) are byte-for-byte what v15
  read; each one's `Status:` line was re-read this run and every one is Settled, so the `Inputs
  read:` line stands. No `QC` is added, renumbered or reused; § 10 does not move; no record is
  edited and the index is untouched. Nothing is left for the owner;
  `docs/architecture_open_issues.md` is removed and `Status:` is Settled *(re: header `Status:`,
  `Version:`; § 9 the `nozoki-mac` bullet's toolchain clause; source:
  `docs/trail/architecture/cycle-13.md` § 2.1; `docs/trail/architecture/self_answer-16.md`;
  `.github/workflows/ci.yml:L22-L29`; GitHub Actions run 35968105480 at `nozoki@c461b29`;
  `nozoki@0f7743e`)*
- **RN-28:** *(v17 — the close: the cycle-14 fold, five items raised by the PM from the tree at
  `nozoki@ab39502`, each answered in the owner's seat)* **How the items came to exist.** No
  `product-architecture` run opened the companion: the PM opened it on 2026-09-24
  (`nozoki@1a84367`) from measuring `main` at `nozoki@ab39502` — the merge at which the runner
  reading went into `checks/renderer.sh`'s header (`nozoki@2b83dce`) and the five remaining
  `checks/tests/` suites went onto CI steps of their own (`nozoki@82996b8`, `nozoki@66ba2e8`) —
  against these records at v16. §§ 3.1, 3.4 and 3.5 were facts the records held that the tree
  made false; §§ 3.2 and 3.3 were rules § 9 wrote for a day that had come. All five were answered
  in the owner's seat by a `companion-self-answer` run, not by the owner in person
  (`nozoki@c26d47c`; its reasoning, `docs/trail/architecture/self_answer-17.md`): each confirmed
  with addition, §§ 3.1 and 3.3 decided together, §§ 3.4 and 3.5 decided together. As answered
  the companion is `docs/trail/architecture/cycle-14.md`. **Re-measured this fold, not taken
  from the answers** (2026-09-24, at `nozoki@c26d47c`, whose tree outside `docs/` is
  `nozoki@ab39502`'s — `git diff --stat ab39502 HEAD` lists the companion and
  `self_answer-17.md` alone): the six suite steps at `.github/workflows/ci.yml:L35-L36`,
  `:L41-L42`, `:L52-L53`, `:L61-L62`, `:L67-L68`, `:L70-L71`, each a step's whole `run`; the
  comparison in § 9's tail prints nothing; `grep -nE 'continue-on-error|^[[:space:]]+if:'
  .github/workflows/ci.yml` prints nothing; `ls checks/*.sh` lists the six scripts and none runs
  the comparison; `NOZOKI_TEST_ONLY=test_header_names_the_runner_reading
  checks/tests/test_renderer.sh` prints `ok` and exits 0; `checks/renderer.sh:L44-L57` holds the
  frame list, `:L58-L61` the Mac reading, `:L62-L65` the hosted-runner reading (run 35988399477
  on `nozoki@37a962d`, `macos-14-arm64` 20260831.0302.1, macOS 14.8.9); `Renderer gate` is
  `ci.yml:L46-L47` and `Bundle probe` `:L31-L32`, and `git show 153f5a1:.github/workflows/ci.yml`
  has `Renderer gate` at `:L43-L44`, so ADR-0012's dated cite was true when written; `gh run list
  --repo kensaiapp/nozoki --workflow ci.yml --limit 5` lists 35988399477 on `nozoki@37a962d`
  (branch `2026-09-24_the-shell-is-seen-at-the-panel`) and 35968105480 on `nozoki@c461b29`
  (`main`) as its newest, `origin/main` is `c461b29`, and `git rev-list --count origin/main..main`
  prints `29` — the answer counted `28` and the PM `27`, the two companion commits since — so no
  run has run the five. The Mac run of all six suites is the PM's measurement in the item and was
  not repeated here. **§§ 3.1, 3.3 → § 9's `checks/tests/` bullet and § 10's preamble.** The
  bullet reads all six on steps from `nozoki@ab39502`, dated; the ordering rule is history that
  held and its case passes; the tail keeps its review gate on the one ground left — no script
  runs the comparison — and states the script it owes, its exit condition, its own step, its
  suite's step in the same change, and the day it lands as the day the gate drops; the one-sided
  gap until then is named. § 10's preamble reads all six on steps and loses its "what fails"
  clause, which had nothing left to point at. Routing the owed script is not this document's.
  **§ 3.2 → § 9's `checks/tests/` bullet, the joining rule.** As written at v15 the rule's
  precondition — green on the hosted runner — could be met only by the act it guarded, so it is
  re-cut as the tree stands: a suite joins as a fatal step and its first CI run is its reading; a
  red suite moves to a named Mac release step, recorded with the measurement, and `main` stays
  red until the next change moves or fixes it, the step never quieted; a non-fatal step is the
  one ruled-out way to join, ADR-0012's rule one level down. Where the five stand is recorded as
  the answer's addition (1) directed — not yet run on the hosted runner — with the measurements
  above. **§§ 3.4, 3.5 → QC-62 and ADR-0012.** QC-62's tail cites the runner reading from the
  header (`checks/renderer.sh:L62-L65`) as it cites the Mac reading from `:L58-L61`, its "cited
  from the run" clause dated history in a parenthesis, and cites `Renderer gate` at
  `ci.yml:L46-L47` with `:L43-L44` dated to `nozoki@153f5a1`; its trace names v17. ADR-0012 takes
  one new dated in-place note in § Consequences, after the 2026-09-24 note that was true at
  `nozoki@153f5a1` and stands as written, carrying both corrections, and one § Traces to bullet
  naming the cycle — the record's own practice for its six earlier dated notes, on the owner's
  ruling that a citation repair reverses no decision (`docs/trail/architecture/cycle-3.md`
  § 3.1) and the form the log took at v9, v13, v14 and v15; § Decision's `:L43-L44` stands,
  inside a parenthesis dated "from `nozoki@153f5a1`", where it was true. After the fold, `grep -n
  'L43-L44' docs/nfdr.md docs/adr/*.md` finds only sites that date it — QC-62's tail, ADR-0012's
  § Decision parenthesis and its new note, and RN-26's measurement, which stands as history.
  **Fixed in place, under no answer:** none this fold. **What moved beneath this document, and
  what did not.** Nothing: `git log 0f7743e..HEAD -- docs/SRS.md docs/SDD.md docs/fdr.md
  docs/PRD.md docs/UXD.md docs/DESIGN.md docs/CONTENT.md` prints nothing, so the SDD (v18), the
  SRS (v12), the FDR (v8), the PRD (v15), the UXD (v10), DESIGN (v8) and CONTENT (v6) are
  byte-for-byte what v16 read; the three primary inputs' `Status:` lines were re-read this run
  and each is Settled, so the `Inputs read:` line stands. The SDD's seven cites into
  `checks/renderer.sh` (`docs/SDD.md:L707`, `:L714`, `:L724`, `:L1324`, `:L2340`, `:L3940`,
  `:L3972` — ranges inside `:L44-L61`) were opened at `nozoki@ab39502` and hold, and the SDD
  states no suite count and no `Renderer gate` line (`grep -n 'ci.yml:L\|checks/tests'
  docs/SDD.md` prints nothing), so it is owed nothing here. No `QC` is added, renumbered or
  reused; § 10's rows do not move; no accepted record is edited beyond ADR-0012's one dated note
  and one trace bullet, and the index is untouched. Nothing is left for the owner;
  `docs/architecture_open_issues.md` is removed and `Status:` is Settled *(re: header `Status:`,
  `Version:`; QC-62; § 9 the `checks/tests/` bullet; § 10 preamble; ADR-0012 § Consequences,
  § Traces to; source: `docs/trail/architecture/cycle-14.md` §§ 3.1 – 3.5;
  `docs/trail/architecture/self_answer-17.md`; `.github/workflows/ci.yml:L26`, `:L31-L36`,
  `:L41-L42`, `:L46-L47`, `:L52-L53`, `:L61-L62`, `:L67-L68`, `:L70-L71`;
  `checks/renderer.sh:L44-L65`; `checks/tests/test_renderer.sh`; GitHub Actions runs 35988399477
  at `nozoki@37a962d` and 35968105480 at `nozoki@c461b29`; `nozoki@153f5a1`, `nozoki@2b83dce`,
  `nozoki@82996b8`, `nozoki@66ba2e8`, `nozoki@ab39502`, `nozoki@1a84367`, `nozoki@c26d47c`)*
- **RN-29:** *(v18 — the cycle-15 fold: § 3.1 folded as answered; QC-6 re-derived on SDD v20
  under a new upstream sentence; § 2.1 kept for the owner's confirm)* **How the items came to
  exist.** No `product-architecture` run opened the companion. The PM opened it on 2026-09-25 with
  § 3.1 (`nozoki@41915e6`), measuring `main` at `nozoki@46bb275` — the first commit at which the
  shell draws `pending` items — against QC-4; a `companion-self-answer` run answering
  `docs/fdr_open_issues.md` § 2.2 appended § 2.1 in the Principal PM's posture (`nozoki@9cfb727`),
  because SDD run 18 (`nozoki@4b9425b`) had moved § 3 `fs-reader` after v17 (`nozoki@18250d6`) and
  no run of these records had read it. § 3.1 was answered in the owner's seat by a
  `companion-self-answer` run (`nozoki@fcd7ac5`; its reasoning
  `docs/trail/architecture/self_answer-18.md`); § 2.1's slot was empty at intake. As it stood at
  intake the companion is `docs/trail/architecture/cycle-15.md`. **§ 3.1 → QC-4's layer-4 half and
  § 9's row 4.** The half no longer names a word: a projection with a `pending` item draws no
  marker, no count and no empty-folder sentence, and the only words it may carry for the state are
  the *Loading* sentence `docs/CONTENT.md` § Message patterns fixes — a pointer, as the answer
  directed, because a string is CONTENT's to hold (QC-53; FDR R-88) and a copied one goes false
  the day CONTENT re-words it. Row 4 of § 9's layer table moves the same way; § 10's QC-4 row names
  commands only and does not move; the trace to R-94 stays and reads R-94 at v10. The contingency
  the answer left — the FDR's seat answering that R-94 is literal — closed before this fold: FDR
  v10 (`nozoki@69cc4b2`, RN-35) re-worded R-94 to name the state and point at CONTENT's *Loading*
  words, so no document in the definition set names the word *pending* any longer, and nothing
  comes back on a fresh item. Re-measured this fold, not taken from the answer: `git diff --stat
  46bb275 HEAD -- crates nozoki-mac checks` prints nothing, so the tree the items measured is the
  tree at `nozoki@69cc4b2`; `testRepoProjectionDrawsNameAndGlyphOnly` sits at
  `nozoki-mac/Tests/SurfacesTests/RootItemsViewTests.swift:L96-L115` and asserts the only visible
  text on a `pending` row is its name; CONTENT's *Loading* sentence is at `docs/CONTENT.md:L314`,
  UX-S2's row at `:L492`. **§ 2.1 → QC-6, re-derived, and the item kept.** v17's QC-6 stated the
  check "on the canonical path, symlinks resolved and after decoding" — SDD § 3's wording at v13 —
  and SDD v20 § 3 `fs-reader` (`docs/SDD.md:L322`) takes the canonical form only at positions
  inside the grant, reads nothing at a position outside it, compares names there as spelled,
  re-enters the grant only on the folder's own name met from its parent (as spelled, or in another
  letter case under two conditions read from the folder itself, and as spelled wherever it cannot
  be sure), and names three spellings refused although they may lead in; § 4 C-D1's *Violated by*
  names a canonicalizing `lstat` or `realpath` outside the grant as a forbidden read, and § 9 TO-6
  and § 11 R-10 follow § 3 (SDD RN-71). Read as written, v17's QC-6 asked for the read C-D1 forbids
  and QC-35 excludes. This fold re-derives QC-6 on that definition, and the authorization is this
  document's own rule for a settled entry — a new upstream sentence (SDD v20 § 3) and the owner's
  answer at `docs/trail/sdd/cycle-15.md` § 5.1, an authorized decision in the product's trail —
  not an answer on the companion: § 2.1's slot was empty, so the item stays for the owner's
  confirm with its *Drafted into the records* now naming what v18 holds, and its slot is what the
  item was opened for. The *verified by* names the layer-1 cases for the four spellings
  `docs/fdr.md`'s example rows fix (`:L357-L358`; R-183 at `:L87`, R-184 at `:L88`) beside the
  `..` and symlink-out cases, states that none of the four is written at `nozoki@69cc4b2`
  (`crates/nozoki-core/src/fs_reader.rs` `mod tests`, the `..` and symlink cases at `:L412-L578`),
  and that the re-entry case goes red when it is — the walk at `:L170-L177` keeps one lexical
  position and answers `Outside` for `../<NAME>`, measured at `docs/trail/sdd/cycle-15.md` § 5.1
  on `nozoki@46bb275` with the crates unchanged since (the stat above); SDD RN-71's own
  re-verification says the same, the reader meeting the definition on every spelling but the one
  re-entry spelling. That nothing is read outside the grant is left to QC-35 at layer 5, where it
  already is, rather than claimed of a unit test. The trace adds ADR-0011 (the wall the no-read
  rests on), SDD § 4 C-D1 and § 9 TO-6, SRS FR-32 and NFR-16 (containment asked for, the form
  unstated — SDD RN-71), FDR R-183 and R-184, and the owner's answer. § 10's QC-6 row names
  commands only and does not move. **No record.** The as-spelled walk is not a decision of the
  log's kind: it is the one reading of the containment check under which ADR-0011's wall and C-D1
  both hold, decided by the owner in the SDD's trail, reversible inside one function, and bound
  already through ADR-0015 → QC-6; a record would restate the wall. **What moved beneath this
  document, and what it reached.** `git log 18250d6..HEAD -- docs/SRS.md docs/SDD.md docs/fdr.md
  docs/PRD.md docs/UXD.md docs/DESIGN.md docs/CONTENT.md` lists SDD run 18 (`nozoki@4b9425b`,
  v18 → v20), FDR v9 and v10 (`nozoki@d341d42`, `nozoki@69cc4b2`), DESIGN v9 and v10
  (`nozoki@cdb756c`, `nozoki@da88347`) and CONTENT v7 (`nozoki@1c95030`); the SRS, the PRD and the
  UXD did not move. The SDD's seven hunks (`git diff 18250d6 HEAD -- docs/SDD.md`): the header;
  § 3 `fs-reader` (QC-6, above); § 4 C-D1's *Violated by* (QC-6's trace — QC-35's obligation
  already states the no-read); § 4 C-E4's new clause — a refused path is one thing the tool
  observed and its sentence is CONTENT's — which reaches no entry beyond QC-53's pointer at the
  catalogue; § 9 TO-6 and § 11 R-10 (QC-6's trace); RN-71 and RN-72. The FDR's: R-94, R-183, R-184,
  the two example rows, RN-34 and RN-35 — each reached above. DESIGN v9 – v10 and CONTENT v7 reach
  no entry: this document cites both by section and never by line (`grep -n -E
  '(CONTENT|DESIGN)\.md:L' docs/nfdr.md` prints nothing), and the word they dropped is the one QC-4
  no longer names. Every `Status:` line was re-read this run and each of the seven is Settled, so
  `Inputs read:` stands as written. No `QC` is added, renumbered or reused; § 10's rows do not
  move; no record is written or edited and the index is untouched. **`Status:` is Draft** not
  because anything derived here is unsettled but because § 2.1 is on disk for the owner's confirm,
  and this document's status follows the companion's presence *(re: header `Status:`, `Version:`;
  QC-4; QC-6; § 9 the layer table's row 4; source: `docs/trail/architecture/cycle-15.md` §§ 2.1,
  3.1; `docs/trail/architecture/self_answer-18.md`; `docs/trail/fdr/self_answer-6.md`
  § Companions opened; `docs/trail/fdr/cycle-6.md` § 2.2; `docs/trail/sdd/cycle-15.md` § 5.1;
  `docs/SDD.md:L322`, § 4 C-D1, § 9 TO-6, § 11 R-10, RN-71; `docs/fdr.md:L87-L88`, `:L357-L358`,
  R-94, RN-34, RN-35; `docs/CONTENT.md:L314`, `:L492`; `crates/nozoki-core/src/fs_reader.rs:L170-L177`,
  `:L412-L578`; `nozoki-mac/Tests/SurfacesTests/RootItemsViewTests.swift:L96-L115`;
  `nozoki@18250d6`, `nozoki@4b9425b`, `nozoki@41915e6`, `nozoki@46bb275`, `nozoki@fcd7ac5`,
  `nozoki@9cfb727`, `nozoki@d341d42`, `nozoki@69cc4b2`, `nozoki@cdb756c`, `nozoki@da88347`,
  `nozoki@1c95030`)*

- **RN-30:** *(v19 — the close: the cycle-16 fold; QC-6's layer-1 list re-sourced under the
  owner's answer; the volume-root case named red under this run's own reading)* **The fold.** The
  companion at intake (`docs/architecture_open_issues.md` at `nozoki@368f127`) held one item, § 2.1,
  answered in the owner's seat by a `companion-self-answer` run (its reasoning
  `docs/trail/architecture/self_answer-19.md` § 2.1): *confirm, with one addition*. The companion as
  it stood is `docs/trail/architecture/cycle-16.md`, copied before this fold rewrote anything.
  **§ 2.1 → QC-6's *verified by*, the layer-1 list only.** The obligation, the trace and § 10's
  row stand as v18 holds them; the answer moves one sentence. v18 said "the four spellings
  `docs/fdr.md`'s example rows fix (`:L357-L358`)" — the rows fix three: `:L357` holds
  `up → ../NOZOKI/docs`, shown as a folder and expanding into `docs` (R-183, R-34, R-151),
  `far → ../../projects/NOZOKI/docs`, marked outside although it leads in (R-184's multi-level
  return), and `self → ../NOZOKI`, a cycle (R-152); `:L358` holds `back → ../Work/notes.txt` under
  `/Volumes/Work` (R-184's volume root). No row exercises a Unicode-normalization difference; that
  refusal rests on R-184's second clause (`docs/fdr.md:L88`) and SDD § 11 R-10 (`docs/SDD.md:L2431`),
  and the list now cites those in its place, so a QA seat deriving the case has a source to derive
  it from. Two consequences the answer drew, folded as given: the re-entry has two forms the rows
  fix — `self`, ending `Cycle`, which v18 named, and `up`, resolving inside and read as its
  target, which it did not — and the list names both; and both are `Outside` on the walk at
  `nozoki@368f127` by the same lines (`crates/nozoki-core/src/fs_reader.rs:L211-L215`), the
  owner's measurement at `docs/trail/sdd/cycle-15.md` § 5.1 having covered the `self` form on
  `nozoki@46bb275` with the crates unchanged since — re-measured this fold, not taken from the
  answer: `git diff --stat 46bb275 HEAD -- crates` prints nothing, `mod tests` sits at `:L370-L796`
  with the `..` and symlink cases at `:L412-L578`, and `grep -n -i -E 'letter case|case-fold|
  normaliz|volume' fs_reader.rs` hits two doc comments (`:L269`, `:L309`) and no test. **Fixed in
  place, under this run's own reading and no answer:** v18's tree-state clause named the re-entry
  as the one case that goes red; the volume-root case goes red too. Read from the code, not run:
  `Step::Parent` pops the position unconditionally (`:L201-L203`), so from a granted `/Volumes/Work`
  the `..` in `back → ../Work/notes.txt` lands on `/Volumes`; at that position — outside the grant —
  `Work` moves the position lexically to `/Volumes/Work` (`:L211-L215`), which `starts_with` the
  root; and `notes.txt` is then `lstat`ed from inside (`:L217`) and resolves. The definition
  refuses any path that leaves a granted folder that is the root of its volume (SDD § 3
  `fs-reader`, `docs/SDD.md:L322`; FDR R-184, `:L88`; the example row at `:L358`), so a layer-1
  test written to it fails on this tree. The other two — `far`, whose walk ends at
  `…/projects/NOZOKI/docs` and fails `strip_prefix(root)` (`:L256-L262`), and a
  normalization difference, whose bytes never equal the root's — are `Outside` already. A
  tree-state clause that names one red case where there are two sends the station's tree half to
  the wrong gap, which is the reason the clause exists; it is logged here because the answer did
  not ask for it. The clause's expiry stays its own: "until the change that builds the check as
  defined lands". **No record.** Nothing in the answer reverses or reads against an accepted
  record; the index is untouched. **What moved beneath this document, and what did not.** Nothing:
  `git log 88b237f..HEAD -- docs/SRS.md docs/SDD.md docs/fdr.md docs/PRD.md docs/UXD.md
  docs/DESIGN.md docs/CONTENT.md` prints nothing, and each of the seven `Status:` lines was re-read
  this run and is Settled, so `Inputs read:` stands as written. Nothing else in this document
  names the live companion in the present tense: `grep -n architecture_open_issues docs/nfdr.md`
  finds the header's and the Review Notes' dated accounts of earlier folds, which stand as
  history, and `grep -rl` over `docs/adr/` finds no record naming it. No `QC` is added, renumbered
  or reused; § 10's rows do not move. Nothing is left for the owner;
  `docs/architecture_open_issues.md` is removed and `Status:` is Settled *(re: header `Status:`,
  `Version:`; QC-6 *verified by*; source: `docs/trail/architecture/cycle-16.md` § 2.1;
  `docs/trail/architecture/self_answer-19.md` § 2.1; `docs/trail/sdd/cycle-15.md` § 5.1;
  `docs/SDD.md:L322`, `:L2431`; `docs/fdr.md:L84-L88`, `:L357-L358`;
  `crates/nozoki-core/src/fs_reader.rs:L170-L177`, `:L201-L203`, `:L211-L215`, `:L217`,
  `:L256-L262`, `:L269`, `:L309`, `:L370-L796`, `:L412-L578`; `nozoki@46bb275`, `nozoki@88b237f`,
  `nozoki@368f127`)*
- **RN-31:** *(v20 — the close: the three answered cycle-17 items folded into § 9)* **The fold.**
  The companion at intake held one overridden choice and two answered downstream findings; copied
  whole before this fold as `docs/trail/architecture/cycle-17.md`. §§ 3.1 and 3.2 were decided in
  the owner's seat by `docs/trail/architecture/self_answer-20.md`; § 2.1 was decided there by
  `self_answer-21.md`. Nothing is left for the owner. **Framework.** The old *followed* clause was
  false after a fifth XCTest file landed. Its answer makes the present state a departure, fixes the
  count at five at `nozoki@f46269a`, and gives it its own evidence-based flip: new tests remain
  XCTest until a CI log on `main` names a toolchain that runs Swift Testing; from that log onward,
  new tests use Swift Testing and the existing XCTest files stay. The review tail gains changes
  adding a file under `nozoki-mac/Tests/`, because the previous trigger read only the manifest and
  workflow and therefore did not read the three changes that wrote XCTest. **Language mode.** The
  5.9 manifest puts every target in Swift 5 mode, so Swift 6 mode joins the recorded tools-version
  departure and flips with it, explicitly as `swiftLanguageModes: [.v6]`. No target takes
  `StrictConcurrency` meanwhile: the measured diagnostics are warnings without the departed
  warnings-as-errors setting, and the unmeasured CI compiler leaves the spelling unresolved. The
  migration cost is named at `LaunchFlow.swift:L53` and `ReadRunning.swift:L28`. **The two 6.2
  settings.** `.strictMemorySafety()` joins every Swift target, including both test targets, and
  `.defaultIsolation(MainActor.self)` joins `Surfaces` and `Nozoki` only. The strict-memory cost is
  the C-pointer crossings in `NativeBridge.swift` and AppKit's `unowned(unsafe)` properties in
  `RootItemsView.swift`; default isolation has no separately measured current-source failure when
  Swift 5 mode is held. These placements replace the draft that incorrectly put the isolation cost
  on `ReadRunning.swift`. The tools-6.2 review gate now names all seven departures — the six in the
  main clause plus the dependency gate — as one flip. **No ADR.** No target steps down alone and no
  decision reverses an accepted record; ADR-0016 already places this package's Swift-packet
  departures in NFDR § 9, so the index and all records stand. **What moved beneath this document.**
  SRS v12, SDD v20, FDR v10, PRD v15, UXD v10 and DESIGN v10 did not move after v19; CONTENT moved
  v7 → v9, changing the gone-folder and gone-file sentences only. The NFDR cites CONTENT by section
  and no obligation here fixes either sentence, so no entry moves for it. No `QC` is added,
  renumbered or reused; § 10 does not move. The companion is removed and `Status:` remains Settled
  *(re: § 9 `nozoki-mac` bullet; source: `docs/trail/architecture/cycle-17.md` §§ 2.1, 3.1, 3.2;
  `docs/trail/architecture/self_answer-20.md`; `docs/trail/architecture/self_answer-21.md`;
  `nozoki-mac/Package.swift:L1-L36`; `docs/adr/0016-physical-unit-set-core-bridge-mac-checks.md`
  § Consequences; `docs/CONTENT.md` RN-34, RN-35; `nozoki@f46269a`; `nozoki@a5fc189`)*
- **RN-32:** *(v21 — the cycle-18 fold, § 3.1 answered; § 2.1 drafted for the owner's confirm)*
  **The fold.** The companion at intake held one answered downstream item, § 3.1, decided in the
  owner's seat by `docs/trail/architecture/self_answer-22.md`, and one unanswered choice, § 2.1,
  raised by that same run; it was copied whole before this fold as
  `docs/trail/architecture/cycle-18.md`. **§ 3.1 → QC-24.** C-R7 at SDD v22 reads "A build exports
  to the shell exactly the functions its landed changes built" and "A change has built a function
  when the bridge function exists and delegates to an operation `folder-model`'s API carries
  (SM-5)" (`docs/SDD.md:L596-L604`). QC-24's two slice-grain sentences now read by change, and the
  entry carries that meaning of *built*. Set equality, the closed list, `nozoki_free`, "from
  `v1.0.0`", the no-second-export clause and the pre-`v1.0.0` uncovered case stand as written.
  **§ 3.1 → QC-2.** The item proposed naming `cargo test --locked -p nozoki-bridge --test
  select_file` in place of `read-only.sh` until the walk drives `select_file`; the answer overrode
  that, because C-I3 at v22 reads "The unit is the build … no test of a slice's own stands in for
  `read-only.sh`" (`docs/SDD.md:L653-L655`). The tail's "after every command the build exports"
  already said so and stands. QC-2 gains the unit and C-I3's two uncovered cases
  (`docs/SDD.md:L655-L659`), named as QC-24's pre-`v1.0.0` case is, so they are not read as
  coverage. The first — the walk's calls against the export set — is held by review of the change
  that exports a command; the gate is `development-design`, where this document already holds
  QC-3's reviewed half, and § 10's QC-2 row gains it. The records say nothing about the interval
  while a build exports a command its walk does not drive, as the SDD says nothing: that is a
  violation in the build, closed when the walk drives the command, not a false sentence here.
  **§ 2.1 → QC-62 and § 9, drafted.** No owner answer stands behind this; a new upstream sentence
  does. C-I3 at v22 re-points and pins the same citations QC-62 carries (`docs/SDD.md:L717-L748`),
  and QC-62 traces to C-I3. Read at `nozoki@a954a90`, whose code under these paths is byte-equal
  to `nozoki@7c7038f` (`git diff --quiet 7c7038f HEAD --` over `LaunchFlow.swift`,
  `ReadRunning.swift` and `checks/renderer.sh`): `LaunchFlow.swift:L35-L37` is the lazy
  `statusGlyphs` property, `chooseFolder()`'s panel wait and hand-off are `:L54-L60`, and
  `bridge.openFolder` is `:L69`; `checks/renderer.sh`'s frame list is `:L53-L56` and holds four
  frames, its Mac reading `:L57-L60`, its runner reading `:L61-L64`; `nozoki@b75348f` removed
  `LaunchFlow.run()` from the list. QC-62 cites each at `nozoki@7c7038f`, as C-I3 does, says the
  five-frame match was the list the script carried at `nozoki@37a962d`, and carries C-I3's second
  runner reading (run 36795836747), cited to the SDD and not re-measured here. § 9's Swift 6
  migration-cost sentence moves `LaunchFlow.swift:L53` to `:L60`; `ReadRunning.swift:L28` still
  names `deliver` and stands. Earlier Review Notes that cite the old lines are dated accounts and
  stand as history. Whether this re-pointing is taken is the owner's: § 2.1 of
  `docs/architecture_open_issues.md` asks it. **No record.** ADR-0013's Context reads "each
  exported from the build in which a slice lands it"
  (`docs/adr/0013-sandboxed-single-process-read-pipeline.md:L46-L47`). It is not superseded: the
  staging grain is cheap to reverse before `v1.0.0`, so it fails the first gate, and the decision
  the record makes — one process, one closed seam — does not move with it. A reader who meets the
  slice wording there finds here where it moved. ADR-0012 carries QC-62's old citations and is
  Accepted, so it is not edited; QC-62 is where the current lines live. The index does not move.
  **What moved beneath this document.** `git log 9228dce..HEAD` over the seven inputs lists SDD
  v21 and v22 and DESIGN v11 to v13. SDD v21 moved § 6 `open-a-folder` and § 5 E-1, and DESIGN
  v11 to v13 moved the realisation in AppKit, the title bar and the application icon; no entry here
  cites the window's widths, the title bar or the icon (`grep -n -i 'minimum width\|title
  bar\|application icon' docs/nfdr.md` printed nothing before this note was written), so none
  moves for them. SDD v22's SM-4,
  C-R7 and C-I3 moves are the ones folded above. Every input's `Status:` line was re-read and is
  Settled, so `Inputs read:` stands. No `QC` is added, renumbered or reused *(re: header `Status:`,
  `Version:`; QC-2; QC-24; QC-62; § 9 `nozoki-mac` bullet; § 10 QC-2 row; source:
  `docs/trail/architecture/cycle-18.md` §§ 2.1, 3.1; `docs/trail/architecture/self_answer-22.md`;
  `docs/SDD.md` § 4 C-R7, C-I3 at v22, RN-76; `docs/trail/sdd/cycle-17.md` §§ 2.1, 5.1;
  `nozoki@7c7038f`, `nozoki@b75348f`, `nozoki@a954a90`)*
- **RN-33:** *(v22 — the close: the cycle-19 fold, § 2.1 confirmed with two additions)* **The
  fold.** The companion at intake held one answered choice, § 2.1, decided in the owner's seat by a
  `companion-self-answer` run (`docs/trail/architecture/self_answer-23.md` § 2.1); it was copied
  whole before this fold as `docs/trail/architecture/cycle-19.md`. The answer confirms QC-62 as v21
  drafted it and adds two corrections; with both folded nothing is open, and the companion is
  removed. **QC-62 does not move.** **§ 9 — addition (1).** RN-32 moved the measured site
  `LaunchFlow.swift:L53` to `:L60`, and that named a different closure: at `nozoki@6e1d79f`, where
  the cost was measured, `:L52-L53` is the `listTree` closure, `{ Self.listing(at: path, through:
  bridge) }`, and at `nozoki@7c7038f` that closure is `:L106-L107`; `:L60` is the closure
  `chooseFolder()` hands to `openAndList`, and `:L110-L111` the `selectFile` closure, both added
  after the measurement (read this fold with `git show` at both commits;
  `nozoki-mac/Sources/Shell/` is byte-equal between `7c7038f` and `HEAD`, `git diff --stat 7c7038f
  HEAD -- nozoki-mac checks` printing nothing). The sentence now names all three sites and
  `ReadRunning.swift:L28`, which stands (`:L28`, `MainActor.assumeIsolated { deliver(listing) }`).
  That all three fail Swift 6 mode is the answer's measurement — Apple Swift 6.4, a copy of
  `nozoki-mac` at `nozoki@7c7038f`, `swift build --target Shell -Xswiftc -swift-version -Xswiftc 6`
  failing at exactly those three lines, and the cycle-17 method (tools 5.9, `StrictConcurrency` on
  `Surfaces` and `Shell`) warning at the three and at `ReadRunning.swift:L28`
  (`self_answer-23.md` § 2.1) — cited and not re-run by this fold. **ADR-0012 — addition (2).**
  RN-32's reason for leaving ADR-0012 alone — that it is Accepted — does not hold: the owner's
  ruling makes a citation repair an edit to an ADR's own prose, as a pin, with no superseding record
  (`docs/trail/architecture/cycle-3.md` § 3.1, answers (1) and (3)). ADR-0012's four unpinned
  citations — `nozoki-mac/Sources/Shell/LaunchFlow.swift:L35-L37` in § Decision and
  `checks/renderer.sh:L44-L57`, `:L58-L61` and `:L62-L65` in § Consequences — are each pinned to
  `nozoki@ab39502:` in two dated in-place notes and a *Traces to* bullet. Read this fold at
  `nozoki@ab39502`: `LaunchFlow.swift:L35-L37` is `panel.chooseFolder()` followed by
  `bridge.openFolder(location:)`, and `checks/renderer.sh` carries § *THE FRAMES* at `:L44`, the
  five-frame list ending at `:L57`, the Mac reading at `:L58-L61` and the runner reading at
  `:L62-L65`. The record's Status, decision, alternatives and binding are untouched, so the index
  does not move. RN-32 stands as the dated account of v21. **What moved beneath this document.**
  `git log c5f3a59..HEAD` lists only the answer's own commit, `nozoki@cb10c34`; every input's
  `Status:` line was re-read and is Settled, so `Inputs read:` stands. No `QC` is added,
  renumbered or reused *(re: header `Status:`, `Version:`; § 9 `nozoki-mac` bullet; ADR-0012
  § Decision, § Consequences, § Traces to; source: `docs/trail/architecture/cycle-19.md` § 2.1;
  `docs/trail/architecture/self_answer-23.md` § 2.1; `docs/trail/architecture/cycle-3.md` § 3.1;
  `nozoki@6e1d79f`, `nozoki@7c7038f`, `nozoki@ab39502`)*
- **RN-34:** *(v23 — the cycle-20 fold, §§ 3.1 and 3.2 answered; two drafts for the owner's
  confirm)* **The fold.** The companion at intake held two answered downstream items, §§ 3.1 and
  3.2, raised by the PM and decided in the owner's seat by a `companion-self-answer` run
  (`docs/trail/architecture/self_answer-24.md`), and one unanswered choice, § 2.1, raised by that
  same run; it was copied whole before this fold as `docs/trail/architecture/cycle-20.md`.
  **§ 3.1 → QC-3.** The tail no longer says the one-time review is owed. Re-verified for this fold,
  not taken from the answer: `git show --stat 85d9fa7` lists `Cargo.lock`, `checks/deps.allow`,
  `checks/deps.review.md` and `crates/nozoki-core/Cargo.toml`; at that commit the list's `cargo:`
  section holds 40 names and the record 40 rows, and `comm -3` of the two name sets prints
  nothing; `bash checks/no-network.sh` on `HEAD` prints "ok — 40 cargo names match
  checks/deps.allow". The answer's three additions are folded as written: the record is cited
  pinned to `nozoki@85d9fa7`, because its title goes stale at the next added name; the dated
  clause "At `nozoki@0aca57e` the list is one `cargo:` section of 17 names" stays as history, with
  the current count beside it; and RN-25 is left as written, its "still owed" being the dated
  account of v14 that this note closes, as RN-18 left RN-4's, RN-7's and RN-16's dated mentions. One word beyond the
  answer, under the same authority: the dated clause's "no record shows the review" becomes "until
  `nozoki@85d9fa7` no record showed the review", because in the present tense it is now false.
  **§ 3.2 → QC-30 half (2) and § 9.** The exception names the package's build script — the file the
  `build` key of the registry copy's `Cargo.toml` names, `build.rs` at the root by default — per
  Cargo's manifest reference (https://doc.rust-lang.org/cargo/reference/manifest.html, § The
  `build` field), and excepts nothing where the key is `false` or the default file is absent.
  Re-measured for this fold over the 32 registry crates `cargo tree -p nozoki-bridge --target
  aarch64-apple-darwin -e normal --locked --offline` resolves: 17 name a script (`tree-sitter` →
  `binding_rust/build.rs`; the six grammars → `bindings/rust/build.rs`; ten → `build.rs`), 14 set
  `false`, and `streaming-iterator` sets no key and has no root `build.rs`. A grep of the 17
  scripts for `mod …;`, `#[path` and `include!` prints nothing, which is the ground for the entry's
  *Not covered* sentence. `Cargo.lock` is unchanged between `nozoki@85d9fa7` and `HEAD` (`git diff
  --stat 85d9fa7 HEAD -- Cargo.lock` prints nothing). § 9's bullet changes "a dependency's root
  `build.rs`" to "a dependency's build script", as the answer's addition (2) directs; its own
  "outside each crate's `build.rs`", about the product's crates, is not in the answer and stands.
  RN-24's mention is dated history and stays. The § 10 row carries no exception and does not move
  (the answer's addition (3)).
  **§ 2.1 → QC-30 half (2), drafted.** No owner answer stands behind this yet. The command half
  (2) names also names `nozoki-bridge v0.0.0 (…/crates/nozoki-bridge)` and `nozoki-core v0.0.0
  (…/crates/nozoki-core)` — re-run for this fold — and neither has a registry copy, so a script
  written to the entry's words failed every build before reading a dependency. Half (1) already
  holds both crates by name. The entry now scans only crates from outside the workspace and skips
  members by membership, not by a name list, which keeps every other unopenable crate a failure.
  This is the reading the entry's own "**(2) The linked dependency tree**" gives, but it changes
  what the check does, so it is drafted and put to the owner: `docs/architecture_open_issues.md`
  § 2.1.
  **What moved beneath this document, and ADR-0017.** `git log cc351c8..HEAD` over the seven inputs
  lists SDD v23 (`nozoki@e81a386`) and UXD v11 (`nozoki@24d652b`). UXD v11 moved UX-U1, the reader
  floor; `grep -n 'UX-U1' docs/nfdr.md` printed nothing before this note was written, so nothing
  here moves for it. SDD v23 names the grammar engine — tree-sitter, its runtime,
  `tree-sitter-highlight` and one grammar crate per floor language, built from C into `nozoki-core`
  (`docs/SDD.md:L327`) — and adds § 9 TO-11 (`:L2252-L2265`), § 11 R-14 (`:L2566`) and two
  sentences to § 3's units paragraph (`:L339-L341`). TO-11 is a § 9 trade-off, one of the three
  surfaces a record is found on, so it was walked through the gates. It is surprising without its
  context — a core whose own source forbids `unsafe` parses the folder's bytes in C — and it was a
  real trade-off, with hand-written lexers and `syntect` weighed and ruled out
  (`nozoki@85d9fa7:checks/deps.review.md` § *The engine chosen*). Whether it is hard enough to
  reverse is the one gate two architects could read differently: TO-11 says undoing it rewrites
  one part and moves no seam, which is the argument for no record, and the rewrite is six
  grammars' worth of lexing or a second engine's vendored syntaxes, which is the argument for one.
  ADR-0017 is written at **Proposed** and the call is put to the owner at
  `docs/architecture_open_issues.md` § 2.2. It binds QC-9, QC-26 and QC-30, whose trace tags now
  name it. **QC-9** gains the limit SDD § 3 now states beside the same claim — *no `unsafe`* is
  said of each crate's own Rust source, and the C the core links is outside it — with the sandbox
  named as what bounds a fault there (SDD § 11 R-14). `grep -c -E '^name = "(git2|libgit2-sys)"'
  Cargo.lock` prints `0`, so the entry says libgit2 is linked "when `git-reader` links it", not
  now. That limit traces to SDD § 3 and stands whether or not ADR-0017 is confirmed. R-14 adds no
  check, and none is added here: its *Not covered* — no sanitizer run and no hostile corpus for the
  engine, no bound on a parse — is the SDD's, stated there, and an entry here would be a
  requirement with no upstream sentence. Every input's `Status:` line was re-read and is Settled,
  so `Inputs read:` stands. No `QC` is added, renumbered or reused *(re: header `Status:`,
  `Version:`; QC-3; QC-9; QC-26; QC-30; § 9 `checks/structure.sh` bullet; ADR-0017; source:
  `docs/trail/architecture/cycle-20.md` §§ 2.1, 3.1, 3.2;
  `docs/trail/architecture/self_answer-24.md` §§ 3.1, 3.2; `docs/SDD.md` § 3, § 9 TO-11, § 11
  R-14, RN-80 at v23; `nozoki@85d9fa7`, `nozoki@e81a386`)*
- **RN-35:** *(v24 — the close: the cycle-21 fold, §§ 2.1 and 2.2 confirmed with an addition
  each)* **The fold.** The companion at intake held the two v23 drafts, both answered in the
  owner's seat by a `companion-self-answer` run (`docs/trail/architecture/self_answer-25.md`) and
  committed at `nozoki@e49b34e`; it was copied whole before this fold as
  `docs/trail/architecture/cycle-21.md`. Nothing is left unresolved, so the companion is removed
  and `Status:` is Settled.
  **§ 2.1 → QC-30 and QC-58.** The draft stands: half (2) scans only crates from outside the
  workspace and skips a member by membership. The addition is folded as written. The workspace's
  members are a glob, `members = ["crates/*"]` (`Cargo.toml:L8`, re-read for this fold), so a
  crate created under `crates/` is a member with no manifest edit. Half (2) would skip it, and
  half (1) named three units, so it fell in neither half. Half (1) now names every workspace member
  and keeps `nozoki-core` and `nozoki-bridge` as today's examples. Its *verified by* points at the
  scope § 9's `checks/structure.sh` bullet already gives the script, "the product crates' sources
  outside `crates/*/tests/`", so that rule does not grow. Neither `checks/structure.sh` nor
  `checks/entry-points.sh` is on the tree yet (`ls checks/`, this fold), so no script moves. The
  entry sets each script's scope for the change that lands it, and until then the gate is
  `development-design` reading the entry, as the header says. One phrase beyond the answer, under
  the same authority: QC-58 called its units "the two crates and `nozoki-mac`" and says its halves
  follow QC-30's, so it now reads "every workspace member (QC-30 half (1)) and `nozoki-mac`". Left
  as it was, it would have named a smaller set than the entry it follows. § 10's two QC-30 rows
  name no crate and do not move.
  **§ 2.2 → ADR-0017.** The record is Accepted. Before acceptance, while it was still Proposed, it
  took the one edit the answer's addition directs: the "record and not a note" sentence in
  § Consequences now rests on the two grounds the answer names, both from facts the record and the
  log already held. The first is ADR-0004, which records libgit2 with a cheaper undo
  (`docs/adr/0004-git-read-through-libgit2-behind-a-port.md:L50-L51`, re-read). The second is that
  the record is the only append-only home for why C parses the adopter's bytes in the
  no-`unsafe` core. Its last `## Traces to` bullet now names the answer, not the pending item. The
  index row follows. QC-9's, QC-26's and QC-30's trace tags already name ADR-0017 and do not move.
  **Inputs.** `git log d7f31fa..HEAD` over the seven inputs prints nothing, and every input's
  `Status:` line was re-read and is Settled, so `Inputs read:` stands. No `QC` is added,
  renumbered or reused *(re: header `Status:`, `Version:`; QC-30; QC-58; ADR-0017; the ADR index;
  source: `docs/trail/architecture/cycle-21.md` §§ 2.1, 2.2;
  `docs/trail/architecture/self_answer-25.md` §§ 2.1, 2.2; `Cargo.toml:L8`)*
- **RN-36:** *(v25 — the close: the cycle-22 fold, § 3.1 answered)* **The fold.** The companion
  at intake was opened by the PM, not by a `product-architecture` run, with one item raised from
  downstream (`nozoki@b15a89a`). It was answered in the owner's seat by a `companion-self-answer`
  run (`docs/trail/architecture/self_answer-26.md`) and committed at `nozoki@fdaa957`, and was
  copied whole before this fold as `docs/trail/architecture/cycle-22.md`. Nothing is left
  unresolved, so the companion is removed and `Status:` is Settled.
  **§ 3.1 → QC-14.** QC-14 said `checks/` is "never a dependency of `nozoki-core`, `nozoki-bridge`
  or `nozoki-mac`", with no shipped/unshipped line, and `crates/nozoki-core/tests/walk.rs:L6-L7`
  compiles `checks/walk.rs` into a `nozoki-core` test target by `#[path]`. The answer reads the
  entry as its two sources already do — ADR-0016 "never a dependency of a shipped unit"
  (`docs/adr/0016-physical-unit-set-core-bridge-mac-checks.md:L40-L41`) and SDD § 3
  `read-only-harness` "Being a dependency of any shipped unit" (`docs/SDD.md:L332`), both re-read
  for this fold — so QC-14 had dropped the qualifier in transcription, and the entry was the copy.
  The first clause now says "any shipped unit" and names the three units as the artifacts that
  ship. The site conforms: Cargo compiles a `tests/` file as its own crate over the library's
  public API, so the edge runs `checks` → `nozoki-core`, the direction QC-14 allows, and § 9's
  `checks/structure.sh` scope bullet already keeps `crates/*/tests/` out of every rule of the
  script, this one included. The trace tag names this note. § 10's QC-9 – QC-14 row needs no new
  command and does not move.
  **Not covered, named so it is not read as coverage.** A `#[path]` or `include!` from a unit's
  shipped source under `src/` into `checks/` would make `checks/` a dependency of a shipped unit
  and break QC-14. No such site exists — `grep -rn '#\[path\|include!' crates/` finds this test
  target and two `#[cfg(test)]` sites into `tests/common/` (`crates/nozoki-core/src/lib.rs:L18-L19`,
  `crates/nozoki-bridge/src/lib.rs:L10-L11`), re-run for this fold — so, per the answer, no rule
  of `checks/structure.sh` is owed for it until one occurs.
  **Inputs.** `git log a7e4445..HEAD` over the seven inputs prints nothing, and every input's
  `Status:` line was re-read and is Settled, so `Inputs read:` stands. No record is written or
  restatused, and no `QC` is added, renumbered or reused *(re: header `Status:`, `Version:`;
  QC-14; source: `docs/trail/architecture/cycle-22.md` § 3.1;
  `docs/trail/architecture/self_answer-26.md` § 3.1; `crates/nozoki-core/tests/walk.rs:L6-L7`)*
- **RN-37:** *(v26 — the cycle-23 fold, §§ 3.1 – 3.4 answered; one draft for the owner's
  confirm)* **The fold.** The companion at intake was opened by the PM, not by a
  `product-architecture` run, with four items raised from downstream after `checks/structure.sh`
  and its suite landed (`nozoki@463acb9`, opened at `nozoki@c308b2f`). All four were answered in the
  owner's seat by a `companion-self-answer` run (`docs/trail/architecture/self_answer-27.md`), which
  also raised one unanswered choice, § 2.1; the companion was committed at `nozoki@b083f99` and
  copied whole before this fold as `docs/trail/architecture/cycle-23.md`. § 2.1 stays open, so the
  companion is rewritten with it alone and `Status:` is Draft. Every fact below was re-measured at
  `nozoki@b083f99`, not taken from the answers; `git diff --stat 463acb9 b083f99 --
  .github/workflows/ci.yml checks crates` prints nothing, so the pins to `nozoki@463acb9` hold.
  **§ 3.1 → the header and § 10.** Executability is tied to each rule, not to its script: a rule a
  command names becomes executable in the change that adds it to the command. Which rules
  `checks/structure.sh` holds is cited from its header (*THE SCAN TABLE* at `:L35`, *WHAT IS NOT
  HELD* at `:L86-L93`) and not copied, the shape QC-62 already takes for `checks/renderer.sh`'s
  frame list, because a copied list goes stale at the next rule added and that change touches no
  NFDR. The answer's addition is folded into § 10's preamble as one sentence: a row's `CI build`
  holds only for the rules its command already holds, and `development-design` is the gate for the
  rest. No row is edited one by one for this. QC-20's row is the plainest case, since the script
  is its only command and the script does not hold QC-20.
  **§ 3.2 → § 9's `checks/tests/` bullet and § 10.** `ls checks/tests` lists seven `test_*.sh`,
  and the bullet's own loop over `ci.yml` prints nothing, so all seven are on steps. The count is
  now seven, and every step is cited pinned to `nozoki@463acb9` at the lines the answer gives,
  re-read with `cat -n .github/workflows/ci.yml`. The bullet's opening citation of
  `Bundle probe suite` moves from `:L35-L36`, which at HEAD is `nozoki-mac/assemble.sh`, to
  `:L41-L42` under the same pin. § 10's preamble points at § 9 for the count and no longer repeats
  it: the count went stale in two places because it was written in two. `(suite
  test_structure.sh)` is added to the nine § 10 rows that name `checks/structure.sh`, all nine
  the item lists, because § 10's rule is per script. The preamble says the tag does not reach a
  rule the script does not hold, which keeps § 3.1's line.
  **§§ 3.3 and 3.4 → § 9's `checks/structure.sh` bullet, decided together.** A module declared in
  `src/` is judged by the file that holds its body, so the scope stays by file path. A body loaded
  through `#[path]` from `crates/*/tests/` is outside every rule, and an inline `#[cfg(test)]`
  module under `src/` stays inside every rule, which `test_inline_test_module_is_scanned` holds
  (`checks/tests/test_structure.sh:L761`). The two test-only sites are named
  (`crates/nozoki-core/src/lib.rs:L18-L24`, `crates/nozoki-bridge/src/lib.rs:L10-L16`, both
  re-read), and so are their bodies' `std::fs` and `std::process` imports, which a reading by
  module would turn into QC-36 and QC-15 findings on the tree as built. The escape's reason now
  says the tree holds no *shipped* site. The escape stays a review catch at `development-design`,
  and no grep rule is owed until a shipped site appears, by RN-19's own terms. The bullet states
  that the two answers rest on each other, and cites the script's header for the gap
  (`checks/structure.sh:L101-L102`).
  **§ 2.1 → § 9's `nozoki-mac` bullet, drafted.** No owner answer stands behind this yet. Two
  pointers in the *Toolchain* clause moved with the same six-line shift. `:L29` named
  `nozoki-mac/assemble.sh` and at HEAD is `run: checks/structure.sh`. The step is now cited `:L35`
  at `nozoki@463acb9`. The *no `swift --version` step* range `:L22-L29` is now `:L22-L35` under the
  same pin, with the whole-file grep beside it, which prints nothing. The draft is put to the owner
  at `docs/architecture_open_issues.md` § 2.1. If overridden, the clause keeps a pointer to the
  wrong step; nothing is gated on it.
  **What moved beneath this document.** `git log 3bbc6ce..HEAD` over the seven inputs lists SDD
  v24 (`nozoki@542dc1c`), UXD v12 (`nozoki@5b3040e`) and three DESIGN folds (`nozoki@51148f9`,
  `nozoki@d234b57`, `nozoki@cec2b7d`). UXD v12 corrects its layout-reference inventory and "changes
  no experience requirement" (`docs/SDD.md:L2673`, § 12, citing `docs/UXD.md` RN-32). The DESIGN folds
  are a gutter padding, a pending path line and the path text's placement. None is named by any
  entry here: `grep -n -i 'gutter\|path line\|path text\|layout-reference' docs/nfdr.md` matched
  nothing above the Review Notes, so nothing moves for them. SDD v24 names one exception on § 3's
  `surfaces` row: a surface may draw that an intent it raised has not been answered yet. It also
  says `stopped` is established in two places, the model and `mac-shell` at SM-4's return
  (`docs/SDD.md` § 3, § 4 C-I1, C-E1, RN-82, RN-83). § 9's layer-4 row said "a view is drawn from a
  projection and from nothing else", the phrase SDD § 6 `open-a-folder` now reads with that
  exception, so the row points at the exception and says, as the SDD does, that the reading adds
  no test. QC-4 and QC-51 do not move. The gap carries no marker, no count and no "nothing
  changed", so QC-4's clause holds. QC-4 speaks of reads the model holds. QC-51's layer-4 check
  renders a `stopped` projection whichever side established it. QC-13 already has every bridge
  function catch a panic and return a failure value. What the SDD records about the tree's
  handling of a no-verdict answer is read against C-E3, the CDO's, and no entry here is written on
  it. Every input's `Status:` line was re-read and is Settled, so `Inputs read:` stands. No record
  is written or restatused, and no `QC` is added, renumbered or reused *(re: header `Status:`,
  `Version:`, the executability sentence; § 9 the layer-4 row, the `checks/structure.sh`,
  `checks/tests/` and `nozoki-mac` bullets; § 10 preamble and nine rows; source:
  `docs/trail/architecture/cycle-23.md` §§ 2.1, 3.1 – 3.4;
  `docs/trail/architecture/self_answer-27.md` §§ 3.1 – 3.4; `docs/SDD.md` v24 § 3 `surfaces`, § 4
  C-I1, RN-82; `checks/structure.sh:L35-L102`; `.github/workflows/ci.yml` at `nozoki@463acb9`)*
- **RN-38:** *(v27 — the close: the cycle-24 fold, § 2.1 confirmed)* **The fold.** The companion
  at intake held one choice, § 2.1, which this document's v26 fold had drafted (RN-37). It was
  confirmed in the owner's seat by a `companion-self-answer` run
  (`docs/trail/architecture/self_answer-28.md` § 2.1) and committed at `nozoki@a3d0e1e`, then
  copied whole before this fold as `docs/trail/architecture/cycle-24.md`. That trail file is now
  where RN-37's pointer to `docs/architecture_open_issues.md` § 2.1 reads, because the companion
  is removed. **§ 2.1 → § 9's `nozoki-mac` bullet.** The clause stands as v26 drafted it. Its
  two *drafted at v26* markers now also name the confirmation, in the form the same bullet's
  v15 correction takes (RN-27). This fold re-measured the answer's facts at HEAD
  `nozoki@a3d0e1e` instead of taking them from it. `git diff --stat 463acb9 HEAD --
  .github/workflows/ci.yml` prints nothing, so the pin reads today's file. In that file `:L26` is
  `cargo test --workspace --locked && swift test --package-path nozoki-mac`, `:L28-L32` are
  `Structure check` and `Structure check suite`, and `:L35` is `run: nozoki-mac/assemble.sh`.
  `grep -n 'swift --version' .github/workflows/ci.yml` prints nothing and exits 1. At
  `nozoki@0aca57e`, `:L29` is `run: nozoki-mac/assemble.sh`, so the dated history the clause keeps
  is true. `nozoki@463acb9` is a merge commit on `main`, so the pin stays reachable. ADR-0012's
  unpinned `ci.yml` citation does not move: a line pointer is no change of decision
  (`self_answer-28.md` § 2.1, check 3). **What moved beneath this document.** `git log
  7ef2386..HEAD` lists only the answer's own commit, `nozoki@a3d0e1e`. Every input's `Status:`
  line was re-read and is Settled, so `Inputs read:` stands. No record is written or restatused,
  the index does not move, and no `QC` is added, renumbered or reused *(re: header `Status:`,
  `Version:`; § 9 `nozoki-mac` bullet; source: `docs/trail/architecture/cycle-24.md` § 2.1;
  `docs/trail/architecture/self_answer-28.md` § 2.1; `.github/workflows/ci.yml` at
  `nozoki@463acb9`, `nozoki@0aca57e` and `nozoki@a3d0e1e`)*
- **RN-39:** *(v28 — the close: the cycle-25 fold, § 3.1 answered)* **The fold.** The companion
  at intake held one item, § 3.1, raised from downstream by the PM on 2026-10-03 after
  `checks/entry-points.sh`, `checks/entry-points.allow` and `checks/tests/test_entry_points.sh`
  landed at `nozoki@b158052`. It was answered in the owner's seat by a `companion-self-answer` run
  (`docs/trail/architecture/self_answer-29.md` § 3.1), committed at `nozoki@6dae2ca`, and copied
  whole before this fold as `docs/trail/architecture/cycle-25.md`. Both halves are corrections:
  § 10's own rule and § 9's own pinned count read false against the tree. **§ 3.1 (a) → § 10's
  QC-30 / QC-58 linked-tree row** gains `(suite test_entry_points.sh)`, as § 10's preamble
  requires of a row naming a script that has a suite. The suite drives the real script against
  the allow list (`checks/tests/test_entry_points.sh:L8-L17`), so the tag stays inside what the
  script holds. **§ 3.1 (b) → § 9's `checks/tests/` bullet** counts eight suites, re-pinned to
  `nozoki@b158052`, and the seven-suite sentence moves into the bullet's dated history beside the
  v25 six. The verified-by tail gains this fold's re-run. **Re-measured at HEAD `nozoki@6dae2ca`,
  not taken from the answer.** `git diff --stat b158052 HEAD -- .github/workflows/ci.yml checks/`
  prints nothing. `ls checks/tests` lists eight `test_*.sh`. `ci.yml`'s `run:` lines `:L32`,
  `:L38`, `:L48`, `:L54`, `:L65`, `:L74`, `:L80` and `:L83` are the eight suites, with each
  step's `name:` on the line above. The bullet's loop prints nothing, and
  `grep -nE 'continue-on-error|^[[:space:]]+if:' .github/workflows/ci.yml` exits 1. **The
  hosted-runner record — the answer's addition, and one correction beyond it.** The answer asked
  the fold to write the entry-points pair's state the way the bullet wrote it for the five
  earlier suites. Writing it beside that paragraph showed the paragraph stale. It recorded the
  five as not yet run at `nozoki@c26d47c`, and promised that the first push carrying them would
  be their reading and that this bullet would record it. That push happened and was never
  recorded: `git merge-base --is-ancestor ab39502 c79270f` exits 0, the same test against
  `37a962d` exits 1, and run 36034875098 on `nozoki@c79270f` reads `success` on every suite step.
  The 2026-09-24 paragraph stays as dated history, and the v28 sentence after it records the
  reading. The same measurement shows `Structure check` and `Structure check suite`, which landed
  at `nozoki@463acb9`, also unread: `git merge-base --is-ancestor 463acb9 origin/main` exits 1,
  and run 36958237363 on `nozoki@d234b57` lists neither step. So the sentence names the four
  pending steps, not two. This goes beyond the answer's words. It applies the bullet's own rule,
  "this bullet records it", and makes no new decision: nothing is moved, quieted or reclassified.
  Two failed runs since, 36761379052 and 36769305658, failed at `Test gate`, not at a suite step,
  so they change no suite's reading. **What moved beneath this document.** `git log
  f8fb6d8..HEAD` lists the entry-points change merged at `nozoki@b158052`, the PM's two companion
  openings, and SDD v25 (`nozoki@0670083`). SDD v25 moves only § 3's `read-only-harness` *Owns*
  cell (SDD RN-84). This document cites that row for its *Must not own* cell in § 1, and by name
  in two trace tags, one in § 2 and one in § 9. None of the three moves: the *Must not own* cell
  is unchanged, and the row still holds every script those tags name. SDD RN-84 names § 9's count and § 10's row as owed here, which is
  this fold. Every input's `Status:` line was re-read and is Settled, so `Inputs read:` stands.
  No record is written or restatused, the index does not move, and no `QC` is added, renumbered
  or reused. § 9's tail ground, `ls checks/*.sh` at `nozoki@ab39502`, stays true at its pin and
  is not re-pinned *(re: header `Status:`, `Version:`; § 9 `checks/tests/` bullet; § 10 QC-30 /
  QC-58 linked-tree row; source: `docs/trail/architecture/cycle-25.md` § 3.1;
  `docs/trail/architecture/self_answer-29.md` § 3.1; `.github/workflows/ci.yml` at
  `nozoki@b158052` and `nozoki@6dae2ca`; GitHub Actions runs 36034875098, 35988399477 and
  36958237363; `docs/SDD.md` v25 RN-84)*
- **RN-40:** *(v29 — the cycle-26 fold, § 3.1 answered; one draft for the owner's confirm)*
  **How the companion came to exist.** As at RN-26 and RN-39, no `product-architecture` run opened
  it. The NFDR was Settled at v28 with no companion on disk. The PM opened it on 2026-10-03
  (`nozoki@bf9b90c`) after `checks/structure.sh` gained the unit-graph rules (`nozoki@8c3ab40`),
  with one item raised from downstream, § 3.1. A `companion-self-answer` run answered § 3.1 in the
  owner's seat and appended § 2.1 in the bucket *Choices to confirm*, with its slot empty
  (`nozoki@803b599`; its reasoning, `docs/trail/architecture/self_answer-30.md`). As answered, the
  companion is `docs/trail/architecture/cycle-26.md`. **§ 3.1 → QC-11's trace.** The answer is
  reading (a): QC-11 stands as written and the `fs-reader` → `folder-model` edge goes. QC-11's
  text and QC-10's "neither imports the model" do not move. The trace now records the reading of
  SDD SM-1 the answer fixed, and where the clause is held from. The answer's ground was re-read
  at `nozoki@803b599`, not taken from it. `docs/SDD.md:L415` gives SM-1's owner as the model,
  which "states what a read must return"; `:L416` says SM-2's port "is a trait the model owns";
  `:L347-L348` is the units paragraph QC-11 transcribes. `fs_reader.rs:L14` is
  `use crate::folder_model::OpenFailure;`, `folder_model.rs:L38` defines the type, and
  `folder_model.rs:L6` imports the other SM-1 types from `fs_reader`, which QC-10 allows.
  `lib.rs:L10-L12` re-exports `OpenFailure` from `folder_model`, and
  `crates/nozoki-bridge/src/session.rs:L9` imports it as `nozoki_core::OpenFailure`, so a move
  that keeps the re-export leaves the bridge alone. `checks/structure.sh` *WHAT IS NOT HELD*
  names the clause and its site, and that stays true until the move lands. No SDD change is owed:
  SM-1 already says what is true under (a), and that judgment is the answer's. **§ 2.1 → QC-63,
  drafted.** The item was raised by the self-answer run, not asked of it, so no answer authorizes
  it. This run drafts it into the records the way RN-26 drafted the item that run raised, and it
  stays in the companion for the owner's confirm. Re-measured at `nozoki@803b599`:
  `folder_model.rs:L8`, `fs_reader.rs:L15` and `highlighter.rs:L13` each import `crate::language`.
  No allowed set in § 1.2 names it, and the only permission is `checks/structure.sh`'s carve-out
  for lib.rs, language.rs and error.rs, which "belong to no unit, are never a subject, and
  importing it is never an edge". `language.rs` and `error.rs` import no part: their one
  crate-relative line each, `language.rs:L43` `use crate::Language;` and `error.rs:L26`
  `use super::Error;`, is inside a test module and names their own type. So the draft is true of
  the tree today, and the one rule it adds to `checks/structure.sh` would raise nothing on it. The
  draft goes one step beyond the item's wording. It names `lib.rs` as neither a part nor a value
  module, because `lib.rs:L9-L15` re-exports from every module and would fail the rule otherwise.
  It also states the no-I/O half as QC-15's, whose scan already reads every Rust I/O primitive
  against its owner, so no second check is invented for it. The ground is that SDD § 3 names the
  core's parts and no module beside them, and "never inferred" in § 1.2's lead. So this is a
  derivation an SDD reader could make another way: move `language` into a part, and name the
  import the move needs. That is why it is a confirm and not a settled entry. **What moved beneath
  this document.** `git diff --stat e2b74bb 803b599` lists `checks/structure.sh`,
  `checks/tests/test_structure.sh`, the companion and the self-answer report, and nothing under
  `crates/`, `.github/` or the upstream documents. `ls checks/tests` still lists eight suites, so
  § 9's count stands. Every input's `Status:` line was re-read and is Settled, so `Inputs read:`
  stands. QC-63 is the one new ID. No `QC` is renumbered or reused, no record is written or
  restatused, and the index does not move *(re: header `Status:`, `Version:`; § 1.2 lead; QC-11;
  QC-63; § 10 QC-63 row; source: `docs/trail/architecture/cycle-26.md` §§ 2.1, 3.1;
  `docs/trail/architecture/self_answer-30.md`; `crates/nozoki-core/src/` and
  `checks/structure.sh` at `nozoki@803b599`; `docs/SDD.md` § 3)*
- **RN-41:** *(v30 — the close: the cycle-27 fold, § 2.1 confirmed with an addition)* **The fold.**
  The companion at intake held one item, § 2.1, the QC-63 draft RN-40 wrote for the owner's
  confirm. A `companion-self-answer` run answered it in the owner's seat
  (`docs/trail/architecture/self_answer-31.md` § 2.1), committed at `nozoki@61295fb`, and copied
  whole before this fold as `docs/trail/architecture/cycle-27.md`. The verdict is *confirm, with
  one addition*, and it also corrects one reason. **The addition → QC-63's *verified by:* and
  § 10's closing list.** "Holds types and values only" had no verification, and this document's
  preamble says an entry with no nameable verification is not yet an entry. No scan reaches it:
  `fs-reader`'s extension map (`docs/SDD.md:L322`), which `highlighter` must not own (`:L327`),
  moved into `language` as a method on `Language` would import no part and do no I/O, so it
  would pass the new `checks/structure.sh` rule and QC-15 while taking owned behaviour out of its
  part. The half is now review at `development-design`, in the form QC-13 takes for its
  delegation half, and the review asks whether a value module holds anything a part's *Owns* cell
  in SDD § 3 names. The tail argues its downgrade in its own words, and § 10's closing list names
  "QC-63 (the types-and-values half)" beside "QC-13 (the delegation half)". QC-63's § 10 row is
  the machine half and stays as v29 wrote it. **The reason corrected → QC-63's trace.** RN-40 said
  the draft was "a derivation an SDD reader could make another way: move `language` into a part,
  and name the import the move needs". At this document's altitude that reading is not open.
  `Language` crosses SM-1 upward, "the floor language named" (`docs/SDD.md:L415`), and QC-11's
  trace, from cycle 26, keeps a type that crosses SM-1 out of `folder-model`. `fs-reader` names
  the language and `highlighter` consumes it, and the units paragraph states exactly two edges
  among the readers, neither between those two (`:L347-L349`). So placing `Language` in a part
  needs an edge the SDD does not state, and stating one would be a change to SDD § 3, the CTO's.
  The positive ground is also the SDD's: "the physical layout is the developer's" (`:L433`), and
  ADR-0016 hands the module boundaries to § 1.2
  (`docs/adr/0016-physical-unit-set-core-bridge-mac-checks.md:L83-L84`). The trace now cites that
  ground in place of "so the reading is this document's". RN-40 is a dated note and stands as it
  was written; this note is the correction. QC-63's obligation does not move. **One pointer runs one
  way, and stays that way.** QC-63 traces to ADR-0016, and ADR-0016's `## Binds` reads "QC-8 –
  QC-17, QC-20" and does not name QC-63. ADR-0016 is Accepted, so this run does not edit it. A
  superseding record written only to add one ID to a list would record no decision, and the
  module boundaries ADR-0016 fixes have not moved. The trace cites the record's own hand-off to
  § 1.2, so a reader can get from QC-63 to the record and back through § 1.2. **Re-measured at
  HEAD `nozoki@61295fb`, not taken from the answer.** `git diff --stat 803b599 HEAD -- crates
  checks .github` prints nothing. The only crate-relative lines in `language.rs` and `error.rs`
  are `language.rs:L43` `use crate::Language;` and `error.rs:L26` `use super::Error;`, both in
  test modules and both naming their own type. `lib.rs:L9-L15` re-exports from all five modules.
  The SDD lines the trace cites read as quoted at `:L322`, `:L327`, `:L347-L349`, `:L415` and
  `:L433`. **What moved beneath this document.** `git log a3caabd..HEAD -- docs/SRS.md docs/SDD.md
  docs/fdr.md docs/PRD.md docs/UXD.md docs/DESIGN.md docs/CONTENT.md crates checks` prints
  nothing. Every input's `Status:` line was re-read and is Settled, so `Inputs read:` stands. No
  `QC` is added, renumbered or reused, no record is written or restatused, and the index does not
  move. Nothing is left for the owner, so the companion is removed and `Status:` is Settled
  *(re: header `Status:`, `Version:`; § 1.2 lead; QC-63; § 10 closing list; source:
  `docs/trail/architecture/cycle-27.md` § 2.1; `docs/trail/architecture/self_answer-31.md` § 2.1;
  `crates/nozoki-core/src/` at `nozoki@61295fb`; `docs/SDD.md` § 3;
  `docs/adr/0016-physical-unit-set-core-bridge-mac-checks.md`)*
- **RN-42:** *(v31 — the close: the cycle-28 fold, § 3.1 answered)* **The fold.** The companion
  at intake was opened by the PM, not by a `product-architecture` run, with one item raised from
  downstream after `fs_reader`'s test body moved under `crates/nozoki-core/tests/unit/`
  (`nozoki@73c408e`, opened at `nozoki@7a8f61d`). A `companion-self-answer` run answered it in the
  owner's seat (`docs/trail/architecture/self_answer-32.md` § 3.1), committed at `nozoki@456098c`,
  and copied whole before this fold as `docs/trail/architecture/cycle-28.md`. The verdict is
  *confirmed with addition*. **§ 3.1 → § 9's `checks/structure.sh` scope bullet.** The bullet named
  two `#[cfg(test)]` `#[path]` sites, and the tree holds three. The third,
  `crates/nozoki-core/src/fs_reader.rs:L894-L896`, is named beside the two `test_support` sites.
  The answer's three additions are folded with it. (1) The sentence that both bodies import
  `std::fs` and `std::process` stays about the two `test_support` bodies and is not widened: the
  third body imports no `std::process`, and its filesystem use sits in `fs-reader`, a file QC-15
  exempts. (2) The findings list is re-measured, not extended by one name. The script gained its
  QC-2 rule at `nozoki@e7f151e`, in the same merge as the body move, so the core's `test_support`
  body raises QC-2 too, and QC-9, whose process clause the script has carried since v1.0.0, was
  missing from the list since v26. (3) The count, the lines and the findings are pinned to a
  commit and the command that prints the sites, `grep -rn '#\[path' crates/*/src`, the form § 9's
  `checks/tests/` bullet already takes for its suite count. The bullet's dated tail records what
  it said through v30. RN-36's "two `#[cfg(test)]` sites" is a dated fold note and stands as
  written. **Re-measured at HEAD `nozoki@456098c`, not taken from the answer.** `git diff --stat
  7a8f61d HEAD -- crates checks .github nozoki-mac` prints nothing, so the answer's measurement at
  `nozoki@7a8f61d` is a measurement of this tree. `grep -rn '#\[path' crates/*/src` prints
  exactly the three sites. The third body's first lines carry no `std::process` import
  (`crates/nozoki-core/tests/unit/fs_reader.rs:L1-L6`), and `:L753` and `:L953` are `fs::write`
  calls. On a throwaway clone, the unmodified `checks/structure.sh` printed `12 Rust files in 2
  crates read — nothing found`. Each `tests/common/mod.rs` body was then copied into its crate's
  `src/`, and the `fs_reader` test body was appended to `fs_reader.rs` so the owner exemption still
  applied to it. The same script then reported QC-2 (nine lines), QC-9 (one), QC-15 (two) and
  QC-36 (one) in `nozoki-core`, and QC-15 (three) and QC-36 (one) in `nozoki-bridge`. The escape
  sentence still holds, because all three sites carry `#[cfg(test)]`. No record names these sites
  (`grep -rnE '#\[path|tests/unit|tests/common|test_support' docs/adr` prints nothing). **What
  moved beneath this document.** `git log 0b62d5f..HEAD -- docs/SRS.md docs/SDD.md docs/fdr.md
  docs/PRD.md docs/UXD.md docs/DESIGN.md docs/CONTENT.md docs/adr` prints nothing. Every input's
  `Status:` line was re-read and is Settled, so `Inputs read:` stands. No `QC` is added,
  renumbered or reused, no record is written or restatused, and the index does not move. Nothing
  is left for the owner, so the companion is removed and `Status:` is Settled *(re: header
  `Status:`, `Version:`; § 9 `checks/structure.sh` scope bullet; source:
  `docs/trail/architecture/cycle-28.md` § 3.1; `docs/trail/architecture/self_answer-32.md` § 3.1;
  `crates/` and `checks/structure.sh` at `nozoki@456098c`)*
- **RN-43:** *(v32 — the cycle-29 fold, §§ 3.1 – 3.5 answered; a re-derivation against SDD v26
  and v27; two items for the owner)* **The fold.** The companion at intake was opened by the PM,
  not by a `product-architecture` run, with five items raised from downstream after `git-reader`
  landed (`nozoki@126ef75`, opened at `nozoki@136b227`). A `companion-self-answer` run answered all
  five in the owner's seat (`docs/trail/architecture/self_answer-33.md`), raised one of them
  upstream, and added two § 2 items whose slots it left for the next round. The answers were
  committed at `nozoki@0955e9e`, and the companion was copied whole before this fold as
  `docs/trail/architecture/cycle-29.md`. **§ 3.1 → ADR-0018, QC-5.** A new record supersedes
  ADR-0005, as the answer ordered. A `.git` file answers `root` from its own content, and the Git
  directory it names is `state()`'s to report. That is SDD § 11 R-3's reading, which FDR R-15 and
  R-21 already follow. `probe` reads only inside the folder, which replaces ADR-0005's "reading …
  nothing" that the adapter never met. QC-5 gains the clause and three named cases, none of them
  written at `nozoki@8edec4f`, so the entry says they go red until the provisional arm is replaced.
  **§ 3.2 → ADR-0019, QC-10, QC-11.** QC-11's trace reads SM-2 as SDD v26 states it, QC-10's
  may-import set gains the types that cross SM-2, and ADR-0004's "owned by the folder model" is
  corrected by the one record that supersedes ADR-0004 for § 3.4 too. **§ 3.3 → QC-15.** The
  `git-reader` clause names its bounded reads outside libgit2. The tail says what the answer
  measured: `checks/structure.sh` does not hold them. It names this document's realization, the
  adapter's file added to the clause's owner files by exact path, and holds the rest at
  `development-design`. **§ 3.4 → ADR-0019, QC-3.** The claim is made of the shipped executable,
  with what the build holds and does not as SDD § 4 C-R6 states them at v26, and a third
  verification half, the `nm` read in `checks/view.sh`, owed by the build that first exports a
  function reaching `git-reader`. **§ 3.5 → QC-9, QC-11, QC-13, QC-17, QC-35, through the SDD.**
  The answer raised the unit question upstream (`docs/SDD_open_issues.md` § 2.1, `nozoki@4f028c7`).
  The SDD folded it at v27 (`nozoki@8edec4f`; its RN-87), in the CTO's seat, after this companion's
  answers were committed. `core-bridge` empties libgit2's four machine-level config search paths
  before the adapter is wired, fails closed, runs once, and is the one exception to the rule that
  only `git-reader` names the binding. Its manifest's `git2` line turns default features off. The
  paths a repository's own config names stay uncovered (SDD § 11 R-16). Each entry SDD RN-87 names
  as owed is re-derived from it, on the new upstream sentences as their authorization: QC-11 (the
  exception), QC-13 and QC-17 (the switch, its bridge test, what the test does not reach), QC-35
  (the switch, three named uncovered cases, and a tail that says no listed check observes a read),
  QC-3 (the manifest clause, held by `checks/tests/test_no_network.sh:L210-L235`), and QC-6 (C-D3's
  uncovered case, which RN-87 did not list and C-D3 now states). **§ 2.1 of the companion, the
  interim QC-35 tail, is overtaken, not answered.** It drafted QC-35 naming the config reads as
  uncovered "until the SDD answers", and its own reasoning said the re-derivation would remove the
  case once the SDD took the bridge reading (`self_answer-33.md` § 2.1, *Check 3*). The SDD took
  that reading, so the interim text is not written. Its addition, that the listed checks observe
  writes and not reads, is a fact of the two scripts and is written into QC-35's tail. The item does
  not re-enter the companion: what it asked is settled by the upstream sentence, and its text
  survives in the trail cycle. **§ 2.2 of the companion → QC-9 now; QC-30 drafted, and re-raised.**
  QC-9's "when `git-reader` links it" becomes "which `git-reader` links", a fact SDD v26 and v27
  § 3 state, at `crates/nozoki-core/Cargo.toml:L9`. QC-30 was left unconfirmed and is drafted here
  differently from the item's proposal, for two reasons this fold measured. First, the item's three
  reads are not the whole set. libgit2's compiled C carries `git__getenv` at more sites. The open
  reaches the three init reads, and `SUDO_UID` only when the effective user is root
  (`fs_path.c:L2030-L2033`). The rest sit behind calls the port does not make, or in `src/cli`,
  which `build.rs` does not compile. The item's open question is closed: `libz-sys`'s zlib-ng file
  is not compiled, because `want_ng` needs a zlib-ng feature (`build.rs:L15-L18`), and the debug
  build's script output links the system `libz` after a `-lz` smoke test
  (`target/debug/build/libz-sys-*/output`). A grep of the C sources of the 37 crates
  `cargo tree -p nozoki-bridge --target aarch64-apple-darwin -e normal --locked` resolves finds
  `getenv` in those two crates alone, and in none of the tree-sitter crates. Second, a class-2 gate
  is a downgrade this document must argue, and the item did not argue it: `checks/entry-points.sh`
  already scans each crate's whole package directory and lists uncompiled reads with their reason
  (the `libz-sys` lines at `checks/entry-points.allow:L30-L31`), so the same scan reading `getenv`
  in C sources is a command with an exit code. The draft names the C read as a member of half (2),
  adds the pattern to the script as this document's realization, and holds the C half at
  `development-design` until the change adds it. The item's class-2 form is the override, at
  `docs/architecture_open_issues.md` § 2.2. **ADR-0016 and the exception → ADR-0020, Proposed, for
  the owner.** ADR-0016 is Accepted and says "only `git-reader` imports the libgit2 binding", which
  SDD v27 no longer says. No owner's answer covers that sentence. The log's two precedents for an
  accepted record that stopped matching are a dated correction in place where only a reason moved
  (ADR-0010 at RN-20; ADR-0016 at cycle 10, § 3.4), each authorized by an answer, and a superseding
  record where the decision moved. Here a rule inside the decision moves. This run drafts the
  supersession, ADR-0020, at Proposed, carrying the unit set and the switch's own alternatives.
  Choosing between that and a correction in place is the owner's, because guessing wrong destroys
  the log's only unique asset; it is § 2.1. ADR-0016 stays Accepted until that answer.
  **Pointers re-pointed.** Every entry trace that named ADR-0004 now names ADR-0019 (QC-3, QC-7,
  QC-10, QC-11, QC-18, QC-26, QC-36, QC-50), and QC-5's ADR-0005 names ADR-0018. Both new records'
  `## Binds` list exactly those entries, plus QC-15 for ADR-0018. Dated notes keep the numbers they
  were written with. **Re-measured at HEAD `nozoki@8edec4f`, not taken from the answers.** `git log
  126ef75..HEAD -- crates checks nozoki-mac .github Cargo.toml Cargo.lock` prints nothing, so the
  answers' measurements at `nozoki@4160b57` and `nozoki@136b227` are measurements of this tree. The
  lines cited read as quoted: `libgit2.rs:L31`, `:L35`, `:L38-L40`, `:L52`, `:L63`;
  `git_reader.rs:L33`; `Cargo.toml:L9`; `root_finding.rs:L158-L169`; `structure.sh:L76-L78`,
  `:L247`, `:L249-L250`, `:L257-L258`; `entry-points.sh:L66`; `grep -n 'nm ' checks/view.sh`
  prints nothing; `grep -n 'GitPort\|git_reader\|RootFinding\|ProbeCondition'
  crates/nozoki-core/src/folder_model.rs` prints nothing. **What moved beneath this document.**
  `git log c6b2fa8..HEAD -- docs/SRS.md docs/SDD.md docs/fdr.md docs/PRD.md docs/UXD.md
  docs/DESIGN.md docs/CONTENT.md` names only the SDD's three commits, v26 at `nozoki@4160b57`, a
  Draft stamp at `nozoki@3cfeb35`, and v27 at `nozoki@8edec4f`. The SDD is Settled at v27, and every
  input's `Status:` line was re-read and is Settled, so `Inputs read:` stands. **Not weighed here,
  and named.** SDD RN-85 names `Security`, `CoreFoundation`, `iconv` and `z` as linked for the
  bridge's static library (`nozoki-mac/Package.swift:L32-L37`), and leaves open whether C-R7 says
  anything about `Security`. QC-8 and QC-23 restate C-R7's link list and do not move until it does.
  No `QC` is added, renumbered or reused. Two items await the owner, so `Status:` is Draft *(re:
  header `Status:`, `Version:`; QC-3, QC-5, QC-6, QC-9, QC-10, QC-11, QC-13, QC-15, QC-17, QC-30,
  QC-35; the traces of QC-7, QC-18, QC-26, QC-36, QC-50; § 10's QC-3, QC-15/QC-17, QC-30 and QC-35
  rows; ADR-0018, ADR-0019, ADR-0020; source: `docs/trail/architecture/cycle-29.md`;
  `docs/trail/architecture/self_answer-33.md`; `docs/SDD.md` v26 and v27, RN-85, RN-87;
  `docs/trail/sdd/self_answer-34.md` § 2.1; `crates/` and `checks/` at `nozoki@8edec4f`; the
  registry copies of `libgit2-sys 0.18.8+1.9.7`, `libz-sys 1.1.29` and `git2 0.21.0`)*
- **RN-44:** *(v33 — the close: the cycle-30 fold, §§ 2.1 and 2.2 confirmed, each with an
  addition)* **The fold.** The companion at intake was the one v32 wrote, with two § 2 items. A
  `companion-self-answer` run confirmed both in the owner's seat, each with an addition
  (`docs/trail/architecture/self_answer-34.md`). The answers were committed at `nozoki@2f15e2c`, and
  the companion was copied whole before this fold as `docs/trail/architecture/cycle-30.md`.
  **§ 2.1 → ADR-0020 Accepted, ADR-0016 superseded.** A superseding record is the mechanic, on the
  test RN-24 drew: a correction in place is allowed only where the record's observable, its units
  table, its alternatives and its binds have not moved, and here three of them move. ADR-0016's
  Status line now reads `Superseded by ADR-0020`, and nothing else in it is edited. The answer's
  addition is folded before acceptance, while ADR-0020 was still Proposed and this run's to revise.
  ADR-0020 now states the grounds for the `crates/` placement and the Swift frame itself, where it
  had written "as ADR-0016 records". It carries ADR-0016's consequences beside its own: the harness
  without a window, `unsafe` in one unit with one review, a forbidden import as a build failure, two
  toolchains, a C ABI kept honest under the address sanitizer, and the Swift package's departures
  recorded in § 9. It also carries ADR-0016's undo cost, its *rests on* paragraph and its *drawn
  on* line for `arch_defaults.md` § Composition Root, and it marks its two carried crate readings
  as reconstructed, as ADR-0016 did. That follows ADR-0019's precedent, which restated ADR-0004's
  consequences whole. **Pointers re-pointed.** Every entry trace that named ADR-0016 now names
  ADR-0020: § 1's opening, QC-8, QC-9, QC-10, QC-11, QC-12, QC-13, QC-14, QC-15, QC-16, QC-17, QC-20,
  QC-24, QC-35, QC-61 and QC-63. QC-63's pointer moves from ADR-0016's undo-cost lines to
  ADR-0020's (`:L140-L142`), the same sentence carried. ", Proposed" is dropped wherever ADR-0020 was
  named, as RN-43 did for ADR-0004 → ADR-0019. Dated notes keep the numbers they were written with.
  **What this run adds beyond the answer:** ADR-0020's `## Binds` reads every entry that now traces
  to it, so it adds QC-24, QC-61 and QC-63 to the list the draft carried. QC-63 is the case RN-41
  named: it traced to ADR-0016 while ADR-0016's accepted `## Binds` could not list it. With a
  record that is still revisable, the pair can be made navigable both ways, so it is.
  ADR-0019 § Decision still says the exception "is drafted as its own record, ADR-0020". That was
  true when ADR-0019 was accepted, and ADR-0019 is not edited. **§ 2.2 → QC-30, § 10.** The draft
  stands: a C environment read is a member of half (2), held by `checks/entry-points.sh`, and not a
  review-only gate, because a command can check it and a class-2 downgrade must be argued
  (`principal_architect_create_architecture.md` § *Every constraint is traced, and named-verifiable*). The answer notes that the
  draft's rationale cited the NFDR preamble for that rule. The preamble does not state it, so this
  note cites the prompt. The addition's two cases are folded. (1) The C rule reads `environ` and
  `_NSGetEnviron` beside `getenv`. libgit2's `src/util/unix/process.c` reads the environment array
  to build a child's environment, the file is compiled, and its entry is reached only from the SSH
  exec transport, so the read is dormant, and its list line will say so. Of the 37 crates, only
  `libgit2-sys` matches. (2) The scan's unit is the pair (crate, name), so a new C read inside a
  listed crate passes. QC-30 names that as not covered, and its gate is the lockfile change
  reviewed as code (QC-26) with the list's text re-read, which the list's header already requires.
  The entry argues why no command can check it, and § 10's list of entries with no row names it
  beside QC-13's and QC-63's review halves. **What this run adds beyond the answer:** the list's
  name field accepts only the six Rust names (`checks/entry-points.allow:L10`, `:L16`), so the
  change that adds the C rule also widens that field. QC-30 says so, so that the delivery session
  does not find it out by a malformed-line failure. **Re-measured at HEAD `nozoki@2f15e2c`, not
  taken from the answers.** `git log 8edec4f..HEAD -- docs/SRS.md docs/SDD.md docs/fdr.md
  docs/PRD.md docs/UXD.md docs/DESIGN.md docs/CONTENT.md crates checks nozoki-mac .github Cargo.toml
  Cargo.lock` prints nothing. `cargo tree -p nozoki-bridge --target aarch64-apple-darwin -e normal
  --locked` resolves 37 crates. A grep of the `.c`, `.h`, `.cc` and `.cpp` files in their registry
  copies finds `getenv` in `libgit2-sys` (10 files) and `libz-sys` (1), and whole-word `environ` or
  `_NSGetEnviron` in `libgit2-sys` (1) alone. The lines cited read as quoted: `process.c:L21-L23`,
  `:L113`, `:L128`; `build.rs:L208`; `grep -rln git_process_new libgit2/src` names only
  `process.h`, the two `process.c` files and `transports/ssh_exec.c`; `sysdir.c:L347`, `:L357`,
  `:L402-L405`, `:L458-L459`, `:L559-L560`; `fs_path.c:L2030-L2033`; `entry-points.sh:L55`, `:L66`;
  `entry-points.allow:L10`, `:L16`, `:L20-L21`, `:L23-L26`; `Cargo.toml:L8`, `:L11`, `:L16`;
  `crates/nozoki-bridge/Cargo.toml:L11-L15`. **What moved beneath this document:** nothing. Every
  input's `Status:` line was re-read and is Settled, so `Inputs read:` stands. No `QC` is added,
  renumbered or reused. Nothing is left for the owner, so the companion is removed and `Status:` is
  Settled *(re: header `Status:`, `Version:`; § 1's opening; QC-30; the traces of QC-8 – QC-17,
  QC-20, QC-24, QC-35, QC-61, QC-63; § 10's QC-30 row and its list of entries with no row; ADR-0016's
  Status line; ADR-0020; the index; source: `docs/trail/architecture/cycle-30.md` §§ 2.1, 2.2;
  `docs/trail/architecture/self_answer-34.md`; `checks/` and `Cargo.toml` at `nozoki@2f15e2c`; the
  registry copies of `libgit2-sys 0.18.8+1.9.7`, `libz-sys 1.1.29` and `git2 0.21.0`)*
- **RN-45:** *(v34 — the cycle-31 fold, § 3.1 confirmed with three additions; § 2.1 drafted for
  the owner)* **The fold.** The companion at intake was opened by the PM, not by a
  `product-architecture` run, with one item raised from downstream: `checks/structure.sh` holds the
  `git-reader` adapter's file as a third QC-15 filesystem owner (`nozoki@48308ff`), and QC-15's
  *verified by* still described the script as it stood before. A `companion-self-answer` run
  answered it in the owner's seat (`docs/trail/architecture/self_answer-35.md` § 3.1) and raised a
  § 2 item on QC-5, whose slot it left for the next round. The answer was committed at
  `nozoki@cd88d52`, and the companion was copied whole before this fold as
  `docs/trail/architecture/cycle-31.md`. **§ 3.1 → QC-15.** The tail names the three exact-path
  owner files and the exempting `case`, pinned at `nozoki@48308ff`. It drops "names QC-15's other
  owners as not held" and the rule still to come, which RN-43 named as this document's realization
  and which has now landed. That is the header's own rule: a rule becomes executable in the change
  that adds it to the command. The three additions are folded as answered. (1) The tail names the
  two suite cases that hold the exemption to the exact path and to this clause only. (2) The
  `Path`-method gap stays, for every crate, re-pinned to the script's *GAPS* (`:L266-L267`), and
  only the `development-design` gate narrows, to the two parts the script lists as unheld
  (`:L253-L256`). (3) No record moves. ADR-0018 binds QC-15, and its citations are pinned at
  `nozoki@8edec4f`, where they still read as quoted: its decision did not change, and its
  realization landed. **What this run adds beyond the answer:** the tail argues its class-2 half in
  the script's own reasons. The script admits every filesystem form inside an owner file, and a
  `Path` method names no filesystem module, so a source scan cannot tell a read inside the folder
  from one past it (`:L253-L256`, `:L266-L267`). The answer named the two parts and did not argue
  them, and a class-2 tail must (`principal_architect_create_architecture.md` § *Every constraint is
  traced, and named-verifiable*). **§ 2.1 of the companion → QC-5, drafted, for the owner.** The
  self-answer run raised it with a proposal and no draft in the records. This run drafts it, as
  RN-43 did with the § 2 items that run raised, and leaves the slot for the owner. QC-5's tail
  states the three named cases as written and passing at `nozoki@48308ff`, cites the adapter's
  `.git`-file arm and CI's command, and keeps the old "none written / go red until" sentences as a
  dated parenthetical. § 10's QC-5 row does not move: it names the same command. ADR-0018 does not
  move either. Its § Consequences already says the missing-directory case goes red if `probe`
  follows the pointer. **Re-measured at HEAD `nozoki@cd88d52`, not taken from the answers.** `git
  diff --stat 48308ff HEAD -- checks crates nozoki-mac .github Cargo.toml Cargo.lock` prints
  nothing, so a pin at the merge is a pin on this tree. `bash checks/structure.sh` prints "14 Rust
  files in 2 crates read — nothing found" and exits 0. `bash checks/tests/test_structure.sh` exits 0
  with 88 `ok` lines, the two cases named above among them. `cargo test --locked -p nozoki-core
  --test root_finding` prints "37 passed; 0 failed", the three QC-5 cases among them. The lines
  cited read as quoted: `structure.sh:L77-L80`, `:L1161`, `:L253-L256`, `:L266-L267`;
  `test_structure.sh:L931`, `:L961`; `libgit2.rs:L38`, `:L42`, `:L46`, `:L58`, `:L62`, `:L69`,
  `:L136`; `root_finding.rs:L175`, `:L185`, `:L196`; `ci.yml:L26`. **What moved beneath this
  document.** `git log 1d81e12..HEAD -- docs/SRS.md docs/SDD.md docs/fdr.md docs/PRD.md docs/UXD.md
  docs/DESIGN.md docs/CONTENT.md` prints nothing. Every input's `Status:` line was re-read and is
  Settled, so `Inputs read:` stands. **Not weighed here, and named.** § 10's list of entries with
  no row names three entries' review halves (QC-13, QC-63, QC-30). It does not name the review
  halves of QC-11, QC-15 or QC-17, though each tail has one at `development-design`, and each of
  those entries does have a row. Whether the list is of entries with no row or of every review half
  is a question about the whole list, not about this fold, so the list does not move. No `QC` is
  added, renumbered or reused, and no record is written or restatused, so the index does not move.
  One item awaits the owner, so `Status:` is Draft *(re: header `Status:`, `Version:`; QC-5;
  QC-15; source: `docs/trail/architecture/cycle-31.md` § 3.1; `docs/trail/architecture/self_answer-35.md`
  §§ 3.1, 2.1; `checks/`, `crates/` and `.github/` at `nozoki@cd88d52`)*
- **RN-46:** *(v35 — the close: the cycle-32 fold, § 2.1 confirmed with one addition)* **The
  fold.** The companion at intake held one item, § 2.1, which the v34 run drafted into QC-5's
  *verified by*. It was answered in the owner's seat (`docs/trail/architecture/self_answer-36.md`
  § 2.1) and committed at `nozoki@899be3d`. The companion was then copied whole, before this fold, as
  `docs/trail/architecture/cycle-32.md`. **§ 2.1 → QC-5.** The v34 draft stands as written: the
  three named cases, the adapter's `.git`-file arm, CI's command and the dated parenthetical. The
  parenthetical's pointer moves from the companion, which this run removes, to the trail cycle that
  keeps it. The one addition is folded as answered. The tail now says the missing-directory case
  goes red for a `probe` whose attempt to follow the pointer changes the answer. It also says the
  case passes a `probe` that tries the pointer, swallows the failed open and still answers `Root`,
  and it points that half of the read bound at QC-15's review at `development-design`. QC-15's tail
  already names that review ("which read the adapter makes inside its owner file"). QC-15 joins
  QC-5's traces so the pointer can be followed back. **What this run adds beyond the answer:** the
  new review half argues its downgrade in its own tail. The case observes only the answer, the
  answer's text and a snapshot of the scene. A swallowed open changes none of the three, and the
  target records no trace of the opens `probe` makes (`root_finding.rs` names none), so no command
  in it can see the attempt (`principal_architect_create_architecture.md` § *Every constraint is
  traced, and named-verifiable*). **Re-measured at HEAD `nozoki@899be3d`, not taken from the
  answer.** `cargo test --locked -p nozoki-core --test root_finding` prints "37 passed; 0 failed",
  and the three QC-5 cases are among them. `git diff --stat 48308ff HEAD -- checks crates nozoki-mac
  .github Cargo.toml Cargo.lock` prints nothing. The lines cited read as quoted: `root_finding.rs:L24`
  (`assert_clean`, the path and scene assertions through `:L30`), `:L33-L37`
  (`probe_leaving_the_scene_unchanged`), `:L65-L68` (`probe_git_file`), `:L175`, `:L185`, `:L196`.
  **What moved beneath this document:** nothing. `git log 1d81e12..HEAD -- docs/SRS.md docs/SDD.md
  docs/fdr.md docs/PRD.md docs/UXD.md docs/DESIGN.md docs/CONTENT.md` prints nothing, and every
  input's `Status:` line was re-read and is Settled, so `Inputs read:` stands. **Not weighed here, and
  named.** QC-5 now has a review half at `development-design` beside its row in § 10. It joins the
  QC-11, QC-15 and QC-17 halves that RN-45 named as missing from § 10's list of entries with no row,
  and it is left off that list for the same reason: the question is about the whole list, not about
  this fold. No `QC` is added, renumbered or reused, no record is written or restatused, and the index
  does not move. Nothing is left for the owner, so the companion is removed and `Status:` is Settled
  *(re: header `Status:`, `Version:`; QC-5; source: `docs/trail/architecture/cycle-32.md` § 2.1;
  `docs/trail/architecture/self_answer-36.md` § 2.1; `crates/` at `nozoki@899be3d`)*
- **RN-47:** *(v36 — a re-derivation on a new upstream sentence; nothing folded from the owner)*
  **Intake.** The companion on disk held two items, and neither answer slot was filled: § 2.1
  (QC-47's sibling wording, appended at `nozoki@f0789a6` by a `companion-self-answer` run in the
  CTO's seat) and § 3.1 (QC-15's list, raised by the PM at `nozoki@df55117`). No `product-architecture`
  run wrote either. With no slot filled, nothing is consumed and no trail cycle is written. **What
  moved beneath this document.** `git log 4a91621..HEAD -- docs/SRS.md docs/SDD.md docs/fdr.md
  docs/PRD.md docs/UXD.md docs/DESIGN.md docs/CONTENT.md` names five commits: the SDD's cycle-23 and
  cycle-24 folds (v28, v29) with their answer commits, and CONTENT v10. **SDD v29 → QC-47.** § 4 C-I1
  now says a failed read "changes no other item", and that each sibling "holds the state its own read
  gave it: `observed`, `pending`, `failed` or `stopped`" (`docs/SDD.md:L686-L690`). S-5's command half
  says the same (`:L1799-L1801`). QC-47's *verified by* repeated the old wording, "`observed` on its
  siblings", which a folder holding a folder cannot meet: a folder entry not yet read is `Pending`
  (`crates/nozoki-core/src/fs_reader.rs:L853` at `nozoki@77c91fc`). QC-47 traces to C-I1, so the
  tail is re-derived from the sentence as it now reads. This is a new upstream sentence, which is a
  fresh authorization for a settled entry (`principal_architect_create_architecture.md` § *Two
  lifecycles*). QC-47's statement, "degrades only that item", does not move, and neither does NFR-3,
  "degrades only that item's view" (`docs/SRS.md:L297-L298`). S-5's command half joins the trace,
  because the *verified by* names its test. **What this run adds beyond the sentence:** one clause.
  C-I1 says what a failed re-read of an already expanded folder does to the entries listed under it
  is not decided there, and the SDD's *Open Questions* carry it to S-5's design (`:L5456-L5463`).
  QC-47 now says it does not hold that case, so that a delivery reader does not take "changes no
  other item" to settle it. The entry decides nothing about it. **Companion § 2.1 closes, unanswered.**
  It asked the owner to confirm the same change, and it waited on `product-sdd`'s fold. Its "If
  overridden" branch kept the old wording knowing it would then differ from C-I1. With the SDD
  folded, two architects reading C-I1 at v29 derive the same tail, so what is left is a derivation
  and not a choice (`principal_architect_create_architecture.md` § *When upstream is silent*, the
  test between cases 2 and 3). The item is dropped. Its text is the companion at `nozoki@f0789a6`,
  and its reasoning is `docs/trail/sdd/self_answer-36.md` § 2.1. No owner's words were in it, so no
  trail cycle keeps it. **The rest of SDD v28 and v29, weighed and left as written.** SM-2 now places
  every type that `probe`, `state` and `status` answer in `git-reader`, and `GitState` is a type
  `folder-model` builds and the port never returns (`docs/SDD.md:L422`, `:L481-L486`). QC-10's
  may-import set and QC-11's SM-2 reading, both traced to SM-2 at v26, still read true, because
  `GitState` does not cross the seam. `see-git-status`'s command half now gives a different reason
  for the reducer double, and says where the adapter's refusal by spelling is exercised
  (`:L1729-L1739`). That half adds no command, and no entry here quotes the reason it replaces
  (`grep` over this file for "reads fine there", "no sandbox grant" and "every tree item" prints
  nothing). CONTENT v10's seventh short-status sentence is cited by no entry. Every input's
  `Status:` line was re-read and is Settled, so `Inputs read:` stands. **Left for the owner:**
  companion § 3.1. QC-15's bounded list was set on the owner's seat's answer
  (`docs/trail/architecture/cycle-29.md` § 3.3 — RN-43), and the SDD sentence that names the
  adapter locating "the Git directory and the common directory by spelling" (`docs/SDD.md:L1737`)
  states what the adapter does, not a read bound. Widening the list, or narrowing the reads, is a
  call on the read-only promise's bound, and no answer authorizes either yet. The PM's code
  citations were not re-measured by this run. **Not run.** No test: QC-47's command needs
  `--test watch`, which does not exist at `nozoki@77c91fc` (`ls crates/nozoki-core/tests/`). No `QC`
  is added, renumbered or reused, no record is written or restatused, the index and § 10 do not
  move. A companion stays on disk, so `Status:` moves from Settled to Draft *(re: header `Status:`,
  `Version:`; QC-47; source: `docs/SDD.md` v29 § 4 C-I1, § 6 S-5, RN-89; `docs/trail/sdd/cycle-24.md`
  § 2.1; `docs/architecture_open_issues.md` § 2.1 at `nozoki@f0789a6`)*
- **RN-48:** *(v37 — the close: the cycle-33 fold, § 3.1 answered)* **The fold.** The companion
  at intake held one item, § 3.1, which the PM raised against QC-15's list of `git-reader`'s reads
  outside libgit2. It was answered in the owner's seat (`docs/trail/architecture/self_answer-37.md`
  § 3.1) and committed at `nozoki@46c7ab0`. The companion was then copied whole, before this fold, as
  `docs/trail/architecture/cycle-33.md`. **§ 3.1 → QC-15.** The list names the two kinds the adapter
  makes and the list left out, in the answer's words: the metadata, and a link's own text, at each
  position inside the folder along the spelled path to the Git directory and to the common
  directory; and the content of the `commondir` file in a Git directory that lies inside the folder.
  The list's items are now separated by semicolons, because the new item carries commas of its own.
  The bound, "never a path past the folder and never a link followed out of it", stays as written.
  The answer corrects a list that read as complete. It does not widen the read-only promise, and
  QC-35 does not move. **Re-measured at HEAD `nozoki@46c7ab0`, not taken from the answer.** `git diff
  --stat 6a0725c HEAD -- crates checks nozoki-mac .github Cargo.toml Cargo.lock` prints nothing, so
  every citation at `6a0725c` reads at HEAD. The lines read as quoted: `libgit2.rs:L102-L127`
  (`verified_locations`), `:L115` (the `commondir` read), `:L138-L142` (an outside location
  refused), `:L162-L172` (`inspect_on_disk`: `symlink_metadata` at `:L163`, `read_link` at `:L166`),
  `:L200-L202` (no position outside the folder, and not the folder itself, is inspected), and
  `:L275-L291` (`read_spelling_file`, opened with `O_NOFOLLOW` at `:L276-L279`). `bash
  checks/structure.sh` prints "14 Rust files in 2 crates read — nothing found" and exits 0. `bash
  checks/tests/test_structure.sh` exits 0 with 88 `ok` lines, and QC-15's two cases are among them.
  **What this run adds beyond the answer.** (1) The answer adds `:L163` to the tail's list of
  `Path`-method reads, "re-pinned at that commit". The list's old locators were pinned at
  `nozoki@48308ff`, and `libgit2.rs` has since moved (`git diff --stat 48308ff 6a0725c` shows 448
  lines added there). A list re-pinned at `6a0725c` with only `:L163` added would leave the old
  numbers on lines they no longer name. So every locator is re-pinned, read off the file at
  `6a0725c`: `:L38` → `:L54`, `:L42` → `:L58`, `:L136` → `:L513`, the `.git` file's open `:L62` →
  `:L439`, and its handle's `metadata()` `:L69` → `:L446`. `:L103` joins the list as well. It is
  `verified_locations`' `symlink_metadata` on the `.git` entry, a read of a kind the list already
  names, made on `state()`'s path. It was not in the file at `48308ff`, and the answer counts it
  among the reads already covered (`self_answer-37.md` § 3.1). The old pins stay in the tail as a
  dated parenthetical, so a reader holding a `48308ff` citation can follow it. (2) The header carried
  a second version line, `Version 35 — 35 — …`, left there by the v36 run. No earlier revision kept
  one (`git show 5a1e13f~1:docs/nfdr.md`), so it was a defect and is removed. Its text is held in the
  v36 commit, `nozoki@5a1e13f`. **Weighed and left as written.** ADR-0018's four-kind list is scoped to
  `probe` (`docs/adr/0018-root-finding-answers-root-for-a-git-file-and-reads-only-inside-the-folder.md:L55-L58`),
  which still makes only those four reads, and the record gives the `commondir` case to `state()`
  (`:L97-L99`). So it stays true, and no record supersedes it. QC-5's copy of the same list is
  scoped to `probe` too (QC-5, "`probe` reads only inside the opened folder"), and it does not move.
  The answer names a case it leaves uncovered: a folder already walked is swapped for a link before the
  `commondir` open, or before libgit2's own open. That case adds no clause here. The read-only promise
  holds there through the App Sandbox wall (ADR-0011), and the adapter's half is already QC-15's review
  at `development-design` ("which read the adapter makes inside its owner file"). **What moved beneath
  this document:** nothing. `git log 5a1e13f..HEAD -- docs/SRS.md docs/SDD.md docs/fdr.md docs/PRD.md
  docs/UXD.md docs/DESIGN.md docs/CONTENT.md` prints nothing, and every input's `Status:` line was
  re-read and is Settled, so `Inputs read:` stands. No `QC` is added, renumbered or reused, and no
  record is written or restatused, so the index does not move. § 10's QC-15 row names
  `checks/structure.sh`, whose rules did not change, so the row does not move either. Nothing is left
  for the owner, so the companion is removed and `Status:` is Settled *(re: header `Status:`,
  `Version:`; QC-15; source: `docs/trail/architecture/cycle-33.md` § 3.1;
  `docs/trail/architecture/self_answer-37.md` § 3.1; `crates/` and `checks/` at `nozoki@6a0725c`)*
- **RN-49:** *(v38 — the cycle-34 fold, § 3.1 and § 3.2 answered; a re-derivation on SDD v30 and
  v31; § 2.1 drafted for the owner; ADR-0021 proposed)* **Intake.** The companion on disk was opened
  by the PM at `nozoki@0aab3e7`, not by a `product-architecture` run, with two items raised from
  downstream: QC-3's `nm` read (§ 3.1) and QC-17's search-path switch (§ 3.2), each stated as
  still to come after the build at `nozoki@392177d` had landed both. A `companion-self-answer` run
  answered both in the owner's seat and added § 2.1 on QC-11, leaving its slot empty
  (`docs/trail/architecture/self_answer-38.md`). The answers were committed at `nozoki@2aed844`,
  and the companion was copied whole before this fold as `docs/trail/architecture/cycle-34.md`.
  **§ 3.1 → QC-3.** Half (3) is held by `checks/view.sh` from `nozoki@392177d`, with the read's
  locators, its suite cases and the three CI steps. The sentence that said the read was not in the
  script, and its clause that no bridge function reached `git-reader`, go. The tail states what the
  read has met, and has not, in SDD § 4 C-I3's terms at v31, with nothing further owed. Beside "The
  three names are a floor" it names C-R6's three defined symbols the pattern does not match, unread
  and not widened for. The trace is re-pinned to C-R6 and C-I3 at v31. **§ 3.2 → QC-17.** The tail
  names the switch's file, the read-back test and its locators, and the gate, which is the bridge's
  suite under `cargo test --workspace --locked` in CI. It names the tests that hold the fail-closed
  and once-per-process halves, which the read-back cannot see. The two sentences that put the
  switch and its test outside the tree go. The violation clause stays as written. The trace is
  re-pinned to C-I3 at v31. **Re-measured at HEAD `nozoki@2aed844`, not taken from the answers.**
  `git diff --stat 392177d HEAD -- crates checks nozoki-mac .github` prints nothing. Each locator
  both answers cite was opened and reads as quoted: `checks/view.sh:L379-L404`;
  `checks/tests/test_view.sh:L58-L64`; `.github/workflows/ci.yml:L26`, `:L41`, `:L51`, `:L54`;
  `crates/nozoki-bridge/src/exports.rs:L105`; `tests/search_path.rs:L36`, `:L47-L55`;
  `src/machine_config.rs:L213`, `:L249`, `:L262`; `src/session.rs:L1729`, `:L1740`; and `docs/SDD.md`
  `:L639-L645` and `:L759-L785`. `grep -rn nozoki_read_git nozoki-mac` prints nothing. This run
  executed `cargo test --locked -p nozoki-bridge` (every target `ok`, `search_path` 1 of 1),
  `bash checks/tests/test_view.sh` (exit 0, 28 `ok` lines), and `bash checks/view.sh` on the release
  bundle on disk, last modified 2026-10-04 08:20 (exit 0, "carries no Git transport — nothing
  found"). That this bundle is the build of a given commit rests on the file's time and on
  `self_answer-38.md`, and was not otherwise shown. **What moved beneath this document.** `git log
  b716c7b..HEAD -- docs/SDD.md` names the SDD's cycle-25 and cycle-26 folds (v30, v31,
  `nozoki@51de784`, `nozoki@27e2bbf`). Neither raised an item on this companion (SDD RN-90, RN-91,
  each under *Downstream*). A new upstream sentence is a fresh authorization for a settled entry
  (`principal_architect_create_architecture.md` § *Two lifecycles*), so each entry that traces to
  a moved sentence was re-read against it. (1) **SM-4's list is ten** (SDD § 3 SM-4, § 10 RC-4,
  RN-90). QC-24 named the nine and held the exported set inside them, while the tree's export test
  admits `nozoki_read_git` (`crates/nozoki-bridge/tests/exports.rs:L17-L23`). Read as written, the
  entry called a landed build a violation. The list now names ten, in the SDD's order, and the trace
  is re-pinned. QC-24's "No second plumbing export" sentence stays, because RC-4 retains C-R7's
  rule on the registration call word for word. QC-1, QC-2, QC-59 and § 9's layer-3 row read the
  list by reference and do not move. (2) **The config-named-path item** (SDD § 11 R-16, *Open
  Questions*, RN-91). QC-6 and QC-35 pointed at "*Open Questions*' last item". It stopped being the
  last at SDD v29, when RN-89 added the failed-re-read item, and v37 did not catch it. Both now name
  the item by what it is, with the bound v31 gives it. (3) **C-I3's third uncovered thing** (RN-91).
  The read-only walk is a third caller with the machine-level reads on (`checks/walk.rs:L292`, read
  at HEAD), so `checks/read-only.sh`'s `unchanged` is shown for libgit2 as the harness configures
  it. QC-35's second uncovered case named the core suites only, and now names the walk and whose
  call isolating them is. Nothing becomes covered. **What this run adds beyond the answers and the
  sentences.** (a) Companion § 2.1 → QC-11, drafted for the owner, as RN-45 did with the § 2 item a
  self-answer run raised with no draft. The tail states that the switch's change did not add the
  exception's rule to `checks/structure.sh`, so the bound stays review until a change adds it. It
  re-pins the script at `:L257-L258` and names the bridge files that name `git2`, measured at HEAD
  (`grep -rln git2 crates/nozoki-bridge`). The slot is left for the owner. (b) **ADR-0021, Proposed —
  supersedes ADR-0013 on acceptance.** ADR-0013 § Decision quotes the nine names and "all nine from
  `v1.0.0`", and RC-4 *Changed* names this log as owed a record on that ground. The record restates
  ADR-0013 whole, with the list at ten and Git state pulled by `read_git`. Its alternatives are
  RC-4's *Stopped* two and the owner's route, beside ADR-0013's own. It clears the three gates.
  Dropping the call after `v1.0.0` costs a major version, because C-I6's pin reads the export set. A
  cold reader of SM-4's upward callback would wonder why Git state is pulled. And two options were
  given up, each for a stated reason. The form follows ADR-0020's (RN-43): Proposed, with ADR-0013
  Accepted and untouched until the owner answers companion § 2.2. QC-24, the one entry that moved on
  this ground, names ADR-0021 now. The other entries ADR-0013 binds carry their trace to ADR-0021 on
  acceptance, as RN-44 did for ADR-0020. (c) § 10's QC-15/QC-17 row names the switch's fail-closed
  and once-per-process cases beside the read-back, because the entry now does. **Weighed and left as
  written.** SDD v31 § 3 `GitState` now says the model holds `HeadState` and `StatusLists` from one
  read, and that a failed half fails the whole Git item. No entry here quotes the sentence it replaces
  (`grep` for "changed and staged" and `StatusLists` matches nothing above § NFDR Review Notes), and C-I1's
  one-item rule is QC-47's, which does not move. R-15's measurement is the SDD's. QC-3 cites R-15 for
  the response, and that does not move. ADR-0019 and ADR-0020 make no claim that a landed build
  falsifies, as the answers say (`self_answer-38.md` § 3.1, § 3.2), and neither moves. Every input's
  `Status:` line was re-read and is Settled, so `Inputs read:` stands. **Left for the owner:**
  companion § 2.1 (QC-11's tail, drafted) and § 2.2 (ADR-0021's form). No `QC` is added, renumbered
  or reused. A companion stays on disk, so `Status:` moves from Settled to Draft *(re: header
  `Status:`, `Version:`; QC-3, QC-6, QC-11, QC-17, QC-24, QC-35; § 10's QC-15/QC-17 row; ADR-0021;
  source: `docs/trail/architecture/cycle-34.md` § 3.1, § 3.2; `docs/trail/architecture/self_answer-38.md`;
  `docs/SDD.md` v30 § 3 SM-4, § 10 RC-4, RN-90, and v31 § 4 C-R6, C-I3, § 11 R-16, RN-91; the tree
  at `nozoki@2aed844`)*
- **RN-50:** *(v39 — the close: the cycle-35 fold, § 2.1 and § 2.2 confirmed)* **The fold.** The
  companion at intake was the one v38 wrote, with two § 2 items. A `companion-self-answer` run
  confirmed both in the owner's seat, § 2.2 with one addition (`docs/trail/architecture/self_answer-39.md`),
  and the answers were committed at `nozoki@98e35f8`. A `product-architecture` run then stopped short
  of accepting ADR-0021 with only a self-answer behind it, and the owner confirmed § 2.2, the addition
  kept, in an interactive session (`nozoki@bb75290`). A second self-answer run found nothing left to
  decide (`docs/trail/architecture/self_answer-40.md`, `nozoki@16f1ce1`). The companion was copied
  whole, before this fold, as `docs/trail/architecture/cycle-35.md`. **§ 2.2 → ADR-0021 Accepted,
  ADR-0013 superseded.** A superseding record is the mechanic, on the line the answer draws from the
  log's own practice: a fact, a pointer or a description the record's rule does not rest on is
  corrected in place with a dated note, and a moved rule is superseded. SM-4's closed list, and what
  C-I6's pin holds from `v1.0.0`, is that kind of rule. ADR-0013's Status line now reads `Superseded by
  ADR-0021`, and nothing else in it is edited. The addition is folded before acceptance, while ADR-0021
  was still Proposed and this run's to revise: its trace to the companion read "§ 2.1, as this run
  wrote it" and now points at `docs/trail/architecture/cycle-35.md` § 2.2, the file that keeps the
  item once the companion is gone. **Pointers re-pointed.** Every entry trace that named ADR-0013 now
  names ADR-0021: QC-1, QC-2, QC-8, QC-9, QC-15, QC-16, QC-24, QC-30, QC-32, QC-34 and QC-36. QC-24's
  "ADR-0021, proposed over ADR-0013 — RN-49" now reads as accepted at v39. Dated notes keep the
  numbers they were written with. **What this run adds beyond the answer:** ADR-0021's `## Binds`
  reads every entry that now traces to it, so it adds QC-36 to the ten the draft carried from
  ADR-0013's `## Binds`. QC-36 traced to ADR-0013 (re-derived at v11, RN-22), and ADR-0013's accepted
  `## Binds` did not list it. With a record that is still revisable, the pair is made navigable both
  ways, as RN-44 did for ADR-0020. **§ 2.1 → QC-11.** The v38 draft stands as written: the
  exception's bound is review at `development-design` until a change adds the rule to
  `checks/structure.sh`. The answer's reason is that the form names no delivery unit as the rule's
  source, and that form is the one that went false at v37. The tail's "drafted at v38 for the owner's
  confirm" now reads as drafted and confirmed, pointing at the trail cycle. **Re-measured at HEAD
  `nozoki@16f1ce1`, not taken from the answers.** `git log 566558b..HEAD -- docs/SRS.md docs/SDD.md
  docs/fdr.md docs/PRD.md docs/UXD.md docs/DESIGN.md docs/CONTENT.md crates checks nozoki-mac
  .github Cargo.toml Cargo.lock` prints nothing. `checks/structure.sh:L257-L258` still names QC-11's
  libgit2 clause under *WHAT IS NOT HELD*, and `grep -rln git2 crates/nozoki-bridge` prints the
  manifest, `src/machine_config.rs` and `tests/search_path.rs`, the three files the tail names.
  `crates/nozoki-bridge/src/exports.rs:L105` is `nozoki_read_git`, the export test admits it
  (`crates/nozoki-bridge/tests/exports.rs:L17-L23`), and `grep -rn nozoki_read_git nozoki-mac` prints
  nothing. This run executed `cargo test --locked -p nozoki-bridge` (every target `ok`; `exports` 11
  of 11, `search_path` 1 of 1) and `bash checks/structure.sh` (exit 0, "15 Rust files in 2 crates
  read — nothing found"). **What moved beneath this document:** nothing. Every input's `Status:`
  line was re-read and is Settled, so `Inputs read:` stands. No `QC` is added, renumbered or reused.
  § 10 does not move: no row names a record. Nothing is left for the owner, so the companion is
  removed and `Status:` is Settled *(re: header `Status:`, `Version:`; QC-11; the traces of QC-1,
  QC-2, QC-8, QC-9, QC-15, QC-16, QC-24, QC-30, QC-32, QC-34, QC-36; ADR-0013's Status line;
  ADR-0021; the index; source: `docs/trail/architecture/cycle-35.md` § 2.1, § 2.2;
  `docs/trail/architecture/self_answer-39.md`, `self_answer-40.md`; `nozoki@bb75290`; the tree at
  `nozoki@16f1ce1`)*
- **RN-51:** *(v40 — the close: a re-derivation on SDD v32)* **Intake.** The companion on disk had
  one item, § 2.1, opened at `nozoki@250fc6e` by a `companion-self-answer` run in the CTO's seat
  while it answered the SDD's companion, not by a `product-architecture` run
  (`nozoki@250fc6e:docs/architecture_open_issues.md` § 2.1; reasoning
  `docs/trail/sdd/self_answer-39.md`). It proposed that QC-6 and QC-35 state the config-named-path
  item's bound as the SDD's *Open Questions* item would state it after the SDD's fold, with a stated
  doubt: the change was owed only once `product-sdd` had folded, and the item was to stay open if
  the SDD still stated the old bound. Its slot was not filled, so the companion is not consumed and
  no trail cycle is written. **What moved beneath this document.** `docs/SDD.md` v31 → v32, Settled
  (`nozoki@19a76bc`, SDD RN-92, `docs/trail/sdd/cycle-27.md` § 5.1): the item's bound is "before the
  slice is reached" alone, the clause naming the build in which `mac-shell` first calls
  `nozoki_read_git` is removed, the bound is held by review of the change after which
  `see-git-status`'s *Reached when* is claimed whole, and § 11 R-16 states what the builds between
  hold. The § 2.1 doubt is resolved: the SDD now states the new bound. **Why this is a derivation,
  not a choice.** The new SDD sentence is the fresh authorization a settled entry needs, and the SDD
  outranks this document. Its § 4 opening note gives the direction, "downstream is rebuilt from
  upstream, never the reverse", and two architects reading SDD v32 would write the same bound. The
  item's own *If overridden* names no defensible alternative: keeping the old bound would make this
  document refuse a build the SDD no longer refuses. So the item is closed by this re-derivation and
  not by an owner's answer. Where the owner reads it otherwise, the cost is one revert of this
  run's commit. **QC-6.** The uncovered case states the bound as the SDD does, names the review that
  holds it and the slice's not being reached where the fixture and its case are missing, and states
  that the builds between open a reader's repositories with this read unsettled. The pin moves from
  "§ 11 R-16 as it reads at v31" to R-16 and the *Open Questions* item at v32. A dated note keeps the
  old bound, and the v37 note stays. The trace tail gains the v32 re-derivation. **QC-35.** Uncovered
  case (1) states the same bound with a dated note keeping the old words. The trace tail splits RN-49's
  pin: (2)'s walk stays on C-I3 at v31, and (1)'s bound is re-derived on v32. **What does not move.**
  QC-3's sentence that the `nm` read "meets that executable in the build where `mac-shell` first
  calls the export" stays. It is about the transport read and SDD § 11 R-15, which SDD RN-92 names
  as unmoved. § 10 does not move: its QC-6 and QC-35 rows carry no bound. No record is written or
  restatused. No ADR states the bound: `grep -n 'first calls' docs/adr/*.md` prints nothing.
  ADR-0020's "How that is closed is the SDD's last *Open Question*" (`:L130`) is not a stale pointer:
  the record's `## Traces to` pins `docs/SDD.md` at v27, where the item was the last, and the SDD
  added the item after it at `nozoki@77c91fc`. **Re-measured at HEAD `nozoki@19a76bc`.** `git log
  d2dd1f2..HEAD -- docs/SRS.md docs/fdr.md docs/PRD.md docs/UXD.md docs/DESIGN.md docs/CONTENT.md
  crates checks nozoki-mac .github Cargo.toml Cargo.lock` prints nothing. `git diff d2dd1f2..HEAD --
  docs/SDD.md` is the v32 fold alone, read whole. `grep -rn 'nozoki_read_git\|read_git\|readGit'
  nozoki-mac/Sources` prints nothing. Every input's `Status:` line was re-read and is Settled, so
  `Inputs read:` stands. **Known limits.** This run read the SDD's v32 diff whole and the SRS and
  FDR at their status lines; their bodies did not move after v39, which derived from them. It built
  nothing and ran no test: it changes no code. **The companion.** Nothing is left for the owner, so
  it is removed and `Status:` is Settled *(re: header `Status:`, `Version:`; QC-6; QC-35; source:
  `docs/SDD.md` v32, SDD RN-92; `docs/trail/sdd/cycle-27.md` § 5.1;
  `nozoki@250fc6e:docs/architecture_open_issues.md` § 2.1; the tree at `nozoki@19a76bc`)*
