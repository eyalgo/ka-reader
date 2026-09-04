# NFDR — Nozoki 覗き

**Status:** Draft
**Owner:** Principal Architect
**Version:** 5 — the cycle-3 fold, under one owner answer, and the SDD re-authored beneath a settled document. The owner's answer to `docs/trail/architecture/cycle-3.md` § 3.1 is folded: the 37 citations in ADR-0001 – ADR-0008 of the deleted SDD's trail and review notes are pinned to `nozoki@70a879a:`, and QC-48's `SDD § 6 S-4` reads `S-5` — prose edits on the owner's ruling, no record superseded (RN-16). The SDD beneath this document is no longer the one v1 – v4 read: it was deleted at `nozoki@9c91359` and re-authored, Settled at v3 (`nozoki@827aa1c`), and this revision re-derives against it as that document's own § 4 rule requires — every trace tag the re-author renumbered is re-pointed (QC-19, QC-21, QC-47, QC-51, QC-53, RN-3, RN-10); § 8's sentence about the card follows S-1's bar, which now carries `--locked` itself; and two of its new sentences bind: C-I6's `checks/contract.sh` gives QC-59's priced members a machine check from `v1.0.0`, with a § 10 row, and C-D3's format list binds the asset handler to four bitmap formats and keeps SVG off the scheme until the mechanism SDD RN-8 states precedes it (QC-37; QC-22 names the PNG). No `QC` is added, renumbered or reused; no record changes beyond the 37 pins. Two items go to the owner and `Status:` is Draft: the re-author moved thirteen further ADR citations the answer's scope did not reach, and the SDD's confirmed 1.0.0 contract prices own-state readability nowhere while `docs/fdr.md` PD-39 and QC-59 do (`docs/architecture_open_issues.md` § 2.1, § 1.1). (v4: the close: the re-opened companion's five answers folded (`docs/trail/architecture/cycle-2.md`), all five in the owner's seat by two `companion-self-answer` runs (RN-15). What this document now binds that v3 did not: the logging facade is `log`, implemented by `nozoki-app`'s own writer installed once at the composition root — no third-party implementation and no `tracing` — held by a machine check on the allowlist and on `log::set_logger` (QC-61, with a § 10 row); every `cargo test` command in § 9, § 10 and the entries' tails carries `--locked`, following the Rust packet where v3 had neither followed it nor recorded a departure (RN-7); and § 9 fixes that layer 5 stays outside `cargo test`, which is why the card's `cargo test --workspace --locked` is this product's change-time run against the packet's release-time classification — the condition that would flip it named and checked (RN-7 departure (1)). § 8's sentence about the card is true again — the card's command satisfies the S-1 bar and adds the packet's flag — and RN-6's pinned history gains the card's third and fourth commits. The v3 drafts on § 9's preamble, its `crates/` paths, RN-7 and RN-6 are confirmed and stand. The `testing_doctrine.md` cite moves to v2.2.0 under no answer (RN-15). QC-61 is the one new ID; no obligation is removed or renumbered; no record changes. Nothing is left for the owner; `docs/architecture_open_issues.md` is removed and `Status:` is Settled. (v3: an input moved underneath a settled document, and the companion is re-opened on it: the organisation's language registry gained a Rust packet on 2026-09-02 (`kensaiapp-dev@d628f75c`; its placement ruling `kensaiapp-dev@49e0444f`), and three statements here that no such packet existed are false. This revision applies the two drafts the re-opened companion carries, awaiting the owner's confirmation (`docs/architecture_open_issues.md` § 2.1, § 2.2): § 9's preamble and RN-7 read Rust tooling as the packet's, with what this product fixes differently and why; § 9's Rust test paths move under `crates/`, the placement the owner ruled for every Rust product here; RN-6 and § 8 record the project card's two closes — the two-toolchain test command (`kensaiapp-opensource@c2155cc`) and the `Languages:` line (`kensaiapp-opensource@0af5fb9`) — as history pinned to `kensaiapp-opensource@4bdfddd`. One question stays open and no entry moves for it: the packet requires the binary crate to select a logging facade, `log` or `tracing`, and leaves the choice to this document (§ 1.1 of the companion); RN-14 names what waits on it. No obligation is added, removed or renumbered; no record changes — ADR-0009 names its crates by name and fixes no directory. `Status:` is Draft because a companion is on disk, and this document is Settled only when none is. (v2: the close: the owner's cycle-1 answers folded (`docs/trail/architecture/cycle-1.md`), ten of its eleven items, and the eleventh settled by derivation from the FDR at v3 (RN-11, RN-12). What this document now binds that v1 did not: a critical advisory blocks release with **no remediation window** — none, not undecided — and `cargo audit` gates every advisory with a reasoned ignore by id (QC-27); the secrets scan is `gitleaks git` (QC-28); QC-33's revocation clause names identity alone; the diagnostic log's bound is the SRS's — one session's lines, 1 MiB on disk, a failed write surfacing nowhere — and own-state retention follows the FDR's R-110 and R-178 – R-182, so QC-40 is a machine check with a § 10 row; the public contract's breaking/additive split (QC-59); own-state read whole or discarded whole, symmetric, silent, never a startup failure (QC-60). ADR-0009 is Accepted. RN-2 is corrected as history, RN-3, RN-4, RN-5 and RN-9 close on the trail, and the upstream moves since v1 read its sources are measured and recorded (RN-13). Nothing is left for the owner; `docs/architecture_open_issues.md` is removed and `Status:` is Settled. (v1: the constraint set stated for the first time, over the settled SDD and SRS with the FDR beside them: the module set and its import graph, the read-only and no-network invariants as machine checks, the three walls around rendered content, the release and sandbox gates, and the test-strategy realization for a Rust host with a TypeScript renderer; nine items parked for the owner.))))
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
> `testing_doctrine.md` v2.2.0, the TypeScript packet (`languages/typescript/`, `testing.md`
> v2.0.1, `toolchain.md` v1.1.0, `quality_gates.md` v1.1.0) or the Rust packet (`languages/rust/`,
> `testing.md` v1.0.0, `layout.md` v1.1.0, `errors_logging.md` v1.1.0, `quality_gates.md` v1.1.0,
> `toolchain.md` v1.1.0) names an engineering-doctrine file of
> the organisation that publishes this product, which is not in this repository; every such entry
> states the rule in full here, so the trace is provenance and never a dependency. Every command
> named below is one the SDD names for a product that has no code yet, or one this document names
> as its own realization and says so in § NFDR Review Notes; each becomes executable in the change
> that lands the script, and until then the gate is `development-design` reading the entry.

---

## 1. Structural integrity

The physical module set is ADR-0009's: `nozoki-core` (Rust library — `fs-reader`, `git-reader`
with the Git port, `watcher`, `folder-model`, `own-state`, `markdown-renderer`), `nozoki-app` (Rust
binary, the Tauri 2 host — `ipc-surface`), `nozoki-ui` (TypeScript — `surfaces`), and `checks/`
(build-time, not shipped). Part names are the SDD's (`docs/SDD.md` § 3); the Rust module spelling
of each is the developer's.

### 1.1 Architectural invariants

- **QC-1:** `nozoki-ui` holds no filesystem, network or shell capability; its only channels to
  the host are the closed IPC command list and the `nozoki-asset` scheme.
  — *verified by:* structural check (test layer 6) over `nozoki-ui`'s imports (QC-8) and the host's
  capability file (QC-24); `checks/no-network.sh` *(traces to: ADR-0001; ADR-0002; SDD § 3 seam 4)*
- **QC-2:** No code path in any shipped unit opens a file under the granted folder for writing,
  creates, renames or removes an entry there, or creates a lock file in `.git`.
  — *verified by:* `checks/read-only.sh <fixture>` prints `unchanged` on every fixture after every
  IPC command, `.git` hashed where present (test layer 3); structural check (layer 6):
  `checks/structure.sh` rule *no write API in `nozoki-core` outside `own-state`* *(traces to:
  SRS NFR-5, NFR-6, C-2; ADR-0001; ADR-0003)*
- **QC-3:** No shipped unit links a network transport: libgit2 is built without its HTTPS and SSH
  transports, and every crate and package the bundle contains is named in `checks/deps.allow`.
  — *verified by:* `checks/no-network.sh` — `cargo tree` and `pnpm ls` diffed against the
  allowlist, non-zero on any hit (the tree) *(traces to: SDD § 4 C-R6; SRS NFR-8; ADR-0004)*
- **QC-4:** Every read the model holds is an item carrying an `ItemState` — `pending`, `observed`,
  `failed(condition)` or `stopped` — and no surface draws a marker, a count or a "nothing changed"
  from an item that is not `observed`.
  — *verified by:* unit tests on the reducer (layer 1): every read path yields a state; UI tests
  (layer 4): a projection with a `pending` item renders the word *pending* and no marker *(traces
  to: SDD § 3 ItemState; § 4 C-I1, C-E1; SRS NFR-3; FDR R-19, R-36, R-94)*
- **QC-5:** The root finding never answers with a path above the granted folder; on `plain` the
  model holds no `GitState`, every Git-derived projection is empty, and the tree carries no marker.
  — *verified by:* `cargo test --locked -p nozoki-core --test root_finding` over the plain,
  inside-a-repository, parent-of-two, linked-worktree and submodule fixtures (layer 2) *(traces to:
  ADR-0005; SRS FR-33, FR-34, AC-24, AC-25)*
- **QC-6:** Every path derived from content or from outside — a tree entry, a symlink target, a
  Markdown image reference, a relative link, an asset request — passes `fs-reader`'s containment
  check on the canonical path, symlinks resolved and after decoding, before any open; the asset
  handler re-runs it on every request.
  — *verified by:* `cargo test --locked -p nozoki-core --test markdown` — the `..` and symlink-out fixtures
  yield the placeholder and the handler returns nothing for them (layer 2); unit tests on the check
  (layer 1) *(traces to: ADR-0006; SDD § 3 `fs-reader`; § 4 C-D3; § 11 R-10; FDR R-34, R-59, R-62)*
- **QC-7:** `git-reader` makes no mutating call — no checkout, index write, ref update or lock
  file — and spawns no process; every port method is read-only.
  — *verified by:* `checks/read-only.sh` on the Git fixtures with `.git/index` hashed (layer 3);
  `checks/structure.sh` rule *no `std::process` in any shipped crate* (layer 6) *(traces to:
  ADR-0004; SRS NFR-6, AC-2; SDD § 3 `git-reader` "Must not own")*

### 1.2 Forbidden imports

One graph, both halves stated. "May import" is the whole allowed set; "must not import" is stated
explicitly and never inferred.

- **QC-8:** `nozoki-ui` may import `@tauri-apps/api` (invoke and event), its own modules, and the
  bundled highlighter with its grammars. It **must not import** any `@tauri-apps/plugin-*` package,
  any Node.js built-in, any package that opens a socket or reads a file, or a URL.
  — *verified by:* structural check (layer 6): `pnpm exec vitest run tests/architecture` *(traces
  to: ADR-0001; ADR-0002; ADR-0009; SDD § 3 `surfaces` "Must not own")*
- **QC-9:** `nozoki-core` **must not import** any Tauri crate, any crate outside `checks/deps.allow`,
  or `std::process`.
  — *verified by:* `checks/no-network.sh`; `checks/structure.sh` (layer 6) *(traces to: ADR-0001;
  ADR-0009; SDD § 4 C-R6)*
- **QC-10:** `folder-model` may import `fs-reader`, the Git port trait, and `watcher`. It **must
  not import** the libgit2 binding, `git-reader`'s adapter, `own-state`, or `markdown-renderer`.
  — *verified by:* `checks/structure.sh` (layer 6) *(traces to: ADR-0004; ADR-0009; SDD § 3
  `folder-model` "Must not own"; `arch_defaults.md` § Dependency Graph Rules)*
- **QC-11:** `fs-reader`, `git-reader`, `watcher` and `markdown-renderer` **must not import**
  `folder-model`, `own-state`, or one another — with one stated edge: `markdown-renderer` imports
  `fs-reader`'s containment check. Only `git-reader` imports the libgit2 binding.
  — *verified by:* `checks/structure.sh` (layer 6) *(traces to: ADR-0004; ADR-0006; ADR-0009; SDD
  § 3 `markdown-renderer` row)*
- **QC-12:** `own-state` **must not import** `fs-reader`, `git-reader`, `watcher`, `folder-model`
  or `markdown-renderer`; it reads and writes only inside the app's container.
  — *verified by:* `checks/structure.sh` (layer 6); `checks/own-state.sh` (layer 5) *(traces to:
  ADR-0009; SDD § 3 `own-state`; § 4 C-D2)*
- **QC-13:** `nozoki-app` may import `nozoki-core` and the Tauri runtime. It **must not import**
  `std::fs` outside its log module, and holds no read logic: every command delegates to
  `nozoki-core` and formats the result.
  — *verified by:* `checks/structure.sh` (layer 6) for the import; review at `development-design`
  for the delegation rule — what counts as logic is not greppable, and the import rule is the part
  that is *(traces to: ADR-0002; ADR-0009; SDD § 4 C-I2; `arch_defaults.md` § Application Layer)*
- **QC-14:** `checks/` may import `nozoki-core` and is **never a dependency** of `nozoki-core`,
  `nozoki-app` or `nozoki-ui`.
  — *verified by:* `cargo tree -p nozoki-app` names no `checks` crate; `checks/structure.sh`
  (layer 6) *(traces to: ADR-0008; ADR-0009; SDD § 3 `read-only-harness` "Must not own")*

### 1.3 Layer isolation

- **QC-15:** I/O ownership is fixed: folder reads are `fs-reader`'s (bytes, listings) and
  `git-reader`'s (Git's on-disk state through libgit2); change notifications are `watcher`'s
  (FSEvents); the Open panel, the window and the diagnostic log are `nozoki-app`'s; rendering is
  `nozoki-ui`'s; **no unit owns a socket and no unit spawns a process.**
  — *verified by:* `checks/structure.sh` (layer 6): each I/O primitive appears only in its owner
  *(traces to: ADR-0001; ADR-0009; SDD § 3 parts table)*
- **QC-16:** The only writes the product performs are `own-state`'s and the host's diagnostic log,
  both inside `~/Library/Containers/com.kensaiapp.nozoki/`.
  — *verified by:* `checks/own-state.sh` — after a session every changed file under `$HOME` is
  under the container and none under the fixture (layer 5) *(traces to: SDD § 4 C-D2, C-I2; SRS
  FR-21, AC-13; ADR-0001)*
- **QC-17:** `nozoki-app` is the composition root: the only place the libgit2 adapter is wired to
  the Git port, and the only place a Tauri API is called.
  — *verified by:* `checks/structure.sh` (layer 6): the adapter's constructor and every `tauri::`
  path appear only in `nozoki-app` *(traces to: ADR-0002; ADR-0009; `arch_defaults.md`
  § Composition Root)*

### 1.4 Replaceability

- **QC-18:** Swapping the Git mechanism — libgit2 for the installed `git` run with
  `--no-optional-locks` — touches `git-reader` (the adapter) and `nozoki-app`'s wiring only; the
  port, the model and the surfaces do not change.
  — *verified by:* review at `development-design` when a change touches `git-reader`; the port's
  contract tests (QC-50) pass unchanged against the new adapter *(traces to: FDR PD-29; SRS § 5.3;
  ADR-0004)*
- **QC-19:** The viewed folder is an input, not a structural singleton: opening a different folder
  replaces the whole model, and adding the folder selector touches `folder-model`'s replace,
  `own-state`'s bookmarks and the shell chrome only — the tree, the Git view and the reading panel
  do not change.
  — *verified by:* `cargo test --locked -p nozoki-core --test switch` (layer 3);
  `git diff --stat <last-release-tag>..HEAD -- nozoki-ui/src/tree nozoki-ui/src/git-view
  nozoki-ui/src/reading-panel` prints nothing on the change that adds the selector (the change)
  *(traces to: SRS NFR-12, FR-19; FDR PD-29; SDD § 3 `folder-model`, § 6 S-10)*
- **QC-20:** Swapping `own-state`'s storage format touches `own-state` only; no other unit reads
  the container.
  — *verified by:* `checks/structure.sh` (layer 6): the container path appears only in `own-state`
  and the host's log module *(traces to: SDD § 3 seam 6; ADR-0009)*
- **QC-21:** No swap invariant is held for the renderer technology or the platform: neither is
  replaceable inside the terminus, and reversing either costs what ADR-0002 states. A change that
  claims either is cheap to replace is wrong.
  — *verified by:* review at `development-design` — a stated non-invariant has nothing to run
  *(traces to: FDR PD-29; SDD § 2 "Undoing it", § 9 TO-4; ADR-0002)*

## 2. Security

**Trust boundaries, named.** (1) The granted folder ↔ the host: everything under the folder is
untrusted, live input (`docs/SRS.md` § 6 DR-6). (2) The host ↔ the renderer: the IPC command list
and the asset scheme (`docs/SDD.md` § 3 seam 4). (3) The bundle ↔ the operating system: the App
Sandbox and its entitlements (ADR-0003). (4) The dependency tree ↔ the build: the allowlist and the
lockfiles (`docs/SDD.md` § 4 C-R6). (5) The release artifact ↔ the adopter: a CI build from a tag
with a published checksum (ADR-0007). The threat classes are a desktop reader's: hostile file
content rendered as HTML, a path that escapes the folder, a dependency that brings a capability,
and an artifact that is not the reviewed tag.

- **QC-22:** Rendering the hostile fixture yields HTML with no `<script`, no `on*=` attribute, no
  `<iframe`, and exactly one `src=` — on the in-folder PNG, on the `nozoki-asset` scheme — and
  the in-folder SVG the observed-condition placeholder and no `src=`; the external link is inert text with its URL visible; the relative link is a data attribute.
  — *verified by:* `cargo test --locked -p nozoki-core --test markdown` over `checks/fixtures/hostile.md`
  (layer 2) *(traces to: SRS NFR-16, FR-32, AC-23; SDD § 4 C-D3; § SDD Review Notes RN-8 — the
  SVG case, RN-16; ADR-0006)*
- **QC-23:** The renderer's Content Security Policy in `tauri.conf.json` equals
  `default-src 'none'; script-src 'self'; style-src 'self'; img-src 'self' data: <asset-scheme>;
  font-src 'self'`, with `<asset-scheme>` the origin form settled for `nozoki-asset`; no directive
  admits `http:`, `https:`, `file:`, `asset:` or `*`.
  — *verified by:* `cargo test --locked -p nozoki-app --test config` — string equality against the entry
  (layer 2) *(traces to: SDD § 4 C-R7; ADR-0006)*
- **QC-24:** The host's capability file grants the renderer exactly the commands `open_folder`,
  `list_tree`, `select_file`, `open_relative_link`, `set_theme`, and — where built — `open_diff`,
  `walk_history`, `switch_folder`, plus the asset scheme, and no plugin.
  — *verified by:* `cargo test --locked -p nozoki-app --test config` — set equality against the list
  (layer 2) *(traces to: SDD § 3 seam 4; § 4 C-R7; ADR-0001)*
- **QC-25:** The bundle carries exactly the entitlements `com.apple.security.app-sandbox`,
  `com.apple.security.files.user-selected.read-only` and — once the folder selector exists —
  `com.apple.security.files.bookmarks.app-scope`; no other; and the launched bundle runs sandboxed.
  — *verified by:* `checks/bundle.sh` — `codesign -d --entitlements :- Nozoki.app` equals the list
  and `APP_SANDBOX_CONTAINER_ID` is set in the launched bundle's environment; on every CI build and
  as a release gate (layer 5) *(traces to: SDD § 4 C-R2, C-I3; § 11 R-8; ADR-0003; ADR-0008)*
- **QC-26:** Every dependency is deliberate: `Cargo.lock` and `pnpm-lock.yaml` are committed,
  CI installs with `pnpm install --frozen-lockfile` and `cargo build --locked`, and a lockfile
  diff that adds a name outside `checks/deps.allow` fails the build until the allowlist change is
  reviewed as code in the same change.
  — *verified by:* `checks/no-network.sh` (the tree); the lockfile diff at `development-design`
  (the change) *(traces to: SDD § 4 C-R6; `quality_defaults.md` § Dependencies; TypeScript packet
  `toolchain.md` § Adding, pinning and locking a dependency; ADR-0004)*
- **QC-27:** A dependency with a known critical vulnerability blocks the next release, for as
  long as it takes to fix, replace or remove the dependency. **No remediation window exists** —
  none, not undecided: the support posture promises "no commitment to fix, and no commitment that
  a fix ever arrives" (`docs/SRS.md` § 7 C-13, quoting `docs/PRD.md` § Assumptions "Support
  posture"; `docs/fdr.md` PD-22), a fix for an advisory is a fix, and where the SRS states the bar
  it outranks the doctrine floor's window. The floor's cost — an obligation nobody is late against
  — is accepted, and is what the posture already tells adopters. The audit databases are fetched
  by CI, never by the product (QC-32).
  — *verified by:* `pnpm audit --audit-level=critical` exits 0; `cargo audit` exits 0 — it has no
  severity threshold, so it gates on every advisory, stricter than *critical*: a non-critical
  advisory a release carries is ignored by id, `--ignore <RUSTSEC-id>`, the ignore and its reason
  added in the change that adds it and reviewed as code the way `checks/deps.allow` is (QC-26);
  both over the tree, as a release gate *(traces to: `quality_defaults.md` § Dependencies; SRS C-7,
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
  (files, entries, `.git`); FSEvents for that folder; the renderer's IPC commands and asset
  requests; and the product's own files in its container. The product has no other entry point —
  no argument vector, no environment variable, no configuration file, no socket.
  — *verified by:* `checks/structure.sh` (layer 6): no `std::env::args`, `std::env::var`, socket
  or config-file read in any shipped crate; review at `development-design` when a change adds an
  entry point — a scanner finds a new socket, not a new trust assumption *(traces to:
  `quality_defaults.md` § The boundary set; SRS NFR-14, FR-1; ADR-0001)*
- **QC-31:** Every value entering from outside is validated at the boundary it enters through
  before it reaches the model: a path by the containment check (QC-6), a decoded file by the
  UTF-8 rule, a Git answer by the port's plain-data contract.
  — *verified by:* review at `development-design` against the entry points the change touches —
  no machine check tells a real validation from a truthy test; the path half is QC-6's machine
  check *(traces to: `quality_defaults.md` § Input at the boundary; SRS DR-6; FDR R-46; ADR-0006)*
- **QC-32:** The set of destinations the product connects to is empty.
  — *verified by:* network monitoring across a full session shows zero outbound traffic
  (`docs/SRS.md` AC-3, the release); `checks/no-network.sh` (the tree); the absent network
  entitlement (QC-25) *(traces to: SRS NFR-7, NFR-8, AC-3; `quality_defaults.md` § The boundary
  set; ADR-0001; ADR-0003)*

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
  FDR PD-14, PD-33, OOS-11; ADR-0003; confirmed with the correction at
  `docs/trail/architecture/cycle-1.md` § 2.3 — RN-9)*

The **privilege** half binds. These are *reach* checks, not import checks (§ 1.2): a unit can
import nothing forbidden and still read a path it was never granted.

- **QC-34:** The renderer reaches nothing but the commands and the scheme QC-24 names: it opens
  no socket, reads no file, and follows no URL.
  — *verified by:* `pnpm exec vitest run tests/architecture` — no `fetch`, `XMLHttpRequest`,
  `WebSocket`, `EventSource`, `navigator.sendBeacon` or dynamic `import()` of a URL in `nozoki-ui`
  (layer 6); `checks/no-network.sh` *(traces to: SDD § 3 seam 4; ADR-0001; `quality_defaults.md`
  § Capability)*
- **QC-35:** The host reads nothing outside the granted folder and its own container, and writes
  nothing outside the container.
  — *verified by:* `checks/own-state.sh` and `checks/read-only.sh` (layer 5); the sandbox grant
  (QC-25) *(traces to: FDR R-101, R-102; SDD § 4 C-D1, C-D2; ADR-0003)*
- **QC-36:** No unit spawns a process, and no Tauri shell or process plugin is present.
  — *verified by:* `checks/structure.sh` (layer 6); `cargo test --locked -p nozoki-app --test config` —
  no plugin registered *(traces to: SDD § 3 `git-reader` "Must not own", `ipc-surface` "Must not
  own"; ADR-0004)*
- **QC-37:** The asset handler serves bytes read-only, only for a path the containment check
  passes and only for the four bitmap formats `docs/SDD.md` § 4 C-D3 names — PNG, JPEG, GIF and
  WebP — and returns nothing for any other request. An in-folder SVG is not served and takes the
  observed-condition placeholder; SVG reaches the scheme only through the mechanism SDD RN-8
  states — a host-side SVG sanitizer in `markdown-renderer`'s pipeline, serving sanitized bytes on
  the same scheme — and only after C-D3's format list moves, never by a handler edit alone.
  — *verified by:* `cargo test --locked -p nozoki-core --test markdown` — a request for the in-folder PNG
  returns its bytes; for the in-folder SVG and for each escaping path, nothing (layer 2)
  *(traces to: SDD § 3 `ipc-surface`; § 4 C-D3; § SDD Review Notes RN-8; ADR-0006; the format
  clause added at v5 on the re-authored SDD — RN-16)*

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
  cap (`cargo test --locked -p nozoki-app`), and the remembered list evicts the oldest entry on the eleventh
  and exposes no removal (`cargo test --locked -p nozoki-core`); `checks/own-state.sh` after
  `checks/churn.sh` — the log under the container is no larger than 1 MiB, and a line written
  before a relaunch is absent after it (layer 5; `docs/SRS.md` AC-13's inspection, machine-run)
  *(traces to: SRS NFR-11, AC-13; FDR R-110, R-178, R-180, R-182; SDD § 4 C-I2; § 3 `own-state`;
  the bound raised from this document and folded at SRS v9 — `docs/trail/architecture/cycle-1.md`
  § 1.2, RN-11; the remembered-folder clause brought to FDR v3 — RN-12)*
- **QC-41:** Every release carries `LICENSE` (MIT) and a `THIRD_PARTY_NOTICES.md` listing every
  crate and package the bundle ships with its licence.
  — *verified by:* `checks/notices.sh` — the names in `cargo tree` and `pnpm ls --prod` each
  appear in the notices file, non-zero on a miss (the release) *(traces to: SRS C-4, C-5, AC-14;
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
  SDD § 4 C-I4; § 11 R-5; ADR-0008)*

## 6. Availability & reliability

- **QC-47:** A failure to read one file, one tree entry or one part of Git state degrades only
  that item, and the next successful read of the same item replaces it without ceremony.
  — *verified by:* `cargo test --locked -p nozoki-core --test watch` — an unreadable fixture entry yields
  `failed` on that item and `observed` on its siblings (layer 2); UI tests (layer 4): the failure
  slot renders and the rest of the surface stands *(traces to: SRS NFR-3; SDD § 4 C-I1, C-E3;
  FDR R-83, R-85)*
- **QC-48:** Under scripted concurrent change — create, modify and delete including the displayed
  file, with Git operations mid-flight, and `git init` at a plain root then its removal — the host
  does not panic, the model's final snapshot equals a fresh open of the fixture, expansion,
  selection and reading position survive, and the fixture is byte-identical to the script's own
  final state.
  — *verified by:* `cargo test --locked -p nozoki-core --test watch` running `checks/churn.sh <fixture> 30`;
  `checks/read-only.sh` against the churn's final state as baseline (layer 3) *(traces to: SRS
  FR-16, NFR-3, NFR-4, AC-8; SDD § 6 S-5; ADR-0008)*
- **QC-49:** The read-only and no-network promises hold through abnormal exit: the host killed
  mid-churn leaves the fixture unchanged and `.git` byte-identical.
  — *verified by:* `checks/read-only.sh --kill` — the harness sends SIGKILL to the host during
  `checks/churn.sh` and re-hashes (layer 5); the sandbox (QC-25) is what makes the property hold
  by construction *(traces to: SRS NFR-4, NFR-9; ADR-0003; ADR-0008; the `--kill` mode is this
  document's addition — RN-4)*
- **QC-50:** The Git port's contract tests are written against the port, not the adapter, so the
  installed-`git` substitute is proved by the same tests when it is built.
  — *verified by:* review at `development-design` when a change touches the port — one adapter
  exists, so "the same tests pass twice" cannot run until the second does; the tests' location is
  the port's, and a test importing the adapter directly fails the review *(traces to: SDD § 3
  seam 2; § 11 R-1; ADR-0004; QC-18)*

## 7. Observability & monitoring

- **QC-51:** A failure the user must know about is visible in the product's own window, in the
  failure slot of the item that stopped, with an enabled route out on the same surface; no
  modal, toast, dialog or terminal line carries a failure.
  — *verified by:* UI tests (layer 4): a `failed` and a `stopped` projection each render in the
  item's slot with the route present; `checks/structure.sh` — no dialog or notification API in
  `nozoki-ui` (layer 6) *(traces to: SRS NFR-11; SDD § 4 C-E3, C-I1; FDR R-86, R-87, R-90, R-91)*
- **QC-52:** The diagnostic log is written to
  `~/Library/Containers/com.kensaiapp.nozoki/Data/Library/Logs/nozoki.log` and nowhere else, one
  line per `failed` or `stopped` item; it is the product's only diagnostic output.
  — *verified by:* `checks/own-state.sh` (layer 5); unit test on the writer's path and line shape
  (layer 1) *(traces to: SDD § 4 C-I2; SRS NFR-11; FDR PD-32)*
- **QC-61:** The logging facade is `log`, and its implementation is the product's own. Every
  shipped Rust crate depends on the `log` facade for diagnostics and on nothing else — no
  `tracing`, no `slog`, no second facade; `nozoki-core` uses the five macros and initializes
  nothing. The implementation is `nozoki-app`'s own log module — the writer QC-39, QC-40 and QC-52
  already bind — implementing `log::Log`, installed once at startup in `nozoki-app`, the
  composition root (QC-17), with no third-party implementation crate; the level it admits is fixed
  in code and read from nothing outside the binary, and it holds what QC-39 and QC-52 describe and
  nothing below it. The implementation is the product's own because of a constraint already here,
  not taste: the stock implementations read their level from the environment — `env_logger` is "a
  simple logger that can be configured via environment variables", `RUST_LOG` controlling the
  filter (https://docs.rs/env_logger/latest/env_logger/) — and QC-30 and QC-58 forbid
  `std::env::var` in any shipped crate, so an off-the-shelf logger fails `checks/structure.sh` the
  day it lands. Which macro a `failed` and a `stopped` item are emitted at is the delivery tier's
  placement under the packet's ladder, not this entry's.
  — *verified by:* `checks/no-network.sh` — `checks/deps.allow` names `log` and names no
  `tracing*`, `env_logger`, `slog*` or `log4rs` crate, so a swap fails the allowlist diff (QC-3,
  QC-26; the tree); `checks/structure.sh` (layer 6) — `log::set_logger` and
  `log::set_boxed_logger` appear only in `nozoki-app` *(traces to:
  `languages/rust/errors_logging.md` v1.1.0 § Logging, § Which facade — the packet requires the
  binary to select an implementation and this document to record the facade, and fixes no default;
  SDD § 4 C-I2; SRS NFR-11; FDR PD-32; QC-17, QC-30, QC-39, QC-52, QC-58; ADR-0009 § Decision;
  answered in the owner's seat at `docs/trail/architecture/cycle-2.md` § 1.1 — RN-15)*
- **QC-53:** No internal text reaches any surface: no stack trace, no error code, no library name,
  and none of the words `docs/CONTENT.md` § Terminology bans; every message the product shows is a
  whole sentence from its catalogue.
  — *verified by:* `checks/strings.sh` — a lint over the renderer's message catalogue for the
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
test command is the SDD's command bar for the Rust workspace — `cargo test --workspace --locked`
exits 0 (`docs/SDD.md` § 6 S-1), the bar carrying the Rust packet's `--locked` itself since the
SDD's re-author (`languages/rust/testing.md` § Layers 1–5; RN-16) — and Vitest for the renderer; its `Languages:` line
names Rust, TypeScript and Shell (RN-6). Why the workspace form is this product's change-time run,
where the packet classifies it as release-time, is RN-7. What follows exceeds the card.

- **QC-55:** The product is one macOS application bundle, `Nozoki.app`, bundle identifier
  `com.kensaiapp.nozoki`; no second binary, no prerequisite, no runtime install, no fetched asset.
  — *verified by:* `checks/bundle.sh` — one executable under `Contents/MacOS`, every renderer asset
  under `Contents/Resources` (layer 5) *(traces to: SDD § 4 C-R1; SRS C-3; FDR R-131, PD-15, PD-28;
  ADR-0002)*
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
- **QC-58:** The product has no configuration surface: it reads no configuration file, no
  environment variable and no argument; the only input is the folder chosen in the Open panel.
  — *verified by:* `checks/structure.sh` (layer 6), the same rule as QC-30; `docs/SRS.md` AC-9 at
  release *(traces to: SRS NFR-14, FR-1, AC-9; FDR R-2; ADR-0003)*
- **QC-59:** From the first 1.0.0 release the public contract semantic versioning binds is:
  every rule and product decision in `docs/fdr.md` as observable behaviour; the install path
  (QC-57); the readability of an earlier version's own-state (QC-60); and the macOS floor
  (QC-56). A *breaking* change to any of these — a behaviour the FDR states that no longer holds,
  an install path or a floor that an adopter on the old one loses, an own-state a later version
  can no longer read — is a major version after 1.0.0; an added behaviour that leaves every stated
  rule holding — a seventh highlighted language, a new read surface, a lowered floor — is a minor
  version. `docs/SRS.md` C-6's "the product's public contract" points here; the definition is a
  constraint — a change could ship breaking as minor silently, and a check names it — so it lives
  in this document and no SRS revision carries it.
  — *verified by:* from `v1.0.0`, `checks/contract.sh <tag>` against the pin
  `checks/contract/<major>` — written once at the major's `.0.0` release from the built bundle and
  read as `git show v<major>.0.0:checks/contract/<major>`, holding the macOS floor as
  `LSMinimumSystemVersion` prints it, the release's asset names and the capability file's command
  list — fails on a tag inside a major whose bundle raises the floor, drops an asset or drops a
  command (the release; layer 5): the machine check for the install path, the floor and the
  surfaces' presence; own-state readability is QC-60's check. The behaviour member has no machine
  check — no test reads the FDR — and stays a review gate: review at `development-specs` — a change
  spec names which of the four it touches and whether the change is breaking or additive, and the
  version bump follows; release inspection reads the version against the change set
  (`docs/SRS.md` AC-14). Before `v1.0.0` there is no pin and the script is not run — C-6's
  pre-1.0.0 half, stated rather than tested *(traces to: SRS C-6; FDR R-142, PD-20; SDD § 4 C-I6,
  § 11 R-12 — the check added at v5, RN-16; confirmed with the breaking/additive split at
  `docs/trail/architecture/cycle-1.md` § 2.1 — RN-5, RN-11)*
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
project's realization of it. Tooling for the renderer comes from the TypeScript packet
(`languages/typescript/testing.md` v2.0.1) and for the host and core from the Rust packet
(`languages/rust/testing.md` v1.0.0); what this table fixes differently from either packet, and
why, is RN-7. If this table and the doctrine disagree on the layers, this table is the copy and is
wrong.

| Level | Scope | Tool | Where it lives |
|---|---|---|---|
| 1 — Unit | The reducer, `ItemState` transitions, the containment check, extension recognition, the sanitizer allowlist, the log line shape | `cargo test --locked` (`#[cfg(test)]` beside the module); Vitest for `nozoki-ui` | inside each `nozoki-core` / `nozoki-app` module; `nozoki-ui/tests/unit/<module>.test.ts` |
| 2 — Integration | `fs-reader` and `git-reader` against real fixture folders and repositories; the Markdown pipeline against `hostile.md`; the host's config against its own files | `cargo test --locked -p nozoki-core --test git_state`, `--test root_finding`, `--test markdown`, `--test watch`; `cargo test --locked -p nozoki-app --test config` | `crates/nozoki-core/tests/`, `crates/nozoki-app/tests/`, over `checks/fixtures/` |
| 3 — Application | The IPC command list driven in-process through `nozoki-core`, bypassing the renderer; the whole-model switch | `checks/read-only.sh`; `cargo test --locked -p nozoki-core --test switch` | `checks/`, `crates/nozoki-core/tests/` |
| 4 — UI | A surface renders truthfully given a model projection: *pending* as the word, no marker before `observed`, the Git view empty on `plain`, the failure slot and its route, both themes | Vitest Browser Mode with the Playwright provider (`pnpm exec vitest run`) | `nozoki-ui/tests/ui/<component>.test.ts` |
| 5 — End-to-end | The built bundle: entitlements and sandbox, own-state after a session, churn and kill, latency figures; from `v1.0.0` the priced contract against its major's pin; the timed release walk | `checks/bundle.sh`, `checks/own-state.sh`, `checks/churn.sh`, `checks/latency.sh`, `checks/read-only.sh --kill`, `checks/contract.sh <tag>`; `docs/SRS.md` AC-10 as a manual timed walk | `checks/` |
| 6 — Architecture | § 1.2's graph, § 1.3's I/O ownership, § 3's reach rules, and this section's layer-5 placement (no `CARGO_BIN_EXE_` reference under `crates/*/tests/`) | `checks/structure.sh` (Rust, grep rules); `pnpm exec vitest run tests/architecture` (TypeScript) | `checks/`, `nozoki-ui/tests/architecture/<property>.test.ts` |
| 7 — Specification | The SRS's acceptance criteria as scenarios through the real entry point | the SDD's per-slice command bars and the AC walk at release, until a QA seat writes the layer | `checks/` |

- **Layer 3 is present**, realized as the harness: it enters inside the boundary by calling the
  command list in-process, which is `testing_doctrine.md`'s own test for layer 3 versus layer 5.
- **Layer 4 is present** — the product has a UI and gets no exemption. The TypeScript packet fixes
  Vitest Browser Mode with Playwright as its provider; the browser Playwright drives is not the
  WKWebView the product ships in, which is why layer 4 proves *rendering given state* and layer 5
  proves the bundle (RN-7).
- **Layer 5 departs from the TypeScript packet's Playwright row**: Tauri has no WKWebView driver on
  macOS (ADR-0008), so the built bundle is exercised by the harness scripts and the rendered UI by
  the timed manual walk, deliberately not automated (`docs/SRS.md` AC-10). **Layer 5 also stays
  outside `cargo test`**, against the Rust packet's shape (`tests/<flow>.rs` in the binary crate):
  the only `--test` file `nozoki-app` carries is `config` (layer 2), and no file under
  `crates/*/tests/` starts the built binary — no `CARGO_BIN_EXE_` reference there, a
  `checks/structure.sh` rule (layer 6, row 6). That placement is what makes
  `cargo test --workspace --locked` this product's change-time run (RN-7).
- **Layers 6–7 are QA-role ATDD work.** No QA seat has written either for this product yet; until
  one does, layer 6 is verified by `checks/structure.sh` and the architecture tests named above,
  run in CI, and layer 7 by the SDD's per-slice command bars and the acceptance walk at release.

## 10. Verification map

A projection of every machine-checked entry above. When a row disagrees with its entry, the entry
is right and this row is stale.

| QC | Check | Command / layer | Runs over | Gated at |
|---|---|---|---|---|
| QC-1 | renderer capability | `pnpm exec vitest run tests/architecture`; `checks/no-network.sh` | the tree | CI build |
| QC-2 | no write under the folder | `checks/read-only.sh <fixture>`; `checks/structure.sh` | the tree | CI build; release |
| QC-3 | no network transport | `checks/no-network.sh` | the tree | CI build |
| QC-4 | ItemState on every read | `cargo test --locked -p nozoki-core` (layer 1); `pnpm exec vitest run` (layer 4) | the change | `development-implementation` |
| QC-5 | root finding | `cargo test --locked -p nozoki-core --test root_finding` | the change | `development-implementation` |
| QC-6 | containment check | `cargo test --locked -p nozoki-core --test markdown` | the change | `development-implementation` |
| QC-7 | no mutating Git call, no spawn | `checks/read-only.sh`; `checks/structure.sh` | the tree | CI build |
| QC-8 | `nozoki-ui` imports | `pnpm exec vitest run tests/architecture` | the tree | CI build |
| QC-9 – QC-12, QC-14 | `nozoki-core` / `checks/` imports | `checks/structure.sh`; `checks/no-network.sh`; `cargo tree -p nozoki-app` | the tree | CI build |
| QC-13 | `nozoki-app` imports | `checks/structure.sh` | the tree | CI build |
| QC-15, QC-17 | I/O ownership; composition root | `checks/structure.sh` | the tree | CI build |
| QC-16 | writes only in the container | `checks/own-state.sh` | the tree | CI build; release |
| QC-19 | folder replace-whole | `cargo test --locked -p nozoki-core --test switch`; `git diff --stat …` | the change | `development-implementation` |
| QC-20 | own-state isolation | `checks/structure.sh` | the tree | CI build |
| QC-22 | sanitizer output | `cargo test --locked -p nozoki-core --test markdown` | the change | `development-implementation` |
| QC-23, QC-24, QC-36 | CSP; capability file; no plugin | `cargo test --locked -p nozoki-app --test config` | the tree | CI build |
| QC-25 | entitlements; sandbox present | `checks/bundle.sh` | the tree | CI build; release gate |
| QC-26 | allowlist; frozen lockfiles | `checks/no-network.sh`; `pnpm install --frozen-lockfile`; `cargo build --locked` | the tree | CI build |
| QC-27 | critical vulnerability | `cargo audit` (every advisory; `--ignore <RUSTSEC-id>` with its reason); `pnpm audit --audit-level=critical` | the tree | release |
| QC-28 | no secret; no signing identity | `gitleaks git`; `gh secret list --repo kensaiapp/nozoki`; `codesign -dv Nozoki.app` | the tree; the release | CI build; release |
| QC-29 | artifact = tag build | `shasum -a 256 -c SHA256SUMS` against a rebuild | the release | release |
| QC-30, QC-58 | no other entry point; no configuration | `checks/structure.sh` | the tree | CI build |
| QC-32 | empty egress set | AC-3 network monitor; `checks/no-network.sh` | the release; the tree | release; CI build |
| QC-34 | renderer reach | `pnpm exec vitest run tests/architecture`; `checks/no-network.sh` | the tree | CI build |
| QC-35 | host reach | `checks/own-state.sh`; `checks/read-only.sh` | the tree | CI build |
| QC-37 | asset handler | `cargo test --locked -p nozoki-core --test markdown` | the change | `development-implementation` |
| QC-38 | own-state fields | `checks/own-state.sh` | the tree | CI build |
| QC-39, QC-52 | log shape and location | `cargo test --locked -p nozoki-app` (layer 1); `checks/own-state.sh` | the change; the tree | `development-implementation`; CI build |
| QC-40 | log bound; own-state retention | `cargo test --locked -p nozoki-app`, `cargo test --locked -p nozoki-core` (layer 1); `checks/own-state.sh` after `checks/churn.sh` | the change; the tree | `development-implementation`; CI build |
| QC-41 | third-party notices | `checks/notices.sh` | the release | release |
| QC-42 | private reporting; SECURITY.md | `gh api repos/kensaiapp/nozoki/private-vulnerability-reporting` | the release | release |
| QC-44 | standing sentences verbatim | `checks/readme.sh` | the release | release |
| QC-46 | latency figures | `checks/latency.sh` | the tree | CI build |
| QC-47, QC-48 | per-item degradation; churn | `cargo test --locked -p nozoki-core --test watch` with `checks/churn.sh` | the change | `development-implementation` |
| QC-49 | promises through kill | `checks/read-only.sh --kill` | the tree | CI build; release |
| QC-51 | failure visible in window | `pnpm exec vitest run` (layer 4); `checks/structure.sh` | the change; the tree | `development-implementation`; CI build |
| QC-53 | no internal text | `checks/strings.sh`; layer-5 error-path tests | the tree | CI build |
| QC-55 | one bundle | `checks/bundle.sh` | the tree | CI build |
| QC-56 | macOS floor in the bundle | `/usr/libexec/PlistBuddy -c 'Print :LSMinimumSystemVersion' …` | the release | release |
| QC-59 | priced contract against its major's pin | `checks/contract.sh <tag>` | the release | release, from `v1.0.0` |
| QC-60 | own-state read across versions | `checks/own-state.sh --from <previous-tag>` | the release | release |
| QC-61 | logging facade and its implementation | `checks/no-network.sh`; `checks/structure.sh` | the tree | CI build |

Entries with no row are review gates, each arguing its downgrade in its own tail: QC-13 (the
delegation half), QC-18, QC-21, QC-31, QC-33, QC-43, QC-45, QC-50, QC-54, QC-57, and QC-59's behaviour member.

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
  § 2.3). *(re: § 8; source: SDD § 6 S-1; ADR-0009; `languages/rust/testing.md` v1.0.0; the four
  commits named)*
- **RN-7:** *(language packets — re-derived at v3)* Both packets resolve at step 1 of
  `languages/README.md` § The resolution chain, from the card's `Languages:` line (RN-6): the
  renderer to the TypeScript packet, the host and core to the Rust packet, which the organisation's
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
