# NFDR — Nozoki 覗き

**Status:** Draft
**Owner:** Principal Architect
**Version:** 11 — the cycle-8 fold (`docs/trail/architecture/cycle-8.md`), and the SDD moved v12 → v13 and the FDR v6 → v8 beneath this document. **The fold:** § 2.1 confirmed — ADR-0011 is Accepted and supersedes ADR-0003, whose Status line is the one line of it that moved; the seven sites that cited ADR-0003 beside QC-25 (QC-2, QC-32, QC-33, QC-35, QC-49, QC-58, and § 2's third trust boundary) read ADR-0011; QC-62 takes the owner's addition — the gate red by construction until the native shell lands, never cleared by an entitlement or by skipping the script; ADR-0012 stays Proposed, revised against C-I3 at v13, its acceptance riding § 2.3 (RN-22). § 2.2 confirmed — nothing lands for it, and its condition ("until the SDD carries the replacement renderer") is now met. **What this document now binds that v10 did not, drafted for the owner's confirm at `docs/architecture_open_issues.md` § 2.3 (RN-22):** `docs/SDD.md` § 10 RC-3 moves the shape and the seams, so four records land at Proposed — ADR-0013 (the sandboxed single-process read pipeline, superseding ADR-0001 on acceptance), ADR-0014 (AppKit in Swift, no web engine, superseding ADR-0002), ADR-0015 (Markdown as a typed document, three walls in one process, superseding ADR-0006), ADR-0016 (the unit set — `nozoki-core`, `nozoki-bridge`, `nozoki-mac`, `checks/` — superseding ADR-0009) — the four superseded records' Status lines untouched until acceptance; and every entry written against the previous shape is re-derived from §§ 2–4 as they read at v13, under the SDD's own rule that the § 4 statement wins: § 1's module set and QC-1, QC-8, QC-9, QC-11, QC-13 – QC-17, QC-19, QC-20; QC-21 (the view replaced once, before any release, and not again); § 2's trust boundaries, QC-22 (the hostile fixture as a `MarkdownDocument`, never HTML), QC-23 (no web engine, in place of the CSP), QC-24 (the bridge's export set, in place of the capability file), QC-26, QC-27, QC-30, QC-34, QC-36, QC-37, QC-41, QC-51, QC-55, QC-58, QC-59, QC-61, and QC-62 (the `idle-shell` control and the `open_folder` observable); § 8 records that the card is owed `Swift` and `swift test`; § 9 is re-derived — `swift test --package-path nozoki-mac` for `nozoki-mac`'s layers 1 and 4, `checks/view.sh` and `--test exports` at layer 6, the shell gate's control at layer 5, Vitest and the TypeScript packet leaving with `nozoki-ui`; § 10 follows. One item is raised: `docs/SDD.md` § 3 leaves unstated which unit invokes `markdown-renderer` and `highlighter` to fill a `FileView` (companion § 1.1). No `QC` is added, renumbered or reused. The tree still holds the previous shape, and every entry naming the new one is red against it until the change that lands the native shell (§ 1, its opening paragraph). Three items await the owner in `docs/architecture_open_issues.md`, so `Status:` is Draft. (v10: the SDD moved v8 → v12 beneath a settled document, and the companion a `companion-self-answer` run opened on that movement (`nozoki@a9f1b8a`) is drafted into the records, its slot the owner's (RN-21). What this document now binds that v9 did not: QC-25 states C-R2's rule — no network entitlement of any kind, the read-only grant, any other entitlement only with a record and only where the probe still finds the wall — in place of *exactly* a list, verified in two halves (`checks/bundle.sh`'s set equality against the set the script expects, and the sandbox probe as before with C-I3's v9 scoping of which lines print the bound; the widening of the script's expected set reviewed as code in the same change against the rule), and QC-62 binds the renderer gate C-I3 gained at v11 — the launched bundle observed inside `open_folder`, read from the process and never from a marker the product writes, its renderer-removed control red, after `checks/bundle.sh` and never instead of it — with a § 10 row and `checks/renderer.sh` in § 9's layer-5 row. Two records land at Proposed: ADR-0011, which restates ADR-0003 whole with the rule in place of the list and supersedes it on acceptance, and ADR-0012, the renderer gate's own record; ADR-0003's Status line and the six entries and one paragraph that cite it beside QC-25 do not move until that acceptance; the index gains the two rows. No record is superseded on the owner's SDD-companion answer that the renderer leaves WKWebView — ADR-0002 and QC-21 stand until the SDD carries the replacement (companion § 2.2). QC-62 is the one new ID; no `QC` is renumbered or reused. Two items await the owner in `docs/architecture_open_issues.md`, so `Status:` is Draft. (v9: the close: the cycle-7 fold (`docs/trail/architecture/cycle-7.md`), three items raised from downstream after the first hosted-runner CI runs, each answered in the owner's seat (RN-20), and the SDD moved v7 → v8 beneath this document on two of them. What this document now binds that v8 did not: QC-3's *verified by* states two halves — `checks/no-network.sh` proving the tree equals the list, and the allowlist change reviewed in the same change against this entry's own domain, in the features the lockfile resolves, with the names already on the list reviewed once by the same question in the change that first realizes the half — where v8 named the diff alone, which cannot fail on a name the list admits; and QC-25's tail is re-derived from `docs/SDD.md` § 4 C-I3 as it reads at v8 — the bounded window with the pass on the first ask where all three hold, the bound the script's and printed, the per-ask check that the pid still names a process, the control answering `sandboxed: no` on every ask for the whole window, an error on any ask failing, the uncovered `yes` → `no` case, and the hosted-runner narrowing under which the read denial separates nothing there — where v8 said the entry asserted nothing about a hosted runner, false since the runner was measured. § 10's QC-3 row gains the review beside the script; QC-25's row does not move. No record lands and none changes status; ADR-0010 takes three in-place prose corrections dated in the record, on the owner's seat's ruling that the window and the narrowing correct it and do not reverse it — the kind of correction the log took at v5 and v6 — and its § Traces to states that provenance; the index is untouched. No `QC` is added, renumbered or reused. Nothing is left for the owner; `docs/architecture_open_issues.md` is removed and `Status:` is Settled. (v8: the close: the cycle-6 fold (`docs/trail/architecture/cycle-6.md`), two items a downstream seat raised after the first code was built, each answered in the owner's seat (RN-19), and the SDD moved v6 → v7 beneath this document on the first of them. What this document now binds that v7 did not: QC-24's grant is staged — a build's capability file grants exactly the commands the host registers, that set always inside SDD § 3 seam 4's closed list and the list whole from `v1.0.0`, no asset scheme granted while SDD § 4 C-R7 carries the `<asset-scheme>` placeholder, the check reading the registered set and never a hand-kept copy, and the pre-`v1.0.0` case the check does not cover named in the entry — re-derived from C-R7 as it reads at v7, where the entry stated the whole list and no build before the last slice could pass it; and `checks/structure.sh` reads shipped sources, stated once in § 9 — the product crates' sources outside `crates/*/tests/`, the one `CARGO_BIN_EXE_` rule that reads that path unchanged — with QC-61's `set_logger` rule carrying the scope in its own tail. No record lands and none changes status; the index is untouched. § 10 is unchanged. No `QC` is added, renumbered or reused. Nothing is left for the owner; `docs/architecture_open_issues.md` is removed and `Status:` is Settled. (v7: the close: the cycle-5 fold (`docs/trail/architecture/cycle-5.md`), three items a downstream seat raised after the first code was built, each answered in the owner's seat (RN-18), and the SDD moved v5 → v6 beneath this document on the first of them. What this document now binds that v6 did not: QC-25's sandbox check reads the operating system's own report on the launched main process — sandboxed, with an out-of-grant file read and an outbound network connection both denied — and carries a no-entitlement negative control that must fail, re-derived from `docs/SDD.md` § 4 C-I3 as it reads at v6, where it read an environment marker measured absent from a sandboxed process; QC-23's string equality is stated in two states keyed on whether SDD § 4 C-R7 still carries the `<asset-scheme>` placeholder, so the check is in force at every build; QC-30's boundary set covers what the shipped process reads whichever crate reads it, held in two halves — the product's own crates by `checks/structure.sh` as before, and the linked dependency tree's environment and argument reads as a reviewed list, `checks/entry-points.allow`, checked by `checks/entry-points.sh`, with a § 10 row — and QC-58 takes the same halves; QC-61's argument is re-pointed to the second half, its conclusion unchanged. One record lands: ADR-0010 supersedes ADR-0008, restating its decision whole with the observable corrected and naming the undocumented `sandbox_check` as what it rests on; ADR-0008's Status line is the only line of it that moved; the index follows, and the live traces in QC-14, QC-25, QC-46, QC-48, QC-49 and § 9 read ADR-0010. The header's sentence that the product *has no code yet* is corrected, false since the first code landed. No `QC` is added, renumbered or reused. Nothing is left for the owner; `docs/architecture_open_issues.md` is removed and `Status:` is Settled. (v6: the close: the cycle-4 fold (`docs/trail/architecture/cycle-4.md`), and two inputs moved beneath a settled document. The owner's two answers are folded (RN-17). § 2.1 → fourteen more `docs/SDD.md` citations the SDD's re-author left on another subject are pinned to `nozoki@70a879a:` — the thirteen the item counted in ADR-0002, ADR-0004, ADR-0005, ADR-0006 and ADR-0009, and ADR-0001's quoted § 1 phrase the answer added — prose edits on the owner's cycle-3 ruling, no record superseded, the index untouched. § 1.1 → the FDR is right: `docs/fdr.md` PD-39, QC-59's third member and QC-60's post-1.0.0 clause stand as written, nothing here moves, and `docs/SDD.md` § 6 S-11 is owed the member through the SDD's own run — no companion opened on it, by the owner's word. The SDD moved v3 → v5 and the FDR v3 → v6 under this document: QC-31 names `fs-reader`'s text rule as the SDD now states it — UTF-16 by byte-order mark beside UTF-8 — where it said *the UTF-8 rule*; QC-59 gains the prerequisite clause `docs/fdr.md` PD-40 prices and traces to PD-40, the FDR's own statement of the priced set, which agrees with this entry on all four members; ADR-0003's and ADR-0005's dated R-21 sentence now diverges from both sources it cites, and RN-12's rule holds unchanged. No `QC` is added, renumbered or reused; no record changes beyond the fourteen pins. Nothing is left for the owner; `docs/architecture_open_issues.md` is removed and `Status:` is Settled. (v5: the cycle-3 fold, under one owner answer, and the SDD re-authored beneath a settled document. The owner's answer to `docs/trail/architecture/cycle-3.md` § 3.1 is folded: the 37 citations in ADR-0001 – ADR-0008 of the deleted SDD's trail and review notes are pinned to `nozoki@70a879a:`, and QC-48's `SDD § 6 S-4` reads `S-5` — prose edits on the owner's ruling, no record superseded (RN-16). The SDD beneath this document is no longer the one v1 – v4 read: it was deleted at `nozoki@9c91359` and re-authored, Settled at v3 (`nozoki@827aa1c`), and this revision re-derives against it as that document's own § 4 rule requires — every trace tag the re-author renumbered is re-pointed (QC-19, QC-21, QC-47, QC-51, QC-53, RN-3, RN-10); § 8's sentence about the card follows S-1's bar, which now carries `--locked` itself; and two of its new sentences bind: C-I6's `checks/contract.sh` gives QC-59's priced members a machine check from `v1.0.0`, with a § 10 row, and C-D3's format list binds the asset handler to four bitmap formats and keeps SVG off the scheme until the mechanism SDD RN-8 states precedes it (QC-37; QC-22 names the PNG). No `QC` is added, renumbered or reused; no record changes beyond the 37 pins. Two items go to the owner and `Status:` is Draft: the re-author moved thirteen further ADR citations the answer's scope did not reach, and the SDD's confirmed 1.0.0 contract prices own-state readability nowhere while `docs/fdr.md` PD-39 and QC-59 do (`docs/architecture_open_issues.md` § 2.1, § 1.1). (v4: the close: the re-opened companion's five answers folded (`docs/trail/architecture/cycle-2.md`), all five in the owner's seat by two `companion-self-answer` runs (RN-15). What this document now binds that v3 did not: the logging facade is `log`, implemented by `nozoki-app`'s own writer installed once at the composition root — no third-party implementation and no `tracing` — held by a machine check on the allowlist and on `log::set_logger` (QC-61, with a § 10 row); every `cargo test` command in § 9, § 10 and the entries' tails carries `--locked`, following the Rust packet where v3 had neither followed it nor recorded a departure (RN-7); and § 9 fixes that layer 5 stays outside `cargo test`, which is why the card's `cargo test --workspace --locked` is this product's change-time run against the packet's release-time classification — the condition that would flip it named and checked (RN-7 departure (1)). § 8's sentence about the card is true again — the card's command satisfies the S-1 bar and adds the packet's flag — and RN-6's pinned history gains the card's third and fourth commits. The v3 drafts on § 9's preamble, its `crates/` paths, RN-7 and RN-6 are confirmed and stand. The `testing_doctrine.md` cite moves to v2.2.0 under no answer (RN-15). QC-61 is the one new ID; no obligation is removed or renumbered; no record changes. Nothing is left for the owner; `docs/architecture_open_issues.md` is removed and `Status:` is Settled. (v3: an input moved underneath a settled document, and the companion is re-opened on it: the organisation's language registry gained a Rust packet on 2026-09-02 (`kensaiapp-dev@d628f75c`; its placement ruling `kensaiapp-dev@49e0444f`), and three statements here that no such packet existed are false. This revision applies the two drafts the re-opened companion carries, awaiting the owner's confirmation (`docs/architecture_open_issues.md` § 2.1, § 2.2): § 9's preamble and RN-7 read Rust tooling as the packet's, with what this product fixes differently and why; § 9's Rust test paths move under `crates/`, the placement the owner ruled for every Rust product here; RN-6 and § 8 record the project card's two closes — the two-toolchain test command (`kensaiapp-opensource@c2155cc`) and the `Languages:` line (`kensaiapp-opensource@0af5fb9`) — as history pinned to `kensaiapp-opensource@4bdfddd`. One question stays open and no entry moves for it: the packet requires the binary crate to select a logging facade, `log` or `tracing`, and leaves the choice to this document (§ 1.1 of the companion); RN-14 names what waits on it. No obligation is added, removed or renumbered; no record changes — ADR-0009 names its crates by name and fixes no directory. `Status:` is Draft because a companion is on disk, and this document is Settled only when none is. (v2: the close: the owner's cycle-1 answers folded (`docs/trail/architecture/cycle-1.md`), ten of its eleven items, and the eleventh settled by derivation from the FDR at v3 (RN-11, RN-12). What this document now binds that v1 did not: a critical advisory blocks release with **no remediation window** — none, not undecided — and `cargo audit` gates every advisory with a reasoned ignore by id (QC-27); the secrets scan is `gitleaks git` (QC-28); QC-33's revocation clause names identity alone; the diagnostic log's bound is the SRS's — one session's lines, 1 MiB on disk, a failed write surfacing nowhere — and own-state retention follows the FDR's R-110 and R-178 – R-182, so QC-40 is a machine check with a § 10 row; the public contract's breaking/additive split (QC-59); own-state read whole or discarded whole, symmetric, silent, never a startup failure (QC-60). ADR-0009 is Accepted. RN-2 is corrected as history, RN-3, RN-4, RN-5 and RN-9 close on the trail, and the upstream moves since v1 read its sources are measured and recorded (RN-13). Nothing is left for the owner; `docs/architecture_open_issues.md` is removed and `Status:` is Settled. (v1: the constraint set stated for the first time, over the settled SDD and SRS with the FDR beside them: the module set and its import graph, the read-only and no-network invariants as machine checks, the three walls around rendered content, the release and sandbox gates, and the test-strategy realization for a Rust host with a TypeScript renderer; nine items parked for the owner.))))))))))
**Inputs read:** SRS Settled · SDD Draft · FDR Settled · PRD Settled · UXD Settled · DESIGN Settled · CONTENT Settled

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
> `testing_doctrine.md` v2.2.0 or the Rust packet (`languages/rust/`, `testing.md` v1.0.1,
> `layout.md` v1.1.0, `errors_logging.md` v1.1.0, `quality_gates.md` v1.1.0, `toolchain.md`
> v1.1.1) names an engineering-doctrine file of
> the organisation that publishes this product, which is not in this repository; every such entry
> states the rule in full here, so the trace is provenance and never a dependency. Every command
> named below is one the SDD names, or one this document names as its own realization and says so
> in § NFDR Review Notes. Not every one exists yet: each becomes executable in the change that
> lands its script, and until then the gate is `development-design` reading the entry.

---

## 1. Structural integrity

The physical module set is ADR-0016's — Proposed, superseding ADR-0009 on acceptance; this
section is re-derived from `docs/SDD.md` § 3 as it reads at v13 under that document's own rule
that the § 4 statement wins, and its entries trace to both records until the owner's confirm
(RN-22): `nozoki-core` (`crates/nozoki-core`, Rust library — `fs-reader`, `git-reader` with the
Git port, `watcher`, `folder-model`, `own-state`, `markdown-renderer`, `highlighter`),
`nozoki-bridge` (`crates/nozoki-bridge`, Rust static library — `core-bridge`: the C ABI and the
Rust-side composition root), `nozoki-mac` (a Swift package — `mac-shell`, `surfaces`), and
`checks/` (build-time, not shipped). Part names are the SDD's (`docs/SDD.md` § 3); the Rust module
spelling of each is the developer's. **The tree as this revision is written still holds the
previous shape** — `crates/nozoki-app` and `nozoki-ui` (`ls`, 2026-09-23) — so every entry below
that names `nozoki-bridge` or `nozoki-mac` is red against it until the change that lands the native
shell. That is the correct reading, not a defect of this revision: the entries follow the SDD, and
the tree follows the entries (RN-22).

### 1.1 Architectural invariants

- **QC-1:** `nozoki-mac` holds no I/O of its own — no filesystem read, no network, no spawned
  process, no URL handed to another program, no web engine — and its only channel to the core is
  `SM-4`'s exported function list, read through the generated header. The seam is where the promise
  is read, not where it is held: the wall is the process's entitlements (QC-25), and this entry is
  a source scan and a link check on every build, not a process boundary.
  — *verified by:* `checks/view.sh` (test layer 6) over `nozoki-mac/Sources` and the built
  executable (QC-34); the bridge's export set (QC-24); `checks/no-network.sh` *(traces to:
  ADR-0013 — Proposed, superseding ADR-0001 on acceptance; ADR-0001; ADR-0014 — Proposed; SDD § 3
  SM-4; § 4 C-R7; re-derived at v11 — RN-22)*
- **QC-2:** No code path in any shipped unit opens a file under the granted folder for writing,
  creates, renames or removes an entry there, or creates a lock file in `.git`.
  — *verified by:* `checks/read-only.sh <fixture>` prints `unchanged` on every fixture after every
  IPC command, `.git` hashed where present (test layer 3); structural check (layer 6):
  `checks/structure.sh` rule *no write API in `nozoki-core` outside `own-state`* *(traces to:
  SRS NFR-5, NFR-6, C-2; ADR-0001; ADR-0011)*
- **QC-3:** No shipped unit links a network transport: libgit2 is built without its HTTPS and SSH
  transports, and every crate and package the bundle contains is named in `checks/deps.allow`.
  — *verified by:* two halves, and the entry holds only with both. **(1) The tree equals the
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
  this half was stated (218 cargo and 163 pnpm, `bash checks/no-network.sh` at `nozoki@9b36a42`;
  the pnpm names leave the list with `nozoki-ui`, SDD § 10 RC-3)
  passed the diff and were never reviewed against the domain: the change that first realizes this
  half reviews them once, by the same question, and records that review as code in the same
  change — after it, every name on the list has passed one review or the other. No command judges
  whether a name is a transport, which is why the second half is a review gate at a named moment
  and says so here *(traces to: SDD § 4 C-R6 — "no shipped unit links a network transport", the
  allowlist change "reviewed in the same change"; § 4 C-I3 — `no-network.sh` failing on a Swift
  dependency; SRS NFR-8; ADR-0004; QC-26; the second half
  stated on the answer at `docs/trail/architecture/cycle-7.md` § 3.1 — RN-20)*
- **QC-4:** Every read the model holds is an item carrying an `ItemState` — `pending`, `observed`,
  `failed(condition)` or `stopped` — and no surface draws a marker, a count or a "nothing changed"
  from an item that is not `observed`.
  — *verified by:* unit tests on the reducer (layer 1): every read path yields a state;
  `swift test --package-path nozoki-mac` (layer 4): a projection with a `pending` item renders
  the word *pending* and no marker *(traces
  to: SDD § 3 ItemState; § 4 C-I1, C-E1; SRS NFR-3; FDR R-19, R-36, R-94)*
- **QC-5:** The root finding never answers with a path above the granted folder; on `plain` the
  model holds no `GitState`, every Git-derived projection is empty, and the tree carries no marker.
  — *verified by:* `cargo test --locked -p nozoki-core --test root_finding` over the plain,
  inside-a-repository, parent-of-two, linked-worktree and submodule fixtures (layer 2) *(traces to:
  ADR-0005; SRS FR-33, FR-34, AC-24, AC-25)*
- **QC-6:** Every path derived from content or from outside — a tree entry, a symlink target, a
  Markdown image reference, a relative link, an `asset_bytes` call — passes `fs-reader`'s
  containment check on the canonical path, symlinks resolved and after decoding, before any open;
  `asset_bytes` re-runs it on every call, and the check has one implementation its two callers do
  not re-implement.
  — *verified by:* `cargo test --locked -p nozoki-core --test markdown` — the `..` and symlink-out fixtures
  yield a placeholder node and `asset_bytes` refuses them (layer 2); unit tests on the check
  (layer 1) *(traces to: ADR-0015 — Proposed, superseding ADR-0006 on acceptance; ADR-0006; SDD
  § 3 `fs-reader`, SM-7; § 4 C-D3; § 11 R-10; FDR R-34, R-59, R-62)*
- **QC-7:** `git-reader` makes no mutating call — no checkout, index write, ref update or lock
  file — and spawns no process; every port method is read-only.
  — *verified by:* `checks/read-only.sh` on the Git fixtures with `.git/index` hashed (layer 3);
  `checks/structure.sh` rule *no `std::process` in any shipped crate* (layer 6) *(traces to:
  ADR-0004; SRS NFR-6, AC-2; SDD § 3 `git-reader` "Must not own")*

### 1.2 Forbidden imports

One graph, both halves stated. "May import" is the whole allowed set; "must not import" is stated
explicitly and never inferred.

- **QC-8:** `nozoki-mac` may import AppKit and Foundation — the platform's own — and its own
  modules, and it links `libnozoki_bridge.a` through the generated header. It **must not** declare
  a package dependency (`Package.swift` declares none; no `Package.resolved` exists), **must not
  import** `WebKit` or `JavaScriptCore`, and `surfaces` **must not** reach the bridge — a surface
  hands `mac-shell` an intent and never calls `SM-4`.
  — *verified by:* `checks/view.sh` (layer 6): the forbidden-symbol scan over `nozoki-mac/Sources`
  and `otool -L` on the built executable naming neither `WebKit` nor `JavaScriptCore`;
  `checks/no-network.sh` — no Swift dependency, no `Package.resolved`; `swift test --package-path
  nozoki-mac` — the shell issues no call `SM-4` does not name (SDD § 6 S-1) *(traces to:
  ADR-0013 — Proposed; ADR-0001; ADR-0014 — Proposed; ADR-0016 — Proposed, superseding ADR-0009 on
  acceptance; ADR-0009; SDD § 3 `mac-shell` and `surfaces` "Must not own", SM-8; § 4 C-R6, C-R7;
  re-derived at v11 — RN-22)*
- **QC-9:** `nozoki-core` **must not import** any Apple framework or a binding to one, any crate
  outside `checks/deps.allow`, or `std::process`, and **holds no `unsafe`** — the workspace forbids
  it, and only `nozoki-bridge`'s manifest relaxes it.
  — *verified by:* `checks/no-network.sh`; `checks/structure.sh` (layer 6) — the imports, and
  `unsafe` appearing in no crate but `nozoki-bridge`; `cargo build --workspace --locked` under
  `[workspace.lints.rust] unsafe_code = "forbid"`, a build failure on an `unsafe` block in any
  crate whose manifest does not relax it *(traces to: ADR-0013 — Proposed; ADR-0001; ADR-0016 —
  Proposed; ADR-0009; SDD § 3, the units paragraph; § 4 C-R6; `Cargo.toml`
  `[workspace.lints.rust]`; re-derived at v11 — RN-22)*
- **QC-10:** `folder-model` may import `fs-reader`, the Git port trait, and `watcher`. It **must
  not import** the libgit2 binding, `git-reader`'s adapter, `own-state`, or `markdown-renderer`.
  Which unit invokes `markdown-renderer` and `highlighter` to fill a `FileView` is unstated in SDD
  § 3 as it reads at v13, and is raised on the companion, not decided here (RN-22).
  — *verified by:* `checks/structure.sh` (layer 6) *(traces to: ADR-0004; ADR-0016 — Proposed;
  ADR-0009; SDD § 3
  `folder-model` "Must not own"; `arch_defaults.md` § Dependency Graph Rules)*
- **QC-11:** `fs-reader`, `git-reader`, `watcher`, `highlighter` and `markdown-renderer` **must not
  import** `folder-model`, `own-state`, or one another — with two stated edges: `markdown-renderer`
  imports `fs-reader`'s containment check, and `highlighter` for a fenced block's spans. Only
  `git-reader` imports the libgit2 binding.
  — *verified by:* `checks/structure.sh` (layer 6) *(traces to: ADR-0004; ADR-0015 — Proposed;
  ADR-0006; ADR-0016 — Proposed; ADR-0009; SDD § 3, the units paragraph's two stated edges, the
  `markdown-renderer` and `highlighter` rows; re-derived at v11 — RN-22)*
- **QC-12:** `own-state` **must not import** `fs-reader`, `git-reader`, `watcher`, `folder-model`
  or `markdown-renderer`; it reads and writes only inside the app's container.
  — *verified by:* `checks/structure.sh` (layer 6); `checks/own-state.sh` (layer 5) *(traces to:
  ADR-0016 — Proposed; ADR-0009; SDD § 3 `own-state`; § 4 C-D2)*
- **QC-13:** `nozoki-bridge` may import `nozoki-core` and the standard library. It **must not
  import** any Apple framework or `std::fs` outside its log writer, and holds no read logic: every
  exported function decodes its arguments, calls `folder-model`, and returns plain data as an
  owned buffer freed by `nozoki_free`. It is the one unit that holds `unsafe`, relaxed in its own
  manifest with the reason recorded; every function catches a panic at the boundary and returns a
  failure value; the header is generated from its source and never hand-edited.
  — *verified by:* `checks/structure.sh` (layer 6) for the imports; `cargo test --locked -p
  nozoki-bridge --test exports` — the header declares what the library exports and nothing else
  (QC-24); the bridge's tests under `-Zsanitizer=address` in CI on every build (layer 2); review at
  `development-design` for the delegation rule — what counts as logic is not greppable, and the
  import rule is the part that is *(traces to: ADR-0014 — Proposed, superseding ADR-0002 on
  acceptance; ADR-0002; ADR-0016 — Proposed; ADR-0009; SDD § 3 `core-bridge` "Owns" and "Must not
  own", SM-4; § 4 C-I2; § 11 R-13; `arch_defaults.md` § Application Layer; re-derived at v11 —
  RN-22)*
- **QC-14:** `checks/` may import `nozoki-core` and is **never a dependency** of `nozoki-core`,
  `nozoki-bridge` or `nozoki-mac`, and never ships in the bundle.
  — *verified by:* `cargo tree -p nozoki-bridge` names no `checks` crate; `checks/structure.sh`
  (layer 6); `checks/bundle.sh` — nothing of `checks/` under `Contents/` (layer 5) *(traces to:
  ADR-0010; ADR-0016 — Proposed; ADR-0009; SDD § 3 `read-only-harness` "Must not own")*

### 1.3 Layer isolation

- **QC-15:** I/O ownership is fixed: folder reads are `fs-reader`'s (bytes, listings) and
  `git-reader`'s (Git's on-disk state through libgit2); change notifications are `watcher`'s
  (FSEvents); the diagnostic log writer is `nozoki-bridge`'s; the Open panel and the one window
  are `mac-shell`'s, in `nozoki-mac`; drawing is `surfaces`', in `nozoki-mac`, which holds no I/O
  of its own; **no unit owns a socket and no unit spawns a process.**
  — *verified by:* `checks/structure.sh` (layer 6): each Rust I/O primitive appears only in its
  owner; `checks/view.sh` (layer 6): no I/O primitive in `nozoki-mac/Sources` at all *(traces to:
  ADR-0013 — Proposed; ADR-0001; ADR-0016 — Proposed; ADR-0009; SDD § 3 parts table; § 4 C-R7)*
- **QC-16:** The only writes the product performs are `own-state`'s and the bridge's diagnostic
  log, both inside `~/Library/Containers/com.kensaiapp.nozoki/`.
  — *verified by:* `checks/own-state.sh` — after a session every changed file under `$HOME` is
  under the container and none under the fixture (layer 5) *(traces to: SDD § 4 C-D2, C-I2; SRS
  FR-21, AC-13; ADR-0013 — Proposed; ADR-0001)*
- **QC-17:** Two composition roots, one per language, and each is the single place its runtime is
  touched: `nozoki-bridge` is the Rust-side root — the only place the libgit2 adapter is wired to
  the Git port and the only place the log writer is installed; `mac-shell` in `nozoki-mac` is the
  app's root — the only place `NSApplication` and the one window are created and the only place
  `SM-4` is called.
  — *verified by:* `checks/structure.sh` (layer 6): the adapter's constructor and `log::set_logger`
  / `log::set_boxed_logger` appear only under `crates/nozoki-bridge/src/`; `checks/view.sh`
  (layer 6): a `nozoki_` symbol the header declares is called from `mac-shell`'s sources and from
  no file of `surfaces` — a rule this document adds to the script (RN-22) *(traces to: ADR-0014 —
  Proposed; ADR-0002; ADR-0016 — Proposed; ADR-0009; SDD § 3 `core-bridge`, `mac-shell`, SM-8;
  `arch_defaults.md` § Composition Root; re-derived at v11 — RN-22)*

### 1.4 Replaceability

- **QC-18:** Swapping the Git mechanism — libgit2 for the installed `git` run with
  `--no-optional-locks` — touches `git-reader` (the adapter) and `nozoki-bridge`'s wiring only; the
  port, the model and the surfaces do not change.
  — *verified by:* review at `development-design` when a change touches `git-reader`; the port's
  contract tests (QC-50) pass unchanged against the new adapter *(traces to: FDR PD-29; SRS § 5.3;
  ADR-0004)*
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
  and the bridge's log writer *(traces to: SDD § 3 SM-6; ADR-0016 — Proposed; ADR-0009)*
- **QC-21:** No swap invariant is held for the platform or for the view technology. The platform
  is not replaceable inside the terminus. The view technology was replaced **once, before any
  public release** — from the system WKWebView to AppKit in Swift, on the owner's ruling
  (ADR-0014, Proposed, superseding ADR-0002 on acceptance) — and is not replaceable again inside
  the terminus; reversing it now costs what ADR-0014 states, every surface rewritten. A change that
  claims either is cheap to replace is wrong, and a second swap of the view is a change that
  contradicts `docs/fdr.md` PD-29 and goes to the owner, never a design call inside a change.
  — *verified by:* review at `development-design` — a stated non-invariant has nothing to run
  *(traces to: FDR PD-29 as it reads at v8 — the owner's confirm at `docs/trail/fdr/cycle-5.md`
  § 2.1; SDD § 2 force 4, "Undoing it", § 9 TO-4, § 10 RC-3; ADR-0014 — Proposed; ADR-0002;
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
  case; ADR-0015 — Proposed, superseding ADR-0006 on acceptance; ADR-0006; re-derived at v11 —
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
  any kind", C-R7; § 10 RC-3; ADR-0014 — Proposed, superseding ADR-0002 on acceptance; ADR-0002;
  ADR-0015 — Proposed; the two-state form this entry carried through v10 was answered in the
  owner's seat at `docs/trail/architecture/cycle-5.md` § 3.2 — RN-18 — and is history; re-derived
  at v11 — RN-22)*
- **QC-24:** A build exports to the shell exactly the functions its landed slices built — set
  equality between the C symbols `libnozoki_bridge.a` exports (`nm -gU`, the `nozoki_` prefix) and
  the functions the generated header declares — and that set is always inside the closed list
  `docs/SDD.md` § 3 `SM-4` names: `open_folder`, `list_tree`, `select_file`, `open_relative_link`,
  `set_theme`, `open_diff`, `walk_history`, `switch_folder`, `asset_bytes`. No function is exported
  before a slice lands it, and from `v1.0.0` the set is that list whole. The header is generated
  from the bridge's source and never hand-kept; the test reads the exported set and never a
  hand-kept copy of it, and an exported set it cannot read fails the test — never a pass.
  **Not covered before `v1.0.0`, and named so it is not read as coverage:** a change that stops
  exporting a function an earlier slice built passes this check, because the export and the
  header move together; until QC-59's pin exists, only that slice's own bar holds the function.
  — *verified by:* `cargo test --locked -p nozoki-bridge --test exports` (layer 2), holding two
  things: set equality between the exported symbols and the header's declarations, and that set
  inside the list above. From `v1.0.0` the whole list is held by QC-59's pin, which reads `SM-4`'s
  function list as the bridge exports it *(traces to: SDD § 3 SM-4; § 4 C-R7 as it reads at v13;
  § 4 C-I6; § 11 R-12; § SDD Review Notes RN-47, RN-60; ADR-0013 — Proposed, superseding ADR-0001
  on acceptance; ADR-0001; QC-59; the staged form answered in the owner's seat at
  `docs/trail/architecture/cycle-6.md` § 3.1 — RN-19 — carried from the capability file to the
  export set at v11 — RN-22)*
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
  Nozoki.app` equals the set the script expects (`checks/bundle.sh:L127-L128`; the two v1
  entitlements today), every value boolean true; an entitlement the bundle carries that the script
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
  observed **inside `open_folder`'s call** — the shell's first and only unconditional act,
  presenting the Open panel at launch — within a bounded window, and the observation is the
  operating system's or the process's own report: never a marker the product writes for the check,
  never an environment variable, never a code path that exists for the gate. The gate's negative
  control — `checks/fixtures/idle-shell`, a bundle the harness owns: an AppKit executable that
  opens one window and never presents the panel, signed and entitled as the product is — goes red.
  **Until the native shell lands, this gate is red by construction, and that red is the gate
  working:** under C-R2's rule no bundle built from the previous shape reaches `open_folder`
  (SDD § 10 RC-2); the red is never cleared by granting an entitlement or by skipping the script,
  and `checks/renderer.sh` and its control land with the native shell or after it.
  — *verified by:* `checks/renderer.sh Nozoki.app` and its `idle-shell` control (layer 5) — the
  script fixes the mechanism it reads and the bound, and prints the bound the way
  `checks/bundle.sh` does; the frames the native shell shows inside `open_folder`'s call are
  re-measured on the first slice's first native bundle and fixed from it (the mechanism measured
  on one Mac for the previous renderer was a thread sample showing `pick_folder → run_on_main`).
  Neither the script nor the control is in the tree yet (`ls checks/`, 2026-09-23), and each
  becomes executable in the change that lands it with the native shell; until then the gate is
  `development-design` reading this entry. Not covered, and named so it is not read as coverage:
  whether the observation reads the same on a GitHub-hosted runner (SDD § Open Questions, last
  item) *(traces to: SDD § 4 C-I3 at v13 — "The shell's run is proved on the shipped bundle,
  beside the wall" and its *Violated by*; § 3 `read-only-harness`; § 5 step 4 E-1; § 6 S-1, command
  half; § 10 RC-2, RC-3; § Open Questions, last item; § SDD Review Notes RN-52, RN-60, RN-61; the
  owner's ruling at `docs/trail/sdd/cycle-8.md` § 5.1, answer 4; ADR-0012 — Proposed, revised at
  v11 against C-I3 at v13; SRS § 8 AC-10, the manual walk this gate precedes; added at v10 —
  RN-21; the owner's addition confirmed at `docs/trail/architecture/cycle-8.md` § 2.1, and the
  mechanism and the control re-derived at v11 — RN-22)*
- **QC-26:** Every dependency is deliberate: `Cargo.lock` is committed and CI builds with
  `cargo build --locked`; `nozoki-mac/Package.swift` declares no dependency and no
  `Package.resolved` exists — the view brings nothing to the tree; and a lockfile diff that adds a
  name outside `checks/deps.allow` fails the build until the allowlist change is reviewed as code
  in the same change.
  — *verified by:* `checks/no-network.sh` (the tree) — non-zero on a name outside the allowlist, on
  a Swift dependency declared, or on a `Package.resolved` present; the lockfile diff at
  `development-design` (the change) *(traces to: SDD § 4 C-R6, C-I3; `quality_defaults.md`
  § Dependencies; `languages/rust/toolchain.md` § Adding, pinning and locking a dependency;
  ADR-0004; ADR-0014 — Proposed; re-derived at v11 — RN-22)*
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
  on that side to audit (SDD § 4 C-R6); `pnpm audit` leaves with `nozoki-ui` (RN-22) *(traces to:
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
  (files, entries, `.git`); FSEvents for that folder; the renderer's IPC commands and asset
  requests; the product's own files in its container; and the environment and argument reads of
  the linked dependency tree, each named in `checks/entry-points.allow`. The set covers what the
  shipped process reads, whichever crate holds the line that reads it — an adopter runs one
  process. It is held in two halves. **(1) The product's own units** — `nozoki-core`,
  `nozoki-bridge` and `nozoki-mac` — read no argument vector, no environment variable and no
  configuration file, and open no socket. **(2) The linked dependency tree** — every environment or
  argument read in the crates `cargo tree -p nozoki-bridge --target aarch64-apple-darwin -e normal
  --locked` resolves is a named member of the set: one line in `checks/entry-points.allow` per
  crate and name, each with
  what the read changes. A read not on the list fails the build until the list change is reviewed
  as code in the same change, the way `checks/deps.allow` is (QC-26); whether a given read is
  acceptable is decided at that review, by a person. **What the set does not reach:** reads made
  by the operating system's own frameworks inside the process. They are the platform's, no
  lockfile names them, and the sandbox (QC-25) is what bounds them.
  — *verified by:* half (1) — `checks/structure.sh` (layer 6): no `std::env::args`,
  `std::env::var`, socket or config-file read in the product's own crates; `checks/view.sh`
  (layer 6): no `CommandLine.arguments`, `ProcessInfo.processInfo.arguments` or
  `ProcessInfo.processInfo.environment` read in `nozoki-mac/Sources` — three names this document
  adds to C-R7's scan to realize C-R3's *Violated by* (RN-22). Half (2) —
  `checks/entry-points.sh` (layer 6): for every crate the `cargo tree` command above names, a scan
  of the crate's whole package directory in the Cargo registry — its root `build.rs` excepted —
  for `env::var`, `env::var_os`, `env::vars`, `env::vars_os`, `env::args` and `env::args_os`,
  diffed against `checks/entry-points.allow`; non-zero on a read not listed, on a listed line no
  longer found, and on any resolved crate whose sources it cannot open — a crate it cannot scan
  is a failure, never a pass. The scan covers the package directory and not `src/`, because a
  crate need not keep its sources there (RN-18). Review at `development-design` when a change adds
  an entry point — a scanner finds a new read or a new socket, not a new trust assumption *(traces
  to: `quality_defaults.md` § The boundary set; SRS NFR-14, FR-1; FDR R-2; SDD § 4 C-R3 *Violated
  by*, C-R7; ADR-0013 — Proposed; ADR-0001; the two
  halves answered in the owner's seat at `docs/trail/architecture/cycle-5.md` § 3.3; the script,
  the list format and the measurement behind them are this document's — RN-18)*
- **QC-31:** Every value entering from outside is validated at the boundary it enters through
  before it reaches the model: a path by the containment check (QC-6), a decoded file by
  `fs-reader`'s text rule — UTF-8 with or without its byte-order mark, or UTF-16 by its mark;
  nothing detected from content and no third encoding — a Git answer by the port's plain-data
  contract.
  — *verified by:* review at `development-design` against the entry points the change touches —
  no machine check tells a real validation from a truthy test; the path half is QC-6's machine
  check *(traces to: `quality_defaults.md` § Input at the boundary; SRS DR-6, FR-10; SDD § 3
  `fs-reader`; FDR R-46, R-154; ADR-0006; the rule's second encoding read at SDD v5 — RN-17)*
- **QC-32:** The set of destinations the product connects to is empty.
  — *verified by:* network monitoring across a full session shows zero outbound traffic
  (`docs/SRS.md` AC-3, the release); `checks/no-network.sh` (the tree); the absent network
  entitlement (QC-25) *(traces to: SRS NFR-7, NFR-8, AC-3; `quality_defaults.md` § The boundary
  set; ADR-0013 — Proposed; ADR-0001; ADR-0011)*

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
  — *verified by:* `checks/view.sh` (layer 6) — the forbidden set scanned over `nozoki-mac/Sources`:
  `WKWebView`, `WebView`, `JSContext`, `NSAttributedString` initialised from HTML or with the
  `.html` document type, `URLSession`, `NSURLConnection`, `Process`, `NSWorkspace.open`,
  `NSSharingService`, `FileManager` reads, `Data(contentsOf:)`, `String(contentsOf:)`, `dlopen`,
  and `Bundle.main` reads outside `Contents/Resources`; and `otool -L` on the built executable. The
  scan is the check and C-R7's first sentence is the rule: a shell that reads a file, opens a
  connection or spawns a process by an API the scan does not name is a violation, caught at
  `development-design` and added to the scan in the same change; `checks/no-network.sh` *(traces
  to: SDD § 4 C-R7 — the forbidden set and its *Violated by*; § 3 SM-4; ADR-0013 — Proposed;
  ADR-0001; `quality_defaults.md` § Capability; re-derived at v11 — RN-22)*
- **QC-35:** The product reads nothing outside the granted folder and its own container, and
  writes nothing outside the container.
  — *verified by:* `checks/own-state.sh` and `checks/read-only.sh` (layer 5); the sandbox grant
  (QC-25) *(traces to: FDR R-101, R-102; SDD § 4 C-D1, C-D2; ADR-0011)*
- **QC-36:** No unit spawns a process: no `std::process` in any shipped crate, and no `Process`
  in `nozoki-mac/Sources`.
  — *verified by:* `checks/structure.sh` (layer 6); `checks/view.sh` (layer 6) *(traces to: SDD
  § 3 `git-reader` "Must not own", `mac-shell` "Must not own"; § 4 C-R7; ADR-0004; ADR-0013 —
  Proposed; re-derived at v11 — RN-22)*
- **QC-37:** `asset_bytes` returns bytes read-only, only for a path the containment check passes
  and only for the four bitmap formats `docs/SDD.md` § 4 C-D3 names — PNG, JPEG, GIF and WebP —
  and refuses any other request; the shell decodes an image from bytes `asset_bytes` returned and
  from nothing else, with the platform's own decoder. An in-folder SVG is not returned and takes the
  placeholder stating that its format is one the tool does not render; SVG reaches the decoder only
  after C-D3's format list moves on the evidence SDD RN-8 names, never by an `asset_bytes` edit
  alone.
  — *verified by:* `cargo test --locked -p nozoki-core --test markdown` — `asset_bytes` returns the
  in-folder PNG's bytes for its path and a refusal for the in-folder SVG and for each escaping
  path, on a second call with the same inputs (layer 2); `swift test --package-path nozoki-mac` — a
  *resolved* image node is drawn from the bytes `asset_bytes` returned and a placeholder node from
  no bytes at all (layer 4) *(traces to: SDD § 3 `core-bridge`, SM-7; § 4 C-D3; § 6 S-3, command
  half; § SDD Review Notes RN-8; ADR-0015 — Proposed, superseding ADR-0006 on acceptance; ADR-0006;
  the format clause added at v5 on the re-authored SDD — RN-16; re-derived at v11 — RN-22)*

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
  `failed` on that item and `observed` on its siblings (layer 2); `swift test --package-path
  nozoki-mac` (layer 4): the failure slot renders and the rest of the surface stands *(traces to: SRS NFR-3; SDD § 4 C-I1, C-E3;
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
  seam 2; § 11 R-1; ADR-0004; QC-18)*

## 7. Observability & monitoring

- **QC-51:** A failure the user must know about is visible in the product's own window, in the
  failure slot of the item that stopped, with an enabled route out on the same surface; no
  modal, toast, dialog or terminal line carries a failure.
  — *verified by:* `swift test --package-path nozoki-mac` (layer 4): a `failed` and a `stopped`
  projection each render in the item's slot with the route present; `checks/view.sh` — no
  `NSAlert`, no user-notification API and no modal presentation in `nozoki-mac/Sources` (layer 6;
  the symbols the script names are this document's realization of `surfaces`' "Must not own" —
  RN-22) *(traces to: SRS NFR-11; SDD § 3 `surfaces` "Must not own"; § 4 C-E3, C-I1; FDR R-86,
  R-87, R-90, R-91)*
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
  SDD § 4 C-I2; SRS NFR-11; FDR PD-32; QC-17, QC-30, QC-39, QC-52, QC-58; ADR-0016 — Proposed,
  § Decision; ADR-0009 § Decision;
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
test command is the SDD's command bar for the Rust workspace — `cargo test --workspace --locked`
exits 0 (`docs/SDD.md` § 6 S-1), the bar carrying the Rust packet's `--locked` itself since the
SDD's re-author (`languages/rust/testing.md` § Layers 1–5; RN-16) — and Vitest for `nozoki-ui`;
its `Languages:` line names Rust, TypeScript and Shell (RN-6). **The card is owed a move this
document does not make:** the SDD at v13 retires `nozoki-ui` and names the card's `Languages:`
line as owed `Swift` in place of `TypeScript`, and its test command the `swift test
--package-path nozoki-mac` half in place of Vitest (`docs/SDD.md` § 3, the Swift-frame paragraph;
§ SDD Review Notes RN-60) — the managing instance's field, not this document's to edit; § 8 states
the card as it reads at `kensaiapp-opensource@3a960a7` and goes false at the card's next move until
RN-6 is extended (RN-22). Why the workspace form is this product's change-time run, where the
packet classifies it as release-time, is RN-7. What follows exceeds the card.

- **QC-55:** The product is one macOS application bundle, `Nozoki.app`, bundle identifier
  `com.kensaiapp.nozoki`, and one process; no second binary, no second process the product starts,
  no prerequisite, no runtime install, no fetched asset, and no font shipped — the fonts are the
  platform's.
  — *verified by:* `checks/bundle.sh` — one executable under `Contents/MacOS`, the fourteen icons
  under `Contents/Resources`, and no second executable and no font anywhere under `Contents/`
  (layer 5) *(traces to: SDD § 4 C-R1 as it reads at v13; § 3 "Two libraries, one executable, one
  bundle"; SRS C-3; FDR R-131, PD-15, PD-28; ADR-0014 — Proposed, superseding ADR-0002 on
  acceptance; ADR-0002; re-derived at v11 — RN-22)*
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
- **QC-58:** The product offers no configuration surface: its own units — the two crates and
  `nozoki-mac` — read no configuration file, no environment variable and no argument, and the only
  input the product requires is the folder chosen in the Open panel. What the linked dependency tree reads from the environment or
  the argument vector is not a surface the product offers: it is the named list QC-30's second
  half holds, and no read enters that list unreviewed.
  — *verified by:* `checks/structure.sh`, `checks/view.sh` and `checks/entry-points.sh`
  (layer 6), the same rules as QC-30; `docs/SRS.md` AC-9 at release *(traces to: SRS NFR-14, FR-1,
  AC-9; FDR R-2; SDD § 4 C-R3; ADR-0011; the two halves follow QC-30 — `docs/trail/architecture/cycle-5.md` § 3.3, RN-18)*
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
  `LSMinimumSystemVersion` prints it, the release's asset names and `SM-4`'s function list as the
  bridge exports it — fails on a tag inside a major whose bundle raises the floor, drops an asset
  or drops a function (the release; layer 5): the machine check for the install path, the floor and the
  surfaces' presence; own-state readability is QC-60's check. The behaviour member has no machine
  check — no test reads the FDR — and stays a review gate: review at `development-specs` — a change
  spec names which of the four it touches and whether the change is breaking or additive, and the
  version bump follows; release inspection reads the version against the change set
  (`docs/SRS.md` AC-14). Before `v1.0.0` there is no pin and the script is not run — C-6's
  pre-1.0.0 half, stated rather than tested *(traces to: SRS C-6; FDR R-142, PD-20, PD-40 — the
  FDR's statement of the priced set since its v4, the prerequisite clause an owner answer at
  `docs/trail/fdr/cycle-3.md` § 2.6, folded here at v6 — RN-17; SDD § 4 C-I6 as it reads at v13 — the pin reads the bridge's exports (RN-22), § 11 R-12 — the
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
(`languages/rust/testing.md` v1.0.1). For `nozoki-mac` no packet exists — the organisation's
language registry lists `javascript`, `python`, `rust`, `shell` and `typescript` (listed
2026-09-23; `docs/SDD.md` § 3, the Swift-frame paragraph) — so the resolution chain falls to the
floor for Swift (`languages/README.md` § The resolution chain, step 4; logged here as that section
requires), and its tooling is this product's own, recorded here as the doctrine asks of a product
whose language has no packet: `swift test --package-path nozoki-mac` (XCTest through Swift Package
Manager), the command the SDD's bars name (`docs/SDD.md` § 6 S-1, S-2, S-3, S-8), over
`nozoki-mac/Tests/`. What this table fixes differently from the Rust packet, and why, is RN-7. If
this table and the doctrine disagree on the layers, this table is the copy and is wrong. Through
v10 the renderer's tooling was the TypeScript packet's — Vitest, and Playwright at layer 4 — and it
leaves with `nozoki-ui` (RN-22).

| Level | Scope | Tool | Where it lives |
|---|---|---|---|
| 1 — Unit | The reducer, `ItemState` transitions, the containment check, the text rule, extension recognition, the log line shape; on the Swift side, a projection decoded from an `SM-4` buffer | `cargo test --locked` (`#[cfg(test)]` beside the module); `swift test --package-path nozoki-mac` | inside each `nozoki-core` / `nozoki-bridge` module; `nozoki-mac/Tests/` |
| 2 — Integration | `fs-reader` and `git-reader` against real fixture folders and repositories; the Markdown pipeline against `hostile.md`; `highlighter` against one fixture per floor language; the bridge's export set against its generated header; the bridge under the address sanitizer | `cargo test --locked -p nozoki-core --test git_state`, `--test root_finding`, `--test markdown`, `--test highlight`, `--test watch`; `cargo test --locked -p nozoki-bridge --test exports` | `crates/nozoki-core/tests/`, `crates/nozoki-bridge/tests/`, over `checks/fixtures/` |
| 3 — Application | `SM-4`'s function list driven in-process through `SM-5`, bypassing the shell; the whole-model switch | `checks/read-only.sh`; `cargo test --locked -p nozoki-core --test switch` | `checks/`, `crates/nozoki-core/tests/` |
| 4 — UI | A view is drawn from a projection and from nothing else, and the shell issues no call `SM-4` does not name: *pending* as the word, no marker before `observed`, the Git view empty on `plain`, the failure slot and its route, the text view `isEditable` false and registering no drop type, a *resolved* image drawn from `asset_bytes`' bytes and a placeholder from none, staged told from unstaged by text, both themes | `swift test --package-path nozoki-mac` (XCTest) | `nozoki-mac/Tests/` |
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
  `nozoki-mac`'s — the only `--test` file `nozoki-bridge` carries is `exports` (layer 2), and no
  file under `crates/*/tests/` starts the built bundle — no `CARGO_BIN_EXE_` reference there, a
  `checks/structure.sh` rule (layer 6, row 6). That placement is what makes
  `cargo test --workspace --locked` this product's change-time run (RN-7). The built bundle is
  exercised by the harness scripts and the shell gate, and the rendered UI by the timed manual
  walk, deliberately not automated (`docs/SRS.md` AC-10).
- **`checks/structure.sh` reads shipped sources, and says so once, here.** Its rules read the
  product crates' sources outside `crates/*/tests/`. Every property the script holds is about the
  process an adopter runs, and Cargo compiles each file under `tests/` "as a separate crate"
  (https://doc.rust-lang.org/cargo/reference/cargo-targets.html, read 2026-09-19), so a test
  target is never in that process. The scope binds each rule that names a crate — QC-2's *no
  write API in `nozoki-core` outside `own-state`*, QC-7's and QC-9's *no `std::process`*, QC-9's
  *no `unsafe` outside `nozoki-bridge`*, QC-13's *no `std::fs` in `nozoki-bridge` outside its log
  writer*, QC-30's and QC-58's first half, QC-61's `set_logger` rule, and every other rule of the
  script alike — and a test target may do what those rules forbid shipped code: build a fixture,
  read a config file, take an argument, install a capturing logger. **One rule reads exactly that
  path on purpose and is unchanged:** no `CARGO_BIN_EXE_` reference under `crates/*/tests/` (the
  layer-5 bullet above). **What the scope does not do, named so none of it is read as coverage:**
  a `#[cfg(test)]` module inside `src/` stays inside every rule; a crate's `build.rs`, and any
  later `benches/` or `examples/`, are not excluded; and shipped code that pulls a file from
  `tests/` in through a `#[path]` attribute would escape the rules — no grep rule is written for
  it, because the tree holds no such site to shape one against, and until one appears it is a
  review catch at `development-design` (RN-19). **`checks/view.sh` has the same scope on the Swift
  side:** it scans `nozoki-mac/Sources`, the path C-R7 names, and `nozoki-mac/Tests/` is outside
  its scan — a test may build an attributed string or read a fixture file that a surface may not.
- **Layers 6–7 are QA-role ATDD work.** No QA seat has written either for this product yet; until
  one does, layer 6 is verified by `checks/structure.sh`, `checks/entry-points.sh` and
  `checks/view.sh`, run in CI, and layer 7 by the SDD's per-slice command bars and the acceptance
  walk at release.

## 10. Verification map

A projection of every machine-checked entry above. When a row disagrees with its entry, the entry
is right and this row is stale.

| QC | Check | Command / layer | Runs over | Gated at |
|---|---|---|---|---|
| QC-1 | the shell holds no I/O of its own | `checks/view.sh`; `checks/no-network.sh` | the tree | CI build |
| QC-2 | no write under the folder | `checks/read-only.sh <fixture>`; `checks/structure.sh` | the tree | CI build; release |
| QC-3 | no network transport — the tree equals the list; the list holds no transport | `checks/no-network.sh`; the allowlist diff reviewed against the entry's domain, in the resolved features, at `development-design` | the tree; the change | CI build; `development-design` |
| QC-4 | ItemState on every read | `cargo test --locked -p nozoki-core` (layer 1); `swift test --package-path nozoki-mac` (layer 4) | the change | `development-implementation` |
| QC-5 | root finding | `cargo test --locked -p nozoki-core --test root_finding` | the change | `development-implementation` |
| QC-6 | containment check | `cargo test --locked -p nozoki-core --test markdown` | the change | `development-implementation` |
| QC-7 | no mutating Git call, no spawn | `checks/read-only.sh`; `checks/structure.sh` | the tree | CI build |
| QC-8 | `nozoki-mac` imports and dependencies | `checks/view.sh`; `checks/no-network.sh`; `swift test --package-path nozoki-mac` | the tree | CI build |
| QC-9 – QC-12, QC-14 | `nozoki-core` / `checks/` imports; no `unsafe` outside the bridge | `checks/structure.sh`; `checks/no-network.sh`; `cargo tree -p nozoki-bridge`; `cargo build --workspace --locked` | the tree | CI build |
| QC-13 | `nozoki-bridge` imports; the export set; the ABI under the sanitizer | `checks/structure.sh`; `cargo test --locked -p nozoki-bridge --test exports`; the bridge's tests under `-Zsanitizer=address` | the tree | CI build |
| QC-15, QC-17 | I/O ownership; the two composition roots | `checks/structure.sh`; `checks/view.sh` | the tree | CI build |
| QC-16 | writes only in the container | `checks/own-state.sh` | the tree | CI build; release |
| QC-19 | folder replace-whole | `cargo test --locked -p nozoki-core --test switch`; `git diff --stat … -- nozoki-mac` | the change | `development-implementation` |
| QC-20 | own-state isolation | `checks/structure.sh` | the tree | CI build |
| QC-22 | the hostile fixture as a `MarkdownDocument` | `cargo test --locked -p nozoki-core --test markdown` | the change | `development-implementation` |
| QC-23 | no web engine | `checks/view.sh`; `checks/no-network.sh` | the tree | CI build |
| QC-24 | the export set equals the header, inside `SM-4`'s list | `cargo test --locked -p nozoki-bridge --test exports` | the tree | CI build |
| QC-25 | entitlements; sandbox present | `checks/bundle.sh` | the tree | CI build; release gate |
| QC-62 | the shell runs under the shipped entitlements | `checks/renderer.sh Nozoki.app` and `checks/fixtures/idle-shell` | the tree | CI build; release gate |
| QC-26 | allowlist; locked build; no Swift dependency | `checks/no-network.sh`; `cargo build --locked` | the tree | CI build |
| QC-27 | critical vulnerability | `cargo audit` (every advisory; `--ignore <RUSTSEC-id>` with its reason) | the tree | release |
| QC-28 | no secret; no signing identity | `gitleaks git`; `gh secret list --repo kensaiapp/nozoki`; `codesign -dv Nozoki.app` | the tree; the release | CI build; release |
| QC-29 | artifact = tag build | `shasum -a 256 -c SHA256SUMS` against a rebuild | the release | release |
| QC-30, QC-58 | no other entry point; no configuration — the product's own units | `checks/structure.sh`; `checks/view.sh` | the tree | CI build |
| QC-30, QC-58 | the linked tree's environment and argument reads, against the reviewed list | `checks/entry-points.sh` against `checks/entry-points.allow` | the tree | CI build |
| QC-32 | empty egress set | AC-3 network monitor; `checks/no-network.sh` | the release; the tree | release; CI build |
| QC-34 | the shell's reach | `checks/view.sh`; `checks/no-network.sh` | the tree | CI build |
| QC-35 | the product's reach | `checks/own-state.sh`; `checks/read-only.sh` | the tree | CI build |
| QC-36 | no spawned process | `checks/structure.sh`; `checks/view.sh` | the tree | CI build |
| QC-37 | `asset_bytes` and the decoder | `cargo test --locked -p nozoki-core --test markdown`; `swift test --package-path nozoki-mac` | the change | `development-implementation` |
| QC-38 | own-state fields | `checks/own-state.sh` | the tree | CI build |
| QC-39, QC-52 | log shape and location | `cargo test --locked -p nozoki-bridge` (layer 1); `checks/own-state.sh` | the change; the tree | `development-implementation`; CI build |
| QC-40 | log bound; own-state retention | `cargo test --locked -p nozoki-bridge`, `cargo test --locked -p nozoki-core` (layer 1); `checks/own-state.sh` after `checks/churn.sh` | the change; the tree | `development-implementation`; CI build |
| QC-41 | third-party notices | `checks/notices.sh` | the release | release |
| QC-42 | private reporting; SECURITY.md | `gh api repos/kensaiapp/nozoki/private-vulnerability-reporting` | the release | release |
| QC-44 | standing sentences verbatim | `checks/readme.sh` | the release | release |
| QC-46 | latency figures | `checks/latency.sh` | the tree | CI build |
| QC-47, QC-48 | per-item degradation; churn | `cargo test --locked -p nozoki-core --test watch` with `checks/churn.sh`; `swift test --package-path nozoki-mac` (layer 4) | the change | `development-implementation` |
| QC-49 | promises through kill | `checks/read-only.sh --kill` | the tree | CI build; release |
| QC-51 | failure visible in window | `swift test --package-path nozoki-mac` (layer 4); `checks/view.sh` | the change; the tree | `development-implementation`; CI build |
| QC-53 | no internal text | `checks/strings.sh`; layer-5 error-path tests | the tree | CI build |
| QC-55 | one bundle, one process | `checks/bundle.sh` | the tree | CI build |
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
  (`crates/nozoki-app/tests/config.rs:L17`, `:L181-L188`; `tauri.conf.json:L12`), opened this run.
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
  `crates/nozoki-app/src/log_writer.rs:L142` and `crates/nozoki-core/src/` holds none (`grep -rn
  'set_logger\|set_boxed_logger' crates/`, run this fold). **The answer's addition, folded as
  written:** the same script carries rules against which the tree holds a test-target site each —
  QC-2's write rule (`crates/nozoki-core/tests/common/mod.rs:L57`), QC-7's and QC-9's
  `std::process` (`…/common/mod.rs:L11`), QC-13's `std::fs` (`crates/nozoki-app/tests/config.rs:L11`,
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
  fold, and breaks nothing:** `crates/nozoki-app/src/log_writer.rs:L201` calls `fs::write` inside
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
  no accepted record is edited beyond ADR-0003's Status line; three items await the owner and
  `Status:` is Draft *(re: header `Status:`, `Version:`, `Inputs read:`; § 1 – § 3, § 8 – § 10 as
  listed; ADR-0003, ADR-0011, ADR-0012, ADR-0013 – ADR-0016, the index; source:
  `docs/trail/architecture/cycle-8.md` §§ 2.1 – 2.3; `docs/trail/architecture/self_answer-11.md`;
  `docs/SDD.md` v13 — § 2, § 3, § 4 C-R1, C-R2, C-R3, C-R6, C-R7, C-I3, C-I6, C-D3, § 6 S-1 – S-3,
  S-7, S-8, S-10, § 9 TO-1, TO-4, TO-5, TO-6, TO-7, § 10 RC-2, RC-3, § 11 R-11, R-13, § 12, RN-53,
  RN-56, RN-59 – RN-63, Open Questions; `docs/trail/sdd/cycle-9.md` §§ 1.1, 2.3; `docs/fdr.md` v8
  — PD-29, RN-31, RN-32; `docs/trail/fdr/cycle-5.md` § 2.1; `Cargo.toml`;
  `languages/rust/testing.md` v1.0.1, `toolchain.md` v1.1.1; `languages/README.md` § The
  resolution chain; `<CORE>/doctrine/engineering/languages/` listing; the commits named)*
