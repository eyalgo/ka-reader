# ADR-0013: Nozoki is a sandboxed single-process read pipeline — one process under the App Sandbox, a Rust core reached across one closed C-ABI seam, and its promise held by the process's own entitlements

**Status:** Accepted — supersedes ADR-0001
**Date:** 2026-09-23

## Context

ADR-0001 decided the capability-split shape: two processes, the surfaces in a renderer process
holding no filesystem, network or shell capability, the closed command list between them the
promise. What moved is the ground the second process stood on. The only renderer that fit that
shape — the system WKWebView — cannot start under the wall as the owner ruled it: every WebKit XPC
service checks the *host's* entitlements at its own start, and a sandboxed host with no network
entitlement fails the check (`docs/SDD.md` § 10 RC-2; the mechanism and its WebKit sources are
ADR-0011 § Context). The owner was asked which gives way, the renderer or the rule, and answered
on 2026-09-23: **the renderer leaves WKWebView** — no network entitlement and no mach-lookup
exception; dropping the sandbox and waiting for Apple are not exits (`docs/trail/sdd/cycle-9.md`
§ 1.1, the owner's (a)).

Two facts the re-weighing added, and neither was available when ADR-0001 was written. A view that
executes nothing has nothing for a renderer wall to contain: content that reaches the view as typed
data laid out by a text engine carries no script, so the second process guarded a threat a native
view does not have. And under one process the rule covers the whole product — no process the
product runs has a network profile of its own, which was exactly the gap exit (c) opened
(`docs/SDD.md` § 10 RC-3, *Observed reality*; § SDD Review Notes RN-56, RN-60).

The forces ADR-0001 recorded stand and are restated so this record reads alone. The one rule this
product must never break is negative — nothing writes to the viewed folder, nothing connects,
nothing read from the folder is executed — and each must hold through a crash (`docs/SRS.md` § 4.2
NFR-4; § 4.3 NFR-5, NFR-6, NFR-8, NFR-16). The folder is live, untrusted input (§ 6 DR-6). A
negative invariant is not held by a guarded domain core; it is held by withholding a capability at
a boundary something outside the code enforces — and since the owner's two rulings that boundary
has a name: the process's own entitlements (`docs/SDD.md` § 2, forces 3 and 5).

## Decision

The system is a **sandboxed single-process read pipeline**. Two read-only sources — the
filesystem and, where the granted folder is itself a repository's root, that repository's Git
state — feed one in-memory folder model, and the surfaces are projections of it. Everything runs
in **one process under the App Sandbox with no network entitlement** (ADR-0011): a Rust core
(`nozoki-core`) that does all the reading, and an AppKit shell (`nozoki-mac`) that draws the
model's projections and **holds no I/O of its own** — it reads no file, opens no connection, spawns
no process, hands no URL to another program, and imports no web engine (`docs/SDD.md` § 4 C-R7).

The seam between them is **`SM-4`, one closed C-ABI function list** exported by `nozoki-bridge`:
`open_folder`, `list_tree`, `select_file`, `open_relative_link`, `set_theme`, `open_diff`,
`walk_history`, `switch_folder` and `asset_bytes` — each exported from the build in which a slice
lands it, all nine from `v1.0.0`; a `model_changed` callback carrying projection deltas; every
return an owned buffer of plain data freed by one `nozoki_free`; the header generated from the
bridge's source and never hand-kept (`docs/SDD.md` § 3 SM-4). **The seam is where the promise is
read, not where it is held.** The wall is the process's entitlements; the seam makes visible that
the shell reads through the core alone, and `checks/view.sh` shows on every build that the shell
adds no I/O of its own (C-R7) — a source scan and a link check, stated plainly as not a process
boundary.

Adding a **read surface** — a diff, a history, a folder chosen at runtime — is priced cheap. Adding
a **capability** — a write, a socket, a shell — costs a visible change to a boundary a reviewer
reads: an entitlement on the file `codesign -d --entitlements` prints, a function on `SM-4`'s list,
or a symbol on the scan's forbidden set (`docs/SDD.md` § 2, force 1; "Which side this product falls
on").

## Alternatives ruled out

- **The capability-split read pipeline** — ADR-0001's shape, held to SDD v12: the surfaces in a
  separate renderer process holding *no* capability, reached through a closed command list and one
  read-only asset scheme. The only renderer that fits refuses to start under the wall (RC-2), and a
  view that executes nothing has nothing to be walled off from, so the second process guarded a
  threat the taken shape does not carry and cost a serialized seam. It returns only if a view that
  executes content *and* starts under the rule ever exists; none is known (`docs/SDD.md` § 2, table
  row 2).
- **Hexagonal — a domain core behind ports, an adapter at every edge** — the edges are two, stable
  and owned by Apple and Git, and the core would hold a folder model and no rule; every port but one
  guards nothing. Its one useful port, the Git reader, is kept inside the taken shape (ADR-0004;
  `docs/SDD.md` § 2, table row 3).
- **Layered, one process — UI over services over a data-access layer** — the data layer's generic
  filesystem and network access is exactly the capability this product must not hold, so
  not-writing becomes discipline; fails § 1's first question by construction (`docs/SDD.md` § 2,
  table row 4).
- **Local server + browser tab — the input proposal's "web app"** — a listening socket is a network
  call during operation, which NFR-8 forbids, and a browser tab is a second thing to install
  (`docs/SDD.md` § 2, table row 7).
- Which view draws the one process — AppKit in Swift over a Rust-native toolkit, an in-process web
  engine, and AppKit through `objc2` — is ADR-0014's weighing, not this record's.

## Consequences

Easier: one entitlements file and one probe cover everything the product runs (`docs/SDD.md` § 4
C-R2, C-I3); no script engine to wall off; no serialization on every projection; the read-only and
no-network acceptance criteria (`docs/SRS.md` § 8 AC-1 – AC-3) pass because the write and the
network are *absent*, not avoided; every foreseen change is still a new read surface on the same
two sources, and the model in the middle survives every reversal below.

Harder: the renderer wall — a process that could be handed *no* capability — is gone, replaced by a
shell whose "no I/O of its own" is a source scan and a link check on every build (C-R7), with an
API the scan does not name a review catch and not a red build; a second language and one C ABI
between them (ADR-0014, ADR-0016); the bridge is the one unit that holds `unsafe`, and a misused
buffer or a panic crossing the seam is a crash inside the wall (`docs/SDD.md` § 11 R-13;
`docs/SRS.md` NFR-4).

What undoing it costs: *moving the view into a second process* costs the bridge re-wired as IPC and
nothing else — the model, the readers and the harness survive — cheap in code and blocked while the
rule stands for any view whose processes check the host's network entitlement (RC-2). *Removing the
sandbox* costs one entitlements file — and the wall, which is why its presence is checked on every
build rather than assumed (ADR-0010) (`docs/SDD.md` § 2, "Undoing it").

**What this rests on, and whose it stays.** The App Sandbox and its entitlement semantics are
Apple's and move on Apple's schedule (ADR-0011). The shape also rests, by negation, on WebKit's
entitlement check in its XPC services' launch path — the reason the two-process shape was left. If
Apple drops that check, nothing here moves on its own: the capability-split shape returns to the
SDD's § 2 table as a candidate, and choosing it again is a superseding record, not a reversal that
happens by itself. No third-party holder underwrites the shape: the seam is the platform's C calling
convention, and the wall is the operating system's.

## Traces to

- `docs/SDD.md` at v13 (`nozoki@b236e7b`, Draft) — § 2 (forces 1, 3, 5 and 6; the candidates
  table, rows 1–4 and 7; "Which side this product falls on, and why"; "Undoing it"); § 3 SM-4,
  SM-5, SM-8; § 4 C-R2, C-R7, C-I3; § 9 TO-1; § 10 RC-2, RC-3; § 12, the downstream boundary; § SDD
  Review Notes RN-56, RN-60. Read for this record while the SDD's companion held one answered item
  (§ 2.3, C-I3's wording and two record lines) awaiting a `product-sdd` fold; nothing in this record
  turns on it.
- `docs/trail/sdd/cycle-9.md` § 1.1 — the owner's (a), and the three seats' positions and the
  priced exits behind it; `docs/trail/sdd/cycle-8.md` § 5.1 — the ruling that made the question.
- ADR-0001 — the record this one supersedes; its decision is restated here whole, so nothing in
  this record depends on that one being open. Its traces stand under this record:
  `docs/SRS.md` § 4.2 NFR-4; § 4.3 NFR-5, NFR-6, NFR-8, NFR-16; § 6 DR-6; § 7 C-1; `docs/fdr.md`
  PD-1, PD-6, PD-7, PD-26, and PD-29 as it reads at FDR v8 (the view technology replaced once,
  before any release, and not again).
- ADR-0011 (the wall this shape rests on), ADR-0012 (the gate that proves the shell ran beside it),
  ADR-0014 (the view), ADR-0016 (the units).
- `docs/trail/architecture/cycle-8.md` § 2.3 — the item that raised this record as owed;
  `docs/trail/architecture/cycle-9.md` § 2.3 — the owner's confirm, given in the owner's seat by a
  `companion-self-answer` run on 2026-09-23 (its reasoning,
  `docs/trail/architecture/self_answer-12.md` § 2.3), on which this record is Accepted and
  ADR-0001 superseded. Accepted with `docs/SDD.md` at v14 (`nozoki@2739007`, Draft): v14's one
  move in § 3 — the model fills the `FileView` by calling `markdown-renderer` and `highlighter`
  (SDD RN-64) — sits inside `nozoki-core` and touches no sentence of this record.
- Inputs read for this record: SDD Draft v13 · SRS Settled v12 · FDR Settled v8.

## Binds

QC-1, QC-2, QC-8, QC-9, QC-15, QC-16, QC-24, QC-30, QC-32, QC-34.
