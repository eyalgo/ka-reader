# NFDR — Nozoki 覗き

**Status:** Draft
**Owner:** Principal Architect
**Version:** 1 — the constraint set stated for the first time, over the settled SDD and SRS with the FDR beside them: the module set and its import graph, the read-only and no-network invariants as machine checks, the three walls around rendered content, the release and sandbox gates, and the test-strategy realization for a Rust host with a TypeScript renderer. Nine items are parked for the owner in `docs/architecture_open_issues.md`.
**Inputs read:** SRS Settled · SDD Settled · FDR Draft · PRD Settled · UXD Settled · DESIGN Settled · CONTENT Settled

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
> `testing_doctrine.md` v2.1.1 or the TypeScript packet (`languages/typescript/`, `testing.md`
> v2.0.1, `toolchain.md` v1.1.0, `quality_gates.md` v1.1.0) names an engineering-doctrine file of
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
  — *verified by:* `cargo test -p nozoki-core --test root_finding` over the plain,
  inside-a-repository, parent-of-two, linked-worktree and submodule fixtures (layer 2) *(traces to:
  ADR-0005; SRS FR-33, FR-34, AC-24, AC-25)*
- **QC-6:** Every path derived from content or from outside — a tree entry, a symlink target, a
  Markdown image reference, a relative link, an asset request — passes `fs-reader`'s containment
  check on the canonical path, symlinks resolved and after decoding, before any open; the asset
  handler re-runs it on every request.
  — *verified by:* `cargo test -p nozoki-core --test markdown` — the `..` and symlink-out fixtures
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
  — *verified by:* `cargo test -p nozoki-core --test switch` (layer 3);
  `git diff --stat <last-release-tag>..HEAD -- nozoki-ui/src/tree nozoki-ui/src/git-view
  nozoki-ui/src/reading-panel` prints nothing on the change that adds the selector (the change)
  *(traces to: SRS NFR-12, FR-19; FDR PD-29; SDD § 3 `folder-model`, § 6 S-6)*
- **QC-20:** Swapping `own-state`'s storage format touches `own-state` only; no other unit reads
  the container.
  — *verified by:* `checks/structure.sh` (layer 6): the container path appears only in `own-state`
  and the host's log module *(traces to: SDD § 3 seam 6; ADR-0009)*
- **QC-21:** No swap invariant is held for the renderer technology or the platform: neither is
  replaceable inside the terminus, and reversing either costs what ADR-0002 states. A change that
  claims either is cheap to replace is wrong.
  — *verified by:* review at `development-design` — a stated non-invariant has nothing to run
  *(traces to: FDR PD-29; SDD § 9 TO-1; ADR-0002)*

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
  `<iframe`, and exactly one `src=` — on the in-folder image, on the `nozoki-asset` scheme; the
  external link is inert text with its URL visible; the relative link is a data attribute.
  — *verified by:* `cargo test -p nozoki-core --test markdown` over `checks/fixtures/hostile.md`
  (layer 2) *(traces to: SRS NFR-16, FR-32, AC-23; SDD § 4 C-D3; ADR-0006)*
- **QC-23:** The renderer's Content Security Policy in `tauri.conf.json` equals
  `default-src 'none'; script-src 'self'; style-src 'self'; img-src 'self' data: <asset-scheme>;
  font-src 'self'`, with `<asset-scheme>` the origin form settled for `nozoki-asset`; no directive
  admits `http:`, `https:`, `file:`, `asset:` or `*`.
  — *verified by:* `cargo test -p nozoki-app --test config` — string equality against the entry
  (layer 2) *(traces to: SDD § 4 C-R7; ADR-0006)*
- **QC-24:** The host's capability file grants the renderer exactly the commands `open_folder`,
  `list_tree`, `select_file`, `open_relative_link`, `set_theme`, and — where built — `open_diff`,
  `walk_history`, `switch_folder`, plus the asset scheme, and no plugin.
  — *verified by:* `cargo test -p nozoki-app --test config` — set equality against the list
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
- **QC-27:** A dependency with a known critical vulnerability blocks the next release. **No
  remediation window is stated**: the support posture promises no fix time (`docs/SRS.md` § 7
  C-7, C-13; `docs/fdr.md` PD-22), and whether a window exists at all is the owner's — open at
  `docs/architecture_open_issues.md` § 1.1.
  — *verified by:* `cargo audit` and `pnpm audit --audit-level=critical` exit 0 (the tree), as a
  release gate *(traces to: `quality_defaults.md` § Dependencies; SRS C-7; the commands are this
  document's realization — RN-3)*
- **QC-28:** No secret is in the repository, and the release workflow holds no signing identity.
  — *verified by:* `gitleaks detect` exits 0 over the tree; `gh secret list --repo kensaiapp/nozoki`
  prints no entry; `codesign -dv Nozoki.app` on the downloaded bundle reports `Signature=adhoc`
  *(traces to: `quality_defaults.md` § Secrets; SDD § 4 C-R4; ADR-0007; the scanner is this
  document's realization — RN-3)*
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
  mode or a second folder, both of which the FDR places out of scope.
  — *verified by:* review at `development-specs` when a change adds a hosted mode, an account, or
  any identifier — a declared absence has nothing to run *(traces to: SDD § 4 C-D1; SRS NFR-7;
  FDR PD-14, PD-33, OOS-11, OOS-12; ADR-0003)*

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
  — *verified by:* `checks/structure.sh` (layer 6); `cargo test -p nozoki-app --test config` —
  no plugin registered *(traces to: SDD § 3 `git-reader` "Must not own", `ipc-surface` "Must not
  own"; ADR-0004)*
- **QC-37:** The asset handler serves bytes read-only, only for a path the containment check
  passes, and returns nothing for any other request.
  — *verified by:* `cargo test -p nozoki-core --test markdown` — a request for the in-folder image
  returns its bytes; for each escaping path, nothing (layer 2) *(traces to: SDD § 3 `ipc-surface`;
  § 4 C-D3; ADR-0006)*

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
- **QC-40:** Retention: own-state persists until the user changes it by the control that set it,
  and a remembered folder until its entry is removed. **The diagnostic log's size and retention
  bound is undecided**; the owner decides it at `docs/architecture_open_issues.md` § 1.2, and the
  SRS states it at NFR-11 by revision.
  — *verified by:* review at `development-design` when a change touches own-state or the log — no
  bound exists yet to assert *(traces to: FDR R-110; SRS NFR-11; SDD § 4 C-I2)*
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
  — *verified by:* `cargo test -p nozoki-core --test watch` — an unreadable fixture entry yields
  `failed` on that item and `observed` on its siblings (layer 2); UI tests (layer 4): the failure
  slot renders and the rest of the surface stands *(traces to: SRS NFR-3; SDD § 4 C-I1, C-E2;
  FDR R-83, R-85)*
- **QC-48:** Under scripted concurrent change — create, modify and delete including the displayed
  file, with Git operations mid-flight, and `git init` at a plain root then its removal — the host
  does not panic, the model's final snapshot equals a fresh open of the fixture, expansion,
  selection and reading position survive, and the fixture is byte-identical to the script's own
  final state.
  — *verified by:* `cargo test -p nozoki-core --test watch` running `checks/churn.sh <fixture> 30`;
  `checks/read-only.sh` against the churn's final state as baseline (layer 3) *(traces to: SRS
  FR-16, NFR-3, NFR-4, AC-8; SDD § 6 S-4; ADR-0008)*
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
  `nozoki-ui` (layer 6) *(traces to: SRS NFR-11; SDD § 4 C-E2, C-I1; FDR R-86, R-87, R-90, R-91)*
- **QC-52:** The diagnostic log is written to
  `~/Library/Containers/com.kensaiapp.nozoki/Data/Library/Logs/nozoki.log` and nowhere else, one
  line per `failed` or `stopped` item; it is the product's only diagnostic output.
  — *verified by:* `checks/own-state.sh` (layer 5); unit test on the writer's path and line shape
  (layer 1) *(traces to: SDD § 4 C-I2; SRS NFR-11; FDR PD-32)*
- **QC-53:** No internal text reaches any surface: no stack trace, no error code, no library name,
  and none of the words `docs/CONTENT.md` § Terminology bans; every message the product shows is a
  whole sentence from its catalogue.
  — *verified by:* `checks/strings.sh` — a lint over the renderer's message catalogue for the
  banned list, non-zero on a hit (the tree); layer-5 error-path tests that a `stopped` item's
  surface text is a catalogue sentence *(traces to: SDD § 4 C-E2, C-E8; FDR R-89; CONTENT
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
test command reads as provisional and disagrees with the SDD's command bar (RN-6). What follows
exceeds the card.

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
  (QC-56). A change to any of these is a major version after 1.0.0. **Drafted, awaiting
  confirmation** — `docs/architecture_open_issues.md` § 2.1.
  — *verified by:* review at `development-specs` — a change spec names which of the four it
  touches, and the version bump follows; release inspection reads the version against the change
  set (`docs/SRS.md` AC-14) *(traces to: SRS C-6; FDR R-142, PD-20; the contract's content is this
  document's draft — RN-5)*
- **QC-60:** A later version either reads an earlier version's own-state or discards it whole,
  and in neither case touches the viewed folder; before 1.0.0 a discard is permitted and stated
  where the release is offered; after 1.0.0 a discard is a breaking change under QC-59. **Drafted,
  awaiting confirmation** — `docs/architecture_open_issues.md` § 2.2.
  — *verified by:* `checks/own-state.sh --from <previous-tag>` — a container written by the
  previous release is opened by the current build without a write outside the container
  (layer 5) *(traces to: SRS DR-5, C-6; FDR R-108, R-109; the rule is this document's draft — RN-5)*

## 9. Test strategy

The layer set is **not defined here** — it is `testing_doctrine.md` v2.1.1, and this table is one
project's realization of it. Tooling for the renderer comes from the TypeScript packet
(`languages/typescript/testing.md` v2.0.1); the host and core are Rust, for which no language packet
exists, so their tooling is this product's own, recorded here (RN-7). If this table and the
doctrine disagree on the layers, this table is the copy and is wrong.

| Level | Scope | Tool | Where it lives |
|---|---|---|---|
| 1 — Unit | The reducer, `ItemState` transitions, the containment check, extension recognition, the sanitizer allowlist, the log line shape | `cargo test` (`#[cfg(test)]` beside the module); Vitest for `nozoki-ui` | inside each `nozoki-core` / `nozoki-app` module; `nozoki-ui/tests/unit/<module>.test.ts` |
| 2 — Integration | `fs-reader` and `git-reader` against real fixture folders and repositories; the Markdown pipeline against `hostile.md`; the host's config against its own files | `cargo test -p nozoki-core --test git_state`, `--test root_finding`, `--test markdown`, `--test watch`; `cargo test -p nozoki-app --test config` | `nozoki-core/tests/`, `nozoki-app/tests/`, over `checks/fixtures/` |
| 3 — Application | The IPC command list driven in-process through `nozoki-core`, bypassing the renderer; the whole-model switch | `checks/read-only.sh`; `cargo test -p nozoki-core --test switch` | `checks/`, `nozoki-core/tests/` |
| 4 — UI | A surface renders truthfully given a model projection: *pending* as the word, no marker before `observed`, the Git view empty on `plain`, the failure slot and its route, both themes | Vitest Browser Mode with the Playwright provider (`pnpm exec vitest run`) | `nozoki-ui/tests/ui/<component>.test.ts` |
| 5 — End-to-end | The built bundle: entitlements and sandbox, own-state after a session, churn and kill, latency figures; the timed release walk | `checks/bundle.sh`, `checks/own-state.sh`, `checks/churn.sh`, `checks/latency.sh`, `checks/read-only.sh --kill`; `docs/SRS.md` AC-10 as a manual timed walk | `checks/` |
| 6 — Architecture | § 1.2's graph, § 1.3's I/O ownership, § 3's reach rules | `checks/structure.sh` (Rust, grep rules); `pnpm exec vitest run tests/architecture` (TypeScript) | `checks/`, `nozoki-ui/tests/architecture/<property>.test.ts` |
| 7 — Specification | The SRS's acceptance criteria as scenarios through the real entry point | the SDD's per-slice command bars and the AC walk at release, until a QA seat writes the layer | `checks/` |

- **Layer 3 is present**, realized as the harness: it enters inside the boundary by calling the
  command list in-process, which is `testing_doctrine.md`'s own test for layer 3 versus layer 5.
- **Layer 4 is present** — the product has a UI and gets no exemption. The TypeScript packet fixes
  Vitest Browser Mode with Playwright as its provider; the browser Playwright drives is not the
  WKWebView the product ships in, which is why layer 4 proves *rendering given state* and layer 5
  proves the bundle (RN-7).
- **Layer 5 departs from the TypeScript packet's Playwright row**: Tauri has no WKWebView driver on
  macOS (ADR-0008), so the built bundle is exercised by the harness scripts and the rendered UI by
  the timed manual walk, deliberately not automated (`docs/SRS.md` AC-10).
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
| QC-4 | ItemState on every read | `cargo test -p nozoki-core` (layer 1); `pnpm exec vitest run` (layer 4) | the change | `development-implementation` |
| QC-5 | root finding | `cargo test -p nozoki-core --test root_finding` | the change | `development-implementation` |
| QC-6 | containment check | `cargo test -p nozoki-core --test markdown` | the change | `development-implementation` |
| QC-7 | no mutating Git call, no spawn | `checks/read-only.sh`; `checks/structure.sh` | the tree | CI build |
| QC-8 | `nozoki-ui` imports | `pnpm exec vitest run tests/architecture` | the tree | CI build |
| QC-9 – QC-12, QC-14 | `nozoki-core` / `checks/` imports | `checks/structure.sh`; `checks/no-network.sh`; `cargo tree -p nozoki-app` | the tree | CI build |
| QC-13 | `nozoki-app` imports | `checks/structure.sh` | the tree | CI build |
| QC-15, QC-17 | I/O ownership; composition root | `checks/structure.sh` | the tree | CI build |
| QC-16 | writes only in the container | `checks/own-state.sh` | the tree | CI build; release |
| QC-19 | folder replace-whole | `cargo test -p nozoki-core --test switch`; `git diff --stat …` | the change | `development-implementation` |
| QC-20 | own-state isolation | `checks/structure.sh` | the tree | CI build |
| QC-22 | sanitizer output | `cargo test -p nozoki-core --test markdown` | the change | `development-implementation` |
| QC-23, QC-24, QC-36 | CSP; capability file; no plugin | `cargo test -p nozoki-app --test config` | the tree | CI build |
| QC-25 | entitlements; sandbox present | `checks/bundle.sh` | the tree | CI build; release gate |
| QC-26 | allowlist; frozen lockfiles | `checks/no-network.sh`; `pnpm install --frozen-lockfile`; `cargo build --locked` | the tree | CI build |
| QC-27 | critical vulnerability | `cargo audit`; `pnpm audit --audit-level=critical` | the tree | release |
| QC-28 | no secret; no signing identity | `gitleaks detect`; `gh secret list --repo kensaiapp/nozoki`; `codesign -dv Nozoki.app` | the tree; the release | CI build; release |
| QC-29 | artifact = tag build | `shasum -a 256 -c SHA256SUMS` against a rebuild | the release | release |
| QC-30, QC-58 | no other entry point; no configuration | `checks/structure.sh` | the tree | CI build |
| QC-32 | empty egress set | AC-3 network monitor; `checks/no-network.sh` | the release; the tree | release; CI build |
| QC-34 | renderer reach | `pnpm exec vitest run tests/architecture`; `checks/no-network.sh` | the tree | CI build |
| QC-35 | host reach | `checks/own-state.sh`; `checks/read-only.sh` | the tree | CI build |
| QC-37 | asset handler | `cargo test -p nozoki-core --test markdown` | the change | `development-implementation` |
| QC-38 | own-state fields | `checks/own-state.sh` | the tree | CI build |
| QC-39, QC-52 | log shape and location | `cargo test -p nozoki-app` (layer 1); `checks/own-state.sh` | the change; the tree | `development-implementation`; CI build |
| QC-41 | third-party notices | `checks/notices.sh` | the release | release |
| QC-42 | private reporting; SECURITY.md | `gh api repos/kensaiapp/nozoki/private-vulnerability-reporting` | the release | release |
| QC-44 | standing sentences verbatim | `checks/readme.sh` | the release | release |
| QC-46 | latency figures | `checks/latency.sh` | the tree | CI build |
| QC-47, QC-48 | per-item degradation; churn | `cargo test -p nozoki-core --test watch` with `checks/churn.sh` | the change | `development-implementation` |
| QC-49 | promises through kill | `checks/read-only.sh --kill` | the tree | CI build; release |
| QC-51 | failure visible in window | `pnpm exec vitest run` (layer 4); `checks/structure.sh` | the change; the tree | `development-implementation`; CI build |
| QC-53 | no internal text | `checks/strings.sh`; layer-5 error-path tests | the tree | CI build |
| QC-55 | one bundle | `checks/bundle.sh` | the tree | CI build |
| QC-56 | macOS floor in the bundle | `/usr/libexec/PlistBuddy -c 'Print :LSMinimumSystemVersion' …` | the release | release |
| QC-60 | own-state read across versions | `checks/own-state.sh --from <previous-tag>` | the release | release |

Entries with no row are review gates, each arguing its downgrade in its own tail: QC-13 (the
delegation half), QC-18, QC-21, QC-31, QC-33, QC-40, QC-43, QC-45, QC-50, QC-54, QC-57, QC-59.

---

## NFDR Review Notes

- **RN-1:** *(the derivation)* Every entry traces to an SRS requirement, an SDD condition, an ADR
  record, an FDR rule or decision, or a doctrine floor named by file and version. No quality floor
  originates here. The SDD's § 4 conditions (`C-R`, `C-I`, `C-D`) are the source of most § 2 – § 8
  entries; the SDD describes each once and this document carries the checkable form, per the
  ownership rule that the enforceable statement lives where the checker looks.
- **RN-2:** *(the FDR at Draft)* `docs/fdr.md` is Draft at v1 with eight companion items open
  (`docs/fdr_open_issues.md`). Every FDR trace here is to a rule or decision the FDR carries from a
  settled source; none turns on an item that companion holds. The one FDR contradiction with the
  SRS — FR-13 versus the Git-view row opening the diff (`docs/fdr.md` RN-1) — is behaviour and
  moves nothing structural.
- **RN-3:** *(tools this document names where the SDD named none)* `cargo audit`,
  `pnpm audit --audit-level=critical`, `gitleaks detect`, `checks/structure.sh`,
  `checks/notices.sh`, `checks/readme.sh`, `checks/strings.sh` and
  `cargo test -p nozoki-app --test config` are this document's realizations of obligations whose
  source names the obligation and not the command — the doctrine floors for secrets and
  dependencies, and the SDD's config, notice and wording bars. Another tool with an exit code
  satisfies the same entry; the tool choice is the CTO's toolchain lane and is put to the owner as
  `docs/architecture_open_issues.md` § 2.7. *(re: QC-9 – QC-17, QC-27, QC-28, QC-41, QC-44, QC-53;
  source: `quality_defaults.md` § Secrets, § Dependencies; SDD § 4 C-R7, § 6 S-2, S-5)*
- **RN-4:** *(an obligation the SRS states and the harness did not cover)* NFR-4 binds the
  promises "during and after crashes and abnormal exits", and the SDD's harness hashes a fixture
  around a clean run. QC-49 adds a kill mid-churn to `checks/read-only.sh`, because a delivery
  session would otherwise find the crash half of NFR-4 unverified at release. *(re: QC-49; source:
  SRS NFR-4, NFR-9; SDD § 4 C-I3)*
- **RN-5:** *(two product-shaping gaps, drafted and routed)* The SRS binds semantic versioning
  from 1.0.0 to "the product's public contract" and defines that contract nowhere (C-6); and no
  document states what a later version does with an earlier version's own-state (DR-5). Both are
  case-2 silences — two architects could answer differently — so QC-59 and QC-60 carry a draft and
  the owner decides at `docs/architecture_open_issues.md` § 2.1 and § 2.2; the SRS is where each
  lands by revision. *(re: QC-59, QC-60; source: SRS C-6, DR-5; FDR PD-20)*
- **RN-6:** *(the project card)* `system/projects/nozoki/project.md` still carries a provisional
  `pytest` test command and no `Languages:` line, while the SDD's command bar is
  `cargo test --workspace` and the units are Rust and TypeScript. § 8 points at the card as the
  template requires; the card is the PM's to correct. *(re: § 8; source: SDD § 6 S-1)*
- **RN-7:** *(language packets)* The renderer resolves to the TypeScript packet by the units the
  SDD names (`docs/SDD.md` § 3; no `Languages:` line on the card — RN-6). The host and core are
  Rust, for which the organisation's registry has no packet, so their tooling falls to the
  language-agnostic floor and is fixed here: `cargo test` for layers 1–3, `cargo build --locked`
  and `cargo audit` for the tree. Layer 4's browser is Playwright's, not WKWebView, so § 9 splits
  what layer 4 proves (rendering given state) from what layer 5 proves (the bundle). *(re: § 9;
  source: `languages/README.md` § The resolution chain; `languages/typescript/testing.md`;
  ADR-0008)*
- **RN-8:** *(citations outside this repository)* Entries tracing to `quality_defaults.md`,
  `arch_defaults.md`, `testing_doctrine.md` or the TypeScript packet name files of the publishing
  organisation that a reader of this repository cannot open. Each such entry states its rule in
  full, so the trace is provenance and never a dependency — the same resolution
  `docs/CONTENT.md` § CONTENT Review Notes RN-15 records for that document. *(re: QC-26 – QC-32,
  QC-38, QC-53, § 9)*
- **RN-9:** *(two not-applicable declarations)* § 3's identity half and § 7's non-repudiation
  clause are declared not applicable, each with the boundary that makes it true and the change
  that would revoke it; both reach the owner as `docs/architecture_open_issues.md` § 2.3 and § 2.4
  rather than as silent holes. *(re: QC-33, QC-54)*
- **RN-10:** *(what stays out)* The raw-source switch not built (SDD TO-5), the extension set
  (SDD RN-12) and the default branch set (SDD RN-16) are product-visible behaviour the FDR carries
  (PD-11, R-44, R-117) and earn no record or entry here: each is cheap to reverse and a change to
  it is behaviour-visible, which is the FDR's tell. The macOS floor (SDD TO-8) is an entry (QC-56)
  and not a record, because its undo cost is one value and a machine to test on.
