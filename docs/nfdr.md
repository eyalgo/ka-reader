# NFDR — KA-Reader

**Status:** Settled
**Owner:** Principal Architect
**Version:** 66 — the close, the cycle-59 fold, § 3.1 confirmed in the owner's seat with five moves. The gate's *Secret scan* step realizes QC-28 at the change: QC-28's *verified by* names `checks/secret-scan.sh gitleaks git` over every commit HEAD reaches, with the script's exit contract, the reviewed `.gitleaksignore` as its one way through and two fail-closed paths — the per-run fetch of gitleaks's release archive and the shallow-checkout refusal — and § 10's QC-28 row names the script and its suite, gated at the change. § 8 gains the gate's 1.2.0 reading, 29 steps, and re-pins its `gate.sh` locators at `ka-reader@8235240`; § 9 counts twelve suites and re-pins every suite locator; QC-64's order sentence, false at `8235240`, is re-worded. Each old reading stands in a dated note. No ADR is written, and no `QC` is added, renumbered or reused. Nothing is left for the owner, so the companion is removed and `Status:` is Settled — RN-77 (v65: the close, the cycle-58 fold — § 9's Swift-packet bullet names `checks/no-network.sh` 1.2.0 as the system-target clause's gate; `Status:` was Settled — RN-76)
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
> `layout.md` v1.0.0, `toolchain.md` v1.1.0, `quality_gates.md` v1.1.0,
> `environment.md` v1.2.0) names an
> engineering-doctrine file of
> the organisation that publishes this product, which is not in this repository; every such entry
> states the rule in full here, so the trace is provenance and never a dependency. Every command
> named below is one the SDD names, or one this document names as its own realization and says so
> in § NFDR Review Notes. Executability is per rule, not per script: a rule a command names
> becomes executable in the change that adds that rule to the command, and until then its gate is
> `development-design` reading the entry. A script not yet in the tree is the case where no rule
> has been added. Which rules a script holds is stated in the script's own header and is cited,
> never copied here — for `checks/structure.sh`, *THE SCAN TABLE* and *WHAT IS NOT HELD*
> (`checks/structure.sh:L35-L93` at `ka-reader@463acb9`) — so the next rule added moves one file
> *(through v25 this sentence tied executability to the script's landing, which read every rule
> § 10 assigns to `checks/structure.sh` as gated once the script landed holding four of them; on
> the owner's seat's answer at `docs/trail/architecture/cycle-23.md` § 3.1 — RN-37)*.

---

## 1. Structural integrity

The physical module set is ADR-0020's, which supersedes ADR-0016 (confirmed in the owner's seat at
`docs/trail/architecture/cycle-30.md` § 2.1 — RN-44), which superseded ADR-0009 (the owner's confirm,
`docs/trail/architecture/cycle-9.md` § 2.3); this section is re-derived from `docs/SDD.md` § 3 as
it reads at v14 under that document's own rule that the § 4 statement wins (RN-22, RN-23): `ka-reader-core` (`crates/ka-reader-core`, Rust library — `fs-reader`, `git-reader` with the
Git port, `watcher`, `folder-model`, `own-state`, `markdown-renderer`, `highlighter`),
`ka-reader-bridge` (`crates/ka-reader-bridge`, Rust static library — `core-bridge`: the C ABI and the
Rust-side composition root), `ka-reader-mac` (a Swift package — `mac-shell`, `surfaces`), and
`checks/` (build-time, not shipped). Part names are the SDD's (`docs/SDD.md` § 3); the Rust module
spelling of each is the developer's. **The tree holds ADR-0020's four units and nothing else**
*(corrected in place at v14 — RN-25, on the owner's seat's answer at
`docs/trail/architecture/cycle-11.md` § 3.1; through v12 this paragraph read the tree as holding
the previous shape alone, and at v13 as holding both shapes until the Tauri build's removal)*:
the native shell landed at `ka-reader@99e2bac` — `crates/ka-reader-bridge` and `ka-reader-mac` are on
`main` — and the Tauri build left at `ka-reader@0aca57e` (`git ls-files ka-reader-ui crates/ka-reader-app
| wc -l` → `0`, 2026-09-24; `docs/SDD.md` § 10 RC-3). Measured with `git ls-files`, not `ls`: a
working copy that built the previous shape can still list `ka-reader-ui/` and `crates/ka-reader-app/`
as untracked build output — `node_modules/`, `dist/`, `gen/`, `permissions/`, whose ignore lines
left with the build — and an `ls` there reads the old shape back into a tree that does not hold
it. The entries follow the SDD and the tree follows the entries — the reading RN-22 fixed for the
new units while they were unbuilt.

### 1.1 Architectural invariants

- **QC-1:** `ka-reader-mac` holds no I/O of its own — no filesystem read, no network, no spawned
  process, no URL handed to another program, no web engine — and its only channel to the core is
  `SM-4`'s exported function list and `ka_reader_free`, the seam's one release call beside the list,
  read through the generated header. The seam is where the promise
  is read, not where it is held: the wall is the process's entitlements (QC-25), and this entry is
  a source scan and a link check on every build, not a process boundary.
  — *verified by:* `checks/view.sh` (test layer 6) over `ka-reader-mac/Sources` and the built
  executable (QC-34); the bridge's export set (QC-24); `checks/no-network.sh` *(traces to:
  ADR-0021; ADR-0014; SDD § 3
  SM-4; § 4 C-R7; re-derived at v11 — RN-22; `ka_reader_free` named at v13 on the owner's addition at
  `docs/trail/architecture/cycle-10.md` § 2.1 — RN-24)*
- **QC-2:** No code path in any shipped unit opens a file under the granted folder for writing,
  creates, renames or removes an entry there, or creates a lock file in `.git`.
  — *verified by:* `checks/read-only.sh <fixture>` prints `unchanged` on every walk fixture after every
  command the build exports — a command being a call on `SM-4`'s list, driven through `SM-5`;
  `ka_reader_free` is the seam's release call and no command, it never reaches the model (C-I3, C-R7
  at v16) — `.git` hashed where present (test
  layer 3); structural check (layer 6):
  `checks/structure.sh` rule *no write API in `ka-reader-core` outside `own-state`*. The unit is the
  build: a build that exports a command has that command's operation on `SM-5`, so the walk calls
  it in that same build, and no test of a slice's own stands in for `read-only.sh`. **Not covered,
  and named so it is not read as coverage:** nothing in the build compares the calls the walk makes
  with the set the build exports, so their match is held by review of the change that exports a
  command, at `development-design` — the moment QC-3's reviewed half is held at — until a change
  makes it a check; no command does today, which is why that half is a review gate and says so
  here. And a fixture that offers no entry a command can act on exercises nothing for that command;
  which fixture a command needs is its slice's own bar (`docs/SDD.md` § 6). **A walk fixture is
  a folder the script's restore builds whole** before the first hash (`restore()`,
  `checks/read-only.sh:L210-L252`, its header `:L24-L29`, at `ka-reader@c268945`), and what the
  restore lays down is removed once the verdict is taken (`:L31-L36`). The script hashes every entry
  under the fixture folder and nothing above it (`:L19-L22`; `manifest()` at `:L45-L65`), once after
  the restore (`:L368`) and once after the walk (`:L389`), so a scene whose Git directory lies
  outside the opened folder is not one: a wrong write there would land outside the hash *(through
  v59 this read "a folder the script's in-place restore builds whole (`checks/read-only.sh:L73-L76`),
  and the script hashes the entries under the fixture folder and nothing above it (`:L17-L20`,
  `:L84`)"; none of the three locators was pinned, and at `c268945` `:L73-L76` is the usage refusal —
  `docs/trail/architecture/cycle-53.md` § 3.1; RN-71)*. `inside-a-repo`, `parent-of-two` and `linked-worktree` are such scenes,
  and they are proved by `cargo test --locked -p ka-reader-core --test root_finding` and
  `--test git_state` (layer 2), which snapshot each scene's whole root around the calls
  (`crates/ka-reader-core/tests/root_finding.rs:L38-L43`; `crates/ka-reader-core/tests/git_state.rs:L146-L155`).
  `plain`, `repo` and `submodule` are walk fixtures, and CI walks all three: the step `Read-only,
  submodule` runs `checks/read-only.sh checks/fixtures/submodule` beside the `plain` and `repo`
  steps (`.github/workflows/ci.yml:L73-L74` at `ka-reader@b12e48c`), where "on every build" puts it.
  That half is bounded by what can be read: the step is in the workflow, and its result on the
  hosted runner is unread, because `b12e48c` is on no remote branch and `origin/main` is at
  `ka-reader@799c3d6` — so this tail says the step is in the workflow and does not say it is green.
  The walk drops the Git answer (`checks/walk.rs:L288-L292`), which is why a case and not the walk
  holds it: in `--test git_state` (layer 2), the case at `crates/ka-reader-core/tests/git_state.rs:L787`
  builds `submodule` as the script's restore builds it (the label read "in-place restore" through
  v59 — RN-71), in a disposable scene of its own,
  and asserts `read_git`'s whole answer there — `root`, HEAD on `main` in the normal state, staged
  empty, and changed = {`submodule` modified, `README.md` untracked}. The same case is a layer-2
  no-write proof on the restored `submodule` beside the walk's: `read_git_over` snapshots the whole
  scene before and after the call and asserts the two are equal (`:L730-L738`). `:L771` asserts the
  scene the restore lays down, and `:L802`, `:L815` and `:L828` the three layouts in which the
  answer moves *(through v45 the tail read: "two limits stand beside `submodule` until a change
  closes them: the walk drops the Git answer (`checks/walk.rs:L288-L292`), so no case asserts what
  `read_git` answers on it; and CI runs the walk on `plain` and `repo` alone
  (`.github/workflows/ci.yml:L68`, `:L71` at `ka-reader@076eac2`), so the `submodule` run is made by
  hand until it joins them, where 'on every build' puts it", and its trace read "the walk fixture,
  the three scenes the suites prove and the two limits from SDD § 4 C-I3 and § 6 S-4, command half,
  as they read at v42 (SDD RN-101)"; both limits are closed at `ka-reader@b12e48c` — RN-57)* *(through
  v41 this tail read "on every fixture" — RN-53)* *(traces to:
  SRS NFR-5, NFR-6, C-2; SDD § 4 C-I3; ADR-0021; ADR-0011; the tail's IPC wording corrected on the
  owner's addition at `docs/trail/architecture/cycle-9.md` § 2.3 — RN-23; the command carve-out on
  the owner's addition at `docs/trail/architecture/cycle-10.md` § 2.1 — RN-24; the unit, the two
  uncovered cases and the reviewed half from SDD § 4 C-I3 and C-R7 as they read at v22, on the
  owner's seat's answer at `docs/trail/architecture/cycle-18.md` § 3.1 — RN-32; the walk fixture
  and the three scenes the suites prove (RN-53), the CI step, the `read_git` case and its no-write
  proof from SDD § 6 S-4, command half, as it reads at v47 (SDD RN-107), on the owner's seat's
  answer at `docs/trail/architecture/cycle-40.md` § 3.1 — RN-57)*
- **QC-3:** The shipped executable, `KA-Reader.app/Contents/MacOS/KAReader`, links no network
  transport, and every crate and package the bundle contains is named in `checks/deps.allow`. The
  claim is made of the executable and of nothing smaller. *What the build holds:* libgit2 is
  vendored with its `https` and `ssh` features off, and every manifest that names `git2` turns its
  default features off — a line with defaults on would turn HTTPS and SSH on for every crate that
  uses it, because Cargo unifies features across a build — so no TLS backend and no libssh2 is
  compiled or linked. *What it does not hold:* the vendored libgit2 compiles its transports and
  streams whatever the features, and registers `git://`, `http://` and `https://` with no guard
  (`libgit2-sys 0.18.8+1.9.7`, `build.rs:L152-L156`, `libgit2/src/libgit2/transport.c:L33-L35`), so
  this entry claims nothing of the library or of `ka-reader-core` as a unit *(through v31 the first
  clause read "No shipped unit links a network transport: libgit2 is built without its HTTPS and
  SSH transports", which was false of the library and of `ka-reader-core` — RN-43)*.
  — *verified by:* three halves, and the entry holds only with all three. **(1) The tree equals the
  list:** `checks/no-network.sh` — `cargo tree` diffed against the allowlist, non-zero on any hit,
  and non-zero where `ka-reader-mac/Package.swift` declares a dependency or a `Package.resolved`
  exists — the view brings nothing to the tree (the tree). That diff proves nothing about a name
  the list admits. **(2) The
  list holds no transport:** the allowlist change reviewed as code in the same change (QC-26, at
  `development-design`), where the review judges each added name against this entry's domain —
  does it, **in the features the lockfile resolves**, link a network transport — and not only
  whether the addition is deliberate. A name alone cannot answer that: `cargo tree --offline
  --locked -e features -i <crate>` is what the review reads for a crate, and a feature-gated
  transport — libgit2's own HTTPS and SSH once a libgit2 binding is on the list, the case this
  entry's first clause states — is a condition no name diff sees. The names on the list before
  this half was stated (218 cargo and 163 pnpm, `bash checks/no-network.sh` at `ka-reader@9b36a42`)
  passed the diff and were never reviewed against the domain. At `ka-reader@0aca57e` the list is one
  `cargo:` section of 17 names (`checks/deps.allow:L18` onward); the `pnpm:` section and 201 of
  the 218 cargo names left with the Tauri build at `ka-reader@fad4e78`, unreviewed, and none of them
  is shipped now; the 17 that stayed were among the 218 never reviewed, and until
  `ka-reader@85d9fa7` no record showed the review — `ka-reader@6acfb65` generated the list and read its names against the file's header
  rules, which is the reading by name this half says cannot answer the question, and
  `ka-reader@fad4e78` records only that the tree equals the list *(the count and the commits on the
  owner's seat's answer at `docs/trail/architecture/cycle-11.md` § 3.2 — RN-25)*. **The one-time
  review is recorded**, at `ka-reader@85d9fa7:checks/deps.review.md`, which landed in one commit with
  `checks/deps.allow` and `Cargo.lock`. At that commit the list is one `cargo:` section of 40
  names — the 17, the three `ka-reader@21589c7` added (`bitflags`, `errno`, `rustix`) and the 20 the
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
  Beside that floor, the pattern does not match three symbols the release executable that links the
  `ka_reader_read_git` export defines, each a local defined symbol (`t`) —
  `_git_socket_stream_global_init`, `_git_stream_registry_global_init` and
  `_git_transport_ssh_libssh2_global_init`. What they do was not read, no network call behind them
  is cited, and the pattern is not widened for them. The read is in the script from the build at
  `ka-reader@392177d` (`checks/view.sh:L379-L404`), with its suite cases in
  `checks/tests/test_view.sh:L58-L64` — the four symbol reds at `:L58-L61`, the three cause reds at
  `:L62-L64` — and CI runs both on every push after `ka-reader-mac/assemble.sh`
  (`.github/workflows/ci.yml:L32`, `:L57`, `:L60` at `ka-reader@f0f1e5f` *(through v48 cited `:L41`,
  `:L51`, `:L54` with no commit named, true through `ka-reader@c915d52`; the lines moved when the
  `Toolchain` step landed at `ka-reader@d852457` and again when the app build moved ahead of `Test
  gate` at `ka-reader@d2694c7` — RN-60)*). This half's gate is that script. The read is
  proved for each executable it has met, and for no later one until it meets it. It has met two,
  both on the owner's machine. The first links libgit2's open and status code and not the
  `ka_reader_read_git` export (`crates/ka-reader-bridge/src/exports.rs:L105`). The second is the first
  that links the export, which the shell calls from `ka-reader@129586e`
  (`ka-reader-mac/Sources/KAReader/NativeBridge.swift:L26`): `nm` prints `T _ka_reader_read_git`, no
  `git_smart_subtransport_` symbol and no undefined `_connect`, `_socket` or `_getaddrinfo`, and
  `checks/view.sh` exits 0. No hosted runner has read a build that links the export *(through v40
  this tail said the read had not met an executable that links the export, which no Swift source
  called, and would meet one in the build where `mac-shell` first calls it; that build landed at
  `ka-reader@129586e` and passed — RN-52)* *(through v37 this tail said the read was not
  in the script at `ka-reader@8edec4f`, that no bridge function reached `git-reader` at that commit,
  and that its gate was `development-design` until the build that first exported one; that build
  landed at `ka-reader@392177d` — RN-49)*. A red read on any release build is SDD § 11 R-15's: the
  change whose build turns the read red does not land until a re-cut is recorded in SDD § 10
  *(through v40 the response read "a re-cut recorded before anything is built on that export" —
  RN-52)*. Stating the claim lower is the owner's call under FDR PD-27. The manifest clause is
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
  owner's seat's answer at `docs/trail/architecture/cycle-34.md` § 3.1 — RN-49; the two executables
  the read has met, the three symbols pinned to the second, and R-15's *shows up as* and *response*
  re-derived from SDD § 4 C-R6, C-I3 and § 11 R-15 as they read at v33 (SDD RN-93) — RN-52)*
- **QC-4:** Every read the model holds is an item carrying an `ItemState` — `pending`, `observed`,
  `failed(condition)` or `stopped` — and no surface draws a marker, a count or a "nothing changed"
  from an item that is not `observed`.
  — *verified by:* unit tests on the reducer (layer 1): every read path yields a state;
  `swift test --package-path ka-reader-mac` (layer 4): a projection with a `pending` item draws no
  marker, no count and no empty-folder sentence, and the only words it may carry for the state
  are the *Loading* sentence `docs/CONTENT.md` § Message patterns fixes — by pointer, never
  copied here (at `ka-reader@69cc4b2` the check passes on
  `ka-reader-mac/Tests/SurfacesTests/RootItemsViewTests.swift:L96-L115`, a `pending` row drawing its
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
  — *verified by:* `cargo test --locked -p ka-reader-core --test root_finding` over the plain,
  inside-a-repository, parent-of-two, linked-worktree and submodule fixtures (layer 2), with three
  cases this entry names: `linked-worktree` answers `Root`, `submodule` answers `Root`, and a scene
  whose `.git` file names a Git directory that does not exist answers `Root` — the case that goes
  red if `probe` ever follows the pointer, so the read bound has a check. All three are written
  and pass at `ka-reader@48308ff`: `test_linked_worktree_answers_root`, `test_submodule_answers_root`
  and `test_git_file_naming_a_missing_git_directory_answers_root`
  (`crates/ka-reader-core/tests/root_finding.rs:L175`, `:L185`, `:L196`). The adapter answers a `.git`
  regular file through `probe_git_file` (`crates/ka-reader-core/src/git_reader/libgit2.rs:L46`,
  `:L58`), and CI runs the target under `cargo test --workspace --locked`
  (`.github/workflows/ci.yml:L35` at `ka-reader@f0f1e5f` *(through v48 cited `:L26` with no commit
  named, true through `ka-reader@c915d52`; moved by the `Toolchain` step at `ka-reader@d852457` and the
  app build's move ahead of `Test gate` at `ka-reader@d2694c7` — RN-60)*). The missing-directory case does not hold the whole read bound.
  It goes red for a `probe` whose attempt to follow the pointer changes the answer. A `probe` that
  tries the pointer, swallows the failed open and still answers `Root` passes it, because the case
  asserts only the answer, that the answer holds no path, and that the scene is unchanged
  (`crates/ka-reader-core/tests/root_finding.rs:L24-L37`, `:L65-L68`), and a swallowed open changes
  none of the three. No command can see the attempt. Seeing it would take a trace of every open
  `probe` makes, and this target has none. That half of the bound is held by QC-15's review at
  `development-design`, which judges which read the adapter makes inside its owner file
  *(through v33 this tail said none of the three was written at
  `ka-reader@8edec4f`, where the `linked-worktree` and `submodule` cases asserted an unchanged scene
  and no outcome and the adapter answered a `.git` file with a provisional condition, and that all
  three would go red until the change replacing that arm landed. It landed at `ka-reader@48308ff`.
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
  check has one implementation its two callers do not re-implement. **Not covered by this check,
  and named so it is not read as coverage:** a path libgit2 takes from a file it loads for the
  repository — the config domain SDD § 11 R-16 states as a rule and measures as six members at
  `libgit2-sys 0.18.8+1.9.7`, and the `objects/info/alternates` file beside it — never passes this
  check. `git-reader` refuses a repository where such a path spells to a location outside the
  folder, or is in a form it does not locate, by a check of its own that reads the file inside the
  folder with a walk that follows this check's rule (ADR-0023; QC-15). The config check and the
  alternates check run before libgit2 opens anything. `.gitmodules`, which libgit2 loads during
  the status read, is checked after the open and before that read, every section of it included:
  a section whose path spells outside the folder, or begins `/`, is refused, and so is one that
  would give a path the status read looks up another location. That last refusal is decided
  against the set of paths the status read looks up, which SDD § 11 R-16 measures as the index's
  gitlinks at the same `libgit2-sys` version, so the set is pinned there beside the six members,
  and a version change re-measures both at the lockfile review (QC-26; ADR-0023, *Decision*, last
  bullet). A libgit2 that looked up more paths would leave a section naming an extra one
  unchecked. `test_looked_up_kinds_the_measurement_found_are_refused`
  (`crates/ka-reader-core/tests/git_state.rs:L3017`) would see an opener for the one kind it runs, a
  working-tree folder holding `.git` with no gitlink, and no case watches any other *(through v44
  this passage closed on "**Still uncovered, and named:** a `.gitmodules` section's path and the
  submodule map — their refusals are stated and not built, which SDD § 11 R-16 calls a known
  defect", with the sandbox (QC-25) as the only bound in the bundle and nothing in the harness for
  a section naming a location outside the folder, and nothing in either for one naming another
  location inside it; it closed on SDD *Open Questions*' config-named-path item, "open on its
  `.gitmodules` case alone, settled before `see-git-status` is reached", and held that bound by
  review of the change after which `see-git-status`'s *Reached when* is claimed whole, "where a
  case's fixture and its case are missing at that review, the slice is not reached". Both
  refusals are built at `ka-reader@772c63b`, SDD v46 removed the item, and the fourth case and its
  fixture are in the tree — RN-56)*. The adapter's walk is a second implementation
  of this check's rule — `git-reader` may not import `fs-reader` (QC-11) — and whether the two walks
  agree has not been compared, which SDD RN-99 records as its own finding (SDD § 3 `git-reader`;
  § 4 C-D3; § 11 R-16, *Built, and the cases that hold it* and *Which paths the status read looks
  up*, as they read at v46 — RN-56; § 11 R-16 and *Open Questions*' config-named-path item, which
  SDD v46 removed, as they read at v43 — RN-55,
  and at v42 — RN-53; through v43 this passage named a second uncovered case, "(b) the
  alternates read, whose refusal is stated and not built", and read the item as "open on its
  alternates and `.gitmodules` cases", and said "The config check runs before libgit2 opens
  anything" — RN-55; through v41 this sentence named three keys "which libgit2 follows with no containment check",
  with the sandbox as the only bound in the bundle, from SDD v32 — RN-51; through v39 the bound
  read "no later than the build in which `mac-shell` first calls `ka_reader_read_git`", from SDD
  v31 — RN-49; through v37 this pointer read "*Open Questions*' last item", which stopped naming
  this item at SDD v29).
  — *verified by:* unit tests on the check (layer 1, beside the module —
  `crates/ka-reader-core/src/fs_reader.rs` `mod tests`): `..` leaving the grant and a symlink out end
  `Outside`; the four spellings the definition turns on — three fixed by `docs/fdr.md`'s example
  rows (`:L357-L358`), the fourth by R-184's second clause: the re-entry on the folder's own name
  in another letter case, in both forms the rows fix — `self → ../KA-READER`, ending `Cycle`
  (R-152), and `up → ../KA-READER/docs`, resolving inside and read as its target (R-34, R-151); the
  multi-level return (`far → ../../projects/KA-READER/docs`) ending `Outside`; the volume root
  (`back → ../Work/notes.txt` under `/Volumes/Work`) ending `Outside`; and a Unicode-normalization
  difference ending `Outside`, which no example row exercises and which rests on R-184's second
  clause and SDD § 11 R-10 alone. None of the four is written at `ka-reader@368f127` (`mod tests`
  holds the `..` and symlink cases, `:L412-L578`), and two go red when they are, until the change
  that builds the check as defined lands: the re-entry, in either form — the walk keeps one
  lexical position and at a position outside the grant moves it by name and touches nothing
  (`:L170-L177` states it, `:L211-L215` does it), so `../KA-READER` ends `Outside` (measured at
  `docs/trail/sdd/cycle-15.md` § 5.1 on `ka-reader@46bb275`; `git diff --stat 46bb275 368f127 --
  crates` prints nothing) — and the volume root, read from the code and not run: `..` pops the
  root to its parent (`:L201-L203`), `Work` re-enters lexically to a position equal to the root
  (`:L211-L215`), and `notes.txt` is then `lstat`ed from inside (`:L217`), so the walk reads what
  the definition refuses. That nothing is read at a position outside the grant
  is QC-35's, at layer 5, not a claim of these unit tests. `cargo test --locked -p ka-reader-core
  --test markdown` — the `..` and symlink-out fixtures yield a placeholder node — and `cargo test
  --locked -p ka-reader-bridge --test asset_bytes` — `asset_bytes` refuses them, tested in the bridge's
  crate where § 3 places the function (SDD § 6 S-3 at v14, RN-64) (layer 2). What `git-reader`'s
  check holds is QC-35's to verify *(traces to: ADR-0015; ADR-0023, which superseded ADR-0022 at
  v45 — RN-56;
  ADR-0011; SDD § 3 `fs-reader` at v20, SM-7; § 4 C-D1, C-D3 — its uncovered case at v27, RN-43; § 9 TO-6; § 11 R-10, R-16; SRS FR-32,
  NFR-16; FDR R-34, R-59, R-62, R-183, R-184; the owner's answer at `docs/trail/sdd/cycle-15.md`
  § 5.1; the `asset_bytes` half moved to the bridge's crate at v12 — RN-23; re-derived on SDD v20 —
  RN-29; the config-named-path item's bound re-derived on SDD v32 (SDD RN-92) — RN-51; the
  uncovered case re-derived on SDD v42 (SDD RN-99 – RN-102), on the item raised at
  `docs/trail/architecture/cycle-36.md` § 2.1 — RN-53; the alternates case dropped from it,
  re-derived on SDD v43 (SDD RN-103), on the owner's seat's answer at
  `docs/trail/architecture/cycle-38.md` § 3.1 — RN-55; the `.gitmodules` sections built, the
  closing pointer and its review bound retired, and the looked-up set named beside the six
  members, re-derived on SDD v46 (SDD RN-106), on the owner's seat's answer at
  `docs/trail/architecture/cycle-39.md` § 3.1 — RN-56)*
- **QC-7:** `git-reader` makes no mutating call — no checkout, index write, ref update or lock
  file — and spawns no process; every port method is read-only.
  — *verified by:* `checks/read-only.sh` on the Git fixtures with `.git/index` hashed (layer 3);
  `checks/structure.sh` rule *no `std::process` in any shipped crate* (layer 6) *(traces to:
  ADR-0019; SRS NFR-6, AC-2; SDD § 3 `git-reader` "Must not own")*

### 1.2 Forbidden imports

One graph, both halves stated. "May import" is the whole allowed set; "must not import" is stated
explicitly and never inferred. A module of `ka-reader-core` that is no part is QC-63's, and importing
one is not an edge of this graph *(drafted at v29 — RN-40; confirmed at v30 — RN-41)*.

- **QC-8:** `ka-reader-mac` may import AppKit and Foundation — the platform's own — and its own
  modules, and it links `libka_reader_bridge.a` through the generated header. It **must not** declare
  a package dependency (`Package.swift` declares none; no `Package.resolved` exists), **must not
  import** `WebKit` or `JavaScriptCore`, and `surfaces` **must not** reach the bridge — a surface
  hands `mac-shell` an intent and never calls `SM-4`.
  — *verified by:* `checks/view.sh` (layer 6): the forbidden-symbol scan over `ka-reader-mac/Sources`
  and `otool -L` on the built executable naming neither `WebKit` nor `JavaScriptCore`;
  `checks/no-network.sh` — no Swift dependency, no `Package.resolved`; `swift test --package-path
  ka-reader-mac` — the shell issues no call `SM-4` does not name (SDD § 6 S-1) *(traces to:
  ADR-0021; ADR-0014; ADR-0020; SDD § 3 `mac-shell` and `surfaces` "Must not own", SM-8; § 4 C-R6, C-R7;
  re-derived at v11 — RN-22)*
- **QC-9:** `ka-reader-core` **must not import** any Apple framework or a binding to one, any crate
  outside `checks/deps.allow`, or `std::process`, and **holds no `unsafe`** — the workspace forbids
  it, and only `ka-reader-bridge`'s manifest relaxes it. *No `unsafe`* is said of each crate's own
  Rust source. The C that `ka-reader-core` links — the grammar engine's runtime and six grammars
  today (SDD § 3 `highlighter`), and libgit2, which `git-reader` links — is compiled in beside
  that source and is outside the claim, so this entry does not say the unit runs only
  memory-safe code. A fault in that C is bounded by the sandbox (QC-25), which this entry does
  not replace (SDD § 11 R-14).
  — *verified by:* `checks/no-network.sh`; `checks/structure.sh` (layer 6) — the imports, and
  `unsafe` appearing in no crate but `ka-reader-bridge`; `cargo build --workspace --locked` under
  `[workspace.lints.rust] unsafe_code = "forbid"`, a build failure on an `unsafe` block in any
  crate whose manifest does not relax it *(traces to: ADR-0021; ADR-0020; ADR-0017; SDD § 3, the units paragraph; § 4 C-R6; `Cargo.toml`
  `[workspace.lints.rust]`; re-derived at v11 — RN-22; the limit from SDD § 3's units paragraph
  and § 11 R-14 as they read at v23 — RN-34; libgit2 stated as linked, which it has been since
  `ka-reader@126ef75` (`crates/ka-reader-core/Cargo.toml:L9`) — RN-43)*
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
  `ka-reader@705d306` (its reasoning, `docs/trail/sdd/self_answer-22.md` § 2.4); `arch_defaults.md`
  § Dependency Graph Rules; transcribed at v12 — RN-23)*
- **QC-11:** `fs-reader`, `git-reader`, `watcher`, `highlighter` and `markdown-renderer` **must not
  import** `folder-model`, `own-state`, or one another — with two stated edges: `markdown-renderer`
  imports `fs-reader`'s containment check, and `highlighter` for a fenced block's spans. Only
  `git-reader` imports the libgit2 binding, with one exception: `core-bridge` names it in the
  composition root's config search-path switch and that switch's test, and nowhere else (QC-17).
  — *verified by:* `checks/structure.sh` (layer 6). What it holds of this entry is stated in its
  header and cited here, never copied: *THE SCAN TABLE*'s unit-edge row
  (`checks/structure.sh:L110-L149`) and libgit2-binding row (`:L167-L181`), and *WHAT IS NOT HELD*
  (`:L321-L336`), all at `ka-reader@82a3fb1`. At that commit the header holds the clauses whose
  subject is `fs-reader`, `highlighter`, `git-reader`, `watcher` or `markdown-renderer`, and the
  suite `checks/tests/test_structure.sh` plants a break of each
  (`test_fs_reader_forbidden_units_are_rejected`, `test_highlighter_forbidden_units_are_rejected`,
  `test_git_reader_unit_edges_are_rejected`, and for the two units with no file
  `test_future_unit_files_are_judged_without_editing_the_scan`). `watcher` and `markdown-renderer`
  have no file yet: their clauses are held as rules, proved on planted files, and judged from the
  run in which a file of either first appears, so *held* is not *measured on their code*. **The
  libgit2-binding clause is held across the whole shipped scope of every crate**: the binding row,
  on `main` since `ka-reader@fc14574`, exempts every file of the `git_reader` unit and
  `crates/ka-reader-bridge/src/machine_config.rs` (the exempting `case` at `checks/structure.sh:L1459`
  at `ka-reader@82a3fb1`), and at that commit the script exits 0 printing "17 Rust files in 2
  crates read — nothing found" and its suite exits 0 with 112 `ok` lines. Three parts of this
  entry's bound stay review at `development-design`. The first two are the exception's: the script
  exempts a file and reads a scope, and the exception is a call and its test. (1) Inside
  `machine_config.rs` the binding is allowed for the switch alone, and the script exempts the whole
  file, which also holds the adapter's constructor
  (`crates/ka-reader-bridge/src/machine_config.rs:L138-L139` at `ka-reader@82a3fb1`). (2) Under
  `crates/ka-reader-bridge/tests/` the binding is allowed in the switch's own test alone, and the
  script reads `tests/` for the layer-5 rule only (`checks/structure.sh:L46-L47` at
  `ka-reader@82a3fb1`), so a second bridge test that names `git2` draws no finding. At
  `ka-reader@82a3fb1` the bridge files that name `git2` are `machine_config.rs`,
  `tests/search_path.rs` and the manifest (`grep -rln git2 crates/ka-reader-bridge`), which is the
  exception's bound exactly. (3) `markdown-renderer`'s stated edge into `fs-reader` reaches the
  containment check alone, and the scan judges an import a whole unit at a time, so no import of
  `fs-reader` by a `markdown-renderer` file draws a finding (*WHAT IS NOT HELD*,
  `checks/structure.sh:L331-L334` at `ka-reader@82a3fb1`) *(through v62 this tail said the script
  still listed QC-11's clauses whose subject is `git-reader`, `watcher` or `markdown-renderer` as not
  held (`checks/structure.sh:L270`), and cited the binding row at `:L130-L142`, the exempting `case`
  at `:L1186` and the `tests/` reading at `:L41-L42`, each true at `ka-reader@076eac2` and none
  pinned; it measured the pass line ("16 Rust files in 2 crates read — nothing found") and the
  bridge files that name `git2` at that commit, and named two review-held parts. The scan's
  version 1.6.0, merged at `ka-reader@82a3fb1`, holds the three subjects. On the owner's seat's
  answer at `docs/trail/architecture/cycle-56.md` § 3.1 — RN-74)* *(through v41 this tail said the script did not hold the import rule
  outside the three units' files it read (`checks/structure.sh:L257-L258` at `ka-reader@392177d`),
  so the whole bound stayed review until a change added it; that change landed at
  `ka-reader@a611cf1` and merged at `ka-reader@fc14574`. On the owner's seat's answer at
  `docs/trail/architecture/cycle-36.md` § 3.1 — RN-53)* *(drafted at v38 — RN-49; confirmed in the
  owner's seat at `docs/trail/architecture/cycle-35.md` § 2.1 — RN-50; through v37 this tail pinned the script at `:L249-L250` at `ka-reader@8edec4f` and named
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
  `crates/ka-reader-core/src/folder_model.rs:L38` and imported at `fs_reader.rs:L14` at
  `ka-reader@803b599`, is the one type that does not, and moves to `fs-reader` by a
  behaviour-preserving change that keeps `ka_reader_core::OpenFailure`; `checks/structure.sh` holds
  the `fs-reader` → `folder-model` clause from that change, and until it the clause's gate is
  `development-design` — RN-40)*
- **QC-63:** A module of `ka-reader-core` that is no SDD part is a **value module**: it holds types
  and values only — shared between parts, or exposed through the crate's public surface — holds no
  I/O (QC-15), and **imports no part**. Any part may import a value module, and that import is not
  an edge of this graph: QC-10's and QC-11's sets neither name it nor need to. A module that would
  have to import a part to hold its type is not a value module; the type moves into a part, under
  QC-10 and QC-11, so no forbidden edge can route through a module the graph does not see.
  `lib.rs` is the crate's re-export surface: it declares the modules and re-exports from them,
  holds no implementation, and is neither a part nor a value module. At `ka-reader@803b599` the
  value modules are `language` and `error`, and neither imports a part.
  — *verified by:* `checks/structure.sh` (layer 6): a file of `ka-reader-core` that belongs to no
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
- **QC-13:** `ka-reader-bridge` may import `ka-reader-core`, the standard library and the crates
  `checks/deps.allow` names — the whole allowed set, in the form QC-9 bounds `ka-reader-core` with,
  and never a hand-kept list of names, which goes false at the bridge's next reviewed dependency.
  It **must not
  import** any Apple framework or `std::fs` outside its log writer, and holds no read logic: every
  exported function decodes its arguments, calls `folder-model`, and returns plain data as an
  owned buffer freed by `ka_reader_free`. Beside the exported functions it runs process setup before
  first use — the log writer's install and libgit2's config search-path switch (QC-17) — and that
  setup is no read logic. It is the one unit that holds `unsafe`, relaxed in its own
  manifest with the reason recorded; every function catches a panic at the boundary and returns a
  failure value; the header is generated from its source and never hand-edited.
  — *verified by:* `checks/structure.sh` (layer 6) for the imports; `cargo test --locked -p
  ka-reader-bridge --test exports` — the header declares what the library exports and nothing else
  (QC-24); the bridge's tests under `-Zsanitizer=address` in CI on every build (layer 2), a run that
  admits `-Cllvm-args=-asan-globals=0` beside the sanitizer flag, as the gate's *Bridge tests under
  the address sanitizer* step passes both (`checks/gate.sh:L57` at `ka-reader@389adad`). **Why the
  flag is admitted.** It turns off only the sanitizer's padding around global and static variables:
  in LLVM, `if (Opts.asan_globals)` wraps `instrumentGlobals` alone (`AddressSanitizer.cpp:L2645`,
  llvm-project `main` at `044150762369`, read 2026-10-22), so the load, store, heap and stack checks
  still run, and with one bridge test changed to overflow a heap buffer the step's command exited 101
  with `AddressSanitizer: heap-buffer-overflow` (the PM's measurement,
  `docs/trail/architecture/cycle-54.md` § 3.2). What R-13 guards is a buffer freed twice or never and
  a lifetime crossed at the C ABI, and every buffer the bridge hands across is an owned heap buffer
  `ka_reader_free` frees, as this entry requires; at `ka-reader@389adad` every `unsafe` site in the
  bridge works on a caller's pointer, a heap box or the stack, and none on a static. **Why it is
  needed.** LLVM skips ELF's init arrays but not Mach-O's `__mod_init_func` (`shouldInstrumentGlobal`,
  `AddressSanitizer.cpp:L1986-L1992` at the same commit), so the bridge's load-time initializer,
  `INSTALL_LOG_AT_LOAD` (`crates/ka-reader-bridge/src/exports.rs:L141-L143`), is padded and the
  linker refuses it (`checks/gate.sh:L55-L56`). **Its limit.** The flag reaches every crate built for
  the host target, not only the bridge; in `ka-reader-core`, which holds no `unsafe`, it costs
  nothing. The admission lapses for a change that hands a static across the ABI or reaches one
  through a raw pointer; such a change already breaks this entry's owned-buffer rule, and
  `development-design` reading this entry is its gate. If a later toolchain links the instrumented
  initializer, the gate may drop the flag with no change here. The run is not claimed to catch a
  leak, a buffer freed never *(added at v61, in the owner's seat at
  `docs/trail/architecture/cycle-54.md` § 3.2 — RN-72)*; review at
  `development-design` for the delegation rule — what counts as logic is not greppable, and the
  import rule is the part that is; the allowlist admits a crate to the workspace and not to a
  purpose, so a listed parser or grammar engine imported to put read logic in the bridge is that
  review's catch, and QC-11 keeps the libgit2 binding out by name but for the search-path switch
  and its test (QC-17) *(traces to: ADR-0014; ADR-0020; SDD § 3 `core-bridge`
  "Owns" and "Must not own" as they read at v27 — the switch, RN-87, re-derived at v32, RN-43 —
  SM-4; § 4 C-I2; § 11 R-13; `arch_defaults.md` § Application Layer; re-derived at v11 —
  RN-22; the *may import* set answered in the owner's seat at
  `docs/trail/architecture/cycle-10.md` § 3.1 — RN-24; the sanitizer run's admitted flag, the owner's
  seat's answer at `docs/trail/architecture/cycle-54.md` § 3.2 — RN-72)*
- **QC-14:** `checks/` may import `ka-reader-core` and is **never a dependency of any shipped
  unit** — the `ka-reader-core` library, the `ka-reader-bridge` static library or the `ka-reader-mac`
  executable, each as it ships, and never a test target declared in one of their manifests — and
  never ships in the bundle.
  — *verified by:* `cargo tree -p ka-reader-bridge` names no `checks` crate; `checks/structure.sh`
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
  common directory; the content of the `commondir` file in a Git directory that lies inside the
  folder; before libgit2 opens anything, the config check's reads — the `config` in the common
  directory, `config.worktree` in the Git directory where `extensions.worktreeConfig` is set, and
  each file those include whose path spells to a location inside the folder, the working tree
  included; before libgit2 opens anything, the alternates check's reads — `objects/info/alternates`
  under the common directory, and the `info/alternates` of each alternate object directory that
  spells inside the folder, to libgit2's depth of five; the metadata, and a link's own text, at
  each position inside the folder along the spelled path of `objects`, `info`, `alternates` and
  each entry; after the open and before the status read, `.gitmodules` in the working tree of the
  repository and of each submodule it verifies, and each file it includes that spells inside the
  folder; the metadata, and a link's own text, at each position inside the folder along the
  spelled path of every value the config check or the `.gitmodules` check locates; and, for each
  submodule verified before the status read, its `.git` entry's metadata, the reads above that
  locate its Git directory and its common directory, its config check and its alternates check —
  never a path past the folder and never a link followed out of it); change
  notifications are `watcher`'s
  (FSEvents); the diagnostic log writer is `ka-reader-bridge`'s; the Open panel and the one window
  are `mac-shell`'s, in `ka-reader-mac`; drawing is `surfaces`', in `ka-reader-mac`, which holds no I/O
  of its own; **no unit owns a socket and no unit spawns a process.**
  — *verified by:* `checks/structure.sh` (layer 6): each Rust I/O primitive appears only in its
  owner. Its filesystem clause exempts three owner files by exact path: `fs_reader.rs`,
  `log_writer.rs` and `git-reader`'s adapter, `crates/ka-reader-core/src/git_reader/libgit2.rs`
  (`checks/structure.sh:L82-L85`, the exempting `case` at `:L1451`, at `ka-reader@82a3fb1`
  *(through v63 these read `:L77-L80` and `:L1161`, at `ka-reader@48308ff`, where the three files
  are spelled `crates/nozoki-*` — RN-75)*). The
  adapter may name `std::fs`, and a `std::fs` read anywhere else in `git-reader` is a finding. The
  suite holds the exemption to the exact path. `test_exemption_is_exact_for_the_adapter_name`
  plants a `std::fs` write under the adapter's file name at six other paths and requires a QC-15
  finding at each, and `test_git_owner_write_is_still_one_qc2_finding` holds that the exemption
  lifts this clause only (`checks/tests/test_structure.sh:L988`, `:L958`, at `ka-reader@82a3fb1`).
  The scan does not see a `Path` method that touches the filesystem, in any crate, because such a
  method names no filesystem module (`checks/structure.sh:L341-L342`, *GAPS THE RULES ABOVE DO NOT
  CLOSE*, at `ka-reader@82a3fb1`). Two parts of the `git-reader` bound are therefore not held by the
  script (`:L327-L330`, *WHAT IS NOT HELD*, at `ka-reader@82a3fb1`) *(through v63 these four
  locators read `test_structure.sh:L961` and `:L931`, `structure.sh:L266-L267` and `:L253-L256`,
  with no commit named; each was true at `ka-reader@48308ff` and fell in another row or another
  case's body once the scan was re-wrapped and reached version 1.6.0 — RN-75)*. The first is
  which read the adapter makes inside its owner file: the script admits every filesystem form
  there, so it cannot tell a read inside the folder from one past it. The second is `git-reader`'s
  `Path`-method reads, which is how the adapter reads the folder, the `.git` entry and each
  position along a spelled path (`crates/ka-reader-core/src/git_reader/libgit2.rs:L54`, `:L58`,
  `:L103`, `:L163`, `:L513`, at `ka-reader@6a0725c`; the `.git` file's open is at `:L439` and its
  handle's `metadata()` at `:L446`) *(through v36 these locators were pinned at `ka-reader@48308ff`,
  as `:L38`, `:L42`, `:L136`, `:L62` and `:L69`, before `state()` and the walk landed — RN-48)*.
  For those two parts only, the bound is review
  at `development-design`, which judges each against the clause above *(through v33 this tail
  exempted two owner files at `ka-reader@8edec4f`, named QC-15's other owners as not held, and held
  the adapter's file as a rule still to come, with review as the whole bound until it came. The
  change that adds it merged at `ka-reader@48308ff`. On the owner's seat's answer at
  `docs/trail/architecture/cycle-31.md` § 3.1 — RN-45)*. Every read the list names is the
  adapter's, in its owner file — `check_config` (`crates/ka-reader-core/src/git_reader/libgit2.rs:L191`),
  `follow` (`:L252`) and `verify_submodules` (`:L285`), at `ka-reader@076eac2`; and `check_alternates`
  (`:L303`, at `ka-reader@66f428d`), which reads each alternates file through `read_alternates`
  (`:L366`) and each position through the walk's `inspect_on_disk` (`:L517`) — and the scanners
  those checks parse with read nothing: `config_scan.rs`'s `scan` takes bytes
  (`crates/ka-reader-core/src/git_reader/config_scan.rs:L66`, at `ka-reader@66f428d`), and so does
  `alternates_scan::scan`
  (`crates/ka-reader-core/src/git_reader/alternates_scan.rs:L28`, at `ka-reader@66f428d`), where `grep -nE
  'std::fs|File::|read_to|OpenOptions|read_link|metadata'` prints nothing *(the config,
  `.gitmodules` and submodule reads, and the walk along each value, on the owner's seat's answer
  at `docs/trail/architecture/cycle-36.md` § 3.2; `.gitmodules` named once SDD v42's `git-reader`
  row owns it, SDD RN-102 — RN-53; the alternates check's reads, from SDD v43's `git-reader` row
  (SDD RN-103), on the owner's seat's answer at `docs/trail/architecture/cycle-38.md` § 3.1 —
  RN-55; through v43 this tail read "The alternates read is owned by SDD § 3's `git-reader` row and
  is not built (`grep -rl alternates checks crates ka-reader-mac/Sources` prints nothing at
  `ka-reader@076eac2`), so the list does not name it until it occurs: the change that builds it owes
  this list that read, through review at `development-design`" — RN-55)*. `checks/view.sh` (layer 6): no I/O
  primitive in `ka-reader-mac/Sources` at all *(traces to: ADR-0021; ADR-0020; ADR-0018; ADR-0023,
  which superseded ADR-0022 at v45, the list unchanged — RN-56;
  SDD § 3 parts table, and the `git-reader` row's *Must not own*, "A file outside Git's
  own on-disk layout", with its three exceptions as it reads at v42 (SDD RN-99, RN-100, RN-102); § 4
  C-R7; the bounded reads and their gate on the owner's seat's answer at
  `docs/trail/architecture/cycle-29.md` § 3.3 — RN-43; the three owner files, the suite's two
  cases and the narrowed gate on the owner's seat's answer at
  `docs/trail/architecture/cycle-31.md` § 3.1 — RN-45; the walk's reads and the `commondir` read
  named in the list, and the `Path`-method locators re-pinned at `ka-reader@6a0725c`, on the owner's
  seat's answer at `docs/trail/architecture/cycle-33.md` § 3.1 — RN-48; the config, `.gitmodules`
  and submodule reads named in the list, on the owner's seat's answer at
  `docs/trail/architecture/cycle-36.md` § 3.2 — RN-53; the alternates check's reads named in the
  list, from SDD v43's `git-reader` row (SDD RN-103), on the owner's seat's answer at
  `docs/trail/architecture/cycle-38.md` § 3.1 — RN-55; every scan and suite locator re-pinned at
  `ka-reader@82a3fb1`, and the `config_scan.rs` locator given its own pin, on the owner's seat's
  answer at `docs/trail/architecture/cycle-57.md` § 2.1 — RN-75)*
- **QC-16:** The only writes the product performs are `own-state`'s and the bridge's diagnostic
  log, both inside `~/Library/Containers/com.kensaiapp.ka-reader/`.
  — *verified by:* `checks/own-state.sh` — after a session every changed file under `$HOME` is
  under the container and none under the fixture (layer 5) *(traces to: SDD § 4 C-D2, C-I2; SRS
  FR-21, AC-13; ADR-0021; ADR-0020 — the trace its § Binds names, added at v12 against ADR-0016 — RN-23 — and carried to ADR-0020 at v33, RN-44)*
- **QC-17:** Two composition roots, one per language, and each is the single place its runtime is
  touched: `ka-reader-bridge` is the Rust-side root — the only place the libgit2 adapter is wired to
  the Git port, the only place the log writer is installed, and the only place libgit2's four
  machine-level config search paths — system, global, XDG and programdata — are set to empty. That
  is four `git2::opts::set_search_path` calls, run once per process, before the adapter is wired and
  before any thread can reach libgit2, and failing closed: if any of the four fails, the adapter is
  not wired and the Git item is `failed`, so no repository is opened with those reads on.
  `mac-shell` in `ka-reader-mac` is the
  app's root — the only place `NSApplication` and the one window are created and the only place
  `SM-4` is called.
  — *verified by:* `checks/structure.sh` (layer 6): the adapter's constructor and `log::set_logger`
  / `log::set_boxed_logger` appear only under `crates/ka-reader-bridge/src/`; `checks/view.sh`
  (layer 6): a `ka_reader_` symbol the header declares is called from `mac-shell`'s sources and from
  no file of `surfaces` — a rule this document adds to the script (RN-22); `cargo test --locked -p
  ka-reader-bridge`, which CI runs on every push inside `cargo test --workspace --locked`
  (`.github/workflows/ci.yml:L35` at `ka-reader@f0f1e5f` *(through v48 cited `:L26` with no commit
  named, true through `ka-reader@c915d52`; moved by the `Toolchain` step at `ka-reader@d852457` and the
  app build's move ahead of `Test gate` at `ka-reader@d2694c7` — RN-60)*). The switch is `crates/ka-reader-bridge/src/machine_config.rs`,
  landed at `ka-reader@392177d`, and the suite holds its three promises. The four empty paths:
  `test_the_switch_against_the_real_libgit2` (`crates/ka-reader-bridge/tests/search_path.rs:L36`),
  whose first arrival is a production session's open, after which it reads each of the four
  levels' search paths back empty with `git2::opts::get_search_path` (`:L47-L55`). Failing closed
  and once per process: `machine_config.rs`'s `mod tests` — any one of the four erring is `Failed`
  (`:L213`), no retry after `Failed` (`:L249`), and concurrent first arrivals set four paths in
  total (`:L262`) — and `session.rs`'s erring-setter cases, in which the Git item answers that the
  config was not switched off (`:L1798` at `ka-reader@076eac2`) and stays so after a second folder
  opens (`:L1809`) *(through v41 these read `:L1729` and `:L1740` with no commit, true at
  `ka-reader@e89b5b6`; the file grew above both cases after that commit — RN-53)*. The
  read-back proves four empty paths and observes no read: the step from an empty path to no file
  touched is `libgit2/src/libgit2/sysdir.c:L559-L560` in the registry copy of
  `libgit2-sys 0.18.8+1.9.7`, read and not run. A bridge that wires the adapter with no switch run
  before it, or with no test of the switch, violates this entry *(through v37 this tail said the
  switch and its test were not in the tree at `ka-reader@8edec4f`, and that the gate was
  `development-design` until the change that wires the adapter in the bridge; that change landed at
  `ka-reader@392177d` — RN-49)*. A libgit2 release that adds a fifth
  level is not caught by a test naming four, and the lockfile change reviewed as code (QC-26) is
  the only gate for it *(traces to: ADR-0014; ADR-0020; SDD § 3 `core-bridge`
  as it reads at v27, `mac-shell`, SM-8; § 4 C-I3 at v27 — the bridge test and what it does not
  reach; SDD RN-87; `arch_defaults.md` § Composition Root; re-derived at v11 — RN-22; the switch
  re-derived at v32 — RN-43; the switch, its read-back and its fail-closed and once-per-process
  tests as landed, from SDD § 4 C-I3 as it reads at v31 (SDD RN-91), on the owner's seat's answer
  at `docs/trail/architecture/cycle-34.md` § 3.2 — RN-49)*

### 1.4 Replaceability

- **QC-18:** Swapping the Git mechanism — libgit2 for the installed `git` run with
  `--no-optional-locks` — touches `git-reader` (the adapter) and `ka-reader-bridge`'s wiring only; the
  port, the model and the surfaces do not change.
  — *verified by:* review at `development-design` when a change touches `git-reader`; the port's
  contract tests (QC-50) pass unchanged against the new adapter *(traces to: FDR PD-29; SRS § 5.3;
  ADR-0019)*
- **QC-19:** The viewed folder is an input, not a structural singleton: opening a different folder
  replaces the whole model, and adding the folder selector touches `folder-model`'s replace,
  `own-state`'s bookmarks, `mac-shell`'s launch-time restore and the shell chrome only — the tree,
  the Git view and the reading panel
  do not change.
  — *verified by:* `cargo test --locked -p ka-reader-core --test switch` (layer 3);
  `git diff --stat <first-public-release tag>..HEAD -- ka-reader-mac` lists only files of the selector
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
artifact ↔ the adopter: a CI build from a tag with a published checksum (ADR-0024, which
superseded ADR-0007 at v55 — RN-66). The threat
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
  — *verified by:* `cargo test --locked -p ka-reader-core --test markdown` over `checks/fixtures/hostile.md`
  (layer 2) *(traces to: SRS NFR-16, FR-32, AC-23; SDD § 3 `markdown-renderer` and the
  `MarkdownDocument` entity; § 4 C-D3; § 6 S-3, command half; § SDD Review Notes RN-8 — the SVG
  case; ADR-0015; re-derived at v11 —
  RN-22)*
- **QC-23:** No web engine of any kind is in the product: `ka-reader-mac` links neither `WebKit` nor
  `JavaScriptCore`; its sources hold no `WKWebView`, `WebView`, `JSContext`, or
  `NSAttributedString` initialised from HTML or with the `.html` document type; and no crate in the
  resolved tree is a web engine or a binding to one. There is no Content Security Policy to
  declare, because there is no engine to declare it to — the previous shape's CSP and its
  `<asset-scheme>` keying, which this entry carried through v10, are retired with it.
  — *verified by:* `checks/view.sh` (layer 6): the forbidden-symbol scan over `ka-reader-mac/Sources`
  and `otool -L` on the built executable; `checks/no-network.sh` with QC-3's second half — an
  allowlist change that admits a web engine or a binding to one is refused at the same-change
  review, by name, under C-R1 (the tree; the change) *(traces to: SDD § 4 C-R1 — "no web engine of
  any kind", C-R7; § 10 RC-3; ADR-0014;
  ADR-0015; the two-state form this entry carried through v10 was answered in the
  owner's seat at `docs/trail/architecture/cycle-5.md` § 3.2 — RN-18 — and is history; re-derived
  at v11 — RN-22)*
- **QC-24:** A build exports to the shell exactly the functions its landed changes built — set
  equality between the C symbols `libka_reader_bridge.a` exports (`nm -gU`, the `ka_reader_` prefix) and
  the functions the generated header declares — and that set is always inside the closed list
  `docs/SDD.md` § 3 `SM-4` names — `open_folder`, `list_tree`, `select_file`, `open_relative_link`,
  `read_git`, `set_theme`, `open_diff`, `walk_history`, `switch_folder`, `asset_bytes`, ten *(nine
  through v37, without `read_git` — RN-49)* — and `ka_reader_free`,
  the seam's one release call beside the list and not on it, exported from the first build on
  because every call's return is an owned buffer it alone frees. No listed function is exported
  before a landed change has built it — a change has built a function when the bridge function
  exists and delegates to an operation `folder-model`'s API carries (`SM-5`) — and from `v1.0.0`
  the set is that list whole and `ka_reader_free`. No
  second plumbing export — a registration call for `model_changed`, or any other — is admitted:
  one is raised on C-R7 and `SM-4` by the slice that needs it, and not before. The header is generated
  from the bridge's source and never hand-kept; the test reads the exported set and never a
  hand-kept copy of it, and an exported set it cannot read fails the test — never a pass.
  **Not covered before `v1.0.0`, and named so it is not read as coverage:** a change that stops
  exporting a function an earlier slice built passes this check, because the export and the
  header move together; until QC-59's pin exists, only that slice's own bar holds the function.
  — *verified by:* `cargo test --locked -p ka-reader-bridge --test exports` (layer 2), holding two
  things: set equality between the exported symbols and the header's declarations, and that set
  inside the list above and `ka_reader_free`. From `v1.0.0` the whole list and `ka_reader_free` are held
  by QC-59's pin, which reads `SM-4`'s function list and `ka_reader_free` as the bridge exports them
  *(traces to: SDD § 3 SM-4 as it reads at v30 — the list of ten, `read_git` added (SDD § 10 RC-4,
  RN-90) — RN-49; § 4 C-R7 as it reads at v22 — the export staged by change and not by
  slice, and what *built* means, on the owner's seat's answer at
  `docs/trail/architecture/cycle-18.md` § 3.1 — RN-32;
  § 4 C-I6; § 11 R-12; § SDD Review Notes RN-47, RN-60, RN-66; ADR-0021 — RN-49, accepted over
  ADR-0013 at v39 — RN-50; ADR-0020, whose units table names `ka_reader_free` apart from the list; QC-59; the staged form answered in the owner's seat at
  `docs/trail/architecture/cycle-6.md` § 3.1 — RN-19 — carried from the capability file to the
  export set at v11 — RN-22; `ka_reader_free` beside the list confirmed with additions in the owner's
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
  sandboxed. And every hosted CI build shows, in its own log, whether the unentitled control's
  out-of-grant read was reported denied on the image it ran on.
  — *verified by:* two halves, and the entry holds only with both. **(1) The set equals the recorded
  set, and the process is sandboxed:** `checks/bundle.sh` — `codesign -d --entitlements :-
  KA-Reader.app` equals the set the script expects (`ka-reader@0aca57e:checks/bundle.sh:L132-L133`,
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
  separates nothing. That narrowing is a reading of two images: `macos-14`, GitHub Actions run
  35797893381 (`docs/SDD.md` RN-48); and `macos-26-arm64` 20260907.0351.1, macOS 26.6.2 (25G83),
  GitHub Actions run 38577309118 on `ka-reader@f357008`, whose control reported the read
  `out-of-grant-read: denied` — the first reading on that image version, and the one recorded
  (`docs/SDD.md` C-I3 at v51, RN-111; RN-62) *(through v50 this read: "That narrowing is a reading
  of one image: `macos-14`, GitHub Actions run 35797893381 (`docs/SDD.md` RN-48). CI has run on
  `macos-26` since `ka-reader@fcb2e2f`, and the narrowing has not been read there. The gap
  overclaims nothing: the narrowing only removes the read denial from the evidence, and the control
  passes on `sandboxed: no` alone, so a green `macos-26` build still evidences the wall by the
  sandboxed report and the outbound denial." True until run 38577309118; re-dated at v51 on the
  owner's seat's answer at `docs/trail/architecture/cycle-44.md` § 3.1 — RN-62)*. Why
  the runner reports it that way is not known, and whether the one Mac measured reports that read
  allowed for the control is not recorded. **The runner reading is taken on every hosted build**,
  this document's own realization of the runner clause (RN-59):
  `gh run view <run-id> --repo eyalgo/ka-reader --log | awk -F'\t' '$2 == "Test gate" { if (after && /out-of-grant-read:/) print; after = /ok   test_negative_control_reports_unsandboxed$/ }'`
  prints the control's `out-of-grant-read:` line for the run named: inside the workflow's `Test gate`
  step, the line directly after the control case's `ok` line. Selecting the step alone is not
  enough. From `ka-reader@8b93322` the gate runs the probe and its suite inside that one step, and the
  probe prints the shipped bundle's own report on every pass (`checks/bundle.sh:L457`, the gate's
  `Bundle probe` step, `checks/gate.sh:L53`) before the suite prints the control's (`Bundle probe
  suite`, `:L55`), all at `ka-reader@8b93322`. Which line follows the `ok` line is the suite's to
  hold, and it holds it: `test_negative_control_missing_read_fails_the_suite` requires the control's
  output to be exactly its `ok` line followed by its reading (`checks/tests/test_bundle.sh:L867-L869`
  at `ka-reader@8b93322`). For a run on a commit that does not hold `ka-reader@8b93322`, the command
  is the one through v57, `awk -F'\t' '$2 == "Bundle probe suite" && /out-of-grant-read:/'` over the
  same log, and run 38577309118's reading stands under it *(through v57 that was the command for
  every run; moved at v58 on the owner's seat's answer at `docs/trail/architecture/cycle-51.md`
  § 3.1 — RN-69)* *(`--repo kensaiapp/ka-reader` through v54; moved at v55 on the owner's answer at
  `docs/trail/architecture/cycle-48.md` § 3.1 — RN-66)*. `checks/bundle.sh:L383`
  prints the control's report — the line at `ka-reader@81734d9`, `fcb2e2f`, `24be581` and
  `970ad65` alike — and at `ka-reader@970ad65` the suite carries it: `publish_control_reading`
  (`checks/tests/test_bundle.sh:L629-L644`) requires exactly one line matching
  `^out-of-grant-read: (denied|allowed)$` in the control's report, fails the case on none, on a
  malformed one and on more than one, and prints the line; the runner forwards it after the
  control's `ok` line (`:L1710`); and `test_negative_control_missing_read_fails_the_suite` (`:L833`)
  proves the three refusals on every run. A control report with no reading is a red suite, so no
  review gate is owed on `checks/bundle.sh` or `checks/tests/test_bundle.sh` for it. **The hosted
  reading is taken, and the break is live.** The first hosted run on `main` that holds `970ad65`
  and concludes *Bundle probe suite* `success` is GitHub Actions run 38577309118 on
  `ka-reader@f357008`, and on its log this command prints exactly one line,
  `out-of-grant-read: denied`. From that run on, a hosted build on a commit before
  `ka-reader@8b93322` whose *Bundle probe suite* step concludes `success`, and for which the earlier
  command prints no `out-of-grant-read:` line, breaks this entry; and a hosted run on a commit that
  holds `ka-reader@8b93322`, whose *Test gate* step concludes `success`, and for which this command
  prints no line, breaks it (C-I3's *Violated by* at SDD v51; SDD RN-110, RN-111; RN-61, RN-62,
  RN-69). A run whose gate fails before the suite runs concludes `failure`, and the break does not
  read it. While Actions is off there is no hosted run, so the first one on such a commit is this
  command's first reading *(through v57 the break named the *Bundle probe suite* step for every run —
  RN-69)*. Runs 38501500758 on
  `ka-reader@3f7a68d` and 38551538187 on `ka-reader@24be581` printed nothing and are not breaks:
  neither commit holds `970ad65`, so both are readings from before the boundary *(through v50 this
  read: "**The hosted reading is not yet taken.** Read on 2026-10-14: `origin/main` is
  `ka-reader@24be581`, which does not hold `970ad65`, and the newest run on `main`, GitHub Actions
  run 38551538187 on `24be581`, concluded *Bundle probe suite* `success` with this command printing
  nothing. Until a hosted run on `main` that holds `970ad65` concludes *Bundle probe suite*
  `success`, an empty read is the measurable *not yet*, never a pass. From that run on, …", its
  *Violated by* read at SDD v50, and the sentence below ended "which reads the same as the
  not-yet". True until run 38577309118; re-dated at v51 on the owner's seat's answer at
  `docs/trail/architecture/cycle-44.md` § 3.1 — RN-62)*. The command picks the line out by two
  names: the workflow's `Test gate` step and the control case,
  `test_negative_control_reports_unsandboxed`. No script holds either name against this command.
  `checks/tests/test_vm_refusal.sh` holds that one workflow step's whole `run:` is `checks/gate.sh`,
  not what that step is called, and the suite names its control case for its own runner. So a
  rename of either makes the command print nothing, which reads as a break whether or not the wall
  held.
  **A change that renames the workflow's `Test gate` step, or the control case, changes this
  command in the same change**, and `development-design` reading this entry is that gate: a
  review gate, because no check reads the step's name or the case's against this command *(through
  v57 this read "The command picks the step out by its name, and no script holds that name — § 9's
  suites bullet holds that the step exists, not what it is called" and "**A change to
  `.github/workflows/` that renames or drops the `Bundle probe suite` step changes this command in the
  same change**" — RN-69)* *(through v49
  this passage read: "It prints nothing today, and that empty output is the measurable *not yet*,
  never a pass: `checks/bundle.sh:L382` prints the control's report, but the suite captures it
  (`checks/tests/test_bundle.sh:L144-L146`) and prints only `ok` and the case name on success
  (`:L1573-L1577`), all at `ka-reader@fcb2e2f`. No script holds the reading, so until the change
  that makes the suite's log carry the line lands, `development-design` reading this entry is the
  gate on any change to `checks/bundle.sh`, `checks/tests/test_bundle.sh` or `.github/workflows/`.
  Once the suite prints the line, a hosted build whose suite log carries no `out-of-grant-read:`
  line for the control breaks this entry (C-I3's *Violated by* at SDD v49; RN-60)." The observation
  stands as true of `ka-reader@fcb2e2f`, except its `:L382`, which was `:L383` there too; re-derived
  at v50 on the owner's seat's answer at `docs/trail/architecture/cycle-43.md` § 3.1 — RN-61)*.
  A `denied` reading leaves the narrowing
  standing, re-dated here with the run id and the image version, and the first reading on each
  image version is the one recorded, as § 9 records the toolchain. An `allowed` reading means the
  read denial separates again on the runner: C-I3 is restated by the CTO, and this entry follows
  *(through v47 this clause named no image, and § 9 gave its re-measurement to "the change that
  moves CI to such an image", which landed at `ka-reader@fcb2e2f` and re-measured nothing; on the
  owner's seat's answer at `docs/trail/architecture/cycle-41.md` § 3.2 — RN-59)*. A container directory that
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
  (layer 5) *(traces to: SDD § 4 C-R2, C-I3 as they read at SDD v13, and C-I3's probe half as it reads
  at SDD v51 — the runner narrowing dated to the images it was read on, `macos-26` among them, the
  reading taken on every hosted build, the missing line in its *Violated by*, and the suite's
  validated reading at `ka-reader@970ad65` (SDD RN-109, RN-110, RN-111; RN-60, RN-61, RN-62;
  through v48 this trace read the probe half "unchanged since v9", true until SDD v49; through v49
  it read C-I3 at SDD v49; through v50 it read C-I3 at SDD v50);
  § 10 RC-1, RC-2, RC-3 *Retained*; § 11 R-8;
  § SDD Review Notes RN-48, RN-50, RN-52; the owner's ruling at `docs/trail/sdd/cycle-8.md` § 5.1,
  answers 1–2; ADR-0011 — Accepted, superseding ADR-0003; ADR-0010; the tail's window re-derived
  from C-I3 at SDD v8 on the answers at `docs/trail/architecture/cycle-7.md` §§ 3.2, 3.3 — RN-20;
  the rule, the second half and the failed-ask scoping re-derived at v10 — RN-21 — and confirmed
  in the owner's seat at `docs/trail/architecture/cycle-8.md` § 2.1 — RN-22; the runner clause
  dated to `macos-14` and its reading made standing at v48 on the owner's seat's answer at
  `docs/trail/architecture/cycle-41.md` § 3.2 — RN-59; the suite's validated reading, the
  `bundle.sh:L383` locator and the step-name gate at v50 on the owner's seat's answer at
  `docs/trail/architecture/cycle-43.md` § 3.1 — RN-61; the first `macos-26` reading and the live
  break at v51 on the owner's seat's answer at `docs/trail/architecture/cycle-44.md` § 3.1 —
  RN-62)*
- **QC-62:** The bundle CI ships runs its shell under its shipped entitlements. On every CI build,
  after `checks/bundle.sh` and never instead of it, the launched main process of the bundle CI
  built — launched as a user launches it, its pid taken the way `checks/bundle.sh` takes it — is
  observed **parked in the Open panel's modal run, inside the shell's launch frames** — the
  shell's first and only unconditional act, presenting the Open panel at launch (C-R3) and parked
  in it until someone answers; `open_folder` is not among those frames, because the shell calls it
  only after the panel returns (`ka-reader-mac/Sources/Shell/LaunchFlow.swift`, `chooseFolder()` and
  `openAndList(_:through:)` — `:L54-L60` and `:L69` at `ka-reader@7c7038f`) and the gate
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
  the tree as written then; from `ka-reader@153f5a1` that tree is gone and the rule is history, its
  never-cleared clause standing on C-I3's *Violated by* and ADR-0011; on the owner's seat's
  answers at `docs/trail/architecture/cycle-12.md` §§ 3.1, 3.2 — RN-26)*.
  — *verified by:* `checks/renderer.sh KA-Reader.app` and its `idle-shell` control (layer 5), in the
  tree since `ka-reader@153f5a1` and run on every CI build as `Renderer gate`
  (`.github/workflows/ci.yml:L46-L47` at `ka-reader@ab39502` — `:L43-L44` at `ka-reader@153f5a1`, moved
  when `View check suite` landed above it at `:L41-L42`), after `Bundle probe` (`:L31-L32`,
  unmoved) — the script fixes the mechanism it reads and the bound, and prints the bound the way
  `checks/bundle.sh` does; the
  frame list is the script's header's (`checks/renderer.sh`, header § *THE FRAMES* — the list at
  `:L53-L56` at `ka-reader@7c7038f`), cited and not copied here,
  the way C-I3 cites it, so the next re-measurement moves one file. The frames were re-measured
  on the first slice's first native bundle: on a Mac, recorded in the script's header
  (`checks/renderer.sh`, header § *THE FRAMES* — `:L57-L60` at `ka-reader@7c7038f`, macOS 26.6.2),
  and on a GitHub-hosted runner — GitHub Actions run 35988399477 on `ka-reader@37a962d`, image
  `macos-14-arm64` 20260831.0302.1, macOS 14.8.9 — where the product matched the five-frame list
  the script carried at that commit on observation 1 and the control on none of 30, recorded in
  the script's header from `ka-reader@2b83dce` (`:L61-L64` at `ka-reader@7c7038f`) and cited from there
  as the Mac reading is. The list has held four frames since `ka-reader@b75348f`, which removed
  `LaunchFlow.run()` from it; the four-frame list matched on the same runner image at run
  36795836747 (`ka-reader@702f7c4`), again on observation 1 with the control matched on none of 30
  (`docs/SDD.md` § 4 C-I3 at v22; SDD RN-76) *(the citations and the frame count re-pointed and
  pinned at v21 — RN-32)*
  *(through v16 cited from the run, the header not carrying the reading yet — true at
  `ka-reader@153f5a1`; this cite and the step's lines on the owner's seat's answers at
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
  `cargo build --locked`; `ka-reader-mac/Package.swift` declares no dependency and no
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
  on that side to audit (SDD § 4 C-R6); `pnpm audit` left with `ka-reader-ui` at `ka-reader@0aca57e`
  (RN-22; RN-25) *(traces to:
  `quality_defaults.md` § Dependencies; SRS C-7,
  C-13; FDR PD-22; the commands are this document's realization — RN-3; the no-window call and the
  `cargo audit` gate confirmed at `docs/trail/architecture/cycle-1.md` § 1.1, § 2.7 — RN-11)*
- **QC-28:** No secret is in the repository, and the release workflow holds no signing identity.
  — *verified by:* `checks/secret-scan.sh gitleaks git` exits 0 over every commit HEAD reaches, at
  every change: the gate's *Secret scan* step (`checks/gate.sh:L58` at `ka-reader@8235240`; § 8),
  with its suite `checks/tests/test_secret_scan.sh` the step before it (`:L48`). The script runs
  gitleaks 8.30.1 with `--exit-code 2` (`checks/secret-scan.sh:L195`), so under it a finding exits 2
  and the tool's own error 1, and the script names which in its output; on either it exits
  non-zero and the step fails (`:L213-L218`). A finding passes only by its fingerprint on a line of
  `.gitleaksignore` at the product root, with the reason in a comment directly above it, added and
  reviewed as code in the same change, the way `checks/deps.allow` is for QC-26
  (`checks/secret-scan.sh`, *.GITLEAKSIGNORE*); a finding with no such line keeps the step red.
  Two paths fail closed, turning the step red and never green. The step fetches gitleaks 8.30.1's
  release archive from GitHub on every run and checks it against a pinned SHA-256: the archive is
  a platform fact this product does not hold, its holders are the gitleaks maintainers, and if they
  stop serving it every change is red until the pin moves. And the script refuses a shallow
  checkout, so `fetch-depth: 0` on the workflow's checkout (`.github/workflows/ci.yml:L21-L23` at
  `ka-reader@8235240`) is what lets a hosted run pass; removing it turns that run red.
  `gh secret list --repo eyalgo/ka-reader` prints no entry; `codesign -dv KA-Reader.app` on the
  downloaded bundle reports `Signature=adhoc` *(traces to: `quality_defaults.md` § Secrets; SDD § 4
  C-R4; ADR-0024, which superseded ADR-0007 at v55; the scanner is this document's realization —
  RN-3; the command confirmed at `docs/trail/architecture/cycle-1.md` § 2.7 — RN-11; the gate step,
  named in SDD § 3's `read-only-harness` row at v58, on the owner's seat's answer at
  `docs/trail/architecture/cycle-59.md` § 3.1 — RN-77)* *(through v65 the first check read
  "`gitleaks git` exits 0 over the repository — exit 1 on a leak or an error", the bare tool's
  default, which RN-3 keeps as true of it — RN-77)* *(through v54 `--repo kensaiapp/ka-reader`;
  moved at v55 — RN-66)*
- **QC-29:** Every release's `SHA256SUMS` matches its artifact, and the artifact is built from the
  release's tagged commit by `.github/workflows/release.yml`; a release with no build from its tag
  is not offered.
  — *verified by:* `shasum -a 256 -c SHA256SUMS` passes against a rebuild from the tag (the
  release) *(traces to: SDD § 4 C-R4; § 11 R-7; FDR R-132; ADR-0024, which superseded ADR-0007 at
  v55 — RN-66)*
- **QC-30:** The boundary set is exactly: the Open-panel grant; the granted folder's content
  (files, entries, `.git`); FSEvents for that folder; the `SM-4` functions the shell calls, `asset_bytes` among
  them; the product's own files in its container; and the environment and argument reads of
  the linked dependency tree, each named in `checks/entry-points.allow`. The set covers what the
  shipped process reads, whichever crate holds the line that reads it — an adopter runs one
  process. It is held in two halves. **(1) The product's own units** — every member of the Cargo
  workspace, whose members are the glob `crates/*` (`Cargo.toml` `members`), so a crate created
  there is a member with no manifest edit (`ka-reader-core` and `ka-reader-bridge` today), and
  `ka-reader-mac` — read no argument vector, no environment variable and no
  configuration file, and open no socket. **(2) The linked dependency tree** — every environment or
  argument read in the crates `cargo tree -p ka-reader-bridge --target aarch64-apple-darwin -e normal
  --locked` resolves is a named member of the set: one line in `checks/entry-points.allow` per
  crate and name, each with
  what the read changes. A read not on the list fails the build until the list change is reviewed
  as code in the same change, the way `checks/deps.allow` is (QC-26); whether a given read is
  acceptable is decided at that review, by a person. **What the set does not reach:** reads made
  by the operating system's own frameworks inside the process. They are the platform's, no
  lockfile names them, and the sandbox (QC-25) is what bounds them. Nor a path libgit2 takes from a file it loads for the
  repository: `git-reader`'s own check refuses one that names a location outside the folder
  (ADR-0023; QC-6), and what that check does not hold QC-35 names as uncovered (SDD § 11 R-16
  as it reads at v46 — RN-56, and at v42 — RN-53; through v44 this sentence read "does not yet
  hold", when QC-35 still named refusals stated and not built — RN-56; through v41 this sentence
  said libgit2 follows such a path with no containment check). **A C environment read in a linked crate is a read of half (2)** — a `getenv`, or a
  read of the process's environment array through `environ` or `_NSGetEnviron` — and is named on the
  list as a Rust read is *(drafted at v32 — RN-43; confirmed at v33, with the environment array
  added — RN-44)*. At `ka-reader@8edec4f`, and unchanged at `ka-reader@2f15e2c`, two of the 37 crates the
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
  `ProcessInfo.processInfo.environment` read in `ka-reader-mac/Sources` — three names this document
  adds to C-R7's scan to realize C-R3's *Violated by* (RN-22). Half (2) —
  `checks/entry-points.sh` (layer 6): for every crate the `cargo tree` command above names from
  outside the workspace, a scan of the crate's whole package directory in the Cargo registry — its
  build script excepted — for `env::var`, `env::var_os`, `env::vars`, `env::vars_os`, `env::args`
  and `env::args_os`, diffed against `checks/entry-points.allow`; non-zero on a read not listed, on
  a listed line no longer found, and on any resolved crate whose sources it cannot open — a crate
  it cannot scan is a failure, never a pass. The scan covers the package directory and not `src/`,
  because a crate need not keep its sources there (RN-18). **The workspace's own members** —
  `ka-reader-core` and `ka-reader-bridge` today, which the command names and which have no registry
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
  the lock resolves at `ka-reader@85d9fa7` does (RN-34). Review at `development-design` when a change adds
  an entry point — a scanner finds a new read or a new socket, not a new trust assumption *(traces
  to: `quality_defaults.md` § The boundary set; SRS NFR-14, FR-1; FDR R-2; SDD § 4 C-R3 *Violated
  by*, C-R7; ADR-0021; ADR-0017; ADR-0023, which superseded ADR-0022 at v45 — RN-56; the two
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

- **QC-34:** The shell reaches nothing but the functions QC-24 names: `ka-reader-mac` opens no socket,
  reads no file, spawns no process, hands no URL to another program, and loads no web engine —
  every byte a surface shows crossed `SM-4`.
  — *verified by:* `checks/view.sh` (layer 6) — the scan over `ka-reader-mac/Sources`, whose list of
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
  (QC-17). The paths libgit2 takes from a file it loads for the repository are refused by
  `git-reader`'s own check where they name a location outside the folder (ADR-0023; QC-6). **Not
  covered, and named so none is read as coverage:** (1) what that check cannot refuse: a config,
  `.gitmodules` or alternates file rewritten between the check and libgit2's read, which libgit2
  then follows unchecked; and a link elsewhere inside the Git directory — a linked `HEAD`, `index`
  or `refs` — that leads out, which no check covers. Neither has a closing named, and the sandbox
  is their only bound *(through v44 this clause led "what that check does not yet refuse, and what
  it cannot", named first "a `.gitmodules` section's path, whose refusal is stated and not built —
  the sandbox is its only bound in the bundle, nothing bounds it in the harness, and a section
  naming another location inside the folder is bounded by nothing in either (QC-6; SDD § 11
  R-16)", and closed it on SDD *Open Questions*' config-named-path item, "open on its
  `.gitmodules` case alone, settled before `see-git-status` is reached, with no build inside the
  slice bounding it", the other two as "the last two"; the refusals are built at `ka-reader@772c63b`
  and SDD v46 removed the item — RN-56)* *(through v43 the first of these read "the
  `objects/info/alternates` read and a `.gitmodules` section's path, whose refusals are stated
  and not built", and closed as "the first two" — RN-55)* *(through v41 this case named three keys of
  the repository's own config, "which libgit2 follows with no containment check" — RN-53; through
  v39 this bound read "no later than the build in which `mac-shell` first calls
  `ka_reader_read_git`" — RN-51)*; (2) `ka-reader-core`'s in-process Git suites
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
  sandbox grant (QC-25), which in the bundle bounds every read the switch does not stop. Beside
  them, six cases of `cargo test --locked -p ka-reader-core --test git_state` (layer 2) each observe
  that no call opens the one outside path its scene names, through a FIFO whose non-blocking open
  succeeds only once a reader holds it (`crates/ka-reader-core/tests/git_state.rs:L1155-L1206`): the
  repository's config (`:L1212`), a submodule's config (`:L1228`), an include from `.gitmodules`
  (`:L1795`), an include through an inside link (`:L1886`), the outside object directory's
  `info/alternates`, which a load of that directory would open
  (`test_the_outside_object_directory_is_never_read_on_the_three_calls`, `:L1995`), and the
  `.git/config` of a repository outside the folder that a `.gitmodules` section leads to through
  an inside link, which an open of that repository would read
  (`test_section_leading_through_a_link_to_an_outside_x_opens_nothing_outside`, `:L2680`, over
  `checks/fixtures/gitmodules-names-outside`) — locators at `ka-reader@772c63b`; 120 passed for v45 on
  a disposable copy of `ka-reader@d90814b`, whose tree outside `docs/` is `ka-reader@772c63b`'s. The
  fifth does not watch a `stat` of the outside
  directory, which is the first thing libgit2 does to an alternate: that no such `stat` is made
  rests on the check running before the open
  (`crates/ka-reader-core/src/git_reader/libgit2.rs:L112-L115`, at `ka-reader@66f428d`) and not on the
  case (SDD § 11 R-16, "A third way out", *The proof*). The six run the adapter in-process, and
  no case runs the check on the built bundle *(through v44 this sentence named five cases, the
  helper at `:L1156-L1170` and the last three at `:L1543`, `:L1634` and `:L1733`, at
  `ka-reader@66f428d` — 82 passed at `ka-reader@4a49995`, and again for v44 at `ka-reader@f2e22e9`; the five
  are re-pinned, not changed in what they name, and the helper's span now reaches the poll it
  describes — RN-56)* *(through v43 this sentence named four cases, at
  `:L1156-L1166`, `:L1202`, `:L1218`, `:L1533` and `:L1624` — 58 passed at `ka-reader@076eac2`, run
  for v42; the four locators are re-pinned, not changed in what they name — RN-55)*. Each
  observes one named path, with the machine-level reads on as (2) states, and not
  the product's reach: no command observes a read outside the grant in general, the reads half
  rests on the wall, the switch's configuration and `git-reader`'s check, and this tail says so
  *(through v41 this sentence said no command observes such a read at all — RN-53)* *(traces to:
  FDR R-101, R-102; ADR-0023, which superseded ADR-0022 at v45 — RN-56; SDD
  § 3 `core-bridge` and `git-reader` at v27; § 4 C-D1, C-D2, C-D3, C-I3 at v27; § 11 R-16;
  § *Open Questions*, second item, and its config-named-path item until SDD v46 removed it; ADR-0011; ADR-0020; re-derived against
  SDD v27, with the tail's observes-no-read sentence, at v32 — RN-43; (2)'s walk from SDD § 4 C-I3
  as it reads at v31 (SDD RN-91) — RN-49; (1)'s bound from SDD § 11 R-16 at v31 (SDD RN-91) —
  RN-49, and re-derived from § 11 R-16 and *Open Questions*' config-named-path item as they read
  at v32 (SDD RN-92) — RN-51; (1) and the four cases re-derived from SDD § 3 `git-reader`,
  § 4 C-D3, § 11 R-16 and *Open Questions*' config-named-path item as they read at v42 (SDD RN-99 –
  RN-102), on the item raised at `docs/trail/architecture/cycle-36.md` § 2.1 — RN-53; (1) and
  the five cases re-derived from SDD § 11 R-16 (*The proof* under "A third way out", *Until the
  checks are built*) and *Open Questions*' config-named-path item as they read at v43 (SDD RN-103),
  on the owner's seat's answer at `docs/trail/architecture/cycle-38.md` § 3.1 — RN-55; (1) and
  the six cases re-derived from SDD § 11 R-16 (*Built, and the cases that hold it*, and *The
  proof*) as it reads at v46 (SDD RN-106), on the owner's seat's answer at
  `docs/trail/architecture/cycle-39.md` § 3.1 — RN-56)*
- **QC-36:** No unit spawns a process: no `std::process` in any shipped crate, and no `Process`
  in `ka-reader-mac/Sources`.
  — *verified by:* `checks/structure.sh` (layer 6); `checks/view.sh` (layer 6) *(traces to: SDD
  § 3 `git-reader` "Must not own", `mac-shell` "Must not own"; § 4 C-R7; ADR-0019; ADR-0021; re-derived at v11 — RN-22)*
- **QC-37:** `asset_bytes` returns bytes read-only, only for a path the containment check passes
  and only for the four bitmap formats `docs/SDD.md` § 4 C-D3 names — PNG, JPEG, GIF and WebP —
  and refuses any other request; the shell decodes an image from bytes `asset_bytes` returned and
  from nothing else, with the platform's own decoder. An in-folder SVG is not returned and takes the
  placeholder stating that its format is one the tool does not render; SVG reaches the decoder only
  after C-D3's format list moves on the evidence SDD RN-8 names, never by an `asset_bytes` edit
  alone.
  — *verified by:* `cargo test --locked -p ka-reader-bridge --test asset_bytes` — `asset_bytes` returns the
  in-folder PNG's bytes for its path and a refusal for the in-folder SVG and for each escaping
  path, on a second call with the same inputs (layer 2); `swift test --package-path ka-reader-mac` — a
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
  cap (`cargo test --locked -p ka-reader-bridge`), and the remembered list evicts the oldest entry on the eleventh
  and exposes no removal (`cargo test --locked -p ka-reader-core`); `checks/own-state.sh` after
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
  `github.com/eyalgo/ka-reader` and `SECURITY.md` exists, promising nothing beyond
  *"Security reports have a private channel and are read, with no acknowledgement or response
  time promised"* (`docs/PRD.md` § Assumptions, "Support posture").
  — *verified by:* `gh api repos/eyalgo/ka-reader/private-vulnerability-reporting` returns
  `"enabled": true`; `SECURITY.md` present; release inspection reads its wording (the release)
  *(traces to: SRS C-7, C-12, AC-14; FDR R-143, PD-22)* *(through v54 this entry named
  `github.com/kensaiapp/ka-reader` and its command `repos/kensaiapp/ka-reader`; moved at v55 on SRS
  v13 C-12 and the owner's answer at `docs/trail/architecture/cycle-48.md` § 3.1 — RN-66)*
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
  — *verified by:* `cargo test --locked -p ka-reader-core --test watch` — an unreadable fixture entry yields
  `failed` on that item and the failure changes no other item: each sibling holds the state its
  own read gave it, `observed`, `pending`, `failed` or `stopped` (layer 2); `swift test --package-path
  ka-reader-mac` (layer 4): the failure slot renders and the rest of the surface stands. What a failed
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
  final state. Where a file's Git status changes mid-run, the model's snapshot then carries the
  changed marker on that file's `TreeEntry` and both Git lists in row order: the marker join and
  the row order are `folder-model`'s, and stand in `surfaces` for `see-git-status` alone until
  `follow-the-folder` is reached (SDD § 3 `surfaces` and `GitState`; § 10 RC-5).
  — *verified by:* `cargo test --locked -p ka-reader-core --test watch` running `checks/churn.sh <fixture> 30`,
  with the same suite's case for a status change mid-run;
  `checks/read-only.sh` against the churn's final state as baseline (layer 3); and
  `grep -rn 'TreeMarkers\|GitRowOrder' ka-reader-mac/Sources` printing nothing, red while either
  file remains in the shell. What runs them is owed by `follow-the-folder`: at `ka-reader@076eac2` no
  `watch` target is under `crates/ka-reader-core/tests/`, `checks/churn.sh` is not in the tree (SDD § 3,
  the `read-only-harness` row, *Owed by a slice*), and the `grep` prints five files, which is the
  placement RC-5 bounds and not a violation until that slice is reached *(traces to: SRS
  FR-16, NFR-3, NFR-4, AC-8; SDD § 6 S-5; ADR-0010; the mid-run case, the `grep` and the end of
  the placement from SDD § 3 `surfaces`, § 6 S-5's command half and § 10 RC-5 as they read at
  v42 (SDD RN-94) — RN-53)*
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
  — *verified by:* `swift test --package-path ka-reader-mac` (layer 4): a `failed` and a `stopped`
  projection each render in the item's slot with the route present; `checks/view.sh` — no
  `NSAlert`, no user-notification API and no modal presentation in `ka-reader-mac/Sources` other than
  the Open panel's own presentation, which C-R3 requires: exactly one `.runModal()` with no
  argument, in `ka-reader-mac/Sources/Shell/OpenFolderPanel.swift` (`:L14`); a second one there, one
  with an argument, or one in any other file is reported (`checks/view.sh:L80-L86`, F13) — the
  bound is stated as the scan holds it, so a sheet, a second panel or a modal elsewhere under
  `Shell/` is not read as admitted (layer 6; the symbols the script names are this document's
  realization of `surfaces`' "Must not own" — RN-22 — and that realization carries the C-R3
  exception from v15, on the owner's seat's answer at `docs/trail/architecture/cycle-12.md` § 3.3
  — RN-26) *(traces to: SRS NFR-11; SDD § 3 `surfaces` "Must not own"; § 4 C-R3, C-E3, C-I1; FDR
  R-86, R-87, R-90, R-91)*
- **QC-52:** The diagnostic log is written to
  `~/Library/Containers/com.kensaiapp.ka-reader/Data/Library/Logs/ka-reader.log` and nowhere else, one
  line per `failed` or `stopped` item; it is the product's only diagnostic output.
  — *verified by:* `checks/own-state.sh` (layer 5); unit test on the writer's path and line shape
  (layer 1) *(traces to: SDD § 4 C-I2; SRS NFR-11; FDR PD-32)*
- **QC-61:** The logging facade is `log`, and its implementation is the product's own. Every
  shipped Rust crate depends on the `log` facade for diagnostics and on nothing else — no
  `tracing`, no `slog`, no second facade; `ka-reader-core` uses the five macros and initializes
  nothing. The implementation is `ka-reader-bridge`'s own log writer — the writer QC-39, QC-40 and
  QC-52 already bind — implementing `log::Log`, installed once at startup in `ka-reader-bridge`, the
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
  `log::set_boxed_logger` appear only under `crates/ka-reader-bridge/src/`; test targets under
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
  — *verified by:* `checks/strings.sh` — a lint over `surfaces`' message catalogue in `ka-reader-mac` for the
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
(`system/projects/ka-reader/project.md` in the managing instance), not restated here. That card's
test command is `checks/gate.sh`, QC-64's one script. Its steps run the workspace build, the
bridge's assembly, which the Swift half needs first (§ 9's runner paragraph), and the test gate,
`cargo test --workspace --locked && swift test --package-path ka-reader-mac`
(`checks/gate.sh:L59`, `:L62`, `:L63` at `ka-reader@8235240`; `:L46`, `:L49`, `:L50` at
`ka-reader@389adad` — RN-77): the SDD's command bar for the Rust
workspace, `cargo test --workspace --locked` exits 0 (`docs/SDD.md` § 6 S-1), the bar carrying the
Rust packet's `--locked` itself since the SDD's re-author (`languages/rust/testing.md` § Layers
1–5; RN-16), and `swift test` for `ka-reader-mac`, the command the SDD's bars name (§ 6 S-1).
After them come the structure pair, on the owner's call (the structure-pair paragraph below), and
every other rule the CI workflow holds (QC-64). Before them, after the toolchain print, come the
secret scan and its suite (QC-28; *Until the card runs the script*, below) *(added at v66 — RN-77)*. Its `Languages:` line names Rust, Swift and Shell
(RN-6). The move the SDD named as owed at v13 (`docs/SDD.md` RN-60) is made, so is the move
the paragraph below named as owed at v49, so is the move the structure-pair paragraph named as
owed at v54, and so is the move *Until the card runs the script* named as owed (RN-69): § 8 states
the card as it reads at
`kensaiapp-opensource@85264c69` — seven moves past the `defe740` v12 read, `5b27023` (Swift in
place of TypeScript on the `Languages:` line, in the test command and on `Language roots:`),
`ec80077` (the `Languages:` comment naming Swift's packet), `d5005730` (the bridge's assembly
before the Swift half), `5be8615c` (the structure pair at the end of the test command),
`a4204e5b` (the command's comment no longer saying the harness stays out of it), `1941f963` (the
test command becomes `checks/gate.sh`) and `85264c69` (the command's comment describes the
script), none of them this
document's to edit (RN-24) — and goes false at the
card's next move until RN-6 is extended (RN-22) *(through v51 this paragraph quoted the command
without `ka-reader-mac/assemble.sh` and pinned the card at `kensaiapp-opensource@ec80077`, true at
that pin; on the owner's seat's answer at `docs/trail/architecture/cycle-45.md` § 3.2 — RN-63.
Through v54 it quoted the command without the structure pair and pinned the card at
`kensaiapp-opensource@d5005730`, true at that pin; moved at v55, where the card moved — RN-66.
Through v61 it quoted the command as `cargo test --workspace --locked && ka-reader-mac/assemble.sh
&& swift test --package-path ka-reader-mac && checks/structure.sh &&
checks/tests/test_structure.sh`, pinned the card at `kensaiapp-opensource@a4204e5b` and counted
five moves, true at that pin; moved at v62, where the card moved, on the owner's seat's answer at
`docs/trail/architecture/cycle-55.md` § 2.1 — RN-73)*. Why the
workspace form is this product's change-time run, where the Rust packet classifies it as
release-time, is RN-7. Where the card's command runs is the card's and the pipeline's, and this
document names no machine; what its verdict is worth is § 9's *Toolchain* clause (RN-63, RN-67) *(through v55 "what its
verdict is worth against CI", true while hosted CI was the reference — RN-67)*. What follows exceeds the card.

**The card's Swift half needs the bridge assembled first, and the card says so.** From
`ka-reader@f0f1e5f`, `ka-reader-mac` links the bridge as a local binary target that
`ka-reader-mac/assemble.sh` writes and no checkout holds. The card's command runs that script
as a step of `checks/gate.sh`, after the workspace build and before the test gate's Swift half
(`checks/gate.sh:L59-L63` at `ka-reader@8235240`; `:L46-L50` at `ka-reader@389adad` — RN-77), which is CI's order
(`.github/workflows/ci.yml:L31-L35` at `ka-reader@f357008`) *(through v61 "runs that script
between its Rust half and its Swift half", true of the card from `kensaiapp-opensource@d5005730`
until `kensaiapp-opensource@1941f963` — RN-73)*. § 9's runner paragraph is that precondition's one home, and it does not
move *(through v51 this paragraph was headed "and the card does not say so yet". It read that the
card's `swift test --package-path ka-reader-mac` failed on every fresh checkout — each worktree the
delivery tier opens is one — and, run without assembly in an old checkout, tested the bridge an
earlier run left. It named the move owed to `product-card`, in the form `docs/SDD.md` RN-60 used:
the card's command gains the bridge's assembly before its Swift half. It said that until the card
moved, the card's command failed on a fresh checkout, and that CI was unaffected because it
assembled first. True until `kensaiapp-opensource@d5005730`, where the card moved (RN-60); on the
owner's seat's answer at `docs/trail/architecture/cycle-45.md` § 3.2 — RN-63)*.

**The card's command runs the structure pair on every change, and the card says so.**
`checks/structure.sh` and its suite `checks/tests/test_structure.sh` are gated at the change as well
as at the CI build: the card's test command runs both, on every change — the owner's call
(`docs/trail/architecture/cycle-47.md` § 3.1). The ground is measured. The chain gates a change on
the card's command and never reads CI, so a change could be sealed while it broke a rule the script
holds, and one was: doc examples added to `crates/ka-reader-core/src/folder_model.rs` at
`ka-reader@f1280b6` wrote through `std::fs`, `checks/structure.sh` drew 16 QC-2 and QC-15 findings,
CI went red at *Structure check* (GitHub Actions run 38673999031), and the change merged at
`ka-reader@21cfd34` on a green card command; the tree was repaired at `ka-reader@527f030`. The cost
is accepted: the script took 0.8 s and the suite 2 min 20 s on the owner's Mac on 2026-10-16, and
running the suite as well is what catches a change that edits `checks/` itself. Neither needs a
toolchain or a build — the script reads source text (`checks/structure.sh`, *WHY THIS EXISTS*) and
the suite runs the real script over copies of `crates/` (`checks/tests/test_structure.sh`, *WHY THIS
EXISTS*) — so § 9's *Toolchain* clause does not bear on the pair, and its change-time verdict is the
same reading CI's is. The other `checks/*.sh` scripts and their suites stay where § 10 has them.
The card's command runs the pair as steps of `checks/gate.sh`, after the test gate and the
sanitizer step (`checks/gate.sh:L71-L72` at `ka-reader@8235240`, the sanitizer at `:L70`; `:L58-L59`
at `ka-reader@389adad` — RN-77), and this section's first
paragraph says so *(through v61 "The card's command ends with the pair, after its Swift half
(`kensaiapp-opensource@5be8615c`), and this section's first paragraph quotes it", true until `kensaiapp-opensource@1941f963`
— RN-73)* *(through v54 this paragraph was headed "and the card does
not say so yet". It named the move owed to `product-card` — the card's command gains
`checks/structure.sh` and `checks/tests/test_structure.sh`, where in the command they sit being the
card's — and said that until the card moved, its command ran neither, the gate that held for the
pair was the CI build, after the seal, and the gap the paragraph closed was open. True until
`kensaiapp-opensource@5be8615c`, where the card moved (RN-65); moved at v55 — RN-66)*.

**Every rule the CI workflow holds is held without GitHub, at the change, in a macOS virtual
machine** — the owner's answer at `docs/trail/architecture/cycle-49.md` § 3.1, which leaves the
split to this document. On 2026-10-16 the owner switched GitHub Actions off on `eyalgo/ka-reader`
until billing is settled. The last hosted runs were refused for billing (38908439556,
38930009564), and whether hosted CI returns is not settled. The workflow runs twenty-four steps
that run a command (`.github/workflows/ci.yml` at `ka-reader@bb2e4cb`, whose workflow is
`ka-reader@d2694c7`'s). One, packaging the bundle, holds no rule. Of the other twenty-three, the
card's command runs four in full: the bridge's assembly, the test gate and the structure pair. It
runs the workspace build only as far as `cargo test` compiles it. The other eighteen ran nowhere
once Actions stopped: the toolchain print, the entry-points pair, the bundle probe and its suite,
the view pair, the renderer gate and its suite, the three read-only walks and their suite, the
no-network pair, the own-state suite, the launch of the built bundle, and own-state. QC-64 moves
every one of them to the change. **Why all of them at the change, and none at a later point.** The
pipeline issues a command for a product at three points, and each issues the card's test command and
nothing else: the developer's closing run, the code-integrity run and the seal. The seal issues none
for a product kept in its own repository, as this one is. The source is the managing pipeline's gate
tool, `gate_suite.py` v1.2.0, `run_gate` (`:L962`), which is not in this repository; the rule is
stated in full here. So no later point the pipeline reaches runs a command for this product, and a
rule placed anywhere but the card's command is held by no run. The cost is accepted and named. On the
last green hosted run, 38673998411, the checks took about 70 s, their suites about 12 min
(entry-points 218 s, bundle 351 s, renderer 120 s, the rest seconds), and the launch and own-state
about 2 s. That cost is paid twice per change, once at each gate. In the guest it is unmeasured, and
the first guest run is its reading, by § 9's rule on how a suite joins. **Where the gate runs.** The
same tool places the card's command in the macOS guest because the product's CI configuration names
a macOS runner. It places the command on the owner's Mac in two cases: the product has no CI, or the
owner asks (`gate_suite.py` v1.2.0, `resolve_environment`, `:L554-L560`). So
`.github/workflows/ci.yml` stays in the tree whether Actions runs or not: it is what places the change
gate in the guest. If it ever leaves the tree, the gate moves to the owner's Mac, where QC-65 turns it
red. Where the guest comes from, and what it carries, is the managing pipeline's; § 9's *Toolchain*
clause records what the guest printed. **What this does not reach.** The packaging and upload steps
hold no rule. They hand the built bundle out, stay the workflow's, and run only when Actions does. Two
release-time obligations name CI, and they stand as the SDD writes them: QC-29's build from the tag
(`docs/SDD.md` § 4 C-R4) and QC-25's read of a hosted run's log (C-I3). While Actions is off, no
hosted run exists for QC-25's read to break on. No release can be built the way C-R4 states either,
and moving C-R4 is the CTO's if hosted CI has not returned by the first public release (RN-67).
**Until the card runs the script.** Every `verified by:` tail and § 10 row in this document that
names the CI build, or a workflow step, reads under this paragraph, and none repeats it.
`checks/gate.sh` is in the tree from `ka-reader@8b93322`, mode `100755`, with 26 steps, and it has
passed in the macOS guest: exit 0 at `ka-reader@726a234`, whose script differs from `8b93322`'s only
in two re-wrapped comments (the PM's measurement, `docs/trail/architecture/cycle-51.md` § 3.2). That
count is true of `8b93322` and stays as its record. At `ka-reader@389adad` the script is version
1.1.0 (`checks/gate.sh:L2`) with 27 steps: the new one, *Bridge tests under the address sanitizer*
(`:L57`), sits between *Test gate* (`:L50`) and *Structure check* (`:L58`), and `grep -c
'^run_step' checks/gate.sh` prints 28 there, 27 steps and the `run_step()` definition at `:L27`,
where the same count on `8b93322`'s script prints 27. The whole gate exited 0 in the macOS guest with
that step in it, the step printing `rustc 1.101.0-nightly (19833af72 2026-10-20)` before the bridge's
results (the PM's measurement, `docs/trail/architecture/cycle-54.md` § 3.1) *(added at v61, in the
owner's seat at `docs/trail/architecture/cycle-54.md` § 3.1 — RN-72)*. At `ka-reader@8235240` the
script is version 1.2.0 (`checks/gate.sh:L2`) with 29 steps: *Secret scan suite* (`:L48`,
`checks/tests/test_secret_scan.sh`) and *Secret scan* (`:L58`, `checks/secret-scan.sh gitleaks git`,
QC-28) sit after *Toolchain* (`:L47`) and before *Build the workspace* (`:L59`), and `grep -c
'^run_step' checks/gate.sh` prints 30 there, 29 steps and the `run_step()` definition at `:L29`.
The whole gate exited 0 in the macOS guest at `ka-reader@38158f4`, the scan printing `commits
scanned: 1279`, and `git diff --stat 38158f4 8235240` prints nothing (the PM's measurement,
`docs/trail/architecture/cycle-59.md` § 3.1). The scan step is the one step that reaches the network
on every run, and it refuses a shallow checkout; what each costs a change is QC-28's tail *(added at
v66, in the owner's seat at `docs/trail/architecture/cycle-59.md` § 3.1 — RN-77)*. **The card runs the script
from `kensaiapp-opensource@1941f963`.** The card's test command is `checks/gate.sh` (this section's
first paragraph), and the pipeline's gate tool issues the card's test command at the developer's
closing run and at code-integrity (*Why all of them at the change*, above). So every step of the
script, and every rule a step holds, runs at every change, at both gates. A rule gated at the CI
build alone is held at the change by the script's step for it while Actions is off, and by the same
step through the workflow when Actions runs. A review gate whose only ground was that no run issued
a check dropped at this move. A review gate that rests on something else stays and names its
ground: QC-56's `.yaml` half and QC-64's *nothing else* half, which no script holds. The refusal
QC-65 puts before the move landed first, at `ka-reader@13e8d42`. The heading keeps its name,
because the card's `Test command:` comment cites it by that name (`kensaiapp-opensource@85264c69`)
and the card is not this document's to edit (RN-24): renaming it is a card move to raise on the
card's own channel, not one to make here *(through v61 this read "Until the card's command runs it,
a rule gated at the CI build alone is held by no run while Actions is off, and by this document's
header rule its gate is `development-design` reading the entry. The card's move is owed to
`product-card`, in the form RN-60 used: the test command runs `checks/gate.sh`, and how the field
spells that is the card's. Nothing this document names still stands in front of that move: the
refusal QC-65 puts before it is in the tree from `ka-reader@13e8d42`, and the script is in the tree
and has passed in the guest", true until `kensaiapp-opensource@1941f963`; on the owner's seat's answer at
`docs/trail/architecture/cycle-55.md` § 2.1 — RN-73)* *(through v57 this
paragraph was headed *Until the script lands* and read "Until `checks/gate.sh` is in the tree and the
card's command runs it"; the script's half was met at `ka-reader@8b93322`; on the owner's seat's
answer at `docs/trail/architecture/cycle-51.md` § 3.2 — RN-69)*.

- **QC-55:** The product is one macOS application bundle, `KA-Reader.app`, bundle identifier
  `com.kensaiapp.ka-reader`, and one process; no second binary, no second process the product starts,
  no prerequisite, no runtime install, no fetched asset, and no font shipped — the fonts are the
  platform's.
  — *verified by:* `checks/bundle.sh` — one executable under `Contents/MacOS`, the fourteen icons
  under `Contents/Resources`, and no second executable and no font anywhere under `Contents/`
  (layer 5) *(traces to: SDD § 4 C-R1 as it reads at v13; § 3 "Two libraries, one executable, one
  bundle"; SRS C-3; FDR R-131, PD-15, PD-28; ADR-0014; re-derived at v11 — RN-22)*
- **QC-56:** The minimum macOS version is 26: the bundle's `LSMinimumSystemVersion` is `26.0`, and
  the floor is stated wherever the install path is offered. Every `runs-on` in the product's CI
  names the `macos-26` label: never an alias such as `macos-latest`, which moves to the next major
  under the same name, and never an image below the floor's major.
  — *verified by:* `/usr/libexec/PlistBuddy -c 'Print :LSMinimumSystemVersion'
  KA-Reader.app/Contents/Info.plist` prints `26.0` (the release); release inspection reads the README
  and the release page (`docs/SRS.md` AC-14); `grep -h -E '^[[:space:]]*runs-on:'
  .github/workflows/*.yml | grep -v -E 'runs-on:[[:space:]]*macos-26[[:space:]]*$'` prints nothing
  (the tree) — this document's own realization of C-R5's workflow case, which
  `checks/tests/test_vm_refusal.sh`'s `test_every_runner_names_macos_26` runs over the same files
  (layer 6, a step of the gate, `checks/gate.sh:L77` at `ka-reader@8b93322`): the same `grep`, the
  same `macos-26` pattern, failing on any other runner, and failing as well when no workflow names a
  runner, which the command does not. The card's command runs the script, so that suite runs at
  every change (§ 8, *Until the card runs the script*), and release inspection runs it as well
  (RN-58) *(through v61 "No run issues that suite at a change until the card's command runs the
  script …, so until then `development-design` reading this entry is its gate for a change under
  `.github/workflows/`", true until `kensaiapp-opensource@1941f963`; on the owner's seat's answer at
  `docs/trail/architecture/cycle-55.md` § 2.1 — RN-73)*. Both the command and the case read only workflow files ending `.yml`, and GitHub runs a
  workflow file ending `.yaml` as well: a `.github/workflows/release.yaml` whose runner is
  `macos-latest` breaks this entry and passes both. For a workflow file ending `.yaml`,
  `development-design` reading this entry is the gate, and that gate stays after the card's command
  runs the script, because the gap is in which files the check reads, not in whether a run issues it
  *(drafted at v58 — RN-69; confirmed with the `.yaml` sentence added, in the owner's seat at
  `docs/trail/architecture/cycle-52.md` § 2.1 — RN-70; through v57 this read "this document's own
  realization of C-R5's workflow case, held by no script, so `development-design` reading this entry
  is its gate", false from `ka-reader@13e8d42`, where the suite already held the case)*. At
  `ka-reader@8b93322` the tree meets both halves: `ka-reader-mac/Info.plist:L13-L14` holds `26.0`,
  `ka-reader-mac/Package.swift:L23` names `.macOS(.v26)`, `ka-reader-mac/assemble.sh:L50` builds with
  `MACOSX_DEPLOYMENT_TARGET=26.0`, the workflow's one runner is `macos-26`
  (`.github/workflows/ci.yml:L18`), that check prints nothing, and the suite passes 9 of 9
  *(re-measured at v59 on the owner's seat's answer at `docs/trail/architecture/cycle-52.md` § 2.1 —
  RN-70; through v58 this sentence read "At `ka-reader@d6405e2` the tree meets neither half: the
  plist, the manifest, the deployment target and the workflow still hold the floor and the image the
  lines SDD RN-108 lists name, and that check prints `runs-on: macos-14`", true at its pin)*
  *(traces to: SDD § 4
  C-R5 as it reads at v48; § 9 TO-8; § 11 R-17; SRS C-11; FDR R-133, PD-18; ADR-0024, which
  superseded ADR-0007 at v55 — RN-66; the owner's
  answer at `docs/trail/sdd/cycle-43.md` § 5.1)* *(through v46 this entry read the floor as "14
  (Sonoma)" and `LSMinimumSystemVersion` as `14.0`, its check as "prints `14.0`", and named no CI
  image; moved at v47 on SDD v48 — RN-58)*
- **QC-57:** There is exactly one install path — download the `.dmg`, drag to Applications, the
  Privacy & Security step — named as the exact click path on the README's first screen, and no
  terminal command is ever the documented route; no cask, no second channel.
  — *verified by:* release inspection (`docs/SRS.md` AC-10, AC-14) — a review gate: the walk is a
  stranger's path and is deliberately not automated *(traces to: SDD § 4 C-R4; SRS C-3, C-9; FDR
  R-128 – R-130; ADR-0024, which superseded ADR-0007 at v55 — RN-66)*
- **QC-58:** The product offers no configuration surface: its own units — every workspace member (QC-30 half (1)) and
  `ka-reader-mac` — read no configuration file, no environment variable and no argument, and the only
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
  `ka_reader_free`, the set as the bridge exports it (C-I6 at v16) — fails on a tag inside a major
  whose bundle raises the floor, drops an asset
  or drops a function (the release; layer 5): the machine check for the install path, the floor and the
  surfaces' presence; own-state readability is QC-60's check. The behaviour member has no machine
  check — no test reads the FDR — and stays a review gate: review at `development-specs` — a change
  spec names which of the four it touches and whether the change is breaking or additive, and the
  version bump follows; release inspection reads the version against the change set
  (`docs/SRS.md` AC-14). Before `v1.0.0` there is no pin and the script is not run — C-6's
  pre-1.0.0 half, stated rather than tested *(traces to: SRS C-6; FDR R-142, PD-20, PD-40 — the
  FDR's statement of the priced set since its v4, the prerequisite clause an owner answer at
  `docs/trail/fdr/cycle-3.md` § 2.6, folded here at v6 — RN-17; SDD § 4 C-I6 as it reads at v16 — the pin reads the bridge's exports, `ka_reader_free` among them (RN-22, RN-24), § 11 R-12 — the
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

- **QC-64:** One script, `checks/gate.sh`, holds every rule the CI workflow holds. It runs every
  step of `.github/workflows/ci.yml` that runs a command, except packaging the bundle. It runs them
  in the workflow's order, each fatal: the toolchain print first, then the workspace build, the
  bridge's assembly, the test gate, and every other moved `checks/*.sh` script, suite and step after
  them, the launch of the built bundle and own-state included. So the order rules the workflow's
  comments state come with it. A step added to the script after the move sits where the script
  places it; where it must come before or after another, the comment above it says which and why
  (`checks/gate.sh:L40-L42` at `ka-reader@8235240`). The secret scan and its suite, added so, run
  after the toolchain print and before the workspace build (`:L48`, `:L58`) *(through v65 "… the
  test gate, and every `checks/*.sh` script, suite and step after them …", which put every script
  after the build and was false from `ka-reader@8235240`; that order was this document's wording for
  the moved steps and not the owner's — `docs/trail/architecture/cycle-49.md` § 3.1 names none —
  re-worded on the owner's seat's answer at `docs/trail/architecture/cycle-59.md` § 3.1 — RN-77)*.
  The script exits 0 only when every step exits 0, and it names the step that
  failed. The card's test command runs it, so it runs at every change, at both gates (§ 8). The
  workflow holds no rule of its own. When Actions runs, its job runs `checks/gate.sh` and the
  packaging and upload steps, and nothing else, so a rule added to one is added to both.
  `.github/workflows/ci.yml` stays in the tree whether Actions runs or not (§ 8, *Where the gate
  runs*).
  — *verified by:* the card's test command, issued by the pipeline's gate tool at the developer's
  closing run and at code-integrity, whose `Environment:` line names where it ran (layer 5, every
  change); `grep -nE '^[[:space:]]+run:' .github/workflows/ci.yml` prints the line that runs
  `checks/gate.sh`, the packaging line, and nothing else (the tree); and `for s in
  checks/tests/*.sh; do grep -q "$s" checks/gate.sh || echo "$s"; done` prints nothing (the tree),
  § 9's suites comparison aimed at the script. Both comparisons are held by a suite that is itself
  a step of the gate, `checks/tests/test_vm_refusal.sh` (the gate's `VM refusal suite` step,
  `checks/gate.sh:L77` at `ka-reader@8b93322`), and held more strictly than the commands state them:
  `test_every_toplevel_suite_is_an_entire_fatal_step` requires each top-level suite to be the whole
  command of a gate step (`grep -x -F`, not a substring), and
  `test_moved_steps_are_single_line_commands_in_order` requires exactly one workflow step whose whole
  `run:` is `checks/gate.sh`, directly before `Package KA-Reader.app`. The workflow case does not hold
  the first comparison's *nothing else* half — an extra `run:` step before the gate step, or after
  packaging, passes it — so that half is held by no script, and `development-design` reading this
  entry is its gate for a change under `.github/workflows/`.
  The suite holds the rest, and the card's command runs the script, so the suite runs at every
  change (§ 8, *Until the card runs the script*) *(through v61 "The suite holds the rest, but no
  run issues it at a change until the card's command runs the script …, so until then
  `development-design` reading this entry is the gate on both comparisons for a change under
  `.github/workflows/` or `checks/`. Its ground is that no run issues the check, not that no script
  holds it", true until `kensaiapp-opensource@1941f963`; on the owner's seat's answer at
  `docs/trail/architecture/cycle-55.md` § 2.1 — RN-73)* *(through v57 this read "The two comparisons are this document's own
  realization and are held by no script, so `development-design` reading this entry is their gate
  for a change under `.github/workflows/` or `checks/`, as it is for QC-56's workflow check. That
  absence is the review gate's only ground. Until `checks/gate.sh` lands, no command holds this
  entry (§ 8, *Until the script lands*)", false from `ka-reader@8b93322`, where the suite reads the
  gate's step list; on the owner's seat's answer at `docs/trail/architecture/cycle-51.md` § 3.2 —
  RN-69)* *(traces to: SDD § 4 C-I3 — "The promises are proved on
  every build", and its *Violated by*, "a build that skips a script"; ADR-0010; ADR-0012 § Decision
  — "a gate that cannot go red has not run"; the owner's answer at
  `docs/trail/architecture/cycle-49.md` § 3.1, requirements 1 and 4 — RN-67; the owner's seat's
  answer at `docs/trail/architecture/cycle-51.md` § 3.2 — RN-69)*
- **QC-65:** The steps that launch the bundle or read the running machine's home run only in a macOS
  virtual machine. They never run on a physical Mac, the owner's included, and never under the gate
  tool's owner's-Mac option. Today they are `checks/bundle.sh` and its suite, `checks/renderer.sh`
  and its suite, the launch of the built bundle through `checks/launch.sh`, and `checks/own-state.sh`
  against the machine's home, which the workflow's own-state step runs through
  `checks/own-state-step.sh`. These are the steps that start `KA-Reader.app` with `open`
  (`checks/bundle.sh:L355`, `checks/tests/test_bundle.sh:L339`, `checks/launch.sh:L50`,
  `checks/renderer.sh`, the real-bundle cases of `checks/tests/test_renderer.sh`) or read the app's
  container under `$HOME` (`checks/own-state.sh`), at `ka-reader@13e8d42`. `checks/own-state-step.sh`
  has no admission of its own and relies on its child's refusal (its header, *WHAT IT DOES NOT DO*)
  *(through v56 the set was pinned at `ka-reader@bb2e4cb`, with the `open` calls at
  `checks/bundle.sh:L339` and `checks/tests/test_bundle.sh:L317`; re-pinned at v57, a
  re-measurement and not a defect — RN-68)*. On a host that is not a virtual machine, each one
  refuses before it launches or reads anything. It exits non-zero and says why, so the gate goes red
  and never reads as green. The script offers no option, flag or variable of its own that skips the
  refusal. A step added later that launches the bundle or reads the machine's home joins this set in
  the change that adds it. The refusal lands in the change that puts these steps on the card's
  command, or before it, never after, because from that change the owner's-Mac option would run
  them. That order was met: the refusal is in the tree from `ka-reader@13e8d42`, before the card's
  command became `checks/gate.sh` at `kensaiapp-opensource@1941f963` (RN-73). The layer-4 window tests open a window inside `swift test`'s own process, start no bundle
  and read no home, and are not in the set. The cost is named, and it is live since the card's
  command became the script at `kensaiapp-opensource@1941f963`: under the owner's-Mac option no
  change to this product can pass a gate, and a contributor with no virtual machine runs every step
  but the guarded ones and the own-state suite, `checks/tests/test_own_state.sh`. That suite
  launches nothing and reads no machine home — its cases point `HOME` at a temporary directory (its
  header, *WHY THIS EXISTS*) — so it is outside the set, and it still fails off a virtual machine,
  because twelve of its fourteen cases run the real `checks/own-state.sh` with no admitting reading
  (exit 1, `2 of 14 passed`, measured on the owner's Mac at `ka-reader@13e8d42`). This entry does
  not forbid making those cases pass there: a stand-in `uname` and `sysctl` first on `PATH` is not
  an option, flag or variable of the script's own, and the suite's `test_admits_on_a_vm_reading`
  already admits the real script that way (`checks/tests/test_own_state.sh:L279-L288` at
  `ka-reader@13e8d42`). Whether the other cases admit the same way is the delivery tier's, and this
  sentence is re-measured the day they do *(through v56 the cost read "runs every step but these" —
  RN-68)*. How a script tells a virtual machine from a physical Mac is the delivery tier's. One
  reading exists: `sysctl -n kern.hv_vmm_present` printed `1` in the guest and `0` on the owner's
  Mac on 2026-10-16.
  — *verified by:* a case in which the host reads as a physical Mac and the guarded step exits
  non-zero having launched nothing and read nothing (layer 6, in the suites QC-64's script runs). For
  `checks/bundle.sh`, `checks/renderer.sh`, `checks/own-state.sh` and `checks/launch.sh` the case is
  in the script's own suite. The two guarded steps that are suites themselves,
  `checks/tests/test_bundle.sh` and `checks/tests/test_renderer.sh`, cannot run their own refusal
  case, because a suite that refuses has no case left to run, so theirs are in
  `checks/tests/test_vm_refusal.sh` (its header, *WHY THIS EXISTS*, and its `CASES` list, at
  `ka-reader@13e8d42`). And the gate tool's `Environment:` line on each change's record names
  `macos-guest` (every change). The refusal and its cases are in the tree from `ka-reader@13e8d42`.
  `checks/gate.sh` runs the suites that hold those cases, from `ka-reader@8b93322`, and the card's
  command runs the script (QC-64; § 8, *Until the card runs the script*), so the suite half is held
  at every change. The card's command runs every guarded step on every change as well, so the
  refusal is what keeps them off a physical Mac *(through v61 this read "Until the card's command
  runs the script …, no run holds the entry's suite half at a change, and `development-design`
  reading it is its gate" and "What holds meanwhile is that the card's command runs none of these
  steps", both true until `kensaiapp-opensource@1941f963`; on the owner's seat's answer at
  `docs/trail/architecture/cycle-55.md` § 2.1 — RN-73; through v57 this read "Until `checks/gate.sh` runs the
  suites that hold those cases (QC-64; § 8, *Until the script lands*)" — RN-69)*. The every-change
  `Environment:` half never rested on that gap *(through v56 the tail read "in each guarded
  script's suite … owed with the refusal and landing in the same change" and "Until the refusal
  lands, no command holds this entry" — RN-68)* *(traces to: the owner's answer at
  `docs/trail/architecture/cycle-49.md` § 3.1, requirement 2; the steps' launches and reads as the
  scripts make them, and the workflow's own comments on them, `.github/workflows/ci.yml` at
  `ka-reader@d2694c7` — RN-67; the owner's seat's answers at `docs/trail/architecture/cycle-50.md`
  §§ 3.1 and 3.2 — RN-68; `docs/trail/architecture/cycle-51.md` § 3.2 — RN-69)*

## 9. Test strategy

The layer set is **not defined here** — it is `testing_doctrine.md` v2.2.0, and this table is one
project's realization of it. Tooling for the core and the bridge comes from the Rust packet
(`languages/rust/testing.md` v1.0.1), and for `ka-reader-mac` from the Swift packet
(`languages/swift/testing.md` v1.1.0), in the organisation's language registry since
`kensaiapp-dev@3ab2e8553` (2026-09-23) — each resolving at step 1 of `languages/README.md` § The
resolution chain from the card's `Languages:` line (RN-6). Through v12 this paragraph read that no
Swift packet existed and that `ka-reader-mac`'s tooling was this product's own to record; true when
written, and history (RN-24). The packet's runner is `swift test --package-path ka-reader-mac`, the
command the SDD's bars name (`docs/SDD.md` § 6 S-1, S-2, S-3, S-8), over `ka-reader-mac/Tests/`.
**Every run assembles the bridge first.** From `ka-reader@f0f1e5f` the package links the bridge as
the local binary target `CKAReaderBridge.artifactbundle` (`ka-reader-mac/Package.swift:L30`), which
`ka-reader-mac/assemble.sh` alone writes and which is git-ignored (`.gitignore:L32`). On a fresh
checkout `swift build --package-path ka-reader-mac` exits 1 with `error: local binary target
'CKAReaderBridge' at '…/ka-reader-mac/CKAReaderBridge.artifactbundle' does not contain a binary
artifact.` (measured on a fresh clone of `ka-reader@f0f1e5f`, 2026-10-14), and the runner resolves
the same target before it builds (`ka-reader-mac/assemble.sh:L10-L12`). The precondition is every
run, not only the first: `assemble.sh` deletes and rebuilds the bundle from the checkout each time
(`:L70-L74`), so a bundle an earlier run left holds that run's bridge, and the runner tests it
without an error. The rule is CI's order — `ka-reader-mac/assemble.sh`, then the runner
(`.github/workflows/ci.yml:L31-L32`, `:L34-L35` at `ka-reader@f0f1e5f`). Every `verified by:` tail
and § 10 row in this document that names `swift test --package-path ka-reader-mac` reads under
this sentence, and none repeats it (RN-60). **A layer-4 test that places a window needs a session
in which the window server places windows.** `LaunchWindowLayoutTests` asks the window server to
place the window and waits for it, and when it is not placed in time the helper fails with *the
window server did not place the window* (`ka-reader-mac/Tests/ShellTests/LaunchWindowSupport.swift:L325-L334`
at `ka-reader@f357008`). On 2026-10-14, with the Mac's screen locked, the window server held the
window at 90% of its frame, the two drag tests timed out, and a correct change was halted
(`docs/trail/architecture/cycle-45.md` § 3.1). A run whose window tests fail with that message in a
locked session has not read the change either way. It is re-run in a session where windows are
placed, and the tests are never skipped or quieted. This precondition is every run's, like the
bridge's assembly, and every tail that names the runner reads under it (RN-63). What
this table fixes differently from the Rust packet, and why, is RN-7; where `ka-reader-mac` stands
against the Swift packet — followed, adopted, or departed from, one by one, and the toolchain CI
builds it with — is the bullet below, and the reasons are RN-24. If
this table and the doctrine disagree on the layers, this table is the copy and is wrong. Through
v10 the renderer's tooling was the TypeScript packet's — Vitest, and Playwright at layer 4 — and it
left with `ka-reader-ui` at `ka-reader@0aca57e` (RN-22; RN-25).

| Level | Scope | Tool | Where it lives |
|---|---|---|---|
| 1 — Unit | The reducer, `ItemState` transitions, the containment check, the text rule, extension recognition, the log line shape; on the Swift side, a projection decoded from an `SM-4` buffer | `cargo test --locked` (`#[cfg(test)]` beside the module); `swift test --package-path ka-reader-mac` | inside each `ka-reader-core` / `ka-reader-bridge` module; `ka-reader-mac/Tests/` |
| 2 — Integration | `fs-reader` and `git-reader` against real fixture folders and repositories; the Markdown pipeline against `hostile.md`; `highlighter` against one fixture per floor language; the bridge's export set against its generated header; `asset_bytes` against the containment check; the bridge under the address sanitizer | `cargo test --locked -p ka-reader-core --test git_state`, `--test root_finding`, `--test markdown`, `--test highlight`, `--test watch`; `cargo test --locked -p ka-reader-bridge --test exports`, `--test asset_bytes` | `crates/ka-reader-core/tests/`, `crates/ka-reader-bridge/tests/`, over `checks/fixtures/` |
| 3 — Application | `SM-4`'s function list driven in-process through `SM-5`, bypassing the shell; the whole-model switch | `checks/read-only.sh`; `cargo test --locked -p ka-reader-core --test switch` | `checks/`, `crates/ka-reader-core/tests/` |
| 4 — UI | A view is drawn from a projection and from nothing else — read with the one exception `docs/SDD.md` § 3's `surfaces` row names, that an intent the surface raised has not been answered yet, under that row's four bounds; the gap is no `ItemState`, and the reading adds no test (`docs/SDD.md` RN-82, v24; RN-37) — read too with the same row's two clauses that are not a second exception: what the pointer is over and whether the window is the key window are the shell's own observations, held across no redraw and no state of the folder (`docs/SDD.md` RN-96, RN-98), and for `see-git-status` alone the tree's marker join and the Git lists' row order stand in `surfaces`, derived only from projections the bridge sent, until `follow-the-folder` (`docs/SDD.md` § 10 RC-5, RN-94; QC-48 holds the end; RN-53) — and the shell issues no call `SM-4` does not name: nothing drawn from `pending` but the entry's name, its glyph and CONTENT's *Loading* sentence, no marker before `observed`, the Git view empty on `plain`, the failure slot and its route, the text view `isEditable` false and registering no drop type, a *resolved* image drawn from `asset_bytes`' bytes and a placeholder from none, staged told from unstaged by text, both themes | `swift test --package-path ka-reader-mac` — the tests on `main` XCTest, which the Swift packet keeps; a new test Swift Testing (the bullet below) | `ka-reader-mac/Tests/` |
| 5 — End-to-end | The built bundle: entitlements and sandbox, the shell's run under them, own-state after a session, churn and kill, latency figures; from `v1.0.0` the priced contract against its major's pin; the timed release walk | `checks/bundle.sh`, `checks/renderer.sh` with `checks/fixtures/idle-shell`, `checks/own-state.sh`, `checks/churn.sh`, `checks/latency.sh`, `checks/read-only.sh --kill`, `checks/contract.sh <tag>`; `docs/SRS.md` AC-10 as a manual timed walk | `checks/` |
| 6 — Architecture | § 1.2's graph, § 1.3's I/O ownership, § 3's reach rules, the linked tree's environment and argument reads against their reviewed list (QC-30), the shell's forbidden set and link list (QC-34), and this section's layer-5 placement (no `CARGO_BIN_EXE_` reference under `crates/*/tests/`) | `checks/structure.sh` (Rust, grep rules over shipped sources — its scope is the bullet below); `checks/entry-points.sh` (the resolved dependency tree); `checks/view.sh` (Swift: the source scan over `ka-reader-mac/Sources` and `otool -L` on the built executable) | `checks/` |
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
  `ka-reader-mac`'s — the `--test` files `ka-reader-bridge` carries are `exports` and `asset_bytes` (layer 2), and no
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
  build script. The tree holds one: `crates/ka-reader-bridge/build.rs` reads and writes the
  generated header with `std::fs` (`:L11`, `:L25`, `:L28-L30`) and reads `CARGO_MANIFEST_DIR`
  through `std::env::var` (`:L18`), and the exclusion covers every rule of the script — QC-13's
  `std::fs` rule and QC-30's and QC-58's first half alike (RN-24). The scope binds each rule that names a crate — QC-2's *no
  write API in `ka-reader-core` outside `own-state`*, QC-7's and QC-9's *no `std::process`*, QC-9's
  *no `unsafe` outside `ka-reader-bridge`*, QC-13's *no `std::fs` in `ka-reader-bridge` outside its log
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
  reason `tests/` is out. The tree holds three such sites at `ka-reader@456098c`, and
  `grep -rn '#\[path' crates/*/src` prints exactly those three. Two are
  `#[path = "../tests/common/mod.rs"]` on a `#[cfg(test)]` `mod test_support`, at
  `crates/ka-reader-core/src/lib.rs:L18-L24` and `crates/ka-reader-bridge/src/lib.rs:L10-L16`; both of
  those bodies import `std::fs` and `std::process` (`crates/ka-reader-core/tests/common/mod.rs:L8`,
  `:L11`; `crates/ka-reader-bridge/tests/common/mod.rs:L8`, `:L13`). The third is
  `#[path = "../tests/unit/fs_reader.rs"]` on `fs_reader`'s `#[cfg(test)]` `mod tests`, at
  `crates/ka-reader-core/src/fs_reader.rs:L894-L896`. Its body imports no `std::process`, and its
  fixture writes (`crates/ka-reader-core/tests/unit/fs_reader.rs:L753`, `:L953`) sit in `fs-reader`,
  a filesystem owner QC-15 exempts. A reading by module would fail the tree as built: with each
  body placed where such a reading judges it, `checks/structure.sh` v1.3.0 at `ka-reader@456098c`
  raises QC-2, QC-9, QC-15 and QC-36 in `ka-reader-core` and QC-15 and QC-36 in `ka-reader-bridge` —
  the overreach RN-19 removed when it scoped QC-61. The count, the lines and the findings are
  dated and pinned: a fourth site, or a rule the script gains, is a re-measurement of this
  sentence and not a contradiction of it *(through v30 this sentence counted two sites and named
  QC-36 and QC-15 alone. The third site arrived at `ka-reader@04ad072` and the script's QC-2 rule at
  `ka-reader@e7f151e`, both merged at `ka-reader@73c408e`; QC-9's process clause has been in the script
  since its v1.0.0 (`checks/structure.sh:L5`), so QC-9 was missing from the list since v26. On
  the owner's seat's answer at `docs/trail/architecture/cycle-28.md` § 3.1 — RN-42)*. **What the scope does not do, named so none of it is read as coverage:** any later
  `benches/` or `examples/` is not excluded, until one occurs; and two escapes are review catches
  at `development-design` and not grep rules, because the tree holds no *shipped* site to shape
  one against — shipped code that pulls a file from `tests/` in through a `#[path]` attribute,
  which is the attribute above on a module without the `#[cfg(test)]` gate, whose body would then
  ship and no scan would read (RN-19). The file reading above and this escape rest on each other:
  the reading is safe only while the module stays gated, and the script's own header names the
  gap (`checks/structure.sh:L101-L102` at `ka-reader@463acb9`) *(through v25 this sentence said the
  tree held no such site, true of shipped code and silent on the two test-only ones; on the
  owner's seat's answers at `docs/trail/architecture/cycle-23.md` §§ 3.3, 3.4 — RN-37)*. The
  second escape is Rust source a build script generates into `OUT_DIR` and a shipped file pulls
  in with `include!`, which ships and which no scan of sources reads (`grep -rn OUT_DIR crates/`
  prints nothing, 2026-09-23; RN-24). **`checks/view.sh` has the same scope on the Swift
  side:** it scans `ka-reader-mac/Sources`, the path C-R7 names, and `ka-reader-mac/Tests/` is outside
  its scan — a test may build an attributed string or read a fixture file that a surface may not.
- **The harness's own suites, `checks/tests/`, run as steps of `checks/gate.sh` — stated once,
  here.** Each `checks/<name>.sh` script with a suite `checks/tests/test_<name>.sh` beside it is
  proved by that suite to read what its entry says it reads, and the suite runs as its own fatal step
  of `checks/gate.sh`, the way the gate's `Bundle probe suite` step runs `checks/tests/test_bundle.sh`
  (`checks/gate.sh:L77` at `ka-reader@8235240`; `:L55` at `ka-reader@8b93322` — RN-77); the workflow
  runs the gate through its `Test gate` step (`.github/workflows/ci.yml:L28` at `ka-reader@8235240`;
  `:L26` with no commit named through v65, true until `fetch-depth: 0` landed — RN-77) *(through v57 the suite ran "as its own CI step on every
  build, the way `Bundle probe suite` runs `checks/tests/test_bundle.sh`
  (`.github/workflows/ci.yml:L41-L42` at `ka-reader@463acb9`)" — RN-69)* — a script whose suite runs
  nowhere is ADR-0012's rule broken one level down: a gate that cannot go red has not run. A script
  that lands with a suite lands the suite as a step of `checks/gate.sh` in the same change, and the
  workflow runs it through `Test gate` *(through v57 "lands the suite's CI step in the same change" —
  RN-69)*. Twelve suites are in the tree (`git ls-tree --name-only 8235240 checks/tests/`:
  `test_bundle.sh`, `test_entry_points.sh`, `test_launch.sh`, `test_no_network.sh`,
  `test_own_state.sh`, `test_own_state_step.sh`, `test_read_only.sh`, `test_renderer.sh`,
  `test_secret_scan.sh`, `test_structure.sh`, `test_view.sh`, `test_vm_refusal.sh`) and all twelve
  are steps of the gate at `ka-reader@8235240`, each the whole command of one `run_step` call
  (`checks/gate.sh` at `ka-reader@8235240`: `:L48` `test_secret_scan.sh`; `:L72`
  `test_structure.sh`; `:L74` `test_entry_points.sh`; `:L77` `test_bundle.sh`; `:L79`
  `test_view.sh`; `:L89` `test_renderer.sh`; `:L93` `test_read_only.sh`; `:L95`
  `test_no_network.sh`; `:L96` `test_own_state.sh`; `:L99` `test_vm_refusal.sh`; `:L100`
  `test_launch.sh`; `:L101` `test_own_state_step.sh`). `test_secret_scan.sh` pairs with
  `checks/secret-scan.sh` *(re-measured at v66 from eleven, on the owner's seat's answer at
  `docs/trail/architecture/cycle-59.md` § 3.1 — RN-77; through v65 it counted eleven, all steps of
  the gate at `ka-reader@8b93322` — `:L50`, `:L52`, `:L55`, `:L57`, `:L67`, `:L71`, `:L73`, `:L74`,
  `:L77`, `:L78` and `:L79` — true at that pin)*. One of the twelve has no script beside it:
  `test_vm_refusal.sh` holds the refusal cases of the two guarded suites and checks the gate's step
  list and the workflow's shape (QC-64, QC-65), so it is counted and a step though no
  `checks/<name>.sh` pairs with it. `checks/tests/support/` is not a suite: it holds the sourced
  helper `vm_refusal.sh`, kept outside the `checks/tests/*.sh` glob on purpose (its header)
  *(re-pinned at v58 on `checks/gate.sh`, on the owner's seat's answer at
  `docs/trail/architecture/cycle-51.md` § 3.3 — RN-69; through v57 all eleven were on workflow steps
  at `ka-reader@13e8d42` — `.github/workflows/ci.yml` `:L40-L41`, `:L46-L47`, `:L53-L54`,
  `:L59-L60`, `:L70-L71`, `:L82-L83`, `:L88-L89`, `:L91-L92`, `:L95-L96`, `:L98-L99` and
  `:L101-L102` — true at that pin; re-measured from eight at v57, on the owner's seat's answer at
  `docs/trail/architecture/cycle-50.md` § 3.3 — RN-68; through v56 it counted eight, on steps at
  `ka-reader@b158052` — `:L31-L32`, `:L37-L38`, `:L47-L48`, `:L53-L54`, `:L64-L65`, `:L73-L74`,
  `:L79-L80` and `:L82-L83` — true at that pin)*; the workflow's `Test gate` step (`ci.yml:L28` at
  `ka-reader@8235240`) runs `checks/gate.sh`, and through it all twelve *(through v65 `ci.yml:L26`
  and "all eleven" — RN-77)* *(through v57 "the test command (`ci.yml:L26`)
  runs none of them", true at `ka-reader@13e8d42` — RN-69)*. One suite ran at the
  change before the script did: `test_structure.sh`, with its script, on the card's command from
  `kensaiapp-opensource@5be8615c` — § 8 holds that rule, and this bullet does not repeat it (RN-65)
  *(through v61 "One suite runs at the change as well … § 8 holds that rule and what it still owes"
  — RN-73)*. **From `checks/gate.sh`, every suite runs at the change** (QC-64): the script runs each suite as its own fatal step, in the workflow's order. The comparison in this bullet's tail is aimed at the script, whose list the card and the workflow both run. The card's command runs the script, so every suite runs at every change, whether Actions runs or not (§ 8, *Until the card runs the script*; RN-67) *(through v61 "While Actions is off and the card's command does not run the script, a suite runs at no change, and only a run of the script reaches it", true until `kensaiapp-opensource@1941f963` — RN-73; through v57 "While Actions is off and the script is not in the tree, a suite on a workflow step alone runs nowhere" — RN-69)*. The count and the lines are dated and pinned: a further suite, or a step inserted
  above these, is a re-measurement of this sentence and not a contradiction of it, and a new suite
  lands its step in the same change by the rule above. This sentence is the count's one home —
  § 10 points here and does not repeat it *(through v25 it counted six, on steps from
  `ka-reader@ab39502`, at `:L35-L36`, `:L41-L42`, `:L52-L53`, `:L61-L62`, `:L67-L68` and `:L70-L71`
  with no commit named — true at `ka-reader@ab39502`, and moved six lines down when `Structure check`
  and `Structure check suite` landed at `:L28-L32`; on the owner's seat's answer at
  `docs/trail/architecture/cycle-23.md` § 3.2 — RN-37; through v27 it counted seven, on steps at
  `ka-reader@463acb9` — `:L31-L32`, `:L41-L42`, `:L47-L48`, `:L58-L59`, `:L67-L68`, `:L73-L74` and
  `:L76-L77` — true at that pin, and re-measured to eight when `test_entry_points.sh` landed with
  its step at `ka-reader@b158052`; on the owner's seat's answer at
  `docs/trail/architecture/cycle-25.md` § 3.1 — RN-39)*. *History,
  and the rule it kept:* at `ka-reader@153f5a1` one suite was on a step, `test_bundle.sh`, and
  `test_renderer.sh` failed one case, `test_header_names_the_runner_reading`, the test of a task
  that change deferred; the ordering rule then in force — that suite's step lands with the change
  that puts the runner reading in `checks/renderer.sh`'s header, or after it, never by skipping
  or deleting the case — held: the reading went into the header at `ka-reader@2b83dce` and the
  suite's step landed at `ka-reader@66ba2e8`, both in the change merged at `ka-reader@ab39502`, and
  the case passes there (`KA_READER_TEST_ONLY=test_header_names_the_runner_reading
  checks/tests/test_renderer.sh` → `ok`, exit 0, re-run this fold). **How a suite joins.** A
  suite joins as a fatal step, and its first CI run is its hosted-runner reading: whether a suite
  runs on the hosted runner is not known until it is tried there, and trying it is the join. A
  suite that is red there moves to a named release step on the Mac, recorded in this bullet with
  the measurement, never left silent — and until the next change moves or fixes it, `main` is
  red; the step is never quieted. The one ruled-out way to join: a non-fatal step —
  `continue-on-error`, or an `if:` that skips it — while a suite waits for its reading, a gate
  that cannot go red (ADR-0012 § Decision). A check refuses that join at the workflow:
  `checks/tests/test_vm_refusal.sh`'s `test_no_conditional_or_nonfatal_step` fails on a
  `continue-on-error` or an `if:` in `.github/workflows/ci.yml` (at `ka-reader@8b93322`; RN-69). *From v56 a suite joins as a fatal step of `checks/gate.sh`, and its first guest run is its reading. A suite that is red there stays red, and `main` with it, until the next change fixes it. A suite that launches the bundle or reads the machine's home never moves to the owner's Mac (QC-65), and no suite is quieted (RN-67).* Where the five stand as this fold runs (2026-09-24,
  at `ka-reader@c26d47c`): not yet run on the hosted runner — no step carries `if:` or
  `continue-on-error` (`grep -nE 'continue-on-error|^[[:space:]]+if:' .github/workflows/ci.yml`
  prints nothing), and `gh run list --repo kensaiapp/ka-reader --workflow ci.yml` lists as its
  newest 35988399477 on `ka-reader@37a962d` and 35968105480 on `ka-reader@c461b29`, `origin/main` is
  `c461b29` and `git rev-list --count origin/main..main` prints `29`, so no push yet carries the
  five steps; on a Mac at `ka-reader@ab39502` with the bundle built, all six exit 0 (the PM's
  measurement, `docs/trail/architecture/cycle-14.md` § 3.2). The first push that carries them is
  their reading, and this bullet records it *(through v16 this bullet read one of six on a step
  and the five joining "as each is green on the hosted runner" — a precondition only the join
  could meet; on the owner's seat's answers at `docs/trail/architecture/cycle-14.md` §§ 3.1, 3.2
  — RN-28)*. Where they stand at v28 (2026-10-03, at `ka-reader@6dae2ca`, whose `ci.yml` and
  `checks/` are `ka-reader@b158052`'s): **the five have their reading, green.** The first push to
  carry them, `ka-reader@c79270f`, ran as GitHub Actions run 36034875098 (push to `main`,
  2026-09-24T17:31:13Z, `success`), and `View check suite`, `Renderer gate suite`, `Read-only
  suite`, `No-network suite` and `Own state suite` each read `success` in it, as does `Bundle
  probe suite` (`gh run view 36034875098 --repo kensaiapp/ka-reader --json jobs`); the run before
  it, 35988399477 on `ka-reader@37a962d`, does not carry `ka-reader@ab39502`. **The four steps that joined
  after have none.** `Structure check` and `Structure check suite` landed at `ka-reader@463acb9`, and
  `Entry-points check` and `Entry-points check suite` at `ka-reader@b158052`. `origin/main` is
  `d234b57`, `git merge-base --is-ancestor <commit> origin/main` exits 1 for both commits, and
  the newest run, 36958237363 on `ka-reader@d234b57` (2026-10-02T03:00:44Z, `success`), lists none
  of the four steps. All four are fatal — the grep above still prints nothing — and the first
  push that carries each pair is its reading, which this bullet records *(added at v28: the
  entry-points pair on the owner's seat's answer at `docs/trail/architecture/cycle-25.md` § 3.1,
  the five's reading and the structure pair found while folding it — RN-39)*. § 10 names each
  script's suite beside it.
  — *verified by:* `checks/tests/test_vm_refusal.sh`'s `test_every_toplevel_suite_is_an_entire_fatal_step`
  (layer 6, a step of the gate, `checks/gate.sh:L77` at `ka-reader@8b93322`), which fails when any
  suite under `checks/tests/` is not the whole command of a step of `checks/gate.sh`, and when it
  finds no suite at all. It is this tail's comparison aimed at the script, and stricter than it:
  `grep -x -F` on the whole command, not `grep -q` on a substring. It is the check this tail owed
  from v15 — "a `checks/` script that runs the comparison and exits non-zero when any suite under
  `checks/tests/` is named by no step … The day it lands, this tail names it and the review gate
  drops" — in the tree from `ka-reader@13e8d42`, where it read the workflow, and aimed at the
  script at `ka-reader@8b93322`. In a copy of `8b93322` it passed, and it went red with an unlisted
  suite added (`checks/tests/test_unlisted.sh`: "is not the entire command of a step in
  checks/gate.sh", 8 of 9 passed; measured for v58 — RN-69). The card's command runs the script, so
  it runs at every change (§ 8, *Until the card runs the script*) *(through v61 "No run issues it
  at a change until the card's command runs the script …, so until then `development-design`
  reading this bullet is the gate on any change under `checks/` or to `.github/workflows/ci.yml` —
  a review gate whose ground is that no run issues the check, not that no script holds it", true
  until `kensaiapp-opensource@1941f963`; on the owner's seat's answer at `docs/trail/architecture/cycle-55.md` § 2.1 —
  RN-73)*. A step naming a deleted suite fails the gate on its own, a missing file
  exiting non-zero *(through v57 this tail named `for s in checks/tests/*.sh; do grep -q "$s"
  .github/workflows/ci.yml || echo "$s"; done` over the tree as the check — nothing at
  `ka-reader@ab39502`, `b083f99` and `6dae2ca`, re-run for v15, v26 and v28; at `ka-reader@8b93322`
  it prints all eleven suites, since the workflow names none — its ground read "no script in the
  tree runs that comparison … and that absence is the gate's only ground", it owed the script above,
  and from v56 it named the same loop over `checks/gate.sh` (RN-67); on the owner's seat's answer at
  `docs/trail/architecture/cycle-51.md` § 3.3 — RN-69)* *(through v16 this tail's ground was that a step would be red on every build
  until the five landed, false from `ka-reader@ab39502`; on the owner's seat's answer at
  `docs/trail/architecture/cycle-14.md` § 3.3 — RN-28)* *(traces to: SDD § 4 C-I3 — its
  *Violated by*, "a build that skips a script", and its probe-suite clause; § 3
  `read-only-harness`; ADR-0012 § Decision — "a gate that cannot go red has not run"; QC-25's
  tail — the probe's suite, "without which the probe has not run"; added at v15 on the owner's
  seat's answer at `docs/trail/architecture/cycle-12.md` § 3.5 — RN-26; re-cut at v17 on the
  owner's seat's answers at `docs/trail/architecture/cycle-14.md` §§ 3.1 – 3.3 — RN-28)*
- **`ka-reader-mac` against the Swift packet, stated once, here** (the reasons are RN-24; the packet
  is `languages/swift/`, and a rule of it not named here is followed as written). *Framework —
  adopted:* new tests use Swift Testing, and the existing XCTest files stay, as the packet keeps
  them (`testing.md` § One framework). The clause departed only until a CI log on `main` named a
  toolchain that runs Swift Testing. Swift 6 toolchains include it
  (https://www.swift.org/blog/announcing-swift-6/, re-read 2026-10-13), and GitHub Actions run
  37845881070, the first on `main` to print the toolchain, prints Swift 6.0.3 (the *Toolchain*
  clause below), so the flip happened at that run, on 2026-10-08. No file has been added under
  `ka-reader-mac/Tests/` since: `git log --since=2026-10-08 --diff-filter=A -- ka-reader-mac/Tests`
  prints nothing at `ka-reader@fcb2e2f`, so no test broke the rule before this revision stated it.
  The flip is separate from the tools-6.2 flip below, and the toolchain it rests on is read from a
  log, never from the image label (RN-31) *(through v47 this clause read "departed from until a CI
  log on `main` names a toolchain that runs Swift Testing", with new tests in XCTest — five files
  imported it at `ka-reader@f46269a`, the fifth
  `ka-reader-mac/Tests/SurfacesTests/RootItemsViewExpansionTests.swift`, added at
  `ka-reader@a5fc189` — and it grounded the separation in "the current `macos-14` image carries
  Xcode 16.1 and 16.2 beside its 15.4 default", true of the workflow through `ka-reader@8926052`;
  from `ka-reader@fcb2e2f` the job runs on `macos-26` and selects no Xcode
  (`.github/workflows/ci.yml:L18-L19`); re-derived at v48 on the owner's seat's answer at
  `docs/trail/architecture/cycle-41.md` § 3.1 — RN-59)*. *Test targets — adopted:* named
  `<Target><Layer>Tests`, the packet's form (`layout.md` § Naming); `SurfacesTests` and
  `ShellTests` (`ka-reader-mac/Package.swift:L39-L40` at `ka-reader@827aad4`) predate the packet and are
  owed it *(through v40 cited `:L34-L35` with no commit named, true at `ka-reader@a4ab8e6`; the lines
  moved five down when `ka-reader@827aad4` added the libgit2 link lines above them — RN-52)*, and which
  layer word each takes is the delivery tier's placement under this table's rows. *Toolchain —
  measured on every build:* CI builds `ka-reader-mac` in two steps, assembly first —
  `.github/workflows/ci.yml:L31-L32` runs `ka-reader-mac/assemble.sh` in `Build KA-Reader.app`, and
  `:L34-L35` runs `swift test --package-path ka-reader-mac` in `Test gate`, both at
  `ka-reader@f0f1e5f` — the order the runner needs (the runner paragraph above) *(through v48 this
  clause read "from `ka-reader@0aca57e` CI builds `ka-reader-mac` in two steps —
  `.github/workflows/ci.yml:L26` runs `swift test --package-path ka-reader-mac` in `Test gate`, and
  `:L35` runs `ka-reader-mac/assemble.sh`, both at `ka-reader@463acb9`", true at that pin; the app
  build moved ahead of `Test gate` at `ka-reader@d2694c7`, merged at `ka-reader@f0f1e5f`; on the
  owner's seat's answer at `docs/trail/architecture/cycle-42.md` § 3.2 — RN-60)* *(drafted at v26 — RN-37 — and
  confirmed in the owner's seat at `docs/trail/architecture/cycle-24.md` § 2.1 — RN-38: through
  v25 the build step was cited `:L29` with no commit named, true at `ka-reader@0aca57e`, and it
  moved six lines down when `Structure check` and `Structure check suite` landed at `:L28-L32`)*
  *(through v13 this clause read that CI did not build it,
  true of `ci.yml` at `ka-reader@99e2bac`; corrected on the owner's seat's answer at
  `docs/trail/architecture/cycle-11.md` § 3.4 — RN-25)* — and the toolchain version CI builds it with, which the packet has this document record where
  no `.swift-version` pin exists, and none does (`toolchain.md` § Toolchain version), is printed on
  every build by the `Toolchain` step (`swift --version && xcrun --show-sdk-version`,
  `.github/workflows/ci.yml:L23-L24` at `ka-reader@fcb2e2f`, in the tree from `ka-reader@d852457`).
  **First measurement:** GitHub Actions run 37845881070 on `ka-reader@fcc3d4f` (2026-10-08,
  `success`) — Apple Swift 6.0.3 (swiftlang-6.0.3.1.10), SDK 15.2, image `macos-14-arm64`
  20260831.0302.1; run 38449250910 on `ka-reader@8926052`, the last `main` build on that image,
  prints the same. The Swift version, the run id and the image version are recorded together
  because a label's default Xcode can move under the same name, and a later reader must tell a
  re-measurement from a contradiction. **The `macos-26` measurement:** GitHub Actions run
  38463966607 on `ka-reader@4601cd9` (2026-10-13), the first `main` run on that image — Apple Swift
  6.3.3 (swiftlang-6.3.3.1.3), SDK 26.5, image `macos-26-arm64` 20260907.0351.1. That run failed at
  `Test gate`, after its `Toolchain` step passed, so the reading stands; run 38501500758 on
  `ka-reader@3f7a68d` (2026-10-14, `success`) prints the same *(through v48 this sentence read "The
  `macos-26` toolchain is a re-measurement, recorded here from the first `main` log on that image,
  and none exists yet: `ka-reader@fcb2e2f`, which moved the job, is on no remote branch, and
  `origin/main` is `ka-reader@8926052`", true when v48 was written; `ka-reader@fcb2e2f` reached
  `origin/main` and run 38463966607 built it; on the owner's seat's answer at
  `docs/trail/architecture/cycle-42.md` § 3.2 — RN-60)* *(through v47
  this clause read *not yet measured* and the toolchain *still unread*: the first CI run on `main`
  to run those steps, GitHub Actions run 35968105480 on `ka-reader@c461b29` (`success`; image
  `macos-14-arm64` 20260831.0302.1, macOS 14.8.9), names no Swift version — its one
  `swift-version` line is a build file's name — and `ci.yml` had no `swift --version` step
  (`:L22-L35` at `ka-reader@463acb9`, `grep -n 'swift --version'` printing nothing over the whole
  file — drafted at v26, RN-37, confirmed at `docs/trail/architecture/cycle-24.md` § 2.1, RN-38),
  whether to add one being the delivery tier's; that grep prints `:L24` from `ka-reader@d852457`,
  and v47 read neither the step nor its logs; re-derived at v48 on the owner's seat's answer at
  `docs/trail/architecture/cycle-41.md` § 3.1 — RN-59)* *(through v14 this clause read that
  no CI run on `main` had built it, true at `origin/main` = `a4ab8e6`; drafted at v15 on the item a
  `companion-self-answer` run raised on this document — RN-26 — and confirmed in the owner's seat
  at `docs/trail/architecture/cycle-13.md` § 2.1 — RN-27)*. **The toolchain of record is the one the change gate runs on** (the owner's answer at
  `docs/trail/architecture/cycle-49.md` § 3.1, requirement 3 — RN-67). `checks/gate.sh` prints
  `swift --version` and `xcrun --show-sdk-version` before its first build (QC-64), so every gate
  run's output carries its toolchain. The record is the guest's: **Apple Swift 6.3.2
  (swiftlang-6.3.2.1.108), SDK 26.5**, on macOS 26.6.2 (25G83), with Xcode at
  `/Applications/Xcode_26.5.app`. It was read in the managing pipeline's macOS guest, `kensai-macos`,
  on image `ghcr.io/cirruslabs/macos-tahoe-xcode:26.5`, on 2026-10-16, with `tart exec kensai-macos
  sh -c 'swift --version; xcrun --show-sdk-version; sw_vers'`. A verdict that depends on the
  compiler is read off a run that printed that toolchain. A run on any other toolchain, a patch
  release included, or a run that names none, proves the change on the toolchain it ran on and
  nothing more. The rule stays at the strict reading, which is tighter than the Swift packet's: the
  packet accepts a patch-level gap between the guest's Swift and CI's (`environment.md` § Default and
  CI alignment). It stays strict because only a minor-version difference has been measured to
  matter (6.3 against 6.4, below), and a patch difference has been checked on this tree once. If
  Actions returns, a hosted run runs the same script (QC-64) and prints its own toolchain. It
  corroborates the gate when the two toolchains match. Where they differ and the results differ, the
  difference is measured and recorded here, as the 6.3/6.4 pair below was. The record moves when the
  guest's printed toolchain does, by re-measurement. Where the gate runs is § 8's *Where the gate
  runs* *(through v55 this passage made the hosted CI build on `main` the reference: "A change-time
  verdict — the card's command (§ 8), wherever it runs — stands in for CI only when the Swift version
  and SDK the run printed are that toolchain, today Apple Swift 6.3.3 on SDK 26.5", with "the CI
  build on `main` is the reading", "until a change-time run carries the recorded toolchain, no
  change-time verdict stands in for CI" and "this document names no machine (RN-63)"; true while
  hosted CI ran on every push, and moved at v56 on the owner's answer — RN-67)*. **Two compilers, held as a bounded
  supported pair.** Swift 6.3 counts `withCString` as an unsafe use and Swift 6.4 does not, and under
  `.strictMemorySafety()` with warnings as errors each rejects the other's spelling.
  `ka-reader@47e8e6b` passed a change-time run on Swift 6.4, then went red on the recorded toolchain
  at GitHub Actions run 38549778886, step `Build KA-Reader.app`: `NativeBridge.swift:24:9` and
  `:28:9`, "expression uses unsafe constructs but is not marked with 'unsafe'".
  `ka-reader-mac/Sources/KAReader/NativeBridge.swift` now carries both spellings under
  `#if compiler(>=6.4)` (`:L23-L40` at `ka-reader@24be581`, unchanged at `ka-reader@f357008`). The
  `#else` arm builds on the toolchain this clause records — the guest's Swift 6.3.2 takes it, as
  the hosted 6.3.3 did — and the change gate holds it on every change, today through the card's
  `swift test` in the guest *(through v55 "and CI holds it on every build" — RN-67)*; run
  38551538187 on `ka-reader@24be581` is its first green. The `compiler(>=6.4)` arm is held by no
  hosted check, only by change-time runs on 6.4. The `#else` arm is owed removal from the first gate run of record whose printed toolchain is
  Swift 6.4 or later, because from then nothing builds it *(through v55 "from the first CI log
  whose `Toolchain` step prints Swift 6.4 or later" — RN-67)*; whether
  and when to remove it is the delivery tier's (on the owner's seat's answer at
  `docs/trail/architecture/cycle-45.md` § 3.1 — RN-63). *Adopted in the tree at `ka-reader@f0f1e5f`, as one decision — the seven tools-6.2 items:* the
  `6.2` tools version (`ka-reader-mac/Package.swift:L1` reads `// swift-tools-version:6.2`, and `:L23`
  `platforms: [.macOS(.v26)]`); the artifact-bundle link, the route the packet lists first —
  `.binaryTarget(name: "CKAReaderBridge", path: "CKAReaderBridge.artifactbundle")` (`:L30`), a bundle
  `ka-reader-mac/assemble.sh` writes from the bridge's release archive, its generated header and
  the tracked module map `ka-reader-mac/Sources/CKAReaderBridge/module.modulemap`
  (`assemble.sh:L53-L74`), git-ignored (`.gitignore:L32`) and never committed; the Swift 6 language
  mode, written out (`swiftLanguageModes: [.v6]`, `Package.swift:L49`); `.treatAllWarnings(as:
  .error)` and `.strictMemorySafety()` on all five Swift targets, `SurfacesTests` and `ShellTests`
  included; `.defaultIsolation(MainActor.self)` on `Surfaces` and `KAReader` only; and the packet's
  dependency gate's `type == "system"` clause (`quality_gates.md` § The gates —
  `select(.url != null or .type == "system")`), followed as written, since no target is of type
  `system`. Measured on a fresh clone of `ka-reader@f0f1e5f` on 2026-10-14:
  `swift package --package-path ka-reader-mac dump-package` exits 0 without the bridge artifact and
  prints tools `6.2.0`, language mode `6`, platform `macos 26.0`, the settings on the targets named
  above, `CKAReaderBridge` of type `binary`, no target of type `system` and none carrying a `url`.
  The flip is the departure's own trigger firing — the change that writes the `6.2` tools version,
  which `docs/SDD.md` RN-108 ties to the floor — and all seven flipped together, as the review gate
  then required; no record is owed for it (RN-60). **The adoption is CI's as well as the tree's.**
  `ka-reader@f0f1e5f` is on `origin/main`. The first hosted build of the `6.2` manifest is GitHub
  Actions run 38549778886 on `ka-reader@47e8e6b` (2026-10-14). The manifest loaded on the hosted
  Swift 6.3.3, and the run went red at `Build KA-Reader.app`, in a source compile: the adopted
  `.strictMemorySafety()` met a spelling Swift 6.3.3 rejects (the *Toolchain* clause's two-compiler
  pair). `ka-reader@24be581` fixed the source, and run 38551538187 on it is the first green hosted
  build of the manifest; run 38577309118 on `ka-reader@f357008` is green too *(through v51 this
  passage read "The adoption is the tree's, not yet CI's. `ka-reader@f0f1e5f` is not on
  `origin/main` (`ka-reader@3f7a68d`), so no hosted run has built the `6.2` manifest. The hosted
  `macos-26` Swift is 6.3.3 (the *Toolchain* clause), above the tools floor, so the manifest is
  expected to load, and the first hosted build of it is the confirming reading: a red there
  contradicts this clause and is not noise", true when v49 wrote it. The first hosted build's red
  came from the source, not from the manifest, so it did not contradict the clause; drafted at v52 on
  the item a `companion-self-answer` run raised on this document,
  `docs/trail/architecture/self_answer-50.md` § *Raised on this document* — RN-63 — and confirmed
  in the owner's seat at `docs/trail/architecture/cycle-46.md` § 2.1 — RN-64)*. **The `type == "system"` clause
  is held by `checks/no-network.sh`.** The script, at version 1.2.0, reads the dump with `plutil`
  rather than `jq` and refuses three things in the Swift package (*THE SWIFT HALF*,
  `checks/no-network.sh:L34-L46` at `ka-reader@825bfcd`): a non-empty `dependencies` array
  (`:L136`), a target carrying a `url` (`:L143-L151`), and a target whose `type` is exactly the
  string `system`, named by its `name` (`:L159-L164`). It also refuses a `Package.resolved` at any
  depth under the package (`:L172-L179`). Its suite `checks/tests/test_no_network.sh`, at version
  1.3.0, holds the refusal with `test_system_target_fails` (`:L64`, `:L512`, at
  `ka-reader@825bfcd`). The two halves hold different things. The suite drives the script on
  stubbed dumps, so it holds the refusal's logic, and a change that drops the refusal turns that
  case red. The gate run reads the real dump, on every change. The script fails closed: a missing
  `swift` or `plutil`, or a dump it cannot read, is a failure (`:L120-L133`, exiting non-zero at
  `:L181`), never a silent pass *(through v64 this passage read "The `type == "system"` clause holds
  with no check behind it. `checks/no-network.sh` refuses only a non-empty `dependencies` array and
  a target carrying a `url` (`:L31-L32`, `:L131-L138`), reads the dump with `plutil` rather than
  `jq`, and refuses a `Package.resolved` at any depth under the package (`:L149`), so a change that
  put a `.systemLibrary` target back would pass every gate in the tree. A refusal of any target of
  type `system` is owed to `checks/no-network.sh`, with a case in its suite
  `checks/tests/test_no_network.sh` that turns it red; until it lands, the `development-design`
  review below holds it, and whether and when to write it is the delivery tier's". Its three
  locators named no commit; they were true of the script at version 1.1.0, `ka-reader@ae72bdc`. The
  passage held until version 1.2.0 landed. Re-derived on the owner's seat's answer at
  `docs/trail/architecture/cycle-58.md` § 3.1 — RN-76)* *(through v48 this
  passage read the seven as departed from, as one decision, until the change that writes the `6.2`
  tools version, with the bridge linked through `.systemLibrary(name: "CKAReaderBridge")` and
  `no-network.sh` standing in the dependency gate's place; its words — the measured source cost of
  adopting, "No target carries `StrictConcurrency` meanwhile", "with Swift 5 mode held" and "Which
  Swift it carries is unread … Swift 6.0.3 on `macos-14`, is below 6.2" among them — were true until
  `ka-reader@f0f1e5f` and stand whole in RN-60; on the owner's seat's answer at
  `docs/trail/architecture/cycle-42.md` § 3.1 — RN-60)*.
  — *verified by:* `swift test --package-path ka-reader-mac` after `ka-reader-mac/assemble.sh` (the
  runner, every change; the runner paragraph above); `checks/no-network.sh` (the dependency gate's
  `dependencies`, `url` and `type == "system"` conditions, every change), with its suite
  `checks/tests/test_no_network.sh`, whose `test_system_target_fails` goes red when the
  system-target refusal is dropped; review at `development-design` on any change to
  `ka-reader-mac/Package.swift` or `.github/workflows/*.yml` against this bullet — the six tools-6.2
  items no script reads stay adopted, read off `swift package --package-path ka-reader-mac
  dump-package`, which runs without the bridge artifact: tools `6.2.0`, language mode `6`, the
  settings on the targets the *Adopted* passage names, none carrying a `url` — and
  review at `development-design` on any change that adds a file under `ka-reader-mac/Tests/`,
  against the *Framework* clause — review gates because no script holds either check: no script in
  the tree reads the dump for the six, and a
  test's framework binds only the files a change adds, which no command over the tree tells apart
  from the XCTest files the packet keeps; each stays a review bar at `development-design` until a
  check is written for it *(through v64 this tail named the script for "the dependency gate's
  `dependencies` and `url` conditions" only, read "the seven tools-6.2 items stay adopted" with "no
  target of type `system`" among the dump's readings, gave as its ground "no script in the tree
  reads the dump for the seven or for a `system` target (the refusal owed above)", and ended "and
  the day `checks/no-network.sh` refuses a `system` target, that clause's gate is the script". That
  day came with the script's version 1.2.0; on the owner's seat's answer at
  `docs/trail/architecture/cycle-58.md` § 3.1 — RN-76)*. The toolchain lines `checks/gate.sh` prints are what the *Toolchain* clause above is checked
  against, on every change. The gate run — the bridge's assembly and the test gate, every change — is
  the reading the clause's reference rule names, and it is what fails when the `#else` arm stops
  building; the same output is where the arm's removal comes due. The card's command is the script, so the
  test gate's `swift test` in the guest holds the arm at every change *(through v61 "Until the card
  runs the script, the card's `swift test` in the guest holds the arm", true until
  `kensaiapp-opensource@1941f963` — RN-73; through v57 "Until the script lands" — RN-69)*, and the guest's toolchain is the one the clause records
  as read in the guest *(through v55 this read "The `Toolchain` step's log is what the *Toolchain*
  clause above is checked against, on every build. The CI build on `main` — `Build KA-Reader.app` and
  `Test gate`, every push — is the reading the clause's reference rule names", with the same log
  where the arm's removal came due — RN-67)*. The
  `compiler(>=6.4)` arm has no hosted check, as the clause says (RN-63) *(through v48 the first review gate read "the seven tools-6.2
  departures, including the dependency-gate clause, flip together or not at all", its ground "the
  seven flipping together is read off the manifest's diff", and the no-network clause "the Swift
  half of the dependency gate"; the flip happened at `ka-reader@f0f1e5f`, so the gate is re-aimed at
  keeping the seven; on the owner's seat's answer at `docs/trail/architecture/cycle-42.md` § 3.1 —
  RN-60)* *(through v47
  this ground read "no command reads which toolchain CI builds with … the review stands until a CI
  log on `main` names the toolchain", true until `ka-reader@d852457`; re-derived at v48 on the
  owner's seat's answer at `docs/trail/architecture/cycle-41.md` § 3.1 — RN-59)*.
- **Layers 6–7 are QA-role ATDD work.** No QA seat has written either for this product yet; until
  one does, layer 6 is verified by `checks/structure.sh`, `checks/entry-points.sh` and
  `checks/view.sh`, run in CI and, from `checks/gate.sh`, at the change (QC-64; through v55 "run in
  CI" alone — RN-67), and layer 7 by the SDD's per-slice command bars and the acceptance
  walk at release.

## 10. Verification map

A projection of every machine-checked entry above. When a row disagrees with its entry, the entry
is right and this row is stale.

Where a row names a `checks/<name>.sh` script that has a suite under `checks/tests/`, the suite is
named beside it as `(suite test_<name>.sh)`: the suite proves the script reads what the row says it
reads, and runs as its own step of `checks/gate.sh`, which the workflow runs through `Test gate`
(through v57 "runs as its own CI step on every build" — RN-69) — § 9's `checks/tests/` bullet is the rule, and
the one place the suites are counted (added at v15 — RN-26; the count at v17, on the owner's
seat's answer at `docs/trail/architecture/cycle-14.md` § 3.1 — RN-28; through v25 this preamble
repeated the count, and the copy went stale with § 9's — RN-37). The suite tag means the suite
proves what its script holds; it does not reach a rule the script does not hold.

*Gated at* reads by the header's rule, per rule: a row's `CI build` holds for the rules its command
already holds, and `development-design` reading the entry is the gate for the rest. Which rules a
script holds is its own header's to state — for `checks/structure.sh`, *THE SCAN TABLE* and *WHAT
IS NOT HELD* (`checks/structure.sh:L35-L93` at `ka-reader@463acb9`) — and no row here copies it
*(on the owner's seat's answer at `docs/trail/architecture/cycle-23.md` § 3.1 — RN-37)*.

**`checks/structure.sh` and its suite are gated at the change as well as the CI build.** On every
row that names them, *Runs over* adds `the change` and *Gated at* adds `development-implementation`,
and both additions are the pair's alone: every other command on a mixed row keeps the gate its row
already had. § 8 holds the rule, and the card's command carries the pair
(`kensaiapp-opensource@5be8615c`), so `development-implementation` on these rows is the run as well
as the rule *(added at v54, on the owner's answer at `docs/trail/architecture/cycle-47.md` § 3.1 —
RN-65; through v54 this paragraph said that until the card carried the pair,
`development-implementation` here was the rule and not yet the run, and the CI build the gate that
held; moved at v55, where the card moved — RN-66)*.

**`CI build` reads under § 8's paragraph on the workflow's rules.** Every row's `CI build` names the
workflow step that held the rule while Actions ran. From `kensaiapp-opensource@1941f963` the card's
command is `checks/gate.sh`, so the same command runs at every change, through the pipeline's gate
tool in the macOS guest (QC-64). So on every row `CI build` reads `development-implementation` as
well, and the workflow runs the same script when Actions does *(through v61 this read "From the
change that lands `checks/gate.sh` and puts it on the card's command, the same command runs …" and
"Until then, a row gated at `CI build` alone is held by no run while Actions is off, and its gate
is `development-design` reading the entry", true until that move — RN-73)*.
The structure pair's rows already run at the change (above). No row is rewritten for this: the rule
is stated once, in § 8 *(added at v56, on the owner's answer at `docs/trail/architecture/cycle-49.md`
§ 3.1 — RN-67)*.

| QC | Check | Command / layer | Runs over | Gated at |
|---|---|---|---|---|
| QC-1 | the shell holds no I/O of its own | `checks/view.sh` (suite `test_view.sh`); `checks/no-network.sh` (suite `test_no_network.sh`) | the tree | CI build |
| QC-2 | no write under the folder; the walk's calls against the export set | `checks/read-only.sh <fixture>` on every walk fixture (suite `test_read_only.sh`); `cargo test --locked -p ka-reader-core --test root_finding`, `--test git_state` — the three scenes whose Git directory lies outside the opened folder; `checks/structure.sh` (suite `test_structure.sh`); the walk's calls read against the build's export set, reviewed in the change that exports a command | the tree; the change | CI build; release; `development-design`; `development-implementation` (the structure pair) |
| QC-3 | no network transport — the tree equals the list; the list holds no transport; the release executable links none | `checks/no-network.sh` (suite `test_no_network.sh`); the allowlist diff reviewed against the entry's domain, in the resolved features, at `development-design`; `checks/view.sh` (suite `test_view.sh`) — `nm` on the release executable | the tree; the change | CI build; `development-design` |
| QC-4 | ItemState on every read | `cargo test --locked -p ka-reader-core` (layer 1); `swift test --package-path ka-reader-mac` (layer 4) | the change | `development-implementation` |
| QC-5 | root finding | `cargo test --locked -p ka-reader-core --test root_finding` | the change | `development-implementation` |
| QC-6 | containment check | `cargo test --locked -p ka-reader-core --test markdown`; `cargo test --locked -p ka-reader-bridge --test asset_bytes` | the change | `development-implementation` |
| QC-7 | no mutating Git call, no spawn | `checks/read-only.sh` (suite `test_read_only.sh`); `checks/structure.sh` (suite `test_structure.sh`) | the tree; the change | CI build; `development-implementation` (the structure pair) |
| QC-8 | `ka-reader-mac` imports and dependencies | `checks/view.sh` (suite `test_view.sh`); `checks/no-network.sh` (suite `test_no_network.sh`); `swift test --package-path ka-reader-mac` | the tree | CI build |
| QC-9 – QC-12, QC-14 | `ka-reader-core` / `checks/` imports; no `unsafe` outside the bridge | `checks/structure.sh` (suite `test_structure.sh`); `checks/no-network.sh` (suite `test_no_network.sh`); `cargo tree -p ka-reader-bridge`; `cargo build --workspace --locked` | the tree; the change | CI build; `development-implementation` (the structure pair) |
| QC-63 | a module of no part in `ka-reader-core` imports no part | `checks/structure.sh` (suite `test_structure.sh`) | the tree; the change | CI build; `development-implementation` (the structure pair) |
| QC-13 | `ka-reader-bridge` imports; the export set; the ABI under the sanitizer | `checks/structure.sh` (suite `test_structure.sh`); `cargo test --locked -p ka-reader-bridge --test exports`; the bridge's tests under `-Zsanitizer=address`, with `-Cllvm-args=-asan-globals=0` admitted (RN-72) | the tree; the change | CI build; `development-implementation` (the structure pair) |
| QC-15, QC-17 | I/O ownership; the two composition roots; libgit2's machine-level config search paths empty, failing closed, once per process | `checks/structure.sh` (suite `test_structure.sh`); `checks/view.sh` (suite `test_view.sh`); `cargo test --locked -p ka-reader-bridge` — the four search paths read back empty, and the switch's fail-closed and once-per-process cases | the tree; the change | CI build; `development-implementation` (the structure pair) |
| QC-16 | writes only in the container | `checks/own-state.sh` (suite `test_own_state.sh`) | the tree | CI build; release |
| QC-19 | folder replace-whole | `cargo test --locked -p ka-reader-core --test switch`; `git diff --stat … -- ka-reader-mac` | the change | `development-implementation` |
| QC-20 | own-state isolation | `checks/structure.sh` (suite `test_structure.sh`) | the tree; the change | CI build; `development-implementation` (the structure pair) |
| QC-22 | the hostile fixture as a `MarkdownDocument` | `cargo test --locked -p ka-reader-core --test markdown` | the change | `development-implementation` |
| QC-23 | no web engine | `checks/view.sh` (suite `test_view.sh`); `checks/no-network.sh` (suite `test_no_network.sh`) | the tree | CI build |
| QC-24 | the export set equals the header, inside `SM-4`'s list and `ka_reader_free` | `cargo test --locked -p ka-reader-bridge --test exports` | the tree | CI build |
| QC-25 | entitlements; sandbox present; the control's out-of-grant read on the hosted image | `checks/bundle.sh` (suite `test_bundle.sh`); `gh run view <run-id> --repo eyalgo/ka-reader --log \| awk -F'\t' '$2 == "Test gate" { if (after && /out-of-grant-read:/) print; after = /ok   test_negative_control_reports_unsandboxed$/ }'` on a commit that holds `ka-reader@8b93322`, and `awk -F'\t' '$2 == "Bundle probe suite" && /out-of-grant-read:/'` before it, whose empty read on a run whose step concluded `success` is a break from run 38577309118 on (RN-59, RN-61, RN-62, RN-69) | the tree; the CI run | CI build; release gate; `development-design` on a change that renames the workflow's `Test gate` step or the control case |
| QC-62 | the shell runs under the shipped entitlements | `checks/renderer.sh KA-Reader.app` (suite `test_renderer.sh`) and `checks/fixtures/idle-shell` | the tree | CI build; release gate |
| QC-26 | allowlist; locked build; no Swift dependency | `checks/no-network.sh` (suite `test_no_network.sh`); `cargo build --locked` | the tree | CI build |
| QC-27 | critical vulnerability | `cargo audit` (every advisory; `--ignore <RUSTSEC-id>` with its reason) | the tree | release |
| QC-28 | no secret in the history HEAD reaches; no signing identity | `checks/secret-scan.sh gitleaks git` (suite `test_secret_scan.sh`); `gh secret list --repo eyalgo/ka-reader`; `codesign -dv KA-Reader.app` | the change; the release | `development-implementation`; release |
| QC-29 | artifact = tag build | `shasum -a 256 -c SHA256SUMS` against a rebuild | the release | release |
| QC-30, QC-58 | no other entry point; no configuration — the product's own units | `checks/structure.sh` (suite `test_structure.sh`); `checks/view.sh` (suite `test_view.sh`) | the tree; the change | CI build; `development-implementation` (the structure pair) |
| QC-30, QC-58 | the linked tree's environment and argument reads — Rust names, and C `getenv`, `environ` and `_NSGetEnviron` — against the reviewed list | `checks/entry-points.sh` (suite `test_entry_points.sh`) against `checks/entry-points.allow` | the tree | CI build |
| QC-32 | empty egress set | AC-3 network monitor; `checks/no-network.sh` (suite `test_no_network.sh`) | the release; the tree | release; CI build |
| QC-34 | the shell's reach | `checks/view.sh` (suite `test_view.sh`); `checks/no-network.sh` (suite `test_no_network.sh`) | the tree | CI build |
| QC-35 | the product's reach — writes observed; the machine-level config reads switched off; the one outside path each scene names, not opened | `checks/own-state.sh` (suite `test_own_state.sh`); `checks/read-only.sh` (suite `test_read_only.sh`); `cargo test --locked -p ka-reader-bridge` — the four search paths read back empty (QC-17); `cargo test --locked -p ka-reader-core --test git_state` — the six FIFO cases | the tree | CI build |
| QC-36 | no spawned process | `checks/structure.sh` (suite `test_structure.sh`); `checks/view.sh` (suite `test_view.sh`) | the tree; the change | CI build; `development-implementation` (the structure pair) |
| QC-37 | `asset_bytes` and the decoder | `cargo test --locked -p ka-reader-bridge --test asset_bytes`; `swift test --package-path ka-reader-mac` | the change | `development-implementation` |
| QC-38 | own-state fields | `checks/own-state.sh` (suite `test_own_state.sh`) | the tree | CI build |
| QC-39, QC-52 | log shape and location | `cargo test --locked -p ka-reader-bridge` (layer 1); `checks/own-state.sh` (suite `test_own_state.sh`) | the change; the tree | `development-implementation`; CI build |
| QC-40 | log bound; own-state retention | `cargo test --locked -p ka-reader-bridge`, `cargo test --locked -p ka-reader-core` (layer 1); `checks/own-state.sh` (suite `test_own_state.sh`) after `checks/churn.sh` | the change; the tree | `development-implementation`; CI build |
| QC-41 | third-party notices | `checks/notices.sh` | the release | release |
| QC-42 | private reporting; SECURITY.md | `gh api repos/eyalgo/ka-reader/private-vulnerability-reporting` | the release | release |
| QC-44 | standing sentences verbatim | `checks/readme.sh` | the release | release |
| QC-46 | latency figures | `checks/latency.sh` | the tree | CI build |
| QC-47, QC-48 | per-item degradation; churn; the marker and the row order in the model | `cargo test --locked -p ka-reader-core --test watch` with `checks/churn.sh`; `swift test --package-path ka-reader-mac` (layer 4); QC-48's `grep` over `ka-reader-mac/Sources` prints nothing, from `follow-the-folder` | the change | `development-implementation` |
| QC-49 | promises through kill | `checks/read-only.sh --kill` (suite `test_read_only.sh`) | the tree | CI build; release |
| QC-51 | failure visible in window | `swift test --package-path ka-reader-mac` (layer 4); `checks/view.sh` (suite `test_view.sh`) | the change; the tree | `development-implementation`; CI build |
| QC-53 | no internal text | `checks/strings.sh`; layer-5 error-path tests | the tree | CI build |
| QC-55 | one bundle, one process | `checks/bundle.sh` (suite `test_bundle.sh`) | the tree | CI build |
| QC-56 | macOS floor in the bundle; CI on the floor's image label | `/usr/libexec/PlistBuddy -c 'Print :LSMinimumSystemVersion' …`; `grep -h -E '^[[:space:]]*runs-on:' .github/workflows/*.yml \| grep -v …`; `checks/tests/test_vm_refusal.sh` — `test_every_runner_names_macos_26` (RN-69, RN-70); neither reads a workflow file ending `.yaml` | the release; the tree; the change | release; `development-implementation` (the suite); `development-design` (a workflow file ending `.yaml`) reading the entry, which alone gates a workflow file ending `.yaml` |
| QC-59 | priced contract against its major's pin | `checks/contract.sh <tag>` | the release | release, from `v1.0.0` |
| QC-60 | own-state read across versions | `checks/own-state.sh --from <previous-tag>` (suite `test_own_state.sh`) | the release | release |
| QC-61 | logging facade and its implementation | `checks/no-network.sh` (suite `test_no_network.sh`); `checks/structure.sh` (suite `test_structure.sh`) | the tree; the change | CI build; `development-implementation` (the structure pair) |
| QC-64 | every workflow rule held by one script, run at the change; the workflow holds none of its own | the card's test command through the gate tool; `grep -nE '^[[:space:]]+run:' .github/workflows/ci.yml`; the suites loop over `checks/gate.sh`; `checks/tests/test_vm_refusal.sh` — `test_every_toplevel_suite_is_an_entire_fatal_step`, `test_moved_steps_are_single_line_commands_in_order` | the change; the tree | `development-implementation`; `development-design` reading the entry |
| QC-65 | the launching and home-reading steps refuse outside a virtual machine | the refusal case in each guarded script's suite, and the two guarded suites' cases in `checks/tests/test_vm_refusal.sh`; the gate tool's `Environment:` line | the change | `development-implementation` |

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
  at Draft, v1, with thirteen companion items open — `ka-reader@a50718a`, the FDR's v1 commit;
  `git show a50718a:docs/fdr_open_issues.md | grep -c '^### '` prints `13` — and v1 of this note
  said *eight*, which was the second bucket alone and false when written. Every FDR trace v1 wrote
  was to a rule or decision the FDR carried from a settled source, and none turned on an item that
  companion held; the fourteenth item, this document's own QC-60 question (`ka-reader@98df76b`), came
  back as R-168 – R-170 and PD-39 and QC-60 traces to them. The FR-13 contradiction v1 recorded —
  the Git-view row opening the diff against the SRS's row opening the file — ended at SRS v12
  (`ka-reader@5c9dda7`; `docs/fdr.md` RN-25) and was behaviour throughout. The FDR now stands Settled
  at v3 (`ka-reader@3325469`), its companion removed and its two rounds at `docs/trail/fdr/cycle-1.md`
  and `cycle-2.md`; the header's `Inputs read:` line carries the present status. Corrected on the
  owner's-seat answer at `docs/trail/architecture/cycle-1.md` § 2.8, which moved the count under
  its commit and made the note history rather than present state.
- **RN-3:** *(tools this document names where the SDD named none)* `cargo audit`,
  `pnpm audit --audit-level=critical`, `gitleaks git`, `checks/structure.sh`,
  `checks/notices.sh`, `checks/readme.sh`, `checks/strings.sh` and
  `cargo test -p ka-reader-app --test config` are this document's realizations of obligations whose
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
  (`docs/trail/architecture/cycle-1.md` § 2.2): raised on the FDR's companion (`ka-reader@98df76b`),
  confirmed by the owner's seat with the discard made silent (`docs/trail/fdr/cycle-1.md` § 2.9),
  and folded at FDR v2 as R-168 – R-170 and PD-39 (`ka-reader@0eb5c67`) — symmetric, so a downgrade
  is covered; never a startup failure, because FR-3's list is closed; silent in the window, the
  release notes carrying the statement. QC-60 keeps its check and traces to those rules; its
  verified-by gains the unreadable-container case and a layer-1 test on the reader — this
  document's realization of R-168 and R-169, the way RN-4 extends C-I3 — and the
  crash-mid-write of own-state that QC-49's kill can produce is exactly the case its
  discard-whole clause exists for. *(re: QC-59, QC-60; source: SRS C-6, DR-5, FR-3; FDR PD-20,
  R-168 – R-170, PD-39; `docs/trail/architecture/cycle-1.md` § 2.1, § 2.2)*
- **RN-6:** *(the project card — history, pinned by commit)* At v1 and v2
  `system/projects/ka-reader/project.md` carried a provisional `pytest tests/` test command and no
  `Languages:` line (`kensaiapp-opensource@4bdfddd`, the card as it stood when v2 read it), while
  the SDD's command bar was `cargo test --workspace` and the units Rust and TypeScript; § 8 pointed
  at the card as the template requires and named the disagreement. The card has moved four times
  since, each pinned. The test command became
  `cargo test --workspace && (cd ka-reader-ui && pnpm exec vitest run)` — the SDD's S-1 bar for the
  Rust workspace and Vitest for `ka-reader-ui`, one gate over the two toolchains ADR-0009 fixes
  (`kensaiapp-opensource@c2155cc`, 2026-09-01). The card declared
  `Languages: Rust, TypeScript, Shell` (`kensaiapp-opensource@0af5fb9`, 2026-09-02). Its
  `Languages:` comment stopped saying Rust had no packet (`kensaiapp-opensource@ff43026`,
  2026-09-02) — the fact v3's fold could not reach and left for the owner, closed in the managing
  instance. And the test command took the Rust packet's `--locked`, a `cto:` run's field
  (`kensaiapp-opensource@3a960a7`, 2026-09-02), so it reads
  `cargo test --workspace --locked && (cd ka-reader-ui && pnpm exec vitest run)`. § 8 states the card
  as it reads at the last of those commits, and goes false at the card's next move until this note
  is extended — the accepted cost of a live sentence with its pinned history beside it, the shape
  the owner's seat confirmed for RN-2 and again here (`docs/trail/architecture/cycle-2.md` § 2.2,
  § 2.3). Three moves since, the first pinned at v12 and the last two at v13 (RN-23, RN-24): the
  card gained `Language roots:` (`kensaiapp-opensource@defe740`, 2026-09-23), touching neither
  line § 8 states; Swift replaced TypeScript on the `Languages:` line, in the test command — now
  `cargo test --workspace --locked && swift test --package-path ka-reader-mac` — and on `Language
  roots:` (`kensaiapp-opensource@5b27023`, 2026-09-23); and the `Languages:` comment named
  Swift's packet (`kensaiapp-opensource@ec80077`, 2026-09-23). § 8 states the card as it reads at
  the last of these. One move since, pinned at v52 (RN-63): `product-card` re-derived the test
  command so it assembles the bridge before its Swift half, and it now reads
  `cargo test --workspace --locked && ka-reader-mac/assemble.sh && swift test --package-path
  ka-reader-mac` (`kensaiapp-opensource@d5005730`, 2026-10-14). That is the move § 8 named as owed
  at v49 (RN-60). Two moves since, pinned at v55 (RN-66): the test command gained the structure
  pair after its Swift half, and now reads `cargo test --workspace --locked &&
  ka-reader-mac/assemble.sh && swift test --package-path ka-reader-mac && checks/structure.sh &&
  checks/tests/test_structure.sh` (`kensaiapp-opensource@5be8615c`, 2026-10-16) — the move § 8
  named as owed at v54 (RN-65); and the command's comment stopped saying the `checks/*.sh` harness
  stays out of the field (`kensaiapp-opensource@a4204e5b`, 2026-10-16). § 8 states the card as it
  reads at the last of these. Two moves since, pinned at v62 (RN-73): the test command became
  `checks/gate.sh`, QC-64's one script (`kensaiapp-opensource@1941f963`, 2026-10-20) — the move
  § 8's *Until the card runs the script* named as owed (RN-69); and the command's comment came to
  describe the script (`kensaiapp-opensource@85264c69`, 2026-10-20). § 8 states the card as it
  reads at the last of these. *(re: § 8; source: SDD § 6 S-1; ADR-0009;
  ADR-0016; `languages/rust/testing.md` v1.0.0; the thirteen
  commits named)*
- **RN-7:** *(language packets — re-derived at v3)* Both packets resolve at step 1 of
  `languages/README.md` § The resolution chain, from the card's `Languages:` line (RN-6): the
  renderer to the TypeScript packet *(history since the card's `kensaiapp-opensource@5b27023`,
  2026-09-23 — `ka-reader-mac` resolves from the same line, at the same step, to the Swift packet,
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
  `cargo test --locked -p ka-reader-core` and `cargo test --locked -p ka-reader-app` — layers 1–3 across
  the two crates ADR-0009 fixes — and is this product's *change-time* run, which the project card's
  per-task field carries (RN-6), where the packet classifies the workspace form as release-time for
  the one reason it states: that layer 5 lives in the binary crate's `tests/<flow>.rs` and the
  workspace run includes it (`languages/rust/testing.md` § Layers 1–5). `testing_doctrine.md`'s
  "Layer 5 runs separately" is met by the harness running outside the per-task gate, not by a
  crate selector. The condition that would flip it is named and checked: a
  `crates/ka-reader-app/tests/<flow>.rs` that starts the built binary through `CARGO_BIN_EXE_*` would
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
  `crates/ka-reader-core/tests/`, `crates/ka-reader-app/tests/` — the owner's ruling for every Rust
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
  `companion-self-answer` run (`docs/trail/architecture/self_answer-1.md`, `ka-reader@a44a19e`), one
  more by a second (`self_answer-2.md`, `ka-reader@357190e`). § 1.1 → QC-27 (no window; the SRS bar
  C-13 outranks the floor). § 1.2 → QC-40 takes the number the SRS folded at v9 (`ka-reader@82c199a`,
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
  wrote "a remembered folder until its entry is removed", true of the FDR at v1 (`ka-reader@a50718a`)
  and false at v3: R-178 – R-182 (`ka-reader@0eb5c67`) and R-110 as re-worded at v3 (`ka-reader@3325469`)
  state that no control removes an entry, the list changes only by viewing a folder, and an
  aged-out entry is not restored. A settled entry changes on a new upstream sentence, and the FDR is
  upstream of this document; QC-40 now states the FDR's rule and traces to it — transcription, not
  a call. **ADR-0003 and ADR-0005.** Each record's § Consequences says the Git view presents the
  outside-the-grant case "as a failure naming the folder to choose", citing `docs/fdr.md` R-21 —
  the FDR's v1 text (`ka-reader@a50718a:docs/fdr.md`, R-21). The owner's seat overrode R-21 at v2
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
  commit. `docs/SRS.md` v8 → v12: NFR-11 and AC-13 gained the log's bound at v9 (`ka-reader@82c199a`)
  — QC-40 carries it; FR-13, AC-6 and AC-12 took the Git-view row's two readings at v12
  (`ka-reader@5c9dda7`) — behaviour, no entry moves, RN-2 records the close; RN-35's clause closed at
  v10 and 80 trail pointers were repaired at v9 — nothing here cites a repaired path.
  `docs/SDD.md` v2 → v3 (`ka-reader@5c776aa`): C-R6 reads `pnpm ls` where it read `npm ls` — QC-3 and
  QC-26 already realized the clause as pnpm, so nothing moves; § 12 and RN-6 – RN-8 name ADR-0001,
  ADR-0002 and ADR-0004; 40 trail pointers repaired. `docs/fdr.md` v1 → v3 (`ka-reader@0eb5c67`,
  `ka-reader@3325469`), now Settled: R-168 – R-170 and PD-39 — QC-60; R-178 – R-182 and R-110 —
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
  (`ka-reader@1329741`). With no companion on disk a
  `product-architecture` re-run reads both records as done, so the companion was re-opened by an
  owner-directed session (`ka-reader@5003906`) with two drafts and one question, and this run — the
  first `product-architecture` run after it — is what applied the drafts: § 2.1 → § 9's preamble,
  § 9's two Rust paths and RN-7; § 2.2 → RN-6 and § 8's preamble. Neither is confirmed: the
  companion's slots are unfilled, so nothing was folded and no trail cycle is written; the items
  stay, now describing edits that are in the document rather than proposed for it, and `Status:`
  reads Draft. The seven inputs did not move: `git diff --stat 1329741 HEAD` over them prints
  nothing (2026-09-02), so the `Inputs read:` line stands. **What waits on the open question.** The
  Rust packet requires the binary crate to select a logging facade and initialize it once, early,
  and leaves the choice — `log` or `tracing` — to this document
  (`languages/rust/errors_logging.md` § Logging, § Which facade; the owner's relaxation of the
  packet's first shape, `kensaiapp-dev@819f6708`). `ka-reader-app` is that crate and the composition
  root (ADR-0009 § Decision). No entry names a facade, and none is false for it: QC-39 and QC-52
  bind the log's line shape and location and QC-40 its bound, and each holds under either. What the
  choice moves when made: `checks/deps.allow` gains the facade crate and its implementation — a
  reviewed allowlist change either way (QC-3, QC-26) — and the entry recording the choice lands
  under § 7 beside QC-52, because the packet makes recording it an obligation of this document
  ("Recording it is the part that is not optional", same section) and a facade a change could
  swap silently is a constraint by lifecycle. Two architects reading the same SDD could answer
  differently — the packet's discriminator is whether diagnostics are queried by field or read as
  lines — so it is routed, not derived. **No record moves.** ADR-0009 names `ka-reader-core` and
  `ka-reader-app` by name and fixes no directory: the `crates/` placement is a layout fact under it,
  not a reversal of it, and ADR-0002's *two languages* and ADR-0009's *two toolchains* stay true.
  *(re: header `Status:`, `Version:`; § 8, § 9, RN-6, RN-7; source:
  `docs/architecture_open_issues.md` § 1.1, § 2.1, § 2.2; `languages/rust/errors_logging.md`
  v1.1.0; ADR-0009; the commits named)*
- **RN-15:** *(v4 — the close of the re-opened companion; what moved, and on whose authority)* The
  companion re-opened at `ka-reader@5003906` was answered in the owner's seat by two
  `companion-self-answer` runs — three items (`docs/trail/architecture/self_answer-3.md`,
  `ka-reader@5b285e4`), then two more raised by an owner-directed session (`ka-reader@b55a6d4`) and
  answered (`self_answer-4.md`, `ka-reader@6415c46`) — and as answered is
  `docs/trail/architecture/cycle-2.md`. **§ 1.1 → QC-61:** `log`, the product's own `log::Log`
  writer installed once in `ka-reader-app`, no third-party implementation. Two things the entry does
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
  authorizations, kept apart. **The owner's answer.** The companion re-opened at `ka-reader@20b9a94`
  by a `companion-self-answer` run — to carry one finding the SDD's re-author raised (its RN-34),
  no authoring run having written it — was answered by the owner through a `companion-answer` walk
  (`ka-reader@07a6b74`) and as answered is `docs/trail/architecture/cycle-3.md`. § 3.1 → the 37
  citations in ADR-0001 – ADR-0008 of the deleted SDD's trail and review notes are pinned: the 14
  of `docs/trail/sdd/cycle-1.md` read `ka-reader@70a879a:docs/trail/sdd/cycle-1.md`, the 23 of
  `docs/SDD.md` § SDD Review Notes RN-n read `ka-reader@70a879a:docs/SDD.md` § SDD Review Notes RN-n
  — `70a879a` being the last commit that touched the SDD before `ka-reader@9c91359` deleted it, and
  carrying RN-1 – RN-34, RN-24 and RN-25 included (`git log 70a879a..9c91359 -- docs/SDD.md`
  returns the deletion alone; re-measured 2026-09-04). Where a review-note citation shared a
  backticked path with section references that still resolve, the pinned path is placed on the
  review-note citation alone and the section references keep the live path — the `## Traces to`
  bullets of ADR-0003, ADR-0004, ADR-0006 and ADR-0008 move the review-note citation to the
  bullet's end for it. Prose edits on the owner's ruling that a citation repair reverses no
  decision: no record's Status, date, decision, alternative or consequence moved, no superseding
  record is written, and ADR-0009 and the index are untouched. And QC-48's `SDD § 6 S-4` reads
  `S-5`, the re-authored SDD's `follow-the-folder`. **The upstream that moved.** The SDD every
  earlier revision read (v1 – v4: `ka-reader@70a879a` and before) was deleted at `ka-reader@9c91359` on
  2026-09-03 and re-authored from the PRD, SRS and UXD as they stand — v1 at `ka-reader@c3eb937`,
  Settled at v3 at `ka-reader@827aa1c` on 2026-09-04 (`git diff --stat 7cdc857 HEAD` over the seven
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
  satisfies" was true of the SDD v4 read and is history at `ka-reader@70a879a`. Nothing else in § 1
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
  run wrote at `ka-reader@41d8c9f`, answered as `docs/trail/architecture/cycle-4.md`: § 2.1 in the
  owner's seat by a `companion-self-answer` run (`self_answer-6.md`, `ka-reader@f60bc3f`), § 1.1 by
  the owner in a `companion-answer` walk (`ka-reader@e54f920`). **§ 2.1 → fourteen pins.** The thirteen citations
  the item counted, each measured this run at the line it names and each landing on another subject
  in `docs/SDD.md` v5 as it did in v3, read `ka-reader@70a879a:docs/SDD.md` § …: ADR-0002's `§ 9 TO-1,
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
  (`ka-reader@683db69`, `ka-reader@67372a5`; `git diff --stat 827aa1c HEAD -- docs/SDD.md`: 158 lines,
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
  (`ka-reader@2cd990f`, `4a73c1a`, `356b531`), read whole. (5) PD-40, added at FDR v4 and widened at v5
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
  run, and `docs/fdr.md` RN-28 (*What is pinned to `ka-reader@70a879a:docs/SDD.md`*) is its record. Nothing else the FDR added — R-146 – R-182, PD-40's siblings — moves
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
  them as done; the PM opened it on 2026-09-19 from a post-build review (`ka-reader@d9cbefc`) with
  three items, all raised from downstream and none drafted. All three were answered in the owner's
  seat by one `companion-self-answer` run (`ka-reader@0f4eab3`; its reasoning,
  `docs/trail/architecture/self_answer-8.md`) and as answered the companion is
  `docs/trail/architecture/cycle-5.md`. Every change below names the answer that authorizes it,
  and what this run added beyond an answer's words is marked as this run's own. **§ 3.1 → QC-25,
  and one record.** `docs/SDD.md` moved v5 → v6 (`ka-reader@b3439e8`): § 4 C-I3 states a new
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
  (`ka-reader@ccb58d8`, v1.0.0) still reads the marker, so QC-25 as it now reads is red against the
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
  (`ka-reader@a4ab8e6:crates/ka-reader-app/tests/config.rs:L17`, `:L181-L188`;
  `ka-reader@a4ab8e6:crates/ka-reader-app/tauri.conf.json:L12`), opened this run.
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
  or re-resolved: `cargo tree -p ka-reader-app --target aarch64-apple-darwin -e normal --locked
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
  and the PM opened one on 2026-09-19 from a post-build review (`ka-reader@07beb5b`, `ka-reader@422f6d1`)
  with two items, both raised from downstream and each carrying a lean. Both were answered in the
  owner's seat by one unattended `companion-self-answer` run, not by the owner in person
  (`ka-reader@bf99e8e`; its reasoning, `docs/trail/architecture/self_answer-9.md`), and as answered
  the companion is `docs/trail/architecture/cycle-6.md`. Every change below names the answer that
  authorizes it, and what this run added beyond an answer's words is marked as this run's own.
  **§ 3.1 → QC-24.** `docs/SDD.md` moved v6 → v7 (`ka-reader@c1f8a20`): § 4 C-R7 states the staged
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
  constants (`crates/ka-reader-app/tests/config.rs:L228`, `:L231`, opened this run at
  `ka-reader@bf99e8e`), and the capability file grants `allow-open-folder` and `allow-list-tree`
  (`crates/ka-reader-app/capabilities/main.json:L5`). The test is green today and does not yet meet
  the re-derived tail. That is the correct reading, not a defect of this revision — the entry
  follows the SDD, and the test follows the entry. How the test comes to read the registered set is
  the delivery tier's to plan (`docs/SDD.md` RN-47); if it finds no way to read it, that comes back
  here as a raised item and is not settled inside a change. **§ 3.2 → QC-61 and § 9.** QC-61's
  rule said `log::set_logger` appears "only in `ka-reader-app`" and stated no scope, and the tree
  holds `crates/ka-reader-core/tests/failure_log.rs:L52` and `failure_log_kinds.rs:L61`, each
  installing a capturing logger in its own test binary to assert on `ka-reader-core`'s warn line —
  the only way a test can observe one, since `set_logger` "may only be called once in the lifetime
  of a program" (https://docs.rs/log/latest/log/fn.set_logger.html). That sentence and the Cargo
  reference's "as a separate crate" were both re-read at source this fold, 2026-09-19, rather than
  transcribed from the answer. The check overreached the property, which is about the shipped process; narrowing
  it relaxes nothing the property protects — the one shipped site is
  `ka-reader@a4ab8e6:crates/ka-reader-app/src/log_writer.rs:L142` and `crates/ka-reader-core/src/` holds none (`grep -rn
  'set_logger\|set_boxed_logger' crates/`, run this fold). **The answer's addition, folded as
  written:** the same script carries rules against which the tree holds a test-target site each —
  QC-2's write rule (`crates/ka-reader-core/tests/common/mod.rs:L57`), QC-7's and QC-9's
  `std::process` (`…/common/mod.rs:L11`), QC-13's `std::fs` (`ka-reader@a4ab8e6:crates/ka-reader-app/tests/config.rs:L11`,
  the very test QC-23, QC-24 and QC-36 name) and QC-30's `std::env::args`
  (`crates/ka-reader-core/tests/walk.rs:L66`, the driver `checks/read-only.sh` runs) — every one
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
  fold, and breaks nothing:** `ka-reader@a4ab8e6:crates/ka-reader-app/src/log_writer.rs:L201` calls `fs::write` inside
  `src/`. It sits in `ka-reader-app`'s log module, which QC-13 admits by name, and QC-2's write rule
  names `ka-reader-core`; so the scope's first not-covered case stays undecided, as the answer left
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
  (`ka-reader@b91ba55`; its reasoning, `docs/trail/architecture/self_answer-10.md`), and as answered
  the companion is `docs/trail/architecture/cycle-7.md`. Every change below names the answer that
  authorizes it, and what this run added beyond an answer's words is marked as this run's own.
  **§ 3.1 → QC-3 and its § 10 row.** The defect: QC-3 states a domain — no shipped unit links a
  network transport — and was verified by a diff of the tree against `checks/deps.allow`, which
  proves the two agree and cannot fail on a name the list admits. Measured on the answer's own
  case and re-run this fold at `ka-reader@b91ba55`: `bash checks/no-network.sh` exits 0 while
  `checks/deps.allow:L51` holds `crypto-common` and `:L204` holds `tokio`. The tail now states two
  halves, the second being QC-26's same-change review told what question to ask — each added
  name judged against QC-3's domain in the features the lockfile resolves — which is what
  `docs/SDD.md` § 4 C-R6 already says: the allowlist change "is reviewed in the same change", and
  "no shipped unit links a network transport". A correction, not a widening, by this document's
  own preamble: an entry with no nameable verification is not yet an entry, and the domain half
  had none. The features clause is the answer's, on the ground that a name cannot answer the
  question — `tokio` is on the list and at `ka-reader@9b36a42` resolves no `net` feature — and that
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
  in place.** `docs/SDD.md` moved v7 → v8 (`ka-reader@9b36a42`): § 4 C-I3 states the bounded window
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
  the printed bound, the whole-window control and the per-ask existence check (`ka-reader@cf539a4`;
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
  the log has taken corrections of this kind before — the citation pins of v5 (`ka-reader@41d8c9f`,
  eight accepted records) and v6 (`ka-reader@00c1bc9`, six) — so this fold follows the ruling and
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
  2026-09-23 (`ka-reader@a9f1b8a`; its reasoning, `docs/trail/sdd/self_answer-19.md`) with one § 2
  item, proposed and not drafted, on the ground the SDD itself gives: § 12 and § 10 RC-2 name
  QC-25's *exactly* and ADR-0003's as the Principal Architect's to bring into line, and route it
  nowhere. This run — the first `product-architecture` run after it — is what drafted the item. Its
  slot is unfilled, so nothing is folded, no trail cycle is written, and `Status:` reads Draft; the
  item now describes edits that are in the records rather than proposed for them, the shape RN-14
  records for v3. **What moved beneath this document, and what did not.** `git diff 42bd7b5..HEAD
  --stat -- docs/` — `42bd7b5` being v9's own commit — names `docs/SDD.md`, the two companions and
  `docs/trail/sdd/` and nothing else (2026-09-23), so the SRS, the FDR, the PRD, the UXD, DESIGN and
  CONTENT are byte-for-byte what v9 read whole and were not re-read whole; each one's `Status:` line
  was re-read this run. The SDD moved v8 → v12 (`ka-reader@e7b2bcd`, `ba63b44`, `6ebdc42`; 556 lines
  in and 44 out), read whole as a diff and every passage cited here opened: the header, § 1's
  read-only bullet, § 2 row 4, § 4 C-R2 and C-I3, § 5 step 4 E-1, § 6 S-1, § 10 RC-1 and RC-2,
  § 12, RN-49 – RN-58, Open Questions. Two subjects: the form of the wall, and the renderer that
  cannot start under it; QC-25 and a new entry follow, and the `Inputs read:` line reads the SDD
  Draft — its companion holds three answered items awaiting a `product-sdd` fold at
  `ka-reader@a1d8f2c`. Which entries turn on the Draft, stated per the rule that the header names the
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
  bound and the control's whole-window rule since `ka-reader@cf539a4` — so QC-25 is green against the
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
  renderer leaves WKWebView (`ka-reader@5176475`) — an authorized decision that outranks every
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
  `ka-reader@a1d8f2c`; `docs/trail/sdd/self_answer-19.md`, `self_answer-20.md`;
  `checks/bundle.sh:L73`, `:L127-L187`; `docs/fdr.md` PD-29; the commits named)*

- **RN-22:** *(v11 — the cycle-8 fold, and the SDD's re-cut of the shape beneath a settled
  document: what is folded, what is drafted for the owner, and what this run added of its own)*
  **The fold.** The companion at intake (`docs/architecture_open_issues.md` at `ka-reader@c2cb01c`)
  held two answered items and one unanswered, and as answered is
  `docs/trail/architecture/cycle-8.md`; both answers were given in the owner's seat by a
  `companion-self-answer` run (`ka-reader@c5a2e76`; its reasoning,
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
  (`docs/trail/sdd/cycle-9.md` § 2.3, the owner's addition, `ka-reader@18ad26d`) — and it has moved:
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
  (`docs/trail/fdr/cycle-5.md` § 2.1; `ka-reader@5003426`), which is what QC-21's re-derivation
  waited on (RN-21). **What moved beneath this document, and what did not.** `git diff --stat
  bd98225..HEAD -- docs/` — `bd98225` being v10's own commit — names `docs/SDD.md` (run 12,
  `ka-reader@b236e7b`, v12 → v13), `docs/fdr.md` (v6 → v8, `ka-reader@be1a821`, `ka-reader@5003426`), the
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
  supersedes ADR-0006), ADR-0016 (the unit set — `ka-reader-core`, `ka-reader-bridge`, `ka-reader-mac`,
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
  opening paragraph; QC-1 (the shell holds no I/O — a scan, not a boundary); QC-8 (`ka-reader-mac`'s
  imports, no package dependency, `surfaces` never calling `SM-4`); QC-9 (no Apple framework, no
  `unsafe` in the core); QC-11 (`highlighter` among the parts, the second stated edge); QC-13
  (`ka-reader-bridge`: delegation, `unsafe`, the generated header, the sanitizer); QC-14, QC-15,
  QC-16, QC-17 (two composition roots); QC-18, QC-19 (the S-10 diff over `ka-reader-mac`), QC-20;
  QC-21 (the non-invariant re-stated on PD-29 at v8); § 2's boundaries and threat classes; QC-22
  (the hostile fixture as a `MarkdownDocument`); QC-23 (no web engine, in place of a CSP the shape
  cannot declare); QC-24 (the bridge's export set, in place of the capability file — the staged
  form RN-19 fixed carried across unchanged in kind); QC-26 (no Swift dependency, no
  `Package.resolved`); QC-27 (`pnpm audit` leaves); QC-30 (`-p ka-reader-bridge`; the shell in
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
  scan does not name (QC-30 half (1)); (2) a `view.sh` rule that a `ka_reader_` symbol is called
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
  reverses ADR-0010's decision — the harness through `ka-reader-core` in-process, the probe on every
  build reading the operating system's report — and C-I3 still names ADR-0010 as its record. RN-3's
  tool list names `cargo test -p ka-reader-app --test config`, a test the shape retires with
  `tauri.conf.json` and the capability file; the note is dated history and stands. RN-7's "Layer 4
  is present, on Vitest Browser Mode with Playwright" and its TypeScript-packet clauses are history
  as of this revision, and the departure list stands for the Rust packet as written. The doctrine
  cites move under no answer: `languages/rust/testing.md` reads v1.0.1 and `toolchain.md` v1.1.1
  (each read whole this run, 2026-09-23; neither moved a layer or a rule this document cites), and
  the TypeScript packet leaves the citing paragraph with `ka-reader-ui`. **One item is raised,
  companion § 1.1, and one entry names it rather than deciding it:** `docs/SDD.md` § 3 at v13 has
  `folder-model` own `FileView` — whose content carries `highlighter`'s spans or a
  `MarkdownDocument` — and `core-bridge` "must not own read logic — every function delegates and
  formats", while `folder-model`'s "Must not own" still lists "Rendering" and QC-10 forbids
  `folder-model` importing `markdown-renderer`; which unit invokes `markdown-renderer` and
  `highlighter` is stated nowhere, and two architects reading the same section would place it
  differently, so it is routed to the SDD's seat through the companion and QC-10 stands as written
  with the gap named. **Seen and not raised, each the SDD's to move at its next run:** `folder-model`'s
  "Must not own" still names "The Tauri runtime" (§ 3, the parts table); RN-8 still says SVG would
  be "served on the same `ka-reader-asset` scheme", a mechanism RC-3 retired, while C-D3 carries the
  current reopening condition; and S-3's command half tests `asset_bytes` under `cargo test -p
  ka-reader-core --test markdown` where § 3 places `asset_bytes` in `core-bridge` — QC-37 cites the
  command as the SDD states it. **Owed outside this document, named so the fold is not read as
  complete:** the project card's `Languages:` line and test command (§ 8; SDD RN-60);
  `README.md:L46-L51`'s stack and proof sentences (SDD RN-59); `docs/DESIGN.md`'s realisation
  sentence (SDD RN-62). **The tree.** `crates/ka-reader-app`, `ka-reader-ui` and `checks/` as v10 read
  them (`ls`, 2026-09-23; no `ka-reader-mac`, no `crates/ka-reader-bridge`, no `checks/view.sh`,
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
  `ka-reader@cddc286`) held two items, both answered in the owner's seat by a `companion-self-answer`
  run (its reasoning, `docs/trail/architecture/self_answer-12.md`), and as answered is
  `docs/trail/architecture/cycle-9.md`. **§ 2.3 → ADR-0013, ADR-0014, ADR-0015 and ADR-0016
  Accepted, superseding ADR-0001, ADR-0002, ADR-0006 and ADR-0009;** each superseded record's
  Status line reads `Superseded by ADR-00NN` and no other line of it moved; **ADR-0012 Accepted**;
  the index follows. Before acceptance, while still Proposed, each of the five took one edit the
  run owns: its § Traces to bullet names the trail cycle and the confirm in place of the live
  companion, and reads the SDD at v14 for the acceptance — v14's one move in § 3 (below) sits
  inside `ka-reader-core` and touches no sentence of the four; and the four superseding records'
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
  companion (`ka-reader@705d306`; `docs/trail/sdd/self_answer-22.md` § 2.4) with one addition and the
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
  `ka-reader-core` under either reading. **What moved beneath this document.** `git diff --stat
  38aaa48..HEAD -- docs/` — `38aaa48` being v11's own commit — names `docs/SDD.md` (run 13,
  `ka-reader@2739007`, v13 → v14), the two companions and the trails, and nothing else (2026-09-23);
  the SRS (v12), the FDR (v8), the PRD, the UXD, DESIGN and CONTENT are what v11 read, every one
  Settled, so the `Inputs read:` line stands, the SDD Draft — its companion holds § 2.4 answered,
  awaiting `product-sdd`. The SDD's v14 moves, each opened: § 3 `folder-model` and the units
  edge (QC-10, above); § 4 C-R2's and C-I3's record lines, which name their record and state no
  status word — nothing here cites a status word from the SDD, so nothing moves; § 6 S-3's
  command half, which tests `asset_bytes` under `cargo test --locked -p ka-reader-bridge --test
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
  `crates/ka-reader-app`, `ka-reader-ui` and `checks/` as v11 read them (`ls`, 2026-09-23), so every
  entry naming the new units is red against it until the change that lands the native shell
  (§ 1). No `QC` is added, renumbered or reused; no accepted record is edited beyond the four
  Status lines; nothing is left for the owner, `docs/architecture_open_issues.md` is removed and
  `Status:` is Settled *(re: header `Status:`, `Version:`; § 1 opening; QC-2, QC-6, QC-10, QC-11,
  QC-16, QC-21, QC-30, QC-31, QC-37, QC-62 and the trace tags listed; § 8; § 9 row 2 and the
  layer-5 bullet; § 10 rows QC-6, QC-37; RN-22's count; ADR-0001, ADR-0002, ADR-0006, ADR-0009,
  ADR-0012 – ADR-0016, the index; source: `docs/trail/architecture/cycle-9.md` §§ 1.1, 2.3;
  `docs/trail/architecture/self_answer-12.md`; `docs/SDD.md` v14 — § 3 `folder-model`,
  `core-bridge`, the units paragraph, SM-5, SM-7; § 4 C-R2, C-I3; § 6 S-3; § 12; RN-64;
  `docs/trail/sdd/cycle-10.md` § 2.3; `docs/trail/sdd/self_answer-22.md` § 2.4; `ka-reader@705d306`;
  `kensaiapp-opensource@defe740`; the commits named)*
- **RN-24:** *(v13 — the close of the cycle-10 companion: one entry the SDD's fold left behind,
  and four things the built native shell and the moved card showed the records state wrong)*
  **How the companion came to exist.** As at RN-18 – RN-21, no `product-architecture` run opened
  it: both records were Settled at v12 with no companion on disk. The PM opened it on 2026-09-23
  after the native shell landed (`ka-reader@196a505`) with four items raised from downstream —
  §§ 3.1 – 3.4 — and a `companion-self-answer` run answering the SDD's own companion added § 2.1
  the same day (`ka-reader@a8b662e`), drafted and not written into any record. All five were
  answered in the owner's seat by one unattended `companion-self-answer` run, not by the owner in
  person (`ka-reader@5c4bd9a`; its reasoning, `docs/trail/architecture/self_answer-13.md`), and as
  answered the companion is `docs/trail/architecture/cycle-10.md`. Every change below names the
  answer that authorizes it, and what this run added beyond an answer's words is marked as this
  run's own. **§ 2.1 → QC-24, QC-1, QC-2, QC-59 and § 10.** `docs/SDD.md` moved v14 → v16
  beneath this document (`ka-reader@1f4961a`, `ka-reader@097ef33`; `git diff 1dfdd86..HEAD --stat --
  docs/SDD.md`: 197 lines, read whole as a diff and every passage cited here opened). At v16 § 4
  C-R7 holds the export set inside `SM-4`'s list *and* `ka_reader_free`, from `v1.0.0` the list
  whole and `ka_reader_free`, states that `ka_reader_free` is no command and admits no second plumbing
  export until the slice that needs one raises it; `SM-4`'s Down cell names `ka_reader_free` beside
  the list and not on it; C-I3's *Violated by* carries the command parenthesis; C-I6's pin takes
  the same set; S-1's and S-11's command halves follow (SDD RN-66, on the owner's confirm at
  `docs/trail/sdd/cycle-12.md` § 5.1). QC-24 is re-derived from C-R7 at v16 under that document's
  own rule that the § 4 statement wins — transcription, not a call — and the defect it closes is
  measured: the bridge on `main` exports `ka_reader_free` (`crates/ka-reader-bridge/src/exports.rs:L61`)
  and its test admits it (`crates/ka-reader-bridge/tests/exports.rs:L17`), which QC-24 as it read
  refused. The answer's four additions, folded as written: QC-2's tail, whose "every function the
  build exports" reached `ka_reader_free` on its own words where the drafted item claimed it did not,
  takes C-I3's carve-out — a command is a call on `SM-4`'s list, driven through `SM-5`, and
  `ka_reader_free` never reaches the model; QC-1's "only channel to the core" names `ka_reader_free`
  beside the list, as `SM-4`'s Down cell does; QC-59's pin reads the list and `ka_reader_free`, as
  C-I6 does; QC-24's trace reads C-R7 at v16. QC-30 does not move — its boundary set is what the
  process reads, and `ka_reader_free` reads nothing, the SDD's own ground for placing it beside the
  list. **Two things here are this run's own.** (1) QC-24 carries C-R7's no-second-export
  sentence in the obligation, not only in the trace: a later plumbing export would pass the
  tail's set equality while sitting outside the held set, which is the stale case C-R7 names, and
  an entry that binds the set has to say what a second export means. (2) QC-24's trace gains
  ADR-0016, whose units table already names `ka_reader_free` apart from the list (§ Decision, the
  `ka-reader-bridge` row) — the record said it before the entry did, and the pair was navigable one
  way only. No record moves: ADR-0013 names `ka_reader_free` after the nine and ADR-0016 lists it
  separately, so the log already held what the entry now holds. **§ 3.1 → QC-13.** The item's
  framing was partly wrong and the answer says so: QC-13 did not leave open whether "may import"
  is the whole list — § 1.2's preamble says it is — so under the one reading available the bridge
  as built breaks the entry (`crates/ka-reader-bridge/Cargo.toml` declares `log`, `serde`,
  `serde_json` and `libc` beside `ka-reader-core`, each on `checks/deps.allow`), and QC-13 read that
  way contradicts QC-61, which requires every shipped Rust crate to depend on `log`. A correction
  of two settled entries that disagree, not a widening. Of the lean's two forms the answer chose
  *points at the list*, QC-9's form for `ka-reader-core`, on the ground that four names in the entry
  would be a hand-kept copy of the manifest, false at the bridge's next reviewed dependency; every
  other clause stands. **One thing here is this run's own:** the tail's sentence that the
  allowlist admits a crate to the workspace and not to a purpose, so a listed parser or grammar
  engine imported to put read logic in the bridge is the delegation review's catch — the answer
  named the review as the catch, and the tail says why the list alone cannot be. **§ 3.2 → § 9's
  scope bullet.** The tree holds a build script — `crates/ka-reader-bridge/build.rs` reads and writes
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
  `cargo test --workspace --locked && swift test --package-path ka-reader-mac` and `Languages: Rust,
  Swift, Shell` (`system/projects/ka-reader/project.md:L7-L8`, in the managing instance). The
  answer's addition: the card moved twice since `defe740`, not once — `kensaiapp-opensource@5b27023`
  and `ec80077`, both 2026-09-23 (`git log -- system/projects/ka-reader/project.md`) — so RN-6's
  pinned history gains both and § 8 pins `ec80077`, the commit the fold read; the *owed a move*
  sentence is gone because the move happened. Decided with § 3.4: RN-7's step-1 sentence naming
  the TypeScript packet for the renderer takes a dated parenthesis and is history. **§ 3.4 → § 9,
  RN-7 and ADR-0016.** The premise is false: the registry carries `languages/swift/` since
  `kensaiapp-dev@3ab2e8553` (18:46 on 2026-09-23, merged; each file read whole this fold at the
  version § 9 cites), and `docs/nfdr.md` § 9 and ADR-0016 said none existed — true at 15:13 the
  same day, when v12 closed and the record was accepted (`ka-reader@1dfdd86`), and false three hours
  later. § 9's preamble reads the packet as `ka-reader-mac`'s tooling, resolving at step 1 from the
  card's line as the Rust packet does, and its previous reading is marked as history. **Where
  `ka-reader-mac` stands against the Swift packet, one verdict per point, each the answer's and each
  stated in § 9's new bullet.** *(1) Framework — followed, not a departure.* The item's supporting
  text was partly wrong and the answer reports it: the packet keeps a product's existing XCTest
  tests — "XCTest tests a product already has stay as they are" (`testing.md` § One framework) —
  and only a new test is Swift Testing; the four test files on `main` are XCTest (`grep -rl
  'import XCTest' ka-reader-mac/Tests`, run this fold, and no `import Testing`). Whether the toolchain
  CI builds with runs Swift Testing is not known; the change that writes the first new test finds
  out, and § 9 records a departure with the measurement if it cannot. *(2), (3) and (5) — departed
  from, as one decision, with the flip named.* The `6.2` tools version, the `.binaryTarget`
  artifact bundle and `.treatAllWarnings(as:)` each need `PackageDescription` 6.2 — the packet
  states it of the manifest settings ("First available in PackageDescription 6.2", `toolchain.md`
  § Toolchain version) and of the artifact route (SE-0482, "Implemented (Swift 6.2)", § Linking a
  C library built by another toolchain), and `ka-reader-mac/Package.swift` declares `5.9` (`:L1`),
  links the bridge as a system library with a `-L` flag (`:L19`, `:L26-L29`) and sets no warnings
  level. The one CI image this product runs, `macos-14` (`.github/workflows/ci.yml:L18`; a
  `release.yml:L18` cited beside it through v13 named a file this repository has never held,
  struck at v14 — RN-25), offers Xcode 15.0.1 – 16.2 with 15.4 the default (the runner-images readme,
  re-read this fold, 2026-09-23), and Swift 6.2 was released on 2025-09-15 (swift.org, read this
  fold). **What this run does not claim, stated so the bullet is read at its measure:** which
  Swift each of those Xcodes carries. Four fetches of Apple's and swift.org's pages returned no
  line pairing Xcode 16.2 with a Swift version, so the bullet cites the three facts it has and
  names the check that settles the fourth — the first CI log that builds `ka-reader-mac` prints the
  toolchain, and if it shows 6.2 or later the departure's ground is gone and the three are adopted
  then. The answer weighed *adopt and move the runner* and did not take it: the records bind no
  runner, so choosing one is not this document's decision, the departure costs nothing the day
  the runner moves, and it commits no contributor to a newer Xcode. The flip carries QC-25's
  re-measurement because the hosted-runner narrowing was taken on `macos-14` (SDD RN-48), and a
  new image is that measurement's stale case. *(4) Test-target names — adopted.* `<Target><Layer>Tests`
  (`layout.md` § Naming) needs no toolchain; `SurfacesTests` and `ShellTests`
  (`ka-reader-mac/Package.swift:L34-L35` at `ka-reader@a4ab8e6`, pinned at v41 — RN-52) predate the
  packet, nothing in the records grounds them, and
  a packet outranks the code's own habits (`languages/README.md` § Precedence). Which layer word
  each takes is the delivery tier's placement under § 9's rows, not this document's. *Also owed by
  the packet, and recorded:* the toolchain version CI builds `ka-reader-mac` with, where no
  `.swift-version` pin exists — none does (`ls -a`, 2026-09-23) — has no value, because CI does not
  build `ka-reader-mac` (`ci.yml` at `ka-reader@99e2bac` still builds the Tauri shape, `:L33-L44`); the
  first CI log that builds it supplies one. **The bullet is held in § 9 and not minted as a `QC`**,
  RN-15's form for the layer-5 rule: it binds the test strategy's own realization, which § 9 owns;
  a reader who needs it as an entry may say so on the next companion. Its review half is a
  class-2 gate and argues it in place — no command reads which toolchain CI builds with until CI
  builds `ka-reader-mac`. **ADR-0016, and the append-only rule.** The answer rules that the moved
  premise corrects the record and does not reverse it: the four units, the frame inside
  `ka-reader-mac/`, and "declares no package dependency" all stand — the artifact-bundle route, if
  adopted, stays inside `ka-reader-mac` and declares nothing — and only a *because* clause in
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
  `ka-reader-bridge` or `ka-reader-mac` as red until the native shell landed. It landed
  (`ka-reader@99e2bac`, 22:42 on 2026-09-23; `ls crates/` prints `ka-reader-app`, `ka-reader-bridge`,
  `ka-reader-core`, and `ka-reader-mac` and `ka-reader-ui` both stand at the root), so the tree holds both
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
  corrected reason and no entry moves; v16 (run 15) is the two subjects above — `ka_reader_free`
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
  preamble, row 4, the scope bullet, the `ka-reader-mac` bullet; § 10 QC-24 row; RN-6, RN-7;
  ADR-0016 § Decision, § Consequences, § Traces to; source: `docs/trail/architecture/cycle-10.md`
  §§ 2.1, 3.1 – 3.4; `docs/trail/architecture/self_answer-13.md`; `docs/SDD.md` v16 — § 3 SM-4,
  the Swift-frame paragraph, § 4 C-R7, C-I3, C-I6, § 6 S-1, S-3, S-11, § 10 RC-3, § 12, RN-65,
  RN-66; `docs/trail/sdd/cycle-12.md` §§ 5.1, 5.2; `docs/trail/sdd/self_answer-23.md`;
  `crates/ka-reader-bridge/Cargo.toml`, `build.rs`, `src/exports.rs`, `tests/exports.rs`;
  `ka-reader-mac/Package.swift`; `ka-reader-mac/Tests/`; `.github/workflows/ci.yml` (`release.yml`,
  listed here through v13, was never in the tree — struck at v14, RN-25);
  `checks/deps.allow`; `system/projects/ka-reader/project.md`; `languages/swift/` — `README.md`,
  `testing.md`, `layout.md`, `toolchain.md`, `quality_gates.md`; `languages/README.md`
  § Precedence, § The resolution chain; https://doc.rust-lang.org/cargo/reference/build-scripts.html;
  https://github.com/actions/runner-images/blob/main/images/macos/macos-14-arm64-Readme.md;
  https://www.swift.org/blog/swift-6.2-released/; the commits named)*
- **RN-25:** *(v14 — the close of the cycle-11 companion: seven facts these records held that the
  Tauri build's removal made false, each raised by the PM from the tree at `ka-reader@0aca57e`)*
  **How the companion came to exist.** As at RN-18 – RN-21 and RN-24, no `product-architecture`
  run opened it: both records were Settled at v13 with no companion on disk. The PM opened it on
  2026-09-24 (`ka-reader@1e2faad`) with seven items raised from downstream, §§ 3.1 – 3.7, each a
  measurement of `main` at `ka-reader@0aca57e` — the merge at which the Tauri build left the tree
  (`docs/SDD.md` § 10 RC-3) — against a sentence here. All seven were answered in the owner's
  seat by one unattended `companion-self-answer` run, not by the owner in person
  (`ka-reader@c461b29`; its reasoning, `docs/trail/architecture/self_answer-14.md`), and as answered
  the companion is `docs/trail/architecture/cycle-11.md`. Every change below names the answer
  that authorizes it, and what this run added beyond an answer's words is marked as this run's
  own. Every measurement below was re-run this fold at `ka-reader@c461b29`, not taken from the
  answer. **§ 3.1 → § 1's opening paragraph.** `git ls-files ka-reader-ui crates/ka-reader-app | wc -l`
  prints `0`, so the v13 sentence that the tree holds both shapes is false; the paragraph reads
  the tree as ADR-0016's four units and nothing else from `ka-reader@0aca57e`, dated in place in the
  form v13 used for the same paragraph, and its closing clause about the old units "while they
  remain" goes with it, nothing old remaining. The answer's addition, folded as written: the
  measure is `git ls-files`, not the `ls` the v13 sentence cited, because a working copy that
  built the previous shape still lists `ka-reader-ui/` and `crates/ka-reader-app/` as untracked build
  output — this checkout does (`ls -d ka-reader-ui crates/ka-reader-app` lists both while `git
  ls-files` tracks neither; the answer names `node_modules/`, `dist/`, `gen/`, `permissions/`),
  their ignore lines having left with the build — and an `ls` there reads the old shape back into
  a tree that does not hold it. The four scripts not yet in the tree — `checks/view.sh`,
  `checks/renderer.sh`, `checks/structure.sh`, `checks/entry-points.sh` (`ls checks/` prints
  `bundle.sh`, `deps.allow`, `fixtures`, `no-network.sh`, `own-state.sh`, `read-only.sh`,
  `sandbox_probe.rs`, `tests`) — stay as the entries name them, under the header's rule that a
  command becomes executable in the change that lands its script. **§ 3.2 → QC-3.** The one item
  the answer overrode, in one clause: the PM's lean had the tail say the review half was realized
  at `ka-reader@0aca57e` over the 17 names, and the answer checked that clause against the record and
  found no review — `ka-reader@6acfb65` generated the list and read its names against the file's
  header rules, which is the reading by name QC-3's own second half says cannot answer the domain
  question, and `ka-reader@fad4e78`'s body records only that the tree equals the list. So the tail
  does not say the half was realized. What it says instead, transcribed from the answer: at
  `ka-reader@0aca57e` the list is one `cargo:` section of 17 names (`checks/deps.allow:L18` onward;
  `awk '/^cargo:/{p=1;next} p && !/^#/ && NF' checks/deps.allow | wc -l` → `17`, and
  `grep -c '^pnpm:'` → `0`); the `pnpm:` section (163 names) and 201 of the 218 cargo names left
  with the Tauri build at `ka-reader@fad4e78`, unreviewed, and none of them is shipped now; the 17
  that stayed were among the 218 never reviewed; the one-time review is still owed over those 17,
  by the change that first realizes the half, and the rest of the tail stands. The clause "the
  pnpm names leave the list with `ka-reader-ui`" is gone from the tail, the leaving having happened.
  § 10's QC-3 row names the script and the review and does not move. **Seen and not written, the
  answer's own note carried here:** read by name, none of the 17 (`itoa`, `libc`, `log`, `memchr`,
  `proc-macro2`, `quote`, the `serde` family, `syn`, `thiserror`, `thiserror-impl`,
  `unicode-ident`, `zmij`, and the two product crates) has a transport for its domain — which is
  exactly the name-level reading QC-3 says is not the review, so it settles nothing. **§ 3.3 →
  QC-25.** `grep -n EXPECTED_ENTITLEMENTS checks/bundle.sh` prints `132:`, and `:L132-L133` hold
  the two entitlements the entry names; QC-25's tail cited `:L127-L128`, true of the script at
  `ka-reader@99e2bac` and five lines high since the contents block above the set grew. Of the lean's
  two options the answer took the current range pinned to the commit it was read at,
  `ka-reader@0aca57e:checks/bundle.sh:L132-L133` — the form § 3.7 uses, so the two answers agree, and
  a pin fails by being old rather than by pointing at the wrong lines. The answer's addition,
  folded as written: RN-21's two old ranges (`:L127-L128` "opened this run", and `:L127-L187` in
  its source list) are dated history, true when their fold read them, and do not move; only QC-25
  is a live entry. § 10's QC-25 row names the script alone and does not move. **§ 3.4 → § 9's
  `ka-reader-mac` bullet, the toolchain clause and the tail.** The clause read that CI does not
  build `ka-reader-mac` — true of `ci.yml` at `ka-reader@99e2bac` — and on `main`
  `.github/workflows/ci.yml:L26` runs `swift test --package-path ka-reader-mac` in `Test gate` and
  `:L29` runs `ka-reader-mac/assemble.sh`, both from `ka-reader@0aca57e`. The clause now says so, dated
  in place, and says the value is still unread: `git rev-parse --short origin/main` prints
  `a4ab8e6` and `git rev-list --count origin/main..main` prints `14` this fold (`9` when the PM
  measured, `13` when the answer did — the count moves with every local commit and the fact does
  not), so no CI run on `main` has built it. The answer's two additions, folded as written:
  (1) `ci.yml` has no `swift --version` step (`:L22-L29`) and neither the answer nor this run
  knows whether `swift test`'s output names the toolchain, so the clause states what happens if
  the first log is silent — the line stays *not yet measured* and says what it waits for — and
  the tail's review gate, which read "until CI builds `ka-reader-mac`", a condition now met while the
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
  built by that workflow — not a citation, and stands. **§ 3.6 → § 9's `ka-reader-mac` bullet, a
  fourth departure and the tail.** The bullet said a packet rule it does not name is followed as
  written, and the packet's dependency gate refuses any target whose `type` is `"system"`
  (`languages/swift/quality_gates.md` § The gates — `select(.url != null or .type == "system")`,
  read this fold at v1.1.0) while `ka-reader-mac/Package.swift:L19` is
  `.systemLibrary(name: "CKAReaderBridge")`; a delivery reader writing the packet's gate from the
  bullet's words would fail the tree as built. The bullet names the clause as departed from, for
  the reason the answer gives — the system library is a module map over `ka-reader-bridge`'s
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
  `crates/ka-reader-app/tests/config.rs:L17`, `:L181-L188` and `tauri.conf.json:L12`; RN-19's
  `log_writer.rs:L142`, `tests/config.rs:L11` and `log_writer.rs:L201`; ADR-0012's
  `ka-reader-ui/src/main.ts:L14-L19` and `crates/ka-reader-app/src/main.rs:L17-L19` in its § Context
  and again in its § Traces to — and RN-19's `tests/config.rs:L228`, `:L231` and
  `capabilities/main.json:L5`, already pinned to `ka-reader@bf99e8e` in their own sentence. Each of
  the seven is pinned to `ka-reader@a4ab8e6:` with its full path: `git show a4ab8e6:<path>` opened
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
  `crates/ka-reader-core/tests/common/mod.rs`, which stands, and is out of the item. **Fixed in
  place, under no answer** — a defect found while walking, RN-24's form for § 1's paragraph:
  QC-27's tail and § 9's preamble each said `pnpm audit` and the TypeScript packet's tooling
  "leaves with `ka-reader-ui`", a prediction the removal fulfilled; each reads *left* and is dated to
  `ka-reader@0aca57e`, and nothing either binds moves. **What moved beneath this document, and what
  did not.** The SDD moved v16 → v17 (`ka-reader@7608edb`, run 16; `git diff --stat 097ef33..7608edb
  -- docs/SDD.md`: 142 insertions, 14 deletions, read whole as a diff): its `Version:` line, a
  dated parenthesis on § 10 RC-3's *Still unresolved* recording that the README's stack and status
  block moved at `ka-reader@61748fe`, and the Review Notes — RN-52, RN-53, RN-57 and RN-58 pinning
  citations to `ka-reader@a4ab8e6:`, RN-59 and RN-60 taking dated parentheses, RN-67 – RN-69 new. No
  § 1 – § 9 statement moved, so no entry here follows it; the SDD is Settled and its companion
  removed. The SRS (v12), the FDR (v8), the PRD (v15), the UXD (v10), DESIGN (v8) and CONTENT (v6)
  are byte-for-byte what v13 read (`git diff --stat 5c4bd9a..HEAD` over the six is empty); each
  one's `Status:` line was re-read this run and every one is Settled, so the `Inputs read:` line
  stands. The doctrine cites stand as the header states them. No `QC` is added, renumbered or
  reused; § 1, § 2, § 9 and the two review notes move only where named above; § 10 does not move;
  no accepted record is edited beyond ADR-0012's three pins and the one § Traces to sentence that
  states their provenance. Nothing is left for the owner; `docs/architecture_open_issues.md` is
  removed and `Status:` is Settled *(re: header `Version:`; § 1 opening; QC-3, QC-25,
  QC-27; § 9 preamble, the `ka-reader-mac` bullet; RN-18, RN-19, RN-24; ADR-0012 § Context,
  § Traces to; source: `docs/trail/architecture/cycle-11.md` §§ 3.1 – 3.7;
  `docs/trail/architecture/self_answer-14.md`; `docs/trail/architecture/cycle-3.md` § 3.1;
  `docs/SDD.md` v17 — § 10 RC-3, RN-67, RN-68; `checks/deps.allow`; `checks/bundle.sh`;
  `checks/no-network.sh`; `ka-reader-mac/Package.swift`; `.github/workflows/ci.yml`;
  `ka-reader@a4ab8e6:crates/ka-reader-app/tests/config.rs`, `:src/log_writer.rs`, `:src/main.rs`,
  `:tauri.conf.json`; `ka-reader@a4ab8e6:ka-reader-ui/src/main.ts`; `languages/swift/quality_gates.md`
  § The gates; the commits named)*
- **RN-26:** *(v15 — the cycle-12 fold: five facts these records held that the renderer gate's
  landing made false, each raised by the PM from the tree at `ka-reader@153f5a1`, and one choice a
  `companion-self-answer` run raised on this document for the owner's confirm)* **How the
  companion came to exist.** As at RN-18 – RN-21, RN-24 and RN-25, no `product-architecture` run
  opened it: both records were Settled at v14 with no companion on disk. The PM opened it on
  2026-09-24 (`ka-reader@2bcefd5`, § 3.5 at `ka-reader@28eb54f`) with five items raised from
  downstream, §§ 3.1 – 3.5, each a measurement of `main` at `ka-reader@153f5a1` — the merge at which
  `checks/view.sh`, `checks/renderer.sh` and `checks/fixtures/idle-shell` landed — against a
  sentence here. All five were answered in the owner's seat by one unattended
  `companion-self-answer` run, not by the owner in person (`ka-reader@c28255e`; its reasoning,
  `docs/trail/architecture/self_answer-15.md`), and that run appended one item of its own, § 2.1,
  in the bucket *Choices to confirm*, with its slot empty. As answered the companion is
  `docs/trail/architecture/cycle-12.md`. Every change below names the answer that authorizes it,
  and what this run added beyond an answer's words is marked as this run's own. Every measurement
  below was re-run this fold at `ka-reader@c28255e`, not taken from the answer: `git diff --stat
  153f5a1 HEAD -- checks .github ka-reader-mac` prints nothing, so the PM's tree is this one.
  **§§ 3.1 and 3.2 → QC-62 and ADR-0012, decided together.** Every sentence the two items correct
  is measured false: `ls checks checks/fixtures` lists `renderer.sh` and `idle-shell`;
  `.github/workflows/ci.yml:L43-L44` runs the gate as `Renderer gate` after `Bundle probe`
  (`:L31-L32`); `ka-reader-mac/Sources/Shell/LaunchFlow.swift:L35-L37` calls `panel.chooseFolder()`
  and only then `bridge.openFolder(location:)`; `checks/renderer.sh:L53-L57` lists five frames
  with no bridge frame and `:L51-L52` says why; `:L58-L61` records the Mac reading (macOS
  26.6.2); `gh run view 35988399477 --json headSha,conclusion,headBranch` → `37a962d`, `success`,
  branch `2026-09-24_the-shell-is-seen-at-the-panel`, and `git diff --stat 37a962d HEAD --
  checks/renderer.sh checks/fixtures/idle-shell ka-reader-mac/Sources` prints nothing, so the run
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
  `ka-reader-mac/Sources/Shell/OpenFolderPanel.swift:L14` is `return panel.runModal() == .OK ?
  panel.url : nil`, and C-R3 requires the panel at launch, so "no modal presentation in
  `ka-reader-mac/Sources`" was false as written. The tail admits the Open panel's own presentation,
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
  `cargo test --workspace --locked && swift test --package-path ka-reader-mac` and the XCTest
  suites executed with 0 failures; the only lines matching `swift-version`, `Swift version`,
  `swiftlang` or `Apple Swift` are two `Write swift-version-76B232A4806BA581.txt` build lines. So
  the clause records the run and stays *not yet measured* by its own rule, "no CI run on `main`
  has built it" becoming dated history; the tail's review gate and the four departures do not
  move. An override at § 2.1 reverts the clause on the next run. **Fixed in place, under no
  answer:** none this fold. **What moved beneath this document, and what did not.** The SDD
  moved v17 → v18 (`ka-reader@399ef71`, run 17; `git diff --stat 8655a33 HEAD -- docs/SDD.md`:
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
  § 9 the `checks/tests/` bullet and the `ka-reader-mac` bullet's toolchain clause; § 10 legend and
  rows; ADR-0012 § Decision, § Consequences, § Traces to; source:
  `docs/trail/architecture/cycle-12.md` §§ 2.1, 3.1 – 3.5;
  `docs/trail/architecture/self_answer-15.md`; `docs/SDD.md` v18 — § 4 C-I3, C-R3, § 9 TO-7,
  RN-70; `docs/trail/sdd/cycle-14.md` §§ 5.1, 5.2; `checks/renderer.sh:L44-L61`;
  `checks/view.sh:L33-L87`; `checks/tests/test_renderer.sh:L64`; `ka-reader-mac/Sources/Shell/
  LaunchFlow.swift:L35-L37`; `ka-reader-mac/Sources/Shell/OpenFolderPanel.swift:L14`;
  `.github/workflows/ci.yml:L26`, `:L31-L36`, `:L43-L44`; GitHub Actions runs 35988399477 at
  `ka-reader@37a962d` and 35968105480 at `ka-reader@c461b29`; `ka-reader@153f5a1`; the commits named)*
- **RN-27:** *(v16 — the close: the cycle-13 fold, one choice v15 drafted into § 9's toolchain
  clause, confirmed with addition in the owner's seat)* **How the item came to exist.** The
  `companion-self-answer` run that answered cycle 12's five downstream items raised § 2.1 on this
  document (`docs/trail/architecture/self_answer-15.md`, § Raised on this document), from reading
  § 9 whole against the CI runs on `main`; the v15 fold drafted it into the clause and left the
  slot empty (RN-26). It was answered in the owner's seat by a second unattended
  `companion-self-answer` run, not by the owner in person (`ka-reader@0f7743e`; its reasoning,
  `docs/trail/architecture/self_answer-16.md`): confirmed, with one addition. As answered the
  companion is `docs/trail/architecture/cycle-13.md`. **Re-measured this fold, not taken from the
  answer** (2026-09-24, at `ka-reader@0f7743e`): `gh run view 35968105480 --json
  status,conclusion,headSha,headBranch,event` → `completed`, `success`, `main`, `push`, `c461b29`;
  `gh run list --branch main --workflow CI --limit 6` lists five runs on `main` and 35968105480 is
  the newest — local `main` is 22 commits ahead of `origin/main` at `c461b29` and unpushed, so no
  later `main` run exists whose log could name the toolchain; `.github/workflows/ci.yml:L25-L26`
  still runs `swift test --package-path ka-reader-mac` in `Test gate`, and `grep -n 'swift --version'
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
  `Version:`; § 9 the `ka-reader-mac` bullet's toolchain clause; source:
  `docs/trail/architecture/cycle-13.md` § 2.1; `docs/trail/architecture/self_answer-16.md`;
  `.github/workflows/ci.yml:L22-L29`; GitHub Actions run 35968105480 at `ka-reader@c461b29`;
  `ka-reader@0f7743e`)*
- **RN-28:** *(v17 — the close: the cycle-14 fold, five items raised by the PM from the tree at
  `ka-reader@ab39502`, each answered in the owner's seat)* **How the items came to exist.** No
  `product-architecture` run opened the companion: the PM opened it on 2026-09-24
  (`ka-reader@1a84367`) from measuring `main` at `ka-reader@ab39502` — the merge at which the runner
  reading went into `checks/renderer.sh`'s header (`ka-reader@2b83dce`) and the five remaining
  `checks/tests/` suites went onto CI steps of their own (`ka-reader@82996b8`, `ka-reader@66ba2e8`) —
  against these records at v16. §§ 3.1, 3.4 and 3.5 were facts the records held that the tree
  made false; §§ 3.2 and 3.3 were rules § 9 wrote for a day that had come. All five were answered
  in the owner's seat by a `companion-self-answer` run, not by the owner in person
  (`ka-reader@c26d47c`; its reasoning, `docs/trail/architecture/self_answer-17.md`): each confirmed
  with addition, §§ 3.1 and 3.3 decided together, §§ 3.4 and 3.5 decided together. As answered
  the companion is `docs/trail/architecture/cycle-14.md`. **Re-measured this fold, not taken
  from the answers** (2026-09-24, at `ka-reader@c26d47c`, whose tree outside `docs/` is
  `ka-reader@ab39502`'s — `git diff --stat ab39502 HEAD` lists the companion and
  `self_answer-17.md` alone): the six suite steps at `.github/workflows/ci.yml:L35-L36`,
  `:L41-L42`, `:L52-L53`, `:L61-L62`, `:L67-L68`, `:L70-L71`, each a step's whole `run`; the
  comparison in § 9's tail prints nothing; `grep -nE 'continue-on-error|^[[:space:]]+if:'
  .github/workflows/ci.yml` prints nothing; `ls checks/*.sh` lists the six scripts and none runs
  the comparison; `KA_READER_TEST_ONLY=test_header_names_the_runner_reading
  checks/tests/test_renderer.sh` prints `ok` and exits 0; `checks/renderer.sh:L44-L57` holds the
  frame list, `:L58-L61` the Mac reading, `:L62-L65` the hosted-runner reading (run 35988399477
  on `ka-reader@37a962d`, `macos-14-arm64` 20260831.0302.1, macOS 14.8.9); `Renderer gate` is
  `ci.yml:L46-L47` and `Bundle probe` `:L31-L32`, and `git show 153f5a1:.github/workflows/ci.yml`
  has `Renderer gate` at `:L43-L44`, so ADR-0012's dated cite was true when written; `gh run list
  --repo kensaiapp/ka-reader --workflow ci.yml --limit 5` lists 35988399477 on `ka-reader@37a962d`
  (branch `2026-09-24_the-shell-is-seen-at-the-panel`) and 35968105480 on `ka-reader@c461b29`
  (`main`) as its newest, `origin/main` is `c461b29`, and `git rev-list --count origin/main..main`
  prints `29` — the answer counted `28` and the PM `27`, the two companion commits since — so no
  run has run the five. The Mac run of all six suites is the PM's measurement in the item and was
  not repeated here. **§§ 3.1, 3.3 → § 9's `checks/tests/` bullet and § 10's preamble.** The
  bullet reads all six on steps from `ka-reader@ab39502`, dated; the ordering rule is history that
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
  `ci.yml:L46-L47` with `:L43-L44` dated to `ka-reader@153f5a1`; its trace names v17. ADR-0012 takes
  one new dated in-place note in § Consequences, after the 2026-09-24 note that was true at
  `ka-reader@153f5a1` and stands as written, carrying both corrections, and one § Traces to bullet
  naming the cycle — the record's own practice for its six earlier dated notes, on the owner's
  ruling that a citation repair reverses no decision (`docs/trail/architecture/cycle-3.md`
  § 3.1) and the form the log took at v9, v13, v14 and v15; § Decision's `:L43-L44` stands,
  inside a parenthesis dated "from `ka-reader@153f5a1`", where it was true. After the fold, `grep -n
  'L43-L44' docs/nfdr.md docs/adr/*.md` finds only sites that date it — QC-62's tail, ADR-0012's
  § Decision parenthesis and its new note, and RN-26's measurement, which stands as history.
  **Fixed in place, under no answer:** none this fold. **What moved beneath this document, and
  what did not.** Nothing: `git log 0f7743e..HEAD -- docs/SRS.md docs/SDD.md docs/fdr.md
  docs/PRD.md docs/UXD.md docs/DESIGN.md docs/CONTENT.md` prints nothing, so the SDD (v18), the
  SRS (v12), the FDR (v8), the PRD (v15), the UXD (v10), DESIGN (v8) and CONTENT (v6) are
  byte-for-byte what v16 read; the three primary inputs' `Status:` lines were re-read this run
  and each is Settled, so the `Inputs read:` line stands. The SDD's seven cites into
  `checks/renderer.sh` (`docs/SDD.md:L707`, `:L714`, `:L724`, `:L1324`, `:L2340`, `:L3940`,
  `:L3972` — ranges inside `:L44-L61`) were opened at `ka-reader@ab39502` and hold, and the SDD
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
  at `ka-reader@37a962d` and 35968105480 at `ka-reader@c461b29`; `ka-reader@153f5a1`, `ka-reader@2b83dce`,
  `ka-reader@82996b8`, `ka-reader@66ba2e8`, `ka-reader@ab39502`, `ka-reader@1a84367`, `ka-reader@c26d47c`)*
- **RN-29:** *(v18 — the cycle-15 fold: § 3.1 folded as answered; QC-6 re-derived on SDD v20
  under a new upstream sentence; § 2.1 kept for the owner's confirm)* **How the items came to
  exist.** No `product-architecture` run opened the companion. The PM opened it on 2026-09-25 with
  § 3.1 (`ka-reader@41915e6`), measuring `main` at `ka-reader@46bb275` — the first commit at which the
  shell draws `pending` items — against QC-4; a `companion-self-answer` run answering
  `docs/fdr_open_issues.md` § 2.2 appended § 2.1 in the Principal PM's posture (`ka-reader@9cfb727`),
  because SDD run 18 (`ka-reader@4b9425b`) had moved § 3 `fs-reader` after v17 (`ka-reader@18250d6`) and
  no run of these records had read it. § 3.1 was answered in the owner's seat by a
  `companion-self-answer` run (`ka-reader@fcd7ac5`; its reasoning
  `docs/trail/architecture/self_answer-18.md`); § 2.1's slot was empty at intake. As it stood at
  intake the companion is `docs/trail/architecture/cycle-15.md`. **§ 3.1 → QC-4's layer-4 half and
  § 9's row 4.** The half no longer names a word: a projection with a `pending` item draws no
  marker, no count and no empty-folder sentence, and the only words it may carry for the state are
  the *Loading* sentence `docs/CONTENT.md` § Message patterns fixes — a pointer, as the answer
  directed, because a string is CONTENT's to hold (QC-53; FDR R-88) and a copied one goes false
  the day CONTENT re-words it. Row 4 of § 9's layer table moves the same way; § 10's QC-4 row names
  commands only and does not move; the trace to R-94 stays and reads R-94 at v10. The contingency
  the answer left — the FDR's seat answering that R-94 is literal — closed before this fold: FDR
  v10 (`ka-reader@69cc4b2`, RN-35) re-worded R-94 to name the state and point at CONTENT's *Loading*
  words, so no document in the definition set names the word *pending* any longer, and nothing
  comes back on a fresh item. Re-measured this fold, not taken from the answer: `git diff --stat
  46bb275 HEAD -- crates ka-reader-mac checks` prints nothing, so the tree the items measured is the
  tree at `ka-reader@69cc4b2`; `testRepoProjectionDrawsNameAndGlyphOnly` sits at
  `ka-reader-mac/Tests/SurfacesTests/RootItemsViewTests.swift:L96-L115` and asserts the only visible
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
  `..` and symlink-out cases, states that none of the four is written at `ka-reader@69cc4b2`
  (`crates/ka-reader-core/src/fs_reader.rs` `mod tests`, the `..` and symlink cases at `:L412-L578`),
  and that the re-entry case goes red when it is — the walk at `:L170-L177` keeps one lexical
  position and answers `Outside` for `../<NAME>`, measured at `docs/trail/sdd/cycle-15.md` § 5.1
  on `ka-reader@46bb275` with the crates unchanged since (the stat above); SDD RN-71's own
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
  docs/PRD.md docs/UXD.md docs/DESIGN.md docs/CONTENT.md` lists SDD run 18 (`ka-reader@4b9425b`,
  v18 → v20), FDR v9 and v10 (`ka-reader@d341d42`, `ka-reader@69cc4b2`), DESIGN v9 and v10
  (`ka-reader@cdb756c`, `ka-reader@da88347`) and CONTENT v7 (`ka-reader@1c95030`); the SRS, the PRD and the
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
  R-94, RN-34, RN-35; `docs/CONTENT.md:L314`, `:L492`; `crates/ka-reader-core/src/fs_reader.rs:L170-L177`,
  `:L412-L578`; `ka-reader-mac/Tests/SurfacesTests/RootItemsViewTests.swift:L96-L115`;
  `ka-reader@18250d6`, `ka-reader@4b9425b`, `ka-reader@41915e6`, `ka-reader@46bb275`, `ka-reader@fcd7ac5`,
  `ka-reader@9cfb727`, `ka-reader@d341d42`, `ka-reader@69cc4b2`, `ka-reader@cdb756c`, `ka-reader@da88347`,
  `ka-reader@1c95030`)*

- **RN-30:** *(v19 — the close: the cycle-16 fold; QC-6's layer-1 list re-sourced under the
  owner's answer; the volume-root case named red under this run's own reading)* **The fold.** The
  companion at intake (`docs/architecture_open_issues.md` at `ka-reader@368f127`) held one item, § 2.1,
  answered in the owner's seat by a `companion-self-answer` run (its reasoning
  `docs/trail/architecture/self_answer-19.md` § 2.1): *confirm, with one addition*. The companion as
  it stood is `docs/trail/architecture/cycle-16.md`, copied before this fold rewrote anything.
  **§ 2.1 → QC-6's *verified by*, the layer-1 list only.** The obligation, the trace and § 10's
  row stand as v18 holds them; the answer moves one sentence. v18 said "the four spellings
  `docs/fdr.md`'s example rows fix (`:L357-L358`)" — the rows fix three: `:L357` holds
  `up → ../KA-READER/docs`, shown as a folder and expanding into `docs` (R-183, R-34, R-151),
  `far → ../../projects/KA-READER/docs`, marked outside although it leads in (R-184's multi-level
  return), and `self → ../KA-READER`, a cycle (R-152); `:L358` holds `back → ../Work/notes.txt` under
  `/Volumes/Work` (R-184's volume root). No row exercises a Unicode-normalization difference; that
  refusal rests on R-184's second clause (`docs/fdr.md:L88`) and SDD § 11 R-10 (`docs/SDD.md:L2431`),
  and the list now cites those in its place, so a QA seat deriving the case has a source to derive
  it from. Two consequences the answer drew, folded as given: the re-entry has two forms the rows
  fix — `self`, ending `Cycle`, which v18 named, and `up`, resolving inside and read as its
  target, which it did not — and the list names both; and both are `Outside` on the walk at
  `ka-reader@368f127` by the same lines (`crates/ka-reader-core/src/fs_reader.rs:L211-L215`), the
  owner's measurement at `docs/trail/sdd/cycle-15.md` § 5.1 having covered the `self` form on
  `ka-reader@46bb275` with the crates unchanged since — re-measured this fold, not taken from the
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
  `…/projects/KA-READER/docs` and fails `strip_prefix(root)` (`:L256-L262`), and a
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
  `crates/ka-reader-core/src/fs_reader.rs:L170-L177`, `:L201-L203`, `:L211-L215`, `:L217`,
  `:L256-L262`, `:L269`, `:L309`, `:L370-L796`, `:L412-L578`; `ka-reader@46bb275`, `ka-reader@88b237f`,
  `ka-reader@368f127`)*
- **RN-31:** *(v20 — the close: the three answered cycle-17 items folded into § 9)* **The fold.**
  The companion at intake held one overridden choice and two answered downstream findings; copied
  whole before this fold as `docs/trail/architecture/cycle-17.md`. §§ 3.1 and 3.2 were decided in
  the owner's seat by `docs/trail/architecture/self_answer-20.md`; § 2.1 was decided there by
  `self_answer-21.md`. Nothing is left for the owner. **Framework.** The old *followed* clause was
  false after a fifth XCTest file landed. Its answer makes the present state a departure, fixes the
  count at five at `ka-reader@f46269a`, and gives it its own evidence-based flip: new tests remain
  XCTest until a CI log on `main` names a toolchain that runs Swift Testing; from that log onward,
  new tests use Swift Testing and the existing XCTest files stay. The review tail gains changes
  adding a file under `ka-reader-mac/Tests/`, because the previous trigger read only the manifest and
  workflow and therefore did not read the three changes that wrote XCTest. **Language mode.** The
  5.9 manifest puts every target in Swift 5 mode, so Swift 6 mode joins the recorded tools-version
  departure and flips with it, explicitly as `swiftLanguageModes: [.v6]`. No target takes
  `StrictConcurrency` meanwhile: the measured diagnostics are warnings without the departed
  warnings-as-errors setting, and the unmeasured CI compiler leaves the spelling unresolved. The
  migration cost is named at `LaunchFlow.swift:L53` and `ReadRunning.swift:L28`. **The two 6.2
  settings.** `.strictMemorySafety()` joins every Swift target, including both test targets, and
  `.defaultIsolation(MainActor.self)` joins `Surfaces` and `KAReader` only. The strict-memory cost is
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
  *(re: § 9 `ka-reader-mac` bullet; source: `docs/trail/architecture/cycle-17.md` §§ 2.1, 3.1, 3.2;
  `docs/trail/architecture/self_answer-20.md`; `docs/trail/architecture/self_answer-21.md`;
  `ka-reader-mac/Package.swift:L1-L36`; `docs/adr/0016-physical-unit-set-core-bridge-mac-checks.md`
  § Consequences; `docs/CONTENT.md` RN-34, RN-35; `ka-reader@f46269a`; `ka-reader@a5fc189`)*
- **RN-32:** *(v21 — the cycle-18 fold, § 3.1 answered; § 2.1 drafted for the owner's confirm)*
  **The fold.** The companion at intake held one answered downstream item, § 3.1, decided in the
  owner's seat by `docs/trail/architecture/self_answer-22.md`, and one unanswered choice, § 2.1,
  raised by that same run; it was copied whole before this fold as
  `docs/trail/architecture/cycle-18.md`. **§ 3.1 → QC-24.** C-R7 at SDD v22 reads "A build exports
  to the shell exactly the functions its landed changes built" and "A change has built a function
  when the bridge function exists and delegates to an operation `folder-model`'s API carries
  (SM-5)" (`docs/SDD.md:L596-L604`). QC-24's two slice-grain sentences now read by change, and the
  entry carries that meaning of *built*. Set equality, the closed list, `ka_reader_free`, "from
  `v1.0.0`", the no-second-export clause and the pre-`v1.0.0` uncovered case stand as written.
  **§ 3.1 → QC-2.** The item proposed naming `cargo test --locked -p ka-reader-bridge --test
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
  and QC-62 traces to C-I3. Read at `ka-reader@a954a90`, whose code under these paths is byte-equal
  to `ka-reader@7c7038f` (`git diff --quiet 7c7038f HEAD --` over `LaunchFlow.swift`,
  `ReadRunning.swift` and `checks/renderer.sh`): `LaunchFlow.swift:L35-L37` is the lazy
  `statusGlyphs` property, `chooseFolder()`'s panel wait and hand-off are `:L54-L60`, and
  `bridge.openFolder` is `:L69`; `checks/renderer.sh`'s frame list is `:L53-L56` and holds four
  frames, its Mac reading `:L57-L60`, its runner reading `:L61-L64`; `ka-reader@b75348f` removed
  `LaunchFlow.run()` from the list. QC-62 cites each at `ka-reader@7c7038f`, as C-I3 does, says the
  five-frame match was the list the script carried at `ka-reader@37a962d`, and carries C-I3's second
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
  `Version:`; QC-2; QC-24; QC-62; § 9 `ka-reader-mac` bullet; § 10 QC-2 row; source:
  `docs/trail/architecture/cycle-18.md` §§ 2.1, 3.1; `docs/trail/architecture/self_answer-22.md`;
  `docs/SDD.md` § 4 C-R7, C-I3 at v22, RN-76; `docs/trail/sdd/cycle-17.md` §§ 2.1, 5.1;
  `ka-reader@7c7038f`, `ka-reader@b75348f`, `ka-reader@a954a90`)*
- **RN-33:** *(v22 — the close: the cycle-19 fold, § 2.1 confirmed with two additions)* **The
  fold.** The companion at intake held one answered choice, § 2.1, decided in the owner's seat by a
  `companion-self-answer` run (`docs/trail/architecture/self_answer-23.md` § 2.1); it was copied
  whole before this fold as `docs/trail/architecture/cycle-19.md`. The answer confirms QC-62 as v21
  drafted it and adds two corrections; with both folded nothing is open, and the companion is
  removed. **QC-62 does not move.** **§ 9 — addition (1).** RN-32 moved the measured site
  `LaunchFlow.swift:L53` to `:L60`, and that named a different closure: at `ka-reader@6e1d79f`, where
  the cost was measured, `:L52-L53` is the `listTree` closure, `{ Self.listing(at: path, through:
  bridge) }`, and at `ka-reader@7c7038f` that closure is `:L106-L107`; `:L60` is the closure
  `chooseFolder()` hands to `openAndList`, and `:L110-L111` the `selectFile` closure, both added
  after the measurement (read this fold with `git show` at both commits;
  `ka-reader-mac/Sources/Shell/` is byte-equal between `7c7038f` and `HEAD`, `git diff --stat 7c7038f
  HEAD -- ka-reader-mac checks` printing nothing). The sentence now names all three sites and
  `ReadRunning.swift:L28`, which stands (`:L28`, `MainActor.assumeIsolated { deliver(listing) }`).
  That all three fail Swift 6 mode is the answer's measurement — Apple Swift 6.4, a copy of
  `ka-reader-mac` at `ka-reader@7c7038f`, `swift build --target Shell -Xswiftc -swift-version -Xswiftc 6`
  failing at exactly those three lines, and the cycle-17 method (tools 5.9, `StrictConcurrency` on
  `Surfaces` and `Shell`) warning at the three and at `ReadRunning.swift:L28`
  (`self_answer-23.md` § 2.1) — cited and not re-run by this fold. **ADR-0012 — addition (2).**
  RN-32's reason for leaving ADR-0012 alone — that it is Accepted — does not hold: the owner's
  ruling makes a citation repair an edit to an ADR's own prose, as a pin, with no superseding record
  (`docs/trail/architecture/cycle-3.md` § 3.1, answers (1) and (3)). ADR-0012's four unpinned
  citations — `ka-reader-mac/Sources/Shell/LaunchFlow.swift:L35-L37` in § Decision and
  `checks/renderer.sh:L44-L57`, `:L58-L61` and `:L62-L65` in § Consequences — are each pinned to
  `ka-reader@ab39502:` in two dated in-place notes and a *Traces to* bullet. Read this fold at
  `ka-reader@ab39502`: `LaunchFlow.swift:L35-L37` is `panel.chooseFolder()` followed by
  `bridge.openFolder(location:)`, and `checks/renderer.sh` carries § *THE FRAMES* at `:L44`, the
  five-frame list ending at `:L57`, the Mac reading at `:L58-L61` and the runner reading at
  `:L62-L65`. The record's Status, decision, alternatives and binding are untouched, so the index
  does not move. RN-32 stands as the dated account of v21. **What moved beneath this document.**
  `git log c5f3a59..HEAD` lists only the answer's own commit, `ka-reader@cb10c34`; every input's
  `Status:` line was re-read and is Settled, so `Inputs read:` stands. No `QC` is added,
  renumbered or reused *(re: header `Status:`, `Version:`; § 9 `ka-reader-mac` bullet; ADR-0012
  § Decision, § Consequences, § Traces to; source: `docs/trail/architecture/cycle-19.md` § 2.1;
  `docs/trail/architecture/self_answer-23.md` § 2.1; `docs/trail/architecture/cycle-3.md` § 3.1;
  `ka-reader@6e1d79f`, `ka-reader@7c7038f`, `ka-reader@ab39502`)*
- **RN-34:** *(v23 — the cycle-20 fold, §§ 3.1 and 3.2 answered; two drafts for the owner's
  confirm)* **The fold.** The companion at intake held two answered downstream items, §§ 3.1 and
  3.2, raised by the PM and decided in the owner's seat by a `companion-self-answer` run
  (`docs/trail/architecture/self_answer-24.md`), and one unanswered choice, § 2.1, raised by that
  same run; it was copied whole before this fold as `docs/trail/architecture/cycle-20.md`.
  **§ 3.1 → QC-3.** The tail no longer says the one-time review is owed. Re-verified for this fold,
  not taken from the answer: `git show --stat 85d9fa7` lists `Cargo.lock`, `checks/deps.allow`,
  `checks/deps.review.md` and `crates/ka-reader-core/Cargo.toml`; at that commit the list's `cargo:`
  section holds 40 names and the record 40 rows, and `comm -3` of the two name sets prints
  nothing; `bash checks/no-network.sh` on `HEAD` prints "ok — 40 cargo names match
  checks/deps.allow". The answer's three additions are folded as written: the record is cited
  pinned to `ka-reader@85d9fa7`, because its title goes stale at the next added name; the dated
  clause "At `ka-reader@0aca57e` the list is one `cargo:` section of 17 names" stays as history, with
  the current count beside it; and RN-25 is left as written, its "still owed" being the dated
  account of v14 that this note closes, as RN-18 left RN-4's, RN-7's and RN-16's dated mentions. One word beyond the
  answer, under the same authority: the dated clause's "no record shows the review" becomes "until
  `ka-reader@85d9fa7` no record showed the review", because in the present tense it is now false.
  **§ 3.2 → QC-30 half (2) and § 9.** The exception names the package's build script — the file the
  `build` key of the registry copy's `Cargo.toml` names, `build.rs` at the root by default — per
  Cargo's manifest reference (https://doc.rust-lang.org/cargo/reference/manifest.html, § The
  `build` field), and excepts nothing where the key is `false` or the default file is absent.
  Re-measured for this fold over the 32 registry crates `cargo tree -p ka-reader-bridge --target
  aarch64-apple-darwin -e normal --locked --offline` resolves: 17 name a script (`tree-sitter` →
  `binding_rust/build.rs`; the six grammars → `bindings/rust/build.rs`; ten → `build.rs`), 14 set
  `false`, and `streaming-iterator` sets no key and has no root `build.rs`. A grep of the 17
  scripts for `mod …;`, `#[path` and `include!` prints nothing, which is the ground for the entry's
  *Not covered* sentence. `Cargo.lock` is unchanged between `ka-reader@85d9fa7` and `HEAD` (`git diff
  --stat 85d9fa7 HEAD -- Cargo.lock` prints nothing). § 9's bullet changes "a dependency's root
  `build.rs`" to "a dependency's build script", as the answer's addition (2) directs; its own
  "outside each crate's `build.rs`", about the product's crates, is not in the answer and stands.
  RN-24's mention is dated history and stays. The § 10 row carries no exception and does not move
  (the answer's addition (3)).
  **§ 2.1 → QC-30 half (2), drafted.** No owner answer stands behind this yet. The command half
  (2) names also names `ka-reader-bridge v0.0.0 (…/crates/ka-reader-bridge)` and `ka-reader-core v0.0.0
  (…/crates/ka-reader-core)` — re-run for this fold — and neither has a registry copy, so a script
  written to the entry's words failed every build before reading a dependency. Half (1) already
  holds both crates by name. The entry now scans only crates from outside the workspace and skips
  members by membership, not by a name list, which keeps every other unopenable crate a failure.
  This is the reading the entry's own "**(2) The linked dependency tree**" gives, but it changes
  what the check does, so it is drafted and put to the owner: `docs/architecture_open_issues.md`
  § 2.1.
  **What moved beneath this document, and ADR-0017.** `git log cc351c8..HEAD` over the seven inputs
  lists SDD v23 (`ka-reader@e81a386`) and UXD v11 (`ka-reader@24d652b`). UXD v11 moved UX-U1, the reader
  floor; `grep -n 'UX-U1' docs/nfdr.md` printed nothing before this note was written, so nothing
  here moves for it. SDD v23 names the grammar engine — tree-sitter, its runtime,
  `tree-sitter-highlight` and one grammar crate per floor language, built from C into `ka-reader-core`
  (`docs/SDD.md:L327`) — and adds § 9 TO-11 (`:L2252-L2265`), § 11 R-14 (`:L2566`) and two
  sentences to § 3's units paragraph (`:L339-L341`). TO-11 is a § 9 trade-off, one of the three
  surfaces a record is found on, so it was walked through the gates. It is surprising without its
  context — a core whose own source forbids `unsafe` parses the folder's bytes in C — and it was a
  real trade-off, with hand-written lexers and `syntect` weighed and ruled out
  (`ka-reader@85d9fa7:checks/deps.review.md` § *The engine chosen*). Whether it is hard enough to
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
  R-14, RN-80 at v23; `ka-reader@85d9fa7`, `ka-reader@e81a386`)*
- **RN-35:** *(v24 — the close: the cycle-21 fold, §§ 2.1 and 2.2 confirmed with an addition
  each)* **The fold.** The companion at intake held the two v23 drafts, both answered in the
  owner's seat by a `companion-self-answer` run (`docs/trail/architecture/self_answer-25.md`) and
  committed at `ka-reader@e49b34e`; it was copied whole before this fold as
  `docs/trail/architecture/cycle-21.md`. Nothing is left unresolved, so the companion is removed
  and `Status:` is Settled.
  **§ 2.1 → QC-30 and QC-58.** The draft stands: half (2) scans only crates from outside the
  workspace and skips a member by membership. The addition is folded as written. The workspace's
  members are a glob, `members = ["crates/*"]` (`Cargo.toml:L8`, re-read for this fold), so a
  crate created under `crates/` is a member with no manifest edit. Half (2) would skip it, and
  half (1) named three units, so it fell in neither half. Half (1) now names every workspace member
  and keeps `ka-reader-core` and `ka-reader-bridge` as today's examples. Its *verified by* points at the
  scope § 9's `checks/structure.sh` bullet already gives the script, "the product crates' sources
  outside `crates/*/tests/`", so that rule does not grow. Neither `checks/structure.sh` nor
  `checks/entry-points.sh` is on the tree yet (`ls checks/`, this fold), so no script moves. The
  entry sets each script's scope for the change that lands it, and until then the gate is
  `development-design` reading the entry, as the header says. One phrase beyond the answer, under
  the same authority: QC-58 called its units "the two crates and `ka-reader-mac`" and says its halves
  follow QC-30's, so it now reads "every workspace member (QC-30 half (1)) and `ka-reader-mac`". Left
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
  downstream (`ka-reader@b15a89a`). It was answered in the owner's seat by a `companion-self-answer`
  run (`docs/trail/architecture/self_answer-26.md`) and committed at `ka-reader@fdaa957`, and was
  copied whole before this fold as `docs/trail/architecture/cycle-22.md`. Nothing is left
  unresolved, so the companion is removed and `Status:` is Settled.
  **§ 3.1 → QC-14.** QC-14 said `checks/` is "never a dependency of `ka-reader-core`, `ka-reader-bridge`
  or `ka-reader-mac`", with no shipped/unshipped line, and `crates/ka-reader-core/tests/walk.rs:L6-L7`
  compiles `checks/walk.rs` into a `ka-reader-core` test target by `#[path]`. The answer reads the
  entry as its two sources already do — ADR-0016 "never a dependency of a shipped unit"
  (`docs/adr/0016-physical-unit-set-core-bridge-mac-checks.md:L40-L41`) and SDD § 3
  `read-only-harness` "Being a dependency of any shipped unit" (`docs/SDD.md:L332`), both re-read
  for this fold — so QC-14 had dropped the qualifier in transcription, and the entry was the copy.
  The first clause now says "any shipped unit" and names the three units as the artifacts that
  ship. The site conforms: Cargo compiles a `tests/` file as its own crate over the library's
  public API, so the edge runs `checks` → `ka-reader-core`, the direction QC-14 allows, and § 9's
  `checks/structure.sh` scope bullet already keeps `crates/*/tests/` out of every rule of the
  script, this one included. The trace tag names this note. § 10's QC-9 – QC-14 row needs no new
  command and does not move.
  **Not covered, named so it is not read as coverage.** A `#[path]` or `include!` from a unit's
  shipped source under `src/` into `checks/` would make `checks/` a dependency of a shipped unit
  and break QC-14. No such site exists — `grep -rn '#\[path\|include!' crates/` finds this test
  target and two `#[cfg(test)]` sites into `tests/common/` (`crates/ka-reader-core/src/lib.rs:L18-L19`,
  `crates/ka-reader-bridge/src/lib.rs:L10-L11`), re-run for this fold — so, per the answer, no rule
  of `checks/structure.sh` is owed for it until one occurs.
  **Inputs.** `git log a7e4445..HEAD` over the seven inputs prints nothing, and every input's
  `Status:` line was re-read and is Settled, so `Inputs read:` stands. No record is written or
  restatused, and no `QC` is added, renumbered or reused *(re: header `Status:`, `Version:`;
  QC-14; source: `docs/trail/architecture/cycle-22.md` § 3.1;
  `docs/trail/architecture/self_answer-26.md` § 3.1; `crates/ka-reader-core/tests/walk.rs:L6-L7`)*
- **RN-37:** *(v26 — the cycle-23 fold, §§ 3.1 – 3.4 answered; one draft for the owner's
  confirm)* **The fold.** The companion at intake was opened by the PM, not by a
  `product-architecture` run, with four items raised from downstream after `checks/structure.sh`
  and its suite landed (`ka-reader@463acb9`, opened at `ka-reader@c308b2f`). All four were answered in the
  owner's seat by a `companion-self-answer` run (`docs/trail/architecture/self_answer-27.md`), which
  also raised one unanswered choice, § 2.1; the companion was committed at `ka-reader@b083f99` and
  copied whole before this fold as `docs/trail/architecture/cycle-23.md`. § 2.1 stays open, so the
  companion is rewritten with it alone and `Status:` is Draft. Every fact below was re-measured at
  `ka-reader@b083f99`, not taken from the answers; `git diff --stat 463acb9 b083f99 --
  .github/workflows/ci.yml checks crates` prints nothing, so the pins to `ka-reader@463acb9` hold.
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
  now seven, and every step is cited pinned to `ka-reader@463acb9` at the lines the answer gives,
  re-read with `cat -n .github/workflows/ci.yml`. The bullet's opening citation of
  `Bundle probe suite` moves from `:L35-L36`, which at HEAD is `ka-reader-mac/assemble.sh`, to
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
  (`crates/ka-reader-core/src/lib.rs:L18-L24`, `crates/ka-reader-bridge/src/lib.rs:L10-L16`, both
  re-read), and so are their bodies' `std::fs` and `std::process` imports, which a reading by
  module would turn into QC-36 and QC-15 findings on the tree as built. The escape's reason now
  says the tree holds no *shipped* site. The escape stays a review catch at `development-design`,
  and no grep rule is owed until a shipped site appears, by RN-19's own terms. The bullet states
  that the two answers rest on each other, and cites the script's header for the gap
  (`checks/structure.sh:L101-L102`).
  **§ 2.1 → § 9's `ka-reader-mac` bullet, drafted.** No owner answer stands behind this yet. Two
  pointers in the *Toolchain* clause moved with the same six-line shift. `:L29` named
  `ka-reader-mac/assemble.sh` and at HEAD is `run: checks/structure.sh`. The step is now cited `:L35`
  at `ka-reader@463acb9`. The *no `swift --version` step* range `:L22-L29` is now `:L22-L35` under the
  same pin, with the whole-file grep beside it, which prints nothing. The draft is put to the owner
  at `docs/architecture_open_issues.md` § 2.1. If overridden, the clause keeps a pointer to the
  wrong step; nothing is gated on it.
  **What moved beneath this document.** `git log 3bbc6ce..HEAD` over the seven inputs lists SDD
  v24 (`ka-reader@542dc1c`), UXD v12 (`ka-reader@5b3040e`) and three DESIGN folds (`ka-reader@51148f9`,
  `ka-reader@d234b57`, `ka-reader@cec2b7d`). UXD v12 corrects its layout-reference inventory and "changes
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
  `checks/tests/` and `ka-reader-mac` bullets; § 10 preamble and nine rows; source:
  `docs/trail/architecture/cycle-23.md` §§ 2.1, 3.1 – 3.4;
  `docs/trail/architecture/self_answer-27.md` §§ 3.1 – 3.4; `docs/SDD.md` v24 § 3 `surfaces`, § 4
  C-I1, RN-82; `checks/structure.sh:L35-L102`; `.github/workflows/ci.yml` at `ka-reader@463acb9`)*
- **RN-38:** *(v27 — the close: the cycle-24 fold, § 2.1 confirmed)* **The fold.** The companion
  at intake held one choice, § 2.1, which this document's v26 fold had drafted (RN-37). It was
  confirmed in the owner's seat by a `companion-self-answer` run
  (`docs/trail/architecture/self_answer-28.md` § 2.1) and committed at `ka-reader@a3d0e1e`, then
  copied whole before this fold as `docs/trail/architecture/cycle-24.md`. That trail file is now
  where RN-37's pointer to `docs/architecture_open_issues.md` § 2.1 reads, because the companion
  is removed. **§ 2.1 → § 9's `ka-reader-mac` bullet.** The clause stands as v26 drafted it. Its
  two *drafted at v26* markers now also name the confirmation, in the form the same bullet's
  v15 correction takes (RN-27). This fold re-measured the answer's facts at HEAD
  `ka-reader@a3d0e1e` instead of taking them from it. `git diff --stat 463acb9 HEAD --
  .github/workflows/ci.yml` prints nothing, so the pin reads today's file. In that file `:L26` is
  `cargo test --workspace --locked && swift test --package-path ka-reader-mac`, `:L28-L32` are
  `Structure check` and `Structure check suite`, and `:L35` is `run: ka-reader-mac/assemble.sh`.
  `grep -n 'swift --version' .github/workflows/ci.yml` prints nothing and exits 1. At
  `ka-reader@0aca57e`, `:L29` is `run: ka-reader-mac/assemble.sh`, so the dated history the clause keeps
  is true. `ka-reader@463acb9` is a merge commit on `main`, so the pin stays reachable. ADR-0012's
  unpinned `ci.yml` citation does not move: a line pointer is no change of decision
  (`self_answer-28.md` § 2.1, check 3). **What moved beneath this document.** `git log
  7ef2386..HEAD` lists only the answer's own commit, `ka-reader@a3d0e1e`. Every input's `Status:`
  line was re-read and is Settled, so `Inputs read:` stands. No record is written or restatused,
  the index does not move, and no `QC` is added, renumbered or reused *(re: header `Status:`,
  `Version:`; § 9 `ka-reader-mac` bullet; source: `docs/trail/architecture/cycle-24.md` § 2.1;
  `docs/trail/architecture/self_answer-28.md` § 2.1; `.github/workflows/ci.yml` at
  `ka-reader@463acb9`, `ka-reader@0aca57e` and `ka-reader@a3d0e1e`)*
- **RN-39:** *(v28 — the close: the cycle-25 fold, § 3.1 answered)* **The fold.** The companion
  at intake held one item, § 3.1, raised from downstream by the PM on 2026-10-03 after
  `checks/entry-points.sh`, `checks/entry-points.allow` and `checks/tests/test_entry_points.sh`
  landed at `ka-reader@b158052`. It was answered in the owner's seat by a `companion-self-answer` run
  (`docs/trail/architecture/self_answer-29.md` § 3.1), committed at `ka-reader@6dae2ca`, and copied
  whole before this fold as `docs/trail/architecture/cycle-25.md`. Both halves are corrections:
  § 10's own rule and § 9's own pinned count read false against the tree. **§ 3.1 (a) → § 10's
  QC-30 / QC-58 linked-tree row** gains `(suite test_entry_points.sh)`, as § 10's preamble
  requires of a row naming a script that has a suite. The suite drives the real script against
  the allow list (`checks/tests/test_entry_points.sh:L8-L17`), so the tag stays inside what the
  script holds. **§ 3.1 (b) → § 9's `checks/tests/` bullet** counts eight suites, re-pinned to
  `ka-reader@b158052`, and the seven-suite sentence moves into the bullet's dated history beside the
  v25 six. The verified-by tail gains this fold's re-run. **Re-measured at HEAD `ka-reader@6dae2ca`,
  not taken from the answer.** `git diff --stat b158052 HEAD -- .github/workflows/ci.yml checks/`
  prints nothing. `ls checks/tests` lists eight `test_*.sh`. `ci.yml`'s `run:` lines `:L32`,
  `:L38`, `:L48`, `:L54`, `:L65`, `:L74`, `:L80` and `:L83` are the eight suites, with each
  step's `name:` on the line above. The bullet's loop prints nothing, and
  `grep -nE 'continue-on-error|^[[:space:]]+if:' .github/workflows/ci.yml` exits 1. **The
  hosted-runner record — the answer's addition, and one correction beyond it.** The answer asked
  the fold to write the entry-points pair's state the way the bullet wrote it for the five
  earlier suites. Writing it beside that paragraph showed the paragraph stale. It recorded the
  five as not yet run at `ka-reader@c26d47c`, and promised that the first push carrying them would
  be their reading and that this bullet would record it. That push happened and was never
  recorded: `git merge-base --is-ancestor ab39502 c79270f` exits 0, the same test against
  `37a962d` exits 1, and run 36034875098 on `ka-reader@c79270f` reads `success` on every suite step.
  The 2026-09-24 paragraph stays as dated history, and the v28 sentence after it records the
  reading. The same measurement shows `Structure check` and `Structure check suite`, which landed
  at `ka-reader@463acb9`, also unread: `git merge-base --is-ancestor 463acb9 origin/main` exits 1,
  and run 36958237363 on `ka-reader@d234b57` lists neither step. So the sentence names the four
  pending steps, not two. This goes beyond the answer's words. It applies the bullet's own rule,
  "this bullet records it", and makes no new decision: nothing is moved, quieted or reclassified.
  Two failed runs since, 36761379052 and 36769305658, failed at `Test gate`, not at a suite step,
  so they change no suite's reading. **What moved beneath this document.** `git log
  f8fb6d8..HEAD` lists the entry-points change merged at `ka-reader@b158052`, the PM's two companion
  openings, and SDD v25 (`ka-reader@0670083`). SDD v25 moves only § 3's `read-only-harness` *Owns*
  cell (SDD RN-84). This document cites that row for its *Must not own* cell in § 1, and by name
  in two trace tags, one in § 2 and one in § 9. None of the three moves: the *Must not own* cell
  is unchanged, and the row still holds every script those tags name. SDD RN-84 names § 9's count and § 10's row as owed here, which is
  this fold. Every input's `Status:` line was re-read and is Settled, so `Inputs read:` stands.
  No record is written or restatused, the index does not move, and no `QC` is added, renumbered
  or reused. § 9's tail ground, `ls checks/*.sh` at `ka-reader@ab39502`, stays true at its pin and
  is not re-pinned *(re: header `Status:`, `Version:`; § 9 `checks/tests/` bullet; § 10 QC-30 /
  QC-58 linked-tree row; source: `docs/trail/architecture/cycle-25.md` § 3.1;
  `docs/trail/architecture/self_answer-29.md` § 3.1; `.github/workflows/ci.yml` at
  `ka-reader@b158052` and `ka-reader@6dae2ca`; GitHub Actions runs 36034875098, 35988399477 and
  36958237363; `docs/SDD.md` v25 RN-84)*
- **RN-40:** *(v29 — the cycle-26 fold, § 3.1 answered; one draft for the owner's confirm)*
  **How the companion came to exist.** As at RN-26 and RN-39, no `product-architecture` run opened
  it. The NFDR was Settled at v28 with no companion on disk. The PM opened it on 2026-10-03
  (`ka-reader@bf9b90c`) after `checks/structure.sh` gained the unit-graph rules (`ka-reader@8c3ab40`),
  with one item raised from downstream, § 3.1. A `companion-self-answer` run answered § 3.1 in the
  owner's seat and appended § 2.1 in the bucket *Choices to confirm*, with its slot empty
  (`ka-reader@803b599`; its reasoning, `docs/trail/architecture/self_answer-30.md`). As answered, the
  companion is `docs/trail/architecture/cycle-26.md`. **§ 3.1 → QC-11's trace.** The answer is
  reading (a): QC-11 stands as written and the `fs-reader` → `folder-model` edge goes. QC-11's
  text and QC-10's "neither imports the model" do not move. The trace now records the reading of
  SDD SM-1 the answer fixed, and where the clause is held from. The answer's ground was re-read
  at `ka-reader@803b599`, not taken from it. `docs/SDD.md:L415` gives SM-1's owner as the model,
  which "states what a read must return"; `:L416` says SM-2's port "is a trait the model owns";
  `:L347-L348` is the units paragraph QC-11 transcribes. `fs_reader.rs:L14` is
  `use crate::folder_model::OpenFailure;`, `folder_model.rs:L38` defines the type, and
  `folder_model.rs:L6` imports the other SM-1 types from `fs_reader`, which QC-10 allows.
  `lib.rs:L10-L12` re-exports `OpenFailure` from `folder_model`, and
  `crates/ka-reader-bridge/src/session.rs:L9` imports it as `ka_reader_core::OpenFailure`, so a move
  that keeps the re-export leaves the bridge alone. `checks/structure.sh` *WHAT IS NOT HELD*
  names the clause and its site, and that stays true until the move lands. No SDD change is owed:
  SM-1 already says what is true under (a), and that judgment is the answer's. **§ 2.1 → QC-63,
  drafted.** The item was raised by the self-answer run, not asked of it, so no answer authorizes
  it. This run drafts it into the records the way RN-26 drafted the item that run raised, and it
  stays in the companion for the owner's confirm. Re-measured at `ka-reader@803b599`:
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
  `docs/trail/architecture/self_answer-30.md`; `crates/ka-reader-core/src/` and
  `checks/structure.sh` at `ka-reader@803b599`; `docs/SDD.md` § 3)*
- **RN-41:** *(v30 — the close: the cycle-27 fold, § 2.1 confirmed with an addition)* **The fold.**
  The companion at intake held one item, § 2.1, the QC-63 draft RN-40 wrote for the owner's
  confirm. A `companion-self-answer` run answered it in the owner's seat
  (`docs/trail/architecture/self_answer-31.md` § 2.1), committed at `ka-reader@61295fb`, and copied
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
  HEAD `ka-reader@61295fb`, not taken from the answer.** `git diff --stat 803b599 HEAD -- crates
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
  `crates/ka-reader-core/src/` at `ka-reader@61295fb`; `docs/SDD.md` § 3;
  `docs/adr/0016-physical-unit-set-core-bridge-mac-checks.md`)*
- **RN-42:** *(v31 — the close: the cycle-28 fold, § 3.1 answered)* **The fold.** The companion
  at intake was opened by the PM, not by a `product-architecture` run, with one item raised from
  downstream after `fs_reader`'s test body moved under `crates/ka-reader-core/tests/unit/`
  (`ka-reader@73c408e`, opened at `ka-reader@7a8f61d`). A `companion-self-answer` run answered it in the
  owner's seat (`docs/trail/architecture/self_answer-32.md` § 3.1), committed at `ka-reader@456098c`,
  and copied whole before this fold as `docs/trail/architecture/cycle-28.md`. The verdict is
  *confirmed with addition*. **§ 3.1 → § 9's `checks/structure.sh` scope bullet.** The bullet named
  two `#[cfg(test)]` `#[path]` sites, and the tree holds three. The third,
  `crates/ka-reader-core/src/fs_reader.rs:L894-L896`, is named beside the two `test_support` sites.
  The answer's three additions are folded with it. (1) The sentence that both bodies import
  `std::fs` and `std::process` stays about the two `test_support` bodies and is not widened: the
  third body imports no `std::process`, and its filesystem use sits in `fs-reader`, a file QC-15
  exempts. (2) The findings list is re-measured, not extended by one name. The script gained its
  QC-2 rule at `ka-reader@e7f151e`, in the same merge as the body move, so the core's `test_support`
  body raises QC-2 too, and QC-9, whose process clause the script has carried since v1.0.0, was
  missing from the list since v26. (3) The count, the lines and the findings are pinned to a
  commit and the command that prints the sites, `grep -rn '#\[path' crates/*/src`, the form § 9's
  `checks/tests/` bullet already takes for its suite count. The bullet's dated tail records what
  it said through v30. RN-36's "two `#[cfg(test)]` sites" is a dated fold note and stands as
  written. **Re-measured at HEAD `ka-reader@456098c`, not taken from the answer.** `git diff --stat
  7a8f61d HEAD -- crates checks .github ka-reader-mac` prints nothing, so the answer's measurement at
  `ka-reader@7a8f61d` is a measurement of this tree. `grep -rn '#\[path' crates/*/src` prints
  exactly the three sites. The third body's first lines carry no `std::process` import
  (`crates/ka-reader-core/tests/unit/fs_reader.rs:L1-L6`), and `:L753` and `:L953` are `fs::write`
  calls. On a throwaway clone, the unmodified `checks/structure.sh` printed `12 Rust files in 2
  crates read — nothing found`. Each `tests/common/mod.rs` body was then copied into its crate's
  `src/`, and the `fs_reader` test body was appended to `fs_reader.rs` so the owner exemption still
  applied to it. The same script then reported QC-2 (nine lines), QC-9 (one), QC-15 (two) and
  QC-36 (one) in `ka-reader-core`, and QC-15 (three) and QC-36 (one) in `ka-reader-bridge`. The escape
  sentence still holds, because all three sites carry `#[cfg(test)]`. No record names these sites
  (`grep -rnE '#\[path|tests/unit|tests/common|test_support' docs/adr` prints nothing). **What
  moved beneath this document.** `git log 0b62d5f..HEAD -- docs/SRS.md docs/SDD.md docs/fdr.md
  docs/PRD.md docs/UXD.md docs/DESIGN.md docs/CONTENT.md docs/adr` prints nothing. Every input's
  `Status:` line was re-read and is Settled, so `Inputs read:` stands. No `QC` is added,
  renumbered or reused, no record is written or restatused, and the index does not move. Nothing
  is left for the owner, so the companion is removed and `Status:` is Settled *(re: header
  `Status:`, `Version:`; § 9 `checks/structure.sh` scope bullet; source:
  `docs/trail/architecture/cycle-28.md` § 3.1; `docs/trail/architecture/self_answer-32.md` § 3.1;
  `crates/` and `checks/structure.sh` at `ka-reader@456098c`)*
- **RN-43:** *(v32 — the cycle-29 fold, §§ 3.1 – 3.5 answered; a re-derivation against SDD v26
  and v27; two items for the owner)* **The fold.** The companion at intake was opened by the PM,
  not by a `product-architecture` run, with five items raised from downstream after `git-reader`
  landed (`ka-reader@126ef75`, opened at `ka-reader@136b227`). A `companion-self-answer` run answered all
  five in the owner's seat (`docs/trail/architecture/self_answer-33.md`), raised one of them
  upstream, and added two § 2 items whose slots it left for the next round. The answers were
  committed at `ka-reader@0955e9e`, and the companion was copied whole before this fold as
  `docs/trail/architecture/cycle-29.md`. **§ 3.1 → ADR-0018, QC-5.** A new record supersedes
  ADR-0005, as the answer ordered. A `.git` file answers `root` from its own content, and the Git
  directory it names is `state()`'s to report. That is SDD § 11 R-3's reading, which FDR R-15 and
  R-21 already follow. `probe` reads only inside the folder, which replaces ADR-0005's "reading …
  nothing" that the adapter never met. QC-5 gains the clause and three named cases, none of them
  written at `ka-reader@8edec4f`, so the entry says they go red until the provisional arm is replaced.
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
  The answer raised the unit question upstream (`docs/SDD_open_issues.md` § 2.1, `ka-reader@4f028c7`).
  The SDD folded it at v27 (`ka-reader@8edec4f`; its RN-87), in the CTO's seat, after this companion's
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
  § 3 state, at `crates/ka-reader-core/Cargo.toml:L9`. QC-30 was left unconfirmed and is drafted here
  differently from the item's proposal, for two reasons this fold measured. First, the item's three
  reads are not the whole set. libgit2's compiled C carries `git__getenv` at more sites. The open
  reaches the three init reads, and `SUDO_UID` only when the effective user is root
  (`fs_path.c:L2030-L2033`). The rest sit behind calls the port does not make, or in `src/cli`,
  which `build.rs` does not compile. The item's open question is closed: `libz-sys`'s zlib-ng file
  is not compiled, because `want_ng` needs a zlib-ng feature (`build.rs:L15-L18`), and the debug
  build's script output links the system `libz` after a `-lz` smoke test
  (`target/debug/build/libz-sys-*/output`). A grep of the C sources of the 37 crates
  `cargo tree -p ka-reader-bridge --target aarch64-apple-darwin -e normal --locked` resolves finds
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
  were written with. **Re-measured at HEAD `ka-reader@8edec4f`, not taken from the answers.** `git log
  126ef75..HEAD -- crates checks ka-reader-mac .github Cargo.toml Cargo.lock` prints nothing, so the
  answers' measurements at `ka-reader@4160b57` and `ka-reader@136b227` are measurements of this tree. The
  lines cited read as quoted: `libgit2.rs:L31`, `:L35`, `:L38-L40`, `:L52`, `:L63`;
  `git_reader.rs:L33`; `Cargo.toml:L9`; `root_finding.rs:L158-L169`; `structure.sh:L76-L78`,
  `:L247`, `:L249-L250`, `:L257-L258`; `entry-points.sh:L66`; `grep -n 'nm ' checks/view.sh`
  prints nothing; `grep -n 'GitPort\|git_reader\|RootFinding\|ProbeCondition'
  crates/ka-reader-core/src/folder_model.rs` prints nothing. **What moved beneath this document.**
  `git log c6b2fa8..HEAD -- docs/SRS.md docs/SDD.md docs/fdr.md docs/PRD.md docs/UXD.md
  docs/DESIGN.md docs/CONTENT.md` names only the SDD's three commits, v26 at `ka-reader@4160b57`, a
  Draft stamp at `ka-reader@3cfeb35`, and v27 at `ka-reader@8edec4f`. The SDD is Settled at v27, and every
  input's `Status:` line was re-read and is Settled, so `Inputs read:` stands. **Not weighed here,
  and named.** SDD RN-85 names `Security`, `CoreFoundation`, `iconv` and `z` as linked for the
  bridge's static library (`ka-reader-mac/Package.swift:L32-L37`), and leaves open whether C-R7 says
  anything about `Security`. QC-8 and QC-23 restate C-R7's link list and do not move until it does.
  No `QC` is added, renumbered or reused. Two items await the owner, so `Status:` is Draft *(re:
  header `Status:`, `Version:`; QC-3, QC-5, QC-6, QC-9, QC-10, QC-11, QC-13, QC-15, QC-17, QC-30,
  QC-35; the traces of QC-7, QC-18, QC-26, QC-36, QC-50; § 10's QC-3, QC-15/QC-17, QC-30 and QC-35
  rows; ADR-0018, ADR-0019, ADR-0020; source: `docs/trail/architecture/cycle-29.md`;
  `docs/trail/architecture/self_answer-33.md`; `docs/SDD.md` v26 and v27, RN-85, RN-87;
  `docs/trail/sdd/self_answer-34.md` § 2.1; `crates/` and `checks/` at `ka-reader@8edec4f`; the
  registry copies of `libgit2-sys 0.18.8+1.9.7`, `libz-sys 1.1.29` and `git2 0.21.0`)*
- **RN-44:** *(v33 — the close: the cycle-30 fold, §§ 2.1 and 2.2 confirmed, each with an
  addition)* **The fold.** The companion at intake was the one v32 wrote, with two § 2 items. A
  `companion-self-answer` run confirmed both in the owner's seat, each with an addition
  (`docs/trail/architecture/self_answer-34.md`). The answers were committed at `ka-reader@2f15e2c`, and
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
  does not find it out by a malformed-line failure. **Re-measured at HEAD `ka-reader@2f15e2c`, not
  taken from the answers.** `git log 8edec4f..HEAD -- docs/SRS.md docs/SDD.md docs/fdr.md
  docs/PRD.md docs/UXD.md docs/DESIGN.md docs/CONTENT.md crates checks ka-reader-mac .github Cargo.toml
  Cargo.lock` prints nothing. `cargo tree -p ka-reader-bridge --target aarch64-apple-darwin -e normal
  --locked` resolves 37 crates. A grep of the `.c`, `.h`, `.cc` and `.cpp` files in their registry
  copies finds `getenv` in `libgit2-sys` (10 files) and `libz-sys` (1), and whole-word `environ` or
  `_NSGetEnviron` in `libgit2-sys` (1) alone. The lines cited read as quoted: `process.c:L21-L23`,
  `:L113`, `:L128`; `build.rs:L208`; `grep -rln git_process_new libgit2/src` names only
  `process.h`, the two `process.c` files and `transports/ssh_exec.c`; `sysdir.c:L347`, `:L357`,
  `:L402-L405`, `:L458-L459`, `:L559-L560`; `fs_path.c:L2030-L2033`; `entry-points.sh:L55`, `:L66`;
  `entry-points.allow:L10`, `:L16`, `:L20-L21`, `:L23-L26`; `Cargo.toml:L8`, `:L11`, `:L16`;
  `crates/ka-reader-bridge/Cargo.toml:L11-L15`. **What moved beneath this document:** nothing. Every
  input's `Status:` line was re-read and is Settled, so `Inputs read:` stands. No `QC` is added,
  renumbered or reused. Nothing is left for the owner, so the companion is removed and `Status:` is
  Settled *(re: header `Status:`, `Version:`; § 1's opening; QC-30; the traces of QC-8 – QC-17,
  QC-20, QC-24, QC-35, QC-61, QC-63; § 10's QC-30 row and its list of entries with no row; ADR-0016's
  Status line; ADR-0020; the index; source: `docs/trail/architecture/cycle-30.md` §§ 2.1, 2.2;
  `docs/trail/architecture/self_answer-34.md`; `checks/` and `Cargo.toml` at `ka-reader@2f15e2c`; the
  registry copies of `libgit2-sys 0.18.8+1.9.7`, `libz-sys 1.1.29` and `git2 0.21.0`)*
- **RN-45:** *(v34 — the cycle-31 fold, § 3.1 confirmed with three additions; § 2.1 drafted for
  the owner)* **The fold.** The companion at intake was opened by the PM, not by a
  `product-architecture` run, with one item raised from downstream: `checks/structure.sh` holds the
  `git-reader` adapter's file as a third QC-15 filesystem owner (`ka-reader@48308ff`), and QC-15's
  *verified by* still described the script as it stood before. A `companion-self-answer` run
  answered it in the owner's seat (`docs/trail/architecture/self_answer-35.md` § 3.1) and raised a
  § 2 item on QC-5, whose slot it left for the next round. The answer was committed at
  `ka-reader@cd88d52`, and the companion was copied whole before this fold as
  `docs/trail/architecture/cycle-31.md`. **§ 3.1 → QC-15.** The tail names the three exact-path
  owner files and the exempting `case`, pinned at `ka-reader@48308ff`. It drops "names QC-15's other
  owners as not held" and the rule still to come, which RN-43 named as this document's realization
  and which has now landed. That is the header's own rule: a rule becomes executable in the change
  that adds it to the command. The three additions are folded as answered. (1) The tail names the
  two suite cases that hold the exemption to the exact path and to this clause only. (2) The
  `Path`-method gap stays, for every crate, re-pinned to the script's *GAPS* (`:L266-L267`), and
  only the `development-design` gate narrows, to the two parts the script lists as unheld
  (`:L253-L256`). (3) No record moves. ADR-0018 binds QC-15, and its citations are pinned at
  `ka-reader@8edec4f`, where they still read as quoted: its decision did not change, and its
  realization landed. **What this run adds beyond the answer:** the tail argues its class-2 half in
  the script's own reasons. The script admits every filesystem form inside an owner file, and a
  `Path` method names no filesystem module, so a source scan cannot tell a read inside the folder
  from one past it (`:L253-L256`, `:L266-L267`). The answer named the two parts and did not argue
  them, and a class-2 tail must (`principal_architect_create_architecture.md` § *Every constraint is
  traced, and named-verifiable*). **§ 2.1 of the companion → QC-5, drafted, for the owner.** The
  self-answer run raised it with a proposal and no draft in the records. This run drafts it, as
  RN-43 did with the § 2 items that run raised, and leaves the slot for the owner. QC-5's tail
  states the three named cases as written and passing at `ka-reader@48308ff`, cites the adapter's
  `.git`-file arm and CI's command, and keeps the old "none written / go red until" sentences as a
  dated parenthetical. § 10's QC-5 row does not move: it names the same command. ADR-0018 does not
  move either. Its § Consequences already says the missing-directory case goes red if `probe`
  follows the pointer. **Re-measured at HEAD `ka-reader@cd88d52`, not taken from the answers.** `git
  diff --stat 48308ff HEAD -- checks crates ka-reader-mac .github Cargo.toml Cargo.lock` prints
  nothing, so a pin at the merge is a pin on this tree. `bash checks/structure.sh` prints "14 Rust
  files in 2 crates read — nothing found" and exits 0. `bash checks/tests/test_structure.sh` exits 0
  with 88 `ok` lines, the two cases named above among them. `cargo test --locked -p ka-reader-core
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
  §§ 3.1, 2.1; `checks/`, `crates/` and `.github/` at `ka-reader@cd88d52`)*
- **RN-46:** *(v35 — the close: the cycle-32 fold, § 2.1 confirmed with one addition)* **The
  fold.** The companion at intake held one item, § 2.1, which the v34 run drafted into QC-5's
  *verified by*. It was answered in the owner's seat (`docs/trail/architecture/self_answer-36.md`
  § 2.1) and committed at `ka-reader@899be3d`. The companion was then copied whole, before this fold, as
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
  traced, and named-verifiable*). **Re-measured at HEAD `ka-reader@899be3d`, not taken from the
  answer.** `cargo test --locked -p ka-reader-core --test root_finding` prints "37 passed; 0 failed",
  and the three QC-5 cases are among them. `git diff --stat 48308ff HEAD -- checks crates ka-reader-mac
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
  `docs/trail/architecture/self_answer-36.md` § 2.1; `crates/` at `ka-reader@899be3d`)*
- **RN-47:** *(v36 — a re-derivation on a new upstream sentence; nothing folded from the owner)*
  **Intake.** The companion on disk held two items, and neither answer slot was filled: § 2.1
  (QC-47's sibling wording, appended at `ka-reader@f0789a6` by a `companion-self-answer` run in the
  CTO's seat) and § 3.1 (QC-15's list, raised by the PM at `ka-reader@df55117`). No `product-architecture`
  run wrote either. With no slot filled, nothing is consumed and no trail cycle is written. **What
  moved beneath this document.** `git log 4a91621..HEAD -- docs/SRS.md docs/SDD.md docs/fdr.md
  docs/PRD.md docs/UXD.md docs/DESIGN.md docs/CONTENT.md` names five commits: the SDD's cycle-23 and
  cycle-24 folds (v28, v29) with their answer commits, and CONTENT v10. **SDD v29 → QC-47.** § 4 C-I1
  now says a failed read "changes no other item", and that each sibling "holds the state its own read
  gave it: `observed`, `pending`, `failed` or `stopped`" (`docs/SDD.md:L686-L690`). S-5's command half
  says the same (`:L1799-L1801`). QC-47's *verified by* repeated the old wording, "`observed` on its
  siblings", which a folder holding a folder cannot meet: a folder entry not yet read is `Pending`
  (`crates/ka-reader-core/src/fs_reader.rs:L853` at `ka-reader@77c91fc`). QC-47 traces to C-I1, so the
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
  test between cases 2 and 3). The item is dropped. Its text is the companion at `ka-reader@f0789a6`,
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
  `--test watch`, which does not exist at `ka-reader@77c91fc` (`ls crates/ka-reader-core/tests/`). No `QC`
  is added, renumbered or reused, no record is written or restatused, the index and § 10 do not
  move. A companion stays on disk, so `Status:` moves from Settled to Draft *(re: header `Status:`,
  `Version:`; QC-47; source: `docs/SDD.md` v29 § 4 C-I1, § 6 S-5, RN-89; `docs/trail/sdd/cycle-24.md`
  § 2.1; `docs/architecture_open_issues.md` § 2.1 at `ka-reader@f0789a6`)*
- **RN-48:** *(v37 — the close: the cycle-33 fold, § 3.1 answered)* **The fold.** The companion
  at intake held one item, § 3.1, which the PM raised against QC-15's list of `git-reader`'s reads
  outside libgit2. It was answered in the owner's seat (`docs/trail/architecture/self_answer-37.md`
  § 3.1) and committed at `ka-reader@46c7ab0`. The companion was then copied whole, before this fold, as
  `docs/trail/architecture/cycle-33.md`. **§ 3.1 → QC-15.** The list names the two kinds the adapter
  makes and the list left out, in the answer's words: the metadata, and a link's own text, at each
  position inside the folder along the spelled path to the Git directory and to the common
  directory; and the content of the `commondir` file in a Git directory that lies inside the folder.
  The list's items are now separated by semicolons, because the new item carries commas of its own.
  The bound, "never a path past the folder and never a link followed out of it", stays as written.
  The answer corrects a list that read as complete. It does not widen the read-only promise, and
  QC-35 does not move. **Re-measured at HEAD `ka-reader@46c7ab0`, not taken from the answer.** `git diff
  --stat 6a0725c HEAD -- crates checks ka-reader-mac .github Cargo.toml Cargo.lock` prints nothing, so
  every citation at `6a0725c` reads at HEAD. The lines read as quoted: `libgit2.rs:L102-L127`
  (`verified_locations`), `:L115` (the `commondir` read), `:L138-L142` (an outside location
  refused), `:L162-L172` (`inspect_on_disk`: `symlink_metadata` at `:L163`, `read_link` at `:L166`),
  `:L200-L202` (no position outside the folder, and not the folder itself, is inspected), and
  `:L275-L291` (`read_spelling_file`, opened with `O_NOFOLLOW` at `:L276-L279`). `bash
  checks/structure.sh` prints "14 Rust files in 2 crates read — nothing found" and exits 0. `bash
  checks/tests/test_structure.sh` exits 0 with 88 `ok` lines, and QC-15's two cases are among them.
  **What this run adds beyond the answer.** (1) The answer adds `:L163` to the tail's list of
  `Path`-method reads, "re-pinned at that commit". The list's old locators were pinned at
  `ka-reader@48308ff`, and `libgit2.rs` has since moved (`git diff --stat 48308ff 6a0725c` shows 448
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
  v36 commit, `ka-reader@5a1e13f`. **Weighed and left as written.** ADR-0018's four-kind list is scoped to
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
  `docs/trail/architecture/self_answer-37.md` § 3.1; `crates/` and `checks/` at `ka-reader@6a0725c`)*
- **RN-49:** *(v38 — the cycle-34 fold, § 3.1 and § 3.2 answered; a re-derivation on SDD v30 and
  v31; § 2.1 drafted for the owner; ADR-0021 proposed)* **Intake.** The companion on disk was opened
  by the PM at `ka-reader@0aab3e7`, not by a `product-architecture` run, with two items raised from
  downstream: QC-3's `nm` read (§ 3.1) and QC-17's search-path switch (§ 3.2), each stated as
  still to come after the build at `ka-reader@392177d` had landed both. A `companion-self-answer` run
  answered both in the owner's seat and added § 2.1 on QC-11, leaving its slot empty
  (`docs/trail/architecture/self_answer-38.md`). The answers were committed at `ka-reader@2aed844`,
  and the companion was copied whole before this fold as `docs/trail/architecture/cycle-34.md`.
  **§ 3.1 → QC-3.** Half (3) is held by `checks/view.sh` from `ka-reader@392177d`, with the read's
  locators, its suite cases and the three CI steps. The sentence that said the read was not in the
  script, and its clause that no bridge function reached `git-reader`, go. The tail states what the
  read has met, and has not, in SDD § 4 C-I3's terms at v31, with nothing further owed. Beside "The
  three names are a floor" it names C-R6's three defined symbols the pattern does not match, unread
  and not widened for. The trace is re-pinned to C-R6 and C-I3 at v31. **§ 3.2 → QC-17.** The tail
  names the switch's file, the read-back test and its locators, and the gate, which is the bridge's
  suite under `cargo test --workspace --locked` in CI. It names the tests that hold the fail-closed
  and once-per-process halves, which the read-back cannot see. The two sentences that put the
  switch and its test outside the tree go. The violation clause stays as written. The trace is
  re-pinned to C-I3 at v31. **Re-measured at HEAD `ka-reader@2aed844`, not taken from the answers.**
  `git diff --stat 392177d HEAD -- crates checks ka-reader-mac .github` prints nothing. Each locator
  both answers cite was opened and reads as quoted: `checks/view.sh:L379-L404`;
  `checks/tests/test_view.sh:L58-L64`; `.github/workflows/ci.yml:L26`, `:L41`, `:L51`, `:L54`;
  `crates/ka-reader-bridge/src/exports.rs:L105`; `tests/search_path.rs:L36`, `:L47-L55`;
  `src/machine_config.rs:L213`, `:L249`, `:L262`; `src/session.rs:L1729`, `:L1740`; and `docs/SDD.md`
  `:L639-L645` and `:L759-L785`. `grep -rn ka_reader_read_git ka-reader-mac` prints nothing. This run
  executed `cargo test --locked -p ka-reader-bridge` (every target `ok`, `search_path` 1 of 1),
  `bash checks/tests/test_view.sh` (exit 0, 28 `ok` lines), and `bash checks/view.sh` on the release
  bundle on disk, last modified 2026-10-04 08:20 (exit 0, "carries no Git transport — nothing
  found"). That this bundle is the build of a given commit rests on the file's time and on
  `self_answer-38.md`, and was not otherwise shown. **What moved beneath this document.** `git log
  b716c7b..HEAD -- docs/SDD.md` names the SDD's cycle-25 and cycle-26 folds (v30, v31,
  `ka-reader@51de784`, `ka-reader@27e2bbf`). Neither raised an item on this companion (SDD RN-90, RN-91,
  each under *Downstream*). A new upstream sentence is a fresh authorization for a settled entry
  (`principal_architect_create_architecture.md` § *Two lifecycles*), so each entry that traces to
  a moved sentence was re-read against it. (1) **SM-4's list is ten** (SDD § 3 SM-4, § 10 RC-4,
  RN-90). QC-24 named the nine and held the exported set inside them, while the tree's export test
  admits `ka_reader_read_git` (`crates/ka-reader-bridge/tests/exports.rs:L17-L23`). Read as written, the
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
  (`grep -rln git2 crates/ka-reader-bridge`). The slot is left for the owner. (b) **ADR-0021, Proposed —
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
  at `ka-reader@2aed844`)*
- **RN-50:** *(v39 — the close: the cycle-35 fold, § 2.1 and § 2.2 confirmed)* **The fold.** The
  companion at intake was the one v38 wrote, with two § 2 items. A `companion-self-answer` run
  confirmed both in the owner's seat, § 2.2 with one addition (`docs/trail/architecture/self_answer-39.md`),
  and the answers were committed at `ka-reader@98e35f8`. A `product-architecture` run then stopped short
  of accepting ADR-0021 with only a self-answer behind it, and the owner confirmed § 2.2, the addition
  kept, in an interactive session (`ka-reader@bb75290`). A second self-answer run found nothing left to
  decide (`docs/trail/architecture/self_answer-40.md`, `ka-reader@16f1ce1`). The companion was copied
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
  `ka-reader@16f1ce1`, not taken from the answers.** `git log 566558b..HEAD -- docs/SRS.md docs/SDD.md
  docs/fdr.md docs/PRD.md docs/UXD.md docs/DESIGN.md docs/CONTENT.md crates checks ka-reader-mac
  .github Cargo.toml Cargo.lock` prints nothing. `checks/structure.sh:L257-L258` still names QC-11's
  libgit2 clause under *WHAT IS NOT HELD*, and `grep -rln git2 crates/ka-reader-bridge` prints the
  manifest, `src/machine_config.rs` and `tests/search_path.rs`, the three files the tail names.
  `crates/ka-reader-bridge/src/exports.rs:L105` is `ka_reader_read_git`, the export test admits it
  (`crates/ka-reader-bridge/tests/exports.rs:L17-L23`), and `grep -rn ka_reader_read_git ka-reader-mac` prints
  nothing. This run executed `cargo test --locked -p ka-reader-bridge` (every target `ok`; `exports` 11
  of 11, `search_path` 1 of 1) and `bash checks/structure.sh` (exit 0, "15 Rust files in 2 crates
  read — nothing found"). **What moved beneath this document:** nothing. Every input's `Status:`
  line was re-read and is Settled, so `Inputs read:` stands. No `QC` is added, renumbered or reused.
  § 10 does not move: no row names a record. Nothing is left for the owner, so the companion is
  removed and `Status:` is Settled *(re: header `Status:`, `Version:`; QC-11; the traces of QC-1,
  QC-2, QC-8, QC-9, QC-15, QC-16, QC-24, QC-30, QC-32, QC-34, QC-36; ADR-0013's Status line;
  ADR-0021; the index; source: `docs/trail/architecture/cycle-35.md` § 2.1, § 2.2;
  `docs/trail/architecture/self_answer-39.md`, `self_answer-40.md`; `ka-reader@bb75290`; the tree at
  `ka-reader@16f1ce1`)*
- **RN-51:** *(v40 — the close: a re-derivation on SDD v32)* **Intake.** The companion on disk had
  one item, § 2.1, opened at `ka-reader@250fc6e` by a `companion-self-answer` run in the CTO's seat
  while it answered the SDD's companion, not by a `product-architecture` run
  (`ka-reader@250fc6e:docs/architecture_open_issues.md` § 2.1; reasoning
  `docs/trail/sdd/self_answer-39.md`). It proposed that QC-6 and QC-35 state the config-named-path
  item's bound as the SDD's *Open Questions* item would state it after the SDD's fold, with a stated
  doubt: the change was owed only once `product-sdd` had folded, and the item was to stay open if
  the SDD still stated the old bound. Its slot was not filled, so the companion is not consumed and
  no trail cycle is written. **What moved beneath this document.** `docs/SDD.md` v31 → v32, Settled
  (`ka-reader@19a76bc`, SDD RN-92, `docs/trail/sdd/cycle-27.md` § 5.1): the item's bound is "before the
  slice is reached" alone, the clause naming the build in which `mac-shell` first calls
  `ka_reader_read_git` is removed, the bound is held by review of the change after which
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
  added the item after it at `ka-reader@77c91fc`. **Re-measured at HEAD `ka-reader@19a76bc`.** `git log
  d2dd1f2..HEAD -- docs/SRS.md docs/fdr.md docs/PRD.md docs/UXD.md docs/DESIGN.md docs/CONTENT.md
  crates checks ka-reader-mac .github Cargo.toml Cargo.lock` prints nothing. `git diff d2dd1f2..HEAD --
  docs/SDD.md` is the v32 fold alone, read whole. `grep -rn 'ka_reader_read_git\|read_git\|readGit'
  ka-reader-mac/Sources` prints nothing. Every input's `Status:` line was re-read and is Settled, so
  `Inputs read:` stands. **Known limits.** This run read the SDD's v32 diff whole and the SRS and
  FDR at their status lines; their bodies did not move after v39, which derived from them. It built
  nothing and ran no test: it changes no code. **The companion.** Nothing is left for the owner, so
  it is removed and `Status:` is Settled *(re: header `Status:`, `Version:`; QC-6; QC-35; source:
  `docs/SDD.md` v32, SDD RN-92; `docs/trail/sdd/cycle-27.md` § 5.1;
  `ka-reader@250fc6e:docs/architecture_open_issues.md` § 2.1; the tree at `ka-reader@19a76bc`)*
- **RN-52:** *(v41 — the close: a re-derivation on SDD v33)* **Intake.** The companion on disk had
  no `product-architecture` run behind it: the PM opened it on 2026-10-04 with two § 3 items
  (`ka-reader@cfcbedf`), and a `companion-self-answer` run answering `docs/SDD_open_issues.md` § 5.2
  added to § 3.1 (`ka-reader@f3aa266`). Neither **Answer** slot was filled, so the companion is not
  consumed and no trail cycle is written. It was clean in git at intake. **What moved beneath this
  document.** `docs/SDD.md` v32 → v33, Settled (`ka-reader@c120c95`, SDD RN-93,
  `docs/trail/sdd/cycle-28.md` §§ 5.1, 5.2): § 4 C-I3 states that the `nm` read has met two
  executables, the second the first that links `ka_reader_read_git`, from `ka-reader@129586e`, and that it
  passed; § 4 C-R6 pins its three unmatched defined symbols to that executable; § 11 R-15 is kept,
  its *shows up as* a red read on any release build, its *response* that the change whose build turns
  the read red does not land until a re-cut is recorded in § 10. Nothing else among the inputs moved:
  `git diff --stat 60a618f HEAD -- docs ':!docs/trail'` lists `docs/SDD.md` and the companion
  alone. **§ 3.1 — closed by derivation.** QC-3 repeated the two C-I3 sentences SDD v33 removed and
  quoted R-15's former response. The new SDD sentences are the fresh authorization a settled entry
  needs, and the SDD outranks this document. The owner's seat's answer behind the old wording
  (`docs/trail/architecture/cycle-34.md` § 3.1) told QC-3 to "State what the read has met, as SDD
  § 4 C-I3 does", so following C-I3 as it now reads carries that answer forward and does not
  override it. Two architects reading SDD v33 would write the same tail. This is RN-47's and RN-51's
  form. **§ 3.2 — a locator re-pin, decided in this seat.** The § 9 bullet and RN-24's item (4)
  cited `ka-reader-mac/Package.swift:L34-L35` with no commit. That was true when v13 wrote it: at
  `ka-reader@a4ab8e6` the two `.testTarget` lines are `:L34-L35`. `ka-reader@827aad4` added five link lines
  above them (`.linkedLibrary("z")`, two frameworks, a two-line comment), so at HEAD they are
  `:L39-L40`. No obligation's words change, and no product promise moves. The item offered two
  folds; this run takes both, each where it fits. The live § 9 bullet cites `:L39-L40` at
  `ka-reader@827aad4` with a dated note, which is RN-38's convention (confirmed in the owner's seat at
  `docs/trail/architecture/cycle-24.md` § 2.1). RN-24 is a v13 record, so it keeps `:L34-L35` and
  gains the commit it was read at. A seat decided this, not the owner. Where the owner reads either
  item otherwise, the cost is one revert of this run's commit. **What does not move.** QC-3's other
  two halves, its statement and its § 10 row, which names `checks/view.sh` and carries no
  measurement. No record is written, restatused or superseded. ADR-0019's *Consequences*
  (`docs/adr/0019-git-read-through-libgit2-behind-a-port-the-executable-links-no-transport.md:L88-L93`)
  says the link "is not measured" and gives R-15's former response; its `## Traces to` pins
  `docs/SDD.md` at v27, where both were true, and its decision — libgit2 behind the port, no
  transport linked — is unchanged by a passing read, so it is history and not a reversal. ADR-0021's
  "No Swift source calls it" (`:L162-L165`) is pinned to the tree at `ka-reader@2aed844`. QC-6, QC-35
  and § 11 R-16 speak of the builds from the first in which the shell calls the export, which SDD
  RN-93 names as still true. **Re-measured for this run at HEAD `ka-reader@c120c95`.** `git diff --quiet
  129586e HEAD -- . ':!docs'` exits 0. `ka-reader-mac/Sources/KAReader/NativeBridge.swift:L26` reads
  `adopt(ka_reader_read_git())`; `crates/ka-reader-bridge/src/exports.rs:L105` defines it. On
  `target/release/bundle/macos/KA-Reader.app/Contents/MacOS/KAReader`, modified 2026-10-04 15:02, `nm`
  prints `T _ka_reader_read_git`, 781 defined `_git_` symbols by QC-3's `awk` count, no
  `git_smart_subtransport_` symbol, no undefined `_connect`, `_socket` or `_getaddrinfo`, and the
  three symbols each as `t`. `bash checks/view.sh` exits 0 printing "38 Swift files scanned … carries
  no Git transport — nothing found". `bash checks/structure.sh` exits 0. The code that landed since
  v40 is 27 files under `ka-reader-mac`'s existing `KAReader`, `Shell` and `Surfaces` targets and their
  tests; no target, package or dependency was added. Every input's `Status:` line was re-read and is
  Settled, so `Inputs read:` stands. **Known limits.** This run read SDD v33's diff whole, the
  sections QC-3 traces to, and the other inputs at their status lines; their bodies did not move
  after v40, which derived from them. It built nothing and ran no test suite: whether the executable
  on disk is the one built from the tree at `ka-reader@129586e` rests on SDD RN-93 and the file's
  time. **The companion.** Nothing is left for the owner, so it is removed and `Status:` is Settled
  *(re: header `Status:`, `Version:`; QC-3; § 9, the Swift-packet bullet; RN-24; source:
  `docs/SDD.md` v33, SDD RN-93; `docs/trail/sdd/cycle-28.md` §§ 5.1, 5.2;
  `ka-reader@f3aa266:docs/architecture_open_issues.md` §§ 3.1, 3.2; the tree at `ka-reader@c120c95`)*
- **RN-53:** *(v42 — the cycle-36 fold, § 3.1 and § 3.2 answered, § 2.1 closed by derivation; a
  re-derivation on SDD v42; ADR-0022 proposed)* **Intake.** The companion on disk had three items,
  and no `product-architecture` run had written any of them. The PM opened §§ 3.1 and 3.2 on
  2026-10-05. A `companion-self-answer` run answered both in the owner's seat and raised § 2.1 with
  its slot empty (`ka-reader@d605605`; reasoning `docs/trail/architecture/self_answer-41.md`). The
  file was clean in git at intake and two slots were filled, so it is consumed. It was copied whole
  to `docs/trail/architecture/cycle-36.md` before this fold's first edit. **What moved beneath
  this document.** `docs/SDD.md` v33 → v42, Settled (`ka-reader@076eac2`, SDD RN-94 – RN-102): nine
  versions this document had not seen. `git diff e89b5b6 HEAD -- docs/SDD.md` was read whole.
  `docs/DESIGN.md` v17 – v19 and `docs/CONTENT.md` v11 – v12 moved too, and each was read at its
  status line, Settled. The SRS, the FDR, the PRD and the UXD did not move (`git diff --stat e89b5b6
  HEAD -- docs ':!docs/trail'` lists the SDD, the DESIGN, the CONTENT and the companion alone), so
  `Inputs read:` stands. **§ 3.1 → QC-11, as answered.** The tail names `checks/structure.sh` as
  the check that holds the libgit2-binding clause across the shipped scope of every crate. It keeps
  review for two parts of the exception's bound, the switch inside `machine_config.rs` and the
  switch's test under `tests/`, and re-measures the bridge files that name `git2` at its own
  commit. It keeps "for the clauses its header holds". The old tail is kept in a dated note.
  **§ 3.2 → QC-15, as answered.** The list gains the config check's reads, the walk along each value
  either check locates, and each verified submodule's reads, in the `git-reader` row's terms.
  Addition one is folded as written: the alternates read is not built, so it is not named until it
  occurs, and the change that builds it owes the list that read. Addition two said QC-15 names
  `.gitmodules` once the SDD owns it. SDD v42 owns it, in § 3's `git-reader` row (SDD RN-102), and
  the read is built for its include keys (`libgit2.rs:L290-L303`), so the list names it. That
  carries the answer's own condition forward and overrides nothing. **§ 2.1 → QC-6, QC-30 and
  QC-35, closed by derivation.** The slot is empty, so no owner's answer stands behind this fold.
  This is RN-51's form. The new SDD sentences are the fresh authorization a settled entry needs,
  the SDD outranks this document, and two architects reading SDD v42 would write the same
  sentences. The item proposed five keys, on SDD v41. SDD v42 measures six, so the entries state
  the domain as § 11 R-16's rule and its count as six. They name as uncovered what is stated and
  not built: the alternates check, the `.gitmodules` section-path refusals and the refusal on the
  submodule map. The item asked for exactly that, and the fold neither widens nor narrows it. One
  sentence the item did not name was false on the same ground: QC-35's "No command observes a read
  outside the grant". Four `git_state` cases now observe, through a FIFO, that no call opens the one
  outside path each scene names, so the tail names them and keeps the general claim. Where the
  owner reads any of this otherwise, the cost is one revert of this run's commit. **ADR-0022,
  Proposed.** SDD RN-99 – RN-102 surface the refusal by an adapter check, the two forms refused
  without locating, the sixth member and the refusal on the submodule map, for this seat to
  record. They are one record and not four, because they answer one question, how a path the
  repository's files name is kept inside the grant. ADR-0020 left that question to the SDD's *Open
  Questions*, and each sub-decision is a line of the record's *Decision* and *Alternatives*. The
  three gates hold. It is hard to reverse: the conditions cross SM-2, SM-4 and SM-8 with sentences
  `docs/CONTENT.md` publishes, and undoing them reopens R-101 in the harness. It is surprising: a
  repository `git status` reads in a terminal shows a failed Git item here, and the adapter parses
  Git's config syntax itself. And it is a real trade-off: eight alternatives are ruled out, each
  the SDD's own. ADR-0020 is not superseded, because the switch it records stands. Its
  *Consequences* sentence that points at the *Open Question* is pinned to SDD v27 by its own
  `## Traces to`, and is history. The record lands Proposed and its acceptance is put to the owner
  at `docs/architecture_open_issues.md` § 2.1. QC-6, QC-15, QC-30 and QC-35 trace to it, marked
  Proposed. **Two candidates that earn no record.** SDD § 10 RC-5 leaves "Whether a dated placement
  earns a record of its own" to this seat. It does not, because it fails the first gate: the SDD
  schedules its reversal at `follow-the-folder`, with a `grep` that is red until then. It lands as
  an obligation instead, in QC-48 and § 9's layer-4 row. SDD RN-101's second decision, that a
  scene whose Git directory lies outside the opened folder is proved by the suites and not by the
  walk, fails the same gate: moving a scene into the walk is a script change that moves no seam. It
  lands in QC-2. **SDD v34 – v38: the surfaces.** The hover fill, the status letter's tooltip, the
  selected row and the key window are observable behaviour, and by this prompt's ownership test
  they are the FDR's and the SDD's. No entry restates them, as no entry restates C-E1 – C-E10, so
  C-E8's new sentence does not reach this document. What is structural is § 3's `surfaces` row: two
  reading clauses that are not a second exception, and one dated placement. § 9's layer-4 row now
  reads them. QC-4 and QC-51 do not move. **Found while walking, and fixed in place.** QC-17 cited
  `session.rs:L1729` and `:L1740` with no commit, and both were dead at HEAD: the cases are at
  `:L1798` and `:L1809`. They are re-pinned at `ka-reader@076eac2` with a dated note
  (`<CORE>/doctrine/governance/found_while_walking.md` § *The rule*, clause 1; RN-38's convention).
  **What does not move.** QC-7: the checks read and do not mutate. QC-17's statement never listed
  the keys, and the `core-bridge` row's *Not covered* sentence it would follow is QC-6's and QC-35's
  to carry. QC-39: the new conditions' log line holds no path (SDD § 3, the `git-reader` row). QC-53:
  the conditions' words are `docs/CONTENT.md`'s. No accepted record is edited, written over or
  restatused. **Measured for this run at `ka-reader@076eac2`.** `git status --porcelain` printed
  nothing at intake. `git diff --quiet 5f3e895 HEAD -- . ':!docs'` exits 0, and so does the same
  command from `b25b407` and from `fc14574`. `bash checks/structure.sh` exits 0, printing "16 Rust
  files in 2 crates read — nothing found". `cargo test --locked -p ka-reader-core --test git_state`
  printed 58 passed. `grep -rln git2 crates/ka-reader-bridge` prints the manifest, `machine_config.rs`
  and `tests/search_path.rs`. `grep -rl alternates checks crates ka-reader-mac/Sources` prints
  nothing. `grep -rln 'TreeMarkers\|GitRowOrder' ka-reader-mac/Sources` prints five files.
  `config_scan.rs` holds no `std::fs`, and its `scan` takes bytes (`:L66`). **Known limits.** This
  run read the SDD's diff whole, and the other inputs at their status lines. It re-read no libgit2
  source: every libgit2 line ADR-0022 cites is the SDD's. It ran one suite and one script. It built
  no bundle and did not run `checks/read-only.sh`. **The companion.** One item is left, § 2.1, the
  acceptance of ADR-0022, so the companion stays and `Status:` is Draft *(re: header `Status:`,
  `Version:`; QC-2, QC-6, QC-11, QC-15, QC-17, QC-30, QC-35, QC-48; § 9, the layer-4 row; § 10, the
  QC-2, QC-35 and QC-47 – QC-48 rows; ADR-0022 and the index; source: `docs/SDD.md` v42, SDD RN-94 –
  RN-102, § 10 RC-5; `docs/trail/architecture/cycle-36.md` §§ 2.1, 3.1, 3.2;
  `docs/trail/architecture/self_answer-41.md`; the tree at `ka-reader@076eac2`)*
- **RN-54:** *(v43 — the close: the cycle-37 fold, § 2.1 confirmed with one addition)* **Intake.**
  The companion on disk was the one v42 wrote, with one § 2 item and nothing in §§ 1 or 3. A
  `companion-self-answer` run confirmed it in the owner's seat, with one addition, and the answer
  was committed at `ka-reader@78276ed` (reasoning `docs/trail/architecture/self_answer-42.md`). The
  file was clean in git at intake and its slot was filled, so it is consumed. It was copied whole
  to `docs/trail/architecture/cycle-37.md` before this fold's first edit. **Whose answer this is.**
  The `companion-self-answer` skill takes the owner's seat on a companion, and the fold is this
  skill's. ADR-0020 was accepted on such an answer alone (RN-44). ADR-0021 was not: one run stopped
  short and the owner confirmed it in an interactive session (RN-50). That stop was one run's call,
  and no rule was written from it. The answer's own *whose seat* check reasons that accepting the
  record binds only the log's consistency with the settled SDD. This run folds it on that ground,
  and the owner can reverse the fold with one revert. **§ 2.1 → ADR-0022 Accepted.** The addition
  is folded first, while the record was still Proposed and this run's to revise. Two sentences of
  its *Decision* went past `docs/SDD.md` v42 and now say what the SDD says. (a) The `includeIf`
  refusal covers a path that spells outside the folder or is in a form the adapter does not locate,
  and an inside one is followed (§ 11 R-16, `docs/SDD.md:L3163-L3165`; the `git-reader` row follows
  every inside include). (b) "Never the read-failed condition" covers a refusal of a value. The same
  bullet now says that a file the check cannot read answers the condition for an unreadable Git
  directory, and that a config it cannot parse to the end answers the read-failed condition, because
  it cannot prove what libgit2 would follow (§ 3, the `git-reader` row; § 11 R-16,
  `docs/SDD.md:L3114-L3116`). The record's `## Traces to` gains the trail cycle, the form ADR-0021
  took (RN-50). Nothing else in the record moves. Its eight alternatives, its *Consequences* and
  its `## Binds` stand as written, and it supersedes nothing (RN-53). Its Status is then Accepted,
  and the index follows. **Traces re-read.** QC-6, QC-15, QC-30 and QC-35 traced to "ADR-0022
  (Proposed)". The marker is dropped, as RN-44 dropped ", Proposed" for ADR-0020. No entry states
  either scoped sentence (`grep -n -i 'includeIf\|read-failed'` over §§ 1 – 10 prints nothing), so
  no obligation moves. **Measured for this run at `ka-reader@78276ed`.** `git status --porcelain`
  printed nothing at intake. `git diff --quiet 076eac2 HEAD -- . ':!docs'` exits 0, so the code
  facts the record pins to `ka-reader@076eac2` still hold at HEAD. `git diff --stat 58a7a2b HEAD --
  docs ':!docs/trail'` lists the companion alone, and every input's `Status:` line was re-read as
  Settled, so `Inputs read:` stands. **Known limits.** This run ran no suite and no script, and
  re-read no libgit2 source. The self-answer re-read libgit2's option list, and this fold relies on
  that reading. **What does not move.** No `QC` is added, renumbered or reused. § 10 does not move:
  no row names a record. No accepted record is edited, written over or restatused. **The
  companion.** Nothing is left for the owner, so the companion is removed and `Status:` is Settled
  *(re: header `Status:`, `Version:`; the traces of QC-6, QC-15, QC-30, QC-35; ADR-0022 and the
  index; source: `docs/trail/architecture/cycle-37.md` § 2.1;
  `docs/trail/architecture/self_answer-42.md`; `ka-reader@78276ed`; `docs/SDD.md` v42 at the lines
  cited)*
- **RN-55:** *(v44 — the close: the cycle-38 fold, §§ 3.1 and 3.2 answered)* **Intake.** The
  companion on disk had two § 3 items and nothing in §§ 1 or 2. No `product-architecture` run wrote
  it. The PM opened it on 2026-10-06, after the alternates check landed on `main` (`ka-reader@66f428d`),
  because QC-6, QC-15, QC-35 and ADR-0022 still read that check as not built (`ka-reader@2309ba5`). A
  `companion-self-answer` run answered both items in the owner's seat: § 3.1 confirmed with
  addition, § 3.2 answered (`ka-reader@f2e22e9`; reasoning `docs/trail/architecture/self_answer-43.md`).
  The file was clean in git at intake and both slots were filled, so it is consumed. It was copied
  whole to `docs/trail/architecture/cycle-38.md` before this fold's first edit. **Whose answer this
  is.** The fold rests on the same ground as RN-54: the answer binds only the records' consistency
  with the tree and with the settled SDD, and the owner can reverse the fold with one revert.
  **What moved beneath this document.** `docs/SDD.md` v42 → v43, Settled (`ka-reader@4a49995`, SDD
  RN-103). `git diff af21672 HEAD -- docs/SDD.md` was read whole. Nothing else in `docs/` outside
  the trail moved: `git diff --stat af21672 HEAD -- docs ':!docs/trail'` lists the SDD and the
  companion alone. Every input's `Status:` line was re-read as Settled, so `Inputs read:` stands.
  **§ 3.1 → QC-6, QC-15 and QC-35, as answered, with the addition.** The fresh authorization is
  SDD v43: § 11 R-16 *Until the checks are built* and *The proof* under "A third way out" state the
  alternates check and its case as in the tree at `ka-reader@66f428d`, and *Open Questions*'
  config-named-path item is open on the `.gitmodules` case alone. (1) QC-15's list names the
  alternates check's reads, as SDD § 3's `git-reader` row states them. Its tail names
  `check_alternates` beside `check_config`, and `alternates_scan::scan`, which takes bytes and reads
  nothing, beside `config_scan.rs`. The not-built sentence moves to a dated note. (2) QC-6 *Still
  uncovered*: (b) leaves, and the item is open on the `.gitmodules` case alone. (3) QC-35 *Not
  covered* (1): the alternates read leaves the not-built clause. The clause about a file rewritten
  between the check and libgit2's read keeps "alternates", because that limit stands. (4) The
  addition: QC-35's tail names the fifth FIFO case, says that it does not watch a `stat` of the
  outside directory, says that the absence of that `stat` rests on the check running before the open
  (`libgit2.rs:L112-L115`), says that no case runs the check on the built bundle, and re-pins the
  count at 82 passed at `ka-reader@4a49995`. (5) ADR-0022 stays in each entry's trace, and each trace
  names SDD v43 RN-103 as the source. Every sentence whose claim changed keeps its old words in a
  dated note. **§ 3.2 → no change to ADR-0022.** The record is Accepted, so its body is not
  rewritten. Its *Built and not built* paragraph is pinned to `ka-reader@076eac2`, where it was true.
  Its `## Binds` names QC-6, QC-15, QC-30 and QC-35, and QC-6, QC-15 and QC-35 now carry the built
  state. The record and the index are untouched by this run. The answer names one guard it leaves
  open: a reader who opens ADR-0022 alone and reads past its pin still meets the old state.
  **Where the fold goes beyond the answers' words, each named.** (a) QC-6's "The config check runs
  before libgit2 opens anything" now names the alternates check beside it. SDD v43 states both
  checks before the open as built, and the code calls them in that order (`libgit2.rs:L113-L114`).
  (b) QC-15's "every value either check locates" now reads "every value the config check or the
  `.gitmodules` check locates". The list now names three checks, so "either" would not say which
  two. The alternates walk has its own clause. (c) QC-15's tail cites `read_alternates` (`:L366`)
  and `inspect_on_disk` (`:L517`). The item named both, and the answer did not. (d) QC-35's four
  earlier FIFO case locators were true at `ka-reader@076eac2` and are ten lines later at
  `ka-reader@66f428d`, and the helper's span ends four lines later. Each is re-pinned there with a dated note, so the count's new pin does not sit beside locators
  from another commit. What each locator names is unchanged (RN-38's convention). (e) § 10's QC-35
  row reads "the five FIFO cases", because the row is a projection of the entry. **A candidate that
  earns no record.** SDD v43 RN-103 adds a second observation to the alternates condition. An entry
  beginning with neither `.` nor `/` is refused without being located, where SDD v42 said it "is
  refused as outside" (`af21672:docs/SDD.md:L3371-L3372`). ADR-0022 already records the rule this
  applies: "A value in a form the adapter does not locate refuses as *not located*, not as
  *outside*" (`docs/adr/0022-git-reader-refuses-a-repository-whose-config-names-a-location-outside-the-folder.md:L49-L50`). Its list of such forms is pinned to SDD v42 by its own traces,
  and at that version the alternates entry was not one of them. The new observation fails the second
  gate: a reader of ADR-0022 would not be surprised by it. The alternative that was weighed,
  locating the entry, is held in SDD § 11 R-16 *The spellings*. No entry moves for it either. QC-6
  already refuses "a form it does not locate" for the alternates file, and the condition's words are
  `docs/CONTENT.md`'s (QC-53). SDD v43's known defect at `ka-reader@66f428d`, one condition for both
  observations, touches no entry: `grep -n -i 'object store names'` over §§ 1 – 10 prints nothing.
  The owner can reopen this as a superseding record. **Measured for this run at `ka-reader@f2e22e9`.**
  `git status --porcelain` printed nothing at intake. `git diff --stat 66f428d HEAD -- . ':!docs'`
  prints nothing, so every code locator here is written against `ka-reader@66f428d`. `check_alternates`
  is defined at `libgit2.rs:L303` and called at `:L114`, `:L449` and `:L475`. `alternates_scan::scan`
  is at `alternates_scan.rs:L28`, and `grep -nE
  'std::fs|File::|read_to|OpenOptions|read_link|metadata'` over that file prints nothing.
  `git_state.rs` holds the FIFO helper at `:L1156-L1170` and the five cases at `:L1212`, `:L1228`,
  `:L1543`, `:L1634` and `:L1733`. `cargo test --locked -p ka-reader-core --test git_state` printed 82
  passed, 0 failed, and every case whose name carries `alternates` or `outside_object` printed `ok`.
  **Known limits.** This run read the SDD's diff since `af21672` whole, and the other inputs at their
  status lines. It ran one suite. It ran no `checks/*.sh` script, built no bundle, ran no
  `swift test`, and re-read no libgit2 source. **What does not move.** No `QC` is added, renumbered or
  reused. QC-30 names no alternates read. No accepted record is edited, written over or restatused,
  and the index does not move. **The companion.** Nothing is left for the owner, so the companion is
  removed and `Status:` is Settled *(re: header `Version:`; QC-6, QC-15, QC-35; § 10, the QC-35 row;
  source: `docs/trail/architecture/cycle-38.md` §§ 3.1, 3.2;
  `docs/trail/architecture/self_answer-43.md`; `docs/SDD.md` v43, SDD RN-103; the tree at
  `ka-reader@66f428d`, measured at `ka-reader@f2e22e9`)*
- **RN-56:** *(v45 — the close: the cycle-39 fold, §§ 3.1 and 3.2 answered)* **Intake.** The
  companion on disk had two § 3 items and nothing in §§ 1 or 2. No `product-architecture` run wrote
  it. The PM opened it on 2026-10-07 (`ka-reader@ccbe02a`), after the `.gitmodules` section-path
  refusals and the refusal on the submodule map merged to `main` (`ka-reader@772c63b`), because QC-6
  and QC-35 still read both as not built and ADR-0022's *Decision* gave an unreadable `.gitmodules`
  a condition the build no longer gives it. A `companion-self-answer` run answered both items in
  the owner's seat: § 3.1 confirmed with additions, § 3.2 answered (`ka-reader@d90814b`; reasoning
  `docs/trail/architecture/self_answer-44.md`). The file was clean in git at intake and both slots
  were filled, so it is consumed. It was copied whole to `docs/trail/architecture/cycle-39.md`
  before this fold's first edit, and `cmp` found the two identical. **Whose answer this is.** The
  fold rests on the ground RN-54 and RN-55 rest on: the answers bind only the records' consistency
  with the tree and with the settled SDD, which decided the substance (SDD RN-106), and the owner
  can reverse the fold with one revert. **What moved beneath this document.** `docs/SDD.md` v43 →
  v46, Settled. RN-104 and RN-105 name nothing owed here: each reads `nfdr.md:L275` and ADR-0022's
  not-located rule as already stating what it built. RN-106 names the two items this fold answers.
  `git diff --stat 218e250 HEAD -- docs ':!docs/trail'` lists the SDD and the companion alone.
  Every input's `Status:` line was re-read as Settled, so `Inputs read:` stands. **§ 3.2 → ADR-0023,
  superseding ADR-0022.** The new record carries ADR-0022's decision whole, with one line changed: a
  file the check cannot read answers the unreadable-Git-directory condition, except a `.gitmodules`
  at depth 0 of a level's walk, which answers `GitmodulesUnreadable` on `status()` alone; a file it
  includes keeps the old condition. *Alternatives ruled out* gains the two the answer names.
  *Built and not built* is re-pinned at `ka-reader@d90814b`, where everything the record decides is
  built. ADR-0022's Status line reads `Superseded by ADR-0023`, and no other line in it moved
  (`git diff` on the file shows one line). The index's ADR-0022 row is restatused and an ADR-0023
  row is added. ADR-0023 lands Accepted: the answer chose the record, named what it carries and
  directed the supersession, which takes effect only on acceptance (ADR-0020 was accepted on such
  an answer alone, RN-44). **§ 3.1 → QC-6, QC-15, QC-30 and QC-35, as answered, with the
  additions.** The fresh authorization is SDD v46: § 11 R-16 *Built, and the cases that hold it*,
  *The proof* and *Which paths the status read looks up*, and RN-106 (7), which removed *Open
  Questions*' config-named-path item. (1) QC-6: *Still uncovered* leaves whole, with its two
  sentences on the bounds, into a dated note. In its place the passage says what the `.gitmodules`
  check now refuses for a section. (2) The closing pointer in QC-6 and QC-35 (1), and QC-6's review
  bound, move to dated notes. QC-35 (1)'s lead keeps "what that check cannot refuse", and its two
  cases keep "no closing named" with the sandbox as their only bound. (3) QC-35's tail names the
  sixth FIFO case and says that it runs in-process like the five. (4) QC-30's "does not yet hold"
  loses "yet". (5) QC-6 names the looked-up set beside the six members, pinned to the same
  `libgit2-sys` version and re-measured at the same lockfile review (QC-26). (6) QC-15's list does
  not move. Each entry's ADR-0022 trace moves to ADR-0023, with the move noted in the trace. §
  10's QC-35 row reads "the six FIFO cases", because the row is a projection of the entry.
  **Where the fold goes beyond the answers' words, each named.** (a) ADR-0023's list of forms the
  adapter does not locate gains the alternates entry beginning with neither `.` nor `/`. The
  record traces to SDD v46, where that form is stated and built (§ 11 R-16, "A third way out", *The
  condition*; SDD RN-105; `libgit2.rs:L487-L491`), and a list pinned to v46 that omitted it would
  be false at its own pin. RN-55 judged the same form no record of its own, and this fold does not
  reopen that: the rule is ADR-0022's, unchanged. The record names this in its `## Traces to`. (b)
  QC-6's looked-up-set sentence says which case would notice a libgit2 that looked up more:
  `test_looked_up_kinds_the_measurement_found_are_refused` (`git_state.rs:L3017`) watches one kind,
  a working-tree folder holding `.git` with no gitlink, and no case watches any other. The answer
  said "no case would notice", which is true of every kind but that one. (c) QC-35's helper span
  moves from `:L1156-L1170` to `:L1155-L1206`. The old span covered the doc comment and the FIFO
  maker and stopped before the non-blocking open it cites; the helper is byte-identical to
  `ka-reader@66f428d`'s (`diff` on `:L1155-L1210` printed nothing). (d) QC-35's trace names *Open
  Questions*' second item alone as live, and the config-named-path item as removed. **Measured for
  this run at `ka-reader@d90814b`.** `git status --short` printed nothing at intake. `git diff --stat
  772c63b HEAD -- . ':!docs'` printed nothing, so every code locator here is written against
  `ka-reader@772c63b`. On a disposable copy (`git archive d90814b`, unpacked under `/private/tmp`, the
  suite run by `--manifest-path`): `cargo test --locked -p ka-reader-core --test git_state` printed
  120 passed, 0 failed, and each of the six FIFO cases and the looked-up-kinds case printed `ok`.
  The six cases are at `git_state.rs:L1212`, `:L1228`, `:L1795`, `:L1886`, `:L1995` and `:L2680`,
  and the helper at `:L1155-L1206`. In the adapter, `state()` and `status()` are at
  `libgit2.rs:L96-L104`; `check_config`, `check_alternates` and `verify_submodules` at `:L201`,
  `:L440` and `:L543`, the first two called before the open at `:L113-L114`; `SectionScope` at
  `:L223-L230`; the skip of an absent file at `:L244`; the read-failed arm at `:L250-L251`;
  `unreadable_config_file` at `:L280-L290`; `check_section_value` at `:L330-L358`; and the
  looked-up collection at `:L553-L557`. The variant is at `git_reader.rs:L238-L241`, the wire arm at
  `session.rs:L586-L588`, the shell case at `GitItem.swift:L114`, and the two sentences at
  `GitSentences.swift:L26-L28` and `:L30-L33`. `Cargo.lock:L122-L123` resolves `libgit2-sys
  0.18.8+1.9.7`. **Known limits.** This run read the SDD's header, RN-104 – RN-106 whole as far as
  their downstream passages, § 11 R-16 from *The sixth member* to *Not covered* whole, and the
  *Open Questions* list. The other inputs were read at their status lines. It ran one suite. It ran
  no `checks/*.sh` script, built no bundle, ran no `swift test`, and re-read no libgit2 source.
  **What does not move.** No `QC` is added, renumbered or reused. No accepted record is edited or
  written over. ADR-0022's Status line is the one line restatused. **The companion.** Nothing is
  left for the owner, so the companion is removed and `Status:` is Settled *(re: header
  `Version:`; QC-6, QC-15, QC-30, QC-35; § 10, the QC-35 row; ADR-0023, ADR-0022's Status line and
  the index; source: `docs/trail/architecture/cycle-39.md` §§ 3.1, 3.2;
  `docs/trail/architecture/self_answer-44.md`; `docs/SDD.md` v46, SDD RN-106; the tree at
  `ka-reader@772c63b`, measured at `ka-reader@d90814b`)*
- **RN-57:** *(v46 — the close: the cycle-40 fold, § 3.1 answered)* **Intake.** The companion on
  disk had one § 3 item and nothing in §§ 1 or 2. No `product-architecture` run wrote it. The PM
  opened it on 2026-10-07 (`ka-reader@258b472`), after the change that runs the `submodule` walk every
  build merged to `main` (`ka-reader@b12e48c`), because QC-2's tail still stated two limits beside the
  `submodule` walk fixture that the change had closed. A `companion-self-answer` run answered it in
  the owner's seat, confirmed with four additions (`ka-reader@201498e`; reasoning
  `docs/trail/architecture/self_answer-45.md`). The file was clean in git at intake and its one slot
  was filled, so it is consumed. It was copied whole to `docs/trail/architecture/cycle-40.md` before
  this fold's first edit, and `cmp` found the two identical. **Whose answer this is.** The fold rests
  on the ground RN-54 to RN-56 rest on: the answer binds only the records' consistency with the tree
  and with the settled SDD, which states the substance (SDD RN-107), and the owner can reverse the
  fold with one revert. **What moved beneath this document.** `docs/SDD.md` v46 → v47, Settled
  (`ka-reader@c1032b5`, SDD RN-107). `git diff 275e179 HEAD -- docs/SDD.md` touches the header, § 3's
  `read-only-harness` row, § 6 S-4's promise clause and *Rests on*, and RN-107, and each was read.
  `git diff --stat 275e179 HEAD -- docs ':!docs/trail'` lists the SDD and the companion alone. Every
  input's `Status:` line was re-read as Settled, so `Inputs read:` stands. **§ 3.1 → QC-2, as
  answered, with the four additions.** The fresh authorization is SDD v47 § 6 S-4, command half, the
  promise clause, which reads both limits as closed at `ka-reader@b12e48c`. QC-2's tail now names the
  CI step `Read-only, submodule` (`.github/workflows/ci.yml:L73-L74`) and the case
  `crates/ka-reader-core/tests/git_state.rs:L787`, and it keeps the old words in a dated note. (1) The
  tail names the case as a layer-2 no-write proof on the restored `submodule` as well as the answer
  it asserts, because `read_git_over` snapshots the whole scene before and after the call
  (`:L730-L738`). (2) The CI half is bounded. The step is in the workflow, and its result on the
  hosted runner is unread: `git branch -r --contains b12e48c` prints nothing, and `origin/main` is at
  `ka-reader@799c3d6`. The tail says this and does not say the step is green. (3) The sentence that the
  walk drops the Git answer (`checks/walk.rs:L288-L292`) stays, as the reason the case and not the
  walk holds the answer. (4) The trace moves from SDD § 4 C-I3 and § 6 S-4, command half, as they
  read at v42 (SDD RN-101) to § 6 S-4 at v47 (SDD RN-107), and the v42 reading is in the dated note.
  The head of QC-2's trace still names SDD § 4 C-I3, which v47 did not move. **Where the fold goes
  beyond the answer's words, each named.** (a) The tail names `:L771`, `:L802`, `:L815` and `:L828`,
  the scene case and the three layouts in which the answer moves. The item named them and the answer
  did not; SDD v47 names all four. (b) The tail states what the `:L787` case asserts — `root`, HEAD on
  `main` in the normal state, staged empty, and changed = {`submodule` modified, `README.md`
  untracked} — as the item and SDD v47 state it, so a reader does not have to open the test to learn
  what "the whole answer" means. **What does not move**, as the answer directs. § 10's QC-2 row reads
  "on every walk fixture", which is still true. § 9's suite count is pinned at `ka-reader@b158052`, and
  its own sentence makes an inserted step a re-measurement. The export-set clause stands. No ADR is
  written, edited or restatused, and the index does not move. No `QC` is added, renumbered or reused.
  **No candidate record.** Running the `submodule` walk in CI and asserting `read_git`'s answer in a
  case are verification moves, not decisions. Undoing either is cheap, and neither involved a real
  trade-off, so neither earns a record. **Measured for this run at `ka-reader@201498e`.** `git status
  --porcelain` printed nothing at intake. `git diff --stat b12e48c HEAD -- . ':!docs'` printed
  nothing, so every code locator here is written against `ka-reader@b12e48c`. At that commit,
  `ci.yml:L73-L74` holds the `Read-only, submodule` step, and `git_state.rs` holds `read_git_over` at
  `:L730-L738` with its snapshot at `:L731` and `:L736`, the scene case at `:L771`, the answer case at
  `:L787` with its assertion at `:L792-L798`, and the three layout cases at `:L802`, `:L815` and
  `:L828`. `walk.rs:L288-L292` still drops the answer. The locators QC-2 already carried were
  re-read at HEAD: `git_state.rs:L146-L155` and `root_finding.rs:L38-L43` still snapshot the scene
  around the calls, and `checks/read-only.sh` is unchanged since `ka-reader@076eac2`. On a disposable
  copy (`git archive HEAD`, unpacked under `/private/tmp`, the suite run by `--manifest-path`),
  `checks/read-only.sh` printed `unchanged` on `plain`, `repo` and `submodule`. In the same copy,
  `cargo test --locked -p ka-reader-core --test git_state submodule` printed `test result: ok. 17 passed;
  0 failed`, and the cases at `:L771`, `:L787`, `:L802` and `:L815` printed `ok`. The filter does
  not reach `:L828`, whose name does not carry `submodule`; run by its own name, it printed `test
  result: ok. 1 passed; 0 failed`. **Known limits.** This run read the SDD's diff since `275e179`
  whole, and the other inputs at their status lines. It ran three walks and two filtered runs of one
  suite. It ran no other `checks/*.sh` script, built no bundle, ran no `swift test`, and
  read no hosted CI run. **The companion.** Nothing is left for the owner, so the companion is removed
  and `Status:` is Settled *(re: header `Version:`; QC-2; source:
  `docs/trail/architecture/cycle-40.md` § 3.1; `docs/trail/architecture/self_answer-45.md`;
  `docs/SDD.md` v47, SDD RN-107; the tree at `ka-reader@b12e48c`, measured at `ka-reader@201498e`)*
- **RN-58:** *(v47 — a re-derivation on SDD v48, the macOS floor at 26.0; § 2.1 closed by
  derivation)* **Intake.** The companion on disk had one § 2 item and nothing in §§ 1 or 3. No
  `product-architecture` run wrote it. A `companion-self-answer` run answering the SDD's companion
  opened it on 2026-10-13 in the CTO's posture (`ka-reader@55c04de`; reasoning
  `docs/trail/sdd/self_answer-55.md`), after the owner raised the floor in their own hand. Its
  *Confirm or override* slot still holds the template's placeholder, and the file was clean in git
  at intake, so it is **not consumed**: no trail cycle is written, and nothing of the owner's is
  folded from it. **Whose answer this is.** None of the owner's stands behind this fold through the
  companion. It is RN-51's and RN-53's form, closed by derivation. The value is the owner's own,
  given at `docs/trail/sdd/cycle-43.md` § 5.1 and first in this document's authority order. SDD v48
  § 4 C-R5 states it as a settled sentence, which is the fresh authorization a settled entry needs,
  and two architects reading C-R5 at v48 would write the same entry. Where the owner reads any of
  this otherwise, the cost is one revert of this run's commit. **What moved beneath this document.**
  `docs/SDD.md` v47 → v48, Settled (`ka-reader@6eec80c`, SDD RN-108). `git show 6eec80c --
  docs/SDD.md` was read whole: § 4 C-R5 and C-I3, § 6's S-4, S-7 and S-11 command halves, § 9
  TO-8, § 11 R-17 (new), RN-6 and RN-108. `docs/fdr.md` v10 → v12, Settled (`ka-reader@1c76704`,
  `ka-reader@d6405e2`). R-133, PD-18 and the stranger's example row read 26, and R-35, R-37, R-38
  and R-185 – R-191 moved or are new. `grep` for an FDR trace to R-35, R-37, R-38 or R-185 – R-191
  in this document prints nothing, so none of those moves an entry. The rename *nozoki* →
  *ka-reader* (`ka-reader@c915d52`, `ka-reader@4b98c17`) touched every input, and no other input
  moved in substance: `git log --oneline 03dcb85..HEAD -- docs/SRS.md docs/PRD.md docs/UXD.md
  docs/DESIGN.md docs/CONTENT.md` lists the two rename commits alone. Every input's `Status:` line
  was re-read as Settled, so `Inputs read:` stands. **§ 2.1 → QC-56, as the item drafted it, with
  two additions.** QC-56 reads `26.0` and `prints 26.0`, and its traces stand as the item proposed.
  Three are added: C-R5 pinned at v48, § 11 R-17, and the owner's answer, because R-17 is where the
  floor's new dependence is held. The floor now rests on how long GitHub hosts one runner image,
  which is a platform fact this product does not control. R-17 names the image's retirement as the
  floor's next move and the owner's companion item as the response, so QC-56 traces there and does
  not restate it. The old words are in a dated note. **Where the fold goes beyond the item, each
  named.** (a) *The CI-image clause.* SDD v48 C-R5 binds CI to the `macos-26` label and refuses
  `macos-latest` as an alias. Its *Violated by* gains "a workflow whose `runs-on` names an alias or
  an image below the floor's major". That is an enforceable sentence a change could break, so its
  checkable form lives here (*Describes and binds*). The item predates the SDD's fold and did not
  name it. The check is a `grep` over `.github/workflows/*.yml` that this document names as its own
  realization, and no script holds it. By the header's rule, its gate is `development-design`
  reading the entry, and release inspection runs it beside the plist read. § 10's row says so. Run
  at `ka-reader@d6405e2`, it prints `runs-on: macos-14`, which is the expected result before the
  tree moves, and the entry states it. (b) *The Swift-packet departure in § 9.* The item's lean was
  that nothing in that paragraph moves by this item. SDD v48 RN-108, written after the lean, states
  that "`Package.swift:L1` moves with the floor and brings the tools-6.2 departure `docs/nfdr.md`
  names … with it", because `.macOS(.v26)` is introduced in SwiftPM 6.2. This run re-read Apple's
  documentation data and found `"introducedAt": "6.2"` under `SwiftPM`
  (`curl -s https://developer.apple.com/tutorials/data/documentation/packagedescription/supportedplatform/macosversion/v26.json`,
  2026-10-13). The paragraph gains one dated sentence: the change that writes the `6.2` tools
  version adopts the other five with it, by the paragraph's own "as one decision". The paragraph's
  older clauses stand. They read the workflow as it is at `ka-reader@d6405e2`, which still names
  `macos-14` and Xcode 16.2 (`.github/workflows/ci.yml:L18`, `:L23`), so "the current `macos-14`
  image" is still true of the tree. **No record is owed.** The floor has never been a record of its
  own. QC-56 traces to C-R5 and ADR-0007. A raise before 1.0.0 fails the first gate: SDD § 9 TO-8
  prices undoing it as "the plist line, the manifest's platform line, the bridge's deployment target
  and the walk widened to every major re-admitted — cheap before 1.0.0". The question is the seat's, as the item itself says,
  and the answer is the same whoever reads TO-8. The log's dated passages that name the old floor or
  the old image stand as written: ADR-0011 `:L99`, ADR-0012 `:L123` and `:L136`, and ADR-0014 `:L102`.
  Each is a reading true when recorded, and none of their decisions rests on a floor value. No
  record is written, edited or restatused, and the index does not move. **What does not move.**
  QC-59 names "the macOS floor" as a contract member and carries no number. § 9's "every macOS the
  floor admits" is now one. The dated `macos-14` readings in these notes stand. No `QC` is added,
  renumbered or reused. **Measured for this run at `ka-reader@d6405e2`.** `git status --porcelain`
  printed nothing at intake. `git diff --stat 0c0d5f9 d6405e2 -- ka-reader-mac checks .github`
  printed nothing, so the tree lines SDD RN-108 lists at `ka-reader@0c0d5f9` stand.
  `ka-reader-mac/Info.plist:L14` reads `<string>14.0</string>`, `Package.swift:L1` reads
  `swift-tools-version:5.9` and `:L14` reads `platforms: [.macOS(.v14)]`, and `ci.yml:L18` reads
  `runs-on: macos-14`. **Known limits.** This run read the SDD's v48 diff and the FDR's v11 – v12
  diff whole, and the other inputs at their status lines and their `git log`. It ran one `grep`
  over the workflow. It built no bundle, ran no test suite and no `checks/*.sh` script, and read
  no hosted CI run. **The companion.** Nothing is left for the owner, so the companion is removed
  and `Status:` is Settled *(re: header `Version:`; QC-56; § 9, the Swift-packet departure; § 10,
  the QC-56 row; source: `docs/SDD.md` v48 § 4 C-R5, § 9 TO-8, § 11 R-17, SDD RN-108;
  `docs/trail/sdd/cycle-43.md` § 5.1; `ka-reader@55c04de:docs/architecture_open_issues.md` § 2.1;
  `docs/fdr.md` v12 R-133, PD-18; the tree at `ka-reader@d6405e2`)*
- **RN-59:** *(v48 — the close: the cycle-41 fold, §§ 3.1 and 3.2 answered)* **Intake.** The
  companion on disk had two § 3 items and nothing in §§ 1 or 2. No `product-architecture` run wrote
  it. The PM opened it on 2026-10-13 (`ka-reader@c8dc81c`), after the change that moves CI's one job
  to `macos-26` and drops its Xcode pin merged to `main` (`ka-reader@fcb2e2f`). A
  `companion-self-answer` run answered both in the owner's seat, decided together
  (`ka-reader@81734d9`; reasoning `docs/trail/architecture/self_answer-46.md`). The file was clean in
  git at intake and both slots were filled, so it is consumed. It was copied whole to
  `docs/trail/architecture/cycle-41.md` before this fold's first edit, and `cmp` found the two
  identical. **Whose answer this is.** The fold rests on the ground RN-54 to RN-57 rest on: both
  answers bind only the records' consistency with the tree, with hosted CI logs, and with the
  settled SDD (RN-108 ties the tools version to the floor and leaves which change carries it to the
  PM), and the owner can reverse the fold with one revert. **What moved beneath this document.**
  Nothing in substance. `git diff --stat 8926052 HEAD -- docs ':!docs/trail'` lists the two
  companions alone, this one and `docs/SDD_open_issues.md`, which the answering run opened at
  `ka-reader@b1679d5` (§ 2.1: C-I3 states the hosted-runner narrowing with no image named). The
  SDD's `Status:` line still reads Settled, so `Inputs read:` stands as the line reads it. When the
  CTO folds that item, QC-25's trace to C-I3 is re-read. `git diff --stat 8926052 HEAD -- .
  ':!docs'` lists `.github/workflows/ci.yml` alone. **§ 3.1 → § 9's Swift-packet bullet, confirmed
  with addition and one clause of the lean overridden.** (1) The image reads `macos-26`
  (`ci.yml:L18`), selecting no Xcode (`:L19`), and the `macos-14` words become dated notes. (2) The
  *Framework* clause is adopted. Its trigger, a CI log on `main` naming a toolchain that runs Swift
  Testing, fired at GitHub Actions run 37845881070. That run is the first `main` build after the
  `Toolchain` step reached `main` with `ka-reader@fcc3d4f`, the merge carrying `ka-reader@d852457`.
  The *Toolchain* clause records the run as its first measurement. Three phrases become dated notes,
  as the answer lists them: *not yet measured*, the missing `swift --version` step, and the
  *verified by*'s "no command reads which toolchain CI builds with". (3) The `macos-26` toolchain is
  named as a re-measurement, and none exists yet. (4) The tools-6.2 departure keeps one trigger, the
  change that writes the `6.2` tools version. Its two other triggers become one dated note, and the
  sentence that its own CI build checks the ground is added. **§ 3.2 → QC-25 and § 10, as
  answered.** QC-25's runner clause is dated to `macos-14`, run 35797893381 (SDD RN-48), and says
  the `macos-26` reading is not yet taken. The entry gains the standing reading, and the command
  that takes it is this document's own realization, held by no script. Until the change that makes
  the suite's log carry the line lands, `development-design` reading QC-25 is the gate on the three
  paths the answer names. The answer's two outcomes, `denied` and `allowed`, are stated in the tail.
  § 10's QC-25 row gains the reading. § 9's "and re-measures QC-25's hosted-runner narrowing … on
  the new image" sits in the dated note that points to QC-25. Which change makes the suite print the
  line is the PM's to schedule, and neither record names it. **Where the fold goes beyond the
  answers' words, each named.** (a) QC-25's body gains one sentence, that every hosted build shows
  the control's read result in its own log. The answer put the realization in the tail; the body
  states the obligation the tail verifies, so an entry is not checked against a rule it never
  states. (b) The answering run left one call to the fold: whether to record every reading or only
  the first on each image version. The tail records the first on each image version, as § 9 records
  the toolchain, and as the answering run leaned. (c) The answer turned the *verified by*'s ground
  into a dated note and gave no new ground. Both review gates still stand, so the class-2 downgrade
  is argued afresh: no script holds either check. The seven-flip rule is read off the manifest's
  diff, and the *Framework* rule binds only the files a change adds. Each remains a review bar at
  `development-design` until a check is written. **What does not move.** QC-56 already reads
  `macos-26`, and its tail's sentence that the tree meets neither half is pinned to
  `ka-reader@d6405e2`, so it stands. At `ka-reader@fcb2e2f` its workflow check prints nothing, which
  means the workflow half is now met. The plist, manifest and deployment-target half is not met:
  `Package.swift:L1` still reads `swift-tools-version:5.9`. The dated `macos-14` readings at QC-62's
  tail, § 9's earlier notes and these Review Notes stand. "Five files import XCTest at
  `ka-reader@f46269a`" is pinned and stands in the dated note; 32 tracked files import it at
  `ka-reader@fcb2e2f`. **No candidate record.** ADR-0010 dates its runner measurement
  (`:L131-L136`, "measured on 2026-09-23"), and that dating is what keeps an image move from
  reaching the log. A per-build reading and a dated clause are verification moves. Undoing either is
  cheap, and neither involved a real trade-off. If the `macos-26` reading contradicts the
  narrowing, the change starts at C-I3, and a record follows then. No ADR is written, edited or
  restatused, and the index does not move. No `QC` is added, renumbered or reused. **Measured for
  this run at `ka-reader@81734d9`.** `git status --porcelain` printed nothing at intake.
  `ci.yml:L18` reads `runs-on: macos-26`, `:L19` the no-Xcode comment, and `:L23-L24` the
  `Toolchain` step. `git merge-base --is-ancestor d852457 origin/main` succeeds, `git branch -r
  --contains fcb2e2f` prints nothing, and `origin/main` is `ka-reader@8926052`. `gh run view`
  returned the following. Run 37845881070 is on `main` at `ka-reader@fcc3d4f`, 2026-10-08, with
  `success`; its `Set up job` reads image `macos-14-arm64` version 20260831.0302.1, and its
  `Toolchain` step prints "Apple Swift version 6.0.3 (swiftlang-6.0.3.1.10 clang-1600.0.30.1)" and
  `15.2`. Run 38449250910 at `ka-reader@8926052` prints the same. `gh run list` lists no `main` run
  between `ka-reader@d852457` and run 37845881070. The QC-25 reading command, run against both,
  printed nothing. `checks/bundle.sh:L382` holds `printf '%s\n' "$probe_output"`
  *(read at v50: that line is `:L383` at `ka-reader@81734d9` and at every commit read since, so
  this note mis-read it on the day it was written; the note stands as written — RN-61)*,
  `test_bundle.sh:L144-L146` the capturing `run_bundle_sh`, and `:L1573-L1577` the `ok`-only
  success path. `git log --since=2026-10-08 --diff-filter=A -- ka-reader-mac/Tests` printed
  nothing, and no tracked file under `ka-reader-mac/Tests/` imports `Testing`. **Known limits.**
  This run read the two companions' diff since `ka-reader@8926052`, the workflow's, and the other
  inputs at their status lines. It read two hosted CI logs, by step name. It built no bundle and
  ran no test suite or `checks/*.sh` script; it ran QC-56's workflow `grep` once. **The
  companion.** Nothing is left for the owner, so the companion is removed and `Status:` is Settled
  *(re: header `Version:`; QC-25; § 9, the Swift-packet bullet's *Framework*, *Toolchain* and
  tools-6.2 clauses and its *verified by*; § 10, the QC-25 row; source:
  `docs/trail/architecture/cycle-41.md` §§ 3.1, 3.2; `docs/trail/architecture/self_answer-46.md`;
  `docs/SDD.md` v48 RN-48, RN-108; the tree at `ka-reader@fcb2e2f`, measured at `ka-reader@81734d9`)*

- **RN-60:** *(v49 — the close: the cycle-42 fold, §§ 3.1 and 3.2 answered)* **Intake.** The
  companion on disk had two § 3 items and nothing in §§ 1 or 2. No `product-architecture` run wrote
  it. The PM opened it on 2026-10-14 (`ka-reader@175c40e`), after the change that moves the product
  to its macOS 26 floor merged to `main` (`ka-reader@f0f1e5f`). A `companion-self-answer` run
  answered both in the owner's seat, decided together (`ka-reader@f2d02bf`; reasoning
  `docs/trail/architecture/self_answer-47.md`). The file was clean in git at intake and both slots
  were filled, so it is consumed. It was copied whole to `docs/trail/architecture/cycle-42.md`
  before this fold's first edit, and `cmp` found the two identical. **Whose answer this is.** The
  fold rests on the ground RN-54 to RN-59 rest on: both answers bind only the records' consistency
  with the tree, with hosted CI logs and with the settled SDD, and the owner can reverse the fold
  with one revert. **What moved beneath this document.** `git diff --stat 4601cd9 HEAD -- docs`
  lists SDD v49 (`ka-reader@23e197d`), its trail and self-answer, this companion and its
  self-answer. SDD v49 moves § 4 C-I3 alone (SDD RN-109): the probe's hosted-runner narrowing is
  dated to the image it was read on, the reading is named as taken on every hosted build from the
  control's `out-of-grant-read:` line, and *Violated by* gains a hosted build whose suite log
  carries no such line once the suite prints it. RN-59 said QC-25's trace to C-I3 would be re-read
  when the CTO folded that item, and this fold re-reads it. The two stores already agreed on the
  dating and on the per-build reading, so QC-25's body gains only the *Violated by* sentence, and
  its trace names C-I3 at v49, with the old "the probe half unchanged since v9" in a dated
  parenthesis. Every input's `Status:` line still reads Settled, so `Inputs read:` stands as it
  reads. `git diff --stat f0f1e5f HEAD -- . ':!docs'` prints nothing, so the tree this fold cites
  is `ka-reader@f0f1e5f`'s. **§ 3.1 → § 9's Swift-packet bullet, confirmed with addition.** The
  departure passage becomes *Adopted in the tree at `ka-reader@f0f1e5f`*, dated, naming the
  artifact-bundle route — `assemble.sh` writes the git-ignored bundle from the tracked module map —
  as the item asked. The answer's additions, each placed: (1) the adoption is dated to the tree,
  not to CI, and the first hosted build of the `6.2` manifest is named as the confirming reading;
  (2) the `type == "system"` clause is followed as written but no check holds it, so a refusal is
  named as owed to `checks/no-network.sh` and its suite, and the `development-design` review on
  `Package.swift` holds it until then; (3) the departure-only words go to this note, quoted whole
  below, and the passage carries a dated parenthesis that points here; (4) the *verified by* gate
  "flip together or not at all" is spent and is re-aimed at "the seven stay adopted", read off
  `dump-package`; (5) RN-25 stays as written, since review notes are history, and this note records
  that the departure it describes has ended; (6) no record is owed. **§ 3.2 → § 9's *Toolchain*
  clause, § 9's runner paragraph and § 8, confirmed with addition and the item's last sentence
  overridden.** The *Toolchain* clause cites `ci.yml:L31-L32` (`Build KA-Reader.app`) before
  `:L34-L35` (`Test gate`) at `ka-reader@f0f1e5f`, and the old citations go to a dated note. The
  answer's additions, each placed: (1) the precondition is stated once, in § 9's runner paragraph,
  and the eleven *verified by* tails and § 10 rows that name `swift test --package-path
  ka-reader-mac` read under it, unedited; (2) the precondition is every run, not only a fresh
  checkout, because `assemble.sh` rebuilds the bundle each time (`:L70-L74`); (3) § 8 names the
  project card's `Test command:` as owing the assembly, a move that is `product-card`'s, in the form
  `docs/SDD.md` RN-60 used, and the card is not edited; (4) the override: the `macos-26` toolchain
  reading exists — run 38463966607 on `ka-reader@4601cd9`, Swift 6.3.3, SDK 26.5, image
  `macos-26-arm64` 20260907.0351.1 — and the clause records it, with "none exists yet" in a dated
  note. **Where the fold goes beyond the answers' words, each named.** (a) The *Adopted* passage
  names the language mode as written out in the manifest (`swiftLanguageModes: [.v6]`,
  `Package.swift:L49`), because the packet asks for it written (`toolchain.md` § Language mode)
  and the item named only the mode `dump-package` reports. (b) The *verified by* names
  `no-network.sh`'s reach as the `dependencies` and `url` conditions in place of "the Swift half
  of the dependency gate", which would now claim the `system` condition it does not hold. (c) The
  runner paragraph quotes the measured failure of `swift build`, which is what the answering run
  measured, and cites `assemble.sh:L10-L12` for `swift test` resolving the same target, rather
  than claiming a `swift test` measurement nobody took. (d) § 8's existing "(RN-60)" named the
  SDD's RN-60 and would now read as this note, so it is spelled `docs/SDD.md` RN-60. (e) Found
  while folding, and fixed in place as small: three citations of `.github/workflows/ci.yml` named no
  commit and had gone false — QC-3's `:L41`, `:L51`, `:L54` and two citations of `:L26` for
  `cargo test --workspace --locked` (§ 1.1 and § 1.3). Each is re-pinned to `ka-reader@f0f1e5f`
  (`:L32`, `:L57`, `:L60`; `:L35`), with the old lines, true through `ka-reader@c915d52`, in a
  dated note. What each cites is unchanged. The `:L26` in § 9's suites bullet sits inside a
  sentence pinned to `ka-reader@b158052` and stands. **The departure, whole, as it read through
  v48** — the words § 3.1 sends here:

  > *Departed from, as one decision, until the change that
  > writes the `6.2` tools version:* the `6.2` tools version
  > (`Package.swift:L1` reads `5.9`); the `.binaryTarget` artifact-bundle link (`:L19`, `:L26-L29`
  > link `libka_reader_bridge.a` as a system library with a `-L` linker flag, the route the packet
  > lists second among its alternatives); `.treatAllWarnings(as:)` on every target (none set); the
  > Swift 6 language mode, written as `swiftLanguageModes: [.v6]` for every target (the 5.9 manifest
  > leaves every target in Swift 5 mode); `.strictMemorySafety()` on every Swift target, including
  > `SurfacesTests` and `ShellTests`; and `.defaultIsolation(MainActor.self)` on `Surfaces` and
  > `KAReader`, but not on `Shell`, `SurfacesTests` or `ShellTests`. The manifest APIs for the three
  > settings need `PackageDescription` 6.2 (`toolchain.md` § Toolchain version; `quality_gates.md`
  > § Types; `conventions.md` concurrency rules), and CI's image, `macos-26` (`ci.yml:L18` at
  > `ka-reader@fcb2e2f`), builds with its own default Xcode and selects none (`:L19`). Which Swift
  > it carries is unread until the *Toolchain* clause's re-measurement; the last one measured, Swift
  > 6.0.3 on `macos-14`, is below 6.2, which was released on 2025-09-15
  > (https://www.swift.org/blog/swift-6.2-released/, read 2026-09-23).
  > The floor at `26.0` (QC-56) brings this departure's end with it: `.macOS(.v26)` is introduced in
  > SwiftPM 6.2 (Apple's documentation data for `SupportedPlatform.MacOSVersion.v26` reads
  > `"introducedAt": "6.2"`,
  > https://developer.apple.com/tutorials/data/documentation/packagedescription/supportedplatform/macosversion/v26.json,
  > read 2026-10-13), so `Package.swift:L1` moves with the floor (`docs/SDD.md` RN-108), and the
  > change that writes the `6.2` tools version adopts the other five with it, because the six are
  > departed from as one decision. The measured source cost below is that change's *(added at v47 —
  > RN-58)*.
  > **That change is the departure's one trigger.** Its own CI build checks the ground: the tools
  > version is a floor the compiler enforces (`toolchain.md` § Toolchain version), so a toolchain
  > below 6.2 refuses the `6.2` manifest and the job goes red, and no separate gate is owed
  > *(through v47 the departure carried two further triggers — it ran "until CI builds
  > `ka-reader-mac` on an image carrying a Swift 6.2 or later toolchain", and "if [the first CI log]
  > shows a 6.2 or later toolchain the departure's ground is gone and all six are adopted then.
  > Otherwise the change that moves CI to such an image adopts all six together and re-measures
  > QC-25's hosted-runner narrowing, taken on `macos-14` (`docs/SDD.md` RN-48), on the new image" —
  > and read CI's image as "`macos-14` (`ci.yml:L18`), [which] offers Xcode 15.0.1 – 16.2 with 15.4
  > the default" (https://github.com/actions/runner-images/blob/main/images/macos/macos-14-arm64-Readme.md,
  > read 2026-09-23). The CI move landed at `ka-reader@fcb2e2f` adopting none of the six, as the
  > review gate below requires. Both triggers give way to the one above, which agrees with
  > `docs/SDD.md` RN-108 tying the tools version to the floor, and the narrowing's re-measurement is
  > QC-25's, taken on every hosted build; re-derived at v48 on the owner's seat's answers at
  > `docs/trail/architecture/cycle-41.md` §§ 3.1, 3.2 — RN-59)*.
  > The adoption's measured source cost is explicit. Swift 6 mode refuses
  > `ka-reader-mac/Sources/Shell/LaunchFlow.swift:L60`, `:L107` and `:L111` at `ka-reader@7c7038f` (each
  > `bridge`, an `any Bridging`, captured in a `@Sendable` closure — the measured site was the
  > `listTree` closure, `:L53` at `ka-reader@6e1d79f` and `:L107` now; `:L60`, the open closure, and
  > `:L111`, the `selectFile` closure, were added after it and fail the same way — RN-33) and
  > `ka-reader-mac/Sources/Shell/ReadRunning.swift:L28` (`deliver`, a
  > `@MainActor (RootListing?) -> Void`, sent across one), plus any site added before the flip. No
  > target carries `StrictConcurrency` meanwhile: without warnings-as-errors its diagnostics cannot
  > fail the Test gate, and CI's unmeasured compiler leaves the setting's required spelling unknown.
  > Strict memory safety requires explicit `unsafe` acknowledgements at the C-pointer uses in
  > `ka-reader-mac/Sources/KAReader/NativeBridge.swift` and the AppKit `unowned(unsafe)` properties in
  > `ka-reader-mac/Sources/Surfaces/RootItemsView.swift`. No separate current source failure is named
  > for default isolation: with Swift 5 mode held, the current `KAReader` target builds with default
  > isolation on `Surfaces` and `KAReader` (RN-31).
  > *Departed from, with the same flip — the packet's dependency gate's `type == "system"`
  > clause:* the packet's gate refuses any target whose `type` is `"system"` (`quality_gates.md`
  > § The gates — `select(.url != null or .type == "system")`), and `ka-reader-mac` links the bridge
  > through `.systemLibrary(name: "CKAReaderBridge")` (`Package.swift:L19`), so that gate as written
  > fails the tree as built. The departure is that one clause and nothing else, for the same reason
  > as the link: the system library is a module map over `ka-reader-bridge`'s generated header, that
  > crate is this repository's own and is on `checks/deps.allow`, and the link brings nothing new
  > into the tree. `checks/no-network.sh` stands in the gate's place: it holds the gate's other two
  > conditions — a non-empty `dependencies` array and a target carrying a `url` (`:L31-L32`) —
  > reads the dump with `plutil` rather than `jq`, and refuses a `Package.resolved` at any depth
  > under the package (`:L149`), wider than the packet's working-directory test. The clause departs
  > only because the system-library link exists, so it flips with the six above: when the
  > artifact-bundle link replaces the system library, no target has `type == "system"` and the
  > packet's gate is followed as written *(on the owner's seat's answer at
  > `docs/trail/architecture/cycle-11.md` § 3.6 — RN-25)*.

  **What does not move.** QC-56 reads the floor at `26.0`, and its sentence that the tree meets
  neither half is pinned to `ka-reader@d6405e2` and stands. At `ka-reader@f0f1e5f` the manifest
  half is met (`Package.swift:L23`); the plist half is not read by this fold. Neither QC-26 nor
  QC-3 claims the `system` condition, so neither gains it; QC-3 moves only by the re-pin in (e). The *Framework* clause, adopted at v48,
  does not move, since 6.3.3 is a Swift 6 toolchain. **No candidate record.** The adoption is the
  departure's own trigger firing, and `docs/SDD.md` RN-108 ties the tools version to the floor. The
  artifact-bundle link is the route the packet lists first, and undoing it is a one-file change, so
  it fails the hard-to-reverse gate. `docs/adr/` mentions neither `systemLibrary` nor the tools
  version. No ADR is written, edited or restatused, the index does not move, and no `QC` is added,
  renumbered or reused. **Measured for this run at `ka-reader@f2d02bf`.** `git status --porcelain`
  printed nothing at intake. `Package.swift:L1` reads `// swift-tools-version:6.2`, `:L23`
  `platforms: [.macOS(.v26)]`, `:L30` the `.binaryTarget`, and `:L49` `swiftLanguageModes: [.v6]`.
  `.gitignore:L32` ignores the bundle. `ci.yml:L31-L32` is `Build KA-Reader.app` and `:L34-L35` is
  `Test gate`, and `git show d2694c7^:.github/workflows/ci.yml` names `Test gate` at `:L29` and
  `Build KA-Reader.app` at `:L44`. `checks/no-network.sh:L31-L32` and `:L131-L138` hold the two
  conditions it refuses and no other. `assemble.sh:L53-L74` writes the bundle from the module map.
  `origin/main` is `ka-reader@3f7a68d`, and `git merge-base --is-ancestor f0f1e5f origin/main`
  fails. `gh run list` lists run 38501500758 on `ka-reader@3f7a68d` with `success`, and its log
  prints image `macos-26-arm64` version 20260907.0351.1 and "Apple Swift version 6.3.3
  (swiftlang-6.3.3.1.3 clang-2100.1.1.101)". The CI line histories in (e) were read with
  `git show <commit>:.github/workflows/ci.yml`. **Known limits.** This run read the SDD's diff since
  `ka-reader@4601cd9` and the other inputs at their status lines. It did not re-run `dump-package`
  or the fresh-clone `swift build`, which the answering run measured, and it built no bundle and ran
  no test suite or `checks/*.sh` script. **The companion.** Nothing is left for the owner, so the
  companion is removed and `Status:` is Settled *(re: header `Version:`; QC-3; the two `ci.yml:L26`
  citations; QC-25; § 8; § 9, the runner paragraph and the Swift-packet bullet's *Toolchain*,
  *Adopted* and *verified by*; source: `docs/trail/architecture/cycle-42.md` §§ 3.1, 3.2;
  `docs/trail/architecture/self_answer-47.md`; `docs/SDD.md` v49 RN-108, RN-109; the tree at
  `ka-reader@f0f1e5f`, measured at `ka-reader@f2d02bf`)*

- **RN-61:** *(v50 — the close: the cycle-43 fold, § 3.1 answered)* **Intake.** The companion on
  disk had one § 3 item and nothing in §§ 1 or 2. No `product-architecture` run wrote it. The PM
  opened it on 2026-10-14 (`ka-reader@6fd689f`), after the change
  that makes the probe suite print the control's reading landed (`ka-reader@970ad65`). A
  `companion-self-answer` run answered it in the owner's seat, *confirmed with addition*
  (`ka-reader@0c1c6de`; reasoning `docs/trail/architecture/self_answer-48.md` § 3.1). The file was
  clean in git at intake and its slot was filled, so it is consumed. It was copied whole to
  `docs/trail/architecture/cycle-43.md` before this fold's first edit, and `cmp` found the two
  identical. **Whose answer this is.** The fold rests on the ground RN-54 to RN-60 rest on: the
  answer binds only this document's agreement with the tree, with hosted CI and with the settled
  SDD, and the owner can reverse the fold with one revert. **What moved beneath this document.**
  `git diff --stat 47e8e6b 0c1c6de -- docs` lists SDD v50 (`ka-reader@a67c257`), its trail and
  self-answer, this companion and its self-answer. SDD v50 moves § 4 C-I3's probe half alone
  (SDD RN-110): the `:L383` locator, the suite's validated reading at `970ad65` with the missing-line
  case of *Violated by* live from that commit, and the ground for the untaken `macos-26` reading
  restated. Every input's `Status:` line still reads Settled, so `Inputs read:` stands as it reads.
  Outside `docs/`, `git diff --stat 47e8e6b 0c1c6de` lists `checks/tests/test_bundle.sh` and
  `ka-reader-mac/Sources/KAReader/NativeBridge.swift`, and `git diff --stat 970ad65 0c1c6de -- .
  ':!docs'` prints nothing, so the tree this fold cites is `ka-reader@970ad65`'s. **§ 3.1 → QC-25's
  runner-reading passage, its trace, § 10's QC-25 row, and RN-59, confirmed with addition.** The
  passage states the suite's one validated reading and retires the gate that rested on
  `development-design` reading the entry for the two scripts; the `fcb2e2f` observation stands, whole,
  in a dated parenthesis; the hosted reading stays unmeasured; the locator reads `:L383`. The
  answer's additions, each placed: (1) the trace names C-I3 at SDD v50 and SDD RN-110, so this
  document follows its input rather than stating the reading fresh; (2) the `development-design`
  gate is narrowed rather than retired — it holds a change to `.github/workflows/` that renames or
  drops the `Bundle probe suite` step, because the reading command matches the step by name and no
  check holds the name, and the passage argues the downgrade in its own words; (3) the passage names
  the boundary: an empty read is the not-yet until a hosted run on `main` that holds `970ad65`
  concludes the step `success`, and a break from that run on; (4) RN-59's `:L382` is corrected by a
  dated note beside it and not rewritten, since a review note is history — `:L383` was the line at
  `81734d9`, the commit that note names; (5) the fold re-read `origin/main` and the newest `main` run
  at its own time, below, and no run holding `970ad65` exists, so the not-yet stands and no
  `macos-26` reading is recorded; (6) no record is owed. **Where the fold goes beyond the answer's
  words, each named.** (a) The break is written as a build whose *Bundle probe suite* step concludes
  `success` and for which the command prints no line, rather than any build with no line: a red
  suite is already a red build, and the reading is not read off a red run, as the answer's own
  *Refused* case puts it. (b) § 10's gate cell names the narrowed workflow gate in place of
  "`development-design` reading the entry until the line prints", and its command cell names the
  boundary in place of "prints nothing until the suite's log carries the line"; the row is a
  projection of the entry, so it carries no dated note of its own. (c) The passage cites
  `publish_control_reading` at `:L629-L644`, the function, where the item cited `:L629-L661`, which
  runs on to the control case that calls it at `:L661`; the answer's own reasoning cites
  `:L629-L644`. **What does not move.** § 9's suites bullet is unchanged: it holds that the step
  exists, which is true, and the passage says what it does not hold. QC-25's two verification halves,
  its *verified by* classes and every other clause stand. **No candidate record.** The suite's
  validation is a verification move, cheap to undo and with no real trade-off, and `grep -rn L382
  docs/adr` prints nothing. No ADR is written, edited or restatused, the index does not move, and no
  `QC` is added, renumbered or reused. **Measured for this run at `ka-reader@0c1c6de`.** `git status
  --porcelain` printed nothing at intake. `git show <commit>:checks/bundle.sh | grep -nF` finds
  `printf '%s\n' "$probe_output"` at `:L383` (the negative-control branch) and `:L439` at
  `81734d9`, `fcb2e2f`, `24be581`, `970ad65` and `0c1c6de`. At `970ad65`, `test_bundle.sh:L629`
  opens `publish_control_reading`, `:L639` holds the `^out-of-grant-read: (denied|allowed)$` match,
  `:L661` calls it from the control case, `:L833` opens
  `test_negative_control_missing_read_fails_the_suite`, and `:L1710` forwards the control's output;
  `ci.yml:L53` names the `Bundle probe suite` step. `git ls-remote origin refs/heads/main` prints
  `24be581344cee53ca7741c5b66a9a9bae0623c4b`, and `git merge-base --is-ancestor 970ad65 origin/main`
  fails. `gh run list --branch main --limit 4` lists run 38551538187 on `24be581`
  (2026-10-14T10:43:17Z, `success`) as the newest. **Known limits.** This run read the SDD's v50
  header and C-I3's probe half and the other inputs at their status lines. It did not re-read run
  38551538187's log; that the command prints nothing there is SDD v50's reading and follows from the
  run's commit. It built no bundle and ran no test suite or `checks/*.sh` script. **The companion.**
  Nothing is left for the owner, so the companion is removed and `Status:` is Settled *(re: header
  `Version:`; QC-25, the runner-reading passage, its trace and its tail; § 10's QC-25 row; RN-59;
  source: `docs/trail/architecture/cycle-43.md` § 3.1;
  `docs/trail/architecture/self_answer-48.md` § 3.1; `docs/SDD.md` v50 RN-110; the tree at
  `ka-reader@970ad65`, measured at `ka-reader@0c1c6de`)*
- **RN-62:** *(v51 — the close: the cycle-44 fold, § 3.1 answered)* **Intake.** The companion on
  disk had one § 3 item and nothing in §§ 1 or 2. No `product-architecture` run wrote it. The
  Principal PM opened it on 2026-10-14 (`ka-reader@3c420cc`), from the `nemawashi-refine` run that
  answered a retired seed, after the first hosted run on `main` holding `ka-reader@970ad65` had
  concluded. A `companion-self-answer` run answered it in the owner's seat, *fold it*
  (`ka-reader@b0f2980`; reasoning `docs/trail/architecture/self_answer-49.md` § 3.1). The file was
  clean in git at intake and its slot was filled, so it is consumed. It was copied whole to
  `docs/trail/architecture/cycle-44.md` before this fold's first edit, and `cmp` found the two
  identical. **Whose answer this is.** The fold rests on the ground RN-54 to RN-61 rest on: the
  answer binds only this document's agreement with hosted CI and with the settled SDD, it applies a
  rule QC-25's own tail already states — a `denied` reading leaves the narrowing standing, re-dated
  with the run id and the image version (RN-59) — and the owner can reverse the fold with one
  revert. **What moved beneath this document.** `git diff --stat f357008 b0f2980` lists SDD v51
  (`ka-reader@761bd6e`), its trail cycle and self-answer, this companion and its self-answer, and
  nothing outside `docs/`. SDD v51 re-dates § 4 C-I3's probe half to the same run and image and
  keeps the narrowing standing, "on `macos-26` as on `macos-14`" (SDD RN-111). Every input's
  `Status:` line still reads Settled, so `Inputs read:` stands as it reads. **§ 3.1 → QC-25's
  narrowing passage, its runner-reading passage, its trace and § 10's QC-25 row, as answered.**
  (1) The narrowing is a reading of two images, `macos-14` at run 35797893381 and `macos-26-arm64`
  20260907.0351.1 at run 38577309118, the first reading on that image version and the one recorded;
  the v50 sentences that said it had not been read there, and the argument that the gap overclaimed
  nothing, stand in a dated note. (2) "The hosted reading is not yet taken" and its not-yet boundary
  become a dated account; the break rule is live from run 38577309118; runs 38501500758 and
  38551538187 stay readings from before the boundary, not breaks, because neither commit holds
  `970ad65`. (3) The trace reads C-I3 at SDD v51 and SDD RN-111, so this document follows its input
  and does not state the reading on its own authority. (4) § 10's command cell names the break
  directly and drops the not-yet; the row is a projection of the entry and carries no dated note of
  its own (RN-61 (b)); the gate cell does not move. **Where the fold goes beyond the answer's words,
  each named.** (a) The rename sentence now ends "which reads as a break whether or not the wall
  held", where it read "the same as the not-yet": with the not-yet gone, a renamed step's empty
  read is a break, which is the consequence the answer's reasoning names
  (`self_answer-49.md` § 3.1, fold step 2) and one more reason the narrowed `development-design`
  gate on a workflow change stays as it is. (b) "Why the runner reports it that way is not known,
  and whether the one Mac measured reports that read allowed for the control is not recorded" stays,
  because it is still true. **What does not move.** QC-25's two verification halves, its
  *verified by* classes, the tail rule on a `denied` or an `allowed` reading, and every other clause
  stand; § 9's suites bullet holds that the step exists, which is still true. **No candidate
  record.** The re-dating is cheap to undo and involved no trade-off, and ADR-0010, ADR-0011 and
  ADR-0012 bind the probe and the wall, not a runner reading. No ADR is written, edited or
  restatused, the index does not move, and no `QC` is added, renumbered or reused. **Measured for
  this run at `ka-reader@b0f2980`.** `git status --porcelain` printed nothing at intake.
  `gh run view 38577309118 --repo kensaiapp/ka-reader --json …` gives `headBranch` `main`,
  `headSha` `f3570082ed190b472635d7c87c391fc36c3170a8`, `createdAt` 2026-10-14T14:04:45Z,
  `conclusion` `success`, and step *Bundle probe suite* `success`; QC-25's command on its log prints
  exactly one line — job `wall`, step *Bundle probe suite*, stamped 2026-10-14T14:15:35.9622300Z —
  reading `out-of-grant-read: denied`;
  its *Set up job* step prints `Image: macos-26-arm64`, `Version: 20260907.0351.1`, macOS `26.6.2`
  `25G83`. `git merge-base --is-ancestor 970ad65 f357008` holds, and `git ls-remote origin
  refs/heads/main` prints `f3570082ed190b472635d7c87c391fc36c3170a8`. **Known limits.** This run read
  the SDD's v51 header, C-I3's probe half and RN-111, and the other inputs at their status lines. It
  did not re-read the logs of runs 38501500758 and 38551538187; that the command prints nothing
  there is SDD v50's reading, and that neither commit holds `970ad65` is the self-answer's
  measurement. It built no bundle and ran no test suite or `checks/*.sh` script. **The companion.**
  Nothing is left for the owner, so the companion is removed and `Status:` is Settled *(re: header
  `Version:`; QC-25, the narrowing passage, the runner-reading passage and its trace; § 10's QC-25
  row; source: `docs/trail/architecture/cycle-44.md` § 3.1;
  `docs/trail/architecture/self_answer-49.md` § 3.1; `docs/SDD.md` v51 C-I3, RN-111; GitHub Actions
  run 38577309118, read at the source for this run)*
- **RN-63:** *(v52 — the cycle-45 fold, §§ 3.1 and 3.2 answered; § 2.1 drafted for the owner)*
  **Intake.** The companion on disk had two § 3 items and one § 2 item. No `product-architecture`
  run wrote it. The owner opened it on 2026-10-14 to carry two items met while walking ka-reader
  that day. A `companion-self-answer` run answered both in the owner's seat (`ka-reader@d5b18d3`;
  reasoning `docs/trail/architecture/self_answer-50.md` §§ 3.1, 3.2) and raised § 2.1 on this
  document with a proposal and no draft, its slot left for the next round. The file was clean in git
  at intake and two slots were filled, so it is consumed. It was copied whole to
  `docs/trail/architecture/cycle-45.md` before this fold's first edit, and `cmp` found the two
  identical. **Whose answer this is.** The fold rests on the ground RN-54 to RN-62 rest on: the
  answers bind only this document's agreement with the card, with hosted CI and with the tree; they
  name no machine and commit nobody to infrastructure; and the owner can reverse the fold with one
  revert. **What moved beneath this document.** `git diff --stat 0e3ad5e d5b18d3` lists this
  companion and its self-answer, and nothing else. Every input's `Status:` line still reads
  Settled, and `git log -1` over the seven inputs is SDD v51 (`ka-reader@761bd6e`), the revision
  v51 read, so `Inputs read:` stands as it reads. **§ 3.2 → § 8 and RN-6, as answered.** § 8 quotes
  the card at `kensaiapp-opensource@d5005730`, the paragraph "the card does not say so yet" becomes
  a dated note, and RN-6 is extended with the pin. § 9's runner paragraph stays the precondition's
  one home and does not move. **§ 3.1 → §§ 8 and 9, as answered, no record.** (1) § 9's *Toolchain*
  clause states the reference rule: a change-time verdict stands in for CI only on the Swift version
  and SDK the clause records, a patch release included, and a run that names none proves the change
  on what it ran on and nothing more. § 8 gains one sentence saying where the gate runs is the
  card's and the pipeline's, and pointing at that rule; it names no machine. (2) § 9's runner
  paragraph states the window-server precondition beside the bridge's assembly. (3) The
  `#if compiler(>=6.4)` branch in `NativeBridge.swift` is recorded as a bounded supported pair, its
  `#else` arm owed removal from the first CI log that prints Swift 6.4 or later. **Where the fold
  goes beyond the answers' words, each named.** (a) The rule's strict reading carries its own
  ground and cost — one patch difference checked, and no change-time run standing in for CI until
  one carries the recorded toolchain — taken from the answer's reasoning
  (`self_answer-50.md` § 3.1, check 3), so a later reader sees why the rule is not looser. (b) The
  ka-reader-mac bullet's *verified by* tail names what fails for the new clauses: the CI build on
  `main` for the reference rule and the `#else` arm, the `Toolchain` log for the arm's removal, and
  no hosted check for the `compiler(>=6.4)` arm. The answers named no verification, and a clause
  with none would be a sentence about the product. (c) The window-server sentence cites the helper's
  failure message at its lines and the 2026-10-14 occurrence as the owner raised it; this run did
  not reproduce the timeout. **§ 2.1 of the companion → § 9's *Adopted* passage, drafted, for the
  owner.** "The adoption is the tree's, not yet CI's" becomes a dated account: the first hosted
  build of the `6.2` manifest, run 38549778886, red at a source compile and not at the manifest
  load, fixed at `ka-reader@24be581`, and run 38551538187, the first green. The v49 words stand in a
  dated note, and the slot stays the owner's. **No candidate record.** The reference rule and the
  precondition are cheap to reverse and involve no structural trade-off. The one choice here that is
  hard to reverse — which environment the gate runs in — is the pipeline's, so the ADR the item
  conditioned on is not owed. No record names a compiler version (`grep -l` for `Swift 6.`, `6.3.3` and
  `compiler(` over `docs/adr/*.md` prints nothing), so none is touched. No ADR is written, edited or restatused, the index does not move, and no
  `QC` is added, renumbered or reused; § 10 does not move, because no row names the card or the
  toolchain. **Measured for this run at `ka-reader@d5b18d3`, `origin/main` `ka-reader@f357008`.**
  `git status --porcelain` printed nothing at intake. `git merge-base --is-ancestor` holds for
  `f0f1e5f`, `47e8e6b`, `24be581` and `da79dcc` against `origin/main`. `gh run view 38549778886
  --repo kensaiapp/ka-reader` gives `headSha` `47e8e6b1…`, `headBranch` `main`, conclusion
  `failure`, job `wall` failing at `Build KA-Reader.app`, and its failed log prints
  `NativeBridge.swift:24:9` and `:28:9` with the error quoted above. `gh run view 38551538187` gives
  `headSha` `24be5813…`, conclusion `success`, and its log prints `Apple Swift version 6.3.3
  (swiftlang-6.3.3.1.3 …)`. `gh run list --workflow ci.yml --limit 5` lists 38577309118 on
  `f357008` `success` after them. `NativeBridge.swift:L23-L40` at `24be581` reads as cited, and
  `git diff --stat 24be581 f357008` over it, `LaunchWindowSupport.swift` and `.github` prints
  nothing. `LaunchWindowSupport.swift:L331` prints the message quoted. `ci.yml:L31-L35` reads the
  build and the test gate in that order. `git show d5005730:system/projects/ka-reader/project.md` in
  the managing instance gives the test command quoted, and `git log -1` over the card names that
  commit. **Known limits.** This run read the inputs at their status lines and the SDD's last
  commit; it built no bundle and ran no suite or `checks/*.sh` script. **The companion.** § 2.1
  awaits the owner, so the companion is rewritten with it alone and `Status:` is Draft *(re: header
  `Status:`, `Version:`; § 8; § 9's runner paragraph, *Toolchain* clause, *Adopted* passage and the
  bullet's *verified by* tail; RN-6; source: `docs/trail/architecture/cycle-45.md` §§ 3.1, 3.2, 2.1;
  `docs/trail/architecture/self_answer-50.md`; GitHub Actions runs 38549778886, 38551538187 and
  38577309118, read at the source for this run)*
- **RN-64:** *(v53 — the close: the cycle-46 fold, § 2.1 confirmed)* **Intake.** The companion on
  disk was the one v52 wrote, with one § 2 item and nothing in §§ 1 or 3. A `companion-self-answer`
  run confirmed it in the owner's seat (`ka-reader@a8f9c96`; reasoning
  `docs/trail/architecture/self_answer-51.md` § 2.1). The file was clean in git at intake and its
  slot was filled, so it is consumed. It was copied whole to `docs/trail/architecture/cycle-46.md`
  before this fold's first edit, and `cmp` found the two identical. **Whose answer this is.** The
  fold rests on the ground RN-54 to RN-63 rest on: the answer binds only this document's agreement
  with hosted CI and the tree, names no machine, commits nobody to infrastructure, and the owner can
  reverse the fold with one revert. **§ 2.1 → § 9's *Adopted* passage, as drafted.** The v52 words
  stand as written: the adoption is CI's as well as the tree's, the first hosted build of the `6.2`
  manifest is run 38549778886, red at a source compile and not at the manifest load, and run
  38551538187 is the first green. The answer adds one measured fact the draft asserted and the
  raising item did not measure — that no run before 38549778886 had a head carrying
  `ka-reader@f0f1e5f` — and it needs no new words, since "the first hosted build" already says it.
  The passage's dated note, "drafted at v52 … — RN-63", now reads drafted and confirmed, pointing
  at the trail cycle, as RN-27 and RN-50 did for their drafts. No other sentence moves. **What moved
  beneath this document.** `git diff --stat 8c39c73 a8f9c96` lists this companion and its
  self-answer, and nothing else. Every input's `Status:` line still reads Settled, and `git log -1`
  over the seven inputs is SDD v51 (`ka-reader@761bd6e`), the revision v52 read, so `Inputs read:`
  stands. **Re-measured for this run at `ka-reader@a8f9c96`, `origin/main` `ka-reader@f357008`.**
  `git status --porcelain` printed nothing at intake. `git merge-base --is-ancestor f0f1e5f
  origin/main` holds. `gh run list --repo kensaiapp/ka-reader --workflow ci.yml --limit 5` lists
  38577309118 (`success`), 38551538187 (`success`) and 38549778886 (`failure`) as the newest runs on
  `main`, in that order, with nothing after them, so the passage's account is still the current
  one. **No candidate record.** Confirming a dated account of hosted runs is cheap to reverse and
  involves no structural trade-off. No ADR is written, edited or restatused, the index does not
  move, no `QC` is added, renumbered or reused, and § 10 does not move, because no row names the
  passage. **Known limits.** This run read the inputs at their status lines and the SDD's last
  commit; it built no bundle and ran no suite or `checks/*.sh` script. **The companion.** Nothing is
  left for the owner, so the companion is removed and `Status:` is Settled *(re: header `Status:`,
  `Version:`; § 9's *Adopted* passage's dated note; source: `docs/trail/architecture/cycle-46.md`
  § 2.1; `docs/trail/architecture/self_answer-51.md` § 2.1; GitHub Actions runs 38549778886,
  38551538187 and 38577309118, listed at the source for this run)*
- **RN-65:** *(v54 — the close: the cycle-47 fold, § 3.1 answered)* **Intake.** The companion on
  disk had one § 3 item and nothing in §§ 1 or 2. No `product-architecture` run wrote it: the owner
  opened it on 2026-10-16 in an interactive session (`ka-reader@3870e48`) and answered it in the
  same commit. The file was clean in git at intake and its slot was filled, so it is consumed. It
  was copied whole to `docs/trail/architecture/cycle-47.md` before this fold's first edit, and `cmp`
  found the two identical. **Whose answer this is.** The owner's own, and it outranks every input.
  It binds where two of the harness's commands run and nothing about what they hold, and the owner
  can reverse the fold with one revert. **§ 3.1 → § 8, § 9's `checks/tests/` bullet, and § 10.**
  The question was whether § 10 gates `checks/structure.sh` and its suite at the change as well as
  the CI build, so the card's test command runs both; the answer is yes, both on every change, the
  suite's 2 min 20 s accepted, and every other `checks/*.sh` script left where § 10 has it. § 8
  gains the rule, its measured ground — the merge at `ka-reader@21cfd34` of doc examples that broke
  QC-2 and QC-15 while the card's command was green, CI red at run 38673999031, the repair at
  `ka-reader@527f030` — and the move it owes `product-card`, in the form RN-60 used: the card's
  command gains the pair. § 10's preamble states the change-time half once, and the ten rows that
  name `checks/structure.sh` — QC-2, QC-7, QC-9 – QC-12 and QC-14, QC-63, QC-13, QC-15 and QC-17,
  QC-20, the first QC-30 and QC-58 row, QC-36 and QC-61 — gain `the change` in *Runs over* and
  `development-implementation (the structure pair)` in *Gated at*, so a row's other commands keep
  their gate. **Two additions beyond the answer, each logged here.** (1) § 9's `checks/tests/`
  bullet says every suite runs as a CI step and that CI's test command runs none, both still true;
  without a pointer a reader of that bullet alone would conclude no suite runs at the change, so it
  gains one sentence pointing at § 8 and repeats nothing. (2) § 8 states that § 9's *Toolchain*
  clause does not bear on the pair. That clause holds a change-time verdict short of CI's unless
  the run carries the recorded Swift toolchain, and read alone it would discount the pair's
  change-time verdict too. It does not apply: the script reads source text and needs no toolchain
  or build (`checks/structure.sh`, *WHY THIS EXISTS*), and the suite runs the real script over
  copies of `crates/` and invokes neither `cargo` nor `swift` (`grep -nE '\bcargo\b|swift |rustc'
  checks/tests/test_structure.sh` prints nothing). **What stays open, and where.** The card does not
  carry the pair yet: `system/projects/ka-reader/project.md` in the managing instance reads
  `cargo test --workspace --locked && ka-reader-mac/assemble.sh && swift test --package-path
  ka-reader-mac`, and its comment says the harness "gates CI and release, not this field". Until
  `product-card` moves it, the change-time gate is the rule and not the run, and the gap the item
  raised stays open; § 8 and § 10's preamble both say so where a reader meets them. § 8's first
  paragraph and RN-6 still state the card as it reads at `kensaiapp-opensource@d5005730`, which is
  true today, and move when the card does. **What moved beneath this document.** `git diff --stat
  f3b3bb1 HEAD -- docs` lists this companion and nothing else. Every input's `Status:` line still
  reads Settled, and `git log -1` over the seven inputs is SDD v51 (`ka-reader@761bd6e`), the
  revision v53 read, so `Inputs read:` stands. **Re-measured for this run at `ka-reader@3870e48`**,
  on a fresh clone: `checks/structure.sh` prints `17 Rust files in 2 crates read — nothing found`
  and exits 0, and `checks/tests/test_structure.sh` exits 0 with 94 `ok` lines in 2 min 44 s. **No
  candidate record.** Where a gate runs is cheap to reverse — one line of the card — and it gives
  up nothing structural; it fails the first gate. `grep -n -i -E "change-time|test command|gates
  CI"` over `docs/adr/` prints nothing, so no accepted record says where the harness runs and none
  is superseded. No ADR is written, edited or restatused, the index does not move, and no `QC` is
  added, renumbered or reused. **Known limits.** This run read the inputs at their status lines and
  the SDD's last commit, and ran only the structure pair; it built no bundle and ran no other suite
  or script. **The companion.** Nothing is left for the owner, so the companion is removed and
  `Status:` is Settled *(re: header `Status:`, `Version:`; § 8; § 9 the `checks/tests/` bullet;
  § 10 preamble and ten rows; source: `docs/trail/architecture/cycle-47.md` § 3.1; GitHub Actions
  run 38673999031; `ka-reader@f1280b6`, `ka-reader@21cfd34`, `ka-reader@527f030`)*
- **RN-66:** *(v55 — the close: the cycle-48 fold, § 3.1 answered)* **Intake.** The companion on
  disk had one § 3 item and nothing in §§ 1 or 2. No `product-architecture` run wrote it: the owner
  opened it on 2026-10-16 in an interactive session and answered it in the same commit
  (`ka-reader@d1d4274`). The file was clean in git at intake and its slot was filled, so it is
  consumed. It was copied whole to `docs/trail/architecture/cycle-48.md` before this fold's first
  edit, and `cmp` found the two identical. **Whose answer this is.** The owner's own, and it
  outranks every input; it also follows three Settled inputs that moved first — PRD v16 § Assumptions
  "Public identity", SRS v13 C-12 and SDD v52 § 4 C-R4, whose reason is SDD RN-112. **§ 3.1 → a
  superseding record.** The answer moves where the release lives and leaves the decision as it was.
  ADR-0007 named `github.com/kensaiapp/ka-reader` in its *Context* and its *Decision*, and an
  Accepted record is never rewritten, so ADR-0024 restates ADR-0007 whole at the new address and
  supersedes it. ADR-0007's Status line now reads `Superseded by ADR-0024`, its only changed line,
  and the index follows. Superseding is right whether the owner meant a correction or a reversal: in
  both readings it keeps the history, and an in-place edit would lose it. So the run raises no item
  asking which was meant. **§ 3.1 → this document.** The forward-looking checks read
  `eyalgo/ka-reader`: QC-25's runner reading in § 2, QC-28's `gh secret list`, QC-42's repository
  and its `gh api` path, and the QC-25, QC-28 and QC-42 rows of § 10. Each entry keeps its old words
  in a dated note. QC-28, QC-29, QC-56 and QC-57, which ADR-0024 binds, and § 2's threat-model
  sentence on the release artifact trace to ADR-0024 in place of ADR-0007. **Not moved, and why.**
  The records of runs made at the old address stand as written, by the item's own *Not to change*:
  § 9's two `gh run` lines on the five suites' reading, and the `gh run` lines in RN-28, RN-62,
  RN-63 and RN-64. Review Notes that name ADR-0007 as it stood when they
  were written stand too: RN-18's, RN-22's and RN-58's. The bundle identifier
  `com.kensaiapp.ka-reader` (QC-55) is not a repository address and does not move. SDD § 4 C-R4 cites
  ADR-0007's *Context* for the owner's standing call. That citation still opens and is still true,
  and it is the CTO's to move, not this seat's. **Two additions beyond the answer, each logged
  here.** (1) QC-42 traces to SRS C-12 as well as C-7, because the repository it names is C-12's.
  (2) The card moved. RN-65 left § 8 owing a re-quote "when it moves", and it moved twice on
  2026-10-16. The test command gained `checks/structure.sh && checks/tests/test_structure.sh` after
  its Swift half (`kensaiapp-opensource@5be8615c`), and its comment stopped saying the harness stays
  out of the field (`kensaiapp-opensource@a4204e5b`). § 8's first paragraph re-quotes the card at
  `a4204e5b`. The structure-pair paragraph now says the card carries the pair. § 10's preamble now
  says `development-implementation` is the run as well as the rule on the pair's rows. RN-6 is
  extended. Each keeps its old words in a dated note. RN-6's closing count read "the eight commits
  named" while it named nine, since v52 added `d5005730` without moving the count; it now reads
  eleven. This is a found-while-walking repair, small and fixed in place. **No candidate record
  beyond ADR-0024.** Where a gate runs is cheap to reverse, and RN-65 already ruled that move out of
  the log. **What moved beneath this document.** `git diff --stat 1ea70ae d1d4274 -- docs` lists
  PRD, SRS and SDD, their three trail cycles, and this companion. SDD RN-112 names what moved, and
  every item is the address. Every input's `Status:` line still reads Settled, so `Inputs read:`
  stands. The SDD's last commit is v52 (`ka-reader@ab7ba0b`). **Read at source for this run:** `git
  remote -v` in the product checkout prints `origin git@github.com:eyalgo/ka-reader.git` for fetch
  and push. **Known limits.** This run read the inputs at their status lines and the SDD's RN-112
  for what moved, and did not re-read the PRD, SRS and SDD diffs line by line. It ran no `gh`
  command, built no bundle, and ran no suite or `checks/*.sh` script. The repository is private, so
  QC-42's check cannot pass before it is public. SDD RN-112 records it answering `HTTP 404` on
  2026-10-16. That is a condition on the first public release, not a change to the entry's bar.
  **The companion.** Nothing is left for the owner, so the companion is removed and `Status:` is
  Settled *(re: header `Status:`, `Version:`; § 2 threat model, QC-25, QC-28, QC-29, QC-42; § 8
  first and structure-pair paragraphs, QC-56, QC-57; § 10 preamble and the QC-25, QC-28 and QC-42
  rows; RN-6; source: `docs/trail/architecture/cycle-48.md` § 3.1; ADR-0024; `docs/PRD.md` v16;
  `docs/SRS.md` v13 C-12; `docs/SDD.md` v52 C-R4, RN-112; `kensaiapp-opensource@5be8615c`,
  `kensaiapp-opensource@a4204e5b`)*
- **RN-67:** *(v56 — the close: the cycle-49 fold, § 3.1 answered)* **Intake.** The companion on
  disk had one § 3 item and nothing in §§ 1 or 2. No `product-architecture` run wrote it: the owner
  opened it on 2026-10-16 in an interactive session, after switching GitHub Actions off on
  `eyalgo/ka-reader`, and answered it in the same commit (`ka-reader@bb2e4cb`). The file was clean
  in git at intake and its slot was filled, so it is consumed. It was copied whole to
  `docs/trail/architecture/cycle-49.md` before this fold's first edit, and `cmp` found the two
  identical. **Whose answer this is.** The owner's own, and it outranks every input. It states four
  requirements and leaves the shape to this seat: every rule the workflow holds is held by a gate that
  runs without GitHub; the app-launching and home-reading checks run only in the macOS guest; the
  toolchain of record is the gate's; and CI, if it returns, runs the same thing. **The split, and
  why it has one answer.** The requirement allowed "at the change, or at a stated point the pipeline
  reaches". The pipeline's gate tool issues the card's command at the developer's closing run and at
  code-integrity, and issues nothing at the seal for a product in its own repository
  (`gate_suite.py` v1.2.0, `run_gate`, `:L962`). So there is no later point, and every rule goes to
  the change: § 8's new paragraph and QC-64. The cost the owner measured — about 14 min more per
  gate run on the hosted runner, paid at both gates — is stated there. **Requirement 2 → QC-65.**
  The tool runs the card's command verbatim on the owner's Mac under the owner's ask (`mac_argv`),
  so only the product's own scripts can keep a step off that Mac. The entry has each launching or
  home-reading step refuse outside a virtual machine, red and never skipped, by ADR-0012's rule that a
  gate that cannot go red has not run. It also names the cost: under the owner's-Mac option no gate
  for this product can pass. **Requirement 3 → § 9's *Toolchain* clause.** The record moves from the
  hosted image's Apple Swift 6.3.3 to the guest's 6.3.2, both on SDK 26.5, read in the guest for
  this run. The strict patch rule stays: the guest and the last hosted image differ by a patch, and
  that gap is now named rather than hidden. Its two dependants follow: the `#else` arm's holder and
  its removal trigger. **Requirement 4 → QC-64's workflow half**, checked by a grep over the
  workflow's `run:` lines. **Two additions beyond the answer, each logged here.** (1) The guest
  depends on the workflow file. The tool sends a product with no CI to the owner's Mac
  (`resolve_environment`, `:L554-L560`), so `.github/workflows/ci.yml` stays in the tree with Actions
  off, and § 8 and QC-64 say so. (2) Two release-time obligations name CI and are not rules the
  workflow holds today: QC-29's tag build under SDD C-R4 and QC-25's hosted-log read under C-I3. They
  stand as the SDD writes them. While Actions is off, the first has no builder and the second has no
  run to read. Moving C-R4 is the CTO's, and it is raised by the first public release, not by this
  fold, so no companion item is written for it. **No candidate record.** Where a gate runs is cheap
  to reverse: one line of the card, and once QC-64 holds, one line of the workflow. RN-65 ruled the
  same move out of the log, and the same reasoning holds. ADR-0010 and ADR-0012 say their gates run
  "on every CI build". That stays true, and this fold adds the change as a second place they run;
  it reverses neither, so neither is superseded. No ADR is written, edited or restatused, and the
  index does not move. QC-64 and QC-65 are new, and no `QC` is renumbered or reused. **What moved
  beneath this document.** `git diff --stat bc84712 bb2e4cb -- docs` lists this companion and
  nothing else. Every input's `Status:` line still reads Settled, so `Inputs read:` stands. The
  header gains the Swift packet's `environment.md` v1.2.0, which § 9 now cites. **Read at source for
  this run, 2026-10-16:** `tart exec kensai-macos` printed `1` for `sysctl -n kern.hv_vmm_present`,
  `VirtualMac2,1`, macOS 26.6.2 (25G83), Apple Swift 6.3.2 (swiftlang-6.3.2.1.108), SDK 26.5 and
  `/Applications/Xcode_26.5.app/Contents/Developer`. On the owner's Mac the same reads printed `0`,
  `Mac16,5`, Apple Swift 6.4 (swiftlang-6.4.0.34.1) and SDK 27.0. The workflow's step list, and the
  `open` calls and container reads QC-65 names, were read at `ka-reader@bb2e4cb`. **Known limits.**
  This run read the inputs at their status lines and searched the SDD for what names CI; it did not
  re-read the SDD whole. It ran no gate, no suite and no `checks/*.sh` script, and built no bundle.
  The checks' cost in the guest is unmeasured. **The companion.** Nothing is left for the owner, so
  the companion is removed and `Status:` is Settled *(re: header `Status:`, `Version:`, the
  doctrine-file list; § 8 first paragraph, the new workflow paragraph, QC-64, QC-65; § 9 the
  `checks/tests/` bullet, the Swift bullet's *Toolchain* clause, its `#else` arm and its tail, the
  layers 6–7 bullet; § 10 preamble and the QC-64 and QC-65 rows; source:
  `docs/trail/architecture/cycle-49.md` § 3.1; GitHub Actions runs 38908439556, 38930009564,
  38673998411; `ka-reader@bb2e4cb`)*
- **RN-68:** *(v57 — the close: the cycle-50 fold, §§ 3.1 – 3.3 answered)* **Intake.** The companion
  on disk had three § 3 items and nothing in §§ 1 or 2. No `product-architecture` run wrote it: the
  PM opened it on 2026-10-16 from a review of the route after the change merged at
  `ka-reader@13e8d42` (`ka-reader@02a404a`), and the three items were answered in the owner's seat
  the same day (`ka-reader@dc5568b`; the reasoning at `docs/trail/architecture/self_answer-52.md`).
  The file was clean in git at intake and every slot was filled, so it is consumed. It was copied
  whole to `docs/trail/architecture/cycle-50.md` before this fold's first edit, and `cmp` found the
  two identical. **Whose answer this is.** The owner's seat's, and it outranks every input. Each
  item re-measures a sentence the tree had moved past, and none moves what an entry obliges.
  **§ 3.1 → QC-65's cost.** The cost read "a contributor with no virtual machine runs every step but
  these", and the own-state suite fails off a virtual machine too. The answer keeps the suite out of
  the set, because it launches nothing and reads no machine home, and names it in the cost with the
  reason it fails: twelve of its fourteen cases run the real `checks/own-state.sh` with no admitting
  reading. One clause corrects the item's own text. QC-65 forbids an option, flag or variable of the
  script's own, and a stand-in reading first on `PATH` is not one; the suite's admit case already
  uses it. Whether the other cases do the same is the delivery tier's call. **§ 3.2 → QC-65's
  *verified by*.** "Until the refusal lands" named an event that has happened. The tail now says
  the refusal and its cases are in the tree from `ka-reader@13e8d42`, and that the gap is held open
  by `checks/gate.sh` not being in the tree (QC-64; § 8, *Until the script lands*). Two additions
  ride on the answer. (1) A suite that refuses cannot run its own refusal case, so the cases for
  `checks/tests/test_bundle.sh` and `checks/tests/test_renderer.sh` are named in
  `checks/tests/test_vm_refusal.sh`, and § 10's QC-65 row follows. (2) The set's locators are
  re-pinned at `ka-reader@13e8d42`: the launch runs through `checks/launch.sh`, the own-state step
  through `checks/own-state-step.sh`, which has no admission of its own, and the two `open` lines
  the entry cites moved to `checks/bundle.sh:L355` and `checks/tests/test_bundle.sh:L339`. Each
  changed sentence keeps its old words in a dated note. **§ 3.3 → § 9's `checks/tests/` bullet.**
  The count moves from eight to eleven at `ka-reader@13e8d42`, with every step locator. Eight stays
  as history. The bullet says that `test_vm_refusal.sh` is counted and on a step though no script
  stands beside it, and that `checks/tests/support/` is a helper folder and not a suite. Its tail's
  "an eighth suite" becomes "a further suite". The fold does not claim `checks/gate.sh` runs any of
  them. **Read at source for this run, at `ka-reader@13e8d42`:** `git ls-tree --name-only 13e8d42
  checks/tests/` lists the eleven suites and `support`; the workflow's `name:` and `run:` lines put
  each suite at the lines § 9 names, the launch at `:L112-L113` and the own-state step at
  `:L117-L118`; the six refusal lines the item cites read as cited; `checks/launch.sh:L50`,
  `checks/bundle.sh:L355` and `checks/tests/test_bundle.sh:L339` are the `open` calls; the
  own-state suite's `CASES` list holds fourteen cases, and its admit case is at `:L279-L288`;
  `checks/tests/test_vm_refusal.sh`'s header and `CASES` list hold the two guarded suites' refusal
  cases; `checks/own-state-step.sh`'s header says it has no admission of its own; and `checks/gate.sh`
  is not in the tree at `HEAD`. `git diff --stat 13e8d42 HEAD -- . ':!docs'` prints nothing.
  **What moved beneath this document.** Since v56 (`ka-reader@8ef8c5b`), SDD v53 settled what the
  reader's held place holds and found the first collapse-and-scroll form at the model's API with no
  function joining SM-4's list; SDD v54 re-measured the `read-only-harness` row at `ka-reader@13e8d42`
  to the same files this fold names; and CONTENT v13 put the checks harness's output outside the
  standard. None of them contradicts an entry, so none moves one here. Every input's `Status:` line
  still reads Settled, so `Inputs read:` stands. **No candidate record.** Each move is a
  re-measurement of a pinned sentence and gives up nothing; it fails the first gate. No ADR is
  written, edited or restatused, the index does not move, and no `QC` is added, renumbered or
  reused. **Known limits.** This run read the inputs at their status lines and their version lines
  for what moved. It ran no gate, no suite and no `checks/*.sh` script, and built no bundle, so the
  `2 of 14 passed` figure is the PM's measurement and not this run's. **The companion.** Nothing is
  left for the owner, so the companion is removed and `Status:` is Settled *(re: header `Version:`;
  § 8 QC-65; § 9 the `checks/tests/` bullet; § 10 the QC-65 row; source:
  `docs/trail/architecture/cycle-50.md` §§ 3.1 – 3.3; `docs/trail/architecture/self_answer-52.md`;
  `ka-reader@13e8d42`)*
- **RN-69:** *(v58 — the cycle-51 fold, §§ 3.1 – 3.3 answered; § 2.1 drafted)* **Intake.** The
  companion on disk had one § 2 item and three § 3 items. No `product-architecture` run wrote it: the
  PM opened it on 2026-10-17 from a `shukuba-refine` review (`ka-reader@1557a34`), and a
  `companion-self-answer` run answered the three § 3 items in the owner's seat on 2026-10-20 and raised
  § 2.1 (`ka-reader@adf6d58`; the reasoning at `docs/trail/architecture/self_answer-53.md`). The file
  was clean in git at intake and three slots were filled, so it is consumed. It was copied whole to
  `docs/trail/architecture/cycle-51.md` before this fold's first edit, and `cmp` found the two
  identical. **Whose answer this is.** The owner's seat's, and it outranks every input. Each item
  re-measures a sentence the tree moved past when `checks/gate.sh` landed at `ka-reader@8b93322`, and
  none moves what an entry obliges. **§ 3.1 → QC-25's runner reading.** Overridden in the seat: the
  item's fold, `$2 == "Test gate"` alone, would print two `out-of-grant-read:` lines on every green
  run, the shipped bundle's first, so the one-line rule would fail every run and an empty read, the
  break, could never happen. The command now takes the line directly after the control case's `ok`
  line inside `Test gate`, which the suite holds. The break is restated per commit: on a commit that
  holds `ka-reader@8b93322`, a `Test gate` step that concludes `success` with this command printing no
  line; before it, the v57 selector and its break, under which run 38577309118's reading stands. The
  review gate now names two names, the step and the case, and the clause "no script holds that name"
  is rewritten to say which script holds what. § 10's row follows. **§ 3.2 → § 8, QC-64, QC-65 and
  § 9's *Toolchain* passage.** Confirmed with three additions. Each sentence waited on the script's
  landing and the card running it, and only the first has happened. § 8's paragraph becomes *Until
  the card runs the script*, records the PM's guest run at `ka-reader@726a234` as carrying to
  `8b93322`, and says nothing the NFDR names still stands in front of the card's move; the pointers in
  QC-64, QC-65 and § 9 move with it, and so does a fifth sentence of the same kind in § 9's suites
  bullet. QC-64's "held by no script" was false from `8b93322`: `checks/tests/test_vm_refusal.sh`, the
  gate's `VM refusal suite` step, holds both comparisons more strictly, except the workflow
  comparison's *nothing else* half, which stays a review gate on that ground; the rest keeps
  `development-design` as its gate on the run gap, not on a missing script. QC-64's "as it is for
  QC-56's workflow check" is dropped with it, since § 2.1 drafts QC-56 onto the same suite. **§ 3.3 →
  § 9's suites bullet and § 10's preamble.** Confirmed with three additions. A suite joins as a step
  of `checks/gate.sh`, and the workflow runs it through `Test gate`; the eleven are re-pinned at the
  gate's lines at `ka-reader@8b93322`, and the `13e8d42` workflow locators stay as history. "The test
  command (`ci.yml:L26`) runs none of them" was false at `8b93322`. The tail's owed check has been in
  the tree since `13e8d42` as `test_every_toplevel_suite_is_an_entire_fatal_step`, so the tail names
  it, and the review gate's ground becomes the run gap. *How a suite joins* names
  `test_no_conditional_or_nonfatal_step` as the check that refuses the ruled-out join at the workflow,
  and the bullet says the suite checks the gate's step list as well as the workflow's shape. § 10's
  preamble moves with the bullet. **§ 2.1 → QC-56, drafted.** Raised by the self-answer run, not
  answered. QC-56's tail said its runner check is "held by no script", and
  `test_every_runner_names_macos_26` has run that comparison since `ka-reader@13e8d42` (`:L211-L216`
  there). This run drafts the change into QC-56 and § 10's row, marked as drafted, because leaving it
  would have § 9 and QC-64 name a suite whose runner case QC-56 says does not exist. The gate stays
  `development-design` until the card runs the script, on the run-gap ground. If the owner overrides,
  QC-56's v57 words and § 10's v57 row return. **Read at source for this run:** `HEAD` is
  `ka-reader@adf6d58`, and `git diff --stat 8b93322 HEAD -- checks .github` prints nothing.
  `.github/workflows/ci.yml` has one rule step, `Test gate`, whose `run:` is `checks/gate.sh` (`:L26`),
  then packaging (`:L31-L32`) and upload; `runs-on: macos-26` (`:L18`). `checks/gate.sh` is mode
  `100755` with 26 `run_step` calls, the eleven suites at the lines § 9 names, `Bundle probe` at `:L53`
  and `Bundle probe suite` at `:L55`. `git diff --stat 726a234 8b93322 -- checks/gate.sh` shows four
  lines changed. `checks/bundle.sh:L457` prints the probe's output; `checks/tests/test_bundle.sh`'s
  runner prints the control's result after its `ok` line (`:L1765`, `:L1769`), and
  `:L867-L869` require that adjacency. `checks/tests/test_vm_refusal.sh` v1.1.0 lists nine cases,
  among them the four this fold names. The QC-25 command was run on a four-line sample log with a
  shipped-bundle line before the control's `ok` line and one after another case's, and printed only
  the control's line. In a disposable clone of `8b93322`, `checks/tests/test_vm_refusal.sh` passed 9 of
  9; with `runs-on: macos-latest` it failed `test_every_runner_names_macos_26` (8 of 9); with an
  unlisted `checks/tests/test_unlisted.sh` it failed `test_every_toplevel_suite_is_an_entire_fatal_step`
  (8 of 9). **What moved beneath this document.** Since v57 (`ka-reader@ea2bd9a`), SDD v55 re-measured
  the `read-only-harness` row at `8b93322`, naming `checks/gate.sh` as the runner and each suite as a
  step of the gate, and moved C-I3's two `ci.yml` locators to the gate's steps. It agrees with every
  move here and contradicts no entry. Every input's `Status:` line still reads Settled, so `Inputs
  read:` stands. **No candidate record.** Each move re-measures a pinned sentence and gives up
  nothing, so it fails the first gate. No ADR is written, edited or restatused, the index does not
  move, and no `QC` is added, renumbered or reused. **Known limits.** This run ran no gate and built no
  bundle, and it ran no hosted log: the guest run of `checks/gate.sh` is the PM's measurement, and run
  38577309118's log is the self-answer run's reading. Workflow locators elsewhere in this document
  that are pinned to earlier commits were not re-measured; each is true at its pin. **The companion.**
  § 2.1 awaits the owner, so the companion stays and `Status:` is Draft *(re: header `Version:` and
  `Status:`; § 2 QC-25; § 8 *Until the card runs the script*, QC-56, QC-64, QC-65; § 9 the
  `checks/tests/` bullet and the *Toolchain* passage; § 10 the preamble and the QC-25, QC-56 and QC-64
  rows; source: `docs/trail/architecture/cycle-51.md` §§ 2.1, 3.1 – 3.3;
  `docs/trail/architecture/self_answer-53.md`; `ka-reader@8b93322`)*
- **RN-70:** *(v59 — the close: the cycle-52 fold, § 2.1 confirmed with two additions)* **Intake.**
  The companion on disk held one item, § 2.1, which the v58 run drafted into QC-56 and § 10's row
  (RN-69). A `companion-self-answer` run answered it in the owner's seat on 2026-10-20
  (`ka-reader@20e4810`; the reasoning at `docs/trail/architecture/self_answer-54.md`). The file was
  clean in git at intake and its one slot was filled, so it is consumed. It was copied whole to
  `docs/trail/architecture/cycle-52.md` before this fold's first edit, and `cmp` found the two
  identical. **Whose answer this is.** The owner's seat's, and it outranks every input. Neither
  addition moves what QC-56 obliges; both make its tail say what the check reads and what the tree
  holds. **§ 2.1 → QC-56.** The v58 draft stands, and its *drafted* marker now names the
  confirmation. **Addition 1, the `.yaml` gap.** QC-56 binds every `runs-on` in the product's CI,
  and both the command and the suite case read only `.github/workflows/*.yml`, while GitHub runs a
  workflow file ending `.yaml` as well (the self-answer report's header names the source). The tail
  now says so, and names `development-design` reading the entry as the gate for such a file, a gate
  that stays after the card's command runs the script because the gap is in what the check reads.
  Whether the case is widened is the delivery tier's; the entry only stops implying coverage it does
  not have. § 10's row says the same in its command and gate columns. **Addition 2, the tree
  sentence.** "At `ka-reader@d6405e2` the tree meets neither half" was true at its pin and sat
  beside a check that now passes, so it is re-measured at `ka-reader@8b93322` and its old words go
  into a dated note. This run adds one locator the answer did not name:
  `ka-reader-mac/assemble.sh:L50`, the deployment target, which the `d6405e2` sentence listed among
  the lines holding the old floor and which now reads `MACOSX_DEPLOYMENT_TARGET=26.0`; naming it
  keeps the re-measured sentence covering every line the old one named. **Read at source for this
  run:** `HEAD` is `ka-reader@20e4810`, and `git diff --stat 8b93322 HEAD -- ka-reader-mac checks
  .github` prints nothing. At `8b93322`: `ka-reader-mac/Info.plist:L13-L14` holds
  `LSMinimumSystemVersion` `26.0`; `ka-reader-mac/Package.swift:L23` reads
  `platforms: [.macOS(.v26)]`; `ka-reader-mac/assemble.sh:L50` sets `MACOSX_DEPLOYMENT_TARGET=26.0`;
  `.github/workflows/` holds `ci.yml` alone, whose one runner is `runs-on: macos-26` (`:L18`);
  `checks/gate.sh:L77` runs `checks/tests/test_vm_refusal.sh` as `VM refusal suite`. In a disposable
  clone of `8b93322` the suite passed 9 of 9; with a `.github/workflows/release.yaml` added whose
  runner is `macos-latest`, it still passed 9 of 9 and QC-56's `grep` printed nothing, which is the
  gap Addition 1 states. The clone was removed afterwards. **What moved beneath this document.**
  Since v58 (`ka-reader@aaa07ea`) only the companion and the self-answer report moved; every input's
  `Status:` line still reads Settled, so `Inputs read:` stands. **No candidate record.** Each move
  re-measures or narrows a pinned sentence and gives up nothing, so it fails the first gate. No ADR
  is written, edited or restatused, the index does not move, and no `QC` is added, renumbered or
  reused. **Known limits.** This run ran no gate and built no bundle; it ran one suite and QC-56's
  `grep`, in the clone. It did not read the SRS, SDD or FDR in full: the fold touches one entry, its
  traces stand, and none of the three moved since v58. **The companion.** Nothing is left for the
  owner, so the companion is removed and `Status:` is Settled *(re: header `Version:` and `Status:`;
  § 8 QC-56; § 10 the QC-56 row; source: `docs/trail/architecture/cycle-52.md` § 2.1;
  `docs/trail/architecture/self_answer-54.md`; `ka-reader@8b93322`)*

- **RN-71:** *(v60 — the close: the cycle-53 fold, § 3.1 confirmed with two additions)* **Intake.**
  The companion on disk held one item, § 3.1, raised by the PM on 2026-10-21 (`ka-reader@060fc76`):
  QC-2's three locators into `checks/read-only.sh` no longer named what they cite. A
  `companion-self-answer` run answered it in the owner's seat on 2026-10-22 (`ka-reader@f6fd13e`; the
  reasoning at `docs/trail/architecture/self_answer-55.md`). The file was clean in git at intake and
  its one slot was filled, so it is consumed. It was copied whole to
  `docs/trail/architecture/cycle-53.md` before this fold's first edit, and `cmp` found the two
  identical. **Whose answer this is.** The owner's seat's, and it outranks every input. Neither
  addition moves what QC-2 obliges. **§ 3.1 → QC-2, the locators.** The walk-fixture sentence's
  three unpinned locators (`:L73-L76`, `:L17-L20`, `:L84`) are replaced by the set the answer names,
  pinned to `ka-reader@c268945`, the merge that landed the restore change: `restore()` at
  `:L210-L252` with its header `:L24-L29`; the removal once the verdict is taken, `:L31-L36`; the
  hashing header `:L19-L22` and `manifest()` at `:L45-L65`; the two hashes at `:L368` and `:L389`.
  These are the locators the SDD's C-I3 took at v56 on the same commit (`docs/trail/sdd/cycle-51.md`
  § 5.1), so the two documents cite the script alike. The old words stand in a dated note in the
  sentence. **Addition 2, the label.** "The script's in-place restore" stood twice in QC-2, in the
  walk-fixture sentence and in the `git_state.rs:L787` sentence. The SDD dropped the label at v56
  because the archive is now unpacked in scratch space and only the entries the fixture lacks are
  copied in (`docs/SDD.md:L824-L829`, `:L2103`); QC-2 traces to C-I3, so it drops it in both places,
  each with a dated note. **The claim stands.** The restore still builds the walk fixture whole before
  the first hash, and a restore that fails exits before it (`:L366`), so a scene whose Git directory
  lies outside the folder is still not a walk fixture. **Read at source for this run:**
  `checks/read-only.sh` at `ka-reader@c268945`, lines `:L17-L66`, `:L205-L254` and `:L362-L392`; each
  locator above names what the answer says it names. `git diff --stat c268945 HEAD -- . ':!docs'`
  prints nothing at `HEAD` `ka-reader@f6fd13e`. `grep -n 'in-place restore\|read-only.sh:L'` finds no
  other unpinned locator into the script and no other use of the label in this document outside the
  dated notes, the header and this note. **What moved beneath this document.** Since v59 (`ka-reader@2baeecf`) the SDD moved to
  v56 (`ka-reader@b5c8042`), re-saying C-I3's restore, which is this fold's ground; every input's
  `Status:` line still reads Settled, so `Inputs read:` stands. **No candidate record.** The fold
  re-pins and relabels one entry and gives up nothing, so it fails the first gate. No ADR is written,
  edited or restatused, the index does not move, and no `QC` is added, renumbered or reused; § 10's
  QC-2 row names no locator, so it does not move. **Known limits.** This run ran no gate and no
  suite: the fold moves citations, not a check. It did not read the SRS, SDD or FDR in full; it read
  the SDD passages the answer cites. **The companion.** Nothing is left for the owner, so the
  companion is removed and `Status:` is Settled *(re: header `Version:`; § 1.1 QC-2; source:
  `docs/trail/architecture/cycle-53.md` § 3.1; `docs/trail/architecture/self_answer-55.md`;
  `ka-reader@c268945`)*

- **RN-72:** *(v61 — the cycle-54 fold, §§ 3.1 and 3.2 answered; § 2.1 open)* **Intake.** The
  companion on disk was opened by the PM on 2026-10-22, not by a `product-architecture` run, to carry
  two items from a `shukuba-refine` review: § 3.1, § 8's 26-step count, and § 3.2, QC-13's sanitizer
  run with the global-variable checks off. A `companion-self-answer` run answered both in the owner's
  seat (`ka-reader@ccf3b22`; the reasoning at `docs/trail/architecture/self_answer-56.md`) and raised
  § 2.1 with an empty slot. The file was clean in git at intake and two slots were filled, so it is
  consumed. It was copied whole to `docs/trail/architecture/cycle-54.md` before this fold's first
  edit, and `cmp` found the two identical. **Whose answers these are.** The owner's seat's, and they
  outrank every input. Neither moves what an entry obliges. **§ 3.1 → § 8, *Until the card runs the
  script*.** A correction, not a widening: the `8b93322` sentence stays as that tree's record, and
  beside it the gate as it stands at `ka-reader@389adad`, version 1.1.0, 27 steps, with the new step's
  place and the count that measures it. The guest pass is cited as the PM's measurement from the trail
  copy, and no commit is named for it, because the item names none. **§ 3.2 → QC-13 and § 10.** QC-13's
  *verified by:* tail now says its sanitizer run admits `-Cllvm-args=-asan-globals=0`, and gives the
  answer's reason (the flag drops only the padding around globals; the bridge's ABI buffers are heap;
  no `unsafe` site reaches a static), the need (LLVM pads Mach-O's `__mod_init_func`, so the linker
  refuses the instrumented `INSTALL_LOG_AT_LOAD`) and the limit (the flag reaches every host-target
  crate; the admission lapses for a change that hands a static across the ABI, which already breaks
  the owned-buffer rule, gated at `development-design`; no leak is claimed caught). The PM's
  heap-overflow negative control is cited as the PM's measurement. § 10's QC-13 row names the flag.
  SDD § 11 R-13's words stand, as the answer says. **Read at source for this run:** `HEAD` is
  `ka-reader@ccf3b22`, and `git diff --stat 389adad HEAD -- checks/gate.sh crates/ka-reader-bridge`
  prints nothing. `grep -c '^run_step' checks/gate.sh` prints 28 at `HEAD` and 27 on
  `git show 8b93322:checks/gate.sh`; `checks/gate.sh:L2` reads `Version: 1.1.0`; `:L50` is *Test
  gate*, `:L57` the sanitizer step passing `-Zsanitizer=address` and `-Cllvm-args=-asan-globals=0`,
  `:L58` *Structure check*; `:L55-L56` give the initializer as the flag's reason;
  `crates/ka-reader-bridge/src/exports.rs:L141-L143` hold `INSTALL_LOG_AT_LOAD` in
  `__DATA,__mod_init_func`. The LLVM locators are the answer's and were not re-read by this run.
  **What moved beneath this document.** Since v60 (`ka-reader@435bb4e`) the SDD moved to v57 and the
  FDR to v13; every input's `Status:` line still reads Settled, so `Inputs read:` stands. **No
  candidate record.** Each fold re-measures or states the limit of an existing check and gives up
  nothing, so it fails the first gate. No ADR is written, edited or restatused, the index does not
  move, and no `QC` is added, renumbered or reused. **Not folded: § 2.1.** Whether § 8's opening
  paragraph, *Until the card runs the script*, and the passages that read under it are re-derived
  against the card that now runs `checks/gate.sh` is a choice whose slot is empty, so this run does
  not touch them: they still read as v60 left them, including the 27-step reading's own *Until*
  sentence after it. The item survives in the companion with its line locators re-measured against
  this version. **Known limits.** This run ran no gate and no suite: the fold moves citations and a
  stated limit, not a check. It did not read the SRS, SDD or FDR in full; it read their status lines,
  the PM's items and the passages the answers cite. **The companion.** § 2.1 is left for the owner, so
  the companion stays and `Status:` is Draft *(re: header `Version:` and `Status:`; § 1.2 QC-13;
  § 8, *Until the card runs the script*; § 10 the QC-13 row; source:
  `docs/trail/architecture/cycle-54.md` §§ 3.1 and 3.2; `docs/trail/architecture/self_answer-56.md`;
  `ka-reader@389adad`)*

- **RN-73:** *(v62 — the close: the cycle-55 fold, § 2.1 confirmed with four additions)* **Intake.**
  The companion on disk held one item, § 2.1, raised on 2026-10-22 by a `companion-self-answer` run
  in this seat while it answered the cycle-54 items (`docs/trail/architecture/self_answer-56.md`
  § Raised on this document), not by a `product-architecture` run. A second `companion-self-answer`
  run answered it in the owner's seat (`ka-reader@4918b8e`; the reasoning at
  `docs/trail/architecture/self_answer-57.md`). The file was clean in git at intake and its one slot
  was filled, so it is consumed. It was copied whole to `docs/trail/architecture/cycle-55.md` before
  this fold's first edit, and `cmp` found the two identical. **Whose answer this is.** The owner's
  seat's, and it outranks every input. It corrects stated facts and moves no obligation: every entry
  still requires what it required, and only where a check runs has changed. **§ 2.1 → § 8.** The
  first paragraph states the card as it reads at `kensaiapp-opensource@85264c69`: the test command
  is `checks/gate.sh` from `1941f963`, and the paragraph names the script's steps that carry what the
  old five-part command ran. The old quote stands in a dated note. *Until the card runs the script*
  records its condition met, and states the rule the re-derivation applies: a review gate whose only
  ground was that no run issued a check drops, and one resting on other ground stays and names it.
  The Swift-half and structure-pair paragraphs, which described the five-part command's order, are
  re-read against the script's step order, each with a dated note. **Addition 1 → QC-56 and
  QC-64.** Two review gates stay. QC-56's `.yaml` half stays because its check reads only files ending
  `.yml`. QC-64's *nothing else* half stays because no script holds it. Each already stated its
  ground, and both keep their words. QC-56's suite and QC-64's two comparisons run at every change.
  § 10's QC-56 row adds `the change` and `development-implementation` for the suite, and keeps
  `development-design` for a `.yaml` workflow file. The QC-64 row already named both gates and does
  not move. **Addition 2 → QC-65.** The "meanwhile" sentence ("the card's command runs none of these
  steps") is replaced by its live reading: the card's command runs every guarded step on every
  change, so the refusal is what keeps them off a physical Mac. The owner's-Mac cost is marked live
  from `1941f963`. The refusal-first ordering is recorded as met, `ka-reader@13e8d42` before
  `kensaiapp-opensource@1941f963`, and the rule stays for a step added later. **Addition 3 → the
  ground.** The fold's ground is the card at `1941f963` together with § 8's own sentence that the
  gate tool issues the card's test command and nothing else. It cites no change record and no guest
  run, because the run that shows the gate working is a change record under the managing instance's
  journey. The guest-side cost § 8 calls unmeasured therefore stays unmeasured here. **Addition 4 →
  the heading.** *Until the card runs the script* keeps its name, because the card's `Test command:`
  comment cites it by that name. No card move is owed. Renaming the heading would be a card move to
  raise on the card's own channel, and this fold makes none (RN-24). **Also re-derived, under the
  same paragraph.** § 9's `checks/tests/` bullet, in two places (the *every suite* sentence and its
  tail's review gate), and its *one suite runs at the change as well* sentence, now history. § 9's
  `ka-reader-mac` bullet's arm sentence, and § 10's *CI build* paragraph. The answer's rule covers
  each of them, because each read under *Until the card runs the script*. **RN-6** is extended by the
  two moves. **Read at source for this run:** the card's `**Test command:**` line
  (`system/projects/ka-reader/project.md:L8` in the managing instance) reads `checks/gate.sh`, and
  its comment cites "NFDR § 8, 'Until the card runs the script'". `git log` on the card shows
  `1941f963` (2026-10-20 17:14:01) and `85264c69` (17:14:17), and nothing after them. In
  `checks/gate.sh` at `HEAD` (`ka-reader@4918b8e`, unchanged since `389adad`), `:L46` is the
  workspace build, `:L49` the bridge's assembly, `:L50` the test gate, `:L57` the sanitizer step and
  `:L58-L59` the structure pair, and `grep -c '^run_step'` prints 28. The managing pipeline's gate
  tool is now `gate_suite.py` v1.5.0. Its `run_gate` (`:L1087`) reads the card's `Test command:`
  (`_CARD_LINE`, `:L621`) and issues that command and no other, and its `resolve_environment`
  (`:L568-L586`) still places a product whose CI names a macOS runner in the guest, and a product
  with no CI, or one whose owner asks, on the owner's Mac. So § 8's v1.2.0 locators are true of the
  version they name, and the rule they cite holds unchanged. They stay as written. **What moved
  beneath this document.** Since v61 (`ka-reader@de3eb1f`) only the companion's answer and the
  self-answer report have landed. Every input's `Status:` line still reads Settled, so
  `Inputs read:` stands. **No candidate record.** The fold re-pins a pointer to the card and re-reads
  which runs hold existing checks, and it gives up nothing, so it fails the first gate. No ADR is
  written, edited or restatused, the index does not move, and no `QC` is added, renumbered or
  reused. **Known limits.** This run ran no gate and no suite: the fold moves citations and the
  reading of where a check runs, not a check. It did not read the SRS, SDD or FDR in full. It read
  their status lines, the answer and the passages the answer names. **The companion.** Nothing is
  left for the owner, so the companion is removed and `Status:` is Settled *(re: header `Version:`
  and `Status:`; § 8, its first paragraph, the Swift-half and structure-pair paragraphs and *Until
  the card runs the script*; QC-56, QC-64, QC-65; § 9 the `checks/tests/` and `ka-reader-mac`
  bullets; § 10 the *CI build* paragraph and the QC-56 row; RN-6; source:
  `docs/trail/architecture/cycle-55.md` § 2.1; `docs/trail/architecture/self_answer-57.md`;
  `kensaiapp-opensource@1941f963`, `85264c69`)*

- **RN-74:** *(v63 — the cycle-56 fold, § 3.1 confirmed with three additions; § 2.1 open)*
  **Intake.** The companion on disk held two items. § 3.1 was raised on 2026-10-23 by the PM
  (`ka-reader@c35081a`). A `companion-self-answer` run answered it in the owner's seat
  (`ka-reader@a364701`; the reasoning at `docs/trail/architecture/self_answer-58.md`) and, while
  doing so, raised § 2.1 on QC-15's locators and left its slot empty. The file was clean in git at
  intake and one slot was filled, so it is consumed. It was copied whole to
  `docs/trail/architecture/cycle-56.md` before this fold's first edit, and `cmp` found the two
  identical. **Whose answer this is.** The owner's seat's, and it outranks every input. It corrects
  a stated fact and moves no obligation: QC-11 still forbids what it forbade, and only the account
  of what the scan holds has changed. **§ 3.1 → QC-11.** The sentence that the script "still lists
  QC-11's clauses whose subject is `git-reader`, `watcher` or `markdown-renderer` as not held" is
  false at the scan's version 1.6.0, and is replaced by a pointer to the header that owns the
  account — *THE SCAN TABLE* and *WHAT IS NOT HELD* — which is this document's own rule for every
  script (the header's *Two things about how this document cites*). **Addition 1 → the review-held
  parts.** The tail names three: the exception's two bounds, which it already stated, and the
  `markdown-renderer` → `fs-reader` edge's containment-only bound, which *WHAT IS NOT HELD* names as
  the one part of QC-11 the scan does not hold. **Addition 2 → the locators.** The binding row
  (`:L130-L142` → `:L167-L181`), the exempting `case` (`:L1186` → `:L1459`) and the `tests/`
  reading (`:L41-L42` → `:L46-L47`) were each true at `ka-reader@076eac2` and carried no pin. Every
  scan locator in the tail now carries `ka-reader@82a3fb1`, the merge that landed version 1.6.0, and
  so do the constructor's locator and the `git2` bound, which did not move. **Addition 3 → the two
  units with no file.** The tail says their clauses are held as rules, proved on planted files, and
  judged from the run in which a file of either first appears, so *held* is not read as *measured on
  their code*. **Also corrected, beyond the answer's text.** The answer named the suite cases for
  the three subjects it covered. The tail names the planted-break case for each of the five subjects,
  because a sentence that says the header holds all five and names cases for three reads as if two
  were unproved. **Read at source for this run**, in the main checkout at `ka-reader@a364701`, whose
  tree outside `docs/` is `82a3fb1`'s (`git diff --stat 82a3fb1 a364701 -- . ':!docs'` prints
  nothing): `checks/structure.sh:L2-L3` reads version 1.6.0 holding "QC-11's git_reader, watcher
  and markdown_renderer subjects"; the unit-edge row is `:L110-L149`, the binding row `:L167-L181`,
  *WHAT IS NOT HELD* `:L321-L336` with the renderer's bound at `:L331-L334`, and the exempting `case`
  `:L1459`; the `tests/` reading is `:L46-L47`; the suite defines
  `test_fs_reader_forbidden_units_are_rejected` (`checks/tests/test_structure.sh:L1326`),
  `test_highlighter_forbidden_units_are_rejected` (`:L1281`),
  `test_git_reader_unit_edges_are_rejected` (`:L2617`) and
  `test_future_unit_files_are_judged_without_editing_the_scan` (`:L2668`);
  `crates/ka-reader-bridge/src/machine_config.rs:L138-L139` is still the constructor, the file
  unchanged since `ka-reader@c915d52`; and `grep -rln git2 crates/ka-reader-bridge` prints the
  manifest, `src/machine_config.rs` and `tests/search_path.rs`. In a disposable clone at
  `a364701`, `checks/structure.sh` exits 0 printing "17 Rust files in 2 crates read — nothing found",
  and `checks/tests/test_structure.sh` exits 0 with 112 `ok` lines and no other line. **What moved
  beneath this document.** Since v62 (`ka-reader@ef2f47c`) only the companion and the self-answer
  report have landed (`git log ef2f47c..HEAD` on the SRS, SDD, FDR, PRD, UXD, DESIGN and CONTENT
  prints nothing), so `Inputs read:` stands. § 10's QC-9 – QC-12 row already names the scan and its
  suite and does not move. **No candidate record.** The fold corrects a pointer and the account of a
  check's coverage, and gives nothing up, so it fails the first gate. No ADR is written, edited or
  restatused, the index does not move, and no `QC` is added, renumbered or reused. **Known limits.**
  This run did not read the SRS, SDD or FDR in full: nothing beneath this document moved, and it
  read their status lines, the answer and the passages the answer names. **The companion.** § 3.1 is
  resolved and dropped. § 2.1 — QC-15's four unpinned locators into the scan and its suite — has no
  answer, so it stays, and `Status:` is Draft *(re: header `Status:`, `Version:`; QC-11's *verified
  by*; source: `docs/trail/architecture/cycle-56.md` § 3.1;
  `docs/trail/architecture/self_answer-58.md`)*

- **RN-75:** *(v64 — the close: the cycle-57 fold, § 2.1 confirmed with two additions)* **Intake.**
  The companion on disk held one item, § 2.1, raised on 2026-10-23 by a `companion-self-answer` run
  in this seat while it answered the cycle-56 item (RN-74), not by a `product-architecture` run. A
  second `companion-self-answer` run answered it in the owner's seat (`ka-reader@b17fb10`; the
  reasoning at `docs/trail/architecture/self_answer-59.md`). The file was clean in git at intake and
  its one slot was filled, so it is consumed. It was copied whole to
  `docs/trail/architecture/cycle-57.md` before this fold's first edit, and `cmp` found the two
  identical. **Whose answer this is.** The owner's seat's, and it outranks every input. It corrects
  pointers and moves no obligation: QC-15 still fixes what it fixed, and the scan and the review at
  `development-design` still hold the parts they held. **§ 2.1 → QC-15, the four unpinned
  locators.** The suite's two exemption cases (`test_structure.sh:L961`, `:L931` →
  `:L988`, `:L958`), the `Path`-method gap (`structure.sh:L266-L267` → `:L341-L342`) and the two
  `git-reader` parts not held (`:L253-L256` → `:L327-L330`) now carry `ka-reader@82a3fb1`, the pin
  QC-11's tail carries since v63, so the next scan change makes both tails stale at one commit.
  **Addition 1, the pin.** It is `82a3fb1`, as the answer names; the item had said only "a named
  commit". **Addition 2, the tail's other locators.** The QC-15 row and the exempting `case`, true at
  their own pin `ka-reader@48308ff` as `:L77-L80` and `:L1161`, move to the same pin as `:L82-L85`
  and `:L1451`, because at `48308ff` the three owner files are spelled `crates/nozoki-*` and the
  sentence spells them `crates/ka-reader-*`, and because two pins in one sentence are what made the
  later locators read as inheriting the earlier one. The `config_scan.rs:L66` locator carries
  `ka-reader@66f428d` in its own parenthesis. Every old reading stands in a dated note. **Also,
  beyond the answer's text.** The `:L327-L330` locator names its section, *WHAT IS NOT HELD*, as the
  gap's locator already named *GAPS THE RULES ABOVE DO NOT CLOSE*, so a reader at the pin knows which
  header the two parts sit under; and QC-15's trace names this answer. **Read at source for this
  run**, in the main checkout at `ka-reader@b17fb10`, whose tree outside `docs/` is `82a3fb1`'s
  (`git diff --stat 82a3fb1 b17fb10 -- . ':!docs'` prints nothing): `checks/structure.sh:L2-L3`
  reads version 1.6.0; `:L82-L85` opens the QC-15 filesystem row naming the three owner files;
  `:L1451` is the exempting `case`; `:L327-L330` is *WHAT IS NOT HELD*'s bullet on QC-15's two
  parts; `:L341-L342` is the `Path`-method sentence under *GAPS THE RULES ABOVE DO NOT CLOSE*; and
  `checks/tests/test_structure.sh` defines `test_git_owner_write_is_still_one_qc2_finding` at
  `:L958` and `test_exemption_is_exact_for_the_adapter_name` at `:L988`. At `48308ff`, `:L77-L80`
  and `:L1161` read as the dated note says, with `crates/nozoki-*`. `config_scan.rs`'s `scan` is
  `:L66` at `66f428d` and `:L93` at `82a3fb1`; at `66f428d` the file, like `alternates_scan.rs` at
  the same pin and `libgit2.rs` at its three pins, lies under `crates/nozoki-core/`, the crate's
  name before `ka-reader@c915d52`, so `git log --follow` reaches it from the spelled path. The answer
  weighed those pinned locators and left them, and this fold does too. **What moved beneath this
  document.** Since v63 (`ka-reader@7f1c949`) only the answered companion and the self-answer report
  have landed (`git log 7f1c949..HEAD` on the SRS, SDD, FDR, PRD, UXD, DESIGN and CONTENT prints
  nothing), so `Inputs read:` stands. § 10's QC-15/QC-17 row names the scan and its suite and no
  line, so it does not move. **No candidate record.** The fold re-pins citations and gives nothing
  up, so it fails the first gate. No ADR is written, edited or restatused, the index does not move,
  and no `QC` is added, renumbered or reused; the two records that name `config_scan.rs`, ADR-0022
  and ADR-0023, name it by file and no line. **Known limits.** This run ran no gate and no suite: the
  fold moves citations, not a check. It did not read the SRS, SDD or FDR in full: nothing beneath
  this document moved, and it read their status lines, the answer and the passages the answer names.
  **The companion.** Nothing is left for the owner, so the companion is removed and `Status:` is
  Settled *(re: header `Status:`, `Version:`; QC-15's *verified by* and trace; source:
  `docs/trail/architecture/cycle-57.md` § 2.1; `docs/trail/architecture/self_answer-59.md`;
  `ka-reader@82a3fb1`)*

- **RN-76:** *(v65 — the close: the cycle-58 fold, § 3.1 confirmed with four additions)* **Intake.**
  The companion on disk held one item, § 3.1, raised from downstream on 2026-10-23 by the PM
  (`ka-reader@825bfcd`) after `checks/no-network.sh` reached version 1.2.0. A `companion-self-answer`
  run answered it in the owner's seat (`ka-reader@a12e5ed`; the reasoning at
  `docs/trail/architecture/self_answer-60.md`). The file was clean in git at intake and its one slot
  was filled, so it is consumed. It was copied whole to `docs/trail/architecture/cycle-58.md` before
  this fold's first edit, and `cmp` found the two identical. **Whose answer this is.** The owner's
  seat's, and it outranks every input. It corrects what § 9 says holds the packet's
  `type == "system"` clause and moves no obligation: the clause binds as it did, and what changed is
  that a script now fails when it is broken. **§ 3.1 → § 9's Swift-packet bullet.** The passage that
  said the clause "holds with no check behind it", that a `.systemLibrary` target "would pass every
  gate in the tree" and that a refusal "is owed" now names `checks/no-network.sh` 1.2.0 as the
  clause's gate, with its refusal at `:L159-L164` and its suite case `test_system_target_fails` at
  `checks/tests/test_no_network.sh:L64`, `:L512`, all at `ka-reader@825bfcd`. The *verified by* tail
  lists the system-target refusal beside the `dependencies` and `url` conditions, and drops "(the
  refusal owed above)" and the closing "the day `checks/no-network.sh` refuses a `system` target"
  clause; the bullet's own tail had named that day as the moment the script becomes the gate.
  **Addition 1, the locators.** Every script locator the passage cites is re-pinned at
  `ka-reader@825bfcd`: *THE SWIFT HALF* at `:L34-L46`, the `dependencies` refusal at `:L136`, the
  `url` refusal at `:L143-L151`, the `Package.resolved` refusal at `:L172-L179`. The unpinned
  `:L31-L32`, `:L131-L138` and `:L149` stand in the dated note, which says they were true of the
  script at version 1.1.0, `ka-reader@ae72bdc`. **Addition 2, the review that stays.** The
  `development-design` review on `Package.swift` now covers the six tools-6.2 items no script reads,
  and an added test's framework. Only the system-target ground leaves its rationale, and "no target
  of type `system`" leaves the dump readings the review checks. **Addition 3, what each half
  holds.** The suite drives the script on stubbed dumps, so it holds the refusal's logic. The gate
  run reads the real dump on every change. The script fails closed on a missing `swift` or `plutil`
  or an unreadable dump (`:L120-L133`, exiting at `:L181`). **Addition 4, no record.** A check
  landing reverses no decision and gives nothing up, so it fails the first gate. No ADR is written,
  edited or restatused, the index does not move, and no `QC` is added, renumbered or reused; `grep`
  over `docs/adr/` for `systemLibrary` and `type == "system"` finds nothing, so no record states the
  old gap. **Left as it stands, and why.** QC-8 and QC-26 cite `checks/no-network.sh` for a Swift
  dependency and a `Package.resolved`. Neither says that is all the script refuses, so neither is
  false, and the answer names § 9 only. The Review Notes that record the old gap are history. § 10
  has no row for § 9's bullet, and the rows that name the script name no condition, so the map does
  not move. **Read at source for this run**, at `ka-reader@a12e5ed`, whose tree outside `docs/` is
  `825bfcd`'s (`git diff --stat 825bfcd a12e5ed` names only the companion and the self-answer
  report): `checks/no-network.sh:L2` reads version 1.2.0, and the lines above read as cited;
  `checks/tests/test_no_network.sh:L2` reads version 1.3.0. At `ka-reader@ae72bdc` the script reads
  version 1.1.0, with *THE SWIFT HALF* opening at `:L31-L32` and the `url` loop at `:L131-L138`. The
  suite, run in a disposable clone at `825bfcd`, exits 0 with 21 `ok` lines and no `FAIL`,
  `test_system_target_fails` among them. The answer's other reading, the case going red with the
  refusal removed, is the PM's measurement and was not repeated. **What moved beneath this
  document.** Since v64 (`ka-reader@a42a625`) no commit touches the SRS, SDD, FDR, PRD, UXD,
  DESIGN, CONTENT or `docs/adr/` (`git log a42a625..HEAD` on those paths prints nothing), and all
  three primary inputs read `Status: Settled`, so `Inputs read:` stands. **Known limits.** This run
  did not read the SRS, SDD or FDR in full: nothing beneath this document moved, and it read their
  status lines, the answer and the passages the answer names. **The companion.** Nothing is left for
  the owner, so the companion is removed and `Status:` is Settled *(re: header `Status:`,
  `Version:`; § 9's Swift-packet bullet and its *verified by*; source:
  `docs/trail/architecture/cycle-58.md` § 3.1; `docs/trail/architecture/self_answer-60.md`;
  `ka-reader@825bfcd`)*
- **RN-77:** *(v66 — the close: the cycle-59 fold, § 3.1 confirmed with five moves)* **Intake.**
  The companion on disk held one item, § 3.1, raised from downstream on 2026-10-23 by the PM
  (`ka-reader@914ceb3`) after `ka-reader@8235240` landed the gate's secret scan. A
  `companion-self-answer` run answered it in the owner's seat (`ka-reader@20f989b`; the reasoning at
  `docs/trail/architecture/self_answer-61.md`). The file was clean in git at intake and its one slot
  was filled, so it is consumed. It was copied whole to `docs/trail/architecture/cycle-59.md` before
  this fold's first edit, and `cmp` found the two identical. **Whose answer this is.** The owner's
  seat's, and it outranks every input. It re-measures §§ 8 and 9 at a new pin and names the gate step
  that now holds QC-28's tree half; the obligation binds as it did. **Move 1, § 8.** *Until the card
  runs the script* gains the 1.2.0 reading — 29 steps, *Secret scan suite* at `:L48` and *Secret
  scan* at `:L58` before *Build the workspace* at `:L59`, and the guest's exit 0 at `ka-reader@38158f4`.
  The first, assembly and structure-pair paragraphs re-pin their `gate.sh` locators at `8235240`
  (`:L59`, `:L62`, `:L63`; `:L59-L63`; `:L71-L72`, the sanitizer at `:L70`), each keeping its
  `389adad` reading. **Move 2, § 9.** The suites bullet counts twelve, adds `test_secret_scan.sh` at
  `:L48`, which pairs with `checks/secret-scan.sh`, and re-pins every suite locator and its
  `Bundle probe suite` example. **Move 3, QC-28.** Its *verified by* names the gate step over every
  commit HEAD reaches, at every change, the script's exit contract, and `.gitleaksignore` — a
  fingerprint line with its reason above it, reviewed as code in the same change, as
  `checks/deps.allow` is for QC-26 — as a finding's one way through. RN-3 keeps the vendor sentence:
  it is still true of bare `gitleaks git` (the gitleaks README, re-read 2026-10-23 by the answering
  run). **Move 4, § 10.** QC-28's row names `checks/secret-scan.sh gitleaks git` (suite
  `test_secret_scan.sh`), by the preamble's suite rule, run over the history at the change and gated
  at `development-implementation`. **Move 5, QC-64.** The order sentence put every `checks/*.sh`
  script after the workspace build, false at `8235240`. It now covers the moved steps, and says a
  step added later sits where the script places it, with its order rule in the comment above it.
  **The two failure paths**, named in QC-28's tail as consequences and not as new obligations: the
  per-run fetch of gitleaks 8.30.1's release archive, a platform fact held by the gitleaks
  maintainers, after which every change is red until the pin moves; and the shallow-checkout
  refusal, which `fetch-depth: 0` answers on the hosted run. Both fail closed. **Where this fold
  departs from the answer's words, and why.** (1) The answer reads "a finding exits 2 and a tool
  error 1". That is gitleaks's exit under the script, not the script's: `checks/secret-scan.sh`
  sends both through `die`, which exits 1 (`:L55-L58`, `:L213-L218`), and its *USAGE* says only "A
  finding, or any error, is non-zero". QC-28 states both halves, so it does not promise a caller an
  exit code the script does not give. (2) The answer re-pins no `ci.yml` locator, but § 9's bullet
  cited `ci.yml:L26` twice with no commit, false since `fetch-depth: 0` moved the `Test gate` step to
  `:L28`; the bullet is re-pinned here, so those two move with it. (3) § 8's first paragraph said
  every other rule comes after the test gate; it now says the secret scan and its suite come before
  the build, so the paragraph does not contradict *Until the card runs the script*. (4) QC-64's new
  sentence cites `checks/gate.sh:L40-L42`, the script's own statement that an order rule lives in the
  comment above a step; the answer said "where its comment says", and a step with no such comment
  binds no order. **No record.** A gate step realizing an existing obligation reverses no decision,
  and undoing it is one line of the script and one pin, so it fails the first gate. No ADR is written,
  edited or restatused, the index does not move, and no `QC` is added, renumbered or reused;
  `grep -rl gitleaks docs/adr/` prints nothing. **Read at source for this run**, at
  `ka-reader@20f989b`, whose tree outside `docs/` is `8235240`'s (`git diff --stat 8235240 HEAD --
  . ':!docs'` prints nothing): `checks/gate.sh` (version 1.2.0 at `:L2`; the steps at the lines
  cited), `checks/secret-scan.sh` (its header, `:L55-L58`, `:L85-L87`, `:L195`, `:L213-L228`),
  `.github/workflows/ci.yml` (`:L21-L23`, `:L27-L28`), and `git ls-tree --name-only HEAD
  checks/tests/` (twelve suites and `support`). The gate was not run here; the exit 0 at `38158f4`
  is the PM's measurement. **What moved beneath this document.** Since v65 (`ka-reader@5db021c`) the
  one upstream commit is SDD v58 (`ka-reader@feac758`), Settled, which names the scan step in § 3's
  `read-only-harness` row and leaves QC-28 and § 8's count to this document (`docs/SDD.md` RN-118).
  No commit touches the SRS, FDR, PRD, UXD, DESIGN, CONTENT or `docs/adr/`, and every input reads
  `Status: Settled`, so `Inputs read:` stands. **Known limits.** This run did not read the SRS, SDD
  or FDR in full: it read their status lines, SDD v58's header and the passages the answer names.
  **The companion.** Nothing is left for the owner, so the companion is removed and `Status:` is
  Settled *(re: header `Version:`; § 8 first, assembly and structure-pair paragraphs, *Until the card
  runs the script*; QC-28; QC-64; § 9's `checks/tests/` bullet; § 10's QC-28 row; source:
  `docs/trail/architecture/cycle-59.md` § 3.1; `docs/trail/architecture/self_answer-61.md`;
  `ka-reader@8235240`)*
